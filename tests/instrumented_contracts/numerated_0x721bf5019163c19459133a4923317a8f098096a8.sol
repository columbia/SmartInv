1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.17 <0.9.0;
3 
4 //import "../utils/Context.sol";
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 //import "@openzeppelin/contracts/access/Ownable.sol";
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor(address initialOwner) {
48         _transferOwnership(initialOwner);
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         _checkOwner();
56         _;
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if the sender is not the owner.
68      */
69     function _checkOwner() internal view virtual {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 
105 //import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
106 /**
107  * @dev Contract module that helps prevent reentrant calls to a function.
108  *
109  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
110  * available, which can be applied to functions to make sure there are no nested
111  * (reentrant) calls to them.
112  *
113  * Note that because there is a single `nonReentrant` guard, functions marked as
114  * `nonReentrant` may not call one another. This can be worked around by making
115  * those functions `private`, and then adding `external` `nonReentrant` entry
116  * points to them.
117  *
118  * TIP: If you would like to learn more about reentrancy and alternative ways
119  * to protect against it, check out our blog post
120  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
121  */
122 abstract contract ReentrancyGuard {
123     // Booleans are more expensive than uint256 or any type that takes up a full
124     // word because each write operation emits an extra SLOAD to first read the
125     // slot's contents, replace the bits taken up by the boolean, and then write
126     // back. This is the compiler's defense against contract upgrades and
127     // pointer aliasing, and it cannot be disabled.
128 
129     // The values being non-zero value makes deployment a bit more expensive,
130     // but in exchange the refund on every call to nonReentrant will be lower in
131     // amount. Since refunds are capped to a percentage of the total
132     // transaction's gas, it is best to keep them low in cases like this one, to
133     // increase the likelihood of the full refund coming into effect.
134     uint256 private constant _NOT_ENTERED = 1;
135     uint256 private constant _ENTERED = 2;
136 
137     uint256 private _status;
138 
139     constructor() {
140         _status = _NOT_ENTERED;
141     }
142 
143     /**
144      * @dev Prevents a contract from calling itself, directly or indirectly.
145      * Calling a `nonReentrant` function from another `nonReentrant`
146      * function is not supported. It is possible to prevent this from happening
147      * by making the `nonReentrant` function external, and making it call a
148      * `private` function that does the actual work.
149      */
150     modifier nonReentrant() {
151         _nonReentrantBefore();
152         _;
153         _nonReentrantAfter();
154     }
155 
156     function _nonReentrantBefore() private {
157         // On the first call to nonReentrant, _status will be _NOT_ENTERED
158         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
159 
160         // Any calls to nonReentrant after this point will fail
161         _status = _ENTERED;
162     }
163 
164     function _nonReentrantAfter() private {
165         // By storing the original value once again, a refund is triggered (see
166         // https://eips.ethereum.org/EIPS/eip-2200)
167         _status = _NOT_ENTERED;
168     }
169 }
170 
171 
172 //import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
173 /**
174  * @dev These functions deal with verification of Merkle Tree proofs.
175  *
176  * The tree and the proofs can be generated using our
177  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
178  * You will find a quickstart guide in the readme.
179  *
180  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
181  * hashing, or use a hash function other than keccak256 for hashing leaves.
182  * This is because the concatenation of a sorted pair of internal nodes in
183  * the merkle tree could be reinterpreted as a leaf value.
184  * OpenZeppelin's JavaScript library generates merkle trees that are safe
185  * against this attack out of the box.
186  */
187 library MerkleProof {
188     /**
189      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
190      * defined by `root`. For this, a `proof` must be provided, containing
191      * sibling hashes on the branch from the leaf to the root of the tree. Each
192      * pair of leaves and each pair of pre-images are assumed to be sorted.
193      */
194     function verify(
195         bytes32[] memory proof,
196         bytes32 root,
197         bytes32 leaf
198     ) internal pure returns (bool) {
199         return processProof(proof, leaf) == root;
200     }
201 
202     /**
203      * @dev Calldata version of {verify}
204      *
205      * _Available since v4.7._
206      */
207     function verifyCalldata(
208         bytes32[] calldata proof,
209         bytes32 root,
210         bytes32 leaf
211     ) internal pure returns (bool) {
212         return processProofCalldata(proof, leaf) == root;
213     }
214 
215     /**
216      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
217      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
218      * hash matches the root of the tree. When processing the proof, the pairs
219      * of leafs & pre-images are assumed to be sorted.
220      *
221      * _Available since v4.4._
222      */
223     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
224         bytes32 computedHash = leaf;
225         for (uint256 i = 0; i < proof.length; i++) {
226             computedHash = _hashPair(computedHash, proof[i]);
227         }
228         return computedHash;
229     }
230 
231     /**
232      * @dev Calldata version of {processProof}
233      *
234      * _Available since v4.7._
235      */
236     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
237         bytes32 computedHash = leaf;
238         for (uint256 i = 0; i < proof.length; i++) {
239             computedHash = _hashPair(computedHash, proof[i]);
240         }
241         return computedHash;
242     }
243 
244     /**
245      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
246      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
247      *
248      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
249      *
250      * _Available since v4.7._
251      */
252     function multiProofVerify(
253         bytes32[] memory proof,
254         bool[] memory proofFlags,
255         bytes32 root,
256         bytes32[] memory leaves
257     ) internal pure returns (bool) {
258         return processMultiProof(proof, proofFlags, leaves) == root;
259     }
260 
261     /**
262      * @dev Calldata version of {multiProofVerify}
263      *
264      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
265      *
266      * _Available since v4.7._
267      */
268     function multiProofVerifyCalldata(
269         bytes32[] calldata proof,
270         bool[] calldata proofFlags,
271         bytes32 root,
272         bytes32[] memory leaves
273     ) internal pure returns (bool) {
274         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
275     }
276 
277     /**
278      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
279      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
280      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
281      * respectively.
282      *
283      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
284      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
285      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
286      *
287      * _Available since v4.7._
288      */
289     function processMultiProof(
290         bytes32[] memory proof,
291         bool[] memory proofFlags,
292         bytes32[] memory leaves
293     ) internal pure returns (bytes32 merkleRoot) {
294         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
295         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
296         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
297         // the merkle tree.
298         uint256 leavesLen = leaves.length;
299         uint256 totalHashes = proofFlags.length;
300 
301         // Check proof validity.
302         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
303 
304         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
305         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
306         bytes32[] memory hashes = new bytes32[](totalHashes);
307         uint256 leafPos = 0;
308         uint256 hashPos = 0;
309         uint256 proofPos = 0;
310         // At each step, we compute the next hash using two values:
311         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
312         //   get the next hash.
313         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
314         //   `proof` array.
315         for (uint256 i = 0; i < totalHashes; i++) {
316             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
317             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
318             hashes[i] = _hashPair(a, b);
319         }
320 
321         if (totalHashes > 0) {
322             return hashes[totalHashes - 1];
323         } else if (leavesLen > 0) {
324             return leaves[0];
325         } else {
326             return proof[0];
327         }
328     }
329 
330     /**
331      * @dev Calldata version of {processMultiProof}.
332      *
333      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
334      *
335      * _Available since v4.7._
336      */
337     function processMultiProofCalldata(
338         bytes32[] calldata proof,
339         bool[] calldata proofFlags,
340         bytes32[] memory leaves
341     ) internal pure returns (bytes32 merkleRoot) {
342         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
343         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
344         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
345         // the merkle tree.
346         uint256 leavesLen = leaves.length;
347         uint256 totalHashes = proofFlags.length;
348 
349         // Check proof validity.
350         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
351 
352         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
353         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
354         bytes32[] memory hashes = new bytes32[](totalHashes);
355         uint256 leafPos = 0;
356         uint256 hashPos = 0;
357         uint256 proofPos = 0;
358         // At each step, we compute the next hash using two values:
359         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
360         //   get the next hash.
361         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
362         //   `proof` array.
363         for (uint256 i = 0; i < totalHashes; i++) {
364             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
365             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
366             hashes[i] = _hashPair(a, b);
367         }
368 
369         if (totalHashes > 0) {
370             return hashes[totalHashes - 1];
371         } else if (leavesLen > 0) {
372             return leaves[0];
373         } else {
374             return proof[0];
375         }
376     }
377 
378     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
379         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
380     }
381 
382     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
383         /// @solidity memory-safe-assembly
384         assembly {
385             mstore(0x00, a)
386             mstore(0x20, b)
387             value := keccak256(0x00, 0x40)
388         }
389     }
390 }
391 
392 
393 //import "@openzeppelin/contracts/utils/Address.sol";
394 
395 /**
396  * @dev Collection of functions related to the address type
397  */
398 library Address {
399     /**
400      * @dev Returns true if `account` is a contract.
401      *
402      * [IMPORTANT]
403      * ====
404      * It is unsafe to assume that an address for which this function returns
405      * false is an externally-owned account (EOA) and not a contract.
406      *
407      * Among others, `isContract` will return false for the following
408      * types of addresses:
409      *
410      *  - an externally-owned account
411      *  - a contract in construction
412      *  - an address where a contract will be created
413      *  - an address where a contract lived, but was destroyed
414      * ====
415      *
416      * [IMPORTANT]
417      * ====
418      * You shouldn't rely on `isContract` to protect against flash loan attacks!
419      *
420      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
421      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
422      * constructor.
423      * ====
424      */
425     function isContract(address account) internal view returns (bool) {
426         // This method relies on extcodesize/address.code.length, which returns 0
427         // for contracts in construction, since the code is only stored at the end
428         // of the constructor execution.
429 
430         return account.code.length > 0;
431     }
432 
433     /**
434      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
435      * `recipient`, forwarding all available gas and reverting on errors.
436      *
437      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
438      * of certain opcodes, possibly making contracts go over the 2300 gas limit
439      * imposed by `transfer`, making them unable to receive funds via
440      * `transfer`. {sendValue} removes this limitation.
441      *
442      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
443      *
444      * IMPORTANT: because control is transferred to `recipient`, care must be
445      * taken to not create reentrancy vulnerabilities. Consider using
446      * {ReentrancyGuard} or the
447      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
448      */
449     function sendValue(address payable recipient, uint256 amount) internal {
450         require(address(this).balance >= amount, "Address: insufficient balance");
451 
452         (bool success, ) = recipient.call{value: amount}("");
453         require(success, "Address: unable to send value, recipient may have reverted");
454     }
455 
456     /**
457      * @dev Performs a Solidity function call using a low level `call`. A
458      * plain `call` is an unsafe replacement for a function call: use this
459      * function instead.
460      *
461      * If `target` reverts with a revert reason, it is bubbled up by this
462      * function (like regular Solidity function calls).
463      *
464      * Returns the raw returned data. To convert to the expected return value,
465      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
466      *
467      * Requirements:
468      *
469      * - `target` must be a contract.
470      * - calling `target` with `data` must not revert.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
480      * `errorMessage` as a fallback revert reason when `target` reverts.
481      *
482      * _Available since v3.1._
483      */
484     function functionCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         return functionCallWithValue(target, data, 0, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but also transferring `value` wei to `target`.
495      *
496      * Requirements:
497      *
498      * - the calling contract must have an ETH balance of at least `value`.
499      * - the called Solidity function must be `payable`.
500      *
501      * _Available since v3.1._
502      */
503     function functionCallWithValue(
504         address target,
505         bytes memory data,
506         uint256 value
507     ) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
513      * with `errorMessage` as a fallback revert reason when `target` reverts.
514      *
515      * _Available since v3.1._
516      */
517     function functionCallWithValue(
518         address target,
519         bytes memory data,
520         uint256 value,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(address(this).balance >= value, "Address: insufficient balance for call");
524         (bool success, bytes memory returndata) = target.call{value: value}(data);
525         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
530      * but performing a static call.
531      *
532      * _Available since v3.3._
533      */
534     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
535         return functionStaticCall(target, data, "Address: low-level static call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal view returns (bytes memory) {
549         (bool success, bytes memory returndata) = target.staticcall(data);
550         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but performing a delegate call.
556      *
557      * _Available since v3.4._
558      */
559     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
560         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a delegate call.
566      *
567      * _Available since v3.4._
568      */
569     function functionDelegateCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         (bool success, bytes memory returndata) = target.delegatecall(data);
575         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
580      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
581      *
582      * _Available since v4.8._
583      */
584     function verifyCallResultFromTarget(
585         address target,
586         bool success,
587         bytes memory returndata,
588         string memory errorMessage
589     ) internal view returns (bytes memory) {
590         if (success) {
591             if (returndata.length == 0) {
592                 // only check isContract if the call was successful and the return data is empty
593                 // otherwise we already know that it was a contract
594                 require(isContract(target), "Address: call to non-contract");
595             }
596             return returndata;
597         } else {
598             _revert(returndata, errorMessage);
599         }
600     }
601 
602     /**
603      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
604      * revert reason or using the provided one.
605      *
606      * _Available since v4.3._
607      */
608     function verifyCallResult(
609         bool success,
610         bytes memory returndata,
611         string memory errorMessage
612     ) internal pure returns (bytes memory) {
613         if (success) {
614             return returndata;
615         } else {
616             _revert(returndata, errorMessage);
617         }
618     }
619 
620     function _revert(bytes memory returndata, string memory errorMessage) private pure {
621         // Look for revert reason and bubble it up if present
622         if (returndata.length > 0) {
623             // The easiest way to bubble the revert reason is using memory via assembly
624             /// @solidity memory-safe-assembly
625             assembly {
626                 let returndata_size := mload(returndata)
627                 revert(add(32, returndata), returndata_size)
628             }
629         } else {
630             revert(errorMessage);
631         }
632     }
633 }
634 
635 
636 //import "./Common/IMintable.sol";
637 //--------------------------------------------
638 // Mintable intterface
639 //--------------------------------------------
640 interface IMintable {
641     //----------------
642     // write
643     //----------------
644     function mintByMinter( address to, uint256 tokenId ) external;
645 }
646 
647 
648 //------------------------------------------------------------
649 // Vendor
650 //------------------------------------------------------------
651 contract Vendor is Ownable, ReentrancyGuard {
652     //--------------------------------------------------------
653     // constants
654     //--------------------------------------------------------
655     address constant private OWNER_ADDRESS = 0xc78b8E9f12EDbc74A708F9B5A0472B33b3B286ce;
656     address constant private TOKEN_ADDRESS = 0x0BdA9d7185A9885eCb1770d4793389bE5DA2e576;
657 
658     address constant private CREATOR_ADDRESS_0 = 0xc78b8E9f12EDbc74A708F9B5A0472B33b3B286ce;
659     uint256 constant private CREATOR_FEE_WEIGHT_0 = 875;    // 87.5%
660 
661     address constant private CREATOR_ADDRESS_1 = 0xFe2875DcACD1D92Ca755C0a3DEF4a8debd970643;
662     uint256 constant private CREATOR_FEE_WEIGHT_1 = 125;    // 12.5%
663 
664     uint256 constant private COLOR_NUM = 10;
665     uint256 constant private BLOCK_SEC_MARGIN = 30;
666 
667     // enum
668     uint256 constant private INFO_SALE_SUSPENDED = 0;
669     uint256 constant private INFO_SALE_START = 1;
670     uint256 constant private INFO_SALE_END = 2;
671     uint256 constant private INFO_SALE_PRICE = 3;
672     uint256 constant private INFO_SALE_USER_MAX_IF_WHITELISTED = 4;
673     uint256 constant private INFO_SALE_USER_MINTABLE = 5;
674     uint256 constant private INFO_SALE_USER_MINTED = 6;
675     uint256 constant private INFO_SALE_USER_LIMIT = 7;
676     uint256 constant private INFO_MAX = 8;
677 
678     uint256 constant private USER_INFO_SALE_TYPE = INFO_MAX;
679     uint256 constant private USER_INFO_USER_MAX = INFO_MAX + 1;
680     uint256 constant private USER_INFO_USER_MINTED = INFO_MAX + 2;
681     uint256 constant private USER_INFO_TOKEN_MAX = INFO_MAX + 3;
682     uint256 constant private USER_INFO_TOTAL_MINTED = INFO_MAX + 4;
683     uint256 constant private USER_INFO_TOKEN_MAX_PER_COLOR = INFO_MAX + 5;
684     uint256 constant private USER_INFO_COLOR_MINTED = INFO_MAX + 6;
685     uint256 constant private USER_INFO_MAX = USER_INFO_COLOR_MINTED + COLOR_NUM;
686 
687     //--------------------------------------------------------
688     // storage
689     //--------------------------------------------------------
690     address private _manager;
691 
692     IMintable private _token;
693     uint256 private _token_id_ofs;
694     uint256 private _token_max;
695     uint256 private _token_max_per_color;
696     uint256 private _token_max_per_user;
697     bytes32 private _token_max_per_user_merkle_root;
698     uint256 private _token_reserved;
699     uint256[COLOR_NUM] private _arr_token_reserved;
700 
701     uint256 private _total_minted;
702     uint256[COLOR_NUM] private _arr_color_minted;
703 
704     //*** PRIVATE(whitelist) ***
705     bool private _PRIVATE_is_suspended;
706     uint256 private _PRIVATE_start;
707     uint256 private _PRIVATE_end;
708     uint256 private _PRIVATE_price;
709     bytes32 private _PRIVATE_merkle_root;
710     mapping( address => uint256 ) private _PRIVATE_map_user_minted;
711 
712     //~~~ PARTNER(whitelist) ~~~
713     bool private _PARTNER_is_suspended;
714     uint256 private _PARTNER_start;
715     uint256 private _PARTNER_end;
716     uint256 private _PARTNER_price;
717     bytes32 private _PARTNER_merkle_root;
718     mapping( address => uint256 ) private _PARTNER_map_user_minted;
719 
720     //=== PUBLIC ===
721     bool private _PUBLIC_is_suspended;
722     uint256 private _PUBLIC_start;
723     uint256 private _PUBLIC_end;
724     uint256 private _PUBLIC_price;
725     mapping( address => uint256 ) private _PUBLIC_map_user_minted;
726 
727     //+++ CREATOR +++
728     address[] private _arr_creator;
729     uint256[] private _arr_creator_fee_weight;
730 
731     //--------------------------------------------------------
732     // [modifier] onlyOwnerOrManager
733     //--------------------------------------------------------
734     modifier onlyOwnerOrManager() {
735         require( msg.sender == owner() || msg.sender == manager(), "caller is not the owner neither manager" );
736         _;
737     }
738 
739     //--------------------------------------------------------
740     // constructor
741     //--------------------------------------------------------
742     constructor() Ownable( OWNER_ADDRESS ) {
743         _manager = msg.sender;
744 
745         _token = IMintable(TOKEN_ADDRESS);
746 
747         _arr_creator.push( CREATOR_ADDRESS_0 );
748         _arr_creator_fee_weight.push( CREATOR_FEE_WEIGHT_0 );
749 
750         _arr_creator.push( CREATOR_ADDRESS_1 );
751         _arr_creator_fee_weight.push( CREATOR_FEE_WEIGHT_1 );
752 
753         //-----------------------
754         // setting
755         //-----------------------
756         _token_id_ofs = 1;
757         _token_max = 5000;
758         _token_max_per_color = 500;
759         _token_max_per_user = 5;
760         _token_max_per_user_merkle_root = 0x3e22812f090c3a2e3417d065aabd382839f0f3d8f9ee6895a0f588d20eeeedf8;
761         for( uint256 i=0; i<COLOR_NUM; i++ ){
762             _arr_token_reserved[i] = 41;
763             _token_reserved += _arr_token_reserved[i];
764         }
765 
766         //***********************
767         // PRIVATE(whitelist)
768         //***********************
769         _PRIVATE_start = 1677042000;               // 2023-02-22 14:00:00(JST)
770         _PRIVATE_end   = 1677214800;               // 2023-02-24 14:00:00(JST)
771         _PRIVATE_price = 70000000000000000;        // 0.07 ETH
772         _PRIVATE_merkle_root = 0xbca758ea3d259685add3babb2992029e0eceea0add5fa292b5485b98b5e5d528;
773         
774         //~~~~~~~~~~~~~~~~~~~~~~~
775         // PARTNER(whitelist)
776         //~~~~~~~~~~~~~~~~~~~~~~~
777         _PARTNER_start = 1677214800;               // 2023-02-24 14:00:00(JST)
778         _PARTNER_end   = 1677301200;               // 2023-02-25 14:00:00(JST)
779         _PARTNER_price = 70000000000000000;        // 0.07 ETH
780         _PARTNER_merkle_root = 0x5f10da6422d0a2ed2a29460dcea08d42790d53cf339e6c347f48e6d109da6ed1;
781 
782         //=======================
783         // PUBLIC
784         //=======================
785         _PUBLIC_start = 1677301200;                 // 2023-02-25 14:00:00(JST)
786         _PUBLIC_end   = 1677387600;                 // 2023-02-26 14:00:00(JST)
787         _PUBLIC_price = 70000000000000000;          // 0.07 ETH
788     }
789 
790     //--------------------------------------------------------
791     // [public] manager
792     //--------------------------------------------------------
793     function manager() public view returns (address) {
794         return( _manager );
795     }
796 
797     //--------------------------------------------------------
798     // [external/onlyOwner] setManager
799     //--------------------------------------------------------
800     function setManager( address target ) external onlyOwner {
801         _manager = target;
802     }
803 
804     //--------------------------------------------------------
805     // [external] get
806     //--------------------------------------------------------
807     function token() external view returns (address) { return( address(_token) ); }
808     function tokenIdOfs() external view returns (uint256) { return( _token_id_ofs ); }
809     function tokenMax() external view returns (uint256) { return( _token_max ); }
810     function tokenMaxPerColor() external view returns (uint256) { return( _token_max_per_color ); }
811     function tokenMaxPerUser() external view returns (uint256) { return( _token_max_per_user ); }
812     function tokenMaxPerUserMerkleRoot() external view returns (bytes32) { return( _token_max_per_user_merkle_root ); }
813     function tokenReserved() external view returns (uint256) { return( _token_reserved ); }
814     function tokenReservedAt( uint256 colorId ) external view returns (uint256) { return( _arr_token_reserved[colorId] ); }
815 
816     function totalMinted() external view returns (uint256) { return( _total_minted ); }
817     function colorMintedAt( uint256 colorId ) external view returns (uint256) { return( _arr_color_minted[colorId] ); }
818     function userMinted( address target ) external view returns (uint256) { return( _getUserMinted( target ) ); }
819 
820     //--------------------------------------------------------
821     // [external/onlyOwnerOrManager] set
822     //--------------------------------------------------------
823     function setToken( address target ) external onlyOwnerOrManager { _token = IMintable(target); }
824     function setTokenIdOfs( uint256 ofs ) external onlyOwnerOrManager { _token_id_ofs = ofs; }
825     function setTokenMax( uint256 max ) external onlyOwnerOrManager { _token_max = max; }
826     function setTokenMaxPerColor( uint256 max ) external onlyOwnerOrManager { _token_max_per_color = max; }
827     function setTokenMaxPerUser( uint256 max ) external onlyOwnerOrManager { _token_max_per_user = max; }
828     function setTokenMaxPerUserMerkleRoot( bytes32 root ) external onlyOwnerOrManager { _token_max_per_user_merkle_root = root; }
829     function setTokenReserved( uint256[COLOR_NUM] calldata arrReserved ) external onlyOwnerOrManager {
830         _token_reserved = 0;
831         for( uint256 i=0; i<COLOR_NUM; i++ ){
832             require( arrReserved[i] <= _token_max_per_color && arrReserved[i] >= _arr_color_minted[i], "invalid arrReserved" );
833             _arr_token_reserved[i] = arrReserved[i];
834             _token_reserved += _arr_token_reserved[i];
835         }
836 
837         require( _token_reserved <= _token_max, "invalid arrReserved total" );
838     }
839 
840     //***********************************************************
841     // [public] getInfo - PRIVATE(whitelist)
842     //***********************************************************
843     function PRIVATE_getInfo( address target, uint256 amount, bytes32[] calldata merkleProof, uint256 amountMax, bytes32[] calldata merkleProofMax ) public view returns (uint256[INFO_MAX] memory) {
844         uint256[INFO_MAX] memory arrRet;
845 
846         if( _PRIVATE_is_suspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
847         arrRet[INFO_SALE_START] = _PRIVATE_start;
848         arrRet[INFO_SALE_END] = _PRIVATE_end;
849         arrRet[INFO_SALE_PRICE] = _PRIVATE_price;
850         if( _checkWhitelisted( _PRIVATE_merkle_root, target, amount, merkleProof ) ){
851             arrRet[INFO_SALE_USER_MAX_IF_WHITELISTED] = _checkMintMaxOfUser( target, amountMax, merkleProofMax );
852             arrRet[INFO_SALE_USER_MINTABLE] = amount;
853         }
854         arrRet[INFO_SALE_USER_MINTED] = _PRIVATE_map_user_minted[target];
855         arrRet[INFO_SALE_USER_LIMIT] = _checkUserLimit( target, arrRet[INFO_SALE_USER_MINTABLE], arrRet[INFO_SALE_USER_MAX_IF_WHITELISTED] );
856 
857         return( arrRet );
858     }
859 
860     //***********************************************************
861     // [external/onlyOwnerOrManager] write - PRIVATE(whitelist)
862     //***********************************************************
863     function PRIVATE_suspend( bool flag ) external onlyOwnerOrManager { _PRIVATE_is_suspended = flag; }
864     function PRIVATE_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager { _PRIVATE_start = start; _PRIVATE_end = end; }
865     function PRIVATE_setPrice( uint256 price ) external onlyOwnerOrManager { _PRIVATE_price = price; }
866     function PRIVATE_setMerkleRoot( bytes32 root ) external onlyOwnerOrManager { _PRIVATE_merkle_root = root; }
867 
868     //***********************************************************
869     // [external/payable/nonReentrant] mint - PRIVATE(whitelist)
870     //***********************************************************
871     function PRIVATE_mint( uint256[] calldata colorIds, uint256[] calldata nums, uint256 amount, bytes32[] calldata merkleProof, uint256 amountMax, bytes32[] calldata merkleProofMax ) external payable nonReentrant {
872         require( _total_minted >= _token_reserved, "PRIVATE SALE: reservation not finished" );
873 
874         uint256[INFO_MAX] memory arrInfo = PRIVATE_getInfo( msg.sender, amount, merkleProof, amountMax, merkleProofMax );
875         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "PRIVATE SALE: suspended" );
876         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "PRIVATE SALE: not opend" );
877         require( arrInfo[INFO_SALE_END] == 0 || (arrInfo[INFO_SALE_END]+BLOCK_SEC_MARGIN) > block.timestamp, "PRIVATE SALE: finished" );
878         require( arrInfo[INFO_SALE_USER_MAX_IF_WHITELISTED] > 0, "PRIVATE SALE: not whitelisted" );
879 
880         require( colorIds.length == nums.length, "PRIVATE SALE: invalid array sizes" );
881         uint256 num;
882         for( uint256 i=0; i<nums.length; i++ ){ num += nums[i]; }
883         require( arrInfo[INFO_SALE_USER_MINTABLE] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "PRIVATE SALE: reached the sale limit" );
884         require( arrInfo[INFO_SALE_USER_LIMIT] >= num, "PRIVATE SALE: reached the user limit" );
885 
886         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
887 
888         _PRIVATE_map_user_minted[msg.sender] += num;
889         for( uint256 i=0; i<colorIds.length; i++ ){
890             _mintTokens( msg.sender, colorIds[i], nums[i] );
891         }
892     }
893 
894     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
895     // [public] getInfo - PARTNER
896     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
897     function PARTNER_getInfo( address target, uint256 amount, bytes32[] calldata merkleProof, uint256 amountMax, bytes32[] calldata merkleProofMax ) public view returns (uint256[INFO_MAX] memory) {
898         uint256[INFO_MAX] memory arrRet;
899 
900         if( _PARTNER_is_suspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
901         arrRet[INFO_SALE_START] = _PARTNER_start;
902         arrRet[INFO_SALE_END] = _PARTNER_end;
903         arrRet[INFO_SALE_PRICE] = _PARTNER_price;
904         if( _checkWhitelisted( _PARTNER_merkle_root, target, amount, merkleProof ) ){
905             arrRet[INFO_SALE_USER_MAX_IF_WHITELISTED] = _checkMintMaxOfUser( target, amountMax, merkleProofMax );
906             arrRet[INFO_SALE_USER_MINTABLE] = amount;
907         }
908         arrRet[INFO_SALE_USER_MINTED] = _PARTNER_map_user_minted[target];
909         arrRet[INFO_SALE_USER_LIMIT] = _checkUserLimit( target, arrRet[INFO_SALE_USER_MINTABLE], arrRet[INFO_SALE_USER_MAX_IF_WHITELISTED] );
910 
911         return( arrRet );
912     }
913 
914     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
915     // [external/onlyOwnerOrManager] write - PARTNER
916     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
917     function PARTNER_suspend( bool flag ) external onlyOwnerOrManager { _PARTNER_is_suspended = flag; }
918     function PARTNER_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager { _PARTNER_start = start; _PARTNER_end = end; }
919     function PARTNER_setPrice( uint256 price ) external onlyOwnerOrManager { _PARTNER_price = price; }
920     function PARTNER_setMerkleRoot( bytes32 root ) external onlyOwnerOrManager { _PARTNER_merkle_root = root; }
921 
922     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
923     // [external/payable/nonReentrant] mint - PARTNER(whitelist)
924     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
925     function PARTNER_mint( uint256[] calldata colorIds, uint256[] calldata nums, uint256 amount, bytes32[] calldata merkleProof, uint256 amountMax, bytes32[] calldata merkleProofMax ) external payable nonReentrant {
926         require( _total_minted >= _token_reserved, "PARTNER SALE: reservation not finished" );
927 
928         uint256[INFO_MAX] memory arrInfo = PARTNER_getInfo( msg.sender, amount, merkleProof, amountMax, merkleProofMax );
929         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "PARTNER SALE: suspended" );
930         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "PARTNER SALE: not opend" );
931         require( arrInfo[INFO_SALE_END] == 0 || (arrInfo[INFO_SALE_END]+BLOCK_SEC_MARGIN) > block.timestamp, "PARTNER SALE: finished" );
932         require( arrInfo[INFO_SALE_USER_MAX_IF_WHITELISTED] > 0, "PARTNER SALE: not whitelisted" );
933 
934         require( colorIds.length == nums.length, "PARTNER SALE: invalid array sizes" );
935         uint256 num;
936         for( uint256 i=0; i<nums.length; i++ ){ num += nums[i]; }
937         require( arrInfo[INFO_SALE_USER_MINTABLE] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "PARTNER SALE: reached the sale limit" );
938         require( arrInfo[INFO_SALE_USER_LIMIT] >= num, "PARTNER SALE: reached the user limit" );
939 
940         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
941 
942         _PARTNER_map_user_minted[msg.sender] += num;
943         for( uint256 i=0; i<colorIds.length; i++ ){
944             _mintTokens( msg.sender, colorIds[i], nums[i] );
945         }
946     }
947 
948     //===========================================================
949     // [public] getInfo - PUBLIC
950     //===========================================================
951     function PUBLIC_getInfo( address target, uint256 amountMax, bytes32[] calldata merkleProofMax ) public view returns (uint256[INFO_MAX] memory) {
952         uint256[INFO_MAX] memory arrRet;
953 
954         if( _PUBLIC_is_suspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
955         arrRet[INFO_SALE_START] = _PUBLIC_start;
956         arrRet[INFO_SALE_END] = _PUBLIC_end;
957         arrRet[INFO_SALE_PRICE] = _PUBLIC_price;
958         arrRet[INFO_SALE_USER_MAX_IF_WHITELISTED] = _checkMintMaxOfUser( target, amountMax, merkleProofMax );
959         arrRet[INFO_SALE_USER_MINTABLE] = arrRet[INFO_SALE_USER_MAX_IF_WHITELISTED];
960         arrRet[INFO_SALE_USER_MINTED] = _PUBLIC_map_user_minted[target];
961         arrRet[INFO_SALE_USER_LIMIT] = _checkUserLimit( target, arrRet[INFO_SALE_USER_MINTABLE], arrRet[INFO_SALE_USER_MAX_IF_WHITELISTED] );
962 
963         return( arrRet );
964     }
965 
966     //===========================================================
967     // [external/onlyOwnerOrManager] write - PUBLIC
968     //===========================================================
969     function PUBLIC_suspend( bool flag ) external onlyOwnerOrManager { _PUBLIC_is_suspended = flag; }
970     function PUBLIC_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager { _PUBLIC_start = start; _PUBLIC_end = end; }
971     function PUBLIC_setPrice( uint256 price ) external onlyOwnerOrManager { _PUBLIC_price = price; }
972 
973     //===========================================================
974     // [external/payable/nonReentrant] mint - PUBLIC
975     //===========================================================
976     function PUBLIC_mint( uint256[] calldata colorIds, uint256[] calldata nums, uint256 amountMax, bytes32[] calldata merkleProofMax ) external payable nonReentrant {
977         require( _total_minted >= _token_reserved, "PUBLIC SALE: reservation not finished" );
978 
979         uint256[INFO_MAX] memory arrInfo = PUBLIC_getInfo( msg.sender, amountMax, merkleProofMax );
980         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "PUBLIC SALE: suspended" );
981         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "PUBLIC SALE: not opend" );
982         require( arrInfo[INFO_SALE_END] == 0 || (arrInfo[INFO_SALE_END]+BLOCK_SEC_MARGIN) > block.timestamp, "PUBLIC SALE: finished" );
983 
984         require( colorIds.length == nums.length, "PUBLIC SALE: invalid array sizes" );
985         uint256 num;
986         for( uint256 i=0; i<nums.length; i++ ){ num += nums[i]; }
987         require( arrInfo[INFO_SALE_USER_MINTABLE] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "PUBLIC SALE: reached the sale limit" );
988         require( arrInfo[INFO_SALE_USER_LIMIT] >= num, "PUBLIC SALE: reached the user limit" );
989 
990         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
991 
992         _PUBLIC_map_user_minted[msg.sender] += num;
993         for( uint256 i=0; i<colorIds.length; i++ ){
994             _mintTokens( msg.sender, colorIds[i], nums[i] );
995         }
996     }
997 
998     //--------------------------------------------------------
999     // [internal] _getUserMinted
1000     //--------------------------------------------------------
1001     function _getUserMinted( address target ) internal view returns (uint256) {
1002         uint256 total;
1003         total += _PRIVATE_map_user_minted[target];
1004         total += _PARTNER_map_user_minted[target];
1005         total += _PUBLIC_map_user_minted[target];
1006         return( total );
1007     }
1008 
1009     //--------------------------------------------------------
1010     // [internal] _checkUserLimit
1011     //--------------------------------------------------------
1012     function _checkUserLimit( address target, uint256 num, uint256 userMax ) internal view returns (uint256) {
1013         uint256 total = _getUserMinted( target );
1014         if( total >= userMax ){
1015             return( 0 );
1016         }
1017 
1018         uint256 rest = userMax - total;
1019         if( num > rest ){
1020             return( rest );
1021         }
1022         return( num );
1023     }    
1024 
1025     //--------------------------------------------------------
1026     // [internal] _checkWhitelisted
1027     //--------------------------------------------------------
1028     function _checkWhitelisted( bytes32 merkleRoot, address target, uint256 amount, bytes32[] calldata merkleProof ) internal pure returns (bool) {
1029         bytes32 node = keccak256( abi.encodePacked( target, amount ) );
1030         if( MerkleProof.verify( merkleProof, merkleRoot, node ) ){
1031             return( true );
1032         }
1033         return( false );
1034     }
1035 
1036     //--------------------------------------------------------
1037     // [internal] _checkMintMaxOfUser
1038     //--------------------------------------------------------
1039     function _checkMintMaxOfUser( address target, uint256 amountMax, bytes32[] calldata merkleProofMax ) internal view returns (uint256) {
1040         bytes32 node = keccak256( abi.encodePacked( target, amountMax ) );
1041         if( MerkleProof.verify( merkleProofMax, _token_max_per_user_merkle_root, node ) ){
1042             return( amountMax );
1043         }
1044         return( _token_max_per_user );
1045     }
1046 
1047     //--------------------------------------------------------
1048     // [internal] _checkPayment
1049     //--------------------------------------------------------
1050     function _checkPayment( address msgSender, uint256 price, uint256 payment ) internal {
1051         require( price <= payment, "insufficient value" );
1052 
1053         // refund if overpaymented
1054         if( price < payment ){
1055             uint256 change = payment - price;
1056             address payable target = payable( msgSender );
1057             Address.sendValue( target, change );
1058         }
1059     }
1060 
1061     //--------------------------------------------------------
1062     // [internal] _mintTokens
1063     //--------------------------------------------------------
1064     function _mintTokens( address to, uint256 colorId, uint256 num ) internal {
1065         require( colorId < COLOR_NUM, "_mintTokens: invalid colorId" );
1066         require( _token_max >= (_total_minted+num), "_mintTokens: reached the supply range" );
1067         require( _token_max_per_color >= (_arr_color_minted[colorId]+num), "_mintTokens: reached the color range" );
1068 
1069         uint256 tokenId = _token_id_ofs + colorId*_token_max_per_color + _arr_color_minted[colorId];
1070 
1071         _total_minted += num;
1072         _arr_color_minted[colorId] += num;
1073         for( uint256 i=0; i<num; i++ ){
1074             _token.mintByMinter( to, tokenId+i );
1075         }
1076     }
1077 
1078     //--------------------------------------------------------
1079     // [external/onlyOwnerOrManager] reserveTokens
1080     //--------------------------------------------------------
1081     function reserveTokens( uint256 num ) external onlyOwnerOrManager {
1082         require( _token_reserved >= (_total_minted+num), "reserveTokens: exceeded the reservation range" );
1083 
1084         uint256 colorId = 0;
1085         while( num > 0 && colorId < COLOR_NUM ){
1086             if( _arr_token_reserved[colorId] > _arr_color_minted[colorId] ){
1087                 uint256 colorNum = _arr_token_reserved[colorId] - _arr_color_minted[colorId];
1088                 if( num < colorNum ){
1089                     colorNum = num;
1090                 }
1091 
1092                 _mintTokens( owner(), colorId, colorNum );
1093                 num -= colorNum;
1094             }
1095             colorId++;
1096         }
1097     }
1098 
1099     //--------------------------------------------------------
1100     // [external] getUserInfo
1101     //--------------------------------------------------------
1102     function getUserInfo( address target, uint256 amountPrivate, bytes32[] calldata merkleProofPrivate, uint256 amountPartner, bytes32[] calldata merkleProofPartner, uint256 amountMax, bytes32[] calldata merkleProofMax ) external view returns (uint256[USER_INFO_MAX] memory) {
1103         uint256[USER_INFO_MAX] memory userInfo;
1104         uint256[INFO_MAX] memory info;
1105 
1106         // PRIVATE(whitelist)
1107         if( (_PRIVATE_end == 0 || _PRIVATE_end > (block.timestamp+BLOCK_SEC_MARGIN/2)) && _checkWhitelisted( _PRIVATE_merkle_root, target, amountPrivate, merkleProofPrivate ) ){
1108             userInfo[USER_INFO_SALE_TYPE] = 1;
1109             info = PRIVATE_getInfo( target, amountPrivate, merkleProofPrivate, amountMax, merkleProofMax );
1110         }
1111         // PARTNER(whitelist)
1112         else if( (_PARTNER_end == 0 || _PARTNER_end > (block.timestamp+BLOCK_SEC_MARGIN/2)) && _checkWhitelisted( _PARTNER_merkle_root, target, amountPartner, merkleProofPartner ) ){
1113             userInfo[USER_INFO_SALE_TYPE] = 2;
1114             info = PARTNER_getInfo( target, amountPartner, merkleProofPartner, amountMax, merkleProofMax );
1115         }
1116         // PUBLIC
1117         else{
1118             userInfo[USER_INFO_SALE_TYPE] = 3;
1119             info = PUBLIC_getInfo( target, amountMax, merkleProofMax );            
1120         }
1121 
1122         for( uint256 i=0; i<INFO_MAX; i++ ){
1123             userInfo[i] = info[i];
1124         }
1125 
1126         // fix: userInfo[INFO_SALE_USER_MAX_IF_WHITELISTED] has the total mintable number, if the user is whitelisted.
1127         if( userInfo[INFO_SALE_USER_MAX_IF_WHITELISTED] > 0 ){
1128             userInfo[USER_INFO_USER_MAX] = userInfo[INFO_SALE_USER_MAX_IF_WHITELISTED]; // save the value
1129             userInfo[INFO_SALE_USER_MAX_IF_WHITELISTED] = 1;    // treated as a flag
1130         }
1131 
1132         userInfo[USER_INFO_USER_MINTED] = _getUserMinted( target );
1133         userInfo[USER_INFO_TOKEN_MAX] = _token_max;
1134         userInfo[USER_INFO_TOTAL_MINTED] = _total_minted;
1135         userInfo[USER_INFO_TOKEN_MAX_PER_COLOR] = _token_max_per_color;
1136         for( uint256 i=0; i<COLOR_NUM; i++ ){
1137             userInfo[USER_INFO_COLOR_MINTED+i] = _arr_color_minted[i];
1138         }
1139 
1140         return( userInfo );
1141     }
1142 
1143     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1144     // [external] getBalance
1145     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1146     function getBalance() external view returns (uint256) {
1147         return( address(this).balance );
1148     }
1149 
1150     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1151     // [external] getCreatorInfo
1152     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1153     function getCreatorInfo() external view returns (address[] memory, uint256[] memory) {
1154         return( _arr_creator, _arr_creator_fee_weight );
1155     }
1156 
1157     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1158     // [external/onlyOwnerOrManager] addCreator
1159     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1160     function addCreator( address creator, uint256 weight ) external onlyOwnerOrManager {
1161         require( creator != address(0x0), "addCreator: invalid address" );
1162         require( weight > 0, "addCreator: invalid weight" );
1163 
1164         for( uint256 i=0; i<_arr_creator.length; i++ ){
1165             if( _arr_creator[i] == creator ){
1166                 _arr_creator_fee_weight[i] = weight;
1167                 return;
1168             }
1169         }
1170 
1171         _arr_creator.push( creator );
1172         _arr_creator_fee_weight.push( weight );
1173     }
1174 
1175     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1176     // [external/onlyOwnerOrManager] deleteCreator
1177     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1178     function deleteCreator( address creator ) external onlyOwnerOrManager {
1179         for( uint256 i=0; i<_arr_creator.length; i++ ){
1180             if( _arr_creator[i] == creator ){
1181                 for( uint256 j=i+1; j<_arr_creator.length; j++ ){
1182                     _arr_creator[j-1] = _arr_creator[j];
1183                     _arr_creator_fee_weight[j-1] = _arr_creator_fee_weight[j];
1184                 }
1185 
1186                 _arr_creator.pop();
1187                 _arr_creator_fee_weight.pop();
1188                 return;
1189             }
1190         }
1191     }
1192 
1193     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1194     // [external/onlyOwnerOrManager] withdraw
1195     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1196     function withdraw( uint256 amount ) external onlyOwnerOrManager{
1197         require( amount <= address(this).balance, "withdraw: insufficient balance" );
1198         require( _arr_creator.length > 0, "withdraw: no creator" );
1199 
1200         uint256 total;
1201         for( uint256 i=0; i<_arr_creator.length; i++ ){
1202             total += _arr_creator_fee_weight[i];
1203         }
1204 
1205         address payable target;
1206         for( uint256 i=1; i<_arr_creator.length; i++ ){
1207             uint256 temp = amount * _arr_creator_fee_weight[i] / total;
1208             target = payable( _arr_creator[i] );
1209             Address.sendValue( target, temp );
1210             amount -= temp;
1211         }
1212 
1213         target = payable( _arr_creator[0] );
1214         Address.sendValue( target, amount );
1215     }
1216 
1217 }