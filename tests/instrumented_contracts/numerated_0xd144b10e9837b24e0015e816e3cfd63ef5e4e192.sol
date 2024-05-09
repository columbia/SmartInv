1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/access/Ownable.sol
97 
98 
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor() {
124         _setOwner(_msgSender());
125     }
126 
127     /**
128      * @dev Returns the address of the current owner.
129      */
130     function owner() public view virtual returns (address) {
131         return _owner;
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         require(owner() == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     /**
143      * @dev Leaves the contract without owner. It will not be possible to call
144      * `onlyOwner` functions anymore. Can only be called by the current owner.
145      *
146      * NOTE: Renouncing ownership will leave the contract without an owner,
147      * thereby removing any functionality that is only available to the owner.
148      */
149     function renounceOwnership() public virtual onlyOwner {
150         _setOwner(address(0));
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Can only be called by the current owner.
156      */
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _setOwner(newOwner);
160     }
161 
162     function _setOwner(address newOwner) private {
163         address oldOwner = _owner;
164         _owner = newOwner;
165         emit OwnershipTransferred(oldOwner, newOwner);
166     }
167 }
168 
169 // File: @openzeppelin/contracts/utils/Address.sol
170 
171 
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Collection of functions related to the address type
177  */
178 library Address {
179     /**
180      * @dev Returns true if `account` is a contract.
181      *
182      * [IMPORTANT]
183      * ====
184      * It is unsafe to assume that an address for which this function returns
185      * false is an externally-owned account (EOA) and not a contract.
186      *
187      * Among others, `isContract` will return false for the following
188      * types of addresses:
189      *
190      *  - an externally-owned account
191      *  - a contract in construction
192      *  - an address where a contract will be created
193      *  - an address where a contract lived, but was destroyed
194      * ====
195      */
196     function isContract(address account) internal view returns (bool) {
197         // This method relies on extcodesize, which returns 0 for contracts in
198         // construction, since the code is only stored at the end of the
199         // constructor execution.
200 
201         uint256 size;
202         assembly {
203             size := extcodesize(account)
204         }
205         return size > 0;
206     }
207 
208     /**
209      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
210      * `recipient`, forwarding all available gas and reverting on errors.
211      *
212      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
213      * of certain opcodes, possibly making contracts go over the 2300 gas limit
214      * imposed by `transfer`, making them unable to receive funds via
215      * `transfer`. {sendValue} removes this limitation.
216      *
217      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
218      *
219      * IMPORTANT: because control is transferred to `recipient`, care must be
220      * taken to not create reentrancy vulnerabilities. Consider using
221      * {ReentrancyGuard} or the
222      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
223      */
224     function sendValue(address payable recipient, uint256 amount) internal {
225         require(address(this).balance >= amount, "Address: insufficient balance");
226 
227         (bool success, ) = recipient.call{value: amount}("");
228         require(success, "Address: unable to send value, recipient may have reverted");
229     }
230 
231     /**
232      * @dev Performs a Solidity function call using a low level `call`. A
233      * plain `call` is an unsafe replacement for a function call: use this
234      * function instead.
235      *
236      * If `target` reverts with a revert reason, it is bubbled up by this
237      * function (like regular Solidity function calls).
238      *
239      * Returns the raw returned data. To convert to the expected return value,
240      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
241      *
242      * Requirements:
243      *
244      * - `target` must be a contract.
245      * - calling `target` with `data` must not revert.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionCall(target, data, "Address: low-level call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
255      * `errorMessage` as a fallback revert reason when `target` reverts.
256      *
257      * _Available since v3.1._
258      */
259     function functionCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         return functionCallWithValue(target, data, 0, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but also transferring `value` wei to `target`.
270      *
271      * Requirements:
272      *
273      * - the calling contract must have an ETH balance of at least `value`.
274      * - the called Solidity function must be `payable`.
275      *
276      * _Available since v3.1._
277      */
278     function functionCallWithValue(
279         address target,
280         bytes memory data,
281         uint256 value
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
288      * with `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         require(address(this).balance >= value, "Address: insufficient balance for call");
299         require(isContract(target), "Address: call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.call{value: value}(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but performing a static call.
308      *
309      * _Available since v3.3._
310      */
311     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
312         return functionStaticCall(target, data, "Address: low-level static call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal view returns (bytes memory) {
326         require(isContract(target), "Address: static call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.staticcall(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a delegate call.
335      *
336      * _Available since v3.4._
337      */
338     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
339         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a delegate call.
345      *
346      * _Available since v3.4._
347      */
348     function functionDelegateCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(isContract(target), "Address: delegate call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.delegatecall(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
361      * revert reason using the provided one.
362      *
363      * _Available since v4.3._
364      */
365     function verifyCallResult(
366         bool success,
367         bytes memory returndata,
368         string memory errorMessage
369     ) internal pure returns (bytes memory) {
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 assembly {
378                     let returndata_size := mload(returndata)
379                     revert(add(32, returndata), returndata_size)
380                 }
381             } else {
382                 revert(errorMessage);
383             }
384         }
385     }
386 }
387 
388 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
389 
390 
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev Interface of the ERC165 standard, as defined in the
396  * https://eips.ethereum.org/EIPS/eip-165[EIP].
397  *
398  * Implementers can declare support of contract interfaces, which can then be
399  * queried by others ({ERC165Checker}).
400  *
401  * For an implementation, see {ERC165}.
402  */
403 interface IERC165 {
404     /**
405      * @dev Returns true if this contract implements the interface defined by
406      * `interfaceId`. See the corresponding
407      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
408      * to learn more about how these ids are created.
409      *
410      * This function call must use less than 30 000 gas.
411      */
412     function supportsInterface(bytes4 interfaceId) external view returns (bool);
413 }
414 
415 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
416 
417 
418 
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Implementation of the {IERC165} interface.
424  *
425  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
426  * for the additional interface id that will be supported. For example:
427  *
428  * ```solidity
429  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
430  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
431  * }
432  * ```
433  *
434  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
435  */
436 abstract contract ERC165 is IERC165 {
437     /**
438      * @dev See {IERC165-supportsInterface}.
439      */
440     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
441         return interfaceId == type(IERC165).interfaceId;
442     }
443 }
444 
445 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
446 
447 
448 
449 pragma solidity ^0.8.0;
450 
451 
452 /**
453  * @dev _Available since v3.1._
454  */
455 interface IERC1155Receiver is IERC165 {
456     /**
457         @dev Handles the receipt of a single ERC1155 token type. This function is
458         called at the end of a `safeTransferFrom` after the balance has been updated.
459         To accept the transfer, this must return
460         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
461         (i.e. 0xf23a6e61, or its own function selector).
462         @param operator The address which initiated the transfer (i.e. msg.sender)
463         @param from The address which previously owned the token
464         @param id The ID of the token being transferred
465         @param value The amount of tokens being transferred
466         @param data Additional data with no specified format
467         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
468     */
469     function onERC1155Received(
470         address operator,
471         address from,
472         uint256 id,
473         uint256 value,
474         bytes calldata data
475     ) external returns (bytes4);
476 
477     /**
478         @dev Handles the receipt of a multiple ERC1155 token types. This function
479         is called at the end of a `safeBatchTransferFrom` after the balances have
480         been updated. To accept the transfer(s), this must return
481         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
482         (i.e. 0xbc197c81, or its own function selector).
483         @param operator The address which initiated the batch transfer (i.e. msg.sender)
484         @param from The address which previously owned the token
485         @param ids An array containing ids of each token being transferred (order and length must match values array)
486         @param values An array containing amounts of each token being transferred (order and length must match ids array)
487         @param data Additional data with no specified format
488         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
489     */
490     function onERC1155BatchReceived(
491         address operator,
492         address from,
493         uint256[] calldata ids,
494         uint256[] calldata values,
495         bytes calldata data
496     ) external returns (bytes4);
497 }
498 
499 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol
500 
501 
502 
503 pragma solidity ^0.8.0;
504 
505 
506 
507 /**
508  * @dev _Available since v3.1._
509  */
510 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
511     /**
512      * @dev See {IERC165-supportsInterface}.
513      */
514     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
515         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
516     }
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 /**
527  * @dev _Available since v3.1._
528  */
529 contract ERC1155Holder is ERC1155Receiver {
530     function onERC1155Received(
531         address,
532         address,
533         uint256,
534         uint256,
535         bytes memory
536     ) public virtual override returns (bytes4) {
537         return this.onERC1155Received.selector;
538     }
539 
540     function onERC1155BatchReceived(
541         address,
542         address,
543         uint256[] memory,
544         uint256[] memory,
545         bytes memory
546     ) public virtual override returns (bytes4) {
547         return this.onERC1155BatchReceived.selector;
548     }
549 }
550 
551 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
552 
553 
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @dev Required interface of an ERC1155 compliant contract, as defined in the
560  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
561  *
562  * _Available since v3.1._
563  */
564 interface IERC1155 is IERC165 {
565     /**
566      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
567      */
568     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
569 
570     /**
571      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
572      * transfers.
573      */
574     event TransferBatch(
575         address indexed operator,
576         address indexed from,
577         address indexed to,
578         uint256[] ids,
579         uint256[] values
580     );
581 
582     /**
583      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
584      * `approved`.
585      */
586     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
587 
588     /**
589      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
590      *
591      * If an {URI} event was emitted for `id`, the standard
592      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
593      * returned by {IERC1155MetadataURI-uri}.
594      */
595     event URI(string value, uint256 indexed id);
596 
597     /**
598      * @dev Returns the amount of tokens of token type `id` owned by `account`.
599      *
600      * Requirements:
601      *
602      * - `account` cannot be the zero address.
603      */
604     function balanceOf(address account, uint256 id) external view returns (uint256);
605 
606     /**
607      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
608      *
609      * Requirements:
610      *
611      * - `accounts` and `ids` must have the same length.
612      */
613     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
614         external
615         view
616         returns (uint256[] memory);
617 
618     /**
619      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
620      *
621      * Emits an {ApprovalForAll} event.
622      *
623      * Requirements:
624      *
625      * - `operator` cannot be the caller.
626      */
627     function setApprovalForAll(address operator, bool approved) external;
628 
629     /**
630      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
631      *
632      * See {setApprovalForAll}.
633      */
634     function isApprovedForAll(address account, address operator) external view returns (bool);
635 
636     /**
637      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
638      *
639      * Emits a {TransferSingle} event.
640      *
641      * Requirements:
642      *
643      * - `to` cannot be the zero address.
644      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
645      * - `from` must have a balance of tokens of type `id` of at least `amount`.
646      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
647      * acceptance magic value.
648      */
649     function safeTransferFrom(
650         address from,
651         address to,
652         uint256 id,
653         uint256 amount,
654         bytes calldata data
655     ) external;
656 
657     /**
658      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
659      *
660      * Emits a {TransferBatch} event.
661      *
662      * Requirements:
663      *
664      * - `ids` and `amounts` must have the same length.
665      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
666      * acceptance magic value.
667      */
668     function safeBatchTransferFrom(
669         address from,
670         address to,
671         uint256[] calldata ids,
672         uint256[] calldata amounts,
673         bytes calldata data
674     ) external;
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
678 
679 
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
686  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
687  *
688  * _Available since v3.1._
689  */
690 interface IERC1155MetadataURI is IERC1155 {
691     /**
692      * @dev Returns the URI for token type `id`.
693      *
694      * If the `\{id\}` substring is present in the URI, it must be replaced by
695      * clients with the actual token type ID.
696      */
697     function uri(uint256 id) external view returns (string memory);
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
701 
702 
703 
704 pragma solidity ^0.8.0;
705 
706 
707 
708 
709 
710 
711 
712 /**
713  * @dev Implementation of the basic standard multi-token.
714  * See https://eips.ethereum.org/EIPS/eip-1155
715  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
716  *
717  * _Available since v3.1._
718  */
719 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
720     using Address for address;
721 
722     // Mapping from token ID to account balances
723     mapping(uint256 => mapping(address => uint256)) private _balances;
724 
725     // Mapping from account to operator approvals
726     mapping(address => mapping(address => bool)) private _operatorApprovals;
727 
728     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
729     string private _uri;
730 
731     /**
732      * @dev See {_setURI}.
733      */
734     constructor(string memory uri_) {
735         _setURI(uri_);
736     }
737 
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
742         return
743             interfaceId == type(IERC1155).interfaceId ||
744             interfaceId == type(IERC1155MetadataURI).interfaceId ||
745             super.supportsInterface(interfaceId);
746     }
747 
748     /**
749      * @dev See {IERC1155MetadataURI-uri}.
750      *
751      * This implementation returns the same URI for *all* token types. It relies
752      * on the token type ID substitution mechanism
753      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
754      *
755      * Clients calling this function must replace the `\{id\}` substring with the
756      * actual token type ID.
757      */
758     function uri(uint256) public view virtual override returns (string memory) {
759         return _uri;
760     }
761 
762     /**
763      * @dev See {IERC1155-balanceOf}.
764      *
765      * Requirements:
766      *
767      * - `account` cannot be the zero address.
768      */
769     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
770         require(account != address(0), "ERC1155: balance query for the zero address");
771         return _balances[id][account];
772     }
773 
774     /**
775      * @dev See {IERC1155-balanceOfBatch}.
776      *
777      * Requirements:
778      *
779      * - `accounts` and `ids` must have the same length.
780      */
781     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
782         public
783         view
784         virtual
785         override
786         returns (uint256[] memory)
787     {
788         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
789 
790         uint256[] memory batchBalances = new uint256[](accounts.length);
791 
792         for (uint256 i = 0; i < accounts.length; ++i) {
793             batchBalances[i] = balanceOf(accounts[i], ids[i]);
794         }
795 
796         return batchBalances;
797     }
798 
799     /**
800      * @dev See {IERC1155-setApprovalForAll}.
801      */
802     function setApprovalForAll(address operator, bool approved) public virtual override {
803         require(_msgSender() != operator, "ERC1155: setting approval status for self");
804 
805         _operatorApprovals[_msgSender()][operator] = approved;
806         emit ApprovalForAll(_msgSender(), operator, approved);
807     }
808 
809     /**
810      * @dev See {IERC1155-isApprovedForAll}.
811      */
812     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
813         return _operatorApprovals[account][operator];
814     }
815 
816     /**
817      * @dev See {IERC1155-safeTransferFrom}.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 id,
823         uint256 amount,
824         bytes memory data
825     ) public virtual override {
826         require(
827             from == _msgSender() || isApprovedForAll(from, _msgSender()),
828             "ERC1155: caller is not owner nor approved"
829         );
830         _safeTransferFrom(from, to, id, amount, data);
831     }
832 
833     /**
834      * @dev See {IERC1155-safeBatchTransferFrom}.
835      */
836     function safeBatchTransferFrom(
837         address from,
838         address to,
839         uint256[] memory ids,
840         uint256[] memory amounts,
841         bytes memory data
842     ) public virtual override {
843         require(
844             from == _msgSender() || isApprovedForAll(from, _msgSender()),
845             "ERC1155: transfer caller is not owner nor approved"
846         );
847         _safeBatchTransferFrom(from, to, ids, amounts, data);
848     }
849 
850     /**
851      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
852      *
853      * Emits a {TransferSingle} event.
854      *
855      * Requirements:
856      *
857      * - `to` cannot be the zero address.
858      * - `from` must have a balance of tokens of type `id` of at least `amount`.
859      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
860      * acceptance magic value.
861      */
862     function _safeTransferFrom(
863         address from,
864         address to,
865         uint256 id,
866         uint256 amount,
867         bytes memory data
868     ) internal virtual {
869         require(to != address(0), "ERC1155: transfer to the zero address");
870 
871         address operator = _msgSender();
872 
873         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
874 
875         uint256 fromBalance = _balances[id][from];
876         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
877         unchecked {
878             _balances[id][from] = fromBalance - amount;
879         }
880         _balances[id][to] += amount;
881 
882         emit TransferSingle(operator, from, to, id, amount);
883 
884         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
885     }
886 
887     /**
888      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
889      *
890      * Emits a {TransferBatch} event.
891      *
892      * Requirements:
893      *
894      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
895      * acceptance magic value.
896      */
897     function _safeBatchTransferFrom(
898         address from,
899         address to,
900         uint256[] memory ids,
901         uint256[] memory amounts,
902         bytes memory data
903     ) internal virtual {
904         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
905         require(to != address(0), "ERC1155: transfer to the zero address");
906 
907         address operator = _msgSender();
908 
909         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
910 
911         for (uint256 i = 0; i < ids.length; ++i) {
912             uint256 id = ids[i];
913             uint256 amount = amounts[i];
914 
915             uint256 fromBalance = _balances[id][from];
916             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
917             unchecked {
918                 _balances[id][from] = fromBalance - amount;
919             }
920             _balances[id][to] += amount;
921         }
922 
923         emit TransferBatch(operator, from, to, ids, amounts);
924 
925         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
926     }
927 
928     /**
929      * @dev Sets a new URI for all token types, by relying on the token type ID
930      * substitution mechanism
931      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
932      *
933      * By this mechanism, any occurrence of the `\{id\}` substring in either the
934      * URI or any of the amounts in the JSON file at said URI will be replaced by
935      * clients with the token type ID.
936      *
937      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
938      * interpreted by clients as
939      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
940      * for token type ID 0x4cce0.
941      *
942      * See {uri}.
943      *
944      * Because these URIs cannot be meaningfully represented by the {URI} event,
945      * this function emits no events.
946      */
947     function _setURI(string memory newuri) internal virtual {
948         _uri = newuri;
949     }
950 
951     /**
952      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
953      *
954      * Emits a {TransferSingle} event.
955      *
956      * Requirements:
957      *
958      * - `account` cannot be the zero address.
959      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
960      * acceptance magic value.
961      */
962     function _mint(
963         address account,
964         uint256 id,
965         uint256 amount,
966         bytes memory data
967     ) internal virtual {
968         require(account != address(0), "ERC1155: mint to the zero address");
969 
970         address operator = _msgSender();
971 
972         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
973 
974         _balances[id][account] += amount;
975         emit TransferSingle(operator, address(0), account, id, amount);
976 
977         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
978     }
979 
980     /**
981      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
982      *
983      * Requirements:
984      *
985      * - `ids` and `amounts` must have the same length.
986      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
987      * acceptance magic value.
988      */
989     function _mintBatch(
990         address to,
991         uint256[] memory ids,
992         uint256[] memory amounts,
993         bytes memory data
994     ) internal virtual {
995         require(to != address(0), "ERC1155: mint to the zero address");
996         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
997 
998         address operator = _msgSender();
999 
1000         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1001 
1002         for (uint256 i = 0; i < ids.length; i++) {
1003             _balances[ids[i]][to] += amounts[i];
1004         }
1005 
1006         emit TransferBatch(operator, address(0), to, ids, amounts);
1007 
1008         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1009     }
1010 
1011     /**
1012      * @dev Destroys `amount` tokens of token type `id` from `account`
1013      *
1014      * Requirements:
1015      *
1016      * - `account` cannot be the zero address.
1017      * - `account` must have at least `amount` tokens of token type `id`.
1018      */
1019     function _burn(
1020         address account,
1021         uint256 id,
1022         uint256 amount
1023     ) internal virtual {
1024         require(account != address(0), "ERC1155: burn from the zero address");
1025 
1026         address operator = _msgSender();
1027 
1028         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1029 
1030         uint256 accountBalance = _balances[id][account];
1031         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1032         unchecked {
1033             _balances[id][account] = accountBalance - amount;
1034         }
1035 
1036         emit TransferSingle(operator, account, address(0), id, amount);
1037     }
1038 
1039     /**
1040      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1041      *
1042      * Requirements:
1043      *
1044      * - `ids` and `amounts` must have the same length.
1045      */
1046     function _burnBatch(
1047         address account,
1048         uint256[] memory ids,
1049         uint256[] memory amounts
1050     ) internal virtual {
1051         require(account != address(0), "ERC1155: burn from the zero address");
1052         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1053 
1054         address operator = _msgSender();
1055 
1056         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1057 
1058         for (uint256 i = 0; i < ids.length; i++) {
1059             uint256 id = ids[i];
1060             uint256 amount = amounts[i];
1061 
1062             uint256 accountBalance = _balances[id][account];
1063             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1064             unchecked {
1065                 _balances[id][account] = accountBalance - amount;
1066             }
1067         }
1068 
1069         emit TransferBatch(operator, account, address(0), ids, amounts);
1070     }
1071 
1072     /**
1073      * @dev Hook that is called before any token transfer. This includes minting
1074      * and burning, as well as batched variants.
1075      *
1076      * The same hook is called on both single and batched variants. For single
1077      * transfers, the length of the `id` and `amount` arrays will be 1.
1078      *
1079      * Calling conditions (for each `id` and `amount` pair):
1080      *
1081      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1082      * of token type `id` will be  transferred to `to`.
1083      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1084      * for `to`.
1085      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1086      * will be burned.
1087      * - `from` and `to` are never both zero.
1088      * - `ids` and `amounts` have the same, non-zero length.
1089      *
1090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1091      */
1092     function _beforeTokenTransfer(
1093         address operator,
1094         address from,
1095         address to,
1096         uint256[] memory ids,
1097         uint256[] memory amounts,
1098         bytes memory data
1099     ) internal virtual {}
1100 
1101     function _doSafeTransferAcceptanceCheck(
1102         address operator,
1103         address from,
1104         address to,
1105         uint256 id,
1106         uint256 amount,
1107         bytes memory data
1108     ) private {
1109         if (to.isContract()) {
1110             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1111                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1112                     revert("ERC1155: ERC1155Receiver rejected tokens");
1113                 }
1114             } catch Error(string memory reason) {
1115                 revert(reason);
1116             } catch {
1117                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1118             }
1119         }
1120     }
1121 
1122     function _doSafeBatchTransferAcceptanceCheck(
1123         address operator,
1124         address from,
1125         address to,
1126         uint256[] memory ids,
1127         uint256[] memory amounts,
1128         bytes memory data
1129     ) private {
1130         if (to.isContract()) {
1131             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1132                 bytes4 response
1133             ) {
1134                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1135                     revert("ERC1155: ERC1155Receiver rejected tokens");
1136                 }
1137             } catch Error(string memory reason) {
1138                 revert(reason);
1139             } catch {
1140                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1141             }
1142         }
1143     }
1144 
1145     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1146         uint256[] memory array = new uint256[](1);
1147         array[0] = element;
1148 
1149         return array;
1150     }
1151 }
1152 
1153 // File: baselib/Initializable.sol
1154 
1155 
1156 
1157 pragma solidity ^0.8.0;
1158 
1159 contract Initializable {
1160     bool inited = false;
1161 
1162     modifier initializer() {
1163         require(!inited, "already inited");
1164         _;
1165         inited = true;
1166     }
1167 }
1168 // File: baselib/EIP712Base.sol
1169 
1170 
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 
1175 contract EIP712Base is Initializable {
1176     struct EIP712Domain {
1177         string name;
1178         string version;
1179         address verifyingContract;
1180         bytes32 salt;
1181     }
1182 
1183     string constant public ERC712_VERSION = "1";
1184 
1185     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
1186         bytes(
1187             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1188         )
1189     );
1190     bytes32 internal domainSeperator;
1191 
1192     // supposed to be called once while initializing.
1193     // one of the contracts that inherits this contract follows proxy pattern
1194     // so it is not possible to do this in a constructor
1195     function _initializeEIP712(
1196         string memory name
1197     )
1198         internal
1199         initializer
1200     {
1201         _setDomainSeperator(name);
1202     }
1203 
1204     function _setDomainSeperator(string memory name) internal {
1205         domainSeperator = keccak256(
1206             abi.encode(
1207                 EIP712_DOMAIN_TYPEHASH,
1208                 keccak256(bytes(name)),
1209                 keccak256(bytes(ERC712_VERSION)),
1210                 address(this),
1211                 bytes32(getChainId())
1212             )
1213         );
1214     }
1215 
1216     function getDomainSeperator() public view returns (bytes32) {
1217         return domainSeperator;
1218     }
1219 
1220     function getChainId() public view returns (uint256) {
1221         uint256 id;
1222         assembly {
1223             id := chainid()
1224         }
1225         return id;
1226     }
1227 
1228     /**
1229      * Accept message hash and returns hash message in EIP712 compatible form
1230      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1231      * https://eips.ethereum.org/EIPS/eip-712
1232      * "\\x19" makes the encoding deterministic
1233      * "\\x01" is the version byte to make it compatible to EIP-191
1234      */
1235     function toTypedMessageHash(bytes32 messageHash)
1236         internal
1237         view
1238         returns (bytes32)
1239     {
1240         return
1241             keccak256(
1242                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1243             );
1244     }
1245 }
1246 // File: baselib/SafeMath.sol
1247 
1248 
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 // CAUTION
1253 // This version of SafeMath should only be used with Solidity 0.8 or later,
1254 // because it relies on the compiler's built in overflow checks.
1255 
1256 /**
1257  * @dev Wrappers over Solidity's arithmetic operations.
1258  *
1259  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1260  * now has built in overflow checking.
1261  */
1262 library SafeMath {
1263     /**
1264      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1265      *
1266      * _Available since v3.4._
1267      */
1268     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1269         unchecked {
1270             uint256 c = a + b;
1271             if (c < a) return (false, 0);
1272             return (true, c);
1273         }
1274     }
1275 
1276     /**
1277      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1278      *
1279      * _Available since v3.4._
1280      */
1281     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1282         unchecked {
1283             if (b > a) return (false, 0);
1284             return (true, a - b);
1285         }
1286     }
1287 
1288     /**
1289      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1290      *
1291      * _Available since v3.4._
1292      */
1293     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1294         unchecked {
1295             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1296             // benefit is lost if 'b' is also tested.
1297             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1298             if (a == 0) return (true, 0);
1299             uint256 c = a * b;
1300             if (c / a != b) return (false, 0);
1301             return (true, c);
1302         }
1303     }
1304 
1305     /**
1306      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1307      *
1308      * _Available since v3.4._
1309      */
1310     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1311         unchecked {
1312             if (b == 0) return (false, 0);
1313             return (true, a / b);
1314         }
1315     }
1316 
1317     /**
1318      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1319      *
1320      * _Available since v3.4._
1321      */
1322     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1323         unchecked {
1324             if (b == 0) return (false, 0);
1325             return (true, a % b);
1326         }
1327     }
1328 
1329     /**
1330      * @dev Returns the addition of two unsigned integers, reverting on
1331      * overflow.
1332      *
1333      * Counterpart to Solidity's `+` operator.
1334      *
1335      * Requirements:
1336      *
1337      * - Addition cannot overflow.
1338      */
1339     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1340         return a + b;
1341     }
1342 
1343     /**
1344      * @dev Returns the subtraction of two unsigned integers, reverting on
1345      * overflow (when the result is negative).
1346      *
1347      * Counterpart to Solidity's `-` operator.
1348      *
1349      * Requirements:
1350      *
1351      * - Subtraction cannot overflow.
1352      */
1353     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1354         return a - b;
1355     }
1356 
1357     /**
1358      * @dev Returns the multiplication of two unsigned integers, reverting on
1359      * overflow.
1360      *
1361      * Counterpart to Solidity's `*` operator.
1362      *
1363      * Requirements:
1364      *
1365      * - Multiplication cannot overflow.
1366      */
1367     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1368         return a * b;
1369     }
1370 
1371     /**
1372      * @dev Returns the integer division of two unsigned integers, reverting on
1373      * division by zero. The result is rounded towards zero.
1374      *
1375      * Counterpart to Solidity's `/` operator.
1376      *
1377      * Requirements:
1378      *
1379      * - The divisor cannot be zero.
1380      */
1381     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1382         return a / b;
1383     }
1384 
1385     /**
1386      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1387      * reverting when dividing by zero.
1388      *
1389      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1390      * opcode (which leaves remaining gas untouched) while Solidity uses an
1391      * invalid opcode to revert (consuming all remaining gas).
1392      *
1393      * Requirements:
1394      *
1395      * - The divisor cannot be zero.
1396      */
1397     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1398         return a % b;
1399     }
1400 
1401     /**
1402      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1403      * overflow (when the result is negative).
1404      *
1405      * CAUTION: This function is deprecated because it requires allocating memory for the error
1406      * message unnecessarily. For custom revert reasons use {trySub}.
1407      *
1408      * Counterpart to Solidity's `-` operator.
1409      *
1410      * Requirements:
1411      *
1412      * - Subtraction cannot overflow.
1413      */
1414     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1415         unchecked {
1416             require(b <= a, errorMessage);
1417             return a - b;
1418         }
1419     }
1420 
1421     /**
1422      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1423      * division by zero. The result is rounded towards zero.
1424      *
1425      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1426      * opcode (which leaves remaining gas untouched) while Solidity uses an
1427      * invalid opcode to revert (consuming all remaining gas).
1428      *
1429      * Counterpart to Solidity's `/` operator. Note: this function uses a
1430      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1431      * uses an invalid opcode to revert (consuming all remaining gas).
1432      *
1433      * Requirements:
1434      *
1435      * - The divisor cannot be zero.
1436      */
1437     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1438         unchecked {
1439             require(b > 0, errorMessage);
1440             return a / b;
1441         }
1442     }
1443 
1444     /**
1445      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1446      * reverting with custom message when dividing by zero.
1447      *
1448      * CAUTION: This function is deprecated because it requires allocating memory for the error
1449      * message unnecessarily. For custom revert reasons use {tryMod}.
1450      *
1451      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1452      * opcode (which leaves remaining gas untouched) while Solidity uses an
1453      * invalid opcode to revert (consuming all remaining gas).
1454      *
1455      * Requirements:
1456      *
1457      * - The divisor cannot be zero.
1458      */
1459     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1460         unchecked {
1461             require(b > 0, errorMessage);
1462             return a % b;
1463         }
1464     }
1465 }
1466 // File: baselib/NativeMetaTransaction.sol
1467 
1468 
1469 
1470 pragma solidity ^0.8.0;
1471 
1472 
1473 
1474 contract NativeMetaTransaction is EIP712Base {
1475     using SafeMath for uint256;
1476     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
1477         bytes(
1478             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1479         )
1480     );
1481     event MetaTransactionExecuted(
1482         address userAddress,
1483         address payable relayerAddress,
1484         bytes functionSignature
1485     );
1486     mapping(address => uint256) nonces;
1487 
1488     /*
1489      * Meta transaction structure.
1490      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1491      * He should call the desired function directly in that case.
1492      */
1493     struct MetaTransaction {
1494         uint256 nonce;
1495         address from;
1496         bytes functionSignature;
1497     }
1498 
1499     function executeMetaTransaction(
1500         address userAddress,
1501         bytes memory functionSignature,
1502         bytes32 sigR,
1503         bytes32 sigS,
1504         uint8 sigV
1505     ) public payable returns (bytes memory) {
1506         MetaTransaction memory metaTx = MetaTransaction({
1507             nonce: nonces[userAddress],
1508             from: userAddress,
1509             functionSignature: functionSignature
1510         });
1511 
1512         require(
1513             verify(userAddress, metaTx, sigR, sigS, sigV),
1514             "Signer and signature do not match"
1515         );
1516 
1517         // increase nonce for user (to avoid re-use)
1518         nonces[userAddress] = nonces[userAddress].add(1);
1519 
1520         emit MetaTransactionExecuted(
1521             userAddress,
1522             payable(msg.sender),
1523             functionSignature
1524         );
1525 
1526         // Append userAddress and relayer address at the end to extract it from calling context
1527         (bool success, bytes memory returnData) = address(this).call(
1528             abi.encodePacked(functionSignature, userAddress)
1529         );
1530         require(success, "Function call not successful");
1531 
1532         return returnData;
1533     }
1534 
1535     function hashMetaTransaction(MetaTransaction memory metaTx)
1536         internal
1537         pure
1538         returns (bytes32)
1539     {
1540         return
1541             keccak256(
1542                 abi.encode(
1543                     META_TRANSACTION_TYPEHASH,
1544                     metaTx.nonce,
1545                     metaTx.from,
1546                     keccak256(metaTx.functionSignature)
1547                 )
1548             );
1549     }
1550 
1551     function getNonce(address user) public view returns (uint256 nonce) {
1552         nonce = nonces[user];
1553     }
1554 
1555     function verify(
1556         address signer,
1557         MetaTransaction memory metaTx,
1558         bytes32 sigR,
1559         bytes32 sigS,
1560         uint8 sigV
1561     ) internal view returns (bool) {
1562         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1563         return
1564             signer ==
1565             ecrecover(
1566                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1567                 sigV,
1568                 sigR,
1569                 sigS
1570             );
1571     }
1572 }
1573 // File: Robotars.sol
1574 
1575 
1576 
1577 pragma solidity ^0.8.0;
1578 
1579 
1580 
1581 
1582 
1583 
1584 contract Robotars is ERC1155, ERC1155Holder, NativeMetaTransaction,Ownable {
1585     using SafeMath for uint256;
1586     
1587     // uint256 constant MAX_NUM_PER_TOKEN = 1;    
1588     uint256 private price = 0.06 ether; // 
1589     
1590     uint16 constant MAX_TOTAL_SUPPLY = 4999;
1591         
1592      // Random tokens assignment
1593     uint16 internal currentID = 0;
1594     uint16[MAX_TOTAL_SUPPLY] internal indices;
1595     
1596     bytes4 private constant INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
1597     bytes4 private constant INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
1598     bytes4 private constant INTERFACE_SIGNATURE_URI = 0x0e89341c;
1599 
1600     //
1601     bool public presaleActive = false;
1602     bool public saleActive = false;
1603     
1604     //
1605     string internal constant NAME = "Robotars";
1606     string internal constant SYMBOL = "Robotars";
1607     string internal constant _CONTRACT = "ERC1155";
1608     string private URI_BASE =
1609         "https://robotars.s3.us-west-1.amazonaws.com/metadata/robotars-metadata-";
1610 
1611     mapping(address => uint16) public presaleWhitelist;
1612 
1613     constructor() ERC1155(URI_BASE) {        
1614         _initializeEIP712(NAME);
1615     }
1616     
1617     function randomToken(uint16 curIndex) internal returns (uint16, uint16) {
1618         uint16 totalSize = MAX_TOTAL_SUPPLY - curIndex;
1619         uint256 index = uint256(
1620             keccak256(
1621                 abi.encodePacked(
1622                     curIndex,
1623                     msg.sender,
1624                     block.difficulty,
1625                     block.timestamp
1626                 )
1627             )
1628         ) % totalSize;
1629         //uint16 index = uint16(index256);
1630         uint16 value = 0;
1631         if (indices[index] != 0) {
1632             value = indices[index];
1633         } else {
1634             value = uint16(index);
1635         }
1636 
1637         // Move last value to selected position
1638         if (indices[totalSize - 1] == 0) {
1639             // Array position not initialized, so use position
1640             indices[index] = totalSize - 1;
1641         } else {
1642             // Array position holds a value so use that
1643             indices[index] = indices[totalSize - 1];
1644         }
1645         curIndex++;
1646         // Don't allow a zero index, start counting at 1
1647         return (value+1, curIndex);
1648     }
1649     
1650 
1651     function editPresale(
1652         address[] calldata presaleAddresses,
1653         uint16[] calldata amount
1654     ) external onlyOwner {
1655         for (uint16 i = 0; i < presaleAddresses.length; i++) {
1656             presaleWhitelist[presaleAddresses[i]] = amount[i];
1657         }
1658     }
1659 
1660     function mintPresale(uint16 _customBatchCount) external payable {
1661         uint16 reserved = presaleWhitelist[msg.sender];
1662         require(presaleActive, "Presale must be active to mint");
1663         require(reserved > 0, "No tokens reserved for this address");
1664         require(_customBatchCount <= reserved, "Can't mint more than reserved");
1665         require(_customBatchCount > 0, "count should be more than one");
1666         require(
1667             price.mul(_customBatchCount) <= msg.value,
1668             "Sorry, sending incorrect eth value"
1669         );
1670         presaleWhitelist[msg.sender] = reserved - _customBatchCount;
1671         _batchMint(msg.sender, _customBatchCount);
1672     }
1673 
1674     function mintPayable(uint16 _customBatchCount) external payable {
1675         require(saleActive, "Sale must be active to mint");
1676         require(_customBatchCount > 0, "count should be more than one");
1677         require(
1678             price.mul(_customBatchCount) <= msg.value,
1679             "Sorry, sending incorrect eth value"
1680         );
1681 
1682         _batchMint(msg.sender, _customBatchCount);
1683     }
1684 
1685     function mint(address _to,uint16 _customBatchCount) external onlyOwner {
1686         if (_customBatchCount <= 0) _customBatchCount = 50;
1687 
1688         _batchMint(_to, _customBatchCount);
1689     }
1690 
1691 
1692     function _batchMint(address _to, uint16 num) private {
1693         uint16 totalSize = MAX_TOTAL_SUPPLY - currentID;        
1694         require(
1695             num <= totalSize,
1696             "Sorry, Request More than TotalSupply, Please Change Number"
1697         );
1698         uint16 curIndex = currentID;
1699         uint256[] memory ids = new uint256[](num);
1700         uint256[] memory amounts = new uint256[](num);
1701         
1702         for (uint16 i = 0; i < num; i++) {
1703             (ids[i], curIndex) = randomToken(curIndex);
1704             amounts[i] = 1;//MAX_NUM_PER_TOKEN;
1705         }
1706         currentID = curIndex;
1707         super._mintBatch(_to, ids, amounts, "");
1708         
1709     }
1710     
1711 
1712 
1713     function setBaseUri(string memory _uri) public onlyOwner {
1714          URI_BASE = _uri;
1715     }
1716     
1717     // Make it possible to change the price: just in case
1718     function setPrice(uint256 _newPrice) external onlyOwner {
1719         price = _newPrice;
1720     }
1721 
1722     function getPrice() external view returns (uint256) {
1723         return price;
1724     }
1725 
1726     function setSalePreSale(bool isSale, bool isPreSale) public onlyOwner {
1727         presaleActive = isPreSale;
1728         saleActive = isSale;
1729     }    
1730 
1731     function name() external pure returns (string memory) {
1732         return NAME;
1733     }
1734 
1735     function symbol() external pure returns (string memory) {
1736         return SYMBOL;
1737     }
1738 
1739     function supportsFactoryInterface() public pure returns (bool) {
1740         return true;
1741     }
1742 
1743     function factorySchemaName() external pure returns (string memory) {
1744         return _CONTRACT;
1745     }
1746 
1747     function totalSupply() external pure returns (uint256) {
1748         return MAX_TOTAL_SUPPLY;
1749     }
1750 
1751     
1752     function supportsInterface(bytes4 interfaceId)
1753         public
1754         view
1755         virtual
1756         override(ERC1155, ERC1155Receiver)
1757         returns (bool)
1758     {
1759         if (
1760             interfaceId == INTERFACE_SIGNATURE_ERC165 ||
1761             interfaceId == INTERFACE_SIGNATURE_ERC1155 ||
1762             interfaceId == INTERFACE_SIGNATURE_URI
1763         ) {
1764             return true;
1765         }
1766         return super.supportsInterface(interfaceId);
1767     }
1768 
1769     function uri(uint256 _tokenId)
1770         public
1771         view
1772         override
1773         returns (string memory)
1774     {
1775         return _getUri(_tokenId);
1776     }
1777 
1778     function _getUri(uint256 _tokenId) internal view returns (string memory) {
1779         return
1780             string(
1781                 abi.encodePacked(URI_BASE, Strings.toString(_tokenId), ".json")
1782             );
1783     }
1784     
1785     function withdraw() public onlyOwner {
1786         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1787         require(
1788             success,
1789             "Address: unable to send value, recipient may have reverted"
1790         );
1791     }
1792     
1793     receive() external payable {}
1794 
1795     fallback() external payable {}
1796     
1797 }