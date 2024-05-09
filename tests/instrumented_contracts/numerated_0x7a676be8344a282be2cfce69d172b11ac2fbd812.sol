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
28 
29 // File: contracts/interfaces/ILayerZeroEndpoint.sol
30 
31 
32 
33 pragma solidity >=0.5.0;
34 
35 
36 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
37     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
38     // @param _dstChainId - the destination chain identifier
39     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
40     // @param _payload - a custom bytes payload to send to the destination contract
41     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
42     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
43     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
44     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
45 
46     // @notice used by the messaging library to publish verified payload
47     // @param _srcChainId - the source chain identifier
48     // @param _srcAddress - the source contract (as bytes) at the source chain
49     // @param _dstAddress - the address on destination chain
50     // @param _nonce - the unbound message ordering nonce
51     // @param _gasLimit - the gas limit for external contract execution
52     // @param _payload - verified payload to send to the destination contract
53     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
54 
55     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
56     // @param _srcChainId - the source chain identifier
57     // @param _srcAddress - the source chain contract address
58     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
59 
60     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
61     // @param _srcAddress - the source chain contract address
62     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
63 
64     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
65     // @param _dstChainId - the destination chain identifier
66     // @param _userApplication - the user app address on this EVM chain
67     // @param _payload - the custom message to send over LayerZero
68     // @param _payInZRO - if false, user app pays the protocol fee in native token
69     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
70     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
71 
72     // @notice get this Endpoint's immutable source identifier
73     function getChainId() external view returns (uint16);
74 
75     // @notice the interface to retry failed message on this Endpoint destination
76     // @param _srcChainId - the source chain identifier
77     // @param _srcAddress - the source chain contract address
78     // @param _payload - the payload to be retried
79     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
80 
81     // @notice query if any STORED payload (message blocking) at the endpoint.
82     // @param _srcChainId - the source chain identifier
83     // @param _srcAddress - the source chain contract address
84     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
85 
86     // @notice query if the _libraryAddress is valid for sending msgs.
87     // @param _userApplication - the user app address on this EVM chain
88     function getSendLibraryAddress(address _userApplication) external view returns (address);
89 
90     // @notice query if the _libraryAddress is valid for receiving msgs.
91     // @param _userApplication - the user app address on this EVM chain
92     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
93 
94     // @notice query if the non-reentrancy guard for send() is on
95     // @return true if the guard is on. false otherwise
96     function isSendingPayload() external view returns (bool);
97 
98     // @notice query if the non-reentrancy guard for receive() is on
99     // @return true if the guard is on. false otherwise
100     function isReceivingPayload() external view returns (bool);
101 
102     // @notice get the configuration of the LayerZero messaging library of the specified version
103     // @param _version - messaging library version
104     // @param _chainId - the chainId for the pending config change
105     // @param _userApplication - the contract address of the user application
106     // @param _configType - type of configuration. every messaging library has its own convention.
107     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
108 
109     // @notice get the send() LayerZero messaging library version
110     // @param _userApplication - the contract address of the user application
111     function getSendVersion(address _userApplication) external view returns (uint16);
112 
113     // @notice get the lzReceive() LayerZero messaging library version
114     // @param _userApplication - the contract address of the user application
115     function getReceiveVersion(address _userApplication) external view returns (uint16);
116 }
117 
118 // File: contracts/interfaces/ILayerZeroReceiver.sol
119 
120 
121 
122 pragma solidity >=0.5.0;
123 
124 interface ILayerZeroReceiver {
125     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
126     // @param _srcChainId - the source endpoint identifier
127     // @param _srcAddress - the source sending contract address from the source chain
128     // @param _nonce - the ordered message nonce
129     // @param _payload - the signed payload is the UA bytes has encoded to be sent
130     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
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
307 // File: @openzeppelin/contracts/utils/Address.sol
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Collection of functions related to the address type
316  */
317 library Address {
318     /**
319      * @dev Returns true if `account` is a contract.
320      *
321      * [IMPORTANT]
322      * ====
323      * It is unsafe to assume that an address for which this function returns
324      * false is an externally-owned account (EOA) and not a contract.
325      *
326      * Among others, `isContract` will return false for the following
327      * types of addresses:
328      *
329      *  - an externally-owned account
330      *  - a contract in construction
331      *  - an address where a contract will be created
332      *  - an address where a contract lived, but was destroyed
333      * ====
334      */
335     function isContract(address account) internal view returns (bool) {
336         // This method relies on extcodesize, which returns 0 for contracts in
337         // construction, since the code is only stored at the end of the
338         // constructor execution.
339 
340         uint256 size;
341         assembly {
342             size := extcodesize(account)
343         }
344         return size > 0;
345     }
346 
347     /**
348      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
349      * `recipient`, forwarding all available gas and reverting on errors.
350      *
351      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
352      * of certain opcodes, possibly making contracts go over the 2300 gas limit
353      * imposed by `transfer`, making them unable to receive funds via
354      * `transfer`. {sendValue} removes this limitation.
355      *
356      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
357      *
358      * IMPORTANT: because control is transferred to `recipient`, care must be
359      * taken to not create reentrancy vulnerabilities. Consider using
360      * {ReentrancyGuard} or the
361      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
362      */
363     function sendValue(address payable recipient, uint256 amount) internal {
364         require(address(this).balance >= amount, "Address: insufficient balance");
365 
366         (bool success, ) = recipient.call{value: amount}("");
367         require(success, "Address: unable to send value, recipient may have reverted");
368     }
369 
370     /**
371      * @dev Performs a Solidity function call using a low level `call`. A
372      * plain `call` is an unsafe replacement for a function call: use this
373      * function instead.
374      *
375      * If `target` reverts with a revert reason, it is bubbled up by this
376      * function (like regular Solidity function calls).
377      *
378      * Returns the raw returned data. To convert to the expected return value,
379      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
380      *
381      * Requirements:
382      *
383      * - `target` must be a contract.
384      * - calling `target` with `data` must not revert.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
389         return functionCall(target, data, "Address: low-level call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
394      * `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, 0, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but also transferring `value` wei to `target`.
409      *
410      * Requirements:
411      *
412      * - the calling contract must have an ETH balance of at least `value`.
413      * - the called Solidity function must be `payable`.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value
421     ) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
427      * with `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 value,
435         string memory errorMessage
436     ) internal returns (bytes memory) {
437         require(address(this).balance >= value, "Address: insufficient balance for call");
438         require(isContract(target), "Address: call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.call{value: value}(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a static call.
447      *
448      * _Available since v3.3._
449      */
450     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
451         return functionStaticCall(target, data, "Address: low-level static call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a static call.
457      *
458      * _Available since v3.3._
459      */
460     function functionStaticCall(
461         address target,
462         bytes memory data,
463         string memory errorMessage
464     ) internal view returns (bytes memory) {
465         require(isContract(target), "Address: static call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.staticcall(data);
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
478         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a delegate call.
484      *
485      * _Available since v3.4._
486      */
487     function functionDelegateCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         require(isContract(target), "Address: delegate call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.delegatecall(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
500      * revert reason using the provided one.
501      *
502      * _Available since v4.3._
503      */
504     function verifyCallResult(
505         bool success,
506         bytes memory returndata,
507         string memory errorMessage
508     ) internal pure returns (bytes memory) {
509         if (success) {
510             return returndata;
511         } else {
512             // Look for revert reason and bubble it up if present
513             if (returndata.length > 0) {
514                 // The easiest way to bubble the revert reason is using memory via assembly
515 
516                 assembly {
517                     let returndata_size := mload(returndata)
518                     revert(add(32, returndata), returndata_size)
519                 }
520             } else {
521                 revert(errorMessage);
522             }
523         }
524     }
525 }
526 
527 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @title ERC721 token receiver interface
536  * @dev Interface for any contract that wants to support safeTransfers
537  * from ERC721 asset contracts.
538  */
539 interface IERC721Receiver {
540     /**
541      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
542      * by `operator` from `from`, this function is called.
543      *
544      * It must return its Solidity selector to confirm the token transfer.
545      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
546      *
547      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
548      */
549     function onERC721Received(
550         address operator,
551         address from,
552         uint256 tokenId,
553         bytes calldata data
554     ) external returns (bytes4);
555 }
556 
557 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @dev Interface of the ERC165 standard, as defined in the
566  * https://eips.ethereum.org/EIPS/eip-165[EIP].
567  *
568  * Implementers can declare support of contract interfaces, which can then be
569  * queried by others ({ERC165Checker}).
570  *
571  * For an implementation, see {ERC165}.
572  */
573 interface IERC165 {
574     /**
575      * @dev Returns true if this contract implements the interface defined by
576      * `interfaceId`. See the corresponding
577      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
578      * to learn more about how these ids are created.
579      *
580      * This function call must use less than 30 000 gas.
581      */
582     function supportsInterface(bytes4 interfaceId) external view returns (bool);
583 }
584 
585 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 
593 /**
594  * @dev Implementation of the {IERC165} interface.
595  *
596  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
597  * for the additional interface id that will be supported. For example:
598  *
599  * ```solidity
600  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
601  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
602  * }
603  * ```
604  *
605  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
606  */
607 abstract contract ERC165 is IERC165 {
608     /**
609      * @dev See {IERC165-supportsInterface}.
610      */
611     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
612         return interfaceId == type(IERC165).interfaceId;
613     }
614 }
615 
616 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 
624 /**
625  * @dev Required interface of an ERC721 compliant contract.
626  */
627 interface IERC721 is IERC165 {
628     /**
629      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
630      */
631     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
632 
633     /**
634      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
635      */
636     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
637 
638     /**
639      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
640      */
641     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
642 
643     /**
644      * @dev Returns the number of tokens in ``owner``'s account.
645      */
646     function balanceOf(address owner) external view returns (uint256 balance);
647 
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
887         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), '.json')) : "";
888     }
889 
890 
891 
892     /**
893      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
894      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
895      * by default, can be overriden in child contracts.
896      */
897     function _baseURI() internal view virtual returns (string memory) {
898         return "";
899     }
900 
901     /**
902      * @dev See {IERC721-approve}.
903      */
904     function approve(address to, uint256 tokenId) public virtual override {
905         address owner = ERC721.ownerOf(tokenId);
906         require(to != owner, "ERC721: approval to current owner");
907 
908         require(
909             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
910             "ERC721: approve caller is not owner nor approved for all"
911         );
912 
913         _approve(to, tokenId);
914     }
915 
916     /**
917      * @dev See {IERC721-getApproved}.
918      */
919     function getApproved(uint256 tokenId) public view virtual override returns (address) {
920         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
921 
922         return _tokenApprovals[tokenId];
923     }
924 
925     /**
926      * @dev See {IERC721-setApprovalForAll}.
927      */
928     function setApprovalForAll(address operator, bool approved) public virtual override {
929         _setApprovalForAll(_msgSender(), operator, approved);
930     }
931 
932     /**
933      * @dev See {IERC721-isApprovedForAll}.
934      */
935     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
936         return _operatorApprovals[owner][operator];
937     }
938 
939     /**
940      * @dev See {IERC721-transferFrom}.
941      */
942     function transferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public virtual override {
947         //solhint-disable-next-line max-line-length
948         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
949 
950         _transfer(from, to, tokenId);
951     }
952 
953     /**
954      * @dev See {IERC721-safeTransferFrom}.
955      */
956     function safeTransferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) public virtual override {
961         safeTransferFrom(from, to, tokenId, "");
962     }
963 
964     /**
965      * @dev See {IERC721-safeTransferFrom}.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) public virtual override {
973         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
974         _safeTransfer(from, to, tokenId, _data);
975     }
976 
977     /**
978      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
979      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
980      *
981      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
982      *
983      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
984      * implement alternative mechanisms to perform token transfer, such as signature-based.
985      *
986      * Requirements:
987      *
988      * - `from` cannot be the zero address.
989      * - `to` cannot be the zero address.
990      * - `tokenId` token must exist and be owned by `from`.
991      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _safeTransfer(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) internal virtual {
1001         _transfer(from, to, tokenId);
1002         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1003     }
1004 
1005     /**
1006      * @dev Returns whether `tokenId` exists.
1007      *
1008      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1009      *
1010      * Tokens start existing when they are minted (`_mint`),
1011      * and stop existing when they are burned (`_burn`).
1012      */
1013     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1014         return _owners[tokenId] != address(0);
1015     }
1016 
1017     /**
1018      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must exist.
1023      */
1024     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1025         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1026         address owner = ERC721.ownerOf(tokenId);
1027         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1028     }
1029 
1030     /**
1031      * @dev Safely mints `tokenId` and transfers it to `to`.
1032      *
1033      * Requirements:
1034      *
1035      * - `tokenId` must not exist.
1036      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _safeMint(address to, uint256 tokenId) internal virtual {
1041         _safeMint(to, tokenId, "");
1042     }
1043 
1044     /**
1045      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1046      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1047      */
1048     function _safeMint(
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) internal virtual {
1053         _mint(to, tokenId);
1054         require(
1055             _checkOnERC721Received(address(0), to, tokenId, _data),
1056             "ERC721: transfer to non ERC721Receiver implementer"
1057         );
1058     }
1059 
1060     /**
1061      * @dev Mints `tokenId` and transfers it to `to`.
1062      *
1063      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must not exist.
1068      * - `to` cannot be the zero address.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _mint(address to, uint256 tokenId) internal virtual {
1073         require(to != address(0), "ERC721: mint to the zero address");
1074 
1075         _beforeTokenTransfer(address(0), to, tokenId);
1076 
1077         _balances[to] += 1;
1078         _owners[tokenId] = to;
1079 
1080         emit Transfer(address(0), to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Destroys `tokenId`.
1085      * The approval is cleared when the token is burned.
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must exist.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _burn(uint256 tokenId) internal virtual {
1094         address owner = ERC721.ownerOf(tokenId);
1095 
1096         _beforeTokenTransfer(owner, address(0), tokenId);
1097 
1098         // Clear approvals
1099         _approve(address(0), tokenId);
1100 
1101         _balances[owner] -= 1;
1102         delete _owners[tokenId];
1103 
1104         emit Transfer(owner, address(0), tokenId);
1105     }
1106 
1107     /**
1108      * @dev Transfers `tokenId` from `from` to `to`.
1109      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - `tokenId` token must be owned by `from`.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _transfer(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) internal virtual {
1123         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1124         require(to != address(0), "ERC721: transfer to the zero address");
1125 
1126         _beforeTokenTransfer(from, to, tokenId);
1127 
1128         // Clear approvals from the previous owner
1129         _approve(address(0), tokenId);
1130 
1131         _balances[from] -= 1;
1132         _balances[to] += 1;
1133         _owners[tokenId] = to;
1134 
1135         emit Transfer(from, to, tokenId);
1136     }
1137 
1138     /**
1139      * @dev Approve `to` to operate on `tokenId`
1140      *
1141      * Emits a {Approval} event.
1142      */
1143     function _approve(address to, uint256 tokenId) internal virtual {
1144         _tokenApprovals[tokenId] = to;
1145         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Approve `operator` to operate on all of `owner` tokens
1150      *
1151      * Emits a {ApprovalForAll} event.
1152      */
1153     function _setApprovalForAll(
1154         address owner,
1155         address operator,
1156         bool approved
1157     ) internal virtual {
1158         require(owner != operator, "ERC721: approve to caller");
1159         _operatorApprovals[owner][operator] = approved;
1160         emit ApprovalForAll(owner, operator, approved);
1161     }
1162 
1163     /**
1164      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1165      * The call is not executed if the target address is not a contract.
1166      *
1167      * @param from address representing the previous owner of the given token ID
1168      * @param to target address that will receive the tokens
1169      * @param tokenId uint256 ID of the token to be transferred
1170      * @param _data bytes optional data to send along with the call
1171      * @return bool whether the call correctly returned the expected magic value
1172      */
1173     function _checkOnERC721Received(
1174         address from,
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) private returns (bool) {
1179         if (to.isContract()) {
1180             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1181                 return retval == IERC721Receiver.onERC721Received.selector;
1182             } catch (bytes memory reason) {
1183                 if (reason.length == 0) {
1184                     revert("ERC721: transfer to non ERC721Receiver implementer");
1185                 } else {
1186                     assembly {
1187                         revert(add(32, reason), mload(reason))
1188                     }
1189                 }
1190             }
1191         } else {
1192             return true;
1193         }
1194     }
1195 
1196     /**
1197      * @dev Hook that is called before any token transfer. This includes minting
1198      * and burning.
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` will be minted for `to`.
1205      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1206      * - `from` and `to` are never both zero.
1207      *
1208      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1209      */
1210     function _beforeTokenTransfer(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) internal virtual {}
1215 }
1216 
1217 // File: contracts/NonblockingReceiver.sol
1218 
1219 
1220 pragma solidity ^0.8.6;
1221 
1222 
1223 
1224 
1225 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1226 
1227     ILayerZeroEndpoint internal endpoint;
1228 
1229     struct FailedMessages {
1230         uint payloadLength;
1231         bytes32 payloadHash;
1232     }
1233 
1234     mapping(uint16 => mapping(bytes => mapping(uint => FailedMessages))) public failedMessages;
1235     mapping(uint16 => bytes) public trustedRemoteLookup;
1236 
1237     event MessageFailed(uint16 _srcChainId, bytes _srcAddress, uint64 _nonce, bytes _payload);
1238 
1239     function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) external override {
1240         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1241         require(_srcAddress.length == trustedRemoteLookup[_srcChainId].length && keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]), 
1242             "NonblockingReceiver: invalid source sending contract");
1243 
1244         // try-catch all errors/exceptions
1245         // having failed messages does not block messages passing
1246         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1247             // do nothing
1248         } catch {
1249             // error / exception
1250             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(_payload.length, keccak256(_payload));
1251             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1252         }
1253     }
1254 
1255     function onLzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) public {
1256         // only internal transaction
1257         require(msg.sender == address(this), "NonblockingReceiver: caller must be Bridge.");
1258 
1259         // handle incoming message
1260         _LzReceive( _srcChainId, _srcAddress, _nonce, _payload);
1261     }
1262 
1263     // abstract function
1264     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) virtual internal;
1265 
1266     function _lzSend(uint16 _dstChainId, bytes memory _payload, address payable _refundAddress, address _zroPaymentAddress, bytes memory _txParam) internal {
1267         endpoint.send{value: msg.value}(_dstChainId, trustedRemoteLookup[_dstChainId], _payload, _refundAddress, _zroPaymentAddress, _txParam);
1268     }
1269 
1270     function retryMessage(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes calldata _payload) external payable {
1271         // assert there is message to retry
1272         FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][_nonce];
1273         require(failedMsg.payloadHash != bytes32(0), "NonblockingReceiver: no stored message");
1274         require(_payload.length == failedMsg.payloadLength && keccak256(_payload) == failedMsg.payloadHash, "LayerZero: invalid payload");
1275         // clear the stored message
1276         failedMsg.payloadLength = 0;
1277         failedMsg.payloadHash = bytes32(0);
1278         // execute the message. revert if it fails again
1279         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1280     }
1281 
1282     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote) external onlyOwner {
1283         trustedRemoteLookup[_chainId] = _trustedRemote;
1284     }
1285 }
1286 
1287 // File: contracts/BETA.sol
1288 
1289 
1290 
1291 pragma solidity ^0.8.7;
1292 
1293 // XXXXXXXXXXXXXXXXXXXXXXXKc    cKXXXXXXXKc    cKXX0:    :0XXXXXXXX0:    :0XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
1294 // XXXXXXXXXXKKKKKKKKKKKKK0c.   cKXXXXXXXKl.   c0KK0:    c0XXXXXXXX0c    :0KKKKXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
1295 // XXXXXXXXKd,''''''''''''':dddxOKXXXXXXXXOxdddc''''cdddxOKXXXXXXXXKOxdddc''',oKXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
1296 // XXXXXXXXKc              :0XXXXXXXXXXXXXXXXXKc    cKXXXXXXXXXXXXXXXXXXKc    cKXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
1297 // XXXXOddddc''''''''..    :0XXXXXXXKOxdddOKXXKc    cKXXXXXXXKOxxddxOXXXKc    cKXXXOdddddddddddddxOXXXXXXXXXXXXXXXXXXXXXXXX
1298 // XXXK:    :0KKKKKKK0;    :0XXXXXXX0:    :0XXKc    cKXXXXXXXKc.   .lKXXKc    cKXXK:             .lKXXXXXXXXXXXXXXXXXXXXXXX
1299 // KKK0:    :0XXXKKKK0:    :0KKKKXXX0:    :0KK0:    c0KKKKXXXKc.   .c0KK0c    :0KK0:              cKKKKXXXXXXKKKKKKKKKXXXXX
1300 // ''',codddOKXXKd,,,,coddoc,,,,dKXXKOdddoc,,,'.    .',,,oKXXKOxdddo:,,,,;clll:,,',codddddddo'    .''',oKXXKd,''''',,,oKXXX
1301 //     cKXXXXXXXKc    cKXXKc    cKXXXXXXXKc              :0XXXXXXXX0:    ,kOOk;    cKXXXXXXXKc         :KXXKc         :KXXX
1302 //     cKXXXXXXXKd;,,;dKXXKc    'loooooooo,    ..''..    'looooooooo:'''';cccc:,,,;dKXXXXXXXKd;,,'.    'looo:,,,,,,,,,:oooo
1303 //     cKXXXXXXXXXKKKKXXXXKc                   ;kOOx,               :kkkk:    c0KKKXXXXXXXXXXKKKK0:         c0KKKKKKKKc    
1304 //     cKKKKXXXXXXXXXXXKKKKc                   ;kkOx,               :kOOk:    cKXXXXKKKKKXXXXXXXX0:         cKXXXXXXXKl.   
1305 // oooo:,,,;dKXXXXXXXKd;,,,:cccc.    ,ooooooooo:'''';ccccccccccccccldOOOk:    cKXXKd;,,;dKXXXXXXX0:    'loodOKXXXXXXXXOdooo
1306 // XXX0:    :0XXXXXXX0:    ,kOOk;    lKXXXXXXXKc    :kOOOOOOOOOOOOOOOOOOk:    cKXX0:    :KXXXXXXX0:    :0XXXXXXXXXXXXXXXXXX
1307 // XXXKo,',,:odddddddo:'..';cllc:,'';dKXXXXXXXKd,'',:cllldkOOkdlllllllllc;'..':oddo:,'',oKXXXOdddo'    :0XXKOddddOXXXXXXXXX
1308 // XXXXXKKKKc         :kkkk:    c0KKKXXXXXXXXXXKKKK0:    ;kOOk;.         ,xkkx;    c0KKKKXXXKc         :0XXKc   .lKXXXXXXXX
1309 // XXXXXXXXKl.        :xkkx;    cKXXXXXXXXKKKKKKXXX0:    ,xkkx;.         ;xkkx;    c0KKKKKKK0:         :OKK0c   .lKXXXKKKKK
1310 // XXXXXXXXXOxdddddddo:.....    :KXXXXXXXKd,'',dKXX0:     ....:oddddddddd:'...;llll;'''''''''.    'llll:''',cdddxOXXXKd,'''
1311 // XXXXXXXXXXXXXXXXXXK:         cKXXXXXXXKc    cKXX0:         c0KXXXXXXXKc    ;kOOk,              :kOOk:    cKXXXXXXXKl    
1312 // XXXXXXXXXOxdddddddd:''''.    ,oddxOXXXKd,'',cdddo'    ..'',o0KXXXXXXXKd,''':lllc.    ..'''''''':lllc'    ,oddddddddc,'''
1313 // XXXXXXXXKl.        c0KK0c        .lKXXXKKKK0c         ;OKKKKXXXXXXXXXXKKKK0c         ;OKKKKKKKO:                   :0KKK
1314 // XXXXXKKKKc         cKKKKc         c0KKKKKKK0c         :0XXXXXXXXXKKKKKKXXXKc         :0KKKKXXX0:                   :KXXX
1315 // XXXKo,,,,:odddddddo:,'''.    .cllc:,,',,,,,,:cllc.    :0XXXXXXXXKo,,,,oKXXKc    ,oddoc,,,,dKXXKOdddo,    ,oddddddddOXXXX
1316 // XXXK:    :0XXXXXXX0:         ;kOOk,         ;kOOk,    :0XXXXXXXX0:    :0XXKc    cKXXKl    cKXXXXXXXKc    cKXXXXXXXXXXXXX
1317 // oooo:,,,;oKXXKkdooo:,,,,.    ;kOOkc'''''''''lkOOkc'''':ooodOKKXXKd;,,,coool'    cKXXKx;,,;dKXXXXXXXKc    cKXXXXXXXXXXXXX
1318 //     cKKKKXXXXKc    cKKKKc    ;kOOOOOkkkOkkOOOOOOOOkkOk:    c0KXXXXKKKKc         cKXXXXKKKKXXXXXXXXXKc    cKXXXXXXXXXXXXX
1319 //     cKXXXXXXXKc   .lKXXKl    ;kOOOOOOOOOOOOOOOOOOOOOOk:    cO0KKKKKKKKc         cKKKKXXXXXXXXXXXKKKKc    cKXKXXXXXXXXXXX
1320 //     lKXXXXXXXKOdoodOXXXKc    ;kOOOOOOOOOOOOOOOOOOOOOOOdlccc:,,,,,,,,,,;ccccccccc:,,,;dKXXXXXXXKd;,,,:cccc:,,,;dXXXXXXXXX
1321 //     lKXXXXXXXXXXXXXXXXXKc    ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOk;          ,kOOOOOOOk,    :0XXXXXXX0:    ,kOOk;    cKXXXXXXXX
1322 // '',,codddOKXXXXXXXKkdddo:'..'lkOOOOOOOOOOOOOOOOOOOOOOOOOOOkl,'.......'ckOOOOOOOkc'..':odddddddo:'..'ckOOk;    cKXXXXXXXX
1323 // KKK0:    :0XXXXXXX0:    ,xkkkOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkOOOOOOOOOOkkkk:         :kkkkOOOOk;    cKXXXXXXXX
1324 // XXXK:    :OKKKKKKKO:    ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkOOOOOOOOOOOOOOOOOOk:         :kOOOkkkkx;   .lKXXXXXXXX
1325 // XXXXOddddc''''''''':lllldOOOOOOOOOOOOOOOOOOOOOOOOOOOOOl'........'lOOOOOOOOOOOOOOOOOOOxlllllllloxOOOkl'...:dddxOXXXXXXXXX
1326 // XXXXXXXXKc         :kOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO:          :OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk:    cKXXXXXXXXXXXXX
1327 // XXXXXXXXKd,'''''''':llllllllldOOOkdlllldkOOOOOOOkdllll'          'lllldkOOOOOOOOOOOOOOOOOOdlllllllll'    cKXXXXXXXXXXXXX
1328 // XXXXXXXXXXKKKKKKKK0:         ;kOOk;    ;kOOOOOOOk;                    ;kOOOOOOOOOOOOOOOOOk;              cKXXXXXXXXXXXXX
1329 // XXXXXXXXXXXXXXXXXXK:         ;xkkx,    ,xkkkkkkkx,                    ,xkkkkOOOOOOOOOOOOOk;              :0KKKXXXXXXXXXX
1330 // XXXXXXXXXXXXXXXXXXK:    .cllc;'..',,,,,''.........                    ....'lkOOOOOOOOOOOOOdlllllllllllllc;,'',dKXXXXXXXX
1331 // XXXXXXXXXXXXXXXXXX0:    ,kOOk;    'cllc'                                   ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1332 // XXXXXXXXXXXXXXXXXXKo,,,,;cccc,....;cllc;..............                     ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1333 // XXXXXXXXXXXXXXXXXXXXXXXKc    'clllllllllcllcclllcccllc'                    ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1334 // XXXXXXXXXXXXXXXXXXXXXXXKc    .cllclllllllllllllllllllc'                    ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1335 // XXXXXXXXXXXXXXXXXXXXXXXKc     .........,clllllllllllll:,,,,.               ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1336 // XXXXXXXXXXXXXXXXXXXXXXXKc              .clllllllllllllllllc.               ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1337 // XXXXXXXXXXXXXXXXXXXXXXXKc    .........'',,,,,,,,,,,,,,:lllc,.....          ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1338 // XXXXXXXXXXXXXXXXXXXXXXXKc    ;xkkkkkkkk;              .cllllccccc.         ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1339 // XXXXXXXXXXXXXXXXXXXXXXXKc    ;kOOOOOOOk:              .:cccccccc:.         ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1340 // XXXXXXXXXXXXXXXXXXXXXXXKc    ;kOOOOOOOOxllllllllc.     ..........     .cllldOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1341 // XXXXXXXXXXXXXXXXXXXXXXXKc    ;kOOOOOOOOOOOOOOOOOk,                    ,kOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1342 // XXXXXXXXXXXXXXXXXXXXXXXXd,''';llllxOOOOOOOOOOOOOkc.....          .....ckOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1343 // XXXXXXXXXXXXXXXXXXXXXXXXXKKK0:    :kOOOOOOOOOOOOOkkkkk;          ;kkkkkOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXX
1344 // XXXXXXXXXXXXXXXXXXXXXXXXXXXXKc    :kkkkkkkkkOOOOOOOOOk:          :kOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkkkkkx;    lKXXXXXXXX
1345 // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXOdddo:'.'.....'lkOOOOOOOOxllllllllllxOOOOOOOOOOOOOOOOOOOOOOOkl'............':odddOXXXXXXXXX
1346 // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXK:         ;kOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;              cKXXXXXXXXXXXXX
1347 // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKd,,,,,,,,,:cccldOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    .,,,,,,,,;dKXXXXXXXXXXXXX
1348 // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKXXXXXK:    :kOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXXXXXXXXXXXXXXXXX
1349 // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKc    :kOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXXXXXXXXXXXXXXXXX
1350 // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKc    :kOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXXXXXXXXXXXXXXXXX
1351 // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKc    :kOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXXXXXXXXXXXXXXXXX
1352 // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKc    :kOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOk;    cKXXXXXXXXXXXXXXXXXXXXXXX
1353 
1354 
1355 contract BETA is Ownable, ERC721, NonblockingReceiver {
1356 
1357     address public _owner;
1358     string private baseURI;
1359     uint256 nextTokenId = 0;
1360 	uint256 nextReserveTokenId = 2700;
1361 	uint256 MAX_PUBLIC_MINT = 2700;
1362     uint256 MAX_MINT_ETHEREUM = 3000;
1363 
1364     uint gasForDestinationLzReceive = 350000;
1365 
1366     constructor(string memory baseURI_, address _layerZeroEndpoint) ERC721("BETA", "BETA") { 
1367         _owner = msg.sender;
1368         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1369         baseURI = baseURI_;
1370     }
1371 
1372 	// owner reserve function
1373 	function reserve(address _receiverAddress, uint8 numTokens) external onlyOwner {
1374 		require(nextReserveTokenId + numTokens <= MAX_MINT_ETHEREUM, "Greedy devs trying to take more than available!");
1375 		for (uint j = 0; j < numTokens; j++) {
1376 			_safeMint(_receiverAddress, ++nextReserveTokenId);
1377 		}
1378 	}
1379 	
1380 	// mint function
1381     // you can choose to mint 1 or 2
1382     // mint is free, but payments are accepted
1383     function mint(uint8 numTokens) external payable {
1384         require(numTokens < 3, "BETA: Max 2 NFTs per transaction");
1385         require(nextTokenId + numTokens <= MAX_PUBLIC_MINT, "BETA: Mint exceeds supply");
1386         _safeMint(msg.sender, ++nextTokenId);
1387         if (numTokens == 2) {
1388             _safeMint(msg.sender, ++nextTokenId);
1389         }
1390     }
1391 
1392     // This function transfers the nft from your address on the 
1393     // source chain to the same address on the destination chain
1394     function traverseChains(uint16 _chainId, uint tokenId) public payable {
1395         require(msg.sender == ownerOf(tokenId), "You must own the token to traverse");
1396         require(trustedRemoteLookup[_chainId].length > 0, "This chain is currently unavailable for travel");
1397 
1398         // burn NFT, eliminating it from circulation on src chain
1399         _burn(tokenId);
1400 
1401         // abi.encode() the payload with the values to send
1402         bytes memory payload = abi.encode(msg.sender, tokenId);
1403 
1404         // encode adapterParams to specify more gas for the destination
1405         uint16 version = 1;
1406         bytes memory adapterParams = abi.encodePacked(version, gasForDestinationLzReceive);
1407 
1408         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1409         // you will be refunded for extra gas paid
1410         (uint messageFee, ) = endpoint.estimateFees(_chainId, address(this), payload, false, adapterParams);
1411         
1412         require(msg.value >= messageFee, "BETA: msg.value not enough to cover messageFee. Send gas for message fees");
1413 
1414         endpoint.send{value: msg.value}(
1415             _chainId,                           // destination chainId
1416             trustedRemoteLookup[_chainId],      // destination address of nft contract
1417             payload,                            // abi.encoded()'ed bytes
1418             payable(msg.sender),                // refund address
1419             address(0x0),                       // 'zroPaymentAddress' unused for this
1420             adapterParams                       // txParameters 
1421         );
1422     }  
1423 
1424     function setBaseURI(string memory URI) external onlyOwner {
1425         baseURI = URI;
1426     }
1427 
1428     function donate() external payable {
1429         // thank you
1430     }
1431 
1432     function withdrawAll() public payable onlyOwner {
1433        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1434        require(success);
1435     }
1436 
1437     // This allows the devs to receive kind donations
1438     function withdrawAmount(uint amt) external onlyOwner {
1439         (bool sent, ) = payable(_owner).call{value: amt}("");
1440         require(sent, "META: Failed to withdraw Ether");
1441     }
1442 
1443     // just in case this fixed variable limits us from future integrations
1444     function setGasForDestinationLzReceive(uint newVal) external onlyOwner {
1445         gasForDestinationLzReceive = newVal;
1446     }
1447 
1448     // ------------------
1449     // Internal Functions
1450     // ------------------
1451 
1452     function _LzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) override internal {
1453         // decode
1454         (address toAddr, uint tokenId) = abi.decode(_payload, (address, uint));
1455 
1456         // mint the tokens back into existence on destination chain
1457         _safeMint(toAddr, tokenId);
1458     }  
1459 
1460     function _baseURI() override internal view returns (string memory) {
1461         return baseURI;
1462     }
1463 }