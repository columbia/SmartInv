1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
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
26 /**
27  * @dev Required interface of an ERC1155 compliant contract, as defined in the
28  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
29  *
30  * _Available since v3.1._
31  */
32 interface IERC1155 is IERC165 {
33     /**
34      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
35      */
36     event TransferSingle(
37         address indexed operator,
38         address indexed from,
39         address indexed to,
40         uint256 id,
41         uint256 value
42     );
43 
44     /**
45      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
46      * transfers.
47      */
48     event TransferBatch(
49         address indexed operator,
50         address indexed from,
51         address indexed to,
52         uint256[] ids,
53         uint256[] values
54     );
55 
56     /**
57      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
58      * `approved`.
59      */
60     event ApprovalForAll(
61         address indexed account,
62         address indexed operator,
63         bool approved
64     );
65 
66     /**
67      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
68      *
69      * If an {URI} event was emitted for `id`, the standard
70      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
71      * returned by {IERC1155MetadataURI-uri}.
72      */
73     event URI(string value, uint256 indexed id);
74 
75     /**
76      * @dev Returns the amount of tokens of token type `id` owned by `account`.
77      *
78      * Requirements:
79      *
80      * - `account` cannot be the zero address.
81      */
82     function balanceOf(address account, uint256 id)
83         external
84         view
85         returns (uint256);
86 
87     /**
88      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
89      *
90      * Requirements:
91      *
92      * - `accounts` and `ids` must have the same length.
93      */
94     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
95         external
96         view
97         returns (uint256[] memory);
98 
99     /**
100      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
101      *
102      * Emits an {ApprovalForAll} event.
103      *
104      * Requirements:
105      *
106      * - `operator` cannot be the caller.
107      */
108     function setApprovalForAll(address operator, bool approved) external;
109 
110     /**
111      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
112      *
113      * See {setApprovalForAll}.
114      */
115     function isApprovedForAll(address account, address operator)
116         external
117         view
118         returns (bool);
119 
120     /**
121      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
122      *
123      * Emits a {TransferSingle} event.
124      *
125      * Requirements:
126      *
127      * - `to` cannot be the zero address.
128      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
129      * - `from` must have a balance of tokens of type `id` of at least `amount`.
130      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
131      * acceptance magic value.
132      */
133     function safeTransferFrom(
134         address from,
135         address to,
136         uint256 id,
137         uint256 amount,
138         bytes calldata data
139     ) external;
140 
141     /**
142      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
143      *
144      * Emits a {TransferBatch} event.
145      *
146      * Requirements:
147      *
148      * - `ids` and `amounts` must have the same length.
149      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
150      * acceptance magic value.
151      */
152     function safeBatchTransferFrom(
153         address from,
154         address to,
155         uint256[] calldata ids,
156         uint256[] calldata amounts,
157         bytes calldata data
158     ) external;
159 }
160 
161 /**
162  * _Available since v3.1._
163  */
164 interface IERC1155Receiver is IERC165 {
165     /**
166         @dev Handles the receipt of a single ERC1155 token type. This function is
167         called at the end of a `safeTransferFrom` after the balance has been updated.
168         To accept the transfer, this must return
169         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
170         (i.e. 0xf23a6e61, or its own function selector).
171         @param operator The address which initiated the transfer (i.e. msg.sender)
172         @param from The address which previously owned the token
173         @param id The ID of the token being transferred
174         @param value The amount of tokens being transferred
175         @param data Additional data with no specified format
176         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
177     */
178     function onERC1155Received(
179         address operator,
180         address from,
181         uint256 id,
182         uint256 value,
183         bytes calldata data
184     ) external returns (bytes4);
185 
186     /**
187         @dev Handles the receipt of a multiple ERC1155 token types. This function
188         is called at the end of a `safeBatchTransferFrom` after the balances have
189         been updated. To accept the transfer(s), this must return
190         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
191         (i.e. 0xbc197c81, or its own function selector).
192         @param operator The address which initiated the batch transfer (i.e. msg.sender)
193         @param from The address which previously owned the token
194         @param ids An array containing ids of each token being transferred (order and length must match values array)
195         @param values An array containing amounts of each token being transferred (order and length must match ids array)
196         @param data Additional data with no specified format
197         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
198     */
199     function onERC1155BatchReceived(
200         address operator,
201         address from,
202         uint256[] calldata ids,
203         uint256[] calldata values,
204         bytes calldata data
205     ) external returns (bytes4);
206 }
207 
208 /**
209  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
210  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
211  *
212  * _Available since v3.1._
213  */
214 interface IERC1155MetadataURI is IERC1155 {
215     /**
216      * @dev Returns the URI for token type `id`.
217      *
218      * If the `\{id\}` substring is present in the URI, it must be replaced by
219      * clients with the actual token type ID.
220      */
221     function uri(uint256 id) external view returns (string memory);
222 }
223 
224 /**
225  * @dev Collection of functions related to the address type
226  */
227 library Address {
228     /**
229      * @dev Returns true if `account` is a contract.
230      *
231      * [IMPORTANT]
232      * ====
233      * It is unsafe to assume that an address for which this function returns
234      * false is an externally-owned account (EOA) and not a contract.
235      *
236      * Among others, `isContract` will return false for the following
237      * types of addresses:
238      *
239      *  - an externally-owned account
240      *  - a contract in construction
241      *  - an address where a contract will be created
242      *  - an address where a contract lived, but was destroyed
243      * ====
244      */
245     function isContract(address account) internal view returns (bool) {
246         // This method relies on extcodesize, which returns 0 for contracts in
247         // construction, since the code is only stored at the end of the
248         // constructor execution.
249 
250         uint256 size;
251         // solhint-disable-next-line no-inline-assembly
252         assembly {
253             size := extcodesize(account)
254         }
255         return size > 0;
256     }
257 
258     /**
259      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
260      * `recipient`, forwarding all available gas and reverting on errors.
261      *
262      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
263      * of certain opcodes, possibly making contracts go over the 2300 gas limit
264      * imposed by `transfer`, making them unable to receive funds via
265      * `transfer`. {sendValue} removes this limitation.
266      *
267      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
268      *
269      * IMPORTANT: because control is transferred to `recipient`, care must be
270      * taken to not create reentrancy vulnerabilities. Consider using
271      * {ReentrancyGuard} or the
272      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
273      */
274     function sendValue(address payable recipient, uint256 amount) internal {
275         require(
276             address(this).balance >= amount,
277             "Address: insufficient balance"
278         );
279 
280         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
281         (bool success, ) = recipient.call{value: amount}("");
282         require(
283             success,
284             "Address: unable to send value, recipient may have reverted"
285         );
286     }
287 
288     /**
289      * @dev Performs a Solidity function call using a low level `call`. A
290      * plain`call` is an unsafe replacement for a function call: use this
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
306     function functionCall(address target, bytes memory data)
307         internal
308         returns (bytes memory)
309     {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value
342     ) internal returns (bytes memory) {
343         return
344             functionCallWithValue(
345                 target,
346                 data,
347                 value,
348                 "Address: low-level call with value failed"
349             );
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(
365             address(this).balance >= value,
366             "Address: insufficient balance for call"
367         );
368         require(isContract(target), "Address: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) =
372             target.call{value: value}(data);
373         return _verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(address target, bytes memory data)
383         internal
384         view
385         returns (bytes memory)
386     {
387         return
388             functionStaticCall(
389                 target,
390                 data,
391                 "Address: low-level static call failed"
392             );
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a static call.
398      *
399      * _Available since v3.3._
400      */
401     function functionStaticCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal view returns (bytes memory) {
406         require(isContract(target), "Address: static call to non-contract");
407 
408         // solhint-disable-next-line avoid-low-level-calls
409         (bool success, bytes memory returndata) = target.staticcall(data);
410         return _verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(address target, bytes memory data)
420         internal
421         returns (bytes memory)
422     {
423         return
424             functionDelegateCall(
425                 target,
426                 data,
427                 "Address: low-level delegate call failed"
428             );
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
433      * but performing a delegate call.
434      *
435      * _Available since v3.4._
436      */
437     function functionDelegateCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         require(isContract(target), "Address: delegate call to non-contract");
443 
444         // solhint-disable-next-line avoid-low-level-calls
445         (bool success, bytes memory returndata) = target.delegatecall(data);
446         return _verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     function _verifyCallResult(
450         bool success,
451         bytes memory returndata,
452         string memory errorMessage
453     ) private pure returns (bytes memory) {
454         if (success) {
455             return returndata;
456         } else {
457             // Look for revert reason and bubble it up if present
458             if (returndata.length > 0) {
459                 // The easiest way to bubble the revert reason is using memory via assembly
460 
461                 // solhint-disable-next-line no-inline-assembly
462                 assembly {
463                     let returndata_size := mload(returndata)
464                     revert(add(32, returndata), returndata_size)
465                 }
466             } else {
467                 revert(errorMessage);
468             }
469         }
470     }
471 }
472 
473 /*
474  * @dev Provides information about the current execution context, including the
475  * sender of the transaction and its data. While these are generally available
476  * via msg.sender and msg.data, they should not be accessed in such a direct
477  * manner, since when dealing with meta-transactions the account sending and
478  * paying for execution may not be the actual sender (as far as an application
479  * is concerned).
480  *
481  * This contract is only required for intermediate, library-like contracts.
482  */
483 abstract contract Context {
484     function _msgSender() internal view virtual returns (address) {
485         return msg.sender;
486     }
487 
488     function _msgData() internal view virtual returns (bytes calldata) {
489         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
490         return msg.data;
491     }
492 }
493 
494 /**
495  * @dev Implementation of the {IERC165} interface.
496  *
497  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
498  * for the additional interface id that will be supported. For example:
499  *
500  * ```solidity
501  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
503  * }
504  * ```
505  *
506  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
507  */
508 abstract contract ERC165 is IERC165 {
509     /**
510      * @dev See {IERC165-supportsInterface}.
511      */
512     function supportsInterface(bytes4 interfaceId)
513         public
514         view
515         virtual
516         override
517         returns (bool)
518     {
519         return interfaceId == type(IERC165).interfaceId;
520     }
521 }
522 
523 /**
524  *
525  * @dev Implementation of the basic standard multi-token.
526  * See https://eips.ethereum.org/EIPS/eip-1155
527  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
528  *
529  * _Available since v3.1._
530  */
531 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
532     using Address for address;
533 
534     // Mapping from token ID to account balances
535     mapping(uint256 => mapping(address => uint256)) private _balances;
536 
537     // Mapping from account to operator approvals
538     mapping(address => mapping(address => bool)) private _operatorApprovals;
539 
540     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
541     string private _uri;
542 
543     address private _owner;
544     address private _marketplace;
545     bool private _onlyMarketplace;
546 
547     /**
548      * @dev See {_setURI}.
549      */
550     constructor(string memory uri_) {
551         _setURI(uri_);
552         _owner = _msgSender();
553         _marketplace = _msgSender();
554         _onlyMarketplace = true;
555     }
556 
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId)
561         public
562         view
563         virtual
564         override(ERC165, IERC165)
565         returns (bool)
566     {
567         return
568             interfaceId == type(IERC1155).interfaceId ||
569             interfaceId == type(IERC1155MetadataURI).interfaceId ||
570             super.supportsInterface(interfaceId);
571     }
572 
573     function marketplace() external view returns (address) {
574         return _marketplace;
575     }
576 
577     function setMarketplace(address marketplaceAddress) external {
578         require(_msgSender() == _owner);
579         _marketplace = marketplaceAddress;
580     }
581 
582     function onlyMarketplace() external view returns (bool) {
583         return _onlyMarketplace;
584     }
585 
586     function setOnlyMarketplace(bool onlyMarketplaceAddress) external {
587         require(_msgSender() == _owner);
588         _onlyMarketplace = onlyMarketplaceAddress;
589     }
590 
591     /**
592      * @dev See {IERC1155MetadataURI-uri}.
593      *
594      * This implementation returns the same URI for *all* token types. It relies
595      * on the token type ID substitution mechanism
596      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
597      *
598      * Clients calling this function must replace the `\{id\}` substring with the
599      * actual token type ID.
600      */
601     function uri(uint256) public view virtual override returns (string memory) {
602         return _uri;
603     }
604 
605     /**
606      * @dev See {IERC1155-balanceOf}.
607      *
608      * Requirements:
609      *
610      * - `account` cannot be the zero address.
611      */
612     function balanceOf(address account, uint256 id)
613         public
614         view
615         virtual
616         override
617         returns (uint256)
618     {
619         require(
620             account != address(0),
621             "ERC1155: balance query for the zero address"
622         );
623         return _balances[id][account];
624     }
625 
626     /**
627      * @dev See {IERC1155-balanceOfBatch}.
628      *
629      * Requirements:
630      *
631      * - `accounts` and `ids` must have the same length.
632      */
633     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
634         public
635         view
636         virtual
637         override
638         returns (uint256[] memory)
639     {
640         require(
641             accounts.length == ids.length,
642             "ERC1155: accounts and ids length mismatch"
643         );
644 
645         uint256[] memory batchBalances = new uint256[](accounts.length);
646 
647         for (uint256 i = 0; i < accounts.length; ++i) {
648             batchBalances[i] = balanceOf(accounts[i], ids[i]);
649         }
650 
651         return batchBalances;
652     }
653 
654     /**
655      * @dev See {IERC1155-setApprovalForAll}.
656      */
657     function setApprovalForAll(address operator, bool approved)
658         public
659         virtual
660         override
661     {
662         require(
663             _msgSender() != operator,
664             "ERC1155: setting approval status for self"
665         );
666 
667         _operatorApprovals[_msgSender()][operator] = approved;
668         emit ApprovalForAll(_msgSender(), operator, approved);
669     }
670 
671     /**
672      * @dev See {IERC1155-isApprovedForAll}.
673      */
674     function isApprovedForAll(address account, address operator)
675         public
676         view
677         virtual
678         override
679         returns (bool)
680     {
681         return _operatorApprovals[account][operator];
682     }
683 
684     /**
685      * @dev See {IERC1155-safeTransferFrom}.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 id,
691         uint256 amount,
692         bytes memory data
693     ) public virtual override {
694         require(to != address(0), "ERC1155: transfer to the zero address");
695         require(
696             ((from == _msgSender() || isApprovedForAll(from, _msgSender())) &&
697                 !_onlyMarketplace) ||
698                 (_msgSender() == _marketplace && _onlyMarketplace),
699             "ERC1155: transfer caller is not owner nor approved"
700         );
701 
702         address operator = _msgSender();
703 
704         _beforeTokenTransfer(
705             operator,
706             from,
707             to,
708             _asSingletonArray(id),
709             _asSingletonArray(amount),
710             data
711         );
712 
713         uint256 fromBalance = _balances[id][from];
714         require(
715             fromBalance >= amount,
716             "ERC1155: insufficient balance for transfer"
717         );
718         _balances[id][from] = fromBalance - amount;
719         _balances[id][to] += amount;
720 
721         emit TransferSingle(operator, from, to, id, amount);
722 
723         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
724     }
725 
726     /**
727      * @dev See {IERC1155-safeBatchTransferFrom}.
728      */
729     function safeBatchTransferFrom(
730         address from,
731         address to,
732         uint256[] memory ids,
733         uint256[] memory amounts,
734         bytes memory data
735     ) public virtual override {
736         require(
737             ids.length == amounts.length,
738             "ERC1155: ids and amounts length mismatch"
739         );
740         require(to != address(0), "ERC1155: transfer to the zero address");
741         require(
742             ((from == _msgSender() || isApprovedForAll(from, _msgSender())) &&
743                 !_onlyMarketplace) ||
744                 (_msgSender() == _marketplace && _onlyMarketplace),
745             "ERC1155: transfer caller is not owner nor approved"
746         );
747 
748         address operator = _msgSender();
749 
750         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
751 
752         for (uint256 i = 0; i < ids.length; ++i) {
753             uint256 id = ids[i];
754             uint256 amount = amounts[i];
755 
756             uint256 fromBalance = _balances[id][from];
757             require(
758                 fromBalance >= amount,
759                 "ERC1155: insufficient balance for transfer"
760             );
761             _balances[id][from] = fromBalance - amount;
762             _balances[id][to] += amount;
763         }
764 
765         emit TransferBatch(operator, from, to, ids, amounts);
766 
767         _doSafeBatchTransferAcceptanceCheck(
768             operator,
769             from,
770             to,
771             ids,
772             amounts,
773             data
774         );
775     }
776 
777     /**
778      * @dev Sets a new URI for all token types, by relying on the token type ID
779      * substitution mechanism
780      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
781      *
782      * By this mechanism, any occurrence of the `\{id\}` substring in either the
783      * URI or any of the amounts in the JSON file at said URI will be replaced by
784      * clients with the token type ID.
785      *
786      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
787      * interpreted by clients as
788      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
789      * for token type ID 0x4cce0.
790      *
791      * See {uri}.
792      *
793      * Because these URIs cannot be meaningfully represented by the {URI} event,
794      * this function emits no events.
795      */
796     function _setURI(string memory newuri) internal virtual {
797         _uri = newuri;
798     }
799 
800     /**
801      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
802      *
803      * Emits a {TransferSingle} event.
804      *
805      * Requirements:
806      *
807      * - `account` cannot be the zero address.
808      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
809      * acceptance magic value.
810      */
811     function _mint(
812         address account,
813         uint256 id,
814         uint256 amount,
815         bytes memory data
816     ) internal virtual {
817         require(account != address(0), "ERC1155: mint to the zero address");
818 
819         address operator = _msgSender();
820 
821         _beforeTokenTransfer(
822             operator,
823             address(0),
824             account,
825             _asSingletonArray(id),
826             _asSingletonArray(amount),
827             data
828         );
829 
830         _balances[id][account] += amount;
831         emit TransferSingle(operator, address(0), account, id, amount);
832 
833         _doSafeTransferAcceptanceCheck(
834             operator,
835             address(0),
836             account,
837             id,
838             amount,
839             data
840         );
841     }
842 
843     /**
844      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
845      *
846      * Requirements:
847      *
848      * - `ids` and `amounts` must have the same length.
849      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
850      * acceptance magic value.
851      */
852     function _mintBatch(
853         address to,
854         uint256[] memory ids,
855         uint256[] memory amounts,
856         bytes memory data
857     ) internal virtual {
858         require(to != address(0), "ERC1155: mint to the zero address");
859         require(
860             ids.length == amounts.length,
861             "ERC1155: ids and amounts length mismatch"
862         );
863 
864         address operator = _msgSender();
865 
866         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
867 
868         for (uint256 i = 0; i < ids.length; i++) {
869             _balances[ids[i]][to] += amounts[i];
870         }
871 
872         emit TransferBatch(operator, address(0), to, ids, amounts);
873 
874         _doSafeBatchTransferAcceptanceCheck(
875             operator,
876             address(0),
877             to,
878             ids,
879             amounts,
880             data
881         );
882     }
883 
884     /**
885      * @dev Destroys `amount` tokens of token type `id` from `account`
886      *
887      * Requirements:
888      *
889      * - `account` cannot be the zero address.
890      * - `account` must have at least `amount` tokens of token type `id`.
891      */
892     function _burn(
893         address account,
894         uint256 id,
895         uint256 amount
896     ) internal virtual {
897         require(account != address(0), "ERC1155: burn from the zero address");
898 
899         address operator = _msgSender();
900 
901         _beforeTokenTransfer(
902             operator,
903             account,
904             address(0),
905             _asSingletonArray(id),
906             _asSingletonArray(amount),
907             ""
908         );
909 
910         uint256 accountBalance = _balances[id][account];
911         require(
912             accountBalance >= amount,
913             "ERC1155: burn amount exceeds balance"
914         );
915         _balances[id][account] = accountBalance - amount;
916 
917         emit TransferSingle(operator, account, address(0), id, amount);
918     }
919 
920     /**
921      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
922      *
923      * Requirements:
924      *
925      * - `ids` and `amounts` must have the same length.
926      */
927     function _burnBatch(
928         address account,
929         uint256[] memory ids,
930         uint256[] memory amounts
931     ) internal virtual {
932         require(account != address(0), "ERC1155: burn from the zero address");
933         require(
934             ids.length == amounts.length,
935             "ERC1155: ids and amounts length mismatch"
936         );
937 
938         address operator = _msgSender();
939 
940         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
941 
942         for (uint256 i = 0; i < ids.length; i++) {
943             uint256 id = ids[i];
944             uint256 amount = amounts[i];
945 
946             uint256 accountBalance = _balances[id][account];
947             require(
948                 accountBalance >= amount,
949                 "ERC1155: burn amount exceeds balance"
950             );
951             _balances[id][account] = accountBalance - amount;
952         }
953 
954         emit TransferBatch(operator, account, address(0), ids, amounts);
955     }
956 
957     /**
958      * @dev Hook that is called before any token transfer. This includes minting
959      * and burning, as well as batched variants.
960      *
961      * The same hook is called on both single and batched variants. For single
962      * transfers, the length of the `id` and `amount` arrays will be 1.
963      *
964      * Calling conditions (for each `id` and `amount` pair):
965      *
966      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
967      * of token type `id` will be  transferred to `to`.
968      * - When `from` is zero, `amount` tokens of token type `id` will be minted
969      * for `to`.
970      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
971      * will be burned.
972      * - `from` and `to` are never both zero.
973      * - `ids` and `amounts` have the same, non-zero length.
974      *
975      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
976      */
977     function _beforeTokenTransfer(
978         address operator,
979         address from,
980         address to,
981         uint256[] memory ids,
982         uint256[] memory amounts,
983         bytes memory data
984     ) internal virtual {}
985 
986     function _doSafeTransferAcceptanceCheck(
987         address operator,
988         address from,
989         address to,
990         uint256 id,
991         uint256 amount,
992         bytes memory data
993     ) private {
994         if (to.isContract()) {
995             try
996                 IERC1155Receiver(to).onERC1155Received(
997                     operator,
998                     from,
999                     id,
1000                     amount,
1001                     data
1002                 )
1003             returns (bytes4 response) {
1004                 if (
1005                     response != IERC1155Receiver(to).onERC1155Received.selector
1006                 ) {
1007                     revert("ERC1155: ERC1155Receiver rejected tokens");
1008                 }
1009             } catch Error(string memory reason) {
1010                 revert(reason);
1011             } catch {
1012                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1013             }
1014         }
1015     }
1016 
1017     function _doSafeBatchTransferAcceptanceCheck(
1018         address operator,
1019         address from,
1020         address to,
1021         uint256[] memory ids,
1022         uint256[] memory amounts,
1023         bytes memory data
1024     ) private {
1025         if (to.isContract()) {
1026             try
1027                 IERC1155Receiver(to).onERC1155BatchReceived(
1028                     operator,
1029                     from,
1030                     ids,
1031                     amounts,
1032                     data
1033                 )
1034             returns (bytes4 response) {
1035                 if (
1036                     response !=
1037                     IERC1155Receiver(to).onERC1155BatchReceived.selector
1038                 ) {
1039                     revert("ERC1155: ERC1155Receiver rejected tokens");
1040                 }
1041             } catch Error(string memory reason) {
1042                 revert(reason);
1043             } catch {
1044                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1045             }
1046         }
1047     }
1048 
1049     function _asSingletonArray(uint256 element)
1050         private
1051         pure
1052         returns (uint256[] memory)
1053     {
1054         uint256[] memory array = new uint256[](1);
1055         array[0] = element;
1056 
1057         return array;
1058     }
1059 }
1060 
1061 /**
1062  * @dev External interface of AccessControl declared to support ERC165 detection.
1063  */
1064 interface IAccessControl {
1065     function hasRole(bytes32 role, address account)
1066         external
1067         view
1068         returns (bool);
1069 
1070     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1071 
1072     function grantRole(bytes32 role, address account) external;
1073 
1074     function revokeRole(bytes32 role, address account) external;
1075 
1076     function renounceRole(bytes32 role, address account) external;
1077 }
1078 
1079 /**
1080  * @dev Contract module that allows children to implement role-based access
1081  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1082  * members except through off-chain means by accessing the contract event logs. Some
1083  * applications may benefit from on-chain enumerability, for those cases see
1084  * {AccessControlEnumerable}.
1085  *
1086  * Roles are referred to by their `bytes32` identifier. These should be exposed
1087  * in the external API and be unique. The best way to achieve this is by
1088  * using `public constant` hash digests:
1089  *
1090  * ```
1091  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1092  * ```
1093  *
1094  * Roles can be used to represent a set of permissions. To restrict access to a
1095  * function call, use {hasRole}:
1096  *
1097  * ```
1098  * function foo() public {
1099  *     require(hasRole(MY_ROLE, msg.sender));
1100  *     ...
1101  * }
1102  * ```
1103  *
1104  * Roles can be granted and revoked dynamically via the {grantRole} and
1105  * {revokeRole} functions. Each role has an associated admin role, and only
1106  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1107  *
1108  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1109  * that only accounts with this role will be able to grant or revoke other
1110  * roles. More complex role relationships can be created by using
1111  * {_setRoleAdmin}.
1112  *
1113  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1114  * grant and revoke this role. Extra precautions should be taken to secure
1115  * accounts that have been granted it.
1116  */
1117 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1118     struct RoleData {
1119         mapping(address => bool) members;
1120         bytes32 adminRole;
1121     }
1122 
1123     mapping(bytes32 => RoleData) private _roles;
1124 
1125     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1126 
1127     /**
1128      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1129      *
1130      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1131      * {RoleAdminChanged} not being emitted signaling this.
1132      *
1133      * _Available since v3.1._
1134      */
1135     event RoleAdminChanged(
1136         bytes32 indexed role,
1137         bytes32 indexed previousAdminRole,
1138         bytes32 indexed newAdminRole
1139     );
1140 
1141     /**
1142      * @dev Emitted when `account` is granted `role`.
1143      *
1144      * `sender` is the account that originated the contract call, an admin role
1145      * bearer except when using {_setupRole}.
1146      */
1147     event RoleGranted(
1148         bytes32 indexed role,
1149         address indexed account,
1150         address indexed sender
1151     );
1152 
1153     /**
1154      * @dev Emitted when `account` is revoked `role`.
1155      *
1156      * `sender` is the account that originated the contract call:
1157      *   - if using `revokeRole`, it is the admin role bearer
1158      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1159      */
1160     event RoleRevoked(
1161         bytes32 indexed role,
1162         address indexed account,
1163         address indexed sender
1164     );
1165 
1166     /**
1167      * @dev See {IERC165-supportsInterface}.
1168      */
1169     function supportsInterface(bytes4 interfaceId)
1170         public
1171         view
1172         virtual
1173         override
1174         returns (bool)
1175     {
1176         return
1177             interfaceId == type(IAccessControl).interfaceId ||
1178             super.supportsInterface(interfaceId);
1179     }
1180 
1181     /**
1182      * @dev Returns `true` if `account` has been granted `role`.
1183      */
1184     function hasRole(bytes32 role, address account)
1185         public
1186         view
1187         override
1188         returns (bool)
1189     {
1190         return _roles[role].members[account];
1191     }
1192 
1193     /**
1194      * @dev Returns the admin role that controls `role`. See {grantRole} and
1195      * {revokeRole}.
1196      *
1197      * To change a role's admin, use {_setRoleAdmin}.
1198      */
1199     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1200         return _roles[role].adminRole;
1201     }
1202 
1203     /**
1204      * @dev Grants `role` to `account`.
1205      *
1206      * If `account` had not been already granted `role`, emits a {RoleGranted}
1207      * event.
1208      *
1209      * Requirements:
1210      *
1211      * - the caller must have ``role``'s admin role.
1212      */
1213     function grantRole(bytes32 role, address account) public virtual override {
1214         require(
1215             hasRole(getRoleAdmin(role), _msgSender()),
1216             "AccessControl: sender must be an admin to grant"
1217         );
1218 
1219         _grantRole(role, account);
1220     }
1221 
1222     /**
1223      * @dev Revokes `role` from `account`.
1224      *
1225      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1226      *
1227      * Requirements:
1228      *
1229      * - the caller must have ``role``'s admin role.
1230      */
1231     function revokeRole(bytes32 role, address account) public virtual override {
1232         require(
1233             hasRole(getRoleAdmin(role), _msgSender()),
1234             "AccessControl: sender must be an admin to revoke"
1235         );
1236 
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
1254     function renounceRole(bytes32 role, address account)
1255         public
1256         virtual
1257         override
1258     {
1259         require(
1260             account == _msgSender(),
1261             "AccessControl: can only renounce roles for self"
1262         );
1263 
1264         _revokeRole(role, account);
1265     }
1266 
1267     /**
1268      * @dev Grants `role` to `account`.
1269      *
1270      * If `account` had not been already granted `role`, emits a {RoleGranted}
1271      * event. Note that unlike {grantRole}, this function doesn't perform any
1272      * checks on the calling account.
1273      *
1274      * [WARNING]
1275      * ====
1276      * This function should only be called from the constructor when setting
1277      * up the initial roles for the system.
1278      *
1279      * Using this function in any other way is effectively circumventing the admin
1280      * system imposed by {AccessControl}.
1281      * ====
1282      */
1283     function _setupRole(bytes32 role, address account) internal virtual {
1284         _grantRole(role, account);
1285     }
1286 
1287     /**
1288      * @dev Sets `adminRole` as ``role``'s admin role.
1289      *
1290      * Emits a {RoleAdminChanged} event.
1291      */
1292     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1293         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1294         _roles[role].adminRole = adminRole;
1295     }
1296 
1297     function _grantRole(bytes32 role, address account) private {
1298         if (!hasRole(role, account)) {
1299             _roles[role].members[account] = true;
1300             emit RoleGranted(role, account, _msgSender());
1301         }
1302     }
1303 
1304     function _revokeRole(bytes32 role, address account) private {
1305         if (hasRole(role, account)) {
1306             _roles[role].members[account] = false;
1307             emit RoleRevoked(role, account, _msgSender());
1308         }
1309     }
1310 }
1311 
1312 /**
1313  * @title Counters
1314  * @author Matt Condon (@shrugs)
1315  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1316  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1317  *
1318  * Include with `using Counters for Counters.Counter;`
1319  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1320  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1321  * directly accessed.
1322  */
1323 library Counters {
1324     struct Counter {
1325         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1326         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1327         // this feature: see https://github.com/ethereum/solidity/issues/4637
1328         uint256 _value; // default: 0
1329     }
1330 
1331     function current(Counter storage counter) internal view returns (uint256) {
1332         return counter._value;
1333     }
1334 
1335     function increment(Counter storage counter) internal {
1336         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1337         counter._value += 1;
1338     }
1339 
1340     function decrement(Counter storage counter) internal {
1341         counter._value = counter._value - 1;
1342     }
1343 }
1344 
1345 contract SatoshiART1155 is ERC1155, AccessControl {
1346     using Counters for Counters.Counter;
1347 
1348     Counters.Counter private _tokenIds;
1349 
1350     struct Token {
1351         address creator;
1352         uint256 royalty;
1353     }
1354     mapping(uint256 => Token) private _token;
1355 
1356     bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
1357 
1358     bool private _anyAddressCanCreateItem = false;
1359 
1360     event ApprovalForItemCreator(
1361         address contractOwner,
1362         address itemCreator,
1363         bool approved
1364     );
1365 
1366     constructor()
1367         ERC1155(
1368             "www.satoshi.art/api/public/tokens/{id}"
1369         )
1370     {
1371         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1372     }
1373 
1374     function supportsInterface(bytes4 interfaceId)
1375         public
1376         view
1377         virtual
1378         override(ERC1155, AccessControl)
1379         returns (bool)
1380     {
1381         return super.supportsInterface(interfaceId);
1382     }
1383 
1384     function setAnyAddressCanCreateItem(bool isAnyAddressCanCreateItem) public {
1385         require(
1386             hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
1387             "Caller is not an admin"
1388         );
1389         _anyAddressCanCreateItem = isAnyAddressCanCreateItem;
1390     }
1391 
1392     function anyAddressCanCreateItem() public view returns (bool) {
1393         return _anyAddressCanCreateItem;
1394     }
1395 
1396     function createItem(
1397         uint256 amount,
1398         uint256 royalty //multiplier:10000
1399     ) external returns (uint256[] memory) {
1400         require(
1401             _anyAddressCanCreateItem || hasRole(CREATOR_ROLE, _msgSender()),
1402             "Address is not approved for creating new item."
1403         );
1404         require(royalty <= 1000, "Royalty is too high");
1405 
1406         uint256[] memory newItemIds = new uint256[](amount);
1407         uint256[] memory amounts = new uint256[](amount);
1408         for (uint256 i = 0; i < amount; i++) {
1409             _tokenIds.increment();
1410             newItemIds[i] = _tokenIds.current();
1411             amounts[i] = 1;
1412         }
1413         _mintBatch(_msgSender(), newItemIds, amounts, "");
1414 
1415         for (uint256 i = 0; i < newItemIds.length; i++) {
1416             _token[newItemIds[i]] = Token({
1417                 creator: _msgSender(),
1418                 royalty: royalty
1419             });
1420         }
1421 
1422         return newItemIds;
1423     }
1424 
1425     function tokenCreator(uint256 _id) external view returns (address) {
1426         return _token[_id].creator;
1427     }
1428 
1429     function tokenRoyalty(uint256 _id) external view returns (uint256) {
1430         return _token[_id].royalty;
1431     }
1432 }