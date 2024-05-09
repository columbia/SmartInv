1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The tree and the proofs can be generated using our
12  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
13  * You will find a quickstart guide in the readme.
14  *
15  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
16  * hashing, or use a hash function other than keccak256 for hashing leaves.
17  * This is because the concatenation of a sorted pair of internal nodes in
18  * the merkle tree could be reinterpreted as a leaf value.
19  * OpenZeppelin's JavaScript library generates merkle trees that are safe
20  * against this attack out of the box.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
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
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
84      *
85      * _Available since v4.7._
86      */
87     function multiProofVerify(
88         bytes32[] memory proof,
89         bool[] memory proofFlags,
90         bytes32 root,
91         bytes32[] memory leaves
92     ) internal pure returns (bool) {
93         return processMultiProof(proof, proofFlags, leaves) == root;
94     }
95 
96     /**
97      * @dev Calldata version of {multiProofVerify}
98      *
99      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
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
113      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
114      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
115      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
116      * respectively.
117      *
118      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
119      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
120      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
121      *
122      * _Available since v4.7._
123      */
124     function processMultiProof(
125         bytes32[] memory proof,
126         bool[] memory proofFlags,
127         bytes32[] memory leaves
128     ) internal pure returns (bytes32 merkleRoot) {
129         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
130         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
131         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
132         // the merkle tree.
133         uint256 leavesLen = leaves.length;
134         uint256 totalHashes = proofFlags.length;
135 
136         // Check proof validity.
137         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
138 
139         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
140         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
141         bytes32[] memory hashes = new bytes32[](totalHashes);
142         uint256 leafPos = 0;
143         uint256 hashPos = 0;
144         uint256 proofPos = 0;
145         // At each step, we compute the next hash using two values:
146         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
147         //   get the next hash.
148         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
149         //   `proof` array.
150         for (uint256 i = 0; i < totalHashes; i++) {
151             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
152             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
153             hashes[i] = _hashPair(a, b);
154         }
155 
156         if (totalHashes > 0) {
157             return hashes[totalHashes - 1];
158         } else if (leavesLen > 0) {
159             return leaves[0];
160         } else {
161             return proof[0];
162         }
163     }
164 
165     /**
166      * @dev Calldata version of {processMultiProof}.
167      *
168      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
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
185         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
186 
187         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
188         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
189         bytes32[] memory hashes = new bytes32[](totalHashes);
190         uint256 leafPos = 0;
191         uint256 hashPos = 0;
192         uint256 proofPos = 0;
193         // At each step, we compute the next hash using two values:
194         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
195         //   get the next hash.
196         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
197         //   `proof` array.
198         for (uint256 i = 0; i < totalHashes; i++) {
199             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
200             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
201             hashes[i] = _hashPair(a, b);
202         }
203 
204         if (totalHashes > 0) {
205             return hashes[totalHashes - 1];
206         } else if (leavesLen > 0) {
207             return leaves[0];
208         } else {
209             return proof[0];
210         }
211     }
212 
213     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
214         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
215     }
216 
217     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
218         /// @solidity memory-safe-assembly
219         assembly {
220             mstore(0x00, a)
221             mstore(0x20, b)
222             value := keccak256(0x00, 0x40)
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Contract module that helps prevent reentrant calls to a function.
236  *
237  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
238  * available, which can be applied to functions to make sure there are no nested
239  * (reentrant) calls to them.
240  *
241  * Note that because there is a single `nonReentrant` guard, functions marked as
242  * `nonReentrant` may not call one another. This can be worked around by making
243  * those functions `private`, and then adding `external` `nonReentrant` entry
244  * points to them.
245  *
246  * TIP: If you would like to learn more about reentrancy and alternative ways
247  * to protect against it, check out our blog post
248  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
249  */
250 abstract contract ReentrancyGuard {
251     // Booleans are more expensive than uint256 or any type that takes up a full
252     // word because each write operation emits an extra SLOAD to first read the
253     // slot's contents, replace the bits taken up by the boolean, and then write
254     // back. This is the compiler's defense against contract upgrades and
255     // pointer aliasing, and it cannot be disabled.
256 
257     // The values being non-zero value makes deployment a bit more expensive,
258     // but in exchange the refund on every call to nonReentrant will be lower in
259     // amount. Since refunds are capped to a percentage of the total
260     // transaction's gas, it is best to keep them low in cases like this one, to
261     // increase the likelihood of the full refund coming into effect.
262     uint256 private constant _NOT_ENTERED = 1;
263     uint256 private constant _ENTERED = 2;
264 
265     uint256 private _status;
266 
267     constructor() {
268         _status = _NOT_ENTERED;
269     }
270 
271     /**
272      * @dev Prevents a contract from calling itself, directly or indirectly.
273      * Calling a `nonReentrant` function from another `nonReentrant`
274      * function is not supported. It is possible to prevent this from happening
275      * by making the `nonReentrant` function external, and making it call a
276      * `private` function that does the actual work.
277      */
278     modifier nonReentrant() {
279         // On the first call to nonReentrant, _notEntered will be true
280         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
281 
282         // Any calls to nonReentrant after this point will fail
283         _status = _ENTERED;
284 
285         _;
286 
287         // By storing the original value once again, a refund is triggered (see
288         // https://eips.ethereum.org/EIPS/eip-2200)
289         _status = _NOT_ENTERED;
290     }
291 }
292 
293 // File: @openzeppelin/contracts/utils/Address.sol
294 
295 
296 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
297 
298 pragma solidity ^0.8.1;
299 
300 /**
301  * @dev Collection of functions related to the address type
302  */
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      *
321      * [IMPORTANT]
322      * ====
323      * You shouldn't rely on `isContract` to protect against flash loan attacks!
324      *
325      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
326      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
327      * constructor.
328      * ====
329      */
330     function isContract(address account) internal view returns (bool) {
331         // This method relies on extcodesize/address.code.length, which returns 0
332         // for contracts in construction, since the code is only stored at the end
333         // of the constructor execution.
334 
335         return account.code.length > 0;
336     }
337 
338     /**
339      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
340      * `recipient`, forwarding all available gas and reverting on errors.
341      *
342      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
343      * of certain opcodes, possibly making contracts go over the 2300 gas limit
344      * imposed by `transfer`, making them unable to receive funds via
345      * `transfer`. {sendValue} removes this limitation.
346      *
347      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
348      *
349      * IMPORTANT: because control is transferred to `recipient`, care must be
350      * taken to not create reentrancy vulnerabilities. Consider using
351      * {ReentrancyGuard} or the
352      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
353      */
354     function sendValue(address payable recipient, uint256 amount) internal {
355         require(address(this).balance >= amount, "Address: insufficient balance");
356 
357         (bool success, ) = recipient.call{value: amount}("");
358         require(success, "Address: unable to send value, recipient may have reverted");
359     }
360 
361     /**
362      * @dev Performs a Solidity function call using a low level `call`. A
363      * plain `call` is an unsafe replacement for a function call: use this
364      * function instead.
365      *
366      * If `target` reverts with a revert reason, it is bubbled up by this
367      * function (like regular Solidity function calls).
368      *
369      * Returns the raw returned data. To convert to the expected return value,
370      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
371      *
372      * Requirements:
373      *
374      * - `target` must be a contract.
375      * - calling `target` with `data` must not revert.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
380         return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, 0, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but also transferring `value` wei to `target`.
400      *
401      * Requirements:
402      *
403      * - the calling contract must have an ETH balance of at least `value`.
404      * - the called Solidity function must be `payable`.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value
412     ) internal returns (bytes memory) {
413         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
418      * with `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(address(this).balance >= value, "Address: insufficient balance for call");
429         require(isContract(target), "Address: call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.call{value: value}(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
442         return functionStaticCall(target, data, "Address: low-level static call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal view returns (bytes memory) {
456         require(isContract(target), "Address: static call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.staticcall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
469         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(
479         address target,
480         bytes memory data,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         require(isContract(target), "Address: delegate call to non-contract");
484 
485         (bool success, bytes memory returndata) = target.delegatecall(data);
486         return verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     /**
490      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
491      * revert reason using the provided one.
492      *
493      * _Available since v4.3._
494      */
495     function verifyCallResult(
496         bool success,
497         bytes memory returndata,
498         string memory errorMessage
499     ) internal pure returns (bytes memory) {
500         if (success) {
501             return returndata;
502         } else {
503             // Look for revert reason and bubble it up if present
504             if (returndata.length > 0) {
505                 // The easiest way to bubble the revert reason is using memory via assembly
506                 /// @solidity memory-safe-assembly
507                 assembly {
508                     let returndata_size := mload(returndata)
509                     revert(add(32, returndata), returndata_size)
510                 }
511             } else {
512                 revert(errorMessage);
513             }
514         }
515     }
516 }
517 
518 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
519 
520 
521 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
527  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
528  *
529  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
530  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
531  * need to send a transaction, and thus is not required to hold Ether at all.
532  */
533 interface IERC20Permit {
534     /**
535      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
536      * given ``owner``'s signed approval.
537      *
538      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
539      * ordering also apply here.
540      *
541      * Emits an {Approval} event.
542      *
543      * Requirements:
544      *
545      * - `spender` cannot be the zero address.
546      * - `deadline` must be a timestamp in the future.
547      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
548      * over the EIP712-formatted function arguments.
549      * - the signature must use ``owner``'s current nonce (see {nonces}).
550      *
551      * For more information on the signature format, see the
552      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
553      * section].
554      */
555     function permit(
556         address owner,
557         address spender,
558         uint256 value,
559         uint256 deadline,
560         uint8 v,
561         bytes32 r,
562         bytes32 s
563     ) external;
564 
565     /**
566      * @dev Returns the current nonce for `owner`. This value must be
567      * included whenever a signature is generated for {permit}.
568      *
569      * Every successful call to {permit} increases ``owner``'s nonce by one. This
570      * prevents a signature from being used multiple times.
571      */
572     function nonces(address owner) external view returns (uint256);
573 
574     /**
575      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
576      */
577     // solhint-disable-next-line func-name-mixedcase
578     function DOMAIN_SEPARATOR() external view returns (bytes32);
579 }
580 
581 // File: @openzeppelin/contracts/utils/Context.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @dev Provides information about the current execution context, including the
590  * sender of the transaction and its data. While these are generally available
591  * via msg.sender and msg.data, they should not be accessed in such a direct
592  * manner, since when dealing with meta-transactions the account sending and
593  * paying for execution may not be the actual sender (as far as an application
594  * is concerned).
595  *
596  * This contract is only required for intermediate, library-like contracts.
597  */
598 abstract contract Context {
599     function _msgSender() internal view virtual returns (address) {
600         return msg.sender;
601     }
602 
603     function _msgData() internal view virtual returns (bytes calldata) {
604         return msg.data;
605     }
606 }
607 
608 // File: @openzeppelin/contracts/access/Ownable.sol
609 
610 
611 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 
616 /**
617  * @dev Contract module which provides a basic access control mechanism, where
618  * there is an account (an owner) that can be granted exclusive access to
619  * specific functions.
620  *
621  * By default, the owner account will be the one that deploys the contract. This
622  * can later be changed with {transferOwnership}.
623  *
624  * This module is used through inheritance. It will make available the modifier
625  * `onlyOwner`, which can be applied to your functions to restrict their use to
626  * the owner.
627  */
628 abstract contract Ownable is Context {
629     address private _owner;
630 
631     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
632 
633     /**
634      * @dev Initializes the contract setting the deployer as the initial owner.
635      */
636     constructor() {
637         _transferOwnership(_msgSender());
638     }
639 
640     /**
641      * @dev Throws if called by any account other than the owner.
642      */
643     modifier onlyOwner() {
644         _checkOwner();
645         _;
646     }
647 
648     /**
649      * @dev Returns the address of the current owner.
650      */
651     function owner() public view virtual returns (address) {
652         return _owner;
653     }
654 
655     /**
656      * @dev Throws if the sender is not the owner.
657      */
658     function _checkOwner() internal view virtual {
659         require(owner() == _msgSender(), "Ownable: caller is not the owner");
660     }
661 
662     /**
663      * @dev Leaves the contract without owner. It will not be possible to call
664      * `onlyOwner` functions anymore. Can only be called by the current owner.
665      *
666      * NOTE: Renouncing ownership will leave the contract without an owner,
667      * thereby removing any functionality that is only available to the owner.
668      */
669     function renounceOwnership() public virtual onlyOwner {
670         _transferOwnership(address(0));
671     }
672 
673     /**
674      * @dev Transfers ownership of the contract to a new account (`newOwner`).
675      * Can only be called by the current owner.
676      */
677     function transferOwnership(address newOwner) public virtual onlyOwner {
678         require(newOwner != address(0), "Ownable: new owner is the zero address");
679         _transferOwnership(newOwner);
680     }
681 
682     /**
683      * @dev Transfers ownership of the contract to a new account (`newOwner`).
684      * Internal function without access restriction.
685      */
686     function _transferOwnership(address newOwner) internal virtual {
687         address oldOwner = _owner;
688         _owner = newOwner;
689         emit OwnershipTransferred(oldOwner, newOwner);
690     }
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
694 
695 
696 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 /**
701  * @dev Interface of the ERC20 standard as defined in the EIP.
702  */
703 interface IERC20 {
704     /**
705      * @dev Emitted when `value` tokens are moved from one account (`from`) to
706      * another (`to`).
707      *
708      * Note that `value` may be zero.
709      */
710     event Transfer(address indexed from, address indexed to, uint256 value);
711 
712     /**
713      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
714      * a call to {approve}. `value` is the new allowance.
715      */
716     event Approval(address indexed owner, address indexed spender, uint256 value);
717 
718     /**
719      * @dev Returns the amount of tokens in existence.
720      */
721     function totalSupply() external view returns (uint256);
722 
723     /**
724      * @dev Returns the amount of tokens owned by `account`.
725      */
726     function balanceOf(address account) external view returns (uint256);
727 
728     /**
729      * @dev Moves `amount` tokens from the caller's account to `to`.
730      *
731      * Returns a boolean value indicating whether the operation succeeded.
732      *
733      * Emits a {Transfer} event.
734      */
735     function transfer(address to, uint256 amount) external returns (bool);
736 
737     /**
738      * @dev Returns the remaining number of tokens that `spender` will be
739      * allowed to spend on behalf of `owner` through {transferFrom}. This is
740      * zero by default.
741      *
742      * This value changes when {approve} or {transferFrom} are called.
743      */
744     function allowance(address owner, address spender) external view returns (uint256);
745 
746     /**
747      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
748      *
749      * Returns a boolean value indicating whether the operation succeeded.
750      *
751      * IMPORTANT: Beware that changing an allowance with this method brings the risk
752      * that someone may use both the old and the new allowance by unfortunate
753      * transaction ordering. One possible solution to mitigate this race
754      * condition is to first reduce the spender's allowance to 0 and set the
755      * desired value afterwards:
756      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
757      *
758      * Emits an {Approval} event.
759      */
760     function approve(address spender, uint256 amount) external returns (bool);
761 
762     /**
763      * @dev Moves `amount` tokens from `from` to `to` using the
764      * allowance mechanism. `amount` is then deducted from the caller's
765      * allowance.
766      *
767      * Returns a boolean value indicating whether the operation succeeded.
768      *
769      * Emits a {Transfer} event.
770      */
771     function transferFrom(
772         address from,
773         address to,
774         uint256 amount
775     ) external returns (bool);
776 }
777 
778 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
779 
780 
781 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 
786 
787 
788 /**
789  * @title SafeERC20
790  * @dev Wrappers around ERC20 operations that throw on failure (when the token
791  * contract returns false). Tokens that return no value (and instead revert or
792  * throw on failure) are also supported, non-reverting calls are assumed to be
793  * successful.
794  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
795  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
796  */
797 library SafeERC20 {
798     using Address for address;
799 
800     function safeTransfer(
801         IERC20 token,
802         address to,
803         uint256 value
804     ) internal {
805         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
806     }
807 
808     function safeTransferFrom(
809         IERC20 token,
810         address from,
811         address to,
812         uint256 value
813     ) internal {
814         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
815     }
816 
817     /**
818      * @dev Deprecated. This function has issues similar to the ones found in
819      * {IERC20-approve}, and its usage is discouraged.
820      *
821      * Whenever possible, use {safeIncreaseAllowance} and
822      * {safeDecreaseAllowance} instead.
823      */
824     function safeApprove(
825         IERC20 token,
826         address spender,
827         uint256 value
828     ) internal {
829         // safeApprove should only be called when setting an initial allowance,
830         // or when resetting it to zero. To increase and decrease it, use
831         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
832         require(
833             (value == 0) || (token.allowance(address(this), spender) == 0),
834             "SafeERC20: approve from non-zero to non-zero allowance"
835         );
836         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
837     }
838 
839     function safeIncreaseAllowance(
840         IERC20 token,
841         address spender,
842         uint256 value
843     ) internal {
844         uint256 newAllowance = token.allowance(address(this), spender) + value;
845         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
846     }
847 
848     function safeDecreaseAllowance(
849         IERC20 token,
850         address spender,
851         uint256 value
852     ) internal {
853         unchecked {
854             uint256 oldAllowance = token.allowance(address(this), spender);
855             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
856             uint256 newAllowance = oldAllowance - value;
857             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
858         }
859     }
860 
861     function safePermit(
862         IERC20Permit token,
863         address owner,
864         address spender,
865         uint256 value,
866         uint256 deadline,
867         uint8 v,
868         bytes32 r,
869         bytes32 s
870     ) internal {
871         uint256 nonceBefore = token.nonces(owner);
872         token.permit(owner, spender, value, deadline, v, r, s);
873         uint256 nonceAfter = token.nonces(owner);
874         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
875     }
876 
877     /**
878      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
879      * on the return value: the return value is optional (but if data is returned, it must not be false).
880      * @param token The token targeted by the call.
881      * @param data The call data (encoded using abi.encode or one of its variants).
882      */
883     function _callOptionalReturn(IERC20 token, bytes memory data) private {
884         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
885         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
886         // the target address contains contract code and also asserts for success in the low-level call.
887 
888         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
889         if (returndata.length > 0) {
890             // Return data is optional
891             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
892         }
893     }
894 }
895 
896 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
897 
898 
899 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
900 
901 pragma solidity ^0.8.0;
902 
903 
904 /**
905  * @dev Interface for the optional metadata functions from the ERC20 standard.
906  *
907  * _Available since v4.1._
908  */
909 interface IERC20Metadata is IERC20 {
910     /**
911      * @dev Returns the name of the token.
912      */
913     function name() external view returns (string memory);
914 
915     /**
916      * @dev Returns the symbol of the token.
917      */
918     function symbol() external view returns (string memory);
919 
920     /**
921      * @dev Returns the decimals places of the token.
922      */
923     function decimals() external view returns (uint8);
924 }
925 
926 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
927 
928 
929 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 
934 
935 
936 /**
937  * @dev Implementation of the {IERC20} interface.
938  *
939  * This implementation is agnostic to the way tokens are created. This means
940  * that a supply mechanism has to be added in a derived contract using {_mint}.
941  * For a generic mechanism see {ERC20PresetMinterPauser}.
942  *
943  * TIP: For a detailed writeup see our guide
944  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
945  * to implement supply mechanisms].
946  *
947  * We have followed general OpenZeppelin Contracts guidelines: functions revert
948  * instead returning `false` on failure. This behavior is nonetheless
949  * conventional and does not conflict with the expectations of ERC20
950  * applications.
951  *
952  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
953  * This allows applications to reconstruct the allowance for all accounts just
954  * by listening to said events. Other implementations of the EIP may not emit
955  * these events, as it isn't required by the specification.
956  *
957  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
958  * functions have been added to mitigate the well-known issues around setting
959  * allowances. See {IERC20-approve}.
960  */
961 contract ERC20 is Context, IERC20, IERC20Metadata {
962     mapping(address => uint256) private _balances;
963 
964     mapping(address => mapping(address => uint256)) private _allowances;
965 
966     uint256 private _totalSupply;
967 
968     string private _name;
969     string private _symbol;
970 
971     /**
972      * @dev Sets the values for {name} and {symbol}.
973      *
974      * The default value of {decimals} is 18. To select a different value for
975      * {decimals} you should overload it.
976      *
977      * All two of these values are immutable: they can only be set once during
978      * construction.
979      */
980     constructor(string memory name_, string memory symbol_) {
981         _name = name_;
982         _symbol = symbol_;
983     }
984 
985     /**
986      * @dev Returns the name of the token.
987      */
988     function name() public view virtual override returns (string memory) {
989         return _name;
990     }
991 
992     /**
993      * @dev Returns the symbol of the token, usually a shorter version of the
994      * name.
995      */
996     function symbol() public view virtual override returns (string memory) {
997         return _symbol;
998     }
999 
1000     /**
1001      * @dev Returns the number of decimals used to get its user representation.
1002      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1003      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1004      *
1005      * Tokens usually opt for a value of 18, imitating the relationship between
1006      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1007      * overridden;
1008      *
1009      * NOTE: This information is only used for _display_ purposes: it in
1010      * no way affects any of the arithmetic of the contract, including
1011      * {IERC20-balanceOf} and {IERC20-transfer}.
1012      */
1013     function decimals() public view virtual override returns (uint8) {
1014         return 18;
1015     }
1016 
1017     /**
1018      * @dev See {IERC20-totalSupply}.
1019      */
1020     function totalSupply() public view virtual override returns (uint256) {
1021         return _totalSupply;
1022     }
1023 
1024     /**
1025      * @dev See {IERC20-balanceOf}.
1026      */
1027     function balanceOf(address account) public view virtual override returns (uint256) {
1028         return _balances[account];
1029     }
1030 
1031     /**
1032      * @dev See {IERC20-transfer}.
1033      *
1034      * Requirements:
1035      *
1036      * - `to` cannot be the zero address.
1037      * - the caller must have a balance of at least `amount`.
1038      */
1039     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1040         address owner = _msgSender();
1041         _transfer(owner, to, amount);
1042         return true;
1043     }
1044 
1045     /**
1046      * @dev See {IERC20-allowance}.
1047      */
1048     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1049         return _allowances[owner][spender];
1050     }
1051 
1052     /**
1053      * @dev See {IERC20-approve}.
1054      *
1055      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1056      * `transferFrom`. This is semantically equivalent to an infinite approval.
1057      *
1058      * Requirements:
1059      *
1060      * - `spender` cannot be the zero address.
1061      */
1062     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1063         address owner = _msgSender();
1064         _approve(owner, spender, amount);
1065         return true;
1066     }
1067 
1068     /**
1069      * @dev See {IERC20-transferFrom}.
1070      *
1071      * Emits an {Approval} event indicating the updated allowance. This is not
1072      * required by the EIP. See the note at the beginning of {ERC20}.
1073      *
1074      * NOTE: Does not update the allowance if the current allowance
1075      * is the maximum `uint256`.
1076      *
1077      * Requirements:
1078      *
1079      * - `from` and `to` cannot be the zero address.
1080      * - `from` must have a balance of at least `amount`.
1081      * - the caller must have allowance for ``from``'s tokens of at least
1082      * `amount`.
1083      */
1084     function transferFrom(
1085         address from,
1086         address to,
1087         uint256 amount
1088     ) public virtual override returns (bool) {
1089         address spender = _msgSender();
1090         _spendAllowance(from, spender, amount);
1091         _transfer(from, to, amount);
1092         return true;
1093     }
1094 
1095     /**
1096      * @dev Atomically increases the allowance granted to `spender` by the caller.
1097      *
1098      * This is an alternative to {approve} that can be used as a mitigation for
1099      * problems described in {IERC20-approve}.
1100      *
1101      * Emits an {Approval} event indicating the updated allowance.
1102      *
1103      * Requirements:
1104      *
1105      * - `spender` cannot be the zero address.
1106      */
1107     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1108         address owner = _msgSender();
1109         _approve(owner, spender, allowance(owner, spender) + addedValue);
1110         return true;
1111     }
1112 
1113     /**
1114      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1115      *
1116      * This is an alternative to {approve} that can be used as a mitigation for
1117      * problems described in {IERC20-approve}.
1118      *
1119      * Emits an {Approval} event indicating the updated allowance.
1120      *
1121      * Requirements:
1122      *
1123      * - `spender` cannot be the zero address.
1124      * - `spender` must have allowance for the caller of at least
1125      * `subtractedValue`.
1126      */
1127     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1128         address owner = _msgSender();
1129         uint256 currentAllowance = allowance(owner, spender);
1130         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1131         unchecked {
1132             _approve(owner, spender, currentAllowance - subtractedValue);
1133         }
1134 
1135         return true;
1136     }
1137 
1138     /**
1139      * @dev Moves `amount` of tokens from `from` to `to`.
1140      *
1141      * This internal function is equivalent to {transfer}, and can be used to
1142      * e.g. implement automatic token fees, slashing mechanisms, etc.
1143      *
1144      * Emits a {Transfer} event.
1145      *
1146      * Requirements:
1147      *
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      * - `from` must have a balance of at least `amount`.
1151      */
1152     function _transfer(
1153         address from,
1154         address to,
1155         uint256 amount
1156     ) internal virtual {
1157         require(from != address(0), "ERC20: transfer from the zero address");
1158         require(to != address(0), "ERC20: transfer to the zero address");
1159 
1160         _beforeTokenTransfer(from, to, amount);
1161 
1162         uint256 fromBalance = _balances[from];
1163         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1164         unchecked {
1165             _balances[from] = fromBalance - amount;
1166         }
1167         _balances[to] += amount;
1168 
1169         emit Transfer(from, to, amount);
1170 
1171         _afterTokenTransfer(from, to, amount);
1172     }
1173 
1174     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1175      * the total supply.
1176      *
1177      * Emits a {Transfer} event with `from` set to the zero address.
1178      *
1179      * Requirements:
1180      *
1181      * - `account` cannot be the zero address.
1182      */
1183     function _mint(address account, uint256 amount) internal virtual {
1184         require(account != address(0), "ERC20: mint to the zero address");
1185 
1186         _beforeTokenTransfer(address(0), account, amount);
1187 
1188         _totalSupply += amount;
1189         _balances[account] += amount;
1190         emit Transfer(address(0), account, amount);
1191 
1192         _afterTokenTransfer(address(0), account, amount);
1193     }
1194 
1195     /**
1196      * @dev Destroys `amount` tokens from `account`, reducing the
1197      * total supply.
1198      *
1199      * Emits a {Transfer} event with `to` set to the zero address.
1200      *
1201      * Requirements:
1202      *
1203      * - `account` cannot be the zero address.
1204      * - `account` must have at least `amount` tokens.
1205      */
1206     function _burn(address account, uint256 amount) internal virtual {
1207         require(account != address(0), "ERC20: burn from the zero address");
1208 
1209         _beforeTokenTransfer(account, address(0), amount);
1210 
1211         uint256 accountBalance = _balances[account];
1212         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1213         unchecked {
1214             _balances[account] = accountBalance - amount;
1215         }
1216         _totalSupply -= amount;
1217 
1218         emit Transfer(account, address(0), amount);
1219 
1220         _afterTokenTransfer(account, address(0), amount);
1221     }
1222 
1223     /**
1224      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1225      *
1226      * This internal function is equivalent to `approve`, and can be used to
1227      * e.g. set automatic allowances for certain subsystems, etc.
1228      *
1229      * Emits an {Approval} event.
1230      *
1231      * Requirements:
1232      *
1233      * - `owner` cannot be the zero address.
1234      * - `spender` cannot be the zero address.
1235      */
1236     function _approve(
1237         address owner,
1238         address spender,
1239         uint256 amount
1240     ) internal virtual {
1241         require(owner != address(0), "ERC20: approve from the zero address");
1242         require(spender != address(0), "ERC20: approve to the zero address");
1243 
1244         _allowances[owner][spender] = amount;
1245         emit Approval(owner, spender, amount);
1246     }
1247 
1248     /**
1249      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1250      *
1251      * Does not update the allowance amount in case of infinite allowance.
1252      * Revert if not enough allowance is available.
1253      *
1254      * Might emit an {Approval} event.
1255      */
1256     function _spendAllowance(
1257         address owner,
1258         address spender,
1259         uint256 amount
1260     ) internal virtual {
1261         uint256 currentAllowance = allowance(owner, spender);
1262         if (currentAllowance != type(uint256).max) {
1263             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1264             unchecked {
1265                 _approve(owner, spender, currentAllowance - amount);
1266             }
1267         }
1268     }
1269 
1270     /**
1271      * @dev Hook that is called before any transfer of tokens. This includes
1272      * minting and burning.
1273      *
1274      * Calling conditions:
1275      *
1276      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1277      * will be transferred to `to`.
1278      * - when `from` is zero, `amount` tokens will be minted for `to`.
1279      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1280      * - `from` and `to` are never both zero.
1281      *
1282      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1283      */
1284     function _beforeTokenTransfer(
1285         address from,
1286         address to,
1287         uint256 amount
1288     ) internal virtual {}
1289 
1290     /**
1291      * @dev Hook that is called after any transfer of tokens. This includes
1292      * minting and burning.
1293      *
1294      * Calling conditions:
1295      *
1296      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1297      * has been transferred to `to`.
1298      * - when `from` is zero, `amount` tokens have been minted for `to`.
1299      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1300      * - `from` and `to` are never both zero.
1301      *
1302      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1303      */
1304     function _afterTokenTransfer(
1305         address from,
1306         address to,
1307         uint256 amount
1308     ) internal virtual {}
1309 }
1310 
1311 // File: hardhat/console.sol
1312 
1313 
1314 pragma solidity >= 0.4.22 <0.9.0;
1315 
1316 library console {
1317 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1318 
1319 	function _sendLogPayload(bytes memory payload) private view {
1320 		uint256 payloadLength = payload.length;
1321 		address consoleAddress = CONSOLE_ADDRESS;
1322 		assembly {
1323 			let payloadStart := add(payload, 32)
1324 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1325 		}
1326 	}
1327 
1328 	function log() internal view {
1329 		_sendLogPayload(abi.encodeWithSignature("log()"));
1330 	}
1331 
1332 	function logInt(int256 p0) internal view {
1333 		_sendLogPayload(abi.encodeWithSignature("log(int256)", p0));
1334 	}
1335 
1336 	function logUint(uint256 p0) internal view {
1337 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
1338 	}
1339 
1340 	function logString(string memory p0) internal view {
1341 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1342 	}
1343 
1344 	function logBool(bool p0) internal view {
1345 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1346 	}
1347 
1348 	function logAddress(address p0) internal view {
1349 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1350 	}
1351 
1352 	function logBytes(bytes memory p0) internal view {
1353 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1354 	}
1355 
1356 	function logBytes1(bytes1 p0) internal view {
1357 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1358 	}
1359 
1360 	function logBytes2(bytes2 p0) internal view {
1361 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1362 	}
1363 
1364 	function logBytes3(bytes3 p0) internal view {
1365 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1366 	}
1367 
1368 	function logBytes4(bytes4 p0) internal view {
1369 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1370 	}
1371 
1372 	function logBytes5(bytes5 p0) internal view {
1373 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1374 	}
1375 
1376 	function logBytes6(bytes6 p0) internal view {
1377 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1378 	}
1379 
1380 	function logBytes7(bytes7 p0) internal view {
1381 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1382 	}
1383 
1384 	function logBytes8(bytes8 p0) internal view {
1385 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1386 	}
1387 
1388 	function logBytes9(bytes9 p0) internal view {
1389 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1390 	}
1391 
1392 	function logBytes10(bytes10 p0) internal view {
1393 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1394 	}
1395 
1396 	function logBytes11(bytes11 p0) internal view {
1397 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1398 	}
1399 
1400 	function logBytes12(bytes12 p0) internal view {
1401 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1402 	}
1403 
1404 	function logBytes13(bytes13 p0) internal view {
1405 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1406 	}
1407 
1408 	function logBytes14(bytes14 p0) internal view {
1409 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1410 	}
1411 
1412 	function logBytes15(bytes15 p0) internal view {
1413 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1414 	}
1415 
1416 	function logBytes16(bytes16 p0) internal view {
1417 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1418 	}
1419 
1420 	function logBytes17(bytes17 p0) internal view {
1421 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1422 	}
1423 
1424 	function logBytes18(bytes18 p0) internal view {
1425 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1426 	}
1427 
1428 	function logBytes19(bytes19 p0) internal view {
1429 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1430 	}
1431 
1432 	function logBytes20(bytes20 p0) internal view {
1433 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1434 	}
1435 
1436 	function logBytes21(bytes21 p0) internal view {
1437 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1438 	}
1439 
1440 	function logBytes22(bytes22 p0) internal view {
1441 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1442 	}
1443 
1444 	function logBytes23(bytes23 p0) internal view {
1445 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1446 	}
1447 
1448 	function logBytes24(bytes24 p0) internal view {
1449 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1450 	}
1451 
1452 	function logBytes25(bytes25 p0) internal view {
1453 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1454 	}
1455 
1456 	function logBytes26(bytes26 p0) internal view {
1457 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1458 	}
1459 
1460 	function logBytes27(bytes27 p0) internal view {
1461 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1462 	}
1463 
1464 	function logBytes28(bytes28 p0) internal view {
1465 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1466 	}
1467 
1468 	function logBytes29(bytes29 p0) internal view {
1469 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1470 	}
1471 
1472 	function logBytes30(bytes30 p0) internal view {
1473 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1474 	}
1475 
1476 	function logBytes31(bytes31 p0) internal view {
1477 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1478 	}
1479 
1480 	function logBytes32(bytes32 p0) internal view {
1481 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1482 	}
1483 
1484 	function log(uint256 p0) internal view {
1485 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
1486 	}
1487 
1488 	function log(string memory p0) internal view {
1489 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1490 	}
1491 
1492 	function log(bool p0) internal view {
1493 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1494 	}
1495 
1496 	function log(address p0) internal view {
1497 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1498 	}
1499 
1500 	function log(uint256 p0, uint256 p1) internal view {
1501 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256)", p0, p1));
1502 	}
1503 
1504 	function log(uint256 p0, string memory p1) internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string)", p0, p1));
1506 	}
1507 
1508 	function log(uint256 p0, bool p1) internal view {
1509 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool)", p0, p1));
1510 	}
1511 
1512 	function log(uint256 p0, address p1) internal view {
1513 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address)", p0, p1));
1514 	}
1515 
1516 	function log(string memory p0, uint256 p1) internal view {
1517 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
1518 	}
1519 
1520 	function log(string memory p0, string memory p1) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1522 	}
1523 
1524 	function log(string memory p0, bool p1) internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1526 	}
1527 
1528 	function log(string memory p0, address p1) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1530 	}
1531 
1532 	function log(bool p0, uint256 p1) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256)", p0, p1));
1534 	}
1535 
1536 	function log(bool p0, string memory p1) internal view {
1537 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1538 	}
1539 
1540 	function log(bool p0, bool p1) internal view {
1541 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1542 	}
1543 
1544 	function log(bool p0, address p1) internal view {
1545 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1546 	}
1547 
1548 	function log(address p0, uint256 p1) internal view {
1549 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256)", p0, p1));
1550 	}
1551 
1552 	function log(address p0, string memory p1) internal view {
1553 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1554 	}
1555 
1556 	function log(address p0, bool p1) internal view {
1557 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1558 	}
1559 
1560 	function log(address p0, address p1) internal view {
1561 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1562 	}
1563 
1564 	function log(uint256 p0, uint256 p1, uint256 p2) internal view {
1565 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256)", p0, p1, p2));
1566 	}
1567 
1568 	function log(uint256 p0, uint256 p1, string memory p2) internal view {
1569 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string)", p0, p1, p2));
1570 	}
1571 
1572 	function log(uint256 p0, uint256 p1, bool p2) internal view {
1573 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool)", p0, p1, p2));
1574 	}
1575 
1576 	function log(uint256 p0, uint256 p1, address p2) internal view {
1577 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address)", p0, p1, p2));
1578 	}
1579 
1580 	function log(uint256 p0, string memory p1, uint256 p2) internal view {
1581 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256)", p0, p1, p2));
1582 	}
1583 
1584 	function log(uint256 p0, string memory p1, string memory p2) internal view {
1585 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string)", p0, p1, p2));
1586 	}
1587 
1588 	function log(uint256 p0, string memory p1, bool p2) internal view {
1589 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool)", p0, p1, p2));
1590 	}
1591 
1592 	function log(uint256 p0, string memory p1, address p2) internal view {
1593 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address)", p0, p1, p2));
1594 	}
1595 
1596 	function log(uint256 p0, bool p1, uint256 p2) internal view {
1597 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256)", p0, p1, p2));
1598 	}
1599 
1600 	function log(uint256 p0, bool p1, string memory p2) internal view {
1601 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string)", p0, p1, p2));
1602 	}
1603 
1604 	function log(uint256 p0, bool p1, bool p2) internal view {
1605 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool)", p0, p1, p2));
1606 	}
1607 
1608 	function log(uint256 p0, bool p1, address p2) internal view {
1609 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address)", p0, p1, p2));
1610 	}
1611 
1612 	function log(uint256 p0, address p1, uint256 p2) internal view {
1613 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256)", p0, p1, p2));
1614 	}
1615 
1616 	function log(uint256 p0, address p1, string memory p2) internal view {
1617 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string)", p0, p1, p2));
1618 	}
1619 
1620 	function log(uint256 p0, address p1, bool p2) internal view {
1621 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool)", p0, p1, p2));
1622 	}
1623 
1624 	function log(uint256 p0, address p1, address p2) internal view {
1625 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address)", p0, p1, p2));
1626 	}
1627 
1628 	function log(string memory p0, uint256 p1, uint256 p2) internal view {
1629 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256)", p0, p1, p2));
1630 	}
1631 
1632 	function log(string memory p0, uint256 p1, string memory p2) internal view {
1633 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string)", p0, p1, p2));
1634 	}
1635 
1636 	function log(string memory p0, uint256 p1, bool p2) internal view {
1637 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool)", p0, p1, p2));
1638 	}
1639 
1640 	function log(string memory p0, uint256 p1, address p2) internal view {
1641 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address)", p0, p1, p2));
1642 	}
1643 
1644 	function log(string memory p0, string memory p1, uint256 p2) internal view {
1645 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256)", p0, p1, p2));
1646 	}
1647 
1648 	function log(string memory p0, string memory p1, string memory p2) internal view {
1649 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1650 	}
1651 
1652 	function log(string memory p0, string memory p1, bool p2) internal view {
1653 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1654 	}
1655 
1656 	function log(string memory p0, string memory p1, address p2) internal view {
1657 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1658 	}
1659 
1660 	function log(string memory p0, bool p1, uint256 p2) internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256)", p0, p1, p2));
1662 	}
1663 
1664 	function log(string memory p0, bool p1, string memory p2) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1666 	}
1667 
1668 	function log(string memory p0, bool p1, bool p2) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1670 	}
1671 
1672 	function log(string memory p0, bool p1, address p2) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1674 	}
1675 
1676 	function log(string memory p0, address p1, uint256 p2) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256)", p0, p1, p2));
1678 	}
1679 
1680 	function log(string memory p0, address p1, string memory p2) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1682 	}
1683 
1684 	function log(string memory p0, address p1, bool p2) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1686 	}
1687 
1688 	function log(string memory p0, address p1, address p2) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1690 	}
1691 
1692 	function log(bool p0, uint256 p1, uint256 p2) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256)", p0, p1, p2));
1694 	}
1695 
1696 	function log(bool p0, uint256 p1, string memory p2) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string)", p0, p1, p2));
1698 	}
1699 
1700 	function log(bool p0, uint256 p1, bool p2) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool)", p0, p1, p2));
1702 	}
1703 
1704 	function log(bool p0, uint256 p1, address p2) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address)", p0, p1, p2));
1706 	}
1707 
1708 	function log(bool p0, string memory p1, uint256 p2) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256)", p0, p1, p2));
1710 	}
1711 
1712 	function log(bool p0, string memory p1, string memory p2) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1714 	}
1715 
1716 	function log(bool p0, string memory p1, bool p2) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1718 	}
1719 
1720 	function log(bool p0, string memory p1, address p2) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1722 	}
1723 
1724 	function log(bool p0, bool p1, uint256 p2) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256)", p0, p1, p2));
1726 	}
1727 
1728 	function log(bool p0, bool p1, string memory p2) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1730 	}
1731 
1732 	function log(bool p0, bool p1, bool p2) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1734 	}
1735 
1736 	function log(bool p0, bool p1, address p2) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1738 	}
1739 
1740 	function log(bool p0, address p1, uint256 p2) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256)", p0, p1, p2));
1742 	}
1743 
1744 	function log(bool p0, address p1, string memory p2) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1746 	}
1747 
1748 	function log(bool p0, address p1, bool p2) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1750 	}
1751 
1752 	function log(bool p0, address p1, address p2) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1754 	}
1755 
1756 	function log(address p0, uint256 p1, uint256 p2) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256)", p0, p1, p2));
1758 	}
1759 
1760 	function log(address p0, uint256 p1, string memory p2) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string)", p0, p1, p2));
1762 	}
1763 
1764 	function log(address p0, uint256 p1, bool p2) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool)", p0, p1, p2));
1766 	}
1767 
1768 	function log(address p0, uint256 p1, address p2) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address)", p0, p1, p2));
1770 	}
1771 
1772 	function log(address p0, string memory p1, uint256 p2) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256)", p0, p1, p2));
1774 	}
1775 
1776 	function log(address p0, string memory p1, string memory p2) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1778 	}
1779 
1780 	function log(address p0, string memory p1, bool p2) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1782 	}
1783 
1784 	function log(address p0, string memory p1, address p2) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1786 	}
1787 
1788 	function log(address p0, bool p1, uint256 p2) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256)", p0, p1, p2));
1790 	}
1791 
1792 	function log(address p0, bool p1, string memory p2) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1794 	}
1795 
1796 	function log(address p0, bool p1, bool p2) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1798 	}
1799 
1800 	function log(address p0, bool p1, address p2) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1802 	}
1803 
1804 	function log(address p0, address p1, uint256 p2) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256)", p0, p1, p2));
1806 	}
1807 
1808 	function log(address p0, address p1, string memory p2) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1810 	}
1811 
1812 	function log(address p0, address p1, bool p2) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1814 	}
1815 
1816 	function log(address p0, address p1, address p2) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1818 	}
1819 
1820 	function log(uint256 p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1821 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,uint256)", p0, p1, p2, p3));
1822 	}
1823 
1824 	function log(uint256 p0, uint256 p1, uint256 p2, string memory p3) internal view {
1825 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,string)", p0, p1, p2, p3));
1826 	}
1827 
1828 	function log(uint256 p0, uint256 p1, uint256 p2, bool p3) internal view {
1829 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,bool)", p0, p1, p2, p3));
1830 	}
1831 
1832 	function log(uint256 p0, uint256 p1, uint256 p2, address p3) internal view {
1833 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,address)", p0, p1, p2, p3));
1834 	}
1835 
1836 	function log(uint256 p0, uint256 p1, string memory p2, uint256 p3) internal view {
1837 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,uint256)", p0, p1, p2, p3));
1838 	}
1839 
1840 	function log(uint256 p0, uint256 p1, string memory p2, string memory p3) internal view {
1841 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,string)", p0, p1, p2, p3));
1842 	}
1843 
1844 	function log(uint256 p0, uint256 p1, string memory p2, bool p3) internal view {
1845 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,bool)", p0, p1, p2, p3));
1846 	}
1847 
1848 	function log(uint256 p0, uint256 p1, string memory p2, address p3) internal view {
1849 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,address)", p0, p1, p2, p3));
1850 	}
1851 
1852 	function log(uint256 p0, uint256 p1, bool p2, uint256 p3) internal view {
1853 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,uint256)", p0, p1, p2, p3));
1854 	}
1855 
1856 	function log(uint256 p0, uint256 p1, bool p2, string memory p3) internal view {
1857 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,string)", p0, p1, p2, p3));
1858 	}
1859 
1860 	function log(uint256 p0, uint256 p1, bool p2, bool p3) internal view {
1861 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,bool)", p0, p1, p2, p3));
1862 	}
1863 
1864 	function log(uint256 p0, uint256 p1, bool p2, address p3) internal view {
1865 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,address)", p0, p1, p2, p3));
1866 	}
1867 
1868 	function log(uint256 p0, uint256 p1, address p2, uint256 p3) internal view {
1869 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,uint256)", p0, p1, p2, p3));
1870 	}
1871 
1872 	function log(uint256 p0, uint256 p1, address p2, string memory p3) internal view {
1873 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,string)", p0, p1, p2, p3));
1874 	}
1875 
1876 	function log(uint256 p0, uint256 p1, address p2, bool p3) internal view {
1877 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,bool)", p0, p1, p2, p3));
1878 	}
1879 
1880 	function log(uint256 p0, uint256 p1, address p2, address p3) internal view {
1881 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,address)", p0, p1, p2, p3));
1882 	}
1883 
1884 	function log(uint256 p0, string memory p1, uint256 p2, uint256 p3) internal view {
1885 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,uint256)", p0, p1, p2, p3));
1886 	}
1887 
1888 	function log(uint256 p0, string memory p1, uint256 p2, string memory p3) internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,string)", p0, p1, p2, p3));
1890 	}
1891 
1892 	function log(uint256 p0, string memory p1, uint256 p2, bool p3) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,bool)", p0, p1, p2, p3));
1894 	}
1895 
1896 	function log(uint256 p0, string memory p1, uint256 p2, address p3) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,address)", p0, p1, p2, p3));
1898 	}
1899 
1900 	function log(uint256 p0, string memory p1, string memory p2, uint256 p3) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,uint256)", p0, p1, p2, p3));
1902 	}
1903 
1904 	function log(uint256 p0, string memory p1, string memory p2, string memory p3) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,string)", p0, p1, p2, p3));
1906 	}
1907 
1908 	function log(uint256 p0, string memory p1, string memory p2, bool p3) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,bool)", p0, p1, p2, p3));
1910 	}
1911 
1912 	function log(uint256 p0, string memory p1, string memory p2, address p3) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,address)", p0, p1, p2, p3));
1914 	}
1915 
1916 	function log(uint256 p0, string memory p1, bool p2, uint256 p3) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,uint256)", p0, p1, p2, p3));
1918 	}
1919 
1920 	function log(uint256 p0, string memory p1, bool p2, string memory p3) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,string)", p0, p1, p2, p3));
1922 	}
1923 
1924 	function log(uint256 p0, string memory p1, bool p2, bool p3) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,bool)", p0, p1, p2, p3));
1926 	}
1927 
1928 	function log(uint256 p0, string memory p1, bool p2, address p3) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,address)", p0, p1, p2, p3));
1930 	}
1931 
1932 	function log(uint256 p0, string memory p1, address p2, uint256 p3) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,uint256)", p0, p1, p2, p3));
1934 	}
1935 
1936 	function log(uint256 p0, string memory p1, address p2, string memory p3) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,string)", p0, p1, p2, p3));
1938 	}
1939 
1940 	function log(uint256 p0, string memory p1, address p2, bool p3) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,bool)", p0, p1, p2, p3));
1942 	}
1943 
1944 	function log(uint256 p0, string memory p1, address p2, address p3) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,address)", p0, p1, p2, p3));
1946 	}
1947 
1948 	function log(uint256 p0, bool p1, uint256 p2, uint256 p3) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,uint256)", p0, p1, p2, p3));
1950 	}
1951 
1952 	function log(uint256 p0, bool p1, uint256 p2, string memory p3) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,string)", p0, p1, p2, p3));
1954 	}
1955 
1956 	function log(uint256 p0, bool p1, uint256 p2, bool p3) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,bool)", p0, p1, p2, p3));
1958 	}
1959 
1960 	function log(uint256 p0, bool p1, uint256 p2, address p3) internal view {
1961 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,address)", p0, p1, p2, p3));
1962 	}
1963 
1964 	function log(uint256 p0, bool p1, string memory p2, uint256 p3) internal view {
1965 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,uint256)", p0, p1, p2, p3));
1966 	}
1967 
1968 	function log(uint256 p0, bool p1, string memory p2, string memory p3) internal view {
1969 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,string)", p0, p1, p2, p3));
1970 	}
1971 
1972 	function log(uint256 p0, bool p1, string memory p2, bool p3) internal view {
1973 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,bool)", p0, p1, p2, p3));
1974 	}
1975 
1976 	function log(uint256 p0, bool p1, string memory p2, address p3) internal view {
1977 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,address)", p0, p1, p2, p3));
1978 	}
1979 
1980 	function log(uint256 p0, bool p1, bool p2, uint256 p3) internal view {
1981 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,uint256)", p0, p1, p2, p3));
1982 	}
1983 
1984 	function log(uint256 p0, bool p1, bool p2, string memory p3) internal view {
1985 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,string)", p0, p1, p2, p3));
1986 	}
1987 
1988 	function log(uint256 p0, bool p1, bool p2, bool p3) internal view {
1989 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,bool)", p0, p1, p2, p3));
1990 	}
1991 
1992 	function log(uint256 p0, bool p1, bool p2, address p3) internal view {
1993 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,address)", p0, p1, p2, p3));
1994 	}
1995 
1996 	function log(uint256 p0, bool p1, address p2, uint256 p3) internal view {
1997 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,uint256)", p0, p1, p2, p3));
1998 	}
1999 
2000 	function log(uint256 p0, bool p1, address p2, string memory p3) internal view {
2001 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,string)", p0, p1, p2, p3));
2002 	}
2003 
2004 	function log(uint256 p0, bool p1, address p2, bool p3) internal view {
2005 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,bool)", p0, p1, p2, p3));
2006 	}
2007 
2008 	function log(uint256 p0, bool p1, address p2, address p3) internal view {
2009 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,address)", p0, p1, p2, p3));
2010 	}
2011 
2012 	function log(uint256 p0, address p1, uint256 p2, uint256 p3) internal view {
2013 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,uint256)", p0, p1, p2, p3));
2014 	}
2015 
2016 	function log(uint256 p0, address p1, uint256 p2, string memory p3) internal view {
2017 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,string)", p0, p1, p2, p3));
2018 	}
2019 
2020 	function log(uint256 p0, address p1, uint256 p2, bool p3) internal view {
2021 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,bool)", p0, p1, p2, p3));
2022 	}
2023 
2024 	function log(uint256 p0, address p1, uint256 p2, address p3) internal view {
2025 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,address)", p0, p1, p2, p3));
2026 	}
2027 
2028 	function log(uint256 p0, address p1, string memory p2, uint256 p3) internal view {
2029 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,uint256)", p0, p1, p2, p3));
2030 	}
2031 
2032 	function log(uint256 p0, address p1, string memory p2, string memory p3) internal view {
2033 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,string)", p0, p1, p2, p3));
2034 	}
2035 
2036 	function log(uint256 p0, address p1, string memory p2, bool p3) internal view {
2037 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,bool)", p0, p1, p2, p3));
2038 	}
2039 
2040 	function log(uint256 p0, address p1, string memory p2, address p3) internal view {
2041 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,address)", p0, p1, p2, p3));
2042 	}
2043 
2044 	function log(uint256 p0, address p1, bool p2, uint256 p3) internal view {
2045 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,uint256)", p0, p1, p2, p3));
2046 	}
2047 
2048 	function log(uint256 p0, address p1, bool p2, string memory p3) internal view {
2049 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,string)", p0, p1, p2, p3));
2050 	}
2051 
2052 	function log(uint256 p0, address p1, bool p2, bool p3) internal view {
2053 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,bool)", p0, p1, p2, p3));
2054 	}
2055 
2056 	function log(uint256 p0, address p1, bool p2, address p3) internal view {
2057 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,address)", p0, p1, p2, p3));
2058 	}
2059 
2060 	function log(uint256 p0, address p1, address p2, uint256 p3) internal view {
2061 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,uint256)", p0, p1, p2, p3));
2062 	}
2063 
2064 	function log(uint256 p0, address p1, address p2, string memory p3) internal view {
2065 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,string)", p0, p1, p2, p3));
2066 	}
2067 
2068 	function log(uint256 p0, address p1, address p2, bool p3) internal view {
2069 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,bool)", p0, p1, p2, p3));
2070 	}
2071 
2072 	function log(uint256 p0, address p1, address p2, address p3) internal view {
2073 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,address)", p0, p1, p2, p3));
2074 	}
2075 
2076 	function log(string memory p0, uint256 p1, uint256 p2, uint256 p3) internal view {
2077 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,uint256)", p0, p1, p2, p3));
2078 	}
2079 
2080 	function log(string memory p0, uint256 p1, uint256 p2, string memory p3) internal view {
2081 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,string)", p0, p1, p2, p3));
2082 	}
2083 
2084 	function log(string memory p0, uint256 p1, uint256 p2, bool p3) internal view {
2085 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,bool)", p0, p1, p2, p3));
2086 	}
2087 
2088 	function log(string memory p0, uint256 p1, uint256 p2, address p3) internal view {
2089 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,address)", p0, p1, p2, p3));
2090 	}
2091 
2092 	function log(string memory p0, uint256 p1, string memory p2, uint256 p3) internal view {
2093 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,uint256)", p0, p1, p2, p3));
2094 	}
2095 
2096 	function log(string memory p0, uint256 p1, string memory p2, string memory p3) internal view {
2097 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,string)", p0, p1, p2, p3));
2098 	}
2099 
2100 	function log(string memory p0, uint256 p1, string memory p2, bool p3) internal view {
2101 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,bool)", p0, p1, p2, p3));
2102 	}
2103 
2104 	function log(string memory p0, uint256 p1, string memory p2, address p3) internal view {
2105 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,address)", p0, p1, p2, p3));
2106 	}
2107 
2108 	function log(string memory p0, uint256 p1, bool p2, uint256 p3) internal view {
2109 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,uint256)", p0, p1, p2, p3));
2110 	}
2111 
2112 	function log(string memory p0, uint256 p1, bool p2, string memory p3) internal view {
2113 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,string)", p0, p1, p2, p3));
2114 	}
2115 
2116 	function log(string memory p0, uint256 p1, bool p2, bool p3) internal view {
2117 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,bool)", p0, p1, p2, p3));
2118 	}
2119 
2120 	function log(string memory p0, uint256 p1, bool p2, address p3) internal view {
2121 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,address)", p0, p1, p2, p3));
2122 	}
2123 
2124 	function log(string memory p0, uint256 p1, address p2, uint256 p3) internal view {
2125 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,uint256)", p0, p1, p2, p3));
2126 	}
2127 
2128 	function log(string memory p0, uint256 p1, address p2, string memory p3) internal view {
2129 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,string)", p0, p1, p2, p3));
2130 	}
2131 
2132 	function log(string memory p0, uint256 p1, address p2, bool p3) internal view {
2133 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,bool)", p0, p1, p2, p3));
2134 	}
2135 
2136 	function log(string memory p0, uint256 p1, address p2, address p3) internal view {
2137 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,address)", p0, p1, p2, p3));
2138 	}
2139 
2140 	function log(string memory p0, string memory p1, uint256 p2, uint256 p3) internal view {
2141 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,uint256)", p0, p1, p2, p3));
2142 	}
2143 
2144 	function log(string memory p0, string memory p1, uint256 p2, string memory p3) internal view {
2145 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,string)", p0, p1, p2, p3));
2146 	}
2147 
2148 	function log(string memory p0, string memory p1, uint256 p2, bool p3) internal view {
2149 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,bool)", p0, p1, p2, p3));
2150 	}
2151 
2152 	function log(string memory p0, string memory p1, uint256 p2, address p3) internal view {
2153 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,address)", p0, p1, p2, p3));
2154 	}
2155 
2156 	function log(string memory p0, string memory p1, string memory p2, uint256 p3) internal view {
2157 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint256)", p0, p1, p2, p3));
2158 	}
2159 
2160 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2161 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2162 	}
2163 
2164 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2165 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2166 	}
2167 
2168 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2169 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2170 	}
2171 
2172 	function log(string memory p0, string memory p1, bool p2, uint256 p3) internal view {
2173 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint256)", p0, p1, p2, p3));
2174 	}
2175 
2176 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2177 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2178 	}
2179 
2180 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2181 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2182 	}
2183 
2184 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2185 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2186 	}
2187 
2188 	function log(string memory p0, string memory p1, address p2, uint256 p3) internal view {
2189 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint256)", p0, p1, p2, p3));
2190 	}
2191 
2192 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2193 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2194 	}
2195 
2196 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2197 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2198 	}
2199 
2200 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2201 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2202 	}
2203 
2204 	function log(string memory p0, bool p1, uint256 p2, uint256 p3) internal view {
2205 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,uint256)", p0, p1, p2, p3));
2206 	}
2207 
2208 	function log(string memory p0, bool p1, uint256 p2, string memory p3) internal view {
2209 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,string)", p0, p1, p2, p3));
2210 	}
2211 
2212 	function log(string memory p0, bool p1, uint256 p2, bool p3) internal view {
2213 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,bool)", p0, p1, p2, p3));
2214 	}
2215 
2216 	function log(string memory p0, bool p1, uint256 p2, address p3) internal view {
2217 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,address)", p0, p1, p2, p3));
2218 	}
2219 
2220 	function log(string memory p0, bool p1, string memory p2, uint256 p3) internal view {
2221 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint256)", p0, p1, p2, p3));
2222 	}
2223 
2224 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2225 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2226 	}
2227 
2228 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2229 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2230 	}
2231 
2232 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2233 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2234 	}
2235 
2236 	function log(string memory p0, bool p1, bool p2, uint256 p3) internal view {
2237 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint256)", p0, p1, p2, p3));
2238 	}
2239 
2240 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2241 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2242 	}
2243 
2244 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2245 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2246 	}
2247 
2248 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2249 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2250 	}
2251 
2252 	function log(string memory p0, bool p1, address p2, uint256 p3) internal view {
2253 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint256)", p0, p1, p2, p3));
2254 	}
2255 
2256 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2257 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2258 	}
2259 
2260 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2261 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2262 	}
2263 
2264 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2265 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2266 	}
2267 
2268 	function log(string memory p0, address p1, uint256 p2, uint256 p3) internal view {
2269 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,uint256)", p0, p1, p2, p3));
2270 	}
2271 
2272 	function log(string memory p0, address p1, uint256 p2, string memory p3) internal view {
2273 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,string)", p0, p1, p2, p3));
2274 	}
2275 
2276 	function log(string memory p0, address p1, uint256 p2, bool p3) internal view {
2277 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,bool)", p0, p1, p2, p3));
2278 	}
2279 
2280 	function log(string memory p0, address p1, uint256 p2, address p3) internal view {
2281 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,address)", p0, p1, p2, p3));
2282 	}
2283 
2284 	function log(string memory p0, address p1, string memory p2, uint256 p3) internal view {
2285 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint256)", p0, p1, p2, p3));
2286 	}
2287 
2288 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2289 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2290 	}
2291 
2292 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2293 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2294 	}
2295 
2296 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2297 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2298 	}
2299 
2300 	function log(string memory p0, address p1, bool p2, uint256 p3) internal view {
2301 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint256)", p0, p1, p2, p3));
2302 	}
2303 
2304 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2305 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2306 	}
2307 
2308 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2309 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2310 	}
2311 
2312 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2313 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2314 	}
2315 
2316 	function log(string memory p0, address p1, address p2, uint256 p3) internal view {
2317 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint256)", p0, p1, p2, p3));
2318 	}
2319 
2320 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2321 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2322 	}
2323 
2324 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2325 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2326 	}
2327 
2328 	function log(string memory p0, address p1, address p2, address p3) internal view {
2329 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2330 	}
2331 
2332 	function log(bool p0, uint256 p1, uint256 p2, uint256 p3) internal view {
2333 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,uint256)", p0, p1, p2, p3));
2334 	}
2335 
2336 	function log(bool p0, uint256 p1, uint256 p2, string memory p3) internal view {
2337 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,string)", p0, p1, p2, p3));
2338 	}
2339 
2340 	function log(bool p0, uint256 p1, uint256 p2, bool p3) internal view {
2341 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,bool)", p0, p1, p2, p3));
2342 	}
2343 
2344 	function log(bool p0, uint256 p1, uint256 p2, address p3) internal view {
2345 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,address)", p0, p1, p2, p3));
2346 	}
2347 
2348 	function log(bool p0, uint256 p1, string memory p2, uint256 p3) internal view {
2349 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,uint256)", p0, p1, p2, p3));
2350 	}
2351 
2352 	function log(bool p0, uint256 p1, string memory p2, string memory p3) internal view {
2353 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,string)", p0, p1, p2, p3));
2354 	}
2355 
2356 	function log(bool p0, uint256 p1, string memory p2, bool p3) internal view {
2357 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,bool)", p0, p1, p2, p3));
2358 	}
2359 
2360 	function log(bool p0, uint256 p1, string memory p2, address p3) internal view {
2361 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,address)", p0, p1, p2, p3));
2362 	}
2363 
2364 	function log(bool p0, uint256 p1, bool p2, uint256 p3) internal view {
2365 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,uint256)", p0, p1, p2, p3));
2366 	}
2367 
2368 	function log(bool p0, uint256 p1, bool p2, string memory p3) internal view {
2369 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,string)", p0, p1, p2, p3));
2370 	}
2371 
2372 	function log(bool p0, uint256 p1, bool p2, bool p3) internal view {
2373 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,bool)", p0, p1, p2, p3));
2374 	}
2375 
2376 	function log(bool p0, uint256 p1, bool p2, address p3) internal view {
2377 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,address)", p0, p1, p2, p3));
2378 	}
2379 
2380 	function log(bool p0, uint256 p1, address p2, uint256 p3) internal view {
2381 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,uint256)", p0, p1, p2, p3));
2382 	}
2383 
2384 	function log(bool p0, uint256 p1, address p2, string memory p3) internal view {
2385 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,string)", p0, p1, p2, p3));
2386 	}
2387 
2388 	function log(bool p0, uint256 p1, address p2, bool p3) internal view {
2389 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,bool)", p0, p1, p2, p3));
2390 	}
2391 
2392 	function log(bool p0, uint256 p1, address p2, address p3) internal view {
2393 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,address)", p0, p1, p2, p3));
2394 	}
2395 
2396 	function log(bool p0, string memory p1, uint256 p2, uint256 p3) internal view {
2397 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,uint256)", p0, p1, p2, p3));
2398 	}
2399 
2400 	function log(bool p0, string memory p1, uint256 p2, string memory p3) internal view {
2401 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,string)", p0, p1, p2, p3));
2402 	}
2403 
2404 	function log(bool p0, string memory p1, uint256 p2, bool p3) internal view {
2405 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,bool)", p0, p1, p2, p3));
2406 	}
2407 
2408 	function log(bool p0, string memory p1, uint256 p2, address p3) internal view {
2409 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,address)", p0, p1, p2, p3));
2410 	}
2411 
2412 	function log(bool p0, string memory p1, string memory p2, uint256 p3) internal view {
2413 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint256)", p0, p1, p2, p3));
2414 	}
2415 
2416 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2417 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2418 	}
2419 
2420 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2421 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2422 	}
2423 
2424 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2425 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2426 	}
2427 
2428 	function log(bool p0, string memory p1, bool p2, uint256 p3) internal view {
2429 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint256)", p0, p1, p2, p3));
2430 	}
2431 
2432 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2433 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2434 	}
2435 
2436 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2437 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2438 	}
2439 
2440 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2441 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2442 	}
2443 
2444 	function log(bool p0, string memory p1, address p2, uint256 p3) internal view {
2445 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint256)", p0, p1, p2, p3));
2446 	}
2447 
2448 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2449 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2450 	}
2451 
2452 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2453 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2454 	}
2455 
2456 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2457 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2458 	}
2459 
2460 	function log(bool p0, bool p1, uint256 p2, uint256 p3) internal view {
2461 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,uint256)", p0, p1, p2, p3));
2462 	}
2463 
2464 	function log(bool p0, bool p1, uint256 p2, string memory p3) internal view {
2465 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,string)", p0, p1, p2, p3));
2466 	}
2467 
2468 	function log(bool p0, bool p1, uint256 p2, bool p3) internal view {
2469 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,bool)", p0, p1, p2, p3));
2470 	}
2471 
2472 	function log(bool p0, bool p1, uint256 p2, address p3) internal view {
2473 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,address)", p0, p1, p2, p3));
2474 	}
2475 
2476 	function log(bool p0, bool p1, string memory p2, uint256 p3) internal view {
2477 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint256)", p0, p1, p2, p3));
2478 	}
2479 
2480 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2481 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2482 	}
2483 
2484 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2485 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2486 	}
2487 
2488 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2489 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2490 	}
2491 
2492 	function log(bool p0, bool p1, bool p2, uint256 p3) internal view {
2493 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint256)", p0, p1, p2, p3));
2494 	}
2495 
2496 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2497 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2498 	}
2499 
2500 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2501 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2502 	}
2503 
2504 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2505 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2506 	}
2507 
2508 	function log(bool p0, bool p1, address p2, uint256 p3) internal view {
2509 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint256)", p0, p1, p2, p3));
2510 	}
2511 
2512 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2513 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2514 	}
2515 
2516 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2517 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2518 	}
2519 
2520 	function log(bool p0, bool p1, address p2, address p3) internal view {
2521 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2522 	}
2523 
2524 	function log(bool p0, address p1, uint256 p2, uint256 p3) internal view {
2525 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,uint256)", p0, p1, p2, p3));
2526 	}
2527 
2528 	function log(bool p0, address p1, uint256 p2, string memory p3) internal view {
2529 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,string)", p0, p1, p2, p3));
2530 	}
2531 
2532 	function log(bool p0, address p1, uint256 p2, bool p3) internal view {
2533 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,bool)", p0, p1, p2, p3));
2534 	}
2535 
2536 	function log(bool p0, address p1, uint256 p2, address p3) internal view {
2537 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,address)", p0, p1, p2, p3));
2538 	}
2539 
2540 	function log(bool p0, address p1, string memory p2, uint256 p3) internal view {
2541 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint256)", p0, p1, p2, p3));
2542 	}
2543 
2544 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2545 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2546 	}
2547 
2548 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2549 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2550 	}
2551 
2552 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2553 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2554 	}
2555 
2556 	function log(bool p0, address p1, bool p2, uint256 p3) internal view {
2557 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint256)", p0, p1, p2, p3));
2558 	}
2559 
2560 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2561 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2562 	}
2563 
2564 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2565 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2566 	}
2567 
2568 	function log(bool p0, address p1, bool p2, address p3) internal view {
2569 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2570 	}
2571 
2572 	function log(bool p0, address p1, address p2, uint256 p3) internal view {
2573 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint256)", p0, p1, p2, p3));
2574 	}
2575 
2576 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2577 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2578 	}
2579 
2580 	function log(bool p0, address p1, address p2, bool p3) internal view {
2581 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2582 	}
2583 
2584 	function log(bool p0, address p1, address p2, address p3) internal view {
2585 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2586 	}
2587 
2588 	function log(address p0, uint256 p1, uint256 p2, uint256 p3) internal view {
2589 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,uint256)", p0, p1, p2, p3));
2590 	}
2591 
2592 	function log(address p0, uint256 p1, uint256 p2, string memory p3) internal view {
2593 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,string)", p0, p1, p2, p3));
2594 	}
2595 
2596 	function log(address p0, uint256 p1, uint256 p2, bool p3) internal view {
2597 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,bool)", p0, p1, p2, p3));
2598 	}
2599 
2600 	function log(address p0, uint256 p1, uint256 p2, address p3) internal view {
2601 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,address)", p0, p1, p2, p3));
2602 	}
2603 
2604 	function log(address p0, uint256 p1, string memory p2, uint256 p3) internal view {
2605 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,uint256)", p0, p1, p2, p3));
2606 	}
2607 
2608 	function log(address p0, uint256 p1, string memory p2, string memory p3) internal view {
2609 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,string)", p0, p1, p2, p3));
2610 	}
2611 
2612 	function log(address p0, uint256 p1, string memory p2, bool p3) internal view {
2613 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,bool)", p0, p1, p2, p3));
2614 	}
2615 
2616 	function log(address p0, uint256 p1, string memory p2, address p3) internal view {
2617 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,address)", p0, p1, p2, p3));
2618 	}
2619 
2620 	function log(address p0, uint256 p1, bool p2, uint256 p3) internal view {
2621 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,uint256)", p0, p1, p2, p3));
2622 	}
2623 
2624 	function log(address p0, uint256 p1, bool p2, string memory p3) internal view {
2625 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,string)", p0, p1, p2, p3));
2626 	}
2627 
2628 	function log(address p0, uint256 p1, bool p2, bool p3) internal view {
2629 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,bool)", p0, p1, p2, p3));
2630 	}
2631 
2632 	function log(address p0, uint256 p1, bool p2, address p3) internal view {
2633 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,address)", p0, p1, p2, p3));
2634 	}
2635 
2636 	function log(address p0, uint256 p1, address p2, uint256 p3) internal view {
2637 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,uint256)", p0, p1, p2, p3));
2638 	}
2639 
2640 	function log(address p0, uint256 p1, address p2, string memory p3) internal view {
2641 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,string)", p0, p1, p2, p3));
2642 	}
2643 
2644 	function log(address p0, uint256 p1, address p2, bool p3) internal view {
2645 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,bool)", p0, p1, p2, p3));
2646 	}
2647 
2648 	function log(address p0, uint256 p1, address p2, address p3) internal view {
2649 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,address)", p0, p1, p2, p3));
2650 	}
2651 
2652 	function log(address p0, string memory p1, uint256 p2, uint256 p3) internal view {
2653 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,uint256)", p0, p1, p2, p3));
2654 	}
2655 
2656 	function log(address p0, string memory p1, uint256 p2, string memory p3) internal view {
2657 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,string)", p0, p1, p2, p3));
2658 	}
2659 
2660 	function log(address p0, string memory p1, uint256 p2, bool p3) internal view {
2661 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,bool)", p0, p1, p2, p3));
2662 	}
2663 
2664 	function log(address p0, string memory p1, uint256 p2, address p3) internal view {
2665 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,address)", p0, p1, p2, p3));
2666 	}
2667 
2668 	function log(address p0, string memory p1, string memory p2, uint256 p3) internal view {
2669 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint256)", p0, p1, p2, p3));
2670 	}
2671 
2672 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2673 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2674 	}
2675 
2676 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2677 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2678 	}
2679 
2680 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2681 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2682 	}
2683 
2684 	function log(address p0, string memory p1, bool p2, uint256 p3) internal view {
2685 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint256)", p0, p1, p2, p3));
2686 	}
2687 
2688 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2689 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2690 	}
2691 
2692 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2693 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2694 	}
2695 
2696 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2697 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2698 	}
2699 
2700 	function log(address p0, string memory p1, address p2, uint256 p3) internal view {
2701 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint256)", p0, p1, p2, p3));
2702 	}
2703 
2704 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2705 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2706 	}
2707 
2708 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2709 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2710 	}
2711 
2712 	function log(address p0, string memory p1, address p2, address p3) internal view {
2713 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2714 	}
2715 
2716 	function log(address p0, bool p1, uint256 p2, uint256 p3) internal view {
2717 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,uint256)", p0, p1, p2, p3));
2718 	}
2719 
2720 	function log(address p0, bool p1, uint256 p2, string memory p3) internal view {
2721 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,string)", p0, p1, p2, p3));
2722 	}
2723 
2724 	function log(address p0, bool p1, uint256 p2, bool p3) internal view {
2725 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,bool)", p0, p1, p2, p3));
2726 	}
2727 
2728 	function log(address p0, bool p1, uint256 p2, address p3) internal view {
2729 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,address)", p0, p1, p2, p3));
2730 	}
2731 
2732 	function log(address p0, bool p1, string memory p2, uint256 p3) internal view {
2733 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint256)", p0, p1, p2, p3));
2734 	}
2735 
2736 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2737 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2738 	}
2739 
2740 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2741 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2742 	}
2743 
2744 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2745 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2746 	}
2747 
2748 	function log(address p0, bool p1, bool p2, uint256 p3) internal view {
2749 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint256)", p0, p1, p2, p3));
2750 	}
2751 
2752 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2753 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2754 	}
2755 
2756 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2757 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2758 	}
2759 
2760 	function log(address p0, bool p1, bool p2, address p3) internal view {
2761 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2762 	}
2763 
2764 	function log(address p0, bool p1, address p2, uint256 p3) internal view {
2765 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint256)", p0, p1, p2, p3));
2766 	}
2767 
2768 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2769 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2770 	}
2771 
2772 	function log(address p0, bool p1, address p2, bool p3) internal view {
2773 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2774 	}
2775 
2776 	function log(address p0, bool p1, address p2, address p3) internal view {
2777 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2778 	}
2779 
2780 	function log(address p0, address p1, uint256 p2, uint256 p3) internal view {
2781 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,uint256)", p0, p1, p2, p3));
2782 	}
2783 
2784 	function log(address p0, address p1, uint256 p2, string memory p3) internal view {
2785 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,string)", p0, p1, p2, p3));
2786 	}
2787 
2788 	function log(address p0, address p1, uint256 p2, bool p3) internal view {
2789 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,bool)", p0, p1, p2, p3));
2790 	}
2791 
2792 	function log(address p0, address p1, uint256 p2, address p3) internal view {
2793 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,address)", p0, p1, p2, p3));
2794 	}
2795 
2796 	function log(address p0, address p1, string memory p2, uint256 p3) internal view {
2797 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint256)", p0, p1, p2, p3));
2798 	}
2799 
2800 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2801 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2802 	}
2803 
2804 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2805 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2806 	}
2807 
2808 	function log(address p0, address p1, string memory p2, address p3) internal view {
2809 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2810 	}
2811 
2812 	function log(address p0, address p1, bool p2, uint256 p3) internal view {
2813 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint256)", p0, p1, p2, p3));
2814 	}
2815 
2816 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2817 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2818 	}
2819 
2820 	function log(address p0, address p1, bool p2, bool p3) internal view {
2821 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2822 	}
2823 
2824 	function log(address p0, address p1, bool p2, address p3) internal view {
2825 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2826 	}
2827 
2828 	function log(address p0, address p1, address p2, uint256 p3) internal view {
2829 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint256)", p0, p1, p2, p3));
2830 	}
2831 
2832 	function log(address p0, address p1, address p2, string memory p3) internal view {
2833 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2834 	}
2835 
2836 	function log(address p0, address p1, address p2, bool p3) internal view {
2837 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2838 	}
2839 
2840 	function log(address p0, address p1, address p2, address p3) internal view {
2841 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2842 	}
2843 
2844 }
2845 
2846 // File: contracts/38_EmpireAirdrop.sol
2847 
2848 
2849 pragma solidity 0.8.19;
2850 
2851 
2852 
2853 
2854 
2855 
2856 
2857 
2858 
2859 contract EmpireAirdrop is Context, Ownable, ReentrancyGuard {
2860     using SafeERC20 for IERC20;
2861     IERC20 public EMPIRE_TOKEN;
2862 
2863     bytes32 public root;
2864 
2865     mapping(address => bool) public hasClaimed;
2866 
2867     constructor(address empire_token_address, bytes32 _root) {
2868         EMPIRE_TOKEN = ERC20(empire_token_address);
2869         root = _root;
2870     }
2871 
2872     /**
2873      * @dev If msg.sender() has been whitelisted, he can call this method to claim the amount of EMPIRE 
2874        set by admin for this msg.sender() to claim
2875      */
2876     function claim(bytes32[] memory proof, uint _amount)public nonReentrant {
2877         require(!hasClaimed[msg.sender], "User has already claimed!");
2878         require(isWhitelisted(proof, keccak256(abi.encodePacked(msg.sender, _amount))), "User not whitelisted OR Incorrect amount!");
2879         hasClaimed[msg.sender] = true;
2880         EMPIRE_TOKEN.transfer(msg.sender, _amount);
2881     }
2882 
2883     /**
2884      * @dev The owner can call this method to withdraw the EMPIRE tokens depoisted in this contract. Only the owner can call this method
2885      */
2886     function emergencyWithdraw(uint256 amount) external onlyOwner {
2887         uint256 token_balance = EMPIRE_TOKEN.balanceOf(address(this));
2888         require (amount <= token_balance, "Amount exceeds balance");
2889 
2890         EMPIRE_TOKEN.transfer(msg.sender, amount);
2891     }
2892 
2893     function isWhitelisted(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
2894         return MerkleProof.verify(proof, root, leaf);
2895     }
2896 
2897     function setRoot(bytes32 _root) external onlyOwner {
2898         root = _root;
2899     }
2900 
2901     function setHasClaimed(address _user, bool _hasClaimed) external onlyOwner {
2902         hasClaimed[_user] = _hasClaimed;
2903     }
2904 }