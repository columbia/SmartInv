1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.7;
3 
4 /**
5  * @dev These functions deal with verification of Merkle Tree proofs.
6  *
7  * The proofs can be generated using the JavaScript library
8  * https://github.com/miguelmota/merkletreejs[merkletreejs].
9  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
10  *
11  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
12  *
13  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
14  * hashing, or use a hash function other than keccak256 for hashing leaves.
15  * This is because the concatenation of a sorted pair of internal nodes in
16  * the merkle tree could be reinterpreted as a leaf value.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Calldata version of {verify}
35      *
36      * _Available since v4.7._
37      */
38     function verifyCalldata(
39         bytes32[] calldata proof,
40         bytes32 root,
41         bytes32 leaf
42     ) internal pure returns (bool) {
43         return processProofCalldata(proof, leaf) == root;
44     }
45 
46     /**
47      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
48      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
49      * hash matches the root of the tree. When processing the proof, the pairs
50      * of leafs & pre-images are assumed to be sorted.
51      *
52      * _Available since v4.4._
53      */
54     function processProof(bytes32[] memory proof, bytes32 leaf)
55         internal
56         pure
57         returns (bytes32)
58     {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
72         internal
73         pure
74         returns (bytes32)
75     {
76         bytes32 computedHash = leaf;
77         for (uint256 i = 0; i < proof.length; i++) {
78             computedHash = _hashPair(computedHash, proof[i]);
79         }
80         return computedHash;
81     }
82 
83     /**
84      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
85      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
86      *
87      * _Available since v4.7._
88      */
89     function multiProofVerify(
90         bytes32[] memory proof,
91         bool[] memory proofFlags,
92         bytes32 root,
93         bytes32[] memory leaves
94     ) internal pure returns (bool) {
95         return processMultiProof(proof, proofFlags, leaves) == root;
96     }
97 
98     /**
99      * @dev Calldata version of {multiProofVerify}
100      *
101      * _Available since v4.7._
102      */
103     function multiProofVerifyCalldata(
104         bytes32[] calldata proof,
105         bool[] calldata proofFlags,
106         bytes32 root,
107         bytes32[] memory leaves
108     ) internal pure returns (bool) {
109         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
110     }
111 
112     /**
113      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
114      * consuming from one or the other at each step according to the instructions given by
115      * `proofFlags`.
116      *
117      * _Available since v4.7._
118      */
119     function processMultiProof(
120         bytes32[] memory proof,
121         bool[] memory proofFlags,
122         bytes32[] memory leaves
123     ) internal pure returns (bytes32 merkleRoot) {
124         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
125         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
126         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
127         // the merkle tree.
128         uint256 leavesLen = leaves.length;
129         uint256 totalHashes = proofFlags.length;
130 
131         // Check proof validity.
132         require(
133             leavesLen + proof.length - 1 == totalHashes,
134             "MerkleProof: invalid multiproof"
135         );
136 
137         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
138         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
139         bytes32[] memory hashes = new bytes32[](totalHashes);
140         uint256 leafPos = 0;
141         uint256 hashPos = 0;
142         uint256 proofPos = 0;
143         // At each step, we compute the next hash using two values:
144         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
145         //   get the next hash.
146         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
147         //   `proof` array.
148         for (uint256 i = 0; i < totalHashes; i++) {
149             bytes32 a = leafPos < leavesLen
150                 ? leaves[leafPos++]
151                 : hashes[hashPos++];
152             bytes32 b = proofFlags[i]
153                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
154                 : proof[proofPos++];
155             hashes[i] = _hashPair(a, b);
156         }
157 
158         if (totalHashes > 0) {
159             return hashes[totalHashes - 1];
160         } else if (leavesLen > 0) {
161             return leaves[0];
162         } else {
163             return proof[0];
164         }
165     }
166 
167     /**
168      * @dev Calldata version of {processMultiProof}
169      *
170      * _Available since v4.7._
171      */
172     function processMultiProofCalldata(
173         bytes32[] calldata proof,
174         bool[] calldata proofFlags,
175         bytes32[] memory leaves
176     ) internal pure returns (bytes32 merkleRoot) {
177         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
178         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
179         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
180         // the merkle tree.
181         uint256 leavesLen = leaves.length;
182         uint256 totalHashes = proofFlags.length;
183 
184         // Check proof validity.
185         require(
186             leavesLen + proof.length - 1 == totalHashes,
187             "MerkleProof: invalid multiproof"
188         );
189 
190         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
191         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
192         bytes32[] memory hashes = new bytes32[](totalHashes);
193         uint256 leafPos = 0;
194         uint256 hashPos = 0;
195         uint256 proofPos = 0;
196         // At each step, we compute the next hash using two values:
197         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
198         //   get the next hash.
199         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
200         //   `proof` array.
201         for (uint256 i = 0; i < totalHashes; i++) {
202             bytes32 a = leafPos < leavesLen
203                 ? leaves[leafPos++]
204                 : hashes[hashPos++];
205             bytes32 b = proofFlags[i]
206                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
207                 : proof[proofPos++];
208             hashes[i] = _hashPair(a, b);
209         }
210 
211         if (totalHashes > 0) {
212             return hashes[totalHashes - 1];
213         } else if (leavesLen > 0) {
214             return leaves[0];
215         } else {
216             return proof[0];
217         }
218     }
219 
220     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
221         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
222     }
223 
224     function _efficientHash(bytes32 a, bytes32 b)
225         private
226         pure
227         returns (bytes32 value)
228     {
229         /// @solidity memory-safe-assembly
230         assembly {
231             mstore(0x00, a)
232             mstore(0x20, b)
233             value := keccak256(0x00, 0x40)
234         }
235     }
236 }
237 
238 /**
239  * @dev Provides information about the current execution context, including the
240  * sender of the transaction and its data. While these are generally available
241  * via msg.sender and msg.data, they should not be accessed in such a direct
242  * manner, since when dealing with meta-transactions the account sending and
243  * paying for execution may not be the actual sender (as far as an application
244  * is concerned).
245  *
246  * This contract is only required for intermediate, library-like contracts.
247  */
248 abstract contract Context {
249     function _msgSender() internal view virtual returns (address) {
250         return msg.sender;
251     }
252 
253     function _msgData() internal view virtual returns (bytes calldata) {
254         return msg.data;
255     }
256 }
257 
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * By default, the owner account will be the one that deploys the contract. This
264  * can later be changed with {transferOwnership}.
265  *
266  * This module is used through inheritance. It will make available the modifier
267  * `onlyOwner`, which can be applied to your functions to restrict their use to
268  * the owner.
269  */
270 abstract contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(
274         address indexed previousOwner,
275         address indexed newOwner
276     );
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
323         require(
324             newOwner != address(0),
325             "Ownable: new owner is the zero address"
326         );
327         _transferOwnership(newOwner);
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      * Internal function without access restriction.
333      */
334     function _transferOwnership(address newOwner) internal virtual {
335         address oldOwner = _owner;
336         _owner = newOwner;
337         emit OwnershipTransferred(oldOwner, newOwner);
338     }
339 }
340 
341 /**
342  * @dev Interface of the ERC165 standard, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-165[EIP].
344  *
345  * Implementers can declare support of contract interfaces, which can then be
346  * queried by others ({ERC165Checker}).
347  *
348  * For an implementation, see {ERC165}.
349  */
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 /**
363  * @dev Required interface of an ERC721 compliant contract.
364  */
365 interface IERC721 is IERC165 {
366     /**
367      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
368      */
369     event Transfer(
370         address indexed from,
371         address indexed to,
372         uint256 indexed tokenId
373     );
374 
375     /**
376      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
377      */
378     event Approval(
379         address indexed owner,
380         address indexed approved,
381         uint256 indexed tokenId
382     );
383 
384     /**
385      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
386      */
387     event ApprovalForAll(
388         address indexed owner,
389         address indexed operator,
390         bool approved
391     );
392 
393     /**
394      * @dev Returns the number of tokens in ``owner``'s account.
395      */
396     function balanceOf(address owner) external view returns (uint256 balance);
397 
398     /**
399      * @dev Returns the owner of the `tokenId` token.
400      *
401      * Requirements:
402      *
403      * - `tokenId` must exist.
404      */
405     function ownerOf(uint256 tokenId) external view returns (address owner);
406 
407     /**
408      * @dev Safely transfers `tokenId` token from `from` to `to`.
409      *
410      * Requirements:
411      *
412      * - `from` cannot be the zero address.
413      * - `to` cannot be the zero address.
414      * - `tokenId` token must exist and be owned by `from`.
415      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
416      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
417      *
418      * Emits a {Transfer} event.
419      */
420     function safeTransferFrom(
421         address from,
422         address to,
423         uint256 tokenId,
424         bytes calldata data
425     ) external;
426 
427     /**
428      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
429      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
430      *
431      * Requirements:
432      *
433      * - `from` cannot be the zero address.
434      * - `to` cannot be the zero address.
435      * - `tokenId` token must exist and be owned by `from`.
436      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
438      *
439      * Emits a {Transfer} event.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) external;
446 
447     /**
448      * @dev Transfers `tokenId` token from `from` to `to`.
449      *
450      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must be owned by `from`.
457      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
458      *
459      * Emits a {Transfer} event.
460      */
461     function transferFrom(
462         address from,
463         address to,
464         uint256 tokenId
465     ) external;
466 
467     /**
468      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
469      * The approval is cleared when the token is transferred.
470      *
471      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
472      *
473      * Requirements:
474      *
475      * - The caller must own the token or be an approved operator.
476      * - `tokenId` must exist.
477      *
478      * Emits an {Approval} event.
479      */
480     function approve(address to, uint256 tokenId) external;
481 
482     /**
483      * @dev Approve or remove `operator` as an operator for the caller.
484      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
485      *
486      * Requirements:
487      *
488      * - The `operator` cannot be the caller.
489      *
490      * Emits an {ApprovalForAll} event.
491      */
492     function setApprovalForAll(address operator, bool _approved) external;
493 
494     /**
495      * @dev Returns the account approved for `tokenId` token.
496      *
497      * Requirements:
498      *
499      * - `tokenId` must exist.
500      */
501     function getApproved(uint256 tokenId)
502         external
503         view
504         returns (address operator);
505 
506     /**
507      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
508      *
509      * See {setApprovalForAll}
510      */
511     function isApprovedForAll(address owner, address operator)
512         external
513         view
514         returns (bool);
515 }
516 
517 /**
518  * @title ERC721 token receiver interface
519  * @dev Interface for any contract that wants to support safeTransfers
520  * from ERC721 asset contracts.
521  */
522 interface IERC721Receiver {
523     /**
524      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
525      * by `operator` from `from`, this function is called.
526      *
527      * It must return its Solidity selector to confirm the token transfer.
528      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
529      *
530      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
531      */
532     function onERC721Received(
533         address operator,
534         address from,
535         uint256 tokenId,
536         bytes calldata data
537     ) external returns (bytes4);
538 }
539 
540 /**
541  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
542  * @dev See https://eips.ethereum.org/EIPS/eip-721
543  */
544 interface IERC721Metadata is IERC721 {
545     /**
546      * @dev Returns the token collection name.
547      */
548     function name() external view returns (string memory);
549 
550     /**
551      * @dev Returns the token collection symbol.
552      */
553     function symbol() external view returns (string memory);
554 
555     /**
556      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
557      */
558     function tokenURI(uint256 tokenId) external view returns (string memory);
559 }
560 
561 /**
562  * @dev Collection of functions related to the address type
563  */
564 library Address {
565     /**
566      * @dev Returns true if `account` is a contract.
567      *
568      * [IMPORTANT]
569      * ====
570      * It is unsafe to assume that an address for which this function returns
571      * false is an externally-owned account (EOA) and not a contract.
572      *
573      * Among others, `isContract` will return false for the following
574      * types of addresses:
575      *
576      *  - an externally-owned account
577      *  - a contract in construction
578      *  - an address where a contract will be created
579      *  - an address where a contract lived, but was destroyed
580      * ====
581      *
582      * [IMPORTANT]
583      * ====
584      * You shouldn't rely on `isContract` to protect against flash loan attacks!
585      *
586      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
587      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
588      * constructor.
589      * ====
590      */
591     function isContract(address account) internal view returns (bool) {
592         // This method relies on extcodesize/address.code.length, which returns 0
593         // for contracts in construction, since the code is only stored at the end
594         // of the constructor execution.
595 
596         return account.code.length > 0;
597     }
598 
599     /**
600      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
601      * `recipient`, forwarding all available gas and reverting on errors.
602      *
603      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
604      * of certain opcodes, possibly making contracts go over the 2300 gas limit
605      * imposed by `transfer`, making them unable to receive funds via
606      * `transfer`. {sendValue} removes this limitation.
607      *
608      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
609      *
610      * IMPORTANT: because control is transferred to `recipient`, care must be
611      * taken to not create reentrancy vulnerabilities. Consider using
612      * {ReentrancyGuard} or the
613      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
614      */
615     function sendValue(address payable recipient, uint256 amount) internal {
616         require(
617             address(this).balance >= amount,
618             "Address: insufficient balance"
619         );
620 
621         (bool success, ) = recipient.call{value: amount}("");
622         require(
623             success,
624             "Address: unable to send value, recipient may have reverted"
625         );
626     }
627 
628     /**
629      * @dev Performs a Solidity function call using a low level `call`. A
630      * plain `call` is an unsafe replacement for a function call: use this
631      * function instead.
632      *
633      * If `target` reverts with a revert reason, it is bubbled up by this
634      * function (like regular Solidity function calls).
635      *
636      * Returns the raw returned data. To convert to the expected return value,
637      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
638      *
639      * Requirements:
640      *
641      * - `target` must be a contract.
642      * - calling `target` with `data` must not revert.
643      *
644      * _Available since v3.1._
645      */
646     function functionCall(address target, bytes memory data)
647         internal
648         returns (bytes memory)
649     {
650         return functionCall(target, data, "Address: low-level call failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
655      * `errorMessage` as a fallback revert reason when `target` reverts.
656      *
657      * _Available since v3.1._
658      */
659     function functionCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal returns (bytes memory) {
664         return functionCallWithValue(target, data, 0, errorMessage);
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
669      * but also transferring `value` wei to `target`.
670      *
671      * Requirements:
672      *
673      * - the calling contract must have an ETH balance of at least `value`.
674      * - the called Solidity function must be `payable`.
675      *
676      * _Available since v3.1._
677      */
678     function functionCallWithValue(
679         address target,
680         bytes memory data,
681         uint256 value
682     ) internal returns (bytes memory) {
683         return
684             functionCallWithValue(
685                 target,
686                 data,
687                 value,
688                 "Address: low-level call with value failed"
689             );
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
694      * with `errorMessage` as a fallback revert reason when `target` reverts.
695      *
696      * _Available since v3.1._
697      */
698     function functionCallWithValue(
699         address target,
700         bytes memory data,
701         uint256 value,
702         string memory errorMessage
703     ) internal returns (bytes memory) {
704         require(
705             address(this).balance >= value,
706             "Address: insufficient balance for call"
707         );
708         require(isContract(target), "Address: call to non-contract");
709 
710         (bool success, bytes memory returndata) = target.call{value: value}(
711             data
712         );
713         return verifyCallResult(success, returndata, errorMessage);
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
718      * but performing a static call.
719      *
720      * _Available since v3.3._
721      */
722     function functionStaticCall(address target, bytes memory data)
723         internal
724         view
725         returns (bytes memory)
726     {
727         return
728             functionStaticCall(
729                 target,
730                 data,
731                 "Address: low-level static call failed"
732             );
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
737      * but performing a static call.
738      *
739      * _Available since v3.3._
740      */
741     function functionStaticCall(
742         address target,
743         bytes memory data,
744         string memory errorMessage
745     ) internal view returns (bytes memory) {
746         require(isContract(target), "Address: static call to non-contract");
747 
748         (bool success, bytes memory returndata) = target.staticcall(data);
749         return verifyCallResult(success, returndata, errorMessage);
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
754      * but performing a delegate call.
755      *
756      * _Available since v3.4._
757      */
758     function functionDelegateCall(address target, bytes memory data)
759         internal
760         returns (bytes memory)
761     {
762         return
763             functionDelegateCall(
764                 target,
765                 data,
766                 "Address: low-level delegate call failed"
767             );
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
772      * but performing a delegate call.
773      *
774      * _Available since v3.4._
775      */
776     function functionDelegateCall(
777         address target,
778         bytes memory data,
779         string memory errorMessage
780     ) internal returns (bytes memory) {
781         require(isContract(target), "Address: delegate call to non-contract");
782 
783         (bool success, bytes memory returndata) = target.delegatecall(data);
784         return verifyCallResult(success, returndata, errorMessage);
785     }
786 
787     /**
788      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
789      * revert reason using the provided one.
790      *
791      * _Available since v4.3._
792      */
793     function verifyCallResult(
794         bool success,
795         bytes memory returndata,
796         string memory errorMessage
797     ) internal pure returns (bytes memory) {
798         if (success) {
799             return returndata;
800         } else {
801             // Look for revert reason and bubble it up if present
802             if (returndata.length > 0) {
803                 // The easiest way to bubble the revert reason is using memory via assembly
804                 /// @solidity memory-safe-assembly
805                 assembly {
806                     let returndata_size := mload(returndata)
807                     revert(add(32, returndata), returndata_size)
808                 }
809             } else {
810                 revert(errorMessage);
811             }
812         }
813     }
814 }
815 
816 /**
817  * @dev String operations.
818  */
819 library Strings {
820     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
821     uint8 private constant _ADDRESS_LENGTH = 20;
822 
823     /**
824      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
825      */
826     function toString(uint256 value) internal pure returns (string memory) {
827         // Inspired by OraclizeAPI's implementation - MIT licence
828         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
829 
830         if (value == 0) {
831             return "0";
832         }
833         uint256 temp = value;
834         uint256 digits;
835         while (temp != 0) {
836             digits++;
837             temp /= 10;
838         }
839         bytes memory buffer = new bytes(digits);
840         while (value != 0) {
841             digits -= 1;
842             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
843             value /= 10;
844         }
845         return string(buffer);
846     }
847 
848     /**
849      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
850      */
851     function toHexString(uint256 value) internal pure returns (string memory) {
852         if (value == 0) {
853             return "0x00";
854         }
855         uint256 temp = value;
856         uint256 length = 0;
857         while (temp != 0) {
858             length++;
859             temp >>= 8;
860         }
861         return toHexString(value, length);
862     }
863 
864     /**
865      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
866      */
867     function toHexString(uint256 value, uint256 length)
868         internal
869         pure
870         returns (string memory)
871     {
872         bytes memory buffer = new bytes(2 * length + 2);
873         buffer[0] = "0";
874         buffer[1] = "x";
875         for (uint256 i = 2 * length + 1; i > 1; --i) {
876             buffer[i] = _HEX_SYMBOLS[value & 0xf];
877             value >>= 4;
878         }
879         require(value == 0, "Strings: hex length insufficient");
880         return string(buffer);
881     }
882 
883     /**
884      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
885      */
886     function toHexString(address addr) internal pure returns (string memory) {
887         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
888     }
889 }
890 
891 /**
892  * @dev Implementation of the {IERC165} interface.
893  *
894  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
895  * for the additional interface id that will be supported. For example:
896  *
897  * ```solidity
898  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
899  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
900  * }
901  * ```
902  *
903  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
904  */
905 abstract contract ERC165 is IERC165 {
906     /**
907      * @dev See {IERC165-supportsInterface}.
908      */
909     function supportsInterface(bytes4 interfaceId)
910         public
911         view
912         virtual
913         override
914         returns (bool)
915     {
916         return interfaceId == type(IERC165).interfaceId;
917     }
918 }
919 
920 /**
921  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
922  * the Metadata extension, but not including the Enumerable extension, which is available separately as
923  * {ERC721Enumerable}.
924  */
925 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
926     using Address for address;
927     using Strings for uint256;
928 
929     // Token name
930     string private _name;
931 
932     // Token symbol
933     string private _symbol;
934 
935     // Mapping from token ID to owner address
936     mapping(uint256 => address) private _owners;
937 
938     // Mapping owner address to token count
939     mapping(address => uint256) private _balances;
940 
941     // Mapping from token ID to approved address
942     mapping(uint256 => address) private _tokenApprovals;
943 
944     // Mapping from owner to operator approvals
945     mapping(address => mapping(address => bool)) private _operatorApprovals;
946 
947     /**
948      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
949      */
950     constructor(string memory name_, string memory symbol_) {
951         _name = name_;
952         _symbol = symbol_;
953     }
954 
955     /**
956      * @dev See {IERC165-supportsInterface}.
957      */
958     function supportsInterface(bytes4 interfaceId)
959         public
960         view
961         virtual
962         override(ERC165, IERC165)
963         returns (bool)
964     {
965         return
966             interfaceId == type(IERC721).interfaceId ||
967             interfaceId == type(IERC721Metadata).interfaceId ||
968             super.supportsInterface(interfaceId);
969     }
970 
971     /**
972      * @dev See {IERC721-balanceOf}.
973      */
974     function balanceOf(address owner)
975         public
976         view
977         virtual
978         override
979         returns (uint256)
980     {
981         require(
982             owner != address(0),
983             "ERC721: address zero is not a valid owner"
984         );
985         return _balances[owner];
986     }
987 
988     /**
989      * @dev See {IERC721-ownerOf}.
990      */
991     function ownerOf(uint256 tokenId)
992         public
993         view
994         virtual
995         override
996         returns (address)
997     {
998         address owner = _owners[tokenId];
999         require(owner != address(0), "ERC721: invalid token ID");
1000         return owner;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-name}.
1005      */
1006     function name() public view virtual override returns (string memory) {
1007         return _name;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-symbol}.
1012      */
1013     function symbol() public view virtual override returns (string memory) {
1014         return _symbol;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-tokenURI}.
1019      */
1020     function tokenURI(uint256 tokenId)
1021         public
1022         view
1023         virtual
1024         override
1025         returns (string memory)
1026     {
1027         _requireMinted(tokenId);
1028 
1029         string memory baseURI = _baseURI();
1030         return
1031             bytes(baseURI).length > 0
1032                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1033                 : "";
1034     }
1035 
1036     /**
1037      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1038      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1039      * by default, can be overridden in child contracts.
1040      */
1041     function _baseURI() internal view virtual returns (string memory) {
1042         return "";
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-approve}.
1047      */
1048     function approve(address to, uint256 tokenId) public virtual override {
1049         address owner = ERC721.ownerOf(tokenId);
1050         require(to != owner, "ERC721: approval to current owner");
1051 
1052         require(
1053             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1054             "ERC721: approve caller is not token owner nor approved for all"
1055         );
1056 
1057         _approve(to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-getApproved}.
1062      */
1063     function getApproved(uint256 tokenId)
1064         public
1065         view
1066         virtual
1067         override
1068         returns (address)
1069     {
1070         _requireMinted(tokenId);
1071 
1072         return _tokenApprovals[tokenId];
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-setApprovalForAll}.
1077      */
1078     function setApprovalForAll(address operator, bool approved)
1079         public
1080         virtual
1081         override
1082     {
1083         _setApprovalForAll(_msgSender(), operator, approved);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-isApprovedForAll}.
1088      */
1089     function isApprovedForAll(address owner, address operator)
1090         public
1091         view
1092         virtual
1093         override
1094         returns (bool)
1095     {
1096         return _operatorApprovals[owner][operator];
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-transferFrom}.
1101      */
1102     function transferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         //solhint-disable-next-line max-line-length
1108         require(
1109             _isApprovedOrOwner(_msgSender(), tokenId),
1110             "ERC721: caller is not token owner nor approved"
1111         );
1112 
1113         _transfer(from, to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-safeTransferFrom}.
1118      */
1119     function safeTransferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) public virtual override {
1124         safeTransferFrom(from, to, tokenId, "");
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-safeTransferFrom}.
1129      */
1130     function safeTransferFrom(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory data
1135     ) public virtual override {
1136         require(
1137             _isApprovedOrOwner(_msgSender(), tokenId),
1138             "ERC721: caller is not token owner nor approved"
1139         );
1140         _safeTransfer(from, to, tokenId, data);
1141     }
1142 
1143     /**
1144      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1145      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1146      *
1147      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1148      *
1149      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1150      * implement alternative mechanisms to perform token transfer, such as signature-based.
1151      *
1152      * Requirements:
1153      *
1154      * - `from` cannot be the zero address.
1155      * - `to` cannot be the zero address.
1156      * - `tokenId` token must exist and be owned by `from`.
1157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1158      *
1159      * Emits a {Transfer} event.
1160      */
1161     function _safeTransfer(
1162         address from,
1163         address to,
1164         uint256 tokenId,
1165         bytes memory data
1166     ) internal virtual {
1167         _transfer(from, to, tokenId);
1168         require(
1169             _checkOnERC721Received(from, to, tokenId, data),
1170             "ERC721: transfer to non ERC721Receiver implementer"
1171         );
1172     }
1173 
1174     /**
1175      * @dev Returns whether `tokenId` exists.
1176      *
1177      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1178      *
1179      * Tokens start existing when they are minted (`_mint`),
1180      * and stop existing when they are burned (`_burn`).
1181      */
1182     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1183         return _owners[tokenId] != address(0);
1184     }
1185 
1186     /**
1187      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1188      *
1189      * Requirements:
1190      *
1191      * - `tokenId` must exist.
1192      */
1193     function _isApprovedOrOwner(address spender, uint256 tokenId)
1194         internal
1195         view
1196         virtual
1197         returns (bool)
1198     {
1199         address owner = ERC721.ownerOf(tokenId);
1200         return (spender == owner ||
1201             isApprovedForAll(owner, spender) ||
1202             getApproved(tokenId) == spender);
1203     }
1204 
1205     /**
1206      * @dev Safely mints `tokenId` and transfers it to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must not exist.
1211      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _safeMint(address to, uint256 tokenId) internal virtual {
1216         _safeMint(to, tokenId, "");
1217     }
1218 
1219     /**
1220      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1221      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1222      */
1223     function _safeMint(
1224         address to,
1225         uint256 tokenId,
1226         bytes memory data
1227     ) internal virtual {
1228         _mint(to, tokenId);
1229         require(
1230             _checkOnERC721Received(address(0), to, tokenId, data),
1231             "ERC721: transfer to non ERC721Receiver implementer"
1232         );
1233     }
1234 
1235     /**
1236      * @dev Mints `tokenId` and transfers it to `to`.
1237      *
1238      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must not exist.
1243      * - `to` cannot be the zero address.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _mint(address to, uint256 tokenId) internal virtual {
1248         require(to != address(0), "ERC721: mint to the zero address");
1249         require(!_exists(tokenId), "ERC721: token already minted");
1250 
1251         _beforeTokenTransfer(address(0), to, tokenId);
1252 
1253         _balances[to] += 1;
1254         _owners[tokenId] = to;
1255 
1256         emit Transfer(address(0), to, tokenId);
1257 
1258         _afterTokenTransfer(address(0), to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev Destroys `tokenId`.
1263      * The approval is cleared when the token is burned.
1264      *
1265      * Requirements:
1266      *
1267      * - `tokenId` must exist.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _burn(uint256 tokenId) internal virtual {
1272         address owner = ERC721.ownerOf(tokenId);
1273 
1274         _beforeTokenTransfer(owner, address(0), tokenId);
1275 
1276         // Clear approvals
1277         _approve(address(0), tokenId);
1278 
1279         _balances[owner] -= 1;
1280         delete _owners[tokenId];
1281 
1282         emit Transfer(owner, address(0), tokenId);
1283 
1284         _afterTokenTransfer(owner, address(0), tokenId);
1285     }
1286 
1287     /**
1288      * @dev Transfers `tokenId` from `from` to `to`.
1289      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1290      *
1291      * Requirements:
1292      *
1293      * - `to` cannot be the zero address.
1294      * - `tokenId` token must be owned by `from`.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function _transfer(
1299         address from,
1300         address to,
1301         uint256 tokenId
1302     ) internal virtual {
1303         require(
1304             ERC721.ownerOf(tokenId) == from,
1305             "ERC721: transfer from incorrect owner"
1306         );
1307         require(to != address(0), "ERC721: transfer to the zero address");
1308 
1309         _beforeTokenTransfer(from, to, tokenId);
1310 
1311         // Clear approvals from the previous owner
1312         _approve(address(0), tokenId);
1313 
1314         _balances[from] -= 1;
1315         _balances[to] += 1;
1316         _owners[tokenId] = to;
1317 
1318         emit Transfer(from, to, tokenId);
1319 
1320         _afterTokenTransfer(from, to, tokenId);
1321     }
1322 
1323     /**
1324      * @dev Approve `to` to operate on `tokenId`
1325      *
1326      * Emits an {Approval} event.
1327      */
1328     function _approve(address to, uint256 tokenId) internal virtual {
1329         _tokenApprovals[tokenId] = to;
1330         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1331     }
1332 
1333     /**
1334      * @dev Approve `operator` to operate on all of `owner` tokens
1335      *
1336      * Emits an {ApprovalForAll} event.
1337      */
1338     function _setApprovalForAll(
1339         address owner,
1340         address operator,
1341         bool approved
1342     ) internal virtual {
1343         require(owner != operator, "ERC721: approve to caller");
1344         _operatorApprovals[owner][operator] = approved;
1345         emit ApprovalForAll(owner, operator, approved);
1346     }
1347 
1348     /**
1349      * @dev Reverts if the `tokenId` has not been minted yet.
1350      */
1351     function _requireMinted(uint256 tokenId) internal view virtual {
1352         require(_exists(tokenId), "ERC721: invalid token ID");
1353     }
1354 
1355     /**
1356      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1357      * The call is not executed if the target address is not a contract.
1358      *
1359      * @param from address representing the previous owner of the given token ID
1360      * @param to target address that will receive the tokens
1361      * @param tokenId uint256 ID of the token to be transferred
1362      * @param data bytes optional data to send along with the call
1363      * @return bool whether the call correctly returned the expected magic value
1364      */
1365     function _checkOnERC721Received(
1366         address from,
1367         address to,
1368         uint256 tokenId,
1369         bytes memory data
1370     ) private returns (bool) {
1371         if (to.isContract()) {
1372             try
1373                 IERC721Receiver(to).onERC721Received(
1374                     _msgSender(),
1375                     from,
1376                     tokenId,
1377                     data
1378                 )
1379             returns (bytes4 retval) {
1380                 return retval == IERC721Receiver.onERC721Received.selector;
1381             } catch (bytes memory reason) {
1382                 if (reason.length == 0) {
1383                     revert(
1384                         "ERC721: transfer to non ERC721Receiver implementer"
1385                     );
1386                 } else {
1387                     /// @solidity memory-safe-assembly
1388                     assembly {
1389                         revert(add(32, reason), mload(reason))
1390                     }
1391                 }
1392             }
1393         } else {
1394             return true;
1395         }
1396     }
1397 
1398     /**
1399      * @dev Hook that is called before any token transfer. This includes minting
1400      * and burning.
1401      *
1402      * Calling conditions:
1403      *
1404      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1405      * transferred to `to`.
1406      * - When `from` is zero, `tokenId` will be minted for `to`.
1407      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1408      * - `from` and `to` are never both zero.
1409      *
1410      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1411      */
1412     function _beforeTokenTransfer(
1413         address from,
1414         address to,
1415         uint256 tokenId
1416     ) internal virtual {}
1417 
1418     /**
1419      * @dev Hook that is called after any transfer of tokens. This includes
1420      * minting and burning.
1421      *
1422      * Calling conditions:
1423      *
1424      * - when `from` and `to` are both non-zero.
1425      * - `from` and `to` are never both zero.
1426      *
1427      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1428      */
1429     function _afterTokenTransfer(
1430         address from,
1431         address to,
1432         uint256 tokenId
1433     ) internal virtual {}
1434 }
1435 
1436 /// @notice Gas optimized reentrancy protection for smart contracts.
1437 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/ReentrancyGuard.sol)
1438 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
1439 abstract contract ReentrancyGuard {
1440     uint256 private locked = 1;
1441 
1442     modifier nonReentrant() virtual {
1443         require(locked == 1, "REENTRANCY");
1444 
1445         locked = 2;
1446 
1447         _;
1448 
1449         locked = 1;
1450     }
1451 }
1452 
1453 /**
1454  * @dev Interface for the NFT Royalty Standard.
1455  *
1456  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1457  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1458  *
1459  * _Available since v4.5._
1460  */
1461 interface IERC2981 is IERC165 {
1462     /**
1463      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1464      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1465      */
1466     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1467         external
1468         view
1469         returns (address receiver, uint256 royaltyAmount);
1470 }
1471 
1472 /// @dev This is a contract used to add ERC2981 support to ERC721A
1473 abstract contract ERC2981 is IERC2981 {
1474     uint256 public constant MULTIPLIER = 10000;
1475     uint256 public value;
1476 
1477     error RoyaltyValueOutOfRange();
1478 
1479     /// @dev Sets token royalties
1480     /// @param _value percentage (using 2 decimals - 10000 = 100, 0 = 0)
1481     function _setTokenRoyalty(uint256 _value) internal {
1482         if (_value > MULTIPLIER) revert RoyaltyValueOutOfRange();
1483         value = _value;
1484     }
1485 }
1486 
1487 error ExceedsMaxSupply();
1488 error MintNotStarted();
1489 error MintEnded();
1490 error MintInProgress();
1491 error InvalidData();
1492 error ERC721ReceiverNotImplemented();
1493 
1494 interface IPriveSociete {
1495     function balanceOf(address owner) external view returns (uint256 balance);
1496 
1497     function safeTransferFrom(
1498         address from,
1499         address to,
1500         uint256 tokenId,
1501         bytes memory _data
1502     ) external;
1503 
1504     function ownerOf(uint256 tokenId) external view returns (address);
1505 }
1506 
1507 contract PriveSocieteGenesis is ERC721, Ownable, ERC2981, ReentrancyGuard {
1508     using Strings for uint256;
1509 
1510     uint256 private constant MAX_SUPPLY = 4999;
1511     uint256 private constant INITIAL_SUPPLY = 5;
1512     uint256 private constant PRIVE_GENESIS_PASS_SUPPLY = 253;
1513     uint256 private constant ROYALTY = 500;
1514     uint256 private constant MINT_FEES = 10**17;
1515 
1516     bytes32 public immutable oneSpotWhitelistMerkleRoot;
1517     bytes32 public immutable twoSpotWhitelistMerkleRoot;
1518     bytes32 public immutable waitlistMerkleRoot;
1519 
1520     address private constant DEAD_ADDRESS =
1521         address(0x000000000000000000000000000000000000dEaD);
1522     address payable private constant TREASURY =
1523         payable(address(0xE15CFdC7DAaEF0D2d2A3bE7239973E11556d9e8C));
1524 
1525     IPriveSociete public priveGenesisPass;
1526     mapping(address => uint256) public whitelistSpots;
1527     mapping(address => uint256) public minted;
1528 
1529     uint256 private _tokenIds = 1;
1530     uint256 private totalSupply;
1531     uint256 private genesisPassSwapped;
1532 
1533     uint256 public firstDayEnd;
1534     uint256 public secondDayEnd;
1535     string public baseURI;
1536     bool public isRevealed;
1537 
1538     event Whitelisted(address[] indexed users, uint256[] indexed spots);
1539     event Waitlisted(address[] indexed users);
1540 
1541     error WrongTokenId();
1542     error NotAllowed();
1543     error AlreadyRevealed();
1544     error InvalidETHAmount();
1545     error NoTokenIdPassed();
1546 
1547     constructor(string memory _initBaseURI, address _priveGenesisPass)
1548         ERC721("Prive Genesis", "PG")
1549     {
1550         baseURI = _initBaseURI;
1551         value = ROYALTY;
1552         priveGenesisPass = IPriveSociete(_priveGenesisPass);
1553 
1554         // solhint-disable-next-line
1555         firstDayEnd = time() + 1 days;
1556         secondDayEnd = firstDayEnd + 1 days;
1557 
1558         oneSpotWhitelistMerkleRoot = 0x2de0703c7796cf1874e5e83feea12018cda1e737b3b770d26662d3bc7e238213;
1559         twoSpotWhitelistMerkleRoot = 0xe15196134ea93dec7fd34dc4c971212a1312140095c873b422729ffd4ee7a69d;
1560         waitlistMerkleRoot = 0x49f14276394a8c5f4cdf69bcdb750b64df91589527676afc34352635c6592d97;
1561 
1562         _batchMint(msg.sender, INITIAL_SUPPLY);
1563     }
1564 
1565     function setRevealed() external onlyOwner {
1566         isRevealed = true;
1567     }
1568 
1569     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1570         if (isRevealed) revert AlreadyRevealed();
1571         baseURI = _newBaseURI;
1572     }
1573 
1574     function time() internal view returns (uint256) {
1575         // solhint-disable-next-line not-rely-on-time
1576         return block.timestamp;
1577     }
1578 
1579     function mintRemaining(uint256 amount) external onlyOwner {
1580         _batchMint(msg.sender, amount);
1581     }
1582 
1583     function _burnGenesisPass(address holder, uint256[] calldata tokenIds)
1584         internal
1585     {
1586         for (uint256 index = 0; index < tokenIds.length; index++) {
1587             if (holder != priveGenesisPass.ownerOf(tokenIds[index]))
1588                 revert WrongTokenId();
1589 
1590             priveGenesisPass.safeTransferFrom(
1591                 holder,
1592                 DEAD_ADDRESS,
1593                 tokenIds[index],
1594                 ""
1595             );
1596         }
1597 
1598         genesisPassSwapped += tokenIds.length;
1599     }
1600 
1601     function _getGenesisPassBalance(address holder)
1602         internal
1603         view
1604         returns (uint256)
1605     {
1606         return priveGenesisPass.balanceOf(holder);
1607     }
1608 
1609     function canMint(
1610         address to_,
1611         uint256 amount_,
1612         bytes32[] calldata merkleProof
1613     )
1614         public
1615         view
1616         returns (
1617             bool isEligible,
1618             uint256 passes,
1619             uint256 payFor
1620         )
1621     {
1622         passes = _getGenesisPassBalance(to_);
1623 
1624         if (passes >= amount_) {
1625             passes = amount_;
1626             payFor = 0;
1627             isEligible = true;
1628         } else if (time() <= firstDayEnd) {
1629             payFor = amount_ - passes;
1630             isEligible = isWhitelisted(to_, payFor, merkleProof);
1631         } else if (time() > firstDayEnd && time() <= secondDayEnd) {
1632             // All the allowed addresses can mint unlimited NFTs
1633             isEligible = isAllowlisted(to_, merkleProof);
1634             payFor = amount_ - passes;
1635         } else {
1636             isEligible = true;
1637             payFor = amount_ - passes;
1638         }
1639     }
1640 
1641     function whitelist(address[] calldata users, uint256[] calldata spots)
1642         external
1643         onlyOwner
1644     {
1645         if (users.length != spots.length) revert InvalidData();
1646         for (uint256 index = 0; index < users.length; ) {
1647             whitelistSpots[users[index]] = spots[index];
1648             unchecked {
1649                 ++index;
1650             }
1651         }
1652         emit Whitelisted(users, spots);
1653     }
1654 
1655     function isWhitelisted(
1656         address user_,
1657         uint256 amount_,
1658         bytes32[] calldata merkleProof
1659     ) internal view returns (bool) {
1660         if (amount_ == 0) return true;
1661 
1662         if (whitelistSpots[user_] > 2) {
1663             if (whitelistSpots[user_] - minted[user_] >= amount_) return true;
1664             return false;
1665         }
1666 
1667         uint256 mints = minted[user_];
1668         if (mints >= 2) return false;
1669 
1670         if (
1671             mints == 0 &&
1672             amount_ == 1 &&
1673             MerkleProof.verify(
1674                 merkleProof,
1675                 oneSpotWhitelistMerkleRoot,
1676                 toBytes32(user_)
1677             )
1678         ) {
1679             return true;
1680         }
1681 
1682         if (
1683             amount_ <= 2 &&
1684             mints < 2 &&
1685             MerkleProof.verify(
1686                 merkleProof,
1687                 twoSpotWhitelistMerkleRoot,
1688                 toBytes32(user_)
1689             )
1690         ) {
1691             if (2 - mints >= amount_) return true;
1692         }
1693 
1694         return false;
1695     }
1696 
1697     function isAllowlisted(address user, bytes32[] calldata merkleProof)
1698         internal
1699         view
1700         returns (bool)
1701     {
1702         return
1703             MerkleProof.verify(
1704                 merkleProof,
1705                 waitlistMerkleRoot,
1706                 toBytes32(user)
1707             );
1708     }
1709 
1710     function toBytes32(address addr) internal pure returns (bytes32) {
1711         return keccak256(abi.encodePacked(addr));
1712     }
1713 
1714     function mint(
1715         uint256 amount_,
1716         uint256[] calldata tokenIds_,
1717         bytes32[] calldata merkleProof_
1718     ) external payable nonReentrant {
1719         (bool isEligible, uint256 passes, uint256 payFor) = canMint(
1720             msg.sender,
1721             amount_,
1722             merkleProof_
1723         );
1724         uint256 fees = payFor * MINT_FEES;
1725 
1726         if (!isEligible) revert NotAllowed();
1727         if (tokenIds_.length != passes) revert NoTokenIdPassed();
1728         if (msg.value != fees) revert InvalidETHAmount();
1729 
1730         if (time() <= firstDayEnd && payFor > 0) {
1731             minted[msg.sender] = payFor;
1732         }
1733 
1734         _batchMint(msg.sender, amount_);
1735 
1736         if (tokenIds_.length != 0) {
1737             _burnGenesisPass(msg.sender, tokenIds_);
1738         }
1739         _transferETH(fees);
1740     }
1741 
1742     function _batchMint(address to, uint256 amount) internal {
1743         uint256 iterations = _tokenIds + amount;
1744         for (uint256 index = _tokenIds; index < iterations; ) {
1745             _safeMint(to, index);
1746             unchecked {
1747                 ++index;
1748             }
1749         }
1750 
1751         _tokenIds += amount;
1752         totalSupply += amount;
1753 
1754         if (
1755             totalSupply >
1756             (MAX_SUPPLY - PRIVE_GENESIS_PASS_SUPPLY - genesisPassSwapped)
1757         ) revert ExceedsMaxSupply();
1758     }
1759 
1760     function _transferETH(uint256 amount) internal {
1761         // solhint-disable-next-line avoid-low-level-calls
1762         (bool success, ) = TREASURY.call{value: amount}("");
1763         require(success, "Failed to send Ether");
1764     }
1765 
1766     function _baseURI() internal view override returns (string memory) {
1767         return baseURI;
1768     }
1769 
1770     function tokenURI(uint256 tokenId)
1771         public
1772         view
1773         virtual
1774         override
1775         returns (string memory)
1776     {
1777         _requireMinted(tokenId);
1778 
1779         // solhint-disable-next-line
1780         string memory baseURI__ = _baseURI();
1781         return
1782             bytes(baseURI__).length > 0
1783                 ? string(
1784                     abi.encodePacked(baseURI__, tokenId.toString(), ".json")
1785                 )
1786                 : "";
1787     }
1788 
1789     /// @inheritdoc IERC2981
1790     function royaltyInfo(uint256, uint256 _value)
1791         external
1792         view
1793         override
1794         returns (address receiver, uint256 royaltyAmount)
1795     {
1796         return (owner(), (_value * value) / MULTIPLIER);
1797     }
1798 
1799     function setTokenRoyalty(uint256 _value) external onlyOwner {
1800         _setTokenRoyalty(_value);
1801     }
1802 
1803     /**
1804      * @dev See {IERC165-supportsInterface}.
1805      */
1806     function supportsInterface(bytes4 interfaceId)
1807         public
1808         view
1809         virtual
1810         override(IERC165, ERC721)
1811         returns (bool)
1812     {
1813         // The interface IDs are constants representing the first 4 bytes of the XOR of
1814         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1815         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1816         return
1817             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1818             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1819             interfaceId == 0x5b5e139f || // ERC165 interface ID for ERC721Metadata.
1820             interfaceId == type(IERC2981).interfaceId; // ERC165 interface ID for ERC2981
1821     }
1822 }