1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-05
3 */
4 
5 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
6 
7 pragma solidity >=0.5.0;
8 
9 interface ILayerZeroUserApplicationConfig {
10     // @notice set the configuration of the LayerZero messaging library of the specified version
11     // @param _version - messaging library version
12     // @param _chainId - the chainId for the pending config change
13     // @param _configType - type of configuration. every messaging library has its own convention.
14     // @param _config - configuration in the bytes. can encode arbitrary content.
15     function setConfig(
16         uint16 _version,
17         uint16 _chainId,
18         uint256 _configType,
19         bytes calldata _config
20     ) external;
21 
22     // @notice set the send() LayerZero messaging library version to _version
23     // @param _version - new messaging library version
24     function setSendVersion(uint16 _version) external;
25 
26     // @notice set the lzReceive() LayerZero messaging library version to _version
27     // @param _version - new messaging library version
28     function setReceiveVersion(uint16 _version) external;
29 
30     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
31     // @param _srcChainId - the chainId of the source chain
32     // @param _srcAddress - the contract address of the source contract at the source chain
33     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
34         external;
35 }
36 
37 // File: contracts/interfaces/ILayerZeroEndpoint.sol
38 
39 pragma solidity >=0.5.0;
40 
41 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
42     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
43     // @param _dstChainId - the destination chain identifier
44     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
45     // @param _payload - a custom bytes payload to send to the destination contract
46     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
47     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
48     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
49     function send(
50         uint16 _dstChainId,
51         bytes calldata _destination,
52         bytes calldata _payload,
53         address payable _refundAddress,
54         address _zroPaymentAddress,
55         bytes calldata _adapterParams
56     ) external payable;
57 
58     // @notice used by the messaging library to publish verified payload
59     // @param _srcChainId - the source chain identifier
60     // @param _srcAddress - the source contract (as bytes) at the source chain
61     // @param _dstAddress - the address on destination chain
62     // @param _nonce - the unbound message ordering nonce
63     // @param _gasLimit - the gas limit for external contract execution
64     // @param _payload - verified payload to send to the destination contract
65     function receivePayload(
66         uint16 _srcChainId,
67         bytes calldata _srcAddress,
68         address _dstAddress,
69         uint64 _nonce,
70         uint256 _gasLimit,
71         bytes calldata _payload
72     ) external;
73 
74     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
75     // @param _srcChainId - the source chain identifier
76     // @param _srcAddress - the source chain contract address
77     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress)
78         external
79         view
80         returns (uint64);
81 
82     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
83     // @param _srcAddress - the source chain contract address
84     function getOutboundNonce(uint16 _dstChainId, address _srcAddress)
85         external
86         view
87         returns (uint64);
88 
89     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
90     // @param _dstChainId - the destination chain identifier
91     // @param _userApplication - the user app address on this EVM chain
92     // @param _payload - the custom message to send over LayerZero
93     // @param _payInZRO - if false, user app pays the protocol fee in native token
94     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
95     function estimateFees(
96         uint16 _dstChainId,
97         address _userApplication,
98         bytes calldata _payload,
99         bool _payInZRO,
100         bytes calldata _adapterParam
101     ) external view returns (uint256 nativeFee, uint256 zroFee);
102 
103     // @notice get this Endpoint's immutable source identifier
104     function getChainId() external view returns (uint16);
105 
106     // @notice the interface to retry failed message on this Endpoint destination
107     // @param _srcChainId - the source chain identifier
108     // @param _srcAddress - the source chain contract address
109     // @param _payload - the payload to be retried
110     function retryPayload(
111         uint16 _srcChainId,
112         bytes calldata _srcAddress,
113         bytes calldata _payload
114     ) external;
115 
116     // @notice query if any STORED payload (message blocking) at the endpoint.
117     // @param _srcChainId - the source chain identifier
118     // @param _srcAddress - the source chain contract address
119     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress)
120         external
121         view
122         returns (bool);
123 
124     // @notice query if the _libraryAddress is valid for sending msgs.
125     // @param _userApplication - the user app address on this EVM chain
126     function getSendLibraryAddress(address _userApplication)
127         external
128         view
129         returns (address);
130 
131     // @notice query if the _libraryAddress is valid for receiving msgs.
132     // @param _userApplication - the user app address on this EVM chain
133     function getReceiveLibraryAddress(address _userApplication)
134         external
135         view
136         returns (address);
137 
138     // @notice query if the non-reentrancy guard for send() is on
139     // @return true if the guard is on. false otherwise
140     function isSendingPayload() external view returns (bool);
141 
142     // @notice query if the non-reentrancy guard for receive() is on
143     // @return true if the guard is on. false otherwise
144     function isReceivingPayload() external view returns (bool);
145 
146     // @notice get the configuration of the LayerZero messaging library of the specified version
147     // @param _version - messaging library version
148     // @param _chainId - the chainId for the pending config change
149     // @param _userApplication - the contract address of the user application
150     // @param _configType - type of configuration. every messaging library has its own convention.
151     function getConfig(
152         uint16 _version,
153         uint16 _chainId,
154         address _userApplication,
155         uint256 _configType
156     ) external view returns (bytes memory);
157 
158     // @notice get the send() LayerZero messaging library version
159     // @param _userApplication - the contract address of the user application
160     function getSendVersion(address _userApplication)
161         external
162         view
163         returns (uint16);
164 
165     // @notice get the lzReceive() LayerZero messaging library version
166     // @param _userApplication - the contract address of the user application
167     function getReceiveVersion(address _userApplication)
168         external
169         view
170         returns (uint16);
171 }
172 
173 // File: contracts/interfaces/ILayerZeroReceiver.sol
174 
175 pragma solidity >=0.5.0;
176 
177 interface ILayerZeroReceiver {
178     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
179     // @param _srcChainId - the source endpoint identifier
180     // @param _srcAddress - the source sending contract address from the source chain
181     // @param _nonce - the ordered message nonce
182     // @param _payload - the signed payload is the UA bytes has encoded to be sent
183     function lzReceive(
184         uint16 _srcChainId,
185         bytes calldata _srcAddress,
186         uint64 _nonce,
187         bytes calldata _payload
188     ) external;
189 }
190 // File: @openzeppelin/contracts/utils/Strings.sol
191 
192 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 /**
197  * @dev String operations.
198  */
199 library Strings {
200     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
201 
202     /**
203      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
204      */
205     function toString(uint256 value) internal pure returns (string memory) {
206         // Inspired by OraclizeAPI's implementation - MIT licence
207         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
208 
209         if (value == 0) {
210             return "0";
211         }
212         uint256 temp = value;
213         uint256 digits;
214         while (temp != 0) {
215             digits++;
216             temp /= 10;
217         }
218         bytes memory buffer = new bytes(digits);
219         while (value != 0) {
220             digits -= 1;
221             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
222             value /= 10;
223         }
224         return string(buffer);
225     }
226 
227     /**
228      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
229      */
230     function toHexString(uint256 value) internal pure returns (string memory) {
231         if (value == 0) {
232             return "0x00";
233         }
234         uint256 temp = value;
235         uint256 length = 0;
236         while (temp != 0) {
237             length++;
238             temp >>= 8;
239         }
240         return toHexString(value, length);
241     }
242 
243     /**
244      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
245      */
246     function toHexString(uint256 value, uint256 length)
247         internal
248         pure
249         returns (string memory)
250     {
251         bytes memory buffer = new bytes(2 * length + 2);
252         buffer[0] = "0";
253         buffer[1] = "x";
254         for (uint256 i = 2 * length + 1; i > 1; --i) {
255             buffer[i] = _HEX_SYMBOLS[value & 0xf];
256             value >>= 4;
257         }
258         require(value == 0, "Strings: hex length insufficient");
259         return string(buffer);
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/Context.sol
264 
265 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @dev Provides information about the current execution context, including the
271  * sender of the transaction and its data. While these are generally available
272  * via msg.sender and msg.data, they should not be accessed in such a direct
273  * manner, since when dealing with meta-transactions the account sending and
274  * paying for execution may not be the actual sender (as far as an application
275  * is concerned).
276  *
277  * This contract is only required for intermediate, library-like contracts.
278  */
279 abstract contract Context {
280     function _msgSender() internal view virtual returns (address) {
281         return msg.sender;
282     }
283 
284     function _msgData() internal view virtual returns (bytes calldata) {
285         return msg.data;
286     }
287 }
288 
289 // File: @openzeppelin/contracts/access/Ownable.sol
290 
291 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Contract module which provides a basic access control mechanism, where
297  * there is an account (an owner) that can be granted exclusive access to
298  * specific functions.
299  *
300  * By default, the owner account will be the one that deploys the contract. This
301  * can later be changed with {transferOwnership}.
302  *
303  * This module is used through inheritance. It will make available the modifier
304  * `onlyOwner`, which can be applied to your functions to restrict their use to
305  * the owner.
306  */
307 abstract contract Ownable is Context {
308     address private _owner;
309 
310     event OwnershipTransferred(
311         address indexed previousOwner,
312         address indexed newOwner
313     );
314 
315     /**
316      * @dev Initializes the contract setting the deployer as the initial owner.
317      */
318     constructor() {
319         _transferOwnership(_msgSender());
320     }
321 
322     /**
323      * @dev Returns the address of the current owner.
324      */
325     function owner() public view virtual returns (address) {
326         return _owner;
327     }
328 
329     /**
330      * @dev Throws if called by any account other than the owner.
331      */
332     modifier onlyOwner() {
333         require(owner() == _msgSender(), "Ownable: caller is not the owner");
334         _;
335     }
336 
337     /**
338      * @dev Leaves the contract without owner. It will not be possible to call
339      * `onlyOwner` functions anymore. Can only be called by the current owner.
340      *
341      * NOTE: Renouncing ownership will leave the contract without an owner,
342      * thereby removing any functionality that is only available to the owner.
343      */
344     function renounceOwnership() public virtual onlyOwner {
345         _transferOwnership(address(0));
346     }
347 
348     /**
349      * @dev Transfers ownership of the contract to a new account (`newOwner`).
350      * Can only be called by the current owner.
351      */
352     function transferOwnership(address newOwner) public virtual onlyOwner {
353         require(
354             newOwner != address(0),
355             "Ownable: new owner is the zero address"
356         );
357         _transferOwnership(newOwner);
358     }
359 
360     /**
361      * @dev Transfers ownership of the contract to a new account (`newOwner`).
362      * Internal function without access restriction.
363      */
364     function _transferOwnership(address newOwner) internal virtual {
365         address oldOwner = _owner;
366         _owner = newOwner;
367         emit OwnershipTransferred(oldOwner, newOwner);
368     }
369 }
370 
371 // File: @openzeppelin/contracts/utils/Address.sol
372 
373 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @dev Collection of functions related to the address type
379  */
380 library Address {
381     /**
382      * @dev Returns true if `account` is a contract.
383      *
384      * [IMPORTANT]
385      * ====
386      * It is unsafe to assume that an address for which this function returns
387      * false is an externally-owned account (EOA) and not a contract.
388      *
389      * Among others, `isContract` will return false for the following
390      * types of addresses:
391      *
392      *  - an externally-owned account
393      *  - a contract in construction
394      *  - an address where a contract will be created
395      *  - an address where a contract lived, but was destroyed
396      * ====
397      */
398     function isContract(address account) internal view returns (bool) {
399         // This method relies on extcodesize, which returns 0 for contracts in
400         // construction, since the code is only stored at the end of the
401         // constructor execution.
402 
403         uint256 size;
404         assembly {
405             size := extcodesize(account)
406         }
407         return size > 0;
408     }
409 
410     /**
411      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
412      * `recipient`, forwarding all available gas and reverting on errors.
413      *
414      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
415      * of certain opcodes, possibly making contracts go over the 2300 gas limit
416      * imposed by `transfer`, making them unable to receive funds via
417      * `transfer`. {sendValue} removes this limitation.
418      *
419      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
420      *
421      * IMPORTANT: because control is transferred to `recipient`, care must be
422      * taken to not create reentrancy vulnerabilities. Consider using
423      * {ReentrancyGuard} or the
424      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
425      */
426     function sendValue(address payable recipient, uint256 amount) internal {
427         require(
428             address(this).balance >= amount,
429             "Address: insufficient balance"
430         );
431 
432         (bool success, ) = recipient.call{value: amount}("");
433         require(
434             success,
435             "Address: unable to send value, recipient may have reverted"
436         );
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
457     function functionCall(address target, bytes memory data)
458         internal
459         returns (bytes memory)
460     {
461         return functionCall(target, data, "Address: low-level call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
466      * `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         return functionCallWithValue(target, data, 0, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but also transferring `value` wei to `target`.
481      *
482      * Requirements:
483      *
484      * - the calling contract must have an ETH balance of at least `value`.
485      * - the called Solidity function must be `payable`.
486      *
487      * _Available since v3.1._
488      */
489     function functionCallWithValue(
490         address target,
491         bytes memory data,
492         uint256 value
493     ) internal returns (bytes memory) {
494         return
495             functionCallWithValue(
496                 target,
497                 data,
498                 value,
499                 "Address: low-level call with value failed"
500             );
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
505      * with `errorMessage` as a fallback revert reason when `target` reverts.
506      *
507      * _Available since v3.1._
508      */
509     function functionCallWithValue(
510         address target,
511         bytes memory data,
512         uint256 value,
513         string memory errorMessage
514     ) internal returns (bytes memory) {
515         require(
516             address(this).balance >= value,
517             "Address: insufficient balance for call"
518         );
519         require(isContract(target), "Address: call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.call{value: value}(
522             data
523         );
524         return verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(address target, bytes memory data)
534         internal
535         view
536         returns (bytes memory)
537     {
538         return
539             functionStaticCall(
540                 target,
541                 data,
542                 "Address: low-level static call failed"
543             );
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
548      * but performing a static call.
549      *
550      * _Available since v3.3._
551      */
552     function functionStaticCall(
553         address target,
554         bytes memory data,
555         string memory errorMessage
556     ) internal view returns (bytes memory) {
557         require(isContract(target), "Address: static call to non-contract");
558 
559         (bool success, bytes memory returndata) = target.staticcall(data);
560         return verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
565      * but performing a delegate call.
566      *
567      * _Available since v3.4._
568      */
569     function functionDelegateCall(address target, bytes memory data)
570         internal
571         returns (bytes memory)
572     {
573         return
574             functionDelegateCall(
575                 target,
576                 data,
577                 "Address: low-level delegate call failed"
578             );
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(
588         address target,
589         bytes memory data,
590         string memory errorMessage
591     ) internal returns (bytes memory) {
592         require(isContract(target), "Address: delegate call to non-contract");
593 
594         (bool success, bytes memory returndata) = target.delegatecall(data);
595         return verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     /**
599      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
600      * revert reason using the provided one.
601      *
602      * _Available since v4.3._
603      */
604     function verifyCallResult(
605         bool success,
606         bytes memory returndata,
607         string memory errorMessage
608     ) internal pure returns (bytes memory) {
609         if (success) {
610             return returndata;
611         } else {
612             // Look for revert reason and bubble it up if present
613             if (returndata.length > 0) {
614                 // The easiest way to bubble the revert reason is using memory via assembly
615 
616                 assembly {
617                     let returndata_size := mload(returndata)
618                     revert(add(32, returndata), returndata_size)
619                 }
620             } else {
621                 revert(errorMessage);
622             }
623         }
624     }
625 }
626 
627 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
628 
629 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @title ERC721 token receiver interface
635  * @dev Interface for any contract that wants to support safeTransfers
636  * from ERC721 asset contracts.
637  */
638 interface IERC721Receiver {
639     /**
640      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
641      * by `operator` from `from`, this function is called.
642      *
643      * It must return its Solidity selector to confirm the token transfer.
644      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
645      *
646      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
647      */
648     function onERC721Received(
649         address operator,
650         address from,
651         uint256 tokenId,
652         bytes calldata data
653     ) external returns (bytes4);
654 }
655 
656 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
657 
658 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @dev Interface of the ERC165 standard, as defined in the
664  * https://eips.ethereum.org/EIPS/eip-165[EIP].
665  *
666  * Implementers can declare support of contract interfaces, which can then be
667  * queried by others ({ERC165Checker}).
668  *
669  * For an implementation, see {ERC165}.
670  */
671 interface IERC165 {
672     /**
673      * @dev Returns true if this contract implements the interface defined by
674      * `interfaceId`. See the corresponding
675      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
676      * to learn more about how these ids are created.
677      *
678      * This function call must use less than 30 000 gas.
679      */
680     function supportsInterface(bytes4 interfaceId) external view returns (bool);
681 }
682 
683 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
684 
685 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 /**
690  * @dev Implementation of the {IERC165} interface.
691  *
692  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
693  * for the additional interface id that will be supported. For example:
694  *
695  * ```solidity
696  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
697  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
698  * }
699  * ```
700  *
701  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
702  */
703 abstract contract ERC165 is IERC165 {
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId)
708         public
709         view
710         virtual
711         override
712         returns (bool)
713     {
714         return interfaceId == type(IERC165).interfaceId;
715     }
716 }
717 
718 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
719 
720 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 /**
725  * @dev Required interface of an ERC721 compliant contract.
726  */
727 interface IERC721 is IERC165 {
728     /**
729      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
730      */
731     event Transfer(
732         address indexed from,
733         address indexed to,
734         uint256 indexed tokenId
735     );
736 
737     /**
738      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
739      */
740     event Approval(
741         address indexed owner,
742         address indexed approved,
743         uint256 indexed tokenId
744     );
745 
746     /**
747      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
748      */
749     event ApprovalForAll(
750         address indexed owner,
751         address indexed operator,
752         bool approved
753     );
754 
755     /**
756      * @dev Returns the number of tokens in ``owner``'s account.
757      */
758     function balanceOf(address owner) external view returns (uint256 balance);
759 
760     /**
761      * @dev Returns the owner of the `tokenId` token.
762      *
763      * Requirements:
764      *
765      * - `tokenId` must exist.
766      */
767     function ownerOf(uint256 tokenId) external view returns (address owner);
768 
769     /**
770      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
771      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
772      *
773      * Requirements:
774      *
775      * - `from` cannot be the zero address.
776      * - `to` cannot be the zero address.
777      * - `tokenId` token must exist and be owned by `from`.
778      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
779      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
780      *
781      * Emits a {Transfer} event.
782      */
783     function safeTransferFrom(
784         address from,
785         address to,
786         uint256 tokenId
787     ) external;
788 
789     /**
790      * @dev Transfers `tokenId` token from `from` to `to`.
791      *
792      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
793      *
794      * Requirements:
795      *
796      * - `from` cannot be the zero address.
797      * - `to` cannot be the zero address.
798      * - `tokenId` token must be owned by `from`.
799      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
800      *
801      * Emits a {Transfer} event.
802      */
803     function transferFrom(
804         address from,
805         address to,
806         uint256 tokenId
807     ) external;
808 
809     /**
810      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
811      * The approval is cleared when the token is transferred.
812      *
813      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
814      *
815      * Requirements:
816      *
817      * - The caller must own the token or be an approved operator.
818      * - `tokenId` must exist.
819      *
820      * Emits an {Approval} event.
821      */
822     function approve(address to, uint256 tokenId) external;
823 
824     /**
825      * @dev Returns the account approved for `tokenId` token.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must exist.
830      */
831     function getApproved(uint256 tokenId)
832         external
833         view
834         returns (address operator);
835 
836     /**
837      * @dev Approve or remove `operator` as an operator for the caller.
838      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
839      *
840      * Requirements:
841      *
842      * - The `operator` cannot be the caller.
843      *
844      * Emits an {ApprovalForAll} event.
845      */
846     function setApprovalForAll(address operator, bool _approved) external;
847 
848     /**
849      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
850      *
851      * See {setApprovalForAll}
852      */
853     function isApprovedForAll(address owner, address operator)
854         external
855         view
856         returns (bool);
857 
858     /**
859      * @dev Safely transfers `tokenId` token from `from` to `to`.
860      *
861      * Requirements:
862      *
863      * - `from` cannot be the zero address.
864      * - `to` cannot be the zero address.
865      * - `tokenId` token must exist and be owned by `from`.
866      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
867      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
868      *
869      * Emits a {Transfer} event.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes calldata data
876     ) external;
877 }
878 
879 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
880 
881 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
882 
883 pragma solidity ^0.8.0;
884 
885 /**
886  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
887  * @dev See https://eips.ethereum.org/EIPS/eip-721
888  */
889 interface IERC721Metadata is IERC721 {
890     /**
891      * @dev Returns the token collection name.
892      */
893     function name() external view returns (string memory);
894 
895     /**
896      * @dev Returns the token collection symbol.
897      */
898     function symbol() external view returns (string memory);
899 
900     /**
901      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
902      */
903     function tokenURI(uint256 tokenId) external view returns (string memory);
904 }
905 
906 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
907 
908 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 /**
913  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
914  * the Metadata extension, but not including the Enumerable extension, which is available separately as
915  * {ERC721Enumerable}.
916  */
917 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
918     using Address for address;
919     using Strings for uint256;
920 
921     // Token name
922     string private _name;
923 
924     // Token symbol
925     string private _symbol;
926 
927     // Mapping from token ID to owner address
928     mapping(uint256 => address) private _owners;
929 
930     // Mapping owner address to token count
931     mapping(address => uint256) private _balances;
932 
933     // Mapping from token ID to approved address
934     mapping(uint256 => address) private _tokenApprovals;
935 
936     // Mapping from owner to operator approvals
937     mapping(address => mapping(address => bool)) private _operatorApprovals;
938 
939     /**
940      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
941      */
942     constructor(string memory name_, string memory symbol_) {
943         _name = name_;
944         _symbol = symbol_;
945     }
946 
947     /**
948      * @dev See {IERC165-supportsInterface}.
949      */
950     function supportsInterface(bytes4 interfaceId)
951         public
952         view
953         virtual
954         override(ERC165, IERC165)
955         returns (bool)
956     {
957         return
958             interfaceId == type(IERC721).interfaceId ||
959             interfaceId == type(IERC721Metadata).interfaceId ||
960             super.supportsInterface(interfaceId);
961     }
962 
963     /**
964      * @dev See {IERC721-balanceOf}.
965      */
966     function balanceOf(address owner)
967         public
968         view
969         virtual
970         override
971         returns (uint256)
972     {
973         require(
974             owner != address(0),
975             "ERC721: balance query for the zero address"
976         );
977         return _balances[owner];
978     }
979 
980     /**
981      * @dev See {IERC721-ownerOf}.
982      */
983     function ownerOf(uint256 tokenId)
984         public
985         view
986         virtual
987         override
988         returns (address)
989     {
990         address owner = _owners[tokenId];
991         require(
992             owner != address(0),
993             "ERC721: owner query for nonexistent token"
994         );
995         return owner;
996     }
997 
998     /**
999      * @dev See {IERC721Metadata-name}.
1000      */
1001     function name() public view virtual override returns (string memory) {
1002         return _name;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-symbol}.
1007      */
1008     function symbol() public view virtual override returns (string memory) {
1009         return _symbol;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Metadata-tokenURI}.
1014      */
1015     function tokenURI(uint256 tokenId)
1016         public
1017         view
1018         virtual
1019         override
1020         returns (string memory)
1021     {
1022         require(
1023             _exists(tokenId),
1024             "ERC721Metadata: URI query for nonexistent token"
1025         );
1026 
1027         string memory baseURI = _baseURI();
1028         return
1029             bytes(baseURI).length > 0
1030                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1031                 : "";
1032     }
1033 
1034     /**
1035      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1036      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1037      * by default, can be overriden in child contracts.
1038      */
1039     function _baseURI() internal view virtual returns (string memory) {
1040         return "";
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-approve}.
1045      */
1046     function approve(address to, uint256 tokenId) public virtual override {
1047         address owner = ERC721.ownerOf(tokenId);
1048         require(to != owner, "ERC721: approval to current owner");
1049 
1050         require(
1051             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1052             "ERC721: approve caller is not owner nor approved for all"
1053         );
1054 
1055         _approve(to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-getApproved}.
1060      */
1061     function getApproved(uint256 tokenId)
1062         public
1063         view
1064         virtual
1065         override
1066         returns (address)
1067     {
1068         require(
1069             _exists(tokenId),
1070             "ERC721: approved query for nonexistent token"
1071         );
1072 
1073         return _tokenApprovals[tokenId];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-setApprovalForAll}.
1078      */
1079     function setApprovalForAll(address operator, bool approved)
1080         public
1081         virtual
1082         override
1083     {
1084         _setApprovalForAll(_msgSender(), operator, approved);
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-isApprovedForAll}.
1089      */
1090     function isApprovedForAll(address owner, address operator)
1091         public
1092         view
1093         virtual
1094         override
1095         returns (bool)
1096     {
1097         return _operatorApprovals[owner][operator];
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-transferFrom}.
1102      */
1103     function transferFrom(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) public virtual override {
1108         //solhint-disable-next-line max-line-length
1109         require(
1110             _isApprovedOrOwner(_msgSender(), tokenId),
1111             "ERC721: transfer caller is not owner nor approved"
1112         );
1113 
1114         _transfer(from, to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-safeTransferFrom}.
1119      */
1120     function safeTransferFrom(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) public virtual override {
1125         safeTransferFrom(from, to, tokenId, "");
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-safeTransferFrom}.
1130      */
1131     function safeTransferFrom(
1132         address from,
1133         address to,
1134         uint256 tokenId,
1135         bytes memory _data
1136     ) public virtual override {
1137         require(
1138             _isApprovedOrOwner(_msgSender(), tokenId),
1139             "ERC721: transfer caller is not owner nor approved"
1140         );
1141         _safeTransfer(from, to, tokenId, _data);
1142     }
1143 
1144     /**
1145      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1146      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1147      *
1148      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1149      *
1150      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1151      * implement alternative mechanisms to perform token transfer, such as signature-based.
1152      *
1153      * Requirements:
1154      *
1155      * - `from` cannot be the zero address.
1156      * - `to` cannot be the zero address.
1157      * - `tokenId` token must exist and be owned by `from`.
1158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _safeTransfer(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) internal virtual {
1168         _transfer(from, to, tokenId);
1169         require(
1170             _checkOnERC721Received(from, to, tokenId, _data),
1171             "ERC721: transfer to non ERC721Receiver implementer"
1172         );
1173     }
1174 
1175     /**
1176      * @dev Returns whether `tokenId` exists.
1177      *
1178      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1179      *
1180      * Tokens start existing when they are minted (`_mint`),
1181      * and stop existing when they are burned (`_burn`).
1182      */
1183     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1184         return _owners[tokenId] != address(0);
1185     }
1186 
1187     /**
1188      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      */
1194     function _isApprovedOrOwner(address spender, uint256 tokenId)
1195         internal
1196         view
1197         virtual
1198         returns (bool)
1199     {
1200         require(
1201             _exists(tokenId),
1202             "ERC721: operator query for nonexistent token"
1203         );
1204         address owner = ERC721.ownerOf(tokenId);
1205         return (spender == owner ||
1206             getApproved(tokenId) == spender ||
1207             isApprovedForAll(owner, spender));
1208     }
1209 
1210     /**
1211      * @dev Safely mints `tokenId` and transfers it to `to`.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must not exist.
1216      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _safeMint(address to, uint256 tokenId) internal virtual {
1221         _safeMint(to, tokenId, "");
1222     }
1223 
1224     /**
1225      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1226      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1227      */
1228     function _safeMint(
1229         address to,
1230         uint256 tokenId,
1231         bytes memory _data
1232     ) internal virtual {
1233         _mint(to, tokenId);
1234         require(
1235             _checkOnERC721Received(address(0), to, tokenId, _data),
1236             "ERC721: transfer to non ERC721Receiver implementer"
1237         );
1238     }
1239 
1240     /**
1241      * @dev Mints `tokenId` and transfers it to `to`.
1242      *
1243      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1244      *
1245      * Requirements:
1246      *
1247      * - `tokenId` must not exist.
1248      * - `to` cannot be the zero address.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _mint(address to, uint256 tokenId) internal virtual {
1253         require(to != address(0), "ERC721: mint to the zero address");
1254 
1255         _beforeTokenTransfer(address(0), to, tokenId);
1256 
1257         _balances[to] += 1;
1258         _owners[tokenId] = to;
1259 
1260         emit Transfer(address(0), to, tokenId);
1261     }
1262 
1263     /**
1264      * @dev Destroys `tokenId`.
1265      * The approval is cleared when the token is burned.
1266      *
1267      * Requirements:
1268      *
1269      * - `tokenId` must exist.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function _burn(uint256 tokenId) internal virtual {
1274         address owner = ERC721.ownerOf(tokenId);
1275 
1276         _beforeTokenTransfer(owner, address(0), tokenId);
1277 
1278         // Clear approvals
1279         _approve(address(0), tokenId);
1280 
1281         _balances[owner] -= 1;
1282         delete _owners[tokenId];
1283 
1284         emit Transfer(owner, address(0), tokenId);
1285     }
1286 
1287     /**
1288      * @dev Transfers `tokenId` from `from` to `to`.
1289      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1290      *
1291      * Requirements:
1292      *
1293      * - `to` cannot be the zero address.
1294      * - `tokenId` token must be owned by `from`.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function _transfer(
1299         address from,
1300         address to,
1301         uint256 tokenId
1302     ) internal virtual {
1303         require(
1304             ERC721.ownerOf(tokenId) == from,
1305             "ERC721: transfer of token that is not own"
1306         );
1307         require(to != address(0), "ERC721: transfer to the zero address");
1308 
1309         _beforeTokenTransfer(from, to, tokenId);
1310 
1311         // Clear approvals from the previous owner
1312         _approve(address(0), tokenId);
1313 
1314         _balances[from] -= 1;
1315         _balances[to] += 1;
1316         _owners[tokenId] = to;
1317 
1318         emit Transfer(from, to, tokenId);
1319     }
1320 
1321     /**
1322      * @dev Approve `to` to operate on `tokenId`
1323      *
1324      * Emits a {Approval} event.
1325      */
1326     function _approve(address to, uint256 tokenId) internal virtual {
1327         _tokenApprovals[tokenId] = to;
1328         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1329     }
1330 
1331     /**
1332      * @dev Approve `operator` to operate on all of `owner` tokens
1333      *
1334      * Emits a {ApprovalForAll} event.
1335      */
1336     function _setApprovalForAll(
1337         address owner,
1338         address operator,
1339         bool approved
1340     ) internal virtual {
1341         require(owner != operator, "ERC721: approve to caller");
1342         _operatorApprovals[owner][operator] = approved;
1343         emit ApprovalForAll(owner, operator, approved);
1344     }
1345 
1346     /**
1347      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1348      * The call is not executed if the target address is not a contract.
1349      *
1350      * @param from address representing the previous owner of the given token ID
1351      * @param to target address that will receive the tokens
1352      * @param tokenId uint256 ID of the token to be transferred
1353      * @param _data bytes optional data to send along with the call
1354      * @return bool whether the call correctly returned the expected magic value
1355      */
1356     function _checkOnERC721Received(
1357         address from,
1358         address to,
1359         uint256 tokenId,
1360         bytes memory _data
1361     ) private returns (bool) {
1362         if (to.isContract()) {
1363             try
1364                 IERC721Receiver(to).onERC721Received(
1365                     _msgSender(),
1366                     from,
1367                     tokenId,
1368                     _data
1369                 )
1370             returns (bytes4 retval) {
1371                 return retval == IERC721Receiver.onERC721Received.selector;
1372             } catch (bytes memory reason) {
1373                 if (reason.length == 0) {
1374                     revert(
1375                         "ERC721: transfer to non ERC721Receiver implementer"
1376                     );
1377                 } else {
1378                     assembly {
1379                         revert(add(32, reason), mload(reason))
1380                     }
1381                 }
1382             }
1383         } else {
1384             return true;
1385         }
1386     }
1387 
1388     /**
1389      * @dev Hook that is called before any token transfer. This includes minting
1390      * and burning.
1391      *
1392      * Calling conditions:
1393      *
1394      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1395      * transferred to `to`.
1396      * - When `from` is zero, `tokenId` will be minted for `to`.
1397      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1398      * - `from` and `to` are never both zero.
1399      *
1400      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1401      */
1402     function _beforeTokenTransfer(
1403         address from,
1404         address to,
1405         uint256 tokenId
1406     ) internal virtual {}
1407 }
1408 
1409 // File: contracts/NonblockingReceiver.sol
1410 
1411 pragma solidity ^0.8.6;
1412 
1413 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1414     ILayerZeroEndpoint internal endpoint;
1415 
1416     struct FailedMessages {
1417         uint256 payloadLength;
1418         bytes32 payloadHash;
1419     }
1420 
1421     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1422         public failedMessages;
1423     mapping(uint16 => bytes) public trustedRemoteLookup;
1424 
1425     event MessageFailed(
1426         uint16 _srcChainId,
1427         bytes _srcAddress,
1428         uint64 _nonce,
1429         bytes _payload
1430     );
1431 
1432     function lzReceive(
1433         uint16 _srcChainId,
1434         bytes memory _srcAddress,
1435         uint64 _nonce,
1436         bytes memory _payload
1437     ) external override {
1438         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1439         require(
1440             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1441                 keccak256(_srcAddress) ==
1442                 keccak256(trustedRemoteLookup[_srcChainId]),
1443             "NonblockingReceiver: invalid source sending contract"
1444         );
1445 
1446         // try-catch all errors/exceptions
1447         // having failed messages does not block messages passing
1448         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1449             // do nothing
1450         } catch {
1451             // error / exception
1452             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1453                 _payload.length,
1454                 keccak256(_payload)
1455             );
1456             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1457         }
1458     }
1459 
1460     function onLzReceive(
1461         uint16 _srcChainId,
1462         bytes memory _srcAddress,
1463         uint64 _nonce,
1464         bytes memory _payload
1465     ) public {
1466         // only internal transaction
1467         require(
1468             msg.sender == address(this),
1469             "NonblockingReceiver: caller must be Bridge."
1470         );
1471 
1472         // handle incoming message
1473         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1474     }
1475 
1476     // abstract function
1477     function _LzReceive(
1478         uint16 _srcChainId,
1479         bytes memory _srcAddress,
1480         uint64 _nonce,
1481         bytes memory _payload
1482     ) internal virtual;
1483 
1484     function _lzSend(
1485         uint16 _dstChainId,
1486         bytes memory _payload,
1487         address payable _refundAddress,
1488         address _zroPaymentAddress,
1489         bytes memory _txParam
1490     ) internal {
1491         endpoint.send{value: msg.value}(
1492             _dstChainId,
1493             trustedRemoteLookup[_dstChainId],
1494             _payload,
1495             _refundAddress,
1496             _zroPaymentAddress,
1497             _txParam
1498         );
1499     }
1500 
1501     function retryMessage(
1502         uint16 _srcChainId,
1503         bytes memory _srcAddress,
1504         uint64 _nonce,
1505         bytes calldata _payload
1506     ) external payable {
1507         // assert there is message to retry
1508         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1509             _srcAddress
1510         ][_nonce];
1511         require(
1512             failedMsg.payloadHash != bytes32(0),
1513             "NonblockingReceiver: no stored message"
1514         );
1515         require(
1516             _payload.length == failedMsg.payloadLength &&
1517                 keccak256(_payload) == failedMsg.payloadHash,
1518             "LayerZero: invalid payload"
1519         );
1520         // clear the stored message
1521         failedMsg.payloadLength = 0;
1522         failedMsg.payloadHash = bytes32(0);
1523         // execute the message. revert if it fails again
1524         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1525     }
1526 
1527     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1528         external
1529         onlyOwner
1530     {
1531         trustedRemoteLookup[_chainId] = _trustedRemote;
1532     }
1533 }
1534 
1535 // File: contracts/tinydinos-eth.sol
1536 
1537 pragma solidity ^0.8.7;
1538 
1539 contract TinyDinos3D is Ownable, ERC721, NonblockingReceiver {
1540     address public _owner;
1541     string private baseURI;
1542     uint256 nextTokenId = 0;
1543     uint256 MAX_MINT_ETHEREUM = 6500;
1544 
1545     uint256 gasForDestinationLzReceive = 350000;
1546 
1547     constructor(string memory baseURI_, address _layerZeroEndpoint)
1548         ERC721("3D tiny dinos", "3D dinos")
1549     {
1550         _owner = msg.sender;
1551         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1552         baseURI = baseURI_;
1553     }
1554 
1555     // mint function
1556     // you can choose to mint 1 or 2
1557     // mint is free, but payments are accepted
1558     function mint(uint8 numTokens) external payable {
1559         require(numTokens < 3, "tiny dinos: Max 2 NFTs per transaction");
1560         require(
1561             nextTokenId + numTokens <= MAX_MINT_ETHEREUM,
1562             "tiny dinos: Mint exceeds supply"
1563         );
1564         _safeMint(msg.sender, ++nextTokenId);
1565         if (numTokens == 2) {
1566             _safeMint(msg.sender, ++nextTokenId);
1567         }
1568     }
1569 
1570     // This function transfers the nft from your address on the
1571     // source chain to the same address on the destination chain
1572     function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1573         require(
1574             msg.sender == ownerOf(tokenId),
1575             "You must own the token to traverse"
1576         );
1577         require(
1578             trustedRemoteLookup[_chainId].length > 0,
1579             "This chain is currently unavailable for travel"
1580         );
1581 
1582         // burn NFT, eliminating it from circulation on src chain
1583         _burn(tokenId);
1584 
1585         // abi.encode() the payload with the values to send
1586         bytes memory payload = abi.encode(msg.sender, tokenId);
1587 
1588         // encode adapterParams to specify more gas for the destination
1589         uint16 version = 1;
1590         bytes memory adapterParams = abi.encodePacked(
1591             version,
1592             gasForDestinationLzReceive
1593         );
1594 
1595         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1596         // you will be refunded for extra gas paid
1597         (uint256 messageFee, ) = endpoint.estimateFees(
1598             _chainId,
1599             address(this),
1600             payload,
1601             false,
1602             adapterParams
1603         );
1604 
1605         require(
1606             msg.value >= messageFee,
1607             "tiny dinos: msg.value not enough to cover messageFee. Send gas for message fees"
1608         );
1609 
1610         endpoint.send{value: msg.value}(
1611             _chainId, // destination chainId
1612             trustedRemoteLookup[_chainId], // destination address of nft contract
1613             payload, // abi.encoded()'ed bytes
1614             payable(msg.sender), // refund address
1615             address(0x0), // 'zroPaymentAddress' unused for this
1616             adapterParams // txParameters
1617         );
1618     }
1619 
1620     function setBaseURI(string memory URI) external onlyOwner {
1621         baseURI = URI;
1622     }
1623 
1624     function donate() external payable {
1625         // thank you
1626     }
1627 
1628     // This allows the devs to receive kind donations
1629     function withdraw(uint256 amt) external onlyOwner {
1630         (bool sent, ) = payable(_owner).call{value: amt}("");
1631         require(sent, "tiny dinos: Failed to withdraw Ether");
1632     }
1633 
1634     // just in case this fixed variable limits us from future integrations
1635     function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1636         gasForDestinationLzReceive = newVal;
1637     }
1638 
1639     // ------------------
1640     // Internal Functions
1641     // ------------------
1642 
1643     function _LzReceive(
1644         uint16 _srcChainId,
1645         bytes memory _srcAddress,
1646         uint64 _nonce,
1647         bytes memory _payload
1648     ) internal override {
1649         // decode
1650         (address toAddr, uint256 tokenId) = abi.decode(
1651             _payload,
1652             (address, uint256)
1653         );
1654 
1655         // mint the tokens back into existence on destination chain
1656         _safeMint(toAddr, tokenId);
1657     }
1658 
1659     function _baseURI() internal view override returns (string memory) {
1660         return baseURI;
1661     }
1662 }