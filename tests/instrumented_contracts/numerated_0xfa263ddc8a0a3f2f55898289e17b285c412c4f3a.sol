1 // SPDX-License-Identifier: MIT
2 
3 /*
4                 8888888888 888                   d8b
5                 888        888                   Y8P
6                 888        888
7                 8888888    888 888  888 .d8888b  888 888  888 88888b.d88b.
8                 888        888 888  888 88K      888 888  888 888 "888 "88b
9                 888        888 888  888 "Y8888b. 888 888  888 888  888  888
10                 888        888 Y88b 888      X88 888 Y88b 888 888  888  888
11                 8888888888 888  "Y88888  88888P' 888  "Y88888 888  888  888
12                                     888
13                                Y8b d88P
14                                 "Y88P"
15                 888b     d888          888              .d8888b.                888
16                 8888b   d8888          888             d88P  Y88b               888
17                 88888b.d88888          888             888    888               888
18                 888Y88888P888  .d88b.  888888  8888b.  888         .d88b.   .d88888 .d8888b
19                 888 Y888P 888 d8P  Y8b 888        "88b 888  88888 d88""88b d88" 888 88K
20                 888  Y8P  888 88888888 888    .d888888 888    888 888  888 888  888 "Y8888b.
21                 888   "   888 Y8b.     Y88b.  888  888 Y88b  d88P Y88..88P Y88b 888      X88
22                 888       888  "Y8888   "Y888 "Y888888  "Y8888P88  "Y88P"   "Y88888  88888P'
23 */
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes calldata) {
43         return msg.data;
44     }
45 }
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev Interface of the ERC165 standard, as defined in the
51  * https://eips.ethereum.org/EIPS/eip-165[EIP].
52  *
53  * Implementers can declare support of contract interfaces, which can then be
54  * queried by others ({ERC165Checker}).
55  *
56  * For an implementation, see {ERC165}.
57  */
58 interface IERC165 {
59     /**
60      * @dev Returns true if this contract implements the interface defined by
61      * `interfaceId`. See the corresponding
62      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
63      * to learn more about how these ids are created.
64      *
65      * This function call must use less than 30 000 gas.
66      */
67     function supportsInterface(bytes4 interfaceId) external view returns (bool);
68 }
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev Required interface of an ERC1155 compliant contract, as defined in the
74  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
75  *
76  * _Available since v3.1._
77  */
78 interface IERC1155 is IERC165 {
79     /**
80      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
81      */
82     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
83 
84     /**
85      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
86      * transfers.
87      */
88     event TransferBatch(
89         address indexed operator,
90         address indexed from,
91         address indexed to,
92         uint256[] ids,
93         uint256[] values
94     );
95 
96     /**
97      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
98      * `approved`.
99      */
100     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
101 
102     /**
103      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
104      *
105      * If an {URI} event was emitted for `id`, the standard
106      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
107      * returned by {IERC1155MetadataURI-uri}.
108      */
109     event URI(string value, uint256 indexed id);
110 
111     /**
112      * @dev Returns the amount of tokens of token type `id` owned by `account`.
113      *
114      * Requirements:
115      *
116      * - `account` cannot be the zero address.
117      */
118     function balanceOf(address account, uint256 id) external view returns (uint256);
119 
120     /**
121      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
122      *
123      * Requirements:
124      *
125      * - `accounts` and `ids` must have the same length.
126      */
127     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
128     external
129     view
130     returns (uint256[] memory);
131 
132     /**
133      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
134      *
135      * Emits an {ApprovalForAll} event.
136      *
137      * Requirements:
138      *
139      * - `operator` cannot be the caller.
140      */
141     function setApprovalForAll(address operator, bool approved) external;
142 
143     /**
144      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
145      *
146      * See {setApprovalForAll}.
147      */
148     function isApprovedForAll(address account, address operator) external view returns (bool);
149 
150     /**
151      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
152      *
153      * Emits a {TransferSingle} event.
154      *
155      * Requirements:
156      *
157      * - `to` cannot be the zero address.
158      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
159      * - `from` must have a balance of tokens of type `id` of at least `amount`.
160      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
161      * acceptance magic value.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 id,
167         uint256 amount,
168         bytes calldata data
169     ) external;
170 
171     /**
172      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
173      *
174      * Emits a {TransferBatch} event.
175      *
176      * Requirements:
177      *
178      * - `ids` and `amounts` must have the same length.
179      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
180      * acceptance magic value.
181      */
182     function safeBatchTransferFrom(
183         address from,
184         address to,
185         uint256[] calldata ids,
186         uint256[] calldata amounts,
187         bytes calldata data
188     ) external;
189 }
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev _Available since v3.1._
195  */
196 interface IERC1155Receiver is IERC165 {
197     /**
198      * @dev Handles the receipt of a single ERC1155 token type. This function is
199      * called at the end of a `safeTransferFrom` after the balance has been updated.
200      *
201      * NOTE: To accept the transfer, this must return
202      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
203      * (i.e. 0xf23a6e61, or its own function selector).
204      *
205      * @param operator The address which initiated the transfer (i.e. msg.sender)
206      * @param from The address which previously owned the token
207      * @param id The ID of the token being transferred
208      * @param value The amount of tokens being transferred
209      * @param data Additional data with no specified format
210      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
211      */
212     function onERC1155Received(
213         address operator,
214         address from,
215         uint256 id,
216         uint256 value,
217         bytes calldata data
218     ) external returns (bytes4);
219 
220     /**
221      * @dev Handles the receipt of a multiple ERC1155 token types. This function
222      * is called at the end of a `safeBatchTransferFrom` after the balances have
223      * been updated.
224      *
225      * NOTE: To accept the transfer(s), this must return
226      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
227      * (i.e. 0xbc197c81, or its own function selector).
228      *
229      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
230      * @param from The address which previously owned the token
231      * @param ids An array containing ids of each token being transferred (order and length must match values array)
232      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
233      * @param data Additional data with no specified format
234      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
235      */
236     function onERC1155BatchReceived(
237         address operator,
238         address from,
239         uint256[] calldata ids,
240         uint256[] calldata values,
241         bytes calldata data
242     ) external returns (bytes4);
243 }
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
249  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
250  *
251  * _Available since v3.1._
252  */
253 interface IERC1155MetadataURI is IERC1155 {
254     /**
255      * @dev Returns the URI for token type `id`.
256      *
257      * If the `\{id\}` substring is present in the URI, it must be replaced by
258      * clients with the actual token type ID.
259      */
260     function uri(uint256 id) external view returns (string memory);
261 }
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // This method relies on extcodesize, which returns 0 for contracts in
288         // construction, since the code is only stored at the end of the
289         // constructor execution.
290 
291         uint256 size;
292         assembly {
293             size := extcodesize(account)
294         }
295         return size > 0;
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         (bool success,) = recipient.call{value : amount}("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain `call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
340         return functionCall(target, data, "Address: low-level call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
345      * `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(
369         address target,
370         bytes memory data,
371         uint256 value
372     ) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(
383         address target,
384         bytes memory data,
385         uint256 value,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         require(address(this).balance >= value, "Address: insufficient balance for call");
389         require(isContract(target), "Address: call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.call{value : value}(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a static call.
398      *
399      * _Available since v3.3._
400      */
401     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
402         return functionStaticCall(target, data, "Address: low-level static call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a static call.
408      *
409      * _Available since v3.3._
410      */
411     function functionStaticCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal view returns (bytes memory) {
416         require(isContract(target), "Address: static call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.staticcall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a delegate call.
425      *
426      * _Available since v3.4._
427      */
428     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
429         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a delegate call.
435      *
436      * _Available since v3.4._
437      */
438     function functionDelegateCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         require(isContract(target), "Address: delegate call to non-contract");
444 
445         (bool success, bytes memory returndata) = target.delegatecall(data);
446         return verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
451      * revert reason using the provided one.
452      *
453      * _Available since v4.3._
454      */
455     function verifyCallResult(
456         bool success,
457         bytes memory returndata,
458         string memory errorMessage
459     ) internal pure returns (bytes memory) {
460         if (success) {
461             return returndata;
462         } else {
463             // Look for revert reason and bubble it up if present
464             if (returndata.length > 0) {
465                 // The easiest way to bubble the revert reason is using memory via assembly
466 
467                 assembly {
468                     let returndata_size := mload(returndata)
469                     revert(add(32, returndata), returndata_size)
470                 }
471             } else {
472                 revert(errorMessage);
473             }
474         }
475     }
476 }
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev Implementation of the {IERC165} interface.
482  *
483  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
484  * for the additional interface id that will be supported. For example:
485  *
486  * ```solidity
487  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
488  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
489  * }
490  * ```
491  *
492  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
493  */
494 abstract contract ERC165 is IERC165 {
495     /**
496      * @dev See {IERC165-supportsInterface}.
497      */
498     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
499         return interfaceId == type(IERC165).interfaceId;
500     }
501 }
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @dev Implementation of the basic standard multi-token.
507  * See https://eips.ethereum.org/EIPS/eip-1155
508  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
509  *
510  * _Available since v3.1._
511  */
512 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
513     using Address for address;
514 
515     // Mapping from token ID to account balances
516     mapping(uint256 => mapping(address => uint256)) private _balances;
517 
518     // Mapping from account to operator approvals
519     mapping(address => mapping(address => bool)) private _operatorApprovals;
520 
521     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
522     string private _uri;
523 
524     /**
525      * @dev See {_setURI}.
526      */
527     constructor(string memory uri_) {
528         _setURI(uri_);
529     }
530 
531     /**
532      * @dev See {IERC165-supportsInterface}.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
535         return
536         interfaceId == type(IERC1155).interfaceId ||
537     interfaceId == type(IERC1155MetadataURI).interfaceId ||
538     super.supportsInterface(interfaceId);
539     }
540 
541     /**
542      * @dev See {IERC1155MetadataURI-uri}.
543      *
544      * This implementation returns the same URI for *all* token types. It relies
545      * on the token type ID substitution mechanism
546      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
547      *
548      * Clients calling this function must replace the `\{id\}` substring with the
549      * actual token type ID.
550      */
551     function uri(uint256) public view virtual override returns (string memory) {
552         return _uri;
553     }
554 
555     /**
556      * @dev See {IERC1155-balanceOf}.
557      *
558      * Requirements:
559      *
560      * - `account` cannot be the zero address.
561      */
562     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
563         require(account != address(0), "ERC1155: balance query for the zero address");
564         return _balances[id][account];
565     }
566 
567     /**
568      * @dev See {IERC1155-balanceOfBatch}.
569      *
570      * Requirements:
571      *
572      * - `accounts` and `ids` must have the same length.
573      */
574     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
575     public
576     view
577     virtual
578     override
579     returns (uint256[] memory)
580     {
581         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
582 
583         uint256[] memory batchBalances = new uint256[](accounts.length);
584 
585         for (uint256 i = 0; i < accounts.length; ++i) {
586             batchBalances[i] = balanceOf(accounts[i], ids[i]);
587         }
588 
589         return batchBalances;
590     }
591 
592     /**
593      * @dev See {IERC1155-setApprovalForAll}.
594      */
595     function setApprovalForAll(address operator, bool approved) public virtual override {
596         _setApprovalForAll(_msgSender(), operator, approved);
597     }
598 
599     /**
600      * @dev See {IERC1155-isApprovedForAll}.
601      */
602     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
603         return _operatorApprovals[account][operator];
604     }
605 
606     /**
607      * @dev See {IERC1155-safeTransferFrom}.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 id,
613         uint256 amount,
614         bytes memory data
615     ) public virtual override {
616         require(
617             from == _msgSender() || isApprovedForAll(from, _msgSender()),
618             "ERC1155: caller is not owner nor approved"
619         );
620         _safeTransferFrom(from, to, id, amount, data);
621     }
622 
623     /**
624      * @dev See {IERC1155-safeBatchTransferFrom}.
625      */
626     function safeBatchTransferFrom(
627         address from,
628         address to,
629         uint256[] memory ids,
630         uint256[] memory amounts,
631         bytes memory data
632     ) public virtual override {
633         require(
634             from == _msgSender() || isApprovedForAll(from, _msgSender()),
635             "ERC1155: transfer caller is not owner nor approved"
636         );
637         _safeBatchTransferFrom(from, to, ids, amounts, data);
638     }
639 
640     /**
641      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
642      *
643      * Emits a {TransferSingle} event.
644      *
645      * Requirements:
646      *
647      * - `to` cannot be the zero address.
648      * - `from` must have a balance of tokens of type `id` of at least `amount`.
649      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
650      * acceptance magic value.
651      */
652     function _safeTransferFrom(
653         address from,
654         address to,
655         uint256 id,
656         uint256 amount,
657         bytes memory data
658     ) internal virtual {
659         require(to != address(0), "ERC1155: transfer to the zero address");
660 
661         address operator = _msgSender();
662 
663         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
664 
665         uint256 fromBalance = _balances[id][from];
666         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
667     unchecked {
668         _balances[id][from] = fromBalance - amount;
669     }
670         _balances[id][to] += amount;
671 
672         emit TransferSingle(operator, from, to, id, amount);
673 
674         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
675     }
676 
677     /**
678      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
679      *
680      * Emits a {TransferBatch} event.
681      *
682      * Requirements:
683      *
684      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
685      * acceptance magic value.
686      */
687     function _safeBatchTransferFrom(
688         address from,
689         address to,
690         uint256[] memory ids,
691         uint256[] memory amounts,
692         bytes memory data
693     ) internal virtual {
694         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
695         require(to != address(0), "ERC1155: transfer to the zero address");
696 
697         address operator = _msgSender();
698 
699         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
700 
701         for (uint256 i = 0; i < ids.length; ++i) {
702             uint256 id = ids[i];
703             uint256 amount = amounts[i];
704 
705             uint256 fromBalance = _balances[id][from];
706             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
707         unchecked {
708             _balances[id][from] = fromBalance - amount;
709         }
710             _balances[id][to] += amount;
711         }
712 
713         emit TransferBatch(operator, from, to, ids, amounts);
714 
715         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
716     }
717 
718     /**
719      * @dev Sets a new URI for all token types, by relying on the token type ID
720      * substitution mechanism
721      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
722      *
723      * By this mechanism, any occurrence of the `\{id\}` substring in either the
724      * URI or any of the amounts in the JSON file at said URI will be replaced by
725      * clients with the token type ID.
726      *
727      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
728      * interpreted by clients as
729      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
730      * for token type ID 0x4cce0.
731      *
732      * See {uri}.
733      *
734      * Because these URIs cannot be meaningfully represented by the {URI} event,
735      * this function emits no events.
736      */
737     function _setURI(string memory newuri) internal virtual {
738         _uri = newuri;
739     }
740 
741     /**
742      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
743      *
744      * Emits a {TransferSingle} event.
745      *
746      * Requirements:
747      *
748      * - `to` cannot be the zero address.
749      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
750      * acceptance magic value.
751      */
752     function _mint(
753         address to,
754         uint256 id,
755         uint256 amount,
756         bytes memory data
757     ) internal virtual {
758         require(to != address(0), "ERC1155: mint to the zero address");
759 
760         address operator = _msgSender();
761 
762         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
763 
764         _balances[id][to] += amount;
765         emit TransferSingle(operator, address(0), to, id, amount);
766 
767         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
768     }
769 
770     /**
771      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
772      *
773      * Requirements:
774      *
775      * - `ids` and `amounts` must have the same length.
776      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
777      * acceptance magic value.
778      */
779     function _mintBatch(
780         address to,
781         uint256[] memory ids,
782         uint256[] memory amounts,
783         bytes memory data
784     ) internal virtual {
785         require(to != address(0), "ERC1155: mint to the zero address");
786         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
787 
788         address operator = _msgSender();
789 
790         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
791 
792         for (uint256 i = 0; i < ids.length; i++) {
793             _balances[ids[i]][to] += amounts[i];
794         }
795 
796         emit TransferBatch(operator, address(0), to, ids, amounts);
797 
798         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
799     }
800 
801     /**
802      * @dev Destroys `amount` tokens of token type `id` from `from`
803      *
804      * Requirements:
805      *
806      * - `from` cannot be the zero address.
807      * - `from` must have at least `amount` tokens of token type `id`.
808      */
809     function _burn(
810         address from,
811         uint256 id,
812         uint256 amount
813     ) internal virtual {
814         require(from != address(0), "ERC1155: burn from the zero address");
815 
816         address operator = _msgSender();
817 
818         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
819 
820         uint256 fromBalance = _balances[id][from];
821         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
822     unchecked {
823         _balances[id][from] = fromBalance - amount;
824     }
825 
826         emit TransferSingle(operator, from, address(0), id, amount);
827     }
828 
829     /**
830      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
831      *
832      * Requirements:
833      *
834      * - `ids` and `amounts` must have the same length.
835      */
836     function _burnBatch(
837         address from,
838         uint256[] memory ids,
839         uint256[] memory amounts
840     ) internal virtual {
841         require(from != address(0), "ERC1155: burn from the zero address");
842         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
843 
844         address operator = _msgSender();
845 
846         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
847 
848         for (uint256 i = 0; i < ids.length; i++) {
849             uint256 id = ids[i];
850             uint256 amount = amounts[i];
851 
852             uint256 fromBalance = _balances[id][from];
853             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
854         unchecked {
855             _balances[id][from] = fromBalance - amount;
856         }
857         }
858 
859         emit TransferBatch(operator, from, address(0), ids, amounts);
860     }
861 
862     /**
863      * @dev Approve `operator` to operate on all of `owner` tokens
864      *
865      * Emits a {ApprovalForAll} event.
866      */
867     function _setApprovalForAll(
868         address owner,
869         address operator,
870         bool approved
871     ) internal virtual {
872         require(owner != operator, "ERC1155: setting approval status for self");
873         _operatorApprovals[owner][operator] = approved;
874         emit ApprovalForAll(owner, operator, approved);
875     }
876 
877     /**
878      * @dev Hook that is called before any token transfer. This includes minting
879      * and burning, as well as batched variants.
880      *
881      * The same hook is called on both single and batched variants. For single
882      * transfers, the length of the `id` and `amount` arrays will be 1.
883      *
884      * Calling conditions (for each `id` and `amount` pair):
885      *
886      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
887      * of token type `id` will be  transferred to `to`.
888      * - When `from` is zero, `amount` tokens of token type `id` will be minted
889      * for `to`.
890      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
891      * will be burned.
892      * - `from` and `to` are never both zero.
893      * - `ids` and `amounts` have the same, non-zero length.
894      *
895      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
896      */
897     function _beforeTokenTransfer(
898         address operator,
899         address from,
900         address to,
901         uint256[] memory ids,
902         uint256[] memory amounts,
903         bytes memory data
904     ) internal virtual {}
905 
906     function _doSafeTransferAcceptanceCheck(
907         address operator,
908         address from,
909         address to,
910         uint256 id,
911         uint256 amount,
912         bytes memory data
913     ) private {
914         if (to.isContract()) {
915             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
916                 if (response != IERC1155Receiver.onERC1155Received.selector) {
917                     revert("ERC1155: ERC1155Receiver rejected tokens");
918                 }
919             } catch Error(string memory reason) {
920                 revert(reason);
921             } catch {
922                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
923             }
924         }
925     }
926 
927     function _doSafeBatchTransferAcceptanceCheck(
928         address operator,
929         address from,
930         address to,
931         uint256[] memory ids,
932         uint256[] memory amounts,
933         bytes memory data
934     ) private {
935         if (to.isContract()) {
936             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
937                 bytes4 response
938             ) {
939                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
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
950     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
951         uint256[] memory array = new uint256[](1);
952         array[0] = element;
953 
954         return array;
955     }
956 }
957 
958 pragma solidity ^0.8.0;
959 
960 /**
961  * @dev Extension of ERC1155 that adds tracking of total supply per id.
962  *
963  * Useful for scenarios where Fungible and Non-fungible tokens have to be
964  * clearly identified. Note: While a totalSupply of 1 might mean the
965  * corresponding is an NFT, there is no guarantees that no other token with the
966  * same id are not going to be minted.
967  */
968 abstract contract ERC1155Supply is ERC1155 {
969     mapping(uint256 => uint256) private _totalSupply;
970 
971     /**
972      * @dev Total amount of tokens in with a given id.
973      */
974     function totalSupply(uint256 id) public view virtual returns (uint256) {
975         return _totalSupply[id];
976     }
977 
978     /**
979      * @dev Indicates whether any token exist with a given id, or not.
980      */
981     function exists(uint256 id) public view virtual returns (bool) {
982         return ERC1155Supply.totalSupply(id) > 0;
983     }
984 
985     /**
986      * @dev See {ERC1155-_beforeTokenTransfer}.
987      */
988     function _beforeTokenTransfer(
989         address operator,
990         address from,
991         address to,
992         uint256[] memory ids,
993         uint256[] memory amounts,
994         bytes memory data
995     ) internal virtual override {
996         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
997 
998         if (from == address(0)) {
999             for (uint256 i = 0; i < ids.length; ++i) {
1000                 _totalSupply[ids[i]] += amounts[i];
1001             }
1002         }
1003 
1004         if (to == address(0)) {
1005             for (uint256 i = 0; i < ids.length; ++i) {
1006                 _totalSupply[ids[i]] -= amounts[i];
1007             }
1008         }
1009     }
1010 }
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 /**
1015  * @dev Contract module which provides a basic access control mechanism, where
1016  * there is an account (an owner) that can be granted exclusive access to
1017  * specific functions.
1018  *
1019  * By default, the owner account will be the one that deploys the contract. This
1020  * can later be changed with {transferOwnership}.
1021  *
1022  * This module is used through inheritance. It will make available the modifier
1023  * `onlyOwner`, which can be applied to your functions to restrict their use to
1024  * the owner.
1025  */
1026 abstract contract Ownable is Context {
1027     address private _owner;
1028 
1029     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1030 
1031     /**
1032      * @dev Initializes the contract setting the deployer as the initial owner.
1033      */
1034     constructor() {
1035         _setOwner(_msgSender());
1036     }
1037 
1038     /**
1039      * @dev Returns the address of the current owner.
1040      */
1041     function owner() public view virtual returns (address) {
1042         return _owner;
1043     }
1044 
1045     /**
1046      * @dev Throws if called by any account other than the owner.
1047      */
1048     modifier onlyOwner() {
1049         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1050         _;
1051     }
1052 
1053     /**
1054      * @dev Leaves the contract without owner. It will not be possible to call
1055      * `onlyOwner` functions anymore. Can only be called by the current owner.
1056      *
1057      * NOTE: Renouncing ownership will leave the contract without an owner,
1058      * thereby removing any functionality that is only available to the owner.
1059      */
1060     function renounceOwnership() public virtual onlyOwner {
1061         _setOwner(address(0));
1062     }
1063 
1064     /**
1065      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1066      * Can only be called by the current owner.
1067      */
1068     function transferOwnership(address newOwner) public virtual onlyOwner {
1069         require(newOwner != address(0), "Ownable: new owner is the zero address");
1070         _setOwner(newOwner);
1071     }
1072 
1073     function _setOwner(address newOwner) private {
1074         address oldOwner = _owner;
1075         _owner = newOwner;
1076         emit OwnershipTransferred(oldOwner, newOwner);
1077     }
1078 }
1079 
1080 pragma solidity ^0.8.0;
1081 
1082 /**
1083  * @dev String operations.
1084  */
1085 library Strings {
1086     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1087 
1088     /**
1089      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1090      */
1091     function toString(uint256 value) internal pure returns (string memory) {
1092         // Inspired by OraclizeAPI's implementation - MIT licence
1093         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1094 
1095         if (value == 0) {
1096             return "0";
1097         }
1098         uint256 temp = value;
1099         uint256 digits;
1100         while (temp != 0) {
1101             digits++;
1102             temp /= 10;
1103         }
1104         bytes memory buffer = new bytes(digits);
1105         while (value != 0) {
1106             digits -= 1;
1107             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1108             value /= 10;
1109         }
1110         return string(buffer);
1111     }
1112 
1113     /**
1114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1115      */
1116     function toHexString(uint256 value) internal pure returns (string memory) {
1117         if (value == 0) {
1118             return "0x00";
1119         }
1120         uint256 temp = value;
1121         uint256 length = 0;
1122         while (temp != 0) {
1123             length++;
1124             temp >>= 8;
1125         }
1126         return toHexString(value, length);
1127     }
1128 
1129     /**
1130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1131      */
1132     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1133         bytes memory buffer = new bytes(2 * length + 2);
1134         buffer[0] = "0";
1135         buffer[1] = "x";
1136         for (uint256 i = 2 * length + 1; i > 1; --i) {
1137             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1138             value >>= 4;
1139         }
1140         require(value == 0, "Strings: hex length insufficient");
1141         return string(buffer);
1142     }
1143 }
1144 
1145 pragma solidity ^0.8.0;
1146 
1147 /**
1148  * @title PaymentSplitter
1149  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1150  * that the Ether will be split in this way, since it is handled transparently by the contract.
1151  *
1152  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1153  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1154  * an amount proportional to the percentage of total shares they were assigned.
1155  *
1156  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1157  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1158  * function.
1159  *
1160  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1161  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1162  * to run tests before sending real value to this contract.
1163  */
1164 contract PaymentSplitter is Context {
1165     event PayeeAdded(address account, uint256 shares);
1166     event PaymentReleased(address to, uint256 amount);
1167     event PaymentReceived(address from, uint256 amount);
1168 
1169     uint256 private _totalShares;
1170     uint256 private _totalReleased;
1171 
1172     mapping(address => uint256) private _shares;
1173     mapping(address => uint256) private _released;
1174     address[] private _payees;
1175 
1176     /**
1177      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1178      * the matching position in the `shares` array.
1179      *
1180      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1181      * duplicates in `payees`.
1182      */
1183     constructor(address[] memory payees, uint256[] memory shares_) payable {
1184         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1185         require(payees.length > 0, "PaymentSplitter: no payees");
1186 
1187         for (uint256 i = 0; i < payees.length; i++) {
1188             _addPayee(payees[i], shares_[i]);
1189         }
1190     }
1191 
1192     /**
1193      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1194      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1195      * reliability of the events, and not the actual splitting of Ether.
1196      *
1197      * To learn more about this see the Solidity documentation for
1198      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1199      * functions].
1200      */
1201     receive() external payable virtual {
1202         emit PaymentReceived(_msgSender(), msg.value);
1203     }
1204 
1205     /**
1206      * @dev Getter for the total shares held by payees.
1207      */
1208     function totalShares() public view returns (uint256) {
1209         return _totalShares;
1210     }
1211 
1212     /**
1213      * @dev Getter for the total amount of Ether already released.
1214      */
1215     function totalReleased() public view returns (uint256) {
1216         return _totalReleased;
1217     }
1218 
1219     /**
1220      * @dev Getter for the amount of shares held by an account.
1221      */
1222     function shares(address account) public view returns (uint256) {
1223         return _shares[account];
1224     }
1225 
1226     /**
1227      * @dev Getter for the amount of Ether already released to a payee.
1228      */
1229     function released(address account) public view returns (uint256) {
1230         return _released[account];
1231     }
1232 
1233     /**
1234      * @dev Getter for the address of the payee number `index`.
1235      */
1236     function payee(uint256 index) public view returns (address) {
1237         return _payees[index];
1238     }
1239 
1240     /**
1241      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1242      * total shares and their previous withdrawals.
1243      */
1244     function release(address payable account) public virtual {
1245         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1246 
1247         uint256 totalReceived = address(this).balance + totalReleased();
1248         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1249 
1250         require(payment != 0, "PaymentSplitter: account is not due payment");
1251 
1252         _released[account] += payment;
1253         _totalReleased += payment;
1254 
1255         Address.sendValue(account, payment);
1256         emit PaymentReleased(account, payment);
1257     }
1258 
1259     /**
1260      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1261      * already released amounts.
1262      */
1263     function _pendingPayment(
1264         address account,
1265         uint256 totalReceived,
1266         uint256 alreadyReleased
1267     ) private view returns (uint256) {
1268         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1269     }
1270 
1271     /**
1272      * @dev Add a new payee to the contract.
1273      * @param account The address of the payee to add.
1274      * @param shares_ The number of shares owned by the payee.
1275      */
1276     function _addPayee(address account, uint256 shares_) private {
1277         require(account != address(0), "PaymentSplitter: account is the zero address");
1278         require(shares_ > 0, "PaymentSplitter: shares are 0");
1279         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1280 
1281         _payees.push(account);
1282         _shares[account] = shares_;
1283         _totalShares = _totalShares + shares_;
1284         emit PayeeAdded(account, shares_);
1285     }
1286 }
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 /**
1291  * @dev These functions deal with verification of Merkle Trees proofs.
1292  *
1293  * The proofs can be generated using the JavaScript library
1294  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1295  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1296  *
1297  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1298  */
1299 library MerkleProof {
1300     /**
1301      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1302      * defined by `root`. For this, a `proof` must be provided, containing
1303      * sibling hashes on the branch from the leaf to the root of the tree. Each
1304      * pair of leaves and each pair of pre-images are assumed to be sorted.
1305      */
1306     function verify(
1307         bytes32[] memory proof,
1308         bytes32 root,
1309         bytes32 leaf
1310     ) internal pure returns (bool) {
1311         return processProof(proof, leaf) == root;
1312     }
1313 
1314     /**
1315      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1316      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1317      * hash matches the root of the tree. When processing the proof, the pairs
1318      * of leafs & pre-images are assumed to be sorted.
1319      *
1320      * _Available since v4.4._
1321      */
1322     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1323         bytes32 computedHash = leaf;
1324         for (uint256 i = 0; i < proof.length; i++) {
1325             bytes32 proofElement = proof[i];
1326             if (computedHash <= proofElement) {
1327                 // Hash(current computed hash + current element of the proof)
1328                 computedHash = _efficientHash(computedHash, proofElement);
1329             } else {
1330                 // Hash(current element of the proof + current computed hash)
1331                 computedHash = _efficientHash(proofElement, computedHash);
1332             }
1333         }
1334         return computedHash;
1335     }
1336 
1337     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1338         assembly {
1339             mstore(0x00, a)
1340             mstore(0x20, b)
1341             value := keccak256(0x00, 0x40)
1342         }
1343     }
1344 }
1345 
1346 
1347 contract MetaGodsMintPass is ERC1155Supply, Ownable, PaymentSplitter {
1348 
1349     bool public isPaused;
1350     bool public isPublicSaleActive;
1351     bool public isPresaleActive;
1352     bool public isBoostedPresaleActive;
1353 
1354     uint256 public maxPresaleMint = 2;
1355     uint256 public perTxnLimit = 7;
1356 
1357     uint256 public cost = 0.2 ether;
1358 
1359     mapping(address => uint256) public presaleWhitelistMints;
1360 
1361     uint256 private ps_redeemable = 200 ether;
1362 
1363     uint256 private constant BOOSTED_PASS = 0;
1364     uint256 private constant MAX_BOOSTED_SUPPLY = 4400;
1365     uint256 private availableBoostedSupply = 4400;
1366     uint256 private boostedReserveSupply = 100;
1367 
1368     uint256 private constant NORMAL_PASS = 1;
1369     uint256 private constant MAX_NORMAL_SUPPLY = 6711;
1370     uint256 private availableNormalSupply = 500;
1371     uint256 private normalReserveSupply = 500;
1372 
1373     bytes32 normalRoot;
1374     bytes32 boostedRoot;
1375 
1376     string private name_;
1377     string private symbol_;
1378 
1379     constructor(
1380         string memory _name,
1381         string memory _symbol,
1382         address[] memory payees,
1383         uint256[] memory shares,
1384         string memory _uri
1385     ) ERC1155(_uri) PaymentSplitter(payees, shares) {
1386         name_ = _name;
1387         symbol_ = _symbol;
1388     }
1389 
1390     function name() public view returns (string memory) {
1391         return name_;
1392     }
1393 
1394     function symbol() public view returns (string memory) {
1395         return symbol_;
1396     }
1397 
1398     //external
1399     function mint(uint256 _mintAmount) external payable {
1400         require(isPublicSaleActive, 'Sale not active');
1401 
1402         uint256 totalSupply = totalSupply(NORMAL_PASS);
1403 
1404         require(_mintAmount <= perTxnLimit, "Exceeds txn limit");
1405 
1406         require(totalSupply + _mintAmount <= _publicNormalSupply(), "Exceeded remaining supply");
1407         require(msg.value >= cost * _mintAmount);
1408 
1409         _mint(_msgSender(), NORMAL_PASS, _mintAmount, "");
1410     }
1411 
1412     function mintPresale(uint256 mintAmount, bytes32[] calldata proof, bool boosted) external payable {
1413 
1414         require(boosted ? isBoostedPresaleActive : isPresaleActive, "Presale not active");
1415 
1416         require(_verify(_leaf(msg.sender), boosted ? boostedRoot : normalRoot, proof), "Not whitelisted");
1417 
1418         require(msg.value >= cost * mintAmount, "Wrong amount");
1419 
1420         require(maxPresaleMint > presaleWhitelistMints[msg.sender], "Too many mints");
1421 
1422         uint256 availableMints = maxPresaleMint - presaleWhitelistMints[msg.sender];
1423 
1424         require(mintAmount <= availableMints, "Too many mints");
1425 
1426         uint256 pass = boosted ? BOOSTED_PASS : NORMAL_PASS;
1427         uint256 currentSupply = totalSupply(pass);
1428         uint256 publicSupply = boosted ? _publicBoostedSupply() : _publicNormalSupply();
1429         require(currentSupply + mintAmount <= publicSupply, "Exceeded remaining supply");
1430 
1431         presaleWhitelistMints[msg.sender] += mintAmount;
1432 
1433         _mint(_msgSender(), pass, mintAmount, "");
1434     }
1435 
1436     function reserveNormal(address _to, uint256 _reserveAmount) external onlyOwner {
1437         require(
1438             _reserveAmount <= normalReserveSupply,
1439             "Not enough reserve left"
1440         );
1441 
1442         _mint(_to, NORMAL_PASS, _reserveAmount, "");
1443 
1444         normalReserveSupply -= _reserveAmount;
1445     }
1446 
1447     function reserveBoosted(address _to, uint256 _reserveAmount) external onlyOwner {
1448         require(
1449             _reserveAmount <= boostedReserveSupply,
1450             "Not enough reserve left"
1451         );
1452 
1453         _mint(_to, BOOSTED_PASS, _reserveAmount, "");
1454 
1455         boostedReserveSupply -= _reserveAmount;
1456     }
1457 
1458     function uri(uint256 _tokenId) public view virtual override returns (string memory) {
1459         string memory baseUri = super.uri(_tokenId);
1460         return bytes(baseUri).length > 0 ? string(abi.encodePacked(baseUri, Strings.toString(_tokenId), ".json")) : "";
1461     }
1462 
1463     //internal
1464     function _leaf(address account) internal pure returns (bytes32) {
1465         return keccak256(abi.encodePacked(account));
1466     }
1467 
1468     function _verify(bytes32 _leafNode, bytes32 root, bytes32[] memory proof) internal pure returns (bool) {
1469         return MerkleProof.verify(proof, root, _leafNode);
1470     }
1471 
1472     function _publicNormalSupply() internal view virtual returns (uint256) {
1473         return availableNormalSupply - normalReserveSupply;
1474     }
1475 
1476     function _publicBoostedSupply() internal view virtual returns (uint256) {
1477         return availableBoostedSupply - boostedReserveSupply;
1478     }
1479 
1480     //setters
1481     function flipPauseState() external onlyOwner {
1482         isPaused = !isPaused;
1483     }
1484 
1485     function flipPublicSaleState() external onlyOwner {
1486         isPublicSaleActive = !isPublicSaleActive;
1487     }
1488 
1489     function flipNormalPresaleState() external onlyOwner {
1490         isPresaleActive = !isPresaleActive;
1491     }
1492 
1493     function flipBoostedPresaleState() external onlyOwner {
1494         isBoostedPresaleActive = !isBoostedPresaleActive;
1495     }
1496 
1497     function setPerTxnLimit(uint256 newPerTxnLimit) external onlyOwner {
1498         perTxnLimit = newPerTxnLimit;
1499     }
1500 
1501     function setMaxPresaleMint(uint256 newMaxPresaleMint) external onlyOwner {
1502         maxPresaleMint = newMaxPresaleMint;
1503     }
1504 
1505     function setTokenPrice(uint256 newCost) public onlyOwner {
1506         cost = newCost;
1507     }
1508 
1509     function setAvailableBoostedSupply(uint256 newBoostedSupply) external onlyOwner {
1510         require(newBoostedSupply <= MAX_BOOSTED_SUPPLY, "Exceeds max supply");
1511         availableBoostedSupply = newBoostedSupply;
1512     }
1513 
1514     function setAvailableNormalSupply(uint256 newNormalSupply) external onlyOwner {
1515         require(newNormalSupply <= MAX_NORMAL_SUPPLY, "Exceeds max supply");
1516         availableNormalSupply = newNormalSupply;
1517     }
1518 
1519     function setNormalRoot(bytes32 newRoot) external onlyOwner {
1520         normalRoot = newRoot;
1521     }
1522 
1523     function setBoostedRoot(bytes32 newRoot) external onlyOwner {
1524         boostedRoot = newRoot;
1525     }
1526 
1527     function setUri(string memory newUri) external onlyOwner {
1528         _setURI(newUri);
1529     }
1530 
1531     function withdraw(uint256 sum) external onlyOwner {
1532         require(sum <= ps_redeemable, "Exceeds redeemable");
1533         require(sum <= address(this).balance, "Exceeds balance");
1534         ps_redeemable -= sum;
1535         require(payable(msg.sender).send(sum));
1536     }
1537 
1538     function release(address payable account) public override {
1539         require(msg.sender == account, "Not owner");
1540         PaymentSplitter.release(account);
1541     }
1542 
1543     function _beforeTokenTransfer(
1544         address operator,
1545         address from,
1546         address to,
1547         uint256[] memory ids,
1548         uint256[] memory amounts,
1549         bytes memory data
1550     ) internal virtual override {
1551         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1552 
1553         require(!isPaused, "Token transfer paused");
1554     }
1555 }