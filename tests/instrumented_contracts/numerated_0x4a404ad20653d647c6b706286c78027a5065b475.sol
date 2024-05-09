1 // File: contracts/ChainPhallusErrors.sol
2 
3 
4 
5 
6 pragma solidity 0.8.7;
7 
8 // Sale
9 error SaleNotOpen();
10 error NotPreSaleStage();
11 error NotMainSaleStage();
12 error SaleNotComplete();
13 error MainSaleNotComplete();
14 error AlreadyClaimed();
15 error InvalidClaimValue();
16 error InvalidClaimAmount();
17 error InvalidProof();
18 error InvalidMintValue();
19 
20 // NFT
21 error NonExistentToken();
22 
23 // Reveal
24 error InvalidReveal();
25 error BalanceNotWithdrawn();
26 error BalanceAlreadyWithdrawn();
27 
28 // Arena
29 error LeavingProhibited();
30 error ArenaIsActive();
31 error ArenaNotActive();
32 error ArenaEntryClosed();
33 error WienersNotFluffy();
34 error WienersAreFluffy();
35 error LastErectWiener();
36 error GameOver();
37 error InvalidJoinCount();
38 error NotYourWiener();
39 // File: @openzeppelin/contracts@4.7.3/utils/cryptography/MerkleProof.sol
40 
41 
42 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev These functions deal with verification of Merkle Tree proofs.
48  *
49  * The proofs can be generated using the JavaScript library
50  * https://github.com/miguelmota/merkletreejs[merkletreejs].
51  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
52  *
53  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
54  *
55  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
56  * hashing, or use a hash function other than keccak256 for hashing leaves.
57  * This is because the concatenation of a sorted pair of internal nodes in
58  * the merkle tree could be reinterpreted as a leaf value.
59  */
60 library MerkleProof {
61     /**
62      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
63      * defined by `root`. For this, a `proof` must be provided, containing
64      * sibling hashes on the branch from the leaf to the root of the tree. Each
65      * pair of leaves and each pair of pre-images are assumed to be sorted.
66      */
67     function verify(
68         bytes32[] memory proof,
69         bytes32 root,
70         bytes32 leaf
71     ) internal pure returns (bool) {
72         return processProof(proof, leaf) == root;
73     }
74 
75     /**
76      * @dev Calldata version of {verify}
77      *
78      * _Available since v4.7._
79      */
80     function verifyCalldata(
81         bytes32[] calldata proof,
82         bytes32 root,
83         bytes32 leaf
84     ) internal pure returns (bool) {
85         return processProofCalldata(proof, leaf) == root;
86     }
87 
88     /**
89      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
90      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
91      * hash matches the root of the tree. When processing the proof, the pairs
92      * of leafs & pre-images are assumed to be sorted.
93      *
94      * _Available since v4.4._
95      */
96     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
97         bytes32 computedHash = leaf;
98         for (uint256 i = 0; i < proof.length; i++) {
99             computedHash = _hashPair(computedHash, proof[i]);
100         }
101         return computedHash;
102     }
103 
104     /**
105      * @dev Calldata version of {processProof}
106      *
107      * _Available since v4.7._
108      */
109     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
110         bytes32 computedHash = leaf;
111         for (uint256 i = 0; i < proof.length; i++) {
112             computedHash = _hashPair(computedHash, proof[i]);
113         }
114         return computedHash;
115     }
116 
117     /**
118      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
119      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
120      *
121      * _Available since v4.7._
122      */
123     function multiProofVerify(
124         bytes32[] memory proof,
125         bool[] memory proofFlags,
126         bytes32 root,
127         bytes32[] memory leaves
128     ) internal pure returns (bool) {
129         return processMultiProof(proof, proofFlags, leaves) == root;
130     }
131 
132     /**
133      * @dev Calldata version of {multiProofVerify}
134      *
135      * _Available since v4.7._
136      */
137     function multiProofVerifyCalldata(
138         bytes32[] calldata proof,
139         bool[] calldata proofFlags,
140         bytes32 root,
141         bytes32[] memory leaves
142     ) internal pure returns (bool) {
143         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
144     }
145 
146     /**
147      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
148      * consuming from one or the other at each step according to the instructions given by
149      * `proofFlags`.
150      *
151      * _Available since v4.7._
152      */
153     function processMultiProof(
154         bytes32[] memory proof,
155         bool[] memory proofFlags,
156         bytes32[] memory leaves
157     ) internal pure returns (bytes32 merkleRoot) {
158         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
159         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
160         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
161         // the merkle tree.
162         uint256 leavesLen = leaves.length;
163         uint256 totalHashes = proofFlags.length;
164 
165         // Check proof validity.
166         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
167 
168         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
169         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
170         bytes32[] memory hashes = new bytes32[](totalHashes);
171         uint256 leafPos = 0;
172         uint256 hashPos = 0;
173         uint256 proofPos = 0;
174         // At each step, we compute the next hash using two values:
175         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
176         //   get the next hash.
177         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
178         //   `proof` array.
179         for (uint256 i = 0; i < totalHashes; i++) {
180             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
181             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
182             hashes[i] = _hashPair(a, b);
183         }
184 
185         if (totalHashes > 0) {
186             return hashes[totalHashes - 1];
187         } else if (leavesLen > 0) {
188             return leaves[0];
189         } else {
190             return proof[0];
191         }
192     }
193 
194     /**
195      * @dev Calldata version of {processMultiProof}
196      *
197      * _Available since v4.7._
198      */
199     function processMultiProofCalldata(
200         bytes32[] calldata proof,
201         bool[] calldata proofFlags,
202         bytes32[] memory leaves
203     ) internal pure returns (bytes32 merkleRoot) {
204         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
205         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
206         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
207         // the merkle tree.
208         uint256 leavesLen = leaves.length;
209         uint256 totalHashes = proofFlags.length;
210 
211         // Check proof validity.
212         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
213 
214         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
215         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
216         bytes32[] memory hashes = new bytes32[](totalHashes);
217         uint256 leafPos = 0;
218         uint256 hashPos = 0;
219         uint256 proofPos = 0;
220         // At each step, we compute the next hash using two values:
221         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
222         //   get the next hash.
223         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
224         //   `proof` array.
225         for (uint256 i = 0; i < totalHashes; i++) {
226             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
227             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
228             hashes[i] = _hashPair(a, b);
229         }
230 
231         if (totalHashes > 0) {
232             return hashes[totalHashes - 1];
233         } else if (leavesLen > 0) {
234             return leaves[0];
235         } else {
236             return proof[0];
237         }
238     }
239 
240     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
241         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
242     }
243 
244     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
245         /// @solidity memory-safe-assembly
246         assembly {
247             mstore(0x00, a)
248             mstore(0x20, b)
249             value := keccak256(0x00, 0x40)
250         }
251     }
252 }
253 
254 // File: @openzeppelin/contracts@4.7.3/utils/Strings.sol
255 
256 
257 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev String operations.
263  */
264 library Strings {
265     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
266     uint8 private constant _ADDRESS_LENGTH = 20;
267 
268     /**
269      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
270      */
271     function toString(uint256 value) internal pure returns (string memory) {
272         // Inspired by OraclizeAPI's implementation - MIT licence
273         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
274 
275         if (value == 0) {
276             return "0";
277         }
278         uint256 temp = value;
279         uint256 digits;
280         while (temp != 0) {
281             digits++;
282             temp /= 10;
283         }
284         bytes memory buffer = new bytes(digits);
285         while (value != 0) {
286             digits -= 1;
287             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
288             value /= 10;
289         }
290         return string(buffer);
291     }
292 
293     /**
294      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
295      */
296     function toHexString(uint256 value) internal pure returns (string memory) {
297         if (value == 0) {
298             return "0x00";
299         }
300         uint256 temp = value;
301         uint256 length = 0;
302         while (temp != 0) {
303             length++;
304             temp >>= 8;
305         }
306         return toHexString(value, length);
307     }
308 
309     /**
310      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
311      */
312     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
313         bytes memory buffer = new bytes(2 * length + 2);
314         buffer[0] = "0";
315         buffer[1] = "x";
316         for (uint256 i = 2 * length + 1; i > 1; --i) {
317             buffer[i] = _HEX_SYMBOLS[value & 0xf];
318             value >>= 4;
319         }
320         require(value == 0, "Strings: hex length insufficient");
321         return string(buffer);
322     }
323 
324     /**
325      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
326      */
327     function toHexString(address addr) internal pure returns (string memory) {
328         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
329     }
330 }
331 
332 // File: contracts/ChainPhallusRenderer.sol
333 
334 
335 
336 pragma solidity 0.8.7;
337 
338 
339 contract ChainPhallusRenderer {
340     using Strings for uint256;
341 
342     // Rendering constants
343     string[13] public ballsArray = [unicode"8", unicode"ō", unicode"B", unicode"₿", unicode"β", unicode"З", unicode"$", unicode"𑂈", unicode"𐋀", unicode"Ӡ", unicode"θ", unicode"Ƀ", unicode"Ѯ"];
344     string[21] public shaft1Array = [unicode"=", unicode"Ξ", unicode"⇔", unicode"⁐", unicode"÷", unicode"—", unicode"+", unicode"‡", unicode"∺", unicode"ǂ", unicode"―", unicode"–", unicode"∷", unicode"⋍", unicode"⇌", unicode"⎓", unicode"⟾", unicode"⏔", unicode"⏕", unicode"≂", unicode"≃"];
345     string[21] public shaft2Array = [unicode"=", unicode"Ξ", unicode"⇔", unicode"⁐", unicode"÷", unicode"—", unicode"+", unicode"‡", unicode"∺", unicode"ǂ", unicode"―", unicode"–", unicode"∷", unicode"⋍", unicode"⇌", unicode"⎓", unicode"⟾", unicode"⏔", unicode"⏕", unicode"≂", unicode"≃"];
346     string[19] public headArray = [unicode"D", unicode"Ͽ", unicode"Ͻ", unicode"Đ", unicode"Э", unicode">", unicode"Ӭ", unicode"O", unicode"∋", unicode"Ӛ", unicode"Ә", unicode"»", unicode"Ѳ", unicode"Ӫ", unicode"Θ", unicode"Ɗ", unicode"Ø", unicode"Þ", unicode"⊃"];
347     string[11] public jizzArray = [unicode"~", unicode"—", unicode"–", unicode"―", unicode"¬", unicode"⌐", unicode"⁊", unicode"√", unicode"ᜯ", unicode"ᜰ", unicode"∖"];
348 
349 
350     uint256[21] rarityArray = [0, 2, 5, 9, 14, 20, 27, 35, 44, 54, 65, 77, 90, 104, 119, 135, 152, 170, 189, 209, 230]; // , 252];
351 
352     uint256[10][] ancients;
353 
354     // Mapping to determine pulledOut status for the metadata
355     mapping(uint256 => bool) public pulledOut;
356     // Mapping to determine champion status for the metadata
357     mapping(uint256 => bool) public wienerOfWieners;
358 
359 
360     constructor() {
361         ancients.push([0, 0, 0, 0, 0]);
362         ancients.push([1, 1, 1, 1, 1]);
363         ancients.push([2, 2, 2, 2, 2]);
364         ancients.push([3, 3, 3, 3, 3]);
365         ancients.push([4, 4, 4, 4, 4]);
366         ancients.push([5, 5, 5, 5, 5]);
367         ancients.push([6, 6, 6, 6, 6]);
368         ancients.push([7, 7, 7, 7, 7]);
369         ancients.push([8, 8, 8, 8, 8]);
370         ancients.push([9, 9, 9, 9, 9]);
371     }
372     // Get ChainPhallus address
373     address _chainPhallusAddress;
374     function receiveChainPhallusAddress(address chainPhallusAddress) public {
375         _chainPhallusAddress = chainPhallusAddress;
376     }
377     // TODO: modify selectors and symmetry calculation
378     function getBalls(uint256 id, uint256 seed) public view returns (string memory) {
379         if (id < ancients.length) {
380             return ballsArray[ancients[id][0]];
381         }
382 
383         uint256 raritySelector = seed % 104;
384 
385         uint256 charSelector = 0;
386 
387         for (uint i = 0; i < 13; i++) {
388             if (raritySelector >= rarityArray[i]) {
389                 charSelector = i;
390             }
391         }
392 
393         return ballsArray[charSelector];
394     }
395 
396     function getShaft1(uint256 id, uint256 seed) public view returns (string memory) {
397         if (id < ancients.length) {
398             return shaft1Array[ancients[id][1]];
399         }
400 
401         uint256 raritySelector = seed % 252;
402 
403         uint256 charSelector = 0;
404 
405         for (uint i = 0; i < 21; i++) {
406             if (raritySelector >= rarityArray[i]) {
407                 charSelector = i;
408             }
409         }
410 
411         return shaft1Array[charSelector];
412     }
413 
414     function getShaft2(uint256 id, uint256 seed) public view returns (string memory) {
415         if (id < ancients.length) {
416             return shaft2Array[ancients[id][2]];
417         }
418 
419         uint256 raritySelector = uint256(keccak256(abi.encodePacked(seed))) % 252;
420 
421         uint256 charSelector = 0;
422 
423         for (uint i = 0; i < 21; i++) {
424             if (raritySelector >= rarityArray[i]) {
425                 charSelector = i;
426             }
427         }
428 
429         return shaft2Array[charSelector];
430     }
431 
432     function getHead(uint256 id, uint256 seed) public view returns (string memory) {
433         if (id < ancients.length) {
434             return headArray[ancients[id][3]];
435         }
436 
437         uint256 raritySelector = seed % 209;
438 
439         uint256 charSelector = 0;
440 
441         for (uint i = 0; i < 19; i++) {
442             if (raritySelector >= rarityArray[i]) {
443                 charSelector = i;
444             }
445         }
446 
447         return headArray[charSelector];
448     }
449 
450     function getJizz(uint256 id, uint256 seed) public view returns (string memory) {
451         if (id < ancients.length) {
452             return jizzArray[ancients[id][4]];
453         }
454 
455         uint256 raritySelector = seed % 77;
456 
457         uint256 charSelector = 0;
458 
459         for (uint i = 0; i < 11; i++) {
460             if (raritySelector >= rarityArray[i]) {
461                 charSelector = i;
462             }
463         }
464 
465         return jizzArray[charSelector];
466     }
467 
468     function setPulledOutStatus(uint256 id) external {
469         pulledOut[id] = true;
470     }
471     function setWienerOfWienersStatus(uint256 id) external {
472         wienerOfWieners[id] = true;
473     }
474 
475     function getStatus(uint256 id, address owner) public view returns (string memory) {
476         if (owner == _chainPhallusAddress) {
477             return "Swingin\'";
478         }
479         if (pulledOut[id]) {
480             return "Pulled out";
481         }
482         if (wienerOfWieners[id]) {
483             return "Wiener";
484         }
485         return "Virgin";
486     }
487 
488     function assemblePhallus(bool revealComplete, uint256 id, uint256 seed) public view returns (string memory phallus) {
489         if (!revealComplete) {
490             return '8==D~';
491         }
492 
493         return string(abi.encodePacked(
494                 getBalls(id, seed),
495                 getShaft1(id, seed),
496                 getShaft2(id, seed),
497                 getHead(id, seed),
498                 getJizz(id, seed)
499             ));
500     }
501 
502     function calculateGolfScore(uint256 id, uint256 seed) public view returns (uint256) {
503         if (id < ancients.length) {
504             return 0;
505         }
506 
507         uint256 ballsRarity = seed % 104;
508         uint256 shaft1Rarity = seed % 252;
509         uint256 shaft2Rarity = uint256(keccak256(abi.encodePacked(seed))) % 252;
510         uint256 headRarity = seed % 209;
511         uint256 jizzRarity = seed % 77;
512 
513         uint256 ballsGolf = 0;
514         uint256 shaft1Golf = 0;
515         uint256 shaft2Golf = 0;
516         uint256 headGolf = 0;
517         uint256 jizzGolf = 0;
518         uint256 i = 0;
519 
520         for (i = 0; i < 13; i++) {
521             if (ballsRarity >= rarityArray[i]) {
522                 ballsGolf = i;
523             }
524         }
525         for (i = 0; i < 21; i++) {
526             if (shaft1Rarity >= rarityArray[i]) {
527                 shaft1Golf = i;
528             }
529         }
530         for (i = 0; i < 21; i++) {
531             if (shaft2Rarity >= rarityArray[i]) {
532                 shaft2Golf = i;
533             }
534         }
535         for (i = 0; i < 19; i++) {
536             if (headRarity >= rarityArray[i]) {
537                 headGolf = i;
538             }
539         }
540         for (i = 0; i < 11; i++) {
541             if (jizzRarity >= rarityArray[i]) {
542                 jizzGolf = i;
543             }
544         }
545 
546         return ballsGolf + shaft1Golf + shaft2Golf + headGolf + jizzGolf;
547     }
548 
549     function calculateSymmetry(uint256 id, uint256 seed) public view returns (string memory) {
550 
551         uint256 symCount = 0;
552 
553         if (id < ancients.length) {
554             symCount = 1;
555         } else {
556             uint256 shaft1Rarity = seed % 252;
557             uint256 shaft2Rarity = uint256(keccak256(abi.encodePacked(seed))) % 252;
558 
559             uint256 shaft1Index = 0;
560             uint256 shaft2Index = 0;
561             uint256 i = 0;
562 
563             for (i = 0; i < 21; i++) {
564                 if (shaft1Rarity >= rarityArray[i]) {
565                     shaft1Index = i;
566                 }
567             }
568             for (i = 0; i < 21; i++) {
569                 if (shaft2Rarity >= rarityArray[i]) {
570                     shaft2Index = i;
571                 }
572             }
573             if (shaft1Index == shaft2Index) {
574                 symCount =  1;
575             }
576         }
577         if (symCount == 1) {
578             return "Perfect Shaft";
579         }
580         else {
581             return "Crooked Shaft";
582         }
583     }
584 
585     function getTextColor(uint256 id) public view returns (string memory) {
586         if (id < ancients.length) {
587             return 'RGB(148,256,209)';
588         } else {
589             return 'RGB(0,0,0)';
590         }
591     }
592 
593     function getBackgroundColor(uint256 id, uint256 seed) public view returns (string memory){
594         if (id < ancients.length) {
595             return 'RGB(128,128,128)';
596         }
597 
598         uint256 golf = calculateGolfScore(id, seed);
599         uint256 red;
600         uint256 green;
601         uint256 blue;
602 
603         if (golf >= 56) {
604             red = 255;
605             green = 255;
606             blue = 255 - (golf - 56) * 4;
607         }
608         else {
609             red = 255 - (56 - golf) * 4;
610             green = 255 - (56 - golf) * 4;
611             blue = 255;
612         }
613 
614         return string(abi.encodePacked("RGB(", red.toString(), ",", green.toString(), ",", blue.toString(), ")"));
615     }
616     string constant headerText = 'data:application/json;ascii,{"description": "ChainPhallus Arena; where you go sword to sword until you are crowned the wiener.","image":"data:image/svg+xml;base64,';
617     string constant attributesText = '","attributes":[{"trait_type":"Golf Score","value":';
618     string constant symmetryText = '},{"trait_type":"Shaft","value":"';
619     string constant ballsText = '"},{"trait_type":"Balls","value":"';
620     string constant shaft1Text = '"},{"trait_type":"Lower Shaft","value":"';
621     string constant shaft2Text = '"},{"trait_type":"Upper Shaft","value":"';
622     string constant headText = '"},{"trait_type":"Head","value":"';
623     string constant jizzText = '"},{"trait_type":"Jizz","value":"';
624     string constant statusText = '"},{"trait_type":"Status","value":"';
625     string constant arenaDurationText = '"},{"trait_type":"Arena Score","value":';
626     string constant ancientText = '},{"trait_type":"Ancient","value":"';
627     string constant footerText = '"}]}';
628 
629     function renderMetadata(bool revealComplete, uint256 id, uint256 seed, uint256 arenaDuration, address owner) external view returns (string memory) {
630         if (!revealComplete) {
631             return preRevealMetadata();
632         }
633 
634         uint256 golfScore = calculateGolfScore(id, seed);
635 
636         string memory svg = b64Encode(bytes(renderSvg(true, id, seed, arenaDuration, owner)));
637 
638         string memory attributes = string(abi.encodePacked(attributesText, golfScore.toString()));
639         attributes = string(abi.encodePacked(attributes, symmetryText, calculateSymmetry(id, seed)));
640         attributes = string(abi.encodePacked(attributes, ballsText, getBalls(id, seed)));
641         attributes = string(abi.encodePacked(attributes, shaft1Text, getShaft1(id, seed)));
642         attributes = string(abi.encodePacked(attributes, shaft2Text, getShaft2(id, seed)));
643         attributes = string(abi.encodePacked(attributes, headText, getHead(id, seed)));
644         attributes = string(abi.encodePacked(attributes, jizzText, getJizz(id, seed)));
645         attributes = string(abi.encodePacked(attributes, statusText, getStatus(id, owner)));
646         attributes = string(abi.encodePacked(attributes, arenaDurationText, arenaDuration.toString()));
647 
648         if (id < ancients.length) {
649             attributes = string(abi.encodePacked(attributes, ancientText, 'Ancient'));
650         } else {
651             attributes = string(abi.encodePacked(attributes, ancientText, 'Not Ancient'));
652         }
653 
654         attributes = string(abi.encodePacked(attributes, footerText));
655 
656         return string(abi.encodePacked(headerText, svg, attributes));
657     }
658 
659     string constant svg1 = "<svg xmlns='http://www.w3.org/2000/svg' width='400' height='400' style='background-color:";
660     string constant svg2 = "'>  <filter id='noise'> <feTurbulence type='turbulence' baseFrequency='0.0024' numOctaves='8' result='turbulence' /> <feDisplacementMap in='SourceGraphic' scale='42' /> </filter>";
661     string constant svg3 = "<text style='filter: url(#noise)' x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='75px' fill='";
662     string constant svg4 = "'>";
663     string constant svg5 = "</text></svg>";
664 
665     function renderSvg(bool revealComplete, uint256 id, uint256 seed, uint256 arenaDuration, address owner) public view returns (string memory) {
666         if (!revealComplete) {
667             return preRevealSvg();
668         }
669 
670         string memory phallus = assemblePhallus(true, id, seed);
671         string memory pubes;
672 
673         if (arenaDuration > 0) {
674             pubes = generatePubes(arenaDuration, seed);
675         }
676 
677         return string(abi.encodePacked(svg1, getBackgroundColor(id, seed), svg2, pubes, svg3, getTextColor(id), svg4, phallus, svg5));
678     }
679 
680     string constant pubeSymbol = "<symbol id='pube'><g stroke='RGBA(0,0,0,1)'><text x='40' y='40' dominant-baseline='middle' text-anchor='middle' font-weight='normal' font-size='36px' fill='RGBA(0,0,0,1)'>&#x04A8</text></g></symbol>";
681     string constant pubePlacement1 = "<g transform='translate(";
682     string constant pubePlacement2 = ") scale(";
683     string constant pubePlacement3 = ") rotate(";
684     string constant pubePlacement4 = ")'><use href='#pube'/></g>";
685 
686     function generatePubes(uint256 arenaDuration, uint256 seed) internal pure returns (string memory) {
687         string memory pubes;
688         string memory pubesTemp;
689 
690         uint256 count = arenaDuration / 10;
691 
692         if (count > 500) {
693             count = 500;
694         }
695 
696         for (uint256 i = 0; i < count; i++) {
697             string memory pube;
698 
699             uint256 pubeSeed = uint256(keccak256(abi.encodePacked(seed, i)));
700 
701             uint256 scale1 = pubeSeed % 2;
702             uint256 scale2 = pubeSeed % 5;
703             if (scale1 == 0) {
704                 scale2 += 5;
705             }
706             uint256 xShift = pubeSeed % 332;
707             uint256 yShift = pubeSeed % 354;
708             int256 rotate = int256(pubeSeed % 91) - 45;
709 
710             pube = string(abi.encodePacked(pube, pubePlacement1, xShift.toString(), " ", yShift.toString(), pubePlacement2, scale1.toString(), ".", scale2.toString()));
711 
712             if (rotate >= 0) {
713                 pube = string(abi.encodePacked(pube, pubePlacement3, uint256(rotate).toString(), pubePlacement4));
714             } else {
715                 pube = string(abi.encodePacked(pube, pubePlacement3, "-", uint256(0 - rotate).toString(), pubePlacement4));
716             }
717 
718             pubesTemp = string(abi.encodePacked(pubesTemp, pube));
719 
720             if (i % 10 == 0) {
721                 pubes = string(abi.encodePacked(pubes, pubesTemp));
722                 pubesTemp = "";
723             }
724         }
725 
726         return string(abi.encodePacked(pubeSymbol, pubes, pubesTemp));
727     }
728 
729     function preRevealMetadata() internal pure returns (string memory) {
730         string memory JSON;
731         string memory svg = preRevealSvg();
732         JSON = string(abi.encodePacked('data:application/json;ascii,{"description": "ChainPhallus Arena; where you go sword to sword until you are crowned the wiener.","image":"data:image/svg+xml;base64,', b64Encode(bytes(svg)), '"}'));
733         return JSON;
734     }
735 
736     function preRevealSvg() internal pure returns (string memory) {
737         return "<svg xmlns='http://www.w3.org/2000/svg' width='400' height='400' style='background-color:RGB(255,255,255);'><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='75px'>?????</text></svg>";
738     }
739 
740     string constant private TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
741 
742     function b64Encode(bytes memory _data) internal pure returns (string memory result) {
743         if (_data.length == 0) return '';
744         string memory _table = TABLE;
745         uint256 _encodedLen = 4 * ((_data.length + 2) / 3);
746         result = new string(_encodedLen + 32);
747 
748         assembly {
749             mstore(result, _encodedLen)
750             let tablePtr := add(_table, 1)
751             let dataPtr := _data
752             let endPtr := add(dataPtr, mload(_data))
753             let resultPtr := add(result, 32)
754 
755             for {} lt(dataPtr, endPtr) {}
756             {
757                 dataPtr := add(dataPtr, 3)
758                 let input := mload(dataPtr)
759                 mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
760                 resultPtr := add(resultPtr, 1)
761                 mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
762                 resultPtr := add(resultPtr, 1)
763                 mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F)))))
764                 resultPtr := add(resultPtr, 1)
765                 mstore(resultPtr, shl(248, mload(add(tablePtr, and(input, 0x3F)))))
766                 resultPtr := add(resultPtr, 1)
767             }
768             switch mod(mload(_data), 3)
769             case 1 {mstore(sub(resultPtr, 2), shl(240, 0x3d3d))}
770             case 2 {mstore(sub(resultPtr, 1), shl(248, 0x3d))}
771         }
772         return result;
773     }
774 }
775 // File: @openzeppelin/contracts@4.7.3/utils/Context.sol
776 
777 
778 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 /**
783  * @dev Provides information about the current execution context, including the
784  * sender of the transaction and its data. While these are generally available
785  * via msg.sender and msg.data, they should not be accessed in such a direct
786  * manner, since when dealing with meta-transactions the account sending and
787  * paying for execution may not be the actual sender (as far as an application
788  * is concerned).
789  *
790  * This contract is only required for intermediate, library-like contracts.
791  */
792 abstract contract Context {
793     function _msgSender() internal view virtual returns (address) {
794         return msg.sender;
795     }
796 
797     function _msgData() internal view virtual returns (bytes calldata) {
798         return msg.data;
799     }
800 }
801 
802 // File: @openzeppelin/contracts@4.7.3/access/Ownable.sol
803 
804 
805 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
806 
807 pragma solidity ^0.8.0;
808 
809 
810 /**
811  * @dev Contract module which provides a basic access control mechanism, where
812  * there is an account (an owner) that can be granted exclusive access to
813  * specific functions.
814  *
815  * By default, the owner account will be the one that deploys the contract. This
816  * can later be changed with {transferOwnership}.
817  *
818  * This module is used through inheritance. It will make available the modifier
819  * `onlyOwner`, which can be applied to your functions to restrict their use to
820  * the owner.
821  */
822 abstract contract Ownable is Context {
823     address private _owner;
824 
825     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
826 
827     /**
828      * @dev Initializes the contract setting the deployer as the initial owner.
829      */
830     constructor() {
831         _transferOwnership(_msgSender());
832     }
833 
834     /**
835      * @dev Throws if called by any account other than the owner.
836      */
837     modifier onlyOwner() {
838         _checkOwner();
839         _;
840     }
841 
842     /**
843      * @dev Returns the address of the current owner.
844      */
845     function owner() public view virtual returns (address) {
846         return _owner;
847     }
848 
849     /**
850      * @dev Throws if the sender is not the owner.
851      */
852     function _checkOwner() internal view virtual {
853         require(owner() == _msgSender(), "Ownable: caller is not the owner");
854     }
855 
856     /**
857      * @dev Leaves the contract without owner. It will not be possible to call
858      * `onlyOwner` functions anymore. Can only be called by the current owner.
859      *
860      * NOTE: Renouncing ownership will leave the contract without an owner,
861      * thereby removing any functionality that is only available to the owner.
862      */
863     function renounceOwnership() public virtual onlyOwner {
864         _transferOwnership(address(0));
865     }
866 
867     /**
868      * @dev Transfers ownership of the contract to a new account (`newOwner`).
869      * Can only be called by the current owner.
870      */
871     function transferOwnership(address newOwner) public virtual onlyOwner {
872         require(newOwner != address(0), "Ownable: new owner is the zero address");
873         _transferOwnership(newOwner);
874     }
875 
876     /**
877      * @dev Transfers ownership of the contract to a new account (`newOwner`).
878      * Internal function without access restriction.
879      */
880     function _transferOwnership(address newOwner) internal virtual {
881         address oldOwner = _owner;
882         _owner = newOwner;
883         emit OwnershipTransferred(oldOwner, newOwner);
884     }
885 }
886 
887 // File: @openzeppelin/contracts@4.7.3/utils/Address.sol
888 
889 
890 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
891 
892 pragma solidity ^0.8.1;
893 
894 /**
895  * @dev Collection of functions related to the address type
896  */
897 library Address {
898     /**
899      * @dev Returns true if `account` is a contract.
900      *
901      * [IMPORTANT]
902      * ====
903      * It is unsafe to assume that an address for which this function returns
904      * false is an externally-owned account (EOA) and not a contract.
905      *
906      * Among others, `isContract` will return false for the following
907      * types of addresses:
908      *
909      *  - an externally-owned account
910      *  - a contract in construction
911      *  - an address where a contract will be created
912      *  - an address where a contract lived, but was destroyed
913      * ====
914      *
915      * [IMPORTANT]
916      * ====
917      * You shouldn't rely on `isContract` to protect against flash loan attacks!
918      *
919      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
920      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
921      * constructor.
922      * ====
923      */
924     function isContract(address account) internal view returns (bool) {
925         // This method relies on extcodesize/address.code.length, which returns 0
926         // for contracts in construction, since the code is only stored at the end
927         // of the constructor execution.
928 
929         return account.code.length > 0;
930     }
931 
932     /**
933      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
934      * `recipient`, forwarding all available gas and reverting on errors.
935      *
936      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
937      * of certain opcodes, possibly making contracts go over the 2300 gas limit
938      * imposed by `transfer`, making them unable to receive funds via
939      * `transfer`. {sendValue} removes this limitation.
940      *
941      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
942      *
943      * IMPORTANT: because control is transferred to `recipient`, care must be
944      * taken to not create reentrancy vulnerabilities. Consider using
945      * {ReentrancyGuard} or the
946      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
947      */
948     function sendValue(address payable recipient, uint256 amount) internal {
949         require(address(this).balance >= amount, "Address: insufficient balance");
950 
951         (bool success, ) = recipient.call{value: amount}("");
952         require(success, "Address: unable to send value, recipient may have reverted");
953     }
954 
955     /**
956      * @dev Performs a Solidity function call using a low level `call`. A
957      * plain `call` is an unsafe replacement for a function call: use this
958      * function instead.
959      *
960      * If `target` reverts with a revert reason, it is bubbled up by this
961      * function (like regular Solidity function calls).
962      *
963      * Returns the raw returned data. To convert to the expected return value,
964      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
965      *
966      * Requirements:
967      *
968      * - `target` must be a contract.
969      * - calling `target` with `data` must not revert.
970      *
971      * _Available since v3.1._
972      */
973     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
974         return functionCall(target, data, "Address: low-level call failed");
975     }
976 
977     /**
978      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
979      * `errorMessage` as a fallback revert reason when `target` reverts.
980      *
981      * _Available since v3.1._
982      */
983     function functionCall(
984         address target,
985         bytes memory data,
986         string memory errorMessage
987     ) internal returns (bytes memory) {
988         return functionCallWithValue(target, data, 0, errorMessage);
989     }
990 
991     /**
992      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
993      * but also transferring `value` wei to `target`.
994      *
995      * Requirements:
996      *
997      * - the calling contract must have an ETH balance of at least `value`.
998      * - the called Solidity function must be `payable`.
999      *
1000      * _Available since v3.1._
1001      */
1002     function functionCallWithValue(
1003         address target,
1004         bytes memory data,
1005         uint256 value
1006     ) internal returns (bytes memory) {
1007         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1012      * with `errorMessage` as a fallback revert reason when `target` reverts.
1013      *
1014      * _Available since v3.1._
1015      */
1016     function functionCallWithValue(
1017         address target,
1018         bytes memory data,
1019         uint256 value,
1020         string memory errorMessage
1021     ) internal returns (bytes memory) {
1022         require(address(this).balance >= value, "Address: insufficient balance for call");
1023         require(isContract(target), "Address: call to non-contract");
1024 
1025         (bool success, bytes memory returndata) = target.call{value: value}(data);
1026         return verifyCallResult(success, returndata, errorMessage);
1027     }
1028 
1029     /**
1030      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1031      * but performing a static call.
1032      *
1033      * _Available since v3.3._
1034      */
1035     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1036         return functionStaticCall(target, data, "Address: low-level static call failed");
1037     }
1038 
1039     /**
1040      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1041      * but performing a static call.
1042      *
1043      * _Available since v3.3._
1044      */
1045     function functionStaticCall(
1046         address target,
1047         bytes memory data,
1048         string memory errorMessage
1049     ) internal view returns (bytes memory) {
1050         require(isContract(target), "Address: static call to non-contract");
1051 
1052         (bool success, bytes memory returndata) = target.staticcall(data);
1053         return verifyCallResult(success, returndata, errorMessage);
1054     }
1055 
1056     /**
1057      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1058      * but performing a delegate call.
1059      *
1060      * _Available since v3.4._
1061      */
1062     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1063         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1064     }
1065 
1066     /**
1067      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1068      * but performing a delegate call.
1069      *
1070      * _Available since v3.4._
1071      */
1072     function functionDelegateCall(
1073         address target,
1074         bytes memory data,
1075         string memory errorMessage
1076     ) internal returns (bytes memory) {
1077         require(isContract(target), "Address: delegate call to non-contract");
1078 
1079         (bool success, bytes memory returndata) = target.delegatecall(data);
1080         return verifyCallResult(success, returndata, errorMessage);
1081     }
1082 
1083     /**
1084      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1085      * revert reason using the provided one.
1086      *
1087      * _Available since v4.3._
1088      */
1089     function verifyCallResult(
1090         bool success,
1091         bytes memory returndata,
1092         string memory errorMessage
1093     ) internal pure returns (bytes memory) {
1094         if (success) {
1095             return returndata;
1096         } else {
1097             // Look for revert reason and bubble it up if present
1098             if (returndata.length > 0) {
1099                 // The easiest way to bubble the revert reason is using memory via assembly
1100                 /// @solidity memory-safe-assembly
1101                 assembly {
1102                     let returndata_size := mload(returndata)
1103                     revert(add(32, returndata), returndata_size)
1104                 }
1105             } else {
1106                 revert(errorMessage);
1107             }
1108         }
1109     }
1110 }
1111 
1112 // File: @openzeppelin/contracts@4.7.3/token/ERC721/IERC721Receiver.sol
1113 
1114 
1115 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 /**
1120  * @title ERC721 token receiver interface
1121  * @dev Interface for any contract that wants to support safeTransfers
1122  * from ERC721 asset contracts.
1123  */
1124 interface IERC721Receiver {
1125     /**
1126      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1127      * by `operator` from `from`, this function is called.
1128      *
1129      * It must return its Solidity selector to confirm the token transfer.
1130      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1131      *
1132      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1133      */
1134     function onERC721Received(
1135         address operator,
1136         address from,
1137         uint256 tokenId,
1138         bytes calldata data
1139     ) external returns (bytes4);
1140 }
1141 
1142 // File: @openzeppelin/contracts@4.7.3/utils/introspection/IERC165.sol
1143 
1144 
1145 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 /**
1150  * @dev Interface of the ERC165 standard, as defined in the
1151  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1152  *
1153  * Implementers can declare support of contract interfaces, which can then be
1154  * queried by others ({ERC165Checker}).
1155  *
1156  * For an implementation, see {ERC165}.
1157  */
1158 interface IERC165 {
1159     /**
1160      * @dev Returns true if this contract implements the interface defined by
1161      * `interfaceId`. See the corresponding
1162      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1163      * to learn more about how these ids are created.
1164      *
1165      * This function call must use less than 30 000 gas.
1166      */
1167     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1168 }
1169 
1170 // File: @openzeppelin/contracts@4.7.3/utils/introspection/ERC165.sol
1171 
1172 
1173 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 
1178 /**
1179  * @dev Implementation of the {IERC165} interface.
1180  *
1181  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1182  * for the additional interface id that will be supported. For example:
1183  *
1184  * ```solidity
1185  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1186  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1187  * }
1188  * ```
1189  *
1190  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1191  */
1192 abstract contract ERC165 is IERC165 {
1193     /**
1194      * @dev See {IERC165-supportsInterface}.
1195      */
1196     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1197         return interfaceId == type(IERC165).interfaceId;
1198     }
1199 }
1200 
1201 // File: @openzeppelin/contracts@4.7.3/token/ERC721/IERC721.sol
1202 
1203 
1204 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 
1209 /**
1210  * @dev Required interface of an ERC721 compliant contract.
1211  */
1212 interface IERC721 is IERC165 {
1213     /**
1214      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1215      */
1216     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1217 
1218     /**
1219      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1220      */
1221     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1222 
1223     /**
1224      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1225      */
1226     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1227 
1228     /**
1229      * @dev Returns the number of tokens in ``owner``'s account.
1230      */
1231     function balanceOf(address owner) external view returns (uint256 balance);
1232 
1233     /**
1234      * @dev Returns the owner of the `tokenId` token.
1235      *
1236      * Requirements:
1237      *
1238      * - `tokenId` must exist.
1239      */
1240     function ownerOf(uint256 tokenId) external view returns (address owner);
1241 
1242     /**
1243      * @dev Safely transfers `tokenId` token from `from` to `to`.
1244      *
1245      * Requirements:
1246      *
1247      * - `from` cannot be the zero address.
1248      * - `to` cannot be the zero address.
1249      * - `tokenId` token must exist and be owned by `from`.
1250      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1251      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function safeTransferFrom(
1256         address from,
1257         address to,
1258         uint256 tokenId,
1259         bytes calldata data
1260     ) external;
1261 
1262     /**
1263      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1264      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1265      *
1266      * Requirements:
1267      *
1268      * - `from` cannot be the zero address.
1269      * - `to` cannot be the zero address.
1270      * - `tokenId` token must exist and be owned by `from`.
1271      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1272      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function safeTransferFrom(
1277         address from,
1278         address to,
1279         uint256 tokenId
1280     ) external;
1281 
1282     /**
1283      * @dev Transfers `tokenId` token from `from` to `to`.
1284      *
1285      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1286      *
1287      * Requirements:
1288      *
1289      * - `from` cannot be the zero address.
1290      * - `to` cannot be the zero address.
1291      * - `tokenId` token must be owned by `from`.
1292      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1293      *
1294      * Emits a {Transfer} event.
1295      */
1296     function transferFrom(
1297         address from,
1298         address to,
1299         uint256 tokenId
1300     ) external;
1301 
1302     /**
1303      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1304      * The approval is cleared when the token is transferred.
1305      *
1306      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1307      *
1308      * Requirements:
1309      *
1310      * - The caller must own the token or be an approved operator.
1311      * - `tokenId` must exist.
1312      *
1313      * Emits an {Approval} event.
1314      */
1315     function approve(address to, uint256 tokenId) external;
1316 
1317     /**
1318      * @dev Approve or remove `operator` as an operator for the caller.
1319      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1320      *
1321      * Requirements:
1322      *
1323      * - The `operator` cannot be the caller.
1324      *
1325      * Emits an {ApprovalForAll} event.
1326      */
1327     function setApprovalForAll(address operator, bool _approved) external;
1328 
1329     /**
1330      * @dev Returns the account approved for `tokenId` token.
1331      *
1332      * Requirements:
1333      *
1334      * - `tokenId` must exist.
1335      */
1336     function getApproved(uint256 tokenId) external view returns (address operator);
1337 
1338     /**
1339      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1340      *
1341      * See {setApprovalForAll}
1342      */
1343     function isApprovedForAll(address owner, address operator) external view returns (bool);
1344 }
1345 
1346 // File: @openzeppelin/contracts@4.7.3/token/ERC721/extensions/IERC721Enumerable.sol
1347 
1348 
1349 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 
1354 /**
1355  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1356  * @dev See https://eips.ethereum.org/EIPS/eip-721
1357  */
1358 interface IERC721Enumerable is IERC721 {
1359     /**
1360      * @dev Returns the total amount of tokens stored by the contract.
1361      */
1362     function totalSupply() external view returns (uint256);
1363 
1364     /**
1365      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1366      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1367      */
1368     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1369 
1370     /**
1371      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1372      * Use along with {totalSupply} to enumerate all tokens.
1373      */
1374     function tokenByIndex(uint256 index) external view returns (uint256);
1375 }
1376 
1377 // File: @openzeppelin/contracts@4.7.3/token/ERC721/extensions/IERC721Metadata.sol
1378 
1379 
1380 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1381 
1382 pragma solidity ^0.8.0;
1383 
1384 
1385 /**
1386  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1387  * @dev See https://eips.ethereum.org/EIPS/eip-721
1388  */
1389 interface IERC721Metadata is IERC721 {
1390     /**
1391      * @dev Returns the token collection name.
1392      */
1393     function name() external view returns (string memory);
1394 
1395     /**
1396      * @dev Returns the token collection symbol.
1397      */
1398     function symbol() external view returns (string memory);
1399 
1400     /**
1401      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1402      */
1403     function tokenURI(uint256 tokenId) external view returns (string memory);
1404 }
1405 
1406 // File: @openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol
1407 
1408 
1409 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1410 
1411 pragma solidity ^0.8.0;
1412 
1413 
1414 
1415 
1416 
1417 
1418 
1419 
1420 /**
1421  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1422  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1423  * {ERC721Enumerable}.
1424  */
1425 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1426     using Address for address;
1427     using Strings for uint256;
1428 
1429     // Token name
1430     string private _name;
1431 
1432     // Token symbol
1433     string private _symbol;
1434 
1435     // Mapping from token ID to owner address
1436     mapping(uint256 => address) private _owners;
1437 
1438     // Mapping owner address to token count
1439     mapping(address => uint256) private _balances;
1440 
1441     // Mapping from token ID to approved address
1442     mapping(uint256 => address) private _tokenApprovals;
1443 
1444     // Mapping from owner to operator approvals
1445     mapping(address => mapping(address => bool)) private _operatorApprovals;
1446 
1447     /**
1448      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1449      */
1450     constructor(string memory name_, string memory symbol_) {
1451         _name = name_;
1452         _symbol = symbol_;
1453     }
1454 
1455     /**
1456      * @dev See {IERC165-supportsInterface}.
1457      */
1458     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1459         return
1460             interfaceId == type(IERC721).interfaceId ||
1461             interfaceId == type(IERC721Metadata).interfaceId ||
1462             super.supportsInterface(interfaceId);
1463     }
1464 
1465     /**
1466      * @dev See {IERC721-balanceOf}.
1467      */
1468     function balanceOf(address owner) public view virtual override returns (uint256) {
1469         require(owner != address(0), "ERC721: address zero is not a valid owner");
1470         return _balances[owner];
1471     }
1472 
1473     /**
1474      * @dev See {IERC721-ownerOf}.
1475      */
1476     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1477         address owner = _owners[tokenId];
1478         require(owner != address(0), "ERC721: invalid token ID");
1479         return owner;
1480     }
1481 
1482     /**
1483      * @dev See {IERC721Metadata-name}.
1484      */
1485     function name() public view virtual override returns (string memory) {
1486         return _name;
1487     }
1488 
1489     /**
1490      * @dev See {IERC721Metadata-symbol}.
1491      */
1492     function symbol() public view virtual override returns (string memory) {
1493         return _symbol;
1494     }
1495 
1496     /**
1497      * @dev See {IERC721Metadata-tokenURI}.
1498      */
1499     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1500         _requireMinted(tokenId);
1501 
1502         string memory baseURI = _baseURI();
1503         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1504     }
1505 
1506     /**
1507      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1508      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1509      * by default, can be overridden in child contracts.
1510      */
1511     function _baseURI() internal view virtual returns (string memory) {
1512         return "";
1513     }
1514 
1515     /**
1516      * @dev See {IERC721-approve}.
1517      */
1518     function approve(address to, uint256 tokenId) public virtual override {
1519         address owner = ERC721.ownerOf(tokenId);
1520         require(to != owner, "ERC721: approval to current owner");
1521 
1522         require(
1523             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1524             "ERC721: approve caller is not token owner nor approved for all"
1525         );
1526 
1527         _approve(to, tokenId);
1528     }
1529 
1530     /**
1531      * @dev See {IERC721-getApproved}.
1532      */
1533     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1534         _requireMinted(tokenId);
1535 
1536         return _tokenApprovals[tokenId];
1537     }
1538 
1539     /**
1540      * @dev See {IERC721-setApprovalForAll}.
1541      */
1542     function setApprovalForAll(address operator, bool approved) public virtual override {
1543         _setApprovalForAll(_msgSender(), operator, approved);
1544     }
1545 
1546     /**
1547      * @dev See {IERC721-isApprovedForAll}.
1548      */
1549     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1550         return _operatorApprovals[owner][operator];
1551     }
1552 
1553     /**
1554      * @dev See {IERC721-transferFrom}.
1555      */
1556     function transferFrom(
1557         address from,
1558         address to,
1559         uint256 tokenId
1560     ) public virtual override {
1561         //solhint-disable-next-line max-line-length
1562         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1563 
1564         _transfer(from, to, tokenId);
1565     }
1566 
1567     /**
1568      * @dev See {IERC721-safeTransferFrom}.
1569      */
1570     function safeTransferFrom(
1571         address from,
1572         address to,
1573         uint256 tokenId
1574     ) public virtual override {
1575         safeTransferFrom(from, to, tokenId, "");
1576     }
1577 
1578     /**
1579      * @dev See {IERC721-safeTransferFrom}.
1580      */
1581     function safeTransferFrom(
1582         address from,
1583         address to,
1584         uint256 tokenId,
1585         bytes memory data
1586     ) public virtual override {
1587         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1588         _safeTransfer(from, to, tokenId, data);
1589     }
1590 
1591     /**
1592      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1593      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1594      *
1595      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1596      *
1597      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1598      * implement alternative mechanisms to perform token transfer, such as signature-based.
1599      *
1600      * Requirements:
1601      *
1602      * - `from` cannot be the zero address.
1603      * - `to` cannot be the zero address.
1604      * - `tokenId` token must exist and be owned by `from`.
1605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1606      *
1607      * Emits a {Transfer} event.
1608      */
1609     function _safeTransfer(
1610         address from,
1611         address to,
1612         uint256 tokenId,
1613         bytes memory data
1614     ) internal virtual {
1615         _transfer(from, to, tokenId);
1616         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1617     }
1618 
1619     /**
1620      * @dev Returns whether `tokenId` exists.
1621      *
1622      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1623      *
1624      * Tokens start existing when they are minted (`_mint`),
1625      * and stop existing when they are burned (`_burn`).
1626      */
1627     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1628         return _owners[tokenId] != address(0);
1629     }
1630 
1631     /**
1632      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1633      *
1634      * Requirements:
1635      *
1636      * - `tokenId` must exist.
1637      */
1638     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1639         address owner = ERC721.ownerOf(tokenId);
1640         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1641     }
1642 
1643     /**
1644      * @dev Safely mints `tokenId` and transfers it to `to`.
1645      *
1646      * Requirements:
1647      *
1648      * - `tokenId` must not exist.
1649      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1650      *
1651      * Emits a {Transfer} event.
1652      */
1653     function _safeMint(address to, uint256 tokenId) internal virtual {
1654         _safeMint(to, tokenId, "");
1655     }
1656 
1657     /**
1658      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1659      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1660      */
1661     function _safeMint(
1662         address to,
1663         uint256 tokenId,
1664         bytes memory data
1665     ) internal virtual {
1666         _mint(to, tokenId);
1667         require(
1668             _checkOnERC721Received(address(0), to, tokenId, data),
1669             "ERC721: transfer to non ERC721Receiver implementer"
1670         );
1671     }
1672 
1673     /**
1674      * @dev Mints `tokenId` and transfers it to `to`.
1675      *
1676      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1677      *
1678      * Requirements:
1679      *
1680      * - `tokenId` must not exist.
1681      * - `to` cannot be the zero address.
1682      *
1683      * Emits a {Transfer} event.
1684      */
1685     function _mint(address to, uint256 tokenId) internal virtual {
1686         require(to != address(0), "ERC721: mint to the zero address");
1687         require(!_exists(tokenId), "ERC721: token already minted");
1688 
1689         _beforeTokenTransfer(address(0), to, tokenId);
1690 
1691         _balances[to] += 1;
1692         _owners[tokenId] = to;
1693 
1694         emit Transfer(address(0), to, tokenId);
1695 
1696         _afterTokenTransfer(address(0), to, tokenId);
1697     }
1698 
1699     /**
1700      * @dev Destroys `tokenId`.
1701      * The approval is cleared when the token is burned.
1702      *
1703      * Requirements:
1704      *
1705      * - `tokenId` must exist.
1706      *
1707      * Emits a {Transfer} event.
1708      */
1709     function _burn(uint256 tokenId) internal virtual {
1710         address owner = ERC721.ownerOf(tokenId);
1711 
1712         _beforeTokenTransfer(owner, address(0), tokenId);
1713 
1714         // Clear approvals
1715         _approve(address(0), tokenId);
1716 
1717         _balances[owner] -= 1;
1718         delete _owners[tokenId];
1719 
1720         emit Transfer(owner, address(0), tokenId);
1721 
1722         _afterTokenTransfer(owner, address(0), tokenId);
1723     }
1724 
1725     /**
1726      * @dev Transfers `tokenId` from `from` to `to`.
1727      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1728      *
1729      * Requirements:
1730      *
1731      * - `to` cannot be the zero address.
1732      * - `tokenId` token must be owned by `from`.
1733      *
1734      * Emits a {Transfer} event.
1735      */
1736     function _transfer(
1737         address from,
1738         address to,
1739         uint256 tokenId
1740     ) internal virtual {
1741         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1742         require(to != address(0), "ERC721: transfer to the zero address");
1743 
1744         _beforeTokenTransfer(from, to, tokenId);
1745 
1746         // Clear approvals from the previous owner
1747         _approve(address(0), tokenId);
1748 
1749         _balances[from] -= 1;
1750         _balances[to] += 1;
1751         _owners[tokenId] = to;
1752 
1753         emit Transfer(from, to, tokenId);
1754 
1755         _afterTokenTransfer(from, to, tokenId);
1756     }
1757 
1758     /**
1759      * @dev Approve `to` to operate on `tokenId`
1760      *
1761      * Emits an {Approval} event.
1762      */
1763     function _approve(address to, uint256 tokenId) internal virtual {
1764         _tokenApprovals[tokenId] = to;
1765         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1766     }
1767 
1768     /**
1769      * @dev Approve `operator` to operate on all of `owner` tokens
1770      *
1771      * Emits an {ApprovalForAll} event.
1772      */
1773     function _setApprovalForAll(
1774         address owner,
1775         address operator,
1776         bool approved
1777     ) internal virtual {
1778         require(owner != operator, "ERC721: approve to caller");
1779         _operatorApprovals[owner][operator] = approved;
1780         emit ApprovalForAll(owner, operator, approved);
1781     }
1782 
1783     /**
1784      * @dev Reverts if the `tokenId` has not been minted yet.
1785      */
1786     function _requireMinted(uint256 tokenId) internal view virtual {
1787         require(_exists(tokenId), "ERC721: invalid token ID");
1788     }
1789 
1790     /**
1791      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1792      * The call is not executed if the target address is not a contract.
1793      *
1794      * @param from address representing the previous owner of the given token ID
1795      * @param to target address that will receive the tokens
1796      * @param tokenId uint256 ID of the token to be transferred
1797      * @param data bytes optional data to send along with the call
1798      * @return bool whether the call correctly returned the expected magic value
1799      */
1800     function _checkOnERC721Received(
1801         address from,
1802         address to,
1803         uint256 tokenId,
1804         bytes memory data
1805     ) private returns (bool) {
1806         if (to.isContract()) {
1807             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1808                 return retval == IERC721Receiver.onERC721Received.selector;
1809             } catch (bytes memory reason) {
1810                 if (reason.length == 0) {
1811                     revert("ERC721: transfer to non ERC721Receiver implementer");
1812                 } else {
1813                     /// @solidity memory-safe-assembly
1814                     assembly {
1815                         revert(add(32, reason), mload(reason))
1816                     }
1817                 }
1818             }
1819         } else {
1820             return true;
1821         }
1822     }
1823 
1824     /**
1825      * @dev Hook that is called before any token transfer. This includes minting
1826      * and burning.
1827      *
1828      * Calling conditions:
1829      *
1830      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1831      * transferred to `to`.
1832      * - When `from` is zero, `tokenId` will be minted for `to`.
1833      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1834      * - `from` and `to` are never both zero.
1835      *
1836      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1837      */
1838     function _beforeTokenTransfer(
1839         address from,
1840         address to,
1841         uint256 tokenId
1842     ) internal virtual {}
1843 
1844     /**
1845      * @dev Hook that is called after any transfer of tokens. This includes
1846      * minting and burning.
1847      *
1848      * Calling conditions:
1849      *
1850      * - when `from` and `to` are both non-zero.
1851      * - `from` and `to` are never both zero.
1852      *
1853      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1854      */
1855     function _afterTokenTransfer(
1856         address from,
1857         address to,
1858         uint256 tokenId
1859     ) internal virtual {}
1860 }
1861 
1862 // File: @openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Enumerable.sol
1863 
1864 
1865 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1866 
1867 pragma solidity ^0.8.0;
1868 
1869 
1870 
1871 /**
1872  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1873  * enumerability of all the token ids in the contract as well as all token ids owned by each
1874  * account.
1875  */
1876 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1877     // Mapping from owner to list of owned token IDs
1878     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1879 
1880     // Mapping from token ID to index of the owner tokens list
1881     mapping(uint256 => uint256) private _ownedTokensIndex;
1882 
1883     // Array with all token ids, used for enumeration
1884     uint256[] private _allTokens;
1885 
1886     // Mapping from token id to position in the allTokens array
1887     mapping(uint256 => uint256) private _allTokensIndex;
1888 
1889     /**
1890      * @dev See {IERC165-supportsInterface}.
1891      */
1892     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1893         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1894     }
1895 
1896     /**
1897      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1898      */
1899     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1900         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1901         return _ownedTokens[owner][index];
1902     }
1903 
1904     /**
1905      * @dev See {IERC721Enumerable-totalSupply}.
1906      */
1907     function totalSupply() public view virtual override returns (uint256) {
1908         return _allTokens.length;
1909     }
1910 
1911     /**
1912      * @dev See {IERC721Enumerable-tokenByIndex}.
1913      */
1914     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1915         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1916         return _allTokens[index];
1917     }
1918 
1919     /**
1920      * @dev Hook that is called before any token transfer. This includes minting
1921      * and burning.
1922      *
1923      * Calling conditions:
1924      *
1925      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1926      * transferred to `to`.
1927      * - When `from` is zero, `tokenId` will be minted for `to`.
1928      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1929      * - `from` cannot be the zero address.
1930      * - `to` cannot be the zero address.
1931      *
1932      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1933      */
1934     function _beforeTokenTransfer(
1935         address from,
1936         address to,
1937         uint256 tokenId
1938     ) internal virtual override {
1939         super._beforeTokenTransfer(from, to, tokenId);
1940 
1941         if (from == address(0)) {
1942             _addTokenToAllTokensEnumeration(tokenId);
1943         } else if (from != to) {
1944             _removeTokenFromOwnerEnumeration(from, tokenId);
1945         }
1946         if (to == address(0)) {
1947             _removeTokenFromAllTokensEnumeration(tokenId);
1948         } else if (to != from) {
1949             _addTokenToOwnerEnumeration(to, tokenId);
1950         }
1951     }
1952 
1953     /**
1954      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1955      * @param to address representing the new owner of the given token ID
1956      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1957      */
1958     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1959         uint256 length = ERC721.balanceOf(to);
1960         _ownedTokens[to][length] = tokenId;
1961         _ownedTokensIndex[tokenId] = length;
1962     }
1963 
1964     /**
1965      * @dev Private function to add a token to this extension's token tracking data structures.
1966      * @param tokenId uint256 ID of the token to be added to the tokens list
1967      */
1968     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1969         _allTokensIndex[tokenId] = _allTokens.length;
1970         _allTokens.push(tokenId);
1971     }
1972 
1973     /**
1974      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1975      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1976      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1977      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1978      * @param from address representing the previous owner of the given token ID
1979      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1980      */
1981     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1982         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1983         // then delete the last slot (swap and pop).
1984 
1985         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1986         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1987 
1988         // When the token to delete is the last token, the swap operation is unnecessary
1989         if (tokenIndex != lastTokenIndex) {
1990             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1991 
1992             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1993             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1994         }
1995 
1996         // This also deletes the contents at the last position of the array
1997         delete _ownedTokensIndex[tokenId];
1998         delete _ownedTokens[from][lastTokenIndex];
1999     }
2000 
2001     /**
2002      * @dev Private function to remove a token from this extension's token tracking data structures.
2003      * This has O(1) time complexity, but alters the order of the _allTokens array.
2004      * @param tokenId uint256 ID of the token to be removed from the tokens list
2005      */
2006     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2007         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2008         // then delete the last slot (swap and pop).
2009 
2010         uint256 lastTokenIndex = _allTokens.length - 1;
2011         uint256 tokenIndex = _allTokensIndex[tokenId];
2012 
2013         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2014         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2015         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2016         uint256 lastTokenId = _allTokens[lastTokenIndex];
2017 
2018         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2019         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2020 
2021         // This also deletes the contents at the last position of the array
2022         delete _allTokensIndex[tokenId];
2023         _allTokens.pop();
2024     }
2025 }
2026 
2027 // File: contracts/ChainPhallus.sol
2028 
2029 
2030 
2031 pragma solidity 0.8.7;
2032 
2033 
2034 
2035 
2036 
2037 
2038 
2039 contract ChainPhallus is ERC721, ERC721Enumerable, Ownable {
2040 
2041     /*************************
2042      COMMON
2043      *************************/
2044 
2045     // Sale stage enum
2046     enum Stage {
2047         STAGE_COMPLETE,  // 0
2048         STAGE_PRESALE,  // 1
2049         STAGE_MAIN_SALE // 2
2050     }
2051 
2052     bool balanceNotWithdrawn;
2053 
2054     constructor(uint256 _secretCommit, address _renderer, bytes32 _merkleRoot) ERC721("ChainPhallus Arena", unicode"8==D~")  {
2055         // tokenLimit = _tokenLimit;
2056         secret = _secretCommit;
2057         merkleRoot = _merkleRoot;
2058         balanceNotWithdrawn = true;
2059 
2060         // Start in presale stage
2061         stage = Stage.STAGE_PRESALE;
2062 
2063         renderer = ChainPhallusRenderer(_renderer);
2064 
2065         // Send address to renderer
2066         renderer.receiveChainPhallusAddress(address(this));
2067 
2068         // Mint ancients
2069         for (uint256 i = 0; i < 10;) {
2070             _createPhallus();
2071             unchecked{ i++; }
2072         }
2073     }
2074 
2075     fallback() external payable {}
2076 
2077     /*************************
2078      TOKEN SALE
2079      *************************/
2080 
2081     Stage public               stage;
2082     uint256 public             saleEnds;
2083 
2084     // Merkle distributor values
2085     bytes32 immutable merkleRoot;
2086     mapping(uint256 => uint256) private claimedBitMap;
2087     uint256 public constant saleLength = 69 hours;
2088     uint256 public constant salePrice = 0.025 ether;
2089 
2090     uint256 secret;             // Entropy supplied by owner (commit/reveal style)
2091     uint256 userSecret;         // Pseudorandom entropy provided by minters
2092 
2093     // -- MODIFIERS --
2094 
2095     modifier onlyMainSaleOpen() {
2096         if (stage != Stage.STAGE_MAIN_SALE || mainSaleComplete()) {
2097             revert SaleNotOpen();
2098         }
2099         _;
2100     }
2101 
2102     modifier onlyPreSale() {
2103         if (stage != Stage.STAGE_PRESALE) {
2104             revert NotPreSaleStage();
2105         }
2106         _;
2107     }
2108 
2109     modifier onlyMainSale() {
2110         if (stage != Stage.STAGE_MAIN_SALE) {
2111             revert NotMainSaleStage();
2112         }
2113         _;
2114     }
2115 
2116     modifier onlySaleComplete() {
2117         if (stage != Stage.STAGE_COMPLETE) {
2118             revert SaleNotComplete();
2119         }
2120         _;
2121     }
2122 
2123     // -- VIEW METHODS --
2124 
2125     function mainSaleComplete() public view returns (bool) {
2126         return block.timestamp >= saleEnds;  // || totalSupply() == tokenLimit;
2127     }
2128 
2129     function isClaimed(uint256 index) public view returns (bool) {
2130         uint256 claimedWordIndex = index / 256;
2131         uint256 claimedBitIndex = index % 256;
2132         uint256 claimedWord = claimedBitMap[claimedWordIndex];
2133         uint256 mask = (1 << claimedBitIndex);
2134         return claimedWord & mask == mask;
2135     }
2136 
2137     // -- OWNER METHODS --
2138 
2139     // Reveal the wieners
2140     function theGreatReveal(uint256 _secretReveal) external onlyOwner onlyMainSale {
2141         if (!mainSaleComplete()) {
2142             revert MainSaleNotComplete();
2143         }
2144 
2145         if (uint256(keccak256(abi.encodePacked(_secretReveal))) != secret) {
2146             revert InvalidReveal();
2147         }
2148 
2149         // Final secret is XOR between the pre-committed secret and the pseudo-random user contributed salt
2150         secret = _secretReveal ^ userSecret;
2151 
2152         // Won't be needing this anymore
2153         delete userSecret;
2154 
2155         stage = Stage.STAGE_COMPLETE;
2156     }
2157 
2158     // Start main sale
2159     function startMainSale() external onlyOwner onlyPreSale {
2160         stage = Stage.STAGE_MAIN_SALE;
2161         saleEnds = block.timestamp + saleLength;
2162     }
2163 
2164     // Withdraw sale proceeds
2165     function withdraw() external onlyOwner {
2166         // Owner can't reneg on bounty
2167         if (arenaActive()) {
2168             revert ArenaIsActive();
2169         }
2170         // Can only withdraw once, and only a fixed percentage
2171         if (!balanceNotWithdrawn) {
2172             revert BalanceAlreadyWithdrawn();
2173         }
2174         balanceNotWithdrawn = false;
2175         owner().call{value : address(this).balance * 3058 / 10000}("");
2176     }
2177 
2178     // -- USER METHODS --
2179 
2180     function claim(uint256 _index, uint256 _ogAmount, uint256 _wlAmount, bytes32[] calldata _merkleProof, uint256 _amount) external payable onlyPreSale {
2181         // Ensure not already claimed
2182         if (isClaimed(_index)) {
2183             revert AlreadyClaimed();
2184         }
2185 
2186         // Prevent accidental claim of 0
2187         if (_amount == 0) {
2188             revert InvalidClaimAmount();
2189         }
2190 
2191         // Check claim amount
2192         uint256 total = _ogAmount + _wlAmount;
2193         if (_amount > total) {
2194             revert InvalidClaimAmount();
2195         }
2196 
2197         // Check claim value
2198         uint256 paidClaims = 0;
2199         if (_amount > _ogAmount) {
2200             paidClaims = _amount - _ogAmount;
2201         }
2202         if (msg.value < paidClaims * salePrice) {
2203             revert InvalidClaimValue();
2204         }
2205 
2206         // Verify the merkle proof
2207         bytes32 node = keccak256(abi.encodePacked(_index, msg.sender, _ogAmount, _wlAmount));
2208         if (!MerkleProof.verify(_merkleProof, merkleRoot, node)) {
2209             revert InvalidProof();
2210         }
2211 
2212         // Mark it claimed and mint
2213         _setClaimed(_index);
2214 
2215         for (uint256 i = 0; i < _amount; i++) {
2216             _createPhallus();
2217         }
2218 
2219         _mix();
2220     }
2221 
2222     // Mint wieners
2223     function createPhallus() external payable onlyMainSaleOpen {
2224         uint256 count = msg.value / salePrice;
2225 
2226         if (count == 0) {
2227             revert InvalidMintValue();
2228         } else if (count > 20) {
2229             count = 20;
2230         }
2231 
2232         // Mint 'em
2233         for (uint256 i = 0; i < count;) {
2234             _createPhallus();
2235             unchecked{ i++; }
2236         }
2237 
2238         _mix();
2239 
2240         // Send any excess ETH back to the caller
2241         uint256 excess = msg.value - (salePrice * count);
2242         if (excess > 0) {
2243             (bool success,) = msg.sender.call{value : excess}("");
2244             require(success);
2245         }
2246     }
2247 
2248     // -- INTERNAL METHODS --
2249 
2250     function _setClaimed(uint256 index) internal {
2251         uint256 claimedWordIndex = index / 256;
2252         uint256 claimedBitIndex = index % 256;
2253         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
2254     }
2255 
2256     function _createPhallus() internal {
2257         uint256 tokenId = totalSupply();
2258         _mint(msg.sender, tokenId);
2259     }
2260 
2261     function _mix() internal {
2262         // Add some pseudorandom value which will be mixed with the pre-committed secret
2263         unchecked {
2264             userSecret += uint256(blockhash(block.number - 1));
2265         }
2266     }
2267 
2268     /*************************
2269      NFT
2270      *************************/
2271 
2272     modifier onlyTokenExists(uint256 _id) {
2273         if (!_exists(_id)) {
2274             revert NonExistentToken();
2275         }
2276         _;
2277     }
2278 
2279     ChainPhallusRenderer public renderer;
2280 
2281     // -- VIEW METHODS --
2282 
2283     function assemblePhallus(uint256 _id) external view onlyTokenExists(_id) returns (string memory) {
2284         return renderer.assemblePhallus(stage == Stage.STAGE_COMPLETE, _id, getFinalizedSeed(_id));
2285     }
2286 
2287     function tokenURI(uint256 _id) public view override onlyTokenExists(_id) returns (string memory) {
2288         return renderer.renderMetadata(stage == Stage.STAGE_COMPLETE, _id, getFinalizedSeed(_id), roundsSurvived[_id], ownerOf(_id));
2289     }
2290 
2291     function renderSvg(uint256 _id) external view onlyTokenExists(_id) returns (string memory) {
2292         uint256 rounds;
2293 
2294         // If wiener is still in the arena, show them with correct amount of scars
2295         if (ownerOf(_id) == address(this)) {
2296             rounds = currentRound;
2297         } else {
2298             rounds = roundsSurvived[_id];
2299         }
2300 
2301         return renderer.renderSvg(stage == Stage.STAGE_COMPLETE, _id, getFinalizedSeed(_id), rounds, ownerOf(_id));
2302     }
2303 
2304     // -- INTERNAL METHODS --
2305 
2306     function getFinalizedSeed(uint256 _tokenId) internal view returns (uint256) {
2307         return uint256(keccak256(abi.encodePacked(secret, _tokenId)));
2308     }
2309 
2310     /*************************
2311      ARENA
2312      *************************/
2313 
2314     uint256     arenaOpenedBlock;
2315     uint256     wienersLastBust;
2316     uint256     champion;
2317 
2318     uint256 public currentRound = 0;
2319     uint256 public bustedNut = 0;
2320     uint256 public pulledOut = 0;
2321     uint256 public swingin = 0;
2322 
2323     uint256 public constant arenaWaitBlocks = 12600;
2324     uint256 public constant blocksPerRound = 42;
2325 
2326     mapping(uint256 => address) public wienerDepositor;
2327     mapping(uint256 => uint256) public roundsSurvived;
2328 
2329     // -- MODIFIERS --
2330 
2331     modifier onlyOpenArena() {
2332         if (!entryOpen()) {
2333             revert ArenaEntryClosed();
2334         }
2335         _;
2336     }
2337 
2338     // -- VIEW METHODS --
2339 
2340     struct ArenaInfo {
2341         uint256 busted;
2342         uint256 swingin;
2343         uint256 pulledOut;
2344         uint256 currentRound;
2345         uint256 bounty;
2346         uint256 hardness;
2347         uint256 nextBust;
2348         uint256 champion;
2349         uint256 entryClosedBlock;
2350         bool horny;
2351         bool open;
2352         bool active;
2353         bool gameOver;
2354     }
2355 
2356     function arenaInfo() external view returns (ArenaInfo memory info) {
2357         info.busted = bustedNut;
2358         info.swingin = swingin;
2359         info.pulledOut = pulledOut;
2360         info.currentRound = currentRound;
2361         info.bounty = address(this).balance;
2362         info.hardness = howHornyAreTheWieners();
2363         info.champion = champion;
2364         info.entryClosedBlock = entryClosedBlock();
2365 
2366         if (!theWienersAreFluffy()) {
2367             info.nextBust = wienersLastBust + blocksPerRound - block.number;
2368         }
2369 
2370         info.horny = theWienersAreFluffy();
2371         info.open = entryOpen();
2372         info.active = arenaActive();
2373         info.gameOver = block.number > info.entryClosedBlock && info.swingin <= 1;
2374     }
2375 
2376     // Return array of msg.senders remaining wieners
2377     function myWieners() external view returns (uint256[] memory) {
2378         return ownerWieners(msg.sender);
2379     }
2380 
2381     // Return array of owner's remaining wieners
2382     function ownerWieners(address _owner) public view returns (uint256[] memory) {
2383         address holdingAddress;
2384         holdingAddress = address(this);
2385 
2386         uint256 total = balanceOf(holdingAddress);
2387         uint256[] memory wieners = new uint256[](total);
2388 
2389         uint256 index = 0;
2390 
2391         for (uint256 i = 0; i < total; i++) {
2392             uint256 id = tokenOfOwnerByIndex(holdingAddress, i);
2393 
2394             if (wienerDepositor[id] == _owner) {
2395                 wieners[index++] = id;
2396             }
2397         }
2398 
2399         assembly {
2400             mstore(wieners, index)
2401         }
2402 
2403         return wieners;
2404     }
2405 
2406     function arenaActive() public view returns (bool) {
2407         return arenaOpenedBlock > 0;
2408     }
2409 
2410     function entryOpen() public view returns (bool) {
2411         return arenaActive() && block.number < entryClosedBlock();
2412     }
2413 
2414     function entryClosedBlock() public view returns (uint256) {
2415         return arenaOpenedBlock + arenaWaitBlocks;
2416     }
2417 
2418     function howHornyAreTheWieners() public view returns (uint256) {
2419 
2420         if (swingin == 0) {
2421             return 0;
2422         }
2423 
2424         uint256 hardness = 1;
2425 
2426         // Calculate how many wieners busted (0.2% of wieners > 1000)
2427         if (swingin >= 2000) {
2428             uint256 excess = swingin - 1000;
2429             hardness = excess / 500;
2430         }
2431 
2432         // The last wiener standing never busts
2433         if (hardness >= swingin) {
2434             hardness = swingin - 1;
2435         }
2436 
2437         // Generous upper bound to prevent gas overflow
2438         if (hardness > 50) {
2439             hardness = 50;
2440         }
2441 
2442         return hardness;
2443     }
2444 
2445     function theWienersAreFluffy() public view returns (bool) {
2446         return block.number >= wienersLastBust + blocksPerRound;
2447     }
2448 
2449     // -- OWNER METHODS --
2450 
2451     function openArena() external payable onlyOwner onlySaleComplete {
2452         if (arenaActive()) {
2453             revert ArenaIsActive();
2454         }
2455         if (balanceNotWithdrawn) {
2456             revert BalanceNotWithdrawn();
2457         }
2458 
2459         // Open the arena
2460         arenaOpenedBlock = block.number;
2461         wienersLastBust = block.number + arenaWaitBlocks;
2462     }
2463 
2464     // -- USER METHODS --
2465 
2466     // Can be called every `blocksPerRound` blocks to kill off some eager wieners
2467     function timeToBust() external {
2468         if (!arenaActive()) {
2469             revert ArenaNotActive();
2470         }
2471         if (!theWienersAreFluffy()) {
2472             revert WienersNotFluffy();
2473         }
2474 
2475         if (swingin == 1) {
2476             revert LastErectWiener();
2477         }
2478         if (swingin == 0) {
2479             revert GameOver();
2480         }
2481 
2482         // The blockhash of every `blocksPerRound` block is used to determine who busts
2483         uint256 entropyBlock;
2484         if (block.number - (wienersLastBust + blocksPerRound) > 255) {
2485             // If this method isn't called within 255 blocks of the period end, this is a fallback so we can still progress
2486             entropyBlock = (block.number / blocksPerRound) * blocksPerRound - 1;
2487         } else {
2488             // Use blockhash of every 42nd block
2489             entropyBlock = (wienersLastBust + blocksPerRound) - 1;
2490         }
2491         uint256 entropy = uint256(blockhash(entropyBlock));
2492         assert(entropy != 0);
2493 
2494         // Update state
2495         wienersLastBust = block.number;
2496         currentRound++;
2497 
2498         // Kill off a percentage of wieners
2499         uint256 killCounter = howHornyAreTheWieners();
2500         bytes memory buffer = new bytes(32);
2501         // i starts at 1 to prevent infinite loop
2502         for (uint256 i = 1; i <= killCounter;) {
2503             // Entropy must increase even if the kill doesn't count
2504             unchecked { entropy = entropy + i; }
2505             // Gas saving trick to avoid abi.encodePacked
2506             assembly { mstore(add(buffer, 32), entropy) }
2507             // Balance of contract in case tokens were transferred without joining
2508             uint256 whoDied = uint256(keccak256(buffer)) % balanceOf(address(this));
2509             // Go to your happy place, loser
2510             uint256 wienerToBust = tokenOfOwnerByIndex(address(this), whoDied);
2511             _burn(wienerToBust);
2512             // Check to ensure that busted wiener was participating in the arena
2513             if (wienerDepositor[wienerToBust] == address(0)) {
2514                 // If not participating, kill doesn't count
2515                 unchecked{ --i; }
2516             }
2517             else {
2518                 // If participating, update counts
2519                 // Clear state
2520                 delete wienerDepositor[wienerToBust];
2521                 bustedNut++;
2522                 swingin--;
2523             }
2524             unchecked{ i++; }
2525         }
2526 
2527         // Record the champion
2528         if (swingin == 1) {
2529             // Check all tokens in contract until champion is found
2530             uint256 wienerToCheck;
2531             for (uint256 i = 0; i < balanceOf(address(this));) {
2532                 wienerToCheck = tokenOfOwnerByIndex(address(this), i);
2533                 if (wienerDepositor[wienerToCheck] != address(0)) {
2534                     // If token was participating in arena it must the the champion
2535                     champion = wienerToCheck;
2536                     break;
2537                 }
2538                 unchecked{ i++; }
2539             }
2540             // Record the champion's achievement
2541             roundsSurvived[champion] = currentRound;
2542             // Set status
2543             renderer.setWienerOfWienersStatus(champion);
2544             // Pay the champion's owner and return wiener
2545             payable(wienerDepositor[champion]).transfer(address(this).balance);
2546             _transfer(address(this), wienerDepositor[champion], champion);
2547         }
2548     }
2549 
2550     function joinArena(uint256 _tokenId) external onlyOpenArena {
2551         _joinArena(_tokenId);
2552     }
2553 
2554     function multiJoinArena(uint256[] memory _tokenIds) external onlyOpenArena {
2555         if (_tokenIds.length > 20) {
2556             revert InvalidJoinCount();
2557         }
2558 
2559         for (uint256 i; i < _tokenIds.length;) {
2560             _joinArena(_tokenIds[i]);
2561             unchecked{ i++; }
2562         }
2563     }
2564 
2565     function claimBounty(uint256 _tokenId) external {
2566         if (wienerDepositor[_tokenId] != msg.sender) {
2567             revert NotYourWiener();
2568         }
2569 
2570         // Can't leave arena if wieners are horny (unless it's the champ and the game is over)
2571         if (swingin != 1 && theWienersAreFluffy()) {
2572             revert WienersAreFluffy();
2573         }
2574 
2575         // Can't leave before a single round has passed
2576         uint256 round = currentRound;
2577         if (currentRound == 0) {
2578             revert LeavingProhibited();
2579         }
2580 
2581         // Record the wiener's achievement
2582         roundsSurvived[_tokenId] = round;
2583 
2584         // Clear state
2585         delete wienerDepositor[_tokenId];
2586 
2587         // Must burn NFT to claim bounty
2588         uint256 battleBounty = address(this).balance / swingin;
2589         _burn(_tokenId);
2590         bustedNut++;
2591         swingin--;
2592         payable(msg.sender).transfer(battleBounty);
2593 
2594         // If this was the second last wiener to leave, the last one left is the champ
2595         if (swingin == 1) {
2596             // Check all tokens in contract until champion is found
2597             uint256 wienerToCheck;
2598             for (uint256 i = 0; i < balanceOf(address(this));) {
2599                 wienerToCheck = tokenOfOwnerByIndex(address(this), i);
2600                 if (wienerDepositor[wienerToCheck] != address(0)) {
2601                     // If token was participating in arena it must the the champion
2602                     champion = wienerToCheck;
2603                     break;
2604                 }
2605                 unchecked{ i++; }
2606             }
2607             // Record the champion's achievement
2608             roundsSurvived[champion] = round;
2609             // Set status
2610             renderer.setWienerOfWienersStatus(champion);
2611             // Pay the champion's owner and return wiener
2612             payable(wienerDepositor[champion]).transfer(address(this).balance);
2613             _transfer(address(this), wienerDepositor[champion], champion);
2614         }
2615     }
2616 
2617     function leaveArena(uint256 _tokenId) external {
2618         if (wienerDepositor[_tokenId] != msg.sender) {
2619             revert NotYourWiener();
2620         }
2621 
2622         // Can't leave arena if wieners are horny (unless it's the champ and the game is over)
2623         if (swingin != 1 && theWienersAreFluffy()) {
2624             revert WienersAreFluffy();
2625         }
2626 
2627         // Can't leave before a single round has passed
2628         uint256 round = currentRound;
2629         if (currentRound == 0) {
2630             revert LeavingProhibited();
2631         }
2632 
2633         // Record the wiener's achievement
2634         roundsSurvived[_tokenId] = round;
2635 
2636         // Set status
2637         renderer.setPulledOutStatus(_tokenId);
2638         // Clear state
2639         delete wienerDepositor[_tokenId];
2640 
2641         // Return wiener
2642          _transfer(address(this), msg.sender, _tokenId);
2643         pulledOut++;
2644         swingin--;
2645 
2646         // If this was the second last wiener to leave, the last one left is the champ
2647         if (swingin == 1) {
2648             // Check all tokens in contract until champion is found
2649             uint256 wienerToCheck;
2650             for (uint256 i = 0; i < balanceOf(address(this));) {
2651                 wienerToCheck = tokenOfOwnerByIndex(address(this), i);
2652                 if (wienerDepositor[wienerToCheck] != address(0)) {
2653                     // If token was participating in arena it must the the champion
2654                     champion = wienerToCheck;
2655                     break;
2656                 }
2657                 unchecked{ i++; }
2658             }
2659             // Record the champion's achievement
2660             roundsSurvived[champion] = round;
2661             // Set status
2662             renderer.setWienerOfWienersStatus(champion);
2663             // Pay the champion's owner and return wiener
2664             payable(wienerDepositor[champion]).transfer(address(this).balance);
2665             _transfer(address(this), wienerDepositor[champion], champion);
2666         }
2667     }
2668     // -- INTERNAL METHODS --
2669 
2670     function _joinArena(uint256 _tokenId) internal {
2671         // Send wiener to the arena
2672         transferFrom(msg.sender, address(this), _tokenId);
2673         wienerDepositor[_tokenId] = msg.sender;
2674         swingin++;
2675     }
2676 
2677     /*************************
2678      MISC
2679      *************************/
2680 
2681     function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
2682         return this.onERC721Received.selector;
2683     }
2684 
2685     function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId) internal override(ERC721, ERC721Enumerable) {
2686         super._beforeTokenTransfer(_from, _to, _tokenId);
2687     }
2688 
2689     function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
2690         return super.supportsInterface(_interfaceId);
2691     }
2692 }