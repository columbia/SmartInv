1 // SPDX-License-Identifier: Unlicensed
2 // File: @openzeppelin/contracts/utils/Address.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(isContract(target), "Address: delegate call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.delegatecall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
200      * revert reason using the provided one.
201      *
202      * _Available since v4.3._
203      */
204     function verifyCallResult(
205         bool success,
206         bytes memory returndata,
207         string memory errorMessage
208     ) internal pure returns (bytes memory) {
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215 
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Interface of the ERC165 standard, as defined in the
236  * https://eips.ethereum.org/EIPS/eip-165[EIP].
237  *
238  * Implementers can declare support of contract interfaces, which can then be
239  * queried by others ({ERC165Checker}).
240  *
241  * For an implementation, see {ERC165}.
242  */
243 interface IERC165 {
244     /**
245      * @dev Returns true if this contract implements the interface defined by
246      * `interfaceId`. See the corresponding
247      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
248      * to learn more about how these ids are created.
249      *
250      * This function call must use less than 30 000 gas.
251      */
252     function supportsInterface(bytes4 interfaceId) external view returns (bool);
253 }
254 
255 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
256 
257 
258 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Implementation of the {IERC165} interface.
265  *
266  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
267  * for the additional interface id that will be supported. For example:
268  *
269  * ```solidity
270  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
271  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
272  * }
273  * ```
274  *
275  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
276  */
277 abstract contract ERC165 is IERC165 {
278     /**
279      * @dev See {IERC165-supportsInterface}.
280      */
281     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
282         return interfaceId == type(IERC165).interfaceId;
283     }
284 }
285 
286 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
287 
288 
289 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 
294 /**
295  * @dev _Available since v3.1._
296  */
297 interface IERC1155Receiver is IERC165 {
298     /**
299      * @dev Handles the receipt of a single ERC1155 token type. This function is
300      * called at the end of a `safeTransferFrom` after the balance has been updated.
301      *
302      * NOTE: To accept the transfer, this must return
303      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
304      * (i.e. 0xf23a6e61, or its own function selector).
305      *
306      * @param operator The address which initiated the transfer (i.e. msg.sender)
307      * @param from The address which previously owned the token
308      * @param id The ID of the token being transferred
309      * @param value The amount of tokens being transferred
310      * @param data Additional data with no specified format
311      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
312      */
313     function onERC1155Received(
314         address operator,
315         address from,
316         uint256 id,
317         uint256 value,
318         bytes calldata data
319     ) external returns (bytes4);
320 
321     /**
322      * @dev Handles the receipt of a multiple ERC1155 token types. This function
323      * is called at the end of a `safeBatchTransferFrom` after the balances have
324      * been updated.
325      *
326      * NOTE: To accept the transfer(s), this must return
327      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
328      * (i.e. 0xbc197c81, or its own function selector).
329      *
330      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
331      * @param from The address which previously owned the token
332      * @param ids An array containing ids of each token being transferred (order and length must match values array)
333      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
334      * @param data Additional data with no specified format
335      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
336      */
337     function onERC1155BatchReceived(
338         address operator,
339         address from,
340         uint256[] calldata ids,
341         uint256[] calldata values,
342         bytes calldata data
343     ) external returns (bytes4);
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 
354 /**
355  * @dev Required interface of an ERC1155 compliant contract, as defined in the
356  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
357  *
358  * _Available since v3.1._
359  */
360 interface IERC1155 is IERC165 {
361     /**
362      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
363      */
364     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
365 
366     /**
367      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
368      * transfers.
369      */
370     event TransferBatch(
371         address indexed operator,
372         address indexed from,
373         address indexed to,
374         uint256[] ids,
375         uint256[] values
376     );
377 
378     /**
379      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
380      * `approved`.
381      */
382     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
383 
384     /**
385      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
386      *
387      * If an {URI} event was emitted for `id`, the standard
388      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
389      * returned by {IERC1155MetadataURI-uri}.
390      */
391     event URI(string value, uint256 indexed id);
392 
393     /**
394      * @dev Returns the amount of tokens of token type `id` owned by `account`.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      */
400     function balanceOf(address account, uint256 id) external view returns (uint256);
401 
402     /**
403      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
404      *
405      * Requirements:
406      *
407      * - `accounts` and `ids` must have the same length.
408      */
409     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
410         external
411         view
412         returns (uint256[] memory);
413 
414     /**
415      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
416      *
417      * Emits an {ApprovalForAll} event.
418      *
419      * Requirements:
420      *
421      * - `operator` cannot be the caller.
422      */
423     function setApprovalForAll(address operator, bool approved) external;
424 
425     /**
426      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
427      *
428      * See {setApprovalForAll}.
429      */
430     function isApprovedForAll(address account, address operator) external view returns (bool);
431 
432     /**
433      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
434      *
435      * Emits a {TransferSingle} event.
436      *
437      * Requirements:
438      *
439      * - `to` cannot be the zero address.
440      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
441      * - `from` must have a balance of tokens of type `id` of at least `amount`.
442      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
443      * acceptance magic value.
444      */
445     function safeTransferFrom(
446         address from,
447         address to,
448         uint256 id,
449         uint256 amount,
450         bytes calldata data
451     ) external;
452 
453     /**
454      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
455      *
456      * Emits a {TransferBatch} event.
457      *
458      * Requirements:
459      *
460      * - `ids` and `amounts` must have the same length.
461      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
462      * acceptance magic value.
463      */
464     function safeBatchTransferFrom(
465         address from,
466         address to,
467         uint256[] calldata ids,
468         uint256[] calldata amounts,
469         bytes calldata data
470     ) external;
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
483  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
484  *
485  * _Available since v3.1._
486  */
487 interface IERC1155MetadataURI is IERC1155 {
488     /**
489      * @dev Returns the URI for token type `id`.
490      *
491      * If the `\{id\}` substring is present in the URI, it must be replaced by
492      * clients with the actual token type ID.
493      */
494     function uri(uint256 id) external view returns (string memory);
495 }
496 
497 // File: @openzeppelin/contracts/utils/Context.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev Provides information about the current execution context, including the
506  * sender of the transaction and its data. While these are generally available
507  * via msg.sender and msg.data, they should not be accessed in such a direct
508  * manner, since when dealing with meta-transactions the account sending and
509  * paying for execution may not be the actual sender (as far as an application
510  * is concerned).
511  *
512  * This contract is only required for intermediate, library-like contracts.
513  */
514 abstract contract Context {
515     function _msgSender() internal view virtual returns (address) {
516         return msg.sender;
517     }
518 
519     function _msgData() internal view virtual returns (bytes calldata) {
520         return msg.data;
521     }
522 }
523 
524 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
525 
526 
527 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 
532 
533 
534 
535 
536 
537 /**
538  * @dev Implementation of the basic standard multi-token.
539  * See https://eips.ethereum.org/EIPS/eip-1155
540  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
541  *
542  * _Available since v3.1._
543  */
544 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
545     using Address for address;
546 
547     // Mapping from token ID to account balances
548     mapping(uint256 => mapping(address => uint256)) private _balances;
549 
550     // Mapping from account to operator approvals
551     mapping(address => mapping(address => bool)) private _operatorApprovals;
552 
553     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
554     string private _uri;
555 
556     /**
557      * @dev See {_setURI}.
558      */
559     constructor(string memory uri_) {
560         _setURI(uri_);
561     }
562 
563     /**
564      * @dev See {IERC165-supportsInterface}.
565      */
566     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
567         return
568             interfaceId == type(IERC1155).interfaceId ||
569             interfaceId == type(IERC1155MetadataURI).interfaceId ||
570             super.supportsInterface(interfaceId);
571     }
572 
573     /**
574      * @dev See {IERC1155MetadataURI-uri}.
575      *
576      * This implementation returns the same URI for *all* token types. It relies
577      * on the token type ID substitution mechanism
578      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
579      *
580      * Clients calling this function must replace the `\{id\}` substring with the
581      * actual token type ID.
582      */
583     function uri(uint256) public view virtual override returns (string memory) {
584         return _uri;
585     }
586 
587     /**
588      * @dev See {IERC1155-balanceOf}.
589      *
590      * Requirements:
591      *
592      * - `account` cannot be the zero address.
593      */
594     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
595         require(account != address(0), "ERC1155: balance query for the zero address");
596         return _balances[id][account];
597     }
598 
599     /**
600      * @dev See {IERC1155-balanceOfBatch}.
601      *
602      * Requirements:
603      *
604      * - `accounts` and `ids` must have the same length.
605      */
606     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
607         public
608         view
609         virtual
610         override
611         returns (uint256[] memory)
612     {
613         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
614 
615         uint256[] memory batchBalances = new uint256[](accounts.length);
616 
617         for (uint256 i = 0; i < accounts.length; ++i) {
618             batchBalances[i] = balanceOf(accounts[i], ids[i]);
619         }
620 
621         return batchBalances;
622     }
623 
624     /**
625      * @dev See {IERC1155-setApprovalForAll}.
626      */
627     function setApprovalForAll(address operator, bool approved) public virtual override {
628         _setApprovalForAll(_msgSender(), operator, approved);
629     }
630 
631     /**
632      * @dev See {IERC1155-isApprovedForAll}.
633      */
634     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
635         return _operatorApprovals[account][operator];
636     }
637 
638     /**
639      * @dev See {IERC1155-safeTransferFrom}.
640      */
641     function safeTransferFrom(
642         address from,
643         address to,
644         uint256 id,
645         uint256 amount,
646         bytes memory data
647     ) public virtual override {
648         require(
649             from == _msgSender() || isApprovedForAll(from, _msgSender()),
650             "ERC1155: caller is not owner nor approved"
651         );
652         _safeTransferFrom(from, to, id, amount, data);
653     }
654 
655     /**
656      * @dev See {IERC1155-safeBatchTransferFrom}.
657      */
658     function safeBatchTransferFrom(
659         address from,
660         address to,
661         uint256[] memory ids,
662         uint256[] memory amounts,
663         bytes memory data
664     ) public virtual override {
665         require(
666             from == _msgSender() || isApprovedForAll(from, _msgSender()),
667             "ERC1155: transfer caller is not owner nor approved"
668         );
669         _safeBatchTransferFrom(from, to, ids, amounts, data);
670     }
671 
672     /**
673      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
674      *
675      * Emits a {TransferSingle} event.
676      *
677      * Requirements:
678      *
679      * - `to` cannot be the zero address.
680      * - `from` must have a balance of tokens of type `id` of at least `amount`.
681      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
682      * acceptance magic value.
683      */
684     function _safeTransferFrom(
685         address from,
686         address to,
687         uint256 id,
688         uint256 amount,
689         bytes memory data
690     ) internal virtual {
691         require(to != address(0), "ERC1155: transfer to the zero address");
692 
693         address operator = _msgSender();
694         uint256[] memory ids = _asSingletonArray(id);
695         uint256[] memory amounts = _asSingletonArray(amount);
696 
697         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
698 
699         uint256 fromBalance = _balances[id][from];
700         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
701         unchecked {
702             _balances[id][from] = fromBalance - amount;
703         }
704         _balances[id][to] += amount;
705 
706         emit TransferSingle(operator, from, to, id, amount);
707 
708         _afterTokenTransfer(operator, from, to, ids, amounts, data);
709 
710         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
711     }
712 
713     /**
714      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
715      *
716      * Emits a {TransferBatch} event.
717      *
718      * Requirements:
719      *
720      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
721      * acceptance magic value.
722      */
723     function _safeBatchTransferFrom(
724         address from,
725         address to,
726         uint256[] memory ids,
727         uint256[] memory amounts,
728         bytes memory data
729     ) internal virtual {
730         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
731         require(to != address(0), "ERC1155: transfer to the zero address");
732 
733         address operator = _msgSender();
734 
735         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
736 
737         for (uint256 i = 0; i < ids.length; ++i) {
738             uint256 id = ids[i];
739             uint256 amount = amounts[i];
740 
741             uint256 fromBalance = _balances[id][from];
742             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
743             unchecked {
744                 _balances[id][from] = fromBalance - amount;
745             }
746             _balances[id][to] += amount;
747         }
748 
749         emit TransferBatch(operator, from, to, ids, amounts);
750 
751         _afterTokenTransfer(operator, from, to, ids, amounts, data);
752 
753         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
754     }
755 
756     /**
757      * @dev Sets a new URI for all token types, by relying on the token type ID
758      * substitution mechanism
759      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
760      *
761      * By this mechanism, any occurrence of the `\{id\}` substring in either the
762      * URI or any of the amounts in the JSON file at said URI will be replaced by
763      * clients with the token type ID.
764      *
765      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
766      * interpreted by clients as
767      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
768      * for token type ID 0x4cce0.
769      *
770      * See {uri}.
771      *
772      * Because these URIs cannot be meaningfully represented by the {URI} event,
773      * this function emits no events.
774      */
775     function _setURI(string memory newuri) internal virtual {
776         _uri = newuri;
777     }
778 
779     /**
780      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
781      *
782      * Emits a {TransferSingle} event.
783      *
784      * Requirements:
785      *
786      * - `to` cannot be the zero address.
787      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
788      * acceptance magic value.
789      */
790     function _mint(
791         address to,
792         uint256 id,
793         uint256 amount,
794         bytes memory data
795     ) internal virtual {
796         require(to != address(0), "ERC1155: mint to the zero address");
797 
798         address operator = _msgSender();
799         uint256[] memory ids = _asSingletonArray(id);
800         uint256[] memory amounts = _asSingletonArray(amount);
801 
802         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
803 
804         _balances[id][to] += amount;
805         emit TransferSingle(operator, address(0), to, id, amount);
806 
807         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
808 
809         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
810     }
811 
812     /**
813      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
814      *
815      * Requirements:
816      *
817      * - `ids` and `amounts` must have the same length.
818      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
819      * acceptance magic value.
820      */
821     function _mintBatch(
822         address to,
823         uint256[] memory ids,
824         uint256[] memory amounts,
825         bytes memory data
826     ) internal virtual {
827         require(to != address(0), "ERC1155: mint to the zero address");
828         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
829 
830         address operator = _msgSender();
831 
832         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
833 
834         for (uint256 i = 0; i < ids.length; i++) {
835             _balances[ids[i]][to] += amounts[i];
836         }
837 
838         emit TransferBatch(operator, address(0), to, ids, amounts);
839 
840         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
841 
842         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
843     }
844 
845     /**
846      * @dev Destroys `amount` tokens of token type `id` from `from`
847      *
848      * Requirements:
849      *
850      * - `from` cannot be the zero address.
851      * - `from` must have at least `amount` tokens of token type `id`.
852      */
853     function _burn(
854         address from,
855         uint256 id,
856         uint256 amount
857     ) internal virtual {
858         require(from != address(0), "ERC1155: burn from the zero address");
859 
860         address operator = _msgSender();
861         uint256[] memory ids = _asSingletonArray(id);
862         uint256[] memory amounts = _asSingletonArray(amount);
863 
864         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
865 
866         uint256 fromBalance = _balances[id][from];
867         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
868         unchecked {
869             _balances[id][from] = fromBalance - amount;
870         }
871 
872         emit TransferSingle(operator, from, address(0), id, amount);
873 
874         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
875     }
876 
877     /**
878      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
879      *
880      * Requirements:
881      *
882      * - `ids` and `amounts` must have the same length.
883      */
884     function _burnBatch(
885         address from,
886         uint256[] memory ids,
887         uint256[] memory amounts
888     ) internal virtual {
889         require(from != address(0), "ERC1155: burn from the zero address");
890         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
891 
892         address operator = _msgSender();
893 
894         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
895 
896         for (uint256 i = 0; i < ids.length; i++) {
897             uint256 id = ids[i];
898             uint256 amount = amounts[i];
899 
900             uint256 fromBalance = _balances[id][from];
901             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
902             unchecked {
903                 _balances[id][from] = fromBalance - amount;
904             }
905         }
906 
907         emit TransferBatch(operator, from, address(0), ids, amounts);
908 
909         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
910     }
911 
912     /**
913      * @dev Approve `operator` to operate on all of `owner` tokens
914      *
915      * Emits a {ApprovalForAll} event.
916      */
917     function _setApprovalForAll(
918         address owner,
919         address operator,
920         bool approved
921     ) internal virtual {
922         require(owner != operator, "ERC1155: setting approval status for self");
923         _operatorApprovals[owner][operator] = approved;
924         emit ApprovalForAll(owner, operator, approved);
925     }
926 
927     /**
928      * @dev Hook that is called before any token transfer. This includes minting
929      * and burning, as well as batched variants.
930      *
931      * The same hook is called on both single and batched variants. For single
932      * transfers, the length of the `id` and `amount` arrays will be 1.
933      *
934      * Calling conditions (for each `id` and `amount` pair):
935      *
936      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
937      * of token type `id` will be  transferred to `to`.
938      * - When `from` is zero, `amount` tokens of token type `id` will be minted
939      * for `to`.
940      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
941      * will be burned.
942      * - `from` and `to` are never both zero.
943      * - `ids` and `amounts` have the same, non-zero length.
944      *
945      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
946      */
947     function _beforeTokenTransfer(
948         address operator,
949         address from,
950         address to,
951         uint256[] memory ids,
952         uint256[] memory amounts,
953         bytes memory data
954     ) internal virtual {}
955 
956     /**
957      * @dev Hook that is called after any token transfer. This includes minting
958      * and burning, as well as batched variants.
959      *
960      * The same hook is called on both single and batched variants. For single
961      * transfers, the length of the `id` and `amount` arrays will be 1.
962      *
963      * Calling conditions (for each `id` and `amount` pair):
964      *
965      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
966      * of token type `id` will be  transferred to `to`.
967      * - When `from` is zero, `amount` tokens of token type `id` will be minted
968      * for `to`.
969      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
970      * will be burned.
971      * - `from` and `to` are never both zero.
972      * - `ids` and `amounts` have the same, non-zero length.
973      *
974      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
975      */
976     function _afterTokenTransfer(
977         address operator,
978         address from,
979         address to,
980         uint256[] memory ids,
981         uint256[] memory amounts,
982         bytes memory data
983     ) internal virtual {}
984 
985     function _doSafeTransferAcceptanceCheck(
986         address operator,
987         address from,
988         address to,
989         uint256 id,
990         uint256 amount,
991         bytes memory data
992     ) private {
993         if (to.isContract()) {
994             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
995                 if (response != IERC1155Receiver.onERC1155Received.selector) {
996                     revert("ERC1155: ERC1155Receiver rejected tokens");
997                 }
998             } catch Error(string memory reason) {
999                 revert(reason);
1000             } catch {
1001                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1002             }
1003         }
1004     }
1005 
1006     function _doSafeBatchTransferAcceptanceCheck(
1007         address operator,
1008         address from,
1009         address to,
1010         uint256[] memory ids,
1011         uint256[] memory amounts,
1012         bytes memory data
1013     ) private {
1014         if (to.isContract()) {
1015             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1016                 bytes4 response
1017             ) {
1018                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1019                     revert("ERC1155: ERC1155Receiver rejected tokens");
1020                 }
1021             } catch Error(string memory reason) {
1022                 revert(reason);
1023             } catch {
1024                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1025             }
1026         }
1027     }
1028 
1029     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1030         uint256[] memory array = new uint256[](1);
1031         array[0] = element;
1032 
1033         return array;
1034     }
1035 }
1036 
1037 // File: @openzeppelin/contracts/access/Ownable.sol
1038 
1039 
1040 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 
1045 /**
1046  * @dev Contract module which provides a basic access control mechanism, where
1047  * there is an account (an owner) that can be granted exclusive access to
1048  * specific functions.
1049  *
1050  * By default, the owner account will be the one that deploys the contract. This
1051  * can later be changed with {transferOwnership}.
1052  *
1053  * This module is used through inheritance. It will make available the modifier
1054  * `onlyOwner`, which can be applied to your functions to restrict their use to
1055  * the owner.
1056  */
1057 abstract contract Ownable is Context {
1058     address private _owner;
1059 
1060     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1061 
1062     /**
1063      * @dev Initializes the contract setting the deployer as the initial owner.
1064      */
1065     constructor() {
1066         _transferOwnership(_msgSender());
1067     }
1068 
1069     /**
1070      * @dev Returns the address of the current owner.
1071      */
1072     function owner() public view virtual returns (address) {
1073         return _owner;
1074     }
1075 
1076     /**
1077      * @dev Throws if called by any account other than the owner.
1078      */
1079     modifier onlyOwner() {
1080         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1081         _;
1082     }
1083 
1084     /**
1085      * @dev Leaves the contract without owner. It will not be possible to call
1086      * `onlyOwner` functions anymore. Can only be called by the current owner.
1087      *
1088      * NOTE: Renouncing ownership will leave the contract without an owner,
1089      * thereby removing any functionality that is only available to the owner.
1090      */
1091     function renounceOwnership() public virtual onlyOwner {
1092         _transferOwnership(address(0));
1093     }
1094 
1095     /**
1096      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1097      * Can only be called by the current owner.
1098      */
1099     function transferOwnership(address newOwner) public virtual onlyOwner {
1100         require(newOwner != address(0), "Ownable: new owner is the zero address");
1101         _transferOwnership(newOwner);
1102     }
1103 
1104     /**
1105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1106      * Internal function without access restriction.
1107      */
1108     function _transferOwnership(address newOwner) internal virtual {
1109         address oldOwner = _owner;
1110         _owner = newOwner;
1111         emit OwnershipTransferred(oldOwner, newOwner);
1112     }
1113 }
1114 
1115 // File: contracts/NFTMagMintPass.sol
1116 
1117 
1118 
1119 pragma solidity ^0.8.0;
1120 
1121 
1122 
1123 contract NFTMagMintPass is ERC1155, Ownable {
1124     uint256 public maxMintAmount = 5000; // Max amount mintable
1125     bool public paused = false; // Incase we need to pause the contract
1126     uint256 public cost = 0.00 ether;
1127     uint256 counter = 0;
1128     mapping(address => uint256) public addressMintedBalance;
1129 
1130     constructor() ERC1155 ("ipfs://QmdHvvoehCV8dGwZUqHF3UcK9D5UjV8Ma6PSu8RRRrNboA") {}
1131 
1132     function mint(uint256 amount) public payable {
1133         require(counter <= maxMintAmount, "max amount reached");
1134         if (msg.sender != owner()) {
1135             require(!paused, "the contract is paused");
1136             require(msg.value >= cost, "insufficient funds");
1137             require(addressMintedBalance[msg.sender] < 3, "max mint amount per wallet exceeded");
1138             addressMintedBalance[msg.sender]++;
1139         }
1140         _mint(msg.sender, 1, amount, "");
1141         counter += amount;
1142     }
1143 
1144     function userAllowed() public view returns (bool) {
1145         return addressMintedBalance[msg.sender] == 0;
1146     }
1147 
1148     function transfer(
1149         address from,
1150         address to,
1151         uint256 id,
1152         uint256 amount
1153     ) public {
1154         require(msg.sender == from, "Only owner of NFT can transfer");
1155         require(amount > 0, "need to transfer at least 1 NFT");
1156         _safeTransferFrom(from, to, id, amount, "");
1157     }
1158 
1159     function burn(
1160         address account,
1161         uint256 id,
1162         uint256 amount
1163     ) public {
1164         require(msg.sender == account);
1165         _burn(account, id, amount);
1166     }
1167 
1168     // Owners only functions
1169 
1170     function setCost(uint256 _newCost) public onlyOwner {
1171         cost = _newCost;
1172     }
1173 
1174     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1175         maxMintAmount = _newmaxMintAmount;
1176     }
1177 
1178     function pause(bool _state) public onlyOwner {
1179         paused = _state;
1180     }
1181 
1182     function withdraw() public payable onlyOwner {
1183         // This will payout the owner the contract balance.
1184         // Do not remove this otherwise you will not be able to withdraw the funds.
1185         // =============================================================================
1186         uint256 totalBalance = address(this).balance;
1187         uint256 ownerBalance = (totalBalance / 1000000) * 1000000;
1188         (bool p1, ) = payable(0x63bFdd398b74c208EDB8a7e45910d0AAC4858D6A).call{
1189             value: ownerBalance
1190         }("");
1191         require(p1);
1192        
1193         // =============================================================================
1194     }
1195 }