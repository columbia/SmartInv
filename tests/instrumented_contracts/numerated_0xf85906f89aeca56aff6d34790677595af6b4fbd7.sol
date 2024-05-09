1 // SPDX-License-Identifier: MIT
2 /*
3    .____    .__             .__    .___
4    |    |   |__| ________ __|__| __| _/
5    |    |   |  |/ ____/  |  \  |/ __ |
6    |    |___|  < <_|  |  |  /  / /_/ |
7    |_______ \__|\__   |____/|__\____ |
8            \/      |__|             \/
9      _____          __  .__  _____               __
10     /  _  \________/  |_|__|/ ____\____    _____/  |_  ______
11    /  /_\  \_  __ \   __\  \   __\\__  \ _/ ___\   __\/  ___/
12   /    |    \  | \/|  | |  ||  |   / __ \\  \___|  |  \___ \
13   \____|__  /__|   |__| |__||__|  (____  /\___  >__| /____  >
14           \/                           \/     \/          \/
15 
16    Standing on the shoulders of giants -- Yuga Labs & MAYC
17     * Written by Aleph 0ne for the ApeLiquid community *
18 
19 */
20 
21 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.2
22 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Interface of the ERC165 standard, as defined in the
28  * https://eips.ethereum.org/EIPS/eip-165[EIP].
29  *
30  * Implementers can declare support of contract interfaces, which can then be
31  * queried by others ({ERC165Checker}).
32  *
33  * For an implementation, see {ERC165}.
34  */
35 interface IERC165 {
36     /**
37      * @dev Returns true if this contract implements the interface defined by
38      * `interfaceId`. See the corresponding
39      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
40      * to learn more about how these ids are created.
41      *
42      * This function call must use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) external view returns (bool);
45 }
46 
47 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.7.2
48 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev Required interface of an ERC1155 compliant contract, as defined in the
54  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
55  *
56  * _Available since v3.1._
57  */
58 interface IERC1155 is IERC165 {
59     /**
60      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
61      */
62     event TransferSingle(
63         address indexed operator,
64         address indexed from,
65         address indexed to,
66         uint256 id,
67         uint256 value
68     );
69 
70     /**
71      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
72      * transfers.
73      */
74     event TransferBatch(
75         address indexed operator,
76         address indexed from,
77         address indexed to,
78         uint256[] ids,
79         uint256[] values
80     );
81 
82     /**
83      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
84      * `approved`.
85      */
86     event ApprovalForAll(
87         address indexed account,
88         address indexed operator,
89         bool approved
90     );
91 
92     /**
93      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
94      *
95      * If an {URI} event was emitted for `id`, the standard
96      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
97      * returned by {IERC1155MetadataURI-uri}.
98      */
99     event URI(string value, uint256 indexed id);
100 
101     /**
102      * @dev Returns the amount of tokens of token type `id` owned by `account`.
103      *
104      * Requirements:
105      *
106      * - `account` cannot be the zero address.
107      */
108     function balanceOf(address account, uint256 id)
109         external
110         view
111         returns (uint256);
112 
113     /**
114      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
115      *
116      * Requirements:
117      *
118      * - `accounts` and `ids` must have the same length.
119      */
120     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
121         external
122         view
123         returns (uint256[] memory);
124 
125     /**
126      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
127      *
128      * Emits an {ApprovalForAll} event.
129      *
130      * Requirements:
131      *
132      * - `operator` cannot be the caller.
133      */
134     function setApprovalForAll(address operator, bool approved) external;
135 
136     /**
137      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
138      *
139      * See {setApprovalForAll}.
140      */
141     function isApprovedForAll(address account, address operator)
142         external
143         view
144         returns (bool);
145 
146     /**
147      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
148      *
149      * Emits a {TransferSingle} event.
150      *
151      * Requirements:
152      *
153      * - `to` cannot be the zero address.
154      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
155      * - `from` must have a balance of tokens of type `id` of at least `amount`.
156      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
157      * acceptance magic value.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 id,
163         uint256 amount,
164         bytes calldata data
165     ) external;
166 
167     /**
168      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
169      *
170      * Emits a {TransferBatch} event.
171      *
172      * Requirements:
173      *
174      * - `ids` and `amounts` must have the same length.
175      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
176      * acceptance magic value.
177      */
178     function safeBatchTransferFrom(
179         address from,
180         address to,
181         uint256[] calldata ids,
182         uint256[] calldata amounts,
183         bytes calldata data
184     ) external;
185 }
186 
187 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.7.2
188 
189 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev _Available since v3.1._
195  */
196 interface IERC1155Receiver is IERC165 {
197     /**
198      * @dev Handles the receipt of a single ERC1155 token type. This function is
199      * called at the end of a `safeTransferFrom` after the balance has been updated.
200      *
201      * NOTE: To accept the transfer, this must return
202      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
203      * (i.e. 0xf23a6e61, or its own function selector).
204      *
205      * @param operator The address which initiated the transfer (i.e. msg.sender)
206      * @param from The address which previously owned the token
207      * @param id The ID of the token being transferred
208      * @param value The amount of tokens being transferred
209      * @param data Additional data with no specified format
210      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
211      */
212     function onERC1155Received(
213         address operator,
214         address from,
215         uint256 id,
216         uint256 value,
217         bytes calldata data
218     ) external returns (bytes4);
219 
220     /**
221      * @dev Handles the receipt of a multiple ERC1155 token types. This function
222      * is called at the end of a `safeBatchTransferFrom` after the balances have
223      * been updated.
224      *
225      * NOTE: To accept the transfer(s), this must return
226      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
227      * (i.e. 0xbc197c81, or its own function selector).
228      *
229      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
230      * @param from The address which previously owned the token
231      * @param ids An array containing ids of each token being transferred (order and length must match values array)
232      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
233      * @param data Additional data with no specified format
234      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
235      */
236     function onERC1155BatchReceived(
237         address operator,
238         address from,
239         uint256[] calldata ids,
240         uint256[] calldata values,
241         bytes calldata data
242     ) external returns (bytes4);
243 }
244 
245 // File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.7.2
246 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
252  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
253  *
254  * _Available since v3.1._
255  */
256 interface IERC1155MetadataURI is IERC1155 {
257     /**
258      * @dev Returns the URI for token type `id`.
259      *
260      * If the `\{id\}` substring is present in the URI, it must be replaced by
261      * clients with the actual token type ID.
262      */
263     function uri(uint256 id) external view returns (string memory);
264 }
265 
266 // File @openzeppelin/contracts/utils/Address.sol@v4.7.2
267 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
268 
269 pragma solidity ^0.8.1;
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      *
292      * [IMPORTANT]
293      * ====
294      * You shouldn't rely on `isContract` to protect against flash loan attacks!
295      *
296      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
297      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
298      * constructor.
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // This method relies on extcodesize/address.code.length, which returns 0
303         // for contracts in construction, since the code is only stored at the end
304         // of the constructor execution.
305 
306         return account.code.length > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(
327             address(this).balance >= amount,
328             "Address: insufficient balance"
329         );
330 
331         (bool success, ) = recipient.call{value: amount}("");
332         require(
333             success,
334             "Address: unable to send value, recipient may have reverted"
335         );
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain `call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data)
357         internal
358         returns (bytes memory)
359     {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value
392     ) internal returns (bytes memory) {
393         return
394             functionCallWithValue(
395                 target,
396                 data,
397                 value,
398                 "Address: low-level call with value failed"
399             );
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(
415             address(this).balance >= value,
416             "Address: insufficient balance for call"
417         );
418         require(isContract(target), "Address: call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.call{value: value}(
421             data
422         );
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data)
433         internal
434         view
435         returns (bytes memory)
436     {
437         return
438             functionStaticCall(
439                 target,
440                 data,
441                 "Address: low-level static call failed"
442             );
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal view returns (bytes memory) {
456         require(isContract(target), "Address: static call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.staticcall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(address target, bytes memory data)
469         internal
470         returns (bytes memory)
471     {
472         return
473             functionDelegateCall(
474                 target,
475                 data,
476                 "Address: low-level delegate call failed"
477             );
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(isContract(target), "Address: delegate call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
499      * revert reason using the provided one.
500      *
501      * _Available since v4.3._
502      */
503     function verifyCallResult(
504         bool success,
505         bytes memory returndata,
506         string memory errorMessage
507     ) internal pure returns (bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514                 /// @solidity memory-safe-assembly
515                 assembly {
516                     let returndata_size := mload(returndata)
517                     revert(add(32, returndata), returndata_size)
518                 }
519             } else {
520                 revert(errorMessage);
521             }
522         }
523     }
524 }
525 
526 // File @openzeppelin/contracts/utils/Context.sol@v4.7.2
527 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Provides information about the current execution context, including the
533  * sender of the transaction and its data. While these are generally available
534  * via msg.sender and msg.data, they should not be accessed in such a direct
535  * manner, since when dealing with meta-transactions the account sending and
536  * paying for execution may not be the actual sender (as far as an application
537  * is concerned).
538  *
539  * This contract is only required for intermediate, library-like contracts.
540  */
541 abstract contract Context {
542     function _msgSender() internal view virtual returns (address) {
543         return msg.sender;
544     }
545 
546     function _msgData() internal view virtual returns (bytes calldata) {
547         return msg.data;
548     }
549 }
550 
551 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.2
552 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId)
575         public
576         view
577         virtual
578         override
579         returns (bool)
580     {
581         return interfaceId == type(IERC165).interfaceId;
582     }
583 }
584 
585 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.7.2
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @dev Implementation of the basic standard multi-token.
591  * See https://eips.ethereum.org/EIPS/eip-1155
592  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
593  *
594  * _Available since v3.1._
595  */
596 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
597     using Address for address;
598 
599     // Mapping from token ID to account balances
600     mapping(uint256 => mapping(address => uint256)) private _balances;
601 
602     // Mapping from account to operator approvals
603     mapping(address => mapping(address => bool)) private _operatorApprovals;
604 
605     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
606     string private _uri;
607 
608     /**
609      * @dev See {_setURI}.
610      */
611     constructor(string memory uri_) {
612         _setURI(uri_);
613     }
614 
615     /**
616      * @dev See {IERC165-supportsInterface}.
617      */
618     function supportsInterface(bytes4 interfaceId)
619         public
620         view
621         virtual
622         override(ERC165, IERC165)
623         returns (bool)
624     {
625         return
626             interfaceId == type(IERC1155).interfaceId ||
627             interfaceId == type(IERC1155MetadataURI).interfaceId ||
628             super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC1155MetadataURI-uri}.
633      *
634      * This implementation returns the same URI for *all* token types. It relies
635      * on the token type ID substitution mechanism
636      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
637      *
638      * Clients calling this function must replace the `\{id\}` substring with the
639      * actual token type ID.
640      */
641     function uri(uint256) public view virtual override returns (string memory) {
642         return _uri;
643     }
644 
645     /**
646      * @dev See {IERC1155-balanceOf}.
647      *
648      * Requirements:
649      *
650      * - `account` cannot be the zero address.
651      */
652     function balanceOf(address account, uint256 id)
653         public
654         view
655         virtual
656         override
657         returns (uint256)
658     {
659         require(
660             account != address(0),
661             "ERC1155: address zero is not a valid owner"
662         );
663         return _balances[id][account];
664     }
665 
666     /**
667      * @dev See {IERC1155-balanceOfBatch}.
668      *
669      * Requirements:
670      *
671      * - `accounts` and `ids` must have the same length.
672      */
673     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
674         public
675         view
676         virtual
677         override
678         returns (uint256[] memory)
679     {
680         require(
681             accounts.length == ids.length,
682             "ERC1155: accounts and ids length mismatch"
683         );
684 
685         uint256[] memory batchBalances = new uint256[](accounts.length);
686 
687         for (uint256 i = 0; i < accounts.length; ++i) {
688             batchBalances[i] = balanceOf(accounts[i], ids[i]);
689         }
690 
691         return batchBalances;
692     }
693 
694     /**
695      * @dev See {IERC1155-setApprovalForAll}.
696      */
697     function setApprovalForAll(address operator, bool approved)
698         public
699         virtual
700         override
701     {
702         _setApprovalForAll(_msgSender(), operator, approved);
703     }
704 
705     /**
706      * @dev See {IERC1155-isApprovedForAll}.
707      */
708     function isApprovedForAll(address account, address operator)
709         public
710         view
711         virtual
712         override
713         returns (bool)
714     {
715         return _operatorApprovals[account][operator];
716     }
717 
718     /**
719      * @dev See {IERC1155-safeTransferFrom}.
720      */
721     function safeTransferFrom(
722         address from,
723         address to,
724         uint256 id,
725         uint256 amount,
726         bytes memory data
727     ) public virtual override {
728         require(
729             from == _msgSender() || isApprovedForAll(from, _msgSender()),
730             "ERC1155: caller is not token owner nor approved"
731         );
732         _safeTransferFrom(from, to, id, amount, data);
733     }
734 
735     /**
736      * @dev See {IERC1155-safeBatchTransferFrom}.
737      */
738     function safeBatchTransferFrom(
739         address from,
740         address to,
741         uint256[] memory ids,
742         uint256[] memory amounts,
743         bytes memory data
744     ) public virtual override {
745         require(
746             from == _msgSender() || isApprovedForAll(from, _msgSender()),
747             "ERC1155: caller is not token owner nor approved"
748         );
749         _safeBatchTransferFrom(from, to, ids, amounts, data);
750     }
751 
752     /**
753      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
754      *
755      * Emits a {TransferSingle} event.
756      *
757      * Requirements:
758      *
759      * - `to` cannot be the zero address.
760      * - `from` must have a balance of tokens of type `id` of at least `amount`.
761      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
762      * acceptance magic value.
763      */
764     function _safeTransferFrom(
765         address from,
766         address to,
767         uint256 id,
768         uint256 amount,
769         bytes memory data
770     ) internal virtual {
771         require(to != address(0), "ERC1155: transfer to the zero address");
772 
773         address operator = _msgSender();
774         uint256[] memory ids = _asSingletonArray(id);
775         uint256[] memory amounts = _asSingletonArray(amount);
776 
777         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
778 
779         uint256 fromBalance = _balances[id][from];
780         require(
781             fromBalance >= amount,
782             "ERC1155: insufficient balance for transfer"
783         );
784         unchecked {
785             _balances[id][from] = fromBalance - amount;
786         }
787         _balances[id][to] += amount;
788 
789         emit TransferSingle(operator, from, to, id, amount);
790 
791         _afterTokenTransfer(operator, from, to, ids, amounts, data);
792 
793         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
794     }
795 
796     /**
797      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
798      *
799      * Emits a {TransferBatch} event.
800      *
801      * Requirements:
802      *
803      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
804      * acceptance magic value.
805      */
806     function _safeBatchTransferFrom(
807         address from,
808         address to,
809         uint256[] memory ids,
810         uint256[] memory amounts,
811         bytes memory data
812     ) internal virtual {
813         require(
814             ids.length == amounts.length,
815             "ERC1155: ids and amounts length mismatch"
816         );
817         require(to != address(0), "ERC1155: transfer to the zero address");
818 
819         address operator = _msgSender();
820 
821         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
822 
823         for (uint256 i = 0; i < ids.length; ++i) {
824             uint256 id = ids[i];
825             uint256 amount = amounts[i];
826 
827             uint256 fromBalance = _balances[id][from];
828             require(
829                 fromBalance >= amount,
830                 "ERC1155: insufficient balance for transfer"
831             );
832             unchecked {
833                 _balances[id][from] = fromBalance - amount;
834             }
835             _balances[id][to] += amount;
836         }
837 
838         emit TransferBatch(operator, from, to, ids, amounts);
839 
840         _afterTokenTransfer(operator, from, to, ids, amounts, data);
841 
842         _doSafeBatchTransferAcceptanceCheck(
843             operator,
844             from,
845             to,
846             ids,
847             amounts,
848             data
849         );
850     }
851 
852     /**
853      * @dev Sets a new URI for all token types, by relying on the token type ID
854      * substitution mechanism
855      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
856      *
857      * By this mechanism, any occurrence of the `\{id\}` substring in either the
858      * URI or any of the amounts in the JSON file at said URI will be replaced by
859      * clients with the token type ID.
860      *
861      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
862      * interpreted by clients as
863      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
864      * for token type ID 0x4cce0.
865      *
866      * See {uri}.
867      *
868      * Because these URIs cannot be meaningfully represented by the {URI} event,
869      * this function emits no events.
870      */
871     function _setURI(string memory newuri) internal virtual {
872         _uri = newuri;
873     }
874 
875     /**
876      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
877      *
878      * Emits a {TransferSingle} event.
879      *
880      * Requirements:
881      *
882      * - `to` cannot be the zero address.
883      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
884      * acceptance magic value.
885      */
886     function _mint(
887         address to,
888         uint256 id,
889         uint256 amount,
890         bytes memory data
891     ) internal virtual {
892         require(to != address(0), "ERC1155: mint to the zero address");
893 
894         address operator = _msgSender();
895         uint256[] memory ids = _asSingletonArray(id);
896         uint256[] memory amounts = _asSingletonArray(amount);
897 
898         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
899 
900         _balances[id][to] += amount;
901         emit TransferSingle(operator, address(0), to, id, amount);
902 
903         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
904 
905         _doSafeTransferAcceptanceCheck(
906             operator,
907             address(0),
908             to,
909             id,
910             amount,
911             data
912         );
913     }
914 
915     /**
916      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
917      *
918      * Emits a {TransferBatch} event.
919      *
920      * Requirements:
921      *
922      * - `ids` and `amounts` must have the same length.
923      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
924      * acceptance magic value.
925      */
926     function _mintBatch(
927         address to,
928         uint256[] memory ids,
929         uint256[] memory amounts,
930         bytes memory data
931     ) internal virtual {
932         require(to != address(0), "ERC1155: mint to the zero address");
933         require(
934             ids.length == amounts.length,
935             "ERC1155: ids and amounts length mismatch"
936         );
937 
938         address operator = _msgSender();
939 
940         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
941 
942         for (uint256 i = 0; i < ids.length; i++) {
943             _balances[ids[i]][to] += amounts[i];
944         }
945 
946         emit TransferBatch(operator, address(0), to, ids, amounts);
947 
948         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
949 
950         _doSafeBatchTransferAcceptanceCheck(
951             operator,
952             address(0),
953             to,
954             ids,
955             amounts,
956             data
957         );
958     }
959 
960     /**
961      * @dev Destroys `amount` tokens of token type `id` from `from`
962      *
963      * Emits a {TransferSingle} event.
964      *
965      * Requirements:
966      *
967      * - `from` cannot be the zero address.
968      * - `from` must have at least `amount` tokens of token type `id`.
969      */
970     function _burn(
971         address from,
972         uint256 id,
973         uint256 amount
974     ) internal virtual {
975         require(from != address(0), "ERC1155: burn from the zero address");
976 
977         address operator = _msgSender();
978         uint256[] memory ids = _asSingletonArray(id);
979         uint256[] memory amounts = _asSingletonArray(amount);
980 
981         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
982 
983         uint256 fromBalance = _balances[id][from];
984         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
985         unchecked {
986             _balances[id][from] = fromBalance - amount;
987         }
988 
989         emit TransferSingle(operator, from, address(0), id, amount);
990 
991         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
992     }
993 
994     /**
995      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
996      *
997      * Emits a {TransferBatch} event.
998      *
999      * Requirements:
1000      *
1001      * - `ids` and `amounts` must have the same length.
1002      */
1003     function _burnBatch(
1004         address from,
1005         uint256[] memory ids,
1006         uint256[] memory amounts
1007     ) internal virtual {
1008         require(from != address(0), "ERC1155: burn from the zero address");
1009         require(
1010             ids.length == amounts.length,
1011             "ERC1155: ids and amounts length mismatch"
1012         );
1013 
1014         address operator = _msgSender();
1015 
1016         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1017 
1018         for (uint256 i = 0; i < ids.length; i++) {
1019             uint256 id = ids[i];
1020             uint256 amount = amounts[i];
1021 
1022             uint256 fromBalance = _balances[id][from];
1023             require(
1024                 fromBalance >= amount,
1025                 "ERC1155: burn amount exceeds balance"
1026             );
1027             unchecked {
1028                 _balances[id][from] = fromBalance - amount;
1029             }
1030         }
1031 
1032         emit TransferBatch(operator, from, address(0), ids, amounts);
1033 
1034         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1035     }
1036 
1037     /**
1038      * @dev Approve `operator` to operate on all of `owner` tokens
1039      *
1040      * Emits an {ApprovalForAll} event.
1041      */
1042     function _setApprovalForAll(
1043         address owner,
1044         address operator,
1045         bool approved
1046     ) internal virtual {
1047         require(owner != operator, "ERC1155: setting approval status for self");
1048         _operatorApprovals[owner][operator] = approved;
1049         emit ApprovalForAll(owner, operator, approved);
1050     }
1051 
1052     /**
1053      * @dev Hook that is called before any token transfer. This includes minting
1054      * and burning, as well as batched variants.
1055      *
1056      * The same hook is called on both single and batched variants. For single
1057      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1058      *
1059      * Calling conditions (for each `id` and `amount` pair):
1060      *
1061      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1062      * of token type `id` will be  transferred to `to`.
1063      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1064      * for `to`.
1065      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1066      * will be burned.
1067      * - `from` and `to` are never both zero.
1068      * - `ids` and `amounts` have the same, non-zero length.
1069      *
1070      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1071      */
1072     function _beforeTokenTransfer(
1073         address operator,
1074         address from,
1075         address to,
1076         uint256[] memory ids,
1077         uint256[] memory amounts,
1078         bytes memory data
1079     ) internal virtual {}
1080 
1081     /**
1082      * @dev Hook that is called after any token transfer. This includes minting
1083      * and burning, as well as batched variants.
1084      *
1085      * The same hook is called on both single and batched variants. For single
1086      * transfers, the length of the `id` and `amount` arrays will be 1.
1087      *
1088      * Calling conditions (for each `id` and `amount` pair):
1089      *
1090      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1091      * of token type `id` will be  transferred to `to`.
1092      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1093      * for `to`.
1094      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1095      * will be burned.
1096      * - `from` and `to` are never both zero.
1097      * - `ids` and `amounts` have the same, non-zero length.
1098      *
1099      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1100      */
1101     function _afterTokenTransfer(
1102         address operator,
1103         address from,
1104         address to,
1105         uint256[] memory ids,
1106         uint256[] memory amounts,
1107         bytes memory data
1108     ) internal virtual {}
1109 
1110     function _doSafeTransferAcceptanceCheck(
1111         address operator,
1112         address from,
1113         address to,
1114         uint256 id,
1115         uint256 amount,
1116         bytes memory data
1117     ) private {
1118         if (to.isContract()) {
1119             try
1120                 IERC1155Receiver(to).onERC1155Received(
1121                     operator,
1122                     from,
1123                     id,
1124                     amount,
1125                     data
1126                 )
1127             returns (bytes4 response) {
1128                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1129                     revert("ERC1155: ERC1155Receiver rejected tokens");
1130                 }
1131             } catch Error(string memory reason) {
1132                 revert(reason);
1133             } catch {
1134                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1135             }
1136         }
1137     }
1138 
1139     function _doSafeBatchTransferAcceptanceCheck(
1140         address operator,
1141         address from,
1142         address to,
1143         uint256[] memory ids,
1144         uint256[] memory amounts,
1145         bytes memory data
1146     ) private {
1147         if (to.isContract()) {
1148             try
1149                 IERC1155Receiver(to).onERC1155BatchReceived(
1150                     operator,
1151                     from,
1152                     ids,
1153                     amounts,
1154                     data
1155                 )
1156             returns (bytes4 response) {
1157                 if (
1158                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1159                 ) {
1160                     revert("ERC1155: ERC1155Receiver rejected tokens");
1161                 }
1162             } catch Error(string memory reason) {
1163                 revert(reason);
1164             } catch {
1165                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1166             }
1167         }
1168     }
1169 
1170     function _asSingletonArray(uint256 element)
1171         private
1172         pure
1173         returns (uint256[] memory)
1174     {
1175         uint256[] memory array = new uint256[](1);
1176         array[0] = element;
1177 
1178         return array;
1179     }
1180 }
1181 
1182 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.2
1183 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 /**
1188  * @dev String operations.
1189  */
1190 library Strings {
1191     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1192     uint8 private constant _ADDRESS_LENGTH = 20;
1193 
1194     /**
1195      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1196      */
1197     function toString(uint256 value) internal pure returns (string memory) {
1198         // Inspired by OraclizeAPI's implementation - MIT licence
1199         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1200 
1201         if (value == 0) {
1202             return "0";
1203         }
1204         uint256 temp = value;
1205         uint256 digits;
1206         while (temp != 0) {
1207             digits++;
1208             temp /= 10;
1209         }
1210         bytes memory buffer = new bytes(digits);
1211         while (value != 0) {
1212             digits -= 1;
1213             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1214             value /= 10;
1215         }
1216         return string(buffer);
1217     }
1218 
1219     /**
1220      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1221      */
1222     function toHexString(uint256 value) internal pure returns (string memory) {
1223         if (value == 0) {
1224             return "0x00";
1225         }
1226         uint256 temp = value;
1227         uint256 length = 0;
1228         while (temp != 0) {
1229             length++;
1230             temp >>= 8;
1231         }
1232         return toHexString(value, length);
1233     }
1234 
1235     /**
1236      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1237      */
1238     function toHexString(uint256 value, uint256 length)
1239         internal
1240         pure
1241         returns (string memory)
1242     {
1243         bytes memory buffer = new bytes(2 * length + 2);
1244         buffer[0] = "0";
1245         buffer[1] = "x";
1246         for (uint256 i = 2 * length + 1; i > 1; --i) {
1247             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1248             value >>= 4;
1249         }
1250         require(value == 0, "Strings: hex length insufficient");
1251         return string(buffer);
1252     }
1253 
1254     /**
1255      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1256      */
1257     function toHexString(address addr) internal pure returns (string memory) {
1258         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1259     }
1260 }
1261 
1262 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.2
1263 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 /**
1268  * @dev Contract module which provides a basic access control mechanism, where
1269  * there is an account (an owner) that can be granted exclusive access to
1270  * specific functions.
1271  *
1272  * By default, the owner account will be the one that deploys the contract. This
1273  * can later be changed with {transferOwnership}.
1274  *
1275  * This module is used through inheritance. It will make available the modifier
1276  * `onlyOwner`, which can be applied to your functions to restrict their use to
1277  * the owner.
1278  */
1279 abstract contract Ownable is Context {
1280     address private _owner;
1281 
1282     event OwnershipTransferred(
1283         address indexed previousOwner,
1284         address indexed newOwner
1285     );
1286 
1287     /**
1288      * @dev Initializes the contract setting the deployer as the initial owner.
1289      */
1290     constructor() {
1291         _transferOwnership(_msgSender());
1292     }
1293 
1294     /**
1295      * @dev Throws if called by any account other than the owner.
1296      */
1297     modifier onlyOwner() {
1298         _checkOwner();
1299         _;
1300     }
1301 
1302     /**
1303      * @dev Returns the address of the current owner.
1304      */
1305     function owner() public view virtual returns (address) {
1306         return _owner;
1307     }
1308 
1309     /**
1310      * @dev Throws if the sender is not the owner.
1311      */
1312     function _checkOwner() internal view virtual {
1313         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1314     }
1315 
1316     /**
1317      * @dev Leaves the contract without owner. It will not be possible to call
1318      * `onlyOwner` functions anymore. Can only be called by the current owner.
1319      *
1320      * NOTE: Renouncing ownership will leave the contract without an owner,
1321      * thereby removing any functionality that is only available to the owner.
1322      */
1323     function renounceOwnership() public virtual onlyOwner {
1324         _transferOwnership(address(0));
1325     }
1326 
1327     /**
1328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1329      * Can only be called by the current owner.
1330      */
1331     function transferOwnership(address newOwner) public virtual onlyOwner {
1332         require(
1333             newOwner != address(0),
1334             "Ownable: new owner is the zero address"
1335         );
1336         _transferOwnership(newOwner);
1337     }
1338 
1339     /**
1340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1341      * Internal function without access restriction.
1342      */
1343     function _transferOwnership(address newOwner) internal virtual {
1344         address oldOwner = _owner;
1345         _owner = newOwner;
1346         emit OwnershipTransferred(oldOwner, newOwner);
1347     }
1348 }
1349 
1350 // File @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol@v4.7.2
1351 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1352 
1353 pragma solidity ^0.8.0;
1354 
1355 /**
1356  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1357  *
1358  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1359  * clearly identified. Note: While a totalSupply of 1 might mean the
1360  * corresponding is an NFT, there is no guarantees that no other token with the
1361  * same id are not going to be minted.
1362  */
1363 abstract contract ERC1155Supply is ERC1155 {
1364     mapping(uint256 => uint256) private _totalSupply;
1365 
1366     /**
1367      * @dev Total amount of tokens in with a given id.
1368      */
1369     function totalSupply(uint256 id) public view virtual returns (uint256) {
1370         return _totalSupply[id];
1371     }
1372 
1373     /**
1374      * @dev Indicates whether any token exist with a given id, or not.
1375      */
1376     function exists(uint256 id) public view virtual returns (bool) {
1377         return ERC1155Supply.totalSupply(id) > 0;
1378     }
1379 
1380     /**
1381      * @dev See {ERC1155-_beforeTokenTransfer}.
1382      */
1383     function _beforeTokenTransfer(
1384         address operator,
1385         address from,
1386         address to,
1387         uint256[] memory ids,
1388         uint256[] memory amounts,
1389         bytes memory data
1390     ) internal virtual override {
1391         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1392 
1393         if (from == address(0)) {
1394             for (uint256 i = 0; i < ids.length; ++i) {
1395                 _totalSupply[ids[i]] += amounts[i];
1396             }
1397         }
1398 
1399         if (to == address(0)) {
1400             for (uint256 i = 0; i < ids.length; ++i) {
1401                 uint256 id = ids[i];
1402                 uint256 amount = amounts[i];
1403                 uint256 supply = _totalSupply[id];
1404                 require(
1405                     supply >= amount,
1406                     "ERC1155: burn amount exceeds totalSupply"
1407                 );
1408                 unchecked {
1409                     _totalSupply[id] = supply - amount;
1410                 }
1411             }
1412         }
1413     }
1414 }
1415 
1416 pragma solidity ^0.8.6;
1417 
1418 contract LiquidArtifacts is ERC1155, Ownable {
1419     using Strings for uint256;
1420 
1421     address private evolutionContract; // = 0x0B0237aD59e1BbCb611fdf0c9Fa07350C3f41e87;
1422     string private baseURI = "https://apeliquid.mypinata.cloud/ipfs/QmQfjT3TGcaBjWTM5kPfKiwWQCaiqJGw1aKft63AkNd4fn/";
1423     string public name = "Liquid Artifacts";
1424 
1425     mapping(uint256 => bool) public validArtifactTypes;
1426 
1427     event SetBaseURI(string indexed _baseURI);
1428 
1429     constructor(string memory _baseURI) ERC1155(_baseURI) {
1430         validArtifactTypes[1] = true;
1431         validArtifactTypes[2] = true;
1432         validArtifactTypes[3] = true;
1433         validArtifactTypes[4] = true;
1434         validArtifactTypes[5] = true;
1435         validArtifactTypes[7] = true;
1436         validArtifactTypes[8] = true;
1437         validArtifactTypes[9] = true;
1438         validArtifactTypes[10] = true;
1439         validArtifactTypes[42] = true;  // Legendary
1440         emit SetBaseURI(baseURI);
1441     }
1442 
1443     /**
1444      * @notice Airdrop a token to multiple addresses at once.
1445      * No strict supply is set in the contract. All methods are ownerOnly,
1446      * it is up to the owner to control the supply by not minting
1447      * past their desired number for each token.
1448      * @dev Airdrop one token to each address in the calldata list,
1449      * setting the supply to the length of the list + previously minted (airdropped) supply. Add an addess once per
1450      * token you would like to send.
1451      * @param _dropNumber The tokenID to send
1452      * @param _list address[] list of wallets to send 1 token to, each.
1453      */
1454     function airdrop(uint256 _dropNumber, address[] calldata _list)
1455         external
1456         onlyOwner
1457     {
1458         for (uint256 i = 0; i < _list.length; i++) {
1459             _mint(_list[i], _dropNumber, 1, "");
1460         }
1461     }
1462 
1463     /**
1464      * @notice Sends multiple tokens to a single address
1465      * @param _tokenID The id of the token to send
1466      * @param _address The address to receive the tokens
1467      * @param _quantity How many to send she receiver
1468      */
1469     function batchMint(
1470         uint256 _tokenID,
1471         address _address,
1472         uint256 _quantity
1473     ) external onlyOwner {
1474         _mint(_address, _tokenID, _quantity, "");
1475     }
1476 
1477     function setName(string memory _name) public onlyOwner {
1478         name = _name;
1479     }
1480 
1481     function setEvolutionContractAddress(address evolutionContractAddress)
1482         external
1483         onlyOwner
1484     {
1485         evolutionContract = evolutionContractAddress;
1486     }
1487 
1488     // Burn for legendary
1489     function burnforLegendary(uint256[] memory tokenIds, uint256[] memory amounts, address tokenOwner)
1490         external
1491     {
1492         _burnBatch(tokenOwner, tokenIds, amounts);
1493         //_mint(_msgSender(), 42, 1, "Burn For Legendary");
1494         _mint(tokenOwner, 42, 1, "Burn For Legendary");
1495     }
1496 
1497     function burnArtifacts(address tokenOwner, uint256 tokenId, uint256 totalToBurn) external {
1498         require(
1499             msg.sender == evolutionContract,
1500             "Invalid Evolution Contract"
1501         );
1502         _burn(tokenOwner, tokenId, totalToBurn);
1503     }
1504 
1505     function updateBaseUri(string memory _baseURI) external onlyOwner {
1506         baseURI = _baseURI;
1507         emit SetBaseURI(baseURI);
1508     }
1509 
1510     function uri(uint256 typeId) public view override returns (string memory) {
1511         require(
1512             validArtifactTypes[typeId],
1513             "URI requested for invalid artifact type"
1514         );
1515         return
1516             bytes(baseURI).length > 0
1517                 ? string(abi.encodePacked(baseURI, typeId.toString()))
1518                 : baseURI;
1519     }
1520 }