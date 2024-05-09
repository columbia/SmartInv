1 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
2 
3 
4 
5 pragma solidity >=0.5.0;
6 
7 interface ILayerZeroUserApplicationConfig {
8     // @notice set the configuration of the LayerZero messaging library of the specified version
9     // @param _version - messaging library version
10     // @param _chainId - the chainId for the pending config change
11     // @param _configType - type of configuration. every messaging library has its own convention.
12     // @param _config - configuration in the bytes. can encode arbitrary content.
13     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
14 
15     // @notice set the send() LayerZero messaging library version to _version
16     // @param _version - new messaging library version
17     function setSendVersion(uint16 _version) external;
18 
19     // @notice set the lzReceive() LayerZero messaging library version to _version
20     // @param _version - new messaging library version
21     function setReceiveVersion(uint16 _version) external;
22 
23     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
24     // @param _srcChainId - the chainId of the source chain
25     // @param _srcAddress - the contract address of the source contract at the source chain
26     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
27 }
28 // File: contracts/interfaces/ILayerZeroEndpoint.sol
29 
30 
31 
32 pragma solidity >=0.5.0;
33 
34 
35 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
36     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
37     // @param _dstChainId - the destination chain identifier
38     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
39     // @param _payload - a custom bytes payload to send to the destination contract
40     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
41     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
42     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
43     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
44 
45     // @notice used by the messaging library to publish verified payload
46     // @param _srcChainId - the source chain identifier
47     // @param _srcAddress - the source contract (as bytes) at the source chain
48     // @param _dstAddress - the address on destination chain
49     // @param _nonce - the unbound message ordering nonce
50     // @param _gasLimit - the gas limit for external contract execution
51     // @param _payload - verified payload to send to the destination contract
52     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
53 
54     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
55     // @param _srcChainId - the source chain identifier
56     // @param _srcAddress - the source chain contract address
57     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
58 
59     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
60     // @param _srcAddress - the source chain contract address
61     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
62 
63     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
64     // @param _dstChainId - the destination chain identifier
65     // @param _userApplication - the user app address on this EVM chain
66     // @param _payload - the custom message to send over LayerZero
67     // @param _payInZRO - if false, user app pays the protocol fee in native token
68     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
69     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
70 
71     // @notice get this Endpoint's immutable source identifier
72     function getChainId() external view returns (uint16);
73 
74     // @notice the interface to retry failed message on this Endpoint destination
75     // @param _srcChainId - the source chain identifier
76     // @param _srcAddress - the source chain contract address
77     // @param _payload - the payload to be retried
78     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
79 
80     // @notice query if any STORED payload (message blocking) at the endpoint.
81     // @param _srcChainId - the source chain identifier
82     // @param _srcAddress - the source chain contract address
83     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
84 
85     // @notice query if the _libraryAddress is valid for sending msgs.
86     // @param _userApplication - the user app address on this EVM chain
87     function getSendLibraryAddress(address _userApplication) external view returns (address);
88 
89     // @notice query if the _libraryAddress is valid for receiving msgs.
90     // @param _userApplication - the user app address on this EVM chain
91     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
92 
93     // @notice query if the non-reentrancy guard for send() is on
94     // @return true if the guard is on. false otherwise
95     function isSendingPayload() external view returns (bool);
96 
97     // @notice query if the non-reentrancy guard for receive() is on
98     // @return true if the guard is on. false otherwise
99     function isReceivingPayload() external view returns (bool);
100 
101     // @notice get the configuration of the LayerZero messaging library of the specified version
102     // @param _version - messaging library version
103     // @param _chainId - the chainId for the pending config change
104     // @param _userApplication - the contract address of the user application
105     // @param _configType - type of configuration. every messaging library has its own convention.
106     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
107 
108     // @notice get the send() LayerZero messaging library version
109     // @param _userApplication - the contract address of the user application
110     function getSendVersion(address _userApplication) external view returns (uint16);
111 
112     // @notice get the lzReceive() LayerZero messaging library version
113     // @param _userApplication - the contract address of the user application
114     function getReceiveVersion(address _userApplication) external view returns (uint16);
115 }
116 // File: contracts/interfaces/ILayerZeroReceiver.sol
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
130 // File: @openzeppelin/contracts/utils/Strings.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev String operations.
139  */
140 library Strings {
141     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
142 
143     /**
144      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
145      */
146     function toString(uint256 value) internal pure returns (string memory) {
147         // Inspired by OraclizeAPI's implementation - MIT licence
148         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
149 
150         if (value == 0) {
151             return "0";
152         }
153         uint256 temp = value;
154         uint256 digits;
155         while (temp != 0) {
156             digits++;
157             temp /= 10;
158         }
159         bytes memory buffer = new bytes(digits);
160         while (value != 0) {
161             digits -= 1;
162             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
163             value /= 10;
164         }
165         return string(buffer);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
170      */
171     function toHexString(uint256 value) internal pure returns (string memory) {
172         if (value == 0) {
173             return "0x00";
174         }
175         uint256 temp = value;
176         uint256 length = 0;
177         while (temp != 0) {
178             length++;
179             temp >>= 8;
180         }
181         return toHexString(value, length);
182     }
183 
184     /**
185      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
186      */
187     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
188         bytes memory buffer = new bytes(2 * length + 2);
189         buffer[0] = "0";
190         buffer[1] = "x";
191         for (uint256 i = 2 * length + 1; i > 1; --i) {
192             buffer[i] = _HEX_SYMBOLS[value & 0xf];
193             value >>= 4;
194         }
195         require(value == 0, "Strings: hex length insufficient");
196         return string(buffer);
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/Context.sol
201 
202 
203 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev Provides information about the current execution context, including the
209  * sender of the transaction and its data. While these are generally available
210  * via msg.sender and msg.data, they should not be accessed in such a direct
211  * manner, since when dealing with meta-transactions the account sending and
212  * paying for execution may not be the actual sender (as far as an application
213  * is concerned).
214  *
215  * This contract is only required for intermediate, library-like contracts.
216  */
217 abstract contract Context {
218     function _msgSender() internal view virtual returns (address) {
219         return msg.sender;
220     }
221 
222     function _msgData() internal view virtual returns (bytes calldata) {
223         return msg.data;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/access/Ownable.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 
235 /**
236  * @dev Contract module which provides a basic access control mechanism, where
237  * there is an account (an owner) that can be granted exclusive access to
238  * specific functions.
239  *
240  * By default, the owner account will be the one that deploys the contract. This
241  * can later be changed with {transferOwnership}.
242  *
243  * This module is used through inheritance. It will make available the modifier
244  * `onlyOwner`, which can be applied to your functions to restrict their use to
245  * the owner.
246  */
247 abstract contract Ownable is Context {
248     address private _owner;
249 
250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
251 
252     /**
253      * @dev Initializes the contract setting the deployer as the initial owner.
254      */
255     constructor() {
256         _transferOwnership(_msgSender());
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view virtual returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         _transferOwnership(address(0));
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      * Internal function without access restriction.
297      */
298     function _transferOwnership(address newOwner) internal virtual {
299         address oldOwner = _owner;
300         _owner = newOwner;
301         emit OwnershipTransferred(oldOwner, newOwner);
302     }
303 }
304 
305 // File: contracts/NonBlockingReceiver.sol
306 
307 pragma solidity 0.8.4;
308 
309 
310 
311 
312 
313 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
314     ILayerZeroEndpoint public endpoint;
315 
316     struct FailedMessages {
317         uint payloadLength;
318         bytes32 payloadHash;
319     }
320 
321     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
322     mapping(uint16 => bytes) public trustedSourceLookup;
323 
324     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
325 
326     // abstract function
327     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
328 
329     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
330         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
331         require(_srcAddress.length == trustedSourceLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedSourceLookup[_srcChainId]), "NonblockingReceiver: invalid source sending contract");
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
347         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
348     }
349 
350     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
351         endpoint.send{value: msg.value}(_dstChainId, trustedSourceLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
352     }
353 
354     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
355         // assert there is message to retry
356         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
357         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
358         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
359         // clear the stored message
360         failedMsg.payloadLength = 0;
361         failedMsg.payloadHash = bytes32(0);
362         // execute the message. revert if it fails again
363         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
364     }
365 
366     function setTrustedSource(uint16 _chainId, bytes calldata _trustedSource) external onlyOwner {
367         require(trustedSourceLookup[_chainId].length == 0, "The trusted source address has already been set for the chainId!");
368         trustedSourceLookup[_chainId] = _trustedSource;
369     }
370 }
371 // File: @openzeppelin/contracts/utils/Address.sol
372 
373 
374 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
375 
376 pragma solidity ^0.8.1;
377 
378 /**
379  * @dev Collection of functions related to the address type
380  */
381 library Address {
382     /**
383      * @dev Returns true if `account` is a contract.
384      *
385      * [IMPORTANT]
386      * ====
387      * It is unsafe to assume that an address for which this function returns
388      * false is an externally-owned account (EOA) and not a contract.
389      *
390      * Among others, `isContract` will return false for the following
391      * types of addresses:
392      *
393      *  - an externally-owned account
394      *  - a contract in construction
395      *  - an address where a contract will be created
396      *  - an address where a contract lived, but was destroyed
397      * ====
398      *
399      * [IMPORTANT]
400      * ====
401      * You shouldn't rely on `isContract` to protect against flash loan attacks!
402      *
403      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
404      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
405      * constructor.
406      * ====
407      */
408     function isContract(address account) internal view returns (bool) {
409         // This method relies on extcodesize/address.code.length, which returns 0
410         // for contracts in construction, since the code is only stored at the end
411         // of the constructor execution.
412 
413         return account.code.length > 0;
414     }
415 
416     /**
417      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
418      * `recipient`, forwarding all available gas and reverting on errors.
419      *
420      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
421      * of certain opcodes, possibly making contracts go over the 2300 gas limit
422      * imposed by `transfer`, making them unable to receive funds via
423      * `transfer`. {sendValue} removes this limitation.
424      *
425      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
426      *
427      * IMPORTANT: because control is transferred to `recipient`, care must be
428      * taken to not create reentrancy vulnerabilities. Consider using
429      * {ReentrancyGuard} or the
430      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
431      */
432     function sendValue(address payable recipient, uint256 amount) internal {
433         require(address(this).balance >= amount, "Address: insufficient balance");
434 
435         (bool success, ) = recipient.call{value: amount}("");
436         require(success, "Address: unable to send value, recipient may have reverted");
437     }
438 
439     /**
440      * @dev Performs a Solidity function call using a low level `call`. A
441      * plain `call` is an unsafe replacement for a function call: use this
442      * function instead.
443      *
444      * If `target` reverts with a revert reason, it is bubbled up by this
445      * function (like regular Solidity function calls).
446      *
447      * Returns the raw returned data. To convert to the expected return value,
448      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
449      *
450      * Requirements:
451      *
452      * - `target` must be a contract.
453      * - calling `target` with `data` must not revert.
454      *
455      * _Available since v3.1._
456      */
457     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
458         return functionCall(target, data, "Address: low-level call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
463      * `errorMessage` as a fallback revert reason when `target` reverts.
464      *
465      * _Available since v3.1._
466      */
467     function functionCall(
468         address target,
469         bytes memory data,
470         string memory errorMessage
471     ) internal returns (bytes memory) {
472         return functionCallWithValue(target, data, 0, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but also transferring `value` wei to `target`.
478      *
479      * Requirements:
480      *
481      * - the calling contract must have an ETH balance of at least `value`.
482      * - the called Solidity function must be `payable`.
483      *
484      * _Available since v3.1._
485      */
486     function functionCallWithValue(
487         address target,
488         bytes memory data,
489         uint256 value
490     ) internal returns (bytes memory) {
491         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
496      * with `errorMessage` as a fallback revert reason when `target` reverts.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(
501         address target,
502         bytes memory data,
503         uint256 value,
504         string memory errorMessage
505     ) internal returns (bytes memory) {
506         require(address(this).balance >= value, "Address: insufficient balance for call");
507         require(isContract(target), "Address: call to non-contract");
508 
509         (bool success, bytes memory returndata) = target.call{value: value}(data);
510         return verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but performing a static call.
516      *
517      * _Available since v3.3._
518      */
519     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
520         return functionStaticCall(target, data, "Address: low-level static call failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
525      * but performing a static call.
526      *
527      * _Available since v3.3._
528      */
529     function functionStaticCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal view returns (bytes memory) {
534         require(isContract(target), "Address: static call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.staticcall(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but performing a delegate call.
543      *
544      * _Available since v3.4._
545      */
546     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
547         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
552      * but performing a delegate call.
553      *
554      * _Available since v3.4._
555      */
556     function functionDelegateCall(
557         address target,
558         bytes memory data,
559         string memory errorMessage
560     ) internal returns (bytes memory) {
561         require(isContract(target), "Address: delegate call to non-contract");
562 
563         (bool success, bytes memory returndata) = target.delegatecall(data);
564         return verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     /**
568      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
569      * revert reason using the provided one.
570      *
571      * _Available since v4.3._
572      */
573     function verifyCallResult(
574         bool success,
575         bytes memory returndata,
576         string memory errorMessage
577     ) internal pure returns (bytes memory) {
578         if (success) {
579             return returndata;
580         } else {
581             // Look for revert reason and bubble it up if present
582             if (returndata.length > 0) {
583                 // The easiest way to bubble the revert reason is using memory via assembly
584 
585                 assembly {
586                     let returndata_size := mload(returndata)
587                     revert(add(32, returndata), returndata_size)
588                 }
589             } else {
590                 revert(errorMessage);
591             }
592         }
593     }
594 }
595 
596 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @title ERC721 token receiver interface
605  * @dev Interface for any contract that wants to support safeTransfers
606  * from ERC721 asset contracts.
607  */
608 interface IERC721Receiver {
609     /**
610      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
611      * by `operator` from `from`, this function is called.
612      *
613      * It must return its Solidity selector to confirm the token transfer.
614      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
615      *
616      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
617      */
618     function onERC721Received(
619         address operator,
620         address from,
621         uint256 tokenId,
622         bytes calldata data
623     ) external returns (bytes4);
624 }
625 
626 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev Interface of the ERC165 standard, as defined in the
635  * https://eips.ethereum.org/EIPS/eip-165[EIP].
636  *
637  * Implementers can declare support of contract interfaces, which can then be
638  * queried by others ({ERC165Checker}).
639  *
640  * For an implementation, see {ERC165}.
641  */
642 interface IERC165 {
643     /**
644      * @dev Returns true if this contract implements the interface defined by
645      * `interfaceId`. See the corresponding
646      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
647      * to learn more about how these ids are created.
648      *
649      * This function call must use less than 30 000 gas.
650      */
651     function supportsInterface(bytes4 interfaceId) external view returns (bool);
652 }
653 
654 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
655 
656 
657 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 
662 /**
663  * @dev Implementation of the {IERC165} interface.
664  *
665  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
666  * for the additional interface id that will be supported. For example:
667  *
668  * ```solidity
669  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
670  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
671  * }
672  * ```
673  *
674  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
675  */
676 abstract contract ERC165 is IERC165 {
677     /**
678      * @dev See {IERC165-supportsInterface}.
679      */
680     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
681         return interfaceId == type(IERC165).interfaceId;
682     }
683 }
684 
685 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 /**
694  * @dev Required interface of an ERC721 compliant contract.
695  */
696 interface IERC721 is IERC165 {
697     /**
698      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
699      */
700     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
701 
702     /**
703      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
704      */
705     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
706 
707     /**
708      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
709      */
710     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
711 
712     /**
713      * @dev Returns the number of tokens in ``owner``'s account.
714      */
715     function balanceOf(address owner) external view returns (uint256 balance);
716 
717     /**
718      * @dev Returns the owner of the `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function ownerOf(uint256 tokenId) external view returns (address owner);
725 
726     /**
727      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
728      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
729      *
730      * Requirements:
731      *
732      * - `from` cannot be the zero address.
733      * - `to` cannot be the zero address.
734      * - `tokenId` token must exist and be owned by `from`.
735      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
737      *
738      * Emits a {Transfer} event.
739      */
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) external;
745 
746     /**
747      * @dev Transfers `tokenId` token from `from` to `to`.
748      *
749      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
750      *
751      * Requirements:
752      *
753      * - `from` cannot be the zero address.
754      * - `to` cannot be the zero address.
755      * - `tokenId` token must be owned by `from`.
756      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
757      *
758      * Emits a {Transfer} event.
759      */
760     function transferFrom(
761         address from,
762         address to,
763         uint256 tokenId
764     ) external;
765 
766     /**
767      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
768      * The approval is cleared when the token is transferred.
769      *
770      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
771      *
772      * Requirements:
773      *
774      * - The caller must own the token or be an approved operator.
775      * - `tokenId` must exist.
776      *
777      * Emits an {Approval} event.
778      */
779     function approve(address to, uint256 tokenId) external;
780 
781     /**
782      * @dev Returns the account approved for `tokenId` token.
783      *
784      * Requirements:
785      *
786      * - `tokenId` must exist.
787      */
788     function getApproved(uint256 tokenId) external view returns (address operator);
789 
790     /**
791      * @dev Approve or remove `operator` as an operator for the caller.
792      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
793      *
794      * Requirements:
795      *
796      * - The `operator` cannot be the caller.
797      *
798      * Emits an {ApprovalForAll} event.
799      */
800     function setApprovalForAll(address operator, bool _approved) external;
801 
802     /**
803      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
804      *
805      * See {setApprovalForAll}
806      */
807     function isApprovedForAll(address owner, address operator) external view returns (bool);
808 
809     /**
810      * @dev Safely transfers `tokenId` token from `from` to `to`.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must exist and be owned by `from`.
817      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
819      *
820      * Emits a {Transfer} event.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId,
826         bytes calldata data
827     ) external;
828 }
829 
830 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
831 
832 
833 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
834 
835 pragma solidity ^0.8.0;
836 
837 
838 /**
839  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
840  * @dev See https://eips.ethereum.org/EIPS/eip-721
841  */
842 interface IERC721Metadata is IERC721 {
843     /**
844      * @dev Returns the token collection name.
845      */
846     function name() external view returns (string memory);
847 
848     /**
849      * @dev Returns the token collection symbol.
850      */
851     function symbol() external view returns (string memory);
852 
853     /**
854      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
855      */
856     function tokenURI(uint256 tokenId) external view returns (string memory);
857 }
858 
859 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
860 
861 
862 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
863 
864 pragma solidity ^0.8.0;
865 
866 
867 
868 
869 
870 
871 
872 
873 /**
874  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
875  * the Metadata extension, but not including the Enumerable extension, which is available separately as
876  * {ERC721Enumerable}.
877  */
878 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
879     using Address for address;
880     using Strings for uint256;
881 
882     // Token name
883     string private _name;
884 
885     // Token symbol
886     string private _symbol;
887 
888     // Mapping from token ID to owner address
889     mapping(uint256 => address) private _owners;
890 
891     // Mapping owner address to token count
892     mapping(address => uint256) private _balances;
893 
894     // Mapping from token ID to approved address
895     mapping(uint256 => address) private _tokenApprovals;
896 
897     // Mapping from owner to operator approvals
898     mapping(address => mapping(address => bool)) private _operatorApprovals;
899 
900     /**
901      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
902      */
903     constructor(string memory name_, string memory symbol_) {
904         _name = name_;
905         _symbol = symbol_;
906     }
907 
908     /**
909      * @dev See {IERC165-supportsInterface}.
910      */
911     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
912         return
913             interfaceId == type(IERC721).interfaceId ||
914             interfaceId == type(IERC721Metadata).interfaceId ||
915             super.supportsInterface(interfaceId);
916     }
917 
918     /**
919      * @dev See {IERC721-balanceOf}.
920      */
921     function balanceOf(address owner) public view virtual override returns (uint256) {
922         require(owner != address(0), "ERC721: balance query for the zero address");
923         return _balances[owner];
924     }
925 
926     /**
927      * @dev See {IERC721-ownerOf}.
928      */
929     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
930         address owner = _owners[tokenId];
931         require(owner != address(0), "ERC721: owner query for nonexistent token");
932         return owner;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-name}.
937      */
938     function name() public view virtual override returns (string memory) {
939         return _name;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-symbol}.
944      */
945     function symbol() public view virtual override returns (string memory) {
946         return _symbol;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-tokenURI}.
951      */
952     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
953         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
954 
955         string memory baseURI = _baseURI();
956         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
957     }
958 
959     /**
960      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
961      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
962      * by default, can be overriden in child contracts.
963      */
964     function _baseURI() internal view virtual returns (string memory) {
965         return "";
966     }
967 
968     /**
969      * @dev See {IERC721-approve}.
970      */
971     function approve(address to, uint256 tokenId) public virtual override {
972         address owner = ERC721.ownerOf(tokenId);
973         require(to != owner, "ERC721: approval to current owner");
974 
975         require(
976             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
977             "ERC721: approve caller is not owner nor approved for all"
978         );
979 
980         _approve(to, tokenId);
981     }
982 
983     /**
984      * @dev See {IERC721-getApproved}.
985      */
986     function getApproved(uint256 tokenId) public view virtual override returns (address) {
987         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
988 
989         return _tokenApprovals[tokenId];
990     }
991 
992     /**
993      * @dev See {IERC721-setApprovalForAll}.
994      */
995     function setApprovalForAll(address operator, bool approved) public virtual override {
996         _setApprovalForAll(_msgSender(), operator, approved);
997     }
998 
999     /**
1000      * @dev See {IERC721-isApprovedForAll}.
1001      */
1002     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1003         return _operatorApprovals[owner][operator];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-transferFrom}.
1008      */
1009     function transferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         //solhint-disable-next-line max-line-length
1015         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1016 
1017         _transfer(from, to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) public virtual override {
1028         safeTransferFrom(from, to, tokenId, "");
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-safeTransferFrom}.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) public virtual override {
1040         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1041         _safeTransfer(from, to, tokenId, _data);
1042     }
1043 
1044     /**
1045      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1046      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1047      *
1048      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1049      *
1050      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1051      * implement alternative mechanisms to perform token transfer, such as signature-based.
1052      *
1053      * Requirements:
1054      *
1055      * - `from` cannot be the zero address.
1056      * - `to` cannot be the zero address.
1057      * - `tokenId` token must exist and be owned by `from`.
1058      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _safeTransfer(
1063         address from,
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) internal virtual {
1068         _transfer(from, to, tokenId);
1069         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1070     }
1071 
1072     /**
1073      * @dev Returns whether `tokenId` exists.
1074      *
1075      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1076      *
1077      * Tokens start existing when they are minted (`_mint`),
1078      * and stop existing when they are burned (`_burn`).
1079      */
1080     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1081         return _owners[tokenId] != address(0);
1082     }
1083 
1084     /**
1085      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must exist.
1090      */
1091     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1092         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1093         address owner = ERC721.ownerOf(tokenId);
1094         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1095     }
1096 
1097     /**
1098      * @dev Safely mints `tokenId` and transfers it to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `tokenId` must not exist.
1103      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _safeMint(address to, uint256 tokenId) internal virtual {
1108         _safeMint(to, tokenId, "");
1109     }
1110 
1111     /**
1112      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1113      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1114      */
1115     function _safeMint(
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) internal virtual {
1120         _mint(to, tokenId);
1121         require(
1122             _checkOnERC721Received(address(0), to, tokenId, _data),
1123             "ERC721: transfer to non ERC721Receiver implementer"
1124         );
1125     }
1126 
1127     /**
1128      * @dev Mints `tokenId` and transfers it to `to`.
1129      *
1130      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1131      *
1132      * Requirements:
1133      *
1134      * - `tokenId` must not exist.
1135      * - `to` cannot be the zero address.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _mint(address to, uint256 tokenId) internal virtual {
1140         require(to != address(0), "ERC721: mint to the zero address");
1141         require(!_exists(tokenId), "ERC721: token already minted");
1142 
1143         _beforeTokenTransfer(address(0), to, tokenId);
1144 
1145         _balances[to] += 1;
1146         _owners[tokenId] = to;
1147 
1148         emit Transfer(address(0), to, tokenId);
1149 
1150         _afterTokenTransfer(address(0), to, tokenId);
1151     }
1152 
1153     /**
1154      * @dev Destroys `tokenId`.
1155      * The approval is cleared when the token is burned.
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must exist.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _burn(uint256 tokenId) internal virtual {
1164         address owner = ERC721.ownerOf(tokenId);
1165 
1166         _beforeTokenTransfer(owner, address(0), tokenId);
1167 
1168         // Clear approvals
1169         _approve(address(0), tokenId);
1170 
1171         _balances[owner] -= 1;
1172         delete _owners[tokenId];
1173 
1174         emit Transfer(owner, address(0), tokenId);
1175 
1176         _afterTokenTransfer(owner, address(0), tokenId);
1177     }
1178 
1179     /**
1180      * @dev Transfers `tokenId` from `from` to `to`.
1181      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must be owned by `from`.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _transfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) internal virtual {
1195         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1196         require(to != address(0), "ERC721: transfer to the zero address");
1197 
1198         _beforeTokenTransfer(from, to, tokenId);
1199 
1200         // Clear approvals from the previous owner
1201         _approve(address(0), tokenId);
1202 
1203         _balances[from] -= 1;
1204         _balances[to] += 1;
1205         _owners[tokenId] = to;
1206 
1207         emit Transfer(from, to, tokenId);
1208 
1209         _afterTokenTransfer(from, to, tokenId);
1210     }
1211 
1212     /**
1213      * @dev Approve `to` to operate on `tokenId`
1214      *
1215      * Emits a {Approval} event.
1216      */
1217     function _approve(address to, uint256 tokenId) internal virtual {
1218         _tokenApprovals[tokenId] = to;
1219         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1220     }
1221 
1222     /**
1223      * @dev Approve `operator` to operate on all of `owner` tokens
1224      *
1225      * Emits a {ApprovalForAll} event.
1226      */
1227     function _setApprovalForAll(
1228         address owner,
1229         address operator,
1230         bool approved
1231     ) internal virtual {
1232         require(owner != operator, "ERC721: approve to caller");
1233         _operatorApprovals[owner][operator] = approved;
1234         emit ApprovalForAll(owner, operator, approved);
1235     }
1236 
1237     /**
1238      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1239      * The call is not executed if the target address is not a contract.
1240      *
1241      * @param from address representing the previous owner of the given token ID
1242      * @param to target address that will receive the tokens
1243      * @param tokenId uint256 ID of the token to be transferred
1244      * @param _data bytes optional data to send along with the call
1245      * @return bool whether the call correctly returned the expected magic value
1246      */
1247     function _checkOnERC721Received(
1248         address from,
1249         address to,
1250         uint256 tokenId,
1251         bytes memory _data
1252     ) private returns (bool) {
1253         if (to.isContract()) {
1254             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1255                 return retval == IERC721Receiver.onERC721Received.selector;
1256             } catch (bytes memory reason) {
1257                 if (reason.length == 0) {
1258                     revert("ERC721: transfer to non ERC721Receiver implementer");
1259                 } else {
1260                     assembly {
1261                         revert(add(32, reason), mload(reason))
1262                     }
1263                 }
1264             }
1265         } else {
1266             return true;
1267         }
1268     }
1269 
1270     /**
1271      * @dev Hook that is called before any token transfer. This includes minting
1272      * and burning.
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` will be minted for `to`.
1279      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1280      * - `from` and `to` are never both zero.
1281      *
1282      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1283      */
1284     function _beforeTokenTransfer(
1285         address from,
1286         address to,
1287         uint256 tokenId
1288     ) internal virtual {}
1289 
1290     /**
1291      * @dev Hook that is called after any transfer of tokens. This includes
1292      * minting and burning.
1293      *
1294      * Calling conditions:
1295      *
1296      * - when `from` and `to` are both non-zero.
1297      * - `from` and `to` are never both zero.
1298      *
1299      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1300      */
1301     function _afterTokenTransfer(
1302         address from,
1303         address to,
1304         uint256 tokenId
1305     ) internal virtual {}
1306 }
1307 
1308 // File: contracts/LittleMouse.sol
1309 
1310 
1311 
1312 pragma solidity 0.8.4;
1313 
1314 
1315 
1316 
1317 /// @title A LayerZero OmnichainNonFungibleToken example
1318 /// @author sirarthurmoney
1319 /// @notice You can use this to mint ONFT and transfer across chain
1320 /// @dev All function calls are currently implemented without side effects
1321 contract LittleMouse is ERC721, NonblockingReceiver, ILayerZeroUserApplicationConfig {
1322 
1323     string public baseTokenURI;
1324     string public thecontractURI;
1325     uint256 public gasForDestinationLzReceive = 350000;
1326 
1327     uint256 nextTokenId;
1328     uint256 maxMint;
1329     uint256 public publicSaleStartTime = 0;
1330     uint256 public maxMintPerWallet = 10;
1331     uint256 public maxMintPerTx = 2;
1332     mapping(address => uint256) public minted;
1333 
1334     /// @notice Constructor for the OmnichainNonFungibleToken
1335     /// @param _baseTokenURI the Uniform Resource Identifier (URI) for tokenId token
1336     /// @param _layerZeroEndpoint handles message transmission across chains
1337     /// @param _startToken the starting mint number on this chain
1338     /// @param _maxMint the max number of mints on this chain
1339     constructor(
1340         string memory _baseTokenURI,
1341         string memory _contractURI,
1342         address _layerZeroEndpoint,
1343         uint256 _startToken,
1344         uint256 _maxMint
1345     )
1346     ERC721("Little Mouse", "LMOUSE"){
1347         setBaseURI(_baseTokenURI);
1348         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1349         nextTokenId = _startToken;
1350         maxMint = _maxMint;
1351     }
1352 
1353     function setPublicSaleStartTime(uint256 newTime) public onlyOwner {
1354         publicSaleStartTime = newTime;
1355     }
1356 
1357     function setMaxMintPerWallet(uint256 newMaxMintPerWallet) external onlyOwner {
1358         maxMintPerWallet = newMaxMintPerWallet;
1359     }
1360 
1361     function setMaxMintPerTx(uint256 newMaxMintPerTx) external onlyOwner {
1362         maxMintPerTx = newMaxMintPerTx;
1363     }
1364 
1365     function setContractURI(string memory _contractURI) public onlyOwner {
1366         thecontractURI = _contractURI;
1367     }
1368 
1369     /**
1370      * pre-mint for community giveaways
1371      */
1372     function giveawayMint(uint8 numTokens) public onlyOwner {
1373         require(nextTokenId + numTokens <= maxMint, "Mint exceeds supply");
1374         
1375         for (uint256 i = 0; i < numTokens; i++) {
1376             _safeMint(msg.sender, ++nextTokenId);
1377         }
1378     }
1379 
1380     /// @notice Mint your OmnichainNonFungibleToken
1381     function mint(uint8 numTokens) external payable {
1382         require(msg.sender == tx.origin, "User wallet required");
1383         require(publicSaleStartTime != 0 && publicSaleStartTime <= block.timestamp, "sales is not started");
1384 
1385         require(numTokens <= maxMintPerTx, "Max 2 NFTs per transaction");
1386         require(minted[msg.sender] + numTokens <= maxMintPerWallet, "limit per wallet reached");
1387         require(nextTokenId + numTokens <= maxMint, "Mint exceeds supply");
1388 
1389         for (uint i=0; i < numTokens; i++) {
1390             _safeMint(msg.sender, ++nextTokenId);
1391         }
1392 
1393         minted[msg.sender] += numTokens;
1394     }
1395 
1396     /// @notice Burn _tokenId on source chain and mint on destination chain
1397     /// @param _chainId the destination chain id you want to transfer too
1398     /// @param _tokenId the id of the NFT you want to transfer
1399  function traverseChains(
1400         uint16 _chainId,
1401         uint256 _tokenId
1402     ) public payable {
1403         require(msg.sender == ownerOf(_tokenId), "Message sender must own the Little Mouse.");
1404         require(trustedSourceLookup[_chainId].length != 0, "This chain is not a trusted source source.");
1405 
1406         // burn NFT on source chain
1407          _burn(_tokenId);
1408 
1409         // encode payload w/ sender address and NFT token id
1410         bytes memory payload = abi.encode(msg.sender, _tokenId);
1411 
1412         // encode adapterParams w/ extra gas for destination chain
1413         uint16 version = 1;
1414         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1415 
1416         // use LayerZero estimateFees for cross chain delivery
1417         (uint quotedLayerZeroFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1418 
1419         require(
1420             msg.value >= quotedLayerZeroFee,
1421             "Little Mouse: msg.value not enough to cover messageFee. Send gas for message fees"
1422         );
1423 
1424         endpoint.send{value:msg.value}(
1425             _chainId,                      // destination chainId
1426             trustedSourceLookup[_chainId], // destination address of nft
1427             payload,                       // abi.encode()'ed bytes
1428             payable(msg.sender),           // refund address
1429             address(0x0),                  // future parameter
1430             adapterParams                  // adapterParams
1431         );
1432     }
1433 
1434     /// @notice Set the baseTokenURI
1435     /// @param _baseTokenURI to set
1436     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
1437         baseTokenURI = _baseTokenURI;
1438     }
1439 
1440     /// @notice Get the contract URI
1441     function contractURI() public view returns (string memory) {
1442         return thecontractURI;
1443     }
1444 
1445     /// @notice Get the base URI
1446     function _baseURI() override internal view returns (string memory) {
1447         return baseTokenURI;
1448     }
1449 
1450     /// @notice Override the _LzReceive internal function of the NonblockingReceiver
1451     // @param _srcChainId - the source endpoint identifier
1452     // @param _srcAddress - the source sending contract address from the source chain
1453     // @param _nonce - the ordered message nonce
1454     // @param _payload - the signed payload is the UA bytes has encoded to be sent
1455     /// @dev safe mints the ONFT on your destination chain
1456     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal override  {
1457         (address _dstOmnichainNFTAddress, uint256 omnichainNFT_tokenId) = abi.decode(_payload, (address, uint256));
1458         _safeMint(_dstOmnichainNFTAddress, omnichainNFT_tokenId);
1459     }
1460 
1461     function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1462         gasForDestinationLzReceive = newVal;
1463     }
1464     //---------------------------DAO CALL----------------------------------------
1465     // generic config for user Application
1466     function setConfig(
1467         uint16 _version,
1468         uint16 _chainId,
1469         uint256 _configType,
1470         bytes calldata _config
1471     ) external override onlyOwner {
1472         endpoint.setConfig(_version, _chainId, _configType, _config);
1473     }
1474 
1475     function setSendVersion(uint16 _version) external override onlyOwner {
1476         endpoint.setSendVersion(_version);
1477     }
1478 
1479     function setReceiveVersion(uint16 _version) external override onlyOwner {
1480         endpoint.setReceiveVersion(_version);
1481     }
1482 
1483     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external override onlyOwner {
1484         endpoint.forceResumeReceive(_srcChainId, _srcAddress);
1485     }
1486 
1487     function renounceOwnership() public override onlyOwner {}
1488 }