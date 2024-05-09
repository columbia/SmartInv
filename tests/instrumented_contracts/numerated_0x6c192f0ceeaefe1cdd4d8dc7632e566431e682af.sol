1 interface IERC165Upgradeable {
2     /**
3      * @dev Returns true if this contract implements the interface defined by
4      * `interfaceId`. See the corresponding
5      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
6      * to learn more about how these ids are created.
7      *
8      * This function call must use less than 30 000 gas.
9      */
10     function supportsInterface(bytes4 interfaceId) external view returns (bool);
11 }
12 
13 interface IERC721Upgradeable is IERC165Upgradeable {
14     /**
15      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
16      */
17     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
18 
19     /**
20      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
21      */
22     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
23 
24     /**
25      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
26      */
27     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
28 
29     /**
30      * @dev Returns the number of tokens in ``owner``'s account.
31      */
32     function balanceOf(address owner) external view returns (uint256 balance);
33 
34     /**
35      * @dev Returns the owner of the `tokenId` token.
36      *
37      * Requirements:
38      *
39      * - `tokenId` must exist.
40      */
41     function ownerOf(uint256 tokenId) external view returns (address owner);
42 
43     /**
44      * @dev Safely transfers `tokenId` token from `from` to `to`.
45      *
46      * Requirements:
47      *
48      * - `from` cannot be the zero address.
49      * - `to` cannot be the zero address.
50      * - `tokenId` token must exist and be owned by `from`.
51      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
52      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
53      *
54      * Emits a {Transfer} event.
55      */
56     function safeTransferFrom(
57         address from,
58         address to,
59         uint256 tokenId,
60         bytes calldata data
61     ) external;
62 
63     /**
64      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
65      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must exist and be owned by `from`.
72      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
73      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74      *
75      * Emits a {Transfer} event.
76      */
77     function safeTransferFrom(
78         address from,
79         address to,
80         uint256 tokenId
81     ) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
87      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
88      * understand this adds an external call which potentially creates a reentrancy vulnerability.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Approve or remove `operator` as an operator for the caller.
122      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
123      *
124      * Requirements:
125      *
126      * - The `operator` cannot be the caller.
127      *
128      * Emits an {ApprovalForAll} event.
129      */
130     function setApprovalForAll(address operator, bool _approved) external;
131 
132     /**
133      * @dev Returns the account approved for `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function getApproved(uint256 tokenId) external view returns (address operator);
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 }
148 
149 
150 interface IERC4906Upgradeable is IERC165Upgradeable, IERC721Upgradeable {
151     /// @dev This event emits when the metadata of a token is changed.
152     /// So that the third-party platforms such as NFT market could
153     /// timely update the images and related attributes of the NFT.
154     event MetadataUpdate(uint256 _tokenId);
155 
156     /// @dev This event emits when the metadata of a range of tokens is changed.
157     /// So that the third-party platforms such as NFT market could
158     /// timely update the images and related attributes of the NFTs.
159     event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);
160 }
161 
162 interface IRenovaItemBase is IERC4906Upgradeable {
163     /// @notice Emitted when an item is minted.
164     /// @param player The player who owns the item.
165     /// @param tokenId The token ID.
166     /// @param hashverseItemId The Hashverse Item ID.
167     event Mint(
168         address indexed player,
169         uint256 tokenId,
170         uint256 hashverseItemId
171     );
172 
173     /// @notice Emitted when the Custom Metadata URI is updated.
174     /// @param uri The new URI.
175     event UpdateCustomURI(string uri);
176 
177     /// @notice Emitted when an item is bridged out of the current chain.
178     /// @param player The player.
179     /// @param tokenId The Token ID.
180     /// @param hashverseItemId The Hashverse Item ID.
181     /// @param dstWormholeChainId The Wormhole Chain ID of the chain the item is being bridged to.
182     /// @param sequence The Wormhole sequence number.
183     event XChainBridgeOut(
184         address indexed player,
185         uint256 tokenId,
186         uint256 hashverseItemId,
187         uint16 dstWormholeChainId,
188         uint256 sequence,
189         uint256 relayerFee
190     );
191 
192     /// @notice Emitted when an item was bridged into the current chain.
193     /// @param player The player.
194     /// @param tokenId The Token ID.
195     /// @param hashverseItemId The Hashverse Item ID.
196     /// @param srcWormholeChainId The Wormhole Chain ID of the chain the item is being bridged from.
197     event XChainBridgeIn(
198         address indexed player,
199         uint256 tokenId,
200         uint256 hashverseItemId,
201         uint16 srcWormholeChainId
202     );
203 
204     /// @notice Bridges an item into the chain via Wormhole.
205     /// @param vaa The Wormhole VAA.
206     function wormholeBridgeIn(bytes memory vaa) external;
207 
208     /// @notice Bridges an item out of the chain via Wormhole.
209     /// @param tokenId The Token ID.
210     /// @param dstWormholeChainId The Wormhole Chain ID of the chain the item is being bridged to.
211     function wormholeBridgeOut(
212         uint256 tokenId,
213         uint16 dstWormholeChainId,
214         uint256 wormholeMessageFee
215     ) external payable;
216 
217     /// @notice Sets the default royalty for the Item collection.
218     /// @param receiver The receiver of royalties.
219     /// @param feeNumerator The numerator of the fraction denoting the royalty percentage.
220     function setDefaultRoyalty(address receiver, uint96 feeNumerator) external;
221 
222     /// @notice Sets a custom base URI for the token metadata.
223     /// @param customBaseURI The new Custom URI.
224     function setCustomBaseURI(string memory customBaseURI) external;
225 
226     /// @notice Emits a refresh metadata event for a token.
227     /// @param tokenId The ID of the token.
228     function refreshMetadata(uint256 tokenId) external;
229 
230     /// @notice Emits a refresh metadata event for all tokens.
231     function refreshAllMetadata() external;
232 }
233 
234 interface IRenovaItem is IRenovaItemBase {
235     /// @notice Emitted when the authorization status of a minter changes.
236     /// @param minter The minter for which the status was updated.
237     /// @param status The new status.
238     event UpdateMinterAuthorization(address minter, bool status);
239 
240     /// @notice Initializer function.
241     /// @param minter The initial authorized minter.
242     /// @param wormhole The Wormhole Endpoint address. See {IWormholeBaseUpgradeable}.
243     /// @param wormholeConsistencyLevel The Wormhole Consistency Level. See {IWormholeBaseUpgradeable}.
244     function initialize(
245         address minter,
246         address wormhole,
247         uint8 wormholeConsistencyLevel
248     ) external;
249 
250     /// @notice Mints an item.
251     /// @param tokenOwner The owner of the item.
252     /// @param hashverseItemId The Hashverse Item ID.
253     function mint(address tokenOwner, uint256 hashverseItemId) external;
254 
255     /// @notice Updates the authorization status of a minter.
256     /// @param minter The minter to update the authorization status for.
257     /// @param status The new status.
258     function updateMinterAuthorization(address minter, bool status) external;
259 }
260 
261 library MerkleProof {
262     /**
263      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
264      * defined by `root`. For this, a `proof` must be provided, containing
265      * sibling hashes on the branch from the leaf to the root of the tree. Each
266      * pair of leaves and each pair of pre-images are assumed to be sorted.
267      */
268     function verify(
269         bytes32[] memory proof,
270         bytes32 root,
271         bytes32 leaf
272     ) internal pure returns (bool) {
273         return processProof(proof, leaf) == root;
274     }
275 
276     /**
277      * @dev Calldata version of {verify}
278      *
279      * _Available since v4.7._
280      */
281     function verifyCalldata(
282         bytes32[] calldata proof,
283         bytes32 root,
284         bytes32 leaf
285     ) internal pure returns (bool) {
286         return processProofCalldata(proof, leaf) == root;
287     }
288 
289     /**
290      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
291      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
292      * hash matches the root of the tree. When processing the proof, the pairs
293      * of leafs & pre-images are assumed to be sorted.
294      *
295      * _Available since v4.4._
296      */
297     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
298         bytes32 computedHash = leaf;
299         for (uint256 i = 0; i < proof.length; i++) {
300             computedHash = _hashPair(computedHash, proof[i]);
301         }
302         return computedHash;
303     }
304 
305     /**
306      * @dev Calldata version of {processProof}
307      *
308      * _Available since v4.7._
309      */
310     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
311         bytes32 computedHash = leaf;
312         for (uint256 i = 0; i < proof.length; i++) {
313             computedHash = _hashPair(computedHash, proof[i]);
314         }
315         return computedHash;
316     }
317 
318     /**
319      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
320      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
321      *
322      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
323      *
324      * _Available since v4.7._
325      */
326     function multiProofVerify(
327         bytes32[] memory proof,
328         bool[] memory proofFlags,
329         bytes32 root,
330         bytes32[] memory leaves
331     ) internal pure returns (bool) {
332         return processMultiProof(proof, proofFlags, leaves) == root;
333     }
334 
335     /**
336      * @dev Calldata version of {multiProofVerify}
337      *
338      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
339      *
340      * _Available since v4.7._
341      */
342     function multiProofVerifyCalldata(
343         bytes32[] calldata proof,
344         bool[] calldata proofFlags,
345         bytes32 root,
346         bytes32[] memory leaves
347     ) internal pure returns (bool) {
348         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
349     }
350 
351     /**
352      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
353      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
354      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
355      * respectively.
356      *
357      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
358      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
359      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
360      *
361      * _Available since v4.7._
362      */
363     function processMultiProof(
364         bytes32[] memory proof,
365         bool[] memory proofFlags,
366         bytes32[] memory leaves
367     ) internal pure returns (bytes32 merkleRoot) {
368         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
369         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
370         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
371         // the merkle tree.
372         uint256 leavesLen = leaves.length;
373         uint256 totalHashes = proofFlags.length;
374 
375         // Check proof validity.
376         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
377 
378         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
379         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
380         bytes32[] memory hashes = new bytes32[](totalHashes);
381         uint256 leafPos = 0;
382         uint256 hashPos = 0;
383         uint256 proofPos = 0;
384         // At each step, we compute the next hash using two values:
385         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
386         //   get the next hash.
387         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
388         //   `proof` array.
389         for (uint256 i = 0; i < totalHashes; i++) {
390             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
391             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
392             hashes[i] = _hashPair(a, b);
393         }
394 
395         if (totalHashes > 0) {
396             return hashes[totalHashes - 1];
397         } else if (leavesLen > 0) {
398             return leaves[0];
399         } else {
400             return proof[0];
401         }
402     }
403 
404     /**
405      * @dev Calldata version of {processMultiProof}.
406      *
407      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
408      *
409      * _Available since v4.7._
410      */
411     function processMultiProofCalldata(
412         bytes32[] calldata proof,
413         bool[] calldata proofFlags,
414         bytes32[] memory leaves
415     ) internal pure returns (bytes32 merkleRoot) {
416         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
417         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
418         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
419         // the merkle tree.
420         uint256 leavesLen = leaves.length;
421         uint256 totalHashes = proofFlags.length;
422 
423         // Check proof validity.
424         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
425 
426         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
427         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
428         bytes32[] memory hashes = new bytes32[](totalHashes);
429         uint256 leafPos = 0;
430         uint256 hashPos = 0;
431         uint256 proofPos = 0;
432         // At each step, we compute the next hash using two values:
433         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
434         //   get the next hash.
435         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
436         //   `proof` array.
437         for (uint256 i = 0; i < totalHashes; i++) {
438             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
439             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
440             hashes[i] = _hashPair(a, b);
441         }
442 
443         if (totalHashes > 0) {
444             return hashes[totalHashes - 1];
445         } else if (leavesLen > 0) {
446             return leaves[0];
447         } else {
448             return proof[0];
449         }
450     }
451 
452     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
453         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
454     }
455 
456     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
457         /// @solidity memory-safe-assembly
458         assembly {
459             mstore(0x00, a)
460             mstore(0x20, b)
461             value := keccak256(0x00, 0x40)
462         }
463     }
464 }
465 
466 abstract contract Context {
467     function _msgSender() internal view virtual returns (address) {
468         return msg.sender;
469     }
470 
471     function _msgData() internal view virtual returns (bytes calldata) {
472         return msg.data;
473     }
474 }
475 
476 contract MEMint is Context {
477     bytes32 private _preAllocatedMerkleRoot;
478     bytes32 private _publicMerkleRoot;
479 
480     address private _renovaItem;
481     mapping(address => bool) _minted;
482 
483     uint256 private _maxPublicMints;
484     uint256 private _numPublicMints;
485 
486     uint256 public totalMinted;
487 
488     event Mint(address player);
489 
490     constructor(
491         bytes32 preAllocatedMerkleRoot,
492         bytes32 publicMerkleRoot,
493         address renovaItem,
494         uint256 maxPublicMints
495     ) {
496         require(
497             preAllocatedMerkleRoot != bytes32(0),
498             'MEMint::constructor Pre-allocated Merkle Root cannot be 0.'
499         );
500         require(
501             publicMerkleRoot != bytes32(0),
502             'MEMint::constructor Public Merkle Root cannot be 0.'
503         );
504         require(
505             renovaItem != address(0),
506             'MEMint::constructor RenovaItem cannot be 0.'
507         );
508 
509         _preAllocatedMerkleRoot = preAllocatedMerkleRoot;
510         _publicMerkleRoot = publicMerkleRoot;
511 
512         _renovaItem = renovaItem;
513 
514         _maxPublicMints = maxPublicMints;
515         _numPublicMints = 0;
516     }
517 
518     function mint(
519         uint256[] calldata hashverseItemIds,
520         bytes32[] calldata proof
521     ) external {
522         require(!_minted[_msgSender()], 'MEMint::mint Already minted.');
523 
524         bytes32 leaf = keccak256(
525             abi.encodePacked(_msgSender(), hashverseItemIds)
526         );
527 
528         if (!MerkleProof.verifyCalldata(proof, _preAllocatedMerkleRoot, leaf)) {
529             if (!MerkleProof.verifyCalldata(proof, _publicMerkleRoot, leaf)) {
530                 revert('MEMint::mint Proof invalid.');
531             } else {
532                 require(
533                     _numPublicMints < _maxPublicMints,
534                     'MEMint::mint Mint limit reached.'
535                 );
536                 _numPublicMints++;
537                 totalMinted++;
538             }
539         }
540 
541         _minted[_msgSender()] = true;
542 
543         emit Mint(_msgSender());
544 
545         for (uint256 i = 0; i < hashverseItemIds.length; i++) {
546             IRenovaItem(_renovaItem).mint(_msgSender(), hashverseItemIds[i]);
547         }
548     }
549 }