1 /*
2    _______________  __ __ __________ 
3   / ___/_  __/ __ \/ //_// ____/ __ \
4   \__ \ / / / / / / ,<  / __/ / / / /
5  ___/ // / / /_/ / /| |/ /___/ /_/ / 
6 /____//_/  \____/_/ |_/_____/_____/  
7                                      
8 */
9 
10 //SPDX-License-Identifier: MIT
11 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
12 
13 pragma solidity >=0.5.0;
14 
15 interface ILayerZeroUserApplicationConfig {
16     // @notice set the configuration of the LayerZero messaging library of the specified version
17     // @param _version - messaging library version
18     // @param _chainId - the chainId for the pending config change
19     // @param _configType - type of configuration. every messaging library has its own convention.
20     // @param _config - configuration in the bytes. can encode arbitrary content.
21     function setConfig(
22         uint16 _version,
23         uint16 _chainId,
24         uint256 _configType,
25         bytes calldata _config
26     ) external;
27 
28     // @notice set the send() LayerZero messaging library version to _version
29     // @param _version - new messaging library version
30     function setSendVersion(uint16 _version) external;
31 
32     // @notice set the lzReceive() LayerZero messaging library version to _version
33     // @param _version - new messaging library version
34     function setReceiveVersion(uint16 _version) external;
35 
36     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
37     // @param _srcChainId - the chainId of the source chain
38     // @param _srcAddress - the contract address of the source contract at the source chain
39     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
40         external;
41 }
42 
43 // File: contracts/interfaces/ILayerZeroEndpoint.sol
44 
45 pragma solidity >=0.5.0;
46 
47 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
48     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
49     // @param _dstChainId - the destination chain identifier
50     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
51     // @param _payload - a custom bytes payload to send to the destination contract
52     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
53     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
54     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
55     function send(
56         uint16 _dstChainId,
57         bytes calldata _destination,
58         bytes calldata _payload,
59         address payable _refundAddress,
60         address _zroPaymentAddress,
61         bytes calldata _adapterParams
62     ) external payable;
63 
64     // @notice used by the messaging library to publish verified payload
65     // @param _srcChainId - the source chain identifier
66     // @param _srcAddress - the source contract (as bytes) at the source chain
67     // @param _dstAddress - the address on destination chain
68     // @param _nonce - the unbound message ordering nonce
69     // @param _gasLimit - the gas limit for external contract execution
70     // @param _payload - verified payload to send to the destination contract
71     function receivePayload(
72         uint16 _srcChainId,
73         bytes calldata _srcAddress,
74         address _dstAddress,
75         uint64 _nonce,
76         uint256 _gasLimit,
77         bytes calldata _payload
78     ) external;
79 
80     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
81     // @param _srcChainId - the source chain identifier
82     // @param _srcAddress - the source chain contract address
83     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress)
84         external
85         view
86         returns (uint64);
87 
88     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
89     // @param _srcAddress - the source chain contract address
90     function getOutboundNonce(uint16 _dstChainId, address _srcAddress)
91         external
92         view
93         returns (uint64);
94 
95     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
96     // @param _dstChainId - the destination chain identifier
97     // @param _userApplication - the user app address on this EVM chain
98     // @param _payload - the custom message to send over LayerZero
99     // @param _payInZRO - if false, user app pays the protocol fee in native token
100     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
101     function estimateFees(
102         uint16 _dstChainId,
103         address _userApplication,
104         bytes calldata _payload,
105         bool _payInZRO,
106         bytes calldata _adapterParam
107     ) external view returns (uint256 nativeFee, uint256 zroFee);
108 
109     // @notice get this Endpoint's immutable source identifier
110     function getChainId() external view returns (uint16);
111 
112     // @notice the interface to retry failed message on this Endpoint destination
113     // @param _srcChainId - the source chain identifier
114     // @param _srcAddress - the source chain contract address
115     // @param _payload - the payload to be retried
116     function retryPayload(
117         uint16 _srcChainId,
118         bytes calldata _srcAddress,
119         bytes calldata _payload
120     ) external;
121 
122     // @notice query if any STORED payload (message blocking) at the endpoint.
123     // @param _srcChainId - the source chain identifier
124     // @param _srcAddress - the source chain contract address
125     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress)
126         external
127         view
128         returns (bool);
129 
130     // @notice query if the _libraryAddress is valid for sending msgs.
131     // @param _userApplication - the user app address on this EVM chain
132     function getSendLibraryAddress(address _userApplication)
133         external
134         view
135         returns (address);
136 
137     // @notice query if the _libraryAddress is valid for receiving msgs.
138     // @param _userApplication - the user app address on this EVM chain
139     function getReceiveLibraryAddress(address _userApplication)
140         external
141         view
142         returns (address);
143 
144     // @notice query if the non-reentrancy guard for send() is on
145     // @return true if the guard is on. false otherwise
146     function isSendingPayload() external view returns (bool);
147 
148     // @notice query if the non-reentrancy guard for receive() is on
149     // @return true if the guard is on. false otherwise
150     function isReceivingPayload() external view returns (bool);
151 
152     // @notice get the configuration of the LayerZero messaging library of the specified version
153     // @param _version - messaging library version
154     // @param _chainId - the chainId for the pending config change
155     // @param _userApplication - the contract address of the user application
156     // @param _configType - type of configuration. every messaging library has its own convention.
157     function getConfig(
158         uint16 _version,
159         uint16 _chainId,
160         address _userApplication,
161         uint256 _configType
162     ) external view returns (bytes memory);
163 
164     // @notice get the send() LayerZero messaging library version
165     // @param _userApplication - the contract address of the user application
166     function getSendVersion(address _userApplication)
167         external
168         view
169         returns (uint16);
170 
171     // @notice get the lzReceive() LayerZero messaging library version
172     // @param _userApplication - the contract address of the user application
173     function getReceiveVersion(address _userApplication)
174         external
175         view
176         returns (uint16);
177 }
178 
179 // File: contracts/interfaces/ILayerZeroReceiver.sol
180 
181 pragma solidity >=0.5.0;
182 
183 interface ILayerZeroReceiver {
184     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
185     // @param _srcChainId - the source endpoint identifier
186     // @param _srcAddress - the source sending contract address from the source chain
187     // @param _nonce - the ordered message nonce
188     // @param _payload - the signed payload is the UA bytes has encoded to be sent
189     function lzReceive(
190         uint16 _srcChainId,
191         bytes calldata _srcAddress,
192         uint64 _nonce,
193         bytes calldata _payload
194     ) external;
195 }
196 // File: @openzeppelin/contracts/utils/Strings.sol
197 
198 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 /**
203  * @dev String operations.
204  */
205 library Strings {
206     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
207 
208     /**
209      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
210      */
211     function toString(uint256 value) internal pure returns (string memory) {
212         // Inspired by OraclizeAPI's implementation - MIT licence
213         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
214 
215         if (value == 0) {
216             return "0";
217         }
218         uint256 temp = value;
219         uint256 digits;
220         while (temp != 0) {
221             digits++;
222             temp /= 10;
223         }
224         bytes memory buffer = new bytes(digits);
225         while (value != 0) {
226             digits -= 1;
227             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
228             value /= 10;
229         }
230         return string(buffer);
231     }
232 
233     /**
234      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
235      */
236     function toHexString(uint256 value) internal pure returns (string memory) {
237         if (value == 0) {
238             return "0x00";
239         }
240         uint256 temp = value;
241         uint256 length = 0;
242         while (temp != 0) {
243             length++;
244             temp >>= 8;
245         }
246         return toHexString(value, length);
247     }
248 
249     /**
250      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
251      */
252     function toHexString(uint256 value, uint256 length)
253         internal
254         pure
255         returns (string memory)
256     {
257         bytes memory buffer = new bytes(2 * length + 2);
258         buffer[0] = "0";
259         buffer[1] = "x";
260         for (uint256 i = 2 * length + 1; i > 1; --i) {
261             buffer[i] = _HEX_SYMBOLS[value & 0xf];
262             value >>= 4;
263         }
264         require(value == 0, "Strings: hex length insufficient");
265         return string(buffer);
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Context.sol
270 
271 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Provides information about the current execution context, including the
277  * sender of the transaction and its data. While these are generally available
278  * via msg.sender and msg.data, they should not be accessed in such a direct
279  * manner, since when dealing with meta-transactions the account sending and
280  * paying for execution may not be the actual sender (as far as an application
281  * is concerned).
282  *
283  * This contract is only required for intermediate, library-like contracts.
284  */
285 abstract contract Context {
286     function _msgSender() internal view virtual returns (address) {
287         return msg.sender;
288     }
289 
290     function _msgData() internal view virtual returns (bytes calldata) {
291         return msg.data;
292     }
293 }
294 
295 // File: @openzeppelin/contracts/access/Ownable.sol
296 
297 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Contract module which provides a basic access control mechanism, where
303  * there is an account (an owner) that can be granted exclusive access to
304  * specific functions.
305  *
306  * By default, the owner account will be the one that deploys the contract. This
307  * can later be changed with {transferOwnership}.
308  *
309  * This module is used through inheritance. It will make available the modifier
310  * `onlyOwner`, which can be applied to your functions to restrict their use to
311  * the owner.
312  */
313 abstract contract Ownable is Context {
314     address private _owner;
315 
316     event OwnershipTransferred(
317         address indexed previousOwner,
318         address indexed newOwner
319     );
320 
321     /**
322      * @dev Initializes the contract setting the deployer as the initial owner.
323      */
324     constructor() {
325         _transferOwnership(_msgSender());
326     }
327 
328     /**
329      * @dev Returns the address of the current owner.
330      */
331     function owner() public view virtual returns (address) {
332         return _owner;
333     }
334 
335     /**
336      * @dev Throws if called by any account other than the owner.
337      */
338     modifier onlyOwner() {
339         require(owner() == _msgSender(), "Ownable: caller is not the owner");
340         _;
341     }
342 
343     /**
344      * @dev Leaves the contract without owner. It will not be possible to call
345      * `onlyOwner` functions anymore. Can only be called by the current owner.
346      *
347      * NOTE: Renouncing ownership will leave the contract without an owner,
348      * thereby removing any functionality that is only available to the owner.
349      */
350     function renounceOwnership() public virtual onlyOwner {
351         _transferOwnership(address(0));
352     }
353 
354     /**
355      * @dev Transfers ownership of the contract to a new account (`newOwner`).
356      * Can only be called by the current owner.
357      */
358     function transferOwnership(address newOwner) public virtual onlyOwner {
359         require(
360             newOwner != address(0),
361             "Ownable: new owner is the zero address"
362         );
363         _transferOwnership(newOwner);
364     }
365 
366     /**
367      * @dev Transfers ownership of the contract to a new account (`newOwner`).
368      * Internal function without access restriction.
369      */
370     function _transferOwnership(address newOwner) internal virtual {
371         address oldOwner = _owner;
372         _owner = newOwner;
373         emit OwnershipTransferred(oldOwner, newOwner);
374     }
375 }
376 
377 // File: @openzeppelin/contracts/utils/Address.sol
378 
379 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
380 
381 pragma solidity ^0.8.0;
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
403      */
404     function isContract(address account) internal view returns (bool) {
405         // This method relies on extcodesize, which returns 0 for contracts in
406         // construction, since the code is only stored at the end of the
407         // constructor execution.
408 
409         uint256 size;
410         assembly {
411             size := extcodesize(account)
412         }
413         return size > 0;
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
433         require(
434             address(this).balance >= amount,
435             "Address: insufficient balance"
436         );
437 
438         (bool success, ) = recipient.call{value: amount}("");
439         require(
440             success,
441             "Address: unable to send value, recipient may have reverted"
442         );
443     }
444 
445     /**
446      * @dev Performs a Solidity function call using a low level `call`. A
447      * plain `call` is an unsafe replacement for a function call: use this
448      * function instead.
449      *
450      * If `target` reverts with a revert reason, it is bubbled up by this
451      * function (like regular Solidity function calls).
452      *
453      * Returns the raw returned data. To convert to the expected return value,
454      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
455      *
456      * Requirements:
457      *
458      * - `target` must be a contract.
459      * - calling `target` with `data` must not revert.
460      *
461      * _Available since v3.1._
462      */
463     function functionCall(address target, bytes memory data)
464         internal
465         returns (bytes memory)
466     {
467         return functionCall(target, data, "Address: low-level call failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
472      * `errorMessage` as a fallback revert reason when `target` reverts.
473      *
474      * _Available since v3.1._
475      */
476     function functionCall(
477         address target,
478         bytes memory data,
479         string memory errorMessage
480     ) internal returns (bytes memory) {
481         return functionCallWithValue(target, data, 0, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but also transferring `value` wei to `target`.
487      *
488      * Requirements:
489      *
490      * - the calling contract must have an ETH balance of at least `value`.
491      * - the called Solidity function must be `payable`.
492      *
493      * _Available since v3.1._
494      */
495     function functionCallWithValue(
496         address target,
497         bytes memory data,
498         uint256 value
499     ) internal returns (bytes memory) {
500         return
501             functionCallWithValue(
502                 target,
503                 data,
504                 value,
505                 "Address: low-level call with value failed"
506             );
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
511      * with `errorMessage` as a fallback revert reason when `target` reverts.
512      *
513      * _Available since v3.1._
514      */
515     function functionCallWithValue(
516         address target,
517         bytes memory data,
518         uint256 value,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         require(
522             address(this).balance >= value,
523             "Address: insufficient balance for call"
524         );
525         require(isContract(target), "Address: call to non-contract");
526 
527         (bool success, bytes memory returndata) = target.call{value: value}(
528             data
529         );
530         return verifyCallResult(success, returndata, errorMessage);
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
535      * but performing a static call.
536      *
537      * _Available since v3.3._
538      */
539     function functionStaticCall(address target, bytes memory data)
540         internal
541         view
542         returns (bytes memory)
543     {
544         return
545             functionStaticCall(
546                 target,
547                 data,
548                 "Address: low-level static call failed"
549             );
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(
559         address target,
560         bytes memory data,
561         string memory errorMessage
562     ) internal view returns (bytes memory) {
563         require(isContract(target), "Address: static call to non-contract");
564 
565         (bool success, bytes memory returndata) = target.staticcall(data);
566         return verifyCallResult(success, returndata, errorMessage);
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
571      * but performing a delegate call.
572      *
573      * _Available since v3.4._
574      */
575     function functionDelegateCall(address target, bytes memory data)
576         internal
577         returns (bytes memory)
578     {
579         return
580             functionDelegateCall(
581                 target,
582                 data,
583                 "Address: low-level delegate call failed"
584             );
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
589      * but performing a delegate call.
590      *
591      * _Available since v3.4._
592      */
593     function functionDelegateCall(
594         address target,
595         bytes memory data,
596         string memory errorMessage
597     ) internal returns (bytes memory) {
598         require(isContract(target), "Address: delegate call to non-contract");
599 
600         (bool success, bytes memory returndata) = target.delegatecall(data);
601         return verifyCallResult(success, returndata, errorMessage);
602     }
603 
604     /**
605      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
606      * revert reason using the provided one.
607      *
608      * _Available since v4.3._
609      */
610     function verifyCallResult(
611         bool success,
612         bytes memory returndata,
613         string memory errorMessage
614     ) internal pure returns (bytes memory) {
615         if (success) {
616             return returndata;
617         } else {
618             // Look for revert reason and bubble it up if present
619             if (returndata.length > 0) {
620                 // The easiest way to bubble the revert reason is using memory via assembly
621 
622                 assembly {
623                     let returndata_size := mload(returndata)
624                     revert(add(32, returndata), returndata_size)
625                 }
626             } else {
627                 revert(errorMessage);
628             }
629         }
630     }
631 }
632 
633 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
634 
635 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @title ERC721 token receiver interface
641  * @dev Interface for any contract that wants to support safeTransfers
642  * from ERC721 asset contracts.
643  */
644 interface IERC721Receiver {
645     /**
646      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
647      * by `operator` from `from`, this function is called.
648      *
649      * It must return its Solidity selector to confirm the token transfer.
650      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
651      *
652      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
653      */
654     function onERC721Received(
655         address operator,
656         address from,
657         uint256 tokenId,
658         bytes calldata data
659     ) external returns (bytes4);
660 }
661 
662 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
663 
664 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 /**
669  * @dev Interface of the ERC165 standard, as defined in the
670  * https://eips.ethereum.org/EIPS/eip-165[EIP].
671  *
672  * Implementers can declare support of contract interfaces, which can then be
673  * queried by others ({ERC165Checker}).
674  *
675  * For an implementation, see {ERC165}.
676  */
677 interface IERC165 {
678     /**
679      * @dev Returns true if this contract implements the interface defined by
680      * `interfaceId`. See the corresponding
681      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
682      * to learn more about how these ids are created.
683      *
684      * This function call must use less than 30 000 gas.
685      */
686     function supportsInterface(bytes4 interfaceId) external view returns (bool);
687 }
688 
689 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
690 
691 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 /**
696  * @dev Implementation of the {IERC165} interface.
697  *
698  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
699  * for the additional interface id that will be supported. For example:
700  *
701  * ```solidity
702  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
703  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
704  * }
705  * ```
706  *
707  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
708  */
709 abstract contract ERC165 is IERC165 {
710     /**
711      * @dev See {IERC165-supportsInterface}.
712      */
713     function supportsInterface(bytes4 interfaceId)
714         public
715         view
716         virtual
717         override
718         returns (bool)
719     {
720         return interfaceId == type(IERC165).interfaceId;
721     }
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 /**
731  * @dev Required interface of an ERC721 compliant contract.
732  */
733 interface IERC721 is IERC165 {
734     /**
735      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
736      */
737     event Transfer(
738         address indexed from,
739         address indexed to,
740         uint256 indexed tokenId
741     );
742 
743     /**
744      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
745      */
746     event Approval(
747         address indexed owner,
748         address indexed approved,
749         uint256 indexed tokenId
750     );
751 
752     /**
753      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
754      */
755     event ApprovalForAll(
756         address indexed owner,
757         address indexed operator,
758         bool approved
759     );
760 
761     /**
762      * @dev Returns the number of tokens in ``owner``'s account.
763      */
764     function balanceOf(address owner) external view returns (uint256 balance);
765 
766     /**
767      * @dev Returns the owner of the `tokenId` token.
768      *
769      * Requirements:
770      *
771      * - `tokenId` must exist.
772      */
773     function ownerOf(uint256 tokenId) external view returns (address owner);
774 
775     /**
776      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
777      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
778      *
779      * Requirements:
780      *
781      * - `from` cannot be the zero address.
782      * - `to` cannot be the zero address.
783      * - `tokenId` token must exist and be owned by `from`.
784      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
785      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
786      *
787      * Emits a {Transfer} event.
788      */
789     function safeTransferFrom(
790         address from,
791         address to,
792         uint256 tokenId
793     ) external;
794 
795     /**
796      * @dev Transfers `tokenId` token from `from` to `to`.
797      *
798      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
799      *
800      * Requirements:
801      *
802      * - `from` cannot be the zero address.
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must be owned by `from`.
805      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
806      *
807      * Emits a {Transfer} event.
808      */
809     function transferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) external;
814 
815     /**
816      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
817      * The approval is cleared when the token is transferred.
818      *
819      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
820      *
821      * Requirements:
822      *
823      * - The caller must own the token or be an approved operator.
824      * - `tokenId` must exist.
825      *
826      * Emits an {Approval} event.
827      */
828     function approve(address to, uint256 tokenId) external;
829 
830     /**
831      * @dev Returns the account approved for `tokenId` token.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      */
837     function getApproved(uint256 tokenId)
838         external
839         view
840         returns (address operator);
841 
842     /**
843      * @dev Approve or remove `operator` as an operator for the caller.
844      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
845      *
846      * Requirements:
847      *
848      * - The `operator` cannot be the caller.
849      *
850      * Emits an {ApprovalForAll} event.
851      */
852     function setApprovalForAll(address operator, bool _approved) external;
853 
854     /**
855      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
856      *
857      * See {setApprovalForAll}
858      */
859     function isApprovedForAll(address owner, address operator)
860         external
861         view
862         returns (bool);
863 
864     /**
865      * @dev Safely transfers `tokenId` token from `from` to `to`.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must exist and be owned by `from`.
872      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
873      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
874      *
875      * Emits a {Transfer} event.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes calldata data
882     ) external;
883 }
884 
885 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
886 
887 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
888 
889 pragma solidity ^0.8.0;
890 
891 /**
892  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
893  * @dev See https://eips.ethereum.org/EIPS/eip-721
894  */
895 interface IERC721Metadata is IERC721 {
896     /**
897      * @dev Returns the token collection name.
898      */
899     function name() external view returns (string memory);
900 
901     /**
902      * @dev Returns the token collection symbol.
903      */
904     function symbol() external view returns (string memory);
905 
906     /**
907      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
908      */
909     function tokenURI(uint256 tokenId) external view returns (string memory);
910 }
911 
912 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
913 
914 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
915 
916 pragma solidity ^0.8.0;
917 
918 /**
919  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
920  * the Metadata extension, but not including the Enumerable extension, which is available separately as
921  * {ERC721Enumerable}.
922  */
923 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
924     using Address for address;
925     using Strings for uint256;
926 
927     // Token name
928     string private _name;
929 
930     // Token symbol
931     string private _symbol;
932 
933     // Mapping from token ID to owner address
934     mapping(uint256 => address) private _owners;
935 
936     // Mapping owner address to token count
937     mapping(address => uint256) private _balances;
938 
939     // Mapping from token ID to approved address
940     mapping(uint256 => address) private _tokenApprovals;
941 
942     // Mapping from owner to operator approvals
943     mapping(address => mapping(address => bool)) private _operatorApprovals;
944 
945     /**
946      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
947      */
948     constructor(string memory name_, string memory symbol_) {
949         _name = name_;
950         _symbol = symbol_;
951     }
952 
953     /**
954      * @dev See {IERC165-supportsInterface}.
955      */
956     function supportsInterface(bytes4 interfaceId)
957         public
958         view
959         virtual
960         override(ERC165, IERC165)
961         returns (bool)
962     {
963         return
964             interfaceId == type(IERC721).interfaceId ||
965             interfaceId == type(IERC721Metadata).interfaceId ||
966             super.supportsInterface(interfaceId);
967     }
968 
969     /**
970      * @dev See {IERC721-balanceOf}.
971      */
972     function balanceOf(address owner)
973         public
974         view
975         virtual
976         override
977         returns (uint256)
978     {
979         require(
980             owner != address(0),
981             "ERC721: balance query for the zero address"
982         );
983         return _balances[owner];
984     }
985 
986     /**
987      * @dev See {IERC721-ownerOf}.
988      */
989     function ownerOf(uint256 tokenId)
990         public
991         view
992         virtual
993         override
994         returns (address)
995     {
996         address owner = _owners[tokenId];
997         require(
998             owner != address(0),
999             "ERC721: owner query for nonexistent token"
1000         );
1001         return owner;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-name}.
1006      */
1007     function name() public view virtual override returns (string memory) {
1008         return _name;
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Metadata-symbol}.
1013      */
1014     function symbol() public view virtual override returns (string memory) {
1015         return _symbol;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-tokenURI}.
1020      */
1021     function tokenURI(uint256 tokenId)
1022         public
1023         view
1024         virtual
1025         override
1026         returns (string memory)
1027     {
1028         require(
1029             _exists(tokenId),
1030             "ERC721Metadata: URI query for nonexistent token"
1031         );
1032 
1033         string memory baseURI = _baseURI();
1034         return
1035             bytes(baseURI).length > 0
1036                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1037                 : "";
1038     }
1039 
1040     /**
1041      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1042      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1043      * by default, can be overriden in child contracts.
1044      */
1045     function _baseURI() internal view virtual returns (string memory) {
1046         return "";
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-approve}.
1051      */
1052     function approve(address to, uint256 tokenId) public virtual override {
1053         address owner = ERC721.ownerOf(tokenId);
1054         require(to != owner, "ERC721: approval to current owner");
1055 
1056         require(
1057             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1058             "ERC721: approve caller is not owner nor approved for all"
1059         );
1060 
1061         _approve(to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-getApproved}.
1066      */
1067     function getApproved(uint256 tokenId)
1068         public
1069         view
1070         virtual
1071         override
1072         returns (address)
1073     {
1074         require(
1075             _exists(tokenId),
1076             "ERC721: approved query for nonexistent token"
1077         );
1078 
1079         return _tokenApprovals[tokenId];
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-setApprovalForAll}.
1084      */
1085     function setApprovalForAll(address operator, bool approved)
1086         public
1087         virtual
1088         override
1089     {
1090         _setApprovalForAll(_msgSender(), operator, approved);
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-isApprovedForAll}.
1095      */
1096     function isApprovedForAll(address owner, address operator)
1097         public
1098         view
1099         virtual
1100         override
1101         returns (bool)
1102     {
1103         return _operatorApprovals[owner][operator];
1104     }
1105 
1106     /**
1107      * @dev See {IERC721-transferFrom}.
1108      */
1109     function transferFrom(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) public virtual override {
1114         //solhint-disable-next-line max-line-length
1115         require(
1116             _isApprovedOrOwner(_msgSender(), tokenId),
1117             "ERC721: transfer caller is not owner nor approved"
1118         );
1119 
1120         _transfer(from, to, tokenId);
1121     }
1122 
1123     /**
1124      * @dev See {IERC721-safeTransferFrom}.
1125      */
1126     function safeTransferFrom(
1127         address from,
1128         address to,
1129         uint256 tokenId
1130     ) public virtual override {
1131         safeTransferFrom(from, to, tokenId, "");
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-safeTransferFrom}.
1136      */
1137     function safeTransferFrom(
1138         address from,
1139         address to,
1140         uint256 tokenId,
1141         bytes memory _data
1142     ) public virtual override {
1143         require(
1144             _isApprovedOrOwner(_msgSender(), tokenId),
1145             "ERC721: transfer caller is not owner nor approved"
1146         );
1147         _safeTransfer(from, to, tokenId, _data);
1148     }
1149 
1150     /**
1151      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1152      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1153      *
1154      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1155      *
1156      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1157      * implement alternative mechanisms to perform token transfer, such as signature-based.
1158      *
1159      * Requirements:
1160      *
1161      * - `from` cannot be the zero address.
1162      * - `to` cannot be the zero address.
1163      * - `tokenId` token must exist and be owned by `from`.
1164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _safeTransfer(
1169         address from,
1170         address to,
1171         uint256 tokenId,
1172         bytes memory _data
1173     ) internal virtual {
1174         _transfer(from, to, tokenId);
1175         require(
1176             _checkOnERC721Received(from, to, tokenId, _data),
1177             "ERC721: transfer to non ERC721Receiver implementer"
1178         );
1179     }
1180 
1181     /**
1182      * @dev Returns whether `tokenId` exists.
1183      *
1184      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1185      *
1186      * Tokens start existing when they are minted (`_mint`),
1187      * and stop existing when they are burned (`_burn`).
1188      */
1189     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1190         return _owners[tokenId] != address(0);
1191     }
1192 
1193     /**
1194      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      */
1200     function _isApprovedOrOwner(address spender, uint256 tokenId)
1201         internal
1202         view
1203         virtual
1204         returns (bool)
1205     {
1206         require(
1207             _exists(tokenId),
1208             "ERC721: operator query for nonexistent token"
1209         );
1210         address owner = ERC721.ownerOf(tokenId);
1211         return (spender == owner ||
1212             getApproved(tokenId) == spender ||
1213             isApprovedForAll(owner, spender));
1214     }
1215 
1216     /**
1217      * @dev Safely mints `tokenId` and transfers it to `to`.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must not exist.
1222      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _safeMint(address to, uint256 tokenId) internal virtual {
1227         _safeMint(to, tokenId, "");
1228     }
1229 
1230     /**
1231      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1232      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1233      */
1234     function _safeMint(
1235         address to,
1236         uint256 tokenId,
1237         bytes memory _data
1238     ) internal virtual {
1239         _mint(to, tokenId);
1240         require(
1241             _checkOnERC721Received(address(0), to, tokenId, _data),
1242             "ERC721: transfer to non ERC721Receiver implementer"
1243         );
1244     }
1245 
1246     /**
1247      * @dev Mints `tokenId` and transfers it to `to`.
1248      *
1249      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must not exist.
1254      * - `to` cannot be the zero address.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _mint(address to, uint256 tokenId) internal virtual {
1259         require(to != address(0), "ERC721: mint to the zero address");
1260 
1261         _beforeTokenTransfer(address(0), to, tokenId);
1262 
1263         _balances[to] += 1;
1264         _owners[tokenId] = to;
1265 
1266         emit Transfer(address(0), to, tokenId);
1267     }
1268 
1269     /**
1270      * @dev Destroys `tokenId`.
1271      * The approval is cleared when the token is burned.
1272      *
1273      * Requirements:
1274      *
1275      * - `tokenId` must exist.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _burn(uint256 tokenId) internal virtual {
1280         address owner = ERC721.ownerOf(tokenId);
1281 
1282         _beforeTokenTransfer(owner, address(0), tokenId);
1283 
1284         // Clear approvals
1285         _approve(address(0), tokenId);
1286 
1287         _balances[owner] -= 1;
1288         delete _owners[tokenId];
1289 
1290         emit Transfer(owner, address(0), tokenId);
1291     }
1292 
1293     /**
1294      * @dev Transfers `tokenId` from `from` to `to`.
1295      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1296      *
1297      * Requirements:
1298      *
1299      * - `to` cannot be the zero address.
1300      * - `tokenId` token must be owned by `from`.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function _transfer(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) internal virtual {
1309         require(
1310             ERC721.ownerOf(tokenId) == from,
1311             "ERC721: transfer of token that is not own"
1312         );
1313         require(to != address(0), "ERC721: transfer to the zero address");
1314 
1315         _beforeTokenTransfer(from, to, tokenId);
1316 
1317         // Clear approvals from the previous owner
1318         _approve(address(0), tokenId);
1319 
1320         _balances[from] -= 1;
1321         _balances[to] += 1;
1322         _owners[tokenId] = to;
1323 
1324         emit Transfer(from, to, tokenId);
1325     }
1326 
1327     /**
1328      * @dev Approve `to` to operate on `tokenId`
1329      *
1330      * Emits a {Approval} event.
1331      */
1332     function _approve(address to, uint256 tokenId) internal virtual {
1333         _tokenApprovals[tokenId] = to;
1334         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1335     }
1336 
1337     /**
1338      * @dev Approve `operator` to operate on all of `owner` tokens
1339      *
1340      * Emits a {ApprovalForAll} event.
1341      */
1342     function _setApprovalForAll(
1343         address owner,
1344         address operator,
1345         bool approved
1346     ) internal virtual {
1347         require(owner != operator, "ERC721: approve to caller");
1348         _operatorApprovals[owner][operator] = approved;
1349         emit ApprovalForAll(owner, operator, approved);
1350     }
1351 
1352     /**
1353      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1354      * The call is not executed if the target address is not a contract.
1355      *
1356      * @param from address representing the previous owner of the given token ID
1357      * @param to target address that will receive the tokens
1358      * @param tokenId uint256 ID of the token to be transferred
1359      * @param _data bytes optional data to send along with the call
1360      * @return bool whether the call correctly returned the expected magic value
1361      */
1362     function _checkOnERC721Received(
1363         address from,
1364         address to,
1365         uint256 tokenId,
1366         bytes memory _data
1367     ) private returns (bool) {
1368         if (to.isContract()) {
1369             try
1370                 IERC721Receiver(to).onERC721Received(
1371                     _msgSender(),
1372                     from,
1373                     tokenId,
1374                     _data
1375                 )
1376             returns (bytes4 retval) {
1377                 return retval == IERC721Receiver.onERC721Received.selector;
1378             } catch (bytes memory reason) {
1379                 if (reason.length == 0) {
1380                     revert(
1381                         "ERC721: transfer to non ERC721Receiver implementer"
1382                     );
1383                 } else {
1384                     assembly {
1385                         revert(add(32, reason), mload(reason))
1386                     }
1387                 }
1388             }
1389         } else {
1390             return true;
1391         }
1392     }
1393 
1394     /**
1395      * @dev Hook that is called before any token transfer. This includes minting
1396      * and burning.
1397      *
1398      * Calling conditions:
1399      *
1400      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1401      * transferred to `to`.
1402      * - When `from` is zero, `tokenId` will be minted for `to`.
1403      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1404      * - `from` and `to` are never both zero.
1405      *
1406      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1407      */
1408     function _beforeTokenTransfer(
1409         address from,
1410         address to,
1411         uint256 tokenId
1412     ) internal virtual {}
1413 }
1414 
1415 // File: contracts/NonblockingReceiver.sol
1416 
1417 pragma solidity ^0.8.6;
1418 
1419 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1420     ILayerZeroEndpoint internal endpoint;
1421 
1422     struct FailedMessages {
1423         uint256 payloadLength;
1424         bytes32 payloadHash;
1425     }
1426 
1427     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1428         public failedMessages;
1429     mapping(uint16 => bytes) public trustedRemoteLookup;
1430 
1431     event MessageFailed(
1432         uint16 _srcChainId,
1433         bytes _srcAddress,
1434         uint64 _nonce,
1435         bytes _payload
1436     );
1437 
1438     function lzReceive(
1439         uint16 _srcChainId,
1440         bytes memory _srcAddress,
1441         uint64 _nonce,
1442         bytes memory _payload
1443     ) external override {
1444         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1445         require(
1446             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1447                 keccak256(_srcAddress) ==
1448                 keccak256(trustedRemoteLookup[_srcChainId]),
1449             "NonblockingReceiver: invalid source sending contract"
1450         );
1451 
1452         // try-catch all errors/exceptions
1453         // having failed messages does not block messages passing
1454         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1455             // do nothing
1456         } catch {
1457             // error / exception
1458             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1459                 _payload.length,
1460                 keccak256(_payload)
1461             );
1462             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1463         }
1464     }
1465 
1466     function onLzReceive(
1467         uint16 _srcChainId,
1468         bytes memory _srcAddress,
1469         uint64 _nonce,
1470         bytes memory _payload
1471     ) public {
1472         // only internal transaction
1473         require(
1474             msg.sender == address(this),
1475             "NonblockingReceiver: caller must be Bridge."
1476         );
1477 
1478         // handle incoming message
1479         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1480     }
1481 
1482     // abstract function
1483     function _LzReceive(
1484         uint16 _srcChainId,
1485         bytes memory _srcAddress,
1486         uint64 _nonce,
1487         bytes memory _payload
1488     ) internal virtual;
1489 
1490     function _lzSend(
1491         uint16 _dstChainId,
1492         bytes memory _payload,
1493         address payable _refundAddress,
1494         address _zroPaymentAddress,
1495         bytes memory _txParam
1496     ) internal {
1497         endpoint.send{value: msg.value}(
1498             _dstChainId,
1499             trustedRemoteLookup[_dstChainId],
1500             _payload,
1501             _refundAddress,
1502             _zroPaymentAddress,
1503             _txParam
1504         );
1505     }
1506 
1507     function retryMessage(
1508         uint16 _srcChainId,
1509         bytes memory _srcAddress,
1510         uint64 _nonce,
1511         bytes calldata _payload
1512     ) external payable {
1513         // assert there is message to retry
1514         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1515             _srcAddress
1516         ][_nonce];
1517         require(
1518             failedMsg.payloadHash != bytes32(0),
1519             "NonblockingReceiver: no stored message"
1520         );
1521         require(
1522             _payload.length == failedMsg.payloadLength &&
1523                 keccak256(_payload) == failedMsg.payloadHash,
1524             "LayerZero: invalid payload"
1525         );
1526         // clear the stored message
1527         failedMsg.payloadLength = 0;
1528         failedMsg.payloadHash = bytes32(0);
1529         // execute the message. revert if it fails again
1530         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1531     }
1532 
1533     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1534         external
1535         onlyOwner
1536     {
1537         trustedRemoteLookup[_chainId] = _trustedRemote;
1538     }
1539 }
1540 
1541 // File: contracts/st0ked-eth.sol
1542 
1543 pragma solidity ^0.8.7;
1544 
1545 contract st0ked is Ownable, ERC721, NonblockingReceiver {
1546     address public _owner;
1547     string private baseURI;
1548     bool public isPaused = true;
1549     uint256 nextTokenId = 1111;
1550     uint256 MAX_MINT_ETH = 2022;
1551 
1552     uint256 gasForDestinationLzReceive = 2022;
1553 
1554     constructor(string memory baseURI_, address _layerZeroEndpoint)
1555         ERC721("st0ked", "st0ked")
1556     {
1557         _owner = msg.sender;
1558         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1559         baseURI = baseURI_;
1560     }
1561 
1562     // mint function
1563     // you can mint upto 2 nft's max. 1 per transaction
1564     // mint is free, but payments are accepted
1565     function mint(uint8 numTokens) external payable {
1566         require(!isPaused, "Minting is Paused yet");	
1567         require(numTokens < 2, "st0ked: Max 1 NFTs per transaction");
1568         require(balanceOf(msg.sender)+numTokens < 3, "Max 2 Nft's per wallet");
1569         require(
1570             nextTokenId + numTokens <= MAX_MINT_ETH,
1571             "st0ked: Mint exceeds supply"
1572         );
1573         _safeMint(msg.sender, ++nextTokenId);
1574         if (numTokens == 2) {
1575             _safeMint(msg.sender, ++nextTokenId);
1576         }
1577         }
1578 
1579     function pause () external onlyOwner {	
1580         isPaused = true;	
1581     }
1582 
1583     function unPause () external onlyOwner {	
1584         isPaused = false;	
1585     }
1586 
1587     // This function transfers the nft from your address on the
1588     // source chain to the same address on the destination chain
1589     function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1590         require(
1591             msg.sender == ownerOf(tokenId),
1592             "You must own the token to traverse"
1593         );
1594         require(
1595             trustedRemoteLookup[_chainId].length > 0,
1596             "This chain is currently unavailable for travel"
1597         );
1598 
1599         // burn NFT, eliminating it from circulation on src chain
1600         _burn(tokenId);
1601 
1602         // abi.encode() the payload with the values to send
1603         bytes memory payload = abi.encode(msg.sender, tokenId);
1604 
1605         // encode adapterParams to specify more gas for the destination
1606         uint16 version = 1;
1607         bytes memory adapterParams = abi.encodePacked(
1608             version,
1609             gasForDestinationLzReceive
1610         );
1611 
1612         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1613         // you will be refunded for extra gas paid
1614         (uint256 messageFee, ) = endpoint.estimateFees(
1615             _chainId,
1616             address(this),
1617             payload,
1618             false,
1619             adapterParams
1620         );
1621 
1622         require(
1623             msg.value >= messageFee,
1624             "st0ked: msg.value not enough to cover messageFee. Send gas for message fees"
1625         );
1626 
1627         endpoint.send{value: msg.value}(
1628             _chainId, // destination chainId
1629             trustedRemoteLookup[_chainId], // destination address of nft contract
1630             payload, // abi.encoded()'ed bytes
1631             payable(msg.sender), // refund address
1632             address(0x0), // 'zroPaymentAddress' unused for this
1633             adapterParams // txParameters
1634         );
1635     }
1636 
1637     function setBaseURI(string memory URI) external onlyOwner {
1638         baseURI = URI;
1639     }
1640 
1641     function donate() external payable {
1642         // thank you
1643     }
1644 
1645     // This allows the devs to receive kind donations
1646     function withdraw(uint256 amt) external onlyOwner {
1647         (bool sent, ) = payable(_owner).call{value: amt}("");
1648         require(sent, "st0ked: Failed to withdraw Ether");
1649     }
1650 
1651     // just in case this fixed variable limits us from future integrations
1652     function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1653         gasForDestinationLzReceive = newVal;
1654     }
1655 
1656     // ------------------
1657     // Internal Functions
1658     // ------------------
1659 
1660     function _LzReceive(
1661         uint16 _srcChainId,
1662         bytes memory _srcAddress,
1663         uint64 _nonce,
1664         bytes memory _payload
1665     ) internal override {
1666         // decode
1667         (address toAddr, uint256 tokenId) = abi.decode(
1668             _payload,
1669             (address, uint256)
1670         );
1671 
1672         // mint the tokens back into existence on destination chain
1673         _safeMint(toAddr, tokenId);
1674     }
1675 
1676     function _baseURI() internal view override returns (string memory) {
1677         return baseURI;
1678     }
1679 }