1 // SPDX-License-Identifier: BUSL-1.1
2 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
3 
4 
5 
6 pragma solidity >=0.5.0;
7 
8 interface ILayerZeroUserApplicationConfig {
9     // @notice set the configuration of the LayerZero messaging library of the specified version
10     // @param _version - messaging library version
11     // @param _chainId - the chainId for the pending config change
12     // @param _configType - type of configuration. every messaging library has its own convention.
13     // @param _config - configuration in the bytes. can encode arbitrary content.
14     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
15 
16     // @notice set the send() LayerZero messaging library version to _version
17     // @param _version - new messaging library version
18     function setSendVersion(uint16 _version) external;
19 
20     // @notice set the lzReceive() LayerZero messaging library version to _version
21     // @param _version - new messaging library version
22     function setReceiveVersion(uint16 _version) external;
23 
24     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
25     // @param _srcChainId - the chainId of the source chain
26     // @param _srcAddress - the contract address of the source contract at the source chain
27     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
28 }
29 
30 // File: contracts/interfaces/ILayerZeroEndpoint.sol
31 
32 
33 
34 pragma solidity >=0.5.0;
35 
36 
37 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
38     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
39     // @param _dstChainId - the destination chain identifier
40     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
41     // @param _payload - a custom bytes payload to send to the destination contract
42     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
43     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
44     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
45     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
46 
47     // @notice used by the messaging library to publish verified payload
48     // @param _srcChainId - the source chain identifier
49     // @param _srcAddress - the source contract (as bytes) at the source chain
50     // @param _dstAddress - the address on destination chain
51     // @param _nonce - the unbound message ordering nonce
52     // @param _gasLimit - the gas limit for external contract execution
53     // @param _payload - verified payload to send to the destination contract
54     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
55 
56     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
57     // @param _srcChainId - the source chain identifier
58     // @param _srcAddress - the source chain contract address
59     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
60 
61     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
62     // @param _srcAddress - the source chain contract address
63     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
64 
65     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
66     // @param _dstChainId - the destination chain identifier
67     // @param _userApplication - the user app address on this EVM chain
68     // @param _payload - the custom message to send over LayerZero
69     // @param _payInZRO - if false, user app pays the protocol fee in native token
70     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
71     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
72 
73     // @notice get this Endpoint's immutable source identifier
74     function getChainId() external view returns (uint16);
75 
76     // @notice the interface to retry failed message on this Endpoint destination
77     // @param _srcChainId - the source chain identifier
78     // @param _srcAddress - the source chain contract address
79     // @param _payload - the payload to be retried
80     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
81 
82     // @notice query if any STORED payload (message blocking) at the endpoint.
83     // @param _srcChainId - the source chain identifier
84     // @param _srcAddress - the source chain contract address
85     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
86 
87     // @notice query if the _libraryAddress is valid for sending msgs.
88     // @param _userApplication - the user app address on this EVM chain
89     function getSendLibraryAddress(address _userApplication) external view returns (address);
90 
91     // @notice query if the _libraryAddress is valid for receiving msgs.
92     // @param _userApplication - the user app address on this EVM chain
93     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
94 
95     // @notice query if the non-reentrancy guard for send() is on
96     // @return true if the guard is on. false otherwise
97     function isSendingPayload() external view returns (bool);
98 
99     // @notice query if the non-reentrancy guard for receive() is on
100     // @return true if the guard is on. false otherwise
101     function isReceivingPayload() external view returns (bool);
102 
103     // @notice get the configuration of the LayerZero messaging library of the specified version
104     // @param _version - messaging library version
105     // @param _chainId - the chainId for the pending config change
106     // @param _userApplication - the contract address of the user application
107     // @param _configType - type of configuration. every messaging library has its own convention.
108     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
109 
110     // @notice get the send() LayerZero messaging library version
111     // @param _userApplication - the contract address of the user application
112     function getSendVersion(address _userApplication) external view returns (uint16);
113 
114     // @notice get the lzReceive() LayerZero messaging library version
115     // @param _userApplication - the contract address of the user application
116     function getReceiveVersion(address _userApplication) external view returns (uint16);
117 }
118 
119 // File: contracts/interfaces/ILayerZeroReceiver.sol
120 
121 
122 
123 pragma solidity >=0.5.0;
124 
125 interface ILayerZeroReceiver {
126     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
127     // @param _srcChainId - the source endpoint identifier
128     // @param _srcAddress - the source sending contract address from the source chain
129     // @param _nonce - the ordered message nonce
130     // @param _payload - the signed payload is the UA bytes has encoded to be sent
131     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
132 }
133 // File: @openzeppelin/contracts/utils/Strings.sol
134 
135 
136 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev String operations.
142  */
143 library Strings {
144     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
145 
146     /**
147      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
148      */
149     function toString(uint256 value) internal pure returns (string memory) {
150         // Inspired by OraclizeAPI's implementation - MIT licence
151         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
152 
153         if (value == 0) {
154             return "0";
155         }
156         uint256 temp = value;
157         uint256 digits;
158         while (temp != 0) {
159             digits++;
160             temp /= 10;
161         }
162         bytes memory buffer = new bytes(digits);
163         while (value != 0) {
164             digits -= 1;
165             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
166             value /= 10;
167         }
168         return string(buffer);
169     }
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
173      */
174     function toHexString(uint256 value) internal pure returns (string memory) {
175         if (value == 0) {
176             return "0x00";
177         }
178         uint256 temp = value;
179         uint256 length = 0;
180         while (temp != 0) {
181             length++;
182             temp >>= 8;
183         }
184         return toHexString(value, length);
185     }
186 
187     /**
188      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
189      */
190     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
191         bytes memory buffer = new bytes(2 * length + 2);
192         buffer[0] = "0";
193         buffer[1] = "x";
194         for (uint256 i = 2 * length + 1; i > 1; --i) {
195             buffer[i] = _HEX_SYMBOLS[value & 0xf];
196             value >>= 4;
197         }
198         require(value == 0, "Strings: hex length insufficient");
199         return string(buffer);
200     }
201 }
202 
203 // File: @openzeppelin/contracts/utils/Context.sol
204 
205 
206 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @dev Provides information about the current execution context, including the
212  * sender of the transaction and its data. While these are generally available
213  * via msg.sender and msg.data, they should not be accessed in such a direct
214  * manner, since when dealing with meta-transactions the account sending and
215  * paying for execution may not be the actual sender (as far as an application
216  * is concerned).
217  *
218  * This contract is only required for intermediate, library-like contracts.
219  */
220 abstract contract Context {
221     function _msgSender() internal view virtual returns (address) {
222         return msg.sender;
223     }
224 
225     function _msgData() internal view virtual returns (bytes calldata) {
226         return msg.data;
227     }
228 }
229 
230 // File: @openzeppelin/contracts/access/Ownable.sol
231 
232 
233 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 
238 /**
239  * @dev Contract module which provides a basic access control mechanism, where
240  * there is an account (an owner) that can be granted exclusive access to
241  * specific functions.
242  *
243  * By default, the owner account will be the one that deploys the contract. This
244  * can later be changed with {transferOwnership}.
245  *
246  * This module is used through inheritance. It will make available the modifier
247  * `onlyOwner`, which can be applied to your functions to restrict their use to
248  * the owner.
249  */
250 abstract contract Ownable is Context {
251     address private _owner;
252 
253     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
254 
255     /**
256      * @dev Initializes the contract setting the deployer as the initial owner.
257      */
258     constructor() {
259         _transferOwnership(_msgSender());
260     }
261 
262     /**
263      * @dev Returns the address of the current owner.
264      */
265     function owner() public view virtual returns (address) {
266         return _owner;
267     }
268 
269     /**
270      * @dev Throws if called by any account other than the owner.
271      */
272     modifier onlyOwner() {
273         require(owner() == _msgSender(), "Ownable: caller is not the owner");
274         _;
275     }
276 
277     /**
278      * @dev Leaves the contract without owner. It will not be possible to call
279      * `onlyOwner` functions anymore. Can only be called by the current owner.
280      *
281      * NOTE: Renouncing ownership will leave the contract without an owner,
282      * thereby removing any functionality that is only available to the owner.
283      */
284     function renounceOwnership() public virtual onlyOwner {
285         _transferOwnership(address(0));
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      * Can only be called by the current owner.
291      */
292     function transferOwnership(address newOwner) public virtual onlyOwner {
293         require(newOwner != address(0), "Ownable: new owner is the zero address");
294         _transferOwnership(newOwner);
295     }
296 
297     /**
298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
299      * Internal function without access restriction.
300      */
301     function _transferOwnership(address newOwner) internal virtual {
302         address oldOwner = _owner;
303         _owner = newOwner;
304         emit OwnershipTransferred(oldOwner, newOwner);
305     }
306 }
307 
308 // File: @openzeppelin/contracts/utils/Address.sol
309 
310 
311 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @dev Collection of functions related to the address type
317  */
318 library Address {
319     /**
320      * @dev Returns true if `account` is a contract.
321      *
322      * [IMPORTANT]
323      * ====
324      * It is unsafe to assume that an address for which this function returns
325      * false is an externally-owned account (EOA) and not a contract.
326      *
327      * Among others, `isContract` will return false for the following
328      * types of addresses:
329      *
330      *  - an externally-owned account
331      *  - a contract in construction
332      *  - an address where a contract will be created
333      *  - an address where a contract lived, but was destroyed
334      * ====
335      */
336     function isContract(address account) internal view returns (bool) {
337         // This method relies on extcodesize, which returns 0 for contracts in
338         // construction, since the code is only stored at the end of the
339         // constructor execution.
340 
341         uint256 size;
342         assembly {
343             size := extcodesize(account)
344         }
345         return size > 0;
346     }
347 
348     /**
349      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
350      * `recipient`, forwarding all available gas and reverting on errors.
351      *
352      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
353      * of certain opcodes, possibly making contracts go over the 2300 gas limit
354      * imposed by `transfer`, making them unable to receive funds via
355      * `transfer`. {sendValue} removes this limitation.
356      *
357      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
358      *
359      * IMPORTANT: because control is transferred to `recipient`, care must be
360      * taken to not create reentrancy vulnerabilities. Consider using
361      * {ReentrancyGuard} or the
362      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
363      */
364     function sendValue(address payable recipient, uint256 amount) internal {
365         require(address(this).balance >= amount, "Address: insufficient balance");
366 
367         (bool success, ) = recipient.call{value: amount}("");
368         require(success, "Address: unable to send value, recipient may have reverted");
369     }
370 
371     /**
372      * @dev Performs a Solidity function call using a low level `call`. A
373      * plain `call` is an unsafe replacement for a function call: use this
374      * function instead.
375      *
376      * If `target` reverts with a revert reason, it is bubbled up by this
377      * function (like regular Solidity function calls).
378      *
379      * Returns the raw returned data. To convert to the expected return value,
380      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
381      *
382      * Requirements:
383      *
384      * - `target` must be a contract.
385      * - calling `target` with `data` must not revert.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
390         return functionCall(target, data, "Address: low-level call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
395      * `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value
422     ) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(
433         address target,
434         bytes memory data,
435         uint256 value,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(address(this).balance >= value, "Address: insufficient balance for call");
439         require(isContract(target), "Address: call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.call{value: value}(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
452         return functionStaticCall(target, data, "Address: low-level static call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.staticcall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(isContract(target), "Address: delegate call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
501      * revert reason using the provided one.
502      *
503      * _Available since v4.3._
504      */
505     function verifyCallResult(
506         bool success,
507         bytes memory returndata,
508         string memory errorMessage
509     ) internal pure returns (bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 assembly {
518                     let returndata_size := mload(returndata)
519                     revert(add(32, returndata), returndata_size)
520                 }
521             } else {
522                 revert(errorMessage);
523             }
524         }
525     }
526 }
527 
528 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @title ERC721 token receiver interface
537  * @dev Interface for any contract that wants to support safeTransfers
538  * from ERC721 asset contracts.
539  */
540 interface IERC721Receiver {
541     /**
542      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
543      * by `operator` from `from`, this function is called.
544      *
545      * It must return its Solidity selector to confirm the token transfer.
546      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
547      *
548      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
549      */
550     function onERC721Received(
551         address operator,
552         address from,
553         uint256 tokenId,
554         bytes calldata data
555     ) external returns (bytes4);
556 }
557 
558 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @dev Interface of the ERC165 standard, as defined in the
567  * https://eips.ethereum.org/EIPS/eip-165[EIP].
568  *
569  * Implementers can declare support of contract interfaces, which can then be
570  * queried by others ({ERC165Checker}).
571  *
572  * For an implementation, see {ERC165}.
573  */
574 interface IERC165 {
575     /**
576      * @dev Returns true if this contract implements the interface defined by
577      * `interfaceId`. See the corresponding
578      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
579      * to learn more about how these ids are created.
580      *
581      * This function call must use less than 30 000 gas.
582      */
583     function supportsInterface(bytes4 interfaceId) external view returns (bool);
584 }
585 
586 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Implementation of the {IERC165} interface.
596  *
597  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
598  * for the additional interface id that will be supported. For example:
599  *
600  * ```solidity
601  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
603  * }
604  * ```
605  *
606  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
607  */
608 abstract contract ERC165 is IERC165 {
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613         return interfaceId == type(IERC165).interfaceId;
614     }
615 }
616 
617 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
618 
619 
620 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 
625 /**
626  * @dev Required interface of an ERC721 compliant contract.
627  */
628 interface IERC721 is IERC165 {
629     /**
630      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
631      */
632     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
633 
634     /**
635      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
636      */
637     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
638 
639     /**
640      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
641      */
642     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
643 
644     /**
645      * @dev Returns the number of tokens in ``owner``'s account.
646      */
647     function balanceOf(address owner) external view returns (uint256 balance);
648     /**
649      * @dev Returns the owner of the `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function ownerOf(uint256 tokenId) external view returns (address owner);
656 
657     /**
658      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
659      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
660      *
661      * Requirements:
662      *
663      * - `from` cannot be the zero address.
664      * - `to` cannot be the zero address.
665      * - `tokenId` token must exist and be owned by `from`.
666      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
667      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
668      *
669      * Emits a {Transfer} event.
670      */
671     function safeTransferFrom(
672         address from,
673         address to,
674         uint256 tokenId
675     ) external;
676 
677     /**
678      * @dev Transfers `tokenId` token from `from` to `to`.
679      *
680      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
681      *
682      * Requirements:
683      *
684      * - `from` cannot be the zero address.
685      * - `to` cannot be the zero address.
686      * - `tokenId` token must be owned by `from`.
687      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
688      *
689      * Emits a {Transfer} event.
690      */
691     function transferFrom(
692         address from,
693         address to,
694         uint256 tokenId
695     ) external;
696 
697     /**
698      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
699      * The approval is cleared when the token is transferred.
700      *
701      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
702      *
703      * Requirements:
704      *
705      * - The caller must own the token or be an approved operator.
706      * - `tokenId` must exist.
707      *
708      * Emits an {Approval} event.
709      */
710     function approve(address to, uint256 tokenId) external;
711 
712     /**
713      * @dev Returns the account approved for `tokenId` token.
714      *
715      * Requirements:
716      *
717      * - `tokenId` must exist.
718      */
719     function getApproved(uint256 tokenId) external view returns (address operator);
720 
721     /**
722      * @dev Approve or remove `operator` as an operator for the caller.
723      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
724      *
725      * Requirements:
726      *
727      * - The `operator` cannot be the caller.
728      *
729      * Emits an {ApprovalForAll} event.
730      */
731     function setApprovalForAll(address operator, bool _approved) external;
732 
733     /**
734      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
735      *
736      * See {setApprovalForAll}
737      */
738     function isApprovedForAll(address owner, address operator) external view returns (bool);
739 
740     /**
741      * @dev Safely transfers `tokenId` token from `from` to `to`.
742      *
743      * Requirements:
744      *
745      * - `from` cannot be the zero address.
746      * - `to` cannot be the zero address.
747      * - `tokenId` token must exist and be owned by `from`.
748      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
749      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
750      *
751      * Emits a {Transfer} event.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId,
757         bytes calldata data
758     ) external;
759 }
760 
761 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
762 
763 
764 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
765 
766 pragma solidity ^0.8.0;
767 
768 
769 /**
770  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
771  * @dev See https://eips.ethereum.org/EIPS/eip-721
772  */
773 interface IERC721Metadata is IERC721 {
774     /**
775      * @dev Returns the token collection name.
776      */
777     function name() external view returns (string memory);
778 
779     /**
780      * @dev Returns the token collection symbol.
781      */
782     function symbol() external view returns (string memory);
783 
784     /**
785      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
786      */
787     function tokenURI(uint256 tokenId) external view returns (string memory);
788 }
789 
790 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
791 
792 
793 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
794 
795 pragma solidity ^0.8.0;
796 
797 
798 
799 
800 
801 
802 
803 
804 /**
805  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
806  * the Metadata extension, but not including the Enumerable extension, which is available separately as
807  * {ERC721Enumerable}.
808  */
809 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
810     using Address for address;
811     using Strings for uint256;
812 
813     // Token name
814     string private _name;
815 
816     // Token symbol
817     string private _symbol;
818 
819     // Mapping from token ID to owner address
820     mapping(uint256 => address) private _owners;
821 
822     // Mapping owner address to token count
823     mapping(address => uint256) private _balances;
824 
825     // Mapping from token ID to approved address
826     mapping(uint256 => address) private _tokenApprovals;
827 
828     // Mapping from owner to operator approvals
829     mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831     /**
832      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
833      */
834     constructor(string memory name_, string memory symbol_) {
835         _name = name_;
836         _symbol = symbol_;
837     }
838 
839     /**
840      * @dev See {IERC165-supportsInterface}.
841      */
842     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
843         return
844             interfaceId == type(IERC721).interfaceId ||
845             interfaceId == type(IERC721Metadata).interfaceId ||
846             super.supportsInterface(interfaceId);
847     }
848 
849     /**
850      * @dev See {IERC721-balanceOf}.
851      */
852     function balanceOf(address owner) public view virtual override returns (uint256) {
853         require(owner != address(0), "ERC721: balance query for the zero address");
854         return _balances[owner];
855     }
856 
857     /**
858      * @dev See {IERC721-ownerOf}.
859      */
860     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
861         address owner = _owners[tokenId];
862         require(owner != address(0), "ERC721: owner query for nonexistent token");
863         return owner;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-name}.
868      */
869     function name() public view virtual override returns (string memory) {
870         return _name;
871     }
872 
873     /**
874      * @dev See {IERC721Metadata-symbol}.
875      */
876     function symbol() public view virtual override returns (string memory) {
877         return _symbol;
878     }
879 
880     /**
881      * @dev See {IERC721Metadata-tokenURI}.
882      */
883     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
884         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
885 
886         string memory baseURI = _baseURI();
887         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString() , ".json")) : "";
888     }
889 
890     /**
891      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
892      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
893      * by default, can be overriden in child contracts.
894      */
895     function _baseURI() internal view virtual returns (string memory) {
896         return "";
897     }
898 
899     /**
900      * @dev See {IERC721-approve}.
901      */
902     function approve(address to, uint256 tokenId) public virtual override {
903         address owner = ERC721.ownerOf(tokenId);
904         require(to != owner, "ERC721: approval to current owner");
905 
906         require(
907             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
908             "ERC721: approve caller is not owner nor approved for all"
909         );
910 
911         _approve(to, tokenId);
912     }
913 
914     /**
915      * @dev See {IERC721-getApproved}.
916      */
917     function getApproved(uint256 tokenId) public view virtual override returns (address) {
918         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
919 
920         return _tokenApprovals[tokenId];
921     }
922 
923     /**
924      * @dev See {IERC721-setApprovalForAll}.
925      */
926     function setApprovalForAll(address operator, bool approved) public virtual override {
927         _setApprovalForAll(_msgSender(), operator, approved);
928     }
929 
930     /**
931      * @dev See {IERC721-isApprovedForAll}.
932      */
933     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
934         return _operatorApprovals[owner][operator];
935     }
936 
937     /**
938      * @dev See {IERC721-transferFrom}.
939      */
940     function transferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         //solhint-disable-next-line max-line-length
946         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
947 
948         _transfer(from, to, tokenId);
949     }
950 
951     /**
952      * @dev See {IERC721-safeTransferFrom}.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         safeTransferFrom(from, to, tokenId, "");
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) public virtual override {
971         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
972         _safeTransfer(from, to, tokenId, _data);
973     }
974 
975     /**
976      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
977      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
978      *
979      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
980      *
981      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
982      * implement alternative mechanisms to perform token transfer, such as signature-based.
983      *
984      * Requirements:
985      *
986      * - `from` cannot be the zero address.
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must exist and be owned by `from`.
989      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _safeTransfer(
994         address from,
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) internal virtual {
999         _transfer(from, to, tokenId);
1000         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1001     }
1002 
1003     /**
1004      * @dev Returns whether `tokenId` exists.
1005      *
1006      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1007      *
1008      * Tokens start existing when they are minted (`_mint`),
1009      * and stop existing when they are burned (`_burn`).
1010      */
1011     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1012         return _owners[tokenId] != address(0);
1013     }
1014 
1015     /**
1016      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      */
1022     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1023         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1024         address owner = ERC721.ownerOf(tokenId);
1025         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1026     }
1027 
1028     /**
1029      * @dev Safely mints `tokenId` and transfers it to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must not exist.
1034      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _safeMint(address to, uint256 tokenId) internal virtual {
1039         _safeMint(to, tokenId, "");
1040     }
1041 
1042     /**
1043      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1044      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1045      */
1046     function _safeMint(
1047         address to,
1048         uint256 tokenId,
1049         bytes memory _data
1050     ) internal virtual {
1051         _mint(to, tokenId);
1052         require(
1053             _checkOnERC721Received(address(0), to, tokenId, _data),
1054             "ERC721: transfer to non ERC721Receiver implementer"
1055         );
1056     }
1057 
1058     /**
1059      * @dev Mints `tokenId` and transfers it to `to`.
1060      *
1061      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1062      *
1063      * Requirements:
1064      *
1065      * - `tokenId` must not exist.
1066      * - `to` cannot be the zero address.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _mint(address to, uint256 tokenId) internal virtual {
1071         require(to != address(0), "ERC721: mint to the zero address");
1072 
1073         _beforeTokenTransfer(address(0), to, tokenId);
1074 
1075         _balances[to] += 1;
1076         _owners[tokenId] = to;
1077 
1078         emit Transfer(address(0), to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev Destroys `tokenId`.
1083      * The approval is cleared when the token is burned.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must exist.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _burn(uint256 tokenId) internal virtual {
1092         address owner = ERC721.ownerOf(tokenId);
1093 
1094         _beforeTokenTransfer(owner, address(0), tokenId);
1095 
1096         // Clear approvals
1097         _approve(address(0), tokenId);
1098 
1099         _balances[owner] -= 1;
1100         delete _owners[tokenId];
1101 
1102         emit Transfer(owner, address(0), tokenId);
1103     }
1104 
1105     /**
1106      * @dev Transfers `tokenId` from `from` to `to`.
1107      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must be owned by `from`.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _transfer(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) internal virtual {
1121         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1122         require(to != address(0), "ERC721: transfer to the zero address");
1123 
1124         _beforeTokenTransfer(from, to, tokenId);
1125 
1126         // Clear approvals from the previous owner
1127         _approve(address(0), tokenId);
1128 
1129         _balances[from] -= 1;
1130         _balances[to] += 1;
1131         _owners[tokenId] = to;
1132 
1133         emit Transfer(from, to, tokenId);
1134     }
1135 
1136     /**
1137      * @dev Approve `to` to operate on `tokenId`
1138      *
1139      * Emits a {Approval} event.
1140      */
1141     function _approve(address to, uint256 tokenId) internal virtual {
1142         _tokenApprovals[tokenId] = to;
1143         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev Approve `operator` to operate on all of `owner` tokens
1148      *
1149      * Emits a {ApprovalForAll} event.
1150      */
1151     function _setApprovalForAll(
1152         address owner,
1153         address operator,
1154         bool approved
1155     ) internal virtual {
1156         require(owner != operator, "ERC721: approve to caller");
1157         _operatorApprovals[owner][operator] = approved;
1158         emit ApprovalForAll(owner, operator, approved);
1159     }
1160 
1161     /**
1162      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1163      * The call is not executed if the target address is not a contract.
1164      *
1165      * @param from address representing the previous owner of the given token ID
1166      * @param to target address that will receive the tokens
1167      * @param tokenId uint256 ID of the token to be transferred
1168      * @param _data bytes optional data to send along with the call
1169      * @return bool whether the call correctly returned the expected magic value
1170      */
1171     function _checkOnERC721Received(
1172         address from,
1173         address to,
1174         uint256 tokenId,
1175         bytes memory _data
1176     ) private returns (bool) {
1177         if (to.isContract()) {
1178             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1179                 return retval == IERC721Receiver.onERC721Received.selector;
1180             } catch (bytes memory reason) {
1181                 if (reason.length == 0) {
1182                     revert("ERC721: transfer to non ERC721Receiver implementer");
1183                 } else {
1184                     assembly {
1185                         revert(add(32, reason), mload(reason))
1186                     }
1187                 }
1188             }
1189         } else {
1190             return true;
1191         }
1192     }
1193 
1194     /**
1195      * @dev Hook that is called before any token transfer. This includes minting
1196      * and burning.
1197      *
1198      * Calling conditions:
1199      *
1200      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1201      * transferred to `to`.
1202      * - When `from` is zero, `tokenId` will be minted for `to`.
1203      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1204      * - `from` and `to` are never both zero.
1205      *
1206      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1207      */
1208     function _beforeTokenTransfer(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) internal virtual {}
1213 }
1214 
1215 // File: contracts/NonblockingReceiver.sol
1216 
1217 
1218 pragma solidity ^0.8.6;
1219 
1220 
1221 
1222 
1223 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1224 
1225     ILayerZeroEndpoint internal endpoint;
1226 
1227     struct FailedMessages {
1228         uint payloadLength;
1229         bytes32 payloadHash;
1230     }
1231 
1232     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
1233     mapping(uint16 => bytes) public trustedRemoteLookup;
1234 
1235     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
1236 
1237     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
1238         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1239         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]), 
1240             "NonblockingReceiver: invalid source sending contract");
1241 
1242         // try-catch all errors/exceptions
1243         // having failed messages does not block messages passing
1244         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1245             // do nothing
1246         } catch {
1247             // error / exception
1248             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
1249             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1250         }
1251     }
1252 
1253     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
1254         // only internal transaction
1255         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
1256 
1257         // handle incoming message
1258         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
1259     }
1260 
1261     // abstract function
1262     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
1263 
1264     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
1265         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
1266     }
1267 
1268     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
1269         // assert there is message to retry
1270         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
1271         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
1272         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
1273         // clear the stored message
1274         failedMsg.payloadLength = 0;
1275         failedMsg.payloadHash = bytes32(0);
1276         // execute the message. revert if it fails again
1277         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1278     }
1279 
1280     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
1281         trustedRemoteLookup[_chainId] = _trustedRemote;
1282     }
1283 }
1284 
1285 pragma solidity ^0.8.7;
1286 contract NFT is Ownable, ERC721, NonblockingReceiver {
1287 
1288     bool public paused = true;
1289     address public _owner;
1290     string private baseURI;
1291     uint256 nextTokenId = 0;
1292     uint256 MAX_MINT_ETH = 2654;
1293     uint maxTXMint = 2;
1294     uint maxPeerWallet = 4; // for 6
1295 
1296     uint gasForDestinationLzReceive = 350000;
1297 
1298     constructor(string memory baseURI_, address _layerZeroEndpoint) ERC721("Z3RO PUNKS", "S3X") { 
1299         _owner = msg.sender;
1300         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1301         baseURI = baseURI_;
1302     }
1303     function pause(bool _state) public onlyOwner {
1304         paused = _state;
1305     }
1306     function mint(uint8 numTokens) external payable {
1307         if(msg.sender != _owner){
1308             require(!paused, "Sale has not started yet");
1309         }        
1310         require(numTokens <= maxTXMint , "S3X: Max mint amount per session exceeded");
1311         require(nextTokenId + numTokens <= MAX_MINT_ETH, "S3X: Mint exceeds supply");
1312         require(maxPeerWallet >= balanceOf(msg.sender) , "S3X: Max mint amount per wallet exceeded");
1313         for (uint256 i = 1; i <= numTokens; i++) {
1314              _safeMint(msg.sender, ++nextTokenId);
1315         }       
1316     }    
1317     function traverseChains(uint16 _chainId, uint tokenId) public payable {
1318         require(msg.sender == ownerOf(tokenId), "You must own the token to traverse");
1319         require(trustedRemoteLookup[_chainId].length > 0, "This chain is currently unavailable for travel");
1320 
1321         _burn(tokenId);
1322 
1323         bytes memory payload = abi.encode(msg.sender, tokenId);
1324 
1325         uint16 version = 1;
1326         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1327 
1328         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1329         
1330         require(msg.value >= messageFee, "S3X: msg.value not enough to cover messageFee. Send gas for message fees");
1331 
1332         endpoint.send{value: msg.value}(
1333             _chainId,                           
1334             trustedRemoteLookup[_chainId],      
1335             payload,                           
1336             payable(msg.sender),               
1337             address(0x0),                       
1338             adapterParams                      
1339         );
1340     }
1341 
1342     function setBaseURI(string memory URI) external onlyOwner {
1343         baseURI = URI;
1344     }
1345 
1346     function donateForDevelop() external payable {
1347         // thank you
1348     }
1349 
1350     function withdraw(uint amt) external onlyOwner {
1351         (bool sent, ) = payable(_owner).call{value: amt}("");
1352         require(sent, "S3X: Failed to withdraw Ether");
1353     }
1354 
1355     function setGasForDestinationLzReceive(uint newVal) external onlyOwner {
1356         gasForDestinationLzReceive = newVal;
1357     }
1358 
1359 
1360     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) override internal {
1361         // decode
1362         (address toAddr, uint tokenId) = abi.decode(_payload, (address, uint));
1363 
1364         _safeMint(toAddr, tokenId);
1365     }  
1366 
1367     function _baseURI() override internal view returns (string memory) {
1368         return baseURI;
1369     }
1370 }