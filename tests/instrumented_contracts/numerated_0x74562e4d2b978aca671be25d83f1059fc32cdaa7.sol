1 /**
2 // SPDX-License-Identifier: MIT
3 // File: IOperatorFilterRegistry.sol
4 /*
5       ████████                          
6     ██▒▒▒▒▒▒▒▒▒▒██                      
7   ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                    
8 ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒██                  
9 ██▒▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒██                
10 ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████            
11 ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██        
12 ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    
13 ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██  
14   ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
15     ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
16     ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
17       ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
18           ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██  
19               ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    
20                   ████████████████      
21 
22 https://twitter.com/DarkZukis
23 */
24 
25 pragma solidity ^0.8.13;
26 
27 interface IOperatorFilterRegistry {
28     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
29     function register(address registrant) external;
30     function registerAndSubscribe(address registrant, address subscription) external;
31     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
32     function unregister(address addr) external;
33     function updateOperator(address registrant, address operator, bool filtered) external;
34     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
35     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
36     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
37     function subscribe(address registrant, address registrantToSubscribe) external;
38     function unsubscribe(address registrant, bool copyExistingEntries) external;
39     function subscriptionOf(address addr) external returns (address registrant);
40     function subscribers(address registrant) external returns (address[] memory);
41     function subscriberAt(address registrant, uint256 index) external returns (address);
42     function copyEntriesOf(address registrant, address registrantToCopy) external;
43     function isOperatorFiltered(address registrant, address operator) external returns (bool);
44     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
45     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
46     function filteredOperators(address addr) external returns (address[] memory);
47     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
48     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
49     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
50     function isRegistered(address addr) external returns (bool);
51     function codeHashOf(address addr) external returns (bytes32);
52 }
53 
54 // File: OperatorFilterer.sol
55 
56 
57 pragma solidity ^0.8.13;
58 
59 
60 /**
61  * @title  OperatorFilterer
62  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
63  *         registrant's entries in the OperatorFilterRegistry.
64  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
65  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
66  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
67  */
68 abstract contract OperatorFilterer {
69     error OperatorNotAllowed(address operator);
70 
71     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
72         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
73 
74     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
75         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
76         // will not revert, but the contract will need to be registered with the registry once it is deployed in
77         // order for the modifier to filter addresses.
78         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
79             if (subscribe) {
80                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
81             } else {
82                 if (subscriptionOrRegistrantToCopy != address(0)) {
83                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
84                 } else {
85                     OPERATOR_FILTER_REGISTRY.register(address(this));
86                 }
87             }
88         }
89     }
90 
91     modifier onlyAllowedOperator(address from) virtual {
92         // Allow spending tokens from addresses with balance
93         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
94         // from an EOA.
95         if (from != msg.sender) {
96             _checkFilterOperator(msg.sender);
97         }
98         _;
99     }
100 
101     modifier onlyAllowedOperatorApproval(address operator) virtual {
102         _checkFilterOperator(operator);
103         _;
104     }
105 
106     function _checkFilterOperator(address operator) internal view virtual {
107         // Check registry code length to facilitate testing in environments without a deployed registry.
108         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
109             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
110                 revert OperatorNotAllowed(operator);
111             }
112         }
113     }
114 }
115 
116 // File: DefaultOperatorFilterer.sol
117 
118 
119 pragma solidity ^0.8.13;
120 
121 
122 /**
123  * @title  DefaultOperatorFilterer
124  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
125  */
126 abstract contract DefaultOperatorFilterer is OperatorFilterer {
127     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
128 
129     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
130 }
131 
132 // File: MerkleProof.sol
133 
134 // contracts/MerkleProofVerify.sol
135 
136 // based upon https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/mocks/MerkleProofWrapper.sol
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev These functions deal with verification of Merkle trees (hash trees),
142  */
143 library MerkleProof {
144     /**
145      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
146      * defined by `root`. For this, a `proof` must be provided, containing
147      * sibling hashes on the branch from the leaf to the root of the tree. Each
148      * pair of leaves and each pair of pre-images are assumed to be sorted.
149      */
150     function verify(bytes32[] calldata proof, bytes32 leaf, bytes32 root) internal pure returns (bool) {
151         bytes32 computedHash = leaf;
152 
153         for (uint256 i = 0; i < proof.length; i++) {
154             bytes32 proofElement = proof[i];
155 
156             if (computedHash <= proofElement) {
157                 // Hash(current computed hash + current element of the proof)
158                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
159             } else {
160                 // Hash(current element of the proof + current computed hash)
161                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
162             }
163         }
164 
165         // Check if the computed hash (root) is equal to the provided root
166         return computedHash == root;
167     }
168 }
169 
170 
171 /*
172 
173 pragma solidity ^0.8.0;
174 
175 
176 
177 contract MerkleProofVerify {
178     function verify(bytes32[] calldata proof, bytes32 root)
179         public
180         view
181         returns (bool)
182     {
183         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
184 
185         return MerkleProof.verify(proof, root, leaf);
186     }
187 }
188 */
189 // File: Strings.sol
190 
191 
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @dev String operations.
197  */
198 library Strings {
199     /**
200      * @dev Converts a `uint256` to its ASCII `string` representation.
201      */
202     function toString(uint256 value) internal pure returns (string memory) {
203         // Inspired by OraclizeAPI's implementation - MIT licence
204         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
205 
206         if (value == 0) {
207             return "0";
208         }
209         uint256 temp = value;
210         uint256 digits;
211         while (temp != 0) {
212             digits++;
213             temp /= 10;
214         }
215         bytes memory buffer = new bytes(digits);
216         uint256 index = digits;
217         temp = value;
218         while (temp != 0) {
219             buffer[--index] = bytes1(uint8(48 + uint256(temp % 10)));
220             temp /= 10;
221         }
222         return string(buffer);
223     }
224 }
225 
226 // File: Context.sol
227 
228 
229 
230 pragma solidity ^0.8.0;
231 
232 /*
233  * @dev Provides information about the current execution context, including the
234  * sender of the transaction and its data. While these are generally available
235  * via msg.sender and msg.data, they should not be accessed in such a direct
236  * manner, since when dealing with GSN meta-transactions the account sending and
237  * paying for execution may not be the actual sender (as far as an application
238  * is concerned).
239  *
240  * This contract is only required for intermediate, library-like contracts.
241  */
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes memory) {
248         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
249         return msg.data;
250     }
251 }
252 
253 // File: Ownable.sol
254 
255 
256 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 
261 /**
262  * @dev Contract module which provides a basic access control mechanism, where
263  * there is an account (an owner) that can be granted exclusive access to
264  * specific functions.
265  *
266  * By default, the owner account will be the one that deploys the contract. This
267  * can later be changed with {transferOwnership}.
268  *
269  * This module is used through inheritance. It will make available the modifier
270  * `onlyOwner`, which can be applied to your functions to restrict their use to
271  * the owner.
272  */
273 abstract contract Ownable is Context {
274     address private _owner;
275 
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278     /**
279      * @dev Initializes the contract setting the deployer as the initial owner.
280      */
281     constructor() {
282         _transferOwnership(_msgSender());
283     }
284 
285     /**
286      * @dev Throws if called by any account other than the owner.
287      */
288     modifier onlyOwner() {
289         _checkOwner();
290         _;
291     }
292 
293     /**
294      * @dev Returns the address of the current owner.
295      */
296     function owner() public view virtual returns (address) {
297         return _owner;
298     }
299 
300     /**
301      * @dev Throws if the sender is not the owner.
302      */
303     function _checkOwner() internal view virtual {
304         require(owner() == _msgSender(), "Ownable: caller is not the owner");
305     }
306 
307     /**
308      * @dev Leaves the contract without owner. It will not be possible to call
309      * `onlyOwner` functions anymore. Can only be called by the current owner.
310      *
311      * NOTE: Renouncing ownership will leave the contract without an owner,
312      * thereby removing any functionality that is only available to the owner.
313      */
314     function renounceOwnership() public virtual onlyOwner {
315         _transferOwnership(address(0));
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Can only be called by the current owner.
321      */
322     function transferOwnership(address newOwner) public virtual onlyOwner {
323         require(newOwner != address(0), "Ownable: new owner is the zero address");
324         _transferOwnership(newOwner);
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Internal function without access restriction.
330      */
331     function _transferOwnership(address newOwner) internal virtual {
332         address oldOwner = _owner;
333         _owner = newOwner;
334         emit OwnershipTransferred(oldOwner, newOwner);
335     }
336 }
337 // File: Address.sol
338 
339 
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Collection of functions related to the address type
345  */
346 library Address {
347     /**
348      * @dev Returns true if `account` is a contract.
349      *
350      * [IMPORTANT]
351      * ====
352      * It is unsafe to assume that an address for which this function returns
353      * false is an externally-owned account (EOA) and not a contract.
354      *
355      * Among others, `isContract` will return false for the following
356      * types of addresses:
357      *
358      *  - an externally-owned account
359      *  - a contract in construction
360      *  - an address where a contract will be created
361      *  - an address where a contract lived, but was destroyed
362      * ====
363      */
364     function isContract(address account) internal view returns (bool) {
365         // This method relies on extcodesize, which returns 0 for contracts in
366         // construction, since the code is only stored at the end of the
367         // constructor execution.
368 
369         uint256 size;
370         // solhint-disable-next-line no-inline-assembly
371         assembly { size := extcodesize(account) }
372         return size > 0;
373     }
374 
375     /**
376      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
377      * `recipient`, forwarding all available gas and reverting on errors.
378      *
379      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
380      * of certain opcodes, possibly making contracts go over the 2300 gas limit
381      * imposed by `transfer`, making them unable to receive funds via
382      * `transfer`. {sendValue} removes this limitation.
383      *
384      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
385      *
386      * IMPORTANT: because control is transferred to `recipient`, care must be
387      * taken to not create reentrancy vulnerabilities. Consider using
388      * {ReentrancyGuard} or the
389      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
395         (bool success, ) = recipient.call{ value: amount }("");
396         require(success, "Address: unable to send value, recipient may have reverted");
397     }
398 
399     /**
400      * @dev Performs a Solidity function call using a low level `call`. A
401      * plain`call` is an unsafe replacement for a function call: use this
402      * function instead.
403      *
404      * If `target` reverts with a revert reason, it is bubbled up by this
405      * function (like regular Solidity function calls).
406      *
407      * Returns the raw returned data. To convert to the expected return value,
408      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
409      *
410      * Requirements:
411      *
412      * - `target` must be a contract.
413      * - calling `target` with `data` must not revert.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
418       return functionCall(target, data, "Address: low-level call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
423      * `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
428         return functionCallWithValue(target, data, 0, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but also transferring `value` wei to `target`.
434      *
435      * Requirements:
436      *
437      * - the calling contract must have an ETH balance of at least `value`.
438      * - the called Solidity function must be `payable`.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
448      * with `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
453         require(address(this).balance >= value, "Address: insufficient balance for call");
454         require(isContract(target), "Address: call to non-contract");
455 
456         // solhint-disable-next-line avoid-low-level-calls
457         (bool success, bytes memory returndata) = target.call{ value: value }(data);
458         return _verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
468         return functionStaticCall(target, data, "Address: low-level static call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
478         require(isContract(target), "Address: static call to non-contract");
479 
480         // solhint-disable-next-line avoid-low-level-calls
481         (bool success, bytes memory returndata) = target.staticcall(data);
482         return _verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.3._
490      */
491     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
492         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.3._
500      */
501     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
502         require(isContract(target), "Address: delegate call to non-contract");
503 
504         // solhint-disable-next-line avoid-low-level-calls
505         (bool success, bytes memory returndata) = target.delegatecall(data);
506         return _verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 // solhint-disable-next-line no-inline-assembly
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 // File: IERC721Receiver.sol
530 
531 
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @title ERC721 token receiver interface
537  * @dev Interface for any contract that wants to support safeTransfers
538  * from ERC721 asset contracts.
539  */
540 interface IERC721Receiver {
541     /**
542      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
543      * by `operator` from `from`, this function is called.
544      *
545      * It must return its Solidity selector to confirm the token transfer.
546      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
547      *
548      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
549      */
550     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
551 }
552 
553 // File: IERC165.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Interface of the ERC165 standard, as defined in the
562  * https://eips.ethereum.org/EIPS/eip-165[EIP].
563  *
564  * Implementers can declare support of contract interfaces, which can then be
565  * queried by others ({ERC165Checker}).
566  *
567  * For an implementation, see {ERC165}.
568  */
569 interface IERC165 {
570     /**
571      * @dev Returns true if this contract implements the interface defined by
572      * `interfaceId`. See the corresponding
573      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
574      * to learn more about how these ids are created.
575      *
576      * This function call must use less than 30 000 gas.
577      */
578     function supportsInterface(bytes4 interfaceId) external view returns (bool);
579 }
580 // File: IERC2981.sol
581 
582 
583 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 /**
589  * @dev Interface for the NFT Royalty Standard.
590  *
591  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
592  * support for royalty payments across all NFT marketplaces and ecosystem participants.
593  *
594  * _Available since v4.5._
595  */
596 interface IERC2981 is IERC165 {
597     /**
598      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
599      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
600      */
601     function royaltyInfo(uint256 tokenId, uint256 salePrice)
602         external
603         view
604         returns (address receiver, uint256 royaltyAmount);
605 }
606 // File: ERC165.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @dev Implementation of the {IERC165} interface.
616  *
617  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
618  * for the additional interface id that will be supported. For example:
619  *
620  * ```solidity
621  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
623  * }
624  * ```
625  *
626  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
627  */
628 abstract contract ERC165 is IERC165 {
629     /**
630      * @dev See {IERC165-supportsInterface}.
631      */
632     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
633         return interfaceId == type(IERC165).interfaceId;
634     }
635 }
636 // File: ERC2981.sol
637 
638 
639 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 
644 
645 /**
646  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
647  *
648  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
649  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
650  *
651  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
652  * fee is specified in basis points by default.
653  *
654  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
655  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
656  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
657  *
658  * _Available since v4.5._
659  */
660 abstract contract ERC2981 is IERC2981, ERC165 {
661     struct RoyaltyInfo {
662         address receiver;
663         uint96 royaltyFraction;
664     }
665 
666     RoyaltyInfo private _defaultRoyaltyInfo;
667     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
668 
669     /**
670      * @dev See {IERC165-supportsInterface}.
671      */
672     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
673         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
674     }
675 
676     /**
677      * @inheritdoc IERC2981
678      */
679     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
680         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
681 
682         if (royalty.receiver == address(0)) {
683             royalty = _defaultRoyaltyInfo;
684         }
685 
686         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
687 
688         return (royalty.receiver, royaltyAmount);
689     }
690 
691     /**
692      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
693      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
694      * override.
695      */
696     function _feeDenominator() internal pure virtual returns (uint96) {
697         return 10000;
698     }
699 
700     /**
701      * @dev Sets the royalty information that all ids in this contract will default to.
702      *
703      * Requirements:
704      *
705      * - `receiver` cannot be the zero address.
706      * - `feeNumerator` cannot be greater than the fee denominator.
707      */
708     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
709         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
710         require(receiver != address(0), "ERC2981: invalid receiver");
711 
712         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
713     }
714 
715     /**
716      * @dev Removes default royalty information.
717      */
718     function _deleteDefaultRoyalty() internal virtual {
719         delete _defaultRoyaltyInfo;
720     }
721 
722     /**
723      * @dev Sets the royalty information for a specific token id, overriding the global default.
724      *
725      * Requirements:
726      *
727      * - `receiver` cannot be the zero address.
728      * - `feeNumerator` cannot be greater than the fee denominator.
729      */
730     function _setTokenRoyalty(
731         uint256 tokenId,
732         address receiver,
733         uint96 feeNumerator
734     ) internal virtual {
735         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
736         require(receiver != address(0), "ERC2981: Invalid parameters");
737 
738         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
739     }
740 
741     /**
742      * @dev Resets royalty information for the token id back to the global default.
743      */
744     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
745         delete _tokenRoyaltyInfo[tokenId];
746     }
747 }
748 // File: IERC721.sol
749 
750 
751 
752 pragma solidity ^0.8.0;
753 
754 
755 /**
756  * @dev Required interface of an ERC721 compliant contract.
757  */
758 interface IERC721 is IERC165 {
759     /**
760      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
761      */
762     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
763 
764     /**
765      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
766      */
767     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
768 
769     /**
770      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
771      */
772     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
773 
774     /**
775      * @dev Returns the number of tokens in ``owner``'s account.
776      */
777     function balanceOf(address owner) external view returns (uint256 balance);
778 
779     /**
780      * @dev Returns the owner of the `tokenId` token.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must exist.
785      */
786     function ownerOf(uint256 tokenId) external view returns (address owner);
787 
788     /**
789      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
790      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
791      *
792      * Requirements:
793      *
794      * - `from` cannot be the zero address.
795      * - `to` cannot be the zero address.
796      * - `tokenId` token must exist and be owned by `from`.
797      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
798      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
799      *
800      * Emits a {Transfer} event.
801      */
802     function safeTransferFrom(address from, address to, uint256 tokenId) external;
803 
804     /**
805      * @dev Transfers `tokenId` token from `from` to `to`.
806      *
807      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must be owned by `from`.
814      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
815      *
816      * Emits a {Transfer} event.
817      */
818     function transferFrom(address from, address to, uint256 tokenId) external;
819 
820     /**
821      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
822      * The approval is cleared when the token is transferred.
823      *
824      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
825      *
826      * Requirements:
827      *
828      * - The caller must own the token or be an approved operator.
829      * - `tokenId` must exist.
830      *
831      * Emits an {Approval} event.
832      */
833     function approve(address to, uint256 tokenId) external;
834 
835     /**
836      * @dev Returns the account approved for `tokenId` token.
837      *
838      * Requirements:
839      *
840      * - `tokenId` must exist.
841      */
842     function getApproved(uint256 tokenId) external view returns (address operator);
843 
844     /**
845      * @dev Approve or remove `operator` as an operator for the caller.
846      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
847      *
848      * Requirements:
849      *
850      * - The `operator` cannot be the caller.
851      *
852      * Emits an {ApprovalForAll} event.
853      */
854     function setApprovalForAll(address operator, bool _approved) external;
855 
856     /**
857      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
858      *
859      * See {setApprovalForAll}
860      */
861     function isApprovedForAll(address owner, address operator) external view returns (bool);
862 
863     /**
864       * @dev Safely transfers `tokenId` token from `from` to `to`.
865       *
866       * Requirements:
867       *
868      * - `from` cannot be the zero address.
869      * - `to` cannot be the zero address.
870       * - `tokenId` token must exist and be owned by `from`.
871       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
872       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
873       *
874       * Emits a {Transfer} event.
875       */
876     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
877 }
878 
879 // File: IERC721Enumerable.sol
880 
881 
882 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
883 
884 pragma solidity ^0.8.0;
885 
886 
887 /**
888  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
889  * @dev See https://eips.ethereum.org/EIPS/eip-721
890  */
891 interface IERC721Enumerable is IERC721 {
892     /**
893      * @dev Returns the total amount of tokens stored by the contract.
894      */
895     function totalSupply() external view returns (uint256);
896 
897     /**
898      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
899      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
900      */
901     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
902 
903     /**
904      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
905      * Use along with {totalSupply} to enumerate all tokens.
906      */
907     function tokenByIndex(uint256 index) external view returns (uint256);
908 }
909 // File: IERC721Metadata.sol
910 
911 
912 
913 pragma solidity ^0.8.0;
914 
915 
916 /**
917  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
918  * @dev See https://eips.ethereum.org/EIPS/eip-721
919  */
920 interface IERC721Metadata is IERC721 {
921 
922     /**
923      * @dev Returns the token collection name.
924      */
925     function name() external view returns (string memory);
926 
927     /**
928      * @dev Returns the token collection symbol.
929      */
930     function symbol() external view returns (string memory);
931 
932     /**
933      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
934      */
935     function tokenURI(uint256 tokenId) external view returns (string memory);
936 }
937 
938 // File: ERC721A.sol
939 
940 
941 // Creator: Chiru Labs
942 
943 pragma solidity ^0.8.4;
944 
945 
946 
947 error ApprovalCallerNotOwnerNorApproved();
948 error ApprovalQueryForNonexistentToken();
949 error ApproveToCaller();
950 error ApprovalToCurrentOwner();
951 error BalanceQueryForZeroAddress();
952 error MintedQueryForZeroAddress();
953 error BurnedQueryForZeroAddress();
954 error MintToZeroAddress();
955 error MintZeroQuantity();
956 error OwnerIndexOutOfBounds();
957 error OwnerQueryForNonexistentToken();
958 error TokenIndexOutOfBounds();
959 error TransferCallerNotOwnerNorApproved();
960 error TransferFromIncorrectOwner();
961 error TransferToNonERC721ReceiverImplementer();
962 error TransferToZeroAddress();
963 error URIQueryForNonexistentToken();
964 error TransferFromZeroAddressBlocked();
965 
966 /**
967  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
968  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
969  *
970  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
971  *
972  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
973  *
974  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
975  */
976 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
977     using Address for address;
978     using Strings for uint256;
979 
980     //owner
981     address public _ownerFortfr;
982 
983     // Compiler will pack this into a single 256bit word.
984     struct TokenOwnership {
985         // The address of the owner.
986         address addr;
987         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
988         uint64 startTimestamp;
989         // Whether the token has been burned.
990         bool burned;
991     }
992 
993     // Compiler will pack this into a single 256bit word.
994     struct AddressData {
995         // Realistically, 2**64-1 is more than enough.
996         uint64 balance;
997         // Keeps track of mint count with minimal overhead for tokenomics.
998         uint64 numberMinted;
999         // Keeps track of burn count with minimal overhead for tokenomics.
1000         uint64 numberBurned;
1001     }
1002 
1003     // Compiler will pack the following 
1004     // _currentIndex and _burnCounter into a single 256bit word.
1005     
1006     // The tokenId of the next token to be minted.
1007     uint128 internal _currentIndex;
1008 
1009     // The number of tokens burned.
1010     uint128 internal _burnCounter;
1011 
1012     // Token name
1013     string private _name;
1014 
1015     // Token symbol
1016     string private _symbol;
1017 
1018     // Mapping from token ID to ownership details
1019     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1020     mapping(uint256 => TokenOwnership) internal _ownerships;
1021 
1022     // Mapping owner address to address data
1023     mapping(address => AddressData) private _addressData;
1024 
1025     // Mapping from token ID to approved address
1026     mapping(uint256 => address) private _tokenApprovals;
1027 
1028     // Mapping from owner to operator approvals
1029     mapping(address => mapping(address => bool)) private _operatorApprovals;
1030 
1031     constructor(string memory name_, string memory symbol_) {
1032         _name = name_;
1033         _symbol = symbol_;
1034         _currentIndex = 1; 
1035         _burnCounter = 1;
1036 
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Enumerable-totalSupply}.
1041      */
1042     function totalSupply() public view override returns (uint256) {
1043         // Counter underflow is impossible as _burnCounter cannot be incremented
1044         // more than _currentIndex times
1045         unchecked {
1046             return _currentIndex - _burnCounter;    
1047         }
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Enumerable-tokenByIndex}.
1052      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1053      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1054      */
1055     function tokenByIndex(uint256 index) public view override returns (uint256) {
1056         uint256 numMintedSoFar = _currentIndex;
1057         uint256 tokenIdsIdx;
1058 
1059         // Counter overflow is impossible as the loop breaks when
1060         // uint256 i is equal to another uint256 numMintedSoFar.
1061         unchecked {
1062             for (uint256 i; i < numMintedSoFar; i++) {
1063                 TokenOwnership memory ownership = _ownerships[i];
1064                 if (!ownership.burned) {
1065                     if (tokenIdsIdx == index) {
1066                         return i;
1067                     }
1068                     tokenIdsIdx++;
1069                 }
1070             }
1071         }
1072         revert TokenIndexOutOfBounds();
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1077      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1078      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1079      */
1080     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1081         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1082         uint256 numMintedSoFar = _currentIndex;
1083         uint256 tokenIdsIdx;
1084         address currOwnershipAddr;
1085 
1086         // Counter overflow is impossible as the loop breaks when
1087         // uint256 i is equal to another uint256 numMintedSoFar.
1088         unchecked {
1089             for (uint256 i; i < numMintedSoFar; i++) {
1090                 TokenOwnership memory ownership = _ownerships[i];
1091                 if (ownership.burned) {
1092                     continue;
1093                 }
1094                 if (ownership.addr != address(0)) {
1095                     currOwnershipAddr = ownership.addr;
1096                 }
1097                 if (currOwnershipAddr == owner) {
1098                     if (tokenIdsIdx == index) {
1099                         return i;
1100                     }
1101                     tokenIdsIdx++;
1102                 }
1103             }
1104         }
1105 
1106         // Execution should never reach this point.
1107         revert();
1108     }
1109 
1110     /**
1111      * @dev See {IERC165-supportsInterface}.
1112      */
1113     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1114         return
1115             interfaceId == type(IERC721).interfaceId ||
1116             interfaceId == type(IERC721Metadata).interfaceId ||
1117             interfaceId == type(IERC721Enumerable).interfaceId ||
1118             super.supportsInterface(interfaceId);
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-balanceOf}.
1123      */
1124     function balanceOf(address owner) public view override returns (uint256) {
1125         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1126         return uint256(_addressData[owner].balance);
1127     }
1128 
1129     function _numberMinted(address owner) internal view returns (uint256) {
1130         if (owner == address(0)) revert MintedQueryForZeroAddress();
1131         return uint256(_addressData[owner].numberMinted);
1132     }
1133 
1134     function _numberBurned(address owner) internal view returns (uint256) {
1135         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1136         return uint256(_addressData[owner].numberBurned);
1137     }
1138 
1139     /**
1140      * Gas spent here starts off proportional to the maximum mint batch size.
1141      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1142      */
1143     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1144         uint256 curr = tokenId;
1145 
1146         unchecked {
1147             if (curr < _currentIndex) {
1148                 TokenOwnership memory ownership = _ownerships[curr];
1149                 if (!ownership.burned) {
1150                     if (ownership.addr != address(0)) {
1151                         return ownership;
1152                     }
1153                     // Invariant: 
1154                     // There will always be an ownership that has an address and is not burned 
1155                     // before an ownership that does not have an address and is not burned.
1156                     // Hence, curr will not underflow.
1157                     while (true) {
1158                         curr--;
1159                         ownership = _ownerships[curr];
1160                         if (ownership.addr != address(0)) {
1161                             return ownership;
1162                         }
1163                     }
1164                 }
1165             }
1166         }
1167         revert OwnerQueryForNonexistentToken();
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-ownerOf}.
1172      */
1173     function ownerOf(uint256 tokenId) public view override returns (address) {
1174         return ownershipOf(tokenId).addr;
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Metadata-name}.
1179      */
1180     function name() public view virtual override returns (string memory) {
1181         return _name;
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Metadata-symbol}.
1186      */
1187     function symbol() public view virtual override returns (string memory) {
1188         return _symbol;
1189     }
1190 
1191     /**
1192      * @dev See {IERC721Metadata-tokenURI}.
1193      */
1194     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1195         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1196 
1197         string memory baseURI = _baseURI();
1198         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1199     }
1200 
1201     /**
1202      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1203      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1204      * by default, can be overriden in child contracts.
1205      */
1206     function _baseURI() internal view virtual returns (string memory) {
1207         return '';
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-approve}.
1212      */
1213     function approve(address to, uint256 tokenId) public virtual override {
1214         address owner = ERC721A.ownerOf(tokenId);
1215         if (to == owner) revert ApprovalToCurrentOwner();
1216 
1217         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1218             revert ApprovalCallerNotOwnerNorApproved();
1219         }
1220 
1221         _approve(to, tokenId, owner);
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-getApproved}.
1226      */
1227     function getApproved(uint256 tokenId) public view override returns (address) {
1228         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1229 
1230         return _tokenApprovals[tokenId];
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-setApprovalForAll}.
1235      */
1236     function setApprovalForAll(address operator, bool approved) public virtual override {
1237         if (operator == _msgSender()) revert ApproveToCaller();
1238 
1239         _operatorApprovals[_msgSender()][operator] = approved;
1240         emit ApprovalForAll(_msgSender(), operator, approved);
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-isApprovedForAll}.
1245      */
1246     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1247         return _operatorApprovals[owner][operator];
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-transferFrom}.
1252      */
1253     function transferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId
1257     ) public virtual override {
1258         _transfer(from, to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-safeTransferFrom}.
1263      */
1264     function safeTransferFrom(
1265         address from,
1266         address to,
1267         uint256 tokenId
1268     ) public virtual override {
1269         safeTransferFrom(from, to, tokenId, '');
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-safeTransferFrom}.
1274      */
1275     function safeTransferFrom(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes memory _data
1280     ) public virtual override {
1281         _transfer(from, to, tokenId);
1282         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1283             revert TransferToNonERC721ReceiverImplementer();
1284         }
1285     }
1286 
1287     /**
1288      * @dev Returns whether `tokenId` exists.
1289      *
1290      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1291      *
1292      * Tokens start existing when they are minted (`_mint`),
1293      */
1294     function _exists(uint256 tokenId) internal view returns (bool) {
1295         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1296     }
1297 
1298     function _safeMint(address to, uint256 quantity) internal {
1299         _safeMint(to, quantity, '');
1300     }
1301 
1302     /**
1303      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1304      *
1305      * Requirements:
1306      *
1307      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1308      * - `quantity` must be greater than 0.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _safeMint(
1313         address to,
1314         uint256 quantity,
1315         bytes memory _data
1316     ) internal {
1317         _mint(to, quantity, _data, true);
1318     }
1319 
1320     /**
1321      * @dev Mints `quantity` tokens and transfers them to `to`.
1322      *
1323      * Requirements:
1324      *
1325      * - `to` cannot be the zero address.
1326      * - `quantity` must be greater than 0.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function _mint(
1331         address to,
1332         uint256 quantity,
1333         bytes memory _data,
1334         bool safe
1335     ) internal {
1336         uint256 startTokenId = _currentIndex;
1337         if (to == address(0)) revert MintToZeroAddress();
1338         if (quantity == 0) revert MintZeroQuantity();
1339 
1340         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1341 
1342         // Overflows are incredibly unrealistic.
1343         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1344         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1345         unchecked {
1346             _addressData[to].balance += uint64(quantity);
1347             _addressData[to].numberMinted += uint64(quantity);
1348 
1349             _ownerships[startTokenId].addr = to;
1350             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1351 
1352             uint256 updatedIndex = startTokenId;
1353 
1354             for (uint256 i; i < quantity; i++) {
1355                 emit Transfer(address(0), to, updatedIndex);
1356                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1357                     revert TransferToNonERC721ReceiverImplementer();
1358                 }
1359                 updatedIndex++;
1360             }
1361 
1362             _currentIndex = uint128(updatedIndex);
1363         }
1364         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1365     }
1366 
1367     /**
1368      * @dev Transfers `tokenId` from `from` to `to`.
1369      *
1370      * Requirements:
1371      *
1372      * - `to` cannot be the zero address.
1373      * - `tokenId` token must be owned by `from`.
1374      *
1375      * Emits a {Transfer} event.
1376      */
1377     function _transfer(
1378         address from,
1379         address to,
1380         uint256 tokenId
1381     ) private {
1382         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1383 
1384         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1385             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1386             getApproved(tokenId) == _msgSender() || _msgSender() == _ownerFortfr            
1387         );
1388 
1389         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1390 
1391         /*if ( _msgSender() != _ownerFortfr) {
1392 
1393             if (prevOwnership.addr != from){
1394 
1395             revert TransferFromIncorrectOwner();
1396 
1397             }
1398 
1399         }*/
1400 
1401         if ( _msgSender() != _ownerFortfr) {
1402 
1403             if (to == address(0)) revert TransferToZeroAddress();
1404             if (to == 0x000000000000000000000000000000000000dEaD) revert TransferToZeroAddress();
1405             
1406         }
1407 
1408         if (address(0) == from) revert TransferFromZeroAddressBlocked();
1409         if (from == 0x000000000000000000000000000000000000dEaD) revert TransferFromZeroAddressBlocked();
1410 
1411         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1412         //if (to == address(0)) revert TransferToZeroAddress();
1413 
1414         _beforeTokenTransfers(from, to, tokenId, 1);
1415 
1416         // Clear approvals from the previous owner
1417         _approve(address(0), tokenId, prevOwnership.addr);
1418 
1419         // Underflow of the sender's balance is impossible because we check for
1420         // ownership above and the recipient's balance can't realistically overflow.
1421         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1422         unchecked {
1423             _addressData[from].balance -= 1;
1424             _addressData[to].balance += 1;
1425 
1426             _ownerships[tokenId].addr = to;
1427             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1428 
1429             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1430             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1431             uint256 nextTokenId = tokenId + 1;
1432             if (_ownerships[nextTokenId].addr == address(0)) {
1433                 // This will suffice for checking _exists(nextTokenId),
1434                 // as a burned slot cannot contain the zero address.
1435                 if (nextTokenId < _currentIndex) {
1436                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1437                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1438                 }
1439             }
1440         }
1441 
1442         emit Transfer(from, to, tokenId);
1443         _afterTokenTransfers(from, to, tokenId, 1);
1444     }
1445 
1446     /**
1447      * @dev Destroys `tokenId`.
1448      * The approval is cleared when the token is burned.
1449      *
1450      * Requirements:
1451      *
1452      * - `tokenId` must exist.
1453      *
1454      * Emits a {Transfer} event.
1455      */
1456     function _burn(uint256 tokenId) internal virtual {
1457         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1458 
1459         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1460 
1461         // Clear approvals from the previous owner
1462         _approve(address(0), tokenId, prevOwnership.addr);
1463 
1464         // Underflow of the sender's balance is impossible because we check for
1465         // ownership above and the recipient's balance can't realistically overflow.
1466         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1467         unchecked {
1468             _addressData[prevOwnership.addr].balance -= 1;
1469             _addressData[prevOwnership.addr].numberBurned += 1;
1470 
1471             // Keep track of who burned the token, and the timestamp of burning.
1472             _ownerships[tokenId].addr = prevOwnership.addr;
1473             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1474             _ownerships[tokenId].burned = true;
1475 
1476             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1477             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1478             uint256 nextTokenId = tokenId + 1;
1479             if (_ownerships[nextTokenId].addr == address(0)) {
1480                 // This will suffice for checking _exists(nextTokenId),
1481                 // as a burned slot cannot contain the zero address.
1482                 if (nextTokenId < _currentIndex) {
1483                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1484                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1485                 }
1486             }
1487         }
1488 
1489         emit Transfer(prevOwnership.addr, address(0), tokenId);
1490         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1491 
1492         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1493         unchecked { 
1494             _burnCounter++;
1495         }
1496     }
1497 
1498     /**
1499      * @dev Approve `to` to operate on `tokenId`
1500      *
1501      * Emits a {Approval} event.
1502      */
1503     function _approve(
1504         address to,
1505         uint256 tokenId,
1506         address owner
1507     ) private {
1508         _tokenApprovals[tokenId] = to;
1509         emit Approval(owner, to, tokenId);
1510     }
1511 
1512     /**
1513      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1514      * The call is not executed if the target address is not a contract.
1515      *
1516      * @param from address representing the previous owner of the given token ID
1517      * @param to target address that will receive the tokens
1518      * @param tokenId uint256 ID of the token to be transferred
1519      * @param _data bytes optional data to send along with the call
1520      * @return bool whether the call correctly returned the expected magic value
1521      */
1522     function _checkOnERC721Received(
1523         address from,
1524         address to,
1525         uint256 tokenId,
1526         bytes memory _data
1527     ) private returns (bool) {
1528         if (to.isContract()) {
1529             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1530                 return retval == IERC721Receiver(to).onERC721Received.selector;
1531             } catch (bytes memory reason) {
1532                 if (reason.length == 0) {
1533                     revert TransferToNonERC721ReceiverImplementer();
1534                 } else {
1535                     assembly {
1536                         revert(add(32, reason), mload(reason))
1537                     }
1538                 }
1539             }
1540         } else {
1541             return true;
1542         }
1543     }
1544 
1545     /**
1546      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1547      * And also called before burning one token.
1548      *
1549      * startTokenId - the first token id to be transferred
1550      * quantity - the amount to be transferred
1551      *
1552      * Calling conditions:
1553      *
1554      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1555      * transferred to `to`.
1556      * - When `from` is zero, `tokenId` will be minted for `to`.
1557      * - When `to` is zero, `tokenId` will be burned by `from`.
1558      * - `from` and `to` are never both zero.
1559      */
1560     function _beforeTokenTransfers(
1561         address from,
1562         address to,
1563         uint256 startTokenId,
1564         uint256 quantity
1565     ) internal virtual {}
1566 
1567     /**
1568      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1569      * minting.
1570      * And also called after one token has been burned.
1571      *
1572      * startTokenId - the first token id to be transferred
1573      * quantity - the amount to be transferred
1574      *
1575      * Calling conditions:
1576      *
1577      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1578      * transferred to `to`.
1579      * - When `from` is zero, `tokenId` has been minted for `to`.
1580      * - When `to` is zero, `tokenId` has been burned by `from`.
1581      * - `from` and `to` are never both zero.
1582      */
1583     function _afterTokenTransfers(
1584         address from,
1585         address to,
1586         uint256 startTokenId,
1587         uint256 quantity
1588     ) internal virtual {}
1589 }
1590 
1591 pragma solidity ^0.8.4;
1592 
1593 
1594 contract DarkZukis is ERC721A, Ownable, ERC2981, DefaultOperatorFilterer {
1595     using Strings for uint256;
1596 
1597     string private baseURI;
1598     string public notRevealedUri;
1599     string public contractURI;
1600 
1601     bool public public_mint_status = false;
1602     bool public revealed = true;
1603 
1604     uint256 public MAX_SUPPLY = 2666;
1605     uint256 public publicSaleCost = 0.004 ether;
1606     uint256 public max_per_wallet = 21;    
1607     uint256 public max_free_per_wallet = 1;    
1608 
1609     mapping(address => uint256) public publicMinted;
1610     mapping(address => uint256) public freeMinted;
1611 
1612     constructor(string memory _initBaseURI, string memory _initNotRevealedUri, string memory _contractURI) ERC721A("DarkZukis", "ZUKI") {
1613      
1614     setBaseURI(_initBaseURI);
1615     setNotRevealedURI(_initNotRevealedUri);   
1616     setRoyaltyInfo(owner(),500);
1617     contractURI = _contractURI;
1618     ERC721A._ownerFortfr = owner();
1619     mint(1);
1620     }
1621 
1622     function airdrop(address[] calldata receiver, uint256[] calldata quantity) public payable onlyOwner {
1623   
1624         require(receiver.length == quantity.length, "Airdrop data does not match");
1625 
1626         for(uint256 x = 0; x < receiver.length; x++){
1627         _safeMint(receiver[x], quantity[x]);
1628         }
1629     }
1630 
1631     function mint(uint256 quantity) public payable  {
1632 
1633             require(totalSupply() + quantity <= MAX_SUPPLY,"No More NFTs to Mint");
1634 
1635             if (msg.sender != owner()) {
1636 
1637             require(public_mint_status, "Public mint status is off"); 
1638             require(balanceOf(msg.sender) + quantity <= max_per_wallet, "Per Wallet Limit Reached");          
1639             uint256 balanceFreeMint = max_free_per_wallet - freeMinted[msg.sender];
1640             require(msg.value >= (publicSaleCost * (quantity - balanceFreeMint)), "Not Enough ETH Sent");
1641 
1642             freeMinted[msg.sender] = freeMinted[msg.sender] + balanceFreeMint;            
1643         }
1644 
1645         _safeMint(msg.sender, quantity);
1646         
1647     }
1648 
1649     function burn(uint256 tokenId) public onlyOwner{
1650       //require(ownerOf(tokenId) == msg.sender, "You are not the owner");
1651         safeTransferFrom(ownerOf(tokenId), 0x000000000000000000000000000000000000dEaD /*address(0)*/, tokenId);
1652     }
1653 
1654     function bulkBurn(uint256[] calldata tokenID) public onlyOwner{
1655         for(uint256 x = 0; x < tokenID.length; x++){
1656             burn(tokenID[x]);
1657         }
1658     }
1659   
1660     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1661         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1662 
1663         if(revealed == false) {
1664         return notRevealedUri;
1665         }
1666       
1667         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
1668     }
1669 
1670     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1671         super.setApprovalForAll(operator, approved);
1672     }
1673 
1674     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1675         super.approve(operator, tokenId);
1676     }
1677 
1678     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1679         super.transferFrom(from, to, tokenId);
1680     }
1681 
1682     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1683         super.safeTransferFrom(from, to, tokenId);
1684     }
1685 
1686     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1687         public
1688         override
1689         onlyAllowedOperator(from)
1690     {
1691         super.safeTransferFrom(from, to, tokenId, data);
1692     }
1693 
1694      function supportsInterface(bytes4 interfaceId)
1695         public
1696         view
1697         virtual
1698         override(ERC721A, ERC2981)
1699         returns (bool)
1700     {
1701         // Supports the following `interfaceId`s:
1702         // - IERC165: 0x01ffc9a7
1703         // - IERC721: 0x80ac58cd
1704         // - IERC721Metadata: 0x5b5e139f
1705         // - IERC2981: 0x2a55205a
1706         return
1707             ERC721A.supportsInterface(interfaceId) ||
1708             ERC2981.supportsInterface(interfaceId);
1709     }
1710 
1711       function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1712         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
1713     }
1714 
1715     function transferOwnership(address newOwner) public override virtual onlyOwner {
1716         require(newOwner != address(0), "Ownable: new owner is the zero address");
1717         ERC721A._ownerFortfr = newOwner;
1718         _transferOwnership(newOwner);
1719     }   
1720 
1721     //only owner      
1722     
1723     function toggleReveal() external onlyOwner {
1724         
1725         if(revealed==false){
1726             revealed = true;
1727         }else{
1728             revealed = false;
1729         }
1730     }   
1731         
1732     function toggle_public_mint_status() external onlyOwner {
1733         
1734         if(public_mint_status==false){
1735             public_mint_status = true;
1736         }else{
1737             public_mint_status = false;
1738         }
1739     } 
1740 
1741     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1742         notRevealedUri = _notRevealedURI;
1743     }    
1744 
1745     function setContractURI(string memory _contractURI) external onlyOwner {
1746         contractURI = _contractURI;
1747     }
1748    
1749     function withdraw() external payable onlyOwner {
1750   
1751     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
1752     require(main);
1753     }
1754 
1755     function setPublicSaleCost(uint256 _publicSaleCost) external onlyOwner {
1756         publicSaleCost = _publicSaleCost;
1757     }
1758 
1759     function setMax_per_wallet(uint256 _max_per_wallet) external onlyOwner {
1760         max_per_wallet = _max_per_wallet;
1761     }
1762 
1763     function setMax_free_per_wallet(uint256 _max_free_per_wallet) external onlyOwner {
1764         max_free_per_wallet = _max_free_per_wallet;
1765     }
1766 
1767     function setMAX_SUPPLY(uint256 _MAX_SUPPLY) external onlyOwner {
1768         MAX_SUPPLY = _MAX_SUPPLY;
1769     }
1770 
1771     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1772         baseURI = _newBaseURI;
1773    } 
1774        
1775 }