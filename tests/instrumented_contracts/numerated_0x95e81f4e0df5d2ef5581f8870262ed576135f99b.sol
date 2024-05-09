1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      */
29     function isContract(address account) internal view returns (bool) {
30         // This method relies on extcodesize, which returns 0 for contracts in
31         // construction, since the code is only stored at the end of the
32         // constructor execution.
33 
34         uint256 size;
35         assembly {
36             size := extcodesize(account)
37         }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         (bool success, ) = recipient.call{value: amount}("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain `call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83         return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal returns (bytes memory) {
97         return functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
102      * but also transferring `value` wei to `target`.
103      *
104      * Requirements:
105      *
106      * - the calling contract must have an ETH balance of at least `value`.
107      * - the called Solidity function must be `payable`.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
121      * with `errorMessage` as a fallback revert reason when `target` reverts.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value,
129         string memory errorMessage
130     ) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         require(isContract(target), "Address: call to non-contract");
133 
134         (bool success, bytes memory returndata) = target.call{value: value}(data);
135         return verifyCallResult(success, returndata, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
145         return functionStaticCall(target, data, "Address: low-level static call failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal view returns (bytes memory) {
159         require(isContract(target), "Address: static call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.staticcall(data);
162         return verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         require(isContract(target), "Address: delegate call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
194      * revert reason using the provided one.
195      *
196      * _Available since v4.3._
197      */
198     function verifyCallResult(
199         bool success,
200         bytes memory returndata,
201         string memory errorMessage
202     ) internal pure returns (bytes memory) {
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Interface of the ERC165 standard, as defined in the
230  * https://eips.ethereum.org/EIPS/eip-165[EIP].
231  *
232  * Implementers can declare support of contract interfaces, which can then be
233  * queried by others ({ERC165Checker}).
234  *
235  * For an implementation, see {ERC165}.
236  */
237 interface IERC165 {
238     /**
239      * @dev Returns true if this contract implements the interface defined by
240      * `interfaceId`. See the corresponding
241      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
242      * to learn more about how these ids are created.
243      *
244      * This function call must use less than 30 000 gas.
245      */
246     function supportsInterface(bytes4 interfaceId) external view returns (bool);
247 }
248 
249 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 
257 /**
258  * @dev Implementation of the {IERC165} interface.
259  *
260  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
261  * for the additional interface id that will be supported. For example:
262  *
263  * ```solidity
264  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
265  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
266  * }
267  * ```
268  *
269  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
270  */
271 abstract contract ERC165 is IERC165 {
272     /**
273      * @dev See {IERC165-supportsInterface}.
274      */
275     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
276         return interfaceId == type(IERC165).interfaceId;
277     }
278 }
279 
280 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
281 
282 
283 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 
288 /**
289  * @dev _Available since v3.1._
290  */
291 interface IERC1155Receiver is IERC165 {
292     /**
293         @dev Handles the receipt of a single ERC1155 token type. This function is
294         called at the end of a `safeTransferFrom` after the balance has been updated.
295         To accept the transfer, this must return
296         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
297         (i.e. 0xf23a6e61, or its own function selector).
298         @param operator The address which initiated the transfer (i.e. msg.sender)
299         @param from The address which previously owned the token
300         @param id The ID of the token being transferred
301         @param value The amount of tokens being transferred
302         @param data Additional data with no specified format
303         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
304     */
305     function onERC1155Received(
306         address operator,
307         address from,
308         uint256 id,
309         uint256 value,
310         bytes calldata data
311     ) external returns (bytes4);
312 
313     /**
314         @dev Handles the receipt of a multiple ERC1155 token types. This function
315         is called at the end of a `safeBatchTransferFrom` after the balances have
316         been updated. To accept the transfer(s), this must return
317         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
318         (i.e. 0xbc197c81, or its own function selector).
319         @param operator The address which initiated the batch transfer (i.e. msg.sender)
320         @param from The address which previously owned the token
321         @param ids An array containing ids of each token being transferred (order and length must match values array)
322         @param values An array containing amounts of each token being transferred (order and length must match ids array)
323         @param data Additional data with no specified format
324         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
325     */
326     function onERC1155BatchReceived(
327         address operator,
328         address from,
329         uint256[] calldata ids,
330         uint256[] calldata values,
331         bytes calldata data
332     ) external returns (bytes4);
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol
336 
337 
338 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 
343 
344 /**
345  * @dev _Available since v3.1._
346  */
347 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
348     /**
349      * @dev See {IERC165-supportsInterface}.
350      */
351     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
352         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
353     }
354 }
355 
356 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 /**
365  * @dev Required interface of an ERC1155 compliant contract, as defined in the
366  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
367  *
368  * _Available since v3.1._
369  */
370 interface IERC1155 is IERC165 {
371     /**
372      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
373      */
374     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
375 
376     /**
377      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
378      * transfers.
379      */
380     event TransferBatch(
381         address indexed operator,
382         address indexed from,
383         address indexed to,
384         uint256[] ids,
385         uint256[] values
386     );
387 
388     /**
389      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
390      * `approved`.
391      */
392     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
393 
394     /**
395      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
396      *
397      * If an {URI} event was emitted for `id`, the standard
398      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
399      * returned by {IERC1155MetadataURI-uri}.
400      */
401     event URI(string value, uint256 indexed id);
402 
403     /**
404      * @dev Returns the amount of tokens of token type `id` owned by `account`.
405      *
406      * Requirements:
407      *
408      * - `account` cannot be the zero address.
409      */
410     function balanceOf(address account, uint256 id) external view returns (uint256);
411 
412     /**
413      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
414      *
415      * Requirements:
416      *
417      * - `accounts` and `ids` must have the same length.
418      */
419     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
420         external
421         view
422         returns (uint256[] memory);
423 
424     /**
425      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
426      *
427      * Emits an {ApprovalForAll} event.
428      *
429      * Requirements:
430      *
431      * - `operator` cannot be the caller.
432      */
433     function setApprovalForAll(address operator, bool approved) external;
434 
435     /**
436      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
437      *
438      * See {setApprovalForAll}.
439      */
440     function isApprovedForAll(address account, address operator) external view returns (bool);
441 
442     /**
443      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
444      *
445      * Emits a {TransferSingle} event.
446      *
447      * Requirements:
448      *
449      * - `to` cannot be the zero address.
450      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
451      * - `from` must have a balance of tokens of type `id` of at least `amount`.
452      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
453      * acceptance magic value.
454      */
455     function safeTransferFrom(
456         address from,
457         address to,
458         uint256 id,
459         uint256 amount,
460         bytes calldata data
461     ) external;
462 
463     /**
464      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
465      *
466      * Emits a {TransferBatch} event.
467      *
468      * Requirements:
469      *
470      * - `ids` and `amounts` must have the same length.
471      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
472      * acceptance magic value.
473      */
474     function safeBatchTransferFrom(
475         address from,
476         address to,
477         uint256[] calldata ids,
478         uint256[] calldata amounts,
479         bytes calldata data
480     ) external;
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 
491 /**
492  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
493  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
494  *
495  * _Available since v3.1._
496  */
497 interface IERC1155MetadataURI is IERC1155 {
498     /**
499      * @dev Returns the URI for token type `id`.
500      *
501      * If the `\{id\}` substring is present in the URI, it must be replaced by
502      * clients with the actual token type ID.
503      */
504     function uri(uint256 id) external view returns (string memory);
505 }
506 
507 // File: @openzeppelin/contracts/utils/Context.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Provides information about the current execution context, including the
516  * sender of the transaction and its data. While these are generally available
517  * via msg.sender and msg.data, they should not be accessed in such a direct
518  * manner, since when dealing with meta-transactions the account sending and
519  * paying for execution may not be the actual sender (as far as an application
520  * is concerned).
521  *
522  * This contract is only required for intermediate, library-like contracts.
523  */
524 abstract contract Context {
525     function _msgSender() internal view virtual returns (address) {
526         return msg.sender;
527     }
528 
529     function _msgData() internal view virtual returns (bytes calldata) {
530         return msg.data;
531     }
532 }
533 
534 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 
543 
544 
545 
546 
547 /**
548  * @dev Implementation of the basic standard multi-token.
549  * See https://eips.ethereum.org/EIPS/eip-1155
550  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
551  *
552  * _Available since v3.1._
553  */
554 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
555     using Address for address;
556 
557     // Mapping from token ID to account balances
558     mapping(uint256 => mapping(address => uint256)) private _balances;
559 
560     // Mapping from account to operator approvals
561     mapping(address => mapping(address => bool)) private _operatorApprovals;
562 
563     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
564     string private _uri;
565 
566     /**
567      * @dev See {_setURI}.
568      */
569     constructor(string memory uri_) {
570         _setURI(uri_);
571     }
572 
573     /**
574      * @dev See {IERC165-supportsInterface}.
575      */
576     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
577         return
578             interfaceId == type(IERC1155).interfaceId ||
579             interfaceId == type(IERC1155MetadataURI).interfaceId ||
580             super.supportsInterface(interfaceId);
581     }
582 
583     /**
584      * @dev See {IERC1155MetadataURI-uri}.
585      *
586      * This implementation returns the same URI for *all* token types. It relies
587      * on the token type ID substitution mechanism
588      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
589      *
590      * Clients calling this function must replace the `\{id\}` substring with the
591      * actual token type ID.
592      */
593     function uri(uint256) public view virtual override returns (string memory) {
594         return _uri;
595     }
596 
597     /**
598      * @dev See {IERC1155-balanceOf}.
599      *
600      * Requirements:
601      *
602      * - `account` cannot be the zero address.
603      */
604     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
605         require(account != address(0), "ERC1155: balance query for the zero address");
606         return _balances[id][account];
607     }
608 
609     /**
610      * @dev See {IERC1155-balanceOfBatch}.
611      *
612      * Requirements:
613      *
614      * - `accounts` and `ids` must have the same length.
615      */
616     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
617         public
618         view
619         virtual
620         override
621         returns (uint256[] memory)
622     {
623         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
624 
625         uint256[] memory batchBalances = new uint256[](accounts.length);
626 
627         for (uint256 i = 0; i < accounts.length; ++i) {
628             batchBalances[i] = balanceOf(accounts[i], ids[i]);
629         }
630 
631         return batchBalances;
632     }
633 
634     /**
635      * @dev See {IERC1155-setApprovalForAll}.
636      */
637     function setApprovalForAll(address operator, bool approved) public virtual override {
638         _setApprovalForAll(_msgSender(), operator, approved);
639     }
640 
641     /**
642      * @dev See {IERC1155-isApprovedForAll}.
643      */
644     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
645         return _operatorApprovals[account][operator];
646     }
647 
648     /**
649      * @dev See {IERC1155-safeTransferFrom}.
650      */
651     function safeTransferFrom(
652         address from,
653         address to,
654         uint256 id,
655         uint256 amount,
656         bytes memory data
657     ) public virtual override {
658         require(
659             from == _msgSender() || isApprovedForAll(from, _msgSender()),
660             "ERC1155: caller is not owner nor approved"
661         );
662         _safeTransferFrom(from, to, id, amount, data);
663     }
664 
665     /**
666      * @dev See {IERC1155-safeBatchTransferFrom}.
667      */
668     function safeBatchTransferFrom(
669         address from,
670         address to,
671         uint256[] memory ids,
672         uint256[] memory amounts,
673         bytes memory data
674     ) public virtual override {
675         require(
676             from == _msgSender() || isApprovedForAll(from, _msgSender()),
677             "ERC1155: transfer caller is not owner nor approved"
678         );
679         _safeBatchTransferFrom(from, to, ids, amounts, data);
680     }
681 
682     /**
683      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
684      *
685      * Emits a {TransferSingle} event.
686      *
687      * Requirements:
688      *
689      * - `to` cannot be the zero address.
690      * - `from` must have a balance of tokens of type `id` of at least `amount`.
691      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
692      * acceptance magic value.
693      */
694     function _safeTransferFrom(
695         address from,
696         address to,
697         uint256 id,
698         uint256 amount,
699         bytes memory data
700     ) internal virtual {
701         require(to != address(0), "ERC1155: transfer to the zero address");
702 
703         address operator = _msgSender();
704 
705         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
706 
707         uint256 fromBalance = _balances[id][from];
708         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
709         unchecked {
710             _balances[id][from] = fromBalance - amount;
711         }
712         _balances[id][to] += amount;
713 
714         emit TransferSingle(operator, from, to, id, amount);
715 
716         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
717     }
718 
719     /**
720      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
721      *
722      * Emits a {TransferBatch} event.
723      *
724      * Requirements:
725      *
726      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
727      * acceptance magic value.
728      */
729     function _safeBatchTransferFrom(
730         address from,
731         address to,
732         uint256[] memory ids,
733         uint256[] memory amounts,
734         bytes memory data
735     ) internal virtual {
736         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
737         require(to != address(0), "ERC1155: transfer to the zero address");
738 
739         address operator = _msgSender();
740 
741         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
742 
743         for (uint256 i = 0; i < ids.length; ++i) {
744             uint256 id = ids[i];
745             uint256 amount = amounts[i];
746 
747             uint256 fromBalance = _balances[id][from];
748             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
749             unchecked {
750                 _balances[id][from] = fromBalance - amount;
751             }
752             _balances[id][to] += amount;
753         }
754 
755         emit TransferBatch(operator, from, to, ids, amounts);
756 
757         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
758     }
759 
760     /**
761      * @dev Sets a new URI for all token types, by relying on the token type ID
762      * substitution mechanism
763      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
764      *
765      * By this mechanism, any occurrence of the `\{id\}` substring in either the
766      * URI or any of the amounts in the JSON file at said URI will be replaced by
767      * clients with the token type ID.
768      *
769      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
770      * interpreted by clients as
771      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
772      * for token type ID 0x4cce0.
773      *
774      * See {uri}.
775      *
776      * Because these URIs cannot be meaningfully represented by the {URI} event,
777      * this function emits no events.
778      */
779     function _setURI(string memory newuri) internal virtual {
780         _uri = newuri;
781     }
782 
783     /**
784      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
785      *
786      * Emits a {TransferSingle} event.
787      *
788      * Requirements:
789      *
790      * - `to` cannot be the zero address.
791      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
792      * acceptance magic value.
793      */
794     function _mint(
795         address to,
796         uint256 id,
797         uint256 amount,
798         bytes memory data
799     ) internal virtual {
800         require(to != address(0), "ERC1155: mint to the zero address");
801 
802         address operator = _msgSender();
803 
804         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
805 
806         _balances[id][to] += amount;
807         emit TransferSingle(operator, address(0), to, id, amount);
808 
809         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
810     }
811 
812     /**
813      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
814      *
815      * Requirements:
816      *
817      * - `ids` and `amounts` must have the same length.
818      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
819      * acceptance magic value.
820      */
821     function _mintBatch(
822         address to,
823         uint256[] memory ids,
824         uint256[] memory amounts,
825         bytes memory data
826     ) internal virtual {
827         require(to != address(0), "ERC1155: mint to the zero address");
828         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
829 
830         address operator = _msgSender();
831 
832         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
833 
834         for (uint256 i = 0; i < ids.length; i++) {
835             _balances[ids[i]][to] += amounts[i];
836         }
837 
838         emit TransferBatch(operator, address(0), to, ids, amounts);
839 
840         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
841     }
842 
843     /**
844      * @dev Destroys `amount` tokens of token type `id` from `from`
845      *
846      * Requirements:
847      *
848      * - `from` cannot be the zero address.
849      * - `from` must have at least `amount` tokens of token type `id`.
850      */
851     function _burn(
852         address from,
853         uint256 id,
854         uint256 amount
855     ) internal virtual {
856         require(from != address(0), "ERC1155: burn from the zero address");
857 
858         address operator = _msgSender();
859 
860         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
861 
862         uint256 fromBalance = _balances[id][from];
863         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
864         unchecked {
865             _balances[id][from] = fromBalance - amount;
866         }
867 
868         emit TransferSingle(operator, from, address(0), id, amount);
869     }
870 
871     /**
872      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
873      *
874      * Requirements:
875      *
876      * - `ids` and `amounts` must have the same length.
877      */
878     function _burnBatch(
879         address from,
880         uint256[] memory ids,
881         uint256[] memory amounts
882     ) internal virtual {
883         require(from != address(0), "ERC1155: burn from the zero address");
884         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
885 
886         address operator = _msgSender();
887 
888         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
889 
890         for (uint256 i = 0; i < ids.length; i++) {
891             uint256 id = ids[i];
892             uint256 amount = amounts[i];
893 
894             uint256 fromBalance = _balances[id][from];
895             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
896             unchecked {
897                 _balances[id][from] = fromBalance - amount;
898             }
899         }
900 
901         emit TransferBatch(operator, from, address(0), ids, amounts);
902     }
903 
904     /**
905      * @dev Approve `operator` to operate on all of `owner` tokens
906      *
907      * Emits a {ApprovalForAll} event.
908      */
909     function _setApprovalForAll(
910         address owner,
911         address operator,
912         bool approved
913     ) internal virtual {
914         require(owner != operator, "ERC1155: setting approval status for self");
915         _operatorApprovals[owner][operator] = approved;
916         emit ApprovalForAll(owner, operator, approved);
917     }
918 
919     /**
920      * @dev Hook that is called before any token transfer. This includes minting
921      * and burning, as well as batched variants.
922      *
923      * The same hook is called on both single and batched variants. For single
924      * transfers, the length of the `id` and `amount` arrays will be 1.
925      *
926      * Calling conditions (for each `id` and `amount` pair):
927      *
928      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
929      * of token type `id` will be  transferred to `to`.
930      * - When `from` is zero, `amount` tokens of token type `id` will be minted
931      * for `to`.
932      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
933      * will be burned.
934      * - `from` and `to` are never both zero.
935      * - `ids` and `amounts` have the same, non-zero length.
936      *
937      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
938      */
939     function _beforeTokenTransfer(
940         address operator,
941         address from,
942         address to,
943         uint256[] memory ids,
944         uint256[] memory amounts,
945         bytes memory data
946     ) internal virtual {}
947 
948     function _doSafeTransferAcceptanceCheck(
949         address operator,
950         address from,
951         address to,
952         uint256 id,
953         uint256 amount,
954         bytes memory data
955     ) private {
956         if (to.isContract()) {
957             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
958                 if (response != IERC1155Receiver.onERC1155Received.selector) {
959                     revert("ERC1155: ERC1155Receiver rejected tokens");
960                 }
961             } catch Error(string memory reason) {
962                 revert(reason);
963             } catch {
964                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
965             }
966         }
967     }
968 
969     function _doSafeBatchTransferAcceptanceCheck(
970         address operator,
971         address from,
972         address to,
973         uint256[] memory ids,
974         uint256[] memory amounts,
975         bytes memory data
976     ) private {
977         if (to.isContract()) {
978             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
979                 bytes4 response
980             ) {
981                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
982                     revert("ERC1155: ERC1155Receiver rejected tokens");
983                 }
984             } catch Error(string memory reason) {
985                 revert(reason);
986             } catch {
987                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
988             }
989         }
990     }
991 
992     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
993         uint256[] memory array = new uint256[](1);
994         array[0] = element;
995 
996         return array;
997     }
998 }
999 
1000 // File: @openzeppelin/contracts/access/Ownable.sol
1001 
1002 
1003 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 
1008 /**
1009  * @dev Contract module which provides a basic access control mechanism, where
1010  * there is an account (an owner) that can be granted exclusive access to
1011  * specific functions.
1012  *
1013  * By default, the owner account will be the one that deploys the contract. This
1014  * can later be changed with {transferOwnership}.
1015  *
1016  * This module is used through inheritance. It will make available the modifier
1017  * `onlyOwner`, which can be applied to your functions to restrict their use to
1018  * the owner.
1019  */
1020 abstract contract Ownable is Context {
1021     address private _owner;
1022 
1023     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1024 
1025     /**
1026      * @dev Initializes the contract setting the deployer as the initial owner.
1027      */
1028     constructor() {
1029         _transferOwnership(_msgSender());
1030     }
1031 
1032     /**
1033      * @dev Returns the address of the current owner.
1034      */
1035     function owner() public view virtual returns (address) {
1036         return _owner;
1037     }
1038 
1039     /**
1040      * @dev Throws if called by any account other than the owner.
1041      */
1042     modifier onlyOwner() {
1043         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1044         _;
1045     }
1046 
1047     /**
1048      * @dev Leaves the contract without owner. It will not be possible to call
1049      * `onlyOwner` functions anymore. Can only be called by the current owner.
1050      *
1051      * NOTE: Renouncing ownership will leave the contract without an owner,
1052      * thereby removing any functionality that is only available to the owner.
1053      */
1054     function renounceOwnership() public virtual onlyOwner {
1055         _transferOwnership(address(0));
1056     }
1057 
1058     /**
1059      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1060      * Can only be called by the current owner.
1061      */
1062     function transferOwnership(address newOwner) public virtual onlyOwner {
1063         require(newOwner != address(0), "Ownable: new owner is the zero address");
1064         _transferOwnership(newOwner);
1065     }
1066 
1067     /**
1068      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1069      * Internal function without access restriction.
1070      */
1071     function _transferOwnership(address newOwner) internal virtual {
1072         address oldOwner = _owner;
1073         _owner = newOwner;
1074         emit OwnershipTransferred(oldOwner, newOwner);
1075     }
1076 }
1077 
1078 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1079 
1080 
1081 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1082 
1083 pragma solidity ^0.8.0;
1084 
1085 // CAUTION
1086 // This version of SafeMath should only be used with Solidity 0.8 or later,
1087 // because it relies on the compiler's built in overflow checks.
1088 
1089 /**
1090  * @dev Wrappers over Solidity's arithmetic operations.
1091  *
1092  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1093  * now has built in overflow checking.
1094  */
1095 library SafeMath {
1096     /**
1097      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1098      *
1099      * _Available since v3.4._
1100      */
1101     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1102         unchecked {
1103             uint256 c = a + b;
1104             if (c < a) return (false, 0);
1105             return (true, c);
1106         }
1107     }
1108 
1109     /**
1110      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1111      *
1112      * _Available since v3.4._
1113      */
1114     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1115         unchecked {
1116             if (b > a) return (false, 0);
1117             return (true, a - b);
1118         }
1119     }
1120 
1121     /**
1122      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1123      *
1124      * _Available since v3.4._
1125      */
1126     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1127         unchecked {
1128             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1129             // benefit is lost if 'b' is also tested.
1130             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1131             if (a == 0) return (true, 0);
1132             uint256 c = a * b;
1133             if (c / a != b) return (false, 0);
1134             return (true, c);
1135         }
1136     }
1137 
1138     /**
1139      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1140      *
1141      * _Available since v3.4._
1142      */
1143     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1144         unchecked {
1145             if (b == 0) return (false, 0);
1146             return (true, a / b);
1147         }
1148     }
1149 
1150     /**
1151      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1152      *
1153      * _Available since v3.4._
1154      */
1155     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1156         unchecked {
1157             if (b == 0) return (false, 0);
1158             return (true, a % b);
1159         }
1160     }
1161 
1162     /**
1163      * @dev Returns the addition of two unsigned integers, reverting on
1164      * overflow.
1165      *
1166      * Counterpart to Solidity's `+` operator.
1167      *
1168      * Requirements:
1169      *
1170      * - Addition cannot overflow.
1171      */
1172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1173         return a + b;
1174     }
1175 
1176     /**
1177      * @dev Returns the subtraction of two unsigned integers, reverting on
1178      * overflow (when the result is negative).
1179      *
1180      * Counterpart to Solidity's `-` operator.
1181      *
1182      * Requirements:
1183      *
1184      * - Subtraction cannot overflow.
1185      */
1186     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1187         return a - b;
1188     }
1189 
1190     /**
1191      * @dev Returns the multiplication of two unsigned integers, reverting on
1192      * overflow.
1193      *
1194      * Counterpart to Solidity's `*` operator.
1195      *
1196      * Requirements:
1197      *
1198      * - Multiplication cannot overflow.
1199      */
1200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1201         return a * b;
1202     }
1203 
1204     /**
1205      * @dev Returns the integer division of two unsigned integers, reverting on
1206      * division by zero. The result is rounded towards zero.
1207      *
1208      * Counterpart to Solidity's `/` operator.
1209      *
1210      * Requirements:
1211      *
1212      * - The divisor cannot be zero.
1213      */
1214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1215         return a / b;
1216     }
1217 
1218     /**
1219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1220      * reverting when dividing by zero.
1221      *
1222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1223      * opcode (which leaves remaining gas untouched) while Solidity uses an
1224      * invalid opcode to revert (consuming all remaining gas).
1225      *
1226      * Requirements:
1227      *
1228      * - The divisor cannot be zero.
1229      */
1230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1231         return a % b;
1232     }
1233 
1234     /**
1235      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1236      * overflow (when the result is negative).
1237      *
1238      * CAUTION: This function is deprecated because it requires allocating memory for the error
1239      * message unnecessarily. For custom revert reasons use {trySub}.
1240      *
1241      * Counterpart to Solidity's `-` operator.
1242      *
1243      * Requirements:
1244      *
1245      * - Subtraction cannot overflow.
1246      */
1247     function sub(
1248         uint256 a,
1249         uint256 b,
1250         string memory errorMessage
1251     ) internal pure returns (uint256) {
1252         unchecked {
1253             require(b <= a, errorMessage);
1254             return a - b;
1255         }
1256     }
1257 
1258     /**
1259      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1260      * division by zero. The result is rounded towards zero.
1261      *
1262      * Counterpart to Solidity's `/` operator. Note: this function uses a
1263      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1264      * uses an invalid opcode to revert (consuming all remaining gas).
1265      *
1266      * Requirements:
1267      *
1268      * - The divisor cannot be zero.
1269      */
1270     function div(
1271         uint256 a,
1272         uint256 b,
1273         string memory errorMessage
1274     ) internal pure returns (uint256) {
1275         unchecked {
1276             require(b > 0, errorMessage);
1277             return a / b;
1278         }
1279     }
1280 
1281     /**
1282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1283      * reverting with custom message when dividing by zero.
1284      *
1285      * CAUTION: This function is deprecated because it requires allocating memory for the error
1286      * message unnecessarily. For custom revert reasons use {tryMod}.
1287      *
1288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1289      * opcode (which leaves remaining gas untouched) while Solidity uses an
1290      * invalid opcode to revert (consuming all remaining gas).
1291      *
1292      * Requirements:
1293      *
1294      * - The divisor cannot be zero.
1295      */
1296     function mod(
1297         uint256 a,
1298         uint256 b,
1299         string memory errorMessage
1300     ) internal pure returns (uint256) {
1301         unchecked {
1302             require(b > 0, errorMessage);
1303             return a % b;
1304         }
1305     }
1306 }
1307 
1308 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1309 
1310 
1311 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1312 
1313 pragma solidity ^0.8.0;
1314 
1315 /**
1316  * @dev These functions deal with verification of Merkle Trees proofs.
1317  *
1318  * The proofs can be generated using the JavaScript library
1319  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1320  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1321  *
1322  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1323  */
1324 library MerkleProof {
1325     /**
1326      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1327      * defined by `root`. For this, a `proof` must be provided, containing
1328      * sibling hashes on the branch from the leaf to the root of the tree. Each
1329      * pair of leaves and each pair of pre-images are assumed to be sorted.
1330      */
1331     function verify(
1332         bytes32[] memory proof,
1333         bytes32 root,
1334         bytes32 leaf
1335     ) internal pure returns (bool) {
1336         return processProof(proof, leaf) == root;
1337     }
1338 
1339     /**
1340      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1341      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1342      * hash matches the root of the tree. When processing the proof, the pairs
1343      * of leafs & pre-images are assumed to be sorted.
1344      *
1345      * _Available since v4.4._
1346      */
1347     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1348         bytes32 computedHash = leaf;
1349         for (uint256 i = 0; i < proof.length; i++) {
1350             bytes32 proofElement = proof[i];
1351             if (computedHash <= proofElement) {
1352                 // Hash(current computed hash + current element of the proof)
1353                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1354             } else {
1355                 // Hash(current element of the proof + current computed hash)
1356                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1357             }
1358         }
1359         return computedHash;
1360     }
1361 }
1362 
1363 // File: contracts/AD2.sol
1364 
1365 
1366 pragma solidity >= 0.8.9;
1367 
1368 
1369 
1370 
1371 
1372 
1373 contract AirDropperErc1155 is Ownable, ERC1155Receiver {
1374 
1375     uint256 public constant DEFAULT_AIRDROP_EXPIRATION = 90 * 24 * 60 * 60;
1376     uint256 public constant DEFAULT_ADMIN_WITHDRAWAL  = 30 * 24 * 60 * 60;
1377 
1378     struct AirDrop {
1379         ERC1155 token;              
1380         uint256 tokenId;
1381         uint64 expirationTimestamp; 
1382         bytes32 merkleRoot;
1383         uint256 amount;
1384         address creator;
1385         bool paidable;
1386         uint256 piecePrice;
1387         address payout;
1388         mapping(uint256 => uint256) claimedBitMap;
1389     }
1390 
1391     mapping(uint256 => AirDrop) public airDrops;
1392     mapping(uint256 => bool) public isPaused;
1393 
1394 
1395     function addErc1155Airdrop(
1396         uint256 airdropId,
1397         ERC1155 token,
1398         uint256 tokenId,
1399         uint256 amount,
1400         bytes32 merkleRoot,
1401         uint256 expirationSeconds,
1402         bool paidable,
1403         uint256 piecePrice,
1404         address payout
1405     )
1406     external
1407     {
1408         require(!isPaused[0], "Paused");
1409 
1410         AirDrop storage airDrop = airDrops[airdropId];
1411         require(address(airDrop.token) == address(0), "Airdrop already exists");
1412       
1413 
1414         token.safeTransferFrom(msg.sender, address(this), tokenId, amount, "");
1415         airDrop.token = token;
1416         airDrop.tokenId = tokenId;
1417         airDrop.creator = msg.sender;
1418         airDrop.merkleRoot = merkleRoot;
1419         airDrop.amount = amount;
1420         airDrop.paidable = paidable;
1421         airDrop.piecePrice = piecePrice;
1422         airDrop.payout = payout;
1423 
1424         if (expirationSeconds > 0) {
1425             airDrop.expirationTimestamp = uint64(block.timestamp + expirationSeconds);
1426         } else {
1427             airDrop.expirationTimestamp = uint64(block.timestamp + DEFAULT_AIRDROP_EXPIRATION);
1428         }
1429         emit AddedAirdrop(airdropId, token, tokenId, amount, paidable);
1430     }
1431 
1432     function isClaimed(uint256 airdropId, uint256 index) public view returns (bool) {
1433         // to save the gas, whether user claim the token is stored in bitmap
1434         uint256 claimedWordIndex = index / 256;
1435         uint256 claimedBitIndex = index % 256;
1436         AirDrop storage airDrop = airDrops[airdropId];
1437         uint256 claimedWord = airDrop.claimedBitMap[claimedWordIndex];
1438         uint256 mask = (1 << claimedBitIndex);
1439         return claimedWord & mask == mask;
1440     }
1441 
1442     function _setClaimed(uint256 airdropId, uint256 index) private {
1443         uint256 claimedWordIndex = index / 256;
1444         uint256 claimedBitIndex = index % 256;
1445         AirDrop storage airDrop = airDrops[airdropId];
1446         airDrop.claimedBitMap[claimedWordIndex] = airDrop.claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
1447     }
1448 
1449     function claim(
1450         uint256 airdropId,
1451         uint256 index,
1452         address payable account,
1453         uint256 amount,
1454         bytes32[] calldata merkleProof
1455     )
1456     external
1457     {
1458         require(!isPaused[1], "Paused");
1459         AirDrop storage airDrop = airDrops[airdropId];
1460 
1461         require(airDrop.paidable != true, "This piece is not claimable");
1462         require(address(airDrop.token) != address(0), "Airdrop with given ID doesn't exists");
1463         require(!isClaimed(airdropId, index), "Account already claimed");
1464         require(block.timestamp <= airDrop.expirationTimestamp, "Airdrop expired");
1465 
1466         // Verify the merkle proof.
1467         bytes32 node = keccak256(abi.encodePacked(msg.sender));
1468         require(MerkleProof.verify(merkleProof, airDrop.merkleRoot, node), "Invalid Merkle-proof");
1469 
1470         airDrop.amount = airDrop.amount - amount;
1471         // Mark it claimed and send the token.
1472         _setClaimed(airdropId, index);
1473         airDrop.token.safeTransferFrom(address(this), account, airDrop.tokenId, amount, "");
1474 
1475         emit Claimed(airdropId, index, account, amount);
1476     }
1477 
1478     function claimPay (
1479         uint256 airdropId,
1480         uint256 index,
1481         address account,
1482         uint256 amount,
1483         bytes32[] calldata merkleProof
1484     )
1485     external payable
1486     {
1487         require(!isPaused[1], "Paused");
1488 
1489         AirDrop storage airDrop = airDrops[airdropId];
1490 
1491         require(msg.value >= airDrop.piecePrice * amount, "Ether value sent is below the price");
1492 
1493         require(address(airDrop.token) != address(0), "Airdrop with given ID doesn't exists");
1494         require(!isClaimed(airdropId, index), "Account already claimed");
1495         require(block.timestamp <= airDrop.expirationTimestamp, "Airdrop expired");
1496 
1497         // Verify the merkle proof.
1498         bytes32 node = keccak256(abi.encodePacked(msg.sender));
1499         require(MerkleProof.verify(merkleProof, airDrop.merkleRoot, node), "Invalid Merkle-proof");
1500 
1501         airDrop.amount = airDrop.amount - amount;
1502         // Mark it claimed and send the token.
1503         _setClaimed(airdropId, index);
1504         payable(airDrop.payout).transfer(airDrop.piecePrice);
1505         airDrop.token.safeTransferFrom(address(this), account, airDrop.tokenId, 1, "");
1506 
1507         emit Claimed(airdropId, index, account, amount);
1508     }
1509 
1510    function adminWithdrawTokensFromExpiredAirdrop(uint256 airdropId) external onlyOwner {
1511         AirDrop storage airDrop = airDrops[airdropId];
1512         require(address(airDrop.token) != address(0), "Airdrop with given Id doesn't exists");
1513         require(airDrop.expirationTimestamp + DEFAULT_ADMIN_WITHDRAWAL < block.timestamp,
1514             "need to wait creator withdrawal expiration");
1515         require(airDrop.amount > 0, "Airdrop balance is empty");
1516         uint256 amount = airDrop.amount;
1517         airDrop.amount = 0;
1518         airDrop.token.safeTransferFrom(address(this), msg.sender, airDrop.tokenId, amount, "");
1519     }
1520 
1521     receive() external payable {
1522         emit Received(msg.sender, msg.value);
1523     }
1524   
1525 
1526     function withdrawFee() external onlyOwner  {
1527         payable(msg.sender).transfer(address(this).balance);
1528     }
1529 
1530     function setPause(uint256 i, bool _isPaused) onlyOwner external {
1531         isPaused[i] = _isPaused;
1532     }
1533 
1534     event AddedAirdrop(uint256 airdropId, ERC1155 token, uint256 tokenId, uint256 amount, bool paidable);
1535     event Claimed(uint256 airdropId, uint256 index, address account, uint256 amount);
1536     event Received(address, uint);
1537 
1538     /**
1539     * @dev See {IERC165-supportsInterface}.
1540     */
1541     function onERC1155Received(
1542         address operator,
1543         address from,
1544         uint256 id,
1545         uint256 value,
1546         bytes calldata data
1547     )
1548     external
1549     override
1550     returns (bytes4)
1551     {
1552         return this.onERC1155Received.selector;
1553     }
1554 
1555     function onERC1155BatchReceived(
1556         address operator,
1557         address from,
1558         uint256[] calldata ids,
1559         uint256[] calldata values,
1560         bytes calldata data
1561     )
1562     external
1563     override
1564     returns (bytes4)
1565     {
1566         return this.onERC1155BatchReceived.selector;
1567     }
1568 
1569 }