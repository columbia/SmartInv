1 // SPDX-License-Identifier: MIT
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 
115 /**
116  * @dev Contract module which provides a basic access control mechanism, where
117  * there is an account (an owner) that can be granted exclusive access to
118  * specific functions.
119  *
120  * By default, the owner account will be the one that deploys the contract. This
121  * can later be changed with {transferOwnership}.
122  *
123  * This module is used through inheritance. It will make available the modifier
124  * `onlyOwner`, which can be applied to your functions to restrict their use to
125  * the owner.
126  */
127 abstract contract Ownable is Context {
128     address private _owner;
129 
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132     /**
133      * @dev Initializes the contract setting the deployer as the initial owner.
134      */
135     constructor() {
136         _transferOwnership(_msgSender());
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         _checkOwner();
144         _;
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view virtual returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if the sender is not the owner.
156      */
157     function _checkOwner() internal view virtual {
158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
159     }
160 
161     /**
162      * @dev Leaves the contract without owner. It will not be possible to call
163      * `onlyOwner` functions anymore. Can only be called by the current owner.
164      *
165      * NOTE: Renouncing ownership will leave the contract without an owner,
166      * thereby removing any functionality that is only available to the owner.
167      */
168     function renounceOwnership() public virtual onlyOwner {
169         _transferOwnership(address(0));
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _transferOwnership(newOwner);
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Internal function without access restriction.
184      */
185     function _transferOwnership(address newOwner) internal virtual {
186         address oldOwner = _owner;
187         _owner = newOwner;
188         emit OwnershipTransferred(oldOwner, newOwner);
189     }
190 }
191 
192 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
193 
194 
195 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
196 
197 pragma solidity ^0.8.1;
198 
199 /**
200  * @dev Collection of functions related to the address type
201  */
202 library Address {
203     /**
204      * @dev Returns true if `account` is a contract.
205      *
206      * [IMPORTANT]
207      * ====
208      * It is unsafe to assume that an address for which this function returns
209      * false is an externally-owned account (EOA) and not a contract.
210      *
211      * Among others, `isContract` will return false for the following
212      * types of addresses:
213      *
214      *  - an externally-owned account
215      *  - a contract in construction
216      *  - an address where a contract will be created
217      *  - an address where a contract lived, but was destroyed
218      * ====
219      *
220      * [IMPORTANT]
221      * ====
222      * You shouldn't rely on `isContract` to protect against flash loan attacks!
223      *
224      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
225      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
226      * constructor.
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // This method relies on extcodesize/address.code.length, which returns 0
231         // for contracts in construction, since the code is only stored at the end
232         // of the constructor execution.
233 
234         return account.code.length > 0;
235     }
236 
237     /**
238      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
239      * `recipient`, forwarding all available gas and reverting on errors.
240      *
241      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
242      * of certain opcodes, possibly making contracts go over the 2300 gas limit
243      * imposed by `transfer`, making them unable to receive funds via
244      * `transfer`. {sendValue} removes this limitation.
245      *
246      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
247      *
248      * IMPORTANT: because control is transferred to `recipient`, care must be
249      * taken to not create reentrancy vulnerabilities. Consider using
250      * {ReentrancyGuard} or the
251      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
252      */
253     function sendValue(address payable recipient, uint256 amount) internal {
254         require(address(this).balance >= amount, "Address: insufficient balance");
255 
256         (bool success, ) = recipient.call{value: amount}("");
257         require(success, "Address: unable to send value, recipient may have reverted");
258     }
259 
260     /**
261      * @dev Performs a Solidity function call using a low level `call`. A
262      * plain `call` is an unsafe replacement for a function call: use this
263      * function instead.
264      *
265      * If `target` reverts with a revert reason, it is bubbled up by this
266      * function (like regular Solidity function calls).
267      *
268      * Returns the raw returned data. To convert to the expected return value,
269      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270      *
271      * Requirements:
272      *
273      * - `target` must be a contract.
274      * - calling `target` with `data` must not revert.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
317      * with `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         (bool success, bytes memory returndata) = target.call{value: value}(data);
329         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
339         return functionStaticCall(target, data, "Address: low-level static call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal view returns (bytes memory) {
353         (bool success, bytes memory returndata) = target.staticcall(data);
354         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
364         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         (bool success, bytes memory returndata) = target.delegatecall(data);
379         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
384      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
385      *
386      * _Available since v4.8._
387      */
388     function verifyCallResultFromTarget(
389         address target,
390         bool success,
391         bytes memory returndata,
392         string memory errorMessage
393     ) internal view returns (bytes memory) {
394         if (success) {
395             if (returndata.length == 0) {
396                 // only check isContract if the call was successful and the return data is empty
397                 // otherwise we already know that it was a contract
398                 require(isContract(target), "Address: call to non-contract");
399             }
400             return returndata;
401         } else {
402             _revert(returndata, errorMessage);
403         }
404     }
405 
406     /**
407      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
408      * revert reason or using the provided one.
409      *
410      * _Available since v4.3._
411      */
412     function verifyCallResult(
413         bool success,
414         bytes memory returndata,
415         string memory errorMessage
416     ) internal pure returns (bytes memory) {
417         if (success) {
418             return returndata;
419         } else {
420             _revert(returndata, errorMessage);
421         }
422     }
423 
424     function _revert(bytes memory returndata, string memory errorMessage) private pure {
425         // Look for revert reason and bubble it up if present
426         if (returndata.length > 0) {
427             // The easiest way to bubble the revert reason is using memory via assembly
428             /// @solidity memory-safe-assembly
429             assembly {
430                 let returndata_size := mload(returndata)
431                 revert(add(32, returndata), returndata_size)
432             }
433         } else {
434             revert(errorMessage);
435         }
436     }
437 }
438 
439 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev Interface of the ERC165 standard, as defined in the
448  * https://eips.ethereum.org/EIPS/eip-165[EIP].
449  *
450  * Implementers can declare support of contract interfaces, which can then be
451  * queried by others ({ERC165Checker}).
452  *
453  * For an implementation, see {ERC165}.
454  */
455 interface IERC165 {
456     /**
457      * @dev Returns true if this contract implements the interface defined by
458      * `interfaceId`. See the corresponding
459      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
460      * to learn more about how these ids are created.
461      *
462      * This function call must use less than 30 000 gas.
463      */
464     function supportsInterface(bytes4 interfaceId) external view returns (bool);
465 }
466 
467 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 
475 /**
476  * @dev Implementation of the {IERC165} interface.
477  *
478  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
479  * for the additional interface id that will be supported. For example:
480  *
481  * ```solidity
482  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
484  * }
485  * ```
486  *
487  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
488  */
489 abstract contract ERC165 is IERC165 {
490     /**
491      * @dev See {IERC165-supportsInterface}.
492      */
493     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
494         return interfaceId == type(IERC165).interfaceId;
495     }
496 }
497 
498 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol
499 
500 
501 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 
506 /**
507  * @dev _Available since v3.1._
508  */
509 interface IERC1155Receiver is IERC165 {
510     /**
511      * @dev Handles the receipt of a single ERC1155 token type. This function is
512      * called at the end of a `safeTransferFrom` after the balance has been updated.
513      *
514      * NOTE: To accept the transfer, this must return
515      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
516      * (i.e. 0xf23a6e61, or its own function selector).
517      *
518      * @param operator The address which initiated the transfer (i.e. msg.sender)
519      * @param from The address which previously owned the token
520      * @param id The ID of the token being transferred
521      * @param value The amount of tokens being transferred
522      * @param data Additional data with no specified format
523      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
524      */
525     function onERC1155Received(
526         address operator,
527         address from,
528         uint256 id,
529         uint256 value,
530         bytes calldata data
531     ) external returns (bytes4);
532 
533     /**
534      * @dev Handles the receipt of a multiple ERC1155 token types. This function
535      * is called at the end of a `safeBatchTransferFrom` after the balances have
536      * been updated.
537      *
538      * NOTE: To accept the transfer(s), this must return
539      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
540      * (i.e. 0xbc197c81, or its own function selector).
541      *
542      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
543      * @param from The address which previously owned the token
544      * @param ids An array containing ids of each token being transferred (order and length must match values array)
545      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
546      * @param data Additional data with no specified format
547      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
548      */
549     function onERC1155BatchReceived(
550         address operator,
551         address from,
552         uint256[] calldata ids,
553         uint256[] calldata values,
554         bytes calldata data
555     ) external returns (bytes4);
556 }
557 
558 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol
559 
560 
561 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @dev Required interface of an ERC1155 compliant contract, as defined in the
568  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
569  *
570  * _Available since v3.1._
571  */
572 interface IERC1155 is IERC165 {
573     /**
574      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
575      */
576     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
577 
578     /**
579      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
580      * transfers.
581      */
582     event TransferBatch(
583         address indexed operator,
584         address indexed from,
585         address indexed to,
586         uint256[] ids,
587         uint256[] values
588     );
589 
590     /**
591      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
592      * `approved`.
593      */
594     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
595 
596     /**
597      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
598      *
599      * If an {URI} event was emitted for `id`, the standard
600      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
601      * returned by {IERC1155MetadataURI-uri}.
602      */
603     event URI(string value, uint256 indexed id);
604 
605     /**
606      * @dev Returns the amount of tokens of token type `id` owned by `account`.
607      *
608      * Requirements:
609      *
610      * - `account` cannot be the zero address.
611      */
612     function balanceOf(address account, uint256 id) external view returns (uint256);
613 
614     /**
615      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
616      *
617      * Requirements:
618      *
619      * - `accounts` and `ids` must have the same length.
620      */
621     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
622         external
623         view
624         returns (uint256[] memory);
625 
626     /**
627      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
628      *
629      * Emits an {ApprovalForAll} event.
630      *
631      * Requirements:
632      *
633      * - `operator` cannot be the caller.
634      */
635     function setApprovalForAll(address operator, bool approved) external;
636 
637     /**
638      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
639      *
640      * See {setApprovalForAll}.
641      */
642     function isApprovedForAll(address account, address operator) external view returns (bool);
643 
644     /**
645      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
646      *
647      * Emits a {TransferSingle} event.
648      *
649      * Requirements:
650      *
651      * - `to` cannot be the zero address.
652      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
653      * - `from` must have a balance of tokens of type `id` of at least `amount`.
654      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
655      * acceptance magic value.
656      */
657     function safeTransferFrom(
658         address from,
659         address to,
660         uint256 id,
661         uint256 amount,
662         bytes calldata data
663     ) external;
664 
665     /**
666      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
667      *
668      * Emits a {TransferBatch} event.
669      *
670      * Requirements:
671      *
672      * - `ids` and `amounts` must have the same length.
673      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
674      * acceptance magic value.
675      */
676     function safeBatchTransferFrom(
677         address from,
678         address to,
679         uint256[] calldata ids,
680         uint256[] calldata amounts,
681         bytes calldata data
682     ) external;
683 }
684 
685 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 /**
694  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
695  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
696  *
697  * _Available since v3.1._
698  */
699 interface IERC1155MetadataURI is IERC1155 {
700     /**
701      * @dev Returns the URI for token type `id`.
702      *
703      * If the `\{id\}` substring is present in the URI, it must be replaced by
704      * clients with the actual token type ID.
705      */
706     function uri(uint256 id) external view returns (string memory);
707 }
708 
709 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
710 
711 
712 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 
718 
719 
720 
721 
722 /**
723  * @dev Implementation of the basic standard multi-token.
724  * See https://eips.ethereum.org/EIPS/eip-1155
725  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
726  *
727  * _Available since v3.1._
728  */
729 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
730     using Address for address;
731 
732     // Mapping from token ID to account balances
733     mapping(uint256 => mapping(address => uint256)) private _balances;
734 
735     // Mapping from account to operator approvals
736     mapping(address => mapping(address => bool)) private _operatorApprovals;
737 
738     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
739     string private _uri;
740 
741     /**
742      * @dev See {_setURI}.
743      */
744     constructor(string memory uri_) {
745         _setURI(uri_);
746     }
747 
748     /**
749      * @dev See {IERC165-supportsInterface}.
750      */
751     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
752         return
753             interfaceId == type(IERC1155).interfaceId ||
754             interfaceId == type(IERC1155MetadataURI).interfaceId ||
755             super.supportsInterface(interfaceId);
756     }
757 
758     /**
759      * @dev See {IERC1155MetadataURI-uri}.
760      *
761      * This implementation returns the same URI for *all* token types. It relies
762      * on the token type ID substitution mechanism
763      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
764      *
765      * Clients calling this function must replace the `\{id\}` substring with the
766      * actual token type ID.
767      */
768     function uri(uint256) public view virtual override returns (string memory) {
769         return _uri;
770     }
771 
772     /**
773      * @dev See {IERC1155-balanceOf}.
774      *
775      * Requirements:
776      *
777      * - `account` cannot be the zero address.
778      */
779     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
780         require(account != address(0), "ERC1155: address zero is not a valid owner");
781         return _balances[id][account];
782     }
783 
784     /**
785      * @dev See {IERC1155-balanceOfBatch}.
786      *
787      * Requirements:
788      *
789      * - `accounts` and `ids` must have the same length.
790      */
791     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
792         public
793         view
794         virtual
795         override
796         returns (uint256[] memory)
797     {
798         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
799 
800         uint256[] memory batchBalances = new uint256[](accounts.length);
801 
802         for (uint256 i = 0; i < accounts.length; ++i) {
803             batchBalances[i] = balanceOf(accounts[i], ids[i]);
804         }
805 
806         return batchBalances;
807     }
808 
809     /**
810      * @dev See {IERC1155-setApprovalForAll}.
811      */
812     function setApprovalForAll(address operator, bool approved) public virtual override {
813         _setApprovalForAll(_msgSender(), operator, approved);
814     }
815 
816     /**
817      * @dev See {IERC1155-isApprovedForAll}.
818      */
819     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
820         return _operatorApprovals[account][operator];
821     }
822 
823     /**
824      * @dev See {IERC1155-safeTransferFrom}.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 id,
830         uint256 amount,
831         bytes memory data
832     ) public virtual override {
833         require(
834             from == _msgSender() || isApprovedForAll(from, _msgSender()),
835             "ERC1155: caller is not token owner nor approved"
836         );
837         _safeTransferFrom(from, to, id, amount, data);
838     }
839 
840     /**
841      * @dev See {IERC1155-safeBatchTransferFrom}.
842      */
843     function safeBatchTransferFrom(
844         address from,
845         address to,
846         uint256[] memory ids,
847         uint256[] memory amounts,
848         bytes memory data
849     ) public virtual override {
850         require(
851             from == _msgSender() || isApprovedForAll(from, _msgSender()),
852             "ERC1155: caller is not token owner nor approved"
853         );
854         _safeBatchTransferFrom(from, to, ids, amounts, data);
855     }
856 
857     /**
858      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
859      *
860      * Emits a {TransferSingle} event.
861      *
862      * Requirements:
863      *
864      * - `to` cannot be the zero address.
865      * - `from` must have a balance of tokens of type `id` of at least `amount`.
866      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
867      * acceptance magic value.
868      */
869     function _safeTransferFrom(
870         address from,
871         address to,
872         uint256 id,
873         uint256 amount,
874         bytes memory data
875     ) internal virtual {
876         require(to != address(0), "ERC1155: transfer to the zero address");
877 
878         address operator = _msgSender();
879         uint256[] memory ids = _asSingletonArray(id);
880         uint256[] memory amounts = _asSingletonArray(amount);
881 
882         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
883 
884         uint256 fromBalance = _balances[id][from];
885         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
886         unchecked {
887             _balances[id][from] = fromBalance - amount;
888         }
889         _balances[id][to] += amount;
890 
891         emit TransferSingle(operator, from, to, id, amount);
892 
893         _afterTokenTransfer(operator, from, to, ids, amounts, data);
894 
895         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
896     }
897 
898     /**
899      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
900      *
901      * Emits a {TransferBatch} event.
902      *
903      * Requirements:
904      *
905      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
906      * acceptance magic value.
907      */
908     function _safeBatchTransferFrom(
909         address from,
910         address to,
911         uint256[] memory ids,
912         uint256[] memory amounts,
913         bytes memory data
914     ) internal virtual {
915         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
916         require(to != address(0), "ERC1155: transfer to the zero address");
917 
918         address operator = _msgSender();
919 
920         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
921 
922         for (uint256 i = 0; i < ids.length; ++i) {
923             uint256 id = ids[i];
924             uint256 amount = amounts[i];
925 
926             uint256 fromBalance = _balances[id][from];
927             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
928             unchecked {
929                 _balances[id][from] = fromBalance - amount;
930             }
931             _balances[id][to] += amount;
932         }
933 
934         emit TransferBatch(operator, from, to, ids, amounts);
935 
936         _afterTokenTransfer(operator, from, to, ids, amounts, data);
937 
938         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
939     }
940 
941     /**
942      * @dev Sets a new URI for all token types, by relying on the token type ID
943      * substitution mechanism
944      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
945      *
946      * By this mechanism, any occurrence of the `\{id\}` substring in either the
947      * URI or any of the amounts in the JSON file at said URI will be replaced by
948      * clients with the token type ID.
949      *
950      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
951      * interpreted by clients as
952      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
953      * for token type ID 0x4cce0.
954      *
955      * See {uri}.
956      *
957      * Because these URIs cannot be meaningfully represented by the {URI} event,
958      * this function emits no events.
959      */
960     function _setURI(string memory newuri) internal virtual {
961         _uri = newuri;
962     }
963 
964     /**
965      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
966      *
967      * Emits a {TransferSingle} event.
968      *
969      * Requirements:
970      *
971      * - `to` cannot be the zero address.
972      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
973      * acceptance magic value.
974      */
975     function _mint(
976         address to,
977         uint256 id,
978         uint256 amount,
979         bytes memory data
980     ) internal virtual {
981         require(to != address(0), "ERC1155: mint to the zero address");
982 
983         address operator = _msgSender();
984         uint256[] memory ids = _asSingletonArray(id);
985         uint256[] memory amounts = _asSingletonArray(amount);
986 
987         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
988 
989         _balances[id][to] += amount;
990         emit TransferSingle(operator, address(0), to, id, amount);
991 
992         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
993 
994         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
995     }
996 
997     /**
998      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
999      *
1000      * Emits a {TransferBatch} event.
1001      *
1002      * Requirements:
1003      *
1004      * - `ids` and `amounts` must have the same length.
1005      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1006      * acceptance magic value.
1007      */
1008     function _mintBatch(
1009         address to,
1010         uint256[] memory ids,
1011         uint256[] memory amounts,
1012         bytes memory data
1013     ) internal virtual {
1014         require(to != address(0), "ERC1155: mint to the zero address");
1015         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1016 
1017         address operator = _msgSender();
1018 
1019         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1020 
1021         for (uint256 i = 0; i < ids.length; i++) {
1022             _balances[ids[i]][to] += amounts[i];
1023         }
1024 
1025         emit TransferBatch(operator, address(0), to, ids, amounts);
1026 
1027         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1028 
1029         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1030     }
1031 
1032     /**
1033      * @dev Destroys `amount` tokens of token type `id` from `from`
1034      *
1035      * Emits a {TransferSingle} event.
1036      *
1037      * Requirements:
1038      *
1039      * - `from` cannot be the zero address.
1040      * - `from` must have at least `amount` tokens of token type `id`.
1041      */
1042     function _burn(
1043         address from,
1044         uint256 id,
1045         uint256 amount
1046     ) internal virtual {
1047         require(from != address(0), "ERC1155: burn from the zero address");
1048 
1049         address operator = _msgSender();
1050         uint256[] memory ids = _asSingletonArray(id);
1051         uint256[] memory amounts = _asSingletonArray(amount);
1052 
1053         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1054 
1055         uint256 fromBalance = _balances[id][from];
1056         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1057         unchecked {
1058             _balances[id][from] = fromBalance - amount;
1059         }
1060 
1061         emit TransferSingle(operator, from, address(0), id, amount);
1062 
1063         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1064     }
1065 
1066     /**
1067      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1068      *
1069      * Emits a {TransferBatch} event.
1070      *
1071      * Requirements:
1072      *
1073      * - `ids` and `amounts` must have the same length.
1074      */
1075     function _burnBatch(
1076         address from,
1077         uint256[] memory ids,
1078         uint256[] memory amounts
1079     ) internal virtual {
1080         require(from != address(0), "ERC1155: burn from the zero address");
1081         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1082 
1083         address operator = _msgSender();
1084 
1085         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1086 
1087         for (uint256 i = 0; i < ids.length; i++) {
1088             uint256 id = ids[i];
1089             uint256 amount = amounts[i];
1090 
1091             uint256 fromBalance = _balances[id][from];
1092             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1093             unchecked {
1094                 _balances[id][from] = fromBalance - amount;
1095             }
1096         }
1097 
1098         emit TransferBatch(operator, from, address(0), ids, amounts);
1099 
1100         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1101     }
1102 
1103     /**
1104      * @dev Approve `operator` to operate on all of `owner` tokens
1105      *
1106      * Emits an {ApprovalForAll} event.
1107      */
1108     function _setApprovalForAll(
1109         address owner,
1110         address operator,
1111         bool approved
1112     ) internal virtual {
1113         require(owner != operator, "ERC1155: setting approval status for self");
1114         _operatorApprovals[owner][operator] = approved;
1115         emit ApprovalForAll(owner, operator, approved);
1116     }
1117 
1118     /**
1119      * @dev Hook that is called before any token transfer. This includes minting
1120      * and burning, as well as batched variants.
1121      *
1122      * The same hook is called on both single and batched variants. For single
1123      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1124      *
1125      * Calling conditions (for each `id` and `amount` pair):
1126      *
1127      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1128      * of token type `id` will be  transferred to `to`.
1129      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1130      * for `to`.
1131      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1132      * will be burned.
1133      * - `from` and `to` are never both zero.
1134      * - `ids` and `amounts` have the same, non-zero length.
1135      *
1136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1137      */
1138     function _beforeTokenTransfer(
1139         address operator,
1140         address from,
1141         address to,
1142         uint256[] memory ids,
1143         uint256[] memory amounts,
1144         bytes memory data
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Hook that is called after any token transfer. This includes minting
1149      * and burning, as well as batched variants.
1150      *
1151      * The same hook is called on both single and batched variants. For single
1152      * transfers, the length of the `id` and `amount` arrays will be 1.
1153      *
1154      * Calling conditions (for each `id` and `amount` pair):
1155      *
1156      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1157      * of token type `id` will be  transferred to `to`.
1158      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1159      * for `to`.
1160      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1161      * will be burned.
1162      * - `from` and `to` are never both zero.
1163      * - `ids` and `amounts` have the same, non-zero length.
1164      *
1165      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1166      */
1167     function _afterTokenTransfer(
1168         address operator,
1169         address from,
1170         address to,
1171         uint256[] memory ids,
1172         uint256[] memory amounts,
1173         bytes memory data
1174     ) internal virtual {}
1175 
1176     function _doSafeTransferAcceptanceCheck(
1177         address operator,
1178         address from,
1179         address to,
1180         uint256 id,
1181         uint256 amount,
1182         bytes memory data
1183     ) private {
1184         if (to.isContract()) {
1185             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1186                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1187                     revert("ERC1155: ERC1155Receiver rejected tokens");
1188                 }
1189             } catch Error(string memory reason) {
1190                 revert(reason);
1191             } catch {
1192                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1193             }
1194         }
1195     }
1196 
1197     function _doSafeBatchTransferAcceptanceCheck(
1198         address operator,
1199         address from,
1200         address to,
1201         uint256[] memory ids,
1202         uint256[] memory amounts,
1203         bytes memory data
1204     ) private {
1205         if (to.isContract()) {
1206             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1207                 bytes4 response
1208             ) {
1209                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1210                     revert("ERC1155: ERC1155Receiver rejected tokens");
1211                 }
1212             } catch Error(string memory reason) {
1213                 revert(reason);
1214             } catch {
1215                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1216             }
1217         }
1218     }
1219 
1220     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1221         uint256[] memory array = new uint256[](1);
1222         array[0] = element;
1223 
1224         return array;
1225     }
1226 }
1227 
1228 // File: contracts/TheOutsiderCollective.sol
1229 
1230 
1231 
1232 pragma solidity ^ 0.8.7;
1233 
1234 
1235 
1236 
1237 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1238 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1239 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1240 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1241 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1242 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1243 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1244 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1245 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1246 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1247 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1248 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1249 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1250 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&***********************#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1251 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@**********************************@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1252 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&*************...*************************@@@@@@@@@@@(***********************(@@@@@@@&#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1253 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(************....***********@@@@@@***********@@@@@@**********************************/&@@@@@##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1254 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&***********,,**********/@@@@@&@@/*************/@@/*****************************************&@@@@&#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1255 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/***********..*******@@@@@@@@@**********************************....................,************@@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1256 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#****************/@@&@@@@@%@//*************************************************,...........**********@@@@%#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1257 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*************(@@@@@@@@@/***@@@(*******************************************************.........*********@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1258 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%*********%@@@@@@@/*&@%&@***@@*@***********************************************************,......*********@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1259 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*********(@@@&*****(@@@@***&@&@#*****************************..,**...*************************..,***********@@@&#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1260 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@***************@@***@@@@(***@@@@************@@@@%**********......*...*****************************...********@@@@#(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1261 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@(*************%@%&@&@@***@@@@@***@@@****%@@@/#@*********......**********************************....*******/@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1262 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@***************@@@*@%***@@@@**@@@@%@**%@@@*@@*@/******......************************************...*******(@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1263 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&***************************@@@@@***@@%*@@*&%@@@@**@@@%@/*@@@(*****....************************************************@@@@#(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1264 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@********************************@@@@@***@&#@@@@**@@@%*@@@@%*(@@@&*****************/@@@@************************************@@@%#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1265 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@************************************@@@@%**%@%(@@@***@@@**@@@**@@@@******************%@@@@************************************@@@&#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1266 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#*********,.....***********************@@%@***@@(@@&****@@@**@@(#@@@*******************/@@&@(**********************************#@@@&##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1267 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/*********........***********************@@@@***@@@@@,*****(@@@/**(**********************@@@@@*******************&@/*************@@@@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1268 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#********.......*********************,*****@@@@***@@%@@*****#@@@@**#&@@@@@@***************@@@@@*************#@@**%@@@@*****************&@@@@@&#@@@@@@@@@@@@@@@@@@@@@@@@@@@
1269 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@********,.....*******************...*..*****@@@@************@@#@@@@@@@&/*****@*************@@@#@****@@@@@****@@@/@@@@@@*********************&@@@@##@@@@@@@@@@@@@@@@@@@@@@@@
1270 //@@@@@@@@@@@@@@@@@@@@@@@#@@@@********.....********************....*******************&@@@@@@@@**************************@@@@@***%@@@/(@***/@@*@@@**(@@***********************@@@@&#@@@@@@@@@@@@@@@@@@@@@@
1271 //@@@@@@@@@@@@@@@@@@@@@@(@@@@********....**********************....***************%@@@@@**@@@@&******/@%****@&*****@@@@@@@@@@@**#@@@*@@*@%*@@@/@@*********************.,********@@@@%#@@@@@@@@@@@@@@@@@@@@
1272 //@@@@@@@@@@@@@@@@@@@@@#@@@@********...*************************,****************@@&*****@@@@@*****%@@@@@/**@@@***@&@@@*/@@(@/**@@@%@/*@@@#@@@*@************************..********@@@@##@@@@@@@@@@@@@@@@@@
1273 //@@@@@@@@@@@@@@@@@@@@@%@@@********,..**************#@@&@@@@@(*********************@/****@@(@#****@@@@&@@********&@*@#**@@@/@**@@@@%*(@@@&*@@@@#*************************,..,******#@@@%#(@@@@@@@@@@@@@@@@
1274 //@@@@@@@@@@@@@@@@@@@@(@@@@********..,***********/@@@@@******@@@&***************#@@@@@**@@@@@***/@@@@*******@#&*(@@@&**@@@@@@**@@@**@@@@***@@@@****************************...******/@@@%#@@@@@@@@@@@@@@@@
1275 //@@@@@@@@@@@@@@@@@@@##@@@/********..***********@@@@/*@@@*****@@@@*************@@@@/*@@*@@@@(***@@@&*******@@@/*@@@@*(@@@@(&/**@@%%@@@@************************************,...*******@@@%#@@@@@@@@@@@@@@@
1276 //@@@@@@@@@@@@@@@@@@@@#@@@**********.**********@@@%**@@@@******@@@**/@@@/*****@@@*@**/@@@@@@********(@@@/*/@@@**%@@@@@@*@@&@******@@@@%**/%&@@@@#***************************....******#@@@##@@@@@@@@@@@@@@
1277 //@@@@@@@@@@@@@@@@@@@@#@@@********************@&@***@@@@*******@@&**@@&@*****@@@@@****@@@/@%*********@@@@((@@@****&@@@**@@@@*****@@*@@@@@@@@(****((*************************,....******@@@@##@@@@@@@@@@@@@
1278 //@@@@@@@@@@@@@@@@@@@##@@@%******************@@@***@@@@*******@@@&*@@@@****&@@@@@@****&@@@@********#@@@@@**&@%**********@@@@&@@@@@@@@****************/@@@****&@@%***********.....******%@@@##&@@@@@@@@@@@@
1279 //@@@@@@@@@@@@@@@@@@@@#@@@@**********,..*****@@#**@@@@%*******@@@**@@@@***@@&/@@@*****@@#@&**#***@@@&*@/****************&@@@@@/*@@@@(****************@@*#***@@@@%@**********....,******/@@@##(@@@@@@@@@@@@
1280 //@@@@@@@@@@@@@@@@@@@@@#@@@%***********.*******%**@@@@*******@@@@*/@@@@*@@@(**@@@******@@@@***@@@@@&******************%@@&*/***@@@@@****************#@@@***@@@#*@@*********,....*******/@@@###@@@@@@@@@@@@
1281 //@@@@@@@@@@@@@@@@@@@@@##@@@(********************@@@@@******@@@/***@@@@@@@****@@*******@@@@**@@@@***********************%@****(@@&@**@@@&**@@@******@@@%**@@@*@@*&@@%******....********@@@@###@@@@@@@@@@@@
1282 //@@@@@@@@@@@@@@@@@@@@@@##@@@(*******************@@@@/****#@@@&***********************@@@@(*/@@*@*******************(*****@%**@@@@@********@@@*****@@@@**@@@@@/*@@@@*******..,*********@@@&##(@@@@@@@@@@@@
1283 //@@@@@@@@@@@@@@@@@@@@@@@##@@@@******************@@@@****@@@@*************************@@*@**@@@@@****************@@#@@@@@*/@#/@@@@****@#**/@&@****&@*@***@@@(**@@&@*******,***********@@@@###@@@@@@@@@@@@@
1284 //@@@@@@@@@@@@@@@@@@@@@@@@##@@@@#****************/@@@&%@@@@@@*&@@@@&*****************@@@@@**@@@@(*****(********/@@@@*******@@@@@@@***@*@**#@@@***@@@@****@@/*@@@@*******,..**********&@@@####@@@@@@@@@@@@@
1285 //@@@@@@@@@@@@@@@@@@@@@@@@@@##@@@@#******************#@@@@@@@#***@@&*****************@@@@%*@@&(@****@@@@@&****(@@@**********@@&%@/**&@*@***@@@*/@@@@******@@@@**********************@@@@#####@@@@@@@@@@@@@
1286 //@@@@@@@@@@@@@@@@@@@@@@@@@@@&##@@@@@******************@@@@&****%@@*****************&@@&@**@@#@@***@#@@*@@****@@@***********@@&@@***@@@/***(@@@@@@********************************#@@@@####%@@@@@@@@@@@@@@
1287 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###@@@@@&*************@@(@*******#**********@@@@****@@&@@**@@%@%**@@@%*@%@@@*@@@(******#@&**@@/@@***@@@*****************************************(@@@@####(@@@@@@@@@@@@@@@@
1288 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%##@@@@@@@@********@@*#*****************@@@&*@@@**@@@@@*(@#*@**@@@@@@*@@@@/@&@******@@****(@@@/*********************************************@@@@@#####%@@@@@@@@@@@@@@@@@
1289 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##@@@@***(********@@(***************/@@@@@#**@@@**@*/@/*&@@@@**@@@&**@@/@*(@@%****@@@******@@@/************************@@@@*************@@@@@@%######@@@@@@@@@@@@@@@@@@@
1290 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#%@@@************%@@***************(@@@@@@**/@@(*(@@@@**@@@@@**@@/*/@@@%***%@@*%@@@***********************************/@@@******(&@@@@@@@@@######&@@@@@@@@@@@@@@@@@@@@@@
1291 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##@@@(************@@&@********(@@@**@@@@@@&**@*@**#@@@@**&@@@&**@@/@@%#*******************************......,*********@@@@@@@@@@@@@@@@&########(@@@@@@@@@@@@@@@@@@@@@@@@@
1292 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#&@@@*************@@&/********@@@@**@@@@**#@@@@***(@@@@**(@@@(******************************,....***.....,*********@@@@@%#################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1293 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@************#@@@********&@@@***@@@@**@@@%*****@@@&*****************************............,**************@@@@@@@####@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1294 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@************%@@@*******%@@@/****@@@@@@&******************.........,*********..........,**************%@@@@@@@######%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1295 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@************/@@@******@@@@********************...*********.,**********************************#@@@@@@@@@########@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1296 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#@@@(************@@@%****@@@&*********,,,*******....************************************/%@@@@@@@@@@@@%##########%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1297 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@*************@@@/*@@@%******...........************@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@##############(/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1298 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@*************************.............**************(@@@@@@@@@@@@@@@@@@@@&%%######################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1299 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#&@@@#**********************.............*************%@@@@####################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1300 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@@@@**********************.......,**************/@@@@@####&@@@@&&&&###########&&&@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1301 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(#@@@@#**************************************(@@@@@#####@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1302 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##@@@@@@*******************************#@@@@@@######@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1303 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(##@@@@@@@@********************(@@@@@@@@######(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1304 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&##%@@@@@@@@@@@@@@@@@@@@@@@@@@@########&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1305 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@######%@@@@@@@&%############(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1306 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&########&&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1307 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1308 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1309 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1310 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1311 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1312 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1313 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1314 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1315 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1316 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1317 
1318 contract TheOutsiderCollective is ERC1155, Ownable {
1319     // editing section starts below here
1320     string public name = "The Outsider Collective"; //name your NFT collection
1321     string public symbol = "TOSC"; //few letters to represent the symbol of your collection
1322     string private ipfsCID = "QmeYpe7bKThjV4LAyvJ6D2iFVNW3iUnFDJ6UDWSfMwA55p"; // ipfs metadata folder CID as the starting or hidden NFT
1323     uint256 public collectionTotal = 1; // total number of NFTs to start your collection
1324     uint256 public cost = 0.055 ether;  // price per mint
1325     uint256 public maxMintAmount = 2; // max amount a user other than owner can mint at in one session
1326     uint256 public maxBatchMintAmount = 2;  // max batch amount a user other than owner can mint at in one session
1327     uint256 public whitelisterLimit = 2; // max amount a whitelisted user can mint during presale 
1328     // editing section end
1329 
1330     bool public paused = false;
1331     bool public revealed = true;
1332 
1333     uint256 public ogCollectionTotal; // the original collection total
1334     mapping(uint => string) private tokenURI;
1335     mapping(uint256 => uint256) private currentSupply;
1336     mapping(uint256 => bool) private hasMaxSupply;
1337     mapping(uint256 => uint256) public maxSupply;
1338     mapping(uint256 => bool) private createdToken; // if true token has been minted at least one time or was updated into the collection total
1339 
1340     bool public onlyWhitelisted = true;
1341     address[] public whitelistedAddresses;
1342     mapping(address => uint256) public whitelisterMintedBalance;
1343 
1344     address payable public payments; // the payout address for the withdraw function
1345     address public ocTreasury = 0xCfe2f134C4d6914D1EfdA3ABa47564E35e6b7fe6;
1346 
1347     constructor() ERC1155(""){
1348         ogCollectionTotal = collectionTotal;
1349         maxSupply[1] = 333;
1350         hasMaxSupply[1] = true;
1351         createdToken[1] = true;
1352         currentSupply[1] = 1; //sets current supply to the amount minted on deploy
1353         _mint(ocTreasury, 1, 46, ""); //sends Owner, NFT id 1, amount 1
1354     }
1355 
1356     /**
1357      * @dev The contract developer's website.
1358      */
1359     function contractDev() public pure returns(string memory){
1360         string memory dev = unicode"🐸 HalfSuperShop.com 🐸";
1361         return dev;
1362     }
1363 
1364     /**
1365      * @dev Admin can set the PAUSE state.
1366      * true = closed to Admin Only
1367      * false = open for Presale or Public
1368      */
1369     function pause(bool _state) public onlyOwner {
1370         paused = _state;
1371     }
1372 
1373     /**
1374      * @dev Allows Owner, Whitelisters, and Public to Mint a single NFT.
1375      * Can only be called by the Public when onlyWhitelisted is false.
1376      */
1377     function mint(address _to, uint _id, uint _amount) public payable {
1378         require(!paused, "Contract Paused");
1379         require(canMintChecker(_id, _amount), "CANNOT MINT");
1380 
1381         if (msg.sender != owner()) {
1382             if (onlyWhitelisted == true) {
1383                 require(isWhitelisted(msg.sender), "Not Whitelisted");
1384                 uint256 whitelisterMintedCount = whitelisterMintedBalance[msg.sender];
1385                 require(whitelisterMintedCount + _amount <= whitelisterLimit, "Exceeded Max Whitelist Mint Limit");
1386             }
1387             require(msg.value >= (_amount * cost), "Insufficient Funds");
1388         }
1389 
1390         whitelisterMintedBalance[msg.sender] += _amount;
1391         currentSupply[_id] += _amount;
1392         if (!exists(_id)) {
1393             createdToken[_id] = true;
1394             collectionTotal++;
1395         }
1396         _mint(_to, _id, _amount, "");
1397     }
1398 
1399     function canMintChecker(uint _id, uint _amount) private view returns(bool){
1400         if (hasMaxSupply[_id]) {
1401             if (_amount > 0 && _amount <= maxMintAmount && _id > 0 && _id <= collectionTotal && currentSupply[_id] + _amount <= maxSupply[_id]) {
1402                 // CAN MINT
1403             }
1404             else {
1405                 // CANNOT MINT 
1406                 return false;
1407             }
1408         }
1409         else {
1410             if (_amount > 0 && _amount <= maxMintAmount && _id > 0 && _id <= collectionTotal) {
1411                 // CAN MINT
1412             }
1413             else {
1414                 // CANNOT MINT 
1415                 return false;
1416             }
1417         }
1418 
1419         return true;
1420     }
1421 
1422     /**
1423      * @dev Allows Owner, Whitelisters, and Public to Mint multiple NFTs.
1424      * Can only be called by the Public when onlyWhitelisted is false.
1425      * Note: Only mint a max of {mintMaxAmount} or less NFT IDs with a totaling amount of {maxBatchMintAmount} at a time.
1426      * Example to Mint 3 of each Token IDs 1, 2, 3, 4:
1427      * _ids = [1,2,3,4]
1428      * _amounts = [3,3,3,3]
1429      * 4 seperate NFTs with a quantity of 3 each has a totaling amount of 12.
1430      */
1431     function mintBatch(address _to, uint[] memory _ids, uint[] memory _amounts) public payable {
1432         require(!paused, "Contract Paused");
1433         require(_ids.length <= maxMintAmount, "Batch Token IDs Limit Exceeded");
1434         require(_ids.length == _amounts.length, "IDs Array Not Equal To Amounts Array");
1435         require(canMintBatchChecker(_ids, _amounts), "CANNOT MINT BATCH");
1436 
1437         uint256 _totalBatchAmount;
1438         for (uint256 i = 0; i < _amounts.length; i++) {
1439             _totalBatchAmount += _amounts[i];
1440         }
1441         require(_totalBatchAmount <= maxBatchMintAmount, "Batch Amount Limit Exceeded");
1442 
1443         if (msg.sender != owner()) {
1444             if (onlyWhitelisted) {
1445                 require(isWhitelisted(msg.sender), "Not Whitelisted");
1446                 uint256 whitelisterMintedCount = whitelisterMintedBalance[msg.sender];
1447                 require(whitelisterMintedCount + _totalBatchAmount <= whitelisterLimit, "Exceeded Max Whitelist Mint Limit");
1448             }
1449             require(msg.value >= (_totalBatchAmount * cost), "Insufficient Funds");
1450         }
1451 
1452         whitelisterMintedBalance[msg.sender] += _totalBatchAmount;
1453 
1454         for (uint256 k = 0; k < _ids.length; k++) {
1455             currentSupply[_ids[k]] += _amounts[k];
1456             uint256 _id = _ids[k];
1457             if (!exists(_id)) {
1458                 createdToken[_id] = true;
1459                 collectionTotal++;
1460             }
1461         }
1462 
1463         _mintBatch(_to, _ids, _amounts, "");
1464     }
1465 
1466     function canMintBatchChecker(uint[] memory _ids, uint[] memory _amounts)private view returns(bool){
1467         for (uint256 i = 0; i < _ids.length; i++) {
1468             uint256 _id = _ids[i];
1469             uint256 _amount = _amounts[i];
1470             if (hasMaxSupply[_id]) {
1471                 if (_amount > 0 && _amount <= maxMintAmount && _id > 0 && _id <= collectionTotal && currentSupply[_id] + _amount <= maxSupply[_id]) {
1472                     // CAN MINT
1473                 }
1474                 else {
1475                     // CANNOT MINT
1476                     return false;
1477                 }
1478             }
1479             else {
1480                 if (_amount > 0 && _amount <= maxMintAmount && _id > 0 && _id <= collectionTotal) {
1481                     // CAN MINT
1482                 }
1483                 else {
1484                     // CANNOT MINT
1485                     return false;
1486                 }
1487             }
1488         }
1489 
1490         return true;
1491     }
1492 
1493     /**
1494      * @dev Allows Admin to Mint a single NEW NFT.
1495      * Can only be called by the current owner.
1496      * Note: NEW NFT means above and beyond the original collection total.
1497      */
1498     function adminMint(address _to, uint _id, uint _amount) external onlyOwner {
1499         require(_id > ogCollectionTotal, "ID Must Not Be From Original Collection");
1500         if (!exists(_id)) {
1501             createdToken[_id] = true;
1502             collectionTotal++;
1503         }
1504         currentSupply[_id] += _amount;
1505         _mint(_to, _id, _amount, "");
1506     }
1507 
1508     /**
1509      * @dev Allows Admin to Mint multiple NEW NFTs.
1510      * Can only be called by the current owner.
1511      * Note: NEW NFT means above and beyond the original collection total.
1512      * Ideally it's best to only mint a max of 70 or less NFT IDs at a time.
1513      * Example to Mint 3 of each Token IDs 1, 2, 3, 4:
1514      * _ids = [1,2,3,4]
1515      * _amounts = [3,3,3,3]
1516      */
1517     function adminMintBatch(address _to, uint[] memory _ids, uint[] memory _amounts) external onlyOwner {
1518         require(!checkIfOriginal(_ids), "ID Must Not Be From Original Collection");
1519         for (uint256 i = 0; i < _ids.length; ++i) {
1520             uint256 _id = _ids[i];
1521             if (!exists(_id)) {
1522                 createdToken[_id] = true;
1523                 collectionTotal++;
1524             }
1525             currentSupply[_id] += _amounts[i];
1526         }
1527         _mintBatch(_to, _ids, _amounts, "");
1528     }
1529 
1530     /**
1531     * @dev Allows User to DESTROY a single token they own.
1532     */
1533     function burn(uint _id, uint _amount) external {
1534         currentSupply[_id] -= _amount;
1535         _burn(msg.sender, _id, _amount);
1536     }
1537 
1538     /**
1539     * @dev Allows User to DESTROY multiple tokens they own.
1540     */
1541     function burnBatch(uint[] memory _ids, uint[] memory _amounts) external {
1542         for (uint256 i = 0; i < _ids.length; ++i) {
1543             uint256 _id = _ids[i];
1544             currentSupply[_id] -= _amounts[i];
1545         }
1546         _burnBatch(msg.sender, _ids, _amounts);
1547     }
1548 
1549     /**
1550     * @dev Allows Admin to REVEAL the original collection.
1551     * Can only be called by the current owner once.
1552     * WARNING: Please ensure the CID is 100% correct before execution.
1553     */
1554     function reveal(string memory _uri) external onlyOwner {
1555         require(!revealed, "Already set to Revealed");
1556         ipfsCID = _uri;
1557         revealed = true;
1558     }
1559 
1560     /**
1561     * @dev Allows Admin to set the URI of a single token.
1562     * Note: Original Token URIs cannot be changed.
1563     *       Set _isIpfsCID to true if using only IPFS CID for the _uri.
1564     */
1565     function setURI(uint _id, string memory _uri, bool _isIpfsCID) external onlyOwner {
1566         require(_id > ogCollectionTotal, "ID Must Not Be From Original Collection");
1567         if (_isIpfsCID) {
1568             string memory _uriIPFS = string(abi.encodePacked(
1569                 "ipfs://",
1570                 _uri,
1571                 "/",
1572                 Strings.toString(_id),
1573                 ".json"
1574             ));
1575 
1576             tokenURI[_id] = _uriIPFS;
1577             emit URI(_uriIPFS, _id);
1578         }
1579         else {
1580             tokenURI[_id] = _uri;
1581             emit URI(_uri, _id);
1582         }
1583     }
1584 
1585     /**
1586     * @dev Allows Admin to set the URI of multiple tokens.
1587     * Note: Original Token URIs cannot be changed.
1588     *       Set _isIpfsCID to true if using only IPFS CID for the _uri.
1589     */
1590     function setBatchURI(uint[] memory _ids, string memory _uri, bool _isIpfsCID) external onlyOwner {
1591         require(_ids.length > 1, "Must have at least 2 ids");
1592         require(!checkIfOriginal(_ids), "ID Must Not Be From Original Collection");
1593 
1594         for (uint256 i = 0; i < _ids.length; ++i) {
1595             uint256 _id = _ids[i];
1596             if (_isIpfsCID) {
1597                 string memory _uriIPFS = string(abi.encodePacked(
1598                     "ipfs://",
1599                     _uri,
1600                     "/",
1601                     Strings.toString(_id),
1602                     ".json"
1603                 ));
1604 
1605                 tokenURI[_id] = _uriIPFS;
1606                 emit URI(_uriIPFS, _id);
1607             }
1608             else {
1609                 tokenURI[_id] = _uri;
1610                 emit URI(_uri, _id);
1611             }
1612         }
1613     }
1614 
1615     function uri(uint256 _id) override public view returns(string memory){
1616         if (_id > 0 && _id <= ogCollectionTotal) {
1617             return (
1618                 string(abi.encodePacked(
1619                     "ipfs://",
1620                     ipfsCID,
1621                     "/",
1622                     Strings.toString(_id),
1623                     ".json"
1624                 )));
1625         }
1626         else {
1627             return tokenURI[_id];
1628         }
1629     }
1630 
1631     function checkIfOriginal(uint[] memory _ids) private view returns(bool){
1632         for (uint256 i = 0; i < _ids.length; ++i) {
1633             uint256 _id = _ids[i];
1634             if (_id <= ogCollectionTotal) {
1635                 // original
1636             }
1637             else {
1638                 // new
1639                 return false;
1640             }
1641         }
1642         return true;
1643     }
1644 
1645     /**
1646     * @dev Total amount of tokens in with a given id.
1647     */
1648     function totalSupply(uint256 _id) public view returns(uint256) {
1649         return currentSupply[_id];
1650     }
1651 
1652     /**
1653      * @dev Indicates whether any token exist with a given id, or not.
1654      */
1655     function exists(uint256 _id) public view returns(bool) {
1656         return createdToken[_id];
1657     }
1658 
1659     /**
1660      * @dev Admin can set a supply limit.
1661      * Note: If supply amount is set to 0 that will make the supply limitless.
1662      */
1663     function setMaxSupplies(uint[] memory _ids, uint[] memory _supplies) external onlyOwner {
1664         for (uint256 i = 0; i < _ids.length; i++) {
1665             uint256 _id = _ids[i];
1666             maxSupply[_id] += _supplies[i];
1667             if (_supplies[i] > 0) {
1668                 // has a max limit
1669                 hasMaxSupply[i] = true;
1670             }
1671             else {
1672                 // infinite supply, because you wouldn't create a token max supply with an amount of zero 
1673                 hasMaxSupply[i] = false;
1674             }
1675         }
1676     }
1677 
1678     /**
1679      * @dev Admin can update the collection total to allow minting the newly added NFTs.
1680      */
1681     function updateCollectionTotal(uint _amountToAdd) external onlyOwner {
1682         collectionTotal += _amountToAdd;
1683     }
1684 
1685     /**
1686      * @dev Check if address is whitelisted.
1687      */
1688     function isWhitelisted(address _user) public view returns(bool) {
1689         for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
1690             if (whitelistedAddresses[i] == _user) {
1691                 return true;
1692             }
1693         }
1694         return false;
1695     }
1696 
1697     /**
1698      * @dev Admin can set the amount of NFTs a user can mint in one session.
1699      */
1700     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1701         maxMintAmount = _newmaxMintAmount;
1702     }
1703 
1704     /**
1705      * @dev Admin can set the max amount of NFTs a whitelister can mint during presale.
1706      */
1707     function setNftPerWhitelisterLimit(uint256 _limit) public onlyOwner {
1708         whitelisterLimit = _limit;
1709     }
1710 
1711     /**
1712      * @dev Admin can set the PRESALE state.
1713      * true = presale ongoing for whitelisters only
1714      * false = sale open to public
1715      */
1716     function setOnlyWhitelisted(bool _state) public onlyOwner {
1717         onlyWhitelisted = _state;
1718     }
1719 
1720     /**
1721      * @dev Admin can set the addresses as whitelisters.
1722      * Example: ["0xADDRESS1", "0xADDRESS2", "0xADDRESS3"]
1723      */
1724     function whitelistUsers(address[] calldata _users) public onlyOwner {
1725         delete whitelistedAddresses;
1726         whitelistedAddresses = _users;
1727     }
1728 
1729     /**
1730      * @dev Admin can set the new cost in WEI.
1731      * 1 ETH = 10^18 WEI
1732      * Use https://coinguides.org/ethereum-unit-converter-gwei-ether/ for conversions.
1733      */
1734     function setCost(uint256 _newCost) public onlyOwner {
1735         cost = _newCost;
1736     }
1737 
1738     /**
1739      * @dev Admin can set the payout address.
1740      */
1741     function setPayoutAddress(address _address) external onlyOwner{
1742         payments = payable(_address);
1743     }
1744 
1745     /**
1746      * @dev Admin can pull funds to the payout address.
1747      */
1748     function withdraw() public payable onlyOwner {
1749         require(payments != 0x0000000000000000000000000000000000000000, "Payout Address Must Be Set First");
1750         (bool success, ) = payable(payments).call{ value: address(this).balance } ("");
1751         require(success);
1752     }
1753 
1754     /**
1755      * @dev Auto send funds to the payout address.
1756         Triggers only if funds were sent directly to this address.
1757      */
1758     receive() payable external {
1759         require(payments != 0x0000000000000000000000000000000000000000, "Payout Address Must Be Set First");
1760         uint256 payout = msg.value;
1761         payments.transfer(payout);
1762     }
1763 
1764 }