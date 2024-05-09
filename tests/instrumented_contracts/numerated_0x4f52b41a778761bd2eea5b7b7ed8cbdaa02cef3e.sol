1 // Sources flattened with hardhat v2.10.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.7.1
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.1
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File contracts/interfaces/ILayerZeroReceiver.sol
117 
118 
119 
120 pragma solidity >=0.5.0;
121 
122 interface ILayerZeroReceiver {
123     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
124     // @param _srcChainId - the source endpoint identifier
125     // @param _srcAddress - the source sending contract address from the source chain
126     // @param _nonce - the ordered message nonce
127     // @param _payload - the signed payload is the UA bytes has encoded to be sent
128     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
129 }
130 
131 
132 // File contracts/interfaces/ILayerZeroUserApplicationConfig.sol
133 
134 
135 
136 pragma solidity >=0.5.0;
137 
138 interface ILayerZeroUserApplicationConfig {
139     // @notice set the configuration of the LayerZero messaging library of the specified version
140     // @param _version - messaging library version
141     // @param _chainId - the chainId for the pending config change
142     // @param _configType - type of configuration. every messaging library has its own convention.
143     // @param _config - configuration in the bytes. can encode arbitrary content.
144     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
145 
146     // @notice set the send() LayerZero messaging library version to _version
147     // @param _version - new messaging library version
148     function setSendVersion(uint16 _version) external;
149 
150     // @notice set the lzReceive() LayerZero messaging library version to _version
151     // @param _version - new messaging library version
152     function setReceiveVersion(uint16 _version) external;
153 
154     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
155     // @param _srcChainId - the chainId of the source chain
156     // @param _srcAddress - the contract address of the source contract at the source chain
157     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
158 }
159 
160 
161 // File contracts/interfaces/ILayerZeroEndpoint.sol
162 
163 
164 
165 pragma solidity >=0.5.0;
166 
167 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
168     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
169     // @param _dstChainId - the destination chain identifier
170     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
171     // @param _payload - a custom bytes payload to send to the destination contract
172     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
173     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
174     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
175     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
176 
177     // @notice used by the messaging library to publish verified payload
178     // @param _srcChainId - the source chain identifier
179     // @param _srcAddress - the source contract (as bytes) at the source chain
180     // @param _dstAddress - the address on destination chain
181     // @param _nonce - the unbound message ordering nonce
182     // @param _gasLimit - the gas limit for external contract execution
183     // @param _payload - verified payload to send to the destination contract
184     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
185 
186     // @notice get the inboundNonce of a lzApp from a source chain which could be EVM or non-EVM chain
187     // @param _srcChainId - the source chain identifier
188     // @param _srcAddress - the source chain contract address
189     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
190 
191     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
192     // @param _srcAddress - the source chain contract address
193     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
194 
195     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
196     // @param _dstChainId - the destination chain identifier
197     // @param _userApplication - the user app address on this EVM chain
198     // @param _payload - the custom message to send over LayerZero
199     // @param _payInZRO - if false, user app pays the protocol fee in native token
200     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
201     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
202 
203     // @notice get this Endpoint's immutable source identifier
204     function getChainId() external view returns (uint16);
205 
206     // @notice the interface to retry failed message on this Endpoint destination
207     // @param _srcChainId - the source chain identifier
208     // @param _srcAddress - the source chain contract address
209     // @param _payload - the payload to be retried
210     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
211 
212     // @notice query if any STORED payload (message blocking) at the endpoint.
213     // @param _srcChainId - the source chain identifier
214     // @param _srcAddress - the source chain contract address
215     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
216 
217     // @notice query if the _libraryAddress is valid for sending msgs.
218     // @param _userApplication - the user app address on this EVM chain
219     function getSendLibraryAddress(address _userApplication) external view returns (address);
220 
221     // @notice query if the _libraryAddress is valid for receiving msgs.
222     // @param _userApplication - the user app address on this EVM chain
223     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
224 
225     // @notice query if the non-reentrancy guard for send() is on
226     // @return true if the guard is on. false otherwise
227     function isSendingPayload() external view returns (bool);
228 
229     // @notice query if the non-reentrancy guard for receive() is on
230     // @return true if the guard is on. false otherwise
231     function isReceivingPayload() external view returns (bool);
232 
233     // @notice get the configuration of the LayerZero messaging library of the specified version
234     // @param _version - messaging library version
235     // @param _chainId - the chainId for the pending config change
236     // @param _userApplication - the contract address of the user application
237     // @param _configType - type of configuration. every messaging library has its own convention.
238     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
239 
240     // @notice get the send() LayerZero messaging library version
241     // @param _userApplication - the contract address of the user application
242     function getSendVersion(address _userApplication) external view returns (uint16);
243 
244     // @notice get the lzReceive() LayerZero messaging library version
245     // @param _userApplication - the contract address of the user application
246     function getReceiveVersion(address _userApplication) external view returns (uint16);
247 }
248 
249 
250 // File contracts/util/BytesLib.sol
251 
252 
253 /*
254  * @title Solidity Bytes Arrays Utils
255  * @author Gonçalo Sá <goncalo.sa@consensys.net>
256  *
257  * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
258  *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
259  */
260 pragma solidity >=0.8.0 <0.9.0;
261 
262 
263 library BytesLib {
264     function concat(
265         bytes memory _preBytes,
266         bytes memory _postBytes
267     )
268     internal
269     pure
270     returns (bytes memory)
271     {
272         bytes memory tempBytes;
273 
274         assembly {
275         // Get a location of some free memory and store it in tempBytes as
276         // Solidity does for memory variables.
277             tempBytes := mload(0x40)
278 
279         // Store the length of the first bytes array at the beginning of
280         // the memory for tempBytes.
281             let length := mload(_preBytes)
282             mstore(tempBytes, length)
283 
284         // Maintain a memory counter for the current write location in the
285         // temp bytes array by adding the 32 bytes for the array length to
286         // the starting location.
287             let mc := add(tempBytes, 0x20)
288         // Stop copying when the memory counter reaches the length of the
289         // first bytes array.
290             let end := add(mc, length)
291 
292             for {
293             // Initialize a copy counter to the start of the _preBytes data,
294             // 32 bytes into its memory.
295                 let cc := add(_preBytes, 0x20)
296             } lt(mc, end) {
297             // Increase both counters by 32 bytes each iteration.
298                 mc := add(mc, 0x20)
299                 cc := add(cc, 0x20)
300             } {
301             // Write the _preBytes data into the tempBytes memory 32 bytes
302             // at a time.
303                 mstore(mc, mload(cc))
304             }
305 
306         // Add the length of _postBytes to the current length of tempBytes
307         // and store it as the new length in the first 32 bytes of the
308         // tempBytes memory.
309             length := mload(_postBytes)
310             mstore(tempBytes, add(length, mload(tempBytes)))
311 
312         // Move the memory counter back from a multiple of 0x20 to the
313         // actual end of the _preBytes data.
314             mc := end
315         // Stop copying when the memory counter reaches the new combined
316         // length of the arrays.
317             end := add(mc, length)
318 
319             for {
320                 let cc := add(_postBytes, 0x20)
321             } lt(mc, end) {
322                 mc := add(mc, 0x20)
323                 cc := add(cc, 0x20)
324             } {
325                 mstore(mc, mload(cc))
326             }
327 
328         // Update the free-memory pointer by padding our last write location
329         // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
330         // next 32 byte block, then round down to the nearest multiple of
331         // 32. If the sum of the length of the two arrays is zero then add
332         // one before rounding down to leave a blank 32 bytes (the length block with 0).
333             mstore(0x40, and(
334             add(add(end, iszero(add(length, mload(_preBytes)))), 31),
335             not(31) // Round down to the nearest 32 bytes.
336             ))
337         }
338 
339         return tempBytes;
340     }
341 
342     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
343         assembly {
344         // Read the first 32 bytes of _preBytes storage, which is the length
345         // of the array. (We don't need to use the offset into the slot
346         // because arrays use the entire slot.)
347             let fslot := sload(_preBytes.slot)
348         // Arrays of 31 bytes or less have an even value in their slot,
349         // while longer arrays have an odd value. The actual length is
350         // the slot divided by two for odd values, and the lowest order
351         // byte divided by two for even values.
352         // If the slot is even, bitwise and the slot with 255 and divide by
353         // two to get the length. If the slot is odd, bitwise and the slot
354         // with -1 and divide by two.
355             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
356             let mlength := mload(_postBytes)
357             let newlength := add(slength, mlength)
358         // slength can contain both the length and contents of the array
359         // if length < 32 bytes so let's prepare for that
360         // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
361             switch add(lt(slength, 32), lt(newlength, 32))
362             case 2 {
363             // Since the new array still fits in the slot, we just need to
364             // update the contents of the slot.
365             // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
366                 sstore(
367                 _preBytes.slot,
368                 // all the modifications to the slot are inside this
369                 // next block
370                 add(
371                 // we can just add to the slot contents because the
372                 // bytes we want to change are the LSBs
373                 fslot,
374                 add(
375                 mul(
376                 div(
377                 // load the bytes from memory
378                 mload(add(_postBytes, 0x20)),
379                 // zero all bytes to the right
380                 exp(0x100, sub(32, mlength))
381                 ),
382                 // and now shift left the number of bytes to
383                 // leave space for the length in the slot
384                 exp(0x100, sub(32, newlength))
385                 ),
386                 // increase length by the double of the memory
387                 // bytes length
388                 mul(mlength, 2)
389                 )
390                 )
391                 )
392             }
393             case 1 {
394             // The stored value fits in the slot, but the combined value
395             // will exceed it.
396             // get the keccak hash to get the contents of the array
397                 mstore(0x0, _preBytes.slot)
398                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
399 
400             // save new length
401                 sstore(_preBytes.slot, add(mul(newlength, 2), 1))
402 
403             // The contents of the _postBytes array start 32 bytes into
404             // the structure. Our first read should obtain the `submod`
405             // bytes that can fit into the unused space in the last word
406             // of the stored array. To get this, we read 32 bytes starting
407             // from `submod`, so the data we read overlaps with the array
408             // contents by `submod` bytes. Masking the lowest-order
409             // `submod` bytes allows us to add that value directly to the
410             // stored value.
411 
412                 let submod := sub(32, slength)
413                 let mc := add(_postBytes, submod)
414                 let end := add(_postBytes, mlength)
415                 let mask := sub(exp(0x100, submod), 1)
416 
417                 sstore(
418                 sc,
419                 add(
420                 and(
421                 fslot,
422                 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
423                 ),
424                 and(mload(mc), mask)
425                 )
426                 )
427 
428                 for {
429                     mc := add(mc, 0x20)
430                     sc := add(sc, 1)
431                 } lt(mc, end) {
432                     sc := add(sc, 1)
433                     mc := add(mc, 0x20)
434                 } {
435                     sstore(sc, mload(mc))
436                 }
437 
438                 mask := exp(0x100, sub(mc, end))
439 
440                 sstore(sc, mul(div(mload(mc), mask), mask))
441             }
442             default {
443             // get the keccak hash to get the contents of the array
444                 mstore(0x0, _preBytes.slot)
445             // Start copying to the last used word of the stored array.
446                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
447 
448             // save new length
449                 sstore(_preBytes.slot, add(mul(newlength, 2), 1))
450 
451             // Copy over the first `submod` bytes of the new data as in
452             // case 1 above.
453                 let slengthmod := mod(slength, 32)
454                 let mlengthmod := mod(mlength, 32)
455                 let submod := sub(32, slengthmod)
456                 let mc := add(_postBytes, submod)
457                 let end := add(_postBytes, mlength)
458                 let mask := sub(exp(0x100, submod), 1)
459 
460                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
461 
462                 for {
463                     sc := add(sc, 1)
464                     mc := add(mc, 0x20)
465                 } lt(mc, end) {
466                     sc := add(sc, 1)
467                     mc := add(mc, 0x20)
468                 } {
469                     sstore(sc, mload(mc))
470                 }
471 
472                 mask := exp(0x100, sub(mc, end))
473 
474                 sstore(sc, mul(div(mload(mc), mask), mask))
475             }
476         }
477     }
478 
479     function slice(
480         bytes memory _bytes,
481         uint256 _start,
482         uint256 _length
483     )
484     internal
485     pure
486     returns (bytes memory)
487     {
488         require(_length + 31 >= _length, "slice_overflow");
489         require(_bytes.length >= _start + _length, "slice_outOfBounds");
490 
491         bytes memory tempBytes;
492 
493         assembly {
494             switch iszero(_length)
495             case 0 {
496             // Get a location of some free memory and store it in tempBytes as
497             // Solidity does for memory variables.
498                 tempBytes := mload(0x40)
499 
500             // The first word of the slice result is potentially a partial
501             // word read from the original array. To read it, we calculate
502             // the length of that partial word and start copying that many
503             // bytes into the array. The first word we copy will start with
504             // data we don't care about, but the last `lengthmod` bytes will
505             // land at the beginning of the contents of the new array. When
506             // we're done copying, we overwrite the full first word with
507             // the actual length of the slice.
508                 let lengthmod := and(_length, 31)
509 
510             // The multiplication in the next line is necessary
511             // because when slicing multiples of 32 bytes (lengthmod == 0)
512             // the following copy loop was copying the origin's length
513             // and then ending prematurely not copying everything it should.
514                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
515                 let end := add(mc, _length)
516 
517                 for {
518                 // The multiplication in the next line has the same exact purpose
519                 // as the one above.
520                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
521                 } lt(mc, end) {
522                     mc := add(mc, 0x20)
523                     cc := add(cc, 0x20)
524                 } {
525                     mstore(mc, mload(cc))
526                 }
527 
528                 mstore(tempBytes, _length)
529 
530             //update free-memory pointer
531             //allocating the array padded to 32 bytes like the compiler does now
532                 mstore(0x40, and(add(mc, 31), not(31)))
533             }
534             //if we want a zero-length slice let's just return a zero-length array
535             default {
536                 tempBytes := mload(0x40)
537             //zero out the 32 bytes slice we are about to return
538             //we need to do it because Solidity does not garbage collect
539                 mstore(tempBytes, 0)
540 
541                 mstore(0x40, add(tempBytes, 0x20))
542             }
543         }
544 
545         return tempBytes;
546     }
547 
548     function toAddress(bytes memory _bytes, uint256 _start) internal pure returns (address) {
549         require(_bytes.length >= _start + 20, "toAddress_outOfBounds");
550         address tempAddress;
551 
552         assembly {
553             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
554         }
555 
556         return tempAddress;
557     }
558 
559     function toUint8(bytes memory _bytes, uint256 _start) internal pure returns (uint8) {
560         require(_bytes.length >= _start + 1 , "toUint8_outOfBounds");
561         uint8 tempUint;
562 
563         assembly {
564             tempUint := mload(add(add(_bytes, 0x1), _start))
565         }
566 
567         return tempUint;
568     }
569 
570     function toUint16(bytes memory _bytes, uint256 _start) internal pure returns (uint16) {
571         require(_bytes.length >= _start + 2, "toUint16_outOfBounds");
572         uint16 tempUint;
573 
574         assembly {
575             tempUint := mload(add(add(_bytes, 0x2), _start))
576         }
577 
578         return tempUint;
579     }
580 
581     function toUint32(bytes memory _bytes, uint256 _start) internal pure returns (uint32) {
582         require(_bytes.length >= _start + 4, "toUint32_outOfBounds");
583         uint32 tempUint;
584 
585         assembly {
586             tempUint := mload(add(add(_bytes, 0x4), _start))
587         }
588 
589         return tempUint;
590     }
591 
592     function toUint64(bytes memory _bytes, uint256 _start) internal pure returns (uint64) {
593         require(_bytes.length >= _start + 8, "toUint64_outOfBounds");
594         uint64 tempUint;
595 
596         assembly {
597             tempUint := mload(add(add(_bytes, 0x8), _start))
598         }
599 
600         return tempUint;
601     }
602 
603     function toUint96(bytes memory _bytes, uint256 _start) internal pure returns (uint96) {
604         require(_bytes.length >= _start + 12, "toUint96_outOfBounds");
605         uint96 tempUint;
606 
607         assembly {
608             tempUint := mload(add(add(_bytes, 0xc), _start))
609         }
610 
611         return tempUint;
612     }
613 
614     function toUint128(bytes memory _bytes, uint256 _start) internal pure returns (uint128) {
615         require(_bytes.length >= _start + 16, "toUint128_outOfBounds");
616         uint128 tempUint;
617 
618         assembly {
619             tempUint := mload(add(add(_bytes, 0x10), _start))
620         }
621 
622         return tempUint;
623     }
624 
625     function toUint256(bytes memory _bytes, uint256 _start) internal pure returns (uint256) {
626         require(_bytes.length >= _start + 32, "toUint256_outOfBounds");
627         uint256 tempUint;
628 
629         assembly {
630             tempUint := mload(add(add(_bytes, 0x20), _start))
631         }
632 
633         return tempUint;
634     }
635 
636     function toBytes32(bytes memory _bytes, uint256 _start) internal pure returns (bytes32) {
637         require(_bytes.length >= _start + 32, "toBytes32_outOfBounds");
638         bytes32 tempBytes32;
639 
640         assembly {
641             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
642         }
643 
644         return tempBytes32;
645     }
646 
647     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
648         bool success = true;
649 
650         assembly {
651             let length := mload(_preBytes)
652 
653         // if lengths don't match the arrays are not equal
654             switch eq(length, mload(_postBytes))
655             case 1 {
656             // cb is a circuit breaker in the for loop since there's
657             //  no said feature for inline assembly loops
658             // cb = 1 - don't breaker
659             // cb = 0 - break
660                 let cb := 1
661 
662                 let mc := add(_preBytes, 0x20)
663                 let end := add(mc, length)
664 
665                 for {
666                     let cc := add(_postBytes, 0x20)
667                 // the next line is the loop condition:
668                 // while(uint256(mc < end) + cb == 2)
669                 } eq(add(lt(mc, end), cb), 2) {
670                     mc := add(mc, 0x20)
671                     cc := add(cc, 0x20)
672                 } {
673                 // if any of these checks fails then arrays are not equal
674                     if iszero(eq(mload(mc), mload(cc))) {
675                     // unsuccess:
676                         success := 0
677                         cb := 0
678                     }
679                 }
680             }
681             default {
682             // unsuccess:
683                 success := 0
684             }
685         }
686 
687         return success;
688     }
689 
690     function equalStorage(
691         bytes storage _preBytes,
692         bytes memory _postBytes
693     )
694     internal
695     view
696     returns (bool)
697     {
698         bool success = true;
699 
700         assembly {
701         // we know _preBytes_offset is 0
702             let fslot := sload(_preBytes.slot)
703         // Decode the length of the stored array like in concatStorage().
704             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
705             let mlength := mload(_postBytes)
706 
707         // if lengths don't match the arrays are not equal
708             switch eq(slength, mlength)
709             case 1 {
710             // slength can contain both the length and contents of the array
711             // if length < 32 bytes so let's prepare for that
712             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
713                 if iszero(iszero(slength)) {
714                     switch lt(slength, 32)
715                     case 1 {
716                     // blank the last byte which is the length
717                         fslot := mul(div(fslot, 0x100), 0x100)
718 
719                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
720                         // unsuccess:
721                             success := 0
722                         }
723                     }
724                     default {
725                     // cb is a circuit breaker in the for loop since there's
726                     //  no said feature for inline assembly loops
727                     // cb = 1 - don't breaker
728                     // cb = 0 - break
729                         let cb := 1
730 
731                     // get the keccak hash to get the contents of the array
732                         mstore(0x0, _preBytes.slot)
733                         let sc := keccak256(0x0, 0x20)
734 
735                         let mc := add(_postBytes, 0x20)
736                         let end := add(mc, mlength)
737 
738                     // the next line is the loop condition:
739                     // while(uint256(mc < end) + cb == 2)
740                         for {} eq(add(lt(mc, end), cb), 2) {
741                             sc := add(sc, 1)
742                             mc := add(mc, 0x20)
743                         } {
744                             if iszero(eq(sload(sc), mload(mc))) {
745                             // unsuccess:
746                                 success := 0
747                                 cb := 0
748                             }
749                         }
750                     }
751                 }
752             }
753             default {
754             // unsuccess:
755                 success := 0
756             }
757         }
758 
759         return success;
760     }
761 }
762 
763 
764 // File contracts/lzApp/LzApp.sol
765 
766 
767 
768 pragma solidity ^0.8.0;
769 
770 
771 
772 
773 
774 /*
775  * a generic LzReceiver implementation
776  */
777 abstract contract LzApp is Ownable, ILayerZeroReceiver, ILayerZeroUserApplicationConfig {
778     using BytesLib for bytes;
779 
780     ILayerZeroEndpoint public immutable lzEndpoint;
781     mapping(uint16 => bytes) public trustedRemoteLookup;
782     mapping(uint16 => mapping(uint16 => uint)) public minDstGasLookup;
783     address public precrime;
784 
785     event SetPrecrime(address precrime);
786     event SetTrustedRemote(uint16 _remoteChainId, bytes _path);
787     event SetTrustedRemoteAddress(uint16 _remoteChainId, bytes _remoteAddress);
788     event SetMinDstGas(uint16 _dstChainId, uint16 _type, uint _minDstGas);
789 
790     constructor(address _endpoint) {
791         lzEndpoint = ILayerZeroEndpoint(_endpoint);
792     }
793 
794     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) public virtual override {
795         // lzReceive must be called by the endpoint for security
796         require(_msgSender() == address(lzEndpoint), "LzApp: invalid endpoint caller");
797 
798         bytes memory trustedRemote = trustedRemoteLookup[_srcChainId];
799         // if will still block the message pathway from (srcChainId, srcAddress). should not receive message from untrusted remote.
800         require(_srcAddress.length == trustedRemote.length && trustedRemote.length > 0 && keccak256(_srcAddress) == keccak256(trustedRemote), "LzApp: invalid source sending contract");
801 
802         _blockingLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
803     }
804 
805     // abstract function - the default behaviour of LayerZero is blocking. See: NonblockingLzApp if you dont need to enforce ordered messaging
806     function _blockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual;
807 
808     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _adapterParams, uint _nativeFee) internal virtual {
809         bytes memory trustedRemote = trustedRemoteLookup[_dstChainId];
810         require(trustedRemote.length != 0, "LzApp: destination chain is not a trusted source");
811         lzEndpoint.send{value: _nativeFee}(_dstChainId, trustedRemote, _payload, _refundAddress, _zroPaymentAddress, _adapterParams);
812     }
813 
814     function _checkGasLimit(uint16 _dstChainId, uint16 _type, bytes memory _adapterParams, uint _extraGas) internal view virtual {
815         uint providedGasLimit = _getGasLimit(_adapterParams);
816         uint minGasLimit = minDstGasLookup[_dstChainId][_type] + _extraGas;
817         require(minGasLimit > 0, "LzApp: minGasLimit not set");
818         require(providedGasLimit >= minGasLimit, "LzApp: gas limit is too low");
819     }
820 
821     function _getGasLimit(bytes memory _adapterParams) internal pure virtual returns (uint gasLimit) {
822         require(_adapterParams.length >= 34, "LzApp: invalid adapterParams");
823         assembly {
824             gasLimit := mload(add(_adapterParams, 34))
825         }
826     }
827 
828     //---------------------------UserApplication config----------------------------------------
829     function getConfig(uint16 _version, uint16 _chainId, address, uint _configType) external view returns (bytes memory) {
830         return lzEndpoint.getConfig(_version, _chainId, address(this), _configType);
831     }
832 
833     // generic config for LayerZero user Application
834     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external override onlyOwner {
835         lzEndpoint.setConfig(_version, _chainId, _configType, _config);
836     }
837 
838     function setSendVersion(uint16 _version) external override onlyOwner {
839         lzEndpoint.setSendVersion(_version);
840     }
841 
842     function setReceiveVersion(uint16 _version) external override onlyOwner {
843         lzEndpoint.setReceiveVersion(_version);
844     }
845 
846     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external override onlyOwner {
847         lzEndpoint.forceResumeReceive(_srcChainId, _srcAddress);
848     }
849 
850     // _path = abi.encodePacked(remoteAddress, localAddress)
851     // this function set the trusted path for the cross-chain communication
852     function setTrustedRemote(uint16 _srcChainId, bytes calldata _path) external onlyOwner {
853         trustedRemoteLookup[_srcChainId] = _path;
854         emit SetTrustedRemote(_srcChainId, _path);
855     }
856 
857     function setTrustedRemoteAddress(uint16 _remoteChainId, bytes calldata _remoteAddress) external onlyOwner {
858         trustedRemoteLookup[_remoteChainId] = abi.encodePacked(_remoteAddress, address(this));
859         emit SetTrustedRemoteAddress(_remoteChainId, _remoteAddress);
860     }
861 
862     function getTrustedRemoteAddress(uint16 _remoteChainId) external view returns (bytes memory) {
863         bytes memory path = trustedRemoteLookup[_remoteChainId];
864         require(path.length != 0, "LzApp: no trusted path record");
865         return path.slice(0, path.length - 20); // the last 20 bytes should be address(this)
866     }
867 
868     function setPrecrime(address _precrime) external onlyOwner {
869         precrime = _precrime;
870         emit SetPrecrime(_precrime);
871     }
872 
873     function setMinDstGas(uint16 _dstChainId, uint16 _packetType, uint _minGas) external onlyOwner {
874         require(_minGas > 0, "LzApp: invalid minGas");
875         minDstGasLookup[_dstChainId][_packetType] = _minGas;
876         emit SetMinDstGas(_dstChainId, _packetType, _minGas);
877     }
878 
879     //--------------------------- VIEW FUNCTION ----------------------------------------
880     function isTrustedRemote(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool) {
881         bytes memory trustedSource = trustedRemoteLookup[_srcChainId];
882         return keccak256(trustedSource) == keccak256(_srcAddress);
883     }
884 }
885 
886 
887 // File contracts/util/ExcessivelySafeCall.sol
888 
889 
890 pragma solidity >=0.7.6;
891 
892 library ExcessivelySafeCall {
893     uint256 constant LOW_28_MASK =
894     0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
895 
896     /// @notice Use when you _really_ really _really_ don't trust the called
897     /// contract. This prevents the called contract from causing reversion of
898     /// the caller in as many ways as we can.
899     /// @dev The main difference between this and a solidity low-level call is
900     /// that we limit the number of bytes that the callee can cause to be
901     /// copied to caller memory. This prevents stupid things like malicious
902     /// contracts returning 10,000,000 bytes causing a local OOG when copying
903     /// to memory.
904     /// @param _target The address to call
905     /// @param _gas The amount of gas to forward to the remote contract
906     /// @param _maxCopy The maximum number of bytes of returndata to copy
907     /// to memory.
908     /// @param _calldata The data to send to the remote contract
909     /// @return success and returndata, as `.call()`. Returndata is capped to
910     /// `_maxCopy` bytes.
911     function excessivelySafeCall(
912         address _target,
913         uint256 _gas,
914         uint16 _maxCopy,
915         bytes memory _calldata
916     ) internal returns (bool, bytes memory) {
917         // set up for assembly call
918         uint256 _toCopy;
919         bool _success;
920         bytes memory _returnData = new bytes(_maxCopy);
921         // dispatch message to recipient
922         // by assembly calling "handle" function
923         // we call via assembly to avoid memcopying a very large returndata
924         // returned by a malicious contract
925         assembly {
926             _success := call(
927             _gas, // gas
928             _target, // recipient
929             0, // ether value
930             add(_calldata, 0x20), // inloc
931             mload(_calldata), // inlen
932             0, // outloc
933             0 // outlen
934             )
935         // limit our copy to 256 bytes
936             _toCopy := returndatasize()
937             if gt(_toCopy, _maxCopy) {
938                 _toCopy := _maxCopy
939             }
940         // Store the length of the copied bytes
941             mstore(_returnData, _toCopy)
942         // copy the bytes from returndata[0:_toCopy]
943             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
944         }
945         return (_success, _returnData);
946     }
947 
948     /// @notice Use when you _really_ really _really_ don't trust the called
949     /// contract. This prevents the called contract from causing reversion of
950     /// the caller in as many ways as we can.
951     /// @dev The main difference between this and a solidity low-level call is
952     /// that we limit the number of bytes that the callee can cause to be
953     /// copied to caller memory. This prevents stupid things like malicious
954     /// contracts returning 10,000,000 bytes causing a local OOG when copying
955     /// to memory.
956     /// @param _target The address to call
957     /// @param _gas The amount of gas to forward to the remote contract
958     /// @param _maxCopy The maximum number of bytes of returndata to copy
959     /// to memory.
960     /// @param _calldata The data to send to the remote contract
961     /// @return success and returndata, as `.call()`. Returndata is capped to
962     /// `_maxCopy` bytes.
963     function excessivelySafeStaticCall(
964         address _target,
965         uint256 _gas,
966         uint16 _maxCopy,
967         bytes memory _calldata
968     ) internal view returns (bool, bytes memory) {
969         // set up for assembly call
970         uint256 _toCopy;
971         bool _success;
972         bytes memory _returnData = new bytes(_maxCopy);
973         // dispatch message to recipient
974         // by assembly calling "handle" function
975         // we call via assembly to avoid memcopying a very large returndata
976         // returned by a malicious contract
977         assembly {
978             _success := staticcall(
979             _gas, // gas
980             _target, // recipient
981             add(_calldata, 0x20), // inloc
982             mload(_calldata), // inlen
983             0, // outloc
984             0 // outlen
985             )
986         // limit our copy to 256 bytes
987             _toCopy := returndatasize()
988             if gt(_toCopy, _maxCopy) {
989                 _toCopy := _maxCopy
990             }
991         // Store the length of the copied bytes
992             mstore(_returnData, _toCopy)
993         // copy the bytes from returndata[0:_toCopy]
994             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
995         }
996         return (_success, _returnData);
997     }
998 
999     /**
1000      * @notice Swaps function selectors in encoded contract calls
1001      * @dev Allows reuse of encoded calldata for functions with identical
1002      * argument types but different names. It simply swaps out the first 4 bytes
1003      * for the new selector. This function modifies memory in place, and should
1004      * only be used with caution.
1005      * @param _newSelector The new 4-byte selector
1006      * @param _buf The encoded contract args
1007      */
1008     function swapSelector(bytes4 _newSelector, bytes memory _buf)
1009     internal
1010     pure
1011     {
1012         require(_buf.length >= 4);
1013         uint256 _mask = LOW_28_MASK;
1014         assembly {
1015         // load the first word of
1016             let _word := mload(add(_buf, 0x20))
1017         // mask out the top 4 bytes
1018         // /x
1019             _word := and(_word, _mask)
1020             _word := or(_newSelector, _word)
1021             mstore(add(_buf, 0x20), _word)
1022         }
1023     }
1024 }
1025 
1026 
1027 // File contracts/lzApp/NonblockingLzApp.sol
1028 
1029 
1030 
1031 pragma solidity ^0.8.0;
1032 
1033 
1034 /*
1035  * the default LayerZero messaging behaviour is blocking, i.e. any failed message will block the channel
1036  * this abstract class try-catch all fail messages and store locally for future retry. hence, non-blocking
1037  * NOTE: if the srcAddress is not configured properly, it will still block the message pathway from (srcChainId, srcAddress)
1038  */
1039 abstract contract NonblockingLzApp is LzApp {
1040     using ExcessivelySafeCall for address;
1041 
1042     constructor(address _endpoint) LzApp(_endpoint) {}
1043 
1044     mapping(uint16 => mapping(bytes => mapping(uint64 => bytes32))) public failedMessages;
1045 
1046     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload, bytes _reason);
1047     event RetryMessageSuccess(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes32 _payloadHash);
1048 
1049     // overriding the virtual function in LzReceiver
1050     function _blockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual override {
1051         (bool success, bytes memory reason) = address(this).excessivelySafeCall(gasleft(), 150, abi.encodeWithSelector(this.nonblockingLzReceive.selector, _srcChainId, _srcAddress, _nonce, _payload));
1052         // try-catch all errors/exceptions
1053         if (!success) {
1054             failedMessages[_srcChainId][_srcAddress][_nonce] = keccak256(_payload);
1055             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload, reason);
1056         }
1057     }
1058 
1059     function nonblockingLzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) public virtual {
1060         // only internal transaction
1061         require(_msgSender() == address(this), "NonblockingLzApp: caller must be LzApp");
1062         _nonblockingLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1063     }
1064 
1065     //@notice override this function
1066     function _nonblockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual;
1067 
1068     function retryMessage(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) public payable virtual {
1069         // assert there is message to retry
1070         bytes32 payloadHash = failedMessages[_srcChainId][_srcAddress][_nonce];
1071         require(payloadHash != bytes32(0), "NonblockingLzApp: no stored message");
1072         require(keccak256(_payload) == payloadHash, "NonblockingLzApp: invalid payload");
1073         // clear the stored message
1074         failedMessages[_srcChainId][_srcAddress][_nonce] = bytes32(0);
1075         // execute the message. revert if it fails again
1076         _nonblockingLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1077         emit RetryMessageSuccess(_srcChainId, _srcAddress, _nonce, payloadHash);
1078     }
1079 }
1080 
1081 
1082 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.1
1083 
1084 
1085 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1086 
1087 pragma solidity ^0.8.0;
1088 
1089 /**
1090  * @dev Interface of the ERC20 standard as defined in the EIP.
1091  */
1092 interface IERC20 {
1093     /**
1094      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1095      * another (`to`).
1096      *
1097      * Note that `value` may be zero.
1098      */
1099     event Transfer(address indexed from, address indexed to, uint256 value);
1100 
1101     /**
1102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1103      * a call to {approve}. `value` is the new allowance.
1104      */
1105     event Approval(address indexed owner, address indexed spender, uint256 value);
1106 
1107     /**
1108      * @dev Returns the amount of tokens in existence.
1109      */
1110     function totalSupply() external view returns (uint256);
1111 
1112     /**
1113      * @dev Returns the amount of tokens owned by `account`.
1114      */
1115     function balanceOf(address account) external view returns (uint256);
1116 
1117     /**
1118      * @dev Moves `amount` tokens from the caller's account to `to`.
1119      *
1120      * Returns a boolean value indicating whether the operation succeeded.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function transfer(address to, uint256 amount) external returns (bool);
1125 
1126     /**
1127      * @dev Returns the remaining number of tokens that `spender` will be
1128      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1129      * zero by default.
1130      *
1131      * This value changes when {approve} or {transferFrom} are called.
1132      */
1133     function allowance(address owner, address spender) external view returns (uint256);
1134 
1135     /**
1136      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1137      *
1138      * Returns a boolean value indicating whether the operation succeeded.
1139      *
1140      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1141      * that someone may use both the old and the new allowance by unfortunate
1142      * transaction ordering. One possible solution to mitigate this race
1143      * condition is to first reduce the spender's allowance to 0 and set the
1144      * desired value afterwards:
1145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1146      *
1147      * Emits an {Approval} event.
1148      */
1149     function approve(address spender, uint256 amount) external returns (bool);
1150 
1151     /**
1152      * @dev Moves `amount` tokens from `from` to `to` using the
1153      * allowance mechanism. `amount` is then deducted from the caller's
1154      * allowance.
1155      *
1156      * Returns a boolean value indicating whether the operation succeeded.
1157      *
1158      * Emits a {Transfer} event.
1159      */
1160     function transferFrom(
1161         address from,
1162         address to,
1163         uint256 amount
1164     ) external returns (bool);
1165 }
1166 
1167 
1168 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.1
1169 
1170 
1171 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 /**
1176  * @dev Interface of the ERC165 standard, as defined in the
1177  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1178  *
1179  * Implementers can declare support of contract interfaces, which can then be
1180  * queried by others ({ERC165Checker}).
1181  *
1182  * For an implementation, see {ERC165}.
1183  */
1184 interface IERC165 {
1185     /**
1186      * @dev Returns true if this contract implements the interface defined by
1187      * `interfaceId`. See the corresponding
1188      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1189      * to learn more about how these ids are created.
1190      *
1191      * This function call must use less than 30 000 gas.
1192      */
1193     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1194 }
1195 
1196 
1197 // File contracts/token/oft/IOFTCore.sol
1198 
1199 
1200 
1201 pragma solidity >=0.5.0;
1202 
1203 
1204 /**
1205  * @dev Interface of the IOFT core standard
1206  */
1207 interface IOFTCore is IERC165 {
1208     /**
1209      * @dev estimate send token `_tokenId` to (`_dstChainId`, `_toAddress`)
1210      * _dstChainId - L0 defined chain id to send tokens too
1211      * _toAddress - dynamic bytes array which contains the address to whom you are sending tokens to on the dstChain
1212      * _amount - amount of the tokens to transfer
1213      * _useZro - indicates to use zro to pay L0 fees
1214      * _adapterParam - flexible bytes array to indicate messaging adapter services in L0
1215      */
1216     function estimateSendFee(uint16 _dstChainId, bytes calldata _toAddress, uint _amount, bool _useZro, bytes calldata _adapterParams) external view returns (uint nativeFee, uint zroFee);
1217 
1218     /**
1219      * @dev send `_amount` amount of token to (`_dstChainId`, `_toAddress`) from `_from`
1220      * `_from` the owner of token
1221      * `_dstChainId` the destination chain identifier
1222      * `_toAddress` can be any size depending on the `dstChainId`.
1223      * `_amount` the quantity of tokens in wei
1224      * `_refundAddress` the address LayerZero refunds if too much message fee is sent
1225      * `_zroPaymentAddress` set to address(0x0) if not paying in ZRO (LayerZero Token)
1226      * `_adapterParams` is a flexible bytes array to indicate messaging adapter services
1227      */
1228     function sendFrom(address _from, uint16 _dstChainId, bytes calldata _toAddress, uint _amount, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
1229 
1230     /**
1231      * @dev returns the circulating amount of tokens on current chain
1232      */
1233     function circulatingSupply() external view returns (uint);
1234 
1235     /**
1236      * @dev Emitted when `_amount` tokens are moved from the `_sender` to (`_dstChainId`, `_toAddress`)
1237      * `_nonce` is the outbound nonce
1238      */
1239     event SendToChain(uint16 indexed _dstChainId, address indexed _from, bytes indexed _toAddress, uint _amount);
1240 
1241     /**
1242      * @dev Emitted when `_amount` tokens are received from `_srcChainId` into the `_toAddress` on the local chain.
1243      * `_nonce` is the inbound nonce.
1244      */
1245     event ReceiveFromChain(uint16 indexed _srcChainId, bytes _fromAddress, address indexed _to, uint _amount);
1246 
1247     event SetUseCustomAdapterParams(bool _useCustomAdapterParams);
1248 }
1249 
1250 
1251 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.1
1252 
1253 
1254 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 /**
1259  * @dev Implementation of the {IERC165} interface.
1260  *
1261  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1262  * for the additional interface id that will be supported. For example:
1263  *
1264  * ```solidity
1265  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1266  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1267  * }
1268  * ```
1269  *
1270  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1271  */
1272 abstract contract ERC165 is IERC165 {
1273     /**
1274      * @dev See {IERC165-supportsInterface}.
1275      */
1276     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1277         return interfaceId == type(IERC165).interfaceId;
1278     }
1279 }
1280 
1281 
1282 // File contracts/token/oft/OFTCore.sol
1283 
1284 
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 
1289 
1290 abstract contract OFTCore is NonblockingLzApp, ERC165, IOFTCore {
1291     using BytesLib for bytes;
1292 
1293     uint public constant NO_EXTRA_GAS = 0;
1294 
1295     // packet type
1296     uint16 public constant PT_SEND = 0;
1297 
1298     bool public useCustomAdapterParams;
1299 
1300     constructor(address _lzEndpoint) NonblockingLzApp(_lzEndpoint) {}
1301 
1302     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1303         return interfaceId == type(IOFTCore).interfaceId || super.supportsInterface(interfaceId);
1304     }
1305 
1306     function estimateSendFee(uint16 _dstChainId, bytes calldata _toAddress, uint _amount, bool _useZro, bytes calldata _adapterParams) public view virtual override returns (uint nativeFee, uint zroFee) {
1307         // mock the payload for sendFrom()
1308         bytes memory payload = abi.encode(PT_SEND, abi.encodePacked(msg.sender), _toAddress, _amount);
1309         return lzEndpoint.estimateFees(_dstChainId, address(this), payload, _useZro, _adapterParams);
1310     }
1311 
1312     function sendFrom(address _from, uint16 _dstChainId, bytes calldata _toAddress, uint _amount, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) public payable virtual override {
1313         _send(_from, _dstChainId, _toAddress, _amount, _refundAddress, _zroPaymentAddress, _adapterParams);
1314     }
1315 
1316     function setUseCustomAdapterParams(bool _useCustomAdapterParams) public virtual onlyOwner {
1317         useCustomAdapterParams = _useCustomAdapterParams;
1318         emit SetUseCustomAdapterParams(_useCustomAdapterParams);
1319     }
1320 
1321     function _nonblockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual override {
1322         uint16 packetType;
1323         assembly {
1324             packetType := mload(add(_payload, 32))
1325         }
1326 
1327         if (packetType == PT_SEND) {
1328             _sendAck(_srcChainId, _srcAddress, _nonce, _payload);
1329         } else {
1330             revert("OFTCore: unknown packet type");
1331         }
1332     }
1333 
1334     function _send(address _from, uint16 _dstChainId, bytes memory _toAddress, uint _amount, address payable _refundAddress, address _zroPaymentAddress, bytes memory _adapterParams) internal virtual {
1335         _checkAdapterParams(_dstChainId, PT_SEND, _adapterParams, NO_EXTRA_GAS);
1336 
1337         _debitFrom(_from, _dstChainId, _toAddress, _amount);
1338 
1339         bytes memory lzPayload = abi.encode(PT_SEND, abi.encodePacked(_from), _toAddress, _amount);
1340         _lzSend(_dstChainId, lzPayload, _refundAddress, _zroPaymentAddress, _adapterParams, msg.value);
1341 
1342         emit SendToChain(_dstChainId, _from, _toAddress, _amount);
1343     }
1344 
1345     function _sendAck(uint16 _srcChainId, bytes memory, uint64, bytes memory _payload) internal virtual {
1346         (, bytes memory from, bytes memory toAddressBytes, uint amount) = abi.decode(_payload, (uint16, bytes, bytes, uint));
1347 
1348         address to = toAddressBytes.toAddress(0);
1349 
1350         _creditTo(_srcChainId, to, amount);
1351         emit ReceiveFromChain(_srcChainId, from, to, amount);
1352     }
1353 
1354     function _checkAdapterParams(uint16 _dstChainId, uint16 _pkType, bytes memory _adapterParams, uint _extraGas) internal virtual {
1355         if (useCustomAdapterParams) {
1356             _checkGasLimit(_dstChainId, _pkType, _adapterParams, _extraGas);
1357         } else {
1358             require(_adapterParams.length == 0, "OFTCore: _adapterParams must be empty.");
1359         }
1360     }
1361 
1362     function _debitFrom(address _from, uint16 _dstChainId, bytes memory _toAddress, uint _amount) internal virtual;
1363 
1364     function _creditTo(uint16 _srcChainId, address _toAddress, uint _amount) internal virtual;
1365 }
1366 
1367 
1368 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.1
1369 
1370 
1371 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 /**
1376  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1377  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1378  *
1379  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1380  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1381  * need to send a transaction, and thus is not required to hold Ether at all.
1382  */
1383 interface IERC20Permit {
1384     /**
1385      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1386      * given ``owner``'s signed approval.
1387      *
1388      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1389      * ordering also apply here.
1390      *
1391      * Emits an {Approval} event.
1392      *
1393      * Requirements:
1394      *
1395      * - `spender` cannot be the zero address.
1396      * - `deadline` must be a timestamp in the future.
1397      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1398      * over the EIP712-formatted function arguments.
1399      * - the signature must use ``owner``'s current nonce (see {nonces}).
1400      *
1401      * For more information on the signature format, see the
1402      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1403      * section].
1404      */
1405     function permit(
1406         address owner,
1407         address spender,
1408         uint256 value,
1409         uint256 deadline,
1410         uint8 v,
1411         bytes32 r,
1412         bytes32 s
1413     ) external;
1414 
1415     /**
1416      * @dev Returns the current nonce for `owner`. This value must be
1417      * included whenever a signature is generated for {permit}.
1418      *
1419      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1420      * prevents a signature from being used multiple times.
1421      */
1422     function nonces(address owner) external view returns (uint256);
1423 
1424     /**
1425      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1426      */
1427     // solhint-disable-next-line func-name-mixedcase
1428     function DOMAIN_SEPARATOR() external view returns (bytes32);
1429 }
1430 
1431 
1432 // File @openzeppelin/contracts/utils/Address.sol@v4.7.1
1433 
1434 
1435 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1436 
1437 pragma solidity ^0.8.1;
1438 
1439 /**
1440  * @dev Collection of functions related to the address type
1441  */
1442 library Address {
1443     /**
1444      * @dev Returns true if `account` is a contract.
1445      *
1446      * [IMPORTANT]
1447      * ====
1448      * It is unsafe to assume that an address for which this function returns
1449      * false is an externally-owned account (EOA) and not a contract.
1450      *
1451      * Among others, `isContract` will return false for the following
1452      * types of addresses:
1453      *
1454      *  - an externally-owned account
1455      *  - a contract in construction
1456      *  - an address where a contract will be created
1457      *  - an address where a contract lived, but was destroyed
1458      * ====
1459      *
1460      * [IMPORTANT]
1461      * ====
1462      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1463      *
1464      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1465      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1466      * constructor.
1467      * ====
1468      */
1469     function isContract(address account) internal view returns (bool) {
1470         // This method relies on extcodesize/address.code.length, which returns 0
1471         // for contracts in construction, since the code is only stored at the end
1472         // of the constructor execution.
1473 
1474         return account.code.length > 0;
1475     }
1476 
1477     /**
1478      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1479      * `recipient`, forwarding all available gas and reverting on errors.
1480      *
1481      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1482      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1483      * imposed by `transfer`, making them unable to receive funds via
1484      * `transfer`. {sendValue} removes this limitation.
1485      *
1486      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1487      *
1488      * IMPORTANT: because control is transferred to `recipient`, care must be
1489      * taken to not create reentrancy vulnerabilities. Consider using
1490      * {ReentrancyGuard} or the
1491      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1492      */
1493     function sendValue(address payable recipient, uint256 amount) internal {
1494         require(address(this).balance >= amount, "Address: insufficient balance");
1495 
1496         (bool success, ) = recipient.call{value: amount}("");
1497         require(success, "Address: unable to send value, recipient may have reverted");
1498     }
1499 
1500     /**
1501      * @dev Performs a Solidity function call using a low level `call`. A
1502      * plain `call` is an unsafe replacement for a function call: use this
1503      * function instead.
1504      *
1505      * If `target` reverts with a revert reason, it is bubbled up by this
1506      * function (like regular Solidity function calls).
1507      *
1508      * Returns the raw returned data. To convert to the expected return value,
1509      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1510      *
1511      * Requirements:
1512      *
1513      * - `target` must be a contract.
1514      * - calling `target` with `data` must not revert.
1515      *
1516      * _Available since v3.1._
1517      */
1518     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1519         return functionCall(target, data, "Address: low-level call failed");
1520     }
1521 
1522     /**
1523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1524      * `errorMessage` as a fallback revert reason when `target` reverts.
1525      *
1526      * _Available since v3.1._
1527      */
1528     function functionCall(
1529         address target,
1530         bytes memory data,
1531         string memory errorMessage
1532     ) internal returns (bytes memory) {
1533         return functionCallWithValue(target, data, 0, errorMessage);
1534     }
1535 
1536     /**
1537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1538      * but also transferring `value` wei to `target`.
1539      *
1540      * Requirements:
1541      *
1542      * - the calling contract must have an ETH balance of at least `value`.
1543      * - the called Solidity function must be `payable`.
1544      *
1545      * _Available since v3.1._
1546      */
1547     function functionCallWithValue(
1548         address target,
1549         bytes memory data,
1550         uint256 value
1551     ) internal returns (bytes memory) {
1552         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1553     }
1554 
1555     /**
1556      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1557      * with `errorMessage` as a fallback revert reason when `target` reverts.
1558      *
1559      * _Available since v3.1._
1560      */
1561     function functionCallWithValue(
1562         address target,
1563         bytes memory data,
1564         uint256 value,
1565         string memory errorMessage
1566     ) internal returns (bytes memory) {
1567         require(address(this).balance >= value, "Address: insufficient balance for call");
1568         require(isContract(target), "Address: call to non-contract");
1569 
1570         (bool success, bytes memory returndata) = target.call{value: value}(data);
1571         return verifyCallResult(success, returndata, errorMessage);
1572     }
1573 
1574     /**
1575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1576      * but performing a static call.
1577      *
1578      * _Available since v3.3._
1579      */
1580     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1581         return functionStaticCall(target, data, "Address: low-level static call failed");
1582     }
1583 
1584     /**
1585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1586      * but performing a static call.
1587      *
1588      * _Available since v3.3._
1589      */
1590     function functionStaticCall(
1591         address target,
1592         bytes memory data,
1593         string memory errorMessage
1594     ) internal view returns (bytes memory) {
1595         require(isContract(target), "Address: static call to non-contract");
1596 
1597         (bool success, bytes memory returndata) = target.staticcall(data);
1598         return verifyCallResult(success, returndata, errorMessage);
1599     }
1600 
1601     /**
1602      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1603      * but performing a delegate call.
1604      *
1605      * _Available since v3.4._
1606      */
1607     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1608         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1609     }
1610 
1611     /**
1612      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1613      * but performing a delegate call.
1614      *
1615      * _Available since v3.4._
1616      */
1617     function functionDelegateCall(
1618         address target,
1619         bytes memory data,
1620         string memory errorMessage
1621     ) internal returns (bytes memory) {
1622         require(isContract(target), "Address: delegate call to non-contract");
1623 
1624         (bool success, bytes memory returndata) = target.delegatecall(data);
1625         return verifyCallResult(success, returndata, errorMessage);
1626     }
1627 
1628     /**
1629      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1630      * revert reason using the provided one.
1631      *
1632      * _Available since v4.3._
1633      */
1634     function verifyCallResult(
1635         bool success,
1636         bytes memory returndata,
1637         string memory errorMessage
1638     ) internal pure returns (bytes memory) {
1639         if (success) {
1640             return returndata;
1641         } else {
1642             // Look for revert reason and bubble it up if present
1643             if (returndata.length > 0) {
1644                 // The easiest way to bubble the revert reason is using memory via assembly
1645                 /// @solidity memory-safe-assembly
1646                 assembly {
1647                     let returndata_size := mload(returndata)
1648                     revert(add(32, returndata), returndata_size)
1649                 }
1650             } else {
1651                 revert(errorMessage);
1652             }
1653         }
1654     }
1655 }
1656 
1657 
1658 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.1
1659 
1660 
1661 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1662 
1663 pragma solidity ^0.8.0;
1664 
1665 
1666 
1667 /**
1668  * @title SafeERC20
1669  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1670  * contract returns false). Tokens that return no value (and instead revert or
1671  * throw on failure) are also supported, non-reverting calls are assumed to be
1672  * successful.
1673  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1674  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1675  */
1676 library SafeERC20 {
1677     using Address for address;
1678 
1679     function safeTransfer(
1680         IERC20 token,
1681         address to,
1682         uint256 value
1683     ) internal {
1684         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1685     }
1686 
1687     function safeTransferFrom(
1688         IERC20 token,
1689         address from,
1690         address to,
1691         uint256 value
1692     ) internal {
1693         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1694     }
1695 
1696     /**
1697      * @dev Deprecated. This function has issues similar to the ones found in
1698      * {IERC20-approve}, and its usage is discouraged.
1699      *
1700      * Whenever possible, use {safeIncreaseAllowance} and
1701      * {safeDecreaseAllowance} instead.
1702      */
1703     function safeApprove(
1704         IERC20 token,
1705         address spender,
1706         uint256 value
1707     ) internal {
1708         // safeApprove should only be called when setting an initial allowance,
1709         // or when resetting it to zero. To increase and decrease it, use
1710         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1711         require(
1712             (value == 0) || (token.allowance(address(this), spender) == 0),
1713             "SafeERC20: approve from non-zero to non-zero allowance"
1714         );
1715         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1716     }
1717 
1718     function safeIncreaseAllowance(
1719         IERC20 token,
1720         address spender,
1721         uint256 value
1722     ) internal {
1723         uint256 newAllowance = token.allowance(address(this), spender) + value;
1724         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1725     }
1726 
1727     function safeDecreaseAllowance(
1728         IERC20 token,
1729         address spender,
1730         uint256 value
1731     ) internal {
1732         unchecked {
1733             uint256 oldAllowance = token.allowance(address(this), spender);
1734             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1735             uint256 newAllowance = oldAllowance - value;
1736             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1737         }
1738     }
1739 
1740     function safePermit(
1741         IERC20Permit token,
1742         address owner,
1743         address spender,
1744         uint256 value,
1745         uint256 deadline,
1746         uint8 v,
1747         bytes32 r,
1748         bytes32 s
1749     ) internal {
1750         uint256 nonceBefore = token.nonces(owner);
1751         token.permit(owner, spender, value, deadline, v, r, s);
1752         uint256 nonceAfter = token.nonces(owner);
1753         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1754     }
1755 
1756     /**
1757      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1758      * on the return value: the return value is optional (but if data is returned, it must not be false).
1759      * @param token The token targeted by the call.
1760      * @param data The call data (encoded using abi.encode or one of its variants).
1761      */
1762     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1763         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1764         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1765         // the target address contains contract code and also asserts for success in the low-level call.
1766 
1767         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1768         if (returndata.length > 0) {
1769             // Return data is optional
1770             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1771         }
1772     }
1773 }
1774 
1775 
1776 // File contracts/token/oft/extension/ProxyERC20.sol
1777 
1778 
1779 
1780 pragma solidity ^0.8.0;
1781 
1782 
1783 contract ProxyERC20 is OFTCore {
1784     using SafeERC20 for IERC20;
1785 
1786     IERC20 public immutable token;
1787 
1788     constructor(address _lzEndpoint, address _proxyToken) OFTCore(_lzEndpoint) {
1789         token = IERC20(_proxyToken);
1790     }
1791 
1792     function circulatingSupply() public view virtual override returns (uint) {
1793         unchecked {
1794             return token.totalSupply() - token.balanceOf(address(this));
1795         }
1796     }
1797 
1798     function _debitFrom(address _from, uint16, bytes memory, uint _amount) internal virtual override {
1799         require(_from == _msgSender(), "ProxyOFT: owner is not send caller");
1800         token.safeTransferFrom(_from, address(this), _amount);
1801     }
1802 
1803     function _creditTo(uint16, address _toAddress, uint _amount) internal virtual override {
1804         token.safeTransfer(_toAddress, _amount);
1805     }
1806 }