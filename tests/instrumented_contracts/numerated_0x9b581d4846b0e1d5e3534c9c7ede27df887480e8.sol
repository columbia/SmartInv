1 pragma solidity 0.8.4;
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
5 /**
6  * @dev These functions deal with verification of Merkle Tree proofs.
7  *
8  * The tree and the proofs can be generated using our
9  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
10  * You will find a quickstart guide in the readme.
11  *
12  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
13  * hashing, or use a hash function other than keccak256 for hashing leaves.
14  * This is because the concatenation of a sorted pair of internal nodes in
15  * the merkle tree could be reinterpreted as a leaf value.
16  * OpenZeppelin's JavaScript library generates merkle trees that are safe
17  * against this attack out of the box.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33 
34     /**
35      * @dev Calldata version of {verify}
36      *
37      * _Available since v4.7._
38      */
39     function verifyCalldata(
40         bytes32[] calldata proof,
41         bytes32 root,
42         bytes32 leaf
43     ) internal pure returns (bool) {
44         return processProofCalldata(proof, leaf) == root;
45     }
46 
47     /**
48      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
49      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
50      * hash matches the root of the tree. When processing the proof, the pairs
51      * of leafs & pre-images are assumed to be sorted.
52      *
53      * _Available since v4.4._
54      */
55     function processProof(bytes32[] memory proof, bytes32 leaf)
56         internal
57         pure
58         returns (bytes32)
59     {
60         bytes32 computedHash = leaf;
61         for (uint256 i = 0; i < proof.length; i++) {
62             computedHash = _hashPair(computedHash, proof[i]);
63         }
64         return computedHash;
65     }
66 
67     /**
68      * @dev Calldata version of {processProof}
69      *
70      * _Available since v4.7._
71      */
72     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
73         internal
74         pure
75         returns (bytes32)
76     {
77         bytes32 computedHash = leaf;
78         for (uint256 i = 0; i < proof.length; i++) {
79             computedHash = _hashPair(computedHash, proof[i]);
80         }
81         return computedHash;
82     }
83 
84     /**
85      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
86      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
87      *
88      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
89      *
90      * _Available since v4.7._
91      */
92     function multiProofVerify(
93         bytes32[] memory proof,
94         bool[] memory proofFlags,
95         bytes32 root,
96         bytes32[] memory leaves
97     ) internal pure returns (bool) {
98         return processMultiProof(proof, proofFlags, leaves) == root;
99     }
100 
101     /**
102      * @dev Calldata version of {multiProofVerify}
103      *
104      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
105      *
106      * _Available since v4.7._
107      */
108     function multiProofVerifyCalldata(
109         bytes32[] calldata proof,
110         bool[] calldata proofFlags,
111         bytes32 root,
112         bytes32[] memory leaves
113     ) internal pure returns (bool) {
114         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
115     }
116 
117     /**
118      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
119      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
120      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
121      * respectively.
122      *
123      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
124      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
125      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
126      *
127      * _Available since v4.7._
128      */
129     function processMultiProof(
130         bytes32[] memory proof,
131         bool[] memory proofFlags,
132         bytes32[] memory leaves
133     ) internal pure returns (bytes32 merkleRoot) {
134         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
135         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
136         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
137         // the merkle tree.
138         uint256 leavesLen = leaves.length;
139         uint256 totalHashes = proofFlags.length;
140 
141         // Check proof validity.
142         require(
143             leavesLen + proof.length - 1 == totalHashes,
144             "MerkleProof: invalid multiproof"
145         );
146 
147         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
148         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
149         bytes32[] memory hashes = new bytes32[](totalHashes);
150         uint256 leafPos = 0;
151         uint256 hashPos = 0;
152         uint256 proofPos = 0;
153         // At each step, we compute the next hash using two values:
154         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
155         //   get the next hash.
156         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
157         //   `proof` array.
158         for (uint256 i = 0; i < totalHashes; i++) {
159             bytes32 a = leafPos < leavesLen
160                 ? leaves[leafPos++]
161                 : hashes[hashPos++];
162             bytes32 b = proofFlags[i]
163                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
164                 : proof[proofPos++];
165             hashes[i] = _hashPair(a, b);
166         }
167 
168         if (totalHashes > 0) {
169             return hashes[totalHashes - 1];
170         } else if (leavesLen > 0) {
171             return leaves[0];
172         } else {
173             return proof[0];
174         }
175     }
176 
177     /**
178      * @dev Calldata version of {processMultiProof}.
179      *
180      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
181      *
182      * _Available since v4.7._
183      */
184     function processMultiProofCalldata(
185         bytes32[] calldata proof,
186         bool[] calldata proofFlags,
187         bytes32[] memory leaves
188     ) internal pure returns (bytes32 merkleRoot) {
189         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
190         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
191         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
192         // the merkle tree.
193         uint256 leavesLen = leaves.length;
194         uint256 totalHashes = proofFlags.length;
195 
196         // Check proof validity.
197         require(
198             leavesLen + proof.length - 1 == totalHashes,
199             "MerkleProof: invalid multiproof"
200         );
201 
202         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
203         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
204         bytes32[] memory hashes = new bytes32[](totalHashes);
205         uint256 leafPos = 0;
206         uint256 hashPos = 0;
207         uint256 proofPos = 0;
208         // At each step, we compute the next hash using two values:
209         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
210         //   get the next hash.
211         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
212         //   `proof` array.
213         for (uint256 i = 0; i < totalHashes; i++) {
214             bytes32 a = leafPos < leavesLen
215                 ? leaves[leafPos++]
216                 : hashes[hashPos++];
217             bytes32 b = proofFlags[i]
218                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
219                 : proof[proofPos++];
220             hashes[i] = _hashPair(a, b);
221         }
222 
223         if (totalHashes > 0) {
224             return hashes[totalHashes - 1];
225         } else if (leavesLen > 0) {
226             return leaves[0];
227         } else {
228             return proof[0];
229         }
230     }
231 
232     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
233         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
234     }
235 
236     function _efficientHash(bytes32 a, bytes32 b)
237         private
238         pure
239         returns (bytes32 value)
240     {
241         /// @solidity memory-safe-assembly
242         assembly {
243             mstore(0x00, a)
244             mstore(0x20, b)
245             value := keccak256(0x00, 0x40)
246         }
247     }
248 }
249 
250 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
251 /**
252  * @dev Contract module that helps prevent reentrant calls to a function.
253  *
254  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
255  * available, which can be applied to functions to make sure there are no nested
256  * (reentrant) calls to them.
257  *
258  * Note that because there is a single `nonReentrant` guard, functions marked as
259  * `nonReentrant` may not call one another. This can be worked around by making
260  * those functions `private`, and then adding `external` `nonReentrant` entry
261  * points to them.
262  *
263  * TIP: If you would like to learn more about reentrancy and alternative ways
264  * to protect against it, check out our blog post
265  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
266  */
267 abstract contract ReentrancyGuard {
268     // Booleans are more expensive than uint256 or any type that takes up a full
269     // word because each write operation emits an extra SLOAD to first read the
270     // slot's contents, replace the bits taken up by the boolean, and then write
271     // back. This is the compiler's defense against contract upgrades and
272     // pointer aliasing, and it cannot be disabled.
273 
274     // The values being non-zero value makes deployment a bit more expensive,
275     // but in exchange the refund on every call to nonReentrant will be lower in
276     // amount. Since refunds are capped to a percentage of the total
277     // transaction's gas, it is best to keep them low in cases like this one, to
278     // increase the likelihood of the full refund coming into effect.
279     uint256 private constant _NOT_ENTERED = 1;
280     uint256 private constant _ENTERED = 2;
281 
282     uint256 private _status;
283 
284     constructor() {
285         _status = _NOT_ENTERED;
286     }
287 
288     /**
289      * @dev Prevents a contract from calling itself, directly or indirectly.
290      * Calling a `nonReentrant` function from another `nonReentrant`
291      * function is not supported. It is possible to prevent this from happening
292      * by making the `nonReentrant` function external, and making it call a
293      * `private` function that does the actual work.
294      */
295     modifier nonReentrant() {
296         _nonReentrantBefore();
297         _;
298         _nonReentrantAfter();
299     }
300 
301     function _nonReentrantBefore() private {
302         // On the first call to nonReentrant, _status will be _NOT_ENTERED
303         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
304 
305         // Any calls to nonReentrant after this point will fail
306         _status = _ENTERED;
307     }
308 
309     function _nonReentrantAfter() private {
310         // By storing the original value once again, a refund is triggered (see
311         // https://eips.ethereum.org/EIPS/eip-2200)
312         _status = _NOT_ENTERED;
313     }
314 }
315 
316 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
317 /**
318  * @dev Provides information about the current execution context, including the
319  * sender of the transaction and its data. While these are generally available
320  * via msg.sender and msg.data, they should not be accessed in such a direct
321  * manner, since when dealing with meta-transactions the account sending and
322  * paying for execution may not be the actual sender (as far as an application
323  * is concerned).
324  *
325  * This contract is only required for intermediate, library-like contracts.
326  */
327 abstract contract Context {
328     function _msgSender() internal view virtual returns (address) {
329         return msg.sender;
330     }
331 
332     function _msgData() internal view virtual returns (bytes calldata) {
333         return msg.data;
334     }
335 }
336 
337 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
338 /**
339  * @dev Contract module which provides a basic access control mechanism, where
340  * there is an account (an owner) that can be granted exclusive access to
341  * specific functions.
342  *
343  * By default, the owner account will be the one that deploys the contract. This
344  * can later be changed with {transferOwnership}.
345  *
346  * This module is used through inheritance. It will make available the modifier
347  * `onlyOwner`, which can be applied to your functions to restrict their use to
348  * the owner.
349  */
350 abstract contract Ownable is Context {
351     address private _owner;
352 
353     event OwnershipTransferred(
354         address indexed previousOwner,
355         address indexed newOwner
356     );
357 
358     /**
359      * @dev Initializes the contract setting the deployer as the initial owner.
360      */
361     constructor() {
362         _transferOwnership(_msgSender());
363     }
364 
365     /**
366      * @dev Throws if called by any account other than the owner.
367      */
368     modifier onlyOwner() {
369         _checkOwner();
370         _;
371     }
372 
373     /**
374      * @dev Returns the address of the current owner.
375      */
376     function owner() public view virtual returns (address) {
377         return _owner;
378     }
379 
380     /**
381      * @dev Throws if the sender is not the owner.
382      */
383     function _checkOwner() internal view virtual {
384         require(owner() == _msgSender(), "Ownable: caller is not the owner");
385     }
386 
387     /**
388      * @dev Leaves the contract without owner. It will not be possible to call
389      * `onlyOwner` functions anymore. Can only be called by the current owner.
390      *
391      * NOTE: Renouncing ownership will leave the contract without an owner,
392      * thereby removing any functionality that is only available to the owner.
393      */
394     function renounceOwnership() public virtual onlyOwner {
395         _transferOwnership(address(0));
396     }
397 
398     /**
399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
400      * Can only be called by the current owner.
401      */
402     function transferOwnership(address newOwner) public virtual onlyOwner {
403         require(
404             newOwner != address(0),
405             "Ownable: new owner is the zero address"
406         );
407         _transferOwnership(newOwner);
408     }
409 
410     /**
411      * @dev Transfers ownership of the contract to a new account (`newOwner`).
412      * Internal function without access restriction.
413      */
414     function _transferOwnership(address newOwner) internal virtual {
415         address oldOwner = _owner;
416         _owner = newOwner;
417         emit OwnershipTransferred(oldOwner, newOwner);
418     }
419 }
420 
421 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
422 /**
423  * @dev Collection of functions related to the address type
424  */
425 library Address {
426     /**
427      * @dev Returns true if `account` is a contract.
428      *
429      * [IMPORTANT]
430      * ====
431      * It is unsafe to assume that an address for which this function returns
432      * false is an externally-owned account (EOA) and not a contract.
433      *
434      * Among others, `isContract` will return false for the following
435      * types of addresses:
436      *
437      *  - an externally-owned account
438      *  - a contract in construction
439      *  - an address where a contract will be created
440      *  - an address where a contract lived, but was destroyed
441      * ====
442      *
443      * [IMPORTANT]
444      * ====
445      * You shouldn't rely on `isContract` to protect against flash loan attacks!
446      *
447      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
448      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
449      * constructor.
450      * ====
451      */
452     function isContract(address account) internal view returns (bool) {
453         // This method relies on extcodesize/address.code.length, which returns 0
454         // for contracts in construction, since the code is only stored at the end
455         // of the constructor execution.
456 
457         return account.code.length > 0;
458     }
459 
460     /**
461      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
462      * `recipient`, forwarding all available gas and reverting on errors.
463      *
464      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
465      * of certain opcodes, possibly making contracts go over the 2300 gas limit
466      * imposed by `transfer`, making them unable to receive funds via
467      * `transfer`. {sendValue} removes this limitation.
468      *
469      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
470      *
471      * IMPORTANT: because control is transferred to `recipient`, care must be
472      * taken to not create reentrancy vulnerabilities. Consider using
473      * {ReentrancyGuard} or the
474      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
475      */
476     function sendValue(address payable recipient, uint256 amount) internal {
477         require(
478             address(this).balance >= amount,
479             "Address: insufficient balance"
480         );
481 
482         (bool success, ) = recipient.call{value: amount}("");
483         require(
484             success,
485             "Address: unable to send value, recipient may have reverted"
486         );
487     }
488 
489     /**
490      * @dev Performs a Solidity function call using a low level `call`. A
491      * plain `call` is an unsafe replacement for a function call: use this
492      * function instead.
493      *
494      * If `target` reverts with a revert reason, it is bubbled up by this
495      * function (like regular Solidity function calls).
496      *
497      * Returns the raw returned data. To convert to the expected return value,
498      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
499      *
500      * Requirements:
501      *
502      * - `target` must be a contract.
503      * - calling `target` with `data` must not revert.
504      *
505      * _Available since v3.1._
506      */
507     function functionCall(address target, bytes memory data)
508         internal
509         returns (bytes memory)
510     {
511         return
512             functionCallWithValue(
513                 target,
514                 data,
515                 0,
516                 "Address: low-level call failed"
517             );
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
522      * `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, 0, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but also transferring `value` wei to `target`.
537      *
538      * Requirements:
539      *
540      * - the calling contract must have an ETH balance of at least `value`.
541      * - the called Solidity function must be `payable`.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(
546         address target,
547         bytes memory data,
548         uint256 value
549     ) internal returns (bytes memory) {
550         return
551             functionCallWithValue(
552                 target,
553                 data,
554                 value,
555                 "Address: low-level call with value failed"
556             );
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
561      * with `errorMessage` as a fallback revert reason when `target` reverts.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value,
569         string memory errorMessage
570     ) internal returns (bytes memory) {
571         require(
572             address(this).balance >= value,
573             "Address: insufficient balance for call"
574         );
575         (bool success, bytes memory returndata) = target.call{value: value}(
576             data
577         );
578         return
579             verifyCallResultFromTarget(
580                 target,
581                 success,
582                 returndata,
583                 errorMessage
584             );
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but performing a static call.
590      *
591      * _Available since v3.3._
592      */
593     function functionStaticCall(address target, bytes memory data)
594         internal
595         view
596         returns (bytes memory)
597     {
598         return
599             functionStaticCall(
600                 target,
601                 data,
602                 "Address: low-level static call failed"
603             );
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
608      * but performing a static call.
609      *
610      * _Available since v3.3._
611      */
612     function functionStaticCall(
613         address target,
614         bytes memory data,
615         string memory errorMessage
616     ) internal view returns (bytes memory) {
617         (bool success, bytes memory returndata) = target.staticcall(data);
618         return
619             verifyCallResultFromTarget(
620                 target,
621                 success,
622                 returndata,
623                 errorMessage
624             );
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
629      * but performing a delegate call.
630      *
631      * _Available since v3.4._
632      */
633     function functionDelegateCall(address target, bytes memory data)
634         internal
635         returns (bytes memory)
636     {
637         return
638             functionDelegateCall(
639                 target,
640                 data,
641                 "Address: low-level delegate call failed"
642             );
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
647      * but performing a delegate call.
648      *
649      * _Available since v3.4._
650      */
651     function functionDelegateCall(
652         address target,
653         bytes memory data,
654         string memory errorMessage
655     ) internal returns (bytes memory) {
656         (bool success, bytes memory returndata) = target.delegatecall(data);
657         return
658             verifyCallResultFromTarget(
659                 target,
660                 success,
661                 returndata,
662                 errorMessage
663             );
664     }
665 
666     /**
667      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
668      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
669      *
670      * _Available since v4.8._
671      */
672     function verifyCallResultFromTarget(
673         address target,
674         bool success,
675         bytes memory returndata,
676         string memory errorMessage
677     ) internal view returns (bytes memory) {
678         if (success) {
679             if (returndata.length == 0) {
680                 // only check isContract if the call was successful and the return data is empty
681                 // otherwise we already know that it was a contract
682                 require(isContract(target), "Address: call to non-contract");
683             }
684             return returndata;
685         } else {
686             _revert(returndata, errorMessage);
687         }
688     }
689 
690     /**
691      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
692      * revert reason or using the provided one.
693      *
694      * _Available since v4.3._
695      */
696     function verifyCallResult(
697         bool success,
698         bytes memory returndata,
699         string memory errorMessage
700     ) internal pure returns (bytes memory) {
701         if (success) {
702             return returndata;
703         } else {
704             _revert(returndata, errorMessage);
705         }
706     }
707 
708     function _revert(bytes memory returndata, string memory errorMessage)
709         private
710         pure
711     {
712         // Look for revert reason and bubble it up if present
713         if (returndata.length > 0) {
714             // The easiest way to bubble the revert reason is using memory via assembly
715             /// @solidity memory-safe-assembly
716             assembly {
717                 let returndata_size := mload(returndata)
718                 revert(add(32, returndata), returndata_size)
719             }
720         } else {
721             revert(errorMessage);
722         }
723     }
724 }
725 
726 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
727 /**
728  * @dev Interface of the ERC20 standard as defined in the EIP.
729  */
730 interface IERC20 {
731     /**
732      * @dev Emitted when `value` tokens are moved from one account (`from`) to
733      * another (`to`).
734      *
735      * Note that `value` may be zero.
736      */
737     event Transfer(address indexed from, address indexed to, uint256 value);
738 
739     /**
740      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
741      * a call to {approve}. `value` is the new allowance.
742      */
743     event Approval(
744         address indexed owner,
745         address indexed spender,
746         uint256 value
747     );
748 
749     /**
750      * @dev Returns the amount of tokens in existence.
751      */
752     function totalSupply() external view returns (uint256);
753 
754     /**
755      * @dev Returns the amount of tokens owned by `account`.
756      */
757     function balanceOf(address account) external view returns (uint256);
758 
759     /**
760      * @dev Moves `amount` tokens from the caller's account to `to`.
761      *
762      * Returns a boolean value indicating whether the operation succeeded.
763      *
764      * Emits a {Transfer} event.
765      */
766     function transfer(address to, uint256 amount) external returns (bool);
767 
768     /**
769      * @dev Returns the remaining number of tokens that `spender` will be
770      * allowed to spend on behalf of `owner` through {transferFrom}. This is
771      * zero by default.
772      *
773      * This value changes when {approve} or {transferFrom} are called.
774      */
775     function allowance(address owner, address spender)
776         external
777         view
778         returns (uint256);
779 
780     /**
781      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
782      *
783      * Returns a boolean value indicating whether the operation succeeded.
784      *
785      * IMPORTANT: Beware that changing an allowance with this method brings the risk
786      * that someone may use both the old and the new allowance by unfortunate
787      * transaction ordering. One possible solution to mitigate this race
788      * condition is to first reduce the spender's allowance to 0 and set the
789      * desired value afterwards:
790      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
791      *
792      * Emits an {Approval} event.
793      */
794     function approve(address spender, uint256 amount) external returns (bool);
795 
796     /**
797      * @dev Moves `amount` tokens from `from` to `to` using the
798      * allowance mechanism. `amount` is then deducted from the caller's
799      * allowance.
800      *
801      * Returns a boolean value indicating whether the operation succeeded.
802      *
803      * Emits a {Transfer} event.
804      */
805     function transferFrom(
806         address from,
807         address to,
808         uint256 amount
809     ) external returns (bool);
810 }
811 
812 interface IOperatorAccessControl {
813     event RoleGranted(
814         bytes32 indexed role,
815         address indexed account,
816         address indexed sender
817     );
818 
819     event RoleRevoked(
820         bytes32 indexed role,
821         address indexed account,
822         address indexed sender
823     );
824 
825     function hasRole(bytes32 role, address account)
826         external
827         view
828         returns (bool);
829 
830     function isOperator(address account) external view returns (bool);
831 
832     function addOperator(address account) external;
833 
834     function revokeOperator(address account) external;
835 }
836 
837 contract OperatorAccessControl is IOperatorAccessControl, Ownable {
838     struct RoleData {
839         mapping(address => bool) members;
840         bytes32 adminRole;
841     }
842 
843     mapping(bytes32 => RoleData) private _roles;
844 
845     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
846 
847     function hasRole(bytes32 role, address account)
848         public
849         view
850         override
851         returns (bool)
852     {
853         return _roles[role].members[account];
854     }
855 
856     function _grantRole(bytes32 role, address account) private {
857         if (!hasRole(role, account)) {
858             _roles[role].members[account] = true;
859             emit RoleGranted(role, account, _msgSender());
860         }
861     }
862 
863     function _setupRole(bytes32 role, address account) internal virtual {
864         _grantRole(role, account);
865     }
866 
867     function _revokeRole(bytes32 role, address account) private {
868         if (hasRole(role, account)) {
869             _roles[role].members[account] = false;
870             emit RoleRevoked(role, account, _msgSender());
871         }
872     }
873 
874     modifier isOperatorOrOwner() {
875         address _sender = _msgSender();
876         require(
877             isOperator(_sender) || owner() == _sender,
878             "OperatorAccessControl: caller is not operator or owner"
879         );
880         _;
881     }
882 
883     modifier onlyOperator() {
884         require(
885             isOperator(_msgSender()),
886             "OperatorAccessControl: caller is not operator"
887         );
888         _;
889     }
890 
891     function isOperator(address account) public view override returns (bool) {
892         return hasRole(OPERATOR_ROLE, account);
893     }
894 
895     function _addOperator(address account) internal virtual {
896         _grantRole(OPERATOR_ROLE, account);
897     }
898 
899     function addOperator(address account) public override onlyOperator {
900         _grantRole(OPERATOR_ROLE, account);
901     }
902 
903     function revokeOperator(address account) public override onlyOperator {
904         _revokeRole(OPERATOR_ROLE, account);
905     }
906 }
907 
908 library Base64 {
909     bytes internal constant TABLE =
910         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
911 
912     /// @notice Encodes some bytes to the base64 representation
913     function encode(bytes memory data) internal pure returns (string memory) {
914         uint256 len = data.length;
915         if (len == 0) return "";
916 
917         // multiply by 4/3 rounded up
918         uint256 encodedLen = 4 * ((len + 2) / 3);
919 
920         // Add some extra buffer at the end
921         bytes memory result = new bytes(encodedLen + 32);
922 
923         bytes memory table = TABLE;
924 
925         assembly {
926             let tablePtr := add(table, 1)
927             let resultPtr := add(result, 32)
928 
929             for {
930                 let i := 0
931             } lt(i, len) {
932 
933             } {
934                 i := add(i, 3)
935                 let input := and(mload(add(data, i)), 0xffffff)
936 
937                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
938                 out := shl(8, out)
939                 out := add(
940                     out,
941                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
942                 )
943                 out := shl(8, out)
944                 out := add(
945                     out,
946                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
947                 )
948                 out := shl(8, out)
949                 out := add(
950                     out,
951                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
952                 )
953                 out := shl(224, out)
954 
955                 mstore(resultPtr, out)
956 
957                 resultPtr := add(resultPtr, 4)
958             }
959 
960             switch mod(len, 3)
961             case 1 {
962                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
963             }
964             case 2 {
965                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
966             }
967 
968             mstore(result, encodedLen)
969         }
970 
971         return string(result);
972     }
973 }
974 
975 /*
976                                                                                                                                                                         
977                                                    :*****.    +***                ***=                                                                                  
978         .-=                                        :#%%%%.    #%%%      .--      .%%%*                      ...   .::.          .::::.      ....      ....     ....     
979        +%%%                                          +%%%.    =+++     #%%*       +++=                      +**+-*****+:      :+*******=.   +***.    +***+     +**+     
980      ::#%%%:::.  :::::  -==:   .-====-:       .-===: +%%%.  .:::::   ::%%%*:::  ::::::       :====-.     ---************:    +****+++****:  -***-   :*****-   -***:     
981      *%%%%%%%%- .%%%%%:#%%%+ .*%%%##%%%*.    +%%%%%%#*%%%.  =%%%%%   %%%%%%%%%. *%%%%*    .+%%%%%%%%+.   %%%****#%%%#***+   =***=.   :+***:  +***   +******.  +**+      
982      ::*%%%:::.  :=%%%%#=--: +%%#.  .#%%+   +%%%+:.:+%%%%.  .:*%%%   ::%%%*:::  .:%%%*   .#%%%-..-#%%%.  :-%****. :#%***+  .***+      :***=  -***- -***.***- :***:      
983        *%%%       -%%%#      ..:::---*%%#  .%%%*     +%%%.    +%%%     %%%*       #%%*   +%%%:    :%%%+   :%***+   =%***+  .***=      .***=   +**+.+**- -***.+**+       
984        *%%%       -%%%-      :*%%%%%%%%%#  :%%%=     -%%%.    +%%%     %%%*       #%%*   *%%%      %%%#   :%***+   -%***+   ***+.     -***-   :***+**+   +**+***:       
985        *%%%       -%%%:     .%%%*:.  +%%#  :%%%+     =%%%.    +%%%     %%%*       #%%*   *%%%.     %%%#   :%***+   -%***+   -***+-..:=***+.    +*****-   -*****+        
986        *%%%  ##:  -%%%:     :%%%:   :%%%#   #%%%:   .#%%%.    +%%%     %%%* :##   #%%*   :%%%*    +%%%-   :%***+   -%***+    -**********+.     :****+     +****:        
987        -%%%##%%..##%%%##-    #%%%++*%#%%%#= :#%%%**#%*%%%#* -#%%%%#*   +%%%*#%* +#%%%%#=  -%%%%**%%%%=   ##%####..##%####.    .-+****+=:        =+++:     :+++=         
988         :*#%#+: .*******-     =*#%#+:-****-  .=*#%#*:.****+ :******=    =*#%#+. =******-   .-*#%%#*=.    *******..*******.                                              
989         
990 */
991 contract NUOPAYEE is OperatorAccessControl, ReentrancyGuard {
992     bytes32 public _kycPayMerkleRoot;
993     bytes32 public _prePayMerkleRoot;
994 
995     mapping(address => uint256) private addressPayCount;
996 
997     uint256 private _kycPayLimit = 100;
998 
999     uint256 private _prePayLimit = 700;
1000 
1001     uint256 private _publicPayLimit = 0;
1002 
1003     uint256 private _addressPayLimit = 1;
1004 
1005     uint256 private _kycPayCount;
1006 
1007     uint256 private _prePayCount;
1008 
1009     uint256 private _publicPayCount;
1010 
1011     uint256 private _kycPayPrice = 60000000000000000;
1012 
1013     uint256 private _prePayPrice = 60000000000000000;
1014 
1015     uint256 private _publicPayPrice = 80000000000000000;
1016 
1017     bool private _kycPayOpen = false;
1018 
1019     bool private _prePayOpen = false;
1020 
1021     bool private _publicPayOpen = false;
1022 
1023     uint256 _totalSupply = 800;
1024 
1025     uint256 _totalTokens;
1026 
1027     constructor() {
1028         _addOperator(_msgSender());
1029     }
1030 
1031     function getPayCount()
1032         public
1033         view
1034         returns (
1035             uint256 kycPayCount,
1036             uint256 prePayCount,
1037             uint256 publicPayCount
1038         )
1039     {
1040         kycPayCount = _kycPayCount;
1041         prePayCount = _prePayCount;
1042         publicPayCount = _publicPayCount;
1043     }
1044 
1045     function setMerkleRoot(bytes32 kycPayMerkleRoot, bytes32 prePayMerkleRoot)
1046         public
1047         onlyOperator
1048     {
1049         _kycPayMerkleRoot = kycPayMerkleRoot;
1050         _prePayMerkleRoot = prePayMerkleRoot;
1051     }
1052 
1053     function isWhitelist(
1054         bytes32[] calldata kycMerkleProof,
1055         bytes32[] calldata preMerkleProof
1056     ) public view returns (bool isKycWhitelist, bool isPreWhitelist) {
1057         isKycWhitelist = MerkleProof.verify(
1058             kycMerkleProof,
1059             _kycPayMerkleRoot,
1060             keccak256(abi.encodePacked(msg.sender))
1061         );
1062 
1063         isPreWhitelist = MerkleProof.verify(
1064             preMerkleProof,
1065             _prePayMerkleRoot,
1066             keccak256(abi.encodePacked(msg.sender))
1067         );
1068     }
1069 
1070     function setPayLimit(
1071         uint256 kycPayLimit,
1072         uint256 prePayLimit,
1073         uint256 publicPayLimit,
1074         uint256 addressPayLimit
1075     ) public onlyOperator {
1076         _kycPayLimit = kycPayLimit;
1077         _prePayLimit = prePayLimit;
1078         _publicPayLimit = publicPayLimit;
1079         _addressPayLimit = addressPayLimit;
1080     }
1081 
1082     function getPayLimit()
1083         public
1084         view
1085         returns (
1086             uint256 kycPayLimit,
1087             uint256 prePayLimit,
1088             uint256 publicPayLimit,
1089             uint256 addressPayLimit
1090         )
1091     {
1092         kycPayLimit = _kycPayLimit;
1093         prePayLimit = _prePayLimit;
1094         publicPayLimit = _publicPayLimit;
1095         addressPayLimit = _addressPayLimit;
1096     }
1097 
1098     function setPayPrice(
1099         uint256 kycPayPrice,
1100         uint256 prePayPrice,
1101         uint256 publicPayPrice
1102     ) public onlyOperator {
1103         _kycPayPrice = kycPayPrice;
1104         _prePayPrice = prePayPrice;
1105         _publicPayPrice = publicPayPrice;
1106     }
1107 
1108     function getPayPrice()
1109         public
1110         view
1111         returns (
1112             uint256 kycPayPrice,
1113             uint256 prePayPrice,
1114             uint256 publicPayPrice
1115         )
1116     {
1117         kycPayPrice = _kycPayPrice;
1118         prePayPrice = _prePayPrice;
1119         publicPayPrice = _publicPayPrice;
1120     }
1121 
1122     function setSwith(
1123         bool kycPayOpen,
1124         bool prePayOpen,
1125         bool publicPayOpen
1126     ) public onlyOperator {
1127         _kycPayOpen = kycPayOpen;
1128         _prePayOpen = prePayOpen;
1129         _publicPayOpen = publicPayOpen;
1130     }
1131 
1132     function getSwith()
1133         public
1134         view
1135         returns (
1136             bool kycPayOpen,
1137             bool prePayOpen,
1138             bool publicPayOpen
1139         )
1140     {
1141         kycPayOpen = _kycPayOpen;
1142         prePayOpen = _prePayOpen;
1143         publicPayOpen = _publicPayOpen;
1144     }
1145 
1146     event BuyRecord(
1147         uint256 buyPrice,
1148         uint256 buyAmount,
1149         address buyUserAddress,
1150         uint256 buyType
1151     );
1152 
1153     function _handlePay(address to) internal {
1154         require(
1155             addressPayCount[to] < _addressPayLimit,
1156             "error:10003 already paid"
1157         );
1158         require(
1159             _totalTokens < _totalSupply,
1160             "error:10010 Exceeding the total amount"
1161         );
1162 
1163         addressPayCount[to] = addressPayCount[to] + 1;
1164 
1165         _totalTokens = _totalTokens + 1;
1166     }
1167 
1168     function kycPay(bytes32[] calldata merkleProof, uint256 count)
1169         public
1170         payable
1171         nonReentrant
1172     {
1173         require(count >= 1, "error:10010 Must be greater than 1");
1174 
1175         require(
1176             msg.value == _kycPayPrice * count,
1177             "error:10000 msg.value is incorrect"
1178         );
1179 
1180         require(_kycPayOpen, "error:10001 switch off");
1181 
1182         require(
1183             MerkleProof.verify(
1184                 merkleProof,
1185                 _kycPayMerkleRoot,
1186                 keccak256(abi.encodePacked(msg.sender))
1187             ),
1188             "error:10002 not in the whitelist"
1189         );
1190 
1191         for (uint256 i = 0; i < count; i++) {
1192             require(_kycPayCount < _kycPayLimit, "error:10004 Reach the limit");
1193 
1194             _handlePay(_msgSender());
1195 
1196             _kycPayCount = _kycPayCount + 1;
1197         }
1198 
1199         emit BuyRecord(_kycPayPrice, count, _msgSender(), 1);
1200     }
1201 
1202     function prePay(bytes32[] calldata merkleProof, uint256 count)
1203         public
1204         payable
1205         nonReentrant
1206     {
1207         require(count >= 1, "error:10010 Must be greater than 1");
1208 
1209         require(
1210             msg.value == _prePayPrice * count,
1211             "error:10000 msg.value is incorrect"
1212         );
1213 
1214         require(_prePayOpen, "error:10001 switch off");
1215 
1216         require(
1217             MerkleProof.verify(
1218                 merkleProof,
1219                 _prePayMerkleRoot,
1220                 keccak256(abi.encodePacked(msg.sender))
1221             ),
1222             "error:10002 not in the whitelist"
1223         );
1224 
1225         for (uint256 i = 0; i < count; i++) {
1226             require(_prePayCount < _prePayLimit, "error:10004 Reach the limit");
1227 
1228             _handlePay(_msgSender());
1229 
1230             _prePayCount = _prePayCount + 1;
1231         }
1232 
1233         emit BuyRecord(_prePayPrice, count, _msgSender(), 2);
1234     }
1235 
1236     function publicPay(uint256 count) public payable nonReentrant {
1237         require(count >= 1, "error:10010 Must be greater than 1");
1238 
1239         require(
1240             msg.value == _publicPayPrice * count,
1241             "error:10000 msg.value is incorrect"
1242         );
1243 
1244         require(_publicPayOpen, "error:10001 switch off");
1245 
1246         for (uint256 i = 0; i < count; i++) {
1247             require(
1248                 _publicPayCount < _publicPayLimit,
1249                 "error:10004 Reach the limit"
1250             );
1251 
1252             _handlePay(_msgSender());
1253 
1254             _publicPayCount = _publicPayCount + 1;
1255         }
1256         emit BuyRecord(_publicPayPrice, count, _msgSender(), 3);
1257     }
1258 
1259     function getCanPayCount(address user) external view returns (uint256) {
1260         if (_addressPayLimit < addressPayCount[user]) {
1261             return 0;
1262         }
1263 
1264         return _addressPayLimit - addressPayCount[user];
1265     }
1266 
1267     function supply() public view returns (uint256) {
1268         return _totalSupply;
1269     }
1270 
1271     function totalPaid() public view returns (uint256) {
1272         return _totalTokens;
1273     }
1274 
1275     function withdraw(address[] memory tokens, address _to)
1276         public
1277         onlyOperator
1278     {
1279         for (uint8 i; i < tokens.length; i++) {
1280             IERC20 token = IERC20(tokens[i]);
1281             uint256 b = token.balanceOf(address(this));
1282             if (b > 0) {
1283                 token.transfer(_to, b);
1284             }
1285         }
1286         uint256 balance = address(this).balance;
1287         payable(_to).transfer(balance);
1288     }
1289 }