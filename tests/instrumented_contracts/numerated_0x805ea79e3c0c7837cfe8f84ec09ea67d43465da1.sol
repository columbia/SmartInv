1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
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
26 
27 
28 
29 
30 
31 /**
32  * @dev Implementation of the {IERC165} interface.
33  *
34  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
35  * for the additional interface id that will be supported. For example:
36  *
37  * ```solidity
38  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
39  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
40  * }
41  * ```
42  *
43  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
44  */
45 abstract contract ERC165 is IERC165 {
46     /**
47      * @dev See {IERC165-supportsInterface}.
48      */
49     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
50         return interfaceId == type(IERC165).interfaceId;
51     }
52 }
53 
54 
55 
56 
57 
58 
59 /**
60  * @dev _Available since v3.1._
61  */
62 interface IERC1155Receiver is IERC165 {
63     /**
64         @dev Handles the receipt of a single ERC1155 token type. This function is
65         called at the end of a `safeTransferFrom` after the balance has been updated.
66         To accept the transfer, this must return
67         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
68         (i.e. 0xf23a6e61, or its own function selector).
69         @param operator The address which initiated the transfer (i.e. msg.sender)
70         @param from The address which previously owned the token
71         @param id The ID of the token being transferred
72         @param value The amount of tokens being transferred
73         @param data Additional data with no specified format
74         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
75     */
76     function onERC1155Received(
77         address operator,
78         address from,
79         uint256 id,
80         uint256 value,
81         bytes calldata data
82     ) external returns (bytes4);
83 
84     /**
85         @dev Handles the receipt of a multiple ERC1155 token types. This function
86         is called at the end of a `safeBatchTransferFrom` after the balances have
87         been updated. To accept the transfer(s), this must return
88         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
89         (i.e. 0xbc197c81, or its own function selector).
90         @param operator The address which initiated the batch transfer (i.e. msg.sender)
91         @param from The address which previously owned the token
92         @param ids An array containing ids of each token being transferred (order and length must match values array)
93         @param values An array containing amounts of each token being transferred (order and length must match ids array)
94         @param data Additional data with no specified format
95         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
96     */
97     function onERC1155BatchReceived(
98         address operator,
99         address from,
100         uint256[] calldata ids,
101         uint256[] calldata values,
102         bytes calldata data
103     ) external returns (bytes4);
104 }
105 
106 
107 
108 
109 /**
110  * @dev Provides information about the current execution context, including the
111  * sender of the transaction and its data. While these are generally available
112  * via msg.sender and msg.data, they should not be accessed in such a direct
113  * manner, since when dealing with meta-transactions the account sending and
114  * paying for execution may not be the actual sender (as far as an application
115  * is concerned).
116  *
117  * This contract is only required for intermediate, library-like contracts.
118  */
119 abstract contract Context {
120     function _msgSender() internal view virtual returns (address) {
121         return msg.sender;
122     }
123 
124     function _msgData() internal view virtual returns (bytes calldata) {
125         return msg.data;
126     }
127 }
128 
129 
130 
131 interface LinkTokenInterface {
132 
133   function allowance(
134     address owner,
135     address spender
136   )
137     external
138     view
139     returns (
140       uint256 remaining
141     );
142 
143   function approve(
144     address spender,
145     uint256 value
146   )
147     external
148     returns (
149       bool success
150     );
151 
152   function balanceOf(
153     address owner
154   )
155     external
156     view
157     returns (
158       uint256 balance
159     );
160 
161   function decimals()
162     external
163     view
164     returns (
165       uint8 decimalPlaces
166     );
167 
168   function decreaseApproval(
169     address spender,
170     uint256 addedValue
171   )
172     external
173     returns (
174       bool success
175     );
176 
177   function increaseApproval(
178     address spender,
179     uint256 subtractedValue
180   ) external;
181 
182   function name()
183     external
184     view
185     returns (
186       string memory tokenName
187     );
188 
189   function symbol()
190     external
191     view
192     returns (
193       string memory tokenSymbol
194     );
195 
196   function totalSupply()
197     external
198     view
199     returns (
200       uint256 totalTokensIssued
201     );
202 
203   function transfer(
204     address to,
205     uint256 value
206   )
207     external
208     returns (
209       bool success
210     );
211 
212   function transferAndCall(
213     address to,
214     uint256 value,
215     bytes calldata data
216   )
217     external
218     returns (
219       bool success
220     );
221 
222   function transferFrom(
223     address from,
224     address to,
225     uint256 value
226   )
227     external
228     returns (
229       bool success
230     );
231 
232 }
233 
234 
235 
236 
237 
238 
239 /**
240  * @dev Contract module which allows children to implement an emergency stop
241  * mechanism that can be triggered by an authorized account.
242  *
243  * This module is used through inheritance. It will make available the
244  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
245  * the functions of your contract. Note that they will not be pausable by
246  * simply including this module, only once the modifiers are put in place.
247  */
248 abstract contract Pausable is Context {
249     /**
250      * @dev Emitted when the pause is triggered by `account`.
251      */
252     event Paused(address account);
253 
254     /**
255      * @dev Emitted when the pause is lifted by `account`.
256      */
257     event Unpaused(address account);
258 
259     bool private _paused;
260 
261     /**
262      * @dev Initializes the contract in unpaused state.
263      */
264     constructor() {
265         _paused = false;
266     }
267 
268     /**
269      * @dev Returns true if the contract is paused, and false otherwise.
270      */
271     function paused() public view virtual returns (bool) {
272         return _paused;
273     }
274 
275     /**
276      * @dev Modifier to make a function callable only when the contract is not paused.
277      *
278      * Requirements:
279      *
280      * - The contract must not be paused.
281      */
282     modifier whenNotPaused() {
283         require(!paused(), "Pausable: paused");
284         _;
285     }
286 
287     /**
288      * @dev Modifier to make a function callable only when the contract is paused.
289      *
290      * Requirements:
291      *
292      * - The contract must be paused.
293      */
294     modifier whenPaused() {
295         require(paused(), "Pausable: not paused");
296         _;
297     }
298 
299     /**
300      * @dev Triggers stopped state.
301      *
302      * Requirements:
303      *
304      * - The contract must not be paused.
305      */
306     function _pause() internal virtual whenNotPaused {
307         _paused = true;
308         emit Paused(_msgSender());
309     }
310 
311     /**
312      * @dev Returns to normal state.
313      *
314      * Requirements:
315      *
316      * - The contract must be paused.
317      */
318     function _unpause() internal virtual whenPaused {
319         _paused = false;
320         emit Unpaused(_msgSender());
321     }
322 }
323 
324 // wire.sol
325 
326 
327 
328 
329 
330 
331 
332 
333 
334 
335 
336 
337 
338 
339 
340 
341 
342 /**
343  * @dev Required interface of an ERC1155 compliant contract, as defined in the
344  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
345  *
346  * _Available since v3.1._
347  */
348 interface IERC1155 is IERC165 {
349     /**
350      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
351      */
352     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
353 
354     /**
355      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
356      * transfers.
357      */
358     event TransferBatch(
359         address indexed operator,
360         address indexed from,
361         address indexed to,
362         uint256[] ids,
363         uint256[] values
364     );
365 
366     /**
367      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
368      * `approved`.
369      */
370     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
371 
372     /**
373      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
374      *
375      * If an {URI} event was emitted for `id`, the standard
376      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
377      * returned by {IERC1155MetadataURI-uri}.
378      */
379     event URI(string value, uint256 indexed id);
380 
381     /**
382      * @dev Returns the amount of tokens of token type `id` owned by `account`.
383      *
384      * Requirements:
385      *
386      * - `account` cannot be the zero address.
387      */
388     function balanceOf(address account, uint256 id) external view returns (uint256);
389 
390     /**
391      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
392      *
393      * Requirements:
394      *
395      * - `accounts` and `ids` must have the same length.
396      */
397     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
398         external
399         view
400         returns (uint256[] memory);
401 
402     /**
403      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
404      *
405      * Emits an {ApprovalForAll} event.
406      *
407      * Requirements:
408      *
409      * - `operator` cannot be the caller.
410      */
411     function setApprovalForAll(address operator, bool approved) external;
412 
413     /**
414      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
415      *
416      * See {setApprovalForAll}.
417      */
418     function isApprovedForAll(address account, address operator) external view returns (bool);
419 
420     /**
421      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
422      *
423      * Emits a {TransferSingle} event.
424      *
425      * Requirements:
426      *
427      * - `to` cannot be the zero address.
428      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
429      * - `from` must have a balance of tokens of type `id` of at least `amount`.
430      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
431      * acceptance magic value.
432      */
433     function safeTransferFrom(
434         address from,
435         address to,
436         uint256 id,
437         uint256 amount,
438         bytes calldata data
439     ) external;
440 
441     /**
442      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
443      *
444      * Emits a {TransferBatch} event.
445      *
446      * Requirements:
447      *
448      * - `ids` and `amounts` must have the same length.
449      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
450      * acceptance magic value.
451      */
452     function safeBatchTransferFrom(
453         address from,
454         address to,
455         uint256[] calldata ids,
456         uint256[] calldata amounts,
457         bytes calldata data
458     ) external;
459 }
460 
461 
462 
463 
464 
465 
466 
467 
468 /**
469  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
470  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
471  *
472  * _Available since v3.1._
473  */
474 interface IERC1155MetadataURI is IERC1155 {
475     /**
476      * @dev Returns the URI for token type `id`.
477      *
478      * If the `\{id\}` substring is present in the URI, it must be replaced by
479      * clients with the actual token type ID.
480      */
481     function uri(uint256 id) external view returns (string memory);
482 }
483 
484 
485 
486 
487 
488 /**
489  * @dev Collection of functions related to the address type
490  */
491 library Address {
492     /**
493      * @dev Returns true if `account` is a contract.
494      *
495      * [IMPORTANT]
496      * ====
497      * It is unsafe to assume that an address for which this function returns
498      * false is an externally-owned account (EOA) and not a contract.
499      *
500      * Among others, `isContract` will return false for the following
501      * types of addresses:
502      *
503      *  - an externally-owned account
504      *  - a contract in construction
505      *  - an address where a contract will be created
506      *  - an address where a contract lived, but was destroyed
507      * ====
508      */
509     function isContract(address account) internal view returns (bool) {
510         // This method relies on extcodesize, which returns 0 for contracts in
511         // construction, since the code is only stored at the end of the
512         // constructor execution.
513 
514         uint256 size;
515         assembly {
516             size := extcodesize(account)
517         }
518         return size > 0;
519     }
520 
521     /**
522      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
523      * `recipient`, forwarding all available gas and reverting on errors.
524      *
525      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
526      * of certain opcodes, possibly making contracts go over the 2300 gas limit
527      * imposed by `transfer`, making them unable to receive funds via
528      * `transfer`. {sendValue} removes this limitation.
529      *
530      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
531      *
532      * IMPORTANT: because control is transferred to `recipient`, care must be
533      * taken to not create reentrancy vulnerabilities. Consider using
534      * {ReentrancyGuard} or the
535      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
536      */
537     function sendValue(address payable recipient, uint256 amount) internal {
538         require(address(this).balance >= amount, "Address: insufficient balance");
539 
540         (bool success, ) = recipient.call{value: amount}("");
541         require(success, "Address: unable to send value, recipient may have reverted");
542     }
543 
544     /**
545      * @dev Performs a Solidity function call using a low level `call`. A
546      * plain `call` is an unsafe replacement for a function call: use this
547      * function instead.
548      *
549      * If `target` reverts with a revert reason, it is bubbled up by this
550      * function (like regular Solidity function calls).
551      *
552      * Returns the raw returned data. To convert to the expected return value,
553      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
554      *
555      * Requirements:
556      *
557      * - `target` must be a contract.
558      * - calling `target` with `data` must not revert.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
563         return functionCall(target, data, "Address: low-level call failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
568      * `errorMessage` as a fallback revert reason when `target` reverts.
569      *
570      * _Available since v3.1._
571      */
572     function functionCall(
573         address target,
574         bytes memory data,
575         string memory errorMessage
576     ) internal returns (bytes memory) {
577         return functionCallWithValue(target, data, 0, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but also transferring `value` wei to `target`.
583      *
584      * Requirements:
585      *
586      * - the calling contract must have an ETH balance of at least `value`.
587      * - the called Solidity function must be `payable`.
588      *
589      * _Available since v3.1._
590      */
591     function functionCallWithValue(
592         address target,
593         bytes memory data,
594         uint256 value
595     ) internal returns (bytes memory) {
596         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
601      * with `errorMessage` as a fallback revert reason when `target` reverts.
602      *
603      * _Available since v3.1._
604      */
605     function functionCallWithValue(
606         address target,
607         bytes memory data,
608         uint256 value,
609         string memory errorMessage
610     ) internal returns (bytes memory) {
611         require(address(this).balance >= value, "Address: insufficient balance for call");
612         require(isContract(target), "Address: call to non-contract");
613 
614         (bool success, bytes memory returndata) = target.call{value: value}(data);
615         return verifyCallResult(success, returndata, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but performing a static call.
621      *
622      * _Available since v3.3._
623      */
624     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
625         return functionStaticCall(target, data, "Address: low-level static call failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
630      * but performing a static call.
631      *
632      * _Available since v3.3._
633      */
634     function functionStaticCall(
635         address target,
636         bytes memory data,
637         string memory errorMessage
638     ) internal view returns (bytes memory) {
639         require(isContract(target), "Address: static call to non-contract");
640 
641         (bool success, bytes memory returndata) = target.staticcall(data);
642         return verifyCallResult(success, returndata, errorMessage);
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
647      * but performing a delegate call.
648      *
649      * _Available since v3.4._
650      */
651     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
652         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
657      * but performing a delegate call.
658      *
659      * _Available since v3.4._
660      */
661     function functionDelegateCall(
662         address target,
663         bytes memory data,
664         string memory errorMessage
665     ) internal returns (bytes memory) {
666         require(isContract(target), "Address: delegate call to non-contract");
667 
668         (bool success, bytes memory returndata) = target.delegatecall(data);
669         return verifyCallResult(success, returndata, errorMessage);
670     }
671 
672     /**
673      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
674      * revert reason using the provided one.
675      *
676      * _Available since v4.3._
677      */
678     function verifyCallResult(
679         bool success,
680         bytes memory returndata,
681         string memory errorMessage
682     ) internal pure returns (bytes memory) {
683         if (success) {
684             return returndata;
685         } else {
686             // Look for revert reason and bubble it up if present
687             if (returndata.length > 0) {
688                 // The easiest way to bubble the revert reason is using memory via assembly
689 
690                 assembly {
691                     let returndata_size := mload(returndata)
692                     revert(add(32, returndata), returndata_size)
693                 }
694             } else {
695                 revert(errorMessage);
696             }
697         }
698     }
699 }
700 
701 
702 
703 
704 /**
705  * @dev Implementation of the basic standard multi-token.
706  * See https://eips.ethereum.org/EIPS/eip-1155
707  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
708  *
709  * _Available since v3.1._
710  */
711 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
712     using Address for address;
713 
714     // Mapping from token ID to account balances
715     mapping(uint256 => mapping(address => uint256)) private _balances;
716 
717     // Mapping from account to operator approvals
718     mapping(address => mapping(address => bool)) private _operatorApprovals;
719 
720     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
721     string private _uri;
722 
723     /**
724      * @dev See {_setURI}.
725      */
726     constructor(string memory uri_) {
727         _setURI(uri_);
728     }
729 
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
734         return
735             interfaceId == type(IERC1155).interfaceId ||
736             interfaceId == type(IERC1155MetadataURI).interfaceId ||
737             super.supportsInterface(interfaceId);
738     }
739 
740     /**
741      * @dev See {IERC1155MetadataURI-uri}.
742      *
743      * This implementation returns the same URI for *all* token types. It relies
744      * on the token type ID substitution mechanism
745      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
746      *
747      * Clients calling this function must replace the `\{id\}` substring with the
748      * actual token type ID.
749      */
750     function uri(uint256) public view virtual override returns (string memory) {
751         return _uri;
752     }
753 
754     /**
755      * @dev See {IERC1155-balanceOf}.
756      *
757      * Requirements:
758      *
759      * - `account` cannot be the zero address.
760      */
761     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
762         require(account != address(0), "ERC1155: balance query for the zero address");
763         return _balances[id][account];
764     }
765 
766     /**
767      * @dev See {IERC1155-balanceOfBatch}.
768      *
769      * Requirements:
770      *
771      * - `accounts` and `ids` must have the same length.
772      */
773     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
774         public
775         view
776         virtual
777         override
778         returns (uint256[] memory)
779     {
780         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
781 
782         uint256[] memory batchBalances = new uint256[](accounts.length);
783 
784         for (uint256 i = 0; i < accounts.length; ++i) {
785             batchBalances[i] = balanceOf(accounts[i], ids[i]);
786         }
787 
788         return batchBalances;
789     }
790 
791     /**
792      * @dev See {IERC1155-setApprovalForAll}.
793      */
794     function setApprovalForAll(address operator, bool approved) public virtual override {
795         require(_msgSender() != operator, "ERC1155: setting approval status for self");
796 
797         _operatorApprovals[_msgSender()][operator] = approved;
798         emit ApprovalForAll(_msgSender(), operator, approved);
799     }
800 
801     /**
802      * @dev See {IERC1155-isApprovedForAll}.
803      */
804     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
805         return _operatorApprovals[account][operator];
806     }
807 
808     /**
809      * @dev See {IERC1155-safeTransferFrom}.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 id,
815         uint256 amount,
816         bytes memory data
817     ) public virtual override {
818         require(
819             from == _msgSender() || isApprovedForAll(from, _msgSender()),
820             "ERC1155: caller is not owner nor approved"
821         );
822         _safeTransferFrom(from, to, id, amount, data);
823     }
824 
825     /**
826      * @dev See {IERC1155-safeBatchTransferFrom}.
827      */
828     function safeBatchTransferFrom(
829         address from,
830         address to,
831         uint256[] memory ids,
832         uint256[] memory amounts,
833         bytes memory data
834     ) public virtual override {
835         require(
836             from == _msgSender() || isApprovedForAll(from, _msgSender()),
837             "ERC1155: transfer caller is not owner nor approved"
838         );
839         _safeBatchTransferFrom(from, to, ids, amounts, data);
840     }
841 
842     /**
843      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
844      *
845      * Emits a {TransferSingle} event.
846      *
847      * Requirements:
848      *
849      * - `to` cannot be the zero address.
850      * - `from` must have a balance of tokens of type `id` of at least `amount`.
851      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
852      * acceptance magic value.
853      */
854     function _safeTransferFrom(
855         address from,
856         address to,
857         uint256 id,
858         uint256 amount,
859         bytes memory data
860     ) internal virtual {
861         require(to != address(0), "ERC1155: transfer to the zero address");
862 
863         address operator = _msgSender();
864 
865         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
866 
867         uint256 fromBalance = _balances[id][from];
868         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
869         unchecked {
870             _balances[id][from] = fromBalance - amount;
871         }
872         _balances[id][to] += amount;
873 
874         emit TransferSingle(operator, from, to, id, amount);
875 
876         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
877     }
878 
879     /**
880      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
881      *
882      * Emits a {TransferBatch} event.
883      *
884      * Requirements:
885      *
886      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
887      * acceptance magic value.
888      */
889     function _safeBatchTransferFrom(
890         address from,
891         address to,
892         uint256[] memory ids,
893         uint256[] memory amounts,
894         bytes memory data
895     ) internal virtual {
896         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
897         require(to != address(0), "ERC1155: transfer to the zero address");
898 
899         address operator = _msgSender();
900 
901         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
902 
903         for (uint256 i = 0; i < ids.length; ++i) {
904             uint256 id = ids[i];
905             uint256 amount = amounts[i];
906 
907             uint256 fromBalance = _balances[id][from];
908             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
909             unchecked {
910                 _balances[id][from] = fromBalance - amount;
911             }
912             _balances[id][to] += amount;
913         }
914 
915         emit TransferBatch(operator, from, to, ids, amounts);
916 
917         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
918     }
919 
920     /**
921      * @dev Sets a new URI for all token types, by relying on the token type ID
922      * substitution mechanism
923      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
924      *
925      * By this mechanism, any occurrence of the `\{id\}` substring in either the
926      * URI or any of the amounts in the JSON file at said URI will be replaced by
927      * clients with the token type ID.
928      *
929      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
930      * interpreted by clients as
931      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
932      * for token type ID 0x4cce0.
933      *
934      * See {uri}.
935      *
936      * Because these URIs cannot be meaningfully represented by the {URI} event,
937      * this function emits no events.
938      */
939     function _setURI(string memory newuri) internal virtual {
940         _uri = newuri;
941     }
942 
943     /**
944      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
945      *
946      * Emits a {TransferSingle} event.
947      *
948      * Requirements:
949      *
950      * - `account` cannot be the zero address.
951      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
952      * acceptance magic value.
953      */
954     function _mint(
955         address account,
956         uint256 id,
957         uint256 amount,
958         bytes memory data
959     ) internal virtual {
960         require(account != address(0), "ERC1155: mint to the zero address");
961 
962         address operator = _msgSender();
963 
964         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
965 
966         _balances[id][account] += amount;
967         emit TransferSingle(operator, address(0), account, id, amount);
968 
969         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
970     }
971 
972     /**
973      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
974      *
975      * Requirements:
976      *
977      * - `ids` and `amounts` must have the same length.
978      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
979      * acceptance magic value.
980      */
981     function _mintBatch(
982         address to,
983         uint256[] memory ids,
984         uint256[] memory amounts,
985         bytes memory data
986     ) internal virtual {
987         require(to != address(0), "ERC1155: mint to the zero address");
988         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
989 
990         address operator = _msgSender();
991 
992         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
993 
994         for (uint256 i = 0; i < ids.length; i++) {
995             _balances[ids[i]][to] += amounts[i];
996         }
997 
998         emit TransferBatch(operator, address(0), to, ids, amounts);
999 
1000         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1001     }
1002 
1003     /**
1004      * @dev Destroys `amount` tokens of token type `id` from `account`
1005      *
1006      * Requirements:
1007      *
1008      * - `account` cannot be the zero address.
1009      * - `account` must have at least `amount` tokens of token type `id`.
1010      */
1011     function _burn(
1012         address account,
1013         uint256 id,
1014         uint256 amount
1015     ) internal virtual {
1016         require(account != address(0), "ERC1155: burn from the zero address");
1017 
1018         address operator = _msgSender();
1019 
1020         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1021 
1022         uint256 accountBalance = _balances[id][account];
1023         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1024         unchecked {
1025             _balances[id][account] = accountBalance - amount;
1026         }
1027 
1028         emit TransferSingle(operator, account, address(0), id, amount);
1029     }
1030 
1031     /**
1032      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1033      *
1034      * Requirements:
1035      *
1036      * - `ids` and `amounts` must have the same length.
1037      */
1038     function _burnBatch(
1039         address account,
1040         uint256[] memory ids,
1041         uint256[] memory amounts
1042     ) internal virtual {
1043         require(account != address(0), "ERC1155: burn from the zero address");
1044         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1045 
1046         address operator = _msgSender();
1047 
1048         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1049 
1050         for (uint256 i = 0; i < ids.length; i++) {
1051             uint256 id = ids[i];
1052             uint256 amount = amounts[i];
1053 
1054             uint256 accountBalance = _balances[id][account];
1055             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1056             unchecked {
1057                 _balances[id][account] = accountBalance - amount;
1058             }
1059         }
1060 
1061         emit TransferBatch(operator, account, address(0), ids, amounts);
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any token transfer. This includes minting
1066      * and burning, as well as batched variants.
1067      *
1068      * The same hook is called on both single and batched variants. For single
1069      * transfers, the length of the `id` and `amount` arrays will be 1.
1070      *
1071      * Calling conditions (for each `id` and `amount` pair):
1072      *
1073      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1074      * of token type `id` will be  transferred to `to`.
1075      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1076      * for `to`.
1077      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1078      * will be burned.
1079      * - `from` and `to` are never both zero.
1080      * - `ids` and `amounts` have the same, non-zero length.
1081      *
1082      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1083      */
1084     function _beforeTokenTransfer(
1085         address operator,
1086         address from,
1087         address to,
1088         uint256[] memory ids,
1089         uint256[] memory amounts,
1090         bytes memory data
1091     ) internal virtual {}
1092 
1093     function _doSafeTransferAcceptanceCheck(
1094         address operator,
1095         address from,
1096         address to,
1097         uint256 id,
1098         uint256 amount,
1099         bytes memory data
1100     ) private {
1101         if (to.isContract()) {
1102             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1103                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1104                     revert("ERC1155: ERC1155Receiver rejected tokens");
1105                 }
1106             } catch Error(string memory reason) {
1107                 revert(reason);
1108             } catch {
1109                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1110             }
1111         }
1112     }
1113 
1114     function _doSafeBatchTransferAcceptanceCheck(
1115         address operator,
1116         address from,
1117         address to,
1118         uint256[] memory ids,
1119         uint256[] memory amounts,
1120         bytes memory data
1121     ) private {
1122         if (to.isContract()) {
1123             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1124                 bytes4 response
1125             ) {
1126                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
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
1137     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1138         uint256[] memory array = new uint256[](1);
1139         array[0] = element;
1140 
1141         return array;
1142     }
1143 }
1144 
1145 
1146 
1147 /**
1148  * @dev ERC1155 token with pausable token transfers, minting and burning.
1149  *
1150  * Useful for scenarios such as preventing trades until the end of an evaluation
1151  * period, or having an emergency switch for freezing all token transfers in the
1152  * event of a large bug.
1153  *
1154  * _Available since v3.1._
1155  */
1156 abstract contract ERC1155Pausable is ERC1155, Pausable {
1157     /**
1158      * @dev See {ERC1155-_beforeTokenTransfer}.
1159      *
1160      * Requirements:
1161      *
1162      * - the contract must not be paused.
1163      */
1164     function _beforeTokenTransfer(
1165         address operator,
1166         address from,
1167         address to,
1168         uint256[] memory ids,
1169         uint256[] memory amounts,
1170         bytes memory data
1171     ) internal virtual override {
1172         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1173 
1174         require(!paused(), "ERC1155Pausable: token transfer while paused");
1175     }
1176 }
1177 
1178 
1179 
1180 
1181 
1182 
1183 
1184 
1185 
1186 
1187 
1188 
1189 /**
1190  * @dev _Available since v3.1._
1191  */
1192 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
1193     /**
1194      * @dev See {IERC165-supportsInterface}.
1195      */
1196     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1197         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
1198     }
1199 }
1200 
1201 
1202 /**
1203  * @dev _Available since v3.1._
1204  */
1205 contract ERC1155Holder is ERC1155Receiver {
1206     function onERC1155Received(
1207         address,
1208         address,
1209         uint256,
1210         uint256,
1211         bytes memory
1212     ) public virtual override returns (bytes4) {
1213         return this.onERC1155Received.selector;
1214     }
1215 
1216     function onERC1155BatchReceived(
1217         address,
1218         address,
1219         uint256[] memory,
1220         uint256[] memory,
1221         bytes memory
1222     ) public virtual override returns (bytes4) {
1223         return this.onERC1155BatchReceived.selector;
1224     }
1225 }
1226 
1227 
1228 
1229 
1230 
1231 
1232 
1233 /**
1234  * @dev Contract module which provides a basic access control mechanism, where
1235  * there is an account (an owner) that can be granted exclusive access to
1236  * specific functions.
1237  *
1238  * By default, the owner account will be the one that deploys the contract. This
1239  * can later be changed with {transferOwnership}.
1240  *
1241  * This module is used through inheritance. It will make available the modifier
1242  * `onlyOwner`, which can be applied to your functions to restrict their use to
1243  * the owner.
1244  */
1245 abstract contract Ownable is Context {
1246     address private _owner;
1247 
1248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1249 
1250     /**
1251      * @dev Initializes the contract setting the deployer as the initial owner.
1252      */
1253     constructor() {
1254         _setOwner(_msgSender());
1255     }
1256 
1257     /**
1258      * @dev Returns the address of the current owner.
1259      */
1260     function owner() public view virtual returns (address) {
1261         return _owner;
1262     }
1263 
1264     /**
1265      * @dev Throws if called by any account other than the owner.
1266      */
1267     modifier onlyOwner() {
1268         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1269         _;
1270     }
1271 
1272     /**
1273      * @dev Leaves the contract without owner. It will not be possible to call
1274      * `onlyOwner` functions anymore. Can only be called by the current owner.
1275      *
1276      * NOTE: Renouncing ownership will leave the contract without an owner,
1277      * thereby removing any functionality that is only available to the owner.
1278      */
1279     function renounceOwnership() public virtual onlyOwner {
1280         _setOwner(address(0));
1281     }
1282 
1283     /**
1284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1285      * Can only be called by the current owner.
1286      */
1287     function transferOwnership(address newOwner) public virtual onlyOwner {
1288         require(newOwner != address(0), "Ownable: new owner is the zero address");
1289         _setOwner(newOwner);
1290     }
1291 
1292     function _setOwner(address newOwner) private {
1293         address oldOwner = _owner;
1294         _owner = newOwner;
1295         emit OwnershipTransferred(oldOwner, newOwner);
1296     }
1297 }
1298 
1299 
1300 
1301 
1302 
1303 
1304 
1305 
1306 
1307 
1308 contract VRFRequestIDBase {
1309 
1310   /**
1311    * @notice returns the seed which is actually input to the VRF coordinator
1312    *
1313    * @dev To prevent repetition of VRF output due to repetition of the
1314    * @dev user-supplied seed, that seed is combined in a hash with the
1315    * @dev user-specific nonce, and the address of the consuming contract. The
1316    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
1317    * @dev the final seed, but the nonce does protect against repetition in
1318    * @dev requests which are included in a single block.
1319    *
1320    * @param _userSeed VRF seed input provided by user
1321    * @param _requester Address of the requesting contract
1322    * @param _nonce User-specific nonce at the time of the request
1323    */
1324   function makeVRFInputSeed(
1325     bytes32 _keyHash,
1326     uint256 _userSeed,
1327     address _requester,
1328     uint256 _nonce
1329   )
1330     internal
1331     pure
1332     returns (
1333       uint256
1334     )
1335   {
1336     return uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
1337   }
1338 
1339   /**
1340    * @notice Returns the id for this request
1341    * @param _keyHash The serviceAgreement ID to be used for this request
1342    * @param _vRFInputSeed The seed to be passed directly to the VRF
1343    * @return The id for this request
1344    *
1345    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
1346    * @dev contract, but the one generated by makeVRFInputSeed
1347    */
1348   function makeRequestId(
1349     bytes32 _keyHash,
1350     uint256 _vRFInputSeed
1351   )
1352     internal
1353     pure
1354     returns (
1355       bytes32
1356     )
1357   {
1358     return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
1359   }
1360 }
1361 
1362 /** ****************************************************************************
1363  * @notice Interface for contracts using VRF randomness
1364  * *****************************************************************************
1365  * @dev PURPOSE
1366  *
1367  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
1368  * @dev to Vera the verifier in such a way that Vera can be sure he's not
1369  * @dev making his output up to suit himself. Reggie provides Vera a public key
1370  * @dev to which he knows the secret key. Each time Vera provides a seed to
1371  * @dev Reggie, he gives back a value which is computed completely
1372  * @dev deterministically from the seed and the secret key.
1373  *
1374  * @dev Reggie provides a proof by which Vera can verify that the output was
1375  * @dev correctly computed once Reggie tells it to her, but without that proof,
1376  * @dev the output is indistinguishable to her from a uniform random sample
1377  * @dev from the output space.
1378  *
1379  * @dev The purpose of this contract is to make it easy for unrelated contracts
1380  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
1381  * @dev simple access to a verifiable source of randomness.
1382  * *****************************************************************************
1383  * @dev USAGE
1384  *
1385  * @dev Calling contracts must inherit from VRFConsumerBase, and can
1386  * @dev initialize VRFConsumerBase's attributes in their constructor as
1387  * @dev shown:
1388  *
1389  * @dev   contract VRFConsumer {
1390  * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
1391  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
1392  * @dev         <initialization with other arguments goes here>
1393  * @dev       }
1394  * @dev   }
1395  *
1396  * @dev The oracle will have given you an ID for the VRF keypair they have
1397  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
1398  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
1399  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
1400  * @dev want to generate randomness from.
1401  *
1402  * @dev Once the VRFCoordinator has received and validated the oracle's response
1403  * @dev to your request, it will call your contract's fulfillRandomness method.
1404  *
1405  * @dev The randomness argument to fulfillRandomness is the actual random value
1406  * @dev generated from your seed.
1407  *
1408  * @dev The requestId argument is generated from the keyHash and the seed by
1409  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
1410  * @dev requests open, you can use the requestId to track which seed is
1411  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
1412  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
1413  * @dev if your contract could have multiple requests in flight simultaneously.)
1414  *
1415  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
1416  * @dev differ. (Which is critical to making unpredictable randomness! See the
1417  * @dev next section.)
1418  *
1419  * *****************************************************************************
1420  * @dev SECURITY CONSIDERATIONS
1421  *
1422  * @dev A method with the ability to call your fulfillRandomness method directly
1423  * @dev could spoof a VRF response with any random value, so it's critical that
1424  * @dev it cannot be directly called by anything other than this base contract
1425  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
1426  *
1427  * @dev For your users to trust that your contract's random behavior is free
1428  * @dev from malicious interference, it's best if you can write it so that all
1429  * @dev behaviors implied by a VRF response are executed *during* your
1430  * @dev fulfillRandomness method. If your contract must store the response (or
1431  * @dev anything derived from it) and use it later, you must ensure that any
1432  * @dev user-significant behavior which depends on that stored value cannot be
1433  * @dev manipulated by a subsequent VRF request.
1434  *
1435  * @dev Similarly, both miners and the VRF oracle itself have some influence
1436  * @dev over the order in which VRF responses appear on the blockchain, so if
1437  * @dev your contract could have multiple VRF requests in flight simultaneously,
1438  * @dev you must ensure that the order in which the VRF responses arrive cannot
1439  * @dev be used to manipulate your contract's user-significant behavior.
1440  *
1441  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
1442  * @dev block in which the request is made, user-provided seeds have no impact
1443  * @dev on its economic security properties. They are only included for API
1444  * @dev compatability with previous versions of this contract.
1445  *
1446  * @dev Since the block hash of the block which contains the requestRandomness
1447  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
1448  * @dev miner could, in principle, fork the blockchain to evict the block
1449  * @dev containing the request, forcing the request to be included in a
1450  * @dev different block with a different hash, and therefore a different input
1451  * @dev to the VRF. However, such an attack would incur a substantial economic
1452  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
1453  * @dev until it calls responds to a request.
1454  */
1455 abstract contract VRFConsumerBase is VRFRequestIDBase {
1456 
1457   /**
1458    * @notice fulfillRandomness handles the VRF response. Your contract must
1459    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
1460    * @notice principles to keep in mind when implementing your fulfillRandomness
1461    * @notice method.
1462    *
1463    * @dev VRFConsumerBase expects its subcontracts to have a method with this
1464    * @dev signature, and will call it once it has verified the proof
1465    * @dev associated with the randomness. (It is triggered via a call to
1466    * @dev rawFulfillRandomness, below.)
1467    *
1468    * @param requestId The Id initially returned by requestRandomness
1469    * @param randomness the VRF output
1470    */
1471   function fulfillRandomness(
1472     bytes32 requestId,
1473     uint256 randomness
1474   )
1475     internal
1476     virtual;
1477 
1478   /**
1479    * @dev In order to keep backwards compatibility we have kept the user
1480    * seed field around. We remove the use of it because given that the blockhash
1481    * enters later, it overrides whatever randomness the used seed provides.
1482    * Given that it adds no security, and can easily lead to misunderstandings,
1483    * we have removed it from usage and can now provide a simpler API.
1484    */
1485   uint256 constant private USER_SEED_PLACEHOLDER = 0;
1486 
1487   /**
1488    * @notice requestRandomness initiates a request for VRF output given _seed
1489    *
1490    * @dev The fulfillRandomness method receives the output, once it's provided
1491    * @dev by the Oracle, and verified by the vrfCoordinator.
1492    *
1493    * @dev The _keyHash must already be registered with the VRFCoordinator, and
1494    * @dev the _fee must exceed the fee specified during registration of the
1495    * @dev _keyHash.
1496    *
1497    * @dev The _seed parameter is vestigial, and is kept only for API
1498    * @dev compatibility with older versions. It can't *hurt* to mix in some of
1499    * @dev your own randomness, here, but it's not necessary because the VRF
1500    * @dev oracle will mix the hash of the block containing your request into the
1501    * @dev VRF seed it ultimately uses.
1502    *
1503    * @param _keyHash ID of public key against which randomness is generated
1504    * @param _fee The amount of LINK to send with the request
1505    *
1506    * @return requestId unique ID for this request
1507    *
1508    * @dev The returned requestId can be used to distinguish responses to
1509    * @dev concurrent requests. It is passed as the first argument to
1510    * @dev fulfillRandomness.
1511    */
1512   function requestRandomness(
1513     bytes32 _keyHash,
1514     uint256 _fee
1515   )
1516     internal
1517     returns (
1518       bytes32 requestId
1519     )
1520   {
1521     LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, USER_SEED_PLACEHOLDER));
1522     // This is the seed passed to VRFCoordinator. The oracle will mix this with
1523     // the hash of the block containing this request to obtain the seed/input
1524     // which is finally passed to the VRF cryptographic machinery.
1525     uint256 vRFSeed  = makeVRFInputSeed(_keyHash, USER_SEED_PLACEHOLDER, address(this), nonces[_keyHash]);
1526     // nonces[_keyHash] must stay in sync with
1527     // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
1528     // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
1529     // This provides protection against the user repeating their input seed,
1530     // which would result in a predictable/duplicate output, if multiple such
1531     // requests appeared in the same block.
1532     nonces[_keyHash] = nonces[_keyHash] + 1;
1533     return makeRequestId(_keyHash, vRFSeed);
1534   }
1535 
1536   LinkTokenInterface immutable internal LINK;
1537   address immutable private vrfCoordinator;
1538 
1539   // Nonces for each VRF key from which randomness has been requested.
1540   //
1541   // Must stay in sync with VRFCoordinator[_keyHash][this]
1542   mapping(bytes32 /* keyHash */ => uint256 /* nonce */) private nonces;
1543 
1544   /**
1545    * @param _vrfCoordinator address of VRFCoordinator contract
1546    * @param _link address of LINK token contract
1547    *
1548    * @dev https://docs.chain.link/docs/link-token-contracts
1549    */
1550   constructor(
1551     address _vrfCoordinator,
1552     address _link
1553   ) {
1554     vrfCoordinator = _vrfCoordinator;
1555     LINK = LinkTokenInterface(_link);
1556   }
1557 
1558   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
1559   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
1560   // the origin of the call
1561   function rawFulfillRandomness(
1562     bytes32 requestId,
1563     uint256 randomness
1564   )
1565     external
1566   {
1567     require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
1568     fulfillRandomness(requestId, randomness);
1569   }
1570 }
1571 
1572 
1573 interface Contract {
1574     function balanceOf(address owner) external view returns (uint256 balance);
1575     function totalSupply() external view returns (uint256 supply);
1576     function ownerOf(uint256 tokenId) external view returns (address owner);
1577 }
1578 
1579 contract BasedFishMafiaWire is ERC1155Pausable, ERC1155Holder, VRFConsumerBase {
1580 
1581     event RandomId(uint id);
1582 
1583     mapping(address => bool) private m_admin_map;
1584     uint private m_salt;
1585 
1586     Contract private constant m_bfm = Contract(0x138Ff21a21DFC06FbfCcf15F2D9Fd290a660E152);
1587     Contract private constant m_zfm = Contract(0xd66247EdA32bAcC0C06DACC80D19281535CE9D35);
1588 
1589     uint private m_seed;
1590 
1591     function supportsInterface(bytes4 interfaceId)
1592         public
1593         view
1594         virtual
1595         override(ERC1155, ERC1155Receiver)
1596         returns (bool)
1597     {
1598         return super.supportsInterface(interfaceId);
1599     }
1600 
1601     function _processAddAdmin(address user) internal {
1602         m_admin_map[user] = true;
1603     }
1604 
1605     modifier onlyAdmin() {
1606         require(m_admin_map[msg.sender], "must be admin to perform this action");
1607         _;
1608     }
1609 
1610     function addAdmin(address user) external onlyAdmin {
1611         _processAddAdmin(user);
1612     }
1613 
1614     constructor() ERC1155("https://basedfishmafia.com/api/wires/wires.json")
1615         VRFConsumerBase(
1616             0xf0d54349aDdcf704F77AE15b96510dEA15cb7952, // VRF
1617             0x514910771AF9Ca656af840dff83E8264EcF986CA  // LINK
1618         )
1619     {
1620         _processAddAdmin(msg.sender);
1621     }
1622 
1623 
1624     function burn(address user, uint count) external onlyAdmin {
1625         _burn(user, 0, count);
1626     }
1627 
1628     function seed() external onlyAdmin returns (bytes32 requestId) {
1629         uint fee = 2 * 10 ** 18;
1630         bytes32 keyh = 0xAA77729D3466CA35AE8D28B3BBAC7CC36A5031EFDC430821C02BC31A238AF445;
1631         require(LINK.balanceOf(address(this)) >= fee, "not enough LINK for transaction");
1632         return requestRandomness(keyh, fee);
1633     }
1634 
1635     function fulfillRandomness(bytes32, uint256 randomness) internal override {
1636         m_seed = randomness;
1637     }
1638 
1639     function distribute(uint count) external onlyAdmin {
1640         require(m_seed != 0, "need to seed() random value first");
1641 
1642         uint bfm_supply = m_bfm.totalSupply();
1643         uint zfm_supply = m_zfm.totalSupply();
1644         uint combined_supply = bfm_supply + zfm_supply;
1645 
1646         uint numPicked = 0;
1647         Contract selContract;
1648         uint randomId;
1649         address selUser;
1650         while (numPicked < count) {
1651             randomId = uint(keccak256(abi.encode(m_seed, m_salt++))) % combined_supply;
1652             emit RandomId(randomId);
1653 
1654             if (randomId < bfm_supply) {
1655                 selContract = m_bfm;
1656             } else {
1657                 selContract = m_zfm;
1658                 randomId -= bfm_supply;
1659             }
1660 
1661             selUser = selContract.ownerOf(randomId);
1662             if (selUser == address(0xE052113bd7D7700d623414a0a4585BCaE754E9d5) ||
1663                 selUser == address(0xCB6eA8Bb9cDF31c1cAcFD207906520aDc249a856)
1664             ) {
1665                 continue;
1666             }
1667 
1668             _mint(selUser, 0, 1, "");
1669             ++numPicked;
1670         }
1671     }
1672 }