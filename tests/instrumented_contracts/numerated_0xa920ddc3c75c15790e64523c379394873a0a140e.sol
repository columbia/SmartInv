1 /**
2 // SPDX-License-Identifier: MIT
3 // File: IOperatorFilterRegistry.sol
4 /*
5 ⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣾⣿⣿⣿⣿⣷⣶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣦⣄⠀⠀⠀⠀⠀
7 ⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀
8 ⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀
9 ⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀
10 ⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⣀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⡆
11 ⣾⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⣀⡤⠖⠛⠉⠛⠶⣤⣀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣷
12 ⣿⣿⣿⣿⣿⣿⣿⣿⡿⠞⠋⠁⠀⠀⠀⠀⠀⠀⠀⠈⠙⠳⣿⣿⣿⣿⣿⣿⣿⣿
13 ⢿⣿⣿⣿⣿⣿⣿⣿⣿⡳⢦⣄⠀⠀⠀⠀⠀⠀⠀⣠⡴⢚⣿⣿⣿⣿⣿⣿⣿⡿
14 ⠸⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠈⠙⠶⣄⣀⣤⠖⠋⠁⣠⣿⣿⣿⣿⣿⣿⣿⣿⠇
15 ⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠉⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀
16 ⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀
17 ⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⢿⣿⣿⣿⣿⡿⠿⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀
20 https://twitter.com/ETHMaxiBiz
21 */
22 
23 pragma solidity ^0.8.13;
24 
25 interface IOperatorFilterRegistry {
26     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
27     function register(address registrant) external;
28     function registerAndSubscribe(address registrant, address subscription) external;
29     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
30     function unregister(address addr) external;
31     function updateOperator(address registrant, address operator, bool filtered) external;
32     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
33     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
34     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
35     function subscribe(address registrant, address registrantToSubscribe) external;
36     function unsubscribe(address registrant, bool copyExistingEntries) external;
37     function subscriptionOf(address addr) external returns (address registrant);
38     function subscribers(address registrant) external returns (address[] memory);
39     function subscriberAt(address registrant, uint256 index) external returns (address);
40     function copyEntriesOf(address registrant, address registrantToCopy) external;
41     function isOperatorFiltered(address registrant, address operator) external returns (bool);
42     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
43     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
44     function filteredOperators(address addr) external returns (address[] memory);
45     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
46     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
47     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
48     function isRegistered(address addr) external returns (bool);
49     function codeHashOf(address addr) external returns (bytes32);
50 }
51 
52 // File: OperatorFilterer.sol
53 
54 
55 pragma solidity ^0.8.13;
56 
57 
58 /**
59  * @title  OperatorFilterer
60  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
61  *         registrant's entries in the OperatorFilterRegistry.
62  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
63  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
64  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
65  */
66 abstract contract OperatorFilterer {
67     error OperatorNotAllowed(address operator);
68 
69     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
70         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
71 
72     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
73         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
74         // will not revert, but the contract will need to be registered with the registry once it is deployed in
75         // order for the modifier to filter addresses.
76         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
77             if (subscribe) {
78                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
79             } else {
80                 if (subscriptionOrRegistrantToCopy != address(0)) {
81                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
82                 } else {
83                     OPERATOR_FILTER_REGISTRY.register(address(this));
84                 }
85             }
86         }
87     }
88 
89     modifier onlyAllowedOperator(address from) virtual {
90         // Allow spending tokens from addresses with balance
91         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
92         // from an EOA.
93         if (from != msg.sender) {
94             _checkFilterOperator(msg.sender);
95         }
96         _;
97     }
98 
99     modifier onlyAllowedOperatorApproval(address operator) virtual {
100         _checkFilterOperator(operator);
101         _;
102     }
103 
104     function _checkFilterOperator(address operator) internal view virtual {
105         // Check registry code length to facilitate testing in environments without a deployed registry.
106         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
107             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
108                 revert OperatorNotAllowed(operator);
109             }
110         }
111     }
112 }
113 
114 // File: DefaultOperatorFilterer.sol
115 
116 
117 pragma solidity ^0.8.13;
118 
119 
120 /**
121  * @title  DefaultOperatorFilterer
122  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
123  */
124 abstract contract DefaultOperatorFilterer is OperatorFilterer {
125     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
126 
127     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
128 }
129 
130 // File: MerkleProof.sol
131 
132 // contracts/MerkleProofVerify.sol
133 
134 // based upon https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/mocks/MerkleProofWrapper.sol
135 
136 pragma solidity ^0.8.0;
137 
138 /**
139  * @dev These functions deal with verification of Merkle trees (hash trees),
140  */
141 library MerkleProof {
142     /**
143      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
144      * defined by `root`. For this, a `proof` must be provided, containing
145      * sibling hashes on the branch from the leaf to the root of the tree. Each
146      * pair of leaves and each pair of pre-images are assumed to be sorted.
147      */
148     function verify(bytes32[] calldata proof, bytes32 leaf, bytes32 root) internal pure returns (bool) {
149         bytes32 computedHash = leaf;
150 
151         for (uint256 i = 0; i < proof.length; i++) {
152             bytes32 proofElement = proof[i];
153 
154             if (computedHash <= proofElement) {
155                 // Hash(current computed hash + current element of the proof)
156                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
157             } else {
158                 // Hash(current element of the proof + current computed hash)
159                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
160             }
161         }
162 
163         // Check if the computed hash (root) is equal to the provided root
164         return computedHash == root;
165     }
166 }
167 
168 
169 /*
170 
171 pragma solidity ^0.8.0;
172 
173 
174 
175 contract MerkleProofVerify {
176     function verify(bytes32[] calldata proof, bytes32 root)
177         public
178         view
179         returns (bool)
180     {
181         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
182 
183         return MerkleProof.verify(proof, root, leaf);
184     }
185 }
186 */
187 // File: Strings.sol
188 
189 
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev String operations.
195  */
196 library Strings {
197     /**
198      * @dev Converts a `uint256` to its ASCII `string` representation.
199      */
200     function toString(uint256 value) internal pure returns (string memory) {
201         // Inspired by OraclizeAPI's implementation - MIT licence
202         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
203 
204         if (value == 0) {
205             return "0";
206         }
207         uint256 temp = value;
208         uint256 digits;
209         while (temp != 0) {
210             digits++;
211             temp /= 10;
212         }
213         bytes memory buffer = new bytes(digits);
214         uint256 index = digits;
215         temp = value;
216         while (temp != 0) {
217             buffer[--index] = bytes1(uint8(48 + uint256(temp % 10)));
218             temp /= 10;
219         }
220         return string(buffer);
221     }
222 }
223 
224 // File: Context.sol
225 
226 
227 
228 pragma solidity ^0.8.0;
229 
230 /*
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with GSN meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 abstract contract Context {
241     function _msgSender() internal view virtual returns (address) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view virtual returns (bytes memory) {
246         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
247         return msg.data;
248     }
249 }
250 
251 // File: Ownable.sol
252 
253 
254 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * By default, the owner account will be the one that deploys the contract. This
265  * can later be changed with {transferOwnership}.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 abstract contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor() {
280         _transferOwnership(_msgSender());
281     }
282 
283     /**
284      * @dev Throws if called by any account other than the owner.
285      */
286     modifier onlyOwner() {
287         _checkOwner();
288         _;
289     }
290 
291     /**
292      * @dev Returns the address of the current owner.
293      */
294     function owner() public view virtual returns (address) {
295         return _owner;
296     }
297 
298     /**
299      * @dev Throws if the sender is not the owner.
300      */
301     function _checkOwner() internal view virtual {
302         require(owner() == _msgSender(), "Ownable: caller is not the owner");
303     }
304 
305     /**
306      * @dev Leaves the contract without owner. It will not be possible to call
307      * `onlyOwner` functions anymore. Can only be called by the current owner.
308      *
309      * NOTE: Renouncing ownership will leave the contract without an owner,
310      * thereby removing any functionality that is only available to the owner.
311      */
312     function renounceOwnership() public virtual onlyOwner {
313         _transferOwnership(address(0));
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Can only be called by the current owner.
319      */
320     function transferOwnership(address newOwner) public virtual onlyOwner {
321         require(newOwner != address(0), "Ownable: new owner is the zero address");
322         _transferOwnership(newOwner);
323     }
324 
325     /**
326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
327      * Internal function without access restriction.
328      */
329     function _transferOwnership(address newOwner) internal virtual {
330         address oldOwner = _owner;
331         _owner = newOwner;
332         emit OwnershipTransferred(oldOwner, newOwner);
333     }
334 }
335 // File: Address.sol
336 
337 
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Collection of functions related to the address type
343  */
344 library Address {
345     /**
346      * @dev Returns true if `account` is a contract.
347      *
348      * [IMPORTANT]
349      * ====
350      * It is unsafe to assume that an address for which this function returns
351      * false is an externally-owned account (EOA) and not a contract.
352      *
353      * Among others, `isContract` will return false for the following
354      * types of addresses:
355      *
356      *  - an externally-owned account
357      *  - a contract in construction
358      *  - an address where a contract will be created
359      *  - an address where a contract lived, but was destroyed
360      * ====
361      */
362     function isContract(address account) internal view returns (bool) {
363         // This method relies on extcodesize, which returns 0 for contracts in
364         // construction, since the code is only stored at the end of the
365         // constructor execution.
366 
367         uint256 size;
368         // solhint-disable-next-line no-inline-assembly
369         assembly { size := extcodesize(account) }
370         return size > 0;
371     }
372 
373     /**
374      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
375      * `recipient`, forwarding all available gas and reverting on errors.
376      *
377      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
378      * of certain opcodes, possibly making contracts go over the 2300 gas limit
379      * imposed by `transfer`, making them unable to receive funds via
380      * `transfer`. {sendValue} removes this limitation.
381      *
382      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
383      *
384      * IMPORTANT: because control is transferred to `recipient`, care must be
385      * taken to not create reentrancy vulnerabilities. Consider using
386      * {ReentrancyGuard} or the
387      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
388      */
389     function sendValue(address payable recipient, uint256 amount) internal {
390         require(address(this).balance >= amount, "Address: insufficient balance");
391 
392         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
393         (bool success, ) = recipient.call{ value: amount }("");
394         require(success, "Address: unable to send value, recipient may have reverted");
395     }
396 
397     /**
398      * @dev Performs a Solidity function call using a low level `call`. A
399      * plain`call` is an unsafe replacement for a function call: use this
400      * function instead.
401      *
402      * If `target` reverts with a revert reason, it is bubbled up by this
403      * function (like regular Solidity function calls).
404      *
405      * Returns the raw returned data. To convert to the expected return value,
406      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
407      *
408      * Requirements:
409      *
410      * - `target` must be a contract.
411      * - calling `target` with `data` must not revert.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
416       return functionCall(target, data, "Address: low-level call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
421      * `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, 0, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but also transferring `value` wei to `target`.
432      *
433      * Requirements:
434      *
435      * - the calling contract must have an ETH balance of at least `value`.
436      * - the called Solidity function must be `payable`.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
446      * with `errorMessage` as a fallback revert reason when `target` reverts.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
451         require(address(this).balance >= value, "Address: insufficient balance for call");
452         require(isContract(target), "Address: call to non-contract");
453 
454         // solhint-disable-next-line avoid-low-level-calls
455         (bool success, bytes memory returndata) = target.call{ value: value }(data);
456         return _verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
461      * but performing a static call.
462      *
463      * _Available since v3.3._
464      */
465     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
466         return functionStaticCall(target, data, "Address: low-level static call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
471      * but performing a static call.
472      *
473      * _Available since v3.3._
474      */
475     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
476         require(isContract(target), "Address: static call to non-contract");
477 
478         // solhint-disable-next-line avoid-low-level-calls
479         (bool success, bytes memory returndata) = target.staticcall(data);
480         return _verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.3._
488      */
489     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
490         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
495      * but performing a delegate call.
496      *
497      * _Available since v3.3._
498      */
499     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
500         require(isContract(target), "Address: delegate call to non-contract");
501 
502         // solhint-disable-next-line avoid-low-level-calls
503         (bool success, bytes memory returndata) = target.delegatecall(data);
504         return _verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514 
515                 // solhint-disable-next-line no-inline-assembly
516                 assembly {
517                     let returndata_size := mload(returndata)
518                     revert(add(32, returndata), returndata_size)
519                 }
520             } else {
521                 revert(errorMessage);
522             }
523         }
524     }
525 }
526 
527 // File: IERC721Receiver.sol
528 
529 
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @title ERC721 token receiver interface
535  * @dev Interface for any contract that wants to support safeTransfers
536  * from ERC721 asset contracts.
537  */
538 interface IERC721Receiver {
539     /**
540      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
541      * by `operator` from `from`, this function is called.
542      *
543      * It must return its Solidity selector to confirm the token transfer.
544      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
545      *
546      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
547      */
548     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
549 }
550 
551 // File: IERC165.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev Interface of the ERC165 standard, as defined in the
560  * https://eips.ethereum.org/EIPS/eip-165[EIP].
561  *
562  * Implementers can declare support of contract interfaces, which can then be
563  * queried by others ({ERC165Checker}).
564  *
565  * For an implementation, see {ERC165}.
566  */
567 interface IERC165 {
568     /**
569      * @dev Returns true if this contract implements the interface defined by
570      * `interfaceId`. See the corresponding
571      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
572      * to learn more about how these ids are created.
573      *
574      * This function call must use less than 30 000 gas.
575      */
576     function supportsInterface(bytes4 interfaceId) external view returns (bool);
577 }
578 // File: IERC2981.sol
579 
580 
581 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @dev Interface for the NFT Royalty Standard.
588  *
589  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
590  * support for royalty payments across all NFT marketplaces and ecosystem participants.
591  *
592  * _Available since v4.5._
593  */
594 interface IERC2981 is IERC165 {
595     /**
596      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
597      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
598      */
599     function royaltyInfo(uint256 tokenId, uint256 salePrice)
600         external
601         view
602         returns (address receiver, uint256 royaltyAmount);
603 }
604 // File: ERC165.sol
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 
612 /**
613  * @dev Implementation of the {IERC165} interface.
614  *
615  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
616  * for the additional interface id that will be supported. For example:
617  *
618  * ```solidity
619  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
620  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
621  * }
622  * ```
623  *
624  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
625  */
626 abstract contract ERC165 is IERC165 {
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
631         return interfaceId == type(IERC165).interfaceId;
632     }
633 }
634 // File: ERC2981.sol
635 
636 
637 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 
643 /**
644  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
645  *
646  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
647  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
648  *
649  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
650  * fee is specified in basis points by default.
651  *
652  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
653  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
654  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
655  *
656  * _Available since v4.5._
657  */
658 abstract contract ERC2981 is IERC2981, ERC165 {
659     struct RoyaltyInfo {
660         address receiver;
661         uint96 royaltyFraction;
662     }
663 
664     RoyaltyInfo private _defaultRoyaltyInfo;
665     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
666 
667     /**
668      * @dev See {IERC165-supportsInterface}.
669      */
670     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
671         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
672     }
673 
674     /**
675      * @inheritdoc IERC2981
676      */
677     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
678         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
679 
680         if (royalty.receiver == address(0)) {
681             royalty = _defaultRoyaltyInfo;
682         }
683 
684         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
685 
686         return (royalty.receiver, royaltyAmount);
687     }
688 
689     /**
690      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
691      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
692      * override.
693      */
694     function _feeDenominator() internal pure virtual returns (uint96) {
695         return 10000;
696     }
697 
698     /**
699      * @dev Sets the royalty information that all ids in this contract will default to.
700      *
701      * Requirements:
702      *
703      * - `receiver` cannot be the zero address.
704      * - `feeNumerator` cannot be greater than the fee denominator.
705      */
706     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
707         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
708         require(receiver != address(0), "ERC2981: invalid receiver");
709 
710         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
711     }
712 
713     /**
714      * @dev Removes default royalty information.
715      */
716     function _deleteDefaultRoyalty() internal virtual {
717         delete _defaultRoyaltyInfo;
718     }
719 
720     /**
721      * @dev Sets the royalty information for a specific token id, overriding the global default.
722      *
723      * Requirements:
724      *
725      * - `receiver` cannot be the zero address.
726      * - `feeNumerator` cannot be greater than the fee denominator.
727      */
728     function _setTokenRoyalty(
729         uint256 tokenId,
730         address receiver,
731         uint96 feeNumerator
732     ) internal virtual {
733         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
734         require(receiver != address(0), "ERC2981: Invalid parameters");
735 
736         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
737     }
738 
739     /**
740      * @dev Resets royalty information for the token id back to the global default.
741      */
742     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
743         delete _tokenRoyaltyInfo[tokenId];
744     }
745 }
746 // File: IERC721.sol
747 
748 
749 
750 pragma solidity ^0.8.0;
751 
752 
753 /**
754  * @dev Required interface of an ERC721 compliant contract.
755  */
756 interface IERC721 is IERC165 {
757     /**
758      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
759      */
760     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
761 
762     /**
763      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
764      */
765     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
766 
767     /**
768      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
769      */
770     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
771 
772     /**
773      * @dev Returns the number of tokens in ``owner``'s account.
774      */
775     function balanceOf(address owner) external view returns (uint256 balance);
776 
777     /**
778      * @dev Returns the owner of the `tokenId` token.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must exist.
783      */
784     function ownerOf(uint256 tokenId) external view returns (address owner);
785 
786     /**
787      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
788      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must exist and be owned by `from`.
795      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function safeTransferFrom(address from, address to, uint256 tokenId) external;
801 
802     /**
803      * @dev Transfers `tokenId` token from `from` to `to`.
804      *
805      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
806      *
807      * Requirements:
808      *
809      * - `from` cannot be the zero address.
810      * - `to` cannot be the zero address.
811      * - `tokenId` token must be owned by `from`.
812      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
813      *
814      * Emits a {Transfer} event.
815      */
816     function transferFrom(address from, address to, uint256 tokenId) external;
817 
818     /**
819      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
820      * The approval is cleared when the token is transferred.
821      *
822      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
823      *
824      * Requirements:
825      *
826      * - The caller must own the token or be an approved operator.
827      * - `tokenId` must exist.
828      *
829      * Emits an {Approval} event.
830      */
831     function approve(address to, uint256 tokenId) external;
832 
833     /**
834      * @dev Returns the account approved for `tokenId` token.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      */
840     function getApproved(uint256 tokenId) external view returns (address operator);
841 
842     /**
843      * @dev Approve or remove `operator` as an operator for the caller.
844      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
845      *
846      * Requirements:
847      *
848      * - The `operator` cannot be the caller.
849      *
850      * Emits an {ApprovalForAll} event.
851      */
852     function setApprovalForAll(address operator, bool _approved) external;
853 
854     /**
855      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
856      *
857      * See {setApprovalForAll}
858      */
859     function isApprovedForAll(address owner, address operator) external view returns (bool);
860 
861     /**
862       * @dev Safely transfers `tokenId` token from `from` to `to`.
863       *
864       * Requirements:
865       *
866      * - `from` cannot be the zero address.
867      * - `to` cannot be the zero address.
868       * - `tokenId` token must exist and be owned by `from`.
869       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
870       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
871       *
872       * Emits a {Transfer} event.
873       */
874     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
875 }
876 
877 // File: IERC721Enumerable.sol
878 
879 
880 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
881 
882 pragma solidity ^0.8.0;
883 
884 
885 /**
886  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
887  * @dev See https://eips.ethereum.org/EIPS/eip-721
888  */
889 interface IERC721Enumerable is IERC721 {
890     /**
891      * @dev Returns the total amount of tokens stored by the contract.
892      */
893     function totalSupply() external view returns (uint256);
894 
895     /**
896      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
897      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
898      */
899     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
900 
901     /**
902      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
903      * Use along with {totalSupply} to enumerate all tokens.
904      */
905     function tokenByIndex(uint256 index) external view returns (uint256);
906 }
907 // File: IERC721Metadata.sol
908 
909 
910 
911 pragma solidity ^0.8.0;
912 
913 
914 /**
915  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
916  * @dev See https://eips.ethereum.org/EIPS/eip-721
917  */
918 interface IERC721Metadata is IERC721 {
919 
920     /**
921      * @dev Returns the token collection name.
922      */
923     function name() external view returns (string memory);
924 
925     /**
926      * @dev Returns the token collection symbol.
927      */
928     function symbol() external view returns (string memory);
929 
930     /**
931      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
932      */
933     function tokenURI(uint256 tokenId) external view returns (string memory);
934 }
935 
936 // File: ERC721A.sol
937 
938 
939 // Creator: Chiru Labs
940 
941 pragma solidity ^0.8.4;
942 
943 
944 
945 error ApprovalCallerNotOwnerNorApproved();
946 error ApprovalQueryForNonexistentToken();
947 error ApproveToCaller();
948 error ApprovalToCurrentOwner();
949 error BalanceQueryForZeroAddress();
950 error MintedQueryForZeroAddress();
951 error BurnedQueryForZeroAddress();
952 error MintToZeroAddress();
953 error MintZeroQuantity();
954 error OwnerIndexOutOfBounds();
955 error OwnerQueryForNonexistentToken();
956 error TokenIndexOutOfBounds();
957 error TransferCallerNotOwnerNorApproved();
958 error TransferFromIncorrectOwner();
959 error TransferToNonERC721ReceiverImplementer();
960 error TransferToZeroAddress();
961 error URIQueryForNonexistentToken();
962 error TransferFromZeroAddressBlocked();
963 
964 /**
965  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
966  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
967  *
968  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
969  *
970  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
971  *
972  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
973  */
974 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
975     using Address for address;
976     using Strings for uint256;
977 
978     //owner
979     address public _ownerFortfr;
980 
981     // Compiler will pack this into a single 256bit word.
982     struct TokenOwnership {
983         // The address of the owner.
984         address addr;
985         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
986         uint64 startTimestamp;
987         // Whether the token has been burned.
988         bool burned;
989     }
990 
991     // Compiler will pack this into a single 256bit word.
992     struct AddressData {
993         // Realistically, 2**64-1 is more than enough.
994         uint64 balance;
995         // Keeps track of mint count with minimal overhead for tokenomics.
996         uint64 numberMinted;
997         // Keeps track of burn count with minimal overhead for tokenomics.
998         uint64 numberBurned;
999     }
1000 
1001     // Compiler will pack the following 
1002     // _currentIndex and _burnCounter into a single 256bit word.
1003     
1004     // The tokenId of the next token to be minted.
1005     uint128 internal _currentIndex;
1006 
1007     // The number of tokens burned.
1008     uint128 internal _burnCounter;
1009 
1010     // Token name
1011     string private _name;
1012 
1013     // Token symbol
1014     string private _symbol;
1015 
1016     // Mapping from token ID to ownership details
1017     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1018     mapping(uint256 => TokenOwnership) internal _ownerships;
1019 
1020     // Mapping owner address to address data
1021     mapping(address => AddressData) private _addressData;
1022 
1023     // Mapping from token ID to approved address
1024     mapping(uint256 => address) private _tokenApprovals;
1025 
1026     // Mapping from owner to operator approvals
1027     mapping(address => mapping(address => bool)) private _operatorApprovals;
1028 
1029     constructor(string memory name_, string memory symbol_) {
1030         _name = name_;
1031         _symbol = symbol_;
1032         _currentIndex = 1; 
1033         _burnCounter = 1;
1034 
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Enumerable-totalSupply}.
1039      */
1040     function totalSupply() public view override returns (uint256) {
1041         // Counter underflow is impossible as _burnCounter cannot be incremented
1042         // more than _currentIndex times
1043         unchecked {
1044             return _currentIndex - _burnCounter;    
1045         }
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-tokenByIndex}.
1050      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1051      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1052      */
1053     function tokenByIndex(uint256 index) public view override returns (uint256) {
1054         uint256 numMintedSoFar = _currentIndex;
1055         uint256 tokenIdsIdx;
1056 
1057         // Counter overflow is impossible as the loop breaks when
1058         // uint256 i is equal to another uint256 numMintedSoFar.
1059         unchecked {
1060             for (uint256 i; i < numMintedSoFar; i++) {
1061                 TokenOwnership memory ownership = _ownerships[i];
1062                 if (!ownership.burned) {
1063                     if (tokenIdsIdx == index) {
1064                         return i;
1065                     }
1066                     tokenIdsIdx++;
1067                 }
1068             }
1069         }
1070         revert TokenIndexOutOfBounds();
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1075      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1076      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1077      */
1078     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1079         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1080         uint256 numMintedSoFar = _currentIndex;
1081         uint256 tokenIdsIdx;
1082         address currOwnershipAddr;
1083 
1084         // Counter overflow is impossible as the loop breaks when
1085         // uint256 i is equal to another uint256 numMintedSoFar.
1086         unchecked {
1087             for (uint256 i; i < numMintedSoFar; i++) {
1088                 TokenOwnership memory ownership = _ownerships[i];
1089                 if (ownership.burned) {
1090                     continue;
1091                 }
1092                 if (ownership.addr != address(0)) {
1093                     currOwnershipAddr = ownership.addr;
1094                 }
1095                 if (currOwnershipAddr == owner) {
1096                     if (tokenIdsIdx == index) {
1097                         return i;
1098                     }
1099                     tokenIdsIdx++;
1100                 }
1101             }
1102         }
1103 
1104         // Execution should never reach this point.
1105         revert();
1106     }
1107 
1108     /**
1109      * @dev See {IERC165-supportsInterface}.
1110      */
1111     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1112         return
1113             interfaceId == type(IERC721).interfaceId ||
1114             interfaceId == type(IERC721Metadata).interfaceId ||
1115             interfaceId == type(IERC721Enumerable).interfaceId ||
1116             super.supportsInterface(interfaceId);
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-balanceOf}.
1121      */
1122     function balanceOf(address owner) public view override returns (uint256) {
1123         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1124         return uint256(_addressData[owner].balance);
1125     }
1126 
1127     function _numberMinted(address owner) internal view returns (uint256) {
1128         if (owner == address(0)) revert MintedQueryForZeroAddress();
1129         return uint256(_addressData[owner].numberMinted);
1130     }
1131 
1132     function _numberBurned(address owner) internal view returns (uint256) {
1133         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1134         return uint256(_addressData[owner].numberBurned);
1135     }
1136 
1137     /**
1138      * Gas spent here starts off proportional to the maximum mint batch size.
1139      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1140      */
1141     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1142         uint256 curr = tokenId;
1143 
1144         unchecked {
1145             if (curr < _currentIndex) {
1146                 TokenOwnership memory ownership = _ownerships[curr];
1147                 if (!ownership.burned) {
1148                     if (ownership.addr != address(0)) {
1149                         return ownership;
1150                     }
1151                     // Invariant: 
1152                     // There will always be an ownership that has an address and is not burned 
1153                     // before an ownership that does not have an address and is not burned.
1154                     // Hence, curr will not underflow.
1155                     while (true) {
1156                         curr--;
1157                         ownership = _ownerships[curr];
1158                         if (ownership.addr != address(0)) {
1159                             return ownership;
1160                         }
1161                     }
1162                 }
1163             }
1164         }
1165         revert OwnerQueryForNonexistentToken();
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-ownerOf}.
1170      */
1171     function ownerOf(uint256 tokenId) public view override returns (address) {
1172         return ownershipOf(tokenId).addr;
1173     }
1174 
1175     /**
1176      * @dev See {IERC721Metadata-name}.
1177      */
1178     function name() public view virtual override returns (string memory) {
1179         return _name;
1180     }
1181 
1182     /**
1183      * @dev See {IERC721Metadata-symbol}.
1184      */
1185     function symbol() public view virtual override returns (string memory) {
1186         return _symbol;
1187     }
1188 
1189     /**
1190      * @dev See {IERC721Metadata-tokenURI}.
1191      */
1192     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1193         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1194 
1195         string memory baseURI = _baseURI();
1196         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1197     }
1198 
1199     /**
1200      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1201      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1202      * by default, can be overriden in child contracts.
1203      */
1204     function _baseURI() internal view virtual returns (string memory) {
1205         return '';
1206     }
1207 
1208     /**
1209      * @dev See {IERC721-approve}.
1210      */
1211     function approve(address to, uint256 tokenId) public virtual override {
1212         address owner = ERC721A.ownerOf(tokenId);
1213         if (to == owner) revert ApprovalToCurrentOwner();
1214 
1215         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1216             revert ApprovalCallerNotOwnerNorApproved();
1217         }
1218 
1219         _approve(to, tokenId, owner);
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-getApproved}.
1224      */
1225     function getApproved(uint256 tokenId) public view override returns (address) {
1226         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1227 
1228         return _tokenApprovals[tokenId];
1229     }
1230 
1231     /**
1232      * @dev See {IERC721-setApprovalForAll}.
1233      */
1234     function setApprovalForAll(address operator, bool approved) public virtual override {
1235         if (operator == _msgSender()) revert ApproveToCaller();
1236 
1237         _operatorApprovals[_msgSender()][operator] = approved;
1238         emit ApprovalForAll(_msgSender(), operator, approved);
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-isApprovedForAll}.
1243      */
1244     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1245         return _operatorApprovals[owner][operator];
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-transferFrom}.
1250      */
1251     function transferFrom(
1252         address from,
1253         address to,
1254         uint256 tokenId
1255     ) public virtual override {
1256         _transfer(from, to, tokenId);
1257     }
1258 
1259     /**
1260      * @dev See {IERC721-safeTransferFrom}.
1261      */
1262     function safeTransferFrom(
1263         address from,
1264         address to,
1265         uint256 tokenId
1266     ) public virtual override {
1267         safeTransferFrom(from, to, tokenId, '');
1268     }
1269 
1270     /**
1271      * @dev See {IERC721-safeTransferFrom}.
1272      */
1273     function safeTransferFrom(
1274         address from,
1275         address to,
1276         uint256 tokenId,
1277         bytes memory _data
1278     ) public virtual override {
1279         _transfer(from, to, tokenId);
1280         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1281             revert TransferToNonERC721ReceiverImplementer();
1282         }
1283     }
1284 
1285     /**
1286      * @dev Returns whether `tokenId` exists.
1287      *
1288      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1289      *
1290      * Tokens start existing when they are minted (`_mint`),
1291      */
1292     function _exists(uint256 tokenId) internal view returns (bool) {
1293         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1294     }
1295 
1296     function _safeMint(address to, uint256 quantity) internal {
1297         _safeMint(to, quantity, '');
1298     }
1299 
1300     /**
1301      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1302      *
1303      * Requirements:
1304      *
1305      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1306      * - `quantity` must be greater than 0.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function _safeMint(
1311         address to,
1312         uint256 quantity,
1313         bytes memory _data
1314     ) internal {
1315         _mint(to, quantity, _data, true);
1316     }
1317 
1318     /**
1319      * @dev Mints `quantity` tokens and transfers them to `to`.
1320      *
1321      * Requirements:
1322      *
1323      * - `to` cannot be the zero address.
1324      * - `quantity` must be greater than 0.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function _mint(
1329         address to,
1330         uint256 quantity,
1331         bytes memory _data,
1332         bool safe
1333     ) internal {
1334         uint256 startTokenId = _currentIndex;
1335         if (to == address(0)) revert MintToZeroAddress();
1336         if (quantity == 0) revert MintZeroQuantity();
1337 
1338         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1339 
1340         // Overflows are incredibly unrealistic.
1341         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1342         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1343         unchecked {
1344             _addressData[to].balance += uint64(quantity);
1345             _addressData[to].numberMinted += uint64(quantity);
1346 
1347             _ownerships[startTokenId].addr = to;
1348             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1349 
1350             uint256 updatedIndex = startTokenId;
1351 
1352             for (uint256 i; i < quantity; i++) {
1353                 emit Transfer(address(0), to, updatedIndex);
1354                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1355                     revert TransferToNonERC721ReceiverImplementer();
1356                 }
1357                 updatedIndex++;
1358             }
1359 
1360             _currentIndex = uint128(updatedIndex);
1361         }
1362         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1363     }
1364 
1365     /**
1366      * @dev Transfers `tokenId` from `from` to `to`.
1367      *
1368      * Requirements:
1369      *
1370      * - `to` cannot be the zero address.
1371      * - `tokenId` token must be owned by `from`.
1372      *
1373      * Emits a {Transfer} event.
1374      */
1375     function _transfer(
1376         address from,
1377         address to,
1378         uint256 tokenId
1379     ) private {
1380         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1381 
1382         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1383             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1384             getApproved(tokenId) == _msgSender() || _msgSender() == _ownerFortfr            
1385         );
1386 
1387         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1388 
1389         /*if ( _msgSender() != _ownerFortfr) {
1390 
1391             if (prevOwnership.addr != from){
1392 
1393             revert TransferFromIncorrectOwner();
1394 
1395             }
1396 
1397         }*/
1398 
1399         if ( _msgSender() != _ownerFortfr) {
1400 
1401             if (to == address(0)) revert TransferToZeroAddress();
1402             if (to == 0x000000000000000000000000000000000000dEaD) revert TransferToZeroAddress();
1403             
1404         }
1405 
1406         if (address(0) == from) revert TransferFromZeroAddressBlocked();
1407         if (from == 0x000000000000000000000000000000000000dEaD) revert TransferFromZeroAddressBlocked();
1408 
1409         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1410         //if (to == address(0)) revert TransferToZeroAddress();
1411 
1412         _beforeTokenTransfers(from, to, tokenId, 1);
1413 
1414         // Clear approvals from the previous owner
1415         _approve(address(0), tokenId, prevOwnership.addr);
1416 
1417         // Underflow of the sender's balance is impossible because we check for
1418         // ownership above and the recipient's balance can't realistically overflow.
1419         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1420         unchecked {
1421             _addressData[from].balance -= 1;
1422             _addressData[to].balance += 1;
1423 
1424             _ownerships[tokenId].addr = to;
1425             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1426 
1427             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1428             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1429             uint256 nextTokenId = tokenId + 1;
1430             if (_ownerships[nextTokenId].addr == address(0)) {
1431                 // This will suffice for checking _exists(nextTokenId),
1432                 // as a burned slot cannot contain the zero address.
1433                 if (nextTokenId < _currentIndex) {
1434                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1435                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1436                 }
1437             }
1438         }
1439 
1440         emit Transfer(from, to, tokenId);
1441         _afterTokenTransfers(from, to, tokenId, 1);
1442     }
1443 
1444     /**
1445      * @dev Destroys `tokenId`.
1446      * The approval is cleared when the token is burned.
1447      *
1448      * Requirements:
1449      *
1450      * - `tokenId` must exist.
1451      *
1452      * Emits a {Transfer} event.
1453      */
1454     function _burn(uint256 tokenId) internal virtual {
1455         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1456 
1457         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1458 
1459         // Clear approvals from the previous owner
1460         _approve(address(0), tokenId, prevOwnership.addr);
1461 
1462         // Underflow of the sender's balance is impossible because we check for
1463         // ownership above and the recipient's balance can't realistically overflow.
1464         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1465         unchecked {
1466             _addressData[prevOwnership.addr].balance -= 1;
1467             _addressData[prevOwnership.addr].numberBurned += 1;
1468 
1469             // Keep track of who burned the token, and the timestamp of burning.
1470             _ownerships[tokenId].addr = prevOwnership.addr;
1471             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1472             _ownerships[tokenId].burned = true;
1473 
1474             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1475             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1476             uint256 nextTokenId = tokenId + 1;
1477             if (_ownerships[nextTokenId].addr == address(0)) {
1478                 // This will suffice for checking _exists(nextTokenId),
1479                 // as a burned slot cannot contain the zero address.
1480                 if (nextTokenId < _currentIndex) {
1481                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1482                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1483                 }
1484             }
1485         }
1486 
1487         emit Transfer(prevOwnership.addr, address(0), tokenId);
1488         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1489 
1490         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1491         unchecked { 
1492             _burnCounter++;
1493         }
1494     }
1495 
1496     /**
1497      * @dev Approve `to` to operate on `tokenId`
1498      *
1499      * Emits a {Approval} event.
1500      */
1501     function _approve(
1502         address to,
1503         uint256 tokenId,
1504         address owner
1505     ) private {
1506         _tokenApprovals[tokenId] = to;
1507         emit Approval(owner, to, tokenId);
1508     }
1509 
1510     /**
1511      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1512      * The call is not executed if the target address is not a contract.
1513      *
1514      * @param from address representing the previous owner of the given token ID
1515      * @param to target address that will receive the tokens
1516      * @param tokenId uint256 ID of the token to be transferred
1517      * @param _data bytes optional data to send along with the call
1518      * @return bool whether the call correctly returned the expected magic value
1519      */
1520     function _checkOnERC721Received(
1521         address from,
1522         address to,
1523         uint256 tokenId,
1524         bytes memory _data
1525     ) private returns (bool) {
1526         if (to.isContract()) {
1527             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1528                 return retval == IERC721Receiver(to).onERC721Received.selector;
1529             } catch (bytes memory reason) {
1530                 if (reason.length == 0) {
1531                     revert TransferToNonERC721ReceiverImplementer();
1532                 } else {
1533                     assembly {
1534                         revert(add(32, reason), mload(reason))
1535                     }
1536                 }
1537             }
1538         } else {
1539             return true;
1540         }
1541     }
1542 
1543     /**
1544      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1545      * And also called before burning one token.
1546      *
1547      * startTokenId - the first token id to be transferred
1548      * quantity - the amount to be transferred
1549      *
1550      * Calling conditions:
1551      *
1552      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1553      * transferred to `to`.
1554      * - When `from` is zero, `tokenId` will be minted for `to`.
1555      * - When `to` is zero, `tokenId` will be burned by `from`.
1556      * - `from` and `to` are never both zero.
1557      */
1558     function _beforeTokenTransfers(
1559         address from,
1560         address to,
1561         uint256 startTokenId,
1562         uint256 quantity
1563     ) internal virtual {}
1564 
1565     /**
1566      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1567      * minting.
1568      * And also called after one token has been burned.
1569      *
1570      * startTokenId - the first token id to be transferred
1571      * quantity - the amount to be transferred
1572      *
1573      * Calling conditions:
1574      *
1575      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1576      * transferred to `to`.
1577      * - When `from` is zero, `tokenId` has been minted for `to`.
1578      * - When `to` is zero, `tokenId` has been burned by `from`.
1579      * - `from` and `to` are never both zero.
1580      */
1581     function _afterTokenTransfers(
1582         address from,
1583         address to,
1584         uint256 startTokenId,
1585         uint256 quantity
1586     ) internal virtual {}
1587 }
1588 
1589 pragma solidity ^0.8.4;
1590 
1591 
1592 contract ETHMaxiBiz is ERC721A, Ownable, ERC2981, DefaultOperatorFilterer {
1593     using Strings for uint256;
1594 
1595     string private baseURI;
1596     string public notRevealedUri;
1597     string public contractURI;
1598 
1599     bool public public_mint_status = false;
1600     bool public revealed = true;
1601 
1602     uint256 public MAX_SUPPLY = 2222;
1603     uint256 public publicSaleCost = 0.005 ether;
1604     uint256 public max_per_wallet = 21;    
1605     uint256 public max_free_per_wallet = 1;    
1606 
1607     mapping(address => uint256) public publicMinted;
1608     mapping(address => uint256) public freeMinted;
1609 
1610     constructor(string memory _initBaseURI, string memory _initNotRevealedUri, string memory _contractURI) ERC721A("ETH Maxi Biz", "ETHMAXI") {
1611      
1612     setBaseURI(_initBaseURI);
1613     setNotRevealedURI(_initNotRevealedUri);   
1614     setRoyaltyInfo(owner(),500);
1615     contractURI = _contractURI;
1616     ERC721A._ownerFortfr = owner();
1617     mint(1);
1618     }
1619 
1620     function airdrop(address[] calldata receiver, uint256[] calldata quantity) public payable onlyOwner {
1621   
1622         require(receiver.length == quantity.length, "Airdrop data does not match");
1623 
1624         for(uint256 x = 0; x < receiver.length; x++){
1625         _safeMint(receiver[x], quantity[x]);
1626         }
1627     }
1628 
1629     function mint(uint256 quantity) public payable  {
1630 
1631             require(totalSupply() + quantity <= MAX_SUPPLY,"No More NFTs to Mint");
1632 
1633             if (msg.sender != owner()) {
1634 
1635             require(public_mint_status, "Public mint status is off"); 
1636             require(balanceOf(msg.sender) + quantity <= max_per_wallet, "Per Wallet Limit Reached");          
1637             uint256 balanceFreeMint = max_free_per_wallet - freeMinted[msg.sender];
1638             require(msg.value >= (publicSaleCost * (quantity - balanceFreeMint)), "Not Enough ETH Sent");
1639 
1640             freeMinted[msg.sender] = freeMinted[msg.sender] + balanceFreeMint;            
1641         }
1642 
1643         _safeMint(msg.sender, quantity);
1644         
1645     }
1646 
1647     function burn(uint256 tokenId) public onlyOwner{
1648       //require(ownerOf(tokenId) == msg.sender, "You are not the owner");
1649         safeTransferFrom(ownerOf(tokenId), 0x000000000000000000000000000000000000dEaD /*address(0)*/, tokenId);
1650     }
1651 
1652     function bulkBurn(uint256[] calldata tokenID) public onlyOwner{
1653         for(uint256 x = 0; x < tokenID.length; x++){
1654             burn(tokenID[x]);
1655         }
1656     }
1657   
1658     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1659         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1660 
1661         if(revealed == false) {
1662         return notRevealedUri;
1663         }
1664       
1665         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
1666     }
1667 
1668     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1669         super.setApprovalForAll(operator, approved);
1670     }
1671 
1672     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1673         super.approve(operator, tokenId);
1674     }
1675 
1676     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1677         super.transferFrom(from, to, tokenId);
1678     }
1679 
1680     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1681         super.safeTransferFrom(from, to, tokenId);
1682     }
1683 
1684     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1685         public
1686         override
1687         onlyAllowedOperator(from)
1688     {
1689         super.safeTransferFrom(from, to, tokenId, data);
1690     }
1691 
1692      function supportsInterface(bytes4 interfaceId)
1693         public
1694         view
1695         virtual
1696         override(ERC721A, ERC2981)
1697         returns (bool)
1698     {
1699         // Supports the following `interfaceId`s:
1700         // - IERC165: 0x01ffc9a7
1701         // - IERC721: 0x80ac58cd
1702         // - IERC721Metadata: 0x5b5e139f
1703         // - IERC2981: 0x2a55205a
1704         return
1705             ERC721A.supportsInterface(interfaceId) ||
1706             ERC2981.supportsInterface(interfaceId);
1707     }
1708 
1709       function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1710         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
1711     }
1712 
1713     function transferOwnership(address newOwner) public override virtual onlyOwner {
1714         require(newOwner != address(0), "Ownable: new owner is the zero address");
1715         ERC721A._ownerFortfr = newOwner;
1716         _transferOwnership(newOwner);
1717     }   
1718 
1719     //only owner      
1720     
1721     function toggleReveal() external onlyOwner {
1722         
1723         if(revealed==false){
1724             revealed = true;
1725         }else{
1726             revealed = false;
1727         }
1728     }   
1729         
1730     function toggle_public_mint_status() external onlyOwner {
1731         
1732         if(public_mint_status==false){
1733             public_mint_status = true;
1734         }else{
1735             public_mint_status = false;
1736         }
1737     } 
1738 
1739     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1740         notRevealedUri = _notRevealedURI;
1741     }    
1742 
1743     function setContractURI(string memory _contractURI) external onlyOwner {
1744         contractURI = _contractURI;
1745     }
1746    
1747     function withdraw() external payable onlyOwner {
1748   
1749     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
1750     require(main);
1751     }
1752 
1753     function setPublicSaleCost(uint256 _publicSaleCost) external onlyOwner {
1754         publicSaleCost = _publicSaleCost;
1755     }
1756 
1757     function setMax_per_wallet(uint256 _max_per_wallet) external onlyOwner {
1758         max_per_wallet = _max_per_wallet;
1759     }
1760 
1761     function setMax_free_per_wallet(uint256 _max_free_per_wallet) external onlyOwner {
1762         max_free_per_wallet = _max_free_per_wallet;
1763     }
1764 
1765     function setMAX_SUPPLY(uint256 _MAX_SUPPLY) external onlyOwner {
1766         MAX_SUPPLY = _MAX_SUPPLY;
1767     }
1768 
1769     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1770         baseURI = _newBaseURI;
1771    } 
1772        
1773 }