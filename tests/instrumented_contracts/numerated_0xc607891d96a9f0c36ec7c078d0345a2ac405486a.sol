1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-12
3  */
4 
5 // SPDX-License-Identifier: GPL-3.0
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
912 pragma solidity ^0.8.0;
913 
914 /**
915  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
916  * the Metadata extension, but not including the Enumerable extension, which is available separately as
917  * {ERC721Enumerable}.
918  */
919 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
920     using Address for address;
921     using Strings for uint256;
922 
923     // Token name
924     string private _name;
925 
926     // Token symbol
927     string private _symbol;
928 
929     // Mapping from token ID to owner address
930     mapping(uint256 => address) private _owners;
931 
932     // Mapping owner address to token count
933     mapping(address => uint256) private _balances;
934 
935     // Mapping from token ID to approved address
936     mapping(uint256 => address) private _tokenApprovals;
937 
938     // Mapping from owner to operator approvals
939     mapping(address => mapping(address => bool)) private _operatorApprovals;
940 
941     /**
942      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
943      */
944     constructor(string memory name_, string memory symbol_) {
945         _name = name_;
946         _symbol = symbol_;
947     }
948 
949     /**
950      * @dev See {IERC165-supportsInterface}.
951      */
952     function supportsInterface(bytes4 interfaceId)
953         public
954         view
955         virtual
956         override(ERC165, IERC165)
957         returns (bool)
958     {
959         return
960             interfaceId == type(IERC721).interfaceId ||
961             interfaceId == type(IERC721Metadata).interfaceId ||
962             super.supportsInterface(interfaceId);
963     }
964 
965     /**
966      * @dev See {IERC721-balanceOf}.
967      */
968     function balanceOf(address owner)
969         public
970         view
971         virtual
972         override
973         returns (uint256)
974     {
975         require(
976             owner != address(0),
977             "ERC721: balance query for the zero address"
978         );
979         return _balances[owner];
980     }
981 
982     /**
983      * @dev See {IERC721-ownerOf}.
984      */
985     function ownerOf(uint256 tokenId)
986         public
987         view
988         virtual
989         override
990         returns (address)
991     {
992         address owner = _owners[tokenId];
993         require(
994             owner != address(0),
995             "ERC721: owner query for nonexistent token"
996         );
997         return owner;
998     }
999 
1000     /**
1001      * @dev See {IERC721Metadata-name}.
1002      */
1003     function name() public view virtual override returns (string memory) {
1004         return _name;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Metadata-symbol}.
1009      */
1010     function symbol() public view virtual override returns (string memory) {
1011         return _symbol;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Metadata-tokenURI}.
1016      */
1017     function tokenURI(uint256 tokenId)
1018         public
1019         view
1020         virtual
1021         override
1022         returns (string memory)
1023     {
1024         require(
1025             _exists(tokenId),
1026             "ERC721Metadata: URI query for nonexistent token"
1027         );
1028 
1029         string memory baseURI = _baseURI();
1030         return
1031             bytes(baseURI).length > 0
1032                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1033                 : "";
1034     }
1035 
1036     /**
1037      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1038      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1039      * by default, can be overriden in child contracts.
1040      */
1041     function _baseURI() internal view virtual returns (string memory) {
1042         return "";
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-approve}.
1047      */
1048     function approve(address to, uint256 tokenId) public virtual override {
1049         address owner = ERC721.ownerOf(tokenId);
1050         require(to != owner, "ERC721: approval to current owner");
1051 
1052         require(
1053             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1054             "ERC721: approve caller is not owner nor approved for all"
1055         );
1056 
1057         _approve(to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-getApproved}.
1062      */
1063     function getApproved(uint256 tokenId)
1064         public
1065         view
1066         virtual
1067         override
1068         returns (address)
1069     {
1070         require(
1071             _exists(tokenId),
1072             "ERC721: approved query for nonexistent token"
1073         );
1074 
1075         return _tokenApprovals[tokenId];
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-setApprovalForAll}.
1080      */
1081     function setApprovalForAll(address operator, bool approved)
1082         public
1083         virtual
1084         override
1085     {
1086         _setApprovalForAll(_msgSender(), operator, approved);
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-isApprovedForAll}.
1091      */
1092     function isApprovedForAll(address owner, address operator)
1093         public
1094         view
1095         virtual
1096         override
1097         returns (bool)
1098     {
1099         return _operatorApprovals[owner][operator];
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-transferFrom}.
1104      */
1105     function transferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) public virtual override {
1110         //solhint-disable-next-line max-line-length
1111         require(
1112             _isApprovedOrOwner(_msgSender(), tokenId),
1113             "ERC721: transfer caller is not owner nor approved"
1114         );
1115 
1116         _transfer(from, to, tokenId);
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-safeTransferFrom}.
1121      */
1122     function safeTransferFrom(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) public virtual override {
1127         safeTransferFrom(from, to, tokenId, "");
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-safeTransferFrom}.
1132      */
1133     function safeTransferFrom(
1134         address from,
1135         address to,
1136         uint256 tokenId,
1137         bytes memory _data
1138     ) public virtual override {
1139         require(
1140             _isApprovedOrOwner(_msgSender(), tokenId),
1141             "ERC721: transfer caller is not owner nor approved"
1142         );
1143         _safeTransfer(from, to, tokenId, _data);
1144     }
1145 
1146     /**
1147      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1148      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1149      *
1150      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1151      *
1152      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1153      * implement alternative mechanisms to perform token transfer, such as signature-based.
1154      *
1155      * Requirements:
1156      *
1157      * - `from` cannot be the zero address.
1158      * - `to` cannot be the zero address.
1159      * - `tokenId` token must exist and be owned by `from`.
1160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _safeTransfer(
1165         address from,
1166         address to,
1167         uint256 tokenId,
1168         bytes memory _data
1169     ) internal virtual {
1170         _transfer(from, to, tokenId);
1171         require(
1172             _checkOnERC721Received(from, to, tokenId, _data),
1173             "ERC721: transfer to non ERC721Receiver implementer"
1174         );
1175     }
1176 
1177     /**
1178      * @dev Returns whether `tokenId` exists.
1179      *
1180      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1181      *
1182      * Tokens start existing when they are minted (`_mint`),
1183      * and stop existing when they are burned (`_burn`).
1184      */
1185     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1186         return _owners[tokenId] != address(0);
1187     }
1188 
1189     /**
1190      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1191      *
1192      * Requirements:
1193      *
1194      * - `tokenId` must exist.
1195      */
1196     function _isApprovedOrOwner(address spender, uint256 tokenId)
1197         internal
1198         view
1199         virtual
1200         returns (bool)
1201     {
1202         require(
1203             _exists(tokenId),
1204             "ERC721: operator query for nonexistent token"
1205         );
1206         address owner = ERC721.ownerOf(tokenId);
1207         return (spender == owner ||
1208             getApproved(tokenId) == spender ||
1209             isApprovedForAll(owner, spender));
1210     }
1211 
1212     /**
1213      * @dev Safely mints `tokenId` and transfers it to `to`.
1214      *
1215      * Requirements:
1216      *
1217      * - `tokenId` must not exist.
1218      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _safeMint(address to, uint256 tokenId) internal virtual {
1223         _safeMint(to, tokenId, "");
1224     }
1225 
1226     /**
1227      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1228      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1229      */
1230     function _safeMint(
1231         address to,
1232         uint256 tokenId,
1233         bytes memory _data
1234     ) internal virtual {
1235         _mint(to, tokenId);
1236         require(
1237             _checkOnERC721Received(address(0), to, tokenId, _data),
1238             "ERC721: transfer to non ERC721Receiver implementer"
1239         );
1240     }
1241 
1242     /**
1243      * @dev Mints `tokenId` and transfers it to `to`.
1244      *
1245      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must not exist.
1250      * - `to` cannot be the zero address.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _mint(address to, uint256 tokenId) internal virtual {
1255         require(to != address(0), "ERC721: mint to the zero address");
1256 
1257         _beforeTokenTransfer(address(0), to, tokenId);
1258 
1259         _balances[to] += 1;
1260         _owners[tokenId] = to;
1261 
1262         emit Transfer(address(0), to, tokenId);
1263     }
1264 
1265     /**
1266      * @dev Destroys `tokenId`.
1267      * The approval is cleared when the token is burned.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function _burn(uint256 tokenId) internal virtual {
1276         address owner = ERC721.ownerOf(tokenId);
1277 
1278         _beforeTokenTransfer(owner, address(0), tokenId);
1279 
1280         // Clear approvals
1281         _approve(address(0), tokenId);
1282 
1283         _balances[owner] -= 1;
1284         delete _owners[tokenId];
1285 
1286         emit Transfer(owner, address(0), tokenId);
1287     }
1288 
1289     /**
1290      * @dev Transfers `tokenId` from `from` to `to`.
1291      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1292      *
1293      * Requirements:
1294      *
1295      * - `to` cannot be the zero address.
1296      * - `tokenId` token must be owned by `from`.
1297      *
1298      * Emits a {Transfer} event.
1299      */
1300     function _transfer(
1301         address from,
1302         address to,
1303         uint256 tokenId
1304     ) internal virtual {
1305         require(
1306             ERC721.ownerOf(tokenId) == from,
1307             "ERC721: transfer of token that is not own"
1308         );
1309         require(to != address(0), "ERC721: transfer to the zero address");
1310 
1311         _beforeTokenTransfer(from, to, tokenId);
1312 
1313         // Clear approvals from the previous owner
1314         _approve(address(0), tokenId);
1315 
1316         _balances[from] -= 1;
1317         _balances[to] += 1;
1318         _owners[tokenId] = to;
1319 
1320         emit Transfer(from, to, tokenId);
1321     }
1322 
1323     /**
1324      * @dev Approve `to` to operate on `tokenId`
1325      *
1326      * Emits a {Approval} event.
1327      */
1328     function _approve(address to, uint256 tokenId) internal virtual {
1329         _tokenApprovals[tokenId] = to;
1330         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1331     }
1332 
1333     /**
1334      * @dev Approve `operator` to operate on all of `owner` tokens
1335      *
1336      * Emits a {ApprovalForAll} event.
1337      */
1338     function _setApprovalForAll(
1339         address owner,
1340         address operator,
1341         bool approved
1342     ) internal virtual {
1343         require(owner != operator, "ERC721: approve to caller");
1344         _operatorApprovals[owner][operator] = approved;
1345         emit ApprovalForAll(owner, operator, approved);
1346     }
1347 
1348     /**
1349      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1350      * The call is not executed if the target address is not a contract.
1351      *
1352      * @param from address representing the previous owner of the given token ID
1353      * @param to target address that will receive the tokens
1354      * @param tokenId uint256 ID of the token to be transferred
1355      * @param _data bytes optional data to send along with the call
1356      * @return bool whether the call correctly returned the expected magic value
1357      */
1358     function _checkOnERC721Received(
1359         address from,
1360         address to,
1361         uint256 tokenId,
1362         bytes memory _data
1363     ) private returns (bool) {
1364         if (to.isContract()) {
1365             try
1366                 IERC721Receiver(to).onERC721Received(
1367                     _msgSender(),
1368                     from,
1369                     tokenId,
1370                     _data
1371                 )
1372             returns (bytes4 retval) {
1373                 return retval == IERC721Receiver.onERC721Received.selector;
1374             } catch (bytes memory reason) {
1375                 if (reason.length == 0) {
1376                     revert(
1377                         "ERC721: transfer to non ERC721Receiver implementer"
1378                     );
1379                 } else {
1380                     assembly {
1381                         revert(add(32, reason), mload(reason))
1382                     }
1383                 }
1384             }
1385         } else {
1386             return true;
1387         }
1388     }
1389 
1390     /**
1391      * @dev Hook that is called before any token transfer. This includes minting
1392      * and burning.
1393      *
1394      * Calling conditions:
1395      *
1396      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1397      * transferred to `to`.
1398      * - When `from` is zero, `tokenId` will be minted for `to`.
1399      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1400      * - `from` and `to` are never both zero.
1401      *
1402      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1403      */
1404     function _beforeTokenTransfer(
1405         address from,
1406         address to,
1407         uint256 tokenId
1408     ) internal virtual {}
1409 }
1410 
1411 // File: contracts/NonblockingReceiver.sol
1412 
1413 pragma solidity ^0.8.6;
1414 
1415 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1416     ILayerZeroEndpoint internal endpoint;
1417 
1418     struct FailedMessages {
1419         uint256 payloadLength;
1420         bytes32 payloadHash;
1421     }
1422 
1423     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1424         public failedMessages;
1425     mapping(uint16 => bytes) public trustedRemoteLookup;
1426 
1427     event MessageFailed(
1428         uint16 _srcChainId,
1429         bytes _srcAddress,
1430         uint64 _nonce,
1431         bytes _payload
1432     );
1433 
1434     function lzReceive(
1435         uint16 _srcChainId,
1436         bytes memory _srcAddress,
1437         uint64 _nonce,
1438         bytes memory _payload
1439     ) external override {
1440         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1441         require(
1442             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1443                 keccak256(_srcAddress) ==
1444                 keccak256(trustedRemoteLookup[_srcChainId]),
1445             "NonblockingReceiver: invalid source sending contract"
1446         );
1447 
1448         // try-catch all errors/exceptions
1449         // having failed messages does not block messages passing
1450         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1451             // do nothing
1452         } catch {
1453             // error / exception
1454             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1455                 _payload.length,
1456                 keccak256(_payload)
1457             );
1458             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1459         }
1460     }
1461 
1462     function onLzReceive(
1463         uint16 _srcChainId,
1464         bytes memory _srcAddress,
1465         uint64 _nonce,
1466         bytes memory _payload
1467     ) public {
1468         // only internal transaction
1469         require(
1470             msg.sender == address(this),
1471             "NonblockingReceiver: caller must be Bridge."
1472         );
1473 
1474         // handle incoming message
1475         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1476     }
1477 
1478     // abstract function
1479     function _LzReceive(
1480         uint16 _srcChainId,
1481         bytes memory _srcAddress,
1482         uint64 _nonce,
1483         bytes memory _payload
1484     ) internal virtual;
1485 
1486     function _lzSend(
1487         uint16 _dstChainId,
1488         bytes memory _payload,
1489         address payable _refundAddress,
1490         address _zroPaymentAddress,
1491         bytes memory _txParam
1492     ) internal {
1493         endpoint.send{value: msg.value}(
1494             _dstChainId,
1495             trustedRemoteLookup[_dstChainId],
1496             _payload,
1497             _refundAddress,
1498             _zroPaymentAddress,
1499             _txParam
1500         );
1501     }
1502 
1503     function retryMessage(
1504         uint16 _srcChainId,
1505         bytes memory _srcAddress,
1506         uint64 _nonce,
1507         bytes calldata _payload
1508     ) external payable {
1509         // assert there is message to retry
1510         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1511             _srcAddress
1512         ][_nonce];
1513         require(
1514             failedMsg.payloadHash != bytes32(0),
1515             "NonblockingReceiver: no stored message"
1516         );
1517         require(
1518             _payload.length == failedMsg.payloadLength &&
1519                 keccak256(_payload) == failedMsg.payloadHash,
1520             "LayerZero: invalid payload"
1521         );
1522         // clear the stored message
1523         failedMsg.payloadLength = 0;
1524         failedMsg.payloadHash = bytes32(0);
1525         // execute the message. revert if it fails again
1526         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1527     }
1528 
1529     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1530         external
1531         onlyOwner
1532     {
1533         trustedRemoteLookup[_chainId] = _trustedRemote;
1534     }
1535 }
1536 
1537 pragma solidity ^0.8.7;
1538 
1539 contract BitBotFriends is Ownable, ERC721, NonblockingReceiver {
1540     using Strings for uint256;
1541 
1542     string public baseExtension = ".json";
1543     
1544     address public _owner;
1545     string private baseURI;
1546     uint256 nextTokenId = 0;
1547     uint256 MAX_MINT_SUPPLY = 4000;
1548     uint256 maxMintAmount = 5;
1549 
1550     uint256 gasForDestinationLzReceive = 350000;
1551 
1552     mapping(address => uint256) public claimedNFT;
1553 
1554     constructor(string memory baseURI_)
1555         ERC721("BitBot Friends", "BB Friends")
1556     {
1557         _owner = msg.sender;
1558         endpoint = ILayerZeroEndpoint(0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675);
1559         baseURI = baseURI_;
1560     }
1561 
1562     /** 
1563      @dev You can mint up to 5 NFTs with a single address.
1564      Beware that to not mint to much or the transaction might fail
1565      mint is free, but donations are also accepted
1566     **/ 
1567     function mint(uint256 _mintAmount) external payable {
1568         require(
1569             _mintAmount <= maxMintAmount,
1570             "Mint Amount exceeds the Maximum Allowed Mint Amount of 5"
1571         );
1572         require(_mintAmount > 0, "Mint Amount needs to be bigger than 0");
1573         require(
1574             nextTokenId + _mintAmount - 1 <= MAX_MINT_SUPPLY,
1575             "Mint Amount exceeds the Available Mint Amount"
1576         );
1577         require(
1578             claimedNFT[msg.sender] + _mintAmount <= maxMintAmount,
1579             "This address already minted the max amount of allowed NFTs"
1580         );
1581         for (uint256 i = 1; i <= _mintAmount; i++) {
1582             _safeMint(msg.sender, nextTokenId++);
1583         }
1584         claimedNFT[msg.sender] = claimedNFT[msg.sender] + _mintAmount;
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
1624             "The value of the send Message was not enough to cover the Message Fee. Send more gas for message fees"
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
1641     function setNextTokenId(uint256 _newNextTokenId) public onlyOwner {
1642         nextTokenId = _newNextTokenId;
1643     }
1644     
1645     function setMAX_MINT_SUPPLY(uint256 _newMAX_MINT_SUPPLY) public onlyOwner {
1646         MAX_MINT_SUPPLY = _newMAX_MINT_SUPPLY;
1647     }
1648     
1649     function setLayerZeroEndpoint(address _layerZeroEndpoint) public onlyOwner {
1650         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1651     }
1652 
1653     function donate() external payable {
1654         // thank you
1655     }
1656 
1657     // This allows the devs to receive kind donations
1658     function withdraw() external onlyOwner {
1659         (bool sent, ) = payable(_owner).call{value: address(this).balance}("");
1660         require(sent);
1661     }
1662 
1663     // just in case this fixed variable limits us from future integrations
1664     function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1665         gasForDestinationLzReceive = newVal;
1666     }
1667 
1668     // ------------------
1669     // Internal Functions
1670     // ------------------
1671 
1672     function _LzReceive(
1673         uint16 _srcChainId,
1674         bytes memory _srcAddress,
1675         uint64 _nonce,
1676         bytes memory _payload
1677     ) internal override {
1678         // decode
1679         (address toAddr, uint256 tokenId) = abi.decode(
1680             _payload,
1681             (address, uint256)
1682         );
1683 
1684         // mint the tokens back into existence on destination chain
1685         _safeMint(toAddr, tokenId);
1686     }
1687 
1688     function tokenURI(uint256 tokenId)
1689         public
1690         view
1691         virtual
1692         override
1693         returns (string memory)
1694     {
1695         require(
1696             _exists(tokenId),
1697             "ERC721Metadata: URI query for nonexistent token"
1698         );
1699 
1700         string memory currentBaseURI = _baseURI();
1701         return
1702             bytes(currentBaseURI).length > 0
1703                 ? string(
1704                     abi.encodePacked(
1705                         currentBaseURI,
1706                         tokenId.toString(),
1707                         baseExtension
1708                     )
1709                 )
1710                 : "";
1711     }
1712 
1713     // internal
1714     function _baseURI() internal view virtual override returns (string memory) {
1715         return baseURI;
1716     }
1717 }