1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
28 
29 
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         return msg.data;
48     }
49 }
50 
51 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
52 
53 
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60     uint8 private constant _ADDRESS_LENGTH = 20;
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
64      */
65     function toString(uint256 value) internal pure returns (string memory) {
66         // Inspired by OraclizeAPI's implementation - MIT licence
67         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
68 
69         if (value == 0) {
70             return "0";
71         }
72         uint256 temp = value;
73         uint256 digits;
74         while (temp != 0) {
75             digits++;
76             temp /= 10;
77         }
78         bytes memory buffer = new bytes(digits);
79         while (value != 0) {
80             digits -= 1;
81             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
82             value /= 10;
83         }
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
89      */
90     function toHexString(uint256 value) internal pure returns (string memory) {
91         if (value == 0) {
92             return "0x00";
93         }
94         uint256 temp = value;
95         uint256 length = 0;
96         while (temp != 0) {
97             length++;
98             temp >>= 8;
99         }
100         return toHexString(value, length);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
105      */
106     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
107         bytes memory buffer = new bytes(2 * length + 2);
108         buffer[0] = "0";
109         buffer[1] = "x";
110         for (uint256 i = 2 * length + 1; i > 1; --i) {
111             buffer[i] = _HEX_SYMBOLS[value & 0xf];
112             value >>= 4;
113         }
114         require(value == 0, "Strings: hex length insufficient");
115         return string(buffer);
116     }
117 
118     /**
119      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
120      */
121     function toHexString(address addr) internal pure returns (string memory) {
122         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
123     }
124 }
125 
126 
127 
128 
129 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
130 
131 
132 
133 
134 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
135 
136 
137 
138 
139 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
140 
141 
142 
143 
144 
145 /**
146  * @dev Required interface of an ERC1155 compliant contract, as defined in the
147  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
148  *
149  * _Available since v3.1._
150  */
151 interface IERC1155 is IERC165 {
152     /**
153      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
154      */
155     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
156 
157     /**
158      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
159      * transfers.
160      */
161     event TransferBatch(
162         address indexed operator,
163         address indexed from,
164         address indexed to,
165         uint256[] ids,
166         uint256[] values
167     );
168 
169     /**
170      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
171      * `approved`.
172      */
173     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
174 
175     /**
176      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
177      *
178      * If an {URI} event was emitted for `id`, the standard
179      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
180      * returned by {IERC1155MetadataURI-uri}.
181      */
182     event URI(string value, uint256 indexed id);
183 
184     /**
185      * @dev Returns the amount of tokens of token type `id` owned by `account`.
186      *
187      * Requirements:
188      *
189      * - `account` cannot be the zero address.
190      */
191     function balanceOf(address account, uint256 id) external view returns (uint256);
192 
193     /**
194      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
195      *
196      * Requirements:
197      *
198      * - `accounts` and `ids` must have the same length.
199      */
200     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
201         external
202         view
203         returns (uint256[] memory);
204 
205     /**
206      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
207      *
208      * Emits an {ApprovalForAll} event.
209      *
210      * Requirements:
211      *
212      * - `operator` cannot be the caller.
213      */
214     function setApprovalForAll(address operator, bool approved) external;
215 
216     /**
217      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
218      *
219      * See {setApprovalForAll}.
220      */
221     function isApprovedForAll(address account, address operator) external view returns (bool);
222 
223     /**
224      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
225      *
226      * Emits a {TransferSingle} event.
227      *
228      * Requirements:
229      *
230      * - `to` cannot be the zero address.
231      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
232      * - `from` must have a balance of tokens of type `id` of at least `amount`.
233      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
234      * acceptance magic value.
235      */
236     function safeTransferFrom(
237         address from,
238         address to,
239         uint256 id,
240         uint256 amount,
241         bytes calldata data
242     ) external;
243 
244     /**
245      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
246      *
247      * Emits a {TransferBatch} event.
248      *
249      * Requirements:
250      *
251      * - `ids` and `amounts` must have the same length.
252      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
253      * acceptance magic value.
254      */
255     function safeBatchTransferFrom(
256         address from,
257         address to,
258         uint256[] calldata ids,
259         uint256[] calldata amounts,
260         bytes calldata data
261     ) external;
262 }
263 
264 
265 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
266 
267 
268 
269 
270 
271 /**
272  * @dev _Available since v3.1._
273  */
274 interface IERC1155Receiver is IERC165 {
275     /**
276      * @dev Handles the receipt of a single ERC1155 token type. This function is
277      * called at the end of a `safeTransferFrom` after the balance has been updated.
278      *
279      * NOTE: To accept the transfer, this must return
280      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
281      * (i.e. 0xf23a6e61, or its own function selector).
282      *
283      * @param operator The address which initiated the transfer (i.e. msg.sender)
284      * @param from The address which previously owned the token
285      * @param id The ID of the token being transferred
286      * @param value The amount of tokens being transferred
287      * @param data Additional data with no specified format
288      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
289      */
290     function onERC1155Received(
291         address operator,
292         address from,
293         uint256 id,
294         uint256 value,
295         bytes calldata data
296     ) external returns (bytes4);
297 
298     /**
299      * @dev Handles the receipt of a multiple ERC1155 token types. This function
300      * is called at the end of a `safeBatchTransferFrom` after the balances have
301      * been updated.
302      *
303      * NOTE: To accept the transfer(s), this must return
304      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
305      * (i.e. 0xbc197c81, or its own function selector).
306      *
307      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
308      * @param from The address which previously owned the token
309      * @param ids An array containing ids of each token being transferred (order and length must match values array)
310      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
311      * @param data Additional data with no specified format
312      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
313      */
314     function onERC1155BatchReceived(
315         address operator,
316         address from,
317         uint256[] calldata ids,
318         uint256[] calldata values,
319         bytes calldata data
320     ) external returns (bytes4);
321 }
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
325 
326 
327 
328 
329 
330 /**
331  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
332  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
333  *
334  * _Available since v3.1._
335  */
336 interface IERC1155MetadataURI is IERC1155 {
337     /**
338      * @dev Returns the URI for token type `id`.
339      *
340      * If the `\{id\}` substring is present in the URI, it must be replaced by
341      * clients with the actual token type ID.
342      */
343     function uri(uint256 id) external view returns (string memory);
344 }
345 
346 
347 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
348 
349 
350 
351 /**
352  * @dev Collection of functions related to the address type
353  */
354 library Address {
355     /**
356      * @dev Returns true if `account` is a contract.
357      *
358      * [IMPORTANT]
359      * ====
360      * It is unsafe to assume that an address for which this function returns
361      * false is an externally-owned account (EOA) and not a contract.
362      *
363      * Among others, `isContract` will return false for the following
364      * types of addresses:
365      *
366      *  - an externally-owned account
367      *  - a contract in construction
368      *  - an address where a contract will be created
369      *  - an address where a contract lived, but was destroyed
370      * ====
371      *
372      * [IMPORTANT]
373      * ====
374      * You shouldn't rely on `isContract` to protect against flash loan attacks!
375      *
376      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
377      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
378      * constructor.
379      * ====
380      */
381     function isContract(address account) internal view returns (bool) {
382         // This method relies on extcodesize/address.code.length, which returns 0
383         // for contracts in construction, since the code is only stored at the end
384         // of the constructor execution.
385 
386         return account.code.length > 0;
387     }
388 
389     /**
390      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
391      * `recipient`, forwarding all available gas and reverting on errors.
392      *
393      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
394      * of certain opcodes, possibly making contracts go over the 2300 gas limit
395      * imposed by `transfer`, making them unable to receive funds via
396      * `transfer`. {sendValue} removes this limitation.
397      *
398      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
399      *
400      * IMPORTANT: because control is transferred to `recipient`, care must be
401      * taken to not create reentrancy vulnerabilities. Consider using
402      * {ReentrancyGuard} or the
403      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
404      */
405     function sendValue(address payable recipient, uint256 amount) internal {
406         require(address(this).balance >= amount, "Address: insufficient balance");
407 
408         (bool success, ) = recipient.call{value: amount}("");
409         require(success, "Address: unable to send value, recipient may have reverted");
410     }
411 
412     /**
413      * @dev Performs a Solidity function call using a low level `call`. A
414      * plain `call` is an unsafe replacement for a function call: use this
415      * function instead.
416      *
417      * If `target` reverts with a revert reason, it is bubbled up by this
418      * function (like regular Solidity function calls).
419      *
420      * Returns the raw returned data. To convert to the expected return value,
421      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
422      *
423      * Requirements:
424      *
425      * - `target` must be a contract.
426      * - calling `target` with `data` must not revert.
427      *
428      * _Available since v3.1._
429      */
430     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionCall(target, data, "Address: low-level call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
436      * `errorMessage` as a fallback revert reason when `target` reverts.
437      *
438      * _Available since v3.1._
439      */
440     function functionCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         return functionCallWithValue(target, data, 0, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but also transferring `value` wei to `target`.
451      *
452      * Requirements:
453      *
454      * - the calling contract must have an ETH balance of at least `value`.
455      * - the called Solidity function must be `payable`.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value
463     ) internal returns (bytes memory) {
464         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
469      * with `errorMessage` as a fallback revert reason when `target` reverts.
470      *
471      * _Available since v3.1._
472      */
473     function functionCallWithValue(
474         address target,
475         bytes memory data,
476         uint256 value,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         require(address(this).balance >= value, "Address: insufficient balance for call");
480         require(isContract(target), "Address: call to non-contract");
481 
482         (bool success, bytes memory returndata) = target.call{value: value}(data);
483         return verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
488      * but performing a static call.
489      *
490      * _Available since v3.3._
491      */
492     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
493         return functionStaticCall(target, data, "Address: low-level static call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
498      * but performing a static call.
499      *
500      * _Available since v3.3._
501      */
502     function functionStaticCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal view returns (bytes memory) {
507         require(isContract(target), "Address: static call to non-contract");
508 
509         (bool success, bytes memory returndata) = target.staticcall(data);
510         return verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but performing a delegate call.
516      *
517      * _Available since v3.4._
518      */
519     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
520         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
525      * but performing a delegate call.
526      *
527      * _Available since v3.4._
528      */
529     function functionDelegateCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         require(isContract(target), "Address: delegate call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.delegatecall(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
542      * revert reason using the provided one.
543      *
544      * _Available since v4.3._
545      */
546     function verifyCallResult(
547         bool success,
548         bytes memory returndata,
549         string memory errorMessage
550     ) internal pure returns (bytes memory) {
551         if (success) {
552             return returndata;
553         } else {
554             // Look for revert reason and bubble it up if present
555             if (returndata.length > 0) {
556                 // The easiest way to bubble the revert reason is using memory via assembly
557                 /// @solidity memory-safe-assembly
558                 assembly {
559                     let returndata_size := mload(returndata)
560                     revert(add(32, returndata), returndata_size)
561                 }
562             } else {
563                 revert(errorMessage);
564             }
565         }
566     }
567 }
568 
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
572 
573 
574 
575 
576 
577 /**
578  * @dev Implementation of the {IERC165} interface.
579  *
580  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
581  * for the additional interface id that will be supported. For example:
582  *
583  * ```solidity
584  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
586  * }
587  * ```
588  *
589  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
590  */
591 abstract contract ERC165 is IERC165 {
592     /**
593      * @dev See {IERC165-supportsInterface}.
594      */
595     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
596         return interfaceId == type(IERC165).interfaceId;
597     }
598 }
599 
600 
601 /**
602  * @dev Implementation of the basic standard multi-token.
603  * See https://eips.ethereum.org/EIPS/eip-1155
604  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
605  *
606  * _Available since v3.1._
607  */
608 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
609     using Address for address;
610 
611     // Mapping from token ID to account balances
612     mapping(uint256 => mapping(address => uint256)) private _balances;
613 
614     // Mapping from account to operator approvals
615     mapping(address => mapping(address => bool)) private _operatorApprovals;
616 
617     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
618     string private _uri;
619 
620     /**
621      * @dev See {_setURI}.
622      */
623     constructor(string memory uri_) {
624         _setURI(uri_);
625     }
626 
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
631         return
632             interfaceId == type(IERC1155).interfaceId ||
633             interfaceId == type(IERC1155MetadataURI).interfaceId ||
634             super.supportsInterface(interfaceId);
635     }
636 
637     /**
638      * @dev See {IERC1155MetadataURI-uri}.
639      *
640      * This implementation returns the same URI for *all* token types. It relies
641      * on the token type ID substitution mechanism
642      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
643      *
644      * Clients calling this function must replace the `\{id\}` substring with the
645      * actual token type ID.
646      */
647     function uri(uint256) public view virtual override returns (string memory) {
648         return _uri;
649     }
650 
651     /**
652      * @dev See {IERC1155-balanceOf}.
653      *
654      * Requirements:
655      *
656      * - `account` cannot be the zero address.
657      */
658     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
659         require(account != address(0), "ERC1155: address zero is not a valid owner");
660         return _balances[id][account];
661     }
662 
663     /**
664      * @dev See {IERC1155-balanceOfBatch}.
665      *
666      * Requirements:
667      *
668      * - `accounts` and `ids` must have the same length.
669      */
670     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
671         public
672         view
673         virtual
674         override
675         returns (uint256[] memory)
676     {
677         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
678 
679         uint256[] memory batchBalances = new uint256[](accounts.length);
680 
681         for (uint256 i = 0; i < accounts.length; ++i) {
682             batchBalances[i] = balanceOf(accounts[i], ids[i]);
683         }
684 
685         return batchBalances;
686     }
687 
688     /**
689      * @dev See {IERC1155-setApprovalForAll}.
690      */
691     function setApprovalForAll(address operator, bool approved) public virtual override {
692         _setApprovalForAll(_msgSender(), operator, approved);
693     }
694 
695     /**
696      * @dev See {IERC1155-isApprovedForAll}.
697      */
698     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
699         return _operatorApprovals[account][operator];
700     }
701 
702     /**
703      * @dev See {IERC1155-safeTransferFrom}.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 id,
709         uint256 amount,
710         bytes memory data
711     ) public virtual override {
712         require(
713             from == _msgSender() || isApprovedForAll(from, _msgSender()),
714             "ERC1155: caller is not token owner nor approved"
715         );
716         _safeTransferFrom(from, to, id, amount, data);
717     }
718 
719     /**
720      * @dev See {IERC1155-safeBatchTransferFrom}.
721      */
722     function safeBatchTransferFrom(
723         address from,
724         address to,
725         uint256[] memory ids,
726         uint256[] memory amounts,
727         bytes memory data
728     ) public virtual override {
729         require(
730             from == _msgSender() || isApprovedForAll(from, _msgSender()),
731             "ERC1155: caller is not token owner nor approved"
732         );
733         _safeBatchTransferFrom(from, to, ids, amounts, data);
734     }
735 
736     /**
737      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
738      *
739      * Emits a {TransferSingle} event.
740      *
741      * Requirements:
742      *
743      * - `to` cannot be the zero address.
744      * - `from` must have a balance of tokens of type `id` of at least `amount`.
745      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
746      * acceptance magic value.
747      */
748     function _safeTransferFrom(
749         address from,
750         address to,
751         uint256 id,
752         uint256 amount,
753         bytes memory data
754     ) internal virtual {
755         require(to != address(0), "ERC1155: transfer to the zero address");
756 
757         address operator = _msgSender();
758         uint256[] memory ids = _asSingletonArray(id);
759         uint256[] memory amounts = _asSingletonArray(amount);
760 
761         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
762 
763         uint256 fromBalance = _balances[id][from];
764         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
765         unchecked {
766             _balances[id][from] = fromBalance - amount;
767         }
768         _balances[id][to] += amount;
769 
770         emit TransferSingle(operator, from, to, id, amount);
771 
772         _afterTokenTransfer(operator, from, to, ids, amounts, data);
773 
774         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
775     }
776 
777     /**
778      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
779      *
780      * Emits a {TransferBatch} event.
781      *
782      * Requirements:
783      *
784      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
785      * acceptance magic value.
786      */
787     function _safeBatchTransferFrom(
788         address from,
789         address to,
790         uint256[] memory ids,
791         uint256[] memory amounts,
792         bytes memory data
793     ) internal virtual {
794         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
795         require(to != address(0), "ERC1155: transfer to the zero address");
796 
797         address operator = _msgSender();
798 
799         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
800 
801         for (uint256 i = 0; i < ids.length; ++i) {
802             uint256 id = ids[i];
803             uint256 amount = amounts[i];
804 
805             uint256 fromBalance = _balances[id][from];
806             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
807             unchecked {
808                 _balances[id][from] = fromBalance - amount;
809             }
810             _balances[id][to] += amount;
811         }
812 
813         emit TransferBatch(operator, from, to, ids, amounts);
814 
815         _afterTokenTransfer(operator, from, to, ids, amounts, data);
816 
817         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
818     }
819 
820     /**
821      * @dev Sets a new URI for all token types, by relying on the token type ID
822      * substitution mechanism
823      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
824      *
825      * By this mechanism, any occurrence of the `\{id\}` substring in either the
826      * URI or any of the amounts in the JSON file at said URI will be replaced by
827      * clients with the token type ID.
828      *
829      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
830      * interpreted by clients as
831      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
832      * for token type ID 0x4cce0.
833      *
834      * See {uri}.
835      *
836      * Because these URIs cannot be meaningfully represented by the {URI} event,
837      * this function emits no events.
838      */
839     function _setURI(string memory newuri) internal virtual {
840         _uri = newuri;
841     }
842 
843     /**
844      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
845      *
846      * Emits a {TransferSingle} event.
847      *
848      * Requirements:
849      *
850      * - `to` cannot be the zero address.
851      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
852      * acceptance magic value.
853      */
854     function _mint(
855         address to,
856         uint256 id,
857         uint256 amount,
858         bytes memory data
859     ) internal virtual {
860         require(to != address(0), "ERC1155: mint to the zero address");
861 
862         address operator = _msgSender();
863         uint256[] memory ids = _asSingletonArray(id);
864         uint256[] memory amounts = _asSingletonArray(amount);
865 
866         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
867 
868         _balances[id][to] += amount;
869         emit TransferSingle(operator, address(0), to, id, amount);
870 
871         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
872 
873         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
874     }
875 
876     /**
877      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
878      *
879      * Emits a {TransferBatch} event.
880      *
881      * Requirements:
882      *
883      * - `ids` and `amounts` must have the same length.
884      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
885      * acceptance magic value.
886      */
887     function _mintBatch(
888         address to,
889         uint256[] memory ids,
890         uint256[] memory amounts,
891         bytes memory data
892     ) internal virtual {
893         require(to != address(0), "ERC1155: mint to the zero address");
894         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
895 
896         address operator = _msgSender();
897 
898         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
899 
900         for (uint256 i = 0; i < ids.length; i++) {
901             _balances[ids[i]][to] += amounts[i];
902         }
903 
904         emit TransferBatch(operator, address(0), to, ids, amounts);
905 
906         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
907 
908         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
909     }
910 
911     /**
912      * @dev Destroys `amount` tokens of token type `id` from `from`
913      *
914      * Emits a {TransferSingle} event.
915      *
916      * Requirements:
917      *
918      * - `from` cannot be the zero address.
919      * - `from` must have at least `amount` tokens of token type `id`.
920      */
921     function _burn(
922         address from,
923         uint256 id,
924         uint256 amount
925     ) internal virtual {
926         require(from != address(0), "ERC1155: burn from the zero address");
927 
928         address operator = _msgSender();
929         uint256[] memory ids = _asSingletonArray(id);
930         uint256[] memory amounts = _asSingletonArray(amount);
931 
932         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
933 
934         uint256 fromBalance = _balances[id][from];
935         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
936         unchecked {
937             _balances[id][from] = fromBalance - amount;
938         }
939 
940         emit TransferSingle(operator, from, address(0), id, amount);
941 
942         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
943     }
944 
945     /**
946      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
947      *
948      * Emits a {TransferBatch} event.
949      *
950      * Requirements:
951      *
952      * - `ids` and `amounts` must have the same length.
953      */
954     function _burnBatch(
955         address from,
956         uint256[] memory ids,
957         uint256[] memory amounts
958     ) internal virtual {
959         require(from != address(0), "ERC1155: burn from the zero address");
960         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
961 
962         address operator = _msgSender();
963 
964         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
965 
966         for (uint256 i = 0; i < ids.length; i++) {
967             uint256 id = ids[i];
968             uint256 amount = amounts[i];
969 
970             uint256 fromBalance = _balances[id][from];
971             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
972             unchecked {
973                 _balances[id][from] = fromBalance - amount;
974             }
975         }
976 
977         emit TransferBatch(operator, from, address(0), ids, amounts);
978 
979         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
980     }
981 
982     /**
983      * @dev Approve `operator` to operate on all of `owner` tokens
984      *
985      * Emits an {ApprovalForAll} event.
986      */
987     function _setApprovalForAll(
988         address owner,
989         address operator,
990         bool approved
991     ) internal virtual {
992         require(owner != operator, "ERC1155: setting approval status for self");
993         _operatorApprovals[owner][operator] = approved;
994         emit ApprovalForAll(owner, operator, approved);
995     }
996 
997     /**
998      * @dev Hook that is called before any token transfer. This includes minting
999      * and burning, as well as batched variants.
1000      *
1001      * The same hook is called on both single and batched variants. For single
1002      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1003      *
1004      * Calling conditions (for each `id` and `amount` pair):
1005      *
1006      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1007      * of token type `id` will be  transferred to `to`.
1008      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1009      * for `to`.
1010      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1011      * will be burned.
1012      * - `from` and `to` are never both zero.
1013      * - `ids` and `amounts` have the same, non-zero length.
1014      *
1015      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1016      */
1017     function _beforeTokenTransfer(
1018         address operator,
1019         address from,
1020         address to,
1021         uint256[] memory ids,
1022         uint256[] memory amounts,
1023         bytes memory data
1024     ) internal virtual {}
1025 
1026     /**
1027      * @dev Hook that is called after any token transfer. This includes minting
1028      * and burning, as well as batched variants.
1029      *
1030      * The same hook is called on both single and batched variants. For single
1031      * transfers, the length of the `id` and `amount` arrays will be 1.
1032      *
1033      * Calling conditions (for each `id` and `amount` pair):
1034      *
1035      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1036      * of token type `id` will be  transferred to `to`.
1037      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1038      * for `to`.
1039      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1040      * will be burned.
1041      * - `from` and `to` are never both zero.
1042      * - `ids` and `amounts` have the same, non-zero length.
1043      *
1044      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1045      */
1046     function _afterTokenTransfer(
1047         address operator,
1048         address from,
1049         address to,
1050         uint256[] memory ids,
1051         uint256[] memory amounts,
1052         bytes memory data
1053     ) internal virtual {}
1054 
1055     function _doSafeTransferAcceptanceCheck(
1056         address operator,
1057         address from,
1058         address to,
1059         uint256 id,
1060         uint256 amount,
1061         bytes memory data
1062     ) private {
1063         if (to.isContract()) {
1064             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1065                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1066                     revert("ERC1155: ERC1155Receiver rejected tokens");
1067                 }
1068             } catch Error(string memory reason) {
1069                 revert(reason);
1070             } catch {
1071                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1072             }
1073         }
1074     }
1075 
1076     function _doSafeBatchTransferAcceptanceCheck(
1077         address operator,
1078         address from,
1079         address to,
1080         uint256[] memory ids,
1081         uint256[] memory amounts,
1082         bytes memory data
1083     ) private {
1084         if (to.isContract()) {
1085             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1086                 bytes4 response
1087             ) {
1088                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1089                     revert("ERC1155: ERC1155Receiver rejected tokens");
1090                 }
1091             } catch Error(string memory reason) {
1092                 revert(reason);
1093             } catch {
1094                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1095             }
1096         }
1097     }
1098 
1099     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1100         uint256[] memory array = new uint256[](1);
1101         array[0] = element;
1102 
1103         return array;
1104     }
1105 }
1106 
1107 
1108 /**
1109  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1110  * own tokens and those that they have been approved to use.
1111  *
1112  * _Available since v3.1._
1113  */
1114 abstract contract ERC1155Burnable is ERC1155 {
1115     function burn(
1116         address account,
1117         uint256 id,
1118         uint256 value
1119     ) public virtual {
1120         require(
1121             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1122             "ERC1155: caller is not token owner nor approved"
1123         );
1124 
1125         _burn(account, id, value);
1126     }
1127 
1128     function burnBatch(
1129         address account,
1130         uint256[] memory ids,
1131         uint256[] memory values
1132     ) public virtual {
1133         require(
1134             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1135             "ERC1155: caller is not token owner nor approved"
1136         );
1137 
1138         _burnBatch(account, ids, values);
1139     }
1140 }
1141 
1142 
1143 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1144 
1145 
1146 
1147 /**
1148  * @dev These functions deal with verification of Merkle Tree proofs.
1149  *
1150  * The proofs can be generated using the JavaScript library
1151  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1152  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1153  *
1154  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1155  *
1156  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1157  * hashing, or use a hash function other than keccak256 for hashing leaves.
1158  * This is because the concatenation of a sorted pair of internal nodes in
1159  * the merkle tree could be reinterpreted as a leaf value.
1160  */
1161 library MerkleProof {
1162     /**
1163      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1164      * defined by `root`. For this, a `proof` must be provided, containing
1165      * sibling hashes on the branch from the leaf to the root of the tree. Each
1166      * pair of leaves and each pair of pre-images are assumed to be sorted.
1167      */
1168     function verify(
1169         bytes32[] memory proof,
1170         bytes32 root,
1171         bytes32 leaf
1172     ) internal pure returns (bool) {
1173         return processProof(proof, leaf) == root;
1174     }
1175 
1176     /**
1177      * @dev Calldata version of {verify}
1178      *
1179      * _Available since v4.7._
1180      */
1181     function verifyCalldata(
1182         bytes32[] calldata proof,
1183         bytes32 root,
1184         bytes32 leaf
1185     ) internal pure returns (bool) {
1186         return processProofCalldata(proof, leaf) == root;
1187     }
1188 
1189     /**
1190      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1191      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1192      * hash matches the root of the tree. When processing the proof, the pairs
1193      * of leafs & pre-images are assumed to be sorted.
1194      *
1195      * _Available since v4.4._
1196      */
1197     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1198         bytes32 computedHash = leaf;
1199         for (uint256 i = 0; i < proof.length; i++) {
1200             computedHash = _hashPair(computedHash, proof[i]);
1201         }
1202         return computedHash;
1203     }
1204 
1205     /**
1206      * @dev Calldata version of {processProof}
1207      *
1208      * _Available since v4.7._
1209      */
1210     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1211         bytes32 computedHash = leaf;
1212         for (uint256 i = 0; i < proof.length; i++) {
1213             computedHash = _hashPair(computedHash, proof[i]);
1214         }
1215         return computedHash;
1216     }
1217 
1218     /**
1219      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1220      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1221      *
1222      * _Available since v4.7._
1223      */
1224     function multiProofVerify(
1225         bytes32[] memory proof,
1226         bool[] memory proofFlags,
1227         bytes32 root,
1228         bytes32[] memory leaves
1229     ) internal pure returns (bool) {
1230         return processMultiProof(proof, proofFlags, leaves) == root;
1231     }
1232 
1233     /**
1234      * @dev Calldata version of {multiProofVerify}
1235      *
1236      * _Available since v4.7._
1237      */
1238     function multiProofVerifyCalldata(
1239         bytes32[] calldata proof,
1240         bool[] calldata proofFlags,
1241         bytes32 root,
1242         bytes32[] memory leaves
1243     ) internal pure returns (bool) {
1244         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1245     }
1246 
1247     /**
1248      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1249      * consuming from one or the other at each step according to the instructions given by
1250      * `proofFlags`.
1251      *
1252      * _Available since v4.7._
1253      */
1254     function processMultiProof(
1255         bytes32[] memory proof,
1256         bool[] memory proofFlags,
1257         bytes32[] memory leaves
1258     ) internal pure returns (bytes32 merkleRoot) {
1259         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1260         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1261         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1262         // the merkle tree.
1263         uint256 leavesLen = leaves.length;
1264         uint256 totalHashes = proofFlags.length;
1265 
1266         // Check proof validity.
1267         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1268 
1269         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1270         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1271         bytes32[] memory hashes = new bytes32[](totalHashes);
1272         uint256 leafPos = 0;
1273         uint256 hashPos = 0;
1274         uint256 proofPos = 0;
1275         // At each step, we compute the next hash using two values:
1276         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1277         //   get the next hash.
1278         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1279         //   `proof` array.
1280         for (uint256 i = 0; i < totalHashes; i++) {
1281             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1282             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1283             hashes[i] = _hashPair(a, b);
1284         }
1285 
1286         if (totalHashes > 0) {
1287             return hashes[totalHashes - 1];
1288         } else if (leavesLen > 0) {
1289             return leaves[0];
1290         } else {
1291             return proof[0];
1292         }
1293     }
1294 
1295     /**
1296      * @dev Calldata version of {processMultiProof}
1297      *
1298      * _Available since v4.7._
1299      */
1300     function processMultiProofCalldata(
1301         bytes32[] calldata proof,
1302         bool[] calldata proofFlags,
1303         bytes32[] memory leaves
1304     ) internal pure returns (bytes32 merkleRoot) {
1305         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1306         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1307         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1308         // the merkle tree.
1309         uint256 leavesLen = leaves.length;
1310         uint256 totalHashes = proofFlags.length;
1311 
1312         // Check proof validity.
1313         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1314 
1315         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1316         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1317         bytes32[] memory hashes = new bytes32[](totalHashes);
1318         uint256 leafPos = 0;
1319         uint256 hashPos = 0;
1320         uint256 proofPos = 0;
1321         // At each step, we compute the next hash using two values:
1322         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1323         //   get the next hash.
1324         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1325         //   `proof` array.
1326         for (uint256 i = 0; i < totalHashes; i++) {
1327             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1328             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1329             hashes[i] = _hashPair(a, b);
1330         }
1331 
1332         if (totalHashes > 0) {
1333             return hashes[totalHashes - 1];
1334         } else if (leavesLen > 0) {
1335             return leaves[0];
1336         } else {
1337             return proof[0];
1338         }
1339     }
1340 
1341     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1342         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1343     }
1344 
1345     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1346         /// @solidity memory-safe-assembly
1347         assembly {
1348             mstore(0x00, a)
1349             mstore(0x20, b)
1350             value := keccak256(0x00, 0x40)
1351         }
1352     }
1353 }
1354 
1355 
1356 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1357 
1358 
1359 
1360 
1361 
1362 /**
1363  * @dev Contract module which provides a basic access control mechanism, where
1364  * there is an account (an owner) that can be granted exclusive access to
1365  * specific functions.
1366  *
1367  * By default, the owner account will be the one that deploys the contract. This
1368  * can later be changed with {transferOwnership}.
1369  *
1370  * This module is used through inheritance. It will make available the modifier
1371  * `onlyOwner`, which can be applied to your functions to restrict their use to
1372  * the owner.
1373  */
1374 abstract contract Ownable is Context {
1375     address private _owner;
1376 
1377     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1378 
1379     /**
1380      * @dev Initializes the contract setting the deployer as the initial owner.
1381      */
1382     constructor() {
1383         _transferOwnership(_msgSender());
1384     }
1385 
1386     /**
1387      * @dev Throws if called by any account other than the owner.
1388      */
1389     modifier onlyOwner() {
1390         _checkOwner();
1391         _;
1392     }
1393 
1394     /**
1395      * @dev Returns the address of the current owner.
1396      */
1397     function owner() public view virtual returns (address) {
1398         return _owner;
1399     }
1400 
1401     /**
1402      * @dev Throws if the sender is not the owner.
1403      */
1404     function _checkOwner() internal view virtual {
1405         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1406     }
1407 
1408     /**
1409      * @dev Leaves the contract without owner. It will not be possible to call
1410      * `onlyOwner` functions anymore. Can only be called by the current owner.
1411      *
1412      * NOTE: Renouncing ownership will leave the contract without an owner,
1413      * thereby removing any functionality that is only available to the owner.
1414      */
1415     function renounceOwnership() public virtual onlyOwner {
1416         _transferOwnership(address(0));
1417     }
1418 
1419     /**
1420      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1421      * Can only be called by the current owner.
1422      */
1423     function transferOwnership(address newOwner) public virtual onlyOwner {
1424         require(newOwner != address(0), "Ownable: new owner is the zero address");
1425         _transferOwnership(newOwner);
1426     }
1427 
1428     /**
1429      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1430      * Internal function without access restriction.
1431      */
1432     function _transferOwnership(address newOwner) internal virtual {
1433         address oldOwner = _owner;
1434         _owner = newOwner;
1435         emit OwnershipTransferred(oldOwner, newOwner);
1436     }
1437 }
1438 
1439 
1440 
1441 contract AuraRelockers is ERC1155Burnable, Ownable {
1442     using Strings for uint256;
1443 
1444     /* -------------------------------------------------------------------
1445      Types
1446   ------------------------------------------------------------------- */
1447 
1448     enum Tier {
1449         COMMON,
1450         UNCOMMON,
1451         RARE,
1452         EPIC,
1453         LEGENDARY
1454     }
1455 
1456     /* -------------------------------------------------------------------
1457      Storage
1458   ------------------------------------------------------------------- */
1459 
1460     // Token name
1461     string public name;
1462 
1463     // Token symbol
1464     string public symbol;
1465 
1466     // Mapping from token ID to token supply
1467     mapping(uint256 => uint256) private tokenSupply;
1468 
1469     /// @dev Number used once for pseudo randomness
1470     uint256 public nonce;
1471 
1472     /// @dev Array of valid merkle roots
1473     bytes32[] public roots;
1474 
1475     /// @dev Map address to has claimed (user => rootIdx => claimed)
1476     mapping(address => mapping(uint256 => bool)) public claimedRoot;
1477 
1478     /// @dev Map address to has claimed (user => rootIdx => claimed)
1479     mapping(address => uint256) public userNonce;
1480 
1481     /* -------------------------------------------------------------------
1482      Events
1483   ------------------------------------------------------------------- */
1484 
1485     event RootsUpdated(bytes32 newRoot);
1486 
1487     event BaseUriUpdated(string oldBaseUri, string baseUri);
1488 
1489     event Minted(address user, Tier tier);
1490 
1491     /* -------------------------------------------------------------------
1492      Constructor
1493   ------------------------------------------------------------------- */
1494 
1495     /**
1496      * @param _name    Token name
1497      * @param _symbol  Token symbol
1498      * @param _baseUri Token Base URI
1499      */
1500     constructor(
1501         string memory _name,
1502         string memory _symbol,
1503         string memory _baseUri
1504     ) ERC1155(_baseUri) {
1505         name = _name;
1506         symbol = _symbol;
1507     }
1508 
1509     /* -------------------------------------------------------------------
1510      Setters
1511   ------------------------------------------------------------------- */
1512 
1513     /**
1514      * @dev Add root to roots array
1515      * @param _root Thew new merkle root to add
1516      */
1517     function addRoot(bytes32 _root) external onlyOwner {
1518         roots.push(_root);
1519         emit RootsUpdated(_root);
1520     }
1521 
1522     /**
1523      * @dev Update base URI
1524      * @param _baseUri The base URI
1525      */
1526     function setBaseUri(string memory _baseUri) external onlyOwner {
1527         string memory oldBaseUri = super.uri(0);
1528         _setURI(_baseUri);
1529         emit BaseUriUpdated(oldBaseUri, _baseUri);
1530     }
1531 
1532     /* -------------------------------------------------------------------
1533      Minting
1534   ------------------------------------------------------------------- */
1535 
1536     /**
1537      * @dev Mint token by providing a valid merkle proof
1538      * @param _to         Address to mint to
1539      * @param _proof      Merkle proof
1540      * @param _rootIndex  Index of the root in roots
1541      */
1542     function mint(
1543         address _to,
1544         bytes32[] memory _proof,
1545         uint256 _rootIndex
1546     ) external {
1547         require(userNonce[_to] < 5, "claimed 5");
1548         require(!claimedRoot[_to][_rootIndex], "claimed root");
1549         require(MerkleProof.verify(_proof, roots[_rootIndex], keccak256(abi.encodePacked(_to))), "!proof");
1550 
1551         // Get the next token ID and increment the global ID
1552         // Save the tier for this token ID and mint the token
1553         // to the _to address
1554         nonce += 1;
1555         userNonce[_to] += 1;
1556         claimedRoot[_to][_rootIndex] = true;
1557         Tier tier = _getTier();
1558         _mint(_to, uint256(tier), 1, new bytes(0));
1559 
1560         emit Minted(_to, tier);
1561     }
1562 
1563     /**
1564      * @dev Returns the URI of a token given its ID
1565      * @param id ID of the token to query
1566      * @return uri of the token or an empty string if it does not exist
1567      */
1568     function uri(uint256 id) public view override returns (string memory) {
1569         require(id < 5, "URI query for nonexistent token");
1570 
1571         string memory baseUri = super.uri(0);
1572         return string(abi.encodePacked(baseUri, Strings.toString(id)));
1573     }
1574 
1575     /**
1576      * @dev Returns the URI of the contract information
1577      */
1578     function contractURI() external view returns (string memory) {
1579         // base64-encoded string:
1580         // {
1581         //     "name": "Aura Meditators",
1582         //     "description": "An NFT collection exclusively for re-lockers of Aura.",
1583         //     "image": "ipfs://Qmf9oGfsP2rHJksY515JbzyMQ9h3GXCBrwiC7jCHAuj2Z2",
1584         //     "external_link": "https://aura.finance/",
1585         //     "seller_fee_basis_points": 0
1586         // }
1587         return string(abi.encodePacked("data:application/json;base64,ewoJIm5hbWUiOiAiQXVyYSBNZWRpdGF0b3JzIiwKCSJkZXNjcmlwdGlvbiI6ICJBbiBORlQgY29sbGVjdGlvbiBleGNsdXNpdmVseSBmb3IgcmUtbG9ja2VycyBvZiBBdXJhLiIsCgkiaW1hZ2UiOiAiaXBmczovL1FtZjlvR2ZzUDJySEprc1k1MTVKYnp5TVE5aDNHWENCcndpQzdqQ0hBdWoyWjIiLAoJImV4dGVybmFsX2xpbmsiOiAiaHR0cHM6Ly9hdXJhLmZpbmFuY2UvIiwKCSJzZWxsZXJfZmVlX2Jhc2lzX3BvaW50cyI6IDAKfQ=="));
1588     }
1589 
1590     /**
1591      * @dev Returns the total quantity for a token ID
1592      * @param id ID of the token to query
1593      * @return amount of token in existence
1594      */
1595     function totalSupply(uint256 id) external view returns (uint256) {
1596         return tokenSupply[id];
1597     }
1598 
1599     /* -------------------------------------------------------------------
1600      Internal
1601   ------------------------------------------------------------------- */
1602 
1603     function _getTier() internal view returns (Tier) {
1604         uint256 seed = _pseudoRand() % 199;
1605 
1606         if (seed == 0) {
1607             return Tier.LEGENDARY;
1608         } else if (seed <= 4) {
1609             return Tier.EPIC;
1610         } else if (seed <= 29) {
1611             return Tier.RARE;
1612         } else if (seed <= 89) {
1613             return Tier.UNCOMMON;
1614         } else {
1615             return Tier.COMMON;
1616         }
1617     }
1618 
1619     function _pseudoRand() internal view returns (uint256) {
1620         return
1621             uint256(
1622                 keccak256(
1623                     abi.encodePacked(
1624                         block.timestamp +
1625                             block.difficulty +
1626                             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
1627                             block.gaslimit +
1628                             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
1629                             block.number,
1630                         nonce
1631                     )
1632                 )
1633             );
1634     }
1635 
1636     function _beforeTokenTransfer(
1637         address, /* operator */
1638         address from,
1639         address to,
1640         uint256[] memory, /* ids */
1641         uint256[] memory, /* amounts */
1642         bytes memory /* data */
1643     ) internal pure override {
1644         // Allowed to mint and burn but all other transfers are
1645         // not allowed
1646         require(from == address(0) || to == address(0), "!transferable");
1647     }
1648 
1649     /**
1650      * @dev Internal override function for minting an NFT
1651      */
1652     function _mint(
1653         address account,
1654         uint256 id,
1655         uint256 amount,
1656         bytes memory data
1657     ) internal override {
1658         super._mint(account, id, amount, data);
1659 
1660         tokenSupply[id] += amount;
1661     }
1662 
1663     /**
1664      * @dev Internal override function for burning an NFT
1665      */
1666     function _burn(
1667         address account,
1668         uint256 id,
1669         uint256 amount
1670     ) internal override {
1671         super._burn(account, id, amount);
1672 
1673         tokenSupply[id] -= amount;
1674     }
1675 }