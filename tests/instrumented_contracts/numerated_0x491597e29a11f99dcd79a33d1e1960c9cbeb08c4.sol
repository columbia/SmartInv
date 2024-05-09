1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-30
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.4;
7 
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 abstract contract Context {
68     function _msgSender() internal view virtual returns (address) {
69         return msg.sender;
70     }
71 
72     function _msgData() internal view virtual returns (bytes calldata) {
73         return msg.data;
74     }
75 }
76 library Address {
77     /**
78      * @dev Returns true if `account` is a contract.
79      *
80      * [IMPORTANT]
81      * ====
82      * It is unsafe to assume that an address for which this function returns
83      * false is an externally-owned account (EOA) and not a contract.
84      *
85      * Among others, `isContract` will return false for the following
86      * types of addresses:
87      *
88      *  - an externally-owned account
89      *  - a contract in construction
90      *  - an address where a contract will be created
91      *  - an address where a contract lived, but was destroyed
92      * ====
93      *
94      * [IMPORTANT]
95      * ====
96      * You shouldn't rely on `isContract` to protect against flash loan attacks!
97      *
98      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
99      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
100      * constructor.
101      * ====
102      */
103     function isContract(address account) internal view returns (bool) {
104         // This method relies on extcodesize/address.code.length, which returns 0
105         // for contracts in construction, since the code is only stored at the end
106         // of the constructor execution.
107 
108         return account.code.length > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 interface IERC165 {
291     /**
292      * @dev Returns true if this contract implements the interface defined by
293      * `interfaceId`. See the corresponding
294      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
295      * to learn more about how these ids are created.
296      *
297      * This function call must use less than 30 000 gas.
298      */
299     function supportsInterface(bytes4 interfaceId) external view returns (bool);
300 }
301 abstract contract ERC165 is IERC165 {
302     /**
303      * @dev See {IERC165-supportsInterface}.
304      */
305     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
306         return interfaceId == type(IERC165).interfaceId;
307     }
308 }
309 interface IERC1155Receiver is IERC165 {
310     /**
311      * @dev Handles the receipt of a single ERC1155 token type. This function is
312      * called at the end of a `safeTransferFrom` after the balance has been updated.
313      *
314      * NOTE: To accept the transfer, this must return
315      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
316      * (i.e. 0xf23a6e61, or its own function selector).
317      *
318      * @param operator The address which initiated the transfer (i.e. msg.sender)
319      * @param from The address which previously owned the token
320      * @param id The ID of the token being transferred
321      * @param value The amount of tokens being transferred
322      * @param data Additional data with no specified format
323      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
324      */
325     function onERC1155Received(
326         address operator,
327         address from,
328         uint256 id,
329         uint256 value,
330         bytes calldata data
331     ) external returns (bytes4);
332 
333     /**
334      * @dev Handles the receipt of a multiple ERC1155 token types. This function
335      * is called at the end of a `safeBatchTransferFrom` after the balances have
336      * been updated.
337      *
338      * NOTE: To accept the transfer(s), this must return
339      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
340      * (i.e. 0xbc197c81, or its own function selector).
341      *
342      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
343      * @param from The address which previously owned the token
344      * @param ids An array containing ids of each token being transferred (order and length must match values array)
345      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
346      * @param data Additional data with no specified format
347      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
348      */
349     function onERC1155BatchReceived(
350         address operator,
351         address from,
352         uint256[] calldata ids,
353         uint256[] calldata values,
354         bytes calldata data
355     ) external returns (bytes4);
356 }
357 interface IERC1155 is IERC165 {
358     /**
359      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
360      */
361     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
362 
363     /**
364      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
365      * transfers.
366      */
367     event TransferBatch(
368         address indexed operator,
369         address indexed from,
370         address indexed to,
371         uint256[] ids,
372         uint256[] values
373     );
374 
375     /**
376      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
377      * `approved`.
378      */
379     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
380 
381     /**
382      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
383      *
384      * If an {URI} event was emitted for `id`, the standard
385      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
386      * returned by {IERC1155MetadataURI-uri}.
387      */
388     event URI(string value, uint256 indexed id);
389 
390     /**
391      * @dev Returns the amount of tokens of token type `id` owned by `account`.
392      *
393      * Requirements:
394      *
395      * - `account` cannot be the zero address.
396      */
397     function balanceOf(address account, uint256 id) external view returns (uint256);
398 
399     /**
400      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
401      *
402      * Requirements:
403      *
404      * - `accounts` and `ids` must have the same length.
405      */
406     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
407         external
408         view
409         returns (uint256[] memory);
410 
411     /**
412      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
413      *
414      * Emits an {ApprovalForAll} event.
415      *
416      * Requirements:
417      *
418      * - `operator` cannot be the caller.
419      */
420     function setApprovalForAll(address operator, bool approved) external;
421 
422     /**
423      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
424      *
425      * See {setApprovalForAll}.
426      */
427     function isApprovedForAll(address account, address operator) external view returns (bool);
428 
429     /**
430      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
431      *
432      * Emits a {TransferSingle} event.
433      *
434      * Requirements:
435      *
436      * - `to` cannot be the zero address.
437      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
438      * - `from` must have a balance of tokens of type `id` of at least `amount`.
439      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
440      * acceptance magic value.
441      */
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 id,
446         uint256 amount,
447         bytes calldata data
448     ) external;
449 
450     /**
451      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
452      *
453      * Emits a {TransferBatch} event.
454      *
455      * Requirements:
456      *
457      * - `ids` and `amounts` must have the same length.
458      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
459      * acceptance magic value.
460      */
461     function safeBatchTransferFrom(
462         address from,
463         address to,
464         uint256[] calldata ids,
465         uint256[] calldata amounts,
466         bytes calldata data
467     ) external;
468 }
469 interface IERC1155MetadataURI is IERC1155 {
470     /**
471      * @dev Returns the URI for token type `id`.
472      *
473      * If the `\{id\}` substring is present in the URI, it must be replaced by
474      * clients with the actual token type ID.
475      */
476     function uri(uint256 id) external view returns (string memory);
477 }
478 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
479     using Address for address;
480 
481     // Mapping from token ID to account balances
482     mapping(uint256 => mapping(address => uint256)) private _balances;
483 
484     // Mapping from account to operator approvals
485     mapping(address => mapping(address => bool)) private _operatorApprovals;
486 
487     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
488     string private _uri;
489 
490     /**
491      * @dev See {_setURI}.
492      */
493     constructor(string memory uri_) {
494         _setURI(uri_);
495     }
496 
497     /**
498      * @dev See {IERC165-supportsInterface}.
499      */
500     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
501         return
502             interfaceId == type(IERC1155).interfaceId ||
503             interfaceId == type(IERC1155MetadataURI).interfaceId ||
504             super.supportsInterface(interfaceId);
505     }
506 
507     /**
508      * @dev See {IERC1155MetadataURI-uri}.
509      *
510      * This implementation returns the same URI for *all* token types. It relies
511      * on the token type ID substitution mechanism
512      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
513      *
514      * Clients calling this function must replace the `\{id\}` substring with the
515      * actual token type ID.
516      */
517     function uri(uint256) public view virtual override returns (string memory) {
518         return _uri;
519     }
520 
521     /**
522      * @dev See {IERC1155-balanceOf}.
523      *
524      * Requirements:
525      *
526      * - `account` cannot be the zero address.
527      */
528     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
529         require(account != address(0), "ERC1155: balance query for the zero address");
530         return _balances[id][account];
531     }
532 
533     /**
534      * @dev See {IERC1155-balanceOfBatch}.
535      *
536      * Requirements:
537      *
538      * - `accounts` and `ids` must have the same length.
539      */
540     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
541         public
542         view
543         virtual
544         override
545         returns (uint256[] memory)
546     {
547         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
548 
549         uint256[] memory batchBalances = new uint256[](accounts.length);
550 
551         for (uint256 i = 0; i < accounts.length; ++i) {
552             batchBalances[i] = balanceOf(accounts[i], ids[i]);
553         }
554 
555         return batchBalances;
556     }
557 
558     /**
559      * @dev See {IERC1155-setApprovalForAll}.
560      */
561     function setApprovalForAll(address operator, bool approved) public virtual override {
562         _setApprovalForAll(_msgSender(), operator, approved);
563     }
564 
565     /**
566      * @dev See {IERC1155-isApprovedForAll}.
567      */
568     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
569         return _operatorApprovals[account][operator];
570     }
571 
572     /**
573      * @dev See {IERC1155-safeTransferFrom}.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 id,
579         uint256 amount,
580         bytes memory data
581     ) public virtual override {
582         require(
583             from == _msgSender() || isApprovedForAll(from, _msgSender()),
584             "ERC1155: caller is not owner nor approved"
585         );
586         _safeTransferFrom(from, to, id, amount, data);
587     }
588 
589     /**
590      * @dev See {IERC1155-safeBatchTransferFrom}.
591      */
592     function safeBatchTransferFrom(
593         address from,
594         address to,
595         uint256[] memory ids,
596         uint256[] memory amounts,
597         bytes memory data
598     ) public virtual override {
599         require(
600             from == _msgSender() || isApprovedForAll(from, _msgSender()),
601             "ERC1155: transfer caller is not owner nor approved"
602         );
603         _safeBatchTransferFrom(from, to, ids, amounts, data);
604     }
605 
606     /**
607      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
608      *
609      * Emits a {TransferSingle} event.
610      *
611      * Requirements:
612      *
613      * - `to` cannot be the zero address.
614      * - `from` must have a balance of tokens of type `id` of at least `amount`.
615      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
616      * acceptance magic value.
617      */
618     function _safeTransferFrom(
619         address from,
620         address to,
621         uint256 id,
622         uint256 amount,
623         bytes memory data
624     ) internal virtual {
625         require(to != address(0), "ERC1155: transfer to the zero address");
626 
627         address operator = _msgSender();
628 
629         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
630 
631         uint256 fromBalance = _balances[id][from];
632         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
633         unchecked {
634             _balances[id][from] = fromBalance - amount;
635         }
636         _balances[id][to] += amount;
637 
638         emit TransferSingle(operator, from, to, id, amount);
639 
640         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
641     }
642 
643     /**
644      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
645      *
646      * Emits a {TransferBatch} event.
647      *
648      * Requirements:
649      *
650      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
651      * acceptance magic value.
652      */
653     function _safeBatchTransferFrom(
654         address from,
655         address to,
656         uint256[] memory ids,
657         uint256[] memory amounts,
658         bytes memory data
659     ) internal virtual {
660         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
661         require(to != address(0), "ERC1155: transfer to the zero address");
662 
663         address operator = _msgSender();
664 
665         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
666 
667         for (uint256 i = 0; i < ids.length; ++i) {
668             uint256 id = ids[i];
669             uint256 amount = amounts[i];
670 
671             uint256 fromBalance = _balances[id][from];
672             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
673             unchecked {
674                 _balances[id][from] = fromBalance - amount;
675             }
676             _balances[id][to] += amount;
677         }
678 
679         emit TransferBatch(operator, from, to, ids, amounts);
680 
681         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
682     }
683 
684     /**
685      * @dev Sets a new URI for all token types, by relying on the token type ID
686      * substitution mechanism
687      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
688      *
689      * By this mechanism, any occurrence of the `\{id\}` substring in either the
690      * URI or any of the amounts in the JSON file at said URI will be replaced by
691      * clients with the token type ID.
692      *
693      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
694      * interpreted by clients as
695      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
696      * for token type ID 0x4cce0.
697      *
698      * See {uri}.
699      *
700      * Because these URIs cannot be meaningfully represented by the {URI} event,
701      * this function emits no events.
702      */
703     function _setURI(string memory newuri) internal virtual {
704         _uri = newuri;
705     }
706 
707     /**
708      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
709      *
710      * Emits a {TransferSingle} event.
711      *
712      * Requirements:
713      *
714      * - `to` cannot be the zero address.
715      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
716      * acceptance magic value.
717      */
718     function _mint(
719         address to,
720         uint256 id,
721         uint256 amount,
722         bytes memory data
723     ) internal virtual {
724         require(to != address(0), "ERC1155: mint to the zero address");
725 
726         address operator = _msgSender();
727 
728         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
729 
730         _balances[id][to] += amount;
731         emit TransferSingle(operator, address(0), to, id, amount);
732 
733         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
734     }
735 
736     /**
737      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
738      *
739      * Requirements:
740      *
741      * - `ids` and `amounts` must have the same length.
742      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
743      * acceptance magic value.
744      */
745     function _mintBatch(
746         address to,
747         uint256[] memory ids,
748         uint256[] memory amounts,
749         bytes memory data
750     ) internal virtual {
751         require(to != address(0), "ERC1155: mint to the zero address");
752         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
753 
754         address operator = _msgSender();
755 
756         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
757 
758         for (uint256 i = 0; i < ids.length; i++) {
759             _balances[ids[i]][to] += amounts[i];
760         }
761 
762         emit TransferBatch(operator, address(0), to, ids, amounts);
763 
764         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
765     }
766 
767     /**
768      * @dev Destroys `amount` tokens of token type `id` from `from`
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `from` must have at least `amount` tokens of token type `id`.
774      */
775     function _burn(
776         address from,
777         uint256 id,
778         uint256 amount
779     ) internal virtual {
780         require(from != address(0), "ERC1155: burn from the zero address");
781 
782         address operator = _msgSender();
783 
784         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
785 
786         uint256 fromBalance = _balances[id][from];
787         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
788         unchecked {
789             _balances[id][from] = fromBalance - amount;
790         }
791 
792         emit TransferSingle(operator, from, address(0), id, amount);
793     }
794 
795     /**
796      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
797      *
798      * Requirements:
799      *
800      * - `ids` and `amounts` must have the same length.
801      */
802     function _burnBatch(
803         address from,
804         uint256[] memory ids,
805         uint256[] memory amounts
806     ) internal virtual {
807         require(from != address(0), "ERC1155: burn from the zero address");
808         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
809 
810         address operator = _msgSender();
811 
812         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
813 
814         for (uint256 i = 0; i < ids.length; i++) {
815             uint256 id = ids[i];
816             uint256 amount = amounts[i];
817 
818             uint256 fromBalance = _balances[id][from];
819             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
820             unchecked {
821                 _balances[id][from] = fromBalance - amount;
822             }
823         }
824 
825         emit TransferBatch(operator, from, address(0), ids, amounts);
826     }
827 
828     /**
829      * @dev Approve `operator` to operate on all of `owner` tokens
830      *
831      * Emits a {ApprovalForAll} event.
832      */
833     function _setApprovalForAll(
834         address owner,
835         address operator,
836         bool approved
837     ) internal virtual {
838         require(owner != operator, "ERC1155: setting approval status for self");
839         _operatorApprovals[owner][operator] = approved;
840         emit ApprovalForAll(owner, operator, approved);
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
882                 if (response != IERC1155Receiver.onERC1155Received.selector) {
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
905                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
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
923 abstract contract Ownable is Context {
924     address private _owner;
925 
926     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
927 
928     /**
929      * @dev Initializes the contract setting the deployer as the initial owner.
930      */
931     constructor() {
932         _transferOwnership(_msgSender());
933     }
934 
935     /**
936      * @dev Returns the address of the current owner.
937      */
938     function owner() public view virtual returns (address) {
939         return _owner;
940     }
941 
942     /**
943      * @dev Throws if called by any account other than the owner.
944      */
945     modifier onlyOwner() {
946         require(owner() == _msgSender(), "Ownable: caller is not the owner");
947         _;
948     }
949 
950     /**
951      * @dev Leaves the contract without owner. It will not be possible to call
952      * `onlyOwner` functions anymore. Can only be called by the current owner.
953      *
954      * NOTE: Renouncing ownership will leave the contract without an owner,
955      * thereby removing any functionality that is only available to the owner.
956      */
957     function renounceOwnership() public virtual onlyOwner {
958         _transferOwnership(address(0));
959     }
960 
961     /**
962      * @dev Transfers ownership of the contract to a new account (`newOwner`).
963      * Can only be called by the current owner.
964      */
965     function transferOwnership(address newOwner) public virtual onlyOwner {
966         require(newOwner != address(0), "Ownable: new owner is the zero address");
967         _transferOwnership(newOwner);
968     }
969 
970     /**
971      * @dev Transfers ownership of the contract to a new account (`newOwner`).
972      * Internal function without access restriction.
973      */
974     function _transferOwnership(address newOwner) internal virtual {
975         address oldOwner = _owner;
976         _owner = newOwner;
977         emit OwnershipTransferred(oldOwner, newOwner);
978     }
979 }
980 abstract contract ERC1155Burnable is ERC1155 {
981     function burn(
982         address account,
983         uint256 id,
984         uint256 value
985     ) public virtual {
986         require(
987             account == _msgSender() || isApprovedForAll(account, _msgSender()),
988             "ERC1155: caller is not owner nor approved"
989         );
990 
991         _burn(account, id, value);
992     }
993 
994     function burnBatch(
995         address account,
996         uint256[] memory ids,
997         uint256[] memory values
998     ) public virtual {
999         require(
1000             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1001             "ERC1155: caller is not owner nor approved"
1002         );
1003 
1004         _burnBatch(account, ids, values);
1005     }
1006 }
1007 abstract contract ERC1155Supply is ERC1155 {
1008     mapping(uint256 => uint256) private _totalSupply;
1009 
1010     /**
1011      * @dev Total amount of tokens in with a given id.
1012      */
1013     function totalSupply(uint256 id) public view virtual returns (uint256) {
1014         return _totalSupply[id];
1015     }
1016 
1017     /**
1018      * @dev Indicates whether any token exist with a given id, or not.
1019      */
1020     function exists(uint256 id) public view virtual returns (bool) {
1021         return ERC1155Supply.totalSupply(id) > 0;
1022     }
1023 
1024     /**
1025      * @dev See {ERC1155-_beforeTokenTransfer}.
1026      */
1027     function _beforeTokenTransfer(
1028         address operator,
1029         address from,
1030         address to,
1031         uint256[] memory ids,
1032         uint256[] memory amounts,
1033         bytes memory data
1034     ) internal virtual override {
1035         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1036 
1037         if (from == address(0)) {
1038             for (uint256 i = 0; i < ids.length; ++i) {
1039                 _totalSupply[ids[i]] += amounts[i];
1040             }
1041         }
1042 
1043         if (to == address(0)) {
1044             for (uint256 i = 0; i < ids.length; ++i) {
1045                 _totalSupply[ids[i]] -= amounts[i];
1046             }
1047         }
1048     }
1049 }
1050 
1051 interface IERC20 {
1052     /**
1053      * @dev Returns the amount of tokens in existence.
1054      */
1055     function totalSupply() external view returns (uint256);
1056 
1057     /**
1058      * @dev Returns the amount of tokens owned by `account`.
1059      */
1060     function balanceOf(address account) external view returns (uint256);
1061 
1062     /**
1063      * @dev Moves `amount` tokens from the caller's account to `to`.
1064      *
1065      * Returns a boolean value indicating whether the operation succeeded.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function transfer(address to, uint256 amount) external returns (bool);
1070 
1071     /**
1072      * @dev Returns the remaining number of tokens that `spender` will be
1073      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1074      * zero by default.
1075      *
1076      * This value changes when {approve} or {transferFrom} are called.
1077      */
1078     function allowance(address owner, address spender) external view returns (uint256);
1079 
1080     /**
1081      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1082      *
1083      * Returns a boolean value indicating whether the operation succeeded.
1084      *
1085      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1086      * that someone may use both the old and the new allowance by unfortunate
1087      * transaction ordering. One possible solution to mitigate this race
1088      * condition is to first reduce the spender's allowance to 0 and set the
1089      * desired value afterwards:
1090      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1091      *
1092      * Emits an {Approval} event.
1093      */
1094     function approve(address spender, uint256 amount) external returns (bool);
1095 
1096     /**
1097      * @dev Moves `amount` tokens from `from` to `to` using the
1098      * allowance mechanism. `amount` is then deducted from the caller's
1099      * allowance.
1100      *
1101      * Returns a boolean value indicating whether the operation succeeded.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function transferFrom(
1106         address from,
1107         address to,
1108         uint256 amount
1109     ) external returns (bool);
1110 
1111     /**
1112      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1113      * another (`to`).
1114      *
1115      * Note that `value` may be zero.
1116      */
1117     event Transfer(address indexed from, address indexed to, uint256 value);
1118 
1119     /**
1120      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1121      * a call to {approve}. `value` is the new allowance.
1122      */
1123     event Approval(address indexed owner, address indexed spender, uint256 value);
1124 }
1125 
1126 contract CaribbeanPass is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
1127 
1128     mapping(uint256 => uint256) public price;
1129     mapping(uint256 => uint256) public supply;
1130     mapping(uint256 => uint256) public burnQ;
1131     mapping(address => mapping(uint256 => uint256)) public numberMinted;    
1132 
1133     uint256 public burned =0; 
1134 
1135     string public name;
1136     string public symbol;
1137 
1138     bool public status = true;
1139 
1140     using Strings for uint256;
1141 
1142     address public apeAddress = 0x4d224452801ACEd8B2F0aebE155379bb5D594381;
1143 
1144     string baseuri = "ipfs://QmYqnTaKzUKLgyHyeeV9T6pddFhDnNzUhiWBNkr5QM2kpJ/";
1145 
1146     constructor() ERC1155("ipfs://QmYqnTaKzUKLgyHyeeV9T6pddFhDnNzUhiWBNkr5QM2kpJ/{id}.json") {
1147         name = "Caribbean Pass";
1148         symbol = "CABP";
1149 
1150         price[1] = 5 ether;
1151         price[2] = 25 ether;
1152         price[3] = 50 ether;
1153         price[4] = 75 ether;
1154 
1155         supply[1] = 2501;
1156         supply[2] = 1001;
1157         supply[3] = 501;
1158         supply[4] = 201;
1159 
1160         burnQ[2] = 5;
1161         burnQ[3] = 10;
1162         burnQ[4] = 15;
1163     }
1164     function setPrice(uint256 id, uint256 p) public onlyOwner{
1165         price[id] = p;
1166     }
1167 
1168     function setStatus() public onlyOwner{
1169         status = !status;
1170     }
1171 
1172     function setBurnQ(uint256 id, uint256 b) public onlyOwner{
1173         burnQ[id] = b;
1174     }
1175 
1176     function mint(address account, uint256 id, uint256 amount) public onlyOwner {
1177         _mint(account, id, amount, "");
1178     }
1179 
1180     function mintBronzeA(uint256 q) public {
1181         require(status, "Minting is paused");
1182         require( totalSupply(1) < 1001 + burned, "Free Bronze Sold Out" );
1183         require( q > 0 && q < 3, "Invalid Quantity Given" );
1184         require( numberMinted[msg.sender][1] + q < 3, "Cannot mint more than 2 free bronze" );
1185 
1186         numberMinted[msg.sender][1] += q;
1187         _mint(msg.sender, 1, q, "");
1188     }
1189 
1190     function mintBronze(uint256 q) public {
1191         require(status, "Minting is paused");
1192         require( totalSupply(1) < supply[1] + burned - 500, "Bronze Sold Out" );
1193         require( q > 0 && q < 8, "Invalid Quantity Given" );
1194         require( numberMinted[msg.sender][1] + q < 8, "Cannot mint more than 5 bronze" );
1195         IERC20(apeAddress).transferFrom(msg.sender, 0x7F65D1e07E31c9D9e0C9d9F5Fa00FcA317c3B064, price[1]*q);
1196 
1197         numberMinted[msg.sender][1] += q;
1198         _mint(msg.sender, 1, q, "");
1199     }
1200     function getMinted (uint256 id) public view returns (uint256){
1201         return numberMinted[msg.sender][id];
1202     }
1203     function mint(uint256 id, uint256 q) public {
1204         require(status, "Minting is paused");
1205         require( id > 1 && id < 5, "Invalid Id");
1206         require( q < 11, "Max 10 per Txn");
1207         require( totalSupply(id)+q < supply[id], "Membership Sold Out" );
1208 
1209         _mint(msg.sender, id, q, "");
1210         numberMinted[msg.sender][id]++;
1211         IERC20(apeAddress).transferFrom(msg.sender, 0x7F65D1e07E31c9D9e0C9d9F5Fa00FcA317c3B064, price[id]*q);
1212     }
1213 
1214     function burnMint(uint256 id, uint256 q) public {
1215         require(status, "Minting is paused");
1216         require( q < 11, "Max 10 per Txn");
1217         require( id > 1 && id < 5, "Invalid Id");
1218         require( totalSupply(id)+q < supply[id], "Sold Out" );
1219 
1220         _burn(msg.sender, 1, burnQ[id]*q);
1221         _mint(msg.sender, id, q, "");
1222 
1223         burned+= (burnQ[id]*q);
1224     }
1225 
1226     function setURI(string memory newuri) public onlyOwner {
1227         baseuri = newuri;
1228     }
1229 
1230     function uri(uint256 tokenId) override public view returns (string memory) { 
1231         return string(
1232             abi.encodePacked(baseuri, Strings.toString(tokenId), ".json")
1233         );
1234     }
1235 
1236     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal override(ERC1155, ERC1155Supply){
1237         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1238     }
1239 }