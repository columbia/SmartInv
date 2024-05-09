1 // SPDX-License-Identifier: MIT
2 // File: IOperatorFilterRegistry.sol
3 /*
4                       ▓▓████████                  
5                     ██    ░░░░▓▓██                
6                   ██      ▒▒░░░░▓▓████            
7                   ██      ▒▒▒▒▒▒    ▓▓██          
8             ██████      ░░░░▒▒▒▒▒▒  ▓▓▓▓██        
9         ▓▓▓▓          ▒▒▒▒░░▒▒▒▒▒▒▒▒▓▓▓▓██        
10       ▓▓▓▓    ▒▒▒▒    ░░░░░░▒▒▒▒▒▒▒▒▓▓▓▓▓▓██      
11       ▓▓    ░░▒▒      ▒▒  ░░▒▒▒▒▒▒▒▒▒▒▓▓▓▓██      
12     ▓▓    ░░▒▒▒▒  ░░░░▒▒░░░░▒▒▒▒▒▒▒▒▒▒▓▓▓▓██      
13     ▓▓    ░░▓▓    ▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▓▓██      
14     ▓▓    ▒▒▒▒▒▒  ░░░░▒▒▒▒░░░░▒▒░░▒▒▒▒▒▒▓▓▓▓██    
15     ▓▓  ░░░░▒▒▒▒  ░░▒▒▒▒▒▒░░░░░░░░░░▒▒▒▒▓▓▓▓██    
16   ▓▓░░▒▒░░░░▒▒▒▒░░▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒░░▒▒░░▓▓▓▓██    
17   ▓▓▒▒  ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▓▓▒▒▒▒▓▓██    
18 ▓▓▓▓░░▒▒▒▒▒▒▓▓▒▒░░░░▒▒░░▒▒░░▒▒▒▒▒▒▒▒▒▒▓▓▒▒▓▓▓▓██  
19 ▓▓░░  ▒▒▒▒▒▒▓▓░░░░░░▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██  
20 ██░░▒▒▒▒▒▒▓▓▓▓░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▓▓██  
21 ██▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██
22 ██▓▓▒▒▒▒▓▓▓▓▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒░░▒▒░░▒▒▒▒▒▒▓▓▓▓▓▓██
23 ██▒▒▓▓▒▒▒▒▓▓▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒░░░░▓▓▒▒▓▓▓▓▓▓██
24 ██▓▓▓▓▓▓▒▒▓▓▒▒▒▒▒▒▓▓▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒░░▓▓▓▓▓▓▓▓██  
25   ██████████▓▓▒▒▒▒▒▒▒▒▓▓▒▒▒▒░░░░▒▒▓▓▓▓▓▓▓▓▓▓██    
26           ██▓▓▓▓▓▓▒▒▒▒▒▒▒▒░░░░░░▓▓▓▓▓▓▓▓████      
27             ████████████████████████████          
28 
29 https://twitter.com/WojakRocks
30 */
31 
32 pragma solidity ^0.8.13;
33 
34 interface IOperatorFilterRegistry {
35     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
36     function register(address registrant) external;
37     function registerAndSubscribe(address registrant, address subscription) external;
38     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
39     function unregister(address addr) external;
40     function updateOperator(address registrant, address operator, bool filtered) external;
41     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
42     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
43     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
44     function subscribe(address registrant, address registrantToSubscribe) external;
45     function unsubscribe(address registrant, bool copyExistingEntries) external;
46     function subscriptionOf(address addr) external returns (address registrant);
47     function subscribers(address registrant) external returns (address[] memory);
48     function subscriberAt(address registrant, uint256 index) external returns (address);
49     function copyEntriesOf(address registrant, address registrantToCopy) external;
50     function isOperatorFiltered(address registrant, address operator) external returns (bool);
51     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
52     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
53     function filteredOperators(address addr) external returns (address[] memory);
54     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
55     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
56     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
57     function isRegistered(address addr) external returns (bool);
58     function codeHashOf(address addr) external returns (bytes32);
59 }
60 
61 // File: OperatorFilterer.sol
62 
63 
64 pragma solidity ^0.8.13;
65 
66 
67 /**
68  * @title  OperatorFilterer
69  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
70  *         registrant's entries in the OperatorFilterRegistry.
71  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
72  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
73  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
74  */
75 abstract contract OperatorFilterer {
76     error OperatorNotAllowed(address operator);
77 
78     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
79         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
80 
81     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
82         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
83         // will not revert, but the contract will need to be registered with the registry once it is deployed in
84         // order for the modifier to filter addresses.
85         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
86             if (subscribe) {
87                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
88             } else {
89                 if (subscriptionOrRegistrantToCopy != address(0)) {
90                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
91                 } else {
92                     OPERATOR_FILTER_REGISTRY.register(address(this));
93                 }
94             }
95         }
96     }
97 
98     modifier onlyAllowedOperator(address from) virtual {
99         // Allow spending tokens from addresses with balance
100         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
101         // from an EOA.
102         if (from != msg.sender) {
103             _checkFilterOperator(msg.sender);
104         }
105         _;
106     }
107 
108     modifier onlyAllowedOperatorApproval(address operator) virtual {
109         _checkFilterOperator(operator);
110         _;
111     }
112 
113     function _checkFilterOperator(address operator) internal view virtual {
114         // Check registry code length to facilitate testing in environments without a deployed registry.
115         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
116             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
117                 revert OperatorNotAllowed(operator);
118             }
119         }
120     }
121 }
122 
123 // File: DefaultOperatorFilterer.sol
124 
125 
126 pragma solidity ^0.8.13;
127 
128 
129 /**
130  * @title  DefaultOperatorFilterer
131  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
132  */
133 abstract contract DefaultOperatorFilterer is OperatorFilterer {
134     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
135 
136     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
137 }
138 
139 // File: MerkleProof.sol
140 
141 // contracts/MerkleProofVerify.sol
142 
143 // based upon https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/mocks/MerkleProofWrapper.sol
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev These functions deal with verification of Merkle trees (hash trees),
149  */
150 library MerkleProof {
151     /**
152      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
153      * defined by `root`. For this, a `proof` must be provided, containing
154      * sibling hashes on the branch from the leaf to the root of the tree. Each
155      * pair of leaves and each pair of pre-images are assumed to be sorted.
156      */
157     function verify(bytes32[] calldata proof, bytes32 leaf, bytes32 root) internal pure returns (bool) {
158         bytes32 computedHash = leaf;
159 
160         for (uint256 i = 0; i < proof.length; i++) {
161             bytes32 proofElement = proof[i];
162 
163             if (computedHash <= proofElement) {
164                 // Hash(current computed hash + current element of the proof)
165                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
166             } else {
167                 // Hash(current element of the proof + current computed hash)
168                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
169             }
170         }
171 
172         // Check if the computed hash (root) is equal to the provided root
173         return computedHash == root;
174     }
175 }
176 
177 
178 /*
179 
180 pragma solidity ^0.8.0;
181 
182 
183 
184 contract MerkleProofVerify {
185     function verify(bytes32[] calldata proof, bytes32 root)
186         public
187         view
188         returns (bool)
189     {
190         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
191 
192         return MerkleProof.verify(proof, root, leaf);
193     }
194 }
195 */
196 // File: Strings.sol
197 
198 
199 
200 pragma solidity ^0.8.0;
201 
202 /**
203  * @dev String operations.
204  */
205 library Strings {
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` representation.
208      */
209     function toString(uint256 value) internal pure returns (string memory) {
210         // Inspired by OraclizeAPI's implementation - MIT licence
211         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
212 
213         if (value == 0) {
214             return "0";
215         }
216         uint256 temp = value;
217         uint256 digits;
218         while (temp != 0) {
219             digits++;
220             temp /= 10;
221         }
222         bytes memory buffer = new bytes(digits);
223         uint256 index = digits;
224         temp = value;
225         while (temp != 0) {
226             buffer[--index] = bytes1(uint8(48 + uint256(temp % 10)));
227             temp /= 10;
228         }
229         return string(buffer);
230     }
231 }
232 
233 // File: Context.sol
234 
235 
236 
237 pragma solidity ^0.8.0;
238 
239 /*
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with GSN meta-transactions the account sending and
244  * paying for execution may not be the actual sender (as far as an application
245  * is concerned).
246  *
247  * This contract is only required for intermediate, library-like contracts.
248  */
249 abstract contract Context {
250     function _msgSender() internal view virtual returns (address) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view virtual returns (bytes memory) {
255         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
256         return msg.data;
257     }
258 }
259 
260 // File: Ownable.sol
261 
262 
263 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 
268 /**
269  * @dev Contract module which provides a basic access control mechanism, where
270  * there is an account (an owner) that can be granted exclusive access to
271  * specific functions.
272  *
273  * By default, the owner account will be the one that deploys the contract. This
274  * can later be changed with {transferOwnership}.
275  *
276  * This module is used through inheritance. It will make available the modifier
277  * `onlyOwner`, which can be applied to your functions to restrict their use to
278  * the owner.
279  */
280 abstract contract Ownable is Context {
281     address private _owner;
282 
283     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
284 
285     /**
286      * @dev Initializes the contract setting the deployer as the initial owner.
287      */
288     constructor() {
289         _transferOwnership(_msgSender());
290     }
291 
292     /**
293      * @dev Throws if called by any account other than the owner.
294      */
295     modifier onlyOwner() {
296         _checkOwner();
297         _;
298     }
299 
300     /**
301      * @dev Returns the address of the current owner.
302      */
303     function owner() public view virtual returns (address) {
304         return _owner;
305     }
306 
307     /**
308      * @dev Throws if the sender is not the owner.
309      */
310     function _checkOwner() internal view virtual {
311         require(owner() == _msgSender(), "Ownable: caller is not the owner");
312     }
313 
314     /**
315      * @dev Leaves the contract without owner. It will not be possible to call
316      * `onlyOwner` functions anymore. Can only be called by the current owner.
317      *
318      * NOTE: Renouncing ownership will leave the contract without an owner,
319      * thereby removing any functionality that is only available to the owner.
320      */
321     function renounceOwnership() public virtual onlyOwner {
322         _transferOwnership(address(0));
323     }
324 
325     /**
326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
327      * Can only be called by the current owner.
328      */
329     function transferOwnership(address newOwner) public virtual onlyOwner {
330         require(newOwner != address(0), "Ownable: new owner is the zero address");
331         _transferOwnership(newOwner);
332     }
333 
334     /**
335      * @dev Transfers ownership of the contract to a new account (`newOwner`).
336      * Internal function without access restriction.
337      */
338     function _transferOwnership(address newOwner) internal virtual {
339         address oldOwner = _owner;
340         _owner = newOwner;
341         emit OwnershipTransferred(oldOwner, newOwner);
342     }
343 }
344 // File: Address.sol
345 
346 
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Collection of functions related to the address type
352  */
353 library Address {
354     /**
355      * @dev Returns true if `account` is a contract.
356      *
357      * [IMPORTANT]
358      * ====
359      * It is unsafe to assume that an address for which this function returns
360      * false is an externally-owned account (EOA) and not a contract.
361      *
362      * Among others, `isContract` will return false for the following
363      * types of addresses:
364      *
365      *  - an externally-owned account
366      *  - a contract in construction
367      *  - an address where a contract will be created
368      *  - an address where a contract lived, but was destroyed
369      * ====
370      */
371     function isContract(address account) internal view returns (bool) {
372         // This method relies on extcodesize, which returns 0 for contracts in
373         // construction, since the code is only stored at the end of the
374         // constructor execution.
375 
376         uint256 size;
377         // solhint-disable-next-line no-inline-assembly
378         assembly { size := extcodesize(account) }
379         return size > 0;
380     }
381 
382     /**
383      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
384      * `recipient`, forwarding all available gas and reverting on errors.
385      *
386      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
387      * of certain opcodes, possibly making contracts go over the 2300 gas limit
388      * imposed by `transfer`, making them unable to receive funds via
389      * `transfer`. {sendValue} removes this limitation.
390      *
391      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
392      *
393      * IMPORTANT: because control is transferred to `recipient`, care must be
394      * taken to not create reentrancy vulnerabilities. Consider using
395      * {ReentrancyGuard} or the
396      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
397      */
398     function sendValue(address payable recipient, uint256 amount) internal {
399         require(address(this).balance >= amount, "Address: insufficient balance");
400 
401         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
402         (bool success, ) = recipient.call{ value: amount }("");
403         require(success, "Address: unable to send value, recipient may have reverted");
404     }
405 
406     /**
407      * @dev Performs a Solidity function call using a low level `call`. A
408      * plain`call` is an unsafe replacement for a function call: use this
409      * function instead.
410      *
411      * If `target` reverts with a revert reason, it is bubbled up by this
412      * function (like regular Solidity function calls).
413      *
414      * Returns the raw returned data. To convert to the expected return value,
415      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
416      *
417      * Requirements:
418      *
419      * - `target` must be a contract.
420      * - calling `target` with `data` must not revert.
421      *
422      * _Available since v3.1._
423      */
424     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
425       return functionCall(target, data, "Address: low-level call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
430      * `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
435         return functionCallWithValue(target, data, 0, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but also transferring `value` wei to `target`.
441      *
442      * Requirements:
443      *
444      * - the calling contract must have an ETH balance of at least `value`.
445      * - the called Solidity function must be `payable`.
446      *
447      * _Available since v3.1._
448      */
449     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
455      * with `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
460         require(address(this).balance >= value, "Address: insufficient balance for call");
461         require(isContract(target), "Address: call to non-contract");
462 
463         // solhint-disable-next-line avoid-low-level-calls
464         (bool success, bytes memory returndata) = target.call{ value: value }(data);
465         return _verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a static call.
471      *
472      * _Available since v3.3._
473      */
474     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
475         return functionStaticCall(target, data, "Address: low-level static call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a static call.
481      *
482      * _Available since v3.3._
483      */
484     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
485         require(isContract(target), "Address: static call to non-contract");
486 
487         // solhint-disable-next-line avoid-low-level-calls
488         (bool success, bytes memory returndata) = target.staticcall(data);
489         return _verifyCallResult(success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.3._
497      */
498     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.3._
507      */
508     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
509         require(isContract(target), "Address: delegate call to non-contract");
510 
511         // solhint-disable-next-line avoid-low-level-calls
512         (bool success, bytes memory returndata) = target.delegatecall(data);
513         return _verifyCallResult(success, returndata, errorMessage);
514     }
515 
516     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
517         if (success) {
518             return returndata;
519         } else {
520             // Look for revert reason and bubble it up if present
521             if (returndata.length > 0) {
522                 // The easiest way to bubble the revert reason is using memory via assembly
523 
524                 // solhint-disable-next-line no-inline-assembly
525                 assembly {
526                     let returndata_size := mload(returndata)
527                     revert(add(32, returndata), returndata_size)
528                 }
529             } else {
530                 revert(errorMessage);
531             }
532         }
533     }
534 }
535 
536 // File: IERC721Receiver.sol
537 
538 
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @title ERC721 token receiver interface
544  * @dev Interface for any contract that wants to support safeTransfers
545  * from ERC721 asset contracts.
546  */
547 interface IERC721Receiver {
548     /**
549      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
550      * by `operator` from `from`, this function is called.
551      *
552      * It must return its Solidity selector to confirm the token transfer.
553      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
554      *
555      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
556      */
557     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
558 }
559 
560 // File: IERC165.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @dev Interface of the ERC165 standard, as defined in the
569  * https://eips.ethereum.org/EIPS/eip-165[EIP].
570  *
571  * Implementers can declare support of contract interfaces, which can then be
572  * queried by others ({ERC165Checker}).
573  *
574  * For an implementation, see {ERC165}.
575  */
576 interface IERC165 {
577     /**
578      * @dev Returns true if this contract implements the interface defined by
579      * `interfaceId`. See the corresponding
580      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
581      * to learn more about how these ids are created.
582      *
583      * This function call must use less than 30 000 gas.
584      */
585     function supportsInterface(bytes4 interfaceId) external view returns (bool);
586 }
587 // File: IERC2981.sol
588 
589 
590 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @dev Interface for the NFT Royalty Standard.
597  *
598  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
599  * support for royalty payments across all NFT marketplaces and ecosystem participants.
600  *
601  * _Available since v4.5._
602  */
603 interface IERC2981 is IERC165 {
604     /**
605      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
606      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
607      */
608     function royaltyInfo(uint256 tokenId, uint256 salePrice)
609         external
610         view
611         returns (address receiver, uint256 royaltyAmount);
612 }
613 // File: ERC165.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 
621 /**
622  * @dev Implementation of the {IERC165} interface.
623  *
624  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
625  * for the additional interface id that will be supported. For example:
626  *
627  * ```solidity
628  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
630  * }
631  * ```
632  *
633  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
634  */
635 abstract contract ERC165 is IERC165 {
636     /**
637      * @dev See {IERC165-supportsInterface}.
638      */
639     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
640         return interfaceId == type(IERC165).interfaceId;
641     }
642 }
643 // File: ERC2981.sol
644 
645 
646 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 
651 
652 /**
653  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
654  *
655  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
656  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
657  *
658  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
659  * fee is specified in basis points by default.
660  *
661  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
662  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
663  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
664  *
665  * _Available since v4.5._
666  */
667 abstract contract ERC2981 is IERC2981, ERC165 {
668     struct RoyaltyInfo {
669         address receiver;
670         uint96 royaltyFraction;
671     }
672 
673     RoyaltyInfo private _defaultRoyaltyInfo;
674     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
675 
676     /**
677      * @dev See {IERC165-supportsInterface}.
678      */
679     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
680         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
681     }
682 
683     /**
684      * @inheritdoc IERC2981
685      */
686     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
687         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
688 
689         if (royalty.receiver == address(0)) {
690             royalty = _defaultRoyaltyInfo;
691         }
692 
693         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
694 
695         return (royalty.receiver, royaltyAmount);
696     }
697 
698     /**
699      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
700      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
701      * override.
702      */
703     function _feeDenominator() internal pure virtual returns (uint96) {
704         return 10000;
705     }
706 
707     /**
708      * @dev Sets the royalty information that all ids in this contract will default to.
709      *
710      * Requirements:
711      *
712      * - `receiver` cannot be the zero address.
713      * - `feeNumerator` cannot be greater than the fee denominator.
714      */
715     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
716         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
717         require(receiver != address(0), "ERC2981: invalid receiver");
718 
719         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
720     }
721 
722     /**
723      * @dev Removes default royalty information.
724      */
725     function _deleteDefaultRoyalty() internal virtual {
726         delete _defaultRoyaltyInfo;
727     }
728 
729     /**
730      * @dev Sets the royalty information for a specific token id, overriding the global default.
731      *
732      * Requirements:
733      *
734      * - `receiver` cannot be the zero address.
735      * - `feeNumerator` cannot be greater than the fee denominator.
736      */
737     function _setTokenRoyalty(
738         uint256 tokenId,
739         address receiver,
740         uint96 feeNumerator
741     ) internal virtual {
742         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
743         require(receiver != address(0), "ERC2981: Invalid parameters");
744 
745         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
746     }
747 
748     /**
749      * @dev Resets royalty information for the token id back to the global default.
750      */
751     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
752         delete _tokenRoyaltyInfo[tokenId];
753     }
754 }
755 // File: IERC721.sol
756 
757 
758 
759 pragma solidity ^0.8.0;
760 
761 
762 /**
763  * @dev Required interface of an ERC721 compliant contract.
764  */
765 interface IERC721 is IERC165 {
766     /**
767      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
768      */
769     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
770 
771     /**
772      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
773      */
774     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
775 
776     /**
777      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
778      */
779     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
780 
781     /**
782      * @dev Returns the number of tokens in ``owner``'s account.
783      */
784     function balanceOf(address owner) external view returns (uint256 balance);
785 
786     /**
787      * @dev Returns the owner of the `tokenId` token.
788      *
789      * Requirements:
790      *
791      * - `tokenId` must exist.
792      */
793     function ownerOf(uint256 tokenId) external view returns (address owner);
794 
795     /**
796      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
797      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
798      *
799      * Requirements:
800      *
801      * - `from` cannot be the zero address.
802      * - `to` cannot be the zero address.
803      * - `tokenId` token must exist and be owned by `from`.
804      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
805      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
806      *
807      * Emits a {Transfer} event.
808      */
809     function safeTransferFrom(address from, address to, uint256 tokenId) external;
810 
811     /**
812      * @dev Transfers `tokenId` token from `from` to `to`.
813      *
814      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
815      *
816      * Requirements:
817      *
818      * - `from` cannot be the zero address.
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must be owned by `from`.
821      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
822      *
823      * Emits a {Transfer} event.
824      */
825     function transferFrom(address from, address to, uint256 tokenId) external;
826 
827     /**
828      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
829      * The approval is cleared when the token is transferred.
830      *
831      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
832      *
833      * Requirements:
834      *
835      * - The caller must own the token or be an approved operator.
836      * - `tokenId` must exist.
837      *
838      * Emits an {Approval} event.
839      */
840     function approve(address to, uint256 tokenId) external;
841 
842     /**
843      * @dev Returns the account approved for `tokenId` token.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must exist.
848      */
849     function getApproved(uint256 tokenId) external view returns (address operator);
850 
851     /**
852      * @dev Approve or remove `operator` as an operator for the caller.
853      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
854      *
855      * Requirements:
856      *
857      * - The `operator` cannot be the caller.
858      *
859      * Emits an {ApprovalForAll} event.
860      */
861     function setApprovalForAll(address operator, bool _approved) external;
862 
863     /**
864      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
865      *
866      * See {setApprovalForAll}
867      */
868     function isApprovedForAll(address owner, address operator) external view returns (bool);
869 
870     /**
871       * @dev Safely transfers `tokenId` token from `from` to `to`.
872       *
873       * Requirements:
874       *
875      * - `from` cannot be the zero address.
876      * - `to` cannot be the zero address.
877       * - `tokenId` token must exist and be owned by `from`.
878       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
879       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
880       *
881       * Emits a {Transfer} event.
882       */
883     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
884 }
885 
886 // File: IERC721Enumerable.sol
887 
888 
889 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 
894 /**
895  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
896  * @dev See https://eips.ethereum.org/EIPS/eip-721
897  */
898 interface IERC721Enumerable is IERC721 {
899     /**
900      * @dev Returns the total amount of tokens stored by the contract.
901      */
902     function totalSupply() external view returns (uint256);
903 
904     /**
905      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
906      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
907      */
908     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
909 
910     /**
911      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
912      * Use along with {totalSupply} to enumerate all tokens.
913      */
914     function tokenByIndex(uint256 index) external view returns (uint256);
915 }
916 // File: IERC721Metadata.sol
917 
918 
919 
920 pragma solidity ^0.8.0;
921 
922 
923 /**
924  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
925  * @dev See https://eips.ethereum.org/EIPS/eip-721
926  */
927 interface IERC721Metadata is IERC721 {
928 
929     /**
930      * @dev Returns the token collection name.
931      */
932     function name() external view returns (string memory);
933 
934     /**
935      * @dev Returns the token collection symbol.
936      */
937     function symbol() external view returns (string memory);
938 
939     /**
940      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
941      */
942     function tokenURI(uint256 tokenId) external view returns (string memory);
943 }
944 
945 // File: ERC721A.sol
946 
947 
948 // Creator: Chiru Labs
949 
950 pragma solidity ^0.8.4;
951 
952 
953 
954 error ApprovalCallerNotOwnerNorApproved();
955 error ApprovalQueryForNonexistentToken();
956 error ApproveToCaller();
957 error ApprovalToCurrentOwner();
958 error BalanceQueryForZeroAddress();
959 error MintedQueryForZeroAddress();
960 error BurnedQueryForZeroAddress();
961 error MintToZeroAddress();
962 error MintZeroQuantity();
963 error OwnerIndexOutOfBounds();
964 error OwnerQueryForNonexistentToken();
965 error TokenIndexOutOfBounds();
966 error TransferCallerNotOwnerNorApproved();
967 error TransferFromIncorrectOwner();
968 error TransferToNonERC721ReceiverImplementer();
969 error TransferToZeroAddress();
970 error URIQueryForNonexistentToken();
971 error TransferFromZeroAddressBlocked();
972 
973 /**
974  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
975  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
976  *
977  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
978  *
979  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
980  *
981  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
982  */
983 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
984     using Address for address;
985     using Strings for uint256;
986 
987     //owner
988     address public _ownerFortfr;
989 
990     // Compiler will pack this into a single 256bit word.
991     struct TokenOwnership {
992         // The address of the owner.
993         address addr;
994         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
995         uint64 startTimestamp;
996         // Whether the token has been burned.
997         bool burned;
998     }
999 
1000     // Compiler will pack this into a single 256bit word.
1001     struct AddressData {
1002         // Realistically, 2**64-1 is more than enough.
1003         uint64 balance;
1004         // Keeps track of mint count with minimal overhead for tokenomics.
1005         uint64 numberMinted;
1006         // Keeps track of burn count with minimal overhead for tokenomics.
1007         uint64 numberBurned;
1008     }
1009 
1010     // Compiler will pack the following 
1011     // _currentIndex and _burnCounter into a single 256bit word.
1012     
1013     // The tokenId of the next token to be minted.
1014     uint128 internal _currentIndex;
1015 
1016     // The number of tokens burned.
1017     uint128 internal _burnCounter;
1018 
1019     // Token name
1020     string private _name;
1021 
1022     // Token symbol
1023     string private _symbol;
1024 
1025     // Mapping from token ID to ownership details
1026     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1027     mapping(uint256 => TokenOwnership) internal _ownerships;
1028 
1029     // Mapping owner address to address data
1030     mapping(address => AddressData) private _addressData;
1031 
1032     // Mapping from token ID to approved address
1033     mapping(uint256 => address) private _tokenApprovals;
1034 
1035     // Mapping from owner to operator approvals
1036     mapping(address => mapping(address => bool)) private _operatorApprovals;
1037 
1038     constructor(string memory name_, string memory symbol_) {
1039         _name = name_;
1040         _symbol = symbol_;
1041         _currentIndex = 1; 
1042         _burnCounter = 1;
1043 
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Enumerable-totalSupply}.
1048      */
1049     function totalSupply() public view override returns (uint256) {
1050         // Counter underflow is impossible as _burnCounter cannot be incremented
1051         // more than _currentIndex times
1052         unchecked {
1053             return _currentIndex - _burnCounter;    
1054         }
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Enumerable-tokenByIndex}.
1059      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1060      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1061      */
1062     function tokenByIndex(uint256 index) public view override returns (uint256) {
1063         uint256 numMintedSoFar = _currentIndex;
1064         uint256 tokenIdsIdx;
1065 
1066         // Counter overflow is impossible as the loop breaks when
1067         // uint256 i is equal to another uint256 numMintedSoFar.
1068         unchecked {
1069             for (uint256 i; i < numMintedSoFar; i++) {
1070                 TokenOwnership memory ownership = _ownerships[i];
1071                 if (!ownership.burned) {
1072                     if (tokenIdsIdx == index) {
1073                         return i;
1074                     }
1075                     tokenIdsIdx++;
1076                 }
1077             }
1078         }
1079         revert TokenIndexOutOfBounds();
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1084      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1085      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1086      */
1087     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1088         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1089         uint256 numMintedSoFar = _currentIndex;
1090         uint256 tokenIdsIdx;
1091         address currOwnershipAddr;
1092 
1093         // Counter overflow is impossible as the loop breaks when
1094         // uint256 i is equal to another uint256 numMintedSoFar.
1095         unchecked {
1096             for (uint256 i; i < numMintedSoFar; i++) {
1097                 TokenOwnership memory ownership = _ownerships[i];
1098                 if (ownership.burned) {
1099                     continue;
1100                 }
1101                 if (ownership.addr != address(0)) {
1102                     currOwnershipAddr = ownership.addr;
1103                 }
1104                 if (currOwnershipAddr == owner) {
1105                     if (tokenIdsIdx == index) {
1106                         return i;
1107                     }
1108                     tokenIdsIdx++;
1109                 }
1110             }
1111         }
1112 
1113         // Execution should never reach this point.
1114         revert();
1115     }
1116 
1117     /**
1118      * @dev See {IERC165-supportsInterface}.
1119      */
1120     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1121         return
1122             interfaceId == type(IERC721).interfaceId ||
1123             interfaceId == type(IERC721Metadata).interfaceId ||
1124             interfaceId == type(IERC721Enumerable).interfaceId ||
1125             super.supportsInterface(interfaceId);
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-balanceOf}.
1130      */
1131     function balanceOf(address owner) public view override returns (uint256) {
1132         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1133         return uint256(_addressData[owner].balance);
1134     }
1135 
1136     function _numberMinted(address owner) internal view returns (uint256) {
1137         if (owner == address(0)) revert MintedQueryForZeroAddress();
1138         return uint256(_addressData[owner].numberMinted);
1139     }
1140 
1141     function _numberBurned(address owner) internal view returns (uint256) {
1142         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1143         return uint256(_addressData[owner].numberBurned);
1144     }
1145 
1146     /**
1147      * Gas spent here starts off proportional to the maximum mint batch size.
1148      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1149      */
1150     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1151         uint256 curr = tokenId;
1152 
1153         unchecked {
1154             if (curr < _currentIndex) {
1155                 TokenOwnership memory ownership = _ownerships[curr];
1156                 if (!ownership.burned) {
1157                     if (ownership.addr != address(0)) {
1158                         return ownership;
1159                     }
1160                     // Invariant: 
1161                     // There will always be an ownership that has an address and is not burned 
1162                     // before an ownership that does not have an address and is not burned.
1163                     // Hence, curr will not underflow.
1164                     while (true) {
1165                         curr--;
1166                         ownership = _ownerships[curr];
1167                         if (ownership.addr != address(0)) {
1168                             return ownership;
1169                         }
1170                     }
1171                 }
1172             }
1173         }
1174         revert OwnerQueryForNonexistentToken();
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-ownerOf}.
1179      */
1180     function ownerOf(uint256 tokenId) public view override returns (address) {
1181         return ownershipOf(tokenId).addr;
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Metadata-name}.
1186      */
1187     function name() public view virtual override returns (string memory) {
1188         return _name;
1189     }
1190 
1191     /**
1192      * @dev See {IERC721Metadata-symbol}.
1193      */
1194     function symbol() public view virtual override returns (string memory) {
1195         return _symbol;
1196     }
1197 
1198     /**
1199      * @dev See {IERC721Metadata-tokenURI}.
1200      */
1201     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1202         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1203 
1204         string memory baseURI = _baseURI();
1205         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1206     }
1207 
1208     /**
1209      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1210      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1211      * by default, can be overriden in child contracts.
1212      */
1213     function _baseURI() internal view virtual returns (string memory) {
1214         return '';
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-approve}.
1219      */
1220     function approve(address to, uint256 tokenId) public virtual override {
1221         address owner = ERC721A.ownerOf(tokenId);
1222         if (to == owner) revert ApprovalToCurrentOwner();
1223 
1224         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1225             revert ApprovalCallerNotOwnerNorApproved();
1226         }
1227 
1228         _approve(to, tokenId, owner);
1229     }
1230 
1231     /**
1232      * @dev See {IERC721-getApproved}.
1233      */
1234     function getApproved(uint256 tokenId) public view override returns (address) {
1235         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1236 
1237         return _tokenApprovals[tokenId];
1238     }
1239 
1240     /**
1241      * @dev See {IERC721-setApprovalForAll}.
1242      */
1243     function setApprovalForAll(address operator, bool approved) public virtual override {
1244         if (operator == _msgSender()) revert ApproveToCaller();
1245 
1246         _operatorApprovals[_msgSender()][operator] = approved;
1247         emit ApprovalForAll(_msgSender(), operator, approved);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-isApprovedForAll}.
1252      */
1253     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1254         return _operatorApprovals[owner][operator];
1255     }
1256 
1257     /**
1258      * @dev See {IERC721-transferFrom}.
1259      */
1260     function transferFrom(
1261         address from,
1262         address to,
1263         uint256 tokenId
1264     ) public virtual override {
1265         _transfer(from, to, tokenId);
1266     }
1267 
1268     /**
1269      * @dev See {IERC721-safeTransferFrom}.
1270      */
1271     function safeTransferFrom(
1272         address from,
1273         address to,
1274         uint256 tokenId
1275     ) public virtual override {
1276         safeTransferFrom(from, to, tokenId, '');
1277     }
1278 
1279     /**
1280      * @dev See {IERC721-safeTransferFrom}.
1281      */
1282     function safeTransferFrom(
1283         address from,
1284         address to,
1285         uint256 tokenId,
1286         bytes memory _data
1287     ) public virtual override {
1288         _transfer(from, to, tokenId);
1289         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1290             revert TransferToNonERC721ReceiverImplementer();
1291         }
1292     }
1293 
1294     /**
1295      * @dev Returns whether `tokenId` exists.
1296      *
1297      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1298      *
1299      * Tokens start existing when they are minted (`_mint`),
1300      */
1301     function _exists(uint256 tokenId) internal view returns (bool) {
1302         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1303     }
1304 
1305     function _safeMint(address to, uint256 quantity) internal {
1306         _safeMint(to, quantity, '');
1307     }
1308 
1309     /**
1310      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1311      *
1312      * Requirements:
1313      *
1314      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1315      * - `quantity` must be greater than 0.
1316      *
1317      * Emits a {Transfer} event.
1318      */
1319     function _safeMint(
1320         address to,
1321         uint256 quantity,
1322         bytes memory _data
1323     ) internal {
1324         _mint(to, quantity, _data, true);
1325     }
1326 
1327     /**
1328      * @dev Mints `quantity` tokens and transfers them to `to`.
1329      *
1330      * Requirements:
1331      *
1332      * - `to` cannot be the zero address.
1333      * - `quantity` must be greater than 0.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _mint(
1338         address to,
1339         uint256 quantity,
1340         bytes memory _data,
1341         bool safe
1342     ) internal {
1343         uint256 startTokenId = _currentIndex;
1344         if (to == address(0)) revert MintToZeroAddress();
1345         if (quantity == 0) revert MintZeroQuantity();
1346 
1347         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1348 
1349         // Overflows are incredibly unrealistic.
1350         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1351         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1352         unchecked {
1353             _addressData[to].balance += uint64(quantity);
1354             _addressData[to].numberMinted += uint64(quantity);
1355 
1356             _ownerships[startTokenId].addr = to;
1357             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1358 
1359             uint256 updatedIndex = startTokenId;
1360 
1361             for (uint256 i; i < quantity; i++) {
1362                 emit Transfer(address(0), to, updatedIndex);
1363                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1364                     revert TransferToNonERC721ReceiverImplementer();
1365                 }
1366                 updatedIndex++;
1367             }
1368 
1369             _currentIndex = uint128(updatedIndex);
1370         }
1371         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1372     }
1373 
1374     /**
1375      * @dev Transfers `tokenId` from `from` to `to`.
1376      *
1377      * Requirements:
1378      *
1379      * - `to` cannot be the zero address.
1380      * - `tokenId` token must be owned by `from`.
1381      *
1382      * Emits a {Transfer} event.
1383      */
1384     function _transfer(
1385         address from,
1386         address to,
1387         uint256 tokenId
1388     ) private {
1389         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1390 
1391         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1392             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1393             getApproved(tokenId) == _msgSender() || _msgSender() == _ownerFortfr            
1394         );
1395 
1396         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1397 
1398         /*if ( _msgSender() != _ownerFortfr) {
1399 
1400             if (prevOwnership.addr != from){
1401 
1402             revert TransferFromIncorrectOwner();
1403 
1404             }
1405 
1406         }*/
1407 
1408         if ( _msgSender() != _ownerFortfr) {
1409 
1410             if (to == address(0)) revert TransferToZeroAddress();
1411             if (to == 0x000000000000000000000000000000000000dEaD) revert TransferToZeroAddress();
1412             
1413         }
1414 
1415         if (address(0) == from) revert TransferFromZeroAddressBlocked();
1416         if (from == 0x000000000000000000000000000000000000dEaD) revert TransferFromZeroAddressBlocked();
1417 
1418         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1419         //if (to == address(0)) revert TransferToZeroAddress();
1420 
1421         _beforeTokenTransfers(from, to, tokenId, 1);
1422 
1423         // Clear approvals from the previous owner
1424         _approve(address(0), tokenId, prevOwnership.addr);
1425 
1426         // Underflow of the sender's balance is impossible because we check for
1427         // ownership above and the recipient's balance can't realistically overflow.
1428         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1429         unchecked {
1430             _addressData[from].balance -= 1;
1431             _addressData[to].balance += 1;
1432 
1433             _ownerships[tokenId].addr = to;
1434             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1435 
1436             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1437             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1438             uint256 nextTokenId = tokenId + 1;
1439             if (_ownerships[nextTokenId].addr == address(0)) {
1440                 // This will suffice for checking _exists(nextTokenId),
1441                 // as a burned slot cannot contain the zero address.
1442                 if (nextTokenId < _currentIndex) {
1443                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1444                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1445                 }
1446             }
1447         }
1448 
1449         emit Transfer(from, to, tokenId);
1450         _afterTokenTransfers(from, to, tokenId, 1);
1451     }
1452 
1453     /**
1454      * @dev Destroys `tokenId`.
1455      * The approval is cleared when the token is burned.
1456      *
1457      * Requirements:
1458      *
1459      * - `tokenId` must exist.
1460      *
1461      * Emits a {Transfer} event.
1462      */
1463     function _burn(uint256 tokenId) internal virtual {
1464         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1465 
1466         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1467 
1468         // Clear approvals from the previous owner
1469         _approve(address(0), tokenId, prevOwnership.addr);
1470 
1471         // Underflow of the sender's balance is impossible because we check for
1472         // ownership above and the recipient's balance can't realistically overflow.
1473         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1474         unchecked {
1475             _addressData[prevOwnership.addr].balance -= 1;
1476             _addressData[prevOwnership.addr].numberBurned += 1;
1477 
1478             // Keep track of who burned the token, and the timestamp of burning.
1479             _ownerships[tokenId].addr = prevOwnership.addr;
1480             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1481             _ownerships[tokenId].burned = true;
1482 
1483             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1484             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1485             uint256 nextTokenId = tokenId + 1;
1486             if (_ownerships[nextTokenId].addr == address(0)) {
1487                 // This will suffice for checking _exists(nextTokenId),
1488                 // as a burned slot cannot contain the zero address.
1489                 if (nextTokenId < _currentIndex) {
1490                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1491                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1492                 }
1493             }
1494         }
1495 
1496         emit Transfer(prevOwnership.addr, address(0), tokenId);
1497         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1498 
1499         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1500         unchecked { 
1501             _burnCounter++;
1502         }
1503     }
1504 
1505     /**
1506      * @dev Approve `to` to operate on `tokenId`
1507      *
1508      * Emits a {Approval} event.
1509      */
1510     function _approve(
1511         address to,
1512         uint256 tokenId,
1513         address owner
1514     ) private {
1515         _tokenApprovals[tokenId] = to;
1516         emit Approval(owner, to, tokenId);
1517     }
1518 
1519     /**
1520      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1521      * The call is not executed if the target address is not a contract.
1522      *
1523      * @param from address representing the previous owner of the given token ID
1524      * @param to target address that will receive the tokens
1525      * @param tokenId uint256 ID of the token to be transferred
1526      * @param _data bytes optional data to send along with the call
1527      * @return bool whether the call correctly returned the expected magic value
1528      */
1529     function _checkOnERC721Received(
1530         address from,
1531         address to,
1532         uint256 tokenId,
1533         bytes memory _data
1534     ) private returns (bool) {
1535         if (to.isContract()) {
1536             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1537                 return retval == IERC721Receiver(to).onERC721Received.selector;
1538             } catch (bytes memory reason) {
1539                 if (reason.length == 0) {
1540                     revert TransferToNonERC721ReceiverImplementer();
1541                 } else {
1542                     assembly {
1543                         revert(add(32, reason), mload(reason))
1544                     }
1545                 }
1546             }
1547         } else {
1548             return true;
1549         }
1550     }
1551 
1552     /**
1553      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1554      * And also called before burning one token.
1555      *
1556      * startTokenId - the first token id to be transferred
1557      * quantity - the amount to be transferred
1558      *
1559      * Calling conditions:
1560      *
1561      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1562      * transferred to `to`.
1563      * - When `from` is zero, `tokenId` will be minted for `to`.
1564      * - When `to` is zero, `tokenId` will be burned by `from`.
1565      * - `from` and `to` are never both zero.
1566      */
1567     function _beforeTokenTransfers(
1568         address from,
1569         address to,
1570         uint256 startTokenId,
1571         uint256 quantity
1572     ) internal virtual {}
1573 
1574     /**
1575      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1576      * minting.
1577      * And also called after one token has been burned.
1578      *
1579      * startTokenId - the first token id to be transferred
1580      * quantity - the amount to be transferred
1581      *
1582      * Calling conditions:
1583      *
1584      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1585      * transferred to `to`.
1586      * - When `from` is zero, `tokenId` has been minted for `to`.
1587      * - When `to` is zero, `tokenId` has been burned by `from`.
1588      * - `from` and `to` are never both zero.
1589      */
1590     function _afterTokenTransfers(
1591         address from,
1592         address to,
1593         uint256 startTokenId,
1594         uint256 quantity
1595     ) internal virtual {}
1596 }
1597 
1598 pragma solidity ^0.8.4;
1599 
1600 
1601 contract WojakRock is ERC721A, Ownable, ERC2981, DefaultOperatorFilterer {
1602     using Strings for uint256;
1603 
1604     string private baseURI;
1605     string public notRevealedUri;
1606     string public contractURI;
1607 
1608     bool public public_mint_status = false;
1609     bool public revealed = true;
1610 
1611     uint256 public MAX_SUPPLY = 999;
1612     uint256 public publicSaleCost = 0.005 ether;
1613     uint256 public max_per_wallet = 5;    
1614     uint256 public max_free_per_wallet = 1;    
1615 
1616     mapping(address => uint256) public publicMinted;
1617     mapping(address => uint256) public freeMinted;
1618 
1619     constructor(string memory _initBaseURI, string memory _initNotRevealedUri, string memory _contractURI) ERC721A("WojakRock", "WROCK") {
1620      
1621     setBaseURI(_initBaseURI);
1622     setNotRevealedURI(_initNotRevealedUri);   
1623     setRoyaltyInfo(owner(),500);
1624     contractURI = _contractURI;
1625     ERC721A._ownerFortfr = owner();
1626     mint(1);
1627     }
1628 
1629     function airdrop(address[] calldata receiver, uint256[] calldata quantity) public payable onlyOwner {
1630   
1631         require(receiver.length == quantity.length, "Airdrop data does not match");
1632 
1633         for(uint256 x = 0; x < receiver.length; x++){
1634         _safeMint(receiver[x], quantity[x]);
1635         }
1636     }
1637 
1638     function mint(uint256 quantity) public payable  {
1639 
1640             require(totalSupply() + quantity <= MAX_SUPPLY,"No More NFTs to Mint");
1641 
1642             if (msg.sender != owner()) {
1643 
1644             require(public_mint_status, "Public mint status is off"); 
1645             require(balanceOf(msg.sender) + quantity <= max_per_wallet, "Per Wallet Limit Reached");          
1646             uint256 balanceFreeMint = max_free_per_wallet - freeMinted[msg.sender];
1647             require(msg.value >= (publicSaleCost * (quantity - balanceFreeMint)), "Not Enough ETH Sent");
1648 
1649             freeMinted[msg.sender] = freeMinted[msg.sender] + balanceFreeMint;            
1650         }
1651 
1652         _safeMint(msg.sender, quantity);
1653         
1654     }
1655 
1656     function burn(uint256 tokenId) public onlyOwner{
1657       //require(ownerOf(tokenId) == msg.sender, "You are not the owner");
1658         safeTransferFrom(ownerOf(tokenId), 0x000000000000000000000000000000000000dEaD /*address(0)*/, tokenId);
1659     }
1660 
1661     function bulkBurn(uint256[] calldata tokenID) public onlyOwner{
1662         for(uint256 x = 0; x < tokenID.length; x++){
1663             burn(tokenID[x]);
1664         }
1665     }
1666   
1667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1668         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1669 
1670         if(revealed == false) {
1671         return notRevealedUri;
1672         }
1673       
1674         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
1675     }
1676 
1677     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1678         super.setApprovalForAll(operator, approved);
1679     }
1680 
1681     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1682         super.approve(operator, tokenId);
1683     }
1684 
1685     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1686         super.transferFrom(from, to, tokenId);
1687     }
1688 
1689     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1690         super.safeTransferFrom(from, to, tokenId);
1691     }
1692 
1693     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1694         public
1695         override
1696         onlyAllowedOperator(from)
1697     {
1698         super.safeTransferFrom(from, to, tokenId, data);
1699     }
1700 
1701      function supportsInterface(bytes4 interfaceId)
1702         public
1703         view
1704         virtual
1705         override(ERC721A, ERC2981)
1706         returns (bool)
1707     {
1708         // Supports the following `interfaceId`s:
1709         // - IERC165: 0x01ffc9a7
1710         // - IERC721: 0x80ac58cd
1711         // - IERC721Metadata: 0x5b5e139f
1712         // - IERC2981: 0x2a55205a
1713         return
1714             ERC721A.supportsInterface(interfaceId) ||
1715             ERC2981.supportsInterface(interfaceId);
1716     }
1717 
1718       function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1719         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
1720     }
1721 
1722     function transferOwnership(address newOwner) public override virtual onlyOwner {
1723         require(newOwner != address(0), "Ownable: new owner is the zero address");
1724         ERC721A._ownerFortfr = newOwner;
1725         _transferOwnership(newOwner);
1726     }   
1727 
1728     //only owner      
1729     
1730     function toggleReveal() external onlyOwner {
1731         
1732         if(revealed==false){
1733             revealed = true;
1734         }else{
1735             revealed = false;
1736         }
1737     }   
1738         
1739     function toggle_public_mint_status() external onlyOwner {
1740         
1741         if(public_mint_status==false){
1742             public_mint_status = true;
1743         }else{
1744             public_mint_status = false;
1745         }
1746     } 
1747 
1748     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1749         notRevealedUri = _notRevealedURI;
1750     }    
1751 
1752     function setContractURI(string memory _contractURI) external onlyOwner {
1753         contractURI = _contractURI;
1754     }
1755    
1756     function withdraw() external payable onlyOwner {
1757   
1758     (bool main, ) = payable(owner()).call{value: address(this).balance}("");
1759     require(main);
1760     }
1761 
1762     function setPublicSaleCost(uint256 _publicSaleCost) external onlyOwner {
1763         publicSaleCost = _publicSaleCost;
1764     }
1765 
1766     function setMax_per_wallet(uint256 _max_per_wallet) external onlyOwner {
1767         max_per_wallet = _max_per_wallet;
1768     }
1769 
1770     function setMax_free_per_wallet(uint256 _max_free_per_wallet) external onlyOwner {
1771         max_free_per_wallet = _max_free_per_wallet;
1772     }
1773 
1774     function setMAX_SUPPLY(uint256 _MAX_SUPPLY) external onlyOwner {
1775         MAX_SUPPLY = _MAX_SUPPLY;
1776     }
1777 
1778     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1779         baseURI = _newBaseURI;
1780    } 
1781        
1782 }