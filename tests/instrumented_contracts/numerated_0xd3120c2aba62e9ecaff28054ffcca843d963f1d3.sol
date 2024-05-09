1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
4 
5 
6 
7 pragma solidity >=0.5.0;
8 
9 interface ILayerZeroUserApplicationConfig {
10     // @notice set the configuration of the LayerZero messaging library of the specified version
11     // @param _version - messaging library version
12     // @param _chainId - the chainId for the pending config change
13     // @param _configType - type of configuration. every messaging library has its own convention.
14     // @param _config - configuration in the bytes. can encode arbitrary content.
15     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
16 
17     // @notice set the send() LayerZero messaging library version to _version
18     // @param _version - new messaging library version
19     function setSendVersion(uint16 _version) external;
20 
21     // @notice set the lzReceive() LayerZero messaging library version to _version
22     // @param _version - new messaging library version
23     function setReceiveVersion(uint16 _version) external;
24 
25     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
26     // @param _srcChainId - the chainId of the source chain
27     // @param _srcAddress - the contract address of the source contract at the source chain
28     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
29 }
30 
31 // File: contracts/interfaces/ILayerZeroEndpoint.sol
32 
33 
34 
35 pragma solidity >=0.5.0;
36 
37 
38 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
39     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
40     // @param _dstChainId - the destination chain identifier
41     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
42     // @param _payload - a custom bytes payload to send to the destination contract
43     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
44     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
45     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
46     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
47 
48     // @notice used by the messaging library to publish verified payload
49     // @param _srcChainId - the source chain identifier
50     // @param _srcAddress - the source contract (as bytes) at the source chain
51     // @param _dstAddress - the address on destination chain
52     // @param _nonce - the unbound message ordering nonce
53     // @param _gasLimit - the gas limit for external contract execution
54     // @param _payload - verified payload to send to the destination contract
55     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
56 
57     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
58     // @param _srcChainId - the source chain identifier
59     // @param _srcAddress - the source chain contract address
60     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
61 
62     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
63     // @param _srcAddress - the source chain contract address
64     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
65 
66     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
67     // @param _dstChainId - the destination chain identifier
68     // @param _userApplication - the user app address on this EVM chain
69     // @param _payload - the custom message to send over LayerZero
70     // @param _payInZRO - if false, user app pays the protocol fee in native token
71     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
72     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
73 
74     // @notice get this Endpoint's immutable source identifier
75     function getChainId() external view returns (uint16);
76 
77     // @notice the interface to retry failed message on this Endpoint destination
78     // @param _srcChainId - the source chain identifier
79     // @param _srcAddress - the source chain contract address
80     // @param _payload - the payload to be retried
81     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
82 
83     // @notice query if any STORED payload (message blocking) at the endpoint.
84     // @param _srcChainId - the source chain identifier
85     // @param _srcAddress - the source chain contract address
86     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
87 
88     // @notice query if the _libraryAddress is valid for sending msgs.
89     // @param _userApplication - the user app address on this EVM chain
90     function getSendLibraryAddress(address _userApplication) external view returns (address);
91 
92     // @notice query if the _libraryAddress is valid for receiving msgs.
93     // @param _userApplication - the user app address on this EVM chain
94     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
95 
96     // @notice query if the non-reentrancy guard for send() is on
97     // @return true if the guard is on. false otherwise
98     function isSendingPayload() external view returns (bool);
99 
100     // @notice query if the non-reentrancy guard for receive() is on
101     // @return true if the guard is on. false otherwise
102     function isReceivingPayload() external view returns (bool);
103 
104     // @notice get the configuration of the LayerZero messaging library of the specified version
105     // @param _version - messaging library version
106     // @param _chainId - the chainId for the pending config change
107     // @param _userApplication - the contract address of the user application
108     // @param _configType - type of configuration. every messaging library has its own convention.
109     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
110 
111     // @notice get the send() LayerZero messaging library version
112     // @param _userApplication - the contract address of the user application
113     function getSendVersion(address _userApplication) external view returns (uint16);
114 
115     // @notice get the lzReceive() LayerZero messaging library version
116     // @param _userApplication - the contract address of the user application
117     function getReceiveVersion(address _userApplication) external view returns (uint16);
118 }
119 
120 // File: contracts/interfaces/ILayerZeroReceiver.sol
121 
122 
123 
124 pragma solidity >=0.5.0;
125 
126 interface ILayerZeroReceiver {
127     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
128     // @param _srcChainId - the source endpoint identifier
129     // @param _srcAddress - the source sending contract address from the source chain
130     // @param _nonce - the ordered message nonce
131     // @param _payload - the signed payload is the UA bytes has encoded to be sent
132     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
133 }
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Collection of functions related to the address type
141  */
142 library Address {
143     /**
144      * @dev Returns true if `account` is a contract.
145      *
146      * [IMPORTANT]
147      * ====
148      * It is unsafe to assume that an address for which this function returns
149      * false is an externally-owned account (EOA) and not a contract.
150      *
151      * Among others, `isContract` will return false for the following
152      * types of addresses:
153      *
154      *  - an externally-owned account
155      *  - a contract in construction
156      *  - an address where a contract will be created
157      *  - an address where a contract lived, but was destroyed
158      * ====
159      *
160      * [IMPORTANT]
161      * ====
162      * You shouldn't rely on `isContract` to protect against flash loan attacks!
163      *
164      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
165      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
166      * constructor.
167      * ====
168      */
169     function isContract(address account) internal view returns (bool) {
170         // This method relies on extcodesize/address.code.length, which returns 0
171         // for contracts in construction, since the code is only stored at the end
172         // of the constructor execution.
173 
174         return account.code.length > 0;
175     }
176 
177     /**
178      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
179      * `recipient`, forwarding all available gas and reverting on errors.
180      *
181      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
182      * of certain opcodes, possibly making contracts go over the 2300 gas limit
183      * imposed by `transfer`, making them unable to receive funds via
184      * `transfer`. {sendValue} removes this limitation.
185      *
186      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
187      *
188      * IMPORTANT: because control is transferred to `recipient`, care must be
189      * taken to not create reentrancy vulnerabilities. Consider using
190      * {ReentrancyGuard} or the
191      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
192      */
193     function sendValue(address payable recipient, uint256 amount) internal {
194         require(address(this).balance >= amount, "Address: insufficient balance");
195 
196         (bool success, ) = recipient.call{value: amount}("");
197         require(success, "Address: unable to send value, recipient may have reverted");
198     }
199 
200     /**
201      * @dev Performs a Solidity function call using a low level `call`. A
202      * plain `call` is an unsafe replacement for a function call: use this
203      * function instead.
204      *
205      * If `target` reverts with a revert reason, it is bubbled up by this
206      * function (like regular Solidity function calls).
207      *
208      * Returns the raw returned data. To convert to the expected return value,
209      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
210      *
211      * Requirements:
212      *
213      * - `target` must be a contract.
214      * - calling `target` with `data` must not revert.
215      *
216      * _Available since v3.1._
217      */
218     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionCall(target, data, "Address: low-level call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
224      * `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but also transferring `value` wei to `target`.
239      *
240      * Requirements:
241      *
242      * - the calling contract must have an ETH balance of at least `value`.
243      * - the called Solidity function must be `payable`.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value
251     ) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
257      * with `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(address(this).balance >= value, "Address: insufficient balance for call");
268         require(isContract(target), "Address: call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.call{value: value}(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but performing a static call.
277      *
278      * _Available since v3.3._
279      */
280     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
281         return functionStaticCall(target, data, "Address: low-level static call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a static call.
287      *
288      * _Available since v3.3._
289      */
290     function functionStaticCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal view returns (bytes memory) {
295         require(isContract(target), "Address: static call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.staticcall(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but performing a delegate call.
304      *
305      * _Available since v3.4._
306      */
307     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
313      * but performing a delegate call.
314      *
315      * _Available since v3.4._
316      */
317     function functionDelegateCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         require(isContract(target), "Address: delegate call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.delegatecall(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
330      * revert reason using the provided one.
331      *
332      * _Available since v4.3._
333      */
334     function verifyCallResult(
335         bool success,
336         bytes memory returndata,
337         string memory errorMessage
338     ) internal pure returns (bytes memory) {
339         if (success) {
340             return returndata;
341         } else {
342             // Look for revert reason and bubble it up if present
343             if (returndata.length > 0) {
344                 // The easiest way to bubble the revert reason is using memory via assembly
345 
346                 assembly {
347                     let returndata_size := mload(returndata)
348                     revert(add(32, returndata), returndata_size)
349                 }
350             } else {
351                 revert(errorMessage);
352             }
353         }
354     }
355 }
356 
357 pragma solidity ^0.8.0;
358 
359 /*
360  * @dev Provides information about the current execution context, including the
361  * sender of the transaction and its data. While these are generally available
362  * via msg.sender and msg.data, they should not be accessed in such a direct
363  * manner, since when dealing with meta-transactions the account sending and
364  * paying for execution may not be the actual sender (as far as an application
365  * is concerned).
366  *
367  * This contract is only required for intermediate, library-like contracts.
368  */
369 abstract contract Context {
370     function _msgSender() internal view virtual returns (address) {
371         return msg.sender;
372     }
373 
374     function _msgData() internal view virtual returns (bytes calldata) {
375         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
376         return msg.data;
377     }
378 }
379 
380 
381 
382 
383 
384 
385 
386 
387 
388 
389 pragma solidity ^0.8.0;
390 
391 /**
392  * @dev Interface of the ERC165 standard, as defined in the
393  * https://eips.ethereum.org/EIPS/eip-165[EIP].
394  *
395  * Implementers can declare support of contract interfaces, which can then be
396  * queried by others ({ERC165Checker}).
397  *
398  * For an implementation, see {ERC165}.
399  */
400 
401 interface IERC165 {
402     /**
403      * @dev Returns true if this contract implements the interface defined by
404      * `interfaceId`. See the corresponding
405      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
406      * to learn more about how these ids are created.
407      *
408      * This function call must use less than 30 000 gas.
409      */
410     function supportsInterface(bytes4 interfaceId) external view returns (bool);
411 }
412 
413 
414 pragma solidity ^0.8.0;
415 
416 
417 /**
418  * @dev Required interface of an ERC721 compliant contract.
419  */
420 interface IERC721 is IERC165 {
421     /**
422      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
423      */
424     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
425 
426     /**
427      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
428      */
429     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
430 
431     /**
432      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
433      */
434     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
435 
436     /**
437      * @dev Returns the number of tokens in ``owner``'s account.
438      */
439     function balanceOf(address owner) external view returns (uint256 balance);
440 
441     /**
442      * @dev Returns the owner of the `tokenId` token.
443      *
444      * Requirements:
445      *
446      * - `tokenId` must exist.
447      */
448     function ownerOf(uint256 tokenId) external view returns (address owner);
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
452      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must exist and be owned by `from`.
459      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
461      *
462      * Emits a {Transfer} event.
463      */
464     function safeTransferFrom(address from, address to, uint256 tokenId) external;
465 
466     /**
467      * @dev Transfers `tokenId` token from `from` to `to`.
468      *
469      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `tokenId` token must be owned by `from`.
476      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
477      *
478      * Emits a {Transfer} event.
479      */
480     function transferFrom(address from, address to, uint256 tokenId) external;
481 
482     /**
483      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
484      * The approval is cleared when the token is transferred.
485      *
486      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
487      *
488      * Requirements:
489      *
490      * - The caller must own the token or be an approved operator.
491      * - `tokenId` must exist.
492      *
493      * Emits an {Approval} event.
494      */
495     function approve(address to, uint256 tokenId) external;
496 
497     /**
498      * @dev Returns the account approved for `tokenId` token.
499      *
500      * Requirements:
501      *
502      * - `tokenId` must exist.
503      */
504     function getApproved(uint256 tokenId) external view returns (address operator);
505 
506     /**
507      * @dev Approve or remove `operator` as an operator for the caller.
508      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
509      *
510      * Requirements:
511      *
512      * - The `operator` cannot be the caller.
513      *
514      * Emits an {ApprovalForAll} event.
515      */
516     function setApprovalForAll(address operator, bool _approved) external;
517 
518     /**
519      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
520      *
521      * See {setApprovalForAll}
522      */
523     function isApprovedForAll(address owner, address operator) external view returns (bool);
524 
525     /**
526       * @dev Safely transfers `tokenId` token from `from` to `to`.
527       *
528       * Requirements:
529       *
530       * - `from` cannot be the zero address.
531       * - `to` cannot be the zero address.
532       * - `tokenId` token must exist and be owned by `from`.
533       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
534       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
535       *
536       * Emits a {Transfer} event.
537       */
538     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
539 }
540 
541 
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
551  * @dev See https://eips.ethereum.org/EIPS/eip-721
552  */
553 interface IERC721Metadata is IERC721 {
554     /**
555      * @dev Returns the token collection name.
556      */
557     function name() external view returns (string memory);
558 
559     /**
560      * @dev Returns the token collection symbol.
561      */
562     function symbol() external view returns (string memory);
563 
564     /**
565      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
566      */
567     function tokenURI(uint256 tokenId) external view returns (string memory);
568 
569     
570 }
571 
572 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 /**
577  * @title ERC721 token receiver interface
578  * @dev Interface for any contract that wants to support safeTransfers
579  * from ERC721 asset contracts.
580  */
581 interface IERC721Receiver {
582     /**
583      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
584      * by `operator` from `from`, this function is called.
585      *
586      * It must return its Solidity selector to confirm the token transfer.
587      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
588      *
589      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
590      */
591     function onERC721Received(
592         address operator,
593         address from,
594         uint256 tokenId,
595         bytes calldata data
596     ) external returns (bytes4);
597 }
598 
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev String operations.
607  */
608 library Strings {
609     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
610 
611     /**
612      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
613      */
614     function toString(uint256 value) internal pure returns (string memory) {
615         // Inspired by OraclizeAPI's implementation - MIT licence
616         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
617 
618         if (value == 0) {
619             return "0";
620         }
621         uint256 temp = value;
622         uint256 digits;
623         while (temp != 0) {
624             digits++;
625             temp /= 10;
626         }
627         bytes memory buffer = new bytes(digits);
628         while (value != 0) {
629             digits -= 1;
630             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
631             value /= 10;
632         }
633         return string(buffer);
634     }
635 
636     /**
637      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
638      */
639     function toHexString(uint256 value) internal pure returns (string memory) {
640         if (value == 0) {
641             return "0x00";
642         }
643         uint256 temp = value;
644         uint256 length = 0;
645         while (temp != 0) {
646             length++;
647             temp >>= 8;
648         }
649         return toHexString(value, length);
650     }
651 
652     /**
653      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
654      */
655     function toHexString(uint256 value, uint256 length)
656         internal
657         pure
658         returns (string memory)
659     {
660         bytes memory buffer = new bytes(2 * length + 2);
661         buffer[0] = "0";
662         buffer[1] = "x";
663         for (uint256 i = 2 * length + 1; i > 1; --i) {
664             buffer[i] = _HEX_SYMBOLS[value & 0xf];
665             value >>= 4;
666         }
667         require(value == 0, "Strings: hex length insufficient");
668         return string(buffer);
669     }
670 }
671 
672 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
673 pragma solidity ^0.8.0;
674 /**
675  * @dev Implementation of the {IERC165} interface.
676  *
677  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
678  * for the additional interface id that will be supported. For example:
679  *
680  * ```solidity
681  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
682  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
683  * }
684  * ```
685  *
686  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
687  */
688 abstract contract ERC165 is IERC165 {
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693         return interfaceId == type(IERC165).interfaceId;
694     }
695 }
696 
697 
698 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 
704 /**
705  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
706  * the Metadata extension, but not including the Enumerable extension, which is available separately as
707  * {ERC721Enumerable}.
708  */
709 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
710     using Address for address;
711     using Strings for uint256;
712 
713     // Token name
714     string private _name;
715 
716 
717     // Token symbol
718     string private _symbol;
719 
720     // Mapping from token ID to owner address
721     mapping(uint256 => address) private _owners;
722 
723     // Mapping owner address to token count
724     mapping(address => uint256) private _balances;
725 
726     // Mapping from token ID to approved address
727     mapping(uint256 => address) private _tokenApprovals;
728 
729     // Mapping from owner to operator approvals
730     mapping(address => mapping(address => bool)) private _operatorApprovals;
731 
732 
733     /**
734      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
735      */
736     constructor(string memory name_, string memory symbol_) {
737         _name = name_;
738         _symbol = symbol_;
739     }
740 
741     /**
742      * @dev See {IERC165-supportsInterface}.
743      */
744     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
745         return
746             interfaceId == type(IERC721).interfaceId ||
747             interfaceId == type(IERC721Metadata).interfaceId ||
748             super.supportsInterface(interfaceId);
749     }
750 
751     /**
752      * @dev See {IERC721-balanceOf}.
753      */
754     function balanceOf(address owner) public view virtual override returns (uint256) {
755         require(owner != address(0), "ERC721: balance query for the zero address");
756         return _balances[owner];
757     }
758 
759     /**
760      * @dev See {IERC721-ownerOf}.
761      */
762     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
763         address owner = _owners[tokenId];
764         require(owner != address(0), "ERC721: owner query for nonexistent token");
765         return owner;
766     }
767 
768     /**
769      * @dev See {IERC721Metadata-name}.
770      */
771     function name() public view virtual override returns (string memory) {
772         return _name;
773     }
774 
775     /**
776      * @dev See {IERC721Metadata-symbol}.
777      */
778     function symbol() public view virtual override returns (string memory) {
779         return _symbol;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-tokenURI}.
784      */
785     function tokenURI(uint256 tokenId)
786         public
787         view
788         virtual
789         override
790         returns (string memory)
791     {
792         require(
793             _exists(tokenId),
794             "ERC721Metadata: URI query for nonexistent token"
795         );
796 
797         
798 
799         string memory baseURI = _baseURI();
800         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
801     }
802 
803     /**
804      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
805      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
806      * by default, can be overridden in child contracts.
807      */
808     function _baseURI() internal view virtual returns (string memory) {
809         return "";
810     }
811 
812     /**
813      * @dev See {IERC721-approve}.
814      */
815     function approve(address to, uint256 tokenId) public virtual override {
816         address owner = ERC721.ownerOf(tokenId);
817         require(to != owner, "ERC721: approval to current owner");
818 
819         require(
820             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
821             "ERC721: approve caller is not owner nor approved for all"
822         );
823 
824         _approve(to, tokenId);
825     }
826 
827     /**
828      * @dev See {IERC721-getApproved}.
829      */
830     function getApproved(uint256 tokenId) public view virtual override returns (address) {
831         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
832 
833         return _tokenApprovals[tokenId];
834     }
835 
836     /**
837      * @dev See {IERC721-setApprovalForAll}.
838      */
839     function setApprovalForAll(address operator, bool approved) public virtual override {
840         _setApprovalForAll(_msgSender(), operator, approved);
841     }
842 
843     /**
844      * @dev See {IERC721-isApprovedForAll}.
845      */
846     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
847         return _operatorApprovals[owner][operator];
848     }
849 
850     /**
851      * @dev See {IERC721-transferFrom}.
852      */
853     function transferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public virtual override {
858         //solhint-disable-next-line max-line-length
859         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
860 
861         _transfer(from, to, tokenId);
862     }
863 
864     /**
865      * @dev See {IERC721-safeTransferFrom}.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) public virtual override {
872         safeTransferFrom(from, to, tokenId, "");
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) public virtual override {
884         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
885         _safeTransfer(from, to, tokenId, _data);
886     }
887 
888     /**
889      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
890      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
891      *
892      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
893      *
894      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
895      * implement alternative mechanisms to perform token transfer, such as signature-based.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must exist and be owned by `from`.
902      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _safeTransfer(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) internal virtual {
912         _transfer(from, to, tokenId);
913         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
914     }
915 
916     /**
917      * @dev Returns whether `tokenId` exists.
918      *
919      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
920      *
921      * Tokens start existing when they are minted (`_mint`),
922      * and stop existing when they are burned (`_burn`).
923      */
924     function _exists(uint256 tokenId) internal view virtual returns (bool) {
925         return _owners[tokenId] != address(0);
926     }
927 
928     /**
929      * @dev Returns whether `spender` is allowed to manage `tokenId`.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must exist.
934      */
935     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
936         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
937         address owner = ERC721.ownerOf(tokenId);
938         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
939     }
940 
941     /**
942      * @dev Safely mints `tokenId` and transfers it to `to`.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must not exist.
947      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _safeMint(address to, uint256 tokenId) internal virtual {
952         _safeMint(to, tokenId, "");
953     }
954 
955     /**
956      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
957      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
958      */
959     function _safeMint(
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) internal virtual {
964         _mint(to, tokenId);
965         require(
966             _checkOnERC721Received(address(0), to, tokenId, _data),
967             "ERC721: transfer to non ERC721Receiver implementer"
968         );
969     }
970 
971     /**
972      * @dev Mints `tokenId` and transfers it to `to`.
973      *
974      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
975      *
976      * Requirements:
977      *
978      * - `tokenId` must not exist.
979      * - `to` cannot be the zero address.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _mint(address to, uint256 tokenId) internal virtual {
984         require(to != address(0), "ERC721: mint to the zero address");
985         require(!_exists(tokenId), "ERC721: token already minted");
986 
987         _beforeTokenTransfer(address(0), to, tokenId);
988 
989         _balances[to] += 1;
990         _owners[tokenId] = to;
991 
992         emit Transfer(address(0), to, tokenId);
993 
994         _afterTokenTransfer(address(0), to, tokenId);
995     }
996 
997     /**
998      * @dev Destroys `tokenId`.
999      * The approval is cleared when the token is burned.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _burn(uint256 tokenId) internal virtual {
1008         address owner = ERC721.ownerOf(tokenId);
1009 
1010         _beforeTokenTransfer(owner, address(0), tokenId);
1011 
1012         // Clear approvals
1013         _approve(address(0), tokenId);
1014 
1015         _balances[owner] -= 1;
1016         delete _owners[tokenId];
1017 
1018         emit Transfer(owner, address(0), tokenId);
1019 
1020         _afterTokenTransfer(owner, address(0), tokenId);
1021     }
1022 
1023     /**
1024      * @dev Transfers `tokenId` from `from` to `to`.
1025      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1026      *
1027      * Requirements:
1028      *
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must be owned by `from`.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function _transfer(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) internal virtual {
1039         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1040         require(to != address(0), "ERC721: transfer to the zero address");
1041 
1042         _beforeTokenTransfer(from, to, tokenId);
1043 
1044         // Clear approvals from the previous owner
1045         _approve(address(0), tokenId);
1046 
1047         _balances[from] -= 1;
1048         _balances[to] += 1;
1049         _owners[tokenId] = to;
1050 
1051         emit Transfer(from, to, tokenId);
1052 
1053         _afterTokenTransfer(from, to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Approve `to` to operate on `tokenId`
1058      *
1059      * Emits a {Approval} event.
1060      */
1061     function _approve(address to, uint256 tokenId) internal virtual {
1062         _tokenApprovals[tokenId] = to;
1063         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Approve `operator` to operate on all of `owner` tokens
1068      *
1069      * Emits a {ApprovalForAll} event.
1070      */
1071     function _setApprovalForAll(
1072         address owner,
1073         address operator,
1074         bool approved
1075     ) internal virtual {
1076         require(owner != operator, "ERC721: approve to caller");
1077         _operatorApprovals[owner][operator] = approved;
1078         emit ApprovalForAll(owner, operator, approved);
1079     }
1080 
1081     /**
1082      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1083      * The call is not executed if the target address is not a contract.
1084      *
1085      * @param from address representing the previous owner of the given token ID
1086      * @param to target address that will receive the tokens
1087      * @param tokenId uint256 ID of the token to be transferred
1088      * @param _data bytes optional data to send along with the call
1089      * @return bool whether the call correctly returned the expected magic value
1090      */
1091     function _checkOnERC721Received(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) private returns (bool) {
1097         if (to.isContract()) {
1098             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1099                 return retval == IERC721Receiver.onERC721Received.selector;
1100             } catch (bytes memory reason) {
1101                 if (reason.length == 0) {
1102                     revert("ERC721: transfer to non ERC721Receiver implementer");
1103                 } else {
1104                     assembly {
1105                         revert(add(32, reason), mload(reason))
1106                     }
1107                 }
1108             }
1109         } else {
1110             return true;
1111         }
1112     }
1113 
1114     /**
1115      * @dev Hook that is called before any token transfer. This includes minting
1116      * and burning.
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` will be minted for `to`.
1123      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1124      * - `from` and `to` are never both zero.
1125      *
1126      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1127      */
1128     function _beforeTokenTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) internal virtual {}
1133 
1134     /**
1135      * @dev Hook that is called after any transfer of tokens. This includes
1136      * minting and burning.
1137      *
1138      * Calling conditions:
1139      *
1140      * - when `from` and `to` are both non-zero.
1141      * - `from` and `to` are never both zero.
1142      *
1143      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1144      */
1145     function _afterTokenTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) internal virtual {}
1150 }
1151 
1152 pragma solidity ^0.8.0;
1153 
1154 
1155 
1156 error ApprovalCallerNotOwnerNorApproved();
1157 error ApprovalQueryForNonexistentToken();
1158 error ApproveToCaller();
1159 error ApprovalToCurrentOwner();
1160 error BalanceQueryForZeroAddress();
1161 error MintedQueryForZeroAddress();
1162 error BurnedQueryForZeroAddress();
1163 error MintToZeroAddress();
1164 error MintZeroQuantity();
1165 error OwnerIndexOutOfBounds();
1166 error OwnerQueryForNonexistentToken();
1167 error TokenIndexOutOfBounds();
1168 error TransferCallerNotOwnerNorApproved();
1169 error TransferFromIncorrectOwner();
1170 error TransferToNonERC721ReceiverImplementer();
1171 error TransferToZeroAddress();
1172 error URIQueryForNonexistentToken();
1173 
1174 /**
1175  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1176  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1177  *
1178  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1179  *
1180  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1181  *
1182  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1183  */
1184 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1185     using Address for address;
1186     using Strings for uint256;
1187 
1188     // Compiler will pack this into a single 256bit word.
1189     struct TokenOwnership {
1190         // The address of the owner.
1191         address addr;
1192         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1193         uint64 startTimestamp;
1194         // Whether the token has been burned.
1195         bool burned;
1196     }
1197 
1198     // Compiler will pack this into a single 256bit word.
1199     struct AddressData {
1200         // Realistically, 2**64-1 is more than enough.
1201         uint64 balance;
1202         // Keeps track of mint count with minimal overhead for tokenomics.
1203         uint64 numberMinted;
1204         // Keeps track of burn count with minimal overhead for tokenomics.
1205         uint64 numberBurned;
1206     }
1207 
1208     // The tokenId of the next token to be minted.
1209     uint256 internal _currentIndex;
1210 
1211     // The number of tokens burned.
1212     uint256 internal _burnCounter;
1213 
1214     // Token name
1215     string private _name;
1216 
1217     
1218     
1219     string public uriSuffix = ".json";
1220 
1221     // Token symbol
1222     string private _symbol;
1223 
1224     // Mapping from token ID to ownership details
1225     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1226     mapping(uint256 => TokenOwnership) internal _ownerships;
1227 
1228     // Mapping owner address to address data
1229     mapping(address => AddressData) private _addressData;
1230 
1231     // Mapping from token ID to approved address
1232     mapping(uint256 => address) private _tokenApprovals;
1233 
1234     // Mapping from owner to operator approvals
1235     mapping(address => mapping(address => bool)) private _operatorApprovals;
1236 
1237 
1238 
1239     constructor(string memory name_, string memory symbol_) {
1240         _name = name_;
1241         _symbol = symbol_;
1242     }
1243 
1244    
1245 
1246     /**
1247      * @dev See {IERC165-supportsInterface}.
1248      */
1249     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1250         return
1251             interfaceId == type(IERC721).interfaceId ||
1252             interfaceId == type(IERC721Metadata).interfaceId ||
1253             super.supportsInterface(interfaceId);
1254     }
1255 
1256     /**
1257      * @dev See {IERC721-balanceOf}.
1258      */
1259     function balanceOf(address owner) public view override returns (uint256) {
1260         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1261         return uint256(_addressData[owner].balance);
1262     }
1263 
1264     function _numberMinted(address owner) internal view returns (uint256) {
1265         if (owner == address(0)) revert MintedQueryForZeroAddress();
1266         return uint256(_addressData[owner].numberMinted);
1267     }
1268 
1269     function _numberBurned(address owner) internal view returns (uint256) {
1270         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1271         return uint256(_addressData[owner].numberBurned);
1272     }
1273 
1274     /**
1275      * Gas spent here starts off proportional to the maximum mint batch size.
1276      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1277      */
1278     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1279         uint256 curr = tokenId;
1280 
1281         unchecked {
1282             if (curr < _currentIndex) {
1283                 TokenOwnership memory ownership = _ownerships[curr];
1284                 if (!ownership.burned) {
1285                     if (ownership.addr != address(0)) {
1286                         return ownership;
1287                     }
1288                     // Invariant: 
1289                     // There will always be an ownership that has an address and is not burned 
1290                     // before an ownership that does not have an address and is not burned.
1291                     // Hence, curr will not underflow.
1292                     while (true) {
1293                         curr--;
1294                         ownership = _ownerships[curr];
1295                         if (ownership.addr != address(0)) {
1296                             return ownership;
1297                         }
1298                     }
1299                 }
1300             }
1301         }
1302         revert OwnerQueryForNonexistentToken();
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-ownerOf}.
1307      */
1308     function ownerOf(uint256 tokenId) public view override returns (address) {
1309         return ownershipOf(tokenId).addr;
1310     }
1311 
1312     /**
1313      * @dev See {IERC721Metadata-name}.
1314      */
1315     function name() public view virtual override returns (string memory) {
1316         return _name;
1317     }
1318 
1319     /**
1320      * @dev See {IERC721Metadata-symbol}.
1321      */
1322     function symbol() public view virtual override returns (string memory) {
1323         return _symbol;
1324     }
1325 
1326     /**
1327      * @dev See {IERC721Metadata-tokenURI}.
1328      */
1329     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1330         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1331         
1332       
1333 
1334 
1335         string memory baseURI = _baseURI();
1336         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1337     }
1338 
1339     /**
1340      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1341      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1342      * by default, can be overriden in child contracts.
1343      */
1344     function _baseURI() internal view virtual returns (string memory) {
1345         return '';
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-approve}.
1350      */
1351     function approve(address to, uint256 tokenId) public override {
1352         address owner = ERC721A.ownerOf(tokenId);
1353         if (to == owner) revert ApprovalToCurrentOwner();
1354 
1355         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1356             revert ApprovalCallerNotOwnerNorApproved();
1357         }
1358 
1359         _approve(to, tokenId, owner);
1360     }
1361 
1362     /**
1363      * @dev See {IERC721-getApproved}.
1364      */
1365     function getApproved(uint256 tokenId) public view override returns (address) {
1366         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1367 
1368         return _tokenApprovals[tokenId];
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-setApprovalForAll}.
1373      */
1374     function setApprovalForAll(address operator, bool approved) public override {
1375         if (operator == _msgSender()) revert ApproveToCaller();
1376 
1377         _operatorApprovals[_msgSender()][operator] = approved;
1378         emit ApprovalForAll(_msgSender(), operator, approved);
1379     }
1380 
1381     /**
1382      * @dev See {IERC721-isApprovedForAll}.
1383      */
1384     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1385         return _operatorApprovals[owner][operator];
1386     }
1387 
1388     /**
1389      * @dev See {IERC721-transferFrom}.
1390      */
1391     function transferFrom(
1392         address from,
1393         address to,
1394         uint256 tokenId
1395     ) public virtual override {
1396         _transfer(from, to, tokenId);
1397     }
1398 
1399     /**
1400      * @dev See {IERC721-safeTransferFrom}.
1401      */
1402     function safeTransferFrom(
1403         address from,
1404         address to,
1405         uint256 tokenId
1406     ) public virtual override {
1407         safeTransferFrom(from, to, tokenId, '');
1408     }
1409 
1410     /**
1411      * @dev See {IERC721-safeTransferFrom}.
1412      */
1413     function safeTransferFrom(
1414         address from,
1415         address to,
1416         uint256 tokenId,
1417         bytes memory _data
1418     ) public virtual override {
1419         _transfer(from, to, tokenId);
1420         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1421             revert TransferToNonERC721ReceiverImplementer();
1422         }
1423     }
1424 
1425     /**
1426      * @dev Returns whether `tokenId` exists.
1427      *
1428      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1429      *
1430      * Tokens start existing when they are minted (`_mint`),
1431      */
1432     function _exists(uint256 tokenId) internal view returns (bool) {
1433         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1434     }
1435 
1436     function _safeMint(address to, uint256 quantity) internal {
1437         _safeMint(to, quantity, '');
1438     }
1439 
1440     /**
1441      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1442      *
1443      * Requirements:
1444      *
1445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1446      * - `quantity` must be greater than 0.
1447      *
1448      * Emits a {Transfer} event.
1449      */
1450     function _safeMint(
1451         address to,
1452         uint256 quantity,
1453         bytes memory _data
1454     ) internal {
1455         _mint(to, quantity, _data, true);
1456     }
1457 
1458     /**
1459      * @dev Mints `quantity` tokens and transfers them to `to`.
1460      *
1461      * Requirements:
1462      *
1463      * - `to` cannot be the zero address.
1464      * - `quantity` must be greater than 0.
1465      *
1466      * Emits a {Transfer} event.
1467      */
1468     function _mint(
1469         address to,
1470         uint256 quantity,
1471         bytes memory _data,
1472         bool safe
1473     ) internal {
1474         uint256 startTokenId = _currentIndex;
1475         if (to == address(0)) revert MintToZeroAddress();
1476         if (quantity == 0) revert MintZeroQuantity();
1477 
1478         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1479 
1480         // Overflows are incredibly unrealistic.
1481         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1482         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1483         unchecked {
1484             _addressData[to].balance += uint64(quantity);
1485             _addressData[to].numberMinted += uint64(quantity);
1486 
1487             _ownerships[startTokenId].addr = to;
1488             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1489 
1490             uint256 updatedIndex = startTokenId;
1491 
1492             for (uint256 i; i < quantity; i++) {
1493                 emit Transfer(address(0), to, updatedIndex);
1494                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1495                     revert TransferToNonERC721ReceiverImplementer();
1496                 }
1497                 updatedIndex++;
1498             }
1499 
1500             _currentIndex = updatedIndex;
1501         }
1502         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1503     }
1504 
1505     /**
1506      * @dev Transfers `tokenId` from `from` to `to`.
1507      *
1508      * Requirements:
1509      *
1510      * - `to` cannot be the zero address.
1511      * - `tokenId` token must be owned by `from`.
1512      *
1513      * Emits a {Transfer} event.
1514      */
1515     function _transfer(
1516         address from,
1517         address to,
1518         uint256 tokenId
1519     ) private {
1520         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1521 
1522         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1523             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1524             getApproved(tokenId) == _msgSender());
1525 
1526         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1527         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1528         if (to == address(0)) revert TransferToZeroAddress();
1529 
1530         _beforeTokenTransfers(from, to, tokenId, 1);
1531 
1532         // Clear approvals from the previous owner
1533         _approve(address(0), tokenId, prevOwnership.addr);
1534 
1535         // Underflow of the sender's balance is impossible because we check for
1536         // ownership above and the recipient's balance can't realistically overflow.
1537         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1538         unchecked {
1539             _addressData[from].balance -= 1;
1540             _addressData[to].balance += 1;
1541 
1542             _ownerships[tokenId].addr = to;
1543             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1544 
1545             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1546             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1547             uint256 nextTokenId = tokenId + 1;
1548             if (_ownerships[nextTokenId].addr == address(0)) {
1549                 // This will suffice for checking _exists(nextTokenId),
1550                 // as a burned slot cannot contain the zero address.
1551                 if (nextTokenId < _currentIndex) {
1552                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1553                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1554                 }
1555             }
1556         }
1557 
1558         emit Transfer(from, to, tokenId);
1559         _afterTokenTransfers(from, to, tokenId, 1);
1560     }
1561 
1562     /**
1563      * @dev Destroys `tokenId`.
1564      * The approval is cleared when the token is burned.
1565      *
1566      * Requirements:
1567      *
1568      * - `tokenId` must exist.
1569      *
1570      * Emits a {Transfer} event.
1571      */
1572     function _burn(uint256 tokenId) internal virtual {
1573         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1574 
1575         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1576 
1577         // Clear approvals from the previous owner
1578         _approve(address(0), tokenId, prevOwnership.addr);
1579 
1580         // Underflow of the sender's balance is impossible because we check for
1581         // ownership above and the recipient's balance can't realistically overflow.
1582         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1583         unchecked {
1584             _addressData[prevOwnership.addr].balance -= 1;
1585             _addressData[prevOwnership.addr].numberBurned += 1;
1586 
1587             // Keep track of who burned the token, and the timestamp of burning.
1588             _ownerships[tokenId].addr = prevOwnership.addr;
1589             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1590             _ownerships[tokenId].burned = true;
1591 
1592             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1593             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1594             uint256 nextTokenId = tokenId + 1;
1595             if (_ownerships[nextTokenId].addr == address(0)) {
1596                 // This will suffice for checking _exists(nextTokenId),
1597                 // as a burned slot cannot contain the zero address.
1598                 if (nextTokenId < _currentIndex) {
1599                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1600                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1601                 }
1602             }
1603         }
1604 
1605         emit Transfer(prevOwnership.addr, address(0), tokenId);
1606         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1607 
1608         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1609         unchecked { 
1610             _burnCounter++;
1611         }
1612     }
1613 
1614     /**
1615      * @dev Approve `to` to operate on `tokenId`
1616      *
1617      * Emits a {Approval} event.
1618      */
1619     function _approve(
1620         address to,
1621         uint256 tokenId,
1622         address owner
1623     ) private {
1624         _tokenApprovals[tokenId] = to;
1625         emit Approval(owner, to, tokenId);
1626     }
1627 
1628     /**
1629      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1630      * The call is not executed if the target address is not a contract.
1631      *
1632      * @param from address representing the previous owner of the given token ID
1633      * @param to target address that will receive the tokens
1634      * @param tokenId uint256 ID of the token to be transferred
1635      * @param _data bytes optional data to send along with the call
1636      * @return bool whether the call correctly returned the expected magic value
1637      */
1638     function _checkOnERC721Received(
1639         address from,
1640         address to,
1641         uint256 tokenId,
1642         bytes memory _data
1643     ) private returns (bool) {
1644         if (to.isContract()) {
1645             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1646                 return retval == IERC721Receiver(to).onERC721Received.selector;
1647             } catch (bytes memory reason) {
1648                 if (reason.length == 0) {
1649                     revert TransferToNonERC721ReceiverImplementer();
1650                 } else {
1651                     assembly {
1652                         revert(add(32, reason), mload(reason))
1653                     }
1654                 }
1655             }
1656         } else {
1657             return true;
1658         }
1659     }
1660 
1661     /**
1662      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1663      * And also called before burning one token.
1664      *
1665      * startTokenId - the first token id to be transferred
1666      * quantity - the amount to be transferred
1667      *
1668      * Calling conditions:
1669      *
1670      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1671      * transferred to `to`.
1672      * - When `from` is zero, `tokenId` will be minted for `to`.
1673      * - When `to` is zero, `tokenId` will be burned by `from`.
1674      * - `from` and `to` are never both zero.
1675      */
1676     function _beforeTokenTransfers(
1677         address from,
1678         address to,
1679         uint256 startTokenId,
1680         uint256 quantity
1681     ) internal virtual {}
1682 
1683     /**
1684      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1685      * minting.
1686      * And also called after one token has been burned.
1687      *
1688      * startTokenId - the first token id to be transferred
1689      * quantity - the amount to be transferred
1690      *
1691      * Calling conditions:
1692      *
1693      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1694      * transferred to `to`.
1695      * - When `from` is zero, `tokenId` has been minted for `to`.
1696      * - When `to` is zero, `tokenId` has been burned by `from`.
1697      * - `from` and `to` are never both zero.
1698      */
1699     function _afterTokenTransfers(
1700         address from,
1701         address to,
1702         uint256 startTokenId,
1703         uint256 quantity
1704     ) internal virtual {}
1705 }
1706 
1707 
1708 
1709 // File: @openzeppelin/contracts/access/Ownable.sol
1710 pragma solidity ^0.8.0;
1711 
1712 /**
1713  * @dev Contract module which provides a basic access control mechanism, where
1714  * there is an account (an owner) that can be granted exclusive access to
1715  * specific functions.
1716  *
1717  * By default, the owner account will be the one that deploys the contract. This
1718  * can later be changed with {transferOwnership}.
1719  *
1720  * This module is used through inheritance. It will make available the modifier
1721  * `onlyOwner`, which can be applied to your functions to restrict their use to
1722  * the owner.
1723  */
1724 abstract contract Ownable is Context {
1725     address private _owner;
1726 
1727     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1728 
1729     /**
1730      * @dev Initializes the contract setting the deployer as the initial owner.
1731      */
1732     constructor () {
1733         address msgSender = _msgSender();
1734         _owner = msgSender;
1735         emit OwnershipTransferred(address(0), msgSender);
1736     }
1737 
1738     /**
1739      * @dev Returns the address of the current owner.
1740      */
1741     function owner() public view virtual returns (address) {
1742         return _owner;
1743     }
1744 
1745     /**
1746      * @dev Throws if called by any account other than the owner.
1747      */
1748     modifier onlyOwner() {
1749         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1750         _;
1751     }
1752 
1753     /**
1754      * @dev Leaves the contract without owner. It will not be possible to call
1755      * `onlyOwner` functions anymore. Can only be called by the current owner.
1756      *
1757      * NOTE: Renouncing ownership will leave the contract without an owner,
1758      * thereby removing any functionality that is only available to the owner.
1759      */
1760     function renounceOwnership() public virtual onlyOwner {
1761         emit OwnershipTransferred(_owner, address(0));
1762         _owner = address(0);
1763     }
1764 
1765     /**
1766      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1767      * Can only be called by the current owner.
1768      */
1769     function transferOwnership(address newOwner) public virtual onlyOwner {
1770         require(newOwner != address(0), "Ownable: new owner is the zero address");
1771         emit OwnershipTransferred(_owner, newOwner);
1772         _owner = newOwner;
1773     }
1774 }
1775 
1776 // File: contracts/NonblockingReceiver.sol
1777 
1778 
1779 pragma solidity ^0.8.6;
1780 
1781 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1782 
1783     ILayerZeroEndpoint internal endpoint;
1784 
1785     struct FailedMessages {
1786         uint payloadLength;
1787         bytes32 payloadHash;
1788     }
1789 
1790     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
1791     mapping(uint16 => bytes) public trustedRemoteLookup;
1792 
1793     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
1794 
1795     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
1796         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1797         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]), 
1798             "NonblockingReceiver: invalid source sending contract");
1799 
1800         // try-catch all errors/exceptions
1801         // having failed messages does not block messages passing
1802         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1803             // do nothing
1804         } catch {
1805             // error / exception
1806             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
1807             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1808         }
1809     }
1810 
1811     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
1812         // only internal transaction
1813         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
1814 
1815         // handle incoming message
1816         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
1817     }
1818 
1819     // abstract function
1820     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
1821 
1822     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
1823         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
1824     }
1825 
1826     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
1827         // assert there is message to retry
1828         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
1829         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
1830         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
1831         // clear the stored message
1832         failedMsg.payloadLength = 0;
1833         failedMsg.payloadHash = bytes32(0);
1834         // execute the message. revert if it fails again
1835         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1836     }
1837 
1838     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
1839         trustedRemoteLookup[_chainId] = _trustedRemote;
1840     }
1841 }
1842 
1843 pragma solidity ^0.8.7;
1844 
1845 contract OmniAmongPunks is Ownable, ERC721A, NonblockingReceiver {
1846 
1847     using Strings for uint256;
1848 
1849     address public _owner;
1850     
1851     uint256 nextTokenId = 0;
1852 
1853     uint256 MAX_NETWORK_MINT = 0;
1854 
1855     uint256 private price = 0;
1856     
1857     uint256 public freeMintAmount = 0;
1858 
1859     string public hiddenMetadataUri;
1860 
1861     string private baseURI;
1862       
1863     bool public saleOpen = true;
1864 
1865     bool public revealed = false;
1866 
1867     event Minted(uint256 totalMinted);
1868 
1869     uint gasForDestinationLzReceive = 350000;
1870 
1871     constructor(string memory hiddenMetadataUri_, string memory baseURI_, address _layerZeroEndpoint, uint256 _nextTokenId, uint256 _maxTokenId, uint256 _price, uint256 _freeMint) ERC721A("OmniAmongPunks", "AP") { 
1872         _owner = msg.sender;
1873         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1874         baseURI = baseURI_;
1875         hiddenMetadataUri = hiddenMetadataUri_;
1876         nextTokenId = _nextTokenId;
1877         MAX_NETWORK_MINT = _maxTokenId;
1878         price = _price;
1879         freeMintAmount = _freeMint;
1880     }
1881 
1882     // mint function
1883     function mint(address _to, uint256 numTokens) external payable {
1884 
1885         require(nextTokenId + numTokens <= MAX_NETWORK_MINT, "Exceeds maximum supply");
1886         require(numTokens > 0, "Minimum 1 NFT has to be minted per transaction");
1887 
1888         if (msg.sender != owner() && (nextTokenId + numTokens) > freeMintAmount) {
1889             require(saleOpen, "Sale is not open yet");
1890             require(
1891                 msg.value >= price * numTokens,
1892                 "Ether sent with this transaction is not correct"
1893             );
1894         }
1895 
1896         if(msg.sender != owner()) {
1897             require(
1898                 numTokens <= 5,
1899                 "Maximum 5 NFTs can be minted per transaction"
1900             );
1901         }
1902         
1903         nextTokenId += numTokens;      
1904         _safeMint(_to, numTokens);
1905         emit Minted(numTokens);      
1906     }
1907 
1908 
1909     // This function transfers the nft from your address on the 
1910     // source chain to the same address on the destination chain
1911     function traverseChains(uint16 _chainId, uint tokenId) public payable {
1912         require(msg.sender == ownerOf(tokenId), "You must own the token to traverse");
1913         require(trustedRemoteLookup[_chainId].length > 0, "This chain is currently unavailable for travel");
1914 
1915         // burn NFT, eliminating it from circulation on src chain
1916         _burn(tokenId);
1917 
1918         // abi.encode() the payload with the values to send
1919         bytes memory payload = abi.encode(msg.sender, tokenId);
1920 
1921         // encode adapterParams to specify more gas for the destination
1922         uint16 version = 1;
1923         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1924 
1925         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1926         // you will be refunded for extra gas paid
1927         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1928         
1929         require(msg.value >= messageFee, "GG: msg.value not enough to cover messageFee. Send gas for message fees");
1930 
1931         endpoint.send{value: msg.value}(
1932             _chainId,                           // destination chainId
1933             trustedRemoteLookup[_chainId],      // destination address of nft contract
1934             payload,                            // abi.encoded()'ed bytes
1935             payable(msg.sender),                // refund address
1936             address(0x0),                       // 'zroPaymentAddress' unused for this
1937             adapterParams                       // txParameters 
1938         );
1939     }  
1940 
1941     function setBaseURI(string memory URI) external onlyOwner {
1942         baseURI = URI;
1943     }
1944 
1945     function setRevealed(bool _state) public onlyOwner {
1946     revealed = _state;
1947   }
1948 
1949     function donate() external payable {
1950         // thank you
1951     }
1952 
1953     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1954         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1955         
1956        if (revealed == false) {
1957          return hiddenMetadataUri;
1958          }
1959 
1960 
1961         string memory baseURI = _baseURI();
1962         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1963     }
1964 
1965     // This allows the devs to receive kind donations
1966     function withdraw(uint amt) external onlyOwner {
1967         (bool sent, ) = payable(_owner).call{value: amt}("");
1968         require(sent, "GG: Failed to withdraw Ether");
1969     }
1970 
1971     // just in case this fixed variable limits us from future integrations
1972     function setGasForDestinationLzReceive(uint newVal) external onlyOwner {
1973         gasForDestinationLzReceive = newVal;
1974     }
1975 
1976     // ------------------
1977     // Internal Functions
1978     // ------------------
1979 
1980     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) override internal {
1981         // decode
1982         (address toAddr, uint tokenId) = abi.decode(_payload, (address, uint));
1983 
1984          //mint the tokens back into existence on destination chain
1985         _safeMint(toAddr, tokenId);
1986     }  
1987 
1988     function _baseURI() override internal view returns (string memory) {
1989         return baseURI;
1990     }
1991 }