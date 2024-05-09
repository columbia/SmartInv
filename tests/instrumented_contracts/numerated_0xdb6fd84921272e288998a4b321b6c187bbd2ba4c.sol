1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
4 
5 pragma solidity >=0.5.0;
6 
7 interface ILayerZeroUserApplicationConfig {
8     // @notice set the configuration of the LayerZero messaging library of the specified version
9     // @param _version - messaging library version
10     // @param _chainId - the chainId for the pending config change
11     // @param _configType - type of configuration. every messaging library has its own convention.
12     // @param _config - configuration in the bytes. can encode arbitrary content.
13     function setConfig(
14         uint16 _version,
15         uint16 _chainId,
16         uint256 _configType,
17         bytes calldata _config
18     ) external;
19 
20     // @notice set the send() LayerZero messaging library version to _version
21     // @param _version - new messaging library version
22     function setSendVersion(uint16 _version) external;
23 
24     // @notice set the lzReceive() LayerZero messaging library version to _version
25     // @param _version - new messaging library version
26     function setReceiveVersion(uint16 _version) external;
27 
28     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
29     // @param _srcChainId - the chainId of the source chain
30     // @param _srcAddress - the contract address of the source contract at the source chain
31     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
32         external;
33 }
34 
35 // File: contracts/interfaces/ILayerZeroEndpoint.sol
36 
37 pragma solidity >=0.5.0;
38 
39 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
40     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
41     // @param _dstChainId - the destination chain identifier
42     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
43     // @param _payload - a custom bytes payload to send to the destination contract
44     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
45     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
46     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
47     function send(
48         uint16 _dstChainId,
49         bytes calldata _destination,
50         bytes calldata _payload,
51         address payable _refundAddress,
52         address _zroPaymentAddress,
53         bytes calldata _adapterParams
54     ) external payable;
55 
56     // @notice used by the messaging library to publish verified payload
57     // @param _srcChainId - the source chain identifier
58     // @param _srcAddress - the source contract (as bytes) at the source chain
59     // @param _dstAddress - the address on destination chain
60     // @param _nonce - the unbound message ordering nonce
61     // @param _gasLimit - the gas limit for external contract execution
62     // @param _payload - verified payload to send to the destination contract
63     function receivePayload(
64         uint16 _srcChainId,
65         bytes calldata _srcAddress,
66         address _dstAddress,
67         uint64 _nonce,
68         uint256 _gasLimit,
69         bytes calldata _payload
70     ) external;
71 
72     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
73     // @param _srcChainId - the source chain identifier
74     // @param _srcAddress - the source chain contract address
75     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress)
76         external
77         view
78         returns (uint64);
79 
80     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
81     // @param _srcAddress - the source chain contract address
82     function getOutboundNonce(uint16 _dstChainId, address _srcAddress)
83         external
84         view
85         returns (uint64);
86 
87     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
88     // @param _dstChainId - the destination chain identifier
89     // @param _userApplication - the user app address on this EVM chain
90     // @param _payload - the custom message to send over LayerZero
91     // @param _payInZRO - if false, user app pays the protocol fee in native token
92     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
93     function estimateFees(
94         uint16 _dstChainId,
95         address _userApplication,
96         bytes calldata _payload,
97         bool _payInZRO,
98         bytes calldata _adapterParam
99     ) external view returns (uint256 nativeFee, uint256 zroFee);
100 
101     // @notice get this Endpoint's immutable source identifier
102     function getChainId() external view returns (uint16);
103 
104     // @notice the interface to retry failed message on this Endpoint destination
105     // @param _srcChainId - the source chain identifier
106     // @param _srcAddress - the source chain contract address
107     // @param _payload - the payload to be retried
108     function retryPayload(
109         uint16 _srcChainId,
110         bytes calldata _srcAddress,
111         bytes calldata _payload
112     ) external;
113 
114     // @notice query if any STORED payload (message blocking) at the endpoint.
115     // @param _srcChainId - the source chain identifier
116     // @param _srcAddress - the source chain contract address
117     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress)
118         external
119         view
120         returns (bool);
121 
122     // @notice query if the _libraryAddress is valid for sending msgs.
123     // @param _userApplication - the user app address on this EVM chain
124     function getSendLibraryAddress(address _userApplication)
125         external
126         view
127         returns (address);
128 
129     // @notice query if the _libraryAddress is valid for receiving msgs.
130     // @param _userApplication - the user app address on this EVM chain
131     function getReceiveLibraryAddress(address _userApplication)
132         external
133         view
134         returns (address);
135 
136     // @notice query if the non-reentrancy guard for send() is on
137     // @return true if the guard is on. false otherwise
138     function isSendingPayload() external view returns (bool);
139 
140     // @notice query if the non-reentrancy guard for receive() is on
141     // @return true if the guard is on. false otherwise
142     function isReceivingPayload() external view returns (bool);
143 
144     // @notice get the configuration of the LayerZero messaging library of the specified version
145     // @param _version - messaging library version
146     // @param _chainId - the chainId for the pending config change
147     // @param _userApplication - the contract address of the user application
148     // @param _configType - type of configuration. every messaging library has its own convention.
149     function getConfig(
150         uint16 _version,
151         uint16 _chainId,
152         address _userApplication,
153         uint256 _configType
154     ) external view returns (bytes memory);
155 
156     // @notice get the send() LayerZero messaging library version
157     // @param _userApplication - the contract address of the user application
158     function getSendVersion(address _userApplication)
159         external
160         view
161         returns (uint16);
162 
163     // @notice get the lzReceive() LayerZero messaging library version
164     // @param _userApplication - the contract address of the user application
165     function getReceiveVersion(address _userApplication)
166         external
167         view
168         returns (uint16);
169 }
170 
171 // File: contracts/interfaces/ILayerZeroReceiver.sol
172 
173 pragma solidity >=0.5.0;
174 
175 interface ILayerZeroReceiver {
176     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
177     // @param _srcChainId - the source endpoint identifier
178     // @param _srcAddress - the source sending contract address from the source chain
179     // @param _nonce - the ordered message nonce
180     // @param _payload - the signed payload is the UA bytes has encoded to be sent
181     function lzReceive(
182         uint16 _srcChainId,
183         bytes calldata _srcAddress,
184         uint64 _nonce,
185         bytes calldata _payload
186     ) external;
187 }
188 // File: @openzeppelin/contracts/utils/Strings.sol
189 
190 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev String operations.
196  */
197 library Strings {
198     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
199 
200     /**
201      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
202      */
203     function toString(uint256 value) internal pure returns (string memory) {
204         // Inspired by OraclizeAPI's implementation - MIT licence
205         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
206 
207         if (value == 0) {
208             return "0";
209         }
210         uint256 temp = value;
211         uint256 digits;
212         while (temp != 0) {
213             digits++;
214             temp /= 10;
215         }
216         bytes memory buffer = new bytes(digits);
217         while (value != 0) {
218             digits -= 1;
219             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
220             value /= 10;
221         }
222         return string(buffer);
223     }
224 
225     /**
226      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
227      */
228     function toHexString(uint256 value) internal pure returns (string memory) {
229         if (value == 0) {
230             return "0x00";
231         }
232         uint256 temp = value;
233         uint256 length = 0;
234         while (temp != 0) {
235             length++;
236             temp >>= 8;
237         }
238         return toHexString(value, length);
239     }
240 
241     /**
242      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
243      */
244     function toHexString(uint256 value, uint256 length)
245         internal
246         pure
247         returns (string memory)
248     {
249         bytes memory buffer = new bytes(2 * length + 2);
250         buffer[0] = "0";
251         buffer[1] = "x";
252         for (uint256 i = 2 * length + 1; i > 1; --i) {
253             buffer[i] = _HEX_SYMBOLS[value & 0xf];
254             value >>= 4;
255         }
256         require(value == 0, "Strings: hex length insufficient");
257         return string(buffer);
258     }
259 }
260 
261 // File: @openzeppelin/contracts/utils/Context.sol
262 
263 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev Provides information about the current execution context, including the
269  * sender of the transaction and its data. While these are generally available
270  * via msg.sender and msg.data, they should not be accessed in such a direct
271  * manner, since when dealing with meta-transactions the account sending and
272  * paying for execution may not be the actual sender (as far as an application
273  * is concerned).
274  *
275  * This contract is only required for intermediate, library-like contracts.
276  */
277 abstract contract Context {
278     function _msgSender() internal view virtual returns (address) {
279         return msg.sender;
280     }
281 
282     function _msgData() internal view virtual returns (bytes calldata) {
283         return msg.data;
284     }
285 }
286 
287 // File: @openzeppelin/contracts/access/Ownable.sol
288 
289 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Contract module which provides a basic access control mechanism, where
295  * there is an account (an owner) that can be granted exclusive access to
296  * specific functions.
297  *
298  * By default, the owner account will be the one that deploys the contract. This
299  * can later be changed with {transferOwnership}.
300  *
301  * This module is used through inheritance. It will make available the modifier
302  * `onlyOwner`, which can be applied to your functions to restrict their use to
303  * the owner.
304  */
305 abstract contract Ownable is Context {
306     address private _owner;
307 
308     event OwnershipTransferred(
309         address indexed previousOwner,
310         address indexed newOwner
311     );
312 
313     /**
314      * @dev Initializes the contract setting the deployer as the initial owner.
315      */
316     constructor() {
317         _transferOwnership(_msgSender());
318     }
319 
320     /**
321      * @dev Returns the address of the current owner.
322      */
323     function owner() public view virtual returns (address) {
324         return _owner;
325     }
326 
327     /**
328      * @dev Throws if called by any account other than the owner.
329      */
330     modifier onlyOwner() {
331         require(owner() == _msgSender(), "Ownable: caller is not the owner");
332         _;
333     }
334 
335     /**
336      * @dev Leaves the contract without owner. It will not be possible to call
337      * `onlyOwner` functions anymore. Can only be called by the current owner.
338      *
339      * NOTE: Renouncing ownership will leave the contract without an owner,
340      * thereby removing any functionality that is only available to the owner.
341      */
342     function renounceOwnership() public virtual onlyOwner {
343         _transferOwnership(address(0));
344     }
345 
346     /**
347      * @dev Transfers ownership of the contract to a new account (`newOwner`).
348      * Can only be called by the current owner.
349      */
350     function transferOwnership(address newOwner) public virtual onlyOwner {
351         require(
352             newOwner != address(0),
353             "Ownable: new owner is the zero address"
354         );
355         _transferOwnership(newOwner);
356     }
357 
358     /**
359      * @dev Transfers ownership of the contract to a new account (`newOwner`).
360      * Internal function without access restriction.
361      */
362     function _transferOwnership(address newOwner) internal virtual {
363         address oldOwner = _owner;
364         _owner = newOwner;
365         emit OwnershipTransferred(oldOwner, newOwner);
366     }
367 }
368 
369 // File: @openzeppelin/contracts/utils/Address.sol
370 
371 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
372 
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @dev Collection of functions related to the address type
377  */
378 library Address {
379     /**
380      * @dev Returns true if `account` is a contract.
381      *
382      * [IMPORTANT]
383      * ====
384      * It is unsafe to assume that an address for which this function returns
385      * false is an externally-owned account (EOA) and not a contract.
386      *
387      * Among others, `isContract` will return false for the following
388      * types of addresses:
389      *
390      *  - an externally-owned account
391      *  - a contract in construction
392      *  - an address where a contract will be created
393      *  - an address where a contract lived, but was destroyed
394      * ====
395      */
396     function isContract(address account) internal view returns (bool) {
397         // This method relies on extcodesize, which returns 0 for contracts in
398         // construction, since the code is only stored at the end of the
399         // constructor execution.
400 
401         uint256 size;
402         assembly {
403             size := extcodesize(account)
404         }
405         return size > 0;
406     }
407 
408     /**
409      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
410      * `recipient`, forwarding all available gas and reverting on errors.
411      *
412      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
413      * of certain opcodes, possibly making contracts go over the 2300 gas limit
414      * imposed by `transfer`, making them unable to receive funds via
415      * `transfer`. {sendValue} removes this limitation.
416      *
417      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
418      *
419      * IMPORTANT: because control is transferred to `recipient`, care must be
420      * taken to not create reentrancy vulnerabilities. Consider using
421      * {ReentrancyGuard} or the
422      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
423      */
424     function sendValue(address payable recipient, uint256 amount) internal {
425         require(
426             address(this).balance >= amount,
427             "Address: insufficient balance"
428         );
429 
430         (bool success, ) = recipient.call{value: amount}("");
431         require(
432             success,
433             "Address: unable to send value, recipient may have reverted"
434         );
435     }
436 
437     /**
438      * @dev Performs a Solidity function call using a low level `call`. A
439      * plain `call` is an unsafe replacement for a function call: use this
440      * function instead.
441      *
442      * If `target` reverts with a revert reason, it is bubbled up by this
443      * function (like regular Solidity function calls).
444      *
445      * Returns the raw returned data. To convert to the expected return value,
446      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
447      *
448      * Requirements:
449      *
450      * - `target` must be a contract.
451      * - calling `target` with `data` must not revert.
452      *
453      * _Available since v3.1._
454      */
455     function functionCall(address target, bytes memory data)
456         internal
457         returns (bytes memory)
458     {
459         return functionCall(target, data, "Address: low-level call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
464      * `errorMessage` as a fallback revert reason when `target` reverts.
465      *
466      * _Available since v3.1._
467      */
468     function functionCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, 0, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but also transferring `value` wei to `target`.
479      *
480      * Requirements:
481      *
482      * - the calling contract must have an ETH balance of at least `value`.
483      * - the called Solidity function must be `payable`.
484      *
485      * _Available since v3.1._
486      */
487     function functionCallWithValue(
488         address target,
489         bytes memory data,
490         uint256 value
491     ) internal returns (bytes memory) {
492         return
493             functionCallWithValue(
494                 target,
495                 data,
496                 value,
497                 "Address: low-level call with value failed"
498             );
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
503      * with `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(
514             address(this).balance >= value,
515             "Address: insufficient balance for call"
516         );
517         require(isContract(target), "Address: call to non-contract");
518 
519         (bool success, bytes memory returndata) = target.call{value: value}(
520             data
521         );
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(address target, bytes memory data)
532         internal
533         view
534         returns (bytes memory)
535     {
536         return
537             functionStaticCall(
538                 target,
539                 data,
540                 "Address: low-level static call failed"
541             );
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal view returns (bytes memory) {
555         require(isContract(target), "Address: static call to non-contract");
556 
557         (bool success, bytes memory returndata) = target.staticcall(data);
558         return verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but performing a delegate call.
564      *
565      * _Available since v3.4._
566      */
567     function functionDelegateCall(address target, bytes memory data)
568         internal
569         returns (bytes memory)
570     {
571         return
572             functionDelegateCall(
573                 target,
574                 data,
575                 "Address: low-level delegate call failed"
576             );
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
581      * but performing a delegate call.
582      *
583      * _Available since v3.4._
584      */
585     function functionDelegateCall(
586         address target,
587         bytes memory data,
588         string memory errorMessage
589     ) internal returns (bytes memory) {
590         require(isContract(target), "Address: delegate call to non-contract");
591 
592         (bool success, bytes memory returndata) = target.delegatecall(data);
593         return verifyCallResult(success, returndata, errorMessage);
594     }
595 
596     /**
597      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
598      * revert reason using the provided one.
599      *
600      * _Available since v4.3._
601      */
602     function verifyCallResult(
603         bool success,
604         bytes memory returndata,
605         string memory errorMessage
606     ) internal pure returns (bytes memory) {
607         if (success) {
608             return returndata;
609         } else {
610             // Look for revert reason and bubble it up if present
611             if (returndata.length > 0) {
612                 // The easiest way to bubble the revert reason is using memory via assembly
613 
614                 assembly {
615                     let returndata_size := mload(returndata)
616                     revert(add(32, returndata), returndata_size)
617                 }
618             } else {
619                 revert(errorMessage);
620             }
621         }
622     }
623 }
624 
625 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
626 
627 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 /**
632  * @title ERC721 token receiver interface
633  * @dev Interface for any contract that wants to support safeTransfers
634  * from ERC721 asset contracts.
635  */
636 interface IERC721Receiver {
637     /**
638      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
639      * by `operator` from `from`, this function is called.
640      *
641      * It must return its Solidity selector to confirm the token transfer.
642      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
643      *
644      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
645      */
646     function onERC721Received(
647         address operator,
648         address from,
649         uint256 tokenId,
650         bytes calldata data
651     ) external returns (bytes4);
652 }
653 
654 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
655 
656 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @dev Interface of the ERC165 standard, as defined in the
662  * https://eips.ethereum.org/EIPS/eip-165[EIP].
663  *
664  * Implementers can declare support of contract interfaces, which can then be
665  * queried by others ({ERC165Checker}).
666  *
667  * For an implementation, see {ERC165}.
668  */
669 interface IERC165 {
670     /**
671      * @dev Returns true if this contract implements the interface defined by
672      * `interfaceId`. See the corresponding
673      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
674      * to learn more about how these ids are created.
675      *
676      * This function call must use less than 30 000 gas.
677      */
678     function supportsInterface(bytes4 interfaceId) external view returns (bool);
679 }
680 
681 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
682 
683 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 /**
688  * @dev Implementation of the {IERC165} interface.
689  *
690  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
691  * for the additional interface id that will be supported. For example:
692  *
693  * ```solidity
694  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
695  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
696  * }
697  * ```
698  *
699  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
700  */
701 abstract contract ERC165 is IERC165 {
702     /**
703      * @dev See {IERC165-supportsInterface}.
704      */
705     function supportsInterface(bytes4 interfaceId)
706         public
707         view
708         virtual
709         override
710         returns (bool)
711     {
712         return interfaceId == type(IERC165).interfaceId;
713     }
714 }
715 
716 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
717 
718 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 /**
723  * @dev Required interface of an ERC721 compliant contract.
724  */
725 interface IERC721 is IERC165 {
726     /**
727      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
728      */
729     event Transfer(
730         address indexed from,
731         address indexed to,
732         uint256 indexed tokenId
733     );
734 
735     /**
736      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
737      */
738     event Approval(
739         address indexed owner,
740         address indexed approved,
741         uint256 indexed tokenId
742     );
743 
744     /**
745      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
746      */
747     event ApprovalForAll(
748         address indexed owner,
749         address indexed operator,
750         bool approved
751     );
752 
753     /**
754      * @dev Returns the number of tokens in ``owner``'s account.
755      */
756     function balanceOf(address owner) external view returns (uint256 balance);
757 
758     /**
759      * @dev Returns the owner of the `tokenId` token.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must exist.
764      */
765     function ownerOf(uint256 tokenId) external view returns (address owner);
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
769      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
777      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
778      *
779      * Emits a {Transfer} event.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId
785     ) external;
786 
787     /**
788      * @dev Transfers `tokenId` token from `from` to `to`.
789      *
790      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
791      *
792      * Requirements:
793      *
794      * - `from` cannot be the zero address.
795      * - `to` cannot be the zero address.
796      * - `tokenId` token must be owned by `from`.
797      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
798      *
799      * Emits a {Transfer} event.
800      */
801     function transferFrom(
802         address from,
803         address to,
804         uint256 tokenId
805     ) external;
806 
807     /**
808      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
809      * The approval is cleared when the token is transferred.
810      *
811      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
812      *
813      * Requirements:
814      *
815      * - The caller must own the token or be an approved operator.
816      * - `tokenId` must exist.
817      *
818      * Emits an {Approval} event.
819      */
820     function approve(address to, uint256 tokenId) external;
821 
822     /**
823      * @dev Returns the account approved for `tokenId` token.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must exist.
828      */
829     function getApproved(uint256 tokenId)
830         external
831         view
832         returns (address operator);
833 
834     /**
835      * @dev Approve or remove `operator` as an operator for the caller.
836      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
837      *
838      * Requirements:
839      *
840      * - The `operator` cannot be the caller.
841      *
842      * Emits an {ApprovalForAll} event.
843      */
844     function setApprovalForAll(address operator, bool _approved) external;
845 
846     /**
847      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
848      *
849      * See {setApprovalForAll}
850      */
851     function isApprovedForAll(address owner, address operator)
852         external
853         view
854         returns (bool);
855 
856     /**
857      * @dev Safely transfers `tokenId` token from `from` to `to`.
858      *
859      * Requirements:
860      *
861      * - `from` cannot be the zero address.
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must exist and be owned by `from`.
864      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
865      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
866      *
867      * Emits a {Transfer} event.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 tokenId,
873         bytes calldata data
874     ) external;
875 }
876 
877 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
878 
879 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 /**
884  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
885  * @dev See https://eips.ethereum.org/EIPS/eip-721
886  */
887 interface IERC721Metadata is IERC721 {
888     /**
889      * @dev Returns the token collection name.
890      */
891     function name() external view returns (string memory);
892 
893     /**
894      * @dev Returns the token collection symbol.
895      */
896     function symbol() external view returns (string memory);
897 
898     /**
899      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
900      */
901     function tokenURI(uint256 tokenId) external view returns (string memory);
902 }
903 
904 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
905 
906 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
907 
908 pragma solidity ^0.8.0;
909 
910 /**
911  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
912  * the Metadata extension, but not including the Enumerable extension, which is available separately as
913  * {ERC721Enumerable}.
914  */
915 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
916     using Address for address;
917     using Strings for uint256;
918 
919     // Token name
920     string private _name;
921 
922     // Token symbol
923     string private _symbol;
924 
925     // Mapping from token ID to owner address
926     mapping(uint256 => address) private _owners;
927 
928     // Mapping owner address to token count
929     mapping(address => uint256) private _balances;
930 
931     // Mapping from token ID to approved address
932     mapping(uint256 => address) private _tokenApprovals;
933 
934     // Mapping from owner to operator approvals
935     mapping(address => mapping(address => bool)) private _operatorApprovals;
936 
937     /**
938      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
939      */
940     constructor(string memory name_, string memory symbol_) {
941         _name = name_;
942         _symbol = symbol_;
943     }
944 
945     /**
946      * @dev See {IERC165-supportsInterface}.
947      */
948     function supportsInterface(bytes4 interfaceId)
949         public
950         view
951         virtual
952         override(ERC165, IERC165)
953         returns (bool)
954     {
955         return
956             interfaceId == type(IERC721).interfaceId ||
957             interfaceId == type(IERC721Metadata).interfaceId ||
958             super.supportsInterface(interfaceId);
959     }
960 
961     /**
962      * @dev See {IERC721-balanceOf}.
963      */
964     function balanceOf(address owner)
965         public
966         view
967         virtual
968         override
969         returns (uint256)
970     {
971         require(
972             owner != address(0),
973             "ERC721: balance query for the zero address"
974         );
975         return _balances[owner];
976     }
977 
978     /**
979      * @dev See {IERC721-ownerOf}.
980      */
981     function ownerOf(uint256 tokenId)
982         public
983         view
984         virtual
985         override
986         returns (address)
987     {
988         address owner = _owners[tokenId];
989         require(
990             owner != address(0),
991             "ERC721: owner query for nonexistent token"
992         );
993         return owner;
994     }
995 
996     /**
997      * @dev See {IERC721Metadata-name}.
998      */
999     function name() public view virtual override returns (string memory) {
1000         return _name;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-symbol}.
1005      */
1006     function symbol() public view virtual override returns (string memory) {
1007         return _symbol;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-tokenURI}.
1012      */
1013     function tokenURI(uint256 tokenId)
1014         public
1015         view
1016         virtual
1017         override
1018         returns (string memory)
1019     {
1020         require(
1021             _exists(tokenId),
1022             "ERC721Metadata: URI query for nonexistent token"
1023         );
1024 
1025         string memory baseURI = _baseURI();
1026         return
1027             bytes(baseURI).length > 0
1028                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1029                 : "";
1030     }
1031 
1032     /**
1033      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1034      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1035      * by default, can be overriden in child contracts.
1036      */
1037     function _baseURI() internal view virtual returns (string memory) {
1038         return "";
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-approve}.
1043      */
1044     function approve(address to, uint256 tokenId) public virtual override {
1045         address owner = ERC721.ownerOf(tokenId);
1046         require(to != owner, "ERC721: approval to current owner");
1047 
1048         require(
1049             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1050             "ERC721: approve caller is not owner nor approved for all"
1051         );
1052 
1053         _approve(to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-getApproved}.
1058      */
1059     function getApproved(uint256 tokenId)
1060         public
1061         view
1062         virtual
1063         override
1064         returns (address)
1065     {
1066         require(
1067             _exists(tokenId),
1068             "ERC721: approved query for nonexistent token"
1069         );
1070 
1071         return _tokenApprovals[tokenId];
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-setApprovalForAll}.
1076      */
1077     function setApprovalForAll(address operator, bool approved)
1078         public
1079         virtual
1080         override
1081     {
1082         _setApprovalForAll(_msgSender(), operator, approved);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-isApprovedForAll}.
1087      */
1088     function isApprovedForAll(address owner, address operator)
1089         public
1090         view
1091         virtual
1092         override
1093         returns (bool)
1094     {
1095         return _operatorApprovals[owner][operator];
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-transferFrom}.
1100      */
1101     function transferFrom(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) public virtual override {
1106         //solhint-disable-next-line max-line-length
1107         require(
1108             _isApprovedOrOwner(_msgSender(), tokenId),
1109             "ERC721: transfer caller is not owner nor approved"
1110         );
1111 
1112         _transfer(from, to, tokenId);
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-safeTransferFrom}.
1117      */
1118     function safeTransferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) public virtual override {
1123         safeTransferFrom(from, to, tokenId, "");
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-safeTransferFrom}.
1128      */
1129     function safeTransferFrom(
1130         address from,
1131         address to,
1132         uint256 tokenId,
1133         bytes memory _data
1134     ) public virtual override {
1135         require(
1136             _isApprovedOrOwner(_msgSender(), tokenId),
1137             "ERC721: transfer caller is not owner nor approved"
1138         );
1139         _safeTransfer(from, to, tokenId, _data);
1140     }
1141 
1142     /**
1143      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1144      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1145      *
1146      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1147      *
1148      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1149      * implement alternative mechanisms to perform token transfer, such as signature-based.
1150      *
1151      * Requirements:
1152      *
1153      * - `from` cannot be the zero address.
1154      * - `to` cannot be the zero address.
1155      * - `tokenId` token must exist and be owned by `from`.
1156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1157      *
1158      * Emits a {Transfer} event.
1159      */
1160     function _safeTransfer(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) internal virtual {
1166         _transfer(from, to, tokenId);
1167         require(
1168             _checkOnERC721Received(from, to, tokenId, _data),
1169             "ERC721: transfer to non ERC721Receiver implementer"
1170         );
1171     }
1172 
1173     /**
1174      * @dev Returns whether `tokenId` exists.
1175      *
1176      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1177      *
1178      * Tokens start existing when they are minted (`_mint`),
1179      * and stop existing when they are burned (`_burn`).
1180      */
1181     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1182         return _owners[tokenId] != address(0);
1183     }
1184 
1185     /**
1186      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1187      *
1188      * Requirements:
1189      *
1190      * - `tokenId` must exist.
1191      */
1192     function _isApprovedOrOwner(address spender, uint256 tokenId)
1193         internal
1194         view
1195         virtual
1196         returns (bool)
1197     {
1198         require(
1199             _exists(tokenId),
1200             "ERC721: operator query for nonexistent token"
1201         );
1202         address owner = ERC721.ownerOf(tokenId);
1203         return (spender == owner ||
1204             getApproved(tokenId) == spender ||
1205             isApprovedForAll(owner, spender));
1206     }
1207 
1208     /**
1209      * @dev Safely mints `tokenId` and transfers it to `to`.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must not exist.
1214      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _safeMint(address to, uint256 tokenId) internal virtual {
1219         _safeMint(to, tokenId, "");
1220     }
1221 
1222     /**
1223      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1224      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1225      */
1226     function _safeMint(
1227         address to,
1228         uint256 tokenId,
1229         bytes memory _data
1230     ) internal virtual {
1231         _mint(to, tokenId);
1232         require(
1233             _checkOnERC721Received(address(0), to, tokenId, _data),
1234             "ERC721: transfer to non ERC721Receiver implementer"
1235         );
1236     }
1237 
1238     /**
1239      * @dev Mints `tokenId` and transfers it to `to`.
1240      *
1241      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1242      *
1243      * Requirements:
1244      *
1245      * - `tokenId` must not exist.
1246      * - `to` cannot be the zero address.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _mint(address to, uint256 tokenId) internal virtual {
1251         require(to != address(0), "ERC721: mint to the zero address");
1252 
1253         _beforeTokenTransfer(address(0), to, tokenId);
1254 
1255         _balances[to] += 1;
1256         _owners[tokenId] = to;
1257 
1258         emit Transfer(address(0), to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev Destroys `tokenId`.
1263      * The approval is cleared when the token is burned.
1264      *
1265      * Requirements:
1266      *
1267      * - `tokenId` must exist.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _burn(uint256 tokenId) internal virtual {
1272         address owner = ERC721.ownerOf(tokenId);
1273 
1274         _beforeTokenTransfer(owner, address(0), tokenId);
1275 
1276         // Clear approvals
1277         _approve(address(0), tokenId);
1278 
1279         _balances[owner] -= 1;
1280         delete _owners[tokenId];
1281 
1282         emit Transfer(owner, address(0), tokenId);
1283     }
1284 
1285     /**
1286      * @dev Transfers `tokenId` from `from` to `to`.
1287      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1288      *
1289      * Requirements:
1290      *
1291      * - `to` cannot be the zero address.
1292      * - `tokenId` token must be owned by `from`.
1293      *
1294      * Emits a {Transfer} event.
1295      */
1296     function _transfer(
1297         address from,
1298         address to,
1299         uint256 tokenId
1300     ) internal virtual {
1301         require(
1302             ERC721.ownerOf(tokenId) == from,
1303             "ERC721: transfer of token that is not own"
1304         );
1305         require(to != address(0), "ERC721: transfer to the zero address");
1306 
1307         _beforeTokenTransfer(from, to, tokenId);
1308 
1309         // Clear approvals from the previous owner
1310         _approve(address(0), tokenId);
1311 
1312         _balances[from] -= 1;
1313         _balances[to] += 1;
1314         _owners[tokenId] = to;
1315 
1316         emit Transfer(from, to, tokenId);
1317     }
1318 
1319     /**
1320      * @dev Approve `to` to operate on `tokenId`
1321      *
1322      * Emits a {Approval} event.
1323      */
1324     function _approve(address to, uint256 tokenId) internal virtual {
1325         _tokenApprovals[tokenId] = to;
1326         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1327     }
1328 
1329     /**
1330      * @dev Approve `operator` to operate on all of `owner` tokens
1331      *
1332      * Emits a {ApprovalForAll} event.
1333      */
1334     function _setApprovalForAll(
1335         address owner,
1336         address operator,
1337         bool approved
1338     ) internal virtual {
1339         require(owner != operator, "ERC721: approve to caller");
1340         _operatorApprovals[owner][operator] = approved;
1341         emit ApprovalForAll(owner, operator, approved);
1342     }
1343 
1344     /**
1345      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1346      * The call is not executed if the target address is not a contract.
1347      *
1348      * @param from address representing the previous owner of the given token ID
1349      * @param to target address that will receive the tokens
1350      * @param tokenId uint256 ID of the token to be transferred
1351      * @param _data bytes optional data to send along with the call
1352      * @return bool whether the call correctly returned the expected magic value
1353      */
1354     function _checkOnERC721Received(
1355         address from,
1356         address to,
1357         uint256 tokenId,
1358         bytes memory _data
1359     ) private returns (bool) {
1360         if (to.isContract()) {
1361             try
1362                 IERC721Receiver(to).onERC721Received(
1363                     _msgSender(),
1364                     from,
1365                     tokenId,
1366                     _data
1367                 )
1368             returns (bytes4 retval) {
1369                 return retval == IERC721Receiver.onERC721Received.selector;
1370             } catch (bytes memory reason) {
1371                 if (reason.length == 0) {
1372                     revert(
1373                         "ERC721: transfer to non ERC721Receiver implementer"
1374                     );
1375                 } else {
1376                     assembly {
1377                         revert(add(32, reason), mload(reason))
1378                     }
1379                 }
1380             }
1381         } else {
1382             return true;
1383         }
1384     }
1385 
1386     /**
1387      * @dev Hook that is called before any token transfer. This includes minting
1388      * and burning.
1389      *
1390      * Calling conditions:
1391      *
1392      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1393      * transferred to `to`.
1394      * - When `from` is zero, `tokenId` will be minted for `to`.
1395      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1396      * - `from` and `to` are never both zero.
1397      *
1398      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1399      */
1400     function _beforeTokenTransfer(
1401         address from,
1402         address to,
1403         uint256 tokenId
1404     ) internal virtual {}
1405 }
1406 
1407 // File: contracts/NonblockingReceiver.sol
1408 
1409 pragma solidity ^0.8.6;
1410 
1411 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1412     ILayerZeroEndpoint internal endpoint;
1413 
1414     struct FailedMessages {
1415         uint256 payloadLength;
1416         bytes32 payloadHash;
1417     }
1418 
1419     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1420         public failedMessages;
1421     mapping(uint16 => bytes) public trustedRemoteLookup;
1422 
1423     event MessageFailed(
1424         uint16 _srcChainId,
1425         bytes _srcAddress,
1426         uint64 _nonce,
1427         bytes _payload
1428     );
1429 
1430     function lzReceive(
1431         uint16 _srcChainId,
1432         bytes memory _srcAddress,
1433         uint64 _nonce,
1434         bytes memory _payload
1435     ) external override {
1436         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1437         require(
1438             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1439                 keccak256(_srcAddress) ==
1440                 keccak256(trustedRemoteLookup[_srcChainId]),
1441             "NonblockingReceiver: invalid source sending contract"
1442         );
1443 
1444         // try-catch all errors/exceptions
1445         // having failed messages does not block messages passing
1446         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1447             // do nothing
1448         } catch {
1449             // error / exception
1450             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1451                 _payload.length,
1452                 keccak256(_payload)
1453             );
1454             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1455         }
1456     }
1457 
1458     function onLzReceive(
1459         uint16 _srcChainId,
1460         bytes memory _srcAddress,
1461         uint64 _nonce,
1462         bytes memory _payload
1463     ) public {
1464         // only internal transaction
1465         require(
1466             msg.sender == address(this),
1467             "NonblockingReceiver: caller must be Bridge."
1468         );
1469 
1470         // handle incoming message
1471         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1472     }
1473 
1474     // abstract function
1475     function _LzReceive(
1476         uint16 _srcChainId,
1477         bytes memory _srcAddress,
1478         uint64 _nonce,
1479         bytes memory _payload
1480     ) internal virtual;
1481 
1482     function _lzSend(
1483         uint16 _dstChainId,
1484         bytes memory _payload,
1485         address payable _refundAddress,
1486         address _zroPaymentAddress,
1487         bytes memory _txParam
1488     ) internal {
1489         endpoint.send{value: msg.value}(
1490             _dstChainId,
1491             trustedRemoteLookup[_dstChainId],
1492             _payload,
1493             _refundAddress,
1494             _zroPaymentAddress,
1495             _txParam
1496         );
1497     }
1498 
1499     function retryMessage(
1500         uint16 _srcChainId,
1501         bytes memory _srcAddress,
1502         uint64 _nonce,
1503         bytes calldata _payload
1504     ) external payable {
1505         // assert there is message to retry
1506         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1507             _srcAddress
1508         ][_nonce];
1509         require(
1510             failedMsg.payloadHash != bytes32(0),
1511             "NonblockingReceiver: no stored message"
1512         );
1513         require(
1514             _payload.length == failedMsg.payloadLength &&
1515                 keccak256(_payload) == failedMsg.payloadHash,
1516             "LayerZero: invalid payload"
1517         );
1518         // clear the stored message
1519         failedMsg.payloadLength = 0;
1520         failedMsg.payloadHash = bytes32(0);
1521         // execute the message. revert if it fails again
1522         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1523     }
1524 
1525     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1526         external
1527         onlyOwner
1528     {
1529         trustedRemoteLookup[_chainId] = _trustedRemote;
1530     }
1531 }
1532 
1533 
1534 pragma solidity ^0.8.7;
1535 
1536 contract OmniMosquitoes is Ownable, ERC721, NonblockingReceiver {
1537     address public _owner;
1538     string private baseURI;
1539     uint256 nextTokenId = 6512;
1540     uint256 MAX_MINT_SUPPLY = 10000;
1541 
1542     uint256 gasForDestinationLzReceive = 350000;
1543 
1544     constructor(string memory baseURI_, address _layerZeroEndpoint)
1545         ERC721("Omni Mosquitoes", "OxMosquitoes")
1546     {
1547         _owner = msg.sender;
1548         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1549         baseURI = baseURI_;
1550     }
1551 
1552     // mint function
1553     // you can choose from mint 1 to 3
1554     // mint is free, but donations are also accepted
1555     function mint(uint8 numTokens) external payable {
1556         require(numTokens < 4, "omni mosquitoes: Max 3 NFTs per transaction");
1557         require(
1558             nextTokenId + numTokens <= MAX_MINT_SUPPLY,
1559             "omni mosquitoes: Mint exceeds supply"
1560         );
1561         
1562         for (uint256 i = 1; i <= numTokens; i++) {
1563             _safeMint(msg.sender, ++nextTokenId);
1564         }
1565     }
1566 
1567     // This function transfers the nft from your address on the
1568     // source chain to the same address on the destination chain
1569     function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1570         require(
1571             msg.sender == ownerOf(tokenId),
1572             "You must own the token to traverse"
1573         );
1574         require(
1575             trustedRemoteLookup[_chainId].length > 0,
1576             "This chain is currently unavailable for travel"
1577         );
1578 
1579         // burn NFT, eliminating it from circulation on src chain
1580         _burn(tokenId);
1581 
1582         // abi.encode() the payload with the values to send
1583         bytes memory payload = abi.encode(msg.sender, tokenId);
1584 
1585         // encode adapterParams to specify more gas for the destination
1586         uint16 version = 1;
1587         bytes memory adapterParams = abi.encodePacked(
1588             version,
1589             gasForDestinationLzReceive
1590         );
1591 
1592         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1593         // you will be refunded for extra gas paid
1594         (uint256 messageFee, ) = endpoint.estimateFees(
1595             _chainId,
1596             address(this),
1597             payload,
1598             false,
1599             adapterParams
1600         );
1601 
1602         require(
1603             msg.value >= messageFee,
1604             "omni mosquitoes: msg.value not enough to cover messageFee. Send gas for message fees"
1605         );
1606 
1607         endpoint.send{value: msg.value}(
1608             _chainId, // destination chainId
1609             trustedRemoteLookup[_chainId], // destination address of nft contract
1610             payload, // abi.encoded()'ed bytes
1611             payable(msg.sender), // refund address
1612             address(0x0), // 'zroPaymentAddress' unused for this
1613             adapterParams // txParameters
1614         );
1615     }
1616 
1617     function setBaseURI(string memory URI) external onlyOwner {
1618         baseURI = URI;
1619     }
1620 
1621     function donate() external payable {
1622         // thank you
1623     }
1624 
1625     // This allows the devs to receive kind donations
1626     function withdraw(uint256 amt) external onlyOwner {
1627         (bool sent, ) = payable(_owner).call{value: amt}("");
1628         require(sent, "omni mosquitoes: Failed to withdraw Ether");
1629     }
1630 
1631     // just in case this fixed variable limits us from future integrations
1632     function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1633         gasForDestinationLzReceive = newVal;
1634     }
1635 
1636     // ------------------
1637     // Internal Functions
1638     // ------------------
1639 
1640     function _LzReceive(
1641         uint16 _srcChainId,
1642         bytes memory _srcAddress,
1643         uint64 _nonce,
1644         bytes memory _payload
1645     ) internal override {
1646         // decode
1647         (address toAddr, uint256 tokenId) = abi.decode(
1648             _payload,
1649             (address, uint256)
1650         );
1651 
1652         // mint the tokens back into existence on destination chain
1653         _safeMint(toAddr, tokenId);
1654     }
1655 
1656     function _baseURI() internal view override returns (string memory) {
1657         return baseURI;
1658     }
1659 }