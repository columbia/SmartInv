1 //SPDX-License-Identifier: MIT
2 // File: /ILayerZeroReceiver.sol
3 
4 
5 
6 pragma solidity >=0.5.0;
7 
8 interface ILayerZeroReceiver {
9     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
10     // @param _srcChainId - the source endpoint identifier
11     // @param _srcAddress - the source sending contract address from the source chain
12     // @param _nonce - the ordered message nonce
13     // @param _payload - the signed payload is the UA bytes has encoded to be sent
14     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
15 }
16 // File: /ILayerZeroUserApplicationConfig.sol
17 
18 
19 
20 pragma solidity >=0.5.0;
21 
22 interface ILayerZeroUserApplicationConfig {
23     // @notice set the configuration of the LayerZero messaging library of the specified version
24     // @param _version - messaging library version
25     // @param _chainId - the chainId for the pending config change
26     // @param _configType - type of configuration. every messaging library has its own convention.
27     // @param _config - configuration in the bytes. can encode arbitrary content.
28     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
29 
30     // @notice set the send() LayerZero messaging library version to _version
31     // @param _version - new messaging library version
32     function setSendVersion(uint16 _version) external;
33 
34     // @notice set the lzReceive() LayerZero messaging library version to _version
35     // @param _version - new messaging library version
36     function setReceiveVersion(uint16 _version) external;
37 
38     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
39     // @param _srcChainId - the chainId of the source chain
40     // @param _srcAddress - the contract address of the source contract at the source chain
41     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
42 }
43 // File: /ILayerZeroEndpoint.sol
44 
45 
46 
47 pragma solidity >=0.5.0;
48 
49 
50 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
51     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
52     // @param _dstChainId - the destination chain identifier
53     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
54     // @param _payload - a custom bytes payload to send to the destination contract
55     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
56     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
57     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
58     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
59 
60     // @notice used by the messaging library to publish verified payload
61     // @param _srcChainId - the source chain identifier
62     // @param _srcAddress - the source contract (as bytes) at the source chain
63     // @param _dstAddress - the address on destination chain
64     // @param _nonce - the unbound message ordering nonce
65     // @param _gasLimit - the gas limit for external contract execution
66     // @param _payload - verified payload to send to the destination contract
67     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
68 
69     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
70     // @param _srcChainId - the source chain identifier
71     // @param _srcAddress - the source chain contract address
72     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
73 
74     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
75     // @param _srcAddress - the source chain contract address
76     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
77 
78     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
79     // @param _dstChainId - the destination chain identifier
80     // @param _userApplication - the user app address on this EVM chain
81     // @param _payload - the custom message to send over LayerZero
82     // @param _payInZRO - if false, user app pays the protocol fee in native token
83     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
84     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
85 
86     // @notice get this Endpoint's immutable source identifier
87     function getChainId() external view returns (uint16);
88 
89     // @notice the interface to retry failed message on this Endpoint destination
90     // @param _srcChainId - the source chain identifier
91     // @param _srcAddress - the source chain contract address
92     // @param _payload - the payload to be retried
93     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
94 
95     // @notice query if any STORED payload (message blocking) at the endpoint.
96     // @param _srcChainId - the source chain identifier
97     // @param _srcAddress - the source chain contract address
98     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
99 
100     // @notice query if the _libraryAddress is valid for sending msgs.
101     // @param _userApplication - the user app address on this EVM chain
102     function getSendLibraryAddress(address _userApplication) external view returns (address);
103 
104     // @notice query if the _libraryAddress is valid for receiving msgs.
105     // @param _userApplication - the user app address on this EVM chain
106     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
107 
108     // @notice query if the non-reentrancy guard for send() is on
109     // @return true if the guard is on. false otherwise
110     function isSendingPayload() external view returns (bool);
111 
112     // @notice query if the non-reentrancy guard for receive() is on
113     // @return true if the guard is on. false otherwise
114     function isReceivingPayload() external view returns (bool);
115 
116     // @notice get the configuration of the LayerZero messaging library of the specified version
117     // @param _version - messaging library version
118     // @param _chainId - the chainId for the pending config change
119     // @param _userApplication - the contract address of the user application
120     // @param _configType - type of configuration. every messaging library has its own convention.
121     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
122 
123     // @notice get the send() LayerZero messaging library version
124     // @param _userApplication - the contract address of the user application
125     function getSendVersion(address _userApplication) external view returns (uint16);
126 
127     // @notice get the lzReceive() LayerZero messaging library version
128     // @param _userApplication - the contract address of the user application
129     function getReceiveVersion(address _userApplication) external view returns (uint16);
130 }
131 // File: @openzeppelin/contracts/utils/Strings.sol
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 /**
139  * @dev String operations.
140  */
141 library Strings {
142     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
146      */
147     function toString(uint256 value) internal pure returns (string memory) {
148         // Inspired by OraclizeAPI's implementation - MIT licence
149         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
150 
151         if (value == 0) {
152             return "0";
153         }
154         uint256 temp = value;
155         uint256 digits;
156         while (temp != 0) {
157             digits++;
158             temp /= 10;
159         }
160         bytes memory buffer = new bytes(digits);
161         while (value != 0) {
162             digits -= 1;
163             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
164             value /= 10;
165         }
166         return string(buffer);
167     }
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
171      */
172     function toHexString(uint256 value) internal pure returns (string memory) {
173         if (value == 0) {
174             return "0x00";
175         }
176         uint256 temp = value;
177         uint256 length = 0;
178         while (temp != 0) {
179             length++;
180             temp >>= 8;
181         }
182         return toHexString(value, length);
183     }
184 
185     /**
186      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
187      */
188     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
189         bytes memory buffer = new bytes(2 * length + 2);
190         buffer[0] = "0";
191         buffer[1] = "x";
192         for (uint256 i = 2 * length + 1; i > 1; --i) {
193             buffer[i] = _HEX_SYMBOLS[value & 0xf];
194             value >>= 4;
195         }
196         require(value == 0, "Strings: hex length insufficient");
197         return string(buffer);
198     }
199 }
200 
201 // File: @openzeppelin/contracts/utils/Context.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Provides information about the current execution context, including the
210  * sender of the transaction and its data. While these are generally available
211  * via msg.sender and msg.data, they should not be accessed in such a direct
212  * manner, since when dealing with meta-transactions the account sending and
213  * paying for execution may not be the actual sender (as far as an application
214  * is concerned).
215  *
216  * This contract is only required for intermediate, library-like contracts.
217  */
218 abstract contract Context {
219     function _msgSender() internal view virtual returns (address) {
220         return msg.sender;
221     }
222 
223     function _msgData() internal view virtual returns (bytes calldata) {
224         return msg.data;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/access/Ownable.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 
236 /**
237  * @dev Contract module which provides a basic access control mechanism, where
238  * there is an account (an owner) that can be granted exclusive access to
239  * specific functions.
240  *
241  * By default, the owner account will be the one that deploys the contract. This
242  * can later be changed with {transferOwnership}.
243  *
244  * This module is used through inheritance. It will make available the modifier
245  * `onlyOwner`, which can be applied to your functions to restrict their use to
246  * the owner.
247  */
248 abstract contract Ownable is Context {
249     address private _owner;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     /**
254      * @dev Initializes the contract setting the deployer as the initial owner.
255      */
256     constructor() {
257         _transferOwnership(_msgSender());
258     }
259 
260     /**
261      * @dev Returns the address of the current owner.
262      */
263     function owner() public view virtual returns (address) {
264         return _owner;
265     }
266 
267     /**
268      * @dev Throws if called by any account other than the owner.
269      */
270     modifier onlyOwner() {
271         require(owner() == _msgSender(), "Ownable: caller is not the owner");
272         _;
273     }
274 
275     /**
276      * @dev Leaves the contract without owner. It will not be possible to call
277      * `onlyOwner` functions anymore. Can only be called by the current owner.
278      *
279      * NOTE: Renouncing ownership will leave the contract without an owner,
280      * thereby removing any functionality that is only available to the owner.
281      */
282     function renounceOwnership() public virtual onlyOwner {
283         _transferOwnership(address(0));
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Can only be called by the current owner.
289      */
290     function transferOwnership(address newOwner) public virtual onlyOwner {
291         require(newOwner != address(0), "Ownable: new owner is the zero address");
292         _transferOwnership(newOwner);
293     }
294 
295     /**
296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
297      * Internal function without access restriction.
298      */
299     function _transferOwnership(address newOwner) internal virtual {
300         address oldOwner = _owner;
301         _owner = newOwner;
302         emit OwnershipTransferred(oldOwner, newOwner);
303     }
304 }
305 
306 // File: /NonblockingReceiver.sol
307 
308 
309 pragma solidity ^0.8.9;
310 
311 
312 
313 
314 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
315 
316     ILayerZeroEndpoint internal endpoint;
317 
318     struct FailedMessages {
319         uint payloadLength;
320         bytes32 payloadHash;
321     }
322 
323     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
324     mapping(uint16 => bytes) public trustedRemoteLookup;
325 
326     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
327 
328     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
329         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
330         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]),
331             "NonblockingReceiver: invalid source sending contract");
332 
333         // try-catch all errors/exceptions
334         // having failed messages does not block messages passing
335         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
336             // do nothing
337         } catch {
338             // error / exception
339             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
340             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
341         }
342     }
343 
344     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
345         // only internal transaction
346         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
347 
348         // handle incoming message
349         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
350     }
351 
352     // abstract function
353     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
354 
355     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
356         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
357     }
358 
359     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
360         // assert there is message to retry
361         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
362         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
363         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
364         // clear the stored message
365         failedMsg.payloadLength = 0;
366         failedMsg.payloadHash = bytes32(0);
367         // execute the message. revert if it fails again
368         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
369     }
370 
371     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
372         trustedRemoteLookup[_chainId] = _trustedRemote;
373     }
374 }
375 // File: @openzeppelin/contracts/utils/Address.sol
376 
377 
378 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
379 
380 pragma solidity ^0.8.1;
381 
382 /**
383  * @dev Collection of functions related to the address type
384  */
385 library Address {
386     /**
387      * @dev Returns true if `account` is a contract.
388      *
389      * [IMPORTANT]
390      * ====
391      * It is unsafe to assume that an address for which this function returns
392      * false is an externally-owned account (EOA) and not a contract.
393      *
394      * Among others, `isContract` will return false for the following
395      * types of addresses:
396      *
397      *  - an externally-owned account
398      *  - a contract in construction
399      *  - an address where a contract will be created
400      *  - an address where a contract lived, but was destroyed
401      * ====
402      *
403      * [IMPORTANT]
404      * ====
405      * You shouldn't rely on `isContract` to protect against flash loan attacks!
406      *
407      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
408      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
409      * constructor.
410      * ====
411      */
412     function isContract(address account) internal view returns (bool) {
413         // This method relies on extcodesize/address.code.length, which returns 0
414         // for contracts in construction, since the code is only stored at the end
415         // of the constructor execution.
416 
417         return account.code.length > 0;
418     }
419 
420     /**
421      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
422      * `recipient`, forwarding all available gas and reverting on errors.
423      *
424      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
425      * of certain opcodes, possibly making contracts go over the 2300 gas limit
426      * imposed by `transfer`, making them unable to receive funds via
427      * `transfer`. {sendValue} removes this limitation.
428      *
429      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
430      *
431      * IMPORTANT: because control is transferred to `recipient`, care must be
432      * taken to not create reentrancy vulnerabilities. Consider using
433      * {ReentrancyGuard} or the
434      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
435      */
436     function sendValue(address payable recipient, uint256 amount) internal {
437         require(address(this).balance >= amount, "Address: insufficient balance");
438 
439         (bool success, ) = recipient.call{value: amount}("");
440         require(success, "Address: unable to send value, recipient may have reverted");
441     }
442 
443     /**
444      * @dev Performs a Solidity function call using a low level `call`. A
445      * plain `call` is an unsafe replacement for a function call: use this
446      * function instead.
447      *
448      * If `target` reverts with a revert reason, it is bubbled up by this
449      * function (like regular Solidity function calls).
450      *
451      * Returns the raw returned data. To convert to the expected return value,
452      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
453      *
454      * Requirements:
455      *
456      * - `target` must be a contract.
457      * - calling `target` with `data` must not revert.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
462         return functionCall(target, data, "Address: low-level call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
467      * `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         return functionCallWithValue(target, data, 0, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but also transferring `value` wei to `target`.
482      *
483      * Requirements:
484      *
485      * - the calling contract must have an ETH balance of at least `value`.
486      * - the called Solidity function must be `payable`.
487      *
488      * _Available since v3.1._
489      */
490     function functionCallWithValue(
491         address target,
492         bytes memory data,
493         uint256 value
494     ) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
500      * with `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         require(address(this).balance >= value, "Address: insufficient balance for call");
511         require(isContract(target), "Address: call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.call{value: value}(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
524         return functionStaticCall(target, data, "Address: low-level static call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal view returns (bytes memory) {
538         require(isContract(target), "Address: static call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.staticcall(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but performing a delegate call.
547      *
548      * _Available since v3.4._
549      */
550     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
551         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(
561         address target,
562         bytes memory data,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(isContract(target), "Address: delegate call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.delegatecall(data);
568         return verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
573      * revert reason using the provided one.
574      *
575      * _Available since v4.3._
576      */
577     function verifyCallResult(
578         bool success,
579         bytes memory returndata,
580         string memory errorMessage
581     ) internal pure returns (bytes memory) {
582         if (success) {
583             return returndata;
584         } else {
585             // Look for revert reason and bubble it up if present
586             if (returndata.length > 0) {
587                 // The easiest way to bubble the revert reason is using memory via assembly
588 
589                 assembly {
590                     let returndata_size := mload(returndata)
591                     revert(add(32, returndata), returndata_size)
592                 }
593             } else {
594                 revert(errorMessage);
595             }
596         }
597     }
598 }
599 
600 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @title ERC721 token receiver interface
609  * @dev Interface for any contract that wants to support safeTransfers
610  * from ERC721 asset contracts.
611  */
612 interface IERC721Receiver {
613     /**
614      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
615      * by `operator` from `from`, this function is called.
616      *
617      * It must return its Solidity selector to confirm the token transfer.
618      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
619      *
620      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
621      */
622     function onERC721Received(
623         address operator,
624         address from,
625         uint256 tokenId,
626         bytes calldata data
627     ) external returns (bytes4);
628 }
629 
630 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 /**
638  * @dev Interface of the ERC165 standard, as defined in the
639  * https://eips.ethereum.org/EIPS/eip-165[EIP].
640  *
641  * Implementers can declare support of contract interfaces, which can then be
642  * queried by others ({ERC165Checker}).
643  *
644  * For an implementation, see {ERC165}.
645  */
646 interface IERC165 {
647     /**
648      * @dev Returns true if this contract implements the interface defined by
649      * `interfaceId`. See the corresponding
650      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
651      * to learn more about how these ids are created.
652      *
653      * This function call must use less than 30 000 gas.
654      */
655     function supportsInterface(bytes4 interfaceId) external view returns (bool);
656 }
657 
658 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
659 
660 
661 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 
666 /**
667  * @dev Implementation of the {IERC165} interface.
668  *
669  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
670  * for the additional interface id that will be supported. For example:
671  *
672  * ```solidity
673  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
674  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
675  * }
676  * ```
677  *
678  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
679  */
680 abstract contract ERC165 is IERC165 {
681     /**
682      * @dev See {IERC165-supportsInterface}.
683      */
684     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
685         return interfaceId == type(IERC165).interfaceId;
686     }
687 }
688 
689 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @dev Required interface of an ERC721 compliant contract.
699  */
700 interface IERC721 is IERC165 {
701     /**
702      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
703      */
704     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
705 
706     /**
707      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
708      */
709     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
710 
711     /**
712      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
713      */
714     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
715 
716     /**
717      * @dev Returns the number of tokens in ``owner``'s account.
718      */
719     function balanceOf(address owner) external view returns (uint256 balance);
720 
721     /**
722      * @dev Returns the owner of the `tokenId` token.
723      *
724      * Requirements:
725      *
726      * - `tokenId` must exist.
727      */
728     function ownerOf(uint256 tokenId) external view returns (address owner);
729 
730     /**
731      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
732      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
733      *
734      * Requirements:
735      *
736      * - `from` cannot be the zero address.
737      * - `to` cannot be the zero address.
738      * - `tokenId` token must exist and be owned by `from`.
739      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
740      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
741      *
742      * Emits a {Transfer} event.
743      */
744     function safeTransferFrom(
745         address from,
746         address to,
747         uint256 tokenId
748     ) external;
749 
750     /**
751      * @dev Transfers `tokenId` token from `from` to `to`.
752      *
753      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
754      *
755      * Requirements:
756      *
757      * - `from` cannot be the zero address.
758      * - `to` cannot be the zero address.
759      * - `tokenId` token must be owned by `from`.
760      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
761      *
762      * Emits a {Transfer} event.
763      */
764     function transferFrom(
765         address from,
766         address to,
767         uint256 tokenId
768     ) external;
769 
770     /**
771      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
772      * The approval is cleared when the token is transferred.
773      *
774      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
775      *
776      * Requirements:
777      *
778      * - The caller must own the token or be an approved operator.
779      * - `tokenId` must exist.
780      *
781      * Emits an {Approval} event.
782      */
783     function approve(address to, uint256 tokenId) external;
784 
785     /**
786      * @dev Returns the account approved for `tokenId` token.
787      *
788      * Requirements:
789      *
790      * - `tokenId` must exist.
791      */
792     function getApproved(uint256 tokenId) external view returns (address operator);
793 
794     /**
795      * @dev Approve or remove `operator` as an operator for the caller.
796      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
797      *
798      * Requirements:
799      *
800      * - The `operator` cannot be the caller.
801      *
802      * Emits an {ApprovalForAll} event.
803      */
804     function setApprovalForAll(address operator, bool _approved) external;
805 
806     /**
807      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
808      *
809      * See {setApprovalForAll}
810      */
811     function isApprovedForAll(address owner, address operator) external view returns (bool);
812 
813     /**
814      * @dev Safely transfers `tokenId` token from `from` to `to`.
815      *
816      * Requirements:
817      *
818      * - `from` cannot be the zero address.
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must exist and be owned by `from`.
821      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
822      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
823      *
824      * Emits a {Transfer} event.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 tokenId,
830         bytes calldata data
831     ) external;
832 }
833 
834 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
835 
836 
837 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
838 
839 pragma solidity ^0.8.0;
840 
841 
842 /**
843  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
844  * @dev See https://eips.ethereum.org/EIPS/eip-721
845  */
846 interface IERC721Metadata is IERC721 {
847     /**
848      * @dev Returns the token collection name.
849      */
850     function name() external view returns (string memory);
851 
852     /**
853      * @dev Returns the token collection symbol.
854      */
855     function symbol() external view returns (string memory);
856 
857     /**
858      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
859      */
860     function tokenURI(uint256 tokenId) external view returns (string memory);
861 }
862 
863 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
864 
865 
866 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
867 
868 pragma solidity ^0.8.0;
869 
870 
871 
872 
873 
874 
875 
876 
877 /**
878  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
879  * the Metadata extension, but not including the Enumerable extension, which is available separately as
880  * {ERC721Enumerable}.
881  */
882 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
883     using Address for address;
884     using Strings for uint256;
885 
886     // Token name
887     string private _name;
888 
889     // Token symbol
890     string private _symbol;
891 
892     // Mapping from token ID to owner address
893     mapping(uint256 => address) private _owners;
894 
895     // Mapping owner address to token count
896     mapping(address => uint256) private _balances;
897 
898     // Mapping from token ID to approved address
899     mapping(uint256 => address) private _tokenApprovals;
900 
901     // Mapping from owner to operator approvals
902     mapping(address => mapping(address => bool)) private _operatorApprovals;
903 
904     /**
905      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
906      */
907     constructor(string memory name_, string memory symbol_) {
908         _name = name_;
909         _symbol = symbol_;
910     }
911 
912     /**
913      * @dev See {IERC165-supportsInterface}.
914      */
915     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
916         return
917             interfaceId == type(IERC721).interfaceId ||
918             interfaceId == type(IERC721Metadata).interfaceId ||
919             super.supportsInterface(interfaceId);
920     }
921 
922     /**
923      * @dev See {IERC721-balanceOf}.
924      */
925     function balanceOf(address owner) public view virtual override returns (uint256) {
926         require(owner != address(0), "ERC721: balance query for the zero address");
927         return _balances[owner];
928     }
929 
930     /**
931      * @dev See {IERC721-ownerOf}.
932      */
933     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
934         address owner = _owners[tokenId];
935         require(owner != address(0), "ERC721: owner query for nonexistent token");
936         return owner;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-name}.
941      */
942     function name() public view virtual override returns (string memory) {
943         return _name;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-symbol}.
948      */
949     function symbol() public view virtual override returns (string memory) {
950         return _symbol;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-tokenURI}.
955      */
956     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
957         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
958 
959         string memory baseURI = _baseURI();
960         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
961     }
962 
963     /**
964      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
965      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
966      * by default, can be overriden in child contracts.
967      */
968     function _baseURI() internal view virtual returns (string memory) {
969         return "";
970     }
971 
972     /**
973      * @dev See {IERC721-approve}.
974      */
975     function approve(address to, uint256 tokenId) public virtual override {
976         address owner = ERC721.ownerOf(tokenId);
977         require(to != owner, "ERC721: approval to current owner");
978 
979         require(
980             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
981             "ERC721: approve caller is not owner nor approved for all"
982         );
983 
984         _approve(to, tokenId);
985     }
986 
987     /**
988      * @dev See {IERC721-getApproved}.
989      */
990     function getApproved(uint256 tokenId) public view virtual override returns (address) {
991         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
992 
993         return _tokenApprovals[tokenId];
994     }
995 
996     /**
997      * @dev See {IERC721-setApprovalForAll}.
998      */
999     function setApprovalForAll(address operator, bool approved) public virtual override {
1000         _setApprovalForAll(_msgSender(), operator, approved);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-isApprovedForAll}.
1005      */
1006     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1007         return _operatorApprovals[owner][operator];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-transferFrom}.
1012      */
1013     function transferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         //solhint-disable-next-line max-line-length
1019         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1020 
1021         _transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         safeTransferFrom(from, to, tokenId, "");
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) public virtual override {
1044         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1045         _safeTransfer(from, to, tokenId, _data);
1046     }
1047 
1048     /**
1049      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1050      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1051      *
1052      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1053      *
1054      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1055      * implement alternative mechanisms to perform token transfer, such as signature-based.
1056      *
1057      * Requirements:
1058      *
1059      * - `from` cannot be the zero address.
1060      * - `to` cannot be the zero address.
1061      * - `tokenId` token must exist and be owned by `from`.
1062      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _safeTransfer(
1067         address from,
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) internal virtual {
1072         _transfer(from, to, tokenId);
1073         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1074     }
1075 
1076     /**
1077      * @dev Returns whether `tokenId` exists.
1078      *
1079      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1080      *
1081      * Tokens start existing when they are minted (`_mint`),
1082      * and stop existing when they are burned (`_burn`).
1083      */
1084     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1085         return _owners[tokenId] != address(0);
1086     }
1087 
1088     /**
1089      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1090      *
1091      * Requirements:
1092      *
1093      * - `tokenId` must exist.
1094      */
1095     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1096         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1097         address owner = ERC721.ownerOf(tokenId);
1098         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1099     }
1100 
1101     /**
1102      * @dev Safely mints `tokenId` and transfers it to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - `tokenId` must not exist.
1107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _safeMint(address to, uint256 tokenId) internal virtual {
1112         _safeMint(to, tokenId, "");
1113     }
1114 
1115     /**
1116      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1117      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1118      */
1119     function _safeMint(
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) internal virtual {
1124         _mint(to, tokenId);
1125         require(
1126             _checkOnERC721Received(address(0), to, tokenId, _data),
1127             "ERC721: transfer to non ERC721Receiver implementer"
1128         );
1129     }
1130 
1131     /**
1132      * @dev Mints `tokenId` and transfers it to `to`.
1133      *
1134      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must not exist.
1139      * - `to` cannot be the zero address.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _mint(address to, uint256 tokenId) internal virtual {
1144         require(to != address(0), "ERC721: mint to the zero address");
1145         require(!_exists(tokenId), "ERC721: token already minted");
1146 
1147         _beforeTokenTransfer(address(0), to, tokenId);
1148 
1149         _balances[to] += 1;
1150         _owners[tokenId] = to;
1151 
1152         emit Transfer(address(0), to, tokenId);
1153 
1154         _afterTokenTransfer(address(0), to, tokenId);
1155     }
1156 
1157     /**
1158      * @dev Destroys `tokenId`.
1159      * The approval is cleared when the token is burned.
1160      *
1161      * Requirements:
1162      *
1163      * - `tokenId` must exist.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function _burn(uint256 tokenId) internal virtual {
1168         address owner = ERC721.ownerOf(tokenId);
1169 
1170         _beforeTokenTransfer(owner, address(0), tokenId);
1171 
1172         // Clear approvals
1173         _approve(address(0), tokenId);
1174 
1175         _balances[owner] -= 1;
1176         delete _owners[tokenId];
1177 
1178         emit Transfer(owner, address(0), tokenId);
1179 
1180         _afterTokenTransfer(owner, address(0), tokenId);
1181     }
1182 
1183     /**
1184      * @dev Transfers `tokenId` from `from` to `to`.
1185      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1186      *
1187      * Requirements:
1188      *
1189      * - `to` cannot be the zero address.
1190      * - `tokenId` token must be owned by `from`.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function _transfer(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) internal virtual {
1199         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1200         require(to != address(0), "ERC721: transfer to the zero address");
1201 
1202         _beforeTokenTransfer(from, to, tokenId);
1203 
1204         // Clear approvals from the previous owner
1205         _approve(address(0), tokenId);
1206 
1207         _balances[from] -= 1;
1208         _balances[to] += 1;
1209         _owners[tokenId] = to;
1210 
1211         emit Transfer(from, to, tokenId);
1212 
1213         _afterTokenTransfer(from, to, tokenId);
1214     }
1215 
1216     /**
1217      * @dev Approve `to` to operate on `tokenId`
1218      *
1219      * Emits a {Approval} event.
1220      */
1221     function _approve(address to, uint256 tokenId) internal virtual {
1222         _tokenApprovals[tokenId] = to;
1223         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1224     }
1225 
1226     /**
1227      * @dev Approve `operator` to operate on all of `owner` tokens
1228      *
1229      * Emits a {ApprovalForAll} event.
1230      */
1231     function _setApprovalForAll(
1232         address owner,
1233         address operator,
1234         bool approved
1235     ) internal virtual {
1236         require(owner != operator, "ERC721: approve to caller");
1237         _operatorApprovals[owner][operator] = approved;
1238         emit ApprovalForAll(owner, operator, approved);
1239     }
1240 
1241     /**
1242      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1243      * The call is not executed if the target address is not a contract.
1244      *
1245      * @param from address representing the previous owner of the given token ID
1246      * @param to target address that will receive the tokens
1247      * @param tokenId uint256 ID of the token to be transferred
1248      * @param _data bytes optional data to send along with the call
1249      * @return bool whether the call correctly returned the expected magic value
1250      */
1251     function _checkOnERC721Received(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory _data
1256     ) private returns (bool) {
1257         if (to.isContract()) {
1258             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1259                 return retval == IERC721Receiver.onERC721Received.selector;
1260             } catch (bytes memory reason) {
1261                 if (reason.length == 0) {
1262                     revert("ERC721: transfer to non ERC721Receiver implementer");
1263                 } else {
1264                     assembly {
1265                         revert(add(32, reason), mload(reason))
1266                     }
1267                 }
1268             }
1269         } else {
1270             return true;
1271         }
1272     }
1273 
1274     /**
1275      * @dev Hook that is called before any token transfer. This includes minting
1276      * and burning.
1277      *
1278      * Calling conditions:
1279      *
1280      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1281      * transferred to `to`.
1282      * - When `from` is zero, `tokenId` will be minted for `to`.
1283      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1284      * - `from` and `to` are never both zero.
1285      *
1286      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1287      */
1288     function _beforeTokenTransfer(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) internal virtual {}
1293 
1294     /**
1295      * @dev Hook that is called after any transfer of tokens. This includes
1296      * minting and burning.
1297      *
1298      * Calling conditions:
1299      *
1300      * - when `from` and `to` are both non-zero.
1301      * - `from` and `to` are never both zero.
1302      *
1303      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1304      */
1305     function _afterTokenTransfer(
1306         address from,
1307         address to,
1308         uint256 tokenId
1309     ) internal virtual {}
1310 }
1311 
1312 // File: eightbitbayc.sol
1313 
1314 
1315 pragma solidity ^0.8.9;
1316 
1317 
1318 
1319 contract multichainmoonbirdPUNKS is ERC721, NonblockingReceiver {
1320 
1321     string public baseURI = "ipfs://QmaJebT6ZGgKWQj5TzJnNg2yUHBTnCEZi6ffuBdLhcJzqs/";
1322     string public contractURI = "ipfs://Qmbht14SgQMmySpm8BHL6CwB47ErhTaHYLYLcE8mYEniZw";
1323     string public constant baseExtension = ".json";
1324 
1325     uint256 nextTokenId;
1326     uint256 MAX_MINT;
1327 
1328     uint256 gasForDestinationLzReceive = 350000;
1329 
1330     uint256 public constant MAX_PER_TX = 2;
1331     uint256 public constant MAX_PER_WALLET = 30;
1332     mapping(address => uint256) public minted;
1333 
1334     bool public paused = false;
1335 
1336     constructor(
1337         address _endpoint,
1338         uint256 startId,
1339         uint256 _max
1340     ) ERC721("moonbirdPUNKS", "mbPUNKS") {
1341         endpoint = ILayerZeroEndpoint(_endpoint);
1342         nextTokenId = startId;
1343         MAX_MINT = _max;
1344     }
1345 
1346     function mint(uint256 _amount) external payable {
1347         address _caller = _msgSender();
1348         require(!paused, "moonbirdPUNKS: Paused");
1349         require(nextTokenId + _amount <= MAX_MINT, "moonbirdPUNKS: Mint exceeds supply");
1350         require(MAX_PER_TX >= _amount , "moonbirdPUNKS: Excess max per tx");
1351         require(MAX_PER_WALLET >= minted[_caller] + _amount, "moonbirdPUNKS: Excess max per wallet");
1352         minted[_caller] += _amount;
1353 
1354         for(uint256 i = 0; i < _amount; i++) {
1355             _safeMint(_caller, ++nextTokenId);
1356         }
1357     }
1358 
1359     // This function transfers the nft from your address on the
1360     // source chain to the same address on the destination chain
1361     function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1362         require(
1363             msg.sender == ownerOf(tokenId),
1364             "You must own the token to traverse"
1365         );
1366         require(
1367             trustedRemoteLookup[_chainId].length > 0,
1368             "This chain is currently unavailable for travel"
1369         );
1370 
1371         // burn NFT, eliminating it from circulation on src chain
1372         _burn(tokenId);
1373 
1374         // abi.encode() the payload with the values to send
1375         bytes memory payload = abi.encode(msg.sender, tokenId);
1376 
1377         // encode adapterParams to specify more gas for the destination
1378         uint16 version = 1;
1379         bytes memory adapterParams = abi.encodePacked(
1380             version,
1381             gasForDestinationLzReceive
1382         );
1383 
1384         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1385         // you will be refunded for extra gas paid
1386         (uint256 messageFee, ) = endpoint.estimateFees(
1387             _chainId,
1388             address(this),
1389             payload,
1390             false,
1391             adapterParams
1392         );
1393 
1394         require(
1395             msg.value >= messageFee,
1396             "moonbirdPUNKS: msg.value not enough to cover messageFee. Send gas for message fees"
1397         );
1398 
1399         endpoint.send{value: msg.value}(
1400             _chainId, // destination chainId
1401             trustedRemoteLookup[_chainId], // destination address of nft contract
1402             payload, // abi.encoded()'ed bytes
1403             payable(msg.sender), // refund address
1404             address(0x0), // 'zroPaymentAddress' unused for this
1405             adapterParams // txParameters
1406         );
1407     }
1408 
1409     function getEstimatedFees(uint16 _chainId, uint256 tokenId) public view returns (uint) {
1410         bytes memory payload = abi.encode(msg.sender, tokenId);
1411         uint16 version = 1;
1412         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1413         (uint quotedLayerZeroFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1414         return quotedLayerZeroFee;
1415     }
1416 
1417     function pause(bool _state) external onlyOwner {
1418         paused = _state;
1419     }
1420 
1421     function setBaseURI(string memory baseURI_) external onlyOwner {
1422         baseURI = baseURI_;
1423     }
1424 
1425     function setContractURI(string memory _contractURI) external onlyOwner {
1426         contractURI = _contractURI;
1427     }
1428 
1429     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1430         require(_exists(_tokenId), "Token does not exist.");
1431         return bytes(baseURI).length > 0 ? string(
1432             abi.encodePacked(
1433               baseURI,
1434               Strings.toString(_tokenId),
1435               baseExtension
1436             )
1437         ) : "";
1438     }
1439 
1440     function setGasForDestinationLzReceive(uint256 _gasForDestinationLzReceive) external onlyOwner {
1441         gasForDestinationLzReceive = _gasForDestinationLzReceive;
1442     }
1443 
1444     function withdraw() external onlyOwner {
1445         uint256 balance = address(this).balance;
1446         (bool success, ) = _msgSender().call{value: balance}("");
1447         require(success, "Failed to send");
1448     }
1449 
1450     // ------------------
1451     // Internal Functions
1452     // ------------------
1453 
1454     function _LzReceive(
1455         uint16 _srcChainId,
1456         bytes memory _srcAddress,
1457         uint64 _nonce,
1458         bytes memory _payload
1459     ) internal override {
1460         // decode
1461         (address toAddr, uint256 tokenId) = abi.decode(
1462             _payload,
1463             (address, uint256)
1464         );
1465 
1466         // mint the tokens back into existence on destination chain
1467         _safeMint(toAddr, tokenId);
1468     }
1469 
1470 }