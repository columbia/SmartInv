1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // This method relies on extcodesize, which returns 0 for contracts in
30         // construction, since the code is only stored at the end of the
31         // constructor execution.
32 
33         uint256 size;
34         assembly {
35             size := extcodesize(account)
36         }
37         return size > 0;
38     }
39 
40     /**
41      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
42      * `recipient`, forwarding all available gas and reverting on errors.
43      *
44      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
45      * of certain opcodes, possibly making contracts go over the 2300 gas limit
46      * imposed by `transfer`, making them unable to receive funds via
47      * `transfer`. {sendValue} removes this limitation.
48      *
49      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
50      *
51      * IMPORTANT: because control is transferred to `recipient`, care must be
52      * taken to not create reentrancy vulnerabilities. Consider using
53      * {ReentrancyGuard} or the
54      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
55      */
56     function sendValue(address payable recipient, uint256 amount) internal {
57         require(address(this).balance >= amount, "Address: insufficient balance");
58 
59         (bool success, ) = recipient.call{value: amount}("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain `call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82         return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(
92         address target,
93         bytes memory data,
94         string memory errorMessage
95     ) internal returns (bytes memory) {
96         return functionCallWithValue(target, data, 0, errorMessage);
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
101      * but also transferring `value` wei to `target`.
102      *
103      * Requirements:
104      *
105      * - the calling contract must have an ETH balance of at least `value`.
106      * - the called Solidity function must be `payable`.
107      *
108      * _Available since v3.1._
109      */
110     function functionCallWithValue(
111         address target,
112         bytes memory data,
113         uint256 value
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
120      * with `errorMessage` as a fallback revert reason when `target` reverts.
121      *
122      * _Available since v3.1._
123      */
124     function functionCallWithValue(
125         address target,
126         bytes memory data,
127         uint256 value,
128         string memory errorMessage
129     ) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         require(isContract(target), "Address: call to non-contract");
132 
133         (bool success, bytes memory returndata) = target.call{value: value}(data);
134         return verifyCallResult(success, returndata, errorMessage);
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
144         return functionStaticCall(target, data, "Address: low-level static call failed");
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
149      * but performing a static call.
150      *
151      * _Available since v3.3._
152      */
153     function functionStaticCall(
154         address target,
155         bytes memory data,
156         string memory errorMessage
157     ) internal view returns (bytes memory) {
158         require(isContract(target), "Address: static call to non-contract");
159 
160         (bool success, bytes memory returndata) = target.staticcall(data);
161         return verifyCallResult(success, returndata, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but performing a delegate call.
167      *
168      * _Available since v3.4._
169      */
170     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
171         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
176      * but performing a delegate call.
177      *
178      * _Available since v3.4._
179      */
180     function functionDelegateCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         require(isContract(target), "Address: delegate call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.delegatecall(data);
188         return verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     /**
192      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
193      * revert reason using the provided one.
194      *
195      * _Available since v4.3._
196      */
197     function verifyCallResult(
198         bool success,
199         bytes memory returndata,
200         string memory errorMessage
201     ) internal pure returns (bytes memory) {
202         if (success) {
203             return returndata;
204         } else {
205             // Look for revert reason and bubble it up if present
206             if (returndata.length > 0) {
207                 // The easiest way to bubble the revert reason is using memory via assembly
208 
209                 assembly {
210                     let returndata_size := mload(returndata)
211                     revert(add(32, returndata), returndata_size)
212                 }
213             } else {
214                 revert(errorMessage);
215             }
216         }
217     }
218 }
219 
220 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
221 
222 
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev Interface of the ERC165 standard, as defined in the
228  * https://eips.ethereum.org/EIPS/eip-165[EIP].
229  *
230  * Implementers can declare support of contract interfaces, which can then be
231  * queried by others ({ERC165Checker}).
232  *
233  * For an implementation, see {ERC165}.
234  */
235 interface IERC165 {
236     /**
237      * @dev Returns true if this contract implements the interface defined by
238      * `interfaceId`. See the corresponding
239      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
240      * to learn more about how these ids are created.
241      *
242      * This function call must use less than 30 000 gas.
243      */
244     function supportsInterface(bytes4 interfaceId) external view returns (bool);
245 }
246 
247 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
248 
249 
250 
251 pragma solidity ^0.8.0;
252 
253 
254 /**
255  * @dev Implementation of the {IERC165} interface.
256  *
257  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
258  * for the additional interface id that will be supported. For example:
259  *
260  * ```solidity
261  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
262  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
263  * }
264  * ```
265  *
266  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
267  */
268 abstract contract ERC165 is IERC165 {
269     /**
270      * @dev See {IERC165-supportsInterface}.
271      */
272     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
273         return interfaceId == type(IERC165).interfaceId;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
278 
279 
280 
281 pragma solidity ^0.8.0;
282 
283 
284 /**
285  * @dev _Available since v3.1._
286  */
287 interface IERC1155Receiver is IERC165 {
288     /**
289         @dev Handles the receipt of a single ERC1155 token type. This function is
290         called at the end of a `safeTransferFrom` after the balance has been updated.
291         To accept the transfer, this must return
292         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
293         (i.e. 0xf23a6e61, or its own function selector).
294         @param operator The address which initiated the transfer (i.e. msg.sender)
295         @param from The address which previously owned the token
296         @param id The ID of the token being transferred
297         @param value The amount of tokens being transferred
298         @param data Additional data with no specified format
299         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
300     */
301     function onERC1155Received(
302         address operator,
303         address from,
304         uint256 id,
305         uint256 value,
306         bytes calldata data
307     ) external returns (bytes4);
308 
309     /**
310         @dev Handles the receipt of a multiple ERC1155 token types. This function
311         is called at the end of a `safeBatchTransferFrom` after the balances have
312         been updated. To accept the transfer(s), this must return
313         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
314         (i.e. 0xbc197c81, or its own function selector).
315         @param operator The address which initiated the batch transfer (i.e. msg.sender)
316         @param from The address which previously owned the token
317         @param ids An array containing ids of each token being transferred (order and length must match values array)
318         @param values An array containing amounts of each token being transferred (order and length must match ids array)
319         @param data Additional data with no specified format
320         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
321     */
322     function onERC1155BatchReceived(
323         address operator,
324         address from,
325         uint256[] calldata ids,
326         uint256[] calldata values,
327         bytes calldata data
328     ) external returns (bytes4);
329 }
330 
331 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
332 
333 
334 
335 pragma solidity ^0.8.0;
336 
337 
338 /**
339  * @dev Required interface of an ERC1155 compliant contract, as defined in the
340  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
341  *
342  * _Available since v3.1._
343  */
344 interface IERC1155 is IERC165 {
345     /**
346      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
347      */
348     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
349 
350     /**
351      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
352      * transfers.
353      */
354     event TransferBatch(
355         address indexed operator,
356         address indexed from,
357         address indexed to,
358         uint256[] ids,
359         uint256[] values
360     );
361 
362     /**
363      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
364      * `approved`.
365      */
366     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
367 
368     /**
369      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
370      *
371      * If an {URI} event was emitted for `id`, the standard
372      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
373      * returned by {IERC1155MetadataURI-uri}.
374      */
375     event URI(string value, uint256 indexed id);
376 
377     /**
378      * @dev Returns the amount of tokens of token type `id` owned by `account`.
379      *
380      * Requirements:
381      *
382      * - `account` cannot be the zero address.
383      */
384     function balanceOf(address account, uint256 id) external view returns (uint256);
385 
386     /**
387      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
388      *
389      * Requirements:
390      *
391      * - `accounts` and `ids` must have the same length.
392      */
393     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
394         external
395         view
396         returns (uint256[] memory);
397 
398     /**
399      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
400      *
401      * Emits an {ApprovalForAll} event.
402      *
403      * Requirements:
404      *
405      * - `operator` cannot be the caller.
406      */
407     function setApprovalForAll(address operator, bool approved) external;
408 
409     /**
410      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
411      *
412      * See {setApprovalForAll}.
413      */
414     function isApprovedForAll(address account, address operator) external view returns (bool);
415 
416     /**
417      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
418      *
419      * Emits a {TransferSingle} event.
420      *
421      * Requirements:
422      *
423      * - `to` cannot be the zero address.
424      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
425      * - `from` must have a balance of tokens of type `id` of at least `amount`.
426      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
427      * acceptance magic value.
428      */
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 id,
433         uint256 amount,
434         bytes calldata data
435     ) external;
436 
437     /**
438      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
439      *
440      * Emits a {TransferBatch} event.
441      *
442      * Requirements:
443      *
444      * - `ids` and `amounts` must have the same length.
445      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
446      * acceptance magic value.
447      */
448     function safeBatchTransferFrom(
449         address from,
450         address to,
451         uint256[] calldata ids,
452         uint256[] calldata amounts,
453         bytes calldata data
454     ) external;
455 }
456 
457 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
458 
459 
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
466  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
467  *
468  * _Available since v3.1._
469  */
470 interface IERC1155MetadataURI is IERC1155 {
471     /**
472      * @dev Returns the URI for token type `id`.
473      *
474      * If the `\{id\}` substring is present in the URI, it must be replaced by
475      * clients with the actual token type ID.
476      */
477     function uri(uint256 id) external view returns (string memory);
478 }
479 
480 // File: @openzeppelin/contracts/utils/Context.sol
481 
482 
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @dev Provides information about the current execution context, including the
488  * sender of the transaction and its data. While these are generally available
489  * via msg.sender and msg.data, they should not be accessed in such a direct
490  * manner, since when dealing with meta-transactions the account sending and
491  * paying for execution may not be the actual sender (as far as an application
492  * is concerned).
493  *
494  * This contract is only required for intermediate, library-like contracts.
495  */
496 abstract contract Context {
497     function _msgSender() internal view virtual returns (address) {
498         return msg.sender;
499     }
500 
501     function _msgData() internal view virtual returns (bytes calldata) {
502         return msg.data;
503     }
504 }
505 
506 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
507 
508 
509 
510 pragma solidity ^0.8.0;
511 
512 
513 
514 
515 
516 
517 
518 /**
519  * @dev Implementation of the basic standard multi-token.
520  * See https://eips.ethereum.org/EIPS/eip-1155
521  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
522  *
523  * _Available since v3.1._
524  */
525 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
526     using Address for address;
527 
528     // Mapping from token ID to account balances
529     mapping(uint256 => mapping(address => uint256)) private _balances;
530 
531     // Mapping from account to operator approvals
532     mapping(address => mapping(address => bool)) private _operatorApprovals;
533 
534     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
535     string private _uri;
536 
537     /**
538      * @dev See {_setURI}.
539      */
540     constructor(string memory uri_) {
541         _setURI(uri_);
542     }
543 
544     /**
545      * @dev See {IERC165-supportsInterface}.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
548         return
549             interfaceId == type(IERC1155).interfaceId ||
550             interfaceId == type(IERC1155MetadataURI).interfaceId ||
551             super.supportsInterface(interfaceId);
552     }
553 
554     /**
555      * @dev See {IERC1155MetadataURI-uri}.
556      *
557      * This implementation returns the same URI for *all* token types. It relies
558      * on the token type ID substitution mechanism
559      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
560      *
561      * Clients calling this function must replace the `\{id\}` substring with the
562      * actual token type ID.
563      */
564     function uri(uint256) public view virtual override returns (string memory) {
565         return _uri;
566     }
567 
568     /**
569      * @dev See {IERC1155-balanceOf}.
570      *
571      * Requirements:
572      *
573      * - `account` cannot be the zero address.
574      */
575     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
576         require(account != address(0), "ERC1155: balance query for the zero address");
577         return _balances[id][account];
578     }
579 
580     /**
581      * @dev See {IERC1155-balanceOfBatch}.
582      *
583      * Requirements:
584      *
585      * - `accounts` and `ids` must have the same length.
586      */
587     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
588         public
589         view
590         virtual
591         override
592         returns (uint256[] memory)
593     {
594         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
595 
596         uint256[] memory batchBalances = new uint256[](accounts.length);
597 
598         for (uint256 i = 0; i < accounts.length; ++i) {
599             batchBalances[i] = balanceOf(accounts[i], ids[i]);
600         }
601 
602         return batchBalances;
603     }
604 
605     /**
606      * @dev See {IERC1155-setApprovalForAll}.
607      */
608     function setApprovalForAll(address operator, bool approved) public virtual override {
609         require(_msgSender() != operator, "ERC1155: setting approval status for self");
610 
611         _operatorApprovals[_msgSender()][operator] = approved;
612         emit ApprovalForAll(_msgSender(), operator, approved);
613     }
614 
615     /**
616      * @dev See {IERC1155-isApprovedForAll}.
617      */
618     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
619         return _operatorApprovals[account][operator];
620     }
621 
622     /**
623      * @dev See {IERC1155-safeTransferFrom}.
624      */
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 id,
629         uint256 amount,
630         bytes memory data
631     ) public virtual override {
632         require(
633             from == _msgSender() || isApprovedForAll(from, _msgSender()),
634             "ERC1155: caller is not owner nor approved"
635         );
636         _safeTransferFrom(from, to, id, amount, data);
637     }
638 
639     /**
640      * @dev See {IERC1155-safeBatchTransferFrom}.
641      */
642     function safeBatchTransferFrom(
643         address from,
644         address to,
645         uint256[] memory ids,
646         uint256[] memory amounts,
647         bytes memory data
648     ) public virtual override {
649         require(
650             from == _msgSender() || isApprovedForAll(from, _msgSender()),
651             "ERC1155: transfer caller is not owner nor approved"
652         );
653         _safeBatchTransferFrom(from, to, ids, amounts, data);
654     }
655 
656     /**
657      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
658      *
659      * Emits a {TransferSingle} event.
660      *
661      * Requirements:
662      *
663      * - `to` cannot be the zero address.
664      * - `from` must have a balance of tokens of type `id` of at least `amount`.
665      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
666      * acceptance magic value.
667      */
668     function _safeTransferFrom(
669         address from,
670         address to,
671         uint256 id,
672         uint256 amount,
673         bytes memory data
674     ) internal virtual {
675         require(to != address(0), "ERC1155: transfer to the zero address");
676 
677         address operator = _msgSender();
678 
679         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
680 
681         uint256 fromBalance = _balances[id][from];
682         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
683         unchecked {
684             _balances[id][from] = fromBalance - amount;
685         }
686         _balances[id][to] += amount;
687 
688         emit TransferSingle(operator, from, to, id, amount);
689 
690         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
691     }
692 
693     /**
694      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
695      *
696      * Emits a {TransferBatch} event.
697      *
698      * Requirements:
699      *
700      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
701      * acceptance magic value.
702      */
703     function _safeBatchTransferFrom(
704         address from,
705         address to,
706         uint256[] memory ids,
707         uint256[] memory amounts,
708         bytes memory data
709     ) internal virtual {
710         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
711         require(to != address(0), "ERC1155: transfer to the zero address");
712 
713         address operator = _msgSender();
714 
715         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
716 
717         for (uint256 i = 0; i < ids.length; ++i) {
718             uint256 id = ids[i];
719             uint256 amount = amounts[i];
720 
721             uint256 fromBalance = _balances[id][from];
722             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
723             unchecked {
724                 _balances[id][from] = fromBalance - amount;
725             }
726             _balances[id][to] += amount;
727         }
728 
729         emit TransferBatch(operator, from, to, ids, amounts);
730 
731         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
732     }
733 
734     /**
735      * @dev Sets a new URI for all token types, by relying on the token type ID
736      * substitution mechanism
737      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
738      *
739      * By this mechanism, any occurrence of the `\{id\}` substring in either the
740      * URI or any of the amounts in the JSON file at said URI will be replaced by
741      * clients with the token type ID.
742      *
743      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
744      * interpreted by clients as
745      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
746      * for token type ID 0x4cce0.
747      *
748      * See {uri}.
749      *
750      * Because these URIs cannot be meaningfully represented by the {URI} event,
751      * this function emits no events.
752      */
753     function _setURI(string memory newuri) internal virtual {
754         _uri = newuri;
755     }
756 
757     /**
758      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
759      *
760      * Emits a {TransferSingle} event.
761      *
762      * Requirements:
763      *
764      * - `account` cannot be the zero address.
765      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
766      * acceptance magic value.
767      */
768     function _mint(
769         address account,
770         uint256 id,
771         uint256 amount,
772         bytes memory data
773     ) internal virtual {
774         require(account != address(0), "ERC1155: mint to the zero address");
775 
776         address operator = _msgSender();
777 
778         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
779 
780         _balances[id][account] += amount;
781         emit TransferSingle(operator, address(0), account, id, amount);
782 
783         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
784     }
785 
786     /**
787      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
788      *
789      * Requirements:
790      *
791      * - `ids` and `amounts` must have the same length.
792      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
793      * acceptance magic value.
794      */
795     function _mintBatch(
796         address to,
797         uint256[] memory ids,
798         uint256[] memory amounts,
799         bytes memory data
800     ) internal virtual {
801         require(to != address(0), "ERC1155: mint to the zero address");
802         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
803 
804         address operator = _msgSender();
805 
806         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
807 
808         for (uint256 i = 0; i < ids.length; i++) {
809             _balances[ids[i]][to] += amounts[i];
810         }
811 
812         emit TransferBatch(operator, address(0), to, ids, amounts);
813 
814         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
815     }
816 
817     /**
818      * @dev Destroys `amount` tokens of token type `id` from `account`
819      *
820      * Requirements:
821      *
822      * - `account` cannot be the zero address.
823      * - `account` must have at least `amount` tokens of token type `id`.
824      */
825     function _burn(
826         address account,
827         uint256 id,
828         uint256 amount
829     ) internal virtual {
830         require(account != address(0), "ERC1155: burn from the zero address");
831 
832         address operator = _msgSender();
833 
834         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
835 
836         uint256 accountBalance = _balances[id][account];
837         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
838         unchecked {
839             _balances[id][account] = accountBalance - amount;
840         }
841 
842         emit TransferSingle(operator, account, address(0), id, amount);
843     }
844 
845     /**
846      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
847      *
848      * Requirements:
849      *
850      * - `ids` and `amounts` must have the same length.
851      */
852     function _burnBatch(
853         address account,
854         uint256[] memory ids,
855         uint256[] memory amounts
856     ) internal virtual {
857         require(account != address(0), "ERC1155: burn from the zero address");
858         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
859 
860         address operator = _msgSender();
861 
862         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
863 
864         for (uint256 i = 0; i < ids.length; i++) {
865             uint256 id = ids[i];
866             uint256 amount = amounts[i];
867 
868             uint256 accountBalance = _balances[id][account];
869             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
870             unchecked {
871                 _balances[id][account] = accountBalance - amount;
872             }
873         }
874 
875         emit TransferBatch(operator, account, address(0), ids, amounts);
876     }
877 
878     /**
879      * @dev Hook that is called before any token transfer. This includes minting
880      * and burning, as well as batched variants.
881      *
882      * The same hook is called on both single and batched variants. For single
883      * transfers, the length of the `id` and `amount` arrays will be 1.
884      *
885      * Calling conditions (for each `id` and `amount` pair):
886      *
887      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
888      * of token type `id` will be  transferred to `to`.
889      * - When `from` is zero, `amount` tokens of token type `id` will be minted
890      * for `to`.
891      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
892      * will be burned.
893      * - `from` and `to` are never both zero.
894      * - `ids` and `amounts` have the same, non-zero length.
895      *
896      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
897      */
898     function _beforeTokenTransfer(
899         address operator,
900         address from,
901         address to,
902         uint256[] memory ids,
903         uint256[] memory amounts,
904         bytes memory data
905     ) internal virtual {}
906 
907     function _doSafeTransferAcceptanceCheck(
908         address operator,
909         address from,
910         address to,
911         uint256 id,
912         uint256 amount,
913         bytes memory data
914     ) private {
915         if (to.isContract()) {
916             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
917                 if (response != IERC1155Receiver.onERC1155Received.selector) {
918                     revert("ERC1155: ERC1155Receiver rejected tokens");
919                 }
920             } catch Error(string memory reason) {
921                 revert(reason);
922             } catch {
923                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
924             }
925         }
926     }
927 
928     function _doSafeBatchTransferAcceptanceCheck(
929         address operator,
930         address from,
931         address to,
932         uint256[] memory ids,
933         uint256[] memory amounts,
934         bytes memory data
935     ) private {
936         if (to.isContract()) {
937             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
938                 bytes4 response
939             ) {
940                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
941                     revert("ERC1155: ERC1155Receiver rejected tokens");
942                 }
943             } catch Error(string memory reason) {
944                 revert(reason);
945             } catch {
946                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
947             }
948         }
949     }
950 
951     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
952         uint256[] memory array = new uint256[](1);
953         array[0] = element;
954 
955         return array;
956     }
957 }
958 
959 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
960 
961 
962 
963 pragma solidity ^0.8.0;
964 
965 
966 /**
967  * @dev Extension of ERC1155 that adds tracking of total supply per id.
968  *
969  * Useful for scenarios where Fungible and Non-fungible tokens have to be
970  * clearly identified. Note: While a totalSupply of 1 might mean the
971  * corresponding is an NFT, there is no guarantees that no other token with the
972  * same id are not going to be minted.
973  */
974 abstract contract ERC1155Supply is ERC1155 {
975     mapping(uint256 => uint256) private _totalSupply;
976 
977     /**
978      * @dev Total amount of tokens in with a given id.
979      */
980     function totalSupply(uint256 id) public view virtual returns (uint256) {
981         return _totalSupply[id];
982     }
983 
984     /**
985      * @dev Indicates weither any token exist with a given id, or not.
986      */
987     function exists(uint256 id) public view virtual returns (bool) {
988         return ERC1155Supply.totalSupply(id) > 0;
989     }
990 
991     /**
992      * @dev See {ERC1155-_beforeTokenTransfer}.
993      */
994     function _beforeTokenTransfer(
995         address operator,
996         address from,
997         address to,
998         uint256[] memory ids,
999         uint256[] memory amounts,
1000         bytes memory data
1001     ) internal virtual override {
1002         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1003 
1004         if (from == address(0)) {
1005             for (uint256 i = 0; i < ids.length; ++i) {
1006                 _totalSupply[ids[i]] += amounts[i];
1007             }
1008         }
1009 
1010         if (to == address(0)) {
1011             for (uint256 i = 0; i < ids.length; ++i) {
1012                 _totalSupply[ids[i]] -= amounts[i];
1013             }
1014         }
1015     }
1016 }
1017 
1018 // File: @openzeppelin/contracts/access/Ownable.sol
1019 
1020 
1021 
1022 pragma solidity ^0.8.0;
1023 
1024 
1025 /**
1026  * @dev Contract module which provides a basic access control mechanism, where
1027  * there is an account (an owner) that can be granted exclusive access to
1028  * specific functions.
1029  *
1030  * By default, the owner account will be the one that deploys the contract. This
1031  * can later be changed with {transferOwnership}.
1032  *
1033  * This module is used through inheritance. It will make available the modifier
1034  * `onlyOwner`, which can be applied to your functions to restrict their use to
1035  * the owner.
1036  */
1037 abstract contract Ownable is Context {
1038     address private _owner;
1039 
1040     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1041 
1042     /**
1043      * @dev Initializes the contract setting the deployer as the initial owner.
1044      */
1045     constructor() {
1046         _setOwner(_msgSender());
1047     }
1048 
1049     /**
1050      * @dev Returns the address of the current owner.
1051      */
1052     function owner() public view virtual returns (address) {
1053         return _owner;
1054     }
1055 
1056     /**
1057      * @dev Throws if called by any account other than the owner.
1058      */
1059     modifier onlyOwner() {
1060         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1061         _;
1062     }
1063 
1064     /**
1065      * @dev Leaves the contract without owner. It will not be possible to call
1066      * `onlyOwner` functions anymore. Can only be called by the current owner.
1067      *
1068      * NOTE: Renouncing ownership will leave the contract without an owner,
1069      * thereby removing any functionality that is only available to the owner.
1070      */
1071     function renounceOwnership() public virtual onlyOwner {
1072         _setOwner(address(0));
1073     }
1074 
1075     /**
1076      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1077      * Can only be called by the current owner.
1078      */
1079     function transferOwnership(address newOwner) public virtual onlyOwner {
1080         require(newOwner != address(0), "Ownable: new owner is the zero address");
1081         _setOwner(newOwner);
1082     }
1083 
1084     function _setOwner(address newOwner) private {
1085         address oldOwner = _owner;
1086         _owner = newOwner;
1087         emit OwnershipTransferred(oldOwner, newOwner);
1088     }
1089 }
1090 
1091 // File: mirage_membership.sol
1092 
1093 /*
1094  
1095            M                                                 M
1096          M   M                                             M   M
1097         M  M  M                                           M  M  M
1098        M  M  M  M                                       M  M  M  M
1099       M  M  M  M  M                                    M  M  M  M  M
1100      M  M M  M  M  M                                 M  M  M  M  M  M  
1101      M  M   M  M  M  M                              M  M     M  M  M  M
1102      M  M     M  M  M  M                           M  M      M  M   M  M
1103      M  M       M  M  M  M                        M  M       M  M   M  M         
1104      M  M         M  M  M  M                     M  M        M  M   M  M
1105      M  M           M  M  M  M                  M  M         M  M   M  M
1106      M  M             M  M  M  M               M  M          M  M   M  M   M  M  M  M  M  M  M
1107      M  M               M  M  M  M            M  M        M  M  M   M  M   M  M  M  M  M  M  M  
1108      M  M                 M  M  M  M         M  M      M  M  M  M   M  M                  M  M
1109      M  M                   M  M  M  M      M  M    M  M  M  M  M   M  M                     M
1110      M  M                     M  M  M  M   M  M  M  M  M  M  M  M   M  M
1111      M  M                       M  M  M  M  M   M  M  M  M   M  M   M  M
1112      M  M                         M  M  M  M   M  M  M  M    M  M   M  M
1113      M  M                           M  M  M   M  M  M  M     M  M   M  M
1114      M  M                             M  M   M  M  M  M      M  M   M  M
1115 M  M  M  M  M  M                         M   M  M  M  M   M  M  M  M  M  M  M    
1116                                             M  M  M  M 
1117                                             M  M  M  M 
1118                                             M  M  M  M 
1119                                              M  M  M  M                        M  M  M  M  M  M
1120                                               M  M  M  M                          M  M  M  M 
1121                                                M  M  M  M                         M  M  M  M 
1122                                                  M  M  M  M                       M  M  M  M 
1123                                                    M  M  M  M                     M  M  M  M 
1124                                                      M  M  M  M                   M  M  M  M 
1125                                                         M  M  M  M                M  M  M  M 
1126                                                            M  M  M  M             M  M  M  M 
1127                                                                M  M  M  M   M  M  M  M  M  M 
1128                                                                    M  M  M  M  M  M  M  M  M
1129                                                                                                                                                         
1130 */
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 
1136 
1137 interface mirageContracts {
1138   function balanceOf(address owner) external view returns (uint256);
1139 }
1140 
1141 contract mirageMembership is ERC1155Supply, Ownable  {
1142     uint _priceIntelligent = 0.05 ether;
1143     uint _priceSentient = 0.5 ether;
1144     uint _priceDiscIntelligent = 0.0125 ether;
1145     uint _priceDiscSentient = 0.25 ether;
1146     uint256 constant _max_intelligent = 1450;
1147     uint256 constant _max_sentient = 50;
1148     uint256 sentient = 0;
1149     uint256 _airdrop_available = 30;
1150     uint256 constant intelligentID = 50;
1151     string intelligentURI = 'https://ipfs.io/ipfs/Qmd68aaryxxngGSXP3FqkWjG4yZG3YGbnK8Sq97ZDnMQsZ';
1152     string sentientURI = 'https://ipfs.io/ipfs/QmPfjJKP4YUD9ypiYZZH57DXQEvjkjv7HikthCU3sQfWnG';
1153     uint256 mintActive = 1;
1154     mirageContracts public cryptoNative;
1155     mirageContracts public AlejandroAndTaylor;
1156     mirageContracts public earlyWorks;
1157 
1158     constructor() ERC1155('https://ipfs.io/ipfs') {
1159         
1160         cryptoNative = mirageContracts(0x89568Fc8d04B3f833209144b77F39b71078e3CB0);
1161         AlejandroAndTaylor = mirageContracts(0x63400da86a6b42dac41075667cF871a5Ef93802F);
1162         earlyWorks = mirageContracts(0x3Cf6e4ff99D616d44Be53E90F74eAE5D150Cb726);
1163     }
1164     
1165     function updateURI(string memory _intelligentURI, string memory _sentientURI) public onlyOwner {
1166         intelligentURI = _intelligentURI;
1167         sentientURI = _sentientURI;
1168     }
1169     
1170     function updateAirdrop(uint256 airdropAvailable) public onlyOwner {
1171         require((totalSupply(intelligentID) + sentient) < (_max_intelligent + _max_sentient), "None available to airdrop");
1172         _airdrop_available = airdropAvailable;
1173     }
1174     
1175     function endMint() public onlyOwner {
1176         mintActive = 2;
1177     }
1178     
1179     function startMint() public onlyOwner {
1180         require(mintActive != 2, "Mint has been locked");
1181         mintActive = 0;
1182     }
1183     
1184     function updatePriceIntelligent(uint256 newMainPrice, uint256 newDiscPrice) public onlyOwner {
1185         _priceIntelligent = newMainPrice;
1186         _priceDiscIntelligent = newDiscPrice;
1187     }
1188     
1189     function updatePriceSentient(uint256 newMainPrice, uint256 newDiscPrice) public onlyOwner {
1190         _priceSentient = newMainPrice;
1191         _priceDiscSentient = newDiscPrice;
1192     }
1193     
1194     function mintToSender(uint numberOfTokens, uint tokenID) internal {
1195         require(totalSupply(intelligentID) + sentient + (numberOfTokens) <= _max_intelligent + _max_sentient, "Minting would exceed max supply");
1196         _mint(msg.sender, tokenID, numberOfTokens, "");
1197         }
1198     
1199     function mintIntelligent(uint numberOfTokens) internal virtual {
1200         _mint(msg.sender, intelligentID, numberOfTokens, "");
1201     }
1202     
1203     function mintToAddress(uint numberOfTokens, address address_to_mint, uint tokenID) internal {
1204         require(totalSupply(intelligentID) + sentient + numberOfTokens <= _max_intelligent + _max_sentient, "Minting would exceed max supply");
1205         _mint(address_to_mint, tokenID, numberOfTokens, "");
1206         }
1207 
1208     function purchaseIntelligent(uint numberOfTokens) public payable {
1209         require(mintActive == 0, "Mint has not opened yet or has been locked");
1210         require(_airdrop_available == 0, "Airdrop has not ended");
1211         require(totalSupply(intelligentID) + numberOfTokens <= _max_intelligent, "Purchase would exceed max supply of tokens");
1212         require(numberOfTokens <= 2, "Can only purchase a maximum of 2 tokens at a time");
1213         if (cryptoNative.balanceOf(msg.sender) > 0 || AlejandroAndTaylor.balanceOf(msg.sender) > 0 || earlyWorks.balanceOf(msg.sender) > 0) {
1214             require((_priceDiscIntelligent * numberOfTokens) <= msg.value, "Ether value sent is not correct");
1215         } else {
1216             require(_priceIntelligent * numberOfTokens <= msg.value, "Ether value sent is not correct");
1217         }
1218         mintIntelligent(numberOfTokens);
1219     }
1220     
1221     function purchaseSentient() public payable {
1222         require(mintActive == 0, "Mint has not opened yet or has been locked");
1223         require(_airdrop_available == 0, "Airdrop has not ended");
1224         require(sentient < _max_sentient, "Purchase would exceed max supply of tokens");
1225         if (cryptoNative.balanceOf(msg.sender) > 0 || AlejandroAndTaylor.balanceOf(msg.sender) > 0 || earlyWorks.balanceOf(msg.sender) > 0) {
1226             require(_priceDiscSentient <= msg.value, "Ether value sent is not correct");
1227         } else {
1228             require(_priceSentient <= msg.value, "Ether value sent is not correct");
1229         }
1230         mintSentient(msg.sender);
1231     }
1232     
1233     function mintSentient(address address_to_mint) internal virtual {
1234         uint tokenID = sentient;
1235         _mint(address_to_mint, tokenID, 1, '');
1236         sentient = sentient +  1; 
1237     }
1238     
1239     function airdrop(address addresstm, uint numberOfTokens, uint one_intelligent_two_sentient) public onlyOwner {
1240         require(_airdrop_available > 0, "No airdrop tokens available");
1241         require(numberOfTokens <= _airdrop_available);
1242         _airdrop_available -= numberOfTokens;
1243         if (one_intelligent_two_sentient == 1) {
1244             mintToAddress(numberOfTokens, addresstm, intelligentID);
1245         } else if (one_intelligent_two_sentient == 2) {
1246             mintSentient(addresstm);
1247         }
1248     }
1249 
1250     function uri(uint tokenID) public view override returns(string memory) {
1251         if (tokenID == intelligentID) {
1252             return intelligentURI;
1253         } else if (tokenID < 50) {
1254             return sentientURI;
1255         } else {
1256             return '';
1257         }
1258     }
1259 
1260     function withdraw() public onlyOwner {
1261         uint balance = address(this).balance;
1262         payable(msg.sender).transfer(balance);
1263     }
1264 }