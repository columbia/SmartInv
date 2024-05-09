1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity ^0.8.2;
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 
5 
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
28 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
29 
30 
31 
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
152 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
153 
154 
155 
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
204 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
205 
206 
207 
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
225 // File: @openzeppelin/contracts/utils/Address.sol
226 
227 
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         uint256 size;
256         assembly {
257             size := extcodesize(account)
258         }
259         return size > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
415      * revert reason using the provided one.
416      *
417      * _Available since v4.3._
418      */
419     function verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) internal pure returns (bytes memory) {
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430 
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 // File: @openzeppelin/contracts/utils/Context.sol
443 
444 
445 
446 /**
447  * @dev Provides information about the current execution context, including the
448  * sender of the transaction and its data. While these are generally available
449  * via msg.sender and msg.data, they should not be accessed in such a direct
450  * manner, since when dealing with meta-transactions the account sending and
451  * paying for execution may not be the actual sender (as far as an application
452  * is concerned).
453  *
454  * This contract is only required for intermediate, library-like contracts.
455  */
456 abstract contract Context {
457     function _msgSender() internal view virtual returns (address) {
458         return msg.sender;
459     }
460 
461     function _msgData() internal view virtual returns (bytes calldata) {
462         return msg.data;
463     }
464 }
465 
466 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
467 
468 
469 
470 
471 /**
472  * @dev Implementation of the {IERC165} interface.
473  *
474  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
475  * for the additional interface id that will be supported. For example:
476  *
477  * ```solidity
478  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
479  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
480  * }
481  * ```
482  *
483  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
484  */
485 abstract contract ERC165 is IERC165 {
486     /**
487      * @dev See {IERC165-supportsInterface}.
488      */
489     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
490         return interfaceId == type(IERC165).interfaceId;
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
495 
496 
497 
498 
499 
500 
501 
502 
503 
504 /**
505  * @dev Implementation of the basic standard multi-token.
506  * See https://eips.ethereum.org/EIPS/eip-1155
507  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
508  *
509  * _Available since v3.1._
510  */
511 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
512     using Address for address;
513 
514     // Mapping from token ID to account balances
515     mapping(uint256 => mapping(address => uint256)) private _balances;
516 
517     // Mapping from account to operator approvals
518     mapping(address => mapping(address => bool)) private _operatorApprovals;
519 
520     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
521     string private _uri;
522 
523     /**
524      * @dev See {_setURI}.
525      */
526     constructor(string memory uri_) {
527         _setURI(uri_);
528     }
529 
530     /**
531      * @dev See {IERC165-supportsInterface}.
532      */
533     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
534         return
535             interfaceId == type(IERC1155).interfaceId ||
536             interfaceId == type(IERC1155MetadataURI).interfaceId ||
537             super.supportsInterface(interfaceId);
538     }
539 
540     /**
541      * @dev See {IERC1155MetadataURI-uri}.
542      *
543      * This implementation returns the same URI for *all* token types. It relies
544      * on the token type ID substitution mechanism
545      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
546      *
547      * Clients calling this function must replace the `\{id\}` substring with the
548      * actual token type ID.
549      */
550     function uri(uint256) public view virtual override returns (string memory) {
551         return _uri;
552     }
553 
554     /**
555      * @dev See {IERC1155-balanceOf}.
556      *
557      * Requirements:
558      *
559      * - `account` cannot be the zero address.
560      */
561     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
562         require(account != address(0), "ERC1155: balance query for the zero address");
563         return _balances[id][account];
564     }
565 
566     /**
567      * @dev See {IERC1155-balanceOfBatch}.
568      *
569      * Requirements:
570      *
571      * - `accounts` and `ids` must have the same length.
572      */
573     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
574         public
575         view
576         virtual
577         override
578         returns (uint256[] memory)
579     {
580         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
581 
582         uint256[] memory batchBalances = new uint256[](accounts.length);
583 
584         for (uint256 i = 0; i < accounts.length; ++i) {
585             batchBalances[i] = balanceOf(accounts[i], ids[i]);
586         }
587 
588         return batchBalances;
589     }
590 
591     /**
592      * @dev See {IERC1155-setApprovalForAll}.
593      */
594     function setApprovalForAll(address operator, bool approved) public virtual override {
595         require(_msgSender() != operator, "ERC1155: setting approval status for self");
596 
597         _operatorApprovals[_msgSender()][operator] = approved;
598         emit ApprovalForAll(_msgSender(), operator, approved);
599     }
600 
601     /**
602      * @dev See {IERC1155-isApprovedForAll}.
603      */
604     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
605         return _operatorApprovals[account][operator];
606     }
607 
608     /**
609      * @dev See {IERC1155-safeTransferFrom}.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 id,
615         uint256 amount,
616         bytes memory data
617     ) public virtual override {
618         require(
619             from == _msgSender() || isApprovedForAll(from, _msgSender()),
620             "ERC1155: caller is not owner nor approved"
621         );
622         _safeTransferFrom(from, to, id, amount, data);
623     }
624 
625     /**
626      * @dev See {IERC1155-safeBatchTransferFrom}.
627      */
628     function safeBatchTransferFrom(
629         address from,
630         address to,
631         uint256[] memory ids,
632         uint256[] memory amounts,
633         bytes memory data
634     ) public virtual override {
635         require(
636             from == _msgSender() || isApprovedForAll(from, _msgSender()),
637             "ERC1155: transfer caller is not owner nor approved"
638         );
639         _safeBatchTransferFrom(from, to, ids, amounts, data);
640     }
641 
642     /**
643      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
644      *
645      * Emits a {TransferSingle} event.
646      *
647      * Requirements:
648      *
649      * - `to` cannot be the zero address.
650      * - `from` must have a balance of tokens of type `id` of at least `amount`.
651      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
652      * acceptance magic value.
653      */
654     function _safeTransferFrom(
655         address from,
656         address to,
657         uint256 id,
658         uint256 amount,
659         bytes memory data
660     ) internal virtual {
661         require(to != address(0), "ERC1155: transfer to the zero address");
662 
663         address operator = _msgSender();
664 
665         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
666 
667         uint256 fromBalance = _balances[id][from];
668         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
669         unchecked {
670             _balances[id][from] = fromBalance - amount;
671         }
672         _balances[id][to] += amount;
673 
674         emit TransferSingle(operator, from, to, id, amount);
675 
676         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
677     }
678 
679     /**
680      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
681      *
682      * Emits a {TransferBatch} event.
683      *
684      * Requirements:
685      *
686      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
687      * acceptance magic value.
688      */
689     function _safeBatchTransferFrom(
690         address from,
691         address to,
692         uint256[] memory ids,
693         uint256[] memory amounts,
694         bytes memory data
695     ) internal virtual {
696         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
697         require(to != address(0), "ERC1155: transfer to the zero address");
698 
699         address operator = _msgSender();
700 
701         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
702 
703         for (uint256 i = 0; i < ids.length; ++i) {
704             uint256 id = ids[i];
705             uint256 amount = amounts[i];
706 
707             uint256 fromBalance = _balances[id][from];
708             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
709             unchecked {
710                 _balances[id][from] = fromBalance - amount;
711             }
712             _balances[id][to] += amount;
713         }
714 
715         emit TransferBatch(operator, from, to, ids, amounts);
716 
717         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
718     }
719 
720     /**
721      * @dev Sets a new URI for all token types, by relying on the token type ID
722      * substitution mechanism
723      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
724      *
725      * By this mechanism, any occurrence of the `\{id\}` substring in either the
726      * URI or any of the amounts in the JSON file at said URI will be replaced by
727      * clients with the token type ID.
728      *
729      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
730      * interpreted by clients as
731      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
732      * for token type ID 0x4cce0.
733      *
734      * See {uri}.
735      *
736      * Because these URIs cannot be meaningfully represented by the {URI} event,
737      * this function emits no events.
738      */
739     function _setURI(string memory newuri) internal virtual {
740         _uri = newuri;
741     }
742 
743     /**
744      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
745      *
746      * Emits a {TransferSingle} event.
747      *
748      * Requirements:
749      *
750      * - `account` cannot be the zero address.
751      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
752      * acceptance magic value.
753      */
754     function _mint(
755         address account,
756         uint256 id,
757         uint256 amount,
758         bytes memory data
759     ) internal virtual {
760         require(account != address(0), "ERC1155: mint to the zero address");
761 
762         address operator = _msgSender();
763 
764         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
765 
766         _balances[id][account] += amount;
767         emit TransferSingle(operator, address(0), account, id, amount);
768 
769         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
770     }
771 
772     /**
773      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
774      *
775      * Requirements:
776      *
777      * - `ids` and `amounts` must have the same length.
778      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
779      * acceptance magic value.
780      */
781     function _mintBatch(
782         address to,
783         uint256[] memory ids,
784         uint256[] memory amounts,
785         bytes memory data
786     ) internal virtual {
787         require(to != address(0), "ERC1155: mint to the zero address");
788         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
789 
790         address operator = _msgSender();
791 
792         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
793 
794         for (uint256 i = 0; i < ids.length; i++) {
795             _balances[ids[i]][to] += amounts[i];
796         }
797 
798         emit TransferBatch(operator, address(0), to, ids, amounts);
799 
800         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
801     }
802 
803     /**
804      * @dev Destroys `amount` tokens of token type `id` from `account`
805      *
806      * Requirements:
807      *
808      * - `account` cannot be the zero address.
809      * - `account` must have at least `amount` tokens of token type `id`.
810      */
811     function _burn(
812         address account,
813         uint256 id,
814         uint256 amount
815     ) internal virtual {
816         require(account != address(0), "ERC1155: burn from the zero address");
817 
818         address operator = _msgSender();
819 
820         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
821 
822         uint256 accountBalance = _balances[id][account];
823         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
824         unchecked {
825             _balances[id][account] = accountBalance - amount;
826         }
827 
828         emit TransferSingle(operator, account, address(0), id, amount);
829     }
830 
831     /**
832      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
833      *
834      * Requirements:
835      *
836      * - `ids` and `amounts` must have the same length.
837      */
838     function _burnBatch(
839         address account,
840         uint256[] memory ids,
841         uint256[] memory amounts
842     ) internal virtual {
843         require(account != address(0), "ERC1155: burn from the zero address");
844         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
845 
846         address operator = _msgSender();
847 
848         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
849 
850         for (uint256 i = 0; i < ids.length; i++) {
851             uint256 id = ids[i];
852             uint256 amount = amounts[i];
853 
854             uint256 accountBalance = _balances[id][account];
855             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
856             unchecked {
857                 _balances[id][account] = accountBalance - amount;
858             }
859         }
860 
861         emit TransferBatch(operator, account, address(0), ids, amounts);
862     }
863 
864     /**
865      * @dev Hook that is called before any token transfer. This includes minting
866      * and burning, as well as batched variants.
867      *
868      * The same hook is called on both single and batched variants. For single
869      * transfers, the length of the `id` and `amount` arrays will be 1.
870      *
871      * Calling conditions (for each `id` and `amount` pair):
872      *
873      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
874      * of token type `id` will be  transferred to `to`.
875      * - When `from` is zero, `amount` tokens of token type `id` will be minted
876      * for `to`.
877      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
878      * will be burned.
879      * - `from` and `to` are never both zero.
880      * - `ids` and `amounts` have the same, non-zero length.
881      *
882      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
883      */
884     function _beforeTokenTransfer(
885         address operator,
886         address from,
887         address to,
888         uint256[] memory ids,
889         uint256[] memory amounts,
890         bytes memory data
891     ) internal virtual {}
892 
893     function _doSafeTransferAcceptanceCheck(
894         address operator,
895         address from,
896         address to,
897         uint256 id,
898         uint256 amount,
899         bytes memory data
900     ) private {
901         if (to.isContract()) {
902             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
903                 if (response != IERC1155Receiver.onERC1155Received.selector) {
904                     revert("ERC1155: ERC1155Receiver rejected tokens");
905                 }
906             } catch Error(string memory reason) {
907                 revert(reason);
908             } catch {
909                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
910             }
911         }
912     }
913 
914     function _doSafeBatchTransferAcceptanceCheck(
915         address operator,
916         address from,
917         address to,
918         uint256[] memory ids,
919         uint256[] memory amounts,
920         bytes memory data
921     ) private {
922         if (to.isContract()) {
923             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
924                 bytes4 response
925             ) {
926                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
927                     revert("ERC1155: ERC1155Receiver rejected tokens");
928                 }
929             } catch Error(string memory reason) {
930                 revert(reason);
931             } catch {
932                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
933             }
934         }
935     }
936 
937     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
938         uint256[] memory array = new uint256[](1);
939         array[0] = element;
940 
941         return array;
942     }
943 }
944 
945 // File: @openzeppelin/contracts/access/Ownable.sol
946 
947 
948 
949 
950 /**
951  * @dev Contract module which provides a basic access control mechanism, where
952  * there is an account (an owner) that can be granted exclusive access to
953  * specific functions.
954  *
955  * By default, the owner account will be the one that deploys the contract. This
956  * can later be changed with {transferOwnership}.
957  *
958  * This module is used through inheritance. It will make available the modifier
959  * `onlyOwner`, which can be applied to your functions to restrict their use to
960  * the owner.
961  */
962 abstract contract Ownable is Context {
963     address private _owner;
964 
965     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
966 
967     /**
968      * @dev Initializes the contract setting the deployer as the initial owner.
969      */
970     constructor() {
971         _setOwner(_msgSender());
972     }
973 
974     /**
975      * @dev Returns the address of the current owner.
976      */
977     function owner() public view virtual returns (address) {
978         return _owner;
979     }
980 
981     /**
982      * @dev Throws if called by any account other than the owner.
983      */
984     modifier onlyOwner() {
985         require(owner() == _msgSender(), "Ownable: caller is not the owner");
986         _;
987     }
988 
989     /**
990      * @dev Leaves the contract without owner. It will not be possible to call
991      * `onlyOwner` functions anymore. Can only be called by the current owner.
992      *
993      * NOTE: Renouncing ownership will leave the contract without an owner,
994      * thereby removing any functionality that is only available to the owner.
995      */
996     function renounceOwnership() public virtual onlyOwner {
997         _setOwner(address(0));
998     }
999 
1000     /**
1001      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1002      * Can only be called by the current owner.
1003      */
1004     function transferOwnership(address newOwner) public virtual onlyOwner {
1005         require(newOwner != address(0), "Ownable: new owner is the zero address");
1006         _setOwner(newOwner);
1007     }
1008 
1009     function _setOwner(address newOwner) private {
1010         address oldOwner = _owner;
1011         _owner = newOwner;
1012         emit OwnershipTransferred(oldOwner, newOwner);
1013     }
1014 }
1015 
1016 // File: contracts/AddressSet.sol
1017 
1018 // Copyright 2017 Loopring Technology Limited.
1019 
1020 
1021 /// @title AddressSet
1022 /// @author Daniel Wang - <daniel@loopring.org>
1023 contract AddressSet
1024 {
1025     struct Set
1026     {
1027         address[] addresses;
1028         mapping (address => uint) positions;
1029         uint count;
1030     }
1031     mapping (bytes32 => Set) private sets;
1032 
1033     function addAddressToSet(
1034         bytes32 key,
1035         address addr,
1036         bool    maintainList
1037         ) internal
1038     {
1039         Set storage set = sets[key];
1040         require(set.positions[addr] == 0, "ALREADY_IN_SET");
1041 
1042         if (maintainList) {
1043             require(set.addresses.length == set.count, "PREVIOUSLY_NOT_MAINTAILED");
1044             set.addresses.push(addr);
1045         } else {
1046             require(set.addresses.length == 0, "MUST_MAINTAIN");
1047         }
1048 
1049         set.count += 1;
1050         set.positions[addr] = set.count;
1051     }
1052 
1053     function removeAddressFromSet(
1054         bytes32 key,
1055         address addr
1056         )
1057         internal
1058     {
1059         Set storage set = sets[key];
1060         uint pos = set.positions[addr];
1061         require(pos != 0, "NOT_IN_SET");
1062 
1063         delete set.positions[addr];
1064         set.count -= 1;
1065 
1066         if (set.addresses.length > 0) {
1067             address lastAddr = set.addresses[set.count];
1068             if (lastAddr != addr) {
1069                 set.addresses[pos - 1] = lastAddr;
1070                 set.positions[lastAddr] = pos;
1071             }
1072             set.addresses.pop();
1073         }
1074     }
1075 
1076     function removeSet(bytes32 key)
1077         internal
1078     {
1079         delete sets[key];
1080     }
1081 
1082     function isAddressInSet(
1083         bytes32 key,
1084         address addr
1085         )
1086         internal
1087         view
1088         returns (bool)
1089     {
1090         return sets[key].positions[addr] != 0;
1091     }
1092 
1093     function numAddressesInSet(bytes32 key)
1094         internal
1095         view
1096         returns (uint)
1097     {
1098         Set storage set = sets[key];
1099         return set.count;
1100     }
1101 
1102     function addressesInSet(bytes32 key)
1103         internal
1104         view
1105         returns (address[] memory)
1106     {
1107         Set storage set = sets[key];
1108         require(set.count == set.addresses.length, "NOT_MAINTAINED");
1109         return sets[key].addresses;
1110     }
1111 }
1112 
1113 // File: contracts/external/IL2MintableNFT.sol
1114 
1115 // Copyright 2017 Loopring Technology Limited.
1116 
1117 
1118 interface IL2MintableNFT
1119 {
1120     /// @dev This function is called when an NFT minted on L2 is withdrawn from Loopring.
1121     ///      That means the NFTs were burned on L2 and now need to be minted on L1.
1122     ///
1123     ///      This function can only be called by the Loopring exchange.
1124     ///
1125     /// @param to The owner of the NFT
1126     /// @param tokenId The token type 'id`
1127     /// @param amount The amount of NFTs to mint
1128     /// @param minter The minter on L2, which can be used to decide if the NFT is authentic
1129     /// @param data Opaque data that can be used by the contract
1130     function mintFromL2(
1131         address          to,
1132         uint256          tokenId,
1133         uint             amount,
1134         address          minter,
1135         bytes   calldata data
1136         )
1137         external;
1138 
1139     /// @dev Returns a list of all address that are authorized to mint NFTs on L2.
1140     /// @return The list of authorized minter on L2
1141     function minters()
1142         external
1143         view
1144         returns (address[] memory);
1145 }
1146 
1147 // File: contracts/ICollection.sol
1148 
1149 
1150 
1151 
1152 /**
1153  * @title ICollection
1154  */
1155 abstract contract ICollection
1156 {
1157     function collectionID()
1158         public
1159         view
1160         virtual
1161         returns (uint32 id);
1162 
1163     function tokenURI(uint256 tokenId)
1164         public
1165         view
1166         virtual
1167         returns (string memory);
1168 }
1169 
1170 // File: ../contracts/MoodyBrainsNFT.sol
1171 
1172 
1173 
1174 
1175 
1176 
1177 
1178 
1179 /**
1180  * @title MoodyBrainsNFT
1181  */
1182 
1183 contract MoodyBrainsNFT is ERC1155, Ownable, IL2MintableNFT, AddressSet
1184 {
1185     event CollectionUpdated(
1186         uint32  indexed collectionID,
1187         ICollection     collection
1188     );
1189 
1190     event MintFromL2(
1191         address owner,
1192         uint256 id,
1193         uint    amount,
1194         address minter
1195     );
1196 
1197     bytes32 internal constant MINTERS = keccak256("__MINTERS__");
1198     bytes32 internal constant DEPRECATED_MINTERS = keccak256("__DEPRECATED_MINTERS__");
1199 
1200     address public immutable layer2Address;
1201 
1202     mapping(uint32 => ICollection) collections;
1203 
1204     modifier onlyFromLayer2
1205     {
1206         require(msg.sender == layer2Address, "not authorized");
1207         _;
1208     }
1209 
1210     modifier onlyFromMinter
1211     {
1212         require(isMinter(msg.sender), "not authorized");
1213         _;
1214     }
1215 
1216     constructor(address _layer2Address)
1217         ERC1155("")
1218     {
1219         layer2Address = _layer2Address;
1220     }
1221 
1222     function mint(
1223         address       account,
1224         uint256       id,
1225         uint256       amount,
1226         bytes  memory data
1227         )
1228         external
1229     onlyFromMinter
1230     {
1231         _mint(account, id, amount, data);
1232     }
1233 
1234     function mintBatch(
1235         address          to,
1236         uint256[] memory ids,
1237         uint256[] memory amounts,
1238         bytes     memory data
1239         )
1240         external
1241     onlyFromMinter
1242     {
1243         _mintBatch(to, ids, amounts, data);
1244     }
1245 
1246     function addCollection(ICollection collection)
1247         external
1248         onlyOwner
1249     {
1250         uint32 id = collection.collectionID();
1251         collections[id] = collection;
1252         emit CollectionUpdated(id, collection);
1253     }
1254 
1255     function setMinter(
1256         address minter,
1257         bool enabled
1258         )
1259         external
1260         onlyOwner
1261     {
1262         if (enabled) {
1263             addAddressToSet(MINTERS, minter, true);
1264             if (isAddressInSet(DEPRECATED_MINTERS, minter)) {
1265                 removeAddressFromSet(DEPRECATED_MINTERS, minter);
1266             }
1267         } else {
1268             removeAddressFromSet(MINTERS, minter);
1269             addAddressToSet(DEPRECATED_MINTERS, minter, true);
1270         }
1271     }
1272 
1273     function uri(uint256 tokenId)
1274         public
1275         view
1276         virtual
1277         override
1278         returns (string memory)
1279     {
1280         // The collection ID is always stored in the highest 32 bits
1281         uint32 collectionID = uint32((tokenId >> 224) & 0xFFFFFFFF);
1282         return collections[collectionID].tokenURI(tokenId);
1283     }
1284 
1285     // Layer 2 logic
1286 
1287     function mintFromL2(
1288         address          to,
1289         uint256          id,
1290         uint             amount,
1291         address          minter,
1292         bytes   calldata data
1293         )
1294         external
1295         override
1296     onlyFromLayer2
1297     {
1298         require(isMinter(minter), "invalid minter");
1299 
1300         _mint(to, id, amount, data);
1301         emit MintFromL2(to, id, amount, minter);
1302     }
1303 
1304     function minters()
1305         public
1306         view
1307         override
1308         returns (address[] memory)
1309     {
1310         return addressesInSet(MINTERS);
1311     }
1312 
1313     function isMinter(address addr)
1314         public
1315         view
1316         returns (bool)
1317     {
1318         return isAddressInSet(MINTERS, addr) || isAddressInSet(DEPRECATED_MINTERS, addr);
1319     }
1320 }