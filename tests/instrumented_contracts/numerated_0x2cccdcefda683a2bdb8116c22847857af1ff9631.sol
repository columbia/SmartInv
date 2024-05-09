1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
8 
9 pragma solidity >=0.5.0;
10 
11 interface ILayerZeroUserApplicationConfig {
12     // @notice set the configuration of the LayerZero messaging library of the specified version
13     // @param _version - messaging library version
14     // @param _chainId - the chainId for the pending config change
15     // @param _configType - type of configuration. every messaging library has its own convention.
16     // @param _config - configuration in the bytes. can encode arbitrary content.
17     function setConfig(
18         uint16 _version,
19         uint16 _chainId,
20         uint256 _configType,
21         bytes calldata _config
22     ) external;
23 
24     // @notice set the send() LayerZero messaging library version to _version
25     // @param _version - new messaging library version
26     function setSendVersion(uint16 _version) external;
27 
28     // @notice set the lzReceive() LayerZero messaging library version to _version
29     // @param _version - new messaging library version
30     function setReceiveVersion(uint16 _version) external;
31 
32     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
33     // @param _srcChainId - the chainId of the source chain
34     // @param _srcAddress - the contract address of the source contract at the source chain
35     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
36         external;
37 }
38 
39 // File: contracts/interfaces/ILayerZeroEndpoint.sol
40 
41 pragma solidity >=0.5.0;
42 
43 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
44     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
45     // @param _dstChainId - the destination chain identifier
46     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
47     // @param _payload - a custom bytes payload to send to the destination contract
48     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
49     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
50     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
51     function send(
52         uint16 _dstChainId,
53         bytes calldata _destination,
54         bytes calldata _payload,
55         address payable _refundAddress,
56         address _zroPaymentAddress,
57         bytes calldata _adapterParams
58     ) external payable;
59 
60     // @notice used by the messaging library to publish verified payload
61     // @param _srcChainId - the source chain identifier
62     // @param _srcAddress - the source contract (as bytes) at the source chain
63     // @param _dstAddress - the address on destination chain
64     // @param _nonce - the unbound message ordering nonce
65     // @param _gasLimit - the gas limit for external contract execution
66     // @param _payload - verified payload to send to the destination contract
67     function receivePayload(
68         uint16 _srcChainId,
69         bytes calldata _srcAddress,
70         address _dstAddress,
71         uint64 _nonce,
72         uint256 _gasLimit,
73         bytes calldata _payload
74     ) external;
75 
76     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
77     // @param _srcChainId - the source chain identifier
78     // @param _srcAddress - the source chain contract address
79     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress)
80         external
81         view
82         returns (uint64);
83 
84     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
85     // @param _srcAddress - the source chain contract address
86     function getOutboundNonce(uint16 _dstChainId, address _srcAddress)
87         external
88         view
89         returns (uint64);
90 
91     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
92     // @param _dstChainId - the destination chain identifier
93     // @param _userApplication - the user app address on this EVM chain
94     // @param _payload - the custom message to send over LayerZero
95     // @param _payInZRO - if false, user app pays the protocol fee in native token
96     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
97     function estimateFees(
98         uint16 _dstChainId,
99         address _userApplication,
100         bytes calldata _payload,
101         bool _payInZRO,
102         bytes calldata _adapterParam
103     ) external view returns (uint256 nativeFee, uint256 zroFee);
104 
105     // @notice get this Endpoint's immutable source identifier
106     function getChainId() external view returns (uint16);
107 
108     // @notice the interface to retry failed message on this Endpoint destination
109     // @param _srcChainId - the source chain identifier
110     // @param _srcAddress - the source chain contract address
111     // @param _payload - the payload to be retried
112     function retryPayload(
113         uint16 _srcChainId,
114         bytes calldata _srcAddress,
115         bytes calldata _payload
116     ) external;
117 
118     // @notice query if any STORED payload (message blocking) at the endpoint.
119     // @param _srcChainId - the source chain identifier
120     // @param _srcAddress - the source chain contract address
121     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress)
122         external
123         view
124         returns (bool);
125 
126     // @notice query if the _libraryAddress is valid for sending msgs.
127     // @param _userApplication - the user app address on this EVM chain
128     function getSendLibraryAddress(address _userApplication)
129         external
130         view
131         returns (address);
132 
133     // @notice query if the _libraryAddress is valid for receiving msgs.
134     // @param _userApplication - the user app address on this EVM chain
135     function getReceiveLibraryAddress(address _userApplication)
136         external
137         view
138         returns (address);
139 
140     // @notice query if the non-reentrancy guard for send() is on
141     // @return true if the guard is on. false otherwise
142     function isSendingPayload() external view returns (bool);
143 
144     // @notice query if the non-reentrancy guard for receive() is on
145     // @return true if the guard is on. false otherwise
146     function isReceivingPayload() external view returns (bool);
147 
148     // @notice get the configuration of the LayerZero messaging library of the specified version
149     // @param _version - messaging library version
150     // @param _chainId - the chainId for the pending config change
151     // @param _userApplication - the contract address of the user application
152     // @param _configType - type of configuration. every messaging library has its own convention.
153     function getConfig(
154         uint16 _version,
155         uint16 _chainId,
156         address _userApplication,
157         uint256 _configType
158     ) external view returns (bytes memory);
159 
160     // @notice get the send() LayerZero messaging library version
161     // @param _userApplication - the contract address of the user application
162     function getSendVersion(address _userApplication)
163         external
164         view
165         returns (uint16);
166 
167     // @notice get the lzReceive() LayerZero messaging library version
168     // @param _userApplication - the contract address of the user application
169     function getReceiveVersion(address _userApplication)
170         external
171         view
172         returns (uint16);
173 }
174 
175 // File: contracts/interfaces/ILayerZeroReceiver.sol
176 
177 pragma solidity >=0.5.0;
178 
179 interface ILayerZeroReceiver {
180     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
181     // @param _srcChainId - the source endpoint identifier
182     // @param _srcAddress - the source sending contract address from the source chain
183     // @param _nonce - the ordered message nonce
184     // @param _payload - the signed payload is the UA bytes has encoded to be sent
185     function lzReceive(
186         uint16 _srcChainId,
187         bytes calldata _srcAddress,
188         uint64 _nonce,
189         bytes calldata _payload
190     ) external;
191 }
192 // File: @openzeppelin/contracts/utils/Strings.sol
193 
194 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev String operations.
200  */
201 library Strings {
202     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
203 
204     /**
205      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
206      */
207     function toString(uint256 value) internal pure returns (string memory) {
208         // Inspired by OraclizeAPI's implementation - MIT licence
209         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
210 
211         if (value == 0) {
212             return "0";
213         }
214         uint256 temp = value;
215         uint256 digits;
216         while (temp != 0) {
217             digits++;
218             temp /= 10;
219         }
220         bytes memory buffer = new bytes(digits);
221         while (value != 0) {
222             digits -= 1;
223             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
224             value /= 10;
225         }
226         return string(buffer);
227     }
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
231      */
232     function toHexString(uint256 value) internal pure returns (string memory) {
233         if (value == 0) {
234             return "0x00";
235         }
236         uint256 temp = value;
237         uint256 length = 0;
238         while (temp != 0) {
239             length++;
240             temp >>= 8;
241         }
242         return toHexString(value, length);
243     }
244 
245     /**
246      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
247      */
248     function toHexString(uint256 value, uint256 length)
249         internal
250         pure
251         returns (string memory)
252     {
253         bytes memory buffer = new bytes(2 * length + 2);
254         buffer[0] = "0";
255         buffer[1] = "x";
256         for (uint256 i = 2 * length + 1; i > 1; --i) {
257             buffer[i] = _HEX_SYMBOLS[value & 0xf];
258             value >>= 4;
259         }
260         require(value == 0, "Strings: hex length insufficient");
261         return string(buffer);
262     }
263 }
264 
265 // File: @openzeppelin/contracts/utils/Context.sol
266 
267 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 /**
272  * @dev Provides information about the current execution context, including the
273  * sender of the transaction and its data. While these are generally available
274  * via msg.sender and msg.data, they should not be accessed in such a direct
275  * manner, since when dealing with meta-transactions the account sending and
276  * paying for execution may not be the actual sender (as far as an application
277  * is concerned).
278  *
279  * This contract is only required for intermediate, library-like contracts.
280  */
281 abstract contract Context {
282     function _msgSender() internal view virtual returns (address) {
283         return msg.sender;
284     }
285 
286     function _msgData() internal view virtual returns (bytes calldata) {
287         return msg.data;
288     }
289 }
290 
291 // File: @openzeppelin/contracts/access/Ownable.sol
292 
293 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Contract module which provides a basic access control mechanism, where
299  * there is an account (an owner) that can be granted exclusive access to
300  * specific functions.
301  *
302  * By default, the owner account will be the one that deploys the contract. This
303  * can later be changed with {transferOwnership}.
304  *
305  * This module is used through inheritance. It will make available the modifier
306  * `onlyOwner`, which can be applied to your functions to restrict their use to
307  * the owner.
308  */
309 abstract contract Ownable is Context {
310     address private _owner;
311 
312     event OwnershipTransferred(
313         address indexed previousOwner,
314         address indexed newOwner
315     );
316 
317     /**
318      * @dev Initializes the contract setting the deployer as the initial owner.
319      */
320     constructor() {
321         _transferOwnership(_msgSender());
322     }
323 
324     /**
325      * @dev Returns the address of the current owner.
326      */
327     function owner() public view virtual returns (address) {
328         return _owner;
329     }
330 
331     /**
332      * @dev Throws if called by any account other than the owner.
333      */
334     modifier onlyOwner() {
335         require(owner() == _msgSender(), "Ownable: caller is not the owner");
336         _;
337     }
338 
339     /**
340      * @dev Leaves the contract without owner. It will not be possible to call
341      * `onlyOwner` functions anymore. Can only be called by the current owner.
342      *
343      * NOTE: Renouncing ownership will leave the contract without an owner,
344      * thereby removing any functionality that is only available to the owner.
345      */
346     function renounceOwnership() public virtual onlyOwner {
347         _transferOwnership(address(0));
348     }
349 
350     /**
351      * @dev Transfers ownership of the contract to a new account (`newOwner`).
352      * Can only be called by the current owner.
353      */
354     function transferOwnership(address newOwner) public virtual onlyOwner {
355         require(
356             newOwner != address(0),
357             "Ownable: new owner is the zero address"
358         );
359         _transferOwnership(newOwner);
360     }
361 
362     /**
363      * @dev Transfers ownership of the contract to a new account (`newOwner`).
364      * Internal function without access restriction.
365      */
366     function _transferOwnership(address newOwner) internal virtual {
367         address oldOwner = _owner;
368         _owner = newOwner;
369         emit OwnershipTransferred(oldOwner, newOwner);
370     }
371 }
372 
373 // File: @openzeppelin/contracts/utils/Address.sol
374 
375 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev Collection of functions related to the address type
381  */
382 library Address {
383     /**
384      * @dev Returns true if `account` is a contract.
385      *
386      * [IMPORTANT]
387      * ====
388      * It is unsafe to assume that an address for which this function returns
389      * false is an externally-owned account (EOA) and not a contract.
390      *
391      * Among others, `isContract` will return false for the following
392      * types of addresses:
393      *
394      *  - an externally-owned account
395      *  - a contract in construction
396      *  - an address where a contract will be created
397      *  - an address where a contract lived, but was destroyed
398      * ====
399      */
400     function isContract(address account) internal view returns (bool) {
401         // This method relies on extcodesize, which returns 0 for contracts in
402         // construction, since the code is only stored at the end of the
403         // constructor execution.
404 
405         uint256 size;
406         assembly {
407             size := extcodesize(account)
408         }
409         return size > 0;
410     }
411 
412     /**
413      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
414      * `recipient`, forwarding all available gas and reverting on errors.
415      *
416      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
417      * of certain opcodes, possibly making contracts go over the 2300 gas limit
418      * imposed by `transfer`, making them unable to receive funds via
419      * `transfer`. {sendValue} removes this limitation.
420      *
421      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
422      *
423      * IMPORTANT: because control is transferred to `recipient`, care must be
424      * taken to not create reentrancy vulnerabilities. Consider using
425      * {ReentrancyGuard} or the
426      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
427      */
428     function sendValue(address payable recipient, uint256 amount) internal {
429         require(
430             address(this).balance >= amount,
431             "Address: insufficient balance"
432         );
433 
434         (bool success, ) = recipient.call{value: amount}("");
435         require(
436             success,
437             "Address: unable to send value, recipient may have reverted"
438         );
439     }
440 
441     /**
442      * @dev Performs a Solidity function call using a low level `call`. A
443      * plain `call` is an unsafe replacement for a function call: use this
444      * function instead.
445      *
446      * If `target` reverts with a revert reason, it is bubbled up by this
447      * function (like regular Solidity function calls).
448      *
449      * Returns the raw returned data. To convert to the expected return value,
450      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
451      *
452      * Requirements:
453      *
454      * - `target` must be a contract.
455      * - calling `target` with `data` must not revert.
456      *
457      * _Available since v3.1._
458      */
459     function functionCall(address target, bytes memory data)
460         internal
461         returns (bytes memory)
462     {
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
496         return
497             functionCallWithValue(
498                 target,
499                 data,
500                 value,
501                 "Address: low-level call with value failed"
502             );
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
507      * with `errorMessage` as a fallback revert reason when `target` reverts.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(
512         address target,
513         bytes memory data,
514         uint256 value,
515         string memory errorMessage
516     ) internal returns (bytes memory) {
517         require(
518             address(this).balance >= value,
519             "Address: insufficient balance for call"
520         );
521         require(isContract(target), "Address: call to non-contract");
522 
523         (bool success, bytes memory returndata) = target.call{value: value}(
524             data
525         );
526         return verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
531      * but performing a static call.
532      *
533      * _Available since v3.3._
534      */
535     function functionStaticCall(address target, bytes memory data)
536         internal
537         view
538         returns (bytes memory)
539     {
540         return
541             functionStaticCall(
542                 target,
543                 data,
544                 "Address: low-level static call failed"
545             );
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal view returns (bytes memory) {
559         require(isContract(target), "Address: static call to non-contract");
560 
561         (bool success, bytes memory returndata) = target.staticcall(data);
562         return verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(address target, bytes memory data)
572         internal
573         returns (bytes memory)
574     {
575         return
576             functionDelegateCall(
577                 target,
578                 data,
579                 "Address: low-level delegate call failed"
580             );
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
585      * but performing a delegate call.
586      *
587      * _Available since v3.4._
588      */
589     function functionDelegateCall(
590         address target,
591         bytes memory data,
592         string memory errorMessage
593     ) internal returns (bytes memory) {
594         require(isContract(target), "Address: delegate call to non-contract");
595 
596         (bool success, bytes memory returndata) = target.delegatecall(data);
597         return verifyCallResult(success, returndata, errorMessage);
598     }
599 
600     /**
601      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
602      * revert reason using the provided one.
603      *
604      * _Available since v4.3._
605      */
606     function verifyCallResult(
607         bool success,
608         bytes memory returndata,
609         string memory errorMessage
610     ) internal pure returns (bytes memory) {
611         if (success) {
612             return returndata;
613         } else {
614             // Look for revert reason and bubble it up if present
615             if (returndata.length > 0) {
616                 // The easiest way to bubble the revert reason is using memory via assembly
617 
618                 assembly {
619                     let returndata_size := mload(returndata)
620                     revert(add(32, returndata), returndata_size)
621                 }
622             } else {
623                 revert(errorMessage);
624             }
625         }
626     }
627 }
628 
629 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
630 
631 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 /**
636  * @title ERC721 token receiver interface
637  * @dev Interface for any contract that wants to support safeTransfers
638  * from ERC721 asset contracts.
639  */
640 interface IERC721Receiver {
641     /**
642      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
643      * by `operator` from `from`, this function is called.
644      *
645      * It must return its Solidity selector to confirm the token transfer.
646      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
647      *
648      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
649      */
650     function onERC721Received(
651         address operator,
652         address from,
653         uint256 tokenId,
654         bytes calldata data
655     ) external returns (bytes4);
656 }
657 
658 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
659 
660 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @dev Interface of the ERC165 standard, as defined in the
666  * https://eips.ethereum.org/EIPS/eip-165[EIP].
667  *
668  * Implementers can declare support of contract interfaces, which can then be
669  * queried by others ({ERC165Checker}).
670  *
671  * For an implementation, see {ERC165}.
672  */
673 interface IERC165 {
674     /**
675      * @dev Returns true if this contract implements the interface defined by
676      * `interfaceId`. See the corresponding
677      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
678      * to learn more about how these ids are created.
679      *
680      * This function call must use less than 30 000 gas.
681      */
682     function supportsInterface(bytes4 interfaceId) external view returns (bool);
683 }
684 
685 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
686 
687 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 /**
692  * @dev Implementation of the {IERC165} interface.
693  *
694  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
695  * for the additional interface id that will be supported. For example:
696  *
697  * ```solidity
698  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
700  * }
701  * ```
702  *
703  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
704  */
705 abstract contract ERC165 is IERC165 {
706     /**
707      * @dev See {IERC165-supportsInterface}.
708      */
709     function supportsInterface(bytes4 interfaceId)
710         public
711         view
712         virtual
713         override
714         returns (bool)
715     {
716         return interfaceId == type(IERC165).interfaceId;
717     }
718 }
719 
720 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
721 
722 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 /**
727  * @dev Required interface of an ERC721 compliant contract.
728  */
729 interface IERC721 is IERC165 {
730     /**
731      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
732      */
733     event Transfer(
734         address indexed from,
735         address indexed to,
736         uint256 indexed tokenId
737     );
738 
739     /**
740      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
741      */
742     event Approval(
743         address indexed owner,
744         address indexed approved,
745         uint256 indexed tokenId
746     );
747 
748     /**
749      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
750      */
751     event ApprovalForAll(
752         address indexed owner,
753         address indexed operator,
754         bool approved
755     );
756 
757     /**
758      * @dev Returns the number of tokens in ``owner``'s account.
759      */
760     function balanceOf(address owner) external view returns (uint256 balance);
761 
762     /**
763      * @dev Returns the owner of the `tokenId` token.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must exist.
768      */
769     function ownerOf(uint256 tokenId) external view returns (address owner);
770 
771     /**
772      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
773      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
774      *
775      * Requirements:
776      *
777      * - `from` cannot be the zero address.
778      * - `to` cannot be the zero address.
779      * - `tokenId` token must exist and be owned by `from`.
780      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) external;
790 
791     /**
792      * @dev Transfers `tokenId` token from `from` to `to`.
793      *
794      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
795      *
796      * Requirements:
797      *
798      * - `from` cannot be the zero address.
799      * - `to` cannot be the zero address.
800      * - `tokenId` token must be owned by `from`.
801      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
802      *
803      * Emits a {Transfer} event.
804      */
805     function transferFrom(
806         address from,
807         address to,
808         uint256 tokenId
809     ) external;
810 
811     /**
812      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
813      * The approval is cleared when the token is transferred.
814      *
815      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
816      *
817      * Requirements:
818      *
819      * - The caller must own the token or be an approved operator.
820      * - `tokenId` must exist.
821      *
822      * Emits an {Approval} event.
823      */
824     function approve(address to, uint256 tokenId) external;
825 
826     /**
827      * @dev Returns the account approved for `tokenId` token.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must exist.
832      */
833     function getApproved(uint256 tokenId)
834         external
835         view
836         returns (address operator);
837 
838     /**
839      * @dev Approve or remove `operator` as an operator for the caller.
840      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
841      *
842      * Requirements:
843      *
844      * - The `operator` cannot be the caller.
845      *
846      * Emits an {ApprovalForAll} event.
847      */
848     function setApprovalForAll(address operator, bool _approved) external;
849 
850     /**
851      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
852      *
853      * See {setApprovalForAll}
854      */
855     function isApprovedForAll(address owner, address operator)
856         external
857         view
858         returns (bool);
859 
860     /**
861      * @dev Safely transfers `tokenId` token from `from` to `to`.
862      *
863      * Requirements:
864      *
865      * - `from` cannot be the zero address.
866      * - `to` cannot be the zero address.
867      * - `tokenId` token must exist and be owned by `from`.
868      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
869      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
870      *
871      * Emits a {Transfer} event.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId,
877         bytes calldata data
878     ) external;
879 }
880 
881 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
882 
883 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
884 
885 pragma solidity ^0.8.0;
886 
887 /**
888  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
889  * @dev See https://eips.ethereum.org/EIPS/eip-721
890  */
891 interface IERC721Metadata is IERC721 {
892     /**
893      * @dev Returns the token collection name.
894      */
895     function name() external view returns (string memory);
896 
897     /**
898      * @dev Returns the token collection symbol.
899      */
900     function symbol() external view returns (string memory);
901 
902     /**
903      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
904      */
905     function tokenURI(uint256 tokenId) external view returns (string memory);
906 }
907 
908 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
909 
910 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
911 
912 interface IERC721Enumerable is IERC721 {
913     /**
914      * @dev Returns the total amount of tokens stored by the contract.
915      */
916     function totalSupply() external view returns (uint256);
917 
918     /**
919      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
920      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
921      */
922     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
923 
924     /**
925      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
926      * Use along with {totalSupply} to enumerate all tokens.
927      */
928     function tokenByIndex(uint256 index) external view returns (uint256);
929 }
930 
931 pragma solidity ^0.8.0;
932 
933 /**
934  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
935  * the Metadata extension, but not including the Enumerable extension, which is available separately as
936  * {ERC721Enumerable}.
937  */
938 
939 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
940     using Address for address;
941     using Strings for uint256;
942 
943     struct TokenOwnership {
944         address addr;
945         uint64 startTimestamp;
946     }
947 
948     struct AddressData {
949         uint128 balance;
950         uint128 numberMinted;
951     }
952 
953     uint256 internal currentIndex = 0;
954 
955     uint256 internal immutable maxBatchSize;
956 
957     // Token name
958     string private _name;
959 
960     // Token symbol
961     string private _symbol;
962 
963     // Mapping from token ID to ownership details
964     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
965     mapping(uint256 => TokenOwnership) internal _ownerships;
966 
967     // Mapping owner address to address data
968     mapping(address => AddressData) private _addressData;
969 
970     // Mapping from token ID to approved address
971     mapping(uint256 => address) private _tokenApprovals;
972 
973     // Mapping from owner to operator approvals
974     mapping(address => mapping(address => bool)) private _operatorApprovals;
975 
976     /**
977      * @dev
978      * `maxBatchSize` refers to how much a minter can mint at a time.
979      */
980     constructor(
981         string memory name_,
982         string memory symbol_,
983         uint256 maxBatchSize_
984     ) {
985         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
986         _name = name_;
987         _symbol = symbol_;
988         maxBatchSize = maxBatchSize_;
989     }
990 
991     /**
992      * @dev See {IERC721Enumerable-totalSupply}.
993      */
994     function totalSupply() public view override returns (uint256) {
995         return currentIndex;
996     }
997 
998     /**
999      * @dev See {IERC721Enumerable-tokenByIndex}.
1000      */
1001     function tokenByIndex(uint256 index) public view override returns (uint256) {
1002         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1003         return index;
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1008      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1009      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1010      */
1011     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1012         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1013         uint256 numMintedSoFar = totalSupply();
1014         uint256 tokenIdsIdx = 0;
1015         address currOwnershipAddr = address(0);
1016         for (uint256 i = 0; i < numMintedSoFar; i++) {
1017             TokenOwnership memory ownership = _ownerships[i];
1018             if (ownership.addr != address(0)) {
1019                 currOwnershipAddr = ownership.addr;
1020             }
1021             if (currOwnershipAddr == owner) {
1022                 if (tokenIdsIdx == index) {
1023                     return i;
1024                 }
1025                 tokenIdsIdx++;
1026             }
1027         }
1028         revert('ERC721A: unable to get token of owner by index');
1029     }
1030 
1031     /**
1032      * @dev See {IERC165-supportsInterface}.
1033      */
1034     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1035         return
1036             interfaceId == type(IERC721).interfaceId ||
1037             interfaceId == type(IERC721Metadata).interfaceId ||
1038             interfaceId == type(IERC721Enumerable).interfaceId ||
1039             super.supportsInterface(interfaceId);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-balanceOf}.
1044      */
1045     function balanceOf(address owner) public view override returns (uint256) {
1046         require(owner != address(0), 'ERC721A: balance query for the zero address');
1047         return uint256(_addressData[owner].balance);
1048     }
1049 
1050     function _numberMinted(address owner) internal view returns (uint256) {
1051         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1052         return uint256(_addressData[owner].numberMinted);
1053     }
1054 
1055     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1056         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1057 
1058         uint256 lowestTokenToCheck;
1059         if (tokenId >= maxBatchSize) {
1060             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1061         }
1062 
1063         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1064             TokenOwnership memory ownership = _ownerships[curr];
1065             if (ownership.addr != address(0)) {
1066                 return ownership;
1067             }
1068         }
1069 
1070         revert('ERC721A: unable to determine the owner of token');
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-ownerOf}.
1075      */
1076     function ownerOf(uint256 tokenId) public view override returns (address) {
1077         return ownershipOf(tokenId).addr;
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Metadata-name}.
1082      */
1083     function name() public view virtual override returns (string memory) {
1084         return _name;
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Metadata-symbol}.
1089      */
1090     function symbol() public view virtual override returns (string memory) {
1091         return _symbol;
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Metadata-tokenURI}.
1096      */
1097     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1098         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1099 
1100         string memory baseURI = _baseURI();
1101         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1102     }
1103 
1104     /**
1105      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1106      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1107      * by default, can be overriden in child contracts.
1108      */
1109     function _baseURI() internal view virtual returns (string memory) {
1110         return '';
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-approve}.
1115      */
1116     function approve(address to, uint256 tokenId) public override {
1117         address owner = ERC721A.ownerOf(tokenId);
1118         require(to != owner, 'ERC721A: approval to current owner');
1119 
1120         require(
1121             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1122             'ERC721A: approve caller is not owner nor approved for all'
1123         );
1124 
1125         _approve(to, tokenId, owner);
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-getApproved}.
1130      */
1131     function getApproved(uint256 tokenId) public view override returns (address) {
1132         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1133 
1134         return _tokenApprovals[tokenId];
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-setApprovalForAll}.
1139      */
1140     function setApprovalForAll(address operator, bool approved) public override {
1141         require(operator != _msgSender(), 'ERC721A: approve to caller');
1142 
1143         _operatorApprovals[_msgSender()][operator] = approved;
1144         emit ApprovalForAll(_msgSender(), operator, approved);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-isApprovedForAll}.
1149      */
1150     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1151         return _operatorApprovals[owner][operator];
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-transferFrom}.
1156      */
1157     function transferFrom(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) public override {
1162         _transfer(from, to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-safeTransferFrom}.
1167      */
1168     function safeTransferFrom(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) public override {
1173         safeTransferFrom(from, to, tokenId, '');
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-safeTransferFrom}.
1178      */
1179     function safeTransferFrom(
1180         address from,
1181         address to,
1182         uint256 tokenId,
1183         bytes memory _data
1184     ) public override {
1185         _transfer(from, to, tokenId);
1186         require(
1187             _checkOnERC721Received(from, to, tokenId, _data),
1188             'ERC721A: transfer to non ERC721Receiver implementer'
1189         );
1190     }
1191 
1192     /**
1193      * @dev Returns whether `tokenId` exists.
1194      *
1195      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1196      *
1197      * Tokens start existing when they are minted (`_mint`),
1198      */
1199     function _exists(uint256 tokenId) internal view returns (bool) {
1200         return tokenId < currentIndex;
1201     }
1202 
1203     function _safeMint(address to, uint256 quantity) internal {
1204         _safeMint(to, quantity, '');
1205     }
1206 
1207     /**
1208      * @dev Mints `quantity` tokens and transfers them to `to`.
1209      *
1210      * Requirements:
1211      *
1212      * - `to` cannot be the zero address.
1213      * - `quantity` cannot be larger than the max batch size.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _safeMint(
1218         address to,
1219         uint256 quantity,
1220         bytes memory _data
1221     ) internal {
1222         uint256 startTokenId = currentIndex;
1223         require(to != address(0), 'ERC721A: mint to the zero address');
1224         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1225         require(!_exists(startTokenId), 'ERC721A: token already minted');
1226         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1227         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1228 
1229         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1230 
1231         AddressData memory addressData = _addressData[to];
1232         _addressData[to] = AddressData(
1233             addressData.balance + uint128(quantity),
1234             addressData.numberMinted + uint128(quantity)
1235         );
1236         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1237 
1238         uint256 updatedIndex = startTokenId;
1239 
1240         for (uint256 i = 0; i < quantity; i++) {
1241             emit Transfer(address(0), to, updatedIndex);
1242             require(
1243                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1244                 'ERC721A: transfer to non ERC721Receiver implementer'
1245             );
1246             updatedIndex++;
1247         }
1248 
1249         currentIndex = updatedIndex;
1250         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1251     }
1252 
1253     /**
1254      * @dev Transfers `tokenId` from `from` to `to`.
1255      *
1256      * Requirements:
1257      *
1258      * - `to` cannot be the zero address.
1259      * - `tokenId` token must be owned by `from`.
1260      *
1261      * Emits a {Transfer} event.
1262      */
1263     function _transfer(
1264         address from,
1265         address to,
1266         uint256 tokenId
1267     ) private {
1268         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1269 
1270         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1271             getApproved(tokenId) == _msgSender() ||
1272             isApprovedForAll(prevOwnership.addr, _msgSender()));
1273 
1274         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1275 
1276         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1277         require(to != address(0), 'ERC721A: transfer to the zero address');
1278 
1279         _beforeTokenTransfers(from, to, tokenId, 1);
1280 
1281         // Clear approvals from the previous owner
1282         _approve(address(0), tokenId, prevOwnership.addr);
1283 
1284         // Underflow of the sender's balance is impossible because we check for
1285         // ownership above and the recipient's balance can't realistically overflow.
1286         unchecked {
1287             _addressData[from].balance -= 1;
1288             _addressData[to].balance += 1;
1289         }
1290 
1291         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1292 
1293         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1294         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1295         uint256 nextTokenId = tokenId + 1;
1296         if (_ownerships[nextTokenId].addr == address(0)) {
1297             if (_exists(nextTokenId)) {
1298                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1299             }
1300         }
1301 
1302         emit Transfer(from, to, tokenId);
1303         _afterTokenTransfers(from, to, tokenId, 1);
1304     }
1305 
1306     /**
1307      * @dev Approve `to` to operate on `tokenId`
1308      *
1309      * Emits a {Approval} event.
1310      */
1311     function _approve(
1312         address to,
1313         uint256 tokenId,
1314         address owner
1315     ) private {
1316         _tokenApprovals[tokenId] = to;
1317         emit Approval(owner, to, tokenId);
1318     }
1319 
1320     /**
1321      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1322      * The call is not executed if the target address is not a contract.
1323      *
1324      * @param from address representing the previous owner of the given token ID
1325      * @param to target address that will receive the tokens
1326      * @param tokenId uint256 ID of the token to be transferred
1327      * @param _data bytes optional data to send along with the call
1328      * @return bool whether the call correctly returned the expected magic value
1329      */
1330     function _checkOnERC721Received(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) private returns (bool) {
1336         if (to.isContract()) {
1337             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1338                 return retval == IERC721Receiver(to).onERC721Received.selector;
1339             } catch (bytes memory reason) {
1340                 if (reason.length == 0) {
1341                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1342                 } else {
1343                     assembly {
1344                         revert(add(32, reason), mload(reason))
1345                     }
1346                 }
1347             }
1348         } else {
1349             return true;
1350         }
1351     }
1352 
1353     /**
1354      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1355      *
1356      * startTokenId - the first token id to be transferred
1357      * quantity - the amount to be transferred
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` will be minted for `to`.
1364      */
1365     function _beforeTokenTransfers(
1366         address from,
1367         address to,
1368         uint256 startTokenId,
1369         uint256 quantity
1370     ) internal virtual {}
1371 
1372     /**
1373      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1374      * minting.
1375      *
1376      * startTokenId - the first token id to be transferred
1377      * quantity - the amount to be transferred
1378      *
1379      * Calling conditions:
1380      *
1381      * - when `from` and `to` are both non-zero.
1382      * - `from` and `to` are never both zero.
1383      */
1384     function _afterTokenTransfers(
1385         address from,
1386         address to,
1387         uint256 startTokenId,
1388         uint256 quantity
1389     ) internal virtual {}
1390 }
1391 
1392 // File: contracts/NonblockingReceiver.sol
1393 
1394 pragma solidity ^0.8.6;
1395 
1396 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1397     ILayerZeroEndpoint internal endpoint;
1398 
1399     struct FailedMessages {
1400         uint256 payloadLength;
1401         bytes32 payloadHash;
1402     }
1403 
1404     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1405         public failedMessages;
1406     mapping(uint16 => bytes) public trustedRemoteLookup;
1407 
1408     event MessageFailed(
1409         uint16 _srcChainId,
1410         bytes _srcAddress,
1411         uint64 _nonce,
1412         bytes _payload
1413     );
1414 
1415     function lzReceive(
1416         uint16 _srcChainId,
1417         bytes memory _srcAddress,
1418         uint64 _nonce,
1419         bytes memory _payload
1420     ) external override {
1421         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1422         require(
1423             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1424                 keccak256(_srcAddress) ==
1425                 keccak256(trustedRemoteLookup[_srcChainId]),
1426             "NonblockingReceiver: invalid source sending contract"
1427         );
1428 
1429         // try-catch all errors/exceptions
1430         // having failed messages does not block messages passing
1431         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1432             // do nothing
1433         } catch {
1434             // error / exception
1435             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1436                 _payload.length,
1437                 keccak256(_payload)
1438             );
1439             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1440         }
1441     }
1442 
1443     function onLzReceive(
1444         uint16 _srcChainId,
1445         bytes memory _srcAddress,
1446         uint64 _nonce,
1447         bytes memory _payload
1448     ) public {
1449         // only internal transaction
1450         require(
1451             msg.sender == address(this),
1452             "NonblockingReceiver: caller must be Bridge."
1453         );
1454 
1455         // handle incoming message
1456         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1457     }
1458 
1459     // abstract function
1460     function _LzReceive(
1461         uint16 _srcChainId,
1462         bytes memory _srcAddress,
1463         uint64 _nonce,
1464         bytes memory _payload
1465     ) internal virtual;
1466 
1467     function _lzSend(
1468         uint16 _dstChainId,
1469         bytes memory _payload,
1470         address payable _refundAddress,
1471         address _zroPaymentAddress,
1472         bytes memory _txParam
1473     ) internal {
1474         endpoint.send{value: msg.value}(
1475             _dstChainId,
1476             trustedRemoteLookup[_dstChainId],
1477             _payload,
1478             _refundAddress,
1479             _zroPaymentAddress,
1480             _txParam
1481         );
1482     }
1483 
1484     function retryMessage(
1485         uint16 _srcChainId,
1486         bytes memory _srcAddress,
1487         uint64 _nonce,
1488         bytes calldata _payload
1489     ) external payable {
1490         // assert there is message to retry
1491         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1492             _srcAddress
1493         ][_nonce];
1494         require(
1495             failedMsg.payloadHash != bytes32(0),
1496             "NonblockingReceiver: no stored message"
1497         );
1498         require(
1499             _payload.length == failedMsg.payloadLength &&
1500                 keccak256(_payload) == failedMsg.payloadHash,
1501             "LayerZero: invalid payload"
1502         );
1503         // clear the stored message
1504         failedMsg.payloadLength = 0;
1505         failedMsg.payloadHash = bytes32(0);
1506         // execute the message. revert if it fails again
1507         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1508     }
1509 
1510     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1511         external
1512         onlyOwner
1513     {
1514         trustedRemoteLookup[_chainId] = _trustedRemote;
1515     }
1516 }
1517 
1518 pragma solidity ^0.8.7;
1519 
1520 contract omnipunks is ERC721A, Ownable {
1521   using Strings for uint256;
1522 
1523   string private uriPrefix = "";
1524   string private uriSuffix = ".json";
1525   string public hiddenMetadataUri;
1526   
1527   uint256 public price = 0 ether; 
1528   uint256 public maxSupply = 1999; 
1529   uint256 public maxMintAmountPerTx = 2; 
1530   
1531   bool public paused = true;
1532   bool public revealed = false;
1533   mapping(address => uint256) public addressMintedBalance;
1534 
1535 
1536   constructor() ERC721A("omni punks", "0xpunks", maxMintAmountPerTx) {
1537     setHiddenMetadataUri("ipfs://QmNzQZoH7sN9VtpsViR7TXwzkLydR53QkrpvfBcgJqhx3j");
1538   }
1539 
1540   modifier mintCompliance(uint256 _mintAmount) {
1541     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1542     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1543     _;
1544   }
1545 
1546   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1547    {
1548     require(!paused, "The contract is paused!");
1549     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1550     
1551     
1552     _safeMint(msg.sender, _mintAmount);
1553   }
1554  
1555   function walletOfOwner(address _owner)
1556     public
1557     view
1558     returns (uint256[] memory)
1559   {
1560     uint256 ownerTokenCount = balanceOf(_owner);
1561     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1562     uint256 currentTokenId = 0;
1563     uint256 ownedTokenIndex = 0;
1564 
1565     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1566       address currentTokenOwner = ownerOf(currentTokenId);
1567 
1568       if (currentTokenOwner == _owner) {
1569         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1570 
1571         ownedTokenIndex++;
1572       }
1573 
1574       currentTokenId++;
1575     }
1576 
1577     return ownedTokenIds;
1578   }
1579 
1580   function tokenURI(uint256 _tokenId)
1581     public
1582     view
1583     virtual
1584     override
1585     returns (string memory)
1586   {
1587     require(
1588       _exists(_tokenId),
1589       "ERC721Metadata: URI query for nonexistent token"
1590     );
1591 
1592     if (revealed == false) {
1593       return hiddenMetadataUri;
1594     }
1595 
1596     string memory currentBaseURI = _baseURI();
1597     return bytes(currentBaseURI).length > 0
1598         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1599         : "";
1600   }
1601 
1602   function setRevealed(bool _state) public onlyOwner {
1603     revealed = _state;
1604   
1605   }
1606 
1607   function setPrice(uint256 _price) public onlyOwner {
1608     price = _price;
1609 
1610   }
1611  
1612   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1613     hiddenMetadataUri = _hiddenMetadataUri;
1614   }
1615 
1616 
1617 
1618   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1619     uriPrefix = _uriPrefix;
1620   }
1621 
1622   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1623     uriSuffix = _uriSuffix;
1624   }
1625 
1626   function setPaused(bool _state) public onlyOwner {
1627     paused = _state;
1628   }
1629 
1630   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1631       _safeMint(_receiver, _mintAmount);
1632   }
1633 
1634   function _baseURI() internal view virtual override returns (string memory) {
1635     return uriPrefix;
1636     
1637   }
1638 
1639     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1640     maxMintAmountPerTx = _maxMintAmountPerTx;
1641 
1642   }
1643 
1644     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1645     maxSupply = _maxSupply;
1646 
1647   }
1648 
1649 
1650   // withdrawall addresses
1651   address t1 = 0x8e308ee8394BC2095d2d64aF56dBFB92Dc605999; 
1652   
1653 
1654   function withdrawall() public onlyOwner {
1655         uint256 _balance = address(this).balance;
1656         
1657         require(payable(t1).send(_balance * 100 / 100 ));
1658         
1659     }
1660 
1661   function withdraw() public onlyOwner {
1662     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1663     require(os);
1664     
1665 
1666  
1667   }
1668 }