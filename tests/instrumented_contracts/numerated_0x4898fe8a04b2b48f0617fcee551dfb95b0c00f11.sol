1 // Sources flattened with hardhat v2.4.1 https://hardhat.org
2 
3 // SPDX-License-Identifier: UNLICENSED
4 
5 pragma solidity ^0.8.4;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 /**
29  * @dev Required interface of an ERC1155 compliant contract, as defined in the
30  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
31  *
32  * _Available since v3.1._
33  */
34 interface IERC1155 is IERC165 {
35     /**
36      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
37      */
38     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
39 
40     /**
41      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
42      * transfers.
43      */
44     event TransferBatch(
45         address indexed operator,
46         address indexed from,
47         address indexed to,
48         uint256[] ids,
49         uint256[] values
50     );
51 
52     /**
53      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
54      * `approved`.
55      */
56     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
57 
58     /**
59      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
60      *
61      * If an {URI} event was emitted for `id`, the standard
62      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
63      * returned by {IERC1155MetadataURI-uri}.
64      */
65     event URI(string value, uint256 indexed id);
66 
67     /**
68      * @dev Returns the amount of tokens of token type `id` owned by `account`.
69      *
70      * Requirements:
71      *
72      * - `account` cannot be the zero address.
73      */
74     function balanceOf(address account, uint256 id) external view returns (uint256);
75 
76     /**
77      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
78      *
79      * Requirements:
80      *
81      * - `accounts` and `ids` must have the same length.
82      */
83     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
84         external
85         view
86         returns (uint256[] memory);
87 
88     /**
89      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
90      *
91      * Emits an {ApprovalForAll} event.
92      *
93      * Requirements:
94      *
95      * - `operator` cannot be the caller.
96      */
97     function setApprovalForAll(address operator, bool approved) external;
98 
99     /**
100      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
101      *
102      * See {setApprovalForAll}.
103      */
104     function isApprovedForAll(address account, address operator) external view returns (bool);
105 
106     /**
107      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
108      *
109      * Emits a {TransferSingle} event.
110      *
111      * Requirements:
112      *
113      * - `to` cannot be the zero address.
114      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
115      * - `from` must have a balance of tokens of type `id` of at least `amount`.
116      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
117      * acceptance magic value.
118      */
119     function safeTransferFrom(
120         address from,
121         address to,
122         uint256 id,
123         uint256 amount,
124         bytes calldata data
125     ) external;
126 
127     /**
128      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
129      *
130      * Emits a {TransferBatch} event.
131      *
132      * Requirements:
133      *
134      * - `ids` and `amounts` must have the same length.
135      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
136      * acceptance magic value.
137      */
138     function safeBatchTransferFrom(
139         address from,
140         address to,
141         uint256[] calldata ids,
142         uint256[] calldata amounts,
143         bytes calldata data
144     ) external;
145 }
146 
147 /**
148  * @dev _Available since v3.1._
149  */
150 interface IERC1155Receiver is IERC165 {
151     /**
152         @dev Handles the receipt of a single ERC1155 token type. This function is
153         called at the end of a `safeTransferFrom` after the balance has been updated.
154         To accept the transfer, this must return
155         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
156         (i.e. 0xf23a6e61, or its own function selector).
157         @param operator The address which initiated the transfer (i.e. msg.sender)
158         @param from The address which previously owned the token
159         @param id The ID of the token being transferred
160         @param value The amount of tokens being transferred
161         @param data Additional data with no specified format
162         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
163     */
164     function onERC1155Received(
165         address operator,
166         address from,
167         uint256 id,
168         uint256 value,
169         bytes calldata data
170     ) external returns (bytes4);
171 
172     /**
173         @dev Handles the receipt of a multiple ERC1155 token types. This function
174         is called at the end of a `safeBatchTransferFrom` after the balances have
175         been updated. To accept the transfer(s), this must return
176         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
177         (i.e. 0xbc197c81, or its own function selector).
178         @param operator The address which initiated the batch transfer (i.e. msg.sender)
179         @param from The address which previously owned the token
180         @param ids An array containing ids of each token being transferred (order and length must match values array)
181         @param values An array containing amounts of each token being transferred (order and length must match ids array)
182         @param data Additional data with no specified format
183         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
184     */
185     function onERC1155BatchReceived(
186         address operator,
187         address from,
188         uint256[] calldata ids,
189         uint256[] calldata values,
190         bytes calldata data
191     ) external returns (bytes4);
192 }
193 
194 /**
195  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
196  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
197  *
198  * _Available since v3.1._
199  */
200 interface IERC1155MetadataURI is IERC1155 {
201     /**
202      * @dev Returns the URI for token type `id`.
203      *
204      * If the `\{id\}` substring is present in the URI, it must be replaced by
205      * clients with the actual token type ID.
206      */
207     function uri(uint256 id) external view returns (string memory);
208 }
209 
210 /**
211  * @dev Collection of functions related to the address type
212  */
213 library Address {
214     /**
215      * @dev Returns true if `account` is a contract.
216      *
217      * [IMPORTANT]
218      * ====
219      * It is unsafe to assume that an address for which this function returns
220      * false is an externally-owned account (EOA) and not a contract.
221      *
222      * Among others, `isContract` will return false for the following
223      * types of addresses:
224      *
225      *  - an externally-owned account
226      *  - a contract in construction
227      *  - an address where a contract will be created
228      *  - an address where a contract lived, but was destroyed
229      * ====
230      */
231     function isContract(address account) internal view returns (bool) {
232         // This method relies on extcodesize, which returns 0 for contracts in
233         // construction, since the code is only stored at the end of the
234         // constructor execution.
235 
236         uint256 size;
237         assembly {
238             size := extcodesize(account)
239         }
240         return size > 0;
241     }
242 
243     /**
244      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
245      * `recipient`, forwarding all available gas and reverting on errors.
246      *
247      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
248      * of certain opcodes, possibly making contracts go over the 2300 gas limit
249      * imposed by `transfer`, making them unable to receive funds via
250      * `transfer`. {sendValue} removes this limitation.
251      *
252      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
253      *
254      * IMPORTANT: because control is transferred to `recipient`, care must be
255      * taken to not create reentrancy vulnerabilities. Consider using
256      * {ReentrancyGuard} or the
257      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
258      */
259     function sendValue(address payable recipient, uint256 amount) internal {
260         require(address(this).balance >= amount, "Address: insufficient balance");
261 
262         (bool success, ) = recipient.call{value: amount}("");
263         require(success, "Address: unable to send value, recipient may have reverted");
264     }
265 
266     /**
267      * @dev Performs a Solidity function call using a low level `call`. A
268      * plain `call` is an unsafe replacement for a function call: use this
269      * function instead.
270      *
271      * If `target` reverts with a revert reason, it is bubbled up by this
272      * function (like regular Solidity function calls).
273      *
274      * Returns the raw returned data. To convert to the expected return value,
275      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
276      *
277      * Requirements:
278      *
279      * - `target` must be a contract.
280      * - calling `target` with `data` must not revert.
281      *
282      * _Available since v3.1._
283      */
284     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionCall(target, data, "Address: low-level call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
290      * `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, 0, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but also transferring `value` wei to `target`.
305      *
306      * Requirements:
307      *
308      * - the calling contract must have an ETH balance of at least `value`.
309      * - the called Solidity function must be `payable`.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(
314         address target,
315         bytes memory data,
316         uint256 value
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
323      * with `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(
328         address target,
329         bytes memory data,
330         uint256 value,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         require(address(this).balance >= value, "Address: insufficient balance for call");
334         require(isContract(target), "Address: call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.call{value: value}(data);
337         return _verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
347         return functionStaticCall(target, data, "Address: low-level static call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal view returns (bytes memory) {
361         require(isContract(target), "Address: static call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.staticcall(data);
364         return _verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.4._
382      */
383     function functionDelegateCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         require(isContract(target), "Address: delegate call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.delegatecall(data);
391         return _verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     function _verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) private pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
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
417 /*
418  * @dev Provides information about the current execution context, including the
419  * sender of the transaction and its data. While these are generally available
420  * via msg.sender and msg.data, they should not be accessed in such a direct
421  * manner, since when dealing with meta-transactions the account sending and
422  * paying for execution may not be the actual sender (as far as an application
423  * is concerned).
424  *
425  * This contract is only required for intermediate, library-like contracts.
426  */
427 abstract contract Context {
428     function _msgSender() internal view virtual returns (address) {
429         return msg.sender;
430     }
431 
432     function _msgData() internal view virtual returns (bytes calldata) {
433         return msg.data;
434     }
435 }
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
460 
461 
462 
463 
464 
465 /**
466  * @dev Implementation of the basic standard multi-token.
467  * See https://eips.ethereum.org/EIPS/eip-1155
468  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
469  *
470  * _Available since v3.1._
471  */
472 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
473     using Address for address;
474 
475     // Mapping from token ID to account balances
476     mapping(uint256 => mapping(address => uint256)) private _balances;
477 
478     // Mapping from account to operator approvals
479     mapping(address => mapping(address => bool)) private _operatorApprovals;
480 
481     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
482     string private _uri;
483 
484     /**
485      * @dev See {_setURI}.
486      */
487     constructor(string memory uri_) {
488         _setURI(uri_);
489     }
490 
491     /**
492      * @dev See {IERC165-supportsInterface}.
493      */
494     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
495         return
496             interfaceId == type(IERC1155).interfaceId ||
497             interfaceId == type(IERC1155MetadataURI).interfaceId ||
498             super.supportsInterface(interfaceId);
499     }
500 
501     /**
502      * @dev See {IERC1155MetadataURI-uri}.
503      *
504      * This implementation returns the same URI for *all* token types. It relies
505      * on the token type ID substitution mechanism
506      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
507      *
508      * Clients calling this function must replace the `\{id\}` substring with the
509      * actual token type ID.
510      */
511     function uri(uint256) public view virtual override returns (string memory) {
512         return _uri;
513     }
514 
515     /**
516      * @dev See {IERC1155-balanceOf}.
517      *
518      * Requirements:
519      *
520      * - `account` cannot be the zero address.
521      */
522     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
523         require(account != address(0), "ERC1155: balance query for the zero address");
524         return _balances[id][account];
525     }
526 
527     /**
528      * @dev See {IERC1155-balanceOfBatch}.
529      *
530      * Requirements:
531      *
532      * - `accounts` and `ids` must have the same length.
533      */
534     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
535         public
536         view
537         virtual
538         override
539         returns (uint256[] memory)
540     {
541         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
542 
543         uint256[] memory batchBalances = new uint256[](accounts.length);
544 
545         for (uint256 i = 0; i < accounts.length; ++i) {
546             batchBalances[i] = balanceOf(accounts[i], ids[i]);
547         }
548 
549         return batchBalances;
550     }
551 
552     /**
553      * @dev See {IERC1155-setApprovalForAll}.
554      */
555     function setApprovalForAll(address operator, bool approved) public virtual override {
556         require(_msgSender() != operator, "ERC1155: setting approval status for self");
557 
558         _operatorApprovals[_msgSender()][operator] = approved;
559         emit ApprovalForAll(_msgSender(), operator, approved);
560     }
561 
562     /**
563      * @dev See {IERC1155-isApprovedForAll}.
564      */
565     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
566         return _operatorApprovals[account][operator];
567     }
568 
569     /**
570      * @dev See {IERC1155-safeTransferFrom}.
571      */
572     function safeTransferFrom(
573         address from,
574         address to,
575         uint256 id,
576         uint256 amount,
577         bytes memory data
578     ) public virtual override {
579         require(
580             from == _msgSender() || isApprovedForAll(from, _msgSender()),
581             "ERC1155: caller is not owner nor approved"
582         );
583         _safeTransferFrom(from, to, id, amount, data);
584     }
585 
586     /**
587      * @dev See {IERC1155-safeBatchTransferFrom}.
588      */
589     function safeBatchTransferFrom(
590         address from,
591         address to,
592         uint256[] memory ids,
593         uint256[] memory amounts,
594         bytes memory data
595     ) public virtual override {
596         require(
597             from == _msgSender() || isApprovedForAll(from, _msgSender()),
598             "ERC1155: transfer caller is not owner nor approved"
599         );
600         _safeBatchTransferFrom(from, to, ids, amounts, data);
601     }
602 
603     /**
604      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
605      *
606      * Emits a {TransferSingle} event.
607      *
608      * Requirements:
609      *
610      * - `to` cannot be the zero address.
611      * - `from` must have a balance of tokens of type `id` of at least `amount`.
612      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
613      * acceptance magic value.
614      */
615     function _safeTransferFrom(
616         address from,
617         address to,
618         uint256 id,
619         uint256 amount,
620         bytes memory data
621     ) internal virtual {
622         require(to != address(0), "ERC1155: transfer to the zero address");
623 
624         address operator = _msgSender();
625 
626         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
627 
628         uint256 fromBalance = _balances[id][from];
629         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
630         unchecked {
631             _balances[id][from] = fromBalance - amount;
632         }
633         _balances[id][to] += amount;
634 
635         emit TransferSingle(operator, from, to, id, amount);
636 
637         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
638     }
639 
640     /**
641      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
642      *
643      * Emits a {TransferBatch} event.
644      *
645      * Requirements:
646      *
647      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
648      * acceptance magic value.
649      */
650     function _safeBatchTransferFrom(
651         address from,
652         address to,
653         uint256[] memory ids,
654         uint256[] memory amounts,
655         bytes memory data
656     ) internal virtual {
657         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
658         require(to != address(0), "ERC1155: transfer to the zero address");
659 
660         address operator = _msgSender();
661 
662         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
663 
664         for (uint256 i = 0; i < ids.length; ++i) {
665             uint256 id = ids[i];
666             uint256 amount = amounts[i];
667 
668             uint256 fromBalance = _balances[id][from];
669             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
670             unchecked {
671                 _balances[id][from] = fromBalance - amount;
672             }
673             _balances[id][to] += amount;
674         }
675 
676         emit TransferBatch(operator, from, to, ids, amounts);
677 
678         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
679     }
680 
681     /**
682      * @dev Sets a new URI for all token types, by relying on the token type ID
683      * substitution mechanism
684      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
685      *
686      * By this mechanism, any occurrence of the `\{id\}` substring in either the
687      * URI or any of the amounts in the JSON file at said URI will be replaced by
688      * clients with the token type ID.
689      *
690      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
691      * interpreted by clients as
692      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
693      * for token type ID 0x4cce0.
694      *
695      * See {uri}.
696      *
697      * Because these URIs cannot be meaningfully represented by the {URI} event,
698      * this function emits no events.
699      */
700     function _setURI(string memory newuri) internal virtual {
701         _uri = newuri;
702     }
703 
704     /**
705      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
706      *
707      * Emits a {TransferSingle} event.
708      *
709      * Requirements:
710      *
711      * - `account` cannot be the zero address.
712      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
713      * acceptance magic value.
714      */
715     function _mint(
716         address account,
717         uint256 id,
718         uint256 amount,
719         bytes memory data
720     ) internal virtual {
721         require(account != address(0), "ERC1155: mint to the zero address");
722 
723         address operator = _msgSender();
724 
725         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
726 
727         _balances[id][account] += amount;
728         emit TransferSingle(operator, address(0), account, id, amount);
729 
730         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
731     }
732 
733     /**
734      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
735      *
736      * Requirements:
737      *
738      * - `ids` and `amounts` must have the same length.
739      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
740      * acceptance magic value.
741      */
742     function _mintBatch(
743         address to,
744         uint256[] memory ids,
745         uint256[] memory amounts,
746         bytes memory data
747     ) internal virtual {
748         require(to != address(0), "ERC1155: mint to the zero address");
749         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
750 
751         address operator = _msgSender();
752 
753         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
754 
755         for (uint256 i = 0; i < ids.length; i++) {
756             _balances[ids[i]][to] += amounts[i];
757         }
758 
759         emit TransferBatch(operator, address(0), to, ids, amounts);
760 
761         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
762     }
763 
764     /**
765      * @dev Destroys `amount` tokens of token type `id` from `account`
766      *
767      * Requirements:
768      *
769      * - `account` cannot be the zero address.
770      * - `account` must have at least `amount` tokens of token type `id`.
771      */
772     function _burn(
773         address account,
774         uint256 id,
775         uint256 amount
776     ) internal virtual {
777         require(account != address(0), "ERC1155: burn from the zero address");
778 
779         address operator = _msgSender();
780 
781         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
782 
783         uint256 accountBalance = _balances[id][account];
784         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
785         unchecked {
786             _balances[id][account] = accountBalance - amount;
787         }
788 
789         emit TransferSingle(operator, account, address(0), id, amount);
790     }
791 
792     /**
793      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
794      *
795      * Requirements:
796      *
797      * - `ids` and `amounts` must have the same length.
798      */
799     function _burnBatch(
800         address account,
801         uint256[] memory ids,
802         uint256[] memory amounts
803     ) internal virtual {
804         require(account != address(0), "ERC1155: burn from the zero address");
805         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
806 
807         address operator = _msgSender();
808 
809         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
810 
811         for (uint256 i = 0; i < ids.length; i++) {
812             uint256 id = ids[i];
813             uint256 amount = amounts[i];
814 
815             uint256 accountBalance = _balances[id][account];
816             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
817             unchecked {
818                 _balances[id][account] = accountBalance - amount;
819             }
820         }
821 
822         emit TransferBatch(operator, account, address(0), ids, amounts);
823     }
824 
825     /**
826      * @dev Hook that is called before any token transfer. This includes minting
827      * and burning, as well as batched variants.
828      *
829      * The same hook is called on both single and batched variants. For single
830      * transfers, the length of the `id` and `amount` arrays will be 1.
831      *
832      * Calling conditions (for each `id` and `amount` pair):
833      *
834      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
835      * of token type `id` will be  transferred to `to`.
836      * - When `from` is zero, `amount` tokens of token type `id` will be minted
837      * for `to`.
838      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
839      * will be burned.
840      * - `from` and `to` are never both zero.
841      * - `ids` and `amounts` have the same, non-zero length.
842      *
843      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
844      */
845     function _beforeTokenTransfer(
846         address operator,
847         address from,
848         address to,
849         uint256[] memory ids,
850         uint256[] memory amounts,
851         bytes memory data
852     ) internal virtual {}
853 
854     function _doSafeTransferAcceptanceCheck(
855         address operator,
856         address from,
857         address to,
858         uint256 id,
859         uint256 amount,
860         bytes memory data
861     ) private {
862         if (to.isContract()) {
863             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
864                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
865                     revert("ERC1155: ERC1155Receiver rejected tokens");
866                 }
867             } catch Error(string memory reason) {
868                 revert(reason);
869             } catch {
870                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
871             }
872         }
873     }
874 
875     function _doSafeBatchTransferAcceptanceCheck(
876         address operator,
877         address from,
878         address to,
879         uint256[] memory ids,
880         uint256[] memory amounts,
881         bytes memory data
882     ) private {
883         if (to.isContract()) {
884             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
885                 bytes4 response
886             ) {
887                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
888                     revert("ERC1155: ERC1155Receiver rejected tokens");
889                 }
890             } catch Error(string memory reason) {
891                 revert(reason);
892             } catch {
893                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
894             }
895         }
896     }
897 
898     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
899         uint256[] memory array = new uint256[](1);
900         array[0] = element;
901 
902         return array;
903     }
904 }
905 
906 /**
907  * @dev Contract module that helps prevent reentrant calls to a function.
908  *
909  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
910  * available, which can be applied to functions to make sure there are no nested
911  * (reentrant) calls to them.
912  *
913  * Note that because there is a single `nonReentrant` guard, functions marked as
914  * `nonReentrant` may not call one another. This can be worked around by making
915  * those functions `private`, and then adding `external` `nonReentrant` entry
916  * points to them.
917  *
918  * TIP: If you would like to learn more about reentrancy and alternative ways
919  * to protect against it, check out our blog post
920  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
921  */
922 abstract contract ReentrancyGuard {
923     // Booleans are more expensive than uint256 or any type that takes up a full
924     // word because each write operation emits an extra SLOAD to first read the
925     // slot's contents, replace the bits taken up by the boolean, and then write
926     // back. This is the compiler's defense against contract upgrades and
927     // pointer aliasing, and it cannot be disabled.
928 
929     // The values being non-zero value makes deployment a bit more expensive,
930     // but in exchange the refund on every call to nonReentrant will be lower in
931     // amount. Since refunds are capped to a percentage of the total
932     // transaction's gas, it is best to keep them low in cases like this one, to
933     // increase the likelihood of the full refund coming into effect.
934     uint256 private constant _NOT_ENTERED = 1;
935     uint256 private constant _ENTERED = 2;
936 
937     uint256 private _status;
938 
939     constructor() {
940         _status = _NOT_ENTERED;
941     }
942 
943     /**
944      * @dev Prevents a contract from calling itself, directly or indirectly.
945      * Calling a `nonReentrant` function from another `nonReentrant`
946      * function is not supported. It is possible to prevent this from happening
947      * by making the `nonReentrant` function external, and make it call a
948      * `private` function that does the actual work.
949      */
950     modifier nonReentrant() {
951         // On the first call to nonReentrant, _notEntered will be true
952         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
953 
954         // Any calls to nonReentrant after this point will fail
955         _status = _ENTERED;
956 
957         _;
958 
959         // By storing the original value once again, a refund is triggered (see
960         // https://eips.ethereum.org/EIPS/eip-2200)
961         _status = _NOT_ENTERED;
962     }
963 }
964 
965 /**
966  * @dev Contract module which allows children to implement an emergency stop
967  * mechanism that can be triggered by an authorized account.
968  *
969  * This module is used through inheritance. It will make available the
970  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
971  * the functions of your contract. Note that they will not be pausable by
972  * simply including this module, only once the modifiers are put in place.
973  */
974 abstract contract Pausable is Context {
975     /**
976      * @dev Emitted when the pause is triggered by `account`.
977      */
978     event Paused(address account);
979 
980     /**
981      * @dev Emitted when the pause is lifted by `account`.
982      */
983     event Unpaused(address account);
984 
985     bool private _paused;
986 
987     /**
988      * @dev Initializes the contract in unpaused state.
989      */
990     constructor() {
991         _paused = false;
992     }
993 
994     /**
995      * @dev Returns true if the contract is paused, and false otherwise.
996      */
997     function paused() public view virtual returns (bool) {
998         return _paused;
999     }
1000 
1001     /**
1002      * @dev Modifier to make a function callable only when the contract is not paused.
1003      *
1004      * Requirements:
1005      *
1006      * - The contract must not be paused.
1007      */
1008     modifier whenNotPaused() {
1009         require(!paused(), "Pausable: paused");
1010         _;
1011     }
1012 
1013     /**
1014      * @dev Modifier to make a function callable only when the contract is paused.
1015      *
1016      * Requirements:
1017      *
1018      * - The contract must be paused.
1019      */
1020     modifier whenPaused() {
1021         require(paused(), "Pausable: not paused");
1022         _;
1023     }
1024 
1025     /**
1026      * @dev Triggers stopped state.
1027      *
1028      * Requirements:
1029      *
1030      * - The contract must not be paused.
1031      */
1032     function _pause() internal virtual whenNotPaused {
1033         _paused = true;
1034         emit Paused(_msgSender());
1035     }
1036 
1037     /**
1038      * @dev Returns to normal state.
1039      *
1040      * Requirements:
1041      *
1042      * - The contract must be paused.
1043      */
1044     function _unpause() internal virtual whenPaused {
1045         _paused = false;
1046         emit Unpaused(_msgSender());
1047     }
1048 }
1049 
1050 /**
1051  * @dev Contract module which provides a basic access control mechanism, where
1052  * there is an account (an owner) that can be granted exclusive access to
1053  * specific functions.
1054  *
1055  * By default, the owner account will be the one that deploys the contract. This
1056  * can later be changed with {transferOwnership}.
1057  *
1058  * This module is used through inheritance. It will make available the modifier
1059  * `onlyOwner`, which can be applied to your functions to restrict their use to
1060  * the owner.
1061  */
1062 abstract contract Ownable is Context {
1063     address private _owner;
1064 
1065     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1066 
1067     /**
1068      * @dev Initializes the contract setting the deployer as the initial owner.
1069      */
1070     constructor() {
1071         _setOwner(_msgSender());
1072     }
1073 
1074     /**
1075      * @dev Returns the address of the current owner.
1076      */
1077     function owner() public view virtual returns (address) {
1078         return _owner;
1079     }
1080 
1081     /**
1082      * @dev Throws if called by any account other than the owner.
1083      */
1084     modifier onlyOwner() {
1085         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1086         _;
1087     }
1088 
1089     /**
1090      * @dev Leaves the contract without owner. It will not be possible to call
1091      * `onlyOwner` functions anymore. Can only be called by the current owner.
1092      *
1093      * NOTE: Renouncing ownership will leave the contract without an owner,
1094      * thereby removing any functionality that is only available to the owner.
1095      */
1096     function renounceOwnership() public virtual onlyOwner {
1097         _setOwner(address(0));
1098     }
1099 
1100     /**
1101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1102      * Can only be called by the current owner.
1103      */
1104     function transferOwnership(address newOwner) public virtual onlyOwner {
1105         require(newOwner != address(0), "Ownable: new owner is the zero address");
1106         _setOwner(newOwner);
1107     }
1108 
1109     function _setOwner(address newOwner) private {
1110         address oldOwner = _owner;
1111         _owner = newOwner;
1112         emit OwnershipTransferred(oldOwner, newOwner);
1113     }
1114 }
1115 
1116 contract SupRecords is ERC1155(""), ReentrancyGuard, Pausable, Ownable {
1117     mapping(address => bool) private _minters;
1118 
1119     mapping(uint256 => uint256) private _totalSupplies;
1120     mapping(uint256 => uint256) private _maxSupplies;
1121     mapping(uint256 => uint256) private _prices;
1122     mapping(uint256 => string) private _hashes;
1123 
1124     uint256 _totalTokens;
1125 
1126     string constant BASE_URI = "https://ipfs.io/ipfs/";
1127     uint256 constant public MAX_MINT_COUNT = 10;
1128 
1129     address payable private payoutAddress;
1130 
1131     string public name;
1132     string public symbol;
1133 
1134     event AllocatedTokens(uint256 tokenId, uint256 price, uint256 count);
1135     event SetMintable(address minter, bool mintable);
1136 
1137     modifier minterOrOwner() {
1138         // Caller must either be a minter or the owner.
1139         if (!_minters[_msgSender()]) {
1140             require(owner() == _msgSender(), "Not minter or owner");
1141         }
1142 
1143         _;
1144     }
1145 
1146     constructor() {
1147         payoutAddress = payable(_msgSender());
1148         name = "Sup? Records";
1149         symbol = "SUP?";
1150     }
1151 
1152     // For OpenSea
1153     function uri(uint256 tokenId) public view override returns (string memory) {
1154         string memory ipfsHash = _hashes[tokenId];
1155 
1156         return bytes(ipfsHash).length > 0 ? string(abi.encodePacked(BASE_URI, ipfsHash)) : "";
1157     }
1158     function totalSupply(uint256 tokenId) external view returns (uint256) {
1159         return _totalSupplies[tokenId];
1160     }
1161     function maxSupply(uint256 tokenId) external view returns (uint256) {
1162         return _maxSupplies[tokenId];
1163     }
1164 
1165     // Views
1166     function getPrice(uint256 tokenId) external view returns (uint256) {
1167         require(_maxSupplies[tokenId] > 1, "Invalid token id");
1168 
1169         return _prices[tokenId];
1170     }
1171     function getTotalTokens() external view returns (uint256) {
1172         return _totalTokens;
1173     }
1174 
1175     /** Mint a non-unique NFT. */
1176     function mint(uint256 tokenId, uint256 count) external payable nonReentrant whenNotPaused {
1177         require(count > 0 && count <= MAX_MINT_COUNT, "Invalid mint count");
1178         uint256 maxTokenSupply = _maxSupplies[tokenId];
1179         require(maxTokenSupply > 1 && _totalSupplies[tokenId] + count <= maxTokenSupply, "No supply");
1180         require(msg.value == _prices[tokenId] * count, "Wrong value");
1181 
1182         _totalSupplies[tokenId] += count;
1183 
1184         _mint(_msgSender(), tokenId, count, "");
1185     }
1186 
1187     /** Sets the allocation for a non-unique NFT. */
1188     function createNonUnique(uint256 price, uint256 count, string memory ipfsHash) external nonReentrant minterOrOwner {
1189         uint256 tokenId = ++_totalTokens;
1190         require(_maxSupplies[tokenId] == 0, "Already created.");
1191         require(price > 0, "Must have price");
1192         require(count > 1, "Must be non-unique");
1193         require(bytes(ipfsHash).length > 0, "Need ipfs hash");
1194 
1195         _maxSupplies[tokenId] = count;
1196         _prices[tokenId] = price;
1197         _hashes[tokenId] = ipfsHash;
1198 
1199         emit AllocatedTokens(tokenId, price, count);
1200     }
1201 
1202     /** Mints a unique, one of one, NFT. */
1203     function mintUnique(string memory ipfsHash) external nonReentrant minterOrOwner {
1204         uint256 tokenId = ++_totalTokens;
1205         require(_maxSupplies[tokenId] == 0, "Already minted");
1206         require(bytes(ipfsHash).length > 0, "Need ipfs hash");
1207 
1208         _totalSupplies[tokenId] = 1;
1209         _maxSupplies[tokenId] = 1;
1210         _hashes[tokenId] = ipfsHash;
1211 
1212         _mint(_msgSender(), tokenId, 1, "");
1213     }
1214 
1215 
1216     // Minter
1217     function isMinter(address minter) external view returns (bool) {
1218         return _minters[minter];
1219     }
1220     /** Set the minter role for a given set of addresses. */
1221     function setMintable(address[] calldata minters, bool[] calldata mintables) external nonReentrant onlyOwner {
1222         uint256 count = minters.length;
1223         require(count > 0, "No minters");
1224         require(count == mintables.length, "Nonmatching length");
1225 
1226         address minter;
1227         bool mintable;
1228         for (uint256 i; i < count; i++) {
1229             minter = minters[i];
1230             mintable = mintables[i];
1231             _minters[minter] = mintable;
1232 
1233             emit SetMintable(minter, mintable);
1234         }
1235     }
1236 
1237     // Owner
1238     function withdraw() public {
1239         payoutAddress.transfer(address(this).balance);
1240     }
1241     function renounceOwnership() public override nonReentrant {
1242         revert();
1243     }
1244     function setPayoutAddress(address payable newAddress) external nonReentrant onlyOwner {
1245         require(newAddress != address(0) && newAddress != address(this), "Invalid address");
1246 
1247         payoutAddress = newAddress;
1248     }
1249     function pause() external nonReentrant onlyOwner {
1250         _pause();
1251     }
1252     function unpause() external nonReentrant onlyOwner {
1253         _unpause();
1254     }
1255 }