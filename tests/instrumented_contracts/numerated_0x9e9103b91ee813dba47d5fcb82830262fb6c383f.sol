1 // SPDX-License-Identifier: MIT
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
908 interface IERC721Enumerable is IERC721 {
909     /**
910      * @dev Returns the total amount of tokens stored by the contract.
911      */
912     function totalSupply() external view returns (uint256);
913 
914     /**
915      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
916      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
917      */
918     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
919 
920     /**
921      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
922      * Use along with {totalSupply} to enumerate all tokens.
923      */
924     function tokenByIndex(uint256 index) external view returns (uint256);
925 }
926 
927 pragma solidity ^0.8.0;
928 
929 /**
930  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
931  * the Metadata extension, but not including the Enumerable extension, which is available separately as
932  * {ERC721Enumerable}.
933  */
934 
935 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
936     using Address for address;
937     using Strings for uint256;
938 
939     struct TokenOwnership {
940         address addr;
941         uint64 startTimestamp;
942     }
943 
944     struct AddressData {
945         uint128 balance;
946         uint128 numberMinted;
947     }
948 
949     uint256 internal currentIndex = 0;
950 
951     uint256 internal immutable maxBatchSize;
952 
953     // Token name
954     string private _name;
955 
956     // Token symbol
957     string private _symbol;
958 
959     // Mapping from token ID to ownership details
960     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
961     mapping(uint256 => TokenOwnership) internal _ownerships;
962 
963     // Mapping owner address to address data
964     mapping(address => AddressData) private _addressData;
965 
966     // Mapping from token ID to approved address
967     mapping(uint256 => address) private _tokenApprovals;
968 
969     // Mapping from owner to operator approvals
970     mapping(address => mapping(address => bool)) private _operatorApprovals;
971 
972     /**
973      * @dev
974      * `maxBatchSize` refers to how much a minter can mint at a time.
975      */
976     constructor(
977         string memory name_,
978         string memory symbol_,
979         uint256 maxBatchSize_
980     ) {
981         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
982         _name = name_;
983         _symbol = symbol_;
984         maxBatchSize = maxBatchSize_;
985     }
986 
987     /**
988      * @dev See {IERC721Enumerable-totalSupply}.
989      */
990     function totalSupply() public view override returns (uint256) {
991         return currentIndex;
992     }
993 
994     /**
995      * @dev See {IERC721Enumerable-tokenByIndex}.
996      */
997     function tokenByIndex(uint256 index) public view override returns (uint256) {
998         require(index < totalSupply(), 'ERC721A: global index out of bounds');
999         return index;
1000     }
1001 
1002     /**
1003      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1004      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1005      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1006      */
1007     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1008         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1009         uint256 numMintedSoFar = totalSupply();
1010         uint256 tokenIdsIdx = 0;
1011         address currOwnershipAddr = address(0);
1012         for (uint256 i = 0; i < numMintedSoFar; i++) {
1013             TokenOwnership memory ownership = _ownerships[i];
1014             if (ownership.addr != address(0)) {
1015                 currOwnershipAddr = ownership.addr;
1016             }
1017             if (currOwnershipAddr == owner) {
1018                 if (tokenIdsIdx == index) {
1019                     return i;
1020                 }
1021                 tokenIdsIdx++;
1022             }
1023         }
1024         revert('ERC721A: unable to get token of owner by index');
1025     }
1026 
1027     /**
1028      * @dev See {IERC165-supportsInterface}.
1029      */
1030     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1031         return
1032             interfaceId == type(IERC721).interfaceId ||
1033             interfaceId == type(IERC721Metadata).interfaceId ||
1034             interfaceId == type(IERC721Enumerable).interfaceId ||
1035             super.supportsInterface(interfaceId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-balanceOf}.
1040      */
1041     function balanceOf(address owner) public view override returns (uint256) {
1042         require(owner != address(0), 'ERC721A: balance query for the zero address');
1043         return uint256(_addressData[owner].balance);
1044     }
1045 
1046     function _numberMinted(address owner) internal view returns (uint256) {
1047         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1048         return uint256(_addressData[owner].numberMinted);
1049     }
1050 
1051     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1052         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1053 
1054         uint256 lowestTokenToCheck;
1055         if (tokenId >= maxBatchSize) {
1056             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1057         }
1058 
1059         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1060             TokenOwnership memory ownership = _ownerships[curr];
1061             if (ownership.addr != address(0)) {
1062                 return ownership;
1063             }
1064         }
1065 
1066         revert('ERC721A: unable to determine the owner of token');
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-ownerOf}.
1071      */
1072     function ownerOf(uint256 tokenId) public view override returns (address) {
1073         return ownershipOf(tokenId).addr;
1074     }
1075 
1076     /**
1077      * @dev See {IERC721Metadata-name}.
1078      */
1079     function name() public view virtual override returns (string memory) {
1080         return _name;
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Metadata-symbol}.
1085      */
1086     function symbol() public view virtual override returns (string memory) {
1087         return _symbol;
1088     }
1089 
1090     /**
1091      * @dev See {IERC721Metadata-tokenURI}.
1092      */
1093     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1094         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1095 
1096         string memory baseURI = _baseURI();
1097         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1098     }
1099 
1100     /**
1101      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1102      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1103      * by default, can be overriden in child contracts.
1104      */
1105     function _baseURI() internal view virtual returns (string memory) {
1106         return '';
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-approve}.
1111      */
1112     function approve(address to, uint256 tokenId) public override {
1113         address owner = ERC721A.ownerOf(tokenId);
1114         require(to != owner, 'ERC721A: approval to current owner');
1115 
1116         require(
1117             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1118             'ERC721A: approve caller is not owner nor approved for all'
1119         );
1120 
1121         _approve(to, tokenId, owner);
1122     }
1123 
1124     /**
1125      * @dev See {IERC721-getApproved}.
1126      */
1127     function getApproved(uint256 tokenId) public view override returns (address) {
1128         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1129 
1130         return _tokenApprovals[tokenId];
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-setApprovalForAll}.
1135      */
1136     function setApprovalForAll(address operator, bool approved) public override {
1137         require(operator != _msgSender(), 'ERC721A: approve to caller');
1138 
1139         _operatorApprovals[_msgSender()][operator] = approved;
1140         emit ApprovalForAll(_msgSender(), operator, approved);
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-isApprovedForAll}.
1145      */
1146     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1147         return _operatorApprovals[owner][operator];
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-transferFrom}.
1152      */
1153     function transferFrom(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) public override {
1158         _transfer(from, to, tokenId);
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-safeTransferFrom}.
1163      */
1164     function safeTransferFrom(
1165         address from,
1166         address to,
1167         uint256 tokenId
1168     ) public override {
1169         safeTransferFrom(from, to, tokenId, '');
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-safeTransferFrom}.
1174      */
1175     function safeTransferFrom(
1176         address from,
1177         address to,
1178         uint256 tokenId,
1179         bytes memory _data
1180     ) public override {
1181         _transfer(from, to, tokenId);
1182         require(
1183             _checkOnERC721Received(from, to, tokenId, _data),
1184             'ERC721A: transfer to non ERC721Receiver implementer'
1185         );
1186     }
1187 
1188     /**
1189      * @dev Returns whether `tokenId` exists.
1190      *
1191      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1192      *
1193      * Tokens start existing when they are minted (`_mint`),
1194      */
1195     function _exists(uint256 tokenId) internal view returns (bool) {
1196         return tokenId < currentIndex;
1197     }
1198 
1199     function _safeMint(address to, uint256 quantity) internal {
1200         _safeMint(to, quantity, '');
1201     }
1202 
1203     /**
1204      * @dev Mints `quantity` tokens and transfers them to `to`.
1205      *
1206      * Requirements:
1207      *
1208      * - `to` cannot be the zero address.
1209      * - `quantity` cannot be larger than the max batch size.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _safeMint(
1214         address to,
1215         uint256 quantity,
1216         bytes memory _data
1217     ) internal {
1218         uint256 startTokenId = currentIndex;
1219         require(to != address(0), 'ERC721A: mint to the zero address');
1220         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1221         require(!_exists(startTokenId), 'ERC721A: token already minted');
1222         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1223         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1224 
1225         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1226 
1227         AddressData memory addressData = _addressData[to];
1228         _addressData[to] = AddressData(
1229             addressData.balance + uint128(quantity),
1230             addressData.numberMinted + uint128(quantity)
1231         );
1232         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1233 
1234         uint256 updatedIndex = startTokenId;
1235 
1236         for (uint256 i = 0; i < quantity; i++) {
1237             emit Transfer(address(0), to, updatedIndex);
1238             require(
1239                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1240                 'ERC721A: transfer to non ERC721Receiver implementer'
1241             );
1242             updatedIndex++;
1243         }
1244 
1245         currentIndex = updatedIndex;
1246         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1247     }
1248 
1249     /**
1250      * @dev Transfers `tokenId` from `from` to `to`.
1251      *
1252      * Requirements:
1253      *
1254      * - `to` cannot be the zero address.
1255      * - `tokenId` token must be owned by `from`.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _transfer(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) private {
1264         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1265 
1266         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1267             getApproved(tokenId) == _msgSender() ||
1268             isApprovedForAll(prevOwnership.addr, _msgSender()));
1269 
1270         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1271 
1272         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1273         require(to != address(0), 'ERC721A: transfer to the zero address');
1274 
1275         _beforeTokenTransfers(from, to, tokenId, 1);
1276 
1277         // Clear approvals from the previous owner
1278         _approve(address(0), tokenId, prevOwnership.addr);
1279 
1280         // Underflow of the sender's balance is impossible because we check for
1281         // ownership above and the recipient's balance can't realistically overflow.
1282         unchecked {
1283             _addressData[from].balance -= 1;
1284             _addressData[to].balance += 1;
1285         }
1286 
1287         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1288 
1289         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1290         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1291         uint256 nextTokenId = tokenId + 1;
1292         if (_ownerships[nextTokenId].addr == address(0)) {
1293             if (_exists(nextTokenId)) {
1294                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1295             }
1296         }
1297 
1298         emit Transfer(from, to, tokenId);
1299         _afterTokenTransfers(from, to, tokenId, 1);
1300     }
1301 
1302     /**
1303      * @dev Approve `to` to operate on `tokenId`
1304      *
1305      * Emits a {Approval} event.
1306      */
1307     function _approve(
1308         address to,
1309         uint256 tokenId,
1310         address owner
1311     ) private {
1312         _tokenApprovals[tokenId] = to;
1313         emit Approval(owner, to, tokenId);
1314     }
1315 
1316     /**
1317      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1318      * The call is not executed if the target address is not a contract.
1319      *
1320      * @param from address representing the previous owner of the given token ID
1321      * @param to target address that will receive the tokens
1322      * @param tokenId uint256 ID of the token to be transferred
1323      * @param _data bytes optional data to send along with the call
1324      * @return bool whether the call correctly returned the expected magic value
1325      */
1326     function _checkOnERC721Received(
1327         address from,
1328         address to,
1329         uint256 tokenId,
1330         bytes memory _data
1331     ) private returns (bool) {
1332         if (to.isContract()) {
1333             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1334                 return retval == IERC721Receiver(to).onERC721Received.selector;
1335             } catch (bytes memory reason) {
1336                 if (reason.length == 0) {
1337                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1338                 } else {
1339                     assembly {
1340                         revert(add(32, reason), mload(reason))
1341                     }
1342                 }
1343             }
1344         } else {
1345             return true;
1346         }
1347     }
1348 
1349     /**
1350      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1351      *
1352      * startTokenId - the first token id to be transferred
1353      * quantity - the amount to be transferred
1354      *
1355      * Calling conditions:
1356      *
1357      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1358      * transferred to `to`.
1359      * - When `from` is zero, `tokenId` will be minted for `to`.
1360      */
1361     function _beforeTokenTransfers(
1362         address from,
1363         address to,
1364         uint256 startTokenId,
1365         uint256 quantity
1366     ) internal virtual {}
1367 
1368     /**
1369      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1370      * minting.
1371      *
1372      * startTokenId - the first token id to be transferred
1373      * quantity - the amount to be transferred
1374      *
1375      * Calling conditions:
1376      *
1377      * - when `from` and `to` are both non-zero.
1378      * - `from` and `to` are never both zero.
1379      */
1380     function _afterTokenTransfers(
1381         address from,
1382         address to,
1383         uint256 startTokenId,
1384         uint256 quantity
1385     ) internal virtual {}
1386 }
1387 
1388 // File: contracts/NonblockingReceiver.sol
1389 
1390 pragma solidity ^0.8.6;
1391 
1392 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1393     ILayerZeroEndpoint internal endpoint;
1394 
1395     struct FailedMessages {
1396         uint256 payloadLength;
1397         bytes32 payloadHash;
1398     }
1399 
1400     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1401         public failedMessages;
1402     mapping(uint16 => bytes) public trustedRemoteLookup;
1403 
1404     event MessageFailed(
1405         uint16 _srcChainId,
1406         bytes _srcAddress,
1407         uint64 _nonce,
1408         bytes _payload
1409     );
1410 
1411     function lzReceive(
1412         uint16 _srcChainId,
1413         bytes memory _srcAddress,
1414         uint64 _nonce,
1415         bytes memory _payload
1416     ) external override {
1417         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1418         require(
1419             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1420                 keccak256(_srcAddress) ==
1421                 keccak256(trustedRemoteLookup[_srcChainId]),
1422             "NonblockingReceiver: invalid source sending contract"
1423         );
1424 
1425         // try-catch all errors/exceptions
1426         // having failed messages does not block messages passing
1427         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1428             // do nothing
1429         } catch {
1430             // error / exception
1431             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1432                 _payload.length,
1433                 keccak256(_payload)
1434             );
1435             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1436         }
1437     }
1438 
1439     function onLzReceive(
1440         uint16 _srcChainId,
1441         bytes memory _srcAddress,
1442         uint64 _nonce,
1443         bytes memory _payload
1444     ) public {
1445         // only internal transaction
1446         require(
1447             msg.sender == address(this),
1448             "NonblockingReceiver: caller must be Bridge."
1449         );
1450 
1451         // handle incoming message
1452         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1453     }
1454 
1455     // abstract function
1456     function _LzReceive(
1457         uint16 _srcChainId,
1458         bytes memory _srcAddress,
1459         uint64 _nonce,
1460         bytes memory _payload
1461     ) internal virtual;
1462 
1463     function _lzSend(
1464         uint16 _dstChainId,
1465         bytes memory _payload,
1466         address payable _refundAddress,
1467         address _zroPaymentAddress,
1468         bytes memory _txParam
1469     ) internal {
1470         endpoint.send{value: msg.value}(
1471             _dstChainId,
1472             trustedRemoteLookup[_dstChainId],
1473             _payload,
1474             _refundAddress,
1475             _zroPaymentAddress,
1476             _txParam
1477         );
1478     }
1479 
1480     function retryMessage(
1481         uint16 _srcChainId,
1482         bytes memory _srcAddress,
1483         uint64 _nonce,
1484         bytes calldata _payload
1485     ) external payable {
1486         // assert there is message to retry
1487         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1488             _srcAddress
1489         ][_nonce];
1490         require(
1491             failedMsg.payloadHash != bytes32(0),
1492             "NonblockingReceiver: no stored message"
1493         );
1494         require(
1495             _payload.length == failedMsg.payloadLength &&
1496                 keccak256(_payload) == failedMsg.payloadHash,
1497             "LayerZero: invalid payload"
1498         );
1499         // clear the stored message
1500         failedMsg.payloadLength = 0;
1501         failedMsg.payloadHash = bytes32(0);
1502         // execute the message. revert if it fails again
1503         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1504     }
1505 
1506     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1507         external
1508         onlyOwner
1509     {
1510         trustedRemoteLookup[_chainId] = _trustedRemote;
1511     }
1512 }
1513 
1514 pragma solidity ^0.8.7;
1515 
1516 contract tinyghosts is ERC721A, Ownable {
1517   using Strings for uint256;
1518 
1519   string private uriPrefix = "";
1520   string private uriSuffix = ".json";
1521   string public hiddenMetadataUri;
1522   
1523   uint256 public price = 0 ether; 
1524   uint256 public maxSupply = 2000; 
1525   uint256 public maxMintAmountPerTx = 2; 
1526   
1527   bool public paused = true;
1528   bool public revealed = false;
1529   mapping(address => uint256) public addressMintedBalance;
1530 
1531 
1532   constructor() ERC721A("tiny ghosts", "ghosts", maxMintAmountPerTx) {
1533     setHiddenMetadataUri("ipfs://QmW7xQ4VJA2ZBcANRJf8bLuudoi72PyhsWMBF4jSE4jyB3");
1534   }
1535 
1536   modifier mintCompliance(uint256 _mintAmount) {
1537     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1538     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1539     _;
1540   }
1541 
1542   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1543    {
1544     require(!paused, "The contract is paused!");
1545     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1546     
1547     
1548     _safeMint(msg.sender, _mintAmount);
1549   }
1550 
1551    
1552   function tinyghoststoAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1553     _safeMint(_to, _mintAmount);
1554   }
1555 
1556  
1557   function walletOfOwner(address _owner)
1558     public
1559     view
1560     returns (uint256[] memory)
1561   {
1562     uint256 ownerTokenCount = balanceOf(_owner);
1563     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1564     uint256 currentTokenId = 0;
1565     uint256 ownedTokenIndex = 0;
1566 
1567     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1568       address currentTokenOwner = ownerOf(currentTokenId);
1569 
1570       if (currentTokenOwner == _owner) {
1571         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1572 
1573         ownedTokenIndex++;
1574       }
1575 
1576       currentTokenId++;
1577     }
1578 
1579     return ownedTokenIds;
1580   }
1581 
1582   function tokenURI(uint256 _tokenId)
1583     public
1584     view
1585     virtual
1586     override
1587     returns (string memory)
1588   {
1589     require(
1590       _exists(_tokenId),
1591       "ERC721Metadata: URI query for nonexistent token"
1592     );
1593 
1594     if (revealed == false) {
1595       return hiddenMetadataUri;
1596     }
1597 
1598     string memory currentBaseURI = _baseURI();
1599     return bytes(currentBaseURI).length > 0
1600         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1601         : "";
1602   }
1603 
1604   function setRevealed(bool _state) public onlyOwner {
1605     revealed = _state;
1606   
1607   }
1608 
1609   function setPrice(uint256 _price) public onlyOwner {
1610     price = _price;
1611 
1612   }
1613  
1614   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1615     hiddenMetadataUri = _hiddenMetadataUri;
1616   }
1617 
1618 
1619 
1620   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1621     uriPrefix = _uriPrefix;
1622   }
1623 
1624   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1625     uriSuffix = _uriSuffix;
1626   }
1627 
1628   function setPaused(bool _state) public onlyOwner {
1629     paused = _state;
1630   }
1631 
1632   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1633       _safeMint(_receiver, _mintAmount);
1634   }
1635 
1636   function _baseURI() internal view virtual override returns (string memory) {
1637     return uriPrefix;
1638     
1639   }
1640 
1641     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1642     maxMintAmountPerTx = _maxMintAmountPerTx;
1643 
1644   }
1645 
1646     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1647     maxSupply = _maxSupply;
1648 
1649   }
1650 
1651 
1652   // withdrawall addresses
1653   address t1 = 0x3d8fAFCc27eA6FA0D582786e191695707C9D690a; 
1654   
1655 
1656   function withdrawall() public onlyOwner {
1657         uint256 _balance = address(this).balance;
1658         
1659         require(payable(t1).send(_balance * 100 / 100 ));
1660         
1661     }
1662 
1663   function withdraw() public onlyOwner {
1664     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1665     require(os);
1666     
1667 
1668  
1669   }
1670 }