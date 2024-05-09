1 // SPDX-License-Identifier: MIT
2  
3  
4 // File: contracts/Gen.sol
5 
6 
7 
8 pragma solidity ^0.8.7;
9 
10  
11  
12 contract Gen {
13 
14     
15 
16     // MAPPINGS //    
17     mapping(string => uint) internal charsMap; // maps characters to numbers for easier access in 'generateWord()' function
18     mapping(uint => uint) internal tokenIdToSeed; // initial seed for each tokenId minted
19     mapping(uint => uint[8]) internal tokenIdToShuffleShift; // tokenId => array of inexes for words to be shifted as a result of shuffling
20     mapping(uint => uint) internal shuffleCount; // tokenId => number of shuffles tokenId has had
21     mapping(address => bool) internal hasClaimed; // keeps track of addresses that have claimed a mint
22     
23 
24     /**
25      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
26      */
27     function toString(uint256 value) internal pure returns (string memory) {
28         // Inspired by OraclizeAPI's implementation - MIT licence
29         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48     
49     
50     // VARIABLES //
51     
52     
53     uint16[297] ps = [
54         1000, 1889, 2889, 3556, 5223, 6223, 7334, 8778, 9334, 9556, 10000,
55         381, 952, 1428, 1809, 2761, 4856, 6094, 7523, 9523, 9809, 10000,
56         198, 792, 1584, 2079, 2574, 3267, 3366, 5643, 7029, 9900, 10000,
57         714, 1071, 1607, 2232, 2945, 4285, 5178, 6516, 7856, 9195, 10000,
58         385, 1348, 3467, 5201, 6163, 7127, 9824, 9920, 9939, 9958, 10000,
59         135, 405, 1081, 1216, 1892, 2703, 4325, 5541, 7568, 9730, 10000,
60         2443, 2932, 3421, 3910, 4561, 5212, 6677, 8470, 9936, 9985, 10000,
61         1239, 1770, 2655, 4071, 5310, 6726, 7257, 9912, 9947, 9982, 10000,
62         268, 281, 294, 328, 1668, 4751, 7432, 9979, 9986, 9993, 10000,
63         291, 679, 1164, 1649, 2329, 3106, 3689, 4951, 6504, 9708, 10000,
64         353, 706, 1923, 3510, 5097, 7672, 8818, 9964, 9982, 9991, 10000, 
65         755, 1227, 1416, 1605, 1888, 2077, 2171, 3114, 9246, 9812, 10000,
66         695, 721, 747, 834, 851, 3023, 5195, 6846, 9974, 9991, 10000,
67         103, 308, 513, 821, 1437, 2566, 3901, 7289, 9958, 9979, 10000,
68         294, 588, 735, 750, 1337, 2071, 2805, 4127, 6183, 8239, 10000,
69         88, 1148, 2561, 2738, 3975, 4682, 4859, 5389, 7156, 9983, 10000,
70         325, 760, 1303, 1629, 1955, 3367, 4670, 6624, 8253, 9990, 10000,
71         4955, 9910, 9920, 9930, 9940, 9950, 9960, 9970, 9980, 9990, 10000,
72         214, 428, 641, 663, 1197, 1411, 1454, 2522, 3590, 4658, 10000,
73         196, 784, 2548, 3332, 4312, 5488, 7644, 9800, 9996, 9998, 10000,
74         475, 1424, 1661, 2848, 4272, 5933, 8544, 9256, 9968, 9992, 10000,
75         515, 618, 1133, 1442, 2267, 3298, 4947, 6493, 7730, 9483, 10000,
76         202, 1412, 3025, 5444, 7662, 9880, 9920, 9940, 9960, 9980, 10000,
77         23, 252, 480, 2657, 2886, 4719, 7354, 9645, 9874, 9885, 10000,
78         433, 866, 1732, 3464, 5195, 8659, 9525, 9698, 9871, 9958, 10000,
79         601, 901, 1502, 2103, 3605, 4806, 6007, 9010, 9310, 9400, 10000,
80         204, 511, 613, 714, 1737, 3782, 9917, 9968, 9978, 9988, 10000];
81     
82 
83 
84     string[] nextChars = [
85         "fbrwsaltpzj",
86         "gmldslrtnkb",
87         "blriiluoaey",
88         "rliktauhooe",
89         "ruaoiiegfws",
90         "mfteladsnrg",
91         "luaarreioyw",
92         "luiraohezgy",
93         "urryoiaejlw",
94         "gredlocstnb",
95         "iieaaouuytf",
96         "aollarsieut",
97         "ussdyoaielf",
98         "smmupioaeyn",
99         "aauyiosetgd",
100         "zolwtmfurny",
101         "tupiilaores",
102         "uuaeiosrfyw",
103         "nudytslaioe",
104         "puhaoietwyq",
105         "usraieohhty",
106         "ebgzplsntrm",
107         "uoaieeyvxrl",
108         "snnoheaiuyr",
109         "oaueeityxth",
110         "lmaiseeouvx",
111         "uyooiaelzrl"];
112 
113     
114 
115     
116     /**
117      * @dev Maps characters in 'chars' to numbers for easier comparison in 'generateWord()' function
118      */
119     function mapChars() internal {
120         string[27] memory chars = [" ", "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
121         for (uint i=0; i<27; i++) {
122             charsMap[chars[i]] = i;
123         }
124     }
125 
126     
127     /**
128      * @dev Returns length of a string '_string'.
129      */
130     function stringLength(string memory _string) internal pure returns(uint) {
131         return bytes(_string).length;
132     }
133 
134     
135     /**
136      * @dev Gets character from 'nextChars'.
137      */
138     function getChar(uint row, uint col) internal view returns(string memory) {
139         bytes memory line = bytes(nextChars[row]);
140         string memory temp = new string(1);
141         bytes memory output = bytes(temp);
142         output[0] = line[col];
143         return string(output); 
144     }
145     
146     
147     
148     /**
149      * @dev Generates word length (1-16) using a distribution
150      */
151     function determineWordLength(uint rand) internal pure returns(uint) {
152         
153         uint16[16] memory cumulativeDistribution = [2,99,761,1929,3175,4694,6291,7654,8744,9328,9678,9872,9938,9976,9991,10000];
154         
155         uint i = 0;
156         while (i <= 15) { 
157             if (rand <= cumulativeDistribution[i]) {
158                 break;
159             }
160             i++;
161         }
162         return i+1;  // returns word length
163     }
164     
165     
166     
167     /**
168      * @dev Generates a random word of length 1-16, given a '_tokenId' and '_totalSeed' as a seed of randomness
169      */
170     function generateWord(uint256 _tokenId, uint _totalSeed) internal view returns(string memory) { // change visibility
171 
172         require(_tokenId >= 1 && _tokenId <= 10000, "Invalid tokenId.");
173 
174         string memory word;
175         string memory char;
176         
177         uint lengthRand = (uint(keccak256(abi.encodePacked(_tokenId, _totalSeed)))% 10000); // gets random number between 0 and 10,000
178         uint rand = (uint(keccak256(abi.encodePacked(_tokenId, lengthRand, _totalSeed)))% 10000) + 1; // gets random number between 1 and 10,000
179 
180         // generates word
181         for (uint n=1; n <= determineWordLength(lengthRand); n++) {
182             
183             // generates letter
184             uint i = 0;
185             while (i < 11) { // indexStart of ps[] to indexEnd
186                 if (rand <= ps[(charsMap[char]*11)+i]) {
187                     break;
188                 }
189                 i++;
190             }
191             char = getChar(charsMap[char], i);
192             
193             word = string(abi.encodePacked(word, char)); // appends letter to word
194             rand = (uint(keccak256(abi.encodePacked(_tokenId, rand, word, n, _totalSeed)))% 10000) + 1; // gets new random number between 1 and 10,000
195         }
196         return word;
197     }
198     
199     
200 }
201 
202 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
203 
204 
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev These functions deal with verification of Merkle Trees proofs.
210  *
211  * The proofs can be generated using the JavaScript library
212  * https://github.com/miguelmota/merkletreejs[merkletreejs].
213  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
214  *
215  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
216  */
217 library MerkleProof {
218     /**
219      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
220      * defined by `root`. For this, a `proof` must be provided, containing
221      * sibling hashes on the branch from the leaf to the root of the tree. Each
222      * pair of leaves and each pair of pre-images are assumed to be sorted.
223      */
224     function verify(
225         bytes32[] memory proof,
226         bytes32 root,
227         bytes32 leaf
228     ) internal pure returns (bool) {
229         bytes32 computedHash = leaf;
230 
231         for (uint256 i = 0; i < proof.length; i++) {
232             bytes32 proofElement = proof[i];
233 
234             if (computedHash <= proofElement) {
235                 // Hash(current computed hash + current element of the proof)
236                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
237             } else {
238                 // Hash(current element of the proof + current computed hash)
239                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
240             }
241         }
242 
243         // Check if the computed hash (root) is equal to the provided root
244         return computedHash == root;
245     }
246 }
247 
248 
249 // File: @openzeppelin/contracts/utils/Context.sol
250 
251 
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev Provides information about the current execution context, including the
257  * sender of the transaction and its data. While these are generally available
258  * via msg.sender and msg.data, they should not be accessed in such a direct
259  * manner, since when dealing with meta-transactions the account sending and
260  * paying for execution may not be the actual sender (as far as an application
261  * is concerned).
262  *
263  * This contract is only required for intermediate, library-like contracts.
264  */
265 abstract contract Context {
266     function _msgSender() internal view virtual returns (address) {
267         return msg.sender;
268     }
269 
270     function _msgData() internal view virtual returns (bytes calldata) {
271         return msg.data;
272     }
273 }
274 
275 
276 
277 // File: @openzeppelin/contracts/access/Ownable.sol
278 
279 
280 
281 pragma solidity ^0.8.0;
282 
283 
284 /**
285  * @dev Contract module which provides a basic access control mechanism, where
286  * there is an account (an owner) that can be granted exclusive access to
287  * specific functions.
288  *
289  * By default, the owner account will be the one that deploys the contract. This
290  * can later be changed with {transferOwnership}.
291  *
292  * This module is used through inheritance. It will make available the modifier
293  * `onlyOwner`, which can be applied to your functions to restrict their use to
294  * the owner.
295  */
296 abstract contract Ownable is Context {
297     address private _owner;
298 
299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301     /**
302      * @dev Initializes the contract setting the deployer as the initial owner.
303      */
304     constructor() {
305         _setOwner(_msgSender());
306     }
307 
308     /**
309      * @dev Returns the address of the current owner.
310      */
311     function owner() public view virtual returns (address) {
312         return _owner;
313     }
314 
315     /**
316      * @dev Throws if called by any account other than the owner.
317      */
318     modifier onlyOwner() {
319         require(owner() == _msgSender(), "Ownable: caller is not the owner");
320         _;
321     }
322 
323     /**
324      * @dev Leaves the contract without owner. It will not be possible to call
325      * `onlyOwner` functions anymore. Can only be called by the current owner.
326      *
327      * NOTE: Renouncing ownership will leave the contract without an owner,
328      * thereby removing any functionality that is only available to the owner.
329      */
330     function renounceOwnership() public virtual onlyOwner {
331         _setOwner(address(0));
332     }
333 
334     /**
335      * @dev Transfers ownership of the contract to a new account (`newOwner`).
336      * Can only be called by the current owner.
337      */
338     function transferOwnership(address newOwner) public virtual onlyOwner {
339         require(newOwner != address(0), "Ownable: new owner is the zero address");
340         _setOwner(newOwner);
341     }
342 
343     function _setOwner(address newOwner) private {
344         address oldOwner = _owner;
345         _owner = newOwner;
346         emit OwnershipTransferred(oldOwner, newOwner);
347     }
348 }
349 
350 
351 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
352 
353 
354 
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @dev Interface of the ERC165 standard, as defined in the
359  * https://eips.ethereum.org/EIPS/eip-165[EIP].
360  *
361  * Implementers can declare support of contract interfaces, which can then be
362  * queried by others ({ERC165Checker}).
363  *
364  * For an implementation, see {ERC165}.
365  */
366 interface IERC165 {
367     /**
368      * @dev Returns true if this contract implements the interface defined by
369      * `interfaceId`. See the corresponding
370      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
371      * to learn more about how these ids are created.
372      *
373      * This function call must use less than 30 000 gas.
374      */
375     function supportsInterface(bytes4 interfaceId) external view returns (bool);
376 }
377 
378 
379 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
380 
381 
382 
383 pragma solidity ^0.8.0;
384 
385 
386 /**
387  * @dev Implementation of the {IERC165} interface.
388  *
389  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
390  * for the additional interface id that will be supported. For example:
391  *
392  * ```solidity
393  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
394  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
395  * }
396  * ```
397  *
398  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
399  */
400 abstract contract ERC165 is IERC165 {
401     /**
402      * @dev See {IERC165-supportsInterface}.
403      */
404     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
405         return interfaceId == type(IERC165).interfaceId;
406     }
407 }
408 
409 // File: @openzeppelin/contracts/utils/Strings.sol
410 
411 
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @dev String operations.
417  */
418 library Strings {
419     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
420 
421     /**
422      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
423      */
424     function toString(uint256 value) internal pure returns (string memory) {
425         // Inspired by OraclizeAPI's implementation - MIT licence
426         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
427 
428         if (value == 0) {
429             return "0";
430         }
431         uint256 temp = value;
432         uint256 digits;
433         while (temp != 0) {
434             digits++;
435             temp /= 10;
436         }
437         bytes memory buffer = new bytes(digits);
438         while (value != 0) {
439             digits -= 1;
440             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
441             value /= 10;
442         }
443         return string(buffer);
444     }
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
448      */
449     function toHexString(uint256 value) internal pure returns (string memory) {
450         if (value == 0) {
451             return "0x00";
452         }
453         uint256 temp = value;
454         uint256 length = 0;
455         while (temp != 0) {
456             length++;
457             temp >>= 8;
458         }
459         return toHexString(value, length);
460     }
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
464      */
465     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
466         bytes memory buffer = new bytes(2 * length + 2);
467         buffer[0] = "0";
468         buffer[1] = "x";
469         for (uint256 i = 2 * length + 1; i > 1; --i) {
470             buffer[i] = _HEX_SYMBOLS[value & 0xf];
471             value >>= 4;
472         }
473         require(value == 0, "Strings: hex length insufficient");
474         return string(buffer);
475     }
476 }
477 
478 
479 // File: @openzeppelin/contracts/utils/Address.sol
480 
481 
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @dev Collection of functions related to the address type
487  */
488 library Address {
489     /**
490      * @dev Returns true if `account` is a contract.
491      *
492      * [IMPORTANT]
493      * ====
494      * It is unsafe to assume that an address for which this function returns
495      * false is an externally-owned account (EOA) and not a contract.
496      *
497      * Among others, `isContract` will return false for the following
498      * types of addresses:
499      *
500      *  - an externally-owned account
501      *  - a contract in construction
502      *  - an address where a contract will be created
503      *  - an address where a contract lived, but was destroyed
504      * ====
505      */
506     function isContract(address account) internal view returns (bool) {
507         // This method relies on extcodesize, which returns 0 for contracts in
508         // construction, since the code is only stored at the end of the
509         // constructor execution.
510 
511         uint256 size;
512         assembly {
513             size := extcodesize(account)
514         }
515         return size > 0;
516     }
517 
518     /**
519      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
520      * `recipient`, forwarding all available gas and reverting on errors.
521      *
522      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
523      * of certain opcodes, possibly making contracts go over the 2300 gas limit
524      * imposed by `transfer`, making them unable to receive funds via
525      * `transfer`. {sendValue} removes this limitation.
526      *
527      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
528      *
529      * IMPORTANT: because control is transferred to `recipient`, care must be
530      * taken to not create reentrancy vulnerabilities. Consider using
531      * {ReentrancyGuard} or the
532      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
533      */
534     function sendValue(address payable recipient, uint256 amount) internal {
535         require(address(this).balance >= amount, "Address: insufficient balance");
536 
537         (bool success, ) = recipient.call{value: amount}("");
538         require(success, "Address: unable to send value, recipient may have reverted");
539     }
540 
541     /**
542      * @dev Performs a Solidity function call using a low level `call`. A
543      * plain `call` is an unsafe replacement for a function call: use this
544      * function instead.
545      *
546      * If `target` reverts with a revert reason, it is bubbled up by this
547      * function (like regular Solidity function calls).
548      *
549      * Returns the raw returned data. To convert to the expected return value,
550      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
551      *
552      * Requirements:
553      *
554      * - `target` must be a contract.
555      * - calling `target` with `data` must not revert.
556      *
557      * _Available since v3.1._
558      */
559     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
560         return functionCall(target, data, "Address: low-level call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
565      * `errorMessage` as a fallback revert reason when `target` reverts.
566      *
567      * _Available since v3.1._
568      */
569     function functionCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         return functionCallWithValue(target, data, 0, errorMessage);
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
579      * but also transferring `value` wei to `target`.
580      *
581      * Requirements:
582      *
583      * - the calling contract must have an ETH balance of at least `value`.
584      * - the called Solidity function must be `payable`.
585      *
586      * _Available since v3.1._
587      */
588     function functionCallWithValue(
589         address target,
590         bytes memory data,
591         uint256 value
592     ) internal returns (bytes memory) {
593         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
598      * with `errorMessage` as a fallback revert reason when `target` reverts.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(
603         address target,
604         bytes memory data,
605         uint256 value,
606         string memory errorMessage
607     ) internal returns (bytes memory) {
608         require(address(this).balance >= value, "Address: insufficient balance for call");
609         require(isContract(target), "Address: call to non-contract");
610 
611         (bool success, bytes memory returndata) = target.call{value: value}(data);
612         return verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but performing a static call.
618      *
619      * _Available since v3.3._
620      */
621     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
622         return functionStaticCall(target, data, "Address: low-level static call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
627      * but performing a static call.
628      *
629      * _Available since v3.3._
630      */
631     function functionStaticCall(
632         address target,
633         bytes memory data,
634         string memory errorMessage
635     ) internal view returns (bytes memory) {
636         require(isContract(target), "Address: static call to non-contract");
637 
638         (bool success, bytes memory returndata) = target.staticcall(data);
639         return verifyCallResult(success, returndata, errorMessage);
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
644      * but performing a delegate call.
645      *
646      * _Available since v3.4._
647      */
648     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
649         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
654      * but performing a delegate call.
655      *
656      * _Available since v3.4._
657      */
658     function functionDelegateCall(
659         address target,
660         bytes memory data,
661         string memory errorMessage
662     ) internal returns (bytes memory) {
663         require(isContract(target), "Address: delegate call to non-contract");
664 
665         (bool success, bytes memory returndata) = target.delegatecall(data);
666         return verifyCallResult(success, returndata, errorMessage);
667     }
668 
669     /**
670      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
671      * revert reason using the provided one.
672      *
673      * _Available since v4.3._
674      */
675     function verifyCallResult(
676         bool success,
677         bytes memory returndata,
678         string memory errorMessage
679     ) internal pure returns (bytes memory) {
680         if (success) {
681             return returndata;
682         } else {
683             // Look for revert reason and bubble it up if present
684             if (returndata.length > 0) {
685                 // The easiest way to bubble the revert reason is using memory via assembly
686 
687                 assembly {
688                     let returndata_size := mload(returndata)
689                     revert(add(32, returndata), returndata_size)
690                 }
691             } else {
692                 revert(errorMessage);
693             }
694         }
695     }
696 }
697 
698 
699 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
700 
701 
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @dev Required interface of an ERC721 compliant contract.
708  */
709 interface IERC721 is IERC165 {
710     /**
711      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
712      */
713     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
714 
715     /**
716      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
717      */
718     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
719 
720     /**
721      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
722      */
723     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
724 
725     /**
726      * @dev Returns the number of tokens in ``owner``'s account.
727      */
728     function balanceOf(address owner) external view returns (uint256 balance);
729 
730     /**
731      * @dev Returns the owner of the `tokenId` token.
732      *
733      * Requirements:
734      *
735      * - `tokenId` must exist.
736      */
737     function ownerOf(uint256 tokenId) external view returns (address owner);
738 
739     /**
740      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
741      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
742      *
743      * Requirements:
744      *
745      * - `from` cannot be the zero address.
746      * - `to` cannot be the zero address.
747      * - `tokenId` token must exist and be owned by `from`.
748      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
749      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
750      *
751      * Emits a {Transfer} event.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) external;
758 
759     /**
760      * @dev Transfers `tokenId` token from `from` to `to`.
761      *
762      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
763      *
764      * Requirements:
765      *
766      * - `from` cannot be the zero address.
767      * - `to` cannot be the zero address.
768      * - `tokenId` token must be owned by `from`.
769      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
770      *
771      * Emits a {Transfer} event.
772      */
773     function transferFrom(
774         address from,
775         address to,
776         uint256 tokenId
777     ) external;
778 
779     /**
780      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
781      * The approval is cleared when the token is transferred.
782      *
783      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
784      *
785      * Requirements:
786      *
787      * - The caller must own the token or be an approved operator.
788      * - `tokenId` must exist.
789      *
790      * Emits an {Approval} event.
791      */
792     function approve(address to, uint256 tokenId) external;
793 
794     /**
795      * @dev Returns the account approved for `tokenId` token.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must exist.
800      */
801     function getApproved(uint256 tokenId) external view returns (address operator);
802 
803     /**
804      * @dev Approve or remove `operator` as an operator for the caller.
805      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
806      *
807      * Requirements:
808      *
809      * - The `operator` cannot be the caller.
810      *
811      * Emits an {ApprovalForAll} event.
812      */
813     function setApprovalForAll(address operator, bool _approved) external;
814 
815     /**
816      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
817      *
818      * See {setApprovalForAll}
819      */
820     function isApprovedForAll(address owner, address operator) external view returns (bool);
821 
822     /**
823      * @dev Safely transfers `tokenId` token from `from` to `to`.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must exist and be owned by `from`.
830      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function safeTransferFrom(
836         address from,
837         address to,
838         uint256 tokenId,
839         bytes calldata data
840     ) external;
841 }
842 
843 
844 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
845 
846 
847 
848 pragma solidity ^0.8.0;
849 
850 
851 /**
852  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
853  * @dev See https://eips.ethereum.org/EIPS/eip-721
854  */
855 interface IERC721Metadata is IERC721 {
856     /**
857      * @dev Returns the token collection name.
858      */
859     function name() external view returns (string memory);
860 
861     /**
862      * @dev Returns the token collection symbol.
863      */
864     function symbol() external view returns (string memory);
865 
866     /**
867      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
868      */
869     function tokenURI(uint256 tokenId) external view returns (string memory);
870 }
871 
872 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
873 
874 
875 
876 pragma solidity ^0.8.0;
877 
878 /**
879  * @title ERC721 token receiver interface
880  * @dev Interface for any contract that wants to support safeTransfers
881  * from ERC721 asset contracts.
882  */
883 interface IERC721Receiver {
884     /**
885      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
886      * by `operator` from `from`, this function is called.
887      *
888      * It must return its Solidity selector to confirm the token transfer.
889      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
890      *
891      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
892      */
893     function onERC721Received(
894         address operator,
895         address from,
896         uint256 tokenId,
897         bytes calldata data
898     ) external returns (bytes4);
899 }
900 
901 
902 
903 
904 
905 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
906 
907 
908 
909 pragma solidity ^0.8.0;
910 
911 
912 
913 
914 
915 
916 
917 
918 /**
919  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
920  * the Metadata extension, but not including the Enumerable extension, which is available separately as
921  * {ERC721Enumerable}.
922  */
923 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
924     using Address for address;
925     using Strings for uint256;
926 
927     // Token name
928     string private _name;
929 
930     // Token symbol
931     string private _symbol;
932 
933     // Mapping from token ID to owner address
934     mapping(uint256 => address) private _owners;
935 
936     // Mapping owner address to token count
937     mapping(address => uint256) private _balances;
938 
939     // Mapping from token ID to approved address
940     mapping(uint256 => address) private _tokenApprovals;
941 
942     // Mapping from owner to operator approvals
943     mapping(address => mapping(address => bool)) private _operatorApprovals;
944 
945     /**
946      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
947      */
948     constructor(string memory name_, string memory symbol_) {
949         _name = name_;
950         _symbol = symbol_;
951     }
952 
953     /**
954      * @dev See {IERC165-supportsInterface}.
955      */
956     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
957         return
958             interfaceId == type(IERC721).interfaceId ||
959             interfaceId == type(IERC721Metadata).interfaceId ||
960             super.supportsInterface(interfaceId);
961     }
962 
963     /**
964      * @dev See {IERC721-balanceOf}.
965      */
966     function balanceOf(address owner) public view virtual override returns (uint256) {
967         require(owner != address(0), "ERC721: balance query for the zero address");
968         return _balances[owner];
969     }
970 
971     /**
972      * @dev See {IERC721-ownerOf}.
973      */
974     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
975         address owner = _owners[tokenId];
976         require(owner != address(0), "ERC721: owner query for nonexistent token");
977         return owner;
978     }
979 
980     /**
981      * @dev See {IERC721Metadata-name}.
982      */
983     function name() public view virtual override returns (string memory) {
984         return _name;
985     }
986 
987     /**
988      * @dev See {IERC721Metadata-symbol}.
989      */
990     function symbol() public view virtual override returns (string memory) {
991         return _symbol;
992     }
993 
994     /**
995      * @dev See {IERC721Metadata-tokenURI}.
996      */
997     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
998         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
999 
1000         string memory baseURI = _baseURI();
1001         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1002     }
1003 
1004     /**
1005      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1006      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1007      * by default, can be overriden in child contracts.
1008      */
1009     function _baseURI() internal view virtual returns (string memory) {
1010         return "";
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-approve}.
1015      */
1016     function approve(address to, uint256 tokenId) public virtual override {
1017         address owner = ERC721.ownerOf(tokenId);
1018         require(to != owner, "ERC721: approval to current owner");
1019 
1020         require(
1021             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1022             "ERC721: approve caller is not owner nor approved for all"
1023         );
1024 
1025         _approve(to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-getApproved}.
1030      */
1031     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1032         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1033 
1034         return _tokenApprovals[tokenId];
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-setApprovalForAll}.
1039      */
1040     function setApprovalForAll(address operator, bool approved) public virtual override {
1041         require(operator != _msgSender(), "ERC721: approve to caller");
1042 
1043         _operatorApprovals[_msgSender()][operator] = approved;
1044         emit ApprovalForAll(_msgSender(), operator, approved);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-isApprovedForAll}.
1049      */
1050     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1051         return _operatorApprovals[owner][operator];
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-transferFrom}.
1056      */
1057     function transferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) public virtual override {
1062         //solhint-disable-next-line max-line-length
1063         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1064 
1065         _transfer(from, to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-safeTransferFrom}.
1070      */
1071     function safeTransferFrom(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) public virtual override {
1076         safeTransferFrom(from, to, tokenId, "");
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-safeTransferFrom}.
1081      */
1082     function safeTransferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId,
1086         bytes memory _data
1087     ) public virtual override {
1088         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1089         _safeTransfer(from, to, tokenId, _data);
1090     }
1091 
1092     /**
1093      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1094      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1095      *
1096      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1097      *
1098      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1099      * implement alternative mechanisms to perform token transfer, such as signature-based.
1100      *
1101      * Requirements:
1102      *
1103      * - `from` cannot be the zero address.
1104      * - `to` cannot be the zero address.
1105      * - `tokenId` token must exist and be owned by `from`.
1106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _safeTransfer(
1111         address from,
1112         address to,
1113         uint256 tokenId,
1114         bytes memory _data
1115     ) internal virtual {
1116         _transfer(from, to, tokenId);
1117         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1118     }
1119 
1120     /**
1121      * @dev Returns whether `tokenId` exists.
1122      *
1123      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1124      *
1125      * Tokens start existing when they are minted (`_mint`),
1126      * and stop existing when they are burned (`_burn`).
1127      */
1128     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1129         return _owners[tokenId] != address(0);
1130     }
1131 
1132     /**
1133      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1134      *
1135      * Requirements:
1136      *
1137      * - `tokenId` must exist.
1138      */
1139     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1140         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1141         address owner = ERC721.ownerOf(tokenId);
1142         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1143     }
1144 
1145     /**
1146      * @dev Safely mints `tokenId` and transfers it to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - `tokenId` must not exist.
1151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _safeMint(address to, uint256 tokenId) internal virtual {
1156         _safeMint(to, tokenId, "");
1157     }
1158 
1159     /**
1160      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1161      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1162      */
1163     function _safeMint(
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) internal virtual {
1168         _mint(to, tokenId);
1169         require(
1170             _checkOnERC721Received(address(0), to, tokenId, _data),
1171             "ERC721: transfer to non ERC721Receiver implementer"
1172         );
1173     }
1174 
1175     /**
1176      * @dev Mints `tokenId` and transfers it to `to`.
1177      *
1178      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1179      *
1180      * Requirements:
1181      *
1182      * - `tokenId` must not exist.
1183      * - `to` cannot be the zero address.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _mint(address to, uint256 tokenId) internal virtual {
1188         require(to != address(0), "ERC721: mint to the zero address");
1189         require(!_exists(tokenId), "ERC721: token already minted");
1190 
1191         _beforeTokenTransfer(address(0), to, tokenId);
1192 
1193         _balances[to] += 1;
1194         _owners[tokenId] = to;
1195 
1196         emit Transfer(address(0), to, tokenId);
1197     }
1198 
1199     /**
1200      * @dev Destroys `tokenId`.
1201      * The approval is cleared when the token is burned.
1202      *
1203      * Requirements:
1204      *
1205      * - `tokenId` must exist.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _burn(uint256 tokenId) internal virtual {
1210         address owner = ERC721.ownerOf(tokenId);
1211 
1212         _beforeTokenTransfer(owner, address(0), tokenId);
1213 
1214         // Clear approvals
1215         _approve(address(0), tokenId);
1216 
1217         _balances[owner] -= 1;
1218         delete _owners[tokenId];
1219 
1220         emit Transfer(owner, address(0), tokenId);
1221     }
1222 
1223     /**
1224      * @dev Transfers `tokenId` from `from` to `to`.
1225      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1226      *
1227      * Requirements:
1228      *
1229      * - `to` cannot be the zero address.
1230      * - `tokenId` token must be owned by `from`.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function _transfer(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) internal virtual {
1239         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1240         require(to != address(0), "ERC721: transfer to the zero address");
1241 
1242         _beforeTokenTransfer(from, to, tokenId);
1243 
1244         // Clear approvals from the previous owner
1245         _approve(address(0), tokenId);
1246 
1247         _balances[from] -= 1;
1248         _balances[to] += 1;
1249         _owners[tokenId] = to;
1250 
1251         emit Transfer(from, to, tokenId);
1252     }
1253 
1254     /**
1255      * @dev Approve `to` to operate on `tokenId`
1256      *
1257      * Emits a {Approval} event.
1258      */
1259     function _approve(address to, uint256 tokenId) internal virtual {
1260         _tokenApprovals[tokenId] = to;
1261         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1262     }
1263 
1264     /**
1265      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1266      * The call is not executed if the target address is not a contract.
1267      *
1268      * @param from address representing the previous owner of the given token ID
1269      * @param to target address that will receive the tokens
1270      * @param tokenId uint256 ID of the token to be transferred
1271      * @param _data bytes optional data to send along with the call
1272      * @return bool whether the call correctly returned the expected magic value
1273      */
1274     function _checkOnERC721Received(
1275         address from,
1276         address to,
1277         uint256 tokenId,
1278         bytes memory _data
1279     ) private returns (bool) {
1280         if (to.isContract()) {
1281             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1282                 return retval == IERC721Receiver.onERC721Received.selector;
1283             } catch (bytes memory reason) {
1284                 if (reason.length == 0) {
1285                     revert("ERC721: transfer to non ERC721Receiver implementer");
1286                 } else {
1287                     assembly {
1288                         revert(add(32, reason), mload(reason))
1289                     }
1290                 }
1291             }
1292         } else {
1293             return true;
1294         }
1295     }
1296 
1297     /**
1298      * @dev Hook that is called before any token transfer. This includes minting
1299      * and burning.
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` will be minted for `to`.
1306      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1307      * - `from` and `to` are never both zero.
1308      *
1309      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1310      */
1311     function _beforeTokenTransfer(
1312         address from,
1313         address to,
1314         uint256 tokenId
1315     ) internal virtual {}
1316 }
1317 
1318 // File: contracts/Lootlang.sol
1319 
1320 
1321 
1322 pragma solidity ^0.8.7;
1323 
1324 
1325 
1326 // IMPORTS //
1327 
1328 /**
1329  * @dev ERC721 token standard
1330  */
1331 
1332 
1333 /**
1334  * @dev Modifier 'onlyOwner' becomes available where owner is the contract deployer
1335  */
1336 
1337 
1338 /**
1339  * @dev Verification of Merkle trees
1340  */
1341 
1342 
1343 /**
1344  * @dev Generates words etc
1345  */
1346 
1347 
1348 
1349 // LIBRARIES //
1350 
1351 /// [MIT License]
1352 /// @title Base64
1353 /// @notice Provides a function for encoding some bytes in base64
1354 /// @author Brecht Devos <brecht@loopring.org>
1355 library Base64 {
1356     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1357 
1358     /// @notice Encodes some bytes to the base64 representation
1359     function encode(bytes memory data) internal pure returns (string memory) {
1360         uint256 len = data.length;
1361         if (len == 0) return "";
1362 
1363         // multiply by 4/3 rounded up
1364         uint256 encodedLen = 4 * ((len + 2) / 3);
1365 
1366         // Add some extra buffer at the end
1367         bytes memory result = new bytes(encodedLen + 32);
1368 
1369         bytes memory table = TABLE;
1370 
1371         assembly {
1372             let tablePtr := add(table, 1)
1373             let resultPtr := add(result, 32)
1374 
1375             for {
1376                 let i := 0
1377             } lt(i, len) {
1378 
1379             } {
1380                 i := add(i, 3)
1381                 let input := and(mload(add(data, i)), 0xffffff)
1382 
1383                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1384                 out := shl(8, out)
1385                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1386                 out := shl(8, out)
1387                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1388                 out := shl(8, out)
1389                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1390                 out := shl(224, out)
1391 
1392                 mstore(resultPtr, out)
1393 
1394                 resultPtr := add(resultPtr, 4)
1395             }
1396 
1397             switch mod(len, 3)
1398             case 1 {
1399                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1400             }
1401             case 2 {
1402                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1403             }
1404 
1405             mstore(result, encodedLen)
1406         }
1407 
1408         return string(result);
1409     }
1410 }
1411 
1412 
1413 
1414 
1415 
1416 
1417 //  CONTRACT //  
1418 
1419 contract Lootlang is ERC721, Ownable, Gen {
1420     
1421     
1422     // VARIABLES //
1423     
1424     uint public enabled;
1425     uint internal mints; 
1426     uint internal claims; 
1427     uint internal nextTokenId;
1428     uint public contractBalance;
1429     string internal contractURIstring;
1430     uint public freezeBlock;
1431     uint internal freezeBlockChanges;
1432     bytes32 internal root;
1433 
1434     
1435     constructor() Ownable() ERC721('Lootlang', 'LANG') {
1436 
1437         nextTokenId = 1;
1438         
1439         freezeBlock = 13487654;
1440         
1441         contractURIstring = "https://lootlang.com/metadata.json";
1442         
1443         mapChars(); // maps characters to uints
1444         
1445     }
1446 
1447 
1448     // EVENTS //
1449     
1450     event Shuffled(uint tokenId);
1451 
1452 
1453 
1454     // ONLY OWNER FUNCTIONS //
1455     
1456     /**
1457      * @dev Set the root for Merkle Proof
1458      */
1459     function setRoot(bytes32 _newRoot) external onlyOwner {
1460         root = _newRoot;
1461     }
1462     
1463     
1464     /**
1465      * @dev Set the new block number to freeze shuffling. Can only be called once.
1466      */
1467     function setFreezeBlock(uint _newFreezeBlockNumber) external onlyOwner {
1468         require(freezeBlockChanges < 1, "Freeze block already changed");
1469         freezeBlock = _newFreezeBlockNumber;
1470         freezeBlockChanges++;
1471     }
1472     
1473 
1474     /**
1475      * @dev Withdraw '_amount' of Ether to address '_to'. Only contract owner can call.
1476      * @param _to - address Ether will be sent to
1477      * @param _amount - amount of Ether, in Wei, to be withdrawn
1478      */
1479     function withdrawFunds(address payable _to, uint _amount) external onlyOwner {
1480         require(_amount <= contractBalance, "Withdrawal amount greater than balance");
1481         contractBalance -= _amount;
1482         _to.transfer(_amount);
1483     }
1484 
1485 
1486     /**
1487      * @dev activates/deactivates the minting functionality - only the contract owner can call
1488      * @param _enabled where 1 = enabled and 0 = not
1489      */
1490     function setEnable(uint _enabled) external onlyOwner {
1491         enabled = _enabled;
1492     }
1493     
1494     
1495     /**
1496      * @dev Set the contract's URI
1497      * @param _contractURIstring - web address containing data read by OpenSea
1498      */
1499     function setContractURI(string memory _contractURIstring) external onlyOwner {
1500         contractURIstring = _contractURIstring;
1501     }
1502     
1503 
1504     // USER FUNCTIONS // 
1505     
1506 
1507     /**
1508      * @dev Mint an ERC721 token. 
1509      */
1510     function mint() external payable {
1511         require(enabled == 1, "Minting is yet to be enabled");
1512         require(nextTokenId <= 10000 && mints <= 9700, "All NFTs have been minted");
1513         require(msg.value >= (2*10**16), "Insufficient funds provided"); // 0.02 eth (cost of minting an NFT) // SET MINT PRICE
1514 
1515         mints++;
1516         contractBalance += msg.value;
1517         sharedMintCode();
1518     }
1519     
1520     /**
1521      * @dev Claim and mint an ERC721 token.
1522      */
1523     function claim(bytes32[] memory proof) external { 
1524         require(enabled == 1, "Minting is yet to be enabled");
1525         require(hasClaimed[msg.sender] == false, "Already claimed");
1526         require(nextTokenId <= 10000 && claims <= 300, "All NFTs have been minted");
1527 
1528         require(MerkleProof.verify(proof, root, keccak256(abi.encodePacked(msg.sender))) == true, "Not on pre-approved claim list");
1529 
1530         claims++;
1531         hasClaimed[msg.sender] = true;
1532         sharedMintCode();
1533     }
1534     
1535     /**
1536      * @dev Shared code used by both 'mint()' and 'claim()' functions.
1537      */
1538     function sharedMintCode() internal {
1539         uint tokenId = nextTokenId;
1540         nextTokenId++;
1541         tokenIdToSeed[tokenId] = uint(keccak256(abi.encodePacked(tokenId, msg.sender, block.timestamp)))%1000000;
1542         _safeMint(msg.sender, tokenId);
1543     }
1544 
1545 
1546     /**
1547      * @dev Shuffles up to 8 words. Set input params as 1 to shuffle word, and 0 to leave it. 
1548      *      E.g. shuffle(243,1,0,0,0,0,0,0,1) shuffles the 1st and 8th word of token 243.
1549      */
1550     function shuffle(uint _tokenId, uint one, uint two, uint three, uint four, uint five, uint six, uint seven, uint eight) external {
1551         require(ownerOf(_tokenId) == msg.sender, "Must be NFT owner");
1552         require(shuffleCount[_tokenId] < 5, "Shuffled max amount already");
1553         require(block.number < freezeBlock, "Shuffling has been frozen!");
1554         require((one+two+three+four+five+six+seven+eight) > 0, "No words selected to be shuffled"); 
1555        
1556         uint randomish = uint(keccak256(abi.encodePacked(block.number)))%1000000;
1557         uint[8] memory indexesToChange = [one, two, three, four, five, six, seven, eight];
1558         
1559         for (uint i=0; i<8; i++) {
1560             if (indexesToChange[i] > 0) {
1561                 tokenIdToShuffleShift[_tokenId][i] += randomish;
1562             }
1563         }
1564         
1565         shuffleCount[_tokenId]++;
1566         emit Shuffled(_tokenId);
1567     }
1568     
1569 
1570 
1571 
1572     // VIEW FUNCTIONS //
1573     
1574     
1575     /**
1576      * @dev View total number of minted tokens
1577      */
1578     function totalSupply() external view returns(uint) {
1579         return mints+claims;
1580     }
1581     
1582     /**
1583      * @dev View the contract URI.
1584      */
1585     function contractURI() public view returns (string memory) {
1586         return contractURIstring;
1587     }
1588 
1589     /**
1590      * @dev Internal function used by function 'tokenURI()' to format word lengths for .json file output
1591      */
1592     function getMetaText(string memory word) internal pure returns(string memory) {
1593         string memory length = string(abi.encodePacked("\"", toString(stringLength(word)), " letters", "\""));
1594         return length;
1595     }
1596     
1597     /**
1598      * @dev Internal function used by function 'tokenURI()' to format words for .json file output
1599      */
1600     function getMetaWord(string memory word) internal pure returns(string memory) {
1601         string memory length = string(abi.encodePacked("\"", word, "\""));
1602         return length;
1603     }
1604     
1605     /**
1606      * @dev Creates seed passed in to 'generateWord()' function for seeding randomness
1607      */
1608     function totalSeedGen(uint tokenId, uint wordNum) internal view returns(uint) {
1609         return uint(keccak256(abi.encodePacked(uint(wordNum), tokenIdToSeed[tokenId], tokenIdToShuffleShift[tokenId][wordNum-1])));
1610     }
1611     
1612     /**
1613      * @dev View tokenURI of 'tokenId'. 
1614      */
1615     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1616         
1617         require(_exists(tokenId), "URI query for nonexistent token");
1618 
1619         string[17] memory parts;
1620         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 20px; }</style><rect width="100%" height="100%" fill="black" /><text x="15" y="30" class="base">';
1621         parts[1] = generateWord(tokenId, totalSeedGen(tokenId, 1));
1622         parts[2] = '</text><text x="15" y="65" class="base">';
1623         parts[3] = generateWord(tokenId, totalSeedGen(tokenId, 2));
1624         parts[4] = '</text><text x="15" y="100" class="base">';
1625         parts[5] = generateWord(tokenId, totalSeedGen(tokenId, 3));
1626         parts[6] = '</text><text x="15" y="135" class="base">';
1627         parts[7] = generateWord(tokenId, totalSeedGen(tokenId, 4));
1628         parts[8] = '</text><text x="15" y="170" class="base">';
1629         parts[9] = generateWord(tokenId, totalSeedGen(tokenId, 5));
1630         parts[10] = '</text><text x="15" y="205" class="base">';
1631         parts[11] = generateWord(tokenId, totalSeedGen(tokenId, 6));
1632         parts[12] = '</text><text x="15" y="240" class="base">';
1633         parts[13] = generateWord(tokenId, totalSeedGen(tokenId, 7));
1634         parts[14] = '</text><text x="15" y="275" class="base">';
1635         parts[15] = generateWord(tokenId, totalSeedGen(tokenId, 8));
1636         parts[16] = '</text></svg>';
1637 
1638         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1639         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1640         
1641         string memory json = string(abi.encodePacked('{"name": "Pack #', toString(tokenId), '", "description": "Pack of 8 Lootlang words", "attributes": [{"trait_type": "Shuffles Used", "value":', getMetaWord(toString(shuffleCount[tokenId])), '}, {"trait_type": "Word Length", "value":', getMetaText(parts[1]), '}, {"trait_type": "Word Length", "value":', getMetaText(parts[3]), '}, {"trait_type": "Word Length", "value":', getMetaText(parts[5]), '}, {"trait_type": "Word Length", "value":', getMetaText(parts[7]), '}, {"trait_type": "Word Length", "value":', getMetaText(parts[9]), '}, {"trait_type": "Word Length", "value":', getMetaText(parts[11]), '}, {"trait_type": "Word Length", "value":', getMetaText(parts[13]), '}, {"trait_type": "Word Length", "value":', getMetaText(parts[15]), '}'));
1642         json = Base64.encode(bytes(string(abi.encodePacked(json, ', {"trait_type": "Word", "value":', getMetaWord(parts[1]), '}, {"trait_type": "Word", "value":', getMetaWord(parts[3]), '}, {"trait_type": "Word", "value":', getMetaWord(parts[5]), '}, {"trait_type": "Word", "value":', getMetaWord(parts[7]), '}, {"trait_type": "Word", "value":', getMetaWord(parts[9]), '}, {"trait_type": "Word", "value":', getMetaWord(parts[11]), '}, {"trait_type": "Word", "value":', getMetaWord(parts[13]), '}, {"trait_type": "Word", "value":', getMetaWord(parts[15]), '}], "image": "data:image/svg+xml;base64, ', Base64.encode(bytes(output)), '"}'))));
1643         
1644         output = string(abi.encodePacked('data:application/json;base64,', json));
1645         return output;
1646     }
1647     
1648 
1649 }