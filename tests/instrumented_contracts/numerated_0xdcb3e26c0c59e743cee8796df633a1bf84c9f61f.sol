1 // SPDX-License-Identifier: MIT
2 
3 /**
4 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
5 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
6 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
7 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
8 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
9 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
10 :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::..:::::::.:::::::::::::::::::::::
11 ::::::::::::::::::::::.::::::.::::::::::::::::::::::::::::::::::.:~?YPGGGGP5?^.:::::::::::::::::::::
12 :::::::::::::::::::.^7YPGGGP5J!^:.::::::::......::::::::....::.~JG###BGGGGGB#B?:::::::::::::::::::::
13 :::::::::::::::::::?B#BBGGGGB##B5?^.::^^~!7?JJY555555555YYJ7!!YB##GPPPPPPPPPG##J::::::::::::::::::::
14 ::::::::::::::::::5&BGPPPPPPPPGB##B55GBB####BBBBBBBBBBBBBB######GPPPPPPPPPPPPG##~:::::::::::::::::::
15 :::::::::::::::::7##PPPPPPPPPPGB###BBGGGPPPPPPPPPPPPPPPPPPPG#BGPPPPPPPPPPPPPPP##!:::::::::::::::::::
16 ::::::::::::::::.Y##PPPPPPPPPPBBGGPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG#B^:::::::::::::::::::
17 :::::::::::::::::7##GPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG#&J::::::::::::::::::::
18 ::::::::::::::::::J##BPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG##5:::::::::::::::::::::
19 :::::::::::::::::::7G#BGPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG##?::::::::::::::::::::::
20 :::::::::::::::::::::?B#BGPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG##7.:::::::::::::::::::::
21 :::::::::::::::::::::7B#BPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG#B~:::::::::::::::::::::
22 ::::::::::::::::::::Y##GPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPB#P:::::::::::::::::::::
23 :::::::::::::::::::Y##GPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG##?.:::::::::::::::::::
24 :::::::::::::::::.7##GPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPB#B^:::::::::::::::::::
25 ::::::::::::::::::G#BPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG##Y:::::::::::::::::::
26 :::::::::::::::::7##GGGGGGGGGGGGPPPPPPPPPPPPPPPPPPPPPPPPPPPPGGGGGGGGGGGGPPPPPPB#B^::::::::::::::::::
27 ::::::::::::::::.Y#BGG~!#&&#!^^PGPPPPPGGGGGGGGGGBGGGGPPPPPPPB7^?&&&B~^JBPPPPPPG##!::::::::::::::::::
28 :::::::::::::::::P#BPB~ ~JJ!  ~GPPPGBBG55Y55555YYY5PGBBGPPPPBJ  !JJ^ .PGPPPPPPG##7::::::::::::::::::
29 :::::::::::::::::G#BPPGJ:   ^?GPPBBPJ??5GBB###BBG5?77?YGBBPPPG5~.  .!PGPPPPPPPG##7.:::::::::::::::::
30 :::::::::::::::::5##PPPGGP5PGGPG#GJ777G&#########&G77777JG#GPPGGP5PPGPPPPPPPPPG##7::::::::::::::::::
31 :::::::::::::::::7##GPPPPPPPPPP#G77777JG#########BJ7777777P#GPPPPPPPPPPPPPPPPPB##~::::::::::::::::::
32 ::::::::::::::::::Y&#GPPPPPPPPG#?7777777JPGBBBGPJ777777777?BBPPPPPPPPPPPPPPPPG#&Y:::::::::::::::::::
33 :::::::::::::::::::5##BPPPPPPPB#?77777777777777777777777777P#PPPPPPPPPPPPPPPB##Y::::::::::::::::::::
34 ::::::::::::::::::::?B&#GPPPPPG#57777777??77777777777777777G#PPPPPPPPPPPPGB##G7:::::::::::::::::::::
35 ::::::::::::::::::::.^JG##BGPPPG#Y7777JGBBBBBBBGG577777777J#BPPPPPPPPPGGB###G!:.::::::::::::::::::::
36 ::::::::::::::::::::::.:Y####BBGB#GJ777???JJJJJJYJ7777777YBBPPPPPGGBB###BBBB##P?^.::::::::::::::::::
37 :::::::::::::::::::::.~5##BGGBB#####BP55YJJ??777777777?5B#BGGBBB###BBGGPPPPPGB##BY^.::::::::::::::::
38 :::::::::::::::::::::?B##GPPPPPPGGGGBB######BBBBGGGGBB#######BBBGGPPPPPPPPPPPPGB##B7.:::::::::::::::
39 ::::::::::::::::::::J##BGPPPPPPPPPPPPPPPPPGGGGGGBBBBBBGGGGGGPPPPPPPPPPPPPPPPPPPPG###J:::::::::::::::
40 ::::::::::::::::::.7##BPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPB##Y::::::::::::::
41 ::::::::::::::::::~B##PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPB##Y:::::::::::::
42 ::::::::::::::::::5##GPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPB##?.:::::::::::
43 :::::::::::::::::!##BPPPPGBGPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP##B~:::::::::::
44 :::::::::::::::::5##GPPPP##BPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGBBPPPPPPPPPPPPG##5:::::::::::
45 ::::::::::::::::~##BPPPPG##GPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG##GPPPPPPPPPPPPB##7.:::::::::
46 :::::::::::::::.J##GPPPPB##PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPB##PPPPPPPPPPPPG##G::::::::::
47 ::::::::::::::::G#BPPPPP##BPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG##BPPPPPPPPPPPPB##?.::::::::
48 :::::::::::::::!##BPPPPG##BPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPB##GPPPPPPPPPPPP##G^::::::::
49 ::::::::::::::.J##GPPPPG##BPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPG##BPPPPPPPPPPPPG##J.:::::::
50 :::::::::::::::5##GPPPPG##GPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPB##GPPPPPPPPPPPP##B^:::::::
51 */
52 
53 // File: @openzeppelin/contracts/utils/Context.sol
54 
55 
56 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev Provides information about the current execution context, including the
62  * sender of the transaction and its data. While these are generally available
63  * via msg.sender and msg.data, they should not be accessed in such a direct
64  * manner, since when dealing with meta-transactions the account sending and
65  * paying for execution may not be the actual sender (as far as an application
66  * is concerned).
67  *
68  * This contract is only required for intermediate, library-like contracts.
69  */
70 abstract contract Context {
71     function _msgSender() internal view virtual returns (address) {
72         return msg.sender;
73     }
74 
75     function _msgData() internal view virtual returns (bytes calldata) {
76         return msg.data;
77     }
78 }
79 
80 // File: @openzeppelin/contracts/access/Ownable.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @dev Contract module which provides a basic access control mechanism, where
90  * there is an account (an owner) that can be granted exclusive access to
91  * specific functions.
92  *
93  * By default, the owner account will be the one that deploys the contract. This
94  * can later be changed with {transferOwnership}.
95  *
96  * This module is used through inheritance. It will make available the modifier
97  * `onlyOwner`, which can be applied to your functions to restrict their use to
98  * the owner.
99  */
100 abstract contract Ownable is Context {
101     address private _owner;
102 
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     /**
106      * @dev Initializes the contract setting the deployer as the initial owner.
107      */
108     constructor() {
109         _transferOwnership(_msgSender());
110     }
111 
112     /**
113      * @dev Returns the address of the current owner.
114      */
115     function owner() public view virtual returns (address) {
116         return _owner;
117     }
118 
119     /**
120      * @dev Throws if called by any account other than the owner.
121      */
122     modifier onlyOwner() {
123         require(owner() == _msgSender(), "Ownable: caller is not the owner");
124         _;
125     }
126 
127     /**
128      * @dev Leaves the contract without owner. It will not be possible to call
129      * `onlyOwner` functions anymore. Can only be called by the current owner.
130      *
131      * NOTE: Renouncing ownership will leave the contract without an owner,
132      * thereby removing any functionality that is only available to the owner.
133      */
134     function renounceOwnership() public virtual onlyOwner {
135         _transferOwnership(address(0));
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
140      * Can only be called by the current owner.
141      */
142     function transferOwnership(address newOwner) public virtual onlyOwner {
143         require(newOwner != address(0), "Ownable: new owner is the zero address");
144         _transferOwnership(newOwner);
145     }
146 
147     /**
148      * @dev Transfers ownership of the contract to a new account (`newOwner`).
149      * Internal function without access restriction.
150      */
151     function _transferOwnership(address newOwner) internal virtual {
152         address oldOwner = _owner;
153         _owner = newOwner;
154         emit OwnershipTransferred(oldOwner, newOwner);
155     }
156 }
157 
158 // File: contracts/Strings.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @dev String operations.
167  */
168 library Strings {
169     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
170     uint8 private constant _ADDRESS_LENGTH = 20;
171 
172     /**
173      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
174      */
175     function toString(uint256 value) internal pure returns (string memory) {
176         // Inspired by OraclizeAPI's implementation - MIT licence
177         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
178 
179         if (value == 0) {
180             return "0";
181         }
182         uint256 temp = value;
183         uint256 digits;
184         while (temp != 0) {
185             digits++;
186             temp /= 10;
187         }
188         bytes memory buffer = new bytes(digits);
189         while (value != 0) {
190             digits -= 1;
191             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
192             value /= 10;
193         }
194         return string(buffer);
195     }
196 
197     /**
198      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
199      */
200     function toHexString(uint256 value) internal pure returns (string memory) {
201         if (value == 0) {
202             return "0x00";
203         }
204         uint256 temp = value;
205         uint256 length = 0;
206         while (temp != 0) {
207             length++;
208             temp >>= 8;
209         }
210         return toHexString(value, length);
211     }
212 
213     /**
214      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
215      */
216     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
217         bytes memory buffer = new bytes(2 * length + 2);
218         buffer[0] = "0";
219         buffer[1] = "x";
220         for (uint256 i = 2 * length + 1; i > 1; --i) {
221             buffer[i] = _HEX_SYMBOLS[value & 0xf];
222             value >>= 4;
223         }
224         require(value == 0, "Strings: hex length insufficient");
225         return string(buffer);
226     }
227 
228     /**
229      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
230      */
231     function toHexString(address addr) internal pure returns (string memory) {
232         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
233     }
234 }
235 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
236 
237 
238 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev These functions deal with verification of Merkle Trees proofs.
244  *
245  * The proofs can be generated using the JavaScript library
246  * https://github.com/miguelmota/merkletreejs[merkletreejs].
247  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
248  *
249  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
250  *
251  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
252  * hashing, or use a hash function other than keccak256 for hashing leaves.
253  * This is because the concatenation of a sorted pair of internal nodes in
254  * the merkle tree could be reinterpreted as a leaf value.
255  */
256 library MerkleProof {
257     /**
258      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
259      * defined by `root`. For this, a `proof` must be provided, containing
260      * sibling hashes on the branch from the leaf to the root of the tree. Each
261      * pair of leaves and each pair of pre-images are assumed to be sorted.
262      */
263     function verify(
264         bytes32[] memory proof,
265         bytes32 root,
266         bytes32 leaf
267     ) internal pure returns (bool) {
268         return processProof(proof, leaf) == root;
269     }
270 
271     /**
272      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
273      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
274      * hash matches the root of the tree. When processing the proof, the pairs
275      * of leafs & pre-images are assumed to be sorted.
276      *
277      * _Available since v4.4._
278      */
279     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
280         bytes32 computedHash = leaf;
281         for (uint256 i = 0; i < proof.length; i++) {
282             bytes32 proofElement = proof[i];
283             if (computedHash <= proofElement) {
284                 // Hash(current computed hash + current element of the proof)
285                 computedHash = _efficientHash(computedHash, proofElement);
286             } else {
287                 // Hash(current element of the proof + current computed hash)
288                 computedHash = _efficientHash(proofElement, computedHash);
289             }
290         }
291         return computedHash;
292     }
293 
294     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
295         assembly {
296             mstore(0x00, a)
297             mstore(0x20, b)
298             value := keccak256(0x00, 0x40)
299         }
300     }
301 }
302 
303 // File: erc721a/contracts/IERC721A.sol
304 
305 
306 // ERC721A Contracts v4.0.0
307 // Creator: Chiru Labs
308 
309 pragma solidity ^0.8.4;
310 
311 /**
312  * @dev Interface of an ERC721A compliant contract.
313  */
314 interface IERC721A {
315     /**
316      * The caller must own the token or be an approved operator.
317      */
318     error ApprovalCallerNotOwnerNorApproved();
319 
320     /**
321      * The token does not exist.
322      */
323     error ApprovalQueryForNonexistentToken();
324 
325     /**
326      * The caller cannot approve to their own address.
327      */
328     error ApproveToCaller();
329 
330     /**
331      * The caller cannot approve to the current owner.
332      */
333     error ApprovalToCurrentOwner();
334 
335     /**
336      * Cannot query the balance for the zero address.
337      */
338     error BalanceQueryForZeroAddress();
339 
340     /**
341      * Cannot mint to the zero address.
342      */
343     error MintToZeroAddress();
344 
345     /**
346      * The quantity of tokens minted must be more than zero.
347      */
348     error MintZeroQuantity();
349 
350     /**
351      * The token does not exist.
352      */
353     error OwnerQueryForNonexistentToken();
354 
355     /**
356      * The caller must own the token or be an approved operator.
357      */
358     error TransferCallerNotOwnerNorApproved();
359 
360     /**
361      * The token must be owned by `from`.
362      */
363     error TransferFromIncorrectOwner();
364 
365     /**
366      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
367      */
368     error TransferToNonERC721ReceiverImplementer();
369 
370     /**
371      * Cannot transfer to the zero address.
372      */
373     error TransferToZeroAddress();
374 
375     /**
376      * The token does not exist.
377      */
378     error URIQueryForNonexistentToken();
379 
380     struct TokenOwnership {
381         // The address of the owner.
382         address addr;
383         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
384         uint64 startTimestamp;
385         // Whether the token has been burned.
386         bool burned;
387     }
388 
389     /**
390      * @dev Returns the total amount of tokens stored by the contract.
391      *
392      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
393      */
394     function totalSupply() external view returns (uint256);
395 
396     // ==============================
397     //            IERC165
398     // ==============================
399 
400     /**
401      * @dev Returns true if this contract implements the interface defined by
402      * `interfaceId`. See the corresponding
403      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
404      * to learn more about how these ids are created.
405      *
406      * This function call must use less than 30 000 gas.
407      */
408     function supportsInterface(bytes4 interfaceId) external view returns (bool);
409 
410     // ==============================
411     //            IERC721
412     // ==============================
413 
414     /**
415      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
416      */
417     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
418 
419     /**
420      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
421      */
422     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
423 
424     /**
425      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
426      */
427     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
428 
429     /**
430      * @dev Returns the number of tokens in ``owner``'s account.
431      */
432     function balanceOf(address owner) external view returns (uint256 balance);
433 
434     /**
435      * @dev Returns the owner of the `tokenId` token.
436      *
437      * Requirements:
438      *
439      * - `tokenId` must exist.
440      */
441     function ownerOf(uint256 tokenId) external view returns (address owner);
442 
443     /**
444      * @dev Safely transfers `tokenId` token from `from` to `to`.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must exist and be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
453      *
454      * Emits a {Transfer} event.
455      */
456     function safeTransferFrom(
457         address from,
458         address to,
459         uint256 tokenId,
460         bytes calldata data
461     ) external;
462 
463     /**
464      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
465      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
466      *
467      * Requirements:
468      *
469      * - `from` cannot be the zero address.
470      * - `to` cannot be the zero address.
471      * - `tokenId` token must exist and be owned by `from`.
472      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
473      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
474      *
475      * Emits a {Transfer} event.
476      */
477     function safeTransferFrom(
478         address from,
479         address to,
480         uint256 tokenId
481     ) external;
482 
483     /**
484      * @dev Transfers `tokenId` token from `from` to `to`.
485      *
486      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
487      *
488      * Requirements:
489      *
490      * - `from` cannot be the zero address.
491      * - `to` cannot be the zero address.
492      * - `tokenId` token must be owned by `from`.
493      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
494      *
495      * Emits a {Transfer} event.
496      */
497     function transferFrom(
498         address from,
499         address to,
500         uint256 tokenId
501     ) external;
502 
503     /**
504      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
505      * The approval is cleared when the token is transferred.
506      *
507      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
508      *
509      * Requirements:
510      *
511      * - The caller must own the token or be an approved operator.
512      * - `tokenId` must exist.
513      *
514      * Emits an {Approval} event.
515      */
516     function approve(address to, uint256 tokenId) external;
517 
518     /**
519      * @dev Approve or remove `operator` as an operator for the caller.
520      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
521      *
522      * Requirements:
523      *
524      * - The `operator` cannot be the caller.
525      *
526      * Emits an {ApprovalForAll} event.
527      */
528     function setApprovalForAll(address operator, bool _approved) external;
529 
530     /**
531      * @dev Returns the account approved for `tokenId` token.
532      *
533      * Requirements:
534      *
535      * - `tokenId` must exist.
536      */
537     function getApproved(uint256 tokenId) external view returns (address operator);
538 
539     /**
540      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
541      *
542      * See {setApprovalForAll}
543      */
544     function isApprovedForAll(address owner, address operator) external view returns (bool);
545 
546     // ==============================
547     //        IERC721Metadata
548     // ==============================
549 
550     /**
551      * @dev Returns the token collection name.
552      */
553     function name() external view returns (string memory);
554 
555     /**
556      * @dev Returns the token collection symbol.
557      */
558     function symbol() external view returns (string memory);
559 
560     /**
561      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
562      */
563     function tokenURI(uint256 tokenId) external view returns (string memory);
564 }
565 
566 // File: erc721a/contracts/ERC721A.sol
567 
568 
569 // ERC721A Contracts v4.0.0
570 // Creator: Chiru Labs
571 
572 pragma solidity ^0.8.4;
573 
574 
575 /**
576  * @dev ERC721 token receiver interface.
577  */
578 interface ERC721A__IERC721Receiver {
579     function onERC721Received(
580         address operator,
581         address from,
582         uint256 tokenId,
583         bytes calldata data
584     ) external returns (bytes4);
585 }
586 
587 /**
588  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
589  * the Metadata extension. Built to optimize for lower gas during batch mints.
590  *
591  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
592  *
593  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
594  *
595  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
596  */
597 contract ERC721A is IERC721A {
598     // Mask of an entry in packed address data.
599     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
600 
601     // The bit position of `numberMinted` in packed address data.
602     uint256 private constant BITPOS_NUMBER_MINTED = 64;
603 
604     // The bit position of `numberBurned` in packed address data.
605     uint256 private constant BITPOS_NUMBER_BURNED = 128;
606 
607     // The bit position of `aux` in packed address data.
608     uint256 private constant BITPOS_AUX = 192;
609 
610     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
611     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
612 
613     // The bit position of `startTimestamp` in packed ownership.
614     uint256 private constant BITPOS_START_TIMESTAMP = 160;
615 
616     // The bit mask of the `burned` bit in packed ownership.
617     uint256 private constant BITMASK_BURNED = 1 << 224;
618     
619     // The bit position of the `nextInitialized` bit in packed ownership.
620     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
621 
622     // The bit mask of the `nextInitialized` bit in packed ownership.
623     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
624 
625     // The tokenId of the next token to be minted.
626     uint256 private _currentIndex;
627 
628     // The number of tokens burned.
629     uint256 private _burnCounter;
630 
631     // Token name
632     string private _name;
633 
634     // Token symbol
635     string private _symbol;
636 
637     // Mapping from token ID to ownership details
638     // An empty struct value does not necessarily mean the token is unowned.
639     // See `_packedOwnershipOf` implementation for details.
640     //
641     // Bits Layout:
642     // - [0..159]   `addr`
643     // - [160..223] `startTimestamp`
644     // - [224]      `burned`
645     // - [225]      `nextInitialized`
646     mapping(uint256 => uint256) private _packedOwnerships;
647 
648     // Mapping owner address to address data.
649     //
650     // Bits Layout:
651     // - [0..63]    `balance`
652     // - [64..127]  `numberMinted`
653     // - [128..191] `numberBurned`
654     // - [192..255] `aux`
655     mapping(address => uint256) private _packedAddressData;
656 
657     // Mapping from token ID to approved address.
658     mapping(uint256 => address) private _tokenApprovals;
659 
660     // Mapping from owner to operator approvals
661     mapping(address => mapping(address => bool)) private _operatorApprovals;
662 
663     constructor(string memory name_, string memory symbol_) {
664         _name = name_;
665         _symbol = symbol_;
666         _currentIndex = _startTokenId();
667     }
668 
669     /**
670      * @dev Returns the starting token ID. 
671      * To change the starting token ID, please override this function.
672      */
673     function _startTokenId() internal view virtual returns (uint256) {
674         return 0;
675     }
676 
677     /**
678      * @dev Returns the next token ID to be minted.
679      */
680     function _nextTokenId() internal view returns (uint256) {
681         return _currentIndex;
682     }
683 
684     /**
685      * @dev Returns the total number of tokens in existence.
686      * Burned tokens will reduce the count. 
687      * To get the total number of tokens minted, please see `_totalMinted`.
688      */
689     function totalSupply() public view override returns (uint256) {
690         // Counter underflow is impossible as _burnCounter cannot be incremented
691         // more than `_currentIndex - _startTokenId()` times.
692         unchecked {
693             return _currentIndex - _burnCounter - _startTokenId();
694         }
695     }
696 
697     /**
698      * @dev Returns the total amount of tokens minted in the contract.
699      */
700     function _totalMinted() internal view returns (uint256) {
701         // Counter underflow is impossible as _currentIndex does not decrement,
702         // and it is initialized to `_startTokenId()`
703         unchecked {
704             return _currentIndex - _startTokenId();
705         }
706     }
707 
708     /**
709      * @dev Returns the total number of tokens burned.
710      */
711     function _totalBurned() internal view returns (uint256) {
712         return _burnCounter;
713     }
714 
715     /**
716      * @dev See {IERC165-supportsInterface}.
717      */
718     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719         // The interface IDs are constants representing the first 4 bytes of the XOR of
720         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
721         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
722         return
723             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
724             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
725             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
726     }
727 
728     /**
729      * @dev See {IERC721-balanceOf}.
730      */
731     function balanceOf(address owner) public view override returns (uint256) {
732         if (owner == address(0)) revert BalanceQueryForZeroAddress();
733         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
734     }
735 
736     /**
737      * Returns the number of tokens minted by `owner`.
738      */
739     function _numberMinted(address owner) internal view returns (uint256) {
740         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
741     }
742 
743     /**
744      * Returns the number of tokens burned by or on behalf of `owner`.
745      */
746     function _numberBurned(address owner) internal view returns (uint256) {
747         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
748     }
749 
750     /**
751      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
752      */
753     function _getAux(address owner) internal view returns (uint64) {
754         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
755     }
756 
757     /**
758      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
759      * If there are multiple variables, please pack them into a uint64.
760      */
761     function _setAux(address owner, uint64 aux) internal {
762         uint256 packed = _packedAddressData[owner];
763         uint256 auxCasted;
764         assembly { // Cast aux without masking.
765             auxCasted := aux
766         }
767         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
768         _packedAddressData[owner] = packed;
769     }
770 
771     /**
772      * Returns the packed ownership data of `tokenId`.
773      */
774     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
775         uint256 curr = tokenId;
776 
777         unchecked {
778             if (_startTokenId() <= curr)
779                 if (curr < _currentIndex) {
780                     uint256 packed = _packedOwnerships[curr];
781                     // If not burned.
782                     if (packed & BITMASK_BURNED == 0) {
783                         // Invariant:
784                         // There will always be an ownership that has an address and is not burned
785                         // before an ownership that does not have an address and is not burned.
786                         // Hence, curr will not underflow.
787                         //
788                         // We can directly compare the packed value.
789                         // If the address is zero, packed is zero.
790                         while (packed == 0) {
791                             packed = _packedOwnerships[--curr];
792                         }
793                         return packed;
794                     }
795                 }
796         }
797         revert OwnerQueryForNonexistentToken();
798     }
799 
800     /**
801      * Returns the unpacked `TokenOwnership` struct from `packed`.
802      */
803     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
804         ownership.addr = address(uint160(packed));
805         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
806         ownership.burned = packed & BITMASK_BURNED != 0;
807     }
808 
809     /**
810      * Returns the unpacked `TokenOwnership` struct at `index`.
811      */
812     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
813         return _unpackedOwnership(_packedOwnerships[index]);
814     }
815 
816     /**
817      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
818      */
819     function _initializeOwnershipAt(uint256 index) internal {
820         if (_packedOwnerships[index] == 0) {
821             _packedOwnerships[index] = _packedOwnershipOf(index);
822         }
823     }
824 
825     /**
826      * Gas spent here starts off proportional to the maximum mint batch size.
827      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
828      */
829     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
830         return _unpackedOwnership(_packedOwnershipOf(tokenId));
831     }
832 
833     /**
834      * @dev See {IERC721-ownerOf}.
835      */
836     function ownerOf(uint256 tokenId) public view override returns (address) {
837         return address(uint160(_packedOwnershipOf(tokenId)));
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-name}.
842      */
843     function name() public view virtual override returns (string memory) {
844         return _name;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-symbol}.
849      */
850     function symbol() public view virtual override returns (string memory) {
851         return _symbol;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-tokenURI}.
856      */
857     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
858         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
859 
860         string memory baseURI = _baseURI();
861         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
862     }
863 
864     /**
865      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
866      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
867      * by default, can be overriden in child contracts.
868      */
869     function _baseURI() internal view virtual returns (string memory) {
870         return '';
871     }
872 
873     /**
874      * @dev Casts the address to uint256 without masking.
875      */
876     function _addressToUint256(address value) private pure returns (uint256 result) {
877         assembly {
878             result := value
879         }
880     }
881 
882     /**
883      * @dev Casts the boolean to uint256 without branching.
884      */
885     function _boolToUint256(bool value) private pure returns (uint256 result) {
886         assembly {
887             result := value
888         }
889     }
890 
891     /**
892      * @dev See {IERC721-approve}.
893      */
894     function approve(address to, uint256 tokenId) public override {
895         address owner = address(uint160(_packedOwnershipOf(tokenId)));
896         if (to == owner) revert ApprovalToCurrentOwner();
897 
898         if (_msgSenderERC721A() != owner)
899             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
900                 revert ApprovalCallerNotOwnerNorApproved();
901             }
902 
903         _tokenApprovals[tokenId] = to;
904         emit Approval(owner, to, tokenId);
905     }
906 
907     /**
908      * @dev See {IERC721-getApproved}.
909      */
910     function getApproved(uint256 tokenId) public view override returns (address) {
911         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
912 
913         return _tokenApprovals[tokenId];
914     }
915 
916     /**
917      * @dev See {IERC721-setApprovalForAll}.
918      */
919     function setApprovalForAll(address operator, bool approved) public virtual override {
920         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
921 
922         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
923         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
924     }
925 
926     /**
927      * @dev See {IERC721-isApprovedForAll}.
928      */
929     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
930         return _operatorApprovals[owner][operator];
931     }
932 
933     /**
934      * @dev See {IERC721-transferFrom}.
935      */
936     function transferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public virtual override {
941         _transfer(from, to, tokenId);
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId
951     ) public virtual override {
952         safeTransferFrom(from, to, tokenId, '');
953     }
954 
955     /**
956      * @dev See {IERC721-safeTransferFrom}.
957      */
958     function safeTransferFrom(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) public virtual override {
964         _transfer(from, to, tokenId);
965         if (to.code.length != 0)
966             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
967                 revert TransferToNonERC721ReceiverImplementer();
968             }
969     }
970 
971     /**
972      * @dev Returns whether `tokenId` exists.
973      *
974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975      *
976      * Tokens start existing when they are minted (`_mint`),
977      */
978     function _exists(uint256 tokenId) internal view returns (bool) {
979         return
980             _startTokenId() <= tokenId &&
981             tokenId < _currentIndex && // If within bounds,
982             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
983     }
984 
985     /**
986      * @dev Equivalent to `_safeMint(to, quantity, '')`.
987      */
988     function _safeMint(address to, uint256 quantity) internal {
989         _safeMint(to, quantity, '');
990     }
991 
992     /**
993      * @dev Safely mints `quantity` tokens and transfers them to `to`.
994      *
995      * Requirements:
996      *
997      * - If `to` refers to a smart contract, it must implement
998      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
999      * - `quantity` must be greater than 0.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _safeMint(
1004         address to,
1005         uint256 quantity,
1006         bytes memory _data
1007     ) internal {
1008         uint256 startTokenId = _currentIndex;
1009         if (to == address(0)) revert MintToZeroAddress();
1010         if (quantity == 0) revert MintZeroQuantity();
1011 
1012         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1013 
1014         // Overflows are incredibly unrealistic.
1015         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1016         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1017         unchecked {
1018             // Updates:
1019             // - `balance += quantity`.
1020             // - `numberMinted += quantity`.
1021             //
1022             // We can directly add to the balance and number minted.
1023             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1024 
1025             // Updates:
1026             // - `address` to the owner.
1027             // - `startTimestamp` to the timestamp of minting.
1028             // - `burned` to `false`.
1029             // - `nextInitialized` to `quantity == 1`.
1030             _packedOwnerships[startTokenId] =
1031                 _addressToUint256(to) |
1032                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1033                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1034 
1035             uint256 updatedIndex = startTokenId;
1036             uint256 end = updatedIndex + quantity;
1037 
1038             if (to.code.length != 0) {
1039                 do {
1040                     emit Transfer(address(0), to, updatedIndex);
1041                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1042                         revert TransferToNonERC721ReceiverImplementer();
1043                     }
1044                 } while (updatedIndex < end);
1045                 // Reentrancy protection
1046                 if (_currentIndex != startTokenId) revert();
1047             } else {
1048                 do {
1049                     emit Transfer(address(0), to, updatedIndex++);
1050                 } while (updatedIndex < end);
1051             }
1052             _currentIndex = updatedIndex;
1053         }
1054         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1055     }
1056 
1057     /**
1058      * @dev Mints `quantity` tokens and transfers them to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `quantity` must be greater than 0.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _mint(address to, uint256 quantity) internal {
1068         uint256 startTokenId = _currentIndex;
1069         if (to == address(0)) revert MintToZeroAddress();
1070         if (quantity == 0) revert MintZeroQuantity();
1071 
1072         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1073 
1074         // Overflows are incredibly unrealistic.
1075         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1076         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1077         unchecked {
1078             // Updates:
1079             // - `balance += quantity`.
1080             // - `numberMinted += quantity`.
1081             //
1082             // We can directly add to the balance and number minted.
1083             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1084 
1085             // Updates:
1086             // - `address` to the owner.
1087             // - `startTimestamp` to the timestamp of minting.
1088             // - `burned` to `false`.
1089             // - `nextInitialized` to `quantity == 1`.
1090             _packedOwnerships[startTokenId] =
1091                 _addressToUint256(to) |
1092                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1093                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1094 
1095             uint256 updatedIndex = startTokenId;
1096             uint256 end = updatedIndex + quantity;
1097 
1098             do {
1099                 emit Transfer(address(0), to, updatedIndex++);
1100             } while (updatedIndex < end);
1101 
1102             _currentIndex = updatedIndex;
1103         }
1104         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1105     }
1106 
1107     /**
1108      * @dev Transfers `tokenId` from `from` to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must be owned by `from`.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _transfer(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) private {
1122         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1123 
1124         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1125 
1126         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1127             isApprovedForAll(from, _msgSenderERC721A()) ||
1128             getApproved(tokenId) == _msgSenderERC721A());
1129 
1130         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1131         if (to == address(0)) revert TransferToZeroAddress();
1132 
1133         _beforeTokenTransfers(from, to, tokenId, 1);
1134 
1135         // Clear approvals from the previous owner.
1136         delete _tokenApprovals[tokenId];
1137 
1138         // Underflow of the sender's balance is impossible because we check for
1139         // ownership above and the recipient's balance can't realistically overflow.
1140         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1141         unchecked {
1142             // We can directly increment and decrement the balances.
1143             --_packedAddressData[from]; // Updates: `balance -= 1`.
1144             ++_packedAddressData[to]; // Updates: `balance += 1`.
1145 
1146             // Updates:
1147             // - `address` to the next owner.
1148             // - `startTimestamp` to the timestamp of transfering.
1149             // - `burned` to `false`.
1150             // - `nextInitialized` to `true`.
1151             _packedOwnerships[tokenId] =
1152                 _addressToUint256(to) |
1153                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1154                 BITMASK_NEXT_INITIALIZED;
1155 
1156             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1157             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1158                 uint256 nextTokenId = tokenId + 1;
1159                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1160                 if (_packedOwnerships[nextTokenId] == 0) {
1161                     // If the next slot is within bounds.
1162                     if (nextTokenId != _currentIndex) {
1163                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1164                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1165                     }
1166                 }
1167             }
1168         }
1169 
1170         emit Transfer(from, to, tokenId);
1171         _afterTokenTransfers(from, to, tokenId, 1);
1172     }
1173 
1174     /**
1175      * @dev Equivalent to `_burn(tokenId, false)`.
1176      */
1177     function _burn(uint256 tokenId) internal virtual {
1178         _burn(tokenId, false);
1179     }
1180 
1181     /**
1182      * @dev Destroys `tokenId`.
1183      * The approval is cleared when the token is burned.
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must exist.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1192         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1193 
1194         address from = address(uint160(prevOwnershipPacked));
1195 
1196         if (approvalCheck) {
1197             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1198                 isApprovedForAll(from, _msgSenderERC721A()) ||
1199                 getApproved(tokenId) == _msgSenderERC721A());
1200 
1201             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1202         }
1203 
1204         _beforeTokenTransfers(from, address(0), tokenId, 1);
1205 
1206         // Clear approvals from the previous owner.
1207         delete _tokenApprovals[tokenId];
1208 
1209         // Underflow of the sender's balance is impossible because we check for
1210         // ownership above and the recipient's balance can't realistically overflow.
1211         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1212         unchecked {
1213             // Updates:
1214             // - `balance -= 1`.
1215             // - `numberBurned += 1`.
1216             //
1217             // We can directly decrement the balance, and increment the number burned.
1218             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1219             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1220 
1221             // Updates:
1222             // - `address` to the last owner.
1223             // - `startTimestamp` to the timestamp of burning.
1224             // - `burned` to `true`.
1225             // - `nextInitialized` to `true`.
1226             _packedOwnerships[tokenId] =
1227                 _addressToUint256(from) |
1228                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1229                 BITMASK_BURNED | 
1230                 BITMASK_NEXT_INITIALIZED;
1231 
1232             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1233             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1234                 uint256 nextTokenId = tokenId + 1;
1235                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1236                 if (_packedOwnerships[nextTokenId] == 0) {
1237                     // If the next slot is within bounds.
1238                     if (nextTokenId != _currentIndex) {
1239                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1240                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1241                     }
1242                 }
1243             }
1244         }
1245 
1246         emit Transfer(from, address(0), tokenId);
1247         _afterTokenTransfers(from, address(0), tokenId, 1);
1248 
1249         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1250         unchecked {
1251             _burnCounter++;
1252         }
1253     }
1254 
1255     /**
1256      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1257      *
1258      * @param from address representing the previous owner of the given token ID
1259      * @param to target address that will receive the tokens
1260      * @param tokenId uint256 ID of the token to be transferred
1261      * @param _data bytes optional data to send along with the call
1262      * @return bool whether the call correctly returned the expected magic value
1263      */
1264     function _checkContractOnERC721Received(
1265         address from,
1266         address to,
1267         uint256 tokenId,
1268         bytes memory _data
1269     ) private returns (bool) {
1270         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1271             bytes4 retval
1272         ) {
1273             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1274         } catch (bytes memory reason) {
1275             if (reason.length == 0) {
1276                 revert TransferToNonERC721ReceiverImplementer();
1277             } else {
1278                 assembly {
1279                     revert(add(32, reason), mload(reason))
1280                 }
1281             }
1282         }
1283     }
1284 
1285     /**
1286      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1287      * And also called before burning one token.
1288      *
1289      * startTokenId - the first token id to be transferred
1290      * quantity - the amount to be transferred
1291      *
1292      * Calling conditions:
1293      *
1294      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1295      * transferred to `to`.
1296      * - When `from` is zero, `tokenId` will be minted for `to`.
1297      * - When `to` is zero, `tokenId` will be burned by `from`.
1298      * - `from` and `to` are never both zero.
1299      */
1300     function _beforeTokenTransfers(
1301         address from,
1302         address to,
1303         uint256 startTokenId,
1304         uint256 quantity
1305     ) internal virtual {}
1306 
1307     /**
1308      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1309      * minting.
1310      * And also called after one token has been burned.
1311      *
1312      * startTokenId - the first token id to be transferred
1313      * quantity - the amount to be transferred
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` has been minted for `to`.
1320      * - When `to` is zero, `tokenId` has been burned by `from`.
1321      * - `from` and `to` are never both zero.
1322      */
1323     function _afterTokenTransfers(
1324         address from,
1325         address to,
1326         uint256 startTokenId,
1327         uint256 quantity
1328     ) internal virtual {}
1329 
1330     /**
1331      * @dev Returns the message sender (defaults to `msg.sender`).
1332      *
1333      * If you are writing GSN compatible contracts, you need to override this function.
1334      */
1335     function _msgSenderERC721A() internal view virtual returns (address) {
1336         return msg.sender;
1337     }
1338 
1339     /**
1340      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1341      */
1342     function _toString(uint256 value) internal pure returns (string memory ptr) {
1343         assembly {
1344             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1345             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1346             // We will need 1 32-byte word to store the length, 
1347             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1348             ptr := add(mload(0x40), 128)
1349             // Update the free memory pointer to allocate.
1350             mstore(0x40, ptr)
1351 
1352             // Cache the end of the memory to calculate the length later.
1353             let end := ptr
1354 
1355             // We write the string from the rightmost digit to the leftmost digit.
1356             // The following is essentially a do-while loop that also handles the zero case.
1357             // Costs a bit more than early returning for the zero case,
1358             // but cheaper in terms of deployment and overall runtime costs.
1359             for { 
1360                 // Initialize and perform the first pass without check.
1361                 let temp := value
1362                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1363                 ptr := sub(ptr, 1)
1364                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1365                 mstore8(ptr, add(48, mod(temp, 10)))
1366                 temp := div(temp, 10)
1367             } temp { 
1368                 // Keep dividing `temp` until zero.
1369                 temp := div(temp, 10)
1370             } { // Body of the for loop.
1371                 ptr := sub(ptr, 1)
1372                 mstore8(ptr, add(48, mod(temp, 10)))
1373             }
1374             
1375             let length := sub(end, ptr)
1376             // Move the pointer 32 bytes leftwards to make room for the length.
1377             ptr := sub(ptr, 32)
1378             // Store the length.
1379             mstore(ptr, length)
1380         }
1381     }
1382 }
1383 
1384 // File: contracts/okaybearcubs.sol
1385 
1386 
1387 
1388 pragma solidity ^0.8.4;
1389 
1390 
1391 
1392 contract okaybearcubs is ERC721A, Ownable {
1393     using Strings for uint256;
1394 
1395     string public  baseTokenUri;
1396     string public  placeholderTokenUri;
1397     string public baseExtension = ".json";
1398 
1399     uint public maxSupply = 10000;
1400     uint256 public maxMintAmount = 5;
1401     bool public revealed = false;
1402     bool public onlyWhitelist = false;
1403     bool public pause = false;
1404 
1405     uint public cost = 0.0025 ether;
1406     mapping(address=>bool) public hasClaimed;
1407     mapping(address=>bool) public whitelisted;
1408 
1409     constructor(string memory _baseTokenURI, string memory _placeholderURI) ERC721A("okaybearcubs", "OKBC") {
1410         baseTokenUri = _baseTokenURI;
1411         placeholderTokenUri = _placeholderURI;
1412     }
1413 
1414     function paused(bool _val) external onlyOwner {
1415         pause = _val;
1416     }
1417 
1418     function onlyWhitelisted(bool _val) external onlyOwner{
1419         onlyWhitelist = _val;
1420     }
1421 
1422     function reveal(bool _val) external onlyOwner {
1423         revealed = _val;
1424     } 
1425     
1426     function mint(uint256 quantity) external payable{
1427         require(!pause, "contract is paused!");
1428         require(quantity != 0, "please increase quantity from zero!");
1429         require(quantity <= maxMintAmount);
1430         require(totalSupply() + quantity <= maxSupply, "exceding total supply");
1431 
1432         if (onlyWhitelist) {
1433             require(whitelisted[msg.sender], "not in whitelist");
1434              internalLogic(quantity);
1435         } else {
1436             internalLogic(quantity);
1437         }
1438     }
1439 
1440     function internalLogic(uint quantity) private {
1441         if(quantity == 1 && !hasClaimed[msg.sender]) {
1442             require(hasClaimed[msg.sender] == false, "already claimed");
1443             hasClaimed[msg.sender] = true;
1444             _mint(msg.sender, quantity);
1445         } else if (quantity == 1 && hasClaimed[msg.sender]) {
1446             require(msg.value >= cost, "not enough balance!");
1447             _mint(msg.sender, quantity);
1448         } else {
1449             if(hasClaimed[msg.sender] == false) {
1450             hasClaimed[msg.sender] = true;
1451             uint totalQToCalculate = quantity - 1;
1452             uint tCost = cost * totalQToCalculate;
1453             require(msg.value >= tCost, "not enough balance to mint!");
1454             _mint(msg.sender, quantity);
1455             } else {
1456                 require(msg.value >= cost * quantity, "insufficient balance!");
1457                  _mint(msg.sender, quantity);
1458             }       
1459         }
1460 
1461     }
1462 
1463     function tokenURI(uint256 tokenId)
1464     public
1465     view
1466     virtual
1467     override
1468     returns (string memory)
1469   {
1470     require(
1471       _exists(tokenId),
1472       "ERC721Metadata: URI query for nonexistent token"
1473     );
1474     
1475     if(revealed == false) {
1476         return placeholderTokenUri;
1477     }
1478     uint256 trueId = tokenId + 1;
1479 
1480     return bytes(baseTokenUri).length > 0
1481         ? string(abi.encodePacked(baseTokenUri, trueId.toString(), baseExtension))
1482         : "";
1483   }
1484 
1485 
1486   function setTokenUri(string memory _baseTokenUri) external onlyOwner {
1487         baseTokenUri = _baseTokenUri;
1488     }
1489     function setPlaceHolderUri(string memory _placeholderTokenUri) external onlyOwner {
1490         placeholderTokenUri = _placeholderTokenUri;
1491     }
1492 
1493     function addWhitelisted(address[] memory accounts) external onlyOwner {
1494 
1495     for (uint256 account = 0; account < accounts.length; account++) {
1496         whitelisted[accounts[account]] = true;
1497     }
1498 }
1499     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1500     maxMintAmount = _newmaxMintAmount;
1501         }
1502 
1503     function setCost(uint256 _newCost) public onlyOwner {
1504     cost = _newCost;
1505          }
1506          
1507     function withdraw() external payable onlyOwner {
1508     (bool os, ) = payable(msg.sender).call{value: address(this).balance}("");
1509     require(os);
1510   }
1511 }