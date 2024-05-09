1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
29 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
30 /**
31  * @dev Required interface of an ERC1155 compliant contract, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
33  *
34  * _Available since v3.1._
35  */
36 interface IERC1155 is IERC165 {
37     /**
38      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
39      */
40     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
41 
42     /**
43      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
44      * transfers.
45      */
46     event TransferBatch(
47         address indexed operator,
48         address indexed from,
49         address indexed to,
50         uint256[] ids,
51         uint256[] values
52     );
53 
54     /**
55      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
56      * `approved`.
57      */
58     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
59 
60     /**
61      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
62      *
63      * If an {URI} event was emitted for `id`, the standard
64      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
65      * returned by {IERC1155MetadataURI-uri}.
66      */
67     event URI(string value, uint256 indexed id);
68 
69     /**
70      * @dev Returns the amount of tokens of token type `id` owned by `account`.
71      *
72      * Requirements:
73      *
74      * - `account` cannot be the zero address.
75      */
76     function balanceOf(address account, uint256 id) external view returns (uint256);
77 
78     /**
79      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
80      *
81      * Requirements:
82      *
83      * - `accounts` and `ids` must have the same length.
84      */
85     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
86         external
87         view
88         returns (uint256[] memory);
89 
90     /**
91      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
92      *
93      * Emits an {ApprovalForAll} event.
94      *
95      * Requirements:
96      *
97      * - `operator` cannot be the caller.
98      */
99     function setApprovalForAll(address operator, bool approved) external;
100 
101     /**
102      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
103      *
104      * See {setApprovalForAll}.
105      */
106     function isApprovedForAll(address account, address operator) external view returns (bool);
107 
108     /**
109      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
110      *
111      * Emits a {TransferSingle} event.
112      *
113      * Requirements:
114      *
115      * - `to` cannot be the zero address.
116      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
117      * - `from` must have a balance of tokens of type `id` of at least `amount`.
118      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
119      * acceptance magic value.
120      */
121     function safeTransferFrom(
122         address from,
123         address to,
124         uint256 id,
125         uint256 amount,
126         bytes calldata data
127     ) external;
128 
129     /**
130      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
131      *
132      * Emits a {TransferBatch} event.
133      *
134      * Requirements:
135      *
136      * - `ids` and `amounts` must have the same length.
137      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
138      * acceptance magic value.
139      */
140     function safeBatchTransferFrom(
141         address from,
142         address to,
143         uint256[] calldata ids,
144         uint256[] calldata amounts,
145         bytes calldata data
146     ) external;
147 }
148 
149 
150 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
151 /**
152  * @dev _Available since v3.1._
153  */
154 interface IERC1155Receiver is IERC165 {
155     /**
156      * @dev Handles the receipt of a single ERC1155 token type. This function is
157      * called at the end of a `safeTransferFrom` after the balance has been updated.
158      *
159      * NOTE: To accept the transfer, this must return
160      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
161      * (i.e. 0xf23a6e61, or its own function selector).
162      *
163      * @param operator The address which initiated the transfer (i.e. msg.sender)
164      * @param from The address which previously owned the token
165      * @param id The ID of the token being transferred
166      * @param value The amount of tokens being transferred
167      * @param data Additional data with no specified format
168      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
169      */
170     function onERC1155Received(
171         address operator,
172         address from,
173         uint256 id,
174         uint256 value,
175         bytes calldata data
176     ) external returns (bytes4);
177 
178     /**
179      * @dev Handles the receipt of a multiple ERC1155 token types. This function
180      * is called at the end of a `safeBatchTransferFrom` after the balances have
181      * been updated.
182      *
183      * NOTE: To accept the transfer(s), this must return
184      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
185      * (i.e. 0xbc197c81, or its own function selector).
186      *
187      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
188      * @param from The address which previously owned the token
189      * @param ids An array containing ids of each token being transferred (order and length must match values array)
190      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
191      * @param data Additional data with no specified format
192      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
193      */
194     function onERC1155BatchReceived(
195         address operator,
196         address from,
197         uint256[] calldata ids,
198         uint256[] calldata values,
199         bytes calldata data
200     ) external returns (bytes4);
201 }
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
205 /**
206  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
207  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
208  *
209  * _Available since v3.1._
210  */
211 interface IERC1155MetadataURI is IERC1155 {
212     /**
213      * @dev Returns the URI for token type `id`.
214      *
215      * If the `\{id\}` substring is present in the URI, it must be replaced by
216      * clients with the actual token type ID.
217      */
218     function uri(uint256 id) external view returns (string memory);
219 }
220 
221 
222 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      *
244      * [IMPORTANT]
245      * ====
246      * You shouldn't rely on `isContract` to protect against flash loan attacks!
247      *
248      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
249      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
250      * constructor.
251      * ====
252      */
253     function isContract(address account) internal view returns (bool) {
254         // This method relies on extcodesize/address.code.length, which returns 0
255         // for contracts in construction, since the code is only stored at the end
256         // of the constructor execution.
257 
258         return account.code.length > 0;
259     }
260 
261     /**
262      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
263      * `recipient`, forwarding all available gas and reverting on errors.
264      *
265      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
266      * of certain opcodes, possibly making contracts go over the 2300 gas limit
267      * imposed by `transfer`, making them unable to receive funds via
268      * `transfer`. {sendValue} removes this limitation.
269      *
270      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
271      *
272      * IMPORTANT: because control is transferred to `recipient`, care must be
273      * taken to not create reentrancy vulnerabilities. Consider using
274      * {ReentrancyGuard} or the
275      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
276      */
277     function sendValue(address payable recipient, uint256 amount) internal {
278         require(address(this).balance >= amount, "Address: insufficient balance");
279 
280         (bool success, ) = recipient.call{value: amount}("");
281         require(success, "Address: unable to send value, recipient may have reverted");
282     }
283 
284     /**
285      * @dev Performs a Solidity function call using a low level `call`. A
286      * plain `call` is an unsafe replacement for a function call: use this
287      * function instead.
288      *
289      * If `target` reverts with a revert reason, it is bubbled up by this
290      * function (like regular Solidity function calls).
291      *
292      * Returns the raw returned data. To convert to the expected return value,
293      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
294      *
295      * Requirements:
296      *
297      * - `target` must be a contract.
298      * - calling `target` with `data` must not revert.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionCall(target, data, "Address: low-level call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
308      * `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, 0, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but also transferring `value` wei to `target`.
323      *
324      * Requirements:
325      *
326      * - the calling contract must have an ETH balance of at least `value`.
327      * - the called Solidity function must be `payable`.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(
332         address target,
333         bytes memory data,
334         uint256 value
335     ) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
341      * with `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(
346         address target,
347         bytes memory data,
348         uint256 value,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         require(address(this).balance >= value, "Address: insufficient balance for call");
352         require(isContract(target), "Address: call to non-contract");
353 
354         (bool success, bytes memory returndata) = target.call{value: value}(data);
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
365         return functionStaticCall(target, data, "Address: low-level static call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal view returns (bytes memory) {
379         require(isContract(target), "Address: static call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.staticcall(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         require(isContract(target), "Address: delegate call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.delegatecall(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
414      * revert reason using the provided one.
415      *
416      * _Available since v4.3._
417      */
418     function verifyCallResult(
419         bool success,
420         bytes memory returndata,
421         string memory errorMessage
422     ) internal pure returns (bytes memory) {
423         if (success) {
424             return returndata;
425         } else {
426             // Look for revert reason and bubble it up if present
427             if (returndata.length > 0) {
428                 // The easiest way to bubble the revert reason is using memory via assembly
429 
430                 assembly {
431                     let returndata_size := mload(returndata)
432                     revert(add(32, returndata), returndata_size)
433                 }
434             } else {
435                 revert(errorMessage);
436             }
437         }
438     }
439 }
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
443 /**
444  * @dev Provides information about the current execution context, including the
445  * sender of the transaction and its data. While these are generally available
446  * via msg.sender and msg.data, they should not be accessed in such a direct
447  * manner, since when dealing with meta-transactions the account sending and
448  * paying for execution may not be the actual sender (as far as an application
449  * is concerned).
450  *
451  * This contract is only required for intermediate, library-like contracts.
452  */
453 abstract contract Context {
454     function _msgSender() internal view virtual returns (address) {
455         return msg.sender;
456     }
457 
458     function _msgData() internal view virtual returns (bytes calldata) {
459         return msg.data;
460     }
461 }
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
465 /**
466  * @dev Implementation of the {IERC165} interface.
467  *
468  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
469  * for the additional interface id that will be supported. For example:
470  *
471  * ```solidity
472  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
473  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
474  * }
475  * ```
476  *
477  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
478  */
479 abstract contract ERC165 is IERC165 {
480     /**
481      * @dev See {IERC165-supportsInterface}.
482      */
483     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484         return interfaceId == type(IERC165).interfaceId;
485     }
486 }
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
490 /**
491  * @dev Implementation of the basic standard multi-token.
492  * See https://eips.ethereum.org/EIPS/eip-1155
493  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
494  *
495  * _Available since v3.1._
496  */
497 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
498     using Address for address;
499 
500     // Mapping from token ID to account balances
501     mapping(uint256 => mapping(address => uint256)) private _balances;
502 
503     // Mapping from account to operator approvals
504     mapping(address => mapping(address => bool)) private _operatorApprovals;
505 
506     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
507     string private _uri;
508 
509     /**
510      * @dev See {_setURI}.
511      */
512     constructor(string memory uri_) {
513         _setURI(uri_);
514     }
515 
516     /**
517      * @dev See {IERC165-supportsInterface}.
518      */
519     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
520         return
521             interfaceId == type(IERC1155).interfaceId ||
522             interfaceId == type(IERC1155MetadataURI).interfaceId ||
523             super.supportsInterface(interfaceId);
524     }
525 
526     /**
527      * @dev See {IERC1155MetadataURI-uri}.
528      *
529      * This implementation returns the same URI for *all* token types. It relies
530      * on the token type ID substitution mechanism
531      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
532      *
533      * Clients calling this function must replace the `\{id\}` substring with the
534      * actual token type ID.
535      */
536     function uri(uint256) public view virtual override returns (string memory) {
537         return _uri;
538     }
539 
540     /**
541      * @dev See {IERC1155-balanceOf}.
542      *
543      * Requirements:
544      *
545      * - `account` cannot be the zero address.
546      */
547     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
548         require(account != address(0), "ERC1155: balance query for the zero address");
549         return _balances[id][account];
550     }
551 
552     /**
553      * @dev See {IERC1155-balanceOfBatch}.
554      *
555      * Requirements:
556      *
557      * - `accounts` and `ids` must have the same length.
558      */
559     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
560         public
561         view
562         virtual
563         override
564         returns (uint256[] memory)
565     {
566         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
567 
568         uint256[] memory batchBalances = new uint256[](accounts.length);
569 
570         for (uint256 i = 0; i < accounts.length; ++i) {
571             batchBalances[i] = balanceOf(accounts[i], ids[i]);
572         }
573 
574         return batchBalances;
575     }
576 
577     /**
578      * @dev See {IERC1155-setApprovalForAll}.
579      */
580     function setApprovalForAll(address operator, bool approved) public virtual override {
581         _setApprovalForAll(_msgSender(), operator, approved);
582     }
583 
584     /**
585      * @dev See {IERC1155-isApprovedForAll}.
586      */
587     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
588         return _operatorApprovals[account][operator];
589     }
590 
591     /**
592      * @dev See {IERC1155-safeTransferFrom}.
593      */
594     function safeTransferFrom(
595         address from,
596         address to,
597         uint256 id,
598         uint256 amount,
599         bytes memory data
600     ) public virtual override {
601         require(
602             from == _msgSender() || isApprovedForAll(from, _msgSender()),
603             "ERC1155: caller is not owner nor approved"
604         );
605         _safeTransferFrom(from, to, id, amount, data);
606     }
607 
608     /**
609      * @dev See {IERC1155-safeBatchTransferFrom}.
610      */
611     function safeBatchTransferFrom(
612         address from,
613         address to,
614         uint256[] memory ids,
615         uint256[] memory amounts,
616         bytes memory data
617     ) public virtual override {
618         require(
619             from == _msgSender() || isApprovedForAll(from, _msgSender()),
620             "ERC1155: transfer caller is not owner nor approved"
621         );
622         _safeBatchTransferFrom(from, to, ids, amounts, data);
623     }
624 
625     /**
626      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
627      *
628      * Emits a {TransferSingle} event.
629      *
630      * Requirements:
631      *
632      * - `to` cannot be the zero address.
633      * - `from` must have a balance of tokens of type `id` of at least `amount`.
634      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
635      * acceptance magic value.
636      */
637     function _safeTransferFrom(
638         address from,
639         address to,
640         uint256 id,
641         uint256 amount,
642         bytes memory data
643     ) internal virtual {
644         require(to != address(0), "ERC1155: transfer to the zero address");
645 
646         address operator = _msgSender();
647 
648         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
649 
650         uint256 fromBalance = _balances[id][from];
651         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
652         unchecked {
653             _balances[id][from] = fromBalance - amount;
654         }
655         _balances[id][to] += amount;
656 
657         emit TransferSingle(operator, from, to, id, amount);
658 
659         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
660     }
661 
662     /**
663      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
664      *
665      * Emits a {TransferBatch} event.
666      *
667      * Requirements:
668      *
669      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
670      * acceptance magic value.
671      */
672     function _safeBatchTransferFrom(
673         address from,
674         address to,
675         uint256[] memory ids,
676         uint256[] memory amounts,
677         bytes memory data
678     ) internal virtual {
679         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
680         require(to != address(0), "ERC1155: transfer to the zero address");
681 
682         address operator = _msgSender();
683 
684         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
685 
686         for (uint256 i = 0; i < ids.length; ++i) {
687             uint256 id = ids[i];
688             uint256 amount = amounts[i];
689 
690             uint256 fromBalance = _balances[id][from];
691             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
692             unchecked {
693                 _balances[id][from] = fromBalance - amount;
694             }
695             _balances[id][to] += amount;
696         }
697 
698         emit TransferBatch(operator, from, to, ids, amounts);
699 
700         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
701     }
702 
703     /**
704      * @dev Sets a new URI for all token types, by relying on the token type ID
705      * substitution mechanism
706      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
707      *
708      * By this mechanism, any occurrence of the `\{id\}` substring in either the
709      * URI or any of the amounts in the JSON file at said URI will be replaced by
710      * clients with the token type ID.
711      *
712      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
713      * interpreted by clients as
714      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
715      * for token type ID 0x4cce0.
716      *
717      * See {uri}.
718      *
719      * Because these URIs cannot be meaningfully represented by the {URI} event,
720      * this function emits no events.
721      */
722     function _setURI(string memory newuri) internal virtual {
723         _uri = newuri;
724     }
725 
726     /**
727      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
728      *
729      * Emits a {TransferSingle} event.
730      *
731      * Requirements:
732      *
733      * - `to` cannot be the zero address.
734      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
735      * acceptance magic value.
736      */
737     function _mint(
738         address to,
739         uint256 id,
740         uint256 amount,
741         bytes memory data
742     ) internal virtual {
743         require(to != address(0), "ERC1155: mint to the zero address");
744 
745         address operator = _msgSender();
746 
747         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
748 
749         _balances[id][to] += amount;
750         emit TransferSingle(operator, address(0), to, id, amount);
751 
752         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
753     }
754 
755     /**
756      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
757      *
758      * Requirements:
759      *
760      * - `ids` and `amounts` must have the same length.
761      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
762      * acceptance magic value.
763      */
764     function _mintBatch(
765         address to,
766         uint256[] memory ids,
767         uint256[] memory amounts,
768         bytes memory data
769     ) internal virtual {
770         require(to != address(0), "ERC1155: mint to the zero address");
771         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
772 
773         address operator = _msgSender();
774 
775         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
776 
777         for (uint256 i = 0; i < ids.length; i++) {
778             _balances[ids[i]][to] += amounts[i];
779         }
780 
781         emit TransferBatch(operator, address(0), to, ids, amounts);
782 
783         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
784     }
785 
786     /**
787      * @dev Destroys `amount` tokens of token type `id` from `from`
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `from` must have at least `amount` tokens of token type `id`.
793      */
794     function _burn(
795         address from,
796         uint256 id,
797         uint256 amount
798     ) internal virtual {
799         require(from != address(0), "ERC1155: burn from the zero address");
800 
801         address operator = _msgSender();
802 
803         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
804 
805         uint256 fromBalance = _balances[id][from];
806         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
807         unchecked {
808             _balances[id][from] = fromBalance - amount;
809         }
810 
811         emit TransferSingle(operator, from, address(0), id, amount);
812     }
813 
814     /**
815      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
816      *
817      * Requirements:
818      *
819      * - `ids` and `amounts` must have the same length.
820      */
821     function _burnBatch(
822         address from,
823         uint256[] memory ids,
824         uint256[] memory amounts
825     ) internal virtual {
826         require(from != address(0), "ERC1155: burn from the zero address");
827         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
828 
829         address operator = _msgSender();
830 
831         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
832 
833         for (uint256 i = 0; i < ids.length; i++) {
834             uint256 id = ids[i];
835             uint256 amount = amounts[i];
836 
837             uint256 fromBalance = _balances[id][from];
838             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
839             unchecked {
840                 _balances[id][from] = fromBalance - amount;
841             }
842         }
843 
844         emit TransferBatch(operator, from, address(0), ids, amounts);
845     }
846 
847     /**
848      * @dev Approve `operator` to operate on all of `owner` tokens
849      *
850      * Emits a {ApprovalForAll} event.
851      */
852     function _setApprovalForAll(
853         address owner,
854         address operator,
855         bool approved
856     ) internal virtual {
857         require(owner != operator, "ERC1155: setting approval status for self");
858         _operatorApprovals[owner][operator] = approved;
859         emit ApprovalForAll(owner, operator, approved);
860     }
861 
862     /**
863      * @dev Hook that is called before any token transfer. This includes minting
864      * and burning, as well as batched variants.
865      *
866      * The same hook is called on both single and batched variants. For single
867      * transfers, the length of the `id` and `amount` arrays will be 1.
868      *
869      * Calling conditions (for each `id` and `amount` pair):
870      *
871      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
872      * of token type `id` will be  transferred to `to`.
873      * - When `from` is zero, `amount` tokens of token type `id` will be minted
874      * for `to`.
875      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
876      * will be burned.
877      * - `from` and `to` are never both zero.
878      * - `ids` and `amounts` have the same, non-zero length.
879      *
880      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
881      */
882     function _beforeTokenTransfer(
883         address operator,
884         address from,
885         address to,
886         uint256[] memory ids,
887         uint256[] memory amounts,
888         bytes memory data
889     ) internal virtual {}
890 
891     function _doSafeTransferAcceptanceCheck(
892         address operator,
893         address from,
894         address to,
895         uint256 id,
896         uint256 amount,
897         bytes memory data
898     ) private {
899         if (to.isContract()) {
900             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
901                 if (response != IERC1155Receiver.onERC1155Received.selector) {
902                     revert("ERC1155: ERC1155Receiver rejected tokens");
903                 }
904             } catch Error(string memory reason) {
905                 revert(reason);
906             } catch {
907                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
908             }
909         }
910     }
911 
912     function _doSafeBatchTransferAcceptanceCheck(
913         address operator,
914         address from,
915         address to,
916         uint256[] memory ids,
917         uint256[] memory amounts,
918         bytes memory data
919     ) private {
920         if (to.isContract()) {
921             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
922                 bytes4 response
923             ) {
924                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
925                     revert("ERC1155: ERC1155Receiver rejected tokens");
926                 }
927             } catch Error(string memory reason) {
928                 revert(reason);
929             } catch {
930                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
931             }
932         }
933     }
934 
935     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
936         uint256[] memory array = new uint256[](1);
937         array[0] = element;
938 
939         return array;
940     }
941 }
942 
943 
944 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
945 /**
946  * @dev Extension of ERC1155 that adds tracking of total supply per id.
947  *
948  * Useful for scenarios where Fungible and Non-fungible tokens have to be
949  * clearly identified. Note: While a totalSupply of 1 might mean the
950  * corresponding is an NFT, there is no guarantees that no other token with the
951  * same id are not going to be minted.
952  */
953 abstract contract ERC1155Supply is ERC1155 {
954     mapping(uint256 => uint256) private _totalSupply;
955 
956     /**
957      * @dev Total amount of tokens in with a given id.
958      */
959     function totalSupply(uint256 id) public view virtual returns (uint256) {
960         return _totalSupply[id];
961     }
962 
963     /**
964      * @dev Indicates whether any token exist with a given id, or not.
965      */
966     function exists(uint256 id) public view virtual returns (bool) {
967         return ERC1155Supply.totalSupply(id) > 0;
968     }
969 
970     /**
971      * @dev See {ERC1155-_beforeTokenTransfer}.
972      */
973     function _beforeTokenTransfer(
974         address operator,
975         address from,
976         address to,
977         uint256[] memory ids,
978         uint256[] memory amounts,
979         bytes memory data
980     ) internal virtual override {
981         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
982 
983         if (from == address(0)) {
984             for (uint256 i = 0; i < ids.length; ++i) {
985                 _totalSupply[ids[i]] += amounts[i];
986             }
987         }
988 
989         if (to == address(0)) {
990             for (uint256 i = 0; i < ids.length; ++i) {
991                 _totalSupply[ids[i]] -= amounts[i];
992             }
993         }
994     }
995 }
996 
997 
998 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
999 /**
1000  * @dev Contract module which provides a basic access control mechanism, where
1001  * there is an account (an owner) that can be granted exclusive access to
1002  * specific functions.
1003  *
1004  * By default, the owner account will be the one that deploys the contract. This
1005  * can later be changed with {transferOwnership}.
1006  *
1007  * This module is used through inheritance. It will make available the modifier
1008  * `onlyOwner`, which can be applied to your functions to restrict their use to
1009  * the owner.
1010  */
1011 abstract contract Ownable is Context {
1012     address private _owner;
1013 
1014     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1015 
1016     /**
1017      * @dev Initializes the contract setting the deployer as the initial owner.
1018      */
1019     constructor() {
1020         _transferOwnership(_msgSender());
1021     }
1022 
1023     /**
1024      * @dev Returns the address of the current owner.
1025      */
1026     function owner() public view virtual returns (address) {
1027         return _owner;
1028     }
1029 
1030     /**
1031      * @dev Throws if called by any account other than the owner.
1032      */
1033     modifier onlyOwner() {
1034         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1035         _;
1036     }
1037 
1038     /**
1039      * @dev Leaves the contract without owner. It will not be possible to call
1040      * `onlyOwner` functions anymore. Can only be called by the current owner.
1041      *
1042      * NOTE: Renouncing ownership will leave the contract without an owner,
1043      * thereby removing any functionality that is only available to the owner.
1044      */
1045     function renounceOwnership() public virtual onlyOwner {
1046         _transferOwnership(address(0));
1047     }
1048 
1049     /**
1050      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1051      * Can only be called by the current owner.
1052      */
1053     function transferOwnership(address newOwner) public virtual onlyOwner {
1054         require(newOwner != address(0), "Ownable: new owner is the zero address");
1055         _transferOwnership(newOwner);
1056     }
1057 
1058     /**
1059      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1060      * Internal function without access restriction.
1061      */
1062     function _transferOwnership(address newOwner) internal virtual {
1063         address oldOwner = _owner;
1064         _owner = newOwner;
1065         emit OwnershipTransferred(oldOwner, newOwner);
1066     }
1067 }
1068 
1069 
1070 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1071 /**
1072  * @dev Required interface of an ERC721 compliant contract.
1073  */
1074 interface IERC721 is IERC165 {
1075     /**
1076      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1077      */
1078     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1079 
1080     /**
1081      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1082      */
1083     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1084 
1085     /**
1086      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1087      */
1088     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1089 
1090     /**
1091      * @dev Returns the number of tokens in ``owner``'s account.
1092      */
1093     function balanceOf(address owner) external view returns (uint256 balance);
1094 
1095     /**
1096      * @dev Returns the owner of the `tokenId` token.
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must exist.
1101      */
1102     function ownerOf(uint256 tokenId) external view returns (address owner);
1103 
1104     /**
1105      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1106      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1107      *
1108      * Requirements:
1109      *
1110      * - `from` cannot be the zero address.
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must exist and be owned by `from`.
1113      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1114      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function safeTransferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) external;
1123 
1124     /**
1125      * @dev Transfers `tokenId` token from `from` to `to`.
1126      *
1127      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1128      *
1129      * Requirements:
1130      *
1131      * - `from` cannot be the zero address.
1132      * - `to` cannot be the zero address.
1133      * - `tokenId` token must be owned by `from`.
1134      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function transferFrom(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) external;
1143 
1144     /**
1145      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1146      * The approval is cleared when the token is transferred.
1147      *
1148      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1149      *
1150      * Requirements:
1151      *
1152      * - The caller must own the token or be an approved operator.
1153      * - `tokenId` must exist.
1154      *
1155      * Emits an {Approval} event.
1156      */
1157     function approve(address to, uint256 tokenId) external;
1158 
1159     /**
1160      * @dev Returns the account approved for `tokenId` token.
1161      *
1162      * Requirements:
1163      *
1164      * - `tokenId` must exist.
1165      */
1166     function getApproved(uint256 tokenId) external view returns (address operator);
1167 
1168     /**
1169      * @dev Approve or remove `operator` as an operator for the caller.
1170      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1171      *
1172      * Requirements:
1173      *
1174      * - The `operator` cannot be the caller.
1175      *
1176      * Emits an {ApprovalForAll} event.
1177      */
1178     function setApprovalForAll(address operator, bool _approved) external;
1179 
1180     /**
1181      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1182      *
1183      * See {setApprovalForAll}
1184      */
1185     function isApprovedForAll(address owner, address operator) external view returns (bool);
1186 
1187     /**
1188      * @dev Safely transfers `tokenId` token from `from` to `to`.
1189      *
1190      * Requirements:
1191      *
1192      * - `from` cannot be the zero address.
1193      * - `to` cannot be the zero address.
1194      * - `tokenId` token must exist and be owned by `from`.
1195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function safeTransferFrom(
1201         address from,
1202         address to,
1203         uint256 tokenId,
1204         bytes calldata data
1205     ) external;
1206 }
1207 
1208 
1209 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1210 /**
1211  * @dev String operations.
1212  */
1213 library Strings {
1214     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1215 
1216     /**
1217      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1218      */
1219     function toString(uint256 value) internal pure returns (string memory) {
1220         // Inspired by OraclizeAPI's implementation - MIT licence
1221         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1222 
1223         if (value == 0) {
1224             return "0";
1225         }
1226         uint256 temp = value;
1227         uint256 digits;
1228         while (temp != 0) {
1229             digits++;
1230             temp /= 10;
1231         }
1232         bytes memory buffer = new bytes(digits);
1233         while (value != 0) {
1234             digits -= 1;
1235             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1236             value /= 10;
1237         }
1238         return string(buffer);
1239     }
1240 
1241     /**
1242      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1243      */
1244     function toHexString(uint256 value) internal pure returns (string memory) {
1245         if (value == 0) {
1246             return "0x00";
1247         }
1248         uint256 temp = value;
1249         uint256 length = 0;
1250         while (temp != 0) {
1251             length++;
1252             temp >>= 8;
1253         }
1254         return toHexString(value, length);
1255     }
1256 
1257     /**
1258      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1259      */
1260     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1261         bytes memory buffer = new bytes(2 * length + 2);
1262         buffer[0] = "0";
1263         buffer[1] = "x";
1264         for (uint256 i = 2 * length + 1; i > 1; --i) {
1265             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1266             value >>= 4;
1267         }
1268         require(value == 0, "Strings: hex length insufficient");
1269         return string(buffer);
1270     }
1271 }
1272 
1273 
1274 interface IMAL {
1275   function spendMAL(address user, uint256 amount) external;
1276 }
1277 
1278 interface ISTAKING {
1279   function balanceOf(address user) external view returns (uint256);
1280 }
1281 
1282 contract MoonPets is ERC1155Supply, Ownable {
1283     using Strings for uint256;
1284 
1285     mapping (uint256 => uint256) maxSupplies;
1286     mapping (uint256 => uint256) tokensPrices;
1287     bool private _detailsSet;
1288 
1289     bool public saleIsActive;
1290     bool public isPaused;
1291     bool public apeOwnershipRequired;
1292 
1293     string private name_;
1294     string private symbol_; 
1295 
1296     IMAL public MAL;
1297     ISTAKING public STAKING;
1298     IERC721 public APES;
1299 
1300     mapping (address => bool) private _isAuthorised;
1301     address[] public authorisedLog;
1302 
1303     string private petsBaseUri;
1304 
1305     enum PetTypes {
1306       PetBasic,
1307       PetCommon,
1308       PetUncommon,
1309       PetRare,
1310       PetEpic,
1311       PetMythic,
1312       PetLegendary,
1313       PetArtifact
1314     }
1315 
1316     event PetsMinted(address mintedBy, uint256 totalAmount, uint256 totalTypes);
1317 
1318     constructor(address _apes, address _staking, address _mal, string memory baseUri) ERC1155(baseUri) {
1319       name_ = "Moon Pets";
1320       symbol_ = "MAL_PETS";
1321       petsBaseUri = baseUri;
1322 
1323       saleIsActive = false;
1324       isPaused = false;
1325       apeOwnershipRequired = true;
1326 
1327       APES = IERC721(address(_apes));
1328       STAKING = ISTAKING(address(_staking));
1329       MAL = IMAL(address(_mal));
1330       _isAuthorised[_staking] = true;
1331 
1332       maxSupplies[0] = 4000;
1333       maxSupplies[1] = 3520;
1334       maxSupplies[2] = 2880;
1335       maxSupplies[3] = 2240;
1336       maxSupplies[4] = 1600;
1337       maxSupplies[5] = 960;
1338       maxSupplies[6] = 640;
1339       maxSupplies[7] = 160;
1340 
1341       tokensPrices[0] = 1200 ether;
1342       tokensPrices[1] = 1600 ether;
1343       tokensPrices[2] = 2000 ether;
1344       tokensPrices[3] = 2400 ether;
1345       tokensPrices[4] = 3000 ether;
1346       tokensPrices[5] = 4000 ether;
1347       tokensPrices[6] = 5000 ether;
1348       tokensPrices[7] = 10000 ether;
1349 
1350       _detailsSet = true;
1351     }
1352 
1353     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) public override {
1354         require(from == _msgSender() || isApprovedForAll(from, _msgSender()) || _isAuthorised[_msgSender()], "ERC1155: caller is not owner nor approved");
1355         _safeTransferFrom(from, to, id, amount, data);
1356     }
1357 
1358     function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public virtual override {
1359         require(from == _msgSender() || isApprovedForAll(from, _msgSender()) || _isAuthorised[_msgSender()], "ERC1155: transfer caller is not owner nor approved");
1360         _safeBatchTransferFrom(from, to, ids, amounts, data);
1361     }
1362 
1363     function authorise(address addressToAuth) public onlyOwner {
1364       _isAuthorised[addressToAuth] = true;
1365       authorisedLog.push(addressToAuth);
1366     }
1367 
1368     function unauthorise(address addressToUnAuth) public onlyOwner {
1369       _isAuthorised[addressToUnAuth] = false;
1370     }
1371     
1372     function name() public view returns (string memory) {
1373       return name_;
1374     }
1375 
1376     function symbol() public view returns (string memory) {
1377       return symbol_;
1378     }
1379 
1380     function reserveForGiveaway(uint256[] memory tokenTypes, uint256[] memory tokenAmounts) public onlyOwner{
1381       require(tokenTypes.length == tokenAmounts.length, "Lists are not same length");
1382       for (uint256 i = 0; i < tokenTypes.length; i++){
1383             require(tokenTypes[i] <= uint256(PetTypes.PetArtifact), "Invalid token type");
1384             require(totalSupply(tokenTypes[i]) + tokenAmounts[i] <= maxSupplies[tokenTypes[i]], "You tried to mint more than allowed");
1385         }
1386       _mintBatch(_msgSender(), tokenTypes, tokenAmounts, "");
1387     }
1388 
1389     function giveaway(address[] memory receivers, uint256[] memory tokenTypes, uint256[] memory tokenAmounts) public onlyOwner{
1390       require(receivers.length == tokenTypes.length, "Lists are not same length");
1391       require(tokenTypes.length == tokenAmounts.length, "Lists are not same length");
1392       for (uint256 i = 0; i < receivers.length; i++){
1393         _mint(receivers[i], tokenTypes[i], tokenAmounts[i], "");
1394       }
1395     }
1396 
1397     function purchase(uint256[] memory tokensTypes, uint256[] memory tokensNumbers) public {
1398         require(tokensTypes.length == tokensNumbers.length, "Lists not same length");
1399         require(_detailsSet, "The mint has not started yet");
1400         require(saleIsActive, "The mint has not started yet");
1401         require(_validateApeOwnership(_msgSender()), "You do not have any Moon Apes");
1402         uint256 totalPrice = 0;
1403         uint256 totalAmount = 0;
1404         for (uint256 i = 0; i < tokensTypes.length; i++){
1405             require(tokensNumbers[i] > 0, "Wrong amount requested");
1406             require(tokensTypes[i] >= 0, "Invalid token type");
1407             require(tokensTypes[i] <= uint256(PetTypes.PetArtifact), "Invalid token type");
1408             require(totalSupply(tokensTypes[i]) + tokensNumbers[i] <= maxSupplies[tokensTypes[i]], "You tried to mint more than allowed");
1409             totalPrice += tokensPrices[tokensTypes[i]] * tokensNumbers[i];
1410             totalAmount += tokensNumbers[i];
1411         }
1412         MAL.spendMAL(_msgSender(), totalPrice);
1413 
1414         _mintBatch(_msgSender(), tokensTypes, tokensNumbers, "");
1415 
1416         emit PetsMinted(_msgSender(), totalAmount, tokensTypes.length);
1417     }
1418 
1419     function updateSaleStatus(bool status) public onlyOwner {
1420       saleIsActive = status;
1421     }
1422     
1423     function setTokenPrices(uint256[] memory _tokenTypes, uint256[] memory _tokenPrices, uint256[] memory _tokenMaxSupplies) public onlyOwner {
1424         require(_tokenTypes.length == _tokenPrices.length, "Lists not same length");
1425         require(!saleIsActive, "Price cannot be changed while sale is active");
1426         for (uint256 i = 0; i < _tokenTypes.length; i++){
1427             require(_tokenTypes[i] >= 0, "Invalid token type");
1428             require(_tokenTypes[i] <= uint256(PetTypes.PetArtifact), "Invalid token type");
1429             require(_tokenPrices[i] > 0, "Invalid price");
1430             tokensPrices[_tokenTypes[i]] = _tokenPrices[i];
1431             maxSupplies[_tokenTypes[i]] = _tokenMaxSupplies[i];
1432         }
1433         _detailsSet = true;
1434     }
1435 
1436     function _validateApeOwnership(address user) internal view returns (bool) {
1437       if (!apeOwnershipRequired) return true;
1438       if (STAKING.balanceOf(user) > 0) return true;
1439       return APES.balanceOf(user) > 0;
1440     }
1441 
1442     function updateApeOwnershipRequirement(bool _isOwnershipRequired) public onlyOwner {
1443       apeOwnershipRequired = _isOwnershipRequired;
1444     }
1445 
1446     function withdraw() external onlyOwner {
1447       uint256 balance = address(this).balance;
1448       payable(owner()).transfer(balance);
1449     }
1450 
1451     function pause(bool _isPaused) external onlyOwner {
1452       isPaused = _isPaused;
1453     }
1454 
1455     function uri(uint256 tokenType) public view override returns (string memory) {
1456         require(tokenType <= uint256(PetTypes.PetArtifact), "Invalid token type");
1457         return string(abi.encodePacked(string(abi.encodePacked(petsBaseUri, tokenType.toString())), ".json"));
1458     }
1459 
1460     function _beforeTokenTransfer(
1461         address operator,
1462         address from,
1463         address to,
1464         uint256[] memory ids,
1465         uint256[] memory amounts,
1466         bytes memory data
1467     ) internal virtual override {
1468         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1469 
1470         require(!isPaused, "ERC1155Pausable: token transfer while paused");
1471     }
1472 }