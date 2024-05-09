1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
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
80 // File: @openzeppelin/contracts/utils/Context.sol
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
107 // File: @openzeppelin/contracts/access/Ownable.sol
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
192 // File: @openzeppelin/contracts/utils/Address.sol
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
279         return functionCall(target, data, "Address: low-level call failed");
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
328         require(isContract(target), "Address: call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.call{value: value}(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
341         return functionStaticCall(target, data, "Address: low-level static call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal view returns (bytes memory) {
355         require(isContract(target), "Address: static call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.staticcall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.delegatecall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
390      * revert reason using the provided one.
391      *
392      * _Available since v4.3._
393      */
394     function verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) internal pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405                 /// @solidity memory-safe-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
418 
419 
420 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @dev Interface of the ERC165 standard, as defined in the
426  * https://eips.ethereum.org/EIPS/eip-165[EIP].
427  *
428  * Implementers can declare support of contract interfaces, which can then be
429  * queried by others ({ERC165Checker}).
430  *
431  * For an implementation, see {ERC165}.
432  */
433 interface IERC165 {
434     /**
435      * @dev Returns true if this contract implements the interface defined by
436      * `interfaceId`. See the corresponding
437      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
438      * to learn more about how these ids are created.
439      *
440      * This function call must use less than 30 000 gas.
441      */
442     function supportsInterface(bytes4 interfaceId) external view returns (bool);
443 }
444 
445 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
446 
447 
448 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
449 
450 pragma solidity ^0.8.0;
451 
452 
453 /**
454  * @dev Implementation of the {IERC165} interface.
455  *
456  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
457  * for the additional interface id that will be supported. For example:
458  *
459  * ```solidity
460  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
461  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
462  * }
463  * ```
464  *
465  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
466  */
467 abstract contract ERC165 is IERC165 {
468     /**
469      * @dev See {IERC165-supportsInterface}.
470      */
471     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472         return interfaceId == type(IERC165).interfaceId;
473     }
474 }
475 
476 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
477 
478 
479 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @dev _Available since v3.1._
486  */
487 interface IERC1155Receiver is IERC165 {
488     /**
489      * @dev Handles the receipt of a single ERC1155 token type. This function is
490      * called at the end of a `safeTransferFrom` after the balance has been updated.
491      *
492      * NOTE: To accept the transfer, this must return
493      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
494      * (i.e. 0xf23a6e61, or its own function selector).
495      *
496      * @param operator The address which initiated the transfer (i.e. msg.sender)
497      * @param from The address which previously owned the token
498      * @param id The ID of the token being transferred
499      * @param value The amount of tokens being transferred
500      * @param data Additional data with no specified format
501      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
502      */
503     function onERC1155Received(
504         address operator,
505         address from,
506         uint256 id,
507         uint256 value,
508         bytes calldata data
509     ) external returns (bytes4);
510 
511     /**
512      * @dev Handles the receipt of a multiple ERC1155 token types. This function
513      * is called at the end of a `safeBatchTransferFrom` after the balances have
514      * been updated.
515      *
516      * NOTE: To accept the transfer(s), this must return
517      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
518      * (i.e. 0xbc197c81, or its own function selector).
519      *
520      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
521      * @param from The address which previously owned the token
522      * @param ids An array containing ids of each token being transferred (order and length must match values array)
523      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
524      * @param data Additional data with no specified format
525      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
526      */
527     function onERC1155BatchReceived(
528         address operator,
529         address from,
530         uint256[] calldata ids,
531         uint256[] calldata values,
532         bytes calldata data
533     ) external returns (bytes4);
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
537 
538 
539 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @dev Required interface of an ERC1155 compliant contract, as defined in the
546  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
547  *
548  * _Available since v3.1._
549  */
550 interface IERC1155 is IERC165 {
551     /**
552      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
553      */
554     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
555 
556     /**
557      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
558      * transfers.
559      */
560     event TransferBatch(
561         address indexed operator,
562         address indexed from,
563         address indexed to,
564         uint256[] ids,
565         uint256[] values
566     );
567 
568     /**
569      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
570      * `approved`.
571      */
572     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
573 
574     /**
575      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
576      *
577      * If an {URI} event was emitted for `id`, the standard
578      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
579      * returned by {IERC1155MetadataURI-uri}.
580      */
581     event URI(string value, uint256 indexed id);
582 
583     /**
584      * @dev Returns the amount of tokens of token type `id` owned by `account`.
585      *
586      * Requirements:
587      *
588      * - `account` cannot be the zero address.
589      */
590     function balanceOf(address account, uint256 id) external view returns (uint256);
591 
592     /**
593      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
594      *
595      * Requirements:
596      *
597      * - `accounts` and `ids` must have the same length.
598      */
599     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
600         external
601         view
602         returns (uint256[] memory);
603 
604     /**
605      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
606      *
607      * Emits an {ApprovalForAll} event.
608      *
609      * Requirements:
610      *
611      * - `operator` cannot be the caller.
612      */
613     function setApprovalForAll(address operator, bool approved) external;
614 
615     /**
616      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
617      *
618      * See {setApprovalForAll}.
619      */
620     function isApprovedForAll(address account, address operator) external view returns (bool);
621 
622     /**
623      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
624      *
625      * Emits a {TransferSingle} event.
626      *
627      * Requirements:
628      *
629      * - `to` cannot be the zero address.
630      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
631      * - `from` must have a balance of tokens of type `id` of at least `amount`.
632      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
633      * acceptance magic value.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 id,
639         uint256 amount,
640         bytes calldata data
641     ) external;
642 
643     /**
644      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
645      *
646      * Emits a {TransferBatch} event.
647      *
648      * Requirements:
649      *
650      * - `ids` and `amounts` must have the same length.
651      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
652      * acceptance magic value.
653      */
654     function safeBatchTransferFrom(
655         address from,
656         address to,
657         uint256[] calldata ids,
658         uint256[] calldata amounts,
659         bytes calldata data
660     ) external;
661 }
662 
663 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
673  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
674  *
675  * _Available since v3.1._
676  */
677 interface IERC1155MetadataURI is IERC1155 {
678     /**
679      * @dev Returns the URI for token type `id`.
680      *
681      * If the `\{id\}` substring is present in the URI, it must be replaced by
682      * clients with the actual token type ID.
683      */
684     function uri(uint256 id) external view returns (string memory);
685 }
686 
687 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
688 
689 
690 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 
696 
697 
698 
699 
700 /**
701  * @dev Implementation of the basic standard multi-token.
702  * See https://eips.ethereum.org/EIPS/eip-1155
703  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
704  *
705  * _Available since v3.1._
706  */
707 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
708     using Address for address;
709 
710     // Mapping from token ID to account balances
711     mapping(uint256 => mapping(address => uint256)) private _balances;
712 
713     // Mapping from account to operator approvals
714     mapping(address => mapping(address => bool)) private _operatorApprovals;
715 
716     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
717     string private _uri;
718 
719     /**
720      * @dev See {_setURI}.
721      */
722     constructor(string memory uri_) {
723         _setURI(uri_);
724     }
725 
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
730         return
731             interfaceId == type(IERC1155).interfaceId ||
732             interfaceId == type(IERC1155MetadataURI).interfaceId ||
733             super.supportsInterface(interfaceId);
734     }
735 
736     /**
737      * @dev See {IERC1155MetadataURI-uri}.
738      *
739      * This implementation returns the same URI for *all* token types. It relies
740      * on the token type ID substitution mechanism
741      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
742      *
743      * Clients calling this function must replace the `\{id\}` substring with the
744      * actual token type ID.
745      */
746     function uri(uint256) public view virtual override returns (string memory) {
747         return _uri;
748     }
749 
750     /**
751      * @dev See {IERC1155-balanceOf}.
752      *
753      * Requirements:
754      *
755      * - `account` cannot be the zero address.
756      */
757     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
758         require(account != address(0), "ERC1155: address zero is not a valid owner");
759         return _balances[id][account];
760     }
761 
762     /**
763      * @dev See {IERC1155-balanceOfBatch}.
764      *
765      * Requirements:
766      *
767      * - `accounts` and `ids` must have the same length.
768      */
769     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
770         public
771         view
772         virtual
773         override
774         returns (uint256[] memory)
775     {
776         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
777 
778         uint256[] memory batchBalances = new uint256[](accounts.length);
779 
780         for (uint256 i = 0; i < accounts.length; ++i) {
781             batchBalances[i] = balanceOf(accounts[i], ids[i]);
782         }
783 
784         return batchBalances;
785     }
786 
787     /**
788      * @dev See {IERC1155-setApprovalForAll}.
789      */
790     function setApprovalForAll(address operator, bool approved) public virtual override {
791         _setApprovalForAll(_msgSender(), operator, approved);
792     }
793 
794     /**
795      * @dev See {IERC1155-isApprovedForAll}.
796      */
797     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
798         return _operatorApprovals[account][operator];
799     }
800 
801     /**
802      * @dev See {IERC1155-safeTransferFrom}.
803      */
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 id,
808         uint256 amount,
809         bytes memory data
810     ) public virtual override {
811         require(
812             from == _msgSender() || isApprovedForAll(from, _msgSender()),
813             "ERC1155: caller is not token owner nor approved"
814         );
815         _safeTransferFrom(from, to, id, amount, data);
816     }
817 
818     /**
819      * @dev See {IERC1155-safeBatchTransferFrom}.
820      */
821     function safeBatchTransferFrom(
822         address from,
823         address to,
824         uint256[] memory ids,
825         uint256[] memory amounts,
826         bytes memory data
827     ) public virtual override {
828         require(
829             from == _msgSender() || isApprovedForAll(from, _msgSender()),
830             "ERC1155: caller is not token owner nor approved"
831         );
832         _safeBatchTransferFrom(from, to, ids, amounts, data);
833     }
834 
835     /**
836      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
837      *
838      * Emits a {TransferSingle} event.
839      *
840      * Requirements:
841      *
842      * - `to` cannot be the zero address.
843      * - `from` must have a balance of tokens of type `id` of at least `amount`.
844      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
845      * acceptance magic value.
846      */
847     function _safeTransferFrom(
848         address from,
849         address to,
850         uint256 id,
851         uint256 amount,
852         bytes memory data
853     ) internal virtual {
854         require(to != address(0), "ERC1155: transfer to the zero address");
855 
856         address operator = _msgSender();
857         uint256[] memory ids = _asSingletonArray(id);
858         uint256[] memory amounts = _asSingletonArray(amount);
859 
860         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
861 
862         uint256 fromBalance = _balances[id][from];
863         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
864         unchecked {
865             _balances[id][from] = fromBalance - amount;
866         }
867         _balances[id][to] += amount;
868 
869         emit TransferSingle(operator, from, to, id, amount);
870 
871         _afterTokenTransfer(operator, from, to, ids, amounts, data);
872 
873         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
874     }
875 
876     /**
877      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
878      *
879      * Emits a {TransferBatch} event.
880      *
881      * Requirements:
882      *
883      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
884      * acceptance magic value.
885      */
886     function _safeBatchTransferFrom(
887         address from,
888         address to,
889         uint256[] memory ids,
890         uint256[] memory amounts,
891         bytes memory data
892     ) internal virtual {
893         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
894         require(to != address(0), "ERC1155: transfer to the zero address");
895 
896         address operator = _msgSender();
897 
898         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
899 
900         for (uint256 i = 0; i < ids.length; ++i) {
901             uint256 id = ids[i];
902             uint256 amount = amounts[i];
903 
904             uint256 fromBalance = _balances[id][from];
905             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
906             unchecked {
907                 _balances[id][from] = fromBalance - amount;
908             }
909             _balances[id][to] += amount;
910         }
911 
912         emit TransferBatch(operator, from, to, ids, amounts);
913 
914         _afterTokenTransfer(operator, from, to, ids, amounts, data);
915 
916         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
917     }
918 
919     /**
920      * @dev Sets a new URI for all token types, by relying on the token type ID
921      * substitution mechanism
922      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
923      *
924      * By this mechanism, any occurrence of the `\{id\}` substring in either the
925      * URI or any of the amounts in the JSON file at said URI will be replaced by
926      * clients with the token type ID.
927      *
928      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
929      * interpreted by clients as
930      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
931      * for token type ID 0x4cce0.
932      *
933      * See {uri}.
934      *
935      * Because these URIs cannot be meaningfully represented by the {URI} event,
936      * this function emits no events.
937      */
938     function _setURI(string memory newuri) internal virtual {
939         _uri = newuri;
940     }
941 
942     /**
943      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
944      *
945      * Emits a {TransferSingle} event.
946      *
947      * Requirements:
948      *
949      * - `to` cannot be the zero address.
950      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
951      * acceptance magic value.
952      */
953     function _mint(
954         address to,
955         uint256 id,
956         uint256 amount,
957         bytes memory data
958     ) internal virtual {
959         require(to != address(0), "ERC1155: mint to the zero address");
960 
961         address operator = _msgSender();
962         uint256[] memory ids = _asSingletonArray(id);
963         uint256[] memory amounts = _asSingletonArray(amount);
964 
965         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
966 
967         _balances[id][to] += amount;
968         emit TransferSingle(operator, address(0), to, id, amount);
969 
970         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
971 
972         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
973     }
974 
975     /**
976      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
977      *
978      * Emits a {TransferBatch} event.
979      *
980      * Requirements:
981      *
982      * - `ids` and `amounts` must have the same length.
983      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
984      * acceptance magic value.
985      */
986     function _mintBatch(
987         address to,
988         uint256[] memory ids,
989         uint256[] memory amounts,
990         bytes memory data
991     ) internal virtual {
992         require(to != address(0), "ERC1155: mint to the zero address");
993         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
994 
995         address operator = _msgSender();
996 
997         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
998 
999         for (uint256 i = 0; i < ids.length; i++) {
1000             _balances[ids[i]][to] += amounts[i];
1001         }
1002 
1003         emit TransferBatch(operator, address(0), to, ids, amounts);
1004 
1005         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1006 
1007         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1008     }
1009 
1010     /**
1011      * @dev Destroys `amount` tokens of token type `id` from `from`
1012      *
1013      * Emits a {TransferSingle} event.
1014      *
1015      * Requirements:
1016      *
1017      * - `from` cannot be the zero address.
1018      * - `from` must have at least `amount` tokens of token type `id`.
1019      */
1020     function _burn(
1021         address from,
1022         uint256 id,
1023         uint256 amount
1024     ) internal virtual {
1025         require(from != address(0), "ERC1155: burn from the zero address");
1026 
1027         address operator = _msgSender();
1028         uint256[] memory ids = _asSingletonArray(id);
1029         uint256[] memory amounts = _asSingletonArray(amount);
1030 
1031         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1032 
1033         uint256 fromBalance = _balances[id][from];
1034         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1035         unchecked {
1036             _balances[id][from] = fromBalance - amount;
1037         }
1038 
1039         emit TransferSingle(operator, from, address(0), id, amount);
1040 
1041         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1042     }
1043 
1044     /**
1045      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1046      *
1047      * Emits a {TransferBatch} event.
1048      *
1049      * Requirements:
1050      *
1051      * - `ids` and `amounts` must have the same length.
1052      */
1053     function _burnBatch(
1054         address from,
1055         uint256[] memory ids,
1056         uint256[] memory amounts
1057     ) internal virtual {
1058         require(from != address(0), "ERC1155: burn from the zero address");
1059         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1060 
1061         address operator = _msgSender();
1062 
1063         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1064 
1065         for (uint256 i = 0; i < ids.length; i++) {
1066             uint256 id = ids[i];
1067             uint256 amount = amounts[i];
1068 
1069             uint256 fromBalance = _balances[id][from];
1070             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1071             unchecked {
1072                 _balances[id][from] = fromBalance - amount;
1073             }
1074         }
1075 
1076         emit TransferBatch(operator, from, address(0), ids, amounts);
1077 
1078         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1079     }
1080 
1081     /**
1082      * @dev Approve `operator` to operate on all of `owner` tokens
1083      *
1084      * Emits an {ApprovalForAll} event.
1085      */
1086     function _setApprovalForAll(
1087         address owner,
1088         address operator,
1089         bool approved
1090     ) internal virtual {
1091         require(owner != operator, "ERC1155: setting approval status for self");
1092         _operatorApprovals[owner][operator] = approved;
1093         emit ApprovalForAll(owner, operator, approved);
1094     }
1095 
1096     /**
1097      * @dev Hook that is called before any token transfer. This includes minting
1098      * and burning, as well as batched variants.
1099      *
1100      * The same hook is called on both single and batched variants. For single
1101      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1102      *
1103      * Calling conditions (for each `id` and `amount` pair):
1104      *
1105      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1106      * of token type `id` will be  transferred to `to`.
1107      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1108      * for `to`.
1109      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1110      * will be burned.
1111      * - `from` and `to` are never both zero.
1112      * - `ids` and `amounts` have the same, non-zero length.
1113      *
1114      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1115      */
1116     function _beforeTokenTransfer(
1117         address operator,
1118         address from,
1119         address to,
1120         uint256[] memory ids,
1121         uint256[] memory amounts,
1122         bytes memory data
1123     ) internal virtual {}
1124 
1125     /**
1126      * @dev Hook that is called after any token transfer. This includes minting
1127      * and burning, as well as batched variants.
1128      *
1129      * The same hook is called on both single and batched variants. For single
1130      * transfers, the length of the `id` and `amount` arrays will be 1.
1131      *
1132      * Calling conditions (for each `id` and `amount` pair):
1133      *
1134      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1135      * of token type `id` will be  transferred to `to`.
1136      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1137      * for `to`.
1138      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1139      * will be burned.
1140      * - `from` and `to` are never both zero.
1141      * - `ids` and `amounts` have the same, non-zero length.
1142      *
1143      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1144      */
1145     function _afterTokenTransfer(
1146         address operator,
1147         address from,
1148         address to,
1149         uint256[] memory ids,
1150         uint256[] memory amounts,
1151         bytes memory data
1152     ) internal virtual {}
1153 
1154     function _doSafeTransferAcceptanceCheck(
1155         address operator,
1156         address from,
1157         address to,
1158         uint256 id,
1159         uint256 amount,
1160         bytes memory data
1161     ) private {
1162         if (to.isContract()) {
1163             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1164                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1165                     revert("ERC1155: ERC1155Receiver rejected tokens");
1166                 }
1167             } catch Error(string memory reason) {
1168                 revert(reason);
1169             } catch {
1170                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1171             }
1172         }
1173     }
1174 
1175     function _doSafeBatchTransferAcceptanceCheck(
1176         address operator,
1177         address from,
1178         address to,
1179         uint256[] memory ids,
1180         uint256[] memory amounts,
1181         bytes memory data
1182     ) private {
1183         if (to.isContract()) {
1184             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1185                 bytes4 response
1186             ) {
1187                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1188                     revert("ERC1155: ERC1155Receiver rejected tokens");
1189                 }
1190             } catch Error(string memory reason) {
1191                 revert(reason);
1192             } catch {
1193                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1194             }
1195         }
1196     }
1197 
1198     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1199         uint256[] memory array = new uint256[](1);
1200         array[0] = element;
1201 
1202         return array;
1203     }
1204 }
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 // (ノ-o-)ノ　🍲∵：．
1209 
1210 contract ChankoGoneOff is ERC1155, Ownable {
1211     using Strings for uint256;
1212     uint256 public constant offId = 0;
1213     address private sumogoneoff;
1214     string private baseURI;
1215 
1216     constructor(string memory _baseURI) ERC1155(_baseURI) {
1217         baseURI = _baseURI;
1218     }
1219 
1220     function setsumogoneoff(address _sumogoneoff) external onlyOwner {
1221         sumogoneoff = _sumogoneoff;
1222     }
1223 
1224     function getoffId() external pure returns (uint256) {
1225         return offId;
1226     }
1227 
1228     function ownerMint(uint256 _amount, address _address) external onlyOwner { 
1229         _mint(_address, offId, _amount, "");
1230     }
1231 
1232     function airdrop(address[] calldata addrs) external onlyOwner {
1233         for (uint256 i = 0; i < addrs.length; i++) {
1234             _mint(addrs[i], offId, 1, "");
1235         }
1236     }
1237 
1238     function eatOffChanko(address burnTokenAddress) external {
1239         require(msg.sender == sumogoneoff, "Invalid burner address");
1240         _burn(burnTokenAddress, offId, 1);
1241     }
1242 
1243     function updateBaseUri(string memory _baseURI) external onlyOwner {
1244         baseURI = _baseURI;
1245     }
1246 
1247     function uri(uint256 typeId) public view override returns (string memory) {
1248         require(typeId == offId, "Id 0 only");
1249         return string(abi.encodePacked(baseURI, Strings.toString(typeId), ".json"));
1250     }
1251 }