1 // SPDX-License-Identifier: AGPL-3.0-only
2 pragma solidity >=0.8.4;
3 
4 /// @notice Minimalist and gas efficient standard ERC1155 implementation.
5 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC1155.sol)
6 abstract contract ERC1155 {
7     /*///////////////////////////////////////////////////////////////
8                                 EVENTS
9     //////////////////////////////////////////////////////////////*/
10 
11     event TransferSingle(
12         address indexed operator,
13         address indexed from,
14         address indexed to,
15         uint256 id,
16         uint256 amount
17     );
18 
19     event TransferBatch(
20         address indexed operator,
21         address indexed from,
22         address indexed to,
23         uint256[] ids,
24         uint256[] amounts
25     );
26 
27     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
28 
29     event URI(string value, uint256 indexed id);
30 
31     /*///////////////////////////////////////////////////////////////
32                             ERC1155 STORAGE
33     //////////////////////////////////////////////////////////////*/
34 
35     mapping(address => mapping(uint256 => uint256)) public balanceOf;
36 
37     mapping(address => mapping(address => bool)) public isApprovedForAll;
38 
39     /*///////////////////////////////////////////////////////////////
40                              METADATA LOGIC
41     //////////////////////////////////////////////////////////////*/
42 
43     function uri(uint256 id) public view virtual returns (string memory);
44 
45     /*///////////////////////////////////////////////////////////////
46                             ERC1155 ACTIONS
47     //////////////////////////////////////////////////////////////*/
48 
49     function setApprovalForAll(address operator, bool approved) public virtual {
50         isApprovedForAll[msg.sender][operator] = approved;
51 
52         emit ApprovalForAll(msg.sender, operator, approved);
53     }
54 
55     function safeTransferFrom(
56         address from,
57         address to,
58         uint256 id,
59         uint256 amount,
60         bytes memory data
61     ) public virtual {
62         require(msg.sender == from || isApprovedForAll[from][msg.sender], "NOT_AUTHORIZED");
63 
64         balanceOf[from][id] -= amount;
65         balanceOf[to][id] += amount;
66 
67         emit TransferSingle(msg.sender, from, to, id, amount);
68 
69         require(
70             to.code.length == 0
71                 ? to != address(0)
72                 : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, from, id, amount, data) ==
73                     ERC1155TokenReceiver.onERC1155Received.selector,
74             "UNSAFE_RECIPIENT"
75         );
76     }
77 
78     function safeBatchTransferFrom(
79         address from,
80         address to,
81         uint256[] memory ids,
82         uint256[] memory amounts,
83         bytes memory data
84     ) public virtual {
85         uint256 idsLength = ids.length; // Saves MLOADs.
86 
87         require(idsLength == amounts.length, "LENGTH_MISMATCH");
88 
89         require(msg.sender == from || isApprovedForAll[from][msg.sender], "NOT_AUTHORIZED");
90 
91         for (uint256 i = 0; i < idsLength; ) {
92             uint256 id = ids[i];
93             uint256 amount = amounts[i];
94 
95             balanceOf[from][id] -= amount;
96             balanceOf[to][id] += amount;
97 
98             // An array can't have a total length
99             // larger than the max uint256 value.
100             unchecked {
101                 i++;
102             }
103         }
104 
105         emit TransferBatch(msg.sender, from, to, ids, amounts);
106 
107         require(
108             to.code.length == 0
109                 ? to != address(0)
110                 : ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, from, ids, amounts, data) ==
111                     ERC1155TokenReceiver.onERC1155BatchReceived.selector,
112             "UNSAFE_RECIPIENT"
113         );
114     }
115 
116     function balanceOfBatch(address[] memory owners, uint256[] memory ids)
117         public
118         view
119         virtual
120         returns (uint256[] memory balances)
121     {
122         uint256 ownersLength = owners.length; // Saves MLOADs.
123 
124         require(ownersLength == ids.length, "LENGTH_MISMATCH");
125 
126         balances = new uint256[](owners.length);
127 
128         // Unchecked because the only math done is incrementing
129         // the array index counter which cannot possibly overflow.
130         unchecked {
131             for (uint256 i = 0; i < ownersLength; i++) {
132                 balances[i] = balanceOf[owners[i]][ids[i]];
133             }
134         }
135     }
136 
137     /*///////////////////////////////////////////////////////////////
138                               ERC165 LOGIC
139     //////////////////////////////////////////////////////////////*/
140 
141     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
142         return
143             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
144             interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
145             interfaceId == 0x0e89341c; // ERC165 Interface ID for ERC1155MetadataURI
146     }
147 
148     /*///////////////////////////////////////////////////////////////
149                        INTERNAL MINT/BURN LOGIC
150     //////////////////////////////////////////////////////////////*/
151 
152     function _mint(
153         address to,
154         uint256 id,
155         uint256 amount,
156         bytes memory data
157     ) internal {
158         balanceOf[to][id] += amount;
159 
160         emit TransferSingle(msg.sender, address(0), to, id, amount);
161 
162         require(
163             to.code.length == 0
164                 ? to != address(0)
165                 : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, address(0), id, amount, data) ==
166                     ERC1155TokenReceiver.onERC1155Received.selector,
167             "UNSAFE_RECIPIENT"
168         );
169     }
170 
171     function _batchMint(
172         address to,
173         uint256[] memory ids,
174         uint256[] memory amounts,
175         bytes memory data
176     ) internal {
177         uint256 idsLength = ids.length; // Saves MLOADs.
178 
179         require(idsLength == amounts.length, "LENGTH_MISMATCH");
180 
181         for (uint256 i = 0; i < idsLength; ) {
182             balanceOf[to][ids[i]] += amounts[i];
183 
184             // An array can't have a total length
185             // larger than the max uint256 value.
186             unchecked {
187                 i++;
188             }
189         }
190 
191         emit TransferBatch(msg.sender, address(0), to, ids, amounts);
192 
193         require(
194             to.code.length == 0
195                 ? to != address(0)
196                 : ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, address(0), ids, amounts, data) ==
197                     ERC1155TokenReceiver.onERC1155BatchReceived.selector,
198             "UNSAFE_RECIPIENT"
199         );
200     }
201 
202     function _batchBurn(
203         address from,
204         uint256[] memory ids,
205         uint256[] memory amounts
206     ) internal {
207         uint256 idsLength = ids.length; // Saves MLOADs.
208 
209         require(idsLength == amounts.length, "LENGTH_MISMATCH");
210 
211         for (uint256 i = 0; i < idsLength; ) {
212             balanceOf[from][ids[i]] -= amounts[i];
213 
214             // An array can't have a total length
215             // larger than the max uint256 value.
216             unchecked {
217                 i++;
218             }
219         }
220 
221         emit TransferBatch(msg.sender, from, address(0), ids, amounts);
222     }
223 
224     function _burn(
225         address from,
226         uint256 id,
227         uint256 amount
228     ) internal {
229         balanceOf[from][id] -= amount;
230 
231         emit TransferSingle(msg.sender, from, address(0), id, amount);
232     }
233 }
234 
235 /// @notice A generic interface for a contract which properly accepts ERC1155 tokens.
236 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC1155.sol)
237 interface ERC1155TokenReceiver {
238     function onERC1155Received(
239         address operator,
240         address from,
241         uint256 id,
242         uint256 amount,
243         bytes calldata data
244     ) external returns (bytes4);
245 
246     function onERC1155BatchReceived(
247         address operator,
248         address from,
249         uint256[] calldata ids,
250         uint256[] calldata amounts,
251         bytes calldata data
252     ) external returns (bytes4);
253 }// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
254 
255 
256 
257 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
258 
259 
260 
261 /**
262  * @dev Provides information about the current execution context, including the
263  * sender of the transaction and its data. While these are generally available
264  * via msg.sender and msg.data, they should not be accessed in such a direct
265  * manner, since when dealing with meta-transactions the account sending and
266  * paying for execution may not be the actual sender (as far as an application
267  * is concerned).
268  *
269  * This contract is only required for intermediate, library-like contracts.
270  */
271 abstract contract Context {
272     function _msgSender() internal view virtual returns (address) {
273         return msg.sender;
274     }
275 
276     function _msgData() internal view virtual returns (bytes calldata) {
277         return msg.data;
278     }
279 }
280 
281 /**
282  * @dev Contract module which provides a basic access control mechanism, where
283  * there is an account (an owner) that can be granted exclusive access to
284  * specific functions.
285  *
286  * By default, the owner account will be the one that deploys the contract. This
287  * can later be changed with {transferOwnership}.
288  *
289  * This module is used through inheritance. It will make available the modifier
290  * `onlyOwner`, which can be applied to your functions to restrict their use to
291  * the owner.
292  */
293 abstract contract Ownable is Context {
294     address private _owner;
295 
296     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
297 
298     /**
299      * @dev Initializes the contract setting the deployer as the initial owner.
300      */
301     constructor() {
302         _transferOwnership(_msgSender());
303     }
304 
305     /**
306      * @dev Returns the address of the current owner.
307      */
308     function owner() public view virtual returns (address) {
309         return _owner;
310     }
311 
312     /**
313      * @dev Throws if called by any account other than the owner.
314      */
315     modifier onlyOwner() {
316         require(owner() == _msgSender(), "Ownable: caller is not the owner");
317         _;
318     }
319 
320     /**
321      * @dev Leaves the contract without owner. It will not be possible to call
322      * `onlyOwner` functions anymore. Can only be called by the current owner.
323      *
324      * NOTE: Renouncing ownership will leave the contract without an owner,
325      * thereby removing any functionality that is only available to the owner.
326      */
327     function renounceOwnership() public virtual onlyOwner {
328         _transferOwnership(address(0));
329     }
330 
331     /**
332      * @dev Transfers ownership of the contract to a new account (`newOwner`).
333      * Can only be called by the current owner.
334      */
335     function transferOwnership(address newOwner) public virtual onlyOwner {
336         require(newOwner != address(0), "Ownable: new owner is the zero address");
337         _transferOwnership(newOwner);
338     }
339 
340     /**
341      * @dev Transfers ownership of the contract to a new account (`newOwner`).
342      * Internal function without access restriction.
343      */
344     function _transferOwnership(address newOwner) internal virtual {
345         address oldOwner = _owner;
346         _owner = newOwner;
347         emit OwnershipTransferred(oldOwner, newOwner);
348     }
349 }// OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
350 
351 
352 
353 /**
354  * @dev These functions deal with verification of Merkle Trees proofs.
355  *
356  * The proofs can be generated using the JavaScript library
357  * https://github.com/miguelmota/merkletreejs[merkletreejs].
358  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
359  *
360  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
361  */
362 library MerkleProof {
363     /**
364      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
365      * defined by `root`. For this, a `proof` must be provided, containing
366      * sibling hashes on the branch from the leaf to the root of the tree. Each
367      * pair of leaves and each pair of pre-images are assumed to be sorted.
368      */
369     function verify(
370         bytes32[] memory proof,
371         bytes32 root,
372         bytes32 leaf
373     ) internal pure returns (bool) {
374         return processProof(proof, leaf) == root;
375     }
376 
377     /**
378      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
379      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
380      * hash matches the root of the tree. When processing the proof, the pairs
381      * of leafs & pre-images are assumed to be sorted.
382      *
383      * _Available since v4.4._
384      */
385     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
386         bytes32 computedHash = leaf;
387         for (uint256 i = 0; i < proof.length; i++) {
388             bytes32 proofElement = proof[i];
389             if (computedHash <= proofElement) {
390                 // Hash(current computed hash + current element of the proof)
391                 computedHash = _efficientHash(computedHash, proofElement);
392             } else {
393                 // Hash(current element of the proof + current computed hash)
394                 computedHash = _efficientHash(proofElement, computedHash);
395             }
396         }
397         return computedHash;
398     }
399 
400     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
401         assembly {
402             mstore(0x00, a)
403             mstore(0x20, b)
404             value := keccak256(0x00, 0x40)
405         }
406     }
407 }// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
408 
409 
410 
411 /**
412  * @dev String operations.
413  */
414 library Strings {
415     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
416 
417     /**
418      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
419      */
420     function toString(uint256 value) internal pure returns (string memory) {
421         // Inspired by OraclizeAPI's implementation - MIT licence
422         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
423 
424         if (value == 0) {
425             return "0";
426         }
427         uint256 temp = value;
428         uint256 digits;
429         while (temp != 0) {
430             digits++;
431             temp /= 10;
432         }
433         bytes memory buffer = new bytes(digits);
434         while (value != 0) {
435             digits -= 1;
436             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
437             value /= 10;
438         }
439         return string(buffer);
440     }
441 
442     /**
443      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
444      */
445     function toHexString(uint256 value) internal pure returns (string memory) {
446         if (value == 0) {
447             return "0x00";
448         }
449         uint256 temp = value;
450         uint256 length = 0;
451         while (temp != 0) {
452             length++;
453             temp >>= 8;
454         }
455         return toHexString(value, length);
456     }
457 
458     /**
459      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
460      */
461     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
462         bytes memory buffer = new bytes(2 * length + 2);
463         buffer[0] = "0";
464         buffer[1] = "x";
465         for (uint256 i = 2 * length + 1; i > 1; --i) {
466             buffer[i] = _HEX_SYMBOLS[value & 0xf];
467             value >>= 4;
468         }
469         require(value == 0, "Strings: hex length insufficient");
470         return string(buffer);
471     }
472 }
473 contract TitanTiki3D is ERC1155, Ownable {
474     using Strings for uint160;
475     using Strings for uint8;
476 
477     /// @dev 0x98d4901c
478     error WrongValue();
479     /// @dev 0x750b219c
480     error WithdrawFailed();
481     /// @dev 0x80cb55e2
482     error NotActive();
483     /// @dev 0xb36c1284
484     error MaxSupply();
485     /// @dev 0xb05e92fa
486     error InvalidMerkleProof();
487     /// @dev 0x843ce46b
488     error InvalidClaimAmount();
489     /// @dev 0x2c5211c6
490     error InvalidAmount();
491 
492     // Immutable
493 
494     uint256 public constant TOTAL_LIMIT = 2022;
495     uint256 public constant UNIT_PRICE = 0.1 ether;
496     uint256 public constant MAX_PER_TX = 10;
497 
498     bytes32 public immutable merkleRoot;
499     address private immutable _payoutAddress;
500 
501     // Mutable
502 
503     uint256 public totalSupply = 0;
504     bool public isPresaleActive = false;
505     string private _uri;
506     bool public isSaleActive = false;
507 
508     /// @dev we know no one is allow-listed to claim more than 255, and we
509     ///      found out uint8 was cheaper than other uints by trial
510     mapping(address => uint8) public amountClaimedByUser;
511 
512     // Constructor
513 
514     constructor(
515         address payoutAddress,
516         string memory __uri,
517         bytes32 _merkleRoot
518     ) {
519         // slither-disable-next-line missing-zero-check
520         _payoutAddress = payoutAddress;
521         _uri = __uri;
522         merkleRoot = _merkleRoot;
523     }
524 
525     // Owner Only
526 
527     function setURI(string calldata newUri) external onlyOwner {
528         _uri = newUri;
529     }
530 
531     function setIsSaleActive(bool newIsSaleActive) external onlyOwner {
532         isSaleActive = newIsSaleActive;
533     }
534 
535     function setIsPresaleActive(bool newIsPresaleActive) external onlyOwner {
536         isPresaleActive = newIsPresaleActive;
537     }
538 
539     function withdraw() external onlyOwner {
540         uint256 contractBalance = address(this).balance;
541         // slither-disable-next-line low-level-calls
542         (bool payoutSent, ) = payable(_payoutAddress).call{ // solhint-disable-line avoid-low-level-calls
543             value: contractBalance
544         }("");
545         if (!payoutSent) revert WithdrawFailed();
546     }
547 
548     function reserve(address to, uint256 amount) external onlyOwner {
549         unchecked {
550             if (amount + totalSupply > TOTAL_LIMIT) revert MaxSupply();
551         }
552         _mintMany(to, amount);
553     }
554 
555     // User
556 
557     function mint(uint256 amount) external payable {
558         if (!isSaleActive) revert NotActive();
559         if (amount == 0 || amount > MAX_PER_TX) revert InvalidAmount();
560         unchecked {
561             if (msg.value != amount * UNIT_PRICE) revert WrongValue();
562             if (amount + totalSupply > TOTAL_LIMIT) revert MaxSupply();
563         }
564         _mintMany(msg.sender, amount);
565     }
566 
567     function claim(
568         uint8 amount,
569         uint8 totalAmount,
570         bytes32[] calldata proof
571     ) external {
572         if (!isPresaleActive) revert NotActive();
573         unchecked {
574             if (amountClaimedByUser[msg.sender] + amount > totalAmount)
575                 revert InvalidClaimAmount();
576         }
577         bytes32 leaf = keccak256(
578             abi.encodePacked(
579                 uint160(msg.sender).toHexString(20),
580                 ":",
581                 totalAmount.toString()
582             )
583         );
584         bool isProofValid = MerkleProof.verify(proof, merkleRoot, leaf);
585         if (!isProofValid) revert InvalidMerkleProof();
586         unchecked {
587             amountClaimedByUser[msg.sender] += amount;
588         }
589         _mintMany(msg.sender, amount);
590     }
591 
592     // Internal Helpers
593 
594     function _mintMany(address to, uint256 amount) internal {
595         uint256[] memory ids = new uint256[](amount);
596         uint256[] memory amounts = new uint256[](amount);
597 
598         uint256 supply = totalSupply;
599         unchecked {
600             totalSupply += amount;
601             for (uint256 i = 0; i < amount; i++) {
602                 ids[i] = supply + i + 1;
603                 amounts[i] = 1;
604             }
605         }
606 
607         _batchMint(to, ids, amounts, "");
608     }
609 
610     // Overrides
611 
612     function uri(uint256) public view override returns (string memory) {
613         return _uri;
614     }
615 }
