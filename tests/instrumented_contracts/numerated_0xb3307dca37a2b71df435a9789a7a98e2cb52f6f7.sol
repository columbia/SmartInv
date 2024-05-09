1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.8.0;
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
27  * @dev Implementation of the {IERC165} interface.
28  *
29  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
30  * for the additional interface id that will be supported. For example:
31  *
32  * ```solidity
33  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
34  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
35  * }
36  * ```
37  *
38  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
39  */
40 abstract contract ERC165 is IERC165 {
41     /**
42      * @dev See {IERC165-supportsInterface}.
43      */
44     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45         return interfaceId == type(IERC165).interfaceId;
46     }
47 }
48 
49 /*
50  * @dev Provides information about the current execution context, including the
51  * sender of the transaction and its data. While these are generally available
52  * via msg.sender and msg.data, they should not be accessed in such a direct
53  * manner, since when dealing with meta-transactions the account sending and
54  * paying for execution may not be the actual sender (as far as an application
55  * is concerned).
56  *
57  * This contract is only required for intermediate, library-like contracts.
58  */
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view virtual returns (bytes calldata) {
65         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
66         return msg.data;
67     }
68 }
69 
70 /**
71  * @dev Collection of functions related to the address type
72  */
73 library Address {
74     /**
75      * @dev Returns true if `account` is a contract.
76      *
77      * [IMPORTANT]
78      * ====
79      * It is unsafe to assume that an address for which this function returns
80      * false is an externally-owned account (EOA) and not a contract.
81      *
82      * Among others, `isContract` will return false for the following
83      * types of addresses:
84      *
85      *  - an externally-owned account
86      *  - a contract in construction
87      *  - an address where a contract will be created
88      *  - an address where a contract lived, but was destroyed
89      * ====
90      */
91     function isContract(address account) internal view returns (bool) {
92         // This method relies on extcodesize, which returns 0 for contracts in
93         // construction, since the code is only stored at the end of the
94         // constructor execution.
95 
96         uint256 size;
97         // solhint-disable-next-line no-inline-assembly
98         assembly { size := extcodesize(account) }
99         return size > 0;
100     }
101 
102     /**
103      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
104      * `recipient`, forwarding all available gas and reverting on errors.
105      *
106      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
107      * of certain opcodes, possibly making contracts go over the 2300 gas limit
108      * imposed by `transfer`, making them unable to receive funds via
109      * `transfer`. {sendValue} removes this limitation.
110      *
111      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
112      *
113      * IMPORTANT: because control is transferred to `recipient`, care must be
114      * taken to not create reentrancy vulnerabilities. Consider using
115      * {ReentrancyGuard} or the
116      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
117      */
118     function sendValue(address payable recipient, uint256 amount) internal {
119         require(address(this).balance >= amount, "Address: insufficient balance");
120 
121         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
122         (bool success, ) = recipient.call{ value: amount }("");
123         require(success, "Address: unable to send value, recipient may have reverted");
124     }
125 
126     /**
127      * @dev Performs a Solidity function call using a low level `call`. A
128      * plain`call` is an unsafe replacement for a function call: use this
129      * function instead.
130      *
131      * If `target` reverts with a revert reason, it is bubbled up by this
132      * function (like regular Solidity function calls).
133      *
134      * Returns the raw returned data. To convert to the expected return value,
135      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
136      *
137      * Requirements:
138      *
139      * - `target` must be a contract.
140      * - calling `target` with `data` must not revert.
141      *
142      * _Available since v3.1._
143      */
144     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
145       return functionCall(target, data, "Address: low-level call failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
150      * `errorMessage` as a fallback revert reason when `target` reverts.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
155         return functionCallWithValue(target, data, 0, errorMessage);
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
160      * but also transferring `value` wei to `target`.
161      *
162      * Requirements:
163      *
164      * - the calling contract must have an ETH balance of at least `value`.
165      * - the called Solidity function must be `payable`.
166      *
167      * _Available since v3.1._
168      */
169     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
175      * with `errorMessage` as a fallback revert reason when `target` reverts.
176      *
177      * _Available since v3.1._
178      */
179     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
180         require(address(this).balance >= value, "Address: insufficient balance for call");
181         require(isContract(target), "Address: call to non-contract");
182 
183         // solhint-disable-next-line avoid-low-level-calls
184         (bool success, bytes memory returndata) = target.call{ value: value }(data);
185         return _verifyCallResult(success, returndata, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
190      * but performing a static call.
191      *
192      * _Available since v3.3._
193      */
194     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
195         return functionStaticCall(target, data, "Address: low-level static call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
200      * but performing a static call.
201      *
202      * _Available since v3.3._
203      */
204     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
205         require(isContract(target), "Address: static call to non-contract");
206 
207         // solhint-disable-next-line avoid-low-level-calls
208         (bool success, bytes memory returndata) = target.staticcall(data);
209         return _verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but performing a delegate call.
215      *
216      * _Available since v3.4._
217      */
218     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
224      * but performing a delegate call.
225      *
226      * _Available since v3.4._
227      */
228     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
229         require(isContract(target), "Address: delegate call to non-contract");
230 
231         // solhint-disable-next-line avoid-low-level-calls
232         (bool success, bytes memory returndata) = target.delegatecall(data);
233         return _verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
237         if (success) {
238             return returndata;
239         } else {
240             // Look for revert reason and bubble it up if present
241             if (returndata.length > 0) {
242                 // The easiest way to bubble the revert reason is using memory via assembly
243 
244                 // solhint-disable-next-line no-inline-assembly
245                 assembly {
246                     let returndata_size := mload(returndata)
247                     revert(add(32, returndata), returndata_size)
248                 }
249             } else {
250                 revert(errorMessage);
251             }
252         }
253     }
254 }
255 
256 /**
257  * @dev Required interface of an ERC1155 compliant contract, as defined in the
258  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
259  *
260  * _Available since v3.1._
261  */
262 interface IERC1155 is IERC165 {
263     /**
264      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
265      */
266     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
267 
268     /**
269      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
270      * transfers.
271      */
272     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
273 
274     /**
275      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
276      * `approved`.
277      */
278     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
279 
280     /**
281      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
282      *
283      * If an {URI} event was emitted for `id`, the standard
284      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
285      * returned by {IERC1155MetadataURI-uri}.
286      */
287     event URI(string value, uint256 indexed id);
288 
289     /**
290      * @dev Returns the amount of tokens of token type `id` owned by `account`.
291      *
292      * Requirements:
293      *
294      * - `account` cannot be the zero address.
295      */
296     function balanceOf(address account, uint256 id) external view returns (uint256);
297 
298     /**
299      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
300      *
301      * Requirements:
302      *
303      * - `accounts` and `ids` must have the same length.
304      */
305     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
306 
307     /**
308      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
309      *
310      * Emits an {ApprovalForAll} event.
311      *
312      * Requirements:
313      *
314      * - `operator` cannot be the caller.
315      */
316     function setApprovalForAll(address operator, bool approved) external;
317 
318     /**
319      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
320      *
321      * See {setApprovalForAll}.
322      */
323     function isApprovedForAll(address account, address operator) external view returns (bool);
324 
325     /**
326      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
327      *
328      * Emits a {TransferSingle} event.
329      *
330      * Requirements:
331      *
332      * - `to` cannot be the zero address.
333      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
334      * - `from` must have a balance of tokens of type `id` of at least `amount`.
335      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
336      * acceptance magic value.
337      */
338     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
339 
340     /**
341      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
342      *
343      * Emits a {TransferBatch} event.
344      *
345      * Requirements:
346      *
347      * - `ids` and `amounts` must have the same length.
348      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
349      * acceptance magic value.
350      */
351     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
352 }
353 
354 /**
355  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
356  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
357  *
358  * _Available since v3.1._
359  */
360 interface IERC1155MetadataURI is IERC1155 {
361     /**
362      * @dev Returns the URI for token type `id`.
363      *
364      * If the `\{id\}` substring is present in the URI, it must be replaced by
365      * clients with the actual token type ID.
366      */
367     function uri(uint256 id) external view returns (string memory);
368 }
369 
370 /**
371  * _Available since v3.1._
372  */
373 interface IERC1155Receiver is IERC165 {
374 
375     /**
376         @dev Handles the receipt of a single ERC1155 token type. This function is
377         called at the end of a `safeTransferFrom` after the balance has been updated.
378         To accept the transfer, this must return
379         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
380         (i.e. 0xf23a6e61, or its own function selector).
381         @param operator The address which initiated the transfer (i.e. msg.sender)
382         @param from The address which previously owned the token
383         @param id The ID of the token being transferred
384         @param value The amount of tokens being transferred
385         @param data Additional data with no specified format
386         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
387     */
388     function onERC1155Received(
389         address operator,
390         address from,
391         uint256 id,
392         uint256 value,
393         bytes calldata data
394     )
395         external
396         returns(bytes4);
397 
398     /**
399         @dev Handles the receipt of a multiple ERC1155 token types. This function
400         is called at the end of a `safeBatchTransferFrom` after the balances have
401         been updated. To accept the transfer(s), this must return
402         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
403         (i.e. 0xbc197c81, or its own function selector).
404         @param operator The address which initiated the batch transfer (i.e. msg.sender)
405         @param from The address which previously owned the token
406         @param ids An array containing ids of each token being transferred (order and length must match values array)
407         @param values An array containing amounts of each token being transferred (order and length must match ids array)
408         @param data Additional data with no specified format
409         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
410     */
411     function onERC1155BatchReceived(
412         address operator,
413         address from,
414         uint256[] calldata ids,
415         uint256[] calldata values,
416         bytes calldata data
417     )
418         external
419         returns(bytes4);
420 }
421 
422 /**
423  * @dev String operations.
424  */
425 library Strings {
426     bytes16 private constant alphabet = "0123456789abcdef";
427 
428     /**
429      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
430      */
431     function toString(uint256 value) internal pure returns (string memory) {
432         // Inspired by OraclizeAPI's implementation - MIT licence
433         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
434 
435         if (value == 0) {
436             return "0";
437         }
438         uint256 temp = value;
439         uint256 digits;
440         while (temp != 0) {
441             digits++;
442             temp /= 10;
443         }
444         bytes memory buffer = new bytes(digits);
445         while (value != 0) {
446             digits -= 1;
447             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
448             value /= 10;
449         }
450         return string(buffer);
451     }
452 
453     /**
454      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
455      */
456     function toHexString(uint256 value) internal pure returns (string memory) {
457         if (value == 0) {
458             return "0x00";
459         }
460         uint256 temp = value;
461         uint256 length = 0;
462         while (temp != 0) {
463             length++;
464             temp >>= 8;
465         }
466         return toHexString(value, length);
467     }
468 
469     /**
470      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
471      */
472     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
473         bytes memory buffer = new bytes(2 * length + 2);
474         buffer[0] = "0";
475         buffer[1] = "x";
476         for (uint256 i = 2 * length + 1; i > 1; --i) {
477             buffer[i] = alphabet[value & 0xf];
478             value >>= 4;
479         }
480         require(value == 0, "Strings: hex length insufficient");
481         return string(buffer);
482     }
483 
484 }
485 
486 /**
487  *
488  * @dev Implementation of the basic standard multi-token.
489  * See https://eips.ethereum.org/EIPS/eip-1155
490  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
491  *
492  * _Available since v3.1._
493  */
494 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
495     using Address for address;
496     using Strings for uint256;
497 
498     // Mapping from token ID to account balances
499     mapping (uint256 => mapping(address => uint256)) private _balances;
500 
501     // Mapping from account to operator approvals
502     mapping (address => mapping(address => bool)) private _operatorApprovals;
503 
504     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
505     string internal _uri;
506 
507     /**
508      * @dev See {_setURI}.
509      */
510     constructor (string memory uri_) {
511         _setURI(uri_);
512     }
513     
514     /**
515      * @dev See {IERC165-supportsInterface}.
516      */
517     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
518         return interfaceId == type(IERC1155).interfaceId
519             || interfaceId == type(IERC1155MetadataURI).interfaceId
520             || super.supportsInterface(interfaceId);
521     }
522 
523     /**
524      * @dev See {IERC1155MetadataURI-uri}.
525      *
526      * This implementation returns the same URI for *all* token types. It relies
527      * on the token type ID substitution mechanism
528      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
529      *
530      * Clients calling this function must replace the `\{id\}` substring with the
531      * actual token type ID.
532      */
533     function uri(uint256 tokenId) external view virtual override returns (string memory) {
534         return bytes(_uri).length > 0
535             ? string(abi.encodePacked(_uri, tokenId.toString()))
536             : '';
537     }
538 
539     /**
540      * @dev See {IERC1155-balanceOf}.
541      *
542      * Requirements:
543      *
544      * - `account` cannot be the zero address.
545      */
546     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
547         require(account != address(0), "ERC1155: balance query for the zero address");
548         return _balances[id][account];
549     }
550 
551     /**
552      * @dev See {IERC1155-balanceOfBatch}.
553      *
554      * Requirements:
555      *
556      * - `accounts` and `ids` must have the same length.
557      */
558     function balanceOfBatch(
559         address[] memory accounts,
560         uint256[] memory ids
561     )
562         public
563         view
564         virtual
565         override
566         returns (uint256[] memory)
567     {
568         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
569 
570         uint256[] memory batchBalances = new uint256[](accounts.length);
571 
572         for (uint256 i = 0; i < accounts.length; ++i) {
573             batchBalances[i] = balanceOf(accounts[i], ids[i]);
574         }
575 
576         return batchBalances;
577     }
578 
579     /**
580      * @dev See {IERC1155-setApprovalForAll}.
581      */
582     function setApprovalForAll(address operator, bool approved) public virtual override {
583         require(_msgSender() != operator, "ERC1155: setting approval status for self");
584 
585         _operatorApprovals[_msgSender()][operator] = approved;
586         emit ApprovalForAll(_msgSender(), operator, approved);
587     }
588 
589     /**
590      * @dev See {IERC1155-isApprovedForAll}.
591      */
592     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
593         return _operatorApprovals[account][operator];
594     }
595 
596     /**
597      * @dev See {IERC1155-safeTransferFrom}.
598      */
599     function safeTransferFrom(
600         address from,
601         address to,
602         uint256 id,
603         uint256 amount,
604         bytes memory data
605     )
606         public
607         override
608     {
609         require(to != address(0), "ERC1155: transfer to the zero address");
610         require(
611             from == _msgSender() || isApprovedForAll(from, _msgSender()),
612             "ERC1155: caller is not owner nor approved"
613         );
614 
615         address operator = _msgSender();
616 
617         uint256 fromBalance = _balances[id][from];
618         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
619         _balances[id][from] = fromBalance - amount;
620         _balances[id][to] += amount;
621 
622         emit TransferSingle(operator, from, to, id, amount);
623 
624         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
625     }
626 
627     /**
628      * @dev See {IERC1155-safeBatchTransferFrom}.
629      */
630     function safeBatchTransferFrom(
631         address from,
632         address to,
633         uint256[] memory ids,
634         uint256[] memory amounts,
635         bytes memory data
636     )
637         public
638         override
639     {
640         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
641         require(to != address(0), "ERC1155: transfer to the zero address");
642         require(
643             from == _msgSender() || isApprovedForAll(from, _msgSender()),
644             "ERC1155: transfer caller is not owner nor approved"
645         );
646 
647         address operator = _msgSender();
648 
649         for (uint256 i = 0; i < ids.length; ++i) {
650             uint256 id = ids[i];
651             uint256 amount = amounts[i];
652 
653             uint256 fromBalance = _balances[id][from];
654             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
655             _balances[id][from] = fromBalance - amount;
656             _balances[id][to] += amount;
657         }
658 
659         emit TransferBatch(operator, from, to, ids, amounts);
660 
661         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
662     }
663 
664     /**
665      * @dev Sets a new URI for all token types, by relying on the token type ID
666      * substitution mechanism
667      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
668      *
669      * By this mechanism, any occurrence of the `\{id\}` substring in either the
670      * URI or any of the amounts in the JSON file at said URI will be replaced by
671      * clients with the token type ID.
672      *
673      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
674      * interpreted by clients as
675      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
676      * for token type ID 0x4cce0.
677      *
678      * See {uri}.
679      *
680      * Because these URIs cannot be meaningfully represented by the {URI} event,
681      * this function emits no events.
682      */
683     function _setURI(string memory newuri) internal virtual {
684         _uri = newuri;
685     }
686 
687     /**
688      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
689      *
690      * Emits a {TransferSingle} event.
691      *
692      * Requirements:
693      *
694      * - `account` cannot be the zero address.
695      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
696      * acceptance magic value.
697      */
698     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
699         require(account != address(0), "ERC1155: mint to the zero address");
700 
701         address operator = _msgSender();
702 
703         _balances[id][account] += amount;
704         emit TransferSingle(operator, address(0), account, id, amount);
705 
706         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
707     }
708 
709     /**
710      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
711      *
712      * Requirements:
713      *
714      * - `ids` and `amounts` must have the same length.
715      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
716      * acceptance magic value.
717      */
718     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
719         require(to != address(0), "ERC1155: mint to the zero address");
720         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
721 
722         address operator = _msgSender();
723 
724         for (uint i = 0; i < ids.length; i++) {
725             _balances[ids[i]][to] += amounts[i];
726         }
727 
728         emit TransferBatch(operator, address(0), to, ids, amounts);
729 
730         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
731     }
732 
733     /**
734      * @dev Destroys `amount` tokens of token type `id` from `account`
735      *
736      * Requirements:
737      *
738      * - `account` cannot be the zero address.
739      * - `account` must have at least `amount` tokens of token type `id`.
740      */
741     function _burn(address account, uint256 id, uint256 amount) internal virtual {
742         require(account != address(0), "ERC1155: burn from the zero address");
743 
744         address operator = _msgSender();
745 
746         uint256 accountBalance = _balances[id][account];
747         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
748         _balances[id][account] = accountBalance - amount;
749 
750         emit TransferSingle(operator, account, address(0), id, amount);
751     }
752 
753     /**
754      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
755      *
756      * Requirements:
757      *
758      * - `ids` and `amounts` must have the same length.
759      */
760     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
761         require(account != address(0), "ERC1155: burn from the zero address");
762         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
763 
764         address operator = _msgSender();
765 
766         for (uint i = 0; i < ids.length; i++) {
767             uint256 id = ids[i];
768             uint256 amount = amounts[i];
769 
770             uint256 accountBalance = _balances[id][account];
771             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
772             _balances[id][account] = accountBalance - amount;
773         }
774 
775         emit TransferBatch(operator, account, address(0), ids, amounts);
776     }
777 
778     /**
779      * @dev Hook that is called before any token transfer. This includes minting
780      * and burning, as well as batched variants.
781      *
782      * The same hook is called on both single and batched variants. For single
783      * transfers, the length of the `id` and `amount` arrays will be 1.
784      *
785      * Calling conditions (for each `id` and `amount` pair):
786      *
787      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
788      * of token type `id` will be  transferred to `to`.
789      * - When `from` is zero, `amount` tokens of token type `id` will be minted
790      * for `to`.
791      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
792      * will be burned.
793      * - `from` and `to` are never both zero.
794      * - `ids` and `amounts` have the same, non-zero length.
795      *
796      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
797      */
798 
799     function _doSafeTransferAcceptanceCheck(
800         address operator,
801         address from,
802         address to,
803         uint256 id,
804         uint256 amount,
805         bytes memory data
806     )
807         private
808     {
809         if (to.isContract()) {
810             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
811                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
812                     revert("ERC1155: ERC1155Receiver rejected tokens");
813                 }
814             } catch Error(string memory reason) {
815                 revert(reason);
816             } catch {
817                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
818             }
819         }
820     }
821 
822     function _doSafeBatchTransferAcceptanceCheck(
823         address operator,
824         address from,
825         address to,
826         uint256[] memory ids,
827         uint256[] memory amounts,
828         bytes memory data
829     )
830         private
831     {
832         if (to.isContract()) {
833             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
834                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
835                     revert("ERC1155: ERC1155Receiver rejected tokens");
836                 }
837             } catch Error(string memory reason) {
838                 revert(reason);
839             } catch {
840                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
841             }
842         }
843     }
844 
845     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
846         uint256[] memory array = new uint256[](1);
847         array[0] = element;
848 
849         return array;
850     }
851 }
852 
853 /**
854  * @dev Contract module which provides a basic access control mechanism, where
855  * there is an account (an owner) that can be granted exclusive access to
856  * specific functions.
857  *
858  * By default, the owner account will be the one that deploys the contract. This
859  * can later be changed with {transferOwnership}.
860  *
861  * This module is used through inheritance. It will make available the modifier
862  * `onlyOwner`, which can be applied to your functions to restrict their use to
863  * the owner.
864  */
865 abstract contract Ownable is Context {
866     address private _owner;
867 
868     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
869 
870     /**
871      * @dev Initializes the contract setting the deployer as the initial owner.
872      */
873     constructor () {
874         address msgSender = _msgSender();
875         _owner = msgSender;
876         emit OwnershipTransferred(address(0), msgSender);
877     }
878 
879     /**
880      * @dev Returns the address of the current owner.
881      */
882     function owner() public view virtual returns (address) {
883         return _owner;
884     }
885 
886     /**
887      * @dev Throws if called by any account other than the owner.
888      */
889     modifier onlyOwner() {
890         require(owner() == _msgSender(), "Ownable: caller is not the owner");
891         _;
892     }
893 
894     /**
895      * @dev Leaves the contract without owner. It will not be possible to call
896      * `onlyOwner` functions anymore. Can only be called by the current owner.
897      *
898      * NOTE: Renouncing ownership will leave the contract without an owner,
899      * thereby removing any functionality that is only available to the owner.
900      */
901     function renounceOwnership() public virtual onlyOwner {
902         emit OwnershipTransferred(_owner, address(0));
903         _owner = address(0);
904     }
905 
906     /**
907      * @dev Transfers ownership of the contract to a new account (`newOwner`).
908      * Can only be called by the current owner.
909      */
910     function transferOwnership(address newOwner) public virtual onlyOwner {
911         require(newOwner != address(0), "Ownable: new owner is the zero address");
912         emit OwnershipTransferred(_owner, newOwner);
913         _owner = newOwner;
914     }
915 }
916 
917 abstract contract Random {
918     
919     function generate(address sender) internal view returns (uint256) {
920         return uint(keccak256(abi.encodePacked(sender, block.difficulty, block.timestamp, blockhash(block.number))));
921     }
922 }
923 
924 contract HypeArt is ERC1155, Ownable, Random {
925 
926     constructor (string memory _uri) ERC1155(_uri) {}
927     
928     uint16 totalMinted;
929     uint16 maxMinted = 2008;
930     
931     function mintRandom() external {
932         require(totalMinted < maxMinted, "Max token amount has been reached");
933         totalMinted += 1;
934         
935         uint256 probability = generate(msg.sender) % 100;
936         uint256 id;
937         if (probability >= 51 && probability <= 77) {
938             id = 1;
939         }
940         if (probability >= 78 && probability <= 96) {
941             id = 2;
942         }
943         if (probability >= 97 && probability <= 99) {
944             id = 3;
945         }
946         
947         bytes memory data;
948         _mint(msg.sender, id, 1, data);
949     }
950 
951     function setBaseURI(string memory _uri) external onlyOwner{
952         _setURI(_uri);
953     }
954 }