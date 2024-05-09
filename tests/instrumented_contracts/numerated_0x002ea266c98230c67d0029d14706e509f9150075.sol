1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/utils/Address.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
32 
33 pragma solidity ^0.8.1;
34 
35 /**
36  * @dev Collection of functions related to the address type
37  */
38 library Address {
39     /**
40      * @dev Returns true if `account` is a contract.
41      *
42      * [IMPORTANT]
43      * ====
44      * It is unsafe to assume that an address for which this function returns
45      * false is an externally-owned account (EOA) and not a contract.
46      *
47      * Among others, `isContract` will return false for the following
48      * types of addresses:
49      *
50      *  - an externally-owned account
51      *  - a contract in construction
52      *  - an address where a contract will be created
53      *  - an address where a contract lived, but was destroyed
54      * ====
55      *
56      * [IMPORTANT]
57      * ====
58      * You shouldn't rely on `isContract` to protect against flash loan attacks!
59      *
60      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
61      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
62      * constructor.
63      * ====
64      */
65     function isContract(address account) internal view returns (bool) {
66         // This method relies on extcodesize/address.code.length, which returns 0
67         // for contracts in construction, since the code is only stored at the end
68         // of the constructor execution.
69 
70         return account.code.length > 0;
71     }
72 
73     /**
74      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
75      * `recipient`, forwarding all available gas and reverting on errors.
76      *
77      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
78      * of certain opcodes, possibly making contracts go over the 2300 gas limit
79      * imposed by `transfer`, making them unable to receive funds via
80      * `transfer`. {sendValue} removes this limitation.
81      *
82      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
83      *
84      * IMPORTANT: because control is transferred to `recipient`, care must be
85      * taken to not create reentrancy vulnerabilities. Consider using
86      * {ReentrancyGuard} or the
87      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
88      */
89     function sendValue(address payable recipient, uint256 amount) internal {
90         require(address(this).balance >= amount, "Address: insufficient balance");
91 
92         (bool success, ) = recipient.call{value: amount}("");
93         require(success, "Address: unable to send value, recipient may have reverted");
94     }
95 
96     /**
97      * @dev Performs a Solidity function call using a low level `call`. A
98      * plain `call` is an unsafe replacement for a function call: use this
99      * function instead.
100      *
101      * If `target` reverts with a revert reason, it is bubbled up by this
102      * function (like regular Solidity function calls).
103      *
104      * Returns the raw returned data. To convert to the expected return value,
105      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
106      *
107      * Requirements:
108      *
109      * - `target` must be a contract.
110      * - calling `target` with `data` must not revert.
111      *
112      * _Available since v3.1._
113      */
114     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
115         return functionCall(target, data, "Address: low-level call failed");
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
120      * `errorMessage` as a fallback revert reason when `target` reverts.
121      *
122      * _Available since v3.1._
123      */
124     function functionCall(
125         address target,
126         bytes memory data,
127         string memory errorMessage
128     ) internal returns (bytes memory) {
129         return functionCallWithValue(target, data, 0, errorMessage);
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
134      * but also transferring `value` wei to `target`.
135      *
136      * Requirements:
137      *
138      * - the calling contract must have an ETH balance of at least `value`.
139      * - the called Solidity function must be `payable`.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value
147     ) internal returns (bytes memory) {
148         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
153      * with `errorMessage` as a fallback revert reason when `target` reverts.
154      *
155      * _Available since v3.1._
156      */
157     function functionCallWithValue(
158         address target,
159         bytes memory data,
160         uint256 value,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         require(address(this).balance >= value, "Address: insufficient balance for call");
164         require(isContract(target), "Address: call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.call{value: value}(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a static call.
173      *
174      * _Available since v3.3._
175      */
176     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
177         return functionStaticCall(target, data, "Address: low-level static call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a static call.
183      *
184      * _Available since v3.3._
185      */
186     function functionStaticCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal view returns (bytes memory) {
191         require(isContract(target), "Address: static call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.staticcall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but performing a delegate call.
200      *
201      * _Available since v3.4._
202      */
203     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
209      * but performing a delegate call.
210      *
211      * _Available since v3.4._
212      */
213     function functionDelegateCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         require(isContract(target), "Address: delegate call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.delegatecall(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
226      * revert reason using the provided one.
227      *
228      * _Available since v4.3._
229      */
230     function verifyCallResult(
231         bool success,
232         bytes memory returndata,
233         string memory errorMessage
234     ) internal pure returns (bytes memory) {
235         if (success) {
236             return returndata;
237         } else {
238             // Look for revert reason and bubble it up if present
239             if (returndata.length > 0) {
240                 // The easiest way to bubble the revert reason is using memory via assembly
241 
242                 assembly {
243                     let returndata_size := mload(returndata)
244                     revert(add(32, returndata), returndata_size)
245                 }
246             } else {
247                 revert(errorMessage);
248             }
249         }
250     }
251 }
252 
253 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
254 
255 
256 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @dev Interface of the ERC165 standard, as defined in the
262  * https://eips.ethereum.org/EIPS/eip-165[EIP].
263  *
264  * Implementers can declare support of contract interfaces, which can then be
265  * queried by others ({ERC165Checker}).
266  *
267  * For an implementation, see {ERC165}.
268  */
269 interface IERC165 {
270     /**
271      * @dev Returns true if this contract implements the interface defined by
272      * `interfaceId`. See the corresponding
273      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
274      * to learn more about how these ids are created.
275      *
276      * This function call must use less than 30 000 gas.
277      */
278     function supportsInterface(bytes4 interfaceId) external view returns (bool);
279 }
280 
281 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
282 
283 
284 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
285 
286 pragma solidity ^0.8.0;
287 
288 
289 /**
290  * @dev Implementation of the {IERC165} interface.
291  *
292  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
293  * for the additional interface id that will be supported. For example:
294  *
295  * ```solidity
296  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
297  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
298  * }
299  * ```
300  *
301  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
302  */
303 abstract contract ERC165 is IERC165 {
304     /**
305      * @dev See {IERC165-supportsInterface}.
306      */
307     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
308         return interfaceId == type(IERC165).interfaceId;
309     }
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
313 
314 
315 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 
320 /**
321  * @dev _Available since v3.1._
322  */
323 interface IERC1155Receiver is IERC165 {
324     /**
325      * @dev Handles the receipt of a single ERC1155 token type. This function is
326      * called at the end of a `safeTransferFrom` after the balance has been updated.
327      *
328      * NOTE: To accept the transfer, this must return
329      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
330      * (i.e. 0xf23a6e61, or its own function selector).
331      *
332      * @param operator The address which initiated the transfer (i.e. msg.sender)
333      * @param from The address which previously owned the token
334      * @param id The ID of the token being transferred
335      * @param value The amount of tokens being transferred
336      * @param data Additional data with no specified format
337      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
338      */
339     function onERC1155Received(
340         address operator,
341         address from,
342         uint256 id,
343         uint256 value,
344         bytes calldata data
345     ) external returns (bytes4);
346 
347     /**
348      * @dev Handles the receipt of a multiple ERC1155 token types. This function
349      * is called at the end of a `safeBatchTransferFrom` after the balances have
350      * been updated.
351      *
352      * NOTE: To accept the transfer(s), this must return
353      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
354      * (i.e. 0xbc197c81, or its own function selector).
355      *
356      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
357      * @param from The address which previously owned the token
358      * @param ids An array containing ids of each token being transferred (order and length must match values array)
359      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
360      * @param data Additional data with no specified format
361      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
362      */
363     function onERC1155BatchReceived(
364         address operator,
365         address from,
366         uint256[] calldata ids,
367         uint256[] calldata values,
368         bytes calldata data
369     ) external returns (bytes4);
370 }
371 
372 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
373 
374 
375 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 
380 /**
381  * @dev Required interface of an ERC1155 compliant contract, as defined in the
382  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
383  *
384  * _Available since v3.1._
385  */
386 interface IERC1155 is IERC165 {
387     /**
388      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
389      */
390     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
391 
392     /**
393      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
394      * transfers.
395      */
396     event TransferBatch(
397         address indexed operator,
398         address indexed from,
399         address indexed to,
400         uint256[] ids,
401         uint256[] values
402     );
403 
404     /**
405      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
406      * `approved`.
407      */
408     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
409 
410     /**
411      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
412      *
413      * If an {URI} event was emitted for `id`, the standard
414      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
415      * returned by {IERC1155MetadataURI-uri}.
416      */
417     event URI(string value, uint256 indexed id);
418 
419     /**
420      * @dev Returns the amount of tokens of token type `id` owned by `account`.
421      *
422      * Requirements:
423      *
424      * - `account` cannot be the zero address.
425      */
426     function balanceOf(address account, uint256 id) external view returns (uint256);
427 
428     /**
429      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
430      *
431      * Requirements:
432      *
433      * - `accounts` and `ids` must have the same length.
434      */
435     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
436         external
437         view
438         returns (uint256[] memory);
439 
440     /**
441      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
442      *
443      * Emits an {ApprovalForAll} event.
444      *
445      * Requirements:
446      *
447      * - `operator` cannot be the caller.
448      */
449     function setApprovalForAll(address operator, bool approved) external;
450 
451     /**
452      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
453      *
454      * See {setApprovalForAll}.
455      */
456     function isApprovedForAll(address account, address operator) external view returns (bool);
457 
458     /**
459      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
460      *
461      * Emits a {TransferSingle} event.
462      *
463      * Requirements:
464      *
465      * - `to` cannot be the zero address.
466      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
467      * - `from` must have a balance of tokens of type `id` of at least `amount`.
468      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
469      * acceptance magic value.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 id,
475         uint256 amount,
476         bytes calldata data
477     ) external;
478 
479     /**
480      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
481      *
482      * Emits a {TransferBatch} event.
483      *
484      * Requirements:
485      *
486      * - `ids` and `amounts` must have the same length.
487      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
488      * acceptance magic value.
489      */
490     function safeBatchTransferFrom(
491         address from,
492         address to,
493         uint256[] calldata ids,
494         uint256[] calldata amounts,
495         bytes calldata data
496     ) external;
497 }
498 
499 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
500 
501 
502 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 
507 /**
508  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
509  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
510  *
511  * _Available since v3.1._
512  */
513 interface IERC1155MetadataURI is IERC1155 {
514     /**
515      * @dev Returns the URI for token type `id`.
516      *
517      * If the `\{id\}` substring is present in the URI, it must be replaced by
518      * clients with the actual token type ID.
519      */
520     function uri(uint256 id) external view returns (string memory);
521 }
522 
523 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
524 
525 
526 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 
531 
532 
533 
534 
535 
536 /**
537  * @dev Implementation of the basic standard multi-token.
538  * See https://eips.ethereum.org/EIPS/eip-1155
539  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
540  *
541  * _Available since v3.1._
542  */
543 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
544     using Address for address;
545 
546     // Mapping from token ID to account balances
547     mapping(uint256 => mapping(address => uint256)) private _balances;
548 
549     // Mapping from account to operator approvals
550     mapping(address => mapping(address => bool)) private _operatorApprovals;
551 
552     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
553     string private _uri;
554 
555     /**
556      * @dev See {_setURI}.
557      */
558     constructor(string memory uri_) {
559         _setURI(uri_);
560     }
561 
562     /**
563      * @dev See {IERC165-supportsInterface}.
564      */
565     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
566         return
567             interfaceId == type(IERC1155).interfaceId ||
568             interfaceId == type(IERC1155MetadataURI).interfaceId ||
569             super.supportsInterface(interfaceId);
570     }
571 
572     /**
573      * @dev See {IERC1155MetadataURI-uri}.
574      *
575      * This implementation returns the same URI for *all* token types. It relies
576      * on the token type ID substitution mechanism
577      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
578      *
579      * Clients calling this function must replace the `\{id\}` substring with the
580      * actual token type ID.
581      */
582     function uri(uint256) public view virtual override returns (string memory) {
583         return _uri;
584     }
585 
586     /**
587      * @dev See {IERC1155-balanceOf}.
588      *
589      * Requirements:
590      *
591      * - `account` cannot be the zero address.
592      */
593     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
594         require(account != address(0), "ERC1155: address zero is not a valid owner");
595         return _balances[id][account];
596     }
597 
598     /**
599      * @dev See {IERC1155-balanceOfBatch}.
600      *
601      * Requirements:
602      *
603      * - `accounts` and `ids` must have the same length.
604      */
605     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
606         public
607         view
608         virtual
609         override
610         returns (uint256[] memory)
611     {
612         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
613 
614         uint256[] memory batchBalances = new uint256[](accounts.length);
615 
616         for (uint256 i = 0; i < accounts.length; ++i) {
617             batchBalances[i] = balanceOf(accounts[i], ids[i]);
618         }
619 
620         return batchBalances;
621     }
622 
623     /**
624      * @dev See {IERC1155-setApprovalForAll}.
625      */
626     function setApprovalForAll(address operator, bool approved) public virtual override {
627         _setApprovalForAll(_msgSender(), operator, approved);
628     }
629 
630     /**
631      * @dev See {IERC1155-isApprovedForAll}.
632      */
633     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
634         return _operatorApprovals[account][operator];
635     }
636 
637     /**
638      * @dev See {IERC1155-safeTransferFrom}.
639      */
640     function safeTransferFrom(
641         address from,
642         address to,
643         uint256 id,
644         uint256 amount,
645         bytes memory data
646     ) public virtual override {
647         require(
648             from == _msgSender() || isApprovedForAll(from, _msgSender()),
649             "ERC1155: caller is not token owner nor approved"
650         );
651         _safeTransferFrom(from, to, id, amount, data);
652     }
653 
654     /**
655      * @dev See {IERC1155-safeBatchTransferFrom}.
656      */
657     function safeBatchTransferFrom(
658         address from,
659         address to,
660         uint256[] memory ids,
661         uint256[] memory amounts,
662         bytes memory data
663     ) public virtual override {
664         require(
665             from == _msgSender() || isApprovedForAll(from, _msgSender()),
666             "ERC1155: caller is not token owner nor approved"
667         );
668         _safeBatchTransferFrom(from, to, ids, amounts, data);
669     }
670 
671     /**
672      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
673      *
674      * Emits a {TransferSingle} event.
675      *
676      * Requirements:
677      *
678      * - `to` cannot be the zero address.
679      * - `from` must have a balance of tokens of type `id` of at least `amount`.
680      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
681      * acceptance magic value.
682      */
683     function _safeTransferFrom(
684         address from,
685         address to,
686         uint256 id,
687         uint256 amount,
688         bytes memory data
689     ) internal virtual {
690         require(to != address(0), "ERC1155: transfer to the zero address");
691 
692         address operator = _msgSender();
693         uint256[] memory ids = _asSingletonArray(id);
694         uint256[] memory amounts = _asSingletonArray(amount);
695 
696         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
697 
698         uint256 fromBalance = _balances[id][from];
699         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
700         unchecked {
701             _balances[id][from] = fromBalance - amount;
702         }
703         _balances[id][to] += amount;
704 
705         emit TransferSingle(operator, from, to, id, amount);
706 
707         _afterTokenTransfer(operator, from, to, ids, amounts, data);
708 
709         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
710     }
711 
712     /**
713      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
714      *
715      * Emits a {TransferBatch} event.
716      *
717      * Requirements:
718      *
719      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
720      * acceptance magic value.
721      */
722     function _safeBatchTransferFrom(
723         address from,
724         address to,
725         uint256[] memory ids,
726         uint256[] memory amounts,
727         bytes memory data
728     ) internal virtual {
729         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
730         require(to != address(0), "ERC1155: transfer to the zero address");
731 
732         address operator = _msgSender();
733 
734         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
735 
736         for (uint256 i = 0; i < ids.length; ++i) {
737             uint256 id = ids[i];
738             uint256 amount = amounts[i];
739 
740             uint256 fromBalance = _balances[id][from];
741             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
742             unchecked {
743                 _balances[id][from] = fromBalance - amount;
744             }
745             _balances[id][to] += amount;
746         }
747 
748         emit TransferBatch(operator, from, to, ids, amounts);
749 
750         _afterTokenTransfer(operator, from, to, ids, amounts, data);
751 
752         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
753     }
754 
755     /**
756      * @dev Sets a new URI for all token types, by relying on the token type ID
757      * substitution mechanism
758      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
759      *
760      * By this mechanism, any occurrence of the `\{id\}` substring in either the
761      * URI or any of the amounts in the JSON file at said URI will be replaced by
762      * clients with the token type ID.
763      *
764      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
765      * interpreted by clients as
766      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
767      * for token type ID 0x4cce0.
768      *
769      * See {uri}.
770      *
771      * Because these URIs cannot be meaningfully represented by the {URI} event,
772      * this function emits no events.
773      */
774     function _setURI(string memory newuri) internal virtual {
775         _uri = newuri;
776     }
777 
778     /**
779      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
780      *
781      * Emits a {TransferSingle} event.
782      *
783      * Requirements:
784      *
785      * - `to` cannot be the zero address.
786      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
787      * acceptance magic value.
788      */
789     function _mint(
790         address to,
791         uint256 id,
792         uint256 amount,
793         bytes memory data
794     ) internal virtual {
795         require(to != address(0), "ERC1155: mint to the zero address");
796 
797         address operator = _msgSender();
798         uint256[] memory ids = _asSingletonArray(id);
799         uint256[] memory amounts = _asSingletonArray(amount);
800 
801         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
802 
803         _balances[id][to] += amount;
804         emit TransferSingle(operator, address(0), to, id, amount);
805 
806         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
807 
808         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
809     }
810 
811     /**
812      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
813      *
814      * Emits a {TransferBatch} event.
815      *
816      * Requirements:
817      *
818      * - `ids` and `amounts` must have the same length.
819      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
820      * acceptance magic value.
821      */
822     function _mintBatch(
823         address to,
824         uint256[] memory ids,
825         uint256[] memory amounts,
826         bytes memory data
827     ) internal virtual {
828         require(to != address(0), "ERC1155: mint to the zero address");
829         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
830 
831         address operator = _msgSender();
832 
833         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
834 
835         for (uint256 i = 0; i < ids.length; i++) {
836             _balances[ids[i]][to] += amounts[i];
837         }
838 
839         emit TransferBatch(operator, address(0), to, ids, amounts);
840 
841         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
842 
843         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
844     }
845 
846     /**
847      * @dev Destroys `amount` tokens of token type `id` from `from`
848      *
849      * Emits a {TransferSingle} event.
850      *
851      * Requirements:
852      *
853      * - `from` cannot be the zero address.
854      * - `from` must have at least `amount` tokens of token type `id`.
855      */
856     function _burn(
857         address from,
858         uint256 id,
859         uint256 amount
860     ) internal virtual {
861         require(from != address(0), "ERC1155: burn from the zero address");
862 
863         address operator = _msgSender();
864         uint256[] memory ids = _asSingletonArray(id);
865         uint256[] memory amounts = _asSingletonArray(amount);
866 
867         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
868 
869         uint256 fromBalance = _balances[id][from];
870         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
871         unchecked {
872             _balances[id][from] = fromBalance - amount;
873         }
874 
875         emit TransferSingle(operator, from, address(0), id, amount);
876 
877         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
878     }
879 
880     /**
881      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
882      *
883      * Emits a {TransferBatch} event.
884      *
885      * Requirements:
886      *
887      * - `ids` and `amounts` must have the same length.
888      */
889     function _burnBatch(
890         address from,
891         uint256[] memory ids,
892         uint256[] memory amounts
893     ) internal virtual {
894         require(from != address(0), "ERC1155: burn from the zero address");
895         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
896 
897         address operator = _msgSender();
898 
899         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
900 
901         for (uint256 i = 0; i < ids.length; i++) {
902             uint256 id = ids[i];
903             uint256 amount = amounts[i];
904 
905             uint256 fromBalance = _balances[id][from];
906             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
907             unchecked {
908                 _balances[id][from] = fromBalance - amount;
909             }
910         }
911 
912         emit TransferBatch(operator, from, address(0), ids, amounts);
913 
914         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
915     }
916 
917     /**
918      * @dev Approve `operator` to operate on all of `owner` tokens
919      *
920      * Emits an {ApprovalForAll} event.
921      */
922     function _setApprovalForAll(
923         address owner,
924         address operator,
925         bool approved
926     ) internal virtual {
927         require(owner != operator, "ERC1155: setting approval status for self");
928         _operatorApprovals[owner][operator] = approved;
929         emit ApprovalForAll(owner, operator, approved);
930     }
931 
932     /**
933      * @dev Hook that is called before any token transfer. This includes minting
934      * and burning, as well as batched variants.
935      *
936      * The same hook is called on both single and batched variants. For single
937      * transfers, the length of the `ids` and `amounts` arrays will be 1.
938      *
939      * Calling conditions (for each `id` and `amount` pair):
940      *
941      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
942      * of token type `id` will be  transferred to `to`.
943      * - When `from` is zero, `amount` tokens of token type `id` will be minted
944      * for `to`.
945      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
946      * will be burned.
947      * - `from` and `to` are never both zero.
948      * - `ids` and `amounts` have the same, non-zero length.
949      *
950      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
951      */
952     function _beforeTokenTransfer(
953         address operator,
954         address from,
955         address to,
956         uint256[] memory ids,
957         uint256[] memory amounts,
958         bytes memory data
959     ) internal virtual {}
960 
961     /**
962      * @dev Hook that is called after any token transfer. This includes minting
963      * and burning, as well as batched variants.
964      *
965      * The same hook is called on both single and batched variants. For single
966      * transfers, the length of the `id` and `amount` arrays will be 1.
967      *
968      * Calling conditions (for each `id` and `amount` pair):
969      *
970      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
971      * of token type `id` will be  transferred to `to`.
972      * - When `from` is zero, `amount` tokens of token type `id` will be minted
973      * for `to`.
974      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
975      * will be burned.
976      * - `from` and `to` are never both zero.
977      * - `ids` and `amounts` have the same, non-zero length.
978      *
979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
980      */
981     function _afterTokenTransfer(
982         address operator,
983         address from,
984         address to,
985         uint256[] memory ids,
986         uint256[] memory amounts,
987         bytes memory data
988     ) internal virtual {}
989 
990     function _doSafeTransferAcceptanceCheck(
991         address operator,
992         address from,
993         address to,
994         uint256 id,
995         uint256 amount,
996         bytes memory data
997     ) private {
998         if (to.isContract()) {
999             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1000                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1001                     revert("ERC1155: ERC1155Receiver rejected tokens");
1002                 }
1003             } catch Error(string memory reason) {
1004                 revert(reason);
1005             } catch {
1006                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1007             }
1008         }
1009     }
1010 
1011     function _doSafeBatchTransferAcceptanceCheck(
1012         address operator,
1013         address from,
1014         address to,
1015         uint256[] memory ids,
1016         uint256[] memory amounts,
1017         bytes memory data
1018     ) private {
1019         if (to.isContract()) {
1020             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1021                 bytes4 response
1022             ) {
1023                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1024                     revert("ERC1155: ERC1155Receiver rejected tokens");
1025                 }
1026             } catch Error(string memory reason) {
1027                 revert(reason);
1028             } catch {
1029                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1030             }
1031         }
1032     }
1033 
1034     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1035         uint256[] memory array = new uint256[](1);
1036         array[0] = element;
1037 
1038         return array;
1039     }
1040 }
1041 
1042 // File: waitara.sol
1043 
1044 
1045 pragma solidity ^0.8.4;
1046 
1047 
1048 
1049 contract waitara is ERC1155 {
1050 
1051   enum SaleStatus { CLOSED, PRESALE, PUBLIC }
1052   uint256 public premiumcost = 0.069 ether;
1053   uint256 public platinumcost = 0.45 ether;
1054   SaleStatus public saleStatus = SaleStatus.CLOSED;
1055   //0 & 1
1056   uint256[] public amountsLeft = [6900, 100];
1057   address private owner;
1058   string public name;
1059   string public symbol;
1060 
1061   mapping(address => mapping(uint256 => bool)) public mintedTier;
1062   mapping(uint => string) public tokenURI;
1063   mapping(address => bool) public presaleWallets;
1064 
1065   modifier onlyExternal() {
1066     require(msg.sender == tx.origin, "Contracts are not allowed to mint");
1067     _;
1068   }
1069 
1070   // IMPORTANT!: Set IPFS metadata URI
1071   constructor(
1072       string memory _name,
1073       string memory _symbol
1074   ) ERC1155("") {
1075     owner = msg.sender;
1076     name = _name;
1077     symbol = _symbol;
1078   }
1079 
1080   modifier onlyOwner() {
1081     require(msg.sender == owner, "You are not the owner of this contract");
1082     _;
1083   }
1084 
1085   modifier mintable(uint256 _id) {
1086     require(_id < 2, "Invalid token ID");
1087     require(amountsLeft[_id] > 0, "All tokens with this ID were already minted");
1088     _;
1089   }
1090 
1091   function mintPresale() external onlyExternal mintable(0) {
1092     require(saleStatus != SaleStatus.CLOSED, "Presale is not active");
1093     require(!mintedTier[msg.sender][0], "You already minted this token");
1094     require(presaleWallets[msg.sender]);
1095     mintedTier[msg.sender][0] = true;
1096     amountsLeft[0] -= 1;  
1097     _mint(msg.sender, 0, 1, "");
1098   }
1099 
1100   function mint(uint256 _id, uint256 _mintAmount) public onlyExternal mintable(_id) payable{
1101     require(saleStatus == SaleStatus.PUBLIC, "Sale is not active");
1102     if(_id==0){
1103         require(msg.value >= premiumcost * _mintAmount,"Not enough Gas");   
1104     }else{
1105         require(!mintedTier[msg.sender][1], "You already minted this token");
1106         require(msg.value >= platinumcost * _mintAmount,"Not enough Gas");
1107         mintedTier[msg.sender][1] = true;
1108     }
1109     amountsLeft[_id] -= _mintAmount;
1110     _mint(msg.sender, _id, _mintAmount, "");
1111   }
1112 
1113 
1114   // Private batch minting function, does not check for payment.
1115   function mintPrivate(uint256[] memory _ids, uint256[] memory _amounts) external onlyOwner {
1116     for (uint256 i = 0; i < _amounts.length; i++) {
1117       amountsLeft[i] -= _amounts[i];
1118     }
1119     _mintBatch(msg.sender, _ids, _amounts, "");
1120   }
1121 
1122     function addPresaleUser(address _user) public onlyOwner {
1123         presaleWallets[_user] = true;
1124     }
1125     
1126     function removePresaleUser(address _user) public onlyOwner {
1127         presaleWallets[_user] = false;
1128     }
1129 
1130     function add100PresaleUsers(address[] memory _users) public onlyOwner {
1131         for (uint256 i = 0; i < _users.length; i++) {
1132             presaleWallets[_users[i]] = true;
1133         }
1134     }
1135   // 0 = CLOSED; 1 = PRESALE; 2 = PUBLIC;
1136   function setSaleStatus(uint256 _status) external onlyOwner {
1137     saleStatus = SaleStatus(_status);
1138   }
1139   function setPremiumCost(uint256 _newPremiumCost) public onlyOwner {
1140         premiumcost = _newPremiumCost;
1141   }
1142   function setPlatinumCost(uint256 _newPlatinumCost) public onlyOwner {
1143         platinumcost = _newPlatinumCost;
1144   }
1145 
1146   function setURI(uint _id, string memory _uri) external onlyOwner {
1147     tokenURI[_id] = _uri;
1148     emit URI(_uri, _id);
1149   }
1150 
1151   function uri(uint _id) public override view returns (string memory) {
1152     return tokenURI[_id];
1153   }
1154 
1155   function getAmountsLeft() external view returns(uint256[] memory) {
1156     return amountsLeft;
1157   } 
1158   function withdraw() public payable onlyOwner {
1159         (bool success, ) = payable(msg.sender).call{
1160             value: address(this).balance
1161         }("");
1162         require(success);
1163     }
1164 
1165 }