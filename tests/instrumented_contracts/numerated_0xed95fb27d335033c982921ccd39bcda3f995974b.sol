1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.3
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
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
28 
29 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.3.3
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Required interface of an ERC1155 compliant contract, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
36  *
37  * _Available since v3.1._
38  */
39 interface IERC1155 is IERC165 {
40     /**
41      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
42      */
43     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
44 
45     /**
46      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
47      * transfers.
48      */
49     event TransferBatch(
50         address indexed operator,
51         address indexed from,
52         address indexed to,
53         uint256[] ids,
54         uint256[] values
55     );
56 
57     /**
58      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
59      * `approved`.
60      */
61     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
62 
63     /**
64      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
65      *
66      * If an {URI} event was emitted for `id`, the standard
67      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
68      * returned by {IERC1155MetadataURI-uri}.
69      */
70     event URI(string value, uint256 indexed id);
71 
72     /**
73      * @dev Returns the amount of tokens of token type `id` owned by `account`.
74      *
75      * Requirements:
76      *
77      * - `account` cannot be the zero address.
78      */
79     function balanceOf(address account, uint256 id) external view returns (uint256);
80 
81     /**
82      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
83      *
84      * Requirements:
85      *
86      * - `accounts` and `ids` must have the same length.
87      */
88     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
89         external
90         view
91         returns (uint256[] memory);
92 
93     /**
94      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
95      *
96      * Emits an {ApprovalForAll} event.
97      *
98      * Requirements:
99      *
100      * - `operator` cannot be the caller.
101      */
102     function setApprovalForAll(address operator, bool approved) external;
103 
104     /**
105      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
106      *
107      * See {setApprovalForAll}.
108      */
109     function isApprovedForAll(address account, address operator) external view returns (bool);
110 
111     /**
112      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
113      *
114      * Emits a {TransferSingle} event.
115      *
116      * Requirements:
117      *
118      * - `to` cannot be the zero address.
119      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
120      * - `from` must have a balance of tokens of type `id` of at least `amount`.
121      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
122      * acceptance magic value.
123      */
124     function safeTransferFrom(
125         address from,
126         address to,
127         uint256 id,
128         uint256 amount,
129         bytes calldata data
130     ) external;
131 
132     /**
133      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
134      *
135      * Emits a {TransferBatch} event.
136      *
137      * Requirements:
138      *
139      * - `ids` and `amounts` must have the same length.
140      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
141      * acceptance magic value.
142      */
143     function safeBatchTransferFrom(
144         address from,
145         address to,
146         uint256[] calldata ids,
147         uint256[] calldata amounts,
148         bytes calldata data
149     ) external;
150 }
151 
152 
153 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.3.3
154 
155 pragma solidity ^0.8.0;
156 
157 /**
158  * @dev _Available since v3.1._
159  */
160 interface IERC1155Receiver is IERC165 {
161     /**
162         @dev Handles the receipt of a single ERC1155 token type. This function is
163         called at the end of a `safeTransferFrom` after the balance has been updated.
164         To accept the transfer, this must return
165         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
166         (i.e. 0xf23a6e61, or its own function selector).
167         @param operator The address which initiated the transfer (i.e. msg.sender)
168         @param from The address which previously owned the token
169         @param id The ID of the token being transferred
170         @param value The amount of tokens being transferred
171         @param data Additional data with no specified format
172         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
173     */
174     function onERC1155Received(
175         address operator,
176         address from,
177         uint256 id,
178         uint256 value,
179         bytes calldata data
180     ) external returns (bytes4);
181 
182     /**
183         @dev Handles the receipt of a multiple ERC1155 token types. This function
184         is called at the end of a `safeBatchTransferFrom` after the balances have
185         been updated. To accept the transfer(s), this must return
186         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
187         (i.e. 0xbc197c81, or its own function selector).
188         @param operator The address which initiated the batch transfer (i.e. msg.sender)
189         @param from The address which previously owned the token
190         @param ids An array containing ids of each token being transferred (order and length must match values array)
191         @param values An array containing amounts of each token being transferred (order and length must match ids array)
192         @param data Additional data with no specified format
193         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
194     */
195     function onERC1155BatchReceived(
196         address operator,
197         address from,
198         uint256[] calldata ids,
199         uint256[] calldata values,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 
205 // File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.3.3
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
211  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
212  *
213  * _Available since v3.1._
214  */
215 interface IERC1155MetadataURI is IERC1155 {
216     /**
217      * @dev Returns the URI for token type `id`.
218      *
219      * If the `\{id\}` substring is present in the URI, it must be replaced by
220      * clients with the actual token type ID.
221      */
222     function uri(uint256 id) external view returns (string memory);
223 }
224 
225 
226 // File @openzeppelin/contracts/utils/Address.sol@v4.3.3
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 
444 // File @openzeppelin/contracts/utils/Context.sol@v4.3.3
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev Provides information about the current execution context, including the
450  * sender of the transaction and its data. While these are generally available
451  * via msg.sender and msg.data, they should not be accessed in such a direct
452  * manner, since when dealing with meta-transactions the account sending and
453  * paying for execution may not be the actual sender (as far as an application
454  * is concerned).
455  *
456  * This contract is only required for intermediate, library-like contracts.
457  */
458 abstract contract Context {
459     function _msgSender() internal view virtual returns (address) {
460         return msg.sender;
461     }
462 
463     function _msgData() internal view virtual returns (bytes calldata) {
464         return msg.data;
465     }
466 }
467 
468 
469 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.3
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @dev Implementation of the {IERC165} interface.
475  *
476  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
477  * for the additional interface id that will be supported. For example:
478  *
479  * ```solidity
480  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
482  * }
483  * ```
484  *
485  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
486  */
487 abstract contract ERC165 is IERC165 {
488     /**
489      * @dev See {IERC165-supportsInterface}.
490      */
491     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
492         return interfaceId == type(IERC165).interfaceId;
493     }
494 }
495 
496 
497 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.3.3
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Implementation of the basic standard multi-token.
503  * See https://eips.ethereum.org/EIPS/eip-1155
504  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
505  *
506  * _Available since v3.1._
507  */
508 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
509     using Address for address;
510 
511     // Mapping from token ID to account balances
512     mapping(uint256 => mapping(address => uint256)) private _balances;
513 
514     // Mapping from account to operator approvals
515     mapping(address => mapping(address => bool)) private _operatorApprovals;
516 
517     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
518     string private _uri;
519 
520     /**
521      * @dev See {_setURI}.
522      */
523     constructor(string memory uri_) {
524         _setURI(uri_);
525     }
526 
527     /**
528      * @dev See {IERC165-supportsInterface}.
529      */
530     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
531         return
532             interfaceId == type(IERC1155).interfaceId ||
533             interfaceId == type(IERC1155MetadataURI).interfaceId ||
534             super.supportsInterface(interfaceId);
535     }
536 
537     /**
538      * @dev See {IERC1155MetadataURI-uri}.
539      *
540      * This implementation returns the same URI for *all* token types. It relies
541      * on the token type ID substitution mechanism
542      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
543      *
544      * Clients calling this function must replace the `\{id\}` substring with the
545      * actual token type ID.
546      */
547     function uri(uint256) public view virtual override returns (string memory) {
548         return _uri;
549     }
550 
551     /**
552      * @dev See {IERC1155-balanceOf}.
553      *
554      * Requirements:
555      *
556      * - `account` cannot be the zero address.
557      */
558     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
559         require(account != address(0), "ERC1155: balance query for the zero address");
560         return _balances[id][account];
561     }
562 
563     /**
564      * @dev See {IERC1155-balanceOfBatch}.
565      *
566      * Requirements:
567      *
568      * - `accounts` and `ids` must have the same length.
569      */
570     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
571         public
572         view
573         virtual
574         override
575         returns (uint256[] memory)
576     {
577         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
578 
579         uint256[] memory batchBalances = new uint256[](accounts.length);
580 
581         for (uint256 i = 0; i < accounts.length; ++i) {
582             batchBalances[i] = balanceOf(accounts[i], ids[i]);
583         }
584 
585         return batchBalances;
586     }
587 
588     /**
589      * @dev See {IERC1155-setApprovalForAll}.
590      */
591     function setApprovalForAll(address operator, bool approved) public virtual override {
592         require(_msgSender() != operator, "ERC1155: setting approval status for self");
593 
594         _operatorApprovals[_msgSender()][operator] = approved;
595         emit ApprovalForAll(_msgSender(), operator, approved);
596     }
597 
598     /**
599      * @dev See {IERC1155-isApprovedForAll}.
600      */
601     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
602         return _operatorApprovals[account][operator];
603     }
604 
605     /**
606      * @dev See {IERC1155-safeTransferFrom}.
607      */
608     function safeTransferFrom(
609         address from,
610         address to,
611         uint256 id,
612         uint256 amount,
613         bytes memory data
614     ) public virtual override {
615         require(
616             from == _msgSender() || isApprovedForAll(from, _msgSender()),
617             "ERC1155: caller is not owner nor approved"
618         );
619         _safeTransferFrom(from, to, id, amount, data);
620     }
621 
622     /**
623      * @dev See {IERC1155-safeBatchTransferFrom}.
624      */
625     function safeBatchTransferFrom(
626         address from,
627         address to,
628         uint256[] memory ids,
629         uint256[] memory amounts,
630         bytes memory data
631     ) public virtual override {
632         require(
633             from == _msgSender() || isApprovedForAll(from, _msgSender()),
634             "ERC1155: transfer caller is not owner nor approved"
635         );
636         _safeBatchTransferFrom(from, to, ids, amounts, data);
637     }
638 
639     /**
640      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
641      *
642      * Emits a {TransferSingle} event.
643      *
644      * Requirements:
645      *
646      * - `to` cannot be the zero address.
647      * - `from` must have a balance of tokens of type `id` of at least `amount`.
648      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
649      * acceptance magic value.
650      */
651     function _safeTransferFrom(
652         address from,
653         address to,
654         uint256 id,
655         uint256 amount,
656         bytes memory data
657     ) internal virtual {
658         require(to != address(0), "ERC1155: transfer to the zero address");
659 
660         address operator = _msgSender();
661 
662         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
663 
664         uint256 fromBalance = _balances[id][from];
665         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
666         unchecked {
667             _balances[id][from] = fromBalance - amount;
668         }
669         _balances[id][to] += amount;
670 
671         emit TransferSingle(operator, from, to, id, amount);
672 
673         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
674     }
675 
676     /**
677      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
678      *
679      * Emits a {TransferBatch} event.
680      *
681      * Requirements:
682      *
683      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
684      * acceptance magic value.
685      */
686     function _safeBatchTransferFrom(
687         address from,
688         address to,
689         uint256[] memory ids,
690         uint256[] memory amounts,
691         bytes memory data
692     ) internal virtual {
693         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
694         require(to != address(0), "ERC1155: transfer to the zero address");
695 
696         address operator = _msgSender();
697 
698         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
699 
700         for (uint256 i = 0; i < ids.length; ++i) {
701             uint256 id = ids[i];
702             uint256 amount = amounts[i];
703 
704             uint256 fromBalance = _balances[id][from];
705             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
706             unchecked {
707                 _balances[id][from] = fromBalance - amount;
708             }
709             _balances[id][to] += amount;
710         }
711 
712         emit TransferBatch(operator, from, to, ids, amounts);
713 
714         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
715     }
716 
717     /**
718      * @dev Sets a new URI for all token types, by relying on the token type ID
719      * substitution mechanism
720      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
721      *
722      * By this mechanism, any occurrence of the `\{id\}` substring in either the
723      * URI or any of the amounts in the JSON file at said URI will be replaced by
724      * clients with the token type ID.
725      *
726      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
727      * interpreted by clients as
728      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
729      * for token type ID 0x4cce0.
730      *
731      * See {uri}.
732      *
733      * Because these URIs cannot be meaningfully represented by the {URI} event,
734      * this function emits no events.
735      */
736     function _setURI(string memory newuri) internal virtual {
737         _uri = newuri;
738     }
739 
740     /**
741      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
742      *
743      * Emits a {TransferSingle} event.
744      *
745      * Requirements:
746      *
747      * - `account` cannot be the zero address.
748      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
749      * acceptance magic value.
750      */
751     function _mint(
752         address account,
753         uint256 id,
754         uint256 amount,
755         bytes memory data
756     ) internal virtual {
757         require(account != address(0), "ERC1155: mint to the zero address");
758 
759         address operator = _msgSender();
760 
761         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
762 
763         _balances[id][account] += amount;
764         emit TransferSingle(operator, address(0), account, id, amount);
765 
766         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
767     }
768 
769     /**
770      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
771      *
772      * Requirements:
773      *
774      * - `ids` and `amounts` must have the same length.
775      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
776      * acceptance magic value.
777      */
778     function _mintBatch(
779         address to,
780         uint256[] memory ids,
781         uint256[] memory amounts,
782         bytes memory data
783     ) internal virtual {
784         require(to != address(0), "ERC1155: mint to the zero address");
785         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
786 
787         address operator = _msgSender();
788 
789         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
790 
791         for (uint256 i = 0; i < ids.length; i++) {
792             _balances[ids[i]][to] += amounts[i];
793         }
794 
795         emit TransferBatch(operator, address(0), to, ids, amounts);
796 
797         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
798     }
799 
800     /**
801      * @dev Destroys `amount` tokens of token type `id` from `account`
802      *
803      * Requirements:
804      *
805      * - `account` cannot be the zero address.
806      * - `account` must have at least `amount` tokens of token type `id`.
807      */
808     function _burn(
809         address account,
810         uint256 id,
811         uint256 amount
812     ) internal virtual {
813         require(account != address(0), "ERC1155: burn from the zero address");
814 
815         address operator = _msgSender();
816 
817         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
818 
819         uint256 accountBalance = _balances[id][account];
820         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
821         unchecked {
822             _balances[id][account] = accountBalance - amount;
823         }
824 
825         emit TransferSingle(operator, account, address(0), id, amount);
826     }
827 
828     /**
829      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
830      *
831      * Requirements:
832      *
833      * - `ids` and `amounts` must have the same length.
834      */
835     function _burnBatch(
836         address account,
837         uint256[] memory ids,
838         uint256[] memory amounts
839     ) internal virtual {
840         require(account != address(0), "ERC1155: burn from the zero address");
841         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
842 
843         address operator = _msgSender();
844 
845         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
846 
847         for (uint256 i = 0; i < ids.length; i++) {
848             uint256 id = ids[i];
849             uint256 amount = amounts[i];
850 
851             uint256 accountBalance = _balances[id][account];
852             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
853             unchecked {
854                 _balances[id][account] = accountBalance - amount;
855             }
856         }
857 
858         emit TransferBatch(operator, account, address(0), ids, amounts);
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
943 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.3.3
944 
945 pragma solidity ^0.8.0;
946 
947 /**
948  * @dev External interface of AccessControl declared to support ERC165 detection.
949  */
950 interface IAccessControl {
951     /**
952      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
953      *
954      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
955      * {RoleAdminChanged} not being emitted signaling this.
956      *
957      * _Available since v3.1._
958      */
959     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
960 
961     /**
962      * @dev Emitted when `account` is granted `role`.
963      *
964      * `sender` is the account that originated the contract call, an admin role
965      * bearer except when using {AccessControl-_setupRole}.
966      */
967     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
968 
969     /**
970      * @dev Emitted when `account` is revoked `role`.
971      *
972      * `sender` is the account that originated the contract call:
973      *   - if using `revokeRole`, it is the admin role bearer
974      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
975      */
976     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
977 
978     /**
979      * @dev Returns `true` if `account` has been granted `role`.
980      */
981     function hasRole(bytes32 role, address account) external view returns (bool);
982 
983     /**
984      * @dev Returns the admin role that controls `role`. See {grantRole} and
985      * {revokeRole}.
986      *
987      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
988      */
989     function getRoleAdmin(bytes32 role) external view returns (bytes32);
990 
991     /**
992      * @dev Grants `role` to `account`.
993      *
994      * If `account` had not been already granted `role`, emits a {RoleGranted}
995      * event.
996      *
997      * Requirements:
998      *
999      * - the caller must have ``role``'s admin role.
1000      */
1001     function grantRole(bytes32 role, address account) external;
1002 
1003     /**
1004      * @dev Revokes `role` from `account`.
1005      *
1006      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1007      *
1008      * Requirements:
1009      *
1010      * - the caller must have ``role``'s admin role.
1011      */
1012     function revokeRole(bytes32 role, address account) external;
1013 
1014     /**
1015      * @dev Revokes `role` from the calling account.
1016      *
1017      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1018      * purpose is to provide a mechanism for accounts to lose their privileges
1019      * if they are compromised (such as when a trusted device is misplaced).
1020      *
1021      * If the calling account had been granted `role`, emits a {RoleRevoked}
1022      * event.
1023      *
1024      * Requirements:
1025      *
1026      * - the caller must be `account`.
1027      */
1028     function renounceRole(bytes32 role, address account) external;
1029 }
1030 
1031 
1032 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.3
1033 
1034 pragma solidity ^0.8.0;
1035 
1036 /**
1037  * @dev String operations.
1038  */
1039 library Strings {
1040     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1041 
1042     /**
1043      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1044      */
1045     function toString(uint256 value) internal pure returns (string memory) {
1046         // Inspired by OraclizeAPI's implementation - MIT licence
1047         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1048 
1049         if (value == 0) {
1050             return "0";
1051         }
1052         uint256 temp = value;
1053         uint256 digits;
1054         while (temp != 0) {
1055             digits++;
1056             temp /= 10;
1057         }
1058         bytes memory buffer = new bytes(digits);
1059         while (value != 0) {
1060             digits -= 1;
1061             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1062             value /= 10;
1063         }
1064         return string(buffer);
1065     }
1066 
1067     /**
1068      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1069      */
1070     function toHexString(uint256 value) internal pure returns (string memory) {
1071         if (value == 0) {
1072             return "0x00";
1073         }
1074         uint256 temp = value;
1075         uint256 length = 0;
1076         while (temp != 0) {
1077             length++;
1078             temp >>= 8;
1079         }
1080         return toHexString(value, length);
1081     }
1082 
1083     /**
1084      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1085      */
1086     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1087         bytes memory buffer = new bytes(2 * length + 2);
1088         buffer[0] = "0";
1089         buffer[1] = "x";
1090         for (uint256 i = 2 * length + 1; i > 1; --i) {
1091             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1092             value >>= 4;
1093         }
1094         require(value == 0, "Strings: hex length insufficient");
1095         return string(buffer);
1096     }
1097 }
1098 
1099 
1100 // File @openzeppelin/contracts/access/AccessControl.sol@v4.3.3
1101 
1102 pragma solidity ^0.8.0;
1103 
1104 /**
1105  * @dev Contract module that allows children to implement role-based access
1106  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1107  * members except through off-chain means by accessing the contract event logs. Some
1108  * applications may benefit from on-chain enumerability, for those cases see
1109  * {AccessControlEnumerable}.
1110  *
1111  * Roles are referred to by their `bytes32` identifier. These should be exposed
1112  * in the external API and be unique. The best way to achieve this is by
1113  * using `public constant` hash digests:
1114  *
1115  * ```
1116  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1117  * ```
1118  *
1119  * Roles can be used to represent a set of permissions. To restrict access to a
1120  * function call, use {hasRole}:
1121  *
1122  * ```
1123  * function foo() public {
1124  *     require(hasRole(MY_ROLE, msg.sender));
1125  *     ...
1126  * }
1127  * ```
1128  *
1129  * Roles can be granted and revoked dynamically via the {grantRole} and
1130  * {revokeRole} functions. Each role has an associated admin role, and only
1131  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1132  *
1133  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1134  * that only accounts with this role will be able to grant or revoke other
1135  * roles. More complex role relationships can be created by using
1136  * {_setRoleAdmin}.
1137  *
1138  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1139  * grant and revoke this role. Extra precautions should be taken to secure
1140  * accounts that have been granted it.
1141  */
1142 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1143     struct RoleData {
1144         mapping(address => bool) members;
1145         bytes32 adminRole;
1146     }
1147 
1148     mapping(bytes32 => RoleData) private _roles;
1149 
1150     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1151 
1152     /**
1153      * @dev Modifier that checks that an account has a specific role. Reverts
1154      * with a standardized message including the required role.
1155      *
1156      * The format of the revert reason is given by the following regular expression:
1157      *
1158      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1159      *
1160      * _Available since v4.1._
1161      */
1162     modifier onlyRole(bytes32 role) {
1163         _checkRole(role, _msgSender());
1164         _;
1165     }
1166 
1167     /**
1168      * @dev See {IERC165-supportsInterface}.
1169      */
1170     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1171         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1172     }
1173 
1174     /**
1175      * @dev Returns `true` if `account` has been granted `role`.
1176      */
1177     function hasRole(bytes32 role, address account) public view override returns (bool) {
1178         return _roles[role].members[account];
1179     }
1180 
1181     /**
1182      * @dev Revert with a standard message if `account` is missing `role`.
1183      *
1184      * The format of the revert reason is given by the following regular expression:
1185      *
1186      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1187      */
1188     function _checkRole(bytes32 role, address account) internal view {
1189         if (!hasRole(role, account)) {
1190             revert(
1191                 string(
1192                     abi.encodePacked(
1193                         "AccessControl: account ",
1194                         Strings.toHexString(uint160(account), 20),
1195                         " is missing role ",
1196                         Strings.toHexString(uint256(role), 32)
1197                     )
1198                 )
1199             );
1200         }
1201     }
1202 
1203     /**
1204      * @dev Returns the admin role that controls `role`. See {grantRole} and
1205      * {revokeRole}.
1206      *
1207      * To change a role's admin, use {_setRoleAdmin}.
1208      */
1209     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1210         return _roles[role].adminRole;
1211     }
1212 
1213     /**
1214      * @dev Grants `role` to `account`.
1215      *
1216      * If `account` had not been already granted `role`, emits a {RoleGranted}
1217      * event.
1218      *
1219      * Requirements:
1220      *
1221      * - the caller must have ``role``'s admin role.
1222      */
1223     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1224         _grantRole(role, account);
1225     }
1226 
1227     /**
1228      * @dev Revokes `role` from `account`.
1229      *
1230      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1231      *
1232      * Requirements:
1233      *
1234      * - the caller must have ``role``'s admin role.
1235      */
1236     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1237         _revokeRole(role, account);
1238     }
1239 
1240     /**
1241      * @dev Revokes `role` from the calling account.
1242      *
1243      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1244      * purpose is to provide a mechanism for accounts to lose their privileges
1245      * if they are compromised (such as when a trusted device is misplaced).
1246      *
1247      * If the calling account had been granted `role`, emits a {RoleRevoked}
1248      * event.
1249      *
1250      * Requirements:
1251      *
1252      * - the caller must be `account`.
1253      */
1254     function renounceRole(bytes32 role, address account) public virtual override {
1255         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1256 
1257         _revokeRole(role, account);
1258     }
1259 
1260     /**
1261      * @dev Grants `role` to `account`.
1262      *
1263      * If `account` had not been already granted `role`, emits a {RoleGranted}
1264      * event. Note that unlike {grantRole}, this function doesn't perform any
1265      * checks on the calling account.
1266      *
1267      * [WARNING]
1268      * ====
1269      * This function should only be called from the constructor when setting
1270      * up the initial roles for the system.
1271      *
1272      * Using this function in any other way is effectively circumventing the admin
1273      * system imposed by {AccessControl}.
1274      * ====
1275      */
1276     function _setupRole(bytes32 role, address account) internal virtual {
1277         _grantRole(role, account);
1278     }
1279 
1280     /**
1281      * @dev Sets `adminRole` as ``role``'s admin role.
1282      *
1283      * Emits a {RoleAdminChanged} event.
1284      */
1285     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1286         bytes32 previousAdminRole = getRoleAdmin(role);
1287         _roles[role].adminRole = adminRole;
1288         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1289     }
1290 
1291     function _grantRole(bytes32 role, address account) private {
1292         if (!hasRole(role, account)) {
1293             _roles[role].members[account] = true;
1294             emit RoleGranted(role, account, _msgSender());
1295         }
1296     }
1297 
1298     function _revokeRole(bytes32 role, address account) private {
1299         if (hasRole(role, account)) {
1300             _roles[role].members[account] = false;
1301             emit RoleRevoked(role, account, _msgSender());
1302         }
1303     }
1304 }
1305 
1306 
1307 // File contracts/tokens_1155.sol
1308 
1309 pragma solidity ^0.8.2;
1310 
1311 
1312 contract Tokens1155 is ERC1155, AccessControl {
1313     bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
1314     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1315 
1316     // Fungible Token ID range is 1..10000
1317     // NFT ID range is 10001+
1318 
1319     // This is the current lowest ID that can be minted
1320     uint256 public minimumId;
1321 
1322     constructor()
1323         ERC1155("")
1324     {
1325         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1326         _setupRole(MINTER_ROLE, msg.sender);
1327         minimumId = 10000;
1328     }
1329 
1330     function setURI(string memory newuri) public onlyRole(DEFAULT_ADMIN_ROLE) {
1331         _setURI(newuri);
1332     }
1333 
1334     // As long as IDs are minted sequentially (and this can be verified after each call), IDs in the non-fungible range
1335     // are safe from being duplicated.
1336     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1337         public
1338         onlyRole(MINTER_ROLE)
1339     {
1340         if(ids[0] <= 10000) { // Fungible zone
1341             for (uint256 i = 0; i < ids.length; i++) {
1342                 require(ids[i] <= 10000, "Fungible ID must be below 10000");
1343             }
1344         } else { // Non-fungible zone
1345             for (uint256 i = 0; i < ids.length; i++) {
1346                 require(ids[i] == minimumId + i + 1, "IDs are not incremental");
1347             }
1348             minimumId += ids.length;
1349         }
1350 
1351         _mintBatch(to, ids, amounts, data);
1352     }
1353 
1354     // The following functions are overrides required by Solidity.
1355     function supportsInterface(bytes4 interfaceId)
1356         public
1357         view
1358         override(ERC1155, AccessControl)
1359         returns (bool)
1360     {
1361         return super.supportsInterface(interfaceId);
1362     }
1363 }