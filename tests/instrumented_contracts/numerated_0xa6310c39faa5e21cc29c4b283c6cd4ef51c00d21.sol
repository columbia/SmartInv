1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts@4.3.1/utils/Address.sol
5 
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      */
31     function isContract(address account) internal view returns (bool) {
32         // This method relies on extcodesize, which returns 0 for contracts in
33         // construction, since the code is only stored at the end of the
34         // constructor execution.
35 
36         uint256 size;
37         assembly {
38             size := extcodesize(account)
39         }
40         return size > 0;
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(address(this).balance >= amount, "Address: insufficient balance");
61 
62         (bool success, ) = recipient.call{value: amount}("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65 
66     /**
67      * @dev Performs a Solidity function call using a low level `call`. A
68      * plain `call` is an unsafe replacement for a function call: use this
69      * function instead.
70      *
71      * If `target` reverts with a revert reason, it is bubbled up by this
72      * function (like regular Solidity function calls).
73      *
74      * Returns the raw returned data. To convert to the expected return value,
75      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
76      *
77      * Requirements:
78      *
79      * - `target` must be a contract.
80      * - calling `target` with `data` must not revert.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
85         return functionCall(target, data, "Address: low-level call failed");
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
90      * `errorMessage` as a fallback revert reason when `target` reverts.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(
95         address target,
96         bytes memory data,
97         string memory errorMessage
98     ) internal returns (bytes memory) {
99         return functionCallWithValue(target, data, 0, errorMessage);
100     }
101 
102     /**
103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
104      * but also transferring `value` wei to `target`.
105      *
106      * Requirements:
107      *
108      * - the calling contract must have an ETH balance of at least `value`.
109      * - the called Solidity function must be `payable`.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(
114         address target,
115         bytes memory data,
116         uint256 value
117     ) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
123      * with `errorMessage` as a fallback revert reason when `target` reverts.
124      *
125      * _Available since v3.1._
126      */
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         require(address(this).balance >= value, "Address: insufficient balance for call");
134         require(isContract(target), "Address: call to non-contract");
135 
136         (bool success, bytes memory returndata) = target.call{value: value}(data);
137         return verifyCallResult(success, returndata, errorMessage);
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
142      * but performing a static call.
143      *
144      * _Available since v3.3._
145      */
146     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
147         return functionStaticCall(target, data, "Address: low-level static call failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
152      * but performing a static call.
153      *
154      * _Available since v3.3._
155      */
156     function functionStaticCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal view returns (bytes memory) {
161         require(isContract(target), "Address: static call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a delegate call.
170      *
171      * _Available since v3.4._
172      */
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         require(isContract(target), "Address: delegate call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.delegatecall(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
196      * revert reason using the provided one.
197      *
198      * _Available since v4.3._
199      */
200     function verifyCallResult(
201         bool success,
202         bytes memory returndata,
203         string memory errorMessage
204     ) internal pure returns (bytes memory) {
205         if (success) {
206             return returndata;
207         } else {
208             // Look for revert reason and bubble it up if present
209             if (returndata.length > 0) {
210                 // The easiest way to bubble the revert reason is using memory via assembly
211 
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {
217                 revert(errorMessage);
218             }
219         }
220     }
221 }
222 
223 // File: @openzeppelin/contracts@4.3.1/utils/introspection/IERC165.sol
224 
225 
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Interface of the ERC165 standard, as defined in the
231  * https://eips.ethereum.org/EIPS/eip-165[EIP].
232  *
233  * Implementers can declare support of contract interfaces, which can then be
234  * queried by others ({ERC165Checker}).
235  *
236  * For an implementation, see {ERC165}.
237  */
238 interface IERC165 {
239     /**
240      * @dev Returns true if this contract implements the interface defined by
241      * `interfaceId`. See the corresponding
242      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
243      * to learn more about how these ids are created.
244      *
245      * This function call must use less than 30 000 gas.
246      */
247     function supportsInterface(bytes4 interfaceId) external view returns (bool);
248 }
249 
250 // File: @openzeppelin/contracts@4.3.1/utils/introspection/ERC165.sol
251 
252 
253 
254 pragma solidity ^0.8.0;
255 
256 
257 /**
258  * @dev Implementation of the {IERC165} interface.
259  *
260  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
261  * for the additional interface id that will be supported. For example:
262  *
263  * ```solidity
264  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
265  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
266  * }
267  * ```
268  *
269  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
270  */
271 abstract contract ERC165 is IERC165 {
272     /**
273      * @dev See {IERC165-supportsInterface}.
274      */
275     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
276         return interfaceId == type(IERC165).interfaceId;
277     }
278 }
279 
280 // File: @openzeppelin/contracts@4.3.1/token/ERC1155/IERC1155Receiver.sol
281 
282 
283 
284 pragma solidity ^0.8.0;
285 
286 
287 /**
288  * @dev _Available since v3.1._
289  */
290 interface IERC1155Receiver is IERC165 {
291     /**
292         @dev Handles the receipt of a single ERC1155 token type. This function is
293         called at the end of a `safeTransferFrom` after the balance has been updated.
294         To accept the transfer, this must return
295         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
296         (i.e. 0xf23a6e61, or its own function selector).
297         @param operator The address which initiated the transfer (i.e. msg.sender)
298         @param from The address which previously owned the token
299         @param id The ID of the token being transferred
300         @param value The amount of tokens being transferred
301         @param data Additional data with no specified format
302         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
303     */
304     function onERC1155Received(
305         address operator,
306         address from,
307         uint256 id,
308         uint256 value,
309         bytes calldata data
310     ) external returns (bytes4);
311 
312     /**
313         @dev Handles the receipt of a multiple ERC1155 token types. This function
314         is called at the end of a `safeBatchTransferFrom` after the balances have
315         been updated. To accept the transfer(s), this must return
316         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
317         (i.e. 0xbc197c81, or its own function selector).
318         @param operator The address which initiated the batch transfer (i.e. msg.sender)
319         @param from The address which previously owned the token
320         @param ids An array containing ids of each token being transferred (order and length must match values array)
321         @param values An array containing amounts of each token being transferred (order and length must match ids array)
322         @param data Additional data with no specified format
323         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
324     */
325     function onERC1155BatchReceived(
326         address operator,
327         address from,
328         uint256[] calldata ids,
329         uint256[] calldata values,
330         bytes calldata data
331     ) external returns (bytes4);
332 }
333 
334 // File: @openzeppelin/contracts@4.3.1/token/ERC1155/IERC1155.sol
335 
336 
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Required interface of an ERC1155 compliant contract, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
344  *
345  * _Available since v3.1._
346  */
347 interface IERC1155 is IERC165 {
348     /**
349      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
350      */
351     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
352 
353     /**
354      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
355      * transfers.
356      */
357     event TransferBatch(
358         address indexed operator,
359         address indexed from,
360         address indexed to,
361         uint256[] ids,
362         uint256[] values
363     );
364 
365     /**
366      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
367      * `approved`.
368      */
369     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
370 
371     /**
372      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
373      *
374      * If an {URI} event was emitted for `id`, the standard
375      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
376      * returned by {IERC1155MetadataURI-uri}.
377      */
378     event URI(string value, uint256 indexed id);
379 
380     /**
381      * @dev Returns the amount of tokens of token type `id` owned by `account`.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      */
387     function balanceOf(address account, uint256 id) external view returns (uint256);
388 
389     /**
390      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
391      *
392      * Requirements:
393      *
394      * - `accounts` and `ids` must have the same length.
395      */
396     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
397         external
398         view
399         returns (uint256[] memory);
400 
401     /**
402      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
403      *
404      * Emits an {ApprovalForAll} event.
405      *
406      * Requirements:
407      *
408      * - `operator` cannot be the caller.
409      */
410     function setApprovalForAll(address operator, bool approved) external;
411 
412     /**
413      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
414      *
415      * See {setApprovalForAll}.
416      */
417     function isApprovedForAll(address account, address operator) external view returns (bool);
418 
419     /**
420      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
421      *
422      * Emits a {TransferSingle} event.
423      *
424      * Requirements:
425      *
426      * - `to` cannot be the zero address.
427      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
428      * - `from` must have a balance of tokens of type `id` of at least `amount`.
429      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
430      * acceptance magic value.
431      */
432     function safeTransferFrom(
433         address from,
434         address to,
435         uint256 id,
436         uint256 amount,
437         bytes calldata data
438     ) external;
439 
440     /**
441      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
442      *
443      * Emits a {TransferBatch} event.
444      *
445      * Requirements:
446      *
447      * - `ids` and `amounts` must have the same length.
448      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
449      * acceptance magic value.
450      */
451     function safeBatchTransferFrom(
452         address from,
453         address to,
454         uint256[] calldata ids,
455         uint256[] calldata amounts,
456         bytes calldata data
457     ) external;
458 }
459 
460 // File: @openzeppelin/contracts@4.3.1/token/ERC1155/extensions/IERC1155MetadataURI.sol
461 
462 
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
469  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
470  *
471  * _Available since v3.1._
472  */
473 interface IERC1155MetadataURI is IERC1155 {
474     /**
475      * @dev Returns the URI for token type `id`.
476      *
477      * If the `\{id\}` substring is present in the URI, it must be replaced by
478      * clients with the actual token type ID.
479      */
480     function uri(uint256 id) external view returns (string memory);
481 }
482 
483 // File: @openzeppelin/contracts@4.3.1/utils/Context.sol
484 
485 
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev Provides information about the current execution context, including the
491  * sender of the transaction and its data. While these are generally available
492  * via msg.sender and msg.data, they should not be accessed in such a direct
493  * manner, since when dealing with meta-transactions the account sending and
494  * paying for execution may not be the actual sender (as far as an application
495  * is concerned).
496  *
497  * This contract is only required for intermediate, library-like contracts.
498  */
499 abstract contract Context {
500     function _msgSender() internal view virtual returns (address) {
501         return msg.sender;
502     }
503 
504     function _msgData() internal view virtual returns (bytes calldata) {
505         return msg.data;
506     }
507 }
508 
509 // File: @openzeppelin/contracts@4.3.1/token/ERC1155/ERC1155.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 
516 
517 
518 
519 
520 
521 /**
522  * @dev Implementation of the basic standard multi-token.
523  * See https://eips.ethereum.org/EIPS/eip-1155
524  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
525  *
526  * _Available since v3.1._
527  */
528 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
529     using Address for address;
530 
531     // Mapping from token ID to account balances
532     mapping(uint256 => mapping(address => uint256)) private _balances;
533 
534     // Mapping from account to operator approvals
535     mapping(address => mapping(address => bool)) private _operatorApprovals;
536 
537     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
538     string private _uri;
539 
540     /**
541      * @dev See {_setURI}.
542      */
543     constructor(string memory uri_) {
544         _setURI(uri_);
545     }
546 
547     /**
548      * @dev See {IERC165-supportsInterface}.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
551         return
552             interfaceId == type(IERC1155).interfaceId ||
553             interfaceId == type(IERC1155MetadataURI).interfaceId ||
554             super.supportsInterface(interfaceId);
555     }
556 
557     /**
558      * @dev See {IERC1155MetadataURI-uri}.
559      *
560      * This implementation returns the same URI for *all* token types. It relies
561      * on the token type ID substitution mechanism
562      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
563      *
564      * Clients calling this function must replace the `\{id\}` substring with the
565      * actual token type ID.
566      */
567     function uri(uint256) public view virtual override returns (string memory) {
568         return _uri;
569     }
570 
571     /**
572      * @dev See {IERC1155-balanceOf}.
573      *
574      * Requirements:
575      *
576      * - `account` cannot be the zero address.
577      */
578     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
579         require(account != address(0), "ERC1155: balance query for the zero address");
580         return _balances[id][account];
581     }
582 
583     /**
584      * @dev See {IERC1155-balanceOfBatch}.
585      *
586      * Requirements:
587      *
588      * - `accounts` and `ids` must have the same length.
589      */
590     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
591         public
592         view
593         virtual
594         override
595         returns (uint256[] memory)
596     {
597         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
598 
599         uint256[] memory batchBalances = new uint256[](accounts.length);
600 
601         for (uint256 i = 0; i < accounts.length; ++i) {
602             batchBalances[i] = balanceOf(accounts[i], ids[i]);
603         }
604 
605         return batchBalances;
606     }
607 
608     /**
609      * @dev See {IERC1155-setApprovalForAll}.
610      */
611     function setApprovalForAll(address operator, bool approved) public virtual override {
612         require(_msgSender() != operator, "ERC1155: setting approval status for self");
613 
614         _operatorApprovals[_msgSender()][operator] = approved;
615         emit ApprovalForAll(_msgSender(), operator, approved);
616     }
617 
618     /**
619      * @dev See {IERC1155-isApprovedForAll}.
620      */
621     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
622         return _operatorApprovals[account][operator];
623     }
624 
625     /**
626      * @dev See {IERC1155-safeTransferFrom}.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 id,
632         uint256 amount,
633         bytes memory data
634     ) public virtual override {
635         require(
636             from == _msgSender() || isApprovedForAll(from, _msgSender()),
637             "ERC1155: caller is not owner nor approved"
638         );
639         _safeTransferFrom(from, to, id, amount, data);
640     }
641 
642     /**
643      * @dev See {IERC1155-safeBatchTransferFrom}.
644      */
645     function safeBatchTransferFrom(
646         address from,
647         address to,
648         uint256[] memory ids,
649         uint256[] memory amounts,
650         bytes memory data
651     ) public virtual override {
652         require(
653             from == _msgSender() || isApprovedForAll(from, _msgSender()),
654             "ERC1155: transfer caller is not owner nor approved"
655         );
656         _safeBatchTransferFrom(from, to, ids, amounts, data);
657     }
658 
659     /**
660      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
661      *
662      * Emits a {TransferSingle} event.
663      *
664      * Requirements:
665      *
666      * - `to` cannot be the zero address.
667      * - `from` must have a balance of tokens of type `id` of at least `amount`.
668      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
669      * acceptance magic value.
670      */
671     function _safeTransferFrom(
672         address from,
673         address to,
674         uint256 id,
675         uint256 amount,
676         bytes memory data
677     ) internal virtual {
678         require(to != address(0), "ERC1155: transfer to the zero address");
679 
680         address operator = _msgSender();
681 
682         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
683 
684         uint256 fromBalance = _balances[id][from];
685         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
686         unchecked {
687             _balances[id][from] = fromBalance - amount;
688         }
689         _balances[id][to] += amount;
690 
691         emit TransferSingle(operator, from, to, id, amount);
692 
693         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
694     }
695 
696     /**
697      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
698      *
699      * Emits a {TransferBatch} event.
700      *
701      * Requirements:
702      *
703      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
704      * acceptance magic value.
705      */
706     function _safeBatchTransferFrom(
707         address from,
708         address to,
709         uint256[] memory ids,
710         uint256[] memory amounts,
711         bytes memory data
712     ) internal virtual {
713         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
714         require(to != address(0), "ERC1155: transfer to the zero address");
715 
716         address operator = _msgSender();
717 
718         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
719 
720         for (uint256 i = 0; i < ids.length; ++i) {
721             uint256 id = ids[i];
722             uint256 amount = amounts[i];
723 
724             uint256 fromBalance = _balances[id][from];
725             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
726             unchecked {
727                 _balances[id][from] = fromBalance - amount;
728             }
729             _balances[id][to] += amount;
730         }
731 
732         emit TransferBatch(operator, from, to, ids, amounts);
733 
734         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
735     }
736 
737     /**
738      * @dev Sets a new URI for all token types, by relying on the token type ID
739      * substitution mechanism
740      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
741      *
742      * By this mechanism, any occurrence of the `\{id\}` substring in either the
743      * URI or any of the amounts in the JSON file at said URI will be replaced by
744      * clients with the token type ID.
745      *
746      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
747      * interpreted by clients as
748      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
749      * for token type ID 0x4cce0.
750      *
751      * See {uri}.
752      *
753      * Because these URIs cannot be meaningfully represented by the {URI} event,
754      * this function emits no events.
755      */
756     function _setURI(string memory newuri) internal virtual {
757         _uri = newuri;
758     }
759 
760     /**
761      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
762      *
763      * Emits a {TransferSingle} event.
764      *
765      * Requirements:
766      *
767      * - `account` cannot be the zero address.
768      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
769      * acceptance magic value.
770      */
771     function _mint(
772         address account,
773         uint256 id,
774         uint256 amount,
775         bytes memory data
776     ) internal virtual {
777         require(account != address(0), "ERC1155: mint to the zero address");
778 
779         address operator = _msgSender();
780 
781         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
782 
783         _balances[id][account] += amount;
784         emit TransferSingle(operator, address(0), account, id, amount);
785 
786         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
787     }
788 
789     /**
790      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
791      *
792      * Requirements:
793      *
794      * - `ids` and `amounts` must have the same length.
795      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
796      * acceptance magic value.
797      */
798     function _mintBatch(
799         address to,
800         uint256[] memory ids,
801         uint256[] memory amounts,
802         bytes memory data
803     ) internal virtual {
804         require(to != address(0), "ERC1155: mint to the zero address");
805         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
806 
807         address operator = _msgSender();
808 
809         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
810 
811         for (uint256 i = 0; i < ids.length; i++) {
812             _balances[ids[i]][to] += amounts[i];
813         }
814 
815         emit TransferBatch(operator, address(0), to, ids, amounts);
816 
817         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
818     }
819 
820     /**
821      * @dev Destroys `amount` tokens of token type `id` from `account`
822      *
823      * Requirements:
824      *
825      * - `account` cannot be the zero address.
826      * - `account` must have at least `amount` tokens of token type `id`.
827      */
828     function _burn(
829         address account,
830         uint256 id,
831         uint256 amount
832     ) internal virtual {
833         require(account != address(0), "ERC1155: burn from the zero address");
834 
835         address operator = _msgSender();
836 
837         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
838 
839         uint256 accountBalance = _balances[id][account];
840         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
841         unchecked {
842             _balances[id][account] = accountBalance - amount;
843         }
844 
845         emit TransferSingle(operator, account, address(0), id, amount);
846     }
847 
848     /**
849      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
850      *
851      * Requirements:
852      *
853      * - `ids` and `amounts` must have the same length.
854      */
855     function _burnBatch(
856         address account,
857         uint256[] memory ids,
858         uint256[] memory amounts
859     ) internal virtual {
860         require(account != address(0), "ERC1155: burn from the zero address");
861         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
862 
863         address operator = _msgSender();
864 
865         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
866 
867         for (uint256 i = 0; i < ids.length; i++) {
868             uint256 id = ids[i];
869             uint256 amount = amounts[i];
870 
871             uint256 accountBalance = _balances[id][account];
872             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
873             unchecked {
874                 _balances[id][account] = accountBalance - amount;
875             }
876         }
877 
878         emit TransferBatch(operator, account, address(0), ids, amounts);
879     }
880 
881     /**
882      * @dev Hook that is called before any token transfer. This includes minting
883      * and burning, as well as batched variants.
884      *
885      * The same hook is called on both single and batched variants. For single
886      * transfers, the length of the `id` and `amount` arrays will be 1.
887      *
888      * Calling conditions (for each `id` and `amount` pair):
889      *
890      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
891      * of token type `id` will be  transferred to `to`.
892      * - When `from` is zero, `amount` tokens of token type `id` will be minted
893      * for `to`.
894      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
895      * will be burned.
896      * - `from` and `to` are never both zero.
897      * - `ids` and `amounts` have the same, non-zero length.
898      *
899      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
900      */
901     function _beforeTokenTransfer(
902         address operator,
903         address from,
904         address to,
905         uint256[] memory ids,
906         uint256[] memory amounts,
907         bytes memory data
908     ) internal virtual {}
909 
910     function _doSafeTransferAcceptanceCheck(
911         address operator,
912         address from,
913         address to,
914         uint256 id,
915         uint256 amount,
916         bytes memory data
917     ) private {
918         if (to.isContract()) {
919             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
920                 if (response != IERC1155Receiver.onERC1155Received.selector) {
921                     revert("ERC1155: ERC1155Receiver rejected tokens");
922                 }
923             } catch Error(string memory reason) {
924                 revert(reason);
925             } catch {
926                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
927             }
928         }
929     }
930 
931     function _doSafeBatchTransferAcceptanceCheck(
932         address operator,
933         address from,
934         address to,
935         uint256[] memory ids,
936         uint256[] memory amounts,
937         bytes memory data
938     ) private {
939         if (to.isContract()) {
940             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
941                 bytes4 response
942             ) {
943                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
944                     revert("ERC1155: ERC1155Receiver rejected tokens");
945                 }
946             } catch Error(string memory reason) {
947                 revert(reason);
948             } catch {
949                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
950             }
951         }
952     }
953 
954     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
955         uint256[] memory array = new uint256[](1);
956         array[0] = element;
957 
958         return array;
959     }
960 }
961 
962 // File: @openzeppelin/contracts@4.3.1/access/Ownable.sol
963 
964 
965 
966 pragma solidity ^0.8.0;
967 
968 
969 /**
970  * @dev Contract module which provides a basic access control mechanism, where
971  * there is an account (an owner) that can be granted exclusive access to
972  * specific functions.
973  *
974  * By default, the owner account will be the one that deploys the contract. This
975  * can later be changed with {transferOwnership}.
976  *
977  * This module is used through inheritance. It will make available the modifier
978  * `onlyOwner`, which can be applied to your functions to restrict their use to
979  * the owner.
980  */
981 abstract contract Ownable is Context {
982     address private _owner;
983 
984     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
985 
986     /**
987      * @dev Initializes the contract setting the deployer as the initial owner.
988      */
989     constructor() {
990         _setOwner(_msgSender());
991     }
992 
993     /**
994      * @dev Returns the address of the current owner.
995      */
996     function owner() public view virtual returns (address) {
997         return _owner;
998     }
999 
1000     /**
1001      * @dev Throws if called by any account other than the owner.
1002      */
1003     modifier onlyOwner() {
1004         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1005         _;
1006     }
1007 
1008     /**
1009      * @dev Leaves the contract without owner. It will not be possible to call
1010      * `onlyOwner` functions anymore. Can only be called by the current owner.
1011      *
1012      * NOTE: Renouncing ownership will leave the contract without an owner,
1013      * thereby removing any functionality that is only available to the owner.
1014      */
1015     function renounceOwnership() public virtual onlyOwner {
1016         _setOwner(address(0));
1017     }
1018 
1019     /**
1020      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1021      * Can only be called by the current owner.
1022      */
1023     function transferOwnership(address newOwner) public virtual onlyOwner {
1024         require(newOwner != address(0), "Ownable: new owner is the zero address");
1025         _setOwner(newOwner);
1026     }
1027 
1028     function _setOwner(address newOwner) private {
1029         address oldOwner = _owner;
1030         _owner = newOwner;
1031         emit OwnershipTransferred(oldOwner, newOwner);
1032     }
1033 }
1034 
1035 // File: syringe.sol
1036 
1037 
1038 
1039 // MTI4
1040 
1041 pragma solidity ^0.8.0;
1042 
1043 
1044 
1045 
1046 interface IEtholvants {
1047 	function tokenToGrowthBoost(uint tokenId) external view returns (uint);
1048 	function tokenToStakeTime(uint tokenId) external view returns (uint);
1049 	function injectBooster(uint tokenId, uint boostAmount) external;
1050 	function getRealOwner(uint tokenId) external view returns (address);
1051 	function getNumCells(uint tokenId) external view returns (uint);
1052 }
1053 
1054 contract EtholvantsBoosterSyringe is ERC1155, Ownable {
1055 	address private etholvantsAddr = 0x1fFF1e9e963f07AC4486503E5a35e71f4e9Fb9FD;
1056 	IEtholvants private ethols = IEtholvants(etholvantsAddr);
1057 	uint public MINT_END_TS = 1654042069;
1058 	bool public mintPaused = false;
1059 	uint public MIN_CELLS = 1440;
1060 	uint public MIN_STAKED_TIME = 24 * 24 * 3600;
1061 	uint public totalMinted = 0;
1062 	uint public totalBurned = 0;
1063 
1064     mapping(uint256 => bool) public injected;
1065     mapping(uint256 => bool) public minted;
1066 
1067     constructor() ERC1155("") {}
1068 
1069 	function isEligibleToInject(uint etholId) public view returns (bool) {
1070 		if(injected[etholId] || ethols.tokenToStakeTime(etholId) != 0) {
1071 			return false;
1072 		}
1073 		if(ethols.tokenToGrowthBoost(etholId) == 6) {
1074 			return false;
1075 		}
1076 		return true;
1077 	}
1078 
1079 	function setURI(string memory newuri) external onlyOwner {
1080         _setURI(newuri);
1081     }
1082 
1083 	function setEtholsAddr(address addr) external onlyOwner {
1084         etholvantsAddr = addr;
1085 		ethols = IEtholvants(etholvantsAddr);
1086     }
1087 
1088     function togglePause() external onlyOwner {
1089         mintPaused = !mintPaused;
1090     }
1091 
1092 	function isEligibleToMint(uint etholId) public view returns (bool) {
1093 		if(block.timestamp > MINT_END_TS || minted[etholId] || mintPaused) {
1094 			return false;
1095 		}
1096 		uint staked_ts = ethols.tokenToStakeTime(etholId);
1097 		if(staked_ts == 0 || block.timestamp < staked_ts + MIN_STAKED_TIME) {
1098 			return false;
1099 		}
1100 		if(ethols.getNumCells(etholId) < MIN_CELLS) {
1101 			return false;
1102 		}
1103 		return true;
1104 	}
1105 
1106 	function getData(uint etholId) public view returns (bool, bool, bool, bool) {
1107 		return (injected[etholId], minted[etholId], isEligibleToInject(etholId), isEligibleToMint(etholId));
1108 	}
1109 
1110 	function getStats() public view returns (uint, uint) {
1111 		return (totalMinted, totalBurned);
1112 	}
1113 
1114 	function mintBatch(uint256[] memory etholIds) public {
1115         for (uint256 i = 0; i < etholIds.length; i++) {
1116 			uint etholId = etholIds[i];
1117 			require(isEligibleToMint(etholId), "not eligible");
1118 			require(ethols.getRealOwner(etholId) == msg.sender, "permission denied");
1119 			minted[etholId] = true;
1120 		}
1121 		_mint(msg.sender, 0, etholIds.length, "");
1122 		totalMinted += etholIds.length;
1123 	}
1124 
1125 	function inject(uint etholId) external {
1126 		require(ethols.getRealOwner(etholId) == msg.sender, "permission denied");
1127 		require(isEligibleToInject(etholId), "not eligible");
1128 		require(balanceOf(msg.sender, 0) > 0, "you should have a syringe");
1129 		ethols.injectBooster(etholId, 2);
1130 		injected[etholId] = true;
1131 		_burn(msg.sender, 0, 1);
1132 		totalBurned += 1;
1133 	}
1134 }