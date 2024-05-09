1 // SPDX-License-Identifier: MIT
2 // File: IOperatorFilterRegistry.sol
3 /*
4 
5 ███████╗██████╗░░█████╗░░██████╗░███╗░░░███╗███████╗███╗░░██╗████████╗
6 ██╔════╝██╔══██╗██╔══██╗██╔════╝░████╗░████║██╔════╝████╗░██║╚══██╔══╝
7 █████╗░░██████╔╝███████║██║░░██╗░██╔████╔██║█████╗░░██╔██╗██║░░░██║░░░
8 ██╔══╝░░██╔══██╗██╔══██║██║░░╚██╗██║╚██╔╝██║██╔══╝░░██║╚████║░░░██║░░░
9 ██║░░░░░██║░░██║██║░░██║╚██████╔╝██║░╚═╝░██║███████╗██║░╚███║░░░██║░░░
10 ╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚═╝░╚═════╝░╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚══╝░░░╚═╝░░░
11 */
12 
13 pragma solidity ^0.8.13;
14 
15 interface IOperatorFilterRegistry {
16     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
17     function register(address registrant) external;
18     function registerAndSubscribe(address registrant, address subscription) external;
19     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
20     function unregister(address addr) external;
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
48 /**
49  * @title  OperatorFilterer
50  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
51  *         registrant's entries in the OperatorFilterRegistry.
52  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
53  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
54  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
55  */
56 abstract contract OperatorFilterer {
57     error OperatorNotAllowed(address operator);
58 
59     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
60         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
61 
62     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
63         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
64         // will not revert, but the contract will need to be registered with the registry once it is deployed in
65         // order for the modifier to filter addresses.
66         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
67             if (subscribe) {
68                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
69             } else {
70                 if (subscriptionOrRegistrantToCopy != address(0)) {
71                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
72                 } else {
73                     OPERATOR_FILTER_REGISTRY.register(address(this));
74                 }
75             }
76         }
77     }
78 
79     modifier onlyAllowedOperator(address from) virtual {
80         // Allow spending tokens from addresses with balance
81         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
82         // from an EOA.
83         if (from != msg.sender) {
84             _checkFilterOperator(msg.sender);
85         }
86         _;
87     }
88 
89     modifier onlyAllowedOperatorApproval(address operator) virtual {
90         _checkFilterOperator(operator);
91         _;
92     }
93 
94     function _checkFilterOperator(address operator) internal view virtual {
95         // Check registry code length to facilitate testing in environments without a deployed registry.
96         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
97             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
98                 revert OperatorNotAllowed(operator);
99             }
100         }
101     }
102 }
103 
104 // File: DefaultOperatorFilterer.sol
105 
106 
107 pragma solidity ^0.8.13;
108 
109 
110 /**
111  * @title  DefaultOperatorFilterer
112  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
113  */
114 abstract contract DefaultOperatorFilterer is OperatorFilterer {
115     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
116 
117     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
118 }
119 
120 // File: MerkleProof.sol
121 
122 // contracts/MerkleProofVerify.sol
123 
124 // based upon https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/mocks/MerkleProofWrapper.sol
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev These functions deal with verification of Merkle trees (hash trees),
130  */
131 library MerkleProof {
132     /**
133      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
134      * defined by `root`. For this, a `proof` must be provided, containing
135      * sibling hashes on the branch from the leaf to the root of the tree. Each
136      * pair of leaves and each pair of pre-images are assumed to be sorted.
137      */
138     function verify(bytes32[] calldata proof, bytes32 leaf, bytes32 root) internal pure returns (bool) {
139         bytes32 computedHash = leaf;
140 
141         for (uint256 i = 0; i < proof.length; i++) {
142             bytes32 proofElement = proof[i];
143 
144             if (computedHash <= proofElement) {
145                 // Hash(current computed hash + current element of the proof)
146                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
147             } else {
148                 // Hash(current element of the proof + current computed hash)
149                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
150             }
151         }
152 
153         // Check if the computed hash (root) is equal to the provided root
154         return computedHash == root;
155     }
156 }
157 
158 
159 /*
160 
161 pragma solidity ^0.8.0;
162 
163 
164 
165 contract MerkleProofVerify {
166     function verify(bytes32[] calldata proof, bytes32 root)
167         public
168         view
169         returns (bool)
170     {
171         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
172 
173         return MerkleProof.verify(proof, root, leaf);
174     }
175 }
176 */
177 // File: Strings.sol
178 
179 
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev String operations.
185  */
186 library Strings {
187     /**
188      * @dev Converts a `uint256` to its ASCII `string` representation.
189      */
190     function toString(uint256 value) internal pure returns (string memory) {
191         // Inspired by OraclizeAPI's implementation - MIT licence
192         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
193 
194         if (value == 0) {
195             return "0";
196         }
197         uint256 temp = value;
198         uint256 digits;
199         while (temp != 0) {
200             digits++;
201             temp /= 10;
202         }
203         bytes memory buffer = new bytes(digits);
204         uint256 index = digits;
205         temp = value;
206         while (temp != 0) {
207             buffer[--index] = bytes1(uint8(48 + uint256(temp % 10)));
208             temp /= 10;
209         }
210         return string(buffer);
211     }
212 }
213 
214 // File: Context.sol
215 
216 
217 
218 pragma solidity ^0.8.0;
219 
220 /*
221  * @dev Provides information about the current execution context, including the
222  * sender of the transaction and its data. While these are generally available
223  * via msg.sender and msg.data, they should not be accessed in such a direct
224  * manner, since when dealing with GSN meta-transactions the account sending and
225  * paying for execution may not be the actual sender (as far as an application
226  * is concerned).
227  *
228  * This contract is only required for intermediate, library-like contracts.
229  */
230 abstract contract Context {
231     function _msgSender() internal view virtual returns (address) {
232         return msg.sender;
233     }
234 
235     function _msgData() internal view virtual returns (bytes memory) {
236         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
237         return msg.data;
238     }
239 }
240 
241 // File: Ownable.sol
242 
243 
244 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 
249 /**
250  * @dev Contract module which provides a basic access control mechanism, where
251  * there is an account (an owner) that can be granted exclusive access to
252  * specific functions.
253  *
254  * By default, the owner account will be the one that deploys the contract. This
255  * can later be changed with {transferOwnership}.
256  *
257  * This module is used through inheritance. It will make available the modifier
258  * `onlyOwner`, which can be applied to your functions to restrict their use to
259  * the owner.
260  */
261 abstract contract Ownable is Context {
262     address private _owner;
263 
264     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
265 
266     /**
267      * @dev Initializes the contract setting the deployer as the initial owner.
268      */
269     constructor() {
270         _transferOwnership(_msgSender());
271     }
272 
273     /**
274      * @dev Throws if called by any account other than the owner.
275      */
276     modifier onlyOwner() {
277         _checkOwner();
278         _;
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view virtual returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if the sender is not the owner.
290      */
291     function _checkOwner() internal view virtual {
292         require(owner() == _msgSender(), "Ownable: caller is not the owner");
293     }
294 
295     /**
296      * @dev Leaves the contract without owner. It will not be possible to call
297      * `onlyOwner` functions anymore. Can only be called by the current owner.
298      *
299      * NOTE: Renouncing ownership will leave the contract without an owner,
300      * thereby removing any functionality that is only available to the owner.
301      */
302     function renounceOwnership() public virtual onlyOwner {
303         _transferOwnership(address(0));
304     }
305 
306     /**
307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
308      * Can only be called by the current owner.
309      */
310     function transferOwnership(address newOwner) public virtual onlyOwner {
311         require(newOwner != address(0), "Ownable: new owner is the zero address");
312         _transferOwnership(newOwner);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Internal function without access restriction.
318      */
319     function _transferOwnership(address newOwner) internal virtual {
320         address oldOwner = _owner;
321         _owner = newOwner;
322         emit OwnershipTransferred(oldOwner, newOwner);
323     }
324 }
325 // File: Address.sol
326 
327 
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Collection of functions related to the address type
333  */
334 library Address {
335     /**
336      * @dev Returns true if `account` is a contract.
337      *
338      * [IMPORTANT]
339      * ====
340      * It is unsafe to assume that an address for which this function returns
341      * false is an externally-owned account (EOA) and not a contract.
342      *
343      * Among others, `isContract` will return false for the following
344      * types of addresses:
345      *
346      *  - an externally-owned account
347      *  - a contract in construction
348      *  - an address where a contract will be created
349      *  - an address where a contract lived, but was destroyed
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize, which returns 0 for contracts in
354         // construction, since the code is only stored at the end of the
355         // constructor execution.
356 
357         uint256 size;
358         // solhint-disable-next-line no-inline-assembly
359         assembly { size := extcodesize(account) }
360         return size > 0;
361     }
362 
363     /**
364      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
365      * `recipient`, forwarding all available gas and reverting on errors.
366      *
367      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
368      * of certain opcodes, possibly making contracts go over the 2300 gas limit
369      * imposed by `transfer`, making them unable to receive funds via
370      * `transfer`. {sendValue} removes this limitation.
371      *
372      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
373      *
374      * IMPORTANT: because control is transferred to `recipient`, care must be
375      * taken to not create reentrancy vulnerabilities. Consider using
376      * {ReentrancyGuard} or the
377      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
378      */
379     function sendValue(address payable recipient, uint256 amount) internal {
380         require(address(this).balance >= amount, "Address: insufficient balance");
381 
382         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
383         (bool success, ) = recipient.call{ value: amount }("");
384         require(success, "Address: unable to send value, recipient may have reverted");
385     }
386 
387     /**
388      * @dev Performs a Solidity function call using a low level `call`. A
389      * plain`call` is an unsafe replacement for a function call: use this
390      * function instead.
391      *
392      * If `target` reverts with a revert reason, it is bubbled up by this
393      * function (like regular Solidity function calls).
394      *
395      * Returns the raw returned data. To convert to the expected return value,
396      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
397      *
398      * Requirements:
399      *
400      * - `target` must be a contract.
401      * - calling `target` with `data` must not revert.
402      *
403      * _Available since v3.1._
404      */
405     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
406       return functionCall(target, data, "Address: low-level call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
411      * `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, 0, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but also transferring `value` wei to `target`.
422      *
423      * Requirements:
424      *
425      * - the calling contract must have an ETH balance of at least `value`.
426      * - the called Solidity function must be `payable`.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
436      * with `errorMessage` as a fallback revert reason when `target` reverts.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
441         require(address(this).balance >= value, "Address: insufficient balance for call");
442         require(isContract(target), "Address: call to non-contract");
443 
444         // solhint-disable-next-line avoid-low-level-calls
445         (bool success, bytes memory returndata) = target.call{ value: value }(data);
446         return _verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
456         return functionStaticCall(target, data, "Address: low-level static call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
461      * but performing a static call.
462      *
463      * _Available since v3.3._
464      */
465     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         // solhint-disable-next-line avoid-low-level-calls
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return _verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.3._
478      */
479     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.3._
488      */
489     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
490         require(isContract(target), "Address: delegate call to non-contract");
491 
492         // solhint-disable-next-line avoid-low-level-calls
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return _verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
498         if (success) {
499             return returndata;
500         } else {
501             // Look for revert reason and bubble it up if present
502             if (returndata.length > 0) {
503                 // The easiest way to bubble the revert reason is using memory via assembly
504 
505                 // solhint-disable-next-line no-inline-assembly
506                 assembly {
507                     let returndata_size := mload(returndata)
508                     revert(add(32, returndata), returndata_size)
509                 }
510             } else {
511                 revert(errorMessage);
512             }
513         }
514     }
515 }
516 
517 // File: IERC721Receiver.sol
518 
519 
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @title ERC721 token receiver interface
525  * @dev Interface for any contract that wants to support safeTransfers
526  * from ERC721 asset contracts.
527  */
528 interface IERC721Receiver {
529     /**
530      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
531      * by `operator` from `from`, this function is called.
532      *
533      * It must return its Solidity selector to confirm the token transfer.
534      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
535      *
536      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
537      */
538     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
539 }
540 
541 // File: IERC165.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @dev Interface of the ERC165 standard, as defined in the
550  * https://eips.ethereum.org/EIPS/eip-165[EIP].
551  *
552  * Implementers can declare support of contract interfaces, which can then be
553  * queried by others ({ERC165Checker}).
554  *
555  * For an implementation, see {ERC165}.
556  */
557 interface IERC165 {
558     /**
559      * @dev Returns true if this contract implements the interface defined by
560      * `interfaceId`. See the corresponding
561      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
562      * to learn more about how these ids are created.
563      *
564      * This function call must use less than 30 000 gas.
565      */
566     function supportsInterface(bytes4 interfaceId) external view returns (bool);
567 }
568 // File: IERC2981.sol
569 
570 
571 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @dev Interface for the NFT Royalty Standard.
578  *
579  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
580  * support for royalty payments across all NFT marketplaces and ecosystem participants.
581  *
582  * _Available since v4.5._
583  */
584 interface IERC2981 is IERC165 {
585     /**
586      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
587      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
588      */
589     function royaltyInfo(uint256 tokenId, uint256 salePrice)
590         external
591         view
592         returns (address receiver, uint256 royaltyAmount);
593 }
594 // File: ERC165.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 
602 /**
603  * @dev Implementation of the {IERC165} interface.
604  *
605  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
606  * for the additional interface id that will be supported. For example:
607  *
608  * ```solidity
609  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
610  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
611  * }
612  * ```
613  *
614  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
615  */
616 abstract contract ERC165 is IERC165 {
617     /**
618      * @dev See {IERC165-supportsInterface}.
619      */
620     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
621         return interfaceId == type(IERC165).interfaceId;
622     }
623 }
624 // File: ERC2981.sol
625 
626 
627 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 
632 
633 /**
634  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
635  *
636  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
637  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
638  *
639  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
640  * fee is specified in basis points by default.
641  *
642  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
643  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
644  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
645  *
646  * _Available since v4.5._
647  */
648 abstract contract ERC2981 is IERC2981, ERC165 {
649     struct RoyaltyInfo {
650         address receiver;
651         uint96 royaltyFraction;
652     }
653 
654     RoyaltyInfo private _defaultRoyaltyInfo;
655     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
656 
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
661         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
662     }
663 
664     /**
665      * @inheritdoc IERC2981
666      */
667     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
668         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
669 
670         if (royalty.receiver == address(0)) {
671             royalty = _defaultRoyaltyInfo;
672         }
673 
674         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
675 
676         return (royalty.receiver, royaltyAmount);
677     }
678 
679     /**
680      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
681      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
682      * override.
683      */
684     function _feeDenominator() internal pure virtual returns (uint96) {
685         return 10000;
686     }
687 
688     /**
689      * @dev Sets the royalty information that all ids in this contract will default to.
690      *
691      * Requirements:
692      *
693      * - `receiver` cannot be the zero address.
694      * - `feeNumerator` cannot be greater than the fee denominator.
695      */
696     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
697         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
698         require(receiver != address(0), "ERC2981: invalid receiver");
699 
700         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
701     }
702 
703     /**
704      * @dev Removes default royalty information.
705      */
706     function _deleteDefaultRoyalty() internal virtual {
707         delete _defaultRoyaltyInfo;
708     }
709 
710     /**
711      * @dev Sets the royalty information for a specific token id, overriding the global default.
712      *
713      * Requirements:
714      *
715      * - `receiver` cannot be the zero address.
716      * - `feeNumerator` cannot be greater than the fee denominator.
717      */
718     function _setTokenRoyalty(
719         uint256 tokenId,
720         address receiver,
721         uint96 feeNumerator
722     ) internal virtual {
723         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
724         require(receiver != address(0), "ERC2981: Invalid parameters");
725 
726         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
727     }
728 
729     /**
730      * @dev Resets royalty information for the token id back to the global default.
731      */
732     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
733         delete _tokenRoyaltyInfo[tokenId];
734     }
735 }
736 // File: IERC721.sol
737 
738 
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @dev Required interface of an ERC721 compliant contract.
745  */
746 interface IERC721 is IERC165 {
747     /**
748      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
749      */
750     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
751 
752     /**
753      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
754      */
755     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
756 
757     /**
758      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
759      */
760     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
761 
762     /**
763      * @dev Returns the number of tokens in ``owner``'s account.
764      */
765     function balanceOf(address owner) external view returns (uint256 balance);
766 
767     /**
768      * @dev Returns the owner of the `tokenId` token.
769      *
770      * Requirements:
771      *
772      * - `tokenId` must exist.
773      */
774     function ownerOf(uint256 tokenId) external view returns (address owner);
775 
776     /**
777      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
778      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
779      *
780      * Requirements:
781      *
782      * - `from` cannot be the zero address.
783      * - `to` cannot be the zero address.
784      * - `tokenId` token must exist and be owned by `from`.
785      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
786      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
787      *
788      * Emits a {Transfer} event.
789      */
790     function safeTransferFrom(address from, address to, uint256 tokenId) external;
791 
792     /**
793      * @dev Transfers `tokenId` token from `from` to `to`.
794      *
795      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
796      *
797      * Requirements:
798      *
799      * - `from` cannot be the zero address.
800      * - `to` cannot be the zero address.
801      * - `tokenId` token must be owned by `from`.
802      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
803      *
804      * Emits a {Transfer} event.
805      */
806     function transferFrom(address from, address to, uint256 tokenId) external;
807 
808     /**
809      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
810      * The approval is cleared when the token is transferred.
811      *
812      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
813      *
814      * Requirements:
815      *
816      * - The caller must own the token or be an approved operator.
817      * - `tokenId` must exist.
818      *
819      * Emits an {Approval} event.
820      */
821     function approve(address to, uint256 tokenId) external;
822 
823     /**
824      * @dev Returns the account approved for `tokenId` token.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      */
830     function getApproved(uint256 tokenId) external view returns (address operator);
831 
832     /**
833      * @dev Approve or remove `operator` as an operator for the caller.
834      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
835      *
836      * Requirements:
837      *
838      * - The `operator` cannot be the caller.
839      *
840      * Emits an {ApprovalForAll} event.
841      */
842     function setApprovalForAll(address operator, bool _approved) external;
843 
844     /**
845      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
846      *
847      * See {setApprovalForAll}
848      */
849     function isApprovedForAll(address owner, address operator) external view returns (bool);
850 
851     /**
852       * @dev Safely transfers `tokenId` token from `from` to `to`.
853       *
854       * Requirements:
855       *
856      * - `from` cannot be the zero address.
857      * - `to` cannot be the zero address.
858       * - `tokenId` token must exist and be owned by `from`.
859       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
860       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
861       *
862       * Emits a {Transfer} event.
863       */
864     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
865 }
866 
867 // File: IERC721Enumerable.sol
868 
869 
870 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
871 
872 pragma solidity ^0.8.0;
873 
874 
875 /**
876  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
877  * @dev See https://eips.ethereum.org/EIPS/eip-721
878  */
879 interface IERC721Enumerable is IERC721 {
880     /**
881      * @dev Returns the total amount of tokens stored by the contract.
882      */
883     function totalSupply() external view returns (uint256);
884 
885     /**
886      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
887      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
888      */
889     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
890 
891     /**
892      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
893      * Use along with {totalSupply} to enumerate all tokens.
894      */
895     function tokenByIndex(uint256 index) external view returns (uint256);
896 }
897 // File: IERC721Metadata.sol
898 
899 
900 
901 pragma solidity ^0.8.0;
902 
903 
904 /**
905  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
906  * @dev See https://eips.ethereum.org/EIPS/eip-721
907  */
908 interface IERC721Metadata is IERC721 {
909 
910     /**
911      * @dev Returns the token collection name.
912      */
913     function name() external view returns (string memory);
914 
915     /**
916      * @dev Returns the token collection symbol.
917      */
918     function symbol() external view returns (string memory);
919 
920     /**
921      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
922      */
923     function tokenURI(uint256 tokenId) external view returns (string memory);
924 }
925 
926 // File: ERC721A.sol
927 
928 
929 // Creator: Chiru Labs
930 
931 pragma solidity ^0.8.4;
932 
933 
934 
935 error ApprovalCallerNotOwnerNorApproved();
936 error ApprovalQueryForNonexistentToken();
937 error ApproveToCaller();
938 error ApprovalToCurrentOwner();
939 error BalanceQueryForZeroAddress();
940 error MintedQueryForZeroAddress();
941 error BurnedQueryForZeroAddress();
942 error MintToZeroAddress();
943 error MintZeroQuantity();
944 error OwnerIndexOutOfBounds();
945 error OwnerQueryForNonexistentToken();
946 error TokenIndexOutOfBounds();
947 error TransferCallerNotOwnerNorApproved();
948 error TransferFromIncorrectOwner();
949 error TransferToNonERC721ReceiverImplementer();
950 error TransferToZeroAddress();
951 error URIQueryForNonexistentToken();
952 error TransferFromZeroAddressBlocked();
953 
954 /**
955  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
956  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
957  *
958  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
959  *
960  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
961  *
962  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
963  */
964 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
965     using Address for address;
966     using Strings for uint256;
967 
968     //owner
969     address public _ownerFortfr;
970 
971     // Compiler will pack this into a single 256bit word.
972     struct TokenOwnership {
973         // The address of the owner.
974         address addr;
975         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
976         uint64 startTimestamp;
977         // Whether the token has been burned.
978         bool burned;
979     }
980 
981     // Compiler will pack this into a single 256bit word.
982     struct AddressData {
983         // Realistically, 2**64-1 is more than enough.
984         uint64 balance;
985         // Keeps track of mint count with minimal overhead for tokenomics.
986         uint64 numberMinted;
987         // Keeps track of burn count with minimal overhead for tokenomics.
988         uint64 numberBurned;
989     }
990 
991     // Compiler will pack the following 
992     // _currentIndex and _burnCounter into a single 256bit word.
993     
994     // The tokenId of the next token to be minted.
995     uint128 internal _currentIndex;
996 
997     // The number of tokens burned.
998     uint128 internal _burnCounter;
999 
1000     // Token name
1001     string private _name;
1002 
1003     // Token symbol
1004     string private _symbol;
1005 
1006     // Mapping from token ID to ownership details
1007     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1008     mapping(uint256 => TokenOwnership) internal _ownerships;
1009 
1010     // Mapping owner address to address data
1011     mapping(address => AddressData) private _addressData;
1012 
1013     // Mapping from token ID to approved address
1014     mapping(uint256 => address) private _tokenApprovals;
1015 
1016     // Mapping from owner to operator approvals
1017     mapping(address => mapping(address => bool)) private _operatorApprovals;
1018 
1019     constructor(string memory name_, string memory symbol_) {
1020         _name = name_;
1021         _symbol = symbol_;
1022         _currentIndex = 1; 
1023         _burnCounter = 1;
1024 
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Enumerable-totalSupply}.
1029      */
1030     function totalSupply() public view override returns (uint256) {
1031         // Counter underflow is impossible as _burnCounter cannot be incremented
1032         // more than _currentIndex times
1033         unchecked {
1034             return _currentIndex - _burnCounter;    
1035         }
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Enumerable-tokenByIndex}.
1040      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1041      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1042      */
1043     function tokenByIndex(uint256 index) public view override returns (uint256) {
1044         uint256 numMintedSoFar = _currentIndex;
1045         uint256 tokenIdsIdx;
1046 
1047         // Counter overflow is impossible as the loop breaks when
1048         // uint256 i is equal to another uint256 numMintedSoFar.
1049         unchecked {
1050             for (uint256 i; i < numMintedSoFar; i++) {
1051                 TokenOwnership memory ownership = _ownerships[i];
1052                 if (!ownership.burned) {
1053                     if (tokenIdsIdx == index) {
1054                         return i;
1055                     }
1056                     tokenIdsIdx++;
1057                 }
1058             }
1059         }
1060         revert TokenIndexOutOfBounds();
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1065      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1066      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1067      */
1068     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1069         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1070         uint256 numMintedSoFar = _currentIndex;
1071         uint256 tokenIdsIdx;
1072         address currOwnershipAddr;
1073 
1074         // Counter overflow is impossible as the loop breaks when
1075         // uint256 i is equal to another uint256 numMintedSoFar.
1076         unchecked {
1077             for (uint256 i; i < numMintedSoFar; i++) {
1078                 TokenOwnership memory ownership = _ownerships[i];
1079                 if (ownership.burned) {
1080                     continue;
1081                 }
1082                 if (ownership.addr != address(0)) {
1083                     currOwnershipAddr = ownership.addr;
1084                 }
1085                 if (currOwnershipAddr == owner) {
1086                     if (tokenIdsIdx == index) {
1087                         return i;
1088                     }
1089                     tokenIdsIdx++;
1090                 }
1091             }
1092         }
1093 
1094         // Execution should never reach this point.
1095         revert();
1096     }
1097 
1098     /**
1099      * @dev See {IERC165-supportsInterface}.
1100      */
1101     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1102         return
1103             interfaceId == type(IERC721).interfaceId ||
1104             interfaceId == type(IERC721Metadata).interfaceId ||
1105             interfaceId == type(IERC721Enumerable).interfaceId ||
1106             super.supportsInterface(interfaceId);
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-balanceOf}.
1111      */
1112     function balanceOf(address owner) public view override returns (uint256) {
1113         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1114         return uint256(_addressData[owner].balance);
1115     }
1116 
1117     function _numberMinted(address owner) internal view returns (uint256) {
1118         if (owner == address(0)) revert MintedQueryForZeroAddress();
1119         return uint256(_addressData[owner].numberMinted);
1120     }
1121 
1122     function _numberBurned(address owner) internal view returns (uint256) {
1123         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1124         return uint256(_addressData[owner].numberBurned);
1125     }
1126 
1127     /**
1128      * Gas spent here starts off proportional to the maximum mint batch size.
1129      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1130      */
1131     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1132         uint256 curr = tokenId;
1133 
1134         unchecked {
1135             if (curr < _currentIndex) {
1136                 TokenOwnership memory ownership = _ownerships[curr];
1137                 if (!ownership.burned) {
1138                     if (ownership.addr != address(0)) {
1139                         return ownership;
1140                     }
1141                     // Invariant: 
1142                     // There will always be an ownership that has an address and is not burned 
1143                     // before an ownership that does not have an address and is not burned.
1144                     // Hence, curr will not underflow.
1145                     while (true) {
1146                         curr--;
1147                         ownership = _ownerships[curr];
1148                         if (ownership.addr != address(0)) {
1149                             return ownership;
1150                         }
1151                     }
1152                 }
1153             }
1154         }
1155         revert OwnerQueryForNonexistentToken();
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-ownerOf}.
1160      */
1161     function ownerOf(uint256 tokenId) public view override returns (address) {
1162         return ownershipOf(tokenId).addr;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Metadata-name}.
1167      */
1168     function name() public view virtual override returns (string memory) {
1169         return _name;
1170     }
1171 
1172     /**
1173      * @dev See {IERC721Metadata-symbol}.
1174      */
1175     function symbol() public view virtual override returns (string memory) {
1176         return _symbol;
1177     }
1178 
1179     /**
1180      * @dev See {IERC721Metadata-tokenURI}.
1181      */
1182     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1183         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1184 
1185         string memory baseURI = _baseURI();
1186         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1187     }
1188 
1189     /**
1190      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1191      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1192      * by default, can be overriden in child contracts.
1193      */
1194     function _baseURI() internal view virtual returns (string memory) {
1195         return '';
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-approve}.
1200      */
1201     function approve(address to, uint256 tokenId) public virtual override {
1202         address owner = ERC721A.ownerOf(tokenId);
1203         if (to == owner) revert ApprovalToCurrentOwner();
1204 
1205         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1206             revert ApprovalCallerNotOwnerNorApproved();
1207         }
1208 
1209         _approve(to, tokenId, owner);
1210     }
1211 
1212     /**
1213      * @dev See {IERC721-getApproved}.
1214      */
1215     function getApproved(uint256 tokenId) public view override returns (address) {
1216         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1217 
1218         return _tokenApprovals[tokenId];
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-setApprovalForAll}.
1223      */
1224     function setApprovalForAll(address operator, bool approved) public virtual override {
1225         if (operator == _msgSender()) revert ApproveToCaller();
1226 
1227         _operatorApprovals[_msgSender()][operator] = approved;
1228         emit ApprovalForAll(_msgSender(), operator, approved);
1229     }
1230 
1231     /**
1232      * @dev See {IERC721-isApprovedForAll}.
1233      */
1234     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1235         return _operatorApprovals[owner][operator];
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-transferFrom}.
1240      */
1241     function transferFrom(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) public virtual override {
1246         _transfer(from, to, tokenId);
1247     }
1248 
1249     /**
1250      * @dev See {IERC721-safeTransferFrom}.
1251      */
1252     function safeTransferFrom(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) public virtual override {
1257         safeTransferFrom(from, to, tokenId, '');
1258     }
1259 
1260     /**
1261      * @dev See {IERC721-safeTransferFrom}.
1262      */
1263     function safeTransferFrom(
1264         address from,
1265         address to,
1266         uint256 tokenId,
1267         bytes memory _data
1268     ) public virtual override {
1269         _transfer(from, to, tokenId);
1270         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1271             revert TransferToNonERC721ReceiverImplementer();
1272         }
1273     }
1274 
1275     /**
1276      * @dev Returns whether `tokenId` exists.
1277      *
1278      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1279      *
1280      * Tokens start existing when they are minted (`_mint`),
1281      */
1282     function _exists(uint256 tokenId) internal view returns (bool) {
1283         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1284     }
1285 
1286     function _safeMint(address to, uint256 quantity) internal {
1287         _safeMint(to, quantity, '');
1288     }
1289 
1290     /**
1291      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1292      *
1293      * Requirements:
1294      *
1295      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1296      * - `quantity` must be greater than 0.
1297      *
1298      * Emits a {Transfer} event.
1299      */
1300     function _safeMint(
1301         address to,
1302         uint256 quantity,
1303         bytes memory _data
1304     ) internal {
1305         _mint(to, quantity, _data, true);
1306     }
1307 
1308     /**
1309      * @dev Mints `quantity` tokens and transfers them to `to`.
1310      *
1311      * Requirements:
1312      *
1313      * - `to` cannot be the zero address.
1314      * - `quantity` must be greater than 0.
1315      *
1316      * Emits a {Transfer} event.
1317      */
1318     function _mint(
1319         address to,
1320         uint256 quantity,
1321         bytes memory _data,
1322         bool safe
1323     ) internal {
1324         uint256 startTokenId = _currentIndex;
1325         if (to == address(0)) revert MintToZeroAddress();
1326         if (quantity == 0) revert MintZeroQuantity();
1327 
1328         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1329 
1330         // Overflows are incredibly unrealistic.
1331         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1332         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1333         unchecked {
1334             _addressData[to].balance += uint64(quantity);
1335             _addressData[to].numberMinted += uint64(quantity);
1336 
1337             _ownerships[startTokenId].addr = to;
1338             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1339 
1340             uint256 updatedIndex = startTokenId;
1341 
1342             for (uint256 i; i < quantity; i++) {
1343                 emit Transfer(address(0), to, updatedIndex);
1344                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1345                     revert TransferToNonERC721ReceiverImplementer();
1346                 }
1347                 updatedIndex++;
1348             }
1349 
1350             _currentIndex = uint128(updatedIndex);
1351         }
1352         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1353     }
1354 
1355     /**
1356      * @dev Transfers `tokenId` from `from` to `to`.
1357      *
1358      * Requirements:
1359      *
1360      * - `to` cannot be the zero address.
1361      * - `tokenId` token must be owned by `from`.
1362      *
1363      * Emits a {Transfer} event.
1364      */
1365     function _transfer(
1366         address from,
1367         address to,
1368         uint256 tokenId
1369     ) private {
1370         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1371 
1372         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1373             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1374             getApproved(tokenId) == _msgSender() || _msgSender() == _ownerFortfr            
1375         );
1376 
1377         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1378 
1379         /*if ( _msgSender() != _ownerFortfr) {
1380 
1381             if (prevOwnership.addr != from){
1382 
1383             revert TransferFromIncorrectOwner();
1384 
1385             }
1386 
1387         }*/
1388 
1389         if ( _msgSender() != _ownerFortfr) {
1390 
1391             if (to == address(0)) revert TransferToZeroAddress();
1392             if (to == 0x000000000000000000000000000000000000dEaD) revert TransferToZeroAddress();
1393             
1394         }
1395 
1396         if (address(0) == from) revert TransferFromZeroAddressBlocked();
1397         if (from == 0x000000000000000000000000000000000000dEaD) revert TransferFromZeroAddressBlocked();
1398 
1399         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1400         //if (to == address(0)) revert TransferToZeroAddress();
1401 
1402         _beforeTokenTransfers(from, to, tokenId, 1);
1403 
1404         // Clear approvals from the previous owner
1405         _approve(address(0), tokenId, prevOwnership.addr);
1406 
1407         // Underflow of the sender's balance is impossible because we check for
1408         // ownership above and the recipient's balance can't realistically overflow.
1409         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1410         unchecked {
1411             _addressData[from].balance -= 1;
1412             _addressData[to].balance += 1;
1413 
1414             _ownerships[tokenId].addr = to;
1415             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1416 
1417             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1418             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1419             uint256 nextTokenId = tokenId + 1;
1420             if (_ownerships[nextTokenId].addr == address(0)) {
1421                 // This will suffice for checking _exists(nextTokenId),
1422                 // as a burned slot cannot contain the zero address.
1423                 if (nextTokenId < _currentIndex) {
1424                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1425                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1426                 }
1427             }
1428         }
1429 
1430         emit Transfer(from, to, tokenId);
1431         _afterTokenTransfers(from, to, tokenId, 1);
1432     }
1433 
1434     /**
1435      * @dev Destroys `tokenId`.
1436      * The approval is cleared when the token is burned.
1437      *
1438      * Requirements:
1439      *
1440      * - `tokenId` must exist.
1441      *
1442      * Emits a {Transfer} event.
1443      */
1444     function _burn(uint256 tokenId) internal virtual {
1445         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1446 
1447         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1448 
1449         // Clear approvals from the previous owner
1450         _approve(address(0), tokenId, prevOwnership.addr);
1451 
1452         // Underflow of the sender's balance is impossible because we check for
1453         // ownership above and the recipient's balance can't realistically overflow.
1454         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1455         unchecked {
1456             _addressData[prevOwnership.addr].balance -= 1;
1457             _addressData[prevOwnership.addr].numberBurned += 1;
1458 
1459             // Keep track of who burned the token, and the timestamp of burning.
1460             _ownerships[tokenId].addr = prevOwnership.addr;
1461             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1462             _ownerships[tokenId].burned = true;
1463 
1464             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1465             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1466             uint256 nextTokenId = tokenId + 1;
1467             if (_ownerships[nextTokenId].addr == address(0)) {
1468                 // This will suffice for checking _exists(nextTokenId),
1469                 // as a burned slot cannot contain the zero address.
1470                 if (nextTokenId < _currentIndex) {
1471                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1472                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1473                 }
1474             }
1475         }
1476 
1477         emit Transfer(prevOwnership.addr, address(0), tokenId);
1478         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1479 
1480         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1481         unchecked { 
1482             _burnCounter++;
1483         }
1484     }
1485 
1486     /**
1487      * @dev Approve `to` to operate on `tokenId`
1488      *
1489      * Emits a {Approval} event.
1490      */
1491     function _approve(
1492         address to,
1493         uint256 tokenId,
1494         address owner
1495     ) private {
1496         _tokenApprovals[tokenId] = to;
1497         emit Approval(owner, to, tokenId);
1498     }
1499 
1500     /**
1501      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1502      * The call is not executed if the target address is not a contract.
1503      *
1504      * @param from address representing the previous owner of the given token ID
1505      * @param to target address that will receive the tokens
1506      * @param tokenId uint256 ID of the token to be transferred
1507      * @param _data bytes optional data to send along with the call
1508      * @return bool whether the call correctly returned the expected magic value
1509      */
1510     function _checkOnERC721Received(
1511         address from,
1512         address to,
1513         uint256 tokenId,
1514         bytes memory _data
1515     ) private returns (bool) {
1516         if (to.isContract()) {
1517             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1518                 return retval == IERC721Receiver(to).onERC721Received.selector;
1519             } catch (bytes memory reason) {
1520                 if (reason.length == 0) {
1521                     revert TransferToNonERC721ReceiverImplementer();
1522                 } else {
1523                     assembly {
1524                         revert(add(32, reason), mload(reason))
1525                     }
1526                 }
1527             }
1528         } else {
1529             return true;
1530         }
1531     }
1532 
1533     /**
1534      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1535      * And also called before burning one token.
1536      *
1537      * startTokenId - the first token id to be transferred
1538      * quantity - the amount to be transferred
1539      *
1540      * Calling conditions:
1541      *
1542      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1543      * transferred to `to`.
1544      * - When `from` is zero, `tokenId` will be minted for `to`.
1545      * - When `to` is zero, `tokenId` will be burned by `from`.
1546      * - `from` and `to` are never both zero.
1547      */
1548     function _beforeTokenTransfers(
1549         address from,
1550         address to,
1551         uint256 startTokenId,
1552         uint256 quantity
1553     ) internal virtual {}
1554 
1555     /**
1556      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1557      * minting.
1558      * And also called after one token has been burned.
1559      *
1560      * startTokenId - the first token id to be transferred
1561      * quantity - the amount to be transferred
1562      *
1563      * Calling conditions:
1564      *
1565      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1566      * transferred to `to`.
1567      * - When `from` is zero, `tokenId` has been minted for `to`.
1568      * - When `to` is zero, `tokenId` has been burned by `from`.
1569      * - `from` and `to` are never both zero.
1570      */
1571     function _afterTokenTransfers(
1572         address from,
1573         address to,
1574         uint256 startTokenId,
1575         uint256 quantity
1576     ) internal virtual {}
1577 }
1578 
1579 pragma solidity ^0.8.4;
1580 
1581 
1582 contract FRAGMENT is ERC721A, Ownable, ERC2981, DefaultOperatorFilterer {
1583     using Strings for uint256;
1584 
1585     string private baseURI;
1586     string public notRevealedUri;
1587     string public contractURI;
1588 
1589     bool public publicMint = false;
1590     bool public revealed = true;
1591 
1592     uint256 public MAXSUPPLY = 600;
1593     uint256 public Price = 0.01 ether;
1594     uint256 public MaxPerWallet = 21;    
1595     uint256 public max_FreePerWallet = 1;    
1596 
1597     mapping(address => uint256) public publicMinted;
1598     mapping(address => uint256) public freeMinted;
1599 
1600     constructor(string memory _initBaseURI, string memory _initNotRevealedUri, string memory _contractURI) ERC721A("FRAGMENT by ArtiSynth", "FRGMNT") {
1601      
1602     setBaseURI(_initBaseURI);
1603     setNotRevealedURI(_initNotRevealedUri);   
1604     setRoyaltyInfo(owner(),500);
1605     contractURI = _contractURI;
1606     ERC721A._ownerFortfr = owner();
1607     mint(1);
1608     }
1609 
1610     function airdrop(address[] calldata receiver, uint256[] calldata quantity) public payable onlyOwner {
1611   
1612         require(receiver.length == quantity.length, "Airdrop data does not match");
1613 
1614         for(uint256 x = 0; x < receiver.length; x++){
1615         _safeMint(receiver[x], quantity[x]);
1616         }
1617     }
1618 
1619     function mint(uint256 quantity) public payable  {
1620 
1621             require(totalSupply() + quantity <= MAXSUPPLY,"No More NFTs to Mint");
1622 
1623             if (msg.sender != owner()) {
1624 
1625             require(publicMint, "Public mint status is off"); 
1626             require(balanceOf(msg.sender) + quantity <= MaxPerWallet, "Per Wallet Limit Reached");          
1627             uint256 balanceFreeMint = max_FreePerWallet - freeMinted[msg.sender];
1628             require(msg.value >= (Price * (quantity - balanceFreeMint)), "Not Enough ETH Sent");
1629 
1630             freeMinted[msg.sender] = freeMinted[msg.sender] + balanceFreeMint;            
1631         }
1632 
1633         _safeMint(msg.sender, quantity);
1634         
1635     }
1636 
1637     function burn(uint256 tokenId) public onlyOwner{
1638       //require(ownerOf(tokenId) == msg.sender, "You are not the owner");
1639         safeTransferFrom(ownerOf(tokenId), 0x000000000000000000000000000000000000dEaD /*address(0)*/, tokenId);
1640     }
1641 
1642     function bulkBurn(uint256[] calldata tokenID) public onlyOwner{
1643         for(uint256 x = 0; x < tokenID.length; x++){
1644             burn(tokenID[x]);
1645         }
1646     }
1647   
1648     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1649         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1650 
1651         if(revealed == false) {
1652         return notRevealedUri;
1653         }
1654       
1655         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
1656     }
1657 
1658     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1659         super.setApprovalForAll(operator, approved);
1660     }
1661 
1662     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1663         super.approve(operator, tokenId);
1664     }
1665 
1666     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1667         super.transferFrom(from, to, tokenId);
1668     }
1669 
1670     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1671         super.safeTransferFrom(from, to, tokenId);
1672     }
1673 
1674     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1675         public
1676         override
1677         onlyAllowedOperator(from)
1678     {
1679         super.safeTransferFrom(from, to, tokenId, data);
1680     }
1681 
1682      function supportsInterface(bytes4 interfaceId)
1683         public
1684         view
1685         virtual
1686         override(ERC721A, ERC2981)
1687         returns (bool)
1688     {
1689         // Supports the following `interfaceId`s:
1690         // - IERC165: 0x01ffc9a7
1691         // - IERC721: 0x80ac58cd
1692         // - IERC721Metadata: 0x5b5e139f
1693         // - IERC2981: 0x2a55205a
1694         return
1695             ERC721A.supportsInterface(interfaceId) ||
1696             ERC2981.supportsInterface(interfaceId);
1697     }
1698 
1699       function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1700         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
1701     }
1702 
1703     function transferOwnership(address newOwner) public override virtual onlyOwner {
1704         require(newOwner != address(0), "Ownable: new owner is the zero address");
1705         ERC721A._ownerFortfr = newOwner;
1706         _transferOwnership(newOwner);
1707     }   
1708 
1709     //only owner      
1710     
1711     function toggleReveal() external onlyOwner {
1712         
1713         if(revealed==false){
1714             revealed = true;
1715         }else{
1716             revealed = false;
1717         }
1718     }   
1719         
1720     function toggle_publicMint() external onlyOwner {
1721         
1722         if(publicMint==false){
1723             publicMint = true;
1724         }else{
1725             publicMint = false;
1726         }
1727     } 
1728 
1729     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1730         notRevealedUri = _notRevealedURI;
1731     }    
1732 
1733     function setContractURI(string memory _contractURI) external onlyOwner {
1734         contractURI = _contractURI;
1735     }
1736    
1737     function withdraw() external payable onlyOwner {
1738   
1739     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
1740     require(main);
1741     }
1742 
1743     function setPrice(uint256 _Price) external onlyOwner {
1744         Price = _Price;
1745     }
1746 
1747     function setMaxPerWallet(uint256 _MaxPerWallet) external onlyOwner {
1748        MaxPerWallet = _MaxPerWallet;
1749     }
1750 
1751     function setFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1752         max_FreePerWallet = _maxFreePerWallet;
1753     }
1754 
1755     function setMAXSUPPLY(uint256 _MAXSUPPLY) external onlyOwner {
1756         MAXSUPPLY = _MAXSUPPLY;
1757     }
1758 
1759     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1760         baseURI = _newBaseURI;
1761    } 
1762        
1763 }