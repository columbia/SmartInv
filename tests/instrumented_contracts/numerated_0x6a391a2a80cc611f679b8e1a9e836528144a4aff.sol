1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.9;
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
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
75 
76 pragma solidity ^0.8.9;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize, which returns 0 for contracts in
101         // construction, since the code is only stored at the end of the
102         // constructor execution.
103 
104         uint256 size;
105         assembly {
106             size := extcodesize(account)
107         }
108         return size > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
295 
296 pragma solidity ^0.8.9;
297 
298 /**
299  * @dev Interface of the ERC165 standard, as defined in the
300  * https://eips.ethereum.org/EIPS/eip-165[EIP].
301  *
302  * Implementers can declare support of contract interfaces, which can then be
303  * queried by others ({ERC165Checker}).
304  *
305  * For an implementation, see {ERC165}.
306  */
307 interface IERC165 {
308     /**
309      * @dev Returns true if this contract implements the interface defined by
310      * `interfaceId`. See the corresponding
311      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
312      * to learn more about how these ids are created.
313      *
314      * This function call must use less than 30 000 gas.
315      */
316     function supportsInterface(bytes4 interfaceId) external view returns (bool);
317 }
318 
319 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
320 
321 
322 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
323 
324 pragma solidity ^0.8.9;
325 
326 
327 /**
328  * @dev Implementation of the {IERC165} interface.
329  *
330  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
331  * for the additional interface id that will be supported. For example:
332  *
333  * ```solidity
334  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
335  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
336  * }
337  * ```
338  *
339  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
340  */
341 abstract contract ERC165 is IERC165 {
342     /**
343      * @dev See {IERC165-supportsInterface}.
344      */
345     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
346         return interfaceId == type(IERC165).interfaceId;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
354 
355 pragma solidity ^0.8.9;
356 
357 
358 /**
359  * @dev _Available since v3.1._
360  */
361 interface IERC1155Receiver is IERC165 {
362     /**
363         @dev Handles the receipt of a single ERC1155 token type. This function is
364         called at the end of a `safeTransferFrom` after the balance has been updated.
365         To accept the transfer, this must return
366         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
367         (i.e. 0xf23a6e61, or its own function selector).
368         @param operator The address which initiated the transfer (i.e. msg.sender)
369         @param from The address which previously owned the token
370         @param id The ID of the token being transferred
371         @param value The amount of tokens being transferred
372         @param data Additional data with no specified format
373         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
374     */
375     function onERC1155Received(
376         address operator,
377         address from,
378         uint256 id,
379         uint256 value,
380         bytes calldata data
381     ) external returns (bytes4);
382 
383     /**
384         @dev Handles the receipt of a multiple ERC1155 token types. This function
385         is called at the end of a `safeBatchTransferFrom` after the balances have
386         been updated. To accept the transfer(s), this must return
387         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
388         (i.e. 0xbc197c81, or its own function selector).
389         @param operator The address which initiated the batch transfer (i.e. msg.sender)
390         @param from The address which previously owned the token
391         @param ids An array containing ids of each token being transferred (order and length must match values array)
392         @param values An array containing amounts of each token being transferred (order and length must match ids array)
393         @param data Additional data with no specified format
394         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
395     */
396     function onERC1155BatchReceived(
397         address operator,
398         address from,
399         uint256[] calldata ids,
400         uint256[] calldata values,
401         bytes calldata data
402     ) external returns (bytes4);
403 }
404 
405 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
409 
410 pragma solidity ^0.8.9;
411 
412 
413 /**
414  * @dev Required interface of an ERC1155 compliant contract, as defined in the
415  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
416  *
417  * _Available since v3.1._
418  */
419 interface IERC1155 is IERC165 {
420     /**
421      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
422      */
423     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
424 
425     /**
426      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
427      * transfers.
428      */
429     event TransferBatch(
430         address indexed operator,
431         address indexed from,
432         address indexed to,
433         uint256[] ids,
434         uint256[] values
435     );
436 
437     /**
438      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
439      * `approved`.
440      */
441     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
442 
443     /**
444      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
445      *
446      * If an {URI} event was emitted for `id`, the standard
447      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
448      * returned by {IERC1155MetadataURI-uri}.
449      */
450     event URI(string value, uint256 indexed id);
451 
452     /**
453      * @dev Returns the amount of tokens of token type `id` owned by `account`.
454      *
455      * Requirements:
456      *
457      * - `account` cannot be the zero address.
458      */
459     function balanceOf(address account, uint256 id) external view returns (uint256);
460 
461     /**
462      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
463      *
464      * Requirements:
465      *
466      * - `accounts` and `ids` must have the same length.
467      */
468     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
469         external
470         view
471         returns (uint256[] memory);
472 
473     /**
474      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
475      *
476      * Emits an {ApprovalForAll} event.
477      *
478      * Requirements:
479      *
480      * - `operator` cannot be the caller.
481      */
482     function setApprovalForAll(address operator, bool approved) external;
483 
484     /**
485      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
486      *
487      * See {setApprovalForAll}.
488      */
489     function isApprovedForAll(address account, address operator) external view returns (bool);
490 
491     /**
492      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
493      *
494      * Emits a {TransferSingle} event.
495      *
496      * Requirements:
497      *
498      * - `to` cannot be the zero address.
499      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
500      * - `from` must have a balance of tokens of type `id` of at least `amount`.
501      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
502      * acceptance magic value.
503      */
504     function safeTransferFrom(
505         address from,
506         address to,
507         uint256 id,
508         uint256 amount,
509         bytes calldata data
510     ) external;
511 
512     /**
513      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
514      *
515      * Emits a {TransferBatch} event.
516      *
517      * Requirements:
518      *
519      * - `ids` and `amounts` must have the same length.
520      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
521      * acceptance magic value.
522      */
523     function safeBatchTransferFrom(
524         address from,
525         address to,
526         uint256[] calldata ids,
527         uint256[] calldata amounts,
528         bytes calldata data
529     ) external;
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
536 
537 pragma solidity ^0.8.9;
538 
539 
540 /**
541  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
542  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
543  *
544  * _Available since v3.1._
545  */
546 interface IERC1155MetadataURI is IERC1155 {
547     /**
548      * @dev Returns the URI for token type `id`.
549      *
550      * If the `\{id\}` substring is present in the URI, it must be replaced by
551      * clients with the actual token type ID.
552      */
553     function uri(uint256 id) external view returns (string memory);
554 }
555 
556 // File: @openzeppelin/contracts/utils/Context.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
560 
561 pragma solidity ^0.8.9;
562 
563 /**
564  * @dev Provides information about the current execution context, including the
565  * sender of the transaction and its data. While these are generally available
566  * via msg.sender and msg.data, they should not be accessed in such a direct
567  * manner, since when dealing with meta-transactions the account sending and
568  * paying for execution may not be the actual sender (as far as an application
569  * is concerned).
570  *
571  * This contract is only required for intermediate, library-like contracts.
572  */
573 abstract contract Context {
574     function _msgSender() internal view virtual returns (address) {
575         return msg.sender;
576     }
577 
578     function _msgData() internal view virtual returns (bytes calldata) {
579         return msg.data;
580     }
581 }
582 
583 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
587 
588 pragma solidity ^0.8.9;
589 
590 
591 
592 
593 
594 
595 
596 /**
597  * @dev Implementation of the basic standard multi-token.
598  * See https://eips.ethereum.org/EIPS/eip-1155
599  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
600  *
601  * _Available since v3.1._
602  */
603 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
604     using Address for address;
605 
606     // Mapping from token ID to account balances
607     mapping(uint256 => mapping(address => uint256)) private _balances;
608 
609     // Mapping from account to operator approvals
610     mapping(address => mapping(address => bool)) private _operatorApprovals;
611 
612     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
613     string private _uri;
614 
615     /**
616      * @dev See {_setURI}.
617      */
618     constructor(string memory uri_) {
619         _setURI(uri_);
620     }
621 
622     /**
623      * @dev See {IERC165-supportsInterface}.
624      */
625     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
626         return
627             interfaceId == type(IERC1155).interfaceId ||
628             interfaceId == type(IERC1155MetadataURI).interfaceId ||
629             super.supportsInterface(interfaceId);
630     }
631 
632     /**
633      * @dev See {IERC1155MetadataURI-uri}.
634      *
635      * This implementation returns the same URI for *all* token types. It relies
636      * on the token type ID substitution mechanism
637      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
638      *
639      * Clients calling this function must replace the `\{id\}` substring with the
640      * actual token type ID.
641      */
642     function uri(uint256) public view virtual override returns (string memory) {
643         return _uri;
644     }
645 
646     /**
647      * @dev See {IERC1155-balanceOf}.
648      *
649      * Requirements:
650      *
651      * - `account` cannot be the zero address.
652      */
653     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
654         require(account != address(0), "ERC1155: balance query for the zero address");
655         return _balances[id][account];
656     }
657 
658     /**
659      * @dev See {IERC1155-balanceOfBatch}.
660      *
661      * Requirements:
662      *
663      * - `accounts` and `ids` must have the same length.
664      */
665     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
666         public
667         view
668         virtual
669         override
670         returns (uint256[] memory)
671     {
672         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
673 
674         uint256[] memory batchBalances = new uint256[](accounts.length);
675 
676         for (uint256 i = 0; i < accounts.length; ++i) {
677             batchBalances[i] = balanceOf(accounts[i], ids[i]);
678         }
679 
680         return batchBalances;
681     }
682 
683     /**
684      * @dev See {IERC1155-setApprovalForAll}.
685      */
686     function setApprovalForAll(address operator, bool approved) public virtual override {
687         _setApprovalForAll(_msgSender(), operator, approved);
688     }
689 
690     /**
691      * @dev See {IERC1155-isApprovedForAll}.
692      */
693     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
694         return _operatorApprovals[account][operator];
695     }
696 
697     /**
698      * @dev See {IERC1155-safeTransferFrom}.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 id,
704         uint256 amount,
705         bytes memory data
706     ) public virtual override {
707         require(
708             from == _msgSender() || isApprovedForAll(from, _msgSender()),
709             "ERC1155: caller is not owner nor approved"
710         );
711         _safeTransferFrom(from, to, id, amount, data);
712     }
713 
714     /**
715      * @dev See {IERC1155-safeBatchTransferFrom}.
716      */
717     function safeBatchTransferFrom(
718         address from,
719         address to,
720         uint256[] memory ids,
721         uint256[] memory amounts,
722         bytes memory data
723     ) public virtual override {
724         require(
725             from == _msgSender() || isApprovedForAll(from, _msgSender()),
726             "ERC1155: transfer caller is not owner nor approved"
727         );
728         _safeBatchTransferFrom(from, to, ids, amounts, data);
729     }
730 
731     /**
732      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
733      *
734      * Emits a {TransferSingle} event.
735      *
736      * Requirements:
737      *
738      * - `to` cannot be the zero address.
739      * - `from` must have a balance of tokens of type `id` of at least `amount`.
740      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
741      * acceptance magic value.
742      */
743     function _safeTransferFrom(
744         address from,
745         address to,
746         uint256 id,
747         uint256 amount,
748         bytes memory data
749     ) internal virtual {
750         require(to != address(0), "ERC1155: transfer to the zero address");
751 
752         address operator = _msgSender();
753 
754         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
755 
756         uint256 fromBalance = _balances[id][from];
757         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
758         unchecked {
759             _balances[id][from] = fromBalance - amount;
760         }
761         _balances[id][to] += amount;
762 
763         emit TransferSingle(operator, from, to, id, amount);
764 
765         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
766     }
767 
768     /**
769      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
770      *
771      * Emits a {TransferBatch} event.
772      *
773      * Requirements:
774      *
775      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
776      * acceptance magic value.
777      */
778     function _safeBatchTransferFrom(
779         address from,
780         address to,
781         uint256[] memory ids,
782         uint256[] memory amounts,
783         bytes memory data
784     ) internal virtual {
785         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
786         require(to != address(0), "ERC1155: transfer to the zero address");
787 
788         address operator = _msgSender();
789 
790         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
791 
792         for (uint256 i = 0; i < ids.length; ++i) {
793             uint256 id = ids[i];
794             uint256 amount = amounts[i];
795 
796             uint256 fromBalance = _balances[id][from];
797             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
798             unchecked {
799                 _balances[id][from] = fromBalance - amount;
800             }
801             _balances[id][to] += amount;
802         }
803 
804         emit TransferBatch(operator, from, to, ids, amounts);
805 
806         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
807     }
808 
809     /**
810      * @dev Sets a new URI for all token types, by relying on the token type ID
811      * substitution mechanism
812      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
813      *
814      * By this mechanism, any occurrence of the `\{id\}` substring in either the
815      * URI or any of the amounts in the JSON file at said URI will be replaced by
816      * clients with the token type ID.
817      *
818      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
819      * interpreted by clients as
820      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
821      * for token type ID 0x4cce0.
822      *
823      * See {uri}.
824      *
825      * Because these URIs cannot be meaningfully represented by the {URI} event,
826      * this function emits no events.
827      */
828     function _setURI(string memory newuri) internal virtual {
829         _uri = newuri;
830     }
831 
832     /**
833      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
834      *
835      * Emits a {TransferSingle} event.
836      *
837      * Requirements:
838      *
839      * - `to` cannot be the zero address.
840      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
841      * acceptance magic value.
842      */
843     function _mint(
844         address to,
845         uint256 id,
846         uint256 amount,
847         bytes memory data
848     ) internal virtual {
849         require(to != address(0), "ERC1155: mint to the zero address");
850 
851         address operator = _msgSender();
852 
853         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
854 
855         _balances[id][to] += amount;
856         emit TransferSingle(operator, address(0), to, id, amount);
857 
858         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
859     }
860 
861     /**
862      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
863      *
864      * Requirements:
865      *
866      * - `ids` and `amounts` must have the same length.
867      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
868      * acceptance magic value.
869      */
870     function _mintBatch(
871         address to,
872         uint256[] memory ids,
873         uint256[] memory amounts,
874         bytes memory data
875     ) internal virtual {
876         require(to != address(0), "ERC1155: mint to the zero address");
877         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
878 
879         address operator = _msgSender();
880 
881         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
882 
883         for (uint256 i = 0; i < ids.length; i++) {
884             _balances[ids[i]][to] += amounts[i];
885         }
886 
887         emit TransferBatch(operator, address(0), to, ids, amounts);
888 
889         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
890     }
891 
892     /**
893      * @dev Destroys `amount` tokens of token type `id` from `from`
894      *
895      * Requirements:
896      *
897      * - `from` cannot be the zero address.
898      * - `from` must have at least `amount` tokens of token type `id`.
899      */
900     function _burn(
901         address from,
902         uint256 id,
903         uint256 amount
904     ) internal virtual {
905         require(from != address(0), "ERC1155: burn from the zero address");
906 
907         address operator = _msgSender();
908 
909         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
910 
911         uint256 fromBalance = _balances[id][from];
912         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
913         unchecked {
914             _balances[id][from] = fromBalance - amount;
915         }
916 
917         emit TransferSingle(operator, from, address(0), id, amount);
918     }
919 
920     /**
921      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
922      *
923      * Requirements:
924      *
925      * - `ids` and `amounts` must have the same length.
926      */
927     function _burnBatch(
928         address from,
929         uint256[] memory ids,
930         uint256[] memory amounts
931     ) internal virtual {
932         require(from != address(0), "ERC1155: burn from the zero address");
933         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
934 
935         address operator = _msgSender();
936 
937         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
938 
939         for (uint256 i = 0; i < ids.length; i++) {
940             uint256 id = ids[i];
941             uint256 amount = amounts[i];
942 
943             uint256 fromBalance = _balances[id][from];
944             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
945             unchecked {
946                 _balances[id][from] = fromBalance - amount;
947             }
948         }
949 
950         emit TransferBatch(operator, from, address(0), ids, amounts);
951     }
952 
953     /**
954      * @dev Approve `operator` to operate on all of `owner` tokens
955      *
956      * Emits a {ApprovalForAll} event.
957      */
958     function _setApprovalForAll(
959         address owner,
960         address operator,
961         bool approved
962     ) internal virtual {
963         require(owner != operator, "ERC1155: setting approval status for self");
964         _operatorApprovals[owner][operator] = approved;
965         emit ApprovalForAll(owner, operator, approved);
966     }
967 
968     /**
969      * @dev Hook that is called before any token transfer. This includes minting
970      * and burning, as well as batched variants.
971      *
972      * The same hook is called on both single and batched variants. For single
973      * transfers, the length of the `id` and `amount` arrays will be 1.
974      *
975      * Calling conditions (for each `id` and `amount` pair):
976      *
977      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
978      * of token type `id` will be  transferred to `to`.
979      * - When `from` is zero, `amount` tokens of token type `id` will be minted
980      * for `to`.
981      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
982      * will be burned.
983      * - `from` and `to` are never both zero.
984      * - `ids` and `amounts` have the same, non-zero length.
985      *
986      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
987      */
988     function _beforeTokenTransfer(
989         address operator,
990         address from,
991         address to,
992         uint256[] memory ids,
993         uint256[] memory amounts,
994         bytes memory data
995     ) internal virtual {}
996 
997     function _doSafeTransferAcceptanceCheck(
998         address operator,
999         address from,
1000         address to,
1001         uint256 id,
1002         uint256 amount,
1003         bytes memory data
1004     ) private {
1005         if (to.isContract()) {
1006             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1007                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1008                     revert("ERC1155: ERC1155Receiver rejected tokens");
1009                 }
1010             } catch Error(string memory reason) {
1011                 revert(reason);
1012             } catch {
1013                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1014             }
1015         }
1016     }
1017 
1018     function _doSafeBatchTransferAcceptanceCheck(
1019         address operator,
1020         address from,
1021         address to,
1022         uint256[] memory ids,
1023         uint256[] memory amounts,
1024         bytes memory data
1025     ) private {
1026         if (to.isContract()) {
1027             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1028                 bytes4 response
1029             ) {
1030                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1031                     revert("ERC1155: ERC1155Receiver rejected tokens");
1032                 }
1033             } catch Error(string memory reason) {
1034                 revert(reason);
1035             } catch {
1036                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1037             }
1038         }
1039     }
1040 
1041     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1042         uint256[] memory array = new uint256[](1);
1043         array[0] = element;
1044 
1045         return array;
1046     }
1047 }
1048 
1049 // File: @openzeppelin/contracts/security/Pausable.sol
1050 
1051 
1052 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1053 
1054 pragma solidity ^0.8.9;
1055 
1056 
1057 /**
1058  * @dev Contract module which allows children to implement an emergency stop
1059  * mechanism that can be triggered by an authorized account.
1060  *
1061  * This module is used through inheritance. It will make available the
1062  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1063  * the functions of your contract. Note that they will not be pausable by
1064  * simply including this module, only once the modifiers are put in place.
1065  */
1066 abstract contract Pausable is Context {
1067     /**
1068      * @dev Emitted when the pause is triggered by `account`.
1069      */
1070     event Paused(address account);
1071 
1072     /**
1073      * @dev Emitted when the pause is lifted by `account`.
1074      */
1075     event Unpaused(address account);
1076 
1077     bool private _paused;
1078 
1079     /**
1080      * @dev Initializes the contract in unpaused state.
1081      */
1082     constructor() {
1083         _paused = false;
1084     }
1085 
1086     /**
1087      * @dev Returns true if the contract is paused, and false otherwise.
1088      */
1089     function paused() public view virtual returns (bool) {
1090         return _paused;
1091     }
1092 
1093     /**
1094      * @dev Modifier to make a function callable only when the contract is not paused.
1095      *
1096      * Requirements:
1097      *
1098      * - The contract must not be paused.
1099      */
1100     modifier whenNotPaused() {
1101         require(!paused(), "Pausable: paused");
1102         _;
1103     }
1104 
1105     /**
1106      * @dev Modifier to make a function callable only when the contract is paused.
1107      *
1108      * Requirements:
1109      *
1110      * - The contract must be paused.
1111      */
1112     modifier whenPaused() {
1113         require(paused(), "Pausable: not paused");
1114         _;
1115     }
1116 
1117     /**
1118      * @dev Triggers stopped state.
1119      *
1120      * Requirements:
1121      *
1122      * - The contract must not be paused.
1123      */
1124     function _pause() internal virtual whenNotPaused {
1125         _paused = true;
1126         emit Paused(_msgSender());
1127     }
1128 
1129     /**
1130      * @dev Returns to normal state.
1131      *
1132      * Requirements:
1133      *
1134      * - The contract must be paused.
1135      */
1136     function _unpause() internal virtual whenPaused {
1137         _paused = false;
1138         emit Unpaused(_msgSender());
1139     }
1140 }
1141 
1142 // File: @openzeppelin/contracts/access/Ownable.sol
1143 
1144 
1145 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1146 
1147 pragma solidity ^0.8.9;
1148 
1149 
1150 /**
1151  * @dev Contract module which provides a basic access control mechanism, where
1152  * there is an account (an owner) that can be granted exclusive access to
1153  * specific functions.
1154  *
1155  * By default, the owner account will be the one that deploys the contract. This
1156  * can later be changed with {transferOwnership}.
1157  *
1158  * This module is used through inheritance. It will make available the modifier
1159  * `onlyOwner`, which can be applied to your functions to restrict their use to
1160  * the owner.
1161  */
1162 abstract contract Ownable is Context {
1163     address private _owner;
1164 
1165     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1166 
1167     /**
1168      * @dev Initializes the contract setting the deployer as the initial owner.
1169      */
1170     constructor() {
1171         _transferOwnership(_msgSender());
1172     }
1173 
1174     /**
1175      * @dev Returns the address of the current owner.
1176      */
1177     function owner() public view virtual returns (address) {
1178         return _owner;
1179     }
1180 
1181     /**
1182      * @dev Throws if called by any account other than the owner.
1183      */
1184     modifier onlyOwner() {
1185         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1186         _;
1187     }
1188 
1189     /**
1190      * @dev Leaves the contract without owner. It will not be possible to call
1191      * `onlyOwner` functions anymore. Can only be called by the current owner.
1192      *
1193      * NOTE: Renouncing ownership will leave the contract without an owner,
1194      * thereby removing any functionality that is only available to the owner.
1195      */
1196     function renounceOwnership() public virtual onlyOwner {
1197         _transferOwnership(address(0));
1198     }
1199 
1200     /**
1201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1202      * Can only be called by the current owner.
1203      */
1204     function transferOwnership(address newOwner) public virtual onlyOwner {
1205         require(newOwner != address(0), "Ownable: new owner is the zero address");
1206         _transferOwnership(newOwner);
1207     }
1208 
1209     /**
1210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1211      * Internal function without access restriction.
1212      */
1213     function _transferOwnership(address newOwner) internal virtual {
1214         address oldOwner = _owner;
1215         _owner = newOwner;
1216         emit OwnershipTransferred(oldOwner, newOwner);
1217     }
1218 }
1219 
1220 // File: contracts/DickDoods.sol
1221 
1222 // SPDX-License-Identifier: MIT
1223 pragma solidity ^0.8.9;
1224 
1225 
1226 
1227 
1228 
1229 contract DickDoods is ERC1155, Ownable, Pausable {
1230     uint private constant MAX_SUPPLY = 6969;
1231     uint private constant MAX_PER_TX = 20;
1232     
1233     // Metadata
1234     uint private counter;
1235 
1236     // Price
1237     uint256 public price = 0.03 ether;
1238 
1239     constructor (
1240         string memory _tokenURI
1241     ) ERC1155(_tokenURI) {
1242         counter = 0;
1243     }
1244 
1245     function setPause(bool pause) external onlyOwner {
1246         if(pause) {
1247             _pause();
1248         } else {
1249             _unpause();
1250         }
1251     }
1252 
1253     function totalSupply() external view returns (uint) {
1254         return counter;
1255     }
1256 
1257     function mint(uint amount) external payable whenNotPaused {
1258         require(amount < MAX_PER_TX + 1, "amount can't exceed 20");
1259         require(amount > 0, "amount too little");
1260         require(counter + amount < MAX_SUPPLY, "no more left to mint");
1261 
1262         if (msg.sender != owner()) {
1263             require(msg.value >= price * amount, "insufficient funds");
1264         }
1265 
1266         mintBatch(msg.sender, amount);
1267     }
1268 
1269     function mintBatch(address to, uint amount) private {
1270         uint256[] memory ids = new uint256[](amount);
1271         uint256[] memory amounts = new uint256[](amount);
1272         uint c = 0;
1273         for(uint i = counter; i < counter + amount; i++) {
1274             ids[c] = i+1; // token starts from 1
1275             amounts[c] = 1;
1276             c++;
1277         }
1278         counter += amount;
1279         _mintBatch(to, ids, amounts, "");
1280     }
1281 
1282     function airdrop(address[] calldata target, uint[] calldata amount) external onlyOwner {
1283         require(target.length > 0, "no target");
1284         require(amount.length > 0, "no amount");
1285         require(target.length == amount.length, "amount and target mismatch");
1286         uint totalAmount = 0;
1287         for(uint i; i < amount.length; i++){
1288             totalAmount += amount[i];
1289         }
1290         require(counter + totalAmount < MAX_SUPPLY, "no more left to mint");
1291         for(uint i; i < target.length; i++) {
1292             mintBatch(target[i], amount[i]);
1293         }
1294     }
1295 
1296     // Minting fee
1297     function setPrice(uint amount) external onlyOwner {
1298         price = amount;
1299     }
1300 
1301     // Metadata
1302     function setTokenURI(string calldata _uri) external onlyOwner {
1303         _setURI(_uri);
1304     }
1305 
1306     function uri(uint256 _tokenId) public view virtual override returns (string memory) {
1307         require(counter >= _tokenId, "URI query for nonexistent token");
1308 
1309         return string(abi.encodePacked(
1310             super.uri(_tokenId),
1311             "/",
1312             Strings.toString(_tokenId),
1313             ".json"
1314         ));
1315     }
1316 
1317     function withdraw() public payable onlyOwner {
1318         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1319         require(os);
1320     }
1321 }