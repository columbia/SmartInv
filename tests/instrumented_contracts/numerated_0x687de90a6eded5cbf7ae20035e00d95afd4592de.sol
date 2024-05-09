1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.13;
4 
5 interface IOperatorFilterRegistry {
6     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
7     function register(address registrant) external;
8     function registerAndSubscribe(address registrant, address subscription) external;
9     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
10     function unregister(address addr) external;
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }
31 
32 pragma solidity ^0.8.13;
33 
34 
35 /**
36  * @title  OperatorFilterer
37  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
38  *         registrant's entries in the OperatorFilterRegistry.
39  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
40  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
41  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
42  */
43 abstract contract OperatorFilterer {
44     error OperatorNotAllowed(address operator);
45 
46     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
47         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
48 
49     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
50         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
51         // will not revert, but the contract will need to be registered with the registry once it is deployed in
52         // order for the modifier to filter addresses.
53         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
54             if (subscribe) {
55                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
56             } else {
57                 if (subscriptionOrRegistrantToCopy != address(0)) {
58                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
59                 } else {
60                     OPERATOR_FILTER_REGISTRY.register(address(this));
61                 }
62             }
63         }
64     }
65 
66     modifier onlyAllowedOperator(address from) virtual {
67         // Allow spending tokens from addresses with balance
68         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
69         // from an EOA.
70         if (from != msg.sender) {
71             _checkFilterOperator(msg.sender);
72         }
73         _;
74     }
75 
76     modifier onlyAllowedOperatorApproval(address operator) virtual {
77         _checkFilterOperator(operator);
78         _;
79     }
80     
81     function _checkFilterOperator(address operator) internal view virtual {
82         // Check registry code length to facilitate testing in environments without a deployed registry.
83         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
84             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
85                 revert OperatorNotAllowed(operator);
86             }
87         }
88     }
89 }
90 
91 pragma solidity ^0.8.13;
92 
93 
94 /**
95  * @title  DefaultOperatorFilterer
96  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
97  */
98 abstract contract DefaultOperatorFilterer is OperatorFilterer {
99     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
100 
101     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
102 }
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev String operations.
108  */
109 library Strings {
110     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
111 
112     /**
113      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
114      */
115     function toString(uint256 value) internal pure returns (string memory) {
116         // Inspired by OraclizeAPI's implementation - MIT licence
117         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
118 
119         if (value == 0) {
120             return "0";
121         }
122         uint256 temp = value;
123         uint256 digits;
124         while (temp != 0) {
125             digits++;
126             temp /= 10;
127         }
128         bytes memory buffer = new bytes(digits);
129         while (value != 0) {
130             digits -= 1;
131             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
132             value /= 10;
133         }
134         return string(buffer);
135     }
136 
137     /**
138      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
139      */
140     function toHexString(uint256 value) internal pure returns (string memory) {
141         if (value == 0) {
142             return "0x00";
143         }
144         uint256 temp = value;
145         uint256 length = 0;
146         while (temp != 0) {
147             length++;
148             temp >>= 8;
149         }
150         return toHexString(value, length);
151     }
152 
153     /**
154      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
155      */
156     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
157         bytes memory buffer = new bytes(2 * length + 2);
158         buffer[0] = "0";
159         buffer[1] = "x";
160         for (uint256 i = 2 * length + 1; i > 1; --i) {
161             buffer[i] = _HEX_SYMBOLS[value & 0xf];
162             value >>= 4;
163         }
164         require(value == 0, "Strings: hex length insufficient");
165         return string(buffer);
166     }
167 }
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev Provides information about the current execution context, including the
173  * sender of the transaction and its data. While these are generally available
174  * via msg.sender and msg.data, they should not be accessed in such a direct
175  * manner, since when dealing with meta-transactions the account sending and
176  * paying for execution may not be the actual sender (as far as an application
177  * is concerned).
178  *
179  * This contract is only required for intermediate, library-like contracts.
180  */
181 abstract contract Context {
182     function _msgSender() internal view virtual returns (address) {
183         return msg.sender;
184     }
185 
186     function _msgData() internal view virtual returns (bytes calldata) {
187         return msg.data;
188     }
189 }
190 
191 pragma solidity ^0.8.0;
192 
193 
194 /**
195  * @dev Contract module which provides a basic access control mechanism, where
196  * there is an account (an owner) that can be granted exclusive access to
197  * specific functions.
198  *
199  * By default, the owner account will be the one that deploys the contract. This
200  * can later be changed with {transferOwnership}.
201  *
202  * This module is used through inheritance. It will make available the modifier
203  * `onlyOwner`, which can be applied to your functions to restrict their use to
204  * the owner.
205  */
206 abstract contract Ownable is Context {
207     address private _owner;
208 
209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
210 
211     /**
212      * @dev Initializes the contract setting the deployer as the initial owner.
213      */
214     constructor() {
215         _transferOwnership(_msgSender());
216     }
217 
218     /**
219      * @dev Throws if called by any account other than the owner.
220      */
221     modifier onlyOwner() {
222         _checkOwner();
223         _;
224     }
225 
226     /**
227      * @dev Returns the address of the current owner.
228      */
229     function owner() public view virtual returns (address) {
230         return _owner;
231     }
232 
233     /**
234      * @dev Throws if the sender is not the owner.
235      */
236     function _checkOwner() internal view virtual {
237         require(owner() == _msgSender(), "Ownable: caller is not the owner");
238     }
239 
240     /**
241      * @dev Leaves the contract without owner. It will not be possible to call
242      * `onlyOwner` functions anymore. Can only be called by the current owner.
243      *
244      * NOTE: Renouncing ownership will leave the contract without an owner,
245      * thereby removing any functionality that is only available to the owner.
246      */
247     function renounceOwnership() public virtual onlyOwner {
248         _transferOwnership(address(0));
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      * Can only be called by the current owner.
254      */
255     function transferOwnership(address newOwner) public virtual onlyOwner {
256         require(newOwner != address(0), "Ownable: new owner is the zero address");
257         _transferOwnership(newOwner);
258     }
259 
260     /**
261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
262      * Internal function without access restriction.
263      */
264     function _transferOwnership(address newOwner) internal virtual {
265         address oldOwner = _owner;
266         _owner = newOwner;
267         emit OwnershipTransferred(oldOwner, newOwner);
268     }
269 }
270 
271 pragma solidity ^0.8.1;
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      *
294      * [IMPORTANT]
295      * ====
296      * You shouldn't rely on `isContract` to protect against flash loan attacks!
297      *
298      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
299      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
300      * constructor.
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // This method relies on extcodesize/address.code.length, which returns 0
305         // for contracts in construction, since the code is only stored at the end
306         // of the constructor execution.
307 
308         return account.code.length > 0;
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         (bool success, ) = recipient.call{value: amount}("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain `call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      *
374      * Requirements:
375      *
376      * - the calling contract must have an ETH balance of at least `value`.
377      * - the called Solidity function must be `payable`.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(
382         address target,
383         bytes memory data,
384         uint256 value
385     ) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
391      * with `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(
396         address target,
397         bytes memory data,
398         uint256 value,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         require(address(this).balance >= value, "Address: insufficient balance for call");
402         require(isContract(target), "Address: call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.call{value: value}(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but performing a static call.
411      *
412      * _Available since v3.3._
413      */
414     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
415         return functionStaticCall(target, data, "Address: low-level static call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420      * but performing a static call.
421      *
422      * _Available since v3.3._
423      */
424     function functionStaticCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal view returns (bytes memory) {
429         require(isContract(target), "Address: static call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.staticcall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.4._
440      */
441     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
442         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a delegate call.
448      *
449      * _Available since v3.4._
450      */
451     function functionDelegateCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal returns (bytes memory) {
456         require(isContract(target), "Address: delegate call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.delegatecall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
464      * revert reason using the provided one.
465      *
466      * _Available since v4.3._
467      */
468     function verifyCallResult(
469         bool success,
470         bytes memory returndata,
471         string memory errorMessage
472     ) internal pure returns (bytes memory) {
473         if (success) {
474             return returndata;
475         } else {
476             // Look for revert reason and bubble it up if present
477             if (returndata.length > 0) {
478                 // The easiest way to bubble the revert reason is using memory via assembly
479                 /// @solidity memory-safe-assembly
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Interface of the ERC165 standard, as defined in the
495  * https://eips.ethereum.org/EIPS/eip-165[EIP].
496  *
497  * Implementers can declare support of contract interfaces, which can then be
498  * queried by others ({ERC165Checker}).
499  *
500  * For an implementation, see {ERC165}.
501  */
502 interface IERC165 {
503     /**
504      * @dev Returns true if this contract implements the interface defined by
505      * `interfaceId`. See the corresponding
506      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
507      * to learn more about how these ids are created.
508      *
509      * This function call must use less than 30 000 gas.
510      */
511     function supportsInterface(bytes4 interfaceId) external view returns (bool);
512 }
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @dev Implementation of the {IERC165} interface.
519  *
520  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
521  * for the additional interface id that will be supported. For example:
522  *
523  * ```solidity
524  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
526  * }
527  * ```
528  *
529  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
530  */
531 abstract contract ERC165 is IERC165 {
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         return interfaceId == type(IERC165).interfaceId;
537     }
538 }
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @dev _Available since v3.1._
545  */
546 interface IERC1155Receiver is IERC165 {
547     /**
548      * @dev Handles the receipt of a single ERC1155 token type. This function is
549      * called at the end of a `safeTransferFrom` after the balance has been updated.
550      *
551      * NOTE: To accept the transfer, this must return
552      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
553      * (i.e. 0xf23a6e61, or its own function selector).
554      *
555      * @param operator The address which initiated the transfer (i.e. msg.sender)
556      * @param from The address which previously owned the token
557      * @param id The ID of the token being transferred
558      * @param value The amount of tokens being transferred
559      * @param data Additional data with no specified format
560      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
561      */
562     function onERC1155Received(
563         address operator,
564         address from,
565         uint256 id,
566         uint256 value,
567         bytes calldata data
568     ) external returns (bytes4);
569 
570     /**
571      * @dev Handles the receipt of a multiple ERC1155 token types. This function
572      * is called at the end of a `safeBatchTransferFrom` after the balances have
573      * been updated.
574      *
575      * NOTE: To accept the transfer(s), this must return
576      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
577      * (i.e. 0xbc197c81, or its own function selector).
578      *
579      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
580      * @param from The address which previously owned the token
581      * @param ids An array containing ids of each token being transferred (order and length must match values array)
582      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
583      * @param data Additional data with no specified format
584      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
585      */
586     function onERC1155BatchReceived(
587         address operator,
588         address from,
589         uint256[] calldata ids,
590         uint256[] calldata values,
591         bytes calldata data
592     ) external returns (bytes4);
593 }
594 
595 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
596 
597 
598 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 
603 /**
604  * @dev Required interface of an ERC1155 compliant contract, as defined in the
605  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
606  *
607  * _Available since v3.1._
608  */
609 interface IERC1155 is IERC165 {
610     /**
611      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
612      */
613     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
614 
615     /**
616      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
617      * transfers.
618      */
619     event TransferBatch(
620         address indexed operator,
621         address indexed from,
622         address indexed to,
623         uint256[] ids,
624         uint256[] values
625     );
626 
627     /**
628      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
629      * `approved`.
630      */
631     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
632 
633     /**
634      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
635      *
636      * If an {URI} event was emitted for `id`, the standard
637      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
638      * returned by {IERC1155MetadataURI-uri}.
639      */
640     event URI(string value, uint256 indexed id);
641 
642     /**
643      * @dev Returns the amount of tokens of token type `id` owned by `account`.
644      *
645      * Requirements:
646      *
647      * - `account` cannot be the zero address.
648      */
649     function balanceOf(address account, uint256 id) external view returns (uint256);
650 
651     /**
652      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
653      *
654      * Requirements:
655      *
656      * - `accounts` and `ids` must have the same length.
657      */
658     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
659         external
660         view
661         returns (uint256[] memory);
662 
663     /**
664      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
665      *
666      * Emits an {ApprovalForAll} event.
667      *
668      * Requirements:
669      *
670      * - `operator` cannot be the caller.
671      */
672     function setApprovalForAll(address operator, bool approved) external;
673 
674     /**
675      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
676      *
677      * See {setApprovalForAll}.
678      */
679     function isApprovedForAll(address account, address operator) external view returns (bool);
680 
681     /**
682      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
683      *
684      * Emits a {TransferSingle} event.
685      *
686      * Requirements:
687      *
688      * - `to` cannot be the zero address.
689      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
690      * - `from` must have a balance of tokens of type `id` of at least `amount`.
691      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
692      * acceptance magic value.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 id,
698         uint256 amount,
699         bytes calldata data
700     ) external;
701 
702     /**
703      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
704      *
705      * Emits a {TransferBatch} event.
706      *
707      * Requirements:
708      *
709      * - `ids` and `amounts` must have the same length.
710      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
711      * acceptance magic value.
712      */
713     function safeBatchTransferFrom(
714         address from,
715         address to,
716         uint256[] calldata ids,
717         uint256[] calldata amounts,
718         bytes calldata data
719     ) external;
720 }
721 
722 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 
730 /**
731  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
732  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
733  *
734  * _Available since v3.1._
735  */
736 interface IERC1155MetadataURI is IERC1155 {
737     /**
738      * @dev Returns the URI for token type `id`.
739      *
740      * If the `\{id\}` substring is present in the URI, it must be replaced by
741      * clients with the actual token type ID.
742      */
743     function uri(uint256 id) external view returns (string memory);
744 }
745 
746 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
747 
748 
749 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
750 
751 pragma solidity ^0.8.0;
752 
753 
754 
755 
756 
757 
758 
759 /**
760  * @dev Implementation of the basic standard multi-token.
761  * See https://eips.ethereum.org/EIPS/eip-1155
762  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
763  *
764  * _Available since v3.1._
765  */
766 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
767     using Address for address;
768 
769     // Mapping from token ID to account balances
770     mapping(uint256 => mapping(address => uint256)) private _balances;
771 
772     // Mapping from account to operator approvals
773     mapping(address => mapping(address => bool)) private _operatorApprovals;
774 
775     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
776     string private _uri;
777 
778     /**
779      * @dev See {_setURI}.
780      */
781     constructor(string memory uri_) {
782         _setURI(uri_);
783     }
784 
785     /**
786      * @dev See {IERC165-supportsInterface}.
787      */
788     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
789         return
790             interfaceId == type(IERC1155).interfaceId ||
791             interfaceId == type(IERC1155MetadataURI).interfaceId ||
792             super.supportsInterface(interfaceId);
793     }
794 
795     /**
796      * @dev See {IERC1155MetadataURI-uri}.
797      *
798      * This implementation returns the same URI for *all* token types. It relies
799      * on the token type ID substitution mechanism
800      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
801      *
802      * Clients calling this function must replace the `\{id\}` substring with the
803      * actual token type ID.
804      */
805     function uri(uint256) public view virtual override returns (string memory) {
806         return _uri;
807     }
808 
809     /**
810      * @dev See {IERC1155-balanceOf}.
811      *
812      * Requirements:
813      *
814      * - `account` cannot be the zero address.
815      */
816     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
817         require(account != address(0), "ERC1155: address zero is not a valid owner");
818         return _balances[id][account];
819     }
820 
821     /**
822      * @dev See {IERC1155-balanceOfBatch}.
823      *
824      * Requirements:
825      *
826      * - `accounts` and `ids` must have the same length.
827      */
828     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
829         public
830         view
831         virtual
832         override
833         returns (uint256[] memory)
834     {
835         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
836 
837         uint256[] memory batchBalances = new uint256[](accounts.length);
838 
839         for (uint256 i = 0; i < accounts.length; ++i) {
840             batchBalances[i] = balanceOf(accounts[i], ids[i]);
841         }
842 
843         return batchBalances;
844     }
845 
846     /**
847      * @dev See {IERC1155-setApprovalForAll}.
848      */
849     function setApprovalForAll(address operator, bool approved) public virtual override {
850         _setApprovalForAll(_msgSender(), operator, approved);
851     }
852 
853     /**
854      * @dev See {IERC1155-isApprovedForAll}.
855      */
856     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
857         return _operatorApprovals[account][operator];
858     }
859 
860     /**
861      * @dev See {IERC1155-safeTransferFrom}.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 id,
867         uint256 amount,
868         bytes memory data
869     ) public virtual override {
870         require(
871             from == _msgSender() || isApprovedForAll(from, _msgSender()),
872             "ERC1155: caller is not token owner nor approved"
873         );
874         _safeTransferFrom(from, to, id, amount, data);
875     }
876 
877     /**
878      * @dev See {IERC1155-safeBatchTransferFrom}.
879      */
880     function safeBatchTransferFrom(
881         address from,
882         address to,
883         uint256[] memory ids,
884         uint256[] memory amounts,
885         bytes memory data
886     ) public virtual override {
887         require(
888             from == _msgSender() || isApprovedForAll(from, _msgSender()),
889             "ERC1155: caller is not token owner nor approved"
890         );
891         _safeBatchTransferFrom(from, to, ids, amounts, data);
892     }
893 
894     /**
895      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
896      *
897      * Emits a {TransferSingle} event.
898      *
899      * Requirements:
900      *
901      * - `to` cannot be the zero address.
902      * - `from` must have a balance of tokens of type `id` of at least `amount`.
903      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
904      * acceptance magic value.
905      */
906     function _safeTransferFrom(
907         address from,
908         address to,
909         uint256 id,
910         uint256 amount,
911         bytes memory data
912     ) internal virtual {
913         require(to != address(0), "ERC1155: transfer to the zero address");
914 
915         address operator = _msgSender();
916         uint256[] memory ids = _asSingletonArray(id);
917         uint256[] memory amounts = _asSingletonArray(amount);
918 
919         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
920 
921         uint256 fromBalance = _balances[id][from];
922         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
923         unchecked {
924             _balances[id][from] = fromBalance - amount;
925         }
926         _balances[id][to] += amount;
927 
928         emit TransferSingle(operator, from, to, id, amount);
929 
930         _afterTokenTransfer(operator, from, to, ids, amounts, data);
931 
932         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
933     }
934 
935     /**
936      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
937      *
938      * Emits a {TransferBatch} event.
939      *
940      * Requirements:
941      *
942      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
943      * acceptance magic value.
944      */
945     function _safeBatchTransferFrom(
946         address from,
947         address to,
948         uint256[] memory ids,
949         uint256[] memory amounts,
950         bytes memory data
951     ) internal virtual {
952         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
953         require(to != address(0), "ERC1155: transfer to the zero address");
954 
955         address operator = _msgSender();
956 
957         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
958 
959         for (uint256 i = 0; i < ids.length; ++i) {
960             uint256 id = ids[i];
961             uint256 amount = amounts[i];
962 
963             uint256 fromBalance = _balances[id][from];
964             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
965             unchecked {
966                 _balances[id][from] = fromBalance - amount;
967             }
968             _balances[id][to] += amount;
969         }
970 
971         emit TransferBatch(operator, from, to, ids, amounts);
972 
973         _afterTokenTransfer(operator, from, to, ids, amounts, data);
974 
975         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
976     }
977 
978     /**
979      * @dev Sets a new URI for all token types, by relying on the token type ID
980      * substitution mechanism
981      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
982      *
983      * By this mechanism, any occurrence of the `\{id\}` substring in either the
984      * URI or any of the amounts in the JSON file at said URI will be replaced by
985      * clients with the token type ID.
986      *
987      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
988      * interpreted by clients as
989      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
990      * for token type ID 0x4cce0.
991      *
992      * See {uri}.
993      *
994      * Because these URIs cannot be meaningfully represented by the {URI} event,
995      * this function emits no events.
996      */
997     function _setURI(string memory newuri) internal virtual {
998         _uri = newuri;
999     }
1000 
1001     /**
1002      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1003      *
1004      * Emits a {TransferSingle} event.
1005      *
1006      * Requirements:
1007      *
1008      * - `to` cannot be the zero address.
1009      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1010      * acceptance magic value.
1011      */
1012     function _mint(
1013         address to,
1014         uint256 id,
1015         uint256 amount,
1016         bytes memory data
1017     ) internal virtual {
1018         require(to != address(0), "ERC1155: mint to the zero address");
1019 
1020         address operator = _msgSender();
1021         uint256[] memory ids = _asSingletonArray(id);
1022         uint256[] memory amounts = _asSingletonArray(amount);
1023 
1024         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1025 
1026         _balances[id][to] += amount;
1027         emit TransferSingle(operator, address(0), to, id, amount);
1028 
1029         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1030 
1031         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1032     }
1033 
1034     /**
1035      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1036      *
1037      * Emits a {TransferBatch} event.
1038      *
1039      * Requirements:
1040      *
1041      * - `ids` and `amounts` must have the same length.
1042      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1043      * acceptance magic value.
1044      */
1045     function _mintBatch(
1046         address to,
1047         uint256[] memory ids,
1048         uint256[] memory amounts,
1049         bytes memory data
1050     ) internal virtual {
1051         require(to != address(0), "ERC1155: mint to the zero address");
1052         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1053 
1054         address operator = _msgSender();
1055 
1056         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1057 
1058         for (uint256 i = 0; i < ids.length; i++) {
1059             _balances[ids[i]][to] += amounts[i];
1060         }
1061 
1062         emit TransferBatch(operator, address(0), to, ids, amounts);
1063 
1064         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1065 
1066         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1067     }
1068 
1069     /**
1070      * @dev Destroys `amount` tokens of token type `id` from `from`
1071      *
1072      * Emits a {TransferSingle} event.
1073      *
1074      * Requirements:
1075      *
1076      * - `from` cannot be the zero address.
1077      * - `from` must have at least `amount` tokens of token type `id`.
1078      */
1079     function _burn(
1080         address from,
1081         uint256 id,
1082         uint256 amount
1083     ) internal virtual {
1084         require(from != address(0), "ERC1155: burn from the zero address");
1085 
1086         address operator = _msgSender();
1087         uint256[] memory ids = _asSingletonArray(id);
1088         uint256[] memory amounts = _asSingletonArray(amount);
1089 
1090         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1091 
1092         uint256 fromBalance = _balances[id][from];
1093         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1094         unchecked {
1095             _balances[id][from] = fromBalance - amount;
1096         }
1097 
1098         emit TransferSingle(operator, from, address(0), id, amount);
1099 
1100         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1101     }
1102 
1103     /**
1104      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1105      *
1106      * Emits a {TransferBatch} event.
1107      *
1108      * Requirements:
1109      *
1110      * - `ids` and `amounts` must have the same length.
1111      */
1112     function _burnBatch(
1113         address from,
1114         uint256[] memory ids,
1115         uint256[] memory amounts
1116     ) internal virtual {
1117         require(from != address(0), "ERC1155: burn from the zero address");
1118         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1119 
1120         address operator = _msgSender();
1121 
1122         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1123 
1124         for (uint256 i = 0; i < ids.length; i++) {
1125             uint256 id = ids[i];
1126             uint256 amount = amounts[i];
1127 
1128             uint256 fromBalance = _balances[id][from];
1129             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1130             unchecked {
1131                 _balances[id][from] = fromBalance - amount;
1132             }
1133         }
1134 
1135         emit TransferBatch(operator, from, address(0), ids, amounts);
1136 
1137         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1138     }
1139 
1140     /**
1141      * @dev Approve `operator` to operate on all of `owner` tokens
1142      *
1143      * Emits an {ApprovalForAll} event.
1144      */
1145     function _setApprovalForAll(
1146         address owner,
1147         address operator,
1148         bool approved
1149     ) internal virtual {
1150         require(owner != operator, "ERC1155: setting approval status for self");
1151         _operatorApprovals[owner][operator] = approved;
1152         emit ApprovalForAll(owner, operator, approved);
1153     }
1154 
1155     /**
1156      * @dev Hook that is called before any token transfer. This includes minting
1157      * and burning, as well as batched variants.
1158      *
1159      * The same hook is called on both single and batched variants. For single
1160      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1161      *
1162      * Calling conditions (for each `id` and `amount` pair):
1163      *
1164      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1165      * of token type `id` will be  transferred to `to`.
1166      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1167      * for `to`.
1168      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1169      * will be burned.
1170      * - `from` and `to` are never both zero.
1171      * - `ids` and `amounts` have the same, non-zero length.
1172      *
1173      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1174      */
1175     function _beforeTokenTransfer(
1176         address operator,
1177         address from,
1178         address to,
1179         uint256[] memory ids,
1180         uint256[] memory amounts,
1181         bytes memory data
1182     ) internal virtual {}
1183 
1184     /**
1185      * @dev Hook that is called after any token transfer. This includes minting
1186      * and burning, as well as batched variants.
1187      *
1188      * The same hook is called on both single and batched variants. For single
1189      * transfers, the length of the `id` and `amount` arrays will be 1.
1190      *
1191      * Calling conditions (for each `id` and `amount` pair):
1192      *
1193      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1194      * of token type `id` will be  transferred to `to`.
1195      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1196      * for `to`.
1197      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1198      * will be burned.
1199      * - `from` and `to` are never both zero.
1200      * - `ids` and `amounts` have the same, non-zero length.
1201      *
1202      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1203      */
1204     function _afterTokenTransfer(
1205         address operator,
1206         address from,
1207         address to,
1208         uint256[] memory ids,
1209         uint256[] memory amounts,
1210         bytes memory data
1211     ) internal virtual {}
1212 
1213     function _doSafeTransferAcceptanceCheck(
1214         address operator,
1215         address from,
1216         address to,
1217         uint256 id,
1218         uint256 amount,
1219         bytes memory data
1220     ) private {
1221         if (to.isContract()) {
1222             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1223                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1224                     revert("ERC1155: ERC1155Receiver rejected tokens");
1225                 }
1226             } catch Error(string memory reason) {
1227                 revert(reason);
1228             } catch {
1229                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1230             }
1231         }
1232     }
1233 
1234     function _doSafeBatchTransferAcceptanceCheck(
1235         address operator,
1236         address from,
1237         address to,
1238         uint256[] memory ids,
1239         uint256[] memory amounts,
1240         bytes memory data
1241     ) private {
1242         if (to.isContract()) {
1243             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1244                 bytes4 response
1245             ) {
1246                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1247                     revert("ERC1155: ERC1155Receiver rejected tokens");
1248                 }
1249             } catch Error(string memory reason) {
1250                 revert(reason);
1251             } catch {
1252                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1253             }
1254         }
1255     }
1256 
1257     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1258         uint256[] memory array = new uint256[](1);
1259         array[0] = element;
1260 
1261         return array;
1262     }
1263 }
1264 
1265 pragma solidity ^0.8.7;
1266 
1267 contract goblinHelix is ERC1155, Ownable, DefaultOperatorFilterer {    
1268 
1269     string public metadata;
1270     string public name_;
1271     string public symbol_;  
1272     
1273     constructor() ERC1155(metadata)  {
1274         name_ = "goblinHelix";
1275         symbol_ = "GTHX";
1276     }
1277     
1278     function airdrop(uint256[] calldata tokenAmount, address[] calldata wallet, uint256 tokenId) public onlyOwner {
1279         for(uint256 i = 0; i < wallet.length; i++) 
1280             _mint(wallet[i], tokenId, tokenAmount[i], "");
1281     }
1282 
1283     function setMetadata(string calldata _uri) public onlyOwner {
1284         metadata = _uri;
1285     }
1286 
1287     function uri(uint256 tokenId) public view override returns (string memory) {
1288         return string(abi.encodePacked(metadata, Strings.toString(tokenId)));
1289     }
1290 
1291     function name() public view returns (string memory) {
1292         return name_;
1293     }
1294 
1295     function symbol() public view returns (string memory) {
1296         return symbol_;
1297     }
1298 
1299     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1300         super.setApprovalForAll(operator, approved);
1301     }
1302 
1303     function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount, bytes memory data)
1304         public
1305         override
1306         onlyAllowedOperator(from)
1307     {
1308         super.safeTransferFrom(from, to, tokenId, amount, data);
1309     }
1310 
1311     function safeBatchTransferFrom(
1312         address from,
1313         address to,
1314         uint256[] memory ids,
1315         uint256[] memory amounts,
1316         bytes memory data
1317     ) public virtual override onlyAllowedOperator(from) {
1318         super.safeBatchTransferFrom(from, to, ids, amounts, data);
1319     }
1320 }