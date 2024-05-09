1 //tiny criminals robbing and stealing across all chains..claim new weapons, cars, tools, booze, and other fun things.
2 //SPDX-License-Identifier: MIT
3 // File: /ILayerZeroReceiver.sol
4 
5 
6 
7 pragma solidity >=0.5.0;
8 
9 interface ILayerZeroReceiver {
10     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
11     // @param _srcChainId - the source endpoint identifier
12     // @param _srcAddress - the source sending contract address from the source chain
13     // @param _nonce - the ordered message nonce
14     // @param _payload - the signed payload is the UA bytes has encoded to be sent
15     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
16 }
17 // File: /ILayerZeroUserApplicationConfig.sol
18 
19 
20 
21 pragma solidity >=0.5.0;
22 
23 interface ILayerZeroUserApplicationConfig {
24     // @notice set the configuration of the LayerZero messaging library of the specified version
25     // @param _version - messaging library version
26     // @param _chainId - the chainId for the pending config change
27     // @param _configType - type of configuration. every messaging library has its own convention.
28     // @param _config - configuration in the bytes. can encode arbitrary content.
29     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
30 
31     // @notice set the send() LayerZero messaging library version to _version
32     // @param _version - new messaging library version
33     function setSendVersion(uint16 _version) external;
34 
35     // @notice set the lzReceive() LayerZero messaging library version to _version
36     // @param _version - new messaging library version
37     function setReceiveVersion(uint16 _version) external;
38 
39     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
40     // @param _srcChainId - the chainId of the source chain
41     // @param _srcAddress - the contract address of the source contract at the source chain
42     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
43 }
44 // File: /ILayerZeroEndpoint.sol
45 
46 
47 
48 pragma solidity >=0.5.0;
49 
50 
51 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
52     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
53     // @param _dstChainId - the destination chain identifier
54     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
55     // @param _payload - a custom bytes payload to send to the destination contract
56     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
57     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
58     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
59     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
60 
61     // @notice used by the messaging library to publish verified payload
62     // @param _srcChainId - the source chain identifier
63     // @param _srcAddress - the source contract (as bytes) at the source chain
64     // @param _dstAddress - the address on destination chain
65     // @param _nonce - the unbound message ordering nonce
66     // @param _gasLimit - the gas limit for external contract execution
67     // @param _payload - verified payload to send to the destination contract
68     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
69 
70     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
71     // @param _srcChainId - the source chain identifier
72     // @param _srcAddress - the source chain contract address
73     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
74 
75     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
76     // @param _srcAddress - the source chain contract address
77     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
78 
79     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
80     // @param _dstChainId - the destination chain identifier
81     // @param _userApplication - the user app address on this EVM chain
82     // @param _payload - the custom message to send over LayerZero
83     // @param _payInZRO - if false, user app pays the protocol fee in native token
84     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
85     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
86 
87     // @notice get this Endpoint's immutable source identifier
88     function getChainId() external view returns (uint16);
89 
90     // @notice the interface to retry failed message on this Endpoint destination
91     // @param _srcChainId - the source chain identifier
92     // @param _srcAddress - the source chain contract address
93     // @param _payload - the payload to be retried
94     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
95 
96     // @notice query if any STORED payload (message blocking) at the endpoint.
97     // @param _srcChainId - the source chain identifier
98     // @param _srcAddress - the source chain contract address
99     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
100 
101     // @notice query if the _libraryAddress is valid for sending msgs.
102     // @param _userApplication - the user app address on this EVM chain
103     function getSendLibraryAddress(address _userApplication) external view returns (address);
104 
105     // @notice query if the _libraryAddress is valid for receiving msgs.
106     // @param _userApplication - the user app address on this EVM chain
107     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
108 
109     // @notice query if the non-reentrancy guard for send() is on
110     // @return true if the guard is on. false otherwise
111     function isSendingPayload() external view returns (bool);
112 
113     // @notice query if the non-reentrancy guard for receive() is on
114     // @return true if the guard is on. false otherwise
115     function isReceivingPayload() external view returns (bool);
116 
117     // @notice get the configuration of the LayerZero messaging library of the specified version
118     // @param _version - messaging library version
119     // @param _chainId - the chainId for the pending config change
120     // @param _userApplication - the contract address of the user application
121     // @param _configType - type of configuration. every messaging library has its own convention.
122     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
123 
124     // @notice get the send() LayerZero messaging library version
125     // @param _userApplication - the contract address of the user application
126     function getSendVersion(address _userApplication) external view returns (uint16);
127 
128     // @notice get the lzReceive() LayerZero messaging library version
129     // @param _userApplication - the contract address of the user application
130     function getReceiveVersion(address _userApplication) external view returns (uint16);
131 }
132 // File: @openzeppelin/contracts/utils/Strings.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev String operations.
141  */
142 library Strings {
143     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
144 
145     /**
146      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
147      */
148     function toString(uint256 value) internal pure returns (string memory) {
149         // Inspired by OraclizeAPI's implementation - MIT licence
150         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
151 
152         if (value == 0) {
153             return "0";
154         }
155         uint256 temp = value;
156         uint256 digits;
157         while (temp != 0) {
158             digits++;
159             temp /= 10;
160         }
161         bytes memory buffer = new bytes(digits);
162         while (value != 0) {
163             digits -= 1;
164             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
165             value /= 10;
166         }
167         return string(buffer);
168     }
169 
170     /**
171      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
172      */
173     function toHexString(uint256 value) internal pure returns (string memory) {
174         if (value == 0) {
175             return "0x00";
176         }
177         uint256 temp = value;
178         uint256 length = 0;
179         while (temp != 0) {
180             length++;
181             temp >>= 8;
182         }
183         return toHexString(value, length);
184     }
185 
186     /**
187      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
188      */
189     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
190         bytes memory buffer = new bytes(2 * length + 2);
191         buffer[0] = "0";
192         buffer[1] = "x";
193         for (uint256 i = 2 * length + 1; i > 1; --i) {
194             buffer[i] = _HEX_SYMBOLS[value & 0xf];
195             value >>= 4;
196         }
197         require(value == 0, "Strings: hex length insufficient");
198         return string(buffer);
199     }
200 }
201 
202 // File: @openzeppelin/contracts/utils/Context.sol
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @dev Provides information about the current execution context, including the
211  * sender of the transaction and its data. While these are generally available
212  * via msg.sender and msg.data, they should not be accessed in such a direct
213  * manner, since when dealing with meta-transactions the account sending and
214  * paying for execution may not be the actual sender (as far as an application
215  * is concerned).
216  *
217  * This contract is only required for intermediate, library-like contracts.
218  */
219 abstract contract Context {
220     function _msgSender() internal view virtual returns (address) {
221         return msg.sender;
222     }
223 
224     function _msgData() internal view virtual returns (bytes calldata) {
225         return msg.data;
226     }
227 }
228 
229 // File: @openzeppelin/contracts/access/Ownable.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 
237 /**
238  * @dev Contract module which provides a basic access control mechanism, where
239  * there is an account (an owner) that can be granted exclusive access to
240  * specific functions.
241  *
242  * By default, the owner account will be the one that deploys the contract. This
243  * can later be changed with {transferOwnership}.
244  *
245  * This module is used through inheritance. It will make available the modifier
246  * `onlyOwner`, which can be applied to your functions to restrict their use to
247  * the owner.
248  */
249 abstract contract Ownable is Context {
250     address private _owner;
251 
252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253 
254     /**
255      * @dev Initializes the contract setting the deployer as the initial owner.
256      */
257     constructor() {
258         _transferOwnership(_msgSender());
259     }
260 
261     /**
262      * @dev Returns the address of the current owner.
263      */
264     function owner() public view virtual returns (address) {
265         return _owner;
266     }
267 
268     /**
269      * @dev Throws if called by any account other than the owner.
270      */
271     modifier onlyOwner() {
272         require(owner() == _msgSender(), "Ownable: caller is not the owner");
273         _;
274     }
275 
276     /**
277      * @dev Leaves the contract without owner. It will not be possible to call
278      * `onlyOwner` functions anymore. Can only be called by the current owner.
279      *
280      * NOTE: Renouncing ownership will leave the contract without an owner,
281      * thereby removing any functionality that is only available to the owner.
282      */
283     function renounceOwnership() public virtual onlyOwner {
284         _transferOwnership(address(0));
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Can only be called by the current owner.
290      */
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         _transferOwnership(newOwner);
294     }
295 
296     /**
297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
298      * Internal function without access restriction.
299      */
300     function _transferOwnership(address newOwner) internal virtual {
301         address oldOwner = _owner;
302         _owner = newOwner;
303         emit OwnershipTransferred(oldOwner, newOwner);
304     }
305 }
306 
307 // File: /NonblockingReceiver.sol
308 
309 
310 pragma solidity ^0.8.9;
311 
312 
313 
314 
315 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
316 
317     ILayerZeroEndpoint internal endpoint;
318 
319     struct FailedMessages {
320         uint payloadLength;
321         bytes32 payloadHash;
322     }
323 
324     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
325     mapping(uint16 => bytes) public trustedRemoteLookup;
326 
327     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
328 
329     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
330         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
331         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]),
332             "NonblockingReceiver: invalid source sending contract");
333 
334         // try-catch all errors/exceptions
335         // having failed messages does not block messages passing
336         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
337             // do nothing
338         } catch {
339             // error / exception
340             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
341             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
342         }
343     }
344 
345     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
346         // only internal transaction
347         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
348 
349         // handle incoming message
350         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
351     }
352 
353     // abstract function
354     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
355 
356     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
357         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
358     }
359 
360     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
361         // assert there is message to retry
362         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
363         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
364         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
365         // clear the stored message
366         failedMsg.payloadLength = 0;
367         failedMsg.payloadHash = bytes32(0);
368         // execute the message. revert if it fails again
369         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
370     }
371 
372     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
373         trustedRemoteLookup[_chainId] = _trustedRemote;
374     }
375 }
376 // File: @openzeppelin/contracts/utils/Address.sol
377 
378 
379 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
380 
381 pragma solidity ^0.8.1;
382 
383 /**
384  * @dev Collection of functions related to the address type
385  */
386 library Address {
387     /**
388      * @dev Returns true if `account` is a contract.
389      *
390      * [IMPORTANT]
391      * ====
392      * It is unsafe to assume that an address for which this function returns
393      * false is an externally-owned account (EOA) and not a contract.
394      *
395      * Among others, `isContract` will return false for the following
396      * types of addresses:
397      *
398      *  - an externally-owned account
399      *  - a contract in construction
400      *  - an address where a contract will be created
401      *  - an address where a contract lived, but was destroyed
402      * ====
403      *
404      * [IMPORTANT]
405      * ====
406      * You shouldn't rely on `isContract` to protect against flash loan attacks!
407      *
408      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
409      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
410      * constructor.
411      * ====
412      */
413     function isContract(address account) internal view returns (bool) {
414         // This method relies on extcodesize/address.code.length, which returns 0
415         // for contracts in construction, since the code is only stored at the end
416         // of the constructor execution.
417 
418         return account.code.length > 0;
419     }
420 
421     /**
422      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
423      * `recipient`, forwarding all available gas and reverting on errors.
424      *
425      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
426      * of certain opcodes, possibly making contracts go over the 2300 gas limit
427      * imposed by `transfer`, making them unable to receive funds via
428      * `transfer`. {sendValue} removes this limitation.
429      *
430      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
431      *
432      * IMPORTANT: because control is transferred to `recipient`, care must be
433      * taken to not create reentrancy vulnerabilities. Consider using
434      * {ReentrancyGuard} or the
435      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
436      */
437     function sendValue(address payable recipient, uint256 amount) internal {
438         require(address(this).balance >= amount, "Address: insufficient balance");
439 
440         (bool success, ) = recipient.call{value: amount}("");
441         require(success, "Address: unable to send value, recipient may have reverted");
442     }
443 
444     /**
445      * @dev Performs a Solidity function call using a low level `call`. A
446      * plain `call` is an unsafe replacement for a function call: use this
447      * function instead.
448      *
449      * If `target` reverts with a revert reason, it is bubbled up by this
450      * function (like regular Solidity function calls).
451      *
452      * Returns the raw returned data. To convert to the expected return value,
453      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
454      *
455      * Requirements:
456      *
457      * - `target` must be a contract.
458      * - calling `target` with `data` must not revert.
459      *
460      * _Available since v3.1._
461      */
462     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
463         return functionCall(target, data, "Address: low-level call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
468      * `errorMessage` as a fallback revert reason when `target` reverts.
469      *
470      * _Available since v3.1._
471      */
472     function functionCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         return functionCallWithValue(target, data, 0, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but also transferring `value` wei to `target`.
483      *
484      * Requirements:
485      *
486      * - the calling contract must have an ETH balance of at least `value`.
487      * - the called Solidity function must be `payable`.
488      *
489      * _Available since v3.1._
490      */
491     function functionCallWithValue(
492         address target,
493         bytes memory data,
494         uint256 value
495     ) internal returns (bytes memory) {
496         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
501      * with `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCallWithValue(
506         address target,
507         bytes memory data,
508         uint256 value,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         require(address(this).balance >= value, "Address: insufficient balance for call");
512         require(isContract(target), "Address: call to non-contract");
513 
514         (bool success, bytes memory returndata) = target.call{value: value}(data);
515         return verifyCallResult(success, returndata, errorMessage);
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
520      * but performing a static call.
521      *
522      * _Available since v3.3._
523      */
524     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
525         return functionStaticCall(target, data, "Address: low-level static call failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
530      * but performing a static call.
531      *
532      * _Available since v3.3._
533      */
534     function functionStaticCall(
535         address target,
536         bytes memory data,
537         string memory errorMessage
538     ) internal view returns (bytes memory) {
539         require(isContract(target), "Address: static call to non-contract");
540 
541         (bool success, bytes memory returndata) = target.staticcall(data);
542         return verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a delegate call.
548      *
549      * _Available since v3.4._
550      */
551     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
552         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal returns (bytes memory) {
566         require(isContract(target), "Address: delegate call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.delegatecall(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
574      * revert reason using the provided one.
575      *
576      * _Available since v4.3._
577      */
578     function verifyCallResult(
579         bool success,
580         bytes memory returndata,
581         string memory errorMessage
582     ) internal pure returns (bytes memory) {
583         if (success) {
584             return returndata;
585         } else {
586             // Look for revert reason and bubble it up if present
587             if (returndata.length > 0) {
588                 // The easiest way to bubble the revert reason is using memory via assembly
589 
590                 assembly {
591                     let returndata_size := mload(returndata)
592                     revert(add(32, returndata), returndata_size)
593                 }
594             } else {
595                 revert(errorMessage);
596             }
597         }
598     }
599 }
600 
601 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
602 
603 
604 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 /**
609  * @title ERC721 token receiver interface
610  * @dev Interface for any contract that wants to support safeTransfers
611  * from ERC721 asset contracts.
612  */
613 interface IERC721Receiver {
614     /**
615      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
616      * by `operator` from `from`, this function is called.
617      *
618      * It must return its Solidity selector to confirm the token transfer.
619      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
620      *
621      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
622      */
623     function onERC721Received(
624         address operator,
625         address from,
626         uint256 tokenId,
627         bytes calldata data
628     ) external returns (bytes4);
629 }
630 
631 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev Interface of the ERC165 standard, as defined in the
640  * https://eips.ethereum.org/EIPS/eip-165[EIP].
641  *
642  * Implementers can declare support of contract interfaces, which can then be
643  * queried by others ({ERC165Checker}).
644  *
645  * For an implementation, see {ERC165}.
646  */
647 interface IERC165 {
648     /**
649      * @dev Returns true if this contract implements the interface defined by
650      * `interfaceId`. See the corresponding
651      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
652      * to learn more about how these ids are created.
653      *
654      * This function call must use less than 30 000 gas.
655      */
656     function supportsInterface(bytes4 interfaceId) external view returns (bool);
657 }
658 
659 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 
667 /**
668  * @dev Implementation of the {IERC165} interface.
669  *
670  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
671  * for the additional interface id that will be supported. For example:
672  *
673  * ```solidity
674  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
675  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
676  * }
677  * ```
678  *
679  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
680  */
681 abstract contract ERC165 is IERC165 {
682     /**
683      * @dev See {IERC165-supportsInterface}.
684      */
685     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
686         return interfaceId == type(IERC165).interfaceId;
687     }
688 }
689 
690 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
691 
692 
693 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 /**
699  * @dev Required interface of an ERC721 compliant contract.
700  */
701 interface IERC721 is IERC165 {
702     /**
703      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
704      */
705     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
706 
707     /**
708      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
709      */
710     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
711 
712     /**
713      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
714      */
715     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
716 
717     /**
718      * @dev Returns the number of tokens in ``owner``'s account.
719      */
720     function balanceOf(address owner) external view returns (uint256 balance);
721 
722     /**
723      * @dev Returns the owner of the `tokenId` token.
724      *
725      * Requirements:
726      *
727      * - `tokenId` must exist.
728      */
729     function ownerOf(uint256 tokenId) external view returns (address owner);
730 
731     /**
732      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
733      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
734      *
735      * Requirements:
736      *
737      * - `from` cannot be the zero address.
738      * - `to` cannot be the zero address.
739      * - `tokenId` token must exist and be owned by `from`.
740      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
741      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
742      *
743      * Emits a {Transfer} event.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) external;
750 
751     /**
752      * @dev Transfers `tokenId` token from `from` to `to`.
753      *
754      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
755      *
756      * Requirements:
757      *
758      * - `from` cannot be the zero address.
759      * - `to` cannot be the zero address.
760      * - `tokenId` token must be owned by `from`.
761      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
762      *
763      * Emits a {Transfer} event.
764      */
765     function transferFrom(
766         address from,
767         address to,
768         uint256 tokenId
769     ) external;
770 
771     /**
772      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
773      * The approval is cleared when the token is transferred.
774      *
775      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
776      *
777      * Requirements:
778      *
779      * - The caller must own the token or be an approved operator.
780      * - `tokenId` must exist.
781      *
782      * Emits an {Approval} event.
783      */
784     function approve(address to, uint256 tokenId) external;
785 
786     /**
787      * @dev Returns the account approved for `tokenId` token.
788      *
789      * Requirements:
790      *
791      * - `tokenId` must exist.
792      */
793     function getApproved(uint256 tokenId) external view returns (address operator);
794 
795     /**
796      * @dev Approve or remove `operator` as an operator for the caller.
797      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
798      *
799      * Requirements:
800      *
801      * - The `operator` cannot be the caller.
802      *
803      * Emits an {ApprovalForAll} event.
804      */
805     function setApprovalForAll(address operator, bool _approved) external;
806 
807     /**
808      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
809      *
810      * See {setApprovalForAll}
811      */
812     function isApprovedForAll(address owner, address operator) external view returns (bool);
813 
814     /**
815      * @dev Safely transfers `tokenId` token from `from` to `to`.
816      *
817      * Requirements:
818      *
819      * - `from` cannot be the zero address.
820      * - `to` cannot be the zero address.
821      * - `tokenId` token must exist and be owned by `from`.
822      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
823      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
824      *
825      * Emits a {Transfer} event.
826      */
827     function safeTransferFrom(
828         address from,
829         address to,
830         uint256 tokenId,
831         bytes calldata data
832     ) external;
833 }
834 
835 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
836 
837 
838 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
839 
840 pragma solidity ^0.8.0;
841 
842 
843 /**
844  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
845  * @dev See https://eips.ethereum.org/EIPS/eip-721
846  */
847 interface IERC721Metadata is IERC721 {
848     /**
849      * @dev Returns the token collection name.
850      */
851     function name() external view returns (string memory);
852 
853     /**
854      * @dev Returns the token collection symbol.
855      */
856     function symbol() external view returns (string memory);
857 
858     /**
859      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
860      */
861     function tokenURI(uint256 tokenId) external view returns (string memory);
862 }
863 
864 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
865 
866 
867 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
868 
869 pragma solidity ^0.8.0;
870 
871 
872 
873 
874 
875 
876 
877 
878 /**
879  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
880  * the Metadata extension, but not including the Enumerable extension, which is available separately as
881  * {ERC721Enumerable}.
882  */
883 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
884     using Address for address;
885     using Strings for uint256;
886 
887     // Token name
888     string private _name;
889 
890     // Token symbol
891     string private _symbol;
892 
893     // Mapping from token ID to owner address
894     mapping(uint256 => address) private _owners;
895 
896     // Mapping owner address to token count
897     mapping(address => uint256) private _balances;
898 
899     // Mapping from token ID to approved address
900     mapping(uint256 => address) private _tokenApprovals;
901 
902     // Mapping from owner to operator approvals
903     mapping(address => mapping(address => bool)) private _operatorApprovals;
904 
905     /**
906      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
907      */
908     constructor(string memory name_, string memory symbol_) {
909         _name = name_;
910         _symbol = symbol_;
911     }
912 
913     /**
914      * @dev See {IERC165-supportsInterface}.
915      */
916     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
917         return
918             interfaceId == type(IERC721).interfaceId ||
919             interfaceId == type(IERC721Metadata).interfaceId ||
920             super.supportsInterface(interfaceId);
921     }
922 
923     /**
924      * @dev See {IERC721-balanceOf}.
925      */
926     function balanceOf(address owner) public view virtual override returns (uint256) {
927         require(owner != address(0), "ERC721: balance query for the zero address");
928         return _balances[owner];
929     }
930 
931     /**
932      * @dev See {IERC721-ownerOf}.
933      */
934     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
935         address owner = _owners[tokenId];
936         require(owner != address(0), "ERC721: owner query for nonexistent token");
937         return owner;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-name}.
942      */
943     function name() public view virtual override returns (string memory) {
944         return _name;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-symbol}.
949      */
950     function symbol() public view virtual override returns (string memory) {
951         return _symbol;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-tokenURI}.
956      */
957     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
958         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
959 
960         string memory baseURI = _baseURI();
961         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
962     }
963 
964     /**
965      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
966      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
967      * by default, can be overriden in child contracts.
968      */
969     function _baseURI() internal view virtual returns (string memory) {
970         return "";
971     }
972 
973     /**
974      * @dev See {IERC721-approve}.
975      */
976     function approve(address to, uint256 tokenId) public virtual override {
977         address owner = ERC721.ownerOf(tokenId);
978         require(to != owner, "ERC721: approval to current owner");
979 
980         require(
981             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
982             "ERC721: approve caller is not owner nor approved for all"
983         );
984 
985         _approve(to, tokenId);
986     }
987 
988     /**
989      * @dev See {IERC721-getApproved}.
990      */
991     function getApproved(uint256 tokenId) public view virtual override returns (address) {
992         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
993 
994         return _tokenApprovals[tokenId];
995     }
996 
997     /**
998      * @dev See {IERC721-setApprovalForAll}.
999      */
1000     function setApprovalForAll(address operator, bool approved) public virtual override {
1001         _setApprovalForAll(_msgSender(), operator, approved);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-isApprovedForAll}.
1006      */
1007     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1008         return _operatorApprovals[owner][operator];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-transferFrom}.
1013      */
1014     function transferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         //solhint-disable-next-line max-line-length
1020         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1021 
1022         _transfer(from, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-safeTransferFrom}.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public virtual override {
1033         safeTransferFrom(from, to, tokenId, "");
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-safeTransferFrom}.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId,
1043         bytes memory _data
1044     ) public virtual override {
1045         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1046         _safeTransfer(from, to, tokenId, _data);
1047     }
1048 
1049     /**
1050      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1051      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1052      *
1053      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1054      *
1055      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1056      * implement alternative mechanisms to perform token transfer, such as signature-based.
1057      *
1058      * Requirements:
1059      *
1060      * - `from` cannot be the zero address.
1061      * - `to` cannot be the zero address.
1062      * - `tokenId` token must exist and be owned by `from`.
1063      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _safeTransfer(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) internal virtual {
1073         _transfer(from, to, tokenId);
1074         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1075     }
1076 
1077     /**
1078      * @dev Returns whether `tokenId` exists.
1079      *
1080      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1081      *
1082      * Tokens start existing when they are minted (`_mint`),
1083      * and stop existing when they are burned (`_burn`).
1084      */
1085     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1086         return _owners[tokenId] != address(0);
1087     }
1088 
1089     /**
1090      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1091      *
1092      * Requirements:
1093      *
1094      * - `tokenId` must exist.
1095      */
1096     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1097         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1098         address owner = ERC721.ownerOf(tokenId);
1099         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1100     }
1101 
1102     /**
1103      * @dev Safely mints `tokenId` and transfers it to `to`.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must not exist.
1108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _safeMint(address to, uint256 tokenId) internal virtual {
1113         _safeMint(to, tokenId, "");
1114     }
1115 
1116     /**
1117      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1118      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1119      */
1120     function _safeMint(
1121         address to,
1122         uint256 tokenId,
1123         bytes memory _data
1124     ) internal virtual {
1125         _mint(to, tokenId);
1126         require(
1127             _checkOnERC721Received(address(0), to, tokenId, _data),
1128             "ERC721: transfer to non ERC721Receiver implementer"
1129         );
1130     }
1131 
1132     /**
1133      * @dev Mints `tokenId` and transfers it to `to`.
1134      *
1135      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1136      *
1137      * Requirements:
1138      *
1139      * - `tokenId` must not exist.
1140      * - `to` cannot be the zero address.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _mint(address to, uint256 tokenId) internal virtual {
1145         require(to != address(0), "ERC721: mint to the zero address");
1146         require(!_exists(tokenId), "ERC721: token already minted");
1147 
1148         _beforeTokenTransfer(address(0), to, tokenId);
1149 
1150         _balances[to] += 1;
1151         _owners[tokenId] = to;
1152 
1153         emit Transfer(address(0), to, tokenId);
1154 
1155         _afterTokenTransfer(address(0), to, tokenId);
1156     }
1157 
1158     /**
1159      * @dev Destroys `tokenId`.
1160      * The approval is cleared when the token is burned.
1161      *
1162      * Requirements:
1163      *
1164      * - `tokenId` must exist.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _burn(uint256 tokenId) internal virtual {
1169         address owner = ERC721.ownerOf(tokenId);
1170 
1171         _beforeTokenTransfer(owner, address(0), tokenId);
1172 
1173         // Clear approvals
1174         _approve(address(0), tokenId);
1175 
1176         _balances[owner] -= 1;
1177         delete _owners[tokenId];
1178 
1179         emit Transfer(owner, address(0), tokenId);
1180 
1181         _afterTokenTransfer(owner, address(0), tokenId);
1182     }
1183 
1184     /**
1185      * @dev Transfers `tokenId` from `from` to `to`.
1186      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1187      *
1188      * Requirements:
1189      *
1190      * - `to` cannot be the zero address.
1191      * - `tokenId` token must be owned by `from`.
1192      *
1193      * Emits a {Transfer} event.
1194      */
1195     function _transfer(
1196         address from,
1197         address to,
1198         uint256 tokenId
1199     ) internal virtual {
1200         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1201         require(to != address(0), "ERC721: transfer to the zero address");
1202 
1203         _beforeTokenTransfer(from, to, tokenId);
1204 
1205         // Clear approvals from the previous owner
1206         _approve(address(0), tokenId);
1207 
1208         _balances[from] -= 1;
1209         _balances[to] += 1;
1210         _owners[tokenId] = to;
1211 
1212         emit Transfer(from, to, tokenId);
1213 
1214         _afterTokenTransfer(from, to, tokenId);
1215     }
1216 
1217     /**
1218      * @dev Approve `to` to operate on `tokenId`
1219      *
1220      * Emits a {Approval} event.
1221      */
1222     function _approve(address to, uint256 tokenId) internal virtual {
1223         _tokenApprovals[tokenId] = to;
1224         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1225     }
1226 
1227     /**
1228      * @dev Approve `operator` to operate on all of `owner` tokens
1229      *
1230      * Emits a {ApprovalForAll} event.
1231      */
1232     function _setApprovalForAll(
1233         address owner,
1234         address operator,
1235         bool approved
1236     ) internal virtual {
1237         require(owner != operator, "ERC721: approve to caller");
1238         _operatorApprovals[owner][operator] = approved;
1239         emit ApprovalForAll(owner, operator, approved);
1240     }
1241 
1242     /**
1243      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1244      * The call is not executed if the target address is not a contract.
1245      *
1246      * @param from address representing the previous owner of the given token ID
1247      * @param to target address that will receive the tokens
1248      * @param tokenId uint256 ID of the token to be transferred
1249      * @param _data bytes optional data to send along with the call
1250      * @return bool whether the call correctly returned the expected magic value
1251      */
1252     function _checkOnERC721Received(
1253         address from,
1254         address to,
1255         uint256 tokenId,
1256         bytes memory _data
1257     ) private returns (bool) {
1258         if (to.isContract()) {
1259             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1260                 return retval == IERC721Receiver.onERC721Received.selector;
1261             } catch (bytes memory reason) {
1262                 if (reason.length == 0) {
1263                     revert("ERC721: transfer to non ERC721Receiver implementer");
1264                 } else {
1265                     assembly {
1266                         revert(add(32, reason), mload(reason))
1267                     }
1268                 }
1269             }
1270         } else {
1271             return true;
1272         }
1273     }
1274 
1275     /**
1276      * @dev Hook that is called before any token transfer. This includes minting
1277      * and burning.
1278      *
1279      * Calling conditions:
1280      *
1281      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1282      * transferred to `to`.
1283      * - When `from` is zero, `tokenId` will be minted for `to`.
1284      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1285      * - `from` and `to` are never both zero.
1286      *
1287      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1288      */
1289     function _beforeTokenTransfer(
1290         address from,
1291         address to,
1292         uint256 tokenId
1293     ) internal virtual {}
1294 
1295     /**
1296      * @dev Hook that is called after any transfer of tokens. This includes
1297      * minting and burning.
1298      *
1299      * Calling conditions:
1300      *
1301      * - when `from` and `to` are both non-zero.
1302      * - `from` and `to` are never both zero.
1303      *
1304      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1305      */
1306     function _afterTokenTransfer(
1307         address from,
1308         address to,
1309         uint256 tokenId
1310     ) internal virtual {}
1311 }
1312 
1313 // File: tiny.sol
1314 
1315 
1316 pragma solidity ^0.8.9;
1317 
1318 
1319 
1320 contract tinycriminals is ERC721, NonblockingReceiver {
1321 
1322     string public baseURI = "ipfs://QmfQEsd3EyNxJ5FDck7N6SGWaVcRjze4aVDN48Hqywmsfm/";
1323     string public contractURI = "ipfs://QmSZ1pj3E74TCsDvJnfV9ZBstM3vNNW4HEntCQjxYoMz3e";
1324     string public constant baseExtension = ".json";
1325 
1326     uint256 nextTokenId;
1327     uint256 MAX_MINT;
1328 
1329     uint256 gasForDestinationLzReceive = 350000;
1330 
1331     uint256 public constant MAX_PER_TX = 2;
1332     uint256 public constant MAX_PER_WALLET = 30;
1333     mapping(address => uint256) public minted;
1334 
1335     bool public paused = false;
1336 
1337     constructor(
1338         address _endpoint,
1339         uint256 startId,
1340         uint256 _max
1341     ) ERC721("tiny criminals", "tc") {
1342         endpoint = ILayerZeroEndpoint(_endpoint);
1343         nextTokenId = startId;
1344         MAX_MINT = _max;
1345     }
1346 
1347     function mint(uint256 _amount) external payable {
1348         address _caller = _msgSender();
1349         require(!paused, "tinycriminals: Paused");
1350         require(nextTokenId + _amount <= MAX_MINT, "tinycriminals: Mint exceeds supply");
1351         require(MAX_PER_TX >= _amount , "tinycriminals: Excess max per tx");
1352         require(MAX_PER_WALLET >= minted[_caller] + _amount, "tinycriminals: Excess max per wallet");
1353         minted[_caller] += _amount;
1354 
1355         for(uint256 i = 0; i < _amount; i++) {
1356             _safeMint(_caller, ++nextTokenId);
1357         }
1358     }
1359 
1360     // This function transfers the nft from your address on the
1361     // source chain to the same address on the destination chain
1362     function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1363         require(
1364             msg.sender == ownerOf(tokenId),
1365             "You must own the token to traverse"
1366         );
1367         require(
1368             trustedRemoteLookup[_chainId].length > 0,
1369             "This chain is currently unavailable for travel"
1370         );
1371 
1372         // burn NFT, eliminating it from circulation on src chain
1373         _burn(tokenId);
1374 
1375         // abi.encode() the payload with the values to send
1376         bytes memory payload = abi.encode(msg.sender, tokenId);
1377 
1378         // encode adapterParams to specify more gas for the destination
1379         uint16 version = 1;
1380         bytes memory adapterParams = abi.encodePacked(
1381             version,
1382             gasForDestinationLzReceive
1383         );
1384 
1385         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1386         // you will be refunded for extra gas paid
1387         (uint256 messageFee, ) = endpoint.estimateFees(
1388             _chainId,
1389             address(this),
1390             payload,
1391             false,
1392             adapterParams
1393         );
1394 
1395         require(
1396             msg.value >= messageFee,
1397             "tinycriminals: msg.value not enough to cover messageFee. Send gas for message fees"
1398         );
1399 
1400         endpoint.send{value: msg.value}(
1401             _chainId, // destination chainId
1402             trustedRemoteLookup[_chainId], // destination address of nft contract
1403             payload, // abi.encoded()'ed bytes
1404             payable(msg.sender), // refund address
1405             address(0x0), // 'zroPaymentAddress' unused for this
1406             adapterParams // txParameters
1407         );
1408     }
1409 
1410     function getEstimatedFees(uint16 _chainId, uint256 tokenId) public view returns (uint) {
1411         bytes memory payload = abi.encode(msg.sender, tokenId);
1412         uint16 version = 1;
1413         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1414         (uint quotedLayerZeroFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1415         return quotedLayerZeroFee;
1416     }
1417 
1418     function pause(bool _state) external onlyOwner {
1419         paused = _state;
1420     }
1421 
1422     function setBaseURI(string memory baseURI_) external onlyOwner {
1423         baseURI = baseURI_;
1424     }
1425 
1426     function setContractURI(string memory _contractURI) external onlyOwner {
1427         contractURI = _contractURI;
1428     }
1429 
1430     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1431         require(_exists(_tokenId), "Token does not exist.");
1432         return bytes(baseURI).length > 0 ? string(
1433             abi.encodePacked(
1434               baseURI,
1435               Strings.toString(_tokenId),
1436               baseExtension
1437             )
1438         ) : "";
1439     }
1440 
1441     function setGasForDestinationLzReceive(uint256 _gasForDestinationLzReceive) external onlyOwner {
1442         gasForDestinationLzReceive = _gasForDestinationLzReceive;
1443     }
1444 
1445     function withdraw() external onlyOwner {
1446         uint256 balance = address(this).balance;
1447         (bool success, ) = _msgSender().call{value: balance}("");
1448         require(success, "Failed to send");
1449     }
1450 
1451     // ------------------
1452     // Internal Functions
1453     // ------------------
1454 
1455     function _LzReceive(
1456         uint16 _srcChainId,
1457         bytes memory _srcAddress,
1458         uint64 _nonce,
1459         bytes memory _payload
1460     ) internal override {
1461         // decode
1462         (address toAddr, uint256 tokenId) = abi.decode(
1463             _payload,
1464             (address, uint256)
1465         );
1466 
1467         // mint the tokens back into existence on destination chain
1468         _safeMint(toAddr, tokenId);
1469     }
1470 
1471 }