1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
27 
28 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
29 /**
30  * @dev Required interface of an ERC1155 compliant contract, as defined in the
31  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
32  *
33  * _Available since v3.1._
34  */
35 interface IERC1155 is IERC165 {
36     /**
37      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
38      */
39     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
40 
41     /**
42      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
43      * transfers.
44      */
45     event TransferBatch(
46         address indexed operator,
47         address indexed from,
48         address indexed to,
49         uint256[] ids,
50         uint256[] values
51     );
52 
53     /**
54      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
55      * `approved`.
56      */
57     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
58 
59     /**
60      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
61      *
62      * If an {URI} event was emitted for `id`, the standard
63      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
64      * returned by {IERC1155MetadataURI-uri}.
65      */
66     event URI(string value, uint256 indexed id);
67 
68     /**
69      * @dev Returns the amount of tokens of token type `id` owned by `account`.
70      *
71      * Requirements:
72      *
73      * - `account` cannot be the zero address.
74      */
75     function balanceOf(address account, uint256 id) external view returns (uint256);
76 
77     /**
78      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
79      *
80      * Requirements:
81      *
82      * - `accounts` and `ids` must have the same length.
83      */
84     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
85         external
86         view
87         returns (uint256[] memory);
88 
89     /**
90      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
91      *
92      * Emits an {ApprovalForAll} event.
93      *
94      * Requirements:
95      *
96      * - `operator` cannot be the caller.
97      */
98     function setApprovalForAll(address operator, bool approved) external;
99 
100     /**
101      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
102      *
103      * See {setApprovalForAll}.
104      */
105     function isApprovedForAll(address account, address operator) external view returns (bool);
106 
107     /**
108      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
109      *
110      * Emits a {TransferSingle} event.
111      *
112      * Requirements:
113      *
114      * - `to` cannot be the zero address.
115      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
116      * - `from` must have a balance of tokens of type `id` of at least `amount`.
117      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
118      * acceptance magic value.
119      */
120     function safeTransferFrom(
121         address from,
122         address to,
123         uint256 id,
124         uint256 amount,
125         bytes calldata data
126     ) external;
127 
128     /**
129      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
130      *
131      * Emits a {TransferBatch} event.
132      *
133      * Requirements:
134      *
135      * - `ids` and `amounts` must have the same length.
136      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
137      * acceptance magic value.
138      */
139     function safeBatchTransferFrom(
140         address from,
141         address to,
142         uint256[] calldata ids,
143         uint256[] calldata amounts,
144         bytes calldata data
145     ) external;
146 }
147 
148 
149 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
150 /**
151  * @dev _Available since v3.1._
152  */
153 interface IERC1155Receiver is IERC165 {
154     /**
155      * @dev Handles the receipt of a single ERC1155 token type. This function is
156      * called at the end of a `safeTransferFrom` after the balance has been updated.
157      *
158      * NOTE: To accept the transfer, this must return
159      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
160      * (i.e. 0xf23a6e61, or its own function selector).
161      *
162      * @param operator The address which initiated the transfer (i.e. msg.sender)
163      * @param from The address which previously owned the token
164      * @param id The ID of the token being transferred
165      * @param value The amount of tokens being transferred
166      * @param data Additional data with no specified format
167      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
168      */
169     function onERC1155Received(
170         address operator,
171         address from,
172         uint256 id,
173         uint256 value,
174         bytes calldata data
175     ) external returns (bytes4);
176 
177     /**
178      * @dev Handles the receipt of a multiple ERC1155 token types. This function
179      * is called at the end of a `safeBatchTransferFrom` after the balances have
180      * been updated.
181      *
182      * NOTE: To accept the transfer(s), this must return
183      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
184      * (i.e. 0xbc197c81, or its own function selector).
185      *
186      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
187      * @param from The address which previously owned the token
188      * @param ids An array containing ids of each token being transferred (order and length must match values array)
189      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
190      * @param data Additional data with no specified format
191      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
192      */
193     function onERC1155BatchReceived(
194         address operator,
195         address from,
196         uint256[] calldata ids,
197         uint256[] calldata values,
198         bytes calldata data
199     ) external returns (bytes4);
200 }
201 
202 
203 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
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
220 
221 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
222 /**
223  * @dev Collection of functions related to the address type
224  */
225 library Address {
226     /**
227      * @dev Returns true if `account` is a contract.
228      *
229      * [IMPORTANT]
230      * ====
231      * It is unsafe to assume that an address for which this function returns
232      * false is an externally-owned account (EOA) and not a contract.
233      *
234      * Among others, `isContract` will return false for the following
235      * types of addresses:
236      *
237      *  - an externally-owned account
238      *  - a contract in construction
239      *  - an address where a contract will be created
240      *  - an address where a contract lived, but was destroyed
241      * ====
242      *
243      * [IMPORTANT]
244      * ====
245      * You shouldn't rely on `isContract` to protect against flash loan attacks!
246      *
247      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
248      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
249      * constructor.
250      * ====
251      */
252     function isContract(address account) internal view returns (bool) {
253         // This method relies on extcodesize/address.code.length, which returns 0
254         // for contracts in construction, since the code is only stored at the end
255         // of the constructor execution.
256 
257         return account.code.length > 0;
258     }
259 
260     /**
261      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
262      * `recipient`, forwarding all available gas and reverting on errors.
263      *
264      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
265      * of certain opcodes, possibly making contracts go over the 2300 gas limit
266      * imposed by `transfer`, making them unable to receive funds via
267      * `transfer`. {sendValue} removes this limitation.
268      *
269      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
270      *
271      * IMPORTANT: because control is transferred to `recipient`, care must be
272      * taken to not create reentrancy vulnerabilities. Consider using
273      * {ReentrancyGuard} or the
274      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
275      */
276     function sendValue(address payable recipient, uint256 amount) internal {
277         require(address(this).balance >= amount, "Address: insufficient balance");
278 
279         (bool success, ) = recipient.call{value: amount}("");
280         require(success, "Address: unable to send value, recipient may have reverted");
281     }
282 
283     /**
284      * @dev Performs a Solidity function call using a low level `call`. A
285      * plain `call` is an unsafe replacement for a function call: use this
286      * function instead.
287      *
288      * If `target` reverts with a revert reason, it is bubbled up by this
289      * function (like regular Solidity function calls).
290      *
291      * Returns the raw returned data. To convert to the expected return value,
292      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
293      *
294      * Requirements:
295      *
296      * - `target` must be a contract.
297      * - calling `target` with `data` must not revert.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302         return functionCall(target, data, "Address: low-level call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
307      * `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, 0, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but also transferring `value` wei to `target`.
322      *
323      * Requirements:
324      *
325      * - the calling contract must have an ETH balance of at least `value`.
326      * - the called Solidity function must be `payable`.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         require(isContract(target), "Address: call to non-contract");
352 
353         (bool success, bytes memory returndata) = target.call{value: value}(data);
354         return verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
364         return functionStaticCall(target, data, "Address: low-level static call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal view returns (bytes memory) {
378         require(isContract(target), "Address: static call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.staticcall(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(isContract(target), "Address: delegate call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.delegatecall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
413      * revert reason using the provided one.
414      *
415      * _Available since v4.3._
416      */
417     function verifyCallResult(
418         bool success,
419         bytes memory returndata,
420         string memory errorMessage
421     ) internal pure returns (bytes memory) {
422         if (success) {
423             return returndata;
424         } else {
425             // Look for revert reason and bubble it up if present
426             if (returndata.length > 0) {
427                 // The easiest way to bubble the revert reason is using memory via assembly
428 
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
442 /**
443  * @dev Provides information about the current execution context, including the
444  * sender of the transaction and its data. While these are generally available
445  * via msg.sender and msg.data, they should not be accessed in such a direct
446  * manner, since when dealing with meta-transactions the account sending and
447  * paying for execution may not be the actual sender (as far as an application
448  * is concerned).
449  *
450  * This contract is only required for intermediate, library-like contracts.
451  */
452 abstract contract Context {
453     function _msgSender() internal view virtual returns (address) {
454         return msg.sender;
455     }
456 
457     function _msgData() internal view virtual returns (bytes calldata) {
458         return msg.data;
459     }
460 }
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
464 /**
465  * @dev Implementation of the {IERC165} interface.
466  *
467  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
468  * for the additional interface id that will be supported. For example:
469  *
470  * ```solidity
471  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
473  * }
474  * ```
475  *
476  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
477  */
478 abstract contract ERC165 is IERC165 {
479     /**
480      * @dev See {IERC165-supportsInterface}.
481      */
482     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483         return interfaceId == type(IERC165).interfaceId;
484     }
485 }
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
489 /**
490  * @dev Implementation of the basic standard multi-token.
491  * See https://eips.ethereum.org/EIPS/eip-1155
492  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
493  *
494  * _Available since v3.1._
495  */
496 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
497     using Address for address;
498 
499     // Mapping from token ID to account balances
500     mapping(uint256 => mapping(address => uint256)) private _balances;
501 
502     // Mapping from account to operator approvals
503     mapping(address => mapping(address => bool)) private _operatorApprovals;
504 
505     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
506     string private _uri;
507 
508     /**
509      * @dev See {_setURI}.
510      */
511     constructor(string memory uri_) {
512         _setURI(uri_);
513     }
514 
515     /**
516      * @dev See {IERC165-supportsInterface}.
517      */
518     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
519         return
520             interfaceId == type(IERC1155).interfaceId ||
521             interfaceId == type(IERC1155MetadataURI).interfaceId ||
522             super.supportsInterface(interfaceId);
523     }
524 
525     /**
526      * @dev See {IERC1155MetadataURI-uri}.
527      *
528      * This implementation returns the same URI for *all* token types. It relies
529      * on the token type ID substitution mechanism
530      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
531      *
532      * Clients calling this function must replace the `\{id\}` substring with the
533      * actual token type ID.
534      */
535     function uri(uint256) public view virtual override returns (string memory) {
536         return _uri;
537     }
538 
539     /**
540      * @dev See {IERC1155-balanceOf}.
541      *
542      * Requirements:
543      *
544      * - `account` cannot be the zero address.
545      */
546     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
547         require(account != address(0), "ERC1155: balance query for the zero address");
548         return _balances[id][account];
549     }
550 
551     /**
552      * @dev See {IERC1155-balanceOfBatch}.
553      *
554      * Requirements:
555      *
556      * - `accounts` and `ids` must have the same length.
557      */
558     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
559         public
560         view
561         virtual
562         override
563         returns (uint256[] memory)
564     {
565         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
566 
567         uint256[] memory batchBalances = new uint256[](accounts.length);
568 
569         for (uint256 i = 0; i < accounts.length; ++i) {
570             batchBalances[i] = balanceOf(accounts[i], ids[i]);
571         }
572 
573         return batchBalances;
574     }
575 
576     /**
577      * @dev See {IERC1155-setApprovalForAll}.
578      */
579     function setApprovalForAll(address operator, bool approved) public virtual override {
580         _setApprovalForAll(_msgSender(), operator, approved);
581     }
582 
583     /**
584      * @dev See {IERC1155-isApprovedForAll}.
585      */
586     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
587         return _operatorApprovals[account][operator];
588     }
589 
590     /**
591      * @dev See {IERC1155-safeTransferFrom}.
592      */
593     function safeTransferFrom(
594         address from,
595         address to,
596         uint256 id,
597         uint256 amount,
598         bytes memory data
599     ) public virtual override {
600         require(
601             from == _msgSender() || isApprovedForAll(from, _msgSender()),
602             "ERC1155: caller is not owner nor approved"
603         );
604         _safeTransferFrom(from, to, id, amount, data);
605     }
606 
607     /**
608      * @dev See {IERC1155-safeBatchTransferFrom}.
609      */
610     function safeBatchTransferFrom(
611         address from,
612         address to,
613         uint256[] memory ids,
614         uint256[] memory amounts,
615         bytes memory data
616     ) public virtual override {
617         require(
618             from == _msgSender() || isApprovedForAll(from, _msgSender()),
619             "ERC1155: transfer caller is not owner nor approved"
620         );
621         _safeBatchTransferFrom(from, to, ids, amounts, data);
622     }
623 
624     /**
625      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
626      *
627      * Emits a {TransferSingle} event.
628      *
629      * Requirements:
630      *
631      * - `to` cannot be the zero address.
632      * - `from` must have a balance of tokens of type `id` of at least `amount`.
633      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
634      * acceptance magic value.
635      */
636     function _safeTransferFrom(
637         address from,
638         address to,
639         uint256 id,
640         uint256 amount,
641         bytes memory data
642     ) internal virtual {
643         require(to != address(0), "ERC1155: transfer to the zero address");
644 
645         address operator = _msgSender();
646 
647         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
648 
649         uint256 fromBalance = _balances[id][from];
650         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
651         unchecked {
652             _balances[id][from] = fromBalance - amount;
653         }
654         _balances[id][to] += amount;
655 
656         emit TransferSingle(operator, from, to, id, amount);
657 
658         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
659     }
660 
661     /**
662      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
663      *
664      * Emits a {TransferBatch} event.
665      *
666      * Requirements:
667      *
668      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
669      * acceptance magic value.
670      */
671     function _safeBatchTransferFrom(
672         address from,
673         address to,
674         uint256[] memory ids,
675         uint256[] memory amounts,
676         bytes memory data
677     ) internal virtual {
678         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
679         require(to != address(0), "ERC1155: transfer to the zero address");
680 
681         address operator = _msgSender();
682 
683         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
684 
685         for (uint256 i = 0; i < ids.length; ++i) {
686             uint256 id = ids[i];
687             uint256 amount = amounts[i];
688 
689             uint256 fromBalance = _balances[id][from];
690             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
691             unchecked {
692                 _balances[id][from] = fromBalance - amount;
693             }
694             _balances[id][to] += amount;
695         }
696 
697         emit TransferBatch(operator, from, to, ids, amounts);
698 
699         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
700     }
701 
702     /**
703      * @dev Sets a new URI for all token types, by relying on the token type ID
704      * substitution mechanism
705      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
706      *
707      * By this mechanism, any occurrence of the `\{id\}` substring in either the
708      * URI or any of the amounts in the JSON file at said URI will be replaced by
709      * clients with the token type ID.
710      *
711      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
712      * interpreted by clients as
713      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
714      * for token type ID 0x4cce0.
715      *
716      * See {uri}.
717      *
718      * Because these URIs cannot be meaningfully represented by the {URI} event,
719      * this function emits no events.
720      */
721     function _setURI(string memory newuri) internal virtual {
722         _uri = newuri;
723     }
724 
725     /**
726      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
727      *
728      * Emits a {TransferSingle} event.
729      *
730      * Requirements:
731      *
732      * - `to` cannot be the zero address.
733      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
734      * acceptance magic value.
735      */
736     function _mint(
737         address to,
738         uint256 id,
739         uint256 amount,
740         bytes memory data
741     ) internal virtual {
742         require(to != address(0), "ERC1155: mint to the zero address");
743 
744         address operator = _msgSender();
745 
746         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
747 
748         _balances[id][to] += amount;
749         emit TransferSingle(operator, address(0), to, id, amount);
750 
751         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
752     }
753 
754     /**
755      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
756      *
757      * Requirements:
758      *
759      * - `ids` and `amounts` must have the same length.
760      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
761      * acceptance magic value.
762      */
763     function _mintBatch(
764         address to,
765         uint256[] memory ids,
766         uint256[] memory amounts,
767         bytes memory data
768     ) internal virtual {
769         require(to != address(0), "ERC1155: mint to the zero address");
770         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
771 
772         address operator = _msgSender();
773 
774         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
775 
776         for (uint256 i = 0; i < ids.length; i++) {
777             _balances[ids[i]][to] += amounts[i];
778         }
779 
780         emit TransferBatch(operator, address(0), to, ids, amounts);
781 
782         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
783     }
784 
785     /**
786      * @dev Destroys `amount` tokens of token type `id` from `from`
787      *
788      * Requirements:
789      *
790      * - `from` cannot be the zero address.
791      * - `from` must have at least `amount` tokens of token type `id`.
792      */
793     function _burn(
794         address from,
795         uint256 id,
796         uint256 amount
797     ) internal virtual {
798         require(from != address(0), "ERC1155: burn from the zero address");
799 
800         address operator = _msgSender();
801 
802         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
803 
804         uint256 fromBalance = _balances[id][from];
805         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
806         unchecked {
807             _balances[id][from] = fromBalance - amount;
808         }
809 
810         emit TransferSingle(operator, from, address(0), id, amount);
811     }
812 
813     /**
814      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
815      *
816      * Requirements:
817      *
818      * - `ids` and `amounts` must have the same length.
819      */
820     function _burnBatch(
821         address from,
822         uint256[] memory ids,
823         uint256[] memory amounts
824     ) internal virtual {
825         require(from != address(0), "ERC1155: burn from the zero address");
826         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
827 
828         address operator = _msgSender();
829 
830         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
831 
832         for (uint256 i = 0; i < ids.length; i++) {
833             uint256 id = ids[i];
834             uint256 amount = amounts[i];
835 
836             uint256 fromBalance = _balances[id][from];
837             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
838             unchecked {
839                 _balances[id][from] = fromBalance - amount;
840             }
841         }
842 
843         emit TransferBatch(operator, from, address(0), ids, amounts);
844     }
845 
846     /**
847      * @dev Approve `operator` to operate on all of `owner` tokens
848      *
849      * Emits a {ApprovalForAll} event.
850      */
851     function _setApprovalForAll(
852         address owner,
853         address operator,
854         bool approved
855     ) internal virtual {
856         require(owner != operator, "ERC1155: setting approval status for self");
857         _operatorApprovals[owner][operator] = approved;
858         emit ApprovalForAll(owner, operator, approved);
859     }
860 
861     /**
862      * @dev Hook that is called before any token transfer. This includes minting
863      * and burning, as well as batched variants.
864      *
865      * The same hook is called on both single and batched variants. For single
866      * transfers, the length of the `id` and `amount` arrays will be 1.
867      *
868      * Calling conditions (for each `id` and `amount` pair):
869      *
870      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
871      * of token type `id` will be  transferred to `to`.
872      * - When `from` is zero, `amount` tokens of token type `id` will be minted
873      * for `to`.
874      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
875      * will be burned.
876      * - `from` and `to` are never both zero.
877      * - `ids` and `amounts` have the same, non-zero length.
878      *
879      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
880      */
881     function _beforeTokenTransfer(
882         address operator,
883         address from,
884         address to,
885         uint256[] memory ids,
886         uint256[] memory amounts,
887         bytes memory data
888     ) internal virtual {}
889 
890     function _doSafeTransferAcceptanceCheck(
891         address operator,
892         address from,
893         address to,
894         uint256 id,
895         uint256 amount,
896         bytes memory data
897     ) private {
898         if (to.isContract()) {
899             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
900                 if (response != IERC1155Receiver.onERC1155Received.selector) {
901                     revert("ERC1155: ERC1155Receiver rejected tokens");
902                 }
903             } catch Error(string memory reason) {
904                 revert(reason);
905             } catch {
906                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
907             }
908         }
909     }
910 
911     function _doSafeBatchTransferAcceptanceCheck(
912         address operator,
913         address from,
914         address to,
915         uint256[] memory ids,
916         uint256[] memory amounts,
917         bytes memory data
918     ) private {
919         if (to.isContract()) {
920             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
921                 bytes4 response
922             ) {
923                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
924                     revert("ERC1155: ERC1155Receiver rejected tokens");
925                 }
926             } catch Error(string memory reason) {
927                 revert(reason);
928             } catch {
929                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
930             }
931         }
932     }
933 
934     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
935         uint256[] memory array = new uint256[](1);
936         array[0] = element;
937 
938         return array;
939     }
940 }
941 
942 
943 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
944 /**
945  * @dev Extension of ERC1155 that adds tracking of total supply per id.
946  *
947  * Useful for scenarios where Fungible and Non-fungible tokens have to be
948  * clearly identified. Note: While a totalSupply of 1 might mean the
949  * corresponding is an NFT, there is no guarantees that no other token with the
950  * same id are not going to be minted.
951  */
952 abstract contract ERC1155Supply is ERC1155 {
953     mapping(uint256 => uint256) private _totalSupply;
954 
955     /**
956      * @dev Total amount of tokens in with a given id.
957      */
958     function totalSupply(uint256 id) public view virtual returns (uint256) {
959         return _totalSupply[id];
960     }
961 
962     /**
963      * @dev Indicates whether any token exist with a given id, or not.
964      */
965     function exists(uint256 id) public view virtual returns (bool) {
966         return ERC1155Supply.totalSupply(id) > 0;
967     }
968 
969     /**
970      * @dev See {ERC1155-_beforeTokenTransfer}.
971      */
972     function _beforeTokenTransfer(
973         address operator,
974         address from,
975         address to,
976         uint256[] memory ids,
977         uint256[] memory amounts,
978         bytes memory data
979     ) internal virtual override {
980         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
981 
982         if (from == address(0)) {
983             for (uint256 i = 0; i < ids.length; ++i) {
984                 _totalSupply[ids[i]] += amounts[i];
985             }
986         }
987 
988         if (to == address(0)) {
989             for (uint256 i = 0; i < ids.length; ++i) {
990                 _totalSupply[ids[i]] -= amounts[i];
991             }
992         }
993     }
994 }
995 
996 
997 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
998 /**
999  * @dev These functions deal with verification of Merkle Trees proofs.
1000  *
1001  * The proofs can be generated using the JavaScript library
1002  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1003  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1004  *
1005  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1006  */
1007 library MerkleProof {
1008     /**
1009      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1010      * defined by `root`. For this, a `proof` must be provided, containing
1011      * sibling hashes on the branch from the leaf to the root of the tree. Each
1012      * pair of leaves and each pair of pre-images are assumed to be sorted.
1013      */
1014     function verify(
1015         bytes32[] memory proof,
1016         bytes32 root,
1017         bytes32 leaf
1018     ) internal pure returns (bool) {
1019         return processProof(proof, leaf) == root;
1020     }
1021 
1022     /**
1023      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1024      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1025      * hash matches the root of the tree. When processing the proof, the pairs
1026      * of leafs & pre-images are assumed to be sorted.
1027      *
1028      * _Available since v4.4._
1029      */
1030     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1031         bytes32 computedHash = leaf;
1032         for (uint256 i = 0; i < proof.length; i++) {
1033             bytes32 proofElement = proof[i];
1034             if (computedHash <= proofElement) {
1035                 // Hash(current computed hash + current element of the proof)
1036                 computedHash = _efficientHash(computedHash, proofElement);
1037             } else {
1038                 // Hash(current element of the proof + current computed hash)
1039                 computedHash = _efficientHash(proofElement, computedHash);
1040             }
1041         }
1042         return computedHash;
1043     }
1044 
1045     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1046         assembly {
1047             mstore(0x00, a)
1048             mstore(0x20, b)
1049             value := keccak256(0x00, 0x40)
1050         }
1051     }
1052 }
1053 
1054 
1055 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1056 /**
1057  * @dev Contract module which provides a basic access control mechanism, where
1058  * there is an account (an owner) that can be granted exclusive access to
1059  * specific functions.
1060  *
1061  * By default, the owner account will be the one that deploys the contract. This
1062  * can later be changed with {transferOwnership}.
1063  *
1064  * This module is used through inheritance. It will make available the modifier
1065  * `onlyOwner`, which can be applied to your functions to restrict their use to
1066  * the owner.
1067  */
1068 abstract contract Ownable is Context {
1069     address private _owner;
1070 
1071     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1072 
1073     /**
1074      * @dev Initializes the contract setting the deployer as the initial owner.
1075      */
1076     constructor() {
1077         _transferOwnership(_msgSender());
1078     }
1079 
1080     /**
1081      * @dev Returns the address of the current owner.
1082      */
1083     function owner() public view virtual returns (address) {
1084         return _owner;
1085     }
1086 
1087     /**
1088      * @dev Throws if called by any account other than the owner.
1089      */
1090     modifier onlyOwner() {
1091         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1092         _;
1093     }
1094 
1095     /**
1096      * @dev Leaves the contract without owner. It will not be possible to call
1097      * `onlyOwner` functions anymore. Can only be called by the current owner.
1098      *
1099      * NOTE: Renouncing ownership will leave the contract without an owner,
1100      * thereby removing any functionality that is only available to the owner.
1101      */
1102     function renounceOwnership() public virtual onlyOwner {
1103         _transferOwnership(address(0));
1104     }
1105 
1106     /**
1107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1108      * Can only be called by the current owner.
1109      */
1110     function transferOwnership(address newOwner) public virtual onlyOwner {
1111         require(newOwner != address(0), "Ownable: new owner is the zero address");
1112         _transferOwnership(newOwner);
1113     }
1114 
1115     /**
1116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1117      * Internal function without access restriction.
1118      */
1119     function _transferOwnership(address newOwner) internal virtual {
1120         address oldOwner = _owner;
1121         _owner = newOwner;
1122         emit OwnershipTransferred(oldOwner, newOwner);
1123     }
1124 }
1125 
1126 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1127 /**
1128  * @dev Contract module which allows children to implement an emergency stop
1129  * mechanism that can be triggered by an authorized account.
1130  *
1131  * This module is used through inheritance. It will make available the
1132  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1133  * the functions of your contract. Note that they will not be pausable by
1134  * simply including this module, only once the modifiers are put in place.
1135  */
1136 abstract contract Pausable is Context {
1137     /**
1138      * @dev Emitted when the pause is triggered by `account`.
1139      */
1140     event Paused(address account);
1141 
1142     /**
1143      * @dev Emitted when the pause is lifted by `account`.
1144      */
1145     event Unpaused(address account);
1146 
1147     bool private _paused;
1148 
1149     /**
1150      * @dev Initializes the contract in unpaused state.
1151      */
1152     constructor() {
1153         _paused = false;
1154     }
1155 
1156     /**
1157      * @dev Returns true if the contract is paused, and false otherwise.
1158      */
1159     function paused() public view virtual returns (bool) {
1160         return _paused;
1161     }
1162 
1163     /**
1164      * @dev Modifier to make a function callable only when the contract is not paused.
1165      *
1166      * Requirements:
1167      *
1168      * - The contract must not be paused.
1169      */
1170     modifier whenNotPaused() {
1171         require(!paused(), "Pausable: paused");
1172         _;
1173     }
1174 
1175     /**
1176      * @dev Modifier to make a function callable only when the contract is paused.
1177      *
1178      * Requirements:
1179      *
1180      * - The contract must be paused.
1181      */
1182     modifier whenPaused() {
1183         require(paused(), "Pausable: not paused");
1184         _;
1185     }
1186 
1187     /**
1188      * @dev Triggers stopped state.
1189      *
1190      * Requirements:
1191      *
1192      * - The contract must not be paused.
1193      */
1194     function _pause() internal virtual whenNotPaused {
1195         _paused = true;
1196         emit Paused(_msgSender());
1197     }
1198 
1199     /**
1200      * @dev Returns to normal state.
1201      *
1202      * Requirements:
1203      *
1204      * - The contract must be paused.
1205      */
1206     function _unpause() internal virtual whenPaused {
1207         _paused = false;
1208         emit Unpaused(_msgSender());
1209     }
1210 }
1211 
1212 //                         .----------------------------------------------------.
1213 //                        | .--------------------------------------------------. |
1214 //                        | |     ____    ____      _____      ____  ____      | |
1215 //                        | |    |_   \  /   _|    |_   _|    |_   ||   _|     | |
1216 //                        | |      |   \/   |        | |        | |__| |       | |
1217 //                        | |      | |\  /| |        | |        |  __  |       | |
1218 //                        | |     _| |_\/_| |_      _| |_      _| |  | |_      | |
1219 //                        | |    |_____||_____|    |_____|    |____||____|     | |
1220 //                        | |                                                  | |
1221 //                        | '--------------------------------------------------' |
1222 //                         '----------------------------------------------------'
1223 //   __  __      _                                   __  __                                   _____
1224 //  |  \/  |    | |                                 |  \/  |                                 |  __ \
1225 //  | \  / | ___| |_ __ ___   _____ _ __ ___  ___   | \  / |_   _ ___  ___ _   _ _ __ ___    | |__) |_ _ ___ ___
1226 //  | |\/| |/ _ \ __/ _` \ \ / / _ \ '__/ __|/ _ \  | |\/| | | | / __|/ _ \ | | | '_ ` _ \   |  ___/ _` / __/ __|
1227 //  | |  | |  __/ || (_| |\ V /  __/ |  \__ \  __/  | |  | | |_| \__ \  __/ |_| | | | | | |  | |  | (_| \__ \__ \
1228 //  |_|  |_|\___|\__\__,_| \_/ \___|_|  |___/\___|  |_|  |_|\__,_|___/\___|\__,_|_| |_| |_|  |_|   \__,_|___/___/
1229 contract MIHMetaverseMuseumPass is ERC1155, ERC1155Supply, Ownable, Pausable
1230 {
1231     bytes32 public whitelistMerkleRoot = 0xba2b009da6c8eb40d494b6f56f5d99318344f3b0d469f368081f4b6b5ef13035;
1232     
1233     mapping(address => mapping(uint256 => bool)) private tokenClaimedByWallet;  // Keep track of claimed tokens by wallet
1234 
1235     constructor() ERC1155("ipfs://QmZD4yfa7mBnVbxKABMZyAdVm7pt5aw1iKzhruPWGnQSxK/{id}.json")
1236     {
1237     }
1238 
1239     function setURI(string memory newuri) public onlyOwner
1240     {
1241         _setURI(newuri);
1242     }
1243 
1244     function setWhitelistMerkleRoot(bytes32 newRoot) public onlyOwner
1245     {
1246         whitelistMerkleRoot = newRoot;
1247     }
1248 
1249     function pause() public onlyOwner
1250     {
1251         _pause();
1252     }
1253 
1254     function unpause() public onlyOwner
1255     {
1256         _unpause();
1257     }
1258 
1259     function claim(address account, uint256 tokenId, bytes32[] calldata proof) public payable whenNotPaused
1260     {
1261         require(!tokenClaimedByWallet[account][tokenId], "This account has already claimed a token.");
1262         require(MerkleProof.verify(proof, whitelistMerkleRoot, keccak256(abi.encodePacked(tokenId, account))), "This account is not allowed to mint requested token.");
1263         require(msg.value == 0.0, "Ether value sent is not correct.");
1264 
1265         _mint(account, tokenId, 1, "");
1266         tokenClaimedByWallet[account][tokenId] = true;
1267     }
1268 
1269     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal whenNotPaused override(ERC1155, ERC1155Supply)
1270     {
1271         super._beforeTokenTransfer(operator, from, to, ids, amounts, data); 
1272     }
1273 }