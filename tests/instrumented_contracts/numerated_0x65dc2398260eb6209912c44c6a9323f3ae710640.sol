1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.5.0
33 
34 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC1155 compliant contract, as defined in the
40  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
41  *
42  * _Available since v3.1._
43  */
44 interface IERC1155 is IERC165 {
45     /**
46      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
47      */
48     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
49 
50     /**
51      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
52      * transfers.
53      */
54     event TransferBatch(
55         address indexed operator,
56         address indexed from,
57         address indexed to,
58         uint256[] ids,
59         uint256[] values
60     );
61 
62     /**
63      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
64      * `approved`.
65      */
66     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
67 
68     /**
69      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
70      *
71      * If an {URI} event was emitted for `id`, the standard
72      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
73      * returned by {IERC1155MetadataURI-uri}.
74      */
75     event URI(string value, uint256 indexed id);
76 
77     /**
78      * @dev Returns the amount of tokens of token type `id` owned by `account`.
79      *
80      * Requirements:
81      *
82      * - `account` cannot be the zero address.
83      */
84     function balanceOf(address account, uint256 id) external view returns (uint256);
85 
86     /**
87      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
88      *
89      * Requirements:
90      *
91      * - `accounts` and `ids` must have the same length.
92      */
93     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
94         external
95         view
96         returns (uint256[] memory);
97 
98     /**
99      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
100      *
101      * Emits an {ApprovalForAll} event.
102      *
103      * Requirements:
104      *
105      * - `operator` cannot be the caller.
106      */
107     function setApprovalForAll(address operator, bool approved) external;
108 
109     /**
110      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
111      *
112      * See {setApprovalForAll}.
113      */
114     function isApprovedForAll(address account, address operator) external view returns (bool);
115 
116     /**
117      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
118      *
119      * Emits a {TransferSingle} event.
120      *
121      * Requirements:
122      *
123      * - `to` cannot be the zero address.
124      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
125      * - `from` must have a balance of tokens of type `id` of at least `amount`.
126      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
127      * acceptance magic value.
128      */
129     function safeTransferFrom(
130         address from,
131         address to,
132         uint256 id,
133         uint256 amount,
134         bytes calldata data
135     ) external;
136 
137     /**
138      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
139      *
140      * Emits a {TransferBatch} event.
141      *
142      * Requirements:
143      *
144      * - `ids` and `amounts` must have the same length.
145      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
146      * acceptance magic value.
147      */
148     function safeBatchTransferFrom(
149         address from,
150         address to,
151         uint256[] calldata ids,
152         uint256[] calldata amounts,
153         bytes calldata data
154     ) external;
155 }
156 
157 
158 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.5.0
159 
160 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 /**
165  * @dev _Available since v3.1._
166  */
167 interface IERC1155Receiver is IERC165 {
168     /**
169      * @dev Handles the receipt of a single ERC1155 token type. This function is
170      * called at the end of a `safeTransferFrom` after the balance has been updated.
171      *
172      * NOTE: To accept the transfer, this must return
173      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
174      * (i.e. 0xf23a6e61, or its own function selector).
175      *
176      * @param operator The address which initiated the transfer (i.e. msg.sender)
177      * @param from The address which previously owned the token
178      * @param id The ID of the token being transferred
179      * @param value The amount of tokens being transferred
180      * @param data Additional data with no specified format
181      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
182      */
183     function onERC1155Received(
184         address operator,
185         address from,
186         uint256 id,
187         uint256 value,
188         bytes calldata data
189     ) external returns (bytes4);
190 
191     /**
192      * @dev Handles the receipt of a multiple ERC1155 token types. This function
193      * is called at the end of a `safeBatchTransferFrom` after the balances have
194      * been updated.
195      *
196      * NOTE: To accept the transfer(s), this must return
197      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
198      * (i.e. 0xbc197c81, or its own function selector).
199      *
200      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
201      * @param from The address which previously owned the token
202      * @param ids An array containing ids of each token being transferred (order and length must match values array)
203      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
204      * @param data Additional data with no specified format
205      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
206      */
207     function onERC1155BatchReceived(
208         address operator,
209         address from,
210         uint256[] calldata ids,
211         uint256[] calldata values,
212         bytes calldata data
213     ) external returns (bytes4);
214 }
215 
216 
217 // File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.5.0
218 
219 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
225  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
226  *
227  * _Available since v3.1._
228  */
229 interface IERC1155MetadataURI is IERC1155 {
230     /**
231      * @dev Returns the URI for token type `id`.
232      *
233      * If the `\{id\}` substring is present in the URI, it must be replaced by
234      * clients with the actual token type ID.
235      */
236     function uri(uint256 id) external view returns (string memory);
237 }
238 
239 
240 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
241 
242 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
243 
244 pragma solidity ^0.8.1;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      *
267      * [IMPORTANT]
268      * ====
269      * You shouldn't rely on `isContract` to protect against flash loan attacks!
270      *
271      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
272      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
273      * constructor.
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // This method relies on extcodesize/address.code.length, which returns 0
278         // for contracts in construction, since the code is only stored at the end
279         // of the constructor execution.
280 
281         return account.code.length > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         (bool success, ) = recipient.call{value: amount}("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain `call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but also transferring `value` wei to `target`.
346      *
347      * Requirements:
348      *
349      * - the calling contract must have an ETH balance of at least `value`.
350      * - the called Solidity function must be `payable`.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(
369         address target,
370         bytes memory data,
371         uint256 value,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         require(isContract(target), "Address: call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.call{value: value}(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
388         return functionStaticCall(target, data, "Address: low-level static call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal view returns (bytes memory) {
402         require(isContract(target), "Address: static call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.staticcall(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
415         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420      * but performing a delegate call.
421      *
422      * _Available since v3.4._
423      */
424     function functionDelegateCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         require(isContract(target), "Address: delegate call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.delegatecall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
437      * revert reason using the provided one.
438      *
439      * _Available since v4.3._
440      */
441     function verifyCallResult(
442         bool success,
443         bytes memory returndata,
444         string memory errorMessage
445     ) internal pure returns (bytes memory) {
446         if (success) {
447             return returndata;
448         } else {
449             // Look for revert reason and bubble it up if present
450             if (returndata.length > 0) {
451                 // The easiest way to bubble the revert reason is using memory via assembly
452 
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 
465 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
466 
467 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @dev Provides information about the current execution context, including the
473  * sender of the transaction and its data. While these are generally available
474  * via msg.sender and msg.data, they should not be accessed in such a direct
475  * manner, since when dealing with meta-transactions the account sending and
476  * paying for execution may not be the actual sender (as far as an application
477  * is concerned).
478  *
479  * This contract is only required for intermediate, library-like contracts.
480  */
481 abstract contract Context {
482     function _msgSender() internal view virtual returns (address) {
483         return msg.sender;
484     }
485 
486     function _msgData() internal view virtual returns (bytes calldata) {
487         return msg.data;
488     }
489 }
490 
491 
492 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
493 
494 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev Implementation of the {IERC165} interface.
500  *
501  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
502  * for the additional interface id that will be supported. For example:
503  *
504  * ```solidity
505  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
506  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
507  * }
508  * ```
509  *
510  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
511  */
512 abstract contract ERC165 is IERC165 {
513     /**
514      * @dev See {IERC165-supportsInterface}.
515      */
516     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517         return interfaceId == type(IERC165).interfaceId;
518     }
519 }
520 
521 
522 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.5.0
523 
524 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 
530 
531 
532 
533 /**
534  * @dev Implementation of the basic standard multi-token.
535  * See https://eips.ethereum.org/EIPS/eip-1155
536  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
537  *
538  * _Available since v3.1._
539  */
540 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
541     using Address for address;
542 
543     // Mapping from token ID to account balances
544     mapping(uint256 => mapping(address => uint256)) private _balances;
545 
546     // Mapping from account to operator approvals
547     mapping(address => mapping(address => bool)) private _operatorApprovals;
548 
549     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
550     string private _uri;
551 
552     /**
553      * @dev See {_setURI}.
554      */
555     constructor(string memory uri_) {
556         _setURI(uri_);
557     }
558 
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
563         return
564             interfaceId == type(IERC1155).interfaceId ||
565             interfaceId == type(IERC1155MetadataURI).interfaceId ||
566             super.supportsInterface(interfaceId);
567     }
568 
569     /**
570      * @dev See {IERC1155MetadataURI-uri}.
571      *
572      * This implementation returns the same URI for *all* token types. It relies
573      * on the token type ID substitution mechanism
574      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
575      *
576      * Clients calling this function must replace the `\{id\}` substring with the
577      * actual token type ID.
578      */
579     function uri(uint256) public view virtual override returns (string memory) {
580         return _uri;
581     }
582 
583     /**
584      * @dev See {IERC1155-balanceOf}.
585      *
586      * Requirements:
587      *
588      * - `account` cannot be the zero address.
589      */
590     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
591         require(account != address(0), "ERC1155: balance query for the zero address");
592         return _balances[id][account];
593     }
594 
595     /**
596      * @dev See {IERC1155-balanceOfBatch}.
597      *
598      * Requirements:
599      *
600      * - `accounts` and `ids` must have the same length.
601      */
602     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
603         public
604         view
605         virtual
606         override
607         returns (uint256[] memory)
608     {
609         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
610 
611         uint256[] memory batchBalances = new uint256[](accounts.length);
612 
613         for (uint256 i = 0; i < accounts.length; ++i) {
614             batchBalances[i] = balanceOf(accounts[i], ids[i]);
615         }
616 
617         return batchBalances;
618     }
619 
620     /**
621      * @dev See {IERC1155-setApprovalForAll}.
622      */
623     function setApprovalForAll(address operator, bool approved) public virtual override {
624         _setApprovalForAll(_msgSender(), operator, approved);
625     }
626 
627     /**
628      * @dev See {IERC1155-isApprovedForAll}.
629      */
630     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
631         return _operatorApprovals[account][operator];
632     }
633 
634     /**
635      * @dev See {IERC1155-safeTransferFrom}.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 id,
641         uint256 amount,
642         bytes memory data
643     ) public virtual override {
644         require(
645             from == _msgSender() || isApprovedForAll(from, _msgSender()),
646             "ERC1155: caller is not owner nor approved"
647         );
648         _safeTransferFrom(from, to, id, amount, data);
649     }
650 
651     /**
652      * @dev See {IERC1155-safeBatchTransferFrom}.
653      */
654     function safeBatchTransferFrom(
655         address from,
656         address to,
657         uint256[] memory ids,
658         uint256[] memory amounts,
659         bytes memory data
660     ) public virtual override {
661         require(
662             from == _msgSender() || isApprovedForAll(from, _msgSender()),
663             "ERC1155: transfer caller is not owner nor approved"
664         );
665         _safeBatchTransferFrom(from, to, ids, amounts, data);
666     }
667 
668     /**
669      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
670      *
671      * Emits a {TransferSingle} event.
672      *
673      * Requirements:
674      *
675      * - `to` cannot be the zero address.
676      * - `from` must have a balance of tokens of type `id` of at least `amount`.
677      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
678      * acceptance magic value.
679      */
680     function _safeTransferFrom(
681         address from,
682         address to,
683         uint256 id,
684         uint256 amount,
685         bytes memory data
686     ) internal virtual {
687         require(to != address(0), "ERC1155: transfer to the zero address");
688 
689         address operator = _msgSender();
690 
691         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
692 
693         uint256 fromBalance = _balances[id][from];
694         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
695         unchecked {
696             _balances[id][from] = fromBalance - amount;
697         }
698         _balances[id][to] += amount;
699 
700         emit TransferSingle(operator, from, to, id, amount);
701 
702         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
703     }
704 
705     /**
706      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
707      *
708      * Emits a {TransferBatch} event.
709      *
710      * Requirements:
711      *
712      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
713      * acceptance magic value.
714      */
715     function _safeBatchTransferFrom(
716         address from,
717         address to,
718         uint256[] memory ids,
719         uint256[] memory amounts,
720         bytes memory data
721     ) internal virtual {
722         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
723         require(to != address(0), "ERC1155: transfer to the zero address");
724 
725         address operator = _msgSender();
726 
727         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
728 
729         for (uint256 i = 0; i < ids.length; ++i) {
730             uint256 id = ids[i];
731             uint256 amount = amounts[i];
732 
733             uint256 fromBalance = _balances[id][from];
734             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
735             unchecked {
736                 _balances[id][from] = fromBalance - amount;
737             }
738             _balances[id][to] += amount;
739         }
740 
741         emit TransferBatch(operator, from, to, ids, amounts);
742 
743         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
744     }
745 
746     /**
747      * @dev Sets a new URI for all token types, by relying on the token type ID
748      * substitution mechanism
749      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
750      *
751      * By this mechanism, any occurrence of the `\{id\}` substring in either the
752      * URI or any of the amounts in the JSON file at said URI will be replaced by
753      * clients with the token type ID.
754      *
755      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
756      * interpreted by clients as
757      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
758      * for token type ID 0x4cce0.
759      *
760      * See {uri}.
761      *
762      * Because these URIs cannot be meaningfully represented by the {URI} event,
763      * this function emits no events.
764      */
765     function _setURI(string memory newuri) internal virtual {
766         _uri = newuri;
767     }
768 
769     /**
770      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
771      *
772      * Emits a {TransferSingle} event.
773      *
774      * Requirements:
775      *
776      * - `to` cannot be the zero address.
777      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
778      * acceptance magic value.
779      */
780     function _mint(
781         address to,
782         uint256 id,
783         uint256 amount,
784         bytes memory data
785     ) internal virtual {
786         require(to != address(0), "ERC1155: mint to the zero address");
787 
788         address operator = _msgSender();
789 
790         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
791 
792         _balances[id][to] += amount;
793         emit TransferSingle(operator, address(0), to, id, amount);
794 
795         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
796     }
797 
798     /**
799      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
800      *
801      * Requirements:
802      *
803      * - `ids` and `amounts` must have the same length.
804      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
805      * acceptance magic value.
806      */
807     function _mintBatch(
808         address to,
809         uint256[] memory ids,
810         uint256[] memory amounts,
811         bytes memory data
812     ) internal virtual {
813         require(to != address(0), "ERC1155: mint to the zero address");
814         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
815 
816         address operator = _msgSender();
817 
818         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
819 
820         for (uint256 i = 0; i < ids.length; i++) {
821             _balances[ids[i]][to] += amounts[i];
822         }
823 
824         emit TransferBatch(operator, address(0), to, ids, amounts);
825 
826         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
827     }
828 
829     /**
830      * @dev Destroys `amount` tokens of token type `id` from `from`
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `from` must have at least `amount` tokens of token type `id`.
836      */
837     function _burn(
838         address from,
839         uint256 id,
840         uint256 amount
841     ) internal virtual {
842         require(from != address(0), "ERC1155: burn from the zero address");
843 
844         address operator = _msgSender();
845 
846         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
847 
848         uint256 fromBalance = _balances[id][from];
849         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
850         unchecked {
851             _balances[id][from] = fromBalance - amount;
852         }
853 
854         emit TransferSingle(operator, from, address(0), id, amount);
855     }
856 
857     /**
858      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
859      *
860      * Requirements:
861      *
862      * - `ids` and `amounts` must have the same length.
863      */
864     function _burnBatch(
865         address from,
866         uint256[] memory ids,
867         uint256[] memory amounts
868     ) internal virtual {
869         require(from != address(0), "ERC1155: burn from the zero address");
870         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
871 
872         address operator = _msgSender();
873 
874         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
875 
876         for (uint256 i = 0; i < ids.length; i++) {
877             uint256 id = ids[i];
878             uint256 amount = amounts[i];
879 
880             uint256 fromBalance = _balances[id][from];
881             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
882             unchecked {
883                 _balances[id][from] = fromBalance - amount;
884             }
885         }
886 
887         emit TransferBatch(operator, from, address(0), ids, amounts);
888     }
889 
890     /**
891      * @dev Approve `operator` to operate on all of `owner` tokens
892      *
893      * Emits a {ApprovalForAll} event.
894      */
895     function _setApprovalForAll(
896         address owner,
897         address operator,
898         bool approved
899     ) internal virtual {
900         require(owner != operator, "ERC1155: setting approval status for self");
901         _operatorApprovals[owner][operator] = approved;
902         emit ApprovalForAll(owner, operator, approved);
903     }
904 
905     /**
906      * @dev Hook that is called before any token transfer. This includes minting
907      * and burning, as well as batched variants.
908      *
909      * The same hook is called on both single and batched variants. For single
910      * transfers, the length of the `id` and `amount` arrays will be 1.
911      *
912      * Calling conditions (for each `id` and `amount` pair):
913      *
914      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
915      * of token type `id` will be  transferred to `to`.
916      * - When `from` is zero, `amount` tokens of token type `id` will be minted
917      * for `to`.
918      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
919      * will be burned.
920      * - `from` and `to` are never both zero.
921      * - `ids` and `amounts` have the same, non-zero length.
922      *
923      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
924      */
925     function _beforeTokenTransfer(
926         address operator,
927         address from,
928         address to,
929         uint256[] memory ids,
930         uint256[] memory amounts,
931         bytes memory data
932     ) internal virtual {}
933 
934     function _doSafeTransferAcceptanceCheck(
935         address operator,
936         address from,
937         address to,
938         uint256 id,
939         uint256 amount,
940         bytes memory data
941     ) private {
942         if (to.isContract()) {
943             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
944                 if (response != IERC1155Receiver.onERC1155Received.selector) {
945                     revert("ERC1155: ERC1155Receiver rejected tokens");
946                 }
947             } catch Error(string memory reason) {
948                 revert(reason);
949             } catch {
950                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
951             }
952         }
953     }
954 
955     function _doSafeBatchTransferAcceptanceCheck(
956         address operator,
957         address from,
958         address to,
959         uint256[] memory ids,
960         uint256[] memory amounts,
961         bytes memory data
962     ) private {
963         if (to.isContract()) {
964             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
965                 bytes4 response
966             ) {
967                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
968                     revert("ERC1155: ERC1155Receiver rejected tokens");
969                 }
970             } catch Error(string memory reason) {
971                 revert(reason);
972             } catch {
973                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
974             }
975         }
976     }
977 
978     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
979         uint256[] memory array = new uint256[](1);
980         array[0] = element;
981 
982         return array;
983     }
984 }
985 
986 
987 // File @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol@v4.5.0
988 
989 
990 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Burnable.sol)
991 
992 pragma solidity ^0.8.0;
993 
994 /**
995  * @dev Extension of {ERC1155} that allows token holders to destroy both their
996  * own tokens and those that they have been approved to use.
997  *
998  * _Available since v3.1._
999  */
1000 abstract contract ERC1155Burnable is ERC1155 {
1001     function burn(
1002         address account,
1003         uint256 id,
1004         uint256 value
1005     ) public virtual {
1006         require(
1007             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1008             "ERC1155: caller is not owner nor approved"
1009         );
1010 
1011         _burn(account, id, value);
1012     }
1013 
1014     function burnBatch(
1015         address account,
1016         uint256[] memory ids,
1017         uint256[] memory values
1018     ) public virtual {
1019         require(
1020             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1021             "ERC1155: caller is not owner nor approved"
1022         );
1023 
1024         _burnBatch(account, ids, values);
1025     }
1026 }
1027 
1028 
1029 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
1030 
1031 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1032 
1033 pragma solidity ^0.8.0;
1034 
1035 /**
1036  * @dev Interface of the ERC20 standard as defined in the EIP.
1037  */
1038 interface IERC20 {
1039     /**
1040      * @dev Returns the amount of tokens in existence.
1041      */
1042     function totalSupply() external view returns (uint256);
1043 
1044     /**
1045      * @dev Returns the amount of tokens owned by `account`.
1046      */
1047     function balanceOf(address account) external view returns (uint256);
1048 
1049     /**
1050      * @dev Moves `amount` tokens from the caller's account to `to`.
1051      *
1052      * Returns a boolean value indicating whether the operation succeeded.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function transfer(address to, uint256 amount) external returns (bool);
1057 
1058     /**
1059      * @dev Returns the remaining number of tokens that `spender` will be
1060      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1061      * zero by default.
1062      *
1063      * This value changes when {approve} or {transferFrom} are called.
1064      */
1065     function allowance(address owner, address spender) external view returns (uint256);
1066 
1067     /**
1068      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1069      *
1070      * Returns a boolean value indicating whether the operation succeeded.
1071      *
1072      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1073      * that someone may use both the old and the new allowance by unfortunate
1074      * transaction ordering. One possible solution to mitigate this race
1075      * condition is to first reduce the spender's allowance to 0 and set the
1076      * desired value afterwards:
1077      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1078      *
1079      * Emits an {Approval} event.
1080      */
1081     function approve(address spender, uint256 amount) external returns (bool);
1082 
1083     /**
1084      * @dev Moves `amount` tokens from `from` to `to` using the
1085      * allowance mechanism. `amount` is then deducted from the caller's
1086      * allowance.
1087      *
1088      * Returns a boolean value indicating whether the operation succeeded.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function transferFrom(
1093         address from,
1094         address to,
1095         uint256 amount
1096     ) external returns (bool);
1097 
1098     /**
1099      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1100      * another (`to`).
1101      *
1102      * Note that `value` may be zero.
1103      */
1104     event Transfer(address indexed from, address indexed to, uint256 value);
1105 
1106     /**
1107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1108      * a call to {approve}. `value` is the new allowance.
1109      */
1110     event Approval(address indexed owner, address indexed spender, uint256 value);
1111 }
1112 
1113 
1114 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
1115 
1116 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 /**
1121  * @dev String operations.
1122  */
1123 library Strings {
1124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1125 
1126     /**
1127      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1128      */
1129     function toString(uint256 value) internal pure returns (string memory) {
1130         // Inspired by OraclizeAPI's implementation - MIT licence
1131         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1132 
1133         if (value == 0) {
1134             return "0";
1135         }
1136         uint256 temp = value;
1137         uint256 digits;
1138         while (temp != 0) {
1139             digits++;
1140             temp /= 10;
1141         }
1142         bytes memory buffer = new bytes(digits);
1143         while (value != 0) {
1144             digits -= 1;
1145             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1146             value /= 10;
1147         }
1148         return string(buffer);
1149     }
1150 
1151     /**
1152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1153      */
1154     function toHexString(uint256 value) internal pure returns (string memory) {
1155         if (value == 0) {
1156             return "0x00";
1157         }
1158         uint256 temp = value;
1159         uint256 length = 0;
1160         while (temp != 0) {
1161             length++;
1162             temp >>= 8;
1163         }
1164         return toHexString(value, length);
1165     }
1166 
1167     /**
1168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1169      */
1170     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1171         bytes memory buffer = new bytes(2 * length + 2);
1172         buffer[0] = "0";
1173         buffer[1] = "x";
1174         for (uint256 i = 2 * length + 1; i > 1; --i) {
1175             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1176             value >>= 4;
1177         }
1178         require(value == 0, "Strings: hex length insufficient");
1179         return string(buffer);
1180     }
1181 }
1182 
1183 
1184 // File @openzeppelin/contracts/utils/Counters.sol@v4.5.0
1185 
1186 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 /**
1191  * @title Counters
1192  * @author Matt Condon (@shrugs)
1193  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1194  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1195  *
1196  * Include with `using Counters for Counters.Counter;`
1197  */
1198 library Counters {
1199     struct Counter {
1200         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1201         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1202         // this feature: see https://github.com/ethereum/solidity/issues/4637
1203         uint256 _value; // default: 0
1204     }
1205 
1206     function current(Counter storage counter) internal view returns (uint256) {
1207         return counter._value;
1208     }
1209 
1210     function increment(Counter storage counter) internal {
1211         unchecked {
1212             counter._value += 1;
1213         }
1214     }
1215 
1216     function decrement(Counter storage counter) internal {
1217         uint256 value = counter._value;
1218         require(value > 0, "Counter: decrement overflow");
1219         unchecked {
1220             counter._value = value - 1;
1221         }
1222     }
1223 
1224     function reset(Counter storage counter) internal {
1225         counter._value = 0;
1226     }
1227 }
1228 
1229 
1230 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1231 
1232 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1233 
1234 pragma solidity ^0.8.0;
1235 
1236 /**
1237  * @dev Contract module which provides a basic access control mechanism, where
1238  * there is an account (an owner) that can be granted exclusive access to
1239  * specific functions.
1240  *
1241  * By default, the owner account will be the one that deploys the contract. This
1242  * can later be changed with {transferOwnership}.
1243  *
1244  * This module is used through inheritance. It will make available the modifier
1245  * `onlyOwner`, which can be applied to your functions to restrict their use to
1246  * the owner.
1247  */
1248 abstract contract Ownable is Context {
1249     address private _owner;
1250 
1251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1252 
1253     /**
1254      * @dev Initializes the contract setting the deployer as the initial owner.
1255      */
1256     constructor() {
1257         _transferOwnership(_msgSender());
1258     }
1259 
1260     /**
1261      * @dev Returns the address of the current owner.
1262      */
1263     function owner() public view virtual returns (address) {
1264         return _owner;
1265     }
1266 
1267     /**
1268      * @dev Throws if called by any account other than the owner.
1269      */
1270     modifier onlyOwner() {
1271         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1272         _;
1273     }
1274 
1275     /**
1276      * @dev Leaves the contract without owner. It will not be possible to call
1277      * `onlyOwner` functions anymore. Can only be called by the current owner.
1278      *
1279      * NOTE: Renouncing ownership will leave the contract without an owner,
1280      * thereby removing any functionality that is only available to the owner.
1281      */
1282     function renounceOwnership() public virtual onlyOwner {
1283         _transferOwnership(address(0));
1284     }
1285 
1286     /**
1287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1288      * Can only be called by the current owner.
1289      */
1290     function transferOwnership(address newOwner) public virtual onlyOwner {
1291         require(newOwner != address(0), "Ownable: new owner is the zero address");
1292         _transferOwnership(newOwner);
1293     }
1294 
1295     /**
1296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1297      * Internal function without access restriction.
1298      */
1299     function _transferOwnership(address newOwner) internal virtual {
1300         address oldOwner = _owner;
1301         _owner = newOwner;
1302         emit OwnershipTransferred(oldOwner, newOwner);
1303     }
1304 }
1305 
1306 
1307 // File @openzeppelin/contracts/security/Pausable.sol@v4.5.0
1308 
1309 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1310 
1311 pragma solidity ^0.8.0;
1312 
1313 /**
1314  * @dev Contract module which allows children to implement an emergency stop
1315  * mechanism that can be triggered by an authorized account.
1316  *
1317  * This module is used through inheritance. It will make available the
1318  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1319  * the functions of your contract. Note that they will not be pausable by
1320  * simply including this module, only once the modifiers are put in place.
1321  */
1322 abstract contract Pausable is Context {
1323     /**
1324      * @dev Emitted when the pause is triggered by `account`.
1325      */
1326     event Paused(address account);
1327 
1328     /**
1329      * @dev Emitted when the pause is lifted by `account`.
1330      */
1331     event Unpaused(address account);
1332 
1333     bool private _paused;
1334 
1335     /**
1336      * @dev Initializes the contract in unpaused state.
1337      */
1338     constructor() {
1339         _paused = false;
1340     }
1341 
1342     /**
1343      * @dev Returns true if the contract is paused, and false otherwise.
1344      */
1345     function paused() public view virtual returns (bool) {
1346         return _paused;
1347     }
1348 
1349     /**
1350      * @dev Modifier to make a function callable only when the contract is not paused.
1351      *
1352      * Requirements:
1353      *
1354      * - The contract must not be paused.
1355      */
1356     modifier whenNotPaused() {
1357         require(!paused(), "Pausable: paused");
1358         _;
1359     }
1360 
1361     /**
1362      * @dev Modifier to make a function callable only when the contract is paused.
1363      *
1364      * Requirements:
1365      *
1366      * - The contract must be paused.
1367      */
1368     modifier whenPaused() {
1369         require(paused(), "Pausable: not paused");
1370         _;
1371     }
1372 
1373     /**
1374      * @dev Triggers stopped state.
1375      *
1376      * Requirements:
1377      *
1378      * - The contract must not be paused.
1379      */
1380     function _pause() internal virtual whenNotPaused {
1381         _paused = true;
1382         emit Paused(_msgSender());
1383     }
1384 
1385     /**
1386      * @dev Returns to normal state.
1387      *
1388      * Requirements:
1389      *
1390      * - The contract must be paused.
1391      */
1392     function _unpause() internal virtual whenPaused {
1393         _paused = false;
1394         emit Unpaused(_msgSender());
1395     }
1396 }
1397 
1398 
1399 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
1400 
1401 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1402 
1403 pragma solidity ^0.8.0;
1404 
1405 /**
1406  * @dev Contract module that helps prevent reentrant calls to a function.
1407  *
1408  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1409  * available, which can be applied to functions to make sure there are no nested
1410  * (reentrant) calls to them.
1411  *
1412  * Note that because there is a single `nonReentrant` guard, functions marked as
1413  * `nonReentrant` may not call one another. This can be worked around by making
1414  * those functions `private`, and then adding `external` `nonReentrant` entry
1415  * points to them.
1416  *
1417  * TIP: If you would like to learn more about reentrancy and alternative ways
1418  * to protect against it, check out our blog post
1419  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1420  */
1421 abstract contract ReentrancyGuard {
1422     // Booleans are more expensive than uint256 or any type that takes up a full
1423     // word because each write operation emits an extra SLOAD to first read the
1424     // slot's contents, replace the bits taken up by the boolean, and then write
1425     // back. This is the compiler's defense against contract upgrades and
1426     // pointer aliasing, and it cannot be disabled.
1427 
1428     // The values being non-zero value makes deployment a bit more expensive,
1429     // but in exchange the refund on every call to nonReentrant will be lower in
1430     // amount. Since refunds are capped to a percentage of the total
1431     // transaction's gas, it is best to keep them low in cases like this one, to
1432     // increase the likelihood of the full refund coming into effect.
1433     uint256 private constant _NOT_ENTERED = 1;
1434     uint256 private constant _ENTERED = 2;
1435 
1436     uint256 private _status;
1437 
1438     constructor() {
1439         _status = _NOT_ENTERED;
1440     }
1441 
1442     /**
1443      * @dev Prevents a contract from calling itself, directly or indirectly.
1444      * Calling a `nonReentrant` function from another `nonReentrant`
1445      * function is not supported. It is possible to prevent this from happening
1446      * by making the `nonReentrant` function external, and making it call a
1447      * `private` function that does the actual work.
1448      */
1449     modifier nonReentrant() {
1450         // On the first call to nonReentrant, _notEntered will be true
1451         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1452 
1453         // Any calls to nonReentrant after this point will fail
1454         _status = _ENTERED;
1455 
1456         _;
1457 
1458         // By storing the original value once again, a refund is triggered (see
1459         // https://eips.ethereum.org/EIPS/eip-2200)
1460         _status = _NOT_ENTERED;
1461     }
1462 }
1463 
1464 
1465 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
1466 
1467 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1468 
1469 pragma solidity ^0.8.0;
1470 
1471 /**
1472  * @dev Required interface of an ERC721 compliant contract.
1473  */
1474 interface IERC721 is IERC165 {
1475     /**
1476      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1477      */
1478     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1479 
1480     /**
1481      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1482      */
1483     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1484 
1485     /**
1486      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1487      */
1488     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1489 
1490     /**
1491      * @dev Returns the number of tokens in ``owner``'s account.
1492      */
1493     function balanceOf(address owner) external view returns (uint256 balance);
1494 
1495     /**
1496      * @dev Returns the owner of the `tokenId` token.
1497      *
1498      * Requirements:
1499      *
1500      * - `tokenId` must exist.
1501      */
1502     function ownerOf(uint256 tokenId) external view returns (address owner);
1503 
1504     /**
1505      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1506      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1507      *
1508      * Requirements:
1509      *
1510      * - `from` cannot be the zero address.
1511      * - `to` cannot be the zero address.
1512      * - `tokenId` token must exist and be owned by `from`.
1513      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1514      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1515      *
1516      * Emits a {Transfer} event.
1517      */
1518     function safeTransferFrom(
1519         address from,
1520         address to,
1521         uint256 tokenId
1522     ) external;
1523 
1524     /**
1525      * @dev Transfers `tokenId` token from `from` to `to`.
1526      *
1527      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1528      *
1529      * Requirements:
1530      *
1531      * - `from` cannot be the zero address.
1532      * - `to` cannot be the zero address.
1533      * - `tokenId` token must be owned by `from`.
1534      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1535      *
1536      * Emits a {Transfer} event.
1537      */
1538     function transferFrom(
1539         address from,
1540         address to,
1541         uint256 tokenId
1542     ) external;
1543 
1544     /**
1545      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1546      * The approval is cleared when the token is transferred.
1547      *
1548      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1549      *
1550      * Requirements:
1551      *
1552      * - The caller must own the token or be an approved operator.
1553      * - `tokenId` must exist.
1554      *
1555      * Emits an {Approval} event.
1556      */
1557     function approve(address to, uint256 tokenId) external;
1558 
1559     /**
1560      * @dev Returns the account approved for `tokenId` token.
1561      *
1562      * Requirements:
1563      *
1564      * - `tokenId` must exist.
1565      */
1566     function getApproved(uint256 tokenId) external view returns (address operator);
1567 
1568     /**
1569      * @dev Approve or remove `operator` as an operator for the caller.
1570      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1571      *
1572      * Requirements:
1573      *
1574      * - The `operator` cannot be the caller.
1575      *
1576      * Emits an {ApprovalForAll} event.
1577      */
1578     function setApprovalForAll(address operator, bool _approved) external;
1579 
1580     /**
1581      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1582      *
1583      * See {setApprovalForAll}
1584      */
1585     function isApprovedForAll(address owner, address operator) external view returns (bool);
1586 
1587     /**
1588      * @dev Safely transfers `tokenId` token from `from` to `to`.
1589      *
1590      * Requirements:
1591      *
1592      * - `from` cannot be the zero address.
1593      * - `to` cannot be the zero address.
1594      * - `tokenId` token must exist and be owned by `from`.
1595      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1596      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1597      *
1598      * Emits a {Transfer} event.
1599      */
1600     function safeTransferFrom(
1601         address from,
1602         address to,
1603         uint256 tokenId,
1604         bytes calldata data
1605     ) external;
1606 }
1607 
1608 
1609 // File @openzeppelin/contracts/interfaces/IERC721.sol@v4.5.0
1610 
1611 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
1612 
1613 pragma solidity ^0.8.0;
1614 
1615 
1616 // File contracts/QMCapsule.sol
1617 
1618 pragma solidity ^0.8.0;
1619 
1620 
1621 
1622 
1623 
1624 
1625 
1626 
1627 
1628 contract QMCapsule is ERC1155, ERC1155Burnable, Ownable, Pausable, ReentrancyGuard {
1629 
1630     using Strings for uint256;
1631     using Counters for Counters.Counter;
1632 
1633     string public baseExtension = ".json";
1634 
1635     uint private constant PAIRED_CAP_RED = 1;
1636     uint private constant PAIRED_CAP_ORANGE = 2;
1637     uint private constant PAIRED_CAP_YELLOW = 3;
1638     uint private constant PAIRED_CAP_GREEN = 4;
1639     uint private constant PAIRED_CAP_BLUE = 5;
1640     uint private constant PAIRED_CAP_PURPLE = 6;
1641     uint private constant PAIRED_CAP_BLACK = 7;
1642     uint private constant PAIRED_CAP_SILVER = 8;
1643     uint private constant PAIRED_CAP_GOLD = 9;
1644     
1645     uint public constant MAX_TOKEN_COUNT = 9;
1646     uint private constant BATCH_LIMIT = 20;
1647 
1648     uint256 private nonce;
1649 
1650     string public baseURI = "";
1651 
1652     mapping(address => bool) public approvedContractList;
1653     mapping(address => mapping(uint => bool)) public claimList;
1654 
1655     event Claim(address indexed _nftContract, uint256 _tokenId, address _claimant, uint256 _mintedId);
1656     event BatchClaim(address[] _nftContracts, uint256[] _tokenIds, address _claimant, uint256[] _mintedIds);
1657     event BatchOwnerClaim(address[] _nftContracts, uint256[] _tokenIds, address[] _claimants, uint256[] _mintedIds);
1658     event ApprovedContractAdded(address indexed _nftContract);
1659 
1660     constructor() ERC1155(baseURI) {
1661         pauseClaim();
1662     }
1663 
1664     function uri(uint _tokenId) public view override returns (string memory) {
1665         require(_tokenId > 0 && _tokenId <= MAX_TOKEN_COUNT, "URI requested for invalid token");
1666         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, _tokenId.toString(), baseExtension)) : baseURI;
1667     }
1668 
1669     function isClaimed(address _contract, uint _tokenId) public view returns (bool) {
1670         return claimList[_contract][_tokenId] ? true : false;
1671     }
1672 
1673     function batchClaim(address[] calldata _contracts, uint[] calldata _tokenIds)  public whenNotPaused nonReentrant returns (uint[] memory) {
1674         require(_contracts.length <= BATCH_LIMIT, "QM: Batch Contracts more than limit");
1675         require(_tokenIds.length <= BATCH_LIMIT, "QM: Token IDs more than limit");
1676         require(_contracts.length == _tokenIds.length, "QM: Size should be the same");
1677 
1678         uint[] memory tokenIdsMinted = new uint[](_contracts.length);
1679 
1680         for (uint i = 0; i < _contracts.length; ++i) {
1681             uint id = _claim(_contracts[i], _tokenIds[i]);
1682             tokenIdsMinted[i] = id;
1683         }
1684 
1685         emit BatchClaim(_contracts, _tokenIds, msg.sender, tokenIdsMinted);
1686         
1687         return tokenIdsMinted;
1688     }
1689 
1690 
1691     function ownerBatchClaim(address[] calldata _owners, address[] calldata _contracts, uint[] calldata _tokenIds)  public nonReentrant onlyOwner returns (uint[] memory) {
1692         require(_contracts.length <= BATCH_LIMIT, "QM: Batch more than limit");
1693         require(_contracts.length == _tokenIds.length && _owners.length == _tokenIds.length, "QM: Size should be the same");
1694 
1695         uint[] memory tokenIdsMinted = new uint[](_contracts.length);
1696 
1697         for (uint i = 0; i < _contracts.length; ++i) {
1698             uint id = _ownerOnlyclaim(_owners[i], _contracts[i], _tokenIds[i]);
1699             tokenIdsMinted[i] = id;
1700         }
1701 
1702         emit BatchOwnerClaim(_contracts, _tokenIds, _owners, tokenIdsMinted);
1703         
1704         return tokenIdsMinted;
1705     }
1706 
1707     function claim(address _contract, uint _tokenId) public whenNotPaused nonReentrant returns (uint) {
1708 
1709         uint tokenIdMinted = _claim(_contract, _tokenId);
1710 
1711         emit Claim(_contract, _tokenId, msg.sender, tokenIdMinted);
1712         return tokenIdMinted;
1713     }
1714 
1715     function _claim(address _contract, uint _tokenId) private returns (uint) {
1716 
1717         require(approvedContractList[_contract], "QM: Not on approved list");
1718         require(claimList[_contract][_tokenId] == false, "QM: Capsule already claimed");
1719         
1720         address tokenOwner = IERC721(_contract).ownerOf(_tokenId);
1721         require(tokenOwner == msg.sender, "QM: Sender not owner");
1722 
1723         claimList[_contract][_tokenId] = true;
1724         uint tokenIdMinted = _randomMintCapsule(msg.sender);
1725 
1726         return tokenIdMinted;
1727     }
1728 
1729     function _ownerOnlyclaim(address _owner, address _contract, uint _tokenId) private returns (uint) {
1730 
1731         require(approvedContractList[_contract], "QM: Not on approved list");
1732         require(claimList[_contract][_tokenId] == false, "QM: Capsule already claimed");
1733 
1734         claimList[_contract][_tokenId] = true;
1735         uint tokenIdMinted = _randomMintCapsule(_owner);
1736 
1737         return tokenIdMinted;
1738     }
1739 
1740     function _randomMintCapsule(address _recipient) private returns(uint){
1741 
1742         uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % MAX_TOKEN_COUNT;
1743         randomnumber = randomnumber + 1;
1744         nonce++;
1745 
1746         _mint(_recipient, randomnumber, 1, "");
1747 
1748         return randomnumber;
1749     }
1750 
1751     function ownerMint(uint _tokenId, uint256 qty) public onlyOwner{
1752         require(_tokenId > 0 && _tokenId <= MAX_TOKEN_COUNT, "QM: Invalid Token ID");
1753         _mint(owner(), _tokenId, qty, "");
1754     }
1755 
1756     function addApproveContract(address _contract) public onlyOwner {
1757         approvedContractList[_contract] = true;
1758         emit ApprovedContractAdded(_contract);
1759     }
1760 
1761     function pauseClaim() public onlyOwner {
1762         _pause();
1763     }
1764 
1765     function unpauseClaim() public onlyOwner {
1766         _unpause();
1767     }
1768 
1769     function setBaseURI(string memory _baseURI) public onlyOwner {
1770         baseURI = _baseURI;
1771     }
1772 
1773     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1774         baseExtension = _newBaseExtension;
1775     }
1776     
1777     function _beforeTokenTransfer(
1778         address operator,
1779         address from,
1780         address to,
1781         uint256[] memory ids,
1782         uint256[] memory amounts,
1783         bytes memory data
1784     ) override internal virtual {}
1785 
1786 }