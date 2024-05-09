1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-02
3  */
4 
5 // SPDX-License-Identifier: MIT
6 /*
7    .____    .__             .__    .___
8    |    |   |__| ________ __|__| __| _/
9    |    |   |  |/ ____/  |  \  |/ __ |
10    |    |___|  < <_|  |  |  /  / /_/ |
11    |_______ \__|\__   |____/|__\____ |
12            \/      |__|             \/
13 
14    Standing on the shoulders of giants -- Yuga Labs & MAYC
15      * Written by Aleph 0ne for the ApeLiquid community *
16   * Liquid Enhancements are in-game items like weapons, etc. *
17 */
18 
19 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.2
20 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Interface of the ERC165 standard, as defined in the
26  * https://eips.ethereum.org/EIPS/eip-165[EIP].
27  *
28  * Implementers can declare support of contract interfaces, which can then be
29  * queried by others ({ERC165Checker}).
30  *
31  * For an implementation, see {ERC165}.
32  */
33 interface IERC165 {
34     /**
35      * @dev Returns true if this contract implements the interface defined by
36      * `interfaceId`. See the corresponding
37      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
38      * to learn more about how these ids are created.
39      *
40      * This function call must use less than 30 000 gas.
41      */
42     function supportsInterface(bytes4 interfaceId) external view returns (bool);
43 }
44 
45 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.7.2
46 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev Required interface of an ERC1155 compliant contract, as defined in the
52  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
53  *
54  * _Available since v3.1._
55  */
56 interface IERC1155 is IERC165 {
57     /**
58      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
59      */
60     event TransferSingle(
61         address indexed operator,
62         address indexed from,
63         address indexed to,
64         uint256 id,
65         uint256 value
66     );
67 
68     /**
69      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
70      * transfers.
71      */
72     event TransferBatch(
73         address indexed operator,
74         address indexed from,
75         address indexed to,
76         uint256[] ids,
77         uint256[] values
78     );
79 
80     /**
81      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
82      * `approved`.
83      */
84     event ApprovalForAll(
85         address indexed account,
86         address indexed operator,
87         bool approved
88     );
89 
90     /**
91      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
92      *
93      * If an {URI} event was emitted for `id`, the standard
94      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
95      * returned by {IERC1155MetadataURI-uri}.
96      */
97     event URI(string value, uint256 indexed id);
98 
99     /**
100      * @dev Returns the amount of tokens of token type `id` owned by `account`.
101      *
102      * Requirements:
103      *
104      * - `account` cannot be the zero address.
105      */
106     function balanceOf(address account, uint256 id)
107         external
108         view
109         returns (uint256);
110 
111     /**
112      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
113      *
114      * Requirements:
115      *
116      * - `accounts` and `ids` must have the same length.
117      */
118     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
119         external
120         view
121         returns (uint256[] memory);
122 
123     /**
124      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
125      *
126      * Emits an {ApprovalForAll} event.
127      *
128      * Requirements:
129      *
130      * - `operator` cannot be the caller.
131      */
132     function setApprovalForAll(address operator, bool approved) external;
133 
134     /**
135      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
136      *
137      * See {setApprovalForAll}.
138      */
139     function isApprovedForAll(address account, address operator)
140         external
141         view
142         returns (bool);
143 
144     /**
145      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
146      *
147      * Emits a {TransferSingle} event.
148      *
149      * Requirements:
150      *
151      * - `to` cannot be the zero address.
152      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
153      * - `from` must have a balance of tokens of type `id` of at least `amount`.
154      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
155      * acceptance magic value.
156      */
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 id,
161         uint256 amount,
162         bytes calldata data
163     ) external;
164 
165     /**
166      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
167      *
168      * Emits a {TransferBatch} event.
169      *
170      * Requirements:
171      *
172      * - `ids` and `amounts` must have the same length.
173      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
174      * acceptance magic value.
175      */
176     function safeBatchTransferFrom(
177         address from,
178         address to,
179         uint256[] calldata ids,
180         uint256[] calldata amounts,
181         bytes calldata data
182     ) external;
183 }
184 
185 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.7.2
186 
187 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @dev _Available since v3.1._
193  */
194 interface IERC1155Receiver is IERC165 {
195     /**
196      * @dev Handles the receipt of a single ERC1155 token type. This function is
197      * called at the end of a `safeTransferFrom` after the balance has been updated.
198      *
199      * NOTE: To accept the transfer, this must return
200      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
201      * (i.e. 0xf23a6e61, or its own function selector).
202      *
203      * @param operator The address which initiated the transfer (i.e. msg.sender)
204      * @param from The address which previously owned the token
205      * @param id The ID of the token being transferred
206      * @param value The amount of tokens being transferred
207      * @param data Additional data with no specified format
208      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
209      */
210     function onERC1155Received(
211         address operator,
212         address from,
213         uint256 id,
214         uint256 value,
215         bytes calldata data
216     ) external returns (bytes4);
217 
218     /**
219      * @dev Handles the receipt of a multiple ERC1155 token types. This function
220      * is called at the end of a `safeBatchTransferFrom` after the balances have
221      * been updated.
222      *
223      * NOTE: To accept the transfer(s), this must return
224      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
225      * (i.e. 0xbc197c81, or its own function selector).
226      *
227      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
228      * @param from The address which previously owned the token
229      * @param ids An array containing ids of each token being transferred (order and length must match values array)
230      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
231      * @param data Additional data with no specified format
232      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
233      */
234     function onERC1155BatchReceived(
235         address operator,
236         address from,
237         uint256[] calldata ids,
238         uint256[] calldata values,
239         bytes calldata data
240     ) external returns (bytes4);
241 }
242 
243 // File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.7.2
244 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
250  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
251  *
252  * _Available since v3.1._
253  */
254 interface IERC1155MetadataURI is IERC1155 {
255     /**
256      * @dev Returns the URI for token type `id`.
257      *
258      * If the `\{id\}` substring is present in the URI, it must be replaced by
259      * clients with the actual token type ID.
260      */
261     function uri(uint256 id) external view returns (string memory);
262 }
263 
264 // File @openzeppelin/contracts/utils/Address.sol@v4.7.2
265 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
266 
267 pragma solidity ^0.8.1;
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      *
290      * [IMPORTANT]
291      * ====
292      * You shouldn't rely on `isContract` to protect against flash loan attacks!
293      *
294      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
295      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
296      * constructor.
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // This method relies on extcodesize/address.code.length, which returns 0
301         // for contracts in construction, since the code is only stored at the end
302         // of the constructor execution.
303 
304         return account.code.length > 0;
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(
325             address(this).balance >= amount,
326             "Address: insufficient balance"
327         );
328 
329         (bool success, ) = recipient.call{value: amount}("");
330         require(
331             success,
332             "Address: unable to send value, recipient may have reverted"
333         );
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain `call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data)
355         internal
356         returns (bytes memory)
357     {
358         return functionCall(target, data, "Address: low-level call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
363      * `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         return functionCallWithValue(target, data, 0, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but also transferring `value` wei to `target`.
378      *
379      * Requirements:
380      *
381      * - the calling contract must have an ETH balance of at least `value`.
382      * - the called Solidity function must be `payable`.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(
387         address target,
388         bytes memory data,
389         uint256 value
390     ) internal returns (bytes memory) {
391         return
392             functionCallWithValue(
393                 target,
394                 data,
395                 value,
396                 "Address: low-level call with value failed"
397             );
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 value,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(
413             address(this).balance >= value,
414             "Address: insufficient balance for call"
415         );
416         require(isContract(target), "Address: call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.call{value: value}(
419             data
420         );
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a static call.
427      *
428      * _Available since v3.3._
429      */
430     function functionStaticCall(address target, bytes memory data)
431         internal
432         view
433         returns (bytes memory)
434     {
435         return
436             functionStaticCall(
437                 target,
438                 data,
439                 "Address: low-level static call failed"
440             );
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445      * but performing a static call.
446      *
447      * _Available since v3.3._
448      */
449     function functionStaticCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal view returns (bytes memory) {
454         require(isContract(target), "Address: static call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.staticcall(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(address target, bytes memory data)
467         internal
468         returns (bytes memory)
469     {
470         return
471             functionDelegateCall(
472                 target,
473                 data,
474                 "Address: low-level delegate call failed"
475             );
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.4._
483      */
484     function functionDelegateCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         require(isContract(target), "Address: delegate call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.delegatecall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
497      * revert reason using the provided one.
498      *
499      * _Available since v4.3._
500      */
501     function verifyCallResult(
502         bool success,
503         bytes memory returndata,
504         string memory errorMessage
505     ) internal pure returns (bytes memory) {
506         if (success) {
507             return returndata;
508         } else {
509             // Look for revert reason and bubble it up if present
510             if (returndata.length > 0) {
511                 // The easiest way to bubble the revert reason is using memory via assembly
512                 /// @solidity memory-safe-assembly
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 // File @openzeppelin/contracts/utils/Context.sol@v4.7.2
525 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Provides information about the current execution context, including the
531  * sender of the transaction and its data. While these are generally available
532  * via msg.sender and msg.data, they should not be accessed in such a direct
533  * manner, since when dealing with meta-transactions the account sending and
534  * paying for execution may not be the actual sender (as far as an application
535  * is concerned).
536  *
537  * This contract is only required for intermediate, library-like contracts.
538  */
539 abstract contract Context {
540     function _msgSender() internal view virtual returns (address) {
541         return msg.sender;
542     }
543 
544     function _msgData() internal view virtual returns (bytes calldata) {
545         return msg.data;
546     }
547 }
548 
549 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.2
550 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 /**
555  * @dev Implementation of the {IERC165} interface.
556  *
557  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
558  * for the additional interface id that will be supported. For example:
559  *
560  * ```solidity
561  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
563  * }
564  * ```
565  *
566  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
567  */
568 abstract contract ERC165 is IERC165 {
569     /**
570      * @dev See {IERC165-supportsInterface}.
571      */
572     function supportsInterface(bytes4 interfaceId)
573         public
574         view
575         virtual
576         override
577         returns (bool)
578     {
579         return interfaceId == type(IERC165).interfaceId;
580     }
581 }
582 
583 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.7.2
584 
585 pragma solidity ^0.8.0;
586 
587 /**
588  * @dev Implementation of the basic standard multi-token.
589  * See https://eips.ethereum.org/EIPS/eip-1155
590  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
591  *
592  * _Available since v3.1._
593  */
594 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
595     using Address for address;
596 
597     // Mapping from token ID to account balances
598     mapping(uint256 => mapping(address => uint256)) private _balances;
599 
600     // Mapping from account to operator approvals
601     mapping(address => mapping(address => bool)) private _operatorApprovals;
602 
603     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
604     string private _uri;
605 
606     /**
607      * @dev See {_setURI}.
608      */
609     constructor(string memory uri_) {
610         _setURI(uri_);
611     }
612 
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId)
617         public
618         view
619         virtual
620         override(ERC165, IERC165)
621         returns (bool)
622     {
623         return
624             interfaceId == type(IERC1155).interfaceId ||
625             interfaceId == type(IERC1155MetadataURI).interfaceId ||
626             super.supportsInterface(interfaceId);
627     }
628 
629     /**
630      * @dev See {IERC1155MetadataURI-uri}.
631      *
632      * This implementation returns the same URI for *all* token types. It relies
633      * on the token type ID substitution mechanism
634      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
635      *
636      * Clients calling this function must replace the `\{id\}` substring with the
637      * actual token type ID.
638      */
639     function uri(uint256) public view virtual override returns (string memory) {
640         return _uri;
641     }
642 
643     /**
644      * @dev See {IERC1155-balanceOf}.
645      *
646      * Requirements:
647      *
648      * - `account` cannot be the zero address.
649      */
650     function balanceOf(address account, uint256 id)
651         public
652         view
653         virtual
654         override
655         returns (uint256)
656     {
657         require(
658             account != address(0),
659             "ERC1155: address zero is not a valid owner"
660         );
661         return _balances[id][account];
662     }
663 
664     /**
665      * @dev See {IERC1155-balanceOfBatch}.
666      *
667      * Requirements:
668      *
669      * - `accounts` and `ids` must have the same length.
670      */
671     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
672         public
673         view
674         virtual
675         override
676         returns (uint256[] memory)
677     {
678         require(
679             accounts.length == ids.length,
680             "ERC1155: accounts and ids length mismatch"
681         );
682 
683         uint256[] memory batchBalances = new uint256[](accounts.length);
684 
685         for (uint256 i = 0; i < accounts.length; ++i) {
686             batchBalances[i] = balanceOf(accounts[i], ids[i]);
687         }
688 
689         return batchBalances;
690     }
691 
692     /**
693      * @dev See {IERC1155-setApprovalForAll}.
694      */
695     function setApprovalForAll(address operator, bool approved)
696         public
697         virtual
698         override
699     {
700         _setApprovalForAll(_msgSender(), operator, approved);
701     }
702 
703     /**
704      * @dev See {IERC1155-isApprovedForAll}.
705      */
706     function isApprovedForAll(address account, address operator)
707         public
708         view
709         virtual
710         override
711         returns (bool)
712     {
713         return _operatorApprovals[account][operator];
714     }
715 
716     /**
717      * @dev See {IERC1155-safeTransferFrom}.
718      */
719     function safeTransferFrom(
720         address from,
721         address to,
722         uint256 id,
723         uint256 amount,
724         bytes memory data
725     ) public virtual override {
726         require(
727             from == _msgSender() || isApprovedForAll(from, _msgSender()),
728             "ERC1155: caller is not token owner nor approved"
729         );
730         _safeTransferFrom(from, to, id, amount, data);
731     }
732 
733     /**
734      * @dev See {IERC1155-safeBatchTransferFrom}.
735      */
736     function safeBatchTransferFrom(
737         address from,
738         address to,
739         uint256[] memory ids,
740         uint256[] memory amounts,
741         bytes memory data
742     ) public virtual override {
743         require(
744             from == _msgSender() || isApprovedForAll(from, _msgSender()),
745             "ERC1155: caller is not token owner nor approved"
746         );
747         _safeBatchTransferFrom(from, to, ids, amounts, data);
748     }
749 
750     /**
751      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
752      *
753      * Emits a {TransferSingle} event.
754      *
755      * Requirements:
756      *
757      * - `to` cannot be the zero address.
758      * - `from` must have a balance of tokens of type `id` of at least `amount`.
759      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
760      * acceptance magic value.
761      */
762     function _safeTransferFrom(
763         address from,
764         address to,
765         uint256 id,
766         uint256 amount,
767         bytes memory data
768     ) internal virtual {
769         require(to != address(0), "ERC1155: transfer to the zero address");
770 
771         address operator = _msgSender();
772         uint256[] memory ids = _asSingletonArray(id);
773         uint256[] memory amounts = _asSingletonArray(amount);
774 
775         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
776 
777         uint256 fromBalance = _balances[id][from];
778         require(
779             fromBalance >= amount,
780             "ERC1155: insufficient balance for transfer"
781         );
782         unchecked {
783             _balances[id][from] = fromBalance - amount;
784         }
785         _balances[id][to] += amount;
786 
787         emit TransferSingle(operator, from, to, id, amount);
788 
789         _afterTokenTransfer(operator, from, to, ids, amounts, data);
790 
791         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
792     }
793 
794     /**
795      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
796      *
797      * Emits a {TransferBatch} event.
798      *
799      * Requirements:
800      *
801      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
802      * acceptance magic value.
803      */
804     function _safeBatchTransferFrom(
805         address from,
806         address to,
807         uint256[] memory ids,
808         uint256[] memory amounts,
809         bytes memory data
810     ) internal virtual {
811         require(
812             ids.length == amounts.length,
813             "ERC1155: ids and amounts length mismatch"
814         );
815         require(to != address(0), "ERC1155: transfer to the zero address");
816 
817         address operator = _msgSender();
818 
819         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
820 
821         for (uint256 i = 0; i < ids.length; ++i) {
822             uint256 id = ids[i];
823             uint256 amount = amounts[i];
824 
825             uint256 fromBalance = _balances[id][from];
826             require(
827                 fromBalance >= amount,
828                 "ERC1155: insufficient balance for transfer"
829             );
830             unchecked {
831                 _balances[id][from] = fromBalance - amount;
832             }
833             _balances[id][to] += amount;
834         }
835 
836         emit TransferBatch(operator, from, to, ids, amounts);
837 
838         _afterTokenTransfer(operator, from, to, ids, amounts, data);
839 
840         _doSafeBatchTransferAcceptanceCheck(
841             operator,
842             from,
843             to,
844             ids,
845             amounts,
846             data
847         );
848     }
849 
850     /**
851      * @dev Sets a new URI for all token types, by relying on the token type ID
852      * substitution mechanism
853      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
854      *
855      * By this mechanism, any occurrence of the `\{id\}` substring in either the
856      * URI or any of the amounts in the JSON file at said URI will be replaced by
857      * clients with the token type ID.
858      *
859      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
860      * interpreted by clients as
861      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
862      * for token type ID 0x4cce0.
863      *
864      * See {uri}.
865      *
866      * Because these URIs cannot be meaningfully represented by the {URI} event,
867      * this function emits no events.
868      */
869     function _setURI(string memory newuri) internal virtual {
870         _uri = newuri;
871     }
872 
873     /**
874      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
875      *
876      * Emits a {TransferSingle} event.
877      *
878      * Requirements:
879      *
880      * - `to` cannot be the zero address.
881      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
882      * acceptance magic value.
883      */
884     function _mint(
885         address to,
886         uint256 id,
887         uint256 amount,
888         bytes memory data
889     ) internal virtual {
890         require(to != address(0), "ERC1155: mint to the zero address");
891 
892         address operator = _msgSender();
893         uint256[] memory ids = _asSingletonArray(id);
894         uint256[] memory amounts = _asSingletonArray(amount);
895 
896         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
897 
898         _balances[id][to] += amount;
899         emit TransferSingle(operator, address(0), to, id, amount);
900 
901         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
902 
903         _doSafeTransferAcceptanceCheck(
904             operator,
905             address(0),
906             to,
907             id,
908             amount,
909             data
910         );
911     }
912 
913     /**
914      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
915      *
916      * Emits a {TransferBatch} event.
917      *
918      * Requirements:
919      *
920      * - `ids` and `amounts` must have the same length.
921      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
922      * acceptance magic value.
923      */
924     function _mintBatch(
925         address to,
926         uint256[] memory ids,
927         uint256[] memory amounts,
928         bytes memory data
929     ) internal virtual {
930         require(to != address(0), "ERC1155: mint to the zero address");
931         require(
932             ids.length == amounts.length,
933             "ERC1155: ids and amounts length mismatch"
934         );
935 
936         address operator = _msgSender();
937 
938         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
939 
940         for (uint256 i = 0; i < ids.length; i++) {
941             _balances[ids[i]][to] += amounts[i];
942         }
943 
944         emit TransferBatch(operator, address(0), to, ids, amounts);
945 
946         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
947 
948         _doSafeBatchTransferAcceptanceCheck(
949             operator,
950             address(0),
951             to,
952             ids,
953             amounts,
954             data
955         );
956     }
957 
958     /**
959      * @dev Destroys `amount` tokens of token type `id` from `from`
960      *
961      * Emits a {TransferSingle} event.
962      *
963      * Requirements:
964      *
965      * - `from` cannot be the zero address.
966      * - `from` must have at least `amount` tokens of token type `id`.
967      */
968     function _burn(
969         address from,
970         uint256 id,
971         uint256 amount
972     ) internal virtual {
973         require(from != address(0), "ERC1155: burn from the zero address");
974 
975         address operator = _msgSender();
976         uint256[] memory ids = _asSingletonArray(id);
977         uint256[] memory amounts = _asSingletonArray(amount);
978 
979         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
980 
981         uint256 fromBalance = _balances[id][from];
982         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
983         unchecked {
984             _balances[id][from] = fromBalance - amount;
985         }
986 
987         emit TransferSingle(operator, from, address(0), id, amount);
988 
989         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
990     }
991 
992     /**
993      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
994      *
995      * Emits a {TransferBatch} event.
996      *
997      * Requirements:
998      *
999      * - `ids` and `amounts` must have the same length.
1000      */
1001     function _burnBatch(
1002         address from,
1003         uint256[] memory ids,
1004         uint256[] memory amounts
1005     ) internal virtual {
1006         require(from != address(0), "ERC1155: burn from the zero address");
1007         require(
1008             ids.length == amounts.length,
1009             "ERC1155: ids and amounts length mismatch"
1010         );
1011 
1012         address operator = _msgSender();
1013 
1014         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1015 
1016         for (uint256 i = 0; i < ids.length; i++) {
1017             uint256 id = ids[i];
1018             uint256 amount = amounts[i];
1019 
1020             uint256 fromBalance = _balances[id][from];
1021             require(
1022                 fromBalance >= amount,
1023                 "ERC1155: burn amount exceeds balance"
1024             );
1025             unchecked {
1026                 _balances[id][from] = fromBalance - amount;
1027             }
1028         }
1029 
1030         emit TransferBatch(operator, from, address(0), ids, amounts);
1031 
1032         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1033     }
1034 
1035     /**
1036      * @dev Approve `operator` to operate on all of `owner` tokens
1037      *
1038      * Emits an {ApprovalForAll} event.
1039      */
1040     function _setApprovalForAll(
1041         address owner,
1042         address operator,
1043         bool approved
1044     ) internal virtual {
1045         require(owner != operator, "ERC1155: setting approval status for self");
1046         _operatorApprovals[owner][operator] = approved;
1047         emit ApprovalForAll(owner, operator, approved);
1048     }
1049 
1050     /**
1051      * @dev Hook that is called before any token transfer. This includes minting
1052      * and burning, as well as batched variants.
1053      *
1054      * The same hook is called on both single and batched variants. For single
1055      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1056      *
1057      * Calling conditions (for each `id` and `amount` pair):
1058      *
1059      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1060      * of token type `id` will be  transferred to `to`.
1061      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1062      * for `to`.
1063      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1064      * will be burned.
1065      * - `from` and `to` are never both zero.
1066      * - `ids` and `amounts` have the same, non-zero length.
1067      *
1068      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1069      */
1070     function _beforeTokenTransfer(
1071         address operator,
1072         address from,
1073         address to,
1074         uint256[] memory ids,
1075         uint256[] memory amounts,
1076         bytes memory data
1077     ) internal virtual {}
1078 
1079     /**
1080      * @dev Hook that is called after any token transfer. This includes minting
1081      * and burning, as well as batched variants.
1082      *
1083      * The same hook is called on both single and batched variants. For single
1084      * transfers, the length of the `id` and `amount` arrays will be 1.
1085      *
1086      * Calling conditions (for each `id` and `amount` pair):
1087      *
1088      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1089      * of token type `id` will be  transferred to `to`.
1090      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1091      * for `to`.
1092      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1093      * will be burned.
1094      * - `from` and `to` are never both zero.
1095      * - `ids` and `amounts` have the same, non-zero length.
1096      *
1097      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1098      */
1099     function _afterTokenTransfer(
1100         address operator,
1101         address from,
1102         address to,
1103         uint256[] memory ids,
1104         uint256[] memory amounts,
1105         bytes memory data
1106     ) internal virtual {}
1107 
1108     function _doSafeTransferAcceptanceCheck(
1109         address operator,
1110         address from,
1111         address to,
1112         uint256 id,
1113         uint256 amount,
1114         bytes memory data
1115     ) private {
1116         if (to.isContract()) {
1117             try
1118                 IERC1155Receiver(to).onERC1155Received(
1119                     operator,
1120                     from,
1121                     id,
1122                     amount,
1123                     data
1124                 )
1125             returns (bytes4 response) {
1126                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1127                     revert("ERC1155: ERC1155Receiver rejected tokens");
1128                 }
1129             } catch Error(string memory reason) {
1130                 revert(reason);
1131             } catch {
1132                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1133             }
1134         }
1135     }
1136 
1137     function _doSafeBatchTransferAcceptanceCheck(
1138         address operator,
1139         address from,
1140         address to,
1141         uint256[] memory ids,
1142         uint256[] memory amounts,
1143         bytes memory data
1144     ) private {
1145         if (to.isContract()) {
1146             try
1147                 IERC1155Receiver(to).onERC1155BatchReceived(
1148                     operator,
1149                     from,
1150                     ids,
1151                     amounts,
1152                     data
1153                 )
1154             returns (bytes4 response) {
1155                 if (
1156                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1157                 ) {
1158                     revert("ERC1155: ERC1155Receiver rejected tokens");
1159                 }
1160             } catch Error(string memory reason) {
1161                 revert(reason);
1162             } catch {
1163                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1164             }
1165         }
1166     }
1167 
1168     function _asSingletonArray(uint256 element)
1169         private
1170         pure
1171         returns (uint256[] memory)
1172     {
1173         uint256[] memory array = new uint256[](1);
1174         array[0] = element;
1175 
1176         return array;
1177     }
1178 }
1179 
1180 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.2
1181 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1182 
1183 pragma solidity ^0.8.0;
1184 
1185 /**
1186  * @dev String operations.
1187  */
1188 library Strings {
1189     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1190     uint8 private constant _ADDRESS_LENGTH = 20;
1191 
1192     /**
1193      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1194      */
1195     function toString(uint256 value) internal pure returns (string memory) {
1196         // Inspired by OraclizeAPI's implementation - MIT licence
1197         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1198 
1199         if (value == 0) {
1200             return "0";
1201         }
1202         uint256 temp = value;
1203         uint256 digits;
1204         while (temp != 0) {
1205             digits++;
1206             temp /= 10;
1207         }
1208         bytes memory buffer = new bytes(digits);
1209         while (value != 0) {
1210             digits -= 1;
1211             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1212             value /= 10;
1213         }
1214         return string(buffer);
1215     }
1216 
1217     /**
1218      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1219      */
1220     function toHexString(uint256 value) internal pure returns (string memory) {
1221         if (value == 0) {
1222             return "0x00";
1223         }
1224         uint256 temp = value;
1225         uint256 length = 0;
1226         while (temp != 0) {
1227             length++;
1228             temp >>= 8;
1229         }
1230         return toHexString(value, length);
1231     }
1232 
1233     /**
1234      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1235      */
1236     function toHexString(uint256 value, uint256 length)
1237         internal
1238         pure
1239         returns (string memory)
1240     {
1241         bytes memory buffer = new bytes(2 * length + 2);
1242         buffer[0] = "0";
1243         buffer[1] = "x";
1244         for (uint256 i = 2 * length + 1; i > 1; --i) {
1245             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1246             value >>= 4;
1247         }
1248         require(value == 0, "Strings: hex length insufficient");
1249         return string(buffer);
1250     }
1251 
1252     /**
1253      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1254      */
1255     function toHexString(address addr) internal pure returns (string memory) {
1256         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1257     }
1258 }
1259 
1260 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.2
1261 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1262 
1263 pragma solidity ^0.8.0;
1264 
1265 /**
1266  * @dev Contract module which provides a basic access control mechanism, where
1267  * there is an account (an owner) that can be granted exclusive access to
1268  * specific functions.
1269  *
1270  * By default, the owner account will be the one that deploys the contract. This
1271  * can later be changed with {transferOwnership}.
1272  *
1273  * This module is used through inheritance. It will make available the modifier
1274  * `onlyOwner`, which can be applied to your functions to restrict their use to
1275  * the owner.
1276  */
1277 abstract contract Ownable is Context {
1278     address private _owner;
1279 
1280     event OwnershipTransferred(
1281         address indexed previousOwner,
1282         address indexed newOwner
1283     );
1284 
1285     /**
1286      * @dev Initializes the contract setting the deployer as the initial owner.
1287      */
1288     constructor() {
1289         _transferOwnership(_msgSender());
1290     }
1291 
1292     /**
1293      * @dev Throws if called by any account other than the owner.
1294      */
1295     modifier onlyOwner() {
1296         _checkOwner();
1297         _;
1298     }
1299 
1300     /**
1301      * @dev Returns the address of the current owner.
1302      */
1303     function owner() public view virtual returns (address) {
1304         return _owner;
1305     }
1306 
1307     /**
1308      * @dev Throws if the sender is not the owner.
1309      */
1310     function _checkOwner() internal view virtual {
1311         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1312     }
1313 
1314     /**
1315      * @dev Leaves the contract without owner. It will not be possible to call
1316      * `onlyOwner` functions anymore. Can only be called by the current owner.
1317      *
1318      * NOTE: Renouncing ownership will leave the contract without an owner,
1319      * thereby removing any functionality that is only available to the owner.
1320      */
1321     function renounceOwnership() public virtual onlyOwner {
1322         _transferOwnership(address(0));
1323     }
1324 
1325     /**
1326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1327      * Can only be called by the current owner.
1328      */
1329     function transferOwnership(address newOwner) public virtual onlyOwner {
1330         require(
1331             newOwner != address(0),
1332             "Ownable: new owner is the zero address"
1333         );
1334         _transferOwnership(newOwner);
1335     }
1336 
1337     /**
1338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1339      * Internal function without access restriction.
1340      */
1341     function _transferOwnership(address newOwner) internal virtual {
1342         address oldOwner = _owner;
1343         _owner = newOwner;
1344         emit OwnershipTransferred(oldOwner, newOwner);
1345     }
1346 }
1347 
1348 // File @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol@v4.7.2
1349 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 /**
1354  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1355  *
1356  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1357  * clearly identified. Note: While a totalSupply of 1 might mean the
1358  * corresponding is an NFT, there is no guarantees that no other token with the
1359  * same id are not going to be minted.
1360  */
1361 abstract contract ERC1155Supply is ERC1155 {
1362     mapping(uint256 => uint256) private _totalSupply;
1363 
1364     /**
1365      * @dev Total amount of tokens in with a given id.
1366      */
1367     function totalSupply(uint256 id) public view virtual returns (uint256) {
1368         return _totalSupply[id];
1369     }
1370 
1371     /**
1372      * @dev Indicates whether any token exist with a given id, or not.
1373      */
1374     function exists(uint256 id) public view virtual returns (bool) {
1375         return ERC1155Supply.totalSupply(id) > 0;
1376     }
1377 
1378     /**
1379      * @dev See {ERC1155-_beforeTokenTransfer}.
1380      */
1381     function _beforeTokenTransfer(
1382         address operator,
1383         address from,
1384         address to,
1385         uint256[] memory ids,
1386         uint256[] memory amounts,
1387         bytes memory data
1388     ) internal virtual override {
1389         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1390 
1391         if (from == address(0)) {
1392             for (uint256 i = 0; i < ids.length; ++i) {
1393                 _totalSupply[ids[i]] += amounts[i];
1394             }
1395         }
1396 
1397         if (to == address(0)) {
1398             for (uint256 i = 0; i < ids.length; ++i) {
1399                 uint256 id = ids[i];
1400                 uint256 amount = amounts[i];
1401                 uint256 supply = _totalSupply[id];
1402                 require(
1403                     supply >= amount,
1404                     "ERC1155: burn amount exceeds totalSupply"
1405                 );
1406                 unchecked {
1407                     _totalSupply[id] = supply - amount;
1408                 }
1409             }
1410         }
1411     }
1412 }
1413 
1414 pragma solidity ^0.8.6;
1415 
1416 contract MythicArtifacts is ERC1155, Ownable {
1417     using Strings for uint256;
1418 
1419     address private evolutionContract = 0x0B0237aD59e1BbCb611fdf0c9Fa07350C3f41e87;
1420     address private gatewayContract = 0xf85906f89aecA56aff6D34790677595aF6B4FBD7;
1421 
1422     string public baseURI = "https://apeliquid.io/mythicartifacts/json/";
1423     string public name = "Mythic Artifacts";
1424 
1425     mapping(uint256 => bool) public validArtifactTypes;
1426 
1427     event SetBaseURI(string indexed baseURI);
1428 
1429     constructor(string memory _baseURI) ERC1155(_baseURI) {
1430         validArtifactTypes[1] = true;
1431         validArtifactTypes[2] = true;
1432         validArtifactTypes[3] = true;
1433         validArtifactTypes[4] = true;
1434         validArtifactTypes[5] = true;
1435         validArtifactTypes[6] = true; // artifact 6
1436         validArtifactTypes[7] = true;
1437         validArtifactTypes[8] = true;
1438         validArtifactTypes[9] = true;
1439         validArtifactTypes[10] = true;
1440         validArtifactTypes[11] = true; // Divine
1441         validArtifactTypes[12] = true; 
1442         validArtifactTypes[13] = true;
1443         validArtifactTypes[14] = true; 
1444         validArtifactTypes[15] = true;
1445         validArtifactTypes[16] = true;
1446         validArtifactTypes[17] = true;
1447         validArtifactTypes[18] = true;
1448         validArtifactTypes[42] = true; // Legendary
1449         emit SetBaseURI(baseURI);
1450     }
1451 
1452     /**
1453      * @notice Airdrop tokens to multiple addresses at once.
1454      * No strict supply is set in the contract. All methods are ownerOnly,
1455      * it is up to the owner to control the supply by not minting
1456      * past their desired number for each token.
1457      * @dev Airdrop tokens to each address in the calldata list,
1458      * setting the supply to the length of the list + previously minted (airdropped) supply.
1459      * Add an address once per token you would like to send.
1460      * @param _tokenIds The tokenIDs to send
1461      * @param _addresses address[] list of wallets to send tokens to
1462      * @param _qty The qty of each token we are sending
1463      */
1464     function airdrop(
1465         uint256[] memory _tokenIds,
1466         address[] calldata _addresses,
1467         uint256[] memory _qty
1468     ) external onlyOwner {
1469         for (uint256 i = 0; i < _addresses.length; i++) {
1470             // Mint address, tokenid, amount
1471             _mint(_addresses[i], _tokenIds[i], _qty[i], "Mint-a-palooza!");
1472         }
1473     }
1474 
1475     /**
1476      * @notice Sends multiple tokens to a single address
1477      * @param _tokenID The id of the token to send
1478      * @param _address The address to receive the tokens
1479      * @param _quantity How many to send she receiver
1480      */
1481     function batchMint(
1482         uint256 _tokenID,
1483         address _address,
1484         uint256 _quantity
1485     ) external onlyOwner {
1486         _mint(_address, _tokenID, _quantity, "");
1487     }
1488 
1489     /**
1490      * @notice Sets the name of the contract
1491      * @param _name the name to set
1492      */
1493     function setName(string memory _name) public onlyOwner {
1494         name = _name;
1495     }
1496 
1497     /**
1498      * @notice Sets the evolution contract address
1499      * @param evolutionContractAddress the address to set
1500      */
1501     function setEvolutionContract(address evolutionContractAddress)
1502         external
1503         onlyOwner
1504     {
1505         evolutionContract = evolutionContractAddress;
1506     }
1507 
1508     /**
1509      * @notice Sets the gateway contract address
1510      * @param aContractAddress the address to set
1511      */
1512     function setGatewayContract(address aContractAddress)
1513         external
1514         onlyOwner
1515     {
1516         gatewayContract = aContractAddress;
1517     }
1518 
1519     /**
1520      * @notice Burn n artifacts (self burn)
1521      * @param tokenId the token to burn
1522      * @param totalToBurn how many?
1523      */
1524     function burnMyArtifacts(
1525         uint256 tokenId,
1526         uint256 totalToBurn
1527     ) external {
1528         require(validArtifactTypes[tokenId], "Invalid token");
1529         require(totalToBurn > 0, "Not enough tokens");
1530         _burn(msg.sender, tokenId, totalToBurn);
1531     }
1532 
1533     /**
1534      * @notice Burn n artifacts (Evolution Contract)
1535      * @param tokenOwner the address of the owner
1536      * @param tokenId the token to burn
1537      * @param totalToBurn how many?
1538      */
1539     function burnArtifacts(
1540         address tokenOwner,
1541         uint256 tokenId,
1542         uint256 totalToBurn
1543     ) external {
1544         require(msg.sender == evolutionContract, "Invalid Evolution Contract");
1545         require(validArtifactTypes[tokenId], "Invalid token");
1546         require(totalToBurn > 0, "Not enough tokens");
1547         _burn(tokenOwner, tokenId, totalToBurn);
1548     }
1549 
1550     /**
1551      * @notice Burn 1 artifact (Open Mythic Gateway)
1552      * @param tokenOwner the address of the owner
1553      * @param tokenId the token to burn
1554      */
1555     function openGateway(
1556         address tokenOwner,
1557         uint256 tokenId
1558     ) external {
1559         require(msg.sender == gatewayContract, "Invalid Gateway Contract");
1560         require(validArtifactTypes[tokenId], "Invalid token");
1561         _burn(tokenOwner, tokenId, 1);
1562     }
1563 
1564     function updateBaseUri(string memory _baseURI) external onlyOwner {
1565         baseURI = _baseURI;
1566         emit SetBaseURI(baseURI);
1567     }
1568 
1569     function uri(uint256 typeId) public view override returns (string memory) {
1570         require(
1571             validArtifactTypes[typeId],
1572             "URI requested for invalid artifact type"
1573         );
1574         return
1575             bytes(baseURI).length > 0
1576                 ? string(abi.encodePacked(baseURI, typeId.toString()))
1577                 : baseURI;
1578     }
1579 }