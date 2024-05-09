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
335 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
336 
337 
338 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 
343 /**
344  * @dev Required interface of an ERC1155 compliant contract, as defined in the
345  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
346  *
347  * _Available since v3.1._
348  */
349 interface IERC1155 is IERC165 {
350     /**
351      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
352      */
353     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
354 
355     /**
356      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
357      * transfers.
358      */
359     event TransferBatch(
360         address indexed operator,
361         address indexed from,
362         address indexed to,
363         uint256[] ids,
364         uint256[] values
365     );
366 
367     /**
368      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
369      * `approved`.
370      */
371     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
372 
373     /**
374      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
375      *
376      * If an {URI} event was emitted for `id`, the standard
377      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
378      * returned by {IERC1155MetadataURI-uri}.
379      */
380     event URI(string value, uint256 indexed id);
381 
382     /**
383      * @dev Returns the amount of tokens of token type `id` owned by `account`.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      */
389     function balanceOf(address account, uint256 id) external view returns (uint256);
390 
391     /**
392      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
393      *
394      * Requirements:
395      *
396      * - `accounts` and `ids` must have the same length.
397      */
398     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
399         external
400         view
401         returns (uint256[] memory);
402 
403     /**
404      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
405      *
406      * Emits an {ApprovalForAll} event.
407      *
408      * Requirements:
409      *
410      * - `operator` cannot be the caller.
411      */
412     function setApprovalForAll(address operator, bool approved) external;
413 
414     /**
415      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
416      *
417      * See {setApprovalForAll}.
418      */
419     function isApprovedForAll(address account, address operator) external view returns (bool);
420 
421     /**
422      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
423      *
424      * Emits a {TransferSingle} event.
425      *
426      * Requirements:
427      *
428      * - `to` cannot be the zero address.
429      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
430      * - `from` must have a balance of tokens of type `id` of at least `amount`.
431      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
432      * acceptance magic value.
433      */
434     function safeTransferFrom(
435         address from,
436         address to,
437         uint256 id,
438         uint256 amount,
439         bytes calldata data
440     ) external;
441 
442     /**
443      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
444      *
445      * Emits a {TransferBatch} event.
446      *
447      * Requirements:
448      *
449      * - `ids` and `amounts` must have the same length.
450      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
451      * acceptance magic value.
452      */
453     function safeBatchTransferFrom(
454         address from,
455         address to,
456         uint256[] calldata ids,
457         uint256[] calldata amounts,
458         bytes calldata data
459     ) external;
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
472  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
473  *
474  * _Available since v3.1._
475  */
476 interface IERC1155MetadataURI is IERC1155 {
477     /**
478      * @dev Returns the URI for token type `id`.
479      *
480      * If the `\{id\}` substring is present in the URI, it must be replaced by
481      * clients with the actual token type ID.
482      */
483     function uri(uint256 id) external view returns (string memory);
484 }
485 
486 // File: @openzeppelin/contracts/utils/Context.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Provides information about the current execution context, including the
495  * sender of the transaction and its data. While these are generally available
496  * via msg.sender and msg.data, they should not be accessed in such a direct
497  * manner, since when dealing with meta-transactions the account sending and
498  * paying for execution may not be the actual sender (as far as an application
499  * is concerned).
500  *
501  * This contract is only required for intermediate, library-like contracts.
502  */
503 abstract contract Context {
504     function _msgSender() internal view virtual returns (address) {
505         return msg.sender;
506     }
507 
508     function _msgData() internal view virtual returns (bytes calldata) {
509         return msg.data;
510     }
511 }
512 
513 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 
521 
522 
523 
524 
525 
526 /**
527  * @dev Implementation of the basic standard multi-token.
528  * See https://eips.ethereum.org/EIPS/eip-1155
529  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
530  *
531  * _Available since v3.1._
532  */
533 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
534     using Address for address;
535 
536     // Mapping from token ID to account balances
537     mapping(uint256 => mapping(address => uint256)) private _balances;
538 
539     // Mapping from account to operator approvals
540     mapping(address => mapping(address => bool)) private _operatorApprovals;
541 
542     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
543     string private _uri;
544 
545     /**
546      * @dev See {_setURI}.
547      */
548     constructor(string memory uri_) {
549         _setURI(uri_);
550     }
551 
552     /**
553      * @dev See {IERC165-supportsInterface}.
554      */
555     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
556         return
557             interfaceId == type(IERC1155).interfaceId ||
558             interfaceId == type(IERC1155MetadataURI).interfaceId ||
559             super.supportsInterface(interfaceId);
560     }
561 
562     /**
563      * @dev See {IERC1155MetadataURI-uri}.
564      *
565      * This implementation returns the same URI for *all* token types. It relies
566      * on the token type ID substitution mechanism
567      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
568      *
569      * Clients calling this function must replace the `\{id\}` substring with the
570      * actual token type ID.
571      */
572     function uri(uint256) public view virtual override returns (string memory) {
573         return _uri;
574     }
575 
576     /**
577      * @dev See {IERC1155-balanceOf}.
578      *
579      * Requirements:
580      *
581      * - `account` cannot be the zero address.
582      */
583     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
584         require(account != address(0), "ERC1155: balance query for the zero address");
585         return _balances[id][account];
586     }
587 
588     /**
589      * @dev See {IERC1155-balanceOfBatch}.
590      *
591      * Requirements:
592      *
593      * - `accounts` and `ids` must have the same length.
594      */
595     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
596         public
597         view
598         virtual
599         override
600         returns (uint256[] memory)
601     {
602         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
603 
604         uint256[] memory batchBalances = new uint256[](accounts.length);
605 
606         for (uint256 i = 0; i < accounts.length; ++i) {
607             batchBalances[i] = balanceOf(accounts[i], ids[i]);
608         }
609 
610         return batchBalances;
611     }
612 
613     /**
614      * @dev See {IERC1155-setApprovalForAll}.
615      */
616     function setApprovalForAll(address operator, bool approved) public virtual override {
617         _setApprovalForAll(_msgSender(), operator, approved);
618     }
619 
620     /**
621      * @dev See {IERC1155-isApprovedForAll}.
622      */
623     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
624         return _operatorApprovals[account][operator];
625     }
626 
627     /**
628      * @dev See {IERC1155-safeTransferFrom}.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 id,
634         uint256 amount,
635         bytes memory data
636     ) public virtual override {
637         require(
638             from == _msgSender() || isApprovedForAll(from, _msgSender()),
639             "ERC1155: caller is not owner nor approved"
640         );
641         _safeTransferFrom(from, to, id, amount, data);
642     }
643 
644     /**
645      * @dev See {IERC1155-safeBatchTransferFrom}.
646      */
647     function safeBatchTransferFrom(
648         address from,
649         address to,
650         uint256[] memory ids,
651         uint256[] memory amounts,
652         bytes memory data
653     ) public virtual override {
654         require(
655             from == _msgSender() || isApprovedForAll(from, _msgSender()),
656             "ERC1155: transfer caller is not owner nor approved"
657         );
658         _safeBatchTransferFrom(from, to, ids, amounts, data);
659     }
660 
661     /**
662      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
663      *
664      * Emits a {TransferSingle} event.
665      *
666      * Requirements:
667      *
668      * - `to` cannot be the zero address.
669      * - `from` must have a balance of tokens of type `id` of at least `amount`.
670      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
671      * acceptance magic value.
672      */
673     function _safeTransferFrom(
674         address from,
675         address to,
676         uint256 id,
677         uint256 amount,
678         bytes memory data
679     ) internal virtual {
680         require(to != address(0), "ERC1155: transfer to the zero address");
681 
682         address operator = _msgSender();
683 
684         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
685 
686         uint256 fromBalance = _balances[id][from];
687         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
688         unchecked {
689             _balances[id][from] = fromBalance - amount;
690         }
691         _balances[id][to] += amount;
692 
693         emit TransferSingle(operator, from, to, id, amount);
694 
695         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
696     }
697 
698     /**
699      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
700      *
701      * Emits a {TransferBatch} event.
702      *
703      * Requirements:
704      *
705      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
706      * acceptance magic value.
707      */
708     function _safeBatchTransferFrom(
709         address from,
710         address to,
711         uint256[] memory ids,
712         uint256[] memory amounts,
713         bytes memory data
714     ) internal virtual {
715         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
716         require(to != address(0), "ERC1155: transfer to the zero address");
717 
718         address operator = _msgSender();
719 
720         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
721 
722         for (uint256 i = 0; i < ids.length; ++i) {
723             uint256 id = ids[i];
724             uint256 amount = amounts[i];
725 
726             uint256 fromBalance = _balances[id][from];
727             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
728             unchecked {
729                 _balances[id][from] = fromBalance - amount;
730             }
731             _balances[id][to] += amount;
732         }
733 
734         emit TransferBatch(operator, from, to, ids, amounts);
735 
736         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
737     }
738 
739     /**
740      * @dev Sets a new URI for all token types, by relying on the token type ID
741      * substitution mechanism
742      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
743      *
744      * By this mechanism, any occurrence of the `\{id\}` substring in either the
745      * URI or any of the amounts in the JSON file at said URI will be replaced by
746      * clients with the token type ID.
747      *
748      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
749      * interpreted by clients as
750      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
751      * for token type ID 0x4cce0.
752      *
753      * See {uri}.
754      *
755      * Because these URIs cannot be meaningfully represented by the {URI} event,
756      * this function emits no events.
757      */
758     function _setURI(string memory newuri) internal virtual {
759         _uri = newuri;
760     }
761 
762     /**
763      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
764      *
765      * Emits a {TransferSingle} event.
766      *
767      * Requirements:
768      *
769      * - `to` cannot be the zero address.
770      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
771      * acceptance magic value.
772      */
773     function _mint(
774         address to,
775         uint256 id,
776         uint256 amount,
777         bytes memory data
778     ) internal virtual {
779         require(to != address(0), "ERC1155: mint to the zero address");
780 
781         address operator = _msgSender();
782 
783         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
784 
785         _balances[id][to] += amount;
786         emit TransferSingle(operator, address(0), to, id, amount);
787 
788         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
789     }
790 
791     /**
792      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
793      *
794      * Requirements:
795      *
796      * - `ids` and `amounts` must have the same length.
797      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
798      * acceptance magic value.
799      */
800     function _mintBatch(
801         address to,
802         uint256[] memory ids,
803         uint256[] memory amounts,
804         bytes memory data
805     ) internal virtual {
806         require(to != address(0), "ERC1155: mint to the zero address");
807         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
808 
809         address operator = _msgSender();
810 
811         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
812 
813         for (uint256 i = 0; i < ids.length; i++) {
814             _balances[ids[i]][to] += amounts[i];
815         }
816 
817         emit TransferBatch(operator, address(0), to, ids, amounts);
818 
819         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
820     }
821 
822     /**
823      * @dev Destroys `amount` tokens of token type `id` from `from`
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `from` must have at least `amount` tokens of token type `id`.
829      */
830     function _burn(
831         address from,
832         uint256 id,
833         uint256 amount
834     ) internal virtual {
835         require(from != address(0), "ERC1155: burn from the zero address");
836 
837         address operator = _msgSender();
838 
839         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
840 
841         uint256 fromBalance = _balances[id][from];
842         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
843         unchecked {
844             _balances[id][from] = fromBalance - amount;
845         }
846 
847         emit TransferSingle(operator, from, address(0), id, amount);
848     }
849 
850     /**
851      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
852      *
853      * Requirements:
854      *
855      * - `ids` and `amounts` must have the same length.
856      */
857     function _burnBatch(
858         address from,
859         uint256[] memory ids,
860         uint256[] memory amounts
861     ) internal virtual {
862         require(from != address(0), "ERC1155: burn from the zero address");
863         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
864 
865         address operator = _msgSender();
866 
867         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
868 
869         for (uint256 i = 0; i < ids.length; i++) {
870             uint256 id = ids[i];
871             uint256 amount = amounts[i];
872 
873             uint256 fromBalance = _balances[id][from];
874             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
875             unchecked {
876                 _balances[id][from] = fromBalance - amount;
877             }
878         }
879 
880         emit TransferBatch(operator, from, address(0), ids, amounts);
881     }
882 
883     /**
884      * @dev Approve `operator` to operate on all of `owner` tokens
885      *
886      * Emits a {ApprovalForAll} event.
887      */
888     function _setApprovalForAll(
889         address owner,
890         address operator,
891         bool approved
892     ) internal virtual {
893         require(owner != operator, "ERC1155: setting approval status for self");
894         _operatorApprovals[owner][operator] = approved;
895         emit ApprovalForAll(owner, operator, approved);
896     }
897 
898     /**
899      * @dev Hook that is called before any token transfer. This includes minting
900      * and burning, as well as batched variants.
901      *
902      * The same hook is called on both single and batched variants. For single
903      * transfers, the length of the `id` and `amount` arrays will be 1.
904      *
905      * Calling conditions (for each `id` and `amount` pair):
906      *
907      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
908      * of token type `id` will be  transferred to `to`.
909      * - When `from` is zero, `amount` tokens of token type `id` will be minted
910      * for `to`.
911      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
912      * will be burned.
913      * - `from` and `to` are never both zero.
914      * - `ids` and `amounts` have the same, non-zero length.
915      *
916      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
917      */
918     function _beforeTokenTransfer(
919         address operator,
920         address from,
921         address to,
922         uint256[] memory ids,
923         uint256[] memory amounts,
924         bytes memory data
925     ) internal virtual {}
926 
927     function _doSafeTransferAcceptanceCheck(
928         address operator,
929         address from,
930         address to,
931         uint256 id,
932         uint256 amount,
933         bytes memory data
934     ) private {
935         if (to.isContract()) {
936             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
937                 if (response != IERC1155Receiver.onERC1155Received.selector) {
938                     revert("ERC1155: ERC1155Receiver rejected tokens");
939                 }
940             } catch Error(string memory reason) {
941                 revert(reason);
942             } catch {
943                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
944             }
945         }
946     }
947 
948     function _doSafeBatchTransferAcceptanceCheck(
949         address operator,
950         address from,
951         address to,
952         uint256[] memory ids,
953         uint256[] memory amounts,
954         bytes memory data
955     ) private {
956         if (to.isContract()) {
957             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
958                 bytes4 response
959             ) {
960                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
961                     revert("ERC1155: ERC1155Receiver rejected tokens");
962                 }
963             } catch Error(string memory reason) {
964                 revert(reason);
965             } catch {
966                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
967             }
968         }
969     }
970 
971     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
972         uint256[] memory array = new uint256[](1);
973         array[0] = element;
974 
975         return array;
976     }
977 }
978 
979 // File: @openzeppelin/contracts/access/Ownable.sol
980 
981 
982 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
983 
984 pragma solidity ^0.8.0;
985 
986 
987 /**
988  * @dev Contract module which provides a basic access control mechanism, where
989  * there is an account (an owner) that can be granted exclusive access to
990  * specific functions.
991  *
992  * By default, the owner account will be the one that deploys the contract. This
993  * can later be changed with {transferOwnership}.
994  *
995  * This module is used through inheritance. It will make available the modifier
996  * `onlyOwner`, which can be applied to your functions to restrict their use to
997  * the owner.
998  */
999 abstract contract Ownable is Context {
1000     address private _owner;
1001 
1002     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1003 
1004     /**
1005      * @dev Initializes the contract setting the deployer as the initial owner.
1006      */
1007     constructor() {
1008         _transferOwnership(_msgSender());
1009     }
1010 
1011     /**
1012      * @dev Returns the address of the current owner.
1013      */
1014     function owner() public view virtual returns (address) {
1015         return _owner;
1016     }
1017 
1018     /**
1019      * @dev Throws if called by any account other than the owner.
1020      */
1021     modifier onlyOwner() {
1022         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1023         _;
1024     }
1025 
1026     /**
1027      * @dev Leaves the contract without owner. It will not be possible to call
1028      * `onlyOwner` functions anymore. Can only be called by the current owner.
1029      *
1030      * NOTE: Renouncing ownership will leave the contract without an owner,
1031      * thereby removing any functionality that is only available to the owner.
1032      */
1033     function renounceOwnership() public virtual onlyOwner {
1034         _transferOwnership(address(0));
1035     }
1036 
1037     /**
1038      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1039      * Can only be called by the current owner.
1040      */
1041     function transferOwnership(address newOwner) public virtual onlyOwner {
1042         require(newOwner != address(0), "Ownable: new owner is the zero address");
1043         _transferOwnership(newOwner);
1044     }
1045 
1046     /**
1047      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1048      * Internal function without access restriction.
1049      */
1050     function _transferOwnership(address newOwner) internal virtual {
1051         address oldOwner = _owner;
1052         _owner = newOwner;
1053         emit OwnershipTransferred(oldOwner, newOwner);
1054     }
1055 }
1056 
1057 // File: DinoDoodles.sol
1058 
1059 
1060 pragma solidity ^0.8.0;
1061 
1062 
1063 
1064 /**
1065  * @dev contract module which defines DinoDoodles NFT Collection
1066  * and all the interactions it uses
1067  */
1068 contract DinoDoodles is ERC1155, Ownable {
1069     //@dev Attributes for NFT configuration
1070     uint256 internal tokenId;
1071     uint256 public cost = 0.1 ether;
1072     uint256 public maxSupply = 888;
1073     uint256 public totalSupply = 0;
1074     uint256 public maxMintAmount = 10;
1075     uint256 private _currentTokenID = 0;
1076     mapping(address => uint256) public freeMint;
1077     bool public paused;
1078 
1079     // @dev inner attributes of the contract
1080 
1081     /**
1082      * @dev Create an instance of DinoDoodles contract
1083      */
1084     constructor(
1085         string memory _baseURI
1086     ) ERC1155(_baseURI) {
1087         tokenId = 0;
1088     }
1089     /**
1090      * @dev Mint edition to a wallet
1091      * @param _to wallet receiving the edition(s).
1092      * @param _mintAmount number of editions to mint.
1093      */
1094     function mint(address _to, uint256 _mintAmount) public payable {
1095         require(!paused, "Minting is Paused.");
1096         require(_mintAmount <= maxMintAmount, "Only 10 DinoDoodles are Allowed Per Transaction");
1097         require(
1098             tokenId + _mintAmount <= maxSupply,
1099             "Dinoverse is at Max Capacity"
1100         );
1101         
1102         if(freeMint[_to] < _mintAmount)
1103             require(
1104                 msg.value >= cost * _mintAmount,
1105                 "Uh Oh Not Enough ETH Paid"
1106             );
1107         else
1108             freeMint[_to] -= _mintAmount;
1109         
1110         for (uint256 i = 0; i < _mintAmount; i++) {
1111             tokenId++;
1112             _mint(_to, tokenId, 1, "");
1113             totalSupply++;
1114         }
1115     }
1116     
1117     function withdraw() public payable onlyOwner{
1118         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1119         require(os);
1120     }
1121 
1122     /**
1123      * @dev change cost of NFT
1124      * @param _newCost new cost of each edition
1125      */
1126     function setCost(uint256 _newCost) public onlyOwner {
1127         cost = _newCost;
1128     }
1129 
1130     /**
1131      * @dev restrict max mintable amount of edition at a time
1132      * @param _newmaxMintAmount new max mintable amount
1133      */
1134     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1135         maxMintAmount = _newmaxMintAmount;
1136     }
1137 
1138     /**
1139      * @dev restrict max mintable amount of edition at a time
1140      * @param _nexMaxSupply new max supply
1141      */
1142     function setmaxSupply(uint256 _nexMaxSupply) public onlyOwner {
1143         maxSupply = _nexMaxSupply;
1144     }
1145     
1146     /**
1147      * @dev set uri
1148      * @param _newURI new URI
1149      */
1150     function setURI(string memory _newURI) public onlyOwner {
1151         _setURI(_newURI);
1152     }
1153 
1154     /**
1155      * @dev Disable minting process
1156      */
1157     function pause() public onlyOwner {
1158         paused = !paused;
1159     }
1160 
1161     /**
1162      * @dev Add user to white list
1163      * @param _user Users wallet to whitelist
1164      */
1165     function freeMintUserBatch(
1166         address[] memory _user,
1167         uint256[] memory _amount
1168     ) public onlyOwner {
1169         require(_user.length == _amount.length);
1170         for (uint256 i = 0; i < _user.length; i++)
1171             freeMint[_user[i]] = _amount[i];
1172     }
1173 }