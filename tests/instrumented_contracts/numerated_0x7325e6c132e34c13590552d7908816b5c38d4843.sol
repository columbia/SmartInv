1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.14;
3 
4 /*
5 *  The Second half - Discover the MANDOX
6 *  One contract - Five Drops
7 *  www.twitter.com/officialmandox
8 *  www.mandoxglobal.com
9 *  www.mandoxmint.com
10 *  t.me/officialmandox
11 */
12 
13 // File: solidity-bits/contracts/Popcount.sol
14 
15 /**
16    _____       ___     ___ __           ____  _ __      
17   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
18   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
19  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
20 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
21                            /____/                        
22 
23 - npm: https://www.npmjs.com/package/solidity-bits
24 - github: https://github.com/estarriolvetch/solidity-bits
25 
26  */
27 
28 //pragma solidity ^0.8.0;
29 
30 library Popcount {
31     uint256 private constant m1 = 0x5555555555555555555555555555555555555555555555555555555555555555;
32     uint256 private constant m2 = 0x3333333333333333333333333333333333333333333333333333333333333333;
33     uint256 private constant m4 = 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f;
34     uint256 private constant h01 = 0x0101010101010101010101010101010101010101010101010101010101010101;
35 
36     function popcount256A(uint256 x) internal pure returns (uint256 count) {
37         unchecked{
38             for (count=0; x!=0; count++)
39                 x &= x - 1;
40         }
41     }
42 
43     function popcount256B(uint256 x) internal pure returns (uint256) {
44         if (x == type(uint256).max) {
45             return 256;
46         }
47         unchecked {
48             x -= (x >> 1) & m1;             //put count of each 2 bits into those 2 bits
49             x = (x & m2) + ((x >> 2) & m2); //put count of each 4 bits into those 4 bits 
50             x = (x + (x >> 4)) & m4;        //put count of each 8 bits into those 8 bits 
51             x = (x * h01) >> 248;  //returns left 8 bits of x + (x<<8) + (x<<16) + (x<<24) + ... 
52         }
53         return x;
54     }
55 }
56 // File: solidity-bits/contracts/BitScan.sol
57 
58 
59 /**
60    _____       ___     ___ __           ____  _ __      
61   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
62   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
63  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
64 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
65                            /____/                        
66 
67 - npm: https://www.npmjs.com/package/solidity-bits
68 - github: https://github.com/estarriolvetch/solidity-bits
69 
70  */
71 
72 //pragma solidity ^0.8.0;
73 
74 
75 library BitScan {
76     uint256 constant private DEBRUIJN_256 = 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
77     bytes constant private LOOKUP_TABLE_256 = hex"0001020903110a19042112290b311a3905412245134d2a550c5d32651b6d3a7506264262237d468514804e8d2b95569d0d495ea533a966b11c886eb93bc176c9071727374353637324837e9b47af86c7155181ad4fd18ed32c9096db57d59ee30e2e4a6a5f92a6be3498aae067ddb2eb1d5989b56fd7baf33ca0c2ee77e5caf7ff0810182028303840444c545c646c7425617c847f8c949c48a4a8b087b8c0c816365272829aaec650acd0d28fdad4e22d6991bd97dfdcea58b4d6f29fede4f6fe0f1f2f3f4b5b6b607b8b93a3a7b7bf357199c5abcfd9e168bcdee9b3f1ecf5fd1e3e5a7a8aa2b670c4ced8bbe8f0f4fc3d79a1c3cde7effb78cce6facbf9f8";
78 
79     /**
80         @dev Isolate the least significant set bit.
81      */ 
82     function isolateLS1B256(uint256 bb) pure internal returns (uint256) {
83         require(bb > 0);
84         unchecked {
85             return bb & (0 - bb);
86         }
87     } 
88 
89     /**
90         @dev Isolate the most significant set bit.
91      */ 
92     function isolateMS1B256(uint256 bb) pure internal returns (uint256) {
93         require(bb > 0);
94         unchecked {
95             bb |= bb >> 128;
96             bb |= bb >> 64;
97             bb |= bb >> 32;
98             bb |= bb >> 16;
99             bb |= bb >> 8;
100             bb |= bb >> 4;
101             bb |= bb >> 2;
102             bb |= bb >> 1;
103             
104             return (bb >> 1) + 1;
105         }
106     } 
107 
108     /**
109         @dev Find the index of the lest significant set bit. (trailing zero count)
110      */ 
111     function bitScanForward256(uint256 bb) pure internal returns (uint8) {
112         unchecked {
113             return uint8(LOOKUP_TABLE_256[(isolateLS1B256(bb) * DEBRUIJN_256) >> 248]);
114         }   
115     }
116 
117     /**
118         @dev Find the index of the most significant set bit.
119      */ 
120     function bitScanReverse256(uint256 bb) pure internal returns (uint8) {
121         unchecked {
122             return 255 - uint8(LOOKUP_TABLE_256[((isolateMS1B256(bb) * DEBRUIJN_256) >> 248)]);
123         }   
124     }
125 
126     function log2(uint256 bb) pure internal returns (uint8) {
127         unchecked {
128             return uint8(LOOKUP_TABLE_256[(isolateMS1B256(bb) * DEBRUIJN_256) >> 248]);
129         } 
130     }
131 }
132 
133 // File: solidity-bits/contracts/BitMaps.sol
134 
135 
136 /**
137    _____       ___     ___ __           ____  _ __      
138   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
139   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
140  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
141 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
142                            /____/                        
143 
144 - npm: https://www.npmjs.com/package/solidity-bits
145 - github: https://github.com/estarriolvetch/solidity-bits
146 
147  */
148 //pragma solidity ^0.8.0;
149 
150 
151 
152 /**
153  * @dev This Library is a modified version of Openzeppelin's BitMaps library with extra features.
154  *
155  * 1. Functions of finding the index of the closest set bit from a given index are added.
156  *    The indexing of each bucket is modifed to count from the MSB to the LSB instead of from the LSB to the MSB.
157  *    The modification of indexing makes finding the closest previous set bit more efficient in gas usage.
158  * 2. Setting and unsetting the bitmap consecutively.
159  * 3. Accounting number of set bits within a given range.   
160  *
161 */
162 
163 /**
164  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
165  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
166  */
167 
168 library BitMaps {
169     using BitScan for uint256;
170     uint256 private constant MASK_INDEX_ZERO = (1 << 255);
171     uint256 private constant MASK_FULL = type(uint256).max;
172 
173     struct BitMap {
174         mapping(uint256 => uint256) _data;
175     }
176 
177     /**
178      * @dev Returns whether the bit at `index` is set.
179      */
180     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
181         uint256 bucket = index >> 8;
182         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
183         return bitmap._data[bucket] & mask != 0;
184     }
185 
186     /**
187      * @dev Sets the bit at `index` to the boolean `value`.
188      */
189     function setTo(
190         BitMap storage bitmap,
191         uint256 index,
192         bool value
193     ) internal {
194         if (value) {
195             set(bitmap, index);
196         } else {
197             unset(bitmap, index);
198         }
199     }
200 
201     /**
202      * @dev Sets the bit at `index`.
203      */
204     function set(BitMap storage bitmap, uint256 index) internal {
205         uint256 bucket = index >> 8;
206         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
207         bitmap._data[bucket] |= mask;
208     }
209 
210     /**
211      * @dev Unsets the bit at `index`.
212      */
213     function unset(BitMap storage bitmap, uint256 index) internal {
214         uint256 bucket = index >> 8;
215         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
216         bitmap._data[bucket] &= ~mask;
217     }
218 
219 
220     /**
221      * @dev Consecutively sets `amount` of bits starting from the bit at `startIndex`.
222      */    
223     function setBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
224         uint256 bucket = startIndex >> 8;
225 
226         uint256 bucketStartIndex = (startIndex & 0xff);
227 
228         unchecked {
229             if(bucketStartIndex + amount < 256) {
230                 bitmap._data[bucket] |= MASK_FULL << (256 - amount) >> bucketStartIndex;
231             } else {
232                 bitmap._data[bucket] |= MASK_FULL >> bucketStartIndex;
233                 amount -= (256 - bucketStartIndex);
234                 bucket++;
235 
236                 while(amount > 256) {
237                     bitmap._data[bucket] = MASK_FULL;
238                     amount -= 256;
239                     bucket++;
240                 }
241 
242                 bitmap._data[bucket] |= MASK_FULL << (256 - amount);
243             }
244         }
245     }
246 
247 
248     /**
249      * @dev Consecutively unsets `amount` of bits starting from the bit at `startIndex`.
250      */    
251     function unsetBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
252         uint256 bucket = startIndex >> 8;
253 
254         uint256 bucketStartIndex = (startIndex & 0xff);
255 
256         unchecked {
257             if(bucketStartIndex + amount < 256) {
258                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount) >> bucketStartIndex);
259             } else {
260                 bitmap._data[bucket] &= ~(MASK_FULL >> bucketStartIndex);
261                 amount -= (256 - bucketStartIndex);
262                 bucket++;
263 
264                 while(amount > 256) {
265                     bitmap._data[bucket] = 0;
266                     amount -= 256;
267                     bucket++;
268                 }
269 
270                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount));
271             }
272         }
273     }
274 
275     /**
276      * @dev Returns number of set bits within a range.
277      */
278     function popcountA(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
279         uint256 bucket = startIndex >> 8;
280 
281         uint256 bucketStartIndex = (startIndex & 0xff);
282 
283         unchecked {
284             if(bucketStartIndex + amount < 256) {
285                 count +=  Popcount.popcount256A(
286                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
287                 );
288             } else {
289                 count += Popcount.popcount256A(
290                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
291                 );
292                 amount -= (256 - bucketStartIndex);
293                 bucket++;
294 
295                 while(amount > 256) {
296                     count += Popcount.popcount256A(bitmap._data[bucket]);
297                     amount -= 256;
298                     bucket++;
299                 }
300                 count += Popcount.popcount256A(
301                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
302                 );
303             }
304         }
305     }
306 
307     /**
308      * @dev Returns number of set bits within a range.
309      */
310     function popcountB(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
311         uint256 bucket = startIndex >> 8;
312 
313         uint256 bucketStartIndex = (startIndex & 0xff);
314 
315         unchecked {
316             if(bucketStartIndex + amount < 256) {
317                 count +=  Popcount.popcount256B(
318                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
319                 );
320             } else {
321                 count += Popcount.popcount256B(
322                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
323                 );
324                 amount -= (256 - bucketStartIndex);
325                 bucket++;
326 
327                 while(amount > 256) {
328                     count += Popcount.popcount256B(bitmap._data[bucket]);
329                     amount -= 256;
330                     bucket++;
331                 }
332                 count += Popcount.popcount256B(
333                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
334                 );
335             }
336         }
337     }
338 
339 
340     /**
341      * @dev Find the closest index of the set bit before `index`.
342      */
343     function scanForward(BitMap storage bitmap, uint256 index) internal view returns (uint256 setBitIndex) {
344         uint256 bucket = index >> 8;
345 
346         // index within the bucket
347         uint256 bucketIndex = (index & 0xff);
348 
349         // load a bitboard from the bitmap.
350         uint256 bb = bitmap._data[bucket];
351 
352         // offset the bitboard to scan from `bucketIndex`.
353         bb = bb >> (0xff ^ bucketIndex); // bb >> (255 - bucketIndex)
354         
355         if(bb > 0) {
356             unchecked {
357                 setBitIndex = (bucket << 8) | (bucketIndex -  bb.bitScanForward256());    
358             }
359         } else {
360             while(true) {
361                 require(bucket > 0, "BitMaps: The set bit before the index doesn't exist.");
362                 unchecked {
363                     bucket--;
364                 }
365                 // No offset. Always scan from the least significiant bit now.
366                 bb = bitmap._data[bucket];
367                 
368                 if(bb > 0) {
369                     unchecked {
370                         setBitIndex = (bucket << 8) | (255 -  bb.bitScanForward256());
371                         break;
372                     }
373                 } 
374             }
375         }
376     }
377 
378     function getBucket(BitMap storage bitmap, uint256 bucket) internal view returns (uint256) {
379         return bitmap._data[bucket];
380     }
381 }
382 
383 // File: @openzeppelin/contracts/utils/StorageSlot.sol
384 
385 
386 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
387 
388 //pragma solidity ^0.8.0;
389 
390 /**
391  * @dev Library for reading and writing primitive types to specific storage slots.
392  *
393  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
394  * This library helps with reading and writing to such slots without the need for inline assembly.
395  *
396  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
397  *
398  * Example usage to set ERC1967 implementation slot:
399  * ```
400  * contract ERC1967 {
401  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
402  *
403  *     function _getImplementation() internal view returns (address) {
404  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
405  *     }
406  *
407  *     function _setImplementation(address newImplementation) internal {
408  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
409  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
410  *     }
411  * }
412  * ```
413  *
414  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
415  */
416 library StorageSlot {
417     struct AddressSlot {
418         address value;
419     }
420 
421     struct BooleanSlot {
422         bool value;
423     }
424 
425     struct Bytes32Slot {
426         bytes32 value;
427     }
428 
429     struct Uint256Slot {
430         uint256 value;
431     }
432 
433     /**
434      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
435      */
436     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
437         /// @solidity memory-safe-assembly
438         assembly {
439             r.slot := slot
440         }
441     }
442 
443     /**
444      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
445      */
446     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
447         /// @solidity memory-safe-assembly
448         assembly {
449             r.slot := slot
450         }
451     }
452 
453     /**
454      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
455      */
456     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
457         /// @solidity memory-safe-assembly
458         assembly {
459             r.slot := slot
460         }
461     }
462 
463     /**
464      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
465      */
466     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
467         /// @solidity memory-safe-assembly
468         assembly {
469             r.slot := slot
470         }
471     }
472 }
473 
474 // File: @openzeppelin/contracts/utils/Address.sol
475 
476 
477 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
478 
479 //pragma solidity ^0.8.1;
480 
481 /**
482  * @dev Collection of functions related to the address type
483  */
484 library Address {
485     /**
486      * @dev Returns true if `account` is a contract.
487      *
488      * [IMPORTANT]
489      * ====
490      * It is unsafe to assume that an address for which this function returns
491      * false is an externally-owned account (EOA) and not a contract.
492      *
493      * Among others, `isContract` will return false for the following
494      * types of addresses:
495      *
496      *  - an externally-owned account
497      *  - a contract in construction
498      *  - an address where a contract will be created
499      *  - an address where a contract lived, but was destroyed
500      * ====
501      *
502      * [IMPORTANT]
503      * ====
504      * You shouldn't rely on `isContract` to protect against flash loan attacks!
505      *
506      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
507      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
508      * constructor.
509      * ====
510      */
511     function isContract(address account) internal view returns (bool) {
512         // This method relies on extcodesize/address.code.length, which returns 0
513         // for contracts in construction, since the code is only stored at the end
514         // of the constructor execution.
515 
516         return account.code.length > 0;
517     }
518 
519     /**
520      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
521      * `recipient`, forwarding all available gas and reverting on errors.
522      *
523      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
524      * of certain opcodes, possibly making contracts go over the 2300 gas limit
525      * imposed by `transfer`, making them unable to receive funds via
526      * `transfer`. {sendValue} removes this limitation.
527      *
528      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
529      *
530      * IMPORTANT: because control is transferred to `recipient`, care must be
531      * taken to not create reentrancy vulnerabilities. Consider using
532      * {ReentrancyGuard} or the
533      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
534      */
535     function sendValue(address payable recipient, uint256 amount) internal {
536         require(address(this).balance >= amount, "Address: insufficient balance");
537 
538         (bool success, ) = recipient.call{value: amount}("");
539         require(success, "Address: unable to send value, recipient may have reverted");
540     }
541 
542     /**
543      * @dev Performs a Solidity function call using a low level `call`. A
544      * plain `call` is an unsafe replacement for a function call: use this
545      * function instead.
546      *
547      * If `target` reverts with a revert reason, it is bubbled up by this
548      * function (like regular Solidity function calls).
549      *
550      * Returns the raw returned data. To convert to the expected return value,
551      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
552      *
553      * Requirements:
554      *
555      * - `target` must be a contract.
556      * - calling `target` with `data` must not revert.
557      *
558      * _Available since v3.1._
559      */
560     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionCall(target, data, "Address: low-level call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
566      * `errorMessage` as a fallback revert reason when `target` reverts.
567      *
568      * _Available since v3.1._
569      */
570     function functionCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         return functionCallWithValue(target, data, 0, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but also transferring `value` wei to `target`.
581      *
582      * Requirements:
583      *
584      * - the calling contract must have an ETH balance of at least `value`.
585      * - the called Solidity function must be `payable`.
586      *
587      * _Available since v3.1._
588      */
589     function functionCallWithValue(
590         address target,
591         bytes memory data,
592         uint256 value
593     ) internal returns (bytes memory) {
594         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
599      * with `errorMessage` as a fallback revert reason when `target` reverts.
600      *
601      * _Available since v3.1._
602      */
603     function functionCallWithValue(
604         address target,
605         bytes memory data,
606         uint256 value,
607         string memory errorMessage
608     ) internal returns (bytes memory) {
609         require(address(this).balance >= value, "Address: insufficient balance for call");
610         require(isContract(target), "Address: call to non-contract");
611 
612         (bool success, bytes memory returndata) = target.call{value: value}(data);
613         return verifyCallResult(success, returndata, errorMessage);
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
618      * but performing a static call.
619      *
620      * _Available since v3.3._
621      */
622     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
623         return functionStaticCall(target, data, "Address: low-level static call failed");
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
628      * but performing a static call.
629      *
630      * _Available since v3.3._
631      */
632     function functionStaticCall(
633         address target,
634         bytes memory data,
635         string memory errorMessage
636     ) internal view returns (bytes memory) {
637         require(isContract(target), "Address: static call to non-contract");
638 
639         (bool success, bytes memory returndata) = target.staticcall(data);
640         return verifyCallResult(success, returndata, errorMessage);
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
645      * but performing a delegate call.
646      *
647      * _Available since v3.4._
648      */
649     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
650         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
655      * but performing a delegate call.
656      *
657      * _Available since v3.4._
658      */
659     function functionDelegateCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal returns (bytes memory) {
664         require(isContract(target), "Address: delegate call to non-contract");
665 
666         (bool success, bytes memory returndata) = target.delegatecall(data);
667         return verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
672      * revert reason using the provided one.
673      *
674      * _Available since v4.3._
675      */
676     function verifyCallResult(
677         bool success,
678         bytes memory returndata,
679         string memory errorMessage
680     ) internal pure returns (bytes memory) {
681         if (success) {
682             return returndata;
683         } else {
684             // Look for revert reason and bubble it up if present
685             if (returndata.length > 0) {
686                 // The easiest way to bubble the revert reason is using memory via assembly
687                 /// @solidity memory-safe-assembly
688                 assembly {
689                     let returndata_size := mload(returndata)
690                     revert(add(32, returndata), returndata_size)
691                 }
692             } else {
693                 revert(errorMessage);
694             }
695         }
696     }
697 }
698 
699 // File: @openzeppelin/contracts/utils/Strings.sol
700 
701 
702 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
703 
704 //pragma solidity ^0.8.0;
705 
706 /**
707  * @dev String operations.
708  */
709 library Strings {
710     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
711     uint8 private constant _ADDRESS_LENGTH = 20;
712 
713     /**
714      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
715      */
716     function toString(uint256 value) internal pure returns (string memory) {
717         // Inspired by OraclizeAPI's implementation - MIT licence
718         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
719 
720         if (value == 0) {
721             return "0";
722         }
723         uint256 temp = value;
724         uint256 digits;
725         while (temp != 0) {
726             digits++;
727             temp /= 10;
728         }
729         bytes memory buffer = new bytes(digits);
730         while (value != 0) {
731             digits -= 1;
732             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
733             value /= 10;
734         }
735         return string(buffer);
736     }
737 
738     /**
739      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
740      */
741     function toHexString(uint256 value) internal pure returns (string memory) {
742         if (value == 0) {
743             return "0x00";
744         }
745         uint256 temp = value;
746         uint256 length = 0;
747         while (temp != 0) {
748             length++;
749             temp >>= 8;
750         }
751         return toHexString(value, length);
752     }
753 
754     /**
755      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
756      */
757     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
758         bytes memory buffer = new bytes(2 * length + 2);
759         buffer[0] = "0";
760         buffer[1] = "x";
761         for (uint256 i = 2 * length + 1; i > 1; --i) {
762             buffer[i] = _HEX_SYMBOLS[value & 0xf];
763             value >>= 4;
764         }
765         require(value == 0, "Strings: hex length insufficient");
766         return string(buffer);
767     }
768 
769     /**
770      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
771      */
772     function toHexString(address addr) internal pure returns (string memory) {
773         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
774     }
775 }
776 
777 // File: @openzeppelin/contracts/utils/Context.sol
778 
779 
780 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
781 
782 //pragma solidity ^0.8.0;
783 
784 /**
785  * @dev Provides information about the current execution context, including the
786  * sender of the transaction and its data. While these are generally available
787  * via msg.sender and msg.data, they should not be accessed in such a direct
788  * manner, since when dealing with meta-transactions the account sending and
789  * paying for execution may not be the actual sender (as far as an application
790  * is concerned).
791  *
792  * This contract is only required for intermediate, library-like contracts.
793  */
794 abstract contract Context {
795     function _msgSender() internal view virtual returns (address) {
796         return msg.sender;
797     }
798 
799     function _msgData() internal view virtual returns (bytes calldata) {
800         return msg.data;
801     }
802 }
803 
804 // File: @openzeppelin/contracts/access/Ownable.sol
805 
806 
807 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
808 
809 //pragma solidity ^0.8.0;
810 
811 
812 /**
813  * @dev Contract module which provides a basic access control mechanism, where
814  * there is an account (an owner) that can be granted exclusive access to
815  * specific functions.
816  *
817  * By default, the owner account will be the one that deploys the contract. This
818  * can later be changed with {transferOwnership}.
819  *
820  * This module is used through inheritance. It will make available the modifier
821  * `onlyOwner`, which can be applied to your functions to restrict their use to
822  * the owner.
823  */
824 abstract contract Ownable is Context {
825     address private _owner;
826 
827     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
828 
829     /**
830      * @dev Initializes the contract setting the deployer as the initial owner.
831      */
832     constructor() {
833         _transferOwnership(_msgSender());
834     }
835 
836     /**
837      * @dev Throws if called by any account other than the owner.
838      */
839     modifier onlyOwner() {
840         _checkOwner();
841         _;
842     }
843 
844     /**
845      * @dev Returns the address of the current owner.
846      */
847     function owner() public view virtual returns (address) {
848         return _owner;
849     }
850 
851     /**
852      * @dev Throws if the sender is not the owner.
853      */
854     function _checkOwner() internal view virtual {
855         require(owner() == _msgSender(), "Ownable: caller is not the owner");
856     }
857 
858     /**
859      * @dev Leaves the contract without owner. It will not be possible to call
860      * `onlyOwner` functions anymore. Can only be called by the current owner.
861      *
862      * NOTE: Renouncing ownership will leave the contract without an owner,
863      * thereby removing any functionality that is only available to the owner.
864      */
865     function renounceOwnership() public virtual onlyOwner {
866         _transferOwnership(address(0));
867     }
868 
869     /**
870      * @dev Transfers ownership of the contract to a new account (`newOwner`).
871      * Can only be called by the current owner.
872      */
873     function transferOwnership(address newOwner) public virtual onlyOwner {
874         require(newOwner != address(0), "Ownable: new owner is the zero address");
875         _transferOwnership(newOwner);
876     }
877 
878     /**
879      * @dev Transfers ownership of the contract to a new account (`newOwner`).
880      * Internal function without access restriction.
881      */
882     function _transferOwnership(address newOwner) internal virtual {
883         address oldOwner = _owner;
884         _owner = newOwner;
885         emit OwnershipTransferred(oldOwner, newOwner);
886     }
887 }
888 
889 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
890 
891 
892 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
893 
894 //pragma solidity ^0.8.0;
895 
896 /**
897  * @title ERC721 token receiver interface
898  * @dev Interface for any contract that wants to support safeTransfers
899  * from ERC721 asset contracts.
900  */
901 interface IERC721Receiver {
902     /**
903      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
904      * by `operator` from `from`, this function is called.
905      *
906      * It must return its Solidity selector to confirm the token transfer.
907      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
908      *
909      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
910      */
911     function onERC721Received(
912         address operator,
913         address from,
914         uint256 tokenId,
915         bytes calldata data
916     ) external returns (bytes4);
917 }
918 
919 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
920 
921 
922 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
923 
924 //pragma solidity ^0.8.0;
925 
926 /**
927  * @dev Interface of the ERC165 standard, as defined in the
928  * https://eips.ethereum.org/EIPS/eip-165[EIP].
929  *
930  * Implementers can declare support of contract interfaces, which can then be
931  * queried by others ({ERC165Checker}).
932  *
933  * For an implementation, see {ERC165}.
934  */
935 interface IERC165 {
936     /**
937      * @dev Returns true if this contract implements the interface defined by
938      * `interfaceId`. See the corresponding
939      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
940      * to learn more about how these ids are created.
941      *
942      * This function call must use less than 30 000 gas.
943      */
944     function supportsInterface(bytes4 interfaceId) external view returns (bool);
945 }
946 
947 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
948 
949 
950 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
951 
952 //pragma solidity ^0.8.0;
953 
954 
955 /**
956  * @dev Implementation of the {IERC165} interface.
957  *
958  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
959  * for the additional interface id that will be supported. For example:
960  *
961  * ```solidity
962  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
963  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
964  * }
965  * ```
966  *
967  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
968  */
969 abstract contract ERC165 is IERC165 {
970     /**
971      * @dev See {IERC165-supportsInterface}.
972      */
973     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
974         return interfaceId == type(IERC165).interfaceId;
975     }
976 }
977 
978 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
979 
980 
981 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
982 
983 //pragma solidity ^0.8.0;
984 
985 
986 /**
987  * @dev Required interface of an ERC721 compliant contract.
988  */
989 interface IERC721 is IERC165 {
990     /**
991      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
992      */
993     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
994 
995     /**
996      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
997      */
998     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
999 
1000     /**
1001      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1002      */
1003     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1004 
1005     /**
1006      * @dev Returns the number of tokens in ``owner``'s account.
1007      */
1008     function balanceOf(address owner) external view returns (uint256 balance);
1009 
1010     /**
1011      * @dev Returns the owner of the `tokenId` token.
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must exist.
1016      */
1017     function ownerOf(uint256 tokenId) external view returns (address owner);
1018 
1019     /**
1020      * @dev Safely transfers `tokenId` token from `from` to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `from` cannot be the zero address.
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must exist and be owned by `from`.
1027      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1028      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes calldata data
1037     ) external;
1038 
1039     /**
1040      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1041      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1042      *
1043      * Requirements:
1044      *
1045      * - `from` cannot be the zero address.
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must exist and be owned by `from`.
1048      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1049      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function safeTransferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) external;
1058 
1059     /**
1060      * @dev Transfers `tokenId` token from `from` to `to`.
1061      *
1062      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1063      *
1064      * Requirements:
1065      *
1066      * - `from` cannot be the zero address.
1067      * - `to` cannot be the zero address.
1068      * - `tokenId` token must be owned by `from`.
1069      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function transferFrom(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) external;
1078 
1079     /**
1080      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1081      * The approval is cleared when the token is transferred.
1082      *
1083      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1084      *
1085      * Requirements:
1086      *
1087      * - The caller must own the token or be an approved operator.
1088      * - `tokenId` must exist.
1089      *
1090      * Emits an {Approval} event.
1091      */
1092     function approve(address to, uint256 tokenId) external;
1093 
1094     /**
1095      * @dev Approve or remove `operator` as an operator for the caller.
1096      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1097      *
1098      * Requirements:
1099      *
1100      * - The `operator` cannot be the caller.
1101      *
1102      * Emits an {ApprovalForAll} event.
1103      */
1104     function setApprovalForAll(address operator, bool _approved) external;
1105 
1106     /**
1107      * @dev Returns the account approved for `tokenId` token.
1108      *
1109      * Requirements:
1110      *
1111      * - `tokenId` must exist.
1112      */
1113     function getApproved(uint256 tokenId) external view returns (address operator);
1114 
1115     /**
1116      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1117      *
1118      * See {setApprovalForAll}
1119      */
1120     function isApprovedForAll(address owner, address operator) external view returns (bool);
1121 }
1122 
1123 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1124 
1125 
1126 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1127 
1128 //pragma solidity ^0.8.0;
1129 
1130 
1131 /**
1132  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1133  * @dev See https://eips.ethereum.org/EIPS/eip-721
1134  */
1135 interface IERC721Enumerable is IERC721 {
1136     /**
1137      * @dev Returns the total amount of tokens stored by the contract.
1138      */
1139     function totalSupply() external view returns (uint256);
1140 
1141     /**
1142      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1143      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1144      */
1145     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1146 
1147     /**
1148      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1149      * Use along with {totalSupply} to enumerate all tokens.
1150      */
1151     function tokenByIndex(uint256 index) external view returns (uint256);
1152 }
1153 
1154 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1155 
1156 
1157 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1158 
1159 //pragma solidity ^0.8.0;
1160 
1161 
1162 /**
1163  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1164  * @dev See https://eips.ethereum.org/EIPS/eip-721
1165  */
1166 interface IERC721Metadata is IERC721 {
1167     /**
1168      * @dev Returns the token collection name.
1169      */
1170     function name() external view returns (string memory);
1171 
1172     /**
1173      * @dev Returns the token collection symbol.
1174      */
1175     function symbol() external view returns (string memory);
1176 
1177     /**
1178      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1179      */
1180     function tokenURI(uint256 tokenId) external view returns (string memory);
1181 }
1182 
1183 // File: docs.chain.link/EVAKeepersAutomationPsi.sol
1184 
1185 
1186 /**
1187   ______ _____   _____ ______ ___  __ _  _  _ 
1188  |  ____|  __ \ / ____|____  |__ \/_ | || || |
1189  | |__  | |__) | |        / /   ) || | \| |/ |
1190  |  __| |  _  /| |       / /   / / | |\_   _/ 
1191  | |____| | \ \| |____  / /   / /_ | |  | |   
1192  |______|_|  \_\\_____|/_/   |____||_|  |_|   
1193 
1194  - github: https://github.com/estarriolvetch/ERC721Psi
1195  - npm: https://www.npmjs.com/package/erc721psi
1196                                           
1197  */
1198 
1199 //pragma solidity ^0.8.0;
1200 
1201 
1202 
1203 
1204 
1205 // File: SafeMath.sol
1206 
1207 /**
1208  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1209  * checks.
1210  *
1211  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1212  * in bugs, because programmers usually assume that an overflow raises an
1213  * error, which is the standard behavior in high level programming languages.
1214  * `SafeMath` restores this intuition by reverting the transaction when an
1215  * operation overflows.
1216  *
1217  * Using this library instead of the unchecked operations eliminates an entire
1218  * class of bugs, so it's recommended to use it always.
1219  */
1220 library SafeMath {
1221     /**
1222      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1223      *
1224      * _Available since v3.4._
1225      */
1226     function tryAdd(uint256 a, uint256 b)
1227         internal
1228         pure
1229         returns (bool, uint256)
1230     {
1231         uint256 c = a + b;
1232         if (c < a) return (false, 0);
1233         return (true, c);
1234     }
1235 
1236     /**
1237      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1238      *
1239      * _Available since v3.4._
1240      */
1241     function trySub(uint256 a, uint256 b)
1242         internal
1243         pure
1244         returns (bool, uint256)
1245     {
1246         if (b > a) return (false, 0);
1247         return (true, a - b);
1248     }
1249 
1250     /**
1251      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1252      *
1253      * _Available since v3.4._
1254      */
1255     function tryMul(uint256 a, uint256 b)
1256         internal
1257         pure
1258         returns (bool, uint256)
1259     {
1260         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1261         // benefit is lost if 'b' is also tested.
1262         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1263         if (a == 0) return (true, 0);
1264         uint256 c = a * b;
1265         if (c / a != b) return (false, 0);
1266         return (true, c);
1267     }
1268 
1269     /**
1270      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1271      *
1272      * _Available since v3.4._
1273      */
1274     function tryDiv(uint256 a, uint256 b)
1275         internal
1276         pure
1277         returns (bool, uint256)
1278     {
1279         if (b == 0) return (false, 0);
1280         return (true, a / b);
1281     }
1282 
1283     /**
1284      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1285      *
1286      * _Available since v3.4._
1287      */
1288     function tryMod(uint256 a, uint256 b)
1289         internal
1290         pure
1291         returns (bool, uint256)
1292     {
1293         if (b == 0) return (false, 0);
1294         return (true, a % b);
1295     }
1296 
1297     /**
1298      * @dev Returns the addition of two unsigned integers, reverting on
1299      * overflow.
1300      *
1301      * Counterpart to Solidity's `+` operator.
1302      *
1303      * Requirements:
1304      *
1305      * - Addition cannot overflow.
1306      */
1307     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1308         uint256 c = a + b;
1309         require(c >= a, "SafeMath: addition overflow");
1310         return c;
1311     }
1312 
1313     /**
1314      * @dev Returns the subtraction of two unsigned integers, reverting on
1315      * overflow (when the result is negative).
1316      *
1317      * Counterpart to Solidity's `-` operator.
1318      *
1319      * Requirements:
1320      *
1321      * - Subtraction cannot overflow.
1322      */
1323     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1324         require(b <= a, "SafeMath: subtraction overflow");
1325         return a - b;
1326     }
1327 
1328     /**
1329      * @dev Returns the multiplication of two unsigned integers, reverting on
1330      * overflow.
1331      *
1332      * Counterpart to Solidity's `*` operator.
1333      *
1334      * Requirements:
1335      *
1336      * - Multiplication cannot overflow.
1337      */
1338     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1339         if (a == 0) return 0;
1340         uint256 c = a * b;
1341         require(c / a == b, "SafeMath: multiplication overflow");
1342         return c;
1343     }
1344 
1345     /**
1346      * @dev Returns the integer division of two unsigned integers, reverting on
1347      * division by zero. The result is rounded towards zero.
1348      *
1349      * Counterpart to Solidity's `/` operator. Note: this function uses a
1350      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1351      * uses an invalid opcode to revert (consuming all remaining gas).
1352      *
1353      * Requirements:
1354      *
1355      * - The divisor cannot be zero.
1356      */
1357     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1358         require(b > 0, "SafeMath: division by zero");
1359         return a / b;
1360     }
1361 
1362     /**
1363      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1364      * reverting when dividing by zero.
1365      *
1366      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1367      * opcode (which leaves remaining gas untouched) while Solidity uses an
1368      * invalid opcode to revert (consuming all remaining gas).
1369      *
1370      * Requirements:
1371      *
1372      * - The divisor cannot be zero.
1373      */
1374     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1375         require(b > 0, "SafeMath: modulo by zero");
1376         return a % b;
1377     }
1378 
1379     /**
1380      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1381      * overflow (when the result is negative).
1382      *
1383      * CAUTION: This function is deprecated because it requires allocating memory for the error
1384      * message unnecessarily. For custom revert reasons use {trySub}.
1385      *
1386      * Counterpart to Solidity's `-` operator.
1387      *
1388      * Requirements:
1389      *
1390      * - Subtraction cannot overflow.
1391      */
1392     function sub(
1393         uint256 a,
1394         uint256 b,
1395         string memory errorMessage
1396     ) internal pure returns (uint256) {
1397         require(b <= a, errorMessage);
1398         return a - b;
1399     }
1400 
1401     /**
1402      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1403      * division by zero. The result is rounded towards zero.
1404      *
1405      * CAUTION: This function is deprecated because it requires allocating memory for the error
1406      * message unnecessarily. For custom revert reasons use {tryDiv}.
1407      *
1408      * Counterpart to Solidity's `/` operator. Note: this function uses a
1409      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1410      * uses an invalid opcode to revert (consuming all remaining gas).
1411      *
1412      * Requirements:
1413      *
1414      * - The divisor cannot be zero.
1415      */
1416     function div(
1417         uint256 a,
1418         uint256 b,
1419         string memory errorMessage
1420     ) internal pure returns (uint256) {
1421         require(b > 0, errorMessage);
1422         return a / b;
1423     }
1424 
1425     /**
1426      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1427      * reverting with custom message when dividing by zero.
1428      *
1429      * CAUTION: This function is deprecated because it requires allocating memory for the error
1430      * message unnecessarily. For custom revert reasons use {tryMod}.
1431      *
1432      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1433      * opcode (which leaves remaining gas untouched) while Solidity uses an
1434      * invalid opcode to revert (consuming all remaining gas).
1435      *
1436      * Requirements:
1437      *
1438      * - The divisor cannot be zero.
1439      */
1440     function mod(
1441         uint256 a,
1442         uint256 b,
1443         string memory errorMessage
1444     ) internal pure returns (uint256) {
1445         require(b > 0, errorMessage);
1446         return a % b;
1447     }
1448 }
1449 
1450 contract ERC721Psi is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1451     using Address for address;
1452     using Strings for uint256;
1453     using BitMaps for BitMaps.BitMap;
1454 
1455     BitMaps.BitMap private _batchHead;
1456 
1457     string private _name;
1458     string private _symbol;
1459 
1460     // Mapping from token ID to owner address
1461     mapping(uint256 => address) internal _owners;
1462     uint256 internal _minted;
1463 
1464     mapping(uint256 => address) private _tokenApprovals;
1465     mapping(address => mapping(address => bool)) private _operatorApprovals;
1466 
1467     /**
1468      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1469      */
1470     constructor(string memory name_, string memory symbol_) {
1471         _name = name_;
1472         _symbol = symbol_;
1473     }
1474 
1475     /**
1476      * @dev See {IERC165-supportsInterface}.
1477      */
1478     function supportsInterface(bytes4 interfaceId)
1479         public
1480         view
1481         virtual
1482         override(ERC165, IERC165)
1483         returns (bool)
1484     {
1485         return
1486             interfaceId == type(IERC721).interfaceId ||
1487             interfaceId == type(IERC721Metadata).interfaceId ||
1488             interfaceId == type(IERC721Enumerable).interfaceId ||
1489             super.supportsInterface(interfaceId);
1490     }
1491 
1492     /**
1493      * @dev See {IERC721-balanceOf}.
1494      */
1495     function balanceOf(address owner) 
1496         public 
1497         view 
1498         virtual 
1499         override 
1500         returns (uint) 
1501     {
1502         require(owner != address(0), "ERC721Psi: balance query for the zero address");
1503 
1504         uint count;
1505         for( uint i; i < _minted; ++i ){
1506             if(_exists(i)){
1507                 if( owner == ownerOf(i)){
1508                     ++count;
1509                 }
1510             }
1511         }
1512         return count;
1513     }
1514 
1515     /**
1516      * @dev See {IERC721-ownerOf}.
1517      */
1518     function ownerOf(uint256 tokenId)
1519         public
1520         view
1521         virtual
1522         override
1523         returns (address)
1524     {
1525         (address owner, ) = _ownerAndBatchHeadOf(tokenId);
1526         return owner;
1527     }
1528 
1529     function _ownerAndBatchHeadOf(uint256 tokenId) internal view returns (address owner, uint256 tokenIdBatchHead){
1530         require(_exists(tokenId), "ERC721Psi: owner query for nonexistent token");
1531         tokenIdBatchHead = _getBatchHead(tokenId);
1532         owner = _owners[tokenIdBatchHead];
1533     }
1534 
1535     /**
1536      * @dev See {IERC721Metadata-name}.
1537      */
1538     function name() public view virtual override returns (string memory) {
1539         return _name;
1540     }
1541 
1542     /**
1543      * @dev See {IERC721Metadata-symbol}.
1544      */
1545     function symbol() public view virtual override returns (string memory) {
1546         return _symbol;
1547     }
1548 
1549     /**
1550      * @dev See {IERC721Metadata-tokenURI}.
1551      */
1552     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1553         require(_exists(tokenId), "ERC721Psi: URI query for nonexistent token");
1554 
1555         string memory baseURI = _baseURI();
1556         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1557     }
1558 
1559     /**
1560      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1561      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1562      * by default, can be overriden in child contracts.
1563      */
1564     function _baseURI() internal view virtual returns (string memory) {
1565         return "";
1566     }
1567 
1568 
1569     /**
1570      * @dev See {IERC721-approve}.
1571      */
1572     function approve(address to, uint256 tokenId) public virtual override {
1573         address owner = ownerOf(tokenId);
1574         require(to != owner, "ERC721Psi: approval to current owner");
1575 
1576         require(
1577             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1578             "ERC721Psi: approve caller is not owner nor approved for all"
1579         );
1580 
1581         _approve(to, tokenId);
1582     }
1583 
1584     /**
1585      * @dev See {IERC721-getApproved}.
1586      */
1587     function getApproved(uint256 tokenId)
1588         public
1589         view
1590         virtual
1591         override
1592         returns (address)
1593     {
1594         require(
1595             _exists(tokenId),
1596             "ERC721Psi: approved query for nonexistent token"
1597         );
1598 
1599         return _tokenApprovals[tokenId];
1600     }
1601 
1602     /**
1603      * @dev See {IERC721-setApprovalForAll}.
1604      */
1605     function setApprovalForAll(address operator, bool approved)
1606         public
1607         virtual
1608         override
1609     {
1610         require(operator != _msgSender(), "ERC721Psi: approve to caller");
1611 
1612         _operatorApprovals[_msgSender()][operator] = approved;
1613         emit ApprovalForAll(_msgSender(), operator, approved);
1614     }
1615 
1616     /**
1617      * @dev See {IERC721-isApprovedForAll}.
1618      */
1619     function isApprovedForAll(address owner, address operator)
1620         public
1621         view
1622         virtual
1623         override
1624         returns (bool)
1625     {
1626         return _operatorApprovals[owner][operator];
1627     }
1628 
1629     /**
1630      * @dev See {IERC721-transferFrom}.
1631      */
1632     function transferFrom(
1633         address from,
1634         address to,
1635         uint256 tokenId
1636     ) public virtual override {
1637         //solhint-disable-next-line max-line-length
1638         require(
1639             _isApprovedOrOwner(_msgSender(), tokenId),
1640             "ERC721Psi: transfer caller is not owner nor approved"
1641         );
1642 
1643         _transfer(from, to, tokenId);
1644     }
1645 
1646     /**
1647      * @dev See {IERC721-safeTransferFrom}.
1648      */
1649     function safeTransferFrom(
1650         address from,
1651         address to,
1652         uint256 tokenId
1653     ) public virtual override {
1654         safeTransferFrom(from, to, tokenId, "");
1655     }
1656 
1657     /**
1658      * @dev See {IERC721-safeTransferFrom}.
1659      */
1660     function safeTransferFrom(
1661         address from,
1662         address to,
1663         uint256 tokenId,
1664         bytes memory _data
1665     ) public virtual override {
1666         require(
1667             _isApprovedOrOwner(_msgSender(), tokenId),
1668             "ERC721Psi: transfer caller is not owner nor approved"
1669         );
1670         _safeTransfer(from, to, tokenId, _data);
1671     }
1672 
1673     /**
1674      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1675      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1676      *
1677      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1678      *
1679      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1680      * implement alternative mechanisms to perform token transfer, such as signature-based.
1681      *
1682      * Requirements:
1683      *
1684      * - `from` cannot be the zero address.
1685      * - `to` cannot be the zero address.
1686      * - `tokenId` token must exist and be owned by `from`.
1687      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1688      *
1689      * Emits a {Transfer} event.
1690      */
1691     function _safeTransfer(
1692         address from,
1693         address to,
1694         uint256 tokenId,
1695         bytes memory _data
1696     ) internal virtual {
1697         _transfer(from, to, tokenId);
1698         require(
1699             _checkOnERC721Received(from, to, tokenId, 1,_data),
1700             "ERC721Psi: transfer to non ERC721Receiver implementer"
1701         );
1702     }
1703 
1704     /**
1705      * @dev Returns whether `tokenId` exists.
1706      *
1707      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1708      *
1709      * Tokens start existing when they are minted (`_mint`).
1710      */
1711     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1712         return tokenId < _minted;
1713     }
1714 
1715     /**
1716      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1717      *
1718      * Requirements:
1719      *
1720      * - `tokenId` must exist.
1721      */
1722     function _isApprovedOrOwner(address spender, uint256 tokenId)
1723         internal
1724         view
1725         virtual
1726         returns (bool)
1727     {
1728         require(
1729             _exists(tokenId),
1730             "ERC721Psi: operator query for nonexistent token"
1731         );
1732         address owner = ownerOf(tokenId);
1733         return (spender == owner ||
1734             getApproved(tokenId) == spender ||
1735             isApprovedForAll(owner, spender));
1736     }
1737 
1738     /**
1739      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1740      *
1741      * Requirements:
1742      *
1743      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1744      * - `quantity` must be greater than 0.
1745      *
1746      * Emits a {Transfer} event.
1747      */
1748     function _safeMint(address to, uint256 quantity) internal virtual {
1749         _safeMint(to, quantity, "");
1750     }
1751 
1752     
1753     function _safeMint(
1754         address to,
1755         uint256 quantity,
1756         bytes memory _data
1757     ) internal virtual {
1758         uint256 startTokenId = _minted;
1759         _mint(to, quantity);
1760         require(
1761             _checkOnERC721Received(address(0), to, startTokenId, quantity, _data),
1762             "ERC721Psi: transfer to non ERC721Receiver implementer"
1763         );
1764     }
1765 
1766 
1767     function _mint(
1768         address to,
1769         uint256 quantity
1770     ) internal virtual {
1771         uint256 tokenIdBatchHead = _minted;
1772         
1773         require(quantity > 0, "ERC721Psi: quantity must be greater 0");
1774         require(to != address(0), "ERC721Psi: mint to the zero address");
1775         
1776         _beforeTokenTransfers(address(0), to, tokenIdBatchHead, quantity);
1777         _minted += quantity;
1778         _owners[tokenIdBatchHead] = to;
1779         _batchHead.set(tokenIdBatchHead);
1780         _afterTokenTransfers(address(0), to, tokenIdBatchHead, quantity);
1781         
1782         // Emit events
1783         for(uint256 tokenId=tokenIdBatchHead;tokenId < tokenIdBatchHead + quantity; tokenId++){
1784             emit Transfer(address(0), to, tokenId);
1785         } 
1786     }
1787 
1788 
1789     /**
1790      * @dev Transfers `tokenId` from `from` to `to`.
1791      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1792      *
1793      * Requirements:
1794      *
1795      * - `to` cannot be the zero address.
1796      * - `tokenId` token must be owned by `from`.
1797      *
1798      * Emits a {Transfer} event.
1799      */
1800     function _transfer(
1801         address from,
1802         address to,
1803         uint256 tokenId
1804     ) internal virtual {
1805         (address owner, uint256 tokenIdBatchHead) = _ownerAndBatchHeadOf(tokenId);
1806 
1807         require(
1808             owner == from,
1809             "ERC721Psi: transfer of token that is not own"
1810         );
1811         require(to != address(0), "ERC721Psi: transfer to the zero address");
1812 
1813         _beforeTokenTransfers(from, to, tokenId, 1);
1814 
1815         // Clear approvals from the previous owner
1816         _approve(address(0), tokenId);   
1817 
1818         uint256 nextTokenId = tokenId + 1;
1819 
1820         if(!_batchHead.get(nextTokenId) &&  
1821             nextTokenId < _minted
1822         ) {
1823             _owners[nextTokenId] = from;
1824             _batchHead.set(nextTokenId);
1825         }
1826 
1827         _owners[tokenId] = to;
1828         if(tokenId != tokenIdBatchHead) {
1829             _batchHead.set(tokenId);
1830         }
1831 
1832         emit Transfer(from, to, tokenId);
1833 
1834         _afterTokenTransfers(from, to, tokenId, 1);
1835     }
1836 
1837     /**
1838      * @dev Approve `to` to operate on `tokenId`
1839      *
1840      * Emits a {Approval} event.
1841      */
1842     function _approve(address to, uint256 tokenId) internal virtual {
1843         _tokenApprovals[tokenId] = to;
1844         emit Approval(ownerOf(tokenId), to, tokenId);
1845     }
1846 
1847     /**
1848      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1849      * The call is not executed if the target address is not a contract.
1850      *
1851      * @param from address representing the previous owner of the given token ID
1852      * @param to target address that will receive the tokens
1853      * @param startTokenId uint256 the first ID of the tokens to be transferred
1854      * @param quantity uint256 amount of the tokens to be transfered.
1855      * @param _data bytes optional data to send along with the call
1856      * @return r bool whether the call correctly returned the expected magic value
1857      */
1858     function _checkOnERC721Received(
1859         address from,
1860         address to,
1861         uint256 startTokenId,
1862         uint256 quantity,
1863         bytes memory _data
1864     ) private returns (bool r) {
1865         if (to.isContract()) {
1866             r = true;
1867             for(uint256 tokenId = startTokenId; tokenId < startTokenId + quantity; tokenId++){
1868                 try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1869                     r = r && retval == IERC721Receiver.onERC721Received.selector;
1870                 } catch (bytes memory reason) {
1871                     if (reason.length == 0) {
1872                         revert("ERC721Psi: transfer to non ERC721Receiver implementer");
1873                     } else {
1874                         assembly {
1875                             revert(add(32, reason), mload(reason))
1876                         }
1877                     }
1878                 }
1879             }
1880             return r;
1881         } else {
1882             return true;
1883         }
1884     }
1885 
1886     function _getBatchHead(uint256 tokenId) internal view returns (uint256 tokenIdBatchHead) {
1887         tokenIdBatchHead = _batchHead.scanForward(tokenId); 
1888     }
1889 
1890     /**
1891      * @dev See {IERC721Enumerable-totalSupply}.
1892      */
1893     function totalSupply() public view virtual override returns (uint256) {
1894         return _minted;
1895     }
1896 
1897     /**
1898      * @dev See {IERC721Enumerable-tokenByIndex}.
1899      */
1900     function tokenByIndex(uint256 index) public view virtual override returns (uint256 tokenId) {
1901         require(index < totalSupply(), "ERC721Psi: global index out of bounds");
1902         
1903         uint count;
1904         for(uint i; i < _minted; i++){
1905             if(_exists(i)){
1906                 if(count == index) return i;
1907                 else count++;
1908             }
1909         }
1910     }
1911 
1912     /**
1913      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1914      */
1915     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1916         uint count;
1917         for(uint i; i < _minted; i++){
1918             if(_exists(i) && owner == ownerOf(i)){
1919                 if(count == index) return i;
1920                 else count++;
1921             }
1922         }
1923 
1924         revert("ERC721Psi: owner index out of bounds");
1925     }
1926 
1927 
1928     /**
1929      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1930      *
1931      * startTokenId - the first token id to be transferred
1932      * quantity - the amount to be transferred
1933      *
1934      * Calling conditions:
1935      *
1936      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1937      * transferred to `to`.
1938      * - When `from` is zero, `tokenId` will be minted for `to`.
1939      */
1940     function _beforeTokenTransfers(
1941         address from,
1942         address to,
1943         uint256 startTokenId,
1944         uint256 quantity
1945     ) internal virtual {}
1946 
1947     /**
1948      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1949      * minting.
1950      *
1951      * startTokenId - the first token id to be transferred
1952      * quantity - the amount to be transferred
1953      *
1954      * Calling conditions:
1955      *
1956      * - when `from` and `to` are both non-zero.
1957      * - `from` and `to` are never both zero.
1958      */
1959     function _afterTokenTransfers(
1960         address from,
1961         address to,
1962         uint256 startTokenId,
1963         uint256 quantity
1964     ) internal virtual {}
1965 }
1966 
1967 
1968 error ApprovalCallerNotOwnerNorApproved();
1969 error ApprovalQueryForNonexistentToken();
1970 error ApproveToCaller();
1971 error ApprovalToCurrentOwner();
1972 error BalanceQueryForZeroAddress();
1973 error MintedQueryForZeroAddress();
1974 error BurnedQueryForZeroAddress();
1975 error MintToZeroAddress();
1976 error MintZeroQuantity();
1977 error OwnerIndexOutOfBounds();
1978 error OwnerQueryForNonexistentToken();
1979 error TokenIndexOutOfBounds();
1980 error TransferCallerNotOwnerNorApproved();
1981 error TransferFromIncorrectOwner();
1982 error TransferToNonERC721ReceiverImplementer();
1983 error TransferToZeroAddress();
1984 error URIQueryForNonexistentToken();
1985 
1986 contract DiscoverTheMandox is ERC721Psi, Ownable {
1987     using SafeMath for uint256;
1988     using Strings for uint;
1989 
1990     /*
1991      * @dev Set Initial Parameters Before deployment
1992      * settings are still fully updateable after deployment
1993      */
1994 
1995     uint256 public maxSupply = 4500;
1996     uint256 public mintRate = 0.09 ether;
1997     // Mint Ending - Phase 1 total supply
1998     uint256 public phase1 = 1000;
1999     // Phase 2 total supply
2000     uint256 public phase2 = 2000;
2001     // Phase 3 total supply
2002     uint256 public phase3 = 3000;
2003     // Phase 4 total supply
2004     uint256 public phase4 = 4000;
2005     // Phase 5 total supply
2006     uint256 public phase5 = 4500;
2007 
2008     uint256 public activePhase = 1;
2009 
2010 
2011     /*
2012     * @Dev Booleans for sale states. 
2013     * salesIsActive must be true in any case to mint
2014     */
2015     bool public globalSaleIsActive = false;
2016     // Phase 1
2017     bool public saleIsActive = false;
2018     // Phase 2
2019     bool public saleIsActive2 = false;
2020     // Phase 3
2021     bool public saleIsActive3 = false;
2022     // Phase 4
2023     bool public saleIsActive4 = false;
2024     // Phase 5
2025     bool public saleIsActive5 = false;
2026 
2027 
2028 
2029 
2030     /*
2031      * @dev Set base URI, Make sure when dpeloying if you plan to Have an 
2032      * Unrevealed Sale or Period you Do not Deploy with your Revealed
2033      * base URI here or they will mint With your revealed Images Showing
2034      */
2035     string private baseURI;
2036     string private baseURI2;
2037     string private baseURI3;
2038     string private baseURI4;
2039     string private baseURI5;
2040 
2041     string public notRevealedUri;
2042     string public notRevealed2Uri;
2043     string public notRevealed3Uri;
2044     string public notRevealed4Uri;
2045     string public notRevealed5Uri;
2046     
2047 
2048     bool public revealed = false;
2049     bool public revealed2 = false;
2050     bool public revealed3 = false;
2051     bool public revealed4 = false;
2052     bool public revealed5 = false;
2053     
2054 
2055 
2056     
2057     /*
2058      * @dev Set Collection/Contract name and Token Ticker
2059      * below. Cannot be changed after
2060      * contract deployment.
2061      */
2062     constructor(string memory _baseUri, string memory _notRevealedUri) ERC721Psi("DiscoverTheMandoxPt2", "DTM2") {
2063         baseURI = _baseUri;
2064         notRevealedUri = _notRevealedUri;
2065     }
2066 
2067     /**
2068      * @dev See {IERC721Metadata-tokenURI}.
2069      */
2070 
2071     function tokenURI(uint256 tokenId) 
2072     public 
2073     view 
2074     virtual 
2075     override 
2076     returns (string memory) {
2077         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2078         if (revealed == false && tokenId < 1000) {
2079             return notRevealedUri;
2080         } if (revealed == true && tokenId < 1000) { 
2081       
2082             return string(abi.encodePacked(baseURI, "/", tokenId.toString(), ""));
2083         } 
2084 
2085          if ( revealed2 == false && tokenId >= 1000 && tokenId < 2000) {
2086             return notRevealed2Uri;
2087         } if (revealed2 == true && tokenId >= 1000 && tokenId < 2000) {
2088             return string(abi.encodePacked(baseURI2,"/", tokenId.toString(), "")); 
2089         }
2090 
2091          if ( revealed3 == false && tokenId >= 2000 && tokenId < 3000) {
2092             return notRevealed3Uri;
2093         } if (revealed3 == true && tokenId >= 2000 && tokenId < 3000) {
2094             return string(abi.encodePacked(baseURI3,"/", tokenId.toString(), "")); 
2095         }
2096 
2097           if ( revealed4 == false && tokenId >= 3000 && tokenId < 4000) {
2098             return notRevealed4Uri;
2099         } if (revealed4 == true && tokenId >= 3000 && tokenId < 4000) {
2100             return string(abi.encodePacked(baseURI4,"/", tokenId.toString(), "")); 
2101         }
2102 
2103           if ( revealed5 == false && tokenId >= 4000 && tokenId < 4500) {
2104             return notRevealed5Uri;
2105         } if (revealed5 == true && tokenId >= 4000 && tokenId < 4500) {
2106             return string(abi.encodePacked(baseURI5,"/", tokenId.toString(), "")); 
2107         }
2108 
2109     }
2110 
2111     function RevealPhase1() public onlyOwner {
2112         revealed = true;
2113     }
2114 
2115     function RevealPhase2() public onlyOwner {
2116         revealed2 = true;
2117     }
2118 
2119     function RevealPhase3() public onlyOwner {
2120         revealed3 = true;
2121     }
2122 
2123     function RevealPhase4() public onlyOwner {
2124         revealed4 = true;
2125     }
2126 
2127     function RevealPhase5() public onlyOwner {
2128         revealed5 = true;
2129     }
2130 
2131     
2132 
2133     /*
2134     * set Not revealed URIs seperately for each phase
2135     */
2136     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2137         notRevealedUri = _notRevealedURI;
2138     }
2139 
2140     function setNotRevealedURI2(string memory _notRevealedURI2) public onlyOwner {
2141         notRevealed2Uri = _notRevealedURI2;
2142     }
2143 
2144     function setNotRevealedURI3(string memory _notRevealedURI3) public onlyOwner {
2145         notRevealed3Uri = _notRevealedURI3;
2146     }
2147 
2148     function setNotRevealedURI4(string memory _notRevealedURI4) public onlyOwner {
2149         notRevealed4Uri = _notRevealedURI4;
2150     }
2151 
2152     function setNotRevealedURI5(string memory _notRevealedURI5) public onlyOwner {
2153         notRevealed5Uri = _notRevealedURI5;
2154     }
2155 
2156     /*
2157      *@dev
2158      * Set publicsale price to mint per NFT
2159      */
2160     function setMintPrice(uint256 _price) external onlyOwner {
2161         mintRate = _price;
2162     }
2163 
2164     /*
2165     * @dev mint funtion with _to address. no cost mint
2166     *  by contract owner/deployer
2167     */
2168     function QwikMint(uint256 quantity, address _to) external onlyOwner {
2169         require(globalSaleIsActive, "Sales must be active to mint");
2170         require(totalSupply() + quantity <= maxSupply, "Not enough NFTs left to Mint");
2171         if (activePhase == 1){
2172             require(saleIsActive, "Phase 1 must be active to mint");
2173             require(totalSupply() + quantity <= phase1, "Not enough NFTs in this phase");
2174          _safeMint(_to, quantity);
2175         }
2176 
2177         if (activePhase == 2){
2178             require(saleIsActive2, "Phase 2 must be active to mint");
2179             require(totalSupply() + quantity <= phase2, "Not enough NFTs in this phase");
2180          _safeMint(_to, quantity);
2181         }
2182 
2183         if (activePhase == 3){
2184             require(saleIsActive3, "Phase 3 must be active to mint");
2185             require(totalSupply() + quantity <= phase3, "Not enough NFTs in this phase");
2186          _safeMint(_to, quantity);
2187         }
2188 
2189         if (activePhase == 4){
2190             require(saleIsActive4, "Phase 4 must be active to mint");
2191             require(totalSupply() + quantity <= phase4, "Not enough NFTs in this phase");
2192          _safeMint(_to, quantity);
2193         }
2194 
2195         if (activePhase == 5){
2196             require(saleIsActive5, "Phase 5 must be active to mint");
2197             require(totalSupply() + quantity <= phase5, "Not enough NFTs in this phase");
2198          _safeMint(_to, quantity);
2199         }
2200     }
2201 
2202     /*
2203     * @dev mint function and checks for saleState, phase and mint quantity
2204     */   
2205     function mint(uint256 quantity) external payable {
2206         require(globalSaleIsActive, "Sales must be active to mint");
2207         require(totalSupply() + quantity <= maxSupply, "Not enough NFTs left to Mint");
2208         require((mintRate * quantity) <= msg.value, "Not enough Eth");
2209 
2210         if (activePhase == 1){
2211             require(saleIsActive, "Phase 1 must be active to mint");
2212             require(totalSupply() + quantity <= phase1, "Not enough NFTs in this phase");
2213          _safeMint(msg.sender, quantity);
2214         }
2215 
2216         if (activePhase == 2){
2217             require(saleIsActive2, "Phase 2 must be active to mint");
2218             require(totalSupply() + quantity <= phase2, "Not enough NFTs in this phase");
2219          _safeMint(msg.sender, quantity);
2220         }
2221 
2222         if (activePhase == 3){
2223             require(saleIsActive3, "Phase 3 must be active to mint");
2224             require(totalSupply() + quantity <= phase3, "Not enough NFTs in this phase");
2225          _safeMint(msg.sender, quantity);
2226         }
2227 
2228         if (activePhase == 4){
2229             require(saleIsActive4, "Phase 4 must be active to mint");
2230             require(totalSupply() + quantity <= phase4, "Not enough NFTs in this phase");
2231          _safeMint(msg.sender, quantity);
2232         }
2233 
2234         if (activePhase == 5){
2235             require(saleIsActive5, "Phase 5 must be active to mint");
2236             require(totalSupply() + quantity <= phase5, "Not enough NFTs in this phase or Collection Finished");
2237          _safeMint(msg.sender, quantity);
2238         }
2239 
2240     }
2241 
2242     function NextPhase() external onlyOwner {
2243         if (activePhase == 1){
2244             activePhase = 2;
2245         } 
2246         else if (activePhase == 2){
2247             activePhase = 3;
2248         }
2249         else if (activePhase == 3){
2250             activePhase = 4;
2251         }
2252         else if (activePhase == 4){
2253             activePhase = 5;
2254         }
2255         else if (activePhase == 5){
2256             revert ("Final Phase Already Active");
2257         }
2258 
2259     }
2260 
2261     //set active phase number
2262     function setManualPhase(uint256 phase) external onlyOwner {
2263         activePhase = phase;
2264     }
2265 
2266     /*
2267      * @dev Set new Base URIs -Seperate for each drop, reamins single collection
2268      * useful for setting unrevealed uri to revealed Base URI
2269      * same as a reveal switch/state but not the extraness
2270      */
2271     function setBaseURI(string calldata newBaseURI) external onlyOwner {
2272         baseURI = newBaseURI;
2273     }
2274 
2275     function setBaseURI2(string calldata newBaseURI2) external onlyOwner {
2276         baseURI2 = newBaseURI2;
2277     }
2278 
2279     function setBaseURI3(string calldata newBaseURI3) external onlyOwner {
2280         baseURI3 = newBaseURI3;
2281     }
2282 
2283     function setBaseURI4(string calldata newBaseURI4) external onlyOwner {
2284         baseURI4 = newBaseURI4;
2285     }
2286 
2287     function setBaseURI5(string calldata newBaseURI5) external onlyOwner {
2288         baseURI5 = newBaseURI5;
2289     }
2290 
2291      /*
2292      * @dev internal baseUri function
2293      */
2294     function _baseURI() internal view override returns (string memory) {
2295         return baseURI;
2296     }
2297 
2298     // global sale active to enable contract mints globally
2299     function setGlobalSaleActive() public onlyOwner {
2300         globalSaleIsActive = !globalSaleIsActive;
2301     }
2302 
2303      /*
2304      * @dev Pause sale if active, make active if paused
2305      */
2306     function setSaleActivePhase1() public onlyOwner {
2307         saleIsActive = !saleIsActive;
2308     }
2309 
2310     function setSaleActivePhase2() public onlyOwner {
2311         saleIsActive2 = !saleIsActive2;
2312     }
2313 
2314     function setSaleActivePhase3() public onlyOwner {
2315         saleIsActive3 = !saleIsActive3;
2316     }
2317 
2318     function setSaleActivePhase4() public onlyOwner {
2319         saleIsActive4 = !saleIsActive4;
2320     }
2321 
2322     function setSaleActivePhase5() public onlyOwner {
2323         saleIsActive5 = !saleIsActive5;
2324     }
2325 
2326     /*
2327      * @dev Public Keepers or to Owner wallet Withdrawl function, Contract ETH balance
2328      * to owner wallet address.
2329      */
2330     function withdraw() external onlyOwner {
2331         payable(owner()).transfer(address(this).balance);
2332     }
2333     
2334     /*
2335     * @dev Alternative withdrawl
2336     * mint funs to a specified address
2337     * 
2338     */
2339     function Withdraw(uint256 _amount, address payable _to)
2340         external
2341         onlyOwner
2342     {
2343         require(_amount > 0, "Withdraw must be greater than 0");
2344         require(_amount <= address(this).balance, "Amount too high");
2345         (bool success, ) = _to.call{value: _amount}("");
2346         require(success);
2347     }
2348 
2349         /**
2350      * Get the array of token for owner.
2351      */
2352     function tokensOfOwner(address _owner)
2353         external
2354         view
2355         returns (uint256[] memory)
2356     {
2357         uint256 tokenCount = balanceOf(_owner);
2358         if (tokenCount == 0) {
2359             return new uint256[](0);
2360         } else {
2361             uint256[] memory result = new uint256[](tokenCount);
2362             for (uint256 index; index < tokenCount; index++) {
2363                 result[index] = tokenOfOwnerByIndex(_owner, index);
2364             }
2365             return result;
2366         }
2367     }
2368 
2369 }