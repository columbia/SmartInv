1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.0;
3 
4 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
5 //                                                                                                            //
6 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
7 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
8 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
9 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
10 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
11 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
12 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
13 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
14 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
15 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
16 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
17 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM@"7HMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
18 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMF   .MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
19 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\   -MMMMMMMMMMMMMMMMMMMMF   JMMMMMMMMMMMMMMMMMMMMMMM    //
20 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM#    MMMMMMMMMMMMMMMMMMMMM\   .MMMMMMMMMMMMMMMMMMMMMMM    //
21 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM]   .MMMMMMMMMMMMMMMMMMMMM`    dMMMMMMMMMMMMMMMMMMMMMM    //
22 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    dMMMH""7!      ?MMMMM#     -MMMMMMMMMMMMMMMMMMMMMM    //
23 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMF    ^              .MMMMM#      MMMMMMMMMMMMMMMMMMMMMM    //
24 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM#"`         .....g+, .MMMMMMF      dMMMMMMMMMMMMMMMMMMMMM    //
25 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM#"`       ..JMMMMMMMMMMMMMMMMMMM\      ,MMMMMMMMMMMMMMMMMMMMM    //
26 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMH"!          (MMMMMMMMMMMMMMMMD`_TMM!       MMMMMMMMMMMMMMMMMMMMM    //
27 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMB^      ..g#   .MMMMMMMMMMMMMMMM#    UM    ;   JMMMMMMMMMMMMMMMMMMMM    //
28 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMM9'      ..MMMM%   .MMMMMMMMMMMMMMMMF     E   .b   .MMMMMMMMMMMMMMMMMMMM    //
29 //    MMMMMMMMMMMMMMMMMMMMMMMMMM"!      .dMMMMMM#    MMMMMMMMMMMMMMMMM]         .M.   HMMMMMMMMMMMMMMMMMMM    //
30 //    MMMMMMMMMMMMMMMMMMMMMMM@!     ... dMMMMMMM]   .MMMMMMMMMMMMMMMMM:         -M]   -MMMMMMMMMMMMMMMMMMM    //
31 //    MMMMMMMMMMMMMMMMMMMM#=        .MN.MMMMMMMM    dMMMMMY"HMMMMMMMMM          dM#    MMMMMMMMMMMMMMMMMMM    //
32 //    MMMMMMMMMMMMMMMMMM@!    ..M,    WMMMMMMMMF   .MMY"`    dMMMMMMM#   .b     MMM,   dMMMMMMMMMMMMMMMMMM    //
33 //    MMMMMMMMMMMMMMMMD`    .dMMMMp    TMMMMMMM!   (`              ?MF   .Mc    MMMb   ,MMMMMMMMMMMMMMMMMM    //
34 //    MMMMMMMMMMMMMMD`    .NMMMMMMMR    ?MMMMMF        ..:           !   (MN.  .MMMN    MMMMMMMMMMMMMMMMMM    //
35 //    MMMMMMMMMMMMMF    .dMMMMMMMMMMN.   ,MMMM>     .gMMF   .MMMMh       dMM[  MMMMM|   JMMMMMMMMMMMMMMMMM    //
36 //    MMMMMMMMMMMMMM,  .MMMMMMMMMMMMMN,   .MM#        TM]   -MMMMM!      MMMM..MMMMMb   .MMMMMMMMMMMMMMMMM    //
37 //    MMMMMMMMMMMMMMN  dMMMMMMMMMMMMMMM,    W%   .,     7    TMM#=      .MMMM..MMMMMM    HMMMMMMMMMMMMMMMM    //
38 //    MMMMMMMMMMMMMMM..MMMMMMMMMMMMMMMMMp        MMMa               `   .MMMMMMMMMMMN    -MMMMMMMMMMMMMMMM    //
39 //    MMMMMMMMMMMMMMM`.MMMMMMMMMMMMMMMMMMb      .MMMMNa,     .    .d\   (MMMMMMMMMMMMN    MMMMMMMMMMMMMMMM    //
40 //    MMMMMMMMMMMMMMM  MMMMMMMMMMMMMMMMMMMN.    dMMMMMMMN,  .MMMaJMMh. .MMMMMMMMMMMMMN    dMMMMMMMMMMMMMMM    //
41 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN    JMMMMMMMMM- MMMMMMMMMb.MMMMMMMMMMMMMMMb  .MMMMMMMMMMMMMMMM    //
42 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN. JMMMMMMMMMM].MMMMMMMMMMMMMMMMMMMMMMMMMMM| MMMMMMMMMMMMMMMMM    //
43 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM].MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMF MMMMMMMMMMMMMMMMM    //
44 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMgMMMMMMMMMMMMMMMMM    //
45 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM: MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
46 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMmJMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
47 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
48 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
49 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
50 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
51 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
52 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
53 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
54 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
55 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
56 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
57 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
58 //                                                                                                            //
59 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
60 
61 interface AggregatorV3Interface {
62 
63   function decimals()
64     external
65     view
66     returns (
67       uint8
68     );
69 
70   function description()
71     external
72     view
73     returns (
74       string memory
75     );
76 
77   function version()
78     external
79     view
80     returns (
81       uint256
82     );
83 
84   // getRoundData and latestRoundData should both raise "No data present"
85   // if they do not have data to report, instead of returning unset values
86   // which could be misinterpreted as actual reported values.
87   function getRoundData(
88     uint80 _roundId
89   )
90     external
91     view
92     returns (
93       uint80 roundId,
94       int256 answer,
95       uint256 startedAt,
96       uint256 updatedAt,
97       uint80 answeredInRound
98     );
99 
100   function latestRoundData()
101     external
102     view
103     returns (
104       uint80 roundId,
105       int256 answer,
106       uint256 startedAt,
107       uint256 updatedAt,
108       uint80 answeredInRound
109     );
110 
111 }
112 
113 
114 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
115 
116 
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev String operations.
122  */
123 library Strings {
124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
128      */
129     function toString(uint256 value) internal pure returns (string memory) {
130         // Inspired by OraclizeAPI's implementation - MIT licence
131         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
132 
133         if (value == 0) {
134             return "0";
135         }
136         uint256 temp = value;
137         uint256 digits;
138         while (temp != 0) {
139             digits++;
140             temp /= 10;
141         }
142         bytes memory buffer = new bytes(digits);
143         while (value != 0) {
144             digits -= 1;
145             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
146             value /= 10;
147         }
148         return string(buffer);
149     }
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
153      */
154     function toHexString(uint256 value) internal pure returns (string memory) {
155         if (value == 0) {
156             return "0x00";
157         }
158         uint256 temp = value;
159         uint256 length = 0;
160         while (temp != 0) {
161             length++;
162             temp >>= 8;
163         }
164         return toHexString(value, length);
165     }
166 
167     /**
168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
169      */
170     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
171         bytes memory buffer = new bytes(2 * length + 2);
172         buffer[0] = "0";
173         buffer[1] = "x";
174         for (uint256 i = 2 * length + 1; i > 1; --i) {
175             buffer[i] = _HEX_SYMBOLS[value & 0xf];
176             value >>= 4;
177         }
178         require(value == 0, "Strings: hex length insufficient");
179         return string(buffer);
180     }
181 }
182 
183 
184 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.2
185 
186 
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev Contract module that helps prevent reentrant calls to a function.
192  *
193  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
194  * available, which can be applied to functions to make sure there are no nested
195  * (reentrant) calls to them.
196  *
197  * Note that because there is a single `nonReentrant` guard, functions marked as
198  * `nonReentrant` may not call one another. This can be worked around by making
199  * those functions `private`, and then adding `external` `nonReentrant` entry
200  * points to them.
201  *
202  * TIP: If you would like to learn more about reentrancy and alternative ways
203  * to protect against it, check out our blog post
204  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
205  */
206 abstract contract ReentrancyGuard {
207     // Booleans are more expensive than uint256 or any type that takes up a full
208     // word because each write operation emits an extra SLOAD to first read the
209     // slot's contents, replace the bits taken up by the boolean, and then write
210     // back. This is the compiler's defense against contract upgrades and
211     // pointer aliasing, and it cannot be disabled.
212 
213     // The values being non-zero value makes deployment a bit more expensive,
214     // but in exchange the refund on every call to nonReentrant will be lower in
215     // amount. Since refunds are capped to a percentage of the total
216     // transaction's gas, it is best to keep them low in cases like this one, to
217     // increase the likelihood of the full refund coming into effect.
218     uint256 private constant _NOT_ENTERED = 1;
219     uint256 private constant _ENTERED = 2;
220 
221     uint256 private _status;
222 
223     constructor() {
224         _status = _NOT_ENTERED;
225     }
226 
227     /**
228      * @dev Prevents a contract from calling itself, directly or indirectly.
229      * Calling a `nonReentrant` function from another `nonReentrant`
230      * function is not supported. It is possible to prevent this from happening
231      * by making the `nonReentrant` function external, and make it call a
232      * `private` function that does the actual work.
233      */
234     modifier nonReentrant() {
235         // On the first call to nonReentrant, _notEntered will be true
236         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
237 
238         // Any calls to nonReentrant after this point will fail
239         _status = _ENTERED;
240 
241         _;
242 
243         // By storing the original value once again, a refund is triggered (see
244         // https://eips.ethereum.org/EIPS/eip-2200)
245         _status = _NOT_ENTERED;
246     }
247 }
248 
249 
250 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
251 
252 
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev Provides information about the current execution context, including the
258  * sender of the transaction and its data. While these are generally available
259  * via msg.sender and msg.data, they should not be accessed in such a direct
260  * manner, since when dealing with meta-transactions the account sending and
261  * paying for execution may not be the actual sender (as far as an application
262  * is concerned).
263  *
264  * This contract is only required for intermediate, library-like contracts.
265  */
266 abstract contract Context {
267     function _msgSender() internal view virtual returns (address) {
268         return msg.sender;
269     }
270 
271     function _msgData() internal view virtual returns (bytes calldata) {
272         return msg.data;
273     }
274 }
275 
276 
277 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
278 
279 
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @dev Contract module which provides a basic access control mechanism, where
285  * there is an account (an owner) that can be granted exclusive access to
286  * specific functions.
287  *
288  * By default, the owner account will be the one that deploys the contract. This
289  * can later be changed with {transferOwnership}.
290  *
291  * This module is used through inheritance. It will make available the modifier
292  * `onlyOwner`, which can be applied to your functions to restrict their use to
293  * the owner.
294  */
295 abstract contract Ownable is Context {
296     address private _owner;
297 
298     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
299 
300     /**
301      * @dev Initializes the contract setting the deployer as the initial owner.
302      */
303     constructor() {
304         _setOwner(_msgSender());
305     }
306 
307     /**
308      * @dev Returns the address of the current owner.
309      */
310     function owner() public view virtual returns (address) {
311         return _owner;
312     }
313 
314     /**
315      * @dev Throws if called by any account other than the owner.
316      */
317     modifier onlyOwner() {
318         require(owner() == _msgSender(), "Ownable: caller is not the owner");
319         _;
320     }
321 
322     /**
323      * @dev Leaves the contract without owner. It will not be possible to call
324      * `onlyOwner` functions anymore. Can only be called by the current owner.
325      *
326      * NOTE: Renouncing ownership will leave the contract without an owner,
327      * thereby removing any functionality that is only available to the owner.
328      */
329     function renounceOwnership() public virtual onlyOwner {
330         _setOwner(address(0));
331     }
332 
333     /**
334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
335      * Can only be called by the current owner.
336      */
337     function transferOwnership(address newOwner) public virtual onlyOwner {
338         require(newOwner != address(0), "Ownable: new owner is the zero address");
339         _setOwner(newOwner);
340     }
341 
342     function _setOwner(address newOwner) private {
343         address oldOwner = _owner;
344         _owner = newOwner;
345         emit OwnershipTransferred(oldOwner, newOwner);
346     }
347 }
348 
349 
350 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.3.2
351 
352 
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev These functions deal with verification of Merkle Trees proofs.
358  *
359  * The proofs can be generated using the JavaScript library
360  * https://github.com/miguelmota/merkletreejs[merkletreejs].
361  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
362  *
363  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
364  */
365 library MerkleProof {
366     /**
367      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
368      * defined by `root`. For this, a `proof` must be provided, containing
369      * sibling hashes on the branch from the leaf to the root of the tree. Each
370      * pair of leaves and each pair of pre-images are assumed to be sorted.
371      */
372     function verify(
373         bytes32[] memory proof,
374         bytes32 root,
375         bytes32 leaf
376     ) internal pure returns (bool) {
377         bytes32 computedHash = leaf;
378 
379         for (uint256 i = 0; i < proof.length; i++) {
380             bytes32 proofElement = proof[i];
381 
382             if (computedHash <= proofElement) {
383                 // Hash(current computed hash + current element of the proof)
384                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
385             } else {
386                 // Hash(current element of the proof + current computed hash)
387                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
388             }
389         }
390 
391         // Check if the computed hash (root) is equal to the provided root
392         return computedHash == root;
393     }
394 }
395 
396 
397 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
398 
399 
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev Interface of the ERC165 standard, as defined in the
405  * https://eips.ethereum.org/EIPS/eip-165[EIP].
406  *
407  * Implementers can declare support of contract interfaces, which can then be
408  * queried by others ({ERC165Checker}).
409  *
410  * For an implementation, see {ERC165}.
411  */
412 interface IERC165 {
413     /**
414      * @dev Returns true if this contract implements the interface defined by
415      * `interfaceId`. See the corresponding
416      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
417      * to learn more about how these ids are created.
418      *
419      * This function call must use less than 30 000 gas.
420      */
421     function supportsInterface(bytes4 interfaceId) external view returns (bool);
422 }
423 
424 
425 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
426 
427 
428 
429 pragma solidity ^0.8.0;
430 
431 /**
432  * @dev Required interface of an ERC721 compliant contract.
433  */
434 interface IERC721 is IERC165 {
435     /**
436      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
437      */
438     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
439 
440     /**
441      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
442      */
443     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
444 
445     /**
446      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
447      */
448     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
449 
450     /**
451      * @dev Returns the number of tokens in ``owner``'s account.
452      */
453     function balanceOf(address owner) external view returns (uint256 balance);
454 
455     /**
456      * @dev Returns the owner of the `tokenId` token.
457      *
458      * Requirements:
459      *
460      * - `tokenId` must exist.
461      */
462     function ownerOf(uint256 tokenId) external view returns (address owner);
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
520      * @dev Returns the account approved for `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function getApproved(uint256 tokenId) external view returns (address operator);
527 
528     /**
529      * @dev Approve or remove `operator` as an operator for the caller.
530      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
531      *
532      * Requirements:
533      *
534      * - The `operator` cannot be the caller.
535      *
536      * Emits an {ApprovalForAll} event.
537      */
538     function setApprovalForAll(address operator, bool _approved) external;
539 
540     /**
541      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
542      *
543      * See {setApprovalForAll}
544      */
545     function isApprovedForAll(address owner, address operator) external view returns (bool);
546 
547     /**
548      * @dev Safely transfers `tokenId` token from `from` to `to`.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `tokenId` token must exist and be owned by `from`.
555      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
556      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
557      *
558      * Emits a {Transfer} event.
559      */
560     function safeTransferFrom(
561         address from,
562         address to,
563         uint256 tokenId,
564         bytes calldata data
565     ) external;
566 }
567 
568 
569 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
570 
571 
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @title ERC721 token receiver interface
577  * @dev Interface for any contract that wants to support safeTransfers
578  * from ERC721 asset contracts.
579  */
580 interface IERC721Receiver {
581     /**
582      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
583      * by `operator` from `from`, this function is called.
584      *
585      * It must return its Solidity selector to confirm the token transfer.
586      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
587      *
588      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
589      */
590     function onERC721Received(
591         address operator,
592         address from,
593         uint256 tokenId,
594         bytes calldata data
595     ) external returns (bytes4);
596 }
597 
598 
599 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
600 
601 
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
607  * @dev See https://eips.ethereum.org/EIPS/eip-721
608  */
609 interface IERC721Metadata is IERC721 {
610     /**
611      * @dev Returns the token collection name.
612      */
613     function name() external view returns (string memory);
614 
615     /**
616      * @dev Returns the token collection symbol.
617      */
618     function symbol() external view returns (string memory);
619 
620     /**
621      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
622      */
623     function tokenURI(uint256 tokenId) external view returns (string memory);
624 }
625 
626 
627 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.3.2
628 
629 
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev Required interface of an ERC1155 compliant contract, as defined in the
635  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
636  *
637  * _Available since v3.1._
638  */
639 interface IERC1155 is IERC165 {
640     /**
641      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
642      */
643     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
644 
645     /**
646      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
647      * transfers.
648      */
649     event TransferBatch(
650         address indexed operator,
651         address indexed from,
652         address indexed to,
653         uint256[] ids,
654         uint256[] values
655     );
656 
657     /**
658      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
659      * `approved`.
660      */
661     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
662 
663     /**
664      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
665      *
666      * If an {URI} event was emitted for `id`, the standard
667      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
668      * returned by {IERC1155MetadataURI-uri}.
669      */
670     event URI(string value, uint256 indexed id);
671 
672     /**
673      * @dev Returns the amount of tokens of token type `id` owned by `account`.
674      *
675      * Requirements:
676      *
677      * - `account` cannot be the zero address.
678      */
679     function balanceOf(address account, uint256 id) external view returns (uint256);
680 
681     /**
682      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
683      *
684      * Requirements:
685      *
686      * - `accounts` and `ids` must have the same length.
687      */
688     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
689         external
690         view
691         returns (uint256[] memory);
692 
693     /**
694      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
695      *
696      * Emits an {ApprovalForAll} event.
697      *
698      * Requirements:
699      *
700      * - `operator` cannot be the caller.
701      */
702     function setApprovalForAll(address operator, bool approved) external;
703 
704     /**
705      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
706      *
707      * See {setApprovalForAll}.
708      */
709     function isApprovedForAll(address account, address operator) external view returns (bool);
710 
711     /**
712      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
713      *
714      * Emits a {TransferSingle} event.
715      *
716      * Requirements:
717      *
718      * - `to` cannot be the zero address.
719      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
720      * - `from` must have a balance of tokens of type `id` of at least `amount`.
721      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
722      * acceptance magic value.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 id,
728         uint256 amount,
729         bytes calldata data
730     ) external;
731 
732     /**
733      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
734      *
735      * Emits a {TransferBatch} event.
736      *
737      * Requirements:
738      *
739      * - `ids` and `amounts` must have the same length.
740      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
741      * acceptance magic value.
742      */
743     function safeBatchTransferFrom(
744         address from,
745         address to,
746         uint256[] calldata ids,
747         uint256[] calldata amounts,
748         bytes calldata data
749     ) external;
750 }
751 
752 
753 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.3.2
754 
755 
756 
757 pragma solidity ^0.8.0;
758 
759 /**
760  * @dev _Available since v3.1._
761  */
762 interface IERC1155Receiver is IERC165 {
763     /**
764         @dev Handles the receipt of a single ERC1155 token type. This function is
765         called at the end of a `safeTransferFrom` after the balance has been updated.
766         To accept the transfer, this must return
767         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
768         (i.e. 0xf23a6e61, or its own function selector).
769         @param operator The address which initiated the transfer (i.e. msg.sender)
770         @param from The address which previously owned the token
771         @param id The ID of the token being transferred
772         @param value The amount of tokens being transferred
773         @param data Additional data with no specified format
774         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
775     */
776     function onERC1155Received(
777         address operator,
778         address from,
779         uint256 id,
780         uint256 value,
781         bytes calldata data
782     ) external returns (bytes4);
783 
784     /**
785         @dev Handles the receipt of a multiple ERC1155 token types. This function
786         is called at the end of a `safeBatchTransferFrom` after the balances have
787         been updated. To accept the transfer(s), this must return
788         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
789         (i.e. 0xbc197c81, or its own function selector).
790         @param operator The address which initiated the batch transfer (i.e. msg.sender)
791         @param from The address which previously owned the token
792         @param ids An array containing ids of each token being transferred (order and length must match values array)
793         @param values An array containing amounts of each token being transferred (order and length must match ids array)
794         @param data Additional data with no specified format
795         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
796     */
797     function onERC1155BatchReceived(
798         address operator,
799         address from,
800         uint256[] calldata ids,
801         uint256[] calldata values,
802         bytes calldata data
803     ) external returns (bytes4);
804 }
805 
806 
807 // File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.3.2
808 
809 
810 
811 pragma solidity ^0.8.0;
812 
813 /**
814  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
815  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
816  *
817  * _Available since v3.1._
818  */
819 interface IERC1155MetadataURI is IERC1155 {
820     /**
821      * @dev Returns the URI for token type `id`.
822      *
823      * If the `\{id\}` substring is present in the URI, it must be replaced by
824      * clients with the actual token type ID.
825      */
826     function uri(uint256 id) external view returns (string memory);
827 }
828 
829 
830 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
831 
832 
833 
834 pragma solidity ^0.8.0;
835 
836 /**
837  * @dev Collection of functions related to the address type
838  */
839 library Address {
840     /**
841      * @dev Returns true if `account` is a contract.
842      *
843      * [IMPORTANT]
844      * ====
845      * It is unsafe to assume that an address for which this function returns
846      * false is an externally-owned account (EOA) and not a contract.
847      *
848      * Among others, `isContract` will return false for the following
849      * types of addresses:
850      *
851      *  - an externally-owned account
852      *  - a contract in construction
853      *  - an address where a contract will be created
854      *  - an address where a contract lived, but was destroyed
855      * ====
856      */
857     function isContract(address account) internal view returns (bool) {
858         // This method relies on extcodesize, which returns 0 for contracts in
859         // construction, since the code is only stored at the end of the
860         // constructor execution.
861 
862         uint256 size;
863         assembly {
864             size := extcodesize(account)
865         }
866         return size > 0;
867     }
868 
869     /**
870      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
871      * `recipient`, forwarding all available gas and reverting on errors.
872      *
873      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
874      * of certain opcodes, possibly making contracts go over the 2300 gas limit
875      * imposed by `transfer`, making them unable to receive funds via
876      * `transfer`. {sendValue} removes this limitation.
877      *
878      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
879      *
880      * IMPORTANT: because control is transferred to `recipient`, care must be
881      * taken to not create reentrancy vulnerabilities. Consider using
882      * {ReentrancyGuard} or the
883      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
884      */
885     function sendValue(address payable recipient, uint256 amount) internal {
886         require(address(this).balance >= amount, "Address: insufficient balance");
887 
888         (bool success, ) = recipient.call{value: amount}("");
889         require(success, "Address: unable to send value, recipient may have reverted");
890     }
891 
892     /**
893      * @dev Performs a Solidity function call using a low level `call`. A
894      * plain `call` is an unsafe replacement for a function call: use this
895      * function instead.
896      *
897      * If `target` reverts with a revert reason, it is bubbled up by this
898      * function (like regular Solidity function calls).
899      *
900      * Returns the raw returned data. To convert to the expected return value,
901      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
902      *
903      * Requirements:
904      *
905      * - `target` must be a contract.
906      * - calling `target` with `data` must not revert.
907      *
908      * _Available since v3.1._
909      */
910     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
911         return functionCall(target, data, "Address: low-level call failed");
912     }
913 
914     /**
915      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
916      * `errorMessage` as a fallback revert reason when `target` reverts.
917      *
918      * _Available since v3.1._
919      */
920     function functionCall(
921         address target,
922         bytes memory data,
923         string memory errorMessage
924     ) internal returns (bytes memory) {
925         return functionCallWithValue(target, data, 0, errorMessage);
926     }
927 
928     /**
929      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
930      * but also transferring `value` wei to `target`.
931      *
932      * Requirements:
933      *
934      * - the calling contract must have an ETH balance of at least `value`.
935      * - the called Solidity function must be `payable`.
936      *
937      * _Available since v3.1._
938      */
939     function functionCallWithValue(
940         address target,
941         bytes memory data,
942         uint256 value
943     ) internal returns (bytes memory) {
944         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
945     }
946 
947     /**
948      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
949      * with `errorMessage` as a fallback revert reason when `target` reverts.
950      *
951      * _Available since v3.1._
952      */
953     function functionCallWithValue(
954         address target,
955         bytes memory data,
956         uint256 value,
957         string memory errorMessage
958     ) internal returns (bytes memory) {
959         require(address(this).balance >= value, "Address: insufficient balance for call");
960         require(isContract(target), "Address: call to non-contract");
961 
962         (bool success, bytes memory returndata) = target.call{value: value}(data);
963         return verifyCallResult(success, returndata, errorMessage);
964     }
965 
966     /**
967      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
968      * but performing a static call.
969      *
970      * _Available since v3.3._
971      */
972     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
973         return functionStaticCall(target, data, "Address: low-level static call failed");
974     }
975 
976     /**
977      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
978      * but performing a static call.
979      *
980      * _Available since v3.3._
981      */
982     function functionStaticCall(
983         address target,
984         bytes memory data,
985         string memory errorMessage
986     ) internal view returns (bytes memory) {
987         require(isContract(target), "Address: static call to non-contract");
988 
989         (bool success, bytes memory returndata) = target.staticcall(data);
990         return verifyCallResult(success, returndata, errorMessage);
991     }
992 
993     /**
994      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
995      * but performing a delegate call.
996      *
997      * _Available since v3.4._
998      */
999     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1000         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1001     }
1002 
1003     /**
1004      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1005      * but performing a delegate call.
1006      *
1007      * _Available since v3.4._
1008      */
1009     function functionDelegateCall(
1010         address target,
1011         bytes memory data,
1012         string memory errorMessage
1013     ) internal returns (bytes memory) {
1014         require(isContract(target), "Address: delegate call to non-contract");
1015 
1016         (bool success, bytes memory returndata) = target.delegatecall(data);
1017         return verifyCallResult(success, returndata, errorMessage);
1018     }
1019 
1020     /**
1021      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1022      * revert reason using the provided one.
1023      *
1024      * _Available since v4.3._
1025      */
1026     function verifyCallResult(
1027         bool success,
1028         bytes memory returndata,
1029         string memory errorMessage
1030     ) internal pure returns (bytes memory) {
1031         if (success) {
1032             return returndata;
1033         } else {
1034             // Look for revert reason and bubble it up if present
1035             if (returndata.length > 0) {
1036                 // The easiest way to bubble the revert reason is using memory via assembly
1037 
1038                 assembly {
1039                     let returndata_size := mload(returndata)
1040                     revert(add(32, returndata), returndata_size)
1041                 }
1042             } else {
1043                 revert(errorMessage);
1044             }
1045         }
1046     }
1047 }
1048 
1049 
1050 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
1051 
1052 
1053 
1054 pragma solidity ^0.8.0;
1055 
1056 /**
1057  * @dev Implementation of the {IERC165} interface.
1058  *
1059  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1060  * for the additional interface id that will be supported. For example:
1061  *
1062  * ```solidity
1063  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1064  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1065  * }
1066  * ```
1067  *
1068  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1069  */
1070 abstract contract ERC165 is IERC165 {
1071     /**
1072      * @dev See {IERC165-supportsInterface}.
1073      */
1074     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1075         return interfaceId == type(IERC165).interfaceId;
1076     }
1077 }
1078 
1079 
1080 // File contracts/ERC1155.sol
1081 
1082 /* The MIT License (MIT)
1083  * 
1084  * Copyright (c) 2016-2020 zOS Global Limited
1085  * 
1086  * Permission is hereby granted, free of charge, to any person obtaining
1087  * a copy of this software and associated documentation files (the
1088  * "Software"), to deal in the Software without restriction, including
1089  * without limitation the rights to use, copy, modify, merge, publish,
1090  * distribute, sublicense, and/or sell copies of the Software, and to
1091  * permit persons to whom the Software is furnished to do so, subject to
1092  * the following conditions:
1093  * 
1094  * The above copyright notice and this permission notice shall be included
1095  * in all copies or substantial portions of the Software.
1096  *
1097  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
1098  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
1099  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
1100  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
1101  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
1102  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
1103  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
1104  */
1105 
1106 /* SUMMARY OF CHANGES
1107  * Line 36-41  Change imports to use @openzeppelin/contracts imports rather than
1108  *             relative imports.
1109  * Line 54     Remove private modifier from `_balances`.
1110  */
1111 
1112 
1113 // OpenZeppelin Contracts v4.3.2 (token/ERC1155/ERC1155.sol)
1114 
1115 pragma solidity ^0.8.0;
1116 
1117 
1118 
1119 
1120 
1121 
1122 /**
1123  * @dev Implementation of the basic standard multi-token.
1124  * See https://eips.ethereum.org/EIPS/eip-1155
1125  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1126  *
1127  * _Available since v3.1._
1128  */
1129 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1130     using Address for address;
1131 
1132     // Mapping from token ID to account balances
1133     mapping(uint256 => mapping(address => uint256)) _balances;
1134 
1135     // Mapping from account to operator approvals
1136     mapping(address => mapping(address => bool)) private _operatorApprovals;
1137 
1138     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1139     string private _uri;
1140 
1141     /**
1142      * @dev See {_setURI}.
1143      */
1144     constructor(string memory uri_) {
1145         _setURI(uri_);
1146     }
1147 
1148     /**
1149      * @dev See {IERC165-supportsInterface}.
1150      */
1151     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1152         return
1153             interfaceId == type(IERC1155).interfaceId ||
1154             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1155             super.supportsInterface(interfaceId);
1156     }
1157 
1158     /**
1159      * @dev See {IERC1155MetadataURI-uri}.
1160      *
1161      * This implementation returns the same URI for *all* token types. It relies
1162      * on the token type ID substitution mechanism
1163      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1164      *
1165      * Clients calling this function must replace the `\{id\}` substring with the
1166      * actual token type ID.
1167      */
1168     function uri(uint256) public view virtual override returns (string memory) {
1169         return _uri;
1170     }
1171 
1172     /**
1173      * @dev See {IERC1155-balanceOf}.
1174      *
1175      * Requirements:
1176      *
1177      * - `account` cannot be the zero address.
1178      */
1179     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1180         require(account != address(0), "ERC1155: balance query for the zero address");
1181         return _balances[id][account];
1182     }
1183 
1184     /**
1185      * @dev See {IERC1155-balanceOfBatch}.
1186      *
1187      * Requirements:
1188      *
1189      * - `accounts` and `ids` must have the same length.
1190      */
1191     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1192         public
1193         view
1194         virtual
1195         override
1196         returns (uint256[] memory)
1197     {
1198         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1199 
1200         uint256[] memory batchBalances = new uint256[](accounts.length);
1201 
1202         for (uint256 i = 0; i < accounts.length; ++i) {
1203             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1204         }
1205 
1206         return batchBalances;
1207     }
1208 
1209     /**
1210      * @dev See {IERC1155-setApprovalForAll}.
1211      */
1212     function setApprovalForAll(address operator, bool approved) public virtual override {
1213         _setApprovalForAll(_msgSender(), operator, approved);
1214     }
1215 
1216     /**
1217      * @dev See {IERC1155-isApprovedForAll}.
1218      */
1219     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1220         return _operatorApprovals[account][operator];
1221     }
1222 
1223     /**
1224      * @dev See {IERC1155-safeTransferFrom}.
1225      */
1226     function safeTransferFrom(
1227         address from,
1228         address to,
1229         uint256 id,
1230         uint256 amount,
1231         bytes memory data
1232     ) public virtual override {
1233         require(
1234             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1235             "ERC1155: caller is not owner nor approved"
1236         );
1237         _safeTransferFrom(from, to, id, amount, data);
1238     }
1239 
1240     /**
1241      * @dev See {IERC1155-safeBatchTransferFrom}.
1242      */
1243     function safeBatchTransferFrom(
1244         address from,
1245         address to,
1246         uint256[] memory ids,
1247         uint256[] memory amounts,
1248         bytes memory data
1249     ) public virtual override {
1250         require(
1251             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1252             "ERC1155: transfer caller is not owner nor approved"
1253         );
1254         _safeBatchTransferFrom(from, to, ids, amounts, data);
1255     }
1256 
1257     /**
1258      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1259      *
1260      * Emits a {TransferSingle} event.
1261      *
1262      * Requirements:
1263      *
1264      * - `to` cannot be the zero address.
1265      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1266      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1267      * acceptance magic value.
1268      */
1269     function _safeTransferFrom(
1270         address from,
1271         address to,
1272         uint256 id,
1273         uint256 amount,
1274         bytes memory data
1275     ) internal virtual {
1276         require(to != address(0), "ERC1155: transfer to the zero address");
1277 
1278         address operator = _msgSender();
1279 
1280         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1281 
1282         uint256 fromBalance = _balances[id][from];
1283         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1284         unchecked {
1285             _balances[id][from] = fromBalance - amount;
1286         }
1287         _balances[id][to] += amount;
1288 
1289         emit TransferSingle(operator, from, to, id, amount);
1290 
1291         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1292     }
1293 
1294     /**
1295      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1296      *
1297      * Emits a {TransferBatch} event.
1298      *
1299      * Requirements:
1300      *
1301      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1302      * acceptance magic value.
1303      */
1304     function _safeBatchTransferFrom(
1305         address from,
1306         address to,
1307         uint256[] memory ids,
1308         uint256[] memory amounts,
1309         bytes memory data
1310     ) internal virtual {
1311         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1312         require(to != address(0), "ERC1155: transfer to the zero address");
1313 
1314         address operator = _msgSender();
1315 
1316         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1317 
1318         for (uint256 i = 0; i < ids.length; ++i) {
1319             uint256 id = ids[i];
1320             uint256 amount = amounts[i];
1321 
1322             uint256 fromBalance = _balances[id][from];
1323             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1324             unchecked {
1325                 _balances[id][from] = fromBalance - amount;
1326             }
1327             _balances[id][to] += amount;
1328         }
1329 
1330         emit TransferBatch(operator, from, to, ids, amounts);
1331 
1332         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1333     }
1334 
1335     /**
1336      * @dev Sets a new URI for all token types, by relying on the token type ID
1337      * substitution mechanism
1338      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1339      *
1340      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1341      * URI or any of the amounts in the JSON file at said URI will be replaced by
1342      * clients with the token type ID.
1343      *
1344      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1345      * interpreted by clients as
1346      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1347      * for token type ID 0x4cce0.
1348      *
1349      * See {uri}.
1350      *
1351      * Because these URIs cannot be meaningfully represented by the {URI} event,
1352      * this function emits no events.
1353      */
1354     function _setURI(string memory newuri) internal virtual {
1355         _uri = newuri;
1356     }
1357 
1358     /**
1359      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1360      *
1361      * Emits a {TransferSingle} event.
1362      *
1363      * Requirements:
1364      *
1365      * - `to` cannot be the zero address.
1366      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1367      * acceptance magic value.
1368      */
1369     function _mint(
1370         address to,
1371         uint256 id,
1372         uint256 amount,
1373         bytes memory data
1374     ) internal virtual {
1375         require(to != address(0), "ERC1155: mint to the zero address");
1376 
1377         address operator = _msgSender();
1378 
1379         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1380 
1381         _balances[id][to] += amount;
1382         emit TransferSingle(operator, address(0), to, id, amount);
1383 
1384         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1385     }
1386 
1387     /**
1388      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1389      *
1390      * Requirements:
1391      *
1392      * - `ids` and `amounts` must have the same length.
1393      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1394      * acceptance magic value.
1395      */
1396     function _mintBatch(
1397         address to,
1398         uint256[] memory ids,
1399         uint256[] memory amounts,
1400         bytes memory data
1401     ) internal virtual {
1402         require(to != address(0), "ERC1155: mint to the zero address");
1403         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1404 
1405         address operator = _msgSender();
1406 
1407         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1408 
1409         for (uint256 i = 0; i < ids.length; i++) {
1410             _balances[ids[i]][to] += amounts[i];
1411         }
1412 
1413         emit TransferBatch(operator, address(0), to, ids, amounts);
1414 
1415         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1416     }
1417 
1418     /**
1419      * @dev Destroys `amount` tokens of token type `id` from `from`
1420      *
1421      * Requirements:
1422      *
1423      * - `from` cannot be the zero address.
1424      * - `from` must have at least `amount` tokens of token type `id`.
1425      */
1426     function _burn(
1427         address from,
1428         uint256 id,
1429         uint256 amount
1430     ) internal virtual {
1431         require(from != address(0), "ERC1155: burn from the zero address");
1432 
1433         address operator = _msgSender();
1434 
1435         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1436 
1437         uint256 fromBalance = _balances[id][from];
1438         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1439         unchecked {
1440             _balances[id][from] = fromBalance - amount;
1441         }
1442 
1443         emit TransferSingle(operator, from, address(0), id, amount);
1444     }
1445 
1446     /**
1447      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1448      *
1449      * Requirements:
1450      *
1451      * - `ids` and `amounts` must have the same length.
1452      */
1453     function _burnBatch(
1454         address from,
1455         uint256[] memory ids,
1456         uint256[] memory amounts
1457     ) internal virtual {
1458         require(from != address(0), "ERC1155: burn from the zero address");
1459         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1460 
1461         address operator = _msgSender();
1462 
1463         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1464 
1465         for (uint256 i = 0; i < ids.length; i++) {
1466             uint256 id = ids[i];
1467             uint256 amount = amounts[i];
1468 
1469             uint256 fromBalance = _balances[id][from];
1470             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1471             unchecked {
1472                 _balances[id][from] = fromBalance - amount;
1473             }
1474         }
1475 
1476         emit TransferBatch(operator, from, address(0), ids, amounts);
1477     }
1478 
1479     /**
1480      * @dev Approve `operator` to operate on all of `owner` tokens
1481      *
1482      * Emits a {ApprovalForAll} event.
1483      */
1484     function _setApprovalForAll(
1485         address owner,
1486         address operator,
1487         bool approved
1488     ) internal virtual {
1489         require(owner != operator, "ERC1155: setting approval status for self");
1490         _operatorApprovals[owner][operator] = approved;
1491         emit ApprovalForAll(owner, operator, approved);
1492     }
1493 
1494     /**
1495      * @dev Hook that is called before any token transfer. This includes minting
1496      * and burning, as well as batched variants.
1497      *
1498      * The same hook is called on both single and batched variants. For single
1499      * transfers, the length of the `id` and `amount` arrays will be 1.
1500      *
1501      * Calling conditions (for each `id` and `amount` pair):
1502      *
1503      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1504      * of token type `id` will be  transferred to `to`.
1505      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1506      * for `to`.
1507      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1508      * will be burned.
1509      * - `from` and `to` are never both zero.
1510      * - `ids` and `amounts` have the same, non-zero length.
1511      *
1512      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1513      */
1514     function _beforeTokenTransfer(
1515         address operator,
1516         address from,
1517         address to,
1518         uint256[] memory ids,
1519         uint256[] memory amounts,
1520         bytes memory data
1521     ) internal virtual {}
1522 
1523     function _doSafeTransferAcceptanceCheck(
1524         address operator,
1525         address from,
1526         address to,
1527         uint256 id,
1528         uint256 amount,
1529         bytes memory data
1530     ) private {
1531         if (to.isContract()) {
1532             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1533                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1534                     revert("ERC1155: ERC1155Receiver rejected tokens");
1535                 }
1536             } catch Error(string memory reason) {
1537                 revert(reason);
1538             } catch {
1539                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1540             }
1541         }
1542     }
1543 
1544     function _doSafeBatchTransferAcceptanceCheck(
1545         address operator,
1546         address from,
1547         address to,
1548         uint256[] memory ids,
1549         uint256[] memory amounts,
1550         bytes memory data
1551     ) private {
1552         if (to.isContract()) {
1553             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1554                 bytes4 response
1555             ) {
1556                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1557                     revert("ERC1155: ERC1155Receiver rejected tokens");
1558                 }
1559             } catch Error(string memory reason) {
1560                 revert(reason);
1561             } catch {
1562                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1563             }
1564         }
1565     }
1566 
1567     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1568         uint256[] memory array = new uint256[](1);
1569         array[0] = element;
1570 
1571         return array;
1572     }
1573 }
1574 
1575 
1576 // File contracts/DualERC1155ERC721.sol
1577 
1578 
1579 
1580 pragma solidity ^0.8.8;
1581 
1582 
1583 
1584 
1585 
1586 
1587 
1588 /// @notice ERC1155 that supports the ERC721 interface for certain tokens
1589 contract DualERC1155ERC721 is ERC1155 {
1590 
1591     using Address for address;
1592     using Strings for uint256;
1593 
1594     /// @dev See {IERC721-Transfer}.
1595     event Transfer(
1596         address indexed from,
1597         address indexed to,
1598         uint256 indexed tokenId
1599     );
1600 
1601     /// @dev See {IERC721-Approval}.
1602     event Approval(
1603         address indexed owner,
1604         address indexed approved,
1605         uint256 indexed tokenId
1606     );
1607 
1608     struct ERC721Data {
1609         bool exists;
1610         address owner;
1611         address approved;
1612     }
1613 
1614     // Mapping from account to number of erc721 compatible tokens owned
1615     mapping(address => uint256) private _erc721Balances;
1616 
1617     // Mapping from token ID to erc721 data
1618     mapping(uint256 => ERC721Data) private _erc721Data;
1619 
1620     constructor() ERC1155("") {}
1621 
1622     /// @dev See {IERC165-supportsInterface}.
1623     function supportsInterface(
1624         bytes4 interfaceId
1625     ) public view virtual override returns (bool) {
1626         return interfaceId == type(IERC721).interfaceId ||
1627             interfaceId == type(IERC721Metadata).interfaceId ||
1628             super.supportsInterface(interfaceId);
1629     }
1630 
1631     /// @dev Base URI form {tokenURI}.
1632     function _baseURI() internal view virtual returns (string memory) {
1633         return "";
1634     }
1635 
1636     /// @dev See {IERC721Metadata-tokenURI}.
1637     /// Concatenates the tokenId to the results of {_baseURI}.
1638     function tokenURI(
1639         uint256 tokenId
1640     ) public view virtual returns (string memory) {
1641         require(
1642             _erc721Data[tokenId].exists,
1643             "ERC721Metadata: URI query for nonexistent token"
1644         );
1645 
1646         return bytes(_baseURI()).length > 0 ?
1647             string(abi.encodePacked(_baseURI(), tokenId.toString())) : "";
1648     }
1649 
1650     /// @dev See {IERC721Metadata-name}.
1651     function name() public view virtual returns (string memory) {
1652         return "";
1653     }
1654 
1655     /// @dev See {IERC721Metadata-symbol}.
1656     function symbol() public view virtual returns (string memory) {
1657         return "";
1658     }
1659 
1660     /// @dev Returns a single element as a single element array
1661     function _asSingleArray(uint256 element) private pure returns (uint256[] memory) {
1662         uint256[] memory array = new uint256[](1);
1663         array[0] = element;
1664 
1665         return array;
1666     }
1667 
1668     /// @dev See {IERC721-balanceOf}.
1669     function balanceOf(address owner) public view virtual returns (uint256 balance) {
1670         return _erc721Balances[owner];
1671     }
1672 
1673     /// @dev See {IERC721-ownerOf}.
1674     function ownerOf(
1675         uint256 tokenId
1676     ) public view virtual returns (address owner) {
1677         return _erc721Data[tokenId].exists ?
1678             _erc721Data[tokenId].owner :
1679             address(0);
1680     }
1681 
1682     /// @dev See {IERC721-transferFrom}.
1683     function transferFrom(
1684         address from,
1685         address to,
1686         uint256 tokenId
1687     ) public virtual {
1688         require(
1689             _erc721Data[tokenId].exists && (
1690                 DualERC1155ERC721.ownerOf(tokenId) == msg.sender || 
1691                 _erc721Data[tokenId].approved == msg.sender
1692             ),
1693             "ERC721: transfer caller is not owner nor approved"
1694         );
1695         _transferERC721(from, to, tokenId);
1696     }
1697 
1698     /// @dev See {IERC721-approve}.
1699     function approve(address to, uint256 tokenId) public virtual {
1700         address owner = DualERC1155ERC721.ownerOf(tokenId);
1701         require(to != owner, "ERC721: approval to current owner");
1702         require(
1703             msg.sender == owner || isApprovedForAll(owner, msg.sender),
1704             "ERC721: approve caller is not owner nor approved for all"
1705         );
1706         _approveERC721(to, tokenId);
1707     }
1708 
1709     /// @dev See {IERC721-getApproved}.
1710     function getApproved(
1711         uint256 tokenId
1712     ) public view virtual returns (address operator) {
1713         return _erc721Data[tokenId].approved;
1714     }
1715 
1716     /// @dev See {IERC721-safeTransferFrom}.
1717     function safeTransferFrom(
1718         address from,
1719         address to,
1720         uint256 tokenId,
1721         bytes memory data
1722     ) public virtual {
1723         require(
1724             _erc721Data[tokenId].exists && (
1725                 DualERC1155ERC721.ownerOf(tokenId) == msg.sender || 
1726                 _erc721Data[tokenId].approved == msg.sender
1727             ),
1728             "ERC721: transfer caller is not owner nor approved"
1729         );
1730         _transferERC721(from, to, tokenId);
1731         require(
1732             _checkOnERC721Received(from, to, tokenId, data),
1733             "ERC721: transfer to non ERC721Receiver implementer"
1734         );
1735     }
1736 
1737     /// @dev See {IERC721-safeTransferFrom}.
1738     function safeTransferFrom(
1739         address from,
1740         address to,
1741         uint256 tokenId
1742     ) public virtual {
1743         safeTransferFrom(from, to, tokenId, bytes(""));
1744     }
1745 
1746     /// @dev Transfer a token as an ERC721
1747     function _transferERC721(
1748         address from,
1749         address to,
1750         uint256 tokenId
1751     ) internal virtual {
1752         require(to != address(0), "ERC721: transfer to the zero address");
1753 
1754         _beforeTokenTransfer(
1755             _msgSender(),
1756             from,
1757             to,
1758             _asSingleArray(tokenId),
1759             _asSingleArray(1),
1760             ""
1761         );
1762 
1763         _approveERC721(address(0), tokenId);
1764         _balances[tokenId][from] -= 1;
1765         _balances[tokenId][to] += 1;
1766 
1767         // Emit ERC1155 transfer event rather than ERC721
1768         emit TransferSingle(_msgSender(), from, to, tokenId, 1);
1769     }
1770 
1771     /// @dev See {approve}.
1772     function _approveERC721(address to, uint256 tokenId) internal virtual {
1773         _erc721Data[tokenId].approved = to;
1774         emit Approval(DualERC1155ERC721.ownerOf(tokenId), to, tokenId);
1775     }
1776 
1777     /// @dev Hooks into transfers of ERC721 marked-tokens
1778     function _beforeTokenTransfer(
1779         address,
1780         address from,
1781         address to,
1782         uint256[] memory ids,
1783         uint256[] memory amounts,
1784         bytes memory
1785     ) internal override {
1786         for (uint256 i = 0; i < ids.length; i ++) {
1787             if (_erc721Data[ids[i]].exists) {
1788                 require(
1789                     DualERC1155ERC721.ownerOf(ids[i]) == from,
1790                     "ERC721: transfer of token that is not own"
1791                 );
1792                 require(
1793                     amounts[i] == 1,
1794                     "ERC721: multi-transfer of token that is not multi-token"
1795                 );
1796                 _erc721Data[ids[i]].owner = to;
1797                 emit Transfer(from, to, ids[i]);
1798                 if (from != address(0)) {
1799                     _erc721Balances[from] -= 1;
1800                 }
1801                 if (to != address(0)) {
1802                     _erc721Balances[to] += 1;
1803                 }
1804             }
1805         }
1806     }
1807 
1808     /// @dev Check to see if receiver contract supports IERC721Receiver.
1809     function _checkOnERC721Received(
1810         address from,
1811         address to,
1812         uint256 tokenId,
1813         bytes memory _data
1814     ) private returns (bool) {
1815         if (to.isContract()) {
1816             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1817                 return retval == IERC721Receiver.onERC721Received.selector;
1818             } catch (bytes memory reason) {
1819                 if (reason.length == 0) {
1820                     revert("ERC721: transfer to non ERC721Receiver implementer");
1821                 } else {
1822                     assembly {
1823                         revert(add(32, reason), mload(reason))
1824                     }
1825                 }
1826             }
1827         } else {
1828             return true;
1829         }
1830     }
1831 
1832     /// @dev Mark a token id as ERC721. MUST be called before a token is minted.
1833     /// Only 1 of this token is allowed to exist at any given time. This token
1834     /// will be visible from the ERC721 interface of this contract.
1835     function _registerERC721(uint256 tokenId) internal {
1836         _erc721Data[tokenId].exists = true;
1837     }
1838 }
1839 
1840 
1841 // File contracts/IDUtils.sol
1842 
1843 
1844 
1845 pragma solidity ^0.8.8;
1846 
1847 /// @notice A helper type to enforce stronger type-checking for token IDs
1848 type ID is uint256;
1849 
1850 /// @title IDUtils
1851 /// @notice Provides utility functions for working with the ID type
1852 library IDUtils {
1853 
1854     /// @notice Get the ID after a given ID
1855     /// @param id The ID
1856     /// @return The next ID
1857     function next(ID id) internal pure returns (ID) {
1858         return ID.wrap(ID.unwrap(id) + 1);
1859     }
1860 
1861     /// @notice Whether and ID comes after another ID
1862     /// @param a The first ID
1863     /// @param b The second ID
1864     /// @return If the first comes after the second or not
1865     function gt(ID a, ID b) internal pure returns (bool) {
1866         return ID.unwrap(a) > ID.unwrap(b);
1867     }
1868 }
1869 
1870 
1871 // File contracts/MerkleDropUniqueToken.sol
1872 
1873 
1874 
1875 pragma solidity ^0.8.8;
1876 
1877 
1878 
1879 
1880 
1881 /// @title Merkle Drop Unique Token
1882 /// @notice Supports two classes of tokens: drop tokens and unique tokens. Drop
1883 /// tokens can be distributed using merkle drops and unique tokens are 1 of 1s
1884 /// that can be purchased if enough drop tokens are held.
1885 contract MerkleDropUniqueToken is DualERC1155ERC721, Ownable, ReentrancyGuard {
1886 
1887     /// @dev Counter used to create new tokens
1888     ID public nextId = ID.wrap(0);
1889 
1890     constructor() DualERC1155ERC721() {}
1891 
1892     struct DropToken {
1893         bool exists;
1894         uint256 supply;
1895     }
1896 
1897     /// @notice Describes which IDs correspond to drop tokens and their supply
1898     mapping(ID => DropToken) public dropTokens;
1899 
1900     /// @notice List of drop token IDs
1901     ID[] public dropTokenList;
1902 
1903     /// @notice Emitted when a new types of drop token are created
1904     /// @param firstId ID of the first drop token
1905     /// @param amounts Amounts of the drop tokens
1906     event DropTokensCreated(ID firstId, uint256[] amounts);
1907 
1908     function _createDropTokens(uint256[] memory _amounts) internal {
1909         emit DropTokensCreated(nextId, _amounts);
1910         for (uint i = 0; i < _amounts.length; i ++) {
1911             dropTokens[nextId] = DropToken(true, _amounts[i]);
1912             dropTokenList.push(nextId);
1913             nextId = IDUtils.next(nextId);
1914         }
1915     }
1916 
1917     /// @notice Create new types of drop token
1918     /// @param _amounts Amounts of the drop tokens
1919     function createDropTokens(uint256[] calldata _amounts) external onlyOwner {
1920         _createDropTokens(_amounts);
1921     }
1922 
1923     struct MerkleDrop {
1924         bool exists;
1925         bytes32 merkleRoot;
1926         mapping(ID => uint256) amounts;
1927         mapping(address => bool) claimed;
1928     }
1929 
1930     /// @notice The ID of the next merkle drop
1931     uint256 public nextMerkleDropId = 0;
1932 
1933     /// @notice Describes existing merkle drops
1934     mapping(uint256 => MerkleDrop) public merkleDrops;
1935 
1936     /// @notice Emitted when a new merkle drop is created
1937     /// @param merkleDropId The ID of the merkle drop
1938     /// @param merkleRoot The root of the merkle tree
1939     /// @param ids The IDs of the drop tokens in this drop
1940     /// @param amounts The amounts of the drops tokens correspond to `ids`
1941     event MerkleDropCreated(
1942         uint256 merkleDropId,
1943         bytes32 merkleRoot,
1944         ID[] ids,
1945         uint256[] amounts
1946     );
1947 
1948     /// @notice Create a new merkle drop to drop multiple drop tokens at once
1949     /// @param _merkleRoot The hex root of the merkle tree. The leaves of the
1950     /// tree must be the address of the recepient as well as the ids and
1951     /// amounts of each of the drop tokens they will be eligible to claim. They
1952     /// should be keccak256 abi packed in address, uint256[], uint256[] format.
1953     /// The merkle tree should be constructed using keccak256 with sorted
1954     /// pairs.
1955     /// @param _ids The IDs of the drop tokens in this drop
1956     /// @param _amounts The amounts of the drops tokens correspond to `ids`
1957     /// @return The ID of the new merkle drop
1958     function createMerkleDrop(
1959         bytes32 _merkleRoot,
1960         ID[] calldata _ids,
1961         uint256[] calldata _amounts
1962     ) external onlyOwner returns (uint256) {
1963         require(
1964             _amounts.length == _ids.length,
1965             "Mismatch between IDs and amounts"
1966         );
1967         ID lastId = ID.wrap(0);
1968         for (uint256 i = 0; i < _ids.length; i ++) {
1969             require(
1970                 i == 0 || IDUtils.gt(_ids[i], lastId),
1971                 "Non-ascending IDs"
1972             );
1973             lastId = _ids[i];
1974             require(dropTokens[_ids[i]].exists, "Drop token does not exist");
1975             require(
1976                 _amounts[i] <= dropTokens[_ids[i]].supply,
1977                 "Not enough drop token supply"
1978             );
1979         }
1980         for (uint256 i = 0; i < _ids.length; i ++) {
1981             dropTokens[_ids[i]].supply -= _amounts[i];
1982             merkleDrops[nextMerkleDropId].amounts[_ids[i]] = _amounts[i];
1983         }
1984         merkleDrops[nextMerkleDropId].merkleRoot = _merkleRoot;
1985         merkleDrops[nextMerkleDropId].exists = true;
1986 
1987         emit MerkleDropCreated(nextMerkleDropId, _merkleRoot, _ids, _amounts);
1988 
1989         return nextMerkleDropId ++;
1990     }
1991 
1992     /// @notice Check whether part of a merkle drop is claimed by an account
1993     /// @param _merkleDropId The ID of the merkle drop
1994     /// @param _account The account to check
1995     function isMerkleDropClaimed(
1996         uint256 _merkleDropId,
1997         address _account
1998     ) public view returns (bool) {
1999         require(merkleDrops[_merkleDropId].exists, "Drop does not exist");
2000         return merkleDrops[_merkleDropId].claimed[_account];
2001     }
2002 
2003     /// @notice Emitted when part of a merkle drop is claimed
2004     /// @param merkleDropId The ID of the merkle drop
2005     /// @param account The recepient
2006     /// @param ids The IDs of the drop tokens received
2007     /// @param amounts The amounts of the drops tokens correspond to `ids`
2008     event MerkleDropClaimed(
2009         uint256 merkleDropId,
2010         address account,
2011         ID[] ids,
2012         uint256[] amounts
2013     );
2014 
2015     /// @notice Claim part of a merkle drop
2016     /// @param _merkleDropId The ID of the merkle drop
2017     /// @param _proof The hex proof of the leaf in the tree. The leaves of the
2018     /// tree must be the address of the recepient as well as the ids and
2019     /// amounts of each of the drop tokens they will be eligible to claim. They
2020     /// should be keccak256 abi packed in address, uint256[], uint256[] format.
2021     /// The merkle tree should be constructed using keccak256 with sorted
2022     /// pairs.
2023     /// @param _ids The IDs of the drop tokens to be received
2024     /// @param _amounts The amounts of the drops tokens correspond to `ids`
2025     function claimMerkleDrop(
2026         uint256 _merkleDropId,
2027         bytes32[] calldata _proof,
2028         ID[] calldata _ids,
2029         uint256[] calldata _amounts
2030     ) external nonReentrant {
2031         _claimMerkleDrop(_merkleDropId, _proof, _ids, _amounts, msg.sender);
2032     }
2033 
2034     function _claimMerkleDrop(
2035         uint256 _merkleDropId,
2036         bytes32[] calldata _proof,
2037         ID[] calldata _ids,
2038         uint256[] calldata _amounts,
2039         address _account
2040     ) internal {
2041         require(merkleDrops[_merkleDropId].exists, "Drop does not exist");
2042         require(
2043             _amounts.length == _ids.length,
2044             "Mismatch between IDs and amounts"
2045         );
2046         require(
2047             !merkleDrops[_merkleDropId].claimed[_account],
2048             "Drop already claimed"
2049         );
2050         ID lastId = ID.wrap(0);
2051         for (uint256 i = 0; i < _ids.length; i ++) {
2052             require(
2053                 i == 0 || IDUtils.gt(_ids[i], lastId),
2054                 "Non-ascending IDs"
2055             );
2056             lastId = _ids[i];
2057             require(dropTokens[_ids[i]].exists, "Drop token does not exist");
2058             require(
2059                 _amounts[i] <= merkleDrops[_merkleDropId].amounts[_ids[i]],
2060                 "Not enough drop tokens in drop"
2061             );
2062         }
2063         bytes32 leaf = keccak256(abi.encodePacked(_account, _ids, _amounts));
2064         require(
2065             MerkleProof.verify(_proof, merkleDrops[_merkleDropId].merkleRoot, leaf),
2066             "Invalid proof"
2067         );
2068         for (uint256 i = 0; i < _ids.length; i ++) {
2069             merkleDrops[_merkleDropId].amounts[_ids[i]] -= _amounts[i];
2070             _mint(_account, ID.unwrap(_ids[i]), _amounts[i], "");
2071         }
2072         merkleDrops[_merkleDropId].claimed[_account] = true;
2073 
2074         emit MerkleDropClaimed(_merkleDropId, _account, _ids, _amounts);
2075     }
2076 
2077     /// @notice Emitted when a merkle drop is cancelled
2078     /// @param merkleDropId The ID of the merkle drop
2079     event MerkleDropCancelled(uint256 merkleDropId);
2080 
2081     /// @notice Cancel an existing merkle drop
2082     /// @param _merkleDropId The ID of the merkle drop
2083     function cancelMerkleDrop(uint256 _merkleDropId) external onlyOwner {
2084         require(merkleDrops[_merkleDropId].exists, "Drop does not exist");
2085         merkleDrops[_merkleDropId].exists = false;
2086         emit MerkleDropCancelled(_merkleDropId);
2087     }
2088 
2089     /// @notice Emitted when drop tokens are manually distributed
2090     /// @param to The address to which the tokens are minted
2091     /// @param id The ID of the token being minted
2092     /// @param amount The amount of the token being minted
2093     event DropTokensDistributed(address to, ID id, uint256 amount);
2094 
2095     /// @notice Manually distribute drop tokens to an address
2096     /// @param _to The address to which the tokens are minted
2097     /// @param _id The ID of the token being minted
2098     /// @param _amount The amount of the token being minted
2099     function distributeDropTokens(
2100         address _to,
2101         ID _id,
2102         uint256 _amount
2103     ) external onlyOwner {
2104         require(dropTokens[_id].exists, "Drop token does not exist");
2105         require(dropTokens[_id].supply >= _amount, "Not enough drop tokens remaining");
2106 
2107         dropTokens[_id].supply -= _amount;
2108         _mint(_to, ID.unwrap(_id), _amount, "");
2109 
2110         emit DropTokensDistributed(_to, _id, _amount);
2111     }
2112 
2113     function _dropTokenBalanceOf(address _account) internal view returns (uint256) {
2114         uint256 balance = 0;
2115         for (uint256 i = 0; i < dropTokenList.length; i ++) {
2116             balance += balanceOf(_account, ID.unwrap(dropTokenList[i]));
2117         }
2118         return balance;
2119     }
2120 
2121     /// @notice Emitted when drop tokens are burned by a holder
2122     /// @param account The address of the token holder
2123     /// @param id The ID of the token being burned
2124     /// @param amount The amount of the token being burned
2125     event DropTokensBurned(address account, ID id, uint256 amount);
2126 
2127     /// @notice Emitted when drop tokens are burned by a holder
2128     /// @param _id The ID of the token to burn
2129     /// @param _amount The amount of the token to burn
2130     function burnDropTokens( ID _id, uint256 _amount) external {
2131         require(dropTokens[_id].exists, "Drop token does not exist");
2132 
2133         _burn(msg.sender, ID.unwrap(_id), _amount);
2134 
2135         emit DropTokensBurned(msg.sender, _id, _amount);
2136     }
2137 
2138     /// @notice Whether unique tokens are availible to be purchased
2139     bool public uniquesPurchasable = false;
2140 
2141     struct Unique {
2142         bool exists;
2143         bool customPrice;
2144         bool minted;
2145         uint256 price;
2146         bool customDropTokenRequirement;
2147         uint256 dropTokenRequirement;
2148     }
2149 
2150     /// @notice Describes which unique tokens are associated with which IDs 
2151     mapping(ID => Unique) public uniques;
2152 
2153     /// @notice Emitted when unique tokens are created
2154     /// @param firstId The id of the first new unique token
2155     /// @param amount The number of new unique tokens created
2156     event UniquesCreated(ID firstId, uint256 amount);
2157 
2158     function _createUniques(uint256 _amount) internal {
2159         emit UniquesCreated(nextId, _amount);
2160         for (uint i = 0; i < _amount; i ++) {
2161             uniques[nextId].exists = true;
2162             _registerERC721(ID.unwrap(nextId));
2163             nextId = IDUtils.next(nextId);
2164         }
2165     }
2166 
2167     /// @notice Create a new unique token
2168     /// @param _amount The number of new unique tokens created
2169     function createUniques(uint256 _amount) external onlyOwner {
2170         _createUniques(_amount);
2171     }
2172 
2173     /// @notice The default price of all unique tokens without a custom setting
2174     uint256 public defaultPrice = 10**18;
2175 
2176     /// @notice The default drop token requirement of all unique tokens without a
2177     /// custom setting
2178     uint256 public defaultDropTokenRequirement = 1;
2179 
2180     /// @notice Emitted when a unique token is purchased
2181     /// @param account The account who purchased the token
2182     /// @param id The ID of the token purchased
2183     /// @param price The price the token sold for
2184     event UniquePurchased(address account, ID id, uint256 price);
2185 
2186     /// @notice Purchase a unique token
2187     /// @param _id The ID of the token to be purchased
2188     function purchaseUnique(ID _id) external payable nonReentrant {
2189         require(uniquesPurchasable, "Uniques not currently purchasable");
2190         require(uniques[_id].exists, "Not a valid unique id");
2191         require(!uniques[_id].minted, "Not enough uniques remaining");
2192         _purchaseUnique(_id, msg.sender, msg.value);
2193     }
2194 
2195     function _purchaseUnique(
2196         ID _id,
2197         address _account,
2198         uint256 _value
2199     ) internal {
2200         require(
2201             uniques[_id].customDropTokenRequirement ?
2202                 _dropTokenBalanceOf(_account) >=
2203                     uniques[_id].dropTokenRequirement :
2204                 _dropTokenBalanceOf(_account) >= defaultDropTokenRequirement,
2205             "Not enough drop tokens to qualify"
2206         );
2207         uint256 price = uniques[_id].customPrice ?
2208             uniques[_id].price : defaultPrice;
2209 
2210         require(_value == price, "Incorrect payment");
2211 
2212         _mint(_account, ID.unwrap(_id), 1, "");
2213         uniques[_id].minted = true;
2214 
2215         emit UniquePurchased(_account, _id, price);
2216     }
2217 
2218     /// @notice Claim part of a merkle drop and purchase a unique token
2219     /// @param _merkleDropId The ID of the merkle drop
2220     /// @param _proof The hex proof of the leaf in the tree. The leaves of the
2221     /// tree must be the address of the recepient as well as the ids and
2222     /// amounts of each of the drop tokens they will be eligible to claim. They
2223     /// should be keccak256 abi packed in address, uint256[], uint256[] format.
2224     /// The merkle tree should be constructed using keccak256 with sorted
2225     /// pairs.
2226     /// @param _ids The IDs of the drop tokens to be received
2227     /// @param _amounts The amounts of the drops tokens correspond to `ids`
2228     /// @param _uniqueId The ID of the token to be purchased
2229     function claimMerkleDropAndPurchaseUnique(
2230         uint256 _merkleDropId,
2231         bytes32[] calldata _proof,
2232         ID[] calldata _ids,
2233         uint256[] calldata _amounts,
2234         ID _uniqueId
2235     ) external payable nonReentrant {
2236         require(uniquesPurchasable, "Uniques not currently purchasable");
2237         require(uniques[_uniqueId].exists, "Not a valid unique id");
2238         require(!uniques[_uniqueId].minted, "Not enough uniques remaining");
2239         _claimMerkleDrop(_merkleDropId, _proof, _ids, _amounts, msg.sender);
2240         _purchaseUnique(_uniqueId, msg.sender, msg.value);
2241     }
2242 
2243     /// @notice Emitted when funds are withdrawn from the contract
2244     /// @param to The address to which the funds were sent
2245     /// @param amount The amount of funds sent in wei
2246     event FundsWithdrawn(address to, uint256 amount);
2247 
2248     /// @notice Withdraw funds from the contract
2249     /// @param _to The address to which the funds were sent
2250     /// @param _amount The amount of funds sent, in wei
2251     function withdrawFunds(
2252         address payable _to,
2253         uint256 _amount
2254     ) external onlyOwner nonReentrant {
2255         require(_amount <= address(this).balance, "Not enough funds");
2256         _to.transfer(_amount);
2257         emit FundsWithdrawn(_to, _amount);
2258     }
2259 
2260     /// @notice Emitted when uniquesPurchasable is updated
2261     /// @param purchasable Whether unique tokens are now purchasable
2262     event UniquesPurchasableUpdated(bool purchasable);
2263 
2264     /// @notice Toggle whether unique tokens are purchasable or not
2265     function toggleUniquesPurchasable() external onlyOwner {
2266         uniquesPurchasable = !uniquesPurchasable;
2267         emit UniquesPurchasableUpdated(uniquesPurchasable);
2268     }
2269 
2270     /// @notice Emitted when the default price of unique tokens is updated
2271     /// @param price The new price, in wei
2272     event DefaultPriceUpdated(uint256 price);
2273 
2274     /// @notice Set the default price of unique tokens
2275     /// @param _price The new price, in wei
2276     function setDefaultPrice(uint256 _price) external onlyOwner {
2277         defaultPrice = _price;
2278         emit DefaultPriceUpdated(_price);
2279     }
2280 
2281     /// @notice Emitted when the default drop token requirement to purchase
2282     /// unique tokens is updated
2283     /// @param requirement The new drop token requirement
2284     event DefaultDropTokenRequirementUpdated(uint256 requirement);
2285 
2286     /// @notice Set the default drop token requirement to purchase unique tokens
2287     /// @param _dropTokenRequirement The new drop token requirement
2288     function setDefaultDropTokenRequirement(
2289         uint256 _dropTokenRequirement
2290     ) external onlyOwner {
2291         defaultDropTokenRequirement = _dropTokenRequirement;
2292         emit DefaultDropTokenRequirementUpdated(_dropTokenRequirement);
2293     }
2294 
2295     /// @notice Emitted when the price of a unique token is updated
2296     /// @param id The id of the unique token
2297     /// @param price The new price, in wei
2298     event UniquePriceUpdated(ID id, uint256 price);
2299 
2300     /// @notice Set the price of a specific unique token
2301     /// @param _id The id of the unique token
2302     /// @param _price The new price, in wei
2303     function setUniquePrice(ID _id, uint256 _price) external onlyOwner {
2304         require(uniques[_id].exists, "Not a valid unique id");
2305         uniques[_id].customPrice = true;
2306         uniques[_id].price = _price;
2307         emit UniquePriceUpdated(_id, _price);
2308     }
2309 
2310     /// @notice Emitted when the drop token requirement to purchase a unique
2311     /// token is updated
2312     /// @param id The id of the unique token
2313     /// @param requirement The new drop token requirement
2314     event UniqueDropTokenRequirementUpdated(ID id, uint256 requirement);
2315 
2316     /// @notice Set the minimum drop token requirement to purchase a specific
2317     /// unique token
2318     /// @param _id The id of the unique token
2319     /// @param _dropTokenRequirement The new drop token requirement
2320     function setUniqueDropTokenRequirement(
2321         ID _id,
2322         uint256 _dropTokenRequirement
2323     ) external onlyOwner {
2324         require(uniques[_id].exists, "Not a valid unique id");
2325         uniques[_id].customDropTokenRequirement = true;
2326         uniques[_id].dropTokenRequirement = _dropTokenRequirement;
2327         emit UniqueDropTokenRequirementUpdated(_id, _dropTokenRequirement);
2328     }
2329 
2330     /// @notice Emitted when the price of a unique token is set back to default
2331     /// @param id The ID of the unique token
2332     event UniquePriceDefault(ID id);
2333 
2334     /// @notice Set the price of a specific unique token back to default
2335     /// @param _id The ID of the unique token
2336     function setUniquePriceDefault(ID _id) external onlyOwner {
2337         require(uniques[_id].exists, "Not a valid unique id");
2338         uniques[_id].customPrice = false;
2339         emit UniquePriceDefault(_id);
2340     }
2341 
2342     /// @notice Emitted when the drop token requirement of a unique token is set
2343     /// back to default
2344     /// @param id The ID of the unique token
2345     event UniqueDropTokenRequirementDefault(ID id);
2346 
2347     /// @notice Set the drop token requirement of a specific unique token back to
2348     /// default
2349     /// @param _id The ID of the unique token
2350     function setUniqueDropTokenRequirementDefault(ID _id) external onlyOwner {
2351         require(uniques[_id].exists, "Not a valid unique id");
2352         uniques[_id].customDropTokenRequirement = false;
2353         emit UniqueDropTokenRequirementDefault(_id);
2354     }
2355 }
2356 
2357 
2358 // File contracts/interfaces/IHydra.sol
2359 
2360 pragma solidity ^0.8.9;
2361 
2362 /// @notice Interface for KomuroDragons contract Hydra bidding
2363 interface IHydra {
2364     /// @notice Whether or not an account is eligible to bid on the Hydra
2365     /// @param _account The address of the account
2366     /// @return Whether the account is eligible or not
2367     function canBidOnHydra(address _account) external view returns (bool);
2368 }
2369 
2370 
2371 // File contracts/KomuroDragons.sol
2372 
2373 
2374 
2375 pragma solidity ^0.8.8;
2376 
2377 
2378 
2379 
2380 
2381 /// @title Komuro Dragons
2382 contract KomuroDragons is MerkleDropUniqueToken, IHydra {
2383 
2384     using Strings for uint256;
2385 
2386     /// @param _priceFeed Address of a chainlink AggregatorV3 price feed that
2387     /// controls the Hydra's dynamic URI
2388     /// @param _positiveHydraUri Hydra URI when price is going up
2389     /// @param _neutralHydraUri Hydra URI when price is neutral
2390     /// @param _negativeHydraUri Hydra URI when price is going down
2391     /// @param _tokenBaseURI The base URI for ERC721 metadata
2392     /// @param _name The token name for ERC721 metadata
2393     /// @param _symbol The token symbol for ERC721 metadata
2394     constructor(
2395         address _priceFeed,
2396         string memory _positiveHydraUri,
2397         string memory _neutralHydraUri,
2398         string memory _negativeHydraUri,
2399         string memory _tokenBaseURI,
2400         string memory _name,
2401         string memory _symbol
2402     ) MerkleDropUniqueToken() {
2403         baseURI = _tokenBaseURI;
2404         tokenSymbol = _symbol;
2405         tokenName = _name;
2406         uint256[] memory dropTokenAmounts = new uint256[](15);
2407         for (uint i = 0; i < 4; i ++) {
2408             dropTokenAmounts[i] = 2500;
2409         }
2410         for (uint i = 4; i < 15; i ++) {
2411             dropTokenAmounts[i] = 1;
2412         }
2413         _createDropTokens(dropTokenAmounts);
2414         // Hydra
2415         _initHydra(
2416             _priceFeed,
2417             _positiveHydraUri,
2418             _neutralHydraUri,
2419             _negativeHydraUri
2420         );
2421     }
2422 
2423     /// @notice Whether or not the hydra has been minted
2424     bool public isHydraMinted = false;
2425 
2426     /// @notice The token ID of the Hydra token
2427     ID public hydraId;
2428 
2429     /// @dev The three states the Hydra can exist in - depends on price feed
2430     enum HydraState {
2431         Positive,
2432         Neutral,
2433         Negative
2434     }
2435 
2436     /// @dev See {IERC165-supportsInterface}.
2437     function supportsInterface(
2438         bytes4 interfaceId
2439     ) public view virtual override returns (bool) {
2440         return interfaceId == type(IHydra).interfaceId ||
2441             super.supportsInterface(interfaceId);
2442     }
2443 
2444     /// @notice Get the metadata URI for a given token
2445     /// @param _id The id of the token
2446     /// @return Metadata URI for the token
2447     /// @dev See {IERC1155MetadataURI-uri}.
2448     function uri(
2449         uint256 _id
2450     ) public view virtual override returns (string memory) {
2451         return tokenURI(_id);
2452     }
2453 
2454     /// @notice Get the metadata URI for a given token
2455     /// @param _id The id of the token
2456     /// @return Metadata URI for the token
2457     /// @dev See {IERC721Metadata-tokenURI}.
2458     function tokenURI (
2459         uint256 _id
2460     ) public view virtual override returns (string memory) {
2461         if (isHydraMinted && _id == ID.unwrap(hydraId)) {
2462             return _hydraUri();
2463         } else {
2464             return bytes(_baseURI()).length > 0 ?
2465                 string(abi.encodePacked(_baseURI(), _id.toString())) : "";
2466         }
2467     }
2468 
2469     /// @dev Used as the base of {IERC721Metadata-tokenURI}.
2470     function _baseURI() internal view override returns (string memory) {
2471         return baseURI;
2472     }
2473 
2474     /// @notice The token name
2475     /// @dev See {IERC721Metadata-name}.
2476     function name() public view override returns (string memory) {
2477         return tokenName;
2478     }
2479 
2480     /// @notice The token symbol
2481     /// @dev See {IERC721Metadata-symbol}.
2482     function symbol() public view override returns (string memory) {
2483         return tokenSymbol;
2484     }
2485 
2486     /// @notice The base URI for ERC721 metadata
2487     string public baseURI;
2488 
2489     /// @notice Emitted when `baseURI` is updated
2490     /// @param value The new value of `baseURI`
2491     event BaseURIUpdated(string value);
2492 
2493     /// @notice Update the value of `baseURI`
2494     /// @param _value The new value of `baseURI`
2495     function setBaseURI(string calldata _value) external onlyOwner {
2496         baseURI = _value;
2497         emit BaseURIUpdated(_value);
2498     }
2499 
2500     /// @notice The token name for ERC721 metadata
2501     string public tokenName;
2502 
2503     /// @notice Emitted when `tokenName` is updated
2504     /// @param value The new value of `tokenName`
2505     event TokenNameUpdated(string value);
2506 
2507     /// @notice Update the value of `tokenName`
2508     /// @param _value The new value of `tokenName`
2509     function setTokenName(string calldata _value) external onlyOwner {
2510         tokenName = _value;
2511         emit TokenNameUpdated(_value);
2512     }
2513 
2514     /// @notice The token symbol for ERC721 metadata
2515     string public tokenSymbol;
2516 
2517     /// @notice Emitted when `tokenSymbol` is updated
2518     /// @param value The new value of `tokenSymbol`
2519     event TokenSymbolUpdated(string value);
2520 
2521     /// @notice Update the value of `tokenSymbol`
2522     /// @param _value The new value of `tokenSymbol`
2523     function setTokenSymbol(string calldata _value) external onlyOwner {
2524         tokenSymbol = _value;
2525         emit TokenSymbolUpdated(_value);
2526     }
2527 
2528     /// @notice The Hydra URI when price is going up
2529     string public hydraUriPositive;
2530 
2531     /// @notice Emitted when `hydraUriPositive` is updated
2532     /// @param uri The new uri
2533     event HydraUriPositiveUpdated(string uri);
2534 
2535     /// @notice Set `hydraUriPositive`
2536     /// @param _uri The new uri
2537     function setHydraUriPositive(string calldata _uri) external onlyOwner {
2538         hydraUriPositive = _uri;
2539         emit HydraUriPositiveUpdated(_uri);
2540     }
2541 
2542     /// @notice The Hydra URI when price is neutral
2543     string public hydraUriNeutral;
2544 
2545     /// @notice Emitted when `hydraUriNeutral` is updated
2546     /// @param uri The new uri
2547     event HydraUriNeutralUpdated(string uri);
2548 
2549     /// @notice Set `hydraUriNeutral`
2550     /// @param _uri The new uri
2551     function setHydraUriNeutral(string calldata _uri) external onlyOwner {
2552         hydraUriNeutral = _uri;
2553         emit HydraUriNeutralUpdated(_uri);
2554     }
2555 
2556     /// @notice The Hydra URI when price is going down
2557     string public hydraUriNegative;
2558 
2559     /// @notice Emitted when `hydraUriNegative` is updated
2560     /// @param uri The new uri
2561     event HydraUriNegativeUpdated(string uri);
2562 
2563     /// @notice Set `hydraUriNegative`
2564     /// @param _uri The new uri
2565     function setHydraUriNegative(string calldata _uri) external onlyOwner {
2566         hydraUriNegative = _uri;
2567         emit HydraUriNegativeUpdated(_uri);
2568     }
2569 
2570     /// @notice The number of price feed rounds to go back and get the "before"
2571     /// time in price difference calculations
2572     uint80 public pricePeriod = 1;
2573 
2574     /// @notice Emitted when `pricePeriod` is updated
2575     /// @param value The new value
2576     event PricePeriodUpdated(uint80 value);
2577 
2578     /// @notice Set `pricePeriod`
2579     /// @param _value The new value
2580     function setPricePeriod(uint80 _value) external onlyOwner {
2581         pricePeriod = _value;
2582         emit PricePeriodUpdated(_value);
2583     }
2584 
2585     /// @notice The multiplier used in price difference calculations to increase
2586     /// resolution
2587     int256 public priceMultiplier = 10000;
2588 
2589     /// @notice Emitted when `priceMultiplier` is updated
2590     /// @param value The new value
2591     event PriceMultiplierUpdated(int256 value);
2592 
2593     /// @notice Set `priceMultiplier`
2594     /// @param _value The new value
2595     function setPriceMultiplier(int256 _value) external onlyOwner {
2596         priceMultiplier = _value;
2597         emit PriceMultiplierUpdated(_value);
2598     }
2599 
2600     /// @notice The minimum positive price difference after being multiplied by
2601     /// the `priceMultiplier` to count as a positive change, the negative of
2602     /// this for negative change
2603     int256 public minPriceDifference = 30;
2604 
2605     /// @notice Emitted when `minPriceDifference` is updated
2606     /// @param value The new value
2607     event MinPriceDifferenceUpdated(int256 value);
2608 
2609     /// @notice Set `minPriceDifference`
2610     /// @param _value The new value
2611     function setMinPriceDifference(int256 _value) external onlyOwner {
2612         minPriceDifference = _value;
2613         emit MinPriceDifferenceUpdated(_value);
2614     }
2615 
2616     /// @notice The chainlink AggregatorV3Interface-compatible contract that
2617     /// provides price feed information for the Hydra's dynamic URI feature
2618     AggregatorV3Interface public priceFeed;
2619 
2620     /// @notice Emitted when the price feed is updated
2621     /// @param priceFeed The address of the price feed contract
2622     event PriceFeedUpdated(address priceFeed);
2623 
2624     /// @notice Update the price feed
2625     /// @param _priceFeed The address of the chainlink
2626     /// AggregatorV3Interface-compatible price feed contract
2627     function setPriceFeed(address _priceFeed) external onlyOwner {
2628         priceFeed = AggregatorV3Interface(_priceFeed);
2629         emit PriceFeedUpdated(_priceFeed);
2630     }
2631 
2632     /// @notice The number of drop tokens needed to take part in the Hydra
2633     /// auction
2634     uint256 public hydraDropTokenRequirement = 1;
2635 
2636     /// @notice Emitted when the number of drop tokens required to bid on the
2637     /// Hydra is updated
2638     /// @param requirement The number of drop tokens required
2639     event HydraDropTokenRequirementUpdated(uint256 requirement);
2640 
2641     /// @notice Set the number of drop tokens required to bid on the Hydra
2642     /// @param _dropTokenRequirement The number of drop tokens required
2643     function setHydraDropTokenRequirement(
2644         uint256 _dropTokenRequirement
2645     ) external onlyOwner {
2646         hydraDropTokenRequirement = _dropTokenRequirement;
2647         emit HydraDropTokenRequirementUpdated(_dropTokenRequirement);
2648     }
2649 
2650     function _initHydra(
2651         address _priceFeed,
2652         string memory _positiveUri,
2653         string memory _neutralUri,
2654         string memory _negativeUri
2655     ) internal {
2656         priceFeed = AggregatorV3Interface(_priceFeed);
2657         hydraUriPositive = _positiveUri;
2658         hydraUriNeutral = _neutralUri;
2659         hydraUriNegative = _negativeUri;
2660     }
2661 
2662     function _getHydraState() internal view returns (HydraState) {
2663         (uint80 roundId, int currentPrice,,,) = priceFeed.latestRoundData();
2664         (, int previousPrice,,,) = priceFeed.getRoundData(
2665             roundId - pricePeriod
2666         );
2667         int256 priceDifference = previousPrice == int256(0) ? int256(0) :
2668             ((currentPrice - previousPrice) * priceMultiplier) / previousPrice;
2669         if (priceDifference >= minPriceDifference) {
2670             return HydraState.Positive;
2671         }
2672         if (priceDifference <= -minPriceDifference) {
2673             return HydraState.Negative;
2674         } 
2675         return HydraState.Neutral;
2676     }
2677 
2678     function _hydraUri() internal view returns (string memory) {
2679         HydraState state = _getHydraState();
2680         if (state == HydraState.Positive) {
2681             return hydraUriPositive;
2682         } else if (state == HydraState.Neutral) {
2683             return hydraUriNeutral;
2684         } else {
2685             return hydraUriNegative;
2686         }
2687     }
2688 
2689     /// @notice Whether or not an account is eligible to bid on the Hydra
2690     /// @param _account The address of the account
2691     /// @return Whether the account is eligible or not
2692     function canBidOnHydra(
2693         address _account
2694     ) external view override returns (bool) {
2695         return _dropTokenBalanceOf(_account) >= hydraDropTokenRequirement;
2696     }
2697 
2698     /// @notice Transfer the hydra to another owner
2699     /// @param _to The address of the new owner
2700     function transferHydra(address _to) external onlyOwner nonReentrant {
2701         require(!isHydraMinted, "Not enough hydras remaining");
2702 
2703         hydraId = nextId;
2704         nextId = IDUtils.next(nextId);
2705         _registerERC721(ID.unwrap(hydraId));
2706 
2707         _mint(_to, ID.unwrap(hydraId), 1, "");
2708 
2709         isHydraMinted = true;
2710     }
2711 }