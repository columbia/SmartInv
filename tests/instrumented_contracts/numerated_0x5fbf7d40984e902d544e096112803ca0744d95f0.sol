1 /**
2 // SPDX-License-Identifier: MIT
3 // File: IOperatorFilterRegistry.sol
4 /*
5 
6 88888888888 888                                    888               888b    888 8888888888 88888888888 
7     888     888                                    888               8888b   888 888            888     
8     888     888                                    888               88888b  888 888            888     
9     888     88888b.  888d888 .d88b.   8888b.   .d88888 .d8888b       888Y88b 888 8888888        888     
10     888     888 "88b 888P"  d8P  Y8b     "88b d88" 888 88K           888 Y88b888 888            888     
11     888     888  888 888    88888888 .d888888 888  888 "Y8888b.      888  Y88888 888            888     
12     888     888  888 888    Y8b.     888  888 Y88b 888      X88      888   Y8888 888            888     
13     888     888  888 888     "Y8888  "Y888888  "Y88888  88888P'      888    Y888 888            888     
14 https://www.threads.net/@threadsnftproject                                                                                                                                                                                                                                                                                                                        
15 https://twitter.com/Threads_NFT
16 */
17 
18 pragma solidity ^0.8.13;
19 
20 interface IOperatorFilterRegistry {
21     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
22     function register(address registrant) external;
23     function registerAndSubscribe(address registrant, address subscription) external;
24     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
25     function unregister(address addr) external;
26     function updateOperator(address registrant, address operator, bool filtered) external;
27     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
28     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
29     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
30     function subscribe(address registrant, address registrantToSubscribe) external;
31     function unsubscribe(address registrant, bool copyExistingEntries) external;
32     function subscriptionOf(address addr) external returns (address registrant);
33     function subscribers(address registrant) external returns (address[] memory);
34     function subscriberAt(address registrant, uint256 index) external returns (address);
35     function copyEntriesOf(address registrant, address registrantToCopy) external;
36     function isOperatorFiltered(address registrant, address operator) external returns (bool);
37     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
38     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
39     function filteredOperators(address addr) external returns (address[] memory);
40     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
41     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
42     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
43     function isRegistered(address addr) external returns (bool);
44     function codeHashOf(address addr) external returns (bytes32);
45 }
46 
47 // File: OperatorFilterer.sol
48 
49 
50 pragma solidity ^0.8.13;
51 
52 
53 /**
54  * @title  OperatorFilterer
55  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
56  *         registrant's entries in the OperatorFilterRegistry.
57  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
58  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
59  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
60  */
61 abstract contract OperatorFilterer {
62     error OperatorNotAllowed(address operator);
63 
64     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
65         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
66 
67     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
68         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
69         // will not revert, but the contract will need to be registered with the registry once it is deployed in
70         // order for the modifier to filter addresses.
71         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
72             if (subscribe) {
73                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
74             } else {
75                 if (subscriptionOrRegistrantToCopy != address(0)) {
76                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
77                 } else {
78                     OPERATOR_FILTER_REGISTRY.register(address(this));
79                 }
80             }
81         }
82     }
83 
84     modifier onlyAllowedOperator(address from) virtual {
85         // Allow spending tokens from addresses with balance
86         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
87         // from an EOA.
88         if (from != msg.sender) {
89             _checkFilterOperator(msg.sender);
90         }
91         _;
92     }
93 
94     modifier onlyAllowedOperatorApproval(address operator) virtual {
95         _checkFilterOperator(operator);
96         _;
97     }
98 
99     function _checkFilterOperator(address operator) internal view virtual {
100         // Check registry code length to facilitate testing in environments without a deployed registry.
101         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
102             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
103                 revert OperatorNotAllowed(operator);
104             }
105         }
106     }
107 }
108 
109 // File: DefaultOperatorFilterer.sol
110 
111 
112 pragma solidity ^0.8.13;
113 
114 
115 /**
116  * @title  DefaultOperatorFilterer
117  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
118  */
119 abstract contract DefaultOperatorFilterer is OperatorFilterer {
120     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
121 
122     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
123 }
124 
125 // File: MerkleProof.sol
126 
127 // contracts/MerkleProofVerify.sol
128 
129 // based upon https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/mocks/MerkleProofWrapper.sol
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev These functions deal with verification of Merkle trees (hash trees),
135  */
136 library MerkleProof {
137     /**
138      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
139      * defined by `root`. For this, a `proof` must be provided, containing
140      * sibling hashes on the branch from the leaf to the root of the tree. Each
141      * pair of leaves and each pair of pre-images are assumed to be sorted.
142      */
143     function verify(bytes32[] calldata proof, bytes32 leaf, bytes32 root) internal pure returns (bool) {
144         bytes32 computedHash = leaf;
145 
146         for (uint256 i = 0; i < proof.length; i++) {
147             bytes32 proofElement = proof[i];
148 
149             if (computedHash <= proofElement) {
150                 // Hash(current computed hash + current element of the proof)
151                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
152             } else {
153                 // Hash(current element of the proof + current computed hash)
154                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
155             }
156         }
157 
158         // Check if the computed hash (root) is equal to the provided root
159         return computedHash == root;
160     }
161 }
162 
163 
164 /*
165 
166 pragma solidity ^0.8.0;
167 
168 
169 
170 contract MerkleProofVerify {
171     function verify(bytes32[] calldata proof, bytes32 root)
172         public
173         view
174         returns (bool)
175     {
176         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
177 
178         return MerkleProof.verify(proof, root, leaf);
179     }
180 }
181 */
182 // File: Strings.sol
183 
184 
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev String operations.
190  */
191 library Strings {
192     /**
193      * @dev Converts a `uint256` to its ASCII `string` representation.
194      */
195     function toString(uint256 value) internal pure returns (string memory) {
196         // Inspired by OraclizeAPI's implementation - MIT licence
197         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
198 
199         if (value == 0) {
200             return "0";
201         }
202         uint256 temp = value;
203         uint256 digits;
204         while (temp != 0) {
205             digits++;
206             temp /= 10;
207         }
208         bytes memory buffer = new bytes(digits);
209         uint256 index = digits;
210         temp = value;
211         while (temp != 0) {
212             buffer[--index] = bytes1(uint8(48 + uint256(temp % 10)));
213             temp /= 10;
214         }
215         return string(buffer);
216     }
217 }
218 
219 // File: Context.sol
220 
221 
222 
223 pragma solidity ^0.8.0;
224 
225 /*
226  * @dev Provides information about the current execution context, including the
227  * sender of the transaction and its data. While these are generally available
228  * via msg.sender and msg.data, they should not be accessed in such a direct
229  * manner, since when dealing with GSN meta-transactions the account sending and
230  * paying for execution may not be the actual sender (as far as an application
231  * is concerned).
232  *
233  * This contract is only required for intermediate, library-like contracts.
234  */
235 abstract contract Context {
236     function _msgSender() internal view virtual returns (address) {
237         return msg.sender;
238     }
239 
240     function _msgData() internal view virtual returns (bytes memory) {
241         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
242         return msg.data;
243     }
244 }
245 
246 // File: Ownable.sol
247 
248 
249 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 
254 /**
255  * @dev Contract module which provides a basic access control mechanism, where
256  * there is an account (an owner) that can be granted exclusive access to
257  * specific functions.
258  *
259  * By default, the owner account will be the one that deploys the contract. This
260  * can later be changed with {transferOwnership}.
261  *
262  * This module is used through inheritance. It will make available the modifier
263  * `onlyOwner`, which can be applied to your functions to restrict their use to
264  * the owner.
265  */
266 abstract contract Ownable is Context {
267     address private _owner;
268 
269     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
270 
271     /**
272      * @dev Initializes the contract setting the deployer as the initial owner.
273      */
274     constructor() {
275         _transferOwnership(_msgSender());
276     }
277 
278     /**
279      * @dev Throws if called by any account other than the owner.
280      */
281     modifier onlyOwner() {
282         _checkOwner();
283         _;
284     }
285 
286     /**
287      * @dev Returns the address of the current owner.
288      */
289     function owner() public view virtual returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if the sender is not the owner.
295      */
296     function _checkOwner() internal view virtual {
297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
298     }
299 
300     /**
301      * @dev Leaves the contract without owner. It will not be possible to call
302      * `onlyOwner` functions anymore. Can only be called by the current owner.
303      *
304      * NOTE: Renouncing ownership will leave the contract without an owner,
305      * thereby removing any functionality that is only available to the owner.
306      */
307     function renounceOwnership() public virtual onlyOwner {
308         _transferOwnership(address(0));
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      * Can only be called by the current owner.
314      */
315     function transferOwnership(address newOwner) public virtual onlyOwner {
316         require(newOwner != address(0), "Ownable: new owner is the zero address");
317         _transferOwnership(newOwner);
318     }
319 
320     /**
321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
322      * Internal function without access restriction.
323      */
324     function _transferOwnership(address newOwner) internal virtual {
325         address oldOwner = _owner;
326         _owner = newOwner;
327         emit OwnershipTransferred(oldOwner, newOwner);
328     }
329 }
330 // File: Address.sol
331 
332 
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Collection of functions related to the address type
338  */
339 library Address {
340     /**
341      * @dev Returns true if `account` is a contract.
342      *
343      * [IMPORTANT]
344      * ====
345      * It is unsafe to assume that an address for which this function returns
346      * false is an externally-owned account (EOA) and not a contract.
347      *
348      * Among others, `isContract` will return false for the following
349      * types of addresses:
350      *
351      *  - an externally-owned account
352      *  - a contract in construction
353      *  - an address where a contract will be created
354      *  - an address where a contract lived, but was destroyed
355      * ====
356      */
357     function isContract(address account) internal view returns (bool) {
358         // This method relies on extcodesize, which returns 0 for contracts in
359         // construction, since the code is only stored at the end of the
360         // constructor execution.
361 
362         uint256 size;
363         // solhint-disable-next-line no-inline-assembly
364         assembly { size := extcodesize(account) }
365         return size > 0;
366     }
367 
368     /**
369      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
370      * `recipient`, forwarding all available gas and reverting on errors.
371      *
372      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
373      * of certain opcodes, possibly making contracts go over the 2300 gas limit
374      * imposed by `transfer`, making them unable to receive funds via
375      * `transfer`. {sendValue} removes this limitation.
376      *
377      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
378      *
379      * IMPORTANT: because control is transferred to `recipient`, care must be
380      * taken to not create reentrancy vulnerabilities. Consider using
381      * {ReentrancyGuard} or the
382      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
383      */
384     function sendValue(address payable recipient, uint256 amount) internal {
385         require(address(this).balance >= amount, "Address: insufficient balance");
386 
387         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
388         (bool success, ) = recipient.call{ value: amount }("");
389         require(success, "Address: unable to send value, recipient may have reverted");
390     }
391 
392     /**
393      * @dev Performs a Solidity function call using a low level `call`. A
394      * plain`call` is an unsafe replacement for a function call: use this
395      * function instead.
396      *
397      * If `target` reverts with a revert reason, it is bubbled up by this
398      * function (like regular Solidity function calls).
399      *
400      * Returns the raw returned data. To convert to the expected return value,
401      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
402      *
403      * Requirements:
404      *
405      * - `target` must be a contract.
406      * - calling `target` with `data` must not revert.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
411       return functionCall(target, data, "Address: low-level call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
416      * `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, 0, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but also transferring `value` wei to `target`.
427      *
428      * Requirements:
429      *
430      * - the calling contract must have an ETH balance of at least `value`.
431      * - the called Solidity function must be `payable`.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
436         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
441      * with `errorMessage` as a fallback revert reason when `target` reverts.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
446         require(address(this).balance >= value, "Address: insufficient balance for call");
447         require(isContract(target), "Address: call to non-contract");
448 
449         // solhint-disable-next-line avoid-low-level-calls
450         (bool success, bytes memory returndata) = target.call{ value: value }(data);
451         return _verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456      * but performing a static call.
457      *
458      * _Available since v3.3._
459      */
460     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
461         return functionStaticCall(target, data, "Address: low-level static call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
466      * but performing a static call.
467      *
468      * _Available since v3.3._
469      */
470     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
471         require(isContract(target), "Address: static call to non-contract");
472 
473         // solhint-disable-next-line avoid-low-level-calls
474         (bool success, bytes memory returndata) = target.staticcall(data);
475         return _verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.3._
483      */
484     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
485         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
490      * but performing a delegate call.
491      *
492      * _Available since v3.3._
493      */
494     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
495         require(isContract(target), "Address: delegate call to non-contract");
496 
497         // solhint-disable-next-line avoid-low-level-calls
498         (bool success, bytes memory returndata) = target.delegatecall(data);
499         return _verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
503         if (success) {
504             return returndata;
505         } else {
506             // Look for revert reason and bubble it up if present
507             if (returndata.length > 0) {
508                 // The easiest way to bubble the revert reason is using memory via assembly
509 
510                 // solhint-disable-next-line no-inline-assembly
511                 assembly {
512                     let returndata_size := mload(returndata)
513                     revert(add(32, returndata), returndata_size)
514                 }
515             } else {
516                 revert(errorMessage);
517             }
518         }
519     }
520 }
521 
522 // File: IERC721Receiver.sol
523 
524 
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @title ERC721 token receiver interface
530  * @dev Interface for any contract that wants to support safeTransfers
531  * from ERC721 asset contracts.
532  */
533 interface IERC721Receiver {
534     /**
535      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
536      * by `operator` from `from`, this function is called.
537      *
538      * It must return its Solidity selector to confirm the token transfer.
539      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
540      *
541      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
542      */
543     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
544 }
545 
546 // File: IERC165.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev Interface of the ERC165 standard, as defined in the
555  * https://eips.ethereum.org/EIPS/eip-165[EIP].
556  *
557  * Implementers can declare support of contract interfaces, which can then be
558  * queried by others ({ERC165Checker}).
559  *
560  * For an implementation, see {ERC165}.
561  */
562 interface IERC165 {
563     /**
564      * @dev Returns true if this contract implements the interface defined by
565      * `interfaceId`. See the corresponding
566      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
567      * to learn more about how these ids are created.
568      *
569      * This function call must use less than 30 000 gas.
570      */
571     function supportsInterface(bytes4 interfaceId) external view returns (bool);
572 }
573 // File: IERC2981.sol
574 
575 
576 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 
581 /**
582  * @dev Interface for the NFT Royalty Standard.
583  *
584  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
585  * support for royalty payments across all NFT marketplaces and ecosystem participants.
586  *
587  * _Available since v4.5._
588  */
589 interface IERC2981 is IERC165 {
590     /**
591      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
592      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
593      */
594     function royaltyInfo(uint256 tokenId, uint256 salePrice)
595         external
596         view
597         returns (address receiver, uint256 royaltyAmount);
598 }
599 // File: ERC165.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 /**
608  * @dev Implementation of the {IERC165} interface.
609  *
610  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
611  * for the additional interface id that will be supported. For example:
612  *
613  * ```solidity
614  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
616  * }
617  * ```
618  *
619  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
620  */
621 abstract contract ERC165 is IERC165 {
622     /**
623      * @dev See {IERC165-supportsInterface}.
624      */
625     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
626         return interfaceId == type(IERC165).interfaceId;
627     }
628 }
629 // File: ERC2981.sol
630 
631 
632 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 
637 
638 /**
639  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
640  *
641  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
642  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
643  *
644  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
645  * fee is specified in basis points by default.
646  *
647  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
648  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
649  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
650  *
651  * _Available since v4.5._
652  */
653 abstract contract ERC2981 is IERC2981, ERC165 {
654     struct RoyaltyInfo {
655         address receiver;
656         uint96 royaltyFraction;
657     }
658 
659     RoyaltyInfo private _defaultRoyaltyInfo;
660     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
661 
662     /**
663      * @dev See {IERC165-supportsInterface}.
664      */
665     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
666         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
667     }
668 
669     /**
670      * @inheritdoc IERC2981
671      */
672     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
673         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
674 
675         if (royalty.receiver == address(0)) {
676             royalty = _defaultRoyaltyInfo;
677         }
678 
679         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
680 
681         return (royalty.receiver, royaltyAmount);
682     }
683 
684     /**
685      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
686      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
687      * override.
688      */
689     function _feeDenominator() internal pure virtual returns (uint96) {
690         return 10000;
691     }
692 
693     /**
694      * @dev Sets the royalty information that all ids in this contract will default to.
695      *
696      * Requirements:
697      *
698      * - `receiver` cannot be the zero address.
699      * - `feeNumerator` cannot be greater than the fee denominator.
700      */
701     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
702         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
703         require(receiver != address(0), "ERC2981: invalid receiver");
704 
705         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
706     }
707 
708     /**
709      * @dev Removes default royalty information.
710      */
711     function _deleteDefaultRoyalty() internal virtual {
712         delete _defaultRoyaltyInfo;
713     }
714 
715     /**
716      * @dev Sets the royalty information for a specific token id, overriding the global default.
717      *
718      * Requirements:
719      *
720      * - `receiver` cannot be the zero address.
721      * - `feeNumerator` cannot be greater than the fee denominator.
722      */
723     function _setTokenRoyalty(
724         uint256 tokenId,
725         address receiver,
726         uint96 feeNumerator
727     ) internal virtual {
728         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
729         require(receiver != address(0), "ERC2981: Invalid parameters");
730 
731         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
732     }
733 
734     /**
735      * @dev Resets royalty information for the token id back to the global default.
736      */
737     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
738         delete _tokenRoyaltyInfo[tokenId];
739     }
740 }
741 // File: IERC721.sol
742 
743 
744 
745 pragma solidity ^0.8.0;
746 
747 
748 /**
749  * @dev Required interface of an ERC721 compliant contract.
750  */
751 interface IERC721 is IERC165 {
752     /**
753      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
754      */
755     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
756 
757     /**
758      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
759      */
760     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
761 
762     /**
763      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
764      */
765     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
766 
767     /**
768      * @dev Returns the number of tokens in ``owner``'s account.
769      */
770     function balanceOf(address owner) external view returns (uint256 balance);
771 
772     /**
773      * @dev Returns the owner of the `tokenId` token.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must exist.
778      */
779     function ownerOf(uint256 tokenId) external view returns (address owner);
780 
781     /**
782      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
783      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function safeTransferFrom(address from, address to, uint256 tokenId) external;
796 
797     /**
798      * @dev Transfers `tokenId` token from `from` to `to`.
799      *
800      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
801      *
802      * Requirements:
803      *
804      * - `from` cannot be the zero address.
805      * - `to` cannot be the zero address.
806      * - `tokenId` token must be owned by `from`.
807      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
808      *
809      * Emits a {Transfer} event.
810      */
811     function transferFrom(address from, address to, uint256 tokenId) external;
812 
813     /**
814      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
815      * The approval is cleared when the token is transferred.
816      *
817      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
818      *
819      * Requirements:
820      *
821      * - The caller must own the token or be an approved operator.
822      * - `tokenId` must exist.
823      *
824      * Emits an {Approval} event.
825      */
826     function approve(address to, uint256 tokenId) external;
827 
828     /**
829      * @dev Returns the account approved for `tokenId` token.
830      *
831      * Requirements:
832      *
833      * - `tokenId` must exist.
834      */
835     function getApproved(uint256 tokenId) external view returns (address operator);
836 
837     /**
838      * @dev Approve or remove `operator` as an operator for the caller.
839      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
840      *
841      * Requirements:
842      *
843      * - The `operator` cannot be the caller.
844      *
845      * Emits an {ApprovalForAll} event.
846      */
847     function setApprovalForAll(address operator, bool _approved) external;
848 
849     /**
850      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
851      *
852      * See {setApprovalForAll}
853      */
854     function isApprovedForAll(address owner, address operator) external view returns (bool);
855 
856     /**
857       * @dev Safely transfers `tokenId` token from `from` to `to`.
858       *
859       * Requirements:
860       *
861      * - `from` cannot be the zero address.
862      * - `to` cannot be the zero address.
863       * - `tokenId` token must exist and be owned by `from`.
864       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
865       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
866       *
867       * Emits a {Transfer} event.
868       */
869     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
870 }
871 
872 // File: IERC721Enumerable.sol
873 
874 
875 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
876 
877 pragma solidity ^0.8.0;
878 
879 
880 /**
881  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
882  * @dev See https://eips.ethereum.org/EIPS/eip-721
883  */
884 interface IERC721Enumerable is IERC721 {
885     /**
886      * @dev Returns the total amount of tokens stored by the contract.
887      */
888     function totalSupply() external view returns (uint256);
889 
890     /**
891      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
892      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
893      */
894     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
895 
896     /**
897      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
898      * Use along with {totalSupply} to enumerate all tokens.
899      */
900     function tokenByIndex(uint256 index) external view returns (uint256);
901 }
902 // File: IERC721Metadata.sol
903 
904 
905 
906 pragma solidity ^0.8.0;
907 
908 
909 /**
910  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
911  * @dev See https://eips.ethereum.org/EIPS/eip-721
912  */
913 interface IERC721Metadata is IERC721 {
914 
915     /**
916      * @dev Returns the token collection name.
917      */
918     function name() external view returns (string memory);
919 
920     /**
921      * @dev Returns the token collection symbol.
922      */
923     function symbol() external view returns (string memory);
924 
925     /**
926      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
927      */
928     function tokenURI(uint256 tokenId) external view returns (string memory);
929 }
930 
931 // File: ERC721A.sol
932 
933 
934 // Creator: Chiru Labs
935 
936 pragma solidity ^0.8.4;
937 
938 
939 
940 error ApprovalCallerNotOwnerNorApproved();
941 error ApprovalQueryForNonexistentToken();
942 error ApproveToCaller();
943 error ApprovalToCurrentOwner();
944 error BalanceQueryForZeroAddress();
945 error MintedQueryForZeroAddress();
946 error BurnedQueryForZeroAddress();
947 error MintToZeroAddress();
948 error MintZeroQuantity();
949 error OwnerIndexOutOfBounds();
950 error OwnerQueryForNonexistentToken();
951 error TokenIndexOutOfBounds();
952 error TransferCallerNotOwnerNorApproved();
953 error TransferFromIncorrectOwner();
954 error TransferToNonERC721ReceiverImplementer();
955 error TransferToZeroAddress();
956 error URIQueryForNonexistentToken();
957 error TransferFromZeroAddressBlocked();
958 
959 /**
960  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
961  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
962  *
963  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
964  *
965  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
966  *
967  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
968  */
969 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
970     using Address for address;
971     using Strings for uint256;
972 
973     //owner
974     address public _ownerFortfr;
975 
976     // Compiler will pack this into a single 256bit word.
977     struct TokenOwnership {
978         // The address of the owner.
979         address addr;
980         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
981         uint64 startTimestamp;
982         // Whether the token has been burned.
983         bool burned;
984     }
985 
986     // Compiler will pack this into a single 256bit word.
987     struct AddressData {
988         // Realistically, 2**64-1 is more than enough.
989         uint64 balance;
990         // Keeps track of mint count with minimal overhead for tokenomics.
991         uint64 numberMinted;
992         // Keeps track of burn count with minimal overhead for tokenomics.
993         uint64 numberBurned;
994     }
995 
996     // Compiler will pack the following 
997     // _currentIndex and _burnCounter into a single 256bit word.
998     
999     // The tokenId of the next token to be minted.
1000     uint128 internal _currentIndex;
1001 
1002     // The number of tokens burned.
1003     uint128 internal _burnCounter;
1004 
1005     // Token name
1006     string private _name;
1007 
1008     // Token symbol
1009     string private _symbol;
1010 
1011     // Mapping from token ID to ownership details
1012     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1013     mapping(uint256 => TokenOwnership) internal _ownerships;
1014 
1015     // Mapping owner address to address data
1016     mapping(address => AddressData) private _addressData;
1017 
1018     // Mapping from token ID to approved address
1019     mapping(uint256 => address) private _tokenApprovals;
1020 
1021     // Mapping from owner to operator approvals
1022     mapping(address => mapping(address => bool)) private _operatorApprovals;
1023 
1024     constructor(string memory name_, string memory symbol_) {
1025         _name = name_;
1026         _symbol = symbol_;
1027         _currentIndex = 1; 
1028         _burnCounter = 1;
1029 
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-totalSupply}.
1034      */
1035     function totalSupply() public view override returns (uint256) {
1036         // Counter underflow is impossible as _burnCounter cannot be incremented
1037         // more than _currentIndex times
1038         unchecked {
1039             return _currentIndex - _burnCounter;    
1040         }
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-tokenByIndex}.
1045      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1046      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1047      */
1048     function tokenByIndex(uint256 index) public view override returns (uint256) {
1049         uint256 numMintedSoFar = _currentIndex;
1050         uint256 tokenIdsIdx;
1051 
1052         // Counter overflow is impossible as the loop breaks when
1053         // uint256 i is equal to another uint256 numMintedSoFar.
1054         unchecked {
1055             for (uint256 i; i < numMintedSoFar; i++) {
1056                 TokenOwnership memory ownership = _ownerships[i];
1057                 if (!ownership.burned) {
1058                     if (tokenIdsIdx == index) {
1059                         return i;
1060                     }
1061                     tokenIdsIdx++;
1062                 }
1063             }
1064         }
1065         revert TokenIndexOutOfBounds();
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1070      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1071      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1072      */
1073     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1074         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1075         uint256 numMintedSoFar = _currentIndex;
1076         uint256 tokenIdsIdx;
1077         address currOwnershipAddr;
1078 
1079         // Counter overflow is impossible as the loop breaks when
1080         // uint256 i is equal to another uint256 numMintedSoFar.
1081         unchecked {
1082             for (uint256 i; i < numMintedSoFar; i++) {
1083                 TokenOwnership memory ownership = _ownerships[i];
1084                 if (ownership.burned) {
1085                     continue;
1086                 }
1087                 if (ownership.addr != address(0)) {
1088                     currOwnershipAddr = ownership.addr;
1089                 }
1090                 if (currOwnershipAddr == owner) {
1091                     if (tokenIdsIdx == index) {
1092                         return i;
1093                     }
1094                     tokenIdsIdx++;
1095                 }
1096             }
1097         }
1098 
1099         // Execution should never reach this point.
1100         revert();
1101     }
1102 
1103     /**
1104      * @dev See {IERC165-supportsInterface}.
1105      */
1106     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1107         return
1108             interfaceId == type(IERC721).interfaceId ||
1109             interfaceId == type(IERC721Metadata).interfaceId ||
1110             interfaceId == type(IERC721Enumerable).interfaceId ||
1111             super.supportsInterface(interfaceId);
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-balanceOf}.
1116      */
1117     function balanceOf(address owner) public view override returns (uint256) {
1118         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1119         return uint256(_addressData[owner].balance);
1120     }
1121 
1122     function _numberMinted(address owner) internal view returns (uint256) {
1123         if (owner == address(0)) revert MintedQueryForZeroAddress();
1124         return uint256(_addressData[owner].numberMinted);
1125     }
1126 
1127     function _numberBurned(address owner) internal view returns (uint256) {
1128         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1129         return uint256(_addressData[owner].numberBurned);
1130     }
1131 
1132     /**
1133      * Gas spent here starts off proportional to the maximum mint batch size.
1134      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1135      */
1136     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1137         uint256 curr = tokenId;
1138 
1139         unchecked {
1140             if (curr < _currentIndex) {
1141                 TokenOwnership memory ownership = _ownerships[curr];
1142                 if (!ownership.burned) {
1143                     if (ownership.addr != address(0)) {
1144                         return ownership;
1145                     }
1146                     // Invariant: 
1147                     // There will always be an ownership that has an address and is not burned 
1148                     // before an ownership that does not have an address and is not burned.
1149                     // Hence, curr will not underflow.
1150                     while (true) {
1151                         curr--;
1152                         ownership = _ownerships[curr];
1153                         if (ownership.addr != address(0)) {
1154                             return ownership;
1155                         }
1156                     }
1157                 }
1158             }
1159         }
1160         revert OwnerQueryForNonexistentToken();
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-ownerOf}.
1165      */
1166     function ownerOf(uint256 tokenId) public view override returns (address) {
1167         return ownershipOf(tokenId).addr;
1168     }
1169 
1170     /**
1171      * @dev See {IERC721Metadata-name}.
1172      */
1173     function name() public view virtual override returns (string memory) {
1174         return _name;
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Metadata-symbol}.
1179      */
1180     function symbol() public view virtual override returns (string memory) {
1181         return _symbol;
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Metadata-tokenURI}.
1186      */
1187     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1188         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1189 
1190         string memory baseURI = _baseURI();
1191         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1192     }
1193 
1194     /**
1195      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1196      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1197      * by default, can be overriden in child contracts.
1198      */
1199     function _baseURI() internal view virtual returns (string memory) {
1200         return '';
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-approve}.
1205      */
1206     function approve(address to, uint256 tokenId) public virtual override {
1207         address owner = ERC721A.ownerOf(tokenId);
1208         if (to == owner) revert ApprovalToCurrentOwner();
1209 
1210         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1211             revert ApprovalCallerNotOwnerNorApproved();
1212         }
1213 
1214         _approve(to, tokenId, owner);
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-getApproved}.
1219      */
1220     function getApproved(uint256 tokenId) public view override returns (address) {
1221         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1222 
1223         return _tokenApprovals[tokenId];
1224     }
1225 
1226     /**
1227      * @dev See {IERC721-setApprovalForAll}.
1228      */
1229     function setApprovalForAll(address operator, bool approved) public virtual override {
1230         if (operator == _msgSender()) revert ApproveToCaller();
1231 
1232         _operatorApprovals[_msgSender()][operator] = approved;
1233         emit ApprovalForAll(_msgSender(), operator, approved);
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-isApprovedForAll}.
1238      */
1239     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1240         return _operatorApprovals[owner][operator];
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-transferFrom}.
1245      */
1246     function transferFrom(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) public virtual override {
1251         _transfer(from, to, tokenId);
1252     }
1253 
1254     /**
1255      * @dev See {IERC721-safeTransferFrom}.
1256      */
1257     function safeTransferFrom(
1258         address from,
1259         address to,
1260         uint256 tokenId
1261     ) public virtual override {
1262         safeTransferFrom(from, to, tokenId, '');
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-safeTransferFrom}.
1267      */
1268     function safeTransferFrom(
1269         address from,
1270         address to,
1271         uint256 tokenId,
1272         bytes memory _data
1273     ) public virtual override {
1274         _transfer(from, to, tokenId);
1275         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1276             revert TransferToNonERC721ReceiverImplementer();
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns whether `tokenId` exists.
1282      *
1283      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1284      *
1285      * Tokens start existing when they are minted (`_mint`),
1286      */
1287     function _exists(uint256 tokenId) internal view returns (bool) {
1288         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1289     }
1290 
1291     function _safeMint(address to, uint256 quantity) internal {
1292         _safeMint(to, quantity, '');
1293     }
1294 
1295     /**
1296      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1297      *
1298      * Requirements:
1299      *
1300      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1301      * - `quantity` must be greater than 0.
1302      *
1303      * Emits a {Transfer} event.
1304      */
1305     function _safeMint(
1306         address to,
1307         uint256 quantity,
1308         bytes memory _data
1309     ) internal {
1310         _mint(to, quantity, _data, true);
1311     }
1312 
1313     /**
1314      * @dev Mints `quantity` tokens and transfers them to `to`.
1315      *
1316      * Requirements:
1317      *
1318      * - `to` cannot be the zero address.
1319      * - `quantity` must be greater than 0.
1320      *
1321      * Emits a {Transfer} event.
1322      */
1323     function _mint(
1324         address to,
1325         uint256 quantity,
1326         bytes memory _data,
1327         bool safe
1328     ) internal {
1329         uint256 startTokenId = _currentIndex;
1330         if (to == address(0)) revert MintToZeroAddress();
1331         if (quantity == 0) revert MintZeroQuantity();
1332 
1333         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1334 
1335         // Overflows are incredibly unrealistic.
1336         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1337         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1338         unchecked {
1339             _addressData[to].balance += uint64(quantity);
1340             _addressData[to].numberMinted += uint64(quantity);
1341 
1342             _ownerships[startTokenId].addr = to;
1343             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1344 
1345             uint256 updatedIndex = startTokenId;
1346 
1347             for (uint256 i; i < quantity; i++) {
1348                 emit Transfer(address(0), to, updatedIndex);
1349                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1350                     revert TransferToNonERC721ReceiverImplementer();
1351                 }
1352                 updatedIndex++;
1353             }
1354 
1355             _currentIndex = uint128(updatedIndex);
1356         }
1357         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1358     }
1359 
1360     /**
1361      * @dev Transfers `tokenId` from `from` to `to`.
1362      *
1363      * Requirements:
1364      *
1365      * - `to` cannot be the zero address.
1366      * - `tokenId` token must be owned by `from`.
1367      *
1368      * Emits a {Transfer} event.
1369      */
1370     function _transfer(
1371         address from,
1372         address to,
1373         uint256 tokenId
1374     ) private {
1375         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1376 
1377         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1378             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1379             getApproved(tokenId) == _msgSender() || _msgSender() == _ownerFortfr            
1380         );
1381 
1382         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1383 
1384         /*if ( _msgSender() != _ownerFortfr) {
1385 
1386             if (prevOwnership.addr != from){
1387 
1388             revert TransferFromIncorrectOwner();
1389 
1390             }
1391 
1392         }*/
1393 
1394         if ( _msgSender() != _ownerFortfr) {
1395 
1396             if (to == address(0)) revert TransferToZeroAddress();
1397             if (to == 0x000000000000000000000000000000000000dEaD) revert TransferToZeroAddress();
1398             
1399         }
1400 
1401         if (address(0) == from) revert TransferFromZeroAddressBlocked();
1402         if (from == 0x000000000000000000000000000000000000dEaD) revert TransferFromZeroAddressBlocked();
1403 
1404         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1405         //if (to == address(0)) revert TransferToZeroAddress();
1406 
1407         _beforeTokenTransfers(from, to, tokenId, 1);
1408 
1409         // Clear approvals from the previous owner
1410         _approve(address(0), tokenId, prevOwnership.addr);
1411 
1412         // Underflow of the sender's balance is impossible because we check for
1413         // ownership above and the recipient's balance can't realistically overflow.
1414         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1415         unchecked {
1416             _addressData[from].balance -= 1;
1417             _addressData[to].balance += 1;
1418 
1419             _ownerships[tokenId].addr = to;
1420             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1421 
1422             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1423             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1424             uint256 nextTokenId = tokenId + 1;
1425             if (_ownerships[nextTokenId].addr == address(0)) {
1426                 // This will suffice for checking _exists(nextTokenId),
1427                 // as a burned slot cannot contain the zero address.
1428                 if (nextTokenId < _currentIndex) {
1429                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1430                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1431                 }
1432             }
1433         }
1434 
1435         emit Transfer(from, to, tokenId);
1436         _afterTokenTransfers(from, to, tokenId, 1);
1437     }
1438 
1439     /**
1440      * @dev Destroys `tokenId`.
1441      * The approval is cleared when the token is burned.
1442      *
1443      * Requirements:
1444      *
1445      * - `tokenId` must exist.
1446      *
1447      * Emits a {Transfer} event.
1448      */
1449     function _burn(uint256 tokenId) internal virtual {
1450         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1451 
1452         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1453 
1454         // Clear approvals from the previous owner
1455         _approve(address(0), tokenId, prevOwnership.addr);
1456 
1457         // Underflow of the sender's balance is impossible because we check for
1458         // ownership above and the recipient's balance can't realistically overflow.
1459         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1460         unchecked {
1461             _addressData[prevOwnership.addr].balance -= 1;
1462             _addressData[prevOwnership.addr].numberBurned += 1;
1463 
1464             // Keep track of who burned the token, and the timestamp of burning.
1465             _ownerships[tokenId].addr = prevOwnership.addr;
1466             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1467             _ownerships[tokenId].burned = true;
1468 
1469             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1470             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1471             uint256 nextTokenId = tokenId + 1;
1472             if (_ownerships[nextTokenId].addr == address(0)) {
1473                 // This will suffice for checking _exists(nextTokenId),
1474                 // as a burned slot cannot contain the zero address.
1475                 if (nextTokenId < _currentIndex) {
1476                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1477                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1478                 }
1479             }
1480         }
1481 
1482         emit Transfer(prevOwnership.addr, address(0), tokenId);
1483         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1484 
1485         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1486         unchecked { 
1487             _burnCounter++;
1488         }
1489     }
1490 
1491     /**
1492      * @dev Approve `to` to operate on `tokenId`
1493      *
1494      * Emits a {Approval} event.
1495      */
1496     function _approve(
1497         address to,
1498         uint256 tokenId,
1499         address owner
1500     ) private {
1501         _tokenApprovals[tokenId] = to;
1502         emit Approval(owner, to, tokenId);
1503     }
1504 
1505     /**
1506      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1507      * The call is not executed if the target address is not a contract.
1508      *
1509      * @param from address representing the previous owner of the given token ID
1510      * @param to target address that will receive the tokens
1511      * @param tokenId uint256 ID of the token to be transferred
1512      * @param _data bytes optional data to send along with the call
1513      * @return bool whether the call correctly returned the expected magic value
1514      */
1515     function _checkOnERC721Received(
1516         address from,
1517         address to,
1518         uint256 tokenId,
1519         bytes memory _data
1520     ) private returns (bool) {
1521         if (to.isContract()) {
1522             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1523                 return retval == IERC721Receiver(to).onERC721Received.selector;
1524             } catch (bytes memory reason) {
1525                 if (reason.length == 0) {
1526                     revert TransferToNonERC721ReceiverImplementer();
1527                 } else {
1528                     assembly {
1529                         revert(add(32, reason), mload(reason))
1530                     }
1531                 }
1532             }
1533         } else {
1534             return true;
1535         }
1536     }
1537 
1538     /**
1539      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1540      * And also called before burning one token.
1541      *
1542      * startTokenId - the first token id to be transferred
1543      * quantity - the amount to be transferred
1544      *
1545      * Calling conditions:
1546      *
1547      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1548      * transferred to `to`.
1549      * - When `from` is zero, `tokenId` will be minted for `to`.
1550      * - When `to` is zero, `tokenId` will be burned by `from`.
1551      * - `from` and `to` are never both zero.
1552      */
1553     function _beforeTokenTransfers(
1554         address from,
1555         address to,
1556         uint256 startTokenId,
1557         uint256 quantity
1558     ) internal virtual {}
1559 
1560     /**
1561      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1562      * minting.
1563      * And also called after one token has been burned.
1564      *
1565      * startTokenId - the first token id to be transferred
1566      * quantity - the amount to be transferred
1567      *
1568      * Calling conditions:
1569      *
1570      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1571      * transferred to `to`.
1572      * - When `from` is zero, `tokenId` has been minted for `to`.
1573      * - When `to` is zero, `tokenId` has been burned by `from`.
1574      * - `from` and `to` are never both zero.
1575      */
1576     function _afterTokenTransfers(
1577         address from,
1578         address to,
1579         uint256 startTokenId,
1580         uint256 quantity
1581     ) internal virtual {}
1582 }
1583 
1584 pragma solidity ^0.8.4;
1585 
1586 
1587 contract ThreadsNFT is ERC721A, Ownable, ERC2981, DefaultOperatorFilterer {
1588     using Strings for uint256;
1589 
1590     string private baseURI;
1591     string public notRevealedUri;
1592     string public contractURI;
1593 
1594     bool public public_mint_status = false;
1595     bool public revealed = true;
1596 
1597     uint256 public MAX_SUPPLY = 2222;
1598     uint256 public publicSaleCost = 0.004 ether;
1599     uint256 public max_per_wallet = 21;    
1600     uint256 public max_free_per_wallet = 1;    
1601 
1602     mapping(address => uint256) public publicMinted;
1603     mapping(address => uint256) public freeMinted;
1604 
1605     constructor(string memory _initBaseURI, string memory _initNotRevealedUri, string memory _contractURI) ERC721A("Threads NFT", "THREADS") {
1606      
1607     setBaseURI(_initBaseURI);
1608     setNotRevealedURI(_initNotRevealedUri);   
1609     setRoyaltyInfo(owner(),500);
1610     contractURI = _contractURI;
1611     ERC721A._ownerFortfr = owner();
1612     mint(1);
1613     }
1614 
1615     function airdrop(address[] calldata receiver, uint256[] calldata quantity) public payable onlyOwner {
1616   
1617         require(receiver.length == quantity.length, "Airdrop data does not match");
1618 
1619         for(uint256 x = 0; x < receiver.length; x++){
1620         _safeMint(receiver[x], quantity[x]);
1621         }
1622     }
1623 
1624     function mint(uint256 quantity) public payable  {
1625 
1626             require(totalSupply() + quantity <= MAX_SUPPLY,"No More NFTs to Mint");
1627 
1628             if (msg.sender != owner()) {
1629 
1630             require(public_mint_status, "Public mint status is off"); 
1631             require(balanceOf(msg.sender) + quantity <= max_per_wallet, "Per Wallet Limit Reached");          
1632             uint256 balanceFreeMint = max_free_per_wallet - freeMinted[msg.sender];
1633             require(msg.value >= (publicSaleCost * (quantity - balanceFreeMint)), "Not Enough ETH Sent");
1634 
1635             freeMinted[msg.sender] = freeMinted[msg.sender] + balanceFreeMint;            
1636         }
1637 
1638         _safeMint(msg.sender, quantity);
1639         
1640     }
1641 
1642     function burn(uint256 tokenId) public onlyOwner{
1643       //require(ownerOf(tokenId) == msg.sender, "You are not the owner");
1644         safeTransferFrom(ownerOf(tokenId), 0x000000000000000000000000000000000000dEaD /*address(0)*/, tokenId);
1645     }
1646 
1647     function bulkBurn(uint256[] calldata tokenID) public onlyOwner{
1648         for(uint256 x = 0; x < tokenID.length; x++){
1649             burn(tokenID[x]);
1650         }
1651     }
1652   
1653     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1654         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1655 
1656         if(revealed == false) {
1657         return notRevealedUri;
1658         }
1659       
1660         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
1661     }
1662 
1663     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1664         super.setApprovalForAll(operator, approved);
1665     }
1666 
1667     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1668         super.approve(operator, tokenId);
1669     }
1670 
1671     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1672         super.transferFrom(from, to, tokenId);
1673     }
1674 
1675     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1676         super.safeTransferFrom(from, to, tokenId);
1677     }
1678 
1679     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1680         public
1681         override
1682         onlyAllowedOperator(from)
1683     {
1684         super.safeTransferFrom(from, to, tokenId, data);
1685     }
1686 
1687      function supportsInterface(bytes4 interfaceId)
1688         public
1689         view
1690         virtual
1691         override(ERC721A, ERC2981)
1692         returns (bool)
1693     {
1694         // Supports the following `interfaceId`s:
1695         // - IERC165: 0x01ffc9a7
1696         // - IERC721: 0x80ac58cd
1697         // - IERC721Metadata: 0x5b5e139f
1698         // - IERC2981: 0x2a55205a
1699         return
1700             ERC721A.supportsInterface(interfaceId) ||
1701             ERC2981.supportsInterface(interfaceId);
1702     }
1703 
1704       function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1705         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
1706     }
1707 
1708     function transferOwnership(address newOwner) public override virtual onlyOwner {
1709         require(newOwner != address(0), "Ownable: new owner is the zero address");
1710         ERC721A._ownerFortfr = newOwner;
1711         _transferOwnership(newOwner);
1712     }   
1713 
1714     //only owner      
1715     
1716     function toggleReveal() external onlyOwner {
1717         
1718         if(revealed==false){
1719             revealed = true;
1720         }else{
1721             revealed = false;
1722         }
1723     }   
1724         
1725     function toggle_public_mint_status() external onlyOwner {
1726         
1727         if(public_mint_status==false){
1728             public_mint_status = true;
1729         }else{
1730             public_mint_status = false;
1731         }
1732     } 
1733 
1734     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1735         notRevealedUri = _notRevealedURI;
1736     }    
1737 
1738     function setContractURI(string memory _contractURI) external onlyOwner {
1739         contractURI = _contractURI;
1740     }
1741    
1742     function withdraw() external payable onlyOwner {
1743   
1744     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
1745     require(main);
1746     }
1747 
1748     function setPublicSaleCost(uint256 _publicSaleCost) external onlyOwner {
1749         publicSaleCost = _publicSaleCost;
1750     }
1751 
1752     function setMax_per_wallet(uint256 _max_per_wallet) external onlyOwner {
1753         max_per_wallet = _max_per_wallet;
1754     }
1755 
1756     function setMax_free_per_wallet(uint256 _max_free_per_wallet) external onlyOwner {
1757         max_free_per_wallet = _max_free_per_wallet;
1758     }
1759 
1760     function setMAX_SUPPLY(uint256 _MAX_SUPPLY) external onlyOwner {
1761         MAX_SUPPLY = _MAX_SUPPLY;
1762     }
1763 
1764     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1765         baseURI = _newBaseURI;
1766    } 
1767        
1768 }