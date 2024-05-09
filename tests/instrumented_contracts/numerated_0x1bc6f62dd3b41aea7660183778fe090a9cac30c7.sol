1 // File: contracts/OmniOwls.sol
2 
3 //SPDX-License-Identifier: UNLICENSED
4 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
5 
6 
7 
8 pragma solidity >=0.5.0;
9 
10 interface ILayerZeroUserApplicationConfig {
11     // @notice set the configuration of the LayerZero messaging library of the specified version
12     // @param _version - messaging library version
13     // @param _chainId - the chainId for the pending config change
14     // @param _configType - type of configuration. every messaging library has its own convention.
15     // @param _config - configuration in the bytes. can encode arbitrary content.
16     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
17 
18     // @notice set the send() LayerZero messaging library version to _version
19     // @param _version - new messaging library version
20     function setSendVersion(uint16 _version) external;
21 
22     // @notice set the lzReceive() LayerZero messaging library version to _version
23     // @param _version - new messaging library version
24     function setReceiveVersion(uint16 _version) external;
25 
26     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
27     // @param _srcChainId - the chainId of the source chain
28     // @param _srcAddress - the contract address of the source contract at the source chain
29     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
30 }
31 
32 // File: contracts/interfaces/ILayerZeroEndpoint.sol
33 
34 
35 
36 pragma solidity >=0.5.0;
37 
38 
39 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
40     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
41     // @param _dstChainId - the destination chain identifier
42     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
43     // @param _payload - a custom bytes payload to send to the destination contract
44     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
45     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
46     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
47     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
48 
49     // @notice used by the messaging library to publish verified payload
50     // @param _srcChainId - the source chain identifier
51     // @param _srcAddress - the source contract (as bytes) at the source chain
52     // @param _dstAddress - the address on destination chain
53     // @param _nonce - the unbound message ordering nonce
54     // @param _gasLimit - the gas limit for external contract execution
55     // @param _payload - verified payload to send to the destination contract
56     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
57 
58     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
59     // @param _srcChainId - the source chain identifier
60     // @param _srcAddress - the source chain contract address
61     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
62 
63     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
64     // @param _srcAddress - the source chain contract address
65     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
66 
67     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
68     // @param _dstChainId - the destination chain identifier
69     // @param _userApplication - the user app address on this EVM chain
70     // @param _payload - the custom message to send over LayerZero
71     // @param _payInZRO - if false, user app pays the protocol fee in native token
72     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
73     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
74 
75     // @notice get this Endpoint's immutable source identifier
76     function getChainId() external view returns (uint16);
77 
78     // @notice the interface to retry failed message on this Endpoint destination
79     // @param _srcChainId - the source chain identifier
80     // @param _srcAddress - the source chain contract address
81     // @param _payload - the payload to be retried
82     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
83 
84     // @notice query if any STORED payload (message blocking) at the endpoint.
85     // @param _srcChainId - the source chain identifier
86     // @param _srcAddress - the source chain contract address
87     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
88 
89     // @notice query if the _libraryAddress is valid for sending msgs.
90     // @param _userApplication - the user app address on this EVM chain
91     function getSendLibraryAddress(address _userApplication) external view returns (address);
92 
93     // @notice query if the _libraryAddress is valid for receiving msgs.
94     // @param _userApplication - the user app address on this EVM chain
95     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
96 
97     // @notice query if the non-reentrancy guard for send() is on
98     // @return true if the guard is on. false otherwise
99     function isSendingPayload() external view returns (bool);
100 
101     // @notice query if the non-reentrancy guard for receive() is on
102     // @return true if the guard is on. false otherwise
103     function isReceivingPayload() external view returns (bool);
104 
105     // @notice get the configuration of the LayerZero messaging library of the specified version
106     // @param _version - messaging library version
107     // @param _chainId - the chainId for the pending config change
108     // @param _userApplication - the contract address of the user application
109     // @param _configType - type of configuration. every messaging library has its own convention.
110     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
111 
112     // @notice get the send() LayerZero messaging library version
113     // @param _userApplication - the contract address of the user application
114     function getSendVersion(address _userApplication) external view returns (uint16);
115 
116     // @notice get the lzReceive() LayerZero messaging library version
117     // @param _userApplication - the contract address of the user application
118     function getReceiveVersion(address _userApplication) external view returns (uint16);
119 }
120 
121 // File: contracts/interfaces/ILayerZeroReceiver.sol
122 
123 
124 
125 pragma solidity >=0.5.0;
126 
127 interface ILayerZeroReceiver {
128     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
129     // @param _srcChainId - the source endpoint identifier
130     // @param _srcAddress - the source sending contract address from the source chain
131     // @param _nonce - the ordered message nonce
132     // @param _payload - the signed payload is the UA bytes has encoded to be sent
133     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
134 }
135 // File: @openzeppelin/contracts/utils/Strings.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev String operations.
144  */
145 library Strings {
146     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
147 
148     /**
149      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
150      */
151     function toString(uint256 value) internal pure returns (string memory) {
152         // Inspired by OraclizeAPI's implementation - MIT licence
153         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
154 
155         if (value == 0) {
156             return "0";
157         }
158         uint256 temp = value;
159         uint256 digits;
160         while (temp != 0) {
161             digits++;
162             temp /= 10;
163         }
164         bytes memory buffer = new bytes(digits);
165         while (value != 0) {
166             digits -= 1;
167             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
168             value /= 10;
169         }
170         return string(buffer);
171     }
172 
173     /**
174      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
175      */
176     function toHexString(uint256 value) internal pure returns (string memory) {
177         if (value == 0) {
178             return "0x00";
179         }
180         uint256 temp = value;
181         uint256 length = 0;
182         while (temp != 0) {
183             length++;
184             temp >>= 8;
185         }
186         return toHexString(value, length);
187     }
188 
189     /**
190      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
191      */
192     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
193         bytes memory buffer = new bytes(2 * length + 2);
194         buffer[0] = "0";
195         buffer[1] = "x";
196         for (uint256 i = 2 * length + 1; i > 1; --i) {
197             buffer[i] = _HEX_SYMBOLS[value & 0xf];
198             value >>= 4;
199         }
200         require(value == 0, "Strings: hex length insufficient");
201         return string(buffer);
202     }
203 }
204 
205 // File: @openzeppelin/contracts/utils/Context.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Provides information about the current execution context, including the
214  * sender of the transaction and its data. While these are generally available
215  * via msg.sender and msg.data, they should not be accessed in such a direct
216  * manner, since when dealing with meta-transactions the account sending and
217  * paying for execution may not be the actual sender (as far as an application
218  * is concerned).
219  *
220  * This contract is only required for intermediate, library-like contracts.
221  */
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes calldata) {
228         return msg.data;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/access/Ownable.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
240 /**
241  * @dev Contract module which provides a basic access control mechanism, where
242  * there is an account (an owner) that can be granted exclusive access to
243  * specific functions.
244  *
245  * By default, the owner account will be the one that deploys the contract. This
246  * can later be changed with {transferOwnership}.
247  *
248  * This module is used through inheritance. It will make available the modifier
249  * `onlyOwner`, which can be applied to your functions to restrict their use to
250  * the owner.
251  */
252 abstract contract Ownable is Context {
253     address private _owner;
254 
255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257     /**
258      * @dev Initializes the contract setting the deployer as the initial owner.
259      */
260     constructor() {
261         _transferOwnership(_msgSender());
262     }
263 
264     /**
265      * @dev Returns the address of the current owner.
266      */
267     function owner() public view virtual returns (address) {
268         return _owner;
269     }
270 
271     /**
272      * @dev Throws if called by any account other than the owner.
273      */
274     modifier onlyOwner() {
275         require(owner() == _msgSender(), "Ownable: caller is not the owner");
276         _;
277     }
278 
279     /**
280      * @dev Leaves the contract without owner. It will not be possible to call
281      * `onlyOwner` functions anymore. Can only be called by the current owner.
282      *
283      * NOTE: Renouncing ownership will leave the contract without an owner,
284      * thereby removing any functionality that is only available to the owner.
285      */
286     function renounceOwnership() public virtual onlyOwner {
287         _transferOwnership(address(0));
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      * Can only be called by the current owner.
293      */
294     function transferOwnership(address newOwner) public virtual onlyOwner {
295         require(newOwner != address(0), "Ownable: new owner is the zero address");
296         _transferOwnership(newOwner);
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Internal function without access restriction.
302      */
303     function _transferOwnership(address newOwner) internal virtual {
304         address oldOwner = _owner;
305         _owner = newOwner;
306         emit OwnershipTransferred(oldOwner, newOwner);
307     }
308 }
309 
310 // File: @openzeppelin/contracts/utils/Address.sol
311 
312 
313 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 /**
318  * @dev Collection of functions related to the address type
319  */
320 library Address {
321     /**
322      * @dev Returns true if `account` is a contract.
323      *
324      * [IMPORTANT]
325      * ====
326      * It is unsafe to assume that an address for which this function returns
327      * false is an externally-owned account (EOA) and not a contract.
328      *
329      * Among others, `isContract` will return false for the following
330      * types of addresses:
331      *
332      *  - an externally-owned account
333      *  - a contract in construction
334      *  - an address where a contract will be created
335      *  - an address where a contract lived, but was destroyed
336      * ====
337      */
338     function isContract(address account) internal view returns (bool) {
339         // This method relies on extcodesize, which returns 0 for contracts in
340         // construction, since the code is only stored at the end of the
341         // constructor execution.
342 
343         uint256 size;
344         assembly {
345             size := extcodesize(account)
346         }
347         return size > 0;
348     }
349 
350     /**
351      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352      * `recipient`, forwarding all available gas and reverting on errors.
353      *
354      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355      * of certain opcodes, possibly making contracts go over the 2300 gas limit
356      * imposed by `transfer`, making them unable to receive funds via
357      * `transfer`. {sendValue} removes this limitation.
358      *
359      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360      *
361      * IMPORTANT: because control is transferred to `recipient`, care must be
362      * taken to not create reentrancy vulnerabilities. Consider using
363      * {ReentrancyGuard} or the
364      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365      */
366     function sendValue(address payable recipient, uint256 amount) internal {
367         require(address(this).balance >= amount, "Address: insufficient balance");
368 
369         (bool success, ) = recipient.call{value: amount}("");
370         require(success, "Address: unable to send value, recipient may have reverted");
371     }
372 
373     /**
374      * @dev Performs a Solidity function call using a low level `call`. A
375      * plain `call` is an unsafe replacement for a function call: use this
376      * function instead.
377      *
378      * If `target` reverts with a revert reason, it is bubbled up by this
379      * function (like regular Solidity function calls).
380      *
381      * Returns the raw returned data. To convert to the expected return value,
382      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
383      *
384      * Requirements:
385      *
386      * - `target` must be a contract.
387      * - calling `target` with `data` must not revert.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionCall(target, data, "Address: low-level call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
397      * `errorMessage` as a fallback revert reason when `target` reverts.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, 0, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but also transferring `value` wei to `target`.
412      *
413      * Requirements:
414      *
415      * - the calling contract must have an ETH balance of at least `value`.
416      * - the called Solidity function must be `payable`.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
430      * with `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(address(this).balance >= value, "Address: insufficient balance for call");
441         require(isContract(target), "Address: call to non-contract");
442 
443         (bool success, bytes memory returndata) = target.call{value: value}(data);
444         return verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
454         return functionStaticCall(target, data, "Address: low-level static call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal view returns (bytes memory) {
468         require(isContract(target), "Address: static call to non-contract");
469 
470         (bool success, bytes memory returndata) = target.staticcall(data);
471         return verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
481         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
486      * but performing a delegate call.
487      *
488      * _Available since v3.4._
489      */
490     function functionDelegateCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal returns (bytes memory) {
495         require(isContract(target), "Address: delegate call to non-contract");
496 
497         (bool success, bytes memory returndata) = target.delegatecall(data);
498         return verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     /**
502      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
503      * revert reason using the provided one.
504      *
505      * _Available since v4.3._
506      */
507     function verifyCallResult(
508         bool success,
509         bytes memory returndata,
510         string memory errorMessage
511     ) internal pure returns (bytes memory) {
512         if (success) {
513             return returndata;
514         } else {
515             // Look for revert reason and bubble it up if present
516             if (returndata.length > 0) {
517                 // The easiest way to bubble the revert reason is using memory via assembly
518 
519                 assembly {
520                     let returndata_size := mload(returndata)
521                     revert(add(32, returndata), returndata_size)
522                 }
523             } else {
524                 revert(errorMessage);
525             }
526         }
527     }
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @title ERC721 token receiver interface
539  * @dev Interface for any contract that wants to support safeTransfers
540  * from ERC721 asset contracts.
541  */
542 interface IERC721Receiver {
543     /**
544      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
545      * by `operator` from `from`, this function is called.
546      *
547      * It must return its Solidity selector to confirm the token transfer.
548      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
549      *
550      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
551      */
552     function onERC721Received(
553         address operator,
554         address from,
555         uint256 tokenId,
556         bytes calldata data
557     ) external returns (bytes4);
558 }
559 
560 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @dev Interface of the ERC165 standard, as defined in the
569  * https://eips.ethereum.org/EIPS/eip-165[EIP].
570  *
571  * Implementers can declare support of contract interfaces, which can then be
572  * queried by others ({ERC165Checker}).
573  *
574  * For an implementation, see {ERC165}.
575  */
576 interface IERC165 {
577     /**
578      * @dev Returns true if this contract implements the interface defined by
579      * `interfaceId`. See the corresponding
580      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
581      * to learn more about how these ids are created.
582      *
583      * This function call must use less than 30 000 gas.
584      */
585     function supportsInterface(bytes4 interfaceId) external view returns (bool);
586 }
587 
588 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @dev Implementation of the {IERC165} interface.
598  *
599  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
600  * for the additional interface id that will be supported. For example:
601  *
602  * ```solidity
603  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
604  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
605  * }
606  * ```
607  *
608  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
609  */
610 abstract contract ERC165 is IERC165 {
611     /**
612      * @dev See {IERC165-supportsInterface}.
613      */
614     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615         return interfaceId == type(IERC165).interfaceId;
616     }
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
620 
621 
622 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 
627 /**
628  * @dev Required interface of an ERC721 compliant contract.
629  */
630 interface IERC721 is IERC165 {
631     /**
632      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
633      */
634     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
635 
636     /**
637      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
638      */
639     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
640 
641     /**
642      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
643      */
644     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
645 
646     /**
647      * @dev Returns the number of tokens in ``owner``'s account.
648      */
649     function balanceOf(address owner) external view returns (uint256 balance);
650 
651     /**
652      * @dev Returns the owner of the `tokenId` token.
653      *
654      * Requirements:
655      *
656      * - `tokenId` must exist.
657      */
658     function ownerOf(uint256 tokenId) external view returns (address owner);
659 
660     /**
661      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
662      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
663      *
664      * Requirements:
665      *
666      * - `from` cannot be the zero address.
667      * - `to` cannot be the zero address.
668      * - `tokenId` token must exist and be owned by `from`.
669      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
670      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
671      *
672      * Emits a {Transfer} event.
673      */
674     function safeTransferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) external;
679 
680     /**
681      * @dev Transfers `tokenId` token from `from` to `to`.
682      *
683      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
684      *
685      * Requirements:
686      *
687      * - `from` cannot be the zero address.
688      * - `to` cannot be the zero address.
689      * - `tokenId` token must be owned by `from`.
690      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
691      *
692      * Emits a {Transfer} event.
693      */
694     function transferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) external;
699 
700     /**
701      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
702      * The approval is cleared when the token is transferred.
703      *
704      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
705      *
706      * Requirements:
707      *
708      * - The caller must own the token or be an approved operator.
709      * - `tokenId` must exist.
710      *
711      * Emits an {Approval} event.
712      */
713     function approve(address to, uint256 tokenId) external;
714 
715     /**
716      * @dev Returns the account approved for `tokenId` token.
717      *
718      * Requirements:
719      *
720      * - `tokenId` must exist.
721      */
722     function getApproved(uint256 tokenId) external view returns (address operator);
723 
724     /**
725      * @dev Approve or remove `operator` as an operator for the caller.
726      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
727      *
728      * Requirements:
729      *
730      * - The `operator` cannot be the caller.
731      *
732      * Emits an {ApprovalForAll} event.
733      */
734     function setApprovalForAll(address operator, bool _approved) external;
735 
736     /**
737      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
738      *
739      * See {setApprovalForAll}
740      */
741     function isApprovedForAll(address owner, address operator) external view returns (bool);
742 
743     /**
744      * @dev Safely transfers `tokenId` token from `from` to `to`.
745      *
746      * Requirements:
747      *
748      * - `from` cannot be the zero address.
749      * - `to` cannot be the zero address.
750      * - `tokenId` token must exist and be owned by `from`.
751      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
752      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
753      *
754      * Emits a {Transfer} event.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes calldata data
761     ) external;
762 }
763 
764 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
765 
766 
767 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 
772 /**
773  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
774  * @dev See https://eips.ethereum.org/EIPS/eip-721
775  */
776 interface IERC721Metadata is IERC721 {
777     /**
778      * @dev Returns the token collection name.
779      */
780     function name() external view returns (string memory);
781 
782     /**
783      * @dev Returns the token collection symbol.
784      */
785     function symbol() external view returns (string memory);
786 
787     /**
788      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
789      */
790     function tokenURI(uint256 tokenId) external view returns (string memory);
791 }
792 
793 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
794 
795 
796 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
797 
798 pragma solidity ^0.8.0;
799 
800 
801 
802 
803 
804 
805 
806 
807 /**
808  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
809  * the Metadata extension, but not including the Enumerable extension, which is available separately as
810  * {ERC721Enumerable}.
811  */
812 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
813     using Address for address;
814     using Strings for uint256;
815 
816     // Token name
817     string private _name;
818 
819     // Token symbol
820     string private _symbol;
821 
822     // Mapping from token ID to owner address
823     mapping(uint256 => address) private _owners;
824 
825     // Mapping owner address to token count
826     mapping(address => uint256) private _balances;
827 
828     // Mapping from token ID to approved address
829     mapping(uint256 => address) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     /**
835      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
836      */
837     constructor(string memory name_, string memory symbol_) {
838         _name = name_;
839         _symbol = symbol_;
840     }
841 
842     /**
843      * @dev See {IERC165-supportsInterface}.
844      */
845     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
846         return
847             interfaceId == type(IERC721).interfaceId ||
848             interfaceId == type(IERC721Metadata).interfaceId ||
849             super.supportsInterface(interfaceId);
850     }
851 
852     /**
853      * @dev See {IERC721-balanceOf}.
854      */
855     function balanceOf(address owner) public view virtual override returns (uint256) {
856         require(owner != address(0), "ERC721: balance query for the zero address");
857         return _balances[owner];
858     }
859 
860     /**
861      * @dev See {IERC721-ownerOf}.
862      */
863     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
864         address owner = _owners[tokenId];
865         require(owner != address(0), "ERC721: owner query for nonexistent token");
866         return owner;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-name}.
871      */
872     function name() public view virtual override returns (string memory) {
873         return _name;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-symbol}.
878      */
879     function symbol() public view virtual override returns (string memory) {
880         return _symbol;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-tokenURI}.
885      */
886     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
887         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
888 
889         string memory baseURI = _baseURI();
890         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
891     }
892 
893     /**
894      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
895      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
896      * by default, can be overriden in child contracts.
897      */
898     function _baseURI() internal view virtual returns (string memory) {
899         return "";
900     }
901 
902     /**
903      * @dev See {IERC721-approve}.
904      */
905     function approve(address to, uint256 tokenId) public virtual override {
906         address owner = ERC721.ownerOf(tokenId);
907         require(to != owner, "ERC721: approval to current owner");
908 
909         require(
910             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
911             "ERC721: approve caller is not owner nor approved for all"
912         );
913 
914         _approve(to, tokenId);
915     }
916 
917     /**
918      * @dev See {IERC721-getApproved}.
919      */
920     function getApproved(uint256 tokenId) public view virtual override returns (address) {
921         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
922 
923         return _tokenApprovals[tokenId];
924     }
925 
926     /**
927      * @dev See {IERC721-setApprovalForAll}.
928      */
929     function setApprovalForAll(address operator, bool approved) public virtual override {
930         _setApprovalForAll(_msgSender(), operator, approved);
931     }
932 
933     /**
934      * @dev See {IERC721-isApprovedForAll}.
935      */
936     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
937         return _operatorApprovals[owner][operator];
938     }
939 
940     /**
941      * @dev See {IERC721-transferFrom}.
942      */
943     function transferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public virtual override {
948         //solhint-disable-next-line max-line-length
949         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
950 
951         _transfer(from, to, tokenId);
952     }
953 
954     /**
955      * @dev See {IERC721-safeTransferFrom}.
956      */
957     function safeTransferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         safeTransferFrom(from, to, tokenId, "");
963     }
964 
965     /**
966      * @dev See {IERC721-safeTransferFrom}.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) public virtual override {
974         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
975         _safeTransfer(from, to, tokenId, _data);
976     }
977 
978     /**
979      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
980      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
981      *
982      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
983      *
984      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
985      * implement alternative mechanisms to perform token transfer, such as signature-based.
986      *
987      * Requirements:
988      *
989      * - `from` cannot be the zero address.
990      * - `to` cannot be the zero address.
991      * - `tokenId` token must exist and be owned by `from`.
992      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _safeTransfer(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) internal virtual {
1002         _transfer(from, to, tokenId);
1003         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1004     }
1005 
1006     /**
1007      * @dev Returns whether `tokenId` exists.
1008      *
1009      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1010      *
1011      * Tokens start existing when they are minted (`_mint`),
1012      * and stop existing when they are burned (`_burn`).
1013      */
1014     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1015         return _owners[tokenId] != address(0);
1016     }
1017 
1018     /**
1019      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must exist.
1024      */
1025     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1026         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1027         address owner = ERC721.ownerOf(tokenId);
1028         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1029     }
1030 
1031     /**
1032      * @dev Safely mints `tokenId` and transfers it to `to`.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must not exist.
1037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _safeMint(address to, uint256 tokenId) internal virtual {
1042         _safeMint(to, tokenId, "");
1043     }
1044 
1045     /**
1046      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1047      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1048      */
1049     function _safeMint(
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) internal virtual {
1054         _mint(to, tokenId);
1055         require(
1056             _checkOnERC721Received(address(0), to, tokenId, _data),
1057             "ERC721: transfer to non ERC721Receiver implementer"
1058         );
1059     }
1060 
1061     /**
1062      * @dev Mints `tokenId` and transfers it to `to`.
1063      *
1064      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must not exist.
1069      * - `to` cannot be the zero address.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _mint(address to, uint256 tokenId) internal virtual {
1074         require(to != address(0), "ERC721: mint to the zero address");
1075 
1076         _beforeTokenTransfer(address(0), to, tokenId);
1077 
1078         _balances[to] += 1;
1079         _owners[tokenId] = to;
1080 
1081         emit Transfer(address(0), to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev Destroys `tokenId`.
1086      * The approval is cleared when the token is burned.
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must exist.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _burn(uint256 tokenId) internal virtual {
1095         address owner = ERC721.ownerOf(tokenId);
1096 
1097         _beforeTokenTransfer(owner, address(0), tokenId);
1098 
1099         // Clear approvals
1100         _approve(address(0), tokenId);
1101 
1102         _balances[owner] -= 1;
1103         delete _owners[tokenId];
1104 
1105         emit Transfer(owner, address(0), tokenId);
1106     }
1107 
1108     /**
1109      * @dev Transfers `tokenId` from `from` to `to`.
1110      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `tokenId` token must be owned by `from`.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _transfer(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) internal virtual {
1124         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1125         require(to != address(0), "ERC721: transfer to the zero address");
1126 
1127         _beforeTokenTransfer(from, to, tokenId);
1128 
1129         // Clear approvals from the previous owner
1130         _approve(address(0), tokenId);
1131 
1132         _balances[from] -= 1;
1133         _balances[to] += 1;
1134         _owners[tokenId] = to;
1135 
1136         emit Transfer(from, to, tokenId);
1137     }
1138 
1139     /**
1140      * @dev Approve `to` to operate on `tokenId`
1141      *
1142      * Emits a {Approval} event.
1143      */
1144     function _approve(address to, uint256 tokenId) internal virtual {
1145         _tokenApprovals[tokenId] = to;
1146         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1147     }
1148 
1149     /**
1150      * @dev Approve `operator` to operate on all of `owner` tokens
1151      *
1152      * Emits a {ApprovalForAll} event.
1153      */
1154     function _setApprovalForAll(
1155         address owner,
1156         address operator,
1157         bool approved
1158     ) internal virtual {
1159         require(owner != operator, "ERC721: approve to caller");
1160         _operatorApprovals[owner][operator] = approved;
1161         emit ApprovalForAll(owner, operator, approved);
1162     }
1163 
1164     /**
1165      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1166      * The call is not executed if the target address is not a contract.
1167      *
1168      * @param from address representing the previous owner of the given token ID
1169      * @param to target address that will receive the tokens
1170      * @param tokenId uint256 ID of the token to be transferred
1171      * @param _data bytes optional data to send along with the call
1172      * @return bool whether the call correctly returned the expected magic value
1173      */
1174     function _checkOnERC721Received(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) private returns (bool) {
1180         if (to.isContract()) {
1181             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1182                 return retval == IERC721Receiver.onERC721Received.selector;
1183             } catch (bytes memory reason) {
1184                 if (reason.length == 0) {
1185                     revert("ERC721: transfer to non ERC721Receiver implementer");
1186                 } else {
1187                     assembly {
1188                         revert(add(32, reason), mload(reason))
1189                     }
1190                 }
1191             }
1192         } else {
1193             return true;
1194         }
1195     }
1196 
1197     /**
1198      * @dev Hook that is called before any token transfer. This includes minting
1199      * and burning.
1200      *
1201      * Calling conditions:
1202      *
1203      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1204      * transferred to `to`.
1205      * - When `from` is zero, `tokenId` will be minted for `to`.
1206      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1207      * - `from` and `to` are never both zero.
1208      *
1209      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1210      */
1211     function _beforeTokenTransfer(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) internal virtual {}
1216 }
1217 
1218 // File: contracts/NonblockingReceiver.sol
1219 
1220 
1221 pragma solidity ^0.8.6;
1222 
1223 
1224 
1225 
1226 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1227 
1228     ILayerZeroEndpoint internal endpoint;
1229 
1230     struct FailedMessages {
1231         uint payloadLength;
1232         bytes32 payloadHash;
1233     }
1234 
1235     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
1236     mapping(uint16 => bytes) public trustedRemoteLookup;
1237 
1238     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
1239 
1240     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
1241         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1242         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]), 
1243             "NonblockingReceiver: invalid source sending contract");
1244 
1245         // try-catch all errors/exceptions
1246         // having failed messages does not block messages passing
1247         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1248             // do nothing
1249         } catch {
1250             // error / exception
1251             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
1252             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1253         }
1254     }
1255 
1256     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
1257         // only internal transaction
1258         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
1259 
1260         // handle incoming message
1261         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
1262     }
1263 
1264     // abstract function
1265     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
1266 
1267     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
1268         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
1269     }
1270 
1271     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
1272         // assert there is message to retry
1273         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
1274         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
1275         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
1276         // clear the stored message
1277         failedMsg.payloadLength = 0;
1278         failedMsg.payloadHash = bytes32(0);
1279         // execute the message. revert if it fails again
1280         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1281     }
1282 
1283     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
1284         trustedRemoteLookup[_chainId] = _trustedRemote;
1285     }
1286 }
1287 
1288 // File: contracts/OmniOwls.sol
1289 
1290 
1291 
1292 pragma solidity ^0.8.7;
1293 
1294 contract OmniOwls is Ownable, ERC721, NonblockingReceiver {
1295 
1296     address public _owner;
1297     string private baseURI;
1298     uint256 nextTokenId = 0;
1299     uint256 MAX_MINT_ETHEREUM = 1000;
1300 
1301     uint gasForDestinationLzReceive = 350000;
1302 
1303     constructor(string memory baseURI_, address _layerZeroEndpoint) ERC721("OmniOwls", "Hoot") { 
1304         _owner = msg.sender;
1305         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1306         baseURI = baseURI_;
1307     }
1308 
1309     // mint function
1310     // you can choose to mint 1 or 2
1311     // mint is free, but payments are accepted
1312     function mint(uint8 numTokens) external payable {
1313         require(numTokens < 3, "Max 2 NFTs per transaction");
1314         require(nextTokenId + numTokens <= MAX_MINT_ETHEREUM, "Mint exceeds supply");
1315         _safeMint(msg.sender, ++nextTokenId);
1316         if (numTokens == 2) {
1317             _safeMint(msg.sender, ++nextTokenId);
1318         }
1319     }
1320 
1321     // This function transfers the nft from your address on the 
1322     // source chain to the same address on the destination chain
1323     function traverseChains(uint16 _chainId, uint tokenId) public payable {
1324         require(msg.sender == ownerOf(tokenId), "You must own the token to traverse");
1325         require(trustedRemoteLookup[_chainId].length > 0, "This chain is currently unavailable for travel");
1326 
1327         // burn NFT, eliminating it from circulation on src chain
1328         _burn(tokenId);
1329 
1330         // abi.encode() the payload with the values to send
1331         bytes memory payload = abi.encode(msg.sender, tokenId);
1332 
1333         // encode adapterParams to specify more gas for the destination
1334         uint16 version = 1;
1335         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1336 
1337         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1338         // you will be refunded for extra gas paid
1339         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1340         
1341         require(msg.value >= messageFee, "msg.value not enough to cover messageFee. Send gas for message fees");
1342 
1343         endpoint.send{value: msg.value}(
1344             _chainId,                           // destination chainId
1345             trustedRemoteLookup[_chainId],      // destination address of nft contract
1346             payload,                            // abi.encoded()'ed bytes
1347             payable(msg.sender),                // refund address
1348             address(0x0),                       // 'zroPaymentAddress' unused for this
1349             adapterParams                       // txParameters 
1350         );
1351     }  
1352 
1353     function setBaseURI(string memory URI) external onlyOwner {
1354         baseURI = URI;
1355     }
1356 
1357     function donate() external payable {
1358         // thank you
1359     }
1360 
1361     // This allows the devs to receive kind donations
1362     function withdraw(uint amt) external onlyOwner {
1363         (bool sent, ) = payable(_owner).call{value: amt}("");
1364         require(sent, "Failed to withdraw Ether");
1365     }
1366 
1367     // just in case this fixed variable limits us from future integrations
1368     function setGasForDestinationLzReceive(uint newVal) external onlyOwner {
1369         gasForDestinationLzReceive = newVal;
1370     }
1371 
1372     // ------------------
1373     // Internal Functions
1374     // ------------------
1375 
1376     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) override internal {
1377         // decode
1378         (address toAddr, uint tokenId) = abi.decode(_payload, (address, uint));
1379 
1380         // mint the tokens back into existence on destination chain
1381         _safeMint(toAddr, tokenId);
1382     }  
1383 
1384     function _baseURI() override internal view returns (string memory) {
1385         return baseURI;
1386     }
1387 }