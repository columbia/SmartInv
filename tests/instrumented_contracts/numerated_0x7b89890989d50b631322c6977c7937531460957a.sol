1 // SPDX-License-Identifier: BUSL-1.1
2 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
3 /*
4 Mint Day: 10 april 2022
5 Mint Price: Free Mint
6 Twitter: https://twitter.com/ape_zero
7  ________   _______ .______        ______   
8 |       /  |   ____||   _  \      /  __  \  
9 `---/  /   |  |__   |  |_)  |    |  |  |  | 
10    /  /    |   __|  |      /     |  |  |  | 
11   /  /----.|  |____ |  |\  \----.|  `--'  | 
12  /________||_______|| _| `._____| \______/  
13                                             
14      ___      .______    _______      ______  __       __    __  .______   
15     /   \     |   _  \  |   ____|    /      ||  |     |  |  |  | |   _  \  
16    /  ^  \    |  |_)  | |  |__      |  ,----'|  |     |  |  |  | |  |_)  | 
17   /  /_\  \   |   ___/  |   __|     |  |     |  |     |  |  |  | |   _  <  
18  /  _____  \  |  |      |  |____    |  `----.|  `----.|  `--'  | |  |_)  | 
19 /__/     \__\ | _|      |_______|    \______||_______| \______/  |______/  
20 
21  */
22 
23 
24 pragma solidity >=0.5.0;
25 
26 interface ILayerZeroUserApplicationConfig {
27     // @notice set the configuration of the LayerZero messaging library of the specified version
28     // @param _version - messaging library version
29     // @param _chainId - the chainId for the pending config change
30     // @param _configType - type of configuration. every messaging library has its own convention.
31     // @param _config - configuration in the bytes. can encode arbitrary content.
32     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
33 
34     // @notice set the send() LayerZero messaging library version to _version
35     // @param _version - new messaging library version
36     function setSendVersion(uint16 _version) external;
37 
38     // @notice set the lzReceive() LayerZero messaging library version to _version
39     // @param _version - new messaging library version
40     function setReceiveVersion(uint16 _version) external;
41 
42     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
43     // @param _srcChainId - the chainId of the source chain
44     // @param _srcAddress - the contract address of the source contract at the source chain
45     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
46 }
47 
48 // File: contracts/interfaces/ILayerZeroEndpoint.sol
49 
50 
51 
52 pragma solidity >=0.5.0;
53 
54 
55 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
56     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
57     // @param _dstChainId - the destination chain identifier
58     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
59     // @param _payload - a custom bytes payload to send to the destination contract
60     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
61     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
62     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
63     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
64 
65     // @notice used by the messaging library to publish verified payload
66     // @param _srcChainId - the source chain identifier
67     // @param _srcAddress - the source contract (as bytes) at the source chain
68     // @param _dstAddress - the address on destination chain
69     // @param _nonce - the unbound message ordering nonce
70     // @param _gasLimit - the gas limit for external contract execution
71     // @param _payload - verified payload to send to the destination contract
72     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
73 
74     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
75     // @param _srcChainId - the source chain identifier
76     // @param _srcAddress - the source chain contract address
77     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
78 
79     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
80     // @param _srcAddress - the source chain contract address
81     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
82 
83     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
84     // @param _dstChainId - the destination chain identifier
85     // @param _userApplication - the user app address on this EVM chain
86     // @param _payload - the custom message to send over LayerZero
87     // @param _payInZRO - if false, user app pays the protocol fee in native token
88     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
89     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
90 
91     // @notice get this Endpoint's immutable source identifier
92     function getChainId() external view returns (uint16);
93 
94     // @notice the interface to retry failed message on this Endpoint destination
95     // @param _srcChainId - the source chain identifier
96     // @param _srcAddress - the source chain contract address
97     // @param _payload - the payload to be retried
98     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
99 
100     // @notice query if any STORED payload (message blocking) at the endpoint.
101     // @param _srcChainId - the source chain identifier
102     // @param _srcAddress - the source chain contract address
103     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
104 
105     // @notice query if the _libraryAddress is valid for sending msgs.
106     // @param _userApplication - the user app address on this EVM chain
107     function getSendLibraryAddress(address _userApplication) external view returns (address);
108 
109     // @notice query if the _libraryAddress is valid for receiving msgs.
110     // @param _userApplication - the user app address on this EVM chain
111     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
112 
113     // @notice query if the non-reentrancy guard for send() is on
114     // @return true if the guard is on. false otherwise
115     function isSendingPayload() external view returns (bool);
116 
117     // @notice query if the non-reentrancy guard for receive() is on
118     // @return true if the guard is on. false otherwise
119     function isReceivingPayload() external view returns (bool);
120 
121     // @notice get the configuration of the LayerZero messaging library of the specified version
122     // @param _version - messaging library version
123     // @param _chainId - the chainId for the pending config change
124     // @param _userApplication - the contract address of the user application
125     // @param _configType - type of configuration. every messaging library has its own convention.
126     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
127 
128     // @notice get the send() LayerZero messaging library version
129     // @param _userApplication - the contract address of the user application
130     function getSendVersion(address _userApplication) external view returns (uint16);
131 
132     // @notice get the lzReceive() LayerZero messaging library version
133     // @param _userApplication - the contract address of the user application
134     function getReceiveVersion(address _userApplication) external view returns (uint16);
135 }
136 
137 // File: contracts/interfaces/ILayerZeroReceiver.sol
138 
139 
140 
141 pragma solidity >=0.5.0;
142 
143 interface ILayerZeroReceiver {
144     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
145     // @param _srcChainId - the source endpoint identifier
146     // @param _srcAddress - the source sending contract address from the source chain
147     // @param _nonce - the ordered message nonce
148     // @param _payload - the signed payload is the UA bytes has encoded to be sent
149     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
150 }
151 // File: @openzeppelin/contracts/utils/Strings.sol
152 
153 
154 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 /**
159  * @dev String operations.
160  */
161 library Strings {
162     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
163 
164     /**
165      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
166      */
167     function toString(uint256 value) internal pure returns (string memory) {
168         // Inspired by OraclizeAPI's implementation - MIT licence
169         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
170 
171         if (value == 0) {
172             return "0";
173         }
174         uint256 temp = value;
175         uint256 digits;
176         while (temp != 0) {
177             digits++;
178             temp /= 10;
179         }
180         bytes memory buffer = new bytes(digits);
181         while (value != 0) {
182             digits -= 1;
183             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
184             value /= 10;
185         }
186         return string(buffer);
187     }
188 
189     /**
190      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
191      */
192     function toHexString(uint256 value) internal pure returns (string memory) {
193         if (value == 0) {
194             return "0x00";
195         }
196         uint256 temp = value;
197         uint256 length = 0;
198         while (temp != 0) {
199             length++;
200             temp >>= 8;
201         }
202         return toHexString(value, length);
203     }
204 
205     /**
206      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
207      */
208     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
209         bytes memory buffer = new bytes(2 * length + 2);
210         buffer[0] = "0";
211         buffer[1] = "x";
212         for (uint256 i = 2 * length + 1; i > 1; --i) {
213             buffer[i] = _HEX_SYMBOLS[value & 0xf];
214             value >>= 4;
215         }
216         require(value == 0, "Strings: hex length insufficient");
217         return string(buffer);
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Context.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 abstract contract Context {
239     function _msgSender() internal view virtual returns (address) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view virtual returns (bytes calldata) {
244         return msg.data;
245     }
246 }
247 
248 // File: @openzeppelin/contracts/access/Ownable.sol
249 
250 
251 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 
256 /**
257  * @dev Contract module which provides a basic access control mechanism, where
258  * there is an account (an owner) that can be granted exclusive access to
259  * specific functions.
260  *
261  * By default, the owner account will be the one that deploys the contract. This
262  * can later be changed with {transferOwnership}.
263  *
264  * This module is used through inheritance. It will make available the modifier
265  * `onlyOwner`, which can be applied to your functions to restrict their use to
266  * the owner.
267  */
268 abstract contract Ownable is Context {
269     address private _owner;
270 
271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272 
273     /**
274      * @dev Initializes the contract setting the deployer as the initial owner.
275      */
276     constructor() {
277         _transferOwnership(_msgSender());
278     }
279 
280     /**
281      * @dev Returns the address of the current owner.
282      */
283     function owner() public view virtual returns (address) {
284         return _owner;
285     }
286 
287     /**
288      * @dev Throws if called by any account other than the owner.
289      */
290     modifier onlyOwner() {
291         require(owner() == _msgSender(), "Ownable: caller is not the owner");
292         _;
293     }
294 
295     /**
296      * @dev Leaves the contract without owner. It will not be possible to call
297      * `onlyOwner` functions anymore. Can only be called by the current owner.
298      *
299      * NOTE: Renouncing ownership will leave the contract without an owner,
300      * thereby removing any functionality that is only available to the owner.
301      */
302     function renounceOwnership() public virtual onlyOwner {
303         _transferOwnership(address(0));
304     }
305 
306     /**
307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
308      * Can only be called by the current owner.
309      */
310     function transferOwnership(address newOwner) public virtual onlyOwner {
311         require(newOwner != address(0), "Ownable: new owner is the zero address");
312         _transferOwnership(newOwner);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Internal function without access restriction.
318      */
319     function _transferOwnership(address newOwner) internal virtual {
320         address oldOwner = _owner;
321         _owner = newOwner;
322         emit OwnershipTransferred(oldOwner, newOwner);
323     }
324 }
325 
326 // File: @openzeppelin/contracts/utils/Address.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Collection of functions related to the address type
335  */
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      */
354     function isContract(address account) internal view returns (bool) {
355         // This method relies on extcodesize, which returns 0 for contracts in
356         // construction, since the code is only stored at the end of the
357         // constructor execution.
358 
359         uint256 size;
360         assembly {
361             size := extcodesize(account)
362         }
363         return size > 0;
364     }
365 
366     /**
367      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
368      * `recipient`, forwarding all available gas and reverting on errors.
369      *
370      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
371      * of certain opcodes, possibly making contracts go over the 2300 gas limit
372      * imposed by `transfer`, making them unable to receive funds via
373      * `transfer`. {sendValue} removes this limitation.
374      *
375      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
376      *
377      * IMPORTANT: because control is transferred to `recipient`, care must be
378      * taken to not create reentrancy vulnerabilities. Consider using
379      * {ReentrancyGuard} or the
380      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
381      */
382     function sendValue(address payable recipient, uint256 amount) internal {
383         require(address(this).balance >= amount, "Address: insufficient balance");
384 
385         (bool success, ) = recipient.call{value: amount}("");
386         require(success, "Address: unable to send value, recipient may have reverted");
387     }
388 
389     /**
390      * @dev Performs a Solidity function call using a low level `call`. A
391      * plain `call` is an unsafe replacement for a function call: use this
392      * function instead.
393      *
394      * If `target` reverts with a revert reason, it is bubbled up by this
395      * function (like regular Solidity function calls).
396      *
397      * Returns the raw returned data. To convert to the expected return value,
398      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
399      *
400      * Requirements:
401      *
402      * - `target` must be a contract.
403      * - calling `target` with `data` must not revert.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionCall(target, data, "Address: low-level call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
413      * `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, 0, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but also transferring `value` wei to `target`.
428      *
429      * Requirements:
430      *
431      * - the calling contract must have an ETH balance of at least `value`.
432      * - the called Solidity function must be `payable`.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(
437         address target,
438         bytes memory data,
439         uint256 value
440     ) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
446      * with `errorMessage` as a fallback revert reason when `target` reverts.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(
451         address target,
452         bytes memory data,
453         uint256 value,
454         string memory errorMessage
455     ) internal returns (bytes memory) {
456         require(address(this).balance >= value, "Address: insufficient balance for call");
457         require(isContract(target), "Address: call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.call{value: value}(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but performing a static call.
466      *
467      * _Available since v3.3._
468      */
469     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
470         return functionStaticCall(target, data, "Address: low-level static call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475      * but performing a static call.
476      *
477      * _Available since v3.3._
478      */
479     function functionStaticCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal view returns (bytes memory) {
484         require(isContract(target), "Address: static call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.staticcall(data);
487         return verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but performing a delegate call.
493      *
494      * _Available since v3.4._
495      */
496     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a delegate call.
503      *
504      * _Available since v3.4._
505      */
506     function functionDelegateCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         require(isContract(target), "Address: delegate call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.delegatecall(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
519      * revert reason using the provided one.
520      *
521      * _Available since v4.3._
522      */
523     function verifyCallResult(
524         bool success,
525         bytes memory returndata,
526         string memory errorMessage
527     ) internal pure returns (bytes memory) {
528         if (success) {
529             return returndata;
530         } else {
531             // Look for revert reason and bubble it up if present
532             if (returndata.length > 0) {
533                 // The easiest way to bubble the revert reason is using memory via assembly
534 
535                 assembly {
536                     let returndata_size := mload(returndata)
537                     revert(add(32, returndata), returndata_size)
538                 }
539             } else {
540                 revert(errorMessage);
541             }
542         }
543     }
544 }
545 
546 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @title ERC721 token receiver interface
555  * @dev Interface for any contract that wants to support safeTransfers
556  * from ERC721 asset contracts.
557  */
558 interface IERC721Receiver {
559     /**
560      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
561      * by `operator` from `from`, this function is called.
562      *
563      * It must return its Solidity selector to confirm the token transfer.
564      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
565      *
566      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
567      */
568     function onERC721Received(
569         address operator,
570         address from,
571         uint256 tokenId,
572         bytes calldata data
573     ) external returns (bytes4);
574 }
575 
576 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
577 
578 
579 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Interface of the ERC165 standard, as defined in the
585  * https://eips.ethereum.org/EIPS/eip-165[EIP].
586  *
587  * Implementers can declare support of contract interfaces, which can then be
588  * queried by others ({ERC165Checker}).
589  *
590  * For an implementation, see {ERC165}.
591  */
592 interface IERC165 {
593     /**
594      * @dev Returns true if this contract implements the interface defined by
595      * `interfaceId`. See the corresponding
596      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
597      * to learn more about how these ids are created.
598      *
599      * This function call must use less than 30 000 gas.
600      */
601     function supportsInterface(bytes4 interfaceId) external view returns (bool);
602 }
603 
604 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 
612 /**
613  * @dev Implementation of the {IERC165} interface.
614  *
615  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
616  * for the additional interface id that will be supported. For example:
617  *
618  * ```solidity
619  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
620  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
621  * }
622  * ```
623  *
624  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
625  */
626 abstract contract ERC165 is IERC165 {
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
631         return interfaceId == type(IERC165).interfaceId;
632     }
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @dev Required interface of an ERC721 compliant contract.
645  */
646 interface IERC721 is IERC165 {
647     /**
648      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
649      */
650     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
651 
652     /**
653      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
654      */
655     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
656 
657     /**
658      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
659      */
660     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
661 
662     /**
663      * @dev Returns the number of tokens in ``owner``'s account.
664      */
665     function balanceOf(address owner) external view returns (uint256 balance);
666     /**
667      * @dev Returns the owner of the `tokenId` token.
668      *
669      * Requirements:
670      *
671      * - `tokenId` must exist.
672      */
673     function ownerOf(uint256 tokenId) external view returns (address owner);
674 
675     /**
676      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
677      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
685      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
686      *
687      * Emits a {Transfer} event.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) external;
694 
695     /**
696      * @dev Transfers `tokenId` token from `from` to `to`.
697      *
698      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
699      *
700      * Requirements:
701      *
702      * - `from` cannot be the zero address.
703      * - `to` cannot be the zero address.
704      * - `tokenId` token must be owned by `from`.
705      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
706      *
707      * Emits a {Transfer} event.
708      */
709     function transferFrom(
710         address from,
711         address to,
712         uint256 tokenId
713     ) external;
714 
715     /**
716      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
717      * The approval is cleared when the token is transferred.
718      *
719      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
720      *
721      * Requirements:
722      *
723      * - The caller must own the token or be an approved operator.
724      * - `tokenId` must exist.
725      *
726      * Emits an {Approval} event.
727      */
728     function approve(address to, uint256 tokenId) external;
729 
730     /**
731      * @dev Returns the account approved for `tokenId` token.
732      *
733      * Requirements:
734      *
735      * - `tokenId` must exist.
736      */
737     function getApproved(uint256 tokenId) external view returns (address operator);
738 
739     /**
740      * @dev Approve or remove `operator` as an operator for the caller.
741      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
742      *
743      * Requirements:
744      *
745      * - The `operator` cannot be the caller.
746      *
747      * Emits an {ApprovalForAll} event.
748      */
749     function setApprovalForAll(address operator, bool _approved) external;
750 
751     /**
752      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
753      *
754      * See {setApprovalForAll}
755      */
756     function isApprovedForAll(address owner, address operator) external view returns (bool);
757 
758     /**
759      * @dev Safely transfers `tokenId` token from `from` to `to`.
760      *
761      * Requirements:
762      *
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must exist and be owned by `from`.
766      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
768      *
769      * Emits a {Transfer} event.
770      */
771     function safeTransferFrom(
772         address from,
773         address to,
774         uint256 tokenId,
775         bytes calldata data
776     ) external;
777 }
778 
779 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
780 
781 
782 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
783 
784 pragma solidity ^0.8.0;
785 
786 
787 /**
788  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
789  * @dev See https://eips.ethereum.org/EIPS/eip-721
790  */
791 interface IERC721Metadata is IERC721 {
792     /**
793      * @dev Returns the token collection name.
794      */
795     function name() external view returns (string memory);
796 
797     /**
798      * @dev Returns the token collection symbol.
799      */
800     function symbol() external view returns (string memory);
801 
802     /**
803      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
804      */
805     function tokenURI(uint256 tokenId) external view returns (string memory);
806 }
807 
808 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
809 
810 
811 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
812 
813 pragma solidity ^0.8.0;
814 
815 
816 
817 
818 
819 
820 
821 
822 /**
823  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
824  * the Metadata extension, but not including the Enumerable extension, which is available separately as
825  * {ERC721Enumerable}.
826  */
827 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
828     using Address for address;
829     using Strings for uint256;
830 
831     // Token name
832     string private _name;
833 
834     // Token symbol
835     string private _symbol;
836 
837     // Mapping from token ID to owner address
838     mapping(uint256 => address) private _owners;
839 
840     // Mapping owner address to token count
841     mapping(address => uint256) private _balances;
842 
843     // Mapping from token ID to approved address
844     mapping(uint256 => address) private _tokenApprovals;
845 
846     // Mapping from owner to operator approvals
847     mapping(address => mapping(address => bool)) private _operatorApprovals;
848 
849     /**
850      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
851      */
852     constructor(string memory name_, string memory symbol_) {
853         _name = name_;
854         _symbol = symbol_;
855     }
856 
857     /**
858      * @dev See {IERC165-supportsInterface}.
859      */
860     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
861         return
862             interfaceId == type(IERC721).interfaceId ||
863             interfaceId == type(IERC721Metadata).interfaceId ||
864             super.supportsInterface(interfaceId);
865     }
866 
867     /**
868      * @dev See {IERC721-balanceOf}.
869      */
870     function balanceOf(address owner) public view virtual override returns (uint256) {
871         require(owner != address(0), "ERC721: balance query for the zero address");
872         return _balances[owner];
873     }
874 
875     /**
876      * @dev See {IERC721-ownerOf}.
877      */
878     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
879         address owner = _owners[tokenId];
880         require(owner != address(0), "ERC721: owner query for nonexistent token");
881         return owner;
882     }
883 
884     /**
885      * @dev See {IERC721Metadata-name}.
886      */
887     function name() public view virtual override returns (string memory) {
888         return _name;
889     }
890 
891     /**
892      * @dev See {IERC721Metadata-symbol}.
893      */
894     function symbol() public view virtual override returns (string memory) {
895         return _symbol;
896     }
897 
898     /**
899      * @dev See {IERC721Metadata-tokenURI}.
900      */
901     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
902         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
903 
904         string memory baseURI = _baseURI();
905         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
906     }
907 
908     /**
909      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
910      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
911      * by default, can be overriden in child contracts.
912      */
913     function _baseURI() internal view virtual returns (string memory) {
914         return "";
915     }
916 
917     /**
918      * @dev See {IERC721-approve}.
919      */
920     function approve(address to, uint256 tokenId) public virtual override {
921         address owner = ERC721.ownerOf(tokenId);
922         require(to != owner, "ERC721: approval to current owner");
923 
924         require(
925             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
926             "ERC721: approve caller is not owner nor approved for all"
927         );
928 
929         _approve(to, tokenId);
930     }
931 
932     /**
933      * @dev See {IERC721-getApproved}.
934      */
935     function getApproved(uint256 tokenId) public view virtual override returns (address) {
936         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
937 
938         return _tokenApprovals[tokenId];
939     }
940 
941     /**
942      * @dev See {IERC721-setApprovalForAll}.
943      */
944     function setApprovalForAll(address operator, bool approved) public virtual override {
945         _setApprovalForAll(_msgSender(), operator, approved);
946     }
947 
948     /**
949      * @dev See {IERC721-isApprovedForAll}.
950      */
951     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
952         return _operatorApprovals[owner][operator];
953     }
954 
955     /**
956      * @dev See {IERC721-transferFrom}.
957      */
958     function transferFrom(
959         address from,
960         address to,
961         uint256 tokenId
962     ) public virtual override {
963         //solhint-disable-next-line max-line-length
964         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
965 
966         _transfer(from, to, tokenId);
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         safeTransferFrom(from, to, tokenId, "");
978     }
979 
980     /**
981      * @dev See {IERC721-safeTransferFrom}.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) public virtual override {
989         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
990         _safeTransfer(from, to, tokenId, _data);
991     }
992 
993     /**
994      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
995      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
996      *
997      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
998      *
999      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1000      * implement alternative mechanisms to perform token transfer, such as signature-based.
1001      *
1002      * Requirements:
1003      *
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must exist and be owned by `from`.
1007      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _safeTransfer(
1012         address from,
1013         address to,
1014         uint256 tokenId,
1015         bytes memory _data
1016     ) internal virtual {
1017         _transfer(from, to, tokenId);
1018         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1019     }
1020 
1021     /**
1022      * @dev Returns whether `tokenId` exists.
1023      *
1024      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1025      *
1026      * Tokens start existing when they are minted (`_mint`),
1027      * and stop existing when they are burned (`_burn`).
1028      */
1029     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1030         return _owners[tokenId] != address(0);
1031     }
1032 
1033     /**
1034      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1035      *
1036      * Requirements:
1037      *
1038      * - `tokenId` must exist.
1039      */
1040     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1041         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1042         address owner = ERC721.ownerOf(tokenId);
1043         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1044     }
1045 
1046     /**
1047      * @dev Safely mints `tokenId` and transfers it to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must not exist.
1052      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _safeMint(address to, uint256 tokenId) internal virtual {
1057         _safeMint(to, tokenId, "");
1058     }
1059 
1060     /**
1061      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1062      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1063      */
1064     function _safeMint(
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) internal virtual {
1069         _mint(to, tokenId);
1070         require(
1071             _checkOnERC721Received(address(0), to, tokenId, _data),
1072             "ERC721: transfer to non ERC721Receiver implementer"
1073         );
1074     }
1075 
1076     /**
1077      * @dev Mints `tokenId` and transfers it to `to`.
1078      *
1079      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must not exist.
1084      * - `to` cannot be the zero address.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _mint(address to, uint256 tokenId) internal virtual {
1089         require(to != address(0), "ERC721: mint to the zero address");
1090 
1091         _beforeTokenTransfer(address(0), to, tokenId);
1092 
1093         _balances[to] += 1;
1094         _owners[tokenId] = to;
1095 
1096         emit Transfer(address(0), to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev Destroys `tokenId`.
1101      * The approval is cleared when the token is burned.
1102      *
1103      * Requirements:
1104      *
1105      * - `tokenId` must exist.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _burn(uint256 tokenId) internal virtual {
1110         address owner = ERC721.ownerOf(tokenId);
1111 
1112         _beforeTokenTransfer(owner, address(0), tokenId);
1113 
1114         // Clear approvals
1115         _approve(address(0), tokenId);
1116 
1117         _balances[owner] -= 1;
1118         delete _owners[tokenId];
1119 
1120         emit Transfer(owner, address(0), tokenId);
1121     }
1122 
1123     /**
1124      * @dev Transfers `tokenId` from `from` to `to`.
1125      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      * - `tokenId` token must be owned by `from`.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _transfer(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) internal virtual {
1139         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1140         require(to != address(0), "ERC721: transfer to the zero address");
1141 
1142         _beforeTokenTransfer(from, to, tokenId);
1143 
1144         // Clear approvals from the previous owner
1145         _approve(address(0), tokenId);
1146 
1147         _balances[from] -= 1;
1148         _balances[to] += 1;
1149         _owners[tokenId] = to;
1150 
1151         emit Transfer(from, to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev Approve `to` to operate on `tokenId`
1156      *
1157      * Emits a {Approval} event.
1158      */
1159     function _approve(address to, uint256 tokenId) internal virtual {
1160         _tokenApprovals[tokenId] = to;
1161         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1162     }
1163 
1164     /**
1165      * @dev Approve `operator` to operate on all of `owner` tokens
1166      *
1167      * Emits a {ApprovalForAll} event.
1168      */
1169     function _setApprovalForAll(
1170         address owner,
1171         address operator,
1172         bool approved
1173     ) internal virtual {
1174         require(owner != operator, "ERC721: approve to caller");
1175         _operatorApprovals[owner][operator] = approved;
1176         emit ApprovalForAll(owner, operator, approved);
1177     }
1178 
1179     /**
1180      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1181      * The call is not executed if the target address is not a contract.
1182      *
1183      * @param from address representing the previous owner of the given token ID
1184      * @param to target address that will receive the tokens
1185      * @param tokenId uint256 ID of the token to be transferred
1186      * @param _data bytes optional data to send along with the call
1187      * @return bool whether the call correctly returned the expected magic value
1188      */
1189     function _checkOnERC721Received(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) private returns (bool) {
1195         if (to.isContract()) {
1196             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1197                 return retval == IERC721Receiver.onERC721Received.selector;
1198             } catch (bytes memory reason) {
1199                 if (reason.length == 0) {
1200                     revert("ERC721: transfer to non ERC721Receiver implementer");
1201                 } else {
1202                     assembly {
1203                         revert(add(32, reason), mload(reason))
1204                     }
1205                 }
1206             }
1207         } else {
1208             return true;
1209         }
1210     }
1211 
1212     /**
1213      * @dev Hook that is called before any token transfer. This includes minting
1214      * and burning.
1215      *
1216      * Calling conditions:
1217      *
1218      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1219      * transferred to `to`.
1220      * - When `from` is zero, `tokenId` will be minted for `to`.
1221      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1222      * - `from` and `to` are never both zero.
1223      *
1224      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1225      */
1226     function _beforeTokenTransfer(
1227         address from,
1228         address to,
1229         uint256 tokenId
1230     ) internal virtual {}
1231 }
1232 
1233 // File: contracts/NonblockingReceiver.sol
1234 
1235 
1236 pragma solidity ^0.8.6;
1237 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1238 
1239     ILayerZeroEndpoint internal endpoint;
1240 
1241     struct FailedMessages {
1242         uint payloadLength;
1243         bytes32 payloadHash;
1244     }
1245 
1246     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
1247     mapping(uint16 => bytes) public trustedRemoteLookup;
1248 
1249     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
1250 
1251     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
1252         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1253         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]), 
1254             "NonblockingReceiver: invalid source sending contract");
1255 
1256         // try-catch all errors/exceptions
1257         // having failed messages does not block messages passing
1258         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1259             // do nothing
1260         } catch {
1261             // error / exception
1262             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
1263             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1264         }
1265     }
1266 
1267     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
1268         // only internal transaction
1269         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
1270 
1271         // handle incoming message
1272         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
1273     }
1274 
1275     // abstract function
1276     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
1277 
1278     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
1279         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
1280     }
1281 
1282     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
1283         // assert there is message to retry
1284         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
1285         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
1286         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
1287         // clear the stored message
1288         failedMsg.payloadLength = 0;
1289         failedMsg.payloadHash = bytes32(0);
1290         // execute the message. revert if it fails again
1291         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1292     }
1293 
1294     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
1295         trustedRemoteLookup[_chainId] = _trustedRemote;
1296     }
1297 }
1298 
1299 pragma solidity ^0.8.7;
1300 contract ZAPE is Ownable, ERC721, NonblockingReceiver {
1301 
1302     address public _owner;
1303     string private baseURI;
1304     uint256 nextTokenId = 0;
1305     uint256 MAX_MINT_ETHEREUM = 1865;
1306     uint maxTXMint = 2;
1307     bool start = false;
1308 
1309     uint gasForDestinationLzReceive = 350000;
1310 
1311     constructor(string memory baseURI_, address _layerZeroEndpoint) ERC721("Zero Ape Club", "ZAPE") { 
1312         _owner = msg.sender;
1313         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1314         baseURI = baseURI_;
1315     }
1316     function mint(uint8 numTokens) external payable {
1317         require(start == true , "ZAPE: Sale hasn't not started yet");
1318         require(numTokens <= maxTXMint , "ZAPE: Max mint amount per session exceeded");
1319         require(nextTokenId + numTokens <= MAX_MINT_ETHEREUM, "ZAPE: Mint exceeds supply");
1320         for (uint256 i = 1; i <= numTokens; i++) {
1321              _safeMint(msg.sender, ++nextTokenId);
1322         }       
1323     }    
1324     function launch() public onlyOwner{
1325         start = true;
1326     }
1327     function estFee(uint16 _chainId, uint tokenId) public view returns (uint) {
1328         bytes memory payload = abi.encode(msg.sender, tokenId);
1329 
1330         // encode adapterParams to specify more gas for the destination
1331         uint16 version = 1;
1332         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1333 
1334         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1335         // you will be refunded for extra gas paid
1336         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1337         return messageFee;
1338     }
1339     // This function transfers the nft from your address on the 
1340     // source chain to the same address on the destination chain
1341     function traverseChains(uint16 _chainId, uint tokenId) public payable {
1342         require(msg.sender == ownerOf(tokenId), "You must own the token to traverse");
1343         require(trustedRemoteLookup[_chainId].length > 0, "This chain is currently unavailable for travel");
1344 
1345         // burn NFT, eliminating it from circulation on src chain
1346         _burn(tokenId);
1347 
1348         // abi.encode() the payload with the values to send
1349         bytes memory payload = abi.encode(msg.sender, tokenId);
1350 
1351         // encode adapterParams to specify more gas for the destination
1352         uint16 version = 1;
1353         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1354 
1355         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1356         // you will be refunded for extra gas paid
1357         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1358         
1359         require(msg.value >= messageFee, "ZAPE: msg.value not enough to cover messageFee. Send gas for message fees");
1360 
1361         endpoint.send{value: msg.value}(
1362             _chainId,                           // destination chainId
1363             trustedRemoteLookup[_chainId],      // destination address of nft contract
1364             payload,                            // abi.encoded()'ed bytes
1365             payable(msg.sender),                // refund address
1366             address(0x0),                       // 'zroPaymentAddress' unused for this
1367             adapterParams                       // txParameters 
1368         );
1369     }
1370 
1371     function setBaseURI(string memory URI) external onlyOwner {
1372         baseURI = URI;
1373     }
1374 
1375     function donateForDevelop() external payable {
1376         // thank you
1377     }
1378 
1379     // This allows the devs to receive kind donations
1380     function withdraw(uint amt) external onlyOwner {
1381         (bool sent, ) = payable(_owner).call{value: amt}("");
1382         require(sent, "ZAPE: Failed to withdraw Ether");
1383     }
1384 
1385     // just in case this fixed variable limits us from future integrations
1386     function setGasForDestinationLzReceive(uint newVal) external onlyOwner {
1387         gasForDestinationLzReceive = newVal;
1388     }
1389 
1390     // ------------------
1391     // Internal Functions
1392     // ------------------
1393 
1394     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) override internal {
1395         // decode
1396         (address toAddr, uint tokenId) = abi.decode(_payload, (address, uint));
1397 
1398         // mint the tokens back into existence on destination chain
1399         _safeMint(toAddr, tokenId);
1400     }  
1401 
1402     function _baseURI() override internal view returns (string memory) {
1403         return baseURI;
1404     }
1405 }