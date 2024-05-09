1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 /*
9 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 @@@@@@@@@::;:;;:;;::;::;;:;::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
11 @@@@@@@@@::::::::::::::::::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 @@@@@@@@@::::::::::::::::::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@r@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 @@@@@@+:.::::::::::::::::::::.:+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 @@@@@@::::::::::,,,,,,,,,,,,::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 @@@@@@::::::::::,,,,,,,,,,,,::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
16 @@@@@@::::::::::,,,,,,,,,,,,::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
17 @@;::::::::::,,,,,,,,,,,,,,,,:::::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
18 @@:::::::::::,,,,,,,,,,,,,,,,,,,:::;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@h@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a@@@@@@@@@@
19 @@:::::::::::,,,,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@::::@@@@@@
20 @@::::::::::,,,,,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@::::::@@@@@::::::@@@@@@::::::::@@@@@@::::::@@@@:::::::::::::::::::::@::::::::::::@@@@@@@@::::::::::@@@
21 @@:::::::::::,,,,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@:::::::@@@@::::::@@@@@:::::::::@@@@@@::::::@@@;::::::.::::::::::::::@::::::::::::::@@@@@::::::::::::@@
22 @@:::::::::::,,,,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@:::::::;@@@::::::@@@@@:::::::::@@@@@@::::::@@.::::::.@::::::::::::::@:::::::::::::::@@@::::::::::::::@
23 @@::::::::::,,,,,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@::::::::@@@::::::@@@@@::::::::::@@@@@::::::@@:::::::@@::::::::::::::@:::::::::::::::.@::::::::::::::::
24 @@:::::::::::,,,,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@:::::::::@@::::::@@@@:::::::::::@@@@@::::::@:::::::@@@:::::::::::::;.::::::::::::::::@:::::::;::::::::
25 @@:::::::::::,,,,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@:::::::::;@::::::@@@@:::::::::::@@@@@:::::::::::::@@@@::::::*@@@@@@@.::::::@@@:::::::@:::::::@@@::::::
26 @@:::::::::::,,,,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@::::::::::@::::::@@@@::::::::::::@@@@::::::::::::+@@@@:::::::::::::@.::::::@@@@::::::.::::::::::;@@@@@
27 @@::::::::::::::,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@:::::::::::::::::@@@::::::@::::::@@@@::::::::::::@@@@@:::::::::::::@.::::::@@@@::::::::::::::::::::;@@
28 @@@:::::::::::::,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@:::::::::::::::::@@@::::::@::::::@@@@::::::::::::@@@@@:::::::::::::@.::::::@@@@:::::::@::::::::::::::@
29 ::::::::::::::::,,,,,,,,,,,,,,,:::::@@@@@@@@@@@@:::::::::::::::::@@@::::::@;:::::;@@@::::::::::::.@@@@:::::::::::::@.::::::@@@@:::::::@@::::::::::::::
30 :::,,,,:::::::::,,,,,,,,,,,,::::::::@@@@@@@@@@@@:::::::::::::::::@@:::::::::::::::@@@:::::::::::::@@@@:::::::::::::@.::::::@@@@:::::::@@@+::::::::::::
31 :::,,,,:::::::::,,,,,,,,,,,,::::::::@@@@@@@@@@@@:::::::;:::::::::@@:::::::::::::::@@@:::::::::::::;@@@:::::::@@@@@@@.::::::@@@@::::::...@@@@@:::::::::
32 :::,,,,:::::::::,,,,,,,,,,,,::::::::@@@@@@@@@@@@:::::::@:::::::::@@::::::::::::::::@@::::::::::::::@@@:::::::@@@@@@@.::::::@@;:::::::@::::::@@@@::::::
33 ::::,,::::::::::,,,,,,,,,,,,::::::::@@@@@@@@@@@@:::::::@@::::::::@:::::::::::::::::@@::::::@*:::::::@@:::::::::::::;.::::::::::::::::@::::::::::::::::
34 ::::,:::::::::::,,,,,,,,,,,,::::::::@@@@@@@@@@@@:::::::@@::::::::@:::::::::::::::::@@::::::@@:::::::;@::::::::::::::@:::::::::::::::@@::::::::::::::::
35 ::::::::::::::::,,,,,,,,,,,,::::::::@@@@@@@@@@@@:::::::@@@:::::::@::::::@@@@@:::::::@::::::@@@:::::::@::::::::::::::@::::::::::::::@@@@::::::::::::::@
36 ::::::::::::::::,,,,,,,,,,,,,,,:::::@@@@@@@@@@@@:::::::@@@@:::::::::::::@@@@@:::::::@::::::@@@::::::::::::::::::::::@:::::::::::::@@@@@@::::::::::::@@
37 @@,:::::::::::::,,,,,,,,,,,,,,,,::::@@@@@@@@@@@@;::::::@@@@*::::::::::::@@@@@+::::::@::::::@@@@:::::::::::::::::::::@:::::::::::@@@@@@@@@:::::::::;@@@
38 @@::::::::::::::o,,,,,,,,,,,,,,,::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
39 @@.::::::::::::::,:,,,,,,,,,:::::::.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
40 @@@@@@:::::::::::::,,,,,,,,,::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@r@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
41 @@@@@@:::::::::::::,,,,,,,,,::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
42 @@@@@@::::::::::::::::::::::::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
43 @@@@@@@@@::::::::::::::::::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
44 @@@@@@@@@::::::::::::::::::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
45 @@@@@@@@@:::::::::::::s::::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
46 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
47 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
48 
49 */
50 /**
51  * @dev These functions deal with verification of Merkle Tree proofs.
52  *
53  * The proofs can be generated using the JavaScript library
54  * https://github.com/miguelmota/merkletreejs[merkletreejs].
55  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
56  *
57  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
58  *
59  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
60  * hashing, or use a hash function other than keccak256 for hashing leaves.
61  * This is because the concatenation of a sorted pair of internal nodes in
62  * the merkle tree could be reinterpreted as a leaf value.
63  */
64 library MerkleProof {
65     /**
66      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
67      * defined by `root`. For this, a `proof` must be provided, containing
68      * sibling hashes on the branch from the leaf to the root of the tree. Each
69      * pair of leaves and each pair of pre-images are assumed to be sorted.
70      */
71     function verify(
72         bytes32[] memory proof,
73         bytes32 root,
74         bytes32 leaf
75     ) internal pure returns (bool) {
76         return processProof(proof, leaf) == root;
77     }
78 
79     /**
80      * @dev Calldata version of {verify}
81      *
82      * _Available since v4.7._
83      */
84     function verifyCalldata(
85         bytes32[] calldata proof,
86         bytes32 root,
87         bytes32 leaf
88     ) internal pure returns (bool) {
89         return processProofCalldata(proof, leaf) == root;
90     }
91 
92     /**
93      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
94      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
95      * hash matches the root of the tree. When processing the proof, the pairs
96      * of leafs & pre-images are assumed to be sorted.
97      *
98      * _Available since v4.4._
99      */
100     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
101         bytes32 computedHash = leaf;
102         for (uint256 i = 0; i < proof.length; i++) {
103             computedHash = _hashPair(computedHash, proof[i]);
104         }
105         return computedHash;
106     }
107 
108     /**
109      * @dev Calldata version of {processProof}
110      *
111      * _Available since v4.7._
112      */
113     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
114         bytes32 computedHash = leaf;
115         for (uint256 i = 0; i < proof.length; i++) {
116             computedHash = _hashPair(computedHash, proof[i]);
117         }
118         return computedHash;
119     }
120 
121     /**
122      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
123      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
124      *
125      * _Available since v4.7._
126      */
127     function multiProofVerify(
128         bytes32[] memory proof,
129         bool[] memory proofFlags,
130         bytes32 root,
131         bytes32[] memory leaves
132     ) internal pure returns (bool) {
133         return processMultiProof(proof, proofFlags, leaves) == root;
134     }
135 
136     /**
137      * @dev Calldata version of {multiProofVerify}
138      *
139      * _Available since v4.7._
140      */
141     function multiProofVerifyCalldata(
142         bytes32[] calldata proof,
143         bool[] calldata proofFlags,
144         bytes32 root,
145         bytes32[] memory leaves
146     ) internal pure returns (bool) {
147         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
148     }
149 
150     /**
151      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
152      * consuming from one or the other at each step according to the instructions given by
153      * `proofFlags`.
154      *
155      * _Available since v4.7._
156      */
157     function processMultiProof(
158         bytes32[] memory proof,
159         bool[] memory proofFlags,
160         bytes32[] memory leaves
161     ) internal pure returns (bytes32 merkleRoot) {
162         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
163         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
164         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
165         // the merkle tree.
166         uint256 leavesLen = leaves.length;
167         uint256 totalHashes = proofFlags.length;
168 
169         // Check proof validity.
170         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
171 
172         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
173         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
174         bytes32[] memory hashes = new bytes32[](totalHashes);
175         uint256 leafPos = 0;
176         uint256 hashPos = 0;
177         uint256 proofPos = 0;
178         // At each step, we compute the next hash using two values:
179         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
180         //   get the next hash.
181         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
182         //   `proof` array.
183         for (uint256 i = 0; i < totalHashes; i++) {
184             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
185             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
186             hashes[i] = _hashPair(a, b);
187         }
188 
189         if (totalHashes > 0) {
190             return hashes[totalHashes - 1];
191         } else if (leavesLen > 0) {
192             return leaves[0];
193         } else {
194             return proof[0];
195         }
196     }
197 
198     /**
199      * @dev Calldata version of {processMultiProof}
200      *
201      * _Available since v4.7._
202      */
203     function processMultiProofCalldata(
204         bytes32[] calldata proof,
205         bool[] calldata proofFlags,
206         bytes32[] memory leaves
207     ) internal pure returns (bytes32 merkleRoot) {
208         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
209         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
210         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
211         // the merkle tree.
212         uint256 leavesLen = leaves.length;
213         uint256 totalHashes = proofFlags.length;
214 
215         // Check proof validity.
216         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
217 
218         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
219         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
220         bytes32[] memory hashes = new bytes32[](totalHashes);
221         uint256 leafPos = 0;
222         uint256 hashPos = 0;
223         uint256 proofPos = 0;
224         // At each step, we compute the next hash using two values:
225         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
226         //   get the next hash.
227         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
228         //   `proof` array.
229         for (uint256 i = 0; i < totalHashes; i++) {
230             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
231             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
232             hashes[i] = _hashPair(a, b);
233         }
234 
235         if (totalHashes > 0) {
236             return hashes[totalHashes - 1];
237         } else if (leavesLen > 0) {
238             return leaves[0];
239         } else {
240             return proof[0];
241         }
242     }
243 
244     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
245         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
246     }
247 
248     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
249         /// @solidity memory-safe-assembly
250         assembly {
251             mstore(0x00, a)
252             mstore(0x20, b)
253             value := keccak256(0x00, 0x40)
254         }
255     }
256 }
257 
258 // File: contracts/Nakeds.sol
259 
260 
261 // HI OS 01.06.2022
262 
263 pragma solidity ^0.8.4;
264 
265 /**
266  * @dev Interface of an ERC721A compliant contract.
267  */
268 interface IERC721A {
269     /**
270      * The caller must own the token or be an approved operator.
271      */
272     error ApprovalCallerNotOwnerNorApproved();
273 
274     /**
275      * The token does not exist.
276      */
277     error ApprovalQueryForNonexistentToken();
278 
279     /**
280      * The caller cannot approve to their own address.
281      */
282     error ApproveToCaller();
283 
284     /**
285      * The caller cannot approve to the current owner.
286      */
287     error ApprovalToCurrentOwner();
288 
289     /**
290      * Cannot query the balance for the zero address.
291      */
292     error BalanceQueryForZeroAddress();
293 
294     /**
295      * Cannot mint to the zero address.
296      */
297     error MintToZeroAddress();
298 
299     /**
300      * The quantity of tokens minted must be more than zero.
301      */
302     error MintZeroQuantity();
303 
304     /**
305      * The token does not exist.
306      */
307     error OwnerQueryForNonexistentToken();
308 
309     /**
310      * The caller must own the token or be an approved operator.
311      */
312     error TransferCallerNotOwnerNorApproved();
313 
314     /**
315      * The token must be owned by `from`.
316      */
317     error TransferFromIncorrectOwner();
318 
319     /**
320      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
321      */
322     error TransferToNonERC721ReceiverImplementer();
323 
324     /**
325      * Cannot transfer to the zero address.
326      */
327     error TransferToZeroAddress();
328 
329     /**
330      * The token does not exist.
331      */
332     error URIQueryForNonexistentToken();
333 
334     struct TokenOwnership {
335         // The address of the owner.
336         address addr;
337         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
338         uint64 startTimestamp;
339         // Whether the token has been burned.
340         bool burned;
341     }
342 
343     /**
344      * @dev Returns the total amount of tokens stored by the contract.
345      *
346      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
347      */
348     function totalSupply() external view returns (uint256);
349 
350     // ==============================
351     //            IERC165
352     // ==============================
353 
354     /**
355      * @dev Returns true if this contract implements the interface defined by
356      * `interfaceId`. See the corresponding
357      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
358      * to learn more about how these ids are created.
359      *
360      * This function call must use less than 30 000 gas.
361      */
362     function supportsInterface(bytes4 interfaceId) external view returns (bool);
363 
364     // ==============================
365     //            IERC721
366     // ==============================
367 
368     /**
369      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
370      */
371     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
372 
373     /**
374      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
375      */
376     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
377 
378     /**
379      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
380      */
381     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
382 
383     /**
384      * @dev Returns the number of tokens in ``owner``'s account.
385      */
386     function balanceOf(address owner) external view returns (uint256 balance);
387 
388     /**
389      * @dev Returns the owner of the `tokenId` token.
390      *
391      * Requirements:
392      *
393      * - `tokenId` must exist.
394      */
395     function ownerOf(uint256 tokenId) external view returns (address owner);
396 
397     /**
398      * @dev Safely transfers `tokenId` token from `from` to `to`.
399      *
400      * Requirements:
401      *
402      * - `from` cannot be the zero address.
403      * - `to` cannot be the zero address.
404      * - `tokenId` token must exist and be owned by `from`.
405      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
406      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
407      *
408      * Emits a {Transfer} event.
409      */
410     function safeTransferFrom(
411         address from,
412         address to,
413         uint256 tokenId,
414         bytes calldata data
415     ) external;
416 
417     /**
418      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
419      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
420      *
421      * Requirements:
422      *
423      * - `from` cannot be the zero address.
424      * - `to` cannot be the zero address.
425      * - `tokenId` token must exist and be owned by `from`.
426      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
427      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
428      *
429      * Emits a {Transfer} event.
430      */
431     function safeTransferFrom(
432         address from,
433         address to,
434         uint256 tokenId
435     ) external;
436 
437     /**
438      * @dev Transfers `tokenId` token from `from` to `to`.
439      *
440      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      *
449      * Emits a {Transfer} event.
450      */
451     function transferFrom(
452         address from,
453         address to,
454         uint256 tokenId
455     ) external;
456 
457     /**
458      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
459      * The approval is cleared when the token is transferred.
460      *
461      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
462      *
463      * Requirements:
464      *
465      * - The caller must own the token or be an approved operator.
466      * - `tokenId` must exist.
467      *
468      * Emits an {Approval} event.
469      */
470     function approve(address to, uint256 tokenId) external;
471 
472     /**
473      * @dev Approve or remove `operator` as an operator for the caller.
474      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
475      *
476      * Requirements:
477      *
478      * - The `operator` cannot be the caller.
479      *
480      * Emits an {ApprovalForAll} event.
481      */
482     function setApprovalForAll(address operator, bool _approved) external;
483 
484     /**
485      * @dev Returns the account approved for `tokenId` token.
486      *
487      * Requirements:
488      *
489      * - `tokenId` must exist.
490      */
491     function getApproved(uint256 tokenId) external view returns (address operator);
492 
493     /**
494      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
495      *
496      * See {setApprovalForAll}
497      */
498     function isApprovedForAll(address owner, address operator) external view returns (bool);
499 
500     // ==============================
501     //        IERC721Metadata
502     // ==============================
503 
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
521 
522 
523 // ERC721A Contracts v3.3.0
524 // Creator: Chiru Labs
525 
526 pragma solidity ^0.8.4;
527 
528 
529 /**
530  * @dev ERC721 token receiver interface.
531  */
532 interface ERC721A__IERC721Receiver {
533     function onERC721Received(
534         address operator,
535         address from,
536         uint256 tokenId,
537         bytes calldata data
538     ) external returns (bytes4);
539 }
540 
541 /**
542  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
543  * the Metadata extension. Built to optimize for lower gas during batch mints.
544  *
545  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
546  *
547  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
548  *
549  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
550  */
551 contract ERC721A is IERC721A {
552     // Mask of an entry in packed address data.
553     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
554 
555     // The bit position of `numberMinted` in packed address data.
556     uint256 private constant BITPOS_NUMBER_MINTED = 64;
557 
558     // The bit position of `numberBurned` in packed address data.
559     uint256 private constant BITPOS_NUMBER_BURNED = 128;
560 
561     // The bit position of `aux` in packed address data.
562     uint256 private constant BITPOS_AUX = 192;
563 
564     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
565     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
566 
567     // The bit position of `startTimestamp` in packed ownership.
568     uint256 private constant BITPOS_START_TIMESTAMP = 160;
569 
570     // The bit mask of the `burned` bit in packed ownership.
571     uint256 private constant BITMASK_BURNED = 1 << 224;
572     
573     // The bit position of the `nextInitialized` bit in packed ownership.
574     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
575 
576     // The bit mask of the `nextInitialized` bit in packed ownership.
577     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
578 
579     // The tokenId of the next token to be minted.
580     uint256 private _currentIndex;
581 
582     // The number of tokens burned.
583     uint256 private _burnCounter;
584 
585     // Token name
586     string private _name;
587 
588     // Token symbol
589     string private _symbol;
590 
591     // Mapping from token ID to ownership details
592     // An empty struct value does not necessarily mean the token is unowned.
593     // See `_packedOwnershipOf` implementation for details.
594     //
595     // Bits Layout:
596     // - [0..159]   `addr`
597     // - [160..223] `startTimestamp`
598     // - [224]      `burned`
599     // - [225]      `nextInitialized`
600     mapping(uint256 => uint256) private _packedOwnerships;
601 
602     // Mapping owner address to address data.
603     //
604     // Bits Layout:
605     // - [0..63]    `balance`
606     // - [64..127]  `numberMinted`
607     // - [128..191] `numberBurned`
608     // - [192..255] `aux`
609     mapping(address => uint256) private _packedAddressData;
610 
611     // Mapping from token ID to approved address.
612     mapping(uint256 => address) private _tokenApprovals;
613 
614     // Mapping from owner to operator approvals
615     mapping(address => mapping(address => bool)) private _operatorApprovals;
616 
617     constructor(string memory name_, string memory symbol_) {
618         _name = name_;
619         _symbol = symbol_;
620         _currentIndex = _startTokenId();
621     }
622 
623     /**
624      * @dev Returns the starting token ID. 
625      * To change the starting token ID, please override this function.
626      */
627     function _startTokenId() internal view virtual returns (uint256) {
628         return 0;
629     }
630 
631     /**
632      * @dev Returns the next token ID to be minted.
633      */
634     function _nextTokenId() internal view returns (uint256) {
635         return _currentIndex;
636     }
637 
638     /**
639      * @dev Returns the total number of tokens in existence.
640      * Burned tokens will reduce the count. 
641      * To get the total number of tokens minted, please see `_totalMinted`.
642      */
643     function totalSupply() public view override returns (uint256) {
644         // Counter underflow is impossible as _burnCounter cannot be incremented
645         // more than `_currentIndex - _startTokenId()` times.
646         unchecked {
647             return _currentIndex - _burnCounter - _startTokenId();
648         }
649     }
650 
651     /**
652      * @dev Returns the total amount of tokens minted in the contract.
653      */
654     function _totalMinted() internal view returns (uint256) {
655         // Counter underflow is impossible as _currentIndex does not decrement,
656         // and it is initialized to `_startTokenId()`
657         unchecked {
658             return _currentIndex - _startTokenId();
659         }
660     }
661 
662     /**
663      * @dev Returns the total number of tokens burned.
664      */
665     function _totalBurned() internal view returns (uint256) {
666         return _burnCounter;
667     }
668 
669     /**
670      * @dev See {IERC165-supportsInterface}.
671      */
672     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
673         // The interface IDs are constants representing the first 4 bytes of the XOR of
674         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
675         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
676         return
677             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
678             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
679             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
680     }
681 
682     /**
683      * @dev See {IERC721-balanceOf}.
684      */
685     function balanceOf(address owner) public view override returns (uint256) {
686         if (owner == address(0)) revert BalanceQueryForZeroAddress();
687         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
688     }
689 
690     /**
691      * Returns the number of tokens minted by `owner`.
692      */
693     function _numberMinted(address owner) internal view returns (uint256) {
694         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
695     }
696 
697     /**
698      * Returns the number of tokens burned by or on behalf of `owner`.
699      */
700     function _numberBurned(address owner) internal view returns (uint256) {
701         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
702     }
703 
704     /**
705      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
706      */
707     function _getAux(address owner) internal view returns (uint64) {
708         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
709     }
710 
711     /**
712      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
713      * If there are multiple variables, please pack them into a uint64.
714      */
715     function _setAux(address owner, uint64 aux) internal {
716         uint256 packed = _packedAddressData[owner];
717         uint256 auxCasted;
718         assembly { // Cast aux without masking.
719             auxCasted := aux
720         }
721         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
722         _packedAddressData[owner] = packed;
723     }
724 
725     /**
726      * Returns the packed ownership data of `tokenId`.
727      */
728     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
729         uint256 curr = tokenId;
730 
731         unchecked {
732             if (_startTokenId() <= curr)
733                 if (curr < _currentIndex) {
734                     uint256 packed = _packedOwnerships[curr];
735                     // If not burned.
736                     if (packed & BITMASK_BURNED == 0) {
737                         // Invariant:
738                         // There will always be an ownership that has an address and is not burned
739                         // before an ownership that does not have an address and is not burned.
740                         // Hence, curr will not underflow.
741                         //
742                         // We can directly compare the packed value.
743                         // If the address is zero, packed is zero.
744                         while (packed == 0) {
745                             packed = _packedOwnerships[--curr];
746                         }
747                         return packed;
748                     }
749                 }
750         }
751         revert OwnerQueryForNonexistentToken();
752     }
753 
754     /**
755      * Returns the unpacked `TokenOwnership` struct from `packed`.
756      */
757     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
758         ownership.addr = address(uint160(packed));
759         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
760         ownership.burned = packed & BITMASK_BURNED != 0;
761     }
762 
763     /**
764      * Returns the unpacked `TokenOwnership` struct at `index`.
765      */
766     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
767         return _unpackedOwnership(_packedOwnerships[index]);
768     }
769 
770     /**
771      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
772      */
773     function _initializeOwnershipAt(uint256 index) internal {
774         if (_packedOwnerships[index] == 0) {
775             _packedOwnerships[index] = _packedOwnershipOf(index);
776         }
777     }
778 
779     /**
780      * Gas spent here starts off proportional to the maximum mint batch size.
781      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
782      */
783     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
784         return _unpackedOwnership(_packedOwnershipOf(tokenId));
785     }
786 
787     /**
788      * @dev See {IERC721-ownerOf}.
789      */
790     function ownerOf(uint256 tokenId) public view override returns (address) {
791         return address(uint160(_packedOwnershipOf(tokenId)));
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-name}.
796      */
797     function name() public view virtual override returns (string memory) {
798         return _name;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-symbol}.
803      */
804     function symbol() public view virtual override returns (string memory) {
805         return _symbol;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-tokenURI}.
810      */
811     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
812         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
813 
814         string memory baseURI = _baseURI();
815         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
816     }
817 
818     /**
819      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
820      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
821      * by default, can be overriden in child contracts.
822      */
823     function _baseURI() internal view virtual returns (string memory) {
824         return '';
825     }
826 
827     /**
828      * @dev Casts the address to uint256 without masking.
829      */
830     function _addressToUint256(address value) private pure returns (uint256 result) {
831         assembly {
832             result := value
833         }
834     }
835 
836     /**
837      * @dev Casts the boolean to uint256 without branching.
838      */
839     function _boolToUint256(bool value) private pure returns (uint256 result) {
840         assembly {
841             result := value
842         }
843     }
844 
845     /**
846      * @dev See {IERC721-approve}.
847      */
848     function approve(address to, uint256 tokenId) public override {
849         address owner = address(uint160(_packedOwnershipOf(tokenId)));
850         if (to == owner) revert ApprovalToCurrentOwner();
851 
852         if (_msgSenderERC721A() != owner)
853             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
854                 revert ApprovalCallerNotOwnerNorApproved();
855             }
856 
857         _tokenApprovals[tokenId] = to;
858         emit Approval(owner, to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-getApproved}.
863      */
864     function getApproved(uint256 tokenId) public view override returns (address) {
865         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
866 
867         return _tokenApprovals[tokenId];
868     }
869 
870     /**
871      * @dev See {IERC721-setApprovalForAll}.
872      */
873     function setApprovalForAll(address operator, bool approved) public virtual override {
874         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
875 
876         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
877         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
878     }
879 
880     /**
881      * @dev See {IERC721-isApprovedForAll}.
882      */
883     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
884         return _operatorApprovals[owner][operator];
885     }
886 
887     /**
888      * @dev See {IERC721-transferFrom}.
889      */
890     function transferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         _transfer(from, to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public virtual override {
906         safeTransferFrom(from, to, tokenId, '');
907     }
908 
909     /**
910      * @dev See {IERC721-safeTransferFrom}.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) public virtual override {
918         _transfer(from, to, tokenId);
919         if (to.code.length != 0)
920             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
921                 revert TransferToNonERC721ReceiverImplementer();
922             }
923     }
924 
925     /**
926      * @dev Returns whether `tokenId` exists.
927      *
928      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
929      *
930      * Tokens start existing when they are minted (`_mint`),
931      */
932     function _exists(uint256 tokenId) internal view returns (bool) {
933         return
934             _startTokenId() <= tokenId &&
935             tokenId < _currentIndex && // If within bounds,
936             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
937     }
938 
939     /**
940      * @dev Equivalent to `_safeMint(to, quantity, '')`.
941      */
942     function _safeMint(address to, uint256 quantity) internal {
943         _safeMint(to, quantity, '');
944     }
945 
946     /**
947      * @dev Safely mints `quantity` tokens and transfers them to `to`.
948      *
949      * Requirements:
950      *
951      * - If `to` refers to a smart contract, it must implement
952      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
953      * - `quantity` must be greater than 0.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _safeMint(
958         address to,
959         uint256 quantity,
960         bytes memory _data
961     ) internal {
962         uint256 startTokenId = _currentIndex;
963         if (to == address(0)) revert MintToZeroAddress();
964         if (quantity == 0) revert MintZeroQuantity();
965 
966         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
967 
968         // Overflows are incredibly unrealistic.
969         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
970         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
971         unchecked {
972             // Updates:
973             // - `balance += quantity`.
974             // - `numberMinted += quantity`.
975             //
976             // We can directly add to the balance and number minted.
977             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
978 
979             // Updates:
980             // - `address` to the owner.
981             // - `startTimestamp` to the timestamp of minting.
982             // - `burned` to `false`.
983             // - `nextInitialized` to `quantity == 1`.
984             _packedOwnerships[startTokenId] =
985                 _addressToUint256(to) |
986                 (block.timestamp << BITPOS_START_TIMESTAMP) |
987                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
988 
989             uint256 updatedIndex = startTokenId;
990             uint256 end = updatedIndex + quantity;
991 
992             if (to.code.length != 0) {
993                 do {
994                     emit Transfer(address(0), to, updatedIndex);
995                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
996                         revert TransferToNonERC721ReceiverImplementer();
997                     }
998                 } while (updatedIndex < end);
999                 // Reentrancy protection
1000                 if (_currentIndex != startTokenId) revert();
1001             } else {
1002                 do {
1003                     emit Transfer(address(0), to, updatedIndex++);
1004                 } while (updatedIndex < end);
1005             }
1006             _currentIndex = updatedIndex;
1007         }
1008         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1009     }
1010 
1011     /**
1012      * @dev Mints `quantity` tokens and transfers them to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `to` cannot be the zero address.
1017      * - `quantity` must be greater than 0.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _mint(address to, uint256 quantity) internal {
1022         uint256 startTokenId = _currentIndex;
1023         if (to == address(0)) revert MintToZeroAddress();
1024         if (quantity == 0) revert MintZeroQuantity();
1025 
1026         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1027 
1028         // Overflows are incredibly unrealistic.
1029         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1030         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1031         unchecked {
1032             // Updates:
1033             // - `balance += quantity`.
1034             // - `numberMinted += quantity`.
1035             //
1036             // We can directly add to the balance and number minted.
1037             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1038 
1039             // Updates:
1040             // - `address` to the owner.
1041             // - `startTimestamp` to the timestamp of minting.
1042             // - `burned` to `false`.
1043             // - `nextInitialized` to `quantity == 1`.
1044             _packedOwnerships[startTokenId] =
1045                 _addressToUint256(to) |
1046                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1047                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1048 
1049             uint256 updatedIndex = startTokenId;
1050             uint256 end = updatedIndex + quantity;
1051 
1052             do {
1053                 emit Transfer(address(0), to, updatedIndex++);
1054             } while (updatedIndex < end);
1055 
1056             _currentIndex = updatedIndex;
1057         }
1058         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1059     }
1060 
1061     /**
1062      * @dev Transfers `tokenId` from `from` to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - `to` cannot be the zero address.
1067      * - `tokenId` token must be owned by `from`.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _transfer(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) private {
1076         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1077 
1078         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1079 
1080         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1081             isApprovedForAll(from, _msgSenderERC721A()) ||
1082             getApproved(tokenId) == _msgSenderERC721A());
1083 
1084         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1085         if (to == address(0)) revert TransferToZeroAddress();
1086 
1087         _beforeTokenTransfers(from, to, tokenId, 1);
1088 
1089         // Clear approvals from the previous owner.
1090         delete _tokenApprovals[tokenId];
1091 
1092         // Underflow of the sender's balance is impossible because we check for
1093         // ownership above and the recipient's balance can't realistically overflow.
1094         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1095         unchecked {
1096             // We can directly increment and decrement the balances.
1097             --_packedAddressData[from]; // Updates: `balance -= 1`.
1098             ++_packedAddressData[to]; // Updates: `balance += 1`.
1099 
1100             // Updates:
1101             // - `address` to the next owner.
1102             // - `startTimestamp` to the timestamp of transfering.
1103             // - `burned` to `false`.
1104             // - `nextInitialized` to `true`.
1105             _packedOwnerships[tokenId] =
1106                 _addressToUint256(to) |
1107                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1108                 BITMASK_NEXT_INITIALIZED;
1109 
1110             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1111             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1112                 uint256 nextTokenId = tokenId + 1;
1113                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1114                 if (_packedOwnerships[nextTokenId] == 0) {
1115                     // If the next slot is within bounds.
1116                     if (nextTokenId != _currentIndex) {
1117                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1118                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1119                     }
1120                 }
1121             }
1122         }
1123 
1124         emit Transfer(from, to, tokenId);
1125         _afterTokenTransfers(from, to, tokenId, 1);
1126     }
1127 
1128     /**
1129      * @dev Equivalent to `_burn(tokenId, false)`.
1130      */
1131     function _burn(uint256 tokenId) internal virtual {
1132         _burn(tokenId, false);
1133     }
1134 
1135     /**
1136      * @dev Destroys `tokenId`.
1137      * The approval is cleared when the token is burned.
1138      *
1139      * Requirements:
1140      *
1141      * - `tokenId` must exist.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1146         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1147 
1148         address from = address(uint160(prevOwnershipPacked));
1149 
1150         if (approvalCheck) {
1151             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1152                 isApprovedForAll(from, _msgSenderERC721A()) ||
1153                 getApproved(tokenId) == _msgSenderERC721A());
1154 
1155             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1156         }
1157 
1158         _beforeTokenTransfers(from, address(0), tokenId, 1);
1159 
1160         // Clear approvals from the previous owner.
1161         delete _tokenApprovals[tokenId];
1162 
1163         // Underflow of the sender's balance is impossible because we check for
1164         // ownership above and the recipient's balance can't realistically overflow.
1165         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1166         unchecked {
1167             // Updates:
1168             // - `balance -= 1`.
1169             // - `numberBurned += 1`.
1170             //
1171             // We can directly decrement the balance, and increment the number burned.
1172             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1173             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1174 
1175             // Updates:
1176             // - `address` to the last owner.
1177             // - `startTimestamp` to the timestamp of burning.
1178             // - `burned` to `true`.
1179             // - `nextInitialized` to `true`.
1180             _packedOwnerships[tokenId] =
1181                 _addressToUint256(from) |
1182                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1183                 BITMASK_BURNED | 
1184                 BITMASK_NEXT_INITIALIZED;
1185 
1186             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1187             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1188                 uint256 nextTokenId = tokenId + 1;
1189                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1190                 if (_packedOwnerships[nextTokenId] == 0) {
1191                     // If the next slot is within bounds.
1192                     if (nextTokenId != _currentIndex) {
1193                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1194                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1195                     }
1196                 }
1197             }
1198         }
1199 
1200         emit Transfer(from, address(0), tokenId);
1201         _afterTokenTransfers(from, address(0), tokenId, 1);
1202 
1203         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1204         unchecked {
1205             _burnCounter++;
1206         }
1207     }
1208 
1209     /**
1210      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1211      *
1212      * @param from address representing the previous owner of the given token ID
1213      * @param to target address that will receive the tokens
1214      * @param tokenId uint256 ID of the token to be transferred
1215      * @param _data bytes optional data to send along with the call
1216      * @return bool whether the call correctly returned the expected magic value
1217      */
1218     function _checkContractOnERC721Received(
1219         address from,
1220         address to,
1221         uint256 tokenId,
1222         bytes memory _data
1223     ) private returns (bool) {
1224         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1225             bytes4 retval
1226         ) {
1227             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1228         } catch (bytes memory reason) {
1229             if (reason.length == 0) {
1230                 revert TransferToNonERC721ReceiverImplementer();
1231             } else {
1232                 assembly {
1233                     revert(add(32, reason), mload(reason))
1234                 }
1235             }
1236         }
1237     }
1238 
1239     /**
1240      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1241      * And also called before burning one token.
1242      *
1243      * startTokenId - the first token id to be transferred
1244      * quantity - the amount to be transferred
1245      *
1246      * Calling conditions:
1247      *
1248      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1249      * transferred to `to`.
1250      * - When `from` is zero, `tokenId` will be minted for `to`.
1251      * - When `to` is zero, `tokenId` will be burned by `from`.
1252      * - `from` and `to` are never both zero.
1253      */
1254     function _beforeTokenTransfers(
1255         address from,
1256         address to,
1257         uint256 startTokenId,
1258         uint256 quantity
1259     ) internal virtual {}
1260 
1261     /**
1262      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1263      * minting.
1264      * And also called after one token has been burned.
1265      *
1266      * startTokenId - the first token id to be transferred
1267      * quantity - the amount to be transferred
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` has been minted for `to`.
1274      * - When `to` is zero, `tokenId` has been burned by `from`.
1275      * - `from` and `to` are never both zero.
1276      */
1277     function _afterTokenTransfers(
1278         address from,
1279         address to,
1280         uint256 startTokenId,
1281         uint256 quantity
1282     ) internal virtual {}
1283 
1284     /**
1285      * @dev Returns the message sender (defaults to `msg.sender`).
1286      *
1287      * If you are writing GSN compatible contracts, you need to override this function.
1288      */
1289     function _msgSenderERC721A() internal view virtual returns (address) {
1290         return msg.sender;
1291     }
1292 
1293     /**
1294      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1295      */
1296     function _toString(uint256 value) internal pure returns (string memory ptr) {
1297         assembly {
1298             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1299             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1300             // We will need 1 32-byte word to store the length, 
1301             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1302             ptr := add(mload(0x40), 128)
1303             // Update the free memory pointer to allocate.
1304             mstore(0x40, ptr)
1305 
1306             // Cache the end of the memory to calculate the length later.
1307             let end := ptr
1308 
1309             // We write the string from the rightmost digit to the leftmost digit.
1310             // The following is essentially a do-while loop that also handles the zero case.
1311             // Costs a bit more than early returning for the zero case,
1312             // but cheaper in terms of deployment and overall runtime costs.
1313             for { 
1314                 // Initialize and perform the first pass without check.
1315                 let temp := value
1316                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1317                 ptr := sub(ptr, 1)
1318                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1319                 mstore8(ptr, add(48, mod(temp, 10)))
1320                 temp := div(temp, 10)
1321             } temp { 
1322                 // Keep dividing `temp` until zero.
1323                 temp := div(temp, 10)
1324             } { // Body of the for loop.
1325                 ptr := sub(ptr, 1)
1326                 mstore8(ptr, add(48, mod(temp, 10)))
1327             }
1328             
1329             let length := sub(end, ptr)
1330             // Move the pointer 32 bytes leftwards to make room for the length.
1331             ptr := sub(ptr, 32)
1332             // Store the length.
1333             mstore(ptr, length)
1334         }
1335     }
1336 }
1337 
1338 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1339 
1340 
1341 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 /**
1346  * @dev String operations.
1347  */
1348 library Strings {
1349     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1350     uint8 private constant _ADDRESS_LENGTH = 20;
1351 
1352     /**
1353      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1354      */
1355     function toString(uint256 value) internal pure returns (string memory) {
1356         // Inspired by OraclizeAPI's implementation - MIT licence
1357         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1358 
1359         if (value == 0) {
1360             return "0";
1361         }
1362         uint256 temp = value;
1363         uint256 digits;
1364         while (temp != 0) {
1365             digits++;
1366             temp /= 10;
1367         }
1368         bytes memory buffer = new bytes(digits);
1369         while (value != 0) {
1370             digits -= 1;
1371             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1372             value /= 10;
1373         }
1374         return string(buffer);
1375     }
1376 
1377     /**
1378      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1379      */
1380     function toHexString(uint256 value) internal pure returns (string memory) {
1381         if (value == 0) {
1382             return "0x00";
1383         }
1384         uint256 temp = value;
1385         uint256 length = 0;
1386         while (temp != 0) {
1387             length++;
1388             temp >>= 8;
1389         }
1390         return toHexString(value, length);
1391     }
1392 
1393     /**
1394      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1395      */
1396     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1397         bytes memory buffer = new bytes(2 * length + 2);
1398         buffer[0] = "0";
1399         buffer[1] = "x";
1400         for (uint256 i = 2 * length + 1; i > 1; --i) {
1401             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1402             value >>= 4;
1403         }
1404         require(value == 0, "Strings: hex length insufficient");
1405         return string(buffer);
1406     }
1407 
1408     /**
1409      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1410      */
1411     function toHexString(address addr) internal pure returns (string memory) {
1412         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1413     }
1414 }
1415 
1416 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1417 
1418 
1419 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1420 
1421 pragma solidity ^0.8.0;
1422 
1423 /**
1424  * @dev Provides information about the current execution context, including the
1425  * sender of the transaction and its data. While these are generally available
1426  * via msg.sender and msg.data, they should not be accessed in such a direct
1427  * manner, since when dealing with meta-transactions the account sending and
1428  * paying for execution may not be the actual sender (as far as an application
1429  * is concerned).
1430  *
1431  * This contract is only required for intermediate, library-like contracts.
1432  */
1433 abstract contract Context {
1434     function _msgSender() internal view virtual returns (address) {
1435         return msg.sender;
1436     }
1437 
1438     function _msgData() internal view virtual returns (bytes calldata) {
1439         return msg.data;
1440     }
1441 }
1442 
1443 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1444 
1445 
1446 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1447 
1448 pragma solidity ^0.8.0;
1449 
1450 
1451 /**
1452  * @dev Contract module which provides a basic access control mechanism, where
1453  * there is an account (an owner) that can be granted exclusive access to
1454  * specific functions.
1455  *
1456  * By default, the owner account will be the one that deploys the contract. This
1457  * can later be changed with {transferOwnership}.
1458  *
1459  * This module is used through inheritance. It will make available the modifier
1460  * `onlyOwner`, which can be applied to your functions to restrict their use to
1461  * the owner.
1462  */
1463 abstract contract Ownable is Context {
1464     address private _owner;
1465 
1466     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1467 
1468     /**
1469      * @dev Initializes the contract setting the deployer as the initial owner.
1470      */
1471     constructor() {
1472         _transferOwnership(_msgSender());
1473     }
1474 
1475     /**
1476      * @dev Returns the address of the current owner.
1477      */
1478     function owner() public view virtual returns (address) {
1479         return _owner;
1480     }
1481 
1482     /**
1483      * @dev Throws if called by any account other than the owner.
1484      */
1485     modifier onlyOwner() {
1486         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1487         _;
1488     }
1489 
1490     /**
1491      * @dev Leaves the contract without owner. It will not be possible to call
1492      * `onlyOwner` functions anymore. Can only be called by the current owner.
1493      *
1494      * NOTE: Renouncing ownership will leave the contract without an owner,
1495      * thereby removing any functionality that is only available to the owner.
1496      */
1497     function renounceOwnership() public virtual onlyOwner {
1498         _transferOwnership(address(0));
1499     }
1500 
1501     /**
1502      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1503      * Can only be called by the current owner.
1504      */
1505     function transferOwnership(address newOwner) public virtual onlyOwner {
1506         require(newOwner != address(0), "Ownable: new owner is the zero address");
1507         _transferOwnership(newOwner);
1508     }
1509 
1510     /**
1511      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1512      * Internal function without access restriction.
1513      */
1514     function _transferOwnership(address newOwner) internal virtual {
1515         address oldOwner = _owner;
1516         _owner = newOwner;
1517         emit OwnershipTransferred(oldOwner, newOwner);
1518     }
1519 }
1520 
1521 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1522 
1523 
1524 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1525 
1526 pragma solidity ^0.8.1;
1527 
1528 /**
1529  * @dev Collection of functions related to the address type
1530  */
1531 library Address {
1532     /**
1533      * @dev Returns true if `account` is a contract.
1534      *
1535      * [IMPORTANT]
1536      * ====
1537      * It is unsafe to assume that an address for which this function returns
1538      * false is an externally-owned account (EOA) and not a contract.
1539      *
1540      * Among others, `isContract` will return false for the following
1541      * types of addresses:
1542      *
1543      *  - an externally-owned account
1544      *  - a contract in construction
1545      *  - an address where a contract will be created
1546      *  - an address where a contract lived, but was destroyed
1547      * ====
1548      *
1549      * [IMPORTANT]
1550      * ====
1551      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1552      *
1553      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1554      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1555      * constructor.
1556      * ====
1557      */
1558     function isContract(address account) internal view returns (bool) {
1559         // This method relies on extcodesize/address.code.length, which returns 0
1560         // for contracts in construction, since the code is only stored at the end
1561         // of the constructor execution.
1562 
1563         return account.code.length > 0;
1564     }
1565 
1566     /**
1567      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1568      * `recipient`, forwarding all available gas and reverting on errors.
1569      *
1570      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1571      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1572      * imposed by `transfer`, making them unable to receive funds via
1573      * `transfer`. {sendValue} removes this limitation.
1574      *
1575      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1576      *
1577      * IMPORTANT: because control is transferred to `recipient`, care must be
1578      * taken to not create reentrancy vulnerabilities. Consider using
1579      * {ReentrancyGuard} or the
1580      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1581      */
1582     function sendValue(address payable recipient, uint256 amount) internal {
1583         require(address(this).balance >= amount, "Address: insufficient balance");
1584 
1585         (bool success, ) = recipient.call{value: amount}("");
1586         require(success, "Address: unable to send value, recipient may have reverted");
1587     }
1588 
1589     /**
1590      * @dev Performs a Solidity function call using a low level `call`. A
1591      * plain `call` is an unsafe replacement for a function call: use this
1592      * function instead.
1593      *
1594      * If `target` reverts with a revert reason, it is bubbled up by this
1595      * function (like regular Solidity function calls).
1596      *
1597      * Returns the raw returned data. To convert to the expected return value,
1598      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1599      *
1600      * Requirements:
1601      *
1602      * - `target` must be a contract.
1603      * - calling `target` with `data` must not revert.
1604      *
1605      * _Available since v3.1._
1606      */
1607     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1608         return functionCall(target, data, "Address: low-level call failed");
1609     }
1610 
1611     /**
1612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1613      * `errorMessage` as a fallback revert reason when `target` reverts.
1614      *
1615      * _Available since v3.1._
1616      */
1617     function functionCall(
1618         address target,
1619         bytes memory data,
1620         string memory errorMessage
1621     ) internal returns (bytes memory) {
1622         return functionCallWithValue(target, data, 0, errorMessage);
1623     }
1624 
1625     /**
1626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1627      * but also transferring `value` wei to `target`.
1628      *
1629      * Requirements:
1630      *
1631      * - the calling contract must have an ETH balance of at least `value`.
1632      * - the called Solidity function must be `payable`.
1633      *
1634      * _Available since v3.1._
1635      */
1636     function functionCallWithValue(
1637         address target,
1638         bytes memory data,
1639         uint256 value
1640     ) internal returns (bytes memory) {
1641         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1642     }
1643 
1644     /**
1645      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1646      * with `errorMessage` as a fallback revert reason when `target` reverts.
1647      *
1648      * _Available since v3.1._
1649      */
1650     function functionCallWithValue(
1651         address target,
1652         bytes memory data,
1653         uint256 value,
1654         string memory errorMessage
1655     ) internal returns (bytes memory) {
1656         require(address(this).balance >= value, "Address: insufficient balance for call");
1657         require(isContract(target), "Address: call to non-contract");
1658 
1659         (bool success, bytes memory returndata) = target.call{value: value}(data);
1660         return verifyCallResult(success, returndata, errorMessage);
1661     }
1662 
1663     /**
1664      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1665      * but performing a static call.
1666      *
1667      * _Available since v3.3._
1668      */
1669     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1670         return functionStaticCall(target, data, "Address: low-level static call failed");
1671     }
1672 
1673     /**
1674      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1675      * but performing a static call.
1676      *
1677      * _Available since v3.3._
1678      */
1679     function functionStaticCall(
1680         address target,
1681         bytes memory data,
1682         string memory errorMessage
1683     ) internal view returns (bytes memory) {
1684         require(isContract(target), "Address: static call to non-contract");
1685 
1686         (bool success, bytes memory returndata) = target.staticcall(data);
1687         return verifyCallResult(success, returndata, errorMessage);
1688     }
1689 
1690     /**
1691      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1692      * but performing a delegate call.
1693      *
1694      * _Available since v3.4._
1695      */
1696     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1697         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1698     }
1699 
1700     /**
1701      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1702      * but performing a delegate call.
1703      *
1704      * _Available since v3.4._
1705      */
1706     function functionDelegateCall(
1707         address target,
1708         bytes memory data,
1709         string memory errorMessage
1710     ) internal returns (bytes memory) {
1711         require(isContract(target), "Address: delegate call to non-contract");
1712 
1713         (bool success, bytes memory returndata) = target.delegatecall(data);
1714         return verifyCallResult(success, returndata, errorMessage);
1715     }
1716 
1717     /**
1718      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1719      * revert reason using the provided one.
1720      *
1721      * _Available since v4.3._
1722      */
1723     function verifyCallResult(
1724         bool success,
1725         bytes memory returndata,
1726         string memory errorMessage
1727     ) internal pure returns (bytes memory) {
1728         if (success) {
1729             return returndata;
1730         } else {
1731             // Look for revert reason and bubble it up if present
1732             if (returndata.length > 0) {
1733                 // The easiest way to bubble the revert reason is using memory via assembly
1734 
1735                 assembly {
1736                     let returndata_size := mload(returndata)
1737                     revert(add(32, returndata), returndata_size)
1738                 }
1739             } else {
1740                 revert(errorMessage);
1741             }
1742         }
1743     }
1744 }
1745 
1746 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1747 
1748 
1749 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1750 
1751 pragma solidity ^0.8.0;
1752 
1753 /**
1754  * @title ERC721 token receiver interface
1755  * @dev Interface for any contract that wants to support safeTransfers
1756  * from ERC721 asset contracts.
1757  */
1758 interface IERC721Receiver {
1759     /**
1760      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1761      * by `operator` from `from`, this function is called.
1762      *
1763      * It must return its Solidity selector to confirm the token transfer.
1764      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1765      *
1766      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1767      */
1768     function onERC721Received(
1769         address operator,
1770         address from,
1771         uint256 tokenId,
1772         bytes calldata data
1773     ) external returns (bytes4);
1774 }
1775 
1776 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1777 
1778 
1779 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1780 
1781 pragma solidity ^0.8.0;
1782 
1783 /**
1784  * @dev Interface of the ERC165 standard, as defined in the
1785  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1786  *
1787  * Implementers can declare support of contract interfaces, which can then be
1788  * queried by others ({ERC165Checker}).
1789  *
1790  * For an implementation, see {ERC165}.
1791  */
1792 interface IERC165 {
1793     /**
1794      * @dev Returns true if this contract implements the interface defined by
1795      * `interfaceId`. See the corresponding
1796      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1797      * to learn more about how these ids are created.
1798      *
1799      * This function call must use less than 30 000 gas.
1800      */
1801     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1802 }
1803 
1804 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1805 
1806 
1807 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1808 
1809 pragma solidity ^0.8.0;
1810 
1811 
1812 /**
1813  * @dev Implementation of the {IERC165} interface.
1814  *
1815  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1816  * for the additional interface id that will be supported. For example:
1817  *
1818  * ```solidity
1819  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1820  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1821  * }
1822  * ```
1823  *
1824  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1825  */
1826 abstract contract ERC165 is IERC165 {
1827     /**
1828      * @dev See {IERC165-supportsInterface}.
1829      */
1830     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1831         return interfaceId == type(IERC165).interfaceId;
1832     }
1833 }
1834 
1835 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1836 
1837 
1838 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1839 
1840 pragma solidity ^0.8.0;
1841 
1842 
1843 /**
1844  * @dev Required interface of an ERC721 compliant contract.
1845  */
1846 interface IERC721 is IERC165 {
1847     /**
1848      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1849      */
1850     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1851 
1852     /**
1853      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1854      */
1855     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1856 
1857     /**
1858      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1859      */
1860     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1861 
1862     /**
1863      * @dev Returns the number of tokens in ``owner``'s account.
1864      */
1865     function balanceOf(address owner) external view returns (uint256 balance);
1866 
1867     /**
1868      * @dev Returns the owner of the `tokenId` token.
1869      *
1870      * Requirements:
1871      *
1872      * - `tokenId` must exist.
1873      */
1874     function ownerOf(uint256 tokenId) external view returns (address owner);
1875 
1876     /**
1877      * @dev Safely transfers `tokenId` token from `from` to `to`.
1878      *
1879      * Requirements:
1880      *
1881      * - `from` cannot be the zero address.
1882      * - `to` cannot be the zero address.
1883      * - `tokenId` token must exist and be owned by `from`.
1884      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1885      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1886      *
1887      * Emits a {Transfer} event.
1888      */
1889     function safeTransferFrom(
1890         address from,
1891         address to,
1892         uint256 tokenId,
1893         bytes calldata data
1894     ) external;
1895 
1896     /**
1897      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1898      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1899      *
1900      * Requirements:
1901      *
1902      * - `from` cannot be the zero address.
1903      * - `to` cannot be the zero address.
1904      * - `tokenId` token must exist and be owned by `from`.
1905      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1907      *
1908      * Emits a {Transfer} event.
1909      */
1910     function safeTransferFrom(
1911         address from,
1912         address to,
1913         uint256 tokenId
1914     ) external;
1915 
1916     /**
1917      * @dev Transfers `tokenId` token from `from` to `to`.
1918      *
1919      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1920      *
1921      * Requirements:
1922      *
1923      * - `from` cannot be the zero address.
1924      * - `to` cannot be the zero address.
1925      * - `tokenId` token must be owned by `from`.
1926      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1927      *
1928      * Emits a {Transfer} event.
1929      */
1930     function transferFrom(
1931         address from,
1932         address to,
1933         uint256 tokenId
1934     ) external;
1935 
1936     /**
1937      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1938      * The approval is cleared when the token is transferred.
1939      *
1940      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1941      *
1942      * Requirements:
1943      *
1944      * - The caller must own the token or be an approved operator.
1945      * - `tokenId` must exist.
1946      *
1947      * Emits an {Approval} event.
1948      */
1949     function approve(address to, uint256 tokenId) external;
1950 
1951     /**
1952      * @dev Approve or remove `operator` as an operator for the caller.
1953      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1954      *
1955      * Requirements:
1956      *
1957      * - The `operator` cannot be the caller.
1958      *
1959      * Emits an {ApprovalForAll} event.
1960      */
1961     function setApprovalForAll(address operator, bool _approved) external;
1962 
1963     /**
1964      * @dev Returns the account approved for `tokenId` token.
1965      *
1966      * Requirements:
1967      *
1968      * - `tokenId` must exist.
1969      */
1970     function getApproved(uint256 tokenId) external view returns (address operator);
1971 
1972     /**
1973      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1974      *
1975      * See {setApprovalForAll}
1976      */
1977     function isApprovedForAll(address owner, address operator) external view returns (bool);
1978 }
1979 
1980 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1981 
1982 
1983 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1984 
1985 pragma solidity ^0.8.0;
1986 
1987 
1988 /**
1989  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1990  * @dev See https://eips.ethereum.org/EIPS/eip-721
1991  */
1992 interface IERC721Metadata is IERC721 {
1993     /**
1994      * @dev Returns the token collection name.
1995      */
1996     function name() external view returns (string memory);
1997 
1998     /**
1999      * @dev Returns the token collection symbol.
2000      */
2001     function symbol() external view returns (string memory);
2002 
2003     /**
2004      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2005      */
2006     function tokenURI(uint256 tokenId) external view returns (string memory);
2007 }
2008 
2009 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
2010 
2011 
2012 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
2013 
2014 pragma solidity ^0.8.0;
2015 
2016 
2017 
2018 
2019 
2020 
2021 
2022 
2023 /**
2024  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2025  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2026  * {ERC721Enumerable}.
2027  */
2028 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2029     using Address for address;
2030     using Strings for uint256;
2031 
2032     // Token name
2033     string private _name;
2034 
2035     // Token symbol
2036     string private _symbol;
2037 
2038     // Mapping from token ID to owner address
2039     mapping(uint256 => address) private _owners;
2040 
2041     // Mapping owner address to token count
2042     mapping(address => uint256) private _balances;
2043 
2044     // Mapping from token ID to approved address
2045     mapping(uint256 => address) private _tokenApprovals;
2046 
2047     // Mapping from owner to operator approvals
2048     mapping(address => mapping(address => bool)) private _operatorApprovals;
2049 
2050     /**
2051      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2052      */
2053     constructor(string memory name_, string memory symbol_) {
2054         _name = name_;
2055         _symbol = symbol_;
2056     }
2057 
2058     /**
2059      * @dev See {IERC165-supportsInterface}.
2060      */
2061     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2062         return
2063             interfaceId == type(IERC721).interfaceId ||
2064             interfaceId == type(IERC721Metadata).interfaceId ||
2065             super.supportsInterface(interfaceId);
2066     }
2067 
2068     /**
2069      * @dev See {IERC721-balanceOf}.
2070      */
2071     function balanceOf(address owner) public view virtual override returns (uint256) {
2072         require(owner != address(0), "ERC721: address zero is not a valid owner");
2073         return _balances[owner];
2074     }
2075 
2076     /**
2077      * @dev See {IERC721-ownerOf}.
2078      */
2079     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2080         address owner = _owners[tokenId];
2081         require(owner != address(0), "ERC721: owner query for nonexistent token");
2082         return owner;
2083     }
2084 
2085     /**
2086      * @dev See {IERC721Metadata-name}.
2087      */
2088     function name() public view virtual override returns (string memory) {
2089         return _name;
2090     }
2091 
2092     /**
2093      * @dev See {IERC721Metadata-symbol}.
2094      */
2095     function symbol() public view virtual override returns (string memory) {
2096         return _symbol;
2097     }
2098 
2099     /**
2100      * @dev See {IERC721Metadata-tokenURI}.
2101      */
2102     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2103         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2104 
2105         string memory baseURI = _baseURI();
2106         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2107     }
2108 
2109     /**
2110      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2111      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2112      * by default, can be overridden in child contracts.
2113      */
2114     function _baseURI() internal view virtual returns (string memory) {
2115         return "";
2116     }
2117 
2118     /**
2119      * @dev See {IERC721-approve}.
2120      */
2121     function approve(address to, uint256 tokenId) public virtual override {
2122         address owner = ERC721.ownerOf(tokenId);
2123         require(to != owner, "ERC721: approval to current owner");
2124 
2125         require(
2126             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2127             "ERC721: approve caller is not owner nor approved for all"
2128         );
2129 
2130         _approve(to, tokenId);
2131     }
2132 
2133     /**
2134      * @dev See {IERC721-getApproved}.
2135      */
2136     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2137         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2138 
2139         return _tokenApprovals[tokenId];
2140     }
2141 
2142     /**
2143      * @dev See {IERC721-setApprovalForAll}.
2144      */
2145     function setApprovalForAll(address operator, bool approved) public virtual override {
2146         _setApprovalForAll(_msgSender(), operator, approved);
2147     }
2148 
2149     /**
2150      * @dev See {IERC721-isApprovedForAll}.
2151      */
2152     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2153         return _operatorApprovals[owner][operator];
2154     }
2155 
2156     /**
2157      * @dev See {IERC721-transferFrom}.
2158      */
2159     function transferFrom(
2160         address from,
2161         address to,
2162         uint256 tokenId
2163     ) public virtual override {
2164         //solhint-disable-next-line max-line-length
2165         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2166 
2167         _transfer(from, to, tokenId);
2168     }
2169 
2170     /**
2171      * @dev See {IERC721-safeTransferFrom}.
2172      */
2173     function safeTransferFrom(
2174         address from,
2175         address to,
2176         uint256 tokenId
2177     ) public virtual override {
2178         safeTransferFrom(from, to, tokenId, "");
2179     }
2180 
2181     /**
2182      * @dev See {IERC721-safeTransferFrom}.
2183      */
2184     function safeTransferFrom(
2185         address from,
2186         address to,
2187         uint256 tokenId,
2188         bytes memory data
2189     ) public virtual override {
2190         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2191         _safeTransfer(from, to, tokenId, data);
2192     }
2193 
2194     /**
2195      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2196      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2197      *
2198      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2199      *
2200      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2201      * implement alternative mechanisms to perform token transfer, such as signature-based.
2202      *
2203      * Requirements:
2204      *
2205      * - `from` cannot be the zero address.
2206      * - `to` cannot be the zero address.
2207      * - `tokenId` token must exist and be owned by `from`.
2208      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2209      *
2210      * Emits a {Transfer} event.
2211      */
2212     function _safeTransfer(
2213         address from,
2214         address to,
2215         uint256 tokenId,
2216         bytes memory data
2217     ) internal virtual {
2218         _transfer(from, to, tokenId);
2219         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2220     }
2221 
2222     /**
2223      * @dev Returns whether `tokenId` exists.
2224      *
2225      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2226      *
2227      * Tokens start existing when they are minted (`_mint`),
2228      * and stop existing when they are burned (`_burn`).
2229      */
2230     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2231         return _owners[tokenId] != address(0);
2232     }
2233 
2234     /**
2235      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2236      *
2237      * Requirements:
2238      *
2239      * - `tokenId` must exist.
2240      */
2241     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2242         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2243         address owner = ERC721.ownerOf(tokenId);
2244         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2245     }
2246 
2247     /**
2248      * @dev Safely mints `tokenId` and transfers it to `to`.
2249      *
2250      * Requirements:
2251      *
2252      * - `tokenId` must not exist.
2253      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2254      *
2255      * Emits a {Transfer} event.
2256      */
2257     function _safeMint(address to, uint256 tokenId) internal virtual {
2258         _safeMint(to, tokenId, "");
2259     }
2260 
2261     /**
2262      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2263      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2264      */
2265     function _safeMint(
2266         address to,
2267         uint256 tokenId,
2268         bytes memory data
2269     ) internal virtual {
2270         _mint(to, tokenId);
2271         require(
2272             _checkOnERC721Received(address(0), to, tokenId, data),
2273             "ERC721: transfer to non ERC721Receiver implementer"
2274         );
2275     }
2276 
2277     /**
2278      * @dev Mints `tokenId` and transfers it to `to`.
2279      *
2280      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2281      *
2282      * Requirements:
2283      *
2284      * - `tokenId` must not exist.
2285      * - `to` cannot be the zero address.
2286      *
2287      * Emits a {Transfer} event.
2288      */
2289     function _mint(address to, uint256 tokenId) internal virtual {
2290         require(to != address(0), "ERC721: mint to the zero address");
2291         require(!_exists(tokenId), "ERC721: token already minted");
2292 
2293         _beforeTokenTransfer(address(0), to, tokenId);
2294 
2295         _balances[to] += 1;
2296         _owners[tokenId] = to;
2297 
2298         emit Transfer(address(0), to, tokenId);
2299 
2300         _afterTokenTransfer(address(0), to, tokenId);
2301     }
2302 
2303     /**
2304      * @dev Destroys `tokenId`.
2305      * The approval is cleared when the token is burned.
2306      *
2307      * Requirements:
2308      *
2309      * - `tokenId` must exist.
2310      *
2311      * Emits a {Transfer} event.
2312      */
2313     function _burn(uint256 tokenId) internal virtual {
2314         address owner = ERC721.ownerOf(tokenId);
2315 
2316         _beforeTokenTransfer(owner, address(0), tokenId);
2317 
2318         // Clear approvals
2319         _approve(address(0), tokenId);
2320 
2321         _balances[owner] -= 1;
2322         delete _owners[tokenId];
2323 
2324         emit Transfer(owner, address(0), tokenId);
2325 
2326         _afterTokenTransfer(owner, address(0), tokenId);
2327     }
2328 
2329     /**
2330      * @dev Transfers `tokenId` from `from` to `to`.
2331      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2332      *
2333      * Requirements:
2334      *
2335      * - `to` cannot be the zero address.
2336      * - `tokenId` token must be owned by `from`.
2337      *
2338      * Emits a {Transfer} event.
2339      */
2340     function _transfer(
2341         address from,
2342         address to,
2343         uint256 tokenId
2344     ) internal virtual {
2345         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2346         require(to != address(0), "ERC721: transfer to the zero address");
2347 
2348         _beforeTokenTransfer(from, to, tokenId);
2349 
2350         // Clear approvals from the previous owner
2351         _approve(address(0), tokenId);
2352 
2353         _balances[from] -= 1;
2354         _balances[to] += 1;
2355         _owners[tokenId] = to;
2356 
2357         emit Transfer(from, to, tokenId);
2358 
2359         _afterTokenTransfer(from, to, tokenId);
2360     }
2361 
2362     /**
2363      * @dev Approve `to` to operate on `tokenId`
2364      *
2365      * Emits an {Approval} event.
2366      */
2367     function _approve(address to, uint256 tokenId) internal virtual {
2368         _tokenApprovals[tokenId] = to;
2369         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2370     }
2371 
2372     /**
2373      * @dev Approve `operator` to operate on all of `owner` tokens
2374      *
2375      * Emits an {ApprovalForAll} event.
2376      */
2377     function _setApprovalForAll(
2378         address owner,
2379         address operator,
2380         bool approved
2381     ) internal virtual {
2382         require(owner != operator, "ERC721: approve to caller");
2383         _operatorApprovals[owner][operator] = approved;
2384         emit ApprovalForAll(owner, operator, approved);
2385     }
2386 
2387     /**
2388      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2389      * The call is not executed if the target address is not a contract.
2390      *
2391      * @param from address representing the previous owner of the given token ID
2392      * @param to target address that will receive the tokens
2393      * @param tokenId uint256 ID of the token to be transferred
2394      * @param data bytes optional data to send along with the call
2395      * @return bool whether the call correctly returned the expected magic value
2396      */
2397     function _checkOnERC721Received(
2398         address from,
2399         address to,
2400         uint256 tokenId,
2401         bytes memory data
2402     ) private returns (bool) {
2403         if (to.isContract()) {
2404             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2405                 return retval == IERC721Receiver.onERC721Received.selector;
2406             } catch (bytes memory reason) {
2407                 if (reason.length == 0) {
2408                     revert("ERC721: transfer to non ERC721Receiver implementer");
2409                 } else {
2410                     assembly {
2411                         revert(add(32, reason), mload(reason))
2412                     }
2413                 }
2414             }
2415         } else {
2416             return true;
2417         }
2418     }
2419     //sf852022
2420     /**
2421      * @dev Hook that is called before any token transfer. This includes minting
2422      * and burning.
2423      *
2424      * Calling conditions:
2425      *
2426      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2427      * transferred to `to`.
2428      * - When `from` is zero, `tokenId` will be minted for `to`.
2429      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2430      * - `from` and `to` are never both zero.
2431      *
2432      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2433      */
2434     function _beforeTokenTransfer(
2435         address from,
2436         address to,
2437         uint256 tokenId
2438     ) internal virtual {}
2439 
2440     /**
2441      * @dev Hook that is called after any transfer of tokens. This includes
2442      * minting and burning.
2443      *
2444      * Calling conditions:
2445      *
2446      * - when `from` and `to` are both non-zero.
2447      * - `from` and `to` are never both zero.
2448      *
2449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2450      */
2451     function _afterTokenTransfer(
2452         address from,
2453         address to,
2454         uint256 tokenId
2455     ) internal virtual {}
2456 }
2457 
2458 
2459 
2460 
2461 pragma solidity ^0.8.0;
2462 
2463 
2464 
2465 
2466 contract Nakedz is ERC721A, Ownable {
2467     using Strings for uint256;
2468 
2469     string private baseURI;
2470 
2471     uint256 public price = 0.0055 ether;
2472 
2473     uint256 public maxPerTx = 5;
2474 
2475     uint256 public maxPerWallet = 5;
2476     string public hiddenURI="ipfs://bafybeih5jcdvmsiut4v6wmctjp5c2csh3pploohgya7kcarh563ixr7lci/hidden.json";
2477     bool public revealed = false;
2478     uint256 public maxRaffle = 1;
2479 
2480     uint256 public maxFree = 1;
2481     uint256 public maxWL = 2;
2482 
2483     uint256 public maxSupply = 5555;
2484 
2485    
2486 
2487     bool public nakedList = false;
2488     bool public allowList = false;
2489     bool public publicEnabled = false;
2490     bytes32 whitelistRoot;
2491     bytes32 raffleRoot;
2492 
2493     mapping(address => uint256  ) private _mintedFreeAmount;
2494     
2495     constructor() ERC721A("Nakeds", "TN") {
2496         
2497         
2498     }
2499 
2500 function nakedMint(bytes32[] calldata _merkleProof,uint256 count) external payable {
2501         uint256 cost = price;
2502        
2503        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2504 
2505         if(_mintedFreeAmount[msg.sender]<maxFree && count==1){
2506             cost=0;
2507         }
2508         
2509         require(MerkleProof.verify(_merkleProof, whitelistRoot, leaf),"Incorrect Whitelist Proof");
2510         require(msg.value >= cost, "Please send the exact amount.");
2511         require(numberMinted(msg.sender)+ count <=maxWL,"You cant mint anymore");
2512         require(totalSupply() + count <= maxSupply , "No more");
2513         require(count>0,"Please enter a number");
2514         require(nakedList, "Minting is not live yet");
2515       
2516 
2517 
2518         _mintedFreeAmount[msg.sender]+=count;
2519 
2520         _safeMint(msg.sender, count);
2521     }
2522 function allowListMint(bytes32[] calldata _merkleProof) external payable {
2523         
2524         
2525        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2526 
2527       
2528         require(MerkleProof.verify(_merkleProof, raffleRoot, leaf),"Incorrect Whitelist Proof");
2529         require(msg.value >=  price, "Please send the exact amount.");
2530         require(numberMinted(msg.sender)+1 <=maxRaffle,"You cant mint anymore");
2531         require(totalSupply()+1<= maxSupply , "No more");
2532         require(allowList, "Minting is not live yet");
2533        
2534 
2535         _safeMint(msg.sender, 1);
2536     }
2537 function publicMint(uint256 count) external payable {
2538        
2539 
2540         require(msg.value >= count * price, "Please send the exact amount.");
2541         require(numberMinted(msg.sender)+ count <=maxPerWallet,"You cant mint anymore");
2542         require(totalSupply() + count <= maxSupply , "No more");
2543         require(count>0,"Please enter a number");
2544         require(publicEnabled, "Minting is not live yet");
2545         require(count<=maxPerTx,"Max per tx exceeded");
2546        
2547 
2548         
2549 
2550         _safeMint(msg.sender, count);
2551     }
2552     function _baseURI() internal view virtual override returns (string memory) {
2553         return baseURI;
2554     }
2555    
2556      function tokenURI(uint256 tokenId)
2557     public
2558     view
2559     virtual
2560     override
2561     returns (string memory)
2562   {
2563     require(
2564       _exists(tokenId),
2565       "ERC721AMetadata: URI query for nonexistent token"
2566     );
2567      if (revealed == false) {
2568       return hiddenURI;
2569     }
2570 
2571     string memory currentBaseURI = _baseURI();
2572     return bytes(currentBaseURI).length > 0
2573         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
2574         : "";
2575   }
2576   
2577 
2578     function setBaseURI(string memory uri) public onlyOwner {
2579         baseURI = uri;
2580     }
2581     function setHiddenURI(string memory uri) public onlyOwner {
2582         hiddenURI = uri;
2583     }
2584 
2585    
2586     function setMaxWL(uint256 amount) external onlyOwner {
2587         maxWL = amount;
2588     }
2589     function setFree(uint256 amount) external onlyOwner {
2590         maxFree = amount;
2591     }
2592     function setMaxPerWallet(uint256 amount) external onlyOwner {
2593         maxPerWallet = amount;
2594     }
2595     function setPrice(uint256 _newPrice) external onlyOwner {
2596         price = _newPrice;
2597     }
2598    function flipSale(bool status) external onlyOwner {
2599         nakedList = status;
2600         allowList= status;
2601     }
2602     function flipNakedList(bool status) external onlyOwner {
2603         nakedList = status;
2604     }
2605      function flipallowList(bool status) external onlyOwner {
2606         
2607         allowList=status;
2608     }
2609     function flipPublic(bool status) external onlyOwner {
2610         
2611         publicEnabled = status;
2612     }
2613     function reveal() external onlyOwner {
2614     revealed = !revealed;
2615    
2616   }
2617      function setPreSaleRoot(bytes32 _presaleRoot_1, bytes32 _presaleRoot_2)
2618         external
2619         onlyOwner
2620     {  
2621         whitelistRoot = _presaleRoot_1;
2622         raffleRoot = _presaleRoot_2;
2623     }
2624      function numberMinted(address owner) public view returns (uint256) {
2625         return _numberMinted(owner);
2626     }
2627  function batchmint(uint256 _mintAmount, address destination) public onlyOwner {
2628     require(_mintAmount > 0, "need to mint at least 1 NFT");
2629     uint256 supply = totalSupply();
2630     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
2631 
2632       _safeMint(destination, _mintAmount);
2633     
2634   }
2635     function withdraw() external onlyOwner {
2636         (bool success, ) = payable(msg.sender).call{
2637             value: address(this).balance
2638         }("");
2639         require(success, "Transfer failed.");
2640     }
2641 }