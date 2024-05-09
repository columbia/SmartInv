1 // File: contracts/CryptoUncle12.sol
2 
3 // SPDX-License-Identifier: MIT
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
648 
649     /**
650      * @dev Returns the owner of the `tokenId` token.
651      *
652      * Requirements:
653      *
654      * - `tokenId` must exist.
655      */
656     function ownerOf(uint256 tokenId) external view returns (address owner);
657 
658     /**
659      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
660      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
661      *
662      * Requirements:
663      *
664      * - `from` cannot be the zero address.
665      * - `to` cannot be the zero address.
666      * - `tokenId` token must exist and be owned by `from`.
667      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
668      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669      *
670      * Emits a {Transfer} event.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) external;
677 
678     /**
679      * @dev Transfers `tokenId` token from `from` to `to`.
680      *
681      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must be owned by `from`.
688      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
689      *
690      * Emits a {Transfer} event.
691      */
692     function transferFrom(
693         address from,
694         address to,
695         uint256 tokenId
696     ) external;
697 
698     /**
699      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
700      * The approval is cleared when the token is transferred.
701      *
702      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
703      *
704      * Requirements:
705      *
706      * - The caller must own the token or be an approved operator.
707      * - `tokenId` must exist.
708      *
709      * Emits an {Approval} event.
710      */
711     function approve(address to, uint256 tokenId) external;
712 
713     /**
714      * @dev Returns the account approved for `tokenId` token.
715      *
716      * Requirements:
717      *
718      * - `tokenId` must exist.
719      */
720     function getApproved(uint256 tokenId) external view returns (address operator);
721 
722     /**
723      * @dev Approve or remove `operator` as an operator for the caller.
724      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
725      *
726      * Requirements:
727      *
728      * - The `operator` cannot be the caller.
729      *
730      * Emits an {ApprovalForAll} event.
731      */
732     function setApprovalForAll(address operator, bool _approved) external;
733 
734     /**
735      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
736      *
737      * See {setApprovalForAll}
738      */
739     function isApprovedForAll(address owner, address operator) external view returns (bool);
740 
741     /**
742      * @dev Safely transfers `tokenId` token from `from` to `to`.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must exist and be owned by `from`.
749      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes calldata data
759     ) external;
760 }
761 
762 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
763 
764 
765 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
766 
767 pragma solidity ^0.8.0;
768 
769 
770 /**
771  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
772  * @dev See https://eips.ethereum.org/EIPS/eip-721
773  */
774 interface IERC721Metadata is IERC721 {
775     /**
776      * @dev Returns the token collection name.
777      */
778     function name() external view returns (string memory);
779 
780     /**
781      * @dev Returns the token collection symbol.
782      */
783     function symbol() external view returns (string memory);
784 
785     /**
786      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
787      */
788     function tokenURI(uint256 tokenId) external view returns (string memory);
789 }
790 
791 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
792 
793 
794 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
795 
796 pragma solidity ^0.8.0;
797 
798 
799 /**
800  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
801  * the Metadata extension, but not including the Enumerable extension, which is available separately as
802  * {ERC721Enumerable}.
803  */
804 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
805     using Address for address;
806     using Strings for uint256;
807 
808     // Token name
809     string private _name;
810 
811     // Token symbol
812     string private _symbol;
813 
814     // Mapping from token ID to owner address
815     mapping(uint256 => address) private _owners;
816 
817     // Mapping owner address to token count
818     mapping(address => uint256) private _balances;
819 
820     // Mapping from token ID to approved address
821     mapping(uint256 => address) private _tokenApprovals;
822 
823     // Mapping from owner to operator approvals
824     mapping(address => mapping(address => bool)) private _operatorApprovals;
825 
826     /**
827      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
828      */
829     constructor(string memory name_, string memory symbol_) {
830         _name = name_;
831         _symbol = symbol_;
832     }
833 
834     /**
835      * @dev See {IERC165-supportsInterface}.
836      */
837     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
838         return
839             interfaceId == type(IERC721).interfaceId ||
840             interfaceId == type(IERC721Metadata).interfaceId ||
841             super.supportsInterface(interfaceId);
842     }
843 
844     /**
845      * @dev See {IERC721-balanceOf}.
846      */
847     function balanceOf(address owner) public view virtual override returns (uint256) {
848         require(owner != address(0), "ERC721: balance query for the zero address");
849         return _balances[owner];
850     }
851 
852     /**
853      * @dev See {IERC721-ownerOf}.
854      */
855     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
856         address owner = _owners[tokenId];
857         require(owner != address(0), "ERC721: owner query for nonexistent token");
858         return owner;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-name}.
863      */
864     function name() public view virtual override returns (string memory) {
865         return _name;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-symbol}.
870      */
871     function symbol() public view virtual override returns (string memory) {
872         return _symbol;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-tokenURI}.
877      */
878     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
879         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
880 
881         string memory baseURI = _baseURI();
882         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
883     }
884 
885     /**
886      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
887      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
888      * by default, can be overriden in child contracts.
889      */
890     function _baseURI() internal view virtual returns (string memory) {
891         return "";
892     }
893 
894     /**
895      * @dev See {IERC721-approve}.
896      */
897     function approve(address to, uint256 tokenId) public virtual override {
898         address owner = ERC721.ownerOf(tokenId);
899         require(to != owner, "ERC721: approval to current owner");
900 
901         require(
902             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
903             "ERC721: approve caller is not owner nor approved for all"
904         );
905 
906         _approve(to, tokenId);
907     }
908 
909     /**
910      * @dev See {IERC721-getApproved}.
911      */
912     function getApproved(uint256 tokenId) public view virtual override returns (address) {
913         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
914 
915         return _tokenApprovals[tokenId];
916     }
917 
918     /**
919      * @dev See {IERC721-setApprovalForAll}.
920      */
921     function setApprovalForAll(address operator, bool approved) public virtual override {
922         _setApprovalForAll(_msgSender(), operator, approved);
923     }
924 
925     /**
926      * @dev See {IERC721-isApprovedForAll}.
927      */
928     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
929         return _operatorApprovals[owner][operator];
930     }
931 
932     /**
933      * @dev See {IERC721-transferFrom}.
934      */
935     function transferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public virtual override {
940         //solhint-disable-next-line max-line-length
941         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
942 
943         _transfer(from, to, tokenId);
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) public virtual override {
954         safeTransferFrom(from, to, tokenId, "");
955     }
956 
957     /**
958      * @dev See {IERC721-safeTransferFrom}.
959      */
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) public virtual override {
966         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
967         _safeTransfer(from, to, tokenId, _data);
968     }
969 
970     /**
971      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
972      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
973      *
974      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
975      *
976      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
977      * implement alternative mechanisms to perform token transfer, such as signature-based.
978      *
979      * Requirements:
980      *
981      * - `from` cannot be the zero address.
982      * - `to` cannot be the zero address.
983      * - `tokenId` token must exist and be owned by `from`.
984      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _safeTransfer(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) internal virtual {
994         _transfer(from, to, tokenId);
995         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
996     }
997 
998     /**
999      * @dev Returns whether `tokenId` exists.
1000      *
1001      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1002      *
1003      * Tokens start existing when they are minted (`_mint`),
1004      * and stop existing when they are burned (`_burn`).
1005      */
1006     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1007         return _owners[tokenId] != address(0);
1008     }
1009 
1010     /**
1011      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must exist.
1016      */
1017     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1018         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1019         address owner = ERC721.ownerOf(tokenId);
1020         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1021     }
1022 
1023     /**
1024      * @dev Safely mints `tokenId` and transfers it to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must not exist.
1029      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _safeMint(address to, uint256 tokenId) internal virtual {
1034         _safeMint(to, tokenId, "");
1035     }
1036 
1037     /**
1038      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1039      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1040      */
1041     function _safeMint(
1042         address to,
1043         uint256 tokenId,
1044         bytes memory _data
1045     ) internal virtual {
1046         _mint(to, tokenId);
1047         require(
1048             _checkOnERC721Received(address(0), to, tokenId, _data),
1049             "ERC721: transfer to non ERC721Receiver implementer"
1050         );
1051     }
1052 
1053     /**
1054      * @dev Mints `tokenId` and transfers it to `to`.
1055      *
1056      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must not exist.
1061      * - `to` cannot be the zero address.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _mint(address to, uint256 tokenId) internal virtual {
1066         require(to != address(0), "ERC721: mint to the zero address");
1067 
1068         _beforeTokenTransfer(address(0), to, tokenId);
1069 
1070         _balances[to] += 1;
1071         _owners[tokenId] = to;
1072 
1073         emit Transfer(address(0), to, tokenId);
1074     }
1075 
1076     /**
1077      * @dev Destroys `tokenId`.
1078      * The approval is cleared when the token is burned.
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must exist.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _burn(uint256 tokenId) internal virtual {
1087         address owner = ERC721.ownerOf(tokenId);
1088 
1089         _beforeTokenTransfer(owner, address(0), tokenId);
1090 
1091         // Clear approvals
1092         _approve(address(0), tokenId);
1093 
1094         _balances[owner] -= 1;
1095         delete _owners[tokenId];
1096 
1097         emit Transfer(owner, address(0), tokenId);
1098     }
1099 
1100     /**
1101      * @dev Transfers `tokenId` from `from` to `to`.
1102      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1103      *
1104      * Requirements:
1105      *
1106      * - `to` cannot be the zero address.
1107      * - `tokenId` token must be owned by `from`.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _transfer(
1112         address from,
1113         address to,
1114         uint256 tokenId
1115     ) internal virtual {
1116         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1117         require(to != address(0), "ERC721: transfer to the zero address");
1118 
1119         _beforeTokenTransfer(from, to, tokenId);
1120 
1121         // Clear approvals from the previous owner
1122         _approve(address(0), tokenId);
1123 
1124         _balances[from] -= 1;
1125         _balances[to] += 1;
1126         _owners[tokenId] = to;
1127 
1128         emit Transfer(from, to, tokenId);
1129     }
1130 
1131     /**
1132      * @dev Approve `to` to operate on `tokenId`
1133      *
1134      * Emits a {Approval} event.
1135      */
1136     function _approve(address to, uint256 tokenId) internal virtual {
1137         _tokenApprovals[tokenId] = to;
1138         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1139     }
1140 
1141     /**
1142      * @dev Approve `operator` to operate on all of `owner` tokens
1143      *
1144      * Emits a {ApprovalForAll} event.
1145      */
1146     function _setApprovalForAll(
1147         address owner,
1148         address operator,
1149         bool approved
1150     ) internal virtual {
1151         require(owner != operator, "ERC721: approve to caller");
1152         _operatorApprovals[owner][operator] = approved;
1153         emit ApprovalForAll(owner, operator, approved);
1154     }
1155 
1156     /**
1157      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1158      * The call is not executed if the target address is not a contract.
1159      *
1160      * @param from address representing the previous owner of the given token ID
1161      * @param to target address that will receive the tokens
1162      * @param tokenId uint256 ID of the token to be transferred
1163      * @param _data bytes optional data to send along with the call
1164      * @return bool whether the call correctly returned the expected magic value
1165      */
1166     function _checkOnERC721Received(
1167         address from,
1168         address to,
1169         uint256 tokenId,
1170         bytes memory _data
1171     ) private returns (bool) {
1172         if (to.isContract()) {
1173             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1174                 return retval == IERC721Receiver.onERC721Received.selector;
1175             } catch (bytes memory reason) {
1176                 if (reason.length == 0) {
1177                     revert("ERC721: transfer to non ERC721Receiver implementer");
1178                 } else {
1179                     assembly {
1180                         revert(add(32, reason), mload(reason))
1181                     }
1182                 }
1183             }
1184         } else {
1185             return true;
1186         }
1187     }
1188 
1189     /**
1190      * @dev Hook that is called before any token transfer. This includes minting
1191      * and burning.
1192      *
1193      * Calling conditions:
1194      *
1195      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1196      * transferred to `to`.
1197      * - When `from` is zero, `tokenId` will be minted for `to`.
1198      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1199      * - `from` and `to` are never both zero.
1200      *
1201      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1202      */
1203     function _beforeTokenTransfer(
1204         address from,
1205         address to,
1206         uint256 tokenId
1207     ) internal virtual {}
1208 }
1209 
1210 // File: contracts/NonblockingReceiver.sol
1211 
1212 
1213 pragma solidity ^0.8.6;
1214 
1215 
1216 
1217 
1218 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1219 
1220     ILayerZeroEndpoint internal endpoint;
1221 
1222     struct FailedMessages {
1223         uint payloadLength;
1224         bytes32 payloadHash;
1225     }
1226 
1227     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
1228     mapping(uint16 => bytes) public trustedRemoteLookup;
1229 
1230     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
1231 
1232     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
1233         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1234         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]), 
1235             "NonblockingReceiver: invalid source sending contract");
1236 
1237         // try-catch all errors/exceptions
1238         // having failed messages does not block messages passing
1239         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1240             // do nothing
1241         } catch {
1242             // error / exception
1243             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
1244             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1245         }
1246     }
1247 
1248     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
1249         // only internal transaction
1250         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
1251 
1252         // handle incoming message
1253         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
1254     }
1255 
1256     // abstract function
1257     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
1258 
1259     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
1260         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
1261     }
1262 
1263     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
1264         // assert there is message to retry
1265         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
1266         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
1267         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
1268         // clear the stored message
1269         failedMsg.payloadLength = 0;
1270         failedMsg.payloadHash = bytes32(0);
1271         // execute the message. revert if it fails again
1272         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1273     }
1274 
1275     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
1276         trustedRemoteLookup[_chainId] = _trustedRemote;
1277     }
1278 }
1279 
1280 // File: contracts/GhostlyGhosts.sol
1281 
1282 
1283 
1284 pragma solidity ^0.8.7;
1285 
1286 //                                                #K#EL# .                                          
1287 //                                              j,#.#W#E#### #                                        
1288 //                                            #W#t###W######## fD                                     
1289 //                                          .################K###                                     
1290 //                                         ###################t####                                   
1291 //                                       :#########################                                   
1292 //                                      #############################,                                
1293 //                                     #G#############################                                
1294 //                                     ####G###############Df#######D                                 
1295 //                                    ############################E##L                                
1296 //                                    ################Wf  G####,###,                                  
1297 //                                   i###K###.####E        ##:## L##                                  
1298 //                                    ##########,           ## #G: W                                  
1299 //                                    j#########            .:    #                                   
1300 //                                     #########                                                      
1301 //                                     L########;                  #                                  
1302 //                                      ########,                  W                                  
1303 //                                      ########                                                      
1304 //                                      ########                    f                                 
1305 //                                       ######K       Kj        W. #                                 
1306 //                                       ######      ##,  #    .#,  #E                                
1307 //                                        #####     E  G###W;#K##   #DD                               
1308 //                                        ##### ;LW#t   E#L#    #G  #;                                
1309 //                                        K#  #         ## #  t i.  #f                                
1310 //                                        #                #   #    ##                                
1311 //                                       Wt if      K     t #  #    #                                 
1312 //                                       Ki   #      #   K: f##L:##G#                                 
1313 //                                        #           :j:  tKjt.    #                                 
1314 //                                        W#tjG           #######  .W                                 
1315 //                                          W#           ####Gi### WE                                 
1316 //                                            #         ## #    D# #                                  
1317 //                                            Dt        ##:f    :#D#                                  
1318 //                                             #       .###  ##  ###                                  
1319 //                                              #:     f##D E###L##                                   
1320 //                                               ,     D###E#######                                   
1321 //                                               E   #tD###########                                   
1322 //                                               #   i############,                                   
1323 //                                              ##     L##########                                    
1324 //                                            f####D     L#######                                     
1325 //                                       :E###########Wf   ;###:                                      
1326 //                                   L##########################                                      
1327 //                                i################# ###########D                                     
1328 //                              i###E ###############W#############                                   
1329 //                             #################################Gt###                                 
1330 //                            ########################################W                               
1331 //                           W########################################W;.                             
1332 //                          K####################LW######################                             
1333 //                          ##############################################                            
1334 //                         ###############################################                            
1335 //                        .###K ###########################################t.                         
1336 //                        ##############L####################j########jttttttttD#                     
1337 //                        ###################################,########ttttttttttt                     
1338 //                       ############################################ttttttttttE                      
1339 //                       ############################################ttttttttttE                      
1340 //                      t###########################################ttttttttttG                       
1341 //                      ##########################:#################ttttttttttW                       
1342 //                      #####:#################### ################ttttttttttD                        
1343 //                      ##########################################Gfttttttttt#                        
1344 //                     j################j#####################j    tjttttttLKj                        
1345 //                     ##################E##################W       WtttED                            
1346 //                     #####################################     tK  #tK                              
1347 //                      ############ ######################:      ## :tW.E#j                          
1348 //                     #############t#####################E         WEt#      G                       
1349 //                     #############D###########, #######E     E#;   f:       .                       
1350 //                     #############E###################;        :#K #  tWj   W                       
1351 //                     #############E#################:        f   #,#L        i                      
1352 //                     ####G########f#################          ,t ##;  ,K##i :                       
1353 //                     #####W#######;################W           E####i      ,E                       
1354 //                     ############# ################K         #######     L###                       
1355 //                     ############# ######i :#######W        #################.                      
1356 //                     ############# ##:  ,W##########   .:  W#################K                      
1357 //                     ############   D############### #########################                      
1358 //                     #########;:##############################################                      
1359 //                     K#######K################################################                      
1360 //                     i################# ##################;#####;.######## ###                      
1361 //                      ####################################:###############.###                      
1362 //                      ####################################################:###                      
1363 //                      W#####################; ############################G###                      
1364 //                      .###i,##############::#################################K                      
1365 //                       #################:i###################################;                      
1366 //                       E##############.G############t########################                       
1367 //                        ############ W############# ########################i                       
1368 //                        ;#########,############################## ##########                        
1369 //                         #################K#################################                        
1370 //                          K############### ################################      
1371 
1372 
1373 contract CryptoUncle12 is Ownable, ERC721, NonblockingReceiver {
1374 
1375 
1376     address public _owner;
1377     string private baseURI;
1378     uint256 nextTokenId = 0;
1379     uint256 MAX_MINT_ETHEREUM = 5000;
1380     uint256 PRICE = 0.002 ether;
1381 
1382     uint gasForDestinationLzReceive = 350000;
1383 
1384     constructor(string memory baseURI_, address _layerZeroEndpoint) ERC721("CryptoUncle12 NFT", "CryptoUncle12") {
1385         _owner = msg.sender;
1386         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1387         baseURI = baseURI_;
1388     }
1389 
1390     // mint function
1391     function mint(uint8 numTokens) external payable {
1392         require((PRICE * numTokens) <= msg.value, "Not enough amount sent.");
1393         require(nextTokenId + numTokens <= MAX_MINT_ETHEREUM, "CryptoUncle12: Mint exceeds supply");
1394         for (uint256 i = 0; i < numTokens; i++) {
1395             _safeMint(msg.sender, ++nextTokenId);
1396         }
1397     }
1398 
1399     // This function transfers the nft from your address on the
1400     // source chain to the same address on the destination chain
1401     function traverseChains(uint16 _chainId, uint tokenId) public payable {
1402         require(msg.sender == ownerOf(tokenId), "You must own the token to traverse");
1403         require(trustedRemoteLookup[_chainId].length > 0, "This chain is currently unavailable for travel");
1404 
1405         // burn NFT, eliminating it from circulation on src chain
1406         _burn(tokenId);
1407 
1408         // abi.encode() the payload with the values to send
1409         bytes memory payload = abi.encode(msg.sender, tokenId);
1410 
1411         // encode adapterParams to specify more gas for the destination
1412         uint16 version = 1;
1413         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1414 
1415         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1416         // you will be refunded for extra gas paid
1417         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1418 
1419         require(msg.value >= messageFee, "CryptoUncle12: msg.value not enough to cover messageFee. Send gas for message fees");
1420 
1421         endpoint.send{value: msg.value}(
1422             _chainId,                           // destination chainId
1423             trustedRemoteLookup[_chainId],      // destination address of nft contract
1424             payload,                            // abi.encoded()'ed bytes
1425             payable(msg.sender),                // refund address
1426             address(0x0),                       // 'zroPaymentAddress' unused for this
1427             adapterParams                       // txParameters
1428         );
1429     }
1430 
1431     function setBaseURI(string memory URI) external onlyOwner {
1432         baseURI = URI;
1433     }
1434 
1435     function donate() external payable {
1436         // thank you
1437     }
1438 
1439     // This allows the devs to receive kind donations
1440     function withdraw(uint amt) external onlyOwner {
1441         (bool sent, ) = payable(_owner).call{value: amt}("");
1442         require(sent, "CryptoUncle12: Failed to withdraw Ether");
1443     }
1444 
1445     // just in case this fixed variable limits us from future integrations
1446     function setGasForDestinationLzReceive(uint newVal) external onlyOwner {
1447         gasForDestinationLzReceive = newVal;
1448     }
1449 
1450     // ------------------
1451     // Internal Functions
1452     // ------------------
1453  
1454     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) override internal {
1455         // decode
1456         (address toAddr, uint tokenId) = abi.decode(_payload, (address, uint));
1457         require(_srcChainId!=0,"_srcChainId");
1458         require(_srcAddress.length!=0,"_srcAddress");
1459         require(_nonce!=0,"_nonce");
1460 
1461         // mint the tokens back into existence on destination chain
1462         _safeMint(toAddr, tokenId);
1463     }
1464 
1465     function _baseURI() override internal view returns (string memory) {
1466         return baseURI;
1467     }
1468 
1469 }