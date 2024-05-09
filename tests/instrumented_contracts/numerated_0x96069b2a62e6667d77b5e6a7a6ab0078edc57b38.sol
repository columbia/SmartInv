1 // SPDX-License-Identifier: GPL-3.0
2 /*
3 
4 ██████╗░██╗██╗░░██╗███████╗██╗░░░░░░██████╗░█████╗░██╗░░░██╗██████╗░██╗░░░██╗░██████╗
5 ██╔══██╗██║╚██╗██╔╝██╔════╝██║░░░░░██╔════╝██╔══██╗██║░░░██║██╔══██╗██║░░░██║██╔════╝
6 ██████╔╝██║░╚███╔╝░█████╗░░██║░░░░░╚█████╗░███████║██║░░░██║██████╔╝██║░░░██║╚█████╗░
7 ██╔═══╝░██║░██╔██╗░██╔══╝░░██║░░░░░░╚═══██╗██╔══██║██║░░░██║██╔══██╗██║░░░██║░╚═══██╗
8 ██║░░░░░██║██╔╝╚██╗███████╗███████╗██████╔╝██║░░██║╚██████╔╝██║░░██║╚██████╔╝██████╔╝
9 ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚══════╝╚══════╝╚═════╝░╚═╝░░╚═╝░╚═════╝░╚═╝░░╚═╝░╚═════╝░╚═════╝░
10 
11 dddddddooooooooooooooooooooooooooolllllllllllllllllllllllllllccccccccccccccccccc
12 dddddddddddooooooooooooooooooooooooooolllllllllllllllllllllllllllccccccccccccccc
13 dddddddddddddddoooooooooooooooooooooooooolllllllllllllllllllllllllllcccccccccccc
14 dddddddddddddddddoooooooooooooooooooooooooooololllllllllllllllllllllllllcccccccc
15 dddddddddddddddddddddoooooooooooooooooooooooooooolllllllllllllllllllllllllllcccc
16 ddddddddddddddddddddddddoddooooooooooooooooooooooooolllllllllllllllllllllllllllc
17 ddddddddddddddddddddddddddoodx0000000000000kooooooooooolllllllllllllllllllllllll
18 xxxxddddddddddddddddddddddddd0Xd:;;;;;:;;cOK0O00Oddddooooooollllllllllllllllllll
19 xxxxxxxxdddddddddddddddddddddkKKd,..',,,,,,,,,:dOkkO00kxdoooooolllllllllllllllll
20 xxxxxxxxxxxdddddddddddddddddddxOKXx;''',;;;,,,,'''.,lxx0XOkxooooolllllllllllllll
21 xxxxxxxxxxxxxdddddddddddddddddddxOXXdcc,.',;;;;;;;;;'..;ookXKxooooooolllllllllll
22 xxxxxxxxxxxxxxxxxxddddddk0KKKKK0kdxO0KN0dl,.,;;;;;'..',,..,:kNKxoooooooollllllll
23 xxxxxxxxxxxxxxxxxxxddxk0X0o;;;cOXKkdddk0XX0l.';;;;..:l:;;;,'':0Xxooooooooooollll
24 xxxxxxxxxxxxxxxxxxxxk0K0o;''',;;lkKKOxx0XXKo.';;;;. .,;;;;;;..oKKOdooooooooooool
25 xxxxxxxxxxxxxxxxxxkKX0o;,,''',;::,ckKXXKkd:,;;:::;'...,;;;;;;,';d0Kxoooooooooooo
26 kkxxxxxxxxxxxxxxkKN0l;,;,;lxdc,,:l:,cdo:'':lcc:,'',::::,',;;,',' lNOoooooooooooo
27 kkkkkxxxxxxxxxkKN0l:;,,;lxxxxxo..ldo:;;cooooooc..l:':cc' .';;';' lNOoooooooooooo
28 kkkkkkkkxxxxkKXKo::;,;cdxxxxxxdl;,:odxdddddollc.;KKd;,c, .'';:c, lNOoooooooooooo
29 kkkkkkkkkkkx0Wd'cc.'cldxxddddddddl,.lxxxxdo:;,,.:kXXl,:,.'lko;;,'dNOoddooooooooo
30 kkkkkkkkkkkx0Wl.oo.'lldxdoxdcoxdo:,,okkoc:;:xkkkd:lkKOc;,.'d0Koo0X0xddddddoooooo
31 kkkkkkkkkkkOXWl.ok:,,codooddoddd:.;kOxc,,;okkkOOOO;.kMWkcccckNXK0xdddddddddddooo
32 kkkkkkkkkkOX0lcc:;;::,,cllloxdl;,:dO0l.,dddxxxkkkk;.xN0000000kxddddddddddddddddd
33 kkkkkkkkkkONk'.;oxxo:c:',:coxdc.'k000o.'loooddxxxx,.xXkddddddddddddddddddddddddd
34 kkkkkkkkkkOKX0l;OWNKk:;d;.;loo:.'kK0Ko..cllloooddd,.xXkdxxdxxddddddddddddddddddd
35 kkkkkkkkkkkkOKKKK0OXK;'k: 'ldo:.'kK0Ko..::cclllooo'.xXkxxxxxxxxddddddddddddddddd
36 OOOOkkkkkkkkkkkkkkkXK;,k: 'lxo;.'kK0d;.';;::ccclc;;l0Xkxxxxxxxxxxxxxdddddddddddd
37 OOOOOOkOkkkkkkkkkkkXK;'kc .:cc;.'kKk'.';,,;,....,l0NKkxxxxxxxxxxxxxxxxdddddddddd
38 OOOOOOOOOOOkkkkkkkOXK;'kc .,,;,.'x0k' .''''. ,c.;KXOxxxxxxxxxxxxxxxxxxxxxxxddddd
39 OOOOOOOOOOOOOOOOkkOXK;.oc'''''''..ok'.''';xl.:k,;KKkxxxxxxxxxxxxxxxxxxxxxxxxxxdd
40 OOOOOOOOOOOOOOOOkkOXK,.;xXXOc,cOd.ck',OXXNWx.:k,;KXOkxxxxxxxxxxxxxxxxxxxxxxxxxxx
41 OOOOOOOOOOOOOOOOOOOKXddXNKKXWWNkl:dOoco0MNkl:xOoco0NKOkxxxxxxxxxxxxxxxxxxxxxxxxx
42 OOOOOOOOOOOOOOOOOOOOKKKKOkk0NO:..,:;:' oMK;.,;;:' .l0XOxkkxxxxxxxxxxxxxxxxxxxxxx
43 OOOOOOOOOOOOOOOOOOOOOOOOOOkKWo.ll.:d''dKWN0c.:d''d:'kNOkkkkkkxxxxxxxxxxxxxxxxxxx
44 OOOOOOOOOOOOOOOOOOOOOOOOOOO0XKOXXOKX00XKO0KKOKN00XKOKKkkkkkkkkkkkkxxxxxxxxxxxxxx
45 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkOOOOOOOOOOOkkkkkkkkkkkkkkkxxxxxxxxxxxx
46 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxxxxxxxx
47 0OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxxxxx
48 0000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkx
49 00000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
50 0000000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
51 */
52 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
53 
54 
55 
56 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev String operations.
62  */
63 library StringsUpgradeable {
64     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
68      */
69     function toString(uint256 value) internal pure returns (string memory) {
70         // Inspired by OraclizeAPI's implementation - MIT licence
71         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
72 
73         if (value == 0) {
74             return "0";
75         }
76         uint256 temp = value;
77         uint256 digits;
78         while (temp != 0) {
79             digits++;
80             temp /= 10;
81         }
82         bytes memory buffer = new bytes(digits);
83         while (value != 0) {
84             digits -= 1;
85             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
86             value /= 10;
87         }
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
93      */
94     function toHexString(uint256 value) internal pure returns (string memory) {
95         if (value == 0) {
96             return "0x00";
97         }
98         uint256 temp = value;
99         uint256 length = 0;
100         while (temp != 0) {
101             length++;
102             temp >>= 8;
103         }
104         return toHexString(value, length);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
109      */
110     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
111         bytes memory buffer = new bytes(2 * length + 2);
112         buffer[0] = "0";
113         buffer[1] = "x";
114         for (uint256 i = 2 * length + 1; i > 1; --i) {
115             buffer[i] = _HEX_SYMBOLS[value & 0xf];
116             value >>= 4;
117         }
118         require(value == 0, "Strings: hex length insufficient");
119         return string(buffer);
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/Context.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Provides information about the current execution context, including the
132  * sender of the transaction and its data. While these are generally available
133  * via msg.sender and msg.data, they should not be accessed in such a direct
134  * manner, since when dealing with meta-transactions the account sending and
135  * paying for execution may not be the actual sender (as far as an application
136  * is concerned).
137  *
138  * This contract is only required for intermediate, library-like contracts.
139  */
140 abstract contract Context {
141     function _msgSender() internal view virtual returns (address) {
142         return msg.sender;
143     }
144 
145     function _msgData() internal view virtual returns (bytes calldata) {
146         return msg.data;
147     }
148 }
149 
150 // File: @openzeppelin/contracts/access/Ownable.sol
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
154 
155 pragma solidity ^0.8.0;
156 
157 
158 /**
159  * @dev Contract module which provides a basic access control mechanism, where
160  * there is an account (an owner) that can be granted exclusive access to
161  * specific functions.
162  *
163  * By default, the owner account will be the one that deploys the contract. This
164  * can later be changed with {transferOwnership}.
165  *
166  * This module is used through inheritance. It will make available the modifier
167  * `onlyOwner`, which can be applied to your functions to restrict their use to
168  * the owner.
169  */
170 abstract contract Ownable is Context {
171     address private _owner;
172 
173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
174 
175     /**
176      * @dev Initializes the contract setting the deployer as the initial owner.
177      */
178     constructor() {
179         _transferOwnership(_msgSender());
180     }
181 
182     /**
183      * @dev Returns the address of the current owner.
184      */
185     function owner() public view virtual returns (address) {
186         return _owner;
187     }
188 
189     /**
190      * @dev Throws if called by any account other than the owner.
191      */
192     modifier onlyOwner() {
193         require(owner() == _msgSender(), "Ownable: caller is not the owner");
194         _;
195     }
196 
197     /**
198      * @dev Leaves the contract without owner. It will not be possible to call
199      * `onlyOwner` functions anymore. Can only be called by the current owner.
200      *
201      * NOTE: Renouncing ownership will leave the contract without an owner,
202      * thereby removing any functionality that is only available to the owner.
203      */
204     function renounceOwnership() public virtual onlyOwner {
205         _transferOwnership(address(0));
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Can only be called by the current owner.
211      */
212     function transferOwnership(address newOwner) public virtual onlyOwner {
213         require(newOwner != address(0), "Ownable: new owner is the zero address");
214         _transferOwnership(newOwner);
215     }
216 
217     /**
218      * @dev Transfers ownership of the contract to a new account (`newOwner`).
219      * Internal function without access restriction.
220      */
221     function _transferOwnership(address newOwner) internal virtual {
222         address oldOwner = _owner;
223         _owner = newOwner;
224         emit OwnershipTransferred(oldOwner, newOwner);
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev These functions deal with verification of Merkle Trees proofs.
237  *
238  * The proofs can be generated using the JavaScript library
239  * https://github.com/miguelmota/merkletreejs[merkletreejs].
240  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
241  *
242  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
243  *
244  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
245  * hashing, or use a hash function other than keccak256 for hashing leaves.
246  * This is because the concatenation of a sorted pair of internal nodes in
247  * the merkle tree could be reinterpreted as a leaf value.
248  */
249 library MerkleProof {
250     /**
251      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
252      * defined by `root`. For this, a `proof` must be provided, containing
253      * sibling hashes on the branch from the leaf to the root of the tree. Each
254      * pair of leaves and each pair of pre-images are assumed to be sorted.
255      */
256     function verify(
257         bytes32[] memory proof,
258         bytes32 root,
259         bytes32 leaf
260     ) internal pure returns (bool) {
261         return processProof(proof, leaf) == root;
262     }
263 
264     /**
265      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
266      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
267      * hash matches the root of the tree. When processing the proof, the pairs
268      * of leafs & pre-images are assumed to be sorted.
269      *
270      * _Available since v4.4._
271      */
272     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
273         bytes32 computedHash = leaf;
274         for (uint256 i = 0; i < proof.length; i++) {
275             bytes32 proofElement = proof[i];
276             if (computedHash <= proofElement) {
277                 // Hash(current computed hash + current element of the proof)
278                 computedHash = _efficientHash(computedHash, proofElement);
279             } else {
280                 // Hash(current element of the proof + current computed hash)
281                 computedHash = _efficientHash(proofElement, computedHash);
282             }
283         }
284         return computedHash;
285     }
286 
287     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
288         assembly {
289             mstore(0x00, a)
290             mstore(0x20, b)
291             value := keccak256(0x00, 0x40)
292         }
293     }
294 }
295 
296 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
297 
298 
299 // ERC721A Contracts v4.1.0
300 // Creator: Chiru Labs
301 
302 pragma solidity ^0.8.4;
303 
304 /**
305  * @dev Interface of an ERC721A compliant contract.
306  */
307 interface IERC721A {
308     /**
309      * The caller must own the token or be an approved operator.
310      */
311     error ApprovalCallerNotOwnerNorApproved();
312 
313     /**
314      * The token does not exist.
315      */
316     error ApprovalQueryForNonexistentToken();
317 
318     /**
319      * The caller cannot approve to their own address.
320      */
321     error ApproveToCaller();
322 
323     /**
324      * Cannot query the balance for the zero address.
325      */
326     error BalanceQueryForZeroAddress();
327 
328     /**
329      * Cannot mint to the zero address.
330      */
331     error MintToZeroAddress();
332 
333     /**
334      * The quantity of tokens minted must be more than zero.
335      */
336     error MintZeroQuantity();
337 
338     /**
339      * The token does not exist.
340      */
341     error OwnerQueryForNonexistentToken();
342 
343     /**
344      * The caller must own the token or be an approved operator.
345      */
346     error TransferCallerNotOwnerNorApproved();
347 
348     /**
349      * The token must be owned by `from`.
350      */
351     error TransferFromIncorrectOwner();
352 
353     /**
354      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
355      */
356     error TransferToNonERC721ReceiverImplementer();
357 
358     /**
359      * Cannot transfer to the zero address.
360      */
361     error TransferToZeroAddress();
362 
363     /**
364      * The token does not exist.
365      */
366     error URIQueryForNonexistentToken();
367 
368     /**
369      * The `quantity` minted with ERC2309 exceeds the safety limit.
370      */
371     error MintERC2309QuantityExceedsLimit();
372 
373     /**
374      * The `extraData` cannot be set on an unintialized ownership slot.
375      */
376     error OwnershipNotInitializedForExtraData();
377 
378     struct TokenOwnership {
379         // The address of the owner.
380         address addr;
381         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
382         uint64 startTimestamp;
383         // Whether the token has been burned.
384         bool burned;
385         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
386         uint24 extraData;
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
564 
565     // ==============================
566     //            IERC2309
567     // ==============================
568 
569     /**
570      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
571      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
572      */
573     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
574 }
575 
576 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
577 
578 
579 // ERC721A Contracts v4.1.0
580 // Creator: Chiru Labs
581 
582 pragma solidity ^0.8.4;
583 
584 
585 /**
586  * @dev ERC721 token receiver interface.
587  */
588 interface ERC721A__IERC721Receiver {
589     function onERC721Received(
590         address operator,
591         address from,
592         uint256 tokenId,
593         bytes calldata data
594     ) external returns (bytes4);
595 }
596 
597 /**
598  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
599  * including the Metadata extension. Built to optimize for lower gas during batch mints.
600  *
601  * Assumes serials are sequentially minted starting at `_startTokenId()`
602  * (defaults to 0, e.g. 0, 1, 2, 3..).
603  *
604  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
605  *
606  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
607  */
608 contract ERC721A is IERC721A {
609     // Mask of an entry in packed address data.
610     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
611 
612     // The bit position of `numberMinted` in packed address data.
613     uint256 private constant BITPOS_NUMBER_MINTED = 64;
614 
615     // The bit position of `numberBurned` in packed address data.
616     uint256 private constant BITPOS_NUMBER_BURNED = 128;
617 
618     // The bit position of `aux` in packed address data.
619     uint256 private constant BITPOS_AUX = 192;
620 
621     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
622     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
623 
624     // The bit position of `startTimestamp` in packed ownership.
625     uint256 private constant BITPOS_START_TIMESTAMP = 160;
626 
627     // The bit mask of the `burned` bit in packed ownership.
628     uint256 private constant BITMASK_BURNED = 1 << 224;
629 
630     // The bit position of the `nextInitialized` bit in packed ownership.
631     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
632 
633     // The bit mask of the `nextInitialized` bit in packed ownership.
634     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
635 
636     // The bit position of `extraData` in packed ownership.
637     uint256 private constant BITPOS_EXTRA_DATA = 232;
638 
639     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
640     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
641 
642     // The mask of the lower 160 bits for addresses.
643     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
644 
645     // The maximum `quantity` that can be minted with `_mintERC2309`.
646     // This limit is to prevent overflows on the address data entries.
647     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
648     // is required to cause an overflow, which is unrealistic.
649     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
650 
651     // The tokenId of the next token to be minted.
652     uint256 private _currentIndex;
653 
654     // The number of tokens burned.
655     uint256 private _burnCounter;
656 
657     // Token name
658     string private _name;
659 
660     // Token symbol
661     string private _symbol;
662 
663     // Mapping from token ID to ownership details
664     // An empty struct value does not necessarily mean the token is unowned.
665     // See `_packedOwnershipOf` implementation for details.
666     //
667     // Bits Layout:
668     // - [0..159]   `addr`
669     // - [160..223] `startTimestamp`
670     // - [224]      `burned`
671     // - [225]      `nextInitialized`
672     // - [232..255] `extraData`
673     mapping(uint256 => uint256) private _packedOwnerships;
674 
675     // Mapping owner address to address data.
676     //
677     // Bits Layout:
678     // - [0..63]    `balance`
679     // - [64..127]  `numberMinted`
680     // - [128..191] `numberBurned`
681     // - [192..255] `aux`
682     mapping(address => uint256) private _packedAddressData;
683 
684     // Mapping from token ID to approved address.
685     mapping(uint256 => address) private _tokenApprovals;
686 
687     // Mapping from owner to operator approvals
688     mapping(address => mapping(address => bool)) private _operatorApprovals;
689 
690     constructor(string memory name_, string memory symbol_) {
691         _name = name_;
692         _symbol = symbol_;
693         _currentIndex = _startTokenId();
694     }
695 
696     /**
697      * @dev Returns the starting token ID.
698      * To change the starting token ID, please override this function.
699      */
700     function _startTokenId() internal view virtual returns (uint256) {
701         return 0;
702     }
703 
704     /**
705      * @dev Returns the next token ID to be minted.
706      */
707     function _nextTokenId() internal view returns (uint256) {
708         return _currentIndex;
709     }
710 
711     /**
712      * @dev Returns the total number of tokens in existence.
713      * Burned tokens will reduce the count.
714      * To get the total number of tokens minted, please see `_totalMinted`.
715      */
716     function totalSupply() public view override returns (uint256) {
717         // Counter underflow is impossible as _burnCounter cannot be incremented
718         // more than `_currentIndex - _startTokenId()` times.
719         unchecked {
720             return _currentIndex - _burnCounter - _startTokenId();
721         }
722     }
723 
724     /**
725      * @dev Returns the total amount of tokens minted in the contract.
726      */
727     function _totalMinted() internal view returns (uint256) {
728         // Counter underflow is impossible as _currentIndex does not decrement,
729         // and it is initialized to `_startTokenId()`
730         unchecked {
731             return _currentIndex - _startTokenId();
732         }
733     }
734 
735     /**
736      * @dev Returns the total number of tokens burned.
737      */
738     function _totalBurned() internal view returns (uint256) {
739         return _burnCounter;
740     }
741 
742     /**
743      * @dev See {IERC165-supportsInterface}.
744      */
745     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
746         // The interface IDs are constants representing the first 4 bytes of the XOR of
747         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
748         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
749         return
750             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
751             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
752             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
753     }
754 
755     /**
756      * @dev See {IERC721-balanceOf}.
757      */
758     function balanceOf(address owner) public view override returns (uint256) {
759         if (owner == address(0)) revert BalanceQueryForZeroAddress();
760         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
761     }
762 
763     /**
764      * Returns the number of tokens minted by `owner`.
765      */
766     function _numberMinted(address owner) internal view returns (uint256) {
767         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
768     }
769 
770     /**
771      * Returns the number of tokens burned by or on behalf of `owner`.
772      */
773     function _numberBurned(address owner) internal view returns (uint256) {
774         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
775     }
776 
777     /**
778      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
779      */
780     function _getAux(address owner) internal view returns (uint64) {
781         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
782     }
783 
784     /**
785      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
786      * If there are multiple variables, please pack them into a uint64.
787      */
788     function _setAux(address owner, uint64 aux) internal {
789         uint256 packed = _packedAddressData[owner];
790         uint256 auxCasted;
791         // Cast `aux` with assembly to avoid redundant masking.
792         assembly {
793             auxCasted := aux
794         }
795         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
796         _packedAddressData[owner] = packed;
797     }
798 
799     /**
800      * Returns the packed ownership data of `tokenId`.
801      */
802     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
803         uint256 curr = tokenId;
804 
805         unchecked {
806             if (_startTokenId() <= curr)
807                 if (curr < _currentIndex) {
808                     uint256 packed = _packedOwnerships[curr];
809                     // If not burned.
810                     if (packed & BITMASK_BURNED == 0) {
811                         // Invariant:
812                         // There will always be an ownership that has an address and is not burned
813                         // before an ownership that does not have an address and is not burned.
814                         // Hence, curr will not underflow.
815                         //
816                         // We can directly compare the packed value.
817                         // If the address is zero, packed is zero.
818                         while (packed == 0) {
819                             packed = _packedOwnerships[--curr];
820                         }
821                         return packed;
822                     }
823                 }
824         }
825         revert OwnerQueryForNonexistentToken();
826     }
827 
828     /**
829      * Returns the unpacked `TokenOwnership` struct from `packed`.
830      */
831     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
832         ownership.addr = address(uint160(packed));
833         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
834         ownership.burned = packed & BITMASK_BURNED != 0;
835         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
836     }
837 
838     /**
839      * Returns the unpacked `TokenOwnership` struct at `index`.
840      */
841     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
842         return _unpackedOwnership(_packedOwnerships[index]);
843     }
844 
845     /**
846      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
847      */
848     function _initializeOwnershipAt(uint256 index) internal {
849         if (_packedOwnerships[index] == 0) {
850             _packedOwnerships[index] = _packedOwnershipOf(index);
851         }
852     }
853 
854     /**
855      * Gas spent here starts off proportional to the maximum mint batch size.
856      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
857      */
858     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
859         return _unpackedOwnership(_packedOwnershipOf(tokenId));
860     }
861 
862     /**
863      * @dev Packs ownership data into a single uint256.
864      */
865     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
866         assembly {
867             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
868             owner := and(owner, BITMASK_ADDRESS)
869             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
870             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
871         }
872     }
873 
874     /**
875      * @dev See {IERC721-ownerOf}.
876      */
877     function ownerOf(uint256 tokenId) public view override returns (address) {
878         return address(uint160(_packedOwnershipOf(tokenId)));
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-name}.
883      */
884     function name() public view virtual override returns (string memory) {
885         return _name;
886     }
887 
888     /**
889      * @dev See {IERC721Metadata-symbol}.
890      */
891     function symbol() public view virtual override returns (string memory) {
892         return _symbol;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-tokenURI}.
897      */
898     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
899         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
900 
901         string memory baseURI = _baseURI();
902         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
903     }
904 
905     /**
906      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
907      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
908      * by default, it can be overridden in child contracts.
909      */
910     function _baseURI() internal view virtual returns (string memory) {
911         return '';
912     }
913 
914     /**
915      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
916      */
917     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
918         // For branchless setting of the `nextInitialized` flag.
919         assembly {
920             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
921             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
922         }
923     }
924 
925     /**
926      * @dev See {IERC721-approve}.
927      */
928     function approve(address to, uint256 tokenId) public override {
929         address owner = ownerOf(tokenId);
930 
931         if (_msgSenderERC721A() != owner)
932             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
933                 revert ApprovalCallerNotOwnerNorApproved();
934             }
935 
936         _tokenApprovals[tokenId] = to;
937         emit Approval(owner, to, tokenId);
938     }
939 
940     /**
941      * @dev See {IERC721-getApproved}.
942      */
943     function getApproved(uint256 tokenId) public view override returns (address) {
944         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
945 
946         return _tokenApprovals[tokenId];
947     }
948 
949     /**
950      * @dev See {IERC721-setApprovalForAll}.
951      */
952     function setApprovalForAll(address operator, bool approved) public virtual override {
953         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
954 
955         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
956         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
957     }
958 
959     /**
960      * @dev See {IERC721-isApprovedForAll}.
961      */
962     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
963         return _operatorApprovals[owner][operator];
964     }
965 
966     /**
967      * @dev See {IERC721-safeTransferFrom}.
968      */
969     function safeTransferFrom(
970         address from,
971         address to,
972         uint256 tokenId
973     ) public virtual override {
974         safeTransferFrom(from, to, tokenId, '');
975     }
976 
977     /**
978      * @dev See {IERC721-safeTransferFrom}.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) public virtual override {
986         transferFrom(from, to, tokenId);
987         if (to.code.length != 0)
988             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
989                 revert TransferToNonERC721ReceiverImplementer();
990             }
991     }
992 
993     /**
994      * @dev Returns whether `tokenId` exists.
995      *
996      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
997      *
998      * Tokens start existing when they are minted (`_mint`),
999      */
1000     function _exists(uint256 tokenId) internal view returns (bool) {
1001         return
1002             _startTokenId() <= tokenId &&
1003             tokenId < _currentIndex && // If within bounds,
1004             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1005     }
1006 
1007     /**
1008      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1009      */
1010     function _safeMint(address to, uint256 quantity) internal {
1011         _safeMint(to, quantity, '');
1012     }
1013 
1014     /**
1015      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - If `to` refers to a smart contract, it must implement
1020      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1021      * - `quantity` must be greater than 0.
1022      *
1023      * See {_mint}.
1024      *
1025      * Emits a {Transfer} event for each mint.
1026      */
1027     function _safeMint(
1028         address to,
1029         uint256 quantity,
1030         bytes memory _data
1031     ) internal {
1032         _mint(to, quantity);
1033 
1034         unchecked {
1035             if (to.code.length != 0) {
1036                 uint256 end = _currentIndex;
1037                 uint256 index = end - quantity;
1038                 do {
1039                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1040                         revert TransferToNonERC721ReceiverImplementer();
1041                     }
1042                 } while (index < end);
1043                 // Reentrancy protection.
1044                 if (_currentIndex != end) revert();
1045             }
1046         }
1047     }
1048 
1049     /**
1050      * @dev Mints `quantity` tokens and transfers them to `to`.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `quantity` must be greater than 0.
1056      *
1057      * Emits a {Transfer} event for each mint.
1058      */
1059     function _mint(address to, uint256 quantity) internal {
1060         uint256 startTokenId = _currentIndex;
1061         if (to == address(0)) revert MintToZeroAddress();
1062         if (quantity == 0) revert MintZeroQuantity();
1063 
1064         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1065 
1066         // Overflows are incredibly unrealistic.
1067         // `balance` and `numberMinted` have a maximum limit of 2**64.
1068         // `tokenId` has a maximum limit of 2**256.
1069         unchecked {
1070             // Updates:
1071             // - `balance += quantity`.
1072             // - `numberMinted += quantity`.
1073             //
1074             // We can directly add to the `balance` and `numberMinted`.
1075             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1076 
1077             // Updates:
1078             // - `address` to the owner.
1079             // - `startTimestamp` to the timestamp of minting.
1080             // - `burned` to `false`.
1081             // - `nextInitialized` to `quantity == 1`.
1082             _packedOwnerships[startTokenId] = _packOwnershipData(
1083                 to,
1084                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1085             );
1086 
1087             uint256 tokenId = startTokenId;
1088             uint256 end = startTokenId + quantity;
1089             do {
1090                 emit Transfer(address(0), to, tokenId++);
1091             } while (tokenId < end);
1092 
1093             _currentIndex = end;
1094         }
1095         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1096     }
1097 
1098     /**
1099      * @dev Mints `quantity` tokens and transfers them to `to`.
1100      *
1101      * This function is intended for efficient minting only during contract creation.
1102      *
1103      * It emits only one {ConsecutiveTransfer} as defined in
1104      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1105      * instead of a sequence of {Transfer} event(s).
1106      *
1107      * Calling this function outside of contract creation WILL make your contract
1108      * non-compliant with the ERC721 standard.
1109      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1110      * {ConsecutiveTransfer} event is only permissible during contract creation.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `quantity` must be greater than 0.
1116      *
1117      * Emits a {ConsecutiveTransfer} event.
1118      */
1119     function _mintERC2309(address to, uint256 quantity) internal {
1120         uint256 startTokenId = _currentIndex;
1121         if (to == address(0)) revert MintToZeroAddress();
1122         if (quantity == 0) revert MintZeroQuantity();
1123         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1124 
1125         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1126 
1127         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1128         unchecked {
1129             // Updates:
1130             // - `balance += quantity`.
1131             // - `numberMinted += quantity`.
1132             //
1133             // We can directly add to the `balance` and `numberMinted`.
1134             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1135 
1136             // Updates:
1137             // - `address` to the owner.
1138             // - `startTimestamp` to the timestamp of minting.
1139             // - `burned` to `false`.
1140             // - `nextInitialized` to `quantity == 1`.
1141             _packedOwnerships[startTokenId] = _packOwnershipData(
1142                 to,
1143                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1144             );
1145 
1146             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1147 
1148             _currentIndex = startTokenId + quantity;
1149         }
1150         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1151     }
1152 
1153     /**
1154      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1155      */
1156     function _getApprovedAddress(uint256 tokenId)
1157         private
1158         view
1159         returns (uint256 approvedAddressSlot, address approvedAddress)
1160     {
1161         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1162         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1163         assembly {
1164             // Compute the slot.
1165             mstore(0x00, tokenId)
1166             mstore(0x20, tokenApprovalsPtr.slot)
1167             approvedAddressSlot := keccak256(0x00, 0x40)
1168             // Load the slot's value from storage.
1169             approvedAddress := sload(approvedAddressSlot)
1170         }
1171     }
1172 
1173     /**
1174      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1175      */
1176     function _isOwnerOrApproved(
1177         address approvedAddress,
1178         address from,
1179         address msgSender
1180     ) private pure returns (bool result) {
1181         assembly {
1182             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1183             from := and(from, BITMASK_ADDRESS)
1184             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1185             msgSender := and(msgSender, BITMASK_ADDRESS)
1186             // `msgSender == from || msgSender == approvedAddress`.
1187             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1188         }
1189     }
1190 
1191     /**
1192      * @dev Transfers `tokenId` from `from` to `to`.
1193      *
1194      * Requirements:
1195      *
1196      * - `to` cannot be the zero address.
1197      * - `tokenId` token must be owned by `from`.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function transferFrom(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) public virtual override {
1206         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1207 
1208         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1209 
1210         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1211 
1212         // The nested ifs save around 20+ gas over a compound boolean condition.
1213         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1214             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1215 
1216         if (to == address(0)) revert TransferToZeroAddress();
1217 
1218         _beforeTokenTransfers(from, to, tokenId, 1);
1219 
1220         // Clear approvals from the previous owner.
1221         assembly {
1222             if approvedAddress {
1223                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1224                 sstore(approvedAddressSlot, 0)
1225             }
1226         }
1227 
1228         // Underflow of the sender's balance is impossible because we check for
1229         // ownership above and the recipient's balance can't realistically overflow.
1230         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1231         unchecked {
1232             // We can directly increment and decrement the balances.
1233             --_packedAddressData[from]; // Updates: `balance -= 1`.
1234             ++_packedAddressData[to]; // Updates: `balance += 1`.
1235 
1236             // Updates:
1237             // - `address` to the next owner.
1238             // - `startTimestamp` to the timestamp of transfering.
1239             // - `burned` to `false`.
1240             // - `nextInitialized` to `true`.
1241             _packedOwnerships[tokenId] = _packOwnershipData(
1242                 to,
1243                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1244             );
1245 
1246             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1247             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1248                 uint256 nextTokenId = tokenId + 1;
1249                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1250                 if (_packedOwnerships[nextTokenId] == 0) {
1251                     // If the next slot is within bounds.
1252                     if (nextTokenId != _currentIndex) {
1253                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1254                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1255                     }
1256                 }
1257             }
1258         }
1259 
1260         emit Transfer(from, to, tokenId);
1261         _afterTokenTransfers(from, to, tokenId, 1);
1262     }
1263 
1264     /**
1265      * @dev Equivalent to `_burn(tokenId, false)`.
1266      */
1267     function _burn(uint256 tokenId) internal virtual {
1268         _burn(tokenId, false);
1269     }
1270 
1271     /**
1272      * @dev Destroys `tokenId`.
1273      * The approval is cleared when the token is burned.
1274      *
1275      * Requirements:
1276      *
1277      * - `tokenId` must exist.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1282         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1283 
1284         address from = address(uint160(prevOwnershipPacked));
1285 
1286         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1287 
1288         if (approvalCheck) {
1289             // The nested ifs save around 20+ gas over a compound boolean condition.
1290             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1291                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1292         }
1293 
1294         _beforeTokenTransfers(from, address(0), tokenId, 1);
1295 
1296         // Clear approvals from the previous owner.
1297         assembly {
1298             if approvedAddress {
1299                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1300                 sstore(approvedAddressSlot, 0)
1301             }
1302         }
1303 
1304         // Underflow of the sender's balance is impossible because we check for
1305         // ownership above and the recipient's balance can't realistically overflow.
1306         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1307         unchecked {
1308             // Updates:
1309             // - `balance -= 1`.
1310             // - `numberBurned += 1`.
1311             //
1312             // We can directly decrement the balance, and increment the number burned.
1313             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1314             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1315 
1316             // Updates:
1317             // - `address` to the last owner.
1318             // - `startTimestamp` to the timestamp of burning.
1319             // - `burned` to `true`.
1320             // - `nextInitialized` to `true`.
1321             _packedOwnerships[tokenId] = _packOwnershipData(
1322                 from,
1323                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1324             );
1325 
1326             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1327             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1328                 uint256 nextTokenId = tokenId + 1;
1329                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1330                 if (_packedOwnerships[nextTokenId] == 0) {
1331                     // If the next slot is within bounds.
1332                     if (nextTokenId != _currentIndex) {
1333                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1334                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1335                     }
1336                 }
1337             }
1338         }
1339 
1340         emit Transfer(from, address(0), tokenId);
1341         _afterTokenTransfers(from, address(0), tokenId, 1);
1342 
1343         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1344         unchecked {
1345             _burnCounter++;
1346         }
1347     }
1348 
1349     /**
1350      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1351      *
1352      * @param from address representing the previous owner of the given token ID
1353      * @param to target address that will receive the tokens
1354      * @param tokenId uint256 ID of the token to be transferred
1355      * @param _data bytes optional data to send along with the call
1356      * @return bool whether the call correctly returned the expected magic value
1357      */
1358     function _checkContractOnERC721Received(
1359         address from,
1360         address to,
1361         uint256 tokenId,
1362         bytes memory _data
1363     ) private returns (bool) {
1364         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1365             bytes4 retval
1366         ) {
1367             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1368         } catch (bytes memory reason) {
1369             if (reason.length == 0) {
1370                 revert TransferToNonERC721ReceiverImplementer();
1371             } else {
1372                 assembly {
1373                     revert(add(32, reason), mload(reason))
1374                 }
1375             }
1376         }
1377     }
1378 
1379     /**
1380      * @dev Directly sets the extra data for the ownership data `index`.
1381      */
1382     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1383         uint256 packed = _packedOwnerships[index];
1384         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1385         uint256 extraDataCasted;
1386         // Cast `extraData` with assembly to avoid redundant masking.
1387         assembly {
1388             extraDataCasted := extraData
1389         }
1390         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1391         _packedOwnerships[index] = packed;
1392     }
1393 
1394     /**
1395      * @dev Returns the next extra data for the packed ownership data.
1396      * The returned result is shifted into position.
1397      */
1398     function _nextExtraData(
1399         address from,
1400         address to,
1401         uint256 prevOwnershipPacked
1402     ) private view returns (uint256) {
1403         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1404         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1405     }
1406 
1407     /**
1408      * @dev Called during each token transfer to set the 24bit `extraData` field.
1409      * Intended to be overridden by the cosumer contract.
1410      *
1411      * `previousExtraData` - the value of `extraData` before transfer.
1412      *
1413      * Calling conditions:
1414      *
1415      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1416      * transferred to `to`.
1417      * - When `from` is zero, `tokenId` will be minted for `to`.
1418      * - When `to` is zero, `tokenId` will be burned by `from`.
1419      * - `from` and `to` are never both zero.
1420      */
1421     function _extraData(
1422         address from,
1423         address to,
1424         uint24 previousExtraData
1425     ) internal view virtual returns (uint24) {}
1426 
1427     /**
1428      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1429      * This includes minting.
1430      * And also called before burning one token.
1431      *
1432      * startTokenId - the first token id to be transferred
1433      * quantity - the amount to be transferred
1434      *
1435      * Calling conditions:
1436      *
1437      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1438      * transferred to `to`.
1439      * - When `from` is zero, `tokenId` will be minted for `to`.
1440      * - When `to` is zero, `tokenId` will be burned by `from`.
1441      * - `from` and `to` are never both zero.
1442      */
1443     function _beforeTokenTransfers(
1444         address from,
1445         address to,
1446         uint256 startTokenId,
1447         uint256 quantity
1448     ) internal virtual {}
1449 
1450     /**
1451      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1452      * This includes minting.
1453      * And also called after one token has been burned.
1454      *
1455      * startTokenId - the first token id to be transferred
1456      * quantity - the amount to be transferred
1457      *
1458      * Calling conditions:
1459      *
1460      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1461      * transferred to `to`.
1462      * - When `from` is zero, `tokenId` has been minted for `to`.
1463      * - When `to` is zero, `tokenId` has been burned by `from`.
1464      * - `from` and `to` are never both zero.
1465      */
1466     function _afterTokenTransfers(
1467         address from,
1468         address to,
1469         uint256 startTokenId,
1470         uint256 quantity
1471     ) internal virtual {}
1472 
1473     /**
1474      * @dev Returns the message sender (defaults to `msg.sender`).
1475      *
1476      * If you are writing GSN compatible contracts, you need to override this function.
1477      */
1478     function _msgSenderERC721A() internal view virtual returns (address) {
1479         return msg.sender;
1480     }
1481 
1482     /**
1483      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1484      */
1485     function _toString(uint256 value) internal pure returns (string memory ptr) {
1486         assembly {
1487             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1488             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1489             // We will need 1 32-byte word to store the length,
1490             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1491             ptr := add(mload(0x40), 128)
1492             // Update the free memory pointer to allocate.
1493             mstore(0x40, ptr)
1494 
1495             // Cache the end of the memory to calculate the length later.
1496             let end := ptr
1497 
1498             // We write the string from the rightmost digit to the leftmost digit.
1499             // The following is essentially a do-while loop that also handles the zero case.
1500             // Costs a bit more than early returning for the zero case,
1501             // but cheaper in terms of deployment and overall runtime costs.
1502             for {
1503                 // Initialize and perform the first pass without check.
1504                 let temp := value
1505                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1506                 ptr := sub(ptr, 1)
1507                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1508                 mstore8(ptr, add(48, mod(temp, 10)))
1509                 temp := div(temp, 10)
1510             } temp {
1511                 // Keep dividing `temp` until zero.
1512                 temp := div(temp, 10)
1513             } {
1514                 // Body of the for loop.
1515                 ptr := sub(ptr, 1)
1516                 mstore8(ptr, add(48, mod(temp, 10)))
1517             }
1518 
1519             let length := sub(end, ptr)
1520             // Move the pointer 32 bytes leftwards to make room for the length.
1521             ptr := sub(ptr, 32)
1522             // Store the length.
1523             mstore(ptr, length)
1524         }
1525     }
1526 }
1527 
1528 // File: contracts/pixelsaurus/AirPixelsaurus.sol
1529 
1530 
1531 pragma solidity ^0.8.7;
1532 
1533 /*
1534 
1535 ██████╗░██╗██╗░░██╗███████╗██╗░░░░░░██████╗░█████╗░██╗░░░██╗██████╗░██╗░░░██╗░██████╗
1536 ██╔══██╗██║╚██╗██╔╝██╔════╝██║░░░░░██╔════╝██╔══██╗██║░░░██║██╔══██╗██║░░░██║██╔════╝
1537 ██████╔╝██║░╚███╔╝░█████╗░░██║░░░░░╚█████╗░███████║██║░░░██║██████╔╝██║░░░██║╚█████╗░
1538 ██╔═══╝░██║░██╔██╗░██╔══╝░░██║░░░░░░╚═══██╗██╔══██║██║░░░██║██╔══██╗██║░░░██║░╚═══██╗
1539 ██║░░░░░██║██╔╝╚██╗███████╗███████╗██████╔╝██║░░██║╚██████╔╝██║░░██║╚██████╔╝██████╔╝
1540 ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚══════╝╚══════╝╚═════╝░╚═╝░░╚═╝░╚═════╝░╚═╝░░╚═╝░╚═════╝░╚═════╝░
1541 
1542 dddddddooooooooooooooooooooooooooolllllllllllllllllllllllllllccccccccccccccccccc
1543 dddddddddddooooooooooooooooooooooooooolllllllllllllllllllllllllllccccccccccccccc
1544 dddddddddddddddoooooooooooooooooooooooooolllllllllllllllllllllllllllcccccccccccc
1545 dddddddddddddddddoooooooooooooooooooooooooooololllllllllllllllllllllllllcccccccc
1546 dddddddddddddddddddddoooooooooooooooooooooooooooolllllllllllllllllllllllllllcccc
1547 ddddddddddddddddddddddddoddooooooooooooooooooooooooolllllllllllllllllllllllllllc
1548 ddddddddddddddddddddddddddoodx0000000000000kooooooooooolllllllllllllllllllllllll
1549 xxxxddddddddddddddddddddddddd0Xd:;;;;;:;;cOK0O00Oddddooooooollllllllllllllllllll
1550 xxxxxxxxdddddddddddddddddddddkKKd,..',,,,,,,,,:dOkkO00kxdoooooolllllllllllllllll
1551 xxxxxxxxxxxdddddddddddddddddddxOKXx;''',;;;,,,,'''.,lxx0XOkxooooolllllllllllllll
1552 xxxxxxxxxxxxxdddddddddddddddddddxOXXdcc,.',;;;;;;;;;'..;ookXKxooooooolllllllllll
1553 xxxxxxxxxxxxxxxxxxddddddk0KKKKK0kdxO0KN0dl,.,;;;;;'..',,..,:kNKxoooooooollllllll
1554 xxxxxxxxxxxxxxxxxxxddxk0X0o;;;cOXKkdddk0XX0l.';;;;..:l:;;;,'':0Xxooooooooooollll
1555 xxxxxxxxxxxxxxxxxxxxk0K0o;''',;;lkKKOxx0XXKo.';;;;. .,;;;;;;..oKKOdooooooooooool
1556 xxxxxxxxxxxxxxxxxxkKX0o;,,''',;::,ckKXXKkd:,;;:::;'...,;;;;;;,';d0Kxoooooooooooo
1557 kkxxxxxxxxxxxxxxkKN0l;,;,;lxdc,,:l:,cdo:'':lcc:,'',::::,',;;,',' lNOoooooooooooo
1558 kkkkkxxxxxxxxxkKN0l:;,,;lxxxxxo..ldo:;;cooooooc..l:':cc' .';;';' lNOoooooooooooo
1559 kkkkkkkkxxxxkKXKo::;,;cdxxxxxxdl;,:odxdddddollc.;KKd;,c, .'';:c, lNOoooooooooooo
1560 kkkkkkkkkkkx0Wd'cc.'cldxxddddddddl,.lxxxxdo:;,,.:kXXl,:,.'lko;;,'dNOoddooooooooo
1561 kkkkkkkkkkkx0Wl.oo.'lldxdoxdcoxdo:,,okkoc:;:xkkkd:lkKOc;,.'d0Koo0X0xddddddoooooo
1562 kkkkkkkkkkkOXWl.ok:,,codooddoddd:.;kOxc,,;okkkOOOO;.kMWkcccckNXK0xdddddddddddooo
1563 kkkkkkkkkkOX0lcc:;;::,,cllloxdl;,:dO0l.,dddxxxkkkk;.xN0000000kxddddddddddddddddd
1564 kkkkkkkkkkONk'.;oxxo:c:',:coxdc.'k000o.'loooddxxxx,.xXkddddddddddddddddddddddddd
1565 kkkkkkkkkkOKX0l;OWNKk:;d;.;loo:.'kK0Ko..cllloooddd,.xXkdxxdxxddddddddddddddddddd
1566 kkkkkkkkkkkkOKKKK0OXK;'k: 'ldo:.'kK0Ko..::cclllooo'.xXkxxxxxxxxddddddddddddddddd
1567 OOOOkkkkkkkkkkkkkkkXK;,k: 'lxo;.'kK0d;.';;::ccclc;;l0Xkxxxxxxxxxxxxxdddddddddddd
1568 OOOOOOkOkkkkkkkkkkkXK;'kc .:cc;.'kKk'.';,,;,....,l0NKkxxxxxxxxxxxxxxxxdddddddddd
1569 OOOOOOOOOOOkkkkkkkOXK;'kc .,,;,.'x0k' .''''. ,c.;KXOxxxxxxxxxxxxxxxxxxxxxxxddddd
1570 OOOOOOOOOOOOOOOOkkOXK;.oc'''''''..ok'.''';xl.:k,;KKkxxxxxxxxxxxxxxxxxxxxxxxxxxdd
1571 OOOOOOOOOOOOOOOOkkOXK,.;xXXOc,cOd.ck',OXXNWx.:k,;KXOkxxxxxxxxxxxxxxxxxxxxxxxxxxx
1572 OOOOOOOOOOOOOOOOOOOKXddXNKKXWWNkl:dOoco0MNkl:xOoco0NKOkxxxxxxxxxxxxxxxxxxxxxxxxx
1573 OOOOOOOOOOOOOOOOOOOOKKKKOkk0NO:..,:;:' oMK;.,;;:' .l0XOxkkxxxxxxxxxxxxxxxxxxxxxx
1574 OOOOOOOOOOOOOOOOOOOOOOOOOOkKWo.ll.:d''dKWN0c.:d''d:'kNOkkkkkkxxxxxxxxxxxxxxxxxxx
1575 OOOOOOOOOOOOOOOOOOOOOOOOOOO0XKOXXOKX00XKO0KKOKN00XKOKKkkkkkkkkkkkkxxxxxxxxxxxxxx
1576 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkOOOOOOOOOOOkkkkkkkkkkkkkkkxxxxxxxxxxxx
1577 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxxxxxxxx
1578 0OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxxxxx
1579 0000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkx
1580 00000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
1581 0000000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
1582 */
1583 
1584 
1585 
1586 
1587 
1588 contract PixelSaurusAir is ERC721A, Ownable {
1589     using StringsUpgradeable for uint256;
1590     event Minted(address indexed _from, uint _amount, uint _value);
1591 
1592     address extendingContract;
1593 
1594 
1595     string public baseApiURI;
1596     
1597      //Utility
1598     bool public paused = true;
1599     bool public whiteListingSale = true;
1600 
1601     //General Settings
1602     uint16 public maxMintAmountPerTransaction = 10;
1603     uint16 public maxMintAmountPerWallet = 500;
1604 
1605     //whitelisting Settings
1606     uint16 public maxMintAmountPerWhitelist1 = 500;
1607     uint16 public maxMintAmountPerWhitelist2 = 500;
1608    
1609 
1610     //Inventory
1611     uint256 public maxSupply = 1100;
1612 
1613     //Prices
1614     uint256 public cost = 0.09 ether;
1615     //greenlist 1 cost
1616     uint256 public whitelistCost1 = 0.08 ether;
1617     //greenlist 2 cost 
1618     uint256 public whitelistCost2 = 0.08 ether;
1619 
1620     //Merkle Tree Roots
1621     bytes32 private whitelistRoot1;
1622     bytes32 private whitelistRoot2;
1623 
1624     //mapping
1625     mapping(address => uint256) private whitelistedMints;
1626 
1627     
1628 
1629     constructor(string memory _baseUrl) ERC721A("PixelSaurus Air", "PXLSAIR") {
1630         baseApiURI = _baseUrl;
1631     }
1632 
1633     //This function will be used to extend the project with more capabilities 
1634     function setExternalContract(address _bAddress) public onlyOwner {
1635         extendingContract = _bAddress;
1636     }
1637 
1638 
1639     //this function can be called only from the extending contract
1640     function mintExternal(address _address, uint256 _mintAmount) external {
1641         require(
1642             msg.sender == extendingContract,
1643             "Sorry you don't have permission to mint"
1644         );
1645         _safeMint(_address, _mintAmount);
1646     }
1647 
1648     function setWhitelistingRoot(bool iswWhitelist1, bytes32 _root) public onlyOwner {
1649        if(iswWhitelist1){
1650             whitelistRoot1 = _root;
1651        }else{
1652             whitelistRoot2 = _root;
1653        }
1654     }
1655 
1656    
1657 
1658  
1659     // Verify that a given leaf is in the tree.
1660     function _verify(
1661         bool isWhitelist1,
1662         bytes32 _leafNode,
1663         bytes32[] memory proof
1664     ) internal view returns (bool) {
1665        if(isWhitelist1){
1666             return MerkleProof.verify(proof, whitelistRoot1, _leafNode);
1667        }else{
1668             return MerkleProof.verify(proof, whitelistRoot2, _leafNode);
1669        }
1670     }
1671 
1672     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1673     function _leaf(address account) internal pure returns (bytes32) {
1674         return keccak256(abi.encodePacked(account));
1675     }
1676 
1677     //whitelist mint
1678     function mintWhitelist(
1679         bool isWhitelist1,
1680         bytes32[] calldata proof,
1681         uint256 _mintAmount
1682     ) public payable {
1683      
1684      
1685                 // WL Verifications
1686                 //1 
1687                  if(isWhitelist1){
1688                      require(
1689                     _verify(true,_leaf(msg.sender), proof),
1690                     "Invalid proof"
1691                 );
1692                
1693                require(
1694                 _mintAmount <= maxMintAmountPerTransaction,
1695                 "Sorry you cannot mint this many at once!"
1696             );
1697 
1698                 require(
1699                     (whitelistedMints[msg.sender] + _mintAmount) <=
1700                         maxMintAmountPerWhitelist1,
1701                     "Exceeds Max Mint amount"
1702                 );
1703 
1704                 require(
1705                     msg.value >= (whitelistCost1 * _mintAmount),
1706                     "Insuffient funds"
1707                 );
1708                  }else{
1709                      require(
1710                     _verify(false, _leaf(msg.sender), proof),
1711                     "Invalid proof"
1712                 );
1713                 require(
1714                     msg.value >= (whitelistCost2 * _mintAmount),
1715                     "Insuffient funds"
1716                 );
1717 
1718                  require(
1719                     (whitelistedMints[msg.sender] + _mintAmount) <=
1720                         maxMintAmountPerWhitelist2,
1721                     "Exceeds Max Mint amount"
1722                 );
1723                  }
1724 
1725                 
1726 
1727                 //END WL Verifications
1728 
1729                 //Mint
1730                 _mintLoop(msg.sender, _mintAmount);
1731                   whitelistedMints[msg.sender] =
1732                     whitelistedMints[msg.sender] +
1733                     _mintAmount;
1734 
1735                 emit Minted(msg.sender,  _mintAmount, msg.value);
1736              
1737     }
1738 
1739     function numberMinted(address owner) public view returns (uint256) {
1740         return _numberMinted(owner);
1741     }
1742 
1743     // public
1744     function mint(uint256 _mintAmount) public payable {
1745         if (msg.sender != owner()) {
1746             uint256 ownerTokenCount = balanceOf(msg.sender);
1747 
1748             require(!paused);
1749             require(!whiteListingSale, "You cant mint on Presale");
1750             require(_mintAmount > 0, "Mint amount should be greater than 0");
1751             require(
1752                 _mintAmount <= maxMintAmountPerTransaction,
1753                 "Sorry you cant mint this amount at once"
1754             );
1755             require(
1756                 totalSupply() + _mintAmount <= maxSupply,
1757                 "Exceeds Max Supply"
1758             );
1759             require(
1760                 (ownerTokenCount + _mintAmount) <= maxMintAmountPerWallet,
1761                 "Sorry you cant mint more"
1762             );
1763 
1764             require(msg.value >= cost * _mintAmount, "Insuffient funds");
1765         }
1766 
1767         _mintLoop(msg.sender, _mintAmount);
1768          emit Minted(msg.sender,  _mintAmount, msg.value);
1769     }
1770 
1771     function gift(address _to, uint256 _mintAmount) public onlyOwner {
1772         _mintLoop(_to, _mintAmount);
1773     }
1774 
1775     function airdrop(address[] memory _airdropAddresses) public onlyOwner {
1776         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1777             address to = _airdropAddresses[i];
1778             _mintLoop(to, 1);
1779         }
1780     }
1781 
1782     function _baseURI() internal view virtual override returns (string memory) {
1783         return baseApiURI;
1784     }
1785 
1786     function tokenURI(uint256 tokenId)
1787         public
1788         view
1789         virtual
1790         override
1791         returns (string memory)
1792     {
1793         require(
1794             _exists(tokenId),
1795             "ERC721Metadata: URI query for nonexistent token"
1796         );
1797         string memory currentBaseURI = _baseURI();
1798         return
1799             bytes(currentBaseURI).length > 0
1800                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1801                 : "";
1802     }
1803 
1804     function setCost( uint256 _newCost) public onlyOwner {
1805         cost = _newCost;
1806     }
1807 
1808     function setWhitelistingCost(bool isWhitelist1, uint256 _newCost) public onlyOwner {
1809        if(isWhitelist1){
1810             whitelistCost1 = _newCost;
1811        }else{
1812             whitelistCost2 = _newCost;
1813        }
1814     }
1815 
1816     function setmaxMintAmountPerTransaction(uint16 _amount) public onlyOwner {
1817         maxMintAmountPerTransaction = _amount;
1818     }
1819 
1820     function setMaxMintAmountPerWallet(uint16 _amount) public onlyOwner {
1821         maxMintAmountPerWallet = _amount;
1822     }
1823 
1824     function setMaxMintAmountPerWhitelist(bool isWhitelist1, uint16 _amount) public onlyOwner {
1825        if(isWhitelist1){
1826             maxMintAmountPerWhitelist1 = _amount;
1827        }else{
1828             maxMintAmountPerWhitelist2 = _amount;
1829        }
1830     }
1831 
1832     function setMaxSupply(uint256 _supply) public onlyOwner {
1833         maxSupply = _supply;
1834     }
1835 
1836     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1837         baseApiURI = _newBaseURI;
1838     }
1839 
1840     function togglePause() public onlyOwner {
1841         paused = !paused;
1842     }
1843 
1844     function toggleWhiteSale() public onlyOwner {
1845         whiteListingSale = !whiteListingSale;
1846     }
1847 
1848     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1849         _safeMint(_receiver, _mintAmount);
1850     }
1851 
1852    
1853 
1854     function withdraw() public payable onlyOwner {
1855         (bool hq, ) = payable(owner()).call{value: address(this).balance}("");
1856         require(hq);
1857 
1858     }
1859 }