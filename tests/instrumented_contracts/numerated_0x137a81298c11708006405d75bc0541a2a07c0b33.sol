1 // Sources flattened with hardhat v2.6.5 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
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
29 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.3.2
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Required interface of an ERC1155 compliant contract, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
37  *
38  * _Available since v3.1._
39  */
40 interface IERC1155 is IERC165 {
41     /**
42      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
43      */
44     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
45 
46     /**
47      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
48      * transfers.
49      */
50     event TransferBatch(
51         address indexed operator,
52         address indexed from,
53         address indexed to,
54         uint256[] ids,
55         uint256[] values
56     );
57 
58     /**
59      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
60      * `approved`.
61      */
62     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
63 
64     /**
65      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
66      *
67      * If an {URI} event was emitted for `id`, the standard
68      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
69      * returned by {IERC1155MetadataURI-uri}.
70      */
71     event URI(string value, uint256 indexed id);
72 
73     /**
74      * @dev Returns the amount of tokens of token type `id` owned by `account`.
75      *
76      * Requirements:
77      *
78      * - `account` cannot be the zero address.
79      */
80     function balanceOf(address account, uint256 id) external view returns (uint256);
81 
82     /**
83      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
84      *
85      * Requirements:
86      *
87      * - `accounts` and `ids` must have the same length.
88      */
89     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
90         external
91         view
92         returns (uint256[] memory);
93 
94     /**
95      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
96      *
97      * Emits an {ApprovalForAll} event.
98      *
99      * Requirements:
100      *
101      * - `operator` cannot be the caller.
102      */
103     function setApprovalForAll(address operator, bool approved) external;
104 
105     /**
106      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
107      *
108      * See {setApprovalForAll}.
109      */
110     function isApprovedForAll(address account, address operator) external view returns (bool);
111 
112     /**
113      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
114      *
115      * Emits a {TransferSingle} event.
116      *
117      * Requirements:
118      *
119      * - `to` cannot be the zero address.
120      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
121      * - `from` must have a balance of tokens of type `id` of at least `amount`.
122      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
123      * acceptance magic value.
124      */
125     function safeTransferFrom(
126         address from,
127         address to,
128         uint256 id,
129         uint256 amount,
130         bytes calldata data
131     ) external;
132 
133     /**
134      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
135      *
136      * Emits a {TransferBatch} event.
137      *
138      * Requirements:
139      *
140      * - `ids` and `amounts` must have the same length.
141      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
142      * acceptance magic value.
143      */
144     function safeBatchTransferFrom(
145         address from,
146         address to,
147         uint256[] calldata ids,
148         uint256[] calldata amounts,
149         bytes calldata data
150     ) external;
151 }
152 
153 
154 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.3.2
155 
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
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
214  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
215  *
216  * _Available since v3.1._
217  */
218 interface IERC1155MetadataURI is IERC1155 {
219     /**
220      * @dev Returns the URI for token type `id`.
221      *
222      * If the `\{id\}` substring is present in the URI, it must be replaced by
223      * clients with the actual token type ID.
224      */
225     function uri(uint256 id) external view returns (string memory);
226 }
227 
228 
229 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
230 
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.
259 
260         uint256 size;
261         assembly {
262             size := extcodesize(account)
263         }
264         return size > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         (bool success, ) = recipient.call{value: amount}("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain `call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, "Address: low-level static call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), "Address: static call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(isContract(target), "Address: delegate call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
420      * revert reason using the provided one.
421      *
422      * _Available since v4.3._
423      */
424     function verifyCallResult(
425         bool success,
426         bytes memory returndata,
427         string memory errorMessage
428     ) internal pure returns (bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435 
436                 assembly {
437                     let returndata_size := mload(returndata)
438                     revert(add(32, returndata), returndata_size)
439                 }
440             } else {
441                 revert(errorMessage);
442             }
443         }
444     }
445 }
446 
447 
448 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
449 
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Provides information about the current execution context, including the
455  * sender of the transaction and its data. While these are generally available
456  * via msg.sender and msg.data, they should not be accessed in such a direct
457  * manner, since when dealing with meta-transactions the account sending and
458  * paying for execution may not be the actual sender (as far as an application
459  * is concerned).
460  *
461  * This contract is only required for intermediate, library-like contracts.
462  */
463 abstract contract Context {
464     function _msgSender() internal view virtual returns (address) {
465         return msg.sender;
466     }
467 
468     function _msgData() internal view virtual returns (bytes calldata) {
469         return msg.data;
470     }
471 }
472 
473 
474 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
475 
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Implementation of the {IERC165} interface.
481  *
482  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
483  * for the additional interface id that will be supported. For example:
484  *
485  * ```solidity
486  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
487  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
488  * }
489  * ```
490  *
491  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
492  */
493 abstract contract ERC165 is IERC165 {
494     /**
495      * @dev See {IERC165-supportsInterface}.
496      */
497     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
498         return interfaceId == type(IERC165).interfaceId;
499     }
500 }
501 
502 
503 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.3.2
504 
505 
506 pragma solidity ^0.8.0;
507 
508 
509 
510 
511 
512 
513 /**
514  * @dev Implementation of the basic standard multi-token.
515  * See https://eips.ethereum.org/EIPS/eip-1155
516  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
517  *
518  * _Available since v3.1._
519  */
520 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
521     using Address for address;
522 
523     // Mapping from token ID to account balances
524     mapping(uint256 => mapping(address => uint256)) private _balances;
525 
526     // Mapping from account to operator approvals
527     mapping(address => mapping(address => bool)) private _operatorApprovals;
528 
529     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
530     string private _uri;
531 
532     /**
533      * @dev See {_setURI}.
534      */
535     constructor(string memory uri_) {
536         _setURI(uri_);
537     }
538 
539     /**
540      * @dev See {IERC165-supportsInterface}.
541      */
542     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
543         return
544             interfaceId == type(IERC1155).interfaceId ||
545             interfaceId == type(IERC1155MetadataURI).interfaceId ||
546             super.supportsInterface(interfaceId);
547     }
548 
549     /**
550      * @dev See {IERC1155MetadataURI-uri}.
551      *
552      * This implementation returns the same URI for *all* token types. It relies
553      * on the token type ID substitution mechanism
554      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
555      *
556      * Clients calling this function must replace the `\{id\}` substring with the
557      * actual token type ID.
558      */
559     function uri(uint256) public view virtual override returns (string memory) {
560         return _uri;
561     }
562 
563     /**
564      * @dev See {IERC1155-balanceOf}.
565      *
566      * Requirements:
567      *
568      * - `account` cannot be the zero address.
569      */
570     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
571         require(account != address(0), "ERC1155: balance query for the zero address");
572         return _balances[id][account];
573     }
574 
575     /**
576      * @dev See {IERC1155-balanceOfBatch}.
577      *
578      * Requirements:
579      *
580      * - `accounts` and `ids` must have the same length.
581      */
582     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
583         public
584         view
585         virtual
586         override
587         returns (uint256[] memory)
588     {
589         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
590 
591         uint256[] memory batchBalances = new uint256[](accounts.length);
592 
593         for (uint256 i = 0; i < accounts.length; ++i) {
594             batchBalances[i] = balanceOf(accounts[i], ids[i]);
595         }
596 
597         return batchBalances;
598     }
599 
600     /**
601      * @dev See {IERC1155-setApprovalForAll}.
602      */
603     function setApprovalForAll(address operator, bool approved) public virtual override {
604         require(_msgSender() != operator, "ERC1155: setting approval status for self");
605 
606         _operatorApprovals[_msgSender()][operator] = approved;
607         emit ApprovalForAll(_msgSender(), operator, approved);
608     }
609 
610     /**
611      * @dev See {IERC1155-isApprovedForAll}.
612      */
613     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
614         return _operatorApprovals[account][operator];
615     }
616 
617     /**
618      * @dev See {IERC1155-safeTransferFrom}.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 id,
624         uint256 amount,
625         bytes memory data
626     ) public virtual override {
627         require(
628             from == _msgSender() || isApprovedForAll(from, _msgSender()),
629             "ERC1155: caller is not owner nor approved"
630         );
631         _safeTransferFrom(from, to, id, amount, data);
632     }
633 
634     /**
635      * @dev See {IERC1155-safeBatchTransferFrom}.
636      */
637     function safeBatchTransferFrom(
638         address from,
639         address to,
640         uint256[] memory ids,
641         uint256[] memory amounts,
642         bytes memory data
643     ) public virtual override {
644         require(
645             from == _msgSender() || isApprovedForAll(from, _msgSender()),
646             "ERC1155: transfer caller is not owner nor approved"
647         );
648         _safeBatchTransferFrom(from, to, ids, amounts, data);
649     }
650 
651     /**
652      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
653      *
654      * Emits a {TransferSingle} event.
655      *
656      * Requirements:
657      *
658      * - `to` cannot be the zero address.
659      * - `from` must have a balance of tokens of type `id` of at least `amount`.
660      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
661      * acceptance magic value.
662      */
663     function _safeTransferFrom(
664         address from,
665         address to,
666         uint256 id,
667         uint256 amount,
668         bytes memory data
669     ) internal virtual {
670         require(to != address(0), "ERC1155: transfer to the zero address");
671 
672         address operator = _msgSender();
673 
674         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
675 
676         uint256 fromBalance = _balances[id][from];
677         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
678         unchecked {
679             _balances[id][from] = fromBalance - amount;
680         }
681         _balances[id][to] += amount;
682 
683         emit TransferSingle(operator, from, to, id, amount);
684 
685         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
686     }
687 
688     /**
689      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
690      *
691      * Emits a {TransferBatch} event.
692      *
693      * Requirements:
694      *
695      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
696      * acceptance magic value.
697      */
698     function _safeBatchTransferFrom(
699         address from,
700         address to,
701         uint256[] memory ids,
702         uint256[] memory amounts,
703         bytes memory data
704     ) internal virtual {
705         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
706         require(to != address(0), "ERC1155: transfer to the zero address");
707 
708         address operator = _msgSender();
709 
710         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
711 
712         for (uint256 i = 0; i < ids.length; ++i) {
713             uint256 id = ids[i];
714             uint256 amount = amounts[i];
715 
716             uint256 fromBalance = _balances[id][from];
717             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
718             unchecked {
719                 _balances[id][from] = fromBalance - amount;
720             }
721             _balances[id][to] += amount;
722         }
723 
724         emit TransferBatch(operator, from, to, ids, amounts);
725 
726         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
727     }
728 
729     /**
730      * @dev Sets a new URI for all token types, by relying on the token type ID
731      * substitution mechanism
732      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
733      *
734      * By this mechanism, any occurrence of the `\{id\}` substring in either the
735      * URI or any of the amounts in the JSON file at said URI will be replaced by
736      * clients with the token type ID.
737      *
738      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
739      * interpreted by clients as
740      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
741      * for token type ID 0x4cce0.
742      *
743      * See {uri}.
744      *
745      * Because these URIs cannot be meaningfully represented by the {URI} event,
746      * this function emits no events.
747      */
748     function _setURI(string memory newuri) internal virtual {
749         _uri = newuri;
750     }
751 
752     /**
753      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
754      *
755      * Emits a {TransferSingle} event.
756      *
757      * Requirements:
758      *
759      * - `account` cannot be the zero address.
760      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
761      * acceptance magic value.
762      */
763     function _mint(
764         address account,
765         uint256 id,
766         uint256 amount,
767         bytes memory data
768     ) internal virtual {
769         require(account != address(0), "ERC1155: mint to the zero address");
770 
771         address operator = _msgSender();
772 
773         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
774 
775         _balances[id][account] += amount;
776         emit TransferSingle(operator, address(0), account, id, amount);
777 
778         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
779     }
780 
781     /**
782      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
783      *
784      * Requirements:
785      *
786      * - `ids` and `amounts` must have the same length.
787      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
788      * acceptance magic value.
789      */
790     function _mintBatch(
791         address to,
792         uint256[] memory ids,
793         uint256[] memory amounts,
794         bytes memory data
795     ) internal virtual {
796         require(to != address(0), "ERC1155: mint to the zero address");
797         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
798 
799         address operator = _msgSender();
800 
801         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
802 
803         for (uint256 i = 0; i < ids.length; i++) {
804             _balances[ids[i]][to] += amounts[i];
805         }
806 
807         emit TransferBatch(operator, address(0), to, ids, amounts);
808 
809         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
810     }
811 
812     /**
813      * @dev Destroys `amount` tokens of token type `id` from `account`
814      *
815      * Requirements:
816      *
817      * - `account` cannot be the zero address.
818      * - `account` must have at least `amount` tokens of token type `id`.
819      */
820     function _burn(
821         address account,
822         uint256 id,
823         uint256 amount
824     ) internal virtual {
825         require(account != address(0), "ERC1155: burn from the zero address");
826 
827         address operator = _msgSender();
828 
829         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
830 
831         uint256 accountBalance = _balances[id][account];
832         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
833         unchecked {
834             _balances[id][account] = accountBalance - amount;
835         }
836 
837         emit TransferSingle(operator, account, address(0), id, amount);
838     }
839 
840     /**
841      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
842      *
843      * Requirements:
844      *
845      * - `ids` and `amounts` must have the same length.
846      */
847     function _burnBatch(
848         address account,
849         uint256[] memory ids,
850         uint256[] memory amounts
851     ) internal virtual {
852         require(account != address(0), "ERC1155: burn from the zero address");
853         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
854 
855         address operator = _msgSender();
856 
857         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
858 
859         for (uint256 i = 0; i < ids.length; i++) {
860             uint256 id = ids[i];
861             uint256 amount = amounts[i];
862 
863             uint256 accountBalance = _balances[id][account];
864             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
865             unchecked {
866                 _balances[id][account] = accountBalance - amount;
867             }
868         }
869 
870         emit TransferBatch(operator, account, address(0), ids, amounts);
871     }
872 
873     /**
874      * @dev Hook that is called before any token transfer. This includes minting
875      * and burning, as well as batched variants.
876      *
877      * The same hook is called on both single and batched variants. For single
878      * transfers, the length of the `id` and `amount` arrays will be 1.
879      *
880      * Calling conditions (for each `id` and `amount` pair):
881      *
882      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
883      * of token type `id` will be  transferred to `to`.
884      * - When `from` is zero, `amount` tokens of token type `id` will be minted
885      * for `to`.
886      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
887      * will be burned.
888      * - `from` and `to` are never both zero.
889      * - `ids` and `amounts` have the same, non-zero length.
890      *
891      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
892      */
893     function _beforeTokenTransfer(
894         address operator,
895         address from,
896         address to,
897         uint256[] memory ids,
898         uint256[] memory amounts,
899         bytes memory data
900     ) internal virtual {}
901 
902     function _doSafeTransferAcceptanceCheck(
903         address operator,
904         address from,
905         address to,
906         uint256 id,
907         uint256 amount,
908         bytes memory data
909     ) private {
910         if (to.isContract()) {
911             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
912                 if (response != IERC1155Receiver.onERC1155Received.selector) {
913                     revert("ERC1155: ERC1155Receiver rejected tokens");
914                 }
915             } catch Error(string memory reason) {
916                 revert(reason);
917             } catch {
918                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
919             }
920         }
921     }
922 
923     function _doSafeBatchTransferAcceptanceCheck(
924         address operator,
925         address from,
926         address to,
927         uint256[] memory ids,
928         uint256[] memory amounts,
929         bytes memory data
930     ) private {
931         if (to.isContract()) {
932             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
933                 bytes4 response
934             ) {
935                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
936                     revert("ERC1155: ERC1155Receiver rejected tokens");
937                 }
938             } catch Error(string memory reason) {
939                 revert(reason);
940             } catch {
941                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
942             }
943         }
944     }
945 
946     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
947         uint256[] memory array = new uint256[](1);
948         array[0] = element;
949 
950         return array;
951     }
952 }
953 
954 
955 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.3.2
956 
957 
958 pragma solidity ^0.8.0;
959 
960 /**
961  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
962  *
963  * These functions can be used to verify that a message was signed by the holder
964  * of the private keys of a given address.
965  */
966 library ECDSA {
967     enum RecoverError {
968         NoError,
969         InvalidSignature,
970         InvalidSignatureLength,
971         InvalidSignatureS,
972         InvalidSignatureV
973     }
974 
975     function _throwError(RecoverError error) private pure {
976         if (error == RecoverError.NoError) {
977             return; // no error: do nothing
978         } else if (error == RecoverError.InvalidSignature) {
979             revert("ECDSA: invalid signature");
980         } else if (error == RecoverError.InvalidSignatureLength) {
981             revert("ECDSA: invalid signature length");
982         } else if (error == RecoverError.InvalidSignatureS) {
983             revert("ECDSA: invalid signature 's' value");
984         } else if (error == RecoverError.InvalidSignatureV) {
985             revert("ECDSA: invalid signature 'v' value");
986         }
987     }
988 
989     /**
990      * @dev Returns the address that signed a hashed message (`hash`) with
991      * `signature` or error string. This address can then be used for verification purposes.
992      *
993      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
994      * this function rejects them by requiring the `s` value to be in the lower
995      * half order, and the `v` value to be either 27 or 28.
996      *
997      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
998      * verification to be secure: it is possible to craft signatures that
999      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1000      * this is by receiving a hash of the original message (which may otherwise
1001      * be too long), and then calling {toEthSignedMessageHash} on it.
1002      *
1003      * Documentation for signature generation:
1004      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1005      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1006      *
1007      * _Available since v4.3._
1008      */
1009     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1010         // Check the signature length
1011         // - case 65: r,s,v signature (standard)
1012         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1013         if (signature.length == 65) {
1014             bytes32 r;
1015             bytes32 s;
1016             uint8 v;
1017             // ecrecover takes the signature parameters, and the only way to get them
1018             // currently is to use assembly.
1019             assembly {
1020                 r := mload(add(signature, 0x20))
1021                 s := mload(add(signature, 0x40))
1022                 v := byte(0, mload(add(signature, 0x60)))
1023             }
1024             return tryRecover(hash, v, r, s);
1025         } else if (signature.length == 64) {
1026             bytes32 r;
1027             bytes32 vs;
1028             // ecrecover takes the signature parameters, and the only way to get them
1029             // currently is to use assembly.
1030             assembly {
1031                 r := mload(add(signature, 0x20))
1032                 vs := mload(add(signature, 0x40))
1033             }
1034             return tryRecover(hash, r, vs);
1035         } else {
1036             return (address(0), RecoverError.InvalidSignatureLength);
1037         }
1038     }
1039 
1040     /**
1041      * @dev Returns the address that signed a hashed message (`hash`) with
1042      * `signature`. This address can then be used for verification purposes.
1043      *
1044      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1045      * this function rejects them by requiring the `s` value to be in the lower
1046      * half order, and the `v` value to be either 27 or 28.
1047      *
1048      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1049      * verification to be secure: it is possible to craft signatures that
1050      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1051      * this is by receiving a hash of the original message (which may otherwise
1052      * be too long), and then calling {toEthSignedMessageHash} on it.
1053      */
1054     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1055         (address recovered, RecoverError error) = tryRecover(hash, signature);
1056         _throwError(error);
1057         return recovered;
1058     }
1059 
1060     /**
1061      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1062      *
1063      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1064      *
1065      * _Available since v4.3._
1066      */
1067     function tryRecover(
1068         bytes32 hash,
1069         bytes32 r,
1070         bytes32 vs
1071     ) internal pure returns (address, RecoverError) {
1072         bytes32 s;
1073         uint8 v;
1074         assembly {
1075             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1076             v := add(shr(255, vs), 27)
1077         }
1078         return tryRecover(hash, v, r, s);
1079     }
1080 
1081     /**
1082      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1083      *
1084      * _Available since v4.2._
1085      */
1086     function recover(
1087         bytes32 hash,
1088         bytes32 r,
1089         bytes32 vs
1090     ) internal pure returns (address) {
1091         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1092         _throwError(error);
1093         return recovered;
1094     }
1095 
1096     /**
1097      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1098      * `r` and `s` signature fields separately.
1099      *
1100      * _Available since v4.3._
1101      */
1102     function tryRecover(
1103         bytes32 hash,
1104         uint8 v,
1105         bytes32 r,
1106         bytes32 s
1107     ) internal pure returns (address, RecoverError) {
1108         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1109         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1110         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1111         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1112         //
1113         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1114         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1115         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1116         // these malleable signatures as well.
1117         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1118             return (address(0), RecoverError.InvalidSignatureS);
1119         }
1120         if (v != 27 && v != 28) {
1121             return (address(0), RecoverError.InvalidSignatureV);
1122         }
1123 
1124         // If the signature is valid (and not malleable), return the signer address
1125         address signer = ecrecover(hash, v, r, s);
1126         if (signer == address(0)) {
1127             return (address(0), RecoverError.InvalidSignature);
1128         }
1129 
1130         return (signer, RecoverError.NoError);
1131     }
1132 
1133     /**
1134      * @dev Overload of {ECDSA-recover} that receives the `v`,
1135      * `r` and `s` signature fields separately.
1136      */
1137     function recover(
1138         bytes32 hash,
1139         uint8 v,
1140         bytes32 r,
1141         bytes32 s
1142     ) internal pure returns (address) {
1143         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1144         _throwError(error);
1145         return recovered;
1146     }
1147 
1148     /**
1149      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1150      * produces hash corresponding to the one signed with the
1151      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1152      * JSON-RPC method as part of EIP-191.
1153      *
1154      * See {recover}.
1155      */
1156     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1157         // 32 is the length in bytes of hash,
1158         // enforced by the type signature above
1159         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1160     }
1161 
1162     /**
1163      * @dev Returns an Ethereum Signed Typed Data, created from a
1164      * `domainSeparator` and a `structHash`. This produces hash corresponding
1165      * to the one signed with the
1166      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1167      * JSON-RPC method as part of EIP-712.
1168      *
1169      * See {recover}.
1170      */
1171     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1172         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1173     }
1174 }
1175 
1176 
1177 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1178 
1179 
1180 pragma solidity ^0.8.0;
1181 
1182 /**
1183  * @dev Contract module which provides a basic access control mechanism, where
1184  * there is an account (an owner) that can be granted exclusive access to
1185  * specific functions.
1186  *
1187  * By default, the owner account will be the one that deploys the contract. This
1188  * can later be changed with {transferOwnership}.
1189  *
1190  * This module is used through inheritance. It will make available the modifier
1191  * `onlyOwner`, which can be applied to your functions to restrict their use to
1192  * the owner.
1193  */
1194 abstract contract Ownable is Context {
1195     address private _owner;
1196 
1197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1198 
1199     /**
1200      * @dev Initializes the contract setting the deployer as the initial owner.
1201      */
1202     constructor() {
1203         _setOwner(_msgSender());
1204     }
1205 
1206     /**
1207      * @dev Returns the address of the current owner.
1208      */
1209     function owner() public view virtual returns (address) {
1210         return _owner;
1211     }
1212 
1213     /**
1214      * @dev Throws if called by any account other than the owner.
1215      */
1216     modifier onlyOwner() {
1217         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1218         _;
1219     }
1220 
1221     /**
1222      * @dev Leaves the contract without owner. It will not be possible to call
1223      * `onlyOwner` functions anymore. Can only be called by the current owner.
1224      *
1225      * NOTE: Renouncing ownership will leave the contract without an owner,
1226      * thereby removing any functionality that is only available to the owner.
1227      */
1228     function renounceOwnership() public virtual onlyOwner {
1229         _setOwner(address(0));
1230     }
1231 
1232     /**
1233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1234      * Can only be called by the current owner.
1235      */
1236     function transferOwnership(address newOwner) public virtual onlyOwner {
1237         require(newOwner != address(0), "Ownable: new owner is the zero address");
1238         _setOwner(newOwner);
1239     }
1240 
1241     function _setOwner(address newOwner) private {
1242         address oldOwner = _owner;
1243         _owner = newOwner;
1244         emit OwnershipTransferred(oldOwner, newOwner);
1245     }
1246 }
1247 
1248 
1249 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.2
1250 
1251 
1252 pragma solidity ^0.8.0;
1253 
1254 /**
1255  * @dev Contract module that helps prevent reentrant calls to a function.
1256  *
1257  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1258  * available, which can be applied to functions to make sure there are no nested
1259  * (reentrant) calls to them.
1260  *
1261  * Note that because there is a single `nonReentrant` guard, functions marked as
1262  * `nonReentrant` may not call one another. This can be worked around by making
1263  * those functions `private`, and then adding `external` `nonReentrant` entry
1264  * points to them.
1265  *
1266  * TIP: If you would like to learn more about reentrancy and alternative ways
1267  * to protect against it, check out our blog post
1268  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1269  */
1270 abstract contract ReentrancyGuard {
1271     // Booleans are more expensive than uint256 or any type that takes up a full
1272     // word because each write operation emits an extra SLOAD to first read the
1273     // slot's contents, replace the bits taken up by the boolean, and then write
1274     // back. This is the compiler's defense against contract upgrades and
1275     // pointer aliasing, and it cannot be disabled.
1276 
1277     // The values being non-zero value makes deployment a bit more expensive,
1278     // but in exchange the refund on every call to nonReentrant will be lower in
1279     // amount. Since refunds are capped to a percentage of the total
1280     // transaction's gas, it is best to keep them low in cases like this one, to
1281     // increase the likelihood of the full refund coming into effect.
1282     uint256 private constant _NOT_ENTERED = 1;
1283     uint256 private constant _ENTERED = 2;
1284 
1285     uint256 private _status;
1286 
1287     constructor() {
1288         _status = _NOT_ENTERED;
1289     }
1290 
1291     /**
1292      * @dev Prevents a contract from calling itself, directly or indirectly.
1293      * Calling a `nonReentrant` function from another `nonReentrant`
1294      * function is not supported. It is possible to prevent this from happening
1295      * by making the `nonReentrant` function external, and make it call a
1296      * `private` function that does the actual work.
1297      */
1298     modifier nonReentrant() {
1299         // On the first call to nonReentrant, _notEntered will be true
1300         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1301 
1302         // Any calls to nonReentrant after this point will fail
1303         _status = _ENTERED;
1304 
1305         _;
1306 
1307         // By storing the original value once again, a refund is triggered (see
1308         // https://eips.ethereum.org/EIPS/eip-2200)
1309         _status = _NOT_ENTERED;
1310     }
1311 }
1312 
1313 
1314 // File contracts/JKKeyCard.sol
1315 
1316 // SPDX-License-Identifier: MIT
1317 /*
1318        _ _  __  _  __________     _______          _____  _____
1319       | | |/ / | |/ /  ____\ \   / / ____|   /\   |  __ \|  __ \
1320       | | ' /  | ' /| |__   \ \_/ / |       /  \  | |__) | |  | |
1321   _   | |  <   |  < |  __|   \   /| |      / /\ \ |  _  /| |  | |
1322  | |__| | . \  | . \| |____   | | | |____ / ____ \| | \ \| |__| |
1323   \____/|_|\_\ |_|\_\______|  |_|  \_____/_/    \_\_|  \_\_____/
1324 
1325 Join us https://discord.gg/796KVFSf
1326 */
1327 
1328 pragma solidity ^0.8.7;
1329 
1330 
1331 
1332 
1333 contract JKKeyCard is ReentrancyGuard, ERC1155, Ownable {
1334 
1335     uint256 public constant MAX_KEY_CARDS = 4500;
1336     uint256 public constant MINT_PRICE = 0.05 ether;
1337     uint256 public constant GIVEAWAY = 50;
1338     uint256 public maxPerAddress = 5;
1339     uint256 public mintCount;
1340 
1341     mapping(bytes32 => bool) private _usedHashes;
1342 
1343     bool public saleStarted = false;
1344     bool public presaleStarted = false;
1345     uint256 constant private _tokenId = 1;
1346     address private _signerAddress;
1347 
1348     constructor() ERC1155("https://ipfs.io/ipfs/QmYbWYv48DWGh5mTGUDo9i5EtZySpTVPv4nJ72A2B5vSuK?filename=jk_metadata%20copy.json") {
1349 
1350         // Mint 50 for giveaways
1351         mintCount = GIVEAWAY;
1352         _mint(msg.sender, _tokenId, GIVEAWAY, "");
1353     }
1354 
1355     // Preasale Mint Key Card
1356     function presaleMint(
1357         uint256 _count,
1358         bytes32 _hash,
1359         bytes memory _sig)
1360         external payable nonReentrant
1361     {
1362         require(presaleStarted, "Presale not started");
1363         require(tx.origin == msg.sender, "Prevent contract call");
1364         require((balanceOf(msg.sender, _tokenId) + _count) <= maxPerAddress, "Max Per Address reached");
1365         require(_count > 0 && msg.value == _count * MINT_PRICE, "invalid eth sent");
1366         require(matchHash(msg.sender, _count, _hash), "invalid hash");
1367         require(matchSigner(_hash, _sig), "invalid signer");
1368         require(!_usedHashes[_hash], "_hash already used");
1369         require(mintCount + _count <= MAX_KEY_CARDS, "max key cards");
1370 
1371         _usedHashes[_hash] = true;
1372         mintCount += _count;
1373         _mint(msg.sender, _tokenId, _count, "");
1374     }
1375 
1376     function publicMint(uint256 _count) external payable nonReentrant {
1377         require(saleStarted, "Public sale not started");
1378         require(tx.origin == msg.sender, "Prevent contract call");
1379         require((balanceOf(msg.sender, _tokenId) + _count) <= maxPerAddress, "Max Per Address reached");
1380         require(_count > 0 && msg.value == _count * MINT_PRICE, "invalid eth sent");
1381         require(mintCount + _count <= MAX_KEY_CARDS, "max key cards");
1382 
1383         mintCount += _count;
1384         _mint(msg.sender, _tokenId, _count, "");
1385     }
1386 
1387     function matchSigner(bytes32 _hash, bytes memory _signature) private view returns(bool) {
1388         return _signerAddress == ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
1389     }
1390 
1391     function matchHash(address _sender, uint256 _count, bytes32 _hash) private pure returns(bool) {
1392         bytes32 h = keccak256(abi.encode(_sender, _count));
1393         return h == _hash;
1394     }
1395 
1396     function checkWhitelist(
1397         address _sender,
1398         uint256 _count,
1399         bytes32 _hash,
1400         bytes memory _sig
1401     ) public view returns(bool) {
1402         return matchHash(_sender, _count, _hash) && matchSigner(_hash, _sig);
1403     }
1404 
1405     // ** Admin Fuctions ** //
1406     function setURI(string memory newuri) external onlyOwner {
1407         _setURI(newuri);
1408     }
1409 
1410     function withdraw(address payable _to) external onlyOwner {
1411         require(_to != address(0), "cannot withdraw to address(0)");
1412         require(address(this).balance > 0, "empty balance");
1413         _to.transfer(address(this).balance);
1414     }
1415 
1416     function setSaleStarted(bool _hasStarted) external onlyOwner {
1417         require(saleStarted != _hasStarted, "saleStarted already set");
1418         saleStarted = _hasStarted;
1419     }
1420 
1421     function setPresaleStarted(bool _hasStarted) external onlyOwner {
1422         require(presaleStarted != _hasStarted, "presaleStarted already set");
1423         presaleStarted= _hasStarted;
1424     }
1425 
1426     function setSignerAddress(address _signer) external onlyOwner {
1427         require(_signer != address(0), "signer address null");
1428         _signerAddress = _signer;
1429     }
1430 
1431     function setMaxPerAddress(uint256 _max) external onlyOwner {
1432         require(_max > 0, "max cannot be null");
1433         maxPerAddress = _max;
1434     }
1435 }