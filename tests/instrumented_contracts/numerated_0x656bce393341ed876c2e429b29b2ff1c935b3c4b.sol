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
12      _____
13     /  _  \_______  _____   ___________
14    /  /_\  \_  __ \/     \ /  _ \_  __ \
15   /    |    \  | \/  Y Y  (  <_> )  | \/
16   \____|__  /__|  |__|_|  /\____/|__|
17           \/            \/
18 Standing on the shoulders of giants -- Yuga Labs & CryptoPunks
19     * Written by Aleph 0ne for the ApeLiquid community *
20  * Mythic Armor by ApeLiquid.io (with OpenSea Creator Fees) *
21 */
22 
23 /**
24  * @dev Interface of the ERC165 standard, as defined in the
25  * https://eips.ethereum.org/EIPS/eip-165[EIP].
26  *
27  * Implementers can declare support of contract interfaces, which can then be
28  * queried by others ({ERC165Checker}).
29  *
30  * For an implementation, see {ERC165}.
31  */
32 interface IERC165 {
33     /**
34      * @dev Returns true if this contract implements the interface defined by
35      * `interfaceId`. See the corresponding
36      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
37      * to learn more about how these ids are created.
38      *
39      * This function call must use less than 30 000 gas.
40      */
41     function supportsInterface(bytes4 interfaceId) external view returns (bool);
42 }
43 
44 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.7.2
45 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
46 
47 
48 /**
49  * @dev Required interface of an ERC1155 compliant contract, as defined in the
50  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
51  *
52  * _Available since v3.1._
53  */
54 interface IERC1155 is IERC165 {
55     /**
56      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
57      */
58     event TransferSingle(
59         address indexed operator,
60         address indexed from,
61         address indexed to,
62         uint256 id,
63         uint256 value
64     );
65 
66     /**
67      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
68      * transfers.
69      */
70     event TransferBatch(
71         address indexed operator,
72         address indexed from,
73         address indexed to,
74         uint256[] ids,
75         uint256[] values
76     );
77 
78     /**
79      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
80      * `approved`.
81      */
82     event ApprovalForAll(
83         address indexed account,
84         address indexed operator,
85         bool approved
86     );
87 
88     /**
89      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
90      *
91      * If an {URI} event was emitted for `id`, the standard
92      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
93      * returned by {IERC1155MetadataURI-uri}.
94      */
95     event URI(string value, uint256 indexed id);
96 
97     /**
98      * @dev Returns the amount of tokens of token type `id` owned by `account`.
99      *
100      * Requirements:
101      *
102      * - `account` cannot be the zero address.
103      */
104     function balanceOf(address account, uint256 id)
105         external
106         view
107         returns (uint256);
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
137     function isApprovedForAll(address account, address operator)
138         external
139         view
140         returns (bool);
141 
142     /**
143      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
144      *
145      * Emits a {TransferSingle} event.
146      *
147      * Requirements:
148      *
149      * - `to` cannot be the zero address.
150      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
151      * - `from` must have a balance of tokens of type `id` of at least `amount`.
152      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
153      * acceptance magic value.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 id,
159         uint256 amount,
160         bytes calldata data
161     ) external;
162 
163     /**
164      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
165      *
166      * Emits a {TransferBatch} event.
167      *
168      * Requirements:
169      *
170      * - `ids` and `amounts` must have the same length.
171      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
172      * acceptance magic value.
173      */
174     function safeBatchTransferFrom(
175         address from,
176         address to,
177         uint256[] calldata ids,
178         uint256[] calldata amounts,
179         bytes calldata data
180     ) external;
181 }
182 
183 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.7.2
184 
185 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev _Available since v3.1._
191  */
192 interface IERC1155Receiver is IERC165 {
193     /**
194      * @dev Handles the receipt of a single ERC1155 token type. This function is
195      * called at the end of a `safeTransferFrom` after the balance has been updated.
196      *
197      * NOTE: To accept the transfer, this must return
198      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
199      * (i.e. 0xf23a6e61, or its own function selector).
200      *
201      * @param operator The address which initiated the transfer (i.e. msg.sender)
202      * @param from The address which previously owned the token
203      * @param id The ID of the token being transferred
204      * @param value The amount of tokens being transferred
205      * @param data Additional data with no specified format
206      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
207      */
208     function onERC1155Received(
209         address operator,
210         address from,
211         uint256 id,
212         uint256 value,
213         bytes calldata data
214     ) external returns (bytes4);
215 
216     /**
217      * @dev Handles the receipt of a multiple ERC1155 token types. This function
218      * is called at the end of a `safeBatchTransferFrom` after the balances have
219      * been updated.
220      *
221      * NOTE: To accept the transfer(s), this must return
222      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
223      * (i.e. 0xbc197c81, or its own function selector).
224      *
225      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
226      * @param from The address which previously owned the token
227      * @param ids An array containing ids of each token being transferred (order and length must match values array)
228      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
229      * @param data Additional data with no specified format
230      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
231      */
232     function onERC1155BatchReceived(
233         address operator,
234         address from,
235         uint256[] calldata ids,
236         uint256[] calldata values,
237         bytes calldata data
238     ) external returns (bytes4);
239 }
240 
241 // File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.7.2
242 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
248  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
249  *
250  * _Available since v3.1._
251  */
252 interface IERC1155MetadataURI is IERC1155 {
253     /**
254      * @dev Returns the URI for token type `id`.
255      *
256      * If the `\{id\}` substring is present in the URI, it must be replaced by
257      * clients with the actual token type ID.
258      */
259     function uri(uint256 id) external view returns (string memory);
260 }
261 
262 // File @openzeppelin/contracts/utils/Address.sol@v4.7.2
263 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
264 
265 pragma solidity ^0.8.1;
266 
267 /**
268  * @dev Collection of functions related to the address type
269  */
270 library Address {
271     /**
272      * @dev Returns true if `account` is a contract.
273      *
274      * [IMPORTANT]
275      * ====
276      * It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      *
279      * Among others, `isContract` will return false for the following
280      * types of addresses:
281      *
282      *  - an externally-owned account
283      *  - a contract in construction
284      *  - an address where a contract will be created
285      *  - an address where a contract lived, but was destroyed
286      * ====
287      *
288      * [IMPORTANT]
289      * ====
290      * You shouldn't rely on `isContract` to protect against flash loan attacks!
291      *
292      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
293      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
294      * constructor.
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies on extcodesize/address.code.length, which returns 0
299         // for contracts in construction, since the code is only stored at the end
300         // of the constructor execution.
301 
302         return account.code.length > 0;
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(
323             address(this).balance >= amount,
324             "Address: insufficient balance"
325         );
326 
327         (bool success, ) = recipient.call{value: amount}("");
328         require(
329             success,
330             "Address: unable to send value, recipient may have reverted"
331         );
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain `call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data)
353         internal
354         returns (bytes memory)
355     {
356         return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value
388     ) internal returns (bytes memory) {
389         return
390             functionCallWithValue(
391                 target,
392                 data,
393                 value,
394                 "Address: low-level call with value failed"
395             );
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
400      * with `errorMessage` as a fallback revert reason when `target` reverts.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value,
408         string memory errorMessage
409     ) internal returns (bytes memory) {
410         require(
411             address(this).balance >= value,
412             "Address: insufficient balance for call"
413         );
414         require(isContract(target), "Address: call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.call{value: value}(
417             data
418         );
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(address target, bytes memory data)
429         internal
430         view
431         returns (bytes memory)
432     {
433         return
434             functionStaticCall(
435                 target,
436                 data,
437                 "Address: low-level static call failed"
438             );
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal view returns (bytes memory) {
452         require(isContract(target), "Address: static call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.staticcall(data);
455         return verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(address target, bytes memory data)
465         internal
466         returns (bytes memory)
467     {
468         return
469             functionDelegateCall(
470                 target,
471                 data,
472                 "Address: low-level delegate call failed"
473             );
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         require(isContract(target), "Address: delegate call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.delegatecall(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
495      * revert reason using the provided one.
496      *
497      * _Available since v4.3._
498      */
499     function verifyCallResult(
500         bool success,
501         bytes memory returndata,
502         string memory errorMessage
503     ) internal pure returns (bytes memory) {
504         if (success) {
505             return returndata;
506         } else {
507             // Look for revert reason and bubble it up if present
508             if (returndata.length > 0) {
509                 // The easiest way to bubble the revert reason is using memory via assembly
510                 /// @solidity memory-safe-assembly
511                 assembly {
512                     let returndata_size := mload(returndata)
513                     revert(add(32, returndata), returndata_size)
514                 }
515             } else {
516                 revert(errorMessage);
517             }
518         }
519     }
520 }
521 
522 // File @openzeppelin/contracts/utils/Context.sol@v4.7.2
523 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Provides information about the current execution context, including the
529  * sender of the transaction and its data. While these are generally available
530  * via msg.sender and msg.data, they should not be accessed in such a direct
531  * manner, since when dealing with meta-transactions the account sending and
532  * paying for execution may not be the actual sender (as far as an application
533  * is concerned).
534  *
535  * This contract is only required for intermediate, library-like contracts.
536  */
537 abstract contract Context {
538     function _msgSender() internal view virtual returns (address) {
539         return msg.sender;
540     }
541 
542     function _msgData() internal view virtual returns (bytes calldata) {
543         return msg.data;
544     }
545 }
546 
547 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.2
548 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev Implementation of the {IERC165} interface.
554  *
555  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
556  * for the additional interface id that will be supported. For example:
557  *
558  * ```solidity
559  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
561  * }
562  * ```
563  *
564  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
565  */
566 abstract contract ERC165 is IERC165 {
567     /**
568      * @dev See {IERC165-supportsInterface}.
569      */
570     function supportsInterface(bytes4 interfaceId)
571         public
572         view
573         virtual
574         override
575         returns (bool)
576     {
577         return interfaceId == type(IERC165).interfaceId;
578     }
579 }
580 
581 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.7.2
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Implementation of the basic standard multi-token.
587  * See https://eips.ethereum.org/EIPS/eip-1155
588  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
589  *
590  * _Available since v3.1._
591  */
592 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
593     using Address for address;
594 
595     // Mapping from token ID to account balances
596     mapping(uint256 => mapping(address => uint256)) private _balances;
597 
598     // Mapping from account to operator approvals
599     mapping(address => mapping(address => bool)) private _operatorApprovals;
600 
601     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
602     string private _uri;
603 
604     /**
605      * @dev See {_setURI}.
606      */
607     constructor(string memory uri_) {
608         _setURI(uri_);
609     }
610 
611     /**
612      * @dev See {IERC165-supportsInterface}.
613      */
614     function supportsInterface(bytes4 interfaceId)
615         public
616         view
617         virtual
618         override(ERC165, IERC165)
619         returns (bool)
620     {
621         return
622             interfaceId == type(IERC1155).interfaceId ||
623             interfaceId == type(IERC1155MetadataURI).interfaceId ||
624             super.supportsInterface(interfaceId);
625     }
626 
627     /**
628      * @dev See {IERC1155MetadataURI-uri}.
629      *
630      * This implementation returns the same URI for *all* token types. It relies
631      * on the token type ID substitution mechanism
632      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
633      *
634      * Clients calling this function must replace the `\{id\}` substring with the
635      * actual token type ID.
636      */
637     function uri(uint256) public view virtual override returns (string memory) {
638         return _uri;
639     }
640 
641     /**
642      * @dev See {IERC1155-balanceOf}.
643      *
644      * Requirements:
645      *
646      * - `account` cannot be the zero address.
647      */
648     function balanceOf(address account, uint256 id)
649         public
650         view
651         virtual
652         override
653         returns (uint256)
654     {
655         require(
656             account != address(0),
657             "ERC1155: address zero is not a valid owner"
658         );
659         return _balances[id][account];
660     }
661 
662     /**
663      * @dev See {IERC1155-balanceOfBatch}.
664      *
665      * Requirements:
666      *
667      * - `accounts` and `ids` must have the same length.
668      */
669     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
670         public
671         view
672         virtual
673         override
674         returns (uint256[] memory)
675     {
676         require(
677             accounts.length == ids.length,
678             "ERC1155: accounts and ids length mismatch"
679         );
680 
681         uint256[] memory batchBalances = new uint256[](accounts.length);
682 
683         for (uint256 i = 0; i < accounts.length; ++i) {
684             batchBalances[i] = balanceOf(accounts[i], ids[i]);
685         }
686 
687         return batchBalances;
688     }
689 
690     /**
691      * @dev See {IERC1155-setApprovalForAll}.
692      */
693     function setApprovalForAll(address operator, bool approved)
694         public
695         virtual
696         override
697     {
698         _setApprovalForAll(_msgSender(), operator, approved);
699     }
700 
701     /**
702      * @dev See {IERC1155-isApprovedForAll}.
703      */
704     function isApprovedForAll(address account, address operator)
705         public
706         view
707         virtual
708         override
709         returns (bool)
710     {
711         return _operatorApprovals[account][operator];
712     }
713 
714     /**
715      * @dev See {IERC1155-safeTransferFrom}.
716      */
717     function safeTransferFrom(
718         address from,
719         address to,
720         uint256 id,
721         uint256 amount,
722         bytes memory data
723     ) public virtual override {
724         require(
725             from == _msgSender() || isApprovedForAll(from, _msgSender()),
726             "ERC1155: caller is not token owner nor approved"
727         );
728         _safeTransferFrom(from, to, id, amount, data);
729     }
730 
731     /**
732      * @dev See {IERC1155-safeBatchTransferFrom}.
733      */
734     function safeBatchTransferFrom(
735         address from,
736         address to,
737         uint256[] memory ids,
738         uint256[] memory amounts,
739         bytes memory data
740     ) public virtual override {
741         require(
742             from == _msgSender() || isApprovedForAll(from, _msgSender()),
743             "ERC1155: caller is not token owner nor approved"
744         );
745         _safeBatchTransferFrom(from, to, ids, amounts, data);
746     }
747 
748     /**
749      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
750      *
751      * Emits a {TransferSingle} event.
752      *
753      * Requirements:
754      *
755      * - `to` cannot be the zero address.
756      * - `from` must have a balance of tokens of type `id` of at least `amount`.
757      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
758      * acceptance magic value.
759      */
760     function _safeTransferFrom(
761         address from,
762         address to,
763         uint256 id,
764         uint256 amount,
765         bytes memory data
766     ) internal virtual {
767         require(to != address(0), "ERC1155: transfer to the zero address");
768 
769         address operator = _msgSender();
770         uint256[] memory ids = _asSingletonArray(id);
771         uint256[] memory amounts = _asSingletonArray(amount);
772 
773         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
774 
775         uint256 fromBalance = _balances[id][from];
776         require(
777             fromBalance >= amount,
778             "ERC1155: insufficient balance for transfer"
779         );
780         unchecked {
781             _balances[id][from] = fromBalance - amount;
782         }
783         _balances[id][to] += amount;
784 
785         emit TransferSingle(operator, from, to, id, amount);
786 
787         _afterTokenTransfer(operator, from, to, ids, amounts, data);
788 
789         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
790     }
791 
792     /**
793      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
794      *
795      * Emits a {TransferBatch} event.
796      *
797      * Requirements:
798      *
799      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
800      * acceptance magic value.
801      */
802     function _safeBatchTransferFrom(
803         address from,
804         address to,
805         uint256[] memory ids,
806         uint256[] memory amounts,
807         bytes memory data
808     ) internal virtual {
809         require(
810             ids.length == amounts.length,
811             "ERC1155: ids and amounts length mismatch"
812         );
813         require(to != address(0), "ERC1155: transfer to the zero address");
814 
815         address operator = _msgSender();
816 
817         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
818 
819         for (uint256 i = 0; i < ids.length; ++i) {
820             uint256 id = ids[i];
821             uint256 amount = amounts[i];
822 
823             uint256 fromBalance = _balances[id][from];
824             require(
825                 fromBalance >= amount,
826                 "ERC1155: insufficient balance for transfer"
827             );
828             unchecked {
829                 _balances[id][from] = fromBalance - amount;
830             }
831             _balances[id][to] += amount;
832         }
833 
834         emit TransferBatch(operator, from, to, ids, amounts);
835 
836         _afterTokenTransfer(operator, from, to, ids, amounts, data);
837 
838         _doSafeBatchTransferAcceptanceCheck(
839             operator,
840             from,
841             to,
842             ids,
843             amounts,
844             data
845         );
846     }
847 
848     /**
849      * @dev Sets a new URI for all token types, by relying on the token type ID
850      * substitution mechanism
851      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
852      *
853      * By this mechanism, any occurrence of the `\{id\}` substring in either the
854      * URI or any of the amounts in the JSON file at said URI will be replaced by
855      * clients with the token type ID.
856      *
857      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
858      * interpreted by clients as
859      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
860      * for token type ID 0x4cce0.
861      *
862      * See {uri}.
863      *
864      * Because these URIs cannot be meaningfully represented by the {URI} event,
865      * this function emits no events.
866      */
867     function _setURI(string memory newuri) internal virtual {
868         _uri = newuri;
869     }
870 
871     /**
872      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
873      *
874      * Emits a {TransferSingle} event.
875      *
876      * Requirements:
877      *
878      * - `to` cannot be the zero address.
879      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
880      * acceptance magic value.
881      */
882     function _mint(
883         address to,
884         uint256 id,
885         uint256 amount,
886         bytes memory data
887     ) internal virtual {
888         require(to != address(0), "ERC1155: mint to the zero address");
889 
890         address operator = _msgSender();
891         uint256[] memory ids = _asSingletonArray(id);
892         uint256[] memory amounts = _asSingletonArray(amount);
893 
894         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
895 
896         _balances[id][to] += amount;
897         emit TransferSingle(operator, address(0), to, id, amount);
898 
899         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
900 
901         _doSafeTransferAcceptanceCheck(
902             operator,
903             address(0),
904             to,
905             id,
906             amount,
907             data
908         );
909     }
910 
911     /**
912      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
913      *
914      * Emits a {TransferBatch} event.
915      *
916      * Requirements:
917      *
918      * - `ids` and `amounts` must have the same length.
919      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
920      * acceptance magic value.
921      */
922     function _mintBatch(
923         address to,
924         uint256[] memory ids,
925         uint256[] memory amounts,
926         bytes memory data
927     ) internal virtual {
928         require(to != address(0), "ERC1155: mint to the zero address");
929         require(
930             ids.length == amounts.length,
931             "ERC1155: ids and amounts length mismatch"
932         );
933 
934         address operator = _msgSender();
935 
936         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
937 
938         for (uint256 i = 0; i < ids.length; i++) {
939             _balances[ids[i]][to] += amounts[i];
940         }
941 
942         emit TransferBatch(operator, address(0), to, ids, amounts);
943 
944         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
945 
946         _doSafeBatchTransferAcceptanceCheck(
947             operator,
948             address(0),
949             to,
950             ids,
951             amounts,
952             data
953         );
954     }
955 
956     /**
957      * @dev Destroys `amount` tokens of token type `id` from `from`
958      *
959      * Emits a {TransferSingle} event.
960      *
961      * Requirements:
962      *
963      * - `from` cannot be the zero address.
964      * - `from` must have at least `amount` tokens of token type `id`.
965      */
966     function _burn(
967         address from,
968         uint256 id,
969         uint256 amount
970     ) internal virtual {
971         require(from != address(0), "ERC1155: burn from the zero address");
972 
973         address operator = _msgSender();
974         uint256[] memory ids = _asSingletonArray(id);
975         uint256[] memory amounts = _asSingletonArray(amount);
976 
977         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
978 
979         uint256 fromBalance = _balances[id][from];
980         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
981         unchecked {
982             _balances[id][from] = fromBalance - amount;
983         }
984 
985         emit TransferSingle(operator, from, address(0), id, amount);
986 
987         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
988     }
989 
990     /**
991      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
992      *
993      * Emits a {TransferBatch} event.
994      *
995      * Requirements:
996      *
997      * - `ids` and `amounts` must have the same length.
998      */
999     function _burnBatch(
1000         address from,
1001         uint256[] memory ids,
1002         uint256[] memory amounts
1003     ) internal virtual {
1004         require(from != address(0), "ERC1155: burn from the zero address");
1005         require(
1006             ids.length == amounts.length,
1007             "ERC1155: ids and amounts length mismatch"
1008         );
1009 
1010         address operator = _msgSender();
1011 
1012         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1013 
1014         for (uint256 i = 0; i < ids.length; i++) {
1015             uint256 id = ids[i];
1016             uint256 amount = amounts[i];
1017 
1018             uint256 fromBalance = _balances[id][from];
1019             require(
1020                 fromBalance >= amount,
1021                 "ERC1155: burn amount exceeds balance"
1022             );
1023             unchecked {
1024                 _balances[id][from] = fromBalance - amount;
1025             }
1026         }
1027 
1028         emit TransferBatch(operator, from, address(0), ids, amounts);
1029 
1030         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1031     }
1032 
1033     /**
1034      * @dev Approve `operator` to operate on all of `owner` tokens
1035      *
1036      * Emits an {ApprovalForAll} event.
1037      */
1038     function _setApprovalForAll(
1039         address owner,
1040         address operator,
1041         bool approved
1042     ) internal virtual {
1043         require(owner != operator, "ERC1155: setting approval status for self");
1044         _operatorApprovals[owner][operator] = approved;
1045         emit ApprovalForAll(owner, operator, approved);
1046     }
1047 
1048     /**
1049      * @dev Hook that is called before any token transfer. This includes minting
1050      * and burning, as well as batched variants.
1051      *
1052      * The same hook is called on both single and batched variants. For single
1053      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1054      *
1055      * Calling conditions (for each `id` and `amount` pair):
1056      *
1057      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1058      * of token type `id` will be  transferred to `to`.
1059      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1060      * for `to`.
1061      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1062      * will be burned.
1063      * - `from` and `to` are never both zero.
1064      * - `ids` and `amounts` have the same, non-zero length.
1065      *
1066      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1067      */
1068     function _beforeTokenTransfer(
1069         address operator,
1070         address from,
1071         address to,
1072         uint256[] memory ids,
1073         uint256[] memory amounts,
1074         bytes memory data
1075     ) internal virtual {}
1076 
1077     /**
1078      * @dev Hook that is called after any token transfer. This includes minting
1079      * and burning, as well as batched variants.
1080      *
1081      * The same hook is called on both single and batched variants. For single
1082      * transfers, the length of the `id` and `amount` arrays will be 1.
1083      *
1084      * Calling conditions (for each `id` and `amount` pair):
1085      *
1086      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1087      * of token type `id` will be  transferred to `to`.
1088      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1089      * for `to`.
1090      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1091      * will be burned.
1092      * - `from` and `to` are never both zero.
1093      * - `ids` and `amounts` have the same, non-zero length.
1094      *
1095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1096      */
1097     function _afterTokenTransfer(
1098         address operator,
1099         address from,
1100         address to,
1101         uint256[] memory ids,
1102         uint256[] memory amounts,
1103         bytes memory data
1104     ) internal virtual {}
1105 
1106     function _doSafeTransferAcceptanceCheck(
1107         address operator,
1108         address from,
1109         address to,
1110         uint256 id,
1111         uint256 amount,
1112         bytes memory data
1113     ) private {
1114         if (to.isContract()) {
1115             try
1116                 IERC1155Receiver(to).onERC1155Received(
1117                     operator,
1118                     from,
1119                     id,
1120                     amount,
1121                     data
1122                 )
1123             returns (bytes4 response) {
1124                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1125                     revert("ERC1155: ERC1155Receiver rejected tokens");
1126                 }
1127             } catch Error(string memory reason) {
1128                 revert(reason);
1129             } catch {
1130                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1131             }
1132         }
1133     }
1134 
1135     function _doSafeBatchTransferAcceptanceCheck(
1136         address operator,
1137         address from,
1138         address to,
1139         uint256[] memory ids,
1140         uint256[] memory amounts,
1141         bytes memory data
1142     ) private {
1143         if (to.isContract()) {
1144             try
1145                 IERC1155Receiver(to).onERC1155BatchReceived(
1146                     operator,
1147                     from,
1148                     ids,
1149                     amounts,
1150                     data
1151                 )
1152             returns (bytes4 response) {
1153                 if (
1154                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1155                 ) {
1156                     revert("ERC1155: ERC1155Receiver rejected tokens");
1157                 }
1158             } catch Error(string memory reason) {
1159                 revert(reason);
1160             } catch {
1161                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1162             }
1163         }
1164     }
1165 
1166     function _asSingletonArray(uint256 element)
1167         private
1168         pure
1169         returns (uint256[] memory)
1170     {
1171         uint256[] memory array = new uint256[](1);
1172         array[0] = element;
1173 
1174         return array;
1175     }
1176 }
1177 
1178 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.2
1179 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 /**
1184  * @dev String operations.
1185  */
1186 library Strings {
1187     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1188     uint8 private constant _ADDRESS_LENGTH = 20;
1189 
1190     /**
1191      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1192      */
1193     function toString(uint256 value) internal pure returns (string memory) {
1194         // Inspired by OraclizeAPI's implementation - MIT licence
1195         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1196 
1197         if (value == 0) {
1198             return "0";
1199         }
1200         uint256 temp = value;
1201         uint256 digits;
1202         while (temp != 0) {
1203             digits++;
1204             temp /= 10;
1205         }
1206         bytes memory buffer = new bytes(digits);
1207         while (value != 0) {
1208             digits -= 1;
1209             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1210             value /= 10;
1211         }
1212         return string(buffer);
1213     }
1214 
1215     /**
1216      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1217      */
1218     function toHexString(uint256 value) internal pure returns (string memory) {
1219         if (value == 0) {
1220             return "0x00";
1221         }
1222         uint256 temp = value;
1223         uint256 length = 0;
1224         while (temp != 0) {
1225             length++;
1226             temp >>= 8;
1227         }
1228         return toHexString(value, length);
1229     }
1230 
1231     /**
1232      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1233      */
1234     function toHexString(uint256 value, uint256 length)
1235         internal
1236         pure
1237         returns (string memory)
1238     {
1239         bytes memory buffer = new bytes(2 * length + 2);
1240         buffer[0] = "0";
1241         buffer[1] = "x";
1242         for (uint256 i = 2 * length + 1; i > 1; --i) {
1243             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1244             value >>= 4;
1245         }
1246         require(value == 0, "Strings: hex length insufficient");
1247         return string(buffer);
1248     }
1249 
1250     /**
1251      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1252      */
1253     function toHexString(address addr) internal pure returns (string memory) {
1254         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1255     }
1256 }
1257 
1258 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.2
1259 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 /**
1264  * @dev Contract module which provides a basic access control mechanism, where
1265  * there is an account (an owner) that can be granted exclusive access to
1266  * specific functions.
1267  *
1268  * By default, the owner account will be the one that deploys the contract. This
1269  * can later be changed with {transferOwnership}.
1270  *
1271  * This module is used through inheritance. It will make available the modifier
1272  * `onlyOwner`, which can be applied to your functions to restrict their use to
1273  * the owner.
1274  */
1275 abstract contract Ownable is Context {
1276     address private _owner;
1277 
1278     event OwnershipTransferred(
1279         address indexed previousOwner,
1280         address indexed newOwner
1281     );
1282 
1283     /**
1284      * @dev Initializes the contract setting the deployer as the initial owner.
1285      */
1286     constructor() {
1287         _transferOwnership(_msgSender());
1288     }
1289 
1290     /**
1291      * @dev Throws if called by any account other than the owner.
1292      */
1293     modifier onlyOwner() {
1294         _checkOwner();
1295         _;
1296     }
1297 
1298     /**
1299      * @dev Returns the address of the current owner.
1300      */
1301     function owner() public view virtual returns (address) {
1302         return _owner;
1303     }
1304 
1305     /**
1306      * @dev Throws if the sender is not the owner.
1307      */
1308     function _checkOwner() internal view virtual {
1309         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1310     }
1311 
1312     /**
1313      * @dev Leaves the contract without owner. It will not be possible to call
1314      * `onlyOwner` functions anymore. Can only be called by the current owner.
1315      *
1316      * NOTE: Renouncing ownership will leave the contract without an owner,
1317      * thereby removing any functionality that is only available to the owner.
1318      */
1319     function renounceOwnership() public virtual onlyOwner {
1320         _transferOwnership(address(0));
1321     }
1322 
1323     /**
1324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1325      * Can only be called by the current owner.
1326      */
1327     function transferOwnership(address newOwner) public virtual onlyOwner {
1328         require(
1329             newOwner != address(0),
1330             "Ownable: new owner is the zero address"
1331         );
1332         _transferOwnership(newOwner);
1333     }
1334 
1335     /**
1336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1337      * Internal function without access restriction.
1338      */
1339     function _transferOwnership(address newOwner) internal virtual {
1340         address oldOwner = _owner;
1341         _owner = newOwner;
1342         emit OwnershipTransferred(oldOwner, newOwner);
1343     }
1344 }
1345 
1346 // File @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol@v4.7.2
1347 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1348 
1349 pragma solidity ^0.8.0;
1350 
1351 /**
1352  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1353  *
1354  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1355  * clearly identified. Note: While a totalSupply of 1 might mean the
1356  * corresponding is an NFT, there is no guarantees that no other token with the
1357  * same id are not going to be minted.
1358  */
1359 abstract contract ERC1155Supply is ERC1155 {
1360     mapping(uint256 => uint256) private _totalSupply;
1361 
1362     /**
1363      * @dev Total amount of tokens in with a given id.
1364      */
1365     function totalSupply(uint256 id) public view virtual returns (uint256) {
1366         return _totalSupply[id];
1367     }
1368 
1369     /**
1370      * @dev Indicates whether any token exist with a given id, or not.
1371      */
1372     function exists(uint256 id) public view virtual returns (bool) {
1373         return ERC1155Supply.totalSupply(id) > 0;
1374     }
1375 
1376     /**
1377      * @dev See {ERC1155-_beforeTokenTransfer}.
1378      */
1379     function _beforeTokenTransfer(
1380         address operator,
1381         address from,
1382         address to,
1383         uint256[] memory ids,
1384         uint256[] memory amounts,
1385         bytes memory data
1386     ) internal virtual override {
1387         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1388 
1389         if (from == address(0)) {
1390             for (uint256 i = 0; i < ids.length; ++i) {
1391                 _totalSupply[ids[i]] += amounts[i];
1392             }
1393         }
1394 
1395         if (to == address(0)) {
1396             for (uint256 i = 0; i < ids.length; ++i) {
1397                 uint256 id = ids[i];
1398                 uint256 amount = amounts[i];
1399                 uint256 supply = _totalSupply[id];
1400                 require(
1401                     supply >= amount,
1402                     "ERC1155: burn amount exceeds totalSupply"
1403                 );
1404                 unchecked {
1405                     _totalSupply[id] = supply - amount;
1406                 }
1407             }
1408         }
1409     }
1410 }
1411 
1412 // SafeMath
1413 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1414 
1415 pragma solidity ^0.8.0;
1416 
1417 // CAUTION
1418 // This version of SafeMath should only be used with Solidity 0.8 or later,
1419 // because it relies on the compiler's built in overflow checks.
1420 
1421 /**
1422  * @dev Wrappers over Solidity's arithmetic operations.
1423  *
1424  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1425  * now has built in overflow checking.
1426  */
1427 library SafeMath {
1428     /**
1429      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1430      *
1431      * _Available since v3.4._
1432      */
1433     function tryAdd(uint256 a, uint256 b)
1434         internal
1435         pure
1436         returns (bool, uint256)
1437     {
1438         unchecked {
1439             uint256 c = a + b;
1440             if (c < a) return (false, 0);
1441             return (true, c);
1442         }
1443     }
1444 
1445     /**
1446      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1447      *
1448      * _Available since v3.4._
1449      */
1450     function trySub(uint256 a, uint256 b)
1451         internal
1452         pure
1453         returns (bool, uint256)
1454     {
1455         unchecked {
1456             if (b > a) return (false, 0);
1457             return (true, a - b);
1458         }
1459     }
1460 
1461     /**
1462      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1463      *
1464      * _Available since v3.4._
1465      */
1466     function tryMul(uint256 a, uint256 b)
1467         internal
1468         pure
1469         returns (bool, uint256)
1470     {
1471         unchecked {
1472             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1473             // benefit is lost if 'b' is also tested.
1474             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1475             if (a == 0) return (true, 0);
1476             uint256 c = a * b;
1477             if (c / a != b) return (false, 0);
1478             return (true, c);
1479         }
1480     }
1481 
1482     /**
1483      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1484      *
1485      * _Available since v3.4._
1486      */
1487     function tryDiv(uint256 a, uint256 b)
1488         internal
1489         pure
1490         returns (bool, uint256)
1491     {
1492         unchecked {
1493             if (b == 0) return (false, 0);
1494             return (true, a / b);
1495         }
1496     }
1497 
1498     /**
1499      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1500      *
1501      * _Available since v3.4._
1502      */
1503     function tryMod(uint256 a, uint256 b)
1504         internal
1505         pure
1506         returns (bool, uint256)
1507     {
1508         unchecked {
1509             if (b == 0) return (false, 0);
1510             return (true, a % b);
1511         }
1512     }
1513 
1514     /**
1515      * @dev Returns the addition of two unsigned integers, reverting on
1516      * overflow.
1517      *
1518      * Counterpart to Solidity's `+` operator.
1519      *
1520      * Requirements:
1521      *
1522      * - Addition cannot overflow.
1523      */
1524     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1525         return a + b;
1526     }
1527 
1528     /**
1529      * @dev Returns the subtraction of two unsigned integers, reverting on
1530      * overflow (when the result is negative).
1531      *
1532      * Counterpart to Solidity's `-` operator.
1533      *
1534      * Requirements:
1535      *
1536      * - Subtraction cannot overflow.
1537      */
1538     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1539         return a - b;
1540     }
1541 
1542     /**
1543      * @dev Returns the multiplication of two unsigned integers, reverting on
1544      * overflow.
1545      *
1546      * Counterpart to Solidity's `*` operator.
1547      *
1548      * Requirements:
1549      *
1550      * - Multiplication cannot overflow.
1551      */
1552     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1553         return a * b;
1554     }
1555 
1556     /**
1557      * @dev Returns the integer division of two unsigned integers, reverting on
1558      * division by zero. The result is rounded towards zero.
1559      *
1560      * Counterpart to Solidity's `/` operator.
1561      *
1562      * Requirements:
1563      *
1564      * - The divisor cannot be zero.
1565      */
1566     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1567         return a / b;
1568     }
1569 
1570     /**
1571      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1572      * reverting when dividing by zero.
1573      *
1574      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1575      * opcode (which leaves remaining gas untouched) while Solidity uses an
1576      * invalid opcode to revert (consuming all remaining gas).
1577      *
1578      * Requirements:
1579      *
1580      * - The divisor cannot be zero.
1581      */
1582     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1583         return a % b;
1584     }
1585 
1586     /**
1587      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1588      * overflow (when the result is negative).
1589      *
1590      * CAUTION: This function is deprecated because it requires allocating memory for the error
1591      * message unnecessarily. For custom revert reasons use {trySub}.
1592      *
1593      * Counterpart to Solidity's `-` operator.
1594      *
1595      * Requirements:
1596      *
1597      * - Subtraction cannot overflow.
1598      */
1599     function sub(
1600         uint256 a,
1601         uint256 b,
1602         string memory errorMessage
1603     ) internal pure returns (uint256) {
1604         unchecked {
1605             require(b <= a, errorMessage);
1606             return a - b;
1607         }
1608     }
1609 
1610     /**
1611      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1612      * division by zero. The result is rounded towards zero.
1613      *
1614      * Counterpart to Solidity's `/` operator. Note: this function uses a
1615      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1616      * uses an invalid opcode to revert (consuming all remaining gas).
1617      *
1618      * Requirements:
1619      *
1620      * - The divisor cannot be zero.
1621      */
1622     function div(
1623         uint256 a,
1624         uint256 b,
1625         string memory errorMessage
1626     ) internal pure returns (uint256) {
1627         unchecked {
1628             require(b > 0, errorMessage);
1629             return a / b;
1630         }
1631     }
1632 
1633     /**
1634      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1635      * reverting with custom message when dividing by zero.
1636      *
1637      * CAUTION: This function is deprecated because it requires allocating memory for the error
1638      * message unnecessarily. For custom revert reasons use {tryMod}.
1639      *
1640      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1641      * opcode (which leaves remaining gas untouched) while Solidity uses an
1642      * invalid opcode to revert (consuming all remaining gas).
1643      *
1644      * Requirements:
1645      *
1646      * - The divisor cannot be zero.
1647      */
1648     function mod(
1649         uint256 a,
1650         uint256 b,
1651         string memory errorMessage
1652     ) internal pure returns (uint256) {
1653         unchecked {
1654             require(b > 0, errorMessage);
1655             return a % b;
1656         }
1657     }
1658 }
1659 
1660 pragma solidity ^0.8.0;
1661 
1662 /**
1663  * @dev Contract module which allows children to implement an emergency stop
1664  * mechanism that can be triggered by an authorized account.
1665  *
1666  * This module is used through inheritance. It will make available the
1667  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1668  * the functions of your contract. Note that they will not be pausable by
1669  * simply including this module, only once the modifiers are put in place.
1670  */
1671 abstract contract Pausable is Context {
1672     /**
1673      * @dev Emitted when the pause is triggered by `account`.
1674      */
1675     event Paused(address account);
1676 
1677     /**
1678      * @dev Emitted when the pause is lifted by `account`.
1679      */
1680     event Unpaused(address account);
1681 
1682     bool private _paused;
1683 
1684     /**
1685      * @dev Initializes the contract in unpaused state.
1686      */
1687     constructor() {
1688         _paused = false;
1689     }
1690 
1691     /**
1692      * @dev Returns true if the contract is paused, and false otherwise.
1693      */
1694     function paused() public view virtual returns (bool) {
1695         return _paused;
1696     }
1697 
1698     /**
1699      * @dev Modifier to make a function callable only when the contract is not paused.
1700      *
1701      * Requirements:
1702      *
1703      * - The contract must not be paused.
1704      */
1705     modifier whenNotPaused() {
1706         require(!paused(), "Pausable: paused");
1707         _;
1708     }
1709 
1710     /**
1711      * @dev Modifier to make a function callable only when the contract is paused.
1712      *
1713      * Requirements:
1714      *
1715      * - The contract must be paused.
1716      */
1717     modifier whenPaused() {
1718         require(paused(), "Pausable: not paused");
1719         _;
1720     }
1721 
1722     /**
1723      * @dev Triggers stopped state.
1724      *
1725      * Requirements:
1726      *
1727      * - The contract must not be paused.
1728      */
1729     function _pause() internal virtual whenNotPaused {
1730         _paused = true;
1731         emit Paused(_msgSender());
1732     }
1733 
1734     /**
1735      * @dev Returns to normal state.
1736      *
1737      * Requirements:
1738      *
1739      * - The contract must be paused.
1740      */
1741     function _unpause() internal virtual whenPaused {
1742         _paused = false;
1743         emit Unpaused(_msgSender());
1744     }
1745 }
1746 
1747 /**
1748  * @title SafeERC20
1749  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1750  * contract returns false). Tokens that return no value (and instead revert or
1751  * throw on failure) are also supported, non-reverting calls are assumed to be
1752  * successful.
1753  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1754  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1755  */
1756 library SafeERC20 {
1757     using Address for address;
1758 
1759     function safeTransfer(
1760         IERC20 token,
1761         address to,
1762         uint256 value
1763     ) internal {
1764         _callOptionalReturn(
1765             token,
1766             abi.encodeWithSelector(token.transfer.selector, to, value)
1767         );
1768     }
1769 
1770     function safeTransferFrom(
1771         IERC20 token,
1772         address from,
1773         address to,
1774         uint256 value
1775     ) internal {
1776         _callOptionalReturn(
1777             token,
1778             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1779         );
1780     }
1781 
1782     /**
1783      * @dev Deprecated. This function has issues similar to the ones found in
1784      * {IERC20-approve}, and its usage is discouraged.
1785      *
1786      * Whenever possible, use {safeIncreaseAllowance} and
1787      * {safeDecreaseAllowance} instead.
1788      */
1789     function safeApprove(
1790         IERC20 token,
1791         address spender,
1792         uint256 value
1793     ) internal {
1794         // safeApprove should only be called when setting an initial allowance,
1795         // or when resetting it to zero. To increase and decrease it, use
1796         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1797         require(
1798             (value == 0) || (token.allowance(address(this), spender) == 0),
1799             "SafeERC20: approve from non-zero to non-zero allowance"
1800         );
1801         _callOptionalReturn(
1802             token,
1803             abi.encodeWithSelector(token.approve.selector, spender, value)
1804         );
1805     }
1806 
1807     function safeIncreaseAllowance(
1808         IERC20 token,
1809         address spender,
1810         uint256 value
1811     ) internal {
1812         uint256 newAllowance = token.allowance(address(this), spender) + value;
1813         _callOptionalReturn(
1814             token,
1815             abi.encodeWithSelector(
1816                 token.approve.selector,
1817                 spender,
1818                 newAllowance
1819             )
1820         );
1821     }
1822 
1823     function safeDecreaseAllowance(
1824         IERC20 token,
1825         address spender,
1826         uint256 value
1827     ) internal {
1828         unchecked {
1829             uint256 oldAllowance = token.allowance(address(this), spender);
1830             require(
1831                 oldAllowance >= value,
1832                 "SafeERC20: decreased allowance below zero"
1833             );
1834             uint256 newAllowance = oldAllowance - value;
1835             _callOptionalReturn(
1836                 token,
1837                 abi.encodeWithSelector(
1838                     token.approve.selector,
1839                     spender,
1840                     newAllowance
1841                 )
1842             );
1843         }
1844     }
1845 
1846     /**
1847      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1848      * on the return value: the return value is optional (but if data is returned, it must not be false).
1849      * @param token The token targeted by the call.
1850      * @param data The call data (encoded using abi.encode or one of its variants).
1851      */
1852     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1853         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1854         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1855         // the target address contains contract code and also asserts for success in the low-level call.
1856 
1857         bytes memory returndata = address(token).functionCall(
1858             data,
1859             "SafeERC20: low-level call failed"
1860         );
1861         if (returndata.length > 0) {
1862             // Return data is optional
1863             require(
1864                 abi.decode(returndata, (bool)),
1865                 "SafeERC20: ERC20 operation did not succeed"
1866             );
1867         }
1868     }
1869 }
1870 
1871 pragma solidity ^0.8.0;
1872 
1873 /**
1874  * @dev Library for managing
1875  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1876  * types.
1877  *
1878  * Sets have the following properties:
1879  *
1880  * - Elements are added, removed, and checked for existence in constant time
1881  * (O(1)).
1882  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1883  *
1884  * ```
1885  * contract Example {
1886  *     // Add the library methods
1887  *     using EnumerableSet for EnumerableSet.AddressSet;
1888  *
1889  *     // Declare a set state variable
1890  *     EnumerableSet.AddressSet private mySet;
1891  * }
1892  * ```
1893  *
1894  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1895  * and `uint256` (`UintSet`) are supported.
1896  */
1897 library EnumerableSet {
1898     // To implement this library for multiple types with as little code
1899     // repetition as possible, we write it in terms of a generic Set type with
1900     // bytes32 values.
1901     // The Set implementation uses private functions, and user-facing
1902     // implementations (such as AddressSet) are just wrappers around the
1903     // underlying Set.
1904     // This means that we can only create new EnumerableSets for types that fit
1905     // in bytes32.
1906 
1907     struct Set {
1908         // Storage of set values
1909         bytes32[] _values;
1910         // Position of the value in the `values` array, plus 1 because index 0
1911         // means a value is not in the set.
1912         mapping(bytes32 => uint256) _indexes;
1913     }
1914 
1915     /**
1916      * @dev Add a value to a set. O(1).
1917      *
1918      * Returns true if the value was added to the set, that is if it was not
1919      * already present.
1920      */
1921     function _add(Set storage set, bytes32 value) private returns (bool) {
1922         if (!_contains(set, value)) {
1923             set._values.push(value);
1924             // The value is stored at length-1, but we add 1 to all indexes
1925             // and use 0 as a sentinel value
1926             set._indexes[value] = set._values.length;
1927             return true;
1928         } else {
1929             return false;
1930         }
1931     }
1932 
1933     /**
1934      * @dev Removes a value from a set. O(1).
1935      *
1936      * Returns true if the value was removed from the set, that is if it was
1937      * present.
1938      */
1939     function _remove(Set storage set, bytes32 value) private returns (bool) {
1940         // We read and store the value's index to prevent multiple reads from the same storage slot
1941         uint256 valueIndex = set._indexes[value];
1942 
1943         if (valueIndex != 0) {
1944             // Equivalent to contains(set, value)
1945             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1946             // the array, and then remove the last element (sometimes called as 'swap and pop').
1947             // This modifies the order of the array, as noted in {at}.
1948 
1949             uint256 toDeleteIndex = valueIndex - 1;
1950             uint256 lastIndex = set._values.length - 1;
1951 
1952             if (lastIndex != toDeleteIndex) {
1953                 bytes32 lastvalue = set._values[lastIndex];
1954 
1955                 // Move the last value to the index where the value to delete is
1956                 set._values[toDeleteIndex] = lastvalue;
1957                 // Update the index for the moved value
1958                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1959             }
1960 
1961             // Delete the slot where the moved value was stored
1962             set._values.pop();
1963 
1964             // Delete the index for the deleted slot
1965             delete set._indexes[value];
1966 
1967             return true;
1968         } else {
1969             return false;
1970         }
1971     }
1972 
1973     /**
1974      * @dev Returns true if the value is in the set. O(1).
1975      */
1976     function _contains(Set storage set, bytes32 value)
1977         private
1978         view
1979         returns (bool)
1980     {
1981         return set._indexes[value] != 0;
1982     }
1983 
1984     /**
1985      * @dev Returns the number of values on the set. O(1).
1986      */
1987     function _length(Set storage set) private view returns (uint256) {
1988         return set._values.length;
1989     }
1990 
1991     /**
1992      * @dev Returns the value stored at position `index` in the set. O(1).
1993      *
1994      * Note that there are no guarantees on the ordering of values inside the
1995      * array, and it may change when more values are added or removed.
1996      *
1997      * Requirements:
1998      *
1999      * - `index` must be strictly less than {length}.
2000      */
2001     function _at(Set storage set, uint256 index)
2002         private
2003         view
2004         returns (bytes32)
2005     {
2006         return set._values[index];
2007     }
2008 
2009     /**
2010      * @dev Return the entire set in an array
2011      *
2012      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2013      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2014      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2015      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2016      */
2017     function _values(Set storage set) private view returns (bytes32[] memory) {
2018         return set._values;
2019     }
2020 
2021     // Bytes32Set
2022 
2023     struct Bytes32Set {
2024         Set _inner;
2025     }
2026 
2027     /**
2028      * @dev Add a value to a set. O(1).
2029      *
2030      * Returns true if the value was added to the set, that is if it was not
2031      * already present.
2032      */
2033     function add(Bytes32Set storage set, bytes32 value)
2034         internal
2035         returns (bool)
2036     {
2037         return _add(set._inner, value);
2038     }
2039 
2040     /**
2041      * @dev Removes a value from a set. O(1).
2042      *
2043      * Returns true if the value was removed from the set, that is if it was
2044      * present.
2045      */
2046     function remove(Bytes32Set storage set, bytes32 value)
2047         internal
2048         returns (bool)
2049     {
2050         return _remove(set._inner, value);
2051     }
2052 
2053     /**
2054      * @dev Returns true if the value is in the set. O(1).
2055      */
2056     function contains(Bytes32Set storage set, bytes32 value)
2057         internal
2058         view
2059         returns (bool)
2060     {
2061         return _contains(set._inner, value);
2062     }
2063 
2064     /**
2065      * @dev Returns the number of values in the set. O(1).
2066      */
2067     function length(Bytes32Set storage set) internal view returns (uint256) {
2068         return _length(set._inner);
2069     }
2070 
2071     /**
2072      * @dev Returns the value stored at position `index` in the set. O(1).
2073      *
2074      * Note that there are no guarantees on the ordering of values inside the
2075      * array, and it may change when more values are added or removed.
2076      *
2077      * Requirements:
2078      *
2079      * - `index` must be strictly less than {length}.
2080      */
2081     function at(Bytes32Set storage set, uint256 index)
2082         internal
2083         view
2084         returns (bytes32)
2085     {
2086         return _at(set._inner, index);
2087     }
2088 
2089     /**
2090      * @dev Return the entire set in an array
2091      *
2092      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2093      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2094      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2095      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2096      */
2097     function values(Bytes32Set storage set)
2098         internal
2099         view
2100         returns (bytes32[] memory)
2101     {
2102         return _values(set._inner);
2103     }
2104 
2105     // AddressSet
2106 
2107     struct AddressSet {
2108         Set _inner;
2109     }
2110 
2111     /**
2112      * @dev Add a value to a set. O(1).
2113      *
2114      * Returns true if the value was added to the set, that is if it was not
2115      * already present.
2116      */
2117     function add(AddressSet storage set, address value)
2118         internal
2119         returns (bool)
2120     {
2121         return _add(set._inner, bytes32(uint256(uint160(value))));
2122     }
2123 
2124     /**
2125      * @dev Removes a value from a set. O(1).
2126      *
2127      * Returns true if the value was removed from the set, that is if it was
2128      * present.
2129      */
2130     function remove(AddressSet storage set, address value)
2131         internal
2132         returns (bool)
2133     {
2134         return _remove(set._inner, bytes32(uint256(uint160(value))));
2135     }
2136 
2137     /**
2138      * @dev Returns true if the value is in the set. O(1).
2139      */
2140     function contains(AddressSet storage set, address value)
2141         internal
2142         view
2143         returns (bool)
2144     {
2145         return _contains(set._inner, bytes32(uint256(uint160(value))));
2146     }
2147 
2148     /**
2149      * @dev Returns the number of values in the set. O(1).
2150      */
2151     function length(AddressSet storage set) internal view returns (uint256) {
2152         return _length(set._inner);
2153     }
2154 
2155     /**
2156      * @dev Returns the value stored at position `index` in the set. O(1).
2157      *
2158      * Note that there are no guarantees on the ordering of values inside the
2159      * array, and it may change when more values are added or removed.
2160      *
2161      * Requirements:
2162      *
2163      * - `index` must be strictly less than {length}.
2164      */
2165     function at(AddressSet storage set, uint256 index)
2166         internal
2167         view
2168         returns (address)
2169     {
2170         return address(uint160(uint256(_at(set._inner, index))));
2171     }
2172 
2173     /**
2174      * @dev Return the entire set in an array
2175      *
2176      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2177      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2178      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2179      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2180      */
2181     function values(AddressSet storage set)
2182         internal
2183         view
2184         returns (address[] memory)
2185     {
2186         bytes32[] memory store = _values(set._inner);
2187         address[] memory result;
2188 
2189         assembly {
2190             result := store
2191         }
2192 
2193         return result;
2194     }
2195 
2196     // UintSet
2197 
2198     struct UintSet {
2199         Set _inner;
2200     }
2201 
2202     /**
2203      * @dev Add a value to a set. O(1).
2204      *
2205      * Returns true if the value was added to the set, that is if it was not
2206      * already present.
2207      */
2208     function add(UintSet storage set, uint256 value) internal returns (bool) {
2209         return _add(set._inner, bytes32(value));
2210     }
2211 
2212     /**
2213      * @dev Removes a value from a set. O(1).
2214      *
2215      * Returns true if the value was removed from the set, that is if it was
2216      * present.
2217      */
2218     function remove(UintSet storage set, uint256 value)
2219         internal
2220         returns (bool)
2221     {
2222         return _remove(set._inner, bytes32(value));
2223     }
2224 
2225     /**
2226      * @dev Returns true if the value is in the set. O(1).
2227      */
2228     function contains(UintSet storage set, uint256 value)
2229         internal
2230         view
2231         returns (bool)
2232     {
2233         return _contains(set._inner, bytes32(value));
2234     }
2235 
2236     /**
2237      * @dev Returns the number of values on the set. O(1).
2238      */
2239     function length(UintSet storage set) internal view returns (uint256) {
2240         return _length(set._inner);
2241     }
2242 
2243     /**
2244      * @dev Returns the value stored at position `index` in the set. O(1).
2245      *
2246      * Note that there are no guarantees on the ordering of values inside the
2247      * array, and it may change when more values are added or removed.
2248      *
2249      * Requirements:
2250      *
2251      * - `index` must be strictly less than {length}.
2252      */
2253     function at(UintSet storage set, uint256 index)
2254         internal
2255         view
2256         returns (uint256)
2257     {
2258         return uint256(_at(set._inner, index));
2259     }
2260 
2261     /**
2262      * @dev Return the entire set in an array
2263      *
2264      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2265      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2266      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2267      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2268      */
2269     function values(UintSet storage set)
2270         internal
2271         view
2272         returns (uint256[] memory)
2273     {
2274         bytes32[] memory store = _values(set._inner);
2275         uint256[] memory result;
2276 
2277         assembly {
2278             result := store
2279         }
2280 
2281         return result;
2282     }
2283 }
2284 
2285 pragma solidity ^0.8.0;
2286 
2287 /**
2288  * @dev Interface of the ERC20 standard as defined in the EIP.
2289  */
2290 interface IERC20 {
2291     /**
2292      * @dev Returns the amount of tokens in existence.
2293      */
2294     function totalSupply() external view returns (uint256);
2295 
2296     /**
2297      * @dev Returns the amount of tokens owned by `account`.
2298      */
2299     function balanceOf(address account) external view returns (uint256);
2300 
2301     /**
2302      * @dev Moves `amount` tokens from the caller's account to `recipient`.
2303      *
2304      * Returns a boolean value indicating whether the operation succeeded.
2305      *
2306      * Emits a {Transfer} event.
2307      */
2308     function transfer(address recipient, uint256 amount)
2309         external
2310         returns (bool);
2311 
2312     /**
2313      * @dev Returns the remaining number of tokens that `spender` will be
2314      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2315      * zero by default.
2316      *
2317      * This value changes when {approve} or {transferFrom} are called.
2318      */
2319     function allowance(address owner, address spender)
2320         external
2321         view
2322         returns (uint256);
2323 
2324     /**
2325      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2326      *
2327      * Returns a boolean value indicating whether the operation succeeded.
2328      *
2329      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2330      * that someone may use both the old and the new allowance by unfortunate
2331      * transaction ordering. One possible solution to mitigate this race
2332      * condition is to first reduce the spender's allowance to 0 and set the
2333      * desired value afterwards:
2334      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2335      *
2336      * Emits an {Approval} event.
2337      */
2338     function approve(address spender, uint256 amount) external returns (bool);
2339 
2340     /**
2341      * @dev Moves `amount` tokens from `sender` to `recipient` using the
2342      * allowance mechanism. `amount` is then deducted from the caller's
2343      * allowance.
2344      *
2345      * Returns a boolean value indicating whether the operation succeeded.
2346      *
2347      * Emits a {Transfer} event.
2348      */
2349     function transferFrom(
2350         address sender,
2351         address recipient,
2352         uint256 amount
2353     ) external returns (bool);
2354 
2355     /**
2356      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2357      * another (`to`).
2358      *
2359      * Note that `value` may be zero.
2360      */
2361     event Transfer(address indexed from, address indexed to, uint256 value);
2362 
2363     /**
2364      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2365      * a call to {approve}. `value` is the new allowance.
2366      */
2367     event Approval(
2368         address indexed owner,
2369         address indexed spender,
2370         uint256 value
2371     );
2372 }
2373 
2374 // OPENSEA BULLSHIT
2375 pragma solidity ^0.8.13;
2376 
2377 interface IOperatorFilterRegistry {
2378     function isOperatorAllowed(address registrant, address operator)
2379         external
2380         view
2381         returns (bool);
2382 
2383     function register(address registrant) external;
2384 
2385     function registerAndSubscribe(address registrant, address subscription)
2386         external;
2387 
2388     function registerAndCopyEntries(
2389         address registrant,
2390         address registrantToCopy
2391     ) external;
2392 
2393     function unregister(address addr) external;
2394 
2395     function updateOperator(
2396         address registrant,
2397         address operator,
2398         bool filtered
2399     ) external;
2400 
2401     function updateOperators(
2402         address registrant,
2403         address[] calldata operators,
2404         bool filtered
2405     ) external;
2406 
2407     function updateCodeHash(
2408         address registrant,
2409         bytes32 codehash,
2410         bool filtered
2411     ) external;
2412 
2413     function updateCodeHashes(
2414         address registrant,
2415         bytes32[] calldata codeHashes,
2416         bool filtered
2417     ) external;
2418 
2419     function subscribe(address registrant, address registrantToSubscribe)
2420         external;
2421 
2422     function unsubscribe(address registrant, bool copyExistingEntries) external;
2423 
2424     function subscriptionOf(address addr) external returns (address registrant);
2425 
2426     function subscribers(address registrant)
2427         external
2428         returns (address[] memory);
2429 
2430     function subscriberAt(address registrant, uint256 index)
2431         external
2432         returns (address);
2433 
2434     function copyEntriesOf(address registrant, address registrantToCopy)
2435         external;
2436 
2437     function isOperatorFiltered(address registrant, address operator)
2438         external
2439         returns (bool);
2440 
2441     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
2442         external
2443         returns (bool);
2444 
2445     function isCodeHashFiltered(address registrant, bytes32 codeHash)
2446         external
2447         returns (bool);
2448 
2449     function filteredOperators(address addr)
2450         external
2451         returns (address[] memory);
2452 
2453     function filteredCodeHashes(address addr)
2454         external
2455         returns (bytes32[] memory);
2456 
2457     function filteredOperatorAt(address registrant, uint256 index)
2458         external
2459         returns (address);
2460 
2461     function filteredCodeHashAt(address registrant, uint256 index)
2462         external
2463         returns (bytes32);
2464 
2465     function isRegistered(address addr) external returns (bool);
2466 
2467     function codeHashOf(address addr) external returns (bytes32);
2468 }
2469 
2470 pragma solidity ^0.8.13;
2471 
2472 //import {IOperatorFilterRegistry} from "./IOperatorFilterRegistry.sol";
2473 
2474 /**
2475  * @title  OperatorFilterer
2476  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2477  *         registrant's entries in the OperatorFilterRegistry.
2478  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2479  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2480  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2481  */
2482 abstract contract OperatorFilterer {
2483     error OperatorNotAllowed(address operator);
2484 
2485     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2486         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
2487 
2488     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2489         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2490         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2491         // order for the modifier to filter addresses.
2492         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2493             if (subscribe) {
2494                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
2495                     address(this),
2496                     subscriptionOrRegistrantToCopy
2497                 );
2498             } else {
2499                 if (subscriptionOrRegistrantToCopy != address(0)) {
2500                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
2501                         address(this),
2502                         subscriptionOrRegistrantToCopy
2503                     );
2504                 } else {
2505                     OPERATOR_FILTER_REGISTRY.register(address(this));
2506                 }
2507             }
2508         }
2509     }
2510 
2511     modifier onlyAllowedOperator(address from) virtual {
2512         // Check registry code length to facilitate testing in environments without a deployed registry.
2513         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2514             // Allow spending tokens from addresses with balance
2515             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2516             // from an EOA.
2517             if (from == msg.sender) {
2518                 _;
2519                 return;
2520             }
2521             if (
2522                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
2523                     address(this),
2524                     msg.sender
2525                 )
2526             ) {
2527                 revert OperatorNotAllowed(msg.sender);
2528             }
2529         }
2530         _;
2531     }
2532 
2533     modifier onlyAllowedOperatorApproval(address operator) virtual {
2534         // Check registry code length to facilitate testing in environments without a deployed registry.
2535         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2536             if (
2537                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
2538                     address(this),
2539                     operator
2540                 )
2541             ) {
2542                 revert OperatorNotAllowed(operator);
2543             }
2544         }
2545         _;
2546     }
2547 }
2548 
2549 pragma solidity ^0.8.0;
2550 
2551 /**
2552  * @title PaymentSplitter
2553  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2554  * that the Ether will be split in this way, since it is handled transparently by the contract.
2555  *
2556  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2557  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2558  * an amount proportional to the percentage of total shares they were assigned.
2559  *
2560  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2561  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2562  * function.
2563  *
2564  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2565  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2566  * to run tests before sending real value to this contract.
2567  */
2568 contract PaymentSplitter is Context {
2569     event PayeeAdded(address account, uint256 shares);
2570     event PaymentReleased(address to, uint256 amount);
2571     event ERC20PaymentReleased(
2572         IERC20 indexed token,
2573         address to,
2574         uint256 amount
2575     );
2576     event PaymentReceived(address from, uint256 amount);
2577 
2578     uint256 private _totalShares;
2579     uint256 private _totalReleased;
2580 
2581     mapping(address => uint256) private _shares;
2582     mapping(address => uint256) private _released;
2583     address[] private _payees;
2584 
2585     mapping(IERC20 => uint256) private _erc20TotalReleased;
2586     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2587 
2588     /**
2589      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2590      * the matching position in the `shares` array.
2591      *
2592      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2593      * duplicates in `payees`.
2594      */
2595     constructor(address[] memory payees, uint256[] memory shares_) payable {
2596         require(
2597             payees.length == shares_.length,
2598             "PaymentSplitter: payees and shares length mismatch"
2599         );
2600         require(payees.length > 0, "PaymentSplitter: no payees");
2601 
2602         for (uint256 i = 0; i < payees.length; i++) {
2603             _addPayee(payees[i], shares_[i]);
2604         }
2605     }
2606 
2607     /**
2608      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2609      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2610      * reliability of the events, and not the actual splitting of Ether.
2611      *
2612      * To learn more about this see the Solidity documentation for
2613      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2614      * functions].
2615      */
2616     receive() external payable virtual {
2617         emit PaymentReceived(_msgSender(), msg.value);
2618     }
2619 
2620     /**
2621      * @dev Getter for the total shares held by payees.
2622      */
2623     function totalShares() public view returns (uint256) {
2624         return _totalShares;
2625     }
2626 
2627     /**
2628      * @dev Getter for the total amount of Ether already released.
2629      */
2630     function totalReleased() public view returns (uint256) {
2631         return _totalReleased;
2632     }
2633 
2634     /**
2635      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2636      * contract.
2637      */
2638     function totalReleased(IERC20 token) public view returns (uint256) {
2639         return _erc20TotalReleased[token];
2640     }
2641 
2642     /**
2643      * @dev Getter for the amount of shares held by an account.
2644      */
2645     function shares(address account) public view returns (uint256) {
2646         return _shares[account];
2647     }
2648 
2649     /**
2650      * @dev Getter for the amount of Ether already released to a payee.
2651      */
2652     function released(address account) public view returns (uint256) {
2653         return _released[account];
2654     }
2655 
2656     /**
2657      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2658      * IERC20 contract.
2659      */
2660     function released(IERC20 token, address account)
2661         public
2662         view
2663         returns (uint256)
2664     {
2665         return _erc20Released[token][account];
2666     }
2667 
2668     /**
2669      * @dev Getter for the address of the payee number `index`.
2670      */
2671     function payee(uint256 index) public view returns (address) {
2672         return _payees[index];
2673     }
2674 
2675     /**
2676      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2677      * total shares and their previous withdrawals.
2678      */
2679     function release(address payable account) public virtual {
2680         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2681 
2682         uint256 totalReceived = address(this).balance + totalReleased();
2683         uint256 payment = _pendingPayment(
2684             account,
2685             totalReceived,
2686             released(account)
2687         );
2688 
2689         require(payment != 0, "PaymentSplitter: account is not due payment");
2690 
2691         _released[account] += payment;
2692         _totalReleased += payment;
2693 
2694         Address.sendValue(account, payment);
2695         emit PaymentReleased(account, payment);
2696     }
2697 
2698     /**
2699      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2700      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2701      * contract.
2702      */
2703     function release(IERC20 token, address account) public virtual {
2704         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2705 
2706         uint256 totalReceived = token.balanceOf(address(this)) +
2707             totalReleased(token);
2708         uint256 payment = _pendingPayment(
2709             account,
2710             totalReceived,
2711             released(token, account)
2712         );
2713 
2714         require(payment != 0, "PaymentSplitter: account is not due payment");
2715 
2716         _erc20Released[token][account] += payment;
2717         _erc20TotalReleased[token] += payment;
2718 
2719         SafeERC20.safeTransfer(token, account, payment);
2720         emit ERC20PaymentReleased(token, account, payment);
2721     }
2722 
2723     /**
2724      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2725      * already released amounts.
2726      */
2727     function _pendingPayment(
2728         address account,
2729         uint256 totalReceived,
2730         uint256 alreadyReleased
2731     ) private view returns (uint256) {
2732         return
2733             (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2734     }
2735 
2736     /**
2737      * @dev Add a new payee to the contract.
2738      * @param account The address of the payee to add.
2739      * @param shares_ The number of shares owned by the payee.
2740      */
2741     function _addPayee(address account, uint256 shares_) private {
2742         require(
2743             account != address(0),
2744             "PaymentSplitter: account is the zero address"
2745         );
2746         require(shares_ > 0, "PaymentSplitter: shares are 0");
2747         require(
2748             _shares[account] == 0,
2749             "PaymentSplitter: account already has shares"
2750         );
2751 
2752         _payees.push(account);
2753         _shares[account] = shares_;
2754         _totalShares = _totalShares + shares_;
2755         emit PayeeAdded(account, shares_);
2756     }
2757 }
2758 
2759 pragma solidity ^0.8.13;
2760 
2761 //import {OperatorFilterer} from "./OperatorFilterer.sol";
2762 
2763 /**
2764  * @title  DefaultOperatorFilterer
2765  * @notice Inherits from OperatorFilterer and automatically subscribes to the default
2766  *         OpenSea subscription.
2767  */
2768 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2769     address constant DEFAULT_SUBSCRIPTION =
2770         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2771 
2772     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
2773 }
2774 
2775 pragma solidity ^0.8.0;
2776 
2777 /**
2778  * @dev Contract module that helps prevent reentrant calls to a function.
2779  *
2780  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2781  * available, which can be applied to functions to make sure there are no nested
2782  * (reentrant) calls to them.
2783  *
2784  * Note that because there is a single `nonReentrant` guard, functions marked as
2785  * `nonReentrant` may not call one another. This can be worked around by making
2786  * those functions `private`, and then adding `external` `nonReentrant` entry
2787  * points to them.
2788  *
2789  * TIP: If you would like to learn more about reentrancy and alternative ways
2790  * to protect against it, check out our blog post
2791  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2792  */
2793 abstract contract ReentrancyGuard {
2794     // Booleans are more expensive than uint256 or any type that takes up a full
2795     // word because each write operation emits an extra SLOAD to first read the
2796     // slot's contents, replace the bits taken up by the boolean, and then write
2797     // back. This is the compiler's defense against contract upgrades and
2798     // pointer aliasing, and it cannot be disabled.
2799 
2800     // The values being non-zero value makes deployment a bit more expensive,
2801     // but in exchange the refund on every call to nonReentrant will be lower in
2802     // amount. Since refunds are capped to a percentage of the total
2803     // transaction's gas, it is best to keep them low in cases like this one, to
2804     // increase the likelihood of the full refund coming into effect.
2805     uint256 private constant _NOT_ENTERED = 1;
2806     uint256 private constant _ENTERED = 2;
2807 
2808     uint256 private _status;
2809 
2810     constructor() {
2811         _status = _NOT_ENTERED;
2812     }
2813 
2814     /**
2815      * @dev Prevents a contract from calling itself, directly or indirectly.
2816      * Calling a `nonReentrant` function from another `nonReentrant`
2817      * function is not supported. It is possible to prevent this from happening
2818      * by making the `nonReentrant` function external, and make it call a
2819      * `private` function that does the actual work.
2820      */
2821     modifier nonReentrant() {
2822         // On the first call to nonReentrant, _notEntered will be true
2823         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2824 
2825         // Any calls to nonReentrant after this point will fail
2826         _status = _ENTERED;
2827 
2828         _;
2829 
2830         // By storing the original value once again, a refund is triggered (see
2831         // https://eips.ethereum.org/EIPS/eip-2200)
2832         _status = _NOT_ENTERED;
2833     }
2834 }
2835 contract MythicArmor is
2836     Ownable,
2837     PaymentSplitter,
2838     DefaultOperatorFilterer,
2839     ERC1155
2840 {
2841     using Strings for uint256;
2842 
2843     // Sale Status
2844     bool public saleIsActive = false;
2845 
2846     address public LiquidDeployer = 0x866cfDa1B7cD90Cd250485cd8b700211480845D7;
2847     uint256 public RandomNumberRange = 100;
2848     string private baseURI = "https://apeliquid.io/armor/json/";
2849     string public name = "Mythic Armor";
2850 
2851     mapping(uint256 => bool) public validArmor;
2852     uint256 private maxArmorID = 27;
2853 
2854     // Liquid METL -- bang your head as you read this line of code
2855     address public METLToken = 0xFcbE615dEf610E806BB64427574A2c5c1fB55510;
2856 
2857     // Specify the IERC20 interface to the METL Token
2858     IERC20 METLTokenAddress = IERC20(address(METLToken));
2859 
2860     uint256 public mintMETLRequired = 10 ether;
2861     uint256 public mintETHRequired = 1000000000000000;
2862 
2863     event SetBaseURI(string indexed _baseURI);
2864 
2865     // Enumerate all the items for minting
2866     constructor() ERC1155("MythicArmor") PaymentSplitter(_payees, _shares) {
2867         validArmor[1] = true; // Common
2868         validArmor[2] = true; // Rare
2869         validArmor[3] = true; // Mythic
2870         validArmor[4] = true; // Legendary
2871         validArmor[5] = true; // Divine
2872         validArmor[6] = true; // Immortal
2873         validArmor[7] = true; // Battle Droid | Android Matrix
2874         validArmor[8] = true; // Bloodmoon | Mono Arch
2875         validArmor[9] = true; // Circuit Shield | Cypher Collective
2876         validArmor[10] = true; // Dark Ruin | Random
2877         validArmor[11] = true; // Dark Spectre | Unknown
2878         validArmor[12] = true; // First Forge | Hammer Planetoid
2879         validArmor[13] = true; // FTL Armor | Ansible Homeworld
2880         validArmor[14] = true; // Goo Reaver | Terrene Goo
2881         validArmor[15] = true; // Guardian | Sword of Light
2882         validArmor[16] = true; // Ironwood | Seed Terra
2883         validArmor[17] = true; // iwghargh | Batleth QonoS
2884         validArmor[18] = true; // Liquid Dragon | Majicka
2885         validArmor[19] = true; // Liquid Immortality | Any
2886         validArmor[20] = true; // Luminous | Inherited
2887         validArmor[21] = true; // Protectorate | New Frontier
2888         validArmor[22] = true; // Queen's Guard | Trilithium Crystal
2889         validArmor[23] = true; // Shellden Ring | Eyebeam
2890         validArmor[24] = true; // Stardust | Interdimensional Portal
2891         validArmor[25] = true; // Stargazer | Telescope Sphere
2892         validArmor[26] = true; // Xeno | Polymorph
2893         validArmor[27] = true; // FUD Butter | Any
2894 
2895         emit SetBaseURI(baseURI);
2896     }
2897 
2898     // -------------------------------------------------------------------
2899     // Functions for setting variables and changing values (only by owner)
2900     // -------------------------------------------------------------------
2901 
2902     function setRandomNumberRange(uint256 r) external onlyOwner {
2903         RandomNumberRange = r;
2904     }
2905 
2906     /**
2907      * @notice Airdrop tokens to multiple addresses at once.
2908      * No strict supply is set in the contract. All methods are ownerOnly,
2909      * it is up to the owner to control the supply by not minting
2910      * past their desired number for each token.
2911      * @dev Airdrop tokens to each address in the calldata list,
2912      * setting the supply to the length of the list + previously minted (airdropped) supply.
2913      * Add an address once per token you would like to send.
2914      * @param _tokenIds The tokenIDs to send
2915      * @param _list address[] list of wallets to send tokens to
2916      * @param _qty The qty of each token we are sending
2917      */
2918     function airdrop(
2919         uint256[] memory _tokenIds,
2920         address[] calldata _list,
2921         uint256[] memory _qty
2922     ) external onlyOwner {
2923         for (uint256 i = 0; i < _list.length; i++) {
2924             _mint(_list[i], _tokenIds[i], _qty[i], "Drop-a-palooza error!");
2925         }
2926     }
2927 
2928     function updateBaseUri(string memory _baseURI) external onlyOwner {
2929         baseURI = _baseURI;
2930         emit SetBaseURI(baseURI);
2931     }
2932 
2933     function uri(uint256 typeId) public view override returns (string memory) {
2934         require(validArmor[typeId], "URI requested for invalid type");
2935         return
2936             bytes(baseURI).length > 0
2937                 ? string(abi.encodePacked(baseURI, typeId.toString()))
2938                 : baseURI;
2939     }
2940 
2941     // -------------------------------------------------------------------------------
2942     // MINT and Sale details
2943     // -------------------------------------------------------------------------------
2944 
2945     event SaleActivation(bool isActive);
2946 
2947     function toggleSaleStatus() external onlyOwner {
2948         saleIsActive = !saleIsActive;
2949         emit SaleActivation(saleIsActive);
2950     }
2951 
2952     event ItemMinted(
2953         address contractAddress,
2954         uint256 tokenId,
2955         uint256 timestamp
2956     );
2957 
2958     function newMints(uint256 _count) private {
2959         for (uint256 i = 0; i < _count; i++) {
2960             uint256 randomItem = RandomNumber(maxArmorID);
2961             _mint(msg.sender, randomItem, 1, "Mint Failed");
2962             emit ItemMinted(msg.sender, randomItem, block.timestamp);
2963         }
2964     }
2965 
2966     // @notice mint The mint function, which can be done in ETH or METL
2967     // @params _count How many to mint
2968     // @params mintInMETL Boolean that determines if mint is in METL (or ETH)
2969     function mint(uint256 _count, bool mintInMETL)
2970         public
2971         payable
2972     {
2973         require(saleIsActive, "Sale not active!");
2974         if (mintInMETL) {
2975             require(
2976                 METLTokenAddress.allowance(msg.sender, address(this)) >=
2977                     mintMETLRequired * _count,
2978                 "Error: Transfer not approved"
2979             );
2980             METLTokenAddress.transferFrom(
2981                 msg.sender,
2982                 address(this),
2983                 (mintMETLRequired) * _count
2984             );
2985         } else {
2986             require(
2987                 mintETHRequired * _count <= msg.value,
2988                 "Not Enough ETH to mint!"
2989             );
2990         }
2991 
2992         newMints(_count);
2993     }
2994 
2995     // @notice Generate random number based on totalnumbers
2996     // @param totalnumbers The Maximum number to return (i.e. 100 returns 0-99)
2997     function RandomNumber(uint256 totalnumbers) public view returns (uint256) {
2998         uint256 seed = uint256(
2999             keccak256(
3000                 abi.encodePacked(
3001                     block.timestamp +
3002                         block.difficulty +
3003                         ((
3004                             uint256(keccak256(abi.encodePacked(block.coinbase)))
3005                         ) / (block.timestamp)) +
3006                         block.gaslimit +
3007                         ((uint256(keccak256(abi.encodePacked(msg.sender)))) /
3008                             (block.timestamp)) +
3009                         block.number
3010                 )
3011             )
3012         );
3013 
3014         return seed % totalnumbers;
3015     }
3016 
3017     // -------------------------------------------------------------------------------
3018     // PRIVATE FUNCTIONS + ADDITIONAL REQUIREMENTS FOR CONTRACT
3019     // -------------------------------------------------------------------------------
3020 
3021     function DestroyArmor(
3022         address tokenOwner,
3023         uint256 tokenId,
3024         uint256 totalToBurn
3025     ) external onlyOwner {
3026         _burn(tokenOwner, tokenId, totalToBurn);
3027     }
3028 
3029     function changeMintETH(uint256 neweth) external onlyOwner {
3030         mintETHRequired = neweth;
3031     }
3032 
3033     function changeMintMETL(uint256 neweth) external onlyOwner {
3034         mintMETLRequired = neweth;
3035     }
3036 
3037     function receiveETH() public payable {
3038         require(msg.value > mintETHRequired, "Not enough ETH");
3039     }
3040 
3041     // Payments using splitter go here...
3042     address[] public _payees = [
3043         0x7FDE663601A53A6953bbb98F1Ab87E86dEE81b35, // Liquid Payments
3044         0x867Eb0804eACA9FEeda8a0E1d2B9a32eEF58AF8f,
3045         0x0C07747AB98EE84971C90Fbd353eda207B737c43,
3046         0xfebbB48C8f7A67Dc3DcEE19524A410E078e6A6a1
3047     ];
3048     uint256[] private _shares = [10, 60, 15, 15];
3049 
3050     // Payments
3051     function claim() external {
3052         release(payable(msg.sender));
3053     }
3054 
3055     /**
3056      * @notice Withdraw all tokens from the contract (emergency function)
3057      */
3058     function removeAllMETL() public onlyOwner {
3059         uint256 balance = METLTokenAddress.balanceOf(address(this));
3060         METLTokenAddress.transfer(LiquidDeployer, balance);
3061     }
3062 
3063     // OpenSea's new bullshit requirements, which violate my moral code, but
3064     // are nonetheless necessary to make this all work properly.
3065     function setApprovalForAll(address operator, bool approved)
3066         public
3067         override
3068         onlyAllowedOperatorApproval(operator)
3069     {
3070         super.setApprovalForAll(operator, approved);
3071     }
3072 
3073     // Take my love, take my land, Take me where I cannot stand.
3074     // I don't care, I'm still free, You can't take the sky from me.
3075     //
3076     function SelfDestruct() external onlyOwner {
3077         // Walk through all the keys and return them to the contract
3078         removeAllMETL();
3079         address payable os = payable(address(LiquidDeployer));
3080         selfdestruct(os);
3081     }
3082 }