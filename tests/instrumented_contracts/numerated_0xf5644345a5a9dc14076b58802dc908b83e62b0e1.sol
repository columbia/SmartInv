1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 
25 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
26 
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         _checkOwner();
57         _;
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if the sender is not the owner.
69      */
70     function _checkOwner() internal view virtual {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 
106 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.0
107 
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP.
111  */
112 interface IERC20 {
113     /**
114      * @dev Emitted when `value` tokens are moved from one account (`from`) to
115      * another (`to`).
116      *
117      * Note that `value` may be zero.
118      */
119     event Transfer(address indexed from, address indexed to, uint256 value);
120 
121     /**
122      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
123      * a call to {approve}. `value` is the new allowance.
124      */
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 
127     /**
128      * @dev Returns the amount of tokens in existence.
129      */
130     function totalSupply() external view returns (uint256);
131 
132     /**
133      * @dev Returns the amount of tokens owned by `account`.
134      */
135     function balanceOf(address account) external view returns (uint256);
136 
137     /**
138      * @dev Moves `amount` tokens from the caller's account to `to`.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transfer(address to, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Returns the remaining number of tokens that `spender` will be
148      * allowed to spend on behalf of `owner` through {transferFrom}. This is
149      * zero by default.
150      *
151      * This value changes when {approve} or {transferFrom} are called.
152      */
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     /**
156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
161      * that someone may use both the old and the new allowance by unfortunate
162      * transaction ordering. One possible solution to mitigate this race
163      * condition is to first reduce the spender's allowance to 0 and set the
164      * desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      *
167      * Emits an {Approval} event.
168      */
169     function approve(address spender, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Moves `amount` tokens from `from` to `to` using the
173      * allowance mechanism. `amount` is then deducted from the caller's
174      * allowance.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(
181         address from,
182         address to,
183         uint256 amount
184     ) external returns (bool);
185 }
186 
187 
188 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.8.0
189 
190 
191 /**
192  * @dev These functions deal with verification of Merkle Tree proofs.
193  *
194  * The tree and the proofs can be generated using our
195  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
196  * You will find a quickstart guide in the readme.
197  *
198  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
199  * hashing, or use a hash function other than keccak256 for hashing leaves.
200  * This is because the concatenation of a sorted pair of internal nodes in
201  * the merkle tree could be reinterpreted as a leaf value.
202  * OpenZeppelin's JavaScript library generates merkle trees that are safe
203  * against this attack out of the box.
204  */
205 library MerkleProof {
206     /**
207      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
208      * defined by `root`. For this, a `proof` must be provided, containing
209      * sibling hashes on the branch from the leaf to the root of the tree. Each
210      * pair of leaves and each pair of pre-images are assumed to be sorted.
211      */
212     function verify(
213         bytes32[] memory proof,
214         bytes32 root,
215         bytes32 leaf
216     ) internal pure returns (bool) {
217         return processProof(proof, leaf) == root;
218     }
219 
220     /**
221      * @dev Calldata version of {verify}
222      *
223      * _Available since v4.7._
224      */
225     function verifyCalldata(
226         bytes32[] calldata proof,
227         bytes32 root,
228         bytes32 leaf
229     ) internal pure returns (bool) {
230         return processProofCalldata(proof, leaf) == root;
231     }
232 
233     /**
234      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
235      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
236      * hash matches the root of the tree. When processing the proof, the pairs
237      * of leafs & pre-images are assumed to be sorted.
238      *
239      * _Available since v4.4._
240      */
241     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
242         bytes32 computedHash = leaf;
243         for (uint256 i = 0; i < proof.length; i++) {
244             computedHash = _hashPair(computedHash, proof[i]);
245         }
246         return computedHash;
247     }
248 
249     /**
250      * @dev Calldata version of {processProof}
251      *
252      * _Available since v4.7._
253      */
254     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
255         bytes32 computedHash = leaf;
256         for (uint256 i = 0; i < proof.length; i++) {
257             computedHash = _hashPair(computedHash, proof[i]);
258         }
259         return computedHash;
260     }
261 
262     /**
263      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
264      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
265      *
266      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
267      *
268      * _Available since v4.7._
269      */
270     function multiProofVerify(
271         bytes32[] memory proof,
272         bool[] memory proofFlags,
273         bytes32 root,
274         bytes32[] memory leaves
275     ) internal pure returns (bool) {
276         return processMultiProof(proof, proofFlags, leaves) == root;
277     }
278 
279     /**
280      * @dev Calldata version of {multiProofVerify}
281      *
282      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
283      *
284      * _Available since v4.7._
285      */
286     function multiProofVerifyCalldata(
287         bytes32[] calldata proof,
288         bool[] calldata proofFlags,
289         bytes32 root,
290         bytes32[] memory leaves
291     ) internal pure returns (bool) {
292         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
293     }
294 
295     /**
296      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
297      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
298      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
299      * respectively.
300      *
301      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
302      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
303      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
304      *
305      * _Available since v4.7._
306      */
307     function processMultiProof(
308         bytes32[] memory proof,
309         bool[] memory proofFlags,
310         bytes32[] memory leaves
311     ) internal pure returns (bytes32 merkleRoot) {
312         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
313         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
314         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
315         // the merkle tree.
316         uint256 leavesLen = leaves.length;
317         uint256 totalHashes = proofFlags.length;
318 
319         // Check proof validity.
320         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
321 
322         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
323         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
324         bytes32[] memory hashes = new bytes32[](totalHashes);
325         uint256 leafPos = 0;
326         uint256 hashPos = 0;
327         uint256 proofPos = 0;
328         // At each step, we compute the next hash using two values:
329         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
330         //   get the next hash.
331         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
332         //   `proof` array.
333         for (uint256 i = 0; i < totalHashes; i++) {
334             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
335             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
336             hashes[i] = _hashPair(a, b);
337         }
338 
339         if (totalHashes > 0) {
340             return hashes[totalHashes - 1];
341         } else if (leavesLen > 0) {
342             return leaves[0];
343         } else {
344             return proof[0];
345         }
346     }
347 
348     /**
349      * @dev Calldata version of {processMultiProof}.
350      *
351      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
352      *
353      * _Available since v4.7._
354      */
355     function processMultiProofCalldata(
356         bytes32[] calldata proof,
357         bool[] calldata proofFlags,
358         bytes32[] memory leaves
359     ) internal pure returns (bytes32 merkleRoot) {
360         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
361         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
362         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
363         // the merkle tree.
364         uint256 leavesLen = leaves.length;
365         uint256 totalHashes = proofFlags.length;
366 
367         // Check proof validity.
368         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
369 
370         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
371         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
372         bytes32[] memory hashes = new bytes32[](totalHashes);
373         uint256 leafPos = 0;
374         uint256 hashPos = 0;
375         uint256 proofPos = 0;
376         // At each step, we compute the next hash using two values:
377         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
378         //   get the next hash.
379         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
380         //   `proof` array.
381         for (uint256 i = 0; i < totalHashes; i++) {
382             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
383             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
384             hashes[i] = _hashPair(a, b);
385         }
386 
387         if (totalHashes > 0) {
388             return hashes[totalHashes - 1];
389         } else if (leavesLen > 0) {
390             return leaves[0];
391         } else {
392             return proof[0];
393         }
394     }
395 
396     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
397         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
398     }
399 
400     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
401         /// @solidity memory-safe-assembly
402         assembly {
403             mstore(0x00, a)
404             mstore(0x20, b)
405             value := keccak256(0x00, 0x40)
406         }
407     }
408 }
409 
410 
411 // File contracts/Merkle.sol
412 
413 
414 
415 
416 contract Merkle is Ownable {
417     using MerkleProof for bytes32[];
418 
419     event Claim(address indexed account, bytes32 leaf, uint amount);
420 
421     IERC20 public immutable token;
422     bytes32 public immutable root;
423     uint public immutable salt;
424     mapping(bytes32 => bool) private _claimed;
425 
426     constructor(IERC20 _token, bytes32 _root, uint _salt) {
427         token = _token;
428         root = _root;
429         salt = _salt;
430     }
431 
432     function _getLeaf(address account, uint amount) private view returns (bytes32) {
433         return keccak256(abi.encodePacked(account, amount, salt));
434     }
435 
436     function claimed(address account, uint amount) external view returns (bool) {
437         bytes32 leaf = _getLeaf(account, amount);
438         return _claimed[leaf];
439     }
440 
441     function claim(address account, uint amount, bytes32[] calldata proof) external {
442         require(account != address(0), "account = zero address");
443         require(amount != 0, "amount = 0");
444 
445         bytes32 leaf = _getLeaf(account, amount);
446         require(!_claimed[leaf], "claimed");
447         require(proof.verify(root, leaf), "invalid proof");
448 
449         _claimed[leaf] = true;
450 
451         token.transfer(account, amount);
452 
453         emit Claim(account, leaf, amount);
454     }
455 
456     function withdraw() external onlyOwner {
457         token.transfer(msg.sender, token.balanceOf(address(this)));
458     }
459 }