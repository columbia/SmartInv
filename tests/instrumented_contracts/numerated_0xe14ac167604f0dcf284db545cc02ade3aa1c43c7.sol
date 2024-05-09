1 // Sources flattened with hardhat v2.8.3 https://hardhat.org
2 
3 // File contracts/utils/Functional.sol
4 
5 abstract contract Functional {
6     function toString(uint256 value) internal pure returns (string memory) {
7         if (value == 0) {
8             return "0";
9         }
10         uint256 temp = value;
11         uint256 digits;
12         while (temp != 0) {
13             digits++;
14             temp /= 10;
15         }
16         bytes memory buffer = new bytes(digits);
17         while (value != 0) {
18             digits -= 1;
19             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
20             value /= 10;
21         }
22         return string(buffer);
23     }
24 
25     bool private _reentryKey = false;
26     modifier reentryLock() {
27         require(!_reentryKey, "attempt to reenter a locked function");
28         _reentryKey = true;
29         _;
30         _reentryKey = false;
31     }
32 }
33 
34 
35 // File contracts/interfaces/IERC165.sol
36 
37 /**
38  * @dev Interface of the ERC165 standard, as defined in the
39  * https://eips.ethereum.org/EIPS/eip-165[EIP].
40  *
41  * Implementers can declare support of contract interfaces, which can then be
42  * queried by others ({ERC165Checker}).
43  *
44  * For an implementation, see {ERC165}.
45  */
46 interface IERC165 {
47     /**
48      * @dev Returns true if this contract implements the interface defined by
49      * `interfaceId`. See the corresponding
50      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
51      * to learn more about how these ids are created.
52      *
53      * This function call must use less than 30 000 gas.
54      */
55     function supportsInterface(bytes4 interfaceId) external view returns (bool);
56 }
57 
58 
59 // File contracts/interfaces/IERC1155.sol
60 
61 /**
62  * @dev Required interface of an ERC1155 compliant contract, as defined in the
63  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
64  *
65  * _Available since v3.1._
66  */
67 interface IERC1155 is IERC165 {
68     /**
69      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
70      */
71     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
72 
73     /**
74      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
75      * transfers.
76      */
77     event TransferBatch(
78         address indexed operator,
79         address indexed from,
80         address indexed to,
81         uint256[] ids,
82         uint256[] values
83     );
84 
85     /**
86      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
87      * `approved`.
88      */
89     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
90 
91     /**
92      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
93      *
94      * If an {URI} event was emitted for `id`, the standard
95      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
96      * returned by {IERC1155MetadataURI-uri}.
97      */
98     event URI(string value, uint256 indexed id);
99 
100     /**
101      * @dev Returns the amount of tokens of token type `id` owned by `account`.
102      *
103      * Requirements:
104      *
105      * - `account` cannot be the zero address.
106      */
107     function balanceOf(address account, uint256 id) external view returns (uint256);
108 
109     /**
110      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
111      *
112      * Requirements:
113      *
114      * - `accounts` and `ids` must have the same length.
115      */
116     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
117         external
118         view
119         returns (uint256[] memory);
120 
121     /**
122      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
123      *
124      * Emits an {ApprovalForAll} event.
125      *
126      * Requirements:
127      *
128      * - `operator` cannot be the caller.
129      */
130     function setApprovalForAll(address operator, bool approved) external;
131 
132     /**
133      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
134      *
135      * See {setApprovalForAll}.
136      */
137     function isApprovedForAll(address account, address operator) external view returns (bool);
138 
139     /**
140      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
141      *
142      * Emits a {TransferSingle} event.
143      *
144      * Requirements:
145      *
146      * - `to` cannot be the zero address.
147      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
148      * - `from` must have a balance of tokens of type `id` of at least `amount`.
149      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
150      * acceptance magic value.
151      */
152     function safeTransferFrom(
153         address from,
154         address to,
155         uint256 id,
156         uint256 amount,
157         bytes calldata data
158     ) external;
159 
160     /**
161      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
162      *
163      * Emits a {TransferBatch} event.
164      *
165      * Requirements:
166      *
167      * - `ids` and `amounts` must have the same length.
168      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
169      * acceptance magic value.
170      */
171     function safeBatchTransferFrom(
172         address from,
173         address to,
174         uint256[] calldata ids,
175         uint256[] calldata amounts,
176         bytes calldata data
177     ) external;
178 }
179 
180 
181 // File contracts/interfaces/IERC1155Receiver.sol
182 
183 /**
184  * @dev _Available since v3.1._
185  */
186 interface IERC1155Receiver is IERC165 {
187     /**
188         @dev Handles the receipt of a single ERC1155 token type. This function is
189         called at the end of a `safeTransferFrom` after the balance has been updated.
190         To accept the transfer, this must return
191         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
192         (i.e. 0xf23a6e61, or its own function selector).
193         @param operator The address which initiated the transfer (i.e. msg.sender)
194         @param from The address which previously owned the token
195         @param id The ID of the token being transferred
196         @param value The amount of tokens being transferred
197         @param data Additional data with no specified format
198         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
199     */
200     function onERC1155Received(
201         address operator,
202         address from,
203         uint256 id,
204         uint256 value,
205         bytes calldata data
206     ) external returns (bytes4);
207 
208     /**
209         @dev Handles the receipt of a multiple ERC1155 token types. This function
210         is called at the end of a `safeBatchTransferFrom` after the balances have
211         been updated. To accept the transfer(s), this must return
212         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
213         (i.e. 0xbc197c81, or its own function selector).
214         @param operator The address which initiated the batch transfer (i.e. msg.sender)
215         @param from The address which previously owned the token
216         @param ids An array containing ids of each token being transferred (order and length must match values array)
217         @param values An array containing amounts of each token being transferred (order and length must match ids array)
218         @param data Additional data with no specified format
219         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
220     */
221     function onERC1155BatchReceived(
222         address operator,
223         address from,
224         uint256[] calldata ids,
225         uint256[] calldata values,
226         bytes calldata data
227     ) external returns (bytes4);
228 }
229 
230 
231 // File contracts/interfaces/IERC1155MetadataURI.sol
232 
233 /**
234  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
235  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
236  *
237  * _Available since v3.1._
238  */
239 interface IERC1155MetadataURI is IERC1155 {
240     /**
241      * @dev Returns the URI for token type `id`.
242      *
243      * If the `\{id\}` substring is present in the URI, it must be replaced by
244      * clients with the actual token type ID.
245      */
246     function uri(uint256 id) external view returns (string memory);
247 }
248 
249 
250 // File contracts/utils/Address.sol
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // This method relies on extcodesize, which returns 0 for contracts in
275         // construction, since the code is only stored at the end of the
276         // constructor execution.
277 
278         uint256 size;
279         assembly {
280             size := extcodesize(account)
281         }
282         return size > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(
303             address(this).balance >= amount,
304             "Address: insufficient balance"
305         );
306 
307         (bool success, ) = recipient.call{value: amount}("");
308         require(
309             success,
310             "Address: unable to send value, recipient may have reverted"
311         );
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain `call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data)
333         internal
334         returns (bytes memory)
335     {
336         return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(
365         address target,
366         bytes memory data,
367         uint256 value
368     ) internal returns (bytes memory) {
369         return
370             functionCallWithValue(
371                 target,
372                 data,
373                 value,
374                 "Address: low-level call with value failed"
375             );
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(
391             address(this).balance >= value,
392             "Address: insufficient balance for call"
393         );
394         require(isContract(target), "Address: call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.call{value: value}(
397             data
398         );
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(address target, bytes memory data)
409         internal
410         view
411         returns (bytes memory)
412     {
413         return
414             functionStaticCall(
415                 target,
416                 data,
417                 "Address: low-level static call failed"
418             );
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data)
445         internal
446         returns (bytes memory)
447     {
448         return
449             functionDelegateCall(
450                 target,
451                 data,
452                 "Address: low-level delegate call failed"
453             );
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         require(isContract(target), "Address: delegate call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.delegatecall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
475      * revert reason using the provided one.
476      *
477      * _Available since v4.3._
478      */
479     function verifyCallResult(
480         bool success,
481         bytes memory returndata,
482         string memory errorMessage
483     ) internal pure returns (bytes memory) {
484         if (success) {
485             return returndata;
486         } else {
487             // Look for revert reason and bubble it up if present
488             if (returndata.length > 0) {
489                 // The easiest way to bubble the revert reason is using memory via assembly
490 
491                 assembly {
492                     let returndata_size := mload(returndata)
493                     revert(add(32, returndata), returndata_size)
494                 }
495             } else {
496                 revert(errorMessage);
497             }
498         }
499     }
500 }
501 
502 
503 // File contracts/utils/Context.sol
504 
505 /**
506  * @dev Provides information about the current execution context, including the
507  * sender of the transaction and its data. While these are generally available
508  * via msg.sender and msg.data, they should not be accessed in such a direct
509  * manner, since when dealing with meta-transactions the account sending and
510  * paying for execution may not be the actual sender (as far as an application
511  * is concerned).
512  *
513  * This contract is only required for intermediate, library-like contracts.
514  */
515 abstract contract Context {
516     function _msgSender() internal view virtual returns (address) {
517         return msg.sender;
518     }
519 
520     function _msgData() internal view virtual returns (bytes calldata) {
521         return msg.data;
522     }
523 }
524 
525 
526 // File contracts/ERC165.sol
527 
528 /**
529  * @dev Implementation of the {IERC165} interface.
530  *
531  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
532  * for the additional interface id that will be supported. For example:
533  *
534  * ```solidity
535  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
537  * }
538  * ```
539  *
540  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
541  */
542 abstract contract ERC165 is IERC165 {
543     /**
544      * @dev See {IERC165-supportsInterface}.
545      */
546     function supportsInterface(bytes4 interfaceId)
547         public
548         view
549         virtual
550         override
551         returns (bool)
552     {
553         return interfaceId == type(IERC165).interfaceId;
554     }
555 }
556 
557 
558 // File contracts/ERC1155.sol
559 
560 // SPDX-License-Identifier: MIT
561 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 
567 
568 
569 
570 /**
571  * @dev Implementation of the basic standard multi-token.
572  * See https://eips.ethereum.org/EIPS/eip-1155
573  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
574  *
575  * _Available since v3.1._
576  */
577 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
578     using Address for address;
579 
580     // Mapping from token ID to account balances
581     mapping(uint256 => mapping(address => uint256)) private _balances;
582 
583     // Mapping from account to operator approvals
584     mapping(address => mapping(address => bool)) private _operatorApprovals;
585 
586     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
587     string private _uri;
588 
589     /**
590      * @dev See {_setURI}.
591      */
592     constructor(string memory uri_) {
593         _setURI(uri_);
594     }
595 
596     /**
597      * @dev See {IERC165-supportsInterface}.
598      */
599     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
600         return
601             interfaceId == type(IERC1155).interfaceId ||
602             interfaceId == type(IERC1155MetadataURI).interfaceId ||
603             super.supportsInterface(interfaceId);
604     }
605 
606     /**
607      * @dev See {IERC1155MetadataURI-uri}.
608      *
609      * This implementation returns the same URI for *all* token types. It relies
610      * on the token type ID substitution mechanism
611      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
612      *
613      * Clients calling this function must replace the `\{id\}` substring with the
614      * actual token type ID.
615      */
616     function uri(uint256) public view virtual override returns (string memory) {
617         return _uri;
618     }
619 
620     /**
621      * @dev See {IERC1155-balanceOf}.
622      *
623      * Requirements:
624      *
625      * - `account` cannot be the zero address.
626      */
627     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
628         require(account != address(0), "ERC1155: balance query for the zero address");
629         return _balances[id][account];
630     }
631 
632     /**
633      * @dev See {IERC1155-balanceOfBatch}.
634      *
635      * Requirements:
636      *
637      * - `accounts` and `ids` must have the same length.
638      */
639     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
640         public
641         view
642         virtual
643         override
644         returns (uint256[] memory)
645     {
646         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
647 
648         uint256[] memory batchBalances = new uint256[](accounts.length);
649 
650         for (uint256 i = 0; i < accounts.length; ++i) {
651             batchBalances[i] = balanceOf(accounts[i], ids[i]);
652         }
653 
654         return batchBalances;
655     }
656 
657     /**
658      * @dev See {IERC1155-setApprovalForAll}.
659      */
660     function setApprovalForAll(address operator, bool approved) public virtual override {
661         _setApprovalForAll(_msgSender(), operator, approved);
662     }
663 
664     /**
665      * @dev See {IERC1155-isApprovedForAll}.
666      */
667     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
668         return _operatorApprovals[account][operator];
669     }
670 
671     /**
672      * @dev See {IERC1155-safeTransferFrom}.
673      */
674     function safeTransferFrom(
675         address from,
676         address to,
677         uint256 id,
678         uint256 amount,
679         bytes memory data
680     ) public virtual override {
681         require(
682             from == _msgSender() || isApprovedForAll(from, _msgSender()),
683             "ERC1155: caller is not owner nor approved"
684         );
685         _safeTransferFrom(from, to, id, amount, data);
686     }
687 
688     /**
689      * @dev See {IERC1155-safeBatchTransferFrom}.
690      */
691     function safeBatchTransferFrom(
692         address from,
693         address to,
694         uint256[] memory ids,
695         uint256[] memory amounts,
696         bytes memory data
697     ) public virtual override {
698         require(
699             from == _msgSender() || isApprovedForAll(from, _msgSender()),
700             "ERC1155: transfer caller is not owner nor approved"
701         );
702         _safeBatchTransferFrom(from, to, ids, amounts, data);
703     }
704 
705     /**
706      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
707      *
708      * Emits a {TransferSingle} event.
709      *
710      * Requirements:
711      *
712      * - `to` cannot be the zero address.
713      * - `from` must have a balance of tokens of type `id` of at least `amount`.
714      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
715      * acceptance magic value.
716      */
717     function _safeTransferFrom(
718         address from,
719         address to,
720         uint256 id,
721         uint256 amount,
722         bytes memory data
723     ) internal virtual {
724         require(to != address(0), "ERC1155: transfer to the zero address");
725 
726         address operator = _msgSender();
727 
728         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
729 
730         uint256 fromBalance = _balances[id][from];
731         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
732         unchecked {
733             _balances[id][from] = fromBalance - amount;
734         }
735         _balances[id][to] += amount;
736 
737         emit TransferSingle(operator, from, to, id, amount);
738 
739         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
740     }
741 
742     /**
743      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
744      *
745      * Emits a {TransferBatch} event.
746      *
747      * Requirements:
748      *
749      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
750      * acceptance magic value.
751      */
752     function _safeBatchTransferFrom(
753         address from,
754         address to,
755         uint256[] memory ids,
756         uint256[] memory amounts,
757         bytes memory data
758     ) internal virtual {
759         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
760         require(to != address(0), "ERC1155: transfer to the zero address");
761 
762         address operator = _msgSender();
763 
764         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
765 
766         for (uint256 i = 0; i < ids.length; ++i) {
767             uint256 id = ids[i];
768             uint256 amount = amounts[i];
769 
770             uint256 fromBalance = _balances[id][from];
771             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
772             unchecked {
773                 _balances[id][from] = fromBalance - amount;
774             }
775             _balances[id][to] += amount;
776         }
777 
778         emit TransferBatch(operator, from, to, ids, amounts);
779 
780         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
781     }
782 
783     /**
784      * @dev Sets a new URI for all token types, by relying on the token type ID
785      * substitution mechanism
786      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
787      *
788      * By this mechanism, any occurrence of the `\{id\}` substring in either the
789      * URI or any of the amounts in the JSON file at said URI will be replaced by
790      * clients with the token type ID.
791      *
792      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
793      * interpreted by clients as
794      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
795      * for token type ID 0x4cce0.
796      *
797      * See {uri}.
798      *
799      * Because these URIs cannot be meaningfully represented by the {URI} event,
800      * this function emits no events.
801      */
802     function _setURI(string memory newuri) internal virtual {
803         _uri = newuri;
804     }
805 
806     /**
807      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
808      *
809      * Emits a {TransferSingle} event.
810      *
811      * Requirements:
812      *
813      * - `to` cannot be the zero address.
814      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
815      * acceptance magic value.
816      */
817     function _mint(
818         address to,
819         uint256 id,
820         uint256 amount,
821         bytes memory data
822     ) internal virtual {
823         require(to != address(0), "ERC1155: mint to the zero address");
824 
825         address operator = _msgSender();
826 
827         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
828 
829         _balances[id][to] += amount;
830         emit TransferSingle(operator, address(0), to, id, amount);
831 
832         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
833     }
834 
835     /**
836      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
837      *
838      * Requirements:
839      *
840      * - `ids` and `amounts` must have the same length.
841      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
842      * acceptance magic value.
843      */
844     function _mintBatch(
845         address to,
846         uint256[] memory ids,
847         uint256[] memory amounts,
848         bytes memory data
849     ) internal virtual {
850         require(to != address(0), "ERC1155: mint to the zero address");
851         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
852 
853         address operator = _msgSender();
854 
855         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
856 
857         for (uint256 i = 0; i < ids.length; i++) {
858             _balances[ids[i]][to] += amounts[i];
859         }
860 
861         emit TransferBatch(operator, address(0), to, ids, amounts);
862 
863         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
864     }
865 
866     /**
867      * @dev Destroys `amount` tokens of token type `id` from `from`
868      *
869      * Requirements:
870      *
871      * - `from` cannot be the zero address.
872      * - `from` must have at least `amount` tokens of token type `id`.
873      */
874     function _burn(
875         address from,
876         uint256 id,
877         uint256 amount
878     ) internal virtual {
879         require(from != address(0), "ERC1155: burn from the zero address");
880 
881         address operator = _msgSender();
882 
883         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
884 
885         uint256 fromBalance = _balances[id][from];
886         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
887         unchecked {
888             _balances[id][from] = fromBalance - amount;
889         }
890 
891         emit TransferSingle(operator, from, address(0), id, amount);
892     }
893 
894     /**
895      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
896      *
897      * Requirements:
898      *
899      * - `ids` and `amounts` must have the same length.
900      */
901     function _burnBatch(
902         address from,
903         uint256[] memory ids,
904         uint256[] memory amounts
905     ) internal virtual {
906         require(from != address(0), "ERC1155: burn from the zero address");
907         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
908 
909         address operator = _msgSender();
910 
911         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
912 
913         for (uint256 i = 0; i < ids.length; i++) {
914             uint256 id = ids[i];
915             uint256 amount = amounts[i];
916 
917             uint256 fromBalance = _balances[id][from];
918             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
919             unchecked {
920                 _balances[id][from] = fromBalance - amount;
921             }
922         }
923 
924         emit TransferBatch(operator, from, address(0), ids, amounts);
925     }
926 
927     /**
928      * @dev Approve `operator` to operate on all of `owner` tokens
929      *
930      * Emits a {ApprovalForAll} event.
931      */
932     function _setApprovalForAll(
933         address owner,
934         address operator,
935         bool approved
936     ) internal virtual {
937         require(owner != operator, "ERC1155: setting approval status for self");
938         _operatorApprovals[owner][operator] = approved;
939         emit ApprovalForAll(owner, operator, approved);
940     }
941 
942     /**
943      * @dev Hook that is called before any token transfer. This includes minting
944      * and burning, as well as batched variants.
945      *
946      * The same hook is called on both single and batched variants. For single
947      * transfers, the length of the `id` and `amount` arrays will be 1.
948      *
949      * Calling conditions (for each `id` and `amount` pair):
950      *
951      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
952      * of token type `id` will be  transferred to `to`.
953      * - When `from` is zero, `amount` tokens of token type `id` will be minted
954      * for `to`.
955      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
956      * will be burned.
957      * - `from` and `to` are never both zero.
958      * - `ids` and `amounts` have the same, non-zero length.
959      *
960      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
961      */
962     function _beforeTokenTransfer(
963         address operator,
964         address from,
965         address to,
966         uint256[] memory ids,
967         uint256[] memory amounts,
968         bytes memory data
969     ) internal virtual {}
970 
971     function _doSafeTransferAcceptanceCheck(
972         address operator,
973         address from,
974         address to,
975         uint256 id,
976         uint256 amount,
977         bytes memory data
978     ) private {
979         if (to.isContract()) {
980             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
981                 if (response != IERC1155Receiver.onERC1155Received.selector) {
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
992     function _doSafeBatchTransferAcceptanceCheck(
993         address operator,
994         address from,
995         address to,
996         uint256[] memory ids,
997         uint256[] memory amounts,
998         bytes memory data
999     ) private {
1000         if (to.isContract()) {
1001             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1002                 bytes4 response
1003             ) {
1004                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1005                     revert("ERC1155: ERC1155Receiver rejected tokens");
1006                 }
1007             } catch Error(string memory reason) {
1008                 revert(reason);
1009             } catch {
1010                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1011             }
1012         }
1013     }
1014 
1015     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1016         uint256[] memory array = new uint256[](1);
1017         array[0] = element;
1018 
1019         return array;
1020     }
1021 }
1022 
1023 
1024 // File contracts/utils/Ownable.sol
1025 
1026 /**
1027  * @dev Contract module which provides a basic access control mechanism, where
1028  * there is an account (an owner) that can be granted exclusive access to
1029  * specific functions.
1030  *
1031  * By default, the owner account will be the one that deploys the contract. This
1032  * can later be changed with {transferOwnership}.
1033  *
1034  * This module is used through inheritance. It will make available the modifier
1035  * `onlyOwner`, which can be applied to your functions to restrict their use to
1036  * the owner.
1037  */
1038 abstract contract Ownable is Context {
1039     address private _owner;
1040 
1041     event OwnershipTransferred(
1042         address indexed previousOwner,
1043         address indexed newOwner
1044     );
1045 
1046     /**
1047      * @dev Initializes the contract setting the deployer as the initial owner.
1048      */
1049     constructor() {
1050         _setOwner(_msgSender());
1051     }
1052 
1053     /**
1054      * @dev Returns the address of the current owner.
1055      */
1056     function owner() public view virtual returns (address) {
1057         return _owner;
1058     }
1059 
1060     /**
1061      * @dev Throws if called by any account other than the owner.
1062      */
1063     modifier onlyOwner() {
1064         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1065         _;
1066     }
1067 
1068     /**
1069      * @dev Leaves the contract without owner. It will not be possible to call
1070      * `onlyOwner` functions anymore. Can only be called by the current owner.
1071      *
1072      * NOTE: Renouncing ownership will leave the contract without an owner,
1073      * thereby removing any functionality that is only available to the owner.
1074      */
1075     function renounceOwnership() public virtual onlyOwner {
1076         _setOwner(address(0));
1077     }
1078 
1079     /**
1080      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1081      * Can only be called by the current owner.
1082      */
1083     function transferOwnership(address newOwner) public virtual onlyOwner {
1084         require(
1085             newOwner != address(0),
1086             "Ownable: new owner is the zero address"
1087         );
1088         _setOwner(newOwner);
1089     }
1090 
1091     function _setOwner(address newOwner) private {
1092         address oldOwner = _owner;
1093         _owner = newOwner;
1094         emit OwnershipTransferred(oldOwner, newOwner);
1095     }
1096 }
1097 
1098 
1099 // File contracts/Kegs.sol
1100 
1101 contract SlattContract {
1102 	function mint(address account, uint256 amount) external {}
1103 }
1104 
1105 contract Kegs is ERC1155, Ownable, Functional {
1106 
1107     string private baseURI;
1108     SlattContract slatt;
1109     address public SLATT_CONTRACT;
1110     bool public supplyFrozen;
1111 
1112     constructor(string memory _baseURI) public ERC1155(_baseURI) {
1113         baseURI = _baseURI;
1114         supplyFrozen = false;
1115     }
1116 
1117     function setSlattContract(address _slatt) external onlyOwner {
1118         slatt = SlattContract(_slatt);
1119         SLATT_CONTRACT = _slatt;
1120     }
1121 
1122     function mint(uint id, uint amount) external onlyOwner {
1123         require(!supplyFrozen, "Supply is frozen");
1124         _mint(msg.sender, id, amount, "");
1125     }
1126 
1127     function airdrop(address[] memory recipients, uint id, uint amount) external onlyOwner {
1128         require(!supplyFrozen, "Supply is frozen");
1129         for(uint i = 0; i < recipients.length; i++) {
1130             _mint(recipients[i], id, amount, "");
1131         }
1132     }
1133 
1134     function burn(uint id, uint amount) external {
1135         _burn(msg.sender, id, amount);
1136         slatt.mint(msg.sender, 420);
1137     }
1138 
1139     function setTokenURI(string memory newURI) external onlyOwner {
1140         baseURI = newURI;
1141     }
1142 
1143     function freezeSupply() external onlyOwner {
1144         supplyFrozen = true;
1145     }
1146 
1147     function uri(uint256 id) public view override returns (string memory)
1148     {
1149         return string(abi.encodePacked(baseURI, toString(id)));
1150     }
1151 }