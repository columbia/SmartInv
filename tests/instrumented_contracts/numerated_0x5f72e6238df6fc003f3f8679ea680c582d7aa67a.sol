1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.7;
3 
4 /*
5 *  EVA Tribe by MANDOX
6 *  www.twitter.com/officialmandox
7 *  www.mandoxglobal.com
8 *  www.mandoxmint.com
9 *  t.me/officialmandox
10 */
11 
12 // File: solidity-bits/contracts/Popcount.sol
13 
14 /**
15    _____       ___     ___ __           ____  _ __      
16   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
17   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
18  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
19 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
20                            /____/                        
21 
22 - npm: https://www.npmjs.com/package/solidity-bits
23 - github: https://github.com/estarriolvetch/solidity-bits
24 
25  */
26 
27 //pragma solidity ^0.8.0;
28 
29 library Popcount {
30     uint256 private constant m1 = 0x5555555555555555555555555555555555555555555555555555555555555555;
31     uint256 private constant m2 = 0x3333333333333333333333333333333333333333333333333333333333333333;
32     uint256 private constant m4 = 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f;
33     uint256 private constant h01 = 0x0101010101010101010101010101010101010101010101010101010101010101;
34 
35     function popcount256A(uint256 x) internal pure returns (uint256 count) {
36         unchecked{
37             for (count=0; x!=0; count++)
38                 x &= x - 1;
39         }
40     }
41 
42     function popcount256B(uint256 x) internal pure returns (uint256) {
43         if (x == type(uint256).max) {
44             return 256;
45         }
46         unchecked {
47             x -= (x >> 1) & m1;             //put count of each 2 bits into those 2 bits
48             x = (x & m2) + ((x >> 2) & m2); //put count of each 4 bits into those 4 bits 
49             x = (x + (x >> 4)) & m4;        //put count of each 8 bits into those 8 bits 
50             x = (x * h01) >> 248;  //returns left 8 bits of x + (x<<8) + (x<<16) + (x<<24) + ... 
51         }
52         return x;
53     }
54 }
55 // File: solidity-bits/contracts/BitScan.sol
56 
57 
58 /**
59    _____       ___     ___ __           ____  _ __      
60   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
61   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
62  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
63 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
64                            /____/                        
65 
66 - npm: https://www.npmjs.com/package/solidity-bits
67 - github: https://github.com/estarriolvetch/solidity-bits
68 
69  */
70 
71 //pragma solidity ^0.8.0;
72 
73 
74 library BitScan {
75     uint256 constant private DEBRUIJN_256 = 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
76     bytes constant private LOOKUP_TABLE_256 = hex"0001020903110a19042112290b311a3905412245134d2a550c5d32651b6d3a7506264262237d468514804e8d2b95569d0d495ea533a966b11c886eb93bc176c9071727374353637324837e9b47af86c7155181ad4fd18ed32c9096db57d59ee30e2e4a6a5f92a6be3498aae067ddb2eb1d5989b56fd7baf33ca0c2ee77e5caf7ff0810182028303840444c545c646c7425617c847f8c949c48a4a8b087b8c0c816365272829aaec650acd0d28fdad4e22d6991bd97dfdcea58b4d6f29fede4f6fe0f1f2f3f4b5b6b607b8b93a3a7b7bf357199c5abcfd9e168bcdee9b3f1ecf5fd1e3e5a7a8aa2b670c4ced8bbe8f0f4fc3d79a1c3cde7effb78cce6facbf9f8";
77 
78     /**
79         @dev Isolate the least significant set bit.
80      */ 
81     function isolateLS1B256(uint256 bb) pure internal returns (uint256) {
82         require(bb > 0);
83         unchecked {
84             return bb & (0 - bb);
85         }
86     } 
87 
88     /**
89         @dev Isolate the most significant set bit.
90      */ 
91     function isolateMS1B256(uint256 bb) pure internal returns (uint256) {
92         require(bb > 0);
93         unchecked {
94             bb |= bb >> 128;
95             bb |= bb >> 64;
96             bb |= bb >> 32;
97             bb |= bb >> 16;
98             bb |= bb >> 8;
99             bb |= bb >> 4;
100             bb |= bb >> 2;
101             bb |= bb >> 1;
102             
103             return (bb >> 1) + 1;
104         }
105     } 
106 
107     /**
108         @dev Find the index of the lest significant set bit. (trailing zero count)
109      */ 
110     function bitScanForward256(uint256 bb) pure internal returns (uint8) {
111         unchecked {
112             return uint8(LOOKUP_TABLE_256[(isolateLS1B256(bb) * DEBRUIJN_256) >> 248]);
113         }   
114     }
115 
116     /**
117         @dev Find the index of the most significant set bit.
118      */ 
119     function bitScanReverse256(uint256 bb) pure internal returns (uint8) {
120         unchecked {
121             return 255 - uint8(LOOKUP_TABLE_256[((isolateMS1B256(bb) * DEBRUIJN_256) >> 248)]);
122         }   
123     }
124 
125     function log2(uint256 bb) pure internal returns (uint8) {
126         unchecked {
127             return uint8(LOOKUP_TABLE_256[(isolateMS1B256(bb) * DEBRUIJN_256) >> 248]);
128         } 
129     }
130 }
131 
132 // File: solidity-bits/contracts/BitMaps.sol
133 
134 
135 /**
136    _____       ___     ___ __           ____  _ __      
137   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
138   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
139  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
140 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
141                            /____/                        
142 
143 - npm: https://www.npmjs.com/package/solidity-bits
144 - github: https://github.com/estarriolvetch/solidity-bits
145 
146  */
147 //pragma solidity ^0.8.0;
148 
149 
150 
151 /**
152  * @dev This Library is a modified version of Openzeppelin's BitMaps library with extra features.
153  *
154  * 1. Functions of finding the index of the closest set bit from a given index are added.
155  *    The indexing of each bucket is modifed to count from the MSB to the LSB instead of from the LSB to the MSB.
156  *    The modification of indexing makes finding the closest previous set bit more efficient in gas usage.
157  * 2. Setting and unsetting the bitmap consecutively.
158  * 3. Accounting number of set bits within a given range.   
159  *
160 */
161 
162 /**
163  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
164  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
165  */
166 
167 library BitMaps {
168     using BitScan for uint256;
169     uint256 private constant MASK_INDEX_ZERO = (1 << 255);
170     uint256 private constant MASK_FULL = type(uint256).max;
171 
172     struct BitMap {
173         mapping(uint256 => uint256) _data;
174     }
175 
176     /**
177      * @dev Returns whether the bit at `index` is set.
178      */
179     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
180         uint256 bucket = index >> 8;
181         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
182         return bitmap._data[bucket] & mask != 0;
183     }
184 
185     /**
186      * @dev Sets the bit at `index` to the boolean `value`.
187      */
188     function setTo(
189         BitMap storage bitmap,
190         uint256 index,
191         bool value
192     ) internal {
193         if (value) {
194             set(bitmap, index);
195         } else {
196             unset(bitmap, index);
197         }
198     }
199 
200     /**
201      * @dev Sets the bit at `index`.
202      */
203     function set(BitMap storage bitmap, uint256 index) internal {
204         uint256 bucket = index >> 8;
205         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
206         bitmap._data[bucket] |= mask;
207     }
208 
209     /**
210      * @dev Unsets the bit at `index`.
211      */
212     function unset(BitMap storage bitmap, uint256 index) internal {
213         uint256 bucket = index >> 8;
214         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
215         bitmap._data[bucket] &= ~mask;
216     }
217 
218 
219     /**
220      * @dev Consecutively sets `amount` of bits starting from the bit at `startIndex`.
221      */    
222     function setBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
223         uint256 bucket = startIndex >> 8;
224 
225         uint256 bucketStartIndex = (startIndex & 0xff);
226 
227         unchecked {
228             if(bucketStartIndex + amount < 256) {
229                 bitmap._data[bucket] |= MASK_FULL << (256 - amount) >> bucketStartIndex;
230             } else {
231                 bitmap._data[bucket] |= MASK_FULL >> bucketStartIndex;
232                 amount -= (256 - bucketStartIndex);
233                 bucket++;
234 
235                 while(amount > 256) {
236                     bitmap._data[bucket] = MASK_FULL;
237                     amount -= 256;
238                     bucket++;
239                 }
240 
241                 bitmap._data[bucket] |= MASK_FULL << (256 - amount);
242             }
243         }
244     }
245 
246 
247     /**
248      * @dev Consecutively unsets `amount` of bits starting from the bit at `startIndex`.
249      */    
250     function unsetBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
251         uint256 bucket = startIndex >> 8;
252 
253         uint256 bucketStartIndex = (startIndex & 0xff);
254 
255         unchecked {
256             if(bucketStartIndex + amount < 256) {
257                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount) >> bucketStartIndex);
258             } else {
259                 bitmap._data[bucket] &= ~(MASK_FULL >> bucketStartIndex);
260                 amount -= (256 - bucketStartIndex);
261                 bucket++;
262 
263                 while(amount > 256) {
264                     bitmap._data[bucket] = 0;
265                     amount -= 256;
266                     bucket++;
267                 }
268 
269                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount));
270             }
271         }
272     }
273 
274     /**
275      * @dev Returns number of set bits within a range.
276      */
277     function popcountA(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
278         uint256 bucket = startIndex >> 8;
279 
280         uint256 bucketStartIndex = (startIndex & 0xff);
281 
282         unchecked {
283             if(bucketStartIndex + amount < 256) {
284                 count +=  Popcount.popcount256A(
285                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
286                 );
287             } else {
288                 count += Popcount.popcount256A(
289                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
290                 );
291                 amount -= (256 - bucketStartIndex);
292                 bucket++;
293 
294                 while(amount > 256) {
295                     count += Popcount.popcount256A(bitmap._data[bucket]);
296                     amount -= 256;
297                     bucket++;
298                 }
299                 count += Popcount.popcount256A(
300                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
301                 );
302             }
303         }
304     }
305 
306     /**
307      * @dev Returns number of set bits within a range.
308      */
309     function popcountB(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
310         uint256 bucket = startIndex >> 8;
311 
312         uint256 bucketStartIndex = (startIndex & 0xff);
313 
314         unchecked {
315             if(bucketStartIndex + amount < 256) {
316                 count +=  Popcount.popcount256B(
317                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
318                 );
319             } else {
320                 count += Popcount.popcount256B(
321                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
322                 );
323                 amount -= (256 - bucketStartIndex);
324                 bucket++;
325 
326                 while(amount > 256) {
327                     count += Popcount.popcount256B(bitmap._data[bucket]);
328                     amount -= 256;
329                     bucket++;
330                 }
331                 count += Popcount.popcount256B(
332                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
333                 );
334             }
335         }
336     }
337 
338 
339     /**
340      * @dev Find the closest index of the set bit before `index`.
341      */
342     function scanForward(BitMap storage bitmap, uint256 index) internal view returns (uint256 setBitIndex) {
343         uint256 bucket = index >> 8;
344 
345         // index within the bucket
346         uint256 bucketIndex = (index & 0xff);
347 
348         // load a bitboard from the bitmap.
349         uint256 bb = bitmap._data[bucket];
350 
351         // offset the bitboard to scan from `bucketIndex`.
352         bb = bb >> (0xff ^ bucketIndex); // bb >> (255 - bucketIndex)
353         
354         if(bb > 0) {
355             unchecked {
356                 setBitIndex = (bucket << 8) | (bucketIndex -  bb.bitScanForward256());    
357             }
358         } else {
359             while(true) {
360                 require(bucket > 0, "BitMaps: The set bit before the index doesn't exist.");
361                 unchecked {
362                     bucket--;
363                 }
364                 // No offset. Always scan from the least significiant bit now.
365                 bb = bitmap._data[bucket];
366                 
367                 if(bb > 0) {
368                     unchecked {
369                         setBitIndex = (bucket << 8) | (255 -  bb.bitScanForward256());
370                         break;
371                     }
372                 } 
373             }
374         }
375     }
376 
377     function getBucket(BitMap storage bitmap, uint256 bucket) internal view returns (uint256) {
378         return bitmap._data[bucket];
379     }
380 }
381 
382 // File: @openzeppelin/contracts/utils/StorageSlot.sol
383 
384 
385 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
386 
387 //pragma solidity ^0.8.0;
388 
389 /**
390  * @dev Library for reading and writing primitive types to specific storage slots.
391  *
392  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
393  * This library helps with reading and writing to such slots without the need for inline assembly.
394  *
395  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
396  *
397  * Example usage to set ERC1967 implementation slot:
398  * ```
399  * contract ERC1967 {
400  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
401  *
402  *     function _getImplementation() internal view returns (address) {
403  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
404  *     }
405  *
406  *     function _setImplementation(address newImplementation) internal {
407  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
408  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
409  *     }
410  * }
411  * ```
412  *
413  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
414  */
415 library StorageSlot {
416     struct AddressSlot {
417         address value;
418     }
419 
420     struct BooleanSlot {
421         bool value;
422     }
423 
424     struct Bytes32Slot {
425         bytes32 value;
426     }
427 
428     struct Uint256Slot {
429         uint256 value;
430     }
431 
432     /**
433      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
434      */
435     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
436         /// @solidity memory-safe-assembly
437         assembly {
438             r.slot := slot
439         }
440     }
441 
442     /**
443      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
444      */
445     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
446         /// @solidity memory-safe-assembly
447         assembly {
448             r.slot := slot
449         }
450     }
451 
452     /**
453      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
454      */
455     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
456         /// @solidity memory-safe-assembly
457         assembly {
458             r.slot := slot
459         }
460     }
461 
462     /**
463      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
464      */
465     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
466         /// @solidity memory-safe-assembly
467         assembly {
468             r.slot := slot
469         }
470     }
471 }
472 
473 // File: @openzeppelin/contracts/utils/Address.sol
474 
475 
476 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
477 
478 //pragma solidity ^0.8.1;
479 
480 /**
481  * @dev Collection of functions related to the address type
482  */
483 library Address {
484     /**
485      * @dev Returns true if `account` is a contract.
486      *
487      * [IMPORTANT]
488      * ====
489      * It is unsafe to assume that an address for which this function returns
490      * false is an externally-owned account (EOA) and not a contract.
491      *
492      * Among others, `isContract` will return false for the following
493      * types of addresses:
494      *
495      *  - an externally-owned account
496      *  - a contract in construction
497      *  - an address where a contract will be created
498      *  - an address where a contract lived, but was destroyed
499      * ====
500      *
501      * [IMPORTANT]
502      * ====
503      * You shouldn't rely on `isContract` to protect against flash loan attacks!
504      *
505      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
506      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
507      * constructor.
508      * ====
509      */
510     function isContract(address account) internal view returns (bool) {
511         // This method relies on extcodesize/address.code.length, which returns 0
512         // for contracts in construction, since the code is only stored at the end
513         // of the constructor execution.
514 
515         return account.code.length > 0;
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
686                 /// @solidity memory-safe-assembly
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
698 // File: @openzeppelin/contracts/utils/Strings.sol
699 
700 
701 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
702 
703 //pragma solidity ^0.8.0;
704 
705 /**
706  * @dev String operations.
707  */
708 library Strings {
709     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
710     uint8 private constant _ADDRESS_LENGTH = 20;
711 
712     /**
713      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
714      */
715     function toString(uint256 value) internal pure returns (string memory) {
716         // Inspired by OraclizeAPI's implementation - MIT licence
717         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
718 
719         if (value == 0) {
720             return "0";
721         }
722         uint256 temp = value;
723         uint256 digits;
724         while (temp != 0) {
725             digits++;
726             temp /= 10;
727         }
728         bytes memory buffer = new bytes(digits);
729         while (value != 0) {
730             digits -= 1;
731             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
732             value /= 10;
733         }
734         return string(buffer);
735     }
736 
737     /**
738      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
739      */
740     function toHexString(uint256 value) internal pure returns (string memory) {
741         if (value == 0) {
742             return "0x00";
743         }
744         uint256 temp = value;
745         uint256 length = 0;
746         while (temp != 0) {
747             length++;
748             temp >>= 8;
749         }
750         return toHexString(value, length);
751     }
752 
753     /**
754      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
755      */
756     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
757         bytes memory buffer = new bytes(2 * length + 2);
758         buffer[0] = "0";
759         buffer[1] = "x";
760         for (uint256 i = 2 * length + 1; i > 1; --i) {
761             buffer[i] = _HEX_SYMBOLS[value & 0xf];
762             value >>= 4;
763         }
764         require(value == 0, "Strings: hex length insufficient");
765         return string(buffer);
766     }
767 
768     /**
769      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
770      */
771     function toHexString(address addr) internal pure returns (string memory) {
772         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
773     }
774 }
775 
776 // File: @openzeppelin/contracts/utils/Context.sol
777 
778 
779 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
780 
781 //pragma solidity ^0.8.0;
782 
783 /**
784  * @dev Provides information about the current execution context, including the
785  * sender of the transaction and its data. While these are generally available
786  * via msg.sender and msg.data, they should not be accessed in such a direct
787  * manner, since when dealing with meta-transactions the account sending and
788  * paying for execution may not be the actual sender (as far as an application
789  * is concerned).
790  *
791  * This contract is only required for intermediate, library-like contracts.
792  */
793 abstract contract Context {
794     function _msgSender() internal view virtual returns (address) {
795         return msg.sender;
796     }
797 
798     function _msgData() internal view virtual returns (bytes calldata) {
799         return msg.data;
800     }
801 }
802 
803 // File: @openzeppelin/contracts/access/Ownable.sol
804 
805 
806 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
807 
808 //pragma solidity ^0.8.0;
809 
810 
811 /**
812  * @dev Contract module which provides a basic access control mechanism, where
813  * there is an account (an owner) that can be granted exclusive access to
814  * specific functions.
815  *
816  * By default, the owner account will be the one that deploys the contract. This
817  * can later be changed with {transferOwnership}.
818  *
819  * This module is used through inheritance. It will make available the modifier
820  * `onlyOwner`, which can be applied to your functions to restrict their use to
821  * the owner.
822  */
823 abstract contract Ownable is Context {
824     address private _owner;
825 
826     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
827 
828     /**
829      * @dev Initializes the contract setting the deployer as the initial owner.
830      */
831     constructor() {
832         _transferOwnership(_msgSender());
833     }
834 
835     /**
836      * @dev Throws if called by any account other than the owner.
837      */
838     modifier onlyOwner() {
839         _checkOwner();
840         _;
841     }
842 
843     /**
844      * @dev Returns the address of the current owner.
845      */
846     function owner() public view virtual returns (address) {
847         return _owner;
848     }
849 
850     /**
851      * @dev Throws if the sender is not the owner.
852      */
853     function _checkOwner() internal view virtual {
854         require(owner() == _msgSender(), "Ownable: caller is not the owner");
855     }
856 
857     /**
858      * @dev Leaves the contract without owner. It will not be possible to call
859      * `onlyOwner` functions anymore. Can only be called by the current owner.
860      *
861      * NOTE: Renouncing ownership will leave the contract without an owner,
862      * thereby removing any functionality that is only available to the owner.
863      */
864     function renounceOwnership() public virtual onlyOwner {
865         _transferOwnership(address(0));
866     }
867 
868     /**
869      * @dev Transfers ownership of the contract to a new account (`newOwner`).
870      * Can only be called by the current owner.
871      */
872     function transferOwnership(address newOwner) public virtual onlyOwner {
873         require(newOwner != address(0), "Ownable: new owner is the zero address");
874         _transferOwnership(newOwner);
875     }
876 
877     /**
878      * @dev Transfers ownership of the contract to a new account (`newOwner`).
879      * Internal function without access restriction.
880      */
881     function _transferOwnership(address newOwner) internal virtual {
882         address oldOwner = _owner;
883         _owner = newOwner;
884         emit OwnershipTransferred(oldOwner, newOwner);
885     }
886 }
887 
888 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
889 
890 
891 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
892 
893 //pragma solidity ^0.8.0;
894 
895 /**
896  * @title ERC721 token receiver interface
897  * @dev Interface for any contract that wants to support safeTransfers
898  * from ERC721 asset contracts.
899  */
900 interface IERC721Receiver {
901     /**
902      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
903      * by `operator` from `from`, this function is called.
904      *
905      * It must return its Solidity selector to confirm the token transfer.
906      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
907      *
908      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
909      */
910     function onERC721Received(
911         address operator,
912         address from,
913         uint256 tokenId,
914         bytes calldata data
915     ) external returns (bytes4);
916 }
917 
918 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
919 
920 
921 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
922 
923 //pragma solidity ^0.8.0;
924 
925 /**
926  * @dev Interface of the ERC165 standard, as defined in the
927  * https://eips.ethereum.org/EIPS/eip-165[EIP].
928  *
929  * Implementers can declare support of contract interfaces, which can then be
930  * queried by others ({ERC165Checker}).
931  *
932  * For an implementation, see {ERC165}.
933  */
934 interface IERC165 {
935     /**
936      * @dev Returns true if this contract implements the interface defined by
937      * `interfaceId`. See the corresponding
938      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
939      * to learn more about how these ids are created.
940      *
941      * This function call must use less than 30 000 gas.
942      */
943     function supportsInterface(bytes4 interfaceId) external view returns (bool);
944 }
945 
946 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
947 
948 
949 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
950 
951 //pragma solidity ^0.8.0;
952 
953 
954 /**
955  * @dev Implementation of the {IERC165} interface.
956  *
957  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
958  * for the additional interface id that will be supported. For example:
959  *
960  * ```solidity
961  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
962  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
963  * }
964  * ```
965  *
966  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
967  */
968 abstract contract ERC165 is IERC165 {
969     /**
970      * @dev See {IERC165-supportsInterface}.
971      */
972     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
973         return interfaceId == type(IERC165).interfaceId;
974     }
975 }
976 
977 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
978 
979 
980 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
981 
982 //pragma solidity ^0.8.0;
983 
984 
985 /**
986  * @dev Required interface of an ERC721 compliant contract.
987  */
988 interface IERC721 is IERC165 {
989     /**
990      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
991      */
992     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
993 
994     /**
995      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
996      */
997     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
998 
999     /**
1000      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1001      */
1002     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1003 
1004     /**
1005      * @dev Returns the number of tokens in ``owner``'s account.
1006      */
1007     function balanceOf(address owner) external view returns (uint256 balance);
1008 
1009     /**
1010      * @dev Returns the owner of the `tokenId` token.
1011      *
1012      * Requirements:
1013      *
1014      * - `tokenId` must exist.
1015      */
1016     function ownerOf(uint256 tokenId) external view returns (address owner);
1017 
1018     /**
1019      * @dev Safely transfers `tokenId` token from `from` to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `from` cannot be the zero address.
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must exist and be owned by `from`.
1026      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1027      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function safeTransferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes calldata data
1036     ) external;
1037 
1038     /**
1039      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1040      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1041      *
1042      * Requirements:
1043      *
1044      * - `from` cannot be the zero address.
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must exist and be owned by `from`.
1047      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1048      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) external;
1057 
1058     /**
1059      * @dev Transfers `tokenId` token from `from` to `to`.
1060      *
1061      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1062      *
1063      * Requirements:
1064      *
1065      * - `from` cannot be the zero address.
1066      * - `to` cannot be the zero address.
1067      * - `tokenId` token must be owned by `from`.
1068      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function transferFrom(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) external;
1077 
1078     /**
1079      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1080      * The approval is cleared when the token is transferred.
1081      *
1082      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1083      *
1084      * Requirements:
1085      *
1086      * - The caller must own the token or be an approved operator.
1087      * - `tokenId` must exist.
1088      *
1089      * Emits an {Approval} event.
1090      */
1091     function approve(address to, uint256 tokenId) external;
1092 
1093     /**
1094      * @dev Approve or remove `operator` as an operator for the caller.
1095      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1096      *
1097      * Requirements:
1098      *
1099      * - The `operator` cannot be the caller.
1100      *
1101      * Emits an {ApprovalForAll} event.
1102      */
1103     function setApprovalForAll(address operator, bool _approved) external;
1104 
1105     /**
1106      * @dev Returns the account approved for `tokenId` token.
1107      *
1108      * Requirements:
1109      *
1110      * - `tokenId` must exist.
1111      */
1112     function getApproved(uint256 tokenId) external view returns (address operator);
1113 
1114     /**
1115      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1116      *
1117      * See {setApprovalForAll}
1118      */
1119     function isApprovedForAll(address owner, address operator) external view returns (bool);
1120 }
1121 
1122 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1123 
1124 
1125 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1126 
1127 //pragma solidity ^0.8.0;
1128 
1129 
1130 /**
1131  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1132  * @dev See https://eips.ethereum.org/EIPS/eip-721
1133  */
1134 interface IERC721Enumerable is IERC721 {
1135     /**
1136      * @dev Returns the total amount of tokens stored by the contract.
1137      */
1138     function totalSupply() external view returns (uint256);
1139 
1140     /**
1141      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1142      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1143      */
1144     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1145 
1146     /**
1147      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1148      * Use along with {totalSupply} to enumerate all tokens.
1149      */
1150     function tokenByIndex(uint256 index) external view returns (uint256);
1151 }
1152 
1153 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1154 
1155 
1156 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1157 
1158 //pragma solidity ^0.8.0;
1159 
1160 
1161 /**
1162  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1163  * @dev See https://eips.ethereum.org/EIPS/eip-721
1164  */
1165 interface IERC721Metadata is IERC721 {
1166     /**
1167      * @dev Returns the token collection name.
1168      */
1169     function name() external view returns (string memory);
1170 
1171     /**
1172      * @dev Returns the token collection symbol.
1173      */
1174     function symbol() external view returns (string memory);
1175 
1176     /**
1177      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1178      */
1179     function tokenURI(uint256 tokenId) external view returns (string memory);
1180 }
1181 
1182 // File: docs.chain.link/EVAKeepersAutomationPsi.sol
1183 
1184 
1185 /**
1186   ______ _____   _____ ______ ___  __ _  _  _ 
1187  |  ____|  __ \ / ____|____  |__ \/_ | || || |
1188  | |__  | |__) | |        / /   ) || | \| |/ |
1189  |  __| |  _  /| |       / /   / / | |\_   _/ 
1190  | |____| | \ \| |____  / /   / /_ | |  | |   
1191  |______|_|  \_\\_____|/_/   |____||_|  |_|   
1192 
1193  - github: https://github.com/estarriolvetch/ERC721Psi
1194  - npm: https://www.npmjs.com/package/erc721psi
1195                                           
1196  */
1197 
1198 //pragma solidity ^0.8.0;
1199 
1200 
1201 interface KeeperCompatibleInterface {
1202   /**
1203    * @notice method that is simulated by the keepers to see if any work actually
1204    * needs to be performed. This method does does not actually need to be
1205    * executable, and since it is only ever simulated it can consume lots of gas.
1206    * @dev To ensure that it is never called, you may want to add the
1207    * cannotExecute modifier from KeeperBase to your implementation of this
1208    * method.
1209    * @param checkData specified in the upkeep registration so it is always the
1210    * same for a registered upkeep. This can easily be broken down into specific
1211    * arguments using `abi.decode`, so multiple upkeeps can be registered on the
1212    * same contract and easily differentiated by the contract.
1213    * @return upkeepNeeded boolean to indicate whether the keeper should call
1214    * performUpkeep or not.
1215    * @return performData bytes that the keeper should call performUpkeep with, if
1216    * upkeep is needed. If you would like to encode data to decode later, try
1217    * `abi.encode`.
1218    */
1219   function checkUpkeep(bytes calldata checkData) external returns (bool upkeepNeeded, bytes memory performData);
1220 
1221   /**
1222    * @notice method that is actually executed by the keepers, via the registry.
1223    * The data returned by the checkUpkeep simulation will be passed into
1224    * this method to actually be executed.
1225    * @dev The input to this method should not be trusted, and the caller of the
1226    * method should not even be restricted to any single registry. Anyone should
1227    * be able call it, and the input should be validated, there is no guarantee
1228    * that the data passed in is the performData returned from checkUpkeep. This
1229    * could happen due to malicious keepers, racing keepers, or simply a state
1230    * change while the performUpkeep transaction is waiting for confirmation.
1231    * Always validate the data passed in.
1232    * @param performData is the data which was passed back from the checkData
1233    * simulation. If it is encoded, it can easily be decoded into other types by
1234    * calling `abi.decode`. This data should not be trusted, and should be
1235    * validated against the contract's current state.
1236    */
1237   function performUpkeep(bytes calldata performData) external;
1238 }
1239 
1240 // File: @chainlink/contracts/src/v0.8/KeeperBase.sol
1241 
1242 
1243 contract KeeperBase {
1244   error OnlySimulatedBackend();
1245 
1246   /**
1247    * @notice method that allows it to be simulated via eth_call by checking that
1248    * the sender is the zero address.
1249    */
1250   function preventExecution() internal view {
1251     if (tx.origin != address(0)) {
1252       revert OnlySimulatedBackend();
1253     }
1254   }
1255 
1256   /**
1257    * @notice modifier that allows it to be simulated via eth_call by checking
1258    * that the sender is the zero address.
1259    */
1260   modifier cannotExecute() {
1261     preventExecution();
1262     _;
1263   }
1264 }
1265 
1266 // File: @chainlink/contracts/src/v0.8/KeeperCompatible.sol
1267 
1268 
1269 
1270 
1271 abstract contract KeeperCompatible is KeeperBase, KeeperCompatibleInterface {}
1272 
1273 
1274 
1275 // File: SafeMath.sol
1276 
1277 /**
1278  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1279  * checks.
1280  *
1281  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1282  * in bugs, because programmers usually assume that an overflow raises an
1283  * error, which is the standard behavior in high level programming languages.
1284  * `SafeMath` restores this intuition by reverting the transaction when an
1285  * operation overflows.
1286  *
1287  * Using this library instead of the unchecked operations eliminates an entire
1288  * class of bugs, so it's recommended to use it always.
1289  */
1290 library SafeMath {
1291     /**
1292      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1293      *
1294      * _Available since v3.4._
1295      */
1296     function tryAdd(uint256 a, uint256 b)
1297         internal
1298         pure
1299         returns (bool, uint256)
1300     {
1301         uint256 c = a + b;
1302         if (c < a) return (false, 0);
1303         return (true, c);
1304     }
1305 
1306     /**
1307      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1308      *
1309      * _Available since v3.4._
1310      */
1311     function trySub(uint256 a, uint256 b)
1312         internal
1313         pure
1314         returns (bool, uint256)
1315     {
1316         if (b > a) return (false, 0);
1317         return (true, a - b);
1318     }
1319 
1320     /**
1321      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1322      *
1323      * _Available since v3.4._
1324      */
1325     function tryMul(uint256 a, uint256 b)
1326         internal
1327         pure
1328         returns (bool, uint256)
1329     {
1330         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1331         // benefit is lost if 'b' is also tested.
1332         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1333         if (a == 0) return (true, 0);
1334         uint256 c = a * b;
1335         if (c / a != b) return (false, 0);
1336         return (true, c);
1337     }
1338 
1339     /**
1340      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1341      *
1342      * _Available since v3.4._
1343      */
1344     function tryDiv(uint256 a, uint256 b)
1345         internal
1346         pure
1347         returns (bool, uint256)
1348     {
1349         if (b == 0) return (false, 0);
1350         return (true, a / b);
1351     }
1352 
1353     /**
1354      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1355      *
1356      * _Available since v3.4._
1357      */
1358     function tryMod(uint256 a, uint256 b)
1359         internal
1360         pure
1361         returns (bool, uint256)
1362     {
1363         if (b == 0) return (false, 0);
1364         return (true, a % b);
1365     }
1366 
1367     /**
1368      * @dev Returns the addition of two unsigned integers, reverting on
1369      * overflow.
1370      *
1371      * Counterpart to Solidity's `+` operator.
1372      *
1373      * Requirements:
1374      *
1375      * - Addition cannot overflow.
1376      */
1377     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1378         uint256 c = a + b;
1379         require(c >= a, "SafeMath: addition overflow");
1380         return c;
1381     }
1382 
1383     /**
1384      * @dev Returns the subtraction of two unsigned integers, reverting on
1385      * overflow (when the result is negative).
1386      *
1387      * Counterpart to Solidity's `-` operator.
1388      *
1389      * Requirements:
1390      *
1391      * - Subtraction cannot overflow.
1392      */
1393     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1394         require(b <= a, "SafeMath: subtraction overflow");
1395         return a - b;
1396     }
1397 
1398     /**
1399      * @dev Returns the multiplication of two unsigned integers, reverting on
1400      * overflow.
1401      *
1402      * Counterpart to Solidity's `*` operator.
1403      *
1404      * Requirements:
1405      *
1406      * - Multiplication cannot overflow.
1407      */
1408     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1409         if (a == 0) return 0;
1410         uint256 c = a * b;
1411         require(c / a == b, "SafeMath: multiplication overflow");
1412         return c;
1413     }
1414 
1415     /**
1416      * @dev Returns the integer division of two unsigned integers, reverting on
1417      * division by zero. The result is rounded towards zero.
1418      *
1419      * Counterpart to Solidity's `/` operator. Note: this function uses a
1420      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1421      * uses an invalid opcode to revert (consuming all remaining gas).
1422      *
1423      * Requirements:
1424      *
1425      * - The divisor cannot be zero.
1426      */
1427     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1428         require(b > 0, "SafeMath: division by zero");
1429         return a / b;
1430     }
1431 
1432     /**
1433      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1434      * reverting when dividing by zero.
1435      *
1436      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1437      * opcode (which leaves remaining gas untouched) while Solidity uses an
1438      * invalid opcode to revert (consuming all remaining gas).
1439      *
1440      * Requirements:
1441      *
1442      * - The divisor cannot be zero.
1443      */
1444     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1445         require(b > 0, "SafeMath: modulo by zero");
1446         return a % b;
1447     }
1448 
1449     /**
1450      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1451      * overflow (when the result is negative).
1452      *
1453      * CAUTION: This function is deprecated because it requires allocating memory for the error
1454      * message unnecessarily. For custom revert reasons use {trySub}.
1455      *
1456      * Counterpart to Solidity's `-` operator.
1457      *
1458      * Requirements:
1459      *
1460      * - Subtraction cannot overflow.
1461      */
1462     function sub(
1463         uint256 a,
1464         uint256 b,
1465         string memory errorMessage
1466     ) internal pure returns (uint256) {
1467         require(b <= a, errorMessage);
1468         return a - b;
1469     }
1470 
1471     /**
1472      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1473      * division by zero. The result is rounded towards zero.
1474      *
1475      * CAUTION: This function is deprecated because it requires allocating memory for the error
1476      * message unnecessarily. For custom revert reasons use {tryDiv}.
1477      *
1478      * Counterpart to Solidity's `/` operator. Note: this function uses a
1479      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1480      * uses an invalid opcode to revert (consuming all remaining gas).
1481      *
1482      * Requirements:
1483      *
1484      * - The divisor cannot be zero.
1485      */
1486     function div(
1487         uint256 a,
1488         uint256 b,
1489         string memory errorMessage
1490     ) internal pure returns (uint256) {
1491         require(b > 0, errorMessage);
1492         return a / b;
1493     }
1494 
1495     /**
1496      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1497      * reverting with custom message when dividing by zero.
1498      *
1499      * CAUTION: This function is deprecated because it requires allocating memory for the error
1500      * message unnecessarily. For custom revert reasons use {tryMod}.
1501      *
1502      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1503      * opcode (which leaves remaining gas untouched) while Solidity uses an
1504      * invalid opcode to revert (consuming all remaining gas).
1505      *
1506      * Requirements:
1507      *
1508      * - The divisor cannot be zero.
1509      */
1510     function mod(
1511         uint256 a,
1512         uint256 b,
1513         string memory errorMessage
1514     ) internal pure returns (uint256) {
1515         require(b > 0, errorMessage);
1516         return a % b;
1517     }
1518 }
1519 
1520 contract ERC721Psi is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1521     using Address for address;
1522     using Strings for uint256;
1523     using BitMaps for BitMaps.BitMap;
1524 
1525     BitMaps.BitMap private _batchHead;
1526 
1527     string private _name;
1528     string private _symbol;
1529 
1530     // Mapping from token ID to owner address
1531     mapping(uint256 => address) internal _owners;
1532     uint256 internal _minted;
1533 
1534     mapping(uint256 => address) private _tokenApprovals;
1535     mapping(address => mapping(address => bool)) private _operatorApprovals;
1536 
1537     /**
1538      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1539      */
1540     constructor(string memory name_, string memory symbol_) {
1541         _name = name_;
1542         _symbol = symbol_;
1543     }
1544 
1545     /**
1546      * @dev See {IERC165-supportsInterface}.
1547      */
1548     function supportsInterface(bytes4 interfaceId)
1549         public
1550         view
1551         virtual
1552         override(ERC165, IERC165)
1553         returns (bool)
1554     {
1555         return
1556             interfaceId == type(IERC721).interfaceId ||
1557             interfaceId == type(IERC721Metadata).interfaceId ||
1558             interfaceId == type(IERC721Enumerable).interfaceId ||
1559             super.supportsInterface(interfaceId);
1560     }
1561 
1562     /**
1563      * @dev See {IERC721-balanceOf}.
1564      */
1565     function balanceOf(address owner) 
1566         public 
1567         view 
1568         virtual 
1569         override 
1570         returns (uint) 
1571     {
1572         require(owner != address(0), "ERC721Psi: balance query for the zero address");
1573 
1574         uint count;
1575         for( uint i; i < _minted; ++i ){
1576             if(_exists(i)){
1577                 if( owner == ownerOf(i)){
1578                     ++count;
1579                 }
1580             }
1581         }
1582         return count;
1583     }
1584 
1585     /**
1586      * @dev See {IERC721-ownerOf}.
1587      */
1588     function ownerOf(uint256 tokenId)
1589         public
1590         view
1591         virtual
1592         override
1593         returns (address)
1594     {
1595         (address owner, ) = _ownerAndBatchHeadOf(tokenId);
1596         return owner;
1597     }
1598 
1599     function _ownerAndBatchHeadOf(uint256 tokenId) internal view returns (address owner, uint256 tokenIdBatchHead){
1600         require(_exists(tokenId), "ERC721Psi: owner query for nonexistent token");
1601         tokenIdBatchHead = _getBatchHead(tokenId);
1602         owner = _owners[tokenIdBatchHead];
1603     }
1604 
1605     /**
1606      * @dev See {IERC721Metadata-name}.
1607      */
1608     function name() public view virtual override returns (string memory) {
1609         return _name;
1610     }
1611 
1612     /**
1613      * @dev See {IERC721Metadata-symbol}.
1614      */
1615     function symbol() public view virtual override returns (string memory) {
1616         return _symbol;
1617     }
1618 
1619     /**
1620      * @dev See {IERC721Metadata-tokenURI}.
1621      */
1622     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1623         require(_exists(tokenId), "ERC721Psi: URI query for nonexistent token");
1624 
1625         string memory baseURI = _baseURI();
1626         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1627     }
1628 
1629     /**
1630      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1631      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1632      * by default, can be overriden in child contracts.
1633      */
1634     function _baseURI() internal view virtual returns (string memory) {
1635         return "";
1636     }
1637 
1638 
1639     /**
1640      * @dev See {IERC721-approve}.
1641      */
1642     function approve(address to, uint256 tokenId) public virtual override {
1643         address owner = ownerOf(tokenId);
1644         require(to != owner, "ERC721Psi: approval to current owner");
1645 
1646         require(
1647             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1648             "ERC721Psi: approve caller is not owner nor approved for all"
1649         );
1650 
1651         _approve(to, tokenId);
1652     }
1653 
1654     /**
1655      * @dev See {IERC721-getApproved}.
1656      */
1657     function getApproved(uint256 tokenId)
1658         public
1659         view
1660         virtual
1661         override
1662         returns (address)
1663     {
1664         require(
1665             _exists(tokenId),
1666             "ERC721Psi: approved query for nonexistent token"
1667         );
1668 
1669         return _tokenApprovals[tokenId];
1670     }
1671 
1672     /**
1673      * @dev See {IERC721-setApprovalForAll}.
1674      */
1675     function setApprovalForAll(address operator, bool approved)
1676         public
1677         virtual
1678         override
1679     {
1680         require(operator != _msgSender(), "ERC721Psi: approve to caller");
1681 
1682         _operatorApprovals[_msgSender()][operator] = approved;
1683         emit ApprovalForAll(_msgSender(), operator, approved);
1684     }
1685 
1686     /**
1687      * @dev See {IERC721-isApprovedForAll}.
1688      */
1689     function isApprovedForAll(address owner, address operator)
1690         public
1691         view
1692         virtual
1693         override
1694         returns (bool)
1695     {
1696         return _operatorApprovals[owner][operator];
1697     }
1698 
1699     /**
1700      * @dev See {IERC721-transferFrom}.
1701      */
1702     function transferFrom(
1703         address from,
1704         address to,
1705         uint256 tokenId
1706     ) public virtual override {
1707         //solhint-disable-next-line max-line-length
1708         require(
1709             _isApprovedOrOwner(_msgSender(), tokenId),
1710             "ERC721Psi: transfer caller is not owner nor approved"
1711         );
1712 
1713         _transfer(from, to, tokenId);
1714     }
1715 
1716     /**
1717      * @dev See {IERC721-safeTransferFrom}.
1718      */
1719     function safeTransferFrom(
1720         address from,
1721         address to,
1722         uint256 tokenId
1723     ) public virtual override {
1724         safeTransferFrom(from, to, tokenId, "");
1725     }
1726 
1727     /**
1728      * @dev See {IERC721-safeTransferFrom}.
1729      */
1730     function safeTransferFrom(
1731         address from,
1732         address to,
1733         uint256 tokenId,
1734         bytes memory _data
1735     ) public virtual override {
1736         require(
1737             _isApprovedOrOwner(_msgSender(), tokenId),
1738             "ERC721Psi: transfer caller is not owner nor approved"
1739         );
1740         _safeTransfer(from, to, tokenId, _data);
1741     }
1742 
1743     /**
1744      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1745      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1746      *
1747      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1748      *
1749      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1750      * implement alternative mechanisms to perform token transfer, such as signature-based.
1751      *
1752      * Requirements:
1753      *
1754      * - `from` cannot be the zero address.
1755      * - `to` cannot be the zero address.
1756      * - `tokenId` token must exist and be owned by `from`.
1757      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1758      *
1759      * Emits a {Transfer} event.
1760      */
1761     function _safeTransfer(
1762         address from,
1763         address to,
1764         uint256 tokenId,
1765         bytes memory _data
1766     ) internal virtual {
1767         _transfer(from, to, tokenId);
1768         require(
1769             _checkOnERC721Received(from, to, tokenId, 1,_data),
1770             "ERC721Psi: transfer to non ERC721Receiver implementer"
1771         );
1772     }
1773 
1774     /**
1775      * @dev Returns whether `tokenId` exists.
1776      *
1777      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1778      *
1779      * Tokens start existing when they are minted (`_mint`).
1780      */
1781     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1782         return tokenId < _minted;
1783     }
1784 
1785     /**
1786      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1787      *
1788      * Requirements:
1789      *
1790      * - `tokenId` must exist.
1791      */
1792     function _isApprovedOrOwner(address spender, uint256 tokenId)
1793         internal
1794         view
1795         virtual
1796         returns (bool)
1797     {
1798         require(
1799             _exists(tokenId),
1800             "ERC721Psi: operator query for nonexistent token"
1801         );
1802         address owner = ownerOf(tokenId);
1803         return (spender == owner ||
1804             getApproved(tokenId) == spender ||
1805             isApprovedForAll(owner, spender));
1806     }
1807 
1808     /**
1809      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1810      *
1811      * Requirements:
1812      *
1813      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1814      * - `quantity` must be greater than 0.
1815      *
1816      * Emits a {Transfer} event.
1817      */
1818     function _safeMint(address to, uint256 quantity) internal virtual {
1819         _safeMint(to, quantity, "");
1820     }
1821 
1822     
1823     function _safeMint(
1824         address to,
1825         uint256 quantity,
1826         bytes memory _data
1827     ) internal virtual {
1828         uint256 startTokenId = _minted;
1829         _mint(to, quantity);
1830         require(
1831             _checkOnERC721Received(address(0), to, startTokenId, quantity, _data),
1832             "ERC721Psi: transfer to non ERC721Receiver implementer"
1833         );
1834     }
1835 
1836 
1837     function _mint(
1838         address to,
1839         uint256 quantity
1840     ) internal virtual {
1841         uint256 tokenIdBatchHead = _minted;
1842         
1843         require(quantity > 0, "ERC721Psi: quantity must be greater 0");
1844         require(to != address(0), "ERC721Psi: mint to the zero address");
1845         
1846         _beforeTokenTransfers(address(0), to, tokenIdBatchHead, quantity);
1847         _minted += quantity;
1848         _owners[tokenIdBatchHead] = to;
1849         _batchHead.set(tokenIdBatchHead);
1850         _afterTokenTransfers(address(0), to, tokenIdBatchHead, quantity);
1851         
1852         // Emit events
1853         for(uint256 tokenId=tokenIdBatchHead;tokenId < tokenIdBatchHead + quantity; tokenId++){
1854             emit Transfer(address(0), to, tokenId);
1855         } 
1856     }
1857 
1858 
1859     /**
1860      * @dev Transfers `tokenId` from `from` to `to`.
1861      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1862      *
1863      * Requirements:
1864      *
1865      * - `to` cannot be the zero address.
1866      * - `tokenId` token must be owned by `from`.
1867      *
1868      * Emits a {Transfer} event.
1869      */
1870     function _transfer(
1871         address from,
1872         address to,
1873         uint256 tokenId
1874     ) internal virtual {
1875         (address owner, uint256 tokenIdBatchHead) = _ownerAndBatchHeadOf(tokenId);
1876 
1877         require(
1878             owner == from,
1879             "ERC721Psi: transfer of token that is not own"
1880         );
1881         require(to != address(0), "ERC721Psi: transfer to the zero address");
1882 
1883         _beforeTokenTransfers(from, to, tokenId, 1);
1884 
1885         // Clear approvals from the previous owner
1886         _approve(address(0), tokenId);   
1887 
1888         uint256 nextTokenId = tokenId + 1;
1889 
1890         if(!_batchHead.get(nextTokenId) &&  
1891             nextTokenId < _minted
1892         ) {
1893             _owners[nextTokenId] = from;
1894             _batchHead.set(nextTokenId);
1895         }
1896 
1897         _owners[tokenId] = to;
1898         if(tokenId != tokenIdBatchHead) {
1899             _batchHead.set(tokenId);
1900         }
1901 
1902         emit Transfer(from, to, tokenId);
1903 
1904         _afterTokenTransfers(from, to, tokenId, 1);
1905     }
1906 
1907     /**
1908      * @dev Approve `to` to operate on `tokenId`
1909      *
1910      * Emits a {Approval} event.
1911      */
1912     function _approve(address to, uint256 tokenId) internal virtual {
1913         _tokenApprovals[tokenId] = to;
1914         emit Approval(ownerOf(tokenId), to, tokenId);
1915     }
1916 
1917     /**
1918      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1919      * The call is not executed if the target address is not a contract.
1920      *
1921      * @param from address representing the previous owner of the given token ID
1922      * @param to target address that will receive the tokens
1923      * @param startTokenId uint256 the first ID of the tokens to be transferred
1924      * @param quantity uint256 amount of the tokens to be transfered.
1925      * @param _data bytes optional data to send along with the call
1926      * @return r bool whether the call correctly returned the expected magic value
1927      */
1928     function _checkOnERC721Received(
1929         address from,
1930         address to,
1931         uint256 startTokenId,
1932         uint256 quantity,
1933         bytes memory _data
1934     ) private returns (bool r) {
1935         if (to.isContract()) {
1936             r = true;
1937             for(uint256 tokenId = startTokenId; tokenId < startTokenId + quantity; tokenId++){
1938                 try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1939                     r = r && retval == IERC721Receiver.onERC721Received.selector;
1940                 } catch (bytes memory reason) {
1941                     if (reason.length == 0) {
1942                         revert("ERC721Psi: transfer to non ERC721Receiver implementer");
1943                     } else {
1944                         assembly {
1945                             revert(add(32, reason), mload(reason))
1946                         }
1947                     }
1948                 }
1949             }
1950             return r;
1951         } else {
1952             return true;
1953         }
1954     }
1955 
1956     function _getBatchHead(uint256 tokenId) internal view returns (uint256 tokenIdBatchHead) {
1957         tokenIdBatchHead = _batchHead.scanForward(tokenId); 
1958     }
1959 
1960     /**
1961      * @dev See {IERC721Enumerable-totalSupply}.
1962      */
1963     function totalSupply() public view virtual override returns (uint256) {
1964         return _minted;
1965     }
1966 
1967     /**
1968      * @dev See {IERC721Enumerable-tokenByIndex}.
1969      */
1970     function tokenByIndex(uint256 index) public view virtual override returns (uint256 tokenId) {
1971         require(index < totalSupply(), "ERC721Psi: global index out of bounds");
1972         
1973         uint count;
1974         for(uint i; i < _minted; i++){
1975             if(_exists(i)){
1976                 if(count == index) return i;
1977                 else count++;
1978             }
1979         }
1980     }
1981 
1982     /**
1983      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1984      */
1985     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1986         uint count;
1987         for(uint i; i < _minted; i++){
1988             if(_exists(i) && owner == ownerOf(i)){
1989                 if(count == index) return i;
1990                 else count++;
1991             }
1992         }
1993 
1994         revert("ERC721Psi: owner index out of bounds");
1995     }
1996 
1997 
1998     /**
1999      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2000      *
2001      * startTokenId - the first token id to be transferred
2002      * quantity - the amount to be transferred
2003      *
2004      * Calling conditions:
2005      *
2006      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2007      * transferred to `to`.
2008      * - When `from` is zero, `tokenId` will be minted for `to`.
2009      */
2010     function _beforeTokenTransfers(
2011         address from,
2012         address to,
2013         uint256 startTokenId,
2014         uint256 quantity
2015     ) internal virtual {}
2016 
2017     /**
2018      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2019      * minting.
2020      *
2021      * startTokenId - the first token id to be transferred
2022      * quantity - the amount to be transferred
2023      *
2024      * Calling conditions:
2025      *
2026      * - when `from` and `to` are both non-zero.
2027      * - `from` and `to` are never both zero.
2028      */
2029     function _afterTokenTransfers(
2030         address from,
2031         address to,
2032         uint256 startTokenId,
2033         uint256 quantity
2034     ) internal virtual {}
2035 }
2036 
2037 
2038 error ApprovalCallerNotOwnerNorApproved();
2039 error ApprovalQueryForNonexistentToken();
2040 error ApproveToCaller();
2041 error ApprovalToCurrentOwner();
2042 error BalanceQueryForZeroAddress();
2043 error MintedQueryForZeroAddress();
2044 error BurnedQueryForZeroAddress();
2045 error MintToZeroAddress();
2046 error MintZeroQuantity();
2047 error OwnerIndexOutOfBounds();
2048 error OwnerQueryForNonexistentToken();
2049 error TokenIndexOutOfBounds();
2050 error TransferCallerNotOwnerNorApproved();
2051 error TransferFromIncorrectOwner();
2052 error TransferToNonERC721ReceiverImplementer();
2053 error TransferToZeroAddress();
2054 error URIQueryForNonexistentToken();
2055 
2056 contract EvaTribe is ERC721Psi, Ownable, KeeperCompatibleInterface {
2057     using SafeMath for uint256;
2058     using Strings for uint;
2059 
2060     /*
2061      * @dev Set Initial Parameters Before deployment
2062      * settings are still fully updateable after deployment
2063      */
2064 
2065     uint256 public maxSupply = 1500;
2066     uint256 public mintRate = 0.08 ether;
2067 
2068     /*
2069     * @Dev Booleans for sale states. 
2070     * salesIsActive must be true in any case to mint
2071     */
2072     bool public saleIsActive = false;
2073 
2074 
2075 
2076 
2077     /*
2078      * @dev Set base URI, Make sure when dpeloying if you plan to Have an 
2079      * Unrevealed Sale or Period you Do not Deploy with your Revealed
2080      * base URI here or they will mint With your revealed Images Showing
2081      */
2082     string private baseURI;
2083     string private imgEnd;
2084     string public notRevealedUri;
2085 
2086     bool public revealed = false;
2087 
2088 
2089     
2090     /*
2091      * @dev Set Collection/Contract name and Token Ticker
2092      * below. Constructor Parameter cannot be changed after
2093      * contract deployment.
2094      */
2095     constructor(string memory _baseUri, string memory _notRevealedUri, string memory _imgEnd) ERC721Psi("Eva", "EVA") {
2096         baseURI = _baseUri;
2097         notRevealedUri = _notRevealedUri;
2098         imgEnd = _imgEnd;
2099     }
2100 
2101 
2102     /**
2103      * @dev See {IERC721Metadata-tokenURI}.
2104      */
2105     function tokenURI(uint256 tokenId) 
2106     public 
2107     view 
2108     virtual 
2109     override 
2110     returns (string memory) {
2111         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2112         if (revealed == false) {
2113             return notRevealedUri;
2114         }
2115       
2116         return string(abi.encodePacked(baseURI, imgEnd, "/", tokenId.toString(), ""));
2117     }
2118 
2119     function devReveal() public onlyOwner {
2120         revealed = true;
2121     }
2122 
2123     function keepersReveal() public {
2124         require (totalSupply() == maxSupply);
2125         require (revealed == false);
2126         revealed = true;
2127     }
2128 
2129     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2130         notRevealedUri = _notRevealedURI;
2131     }
2132 
2133     function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory /* performData */) {
2134         upkeepNeeded = address(this).balance > 1000000000000000000 || totalSupply() == maxSupply && revealed == false;
2135     }
2136 
2137     function performUpkeep(bytes calldata /* performData */) external override {
2138         //We highly recommend revalidating the upkeep in the performUpkeep function
2139         if (address(this).balance > 1000000000000000000) {
2140             withdraw();   
2141         }
2142          if (totalSupply() == maxSupply && revealed == false){
2143             keepersReveal();
2144         }
2145     }
2146 
2147     /*
2148      *@dev
2149      * Set publicsale price to mint per NFT
2150      */
2151     function setPublicMintPrice(uint256 _price) external onlyOwner {
2152         mintRate = _price;
2153     }
2154 
2155     /*
2156     * @dev mint funtion with _to address. no cost mint
2157     *  by contract owner/deployer
2158     */
2159     function Devmint(uint256 quantity, address _to) external onlyOwner {
2160         require(totalSupply() + quantity <= maxSupply, "Not enough tokens left");
2161         _safeMint(_to, quantity);
2162     }
2163 
2164     /*
2165     * @dev mint function and checks for saleState and mint quantity
2166     */   
2167     function mint(uint256 quantity) external payable {
2168         require(saleIsActive, "Sale must be active to mint");
2169         // _safeMint's second argument now takes in a quantity, not a tokenId.
2170         require(totalSupply() + quantity <= maxSupply, "Not enough tokens left to Mint");
2171         require((mintRate * quantity) <= msg.value, "Value below price");
2172 
2173         if (totalSupply() < maxSupply){
2174         _safeMint(msg.sender, quantity);
2175         }
2176     }
2177 
2178     /*
2179      * @dev Set new Base URI
2180      * useful for setting unrevealed uri to revealed Base URI
2181      * same as a reveal switch/state but not the extraness
2182      */
2183     function setBaseURI(string calldata newBaseURI) external onlyOwner {
2184         baseURI = newBaseURI;
2185     }
2186 
2187     //Set imgEnd Funtion..
2188 
2189     function setImgEnd(string calldata newImgEnd) external onlyOwner {
2190         imgEnd = newImgEnd;
2191     }
2192 
2193      /*
2194      * @dev internal baseUri function
2195      */
2196     function _baseURI() internal view override returns (string memory) {
2197         return baseURI;
2198     }
2199 
2200      /*
2201      * @dev Pause sale if active, make active if paused
2202      */
2203     function setSaleActive() public onlyOwner {
2204         saleIsActive = !saleIsActive;
2205     }
2206 
2207     /*
2208      * @dev Public Keepers or to Owner wallet Withdrawl function, Contract ETH balance
2209      * to owner wallet address.
2210      */
2211     function withdraw() public {
2212         payable(owner()).transfer(address(this).balance);
2213     }
2214     
2215     /*
2216     * @dev Alternative withdrawl
2217     * mint funs to a specified address
2218     * 
2219     */
2220     function altWithdraw(uint256 _amount, address payable _to)
2221         external
2222         onlyOwner
2223     {
2224         require(_amount > 0, "Withdraw must be greater than 0");
2225         require(_amount <= address(this).balance, "Amount too high");
2226         (bool success, ) = _to.call{value: _amount}("");
2227         require(success);
2228     }
2229 
2230 }