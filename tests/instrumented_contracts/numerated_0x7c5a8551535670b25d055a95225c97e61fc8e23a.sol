1 // By interacting with this contract, you agree to our terms and conditions. Please check our website for the latest version.
2 
3 // SPDX-License-Identifier: UNLICENSED
4 /*  ______    ___    ______    ______   _____          ____     ______           ____     ______    __ __  ______
5    / ____/   /   |  / ____/   / ____/  / ___/         / __ \   / ____/          / __ \   / ____/   / //_/ /_  __/
6   / /_      / /| | / /       / __/     \__ \         / / / /  / /_             / /_/ /  / __/     / ,<     / /
7  / __/     / ___ |/ /___    / /___    ___/ /        / /_/ /  / __/            / _, _/  / /___    / /| |   / /
8 /_/       /_/  |_|\____/   /_____/   /____/         \____/  /_/              /_/ |_|  /_____/   /_/ |_|  /_/
9                                                                                                                  */
10 
11 /*
12 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
13 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
14 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
15 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
16 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
17 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
18 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OOOOOOOOO,,,,,,,,,,,,O,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
19 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OOOOOOOOOOOOO,,,,,,,,,,,,OOOO,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
20 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,°OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
21 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OOOOOIFOOOOROOOOOOOOOOELSEOOOOOOOOOOOOOOOO,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
22 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OOOOOOOOOOOOOOOOOOOOOOE###OOOOOOWHILEOOOOOOOOOO,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
23 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OOOOOOOOOOOOOOO#####OOOOOOOOOOOOOO##OOOOOOOOOOOOOOOOO°],,,,,,,,,,,,,,,,,,,,,,,,,,,,,
24 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OOOOOFOROOOOOOOOOOOOOOOOOOOOOEE#OOOOO]°°]OOOOOOOOOOOO,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
25 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OOOOOOOOOOOOOOO]°.....°(OOOOOOOOO.°...........,O,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
26 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O]°O.........°OOOOOOO].............]OOOOO°..O,,,,,,,,,,,,,°°°,,,,,,,,,,,,,,,,,,,,
27 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O...........OO°........°..........°.....°OO.O,,,,,,,,°°°°°°°°°°°,,,,,,,,,,,,,,,,,
28 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O..............OOO}}°..............OO°}},...O,,,,,,,,,}}°°}}]°}}],,,,,,,,,,,,,,,,
29 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O....E........OOOOOO}}............COODE}}]..O,,,,,,,,,}}}}]°°°°°°°°,,,,,,,,,,,,,,
30 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O.............,COOODE]............,COODE}}.°O,,,,,,,,,,}}°}}°°°°°°°°,,,,,,,,,,,,,
31 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O....°,........COOODE].............COODE}}.O,,,,,,,,,,,,,}}]°°°°°°°°,,,,,,,,,,,,,
32 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O.....O........COOODE].............COODE]°.O,,,,,,,,,,,,]°]°°°°°°°°,,,,,,,,,,,,,,
33 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O°,,,,O,...........COOODE].............COODE}}.O,,,,,,,,,,,}}°°°°}}],,,,,,,,,,,,,,,,,
34 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O,..}}].............COOODE].............COODE}}.O,,,,,,,,,,,,]°],,,,,,,,,,,,,,,,,,,,,,
35 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O..°°}}.............COOODE].............COODE}}.O,,,,,,,,,,,]°°,,,,,,,,,,,,,,,,,,,,,,,
36 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O..°°°°°............COOODE].............COODE]°..O,,,,,,,,,,}}°°°°°°°°,,,,,,,,,,,,,,,,
37 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O....°°°...........COOOODE]............COODE}}..O,,,,,,,,,,,}}]°°°°°°°,,,,,,,,,,,,,,,
38 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OO...O...........COOODE}}.°.°......O.COODE}}].°O,,,,,,,,,,,,°]°°°°°°°,,,,,,,,,,,,,,,
39 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O.................°°....°OOOOO°......°°°..O,,,,,,°]°°°°]°°°°°°,,,,,,,,,,,,,,,,,
40 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O.......................................°O,,,,,],,}}}}°,,,,,,,,,,,,,,,,,,,,,,,
41 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O.................    OOO.  .OOOOOO°....O,,O°°°°°°°°°O,,,,,,,,,,,,,,,,,,,,,,,,
42 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O°...........,   ,° ,°,,,°°OOOOOE}}}}COOODE#COOOOODE##O,,,,,,,,,,,,,,,,,,,,,,,
43 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O°.......°..OOOOE...................COOODE°°°°°°°°###O,,,,,,,,,,,,,,,,,,,,,,,
44 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O°°.....°O°....................°O,,,,,,O#°°°°°°°###O,,,,,,,,,,,,,,,,,,,,,,,
45 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O°°°°°°°°°°°°O,,,,,,,,,,,,,,,,,COOOODE,,,,,,,,,,,,,,,,,,,,,,,,,,
46 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,O°°°°°°°°°°°°O,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
47 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OO#O]°°..°...]..°OO,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
48 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OE###OOOO.......°...OO#EO,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
49 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OOO##O####O    °OO.....OO.O###E°,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
50 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OOO############O######O        O.    O####O######OOO,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
51 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,OE###############OO########O    #OO###EOO O###OOO###########EE°,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
52 ,,,,,,,,,,,,,,,,,,,,,,,,,,O###################O#########OOO.  O####O  O#####O##############O,,,,,,,,,,,,,,,,,,,,,,,,,,,,
53 ,,,,,,,,,,,,,,,,,,,,,,,,,O#####################O#########O    O####O   O####O###############O,,,,,,,,,,,,,,,,,,,,,,,,,,,
54 ,,,,,,,,,,,,,,,,,,,,,,,,,O###############################O#E.#######O OO#####################O,,,,,,,,,,,,,,,,,,,,,,,,,,
55 ,,,,,,,,,,,,,,,,,,,,,,,,O################################O##########OO#O#####################O,,,,,,,,,,,,,,,,,,,,,,,,,,
56 ,,,,,,,,,,,,,,,,,,,,,,,,O#################################O#####OOOO####O#####################O,,,,,,,,,,,,,,,,,,,,,,,,,
57 ,,,,,,,,,,,,,,,,,,,,,,,,O#################################O#######O#####O#####################O,,,,,,,,,,,,,,,,,,,,,,,,,
58 ,,,,,,,,,,,,,,,,,,,,,,,O##################################O#(#####O#####O#####################O,,,,,,,,,,,,,,,,,,,,,,,,,
59 ,,,,,,,,,,,,,,,,,,,,,,,O################O#################O((##,##O#####O#############O########O,,,,,,,,,,,,,,,,,,,,,,,,
60  */
61 
62 
63 pragma solidity ^0.8.0;
64 
65 abstract contract ReentrancyGuard {
66 
67     uint256 private constant _NOT_ENTERED = 1;
68     uint256 private constant _ENTERED = 2;
69 
70     uint256 private _status;
71 
72     constructor() {
73         _status = _NOT_ENTERED;
74     }
75 
76     modifier nonReentrant() {
77 
78         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
79 
80         _status = _ENTERED;
81 
82         _;
83 
84         _status = _NOT_ENTERED;
85     }
86 }
87 
88 
89 pragma solidity ^0.8.0;
90 
91 library MerkleProof {
92 
93     function verify(
94         bytes32[] memory proof,
95         bytes32 root,
96         bytes32 leaf
97     ) internal pure returns (bool) {
98         return processProof(proof, leaf) == root;
99     }
100     function verifyCalldata(
101         bytes32[] calldata proof,
102         bytes32 root,
103         bytes32 leaf
104     ) internal pure returns (bool) {
105         return processProofCalldata(proof, leaf) == root;
106     }
107     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
108         bytes32 computedHash = leaf;
109         for (uint256 i = 0; i < proof.length; i++) {
110             computedHash = _hashPair(computedHash, proof[i]);
111         }
112         return computedHash;
113     }
114     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
115         bytes32 computedHash = leaf;
116         for (uint256 i = 0; i < proof.length; i++) {
117             computedHash = _hashPair(computedHash, proof[i]);
118         }
119         return computedHash;
120     }
121     function multiProofVerify(
122         bytes32[] memory proof,
123         bool[] memory proofFlags,
124         bytes32 root,
125         bytes32[] memory leaves
126     ) internal pure returns (bool) {
127         return processMultiProof(proof, proofFlags, leaves) == root;
128     }
129     function multiProofVerifyCalldata(
130         bytes32[] calldata proof,
131         bool[] calldata proofFlags,
132         bytes32 root,
133         bytes32[] memory leaves
134     ) internal pure returns (bool) {
135         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
136     }
137     function processMultiProof(
138         bytes32[] memory proof,
139         bool[] memory proofFlags,
140         bytes32[] memory leaves
141     ) internal pure returns (bytes32 merkleRoot) {
142 
143         uint256 leavesLen = leaves.length;
144         uint256 totalHashes = proofFlags.length;
145 
146         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
147 
148         bytes32[] memory hashes = new bytes32[](totalHashes);
149         uint256 leafPos = 0;
150         uint256 hashPos = 0;
151         uint256 proofPos = 0;
152 
153         for (uint256 i = 0; i < totalHashes; i++) {
154             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
155             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
156             hashes[i] = _hashPair(a, b);
157         }
158 
159         if (totalHashes > 0) {
160             return hashes[totalHashes - 1];
161         } else if (leavesLen > 0) {
162             return leaves[0];
163         } else {
164             return proof[0];
165         }
166     }
167 
168     function processMultiProofCalldata(
169         bytes32[] calldata proof,
170         bool[] calldata proofFlags,
171         bytes32[] memory leaves
172     ) internal pure returns (bytes32 merkleRoot) {
173 
174         uint256 leavesLen = leaves.length;
175         uint256 totalHashes = proofFlags.length;
176 
177 
178         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
179 
180         bytes32[] memory hashes = new bytes32[](totalHashes);
181         uint256 leafPos = 0;
182         uint256 hashPos = 0;
183         uint256 proofPos = 0;
184 
185         for (uint256 i = 0; i < totalHashes; i++) {
186             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
187             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
188             hashes[i] = _hashPair(a, b);
189         }
190 
191         if (totalHashes > 0) {
192             return hashes[totalHashes - 1];
193         } else if (leavesLen > 0) {
194             return leaves[0];
195         } else {
196             return proof[0];
197         }
198     }
199 
200     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
201         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
202     }
203 
204     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
205 
206         assembly {
207             mstore(0x00, a)
208             mstore(0x20, b)
209             value := keccak256(0x00, 0x40)
210         }
211     }
212 }
213 
214 pragma solidity ^0.8.0;
215 library Strings {
216     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
217 
218     function toString(uint256 value) internal pure returns (string memory) {
219 
220         if (value == 0) {
221             return "0";
222         }
223         uint256 temp = value;
224         uint256 digits;
225         while (temp != 0) {
226             digits++;
227             temp /= 10;
228         }
229         bytes memory buffer = new bytes(digits);
230         while (value != 0) {
231             digits -= 1;
232             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
233             value /= 10;
234         }
235         return string(buffer);
236     }
237 
238     function toHexString(uint256 value) internal pure returns (string memory) {
239         if (value == 0) {
240             return "0x00";
241         }
242         uint256 temp = value;
243         uint256 length = 0;
244         while (temp != 0) {
245             length++;
246             temp >>= 8;
247         }
248         return toHexString(value, length);
249     }
250 
251     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
252         bytes memory buffer = new bytes(2 * length + 2);
253         buffer[0] = "0";
254         buffer[1] = "x";
255         for (uint256 i = 2 * length + 1; i > 1; --i) {
256             buffer[i] = _HEX_SYMBOLS[value & 0xf];
257             value >>= 4;
258         }
259         require(value == 0, "Strings: hex length insufficient");
260         return string(buffer);
261     }
262 }
263 
264 pragma solidity ^0.8.0;
265 
266 library ECDSA {
267     enum RecoverError {
268         NoError,
269         InvalidSignature,
270         InvalidSignatureLength,
271         InvalidSignatureS,
272         InvalidSignatureV
273     }
274 
275     function _throwError(RecoverError error) private pure {
276         if (error == RecoverError.NoError) {
277             return; // no error: do nothing
278         } else if (error == RecoverError.InvalidSignature) {
279             revert("ECDSA: invalid signature");
280         } else if (error == RecoverError.InvalidSignatureLength) {
281             revert("ECDSA: invalid signature length");
282         } else if (error == RecoverError.InvalidSignatureS) {
283             revert("ECDSA: invalid signature 's' value");
284         } else if (error == RecoverError.InvalidSignatureV) {
285             revert("ECDSA: invalid signature 'v' value");
286         }
287     }
288 
289     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
290         if (signature.length == 65) {
291             bytes32 r;
292             bytes32 s;
293             uint8 v;
294             assembly {
295                 r := mload(add(signature, 0x20))
296                 s := mload(add(signature, 0x40))
297                 v := byte(0, mload(add(signature, 0x60)))
298             }
299             return tryRecover(hash, v, r, s);
300         } else if (signature.length == 64) {
301             bytes32 r;
302             bytes32 vs;
303             assembly {
304                 r := mload(add(signature, 0x20))
305                 vs := mload(add(signature, 0x40))
306             }
307             return tryRecover(hash, r, vs);
308         } else {
309             return (address(0), RecoverError.InvalidSignatureLength);
310         }
311     }
312 
313     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
314         (address recovered, RecoverError error) = tryRecover(hash, signature);
315         _throwError(error);
316         return recovered;
317     }
318 
319     function tryRecover(
320         bytes32 hash,
321         bytes32 r,
322         bytes32 vs
323     ) internal pure returns (address, RecoverError) {
324         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
325         uint8 v = uint8((uint256(vs) >> 255) + 27);
326         return tryRecover(hash, v, r, s);
327     }
328 
329     function recover(
330         bytes32 hash,
331         bytes32 r,
332         bytes32 vs
333     ) internal pure returns (address) {
334         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
335         _throwError(error);
336         return recovered;
337     }
338 
339     function tryRecover(
340         bytes32 hash,
341         uint8 v,
342         bytes32 r,
343         bytes32 s
344     ) internal pure returns (address, RecoverError) {
345         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
346             return (address(0), RecoverError.InvalidSignatureS);
347         }
348         if (v != 27 && v != 28) {
349             return (address(0), RecoverError.InvalidSignatureV);
350         }
351 
352         // If the signature is valid (and not malleable), return the signer address
353         address signer = ecrecover(hash, v, r, s);
354         if (signer == address(0)) {
355             return (address(0), RecoverError.InvalidSignature);
356         }
357 
358         return (signer, RecoverError.NoError);
359     }
360 
361     function recover(
362         bytes32 hash,
363         uint8 v,
364         bytes32 r,
365         bytes32 s
366     ) internal pure returns (address) {
367         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
368         _throwError(error);
369         return recovered;
370     }
371 
372     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
373 
374         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
375     }
376 
377     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
378         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
379     }
380 
381     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
382         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
383     }
384 }
385 
386 pragma solidity ^0.8.0;
387 
388 abstract contract Context {
389     function _msgSender() internal view virtual returns (address) {
390         return msg.sender;
391     }
392 
393     function _msgData() internal view virtual returns (bytes calldata) {
394         return msg.data;
395     }
396 }
397 
398 pragma solidity ^0.8.0;
399 
400 abstract contract Ownable is Context {
401     address private _owner;
402 
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404     constructor() {
405         _transferOwnership(_msgSender());
406     }
407 
408     function owner() public view virtual returns (address) {
409         return _owner;
410     }
411 
412     modifier onlyOwner() {
413         require(owner() == _msgSender(), "Ownable: caller is not the owner");
414         _;
415     }
416 
417     function renounceOwnership() public virtual onlyOwner {
418         _transferOwnership(address(0));
419     }
420 
421     function transferOwnership(address newOwner) public virtual onlyOwner {
422         require(newOwner != address(0), "Ownable: new owner is the zero address");
423         _transferOwnership(newOwner);
424     }
425 
426     function _transferOwnership(address newOwner) internal virtual {
427         address oldOwner = _owner;
428         _owner = newOwner;
429         emit OwnershipTransferred(oldOwner, newOwner);
430     }
431 }
432 
433 pragma solidity ^0.8.1;
434 
435 library Address {
436 
437     function isContract(address account) internal view returns (bool) {
438 
439         return account.code.length > 0;
440     }
441 
442 
443     function sendValue(address payable recipient, uint256 amount) internal {
444         require(address(this).balance >= amount, "Address: insufficient balance");
445 
446         (bool success, ) = recipient.call{value: amount}("");
447         require(success, "Address: unable to send value, recipient may have reverted");
448     }
449 
450     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
451         return functionCall(target, data, "Address: low-level call failed");
452     }
453 
454     function functionCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         return functionCallWithValue(target, data, 0, errorMessage);
460     }
461 
462     function functionCallWithValue(
463         address target,
464         bytes memory data,
465         uint256 value
466     ) internal returns (bytes memory) {
467         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
468     }
469 
470     function functionCallWithValue(
471         address target,
472         bytes memory data,
473         uint256 value,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         require(address(this).balance >= value, "Address: insufficient balance for call");
477         require(isContract(target), "Address: call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.call{value: value}(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
484         return functionStaticCall(target, data, "Address: low-level static call failed");
485     }
486 
487     function functionStaticCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal view returns (bytes memory) {
492         require(isContract(target), "Address: static call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.staticcall(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
500     }
501 
502     function functionDelegateCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         require(isContract(target), "Address: delegate call to non-contract");
508 
509         (bool success, bytes memory returndata) = target.delegatecall(data);
510         return verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     function verifyCallResult(
514         bool success,
515         bytes memory returndata,
516         string memory errorMessage
517     ) internal pure returns (bytes memory) {
518         if (success) {
519             return returndata;
520         } else {
521             if (returndata.length > 0) {
522 
523                 assembly {
524                     let returndata_size := mload(returndata)
525                     revert(add(32, returndata), returndata_size)
526                 }
527             } else {
528                 revert(errorMessage);
529             }
530         }
531     }
532 }
533 
534 pragma solidity ^0.8.4;
535 
536 interface IERC721A {
537 
538     error ApprovalCallerNotOwnerNorApproved();
539     error ApprovalQueryForNonexistentToken();
540     error ApproveToCaller();
541     error BalanceQueryForZeroAddress();
542     error MintToZeroAddress();
543     error MintZeroQuantity();
544     error OwnerQueryForNonexistentToken();
545     error TransferCallerNotOwnerNorApproved();
546     error TransferFromIncorrectOwner();
547     error TransferToNonERC721ReceiverImplementer();
548     error TransferToZeroAddress();
549     error URIQueryForNonexistentToken();
550     error MintERC2309QuantityExceedsLimit();
551     error OwnershipNotInitializedForExtraData();
552 
553 
554     struct TokenOwnership {
555         address addr;
556         uint64 startTimestamp;
557         bool burned;
558         uint24 extraData;
559     }
560 
561     function totalSupply() external view returns (uint256);
562 
563     function supportsInterface(bytes4 interfaceId) external view returns (bool);
564 
565     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
566 
567     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
568 
569     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
570 
571     function balanceOf(address owner) external view returns (uint256 balance);
572 
573     function ownerOf(uint256 tokenId) external view returns (address owner);
574 
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId,
579         bytes calldata data
580     ) external;
581 
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) external;
587 
588     function transferFrom(
589         address from,
590         address to,
591         uint256 tokenId
592     ) external;
593 
594     function approve(address to, uint256 tokenId) external;
595 
596     function setApprovalForAll(address operator, bool _approved) external;
597 
598     function isApprovedForAll(address owner, address operator) external view returns (bool);
599 
600     function name() external view returns (string memory);
601 
602     function symbol() external view returns (string memory);
603 
604     function tokenURI(uint256 tokenId) external view returns (string memory);
605 
606     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
607 }
608 
609 pragma solidity ^0.8.4;
610 
611 interface ERC721A__IERC721Receiver {
612     function onERC721Received(
613         address operator,
614         address from,
615         uint256 tokenId,
616         bytes calldata data
617     ) external returns (bytes4);
618 }
619 
620 contract ERC721A is IERC721A {
621     struct TokenApprovalRef {
622         address value;
623     }
624 
625 
626     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
627 
628     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
629 
630     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
631 
632     uint256 private constant _BITPOS_AUX = 192;
633 
634     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
635 
636     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
637 
638     uint256 private constant _BITMASK_BURNED = 1 << 224;
639 
640     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
641 
642     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
643 
644     uint256 private constant _BITPOS_EXTRA_DATA = 232;
645 
646     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
647 
648     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
649 
650     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
651 
652     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
653     0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
654 
655 
656     uint256 private _currentIndex;
657 
658     uint256 private _burnCounter;
659 
660     string private _name;
661 
662     string private _symbol;
663 
664     mapping(uint256 => uint256) private _packedOwnerships;
665 
666     mapping(address => uint256) private _packedAddressData;
667 
668     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
669 
670     mapping(address => mapping(address => bool)) private _operatorApprovals;
671 
672 
673     constructor(string memory name_, string memory symbol_) {
674         _name = name_;
675         _symbol = symbol_;
676         _currentIndex = _startTokenId();
677     }
678 
679 
680     function _startTokenId() internal view virtual returns (uint256) {
681         return 0;
682     }
683 
684     function _nextTokenId() internal view virtual returns (uint256) {
685         return _currentIndex;
686     }
687 
688     function totalSupply() public view virtual override returns (uint256) {
689     unchecked {
690         return _currentIndex - _burnCounter - _startTokenId();
691     }
692     }
693 
694     function __burn_non_minted_token(uint16 amount) internal virtual {
695         _currentIndex += amount;
696     }
697 
698     function _totalMinted() internal view virtual returns (uint256) {
699     unchecked {
700         return _currentIndex - _startTokenId();
701     }
702     }
703 
704     function _totalBurned() internal view virtual returns (uint256) {
705         return _burnCounter;
706     }
707 
708 
709     function balanceOf(address owner) public view virtual override returns (uint256) {
710         if (owner == address(0)) revert BalanceQueryForZeroAddress();
711         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
712     }
713 
714     function _numberMinted(address owner) internal view returns (uint256) {
715         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
716     }
717 
718     function _numberBurned(address owner) internal view returns (uint256) {
719         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
720     }
721 
722     function _getAux(address owner) internal view returns (uint64) {
723         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
724     }
725 
726     function _setAux(address owner, uint64 aux) internal virtual {
727         uint256 packed = _packedAddressData[owner];
728         uint256 auxCasted;
729         assembly {
730             auxCasted := aux
731         }
732         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
733         _packedAddressData[owner] = packed;
734     }
735 
736 
737     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
738         return
739         interfaceId == 0x01ffc9a7 ||
740         interfaceId == 0x80ac58cd ||
741         interfaceId == 0x5b5e139f;
742     }
743 
744 
745     function name() public view virtual override returns (string memory) {
746         return _name;
747     }
748 
749     function symbol() public view virtual override returns (string memory) {
750         return _symbol;
751     }
752 
753     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
754         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
755 
756         string memory baseURI = _baseURI();
757         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
758     }
759 
760     function _baseURI() internal view virtual returns (string memory) {
761         return '';
762     }
763 
764 
765     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
766         return address(uint160(_packedOwnershipOf(tokenId)));
767     }
768 
769     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
770         return _unpackedOwnership(_packedOwnershipOf(tokenId));
771     }
772 
773     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
774         return _unpackedOwnership(_packedOwnerships[index]);
775     }
776 
777     function _initializeOwnershipAt(uint256 index) internal virtual {
778         if (_packedOwnerships[index] == 0) {
779             _packedOwnerships[index] = _packedOwnershipOf(index);
780         }
781     }
782 
783     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
784         uint256 curr = tokenId;
785 
786     unchecked {
787         if (_startTokenId() <= curr)
788             if (curr < _currentIndex) {
789                 uint256 packed = _packedOwnerships[curr];
790                 if (packed & _BITMASK_BURNED == 0) {
791                     while (packed == 0) {
792                         packed = _packedOwnerships[--curr];
793                     }
794                     return packed;
795                 }
796             }
797     }
798         revert OwnerQueryForNonexistentToken();
799     }
800 
801     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
802         ownership.addr = address(uint160(packed));
803         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
804         ownership.burned = packed & _BITMASK_BURNED != 0;
805         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
806     }
807 
808     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
809         assembly {
810             owner := and(owner, _BITMASK_ADDRESS)
811             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
812         }
813     }
814 
815     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
816         assembly {
817             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
818         }
819     }
820 
821 
822     function approve(address to, uint256 tokenId) public virtual override {
823         address owner = ownerOf(tokenId);
824 
825         if (_msgSenderERC721A() != owner)
826             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
827                 revert ApprovalCallerNotOwnerNorApproved();
828             }
829 
830         _tokenApprovals[tokenId].value = to;
831         emit Approval(owner, to, tokenId);
832     }
833 
834     function getApproved(uint256 tokenId) public view virtual returns (address) {
835         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
836 
837         return _tokenApprovals[tokenId].value;
838     }
839 
840     function setApprovalForAll(address operator, bool approved) public virtual override {
841         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
842 
843         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
844         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
845     }
846 
847     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
848         return _operatorApprovals[owner][operator];
849     }
850 
851     function _exists(uint256 tokenId) internal view virtual returns (bool) {
852         return
853         _startTokenId() <= tokenId &&
854         tokenId < _currentIndex &&
855         _packedOwnerships[tokenId] & _BITMASK_BURNED == 0;
856     }
857 
858     function _isSenderApprovedOrOwner(
859         address approvedAddress,
860         address owner,
861         address msgSender
862     ) private pure returns (bool result) {
863         assembly {
864             owner := and(owner, _BITMASK_ADDRESS)
865             msgSender := and(msgSender, _BITMASK_ADDRESS)
866             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
867         }
868     }
869 
870     function _getApprovedSlotAndAddress(uint256 tokenId)
871     private
872     view
873     returns (uint256 approvedAddressSlot, address approvedAddress)
874     {
875         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
876         assembly {
877             approvedAddressSlot := tokenApproval.slot
878             approvedAddress := sload(approvedAddressSlot)
879         }
880     }
881 
882 
883     function transferFrom(
884         address from,
885         address to,
886         uint256 tokenId
887     ) public virtual override {
888         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
889 
890         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
891 
892         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
893 
894         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
895             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
896 
897         if (to == address(0)) revert TransferToZeroAddress();
898 
899         _beforeTokenTransfers(from, to, tokenId, 1);
900 
901         assembly {
902             if approvedAddress {
903                 sstore(approvedAddressSlot, 0)
904             }
905         }
906 
907     unchecked {
908         --_packedAddressData[from];
909         ++_packedAddressData[to];
910 
911         _packedOwnerships[tokenId] = _packOwnershipData(
912             to,
913             _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
914         );
915 
916         if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
917             uint256 nextTokenId = tokenId + 1;
918             if (_packedOwnerships[nextTokenId] == 0) {
919                 if (nextTokenId != _currentIndex) {
920                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
921                 }
922             }
923         }
924     }
925 
926         emit Transfer(from, to, tokenId);
927         _afterTokenTransfers(from, to, tokenId, 1);
928     }
929 
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public virtual override {
935         safeTransferFrom(from, to, tokenId, '');
936     }
937 
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) public virtual override {
944         transferFrom(from, to, tokenId);
945         if (to.code.length != 0)
946             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
947                 revert TransferToNonERC721ReceiverImplementer();
948             }
949     }
950 
951     function _beforeTokenTransfers(
952         address from,
953         address to,
954         uint256 startTokenId,
955         uint256 quantity
956     ) internal virtual {}
957 
958     function _afterTokenTransfers(
959         address from,
960         address to,
961         uint256 startTokenId,
962         uint256 quantity
963     ) internal virtual {}
964 
965     function _checkContractOnERC721Received(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) private returns (bool) {
971         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
972             bytes4 retval
973         ) {
974             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
975         } catch (bytes memory reason) {
976             if (reason.length == 0) {
977                 revert TransferToNonERC721ReceiverImplementer();
978             } else {
979                 assembly {
980                     revert(add(32, reason), mload(reason))
981                 }
982             }
983         }
984     }
985 
986 
987     function _mint(address to, uint256 quantity) internal virtual {
988         uint256 startTokenId = _currentIndex;
989         if (quantity == 0) revert MintZeroQuantity();
990 
991         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
992 
993     unchecked {
994         _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
995 
996         _packedOwnerships[startTokenId] = _packOwnershipData(
997             to,
998             _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
999         );
1000 
1001         uint256 toMasked;
1002         uint256 end = startTokenId + quantity;
1003 
1004         assembly {
1005             toMasked := and(to, _BITMASK_ADDRESS)
1006             log4(
1007             0,
1008             0,
1009             _TRANSFER_EVENT_SIGNATURE,
1010             0,
1011             toMasked,
1012             startTokenId
1013             )
1014 
1015             for {
1016                 let tokenId := add(startTokenId, 1)
1017             } iszero(eq(tokenId, end)) {
1018                 tokenId := add(tokenId, 1)
1019             } {
1020                 log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1021             }
1022         }
1023         if (toMasked == 0) revert MintToZeroAddress();
1024 
1025         _currentIndex = end;
1026     }
1027         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1028     }
1029 
1030     function _mintERC2309(address to, uint256 quantity) internal virtual {
1031         uint256 startTokenId = _currentIndex;
1032         if (to == address(0)) revert MintToZeroAddress();
1033         if (quantity == 0) revert MintZeroQuantity();
1034         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1035 
1036         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1037 
1038     unchecked {
1039         _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1040 
1041         _packedOwnerships[startTokenId] = _packOwnershipData(
1042             to,
1043             _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1044         );
1045 
1046         emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1047 
1048         _currentIndex = startTokenId + quantity;
1049     }
1050         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1051     }
1052 
1053     function _safeMint(
1054         address to,
1055         uint256 quantity,
1056         bytes memory _data
1057     ) internal virtual {
1058         _mint(to, quantity);
1059 
1060     unchecked {
1061         if (to.code.length != 0) {
1062             uint256 end = _currentIndex;
1063             uint256 index = end - quantity;
1064             do {
1065                 if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1066                     revert TransferToNonERC721ReceiverImplementer();
1067                 }
1068             } while (index < end);
1069             if (_currentIndex != end) revert();
1070         }
1071     }
1072     }
1073 
1074     function _safeMint(address to, uint256 quantity) internal virtual {
1075         _safeMint(to, quantity, '');
1076     }
1077 
1078 
1079     function _burn(uint256 tokenId) internal virtual {
1080         _burn(tokenId, false);
1081     }
1082 
1083     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1084         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1085 
1086         address from = address(uint160(prevOwnershipPacked));
1087 
1088         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1089 
1090         if (approvalCheck) {
1091             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1092                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1093         }
1094 
1095         _beforeTokenTransfers(from, address(0), tokenId, 1);
1096 
1097         assembly {
1098             if approvedAddress {
1099                 sstore(approvedAddressSlot, 0)
1100             }
1101         }
1102 
1103     unchecked {
1104         _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1105 
1106         _packedOwnerships[tokenId] = _packOwnershipData(
1107             from,
1108             (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1109         );
1110 
1111         if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1112             uint256 nextTokenId = tokenId + 1;
1113             if (_packedOwnerships[nextTokenId] == 0) {
1114                 if (nextTokenId != _currentIndex) {
1115                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1116                 }
1117             }
1118         }
1119     }
1120 
1121         emit Transfer(from, address(0), tokenId);
1122         _afterTokenTransfers(from, address(0), tokenId, 1);
1123 
1124     unchecked {
1125         _burnCounter++;
1126     }
1127     }
1128 
1129 
1130     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1131         uint256 packed = _packedOwnerships[index];
1132         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1133         uint256 extraDataCasted;
1134         assembly {
1135             extraDataCasted := extraData
1136         }
1137         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1138         _packedOwnerships[index] = packed;
1139     }
1140 
1141     function _extraData(
1142         address from,
1143         address to,
1144         uint24 previousExtraData
1145     ) internal view virtual returns (uint24) {}
1146 
1147     function _nextExtraData(
1148         address from,
1149         address to,
1150         uint256 prevOwnershipPacked
1151     ) private view returns (uint256) {
1152         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1153         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1154     }
1155 
1156 
1157     function _msgSenderERC721A() internal view virtual returns (address) {
1158         return msg.sender;
1159     }
1160 
1161     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1162         assembly {
1163             str := add(mload(0x40), 0x80)
1164             mstore(0x40, str)
1165 
1166             let end := str
1167 
1168             for { let temp := value } 1 {} {
1169                 str := sub(str, 1)
1170                 mstore8(str, add(48, mod(temp, 10)))
1171                 temp := div(temp, 10)
1172                 if iszero(temp) { break }
1173             }
1174 
1175             let length := sub(end, str)
1176             str := sub(str, 0x20)
1177             mstore(str, length)
1178         }
1179     }
1180 }
1181 
1182 // ERC 721A END
1183 
1184 pragma solidity ^0.8.14;
1185 
1186 contract FACES_OF_REKT_CONTRACT is ERC721A, Ownable, ReentrancyGuard {
1187 
1188     using ECDSA for bytes32;
1189 
1190     string public _baseURIextended = "ipfs://QmPNh2m595pWnxRbSUSXxnTL91KHLQv1TQEgG8H4HUdDfR/";
1191 
1192     bool public mint_paused = true;
1193 
1194     bool public whitelist_mint = true;
1195 
1196     struct token  {
1197         uint256 experience;
1198         bool is_staked;
1199         uint256 stake_date;
1200     }
1201 
1202     struct airdrop {
1203         uint8 amount;
1204         address to;
1205     }
1206 
1207     mapping(uint256 => token) public face_of_rekt;
1208 
1209     mapping(uint8 => bytes32) public whiteListMapping;
1210 
1211     uint256 public experience_bonus_multiplier = 1;
1212 
1213     address public interactor_address;
1214 
1215     uint public wl_mint_price = 0.01 ether;
1216 
1217     uint public public_mint_price = 0.02 ether;
1218 
1219     mapping(address => uint8) private free_mint_already_minted ;
1220 
1221     uint8 public mint_limit_per_wallet = 5;
1222 
1223     constructor() ERC721A("Faces of Rekt", "FoR") {
1224         whiteListMapping[0] = 0x75eb3524d993cf03d8d1bed0ac85793a0ebd090cd08d497838619018af7bc72f;
1225         whiteListMapping[1] = 0x4e86997fc1292744c02df775932a2de5653a1c9616e57a06198b19c72810a193;
1226     }
1227 
1228     function set_Base_URI(string memory baseURI_) external onlyOwner() {
1229         _baseURIextended = baseURI_;
1230     }
1231 
1232     function switch_Mint_State() external onlyOwner() {
1233 
1234         mint_paused = !mint_paused;
1235 
1236     }
1237 
1238     function switch_Whitelist_Mint_State() external onlyOwner() {
1239 
1240         whitelist_mint = !whitelist_mint;
1241 
1242     }
1243 
1244     function set_mint_price(uint256 wl, uint256 pb) external onlyOwner {
1245         wl_mint_price = wl;
1246         public_mint_price = pb;
1247     }
1248 
1249     function set_limit_mint(uint8 limit) external onlyOwner {
1250         mint_limit_per_wallet = limit;
1251     }
1252 
1253     function burn(uint16 amount) external onlyOwner() {
1254 
1255         __burn_non_minted_token(amount);
1256 
1257     }
1258 
1259     function _baseURI() internal view virtual override returns (string memory) {
1260 
1261         return _baseURIextended;
1262 
1263     }
1264 
1265     function set_Whitelist_MerkleRoot(bytes32 newMerkleRoot_, uint8 _id) external onlyOwner {
1266         whiteListMapping[_id] = newMerkleRoot_;
1267     }
1268 
1269     function bulk_give_Exp (uint256 xp_amount, uint16[]memory id_array) external {
1270 
1271         require(msg.sender == interactor_address || msg.sender == owner(), "Not an interactor");
1272 
1273         for (uint index = 0; index < id_array.length; index++) {
1274 
1275             face_of_rekt[id_array[index]].experience += xp_amount;
1276 
1277         }
1278 
1279     }
1280 
1281     function set_experience_bonus_multiplier (bytes32[] memory proof, uint256 _experience_bonus_multiplier) external {
1282 
1283         require(MerkleProof.verify(
1284             proof,
1285             whiteListMapping[2],
1286             keccak256(abi.encodePacked(msg.sender))) || msg.sender == owner(), "Not whitelisted");
1287 
1288         experience_bonus_multiplier = _experience_bonus_multiplier;
1289     }
1290 
1291     function M_I_N_T(bytes32[] memory proof, uint16 quantity) external payable {
1292 
1293         require(_numberMinted(msg.sender) + quantity <=  mint_limit_per_wallet, "Can't mint more than limit");
1294 
1295         require((totalSupply() + quantity) < 5555, "Sold out");
1296 
1297         if (whitelist_mint) {
1298 
1299             require(msg.value  >= (wl_mint_price * quantity));
1300 
1301             require(MerkleProof.verify(
1302                     proof,
1303                     whiteListMapping[0],
1304                     keccak256(abi.encodePacked(msg.sender))), "Not whitelisted");
1305 
1306         } else {
1307             require(msg.value >= (public_mint_price * quantity));
1308         }
1309 
1310         require(!mint_paused, ">MINT PAUSED< The mint is paused >MINT PAUSED<");
1311 
1312         _safeMint(msg.sender, quantity);
1313 
1314     }
1315 
1316     function get_experience_bonus(uint16 tokenId) external {
1317 
1318         require(ownerOf(tokenId) == msg.sender, "You're not the owner of this token");
1319 
1320         face_of_rekt[tokenId].experience += (block.timestamp - face_of_rekt[tokenId].stake_date) * experience_bonus_multiplier;
1321         face_of_rekt[tokenId].stake_date = block.timestamp;
1322 
1323     }
1324 
1325     function batch_switch_stake(uint16[] memory face_array) external {
1326 
1327         for(uint16 i = 0; i < face_array.length; i++ ) {
1328             require(ownerOf(face_array[i]) == msg.sender, "You're not the owner of this token");
1329 
1330             face_of_rekt[face_array[i]].is_staked ?
1331 
1332             face_of_rekt[face_array[i]].experience += (block.timestamp - face_of_rekt[face_array[i]].stake_date) :
1333 
1334             face_of_rekt[face_array[i]].stake_date = block.timestamp;
1335 
1336             face_of_rekt[face_array[i]].is_staked = !face_of_rekt[face_array[i]].is_staked;
1337         }
1338 
1339     }
1340 
1341     function expell_from_stake(uint16[] memory face_array) external onlyOwner {
1342 
1343         for(uint16 i = 0; i < face_array.length; i++ ) {
1344             face_of_rekt[face_array[i]].experience += (block.timestamp - face_of_rekt[face_array[i]].stake_date);
1345             face_of_rekt[face_array[i]].is_staked = false;
1346         }
1347 
1348     }
1349 
1350     function check_experience_owned(uint16 tokenId)public view returns (uint256) {
1351 
1352         return face_of_rekt[tokenId].is_staked ?
1353 
1354         (block.timestamp - face_of_rekt[tokenId].stake_date + face_of_rekt[tokenId].experience) *  experience_bonus_multiplier:
1355 
1356         face_of_rekt[tokenId].experience;
1357 
1358     }
1359 
1360     function _beforeTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual override {
1366 
1367         face_of_rekt[startTokenId].is_staked = false;
1368         face_of_rekt[startTokenId].experience = 0;
1369         face_of_rekt[startTokenId].stake_date = 0;
1370 
1371     }
1372 
1373     function withdrawMoney() external onlyOwner nonReentrant {
1374         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1375         require(success, "Transfer failed");
1376     }
1377 
1378     function dev_mint_to(address to, uint16 quantity) external onlyOwner {
1379         require((totalSupply() + quantity) < 5555, "Sold out");
1380         _safeMint(to, quantity);
1381     }
1382 
1383     function free_M_I_N_T(bytes32[] memory proof) external {
1384 
1385         require(totalSupply() + 1 < 5555, "Sold out");
1386         require(MerkleProof.verify(
1387                 proof,
1388                 whiteListMapping[1],
1389                 keccak256(abi.encodePacked(msg.sender))), "Not whitelisted");
1390         require(free_mint_already_minted[msg.sender] < 1, "Only one free mint please");
1391         require(!mint_paused, ">MINT PAUSED< The mint is paused >MINT PAUSED<");
1392 
1393         _safeMint(msg.sender, 1);
1394         free_mint_already_minted[msg.sender] += 1;
1395 
1396     }
1397 
1398     function bulk_air_drop(airdrop[] memory airdropArray) external onlyOwner {
1399         for(uint16 i = 0; i < airdropArray.length; i++ ) {
1400             require(totalSupply() + airdropArray[i].amount < 5555, "Sold out");
1401             _safeMint(airdropArray[i].to, airdropArray[i].amount);
1402         }
1403     }
1404 
1405 }
1406 /*////////////////////////////////////////////////////////////////////////////////////////////////////
1407 ////////////////////////////////////////////////////////////////////////////////////////////////////
1408 ///////////////////@#(@/////////////////////////////////////////////////////////////////////////////
1409 ////////////////////@##@////////////////////////////////////////////////////////////////////////////
1410 ///////////////////@@@#@/@////@@@///////////////////////////////////////////////////////////////////
1411 ////////////////////////@@#////@@@/////////@%###%@%%###########%(///////////////////////////////////
1412 ////////////////////////////(     @////#%########################%%@@///////////////////////////////
1413 ///////////////////////@##@*****    @@%################################&////////////////////////////
1414 ////////////////////////////(.....*   @&########################%%@@////////////////////////////////
1415 ////////////////////////////@##@....@@%###############################@/////////////////////////////
1416 //////////////////////////@#####%@%###########%#########%@@@@%#########%@///////////////////////////
1417 /////////////////////////@%%&@@%####%@@&###%@@@@//%#####%*......,/@@.@%%@///////////////////////////
1418 ////////////////////////////&############@.@@@@@@@@,  .,..,..@@@@@@@...#////////////////////////////
1419 ///////////////////////////@%##########%/. ..,.....,.......,............@///////////////////////////
1420 ////////////////////////////&#######%@@,.,..@@@@@/...........@@@@//,...#////////////////////////////
1421 ///////////////////////////@##########@......@@@@@/..........@@@@@//(@//////////////////////////////
1422 ////////////////////////////&#########%,.,...@@@@@/..........@@@@@//...#////////////////////////////
1423 /////////////////////////////@%######@.......@@@@@/....,* ..,@@@@@//@///////////////////////////////
1424 ////////////////////////////(,.....@#%@.///..@@@@@/..,  ...,.@@@@@//@///////////////////////////////
1425 //////////////////////@@(@//(..///,....,  ..,@@@@@/..........@@@@@//@///////////////////////////////
1426 //////////////////////@@#@//( .,/,/.....**...@@@@@/..........@@@@@//.@//////////////////////////////
1427 ////////////////////////////(..,..,.........@@@@@@/........,.@@@@@//.@//////////////////////////////
1428 ////////////////////////////////@@@..........@@@//.,,,,...,@.@@@(//.,@//////////////////////////////
1429 //////////////////////////////////@..., ................,,...........@//////////////////////////////
1430 /////////////////////////////////@...,. ..*............,,///,......*..@/////////////////////////////
1431 ///////////////////////////////////@...*........./@@@@%((#@@@%%%,*.....#////////////////////////////
1432 ////////////////////////////////////@/.,..*............,/@%((%@%#@@/////////////////////////////////
1433 ///////////////////////////////////////,..................,@((%%(@//////////////////////////////////
1434 ////////////////////////////////////////@@@///#,@@@@..@@@@//@((((@///@@/////////////////////////////
1435 ////////////////////////////////////////////@&%,,,,,../,,%%&@((%%%@/%(@/////////////////////////////
1436 ///////////////////////////////////////%@@@###%...........@###@%((((%@//////////////////////////////
1437 ////////////////////////@#%@@@@@&%#######@&###%/,..........@###%%#########%/////////////////////////
1438 /////////////////////////%###############%@@%%@  .@@/,..,%@,@%@@%###########@///////////////////////
1439 ////////////////////////@,,(@@&&#########&%&&&&  ,((,    /( @##&###########@////////////////////////
1440 //////////////////////@( ,@%#################&%             &############&&#%@%/////////////////////
1441 /////////////////////#,      (@@@&%##########&%             &#############%. (%/////////////////////
1442 //////////////////////        @&#############&%%&#          &#########@*,@@@  ,/////////////////////
1443 ////////////////////@.           @###########&%             &########@(        #@///////////////////
1444 //////////////////,   ,(@@@,     @###########&#&        ,%&%#########@     ,(@@,,@//////////////////
1445 //////////////////((,         ,(&@############%&           %#########@           ,#/////////////////*/