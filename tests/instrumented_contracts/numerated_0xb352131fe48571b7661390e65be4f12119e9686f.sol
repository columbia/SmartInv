1 pragma solidity ^0.8.0;
2 
3 /**
4 * The Chic-A-Dees contract was deployed by Ownerfy Inc. of Ownerfy.com
5 * Visit Ownerfy.com for exclusive NFT drops or inquiries for your project.
6 *
7 * This contract is not a proxy.
8 * This contract is not pausable.
9 * This contract is not lockable.
10 * This contract cannot be rug pulled.
11 * The URIs are not changeable after mint.
12 * This contract uses IPFS
13 * This contract puts SHA256 media hash into the Update event for permanent on-chain documentation
14 * The NFT Owners and only the NFT Owners have complete control over their NFTs
15 */
16 
17 // From base:
18 // https://docs.openzeppelin.com/contracts/4.x/erc1155
19 
20 /**
21  * @dev Interface of the ERC165 standard, as defined in the
22  * https://eips.ethereum.org/EIPS/eip-165[EIP].
23  *
24  * Implementers can declare support of contract interfaces, which can then be
25  * queried by others ({ERC165Checker}).
26  *
27  * For an implementation, see {ERC165}.
28  */
29 interface IERC165 {
30     /**
31      * @dev Returns true if this contract implements the interface defined by
32      * `interfaceId`. See the corresponding
33      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
34      * to learn more about how these ids are created.
35      *
36      * This function call must use less than 30 000 gas.
37      */
38     function supportsInterface(bytes4 interfaceId) external view returns (bool);
39 }
40 
41 /**
42  * @dev Required interface of an ERC1155 compliant contract, as defined in the
43  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
44  *
45  * _Available since v3.1._
46  */
47 interface IERC1155 is IERC165 {
48     /**
49      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
50      */
51     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
52 
53     /**
54      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
55      * transfers.
56      */
57     event TransferBatch(
58         address indexed operator,
59         address indexed from,
60         address indexed to,
61         uint256[] ids,
62         uint256[] values
63     );
64 
65     /**
66      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
67      * `approved`.
68      */
69     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
70 
71     /**
72      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
73      *
74      * If an {URI} event was emitted for `id`, the standard
75      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
76      * returned by {IERC1155MetadataURI-uri}.
77      */
78     event URI(string value, uint256 indexed id);
79 
80     /**
81      * @dev Returns the amount of tokens of token type `id` owned by `account`.
82      *
83      * Requirements:
84      *
85      * - `account` cannot be the zero address.
86      */
87     function balanceOf(address account, uint256 id) external view returns (uint256);
88 
89     /**
90      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
91      *
92      * Requirements:
93      *
94      * - `accounts` and `ids` must have the same length.
95      */
96     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
97         external
98         view
99         returns (uint256[] memory);
100 
101     /**
102      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
103      *
104      * Emits an {ApprovalForAll} event.
105      *
106      * Requirements:
107      *
108      * - `operator` cannot be the caller.
109      */
110     function setApprovalForAll(address operator, bool approved) external;
111 
112     /**
113      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
114      *
115      * See {setApprovalForAll}.
116      */
117     function isApprovedForAll(address account, address operator) external view returns (bool);
118 
119     /**
120      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
121      *
122      * Emits a {TransferSingle} event.
123      *
124      * Requirements:
125      *
126      * - `to` cannot be the zero address.
127      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
128      * - `from` must have a balance of tokens of type `id` of at least `amount`.
129      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
130      * acceptance magic value.
131      */
132     function safeTransferFrom(
133         address from,
134         address to,
135         uint256 id,
136         uint256 amount,
137         bytes calldata data
138     ) external;
139 
140     /**
141      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
142      *
143      * Emits a {TransferBatch} event.
144      *
145      * Requirements:
146      *
147      * - `ids` and `amounts` must have the same length.
148      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
149      * acceptance magic value.
150      */
151     function safeBatchTransferFrom(
152         address from,
153         address to,
154         uint256[] calldata ids,
155         uint256[] calldata amounts,
156         bytes calldata data
157     ) external;
158 }
159 
160 
161 
162 /**
163  * @dev _Available since v3.1._
164  */
165 interface IERC1155Receiver is IERC165 {
166     /**
167         @dev Handles the receipt of a single ERC1155 token type. This function is
168         called at the end of a `safeTransferFrom` after the balance has been updated.
169         To accept the transfer, this must return
170         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
171         (i.e. 0xf23a6e61, or its own function selector).
172         @param operator The address which initiated the transfer (i.e. msg.sender)
173         @param from The address which previously owned the token
174         @param id The ID of the token being transferred
175         @param value The amount of tokens being transferred
176         @param data Additional data with no specified format
177         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
178     */
179     function onERC1155Received(
180         address operator,
181         address from,
182         uint256 id,
183         uint256 value,
184         bytes calldata data
185     ) external returns (bytes4);
186 
187     /**
188         @dev Handles the receipt of a multiple ERC1155 token types. This function
189         is called at the end of a `safeBatchTransferFrom` after the balances have
190         been updated. To accept the transfer(s), this must return
191         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
192         (i.e. 0xbc197c81, or its own function selector).
193         @param operator The address which initiated the batch transfer (i.e. msg.sender)
194         @param from The address which previously owned the token
195         @param ids An array containing ids of each token being transferred (order and length must match values array)
196         @param values An array containing amounts of each token being transferred (order and length must match ids array)
197         @param data Additional data with no specified format
198         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
199     */
200     function onERC1155BatchReceived(
201         address operator,
202         address from,
203         uint256[] calldata ids,
204         uint256[] calldata values,
205         bytes calldata data
206     ) external returns (bytes4);
207 }
208 
209 
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
356         return _verifyCallResult(success, returndata, errorMessage);
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
383         return _verifyCallResult(success, returndata, errorMessage);
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
410         return _verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     function _verifyCallResult(
414         bool success,
415         bytes memory returndata,
416         string memory errorMessage
417     ) private pure returns (bytes memory) {
418         if (success) {
419             return returndata;
420         } else {
421             // Look for revert reason and bubble it up if present
422             if (returndata.length > 0) {
423                 // The easiest way to bubble the revert reason is using memory via assembly
424 
425                 assembly {
426                     let returndata_size := mload(returndata)
427                     revert(add(32, returndata), returndata_size)
428                 }
429             } else {
430                 revert(errorMessage);
431             }
432         }
433     }
434 }
435 
436 
437 
438 /*
439  * @dev Provides information about the current execution context, including the
440  * sender of the transaction and its data. While these are generally available
441  * via msg.sender and msg.data, they should not be accessed in such a direct
442  * manner, since when dealing with meta-transactions the account sending and
443  * paying for execution may not be the actual sender (as far as an application
444  * is concerned).
445  *
446  * This contract is only required for intermediate, library-like contracts.
447  */
448 abstract contract Context {
449     function _msgSender() internal view virtual returns (address) {
450         return msg.sender;
451     }
452 
453     function _msgData() internal view virtual returns (bytes calldata) {
454         return msg.data;
455     }
456 }
457 
458 
459 
460 /**
461  * @dev Implementation of the {IERC165} interface.
462  *
463  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
464  * for the additional interface id that will be supported. For example:
465  *
466  * ```solidity
467  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
468  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
469  * }
470  * ```
471  *
472  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
473  */
474 abstract contract ERC165 is IERC165 {
475     /**
476      * @dev See {IERC165-supportsInterface}.
477      */
478     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
479         return interfaceId == type(IERC165).interfaceId;
480     }
481 }
482 
483 /**
484  * @dev Implementation of the basic standard multi-token.
485  * See https://eips.ethereum.org/EIPS/eip-1155
486  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
487  *
488  * _Available since v3.1._
489  */
490 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
491     using Address for address;
492 
493     // Mapping from token ID to account balances
494     mapping(uint256 => mapping(address => uint256)) private _balances;
495 
496     // Mapping from account to operator approvals
497     mapping(address => mapping(address => bool)) private _operatorApprovals;
498 
499     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
500     string private _uri;
501 
502     /**
503      * @dev See {_setURI}.
504      */
505     constructor(string memory uri_) {
506         _setURI(uri_);
507     }
508 
509     /**
510      * @dev See {IERC165-supportsInterface}.
511      */
512     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
513         return
514             interfaceId == type(IERC1155).interfaceId ||
515             interfaceId == type(IERC1155MetadataURI).interfaceId ||
516             super.supportsInterface(interfaceId);
517     }
518 
519     /**
520      * @dev See {IERC1155MetadataURI-uri}.
521      *
522      * This implementation returns the same URI for *all* token types. It relies
523      * on the token type ID substitution mechanism
524      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
525      *
526      * Clients calling this function must replace the `\{id\}` substring with the
527      * actual token type ID.
528      */
529     function uri(uint256) public view virtual override returns (string memory) {
530         return _uri;
531     }
532 
533     /**
534      * @dev See {IERC1155-balanceOf}.
535      *
536      * Requirements:
537      *
538      * - `account` cannot be the zero address.
539      */
540     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
541         require(account != address(0), "ERC1155: balance query for the zero address");
542         return _balances[id][account];
543     }
544 
545     /**
546      * @dev See {IERC1155-balanceOfBatch}.
547      *
548      * Requirements:
549      *
550      * - `accounts` and `ids` must have the same length.
551      */
552     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
553         public
554         view
555         virtual
556         override
557         returns (uint256[] memory)
558     {
559         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
560 
561         uint256[] memory batchBalances = new uint256[](accounts.length);
562 
563         for (uint256 i = 0; i < accounts.length; ++i) {
564             batchBalances[i] = balanceOf(accounts[i], ids[i]);
565         }
566 
567         return batchBalances;
568     }
569 
570     /**
571      * @dev See {IERC1155-setApprovalForAll}.
572      */
573     function setApprovalForAll(address operator, bool approved) public virtual override {
574         require(_msgSender() != operator, "ERC1155: setting approval status for self");
575 
576         _operatorApprovals[_msgSender()][operator] = approved;
577         emit ApprovalForAll(_msgSender(), operator, approved);
578     }
579 
580     /**
581      * @dev See {IERC1155-isApprovedForAll}.
582      */
583     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
584         return _operatorApprovals[account][operator];
585     }
586 
587     /**
588      * @dev See {IERC1155-safeTransferFrom}.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 id,
594         uint256 amount,
595         bytes memory data
596     ) public virtual override {
597         require(
598             from == _msgSender() || isApprovedForAll(from, _msgSender()),
599             "ERC1155: caller is not owner nor approved"
600         );
601         _safeTransferFrom(from, to, id, amount, data);
602     }
603 
604     /**
605      * @dev See {IERC1155-safeBatchTransferFrom}.
606      */
607     function safeBatchTransferFrom(
608         address from,
609         address to,
610         uint256[] memory ids,
611         uint256[] memory amounts,
612         bytes memory data
613     ) public virtual override {
614         require(
615             from == _msgSender() || isApprovedForAll(from, _msgSender()),
616             "ERC1155: transfer caller is not owner nor approved"
617         );
618         _safeBatchTransferFrom(from, to, ids, amounts, data);
619     }
620 
621     /**
622      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
623      *
624      * Emits a {TransferSingle} event.
625      *
626      * Requirements:
627      *
628      * - `to` cannot be the zero address.
629      * - `from` must have a balance of tokens of type `id` of at least `amount`.
630      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
631      * acceptance magic value.
632      */
633     function _safeTransferFrom(
634         address from,
635         address to,
636         uint256 id,
637         uint256 amount,
638         bytes memory data
639     ) internal virtual {
640         require(to != address(0), "ERC1155: transfer to the zero address");
641 
642         address operator = _msgSender();
643 
644         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
645 
646         uint256 fromBalance = _balances[id][from];
647         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
648         unchecked {
649             _balances[id][from] = fromBalance - amount;
650         }
651         _balances[id][to] += amount;
652 
653         emit TransferSingle(operator, from, to, id, amount);
654 
655         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
656     }
657 
658     /**
659      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
660      *
661      * Emits a {TransferBatch} event.
662      *
663      * Requirements:
664      *
665      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
666      * acceptance magic value.
667      */
668     function _safeBatchTransferFrom(
669         address from,
670         address to,
671         uint256[] memory ids,
672         uint256[] memory amounts,
673         bytes memory data
674     ) internal virtual {
675         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
676         require(to != address(0), "ERC1155: transfer to the zero address");
677 
678         address operator = _msgSender();
679 
680         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
681 
682         for (uint256 i = 0; i < ids.length; ++i) {
683             uint256 id = ids[i];
684             uint256 amount = amounts[i];
685 
686             uint256 fromBalance = _balances[id][from];
687             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
688             unchecked {
689                 _balances[id][from] = fromBalance - amount;
690             }
691             _balances[id][to] += amount;
692         }
693 
694         emit TransferBatch(operator, from, to, ids, amounts);
695 
696         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
697     }
698 
699     /**
700      * @dev Sets a new URI for all token types, by relying on the token type ID
701      * substitution mechanism
702      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
703      *
704      * By this mechanism, any occurrence of the `\{id\}` substring in either the
705      * URI or any of the amounts in the JSON file at said URI will be replaced by
706      * clients with the token type ID.
707      *
708      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
709      * interpreted by clients as
710      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
711      * for token type ID 0x4cce0.
712      *
713      * See {uri}.
714      *
715      * Because these URIs cannot be meaningfully represented by the {URI} event,
716      * this function emits no events.
717      */
718     function _setURI(string memory newuri) internal virtual {
719         _uri = newuri;
720     }
721 
722     /**
723      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
724      *
725      * Emits a {TransferSingle} event.
726      *
727      * Requirements:
728      *
729      * - `account` cannot be the zero address.
730      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
731      * acceptance magic value.
732      */
733     function _mint(
734         address account,
735         uint256 id,
736         uint256 amount,
737         bytes memory data
738     ) internal virtual {
739         require(account != address(0), "ERC1155: mint to the zero address");
740 
741         address operator = _msgSender();
742 
743         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
744 
745         _balances[id][account] += amount;
746         emit TransferSingle(operator, address(0), account, id, amount);
747 
748         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
749     }
750 
751     /**
752      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
753      *
754      * Requirements:
755      *
756      * - `ids` and `amounts` must have the same length.
757      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
758      * acceptance magic value.
759      */
760     function _mintBatch(
761         address to,
762         uint256[] memory ids,
763         uint256[] memory amounts,
764         bytes memory data
765     ) internal virtual {
766         require(to != address(0), "ERC1155: mint to the zero address");
767         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
768 
769         address operator = _msgSender();
770 
771         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
772 
773         for (uint256 i = 0; i < ids.length; i++) {
774             _balances[ids[i]][to] += amounts[i];
775         }
776 
777         emit TransferBatch(operator, address(0), to, ids, amounts);
778 
779         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
780     }
781 
782     /**
783      * @dev Destroys `amount` tokens of token type `id` from `account`
784      *
785      * Requirements:
786      *
787      * - `account` cannot be the zero address.
788      * - `account` must have at least `amount` tokens of token type `id`.
789      */
790     function _burn(
791         address account,
792         uint256 id,
793         uint256 amount
794     ) internal virtual {
795         require(account != address(0), "ERC1155: burn from the zero address");
796 
797         address operator = _msgSender();
798 
799         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
800 
801         uint256 accountBalance = _balances[id][account];
802         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
803         unchecked {
804             _balances[id][account] = accountBalance - amount;
805         }
806 
807         emit TransferSingle(operator, account, address(0), id, amount);
808     }
809 
810     /**
811      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
812      *
813      * Requirements:
814      *
815      * - `ids` and `amounts` must have the same length.
816      */
817     function _burnBatch(
818         address account,
819         uint256[] memory ids,
820         uint256[] memory amounts
821     ) internal virtual {
822         require(account != address(0), "ERC1155: burn from the zero address");
823         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
824 
825         address operator = _msgSender();
826 
827         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
828 
829         for (uint256 i = 0; i < ids.length; i++) {
830             uint256 id = ids[i];
831             uint256 amount = amounts[i];
832 
833             uint256 accountBalance = _balances[id][account];
834             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
835             unchecked {
836                 _balances[id][account] = accountBalance - amount;
837             }
838         }
839 
840         emit TransferBatch(operator, account, address(0), ids, amounts);
841     }
842 
843     /**
844      * @dev Hook that is called before any token transfer. This includes minting
845      * and burning, as well as batched variants.
846      *
847      * The same hook is called on both single and batched variants. For single
848      * transfers, the length of the `id` and `amount` arrays will be 1.
849      *
850      * Calling conditions (for each `id` and `amount` pair):
851      *
852      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
853      * of token type `id` will be  transferred to `to`.
854      * - When `from` is zero, `amount` tokens of token type `id` will be minted
855      * for `to`.
856      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
857      * will be burned.
858      * - `from` and `to` are never both zero.
859      * - `ids` and `amounts` have the same, non-zero length.
860      *
861      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
862      */
863     function _beforeTokenTransfer(
864         address operator,
865         address from,
866         address to,
867         uint256[] memory ids,
868         uint256[] memory amounts,
869         bytes memory data
870     ) internal virtual {}
871 
872     function _doSafeTransferAcceptanceCheck(
873         address operator,
874         address from,
875         address to,
876         uint256 id,
877         uint256 amount,
878         bytes memory data
879     ) private {
880         if (to.isContract()) {
881             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
882                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
883                     revert("ERC1155: ERC1155Receiver rejected tokens");
884                 }
885             } catch Error(string memory reason) {
886                 revert(reason);
887             } catch {
888                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
889             }
890         }
891     }
892 
893     function _doSafeBatchTransferAcceptanceCheck(
894         address operator,
895         address from,
896         address to,
897         uint256[] memory ids,
898         uint256[] memory amounts,
899         bytes memory data
900     ) private {
901         if (to.isContract()) {
902             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
903                 bytes4 response
904             ) {
905                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
906                     revert("ERC1155: ERC1155Receiver rejected tokens");
907                 }
908             } catch Error(string memory reason) {
909                 revert(reason);
910             } catch {
911                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
912             }
913         }
914     }
915 
916     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
917         uint256[] memory array = new uint256[](1);
918         array[0] = element;
919 
920         return array;
921     }
922 }
923 
924 
925 
926 /**
927  * @dev Extension of {ERC1155} that allows token holders to destroy both their
928  * own tokens and those that they have been approved to use.
929  *
930  * _Available since v3.1._
931  */
932 abstract contract ERC1155Burnable is ERC1155 {
933     function burn(
934         address account,
935         uint256 id,
936         uint256 value
937     ) public virtual {
938         require(
939             account == _msgSender() || isApprovedForAll(account, _msgSender()),
940             "ERC1155: caller is not owner nor approved"
941         );
942 
943         _burn(account, id, value);
944     }
945 
946     function burnBatch(
947         address account,
948         uint256[] memory ids,
949         uint256[] memory values
950     ) public virtual {
951         require(
952             account == _msgSender() || isApprovedForAll(account, _msgSender()),
953             "ERC1155: caller is not owner nor approved"
954         );
955 
956         _burnBatch(account, ids, values);
957     }
958 }
959 
960 
961 
962 
963 
964 
965 
966 /**
967  * @dev String operations.
968  */
969 library Strings {
970     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
971 
972     /**
973      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
974      */
975     function toString(uint256 value) internal pure returns (string memory) {
976         // Inspired by OraclizeAPI's implementation - MIT licence
977         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
978 
979         if (value == 0) {
980             return "0";
981         }
982         uint256 temp = value;
983         uint256 digits;
984         while (temp != 0) {
985             digits++;
986             temp /= 10;
987         }
988         bytes memory buffer = new bytes(digits);
989         while (value != 0) {
990             digits -= 1;
991             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
992             value /= 10;
993         }
994         return string(buffer);
995     }
996 
997     /**
998      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
999      */
1000     function toHexString(uint256 value) internal pure returns (string memory) {
1001         if (value == 0) {
1002             return "0x00";
1003         }
1004         uint256 temp = value;
1005         uint256 length = 0;
1006         while (temp != 0) {
1007             length++;
1008             temp >>= 8;
1009         }
1010         return toHexString(value, length);
1011     }
1012 
1013     /**
1014      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1015      */
1016     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1017         bytes memory buffer = new bytes(2 * length + 2);
1018         buffer[0] = "0";
1019         buffer[1] = "x";
1020         for (uint256 i = 2 * length + 1; i > 1; --i) {
1021             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1022             value >>= 4;
1023         }
1024         require(value == 0, "Strings: hex length insufficient");
1025         return string(buffer);
1026     }
1027 }
1028 
1029 /**
1030  * @dev External interface of AccessControl declared to support ERC165 detection.
1031  */
1032 interface IAccessControl {
1033     function hasRole(bytes32 role, address account) external view returns (bool);
1034 
1035     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1036 
1037     function grantRole(bytes32 role, address account) external;
1038 
1039     function revokeRole(bytes32 role, address account) external;
1040 
1041     function renounceRole(bytes32 role, address account) external;
1042 }
1043 
1044 /**
1045  * @dev Contract module that allows children to implement role-based access
1046  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1047  * members except through off-chain means by accessing the contract event logs. Some
1048  * applications may benefit from on-chain enumerability, for those cases see
1049  * {AccessControlEnumerable}.
1050  *
1051  * Roles are referred to by their `bytes32` identifier. These should be exposed
1052  * in the external API and be unique. The best way to achieve this is by
1053  * using `public constant` hash digests:
1054  *
1055  * ```
1056  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1057  * ```
1058  *
1059  * Roles can be used to represent a set of permissions. To restrict access to a
1060  * function call, use {hasRole}:
1061  *
1062  * ```
1063  * function foo() public {
1064  *     require(hasRole(MY_ROLE, msg.sender));
1065  *     ...
1066  * }
1067  * ```
1068  *
1069  * Roles can be granted and revoked dynamically via the {grantRole} and
1070  * {revokeRole} functions. Each role has an associated admin role, and only
1071  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1072  *
1073  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1074  * that only accounts with this role will be able to grant or revoke other
1075  * roles. More complex role relationships can be created by using
1076  * {_setRoleAdmin}.
1077  *
1078  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1079  * grant and revoke this role. Extra precautions should be taken to secure
1080  * accounts that have been granted it.
1081  */
1082 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1083     struct RoleData {
1084         mapping(address => bool) members;
1085         bytes32 adminRole;
1086     }
1087 
1088     mapping(bytes32 => RoleData) private _roles;
1089 
1090     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1091 
1092     /**
1093      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1094      *
1095      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1096      * {RoleAdminChanged} not being emitted signaling this.
1097      *
1098      * _Available since v3.1._
1099      */
1100     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1101 
1102     /**
1103      * @dev Emitted when `account` is granted `role`.
1104      *
1105      * `sender` is the account that originated the contract call, an admin role
1106      * bearer except when using {_setupRole}.
1107      */
1108     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1109 
1110     /**
1111      * @dev Emitted when `account` is revoked `role`.
1112      *
1113      * `sender` is the account that originated the contract call:
1114      *   - if using `revokeRole`, it is the admin role bearer
1115      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1116      */
1117     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1118 
1119     /**
1120      * @dev Modifier that checks that an account has a specific role. Reverts
1121      * with a standardized message including the required role.
1122      *
1123      * The format of the revert reason is given by the following regular expression:
1124      *
1125      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1126      *
1127      * _Available since v4.1._
1128      */
1129     modifier onlyRole(bytes32 role) {
1130         _checkRole(role, _msgSender());
1131         _;
1132     }
1133 
1134     /**
1135      * @dev See {IERC165-supportsInterface}.
1136      */
1137     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1138         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1139     }
1140 
1141     /**
1142      * @dev Returns `true` if `account` has been granted `role`.
1143      */
1144     function hasRole(bytes32 role, address account) public view override returns (bool) {
1145         return _roles[role].members[account];
1146     }
1147 
1148     /**
1149      * @dev Revert with a standard message if `account` is missing `role`.
1150      *
1151      * The format of the revert reason is given by the following regular expression:
1152      *
1153      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1154      */
1155     function _checkRole(bytes32 role, address account) internal view {
1156         if (!hasRole(role, account)) {
1157             revert(
1158                 string(
1159                     abi.encodePacked(
1160                         "AccessControl: account ",
1161                         Strings.toHexString(uint160(account), 20),
1162                         " is missing role ",
1163                         Strings.toHexString(uint256(role), 32)
1164                     )
1165                 )
1166             );
1167         }
1168     }
1169 
1170     /**
1171      * @dev Returns the admin role that controls `role`. See {grantRole} and
1172      * {revokeRole}.
1173      *
1174      * To change a role's admin, use {_setRoleAdmin}.
1175      */
1176     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1177         return _roles[role].adminRole;
1178     }
1179 
1180     /**
1181      * @dev Grants `role` to `account`.
1182      *
1183      * If `account` had not been already granted `role`, emits a {RoleGranted}
1184      * event.
1185      *
1186      * Requirements:
1187      *
1188      * - the caller must have ``role``'s admin role.
1189      */
1190     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1191         _grantRole(role, account);
1192     }
1193 
1194     /**
1195      * @dev Revokes `role` from `account`.
1196      *
1197      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1198      *
1199      * Requirements:
1200      *
1201      * - the caller must have ``role``'s admin role.
1202      */
1203     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1204         _revokeRole(role, account);
1205     }
1206 
1207     /**
1208      * @dev Revokes `role` from the calling account.
1209      *
1210      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1211      * purpose is to provide a mechanism for accounts to lose their privileges
1212      * if they are compromised (such as when a trusted device is misplaced).
1213      *
1214      * If the calling account had been granted `role`, emits a {RoleRevoked}
1215      * event.
1216      *
1217      * Requirements:
1218      *
1219      * - the caller must be `account`.
1220      */
1221     function renounceRole(bytes32 role, address account) public virtual override {
1222         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1223 
1224         _revokeRole(role, account);
1225     }
1226 
1227     /**
1228      * @dev Grants `role` to `account`.
1229      *
1230      * If `account` had not been already granted `role`, emits a {RoleGranted}
1231      * event. Note that unlike {grantRole}, this function doesn't perform any
1232      * checks on the calling account.
1233      *
1234      * [WARNING]
1235      * ====
1236      * This function should only be called from the constructor when setting
1237      * up the initial roles for the system.
1238      *
1239      * Using this function in any other way is effectively circumventing the admin
1240      * system imposed by {AccessControl}.
1241      * ====
1242      */
1243     function _setupRole(bytes32 role, address account) internal virtual {
1244         _grantRole(role, account);
1245     }
1246 
1247     /**
1248      * @dev Sets `adminRole` as ``role``'s admin role.
1249      *
1250      * Emits a {RoleAdminChanged} event.
1251      */
1252     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1253         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1254         _roles[role].adminRole = adminRole;
1255     }
1256 
1257     function _grantRole(bytes32 role, address account) private {
1258         if (!hasRole(role, account)) {
1259             _roles[role].members[account] = true;
1260             emit RoleGranted(role, account, _msgSender());
1261         }
1262     }
1263 
1264     function _revokeRole(bytes32 role, address account) private {
1265         if (hasRole(role, account)) {
1266             _roles[role].members[account] = false;
1267             emit RoleRevoked(role, account, _msgSender());
1268         }
1269     }
1270 }
1271 
1272 
1273 
1274 /**
1275  * @dev Library for managing
1276  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1277  * types.
1278  *
1279  * Sets have the following properties:
1280  *
1281  * - Elements are added, removed, and checked for existence in constant time
1282  * (O(1)).
1283  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1284  *
1285  * ```
1286  * contract Example {
1287  *     // Add the library methods
1288  *     using EnumerableSet for EnumerableSet.AddressSet;
1289  *
1290  *     // Declare a set state variable
1291  *     EnumerableSet.AddressSet private mySet;
1292  * }
1293  * ```
1294  *
1295  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1296  * and `uint256` (`UintSet`) are supported.
1297  */
1298 library EnumerableSet {
1299     // To implement this library for multiple types with as little code
1300     // repetition as possible, we write it in terms of a generic Set type with
1301     // bytes32 values.
1302     // The Set implementation uses private functions, and user-facing
1303     // implementations (such as AddressSet) are just wrappers around the
1304     // underlying Set.
1305     // This means that we can only create new EnumerableSets for types that fit
1306     // in bytes32.
1307 
1308     struct Set {
1309         // Storage of set values
1310         bytes32[] _values;
1311         // Position of the value in the `values` array, plus 1 because index 0
1312         // means a value is not in the set.
1313         mapping(bytes32 => uint256) _indexes;
1314     }
1315 
1316     /**
1317      * @dev Add a value to a set. O(1).
1318      *
1319      * Returns true if the value was added to the set, that is if it was not
1320      * already present.
1321      */
1322     function _add(Set storage set, bytes32 value) private returns (bool) {
1323         if (!_contains(set, value)) {
1324             set._values.push(value);
1325             // The value is stored at length-1, but we add 1 to all indexes
1326             // and use 0 as a sentinel value
1327             set._indexes[value] = set._values.length;
1328             return true;
1329         } else {
1330             return false;
1331         }
1332     }
1333 
1334     /**
1335      * @dev Removes a value from a set. O(1).
1336      *
1337      * Returns true if the value was removed from the set, that is if it was
1338      * present.
1339      */
1340     function _remove(Set storage set, bytes32 value) private returns (bool) {
1341         // We read and store the value's index to prevent multiple reads from the same storage slot
1342         uint256 valueIndex = set._indexes[value];
1343 
1344         if (valueIndex != 0) {
1345             // Equivalent to contains(set, value)
1346             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1347             // the array, and then remove the last element (sometimes called as 'swap and pop').
1348             // This modifies the order of the array, as noted in {at}.
1349 
1350             uint256 toDeleteIndex = valueIndex - 1;
1351             uint256 lastIndex = set._values.length - 1;
1352 
1353             if (lastIndex != toDeleteIndex) {
1354                 bytes32 lastvalue = set._values[lastIndex];
1355 
1356                 // Move the last value to the index where the value to delete is
1357                 set._values[toDeleteIndex] = lastvalue;
1358                 // Update the index for the moved value
1359                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1360             }
1361 
1362             // Delete the slot where the moved value was stored
1363             set._values.pop();
1364 
1365             // Delete the index for the deleted slot
1366             delete set._indexes[value];
1367 
1368             return true;
1369         } else {
1370             return false;
1371         }
1372     }
1373 
1374     /**
1375      * @dev Returns true if the value is in the set. O(1).
1376      */
1377     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1378         return set._indexes[value] != 0;
1379     }
1380 
1381     /**
1382      * @dev Returns the number of values on the set. O(1).
1383      */
1384     function _length(Set storage set) private view returns (uint256) {
1385         return set._values.length;
1386     }
1387 
1388     /**
1389      * @dev Returns the value stored at position `index` in the set. O(1).
1390      *
1391      * Note that there are no guarantees on the ordering of values inside the
1392      * array, and it may change when more values are added or removed.
1393      *
1394      * Requirements:
1395      *
1396      * - `index` must be strictly less than {length}.
1397      */
1398     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1399         return set._values[index];
1400     }
1401 
1402     // Bytes32Set
1403 
1404     struct Bytes32Set {
1405         Set _inner;
1406     }
1407 
1408     /**
1409      * @dev Add a value to a set. O(1).
1410      *
1411      * Returns true if the value was added to the set, that is if it was not
1412      * already present.
1413      */
1414     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1415         return _add(set._inner, value);
1416     }
1417 
1418     /**
1419      * @dev Removes a value from a set. O(1).
1420      *
1421      * Returns true if the value was removed from the set, that is if it was
1422      * present.
1423      */
1424     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1425         return _remove(set._inner, value);
1426     }
1427 
1428     /**
1429      * @dev Returns true if the value is in the set. O(1).
1430      */
1431     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1432         return _contains(set._inner, value);
1433     }
1434 
1435     /**
1436      * @dev Returns the number of values in the set. O(1).
1437      */
1438     function length(Bytes32Set storage set) internal view returns (uint256) {
1439         return _length(set._inner);
1440     }
1441 
1442     /**
1443      * @dev Returns the value stored at position `index` in the set. O(1).
1444      *
1445      * Note that there are no guarantees on the ordering of values inside the
1446      * array, and it may change when more values are added or removed.
1447      *
1448      * Requirements:
1449      *
1450      * - `index` must be strictly less than {length}.
1451      */
1452     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1453         return _at(set._inner, index);
1454     }
1455 
1456     // AddressSet
1457 
1458     struct AddressSet {
1459         Set _inner;
1460     }
1461 
1462     /**
1463      * @dev Add a value to a set. O(1).
1464      *
1465      * Returns true if the value was added to the set, that is if it was not
1466      * already present.
1467      */
1468     function add(AddressSet storage set, address value) internal returns (bool) {
1469         return _add(set._inner, bytes32(uint256(uint160(value))));
1470     }
1471 
1472     /**
1473      * @dev Removes a value from a set. O(1).
1474      *
1475      * Returns true if the value was removed from the set, that is if it was
1476      * present.
1477      */
1478     function remove(AddressSet storage set, address value) internal returns (bool) {
1479         return _remove(set._inner, bytes32(uint256(uint160(value))));
1480     }
1481 
1482     /**
1483      * @dev Returns true if the value is in the set. O(1).
1484      */
1485     function contains(AddressSet storage set, address value) internal view returns (bool) {
1486         return _contains(set._inner, bytes32(uint256(uint160(value))));
1487     }
1488 
1489     /**
1490      * @dev Returns the number of values in the set. O(1).
1491      */
1492     function length(AddressSet storage set) internal view returns (uint256) {
1493         return _length(set._inner);
1494     }
1495 
1496     /**
1497      * @dev Returns the value stored at position `index` in the set. O(1).
1498      *
1499      * Note that there are no guarantees on the ordering of values inside the
1500      * array, and it may change when more values are added or removed.
1501      *
1502      * Requirements:
1503      *
1504      * - `index` must be strictly less than {length}.
1505      */
1506     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1507         return address(uint160(uint256(_at(set._inner, index))));
1508     }
1509 
1510     // UintSet
1511 
1512     struct UintSet {
1513         Set _inner;
1514     }
1515 
1516     /**
1517      * @dev Add a value to a set. O(1).
1518      *
1519      * Returns true if the value was added to the set, that is if it was not
1520      * already present.
1521      */
1522     function add(UintSet storage set, uint256 value) internal returns (bool) {
1523         return _add(set._inner, bytes32(value));
1524     }
1525 
1526     /**
1527      * @dev Removes a value from a set. O(1).
1528      *
1529      * Returns true if the value was removed from the set, that is if it was
1530      * present.
1531      */
1532     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1533         return _remove(set._inner, bytes32(value));
1534     }
1535 
1536     /**
1537      * @dev Returns true if the value is in the set. O(1).
1538      */
1539     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1540         return _contains(set._inner, bytes32(value));
1541     }
1542 
1543     /**
1544      * @dev Returns the number of values on the set. O(1).
1545      */
1546     function length(UintSet storage set) internal view returns (uint256) {
1547         return _length(set._inner);
1548     }
1549 
1550     /**
1551      * @dev Returns the value stored at position `index` in the set. O(1).
1552      *
1553      * Note that there are no guarantees on the ordering of values inside the
1554      * array, and it may change when more values are added or removed.
1555      *
1556      * Requirements:
1557      *
1558      * - `index` must be strictly less than {length}.
1559      */
1560     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1561         return uint256(_at(set._inner, index));
1562     }
1563 }
1564 
1565 /**
1566  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1567  */
1568 interface IAccessControlEnumerable {
1569     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1570 
1571     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1572 }
1573 
1574 /**
1575  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1576  */
1577 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1578     using EnumerableSet for EnumerableSet.AddressSet;
1579 
1580     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1581 
1582     /**
1583      * @dev See {IERC165-supportsInterface}.
1584      */
1585     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1586         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1587     }
1588 
1589     /**
1590      * @dev Returns one of the accounts that have `role`. `index` must be a
1591      * value between 0 and {getRoleMemberCount}, non-inclusive.
1592      *
1593      * Role bearers are not sorted in any particular way, and their ordering may
1594      * change at any point.
1595      *
1596      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1597      * you perform all queries on the same block. See the following
1598      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1599      * for more information.
1600      */
1601     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1602         return _roleMembers[role].at(index);
1603     }
1604 
1605     /**
1606      * @dev Returns the number of accounts that have `role`. Can be used
1607      * together with {getRoleMember} to enumerate all bearers of a role.
1608      */
1609     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1610         return _roleMembers[role].length();
1611     }
1612 
1613     /**
1614      * @dev Overload {grantRole} to track enumerable memberships
1615      */
1616     function grantRole(bytes32 role, address account) public virtual override {
1617         super.grantRole(role, account);
1618         _roleMembers[role].add(account);
1619     }
1620 
1621     /**
1622      * @dev Overload {revokeRole} to track enumerable memberships
1623      */
1624     function revokeRole(bytes32 role, address account) public virtual override {
1625         super.revokeRole(role, account);
1626         _roleMembers[role].remove(account);
1627     }
1628 
1629     /**
1630      * @dev Overload {renounceRole} to track enumerable memberships
1631      */
1632     function renounceRole(bytes32 role, address account) public virtual override {
1633         super.renounceRole(role, account);
1634         _roleMembers[role].remove(account);
1635     }
1636 
1637     /**
1638      * @dev Overload {_setupRole} to track enumerable memberships
1639      */
1640     function _setupRole(bytes32 role, address account) internal virtual override {
1641         super._setupRole(role, account);
1642         _roleMembers[role].add(account);
1643     }
1644 }
1645 
1646 
1647 
1648 // CAUTION
1649 // This version of SafeMath should only be used with Solidity 0.8 or later,
1650 // because it relies on the compiler's built in overflow checks.
1651 
1652 /**
1653  * @dev Wrappers over Solidity's arithmetic operations.
1654  *
1655  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1656  * now has built in overflow checking.
1657  */
1658 library SafeMath {
1659     /**
1660      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1661      *
1662      * _Available since v3.4._
1663      */
1664     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1665         unchecked {
1666             uint256 c = a + b;
1667             if (c < a) return (false, 0);
1668             return (true, c);
1669         }
1670     }
1671 
1672     /**
1673      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1674      *
1675      * _Available since v3.4._
1676      */
1677     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1678         unchecked {
1679             if (b > a) return (false, 0);
1680             return (true, a - b);
1681         }
1682     }
1683 
1684     /**
1685      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1686      *
1687      * _Available since v3.4._
1688      */
1689     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1690         unchecked {
1691             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1692             // benefit is lost if 'b' is also tested.
1693             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1694             if (a == 0) return (true, 0);
1695             uint256 c = a * b;
1696             if (c / a != b) return (false, 0);
1697             return (true, c);
1698         }
1699     }
1700 
1701     /**
1702      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1703      *
1704      * _Available since v3.4._
1705      */
1706     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1707         unchecked {
1708             if (b == 0) return (false, 0);
1709             return (true, a / b);
1710         }
1711     }
1712 
1713     /**
1714      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1715      *
1716      * _Available since v3.4._
1717      */
1718     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1719         unchecked {
1720             if (b == 0) return (false, 0);
1721             return (true, a % b);
1722         }
1723     }
1724 
1725     /**
1726      * @dev Returns the addition of two unsigned integers, reverting on
1727      * overflow.
1728      *
1729      * Counterpart to Solidity's `+` operator.
1730      *
1731      * Requirements:
1732      *
1733      * - Addition cannot overflow.
1734      */
1735     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1736         return a + b;
1737     }
1738 
1739     /**
1740      * @dev Returns the subtraction of two unsigned integers, reverting on
1741      * overflow (when the result is negative).
1742      *
1743      * Counterpart to Solidity's `-` operator.
1744      *
1745      * Requirements:
1746      *
1747      * - Subtraction cannot overflow.
1748      */
1749     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1750         return a - b;
1751     }
1752 
1753     /**
1754      * @dev Returns the multiplication of two unsigned integers, reverting on
1755      * overflow.
1756      *
1757      * Counterpart to Solidity's `*` operator.
1758      *
1759      * Requirements:
1760      *
1761      * - Multiplication cannot overflow.
1762      */
1763     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1764         return a * b;
1765     }
1766 
1767     /**
1768      * @dev Returns the integer division of two unsigned integers, reverting on
1769      * division by zero. The result is rounded towards zero.
1770      *
1771      * Counterpart to Solidity's `/` operator.
1772      *
1773      * Requirements:
1774      *
1775      * - The divisor cannot be zero.
1776      */
1777     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1778         return a / b;
1779     }
1780 
1781     /**
1782      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1783      * reverting when dividing by zero.
1784      *
1785      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1786      * opcode (which leaves remaining gas untouched) while Solidity uses an
1787      * invalid opcode to revert (consuming all remaining gas).
1788      *
1789      * Requirements:
1790      *
1791      * - The divisor cannot be zero.
1792      */
1793     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1794         return a % b;
1795     }
1796 
1797     /**
1798      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1799      * overflow (when the result is negative).
1800      *
1801      * CAUTION: This function is deprecated because it requires allocating memory for the error
1802      * message unnecessarily. For custom revert reasons use {trySub}.
1803      *
1804      * Counterpart to Solidity's `-` operator.
1805      *
1806      * Requirements:
1807      *
1808      * - Subtraction cannot overflow.
1809      */
1810     function sub(
1811         uint256 a,
1812         uint256 b,
1813         string memory errorMessage
1814     ) internal pure returns (uint256) {
1815         unchecked {
1816             require(b <= a, errorMessage);
1817             return a - b;
1818         }
1819     }
1820 
1821     /**
1822      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1823      * division by zero. The result is rounded towards zero.
1824      *
1825      * Counterpart to Solidity's `/` operator. Note: this function uses a
1826      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1827      * uses an invalid opcode to revert (consuming all remaining gas).
1828      *
1829      * Requirements:
1830      *
1831      * - The divisor cannot be zero.
1832      */
1833     function div(
1834         uint256 a,
1835         uint256 b,
1836         string memory errorMessage
1837     ) internal pure returns (uint256) {
1838         unchecked {
1839             require(b > 0, errorMessage);
1840             return a / b;
1841         }
1842     }
1843 
1844     /**
1845      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1846      * reverting with custom message when dividing by zero.
1847      *
1848      * CAUTION: This function is deprecated because it requires allocating memory for the error
1849      * message unnecessarily. For custom revert reasons use {tryMod}.
1850      *
1851      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1852      * opcode (which leaves remaining gas untouched) while Solidity uses an
1853      * invalid opcode to revert (consuming all remaining gas).
1854      *
1855      * Requirements:
1856      *
1857      * - The divisor cannot be zero.
1858      */
1859     function mod(
1860         uint256 a,
1861         uint256 b,
1862         string memory errorMessage
1863     ) internal pure returns (uint256) {
1864         unchecked {
1865             require(b > 0, errorMessage);
1866             return a % b;
1867         }
1868     }
1869 }
1870 
1871 
1872 
1873 /**
1874  * @title Counters
1875  * @author Matt Condon (@shrugs)
1876  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1877  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1878  *
1879  * Include with `using Counters for Counters.Counter;`
1880  */
1881 library Counters {
1882     struct Counter {
1883         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1884         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1885         // this feature: see https://github.com/ethereum/solidity/issues/4637
1886         uint256 _value; // default: 0
1887     }
1888 
1889     function current(Counter storage counter) internal view returns (uint256) {
1890         return counter._value;
1891     }
1892 
1893     function increment(Counter storage counter) internal {
1894         unchecked {
1895             counter._value += 1;
1896         }
1897     }
1898 
1899     function decrement(Counter storage counter) internal {
1900         uint256 value = counter._value;
1901         require(value > 0, "Counter: decrement overflow");
1902         unchecked {
1903             counter._value = value - 1;
1904         }
1905     }
1906 
1907     function reset(Counter storage counter) internal {
1908         counter._value = 0;
1909     }
1910 }
1911 
1912 contract ChicADees is Context, AccessControlEnumerable, ERC1155Burnable {
1913 
1914   using SafeMath for uint256;
1915   using Counters for Counters.Counter;
1916 
1917   Counters.Counter private _tokenIdTracker;
1918 
1919   string public constant name = 'Chic-A-Dees';
1920   string public constant symbol = 'CHIC';
1921   bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1922   uint256 public constant MAX_ELEMENTS = 11111;
1923   address public constant creatorAddress = 0x6c474099ad6d9Af49201a38b9842111d4ACd10BC;
1924 
1925   event Update(string _value, uint256 indexed _id);
1926 
1927   // CIDs
1928     mapping (uint256 => string) public cids;
1929 
1930     /**
1931      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE`, and `AUDITOR_ROL` to the account that
1932      * deploys the contract.
1933      */
1934     constructor(string memory _uri) ERC1155(_uri) {
1935         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1936         _setupRole(MINTER_ROLE, _msgSender());
1937     }
1938 
1939     function _totalSupply() internal view returns (uint) {
1940         return _tokenIdTracker.current();
1941     }
1942 
1943     /**
1944      * @dev Creates `amount` new tokens for `to`, of token type `id`.
1945      *
1946      * See {ERC1155-_mint}.
1947      *
1948      * Requirements:
1949      *
1950      * - the caller must have the `MINTER_ROLE`.
1951      */
1952     function mint(address to, uint256 id, uint256 amount, bytes memory data, string calldata _update, string calldata cid) public virtual {
1953 
1954         uint256 total = _totalSupply();
1955         require(total + 1 <= MAX_ELEMENTS, "Max limit");
1956         require(total <= MAX_ELEMENTS, "Sale end");
1957         require(hasRole(MINTER_ROLE, _msgSender()), "Ownerfy: must have minter role to mint");
1958 
1959         if (bytes(_update).length > 0) {
1960           emit Update(_update, id);
1961         }
1962 
1963         _tokenIdTracker.increment();
1964 
1965         cids[id] = cid;
1966 
1967         _mint(to, id, amount, data);
1968     }
1969 
1970     /**
1971      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] variant of {mint}.
1972      */
1973     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data, string[] calldata updates, string[] calldata _cids) public virtual {
1974 
1975         uint256 total = _totalSupply();
1976         require(total + ids.length <= MAX_ELEMENTS, "Max limit");
1977         require(total <= MAX_ELEMENTS, "Sale end");
1978         require(hasRole(MINTER_ROLE, _msgSender()), "Ownerfy: must have minter role to mint");
1979 
1980         _mintBatch(to, ids, amounts, data);
1981 
1982         for (uint i = 0; i < ids.length; i++) {
1983           _tokenIdTracker.increment();
1984 
1985           if (bytes(_cids[i]).length > 0) {
1986             cids[ids[i]] = _cids[i];
1987           }
1988           if (bytes(updates[i]).length > 0) {
1989             emit Update(updates[i], ids[i]);
1990           }
1991         }
1992     }
1993 
1994     function uri(uint256 _id) public view virtual override returns (string memory) {
1995         return string(abi.encodePacked('https://gateway.pinata.cloud/ipfs/', cids[_id]));
1996     }
1997 
1998     /**
1999      * @dev See {IERC165-supportsInterface}.
2000      */
2001     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerable, ERC1155) returns (bool) {
2002         return super.supportsInterface(interfaceId);
2003     }
2004 
2005 }