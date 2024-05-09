1 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface ILayerZeroUserApplicationConfig {
6   // @notice set the configuration of the LayerZero messaging library of the specified version
7   // @param _version - messaging library version
8   // @param _chainId - the chainId for the pending config change
9   // @param _configType - type of configuration. every messaging library has its own convention.
10   // @param _config - configuration in the bytes. can encode arbitrary content.
11   function setConfig(
12     uint16 _version,
13     uint16 _chainId,
14     uint256 _configType,
15     bytes calldata _config
16   ) external;
17 
18   // @notice set the send() LayerZero messaging library version to _version
19   // @param _version - new messaging library version
20   function setSendVersion(uint16 _version) external;
21 
22   // @notice set the lzReceive() LayerZero messaging library version to _version
23   // @param _version - new messaging library version
24   function setReceiveVersion(uint16 _version) external;
25 
26   // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
27   // @param _srcChainId - the chainId of the source chain
28   // @param _srcAddress - the contract address of the source contract at the source chain
29   function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
30     external;
31 }
32 
33 // File: contracts/interfaces/ILayerZeroEndpoint.sol
34 
35 pragma solidity >=0.5.0;
36 
37 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
38   // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
39   // @param _dstChainId - the destination chain identifier
40   // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
41   // @param _payload - a custom bytes payload to send to the destination contract
42   // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
43   // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
44   // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
45   function send(
46     uint16 _dstChainId,
47     bytes calldata _destination,
48     bytes calldata _payload,
49     address payable _refundAddress,
50     address _zroPaymentAddress,
51     bytes calldata _adapterParams
52   ) external payable;
53 
54   // @notice used by the messaging library to publish verified payload
55   // @param _srcChainId - the source chain identifier
56   // @param _srcAddress - the source contract (as bytes) at the source chain
57   // @param _dstAddress - the address on destination chain
58   // @param _nonce - the unbound message ordering nonce
59   // @param _gasLimit - the gas limit for external contract execution
60   // @param _payload - verified payload to send to the destination contract
61   function receivePayload(
62     uint16 _srcChainId,
63     bytes calldata _srcAddress,
64     address _dstAddress,
65     uint64 _nonce,
66     uint256 _gasLimit,
67     bytes calldata _payload
68   ) external;
69 
70   // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
71   // @param _srcChainId - the source chain identifier
72   // @param _srcAddress - the source chain contract address
73   function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress)
74     external
75     view
76     returns (uint64);
77 
78   // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
79   // @param _srcAddress - the source chain contract address
80   function getOutboundNonce(uint16 _dstChainId, address _srcAddress)
81     external
82     view
83     returns (uint64);
84 
85   // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
86   // @param _dstChainId - the destination chain identifier
87   // @param _userApplication - the user app address on this EVM chain
88   // @param _payload - the custom message to send over LayerZero
89   // @param _payInZRO - if false, user app pays the protocol fee in native token
90   // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
91   function estimateFees(
92     uint16 _dstChainId,
93     address _userApplication,
94     bytes calldata _payload,
95     bool _payInZRO,
96     bytes calldata _adapterParam
97   ) external view returns (uint256 nativeFee, uint256 zroFee);
98 
99   // @notice get this Endpoint's immutable source identifier
100   function getChainId() external view returns (uint16);
101 
102   // @notice the interface to retry failed message on this Endpoint destination
103   // @param _srcChainId - the source chain identifier
104   // @param _srcAddress - the source chain contract address
105   // @param _payload - the payload to be retried
106   function retryPayload(
107     uint16 _srcChainId,
108     bytes calldata _srcAddress,
109     bytes calldata _payload
110   ) external;
111 
112   // @notice query if any STORED payload (message blocking) at the endpoint.
113   // @param _srcChainId - the source chain identifier
114   // @param _srcAddress - the source chain contract address
115   function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress)
116     external
117     view
118     returns (bool);
119 
120   // @notice query if the _libraryAddress is valid for sending msgs.
121   // @param _userApplication - the user app address on this EVM chain
122   function getSendLibraryAddress(address _userApplication)
123     external
124     view
125     returns (address);
126 
127   // @notice query if the _libraryAddress is valid for receiving msgs.
128   // @param _userApplication - the user app address on this EVM chain
129   function getReceiveLibraryAddress(address _userApplication)
130     external
131     view
132     returns (address);
133 
134   // @notice query if the non-reentrancy guard for send() is on
135   // @return true if the guard is on. false otherwise
136   function isSendingPayload() external view returns (bool);
137 
138   // @notice query if the non-reentrancy guard for receive() is on
139   // @return true if the guard is on. false otherwise
140   function isReceivingPayload() external view returns (bool);
141 
142   // @notice get the configuration of the LayerZero messaging library of the specified version
143   // @param _version - messaging library version
144   // @param _chainId - the chainId for the pending config change
145   // @param _userApplication - the contract address of the user application
146   // @param _configType - type of configuration. every messaging library has its own convention.
147   function getConfig(
148     uint16 _version,
149     uint16 _chainId,
150     address _userApplication,
151     uint256 _configType
152   ) external view returns (bytes memory);
153 
154   // @notice get the send() LayerZero messaging library version
155   // @param _userApplication - the contract address of the user application
156   function getSendVersion(address _userApplication)
157     external
158     view
159     returns (uint16);
160 
161   // @notice get the lzReceive() LayerZero messaging library version
162   // @param _userApplication - the contract address of the user application
163   function getReceiveVersion(address _userApplication)
164     external
165     view
166     returns (uint16);
167 }
168 
169 // File: contracts/interfaces/ILayerZeroReceiver.sol
170 
171 pragma solidity >=0.5.0;
172 
173 interface ILayerZeroReceiver {
174   // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
175   // @param _srcChainId - the source endpoint identifier
176   // @param _srcAddress - the source sending contract address from the source chain
177   // @param _nonce - the ordered message nonce
178   // @param _payload - the signed payload is the UA bytes has encoded to be sent
179   function lzReceive(
180     uint16 _srcChainId,
181     bytes calldata _srcAddress,
182     uint64 _nonce,
183     bytes calldata _payload
184   ) external;
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
196   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
197 
198   /**
199    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
200    */
201   function toString(uint256 value) internal pure returns (string memory) {
202     // Inspired by OraclizeAPI's implementation - MIT licence
203     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
204 
205     if (value == 0) {
206       return "0";
207     }
208     uint256 temp = value;
209     uint256 digits;
210     while (temp != 0) {
211       digits++;
212       temp /= 10;
213     }
214     bytes memory buffer = new bytes(digits);
215     while (value != 0) {
216       digits -= 1;
217       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
218       value /= 10;
219     }
220     return string(buffer);
221   }
222 
223   /**
224    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
225    */
226   function toHexString(uint256 value) internal pure returns (string memory) {
227     if (value == 0) {
228       return "0x00";
229     }
230     uint256 temp = value;
231     uint256 length = 0;
232     while (temp != 0) {
233       length++;
234       temp >>= 8;
235     }
236     return toHexString(value, length);
237   }
238 
239   /**
240    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
241    */
242   function toHexString(uint256 value, uint256 length)
243     internal
244     pure
245     returns (string memory)
246   {
247     bytes memory buffer = new bytes(2 * length + 2);
248     buffer[0] = "0";
249     buffer[1] = "x";
250     for (uint256 i = 2 * length + 1; i > 1; --i) {
251       buffer[i] = _HEX_SYMBOLS[value & 0xf];
252       value >>= 4;
253     }
254     require(value == 0, "Strings: hex length insufficient");
255     return string(buffer);
256   }
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
276   function _msgSender() internal view virtual returns (address) {
277     return msg.sender;
278   }
279 
280   function _msgData() internal view virtual returns (bytes calldata) {
281     return msg.data;
282   }
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
304   address private _owner;
305 
306   event OwnershipTransferred(
307     address indexed previousOwner,
308     address indexed newOwner
309   );
310 
311   /**
312    * @dev Initializes the contract setting the deployer as the initial owner.
313    */
314   constructor() {
315     _transferOwnership(_msgSender());
316   }
317 
318   /**
319    * @dev Returns the address of the current owner.
320    */
321   function owner() public view virtual returns (address) {
322     return _owner;
323   }
324 
325   /**
326    * @dev Throws if called by any account other than the owner.
327    */
328   modifier onlyOwner() {
329     require(owner() == _msgSender(), "Ownable: caller is not the owner");
330     _;
331   }
332 
333   /**
334    * @dev Leaves the contract without owner. It will not be possible to call
335    * `onlyOwner` functions anymore. Can only be called by the current owner.
336    *
337    * NOTE: Renouncing ownership will leave the contract without an owner,
338    * thereby removing any functionality that is only available to the owner.
339    */
340   function renounceOwnership() public virtual onlyOwner {
341     _transferOwnership(address(0));
342   }
343 
344   /**
345    * @dev Transfers ownership of the contract to a new account (`newOwner`).
346    * Can only be called by the current owner.
347    */
348   function transferOwnership(address newOwner) public virtual onlyOwner {
349     require(newOwner != address(0), "Ownable: new owner is the zero address");
350     _transferOwnership(newOwner);
351   }
352 
353   /**
354    * @dev Transfers ownership of the contract to a new account (`newOwner`).
355    * Internal function without access restriction.
356    */
357   function _transferOwnership(address newOwner) internal virtual {
358     address oldOwner = _owner;
359     _owner = newOwner;
360     emit OwnershipTransferred(oldOwner, newOwner);
361   }
362 }
363 
364 // File: @openzeppelin/contracts/utils/Address.sol
365 
366 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Collection of functions related to the address type
372  */
373 library Address {
374   /**
375    * @dev Returns true if `account` is a contract.
376    *
377    * [IMPORTANT]
378    * ====
379    * It is unsafe to assume that an address for which this function returns
380    * false is an externally-owned account (EOA) and not a contract.
381    *
382    * Among others, `isContract` will return false for the following
383    * types of addresses:
384    *
385    *  - an externally-owned account
386    *  - a contract in construction
387    *  - an address where a contract will be created
388    *  - an address where a contract lived, but was destroyed
389    * ====
390    */
391   function isContract(address account) internal view returns (bool) {
392     // This method relies on extcodesize, which returns 0 for contracts in
393     // construction, since the code is only stored at the end of the
394     // constructor execution.
395 
396     uint256 size;
397     assembly {
398       size := extcodesize(account)
399     }
400     return size > 0;
401   }
402 
403   /**
404    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
405    * `recipient`, forwarding all available gas and reverting on errors.
406    *
407    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
408    * of certain opcodes, possibly making contracts go over the 2300 gas limit
409    * imposed by `transfer`, making them unable to receive funds via
410    * `transfer`. {sendValue} removes this limitation.
411    *
412    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
413    *
414    * IMPORTANT: because control is transferred to `recipient`, care must be
415    * taken to not create reentrancy vulnerabilities. Consider using
416    * {ReentrancyGuard} or the
417    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
418    */
419   function sendValue(address payable recipient, uint256 amount) internal {
420     require(address(this).balance >= amount, "Address: insufficient balance");
421 
422     (bool success, ) = recipient.call{ value: amount }("");
423     require(
424       success,
425       "Address: unable to send value, recipient may have reverted"
426     );
427   }
428 
429   /**
430    * @dev Performs a Solidity function call using a low level `call`. A
431    * plain `call` is an unsafe replacement for a function call: use this
432    * function instead.
433    *
434    * If `target` reverts with a revert reason, it is bubbled up by this
435    * function (like regular Solidity function calls).
436    *
437    * Returns the raw returned data. To convert to the expected return value,
438    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
439    *
440    * Requirements:
441    *
442    * - `target` must be a contract.
443    * - calling `target` with `data` must not revert.
444    *
445    * _Available since v3.1._
446    */
447   function functionCall(address target, bytes memory data)
448     internal
449     returns (bytes memory)
450   {
451     return functionCall(target, data, "Address: low-level call failed");
452   }
453 
454   /**
455    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
456    * `errorMessage` as a fallback revert reason when `target` reverts.
457    *
458    * _Available since v3.1._
459    */
460   function functionCall(
461     address target,
462     bytes memory data,
463     string memory errorMessage
464   ) internal returns (bytes memory) {
465     return functionCallWithValue(target, data, 0, errorMessage);
466   }
467 
468   /**
469    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470    * but also transferring `value` wei to `target`.
471    *
472    * Requirements:
473    *
474    * - the calling contract must have an ETH balance of at least `value`.
475    * - the called Solidity function must be `payable`.
476    *
477    * _Available since v3.1._
478    */
479   function functionCallWithValue(
480     address target,
481     bytes memory data,
482     uint256 value
483   ) internal returns (bytes memory) {
484     return
485       functionCallWithValue(
486         target,
487         data,
488         value,
489         "Address: low-level call with value failed"
490       );
491   }
492 
493   /**
494    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
495    * with `errorMessage` as a fallback revert reason when `target` reverts.
496    *
497    * _Available since v3.1._
498    */
499   function functionCallWithValue(
500     address target,
501     bytes memory data,
502     uint256 value,
503     string memory errorMessage
504   ) internal returns (bytes memory) {
505     require(
506       address(this).balance >= value,
507       "Address: insufficient balance for call"
508     );
509     require(isContract(target), "Address: call to non-contract");
510 
511     (bool success, bytes memory returndata) = target.call{ value: value }(data);
512     return verifyCallResult(success, returndata, errorMessage);
513   }
514 
515   /**
516    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517    * but performing a static call.
518    *
519    * _Available since v3.3._
520    */
521   function functionStaticCall(address target, bytes memory data)
522     internal
523     view
524     returns (bytes memory)
525   {
526     return
527       functionStaticCall(target, data, "Address: low-level static call failed");
528   }
529 
530   /**
531    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
532    * but performing a static call.
533    *
534    * _Available since v3.3._
535    */
536   function functionStaticCall(
537     address target,
538     bytes memory data,
539     string memory errorMessage
540   ) internal view returns (bytes memory) {
541     require(isContract(target), "Address: static call to non-contract");
542 
543     (bool success, bytes memory returndata) = target.staticcall(data);
544     return verifyCallResult(success, returndata, errorMessage);
545   }
546 
547   /**
548    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
549    * but performing a delegate call.
550    *
551    * _Available since v3.4._
552    */
553   function functionDelegateCall(address target, bytes memory data)
554     internal
555     returns (bytes memory)
556   {
557     return
558       functionDelegateCall(
559         target,
560         data,
561         "Address: low-level delegate call failed"
562       );
563   }
564 
565   /**
566    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
567    * but performing a delegate call.
568    *
569    * _Available since v3.4._
570    */
571   function functionDelegateCall(
572     address target,
573     bytes memory data,
574     string memory errorMessage
575   ) internal returns (bytes memory) {
576     require(isContract(target), "Address: delegate call to non-contract");
577 
578     (bool success, bytes memory returndata) = target.delegatecall(data);
579     return verifyCallResult(success, returndata, errorMessage);
580   }
581 
582   /**
583    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
584    * revert reason using the provided one.
585    *
586    * _Available since v4.3._
587    */
588   function verifyCallResult(
589     bool success,
590     bytes memory returndata,
591     string memory errorMessage
592   ) internal pure returns (bytes memory) {
593     if (success) {
594       return returndata;
595     } else {
596       // Look for revert reason and bubble it up if present
597       if (returndata.length > 0) {
598         // The easiest way to bubble the revert reason is using memory via assembly
599 
600         assembly {
601           let returndata_size := mload(returndata)
602           revert(add(32, returndata), returndata_size)
603         }
604       } else {
605         revert(errorMessage);
606       }
607     }
608   }
609 }
610 
611 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
612 
613 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @title ERC721 token receiver interface
619  * @dev Interface for any contract that wants to support safeTransfers
620  * from ERC721 asset contracts.
621  */
622 interface IERC721Receiver {
623   /**
624    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
625    * by `operator` from `from`, this function is called.
626    *
627    * It must return its Solidity selector to confirm the token transfer.
628    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
629    *
630    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
631    */
632   function onERC721Received(
633     address operator,
634     address from,
635     uint256 tokenId,
636     bytes calldata data
637   ) external returns (bytes4);
638 }
639 
640 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
641 
642 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 /**
647  * @dev Interface of the ERC165 standard, as defined in the
648  * https://eips.ethereum.org/EIPS/eip-165[EIP].
649  *
650  * Implementers can declare support of contract interfaces, which can then be
651  * queried by others ({ERC165Checker}).
652  *
653  * For an implementation, see {ERC165}.
654  */
655 interface IERC165 {
656   /**
657    * @dev Returns true if this contract implements the interface defined by
658    * `interfaceId`. See the corresponding
659    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
660    * to learn more about how these ids are created.
661    *
662    * This function call must use less than 30 000 gas.
663    */
664   function supportsInterface(bytes4 interfaceId) external view returns (bool);
665 }
666 
667 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @dev Implementation of the {IERC165} interface.
675  *
676  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
677  * for the additional interface id that will be supported. For example:
678  *
679  * ```solidity
680  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
681  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
682  * }
683  * ```
684  *
685  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
686  */
687 abstract contract ERC165 is IERC165 {
688   /**
689    * @dev See {IERC165-supportsInterface}.
690    */
691   function supportsInterface(bytes4 interfaceId)
692     public
693     view
694     virtual
695     override
696     returns (bool)
697   {
698     return interfaceId == type(IERC165).interfaceId;
699   }
700 }
701 
702 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
703 
704 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @dev Required interface of an ERC721 compliant contract.
710  */
711 interface IERC721 is IERC165 {
712   /**
713    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
714    */
715   event Transfer(
716     address indexed from,
717     address indexed to,
718     uint256 indexed tokenId
719   );
720 
721   /**
722    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
723    */
724   event Approval(
725     address indexed owner,
726     address indexed approved,
727     uint256 indexed tokenId
728   );
729 
730   /**
731    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
732    */
733   event ApprovalForAll(
734     address indexed owner,
735     address indexed operator,
736     bool approved
737   );
738 
739   /**
740    * @dev Returns the number of tokens in ``owner``'s account.
741    */
742   function balanceOf(address owner) external view returns (uint256 balance);
743 
744   /**
745    * @dev Returns the owner of the `tokenId` token.
746    *
747    * Requirements:
748    *
749    * - `tokenId` must exist.
750    */
751   function ownerOf(uint256 tokenId) external view returns (address owner);
752 
753   /**
754    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
755    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
756    *
757    * Requirements:
758    *
759    * - `from` cannot be the zero address.
760    * - `to` cannot be the zero address.
761    * - `tokenId` token must exist and be owned by `from`.
762    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
763    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
764    *
765    * Emits a {Transfer} event.
766    */
767   function safeTransferFrom(
768     address from,
769     address to,
770     uint256 tokenId
771   ) external;
772 
773   /**
774    * @dev Transfers `tokenId` token from `from` to `to`.
775    *
776    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
777    *
778    * Requirements:
779    *
780    * - `from` cannot be the zero address.
781    * - `to` cannot be the zero address.
782    * - `tokenId` token must be owned by `from`.
783    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
784    *
785    * Emits a {Transfer} event.
786    */
787   function transferFrom(
788     address from,
789     address to,
790     uint256 tokenId
791   ) external;
792 
793   /**
794    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
795    * The approval is cleared when the token is transferred.
796    *
797    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
798    *
799    * Requirements:
800    *
801    * - The caller must own the token or be an approved operator.
802    * - `tokenId` must exist.
803    *
804    * Emits an {Approval} event.
805    */
806   function approve(address to, uint256 tokenId) external;
807 
808   /**
809    * @dev Returns the account approved for `tokenId` token.
810    *
811    * Requirements:
812    *
813    * - `tokenId` must exist.
814    */
815   function getApproved(uint256 tokenId)
816     external
817     view
818     returns (address operator);
819 
820   /**
821    * @dev Approve or remove `operator` as an operator for the caller.
822    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
823    *
824    * Requirements:
825    *
826    * - The `operator` cannot be the caller.
827    *
828    * Emits an {ApprovalForAll} event.
829    */
830   function setApprovalForAll(address operator, bool _approved) external;
831 
832   /**
833    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
834    *
835    * See {setApprovalForAll}
836    */
837   function isApprovedForAll(address owner, address operator)
838     external
839     view
840     returns (bool);
841 
842   /**
843    * @dev Safely transfers `tokenId` token from `from` to `to`.
844    *
845    * Requirements:
846    *
847    * - `from` cannot be the zero address.
848    * - `to` cannot be the zero address.
849    * - `tokenId` token must exist and be owned by `from`.
850    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
851    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
852    *
853    * Emits a {Transfer} event.
854    */
855   function safeTransferFrom(
856     address from,
857     address to,
858     uint256 tokenId,
859     bytes calldata data
860   ) external;
861 }
862 
863 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
864 
865 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 /**
870  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
871  * @dev See https://eips.ethereum.org/EIPS/eip-721
872  */
873 interface IERC721Metadata is IERC721 {
874   /**
875    * @dev Returns the token collection name.
876    */
877   function name() external view returns (string memory);
878 
879   /**
880    * @dev Returns the token collection symbol.
881    */
882   function symbol() external view returns (string memory);
883 
884   /**
885    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
886    */
887   function tokenURI(uint256 tokenId) external view returns (string memory);
888 }
889 
890 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
891 
892 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 /**
897  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
898  * the Metadata extension, but not including the Enumerable extension, which is available separately as
899  * {ERC721Enumerable}.
900  */
901 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
902   using Address for address;
903   using Strings for uint256;
904 
905   // Token name
906   string private _name;
907 
908   // Token symbol
909   string private _symbol;
910 
911   // Mapping from token ID to owner address
912   mapping(uint256 => address) private _owners;
913 
914   // Mapping owner address to token count
915   mapping(address => uint256) private _balances;
916 
917   // Mapping from token ID to approved address
918   mapping(uint256 => address) private _tokenApprovals;
919 
920   // Mapping from owner to operator approvals
921   mapping(address => mapping(address => bool)) private _operatorApprovals;
922 
923   /**
924    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
925    */
926   constructor(string memory name_, string memory symbol_) {
927     _name = name_;
928     _symbol = symbol_;
929   }
930 
931   /**
932    * @dev See {IERC165-supportsInterface}.
933    */
934   function supportsInterface(bytes4 interfaceId)
935     public
936     view
937     virtual
938     override(ERC165, IERC165)
939     returns (bool)
940   {
941     return
942       interfaceId == type(IERC721).interfaceId ||
943       interfaceId == type(IERC721Metadata).interfaceId ||
944       super.supportsInterface(interfaceId);
945   }
946 
947   /**
948    * @dev See {IERC721-balanceOf}.
949    */
950   function balanceOf(address owner)
951     public
952     view
953     virtual
954     override
955     returns (uint256)
956   {
957     require(owner != address(0), "ERC721: balance query for the zero address");
958     return _balances[owner];
959   }
960 
961   /**
962    * @dev See {IERC721-ownerOf}.
963    */
964   function ownerOf(uint256 tokenId)
965     public
966     view
967     virtual
968     override
969     returns (address)
970   {
971     address owner = _owners[tokenId];
972     require(owner != address(0), "ERC721: owner query for nonexistent token");
973     return owner;
974   }
975 
976   /**
977    * @dev See {IERC721Metadata-name}.
978    */
979   function name() public view virtual override returns (string memory) {
980     return _name;
981   }
982 
983   /**
984    * @dev See {IERC721Metadata-symbol}.
985    */
986   function symbol() public view virtual override returns (string memory) {
987     return _symbol;
988   }
989 
990   /**
991    * @dev See {IERC721Metadata-tokenURI}.
992    */
993   function tokenURI(uint256 tokenId)
994     public
995     view
996     virtual
997     override
998     returns (string memory)
999   {
1000     require(
1001       _exists(tokenId),
1002       "ERC721Metadata: URI query for nonexistent token"
1003     );
1004 
1005     string memory baseURI = _baseURI();
1006     return
1007       bytes(baseURI).length > 0
1008         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1009         : "";
1010   }
1011 
1012   /**
1013    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1014    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1015    * by default, can be overriden in child contracts.
1016    */
1017   function _baseURI() internal view virtual returns (string memory) {
1018     return "";
1019   }
1020 
1021   /**
1022    * @dev See {IERC721-approve}.
1023    */
1024   function approve(address to, uint256 tokenId) public virtual override {
1025     address owner = ERC721.ownerOf(tokenId);
1026     require(to != owner, "ERC721: approval to current owner");
1027 
1028     require(
1029       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1030       "ERC721: approve caller is not owner nor approved for all"
1031     );
1032 
1033     _approve(to, tokenId);
1034   }
1035 
1036   /**
1037    * @dev See {IERC721-getApproved}.
1038    */
1039   function getApproved(uint256 tokenId)
1040     public
1041     view
1042     virtual
1043     override
1044     returns (address)
1045   {
1046     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1047 
1048     return _tokenApprovals[tokenId];
1049   }
1050 
1051   /**
1052    * @dev See {IERC721-setApprovalForAll}.
1053    */
1054   function setApprovalForAll(address operator, bool approved)
1055     public
1056     virtual
1057     override
1058   {
1059     _setApprovalForAll(_msgSender(), operator, approved);
1060   }
1061 
1062   /**
1063    * @dev See {IERC721-isApprovedForAll}.
1064    */
1065   function isApprovedForAll(address owner, address operator)
1066     public
1067     view
1068     virtual
1069     override
1070     returns (bool)
1071   {
1072     return _operatorApprovals[owner][operator];
1073   }
1074 
1075   /**
1076    * @dev See {IERC721-transferFrom}.
1077    */
1078   function transferFrom(
1079     address from,
1080     address to,
1081     uint256 tokenId
1082   ) public virtual override {
1083     //solhint-disable-next-line max-line-length
1084     require(
1085       _isApprovedOrOwner(_msgSender(), tokenId),
1086       "ERC721: transfer caller is not owner nor approved"
1087     );
1088 
1089     _transfer(from, to, tokenId);
1090   }
1091 
1092   /**
1093    * @dev See {IERC721-safeTransferFrom}.
1094    */
1095   function safeTransferFrom(
1096     address from,
1097     address to,
1098     uint256 tokenId
1099   ) public virtual override {
1100     safeTransferFrom(from, to, tokenId, "");
1101   }
1102 
1103   /**
1104    * @dev See {IERC721-safeTransferFrom}.
1105    */
1106   function safeTransferFrom(
1107     address from,
1108     address to,
1109     uint256 tokenId,
1110     bytes memory _data
1111   ) public virtual override {
1112     require(
1113       _isApprovedOrOwner(_msgSender(), tokenId),
1114       "ERC721: transfer caller is not owner nor approved"
1115     );
1116     _safeTransfer(from, to, tokenId, _data);
1117   }
1118 
1119   /**
1120    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1121    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1122    *
1123    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1124    *
1125    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1126    * implement alternative mechanisms to perform token transfer, such as signature-based.
1127    *
1128    * Requirements:
1129    *
1130    * - `from` cannot be the zero address.
1131    * - `to` cannot be the zero address.
1132    * - `tokenId` token must exist and be owned by `from`.
1133    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1134    *
1135    * Emits a {Transfer} event.
1136    */
1137   function _safeTransfer(
1138     address from,
1139     address to,
1140     uint256 tokenId,
1141     bytes memory _data
1142   ) internal virtual {
1143     _transfer(from, to, tokenId);
1144     require(
1145       _checkOnERC721Received(from, to, tokenId, _data),
1146       "ERC721: transfer to non ERC721Receiver implementer"
1147     );
1148   }
1149 
1150   /**
1151    * @dev Returns whether `tokenId` exists.
1152    *
1153    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1154    *
1155    * Tokens start existing when they are minted (`_mint`),
1156    * and stop existing when they are burned (`_burn`).
1157    */
1158   function _exists(uint256 tokenId) internal view virtual returns (bool) {
1159     return _owners[tokenId] != address(0);
1160   }
1161 
1162   /**
1163    * @dev Returns whether `spender` is allowed to manage `tokenId`.
1164    *
1165    * Requirements:
1166    *
1167    * - `tokenId` must exist.
1168    */
1169   function _isApprovedOrOwner(address spender, uint256 tokenId)
1170     internal
1171     view
1172     virtual
1173     returns (bool)
1174   {
1175     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1176     address owner = ERC721.ownerOf(tokenId);
1177     return (spender == owner ||
1178       getApproved(tokenId) == spender ||
1179       isApprovedForAll(owner, spender));
1180   }
1181 
1182   /**
1183    * @dev Safely mints `tokenId` and transfers it to `to`.
1184    *
1185    * Requirements:
1186    *
1187    * - `tokenId` must not exist.
1188    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1189    *
1190    * Emits a {Transfer} event.
1191    */
1192   function _safeMint(address to, uint256 tokenId) internal virtual {
1193     _safeMint(to, tokenId, "");
1194   }
1195 
1196   /**
1197    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1198    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1199    */
1200   function _safeMint(
1201     address to,
1202     uint256 tokenId,
1203     bytes memory _data
1204   ) internal virtual {
1205     _mint(to, tokenId);
1206     require(
1207       _checkOnERC721Received(address(0), to, tokenId, _data),
1208       "ERC721: transfer to non ERC721Receiver implementer"
1209     );
1210   }
1211 
1212   /**
1213    * @dev Mints `tokenId` and transfers it to `to`.
1214    *
1215    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1216    *
1217    * Requirements:
1218    *
1219    * - `tokenId` must not exist.
1220    * - `to` cannot be the zero address.
1221    *
1222    * Emits a {Transfer} event.
1223    */
1224   function _mint(address to, uint256 tokenId) internal virtual {
1225     require(to != address(0), "ERC721: mint to the zero address");
1226 
1227     _beforeTokenTransfer(address(0), to, tokenId);
1228 
1229     _balances[to] += 1;
1230     _owners[tokenId] = to;
1231 
1232     emit Transfer(address(0), to, tokenId);
1233   }
1234 
1235   /**
1236    * @dev Destroys `tokenId`.
1237    * The approval is cleared when the token is burned.
1238    *
1239    * Requirements:
1240    *
1241    * - `tokenId` must exist.
1242    *
1243    * Emits a {Transfer} event.
1244    */
1245   function _burn(uint256 tokenId) internal virtual {
1246     address owner = ERC721.ownerOf(tokenId);
1247 
1248     _beforeTokenTransfer(owner, address(0), tokenId);
1249 
1250     // Clear approvals
1251     _approve(address(0), tokenId);
1252 
1253     _balances[owner] -= 1;
1254     delete _owners[tokenId];
1255 
1256     emit Transfer(owner, address(0), tokenId);
1257   }
1258 
1259   /**
1260    * @dev Transfers `tokenId` from `from` to `to`.
1261    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1262    *
1263    * Requirements:
1264    *
1265    * - `to` cannot be the zero address.
1266    * - `tokenId` token must be owned by `from`.
1267    *
1268    * Emits a {Transfer} event.
1269    */
1270   function _transfer(
1271     address from,
1272     address to,
1273     uint256 tokenId
1274   ) internal virtual {
1275     require(
1276       ERC721.ownerOf(tokenId) == from,
1277       "ERC721: transfer of token that is not own"
1278     );
1279     require(to != address(0), "ERC721: transfer to the zero address");
1280 
1281     _beforeTokenTransfer(from, to, tokenId);
1282 
1283     // Clear approvals from the previous owner
1284     _approve(address(0), tokenId);
1285 
1286     _balances[from] -= 1;
1287     _balances[to] += 1;
1288     _owners[tokenId] = to;
1289 
1290     emit Transfer(from, to, tokenId);
1291   }
1292 
1293   /**
1294    * @dev Approve `to` to operate on `tokenId`
1295    *
1296    * Emits a {Approval} event.
1297    */
1298   function _approve(address to, uint256 tokenId) internal virtual {
1299     _tokenApprovals[tokenId] = to;
1300     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1301   }
1302 
1303   /**
1304    * @dev Approve `operator` to operate on all of `owner` tokens
1305    *
1306    * Emits a {ApprovalForAll} event.
1307    */
1308   function _setApprovalForAll(
1309     address owner,
1310     address operator,
1311     bool approved
1312   ) internal virtual {
1313     require(owner != operator, "ERC721: approve to caller");
1314     _operatorApprovals[owner][operator] = approved;
1315     emit ApprovalForAll(owner, operator, approved);
1316   }
1317 
1318   /**
1319    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1320    * The call is not executed if the target address is not a contract.
1321    *
1322    * @param from address representing the previous owner of the given token ID
1323    * @param to target address that will receive the tokens
1324    * @param tokenId uint256 ID of the token to be transferred
1325    * @param _data bytes optional data to send along with the call
1326    * @return bool whether the call correctly returned the expected magic value
1327    */
1328   function _checkOnERC721Received(
1329     address from,
1330     address to,
1331     uint256 tokenId,
1332     bytes memory _data
1333   ) private returns (bool) {
1334     if (to.isContract()) {
1335       try
1336         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1337       returns (bytes4 retval) {
1338         return retval == IERC721Receiver.onERC721Received.selector;
1339       } catch (bytes memory reason) {
1340         if (reason.length == 0) {
1341           revert("ERC721: transfer to non ERC721Receiver implementer");
1342         } else {
1343           assembly {
1344             revert(add(32, reason), mload(reason))
1345           }
1346         }
1347       }
1348     } else {
1349       return true;
1350     }
1351   }
1352 
1353   /**
1354    * @dev Hook that is called before any token transfer. This includes minting
1355    * and burning.
1356    *
1357    * Calling conditions:
1358    *
1359    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1360    * transferred to `to`.
1361    * - When `from` is zero, `tokenId` will be minted for `to`.
1362    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1363    * - `from` and `to` are never both zero.
1364    *
1365    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1366    */
1367   function _beforeTokenTransfer(
1368     address from,
1369     address to,
1370     uint256 tokenId
1371   ) internal virtual {}
1372 }
1373 
1374 // File: contracts/NonblockingReceiver.sol
1375 
1376 pragma solidity ^0.8.6;
1377 
1378 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1379   ILayerZeroEndpoint internal endpoint;
1380 
1381   struct FailedMessages {
1382     uint256 payloadLength;
1383     bytes32 payloadHash;
1384   }
1385 
1386   mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1387     public failedMessages;
1388   mapping(uint16 => bytes) public trustedRemoteLookup;
1389 
1390   event MessageFailed(
1391     uint16 _srcChainId,
1392     bytes _srcAddress,
1393     uint64 _nonce,
1394     bytes _payload
1395   );
1396 
1397   function lzReceive(
1398     uint16 _srcChainId,
1399     bytes memory _srcAddress,
1400     uint64 _nonce,
1401     bytes memory _payload
1402   ) external override {
1403     require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1404     require(
1405       _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1406         keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]),
1407       "NonblockingReceiver: invalid source sending contract"
1408     );
1409 
1410     // try-catch all errors/exceptions
1411     // having failed messages does not block messages passing
1412     try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1413       // do nothing
1414     } catch {
1415       // error / exception
1416       failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1417         _payload.length,
1418         keccak256(_payload)
1419       );
1420       emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1421     }
1422   }
1423 
1424   function onLzReceive(
1425     uint16 _srcChainId,
1426     bytes memory _srcAddress,
1427     uint64 _nonce,
1428     bytes memory _payload
1429   ) public {
1430     // only internal transaction
1431     require(
1432       msg.sender == address(this),
1433       "NonblockingReceiver: caller must be Bridge."
1434     );
1435 
1436     // handle incoming message
1437     _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1438   }
1439 
1440   // abstract function
1441   function _LzReceive(
1442     uint16 _srcChainId,
1443     bytes memory _srcAddress,
1444     uint64 _nonce,
1445     bytes memory _payload
1446   ) internal virtual;
1447 
1448   function _lzSend(
1449     uint16 _dstChainId,
1450     bytes memory _payload,
1451     address payable _refundAddress,
1452     address _zroPaymentAddress,
1453     bytes memory _txParam
1454   ) internal {
1455     endpoint.send{ value: msg.value }(
1456       _dstChainId,
1457       trustedRemoteLookup[_dstChainId],
1458       _payload,
1459       _refundAddress,
1460       _zroPaymentAddress,
1461       _txParam
1462     );
1463   }
1464 
1465   function retryMessage(
1466     uint16 _srcChainId,
1467     bytes memory _srcAddress,
1468     uint64 _nonce,
1469     bytes calldata _payload
1470   ) external payable {
1471     // assert there is message to retry
1472     FailedMessages storage failedMsg = failedMessages[_srcChainId][_srcAddress][
1473       _nonce
1474     ];
1475     require(
1476       failedMsg.payloadHash != bytes32(0),
1477       "NonblockingReceiver: no stored message"
1478     );
1479     require(
1480       _payload.length == failedMsg.payloadLength &&
1481         keccak256(_payload) == failedMsg.payloadHash,
1482       "LayerZero: invalid payload"
1483     );
1484     // clear the stored message
1485     failedMsg.payloadLength = 0;
1486     failedMsg.payloadHash = bytes32(0);
1487     // execute the message. revert if it fails again
1488     this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1489   }
1490 
1491   function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1492     external
1493     onlyOwner
1494   {
1495     trustedRemoteLookup[_chainId] = _trustedRemote;
1496   }
1497 }
1498 
1499 //ᶠᵉᵉᵈ ᵐᵉ ʰᵘᵍ ᵐᵉ ᵗʰᵉⁿ ᶠˣˣᵏ ᵒᶠᶠ ʷⁱˡˡ ʸᵃ /ᐠ｡｡ᐟ\
1500 // File: contracts/moodykittens-eth.sol
1501 
1502 pragma solidity ^0.8.7;
1503 
1504 contract moodykittens is Ownable, ERC721, NonblockingReceiver {
1505   address public _owner;
1506   string private baseURI;
1507   uint256 nextTokenId = 4900;
1508   uint256 MAX_MINT_ETHEREUM = 8400;
1509 
1510   uint256 gasForDestinationLzReceive = 350000;
1511 
1512   constructor(string memory baseURI_, address _layerZeroEndpoint)
1513     ERC721("moody kittens", "ktns")
1514   {
1515     _owner = msg.sender;
1516     endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1517     baseURI = baseURI_;
1518   }
1519 
1520   // mint function
1521   // you can choose to mint 1 or 2
1522   // mint is free, but payments are accepted
1523   function mint(uint8 numTokens) external payable {
1524     require(numTokens < 3, "moody kittens: Max 2 NFTs per transaction");
1525     require(
1526       nextTokenId + numTokens <= MAX_MINT_ETHEREUM,
1527       "moody kittens: Mint exceeds supply"
1528     );
1529     _safeMint(msg.sender, ++nextTokenId);
1530     if (numTokens == 2) {
1531       _safeMint(msg.sender, ++nextTokenId);
1532     }
1533   }
1534 
1535   // This function transfers the nft from your address on the
1536   // source chain to the same address on the destination chain
1537   function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1538     require(
1539       msg.sender == ownerOf(tokenId),
1540       "You must own the token to traverse"
1541     );
1542     require(
1543       trustedRemoteLookup[_chainId].length > 0,
1544       "This chain is currently unavailable for travel"
1545     );
1546 
1547     // burn NFT, eliminating it from circulation on src chain
1548     _burn(tokenId);
1549 
1550     // abi.encode() the payload with the values to send
1551     bytes memory payload = abi.encode(msg.sender, tokenId);
1552 
1553     // encode adapterParams to specify more gas for the destination
1554     uint16 version = 1;
1555     bytes memory adapterParams = abi.encodePacked(
1556       version,
1557       gasForDestinationLzReceive
1558     );
1559 
1560     // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1561     // you will be refunded for extra gas paid
1562     (uint256 messageFee, ) = endpoint.estimateFees(
1563       _chainId,
1564       address(this),
1565       payload,
1566       false,
1567       adapterParams
1568     );
1569 
1570     require(
1571       msg.value >= messageFee,
1572       "moody kittens: msg.value not enough to cover messageFee. Send gas for message fees"
1573     );
1574 
1575     endpoint.send{ value: msg.value }(
1576       _chainId, // destination chainId
1577       trustedRemoteLookup[_chainId], // destination address of nft contract
1578       payload, // abi.encoded()'ed bytes
1579       payable(msg.sender), // refund address
1580       address(0x0), // 'zroPaymentAddress' unused for this
1581       adapterParams // txParameters
1582     );
1583   }
1584 
1585   function setBaseURI(string memory URI) external onlyOwner {
1586     baseURI = URI;
1587   }
1588 
1589   function donate() external payable {
1590     // thank you
1591   }
1592 
1593   // This allows the devs to receive kind donations
1594   function withdraw(uint256 amt) external onlyOwner {
1595     (bool sent, ) = payable(_owner).call{ value: amt }("");
1596     require(sent, "moody kittens: Failed to withdraw Ether");
1597   }
1598 
1599   // just in case this fixed variable limits us from future integrations
1600   function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1601     gasForDestinationLzReceive = newVal;
1602   }
1603 
1604   // ------------------
1605   // Internal Functions
1606   // ------------------
1607 
1608   function _LzReceive(
1609     uint16 _srcChainId,
1610     bytes memory _srcAddress,
1611     uint64 _nonce,
1612     bytes memory _payload
1613   ) internal override {
1614     // decode
1615     (address toAddr, uint256 tokenId) = abi.decode(
1616       _payload,
1617       (address, uint256)
1618     );
1619 
1620     // mint the tokens back into existence on destination chain
1621     _safeMint(toAddr, tokenId);
1622   }
1623 
1624   function _baseURI() internal view override returns (string memory) {
1625     return baseURI;
1626   }
1627 }