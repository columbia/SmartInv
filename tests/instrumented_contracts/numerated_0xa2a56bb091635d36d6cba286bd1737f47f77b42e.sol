1 // SPDX-License-Identifier: MIT
2 
3 /**
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#??@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
11 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P? G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G#@@@@^  ~J@&#7P@@@@#G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GJ?JJ&@@&5^  .~7B&@@&JJ?JG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@J.&&P?J#@@@5??B@@@#J?P&&.J@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&.J&@@@&G!YPPGGGPPPY!G&@@@&J.&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
16 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P?JG@@@@@@@PJJJJJJJJP@@@@@@@GJ?P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
17 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@! @@@@@@@@@@@@@@@@@@@@@@@@@@@@ !@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
18 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&P?7@@@@@@@@@@@@@@@@@@@@@@@@@@@@7?P&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
19 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B 5@@@&?5@@#7B@@@@@@@@B7#@@5?&@@@5 B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
20 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B 5@@5: 7@@G .!@@@@@@!. G@@7 :5@@5 B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
21 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B 5@@J  7@@G  :@@@@@@:  G@@7  J@@5 B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
22 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B 5@@B5.^?7! ?P@@&&@@P? !7?^.5B@@5 B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
23 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B^Y#@@@##BBB#@@@5!!5@@@#BBB##@@@#Y^B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
24 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!.@@@@@@@@@@@@@@@@@@@@@@@@@@@@.!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B575&@@@@@@@@@@@@@@@@@@@@@@&575B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
26 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#57PB@@@@@@@@@@@@@@@@@@BP75#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
27 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G??P@@@@@@@@@@@@@@@@@@P??G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
28 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&J.&@@@@@@@@@@@@@@@@@@@@&.J&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
29 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@& J@@@@@@@@@@@@@@@@@@@@@@@@J &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
30 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5?JB@@@@@@@@@@@@@@@@@@@@@@@@BJ?5@@@@@@@@@@@@@B????B@@@@@@@@@@@@@@@
31 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@! @@@@@@@@@@@@@@@@@@@@@@@@@@@@ !@@@@@@@@@#5!!JBBG5!~&@@@@@@@@@@@@@
32 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&5??@@@@@@@@@@@@@@@@@@@@@@@@@@@@??5&@@@@@B575@@#55Y?7?@@@@@@@@@@@@@@
33 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B 5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5 B@@@@@?.&@@J?5YP@@@@@@@@@@@@@@@@@
34 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#P:P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P:P#@@#:Y#@5.P#@@@@@@@@@@@@@@@@@@@@
35 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@~^@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@^~@@# Y@5J7&@@@@@@@@@@@@@@@@@@@@@
36 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@~^@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@^~@@B.5& ?@@@@@@@@@@@@@@@@@@@@@@@
37 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@~^@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:^@7^#@& 7@@@@@@@@@@@@@@@@@@@@@@@
38 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@~^@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5JJ?Y@GJ?P@@@@@@@@@@@@@@@@@@@@@@@
39 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B5^G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&P@@&7.@@@@@@@@@@@@@@@@@@@@@@@@@
40 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#~JG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&PP5!P&@@@@@@@@@@@@@@@@@@@@@@@@@
41 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PJ??J&@@@@@@@@@@@@@@@@@@@@@@@@@B??JJJ5@@@@@@@@@@@@@@@@@@@@@@@@@@@@
42 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGG7!!!!!!!!!!!!!!!!!!!!!!!!!JGGB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
43 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
44 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
45 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
46 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
47 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
48 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
49 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
50 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
51 */
52 
53 
54 // File: @openzeppelin/contracts/utils/Context.sol
55 
56 
57 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
58 
59 pragma solidity ^0.8.0;
60 
61 /**
62  * @dev Provides information about the current execution context, including the
63  * sender of the transaction and its data. While these are generally available
64  * via msg.sender and msg.data, they should not be accessed in such a direct
65  * manner, since when dealing with meta-transactions the account sending and
66  * paying for execution may not be the actual sender (as far as an application
67  * is concerned).
68  *
69  * This contract is only required for intermediate, library-like contracts.
70  */
71 abstract contract Context {
72     function _msgSender() internal view virtual returns (address) {
73         return msg.sender;
74     }
75 
76     function _msgData() internal view virtual returns (bytes calldata) {
77         return msg.data;
78     }
79 }
80 
81 // File: @openzeppelin/contracts/access/Ownable.sol
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 
89 /**
90  * @dev Contract module which provides a basic access control mechanism, where
91  * there is an account (an owner) that can be granted exclusive access to
92  * specific functions.
93  *
94  * By default, the owner account will be the one that deploys the contract. This
95  * can later be changed with {transferOwnership}.
96  *
97  * This module is used through inheritance. It will make available the modifier
98  * `onlyOwner`, which can be applied to your functions to restrict their use to
99  * the owner.
100  */
101 abstract contract Ownable is Context {
102     address private _owner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     /**
107      * @dev Initializes the contract setting the deployer as the initial owner.
108      */
109     constructor() {
110         _transferOwnership(_msgSender());
111     }
112 
113     /**
114      * @dev Returns the address of the current owner.
115      */
116     function owner() public view virtual returns (address) {
117         return _owner;
118     }
119 
120     /**
121      * @dev Throws if called by any account other than the owner.
122      */
123     modifier onlyOwner() {
124         require(owner() == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     /**
129      * @dev Leaves the contract without owner. It will not be possible to call
130      * `onlyOwner` functions anymore. Can only be called by the current owner.
131      *
132      * NOTE: Renouncing ownership will leave the contract without an owner,
133      * thereby removing any functionality that is only available to the owner.
134      */
135     function renounceOwnership() public virtual onlyOwner {
136         _transferOwnership(address(0));
137     }
138 
139     /**
140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
141      * Can only be called by the current owner.
142      */
143     function transferOwnership(address newOwner) public virtual onlyOwner {
144         require(newOwner != address(0), "Ownable: new owner is the zero address");
145         _transferOwnership(newOwner);
146     }
147 
148     /**
149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
150      * Internal function without access restriction.
151      */
152     function _transferOwnership(address newOwner) internal virtual {
153         address oldOwner = _owner;
154         _owner = newOwner;
155         emit OwnershipTransferred(oldOwner, newOwner);
156     }
157 }
158 
159 // File: contracts/Strings.sol
160 
161 
162 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 /**
167  * @dev String operations.
168  */
169 library Strings {
170     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
171     uint8 private constant _ADDRESS_LENGTH = 20;
172 
173     /**
174      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
175      */
176     function toString(uint256 value) internal pure returns (string memory) {
177         // Inspired by OraclizeAPI's implementation - MIT licence
178         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
179 
180         if (value == 0) {
181             return "0";
182         }
183         uint256 temp = value;
184         uint256 digits;
185         while (temp != 0) {
186             digits++;
187             temp /= 10;
188         }
189         bytes memory buffer = new bytes(digits);
190         while (value != 0) {
191             digits -= 1;
192             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
193             value /= 10;
194         }
195         return string(buffer);
196     }
197 
198     /**
199      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
200      */
201     function toHexString(uint256 value) internal pure returns (string memory) {
202         if (value == 0) {
203             return "0x00";
204         }
205         uint256 temp = value;
206         uint256 length = 0;
207         while (temp != 0) {
208             length++;
209             temp >>= 8;
210         }
211         return toHexString(value, length);
212     }
213 
214     /**
215      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
216      */
217     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
218         bytes memory buffer = new bytes(2 * length + 2);
219         buffer[0] = "0";
220         buffer[1] = "x";
221         for (uint256 i = 2 * length + 1; i > 1; --i) {
222             buffer[i] = _HEX_SYMBOLS[value & 0xf];
223             value >>= 4;
224         }
225         require(value == 0, "Strings: hex length insufficient");
226         return string(buffer);
227     }
228 
229     /**
230      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
231      */
232     function toHexString(address addr) internal pure returns (string memory) {
233         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
234     }
235 }
236 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
237 
238 
239 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev These functions deal with verification of Merkle Trees proofs.
245  *
246  * The proofs can be generated using the JavaScript library
247  * https://github.com/miguelmota/merkletreejs[merkletreejs].
248  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
249  *
250  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
251  *
252  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
253  * hashing, or use a hash function other than keccak256 for hashing leaves.
254  * This is because the concatenation of a sorted pair of internal nodes in
255  * the merkle tree could be reinterpreted as a leaf value.
256  */
257 library MerkleProof {
258     /**
259      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
260      * defined by `root`. For this, a `proof` must be provided, containing
261      * sibling hashes on the branch from the leaf to the root of the tree. Each
262      * pair of leaves and each pair of pre-images are assumed to be sorted.
263      */
264     function verify(
265         bytes32[] memory proof,
266         bytes32 root,
267         bytes32 leaf
268     ) internal pure returns (bool) {
269         return processProof(proof, leaf) == root;
270     }
271 
272     /**
273      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
274      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
275      * hash matches the root of the tree. When processing the proof, the pairs
276      * of leafs & pre-images are assumed to be sorted.
277      *
278      * _Available since v4.4._
279      */
280     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
281         bytes32 computedHash = leaf;
282         for (uint256 i = 0; i < proof.length; i++) {
283             bytes32 proofElement = proof[i];
284             if (computedHash <= proofElement) {
285                 // Hash(current computed hash + current element of the proof)
286                 computedHash = _efficientHash(computedHash, proofElement);
287             } else {
288                 // Hash(current element of the proof + current computed hash)
289                 computedHash = _efficientHash(proofElement, computedHash);
290             }
291         }
292         return computedHash;
293     }
294 
295     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
296         assembly {
297             mstore(0x00, a)
298             mstore(0x20, b)
299             value := keccak256(0x00, 0x40)
300         }
301     }
302 }
303 
304 // File: erc721a/contracts/IERC721A.sol
305 
306 
307 // ERC721A Contracts v4.0.0
308 // Creator: Chiru Labs
309 
310 pragma solidity ^0.8.4;
311 
312 /**
313  * @dev Interface of an ERC721A compliant contract.
314  */
315 interface IERC721A {
316     /**
317      * The caller must own the token or be an approved operator.
318      */
319     error ApprovalCallerNotOwnerNorApproved();
320 
321     /**
322      * The token does not exist.
323      */
324     error ApprovalQueryForNonexistentToken();
325 
326     /**
327      * The caller cannot approve to their own address.
328      */
329     error ApproveToCaller();
330 
331     /**
332      * The caller cannot approve to the current owner.
333      */
334     error ApprovalToCurrentOwner();
335 
336     /**
337      * Cannot query the balance for the zero address.
338      */
339     error BalanceQueryForZeroAddress();
340 
341     /**
342      * Cannot mint to the zero address.
343      */
344     error MintToZeroAddress();
345 
346     /**
347      * The quantity of tokens minted must be more than zero.
348      */
349     error MintZeroQuantity();
350 
351     /**
352      * The token does not exist.
353      */
354     error OwnerQueryForNonexistentToken();
355 
356     /**
357      * The caller must own the token or be an approved operator.
358      */
359     error TransferCallerNotOwnerNorApproved();
360 
361     /**
362      * The token must be owned by `from`.
363      */
364     error TransferFromIncorrectOwner();
365 
366     /**
367      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
368      */
369     error TransferToNonERC721ReceiverImplementer();
370 
371     /**
372      * Cannot transfer to the zero address.
373      */
374     error TransferToZeroAddress();
375 
376     /**
377      * The token does not exist.
378      */
379     error URIQueryForNonexistentToken();
380 
381     struct TokenOwnership {
382         // The address of the owner.
383         address addr;
384         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
385         uint64 startTimestamp;
386         // Whether the token has been burned.
387         bool burned;
388     }
389 
390     /**
391      * @dev Returns the total amount of tokens stored by the contract.
392      *
393      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
394      */
395     function totalSupply() external view returns (uint256);
396 
397     // ==============================
398     //            IERC165
399     // ==============================
400 
401     /**
402      * @dev Returns true if this contract implements the interface defined by
403      * `interfaceId`. See the corresponding
404      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
405      * to learn more about how these ids are created.
406      *
407      * This function call must use less than 30 000 gas.
408      */
409     function supportsInterface(bytes4 interfaceId) external view returns (bool);
410 
411     // ==============================
412     //            IERC721
413     // ==============================
414 
415     /**
416      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
417      */
418     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
419 
420     /**
421      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
422      */
423     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
424 
425     /**
426      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
427      */
428     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
429 
430     /**
431      * @dev Returns the number of tokens in ``owner``'s account.
432      */
433     function balanceOf(address owner) external view returns (uint256 balance);
434 
435     /**
436      * @dev Returns the owner of the `tokenId` token.
437      *
438      * Requirements:
439      *
440      * - `tokenId` must exist.
441      */
442     function ownerOf(uint256 tokenId) external view returns (address owner);
443 
444     /**
445      * @dev Safely transfers `tokenId` token from `from` to `to`.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must exist and be owned by `from`.
452      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
454      *
455      * Emits a {Transfer} event.
456      */
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId,
461         bytes calldata data
462     ) external;
463 
464     /**
465      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
466      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must exist and be owned by `from`.
473      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
474      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
475      *
476      * Emits a {Transfer} event.
477      */
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId
482     ) external;
483 
484     /**
485      * @dev Transfers `tokenId` token from `from` to `to`.
486      *
487      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
488      *
489      * Requirements:
490      *
491      * - `from` cannot be the zero address.
492      * - `to` cannot be the zero address.
493      * - `tokenId` token must be owned by `from`.
494      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
495      *
496      * Emits a {Transfer} event.
497      */
498     function transferFrom(
499         address from,
500         address to,
501         uint256 tokenId
502     ) external;
503 
504     /**
505      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
506      * The approval is cleared when the token is transferred.
507      *
508      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
509      *
510      * Requirements:
511      *
512      * - The caller must own the token or be an approved operator.
513      * - `tokenId` must exist.
514      *
515      * Emits an {Approval} event.
516      */
517     function approve(address to, uint256 tokenId) external;
518 
519     /**
520      * @dev Approve or remove `operator` as an operator for the caller.
521      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
522      *
523      * Requirements:
524      *
525      * - The `operator` cannot be the caller.
526      *
527      * Emits an {ApprovalForAll} event.
528      */
529     function setApprovalForAll(address operator, bool _approved) external;
530 
531     /**
532      * @dev Returns the account approved for `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function getApproved(uint256 tokenId) external view returns (address operator);
539 
540     /**
541      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
542      *
543      * See {setApprovalForAll}
544      */
545     function isApprovedForAll(address owner, address operator) external view returns (bool);
546 
547     // ==============================
548     //        IERC721Metadata
549     // ==============================
550 
551     /**
552      * @dev Returns the token collection name.
553      */
554     function name() external view returns (string memory);
555 
556     /**
557      * @dev Returns the token collection symbol.
558      */
559     function symbol() external view returns (string memory);
560 
561     /**
562      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
563      */
564     function tokenURI(uint256 tokenId) external view returns (string memory);
565 }
566 
567 // File: erc721a/contracts/ERC721A.sol
568 
569 
570 // ERC721A Contracts v4.0.0
571 // Creator: Chiru Labs
572 
573 pragma solidity ^0.8.4;
574 
575 
576 /**
577  * @dev ERC721 token receiver interface.
578  */
579 interface ERC721A__IERC721Receiver {
580     function onERC721Received(
581         address operator,
582         address from,
583         uint256 tokenId,
584         bytes calldata data
585     ) external returns (bytes4);
586 }
587 
588 /**
589  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
590  * the Metadata extension. Built to optimize for lower gas during batch mints.
591  *
592  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
593  *
594  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
595  *
596  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
597  */
598 contract ERC721A is IERC721A {
599     // Mask of an entry in packed address data.
600     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
601 
602     // The bit position of `numberMinted` in packed address data.
603     uint256 private constant BITPOS_NUMBER_MINTED = 64;
604 
605     // The bit position of `numberBurned` in packed address data.
606     uint256 private constant BITPOS_NUMBER_BURNED = 128;
607 
608     // The bit position of `aux` in packed address data.
609     uint256 private constant BITPOS_AUX = 192;
610 
611     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
612     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
613 
614     // The bit position of `startTimestamp` in packed ownership.
615     uint256 private constant BITPOS_START_TIMESTAMP = 160;
616 
617     // The bit mask of the `burned` bit in packed ownership.
618     uint256 private constant BITMASK_BURNED = 1 << 224;
619     
620     // The bit position of the `nextInitialized` bit in packed ownership.
621     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
622 
623     // The bit mask of the `nextInitialized` bit in packed ownership.
624     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
625 
626     // The tokenId of the next token to be minted.
627     uint256 private _currentIndex;
628 
629     // The number of tokens burned.
630     uint256 private _burnCounter;
631 
632     // Token name
633     string private _name;
634 
635     // Token symbol
636     string private _symbol;
637 
638     // Mapping from token ID to ownership details
639     // An empty struct value does not necessarily mean the token is unowned.
640     // See `_packedOwnershipOf` implementation for details.
641     //
642     // Bits Layout:
643     // - [0..159]   `addr`
644     // - [160..223] `startTimestamp`
645     // - [224]      `burned`
646     // - [225]      `nextInitialized`
647     mapping(uint256 => uint256) private _packedOwnerships;
648 
649     // Mapping owner address to address data.
650     //
651     // Bits Layout:
652     // - [0..63]    `balance`
653     // - [64..127]  `numberMinted`
654     // - [128..191] `numberBurned`
655     // - [192..255] `aux`
656     mapping(address => uint256) private _packedAddressData;
657 
658     // Mapping from token ID to approved address.
659     mapping(uint256 => address) private _tokenApprovals;
660 
661     // Mapping from owner to operator approvals
662     mapping(address => mapping(address => bool)) private _operatorApprovals;
663 
664     constructor(string memory name_, string memory symbol_) {
665         _name = name_;
666         _symbol = symbol_;
667         _currentIndex = _startTokenId();
668     }
669 
670     /**
671      * @dev Returns the starting token ID. 
672      * To change the starting token ID, please override this function.
673      */
674     function _startTokenId() internal view virtual returns (uint256) {
675         return 0;
676     }
677 
678     /**
679      * @dev Returns the next token ID to be minted.
680      */
681     function _nextTokenId() internal view returns (uint256) {
682         return _currentIndex;
683     }
684 
685     /**
686      * @dev Returns the total number of tokens in existence.
687      * Burned tokens will reduce the count. 
688      * To get the total number of tokens minted, please see `_totalMinted`.
689      */
690     function totalSupply() public view override returns (uint256) {
691         // Counter underflow is impossible as _burnCounter cannot be incremented
692         // more than `_currentIndex - _startTokenId()` times.
693         unchecked {
694             return _currentIndex - _burnCounter - _startTokenId();
695         }
696     }
697 
698     /**
699      * @dev Returns the total amount of tokens minted in the contract.
700      */
701     function _totalMinted() internal view returns (uint256) {
702         // Counter underflow is impossible as _currentIndex does not decrement,
703         // and it is initialized to `_startTokenId()`
704         unchecked {
705             return _currentIndex - _startTokenId();
706         }
707     }
708 
709     /**
710      * @dev Returns the total number of tokens burned.
711      */
712     function _totalBurned() internal view returns (uint256) {
713         return _burnCounter;
714     }
715 
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
720         // The interface IDs are constants representing the first 4 bytes of the XOR of
721         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
722         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
723         return
724             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
725             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
726             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
727     }
728 
729     /**
730      * @dev See {IERC721-balanceOf}.
731      */
732     function balanceOf(address owner) public view override returns (uint256) {
733         if (owner == address(0)) revert BalanceQueryForZeroAddress();
734         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
735     }
736 
737     /**
738      * Returns the number of tokens minted by `owner`.
739      */
740     function _numberMinted(address owner) internal view returns (uint256) {
741         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
742     }
743 
744     /**
745      * Returns the number of tokens burned by or on behalf of `owner`.
746      */
747     function _numberBurned(address owner) internal view returns (uint256) {
748         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
749     }
750 
751     /**
752      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
753      */
754     function _getAux(address owner) internal view returns (uint64) {
755         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
756     }
757 
758     /**
759      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
760      * If there are multiple variables, please pack them into a uint64.
761      */
762     function _setAux(address owner, uint64 aux) internal {
763         uint256 packed = _packedAddressData[owner];
764         uint256 auxCasted;
765         assembly { // Cast aux without masking.
766             auxCasted := aux
767         }
768         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
769         _packedAddressData[owner] = packed;
770     }
771 
772     /**
773      * Returns the packed ownership data of `tokenId`.
774      */
775     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
776         uint256 curr = tokenId;
777 
778         unchecked {
779             if (_startTokenId() <= curr)
780                 if (curr < _currentIndex) {
781                     uint256 packed = _packedOwnerships[curr];
782                     // If not burned.
783                     if (packed & BITMASK_BURNED == 0) {
784                         // Invariant:
785                         // There will always be an ownership that has an address and is not burned
786                         // before an ownership that does not have an address and is not burned.
787                         // Hence, curr will not underflow.
788                         //
789                         // We can directly compare the packed value.
790                         // If the address is zero, packed is zero.
791                         while (packed == 0) {
792                             packed = _packedOwnerships[--curr];
793                         }
794                         return packed;
795                     }
796                 }
797         }
798         revert OwnerQueryForNonexistentToken();
799     }
800 
801     /**
802      * Returns the unpacked `TokenOwnership` struct from `packed`.
803      */
804     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
805         ownership.addr = address(uint160(packed));
806         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
807         ownership.burned = packed & BITMASK_BURNED != 0;
808     }
809 
810     /**
811      * Returns the unpacked `TokenOwnership` struct at `index`.
812      */
813     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
814         return _unpackedOwnership(_packedOwnerships[index]);
815     }
816 
817     /**
818      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
819      */
820     function _initializeOwnershipAt(uint256 index) internal {
821         if (_packedOwnerships[index] == 0) {
822             _packedOwnerships[index] = _packedOwnershipOf(index);
823         }
824     }
825 
826     /**
827      * Gas spent here starts off proportional to the maximum mint batch size.
828      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
829      */
830     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
831         return _unpackedOwnership(_packedOwnershipOf(tokenId));
832     }
833 
834     /**
835      * @dev See {IERC721-ownerOf}.
836      */
837     function ownerOf(uint256 tokenId) public view override returns (address) {
838         return address(uint160(_packedOwnershipOf(tokenId)));
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-name}.
843      */
844     function name() public view virtual override returns (string memory) {
845         return _name;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-symbol}.
850      */
851     function symbol() public view virtual override returns (string memory) {
852         return _symbol;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-tokenURI}.
857      */
858     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
859         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
860 
861         string memory baseURI = _baseURI();
862         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
863     }
864 
865     /**
866      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
867      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
868      * by default, can be overriden in child contracts.
869      */
870     function _baseURI() internal view virtual returns (string memory) {
871         return '';
872     }
873 
874     /**
875      * @dev Casts the address to uint256 without masking.
876      */
877     function _addressToUint256(address value) private pure returns (uint256 result) {
878         assembly {
879             result := value
880         }
881     }
882 
883     /**
884      * @dev Casts the boolean to uint256 without branching.
885      */
886     function _boolToUint256(bool value) private pure returns (uint256 result) {
887         assembly {
888             result := value
889         }
890     }
891 
892     /**
893      * @dev See {IERC721-approve}.
894      */
895     function approve(address to, uint256 tokenId) public override {
896         address owner = address(uint160(_packedOwnershipOf(tokenId)));
897         if (to == owner) revert ApprovalToCurrentOwner();
898 
899         if (_msgSenderERC721A() != owner)
900             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
901                 revert ApprovalCallerNotOwnerNorApproved();
902             }
903 
904         _tokenApprovals[tokenId] = to;
905         emit Approval(owner, to, tokenId);
906     }
907 
908     /**
909      * @dev See {IERC721-getApproved}.
910      */
911     function getApproved(uint256 tokenId) public view override returns (address) {
912         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
913 
914         return _tokenApprovals[tokenId];
915     }
916 
917     /**
918      * @dev See {IERC721-setApprovalForAll}.
919      */
920     function setApprovalForAll(address operator, bool approved) public virtual override {
921         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
922 
923         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
924         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
925     }
926 
927     /**
928      * @dev See {IERC721-isApprovedForAll}.
929      */
930     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
931         return _operatorApprovals[owner][operator];
932     }
933 
934     /**
935      * @dev See {IERC721-transferFrom}.
936      */
937     function transferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public virtual override {
942         _transfer(from, to, tokenId);
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public virtual override {
953         safeTransferFrom(from, to, tokenId, '');
954     }
955 
956     /**
957      * @dev See {IERC721-safeTransferFrom}.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) public virtual override {
965         _transfer(from, to, tokenId);
966         if (to.code.length != 0)
967             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
968                 revert TransferToNonERC721ReceiverImplementer();
969             }
970     }
971 
972     /**
973      * @dev Returns whether `tokenId` exists.
974      *
975      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
976      *
977      * Tokens start existing when they are minted (`_mint`),
978      */
979     function _exists(uint256 tokenId) internal view returns (bool) {
980         return
981             _startTokenId() <= tokenId &&
982             tokenId < _currentIndex && // If within bounds,
983             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
984     }
985 
986     /**
987      * @dev Equivalent to `_safeMint(to, quantity, '')`.
988      */
989     function _safeMint(address to, uint256 quantity) internal {
990         _safeMint(to, quantity, '');
991     }
992 
993     /**
994      * @dev Safely mints `quantity` tokens and transfers them to `to`.
995      *
996      * Requirements:
997      *
998      * - If `to` refers to a smart contract, it must implement
999      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1000      * - `quantity` must be greater than 0.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _safeMint(
1005         address to,
1006         uint256 quantity,
1007         bytes memory _data
1008     ) internal {
1009         uint256 startTokenId = _currentIndex;
1010         if (to == address(0)) revert MintToZeroAddress();
1011         if (quantity == 0) revert MintZeroQuantity();
1012 
1013         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1014 
1015         // Overflows are incredibly unrealistic.
1016         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1017         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1018         unchecked {
1019             // Updates:
1020             // - `balance += quantity`.
1021             // - `numberMinted += quantity`.
1022             //
1023             // We can directly add to the balance and number minted.
1024             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1025 
1026             // Updates:
1027             // - `address` to the owner.
1028             // - `startTimestamp` to the timestamp of minting.
1029             // - `burned` to `false`.
1030             // - `nextInitialized` to `quantity == 1`.
1031             _packedOwnerships[startTokenId] =
1032                 _addressToUint256(to) |
1033                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1034                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1035 
1036             uint256 updatedIndex = startTokenId;
1037             uint256 end = updatedIndex + quantity;
1038 
1039             if (to.code.length != 0) {
1040                 do {
1041                     emit Transfer(address(0), to, updatedIndex);
1042                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1043                         revert TransferToNonERC721ReceiverImplementer();
1044                     }
1045                 } while (updatedIndex < end);
1046                 // Reentrancy protection
1047                 if (_currentIndex != startTokenId) revert();
1048             } else {
1049                 do {
1050                     emit Transfer(address(0), to, updatedIndex++);
1051                 } while (updatedIndex < end);
1052             }
1053             _currentIndex = updatedIndex;
1054         }
1055         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1056     }
1057 
1058     /**
1059      * @dev Mints `quantity` tokens and transfers them to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `quantity` must be greater than 0.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _mint(address to, uint256 quantity) internal {
1069         uint256 startTokenId = _currentIndex;
1070         if (to == address(0)) revert MintToZeroAddress();
1071         if (quantity == 0) revert MintZeroQuantity();
1072 
1073         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1074 
1075         // Overflows are incredibly unrealistic.
1076         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1077         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1078         unchecked {
1079             // Updates:
1080             // - `balance += quantity`.
1081             // - `numberMinted += quantity`.
1082             //
1083             // We can directly add to the balance and number minted.
1084             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1085 
1086             // Updates:
1087             // - `address` to the owner.
1088             // - `startTimestamp` to the timestamp of minting.
1089             // - `burned` to `false`.
1090             // - `nextInitialized` to `quantity == 1`.
1091             _packedOwnerships[startTokenId] =
1092                 _addressToUint256(to) |
1093                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1094                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1095 
1096             uint256 updatedIndex = startTokenId;
1097             uint256 end = updatedIndex + quantity;
1098 
1099             do {
1100                 emit Transfer(address(0), to, updatedIndex++);
1101             } while (updatedIndex < end);
1102 
1103             _currentIndex = updatedIndex;
1104         }
1105         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1106     }
1107 
1108     /**
1109      * @dev Transfers `tokenId` from `from` to `to`.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - `tokenId` token must be owned by `from`.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _transfer(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) private {
1123         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1124 
1125         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1126 
1127         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1128             isApprovedForAll(from, _msgSenderERC721A()) ||
1129             getApproved(tokenId) == _msgSenderERC721A());
1130 
1131         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1132         if (to == address(0)) revert TransferToZeroAddress();
1133 
1134         _beforeTokenTransfers(from, to, tokenId, 1);
1135 
1136         // Clear approvals from the previous owner.
1137         delete _tokenApprovals[tokenId];
1138 
1139         // Underflow of the sender's balance is impossible because we check for
1140         // ownership above and the recipient's balance can't realistically overflow.
1141         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1142         unchecked {
1143             // We can directly increment and decrement the balances.
1144             --_packedAddressData[from]; // Updates: `balance -= 1`.
1145             ++_packedAddressData[to]; // Updates: `balance += 1`.
1146 
1147             // Updates:
1148             // - `address` to the next owner.
1149             // - `startTimestamp` to the timestamp of transfering.
1150             // - `burned` to `false`.
1151             // - `nextInitialized` to `true`.
1152             _packedOwnerships[tokenId] =
1153                 _addressToUint256(to) |
1154                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1155                 BITMASK_NEXT_INITIALIZED;
1156 
1157             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1158             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1159                 uint256 nextTokenId = tokenId + 1;
1160                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1161                 if (_packedOwnerships[nextTokenId] == 0) {
1162                     // If the next slot is within bounds.
1163                     if (nextTokenId != _currentIndex) {
1164                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1165                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1166                     }
1167                 }
1168             }
1169         }
1170 
1171         emit Transfer(from, to, tokenId);
1172         _afterTokenTransfers(from, to, tokenId, 1);
1173     }
1174 
1175     /**
1176      * @dev Equivalent to `_burn(tokenId, false)`.
1177      */
1178     function _burn(uint256 tokenId) internal virtual {
1179         _burn(tokenId, false);
1180     }
1181 
1182     /**
1183      * @dev Destroys `tokenId`.
1184      * The approval is cleared when the token is burned.
1185      *
1186      * Requirements:
1187      *
1188      * - `tokenId` must exist.
1189      *
1190      * Emits a {Transfer} event.
1191      */
1192     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1193         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1194 
1195         address from = address(uint160(prevOwnershipPacked));
1196 
1197         if (approvalCheck) {
1198             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1199                 isApprovedForAll(from, _msgSenderERC721A()) ||
1200                 getApproved(tokenId) == _msgSenderERC721A());
1201 
1202             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1203         }
1204 
1205         _beforeTokenTransfers(from, address(0), tokenId, 1);
1206 
1207         // Clear approvals from the previous owner.
1208         delete _tokenApprovals[tokenId];
1209 
1210         // Underflow of the sender's balance is impossible because we check for
1211         // ownership above and the recipient's balance can't realistically overflow.
1212         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1213         unchecked {
1214             // Updates:
1215             // - `balance -= 1`.
1216             // - `numberBurned += 1`.
1217             //
1218             // We can directly decrement the balance, and increment the number burned.
1219             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1220             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1221 
1222             // Updates:
1223             // - `address` to the last owner.
1224             // - `startTimestamp` to the timestamp of burning.
1225             // - `burned` to `true`.
1226             // - `nextInitialized` to `true`.
1227             _packedOwnerships[tokenId] =
1228                 _addressToUint256(from) |
1229                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1230                 BITMASK_BURNED | 
1231                 BITMASK_NEXT_INITIALIZED;
1232 
1233             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1234             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1235                 uint256 nextTokenId = tokenId + 1;
1236                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1237                 if (_packedOwnerships[nextTokenId] == 0) {
1238                     // If the next slot is within bounds.
1239                     if (nextTokenId != _currentIndex) {
1240                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1241                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1242                     }
1243                 }
1244             }
1245         }
1246 
1247         emit Transfer(from, address(0), tokenId);
1248         _afterTokenTransfers(from, address(0), tokenId, 1);
1249 
1250         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1251         unchecked {
1252             _burnCounter++;
1253         }
1254     }
1255 
1256     /**
1257      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1258      *
1259      * @param from address representing the previous owner of the given token ID
1260      * @param to target address that will receive the tokens
1261      * @param tokenId uint256 ID of the token to be transferred
1262      * @param _data bytes optional data to send along with the call
1263      * @return bool whether the call correctly returned the expected magic value
1264      */
1265     function _checkContractOnERC721Received(
1266         address from,
1267         address to,
1268         uint256 tokenId,
1269         bytes memory _data
1270     ) private returns (bool) {
1271         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1272             bytes4 retval
1273         ) {
1274             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1275         } catch (bytes memory reason) {
1276             if (reason.length == 0) {
1277                 revert TransferToNonERC721ReceiverImplementer();
1278             } else {
1279                 assembly {
1280                     revert(add(32, reason), mload(reason))
1281                 }
1282             }
1283         }
1284     }
1285 
1286     /**
1287      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1288      * And also called before burning one token.
1289      *
1290      * startTokenId - the first token id to be transferred
1291      * quantity - the amount to be transferred
1292      *
1293      * Calling conditions:
1294      *
1295      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1296      * transferred to `to`.
1297      * - When `from` is zero, `tokenId` will be minted for `to`.
1298      * - When `to` is zero, `tokenId` will be burned by `from`.
1299      * - `from` and `to` are never both zero.
1300      */
1301     function _beforeTokenTransfers(
1302         address from,
1303         address to,
1304         uint256 startTokenId,
1305         uint256 quantity
1306     ) internal virtual {}
1307 
1308     /**
1309      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1310      * minting.
1311      * And also called after one token has been burned.
1312      *
1313      * startTokenId - the first token id to be transferred
1314      * quantity - the amount to be transferred
1315      *
1316      * Calling conditions:
1317      *
1318      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1319      * transferred to `to`.
1320      * - When `from` is zero, `tokenId` has been minted for `to`.
1321      * - When `to` is zero, `tokenId` has been burned by `from`.
1322      * - `from` and `to` are never both zero.
1323      */
1324     function _afterTokenTransfers(
1325         address from,
1326         address to,
1327         uint256 startTokenId,
1328         uint256 quantity
1329     ) internal virtual {}
1330 
1331     /**
1332      * @dev Returns the message sender (defaults to `msg.sender`).
1333      *
1334      * If you are writing GSN compatible contracts, you need to override this function.
1335      */
1336     function _msgSenderERC721A() internal view virtual returns (address) {
1337         return msg.sender;
1338     }
1339 
1340     /**
1341      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1342      */
1343     function _toString(uint256 value) internal pure returns (string memory ptr) {
1344         assembly {
1345             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1346             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1347             // We will need 1 32-byte word to store the length, 
1348             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1349             ptr := add(mload(0x40), 128)
1350             // Update the free memory pointer to allocate.
1351             mstore(0x40, ptr)
1352 
1353             // Cache the end of the memory to calculate the length later.
1354             let end := ptr
1355 
1356             // We write the string from the rightmost digit to the leftmost digit.
1357             // The following is essentially a do-while loop that also handles the zero case.
1358             // Costs a bit more than early returning for the zero case,
1359             // but cheaper in terms of deployment and overall runtime costs.
1360             for { 
1361                 // Initialize and perform the first pass without check.
1362                 let temp := value
1363                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1364                 ptr := sub(ptr, 1)
1365                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1366                 mstore8(ptr, add(48, mod(temp, 10)))
1367                 temp := div(temp, 10)
1368             } temp { 
1369                 // Keep dividing `temp` until zero.
1370                 temp := div(temp, 10)
1371             } { // Body of the for loop.
1372                 ptr := sub(ptr, 1)
1373                 mstore8(ptr, add(48, mod(temp, 10)))
1374             }
1375             
1376             let length := sub(end, ptr)
1377             // Move the pointer 32 bytes leftwards to make room for the length.
1378             ptr := sub(ptr, 32)
1379             // Store the length.
1380             mstore(ptr, length)
1381         }
1382     }
1383 }
1384 
1385 // File: contracts/nightcatz.sol
1386 
1387 
1388 
1389 pragma solidity ^0.8.4;
1390 
1391 
1392 
1393 contract nightcatz is ERC721A, Ownable {
1394     using Strings for uint256;
1395 
1396     string public  baseTokenUri;
1397     string public  placeholderTokenUri;
1398     string public baseExtension = ".json";
1399 
1400     uint public maxSupply = 3333;
1401     uint256 public maxMintAmount = 50;
1402     bool public revealed = false;
1403     bool public onlyWhitelist = false;
1404     bool public pause = true;
1405 
1406     uint public cost = 0.001 ether;
1407     mapping(address=>bool) public hasClaimed;
1408     mapping(address=>bool) public whitelisted;
1409 
1410     constructor(string memory _baseTokenURI, string memory _placeholderURI) ERC721A("nightcatz", "NICA") {
1411         baseTokenUri = _baseTokenURI;
1412         placeholderTokenUri = _placeholderURI;
1413     }
1414 
1415     function paused(bool _val) external onlyOwner {
1416         pause = _val;
1417     }
1418 
1419     function onlyWhitelisted(bool _val) external onlyOwner{
1420         onlyWhitelist = _val;
1421     }
1422 
1423     function reveal(bool _val) external onlyOwner {
1424         revealed = _val;
1425     } 
1426     
1427     function mint(uint256 quantity) external payable{
1428         require(!pause, "contract is paused!");
1429         require(quantity != 0, "please increase quantity from zero!");
1430         require(quantity <= maxMintAmount);
1431         require(totalSupply() + quantity <= maxSupply, "exceding total supply");
1432 
1433         if (onlyWhitelist) {
1434             require(whitelisted[msg.sender], "not in whitelist");
1435              internalLogic(quantity);
1436         } else {
1437             internalLogic(quantity);
1438         }
1439     }
1440 
1441     function internalLogic(uint quantity) private {
1442         if(quantity < 4 && !hasClaimed[msg.sender]) {
1443             require(hasClaimed[msg.sender] == false, "already claimed");
1444             hasClaimed[msg.sender] = true;
1445             _mint(msg.sender, quantity);
1446         } else if (quantity < 4 && hasClaimed[msg.sender]) {
1447             require(msg.value >= cost, "not enough balance!");
1448             _mint(msg.sender, quantity);
1449         } else {
1450             if(hasClaimed[msg.sender] == false) {
1451             hasClaimed[msg.sender] = true;
1452             uint totalQToCalculate = quantity - 3;
1453             uint tCost = cost * totalQToCalculate;
1454             require(msg.value >= tCost, "not enough balance to mint!");
1455             _mint(msg.sender, quantity);
1456             } else {
1457                 require(msg.value >= cost * quantity, "insufficient balance!");
1458                  _mint(msg.sender, quantity);
1459             }       
1460         }
1461 
1462     }
1463 
1464     function tokenURI(uint256 tokenId)
1465     public
1466     view
1467     virtual
1468     override
1469     returns (string memory)
1470   {
1471     require(
1472       _exists(tokenId),
1473       "ERC721Metadata: URI query for nonexistent token"
1474     );
1475     
1476     if(revealed == false) {
1477         return placeholderTokenUri;
1478     }
1479     uint256 trueId = tokenId + 1;
1480 
1481     return bytes(baseTokenUri).length > 0
1482         ? string(abi.encodePacked(baseTokenUri, trueId.toString(), baseExtension))
1483         : "";
1484   }
1485 
1486 
1487   function setTokenUri(string memory _baseTokenUri) external onlyOwner {
1488         baseTokenUri = _baseTokenUri;
1489     }
1490     function setPlaceHolderUri(string memory _placeholderTokenUri) external onlyOwner {
1491         placeholderTokenUri = _placeholderTokenUri;
1492     }
1493 
1494     function addWhitelisted(address[] memory accounts) external onlyOwner {
1495 
1496     for (uint256 account = 0; account < accounts.length; account++) {
1497         whitelisted[accounts[account]] = true;
1498     }
1499 }
1500     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1501     maxMintAmount = _newmaxMintAmount;
1502         }
1503 
1504     function setCost(uint256 _newCost) public onlyOwner {
1505     cost = _newCost;
1506          }
1507          
1508     function withdraw() external payable onlyOwner {
1509     (bool os, ) = payable(msg.sender).call{value: address(this).balance}("");
1510     require(os);
1511   }
1512 }