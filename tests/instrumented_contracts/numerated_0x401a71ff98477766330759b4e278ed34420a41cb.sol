1 // SPDX-License-Identifier: MIT
2 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
3 
4 pragma solidity >=0.5.0;
5 
6 interface ILayerZeroUserApplicationConfig {
7     // @notice set the configuration of the LayerZero messaging library of the specified version
8     // @param _version - messaging library version
9     // @param _chainId - the chainId for the pending config change
10     // @param _configType - type of configuration. every messaging library has its own convention.
11     // @param _config - configuration in the bytes. can encode arbitrary content.
12     function setConfig(
13         uint16 _version,
14         uint16 _chainId,
15         uint256 _configType,
16         bytes calldata _config
17     ) external;
18 
19     // @notice set the send() LayerZero messaging library version to _version
20     // @param _version - new messaging library version
21     function setSendVersion(uint16 _version) external;
22 
23     // @notice set the lzReceive() LayerZero messaging library version to _version
24     // @param _version - new messaging library version
25     function setReceiveVersion(uint16 _version) external;
26 
27     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
28     // @param _srcChainId - the chainId of the source chain
29     // @param _srcAddress - the contract address of the source contract at the source chain
30     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
31         external;
32 }
33 
34 // File: contracts/interfaces/ILayerZeroEndpoint.sol
35 
36 pragma solidity >=0.5.0;
37 
38 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
39     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
40     // @param _dstChainId - the destination chain identifier
41     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
42     // @param _payload - a custom bytes payload to send to the destination contract
43     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
44     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
45     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
46     function send(
47         uint16 _dstChainId,
48         bytes calldata _destination,
49         bytes calldata _payload,
50         address payable _refundAddress,
51         address _zroPaymentAddress,
52         bytes calldata _adapterParams
53     ) external payable;
54 
55     // @notice used by the messaging library to publish verified payload
56     // @param _srcChainId - the source chain identifier
57     // @param _srcAddress - the source contract (as bytes) at the source chain
58     // @param _dstAddress - the address on destination chain
59     // @param _nonce - the unbound message ordering nonce
60     // @param _gasLimit - the gas limit for external contract execution
61     // @param _payload - verified payload to send to the destination contract
62     function receivePayload(
63         uint16 _srcChainId,
64         bytes calldata _srcAddress,
65         address _dstAddress,
66         uint64 _nonce,
67         uint256 _gasLimit,
68         bytes calldata _payload
69     ) external;
70 
71     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
72     // @param _srcChainId - the source chain identifier
73     // @param _srcAddress - the source chain contract address
74     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress)
75         external
76         view
77         returns (uint64);
78 
79     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
80     // @param _srcAddress - the source chain contract address
81     function getOutboundNonce(uint16 _dstChainId, address _srcAddress)
82         external
83         view
84         returns (uint64);
85 
86     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
87     // @param _dstChainId - the destination chain identifier
88     // @param _userApplication - the user app address on this EVM chain
89     // @param _payload - the custom message to send over LayerZero
90     // @param _payInZRO - if false, user app pays the protocol fee in native token
91     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
92     function estimateFees(
93         uint16 _dstChainId,
94         address _userApplication,
95         bytes calldata _payload,
96         bool _payInZRO,
97         bytes calldata _adapterParam
98     ) external view returns (uint256 nativeFee, uint256 zroFee);
99 
100     // @notice get this Endpoint's immutable source identifier
101     function getChainId() external view returns (uint16);
102 
103     // @notice the interface to retry failed message on this Endpoint destination
104     // @param _srcChainId - the source chain identifier
105     // @param _srcAddress - the source chain contract address
106     // @param _payload - the payload to be retried
107     function retryPayload(
108         uint16 _srcChainId,
109         bytes calldata _srcAddress,
110         bytes calldata _payload
111     ) external;
112 
113     // @notice query if any STORED payload (message blocking) at the endpoint.
114     // @param _srcChainId - the source chain identifier
115     // @param _srcAddress - the source chain contract address
116     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress)
117         external
118         view
119         returns (bool);
120 
121     // @notice query if the _libraryAddress is valid for sending msgs.
122     // @param _userApplication - the user app address on this EVM chain
123     function getSendLibraryAddress(address _userApplication)
124         external
125         view
126         returns (address);
127 
128     // @notice query if the _libraryAddress is valid for receiving msgs.
129     // @param _userApplication - the user app address on this EVM chain
130     function getReceiveLibraryAddress(address _userApplication)
131         external
132         view
133         returns (address);
134 
135     // @notice query if the non-reentrancy guard for send() is on
136     // @return true if the guard is on. false otherwise
137     function isSendingPayload() external view returns (bool);
138 
139     // @notice query if the non-reentrancy guard for receive() is on
140     // @return true if the guard is on. false otherwise
141     function isReceivingPayload() external view returns (bool);
142 
143     // @notice get the configuration of the LayerZero messaging library of the specified version
144     // @param _version - messaging library version
145     // @param _chainId - the chainId for the pending config change
146     // @param _userApplication - the contract address of the user application
147     // @param _configType - type of configuration. every messaging library has its own convention.
148     function getConfig(
149         uint16 _version,
150         uint16 _chainId,
151         address _userApplication,
152         uint256 _configType
153     ) external view returns (bytes memory);
154 
155     // @notice get the send() LayerZero messaging library version
156     // @param _userApplication - the contract address of the user application
157     function getSendVersion(address _userApplication)
158         external
159         view
160         returns (uint16);
161 
162     // @notice get the lzReceive() LayerZero messaging library version
163     // @param _userApplication - the contract address of the user application
164     function getReceiveVersion(address _userApplication)
165         external
166         view
167         returns (uint16);
168 }
169 
170 // File: contracts/interfaces/ILayerZeroReceiver.sol
171 
172 pragma solidity >=0.5.0;
173 
174 interface ILayerZeroReceiver {
175     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
176     // @param _srcChainId - the source endpoint identifier
177     // @param _srcAddress - the source sending contract address from the source chain
178     // @param _nonce - the ordered message nonce
179     // @param _payload - the signed payload is the UA bytes has encoded to be sent
180     function lzReceive(
181         uint16 _srcChainId,
182         bytes calldata _srcAddress,
183         uint64 _nonce,
184         bytes calldata _payload
185     ) external;
186 }
187 // File: @openzeppelin/contracts/utils/Strings.sol
188 
189 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev String operations.
195  */
196 library Strings {
197     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
198 
199     /**
200      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
201      */
202     function toString(uint256 value) internal pure returns (string memory) {
203         // Inspired by OraclizeAPI's implementation - MIT licence
204         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
205 
206         if (value == 0) {
207             return "0";
208         }
209         uint256 temp = value;
210         uint256 digits;
211         while (temp != 0) {
212             digits++;
213             temp /= 10;
214         }
215         bytes memory buffer = new bytes(digits);
216         while (value != 0) {
217             digits -= 1;
218             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
219             value /= 10;
220         }
221         return string(buffer);
222     }
223 
224     /**
225      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
226      */
227     function toHexString(uint256 value) internal pure returns (string memory) {
228         if (value == 0) {
229             return "0x00";
230         }
231         uint256 temp = value;
232         uint256 length = 0;
233         while (temp != 0) {
234             length++;
235             temp >>= 8;
236         }
237         return toHexString(value, length);
238     }
239 
240     /**
241      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
242      */
243     function toHexString(uint256 value, uint256 length)
244         internal
245         pure
246         returns (string memory)
247     {
248         bytes memory buffer = new bytes(2 * length + 2);
249         buffer[0] = "0";
250         buffer[1] = "x";
251         for (uint256 i = 2 * length + 1; i > 1; --i) {
252             buffer[i] = _HEX_SYMBOLS[value & 0xf];
253             value >>= 4;
254         }
255         require(value == 0, "Strings: hex length insufficient");
256         return string(buffer);
257     }
258 }
259 
260 // File: @openzeppelin/contracts/utils/Context.sol
261 
262 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @dev Provides information about the current execution context, including the
268  * sender of the transaction and its data. While these are generally available
269  * via msg.sender and msg.data, they should not be accessed in such a direct
270  * manner, since when dealing with meta-transactions the account sending and
271  * paying for execution may not be the actual sender (as far as an application
272  * is concerned).
273  *
274  * This contract is only required for intermediate, library-like contracts.
275  */
276 abstract contract Context {
277     function _msgSender() internal view virtual returns (address) {
278         return msg.sender;
279     }
280 
281     function _msgData() internal view virtual returns (bytes calldata) {
282         return msg.data;
283     }
284 }
285 
286 // File: @openzeppelin/contracts/access/Ownable.sol
287 
288 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @dev Contract module which provides a basic access control mechanism, where
294  * there is an account (an owner) that can be granted exclusive access to
295  * specific functions.
296  *
297  * By default, the owner account will be the one that deploys the contract. This
298  * can later be changed with {transferOwnership}.
299  *
300  * This module is used through inheritance. It will make available the modifier
301  * `onlyOwner`, which can be applied to your functions to restrict their use to
302  * the owner.
303  */
304 abstract contract Ownable is Context {
305     address private _owner;
306 
307     event OwnershipTransferred(
308         address indexed previousOwner,
309         address indexed newOwner
310     );
311 
312     /**
313      * @dev Initializes the contract setting the deployer as the initial owner.
314      */
315     constructor() {
316         _transferOwnership(_msgSender());
317     }
318 
319     /**
320      * @dev Returns the address of the current owner.
321      */
322     function owner() public view virtual returns (address) {
323         return _owner;
324     }
325 
326     /**
327      * @dev Throws if called by any account other than the owner.
328      */
329     modifier onlyOwner() {
330         require(owner() == _msgSender(), "Ownable: caller is not the owner");
331         _;
332     }
333 
334     /**
335      * @dev Leaves the contract without owner. It will not be possible to call
336      * `onlyOwner` functions anymore. Can only be called by the current owner.
337      *
338      * NOTE: Renouncing ownership will leave the contract without an owner,
339      * thereby removing any functionality that is only available to the owner.
340      */
341     function renounceOwnership() public virtual onlyOwner {
342         _transferOwnership(address(0));
343     }
344 
345     /**
346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
347      * Can only be called by the current owner.
348      */
349     function transferOwnership(address newOwner) public virtual onlyOwner {
350         require(
351             newOwner != address(0),
352             "Ownable: new owner is the zero address"
353         );
354         _transferOwnership(newOwner);
355     }
356 
357     /**
358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
359      * Internal function without access restriction.
360      */
361     function _transferOwnership(address newOwner) internal virtual {
362         address oldOwner = _owner;
363         _owner = newOwner;
364         emit OwnershipTransferred(oldOwner, newOwner);
365     }
366 }
367 
368 // File: @openzeppelin/contracts/utils/Address.sol
369 
370 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Collection of functions related to the address type
376  */
377 library Address {
378     /**
379      * @dev Returns true if `account` is a contract.
380      *
381      * [IMPORTANT]
382      * ====
383      * It is unsafe to assume that an address for which this function returns
384      * false is an externally-owned account (EOA) and not a contract.
385      *
386      * Among others, `isContract` will return false for the following
387      * types of addresses:
388      *
389      *  - an externally-owned account
390      *  - a contract in construction
391      *  - an address where a contract will be created
392      *  - an address where a contract lived, but was destroyed
393      * ====
394      */
395     function isContract(address account) internal view returns (bool) {
396         // This method relies on extcodesize, which returns 0 for contracts in
397         // construction, since the code is only stored at the end of the
398         // constructor execution.
399 
400         uint256 size;
401         assembly {
402             size := extcodesize(account)
403         }
404         return size > 0;
405     }
406 
407     /**
408      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
409      * `recipient`, forwarding all available gas and reverting on errors.
410      *
411      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
412      * of certain opcodes, possibly making contracts go over the 2300 gas limit
413      * imposed by `transfer`, making them unable to receive funds via
414      * `transfer`. {sendValue} removes this limitation.
415      *
416      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
417      *
418      * IMPORTANT: because control is transferred to `recipient`, care must be
419      * taken to not create reentrancy vulnerabilities. Consider using
420      * {ReentrancyGuard} or the
421      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
422      */
423     function sendValue(address payable recipient, uint256 amount) internal {
424         require(
425             address(this).balance >= amount,
426             "Address: insufficient balance"
427         );
428 
429         (bool success, ) = recipient.call{value: amount}("");
430         require(
431             success,
432             "Address: unable to send value, recipient may have reverted"
433         );
434     }
435 
436     /**
437      * @dev Performs a Solidity function call using a low level `call`. A
438      * plain `call` is an unsafe replacement for a function call: use this
439      * function instead.
440      *
441      * If `target` reverts with a revert reason, it is bubbled up by this
442      * function (like regular Solidity function calls).
443      *
444      * Returns the raw returned data. To convert to the expected return value,
445      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
446      *
447      * Requirements:
448      *
449      * - `target` must be a contract.
450      * - calling `target` with `data` must not revert.
451      *
452      * _Available since v3.1._
453      */
454     function functionCall(address target, bytes memory data)
455         internal
456         returns (bytes memory)
457     {
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
491         return
492             functionCallWithValue(
493                 target,
494                 data,
495                 value,
496                 "Address: low-level call with value failed"
497             );
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
502      * with `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCallWithValue(
507         address target,
508         bytes memory data,
509         uint256 value,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         require(
513             address(this).balance >= value,
514             "Address: insufficient balance for call"
515         );
516         require(isContract(target), "Address: call to non-contract");
517 
518         (bool success, bytes memory returndata) = target.call{value: value}(
519             data
520         );
521         return verifyCallResult(success, returndata, errorMessage);
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
526      * but performing a static call.
527      *
528      * _Available since v3.3._
529      */
530     function functionStaticCall(address target, bytes memory data)
531         internal
532         view
533         returns (bytes memory)
534     {
535         return
536             functionStaticCall(
537                 target,
538                 data,
539                 "Address: low-level static call failed"
540             );
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
545      * but performing a static call.
546      *
547      * _Available since v3.3._
548      */
549     function functionStaticCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal view returns (bytes memory) {
554         require(isContract(target), "Address: static call to non-contract");
555 
556         (bool success, bytes memory returndata) = target.staticcall(data);
557         return verifyCallResult(success, returndata, errorMessage);
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
562      * but performing a delegate call.
563      *
564      * _Available since v3.4._
565      */
566     function functionDelegateCall(address target, bytes memory data)
567         internal
568         returns (bytes memory)
569     {
570         return
571             functionDelegateCall(
572                 target,
573                 data,
574                 "Address: low-level delegate call failed"
575             );
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
580      * but performing a delegate call.
581      *
582      * _Available since v3.4._
583      */
584     function functionDelegateCall(
585         address target,
586         bytes memory data,
587         string memory errorMessage
588     ) internal returns (bytes memory) {
589         require(isContract(target), "Address: delegate call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.delegatecall(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
597      * revert reason using the provided one.
598      *
599      * _Available since v4.3._
600      */
601     function verifyCallResult(
602         bool success,
603         bytes memory returndata,
604         string memory errorMessage
605     ) internal pure returns (bytes memory) {
606         if (success) {
607             return returndata;
608         } else {
609             // Look for revert reason and bubble it up if present
610             if (returndata.length > 0) {
611                 // The easiest way to bubble the revert reason is using memory via assembly
612 
613                 assembly {
614                     let returndata_size := mload(returndata)
615                     revert(add(32, returndata), returndata_size)
616                 }
617             } else {
618                 revert(errorMessage);
619             }
620         }
621     }
622 }
623 
624 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
625 
626 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 /**
631  * @title ERC721 token receiver interface
632  * @dev Interface for any contract that wants to support safeTransfers
633  * from ERC721 asset contracts.
634  */
635 interface IERC721Receiver {
636     /**
637      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
638      * by `operator` from `from`, this function is called.
639      *
640      * It must return its Solidity selector to confirm the token transfer.
641      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
642      *
643      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
644      */
645     function onERC721Received(
646         address operator,
647         address from,
648         uint256 tokenId,
649         bytes calldata data
650     ) external returns (bytes4);
651 }
652 
653 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
654 
655 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 /**
660  * @dev Interface of the ERC165 standard, as defined in the
661  * https://eips.ethereum.org/EIPS/eip-165[EIP].
662  *
663  * Implementers can declare support of contract interfaces, which can then be
664  * queried by others ({ERC165Checker}).
665  *
666  * For an implementation, see {ERC165}.
667  */
668 interface IERC165 {
669     /**
670      * @dev Returns true if this contract implements the interface defined by
671      * `interfaceId`. See the corresponding
672      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
673      * to learn more about how these ids are created.
674      *
675      * This function call must use less than 30 000 gas.
676      */
677     function supportsInterface(bytes4 interfaceId) external view returns (bool);
678 }
679 
680 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
681 
682 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 /**
687  * @dev Implementation of the {IERC165} interface.
688  *
689  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
690  * for the additional interface id that will be supported. For example:
691  *
692  * ```solidity
693  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
694  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
695  * }
696  * ```
697  *
698  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
699  */
700 abstract contract ERC165 is IERC165 {
701     /**
702      * @dev See {IERC165-supportsInterface}.
703      */
704     function supportsInterface(bytes4 interfaceId)
705         public
706         view
707         virtual
708         override
709         returns (bool)
710     {
711         return interfaceId == type(IERC165).interfaceId;
712     }
713 }
714 
715 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
716 
717 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 /**
722  * @dev Required interface of an ERC721 compliant contract.
723  */
724 interface IERC721 is IERC165 {
725     /**
726      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
727      */
728     event Transfer(
729         address indexed from,
730         address indexed to,
731         uint256 indexed tokenId
732     );
733 
734     /**
735      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
736      */
737     event Approval(
738         address indexed owner,
739         address indexed approved,
740         uint256 indexed tokenId
741     );
742 
743     /**
744      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
745      */
746     event ApprovalForAll(
747         address indexed owner,
748         address indexed operator,
749         bool approved
750     );
751 
752     /**
753      * @dev Returns the number of tokens in ``owner``'s account.
754      */
755     function balanceOf(address owner) external view returns (uint256 balance);
756 
757     /**
758      * @dev Returns the owner of the `tokenId` token.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function ownerOf(uint256 tokenId) external view returns (address owner);
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
768      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must exist and be owned by `from`.
775      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId
784     ) external;
785 
786     /**
787      * @dev Transfers `tokenId` token from `from` to `to`.
788      *
789      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must be owned by `from`.
796      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
797      *
798      * Emits a {Transfer} event.
799      */
800     function transferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external;
805 
806     /**
807      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
808      * The approval is cleared when the token is transferred.
809      *
810      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
811      *
812      * Requirements:
813      *
814      * - The caller must own the token or be an approved operator.
815      * - `tokenId` must exist.
816      *
817      * Emits an {Approval} event.
818      */
819     function approve(address to, uint256 tokenId) external;
820 
821     /**
822      * @dev Returns the account approved for `tokenId` token.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      */
828     function getApproved(uint256 tokenId)
829         external
830         view
831         returns (address operator);
832 
833     /**
834      * @dev Approve or remove `operator` as an operator for the caller.
835      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
836      *
837      * Requirements:
838      *
839      * - The `operator` cannot be the caller.
840      *
841      * Emits an {ApprovalForAll} event.
842      */
843     function setApprovalForAll(address operator, bool _approved) external;
844 
845     /**
846      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
847      *
848      * See {setApprovalForAll}
849      */
850     function isApprovedForAll(address owner, address operator)
851         external
852         view
853         returns (bool);
854 
855     /**
856      * @dev Safely transfers `tokenId` token from `from` to `to`.
857      *
858      * Requirements:
859      *
860      * - `from` cannot be the zero address.
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must exist and be owned by `from`.
863      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
864      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
865      *
866      * Emits a {Transfer} event.
867      */
868     function safeTransferFrom(
869         address from,
870         address to,
871         uint256 tokenId,
872         bytes calldata data
873     ) external;
874 }
875 
876 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
877 
878 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
879 
880 pragma solidity ^0.8.0;
881 
882 /**
883  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
884  * @dev See https://eips.ethereum.org/EIPS/eip-721
885  */
886 interface IERC721Metadata is IERC721 {
887     /**
888      * @dev Returns the token collection name.
889      */
890     function name() external view returns (string memory);
891 
892     /**
893      * @dev Returns the token collection symbol.
894      */
895     function symbol() external view returns (string memory);
896 
897     /**
898      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
899      */
900     function tokenURI(uint256 tokenId) external view returns (string memory);
901 }
902 
903 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
904 
905 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
906 
907 pragma solidity ^0.8.0;
908 
909 /**
910  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
911  * the Metadata extension, but not including the Enumerable extension, which is available separately as
912  * {ERC721Enumerable}.
913  */
914 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
915     using Address for address;
916     using Strings for uint256;
917 
918     // Token name
919     string private _name;
920 
921     string public hiddenMetadataUri;
922     
923     string public uriSuffix = ".json";
924 
925     // Token symbol
926     string private _symbol;
927 
928     // Mapping from token ID to owner address
929     mapping(uint256 => address) private _owners;
930 
931     // Mapping owner address to token count
932     mapping(address => uint256) private _balances;
933 
934     // Mapping from token ID to approved address
935     mapping(uint256 => address) private _tokenApprovals;
936 
937     // Mapping from owner to operator approvals
938     mapping(address => mapping(address => bool)) private _operatorApprovals;
939 
940     bool public revealed = false;
941 
942     /**
943      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
944      */
945     constructor(string memory name_, string memory symbol_) {
946         _name = name_;
947         _symbol = symbol_;
948     }
949 
950     /**
951      * @dev See {IERC165-supportsInterface}.
952      */
953     function supportsInterface(bytes4 interfaceId)
954         public
955         view
956         virtual
957         override(ERC165, IERC165)
958         returns (bool)
959     {
960         return
961             interfaceId == type(IERC721).interfaceId ||
962             interfaceId == type(IERC721Metadata).interfaceId ||
963             super.supportsInterface(interfaceId);
964     }
965 
966     /**
967      * @dev See {IERC721-balanceOf}.
968      */
969     function balanceOf(address owner)
970         public
971         view
972         virtual
973         override
974         returns (uint256)
975     {
976         require(
977             owner != address(0),
978             "ERC721: balance query for the zero address"
979         );
980         return _balances[owner];
981     }
982 
983     /**
984      * @dev See {IERC721-ownerOf}.
985      */
986     function ownerOf(uint256 tokenId)
987         public
988         view
989         virtual
990         override
991         returns (address)
992     {
993         address owner = _owners[tokenId];
994         require(
995             owner != address(0),
996             "ERC721: owner query for nonexistent token"
997         );
998         return owner;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Metadata-name}.
1003      */
1004     function name() public view virtual override returns (string memory) {
1005         return _name;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Metadata-symbol}.
1010      */
1011     function symbol() public view virtual override returns (string memory) {
1012         return _symbol;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-tokenURI}.
1017      */
1018     function tokenURI(uint256 tokenId)
1019         public
1020         view
1021         virtual
1022         override
1023         returns (string memory)
1024     {
1025         require(
1026             _exists(tokenId),
1027             "ERC721Metadata: URI query for nonexistent token"
1028         );
1029 
1030         if (revealed == false) {
1031          return hiddenMetadataUri;
1032          }
1033 
1034         string memory baseURI = _baseURI();
1035         return
1036             bytes(baseURI).length > 0
1037                 ? string(abi.encodePacked(baseURI, tokenId.toString(), uriSuffix))
1038                 : "";
1039     }
1040 
1041     /**
1042      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1043      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1044      * by default, can be overriden in child contracts.
1045      */
1046     function _baseURI() internal view virtual returns (string memory) {
1047         return "";
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-approve}.
1052      */
1053     function approve(address to, uint256 tokenId) public virtual override {
1054         address owner = ERC721.ownerOf(tokenId);
1055         require(to != owner, "ERC721: approval to current owner");
1056 
1057         require(
1058             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1059             "ERC721: approve caller is not owner nor approved for all"
1060         );
1061 
1062         _approve(to, tokenId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-getApproved}.
1067      */
1068     function getApproved(uint256 tokenId)
1069         public
1070         view
1071         virtual
1072         override
1073         returns (address)
1074     {
1075         require(
1076             _exists(tokenId),
1077             "ERC721: approved query for nonexistent token"
1078         );
1079 
1080         return _tokenApprovals[tokenId];
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-setApprovalForAll}.
1085      */
1086     function setApprovalForAll(address operator, bool approved)
1087         public
1088         virtual
1089         override
1090     {
1091         _setApprovalForAll(_msgSender(), operator, approved);
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-isApprovedForAll}.
1096      */
1097     function isApprovedForAll(address owner, address operator)
1098         public
1099         view
1100         virtual
1101         override
1102         returns (bool)
1103     {
1104         return _operatorApprovals[owner][operator];
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-transferFrom}.
1109      */
1110     function transferFrom(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) public virtual override {
1115         //solhint-disable-next-line max-line-length
1116         require(
1117             _isApprovedOrOwner(_msgSender(), tokenId),
1118             "ERC721: transfer caller is not owner nor approved"
1119         );
1120 
1121         _transfer(from, to, tokenId);
1122     }
1123 
1124     /**
1125      * @dev See {IERC721-safeTransferFrom}.
1126      */
1127     function safeTransferFrom(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) public virtual override {
1132         safeTransferFrom(from, to, tokenId, "");
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-safeTransferFrom}.
1137      */
1138     function safeTransferFrom(
1139         address from,
1140         address to,
1141         uint256 tokenId,
1142         bytes memory _data
1143     ) public virtual override {
1144         require(
1145             _isApprovedOrOwner(_msgSender(), tokenId),
1146             "ERC721: transfer caller is not owner nor approved"
1147         );
1148         _safeTransfer(from, to, tokenId, _data);
1149     }
1150 
1151     /**
1152      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1153      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1154      *
1155      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1156      *
1157      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1158      * implement alternative mechanisms to perform token transfer, such as signature-based.
1159      *
1160      * Requirements:
1161      *
1162      * - `from` cannot be the zero address.
1163      * - `to` cannot be the zero address.
1164      * - `tokenId` token must exist and be owned by `from`.
1165      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _safeTransfer(
1170         address from,
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) internal virtual {
1175         _transfer(from, to, tokenId);
1176         require(
1177             _checkOnERC721Received(from, to, tokenId, _data),
1178             "ERC721: transfer to non ERC721Receiver implementer"
1179         );
1180     }
1181 
1182     /**
1183      * @dev Returns whether `tokenId` exists.
1184      *
1185      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1186      *
1187      * Tokens start existing when they are minted (`_mint`),
1188      * and stop existing when they are burned (`_burn`).
1189      */
1190     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1191         return _owners[tokenId] != address(0);
1192     }
1193 
1194     /**
1195      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must exist.
1200      */
1201     function _isApprovedOrOwner(address spender, uint256 tokenId)
1202         internal
1203         view
1204         virtual
1205         returns (bool)
1206     {
1207         require(
1208             _exists(tokenId),
1209             "ERC721: operator query for nonexistent token"
1210         );
1211         address owner = ERC721.ownerOf(tokenId);
1212         return (spender == owner ||
1213             getApproved(tokenId) == spender ||
1214             isApprovedForAll(owner, spender));
1215     }
1216 
1217     /**
1218      * @dev Safely mints `tokenId` and transfers it to `to`.
1219      *
1220      * Requirements:
1221      *
1222      * - `tokenId` must not exist.
1223      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _safeMint(address to, uint256 tokenId) internal virtual {
1228         _safeMint(to, tokenId, "");
1229     }
1230 
1231     /**
1232      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1233      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1234      */
1235     function _safeMint(
1236         address to,
1237         uint256 tokenId,
1238         bytes memory _data
1239     ) internal virtual {
1240         _mint(to, tokenId);
1241         require(
1242             _checkOnERC721Received(address(0), to, tokenId, _data),
1243             "ERC721: transfer to non ERC721Receiver implementer"
1244         );
1245     }
1246 
1247 
1248     /**
1249      * @dev Mints `tokenId` and transfers it to `to`.
1250      *
1251      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1252      *
1253      * Requirements:
1254      *
1255      * - `tokenId` must not exist.
1256      * - `to` cannot be the zero address.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _mint(address to, uint256 tokenId) internal virtual {
1261         require(to != address(0), "ERC721: mint to the zero address");
1262 
1263         _beforeTokenTransfer(address(0), to, tokenId);
1264 
1265         _balances[to] += 1;
1266         _owners[tokenId] = to;
1267 
1268         emit Transfer(address(0), to, tokenId);
1269     }
1270 
1271     /**
1272      * @dev Destroys `tokenId`.
1273      * The approval is cleared when the token is burned.
1274      *
1275      * Requirements:
1276      *
1277      * - `tokenId` must exist.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _burn(uint256 tokenId) internal virtual {
1282         address owner = ERC721.ownerOf(tokenId);
1283 
1284         _beforeTokenTransfer(owner, address(0), tokenId);
1285 
1286         // Clear approvals
1287         _approve(address(0), tokenId);
1288 
1289         _balances[owner] -= 1;
1290         delete _owners[tokenId];
1291 
1292         emit Transfer(owner, address(0), tokenId);
1293     }
1294 
1295     /**
1296      * @dev Transfers `tokenId` from `from` to `to`.
1297      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1298      *
1299      * Requirements:
1300      *
1301      * - `to` cannot be the zero address.
1302      * - `tokenId` token must be owned by `from`.
1303      *
1304      * Emits a {Transfer} event.
1305      */
1306     function _transfer(
1307         address from,
1308         address to,
1309         uint256 tokenId
1310     ) internal virtual {
1311         require(
1312             ERC721.ownerOf(tokenId) == from,
1313             "ERC721: transfer of token that is not own"
1314         );
1315         require(to != address(0), "ERC721: transfer to the zero address");
1316 
1317         _beforeTokenTransfer(from, to, tokenId);
1318 
1319         // Clear approvals from the previous owner
1320         _approve(address(0), tokenId);
1321 
1322         _balances[from] -= 1;
1323         _balances[to] += 1;
1324         _owners[tokenId] = to;
1325 
1326         emit Transfer(from, to, tokenId);
1327     }
1328 
1329     /**
1330      * @dev Approve `to` to operate on `tokenId`
1331      *
1332      * Emits a {Approval} event.
1333      */
1334     function _approve(address to, uint256 tokenId) internal virtual {
1335         _tokenApprovals[tokenId] = to;
1336         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1337     }
1338 
1339     /**
1340      * @dev Approve `operator` to operate on all of `owner` tokens
1341      *
1342      * Emits a {ApprovalForAll} event.
1343      */
1344     function _setApprovalForAll(
1345         address owner,
1346         address operator,
1347         bool approved
1348     ) internal virtual {
1349         require(owner != operator, "ERC721: approve to caller");
1350         _operatorApprovals[owner][operator] = approved;
1351         emit ApprovalForAll(owner, operator, approved);
1352     }
1353 
1354     /**
1355      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1356      * The call is not executed if the target address is not a contract.
1357      *
1358      * @param from address representing the previous owner of the given token ID
1359      * @param to target address that will receive the tokens
1360      * @param tokenId uint256 ID of the token to be transferred
1361      * @param _data bytes optional data to send along with the call
1362      * @return bool whether the call correctly returned the expected magic value
1363      */
1364     function _checkOnERC721Received(
1365         address from,
1366         address to,
1367         uint256 tokenId,
1368         bytes memory _data
1369     ) private returns (bool) {
1370         if (to.isContract()) {
1371             try
1372                 IERC721Receiver(to).onERC721Received(
1373                     _msgSender(),
1374                     from,
1375                     tokenId,
1376                     _data
1377                 )
1378             returns (bytes4 retval) {
1379                 return retval == IERC721Receiver.onERC721Received.selector;
1380             } catch (bytes memory reason) {
1381                 if (reason.length == 0) {
1382                     revert(
1383                         "ERC721: transfer to non ERC721Receiver implementer"
1384                     );
1385                 } else {
1386                     assembly {
1387                         revert(add(32, reason), mload(reason))
1388                     }
1389                 }
1390             }
1391         } else {
1392             return true;
1393         }
1394     }
1395 
1396     /**
1397      * @dev Hook that is called before any token transfer. This includes minting
1398      * and burning.
1399      *
1400      * Calling conditions:
1401      *
1402      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1403      * transferred to `to`.
1404      * - When `from` is zero, `tokenId` will be minted for `to`.
1405      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1406      * - `from` and `to` are never both zero.
1407      *
1408      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1409      */
1410     function _beforeTokenTransfer(
1411         address from,
1412         address to,
1413         uint256 tokenId
1414     ) internal virtual {}
1415 }
1416 
1417 // File: contracts/NonblockingReceiver.sol
1418 
1419 pragma solidity ^0.8.6;
1420 
1421 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1422     ILayerZeroEndpoint internal endpoint;
1423 
1424     struct FailedMessages {
1425         uint256 payloadLength;
1426         bytes32 payloadHash;
1427     }
1428 
1429     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1430         public failedMessages;
1431     mapping(uint16 => bytes) public trustedRemoteLookup;
1432 
1433     event MessageFailed(
1434         uint16 _srcChainId,
1435         bytes _srcAddress,
1436         uint64 _nonce,
1437         bytes _payload
1438     );
1439 
1440     function lzReceive(
1441         uint16 _srcChainId,
1442         bytes memory _srcAddress,
1443         uint64 _nonce,
1444         bytes memory _payload
1445     ) external override {
1446         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1447         require(
1448             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1449                 keccak256(_srcAddress) ==
1450                 keccak256(trustedRemoteLookup[_srcChainId]),
1451             "NonblockingReceiver: invalid source sending contract"
1452         );
1453 
1454         // try-catch all errors/exceptions
1455         // having failed messages does not block messages passing
1456         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1457             // do nothing
1458         } catch {
1459             // error / exception
1460             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1461                 _payload.length,
1462                 keccak256(_payload)
1463             );
1464             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1465         }
1466     }
1467 
1468     function onLzReceive(
1469         uint16 _srcChainId,
1470         bytes memory _srcAddress,
1471         uint64 _nonce,
1472         bytes memory _payload
1473     ) public {
1474         // only internal transaction
1475         require(
1476             msg.sender == address(this),
1477             "NonblockingReceiver: caller must be Bridge."
1478         );
1479 
1480         // handle incoming message
1481         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1482     }
1483 
1484     // abstract function
1485     function _LzReceive(
1486         uint16 _srcChainId,
1487         bytes memory _srcAddress,
1488         uint64 _nonce,
1489         bytes memory _payload
1490     ) internal virtual;
1491 
1492     function _lzSend(
1493         uint16 _dstChainId,
1494         bytes memory _payload,
1495         address payable _refundAddress,
1496         address _zroPaymentAddress,
1497         bytes memory _txParam
1498     ) internal {
1499         endpoint.send{value: msg.value}(
1500             _dstChainId,
1501             trustedRemoteLookup[_dstChainId],
1502             _payload,
1503             _refundAddress,
1504             _zroPaymentAddress,
1505             _txParam
1506         );
1507     }
1508 
1509     function retryMessage(
1510         uint16 _srcChainId,
1511         bytes memory _srcAddress,
1512         uint64 _nonce,
1513         bytes calldata _payload
1514     ) external payable {
1515         // assert there is message to retry
1516         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1517             _srcAddress
1518         ][_nonce];
1519         require(
1520             failedMsg.payloadHash != bytes32(0),
1521             "NonblockingReceiver: no stored message"
1522         );
1523         require(
1524             _payload.length == failedMsg.payloadLength &&
1525                 keccak256(_payload) == failedMsg.payloadHash,
1526             "LayerZero: invalid payload"
1527         );
1528         // clear the stored message
1529         failedMsg.payloadLength = 0;
1530         failedMsg.payloadHash = bytes32(0);
1531         // execute the message. revert if it fails again
1532         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1533     }
1534 
1535     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1536         external
1537         onlyOwner
1538     {
1539         trustedRemoteLookup[_chainId] = _trustedRemote;
1540     }
1541 }
1542 
1543 // File: contracts/pillowcats-eth.sol
1544 
1545 pragma solidity ^0.8.7;
1546 
1547 contract pillowcats is Ownable, ERC721, NonblockingReceiver {
1548     address public _owner;
1549     string private baseURI;
1550     uint256 nextTokenId = 700;
1551     uint256 MAX_MINT_ETHEREUM = 4000;
1552     uint256 gasForDestinationLzReceive = 350000;
1553 
1554     constructor(string memory hiddenMetadataUri_, address _layerZeroEndpoint)
1555         ERC721("PillowCats", "PC")
1556     {
1557         _owner = msg.sender;
1558         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1559         hiddenMetadataUri = hiddenMetadataUri_;
1560     }
1561 
1562     // mint function
1563     // you can choose to mint 1 or 2
1564     // mint is free, but payments are accepted
1565     function mint(uint8 numTokens) external payable {
1566         require(numTokens < 3, "pillowcats: Max 2 NFTs per transaction");
1567         require(
1568             nextTokenId + numTokens <= MAX_MINT_ETHEREUM,
1569             "pillowcats: Mint exceeds supply"
1570         );
1571         _safeMint(msg.sender, ++nextTokenId);
1572         if (numTokens == 2) {
1573             _safeMint(msg.sender, ++nextTokenId);
1574         }
1575     }
1576 
1577     // This function transfers the nft from your address on the
1578     // source chain to the same address on the destination chain
1579     function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1580         require(
1581             msg.sender == ownerOf(tokenId),
1582             "You must own the token to traverse"
1583         );
1584         require(
1585             trustedRemoteLookup[_chainId].length > 0,
1586             "This chain is currently unavailable for travel"
1587         );
1588 
1589         // burn NFT, eliminating it from circulation on src chain
1590         _burn(tokenId);
1591 
1592         // abi.encode() the payload with the values to send
1593         bytes memory payload = abi.encode(msg.sender, tokenId);
1594 
1595         // encode adapterParams to specify more gas for the destination
1596         uint16 version = 1;
1597         bytes memory adapterParams = abi.encodePacked(
1598             version,
1599             gasForDestinationLzReceive
1600         );
1601 
1602         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1603         // you will be refunded for extra gas paid
1604         (uint256 messageFee, ) = endpoint.estimateFees(
1605             _chainId,
1606             address(this),
1607             payload,
1608             false,
1609             adapterParams
1610         );
1611 
1612         require(
1613             msg.value >= messageFee,
1614             "pillowcats: msg.value not enough to cover messageFee. Send gas for message fees"
1615         );
1616 
1617         endpoint.send{value: msg.value}(
1618             _chainId, // destination chainId
1619             trustedRemoteLookup[_chainId], // destination address of nft contract
1620             payload, // abi.encoded()'ed bytes
1621             payable(msg.sender), // refund address
1622             address(0x0), // 'zroPaymentAddress' unused for this
1623             adapterParams // txParameters
1624         );
1625     }
1626 
1627     function setBaseURI(string memory URI) external onlyOwner {
1628         baseURI = URI;
1629     }
1630     
1631     function setRevealed(bool _state) public onlyOwner {
1632     revealed = _state;
1633     }
1634 
1635     function donate() external payable {
1636         // thank you
1637     }
1638 
1639     // This allows the devs to receive kind donations
1640     function withdraw(uint256 amt) external onlyOwner {
1641         (bool sent, ) = payable(_owner).call{value: amt}("");
1642         require(sent, "pillowcats: Failed to withdraw Ether");
1643     }
1644 
1645     // just in case this fixed variable limits us from future integrations
1646     function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1647         gasForDestinationLzReceive = newVal;
1648     }
1649 
1650     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1651     uriSuffix = _uriSuffix;
1652   }
1653 
1654     // ------------------
1655     // Internal Functions
1656     // ------------------
1657 
1658     function _LzReceive(
1659         uint16 _srcChainId,
1660         bytes memory _srcAddress,
1661         uint64 _nonce,
1662         bytes memory _payload
1663     ) internal override {
1664         // decode
1665         (address toAddr, uint256 tokenId) = abi.decode(
1666             _payload,
1667             (address, uint256)
1668         );
1669 
1670         // mint the tokens back into existence on destination chain
1671         _safeMint(toAddr, tokenId);
1672     }
1673 
1674     function _baseURI() internal view override returns (string memory) {
1675         return baseURI;
1676     }
1677 }