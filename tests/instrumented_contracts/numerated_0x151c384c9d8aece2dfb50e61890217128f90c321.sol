1 // SPDX-License-Identifier: MIT
2 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
3 
4 pragma solidity >=0.8.0;
5 
6 /// @title DynamicBuffer
7 /// @author David Huber (@cxkoda) and Simon Fremaux (@dievardump). See also
8 ///         https://raw.githubusercontent.com/dievardump/solidity-dynamic-buffer
9 /// @notice This library is used to allocate a big amount of container memory
10 //          which will be subsequently filled without needing to reallocate
11 ///         memory.
12 /// @dev First, allocate memory.
13 ///      Then use `buffer.appendUnchecked(theBytes)` or `appendSafe()` if
14 ///      bounds checking is required.
15 library DynamicBuffer {
16     /// @notice Allocates container space for the DynamicBuffer
17     /// @param capacity The intended max amount of bytes in the buffer
18     /// @return buffer The memory location of the buffer
19     /// @dev Allocates `capacity + 0x60` bytes of space
20     ///      The buffer array starts at the first container data position,
21     ///      (i.e. `buffer = container + 0x20`)
22     function allocate(uint256 capacity) internal pure returns (bytes memory buffer) {
23         assembly {
24             // Get next-free memory address
25             let container := mload(0x40)
26 
27             // Allocate memory by setting a new next-free address
28             {
29                 // Add 2 x 32 bytes in size for the two length fields
30                 // Add 32 bytes safety space for 32B chunked copy
31                 let size := add(capacity, 0x60)
32                 let newNextFree := add(container, size)
33                 mstore(0x40, newNextFree)
34             }
35 
36             // Set the correct container length
37             {
38                 let length := add(capacity, 0x40)
39                 mstore(container, length)
40             }
41 
42             // The buffer starts at idx 1 in the container (0 is length)
43             buffer := add(container, 0x20)
44 
45             // Init content with length 0
46             mstore(buffer, 0)
47         }
48 
49         return buffer;
50     }
51 
52     /// @notice Appends data to buffer, and update buffer length
53     /// @param buffer the buffer to append the data to
54     /// @param data the data to append
55     /// @dev Does not perform out-of-bound checks (container capacity)
56     ///      for efficiency.
57     function appendUnchecked(bytes memory buffer, bytes memory data) internal pure {
58         assembly {
59             let length := mload(data)
60             for {
61                 data := add(data, 0x20)
62                 let dataEnd := add(data, length)
63                 let copyTo := add(buffer, add(mload(buffer), 0x20))
64             } lt(data, dataEnd) {
65                 data := add(data, 0x20)
66                 copyTo := add(copyTo, 0x20)
67             } {
68                 // Copy 32B chunks from data to buffer.
69                 // This may read over data array boundaries and copy invalid
70                 // bytes, which doesn't matter in the end since we will
71                 // later set the correct buffer length, and have allocated an
72                 // additional word to avoid buffer overflow.
73                 mstore(copyTo, mload(data))
74             }
75 
76             // Update buffer length
77             mstore(buffer, add(mload(buffer), length))
78         }
79     }
80 
81     /// @notice Appends data to buffer, and update buffer length
82     /// @param buffer the buffer to append the data to
83     /// @param data the data to append
84     /// @dev Performs out-of-bound checks and calls `appendUnchecked`.
85     function appendSafe(bytes memory buffer, bytes memory data) internal pure {
86         uint256 capacity;
87         uint256 length;
88         assembly {
89             capacity := sub(mload(sub(buffer, 0x20)), 0x40)
90             length := mload(buffer)
91         }
92 
93         require(length + data.length <= capacity, "DynamicBuffer: Appending out of bounds.");
94         appendUnchecked(buffer, data);
95     }
96 }
97 
98 pragma solidity >=0.6.0;
99 
100 /// @title Base64
101 /// @author Brecht Devos - <brecht@loopring.org>
102 /// @notice Provides functions for encoding/decoding base64
103 library Base64 {
104     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
105     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
106                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
107                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
108                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
109 
110     function encode(bytes memory data) internal pure returns (string memory) {
111         if (data.length == 0) return '';
112 
113         // load the table into memory
114         string memory table = TABLE_ENCODE;
115 
116         // multiply by 4/3 rounded up
117         uint256 encodedLen = 4 * ((data.length + 2) / 3);
118 
119         // add some extra buffer at the end required for the writing
120         string memory result = new string(encodedLen + 32);
121 
122         assembly {
123             // set the actual output length
124             mstore(result, encodedLen)
125 
126             // prepare the lookup table
127             let tablePtr := add(table, 1)
128 
129             // input ptr
130             let dataPtr := data
131             let endPtr := add(dataPtr, mload(data))
132 
133             // result ptr, jump over length
134             let resultPtr := add(result, 32)
135 
136             // run over the input, 3 bytes at a time
137             for {} lt(dataPtr, endPtr) {}
138             {
139                 // read 3 bytes
140                 dataPtr := add(dataPtr, 3)
141                 let input := mload(dataPtr)
142 
143                 // write 4 characters
144                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
145                 resultPtr := add(resultPtr, 1)
146                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
147                 resultPtr := add(resultPtr, 1)
148                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
149                 resultPtr := add(resultPtr, 1)
150                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
151                 resultPtr := add(resultPtr, 1)
152             }
153 
154             // padding with '='
155             switch mod(mload(data), 3)
156             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
157             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
158         }
159 
160         return result;
161     }
162 
163     function decode(string memory _data) internal pure returns (bytes memory) {
164         bytes memory data = bytes(_data);
165 
166         if (data.length == 0) return new bytes(0);
167         require(data.length % 4 == 0, "invalid base64 decoder input");
168 
169         // load the table into memory
170         bytes memory table = TABLE_DECODE;
171 
172         // every 4 characters represent 3 bytes
173         uint256 decodedLen = (data.length / 4) * 3;
174 
175         // add some extra buffer at the end required for the writing
176         bytes memory result = new bytes(decodedLen + 32);
177 
178         assembly {
179             // padding with '='
180             let lastBytes := mload(add(data, mload(data)))
181             if eq(and(lastBytes, 0xFF), 0x3d) {
182                 decodedLen := sub(decodedLen, 1)
183                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
184                     decodedLen := sub(decodedLen, 1)
185                 }
186             }
187 
188             // set the actual output length
189             mstore(result, decodedLen)
190 
191             // prepare the lookup table
192             let tablePtr := add(table, 1)
193 
194             // input ptr
195             let dataPtr := data
196             let endPtr := add(dataPtr, mload(data))
197 
198             // result ptr, jump over length
199             let resultPtr := add(result, 32)
200 
201             // run over the input, 4 characters at a time
202             for {} lt(dataPtr, endPtr) {}
203             {
204                // read 4 characters
205                dataPtr := add(dataPtr, 4)
206                let input := mload(dataPtr)
207 
208                // write 3 bytes
209                let output := add(
210                    add(
211                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
212                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
213                    add(
214                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
215                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
216                     )
217                 )
218                 mstore(resultPtr, shl(232, output))
219                 resultPtr := add(resultPtr, 3)
220             }
221         }
222 
223         return result;
224     }
225 }
226 
227 pragma solidity >=0.5.0;
228 
229 interface ILayerZeroUserApplicationConfig {
230     // @notice set the configuration of the LayerZero messaging library of the specified version
231     // @param _version - messaging library version
232     // @param _chainId - the chainId for the pending config change
233     // @param _configType - type of configuration. every messaging library has its own convention.
234     // @param _config - configuration in the bytes. can encode arbitrary content.
235     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
236 
237     // @notice set the send() LayerZero messaging library version to _version
238     // @param _version - new messaging library version
239     function setSendVersion(uint16 _version) external;
240 
241     // @notice set the lzReceive() LayerZero messaging library version to _version
242     // @param _version - new messaging library version
243     function setReceiveVersion(uint16 _version) external;
244 
245     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
246     // @param _srcChainId - the chainId of the source chain
247     // @param _srcAddress - the contract address of the source contract at the source chain
248     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
249 }
250 
251 // File: contracts/interfaces/ILayerZeroEndpoint.sol
252 
253 pragma solidity >=0.5.0;
254 
255 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
256     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
257     // @param _dstChainId - the destination chain identifier
258     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
259     // @param _payload - a custom bytes payload to send to the destination contract
260     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
261     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
262     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
263     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
264 
265     // @notice used by the messaging library to publish verified payload
266     // @param _srcChainId - the source chain identifier
267     // @param _srcAddress - the source contract (as bytes) at the source chain
268     // @param _dstAddress - the address on destination chain
269     // @param _nonce - the unbound message ordering nonce
270     // @param _gasLimit - the gas limit for external contract execution
271     // @param _payload - verified payload to send to the destination contract
272     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
273 
274     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
275     // @param _srcChainId - the source chain identifier
276     // @param _srcAddress - the source chain contract address
277     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
278 
279     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
280     // @param _srcAddress - the source chain contract address
281     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
282 
283     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
284     // @param _dstChainId - the destination chain identifier
285     // @param _userApplication - the user app address on this EVM chain
286     // @param _payload - the custom message to send over LayerZero
287     // @param _payInZRO - if false, user app pays the protocol fee in native token
288     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
289     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
290 
291     // @notice get this Endpoint's immutable source identifier
292     function getChainId() external view returns (uint16);
293 
294     // @notice the interface to retry failed message on this Endpoint destination
295     // @param _srcChainId - the source chain identifier
296     // @param _srcAddress - the source chain contract address
297     // @param _payload - the payload to be retried
298     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
299 
300     // @notice query if any STORED payload (message blocking) at the endpoint.
301     // @param _srcChainId - the source chain identifier
302     // @param _srcAddress - the source chain contract address
303     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
304 
305     // @notice query if the _libraryAddress is valid for sending msgs.
306     // @param _userApplication - the user app address on this EVM chain
307     function getSendLibraryAddress(address _userApplication) external view returns (address);
308 
309     // @notice query if the _libraryAddress is valid for receiving msgs.
310     // @param _userApplication - the user app address on this EVM chain
311     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
312 
313     // @notice query if the non-reentrancy guard for send() is on
314     // @return true if the guard is on. false otherwise
315     function isSendingPayload() external view returns (bool);
316 
317     // @notice query if the non-reentrancy guard for receive() is on
318     // @return true if the guard is on. false otherwise
319     function isReceivingPayload() external view returns (bool);
320 
321     // @notice get the configuration of the LayerZero messaging library of the specified version
322     // @param _version - messaging library version
323     // @param _chainId - the chainId for the pending config change
324     // @param _userApplication - the contract address of the user application
325     // @param _configType - type of configuration. every messaging library has its own convention.
326     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
327 
328     // @notice get the send() LayerZero messaging library version
329     // @param _userApplication - the contract address of the user application
330     function getSendVersion(address _userApplication) external view returns (uint16);
331 
332     // @notice get the lzReceive() LayerZero messaging library version
333     // @param _userApplication - the contract address of the user application
334     function getReceiveVersion(address _userApplication) external view returns (uint16);
335 }
336 
337 // File: contracts/interfaces/ILayerZeroReceiver.sol
338 
339 pragma solidity >=0.5.0;
340 
341 interface ILayerZeroReceiver {
342     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
343     // @param _srcChainId - the source endpoint identifier
344     // @param _srcAddress - the source sending contract address from the source chain
345     // @param _nonce - the ordered message nonce
346     // @param _payload - the signed payload is the UA bytes has encoded to be sent
347     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
348 }
349 // File: @openzeppelin/contracts/utils/Strings.sol
350 
351 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @dev String operations.
357  */
358 library Strings {
359     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
360 
361     /**
362      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
363      */
364     function toString(uint256 value) internal pure returns (string memory) {
365         // Inspired by OraclizeAPI's implementation - MIT licence
366         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
367 
368         if (value == 0) {
369             return "0";
370         }
371         uint256 temp = value;
372         uint256 digits;
373         while (temp != 0) {
374             digits++;
375             temp /= 10;
376         }
377         bytes memory buffer = new bytes(digits);
378         while (value != 0) {
379             digits -= 1;
380             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
381             value /= 10;
382         }
383         return string(buffer);
384     }
385 
386     /**
387      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
388      */
389     function toHexString(uint256 value) internal pure returns (string memory) {
390         if (value == 0) {
391             return "0x00";
392         }
393         uint256 temp = value;
394         uint256 length = 0;
395         while (temp != 0) {
396             length++;
397             temp >>= 8;
398         }
399         return toHexString(value, length);
400     }
401 
402     /**
403      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
404      */
405     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
406         bytes memory buffer = new bytes(2 * length + 2);
407         buffer[0] = "0";
408         buffer[1] = "x";
409         for (uint256 i = 2 * length + 1; i > 1; --i) {
410             buffer[i] = _HEX_SYMBOLS[value & 0xf];
411             value >>= 4;
412         }
413         require(value == 0, "Strings: hex length insufficient");
414         return string(buffer);
415     }
416 }
417 
418 // File: @openzeppelin/contracts/utils/Context.sol
419 
420 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @dev Provides information about the current execution context, including the
426  * sender of the transaction and its data. While these are generally available
427  * via msg.sender and msg.data, they should not be accessed in such a direct
428  * manner, since when dealing with meta-transactions the account sending and
429  * paying for execution may not be the actual sender (as far as an application
430  * is concerned).
431  *
432  * This contract is only required for intermediate, library-like contracts.
433  */
434 abstract contract Context {
435     function _msgSender() internal view virtual returns (address) {
436         return msg.sender;
437     }
438 
439     function _msgData() internal view virtual returns (bytes calldata) {
440         return msg.data;
441     }
442 }
443 
444 // File: @openzeppelin/contracts/access/Ownable.sol
445 
446 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev Contract module which provides a basic access control mechanism, where
452  * there is an account (an owner) that can be granted exclusive access to
453  * specific functions.
454  *
455  * By default, the owner account will be the one that deploys the contract. This
456  * can later be changed with {transferOwnership}.
457  *
458  * This module is used through inheritance. It will make available the modifier
459  * `onlyOwner`, which can be applied to your functions to restrict their use to
460  * the owner.
461  */
462 abstract contract Ownable is Context {
463     address private _owner;
464 
465     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
466 
467     /**
468      * @dev Initializes the contract setting the deployer as the initial owner.
469      */
470     constructor() {
471         _transferOwnership(_msgSender());
472     }
473 
474     /**
475      * @dev Returns the address of the current owner.
476      */
477     function owner() public view virtual returns (address) {
478         return _owner;
479     }
480 
481     /**
482      * @dev Throws if called by any account other than the owner.
483      */
484     modifier onlyOwner() {
485         require(owner() == _msgSender(), "Ownable: caller is not the owner");
486         _;
487     }
488 
489     /**
490      * @dev Leaves the contract without owner. It will not be possible to call
491      * `onlyOwner` functions anymore. Can only be called by the current owner.
492      *
493      * NOTE: Renouncing ownership will leave the contract without an owner,
494      * thereby removing any functionality that is only available to the owner.
495      */
496     function renounceOwnership() public virtual onlyOwner {
497         _transferOwnership(address(0));
498     }
499 
500     /**
501      * @dev Transfers ownership of the contract to a new account (`newOwner`).
502      * Can only be called by the current owner.
503      */
504     function transferOwnership(address newOwner) public virtual onlyOwner {
505         require(newOwner != address(0), "Ownable: new owner is the zero address");
506         _transferOwnership(newOwner);
507     }
508 
509     /**
510      * @dev Transfers ownership of the contract to a new account (`newOwner`).
511      * Internal function without access restriction.
512      */
513     function _transferOwnership(address newOwner) internal virtual {
514         address oldOwner = _owner;
515         _owner = newOwner;
516         emit OwnershipTransferred(oldOwner, newOwner);
517     }
518 }
519 
520 // File: @openzeppelin/contracts/utils/Address.sol
521 
522 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev Collection of functions related to the address type
528  */
529 library Address {
530     /**
531      * @dev Returns true if `account` is a contract.
532      *
533      * [IMPORTANT]
534      * ====
535      * It is unsafe to assume that an address for which this function returns
536      * false is an externally-owned account (EOA) and not a contract.
537      *
538      * Among others, `isContract` will return false for the following
539      * types of addresses:
540      *
541      *  - an externally-owned account
542      *  - a contract in construction
543      *  - an address where a contract will be created
544      *  - an address where a contract lived, but was destroyed
545      * ====
546      */
547     function isContract(address account) internal view returns (bool) {
548         // This method relies on extcodesize, which returns 0 for contracts in
549         // construction, since the code is only stored at the end of the
550         // constructor execution.
551 
552         uint256 size;
553         assembly {
554             size := extcodesize(account)
555         }
556         return size > 0;
557     }
558 
559     /**
560      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
561      * `recipient`, forwarding all available gas and reverting on errors.
562      *
563      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
564      * of certain opcodes, possibly making contracts go over the 2300 gas limit
565      * imposed by `transfer`, making them unable to receive funds via
566      * `transfer`. {sendValue} removes this limitation.
567      *
568      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
569      *
570      * IMPORTANT: because control is transferred to `recipient`, care must be
571      * taken to not create reentrancy vulnerabilities. Consider using
572      * {ReentrancyGuard} or the
573      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
574      */
575     function sendValue(address payable recipient, uint256 amount) internal {
576         require(address(this).balance >= amount, "Address: insufficient balance");
577 
578         (bool success, ) = recipient.call{value: amount}("");
579         require(success, "Address: unable to send value, recipient may have reverted");
580     }
581 
582     /**
583      * @dev Performs a Solidity function call using a low level `call`. A
584      * plain `call` is an unsafe replacement for a function call: use this
585      * function instead.
586      *
587      * If `target` reverts with a revert reason, it is bubbled up by this
588      * function (like regular Solidity function calls).
589      *
590      * Returns the raw returned data. To convert to the expected return value,
591      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
592      *
593      * Requirements:
594      *
595      * - `target` must be a contract.
596      * - calling `target` with `data` must not revert.
597      *
598      * _Available since v3.1._
599      */
600     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
601         return functionCall(target, data, "Address: low-level call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
606      * `errorMessage` as a fallback revert reason when `target` reverts.
607      *
608      * _Available since v3.1._
609      */
610     function functionCall(
611         address target,
612         bytes memory data,
613         string memory errorMessage
614     ) internal returns (bytes memory) {
615         return functionCallWithValue(target, data, 0, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but also transferring `value` wei to `target`.
621      *
622      * Requirements:
623      *
624      * - the calling contract must have an ETH balance of at least `value`.
625      * - the called Solidity function must be `payable`.
626      *
627      * _Available since v3.1._
628      */
629     function functionCallWithValue(
630         address target,
631         bytes memory data,
632         uint256 value
633     ) internal returns (bytes memory) {
634         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
639      * with `errorMessage` as a fallback revert reason when `target` reverts.
640      *
641      * _Available since v3.1._
642      */
643     function functionCallWithValue(
644         address target,
645         bytes memory data,
646         uint256 value,
647         string memory errorMessage
648     ) internal returns (bytes memory) {
649         require(address(this).balance >= value, "Address: insufficient balance for call");
650         require(isContract(target), "Address: call to non-contract");
651 
652         (bool success, bytes memory returndata) = target.call{value: value}(data);
653         return verifyCallResult(success, returndata, errorMessage);
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
658      * but performing a static call.
659      *
660      * _Available since v3.3._
661      */
662     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
663         return functionStaticCall(target, data, "Address: low-level static call failed");
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
668      * but performing a static call.
669      *
670      * _Available since v3.3._
671      */
672     function functionStaticCall(
673         address target,
674         bytes memory data,
675         string memory errorMessage
676     ) internal view returns (bytes memory) {
677         require(isContract(target), "Address: static call to non-contract");
678 
679         (bool success, bytes memory returndata) = target.staticcall(data);
680         return verifyCallResult(success, returndata, errorMessage);
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
685      * but performing a delegate call.
686      *
687      * _Available since v3.4._
688      */
689     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
690         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
695      * but performing a delegate call.
696      *
697      * _Available since v3.4._
698      */
699     function functionDelegateCall(
700         address target,
701         bytes memory data,
702         string memory errorMessage
703     ) internal returns (bytes memory) {
704         require(isContract(target), "Address: delegate call to non-contract");
705 
706         (bool success, bytes memory returndata) = target.delegatecall(data);
707         return verifyCallResult(success, returndata, errorMessage);
708     }
709 
710     /**
711      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
712      * revert reason using the provided one.
713      *
714      * _Available since v4.3._
715      */
716     function verifyCallResult(
717         bool success,
718         bytes memory returndata,
719         string memory errorMessage
720     ) internal pure returns (bytes memory) {
721         if (success) {
722             return returndata;
723         } else {
724             // Look for revert reason and bubble it up if present
725             if (returndata.length > 0) {
726                 // The easiest way to bubble the revert reason is using memory via assembly
727 
728                 assembly {
729                     let returndata_size := mload(returndata)
730                     revert(add(32, returndata), returndata_size)
731                 }
732             } else {
733                 revert(errorMessage);
734             }
735         }
736     }
737 }
738 
739 pragma solidity ^0.8.0;
740 
741 /**
742  * @dev These functions deal with verification of Merkle Trees proofs.
743  *
744  * The proofs can be generated using the JavaScript library
745  * https://github.com/miguelmota/merkletreejs[merkletreejs].
746  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
747  *
748  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
749  */
750 library MerkleProof {
751     /**
752      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
753      * defined by `root`. For this, a `proof` must be provided, containing
754      * sibling hashes on the branch from the leaf to the root of the tree. Each
755      * pair of leaves and each pair of pre-images are assumed to be sorted.
756      */
757     function verify(
758         bytes32[] memory proof,
759         bytes32 root,
760         bytes32 leaf
761     ) internal pure returns (bool) {
762         bytes32 computedHash = leaf;
763 
764         for (uint256 i = 0; i < proof.length; i++) {
765             bytes32 proofElement = proof[i];
766 
767             if (computedHash <= proofElement) {
768                 // Hash(current computed hash + current element of the proof)
769                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
770             } else {
771                 // Hash(current element of the proof + current computed hash)
772                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
773             }
774         }
775 
776         // Check if the computed hash (root) is equal to the provided root
777         return computedHash == root;
778     }
779 }
780 
781 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
782 
783 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 /**
788  * @title ERC721 token receiver interface
789  * @dev Interface for any contract that wants to support safeTransfers
790  * from ERC721 asset contracts.
791  */
792 interface IERC721Receiver {
793     /**
794      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
795      * by `operator` from `from`, this function is called.
796      *
797      * It must return its Solidity selector to confirm the token transfer.
798      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
799      *
800      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
801      */
802     function onERC721Received(
803         address operator,
804         address from,
805         uint256 tokenId,
806         bytes calldata data
807     ) external returns (bytes4);
808 }
809 
810 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
811 
812 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
813 
814 pragma solidity ^0.8.0;
815 
816 /**
817  * @dev Interface of the ERC165 standard, as defined in the
818  * https://eips.ethereum.org/EIPS/eip-165[EIP].
819  *
820  * Implementers can declare support of contract interfaces, which can then be
821  * queried by others ({ERC165Checker}).
822  *
823  * For an implementation, see {ERC165}.
824  */
825 interface IERC165 {
826     /**
827      * @dev Returns true if this contract implements the interface defined by
828      * `interfaceId`. See the corresponding
829      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
830      * to learn more about how these ids are created.
831      *
832      * This function call must use less than 30 000 gas.
833      */
834     function supportsInterface(bytes4 interfaceId) external view returns (bool);
835 }
836 
837 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
838 
839 
840 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
841 
842 pragma solidity ^0.8.0;
843 
844 /**
845  * @dev Implementation of the {IERC165} interface.
846  *
847  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
848  * for the additional interface id that will be supported. For example:
849  *
850  * ```solidity
851  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
852  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
853  * }
854  * ```
855  *
856  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
857  */
858 abstract contract ERC165 is IERC165 {
859     /**
860      * @dev See {IERC165-supportsInterface}.
861      */
862     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
863         return interfaceId == type(IERC165).interfaceId;
864     }
865 }
866 
867 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
868 
869 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
870 
871 pragma solidity ^0.8.0;
872 
873 /**
874  * @dev Required interface of an ERC721 compliant contract.
875  */
876 interface IERC721 is IERC165 {
877     /**
878      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
879      */
880     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
881 
882     /**
883      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
884      */
885     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
886 
887     /**
888      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
889      */
890     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
891 
892     /**
893      * @dev Returns the number of tokens in ``owner``'s account.
894      */
895     function balanceOf(address owner) external view returns (uint256 balance);
896 
897     /**
898      * @dev Returns the owner of the `tokenId` token.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must exist.
903      */
904     function ownerOf(uint256 tokenId) external view returns (address owner);
905 
906     /**
907      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
908      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must exist and be owned by `from`.
915      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) external;
925 
926     /**
927      * @dev Transfers `tokenId` token from `from` to `to`.
928      *
929      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
930      *
931      * Requirements:
932      *
933      * - `from` cannot be the zero address.
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must be owned by `from`.
936      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
937      *
938      * Emits a {Transfer} event.
939      */
940     function transferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) external;
945 
946     /**
947      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
948      * The approval is cleared when the token is transferred.
949      *
950      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
951      *
952      * Requirements:
953      *
954      * - The caller must own the token or be an approved operator.
955      * - `tokenId` must exist.
956      *
957      * Emits an {Approval} event.
958      */
959     function approve(address to, uint256 tokenId) external;
960 
961     /**
962      * @dev Returns the account approved for `tokenId` token.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must exist.
967      */
968     function getApproved(uint256 tokenId) external view returns (address operator);
969 
970     /**
971      * @dev Approve or remove `operator` as an operator for the caller.
972      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
973      *
974      * Requirements:
975      *
976      * - The `operator` cannot be the caller.
977      *
978      * Emits an {ApprovalForAll} event.
979      */
980     function setApprovalForAll(address operator, bool _approved) external;
981 
982     /**
983      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
984      *
985      * See {setApprovalForAll}
986      */
987     function isApprovedForAll(address owner, address operator) external view returns (bool);
988 
989     /**
990      * @dev Safely transfers `tokenId` token from `from` to `to`.
991      *
992      * Requirements:
993      *
994      * - `from` cannot be the zero address.
995      * - `to` cannot be the zero address.
996      * - `tokenId` token must exist and be owned by `from`.
997      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
998      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function safeTransferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId,
1006         bytes calldata data
1007     ) external;
1008 }
1009 
1010 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1011 
1012 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 /**
1017  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1018  * @dev See https://eips.ethereum.org/EIPS/eip-721
1019  */
1020 interface IERC721Metadata is IERC721 {
1021     /**
1022      * @dev Returns the token collection name.
1023      */
1024     function name() external view returns (string memory);
1025 
1026     /**
1027      * @dev Returns the token collection symbol.
1028      */
1029     function symbol() external view returns (string memory);
1030 
1031     /**
1032      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1033      */
1034     function tokenURI(uint256 tokenId) external view returns (string memory);
1035 }
1036 
1037 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1038 
1039 
1040 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 /**
1045  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1046  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1047  * {ERC721Enumerable}.
1048  */
1049 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1050     using Address for address;
1051     using Strings for uint256;
1052 
1053     // Token name
1054     string private _name;
1055 
1056     // Token symbol
1057     string private _symbol;
1058 
1059     // Mapping from token ID to owner address
1060     mapping(uint256 => address) private _owners;
1061 
1062     // Mapping owner address to token count
1063     mapping(address => uint256) private _balances;
1064 
1065     // Mapping from token ID to approved address
1066     mapping(uint256 => address) private _tokenApprovals;
1067 
1068     // Mapping from owner to operator approvals
1069     mapping(address => mapping(address => bool)) private _operatorApprovals;
1070 
1071     /**
1072      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1073      */
1074     constructor(string memory name_, string memory symbol_) {
1075         _name = name_;
1076         _symbol = symbol_;
1077     }
1078 
1079     /**
1080      * @dev See {IERC165-supportsInterface}.
1081      */
1082     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1083         return
1084             interfaceId == type(IERC721).interfaceId ||
1085             interfaceId == type(IERC721Metadata).interfaceId ||
1086             super.supportsInterface(interfaceId);
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-balanceOf}.
1091      */
1092     function balanceOf(address owner) public view virtual override returns (uint256) {
1093         require(owner != address(0), "ERC721: balance query for the zero address");
1094         return _balances[owner];
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-ownerOf}.
1099      */
1100     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1101         address owner = _owners[tokenId];
1102         require(owner != address(0), "ERC721: owner query for nonexistent token");
1103         return owner;
1104     }
1105 
1106     /**
1107      * @dev See {IERC721Metadata-name}.
1108      */
1109     function name() public view virtual override returns (string memory) {
1110         return _name;
1111     }
1112 
1113     /**
1114      * @dev See {IERC721Metadata-symbol}.
1115      */
1116     function symbol() public view virtual override returns (string memory) {
1117         return _symbol;
1118     }
1119 
1120     /**
1121      * @dev See {IERC721Metadata-tokenURI}.
1122      */
1123     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1124         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1125 
1126         string memory baseURI = _baseURI();
1127         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1128     }
1129 
1130     /**
1131      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1132      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1133      * by default, can be overriden in child contracts.
1134      */
1135     function _baseURI() internal view virtual returns (string memory) {
1136         return "";
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-approve}.
1141      */
1142     function approve(address to, uint256 tokenId) public virtual override {
1143         address owner = ERC721.ownerOf(tokenId);
1144         require(to != owner, "ERC721: approval to current owner");
1145 
1146         require(
1147             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1148             "ERC721: approve caller is not owner nor approved for all"
1149         );
1150 
1151         _approve(to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-getApproved}.
1156      */
1157     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1158         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1159 
1160         return _tokenApprovals[tokenId];
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-setApprovalForAll}.
1165      */
1166     function setApprovalForAll(address operator, bool approved) public virtual override {
1167         _setApprovalForAll(_msgSender(), operator, approved);
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-isApprovedForAll}.
1172      */
1173     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1174         return _operatorApprovals[owner][operator];
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-transferFrom}.
1179      */
1180     function transferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) public virtual override {
1185         //solhint-disable-next-line max-line-length
1186         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1187 
1188         _transfer(from, to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-safeTransferFrom}.
1193      */
1194     function safeTransferFrom(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) public virtual override {
1199         safeTransferFrom(from, to, tokenId, "");
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-safeTransferFrom}.
1204      */
1205     function safeTransferFrom(
1206         address from,
1207         address to,
1208         uint256 tokenId,
1209         bytes memory _data
1210     ) public virtual override {
1211         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1212         _safeTransfer(from, to, tokenId, _data);
1213     }
1214 
1215     /**
1216      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1217      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1218      *
1219      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1220      *
1221      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1222      * implement alternative mechanisms to perform token transfer, such as signature-based.
1223      *
1224      * Requirements:
1225      *
1226      * - `from` cannot be the zero address.
1227      * - `to` cannot be the zero address.
1228      * - `tokenId` token must exist and be owned by `from`.
1229      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _safeTransfer(
1234         address from,
1235         address to,
1236         uint256 tokenId,
1237         bytes memory _data
1238     ) internal virtual {
1239         _transfer(from, to, tokenId);
1240         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1241     }
1242 
1243     /**
1244      * @dev Returns whether `tokenId` exists.
1245      *
1246      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1247      *
1248      * Tokens start existing when they are minted (`_mint`),
1249      * and stop existing when they are burned (`_burn`).
1250      */
1251     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1252         return _owners[tokenId] != address(0);
1253     }
1254 
1255     /**
1256      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1257      *
1258      * Requirements:
1259      *
1260      * - `tokenId` must exist.
1261      */
1262     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1263         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1264         address owner = ERC721.ownerOf(tokenId);
1265         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1266     }
1267 
1268     /**
1269      * @dev Safely mints `tokenId` and transfers it to `to`.
1270      *
1271      * Requirements:
1272      *
1273      * - `tokenId` must not exist.
1274      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1275      *
1276      * Emits a {Transfer} event.
1277      */
1278     function _safeMint(address to, uint256 tokenId) internal virtual {
1279         _safeMint(to, tokenId, "");
1280     }
1281 
1282     /**
1283      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1284      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1285      */
1286     function _safeMint(
1287         address to,
1288         uint256 tokenId,
1289         bytes memory _data
1290     ) internal virtual {
1291         _mint(to, tokenId);
1292         require(
1293             _checkOnERC721Received(address(0), to, tokenId, _data),
1294             "ERC721: transfer to non ERC721Receiver implementer"
1295         );
1296     }
1297 
1298     /**
1299      * @dev Mints `tokenId` and transfers it to `to`.
1300      *
1301      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1302      *
1303      * Requirements:
1304      *
1305      * - `tokenId` must not exist.
1306      * - `to` cannot be the zero address.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function _mint(address to, uint256 tokenId) internal virtual {
1311         require(to != address(0), "ERC721: mint to the zero address");
1312 
1313         _beforeTokenTransfer(address(0), to, tokenId);
1314 
1315         _balances[to] += 1;
1316         _owners[tokenId] = to;
1317 
1318         emit Transfer(address(0), to, tokenId);
1319     }
1320 
1321     /**
1322      * @dev Destroys `tokenId`.
1323      * The approval is cleared when the token is burned.
1324      *
1325      * Requirements:
1326      *
1327      * - `tokenId` must exist.
1328      *
1329      * Emits a {Transfer} event.
1330      */
1331     function _burn(uint256 tokenId) internal virtual {
1332         address owner = ERC721.ownerOf(tokenId);
1333 
1334         _beforeTokenTransfer(owner, address(0), tokenId);
1335 
1336         // Clear approvals
1337         _approve(address(0), tokenId);
1338 
1339         _balances[owner] -= 1;
1340         delete _owners[tokenId];
1341 
1342         emit Transfer(owner, address(0), tokenId);
1343     }
1344 
1345     /**
1346      * @dev Transfers `tokenId` from `from` to `to`.
1347      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1348      *
1349      * Requirements:
1350      *
1351      * - `to` cannot be the zero address.
1352      * - `tokenId` token must be owned by `from`.
1353      *
1354      * Emits a {Transfer} event.
1355      */
1356     function _transfer(
1357         address from,
1358         address to,
1359         uint256 tokenId
1360     ) internal virtual {
1361         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1362         require(to != address(0), "ERC721: transfer to the zero address");
1363 
1364         _beforeTokenTransfer(from, to, tokenId);
1365 
1366         // Clear approvals from the previous owner
1367         _approve(address(0), tokenId);
1368 
1369         _balances[from] -= 1;
1370         _balances[to] += 1;
1371         _owners[tokenId] = to;
1372 
1373         emit Transfer(from, to, tokenId);
1374     }
1375 
1376     /**
1377      * @dev Approve `to` to operate on `tokenId`
1378      *
1379      * Emits a {Approval} event.
1380      */
1381     function _approve(address to, uint256 tokenId) internal virtual {
1382         _tokenApprovals[tokenId] = to;
1383         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1384     }
1385 
1386     /**
1387      * @dev Approve `operator` to operate on all of `owner` tokens
1388      *
1389      * Emits a {ApprovalForAll} event.
1390      */
1391     function _setApprovalForAll(
1392         address owner,
1393         address operator,
1394         bool approved
1395     ) internal virtual {
1396         require(owner != operator, "ERC721: approve to caller");
1397         _operatorApprovals[owner][operator] = approved;
1398         emit ApprovalForAll(owner, operator, approved);
1399     }
1400 
1401     /**
1402      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1403      * The call is not executed if the target address is not a contract.
1404      *
1405      * @param from address representing the previous owner of the given token ID
1406      * @param to target address that will receive the tokens
1407      * @param tokenId uint256 ID of the token to be transferred
1408      * @param _data bytes optional data to send along with the call
1409      * @return bool whether the call correctly returned the expected magic value
1410      */
1411     function _checkOnERC721Received(
1412         address from,
1413         address to,
1414         uint256 tokenId,
1415         bytes memory _data
1416     ) private returns (bool) {
1417         if (to.isContract()) {
1418             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1419                 return retval == IERC721Receiver.onERC721Received.selector;
1420             } catch (bytes memory reason) {
1421                 if (reason.length == 0) {
1422                     revert("ERC721: transfer to non ERC721Receiver implementer");
1423                 } else {
1424                     assembly {
1425                         revert(add(32, reason), mload(reason))
1426                     }
1427                 }
1428             }
1429         } else {
1430             return true;
1431         }
1432     }
1433 
1434     /**
1435      * @dev Hook that is called before any token transfer. This includes minting
1436      * and burning.
1437      *
1438      * Calling conditions:
1439      *
1440      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1441      * transferred to `to`.
1442      * - When `from` is zero, `tokenId` will be minted for `to`.
1443      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1444      * - `from` and `to` are never both zero.
1445      *
1446      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1447      */
1448     function _beforeTokenTransfer(
1449         address from,
1450         address to,
1451         uint256 tokenId
1452     ) internal virtual {}
1453 }
1454 
1455 // File: contracts/NonblockingReceiver.sol
1456 
1457 pragma solidity ^0.8.6;
1458 
1459 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1460 
1461     ILayerZeroEndpoint internal endpoint;
1462 
1463     struct FailedMessages {
1464         uint payloadLength;
1465         bytes32 payloadHash;
1466     }
1467 
1468     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
1469     mapping(uint16 => bytes) public trustedRemoteLookup;
1470 
1471     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
1472 
1473     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
1474         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1475         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]),
1476             "NonblockingReceiver: invalid source sending contract");
1477 
1478         // try-catch all errors/exceptions
1479         // having failed messages does not block messages passing
1480         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1481             // do nothing
1482         } catch {
1483             // error / exception
1484             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
1485             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1486         }
1487     }
1488 
1489     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
1490         // only internal transaction
1491         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
1492 
1493         // handle incoming message
1494         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
1495     }
1496 
1497     // abstract function
1498     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal virtual;
1499 
1500     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
1501         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
1502     }
1503 
1504     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
1505         // assert there is message to retry
1506         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
1507         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
1508         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
1509         // clear the stored message
1510         failedMsg.payloadLength = 0;
1511         failedMsg.payloadHash = bytes32(0);
1512         // execute the message. revert if it fails again
1513         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1514     }
1515 
1516     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
1517         trustedRemoteLookup[_chainId] = _trustedRemote;
1518     }
1519 }
1520 
1521 // File: contracts/METAKAYS.sol
1522 
1523 pragma solidity ^0.8.7;
1524 
1525 interface IFeatures1 {
1526   function readMisc(uint256 _id) external view returns (string memory);
1527 }
1528 
1529 contract METAKAYS is Ownable, ERC721, NonblockingReceiver {
1530 
1531     using DynamicBuffer for bytes;
1532     event Kustomized(uint256 _itemID);
1533 
1534     struct Features {
1535       uint256 data1;
1536       uint256 data2;
1537       uint256[4] colors;
1538       uint256[3] colorSelectors;
1539     }
1540 
1541     IFeatures1 features1;
1542     address public _owner;
1543     uint256 nextTokenId = 0;
1544     uint256 MAX_MINT_ETHEREUM = 8888;
1545 
1546     uint gasForDestinationLzReceive = 350000;
1547 
1548     bytes32 public _merkleRoot;
1549 
1550     mapping(uint256 => Features) public features;
1551     mapping (uint256 => string) public svgData;
1552     mapping (uint256 => string) public svgBackgroundColor;
1553     mapping (uint256 => uint256) public svgBackgroundColorSelector;
1554     mapping (uint256 => bool) public finality;
1555     mapping (string => bool) public taken;
1556     mapping (address => bool) public whitelistClaimed;
1557 
1558 
1559     constructor() ERC721("METAKAYS", "MK") {
1560         _owner = msg.sender;
1561         endpoint = ILayerZeroEndpoint(0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675);
1562 
1563         svgBackgroundColor[0] = '#800000"/>';
1564         svgBackgroundColor[1] = '#8B0000"/>';
1565         svgBackgroundColor[2] = '#A52A2A"/>';
1566         svgBackgroundColor[3] = '#B22222"/>';
1567         svgBackgroundColor[4] = '#DC143C"/>';
1568         svgBackgroundColor[5] = '#FF0000"/>';
1569         svgBackgroundColor[6] = '#FF6347"/>';
1570         svgBackgroundColor[7] = '#FF7F50"/>';
1571         svgBackgroundColor[8] = '#CD5C5C"/>';
1572         svgBackgroundColor[9] = '#F08080"/>';
1573         svgBackgroundColor[10] = '#E9967A"/>';
1574         svgBackgroundColor[11] = '#FA8072"/>';
1575         svgBackgroundColor[12] = '#FFA07A"/>';
1576         svgBackgroundColor[13] = '#FF4500"/>';
1577         svgBackgroundColor[14] = '#FF8C00"/>';
1578         svgBackgroundColor[15] = '#FFA500"/>';
1579         svgBackgroundColor[16] = '#FFD700"/>';
1580         svgBackgroundColor[17] = '#B8860B"/>';
1581         svgBackgroundColor[18] = '#DAA520"/>';
1582         svgBackgroundColor[19] = '#EEE8AA"/>';
1583         svgBackgroundColor[20] = '#BDB76B"/>';
1584         svgBackgroundColor[21] = '#F0E68C"/>';
1585         svgBackgroundColor[22] = '#808000"/>';
1586         svgBackgroundColor[23] = '#FFFF00"/>';
1587         svgBackgroundColor[24] = '#9ACD32"/>';
1588         svgBackgroundColor[25] = '#556B2F"/>';
1589         svgBackgroundColor[26] = '#6B8E23"/>';
1590         svgBackgroundColor[27] = '#7CFC00"/>';
1591         svgBackgroundColor[28] = '#7FFF00"/>';
1592         svgBackgroundColor[29] = '#ADFF2F"/>';
1593         svgBackgroundColor[30] = '#006400"/>';
1594         svgBackgroundColor[31] = '#008000"/>';
1595         svgBackgroundColor[32] = '#228B22"/>';
1596         svgBackgroundColor[33] = '#00FF00"/>';
1597         svgBackgroundColor[34] = '#32CD32"/>';
1598         svgBackgroundColor[35] = '#90EE90"/>';
1599         svgBackgroundColor[36] = '#98FB98"/>';
1600         svgBackgroundColor[37] = '#8FBC8F"/>';
1601         svgBackgroundColor[38] = '#00FA9A"/>';
1602         svgBackgroundColor[39] = '#00FF7F"/>';
1603         svgBackgroundColor[40] = '#2E8B57"/>';
1604         svgBackgroundColor[41] = '#66CDAA"/>';
1605         svgBackgroundColor[42] = '#3CB371"/>';
1606         svgBackgroundColor[43] = '#20B2AA"/>';
1607         svgBackgroundColor[44] = '#2F4F4F"/>';
1608         svgBackgroundColor[45] = '#008080"/>';
1609         svgBackgroundColor[46] = '#008B8B"/>';
1610         svgBackgroundColor[47] = '#00FFFF"/>';
1611         svgBackgroundColor[48] = '#00FFFF"/>';
1612         svgBackgroundColor[49] = '#E0FFFF"/>';
1613         svgBackgroundColor[50] = '#00CED1"/>';
1614         svgBackgroundColor[51] = '#40E0D0"/>';
1615         svgBackgroundColor[52] = '#48D1CC"/>';
1616         svgBackgroundColor[53] = '#AFEEEE"/>';
1617         svgBackgroundColor[54] = '#7FFFD4"/>';
1618         svgBackgroundColor[55] = '#B0E0E6"/>';
1619         svgBackgroundColor[56] = '#5F9EA0"/>';
1620         svgBackgroundColor[57] = '#4682B4"/>';
1621         svgBackgroundColor[58] = '#6495ED"/>';
1622         svgBackgroundColor[59] = '#00BFFF"/>';
1623         svgBackgroundColor[60] = '#1E90FF"/>';
1624         svgBackgroundColor[61] = '#ADD8E6"/>';
1625         svgBackgroundColor[62] = '#87CEEB"/>';
1626         svgBackgroundColor[63] = '#87CEFA"/>';
1627         svgBackgroundColor[64] = '#191970"/>';
1628         svgBackgroundColor[65] = '#000080"/>';
1629         svgBackgroundColor[66] = '#00008B"/>';
1630         svgBackgroundColor[67] = '#0000CD"/>';
1631         svgBackgroundColor[68] = '#0000FF"/>';
1632         svgBackgroundColor[69] = '#4169E1"/>';
1633         svgBackgroundColor[70] = '#8A2BE2"/>';
1634         svgBackgroundColor[71] = '#4B0082"/>';
1635         svgBackgroundColor[72] = '#483D8B"/>';
1636         svgBackgroundColor[73] = '#6A5ACD"/>';
1637         svgBackgroundColor[74] = '#7B68EE"/>';
1638         svgBackgroundColor[75] = '#9370DB"/>';
1639         svgBackgroundColor[76] = '#8B008B"/>';
1640         svgBackgroundColor[77] = '#9400D3"/>';
1641         svgBackgroundColor[78] = '#9932CC"/>';
1642         svgBackgroundColor[79] = '#BA55D3"/>';
1643         svgBackgroundColor[80] = '#800080"/>';
1644         svgBackgroundColor[81] = '#D8BFD8"/>';
1645         svgBackgroundColor[82] = '#DDA0DD"/>';
1646         svgBackgroundColor[83] = '#EE82EE"/>';
1647         svgBackgroundColor[84] = '#FF00FF"/>';
1648         svgBackgroundColor[85] = '#DA70D6"/>';
1649         svgBackgroundColor[86] = '#C71585"/>';
1650         svgBackgroundColor[87] = '#DB7093"/>';
1651         svgBackgroundColor[88] = '#FF1493"/>';
1652         svgBackgroundColor[89] = '#FF69B4"/>';
1653         svgBackgroundColor[90] = '#FFB6C1"/>';
1654         svgBackgroundColor[91] = '#FFC0CB"/>';
1655         svgBackgroundColor[92] = '#FAEBD7"/>';
1656         svgBackgroundColor[93] = '#F5F5DC"/>';
1657         svgBackgroundColor[94] = '#FFE4C4"/>';
1658         svgBackgroundColor[95] = '#FFEBCD"/>';
1659         svgBackgroundColor[96] = '#F5DEB3"/>';
1660         svgBackgroundColor[97] = '#FFF8DC"/>';
1661         svgBackgroundColor[98] = '#FFFACD"/>';
1662         svgBackgroundColor[99] = '#FAFAD2"/>';
1663         svgBackgroundColor[100] = '#FFFFE0"/>';
1664         svgBackgroundColor[101] = '#8B4513"/>';
1665         svgBackgroundColor[102] = '#A0522D"/>';
1666         svgBackgroundColor[103] = '#D2691E"/>';
1667         svgBackgroundColor[104] = '#CD853F"/>';
1668         svgBackgroundColor[105] = '#F4A460"/>';
1669         svgBackgroundColor[106] = '#DEB887"/>';
1670         svgBackgroundColor[107] = '#D2B48C"/>';
1671         svgBackgroundColor[108] = '#BC8F8F"/>';
1672         svgBackgroundColor[109] = '#FFE4B5"/>';
1673         svgBackgroundColor[110] = '#FFDEAD"/>';
1674         svgBackgroundColor[111] = '#FFDAB9"/>';
1675         svgBackgroundColor[112] = '#FFE4E1"/>';
1676         svgBackgroundColor[113] = '#FFF0F5"/>';
1677         svgBackgroundColor[114] = '#FAF0E6"/>';
1678         svgBackgroundColor[115] = '#FDF5E6"/>';
1679         svgBackgroundColor[116] = '#FFEFD5"/>';
1680         svgBackgroundColor[117] = '#FFF5EE"/>';
1681         svgBackgroundColor[118] = '#F5FFFA"/>';
1682         svgBackgroundColor[119] = '#708090"/>';
1683         svgBackgroundColor[120] = '#778899"/>';
1684         svgBackgroundColor[121] = '#B0C4DE"/>';
1685         svgBackgroundColor[122] = '#E6E6FA"/>';
1686         svgBackgroundColor[123] = '#FFFAF0"/>';
1687         svgBackgroundColor[124] = '#F0F8FF"/>';
1688         svgBackgroundColor[125] = '#F8F8FF"/>';
1689         svgBackgroundColor[126] = '#F0FFF0"/>';
1690         svgBackgroundColor[127] = '#FFFFF0"/>';
1691         svgBackgroundColor[128] = '#F0FFFF"/>';
1692         svgBackgroundColor[129] = '#FFFAFA"/>';
1693         svgBackgroundColor[130] = '#000000"/>';
1694         svgBackgroundColor[131] = '#696969"/>';
1695         svgBackgroundColor[132] = '#808080"/>';
1696         svgBackgroundColor[133] = '#A9A9A9"/>';
1697         svgBackgroundColor[134] = '#C0C0C0"/>';
1698         svgBackgroundColor[135] = '#D3D3D3"/>';
1699         svgBackgroundColor[136] = '#DCDCDC"/>';
1700         svgBackgroundColor[137] = '#FFFFFF"/>';
1701 
1702         svgData[0] = '<use xlink:href="#cube" x="487" y="540';
1703         svgData[1] = '<use xlink:href="#cube" x="543" y="568';
1704         svgData[2] = '<use xlink:href="#cube" x="599" y="596';
1705         svgData[3] = '<use xlink:href="#cube" x="655" y="624';
1706         svgData[4] = '<use xlink:href="#cube" x="711" y="652';
1707         svgData[5] = '<use xlink:href="#cube" x="767" y="680';
1708         svgData[6] = '<use xlink:href="#cube" x="823" y="708';
1709         svgData[7] = '<use xlink:href="#cube" x="879" y="736';
1710         svgData[8] = '<use xlink:href="#cube" x="487" y="468';
1711         svgData[9] = '<use xlink:href="#cube" x="543" y="496';
1712         svgData[10] = '<use xlink:href="#cube" x="599" y="524';
1713         svgData[11] = '<use xlink:href="#cube" x="655" y="552';
1714         svgData[12] = '<use xlink:href="#cube" x="711" y="580';
1715         svgData[13] = '<use xlink:href="#cube" x="767" y="608';
1716         svgData[14] = '<use xlink:href="#cube" x="823" y="636';
1717         svgData[15] = '<use xlink:href="#cube" x="879" y="664';
1718         svgData[16] = '<use xlink:href="#cube" x="487" y="396';
1719         svgData[17] = '<use xlink:href="#cube" x="543" y="424';
1720         svgData[18] = '<use xlink:href="#cube" x="599" y="452';
1721         svgData[19] = '<use xlink:href="#cube" x="655" y="480';
1722         svgData[20] = '<use xlink:href="#cube" x="711" y="508';
1723         svgData[21] = '<use xlink:href="#cube" x="767" y="536';
1724         svgData[22] = '<use xlink:href="#cube" x="823" y="564';
1725         svgData[23] = '<use xlink:href="#cube" x="879" y="592';
1726         svgData[24] = '<use xlink:href="#cube" x="487" y="324';
1727         svgData[25] = '<use xlink:href="#cube" x="543" y="352';
1728         svgData[26] = '<use xlink:href="#cube" x="599" y="380';
1729         svgData[27] = '<use xlink:href="#cube" x="655" y="408';
1730         svgData[28] = '<use xlink:href="#cube" x="711" y="436';
1731         svgData[29] = '<use xlink:href="#cube" x="767" y="464';
1732         svgData[30] = '<use xlink:href="#cube" x="823" y="492';
1733         svgData[31] = '<use xlink:href="#cube" x="879" y="520';
1734         svgData[32] = '<use xlink:href="#cube" x="487" y="252';
1735         svgData[33] = '<use xlink:href="#cube" x="543" y="280';
1736         svgData[34] = '<use xlink:href="#cube" x="599" y="308';
1737         svgData[35] = '<use xlink:href="#cube" x="655" y="336';
1738         svgData[36] = '<use xlink:href="#cube" x="711" y="364';
1739         svgData[37] = '<use xlink:href="#cube" x="767" y="392';
1740         svgData[38] = '<use xlink:href="#cube" x="823" y="420';
1741         svgData[39] = '<use xlink:href="#cube" x="879" y="448';
1742         svgData[40] = '<use xlink:href="#cube" x="487" y="180';
1743         svgData[41] = '<use xlink:href="#cube" x="543" y="208';
1744         svgData[42] = '<use xlink:href="#cube" x="599" y="236';
1745         svgData[43] = '<use xlink:href="#cube" x="655" y="264';
1746         svgData[44] = '<use xlink:href="#cube" x="711" y="292';
1747         svgData[45] = '<use xlink:href="#cube" x="767" y="320';
1748         svgData[46] = '<use xlink:href="#cube" x="823" y="348';
1749         svgData[47] = '<use xlink:href="#cube" x="879" y="376';
1750         svgData[48] = '<use xlink:href="#cube" x="487" y="108';
1751         svgData[49] = '<use xlink:href="#cube" x="543" y="136';
1752         svgData[50] = '<use xlink:href="#cube" x="599" y="164';
1753         svgData[51] = '<use xlink:href="#cube" x="655" y="192';
1754         svgData[52] = '<use xlink:href="#cube" x="711" y="220';
1755         svgData[53] = '<use xlink:href="#cube" x="767" y="248';
1756         svgData[54] = '<use xlink:href="#cube" x="823" y="276';
1757         svgData[55] = '<use xlink:href="#cube" x="879" y="304';
1758         svgData[56] = '<use xlink:href="#cube" x="487" y="36';
1759         svgData[57] = '<use xlink:href="#cube" x="543" y="64';
1760         svgData[58] = '<use xlink:href="#cube" x="599" y="92';
1761         svgData[59] = '<use xlink:href="#cube" x="655" y="120';
1762         svgData[60] = '<use xlink:href="#cube" x="711" y="148';
1763         svgData[61] = '<use xlink:href="#cube" x="767" y="176';
1764         svgData[62] = '<use xlink:href="#cube" x="823" y="204';
1765         svgData[63] = '<use xlink:href="#cube" x="879" y="232';
1766         svgData[64] = '<use xlink:href="#cube" x="431" y="568';
1767         svgData[65] = '<use xlink:href="#cube" x="487" y="596';
1768         svgData[66] = '<use xlink:href="#cube" x="543" y="624';
1769         svgData[67] = '<use xlink:href="#cube" x="599" y="652';
1770         svgData[68] = '<use xlink:href="#cube" x="655" y="680';
1771         svgData[69] = '<use xlink:href="#cube" x="711" y="708';
1772         svgData[70] = '<use xlink:href="#cube" x="767" y="736';
1773         svgData[71] = '<use xlink:href="#cube" x="823" y="764';
1774         svgData[72] = '<use xlink:href="#cube" x="431" y="496';
1775         svgData[73] = '<use xlink:href="#cube" x="487" y="524';
1776         svgData[74] = '<use xlink:href="#cube" x="543" y="552';
1777         svgData[75] = '<use xlink:href="#cube" x="599" y="580';
1778         svgData[76] = '<use xlink:href="#cube" x="655" y="608';
1779         svgData[77] = '<use xlink:href="#cube" x="711" y="636';
1780         svgData[78] = '<use xlink:href="#cube" x="767" y="664';
1781         svgData[79] = '<use xlink:href="#cube" x="823" y="692';
1782         svgData[80] = '<use xlink:href="#cube" x="431" y="424';
1783         svgData[81] = '<use xlink:href="#cube" x="487" y="452';
1784         svgData[82] = '<use xlink:href="#cube" x="543" y="480';
1785         svgData[83] = '<use xlink:href="#cube" x="599" y="508';
1786         svgData[84] = '<use xlink:href="#cube" x="655" y="536';
1787         svgData[85] = '<use xlink:href="#cube" x="711" y="564';
1788         svgData[86] = '<use xlink:href="#cube" x="767" y="592';
1789         svgData[87] = '<use xlink:href="#cube" x="823" y="620';
1790         svgData[88] = '<use xlink:href="#cube" x="431" y="352';
1791         svgData[89] = '<use xlink:href="#cube" x="487" y="380';
1792         svgData[90] = '<use xlink:href="#cube" x="543" y="408';
1793         svgData[91] = '<use xlink:href="#cube" x="599" y="436';
1794         svgData[92] = '<use xlink:href="#cube" x="655" y="464';
1795         svgData[93] = '<use xlink:href="#cube" x="711" y="492';
1796         svgData[94] = '<use xlink:href="#cube" x="767" y="520';
1797         svgData[95] = '<use xlink:href="#cube" x="823" y="548';
1798         svgData[96] = '<use xlink:href="#cube" x="431" y="280';
1799         svgData[97] = '<use xlink:href="#cube" x="487" y="308';
1800         svgData[98] = '<use xlink:href="#cube" x="543" y="336';
1801         svgData[99] = '<use xlink:href="#cube" x="599" y="364';
1802         svgData[100] = '<use xlink:href="#cube" x="655" y="392';
1803         svgData[101] = '<use xlink:href="#cube" x="711" y="420';
1804         svgData[102] = '<use xlink:href="#cube" x="767" y="448';
1805         svgData[103] = '<use xlink:href="#cube" x="823" y="476';
1806     }
1807 
1808     // this is here for illustrative purposes -- you may ignore the onlyOwner isOwner on the functions
1809     // keeping in for nostalgic/sentimental reasons
1810     modifier isOwner(){
1811         require(_owner == msg.sender, "not the owner");
1812         _;
1813     }
1814 
1815     function setFeaturesAddress(address addr) external onlyOwner isOwner {
1816         features1= IFeatures1(addr);
1817     }
1818 
1819     function setPresaleMerkleRoot(bytes32 root) external onlyOwner isOwner {
1820         _merkleRoot = root;
1821     }
1822 
1823     function getFeatures(uint256 _tokenId) public view returns(uint256 , uint256 , uint256[4] memory, uint256[3] memory) {
1824         return (features[_tokenId].data1, features[_tokenId].data2, features[_tokenId].colors, features[_tokenId].colorSelectors);
1825     }
1826 
1827     //minting any unclaimed.
1828     function devMint(uint256 _amount) external onlyOwner isOwner {
1829         require(nextTokenId + _amount <= MAX_MINT_ETHEREUM, "MAX SUPPLY!");
1830         for (uint256 i = 0; i < _amount; i++) {
1831             _safeMint(msg.sender, ++nextTokenId);
1832         }
1833     }
1834 
1835     function setFinality(uint256 _itemID) public {
1836         require(msg.sender == ownerOf(_itemID), "YOU ARE NOT THE OWNER!");
1837         require(finality[_itemID] == false, "ALREADY IN FINALITY!");
1838 
1839         Features memory feature = features[_itemID];
1840         bytes memory output = abi.encodePacked(feature.data1, feature.data2, feature.colors[0], feature.colors[1], feature.colors[2], feature.colors[3]);
1841         require(taken[string(output)] == false, "THIS IS ALREADY TAKEN!");
1842 
1843         finality[_itemID] = true;
1844         taken[string(output)] = true;
1845     }
1846 
1847     function whitelistClaim(uint256 _amount, bytes32[] calldata _merkleProof) external payable {
1848         require(!whitelistClaimed[msg.sender], "ADDRESS HAS ALREADY CLAIMED!");
1849         require(_amount > 0, "CAN'T BE ZERO!");
1850         require(nextTokenId + _amount <= MAX_MINT_ETHEREUM, "MAX SUPPLY!");
1851 
1852         bytes32 leaf = keccak256(abi.encodePacked(msg.sender, _amount));
1853         require(MerkleProof.verify(_merkleProof, _merkleRoot, leaf),  "INVALID PROOF!");
1854 
1855         whitelistClaimed[msg.sender] = true;
1856         for (uint256 i = 0; i < _amount; i++) {
1857             _safeMint(msg.sender, ++nextTokenId);
1858         }
1859     }
1860 
1861     // this function transfers the nft from your address on the
1862     // source chain to the same address on the destination chain
1863     function traverseChains(uint16 _chainId, uint tokenId) public payable {
1864         require(msg.sender == ownerOf(tokenId), "You must own the token to traverse");
1865         require(trustedRemoteLookup[_chainId].length > 0, "This chain is currently unavailable for travel");
1866         require(finality[tokenId] == false, "ONLY NON-FINALITY CAN TRAVERSE!");
1867         // burn NFT, eliminating it from circulation on src chain
1868         _burn(tokenId);
1869 
1870         // abi.encode() the payload with the values to send
1871         bytes memory payload = abi.encode(msg.sender, tokenId);
1872 
1873         // encode adapterParams to specify more gas for the destination
1874         uint16 version = 1;
1875         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1876 
1877         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1878         // you will be refunded for extra gas paid
1879         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1880 
1881         require(msg.value >= messageFee, "msg.value not enough to cover messageFee. Send gas for message fees");
1882 
1883         endpoint.send{value: msg.value}(
1884             _chainId,                           // destination chainId
1885             trustedRemoteLookup[_chainId],      // destination address of nft contract
1886             payload,                            // abi.encoded()'ed bytes
1887             payable(msg.sender),                // refund address
1888             address(0x0),                       // 'zroPaymentAddress' unused for this
1889             adapterParams                       // txParameters
1890         );
1891     }
1892 
1893 
1894     // here for donations or accidents
1895     function withdraw(uint amt) external onlyOwner isOwner {
1896         (bool sent, ) = payable(_owner).call{value: amt}("");
1897         require(sent, "Failed to withdraw Ether");
1898     }
1899 
1900     function kustomize(uint256 _data1, uint256 _data2, uint256[4] memory _colors, uint256[3] memory _colorSelectors, uint256 _itemID) public {
1901         require(msg.sender == ownerOf(_itemID), "YOU ARE NOT THE OWNER!");
1902         require(finality[_itemID] == false, "ONLY NON-FINALITY CAN KUSTOMIZE!");
1903         require((_colorSelectors[0] < 138) && (_colorSelectors[1] < 138) && (_colorSelectors[2] < 138), "NO SUCH COLOR!");
1904 
1905         Features storage feature = features[_itemID];
1906         feature.data1 = _data1;
1907         feature.data2 = _data2;
1908         feature.colors = _colors;
1909         feature.colorSelectors = _colorSelectors;
1910 
1911         emit Kustomized(_itemID);
1912     }
1913 
1914     function kustomizeBackground(uint256 _data1, uint256 _itemID) public {
1915         require(msg.sender == ownerOf(_itemID), "YOU ARE NOT THE OWNER!");
1916         require(finality[_itemID] == false, "ONLY NON-FINALITY CAN KUSTOMIZE!");
1917         require(_data1 < 138, "NOT AN AVAILABLE COLOR!");
1918         svgBackgroundColorSelector[_itemID] = _data1;
1919     }
1920 
1921     function getSVG(uint256 _tokenId) public view returns (string memory) {
1922         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1923 
1924         Features memory feature = features[_tokenId];
1925 
1926         bytes memory artData = abi.encodePacked(feature.data1, feature.data2);
1927         bytes memory colorData = abi.encodePacked(feature.colors[0], feature.colors[1]);
1928         bytes memory colorData2 = abi.encodePacked(feature.colors[2], feature.colors[3]);
1929 
1930         string memory imageURI = string(abi.encodePacked('<svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="1100.000000pt" height="1100.000000pt" viewBox="0 0 1100.000000 1100.000000" preserveAspectRatio="xMidYMid meet" xmlns:xlink="http://www.w3.org/1999/xlink"> <defs> <g id="cube" class="cube-unit" transform="scale(0.25,0.25)"> <polygon style="stroke:#000000;" points="480,112 256,0 32,112 32,400 256,512 480,400 "/> <polygon style="stroke:#000000;" points="256,224 32,112 32,400 256,512 480,400 480,112 "/> <polygon style="stroke:#000000;" points="256,224 256,512 480,400 480,112 "/> </g> </defs> <g transform="translate(0.000000,1100.000000) scale(0.100000,-0.100000)" fill="#000000" stroke="none"> <path d="M0 5500 l0 -5500 5500 0 5500 0 0 5500 0 5500 -5500 0 -5500 0 0 -5500z" fill="', svgBackgroundColor[svgBackgroundColorSelector[_tokenId]], '</g>', CREATE(artData, colorData, colorData2, feature.colorSelectors[0], feature.colorSelectors[1], feature.colorSelectors[2]),finality[_tokenId] == false ? '<g transform="translate(0.000000,1100.000000) scale(0.100000,-0.100000)" fill="#F5F5F5"> <path d="M9720 890 l0 -110 -110 0 -110 0 0 -110 0 -110 110 0 110 0 0 -220 0 -220 110 0 110 0 0 220 0 220 110 0 110 0 0 110 0 110 -110 0 -110 0 0 110 0 110 -110 0 -110 0 0 -110z M10440 890 l0 -110 -110 0 -110 0 0 -110 0 -110 110 0 110 0 0 -220 0 -220 110 0 110 0 0 220 0 220 110 0 110 0 0 110 0 110 -110 0 -110 0 0 110 0 110 -110 0 -110 0 0 -110z"/></g></svg>' : '<g transform="translate(0.000000,1100.000000) scale(0.100000,-0.100000)" fill="#F5F5F5" stroke="none"> <path d="M9720 890 l0 -110 -110 0 -110 0 0 -110 0 -110 110 0 110 0 0 -220 0 -220 110 0 110 0 0 220 0 220 110 0 110 0 0 110 0 110 -110 0 -110 0 0 110 0 110 -110 0 -110 0 0 -110z m200 -20 l0 -110 110 0 110 0 0 -90 0 -90 -110 0 -110 0 0 -220 0 -220 -90 0 -90 0 0 220 0 220 -110 0 -110 0 0 90 0 90 110 0 110 0 0 110 0 110 90 0 90 0 0 -110z M9760 850 l0 -110 -110 0 -110 0 0 -70 0 -70 110 0 110 0 0 -220 0 -220 70 0 70 0 0 220 0 220 110 0 110 0 0 70 0 70 -110 0 -110 0 0 110 0 110 -70 0 -70 0 0 -110z m120 -20 l0 -110 110 0 110 0 0 -50 0 -50 -110 0 -110 0 0 -220 0 -220 -50 0 -50 0 0 220 0 220 -110 0 -110 0 0 50 0 50 110 0 110 0 0 110 0 110 50 0 50 0 0 -110z M9800 810 l0 -110 -110 0 -110 0 0 -30 0 -30 110 0 110 0 0 -220 0 -220 30 0 30 0 0 220 0 220 110 0 110 0 0 30 0 30 -110 0 -110 0 0 110 0 110 -30 0 -30 0 0 -110z m40 -20 l0 -110 110 0 c67 0 110 -4 110 -10 0 -6 -43 -10 -110 -10 l-110 0 0 -220 c0 -140 -4 -220 -10 -220 -6 0 -10 80 -10 220 l0 220 -110 0 c-67 0 -110 4 -110 10 0 6 43 10 110 10 l110 0 0 110 c0 67 4 110 10 110 6 0 10 -43 10 -110z M10440 890 l0 -110 -110 0 -110 0 0 -110 0 -110 110 0 110 0 0 -220 0 -220 110 0 110 0 0 220 0 220 110 0 110 0 0 110 0 110 -110 0 -110 0 0 110 0 110 -110 0 -110 0 0 -110z m200 -20 l0 -110 110 0 110 0 0 -90 0 -90 -110 0 -110 0 0 -220 0 -220 -90 0 -90 0 0 220 0 220 -110 0 -110 0 0 90 0 90 110 0 110 0 0 110 0 110 90 0 90 0 0 -110z M10480 850 l0 -110 -110 0 -110 0 0 -70 0 -70 110 0 110 0 0 -220 0 -220 70 0 70 0 0 220 0 220 110 0 110 0 0 70 0 70 -110 0 -110 0 0 110 0 110 -70 0 -70 0 0 -110z m120 -20 l0 -110 110 0 110 0 0 -50 0 -50 -110 0 -110 0 0 -220 0 -220 -50 0 -50 0 0 220 0 220 -110 0 -110 0 0 50 0 50 110 0 110 0 0 110 0 110 50 0 50 0 0 -110z M10520 810 l0 -110 -110 0 -110 0 0 -30 0 -30 110 0 110 0 0 -220 0 -220 30 0 30 0 0 220 0 220 110 0 110 0 0 30 0 30 -110 0 -110 0 0 110 0 110 -30 0 -30 0 0 -110z m40 -20 l0 -110 110 0 c67 0 110 -4 110 -10 0 -6 -43 -10 -110 -10 l-110 0 0 -220 c0 -140 -4 -220 -10 -220 -6 0 -10 80 -10 220 l0 220 -110 0 c-67 0 -110 4 -110 10 0 6 43 10 110 10 l110 0 0 110 c0 67 4 110 10 110 6 0 10 -43 10 -110z"/></g></svg>'));
1931 
1932         return imageURI;
1933     }
1934 
1935     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1936         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1937 
1938         Features memory feature = features[_tokenId];
1939 
1940         bytes memory artData = abi.encodePacked(feature.data1, feature.data2);
1941         bytes memory colorData = abi.encodePacked(feature.colors[0], feature.colors[1]);
1942         bytes memory colorData2 = abi.encodePacked(feature.colors[2], feature.colors[3]);
1943 
1944         string memory imageURI = string(abi.encodePacked("data:image/svg+xml;base64, ", Base64.encode(bytes(string(abi.encodePacked('<svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="1100.000000pt" height="1100.000000pt" viewBox="0 0 1100.000000 1100.000000" preserveAspectRatio="xMidYMid meet" xmlns:xlink="http://www.w3.org/1999/xlink"> <defs> <g id="cube" class="cube-unit" transform="scale(0.25,0.25)"> <polygon style="stroke:#000000;" points="480,112 256,0 32,112 32,400 256,512 480,400 "/> <polygon style="stroke:#000000;" points="256,224 32,112 32,400 256,512 480,400 480,112 "/> <polygon style="stroke:#000000;" points="256,224 256,512 480,400 480,112 "/> </g> </defs> <g transform="translate(0.000000,1100.000000) scale(0.100000,-0.100000)" fill="#000000" stroke="none"> <path d="M0 5500 l0 -5500 5500 0 5500 0 0 5500 0 5500 -5500 0 -5500 0 0 -5500z" fill="', svgBackgroundColor[svgBackgroundColorSelector[_tokenId]], '</g>', CREATE(artData, colorData, colorData2, feature.colorSelectors[0], feature.colorSelectors[1], feature.colorSelectors[2]),finality[_tokenId] == false ? '<g transform="translate(0.000000,1100.000000) scale(0.100000,-0.100000)" fill="#F5F5F5"> <path d="M9720 890 l0 -110 -110 0 -110 0 0 -110 0 -110 110 0 110 0 0 -220 0 -220 110 0 110 0 0 220 0 220 110 0 110 0 0 110 0 110 -110 0 -110 0 0 110 0 110 -110 0 -110 0 0 -110z M10440 890 l0 -110 -110 0 -110 0 0 -110 0 -110 110 0 110 0 0 -220 0 -220 110 0 110 0 0 220 0 220 110 0 110 0 0 110 0 110 -110 0 -110 0 0 110 0 110 -110 0 -110 0 0 -110z"/></g></svg>' : '<g transform="translate(0.000000,1100.000000) scale(0.100000,-0.100000)" fill="#F5F5F5" stroke="none"> <path d="M9720 890 l0 -110 -110 0 -110 0 0 -110 0 -110 110 0 110 0 0 -220 0 -220 110 0 110 0 0 220 0 220 110 0 110 0 0 110 0 110 -110 0 -110 0 0 110 0 110 -110 0 -110 0 0 -110z m200 -20 l0 -110 110 0 110 0 0 -90 0 -90 -110 0 -110 0 0 -220 0 -220 -90 0 -90 0 0 220 0 220 -110 0 -110 0 0 90 0 90 110 0 110 0 0 110 0 110 90 0 90 0 0 -110z M9760 850 l0 -110 -110 0 -110 0 0 -70 0 -70 110 0 110 0 0 -220 0 -220 70 0 70 0 0 220 0 220 110 0 110 0 0 70 0 70 -110 0 -110 0 0 110 0 110 -70 0 -70 0 0 -110z m120 -20 l0 -110 110 0 110 0 0 -50 0 -50 -110 0 -110 0 0 -220 0 -220 -50 0 -50 0 0 220 0 220 -110 0 -110 0 0 50 0 50 110 0 110 0 0 110 0 110 50 0 50 0 0 -110z M9800 810 l0 -110 -110 0 -110 0 0 -30 0 -30 110 0 110 0 0 -220 0 -220 30 0 30 0 0 220 0 220 110 0 110 0 0 30 0 30 -110 0 -110 0 0 110 0 110 -30 0 -30 0 0 -110z m40 -20 l0 -110 110 0 c67 0 110 -4 110 -10 0 -6 -43 -10 -110 -10 l-110 0 0 -220 c0 -140 -4 -220 -10 -220 -6 0 -10 80 -10 220 l0 220 -110 0 c-67 0 -110 4 -110 10 0 6 43 10 110 10 l110 0 0 110 c0 67 4 110 10 110 6 0 10 -43 10 -110z M10440 890 l0 -110 -110 0 -110 0 0 -110 0 -110 110 0 110 0 0 -220 0 -220 110 0 110 0 0 220 0 220 110 0 110 0 0 110 0 110 -110 0 -110 0 0 110 0 110 -110 0 -110 0 0 -110z m200 -20 l0 -110 110 0 110 0 0 -90 0 -90 -110 0 -110 0 0 -220 0 -220 -90 0 -90 0 0 220 0 220 -110 0 -110 0 0 90 0 90 110 0 110 0 0 110 0 110 90 0 90 0 0 -110z M10480 850 l0 -110 -110 0 -110 0 0 -70 0 -70 110 0 110 0 0 -220 0 -220 70 0 70 0 0 220 0 220 110 0 110 0 0 70 0 70 -110 0 -110 0 0 110 0 110 -70 0 -70 0 0 -110z m120 -20 l0 -110 110 0 110 0 0 -50 0 -50 -110 0 -110 0 0 -220 0 -220 -50 0 -50 0 0 220 0 220 -110 0 -110 0 0 50 0 50 110 0 110 0 0 110 0 110 50 0 50 0 0 -110z M10520 810 l0 -110 -110 0 -110 0 0 -30 0 -30 110 0 110 0 0 -220 0 -220 30 0 30 0 0 220 0 220 110 0 110 0 0 30 0 30 -110 0 -110 0 0 110 0 110 -30 0 -30 0 0 -110z m40 -20 l0 -110 110 0 c67 0 110 -4 110 -10 0 -6 -43 -10 -110 -10 l-110 0 0 -220 c0 -140 -4 -220 -10 -220 -6 0 -10 80 -10 220 l0 220 -110 0 c-67 0 -110 4 -110 10 0 6 43 10 110 10 l110 0 0 110 c0 67 4 110 10 110 6 0 10 -43 10 -110z"/> </g></svg>'))))));
1945         string memory finality_ = finality[_tokenId] == false ? 'false' : 'true';
1946 
1947         return string(
1948             abi.encodePacked(
1949             "data:application/json;base64,",
1950             Base64.encode(
1951                 bytes(
1952                 abi.encodePacked(
1953                     '{"name":"',
1954                     "METAKUBES-", toString(_tokenId),
1955                     '", "attributes":[{"trait_type" : "Finality", "value" : "', finality_ ,'"}], "image":"',imageURI,'"}'
1956                 )
1957                 )
1958             )
1959             )
1960         );
1961     }
1962 
1963 // had math here but 30M limit had different plans for us
1964 // please ignore any ugliness
1965 function CREATE(bytes memory artData, bytes memory colorData, bytes memory colorData2, uint256 color1, uint256 color2, uint256 color3) internal view returns (string memory) {
1966     bytes memory kubes = DynamicBuffer.allocate(2**16);
1967     uint tempCount;
1968 
1969     for (uint i = 0; i < 512; i+=8) {
1970         uint8 workingByte = uint8(artData[i/8]);
1971         uint8 colorByte = uint8(colorData[i/8]);
1972         uint8 colorByte2 = uint8(colorData2[i/8]);
1973 
1974         for (uint256 ii=0; ii < 8; ii++) {
1975             tempCount = i+ii;
1976             if ((workingByte >> (7 - ii)) & 1 == 1) {
1977                 if ((colorByte >> (7 - ii)) & 1 == 1) {
1978                     kubes.appendSafe(abi.encodePacked( tempCount < 104 ? svgData[tempCount] : features1.readMisc(tempCount),'" fill="', svgBackgroundColor[color1]));
1979                 } else {
1980                     if ((colorByte2 >> (7 - ii)) & 1 == 1) {
1981                         kubes.appendSafe(abi.encodePacked(tempCount < 104 ? svgData[tempCount] : features1.readMisc(tempCount),'" fill="', svgBackgroundColor[color2]));
1982                     } else {
1983                         kubes.appendSafe(abi.encodePacked(tempCount < 104 ? svgData[tempCount] : features1.readMisc(tempCount),'" fill="', svgBackgroundColor[color3]));
1984                     }
1985                 }
1986 
1987             }
1988         }
1989     }
1990       return string(kubes);
1991     }
1992 
1993     // just in case this fixed variable limits us from future integrations
1994     function setGasForDestinationLzReceive(uint newVal) external onlyOwner isOwner {
1995         gasForDestinationLzReceive = newVal;
1996     }
1997 
1998     function toString(uint256 value) internal pure returns (string memory) {
1999       if (value == 0) {
2000         return "0";
2001       }
2002       uint256 temp = value;
2003       uint256 digits;
2004       while (temp != 0) {
2005         digits++;
2006         temp /= 10;
2007       }
2008       bytes memory buffer = new bytes(digits);
2009       while (value != 0) {
2010         digits -= 1;
2011         buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2012         value /= 10;
2013       }
2014       return string(buffer);
2015     }
2016 
2017     // ------------------
2018     // Internal Functions
2019     // ------------------
2020 
2021     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal override {
2022         // decode
2023         (address toAddr, uint tokenId) = abi.decode(_payload, (address, uint));
2024 
2025         // mint the tokens back into existence on destination chain
2026         _safeMint(toAddr, tokenId);
2027     }
2028 }