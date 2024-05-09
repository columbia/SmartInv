1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Required interface of an ERC1155 compliant contract, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
33  *
34  * _Available since v3.1._
35  */
36 interface IERC1155 is IERC165 {
37     /**
38      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
39      */
40     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
41 
42     /**
43      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
44      * transfers.
45      */
46     event TransferBatch(
47         address indexed operator,
48         address indexed from,
49         address indexed to,
50         uint256[] ids,
51         uint256[] values
52     );
53 
54     /**
55      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
56      * `approved`.
57      */
58     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
59 
60     /**
61      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
62      *
63      * If an {URI} event was emitted for `id`, the standard
64      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
65      * returned by {IERC1155MetadataURI-uri}.
66      */
67     event URI(string value, uint256 indexed id);
68 
69     /**
70      * @dev Returns the amount of tokens of token type `id` owned by `account`.
71      *
72      * Requirements:
73      *
74      * - `account` cannot be the zero address.
75      */
76     function balanceOf(address account, uint256 id) external view returns (uint256);
77 
78     /**
79      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
80      *
81      * Requirements:
82      *
83      * - `accounts` and `ids` must have the same length.
84      */
85     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
86         external
87         view
88         returns (uint256[] memory);
89 
90     /**
91      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
92      *
93      * Emits an {ApprovalForAll} event.
94      *
95      * Requirements:
96      *
97      * - `operator` cannot be the caller.
98      */
99     function setApprovalForAll(address operator, bool approved) external;
100 
101     /**
102      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
103      *
104      * See {setApprovalForAll}.
105      */
106     function isApprovedForAll(address account, address operator) external view returns (bool);
107 
108     /**
109      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
110      *
111      * Emits a {TransferSingle} event.
112      *
113      * Requirements:
114      *
115      * - `to` cannot be the zero address.
116      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
117      * - `from` must have a balance of tokens of type `id` of at least `amount`.
118      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
119      * acceptance magic value.
120      */
121     function safeTransferFrom(
122         address from,
123         address to,
124         uint256 id,
125         uint256 amount,
126         bytes calldata data
127     ) external;
128 
129     /**
130      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
131      *
132      * Emits a {TransferBatch} event.
133      *
134      * Requirements:
135      *
136      * - `ids` and `amounts` must have the same length.
137      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
138      * acceptance magic value.
139      */
140     function safeBatchTransferFrom(
141         address from,
142         address to,
143         uint256[] calldata ids,
144         uint256[] calldata amounts,
145         bytes calldata data
146     ) external;
147 }
148 
149 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev _Available since v3.1._
155  */
156 interface IERC1155Receiver is IERC165 {
157     /**
158         @dev Handles the receipt of a single ERC1155 token type. This function is
159         called at the end of a `safeTransferFrom` after the balance has been updated.
160         To accept the transfer, this must return
161         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
162         (i.e. 0xf23a6e61, or its own function selector).
163         @param operator The address which initiated the transfer (i.e. msg.sender)
164         @param from The address which previously owned the token
165         @param id The ID of the token being transferred
166         @param value The amount of tokens being transferred
167         @param data Additional data with no specified format
168         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
169     */
170     function onERC1155Received(
171         address operator,
172         address from,
173         uint256 id,
174         uint256 value,
175         bytes calldata data
176     ) external returns (bytes4);
177 
178     /**
179         @dev Handles the receipt of a multiple ERC1155 token types. This function
180         is called at the end of a `safeBatchTransferFrom` after the balances have
181         been updated. To accept the transfer(s), this must return
182         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
183         (i.e. 0xbc197c81, or its own function selector).
184         @param operator The address which initiated the batch transfer (i.e. msg.sender)
185         @param from The address which previously owned the token
186         @param ids An array containing ids of each token being transferred (order and length must match values array)
187         @param values An array containing amounts of each token being transferred (order and length must match ids array)
188         @param data Additional data with no specified format
189         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
190     */
191     function onERC1155BatchReceived(
192         address operator,
193         address from,
194         uint256[] calldata ids,
195         uint256[] calldata values,
196         bytes calldata data
197     ) external returns (bytes4);
198 }
199 
200 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
206  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
207  *
208  * _Available since v3.1._
209  */
210 interface IERC1155MetadataURI is IERC1155 {
211     /**
212      * @dev Returns the URI for token type `id`.
213      *
214      * If the `\{id\}` substring is present in the URI, it must be replaced by
215      * clients with the actual token type ID.
216      */
217     function uri(uint256 id) external view returns (string memory);
218 }
219 
220 // File: @openzeppelin/contracts/utils/Address.sol
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Collection of functions related to the address type
226  */
227 library Address {
228     /**
229      * @dev Returns true if `account` is a contract.
230      *
231      * [IMPORTANT]
232      * ====
233      * It is unsafe to assume that an address for which this function returns
234      * false is an externally-owned account (EOA) and not a contract.
235      *
236      * Among others, `isContract` will return false for the following
237      * types of addresses:
238      *
239      *  - an externally-owned account
240      *  - a contract in construction
241      *  - an address where a contract will be created
242      *  - an address where a contract lived, but was destroyed
243      * ====
244      */
245     function isContract(address account) internal view returns (bool) {
246         // This method relies on extcodesize, which returns 0 for contracts in
247         // construction, since the code is only stored at the end of the
248         // constructor execution.
249 
250         uint256 size;
251         assembly {
252             size := extcodesize(account)
253         }
254         return size > 0;
255     }
256 
257     /**
258      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
259      * `recipient`, forwarding all available gas and reverting on errors.
260      *
261      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
262      * of certain opcodes, possibly making contracts go over the 2300 gas limit
263      * imposed by `transfer`, making them unable to receive funds via
264      * `transfer`. {sendValue} removes this limitation.
265      *
266      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
267      *
268      * IMPORTANT: because control is transferred to `recipient`, care must be
269      * taken to not create reentrancy vulnerabilities. Consider using
270      * {ReentrancyGuard} or the
271      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
272      */
273     function sendValue(address payable recipient, uint256 amount) internal {
274         require(address(this).balance >= amount, "Address: insufficient balance");
275 
276         (bool success, ) = recipient.call{value: amount}("");
277         require(success, "Address: unable to send value, recipient may have reverted");
278     }
279 
280     /**
281      * @dev Performs a Solidity function call using a low level `call`. A
282      * plain `call` is an unsafe replacement for a function call: use this
283      * function instead.
284      *
285      * If `target` reverts with a revert reason, it is bubbled up by this
286      * function (like regular Solidity function calls).
287      *
288      * Returns the raw returned data. To convert to the expected return value,
289      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
290      *
291      * Requirements:
292      *
293      * - `target` must be a contract.
294      * - calling `target` with `data` must not revert.
295      *
296      * _Available since v3.1._
297      */
298     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
299         return functionCall(target, data, "Address: low-level call failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
304      * `errorMessage` as a fallback revert reason when `target` reverts.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(
309         address target,
310         bytes memory data,
311         string memory errorMessage
312     ) internal returns (bytes memory) {
313         return functionCallWithValue(target, data, 0, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but also transferring `value` wei to `target`.
319      *
320      * Requirements:
321      *
322      * - the calling contract must have an ETH balance of at least `value`.
323      * - the called Solidity function must be `payable`.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(
328         address target,
329         bytes memory data,
330         uint256 value
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
337      * with `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         require(isContract(target), "Address: call to non-contract");
349 
350         (bool success, bytes memory returndata) = target.call{value: value}(data);
351         return verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but performing a static call.
357      *
358      * _Available since v3.3._
359      */
360     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
361         return functionStaticCall(target, data, "Address: low-level static call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal view returns (bytes memory) {
375         require(isContract(target), "Address: static call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.staticcall(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a delegate call.
384      *
385      * _Available since v3.4._
386      */
387     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
388         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         require(isContract(target), "Address: delegate call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.delegatecall(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
410      * revert reason using the provided one.
411      *
412      * _Available since v4.3._
413      */
414     function verifyCallResult(
415         bool success,
416         bytes memory returndata,
417         string memory errorMessage
418     ) internal pure returns (bytes memory) {
419         if (success) {
420             return returndata;
421         } else {
422             // Look for revert reason and bubble it up if present
423             if (returndata.length > 0) {
424                 // The easiest way to bubble the revert reason is using memory via assembly
425 
426                 assembly {
427                     let returndata_size := mload(returndata)
428                     revert(add(32, returndata), returndata_size)
429                 }
430             } else {
431                 revert(errorMessage);
432             }
433         }
434     }
435 }
436 
437 // File: @openzeppelin/contracts/utils/Context.sol
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Provides information about the current execution context, including the
443  * sender of the transaction and its data. While these are generally available
444  * via msg.sender and msg.data, they should not be accessed in such a direct
445  * manner, since when dealing with meta-transactions the account sending and
446  * paying for execution may not be the actual sender (as far as an application
447  * is concerned).
448  *
449  * This contract is only required for intermediate, library-like contracts.
450  */
451 abstract contract Context {
452     function _msgSender() internal view virtual returns (address) {
453         return msg.sender;
454     }
455 
456     function _msgData() internal view virtual returns (bytes calldata) {
457         return msg.data;
458     }
459 }
460 
461 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Implementation of the {IERC165} interface.
467  *
468  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
469  * for the additional interface id that will be supported. For example:
470  *
471  * ```solidity
472  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
473  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
474  * }
475  * ```
476  *
477  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
478  */
479 abstract contract ERC165 is IERC165 {
480     /**
481      * @dev See {IERC165-supportsInterface}.
482      */
483     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484         return interfaceId == type(IERC165).interfaceId;
485     }
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
489 
490 pragma solidity ^0.8.0;
491 
492 
493 
494 
495 
496 
497 /**
498  * @dev Implementation of the basic standard multi-token.
499  * See https://eips.ethereum.org/EIPS/eip-1155
500  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
501  *
502  * _Available since v3.1._
503  */
504 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
505     using Address for address;
506 
507     // Mapping from token ID to account balances
508     mapping(uint256 => mapping(address => uint256)) private _balances;
509 
510     // Mapping from account to operator approvals
511     mapping(address => mapping(address => bool)) private _operatorApprovals;
512 
513     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
514     string private _uri;
515 
516     /**
517      * @dev See {_setURI}.
518      */
519     constructor(string memory uri_) {
520         _setURI(uri_);
521     }
522 
523     /**
524      * @dev See {IERC165-supportsInterface}.
525      */
526     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
527         return
528             interfaceId == type(IERC1155).interfaceId ||
529             interfaceId == type(IERC1155MetadataURI).interfaceId ||
530             super.supportsInterface(interfaceId);
531     }
532 
533     /**
534      * @dev See {IERC1155MetadataURI-uri}.
535      *
536      * This implementation returns the same URI for *all* token types. It relies
537      * on the token type ID substitution mechanism
538      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
539      *
540      * Clients calling this function must replace the `\{id\}` substring with the
541      * actual token type ID.
542      */
543     function uri(uint256) public view virtual override returns (string memory) {
544         return _uri;
545     }
546 
547     /**
548      * @dev See {IERC1155-balanceOf}.
549      *
550      * Requirements:
551      *
552      * - `account` cannot be the zero address.
553      */
554     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
555         require(account != address(0), "ERC1155: balance query for the zero address");
556         return _balances[id][account];
557     }
558 
559     /**
560      * @dev See {IERC1155-balanceOfBatch}.
561      *
562      * Requirements:
563      *
564      * - `accounts` and `ids` must have the same length.
565      */
566     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
567         public
568         view
569         virtual
570         override
571         returns (uint256[] memory)
572     {
573         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
574 
575         uint256[] memory batchBalances = new uint256[](accounts.length);
576 
577         for (uint256 i = 0; i < accounts.length; ++i) {
578             batchBalances[i] = balanceOf(accounts[i], ids[i]);
579         }
580 
581         return batchBalances;
582     }
583 
584     /**
585      * @dev See {IERC1155-setApprovalForAll}.
586      */
587     function setApprovalForAll(address operator, bool approved) public virtual override {
588         require(_msgSender() != operator, "ERC1155: setting approval status for self");
589 
590         _operatorApprovals[_msgSender()][operator] = approved;
591         emit ApprovalForAll(_msgSender(), operator, approved);
592     }
593 
594     /**
595      * @dev See {IERC1155-isApprovedForAll}.
596      */
597     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
598         return _operatorApprovals[account][operator];
599     }
600 
601     /**
602      * @dev See {IERC1155-safeTransferFrom}.
603      */
604     function safeTransferFrom(
605         address from,
606         address to,
607         uint256 id,
608         uint256 amount,
609         bytes memory data
610     ) public virtual override {
611         require(
612             from == _msgSender() || isApprovedForAll(from, _msgSender()),
613             "ERC1155: caller is not owner nor approved"
614         );
615         _safeTransferFrom(from, to, id, amount, data);
616     }
617 
618     /**
619      * @dev See {IERC1155-safeBatchTransferFrom}.
620      */
621     function safeBatchTransferFrom(
622         address from,
623         address to,
624         uint256[] memory ids,
625         uint256[] memory amounts,
626         bytes memory data
627     ) public virtual override {
628         require(
629             from == _msgSender() || isApprovedForAll(from, _msgSender()),
630             "ERC1155: transfer caller is not owner nor approved"
631         );
632         _safeBatchTransferFrom(from, to, ids, amounts, data);
633     }
634 
635     /**
636      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
637      *
638      * Emits a {TransferSingle} event.
639      *
640      * Requirements:
641      *
642      * - `to` cannot be the zero address.
643      * - `from` must have a balance of tokens of type `id` of at least `amount`.
644      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
645      * acceptance magic value.
646      */
647     function _safeTransferFrom(
648         address from,
649         address to,
650         uint256 id,
651         uint256 amount,
652         bytes memory data
653     ) internal virtual {
654         require(to != address(0), "ERC1155: transfer to the zero address");
655 
656         address operator = _msgSender();
657 
658         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
659 
660         uint256 fromBalance = _balances[id][from];
661         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
662         unchecked {
663             _balances[id][from] = fromBalance - amount;
664         }
665         _balances[id][to] += amount;
666 
667         emit TransferSingle(operator, from, to, id, amount);
668 
669         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
670     }
671 
672     /**
673      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
674      *
675      * Emits a {TransferBatch} event.
676      *
677      * Requirements:
678      *
679      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
680      * acceptance magic value.
681      */
682     function _safeBatchTransferFrom(
683         address from,
684         address to,
685         uint256[] memory ids,
686         uint256[] memory amounts,
687         bytes memory data
688     ) internal virtual {
689         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
690         require(to != address(0), "ERC1155: transfer to the zero address");
691 
692         address operator = _msgSender();
693 
694         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
695 
696         for (uint256 i = 0; i < ids.length; ++i) {
697             uint256 id = ids[i];
698             uint256 amount = amounts[i];
699 
700             uint256 fromBalance = _balances[id][from];
701             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
702             unchecked {
703                 _balances[id][from] = fromBalance - amount;
704             }
705             _balances[id][to] += amount;
706         }
707 
708         emit TransferBatch(operator, from, to, ids, amounts);
709 
710         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
711     }
712 
713     /**
714      * @dev Sets a new URI for all token types, by relying on the token type ID
715      * substitution mechanism
716      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
717      *
718      * By this mechanism, any occurrence of the `\{id\}` substring in either the
719      * URI or any of the amounts in the JSON file at said URI will be replaced by
720      * clients with the token type ID.
721      *
722      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
723      * interpreted by clients as
724      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
725      * for token type ID 0x4cce0.
726      *
727      * See {uri}.
728      *
729      * Because these URIs cannot be meaningfully represented by the {URI} event,
730      * this function emits no events.
731      */
732     function _setURI(string memory newuri) internal virtual {
733         _uri = newuri;
734     }
735 
736     /**
737      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
738      *
739      * Emits a {TransferSingle} event.
740      *
741      * Requirements:
742      *
743      * - `account` cannot be the zero address.
744      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
745      * acceptance magic value.
746      */
747     function _mint(
748         address account,
749         uint256 id,
750         uint256 amount,
751         bytes memory data
752     ) internal virtual {
753         require(account != address(0), "ERC1155: mint to the zero address");
754 
755         address operator = _msgSender();
756 
757         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
758 
759         _balances[id][account] += amount;
760         emit TransferSingle(operator, address(0), account, id, amount);
761 
762         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
763     }
764 
765     /**
766      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
767      *
768      * Requirements:
769      *
770      * - `ids` and `amounts` must have the same length.
771      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
772      * acceptance magic value.
773      */
774     function _mintBatch(
775         address to,
776         uint256[] memory ids,
777         uint256[] memory amounts,
778         bytes memory data
779     ) internal virtual {
780         require(to != address(0), "ERC1155: mint to the zero address");
781         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
782 
783         address operator = _msgSender();
784 
785         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
786 
787         for (uint256 i = 0; i < ids.length; i++) {
788             _balances[ids[i]][to] += amounts[i];
789         }
790 
791         emit TransferBatch(operator, address(0), to, ids, amounts);
792 
793         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
794     }
795 
796     /**
797      * @dev Destroys `amount` tokens of token type `id` from `account`
798      *
799      * Requirements:
800      *
801      * - `account` cannot be the zero address.
802      * - `account` must have at least `amount` tokens of token type `id`.
803      */
804     function _burn(
805         address account,
806         uint256 id,
807         uint256 amount
808     ) internal virtual {
809         require(account != address(0), "ERC1155: burn from the zero address");
810 
811         address operator = _msgSender();
812 
813         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
814 
815         uint256 accountBalance = _balances[id][account];
816         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
817         unchecked {
818             _balances[id][account] = accountBalance - amount;
819         }
820 
821         emit TransferSingle(operator, account, address(0), id, amount);
822     }
823 
824     /**
825      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
826      *
827      * Requirements:
828      *
829      * - `ids` and `amounts` must have the same length.
830      */
831     function _burnBatch(
832         address account,
833         uint256[] memory ids,
834         uint256[] memory amounts
835     ) internal virtual {
836         require(account != address(0), "ERC1155: burn from the zero address");
837         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
838 
839         address operator = _msgSender();
840 
841         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
842 
843         for (uint256 i = 0; i < ids.length; i++) {
844             uint256 id = ids[i];
845             uint256 amount = amounts[i];
846 
847             uint256 accountBalance = _balances[id][account];
848             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
849             unchecked {
850                 _balances[id][account] = accountBalance - amount;
851             }
852         }
853 
854         emit TransferBatch(operator, account, address(0), ids, amounts);
855     }
856 
857     /**
858      * @dev Hook that is called before any token transfer. This includes minting
859      * and burning, as well as batched variants.
860      *
861      * The same hook is called on both single and batched variants. For single
862      * transfers, the length of the `id` and `amount` arrays will be 1.
863      *
864      * Calling conditions (for each `id` and `amount` pair):
865      *
866      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
867      * of token type `id` will be  transferred to `to`.
868      * - When `from` is zero, `amount` tokens of token type `id` will be minted
869      * for `to`.
870      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
871      * will be burned.
872      * - `from` and `to` are never both zero.
873      * - `ids` and `amounts` have the same, non-zero length.
874      *
875      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
876      */
877     function _beforeTokenTransfer(
878         address operator,
879         address from,
880         address to,
881         uint256[] memory ids,
882         uint256[] memory amounts,
883         bytes memory data
884     ) internal virtual {}
885 
886     function _doSafeTransferAcceptanceCheck(
887         address operator,
888         address from,
889         address to,
890         uint256 id,
891         uint256 amount,
892         bytes memory data
893     ) private {
894         if (to.isContract()) {
895             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
896                 if (response != IERC1155Receiver.onERC1155Received.selector) {
897                     revert("ERC1155: ERC1155Receiver rejected tokens");
898                 }
899             } catch Error(string memory reason) {
900                 revert(reason);
901             } catch {
902                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
903             }
904         }
905     }
906 
907     function _doSafeBatchTransferAcceptanceCheck(
908         address operator,
909         address from,
910         address to,
911         uint256[] memory ids,
912         uint256[] memory amounts,
913         bytes memory data
914     ) private {
915         if (to.isContract()) {
916             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
917                 bytes4 response
918             ) {
919                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
920                     revert("ERC1155: ERC1155Receiver rejected tokens");
921                 }
922             } catch Error(string memory reason) {
923                 revert(reason);
924             } catch {
925                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
926             }
927         }
928     }
929 
930     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
931         uint256[] memory array = new uint256[](1);
932         array[0] = element;
933 
934         return array;
935     }
936 }
937 
938 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
939 
940 pragma solidity ^0.8.0;
941 
942 /**
943  * @dev Extension of {ERC1155} that allows token holders to destroy both their
944  * own tokens and those that they have been approved to use.
945  *
946  * _Available since v3.1._
947  */
948 abstract contract ERC1155Burnable is ERC1155 {
949     function burn(
950         address account,
951         uint256 id,
952         uint256 value
953     ) public virtual {
954         require(
955             account == _msgSender() || isApprovedForAll(account, _msgSender()),
956             "ERC1155: caller is not owner nor approved"
957         );
958 
959         _burn(account, id, value);
960     }
961 
962     function burnBatch(
963         address account,
964         uint256[] memory ids,
965         uint256[] memory values
966     ) public virtual {
967         require(
968             account == _msgSender() || isApprovedForAll(account, _msgSender()),
969             "ERC1155: caller is not owner nor approved"
970         );
971 
972         _burnBatch(account, ids, values);
973     }
974 }
975 
976 // File: @openzeppelin/contracts/security/Pausable.sol
977 
978 pragma solidity ^0.8.0;
979 
980 /**
981  * @dev Contract module which allows children to implement an emergency stop
982  * mechanism that can be triggered by an authorized account.
983  *
984  * This module is used through inheritance. It will make available the
985  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
986  * the functions of your contract. Note that they will not be pausable by
987  * simply including this module, only once the modifiers are put in place.
988  */
989 abstract contract Pausable is Context {
990     /**
991      * @dev Emitted when the pause is triggered by `account`.
992      */
993     event Paused(address account);
994 
995     /**
996      * @dev Emitted when the pause is lifted by `account`.
997      */
998     event Unpaused(address account);
999 
1000     bool private _paused;
1001 
1002     /**
1003      * @dev Initializes the contract in unpaused state.
1004      */
1005     constructor() {
1006         _paused = false;
1007     }
1008 
1009     /**
1010      * @dev Returns true if the contract is paused, and false otherwise.
1011      */
1012     function paused() public view virtual returns (bool) {
1013         return _paused;
1014     }
1015 
1016     /**
1017      * @dev Modifier to make a function callable only when the contract is not paused.
1018      *
1019      * Requirements:
1020      *
1021      * - The contract must not be paused.
1022      */
1023     modifier whenNotPaused() {
1024         require(!paused(), "Pausable: paused");
1025         _;
1026     }
1027 
1028     /**
1029      * @dev Modifier to make a function callable only when the contract is paused.
1030      *
1031      * Requirements:
1032      *
1033      * - The contract must be paused.
1034      */
1035     modifier whenPaused() {
1036         require(paused(), "Pausable: not paused");
1037         _;
1038     }
1039 
1040     /**
1041      * @dev Triggers stopped state.
1042      *
1043      * Requirements:
1044      *
1045      * - The contract must not be paused.
1046      */
1047     function _pause() internal virtual whenNotPaused {
1048         _paused = true;
1049         emit Paused(_msgSender());
1050     }
1051 
1052     /**
1053      * @dev Returns to normal state.
1054      *
1055      * Requirements:
1056      *
1057      * - The contract must be paused.
1058      */
1059     function _unpause() internal virtual whenPaused {
1060         _paused = false;
1061         emit Unpaused(_msgSender());
1062     }
1063 }
1064 
1065 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol
1066 
1067 pragma solidity ^0.8.0;
1068 
1069 
1070 /**
1071  * @dev ERC1155 token with pausable token transfers, minting and burning.
1072  *
1073  * Useful for scenarios such as preventing trades until the end of an evaluation
1074  * period, or having an emergency switch for freezing all token transfers in the
1075  * event of a large bug.
1076  *
1077  * _Available since v3.1._
1078  */
1079 abstract contract ERC1155Pausable is ERC1155, Pausable {
1080     /**
1081      * @dev See {ERC1155-_beforeTokenTransfer}.
1082      *
1083      * Requirements:
1084      *
1085      * - the contract must not be paused.
1086      */
1087     function _beforeTokenTransfer(
1088         address operator,
1089         address from,
1090         address to,
1091         uint256[] memory ids,
1092         uint256[] memory amounts,
1093         bytes memory data
1094     ) internal virtual override {
1095         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1096 
1097         require(!paused(), "ERC1155Pausable: token transfer while paused");
1098     }
1099 }
1100 
1101 // File: @openzeppelin/contracts/access/Ownable.sol
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 /**
1106  * @dev Contract module which provides a basic access control mechanism, where
1107  * there is an account (an owner) that can be granted exclusive access to
1108  * specific functions.
1109  *
1110  * By default, the owner account will be the one that deploys the contract. This
1111  * can later be changed with {transferOwnership}.
1112  *
1113  * This module is used through inheritance. It will make available the modifier
1114  * `onlyOwner`, which can be applied to your functions to restrict their use to
1115  * the owner.
1116  */
1117 abstract contract Ownable is Context {
1118     address private _owner;
1119 
1120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1121 
1122     /**
1123      * @dev Initializes the contract setting the deployer as the initial owner.
1124      */
1125     constructor() {
1126         _setOwner(_msgSender());
1127     }
1128 
1129     /**
1130      * @dev Returns the address of the current owner.
1131      */
1132     function owner() public view virtual returns (address) {
1133         return _owner;
1134     }
1135 
1136     /**
1137      * @dev Throws if called by any account other than the owner.
1138      */
1139     modifier onlyOwner() {
1140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1141         _;
1142     }
1143 
1144     /**
1145      * @dev Leaves the contract without owner. It will not be possible to call
1146      * `onlyOwner` functions anymore. Can only be called by the current owner.
1147      *
1148      * NOTE: Renouncing ownership will leave the contract without an owner,
1149      * thereby removing any functionality that is only available to the owner.
1150      */
1151     function renounceOwnership() public virtual onlyOwner {
1152         _setOwner(address(0));
1153     }
1154 
1155     /**
1156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1157      * Can only be called by the current owner.
1158      */
1159     function transferOwnership(address newOwner) public virtual onlyOwner {
1160         require(newOwner != address(0), "Ownable: new owner is the zero address");
1161         _setOwner(newOwner);
1162     }
1163 
1164     function _setOwner(address newOwner) private {
1165         address oldOwner = _owner;
1166         _owner = newOwner;
1167         emit OwnershipTransferred(oldOwner, newOwner);
1168     }
1169 }
1170 
1171 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 /**
1176  * @dev Interface of the ERC20 standard as defined in the EIP.
1177  */
1178 interface IERC20 {
1179     /**
1180      * @dev Returns the amount of tokens in existence.
1181      */
1182     function totalSupply() external view returns (uint256);
1183 
1184     /**
1185      * @dev Returns the amount of tokens owned by `account`.
1186      */
1187     function balanceOf(address account) external view returns (uint256);
1188 
1189     /**
1190      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1191      *
1192      * Returns a boolean value indicating whether the operation succeeded.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function transfer(address recipient, uint256 amount) external returns (bool);
1197 
1198     /**
1199      * @dev Returns the remaining number of tokens that `spender` will be
1200      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1201      * zero by default.
1202      *
1203      * This value changes when {approve} or {transferFrom} are called.
1204      */
1205     function allowance(address owner, address spender) external view returns (uint256);
1206 
1207     /**
1208      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1209      *
1210      * Returns a boolean value indicating whether the operation succeeded.
1211      *
1212      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1213      * that someone may use both the old and the new allowance by unfortunate
1214      * transaction ordering. One possible solution to mitigate this race
1215      * condition is to first reduce the spender's allowance to 0 and set the
1216      * desired value afterwards:
1217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1218      *
1219      * Emits an {Approval} event.
1220      */
1221     function approve(address spender, uint256 amount) external returns (bool);
1222 
1223     /**
1224      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1225      * allowance mechanism. `amount` is then deducted from the caller's
1226      * allowance.
1227      *
1228      * Returns a boolean value indicating whether the operation succeeded.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function transferFrom(
1233         address sender,
1234         address recipient,
1235         uint256 amount
1236     ) external returns (bool);
1237 
1238     /**
1239      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1240      * another (`to`).
1241      *
1242      * Note that `value` may be zero.
1243      */
1244     event Transfer(address indexed from, address indexed to, uint256 value);
1245 
1246     /**
1247      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1248      * a call to {approve}. `value` is the new allowance.
1249      */
1250     event Approval(address indexed owner, address indexed spender, uint256 value);
1251 }
1252 
1253 // File: contracts/presale.sol
1254 
1255 pragma solidity ^0.8.2;
1256 
1257 
1258 
1259 
1260 
1261 contract PRESALE is ERC1155, Ownable, ERC1155Burnable, ERC1155Pausable {
1262     fallback() external payable {}
1263 
1264     receive() external payable {}
1265 
1266     uint256 public constant MAX_SUPPLY = 10000;
1267     uint256 public CLAIMED_SUPPLY;
1268 
1269     mapping(address => uint8) private _allowList;
1270     uint256 private constant _tokenId = 1;
1271 
1272     // the prices are temporary, and set in the "setDutchAuctionPrice" function
1273     // public sale dutch auction
1274     uint public DUTCH_AUCTION_START = 0 ether;
1275     uint public DUTCH_AUCTION_END = 0 ether;
1276     uint public DUTCH_AUCTION_INCREMENT = 0 ether;
1277     uint public DUTCH_AUCTION_STEP_TIME = 1;
1278 
1279     // presale fixed price, temporary as well
1280     uint public PRESALE_PRICE = 0.25 ether;
1281 
1282     uint public startTimestamp;
1283 
1284     bool public hasPreSaleStarted = false;
1285 
1286     constructor()
1287         ERC1155("")
1288     {}
1289 
1290     function dutchAuctionPrice() public view returns (uint) {
1291         if (startTimestamp == 0 || block.timestamp <= startTimestamp) {
1292             return DUTCH_AUCTION_START;
1293         } else {
1294             uint increments = (block.timestamp - startTimestamp) / DUTCH_AUCTION_STEP_TIME;
1295             if (increments * DUTCH_AUCTION_INCREMENT >= DUTCH_AUCTION_START) {
1296                 return DUTCH_AUCTION_END;
1297             } else {
1298                 return DUTCH_AUCTION_START - (increments * DUTCH_AUCTION_INCREMENT);
1299             }
1300         }
1301     }
1302 
1303     function setDutchAuctionPrice(uint dutch_auction_start, uint dutch_auction_end, uint dutch_auction_increment, uint dutch_auction_step_time) public onlyOwner
1304     {
1305         DUTCH_AUCTION_START = dutch_auction_start;
1306         DUTCH_AUCTION_END = dutch_auction_end;
1307         DUTCH_AUCTION_INCREMENT = dutch_auction_increment;
1308         DUTCH_AUCTION_STEP_TIME = dutch_auction_step_time;
1309     }
1310 
1311     // this makes it easier to grab all the essential information about the state of the presale contract without making multiple infura requests.
1312     function getAuctionInformation() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint, bool, bool) {
1313         /*
1314             0: dutch auction start timestamp
1315             1: dutch auction start price
1316             2: dutch auction end price
1317             3: dutch auction increment price
1318             4: dutch auction step time
1319             5: max supply
1320             6: claimed supply
1321             7: dutch auction current price
1322             8: presale price
1323             9: has presale started
1324             10:has public sale started
1325         */
1326         return (startTimestamp, DUTCH_AUCTION_START, DUTCH_AUCTION_END, DUTCH_AUCTION_INCREMENT, DUTCH_AUCTION_STEP_TIME, 
1327                 MAX_SUPPLY, claimedSupply(), dutchAuctionPrice(), PRESALE_PRICE, hasPreSaleStarted, hasPublicSaleStarted());
1328     }
1329 
1330     function hasPublicSaleStarted() public view returns (bool) {
1331         return startTimestamp != 0;
1332     }
1333 
1334     /**
1335      * @dev Set the URI
1336      */
1337     function setURI(string memory newuri) public onlyOwner {
1338         _setURI(newuri);
1339     }
1340 
1341     /**
1342      * @dev Enable the public sale
1343      */
1344     function enablePublicSale() public onlyOwner {
1345         startTimestamp = block.timestamp;
1346     }
1347 
1348     /**
1349      * @dev set the public sale timestamp
1350      */
1351     function setPublicSaleTimestamp(uint timestamp) public onlyOwner {
1352         startTimestamp = timestamp;
1353     }
1354 
1355     /**
1356      * @dev Stop the public sale
1357      */
1358     function stopPublicSale() public onlyOwner {
1359         startTimestamp = 0;
1360     }
1361 
1362     /**
1363      * @dev Enable the Pre-sale
1364      */
1365     function enablePreSale(uint presale_price) public onlyOwner {
1366         PRESALE_PRICE = presale_price;
1367         hasPreSaleStarted = true;
1368     }
1369 
1370     /**
1371      * @dev Stop the public sale
1372      */
1373     function stopPreSale() public onlyOwner {
1374         hasPreSaleStarted = false;
1375     }
1376 
1377     /**
1378      * @dev Just in case.
1379      */
1380     function setStartingPrice(uint256 _newPrice) public onlyOwner {
1381         DUTCH_AUCTION_START = _newPrice;
1382     }
1383 
1384     /**
1385      * @dev Shows the price of the token
1386      */
1387     function getStartingPrice() public view returns (uint256) {
1388         return DUTCH_AUCTION_START;
1389     }
1390 
1391     /**
1392      * @dev Total claimed supply.
1393      */
1394     function claimedSupply() public view returns (uint256) {
1395         return CLAIMED_SUPPLY;
1396     }
1397 
1398     /**
1399      * @dev Add address to the presale list
1400      */
1401     function setWhitelisted(address[] calldata addresses, uint8 numAllowedToMint)
1402         external
1403         onlyOwner
1404     {
1405         for (uint256 i = 0; i < addresses.length; i++) {
1406             _allowList[addresses[i]] = numAllowedToMint;
1407         }
1408     }
1409 
1410     /**
1411      * @dev Pre-sale Minting
1412      */
1413     function preSaleMint(uint256 numberOfTokens) external payable {
1414         require(hasPreSaleStarted, "Pre-sale minting is not active");
1415         require(
1416             CLAIMED_SUPPLY + numberOfTokens <= MAX_SUPPLY,
1417             "Purchase would exceed max tokens"
1418         );
1419 
1420         uint256 senderBalance = balanceOf(msg.sender, _tokenId);
1421         require(
1422             numberOfTokens <= _allowList[msg.sender] - senderBalance,
1423             "Exceeded max available to purchase"
1424         );
1425 
1426         require(!paused(), "The contract is currently paused");
1427 
1428         // Can only claim one at a time
1429         require(numberOfTokens <= 10, "Too many requested");
1430         require(
1431             PRESALE_PRICE * numberOfTokens == msg.value,
1432             "Ether value sent is not correct"
1433         );
1434 
1435         CLAIMED_SUPPLY += numberOfTokens;
1436         _mint(msg.sender, _tokenId, numberOfTokens, "");
1437     }
1438 
1439     function isWalletWhitelisted(address wallet) public view returns (bool) {
1440         return _allowList[wallet] > 0;
1441     }
1442 
1443     function pause() public onlyOwner {
1444         _pause();
1445     }
1446 
1447     function unpause() public onlyOwner {
1448         _unpause();
1449     }
1450 
1451     /**
1452      * @dev Public Sale Minting
1453      */
1454     function publicSaleMint(uint256 numberOfTokens) external payable {
1455         require(hasPublicSaleStarted(), "Public sale minting is not active");
1456         require(
1457             CLAIMED_SUPPLY + numberOfTokens <= MAX_SUPPLY,
1458             "Purchase would exceed max tokens"
1459         );
1460 
1461         // Can only claim 10 at a time
1462         require(numberOfTokens <= 10, "Too many requested");
1463         require(
1464             dutchAuctionPrice() * numberOfTokens == msg.value,
1465             "Ether value sent is not correct"
1466         );
1467 
1468         require(!paused(), "The contract is currently paused");
1469 
1470         CLAIMED_SUPPLY += numberOfTokens;
1471         _mint(msg.sender, _tokenId, numberOfTokens, "");
1472     }
1473 
1474     /**
1475      * @dev Owner minting function
1476      */
1477     function ownerMint(uint256 numberOfTokens) external payable onlyOwner {
1478         require(
1479             CLAIMED_SUPPLY + numberOfTokens <= MAX_SUPPLY,
1480             "Purchase would exceed max tokens"
1481         );
1482 
1483         CLAIMED_SUPPLY += numberOfTokens;
1484         _mint(msg.sender, _tokenId, numberOfTokens, "");
1485     }
1486 
1487     /**
1488      * @dev Withdraw and distribute the ether.
1489      */
1490     function withdrawAll() public payable onlyOwner {
1491         uint256 balance = address(this).balance;
1492         payable(msg.sender).transfer(balance);
1493     }
1494 
1495     function _beforeTokenTransfer(
1496         address operator,
1497         address from,
1498         address to,
1499         uint256[] memory ids,
1500         uint256[] memory amounts,
1501         bytes memory data
1502     ) internal virtual override(ERC1155, ERC1155Pausable) {
1503         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1504     }
1505 }