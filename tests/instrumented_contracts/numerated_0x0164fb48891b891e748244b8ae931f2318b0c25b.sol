1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
180 
181 pragma solidity ^0.8.1;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      *
204      * [IMPORTANT]
205      * ====
206      * You shouldn't rely on `isContract` to protect against flash loan attacks!
207      *
208      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
209      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
210      * constructor.
211      * ====
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies on extcodesize/address.code.length, which returns 0
215         // for contracts in construction, since the code is only stored at the end
216         // of the constructor execution.
217 
218         return account.code.length > 0;
219     }
220 
221     /**
222      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
223      * `recipient`, forwarding all available gas and reverting on errors.
224      *
225      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
226      * of certain opcodes, possibly making contracts go over the 2300 gas limit
227      * imposed by `transfer`, making them unable to receive funds via
228      * `transfer`. {sendValue} removes this limitation.
229      *
230      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
231      *
232      * IMPORTANT: because control is transferred to `recipient`, care must be
233      * taken to not create reentrancy vulnerabilities. Consider using
234      * {ReentrancyGuard} or the
235      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
236      */
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     /**
245      * @dev Performs a Solidity function call using a low level `call`. A
246      * plain `call` is an unsafe replacement for a function call: use this
247      * function instead.
248      *
249      * If `target` reverts with a revert reason, it is bubbled up by this
250      * function (like regular Solidity function calls).
251      *
252      * Returns the raw returned data. To convert to the expected return value,
253      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
254      *
255      * Requirements:
256      *
257      * - `target` must be a contract.
258      * - calling `target` with `data` must not revert.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionCall(target, data, "Address: low-level call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
268      * `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
301      * with `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(address(this).balance >= value, "Address: insufficient balance for call");
312         require(isContract(target), "Address: call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.call{value: value}(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
325         return functionStaticCall(target, data, "Address: low-level static call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(isContract(target), "Address: delegate call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.delegatecall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
374      * revert reason using the provided one.
375      *
376      * _Available since v4.3._
377      */
378     function verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @dev Interface of the ERC165 standard, as defined in the
410  * https://eips.ethereum.org/EIPS/eip-165[EIP].
411  *
412  * Implementers can declare support of contract interfaces, which can then be
413  * queried by others ({ERC165Checker}).
414  *
415  * For an implementation, see {ERC165}.
416  */
417 interface IERC165 {
418     /**
419      * @dev Returns true if this contract implements the interface defined by
420      * `interfaceId`. See the corresponding
421      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
422      * to learn more about how these ids are created.
423      *
424      * This function call must use less than 30 000 gas.
425      */
426     function supportsInterface(bytes4 interfaceId) external view returns (bool);
427 }
428 
429 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
430 
431 
432 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 
437 /**
438  * @dev Implementation of the {IERC165} interface.
439  *
440  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
441  * for the additional interface id that will be supported. For example:
442  *
443  * ```solidity
444  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
445  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
446  * }
447  * ```
448  *
449  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
450  */
451 abstract contract ERC165 is IERC165 {
452     /**
453      * @dev See {IERC165-supportsInterface}.
454      */
455     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
456         return interfaceId == type(IERC165).interfaceId;
457     }
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @dev _Available since v3.1._
470  */
471 interface IERC1155Receiver is IERC165 {
472     /**
473      * @dev Handles the receipt of a single ERC1155 token type. This function is
474      * called at the end of a `safeTransferFrom` after the balance has been updated.
475      *
476      * NOTE: To accept the transfer, this must return
477      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
478      * (i.e. 0xf23a6e61, or its own function selector).
479      *
480      * @param operator The address which initiated the transfer (i.e. msg.sender)
481      * @param from The address which previously owned the token
482      * @param id The ID of the token being transferred
483      * @param value The amount of tokens being transferred
484      * @param data Additional data with no specified format
485      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
486      */
487     function onERC1155Received(
488         address operator,
489         address from,
490         uint256 id,
491         uint256 value,
492         bytes calldata data
493     ) external returns (bytes4);
494 
495     /**
496      * @dev Handles the receipt of a multiple ERC1155 token types. This function
497      * is called at the end of a `safeBatchTransferFrom` after the balances have
498      * been updated.
499      *
500      * NOTE: To accept the transfer(s), this must return
501      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
502      * (i.e. 0xbc197c81, or its own function selector).
503      *
504      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
505      * @param from The address which previously owned the token
506      * @param ids An array containing ids of each token being transferred (order and length must match values array)
507      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
508      * @param data Additional data with no specified format
509      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
510      */
511     function onERC1155BatchReceived(
512         address operator,
513         address from,
514         uint256[] calldata ids,
515         uint256[] calldata values,
516         bytes calldata data
517     ) external returns (bytes4);
518 }
519 
520 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Required interface of an ERC1155 compliant contract, as defined in the
530  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
531  *
532  * _Available since v3.1._
533  */
534 interface IERC1155 is IERC165 {
535     /**
536      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
537      */
538     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
539 
540     /**
541      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
542      * transfers.
543      */
544     event TransferBatch(
545         address indexed operator,
546         address indexed from,
547         address indexed to,
548         uint256[] ids,
549         uint256[] values
550     );
551 
552     /**
553      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
554      * `approved`.
555      */
556     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
557 
558     /**
559      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
560      *
561      * If an {URI} event was emitted for `id`, the standard
562      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
563      * returned by {IERC1155MetadataURI-uri}.
564      */
565     event URI(string value, uint256 indexed id);
566 
567     /**
568      * @dev Returns the amount of tokens of token type `id` owned by `account`.
569      *
570      * Requirements:
571      *
572      * - `account` cannot be the zero address.
573      */
574     function balanceOf(address account, uint256 id) external view returns (uint256);
575 
576     /**
577      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
578      *
579      * Requirements:
580      *
581      * - `accounts` and `ids` must have the same length.
582      */
583     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
584         external
585         view
586         returns (uint256[] memory);
587 
588     /**
589      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
590      *
591      * Emits an {ApprovalForAll} event.
592      *
593      * Requirements:
594      *
595      * - `operator` cannot be the caller.
596      */
597     function setApprovalForAll(address operator, bool approved) external;
598 
599     /**
600      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
601      *
602      * See {setApprovalForAll}.
603      */
604     function isApprovedForAll(address account, address operator) external view returns (bool);
605 
606     /**
607      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
608      *
609      * Emits a {TransferSingle} event.
610      *
611      * Requirements:
612      *
613      * - `to` cannot be the zero address.
614      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
615      * - `from` must have a balance of tokens of type `id` of at least `amount`.
616      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
617      * acceptance magic value.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 id,
623         uint256 amount,
624         bytes calldata data
625     ) external;
626 
627     /**
628      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
629      *
630      * Emits a {TransferBatch} event.
631      *
632      * Requirements:
633      *
634      * - `ids` and `amounts` must have the same length.
635      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
636      * acceptance magic value.
637      */
638     function safeBatchTransferFrom(
639         address from,
640         address to,
641         uint256[] calldata ids,
642         uint256[] calldata amounts,
643         bytes calldata data
644     ) external;
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
657  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
658  *
659  * _Available since v3.1._
660  */
661 interface IERC1155MetadataURI is IERC1155 {
662     /**
663      * @dev Returns the URI for token type `id`.
664      *
665      * If the `\{id\}` substring is present in the URI, it must be replaced by
666      * clients with the actual token type ID.
667      */
668     function uri(uint256 id) external view returns (string memory);
669 }
670 
671 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 
679 
680 
681 
682 
683 
684 /**
685  * @dev Implementation of the basic standard multi-token.
686  * See https://eips.ethereum.org/EIPS/eip-1155
687  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
688  *
689  * _Available since v3.1._
690  */
691 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
692     using Address for address;
693 
694     // Mapping from token ID to account balances
695     mapping(uint256 => mapping(address => uint256)) private _balances;
696 
697     // Mapping from account to operator approvals
698     mapping(address => mapping(address => bool)) private _operatorApprovals;
699 
700     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
701     string private _uri;
702 
703     /**
704      * @dev See {_setURI}.
705      */
706     constructor(string memory uri_) {
707         _setURI(uri_);
708     }
709 
710     /**
711      * @dev See {IERC165-supportsInterface}.
712      */
713     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
714         return
715             interfaceId == type(IERC1155).interfaceId ||
716             interfaceId == type(IERC1155MetadataURI).interfaceId ||
717             super.supportsInterface(interfaceId);
718     }
719 
720     /**
721      * @dev See {IERC1155MetadataURI-uri}.
722      *
723      * This implementation returns the same URI for *all* token types. It relies
724      * on the token type ID substitution mechanism
725      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
726      *
727      * Clients calling this function must replace the `\{id\}` substring with the
728      * actual token type ID.
729      */
730     function uri(uint256) public view virtual override returns (string memory) {
731         return _uri;
732     }
733 
734     /**
735      * @dev See {IERC1155-balanceOf}.
736      *
737      * Requirements:
738      *
739      * - `account` cannot be the zero address.
740      */
741     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
742         require(account != address(0), "ERC1155: balance query for the zero address");
743         return _balances[id][account];
744     }
745 
746     /**
747      * @dev See {IERC1155-balanceOfBatch}.
748      *
749      * Requirements:
750      *
751      * - `accounts` and `ids` must have the same length.
752      */
753     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
754         public
755         view
756         virtual
757         override
758         returns (uint256[] memory)
759     {
760         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
761 
762         uint256[] memory batchBalances = new uint256[](accounts.length);
763 
764         for (uint256 i = 0; i < accounts.length; ++i) {
765             batchBalances[i] = balanceOf(accounts[i], ids[i]);
766         }
767 
768         return batchBalances;
769     }
770 
771     /**
772      * @dev See {IERC1155-setApprovalForAll}.
773      */
774     function setApprovalForAll(address operator, bool approved) public virtual override {
775         _setApprovalForAll(_msgSender(), operator, approved);
776     }
777 
778     /**
779      * @dev See {IERC1155-isApprovedForAll}.
780      */
781     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
782         return _operatorApprovals[account][operator];
783     }
784 
785     /**
786      * @dev See {IERC1155-safeTransferFrom}.
787      */
788     function safeTransferFrom(
789         address from,
790         address to,
791         uint256 id,
792         uint256 amount,
793         bytes memory data
794     ) public virtual override {
795         require(
796             from == _msgSender() || isApprovedForAll(from, _msgSender()),
797             "ERC1155: caller is not owner nor approved"
798         );
799         _safeTransferFrom(from, to, id, amount, data);
800     }
801 
802     /**
803      * @dev See {IERC1155-safeBatchTransferFrom}.
804      */
805     function safeBatchTransferFrom(
806         address from,
807         address to,
808         uint256[] memory ids,
809         uint256[] memory amounts,
810         bytes memory data
811     ) public virtual override {
812         require(
813             from == _msgSender() || isApprovedForAll(from, _msgSender()),
814             "ERC1155: transfer caller is not owner nor approved"
815         );
816         _safeBatchTransferFrom(from, to, ids, amounts, data);
817     }
818 
819     /**
820      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
821      *
822      * Emits a {TransferSingle} event.
823      *
824      * Requirements:
825      *
826      * - `to` cannot be the zero address.
827      * - `from` must have a balance of tokens of type `id` of at least `amount`.
828      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
829      * acceptance magic value.
830      */
831     function _safeTransferFrom(
832         address from,
833         address to,
834         uint256 id,
835         uint256 amount,
836         bytes memory data
837     ) internal virtual {
838         require(to != address(0), "ERC1155: transfer to the zero address");
839 
840         address operator = _msgSender();
841 
842         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
843 
844         uint256 fromBalance = _balances[id][from];
845         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
846         unchecked {
847             _balances[id][from] = fromBalance - amount;
848         }
849         _balances[id][to] += amount;
850 
851         emit TransferSingle(operator, from, to, id, amount);
852 
853         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
854     }
855 
856     /**
857      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
858      *
859      * Emits a {TransferBatch} event.
860      *
861      * Requirements:
862      *
863      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
864      * acceptance magic value.
865      */
866     function _safeBatchTransferFrom(
867         address from,
868         address to,
869         uint256[] memory ids,
870         uint256[] memory amounts,
871         bytes memory data
872     ) internal virtual {
873         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
874         require(to != address(0), "ERC1155: transfer to the zero address");
875 
876         address operator = _msgSender();
877 
878         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
879 
880         for (uint256 i = 0; i < ids.length; ++i) {
881             uint256 id = ids[i];
882             uint256 amount = amounts[i];
883 
884             uint256 fromBalance = _balances[id][from];
885             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
886             unchecked {
887                 _balances[id][from] = fromBalance - amount;
888             }
889             _balances[id][to] += amount;
890         }
891 
892         emit TransferBatch(operator, from, to, ids, amounts);
893 
894         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
895     }
896 
897     /**
898      * @dev Sets a new URI for all token types, by relying on the token type ID
899      * substitution mechanism
900      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
901      *
902      * By this mechanism, any occurrence of the `\{id\}` substring in either the
903      * URI or any of the amounts in the JSON file at said URI will be replaced by
904      * clients with the token type ID.
905      *
906      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
907      * interpreted by clients as
908      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
909      * for token type ID 0x4cce0.
910      *
911      * See {uri}.
912      *
913      * Because these URIs cannot be meaningfully represented by the {URI} event,
914      * this function emits no events.
915      */
916     function _setURI(string memory newuri) internal virtual {
917         _uri = newuri;
918     }
919 
920     /**
921      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
922      *
923      * Emits a {TransferSingle} event.
924      *
925      * Requirements:
926      *
927      * - `to` cannot be the zero address.
928      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
929      * acceptance magic value.
930      */
931     function _mint(
932         address to,
933         uint256 id,
934         uint256 amount,
935         bytes memory data
936     ) internal virtual {
937         require(to != address(0), "ERC1155: mint to the zero address");
938 
939         address operator = _msgSender();
940 
941         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
942 
943         _balances[id][to] += amount;
944         emit TransferSingle(operator, address(0), to, id, amount);
945 
946         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
947     }
948 
949     /**
950      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
951      *
952      * Requirements:
953      *
954      * - `ids` and `amounts` must have the same length.
955      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
956      * acceptance magic value.
957      */
958     function _mintBatch(
959         address to,
960         uint256[] memory ids,
961         uint256[] memory amounts,
962         bytes memory data
963     ) internal virtual {
964         require(to != address(0), "ERC1155: mint to the zero address");
965         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
966 
967         address operator = _msgSender();
968 
969         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
970 
971         for (uint256 i = 0; i < ids.length; i++) {
972             _balances[ids[i]][to] += amounts[i];
973         }
974 
975         emit TransferBatch(operator, address(0), to, ids, amounts);
976 
977         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
978     }
979 
980     /**
981      * @dev Destroys `amount` tokens of token type `id` from `from`
982      *
983      * Requirements:
984      *
985      * - `from` cannot be the zero address.
986      * - `from` must have at least `amount` tokens of token type `id`.
987      */
988     function _burn(
989         address from,
990         uint256 id,
991         uint256 amount
992     ) internal virtual {
993         require(from != address(0), "ERC1155: burn from the zero address");
994 
995         address operator = _msgSender();
996 
997         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
998 
999         uint256 fromBalance = _balances[id][from];
1000         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1001         unchecked {
1002             _balances[id][from] = fromBalance - amount;
1003         }
1004 
1005         emit TransferSingle(operator, from, address(0), id, amount);
1006     }
1007 
1008     /**
1009      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1010      *
1011      * Requirements:
1012      *
1013      * - `ids` and `amounts` must have the same length.
1014      */
1015     function _burnBatch(
1016         address from,
1017         uint256[] memory ids,
1018         uint256[] memory amounts
1019     ) internal virtual {
1020         require(from != address(0), "ERC1155: burn from the zero address");
1021         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1022 
1023         address operator = _msgSender();
1024 
1025         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1026 
1027         for (uint256 i = 0; i < ids.length; i++) {
1028             uint256 id = ids[i];
1029             uint256 amount = amounts[i];
1030 
1031             uint256 fromBalance = _balances[id][from];
1032             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1033             unchecked {
1034                 _balances[id][from] = fromBalance - amount;
1035             }
1036         }
1037 
1038         emit TransferBatch(operator, from, address(0), ids, amounts);
1039     }
1040 
1041     /**
1042      * @dev Approve `operator` to operate on all of `owner` tokens
1043      *
1044      * Emits a {ApprovalForAll} event.
1045      */
1046     function _setApprovalForAll(
1047         address owner,
1048         address operator,
1049         bool approved
1050     ) internal virtual {
1051         require(owner != operator, "ERC1155: setting approval status for self");
1052         _operatorApprovals[owner][operator] = approved;
1053         emit ApprovalForAll(owner, operator, approved);
1054     }
1055 
1056     /**
1057      * @dev Hook that is called before any token transfer. This includes minting
1058      * and burning, as well as batched variants.
1059      *
1060      * The same hook is called on both single and batched variants. For single
1061      * transfers, the length of the `id` and `amount` arrays will be 1.
1062      *
1063      * Calling conditions (for each `id` and `amount` pair):
1064      *
1065      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1066      * of token type `id` will be  transferred to `to`.
1067      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1068      * for `to`.
1069      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1070      * will be burned.
1071      * - `from` and `to` are never both zero.
1072      * - `ids` and `amounts` have the same, non-zero length.
1073      *
1074      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1075      */
1076     function _beforeTokenTransfer(
1077         address operator,
1078         address from,
1079         address to,
1080         uint256[] memory ids,
1081         uint256[] memory amounts,
1082         bytes memory data
1083     ) internal virtual {}
1084 
1085     function _doSafeTransferAcceptanceCheck(
1086         address operator,
1087         address from,
1088         address to,
1089         uint256 id,
1090         uint256 amount,
1091         bytes memory data
1092     ) private {
1093         if (to.isContract()) {
1094             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1095                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1096                     revert("ERC1155: ERC1155Receiver rejected tokens");
1097                 }
1098             } catch Error(string memory reason) {
1099                 revert(reason);
1100             } catch {
1101                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1102             }
1103         }
1104     }
1105 
1106     function _doSafeBatchTransferAcceptanceCheck(
1107         address operator,
1108         address from,
1109         address to,
1110         uint256[] memory ids,
1111         uint256[] memory amounts,
1112         bytes memory data
1113     ) private {
1114         if (to.isContract()) {
1115             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1116                 bytes4 response
1117             ) {
1118                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1119                     revert("ERC1155: ERC1155Receiver rejected tokens");
1120                 }
1121             } catch Error(string memory reason) {
1122                 revert(reason);
1123             } catch {
1124                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1125             }
1126         }
1127     }
1128 
1129     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1130         uint256[] memory array = new uint256[](1);
1131         array[0] = element;
1132 
1133         return array;
1134     }
1135 }
1136 
1137 // File: contracts/BoringSec.sol
1138 
1139 //SPDX-License-Identifier: MIT
1140 //                ██████   ██████  ██████  ██ ███    ██  ██████      ███████ ███████  ██████ ██    ██ ██████  ██ ████████ ██    ██ 
1141 //                ██   ██ ██    ██ ██   ██ ██ ████   ██ ██           ██      ██      ██      ██    ██ ██   ██ ██    ██     ██  ██
1142 //                ██████  ██    ██ ██████  ██ ██ ██  ██ ██   ███     ███████ █████   ██      ██    ██ ██████  ██    ██      ████
1143 //                ██   ██ ██    ██ ██   ██ ██ ██  ██ ██ ██    ██          ██ ██      ██      ██    ██ ██   ██ ██    ██       ██
1144 //proudly made by:██████   ██████  ██   ██ ██ ██   ████  ██████      ███████ ███████  ██████  ██████  ██   ██ ██    ██       ██
1145 
1146 
1147 
1148 pragma solidity ^0.8.0;
1149 
1150 
1151 
1152 
1153 contract BoringSecurity is ERC1155, Ownable {
1154     string public name;
1155     string public symbol;
1156     uint256 public constant BSEC101 = 101;
1157     uint256 public constant BSEC102 = 102;
1158 
1159     constructor() ERC1155("https://gateway.pinata.cloud/ipfs/QmYf5kUoN4sHZ2dU9mkAKCChFdjtRW64mrFfZc59FS2SAn/metadata101.json") {
1160         _mint(msg.sender, BSEC101, 500, "");
1161         _mint(msg.sender, BSEC102, 500, "");
1162         name = "Boring Security";
1163         symbol = "BoringSEC";
1164     }
1165 
1166     function mint(uint256 amount, uint256 tokenID) public onlyOwner {
1167         _mint(msg.sender, tokenID, amount, "");
1168     }
1169 
1170     function uri(uint256 _tokenID) override public view returns (string memory) {
1171         return string (
1172             abi.encodePacked(
1173                 "https://gateway.pinata.cloud/ipfs/QmYf5kUoN4sHZ2dU9mkAKCChFdjtRW64mrFfZc59FS2SAn/metadata",
1174                 Strings.toString(_tokenID),
1175                 ".json"
1176             )
1177         );
1178     }
1179 }