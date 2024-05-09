1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.6;
3 
4 interface IERC165 {
5     /**
6      * @dev Returns true if this contract implements the interface defined by
7      * `interfaceId`. See the corresponding
8      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
9      * to learn more about how these ids are created.
10      *
11      * This function call must use less than 30 000 gas.
12      */
13     function supportsInterface(bytes4 interfaceId) external view returns (bool);
14 }
15 
16 
17 interface IERC1155 is IERC165 {
18     /**
19      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
20      */
21     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
22 
23     /**
24      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
25      * transfers.
26      */
27     event TransferBatch(
28         address indexed operator,
29         address indexed from,
30         address indexed to,
31         uint256[] ids,
32         uint256[] values
33     );
34 
35     /**
36      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
37      * `approved`.
38      */
39     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
40 
41     /**
42      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
43      *
44      * If an {URI} event was emitted for `id`, the standard
45      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
46      * returned by {IERC1155MetadataURI-uri}.
47      */
48     event URI(string value, uint256 indexed id);
49 
50     /**
51      * @dev Returns the amount of tokens of token type `id` owned by `account`.
52      *
53      * Requirements:
54      *
55      * - `account` cannot be the zero address.
56      */
57     function balanceOf(address account, uint256 id) external view returns (uint256);
58 
59     /**
60      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
61      *
62      * Requirements:
63      *
64      * - `accounts` and `ids` must have the same length.
65      */
66     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
67         external
68         view
69         returns (uint256[] memory);
70 
71     /**
72      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
73      *
74      * Emits an {ApprovalForAll} event.
75      *
76      * Requirements:
77      *
78      * - `operator` cannot be the caller.
79      */
80     function setApprovalForAll(address operator, bool approved) external;
81 
82     /**
83      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
84      *
85      * See {setApprovalForAll}.
86      */
87     function isApprovedForAll(address account, address operator) external view returns (bool);
88 
89     /**
90      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
91      *
92      * Emits a {TransferSingle} event.
93      *
94      * Requirements:
95      *
96      * - `to` cannot be the zero address.
97      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
98      * - `from` must have a balance of tokens of type `id` of at least `amount`.
99      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
100      * acceptance magic value.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 id,
106         uint256 amount,
107         bytes calldata data
108     ) external;
109 
110     /**
111      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
112      *
113      * Emits a {TransferBatch} event.
114      *
115      * Requirements:
116      *
117      * - `ids` and `amounts` must have the same length.
118      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
119      * acceptance magic value.
120      */
121     function safeBatchTransferFrom(
122         address from,
123         address to,
124         uint256[] calldata ids,
125         uint256[] calldata amounts,
126         bytes calldata data
127     ) external;
128 }
129 
130 
131 interface IERC1155Receiver is IERC165 {
132     /**
133         @dev Handles the receipt of a single ERC1155 token type. This function is
134         called at the end of a `safeTransferFrom` after the balance has been updated.
135         To accept the transfer, this must return
136         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
137         (i.e. 0xf23a6e61, or its own function selector).
138         @param operator The address which initiated the transfer (i.e. msg.sender)
139         @param from The address which previously owned the token
140         @param id The ID of the token being transferred
141         @param value The amount of tokens being transferred
142         @param data Additional data with no specified format
143         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
144     */
145     function onERC1155Received(
146         address operator,
147         address from,
148         uint256 id,
149         uint256 value,
150         bytes calldata data
151     ) external returns (bytes4);
152 
153     /**
154         @dev Handles the receipt of a multiple ERC1155 token types. This function
155         is called at the end of a `safeBatchTransferFrom` after the balances have
156         been updated. To accept the transfer(s), this must return
157         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
158         (i.e. 0xbc197c81, or its own function selector).
159         @param operator The address which initiated the batch transfer (i.e. msg.sender)
160         @param from The address which previously owned the token
161         @param ids An array containing ids of each token being transferred (order and length must match values array)
162         @param values An array containing amounts of each token being transferred (order and length must match ids array)
163         @param data Additional data with no specified format
164         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
165     */
166     function onERC1155BatchReceived(
167         address operator,
168         address from,
169         uint256[] calldata ids,
170         uint256[] calldata values,
171         bytes calldata data
172     ) external returns (bytes4);
173 }
174 
175 
176 interface IERC1155MetadataURI is IERC1155 {
177     /**
178      * @dev Returns the URI for token type `id`.
179      *
180      * If the `\{id\}` substring is present in the URI, it must be replaced by
181      * clients with the actual token type ID.
182      */
183     function uri(uint256 id) external view returns (string memory);
184 }
185 
186 
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      */
205     function isContract(address account) internal view returns (bool) {
206         // This method relies on extcodesize, which returns 0 for contracts in
207         // construction, since the code is only stored at the end of the
208         // constructor execution.
209 
210         uint256 size;
211         assembly {
212             size := extcodesize(account)
213         }
214         return size > 0;
215     }
216 
217     /**
218      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
219      * `recipient`, forwarding all available gas and reverting on errors.
220      *
221      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
222      * of certain opcodes, possibly making contracts go over the 2300 gas limit
223      * imposed by `transfer`, making them unable to receive funds via
224      * `transfer`. {sendValue} removes this limitation.
225      *
226      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
227      *
228      * IMPORTANT: because control is transferred to `recipient`, care must be
229      * taken to not create reentrancy vulnerabilities. Consider using
230      * {ReentrancyGuard} or the
231      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
232      */
233     function sendValue(address payable recipient, uint256 amount) internal {
234         require(address(this).balance >= amount, "Address: insufficient balance");
235 
236         (bool success, ) = recipient.call{value: amount}("");
237         require(success, "Address: unable to send value, recipient may have reverted");
238     }
239 
240     /**
241      * @dev Performs a Solidity function call using a low level `call`. A
242      * plain `call` is an unsafe replacement for a function call: use this
243      * function instead.
244      *
245      * If `target` reverts with a revert reason, it is bubbled up by this
246      * function (like regular Solidity function calls).
247      *
248      * Returns the raw returned data. To convert to the expected return value,
249      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
250      *
251      * Requirements:
252      *
253      * - `target` must be a contract.
254      * - calling `target` with `data` must not revert.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionCall(target, data, "Address: low-level call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
264      * `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         return functionCallWithValue(target, data, 0, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but also transferring `value` wei to `target`.
279      *
280      * Requirements:
281      *
282      * - the calling contract must have an ETH balance of at least `value`.
283      * - the called Solidity function must be `payable`.
284      *
285      * _Available since v3.1._
286      */
287     function functionCallWithValue(
288         address target,
289         bytes memory data,
290         uint256 value
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
297      * with `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(address(this).balance >= value, "Address: insufficient balance for call");
308         require(isContract(target), "Address: call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.call{value: value}(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
321         return functionStaticCall(target, data, "Address: low-level static call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal view returns (bytes memory) {
335         require(isContract(target), "Address: static call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.staticcall(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a delegate call.
344      *
345      * _Available since v3.4._
346      */
347     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(isContract(target), "Address: delegate call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.delegatecall(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
370      * revert reason using the provided one.
371      *
372      * _Available since v4.3._
373      */
374     function verifyCallResult(
375         bool success,
376         bytes memory returndata,
377         string memory errorMessage
378     ) internal pure returns (bytes memory) {
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 
398 abstract contract Context {
399     function _msgSender() internal view virtual returns (address) {
400         return msg.sender;
401     }
402 
403     function _msgData() internal view virtual returns (bytes calldata) {
404         return msg.data;
405     }
406 }
407 
408 
409 abstract contract ERC165 is IERC165 {
410     /**
411      * @dev See {IERC165-supportsInterface}.
412      */
413     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
414         return interfaceId == type(IERC165).interfaceId;
415     }
416 }
417 
418 
419 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
420     using Address for address;
421 
422     // Mapping from token ID to account balances
423     mapping(uint256 => mapping(address => uint256)) private _balances;
424 
425     // Mapping from account to operator approvals
426     mapping(address => mapping(address => bool)) private _operatorApprovals;
427 
428     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
429     string private _uri;
430 
431     /**
432      * @dev See {_setURI}.
433      */
434     constructor(string memory uri_) {
435         _setURI(uri_);
436     }
437 
438     /**
439      * @dev See {IERC165-supportsInterface}.
440      */
441     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
442         return
443             interfaceId == type(IERC1155).interfaceId ||
444             interfaceId == type(IERC1155MetadataURI).interfaceId ||
445             super.supportsInterface(interfaceId);
446     }
447 
448     /**
449      * @dev See {IERC1155MetadataURI-uri}.
450      *
451      * This implementation returns the same URI for *all* token types. It relies
452      * on the token type ID substitution mechanism
453      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
454      *
455      * Clients calling this function must replace the `\{id\}` substring with the
456      * actual token type ID.
457      */
458     function uri(uint256) public view virtual override returns (string memory) {
459         return _uri;
460     }
461 
462     /**
463      * @dev See {IERC1155-balanceOf}.
464      *
465      * Requirements:
466      *
467      * - `account` cannot be the zero address.
468      */
469     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
470         require(account != address(0), "ERC1155: balance query for the zero address");
471         return _balances[id][account];
472     }
473 
474     /**
475      * @dev See {IERC1155-balanceOfBatch}.
476      *
477      * Requirements:
478      *
479      * - `accounts` and `ids` must have the same length.
480      */
481     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
482         public
483         view
484         virtual
485         override
486         returns (uint256[] memory)
487     {
488         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
489 
490         uint256[] memory batchBalances = new uint256[](accounts.length);
491 
492         for (uint256 i = 0; i < accounts.length; ++i) {
493             batchBalances[i] = balanceOf(accounts[i], ids[i]);
494         }
495 
496         return batchBalances;
497     }
498 
499     /**
500      * @dev See {IERC1155-setApprovalForAll}.
501      */
502     function setApprovalForAll(address operator, bool approved) public virtual override {
503         require(_msgSender() != operator, "ERC1155: setting approval status for self");
504 
505         _operatorApprovals[_msgSender()][operator] = approved;
506         emit ApprovalForAll(_msgSender(), operator, approved);
507     }
508 
509     /**
510      * @dev See {IERC1155-isApprovedForAll}.
511      */
512     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
513         return _operatorApprovals[account][operator];
514     }
515 
516     /**
517      * @dev See {IERC1155-safeTransferFrom}.
518      */
519     function safeTransferFrom(
520         address from,
521         address to,
522         uint256 id,
523         uint256 amount,
524         bytes memory data
525     ) public virtual override {
526         require(
527             from == _msgSender() || isApprovedForAll(from, _msgSender()),
528             "ERC1155: caller is not owner nor approved"
529         );
530         _safeTransferFrom(from, to, id, amount, data);
531     }
532 
533     /**
534      * @dev See {IERC1155-safeBatchTransferFrom}.
535      */
536     function safeBatchTransferFrom(
537         address from,
538         address to,
539         uint256[] memory ids,
540         uint256[] memory amounts,
541         bytes memory data
542     ) public virtual override {
543         require(
544             from == _msgSender() || isApprovedForAll(from, _msgSender()),
545             "ERC1155: transfer caller is not owner nor approved"
546         );
547         _safeBatchTransferFrom(from, to, ids, amounts, data);
548     }
549 
550     /**
551      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
552      *
553      * Emits a {TransferSingle} event.
554      *
555      * Requirements:
556      *
557      * - `to` cannot be the zero address.
558      * - `from` must have a balance of tokens of type `id` of at least `amount`.
559      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
560      * acceptance magic value.
561      */
562     function _safeTransferFrom(
563         address from,
564         address to,
565         uint256 id,
566         uint256 amount,
567         bytes memory data
568     ) internal virtual {
569         require(to != address(0), "ERC1155: transfer to the zero address");
570 
571         address operator = _msgSender();
572 
573         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
574 
575         uint256 fromBalance = _balances[id][from];
576         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
577         unchecked {
578             _balances[id][from] = fromBalance - amount;
579         }
580         _balances[id][to] += amount;
581 
582         emit TransferSingle(operator, from, to, id, amount);
583 
584         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
585     }
586 
587     /**
588      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
589      *
590      * Emits a {TransferBatch} event.
591      *
592      * Requirements:
593      *
594      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
595      * acceptance magic value.
596      */
597     function _safeBatchTransferFrom(
598         address from,
599         address to,
600         uint256[] memory ids,
601         uint256[] memory amounts,
602         bytes memory data
603     ) internal virtual {
604         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
605         require(to != address(0), "ERC1155: transfer to the zero address");
606 
607         address operator = _msgSender();
608 
609         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
610 
611         for (uint256 i = 0; i < ids.length; ++i) {
612             uint256 id = ids[i];
613             uint256 amount = amounts[i];
614 
615             uint256 fromBalance = _balances[id][from];
616             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
617             unchecked {
618                 _balances[id][from] = fromBalance - amount;
619             }
620             _balances[id][to] += amount;
621         }
622 
623         emit TransferBatch(operator, from, to, ids, amounts);
624 
625         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
626     }
627 
628     /**
629      * @dev Sets a new URI for all token types, by relying on the token type ID
630      * substitution mechanism
631      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
632      *
633      * By this mechanism, any occurrence of the `\{id\}` substring in either the
634      * URI or any of the amounts in the JSON file at said URI will be replaced by
635      * clients with the token type ID.
636      *
637      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
638      * interpreted by clients as
639      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
640      * for token type ID 0x4cce0.
641      *
642      * See {uri}.
643      *
644      * Because these URIs cannot be meaningfully represented by the {URI} event,
645      * this function emits no events.
646      */
647     function _setURI(string memory newuri) internal virtual {
648         _uri = newuri;
649     }
650 
651     /**
652      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
653      *
654      * Emits a {TransferSingle} event.
655      *
656      * Requirements:
657      *
658      * - `account` cannot be the zero address.
659      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
660      * acceptance magic value.
661      */
662     function _mint(
663         address account,
664         uint256 id,
665         uint256 amount,
666         bytes memory data
667     ) internal virtual {
668         require(account != address(0), "ERC1155: mint to the zero address");
669 
670         address operator = _msgSender();
671 
672         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
673 
674         _balances[id][account] += amount;
675         emit TransferSingle(operator, address(0), account, id, amount);
676 
677         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
678     }
679 
680     /**
681      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
682      *
683      * Requirements:
684      *
685      * - `ids` and `amounts` must have the same length.
686      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
687      * acceptance magic value.
688      */
689     function _mintBatch(
690         address to,
691         uint256[] memory ids,
692         uint256[] memory amounts,
693         bytes memory data
694     ) internal virtual {
695         require(to != address(0), "ERC1155: mint to the zero address");
696         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
697 
698         address operator = _msgSender();
699 
700         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
701 
702         for (uint256 i = 0; i < ids.length; i++) {
703             _balances[ids[i]][to] += amounts[i];
704         }
705 
706         emit TransferBatch(operator, address(0), to, ids, amounts);
707 
708         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
709     }
710 
711     /**
712      * @dev Destroys `amount` tokens of token type `id` from `account`
713      *
714      * Requirements:
715      *
716      * - `account` cannot be the zero address.
717      * - `account` must have at least `amount` tokens of token type `id`.
718      */
719     function _burn(
720         address account,
721         uint256 id,
722         uint256 amount
723     ) internal virtual {
724         require(account != address(0), "ERC1155: burn from the zero address");
725 
726         address operator = _msgSender();
727 
728         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
729 
730         uint256 accountBalance = _balances[id][account];
731         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
732         unchecked {
733             _balances[id][account] = accountBalance - amount;
734         }
735 
736         emit TransferSingle(operator, account, address(0), id, amount);
737     }
738 
739     /**
740      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
741      *
742      * Requirements:
743      *
744      * - `ids` and `amounts` must have the same length.
745      */
746     function _burnBatch(
747         address account,
748         uint256[] memory ids,
749         uint256[] memory amounts
750     ) internal virtual {
751         require(account != address(0), "ERC1155: burn from the zero address");
752         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
753 
754         address operator = _msgSender();
755 
756         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
757 
758         for (uint256 i = 0; i < ids.length; i++) {
759             uint256 id = ids[i];
760             uint256 amount = amounts[i];
761 
762             uint256 accountBalance = _balances[id][account];
763             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
764             unchecked {
765                 _balances[id][account] = accountBalance - amount;
766             }
767         }
768 
769         emit TransferBatch(operator, account, address(0), ids, amounts);
770     }
771 
772     /**
773      * @dev Hook that is called before any token transfer. This includes minting
774      * and burning, as well as batched variants.
775      *
776      * The same hook is called on both single and batched variants. For single
777      * transfers, the length of the `id` and `amount` arrays will be 1.
778      *
779      * Calling conditions (for each `id` and `amount` pair):
780      *
781      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
782      * of token type `id` will be  transferred to `to`.
783      * - When `from` is zero, `amount` tokens of token type `id` will be minted
784      * for `to`.
785      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
786      * will be burned.
787      * - `from` and `to` are never both zero.
788      * - `ids` and `amounts` have the same, non-zero length.
789      *
790      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
791      */
792     function _beforeTokenTransfer(
793         address operator,
794         address from,
795         address to,
796         uint256[] memory ids,
797         uint256[] memory amounts,
798         bytes memory data
799     ) internal virtual {}
800 
801     function _doSafeTransferAcceptanceCheck(
802         address operator,
803         address from,
804         address to,
805         uint256 id,
806         uint256 amount,
807         bytes memory data
808     ) private {
809         if (to.isContract()) {
810             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
811                 if (response != IERC1155Receiver.onERC1155Received.selector) {
812                     revert("ERC1155: ERC1155Receiver rejected tokens");
813                 }
814             } catch Error(string memory reason) {
815                 revert(reason);
816             } catch {
817                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
818             }
819         }
820     }
821 
822     function _doSafeBatchTransferAcceptanceCheck(
823         address operator,
824         address from,
825         address to,
826         uint256[] memory ids,
827         uint256[] memory amounts,
828         bytes memory data
829     ) private {
830         if (to.isContract()) {
831             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
832                 bytes4 response
833             ) {
834                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
835                     revert("ERC1155: ERC1155Receiver rejected tokens");
836                 }
837             } catch Error(string memory reason) {
838                 revert(reason);
839             } catch {
840                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
841             }
842         }
843     }
844 
845     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
846         uint256[] memory array = new uint256[](1);
847         array[0] = element;
848 
849         return array;
850     }
851 }
852 
853 
854 /**
855  * @dev Contract module which provides a basic access control mechanism, where
856  * there is an account (an owner) that can be granted exclusive access to
857  * specific functions.
858  *
859  * By default, the owner account will be the one that deploys the contract. This
860  * can later be changed with {transferOwnership}.
861  *
862  * This module is used through inheritance. It will make available the modifier
863  * `onlyOwner`, which can be applied to your functions to restrict their use to
864  * the owner.
865  */
866 abstract contract Ownable is Context {
867     address private _owner;
868 
869     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
870 
871     /**
872      * @dev Initializes the contract setting the deployer as the initial owner.
873      */
874     constructor() {
875         _setOwner(_msgSender());
876     }
877 
878     /**
879      * @dev Returns the address of the current owner.
880      */
881     function owner() public view virtual returns (address) {
882         return _owner;
883     }
884 
885     /**
886      * @dev Throws if called by any account other than the owner.
887      */
888     modifier onlyOwner() {
889         require(owner() == _msgSender(), "Ownable: caller is not the owner");
890         _;
891     }
892 
893     /**
894      * @dev Leaves the contract without owner. It will not be possible to call
895      * `onlyOwner` functions anymore. Can only be called by the current owner.
896      *
897      * NOTE: Renouncing ownership will leave the contract without an owner,
898      * thereby removing any functionality that is only available to the owner.
899      */
900     function renounceOwnership() public virtual onlyOwner {
901         _setOwner(address(0));
902     }
903 
904     /**
905      * @dev Transfers ownership of the contract to a new account (`newOwner`).
906      * Can only be called by the current owner.
907      */
908     function transferOwnership(address newOwner) public virtual onlyOwner {
909         require(newOwner != address(0), "Ownable: new owner is the zero address");
910         _setOwner(newOwner);
911     }
912 
913     function _setOwner(address newOwner) private {
914         address oldOwner = _owner;
915         _owner = newOwner;
916         emit OwnershipTransferred(oldOwner, newOwner);
917     }
918 }
919 
920 library Strings {
921     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
922 
923     /**
924      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
925      */
926     function toString(uint256 value) internal pure returns (string memory) {
927         // Inspired by OraclizeAPI's implementation - MIT licence
928         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
929 
930         if (value == 0) {
931             return "0";
932         }
933         uint256 temp = value;
934         uint256 digits;
935         while (temp != 0) {
936             digits++;
937             temp /= 10;
938         }
939         bytes memory buffer = new bytes(digits);
940         while (value != 0) {
941             digits -= 1;
942             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
943             value /= 10;
944         }
945         return string(buffer);
946     }
947 
948     /**
949      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
950      */
951     function toHexString(uint256 value) internal pure returns (string memory) {
952         if (value == 0) {
953             return "0x00";
954         }
955         uint256 temp = value;
956         uint256 length = 0;
957         while (temp != 0) {
958             length++;
959             temp >>= 8;
960         }
961         return toHexString(value, length);
962     }
963 
964     /**
965      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
966      */
967     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
968         bytes memory buffer = new bytes(2 * length + 2);
969         buffer[0] = "0";
970         buffer[1] = "x";
971         for (uint256 i = 2 * length + 1; i > 1; --i) {
972             buffer[i] = _HEX_SYMBOLS[value & 0xf];
973             value >>= 4;
974         }
975         require(value == 0, "Strings: hex length insufficient");
976         return string(buffer);
977     }
978 }
979 
980 
981 contract LlamaPass is ERC1155, Ownable {
982     // TODO: Will generate a new one for real deployment
983     address private passwordSigner = 0xbBaA67D208F4c5fCa149060ff584DD0E88852C95;
984 
985     uint private constant GOLD_PASS_ID = 1;
986     uint private constant SILVER_PASS_ID = 2;
987 
988     string public name = "Llama Pass";
989     string public symbol = "LLP";
990 
991     uint16 private maxGoldPasses = 500;
992     uint16 private maxSilverPasses = 3500;
993 
994     uint16 private currentGoldPassCount = 0;
995     uint16 private currentSilverPassCount = 0;
996 
997     uint private silverPassPrice = 0.75 ether;
998     uint private goldPassPrice = 5 ether;
999 
1000     bool public sale = false;
1001 
1002     string private baseUri = "ipfs://QmZEMXDzfHDtEiYbHcUtyQ7gVmnvMT6VoNfDX7Ztsdc7b2/";
1003 
1004     mapping (address => bool) public alreadyMinted;
1005 
1006     constructor() ERC1155("") {}
1007 
1008     function withdrawEther(address payable _to, uint _amount) public onlyOwner {
1009         _to.transfer(_amount);
1010     }
1011 
1012     function setBaseURI(string memory newBaseUri) external onlyOwner {
1013         baseUri = newBaseUri;
1014     }
1015 
1016     function uri(uint id) public view virtual override returns (string memory) {
1017         return string(abi.encodePacked(baseUri, Strings.toString(id)));
1018     }
1019 
1020     function buy(uint16 tokenId) public payable {
1021         require(sale, "Sale not open");
1022         require(tokenId == GOLD_PASS_ID ? currentGoldPassCount + 1 <= maxGoldPasses : currentSilverPassCount + 1 <= maxSilverPasses, "Max supply");
1023         require(!alreadyMinted[msg.sender], "Double mint");
1024         require(tokenId == GOLD_PASS_ID || tokenId == SILVER_PASS_ID, "Bad ID");
1025         require(msg.value >= getPassPrice(tokenId), "Wrong amt");
1026 
1027         tokenId == GOLD_PASS_ID ? currentGoldPassCount++ : currentSilverPassCount++;         
1028         alreadyMinted[msg.sender] = true;
1029 
1030         _mint(msg.sender, tokenId, 1, "");
1031     }
1032 
1033     function setSale() external onlyOwner {
1034         sale = !sale;
1035     }
1036 
1037     function mint(uint16 tokenId, bytes memory signature) public {
1038         require(tokenId == 1 || tokenId == 2, "Bad ID");
1039         require(tokenId == GOLD_PASS_ID ? currentGoldPassCount + 1 <= maxGoldPasses : currentSilverPassCount + 1 <= maxSilverPasses, "Max supply");
1040 
1041         require(isWhitelisted(msg.sender, tokenId, signature), "Not whitelisted");
1042         require(!alreadyMinted[msg.sender], "Double mint");
1043 
1044         tokenId == GOLD_PASS_ID ? currentGoldPassCount++ : currentSilverPassCount++; 
1045         alreadyMinted[msg.sender] = true;
1046 
1047         _mint(msg.sender, tokenId, 1, "");
1048     }
1049 
1050     function claimToAdmin(uint16 tokenId, uint16 tokenAmt) public onlyOwner {
1051         _mint(msg.sender, tokenId, tokenAmt, "");
1052         tokenId == GOLD_PASS_ID ? currentGoldPassCount+=tokenAmt : currentSilverPassCount+=tokenAmt;     
1053     }
1054 
1055     function isWhitelisted(address user, uint16 tokenId, bytes memory signature) public view returns (bool) {
1056         bytes32 messageHash = keccak256(abi.encode(user, tokenId));
1057         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
1058 
1059         return recoverSigner(ethSignedMessageHash, signature) == passwordSigner;
1060     }
1061 
1062     function getEthSignedMessageHash(bytes32 _messageHash) private pure returns (bytes32) {
1063         /*
1064         Signature is produced by signing a keccak256 hash with the following format:
1065         "\x19Ethereum Signed Message\n" + len(msg) + msg
1066         */
1067         return
1068         keccak256(
1069             abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
1070         );
1071     }
1072 
1073     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) private pure returns (address) {
1074         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1075         return ecrecover(_ethSignedMessageHash, v, r, s);
1076     }
1077 
1078     function splitSignature(bytes memory sig) private pure returns (bytes32 r, bytes32 s, uint8 v) {
1079         require(sig.length == 65, "sig invalid");
1080 
1081         assembly {
1082         /*
1083         First 32 bytes stores the length of the signature
1084 
1085         add(sig, 32) = pointer of sig + 32
1086         effectively, skips first 32 bytes of signature
1087 
1088         mload(p) loads next 32 bytes starting at the memory address p into memory
1089         */
1090 
1091         // first 32 bytes, after the length prefix
1092             r := mload(add(sig, 32))
1093         // second 32 bytes
1094             s := mload(add(sig, 64))
1095         // final byte (first byte of the next 32 bytes)
1096             v := byte(0, mload(add(sig, 96)))
1097         }
1098 
1099         // implicitly return (r, s, v)
1100     }
1101     
1102     function getPassTotalSupply(uint tokenId) public view returns (uint256) {
1103         if(tokenId == GOLD_PASS_ID) {
1104             return maxGoldPasses;
1105         }
1106         return maxSilverPasses;
1107     }
1108     
1109     function getPassSupply(uint tokenId) public view returns (uint256) {
1110         if(tokenId == GOLD_PASS_ID) {
1111             return currentGoldPassCount;
1112         }
1113         return currentSilverPassCount;
1114     }
1115     
1116     function getPassPrice(uint tokenId) public view returns (uint256) {
1117         if(tokenId == GOLD_PASS_ID) {
1118             return goldPassPrice;
1119         }
1120         return silverPassPrice;
1121     }
1122     
1123     function setPassPrice(uint tokenId, uint price) external onlyOwner {
1124         if(tokenId == GOLD_PASS_ID)
1125             goldPassPrice = price;
1126         else
1127             silverPassPrice = price;
1128     }
1129 }