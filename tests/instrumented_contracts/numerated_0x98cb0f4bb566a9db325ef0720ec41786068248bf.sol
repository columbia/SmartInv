1 // Sources flattened with hardhat v2.6.5 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.3.2
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Required interface of an ERC1155 compliant contract, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
38  *
39  * _Available since v3.1._
40  */
41 interface IERC1155 is IERC165 {
42     /**
43      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
44      */
45     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
46 
47     /**
48      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
49      * transfers.
50      */
51     event TransferBatch(
52         address indexed operator,
53         address indexed from,
54         address indexed to,
55         uint256[] ids,
56         uint256[] values
57     );
58 
59     /**
60      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
61      * `approved`.
62      */
63     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
64 
65     /**
66      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
67      *
68      * If an {URI} event was emitted for `id`, the standard
69      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
70      * returned by {IERC1155MetadataURI-uri}.
71      */
72     event URI(string value, uint256 indexed id);
73 
74     /**
75      * @dev Returns the amount of tokens of token type `id` owned by `account`.
76      *
77      * Requirements:
78      *
79      * - `account` cannot be the zero address.
80      */
81     function balanceOf(address account, uint256 id) external view returns (uint256);
82 
83     /**
84      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
85      *
86      * Requirements:
87      *
88      * - `accounts` and `ids` must have the same length.
89      */
90     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
91         external
92         view
93         returns (uint256[] memory);
94 
95     /**
96      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
97      *
98      * Emits an {ApprovalForAll} event.
99      *
100      * Requirements:
101      *
102      * - `operator` cannot be the caller.
103      */
104     function setApprovalForAll(address operator, bool approved) external;
105 
106     /**
107      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
108      *
109      * See {setApprovalForAll}.
110      */
111     function isApprovedForAll(address account, address operator) external view returns (bool);
112 
113     /**
114      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
115      *
116      * Emits a {TransferSingle} event.
117      *
118      * Requirements:
119      *
120      * - `to` cannot be the zero address.
121      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
122      * - `from` must have a balance of tokens of type `id` of at least `amount`.
123      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
124      * acceptance magic value.
125      */
126     function safeTransferFrom(
127         address from,
128         address to,
129         uint256 id,
130         uint256 amount,
131         bytes calldata data
132     ) external;
133 
134     /**
135      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
136      *
137      * Emits a {TransferBatch} event.
138      *
139      * Requirements:
140      *
141      * - `ids` and `amounts` must have the same length.
142      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
143      * acceptance magic value.
144      */
145     function safeBatchTransferFrom(
146         address from,
147         address to,
148         uint256[] calldata ids,
149         uint256[] calldata amounts,
150         bytes calldata data
151     ) external;
152 }
153 
154 
155 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.3.2
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev _Available since v3.1._
161  */
162 interface IERC1155Receiver is IERC165 {
163     /**
164         @dev Handles the receipt of a single ERC1155 token type. This function is
165         called at the end of a `safeTransferFrom` after the balance has been updated.
166         To accept the transfer, this must return
167         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
168         (i.e. 0xf23a6e61, or its own function selector).
169         @param operator The address which initiated the transfer (i.e. msg.sender)
170         @param from The address which previously owned the token
171         @param id The ID of the token being transferred
172         @param value The amount of tokens being transferred
173         @param data Additional data with no specified format
174         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
175     */
176     function onERC1155Received(
177         address operator,
178         address from,
179         uint256 id,
180         uint256 value,
181         bytes calldata data
182     ) external returns (bytes4);
183 
184     /**
185         @dev Handles the receipt of a multiple ERC1155 token types. This function
186         is called at the end of a `safeBatchTransferFrom` after the balances have
187         been updated. To accept the transfer(s), this must return
188         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
189         (i.e. 0xbc197c81, or its own function selector).
190         @param operator The address which initiated the batch transfer (i.e. msg.sender)
191         @param from The address which previously owned the token
192         @param ids An array containing ids of each token being transferred (order and length must match values array)
193         @param values An array containing amounts of each token being transferred (order and length must match ids array)
194         @param data Additional data with no specified format
195         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
196     */
197     function onERC1155BatchReceived(
198         address operator,
199         address from,
200         uint256[] calldata ids,
201         uint256[] calldata values,
202         bytes calldata data
203     ) external returns (bytes4);
204 }
205 
206 
207 // File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.3.2
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
213  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
214  *
215  * _Available since v3.1._
216  */
217 interface IERC1155MetadataURI is IERC1155 {
218     /**
219      * @dev Returns the URI for token type `id`.
220      *
221      * If the `\{id\}` substring is present in the URI, it must be replaced by
222      * clients with the actual token type ID.
223      */
224     function uri(uint256 id) external view returns (string memory);
225 }
226 
227 
228 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev Collection of functions related to the address type
234  */
235 library Address {
236     /**
237      * @dev Returns true if `account` is a contract.
238      *
239      * [IMPORTANT]
240      * ====
241      * It is unsafe to assume that an address for which this function returns
242      * false is an externally-owned account (EOA) and not a contract.
243      *
244      * Among others, `isContract` will return false for the following
245      * types of addresses:
246      *
247      *  - an externally-owned account
248      *  - a contract in construction
249      *  - an address where a contract will be created
250      *  - an address where a contract lived, but was destroyed
251      * ====
252      */
253     function isContract(address account) internal view returns (bool) {
254         // This method relies on extcodesize, which returns 0 for contracts in
255         // construction, since the code is only stored at the end of the
256         // constructor execution.
257 
258         uint256 size;
259         assembly {
260             size := extcodesize(account)
261         }
262         return size > 0;
263     }
264 
265     /**
266      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267      * `recipient`, forwarding all available gas and reverting on errors.
268      *
269      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270      * of certain opcodes, possibly making contracts go over the 2300 gas limit
271      * imposed by `transfer`, making them unable to receive funds via
272      * `transfer`. {sendValue} removes this limitation.
273      *
274      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275      *
276      * IMPORTANT: because control is transferred to `recipient`, care must be
277      * taken to not create reentrancy vulnerabilities. Consider using
278      * {ReentrancyGuard} or the
279      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280      */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, "Address: insufficient balance");
283 
284         (bool success, ) = recipient.call{value: amount}("");
285         require(success, "Address: unable to send value, recipient may have reverted");
286     }
287 
288     /**
289      * @dev Performs a Solidity function call using a low level `call`. A
290      * plain `call` is an unsafe replacement for a function call: use this
291      * function instead.
292      *
293      * If `target` reverts with a revert reason, it is bubbled up by this
294      * function (like regular Solidity function calls).
295      *
296      * Returns the raw returned data. To convert to the expected return value,
297      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
298      *
299      * Requirements:
300      *
301      * - `target` must be a contract.
302      * - calling `target` with `data` must not revert.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionCall(target, data, "Address: low-level call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
312      * `errorMessage` as a fallback revert reason when `target` reverts.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but also transferring `value` wei to `target`.
327      *
328      * Requirements:
329      *
330      * - the calling contract must have an ETH balance of at least `value`.
331      * - the called Solidity function must be `payable`.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(
336         address target,
337         bytes memory data,
338         uint256 value
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         require(isContract(target), "Address: call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.call{value: value}(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
369         return functionStaticCall(target, data, "Address: low-level static call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal view returns (bytes memory) {
383         require(isContract(target), "Address: static call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.staticcall(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.4._
394      */
395     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
396         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
401      * but performing a delegate call.
402      *
403      * _Available since v3.4._
404      */
405     function functionDelegateCall(
406         address target,
407         bytes memory data,
408         string memory errorMessage
409     ) internal returns (bytes memory) {
410         require(isContract(target), "Address: delegate call to non-contract");
411 
412         (bool success, bytes memory returndata) = target.delegatecall(data);
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
418      * revert reason using the provided one.
419      *
420      * _Available since v4.3._
421      */
422     function verifyCallResult(
423         bool success,
424         bytes memory returndata,
425         string memory errorMessage
426     ) internal pure returns (bytes memory) {
427         if (success) {
428             return returndata;
429         } else {
430             // Look for revert reason and bubble it up if present
431             if (returndata.length > 0) {
432                 // The easiest way to bubble the revert reason is using memory via assembly
433 
434                 assembly {
435                     let returndata_size := mload(returndata)
436                     revert(add(32, returndata), returndata_size)
437                 }
438             } else {
439                 revert(errorMessage);
440             }
441         }
442     }
443 }
444 
445 
446 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev Provides information about the current execution context, including the
452  * sender of the transaction and its data. While these are generally available
453  * via msg.sender and msg.data, they should not be accessed in such a direct
454  * manner, since when dealing with meta-transactions the account sending and
455  * paying for execution may not be the actual sender (as far as an application
456  * is concerned).
457  *
458  * This contract is only required for intermediate, library-like contracts.
459  */
460 abstract contract Context {
461     function _msgSender() internal view virtual returns (address) {
462         return msg.sender;
463     }
464 
465     function _msgData() internal view virtual returns (bytes calldata) {
466         return msg.data;
467     }
468 }
469 
470 
471 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @dev Implementation of the {IERC165} interface.
477  *
478  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
479  * for the additional interface id that will be supported. For example:
480  *
481  * ```solidity
482  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
484  * }
485  * ```
486  *
487  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
488  */
489 abstract contract ERC165 is IERC165 {
490     /**
491      * @dev See {IERC165-supportsInterface}.
492      */
493     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
494         return interfaceId == type(IERC165).interfaceId;
495     }
496 }
497 
498 
499 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.3.2
500 
501 pragma solidity ^0.8.0;
502 
503 
504 
505 
506 
507 
508 /**
509  * @dev Implementation of the basic standard multi-token.
510  * See https://eips.ethereum.org/EIPS/eip-1155
511  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
512  *
513  * _Available since v3.1._
514  */
515 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
516     using Address for address;
517 
518     // Mapping from token ID to account balances
519     mapping(uint256 => mapping(address => uint256)) private _balances;
520 
521     // Mapping from account to operator approvals
522     mapping(address => mapping(address => bool)) private _operatorApprovals;
523 
524     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
525     string private _uri;
526 
527     /**
528      * @dev See {_setURI}.
529      */
530     constructor(string memory uri_) {
531         _setURI(uri_);
532     }
533 
534     /**
535      * @dev See {IERC165-supportsInterface}.
536      */
537     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
538         return
539             interfaceId == type(IERC1155).interfaceId ||
540             interfaceId == type(IERC1155MetadataURI).interfaceId ||
541             super.supportsInterface(interfaceId);
542     }
543 
544     /**
545      * @dev See {IERC1155MetadataURI-uri}.
546      *
547      * This implementation returns the same URI for *all* token types. It relies
548      * on the token type ID substitution mechanism
549      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
550      *
551      * Clients calling this function must replace the `\{id\}` substring with the
552      * actual token type ID.
553      */
554     function uri(uint256) public view virtual override returns (string memory) {
555         return _uri;
556     }
557 
558     /**
559      * @dev See {IERC1155-balanceOf}.
560      *
561      * Requirements:
562      *
563      * - `account` cannot be the zero address.
564      */
565     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
566         require(account != address(0), "ERC1155: balance query for the zero address");
567         return _balances[id][account];
568     }
569 
570     /**
571      * @dev See {IERC1155-balanceOfBatch}.
572      *
573      * Requirements:
574      *
575      * - `accounts` and `ids` must have the same length.
576      */
577     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
578         public
579         view
580         virtual
581         override
582         returns (uint256[] memory)
583     {
584         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
585 
586         uint256[] memory batchBalances = new uint256[](accounts.length);
587 
588         for (uint256 i = 0; i < accounts.length; ++i) {
589             batchBalances[i] = balanceOf(accounts[i], ids[i]);
590         }
591 
592         return batchBalances;
593     }
594 
595     /**
596      * @dev See {IERC1155-setApprovalForAll}.
597      */
598     function setApprovalForAll(address operator, bool approved) public virtual override {
599         require(_msgSender() != operator, "ERC1155: setting approval status for self");
600 
601         _operatorApprovals[_msgSender()][operator] = approved;
602         emit ApprovalForAll(_msgSender(), operator, approved);
603     }
604 
605     /**
606      * @dev See {IERC1155-isApprovedForAll}.
607      */
608     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
609         return _operatorApprovals[account][operator];
610     }
611 
612     /**
613      * @dev See {IERC1155-safeTransferFrom}.
614      */
615     function safeTransferFrom(
616         address from,
617         address to,
618         uint256 id,
619         uint256 amount,
620         bytes memory data
621     ) public virtual override {
622         require(
623             from == _msgSender() || isApprovedForAll(from, _msgSender()),
624             "ERC1155: caller is not owner nor approved"
625         );
626         _safeTransferFrom(from, to, id, amount, data);
627     }
628 
629     /**
630      * @dev See {IERC1155-safeBatchTransferFrom}.
631      */
632     function safeBatchTransferFrom(
633         address from,
634         address to,
635         uint256[] memory ids,
636         uint256[] memory amounts,
637         bytes memory data
638     ) public virtual override {
639         require(
640             from == _msgSender() || isApprovedForAll(from, _msgSender()),
641             "ERC1155: transfer caller is not owner nor approved"
642         );
643         _safeBatchTransferFrom(from, to, ids, amounts, data);
644     }
645 
646     /**
647      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
648      *
649      * Emits a {TransferSingle} event.
650      *
651      * Requirements:
652      *
653      * - `to` cannot be the zero address.
654      * - `from` must have a balance of tokens of type `id` of at least `amount`.
655      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
656      * acceptance magic value.
657      */
658     function _safeTransferFrom(
659         address from,
660         address to,
661         uint256 id,
662         uint256 amount,
663         bytes memory data
664     ) internal virtual {
665         require(to != address(0), "ERC1155: transfer to the zero address");
666 
667         address operator = _msgSender();
668 
669         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
670 
671         uint256 fromBalance = _balances[id][from];
672         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
673         unchecked {
674             _balances[id][from] = fromBalance - amount;
675         }
676         _balances[id][to] += amount;
677 
678         emit TransferSingle(operator, from, to, id, amount);
679 
680         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
681     }
682 
683     /**
684      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
685      *
686      * Emits a {TransferBatch} event.
687      *
688      * Requirements:
689      *
690      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
691      * acceptance magic value.
692      */
693     function _safeBatchTransferFrom(
694         address from,
695         address to,
696         uint256[] memory ids,
697         uint256[] memory amounts,
698         bytes memory data
699     ) internal virtual {
700         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
701         require(to != address(0), "ERC1155: transfer to the zero address");
702 
703         address operator = _msgSender();
704 
705         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
706 
707         for (uint256 i = 0; i < ids.length; ++i) {
708             uint256 id = ids[i];
709             uint256 amount = amounts[i];
710 
711             uint256 fromBalance = _balances[id][from];
712             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
713             unchecked {
714                 _balances[id][from] = fromBalance - amount;
715             }
716             _balances[id][to] += amount;
717         }
718 
719         emit TransferBatch(operator, from, to, ids, amounts);
720 
721         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
722     }
723 
724     /**
725      * @dev Sets a new URI for all token types, by relying on the token type ID
726      * substitution mechanism
727      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
728      *
729      * By this mechanism, any occurrence of the `\{id\}` substring in either the
730      * URI or any of the amounts in the JSON file at said URI will be replaced by
731      * clients with the token type ID.
732      *
733      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
734      * interpreted by clients as
735      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
736      * for token type ID 0x4cce0.
737      *
738      * See {uri}.
739      *
740      * Because these URIs cannot be meaningfully represented by the {URI} event,
741      * this function emits no events.
742      */
743     function _setURI(string memory newuri) internal virtual {
744         _uri = newuri;
745     }
746 
747     /**
748      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
749      *
750      * Emits a {TransferSingle} event.
751      *
752      * Requirements:
753      *
754      * - `account` cannot be the zero address.
755      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
756      * acceptance magic value.
757      */
758     function _mint(
759         address account,
760         uint256 id,
761         uint256 amount,
762         bytes memory data
763     ) internal virtual {
764         require(account != address(0), "ERC1155: mint to the zero address");
765 
766         address operator = _msgSender();
767 
768         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
769 
770         _balances[id][account] += amount;
771         emit TransferSingle(operator, address(0), account, id, amount);
772 
773         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
774     }
775 
776     /**
777      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
778      *
779      * Requirements:
780      *
781      * - `ids` and `amounts` must have the same length.
782      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
783      * acceptance magic value.
784      */
785     function _mintBatch(
786         address to,
787         uint256[] memory ids,
788         uint256[] memory amounts,
789         bytes memory data
790     ) internal virtual {
791         require(to != address(0), "ERC1155: mint to the zero address");
792         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
793 
794         address operator = _msgSender();
795 
796         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
797 
798         for (uint256 i = 0; i < ids.length; i++) {
799             _balances[ids[i]][to] += amounts[i];
800         }
801 
802         emit TransferBatch(operator, address(0), to, ids, amounts);
803 
804         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
805     }
806 
807     /**
808      * @dev Destroys `amount` tokens of token type `id` from `account`
809      *
810      * Requirements:
811      *
812      * - `account` cannot be the zero address.
813      * - `account` must have at least `amount` tokens of token type `id`.
814      */
815     function _burn(
816         address account,
817         uint256 id,
818         uint256 amount
819     ) internal virtual {
820         require(account != address(0), "ERC1155: burn from the zero address");
821 
822         address operator = _msgSender();
823 
824         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
825 
826         uint256 accountBalance = _balances[id][account];
827         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
828         unchecked {
829             _balances[id][account] = accountBalance - amount;
830         }
831 
832         emit TransferSingle(operator, account, address(0), id, amount);
833     }
834 
835     /**
836      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
837      *
838      * Requirements:
839      *
840      * - `ids` and `amounts` must have the same length.
841      */
842     function _burnBatch(
843         address account,
844         uint256[] memory ids,
845         uint256[] memory amounts
846     ) internal virtual {
847         require(account != address(0), "ERC1155: burn from the zero address");
848         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
849 
850         address operator = _msgSender();
851 
852         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
853 
854         for (uint256 i = 0; i < ids.length; i++) {
855             uint256 id = ids[i];
856             uint256 amount = amounts[i];
857 
858             uint256 accountBalance = _balances[id][account];
859             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
860             unchecked {
861                 _balances[id][account] = accountBalance - amount;
862             }
863         }
864 
865         emit TransferBatch(operator, account, address(0), ids, amounts);
866     }
867 
868     /**
869      * @dev Hook that is called before any token transfer. This includes minting
870      * and burning, as well as batched variants.
871      *
872      * The same hook is called on both single and batched variants. For single
873      * transfers, the length of the `id` and `amount` arrays will be 1.
874      *
875      * Calling conditions (for each `id` and `amount` pair):
876      *
877      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
878      * of token type `id` will be  transferred to `to`.
879      * - When `from` is zero, `amount` tokens of token type `id` will be minted
880      * for `to`.
881      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
882      * will be burned.
883      * - `from` and `to` are never both zero.
884      * - `ids` and `amounts` have the same, non-zero length.
885      *
886      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
887      */
888     function _beforeTokenTransfer(
889         address operator,
890         address from,
891         address to,
892         uint256[] memory ids,
893         uint256[] memory amounts,
894         bytes memory data
895     ) internal virtual {}
896 
897     function _doSafeTransferAcceptanceCheck(
898         address operator,
899         address from,
900         address to,
901         uint256 id,
902         uint256 amount,
903         bytes memory data
904     ) private {
905         if (to.isContract()) {
906             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
907                 if (response != IERC1155Receiver.onERC1155Received.selector) {
908                     revert("ERC1155: ERC1155Receiver rejected tokens");
909                 }
910             } catch Error(string memory reason) {
911                 revert(reason);
912             } catch {
913                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
914             }
915         }
916     }
917 
918     function _doSafeBatchTransferAcceptanceCheck(
919         address operator,
920         address from,
921         address to,
922         uint256[] memory ids,
923         uint256[] memory amounts,
924         bytes memory data
925     ) private {
926         if (to.isContract()) {
927             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
928                 bytes4 response
929             ) {
930                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
931                     revert("ERC1155: ERC1155Receiver rejected tokens");
932                 }
933             } catch Error(string memory reason) {
934                 revert(reason);
935             } catch {
936                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
937             }
938         }
939     }
940 
941     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
942         uint256[] memory array = new uint256[](1);
943         array[0] = element;
944 
945         return array;
946     }
947 }
948 
949 
950 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.3.2
951 
952 pragma solidity ^0.8.0;
953 
954 /**
955  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
956  *
957  * These functions can be used to verify that a message was signed by the holder
958  * of the private keys of a given address.
959  */
960 library ECDSA {
961     enum RecoverError {
962         NoError,
963         InvalidSignature,
964         InvalidSignatureLength,
965         InvalidSignatureS,
966         InvalidSignatureV
967     }
968 
969     function _throwError(RecoverError error) private pure {
970         if (error == RecoverError.NoError) {
971             return; // no error: do nothing
972         } else if (error == RecoverError.InvalidSignature) {
973             revert("ECDSA: invalid signature");
974         } else if (error == RecoverError.InvalidSignatureLength) {
975             revert("ECDSA: invalid signature length");
976         } else if (error == RecoverError.InvalidSignatureS) {
977             revert("ECDSA: invalid signature 's' value");
978         } else if (error == RecoverError.InvalidSignatureV) {
979             revert("ECDSA: invalid signature 'v' value");
980         }
981     }
982 
983     /**
984      * @dev Returns the address that signed a hashed message (`hash`) with
985      * `signature` or error string. This address can then be used for verification purposes.
986      *
987      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
988      * this function rejects them by requiring the `s` value to be in the lower
989      * half order, and the `v` value to be either 27 or 28.
990      *
991      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
992      * verification to be secure: it is possible to craft signatures that
993      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
994      * this is by receiving a hash of the original message (which may otherwise
995      * be too long), and then calling {toEthSignedMessageHash} on it.
996      *
997      * Documentation for signature generation:
998      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
999      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1000      *
1001      * _Available since v4.3._
1002      */
1003     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1004         // Check the signature length
1005         // - case 65: r,s,v signature (standard)
1006         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1007         if (signature.length == 65) {
1008             bytes32 r;
1009             bytes32 s;
1010             uint8 v;
1011             // ecrecover takes the signature parameters, and the only way to get them
1012             // currently is to use assembly.
1013             assembly {
1014                 r := mload(add(signature, 0x20))
1015                 s := mload(add(signature, 0x40))
1016                 v := byte(0, mload(add(signature, 0x60)))
1017             }
1018             return tryRecover(hash, v, r, s);
1019         } else if (signature.length == 64) {
1020             bytes32 r;
1021             bytes32 vs;
1022             // ecrecover takes the signature parameters, and the only way to get them
1023             // currently is to use assembly.
1024             assembly {
1025                 r := mload(add(signature, 0x20))
1026                 vs := mload(add(signature, 0x40))
1027             }
1028             return tryRecover(hash, r, vs);
1029         } else {
1030             return (address(0), RecoverError.InvalidSignatureLength);
1031         }
1032     }
1033 
1034     /**
1035      * @dev Returns the address that signed a hashed message (`hash`) with
1036      * `signature`. This address can then be used for verification purposes.
1037      *
1038      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1039      * this function rejects them by requiring the `s` value to be in the lower
1040      * half order, and the `v` value to be either 27 or 28.
1041      *
1042      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1043      * verification to be secure: it is possible to craft signatures that
1044      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1045      * this is by receiving a hash of the original message (which may otherwise
1046      * be too long), and then calling {toEthSignedMessageHash} on it.
1047      */
1048     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1049         (address recovered, RecoverError error) = tryRecover(hash, signature);
1050         _throwError(error);
1051         return recovered;
1052     }
1053 
1054     /**
1055      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1056      *
1057      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1058      *
1059      * _Available since v4.3._
1060      */
1061     function tryRecover(
1062         bytes32 hash,
1063         bytes32 r,
1064         bytes32 vs
1065     ) internal pure returns (address, RecoverError) {
1066         bytes32 s;
1067         uint8 v;
1068         assembly {
1069             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1070             v := add(shr(255, vs), 27)
1071         }
1072         return tryRecover(hash, v, r, s);
1073     }
1074 
1075     /**
1076      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1077      *
1078      * _Available since v4.2._
1079      */
1080     function recover(
1081         bytes32 hash,
1082         bytes32 r,
1083         bytes32 vs
1084     ) internal pure returns (address) {
1085         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1086         _throwError(error);
1087         return recovered;
1088     }
1089 
1090     /**
1091      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1092      * `r` and `s` signature fields separately.
1093      *
1094      * _Available since v4.3._
1095      */
1096     function tryRecover(
1097         bytes32 hash,
1098         uint8 v,
1099         bytes32 r,
1100         bytes32 s
1101     ) internal pure returns (address, RecoverError) {
1102         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1103         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1104         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1105         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1106         //
1107         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1108         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1109         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1110         // these malleable signatures as well.
1111         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1112             return (address(0), RecoverError.InvalidSignatureS);
1113         }
1114         if (v != 27 && v != 28) {
1115             return (address(0), RecoverError.InvalidSignatureV);
1116         }
1117 
1118         // If the signature is valid (and not malleable), return the signer address
1119         address signer = ecrecover(hash, v, r, s);
1120         if (signer == address(0)) {
1121             return (address(0), RecoverError.InvalidSignature);
1122         }
1123 
1124         return (signer, RecoverError.NoError);
1125     }
1126 
1127     /**
1128      * @dev Overload of {ECDSA-recover} that receives the `v`,
1129      * `r` and `s` signature fields separately.
1130      */
1131     function recover(
1132         bytes32 hash,
1133         uint8 v,
1134         bytes32 r,
1135         bytes32 s
1136     ) internal pure returns (address) {
1137         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1138         _throwError(error);
1139         return recovered;
1140     }
1141 
1142     /**
1143      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1144      * produces hash corresponding to the one signed with the
1145      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1146      * JSON-RPC method as part of EIP-191.
1147      *
1148      * See {recover}.
1149      */
1150     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1151         // 32 is the length in bytes of hash,
1152         // enforced by the type signature above
1153         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1154     }
1155 
1156     /**
1157      * @dev Returns an Ethereum Signed Typed Data, created from a
1158      * `domainSeparator` and a `structHash`. This produces hash corresponding
1159      * to the one signed with the
1160      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1161      * JSON-RPC method as part of EIP-712.
1162      *
1163      * See {recover}.
1164      */
1165     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1166         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1167     }
1168 }
1169 
1170 
1171 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 /**
1176  * @dev Contract module which provides a basic access control mechanism, where
1177  * there is an account (an owner) that can be granted exclusive access to
1178  * specific functions.
1179  *
1180  * By default, the owner account will be the one that deploys the contract. This
1181  * can later be changed with {transferOwnership}.
1182  *
1183  * This module is used through inheritance. It will make available the modifier
1184  * `onlyOwner`, which can be applied to your functions to restrict their use to
1185  * the owner.
1186  */
1187 abstract contract Ownable is Context {
1188     address private _owner;
1189 
1190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1191 
1192     /**
1193      * @dev Initializes the contract setting the deployer as the initial owner.
1194      */
1195     constructor() {
1196         _setOwner(_msgSender());
1197     }
1198 
1199     /**
1200      * @dev Returns the address of the current owner.
1201      */
1202     function owner() public view virtual returns (address) {
1203         return _owner;
1204     }
1205 
1206     /**
1207      * @dev Throws if called by any account other than the owner.
1208      */
1209     modifier onlyOwner() {
1210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1211         _;
1212     }
1213 
1214     /**
1215      * @dev Leaves the contract without owner. It will not be possible to call
1216      * `onlyOwner` functions anymore. Can only be called by the current owner.
1217      *
1218      * NOTE: Renouncing ownership will leave the contract without an owner,
1219      * thereby removing any functionality that is only available to the owner.
1220      */
1221     function renounceOwnership() public virtual onlyOwner {
1222         _setOwner(address(0));
1223     }
1224 
1225     /**
1226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1227      * Can only be called by the current owner.
1228      */
1229     function transferOwnership(address newOwner) public virtual onlyOwner {
1230         require(newOwner != address(0), "Ownable: new owner is the zero address");
1231         _setOwner(newOwner);
1232     }
1233 
1234     function _setOwner(address newOwner) private {
1235         address oldOwner = _owner;
1236         _owner = newOwner;
1237         emit OwnershipTransferred(oldOwner, newOwner);
1238     }
1239 }
1240 
1241 
1242 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.2
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 /**
1247  * @dev Contract module that helps prevent reentrant calls to a function.
1248  *
1249  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1250  * available, which can be applied to functions to make sure there are no nested
1251  * (reentrant) calls to them.
1252  *
1253  * Note that because there is a single `nonReentrant` guard, functions marked as
1254  * `nonReentrant` may not call one another. This can be worked around by making
1255  * those functions `private`, and then adding `external` `nonReentrant` entry
1256  * points to them.
1257  *
1258  * TIP: If you would like to learn more about reentrancy and alternative ways
1259  * to protect against it, check out our blog post
1260  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1261  */
1262 abstract contract ReentrancyGuard {
1263     // Booleans are more expensive than uint256 or any type that takes up a full
1264     // word because each write operation emits an extra SLOAD to first read the
1265     // slot's contents, replace the bits taken up by the boolean, and then write
1266     // back. This is the compiler's defense against contract upgrades and
1267     // pointer aliasing, and it cannot be disabled.
1268 
1269     // The values being non-zero value makes deployment a bit more expensive,
1270     // but in exchange the refund on every call to nonReentrant will be lower in
1271     // amount. Since refunds are capped to a percentage of the total
1272     // transaction's gas, it is best to keep them low in cases like this one, to
1273     // increase the likelihood of the full refund coming into effect.
1274     uint256 private constant _NOT_ENTERED = 1;
1275     uint256 private constant _ENTERED = 2;
1276 
1277     uint256 private _status;
1278 
1279     constructor() {
1280         _status = _NOT_ENTERED;
1281     }
1282 
1283     /**
1284      * @dev Prevents a contract from calling itself, directly or indirectly.
1285      * Calling a `nonReentrant` function from another `nonReentrant`
1286      * function is not supported. It is possible to prevent this from happening
1287      * by making the `nonReentrant` function external, and make it call a
1288      * `private` function that does the actual work.
1289      */
1290     modifier nonReentrant() {
1291         // On the first call to nonReentrant, _notEntered will be true
1292         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1293 
1294         // Any calls to nonReentrant after this point will fail
1295         _status = _ENTERED;
1296 
1297         _;
1298 
1299         // By storing the original value once again, a refund is triggered (see
1300         // https://eips.ethereum.org/EIPS/eip-2200)
1301         _status = _NOT_ENTERED;
1302     }
1303 }
1304 
1305 
1306 // File contracts/JKDao.sol
1307 
1308 /*
1309        __   __  ___  _______       ___       ______
1310       |  | |  |/  / |       \     /   \     /  __  \
1311       |  | |  '  /  |  .--.  |   /  ^  \   |  |  |  |
1312 .--.  |  | |    <   |  |  |  |  /  /_\  \  |  |  |  |
1313 |  `--'  | |  .  \  |  '--'  | /  _____  \ |  `--'  |
1314  \______/  |__|\__\ |_______/ /__/     \__\ \______/
1315 
1316 
1317 Join us https://discord.gg/796KVFSf
1318 */
1319 
1320 pragma solidity ^0.8.7;
1321 
1322 
1323 
1324 
1325 
1326 contract JKDao is ReentrancyGuard, ERC1155, Ownable {
1327     uint256 constant private _tokenId = 1;
1328     uint256 constant public oldJKSupply = 2278;
1329 
1330     address constant public oldJK = 0x137A81298c11708006405d75bC0541A2a07C0B33;
1331     uint256 public maxPerAddress = 15;
1332     uint256 public mintCount = 0;
1333     uint256 public bridgeCount = 0;
1334     uint256 public totalMinted = 0;
1335     uint256 public maxKeySupply = 7500;
1336     uint256 public mintPrice = 0.07 ether;
1337 
1338     bool public saleStarted = false;
1339     bool public presaleStarted = false;
1340 
1341     mapping(bytes32 => bool) private _usedHashes;
1342     address private _signerAddress;
1343 
1344     constructor() ERC1155("https://ipfs.io/ipfs/QmYbWYv48DWGh5mTGUDo9i5EtZySpTVPv4nJ72A2B5vSuK?filename=jk_metadata%20copy.json") {}
1345 
1346     function publicMint(uint256 _count) external payable nonReentrant {
1347         require(saleStarted, "Public sale not started");
1348         require(tx.origin == msg.sender, "Prevent contract call");
1349         require((balanceOf(msg.sender, _tokenId) + _count) <= maxPerAddress, "Max Per Address reached");
1350         require(_count > 0 && msg.value == _count * mintPrice, "invalid eth sent");
1351         require(mintCount + _count + oldJKSupply <= maxKeySupply, "max key cards");
1352         require(totalMinted + _count <= maxKeySupply, "max key cards");
1353 
1354         mintCount += _count;
1355         totalMinted += _count;
1356         _mint(msg.sender, _tokenId, _count, "");
1357     }
1358 
1359 
1360     // Preasale Mint Key Card
1361     function presaleMint(
1362         uint256 _count,
1363         bytes32 _hash,
1364         bytes memory _sig)
1365         external payable nonReentrant
1366     {
1367         require(presaleStarted, "Presale not started");
1368         require(tx.origin == msg.sender, "Prevent contract call");
1369         require((balanceOf(msg.sender, _tokenId) + _count) <= maxPerAddress, "Max Per Address reached");
1370         require(_count > 0 && msg.value == _count * mintPrice, "invalid eth sent");
1371         require(matchHash(msg.sender, _count, _hash), "invalid hash");
1372         require(matchSigner(_hash, _sig), "invalid signer");
1373         require(!_usedHashes[_hash], "_hash already used");
1374         require(mintCount + _count + oldJKSupply <= maxKeySupply, "max key cards");
1375         require(totalMinted + _count <= maxKeySupply, "max key cards");
1376 
1377         _usedHashes[_hash] = true;
1378         mintCount += _count;
1379         totalMinted += _count;
1380         _mint(msg.sender, _tokenId, _count, "");
1381     }
1382 
1383     function matchSigner(bytes32 _hash, bytes memory _signature) private view returns(bool) {
1384         return _signerAddress == ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
1385     }
1386 
1387     function matchHash(address _sender, uint256 _count, bytes32 _hash) private pure returns(bool) {
1388         bytes32 h = keccak256(abi.encode(_sender, _count));
1389         return h == _hash;
1390     }
1391 
1392     function checkWhitelist(
1393         address _sender,
1394         uint256 _count,
1395         bytes32 _hash,
1396         bytes memory _sig
1397     ) public view returns(bool) {
1398         return matchHash(_sender, _count, _hash) && matchSigner(_hash, _sig);
1399     }
1400 
1401     // One Way Bridge function from old JKKeyCard to new JKKeyCard
1402     function bridge(uint256 _count) external {
1403         require(IERC1155(oldJK).isApprovedForAll(msg.sender, address(this)), "not approved.");
1404         require(IERC1155(oldJK).balanceOf(msg.sender, _tokenId) >= _count, "not enough balance");
1405         require(bridgeCount + _count <= oldJKSupply, "bridge exceed supply");
1406 
1407         bridgeCount += _count;
1408         totalMinted += _count;
1409         // BURN
1410         IERC1155(oldJK).safeTransferFrom(msg.sender, 0xDEadadD000000000000000000000000000000000, 1, _count, "");
1411         _mint(msg.sender, _tokenId, _count, "");
1412     }
1413 
1414     // ** Admin Fuctions ** //
1415     function setURI(string memory newuri) external onlyOwner {
1416         _setURI(newuri);
1417     }
1418 
1419     function withdraw(address payable _to) external onlyOwner {
1420         require(_to != address(0), "cannot withdraw to address(0)");
1421         require(address(this).balance > 0, "empty balance");
1422         _to.transfer(address(this).balance);
1423     }
1424 
1425     function setSaleStarted(bool _hasStarted) external onlyOwner {
1426         require(saleStarted != _hasStarted, "saleStarted already set");
1427         saleStarted = _hasStarted;
1428     }
1429 
1430     function setPresaleStarted(bool _hasStarted) external onlyOwner {
1431         require(presaleStarted != _hasStarted, "presaleStarted already set");
1432         presaleStarted= _hasStarted;
1433     }
1434 
1435     function setSignerAddress(address _signer) external onlyOwner {
1436         require(_signer != address(0), "signer address null");
1437         _signerAddress = _signer;
1438     }
1439 
1440     function setMaxPerAddress(uint256 _max) external onlyOwner {
1441         require(_max > 0, "max cannot be null");
1442         maxPerAddress = _max;
1443     }
1444 
1445     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1446         require(_maxSupply > 0, "max supply cannot be 0");
1447         require(_maxSupply >= oldJKSupply, "supply cannot be lower than oldKey supply");
1448         maxKeySupply = _maxSupply;
1449     }
1450 
1451     function setMintPrice(uint256 _price) external onlyOwner {
1452         mintPrice = _price;
1453     }
1454 }