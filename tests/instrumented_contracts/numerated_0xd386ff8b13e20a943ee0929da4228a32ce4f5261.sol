1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // File contracts/Functional.sol
4 
5 pragma solidity ^0.8.0;
6 
7 
8 abstract contract Functional {
9     function toString(uint256 value) internal pure returns (string memory) {
10         if (value == 0) {
11             return "0";
12         }
13         uint256 temp = value;
14         uint256 digits;
15         while (temp != 0) {
16             digits++;
17             temp /= 10;
18         }
19         bytes memory buffer = new bytes(digits);
20         while (value != 0) {
21             digits -= 1;
22             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
23             value /= 10;
24         }
25         return string(buffer);
26     }
27     
28     bool private _reentryKey = false;
29     modifier reentryLock {
30         require(!_reentryKey, "attempt to reenter a locked function");
31         _reentryKey = true;
32         _;
33         _reentryKey = false;
34     }
35 }
36 
37 
38 // File contracts/interfaces/IERC165.sol
39 
40 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
41 
42 pragma solidity ^0.8.0;
43 
44 /**
45  * @dev Interface of the ERC165 standard, as defined in the
46  * https://eips.ethereum.org/EIPS/eip-165[EIP].
47  *
48  * Implementers can declare support of contract interfaces, which can then be
49  * queried by others ({ERC165Checker}).
50  *
51  * For an implementation, see {ERC165}.
52  */
53 interface IERC165 {
54     /**
55      * @dev Returns true if this contract implements the interface defined by
56      * `interfaceId`. See the corresponding
57      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
58      * to learn more about how these ids are created.
59      *
60      * This function call must use less than 30 000 gas.
61      */
62     function supportsInterface(bytes4 interfaceId) external view returns (bool);
63 }
64 
65 
66 // File contracts/interfaces/IERC1155.sol
67 
68 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/IERC1155.sol)
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
128         external
129         view
130         returns (uint256[] memory);
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
191 
192 // File contracts/interfaces/IERC1155Receiver.sol
193 
194 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/IERC1155Receiver.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev _Available since v3.1._
200  */
201 interface IERC1155Receiver is IERC165 {
202     /**
203         @dev Handles the receipt of a single ERC1155 token type. This function is
204         called at the end of a `safeTransferFrom` after the balance has been updated.
205         To accept the transfer, this must return
206         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
207         (i.e. 0xf23a6e61, or its own function selector).
208         @param operator The address which initiated the transfer (i.e. msg.sender)
209         @param from The address which previously owned the token
210         @param id The ID of the token being transferred
211         @param value The amount of tokens being transferred
212         @param data Additional data with no specified format
213         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
214     */
215     function onERC1155Received(
216         address operator,
217         address from,
218         uint256 id,
219         uint256 value,
220         bytes calldata data
221     ) external returns (bytes4);
222 
223     /**
224         @dev Handles the receipt of a multiple ERC1155 token types. This function
225         is called at the end of a `safeBatchTransferFrom` after the balances have
226         been updated. To accept the transfer(s), this must return
227         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
228         (i.e. 0xbc197c81, or its own function selector).
229         @param operator The address which initiated the batch transfer (i.e. msg.sender)
230         @param from The address which previously owned the token
231         @param ids An array containing ids of each token being transferred (order and length must match values array)
232         @param values An array containing amounts of each token being transferred (order and length must match ids array)
233         @param data Additional data with no specified format
234         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
235     */
236     function onERC1155BatchReceived(
237         address operator,
238         address from,
239         uint256[] calldata ids,
240         uint256[] calldata values,
241         bytes calldata data
242     ) external returns (bytes4);
243 }
244 
245 
246 // File contracts/interfaces/IERC1155MetadataURI.sol
247 
248 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
254  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
255  *
256  * _Available since v3.1._
257  */
258 interface IERC1155MetadataURI is IERC1155 {
259     /**
260      * @dev Returns the URI for token type `id`.
261      *
262      * If the `\{id\}` substring is present in the URI, it must be replaced by
263      * clients with the actual token type ID.
264      */
265     function uri(uint256 id) external view returns (string memory);
266 }
267 
268 
269 // File contracts/utils/Address.sol
270 
271 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize, which returns 0 for contracts in
298         // construction, since the code is only stored at the end of the
299         // constructor execution.
300 
301         uint256 size;
302         assembly {
303             size := extcodesize(account)
304         }
305         return size > 0;
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         (bool success, ) = recipient.call{value: amount}("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain `call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value
382     ) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(
393         address target,
394         bytes memory data,
395         uint256 value,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(address(this).balance >= value, "Address: insufficient balance for call");
399         require(isContract(target), "Address: call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.call{value: value}(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a static call.
408      *
409      * _Available since v3.3._
410      */
411     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
412         return functionStaticCall(target, data, "Address: low-level static call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal view returns (bytes memory) {
426         require(isContract(target), "Address: static call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.staticcall(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a delegate call.
435      *
436      * _Available since v3.4._
437      */
438     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
439         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal returns (bytes memory) {
453         require(isContract(target), "Address: delegate call to non-contract");
454 
455         (bool success, bytes memory returndata) = target.delegatecall(data);
456         return verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
461      * revert reason using the provided one.
462      *
463      * _Available since v4.3._
464      */
465     function verifyCallResult(
466         bool success,
467         bytes memory returndata,
468         string memory errorMessage
469     ) internal pure returns (bytes memory) {
470         if (success) {
471             return returndata;
472         } else {
473             // Look for revert reason and bubble it up if present
474             if (returndata.length > 0) {
475                 // The easiest way to bubble the revert reason is using memory via assembly
476 
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 
489 // File contracts/utils/Context.sol
490 
491 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Provides information about the current execution context, including the
497  * sender of the transaction and its data. While these are generally available
498  * via msg.sender and msg.data, they should not be accessed in such a direct
499  * manner, since when dealing with meta-transactions the account sending and
500  * paying for execution may not be the actual sender (as far as an application
501  * is concerned).
502  *
503  * This contract is only required for intermediate, library-like contracts.
504  */
505 abstract contract Context {
506     function _msgSender() internal view virtual returns (address) {
507         return msg.sender;
508     }
509 
510     function _msgData() internal view virtual returns (bytes calldata) {
511         return msg.data;
512     }
513 }
514 
515 
516 // File contracts/utils/ERC165.sol
517 
518 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Implementation of the {IERC165} interface.
524  *
525  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
526  * for the additional interface id that will be supported. For example:
527  *
528  * ```solidity
529  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
531  * }
532  * ```
533  *
534  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
535  */
536 abstract contract ERC165 is IERC165 {
537     /**
538      * @dev See {IERC165-supportsInterface}.
539      */
540     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541         return interfaceId == type(IERC165).interfaceId;
542     }
543 }
544 
545 
546 // File contracts/ERC1155.sol
547 
548 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/ERC1155.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 
553 
554 
555 
556 
557 /**
558  * @dev Implementation of the basic standard multi-token.
559  * See https://eips.ethereum.org/EIPS/eip-1155
560  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
561  *
562  * _Available since v3.1._
563  */
564 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
565     using Address for address;
566 
567     // Mapping from token ID to account balances
568     mapping(address => uint32[7]) private _balances;
569     uint[] private tokens;
570 
571     // Mapping from account to operator approvals
572     mapping(address => mapping(address => bool)) private _operatorApprovals;
573 
574     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
575     string private _uri;
576 
577     /**
578      * @dev See {_setURI}.
579      */
580     constructor(string memory uri_) {
581         _setURI(uri_);
582         tokens = new uint[](7);
583         for(uint i = 0; i < 7; i++) {
584             tokens[i] = i;
585         }
586     }
587 
588     /**
589      * @dev See {IERC165-supportsInterface}.
590      */
591     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
592         return
593             interfaceId == type(IERC1155).interfaceId ||
594             interfaceId == type(IERC1155MetadataURI).interfaceId ||
595             super.supportsInterface(interfaceId);
596     }
597 
598     /**
599      * @dev See {IERC1155MetadataURI-uri}.
600      *
601      * This implementation returns the same URI for *all* token types. It relies
602      * on the token type ID substitution mechanism
603      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
604      *
605      * Clients calling this function must replace the `\{id\}` substring with the
606      * actual token type ID.
607      */
608     function uri(uint256) public view virtual override returns (string memory) {
609         return _uri;
610     }
611 
612     /**
613      * @dev See {IERC1155-balanceOf}.
614      *
615      * Requirements:
616      *
617      * - `account` cannot be the zero address.
618      */
619     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
620         require(account != address(0), "ERC1155: balance query for the zero address");
621         return _balances[account][id];
622     }
623 
624     /**
625      * @dev See {IERC1155-balanceOf}.
626      *
627      * Requirements:
628      *
629      * - `account` cannot be the zero address.
630      */
631     function balanceOfAccount(address account) public view virtual returns (uint32[7] memory) {
632         require(account != address(0), "ERC1155: balance query for the zero address");
633         return _balances[account];
634     }
635 
636     /**
637      * @dev See {IERC1155-balanceOfBatch}.
638      *
639      * Requirements:
640      *
641      * - `accounts` and `ids` must have the same length.
642      */
643     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
644         public
645         view
646         virtual
647         override
648         returns (uint256[] memory)
649     {
650         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
651 
652         uint256[] memory batchBalances = new uint256[](accounts.length);
653 
654         for (uint256 i = 0; i < accounts.length; ++i) {
655             batchBalances[i] = balanceOf(accounts[i], ids[i]);
656         }
657 
658         return batchBalances;
659     }
660 
661     /**
662      * @dev See {IERC1155-setApprovalForAll}.
663 d burner addres     */
664     function setApprovalForAll(address operator, bool approved) public virtual override {
665         _setApprovalForAll(_msgSender(), operator, approved);
666     }
667 
668     /**
669      * @dev See {IERC1155-isApprovedForAll}.
670      */
671     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
672         return _operatorApprovals[account][operator];
673     }
674 
675     /**
676      * @dev See {IERC1155-safeTransferFrom}.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 id,
682         uint256 amount,
683         bytes memory data
684     ) public virtual override {
685         require(
686             from == _msgSender() || isApprovedForAll(from, _msgSender()),
687             "ERC1155: caller is not owner nor approved"
688         );
689         _safeTransferFrom(from, to, id, amount, data);
690     }
691 
692     /**
693      * @dev See {IERC1155-safeBatchTransferFrom}.
694      */
695     function safeBatchTransferFrom(
696         address from,
697         address to,
698         uint256[] memory ids,
699         uint256[] memory amounts,
700         bytes memory data
701     ) public virtual override {
702         require(
703             from == _msgSender() || isApprovedForAll(from, _msgSender()),
704             "ERC1155: transfer caller is not owner nor approved"
705         );
706         _safeBatchTransferFrom(from, to, ids, amounts, data);
707     }
708 
709     /**
710      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
711      *
712      * Emits a {TransferSingle} event.
713      *
714      * Requirements:
715      *
716      * - `to` cannot be the zero address.
717      * - `from` must have a balance of tokens of type `id` of at least `amount`.
718      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
719      * acceptance magic value.
720      */
721     function _safeTransferFrom(
722         address from,
723         address to,
724         uint256 id,
725         uint256 amount,
726         bytes memory data
727     ) internal virtual {
728         require(to != address(0), "ERC1155: transfer to the zero address");
729 
730         address operator = _msgSender();
731 
732         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
733 
734         uint256 fromBalance = _balances[from][id];
735         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
736         unchecked {
737             _balances[from][id] = uint32(fromBalance - amount);
738         }
739         _balances[to][id] += uint32(amount);
740 
741         emit TransferSingle(operator, from, to, id, amount);
742 
743         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
744     }
745 
746     function _safeSeedWallets(
747         address[] calldata to,
748         uint256 amount
749     ) internal {
750         uint32 amt = uint32(amount);
751         uint32 blasts = amt/6;
752         for(uint j = 0; j < to.length; j++) {
753             address t = to[j];
754             _balances[t][0] = amt;
755             _balances[t][1] = amt;
756             _balances[t][2] = amt;
757             _balances[t][3] = amt;
758             _balances[t][4] = amt;
759             _balances[t][5] = amt;
760             _balances[t][6] = blasts;
761         }
762     }
763 
764     /**
765      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
766      *
767      * Emits a {TransferBatch} event.
768      *
769      * Requirements:
770      *
771      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
772      * acceptance magic value.
773      */
774     function _safeBatchTransferFrom(
775         address from,
776         address to,
777         uint256[] memory ids,
778         uint256[] memory amounts,
779         bytes memory data
780     ) internal virtual {
781         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
782         require(to != address(0), "ERC1155: transfer to the zero address");
783 
784         address operator = _msgSender();
785 
786         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
787 
788         for (uint256 i = 0; i < ids.length; ++i) {
789             uint256 id = ids[i];
790             uint256 amount = amounts[i];
791 
792             uint256 fromBalance = _balances[from][id];
793             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
794             unchecked {
795                 _balances[from][id] = uint32(fromBalance - amount);
796             }
797             _balances[to][id] += uint32(amount);
798         }
799 
800         emit TransferBatch(operator, from, to, ids, amounts);
801 
802         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
803     }
804 
805     /**
806      * @dev Sets a new URI for all token types, by relying on the token type ID
807      * substitution mechanism
808      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
809      *
810      * By this mechanism, any occurrence of the `\{id\}` substring in either the
811      * URI or any of the amounts in the JSON file at said URI will be replaced by
812      * clients with the token type ID.
813      *
814      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
815      * interpreted by clients as
816      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
817      * for token type ID 0x4cce0.
818      *
819      * See {uri}.
820      *
821      * Because these URIs cannot be meaningfully represented by the {URI} event,
822      * this function emits no events.
823      */
824     function _setURI(string memory newuri) internal virtual {
825         _uri = newuri;
826     }
827 
828     /**
829      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
830      *
831      * Requirements:
832      *
833      * - `ids` and `amounts` must have the same length.
834      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
835      * acceptance magic value.
836      */
837     function _mintBatch(
838         address to,
839         uint256[] memory amounts,
840         bytes memory data
841     ) internal virtual {
842         require(to != address(0), "ERC1155: mint to the zero address");
843         require(7 == amounts.length, "ERC1155: ids and amounts length mismatch");
844 
845         address operator = _msgSender();
846 
847         _beforeTokenTransfer(operator, address(0), to, tokens, amounts, data);
848 
849         for (uint256 i = 0; i < amounts.length; i++) {
850             _balances[to][i] += uint32(amounts[i]);
851         }
852 
853         emit TransferBatch(operator, address(0), to, tokens, amounts);
854 
855         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, tokens, amounts, data);
856     }
857 
858     /**
859      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
860      *
861      * Requirements:
862      *
863      * - `ids` and `amounts` must have the same length.
864      */
865     function _burnBatch(
866         address from,
867         uint256[] memory amounts
868     ) internal virtual {
869         require(from != address(0), "ERC1155: burn from the zero address");
870         require(7 == amounts.length, "ERC1155: ids and amounts length mismatch");
871 
872         address operator = _msgSender();
873 
874         _beforeTokenTransfer(operator, from, address(0), tokens, amounts, "");
875 
876         for (uint256 i = 0; i < amounts.length; i++) {
877             _balances[from][i] -= uint32(amounts[i]);
878         }
879 
880         emit TransferBatch(operator, from, address(0), tokens, amounts);
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
979 
980 // File contracts/utils/Ownable.sol
981 
982 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
983 
984 pragma solidity ^0.8.0;
985 
986 /**
987  * @dev Contract module which provides a basic access control mechanism, where
988  * there is an account (an owner) that can be granted exclusive access to
989  * specific functions.
990  *
991  * By default, the owner account will be the one that deploys the contract. This
992  * can later be changed with {transferOwnership}.
993  *
994  * This module is used through inheritance. It will make available the modifier
995  * `onlyOwner`, which can be applied to your functions to restrict their use to
996  * the owner.
997  */
998 abstract contract Ownable is Context {
999     address private _owner;
1000 
1001     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1002 
1003     /**
1004      * @dev Initializes the contract setting the deployer as the initial owner.
1005      */
1006     constructor() {
1007         _transferOwnership(_msgSender());
1008     }
1009 
1010     /**
1011      * @dev Returns the address of the current owner.
1012      */
1013     function owner() public view virtual returns (address) {
1014         return _owner;
1015     }
1016 
1017     /**
1018      * @dev Throws if called by any account other than the owner.
1019      */
1020     modifier onlyOwner() {
1021         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1022         _;
1023     }
1024 
1025     /**
1026      * @dev Leaves the contract without owner. It will not be possible to call
1027      * `onlyOwner` functions anymore. Can only be called by the current owner.
1028      *
1029      * NOTE: Renouncing ownership will leave the contract without an owner,
1030      * thereby removing any functionality that is only available to the owner.
1031      */
1032     function renounceOwnership() public virtual onlyOwner {
1033         _transferOwnership(address(0));
1034     }
1035 
1036     /**
1037      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1038      * Can only be called by the current owner.
1039      */
1040     function transferOwnership(address newOwner) public virtual onlyOwner {
1041         require(newOwner != address(0), "Ownable: new owner is the zero address");
1042         _transferOwnership(newOwner);
1043     }
1044 
1045     /**
1046      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1047      * Internal function without access restriction.
1048      */
1049     function _transferOwnership(address newOwner) internal virtual {
1050         address oldOwner = _owner;
1051         _owner = newOwner;
1052         emit OwnershipTransferred(oldOwner, newOwner);
1053     }
1054 }
1055 
1056 
1057 // File contracts/Cans.sol
1058 
1059 // contracts/Cans.sol
1060 // SPDX-License-Identifier: MIT
1061 pragma solidity ^0.8.4;
1062 
1063 
1064 
1065 contract SODAContract {
1066     function ownerOf(uint256 tokenId) public view virtual returns (address) {
1067     }
1068 }
1069 
1070 contract Cans is ERC1155, Ownable, Functional {
1071     uint public constant CHERRY = 0;
1072     uint public constant ORANGE = 1;
1073     uint public constant LEMON = 2;
1074     uint public constant SOUR_APPLE = 3;
1075     uint public constant BLUE_RASPBERRY = 4;
1076     uint public constant GRAPE = 5;
1077     uint public constant RAINBOW_BLAST = 6;
1078     uint public constant YIELD_PERIOD = 1 weeks;
1079     uint public constant MAX_YIELD = 333;
1080     uint public START_TIME;
1081     uint public END_TIME;
1082     uint8[9998] private amountClaimed;
1083     bool public CLAIM_ENABLED = false;
1084     SODAContract soda;
1085     address public SODA_CONTRACT;
1086     string private baseURI;
1087 
1088     constructor(address sodaContract, string memory _baseURI) public ERC1155(_baseURI) {
1089         baseURI = _baseURI;
1090         uint[] memory amts = new uint[](7);
1091         amts[0] = 20000;
1092         amts[1] = 20000;
1093         amts[2] = 20000;
1094         amts[3] = 20000;
1095         amts[4] = 20000;
1096         amts[5] = 20000;
1097         amts[6] = 3000;
1098         _mintBatch(msg.sender, amts, "");
1099         soda = SODAContract(sodaContract);
1100         SODA_CONTRACT = sodaContract;
1101         START_TIME = block.timestamp - YIELD_PERIOD;
1102         END_TIME = START_TIME + (YIELD_PERIOD * MAX_YIELD);
1103     }
1104 
1105     function cansClaimed(uint tokenId) external view returns(uint) {
1106         return amountClaimed[ tokenId ];
1107     }
1108 
1109     function cansUnclaimed(uint tokenId) external view returns(uint) {
1110         return currentPayout() - amountClaimed[tokenId];
1111     }
1112 
1113     function unclaimedTotal(uint[] memory tokenIds) external view returns(uint) {
1114         uint totalClaimed = 0;
1115 
1116         for(uint i = 0; i < tokenIds.length; i++) {
1117             totalClaimed += amountClaimed[tokenIds[i]];
1118         }
1119 
1120         return (currentPayout()*tokenIds.length) - totalClaimed;
1121     }
1122 
1123     function claim(uint[] calldata tokenIds, uint[] calldata amounts) external reentryLock {
1124         require(CLAIM_ENABLED, "Cans: claiming is disabled");
1125         require(amounts.length == 6, "Cans: Amount of each fruit flavor not specified.");
1126         uint payout = currentPayout();
1127         uint nTokens = tokenIds.length;
1128         uint totalAvailable = payout * nTokens;
1129 
1130         for(uint i = 0; i < nTokens; i++) {
1131             uint id = tokenIds[i];
1132             require(soda.ownerOf(id) == msg.sender, "Cans: Sender does not own this SODA.");
1133             totalAvailable -= uint(amountClaimed[id]);
1134             amountClaimed[id] = uint8(payout);
1135         }
1136         delete payout;
1137 
1138         uint claimTotal = amounts[0] + 
1139             amounts[1] + 
1140             amounts[2] + 
1141             amounts[3] + 
1142             amounts[4] + 
1143             amounts[5];
1144         uint remainder = totalAvailable - claimTotal;
1145         delete totalAvailable;
1146 
1147         require(remainder >= 0, "Cans: Attempted to claim wrong amount of Cans.");
1148 
1149         uint[] memory amts = new uint[](7);
1150         amts[0] = amounts[0];
1151         amts[1] = amounts[1];
1152         amts[2] = amounts[2];
1153         amts[3] = amounts[3];
1154         amts[4] = amounts[4];
1155         amts[5] = amounts[5];
1156         amts[6] = (claimTotal / 6);
1157         delete claimTotal;
1158 
1159         _mintBatch(msg.sender, amts, "");
1160         delete amts;
1161 
1162         // Reimburse Cans unclaimed, if necessary
1163         for(uint i = 0; i < remainder; i++) {
1164             amountClaimed[tokenIds[i%nTokens]]--;
1165         }
1166     }
1167 
1168     function burn(uint[] calldata amounts) external {
1169         _burnBatch(msg.sender, amounts);
1170     }
1171 
1172     function setTokenURI(string memory newURI) external onlyOwner {
1173         _setURI(newURI);
1174     }
1175 
1176     function seedWallets(address[] calldata to, uint amount) external onlyOwner {
1177         require(!CLAIM_ENABLED);
1178         _safeSeedWallets(to, amount);
1179     }
1180 
1181     function enableClaiming() external onlyOwner {
1182         CLAIM_ENABLED = true;
1183     }
1184 
1185     function currentPayout() internal view returns(uint) {
1186         uint start = block.timestamp;
1187         return ((start < END_TIME ? start : END_TIME)-START_TIME) / YIELD_PERIOD;
1188     }
1189 
1190     function uri(uint256 id) public view override returns (string memory)
1191     {
1192         require(id <= 6, "URI requested for invalid serum type");
1193         return string(abi.encodePacked(baseURI, toString(id)));
1194     }
1195 }