1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev These functions deal with verification of Merkle Trees proofs.
9  *
10  * The proofs can be generated using the JavaScript library
11  * https://github.com/miguelmota/merkletreejs[merkletreejs].
12  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
13  *
14  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
15  *
16  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
17  * hashing, or use a hash function other than keccak256 for hashing leaves.
18  * This is because the concatenation of a sorted pair of internal nodes in
19  * the merkle tree could be reinterpreted as a leaf value.
20  */
21 library MerkleProof {
22     /**
23      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
24      * defined by `root`. For this, a `proof` must be provided, containing
25      * sibling hashes on the branch from the leaf to the root of the tree. Each
26      * pair of leaves and each pair of pre-images are assumed to be sorted.
27      */
28     function verify(
29         bytes32[] memory proof,
30         bytes32 root,
31         bytes32 leaf
32     ) internal pure returns (bool) {
33         return processProof(proof, leaf) == root;
34     }
35 
36     /**
37      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
38      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
39      * hash matches the root of the tree. When processing the proof, the pairs
40      * of leafs & pre-images are assumed to be sorted.
41      *
42      * _Available since v4.4._
43      */
44     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
45         bytes32 computedHash = leaf;
46         for (uint256 i = 0; i < proof.length; i++) {
47             bytes32 proofElement = proof[i];
48             if (computedHash <= proofElement) {
49                 // Hash(current computed hash + current element of the proof)
50                 computedHash = _efficientHash(computedHash, proofElement);
51             } else {
52                 // Hash(current element of the proof + current computed hash)
53                 computedHash = _efficientHash(proofElement, computedHash);
54             }
55         }
56         return computedHash;
57     }
58 
59     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
60         assembly {
61             mstore(0x00, a)
62             mstore(0x20, b)
63             value := keccak256(0x00, 0x40)
64         }
65     }
66 }
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev Interface of the ERC165 standard, as defined in the
74  * https://eips.ethereum.org/EIPS/eip-165[EIP].
75  *
76  * Implementers can declare support of contract interfaces, which can then be
77  * queried by others ({ERC165Checker}).
78  *
79  * For an implementation, see {ERC165}.
80  */
81 interface IERC165 {
82     /**
83      * @dev Returns true if this contract implements the interface defined by
84      * `interfaceId`. See the corresponding
85      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
86      * to learn more about how these ids are created.
87      *
88      * This function call must use less than 30 000 gas.
89      */
90     function supportsInterface(bytes4 interfaceId) external view returns (bool);
91 }
92 
93 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Required interface of an ERC721 compliant contract.
99  */
100 interface IERC721 is IERC165 {
101     /**
102      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
105 
106     /**
107      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
108      */
109     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
110 
111     /**
112      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
113      */
114     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
115 
116     /**
117      * @dev Returns the number of tokens in ``owner``'s account.
118      */
119     function balanceOf(address owner) external view returns (uint256 balance);
120 
121     /**
122      * @dev Returns the owner of the `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function ownerOf(uint256 tokenId) external view returns (address owner);
129 
130     /**
131      * @dev Safely transfers `tokenId` token from `from` to `to`.
132      *
133      * Requirements:
134      *
135      * - `from` cannot be the zero address.
136      * - `to` cannot be the zero address.
137      * - `tokenId` token must exist and be owned by `from`.
138      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
140      *
141      * Emits a {Transfer} event.
142      */
143     function safeTransferFrom(
144         address from,
145         address to,
146         uint256 tokenId,
147         bytes calldata data
148     ) external;
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
152      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId
168     ) external;
169 
170     /**
171      * @dev Transfers `tokenId` token from `from` to `to`.
172      *
173      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must be owned by `from`.
180      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external;
189 
190     /**
191      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
192      * The approval is cleared when the token is transferred.
193      *
194      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
195      *
196      * Requirements:
197      *
198      * - The caller must own the token or be an approved operator.
199      * - `tokenId` must exist.
200      *
201      * Emits an {Approval} event.
202      */
203     function approve(address to, uint256 tokenId) external;
204 
205     /**
206      * @dev Approve or remove `operator` as an operator for the caller.
207      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
208      *
209      * Requirements:
210      *
211      * - The `operator` cannot be the caller.
212      *
213      * Emits an {ApprovalForAll} event.
214      */
215     function setApprovalForAll(address operator, bool _approved) external;
216 
217     /**
218      * @dev Returns the account approved for `tokenId` token.
219      *
220      * Requirements:
221      *
222      * - `tokenId` must exist.
223      */
224     function getApproved(uint256 tokenId) external view returns (address operator);
225 
226     /**
227      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
228      *
229      * See {setApprovalForAll}
230      */
231     function isApprovedForAll(address owner, address operator) external view returns (bool);
232 }
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with meta-transactions the account sending and
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
254     function _msgData() internal view virtual returns (bytes calldata) {
255         return msg.data;
256     }
257 }
258 
259 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 abstract contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor() {
284         _transferOwnership(_msgSender());
285     }
286 
287     /**
288      * @dev Throws if called by any account other than the owner.
289      */
290     modifier onlyOwner() {
291         _checkOwner();
292         _;
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view virtual returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if the sender is not the owner.
304      */
305     function _checkOwner() internal view virtual {
306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
307     }
308 
309     /**
310      * @dev Leaves the contract without owner. It will not be possible to call
311      * `onlyOwner` functions anymore. Can only be called by the current owner.
312      *
313      * NOTE: Renouncing ownership will leave the contract without an owner,
314      * thereby removing any functionality that is only available to the owner.
315      */
316     function renounceOwnership() public virtual onlyOwner {
317         _transferOwnership(address(0));
318     }
319 
320     /**
321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
322      * Can only be called by the current owner.
323      */
324     function transferOwnership(address newOwner) public virtual onlyOwner {
325         require(newOwner != address(0), "Ownable: new owner is the zero address");
326         _transferOwnership(newOwner);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Internal function without access restriction.
332      */
333     function _transferOwnership(address newOwner) internal virtual {
334         address oldOwner = _owner;
335         _owner = newOwner;
336         emit OwnershipTransferred(oldOwner, newOwner);
337     }
338 }
339 
340 pragma solidity ^0.8.7;
341 
342 interface IMoonBase {
343     function mintPaused() external view returns (bool);
344     function mintPrice() external view returns (uint256);
345     function currentMintId() external view returns (uint256);
346     function mint(uint256 amount) external payable;
347     function updateMintPaused(bool paused) external;
348     function updateCurrentMintId(uint256 mintId) external;
349     function updateMintPrice(uint256 price) external;
350 }
351 
352 contract FreeClaim is Ownable {
353     error CannotClaim();
354     error AlreadyClaimed();
355 
356     IMoonBase private moonBase;
357     IERC721 private mlz;
358 
359     // Validating whitelisted addresses using merkle tree
360     bytes32 public merkleRoot;
361 
362     // Storing claims => keccak(merkleRoot + msg.sender)
363     // Allows multiple claims only defined by the current root
364     // If missing before going to the next round, only need to
365     // add him back to the next one and move on.
366     mapping(bytes32 => bool) public claims;
367 
368     event MerkleRootUpdated(bytes32 root);
369     event Claimed();
370 
371     constructor(address moonBaseAddr, address mlzAddr) {
372         moonBase = IMoonBase(moonBaseAddr);
373         mlz = IERC721(mlzAddr);
374     }
375 
376     function setMerkleRoot(bytes32 root) external onlyOwner {
377         merkleRoot = root;
378 
379         emit MerkleRootUpdated(root);
380     }
381 
382     function giveBackOwnership() external onlyOwner {
383         Ownable(address(moonBase)).transferOwnership(msg.sender);
384     }
385 
386     function ownerMint(
387         uint256 fromId,
388         uint256 amount,
389         address recipient
390     )
391         external
392         onlyOwner
393     {
394         bool mintPaused = moonBase.mintPaused();
395 
396         if (mintPaused)
397             moonBase.updateMintPaused(false);
398 
399         uint256 previousMintPrice = moonBase.mintPrice();
400         
401         if (previousMintPrice > 0)
402             moonBase.updateMintPrice(0);
403 
404         uint256 previousMintId = moonBase.currentMintId();
405 
406         moonBase.updateCurrentMintId(fromId);
407         moonBase.mint(amount);
408 
409         uint256 transferId;
410 
411         for (uint256 i; i < amount;) {
412             unchecked {
413                 transferId = fromId + i;
414             }
415 
416             mlz.transferFrom(address(this), recipient, transferId);
417 
418             unchecked {
419                 i++;
420             }
421         }
422 
423         moonBase.updateCurrentMintId(previousMintId);
424 
425         if (mintPaused)
426             moonBase.updateMintPaused(true);
427 
428         if (previousMintPrice > 0)
429             moonBase.updateMintPrice(previousMintPrice);
430     }
431 
432     function freeClaim(
433         uint256 amount,
434         address recipient,
435         bytes32[] calldata _proof
436     )
437         external
438     {
439         if (!MerkleProof.verify(_proof, merkleRoot, _leaf(msg.sender, amount)))
440             revert CannotClaim();
441 
442         bytes32 currentClaimKey = keccak256(abi.encodePacked(merkleRoot, msg.sender));
443         
444         if (claims[currentClaimKey])
445             revert AlreadyClaimed();
446 
447         bool mintPaused = moonBase.mintPaused();
448 
449         if (mintPaused)
450             moonBase.updateMintPaused(false);
451 
452         uint256 previousMintPrice = moonBase.mintPrice();
453         
454         if (previousMintPrice > 0)
455             moonBase.updateMintPrice(0);
456 
457         claims[currentClaimKey] = true;
458 
459         uint256 currentId = moonBase.currentMintId();
460 
461         moonBase.mint(amount);
462 
463         uint256 transferId;
464 
465         for (uint256 i; i < amount;) {
466             unchecked {
467                 transferId = currentId + i;
468             }
469 
470             mlz.transferFrom(address(this), recipient, transferId);
471 
472             unchecked {
473                 i++;
474             }
475         }
476         
477         if (mintPaused)
478             moonBase.updateMintPaused(true);
479 
480         if (previousMintPrice > 0)
481             moonBase.updateMintPrice(previousMintPrice);
482 
483         emit Claimed();
484     }
485 
486     function _leaf(address account, uint256 amount)
487         private
488         pure
489         returns (bytes32)
490     {
491         return keccak256(abi.encodePacked(account, amount));
492     }
493 }