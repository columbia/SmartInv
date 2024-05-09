1 // SPDX-License-Identifier: UNLISENCED
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 pragma solidity ^0.8.1;
26 
27 /**
28  * @dev Collection of functions related to the address type
29  */
30 library Address {
31     /**
32      * @dev Returns true if `account` is a contract.
33      *
34      * [IMPORTANT]
35      * ====
36      * It is unsafe to assume that an address for which this function returns
37      * false is an externally-owned account (EOA) and not a contract.
38      *
39      * Among others, `isContract` will return false for the following
40      * types of addresses:
41      *
42      *  - an externally-owned account
43      *  - a contract in construction
44      *  - an address where a contract will be created
45      *  - an address where a contract lived, but was destroyed
46      * ====
47      *
48      * [IMPORTANT]
49      * ====
50      * You shouldn't rely on `isContract` to protect against flash loan attacks!
51      *
52      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
53      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
54      * constructor.
55      * ====
56      */
57     function isContract(address account) internal view returns (bool) {
58         // This method relies on extcodesize/address.code.length, which returns 0
59         // for contracts in construction, since the code is only stored at the end
60         // of the constructor execution.
61 
62         return account.code.length > 0;
63     }
64 
65     /**
66      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
67      * `recipient`, forwarding all available gas and reverting on errors.
68      *
69      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
70      * of certain opcodes, possibly making contracts go over the 2300 gas limit
71      * imposed by `transfer`, making them unable to receive funds via
72      * `transfer`. {sendValue} removes this limitation.
73      *
74      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
75      *
76      * IMPORTANT: because control is transferred to `recipient`, care must be
77      * taken to not create reentrancy vulnerabilities. Consider using
78      * {ReentrancyGuard} or the
79      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
80      */
81     function sendValue(address payable recipient, uint256 amount) internal {
82         require(address(this).balance >= amount, "Address: insufficient balance");
83 
84         (bool success, ) = recipient.call{value: amount}("");
85         require(success, "Address: unable to send value, recipient may have reverted");
86     }
87 
88     /**
89      * @dev Performs a Solidity function call using a low level `call`. A
90      * plain `call` is an unsafe replacement for a function call: use this
91      * function instead.
92      *
93      * If `target` reverts with a revert reason, it is bubbled up by this
94      * function (like regular Solidity function calls).
95      *
96      * Returns the raw returned data. To convert to the expected return value,
97      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
98      *
99      * Requirements:
100      *
101      * - `target` must be a contract.
102      * - calling `target` with `data` must not revert.
103      *
104      * _Available since v3.1._
105      */
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
112      * `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCall(
117         address target,
118         bytes memory data,
119         string memory errorMessage
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, 0, errorMessage);
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
126      * but also transferring `value` wei to `target`.
127      *
128      * Requirements:
129      *
130      * - the calling contract must have an ETH balance of at least `value`.
131      * - the called Solidity function must be `payable`.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(
136         address target,
137         bytes memory data,
138         uint256 value
139     ) internal returns (bytes memory) {
140         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
145      * with `errorMessage` as a fallback revert reason when `target` reverts.
146      *
147      * _Available since v3.1._
148      */
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value,
153         string memory errorMessage
154     ) internal returns (bytes memory) {
155         require(address(this).balance >= value, "Address: insufficient balance for call");
156         (bool success, bytes memory returndata) = target.call{value: value}(data);
157         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
162      * but performing a static call.
163      *
164      * _Available since v3.3._
165      */
166     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
167         return functionStaticCall(target, data, "Address: low-level static call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
172      * but performing a static call.
173      *
174      * _Available since v3.3._
175      */
176     function functionStaticCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal view returns (bytes memory) {
181         (bool success, bytes memory returndata) = target.staticcall(data);
182         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
187      * but performing a delegate call.
188      *
189      * _Available since v3.4._
190      */
191     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
192         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
197      * but performing a delegate call.
198      *
199      * _Available since v3.4._
200      */
201     function functionDelegateCall(
202         address target,
203         bytes memory data,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         (bool success, bytes memory returndata) = target.delegatecall(data);
207         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
212      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
213      *
214      * _Available since v4.8._
215      */
216     function verifyCallResultFromTarget(
217         address target,
218         bool success,
219         bytes memory returndata,
220         string memory errorMessage
221     ) internal view returns (bytes memory) {
222         if (success) {
223             if (returndata.length == 0) {
224                 // only check isContract if the call was successful and the return data is empty
225                 // otherwise we already know that it was a contract
226                 require(isContract(target), "Address: call to non-contract");
227             }
228             return returndata;
229         } else {
230             _revert(returndata, errorMessage);
231         }
232     }
233 
234     /**
235      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
236      * revert reason or using the provided one.
237      *
238      * _Available since v4.3._
239      */
240     function verifyCallResult(
241         bool success,
242         bytes memory returndata,
243         string memory errorMessage
244     ) internal pure returns (bytes memory) {
245         if (success) {
246             return returndata;
247         } else {
248             _revert(returndata, errorMessage);
249         }
250     }
251 
252     function _revert(bytes memory returndata, string memory errorMessage) private pure {
253         // Look for revert reason and bubble it up if present
254         if (returndata.length > 0) {
255             // The easiest way to bubble the revert reason is using memory via assembly
256             /// @solidity memory-safe-assembly
257             assembly {
258                 let returndata_size := mload(returndata)
259                 revert(add(32, returndata), returndata_size)
260             }
261         } else {
262             revert(errorMessage);
263         }
264     }
265 }
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @dev Interface of the ERC165 standard, as defined in the
271  * https://eips.ethereum.org/EIPS/eip-165[EIP].
272  *
273  * Implementers can declare support of contract interfaces, which can then be
274  * queried by others ({ERC165Checker}).
275  *
276  * For an implementation, see {ERC165}.
277  */
278 interface IERC165 {
279     /**
280      * @dev Returns true if this contract implements the interface defined by
281      * `interfaceId`. See the corresponding
282      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
283      * to learn more about how these ids are created.
284      *
285      * This function call must use less than 30 000 gas.
286      */
287     function supportsInterface(bytes4 interfaceId) external view returns (bool);
288 }
289 
290 pragma solidity ^0.8.0;
291 
292 
293 /**
294  * @dev Implementation of the {IERC165} interface.
295  *
296  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
297  * for the additional interface id that will be supported. For example:
298  *
299  * ```solidity
300  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
301  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
302  * }
303  * ```
304  *
305  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
306  */
307 abstract contract ERC165 is IERC165 {
308     /**
309      * @dev See {IERC165-supportsInterface}.
310      */
311     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
312         return interfaceId == type(IERC165).interfaceId;
313     }
314 }
315 
316 pragma solidity ^0.8.0;
317 
318 
319 /**
320  * @dev _Available since v3.1._
321  */
322 interface IERC1155Receiver is IERC165 {
323     /**
324      * @dev Handles the receipt of a single ERC1155 token type. This function is
325      * called at the end of a `safeTransferFrom` after the balance has been updated.
326      *
327      * NOTE: To accept the transfer, this must return
328      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
329      * (i.e. 0xf23a6e61, or its own function selector).
330      *
331      * @param operator The address which initiated the transfer (i.e. msg.sender)
332      * @param from The address which previously owned the token
333      * @param id The ID of the token being transferred
334      * @param value The amount of tokens being transferred
335      * @param data Additional data with no specified format
336      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
337      */
338     function onERC1155Received(
339         address operator,
340         address from,
341         uint256 id,
342         uint256 value,
343         bytes calldata data
344     ) external returns (bytes4);
345 
346     /**
347      * @dev Handles the receipt of a multiple ERC1155 token types. This function
348      * is called at the end of a `safeBatchTransferFrom` after the balances have
349      * been updated.
350      *
351      * NOTE: To accept the transfer(s), this must return
352      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
353      * (i.e. 0xbc197c81, or its own function selector).
354      *
355      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
356      * @param from The address which previously owned the token
357      * @param ids An array containing ids of each token being transferred (order and length must match values array)
358      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
359      * @param data Additional data with no specified format
360      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
361      */
362     function onERC1155BatchReceived(
363         address operator,
364         address from,
365         uint256[] calldata ids,
366         uint256[] calldata values,
367         bytes calldata data
368     ) external returns (bytes4);
369 }
370 
371 pragma solidity ^0.8.0;
372 
373 
374 /**
375  * @dev Required interface of an ERC1155 compliant contract, as defined in the
376  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
377  *
378  * _Available since v3.1._
379  */
380 interface IERC1155 is IERC165 {
381     /**
382      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
383      */
384     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
385 
386     /**
387      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
388      * transfers.
389      */
390     event TransferBatch(
391         address indexed operator,
392         address indexed from,
393         address indexed to,
394         uint256[] ids,
395         uint256[] values
396     );
397 
398     /**
399      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
400      * `approved`.
401      */
402     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
403 
404     /**
405      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
406      *
407      * If an {URI} event was emitted for `id`, the standard
408      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
409      * returned by {IERC1155MetadataURI-uri}.
410      */
411     event URI(string value, uint256 indexed id);
412 
413     /**
414      * @dev Returns the amount of tokens of token type `id` owned by `account`.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      */
420     function balanceOf(address account, uint256 id) external view returns (uint256);
421 
422     /**
423      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
424      *
425      * Requirements:
426      *
427      * - `accounts` and `ids` must have the same length.
428      */
429     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
430         external
431         view
432         returns (uint256[] memory);
433 
434     /**
435      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
436      *
437      * Emits an {ApprovalForAll} event.
438      *
439      * Requirements:
440      *
441      * - `operator` cannot be the caller.
442      */
443     function setApprovalForAll(address operator, bool approved) external;
444 
445     /**
446      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
447      *
448      * See {setApprovalForAll}.
449      */
450     function isApprovedForAll(address account, address operator) external view returns (bool);
451 
452     /**
453      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
454      *
455      * Emits a {TransferSingle} event.
456      *
457      * Requirements:
458      *
459      * - `to` cannot be the zero address.
460      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
461      * - `from` must have a balance of tokens of type `id` of at least `amount`.
462      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
463      * acceptance magic value.
464      */
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 id,
469         uint256 amount,
470         bytes calldata data
471     ) external;
472 
473     /**
474      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
475      *
476      * Emits a {TransferBatch} event.
477      *
478      * Requirements:
479      *
480      * - `ids` and `amounts` must have the same length.
481      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
482      * acceptance magic value.
483      */
484     function safeBatchTransferFrom(
485         address from,
486         address to,
487         uint256[] calldata ids,
488         uint256[] calldata amounts,
489         bytes calldata data
490     ) external;
491 }
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
498  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
499  *
500  * _Available since v3.1._
501  */
502 interface IERC1155MetadataURI is IERC1155 {
503     /**
504      * @dev Returns the URI for token type `id`.
505      *
506      * If the `\{id\}` substring is present in the URI, it must be replaced by
507      * clients with the actual token type ID.
508      */
509     function uri(uint256 id) external view returns (string memory);
510 }
511 
512 pragma solidity ^0.8.0;
513 
514 
515 
516 
517 
518 
519 
520 /**
521  * @dev Implementation of the basic standard multi-token.
522  * See https://eips.ethereum.org/EIPS/eip-1155
523  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
524  *
525  * _Available since v3.1._
526  */
527 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
528     using Address for address;
529 
530     // Mapping from token ID to account balances
531     mapping(uint256 => mapping(address => uint256)) private _balances;
532 
533     // Mapping from account to operator approvals
534     mapping(address => mapping(address => bool)) private _operatorApprovals;
535 
536     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
537     string private _uri;
538 
539     /**
540      * @dev See {_setURI}.
541      */
542     constructor(string memory uri_) {
543         _setURI(uri_);
544     }
545 
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
550         return
551             interfaceId == type(IERC1155).interfaceId ||
552             interfaceId == type(IERC1155MetadataURI).interfaceId ||
553             super.supportsInterface(interfaceId);
554     }
555 
556     /**
557      * @dev See {IERC1155MetadataURI-uri}.
558      *
559      * This implementation returns the same URI for *all* token types. It relies
560      * on the token type ID substitution mechanism
561      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
562      *
563      * Clients calling this function must replace the `\{id\}` substring with the
564      * actual token type ID.
565      */
566     function uri(uint256) public view virtual override returns (string memory) {
567         return _uri;
568     }
569 
570     /**
571      * @dev See {IERC1155-balanceOf}.
572      *
573      * Requirements:
574      *
575      * - `account` cannot be the zero address.
576      */
577     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
578         require(account != address(0), "ERC1155: address zero is not a valid owner");
579         return _balances[id][account];
580     }
581 
582     /**
583      * @dev See {IERC1155-balanceOfBatch}.
584      *
585      * Requirements:
586      *
587      * - `accounts` and `ids` must have the same length.
588      */
589     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
590         public
591         view
592         virtual
593         override
594         returns (uint256[] memory)
595     {
596         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
597 
598         uint256[] memory batchBalances = new uint256[](accounts.length);
599 
600         for (uint256 i = 0; i < accounts.length; ++i) {
601             batchBalances[i] = balanceOf(accounts[i], ids[i]);
602         }
603 
604         return batchBalances;
605     }
606 
607     /**
608      * @dev See {IERC1155-setApprovalForAll}.
609      */
610     function setApprovalForAll(address operator, bool approved) public virtual override {
611         _setApprovalForAll(_msgSender(), operator, approved);
612     }
613 
614     /**
615      * @dev See {IERC1155-isApprovedForAll}.
616      */
617     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
618         return _operatorApprovals[account][operator];
619     }
620 
621     /**
622      * @dev See {IERC1155-safeTransferFrom}.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 id,
628         uint256 amount,
629         bytes memory data
630     ) public virtual override {
631         require(
632             from == _msgSender() || isApprovedForAll(from, _msgSender()),
633             "ERC1155: caller is not token owner or approved"
634         );
635         _safeTransferFrom(from, to, id, amount, data);
636     }
637 
638     /**
639      * @dev See {IERC1155-safeBatchTransferFrom}.
640      */
641     function safeBatchTransferFrom(
642         address from,
643         address to,
644         uint256[] memory ids,
645         uint256[] memory amounts,
646         bytes memory data
647     ) public virtual override {
648         require(
649             from == _msgSender() || isApprovedForAll(from, _msgSender()),
650             "ERC1155: caller is not token owner or approved"
651         );
652         _safeBatchTransferFrom(from, to, ids, amounts, data);
653     }
654 
655     /**
656      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
657      *
658      * Emits a {TransferSingle} event.
659      *
660      * Requirements:
661      *
662      * - `to` cannot be the zero address.
663      * - `from` must have a balance of tokens of type `id` of at least `amount`.
664      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
665      * acceptance magic value.
666      */
667     function _safeTransferFrom(
668         address from,
669         address to,
670         uint256 id,
671         uint256 amount,
672         bytes memory data
673     ) internal virtual {
674         require(to != address(0), "ERC1155: transfer to the zero address");
675 
676         address operator = _msgSender();
677         uint256[] memory ids = _asSingletonArray(id);
678         uint256[] memory amounts = _asSingletonArray(amount);
679 
680         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
681 
682         uint256 fromBalance = _balances[id][from];
683         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
684         unchecked {
685             _balances[id][from] = fromBalance - amount;
686         }
687         _balances[id][to] += amount;
688 
689         emit TransferSingle(operator, from, to, id, amount);
690 
691         _afterTokenTransfer(operator, from, to, ids, amounts, data);
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
734         _afterTokenTransfer(operator, from, to, ids, amounts, data);
735 
736         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
737     }
738 
739     /**
740      * @dev Sets a new URI for all token types, by relying on the token type ID
741      * substitution mechanism
742      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
743      *
744      * By this mechanism, any occurrence of the `\{id\}` substring in either the
745      * URI or any of the amounts in the JSON file at said URI will be replaced by
746      * clients with the token type ID.
747      *
748      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
749      * interpreted by clients as
750      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
751      * for token type ID 0x4cce0.
752      *
753      * See {uri}.
754      *
755      * Because these URIs cannot be meaningfully represented by the {URI} event,
756      * this function emits no events.
757      */
758     function _setURI(string memory newuri) internal virtual {
759         _uri = newuri;
760     }
761 
762     /**
763      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
764      *
765      * Emits a {TransferSingle} event.
766      *
767      * Requirements:
768      *
769      * - `to` cannot be the zero address.
770      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
771      * acceptance magic value.
772      */
773     function _mint(
774         address to,
775         uint256 id,
776         uint256 amount,
777         bytes memory data
778     ) internal virtual {
779         require(to != address(0), "ERC1155: mint to the zero address");
780 
781         address operator = _msgSender();
782         uint256[] memory ids = _asSingletonArray(id);
783         uint256[] memory amounts = _asSingletonArray(amount);
784 
785         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
786 
787         _balances[id][to] += amount;
788         emit TransferSingle(operator, address(0), to, id, amount);
789 
790         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
791 
792         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
793     }
794 
795     /**
796      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
797      *
798      * Emits a {TransferBatch} event.
799      *
800      * Requirements:
801      *
802      * - `ids` and `amounts` must have the same length.
803      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
804      * acceptance magic value.
805      */
806     function _mintBatch(
807         address to,
808         uint256[] memory ids,
809         uint256[] memory amounts,
810         bytes memory data
811     ) internal virtual {
812         require(to != address(0), "ERC1155: mint to the zero address");
813         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
814 
815         address operator = _msgSender();
816 
817         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
818 
819         for (uint256 i = 0; i < ids.length; i++) {
820             _balances[ids[i]][to] += amounts[i];
821         }
822 
823         emit TransferBatch(operator, address(0), to, ids, amounts);
824 
825         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
826 
827         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
828     }
829 
830     /**
831      * @dev Destroys `amount` tokens of token type `id` from `from`
832      *
833      * Emits a {TransferSingle} event.
834      *
835      * Requirements:
836      *
837      * - `from` cannot be the zero address.
838      * - `from` must have at least `amount` tokens of token type `id`.
839      */
840     function _burn(
841         address from,
842         uint256 id,
843         uint256 amount
844     ) internal virtual {
845         require(from != address(0), "ERC1155: burn from the zero address");
846 
847         address operator = _msgSender();
848         uint256[] memory ids = _asSingletonArray(id);
849         uint256[] memory amounts = _asSingletonArray(amount);
850 
851         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
852 
853         uint256 fromBalance = _balances[id][from];
854         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
855         unchecked {
856             _balances[id][from] = fromBalance - amount;
857         }
858 
859         emit TransferSingle(operator, from, address(0), id, amount);
860 
861         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
862     }
863 
864     /**
865      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
866      *
867      * Emits a {TransferBatch} event.
868      *
869      * Requirements:
870      *
871      * - `ids` and `amounts` must have the same length.
872      */
873     function _burnBatch(
874         address from,
875         uint256[] memory ids,
876         uint256[] memory amounts
877     ) internal virtual {
878         require(from != address(0), "ERC1155: burn from the zero address");
879         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
880 
881         address operator = _msgSender();
882 
883         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
884 
885         for (uint256 i = 0; i < ids.length; i++) {
886             uint256 id = ids[i];
887             uint256 amount = amounts[i];
888 
889             uint256 fromBalance = _balances[id][from];
890             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
891             unchecked {
892                 _balances[id][from] = fromBalance - amount;
893             }
894         }
895 
896         emit TransferBatch(operator, from, address(0), ids, amounts);
897 
898         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
899     }
900 
901     /**
902      * @dev Approve `operator` to operate on all of `owner` tokens
903      *
904      * Emits an {ApprovalForAll} event.
905      */
906     function _setApprovalForAll(
907         address owner,
908         address operator,
909         bool approved
910     ) internal virtual {
911         require(owner != operator, "ERC1155: setting approval status for self");
912         _operatorApprovals[owner][operator] = approved;
913         emit ApprovalForAll(owner, operator, approved);
914     }
915 
916     /**
917      * @dev Hook that is called before any token transfer. This includes minting
918      * and burning, as well as batched variants.
919      *
920      * The same hook is called on both single and batched variants. For single
921      * transfers, the length of the `ids` and `amounts` arrays will be 1.
922      *
923      * Calling conditions (for each `id` and `amount` pair):
924      *
925      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
926      * of token type `id` will be  transferred to `to`.
927      * - When `from` is zero, `amount` tokens of token type `id` will be minted
928      * for `to`.
929      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
930      * will be burned.
931      * - `from` and `to` are never both zero.
932      * - `ids` and `amounts` have the same, non-zero length.
933      *
934      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
935      */
936     function _beforeTokenTransfer(
937         address operator,
938         address from,
939         address to,
940         uint256[] memory ids,
941         uint256[] memory amounts,
942         bytes memory data
943     ) internal virtual {}
944 
945     /**
946      * @dev Hook that is called after any token transfer. This includes minting
947      * and burning, as well as batched variants.
948      *
949      * The same hook is called on both single and batched variants. For single
950      * transfers, the length of the `id` and `amount` arrays will be 1.
951      *
952      * Calling conditions (for each `id` and `amount` pair):
953      *
954      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
955      * of token type `id` will be  transferred to `to`.
956      * - When `from` is zero, `amount` tokens of token type `id` will be minted
957      * for `to`.
958      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
959      * will be burned.
960      * - `from` and `to` are never both zero.
961      * - `ids` and `amounts` have the same, non-zero length.
962      *
963      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
964      */
965     function _afterTokenTransfer(
966         address operator,
967         address from,
968         address to,
969         uint256[] memory ids,
970         uint256[] memory amounts,
971         bytes memory data
972     ) internal virtual {}
973 
974     function _doSafeTransferAcceptanceCheck(
975         address operator,
976         address from,
977         address to,
978         uint256 id,
979         uint256 amount,
980         bytes memory data
981     ) private {
982         if (to.isContract()) {
983             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
984                 if (response != IERC1155Receiver.onERC1155Received.selector) {
985                     revert("ERC1155: ERC1155Receiver rejected tokens");
986                 }
987             } catch Error(string memory reason) {
988                 revert(reason);
989             } catch {
990                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
991             }
992         }
993     }
994 
995     function _doSafeBatchTransferAcceptanceCheck(
996         address operator,
997         address from,
998         address to,
999         uint256[] memory ids,
1000         uint256[] memory amounts,
1001         bytes memory data
1002     ) private {
1003         if (to.isContract()) {
1004             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1005                 bytes4 response
1006             ) {
1007                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1008                     revert("ERC1155: ERC1155Receiver rejected tokens");
1009                 }
1010             } catch Error(string memory reason) {
1011                 revert(reason);
1012             } catch {
1013                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1014             }
1015         }
1016     }
1017 
1018     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1019         uint256[] memory array = new uint256[](1);
1020         array[0] = element;
1021 
1022         return array;
1023     }
1024 }
1025 
1026 pragma solidity ^0.8.0;
1027 
1028 /**
1029  * @dev Standard math utilities missing in the Solidity language.
1030  */
1031 library Math {
1032     enum Rounding {
1033         Down, // Toward negative infinity
1034         Up, // Toward infinity
1035         Zero // Toward zero
1036     }
1037 
1038     /**
1039      * @dev Returns the largest of two numbers.
1040      */
1041     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1042         return a > b ? a : b;
1043     }
1044 
1045     /**
1046      * @dev Returns the smallest of two numbers.
1047      */
1048     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1049         return a < b ? a : b;
1050     }
1051 
1052     /**
1053      * @dev Returns the average of two numbers. The result is rounded towards
1054      * zero.
1055      */
1056     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1057         // (a + b) / 2 can overflow.
1058         return (a & b) + (a ^ b) / 2;
1059     }
1060 
1061     /**
1062      * @dev Returns the ceiling of the division of two numbers.
1063      *
1064      * This differs from standard division with `/` in that it rounds up instead
1065      * of rounding down.
1066      */
1067     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1068         // (a + b - 1) / b can overflow on addition, so we distribute.
1069         return a == 0 ? 0 : (a - 1) / b + 1;
1070     }
1071 
1072     /**
1073      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1074      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1075      * with further edits by Uniswap Labs also under MIT license.
1076      */
1077     function mulDiv(
1078         uint256 x,
1079         uint256 y,
1080         uint256 denominator
1081     ) internal pure returns (uint256 result) {
1082         unchecked {
1083             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1084             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1085             // variables such that product = prod1 * 2^256 + prod0.
1086             uint256 prod0; // Least significant 256 bits of the product
1087             uint256 prod1; // Most significant 256 bits of the product
1088             assembly {
1089                 let mm := mulmod(x, y, not(0))
1090                 prod0 := mul(x, y)
1091                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1092             }
1093 
1094             // Handle non-overflow cases, 256 by 256 division.
1095             if (prod1 == 0) {
1096                 return prod0 / denominator;
1097             }
1098 
1099             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1100             require(denominator > prod1);
1101 
1102             ///////////////////////////////////////////////
1103             // 512 by 256 division.
1104             ///////////////////////////////////////////////
1105 
1106             // Make division exact by subtracting the remainder from [prod1 prod0].
1107             uint256 remainder;
1108             assembly {
1109                 // Compute remainder using mulmod.
1110                 remainder := mulmod(x, y, denominator)
1111 
1112                 // Subtract 256 bit number from 512 bit number.
1113                 prod1 := sub(prod1, gt(remainder, prod0))
1114                 prod0 := sub(prod0, remainder)
1115             }
1116 
1117             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1118             // See https://cs.stackexchange.com/q/138556/92363.
1119 
1120             // Does not overflow because the denominator cannot be zero at this stage in the function.
1121             uint256 twos = denominator & (~denominator + 1);
1122             assembly {
1123                 // Divide denominator by twos.
1124                 denominator := div(denominator, twos)
1125 
1126                 // Divide [prod1 prod0] by twos.
1127                 prod0 := div(prod0, twos)
1128 
1129                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1130                 twos := add(div(sub(0, twos), twos), 1)
1131             }
1132 
1133             // Shift in bits from prod1 into prod0.
1134             prod0 |= prod1 * twos;
1135 
1136             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1137             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1138             // four bits. That is, denominator * inv = 1 mod 2^4.
1139             uint256 inverse = (3 * denominator) ^ 2;
1140 
1141             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1142             // in modular arithmetic, doubling the correct bits in each step.
1143             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1144             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1145             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1146             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1147             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1148             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1149 
1150             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1151             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1152             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1153             // is no longer required.
1154             result = prod0 * inverse;
1155             return result;
1156         }
1157     }
1158 
1159     /**
1160      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1161      */
1162     function mulDiv(
1163         uint256 x,
1164         uint256 y,
1165         uint256 denominator,
1166         Rounding rounding
1167     ) internal pure returns (uint256) {
1168         uint256 result = mulDiv(x, y, denominator);
1169         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1170             result += 1;
1171         }
1172         return result;
1173     }
1174 
1175     /**
1176      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1177      *
1178      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1179      */
1180     function sqrt(uint256 a) internal pure returns (uint256) {
1181         if (a == 0) {
1182             return 0;
1183         }
1184 
1185         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1186         //
1187         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1188         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1189         //
1190         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1191         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1192         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1193         //
1194         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1195         uint256 result = 1 << (log2(a) >> 1);
1196 
1197         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1198         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1199         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1200         // into the expected uint128 result.
1201         unchecked {
1202             result = (result + a / result) >> 1;
1203             result = (result + a / result) >> 1;
1204             result = (result + a / result) >> 1;
1205             result = (result + a / result) >> 1;
1206             result = (result + a / result) >> 1;
1207             result = (result + a / result) >> 1;
1208             result = (result + a / result) >> 1;
1209             return min(result, a / result);
1210         }
1211     }
1212 
1213     /**
1214      * @notice Calculates sqrt(a), following the selected rounding direction.
1215      */
1216     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1217         unchecked {
1218             uint256 result = sqrt(a);
1219             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1220         }
1221     }
1222 
1223     /**
1224      * @dev Return the log in base 2, rounded down, of a positive value.
1225      * Returns 0 if given 0.
1226      */
1227     function log2(uint256 value) internal pure returns (uint256) {
1228         uint256 result = 0;
1229         unchecked {
1230             if (value >> 128 > 0) {
1231                 value >>= 128;
1232                 result += 128;
1233             }
1234             if (value >> 64 > 0) {
1235                 value >>= 64;
1236                 result += 64;
1237             }
1238             if (value >> 32 > 0) {
1239                 value >>= 32;
1240                 result += 32;
1241             }
1242             if (value >> 16 > 0) {
1243                 value >>= 16;
1244                 result += 16;
1245             }
1246             if (value >> 8 > 0) {
1247                 value >>= 8;
1248                 result += 8;
1249             }
1250             if (value >> 4 > 0) {
1251                 value >>= 4;
1252                 result += 4;
1253             }
1254             if (value >> 2 > 0) {
1255                 value >>= 2;
1256                 result += 2;
1257             }
1258             if (value >> 1 > 0) {
1259                 result += 1;
1260             }
1261         }
1262         return result;
1263     }
1264 
1265     /**
1266      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1267      * Returns 0 if given 0.
1268      */
1269     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1270         unchecked {
1271             uint256 result = log2(value);
1272             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1273         }
1274     }
1275 
1276     /**
1277      * @dev Return the log in base 10, rounded down, of a positive value.
1278      * Returns 0 if given 0.
1279      */
1280     function log10(uint256 value) internal pure returns (uint256) {
1281         uint256 result = 0;
1282         unchecked {
1283             if (value >= 10**64) {
1284                 value /= 10**64;
1285                 result += 64;
1286             }
1287             if (value >= 10**32) {
1288                 value /= 10**32;
1289                 result += 32;
1290             }
1291             if (value >= 10**16) {
1292                 value /= 10**16;
1293                 result += 16;
1294             }
1295             if (value >= 10**8) {
1296                 value /= 10**8;
1297                 result += 8;
1298             }
1299             if (value >= 10**4) {
1300                 value /= 10**4;
1301                 result += 4;
1302             }
1303             if (value >= 10**2) {
1304                 value /= 10**2;
1305                 result += 2;
1306             }
1307             if (value >= 10**1) {
1308                 result += 1;
1309             }
1310         }
1311         return result;
1312     }
1313 
1314     /**
1315      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1316      * Returns 0 if given 0.
1317      */
1318     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1319         unchecked {
1320             uint256 result = log10(value);
1321             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1322         }
1323     }
1324 
1325     /**
1326      * @dev Return the log in base 256, rounded down, of a positive value.
1327      * Returns 0 if given 0.
1328      *
1329      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1330      */
1331     function log256(uint256 value) internal pure returns (uint256) {
1332         uint256 result = 0;
1333         unchecked {
1334             if (value >> 128 > 0) {
1335                 value >>= 128;
1336                 result += 16;
1337             }
1338             if (value >> 64 > 0) {
1339                 value >>= 64;
1340                 result += 8;
1341             }
1342             if (value >> 32 > 0) {
1343                 value >>= 32;
1344                 result += 4;
1345             }
1346             if (value >> 16 > 0) {
1347                 value >>= 16;
1348                 result += 2;
1349             }
1350             if (value >> 8 > 0) {
1351                 result += 1;
1352             }
1353         }
1354         return result;
1355     }
1356 
1357     /**
1358      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1359      * Returns 0 if given 0.
1360      */
1361     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1362         unchecked {
1363             uint256 result = log256(value);
1364             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1365         }
1366     }
1367 }
1368 
1369 pragma solidity ^0.8.0;
1370 
1371 
1372 /**
1373  * @dev String operations.
1374  */
1375 library Strings {
1376     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1377     uint8 private constant _ADDRESS_LENGTH = 20;
1378 
1379     /**
1380      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1381      */
1382     function toString(uint256 value) internal pure returns (string memory) {
1383         unchecked {
1384             uint256 length = Math.log10(value) + 1;
1385             string memory buffer = new string(length);
1386             uint256 ptr;
1387             /// @solidity memory-safe-assembly
1388             assembly {
1389                 ptr := add(buffer, add(32, length))
1390             }
1391             while (true) {
1392                 ptr--;
1393                 /// @solidity memory-safe-assembly
1394                 assembly {
1395                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1396                 }
1397                 value /= 10;
1398                 if (value == 0) break;
1399             }
1400             return buffer;
1401         }
1402     }
1403 
1404     /**
1405      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1406      */
1407     function toHexString(uint256 value) internal pure returns (string memory) {
1408         unchecked {
1409             return toHexString(value, Math.log256(value) + 1);
1410         }
1411     }
1412 
1413     /**
1414      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1415      */
1416     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1417         bytes memory buffer = new bytes(2 * length + 2);
1418         buffer[0] = "0";
1419         buffer[1] = "x";
1420         for (uint256 i = 2 * length + 1; i > 1; --i) {
1421             buffer[i] = _SYMBOLS[value & 0xf];
1422             value >>= 4;
1423         }
1424         require(value == 0, "Strings: hex length insufficient");
1425         return string(buffer);
1426     }
1427 
1428     /**
1429      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1430      */
1431     function toHexString(address addr) internal pure returns (string memory) {
1432         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1433     }
1434 }
1435 
1436 pragma solidity ^0.8.0;
1437 
1438 /**
1439  * @dev ERC1155 token with storage based token URI management.
1440  * Inspired by the ERC721URIStorage extension
1441  *
1442  * _Available since v4.6._
1443  */
1444 abstract contract ERC1155URIStorage is ERC1155 {
1445     using Strings for uint256;
1446 
1447     // Optional base URI
1448     string private _baseURI = "";
1449 
1450     // Optional mapping for token URIs
1451     mapping(uint256 => string) private _tokenURIs;
1452 
1453     /**
1454      * @dev See {IERC1155MetadataURI-uri}.
1455      *
1456      * This implementation returns the concatenation of the `_baseURI`
1457      * and the token-specific uri if the latter is set
1458      *
1459      * This enables the following behaviors:
1460      *
1461      * - if `_tokenURIs[tokenId]` is set, then the result is the concatenation
1462      *   of `_baseURI` and `_tokenURIs[tokenId]` (keep in mind that `_baseURI`
1463      *   is empty per default);
1464      *
1465      * - if `_tokenURIs[tokenId]` is NOT set then we fallback to `super.uri()`
1466      *   which in most cases will contain `ERC1155._uri`;
1467      *
1468      * - if `_tokenURIs[tokenId]` is NOT set, and if the parents do not have a
1469      *   uri value set, then the result is empty.
1470      */
1471     function uri(uint256 tokenId) public view virtual override returns (string memory) {
1472         string memory tokenURI = _tokenURIs[tokenId];
1473 
1474         // If token URI is set, concatenate base URI and tokenURI (via abi.encodePacked).
1475         return bytes(tokenURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenURI)) : super.uri(tokenId);
1476     }
1477 
1478     /**
1479      * @dev Sets `tokenURI` as the tokenURI of `tokenId`.
1480      */
1481     function _setURI(uint256 tokenId, string memory tokenURI) internal virtual {
1482         _tokenURIs[tokenId] = tokenURI;
1483         emit URI(uri(tokenId), tokenId);
1484     }
1485 
1486     /**
1487      * @dev Sets `baseURI` as the `_baseURI` for all tokens
1488      */
1489     function _setBaseURI(string memory baseURI) internal virtual {
1490         _baseURI = baseURI;
1491     }
1492 }
1493 
1494 abstract contract Ownable {
1495     address public owner; 
1496     constructor() { owner = msg.sender; }
1497     modifier onlyOwner { require(owner == msg.sender, "Not Owner"); _; }
1498     function transferOwnership(address new_) external onlyOwner { owner = new_; }
1499 }
1500 
1501 abstract contract MintToken is Ownable {
1502     mapping(address => bool) public minters;
1503     modifier onlyMinter { require(minters[msg.sender], "Not Minter"); _; }
1504     function setMinter(address address_, bool bool_) external onlyOwner {
1505         minters[address_] = bool_;
1506     }
1507 }
1508 
1509 interface IOperatorFilterRegistry {
1510     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1511     function register(address registrant) external;
1512     function registerAndSubscribe(address registrant, address subscription) external;
1513     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1514     function unregister(address addr) external;
1515     function updateOperator(address registrant, address operator, bool filtered) external;
1516     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1517     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1518     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1519     function subscribe(address registrant, address registrantToSubscribe) external;
1520     function unsubscribe(address registrant, bool copyExistingEntries) external;
1521     function subscriptionOf(address addr) external returns (address registrant);
1522     function subscribers(address registrant) external returns (address[] memory);
1523     function subscriberAt(address registrant, uint256 index) external returns (address);
1524     function copyEntriesOf(address registrant, address registrantToCopy) external;
1525     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1526     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1527     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1528     function filteredOperators(address addr) external returns (address[] memory);
1529     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1530     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1531     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1532     function isRegistered(address addr) external returns (bool);
1533     function codeHashOf(address addr) external returns (bytes32);
1534 }
1535 
1536 abstract contract OperatorFilterer {
1537     error OperatorNotAllowed(address operator);
1538 
1539     IOperatorFilterRegistry constant operatorFilterRegistry =
1540         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1541 
1542     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1543         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1544         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1545         // order for the modifier to filter addresses.
1546         if (address(operatorFilterRegistry).code.length > 0) {
1547             if (subscribe) {
1548                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1549             } else {
1550                 if (subscriptionOrRegistrantToCopy != address(0)) {
1551                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1552                 } else {
1553                     operatorFilterRegistry.register(address(this));
1554                 }
1555             }
1556         }
1557     }
1558 
1559     modifier onlyAllowedOperator(address from) virtual {
1560         // Check registry code length to facilitate testing in environments without a deployed registry.
1561         if (address(operatorFilterRegistry).code.length > 0) {
1562             // Allow spending tokens from addresses with balance
1563             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1564             // from an EOA.
1565             if (from == msg.sender) {
1566                 _;
1567                 return;
1568             }
1569             if (
1570                 !(
1571                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1572                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1573                 )
1574             ) {
1575                 revert OperatorNotAllowed(msg.sender);
1576             }
1577         }
1578         _;
1579     }
1580 }
1581 
1582 /// @title Neo Tokyo Punks Collabs
1583 /// @author sumotechnologies
1584 
1585 contract NeoTokyoPunksCollabs is ERC1155URIStorage, Ownable, MintToken, OperatorFilterer {
1586     
1587     string private _baseURI = "";
1588     mapping(uint256 => string) private _tokenURIs;
1589 
1590     constructor() ERC1155("") OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), true) {}
1591 
1592     function mint(address to, uint256 id, uint256 amount, bytes memory data) public onlyOwner {
1593         _mint(to, id, amount, data);
1594     }
1595 
1596     function mintMany(address[] calldata addrs, uint256 id, uint256 amount, bytes memory data) external onlyOwner {
1597         uint256 l = addrs.length;
1598         uint256 i; unchecked { do {
1599             _mint(addrs[i], id, amount, data);
1600         } while (++i < l); }
1601     }
1602 
1603     function mintToken(address to, uint256 id, uint256 amount, bytes memory data) external onlyMinter {
1604         _mint(to, id, amount, data);
1605     }
1606 
1607     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1608         _setBaseURI(_newBaseURI);
1609     }
1610 
1611     function setEachURI(uint256 _id, string memory _newURI) public onlyOwner {
1612         _setURI(_id, _newURI);
1613     }
1614 
1615     function uri(uint256 tokenId) public view override returns (string memory) {
1616         string memory tokenURI = _tokenURIs[tokenId];
1617         return bytes(tokenURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenURI)) : super.uri(tokenId);
1618     }
1619 
1620     function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount, bytes memory data)
1621         public
1622         override
1623         onlyAllowedOperator(from)
1624     {
1625         super.safeTransferFrom(from, to, tokenId, amount, data);
1626     }
1627 
1628     function safeBatchTransferFrom(
1629         address from,
1630         address to,
1631         uint256[] memory ids,
1632         uint256[] memory amounts,
1633         bytes memory data
1634     ) public virtual override onlyAllowedOperator(from) {
1635         super.safeBatchTransferFrom(from, to, ids, amounts, data);
1636     }
1637 }