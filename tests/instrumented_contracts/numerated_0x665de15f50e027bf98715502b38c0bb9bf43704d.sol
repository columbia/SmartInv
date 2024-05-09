1 pragma solidity 0.8.16;
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
26 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
27 /**
28  * @dev Required interface of an ERC1155 compliant contract, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
30  *
31  * _Available since v3.1._
32  */
33 interface IERC1155 is IERC165 {
34     /**
35      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
36      */
37     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
38 
39     /**
40      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
41      * transfers.
42      */
43     event TransferBatch(
44         address indexed operator,
45         address indexed from,
46         address indexed to,
47         uint256[] ids,
48         uint256[] values
49     );
50 
51     /**
52      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
53      * `approved`.
54      */
55     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
56 
57     /**
58      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
59      *
60      * If an {URI} event was emitted for `id`, the standard
61      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
62      * returned by {IERC1155MetadataURI-uri}.
63      */
64     event URI(string value, uint256 indexed id);
65 
66     /**
67      * @dev Returns the amount of tokens of token type `id` owned by `account`.
68      *
69      * Requirements:
70      *
71      * - `account` cannot be the zero address.
72      */
73     function balanceOf(address account, uint256 id) external view returns (uint256);
74 
75     /**
76      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
77      *
78      * Requirements:
79      *
80      * - `accounts` and `ids` must have the same length.
81      */
82     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
83         external
84         view
85         returns (uint256[] memory);
86 
87     /**
88      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
89      *
90      * Emits an {ApprovalForAll} event.
91      *
92      * Requirements:
93      *
94      * - `operator` cannot be the caller.
95      */
96     function setApprovalForAll(address operator, bool approved) external;
97 
98     /**
99      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
100      *
101      * See {setApprovalForAll}.
102      */
103     function isApprovedForAll(address account, address operator) external view returns (bool);
104 
105     /**
106      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
107      *
108      * Emits a {TransferSingle} event.
109      *
110      * Requirements:
111      *
112      * - `to` cannot be the zero address.
113      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
114      * - `from` must have a balance of tokens of type `id` of at least `amount`.
115      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
116      * acceptance magic value.
117      */
118     function safeTransferFrom(
119         address from,
120         address to,
121         uint256 id,
122         uint256 amount,
123         bytes calldata data
124     ) external;
125 
126     /**
127      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
128      *
129      * Emits a {TransferBatch} event.
130      *
131      * Requirements:
132      *
133      * - `ids` and `amounts` must have the same length.
134      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
135      * acceptance magic value.
136      */
137     function safeBatchTransferFrom(
138         address from,
139         address to,
140         uint256[] calldata ids,
141         uint256[] calldata amounts,
142         bytes calldata data
143     ) external;
144 }
145 
146 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
147 /**
148  * @dev _Available since v3.1._
149  */
150 interface IERC1155Receiver is IERC165 {
151     /**
152      * @dev Handles the receipt of a single ERC1155 token type. This function is
153      * called at the end of a `safeTransferFrom` after the balance has been updated.
154      *
155      * NOTE: To accept the transfer, this must return
156      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
157      * (i.e. 0xf23a6e61, or its own function selector).
158      *
159      * @param operator The address which initiated the transfer (i.e. msg.sender)
160      * @param from The address which previously owned the token
161      * @param id The ID of the token being transferred
162      * @param value The amount of tokens being transferred
163      * @param data Additional data with no specified format
164      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
165      */
166     function onERC1155Received(
167         address operator,
168         address from,
169         uint256 id,
170         uint256 value,
171         bytes calldata data
172     ) external returns (bytes4);
173 
174     /**
175      * @dev Handles the receipt of a multiple ERC1155 token types. This function
176      * is called at the end of a `safeBatchTransferFrom` after the balances have
177      * been updated.
178      *
179      * NOTE: To accept the transfer(s), this must return
180      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
181      * (i.e. 0xbc197c81, or its own function selector).
182      *
183      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
184      * @param from The address which previously owned the token
185      * @param ids An array containing ids of each token being transferred (order and length must match values array)
186      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
187      * @param data Additional data with no specified format
188      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
189      */
190     function onERC1155BatchReceived(
191         address operator,
192         address from,
193         uint256[] calldata ids,
194         uint256[] calldata values,
195         bytes calldata data
196     ) external returns (bytes4);
197 }
198 
199 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
200 /**
201  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
202  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
203  *
204  * _Available since v3.1._
205  */
206 interface IERC1155MetadataURI is IERC1155 {
207     /**
208      * @dev Returns the URI for token type `id`.
209      *
210      * If the `\{id\}` substring is present in the URI, it must be replaced by
211      * clients with the actual token type ID.
212      */
213     function uri(uint256 id) external view returns (string memory);
214 }
215 
216 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
217 /**
218  * @dev Collection of functions related to the address type
219  */
220 library Address {
221     /**
222      * @dev Returns true if `account` is a contract.
223      *
224      * [IMPORTANT]
225      * ====
226      * It is unsafe to assume that an address for which this function returns
227      * false is an externally-owned account (EOA) and not a contract.
228      *
229      * Among others, `isContract` will return false for the following
230      * types of addresses:
231      *
232      *  - an externally-owned account
233      *  - a contract in construction
234      *  - an address where a contract will be created
235      *  - an address where a contract lived, but was destroyed
236      * ====
237      *
238      * [IMPORTANT]
239      * ====
240      * You shouldn't rely on `isContract` to protect against flash loan attacks!
241      *
242      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
243      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
244      * constructor.
245      * ====
246      */
247     function isContract(address account) internal view returns (bool) {
248         // This method relies on extcodesize/address.code.length, which returns 0
249         // for contracts in construction, since the code is only stored at the end
250         // of the constructor execution.
251 
252         return account.code.length > 0;
253     }
254 
255     /**
256      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
257      * `recipient`, forwarding all available gas and reverting on errors.
258      *
259      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
260      * of certain opcodes, possibly making contracts go over the 2300 gas limit
261      * imposed by `transfer`, making them unable to receive funds via
262      * `transfer`. {sendValue} removes this limitation.
263      *
264      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
265      *
266      * IMPORTANT: because control is transferred to `recipient`, care must be
267      * taken to not create reentrancy vulnerabilities. Consider using
268      * {ReentrancyGuard} or the
269      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
270      */
271     function sendValue(address payable recipient, uint256 amount) internal {
272         require(address(this).balance >= amount, "Address: insufficient balance");
273 
274         (bool success, ) = recipient.call{value: amount}("");
275         require(success, "Address: unable to send value, recipient may have reverted");
276     }
277 
278     /**
279      * @dev Performs a Solidity function call using a low level `call`. A
280      * plain `call` is an unsafe replacement for a function call: use this
281      * function instead.
282      *
283      * If `target` reverts with a revert reason, it is bubbled up by this
284      * function (like regular Solidity function calls).
285      *
286      * Returns the raw returned data. To convert to the expected return value,
287      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
288      *
289      * Requirements:
290      *
291      * - `target` must be a contract.
292      * - calling `target` with `data` must not revert.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
297         return functionCall(target, data, "Address: low-level call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
302      * `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(
307         address target,
308         bytes memory data,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, 0, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but also transferring `value` wei to `target`.
317      *
318      * Requirements:
319      *
320      * - the calling contract must have an ETH balance of at least `value`.
321      * - the called Solidity function must be `payable`.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(
326         address target,
327         bytes memory data,
328         uint256 value
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
335      * with `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         require(isContract(target), "Address: call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.call{value: value}(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a static call.
355      *
356      * _Available since v3.3._
357      */
358     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
359         return functionStaticCall(target, data, "Address: low-level static call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal view returns (bytes memory) {
373         require(isContract(target), "Address: static call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.staticcall(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.4._
384      */
385     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.4._
394      */
395     function functionDelegateCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(isContract(target), "Address: delegate call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.delegatecall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
408      * revert reason using the provided one.
409      *
410      * _Available since v4.3._
411      */
412     function verifyCallResult(
413         bool success,
414         bytes memory returndata,
415         string memory errorMessage
416     ) internal pure returns (bytes memory) {
417         if (success) {
418             return returndata;
419         } else {
420             // Look for revert reason and bubble it up if present
421             if (returndata.length > 0) {
422                 // The easiest way to bubble the revert reason is using memory via assembly
423 
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
436 /**
437  * @dev Provides information about the current execution context, including the
438  * sender of the transaction and its data. While these are generally available
439  * via msg.sender and msg.data, they should not be accessed in such a direct
440  * manner, since when dealing with meta-transactions the account sending and
441  * paying for execution may not be the actual sender (as far as an application
442  * is concerned).
443  *
444  * This contract is only required for intermediate, library-like contracts.
445  */
446 abstract contract Context {
447     function _msgSender() internal view virtual returns (address) {
448         return msg.sender;
449     }
450 
451     function _msgData() internal view virtual returns (bytes calldata) {
452         return msg.data;
453     }
454 }
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
457 /**
458  * @dev Implementation of the {IERC165} interface.
459  *
460  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
461  * for the additional interface id that will be supported. For example:
462  *
463  * ```solidity
464  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
465  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
466  * }
467  * ```
468  *
469  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
470  */
471 abstract contract ERC165 is IERC165 {
472     /**
473      * @dev See {IERC165-supportsInterface}.
474      */
475     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
476         return interfaceId == type(IERC165).interfaceId;
477     }
478 }
479 
480 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
481 /**
482  * @dev Implementation of the basic standard multi-token.
483  * See https://eips.ethereum.org/EIPS/eip-1155
484  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
485  *
486  * _Available since v3.1._
487  */
488 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
489     using Address for address;
490 
491     // Mapping from token ID to account balances
492     mapping(uint256 => mapping(address => uint256)) private _balances;
493 
494     // Mapping from account to operator approvals
495     mapping(address => mapping(address => bool)) private _operatorApprovals;
496 
497     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
498     string private _uri;
499 
500     /**
501      * @dev See {_setURI}.
502      */
503     constructor(string memory uri_) {
504         _setURI(uri_);
505     }
506 
507     /**
508      * @dev See {IERC165-supportsInterface}.
509      */
510     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
511         return
512             interfaceId == type(IERC1155).interfaceId ||
513             interfaceId == type(IERC1155MetadataURI).interfaceId ||
514             super.supportsInterface(interfaceId);
515     }
516 
517     /**
518      * @dev See {IERC1155MetadataURI-uri}.
519      *
520      * This implementation returns the same URI for *all* token types. It relies
521      * on the token type ID substitution mechanism
522      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
523      *
524      * Clients calling this function must replace the `\{id\}` substring with the
525      * actual token type ID.
526      */
527     function uri(uint256) public view virtual override returns (string memory) {
528         return _uri;
529     }
530 
531     /**
532      * @dev See {IERC1155-balanceOf}.
533      *
534      * Requirements:
535      *
536      * - `account` cannot be the zero address.
537      */
538     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
539         require(account != address(0), "ERC1155: balance query for the zero address");
540         return _balances[id][account];
541     }
542 
543     /**
544      * @dev See {IERC1155-balanceOfBatch}.
545      *
546      * Requirements:
547      *
548      * - `accounts` and `ids` must have the same length.
549      */
550     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
551         public
552         view
553         virtual
554         override
555         returns (uint256[] memory)
556     {
557         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
558 
559         uint256[] memory batchBalances = new uint256[](accounts.length);
560 
561         for (uint256 i = 0; i < accounts.length; ++i) {
562             batchBalances[i] = balanceOf(accounts[i], ids[i]);
563         }
564 
565         return batchBalances;
566     }
567 
568     /**
569      * @dev See {IERC1155-setApprovalForAll}.
570      */
571     function setApprovalForAll(address operator, bool approved) public virtual override {
572         _setApprovalForAll(_msgSender(), operator, approved);
573     }
574 
575     /**
576      * @dev See {IERC1155-isApprovedForAll}.
577      */
578     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
579         return _operatorApprovals[account][operator];
580     }
581 
582     /**
583      * @dev See {IERC1155-safeTransferFrom}.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 id,
589         uint256 amount,
590         bytes memory data
591     ) public virtual override {
592         require(
593             from == _msgSender() || isApprovedForAll(from, _msgSender()),
594             "ERC1155: caller is not owner nor approved"
595         );
596         _safeTransferFrom(from, to, id, amount, data);
597     }
598 
599     /**
600      * @dev See {IERC1155-safeBatchTransferFrom}.
601      */
602     function safeBatchTransferFrom(
603         address from,
604         address to,
605         uint256[] memory ids,
606         uint256[] memory amounts,
607         bytes memory data
608     ) public virtual override {
609         require(
610             from == _msgSender() || isApprovedForAll(from, _msgSender()),
611             "ERC1155: transfer caller is not owner nor approved"
612         );
613         _safeBatchTransferFrom(from, to, ids, amounts, data);
614     }
615 
616     /**
617      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
618      *
619      * Emits a {TransferSingle} event.
620      *
621      * Requirements:
622      *
623      * - `to` cannot be the zero address.
624      * - `from` must have a balance of tokens of type `id` of at least `amount`.
625      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
626      * acceptance magic value.
627      */
628     function _safeTransferFrom(
629         address from,
630         address to,
631         uint256 id,
632         uint256 amount,
633         bytes memory data
634     ) internal virtual {
635         require(to != address(0), "ERC1155: transfer to the zero address");
636 
637         address operator = _msgSender();
638         uint256[] memory ids = _asSingletonArray(id);
639         uint256[] memory amounts = _asSingletonArray(amount);
640 
641         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
642 
643         uint256 fromBalance = _balances[id][from];
644         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
645         unchecked {
646             _balances[id][from] = fromBalance - amount;
647         }
648         _balances[id][to] += amount;
649 
650         emit TransferSingle(operator, from, to, id, amount);
651 
652         _afterTokenTransfer(operator, from, to, ids, amounts, data);
653 
654         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
655     }
656 
657     /**
658      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
659      *
660      * Emits a {TransferBatch} event.
661      *
662      * Requirements:
663      *
664      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
665      * acceptance magic value.
666      */
667     function _safeBatchTransferFrom(
668         address from,
669         address to,
670         uint256[] memory ids,
671         uint256[] memory amounts,
672         bytes memory data
673     ) internal virtual {
674         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
675         require(to != address(0), "ERC1155: transfer to the zero address");
676 
677         address operator = _msgSender();
678 
679         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
680 
681         for (uint256 i = 0; i < ids.length; ++i) {
682             uint256 id = ids[i];
683             uint256 amount = amounts[i];
684 
685             uint256 fromBalance = _balances[id][from];
686             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
687             unchecked {
688                 _balances[id][from] = fromBalance - amount;
689             }
690             _balances[id][to] += amount;
691         }
692 
693         emit TransferBatch(operator, from, to, ids, amounts);
694 
695         _afterTokenTransfer(operator, from, to, ids, amounts, data);
696 
697         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
698     }
699 
700     /**
701      * @dev Sets a new URI for all token types, by relying on the token type ID
702      * substitution mechanism
703      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
704      *
705      * By this mechanism, any occurrence of the `\{id\}` substring in either the
706      * URI or any of the amounts in the JSON file at said URI will be replaced by
707      * clients with the token type ID.
708      *
709      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
710      * interpreted by clients as
711      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
712      * for token type ID 0x4cce0.
713      *
714      * See {uri}.
715      *
716      * Because these URIs cannot be meaningfully represented by the {URI} event,
717      * this function emits no events.
718      */
719     function _setURI(string memory newuri) internal virtual {
720         _uri = newuri;
721     }
722 
723     /**
724      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
725      *
726      * Emits a {TransferSingle} event.
727      *
728      * Requirements:
729      *
730      * - `to` cannot be the zero address.
731      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
732      * acceptance magic value.
733      */
734     function _mint(
735         address to,
736         uint256 id,
737         uint256 amount,
738         bytes memory data
739     ) internal virtual {
740         require(to != address(0), "ERC1155: mint to the zero address");
741 
742         address operator = _msgSender();
743         uint256[] memory ids = _asSingletonArray(id);
744         uint256[] memory amounts = _asSingletonArray(amount);
745 
746         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
747 
748         _balances[id][to] += amount;
749         emit TransferSingle(operator, address(0), to, id, amount);
750 
751         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
752 
753         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
754     }
755 
756     /**
757      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
758      *
759      * Requirements:
760      *
761      * - `ids` and `amounts` must have the same length.
762      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
763      * acceptance magic value.
764      */
765     function _mintBatch(
766         address to,
767         uint256[] memory ids,
768         uint256[] memory amounts,
769         bytes memory data
770     ) internal virtual {
771         require(to != address(0), "ERC1155: mint to the zero address");
772         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
773 
774         address operator = _msgSender();
775 
776         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
777 
778         for (uint256 i = 0; i < ids.length; i++) {
779             _balances[ids[i]][to] += amounts[i];
780         }
781 
782         emit TransferBatch(operator, address(0), to, ids, amounts);
783 
784         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
785 
786         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
787     }
788 
789     /**
790      * @dev Destroys `amount` tokens of token type `id` from `from`
791      *
792      * Requirements:
793      *
794      * - `from` cannot be the zero address.
795      * - `from` must have at least `amount` tokens of token type `id`.
796      */
797     function _burn(
798         address from,
799         uint256 id,
800         uint256 amount
801     ) internal virtual {
802         require(from != address(0), "ERC1155: burn from the zero address");
803 
804         address operator = _msgSender();
805         uint256[] memory ids = _asSingletonArray(id);
806         uint256[] memory amounts = _asSingletonArray(amount);
807 
808         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
809 
810         uint256 fromBalance = _balances[id][from];
811         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
812         unchecked {
813             _balances[id][from] = fromBalance - amount;
814         }
815 
816         emit TransferSingle(operator, from, address(0), id, amount);
817 
818         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
819     }
820 
821     /**
822      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
823      *
824      * Requirements:
825      *
826      * - `ids` and `amounts` must have the same length.
827      */
828     function _burnBatch(
829         address from,
830         uint256[] memory ids,
831         uint256[] memory amounts
832     ) internal virtual {
833         require(from != address(0), "ERC1155: burn from the zero address");
834         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
835 
836         address operator = _msgSender();
837 
838         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
839 
840         for (uint256 i = 0; i < ids.length; i++) {
841             uint256 id = ids[i];
842             uint256 amount = amounts[i];
843 
844             uint256 fromBalance = _balances[id][from];
845             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
846             unchecked {
847                 _balances[id][from] = fromBalance - amount;
848             }
849         }
850 
851         emit TransferBatch(operator, from, address(0), ids, amounts);
852 
853         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
854     }
855 
856     /**
857      * @dev Approve `operator` to operate on all of `owner` tokens
858      *
859      * Emits a {ApprovalForAll} event.
860      */
861     function _setApprovalForAll(
862         address owner,
863         address operator,
864         bool approved
865     ) internal virtual {
866         require(owner != operator, "ERC1155: setting approval status for self");
867         _operatorApprovals[owner][operator] = approved;
868         emit ApprovalForAll(owner, operator, approved);
869     }
870 
871     /**
872      * @dev Hook that is called before any token transfer. This includes minting
873      * and burning, as well as batched variants.
874      *
875      * The same hook is called on both single and batched variants. For single
876      * transfers, the length of the `id` and `amount` arrays will be 1.
877      *
878      * Calling conditions (for each `id` and `amount` pair):
879      *
880      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
881      * of token type `id` will be  transferred to `to`.
882      * - When `from` is zero, `amount` tokens of token type `id` will be minted
883      * for `to`.
884      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
885      * will be burned.
886      * - `from` and `to` are never both zero.
887      * - `ids` and `amounts` have the same, non-zero length.
888      *
889      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
890      */
891     function _beforeTokenTransfer(
892         address operator,
893         address from,
894         address to,
895         uint256[] memory ids,
896         uint256[] memory amounts,
897         bytes memory data
898     ) internal virtual {}
899 
900     /**
901      * @dev Hook that is called after any token transfer. This includes minting
902      * and burning, as well as batched variants.
903      *
904      * The same hook is called on both single and batched variants. For single
905      * transfers, the length of the `id` and `amount` arrays will be 1.
906      *
907      * Calling conditions (for each `id` and `amount` pair):
908      *
909      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
910      * of token type `id` will be  transferred to `to`.
911      * - When `from` is zero, `amount` tokens of token type `id` will be minted
912      * for `to`.
913      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
914      * will be burned.
915      * - `from` and `to` are never both zero.
916      * - `ids` and `amounts` have the same, non-zero length.
917      *
918      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
919      */
920     function _afterTokenTransfer(
921         address operator,
922         address from,
923         address to,
924         uint256[] memory ids,
925         uint256[] memory amounts,
926         bytes memory data
927     ) internal virtual {}
928 
929     function _doSafeTransferAcceptanceCheck(
930         address operator,
931         address from,
932         address to,
933         uint256 id,
934         uint256 amount,
935         bytes memory data
936     ) private {
937         if (to.isContract()) {
938             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
939                 if (response != IERC1155Receiver.onERC1155Received.selector) {
940                     revert("ERC1155: ERC1155Receiver rejected tokens");
941                 }
942             } catch Error(string memory reason) {
943                 revert(reason);
944             } catch {
945                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
946             }
947         }
948     }
949 
950     function _doSafeBatchTransferAcceptanceCheck(
951         address operator,
952         address from,
953         address to,
954         uint256[] memory ids,
955         uint256[] memory amounts,
956         bytes memory data
957     ) private {
958         if (to.isContract()) {
959             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
960                 bytes4 response
961             ) {
962                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
963                     revert("ERC1155: ERC1155Receiver rejected tokens");
964                 }
965             } catch Error(string memory reason) {
966                 revert(reason);
967             } catch {
968                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
969             }
970         }
971     }
972 
973     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
974         uint256[] memory array = new uint256[](1);
975         array[0] = element;
976 
977         return array;
978     }
979 }
980 
981 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
982 /**
983  * @dev String operations.
984  */
985 library Strings {
986     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
987 
988     /**
989      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
990      */
991     function toString(uint256 value) internal pure returns (string memory) {
992         // Inspired by OraclizeAPI's implementation - MIT licence
993         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
994 
995         if (value == 0) {
996             return "0";
997         }
998         uint256 temp = value;
999         uint256 digits;
1000         while (temp != 0) {
1001             digits++;
1002             temp /= 10;
1003         }
1004         bytes memory buffer = new bytes(digits);
1005         while (value != 0) {
1006             digits -= 1;
1007             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1008             value /= 10;
1009         }
1010         return string(buffer);
1011     }
1012 
1013     /**
1014      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1015      */
1016     function toHexString(uint256 value) internal pure returns (string memory) {
1017         if (value == 0) {
1018             return "0x00";
1019         }
1020         uint256 temp = value;
1021         uint256 length = 0;
1022         while (temp != 0) {
1023             length++;
1024             temp >>= 8;
1025         }
1026         return toHexString(value, length);
1027     }
1028 
1029     /**
1030      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1031      */
1032     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1033         bytes memory buffer = new bytes(2 * length + 2);
1034         buffer[0] = "0";
1035         buffer[1] = "x";
1036         for (uint256 i = 2 * length + 1; i > 1; --i) {
1037             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1038             value >>= 4;
1039         }
1040         require(value == 0, "Strings: hex length insufficient");
1041         return string(buffer);
1042     }
1043 }
1044 
1045 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1046 /**
1047  * @dev Contract module which provides a basic access control mechanism, where
1048  * there is an account (an owner) that can be granted exclusive access to
1049  * specific functions.
1050  *
1051  * By default, the owner account will be the one that deploys the contract. This
1052  * can later be changed with {transferOwnership}.
1053  *
1054  * This module is used through inheritance. It will make available the modifier
1055  * `onlyOwner`, which can be applied to your functions to restrict their use to
1056  * the owner.
1057  */
1058 abstract contract Ownable is Context {
1059     address private _owner;
1060 
1061     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1062 
1063     /**
1064      * @dev Initializes the contract setting the deployer as the initial owner.
1065      */
1066     constructor() {
1067         _transferOwnership(_msgSender());
1068     }
1069 
1070     /**
1071      * @dev Returns the address of the current owner.
1072      */
1073     function owner() public view virtual returns (address) {
1074         return _owner;
1075     }
1076 
1077     /**
1078      * @dev Throws if called by any account other than the owner.
1079      */
1080     modifier onlyOwner() {
1081         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1082         _;
1083     }
1084 
1085     /**
1086      * @dev Leaves the contract without owner. It will not be possible to call
1087      * `onlyOwner` functions anymore. Can only be called by the current owner.
1088      *
1089      * NOTE: Renouncing ownership will leave the contract without an owner,
1090      * thereby removing any functionality that is only available to the owner.
1091      */
1092     function renounceOwnership() public virtual onlyOwner {
1093         _transferOwnership(address(0));
1094     }
1095 
1096     /**
1097      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1098      * Can only be called by the current owner.
1099      */
1100     function transferOwnership(address newOwner) public virtual onlyOwner {
1101         require(newOwner != address(0), "Ownable: new owner is the zero address");
1102         _transferOwnership(newOwner);
1103     }
1104 
1105     /**
1106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1107      * Internal function without access restriction.
1108      */
1109     function _transferOwnership(address newOwner) internal virtual {
1110         address oldOwner = _owner;
1111         _owner = newOwner;
1112         emit OwnershipTransferred(oldOwner, newOwner);
1113     }
1114 }
1115 
1116 contract CornyJuice is Ownable, ERC1155 {
1117   using Strings for uint256;
1118 
1119   string public baseURI;
1120   address public cornyJuiceOperator;
1121   address public burnerOperator;
1122 
1123   event BaseURI(string baseUri);
1124 
1125   string public constant name = "Corny Juice";
1126   string public constant symbol = "ANTI";
1127 
1128   constructor(address treasury, uint256 initialSupply) ERC1155("") {
1129     _mint(treasury, 0, initialSupply, "");
1130   }
1131 
1132   modifier onlyCornyJuiceOperator() {
1133     require(msg.sender == cornyJuiceOperator, "onlyCornyJuiceOperator");
1134     _;
1135   }
1136 
1137   modifier onlyBurnerOperator() {
1138     require(msg.sender == burnerOperator, "onlyBurnerOperator");
1139     _;
1140   }
1141 
1142   function setBaseURI(string memory _baseUri) external onlyOwner {
1143     baseURI = _baseUri;
1144   }
1145 
1146   function uri(uint256 tokenId) public view virtual override returns (string memory) {
1147     return string(abi.encodePacked(baseURI, tokenId.toString()));
1148   }
1149 
1150   function mint(
1151     address initialOwner,
1152     uint256 tokenId,
1153     uint256 amount,
1154     bytes memory data
1155   ) external onlyCornyJuiceOperator {
1156     _mint(initialOwner, tokenId, amount, data);
1157   }
1158 
1159   function burn(
1160     address from,
1161     uint256 tokenId,
1162     uint256 amount
1163   ) external onlyBurnerOperator {
1164     _burn(from, tokenId, amount);
1165   }
1166 
1167   function burnBatch(
1168     address from,
1169     uint256[] memory ids,
1170     uint256[] memory amounts
1171   ) external onlyBurnerOperator {
1172     _burnBatch(from, ids, amounts);
1173   }
1174 
1175   /// @notice Set the address for the corntract1155Operator
1176   /// @param _cornyJuiceOperator: address of the corntract1155Operator
1177   /// @param _burnerOperator: address of the burner contract that can burn tokens on user behalf
1178   function setOperators(address _cornyJuiceOperator, address _burnerOperator) external onlyOwner {
1179     cornyJuiceOperator = _cornyJuiceOperator;
1180     burnerOperator = _burnerOperator;
1181   }
1182 }