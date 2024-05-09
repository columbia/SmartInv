1 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface ILayerZeroUserApplicationConfig {
6     // @notice set the configuration of the LayerZero messaging library of the specified version
7     // @param _version - messaging library version
8     // @param _chainId - the chainId for the pending config change
9     // @param _configType - type of configuration. every messaging library has its own convention.
10     // @param _config - configuration in the bytes. can encode arbitrary content.
11     function setConfig(
12         uint16 _version,
13         uint16 _chainId,
14         uint256 _configType,
15         bytes calldata _config
16     ) external;
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
29     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
30         external;
31 }
32 
33 // File: contracts/interfaces/ILayerZeroEndpoint.sol
34 
35 pragma solidity >=0.5.0;
36 
37 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
38     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
39     // @param _dstChainId - the destination chain identifier
40     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
41     // @param _payload - a custom bytes payload to send to the destination contract
42     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
43     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
44     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
45     function send(
46         uint16 _dstChainId,
47         bytes calldata _destination,
48         bytes calldata _payload,
49         address payable _refundAddress,
50         address _zroPaymentAddress,
51         bytes calldata _adapterParams
52     ) external payable;
53 
54     // @notice used by the messaging library to publish verified payload
55     // @param _srcChainId - the source chain identifier
56     // @param _srcAddress - the source contract (as bytes) at the source chain
57     // @param _dstAddress - the address on destination chain
58     // @param _nonce - the unbound message ordering nonce
59     // @param _gasLimit - the gas limit for external contract execution
60     // @param _payload - verified payload to send to the destination contract
61     function receivePayload(
62         uint16 _srcChainId,
63         bytes calldata _srcAddress,
64         address _dstAddress,
65         uint64 _nonce,
66         uint256 _gasLimit,
67         bytes calldata _payload
68     ) external;
69 
70     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
71     // @param _srcChainId - the source chain identifier
72     // @param _srcAddress - the source chain contract address
73     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress)
74         external
75         view
76         returns (uint64);
77 
78     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
79     // @param _srcAddress - the source chain contract address
80     function getOutboundNonce(uint16 _dstChainId, address _srcAddress)
81         external
82         view
83         returns (uint64);
84 
85     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
86     // @param _dstChainId - the destination chain identifier
87     // @param _userApplication - the user app address on this EVM chain
88     // @param _payload - the custom message to send over LayerZero
89     // @param _payInZRO - if false, user app pays the protocol fee in native token
90     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
91     function estimateFees(
92         uint16 _dstChainId,
93         address _userApplication,
94         bytes calldata _payload,
95         bool _payInZRO,
96         bytes calldata _adapterParam
97     ) external view returns (uint256 nativeFee, uint256 zroFee);
98 
99     // @notice get this Endpoint's immutable source identifier
100     function getChainId() external view returns (uint16);
101 
102     // @notice the interface to retry failed message on this Endpoint destination
103     // @param _srcChainId - the source chain identifier
104     // @param _srcAddress - the source chain contract address
105     // @param _payload - the payload to be retried
106     function retryPayload(
107         uint16 _srcChainId,
108         bytes calldata _srcAddress,
109         bytes calldata _payload
110     ) external;
111 
112     // @notice query if any STORED payload (message blocking) at the endpoint.
113     // @param _srcChainId - the source chain identifier
114     // @param _srcAddress - the source chain contract address
115     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress)
116         external
117         view
118         returns (bool);
119 
120     // @notice query if the _libraryAddress is valid for sending msgs.
121     // @param _userApplication - the user app address on this EVM chain
122     function getSendLibraryAddress(address _userApplication)
123         external
124         view
125         returns (address);
126 
127     // @notice query if the _libraryAddress is valid for receiving msgs.
128     // @param _userApplication - the user app address on this EVM chain
129     function getReceiveLibraryAddress(address _userApplication)
130         external
131         view
132         returns (address);
133 
134     // @notice query if the non-reentrancy guard for send() is on
135     // @return true if the guard is on. false otherwise
136     function isSendingPayload() external view returns (bool);
137 
138     // @notice query if the non-reentrancy guard for receive() is on
139     // @return true if the guard is on. false otherwise
140     function isReceivingPayload() external view returns (bool);
141 
142     // @notice get the configuration of the LayerZero messaging library of the specified version
143     // @param _version - messaging library version
144     // @param _chainId - the chainId for the pending config change
145     // @param _userApplication - the contract address of the user application
146     // @param _configType - type of configuration. every messaging library has its own convention.
147     function getConfig(
148         uint16 _version,
149         uint16 _chainId,
150         address _userApplication,
151         uint256 _configType
152     ) external view returns (bytes memory);
153 
154     // @notice get the send() LayerZero messaging library version
155     // @param _userApplication - the contract address of the user application
156     function getSendVersion(address _userApplication)
157         external
158         view
159         returns (uint16);
160 
161     // @notice get the lzReceive() LayerZero messaging library version
162     // @param _userApplication - the contract address of the user application
163     function getReceiveVersion(address _userApplication)
164         external
165         view
166         returns (uint16);
167 }
168 
169 // File: contracts/interfaces/ILayerZeroReceiver.sol
170 
171 pragma solidity >=0.5.0;
172 
173 interface ILayerZeroReceiver {
174     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
175     // @param _srcChainId - the source endpoint identifier
176     // @param _srcAddress - the source sending contract address from the source chain
177     // @param _nonce - the ordered message nonce
178     // @param _payload - the signed payload is the UA bytes has encoded to be sent
179     function lzReceive(
180         uint16 _srcChainId,
181         bytes calldata _srcAddress,
182         uint64 _nonce,
183         bytes calldata _payload
184     ) external;
185 }
186 // File: @openzeppelin/contracts/utils/Strings.sol
187 
188 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev String operations.
194  */
195 library Strings {
196     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
197 
198     /**
199      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
200      */
201     function toString(uint256 value) internal pure returns (string memory) {
202         // Inspired by OraclizeAPI's implementation - MIT licence
203         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
204 
205         if (value == 0) {
206             return "0";
207         }
208         uint256 temp = value;
209         uint256 digits;
210         while (temp != 0) {
211             digits++;
212             temp /= 10;
213         }
214         bytes memory buffer = new bytes(digits);
215         while (value != 0) {
216             digits -= 1;
217             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
218             value /= 10;
219         }
220         return string(buffer);
221     }
222 
223     /**
224      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
225      */
226     function toHexString(uint256 value) internal pure returns (string memory) {
227         if (value == 0) {
228             return "0x00";
229         }
230         uint256 temp = value;
231         uint256 length = 0;
232         while (temp != 0) {
233             length++;
234             temp >>= 8;
235         }
236         return toHexString(value, length);
237     }
238 
239     /**
240      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
241      */
242     function toHexString(uint256 value, uint256 length)
243         internal
244         pure
245         returns (string memory)
246     {
247         bytes memory buffer = new bytes(2 * length + 2);
248         buffer[0] = "0";
249         buffer[1] = "x";
250         for (uint256 i = 2 * length + 1; i > 1; --i) {
251             buffer[i] = _HEX_SYMBOLS[value & 0xf];
252             value >>= 4;
253         }
254         require(value == 0, "Strings: hex length insufficient");
255         return string(buffer);
256     }
257 }
258 
259 // File: @openzeppelin/contracts/utils/Context.sol
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Provides information about the current execution context, including the
267  * sender of the transaction and its data. While these are generally available
268  * via msg.sender and msg.data, they should not be accessed in such a direct
269  * manner, since when dealing with meta-transactions the account sending and
270  * paying for execution may not be the actual sender (as far as an application
271  * is concerned).
272  *
273  * This contract is only required for intermediate, library-like contracts.
274  */
275 abstract contract Context {
276     function _msgSender() internal view virtual returns (address) {
277         return msg.sender;
278     }
279 
280     function _msgData() internal view virtual returns (bytes calldata) {
281         return msg.data;
282     }
283 }
284 
285 // File: @openzeppelin/contracts/access/Ownable.sol
286 
287 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev Contract module which provides a basic access control mechanism, where
293  * there is an account (an owner) that can be granted exclusive access to
294  * specific functions.
295  *
296  * By default, the owner account will be the one that deploys the contract. This
297  * can later be changed with {transferOwnership}.
298  *
299  * This module is used through inheritance. It will make available the modifier
300  * `onlyOwner`, which can be applied to your functions to restrict their use to
301  * the owner.
302  */
303 abstract contract Ownable is Context {
304     address private _owner;
305 
306     event OwnershipTransferred(
307         address indexed previousOwner,
308         address indexed newOwner
309     );
310 
311     /**
312      * @dev Initializes the contract setting the deployer as the initial owner.
313      */
314     constructor() {
315         _transferOwnership(_msgSender());
316     }
317 
318     /**
319      * @dev Returns the address of the current owner.
320      */
321     function owner() public view virtual returns (address) {
322         return _owner;
323     }
324 
325     /**
326      * @dev Throws if called by any account other than the owner.
327      */
328     modifier onlyOwner() {
329         require(owner() == _msgSender(), "Ownable: caller is not the owner");
330         _;
331     }
332 
333     /**
334      * @dev Leaves the contract without owner. It will not be possible to call
335      * `onlyOwner` functions anymore. Can only be called by the current owner.
336      *
337      * NOTE: Renouncing ownership will leave the contract without an owner,
338      * thereby removing any functionality that is only available to the owner.
339      */
340     function renounceOwnership() public virtual onlyOwner {
341         _transferOwnership(address(0));
342     }
343 
344     /**
345      * @dev Transfers ownership of the contract to a new account (`newOwner`).
346      * Can only be called by the current owner.
347      */
348     function transferOwnership(address newOwner) public virtual onlyOwner {
349         require(
350             newOwner != address(0),
351             "Ownable: new owner is the zero address"
352         );
353         _transferOwnership(newOwner);
354     }
355 
356     /**
357      * @dev Transfers ownership of the contract to a new account (`newOwner`).
358      * Internal function without access restriction.
359      */
360     function _transferOwnership(address newOwner) internal virtual {
361         address oldOwner = _owner;
362         _owner = newOwner;
363         emit OwnershipTransferred(oldOwner, newOwner);
364     }
365 }
366 
367 // File: @openzeppelin/contracts/utils/Address.sol
368 
369 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @dev Collection of functions related to the address type
375  */
376 library Address {
377     /**
378      * @dev Returns true if `account` is a contract.
379      *
380      * [IMPORTANT]
381      * ====
382      * It is unsafe to assume that an address for which this function returns
383      * false is an externally-owned account (EOA) and not a contract.
384      *
385      * Among others, `isContract` will return false for the following
386      * types of addresses:
387      *
388      *  - an externally-owned account
389      *  - a contract in construction
390      *  - an address where a contract will be created
391      *  - an address where a contract lived, but was destroyed
392      * ====
393      */
394     function isContract(address account) internal view returns (bool) {
395         // This method relies on extcodesize, which returns 0 for contracts in
396         // construction, since the code is only stored at the end of the
397         // constructor execution.
398 
399         uint256 size;
400         assembly {
401             size := extcodesize(account)
402         }
403         return size > 0;
404     }
405 
406     /**
407      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
408      * `recipient`, forwarding all available gas and reverting on errors.
409      *
410      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
411      * of certain opcodes, possibly making contracts go over the 2300 gas limit
412      * imposed by `transfer`, making them unable to receive funds via
413      * `transfer`. {sendValue} removes this limitation.
414      *
415      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
416      *
417      * IMPORTANT: because control is transferred to `recipient`, care must be
418      * taken to not create reentrancy vulnerabilities. Consider using
419      * {ReentrancyGuard} or the
420      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
421      */
422     function sendValue(address payable recipient, uint256 amount) internal {
423         require(
424             address(this).balance >= amount,
425             "Address: insufficient balance"
426         );
427 
428         (bool success, ) = recipient.call{value: amount}("");
429         require(
430             success,
431             "Address: unable to send value, recipient may have reverted"
432         );
433     }
434 
435     /**
436      * @dev Performs a Solidity function call using a low level `call`. A
437      * plain `call` is an unsafe replacement for a function call: use this
438      * function instead.
439      *
440      * If `target` reverts with a revert reason, it is bubbled up by this
441      * function (like regular Solidity function calls).
442      *
443      * Returns the raw returned data. To convert to the expected return value,
444      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
445      *
446      * Requirements:
447      *
448      * - `target` must be a contract.
449      * - calling `target` with `data` must not revert.
450      *
451      * _Available since v3.1._
452      */
453     function functionCall(address target, bytes memory data)
454         internal
455         returns (bytes memory)
456     {
457         return functionCall(target, data, "Address: low-level call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
462      * `errorMessage` as a fallback revert reason when `target` reverts.
463      *
464      * _Available since v3.1._
465      */
466     function functionCall(
467         address target,
468         bytes memory data,
469         string memory errorMessage
470     ) internal returns (bytes memory) {
471         return functionCallWithValue(target, data, 0, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but also transferring `value` wei to `target`.
477      *
478      * Requirements:
479      *
480      * - the calling contract must have an ETH balance of at least `value`.
481      * - the called Solidity function must be `payable`.
482      *
483      * _Available since v3.1._
484      */
485     function functionCallWithValue(
486         address target,
487         bytes memory data,
488         uint256 value
489     ) internal returns (bytes memory) {
490         return
491             functionCallWithValue(
492                 target,
493                 data,
494                 value,
495                 "Address: low-level call with value failed"
496             );
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
501      * with `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCallWithValue(
506         address target,
507         bytes memory data,
508         uint256 value,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         require(
512             address(this).balance >= value,
513             "Address: insufficient balance for call"
514         );
515         require(isContract(target), "Address: call to non-contract");
516 
517         (bool success, bytes memory returndata) = target.call{value: value}(
518             data
519         );
520         return verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
525      * but performing a static call.
526      *
527      * _Available since v3.3._
528      */
529     function functionStaticCall(address target, bytes memory data)
530         internal
531         view
532         returns (bytes memory)
533     {
534         return
535             functionStaticCall(
536                 target,
537                 data,
538                 "Address: low-level static call failed"
539             );
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
544      * but performing a static call.
545      *
546      * _Available since v3.3._
547      */
548     function functionStaticCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal view returns (bytes memory) {
553         require(isContract(target), "Address: static call to non-contract");
554 
555         (bool success, bytes memory returndata) = target.staticcall(data);
556         return verifyCallResult(success, returndata, errorMessage);
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but performing a delegate call.
562      *
563      * _Available since v3.4._
564      */
565     function functionDelegateCall(address target, bytes memory data)
566         internal
567         returns (bytes memory)
568     {
569         return
570             functionDelegateCall(
571                 target,
572                 data,
573                 "Address: low-level delegate call failed"
574             );
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
579      * but performing a delegate call.
580      *
581      * _Available since v3.4._
582      */
583     function functionDelegateCall(
584         address target,
585         bytes memory data,
586         string memory errorMessage
587     ) internal returns (bytes memory) {
588         require(isContract(target), "Address: delegate call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.delegatecall(data);
591         return verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
596      * revert reason using the provided one.
597      *
598      * _Available since v4.3._
599      */
600     function verifyCallResult(
601         bool success,
602         bytes memory returndata,
603         string memory errorMessage
604     ) internal pure returns (bytes memory) {
605         if (success) {
606             return returndata;
607         } else {
608             // Look for revert reason and bubble it up if present
609             if (returndata.length > 0) {
610                 // The easiest way to bubble the revert reason is using memory via assembly
611 
612                 assembly {
613                     let returndata_size := mload(returndata)
614                     revert(add(32, returndata), returndata_size)
615                 }
616             } else {
617                 revert(errorMessage);
618             }
619         }
620     }
621 }
622 
623 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
624 
625 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @title ERC721 token receiver interface
631  * @dev Interface for any contract that wants to support safeTransfers
632  * from ERC721 asset contracts.
633  */
634 interface IERC721Receiver {
635     /**
636      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
637      * by `operator` from `from`, this function is called.
638      *
639      * It must return its Solidity selector to confirm the token transfer.
640      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
641      *
642      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
643      */
644     function onERC721Received(
645         address operator,
646         address from,
647         uint256 tokenId,
648         bytes calldata data
649     ) external returns (bytes4);
650 }
651 
652 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
653 
654 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Interface of the ERC165 standard, as defined in the
660  * https://eips.ethereum.org/EIPS/eip-165[EIP].
661  *
662  * Implementers can declare support of contract interfaces, which can then be
663  * queried by others ({ERC165Checker}).
664  *
665  * For an implementation, see {ERC165}.
666  */
667 interface IERC165 {
668     /**
669      * @dev Returns true if this contract implements the interface defined by
670      * `interfaceId`. See the corresponding
671      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
672      * to learn more about how these ids are created.
673      *
674      * This function call must use less than 30 000 gas.
675      */
676     function supportsInterface(bytes4 interfaceId) external view returns (bool);
677 }
678 
679 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
680 
681 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 /**
686  * @dev Implementation of the {IERC165} interface.
687  *
688  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
689  * for the additional interface id that will be supported. For example:
690  *
691  * ```solidity
692  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
694  * }
695  * ```
696  *
697  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
698  */
699 abstract contract ERC165 is IERC165 {
700     /**
701      * @dev See {IERC165-supportsInterface}.
702      */
703     function supportsInterface(bytes4 interfaceId)
704         public
705         view
706         virtual
707         override
708         returns (bool)
709     {
710         return interfaceId == type(IERC165).interfaceId;
711     }
712 }
713 
714 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
715 
716 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 /**
721  * @dev Required interface of an ERC721 compliant contract.
722  */
723 interface IERC721 is IERC165 {
724     /**
725      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
726      */
727     event Transfer(
728         address indexed from,
729         address indexed to,
730         uint256 indexed tokenId
731     );
732 
733     /**
734      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
735      */
736     event Approval(
737         address indexed owner,
738         address indexed approved,
739         uint256 indexed tokenId
740     );
741 
742     /**
743      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
744      */
745     event ApprovalForAll(
746         address indexed owner,
747         address indexed operator,
748         bool approved
749     );
750 
751     /**
752      * @dev Returns the number of tokens in ``owner``'s account.
753      */
754     function balanceOf(address owner) external view returns (uint256 balance);
755 
756     /**
757      * @dev Returns the owner of the `tokenId` token.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function ownerOf(uint256 tokenId) external view returns (address owner);
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
767      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId
783     ) external;
784 
785     /**
786      * @dev Transfers `tokenId` token from `from` to `to`.
787      *
788      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must be owned by `from`.
795      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
796      *
797      * Emits a {Transfer} event.
798      */
799     function transferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) external;
804 
805     /**
806      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
807      * The approval is cleared when the token is transferred.
808      *
809      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
810      *
811      * Requirements:
812      *
813      * - The caller must own the token or be an approved operator.
814      * - `tokenId` must exist.
815      *
816      * Emits an {Approval} event.
817      */
818     function approve(address to, uint256 tokenId) external;
819 
820     /**
821      * @dev Returns the account approved for `tokenId` token.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must exist.
826      */
827     function getApproved(uint256 tokenId)
828         external
829         view
830         returns (address operator);
831 
832     /**
833      * @dev Approve or remove `operator` as an operator for the caller.
834      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
835      *
836      * Requirements:
837      *
838      * - The `operator` cannot be the caller.
839      *
840      * Emits an {ApprovalForAll} event.
841      */
842     function setApprovalForAll(address operator, bool _approved) external;
843 
844     /**
845      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
846      *
847      * See {setApprovalForAll}
848      */
849     function isApprovedForAll(address owner, address operator)
850         external
851         view
852         returns (bool);
853 
854     /**
855      * @dev Safely transfers `tokenId` token from `from` to `to`.
856      *
857      * Requirements:
858      *
859      * - `from` cannot be the zero address.
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must exist and be owned by `from`.
862      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
864      *
865      * Emits a {Transfer} event.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes calldata data
872     ) external;
873 }
874 
875 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
876 
877 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
878 
879 pragma solidity ^0.8.0;
880 
881 /**
882  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
883  * @dev See https://eips.ethereum.org/EIPS/eip-721
884  */
885 interface IERC721Metadata is IERC721 {
886     /**
887      * @dev Returns the token collection name.
888      */
889     function name() external view returns (string memory);
890 
891     /**
892      * @dev Returns the token collection symbol.
893      */
894     function symbol() external view returns (string memory);
895 
896     /**
897      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
898      */
899     function tokenURI(uint256 tokenId) external view returns (string memory);
900 }
901 
902 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
903 
904 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
905 
906 pragma solidity ^0.8.0;
907 
908 /**
909  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
910  * the Metadata extension, but not including the Enumerable extension, which is available separately as
911  * {ERC721Enumerable}.
912  */
913 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
914     using Address for address;
915     using Strings for uint256;
916 
917     // Token name
918     string private _name;
919 
920     // Token symbol
921     string private _symbol;
922 
923     // Mapping from token ID to owner address
924     mapping(uint256 => address) private _owners;
925 
926     // Mapping owner address to token count
927     mapping(address => uint256) private _balances;
928 
929     // Mapping from token ID to approved address
930     mapping(uint256 => address) private _tokenApprovals;
931 
932     // Mapping from owner to operator approvals
933     mapping(address => mapping(address => bool)) private _operatorApprovals;
934 
935     /**
936      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
937      */
938     constructor(string memory name_, string memory symbol_) {
939         _name = name_;
940         _symbol = symbol_;
941     }
942 
943     /**
944      * @dev See {IERC165-supportsInterface}.
945      */
946     function supportsInterface(bytes4 interfaceId)
947         public
948         view
949         virtual
950         override(ERC165, IERC165)
951         returns (bool)
952     {
953         return
954             interfaceId == type(IERC721).interfaceId ||
955             interfaceId == type(IERC721Metadata).interfaceId ||
956             super.supportsInterface(interfaceId);
957     }
958 
959     /**
960      * @dev See {IERC721-balanceOf}.
961      */
962     function balanceOf(address owner)
963         public
964         view
965         virtual
966         override
967         returns (uint256)
968     {
969         require(
970             owner != address(0),
971             "ERC721: balance query for the zero address"
972         );
973         return _balances[owner];
974     }
975 
976     /**
977      * @dev See {IERC721-ownerOf}.
978      */
979     function ownerOf(uint256 tokenId)
980         public
981         view
982         virtual
983         override
984         returns (address)
985     {
986         address owner = _owners[tokenId];
987         require(
988             owner != address(0),
989             "ERC721: owner query for nonexistent token"
990         );
991         return owner;
992     }
993 
994     /**
995      * @dev See {IERC721Metadata-name}.
996      */
997     function name() public view virtual override returns (string memory) {
998         return _name;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Metadata-symbol}.
1003      */
1004     function symbol() public view virtual override returns (string memory) {
1005         return _symbol;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Metadata-tokenURI}.
1010      */
1011     function tokenURI(uint256 tokenId)
1012         public
1013         view
1014         virtual
1015         override
1016         returns (string memory)
1017     {
1018         require(
1019             _exists(tokenId),
1020             "ERC721Metadata: URI query for nonexistent token"
1021         );
1022 
1023         string memory baseURI = _baseURI();
1024         return
1025             bytes(baseURI).length > 0
1026                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1027                 : "";
1028     }
1029 
1030     /**
1031      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1032      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1033      * by default, can be overriden in child contracts.
1034      */
1035     function _baseURI() internal view virtual returns (string memory) {
1036         return "";
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-approve}.
1041      */
1042     function approve(address to, uint256 tokenId) public virtual override {
1043         address owner = ERC721.ownerOf(tokenId);
1044         require(to != owner, "ERC721: approval to current owner");
1045 
1046         require(
1047             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1048             "ERC721: approve caller is not owner nor approved for all"
1049         );
1050 
1051         _approve(to, tokenId);
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-getApproved}.
1056      */
1057     function getApproved(uint256 tokenId)
1058         public
1059         view
1060         virtual
1061         override
1062         returns (address)
1063     {
1064         require(
1065             _exists(tokenId),
1066             "ERC721: approved query for nonexistent token"
1067         );
1068 
1069         return _tokenApprovals[tokenId];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-setApprovalForAll}.
1074      */
1075     function setApprovalForAll(address operator, bool approved)
1076         public
1077         virtual
1078         override
1079     {
1080         _setApprovalForAll(_msgSender(), operator, approved);
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-isApprovedForAll}.
1085      */
1086     function isApprovedForAll(address owner, address operator)
1087         public
1088         view
1089         virtual
1090         override
1091         returns (bool)
1092     {
1093         return _operatorApprovals[owner][operator];
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-transferFrom}.
1098      */
1099     function transferFrom(
1100         address from,
1101         address to,
1102         uint256 tokenId
1103     ) public virtual override {
1104         //solhint-disable-next-line max-line-length
1105         require(
1106             _isApprovedOrOwner(_msgSender(), tokenId),
1107             "ERC721: transfer caller is not owner nor approved"
1108         );
1109 
1110         _transfer(from, to, tokenId);
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-safeTransferFrom}.
1115      */
1116     function safeTransferFrom(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) public virtual override {
1121         safeTransferFrom(from, to, tokenId, "");
1122     }
1123 
1124     /**
1125      * @dev See {IERC721-safeTransferFrom}.
1126      */
1127     function safeTransferFrom(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) public virtual override {
1133         require(
1134             _isApprovedOrOwner(_msgSender(), tokenId),
1135             "ERC721: transfer caller is not owner nor approved"
1136         );
1137         _safeTransfer(from, to, tokenId, _data);
1138     }
1139 
1140     /**
1141      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1142      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1143      *
1144      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1145      *
1146      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1147      * implement alternative mechanisms to perform token transfer, such as signature-based.
1148      *
1149      * Requirements:
1150      *
1151      * - `from` cannot be the zero address.
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must exist and be owned by `from`.
1154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _safeTransfer(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes memory _data
1163     ) internal virtual {
1164         _transfer(from, to, tokenId);
1165         require(
1166             _checkOnERC721Received(from, to, tokenId, _data),
1167             "ERC721: transfer to non ERC721Receiver implementer"
1168         );
1169     }
1170 
1171     /**
1172      * @dev Returns whether `tokenId` exists.
1173      *
1174      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1175      *
1176      * Tokens start existing when they are minted (`_mint`),
1177      * and stop existing when they are burned (`_burn`).
1178      */
1179     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1180         return _owners[tokenId] != address(0);
1181     }
1182 
1183     /**
1184      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1185      *
1186      * Requirements:
1187      *
1188      * - `tokenId` must exist.
1189      */
1190     function _isApprovedOrOwner(address spender, uint256 tokenId)
1191         internal
1192         view
1193         virtual
1194         returns (bool)
1195     {
1196         require(
1197             _exists(tokenId),
1198             "ERC721: operator query for nonexistent token"
1199         );
1200         address owner = ERC721.ownerOf(tokenId);
1201         return (spender == owner ||
1202             getApproved(tokenId) == spender ||
1203             isApprovedForAll(owner, spender));
1204     }
1205 
1206     /**
1207      * @dev Safely mints `tokenId` and transfers it to `to`.
1208      *
1209      * Requirements:
1210      *
1211      * - `tokenId` must not exist.
1212      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function _safeMint(address to, uint256 tokenId) internal virtual {
1217         _safeMint(to, tokenId, "");
1218     }
1219 
1220     /**
1221      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1222      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1223      */
1224     function _safeMint(
1225         address to,
1226         uint256 tokenId,
1227         bytes memory _data
1228     ) internal virtual {
1229         _mint(to, tokenId);
1230         require(
1231             _checkOnERC721Received(address(0), to, tokenId, _data),
1232             "ERC721: transfer to non ERC721Receiver implementer"
1233         );
1234     }
1235 
1236     /**
1237      * @dev Mints `tokenId` and transfers it to `to`.
1238      *
1239      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1240      *
1241      * Requirements:
1242      *
1243      * - `tokenId` must not exist.
1244      * - `to` cannot be the zero address.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function _mint(address to, uint256 tokenId) internal virtual {
1249         require(to != address(0), "ERC721: mint to the zero address");
1250 
1251         _beforeTokenTransfer(address(0), to, tokenId);
1252 
1253         _balances[to] += 1;
1254         _owners[tokenId] = to;
1255 
1256         emit Transfer(address(0), to, tokenId);
1257     }
1258 
1259     /**
1260      * @dev Destroys `tokenId`.
1261      * The approval is cleared when the token is burned.
1262      *
1263      * Requirements:
1264      *
1265      * - `tokenId` must exist.
1266      *
1267      * Emits a {Transfer} event.
1268      */
1269     function _burn(uint256 tokenId) internal virtual {
1270         address owner = ERC721.ownerOf(tokenId);
1271 
1272         _beforeTokenTransfer(owner, address(0), tokenId);
1273 
1274         // Clear approvals
1275         _approve(address(0), tokenId);
1276 
1277         _balances[owner] -= 1;
1278         delete _owners[tokenId];
1279 
1280         emit Transfer(owner, address(0), tokenId);
1281     }
1282 
1283     /**
1284      * @dev Transfers `tokenId` from `from` to `to`.
1285      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1286      *
1287      * Requirements:
1288      *
1289      * - `to` cannot be the zero address.
1290      * - `tokenId` token must be owned by `from`.
1291      *
1292      * Emits a {Transfer} event.
1293      */
1294     function _transfer(
1295         address from,
1296         address to,
1297         uint256 tokenId
1298     ) internal virtual {
1299         require(
1300             ERC721.ownerOf(tokenId) == from,
1301             "ERC721: transfer of token that is not own"
1302         );
1303         require(to != address(0), "ERC721: transfer to the zero address");
1304 
1305         _beforeTokenTransfer(from, to, tokenId);
1306 
1307         // Clear approvals from the previous owner
1308         _approve(address(0), tokenId);
1309 
1310         _balances[from] -= 1;
1311         _balances[to] += 1;
1312         _owners[tokenId] = to;
1313 
1314         emit Transfer(from, to, tokenId);
1315     }
1316 
1317     /**
1318      * @dev Approve `to` to operate on `tokenId`
1319      *
1320      * Emits a {Approval} event.
1321      */
1322     function _approve(address to, uint256 tokenId) internal virtual {
1323         _tokenApprovals[tokenId] = to;
1324         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1325     }
1326 
1327     /**
1328      * @dev Approve `operator` to operate on all of `owner` tokens
1329      *
1330      * Emits a {ApprovalForAll} event.
1331      */
1332     function _setApprovalForAll(
1333         address owner,
1334         address operator,
1335         bool approved
1336     ) internal virtual {
1337         require(owner != operator, "ERC721: approve to caller");
1338         _operatorApprovals[owner][operator] = approved;
1339         emit ApprovalForAll(owner, operator, approved);
1340     }
1341 
1342     /**
1343      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1344      * The call is not executed if the target address is not a contract.
1345      *
1346      * @param from address representing the previous owner of the given token ID
1347      * @param to target address that will receive the tokens
1348      * @param tokenId uint256 ID of the token to be transferred
1349      * @param _data bytes optional data to send along with the call
1350      * @return bool whether the call correctly returned the expected magic value
1351      */
1352     function _checkOnERC721Received(
1353         address from,
1354         address to,
1355         uint256 tokenId,
1356         bytes memory _data
1357     ) private returns (bool) {
1358         if (to.isContract()) {
1359             try
1360                 IERC721Receiver(to).onERC721Received(
1361                     _msgSender(),
1362                     from,
1363                     tokenId,
1364                     _data
1365                 )
1366             returns (bytes4 retval) {
1367                 return retval == IERC721Receiver.onERC721Received.selector;
1368             } catch (bytes memory reason) {
1369                 if (reason.length == 0) {
1370                     revert(
1371                         "ERC721: transfer to non ERC721Receiver implementer"
1372                     );
1373                 } else {
1374                     assembly {
1375                         revert(add(32, reason), mload(reason))
1376                     }
1377                 }
1378             }
1379         } else {
1380             return true;
1381         }
1382     }
1383 
1384     /**
1385      * @dev Hook that is called before any token transfer. This includes minting
1386      * and burning.
1387      *
1388      * Calling conditions:
1389      *
1390      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1391      * transferred to `to`.
1392      * - When `from` is zero, `tokenId` will be minted for `to`.
1393      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1394      * - `from` and `to` are never both zero.
1395      *
1396      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1397      */
1398     function _beforeTokenTransfer(
1399         address from,
1400         address to,
1401         uint256 tokenId
1402     ) internal virtual {}
1403 }
1404 
1405 // File: contracts/NonblockingReceiver.sol
1406 
1407 pragma solidity ^0.8.6;
1408 
1409 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1410     ILayerZeroEndpoint internal endpoint;
1411 
1412     struct FailedMessages {
1413         uint256 payloadLength;
1414         bytes32 payloadHash;
1415     }
1416 
1417     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1418         public failedMessages;
1419     mapping(uint16 => bytes) public trustedRemoteLookup;
1420 
1421     event MessageFailed(
1422         uint16 _srcChainId,
1423         bytes _srcAddress,
1424         uint64 _nonce,
1425         bytes _payload
1426     );
1427 
1428     function lzReceive(
1429         uint16 _srcChainId,
1430         bytes memory _srcAddress,
1431         uint64 _nonce,
1432         bytes memory _payload
1433     ) external override {
1434         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1435         require(
1436             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1437                 keccak256(_srcAddress) ==
1438                 keccak256(trustedRemoteLookup[_srcChainId]),
1439             "NonblockingReceiver: invalid source sending contract"
1440         );
1441 
1442         // try-catch all errors/exceptions
1443         // having failed messages does not block messages passing
1444         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1445             // do nothing
1446         } catch {
1447             // error / exception
1448             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1449                 _payload.length,
1450                 keccak256(_payload)
1451             );
1452             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1453         }
1454     }
1455 
1456     function onLzReceive(
1457         uint16 _srcChainId,
1458         bytes memory _srcAddress,
1459         uint64 _nonce,
1460         bytes memory _payload
1461     ) public {
1462         // only internal transaction
1463         require(
1464             msg.sender == address(this),
1465             "NonblockingReceiver: caller must be Bridge."
1466         );
1467 
1468         // handle incoming message
1469         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1470     }
1471 
1472     // abstract function
1473     function _LzReceive(
1474         uint16 _srcChainId,
1475         bytes memory _srcAddress,
1476         uint64 _nonce,
1477         bytes memory _payload
1478     ) internal virtual;
1479 
1480     function _lzSend(
1481         uint16 _dstChainId,
1482         bytes memory _payload,
1483         address payable _refundAddress,
1484         address _zroPaymentAddress,
1485         bytes memory _txParam
1486     ) internal {
1487         endpoint.send{value: msg.value}(
1488             _dstChainId,
1489             trustedRemoteLookup[_dstChainId],
1490             _payload,
1491             _refundAddress,
1492             _zroPaymentAddress,
1493             _txParam
1494         );
1495     }
1496 
1497     function retryMessage(
1498         uint16 _srcChainId,
1499         bytes memory _srcAddress,
1500         uint64 _nonce,
1501         bytes calldata _payload
1502     ) external payable {
1503         // assert there is message to retry
1504         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1505             _srcAddress
1506         ][_nonce];
1507         require(
1508             failedMsg.payloadHash != bytes32(0),
1509             "NonblockingReceiver: no stored message"
1510         );
1511         require(
1512             _payload.length == failedMsg.payloadLength &&
1513                 keccak256(_payload) == failedMsg.payloadHash,
1514             "LayerZero: invalid payload"
1515         );
1516         // clear the stored message
1517         failedMsg.payloadLength = 0;
1518         failedMsg.payloadHash = bytes32(0);
1519         // execute the message. revert if it fails again
1520         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1521     }
1522 
1523     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1524         external
1525         onlyOwner
1526     {
1527         trustedRemoteLookup[_chainId] = _trustedRemote;
1528     }
1529 }
1530 
1531 // File: contracts/tinydinos-eth.sol
1532 
1533 pragma solidity ^0.8.7;
1534 
1535 contract tinydinos is Ownable, ERC721, NonblockingReceiver {
1536     address public _owner;
1537     string private baseURI;
1538     uint256 nextTokenId = 6512;
1539     uint256 MAX_MINT_ETHEREUM = 10000;
1540 
1541     uint256 gasForDestinationLzReceive = 350000;
1542 
1543     constructor(string memory baseURI_, address _layerZeroEndpoint)
1544         ERC721("tiny dinos", "dino")
1545     {
1546         _owner = msg.sender;
1547         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1548         baseURI = baseURI_;
1549     }
1550 
1551     // mint function
1552     // you can choose to mint 1 or 2
1553     // mint is free, but payments are accepted
1554     function mint(uint8 numTokens) external payable {
1555         require(numTokens < 3, "tiny dinos: Max 2 NFTs per transaction");
1556         require(
1557             nextTokenId + numTokens <= MAX_MINT_ETHEREUM,
1558             "tiny dinos: Mint exceeds supply"
1559         );
1560         _safeMint(msg.sender, ++nextTokenId);
1561         if (numTokens == 2) {
1562             _safeMint(msg.sender, ++nextTokenId);
1563         }
1564     }
1565 
1566     // This function transfers the nft from your address on the
1567     // source chain to the same address on the destination chain
1568     function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1569         require(
1570             msg.sender == ownerOf(tokenId),
1571             "You must own the token to traverse"
1572         );
1573         require(
1574             trustedRemoteLookup[_chainId].length > 0,
1575             "This chain is currently unavailable for travel"
1576         );
1577 
1578         // burn NFT, eliminating it from circulation on src chain
1579         _burn(tokenId);
1580 
1581         // abi.encode() the payload with the values to send
1582         bytes memory payload = abi.encode(msg.sender, tokenId);
1583 
1584         // encode adapterParams to specify more gas for the destination
1585         uint16 version = 1;
1586         bytes memory adapterParams = abi.encodePacked(
1587             version,
1588             gasForDestinationLzReceive
1589         );
1590 
1591         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1592         // you will be refunded for extra gas paid
1593         (uint256 messageFee, ) = endpoint.estimateFees(
1594             _chainId,
1595             address(this),
1596             payload,
1597             false,
1598             adapterParams
1599         );
1600 
1601         require(
1602             msg.value >= messageFee,
1603             "tiny dinos: msg.value not enough to cover messageFee. Send gas for message fees"
1604         );
1605 
1606         endpoint.send{value: msg.value}(
1607             _chainId, // destination chainId
1608             trustedRemoteLookup[_chainId], // destination address of nft contract
1609             payload, // abi.encoded()'ed bytes
1610             payable(msg.sender), // refund address
1611             address(0x0), // 'zroPaymentAddress' unused for this
1612             adapterParams // txParameters
1613         );
1614     }
1615 
1616     function setBaseURI(string memory URI) external onlyOwner {
1617         baseURI = URI;
1618     }
1619 
1620     function donate() external payable {
1621         // thank you
1622     }
1623 
1624     // This allows the devs to receive kind donations
1625     function withdraw(uint256 amt) external onlyOwner {
1626         (bool sent, ) = payable(_owner).call{value: amt}("");
1627         require(sent, "tiny dinos: Failed to withdraw Ether");
1628     }
1629 
1630     // just in case this fixed variable limits us from future integrations
1631     function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1632         gasForDestinationLzReceive = newVal;
1633     }
1634 
1635     // ------------------
1636     // Internal Functions
1637     // ------------------
1638 
1639     function _LzReceive(
1640         uint16 _srcChainId,
1641         bytes memory _srcAddress,
1642         uint64 _nonce,
1643         bytes memory _payload
1644     ) internal override {
1645         // decode
1646         (address toAddr, uint256 tokenId) = abi.decode(
1647             _payload,
1648             (address, uint256)
1649         );
1650 
1651         // mint the tokens back into existence on destination chain
1652         _safeMint(toAddr, tokenId);
1653     }
1654 
1655     function _baseURI() internal view override returns (string memory) {
1656         return baseURI;
1657     }
1658 }