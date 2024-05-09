1 // File: IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }
31 
32 // File: OperatorFilterer.sol
33 
34 
35 pragma solidity ^0.8.13;
36 
37 
38 abstract contract OperatorFilterer {
39     error OperatorNotAllowed(address operator);
40 
41     IOperatorFilterRegistry constant operatorFilterRegistry =
42         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
43 
44     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
45         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
46         // will not revert, but the contract will need to be registered with the registry once it is deployed in
47         // order for the modifier to filter addresses.
48         if (address(operatorFilterRegistry).code.length > 0) {
49             if (subscribe) {
50                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
51             } else {
52                 if (subscriptionOrRegistrantToCopy != address(0)) {
53                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
54                 } else {
55                     operatorFilterRegistry.register(address(this));
56                 }
57             }
58         }
59     }
60 
61     modifier onlyAllowedOperator(address from) virtual {
62         // Check registry code length to facilitate testing in environments without a deployed registry.
63         if (address(operatorFilterRegistry).code.length > 0) {
64             // Allow spending tokens from addresses with balance
65             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
66             // from an EOA.
67             if (from == msg.sender) {
68                 _;
69                 return;
70             }
71             if (
72                 !(
73                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
74                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
75                 )
76             ) {
77                 revert OperatorNotAllowed(msg.sender);
78             }
79         }
80         _;
81     }
82 }
83 
84 // File: DefaultOperatorFilterer.sol
85 
86 
87 pragma solidity ^0.8.13;
88 
89 
90 abstract contract DefaultOperatorFilterer is OperatorFilterer {
91     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
92 
93     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
94 }
95 
96 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
97 
98 
99 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev These functions deal with verification of Merkle Trees proofs.
105  *
106  * The proofs can be generated using the JavaScript library
107  * https://github.com/miguelmota/merkletreejs[merkletreejs].
108  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
109  *
110  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
111  *
112  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
113  * hashing, or use a hash function other than keccak256 for hashing leaves.
114  * This is because the concatenation of a sorted pair of internal nodes in
115  * the merkle tree could be reinterpreted as a leaf value.
116  */
117 library MerkleProof {
118     /**
119      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
120      * defined by `root`. For this, a `proof` must be provided, containing
121      * sibling hashes on the branch from the leaf to the root of the tree. Each
122      * pair of leaves and each pair of pre-images are assumed to be sorted.
123      */
124     function verify(
125         bytes32[] memory proof,
126         bytes32 root,
127         bytes32 leaf
128     ) internal pure returns (bool) {
129         return processProof(proof, leaf) == root;
130     }
131 
132     /**
133      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
134      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
135      * hash matches the root of the tree. When processing the proof, the pairs
136      * of leafs & pre-images are assumed to be sorted.
137      *
138      * _Available since v4.4._
139      */
140     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
141         bytes32 computedHash = leaf;
142         for (uint256 i = 0; i < proof.length; i++) {
143             bytes32 proofElement = proof[i];
144             if (computedHash <= proofElement) {
145                 // Hash(current computed hash + current element of the proof)
146                 computedHash = _efficientHash(computedHash, proofElement);
147             } else {
148                 // Hash(current element of the proof + current computed hash)
149                 computedHash = _efficientHash(proofElement, computedHash);
150             }
151         }
152         return computedHash;
153     }
154 
155     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
156         assembly {
157             mstore(0x00, a)
158             mstore(0x20, b)
159             value := keccak256(0x00, 0x40)
160         }
161     }
162 }
163 
164 // File: @openzeppelin/contracts/utils/Address.sol
165 
166 
167 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
168 
169 pragma solidity ^0.8.1;
170 
171 /**
172  * @dev Collection of functions related to the address type
173  */
174 library Address {
175     /**
176      * @dev Returns true if `account` is a contract.
177      *
178      * [IMPORTANT]
179      * ====
180      * It is unsafe to assume that an address for which this function returns
181      * false is an externally-owned account (EOA) and not a contract.
182      *
183      * Among others, `isContract` will return false for the following
184      * types of addresses:
185      *
186      *  - an externally-owned account
187      *  - a contract in construction
188      *  - an address where a contract will be created
189      *  - an address where a contract lived, but was destroyed
190      * ====
191      *
192      * [IMPORTANT]
193      * ====
194      * You shouldn't rely on `isContract` to protect against flash loan attacks!
195      *
196      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
197      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
198      * constructor.
199      * ====
200      */
201     function isContract(address account) internal view returns (bool) {
202         // This method relies on extcodesize/address.code.length, which returns 0
203         // for contracts in construction, since the code is only stored at the end
204         // of the constructor execution.
205 
206         return account.code.length > 0;
207     }
208 
209     /**
210      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
211      * `recipient`, forwarding all available gas and reverting on errors.
212      *
213      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
214      * of certain opcodes, possibly making contracts go over the 2300 gas limit
215      * imposed by `transfer`, making them unable to receive funds via
216      * `transfer`. {sendValue} removes this limitation.
217      *
218      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
219      *
220      * IMPORTANT: because control is transferred to `recipient`, care must be
221      * taken to not create reentrancy vulnerabilities. Consider using
222      * {ReentrancyGuard} or the
223      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
224      */
225     function sendValue(address payable recipient, uint256 amount) internal {
226         require(address(this).balance >= amount, "Address: insufficient balance");
227 
228         (bool success, ) = recipient.call{value: amount}("");
229         require(success, "Address: unable to send value, recipient may have reverted");
230     }
231 
232     /**
233      * @dev Performs a Solidity function call using a low level `call`. A
234      * plain `call` is an unsafe replacement for a function call: use this
235      * function instead.
236      *
237      * If `target` reverts with a revert reason, it is bubbled up by this
238      * function (like regular Solidity function calls).
239      *
240      * Returns the raw returned data. To convert to the expected return value,
241      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
242      *
243      * Requirements:
244      *
245      * - `target` must be a contract.
246      * - calling `target` with `data` must not revert.
247      *
248      * _Available since v3.1._
249      */
250     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
251         return functionCall(target, data, "Address: low-level call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
256      * `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, 0, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but also transferring `value` wei to `target`.
271      *
272      * Requirements:
273      *
274      * - the calling contract must have an ETH balance of at least `value`.
275      * - the called Solidity function must be `payable`.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(
280         address target,
281         bytes memory data,
282         uint256 value
283     ) internal returns (bytes memory) {
284         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
289      * with `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(
294         address target,
295         bytes memory data,
296         uint256 value,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         require(address(this).balance >= value, "Address: insufficient balance for call");
300         require(isContract(target), "Address: call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.call{value: value}(data);
303         return verifyCallResult(success, returndata, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but performing a static call.
309      *
310      * _Available since v3.3._
311      */
312     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
313         return functionStaticCall(target, data, "Address: low-level static call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
318      * but performing a static call.
319      *
320      * _Available since v3.3._
321      */
322     function functionStaticCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal view returns (bytes memory) {
327         require(isContract(target), "Address: static call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.staticcall(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a delegate call.
336      *
337      * _Available since v3.4._
338      */
339     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
340         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a delegate call.
346      *
347      * _Available since v3.4._
348      */
349     function functionDelegateCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal returns (bytes memory) {
354         require(isContract(target), "Address: delegate call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.delegatecall(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
362      * revert reason using the provided one.
363      *
364      * _Available since v4.3._
365      */
366     function verifyCallResult(
367         bool success,
368         bytes memory returndata,
369         string memory errorMessage
370     ) internal pure returns (bytes memory) {
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
389 
390 
391 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @title ERC721 token receiver interface
397  * @dev Interface for any contract that wants to support safeTransfers
398  * from ERC721 asset contracts.
399  */
400 interface IERC721Receiver {
401     /**
402      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
403      * by `operator` from `from`, this function is called.
404      *
405      * It must return its Solidity selector to confirm the token transfer.
406      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
407      *
408      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
409      */
410     function onERC721Received(
411         address operator,
412         address from,
413         uint256 tokenId,
414         bytes calldata data
415     ) external returns (bytes4);
416 }
417 
418 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
419 
420 
421 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @dev Interface of the ERC165 standard, as defined in the
427  * https://eips.ethereum.org/EIPS/eip-165[EIP].
428  *
429  * Implementers can declare support of contract interfaces, which can then be
430  * queried by others ({ERC165Checker}).
431  *
432  * For an implementation, see {ERC165}.
433  */
434 interface IERC165 {
435     /**
436      * @dev Returns true if this contract implements the interface defined by
437      * `interfaceId`. See the corresponding
438      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
439      * to learn more about how these ids are created.
440      *
441      * This function call must use less than 30 000 gas.
442      */
443     function supportsInterface(bytes4 interfaceId) external view returns (bool);
444 }
445 
446 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev Implementation of the {IERC165} interface.
456  *
457  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
458  * for the additional interface id that will be supported. For example:
459  *
460  * ```solidity
461  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
462  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
463  * }
464  * ```
465  *
466  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
467  */
468 abstract contract ERC165 is IERC165 {
469     /**
470      * @dev See {IERC165-supportsInterface}.
471      */
472     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
473         return interfaceId == type(IERC165).interfaceId;
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
478 
479 
480 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Required interface of an ERC721 compliant contract.
487  */
488 interface IERC721 is IERC165 {
489     /**
490      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
491      */
492     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
493 
494     /**
495      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
496      */
497     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
498 
499     /**
500      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
501      */
502     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
503 
504     /**
505      * @dev Returns the number of tokens in ``owner``'s account.
506      */
507     function balanceOf(address owner) external view returns (uint256 balance);
508 
509     /**
510      * @dev Returns the owner of the `tokenId` token.
511      *
512      * Requirements:
513      *
514      * - `tokenId` must exist.
515      */
516     function ownerOf(uint256 tokenId) external view returns (address owner);
517 
518     /**
519      * @dev Safely transfers `tokenId` token from `from` to `to`.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must exist and be owned by `from`.
526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
527      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
528      *
529      * Emits a {Transfer} event.
530      */
531     function safeTransferFrom(
532         address from,
533         address to,
534         uint256 tokenId,
535         bytes calldata data
536     ) external;
537 
538     /**
539      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
540      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
541      *
542      * Requirements:
543      *
544      * - `from` cannot be the zero address.
545      * - `to` cannot be the zero address.
546      * - `tokenId` token must exist and be owned by `from`.
547      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
548      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
549      *
550      * Emits a {Transfer} event.
551      */
552     function safeTransferFrom(
553         address from,
554         address to,
555         uint256 tokenId
556     ) external;
557 
558     /**
559      * @dev Transfers `tokenId` token from `from` to `to`.
560      *
561      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must be owned by `from`.
568      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
569      *
570      * Emits a {Transfer} event.
571      */
572     function transferFrom(
573         address from,
574         address to,
575         uint256 tokenId
576     ) external;
577 
578     /**
579      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
580      * The approval is cleared when the token is transferred.
581      *
582      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
583      *
584      * Requirements:
585      *
586      * - The caller must own the token or be an approved operator.
587      * - `tokenId` must exist.
588      *
589      * Emits an {Approval} event.
590      */
591     function approve(address to, uint256 tokenId) external;
592 
593     /**
594      * @dev Approve or remove `operator` as an operator for the caller.
595      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
596      *
597      * Requirements:
598      *
599      * - The `operator` cannot be the caller.
600      *
601      * Emits an {ApprovalForAll} event.
602      */
603     function setApprovalForAll(address operator, bool _approved) external;
604 
605     /**
606      * @dev Returns the account approved for `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function getApproved(uint256 tokenId) external view returns (address operator);
613 
614     /**
615      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
616      *
617      * See {setApprovalForAll}
618      */
619     function isApprovedForAll(address owner, address operator) external view returns (bool);
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 
630 /**
631  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
632  * @dev See https://eips.ethereum.org/EIPS/eip-721
633  */
634 interface IERC721Metadata is IERC721 {
635     /**
636      * @dev Returns the token collection name.
637      */
638     function name() external view returns (string memory);
639 
640     /**
641      * @dev Returns the token collection symbol.
642      */
643     function symbol() external view returns (string memory);
644 
645     /**
646      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
647      */
648     function tokenURI(uint256 tokenId) external view returns (string memory);
649 }
650 
651 // File: @openzeppelin/contracts/utils/Context.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Provides information about the current execution context, including the
660  * sender of the transaction and its data. While these are generally available
661  * via msg.sender and msg.data, they should not be accessed in such a direct
662  * manner, since when dealing with meta-transactions the account sending and
663  * paying for execution may not be the actual sender (as far as an application
664  * is concerned).
665  *
666  * This contract is only required for intermediate, library-like contracts.
667  */
668 abstract contract Context {
669     function _msgSender() internal view virtual returns (address) {
670         return msg.sender;
671     }
672 
673     function _msgData() internal view virtual returns (bytes calldata) {
674         return msg.data;
675     }
676 }
677 
678 // File: @openzeppelin/contracts/access/Ownable.sol
679 
680 
681 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @dev Contract module which provides a basic access control mechanism, where
688  * there is an account (an owner) that can be granted exclusive access to
689  * specific functions.
690  *
691  * By default, the owner account will be the one that deploys the contract. This
692  * can later be changed with {transferOwnership}.
693  *
694  * This module is used through inheritance. It will make available the modifier
695  * `onlyOwner`, which can be applied to your functions to restrict their use to
696  * the owner.
697  */
698 abstract contract Ownable is Context {
699     address private _owner;
700 
701     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
702 
703     /**
704      * @dev Initializes the contract setting the deployer as the initial owner.
705      */
706     constructor() {
707         _transferOwnership(_msgSender());
708     }
709 
710     /**
711      * @dev Returns the address of the current owner.
712      */
713     function owner() public view virtual returns (address) {
714         return _owner;
715     }
716 
717     /**
718      * @dev Throws if called by any account other than the owner.
719      */
720     modifier onlyOwner() {
721         require(owner() == _msgSender(), "Ownable: caller is not the owner");
722         _;
723     }
724 
725     /**
726      * @dev Leaves the contract without owner. It will not be possible to call
727      * `onlyOwner` functions anymore. Can only be called by the current owner.
728      *
729      * NOTE: Renouncing ownership will leave the contract without an owner,
730      * thereby removing any functionality that is only available to the owner.
731      */
732     function renounceOwnership() public virtual onlyOwner {
733         _transferOwnership(address(0));
734     }
735 
736     /**
737      * @dev Transfers ownership of the contract to a new account (`newOwner`).
738      * Can only be called by the current owner.
739      */
740     function transferOwnership(address newOwner) public virtual onlyOwner {
741         require(newOwner != address(0), "Ownable: new owner is the zero address");
742         _transferOwnership(newOwner);
743     }
744 
745     /**
746      * @dev Transfers ownership of the contract to a new account (`newOwner`).
747      * Internal function without access restriction.
748      */
749     function _transferOwnership(address newOwner) internal virtual {
750         address oldOwner = _owner;
751         _owner = newOwner;
752         emit OwnershipTransferred(oldOwner, newOwner);
753     }
754 }
755 
756 // File: @openzeppelin/contracts/utils/Strings.sol
757 
758 
759 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
760 
761 pragma solidity ^0.8.0;
762 
763 /**
764  * @dev String operations.
765  */
766 library Strings {
767     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
768 
769     /**
770      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
771      */
772     function toString(uint256 value) internal pure returns (string memory) {
773         // Inspired by OraclizeAPI's implementation - MIT licence
774         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
775 
776         if (value == 0) {
777             return "0";
778         }
779         uint256 temp = value;
780         uint256 digits;
781         while (temp != 0) {
782             digits++;
783             temp /= 10;
784         }
785         bytes memory buffer = new bytes(digits);
786         while (value != 0) {
787             digits -= 1;
788             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
789             value /= 10;
790         }
791         return string(buffer);
792     }
793 
794     /**
795      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
796      */
797     function toHexString(uint256 value) internal pure returns (string memory) {
798         if (value == 0) {
799             return "0x00";
800         }
801         uint256 temp = value;
802         uint256 length = 0;
803         while (temp != 0) {
804             length++;
805             temp >>= 8;
806         }
807         return toHexString(value, length);
808     }
809 
810     /**
811      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
812      */
813     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
814         bytes memory buffer = new bytes(2 * length + 2);
815         buffer[0] = "0";
816         buffer[1] = "x";
817         for (uint256 i = 2 * length + 1; i > 1; --i) {
818             buffer[i] = _HEX_SYMBOLS[value & 0xf];
819             value >>= 4;
820         }
821         require(value == 0, "Strings: hex length insufficient");
822         return string(buffer);
823     }
824 }
825 
826 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
827 
828 
829 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
830 
831 pragma solidity ^0.8.0;
832 
833 
834 
835 
836 
837 
838 
839 
840 /**
841  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
842  * the Metadata extension, but not including the Enumerable extension, which is available separately as
843  * {ERC721Enumerable}.
844  */
845 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
846     using Address for address;
847     using Strings for uint256;
848 
849     // Token name
850     string private _name;
851 
852     // Token symbol
853     string private _symbol;
854 
855     // Mapping from token ID to owner address
856     mapping(uint256 => address) private _owners;
857 
858     // Mapping owner address to token count
859     mapping(address => uint256) private _balances;
860 
861     // Mapping from token ID to approved address
862     mapping(uint256 => address) private _tokenApprovals;
863 
864     // Mapping from owner to operator approvals
865     mapping(address => mapping(address => bool)) private _operatorApprovals;
866 
867     /**
868      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
869      */
870     constructor(string memory name_, string memory symbol_) {
871         _name = name_;
872         _symbol = symbol_;
873     }
874 
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
879         return
880             interfaceId == type(IERC721).interfaceId ||
881             interfaceId == type(IERC721Metadata).interfaceId ||
882             super.supportsInterface(interfaceId);
883     }
884 
885     /**
886      * @dev See {IERC721-balanceOf}.
887      */
888     function balanceOf(address owner) public view virtual override returns (uint256) {
889         require(owner != address(0), "ERC721: balance query for the zero address");
890         return _balances[owner];
891     }
892 
893     /**
894      * @dev See {IERC721-ownerOf}.
895      */
896     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
897         address owner = _owners[tokenId];
898         require(owner != address(0), "ERC721: owner query for nonexistent token");
899         return owner;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-name}.
904      */
905     function name() public view virtual override returns (string memory) {
906         return _name;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-symbol}.
911      */
912     function symbol() public view virtual override returns (string memory) {
913         return _symbol;
914     }
915 
916     /**
917      * @dev See {IERC721Metadata-tokenURI}.
918      */
919     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
920         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
921 
922         string memory baseURI = _baseURI();
923         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
924     }
925 
926     /**
927      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
928      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
929      * by default, can be overridden in child contracts.
930      */
931     function _baseURI() internal view virtual returns (string memory) {
932         return "";
933     }
934 
935     /**
936      * @dev See {IERC721-approve}.
937      */
938     function approve(address to, uint256 tokenId) public virtual override {
939         address owner = ERC721.ownerOf(tokenId);
940         require(to != owner, "ERC721: approval to current owner");
941 
942         require(
943             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
944             "ERC721: approve caller is not owner nor approved for all"
945         );
946 
947         _approve(to, tokenId);
948     }
949 
950     /**
951      * @dev See {IERC721-getApproved}.
952      */
953     function getApproved(uint256 tokenId) public view virtual override returns (address) {
954         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
955 
956         return _tokenApprovals[tokenId];
957     }
958 
959     /**
960      * @dev See {IERC721-setApprovalForAll}.
961      */
962     function setApprovalForAll(address operator, bool approved) public virtual override {
963         _setApprovalForAll(_msgSender(), operator, approved);
964     }
965 
966     /**
967      * @dev See {IERC721-isApprovedForAll}.
968      */
969     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
970         return _operatorApprovals[owner][operator];
971     }
972 
973     /**
974      * @dev See {IERC721-transferFrom}.
975      */
976     function transferFrom(
977         address from,
978         address to,
979         uint256 tokenId
980     ) public virtual override {
981         //solhint-disable-next-line max-line-length
982         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
983 
984         _transfer(from, to, tokenId);
985     }
986 
987     /**
988      * @dev See {IERC721-safeTransferFrom}.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) public virtual override {
995         safeTransferFrom(from, to, tokenId, "");
996     }
997 
998     /**
999      * @dev See {IERC721-safeTransferFrom}.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId,
1005         bytes memory _data
1006     ) public virtual override {
1007         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1008         _safeTransfer(from, to, tokenId, _data);
1009     }
1010 
1011     /**
1012      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1013      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1014      *
1015      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1016      *
1017      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1018      * implement alternative mechanisms to perform token transfer, such as signature-based.
1019      *
1020      * Requirements:
1021      *
1022      * - `from` cannot be the zero address.
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must exist and be owned by `from`.
1025      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _safeTransfer(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) internal virtual {
1035         _transfer(from, to, tokenId);
1036         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1037     }
1038 
1039     /**
1040      * @dev Returns whether `tokenId` exists.
1041      *
1042      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1043      *
1044      * Tokens start existing when they are minted (`_mint`),
1045      * and stop existing when they are burned (`_burn`).
1046      */
1047     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1048         return _owners[tokenId] != address(0);
1049     }
1050 
1051     /**
1052      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      */
1058     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1059         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1060         address owner = ERC721.ownerOf(tokenId);
1061         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1062     }
1063 
1064     /**
1065      * @dev Safely mints `tokenId` and transfers it to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `tokenId` must not exist.
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeMint(address to, uint256 tokenId) internal virtual {
1075         _safeMint(to, tokenId, "");
1076     }
1077 
1078     /**
1079      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1080      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1081      */
1082     function _safeMint(
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) internal virtual {
1087         _mint(to, tokenId);
1088         require(
1089             _checkOnERC721Received(address(0), to, tokenId, _data),
1090             "ERC721: transfer to non ERC721Receiver implementer"
1091         );
1092     }
1093 
1094     /**
1095      * @dev Mints `tokenId` and transfers it to `to`.
1096      *
1097      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must not exist.
1102      * - `to` cannot be the zero address.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _mint(address to, uint256 tokenId) internal virtual {
1107         require(to != address(0), "ERC721: mint to the zero address");
1108         require(!_exists(tokenId), "ERC721: token already minted");
1109 
1110         _beforeTokenTransfer(address(0), to, tokenId);
1111 
1112         _balances[to] += 1;
1113         _owners[tokenId] = to;
1114 
1115         emit Transfer(address(0), to, tokenId);
1116 
1117         _afterTokenTransfer(address(0), to, tokenId);
1118     }
1119 
1120     /**
1121      * @dev Destroys `tokenId`.
1122      * The approval is cleared when the token is burned.
1123      *
1124      * Requirements:
1125      *
1126      * - `tokenId` must exist.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _burn(uint256 tokenId) internal virtual {
1131         address owner = ERC721.ownerOf(tokenId);
1132 
1133         _beforeTokenTransfer(owner, address(0), tokenId);
1134 
1135         // Clear approvals
1136         _approve(address(0), tokenId);
1137 
1138         _balances[owner] -= 1;
1139         delete _owners[tokenId];
1140 
1141         emit Transfer(owner, address(0), tokenId);
1142 
1143         _afterTokenTransfer(owner, address(0), tokenId);
1144     }
1145 
1146     /**
1147      * @dev Transfers `tokenId` from `from` to `to`.
1148      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must be owned by `from`.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _transfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) internal virtual {
1162         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1163         require(to != address(0), "ERC721: transfer to the zero address");
1164 
1165         _beforeTokenTransfer(from, to, tokenId);
1166 
1167         // Clear approvals from the previous owner
1168         _approve(address(0), tokenId);
1169 
1170         _balances[from] -= 1;
1171         _balances[to] += 1;
1172         _owners[tokenId] = to;
1173 
1174         emit Transfer(from, to, tokenId);
1175 
1176         _afterTokenTransfer(from, to, tokenId);
1177     }
1178 
1179     /**
1180      * @dev Approve `to` to operate on `tokenId`
1181      *
1182      * Emits a {Approval} event.
1183      */
1184     function _approve(address to, uint256 tokenId) internal virtual {
1185         _tokenApprovals[tokenId] = to;
1186         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1187     }
1188 
1189     /**
1190      * @dev Approve `operator` to operate on all of `owner` tokens
1191      *
1192      * Emits a {ApprovalForAll} event.
1193      */
1194     function _setApprovalForAll(
1195         address owner,
1196         address operator,
1197         bool approved
1198     ) internal virtual {
1199         require(owner != operator, "ERC721: approve to caller");
1200         _operatorApprovals[owner][operator] = approved;
1201         emit ApprovalForAll(owner, operator, approved);
1202     }
1203 
1204     /**
1205      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1206      * The call is not executed if the target address is not a contract.
1207      *
1208      * @param from address representing the previous owner of the given token ID
1209      * @param to target address that will receive the tokens
1210      * @param tokenId uint256 ID of the token to be transferred
1211      * @param _data bytes optional data to send along with the call
1212      * @return bool whether the call correctly returned the expected magic value
1213      */
1214     function _checkOnERC721Received(
1215         address from,
1216         address to,
1217         uint256 tokenId,
1218         bytes memory _data
1219     ) private returns (bool) {
1220         if (to.isContract()) {
1221             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1222                 return retval == IERC721Receiver.onERC721Received.selector;
1223             } catch (bytes memory reason) {
1224                 if (reason.length == 0) {
1225                     revert("ERC721: transfer to non ERC721Receiver implementer");
1226                 } else {
1227                     assembly {
1228                         revert(add(32, reason), mload(reason))
1229                     }
1230                 }
1231             }
1232         } else {
1233             return true;
1234         }
1235     }
1236 
1237     /**
1238      * @dev Hook that is called before any token transfer. This includes minting
1239      * and burning.
1240      *
1241      * Calling conditions:
1242      *
1243      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1244      * transferred to `to`.
1245      * - When `from` is zero, `tokenId` will be minted for `to`.
1246      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1247      * - `from` and `to` are never both zero.
1248      *
1249      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1250      */
1251     function _beforeTokenTransfer(
1252         address from,
1253         address to,
1254         uint256 tokenId
1255     ) internal virtual {}
1256 
1257     /**
1258      * @dev Hook that is called after any transfer of tokens. This includes
1259      * minting and burning.
1260      *
1261      * Calling conditions:
1262      *
1263      * - when `from` and `to` are both non-zero.
1264      * - `from` and `to` are never both zero.
1265      *
1266      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1267      */
1268     function _afterTokenTransfer(
1269         address from,
1270         address to,
1271         uint256 tokenId
1272     ) internal virtual {}
1273 }
1274 
1275 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1276 
1277 
1278 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1279 
1280 pragma solidity ^0.8.0;
1281 
1282 
1283 
1284 /**
1285  * @title ERC721 Burnable Token
1286  * @dev ERC721 Token that can be burned (destroyed).
1287  */
1288 abstract contract ERC721Burnable is Context, ERC721 {
1289     /**
1290      * @dev Burns `tokenId`. See {ERC721-_burn}.
1291      *
1292      * Requirements:
1293      *
1294      * - The caller must own `tokenId` or be an approved operator.
1295      */
1296     function burn(uint256 tokenId) public virtual {
1297         //solhint-disable-next-line max-line-length
1298         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1299         _burn(tokenId);
1300     }
1301 }
1302 
1303 // File: GEISHA.sol
1304 
1305 
1306 
1307 pragma solidity ^0.8.13;
1308 
1309 
1310 
1311 
1312 
1313 
1314 
1315 
1316 contract GEISHA is Ownable, ERC721Burnable, DefaultOperatorFilterer {
1317 
1318     string public uriPrefix = '';
1319 
1320     string public uriSuffix = '.json';
1321 
1322     uint256 public max_supply = 888;
1323 
1324     uint256 public amountMintPerAccount = 1;
1325 
1326     uint256 public currentToken = 0;
1327 
1328 
1329 
1330     bytes32 public whitelistRoot;
1331 
1332     bool public publicSaleEnabled;
1333 
1334 
1335 
1336     event MintSuccessful(address user);
1337 
1338 
1339 
1340     constructor() ERC721("888GEISHA", "888GEISHA") { 
1341 
1342     }
1343 
1344 
1345 
1346     function mint() external {
1347 
1348         require(balanceOf(msg.sender) < amountMintPerAccount, 'Each address may only mint x NFTs!');
1349 
1350         require(currentToken < max_supply, 'No more NFT available to mint!');
1351 
1352         require(publicSaleEnabled, 'Public sale not live');
1353 
1354 
1355 
1356         currentToken += 1;
1357 
1358         _safeMint(msg.sender, currentToken);
1359 
1360         
1361 
1362         emit MintSuccessful(msg.sender);
1363 
1364     }
1365 
1366 
1367 
1368     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1369 
1370         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1371 
1372 
1373 
1374         string memory currentBaseURI = _baseURI();
1375 
1376         return bytes(currentBaseURI).length > 0
1377 
1378             ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), uriSuffix))
1379 
1380             : '';
1381 
1382     }
1383 
1384 
1385 
1386     function _baseURI() internal pure override returns (string memory) {
1387 
1388         return "ipfs://QmTtJeJKeisjtmA6LpbfXFoQ9kdczpdMBFWiTAeNb2xFid/";
1389 
1390     }
1391 
1392     
1393 
1394     function baseTokenURI() public pure returns (string memory) {
1395 
1396         return _baseURI();
1397 
1398     }
1399 
1400 
1401 
1402     function contractURI() public pure returns (string memory) {
1403 
1404         return "ipfs://QmVkah9VhgerH3jHnP53sDmQWhqhwJ5kRadjmykYbaQV8f/";
1405 
1406     }
1407 
1408 
1409 
1410     function setAmountMintPerAccount(uint _amountMintPerAccount) public onlyOwner {
1411 
1412         amountMintPerAccount = _amountMintPerAccount;
1413 
1414     }
1415 
1416 
1417 
1418     function setPublicSaleEnabled(bool _state) public onlyOwner {
1419 
1420         publicSaleEnabled = _state;
1421 
1422     }
1423 
1424 
1425 
1426     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1427 
1428         super.transferFrom(from, to, tokenId);
1429 
1430     }
1431 
1432 
1433 
1434     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1435 
1436         super.safeTransferFrom(from, to, tokenId);
1437 
1438     }
1439 
1440 
1441 
1442     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1443 
1444         public
1445 
1446         override
1447 
1448         onlyAllowedOperator(from)
1449 
1450     {
1451 
1452         super.safeTransferFrom(from, to, tokenId, data);
1453 
1454     }
1455 
1456     
1457 
1458     function withdraw() external onlyOwner {
1459 
1460         payable(msg.sender).transfer(address(this).balance);
1461 
1462     }
1463 
1464 }