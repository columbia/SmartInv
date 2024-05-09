1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.16;
4 
5 /*
6     _____           __  .__    .__
7    /     \ ___.__._/  |_|  |__ |__| ____
8   /  \ /  <   |  |\   __\  |  \|  |/ ___\
9  /    Y    \___  | |  | |   Y  \  \  \___
10  \____|__  / ____| |__| |___|  /__|\___  >
11          \/\/                \/        \/
12 
13 Standing on the shoulders of giants -- Yuga Labs & CryptoPunks
14     * Written by Aleph 0ne for the ApeLiquid community *
15  * Mythic Chests by ApeLiquid.io (with OpenSea Creator Fees) *
16 */
17 
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.7.2
40 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
41 
42 /**
43  * @dev Required interface of an ERC1155 compliant contract, as defined in the
44  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
45  *
46  * _Available since v3.1._
47  */
48 interface IERC1155 is IERC165 {
49     /**
50      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
51      */
52     event TransferSingle(
53         address indexed operator,
54         address indexed from,
55         address indexed to,
56         uint256 id,
57         uint256 value
58     );
59 
60     /**
61      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
62      * transfers.
63      */
64     event TransferBatch(
65         address indexed operator,
66         address indexed from,
67         address indexed to,
68         uint256[] ids,
69         uint256[] values
70     );
71 
72     /**
73      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
74      * `approved`.
75      */
76     event ApprovalForAll(
77         address indexed account,
78         address indexed operator,
79         bool approved
80     );
81 
82     /**
83      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
84      *
85      * If an {URI} event was emitted for `id`, the standard
86      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
87      * returned by {IERC1155MetadataURI-uri}.
88      */
89     event URI(string value, uint256 indexed id);
90 
91     /**
92      * @dev Returns the amount of tokens of token type `id` owned by `account`.
93      *
94      * Requirements:
95      *
96      * - `account` cannot be the zero address.
97      */
98     function balanceOf(address account, uint256 id)
99         external
100         view
101         returns (uint256);
102 
103     /**
104      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
105      *
106      * Requirements:
107      *
108      * - `accounts` and `ids` must have the same length.
109      */
110     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
111         external
112         view
113         returns (uint256[] memory);
114 
115     /**
116      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
117      *
118      * Emits an {ApprovalForAll} event.
119      *
120      * Requirements:
121      *
122      * - `operator` cannot be the caller.
123      */
124     function setApprovalForAll(address operator, bool approved) external;
125 
126     /**
127      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
128      *
129      * See {setApprovalForAll}.
130      */
131     function isApprovedForAll(address account, address operator)
132         external
133         view
134         returns (bool);
135 
136     /**
137      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
138      *
139      * Emits a {TransferSingle} event.
140      *
141      * Requirements:
142      *
143      * - `to` cannot be the zero address.
144      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
145      * - `from` must have a balance of tokens of type `id` of at least `amount`.
146      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
147      * acceptance magic value.
148      */
149     function safeTransferFrom(
150         address from,
151         address to,
152         uint256 id,
153         uint256 amount,
154         bytes calldata data
155     ) external;
156 
157     /**
158      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
159      *
160      * Emits a {TransferBatch} event.
161      *
162      * Requirements:
163      *
164      * - `ids` and `amounts` must have the same length.
165      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
166      * acceptance magic value.
167      */
168     function safeBatchTransferFrom(
169         address from,
170         address to,
171         uint256[] calldata ids,
172         uint256[] calldata amounts,
173         bytes calldata data
174     ) external;
175 }
176 
177 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.7.2
178 
179 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev _Available since v3.1._
185  */
186 interface IERC1155Receiver is IERC165 {
187     /**
188      * @dev Handles the receipt of a single ERC1155 token type. This function is
189      * called at the end of a `safeTransferFrom` after the balance has been updated.
190      *
191      * NOTE: To accept the transfer, this must return
192      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
193      * (i.e. 0xf23a6e61, or its own function selector).
194      *
195      * @param operator The address which initiated the transfer (i.e. msg.sender)
196      * @param from The address which previously owned the token
197      * @param id The ID of the token being transferred
198      * @param value The amount of tokens being transferred
199      * @param data Additional data with no specified format
200      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
201      */
202     function onERC1155Received(
203         address operator,
204         address from,
205         uint256 id,
206         uint256 value,
207         bytes calldata data
208     ) external returns (bytes4);
209 
210     /**
211      * @dev Handles the receipt of a multiple ERC1155 token types. This function
212      * is called at the end of a `safeBatchTransferFrom` after the balances have
213      * been updated.
214      *
215      * NOTE: To accept the transfer(s), this must return
216      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
217      * (i.e. 0xbc197c81, or its own function selector).
218      *
219      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
220      * @param from The address which previously owned the token
221      * @param ids An array containing ids of each token being transferred (order and length must match values array)
222      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
223      * @param data Additional data with no specified format
224      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
225      */
226     function onERC1155BatchReceived(
227         address operator,
228         address from,
229         uint256[] calldata ids,
230         uint256[] calldata values,
231         bytes calldata data
232     ) external returns (bytes4);
233 }
234 
235 // File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.7.2
236 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
242  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
243  *
244  * _Available since v3.1._
245  */
246 interface IERC1155MetadataURI is IERC1155 {
247     /**
248      * @dev Returns the URI for token type `id`.
249      *
250      * If the `\{id\}` substring is present in the URI, it must be replaced by
251      * clients with the actual token type ID.
252      */
253     function uri(uint256 id) external view returns (string memory);
254 }
255 
256 // File @openzeppelin/contracts/utils/Address.sol@v4.7.2
257 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
258 
259 pragma solidity ^0.8.1;
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      *
282      * [IMPORTANT]
283      * ====
284      * You shouldn't rely on `isContract` to protect against flash loan attacks!
285      *
286      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
287      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
288      * constructor.
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize/address.code.length, which returns 0
293         // for contracts in construction, since the code is only stored at the end
294         // of the constructor execution.
295 
296         return account.code.length > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(
317             address(this).balance >= amount,
318             "Address: insufficient balance"
319         );
320 
321         (bool success, ) = recipient.call{value: amount}("");
322         require(
323             success,
324             "Address: unable to send value, recipient may have reverted"
325         );
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain `call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data)
347         internal
348         returns (bytes memory)
349     {
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
383         return
384             functionCallWithValue(
385                 target,
386                 data,
387                 value,
388                 "Address: low-level call with value failed"
389             );
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
394      * with `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         require(
405             address(this).balance >= value,
406             "Address: insufficient balance for call"
407         );
408         require(isContract(target), "Address: call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.call{value: value}(
411             data
412         );
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(address target, bytes memory data)
423         internal
424         view
425         returns (bytes memory)
426     {
427         return
428             functionStaticCall(
429                 target,
430                 data,
431                 "Address: low-level static call failed"
432             );
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(
442         address target,
443         bytes memory data,
444         string memory errorMessage
445     ) internal view returns (bytes memory) {
446         require(isContract(target), "Address: static call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.staticcall(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(address target, bytes memory data)
459         internal
460         returns (bytes memory)
461     {
462         return
463             functionDelegateCall(
464                 target,
465                 data,
466                 "Address: low-level delegate call failed"
467             );
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(
477         address target,
478         bytes memory data,
479         string memory errorMessage
480     ) internal returns (bytes memory) {
481         require(isContract(target), "Address: delegate call to non-contract");
482 
483         (bool success, bytes memory returndata) = target.delegatecall(data);
484         return verifyCallResult(success, returndata, errorMessage);
485     }
486 
487     /**
488      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
489      * revert reason using the provided one.
490      *
491      * _Available since v4.3._
492      */
493     function verifyCallResult(
494         bool success,
495         bytes memory returndata,
496         string memory errorMessage
497     ) internal pure returns (bytes memory) {
498         if (success) {
499             return returndata;
500         } else {
501             // Look for revert reason and bubble it up if present
502             if (returndata.length > 0) {
503                 // The easiest way to bubble the revert reason is using memory via assembly
504                 /// @solidity memory-safe-assembly
505                 assembly {
506                     let returndata_size := mload(returndata)
507                     revert(add(32, returndata), returndata_size)
508                 }
509             } else {
510                 revert(errorMessage);
511             }
512         }
513     }
514 }
515 
516 // File @openzeppelin/contracts/utils/Context.sol@v4.7.2
517 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev Provides information about the current execution context, including the
523  * sender of the transaction and its data. While these are generally available
524  * via msg.sender and msg.data, they should not be accessed in such a direct
525  * manner, since when dealing with meta-transactions the account sending and
526  * paying for execution may not be the actual sender (as far as an application
527  * is concerned).
528  *
529  * This contract is only required for intermediate, library-like contracts.
530  */
531 abstract contract Context {
532     function _msgSender() internal view virtual returns (address) {
533         return msg.sender;
534     }
535 
536     function _msgData() internal view virtual returns (bytes calldata) {
537         return msg.data;
538     }
539 }
540 
541 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.2
542 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev Implementation of the {IERC165} interface.
548  *
549  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
550  * for the additional interface id that will be supported. For example:
551  *
552  * ```solidity
553  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
555  * }
556  * ```
557  *
558  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
559  */
560 abstract contract ERC165 is IERC165 {
561     /**
562      * @dev See {IERC165-supportsInterface}.
563      */
564     function supportsInterface(bytes4 interfaceId)
565         public
566         view
567         virtual
568         override
569         returns (bool)
570     {
571         return interfaceId == type(IERC165).interfaceId;
572     }
573 }
574 
575 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.7.2
576 
577 pragma solidity ^0.8.0;
578 
579 /**
580  * @dev Implementation of the basic standard multi-token.
581  * See https://eips.ethereum.org/EIPS/eip-1155
582  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
583  *
584  * _Available since v3.1._
585  */
586 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
587     using Address for address;
588 
589     // Mapping from token ID to account balances
590     mapping(uint256 => mapping(address => uint256)) private _balances;
591 
592     // Mapping from account to operator approvals
593     mapping(address => mapping(address => bool)) private _operatorApprovals;
594 
595     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
596     string private _uri;
597 
598     /**
599      * @dev See {_setURI}.
600      */
601     constructor(string memory uri_) {
602         _setURI(uri_);
603     }
604 
605     /**
606      * @dev See {IERC165-supportsInterface}.
607      */
608     function supportsInterface(bytes4 interfaceId)
609         public
610         view
611         virtual
612         override(ERC165, IERC165)
613         returns (bool)
614     {
615         return
616             interfaceId == type(IERC1155).interfaceId ||
617             interfaceId == type(IERC1155MetadataURI).interfaceId ||
618             super.supportsInterface(interfaceId);
619     }
620 
621     /**
622      * @dev See {IERC1155MetadataURI-uri}.
623      *
624      * This implementation returns the same URI for *all* token types. It relies
625      * on the token type ID substitution mechanism
626      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
627      *
628      * Clients calling this function must replace the `\{id\}` substring with the
629      * actual token type ID.
630      */
631     function uri(uint256) public view virtual override returns (string memory) {
632         return _uri;
633     }
634 
635     /**
636      * @dev See {IERC1155-balanceOf}.
637      *
638      * Requirements:
639      *
640      * - `account` cannot be the zero address.
641      */
642     function balanceOf(address account, uint256 id)
643         public
644         view
645         virtual
646         override
647         returns (uint256)
648     {
649         require(
650             account != address(0),
651             "ERC1155: address zero is not a valid owner"
652         );
653         return _balances[id][account];
654     }
655 
656     /**
657      * @dev See {IERC1155-balanceOfBatch}.
658      *
659      * Requirements:
660      *
661      * - `accounts` and `ids` must have the same length.
662      */
663     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
664         public
665         view
666         virtual
667         override
668         returns (uint256[] memory)
669     {
670         require(
671             accounts.length == ids.length,
672             "ERC1155: accounts and ids length mismatch"
673         );
674 
675         uint256[] memory batchBalances = new uint256[](accounts.length);
676 
677         for (uint256 i = 0; i < accounts.length; ++i) {
678             batchBalances[i] = balanceOf(accounts[i], ids[i]);
679         }
680 
681         return batchBalances;
682     }
683 
684     /**
685      * @dev See {IERC1155-setApprovalForAll}.
686      */
687     function setApprovalForAll(address operator, bool approved)
688         public
689         virtual
690         override
691     {
692         _setApprovalForAll(_msgSender(), operator, approved);
693     }
694 
695     /**
696      * @dev See {IERC1155-isApprovedForAll}.
697      */
698     function isApprovedForAll(address account, address operator)
699         public
700         view
701         virtual
702         override
703         returns (bool)
704     {
705         return _operatorApprovals[account][operator];
706     }
707 
708     /**
709      * @dev See {IERC1155-safeTransferFrom}.
710      */
711     function safeTransferFrom(
712         address from,
713         address to,
714         uint256 id,
715         uint256 amount,
716         bytes memory data
717     ) public virtual override {
718         require(
719             from == _msgSender() || isApprovedForAll(from, _msgSender()),
720             "ERC1155: caller is not token owner nor approved"
721         );
722         _safeTransferFrom(from, to, id, amount, data);
723     }
724 
725     /**
726      * @dev See {IERC1155-safeBatchTransferFrom}.
727      */
728     function safeBatchTransferFrom(
729         address from,
730         address to,
731         uint256[] memory ids,
732         uint256[] memory amounts,
733         bytes memory data
734     ) public virtual override {
735         require(
736             from == _msgSender() || isApprovedForAll(from, _msgSender()),
737             "ERC1155: caller is not token owner nor approved"
738         );
739         _safeBatchTransferFrom(from, to, ids, amounts, data);
740     }
741 
742     /**
743      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
744      *
745      * Emits a {TransferSingle} event.
746      *
747      * Requirements:
748      *
749      * - `to` cannot be the zero address.
750      * - `from` must have a balance of tokens of type `id` of at least `amount`.
751      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
752      * acceptance magic value.
753      */
754     function _safeTransferFrom(
755         address from,
756         address to,
757         uint256 id,
758         uint256 amount,
759         bytes memory data
760     ) internal virtual {
761         require(to != address(0), "ERC1155: transfer to the zero address");
762 
763         address operator = _msgSender();
764         uint256[] memory ids = _asSingletonArray(id);
765         uint256[] memory amounts = _asSingletonArray(amount);
766 
767         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
768 
769         uint256 fromBalance = _balances[id][from];
770         require(
771             fromBalance >= amount,
772             "ERC1155: insufficient balance for transfer"
773         );
774         unchecked {
775             _balances[id][from] = fromBalance - amount;
776         }
777         _balances[id][to] += amount;
778 
779         emit TransferSingle(operator, from, to, id, amount);
780 
781         _afterTokenTransfer(operator, from, to, ids, amounts, data);
782 
783         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
784     }
785 
786     /**
787      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
788      *
789      * Emits a {TransferBatch} event.
790      *
791      * Requirements:
792      *
793      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
794      * acceptance magic value.
795      */
796     function _safeBatchTransferFrom(
797         address from,
798         address to,
799         uint256[] memory ids,
800         uint256[] memory amounts,
801         bytes memory data
802     ) internal virtual {
803         require(
804             ids.length == amounts.length,
805             "ERC1155: ids and amounts length mismatch"
806         );
807         require(to != address(0), "ERC1155: transfer to the zero address");
808 
809         address operator = _msgSender();
810 
811         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
812 
813         for (uint256 i = 0; i < ids.length; ++i) {
814             uint256 id = ids[i];
815             uint256 amount = amounts[i];
816 
817             uint256 fromBalance = _balances[id][from];
818             require(
819                 fromBalance >= amount,
820                 "ERC1155: insufficient balance for transfer"
821             );
822             unchecked {
823                 _balances[id][from] = fromBalance - amount;
824             }
825             _balances[id][to] += amount;
826         }
827 
828         emit TransferBatch(operator, from, to, ids, amounts);
829 
830         _afterTokenTransfer(operator, from, to, ids, amounts, data);
831 
832         _doSafeBatchTransferAcceptanceCheck(
833             operator,
834             from,
835             to,
836             ids,
837             amounts,
838             data
839         );
840     }
841 
842     /**
843      * @dev Sets a new URI for all token types, by relying on the token type ID
844      * substitution mechanism
845      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
846      *
847      * By this mechanism, any occurrence of the `\{id\}` substring in either the
848      * URI or any of the amounts in the JSON file at said URI will be replaced by
849      * clients with the token type ID.
850      *
851      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
852      * interpreted by clients as
853      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
854      * for token type ID 0x4cce0.
855      *
856      * See {uri}.
857      *
858      * Because these URIs cannot be meaningfully represented by the {URI} event,
859      * this function emits no events.
860      */
861     function _setURI(string memory newuri) internal virtual {
862         _uri = newuri;
863     }
864 
865     /**
866      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
867      *
868      * Emits a {TransferSingle} event.
869      *
870      * Requirements:
871      *
872      * - `to` cannot be the zero address.
873      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
874      * acceptance magic value.
875      */
876     function _mint(
877         address to,
878         uint256 id,
879         uint256 amount,
880         bytes memory data
881     ) internal virtual {
882         require(to != address(0), "ERC1155: mint to the zero address");
883 
884         address operator = _msgSender();
885         uint256[] memory ids = _asSingletonArray(id);
886         uint256[] memory amounts = _asSingletonArray(amount);
887 
888         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
889 
890         _balances[id][to] += amount;
891         emit TransferSingle(operator, address(0), to, id, amount);
892 
893         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
894 
895         _doSafeTransferAcceptanceCheck(
896             operator,
897             address(0),
898             to,
899             id,
900             amount,
901             data
902         );
903     }
904 
905     /**
906      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
907      *
908      * Emits a {TransferBatch} event.
909      *
910      * Requirements:
911      *
912      * - `ids` and `amounts` must have the same length.
913      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
914      * acceptance magic value.
915      */
916     function _mintBatch(
917         address to,
918         uint256[] memory ids,
919         uint256[] memory amounts,
920         bytes memory data
921     ) internal virtual {
922         require(to != address(0), "ERC1155: mint to the zero address");
923         require(
924             ids.length == amounts.length,
925             "ERC1155: ids and amounts length mismatch"
926         );
927 
928         address operator = _msgSender();
929 
930         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
931 
932         for (uint256 i = 0; i < ids.length; i++) {
933             _balances[ids[i]][to] += amounts[i];
934         }
935 
936         emit TransferBatch(operator, address(0), to, ids, amounts);
937 
938         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
939 
940         _doSafeBatchTransferAcceptanceCheck(
941             operator,
942             address(0),
943             to,
944             ids,
945             amounts,
946             data
947         );
948     }
949 
950     /**
951      * @dev Destroys `amount` tokens of token type `id` from `from`
952      *
953      * Emits a {TransferSingle} event.
954      *
955      * Requirements:
956      *
957      * - `from` cannot be the zero address.
958      * - `from` must have at least `amount` tokens of token type `id`.
959      */
960     function _burn(
961         address from,
962         uint256 id,
963         uint256 amount
964     ) internal virtual {
965         require(from != address(0), "ERC1155: burn from the zero address");
966 
967         address operator = _msgSender();
968         uint256[] memory ids = _asSingletonArray(id);
969         uint256[] memory amounts = _asSingletonArray(amount);
970 
971         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
972 
973         uint256 fromBalance = _balances[id][from];
974         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
975         unchecked {
976             _balances[id][from] = fromBalance - amount;
977         }
978 
979         emit TransferSingle(operator, from, address(0), id, amount);
980 
981         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
982     }
983 
984     /**
985      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
986      *
987      * Emits a {TransferBatch} event.
988      *
989      * Requirements:
990      *
991      * - `ids` and `amounts` must have the same length.
992      */
993     function _burnBatch(
994         address from,
995         uint256[] memory ids,
996         uint256[] memory amounts
997     ) internal virtual {
998         require(from != address(0), "ERC1155: burn from the zero address");
999         require(
1000             ids.length == amounts.length,
1001             "ERC1155: ids and amounts length mismatch"
1002         );
1003 
1004         address operator = _msgSender();
1005 
1006         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1007 
1008         for (uint256 i = 0; i < ids.length; i++) {
1009             uint256 id = ids[i];
1010             uint256 amount = amounts[i];
1011 
1012             uint256 fromBalance = _balances[id][from];
1013             require(
1014                 fromBalance >= amount,
1015                 "ERC1155: burn amount exceeds balance"
1016             );
1017             unchecked {
1018                 _balances[id][from] = fromBalance - amount;
1019             }
1020         }
1021 
1022         emit TransferBatch(operator, from, address(0), ids, amounts);
1023 
1024         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1025     }
1026 
1027     /**
1028      * @dev Approve `operator` to operate on all of `owner` tokens
1029      *
1030      * Emits an {ApprovalForAll} event.
1031      */
1032     function _setApprovalForAll(
1033         address owner,
1034         address operator,
1035         bool approved
1036     ) internal virtual {
1037         require(owner != operator, "ERC1155: setting approval status for self");
1038         _operatorApprovals[owner][operator] = approved;
1039         emit ApprovalForAll(owner, operator, approved);
1040     }
1041 
1042     /**
1043      * @dev Hook that is called before any token transfer. This includes minting
1044      * and burning, as well as batched variants.
1045      *
1046      * The same hook is called on both single and batched variants. For single
1047      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1048      *
1049      * Calling conditions (for each `id` and `amount` pair):
1050      *
1051      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1052      * of token type `id` will be  transferred to `to`.
1053      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1054      * for `to`.
1055      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1056      * will be burned.
1057      * - `from` and `to` are never both zero.
1058      * - `ids` and `amounts` have the same, non-zero length.
1059      *
1060      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1061      */
1062     function _beforeTokenTransfer(
1063         address operator,
1064         address from,
1065         address to,
1066         uint256[] memory ids,
1067         uint256[] memory amounts,
1068         bytes memory data
1069     ) internal virtual {}
1070 
1071     /**
1072      * @dev Hook that is called after any token transfer. This includes minting
1073      * and burning, as well as batched variants.
1074      *
1075      * The same hook is called on both single and batched variants. For single
1076      * transfers, the length of the `id` and `amount` arrays will be 1.
1077      *
1078      * Calling conditions (for each `id` and `amount` pair):
1079      *
1080      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1081      * of token type `id` will be  transferred to `to`.
1082      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1083      * for `to`.
1084      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1085      * will be burned.
1086      * - `from` and `to` are never both zero.
1087      * - `ids` and `amounts` have the same, non-zero length.
1088      *
1089      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1090      */
1091     function _afterTokenTransfer(
1092         address operator,
1093         address from,
1094         address to,
1095         uint256[] memory ids,
1096         uint256[] memory amounts,
1097         bytes memory data
1098     ) internal virtual {}
1099 
1100     function _doSafeTransferAcceptanceCheck(
1101         address operator,
1102         address from,
1103         address to,
1104         uint256 id,
1105         uint256 amount,
1106         bytes memory data
1107     ) private {
1108         if (to.isContract()) {
1109             try
1110                 IERC1155Receiver(to).onERC1155Received(
1111                     operator,
1112                     from,
1113                     id,
1114                     amount,
1115                     data
1116                 )
1117             returns (bytes4 response) {
1118                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1119                     revert("ERC1155: ERC1155Receiver rejected tokens");
1120                 }
1121             } catch Error(string memory reason) {
1122                 revert(reason);
1123             } catch {
1124                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1125             }
1126         }
1127     }
1128 
1129     function _doSafeBatchTransferAcceptanceCheck(
1130         address operator,
1131         address from,
1132         address to,
1133         uint256[] memory ids,
1134         uint256[] memory amounts,
1135         bytes memory data
1136     ) private {
1137         if (to.isContract()) {
1138             try
1139                 IERC1155Receiver(to).onERC1155BatchReceived(
1140                     operator,
1141                     from,
1142                     ids,
1143                     amounts,
1144                     data
1145                 )
1146             returns (bytes4 response) {
1147                 if (
1148                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1149                 ) {
1150                     revert("ERC1155: ERC1155Receiver rejected tokens");
1151                 }
1152             } catch Error(string memory reason) {
1153                 revert(reason);
1154             } catch {
1155                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1156             }
1157         }
1158     }
1159 
1160     function _asSingletonArray(uint256 element)
1161         private
1162         pure
1163         returns (uint256[] memory)
1164     {
1165         uint256[] memory array = new uint256[](1);
1166         array[0] = element;
1167 
1168         return array;
1169     }
1170 }
1171 
1172 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.2
1173 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 /**
1178  * @dev String operations.
1179  */
1180 library Strings {
1181     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1182     uint8 private constant _ADDRESS_LENGTH = 20;
1183 
1184     /**
1185      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1186      */
1187     function toString(uint256 value) internal pure returns (string memory) {
1188         // Inspired by OraclizeAPI's implementation - MIT licence
1189         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1190 
1191         if (value == 0) {
1192             return "0";
1193         }
1194         uint256 temp = value;
1195         uint256 digits;
1196         while (temp != 0) {
1197             digits++;
1198             temp /= 10;
1199         }
1200         bytes memory buffer = new bytes(digits);
1201         while (value != 0) {
1202             digits -= 1;
1203             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1204             value /= 10;
1205         }
1206         return string(buffer);
1207     }
1208 
1209     /**
1210      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1211      */
1212     function toHexString(uint256 value) internal pure returns (string memory) {
1213         if (value == 0) {
1214             return "0x00";
1215         }
1216         uint256 temp = value;
1217         uint256 length = 0;
1218         while (temp != 0) {
1219             length++;
1220             temp >>= 8;
1221         }
1222         return toHexString(value, length);
1223     }
1224 
1225     /**
1226      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1227      */
1228     function toHexString(uint256 value, uint256 length)
1229         internal
1230         pure
1231         returns (string memory)
1232     {
1233         bytes memory buffer = new bytes(2 * length + 2);
1234         buffer[0] = "0";
1235         buffer[1] = "x";
1236         for (uint256 i = 2 * length + 1; i > 1; --i) {
1237             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1238             value >>= 4;
1239         }
1240         require(value == 0, "Strings: hex length insufficient");
1241         return string(buffer);
1242     }
1243 
1244     /**
1245      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1246      */
1247     function toHexString(address addr) internal pure returns (string memory) {
1248         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1249     }
1250 }
1251 
1252 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.2
1253 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1254 
1255 pragma solidity ^0.8.0;
1256 
1257 /**
1258  * @dev Contract module which provides a basic access control mechanism, where
1259  * there is an account (an owner) that can be granted exclusive access to
1260  * specific functions.
1261  *
1262  * By default, the owner account will be the one that deploys the contract. This
1263  * can later be changed with {transferOwnership}.
1264  *
1265  * This module is used through inheritance. It will make available the modifier
1266  * `onlyOwner`, which can be applied to your functions to restrict their use to
1267  * the owner.
1268  */
1269 abstract contract Ownable is Context {
1270     address private _owner;
1271 
1272     event OwnershipTransferred(
1273         address indexed previousOwner,
1274         address indexed newOwner
1275     );
1276 
1277     /**
1278      * @dev Initializes the contract setting the deployer as the initial owner.
1279      */
1280     constructor() {
1281         _transferOwnership(_msgSender());
1282     }
1283 
1284     /**
1285      * @dev Throws if called by any account other than the owner.
1286      */
1287     modifier onlyOwner() {
1288         _checkOwner();
1289         _;
1290     }
1291 
1292     /**
1293      * @dev Returns the address of the current owner.
1294      */
1295     function owner() public view virtual returns (address) {
1296         return _owner;
1297     }
1298 
1299     /**
1300      * @dev Throws if the sender is not the owner.
1301      */
1302     function _checkOwner() internal view virtual {
1303         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1304     }
1305 
1306     /**
1307      * @dev Leaves the contract without owner. It will not be possible to call
1308      * `onlyOwner` functions anymore. Can only be called by the current owner.
1309      *
1310      * NOTE: Renouncing ownership will leave the contract without an owner,
1311      * thereby removing any functionality that is only available to the owner.
1312      */
1313     function renounceOwnership() public virtual onlyOwner {
1314         _transferOwnership(address(0));
1315     }
1316 
1317     /**
1318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1319      * Can only be called by the current owner.
1320      */
1321     function transferOwnership(address newOwner) public virtual onlyOwner {
1322         require(
1323             newOwner != address(0),
1324             "Ownable: new owner is the zero address"
1325         );
1326         _transferOwnership(newOwner);
1327     }
1328 
1329     /**
1330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1331      * Internal function without access restriction.
1332      */
1333     function _transferOwnership(address newOwner) internal virtual {
1334         address oldOwner = _owner;
1335         _owner = newOwner;
1336         emit OwnershipTransferred(oldOwner, newOwner);
1337     }
1338 }
1339 
1340 // File @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol@v4.7.2
1341 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 /**
1346  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1347  *
1348  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1349  * clearly identified. Note: While a totalSupply of 1 might mean the
1350  * corresponding is an NFT, there is no guarantees that no other token with the
1351  * same id are not going to be minted.
1352  */
1353 abstract contract ERC1155Supply is ERC1155 {
1354     mapping(uint256 => uint256) private _totalSupply;
1355 
1356     /**
1357      * @dev Total amount of tokens in with a given id.
1358      */
1359     function totalSupply(uint256 id) public view virtual returns (uint256) {
1360         return _totalSupply[id];
1361     }
1362 
1363     /**
1364      * @dev Indicates whether any token exist with a given id, or not.
1365      */
1366     function exists(uint256 id) public view virtual returns (bool) {
1367         return ERC1155Supply.totalSupply(id) > 0;
1368     }
1369 
1370     /**
1371      * @dev See {ERC1155-_beforeTokenTransfer}.
1372      */
1373     function _beforeTokenTransfer(
1374         address operator,
1375         address from,
1376         address to,
1377         uint256[] memory ids,
1378         uint256[] memory amounts,
1379         bytes memory data
1380     ) internal virtual override {
1381         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1382 
1383         if (from == address(0)) {
1384             for (uint256 i = 0; i < ids.length; ++i) {
1385                 _totalSupply[ids[i]] += amounts[i];
1386             }
1387         }
1388 
1389         if (to == address(0)) {
1390             for (uint256 i = 0; i < ids.length; ++i) {
1391                 uint256 id = ids[i];
1392                 uint256 amount = amounts[i];
1393                 uint256 supply = _totalSupply[id];
1394                 require(
1395                     supply >= amount,
1396                     "ERC1155: burn amount exceeds totalSupply"
1397                 );
1398                 unchecked {
1399                     _totalSupply[id] = supply - amount;
1400                 }
1401             }
1402         }
1403     }
1404 }
1405 
1406 // SafeMath
1407 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1408 
1409 pragma solidity ^0.8.0;
1410 
1411 // CAUTION
1412 // This version of SafeMath should only be used with Solidity 0.8 or later,
1413 // because it relies on the compiler's built in overflow checks.
1414 
1415 /**
1416  * @dev Wrappers over Solidity's arithmetic operations.
1417  *
1418  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1419  * now has built in overflow checking.
1420  */
1421 library SafeMath {
1422     /**
1423      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1424      *
1425      * _Available since v3.4._
1426      */
1427     function tryAdd(uint256 a, uint256 b)
1428         internal
1429         pure
1430         returns (bool, uint256)
1431     {
1432         unchecked {
1433             uint256 c = a + b;
1434             if (c < a) return (false, 0);
1435             return (true, c);
1436         }
1437     }
1438 
1439     /**
1440      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1441      *
1442      * _Available since v3.4._
1443      */
1444     function trySub(uint256 a, uint256 b)
1445         internal
1446         pure
1447         returns (bool, uint256)
1448     {
1449         unchecked {
1450             if (b > a) return (false, 0);
1451             return (true, a - b);
1452         }
1453     }
1454 
1455     /**
1456      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1457      *
1458      * _Available since v3.4._
1459      */
1460     function tryMul(uint256 a, uint256 b)
1461         internal
1462         pure
1463         returns (bool, uint256)
1464     {
1465         unchecked {
1466             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1467             // benefit is lost if 'b' is also tested.
1468             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1469             if (a == 0) return (true, 0);
1470             uint256 c = a * b;
1471             if (c / a != b) return (false, 0);
1472             return (true, c);
1473         }
1474     }
1475 
1476     /**
1477      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1478      *
1479      * _Available since v3.4._
1480      */
1481     function tryDiv(uint256 a, uint256 b)
1482         internal
1483         pure
1484         returns (bool, uint256)
1485     {
1486         unchecked {
1487             if (b == 0) return (false, 0);
1488             return (true, a / b);
1489         }
1490     }
1491 
1492     /**
1493      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1494      *
1495      * _Available since v3.4._
1496      */
1497     function tryMod(uint256 a, uint256 b)
1498         internal
1499         pure
1500         returns (bool, uint256)
1501     {
1502         unchecked {
1503             if (b == 0) return (false, 0);
1504             return (true, a % b);
1505         }
1506     }
1507 
1508     /**
1509      * @dev Returns the addition of two unsigned integers, reverting on
1510      * overflow.
1511      *
1512      * Counterpart to Solidity's `+` operator.
1513      *
1514      * Requirements:
1515      *
1516      * - Addition cannot overflow.
1517      */
1518     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1519         return a + b;
1520     }
1521 
1522     /**
1523      * @dev Returns the subtraction of two unsigned integers, reverting on
1524      * overflow (when the result is negative).
1525      *
1526      * Counterpart to Solidity's `-` operator.
1527      *
1528      * Requirements:
1529      *
1530      * - Subtraction cannot overflow.
1531      */
1532     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1533         return a - b;
1534     }
1535 
1536     /**
1537      * @dev Returns the multiplication of two unsigned integers, reverting on
1538      * overflow.
1539      *
1540      * Counterpart to Solidity's `*` operator.
1541      *
1542      * Requirements:
1543      *
1544      * - Multiplication cannot overflow.
1545      */
1546     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1547         return a * b;
1548     }
1549 
1550     /**
1551      * @dev Returns the integer division of two unsigned integers, reverting on
1552      * division by zero. The result is rounded towards zero.
1553      *
1554      * Counterpart to Solidity's `/` operator.
1555      *
1556      * Requirements:
1557      *
1558      * - The divisor cannot be zero.
1559      */
1560     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1561         return a / b;
1562     }
1563 
1564     /**
1565      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1566      * reverting when dividing by zero.
1567      *
1568      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1569      * opcode (which leaves remaining gas untouched) while Solidity uses an
1570      * invalid opcode to revert (consuming all remaining gas).
1571      *
1572      * Requirements:
1573      *
1574      * - The divisor cannot be zero.
1575      */
1576     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1577         return a % b;
1578     }
1579 
1580     /**
1581      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1582      * overflow (when the result is negative).
1583      *
1584      * CAUTION: This function is deprecated because it requires allocating memory for the error
1585      * message unnecessarily. For custom revert reasons use {trySub}.
1586      *
1587      * Counterpart to Solidity's `-` operator.
1588      *
1589      * Requirements:
1590      *
1591      * - Subtraction cannot overflow.
1592      */
1593     function sub(
1594         uint256 a,
1595         uint256 b,
1596         string memory errorMessage
1597     ) internal pure returns (uint256) {
1598         unchecked {
1599             require(b <= a, errorMessage);
1600             return a - b;
1601         }
1602     }
1603 
1604     /**
1605      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1606      * division by zero. The result is rounded towards zero.
1607      *
1608      * Counterpart to Solidity's `/` operator. Note: this function uses a
1609      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1610      * uses an invalid opcode to revert (consuming all remaining gas).
1611      *
1612      * Requirements:
1613      *
1614      * - The divisor cannot be zero.
1615      */
1616     function div(
1617         uint256 a,
1618         uint256 b,
1619         string memory errorMessage
1620     ) internal pure returns (uint256) {
1621         unchecked {
1622             require(b > 0, errorMessage);
1623             return a / b;
1624         }
1625     }
1626 
1627     /**
1628      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1629      * reverting with custom message when dividing by zero.
1630      *
1631      * CAUTION: This function is deprecated because it requires allocating memory for the error
1632      * message unnecessarily. For custom revert reasons use {tryMod}.
1633      *
1634      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1635      * opcode (which leaves remaining gas untouched) while Solidity uses an
1636      * invalid opcode to revert (consuming all remaining gas).
1637      *
1638      * Requirements:
1639      *
1640      * - The divisor cannot be zero.
1641      */
1642     function mod(
1643         uint256 a,
1644         uint256 b,
1645         string memory errorMessage
1646     ) internal pure returns (uint256) {
1647         unchecked {
1648             require(b > 0, errorMessage);
1649             return a % b;
1650         }
1651     }
1652 }
1653 
1654 pragma solidity ^0.8.0;
1655 
1656 /**
1657  * @dev Contract module which allows children to implement an emergency stop
1658  * mechanism that can be triggered by an authorized account.
1659  *
1660  * This module is used through inheritance. It will make available the
1661  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1662  * the functions of your contract. Note that they will not be pausable by
1663  * simply including this module, only once the modifiers are put in place.
1664  */
1665 abstract contract Pausable is Context {
1666     /**
1667      * @dev Emitted when the pause is triggered by `account`.
1668      */
1669     event Paused(address account);
1670 
1671     /**
1672      * @dev Emitted when the pause is lifted by `account`.
1673      */
1674     event Unpaused(address account);
1675 
1676     bool private _paused;
1677 
1678     /**
1679      * @dev Initializes the contract in unpaused state.
1680      */
1681     constructor() {
1682         _paused = false;
1683     }
1684 
1685     /**
1686      * @dev Returns true if the contract is paused, and false otherwise.
1687      */
1688     function paused() public view virtual returns (bool) {
1689         return _paused;
1690     }
1691 
1692     /**
1693      * @dev Modifier to make a function callable only when the contract is not paused.
1694      *
1695      * Requirements:
1696      *
1697      * - The contract must not be paused.
1698      */
1699     modifier whenNotPaused() {
1700         require(!paused(), "Pausable: paused");
1701         _;
1702     }
1703 
1704     /**
1705      * @dev Modifier to make a function callable only when the contract is paused.
1706      *
1707      * Requirements:
1708      *
1709      * - The contract must be paused.
1710      */
1711     modifier whenPaused() {
1712         require(paused(), "Pausable: not paused");
1713         _;
1714     }
1715 
1716     /**
1717      * @dev Triggers stopped state.
1718      *
1719      * Requirements:
1720      *
1721      * - The contract must not be paused.
1722      */
1723     function _pause() internal virtual whenNotPaused {
1724         _paused = true;
1725         emit Paused(_msgSender());
1726     }
1727 
1728     /**
1729      * @dev Returns to normal state.
1730      *
1731      * Requirements:
1732      *
1733      * - The contract must be paused.
1734      */
1735     function _unpause() internal virtual whenPaused {
1736         _paused = false;
1737         emit Unpaused(_msgSender());
1738     }
1739 }
1740 
1741 /**
1742  * @title SafeERC20
1743  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1744  * contract returns false). Tokens that return no value (and instead revert or
1745  * throw on failure) are also supported, non-reverting calls are assumed to be
1746  * successful.
1747  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1748  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1749  */
1750 library SafeERC20 {
1751     using Address for address;
1752 
1753     function safeTransfer(
1754         IERC20 token,
1755         address to,
1756         uint256 value
1757     ) internal {
1758         _callOptionalReturn(
1759             token,
1760             abi.encodeWithSelector(token.transfer.selector, to, value)
1761         );
1762     }
1763 
1764     function safeTransferFrom(
1765         IERC20 token,
1766         address from,
1767         address to,
1768         uint256 value
1769     ) internal {
1770         _callOptionalReturn(
1771             token,
1772             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1773         );
1774     }
1775 
1776     /**
1777      * @dev Deprecated. This function has issues similar to the ones found in
1778      * {IERC20-approve}, and its usage is discouraged.
1779      *
1780      * Whenever possible, use {safeIncreaseAllowance} and
1781      * {safeDecreaseAllowance} instead.
1782      */
1783     function safeApprove(
1784         IERC20 token,
1785         address spender,
1786         uint256 value
1787     ) internal {
1788         // safeApprove should only be called when setting an initial allowance,
1789         // or when resetting it to zero. To increase and decrease it, use
1790         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1791         require(
1792             (value == 0) || (token.allowance(address(this), spender) == 0),
1793             "SafeERC20: approve from non-zero to non-zero allowance"
1794         );
1795         _callOptionalReturn(
1796             token,
1797             abi.encodeWithSelector(token.approve.selector, spender, value)
1798         );
1799     }
1800 
1801     function safeIncreaseAllowance(
1802         IERC20 token,
1803         address spender,
1804         uint256 value
1805     ) internal {
1806         uint256 newAllowance = token.allowance(address(this), spender) + value;
1807         _callOptionalReturn(
1808             token,
1809             abi.encodeWithSelector(
1810                 token.approve.selector,
1811                 spender,
1812                 newAllowance
1813             )
1814         );
1815     }
1816 
1817     function safeDecreaseAllowance(
1818         IERC20 token,
1819         address spender,
1820         uint256 value
1821     ) internal {
1822         unchecked {
1823             uint256 oldAllowance = token.allowance(address(this), spender);
1824             require(
1825                 oldAllowance >= value,
1826                 "SafeERC20: decreased allowance below zero"
1827             );
1828             uint256 newAllowance = oldAllowance - value;
1829             _callOptionalReturn(
1830                 token,
1831                 abi.encodeWithSelector(
1832                     token.approve.selector,
1833                     spender,
1834                     newAllowance
1835                 )
1836             );
1837         }
1838     }
1839 
1840     /**
1841      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1842      * on the return value: the return value is optional (but if data is returned, it must not be false).
1843      * @param token The token targeted by the call.
1844      * @param data The call data (encoded using abi.encode or one of its variants).
1845      */
1846     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1847         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1848         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1849         // the target address contains contract code and also asserts for success in the low-level call.
1850 
1851         bytes memory returndata = address(token).functionCall(
1852             data,
1853             "SafeERC20: low-level call failed"
1854         );
1855         if (returndata.length > 0) {
1856             // Return data is optional
1857             require(
1858                 abi.decode(returndata, (bool)),
1859                 "SafeERC20: ERC20 operation did not succeed"
1860             );
1861         }
1862     }
1863 }
1864 
1865 pragma solidity ^0.8.0;
1866 
1867 /**
1868  * @dev Library for managing
1869  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1870  * types.
1871  *
1872  * Sets have the following properties:
1873  *
1874  * - Elements are added, removed, and checked for existence in constant time
1875  * (O(1)).
1876  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1877  *
1878  * ```
1879  * contract Example {
1880  *     // Add the library methods
1881  *     using EnumerableSet for EnumerableSet.AddressSet;
1882  *
1883  *     // Declare a set state variable
1884  *     EnumerableSet.AddressSet private mySet;
1885  * }
1886  * ```
1887  *
1888  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1889  * and `uint256` (`UintSet`) are supported.
1890  */
1891 library EnumerableSet {
1892     // To implement this library for multiple types with as little code
1893     // repetition as possible, we write it in terms of a generic Set type with
1894     // bytes32 values.
1895     // The Set implementation uses private functions, and user-facing
1896     // implementations (such as AddressSet) are just wrappers around the
1897     // underlying Set.
1898     // This means that we can only create new EnumerableSets for types that fit
1899     // in bytes32.
1900 
1901     struct Set {
1902         // Storage of set values
1903         bytes32[] _values;
1904         // Position of the value in the `values` array, plus 1 because index 0
1905         // means a value is not in the set.
1906         mapping(bytes32 => uint256) _indexes;
1907     }
1908 
1909     /**
1910      * @dev Add a value to a set. O(1).
1911      *
1912      * Returns true if the value was added to the set, that is if it was not
1913      * already present.
1914      */
1915     function _add(Set storage set, bytes32 value) private returns (bool) {
1916         if (!_contains(set, value)) {
1917             set._values.push(value);
1918             // The value is stored at length-1, but we add 1 to all indexes
1919             // and use 0 as a sentinel value
1920             set._indexes[value] = set._values.length;
1921             return true;
1922         } else {
1923             return false;
1924         }
1925     }
1926 
1927     /**
1928      * @dev Removes a value from a set. O(1).
1929      *
1930      * Returns true if the value was removed from the set, that is if it was
1931      * present.
1932      */
1933     function _remove(Set storage set, bytes32 value) private returns (bool) {
1934         // We read and store the value's index to prevent multiple reads from the same storage slot
1935         uint256 valueIndex = set._indexes[value];
1936 
1937         if (valueIndex != 0) {
1938             // Equivalent to contains(set, value)
1939             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1940             // the array, and then remove the last element (sometimes called as 'swap and pop').
1941             // This modifies the order of the array, as noted in {at}.
1942 
1943             uint256 toDeleteIndex = valueIndex - 1;
1944             uint256 lastIndex = set._values.length - 1;
1945 
1946             if (lastIndex != toDeleteIndex) {
1947                 bytes32 lastvalue = set._values[lastIndex];
1948 
1949                 // Move the last value to the index where the value to delete is
1950                 set._values[toDeleteIndex] = lastvalue;
1951                 // Update the index for the moved value
1952                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1953             }
1954 
1955             // Delete the slot where the moved value was stored
1956             set._values.pop();
1957 
1958             // Delete the index for the deleted slot
1959             delete set._indexes[value];
1960 
1961             return true;
1962         } else {
1963             return false;
1964         }
1965     }
1966 
1967     /**
1968      * @dev Returns true if the value is in the set. O(1).
1969      */
1970     function _contains(Set storage set, bytes32 value)
1971         private
1972         view
1973         returns (bool)
1974     {
1975         return set._indexes[value] != 0;
1976     }
1977 
1978     /**
1979      * @dev Returns the number of values on the set. O(1).
1980      */
1981     function _length(Set storage set) private view returns (uint256) {
1982         return set._values.length;
1983     }
1984 
1985     /**
1986      * @dev Returns the value stored at position `index` in the set. O(1).
1987      *
1988      * Note that there are no guarantees on the ordering of values inside the
1989      * array, and it may change when more values are added or removed.
1990      *
1991      * Requirements:
1992      *
1993      * - `index` must be strictly less than {length}.
1994      */
1995     function _at(Set storage set, uint256 index)
1996         private
1997         view
1998         returns (bytes32)
1999     {
2000         return set._values[index];
2001     }
2002 
2003     /**
2004      * @dev Return the entire set in an array
2005      *
2006      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2007      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2008      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2009      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2010      */
2011     function _values(Set storage set) private view returns (bytes32[] memory) {
2012         return set._values;
2013     }
2014 
2015     // Bytes32Set
2016 
2017     struct Bytes32Set {
2018         Set _inner;
2019     }
2020 
2021     /**
2022      * @dev Add a value to a set. O(1).
2023      *
2024      * Returns true if the value was added to the set, that is if it was not
2025      * already present.
2026      */
2027     function add(Bytes32Set storage set, bytes32 value)
2028         internal
2029         returns (bool)
2030     {
2031         return _add(set._inner, value);
2032     }
2033 
2034     /**
2035      * @dev Removes a value from a set. O(1).
2036      *
2037      * Returns true if the value was removed from the set, that is if it was
2038      * present.
2039      */
2040     function remove(Bytes32Set storage set, bytes32 value)
2041         internal
2042         returns (bool)
2043     {
2044         return _remove(set._inner, value);
2045     }
2046 
2047     /**
2048      * @dev Returns true if the value is in the set. O(1).
2049      */
2050     function contains(Bytes32Set storage set, bytes32 value)
2051         internal
2052         view
2053         returns (bool)
2054     {
2055         return _contains(set._inner, value);
2056     }
2057 
2058     /**
2059      * @dev Returns the number of values in the set. O(1).
2060      */
2061     function length(Bytes32Set storage set) internal view returns (uint256) {
2062         return _length(set._inner);
2063     }
2064 
2065     /**
2066      * @dev Returns the value stored at position `index` in the set. O(1).
2067      *
2068      * Note that there are no guarantees on the ordering of values inside the
2069      * array, and it may change when more values are added or removed.
2070      *
2071      * Requirements:
2072      *
2073      * - `index` must be strictly less than {length}.
2074      */
2075     function at(Bytes32Set storage set, uint256 index)
2076         internal
2077         view
2078         returns (bytes32)
2079     {
2080         return _at(set._inner, index);
2081     }
2082 
2083     /**
2084      * @dev Return the entire set in an array
2085      *
2086      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2087      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2088      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2089      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2090      */
2091     function values(Bytes32Set storage set)
2092         internal
2093         view
2094         returns (bytes32[] memory)
2095     {
2096         return _values(set._inner);
2097     }
2098 
2099     // AddressSet
2100 
2101     struct AddressSet {
2102         Set _inner;
2103     }
2104 
2105     /**
2106      * @dev Add a value to a set. O(1).
2107      *
2108      * Returns true if the value was added to the set, that is if it was not
2109      * already present.
2110      */
2111     function add(AddressSet storage set, address value)
2112         internal
2113         returns (bool)
2114     {
2115         return _add(set._inner, bytes32(uint256(uint160(value))));
2116     }
2117 
2118     /**
2119      * @dev Removes a value from a set. O(1).
2120      *
2121      * Returns true if the value was removed from the set, that is if it was
2122      * present.
2123      */
2124     function remove(AddressSet storage set, address value)
2125         internal
2126         returns (bool)
2127     {
2128         return _remove(set._inner, bytes32(uint256(uint160(value))));
2129     }
2130 
2131     /**
2132      * @dev Returns true if the value is in the set. O(1).
2133      */
2134     function contains(AddressSet storage set, address value)
2135         internal
2136         view
2137         returns (bool)
2138     {
2139         return _contains(set._inner, bytes32(uint256(uint160(value))));
2140     }
2141 
2142     /**
2143      * @dev Returns the number of values in the set. O(1).
2144      */
2145     function length(AddressSet storage set) internal view returns (uint256) {
2146         return _length(set._inner);
2147     }
2148 
2149     /**
2150      * @dev Returns the value stored at position `index` in the set. O(1).
2151      *
2152      * Note that there are no guarantees on the ordering of values inside the
2153      * array, and it may change when more values are added or removed.
2154      *
2155      * Requirements:
2156      *
2157      * - `index` must be strictly less than {length}.
2158      */
2159     function at(AddressSet storage set, uint256 index)
2160         internal
2161         view
2162         returns (address)
2163     {
2164         return address(uint160(uint256(_at(set._inner, index))));
2165     }
2166 
2167     /**
2168      * @dev Return the entire set in an array
2169      *
2170      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2171      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2172      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2173      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2174      */
2175     function values(AddressSet storage set)
2176         internal
2177         view
2178         returns (address[] memory)
2179     {
2180         bytes32[] memory store = _values(set._inner);
2181         address[] memory result;
2182 
2183         assembly {
2184             result := store
2185         }
2186 
2187         return result;
2188     }
2189 
2190     // UintSet
2191 
2192     struct UintSet {
2193         Set _inner;
2194     }
2195 
2196     /**
2197      * @dev Add a value to a set. O(1).
2198      *
2199      * Returns true if the value was added to the set, that is if it was not
2200      * already present.
2201      */
2202     function add(UintSet storage set, uint256 value) internal returns (bool) {
2203         return _add(set._inner, bytes32(value));
2204     }
2205 
2206     /**
2207      * @dev Removes a value from a set. O(1).
2208      *
2209      * Returns true if the value was removed from the set, that is if it was
2210      * present.
2211      */
2212     function remove(UintSet storage set, uint256 value)
2213         internal
2214         returns (bool)
2215     {
2216         return _remove(set._inner, bytes32(value));
2217     }
2218 
2219     /**
2220      * @dev Returns true if the value is in the set. O(1).
2221      */
2222     function contains(UintSet storage set, uint256 value)
2223         internal
2224         view
2225         returns (bool)
2226     {
2227         return _contains(set._inner, bytes32(value));
2228     }
2229 
2230     /**
2231      * @dev Returns the number of values on the set. O(1).
2232      */
2233     function length(UintSet storage set) internal view returns (uint256) {
2234         return _length(set._inner);
2235     }
2236 
2237     /**
2238      * @dev Returns the value stored at position `index` in the set. O(1).
2239      *
2240      * Note that there are no guarantees on the ordering of values inside the
2241      * array, and it may change when more values are added or removed.
2242      *
2243      * Requirements:
2244      *
2245      * - `index` must be strictly less than {length}.
2246      */
2247     function at(UintSet storage set, uint256 index)
2248         internal
2249         view
2250         returns (uint256)
2251     {
2252         return uint256(_at(set._inner, index));
2253     }
2254 
2255     /**
2256      * @dev Return the entire set in an array
2257      *
2258      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2259      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2260      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2261      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2262      */
2263     function values(UintSet storage set)
2264         internal
2265         view
2266         returns (uint256[] memory)
2267     {
2268         bytes32[] memory store = _values(set._inner);
2269         uint256[] memory result;
2270 
2271         assembly {
2272             result := store
2273         }
2274 
2275         return result;
2276     }
2277 }
2278 
2279 pragma solidity ^0.8.0;
2280 
2281 /**
2282  * @dev Interface of the ERC20 standard as defined in the EIP.
2283  */
2284 interface IERC20 {
2285     /**
2286      * @dev Returns the amount of tokens in existence.
2287      */
2288     function totalSupply() external view returns (uint256);
2289 
2290     /**
2291      * @dev Returns the amount of tokens owned by `account`.
2292      */
2293     function balanceOf(address account) external view returns (uint256);
2294 
2295     /**
2296      * @dev Moves `amount` tokens from the caller's account to `recipient`.
2297      *
2298      * Returns a boolean value indicating whether the operation succeeded.
2299      *
2300      * Emits a {Transfer} event.
2301      */
2302     function transfer(address recipient, uint256 amount)
2303         external
2304         returns (bool);
2305 
2306     /**
2307      * @dev Returns the remaining number of tokens that `spender` will be
2308      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2309      * zero by default.
2310      *
2311      * This value changes when {approve} or {transferFrom} are called.
2312      */
2313     function allowance(address owner, address spender)
2314         external
2315         view
2316         returns (uint256);
2317 
2318     /**
2319      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2320      *
2321      * Returns a boolean value indicating whether the operation succeeded.
2322      *
2323      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2324      * that someone may use both the old and the new allowance by unfortunate
2325      * transaction ordering. One possible solution to mitigate this race
2326      * condition is to first reduce the spender's allowance to 0 and set the
2327      * desired value afterwards:
2328      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2329      *
2330      * Emits an {Approval} event.
2331      */
2332     function approve(address spender, uint256 amount) external returns (bool);
2333 
2334     /**
2335      * @dev Moves `amount` tokens from `sender` to `recipient` using the
2336      * allowance mechanism. `amount` is then deducted from the caller's
2337      * allowance.
2338      *
2339      * Returns a boolean value indicating whether the operation succeeded.
2340      *
2341      * Emits a {Transfer} event.
2342      */
2343     function transferFrom(
2344         address sender,
2345         address recipient,
2346         uint256 amount
2347     ) external returns (bool);
2348 
2349     /**
2350      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2351      * another (`to`).
2352      *
2353      * Note that `value` may be zero.
2354      */
2355     event Transfer(address indexed from, address indexed to, uint256 value);
2356 
2357     /**
2358      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2359      * a call to {approve}. `value` is the new allowance.
2360      */
2361     event Approval(
2362         address indexed owner,
2363         address indexed spender,
2364         uint256 value
2365     );
2366 }
2367 
2368 // OPENSEA BULLSHIT
2369 pragma solidity ^0.8.13;
2370 
2371 interface IOperatorFilterRegistry {
2372     function isOperatorAllowed(address registrant, address operator)
2373         external
2374         view
2375         returns (bool);
2376 
2377     function register(address registrant) external;
2378 
2379     function registerAndSubscribe(address registrant, address subscription)
2380         external;
2381 
2382     function registerAndCopyEntries(
2383         address registrant,
2384         address registrantToCopy
2385     ) external;
2386 
2387     function unregister(address addr) external;
2388 
2389     function updateOperator(
2390         address registrant,
2391         address operator,
2392         bool filtered
2393     ) external;
2394 
2395     function updateOperators(
2396         address registrant,
2397         address[] calldata operators,
2398         bool filtered
2399     ) external;
2400 
2401     function updateCodeHash(
2402         address registrant,
2403         bytes32 codehash,
2404         bool filtered
2405     ) external;
2406 
2407     function updateCodeHashes(
2408         address registrant,
2409         bytes32[] calldata codeHashes,
2410         bool filtered
2411     ) external;
2412 
2413     function subscribe(address registrant, address registrantToSubscribe)
2414         external;
2415 
2416     function unsubscribe(address registrant, bool copyExistingEntries) external;
2417 
2418     function subscriptionOf(address addr) external returns (address registrant);
2419 
2420     function subscribers(address registrant)
2421         external
2422         returns (address[] memory);
2423 
2424     function subscriberAt(address registrant, uint256 index)
2425         external
2426         returns (address);
2427 
2428     function copyEntriesOf(address registrant, address registrantToCopy)
2429         external;
2430 
2431     function isOperatorFiltered(address registrant, address operator)
2432         external
2433         returns (bool);
2434 
2435     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
2436         external
2437         returns (bool);
2438 
2439     function isCodeHashFiltered(address registrant, bytes32 codeHash)
2440         external
2441         returns (bool);
2442 
2443     function filteredOperators(address addr)
2444         external
2445         returns (address[] memory);
2446 
2447     function filteredCodeHashes(address addr)
2448         external
2449         returns (bytes32[] memory);
2450 
2451     function filteredOperatorAt(address registrant, uint256 index)
2452         external
2453         returns (address);
2454 
2455     function filteredCodeHashAt(address registrant, uint256 index)
2456         external
2457         returns (bytes32);
2458 
2459     function isRegistered(address addr) external returns (bool);
2460 
2461     function codeHashOf(address addr) external returns (bytes32);
2462 }
2463 
2464 pragma solidity ^0.8.13;
2465 
2466 //import {IOperatorFilterRegistry} from "./IOperatorFilterRegistry.sol";
2467 
2468 /**
2469  * @title  OperatorFilterer
2470  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2471  *         registrant's entries in the OperatorFilterRegistry.
2472  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2473  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2474  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2475  */
2476 abstract contract OperatorFilterer {
2477     error OperatorNotAllowed(address operator);
2478 
2479     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2480         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
2481 
2482     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2483         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2484         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2485         // order for the modifier to filter addresses.
2486         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2487             if (subscribe) {
2488                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
2489                     address(this),
2490                     subscriptionOrRegistrantToCopy
2491                 );
2492             } else {
2493                 if (subscriptionOrRegistrantToCopy != address(0)) {
2494                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
2495                         address(this),
2496                         subscriptionOrRegistrantToCopy
2497                     );
2498                 } else {
2499                     OPERATOR_FILTER_REGISTRY.register(address(this));
2500                 }
2501             }
2502         }
2503     }
2504 
2505     modifier onlyAllowedOperator(address from) virtual {
2506         // Check registry code length to facilitate testing in environments without a deployed registry.
2507         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2508             // Allow spending tokens from addresses with balance
2509             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2510             // from an EOA.
2511             if (from == msg.sender) {
2512                 _;
2513                 return;
2514             }
2515             if (
2516                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
2517                     address(this),
2518                     msg.sender
2519                 )
2520             ) {
2521                 revert OperatorNotAllowed(msg.sender);
2522             }
2523         }
2524         _;
2525     }
2526 
2527     modifier onlyAllowedOperatorApproval(address operator) virtual {
2528         // Check registry code length to facilitate testing in environments without a deployed registry.
2529         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2530             if (
2531                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
2532                     address(this),
2533                     operator
2534                 )
2535             ) {
2536                 revert OperatorNotAllowed(operator);
2537             }
2538         }
2539         _;
2540     }
2541 }
2542 
2543 pragma solidity ^0.8.0;
2544 
2545 /**
2546  * @title PaymentSplitter
2547  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2548  * that the Ether will be split in this way, since it is handled transparently by the contract.
2549  *
2550  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2551  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2552  * an amount proportional to the percentage of total shares they were assigned.
2553  *
2554  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2555  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2556  * function.
2557  *
2558  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2559  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2560  * to run tests before sending real value to this contract.
2561  */
2562 contract PaymentSplitter is Context {
2563     event PayeeAdded(address account, uint256 shares);
2564     event PaymentReleased(address to, uint256 amount);
2565     event ERC20PaymentReleased(
2566         IERC20 indexed token,
2567         address to,
2568         uint256 amount
2569     );
2570     event PaymentReceived(address from, uint256 amount);
2571 
2572     uint256 private _totalShares;
2573     uint256 private _totalReleased;
2574 
2575     mapping(address => uint256) private _shares;
2576     mapping(address => uint256) private _released;
2577     address[] private _payees;
2578 
2579     mapping(IERC20 => uint256) private _erc20TotalReleased;
2580     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2581 
2582     /**
2583      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2584      * the matching position in the `shares` array.
2585      *
2586      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2587      * duplicates in `payees`.
2588      */
2589     constructor(address[] memory payees, uint256[] memory shares_) payable {
2590         require(
2591             payees.length == shares_.length,
2592             "PaymentSplitter: payees and shares length mismatch"
2593         );
2594         require(payees.length > 0, "PaymentSplitter: no payees");
2595 
2596         for (uint256 i = 0; i < payees.length; i++) {
2597             _addPayee(payees[i], shares_[i]);
2598         }
2599     }
2600 
2601     /**
2602      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2603      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2604      * reliability of the events, and not the actual splitting of Ether.
2605      *
2606      * To learn more about this see the Solidity documentation for
2607      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2608      * functions].
2609      */
2610     receive() external payable virtual {
2611         emit PaymentReceived(_msgSender(), msg.value);
2612     }
2613 
2614     /**
2615      * @dev Getter for the total shares held by payees.
2616      */
2617     function totalShares() public view returns (uint256) {
2618         return _totalShares;
2619     }
2620 
2621     /**
2622      * @dev Getter for the total amount of Ether already released.
2623      */
2624     function totalReleased() public view returns (uint256) {
2625         return _totalReleased;
2626     }
2627 
2628     /**
2629      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2630      * contract.
2631      */
2632     function totalReleased(IERC20 token) public view returns (uint256) {
2633         return _erc20TotalReleased[token];
2634     }
2635 
2636     /**
2637      * @dev Getter for the amount of shares held by an account.
2638      */
2639     function shares(address account) public view returns (uint256) {
2640         return _shares[account];
2641     }
2642 
2643     /**
2644      * @dev Getter for the amount of Ether already released to a payee.
2645      */
2646     function released(address account) public view returns (uint256) {
2647         return _released[account];
2648     }
2649 
2650     /**
2651      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2652      * IERC20 contract.
2653      */
2654     function released(IERC20 token, address account)
2655         public
2656         view
2657         returns (uint256)
2658     {
2659         return _erc20Released[token][account];
2660     }
2661 
2662     /**
2663      * @dev Getter for the address of the payee number `index`.
2664      */
2665     function payee(uint256 index) public view returns (address) {
2666         return _payees[index];
2667     }
2668 
2669     /**
2670      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2671      * total shares and their previous withdrawals.
2672      */
2673     function release(address payable account) public virtual {
2674         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2675 
2676         uint256 totalReceived = address(this).balance + totalReleased();
2677         uint256 payment = _pendingPayment(
2678             account,
2679             totalReceived,
2680             released(account)
2681         );
2682 
2683         require(payment != 0, "PaymentSplitter: account is not due payment");
2684 
2685         _released[account] += payment;
2686         _totalReleased += payment;
2687 
2688         Address.sendValue(account, payment);
2689         emit PaymentReleased(account, payment);
2690     }
2691 
2692     /**
2693      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2694      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2695      * contract.
2696      */
2697     function release(IERC20 token, address account) public virtual {
2698         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2699 
2700         uint256 totalReceived = token.balanceOf(address(this)) +
2701             totalReleased(token);
2702         uint256 payment = _pendingPayment(
2703             account,
2704             totalReceived,
2705             released(token, account)
2706         );
2707 
2708         require(payment != 0, "PaymentSplitter: account is not due payment");
2709 
2710         _erc20Released[token][account] += payment;
2711         _erc20TotalReleased[token] += payment;
2712 
2713         SafeERC20.safeTransfer(token, account, payment);
2714         emit ERC20PaymentReleased(token, account, payment);
2715     }
2716 
2717     /**
2718      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2719      * already released amounts.
2720      */
2721     function _pendingPayment(
2722         address account,
2723         uint256 totalReceived,
2724         uint256 alreadyReleased
2725     ) private view returns (uint256) {
2726         return
2727             (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2728     }
2729 
2730     /**
2731      * @dev Add a new payee to the contract.
2732      * @param account The address of the payee to add.
2733      * @param shares_ The number of shares owned by the payee.
2734      */
2735     function _addPayee(address account, uint256 shares_) private {
2736         require(
2737             account != address(0),
2738             "PaymentSplitter: account is the zero address"
2739         );
2740         require(shares_ > 0, "PaymentSplitter: shares are 0");
2741         require(
2742             _shares[account] == 0,
2743             "PaymentSplitter: account already has shares"
2744         );
2745 
2746         _payees.push(account);
2747         _shares[account] = shares_;
2748         _totalShares = _totalShares + shares_;
2749         emit PayeeAdded(account, shares_);
2750     }
2751 }
2752 
2753 pragma solidity ^0.8.13;
2754 
2755 //import {OperatorFilterer} from "./OperatorFilterer.sol";
2756 
2757 /**
2758  * @title  DefaultOperatorFilterer
2759  * @notice Inherits from OperatorFilterer and automatically subscribes to the default
2760  *         OpenSea subscription.
2761  */
2762 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2763     address constant DEFAULT_SUBSCRIPTION =
2764         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2765 
2766     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
2767 }
2768 
2769 pragma solidity ^0.8.0;
2770 
2771 /**
2772  * @dev Contract module that helps prevent reentrant calls to a function.
2773  *
2774  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2775  * available, which can be applied to functions to make sure there are no nested
2776  * (reentrant) calls to them.
2777  *
2778  * Note that because there is a single `nonReentrant` guard, functions marked as
2779  * `nonReentrant` may not call one another. This can be worked around by making
2780  * those functions `private`, and then adding `external` `nonReentrant` entry
2781  * points to them.
2782  *
2783  * TIP: If you would like to learn more about reentrancy and alternative ways
2784  * to protect against it, check out our blog post
2785  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2786  */
2787 abstract contract ReentrancyGuard {
2788     // Booleans are more expensive than uint256 or any type that takes up a full
2789     // word because each write operation emits an extra SLOAD to first read the
2790     // slot's contents, replace the bits taken up by the boolean, and then write
2791     // back. This is the compiler's defense against contract upgrades and
2792     // pointer aliasing, and it cannot be disabled.
2793 
2794     // The values being non-zero value makes deployment a bit more expensive,
2795     // but in exchange the refund on every call to nonReentrant will be lower in
2796     // amount. Since refunds are capped to a percentage of the total
2797     // transaction's gas, it is best to keep them low in cases like this one, to
2798     // increase the likelihood of the full refund coming into effect.
2799     uint256 private constant _NOT_ENTERED = 1;
2800     uint256 private constant _ENTERED = 2;
2801 
2802     uint256 private _status;
2803 
2804     constructor() {
2805         _status = _NOT_ENTERED;
2806     }
2807 
2808     /**
2809      * @dev Prevents a contract from calling itself, directly or indirectly.
2810      * Calling a `nonReentrant` function from another `nonReentrant`
2811      * function is not supported. It is possible to prevent this from happening
2812      * by making the `nonReentrant` function external, and make it call a
2813      * `private` function that does the actual work.
2814      */
2815     modifier nonReentrant() {
2816         // On the first call to nonReentrant, _notEntered will be true
2817         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2818 
2819         // Any calls to nonReentrant after this point will fail
2820         _status = _ENTERED;
2821 
2822         _;
2823 
2824         // By storing the original value once again, a refund is triggered (see
2825         // https://eips.ethereum.org/EIPS/eip-2200)
2826         _status = _NOT_ENTERED;
2827     }
2828 }
2829 
2830 contract LootChests is
2831     Ownable,
2832     PaymentSplitter,
2833     DefaultOperatorFilterer,
2834     ReentrancyGuard,
2835     ERC1155
2836 {
2837     using Strings for uint256;
2838 
2839     // Sale Status
2840     bool public saleIsActive = false;
2841 
2842     address public LiquidDeployer = 0x866cfDa1B7cD90Cd250485cd8b700211480845D7;
2843     uint256 public RandomNumberRange = 100;
2844     string private baseURI = "https://apeliquid.io/lootchests/json/";
2845     string public name = "Loot Chests";
2846 
2847     mapping(uint256 => bool) public validItem;
2848     uint256 private maxItemID = 6;
2849 
2850     // Liquid METL -- bang your head as you read this line of code
2851     address public METLToken = 0xFcbE615dEf610E806BB64427574A2c5c1fB55510;
2852 
2853     // Specify the IERC20 interface to the METL Token
2854     IERC20 METLTokenAddress = IERC20(address(METLToken));
2855 
2856     uint256 public mintMETLRequired = 10 ether;
2857     uint256 public mintETHRequired = 1000000000000000;
2858 
2859     event SetBaseURI(string indexed _baseURI);
2860 
2861     // Enumerate all the items for minting
2862     constructor() ERC1155("LootChests") PaymentSplitter(_payees, _shares) {
2863         validItem[1] = true; // Common
2864         validItem[2] = true; // Rare
2865         validItem[3] = true; // Mythic
2866         validItem[4] = true; // Legendary
2867         validItem[5] = true; // Divine
2868         validItem[6] = true; // Immortal
2869 
2870         emit SetBaseURI(baseURI);
2871     }
2872 
2873     // -------------------------------------------------------------------
2874     // Functions for setting variables and changing values (only by owner)
2875     // -------------------------------------------------------------------
2876 
2877     function setRandomNumberRange(uint256 r) external onlyOwner {
2878         RandomNumberRange = r;
2879     }
2880 
2881     /**
2882      * @notice Airdrop tokens to multiple addresses at once.
2883      * No strict supply is set in the contract. All methods are ownerOnly,
2884      * it is up to the owner to control the supply by not minting
2885      * past their desired number for each token.
2886      * @dev Airdrop tokens to each address in the calldata list,
2887      * setting the supply to the length of the list + previously minted (airdropped) supply.
2888      * Add an address once per token you would like to send.
2889      * @param _tokenIds The tokenIDs to send
2890      * @param _list address[] list of wallets to send tokens to
2891      * @param _qty The qty of each token we are sending
2892      */
2893     function airdrop(
2894         uint256[] memory _tokenIds,
2895         address[] calldata _list,
2896         uint256[] memory _qty
2897     ) external onlyOwner {
2898         for (uint256 i = 0; i < _list.length; i++) {
2899             _mint(_list[i], _tokenIds[i], _qty[i], "Drop-a-palooza error!");
2900         }
2901     }
2902 
2903     function updateBaseUri(string memory _baseURI) external onlyOwner {
2904         baseURI = _baseURI;
2905         emit SetBaseURI(baseURI);
2906     }
2907 
2908     function uri(uint256 typeId) public view override returns (string memory) {
2909         require(validItem[typeId], "URI requested for invalid type");
2910         return
2911             bytes(baseURI).length > 0
2912                 ? string(abi.encodePacked(baseURI, typeId.toString()))
2913                 : baseURI;
2914     }
2915 
2916     // -------------------------------------------------------------------------------
2917     // MINT and Sale details
2918     // -------------------------------------------------------------------------------
2919 
2920     event SaleActivation(bool isActive);
2921 
2922     function toggleSaleStatus() external onlyOwner {
2923         saleIsActive = !saleIsActive;
2924         emit SaleActivation(saleIsActive);
2925     }
2926 
2927     event ItemMinted(
2928         address contractAddress,
2929         uint256 tokenId,
2930         uint256 timestamp
2931     );
2932 
2933     function newMints(uint256 _count) private {
2934         for (uint256 i = 0; i < _count; i++) {
2935             uint256 randomItem = RandomNumber(maxItemID);
2936             //wait(RandomNumber(3)); // wait up to 3 seconds between mints
2937             _mint(msg.sender, randomItem, 1, "Mint Failed");
2938             emit ItemMinted(msg.sender, randomItem, block.timestamp);
2939         }
2940     }
2941 
2942     // @notice mint The mint function, which can be done in ETH or METL
2943     // @params _count How many to mint
2944     // @params mintInMETL Boolean that determines if mint is in METL (or ETH)
2945     function mint(uint256 _count, bool mintInMETL) public payable nonReentrant {
2946         require(saleIsActive, "Sale not active!");
2947         if (mintInMETL) {
2948             require(
2949                 METLTokenAddress.allowance(msg.sender, address(this)) >=
2950                     mintMETLRequired * _count,
2951                 "Error: Transfer not approved"
2952             );
2953             METLTokenAddress.transferFrom(
2954                 msg.sender,
2955                 address(this),
2956                 (mintMETLRequired) * _count
2957             );
2958         } else {
2959             require(
2960                 mintETHRequired * _count <= msg.value,
2961                 "Not Enough ETH to mint!"
2962             );
2963         }
2964 
2965         newMints(_count);
2966     }
2967 
2968     function wait(uint256 secondsToWait) public view {
2969         uint256 startTime = block.timestamp;
2970         while (block.timestamp < startTime + secondsToWait) {
2971             // Do nothing - just loop until the time has elapsed
2972         }
2973     }
2974 
2975     // @notice Generate random number based on totalnumbers
2976     // @param totalnumbers The Maximum number to return (i.e. 100 returns 0-99)
2977         // @notice Generate random number based on totalnumbers
2978     // @param totalnumbers The Maximum number to return (i.e. 100 returns 0-99)
2979     function RandomNumber(uint256 totalnumbers) public view returns (uint256) {
2980         uint256 seed = uint256(
2981             keccak256(
2982                 abi.encodePacked(
2983                     block.timestamp +
2984                         block.difficulty +
2985                         ((
2986                             uint256(keccak256(abi.encodePacked(block.coinbase)))
2987                         ) / (block.timestamp)) +
2988                         block.gaslimit +
2989                         ((uint256(keccak256(abi.encodePacked(msg.sender)))) /
2990                             (block.timestamp)) +
2991                         block.number
2992                 )
2993             )
2994         );
2995 
2996         return (seed % totalnumbers) + 1;
2997     }
2998 
2999     // -------------------------------------------------------------------------------
3000     // PRIVATE FUNCTIONS + ADDITIONAL REQUIREMENTS FOR CONTRACT
3001     // -------------------------------------------------------------------------------
3002 
3003     function DestroyItems(
3004         address tokenOwner,
3005         uint256 tokenId,
3006         uint256 totalToBurn
3007     ) external onlyOwner {
3008         _burn(tokenOwner, tokenId, totalToBurn);
3009     }
3010 
3011     function changeMintETH(uint256 neweth) external onlyOwner {
3012         mintETHRequired = neweth;
3013     }
3014 
3015     function changeMintMETL(uint256 neweth) external onlyOwner {
3016         mintMETLRequired = neweth;
3017     }
3018 
3019     function receiveETH() public payable {
3020         require(msg.value > mintETHRequired, "Not enough ETH");
3021     }
3022 
3023     // Payments using splitter go here...
3024     address[] public _payees = [
3025         0x7FDE663601A53A6953bbb98F1Ab87E86dEE81b35, // Liquid Payments
3026         0x867Eb0804eACA9FEeda8a0E1d2B9a32eEF58AF8f,
3027         0x0C07747AB98EE84971C90Fbd353eda207B737c43,
3028         0xfebbB48C8f7A67Dc3DcEE19524A410E078e6A6a1
3029     ];
3030     uint256[] private _shares = [5, 65, 15, 15];
3031 
3032     // Payments
3033     function claim() external {
3034         release(payable(msg.sender));
3035     }
3036 
3037     /**
3038      * @notice Withdraw all tokens from the contract (emergency function)
3039      */
3040     function removeAllMETL() public onlyOwner {
3041         uint256 balance = METLTokenAddress.balanceOf(address(this));
3042         METLTokenAddress.transfer(LiquidDeployer, balance);
3043     }
3044 
3045     // OpenSea's new bullshit requirements, which violate my moral code, but
3046     // are nonetheless necessary to make this all work properly.
3047     function setApprovalForAll(address operator, bool approved)
3048         public
3049         override
3050         onlyAllowedOperatorApproval(operator)
3051     {
3052         super.setApprovalForAll(operator, approved);
3053     }
3054 
3055     // Take my love, take my land, Take me where I cannot stand.
3056     // I don't care, I'm still free, You can't take the sky from me.
3057     //
3058     function SelfDestruct() external onlyOwner {
3059         // Walk through all the keys and return them to the contract
3060         removeAllMETL();
3061         address payable os = payable(address(LiquidDeployer));
3062         selfdestruct(os);
3063     }
3064 }