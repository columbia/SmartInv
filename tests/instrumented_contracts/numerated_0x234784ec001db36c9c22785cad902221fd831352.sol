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
33 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 
115 // File contracts/interfaces/ILayerZeroReceiver.sol
116 
117 
118 pragma solidity >=0.5.0;
119 
120 interface ILayerZeroReceiver {
121     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
122     // @param _srcChainId - the source endpoint identifier
123     // @param _srcAddress - the source sending contract address from the source chain
124     // @param _nonce - the ordered message nonce
125     // @param _payload - the signed payload is the UA bytes has encoded to be sent
126     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
127 }
128 
129 
130 // File contracts/interfaces/ILayerZeroUserApplicationConfig.sol
131 
132 
133 pragma solidity >=0.5.0;
134 
135 interface ILayerZeroUserApplicationConfig {
136     // @notice set the configuration of the LayerZero messaging library of the specified version
137     // @param _version - messaging library version
138     // @param _chainId - the chainId for the pending config change
139     // @param _configType - type of configuration. every messaging library has its own convention.
140     // @param _config - configuration in the bytes. can encode arbitrary content.
141     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
142 
143     // @notice set the send() LayerZero messaging library version to _version
144     // @param _version - new messaging library version
145     function setSendVersion(uint16 _version) external;
146 
147     // @notice set the lzReceive() LayerZero messaging library version to _version
148     // @param _version - new messaging library version
149     function setReceiveVersion(uint16 _version) external;
150 
151     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
152     // @param _srcChainId - the chainId of the source chain
153     // @param _srcAddress - the contract address of the source contract at the source chain
154     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
155 }
156 
157 
158 // File contracts/interfaces/ILayerZeroEndpoint.sol
159 
160 
161 pragma solidity >=0.5.0;
162 
163 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
164     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
165     // @param _dstChainId - the destination chain identifier
166     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
167     // @param _payload - a custom bytes payload to send to the destination contract
168     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
169     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
170     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
171     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
172 
173     // @notice used by the messaging library to publish verified payload
174     // @param _srcChainId - the source chain identifier
175     // @param _srcAddress - the source contract (as bytes) at the source chain
176     // @param _dstAddress - the address on destination chain
177     // @param _nonce - the unbound message ordering nonce
178     // @param _gasLimit - the gas limit for external contract execution
179     // @param _payload - verified payload to send to the destination contract
180     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
181 
182     // @notice get the inboundNonce of a lzApp from a source chain which could be EVM or non-EVM chain
183     // @param _srcChainId - the source chain identifier
184     // @param _srcAddress - the source chain contract address
185     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
186 
187     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
188     // @param _srcAddress - the source chain contract address
189     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
190 
191     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
192     // @param _dstChainId - the destination chain identifier
193     // @param _userApplication - the user app address on this EVM chain
194     // @param _payload - the custom message to send over LayerZero
195     // @param _payInZRO - if false, user app pays the protocol fee in native token
196     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
197     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
198 
199     // @notice get this Endpoint's immutable source identifier
200     function getChainId() external view returns (uint16);
201 
202     // @notice the interface to retry failed message on this Endpoint destination
203     // @param _srcChainId - the source chain identifier
204     // @param _srcAddress - the source chain contract address
205     // @param _payload - the payload to be retried
206     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
207 
208     // @notice query if any STORED payload (message blocking) at the endpoint.
209     // @param _srcChainId - the source chain identifier
210     // @param _srcAddress - the source chain contract address
211     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
212 
213     // @notice query if the _libraryAddress is valid for sending msgs.
214     // @param _userApplication - the user app address on this EVM chain
215     function getSendLibraryAddress(address _userApplication) external view returns (address);
216 
217     // @notice query if the _libraryAddress is valid for receiving msgs.
218     // @param _userApplication - the user app address on this EVM chain
219     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
220 
221     // @notice query if the non-reentrancy guard for send() is on
222     // @return true if the guard is on. false otherwise
223     function isSendingPayload() external view returns (bool);
224 
225     // @notice query if the non-reentrancy guard for receive() is on
226     // @return true if the guard is on. false otherwise
227     function isReceivingPayload() external view returns (bool);
228 
229     // @notice get the configuration of the LayerZero messaging library of the specified version
230     // @param _version - messaging library version
231     // @param _chainId - the chainId for the pending config change
232     // @param _userApplication - the contract address of the user application
233     // @param _configType - type of configuration. every messaging library has its own convention.
234     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
235 
236     // @notice get the send() LayerZero messaging library version
237     // @param _userApplication - the contract address of the user application
238     function getSendVersion(address _userApplication) external view returns (uint16);
239 
240     // @notice get the lzReceive() LayerZero messaging library version
241     // @param _userApplication - the contract address of the user application
242     function getReceiveVersion(address _userApplication) external view returns (uint16);
243 }
244 
245 
246 // File contracts/util/BytesLib.sol
247 
248 /*
249  * @title Solidity Bytes Arrays Utils
250  * @author Gonçalo Sá <goncalo.sa@consensys.net>
251  *
252  * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
253  *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
254  */
255 pragma solidity >=0.8.0 <0.9.0;
256 
257 
258 library BytesLib {
259     function concat(
260         bytes memory _preBytes,
261         bytes memory _postBytes
262     )
263     internal
264     pure
265     returns (bytes memory)
266     {
267         bytes memory tempBytes;
268 
269         assembly {
270         // Get a location of some free memory and store it in tempBytes as
271         // Solidity does for memory variables.
272             tempBytes := mload(0x40)
273 
274         // Store the length of the first bytes array at the beginning of
275         // the memory for tempBytes.
276             let length := mload(_preBytes)
277             mstore(tempBytes, length)
278 
279         // Maintain a memory counter for the current write location in the
280         // temp bytes array by adding the 32 bytes for the array length to
281         // the starting location.
282             let mc := add(tempBytes, 0x20)
283         // Stop copying when the memory counter reaches the length of the
284         // first bytes array.
285             let end := add(mc, length)
286 
287             for {
288             // Initialize a copy counter to the start of the _preBytes data,
289             // 32 bytes into its memory.
290                 let cc := add(_preBytes, 0x20)
291             } lt(mc, end) {
292             // Increase both counters by 32 bytes each iteration.
293                 mc := add(mc, 0x20)
294                 cc := add(cc, 0x20)
295             } {
296             // Write the _preBytes data into the tempBytes memory 32 bytes
297             // at a time.
298                 mstore(mc, mload(cc))
299             }
300 
301         // Add the length of _postBytes to the current length of tempBytes
302         // and store it as the new length in the first 32 bytes of the
303         // tempBytes memory.
304             length := mload(_postBytes)
305             mstore(tempBytes, add(length, mload(tempBytes)))
306 
307         // Move the memory counter back from a multiple of 0x20 to the
308         // actual end of the _preBytes data.
309             mc := end
310         // Stop copying when the memory counter reaches the new combined
311         // length of the arrays.
312             end := add(mc, length)
313 
314             for {
315                 let cc := add(_postBytes, 0x20)
316             } lt(mc, end) {
317                 mc := add(mc, 0x20)
318                 cc := add(cc, 0x20)
319             } {
320                 mstore(mc, mload(cc))
321             }
322 
323         // Update the free-memory pointer by padding our last write location
324         // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
325         // next 32 byte block, then round down to the nearest multiple of
326         // 32. If the sum of the length of the two arrays is zero then add
327         // one before rounding down to leave a blank 32 bytes (the length block with 0).
328             mstore(0x40, and(
329             add(add(end, iszero(add(length, mload(_preBytes)))), 31),
330             not(31) // Round down to the nearest 32 bytes.
331             ))
332         }
333 
334         return tempBytes;
335     }
336 
337     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
338         assembly {
339         // Read the first 32 bytes of _preBytes storage, which is the length
340         // of the array. (We don't need to use the offset into the slot
341         // because arrays use the entire slot.)
342             let fslot := sload(_preBytes.slot)
343         // Arrays of 31 bytes or less have an even value in their slot,
344         // while longer arrays have an odd value. The actual length is
345         // the slot divided by two for odd values, and the lowest order
346         // byte divided by two for even values.
347         // If the slot is even, bitwise and the slot with 255 and divide by
348         // two to get the length. If the slot is odd, bitwise and the slot
349         // with -1 and divide by two.
350             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
351             let mlength := mload(_postBytes)
352             let newlength := add(slength, mlength)
353         // slength can contain both the length and contents of the array
354         // if length < 32 bytes so let's prepare for that
355         // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
356             switch add(lt(slength, 32), lt(newlength, 32))
357             case 2 {
358             // Since the new array still fits in the slot, we just need to
359             // update the contents of the slot.
360             // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
361                 sstore(
362                 _preBytes.slot,
363                 // all the modifications to the slot are inside this
364                 // next block
365                 add(
366                 // we can just add to the slot contents because the
367                 // bytes we want to change are the LSBs
368                 fslot,
369                 add(
370                 mul(
371                 div(
372                 // load the bytes from memory
373                 mload(add(_postBytes, 0x20)),
374                 // zero all bytes to the right
375                 exp(0x100, sub(32, mlength))
376                 ),
377                 // and now shift left the number of bytes to
378                 // leave space for the length in the slot
379                 exp(0x100, sub(32, newlength))
380                 ),
381                 // increase length by the double of the memory
382                 // bytes length
383                 mul(mlength, 2)
384                 )
385                 )
386                 )
387             }
388             case 1 {
389             // The stored value fits in the slot, but the combined value
390             // will exceed it.
391             // get the keccak hash to get the contents of the array
392                 mstore(0x0, _preBytes.slot)
393                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
394 
395             // save new length
396                 sstore(_preBytes.slot, add(mul(newlength, 2), 1))
397 
398             // The contents of the _postBytes array start 32 bytes into
399             // the structure. Our first read should obtain the `submod`
400             // bytes that can fit into the unused space in the last word
401             // of the stored array. To get this, we read 32 bytes starting
402             // from `submod`, so the data we read overlaps with the array
403             // contents by `submod` bytes. Masking the lowest-order
404             // `submod` bytes allows us to add that value directly to the
405             // stored value.
406 
407                 let submod := sub(32, slength)
408                 let mc := add(_postBytes, submod)
409                 let end := add(_postBytes, mlength)
410                 let mask := sub(exp(0x100, submod), 1)
411 
412                 sstore(
413                 sc,
414                 add(
415                 and(
416                 fslot,
417                 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
418                 ),
419                 and(mload(mc), mask)
420                 )
421                 )
422 
423                 for {
424                     mc := add(mc, 0x20)
425                     sc := add(sc, 1)
426                 } lt(mc, end) {
427                     sc := add(sc, 1)
428                     mc := add(mc, 0x20)
429                 } {
430                     sstore(sc, mload(mc))
431                 }
432 
433                 mask := exp(0x100, sub(mc, end))
434 
435                 sstore(sc, mul(div(mload(mc), mask), mask))
436             }
437             default {
438             // get the keccak hash to get the contents of the array
439                 mstore(0x0, _preBytes.slot)
440             // Start copying to the last used word of the stored array.
441                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
442 
443             // save new length
444                 sstore(_preBytes.slot, add(mul(newlength, 2), 1))
445 
446             // Copy over the first `submod` bytes of the new data as in
447             // case 1 above.
448                 let slengthmod := mod(slength, 32)
449                 let mlengthmod := mod(mlength, 32)
450                 let submod := sub(32, slengthmod)
451                 let mc := add(_postBytes, submod)
452                 let end := add(_postBytes, mlength)
453                 let mask := sub(exp(0x100, submod), 1)
454 
455                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
456 
457                 for {
458                     sc := add(sc, 1)
459                     mc := add(mc, 0x20)
460                 } lt(mc, end) {
461                     sc := add(sc, 1)
462                     mc := add(mc, 0x20)
463                 } {
464                     sstore(sc, mload(mc))
465                 }
466 
467                 mask := exp(0x100, sub(mc, end))
468 
469                 sstore(sc, mul(div(mload(mc), mask), mask))
470             }
471         }
472     }
473 
474     function slice(
475         bytes memory _bytes,
476         uint256 _start,
477         uint256 _length
478     )
479     internal
480     pure
481     returns (bytes memory)
482     {
483         require(_length + 31 >= _length, "slice_overflow");
484         require(_bytes.length >= _start + _length, "slice_outOfBounds");
485 
486         bytes memory tempBytes;
487 
488         assembly {
489             switch iszero(_length)
490             case 0 {
491             // Get a location of some free memory and store it in tempBytes as
492             // Solidity does for memory variables.
493                 tempBytes := mload(0x40)
494 
495             // The first word of the slice result is potentially a partial
496             // word read from the original array. To read it, we calculate
497             // the length of that partial word and start copying that many
498             // bytes into the array. The first word we copy will start with
499             // data we don't care about, but the last `lengthmod` bytes will
500             // land at the beginning of the contents of the new array. When
501             // we're done copying, we overwrite the full first word with
502             // the actual length of the slice.
503                 let lengthmod := and(_length, 31)
504 
505             // The multiplication in the next line is necessary
506             // because when slicing multiples of 32 bytes (lengthmod == 0)
507             // the following copy loop was copying the origin's length
508             // and then ending prematurely not copying everything it should.
509                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
510                 let end := add(mc, _length)
511 
512                 for {
513                 // The multiplication in the next line has the same exact purpose
514                 // as the one above.
515                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
516                 } lt(mc, end) {
517                     mc := add(mc, 0x20)
518                     cc := add(cc, 0x20)
519                 } {
520                     mstore(mc, mload(cc))
521                 }
522 
523                 mstore(tempBytes, _length)
524 
525             //update free-memory pointer
526             //allocating the array padded to 32 bytes like the compiler does now
527                 mstore(0x40, and(add(mc, 31), not(31)))
528             }
529             //if we want a zero-length slice let's just return a zero-length array
530             default {
531                 tempBytes := mload(0x40)
532             //zero out the 32 bytes slice we are about to return
533             //we need to do it because Solidity does not garbage collect
534                 mstore(tempBytes, 0)
535 
536                 mstore(0x40, add(tempBytes, 0x20))
537             }
538         }
539 
540         return tempBytes;
541     }
542 
543     function toAddress(bytes memory _bytes, uint256 _start) internal pure returns (address) {
544         require(_bytes.length >= _start + 20, "toAddress_outOfBounds");
545         address tempAddress;
546 
547         assembly {
548             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
549         }
550 
551         return tempAddress;
552     }
553 
554     function toUint8(bytes memory _bytes, uint256 _start) internal pure returns (uint8) {
555         require(_bytes.length >= _start + 1 , "toUint8_outOfBounds");
556         uint8 tempUint;
557 
558         assembly {
559             tempUint := mload(add(add(_bytes, 0x1), _start))
560         }
561 
562         return tempUint;
563     }
564 
565     function toUint16(bytes memory _bytes, uint256 _start) internal pure returns (uint16) {
566         require(_bytes.length >= _start + 2, "toUint16_outOfBounds");
567         uint16 tempUint;
568 
569         assembly {
570             tempUint := mload(add(add(_bytes, 0x2), _start))
571         }
572 
573         return tempUint;
574     }
575 
576     function toUint32(bytes memory _bytes, uint256 _start) internal pure returns (uint32) {
577         require(_bytes.length >= _start + 4, "toUint32_outOfBounds");
578         uint32 tempUint;
579 
580         assembly {
581             tempUint := mload(add(add(_bytes, 0x4), _start))
582         }
583 
584         return tempUint;
585     }
586 
587     function toUint64(bytes memory _bytes, uint256 _start) internal pure returns (uint64) {
588         require(_bytes.length >= _start + 8, "toUint64_outOfBounds");
589         uint64 tempUint;
590 
591         assembly {
592             tempUint := mload(add(add(_bytes, 0x8), _start))
593         }
594 
595         return tempUint;
596     }
597 
598     function toUint96(bytes memory _bytes, uint256 _start) internal pure returns (uint96) {
599         require(_bytes.length >= _start + 12, "toUint96_outOfBounds");
600         uint96 tempUint;
601 
602         assembly {
603             tempUint := mload(add(add(_bytes, 0xc), _start))
604         }
605 
606         return tempUint;
607     }
608 
609     function toUint128(bytes memory _bytes, uint256 _start) internal pure returns (uint128) {
610         require(_bytes.length >= _start + 16, "toUint128_outOfBounds");
611         uint128 tempUint;
612 
613         assembly {
614             tempUint := mload(add(add(_bytes, 0x10), _start))
615         }
616 
617         return tempUint;
618     }
619 
620     function toUint256(bytes memory _bytes, uint256 _start) internal pure returns (uint256) {
621         require(_bytes.length >= _start + 32, "toUint256_outOfBounds");
622         uint256 tempUint;
623 
624         assembly {
625             tempUint := mload(add(add(_bytes, 0x20), _start))
626         }
627 
628         return tempUint;
629     }
630 
631     function toBytes32(bytes memory _bytes, uint256 _start) internal pure returns (bytes32) {
632         require(_bytes.length >= _start + 32, "toBytes32_outOfBounds");
633         bytes32 tempBytes32;
634 
635         assembly {
636             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
637         }
638 
639         return tempBytes32;
640     }
641 
642     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
643         bool success = true;
644 
645         assembly {
646             let length := mload(_preBytes)
647 
648         // if lengths don't match the arrays are not equal
649             switch eq(length, mload(_postBytes))
650             case 1 {
651             // cb is a circuit breaker in the for loop since there's
652             //  no said feature for inline assembly loops
653             // cb = 1 - don't breaker
654             // cb = 0 - break
655                 let cb := 1
656 
657                 let mc := add(_preBytes, 0x20)
658                 let end := add(mc, length)
659 
660                 for {
661                     let cc := add(_postBytes, 0x20)
662                 // the next line is the loop condition:
663                 // while(uint256(mc < end) + cb == 2)
664                 } eq(add(lt(mc, end), cb), 2) {
665                     mc := add(mc, 0x20)
666                     cc := add(cc, 0x20)
667                 } {
668                 // if any of these checks fails then arrays are not equal
669                     if iszero(eq(mload(mc), mload(cc))) {
670                     // unsuccess:
671                         success := 0
672                         cb := 0
673                     }
674                 }
675             }
676             default {
677             // unsuccess:
678                 success := 0
679             }
680         }
681 
682         return success;
683     }
684 
685     function equalStorage(
686         bytes storage _preBytes,
687         bytes memory _postBytes
688     )
689     internal
690     view
691     returns (bool)
692     {
693         bool success = true;
694 
695         assembly {
696         // we know _preBytes_offset is 0
697             let fslot := sload(_preBytes.slot)
698         // Decode the length of the stored array like in concatStorage().
699             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
700             let mlength := mload(_postBytes)
701 
702         // if lengths don't match the arrays are not equal
703             switch eq(slength, mlength)
704             case 1 {
705             // slength can contain both the length and contents of the array
706             // if length < 32 bytes so let's prepare for that
707             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
708                 if iszero(iszero(slength)) {
709                     switch lt(slength, 32)
710                     case 1 {
711                     // blank the last byte which is the length
712                         fslot := mul(div(fslot, 0x100), 0x100)
713 
714                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
715                         // unsuccess:
716                             success := 0
717                         }
718                     }
719                     default {
720                     // cb is a circuit breaker in the for loop since there's
721                     //  no said feature for inline assembly loops
722                     // cb = 1 - don't breaker
723                     // cb = 0 - break
724                         let cb := 1
725 
726                     // get the keccak hash to get the contents of the array
727                         mstore(0x0, _preBytes.slot)
728                         let sc := keccak256(0x0, 0x20)
729 
730                         let mc := add(_postBytes, 0x20)
731                         let end := add(mc, mlength)
732 
733                     // the next line is the loop condition:
734                     // while(uint256(mc < end) + cb == 2)
735                         for {} eq(add(lt(mc, end), cb), 2) {
736                             sc := add(sc, 1)
737                             mc := add(mc, 0x20)
738                         } {
739                             if iszero(eq(sload(sc), mload(mc))) {
740                             // unsuccess:
741                                 success := 0
742                                 cb := 0
743                             }
744                         }
745                     }
746                 }
747             }
748             default {
749             // unsuccess:
750                 success := 0
751             }
752         }
753 
754         return success;
755     }
756 }
757 
758 
759 // File contracts/lzApp/LzApp.sol
760 
761 
762 pragma solidity ^0.8.0;
763 
764 
765 
766 
767 
768 /*
769  * a generic LzReceiver implementation
770  */
771 abstract contract LzApp is Ownable, ILayerZeroReceiver, ILayerZeroUserApplicationConfig {
772     using BytesLib for bytes;
773 
774     ILayerZeroEndpoint public immutable lzEndpoint;
775     mapping(uint16 => bytes) public trustedRemoteLookup;
776     mapping(uint16 => mapping(uint16 => uint)) public minDstGasLookup;
777     address public precrime;
778 
779     event SetPrecrime(address precrime);
780     event SetTrustedRemote(uint16 _remoteChainId, bytes _path);
781     event SetTrustedRemoteAddress(uint16 _remoteChainId, bytes _remoteAddress);
782     event SetMinDstGas(uint16 _dstChainId, uint16 _type, uint _minDstGas);
783 
784     constructor(address _endpoint) {
785         lzEndpoint = ILayerZeroEndpoint(_endpoint);
786     }
787 
788     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) public virtual override {
789         // lzReceive must be called by the endpoint for security
790         require(_msgSender() == address(lzEndpoint), "LzApp: invalid endpoint caller");
791 
792         bytes memory trustedRemote = trustedRemoteLookup[_srcChainId];
793         // if will still block the message pathway from (srcChainId, srcAddress). should not receive message from untrusted remote.
794         require(_srcAddress.length == trustedRemote.length && trustedRemote.length > 0 && keccak256(_srcAddress) == keccak256(trustedRemote), "LzApp: invalid source sending contract");
795 
796         _blockingLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
797     }
798 
799     // abstract function - the default behaviour of LayerZero is blocking. See: NonblockingLzApp if you dont need to enforce ordered messaging
800     function _blockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual;
801 
802     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _adapterParams, uint _nativeFee) internal virtual {
803         bytes memory trustedRemote = trustedRemoteLookup[_dstChainId];
804         require(trustedRemote.length != 0, "LzApp: destination chain is not a trusted source");
805         lzEndpoint.send{value: _nativeFee}(_dstChainId, trustedRemote, _payload, _refundAddress, _zroPaymentAddress, _adapterParams);
806     }
807 
808     function _checkGasLimit(uint16 _dstChainId, uint16 _type, bytes memory _adapterParams, uint _extraGas) internal view virtual {
809         uint providedGasLimit = _getGasLimit(_adapterParams);
810         uint minGasLimit = minDstGasLookup[_dstChainId][_type] + _extraGas;
811         require(minGasLimit > 0, "LzApp: minGasLimit not set");
812         require(providedGasLimit >= minGasLimit, "LzApp: gas limit is too low");
813     }
814 
815     function _getGasLimit(bytes memory _adapterParams) internal pure virtual returns (uint gasLimit) {
816         require(_adapterParams.length >= 34, "LzApp: invalid adapterParams");
817         assembly {
818             gasLimit := mload(add(_adapterParams, 34))
819         }
820     }
821 
822     //---------------------------UserApplication config----------------------------------------
823     function getConfig(uint16 _version, uint16 _chainId, address, uint _configType) external view returns (bytes memory) {
824         return lzEndpoint.getConfig(_version, _chainId, address(this), _configType);
825     }
826 
827     // generic config for LayerZero user Application
828     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external override onlyOwner {
829         lzEndpoint.setConfig(_version, _chainId, _configType, _config);
830     }
831 
832     function setSendVersion(uint16 _version) external override onlyOwner {
833         lzEndpoint.setSendVersion(_version);
834     }
835 
836     function setReceiveVersion(uint16 _version) external override onlyOwner {
837         lzEndpoint.setReceiveVersion(_version);
838     }
839 
840     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external override onlyOwner {
841         lzEndpoint.forceResumeReceive(_srcChainId, _srcAddress);
842     }
843 
844     // _path = abi.encodePacked(remoteAddress, localAddress)
845     // this function set the trusted path for the cross-chain communication
846     function setTrustedRemote(uint16 _srcChainId, bytes calldata _path) external onlyOwner {
847         trustedRemoteLookup[_srcChainId] = _path;
848         emit SetTrustedRemote(_srcChainId, _path);
849     }
850 
851     function setTrustedRemoteAddress(uint16 _remoteChainId, bytes calldata _remoteAddress) external onlyOwner {
852         trustedRemoteLookup[_remoteChainId] = abi.encodePacked(_remoteAddress, address(this));
853         emit SetTrustedRemoteAddress(_remoteChainId, _remoteAddress);
854     }
855 
856     function getTrustedRemoteAddress(uint16 _remoteChainId) external view returns (bytes memory) {
857         bytes memory path = trustedRemoteLookup[_remoteChainId];
858         require(path.length != 0, "LzApp: no trusted path record");
859         return path.slice(0, path.length - 20); // the last 20 bytes should be address(this)
860     }
861 
862     function setPrecrime(address _precrime) external onlyOwner {
863         precrime = _precrime;
864         emit SetPrecrime(_precrime);
865     }
866 
867     function setMinDstGas(uint16 _dstChainId, uint16 _packetType, uint _minGas) external onlyOwner {
868         require(_minGas > 0, "LzApp: invalid minGas");
869         minDstGasLookup[_dstChainId][_packetType] = _minGas;
870         emit SetMinDstGas(_dstChainId, _packetType, _minGas);
871     }
872 
873     //--------------------------- VIEW FUNCTION ----------------------------------------
874     function isTrustedRemote(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool) {
875         bytes memory trustedSource = trustedRemoteLookup[_srcChainId];
876         return keccak256(trustedSource) == keccak256(_srcAddress);
877     }
878 }
879 
880 
881 // File contracts/util/ExcessivelySafeCall.sol
882 
883 pragma solidity >=0.7.6;
884 
885 library ExcessivelySafeCall {
886     uint256 constant LOW_28_MASK =
887     0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
888 
889     /// @notice Use when you _really_ really _really_ don't trust the called
890     /// contract. This prevents the called contract from causing reversion of
891     /// the caller in as many ways as we can.
892     /// @dev The main difference between this and a solidity low-level call is
893     /// that we limit the number of bytes that the callee can cause to be
894     /// copied to caller memory. This prevents stupid things like malicious
895     /// contracts returning 10,000,000 bytes causing a local OOG when copying
896     /// to memory.
897     /// @param _target The address to call
898     /// @param _gas The amount of gas to forward to the remote contract
899     /// @param _maxCopy The maximum number of bytes of returndata to copy
900     /// to memory.
901     /// @param _calldata The data to send to the remote contract
902     /// @return success and returndata, as `.call()`. Returndata is capped to
903     /// `_maxCopy` bytes.
904     function excessivelySafeCall(
905         address _target,
906         uint256 _gas,
907         uint16 _maxCopy,
908         bytes memory _calldata
909     ) internal returns (bool, bytes memory) {
910         // set up for assembly call
911         uint256 _toCopy;
912         bool _success;
913         bytes memory _returnData = new bytes(_maxCopy);
914         // dispatch message to recipient
915         // by assembly calling "handle" function
916         // we call via assembly to avoid memcopying a very large returndata
917         // returned by a malicious contract
918         assembly {
919             _success := call(
920             _gas, // gas
921             _target, // recipient
922             0, // ether value
923             add(_calldata, 0x20), // inloc
924             mload(_calldata), // inlen
925             0, // outloc
926             0 // outlen
927             )
928         // limit our copy to 256 bytes
929             _toCopy := returndatasize()
930             if gt(_toCopy, _maxCopy) {
931                 _toCopy := _maxCopy
932             }
933         // Store the length of the copied bytes
934             mstore(_returnData, _toCopy)
935         // copy the bytes from returndata[0:_toCopy]
936             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
937         }
938         return (_success, _returnData);
939     }
940 
941     /// @notice Use when you _really_ really _really_ don't trust the called
942     /// contract. This prevents the called contract from causing reversion of
943     /// the caller in as many ways as we can.
944     /// @dev The main difference between this and a solidity low-level call is
945     /// that we limit the number of bytes that the callee can cause to be
946     /// copied to caller memory. This prevents stupid things like malicious
947     /// contracts returning 10,000,000 bytes causing a local OOG when copying
948     /// to memory.
949     /// @param _target The address to call
950     /// @param _gas The amount of gas to forward to the remote contract
951     /// @param _maxCopy The maximum number of bytes of returndata to copy
952     /// to memory.
953     /// @param _calldata The data to send to the remote contract
954     /// @return success and returndata, as `.call()`. Returndata is capped to
955     /// `_maxCopy` bytes.
956     function excessivelySafeStaticCall(
957         address _target,
958         uint256 _gas,
959         uint16 _maxCopy,
960         bytes memory _calldata
961     ) internal view returns (bool, bytes memory) {
962         // set up for assembly call
963         uint256 _toCopy;
964         bool _success;
965         bytes memory _returnData = new bytes(_maxCopy);
966         // dispatch message to recipient
967         // by assembly calling "handle" function
968         // we call via assembly to avoid memcopying a very large returndata
969         // returned by a malicious contract
970         assembly {
971             _success := staticcall(
972             _gas, // gas
973             _target, // recipient
974             add(_calldata, 0x20), // inloc
975             mload(_calldata), // inlen
976             0, // outloc
977             0 // outlen
978             )
979         // limit our copy to 256 bytes
980             _toCopy := returndatasize()
981             if gt(_toCopy, _maxCopy) {
982                 _toCopy := _maxCopy
983             }
984         // Store the length of the copied bytes
985             mstore(_returnData, _toCopy)
986         // copy the bytes from returndata[0:_toCopy]
987             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
988         }
989         return (_success, _returnData);
990     }
991 
992     /**
993      * @notice Swaps function selectors in encoded contract calls
994      * @dev Allows reuse of encoded calldata for functions with identical
995      * argument types but different names. It simply swaps out the first 4 bytes
996      * for the new selector. This function modifies memory in place, and should
997      * only be used with caution.
998      * @param _newSelector The new 4-byte selector
999      * @param _buf The encoded contract args
1000      */
1001     function swapSelector(bytes4 _newSelector, bytes memory _buf)
1002     internal
1003     pure
1004     {
1005         require(_buf.length >= 4);
1006         uint256 _mask = LOW_28_MASK;
1007         assembly {
1008         // load the first word of
1009             let _word := mload(add(_buf, 0x20))
1010         // mask out the top 4 bytes
1011         // /x
1012             _word := and(_word, _mask)
1013             _word := or(_newSelector, _word)
1014             mstore(add(_buf, 0x20), _word)
1015         }
1016     }
1017 }
1018 
1019 
1020 // File contracts/lzApp/NonblockingLzApp.sol
1021 
1022 
1023 pragma solidity ^0.8.0;
1024 
1025 
1026 /*
1027  * the default LayerZero messaging behaviour is blocking, i.e. any failed message will block the channel
1028  * this abstract class try-catch all fail messages and store locally for future retry. hence, non-blocking
1029  * NOTE: if the srcAddress is not configured properly, it will still block the message pathway from (srcChainId, srcAddress)
1030  */
1031 abstract contract NonblockingLzApp is LzApp {
1032     using ExcessivelySafeCall for address;
1033 
1034     constructor(address _endpoint) LzApp(_endpoint) {}
1035 
1036     mapping(uint16 => mapping(bytes => mapping(uint64 => bytes32))) public failedMessages;
1037 
1038     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload, bytes _reason);
1039     event RetryMessageSuccess(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes32 _payloadHash);
1040 
1041     // overriding the virtual function in LzReceiver
1042     function _blockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual override {
1043         (bool success, bytes memory reason) = address(this).excessivelySafeCall(gasleft(), 150, abi.encodeWithSelector(this.nonblockingLzReceive.selector, _srcChainId, _srcAddress, _nonce, _payload));
1044         // try-catch all errors/exceptions
1045         if (!success) {
1046             failedMessages[_srcChainId][_srcAddress][_nonce] = keccak256(_payload);
1047             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload, reason);
1048         }
1049     }
1050 
1051     function nonblockingLzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) public virtual {
1052         // only internal transaction
1053         require(_msgSender() == address(this), "NonblockingLzApp: caller must be LzApp");
1054         _nonblockingLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1055     }
1056 
1057     //@notice override this function
1058     function _nonblockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual;
1059 
1060     function retryMessage(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) public payable virtual {
1061         // assert there is message to retry
1062         bytes32 payloadHash = failedMessages[_srcChainId][_srcAddress][_nonce];
1063         require(payloadHash != bytes32(0), "NonblockingLzApp: no stored message");
1064         require(keccak256(_payload) == payloadHash, "NonblockingLzApp: invalid payload");
1065         // clear the stored message
1066         failedMessages[_srcChainId][_srcAddress][_nonce] = bytes32(0);
1067         // execute the message. revert if it fails again
1068         _nonblockingLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1069         emit RetryMessageSuccess(_srcChainId, _srcAddress, _nonce, payloadHash);
1070     }
1071 }
1072 
1073 
1074 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.1
1075 
1076 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 /**
1081  * @dev Interface of the ERC20 standard as defined in the EIP.
1082  */
1083 interface IERC20 {
1084     /**
1085      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1086      * another (`to`).
1087      *
1088      * Note that `value` may be zero.
1089      */
1090     event Transfer(address indexed from, address indexed to, uint256 value);
1091 
1092     /**
1093      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1094      * a call to {approve}. `value` is the new allowance.
1095      */
1096     event Approval(address indexed owner, address indexed spender, uint256 value);
1097 
1098     /**
1099      * @dev Returns the amount of tokens in existence.
1100      */
1101     function totalSupply() external view returns (uint256);
1102 
1103     /**
1104      * @dev Returns the amount of tokens owned by `account`.
1105      */
1106     function balanceOf(address account) external view returns (uint256);
1107 
1108     /**
1109      * @dev Moves `amount` tokens from the caller's account to `to`.
1110      *
1111      * Returns a boolean value indicating whether the operation succeeded.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function transfer(address to, uint256 amount) external returns (bool);
1116 
1117     /**
1118      * @dev Returns the remaining number of tokens that `spender` will be
1119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1120      * zero by default.
1121      *
1122      * This value changes when {approve} or {transferFrom} are called.
1123      */
1124     function allowance(address owner, address spender) external view returns (uint256);
1125 
1126     /**
1127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1128      *
1129      * Returns a boolean value indicating whether the operation succeeded.
1130      *
1131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1132      * that someone may use both the old and the new allowance by unfortunate
1133      * transaction ordering. One possible solution to mitigate this race
1134      * condition is to first reduce the spender's allowance to 0 and set the
1135      * desired value afterwards:
1136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1137      *
1138      * Emits an {Approval} event.
1139      */
1140     function approve(address spender, uint256 amount) external returns (bool);
1141 
1142     /**
1143      * @dev Moves `amount` tokens from `from` to `to` using the
1144      * allowance mechanism. `amount` is then deducted from the caller's
1145      * allowance.
1146      *
1147      * Returns a boolean value indicating whether the operation succeeded.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function transferFrom(
1152         address from,
1153         address to,
1154         uint256 amount
1155     ) external returns (bool);
1156 }
1157 
1158 
1159 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.1
1160 
1161 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1162 
1163 pragma solidity ^0.8.0;
1164 
1165 /**
1166  * @dev Interface of the ERC165 standard, as defined in the
1167  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1168  *
1169  * Implementers can declare support of contract interfaces, which can then be
1170  * queried by others ({ERC165Checker}).
1171  *
1172  * For an implementation, see {ERC165}.
1173  */
1174 interface IERC165 {
1175     /**
1176      * @dev Returns true if this contract implements the interface defined by
1177      * `interfaceId`. See the corresponding
1178      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1179      * to learn more about how these ids are created.
1180      *
1181      * This function call must use less than 30 000 gas.
1182      */
1183     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1184 }
1185 
1186 
1187 // File contracts/token/oft/IOFTCore.sol
1188 
1189 
1190 pragma solidity >=0.5.0;
1191 
1192 
1193 /**
1194  * @dev Interface of the IOFT core standard
1195  */
1196 interface IOFTCore is IERC165 {
1197     /**
1198      * @dev estimate send token `_tokenId` to (`_dstChainId`, `_toAddress`)
1199      * _dstChainId - L0 defined chain id to send tokens too
1200      * _toAddress - dynamic bytes array which contains the address to whom you are sending tokens to on the dstChain
1201      * _amount - amount of the tokens to transfer
1202      * _useZro - indicates to use zro to pay L0 fees
1203      * _adapterParam - flexible bytes array to indicate messaging adapter services in L0
1204      */
1205     function estimateSendFee(uint16 _dstChainId, bytes calldata _toAddress, uint _amount, bool _useZro, bytes calldata _adapterParams) external view returns (uint nativeFee, uint zroFee);
1206 
1207     /**
1208      * @dev send `_amount` amount of token to (`_dstChainId`, `_toAddress`) from `_from`
1209      * `_from` the owner of token
1210      * `_dstChainId` the destination chain identifier
1211      * `_toAddress` can be any size depending on the `dstChainId`.
1212      * `_amount` the quantity of tokens in wei
1213      * `_refundAddress` the address LayerZero refunds if too much message fee is sent
1214      * `_zroPaymentAddress` set to address(0x0) if not paying in ZRO (LayerZero Token)
1215      * `_adapterParams` is a flexible bytes array to indicate messaging adapter services
1216      */
1217     function sendFrom(address _from, uint16 _dstChainId, bytes calldata _toAddress, uint _amount, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
1218 
1219     /**
1220      * @dev returns the circulating amount of tokens on current chain
1221      */
1222     function circulatingSupply() external view returns (uint);
1223 
1224     /**
1225      * @dev Emitted when `_amount` tokens are moved from the `_sender` to (`_dstChainId`, `_toAddress`)
1226      * `_nonce` is the outbound nonce
1227      */
1228     event SendToChain(uint16 indexed _dstChainId, address indexed _from, bytes indexed _toAddress, uint _amount);
1229 
1230     /**
1231      * @dev Emitted when `_amount` tokens are received from `_srcChainId` into the `_toAddress` on the local chain.
1232      * `_nonce` is the inbound nonce.
1233      */
1234     event ReceiveFromChain(uint16 indexed _srcChainId, bytes _fromAddress, address indexed _to, uint _amount);
1235 
1236     event SetUseCustomAdapterParams(bool _useCustomAdapterParams);
1237 }
1238 
1239 
1240 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.1
1241 
1242 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 /**
1247  * @dev Implementation of the {IERC165} interface.
1248  *
1249  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1250  * for the additional interface id that will be supported. For example:
1251  *
1252  * ```solidity
1253  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1254  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1255  * }
1256  * ```
1257  *
1258  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1259  */
1260 abstract contract ERC165 is IERC165 {
1261     /**
1262      * @dev See {IERC165-supportsInterface}.
1263      */
1264     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1265         return interfaceId == type(IERC165).interfaceId;
1266     }
1267 }
1268 
1269 
1270 // File contracts/token/oft/OFTCore.sol
1271 
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 
1276 
1277 abstract contract OFTCore is NonblockingLzApp, ERC165, IOFTCore {
1278     using BytesLib for bytes;
1279 
1280     uint public constant NO_EXTRA_GAS = 0;
1281 
1282     // packet type
1283     uint16 public constant PT_SEND = 0;
1284 
1285     bool public useCustomAdapterParams;
1286 
1287     constructor(address _lzEndpoint) NonblockingLzApp(_lzEndpoint) {}
1288 
1289     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1290         return interfaceId == type(IOFTCore).interfaceId || super.supportsInterface(interfaceId);
1291     }
1292 
1293     function estimateSendFee(uint16 _dstChainId, bytes calldata _toAddress, uint _amount, bool _useZro, bytes calldata _adapterParams) public view virtual override returns (uint nativeFee, uint zroFee) {
1294         // mock the payload for sendFrom()
1295         bytes memory payload = abi.encode(PT_SEND, abi.encodePacked(msg.sender), _toAddress, _amount);
1296         return lzEndpoint.estimateFees(_dstChainId, address(this), payload, _useZro, _adapterParams);
1297     }
1298 
1299     function sendFrom(address _from, uint16 _dstChainId, bytes calldata _toAddress, uint _amount, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) public payable virtual override {
1300         _send(_from, _dstChainId, _toAddress, _amount, _refundAddress, _zroPaymentAddress, _adapterParams);
1301     }
1302 
1303     function setUseCustomAdapterParams(bool _useCustomAdapterParams) public virtual onlyOwner {
1304         useCustomAdapterParams = _useCustomAdapterParams;
1305         emit SetUseCustomAdapterParams(_useCustomAdapterParams);
1306     }
1307 
1308     function _nonblockingLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual override {
1309         uint16 packetType;
1310         assembly {
1311             packetType := mload(add(_payload, 32))
1312         }
1313 
1314         if (packetType == PT_SEND) {
1315             _sendAck(_srcChainId, _srcAddress, _nonce, _payload);
1316         } else {
1317             revert("OFTCore: unknown packet type");
1318         }
1319     }
1320 
1321     function _send(address _from, uint16 _dstChainId, bytes memory _toAddress, uint _amount, address payable _refundAddress, address _zroPaymentAddress, bytes memory _adapterParams) internal virtual {
1322         _checkAdapterParams(_dstChainId, PT_SEND, _adapterParams, NO_EXTRA_GAS);
1323 
1324         _debitFrom(_from, _dstChainId, _toAddress, _amount);
1325 
1326         bytes memory lzPayload = abi.encode(PT_SEND, abi.encodePacked(_from), _toAddress, _amount);
1327         _lzSend(_dstChainId, lzPayload, _refundAddress, _zroPaymentAddress, _adapterParams, msg.value);
1328 
1329         emit SendToChain(_dstChainId, _from, _toAddress, _amount);
1330     }
1331 
1332     function _sendAck(uint16 _srcChainId, bytes memory, uint64, bytes memory _payload) internal virtual {
1333         (, bytes memory from, bytes memory toAddressBytes, uint amount) = abi.decode(_payload, (uint16, bytes, bytes, uint));
1334 
1335         address to = toAddressBytes.toAddress(0);
1336 
1337         _creditTo(_srcChainId, to, amount);
1338         emit ReceiveFromChain(_srcChainId, from, to, amount);
1339     }
1340 
1341     function _checkAdapterParams(uint16 _dstChainId, uint16 _pkType, bytes memory _adapterParams, uint _extraGas) internal virtual {
1342         if (useCustomAdapterParams) {
1343             _checkGasLimit(_dstChainId, _pkType, _adapterParams, _extraGas);
1344         } else {
1345             require(_adapterParams.length == 0, "OFTCore: _adapterParams must be empty.");
1346         }
1347     }
1348 
1349     function _debitFrom(address _from, uint16 _dstChainId, bytes memory _toAddress, uint _amount) internal virtual;
1350 
1351     function _creditTo(uint16 _srcChainId, address _toAddress, uint _amount) internal virtual;
1352 }
1353 
1354 
1355 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.1
1356 
1357 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1358 
1359 pragma solidity ^0.8.0;
1360 
1361 /**
1362  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1363  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1364  *
1365  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1366  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1367  * need to send a transaction, and thus is not required to hold Ether at all.
1368  */
1369 interface IERC20Permit {
1370     /**
1371      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1372      * given ``owner``'s signed approval.
1373      *
1374      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1375      * ordering also apply here.
1376      *
1377      * Emits an {Approval} event.
1378      *
1379      * Requirements:
1380      *
1381      * - `spender` cannot be the zero address.
1382      * - `deadline` must be a timestamp in the future.
1383      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1384      * over the EIP712-formatted function arguments.
1385      * - the signature must use ``owner``'s current nonce (see {nonces}).
1386      *
1387      * For more information on the signature format, see the
1388      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1389      * section].
1390      */
1391     function permit(
1392         address owner,
1393         address spender,
1394         uint256 value,
1395         uint256 deadline,
1396         uint8 v,
1397         bytes32 r,
1398         bytes32 s
1399     ) external;
1400 
1401     /**
1402      * @dev Returns the current nonce for `owner`. This value must be
1403      * included whenever a signature is generated for {permit}.
1404      *
1405      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1406      * prevents a signature from being used multiple times.
1407      */
1408     function nonces(address owner) external view returns (uint256);
1409 
1410     /**
1411      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1412      */
1413     // solhint-disable-next-line func-name-mixedcase
1414     function DOMAIN_SEPARATOR() external view returns (bytes32);
1415 }
1416 
1417 
1418 // File @openzeppelin/contracts/utils/Address.sol@v4.7.1
1419 
1420 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1421 
1422 pragma solidity ^0.8.1;
1423 
1424 /**
1425  * @dev Collection of functions related to the address type
1426  */
1427 library Address {
1428     /**
1429      * @dev Returns true if `account` is a contract.
1430      *
1431      * [IMPORTANT]
1432      * ====
1433      * It is unsafe to assume that an address for which this function returns
1434      * false is an externally-owned account (EOA) and not a contract.
1435      *
1436      * Among others, `isContract` will return false for the following
1437      * types of addresses:
1438      *
1439      *  - an externally-owned account
1440      *  - a contract in construction
1441      *  - an address where a contract will be created
1442      *  - an address where a contract lived, but was destroyed
1443      * ====
1444      *
1445      * [IMPORTANT]
1446      * ====
1447      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1448      *
1449      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1450      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1451      * constructor.
1452      * ====
1453      */
1454     function isContract(address account) internal view returns (bool) {
1455         // This method relies on extcodesize/address.code.length, which returns 0
1456         // for contracts in construction, since the code is only stored at the end
1457         // of the constructor execution.
1458 
1459         return account.code.length > 0;
1460     }
1461 
1462     /**
1463      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1464      * `recipient`, forwarding all available gas and reverting on errors.
1465      *
1466      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1467      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1468      * imposed by `transfer`, making them unable to receive funds via
1469      * `transfer`. {sendValue} removes this limitation.
1470      *
1471      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1472      *
1473      * IMPORTANT: because control is transferred to `recipient`, care must be
1474      * taken to not create reentrancy vulnerabilities. Consider using
1475      * {ReentrancyGuard} or the
1476      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1477      */
1478     function sendValue(address payable recipient, uint256 amount) internal {
1479         require(address(this).balance >= amount, "Address: insufficient balance");
1480 
1481         (bool success, ) = recipient.call{value: amount}("");
1482         require(success, "Address: unable to send value, recipient may have reverted");
1483     }
1484 
1485     /**
1486      * @dev Performs a Solidity function call using a low level `call`. A
1487      * plain `call` is an unsafe replacement for a function call: use this
1488      * function instead.
1489      *
1490      * If `target` reverts with a revert reason, it is bubbled up by this
1491      * function (like regular Solidity function calls).
1492      *
1493      * Returns the raw returned data. To convert to the expected return value,
1494      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1495      *
1496      * Requirements:
1497      *
1498      * - `target` must be a contract.
1499      * - calling `target` with `data` must not revert.
1500      *
1501      * _Available since v3.1._
1502      */
1503     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1504         return functionCall(target, data, "Address: low-level call failed");
1505     }
1506 
1507     /**
1508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1509      * `errorMessage` as a fallback revert reason when `target` reverts.
1510      *
1511      * _Available since v3.1._
1512      */
1513     function functionCall(
1514         address target,
1515         bytes memory data,
1516         string memory errorMessage
1517     ) internal returns (bytes memory) {
1518         return functionCallWithValue(target, data, 0, errorMessage);
1519     }
1520 
1521     /**
1522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1523      * but also transferring `value` wei to `target`.
1524      *
1525      * Requirements:
1526      *
1527      * - the calling contract must have an ETH balance of at least `value`.
1528      * - the called Solidity function must be `payable`.
1529      *
1530      * _Available since v3.1._
1531      */
1532     function functionCallWithValue(
1533         address target,
1534         bytes memory data,
1535         uint256 value
1536     ) internal returns (bytes memory) {
1537         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1538     }
1539 
1540     /**
1541      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1542      * with `errorMessage` as a fallback revert reason when `target` reverts.
1543      *
1544      * _Available since v3.1._
1545      */
1546     function functionCallWithValue(
1547         address target,
1548         bytes memory data,
1549         uint256 value,
1550         string memory errorMessage
1551     ) internal returns (bytes memory) {
1552         require(address(this).balance >= value, "Address: insufficient balance for call");
1553         require(isContract(target), "Address: call to non-contract");
1554 
1555         (bool success, bytes memory returndata) = target.call{value: value}(data);
1556         return verifyCallResult(success, returndata, errorMessage);
1557     }
1558 
1559     /**
1560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1561      * but performing a static call.
1562      *
1563      * _Available since v3.3._
1564      */
1565     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1566         return functionStaticCall(target, data, "Address: low-level static call failed");
1567     }
1568 
1569     /**
1570      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1571      * but performing a static call.
1572      *
1573      * _Available since v3.3._
1574      */
1575     function functionStaticCall(
1576         address target,
1577         bytes memory data,
1578         string memory errorMessage
1579     ) internal view returns (bytes memory) {
1580         require(isContract(target), "Address: static call to non-contract");
1581 
1582         (bool success, bytes memory returndata) = target.staticcall(data);
1583         return verifyCallResult(success, returndata, errorMessage);
1584     }
1585 
1586     /**
1587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1588      * but performing a delegate call.
1589      *
1590      * _Available since v3.4._
1591      */
1592     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1593         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1594     }
1595 
1596     /**
1597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1598      * but performing a delegate call.
1599      *
1600      * _Available since v3.4._
1601      */
1602     function functionDelegateCall(
1603         address target,
1604         bytes memory data,
1605         string memory errorMessage
1606     ) internal returns (bytes memory) {
1607         require(isContract(target), "Address: delegate call to non-contract");
1608 
1609         (bool success, bytes memory returndata) = target.delegatecall(data);
1610         return verifyCallResult(success, returndata, errorMessage);
1611     }
1612 
1613     /**
1614      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1615      * revert reason using the provided one.
1616      *
1617      * _Available since v4.3._
1618      */
1619     function verifyCallResult(
1620         bool success,
1621         bytes memory returndata,
1622         string memory errorMessage
1623     ) internal pure returns (bytes memory) {
1624         if (success) {
1625             return returndata;
1626         } else {
1627             // Look for revert reason and bubble it up if present
1628             if (returndata.length > 0) {
1629                 // The easiest way to bubble the revert reason is using memory via assembly
1630                 /// @solidity memory-safe-assembly
1631                 assembly {
1632                     let returndata_size := mload(returndata)
1633                     revert(add(32, returndata), returndata_size)
1634                 }
1635             } else {
1636                 revert(errorMessage);
1637             }
1638         }
1639     }
1640 }
1641 
1642 
1643 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.1
1644 
1645 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1646 
1647 pragma solidity ^0.8.0;
1648 
1649 
1650 
1651 /**
1652  * @title SafeERC20
1653  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1654  * contract returns false). Tokens that return no value (and instead revert or
1655  * throw on failure) are also supported, non-reverting calls are assumed to be
1656  * successful.
1657  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1658  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1659  */
1660 library SafeERC20 {
1661     using Address for address;
1662 
1663     function safeTransfer(
1664         IERC20 token,
1665         address to,
1666         uint256 value
1667     ) internal {
1668         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1669     }
1670 
1671     function safeTransferFrom(
1672         IERC20 token,
1673         address from,
1674         address to,
1675         uint256 value
1676     ) internal {
1677         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1678     }
1679 
1680     /**
1681      * @dev Deprecated. This function has issues similar to the ones found in
1682      * {IERC20-approve}, and its usage is discouraged.
1683      *
1684      * Whenever possible, use {safeIncreaseAllowance} and
1685      * {safeDecreaseAllowance} instead.
1686      */
1687     function safeApprove(
1688         IERC20 token,
1689         address spender,
1690         uint256 value
1691     ) internal {
1692         // safeApprove should only be called when setting an initial allowance,
1693         // or when resetting it to zero. To increase and decrease it, use
1694         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1695         require(
1696             (value == 0) || (token.allowance(address(this), spender) == 0),
1697             "SafeERC20: approve from non-zero to non-zero allowance"
1698         );
1699         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1700     }
1701 
1702     function safeIncreaseAllowance(
1703         IERC20 token,
1704         address spender,
1705         uint256 value
1706     ) internal {
1707         uint256 newAllowance = token.allowance(address(this), spender) + value;
1708         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1709     }
1710 
1711     function safeDecreaseAllowance(
1712         IERC20 token,
1713         address spender,
1714         uint256 value
1715     ) internal {
1716         unchecked {
1717             uint256 oldAllowance = token.allowance(address(this), spender);
1718             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1719             uint256 newAllowance = oldAllowance - value;
1720             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1721         }
1722     }
1723 
1724     function safePermit(
1725         IERC20Permit token,
1726         address owner,
1727         address spender,
1728         uint256 value,
1729         uint256 deadline,
1730         uint8 v,
1731         bytes32 r,
1732         bytes32 s
1733     ) internal {
1734         uint256 nonceBefore = token.nonces(owner);
1735         token.permit(owner, spender, value, deadline, v, r, s);
1736         uint256 nonceAfter = token.nonces(owner);
1737         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1738     }
1739 
1740     /**
1741      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1742      * on the return value: the return value is optional (but if data is returned, it must not be false).
1743      * @param token The token targeted by the call.
1744      * @param data The call data (encoded using abi.encode or one of its variants).
1745      */
1746     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1747         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1748         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1749         // the target address contains contract code and also asserts for success in the low-level call.
1750 
1751         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1752         if (returndata.length > 0) {
1753             // Return data is optional
1754             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1755         }
1756     }
1757 }
1758 
1759 
1760 // File contracts/token/oft/extension/ProxyERC20WithMint.sol
1761 
1762 
1763 pragma solidity ^0.8.0;
1764 
1765 
1766 interface MultisigWallet {
1767     function submitTransaction(
1768         address destination,
1769         uint value,
1770         bytes memory data
1771     ) external returns (uint transactionId);
1772 }
1773 
1774 interface BurnableToken {
1775     function burnFrom(
1776         address from,
1777         uint256 amount
1778     ) external;
1779 }
1780 
1781 contract ProxyERC20WithMint is OFTCore {
1782     using SafeERC20 for IERC20;
1783 
1784     IERC20 public immutable token;
1785 
1786     address public multisig;
1787     address public bridgeManager;
1788 
1789     constructor(
1790         address _lzEndpoint,
1791         address _proxyToken,
1792         address _multisig,
1793         address _bridgeManager
1794     ) OFTCore(_lzEndpoint) {
1795         token = IERC20(_proxyToken);
1796         multisig = _multisig;
1797         bridgeManager = _bridgeManager;
1798     }
1799 
1800     function circulatingSupply() public view virtual override returns (uint) {
1801         unchecked {
1802             return token.totalSupply() - token.balanceOf(address(this));
1803         }
1804     }
1805 
1806     function _debitFrom(
1807         address _from,
1808         uint16,
1809         bytes memory,
1810         uint _amount
1811     ) internal virtual override {
1812         require(_from == _msgSender(), "ProxyOFT: owner is not send caller");
1813         BurnableToken(address(token)).burnFrom(_from, _amount);
1814     }
1815 
1816     function _creditTo(
1817         uint16,
1818         address _toAddress,
1819         uint _amount
1820     ) internal virtual override {
1821         MultisigWallet(multisig).submitTransaction(
1822             bridgeManager,
1823             0,
1824             abi.encodeWithSelector(
1825                 0xf633be1e,
1826                 token,
1827                 _amount,
1828                 _toAddress,
1829                 // instead of src chain txn hash, using this as unique receiptId
1830                 keccak256(abi.encodePacked(_amount, _toAddress, blockhash(block.number - 1)))
1831             )
1832         );
1833     }
1834 }