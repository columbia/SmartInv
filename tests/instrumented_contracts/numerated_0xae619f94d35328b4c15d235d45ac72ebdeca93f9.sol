1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/access/Ownable.sol
31 
32 
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 // File: @openzeppelin/contracts/utils/Address.sol
109 
110 
111 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Collection of functions related to the address type
117  */
118 library Address {
119     /**
120      * @dev Returns true if `account` is a contract.
121      *
122      * [IMPORTANT]
123      * ====
124      * It is unsafe to assume that an address for which this function returns
125      * false is an externally-owned account (EOA) and not a contract.
126      *
127      * Among others, `isContract` will return false for the following
128      * types of addresses:
129      *
130      *  - an externally-owned account
131      *  - a contract in construction
132      *  - an address where a contract will be created
133      *  - an address where a contract lived, but was destroyed
134      * ====
135      */
136     function isContract(address account) internal view returns (bool) {
137         // This method relies on extcodesize, which returns 0 for contracts in
138         // construction, since the code is only stored at the end of the
139         // constructor execution.
140 
141         uint256 size;
142         assembly {
143             size := extcodesize(account)
144         }
145         return size > 0;
146     }
147 
148     /**
149      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
150      * `recipient`, forwarding all available gas and reverting on errors.
151      *
152      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
153      * of certain opcodes, possibly making contracts go over the 2300 gas limit
154      * imposed by `transfer`, making them unable to receive funds via
155      * `transfer`. {sendValue} removes this limitation.
156      *
157      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
158      *
159      * IMPORTANT: because control is transferred to `recipient`, care must be
160      * taken to not create reentrancy vulnerabilities. Consider using
161      * {ReentrancyGuard} or the
162      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
163      */
164     function sendValue(address payable recipient, uint256 amount) internal {
165         require(address(this).balance >= amount, "Address: insufficient balance");
166 
167         (bool success, ) = recipient.call{value: amount}("");
168         require(success, "Address: unable to send value, recipient may have reverted");
169     }
170 
171     /**
172      * @dev Performs a Solidity function call using a low level `call`. A
173      * plain `call` is an unsafe replacement for a function call: use this
174      * function instead.
175      *
176      * If `target` reverts with a revert reason, it is bubbled up by this
177      * function (like regular Solidity function calls).
178      *
179      * Returns the raw returned data. To convert to the expected return value,
180      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
181      *
182      * Requirements:
183      *
184      * - `target` must be a contract.
185      * - calling `target` with `data` must not revert.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionCall(target, data, "Address: low-level call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
195      * `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, 0, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but also transferring `value` wei to `target`.
210      *
211      * Requirements:
212      *
213      * - the calling contract must have an ETH balance of at least `value`.
214      * - the called Solidity function must be `payable`.
215      *
216      * _Available since v3.1._
217      */
218     function functionCallWithValue(
219         address target,
220         bytes memory data,
221         uint256 value
222     ) internal returns (bytes memory) {
223         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
228      * with `errorMessage` as a fallback revert reason when `target` reverts.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         require(address(this).balance >= value, "Address: insufficient balance for call");
239         require(isContract(target), "Address: call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.call{value: value}(data);
242         return verifyCallResult(success, returndata, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
252         return functionStaticCall(target, data, "Address: low-level static call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal view returns (bytes memory) {
266         require(isContract(target), "Address: static call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.staticcall(data);
269         return verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
284      * but performing a delegate call.
285      *
286      * _Available since v3.4._
287      */
288     function functionDelegateCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         require(isContract(target), "Address: delegate call to non-contract");
294 
295         (bool success, bytes memory returndata) = target.delegatecall(data);
296         return verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     /**
300      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
301      * revert reason using the provided one.
302      *
303      * _Available since v4.3._
304      */
305     function verifyCallResult(
306         bool success,
307         bytes memory returndata,
308         string memory errorMessage
309     ) internal pure returns (bytes memory) {
310         if (success) {
311             return returndata;
312         } else {
313             // Look for revert reason and bubble it up if present
314             if (returndata.length > 0) {
315                 // The easiest way to bubble the revert reason is using memory via assembly
316 
317                 assembly {
318                     let returndata_size := mload(returndata)
319                     revert(add(32, returndata), returndata_size)
320                 }
321             } else {
322                 revert(errorMessage);
323             }
324         }
325     }
326 }
327 
328 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev Interface of the ERC165 standard, as defined in the
337  * https://eips.ethereum.org/EIPS/eip-165[EIP].
338  *
339  * Implementers can declare support of contract interfaces, which can then be
340  * queried by others ({ERC165Checker}).
341  *
342  * For an implementation, see {ERC165}.
343  */
344 interface IERC165 {
345     /**
346      * @dev Returns true if this contract implements the interface defined by
347      * `interfaceId`. See the corresponding
348      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
349      * to learn more about how these ids are created.
350      *
351      * This function call must use less than 30 000 gas.
352      */
353     function supportsInterface(bytes4 interfaceId) external view returns (bool);
354 }
355 
356 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 /**
365  * @dev Implementation of the {IERC165} interface.
366  *
367  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
368  * for the additional interface id that will be supported. For example:
369  *
370  * ```solidity
371  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
372  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
373  * }
374  * ```
375  *
376  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
377  */
378 abstract contract ERC165 is IERC165 {
379     /**
380      * @dev See {IERC165-supportsInterface}.
381      */
382     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
383         return interfaceId == type(IERC165).interfaceId;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev _Available since v3.1._
397  */
398 interface IERC1155Receiver is IERC165 {
399     /**
400         @dev Handles the receipt of a single ERC1155 token type. This function is
401         called at the end of a `safeTransferFrom` after the balance has been updated.
402         To accept the transfer, this must return
403         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
404         (i.e. 0xf23a6e61, or its own function selector).
405         @param operator The address which initiated the transfer (i.e. msg.sender)
406         @param from The address which previously owned the token
407         @param id The ID of the token being transferred
408         @param value The amount of tokens being transferred
409         @param data Additional data with no specified format
410         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
411     */
412     function onERC1155Received(
413         address operator,
414         address from,
415         uint256 id,
416         uint256 value,
417         bytes calldata data
418     ) external returns (bytes4);
419 
420     /**
421         @dev Handles the receipt of a multiple ERC1155 token types. This function
422         is called at the end of a `safeBatchTransferFrom` after the balances have
423         been updated. To accept the transfer(s), this must return
424         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
425         (i.e. 0xbc197c81, or its own function selector).
426         @param operator The address which initiated the batch transfer (i.e. msg.sender)
427         @param from The address which previously owned the token
428         @param ids An array containing ids of each token being transferred (order and length must match values array)
429         @param values An array containing amounts of each token being transferred (order and length must match ids array)
430         @param data Additional data with no specified format
431         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
432     */
433     function onERC1155BatchReceived(
434         address operator,
435         address from,
436         uint256[] calldata ids,
437         uint256[] calldata values,
438         bytes calldata data
439     ) external returns (bytes4);
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 
450 /**
451  * @dev Required interface of an ERC1155 compliant contract, as defined in the
452  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
453  *
454  * _Available since v3.1._
455  */
456 interface IERC1155 is IERC165 {
457     /**
458      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
459      */
460     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
461 
462     /**
463      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
464      * transfers.
465      */
466     event TransferBatch(
467         address indexed operator,
468         address indexed from,
469         address indexed to,
470         uint256[] ids,
471         uint256[] values
472     );
473 
474     /**
475      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
476      * `approved`.
477      */
478     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
479 
480     /**
481      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
482      *
483      * If an {URI} event was emitted for `id`, the standard
484      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
485      * returned by {IERC1155MetadataURI-uri}.
486      */
487     event URI(string value, uint256 indexed id);
488 
489     /**
490      * @dev Returns the amount of tokens of token type `id` owned by `account`.
491      *
492      * Requirements:
493      *
494      * - `account` cannot be the zero address.
495      */
496     function balanceOf(address account, uint256 id) external view returns (uint256);
497 
498     /**
499      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
500      *
501      * Requirements:
502      *
503      * - `accounts` and `ids` must have the same length.
504      */
505     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
506         external
507         view
508         returns (uint256[] memory);
509 
510     /**
511      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
512      *
513      * Emits an {ApprovalForAll} event.
514      *
515      * Requirements:
516      *
517      * - `operator` cannot be the caller.
518      */
519     function setApprovalForAll(address operator, bool approved) external;
520 
521     /**
522      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
523      *
524      * See {setApprovalForAll}.
525      */
526     function isApprovedForAll(address account, address operator) external view returns (bool);
527 
528     /**
529      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
530      *
531      * Emits a {TransferSingle} event.
532      *
533      * Requirements:
534      *
535      * - `to` cannot be the zero address.
536      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
537      * - `from` must have a balance of tokens of type `id` of at least `amount`.
538      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
539      * acceptance magic value.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 id,
545         uint256 amount,
546         bytes calldata data
547     ) external;
548 
549     /**
550      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
551      *
552      * Emits a {TransferBatch} event.
553      *
554      * Requirements:
555      *
556      * - `ids` and `amounts` must have the same length.
557      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
558      * acceptance magic value.
559      */
560     function safeBatchTransferFrom(
561         address from,
562         address to,
563         uint256[] calldata ids,
564         uint256[] calldata amounts,
565         bytes calldata data
566     ) external;
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
579  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
580  *
581  * _Available since v3.1._
582  */
583 interface IERC1155MetadataURI is IERC1155 {
584     /**
585      * @dev Returns the URI for token type `id`.
586      *
587      * If the `\{id\}` substring is present in the URI, it must be replaced by
588      * clients with the actual token type ID.
589      */
590     function uri(uint256 id) external view returns (string memory);
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 
602 
603 
604 
605 
606 /**
607  * @dev Implementation of the basic standard multi-token.
608  * See https://eips.ethereum.org/EIPS/eip-1155
609  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
610  *
611  * _Available since v3.1._
612  */
613 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
614     using Address for address;
615 
616     // Mapping from token ID to account balances
617     mapping(uint256 => mapping(address => uint256)) private _balances;
618 
619     // Mapping from account to operator approvals
620     mapping(address => mapping(address => bool)) private _operatorApprovals;
621 
622     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
623     string private _uri;
624 
625     /**
626      * @dev See {_setURI}.
627      */
628     constructor(string memory uri_) {
629         _setURI(uri_);
630     }
631 
632     /**
633      * @dev See {IERC165-supportsInterface}.
634      */
635     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
636         return
637             interfaceId == type(IERC1155).interfaceId ||
638             interfaceId == type(IERC1155MetadataURI).interfaceId ||
639             super.supportsInterface(interfaceId);
640     }
641 
642     /**
643      * @dev See {IERC1155MetadataURI-uri}.
644      *
645      * This implementation returns the same URI for *all* token types. It relies
646      * on the token type ID substitution mechanism
647      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
648      *
649      * Clients calling this function must replace the `\{id\}` substring with the
650      * actual token type ID.
651      */
652     function uri(uint256) public view virtual override returns (string memory) {
653         return _uri;
654     }
655 
656     /**
657      * @dev See {IERC1155-balanceOf}.
658      *
659      * Requirements:
660      *
661      * - `account` cannot be the zero address.
662      */
663     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
664         require(account != address(0), "ERC1155: balance query for the zero address");
665         return _balances[id][account];
666     }
667 
668     /**
669      * @dev See {IERC1155-balanceOfBatch}.
670      *
671      * Requirements:
672      *
673      * - `accounts` and `ids` must have the same length.
674      */
675     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
676         public
677         view
678         virtual
679         override
680         returns (uint256[] memory)
681     {
682         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
683 
684         uint256[] memory batchBalances = new uint256[](accounts.length);
685 
686         for (uint256 i = 0; i < accounts.length; ++i) {
687             batchBalances[i] = balanceOf(accounts[i], ids[i]);
688         }
689 
690         return batchBalances;
691     }
692 
693     /**
694      * @dev See {IERC1155-setApprovalForAll}.
695      */
696     function setApprovalForAll(address operator, bool approved) public virtual override {
697         _setApprovalForAll(_msgSender(), operator, approved);
698     }
699 
700     /**
701      * @dev See {IERC1155-isApprovedForAll}.
702      */
703     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
704         return _operatorApprovals[account][operator];
705     }
706 
707     /**
708      * @dev See {IERC1155-safeTransferFrom}.
709      */
710     function safeTransferFrom(
711         address from,
712         address to,
713         uint256 id,
714         uint256 amount,
715         bytes memory data
716     ) public virtual override {
717         require(
718             from == _msgSender() || isApprovedForAll(from, _msgSender()),
719             "ERC1155: caller is not owner nor approved"
720         );
721         _safeTransferFrom(from, to, id, amount, data);
722     }
723 
724     /**
725      * @dev See {IERC1155-safeBatchTransferFrom}.
726      */
727     function safeBatchTransferFrom(
728         address from,
729         address to,
730         uint256[] memory ids,
731         uint256[] memory amounts,
732         bytes memory data
733     ) public virtual override {
734         require(
735             from == _msgSender() || isApprovedForAll(from, _msgSender()),
736             "ERC1155: transfer caller is not owner nor approved"
737         );
738         _safeBatchTransferFrom(from, to, ids, amounts, data);
739     }
740 
741     /**
742      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
743      *
744      * Emits a {TransferSingle} event.
745      *
746      * Requirements:
747      *
748      * - `to` cannot be the zero address.
749      * - `from` must have a balance of tokens of type `id` of at least `amount`.
750      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
751      * acceptance magic value.
752      */
753     function _safeTransferFrom(
754         address from,
755         address to,
756         uint256 id,
757         uint256 amount,
758         bytes memory data
759     ) internal virtual {
760         require(to != address(0), "ERC1155: transfer to the zero address");
761 
762         address operator = _msgSender();
763 
764         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
765 
766         uint256 fromBalance = _balances[id][from];
767         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
768         unchecked {
769             _balances[id][from] = fromBalance - amount;
770         }
771         _balances[id][to] += amount;
772 
773         emit TransferSingle(operator, from, to, id, amount);
774 
775         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
776     }
777 
778     /**
779      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
780      *
781      * Emits a {TransferBatch} event.
782      *
783      * Requirements:
784      *
785      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
786      * acceptance magic value.
787      */
788     function _safeBatchTransferFrom(
789         address from,
790         address to,
791         uint256[] memory ids,
792         uint256[] memory amounts,
793         bytes memory data
794     ) internal virtual {
795         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
796         require(to != address(0), "ERC1155: transfer to the zero address");
797 
798         address operator = _msgSender();
799 
800         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
801 
802         for (uint256 i = 0; i < ids.length; ++i) {
803             uint256 id = ids[i];
804             uint256 amount = amounts[i];
805 
806             uint256 fromBalance = _balances[id][from];
807             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
808             unchecked {
809                 _balances[id][from] = fromBalance - amount;
810             }
811             _balances[id][to] += amount;
812         }
813 
814         emit TransferBatch(operator, from, to, ids, amounts);
815 
816         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
817     }
818 
819     /**
820      * @dev Sets a new URI for all token types, by relying on the token type ID
821      * substitution mechanism
822      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
823      *
824      * By this mechanism, any occurrence of the `\{id\}` substring in either the
825      * URI or any of the amounts in the JSON file at said URI will be replaced by
826      * clients with the token type ID.
827      *
828      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
829      * interpreted by clients as
830      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
831      * for token type ID 0x4cce0.
832      *
833      * See {uri}.
834      *
835      * Because these URIs cannot be meaningfully represented by the {URI} event,
836      * this function emits no events.
837      */
838     function _setURI(string memory newuri) internal virtual {
839         _uri = newuri;
840     }
841 
842     /**
843      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
844      *
845      * Emits a {TransferSingle} event.
846      *
847      * Requirements:
848      *
849      * - `to` cannot be the zero address.
850      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
851      * acceptance magic value.
852      */
853     function _mint(
854         address to,
855         uint256 id,
856         uint256 amount,
857         bytes memory data
858     ) internal virtual {
859         require(to != address(0), "ERC1155: mint to the zero address");
860 
861         address operator = _msgSender();
862 
863         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
864 
865         _balances[id][to] += amount;
866         emit TransferSingle(operator, address(0), to, id, amount);
867 
868         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
869     }
870 
871     /**
872      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
873      *
874      * Requirements:
875      *
876      * - `ids` and `amounts` must have the same length.
877      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
878      * acceptance magic value.
879      */
880     function _mintBatch(
881         address to,
882         uint256[] memory ids,
883         uint256[] memory amounts,
884         bytes memory data
885     ) internal virtual {
886         require(to != address(0), "ERC1155: mint to the zero address");
887         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
888 
889         address operator = _msgSender();
890 
891         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
892 
893         for (uint256 i = 0; i < ids.length; i++) {
894             _balances[ids[i]][to] += amounts[i];
895         }
896 
897         emit TransferBatch(operator, address(0), to, ids, amounts);
898 
899         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
900     }
901 
902     /**
903      * @dev Destroys `amount` tokens of token type `id` from `from`
904      *
905      * Requirements:
906      *
907      * - `from` cannot be the zero address.
908      * - `from` must have at least `amount` tokens of token type `id`.
909      */
910     function _burn(
911         address from,
912         uint256 id,
913         uint256 amount
914     ) internal virtual {
915         require(from != address(0), "ERC1155: burn from the zero address");
916 
917         address operator = _msgSender();
918 
919         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
920 
921         uint256 fromBalance = _balances[id][from];
922         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
923         unchecked {
924             _balances[id][from] = fromBalance - amount;
925         }
926 
927         emit TransferSingle(operator, from, address(0), id, amount);
928     }
929 
930     /**
931      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
932      *
933      * Requirements:
934      *
935      * - `ids` and `amounts` must have the same length.
936      */
937     function _burnBatch(
938         address from,
939         uint256[] memory ids,
940         uint256[] memory amounts
941     ) internal virtual {
942         require(from != address(0), "ERC1155: burn from the zero address");
943         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
944 
945         address operator = _msgSender();
946 
947         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
948 
949         for (uint256 i = 0; i < ids.length; i++) {
950             uint256 id = ids[i];
951             uint256 amount = amounts[i];
952 
953             uint256 fromBalance = _balances[id][from];
954             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
955             unchecked {
956                 _balances[id][from] = fromBalance - amount;
957             }
958         }
959 
960         emit TransferBatch(operator, from, address(0), ids, amounts);
961     }
962 
963     /**
964      * @dev Approve `operator` to operate on all of `owner` tokens
965      *
966      * Emits a {ApprovalForAll} event.
967      */
968     function _setApprovalForAll(
969         address owner,
970         address operator,
971         bool approved
972     ) internal virtual {
973         require(owner != operator, "ERC1155: setting approval status for self");
974         _operatorApprovals[owner][operator] = approved;
975         emit ApprovalForAll(owner, operator, approved);
976     }
977 
978     /**
979      * @dev Hook that is called before any token transfer. This includes minting
980      * and burning, as well as batched variants.
981      *
982      * The same hook is called on both single and batched variants. For single
983      * transfers, the length of the `id` and `amount` arrays will be 1.
984      *
985      * Calling conditions (for each `id` and `amount` pair):
986      *
987      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
988      * of token type `id` will be  transferred to `to`.
989      * - When `from` is zero, `amount` tokens of token type `id` will be minted
990      * for `to`.
991      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
992      * will be burned.
993      * - `from` and `to` are never both zero.
994      * - `ids` and `amounts` have the same, non-zero length.
995      *
996      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
997      */
998     function _beforeTokenTransfer(
999         address operator,
1000         address from,
1001         address to,
1002         uint256[] memory ids,
1003         uint256[] memory amounts,
1004         bytes memory data
1005     ) internal virtual {}
1006 
1007     function _doSafeTransferAcceptanceCheck(
1008         address operator,
1009         address from,
1010         address to,
1011         uint256 id,
1012         uint256 amount,
1013         bytes memory data
1014     ) private {
1015         if (to.isContract()) {
1016             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1017                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1018                     revert("ERC1155: ERC1155Receiver rejected tokens");
1019                 }
1020             } catch Error(string memory reason) {
1021                 revert(reason);
1022             } catch {
1023                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1024             }
1025         }
1026     }
1027 
1028     function _doSafeBatchTransferAcceptanceCheck(
1029         address operator,
1030         address from,
1031         address to,
1032         uint256[] memory ids,
1033         uint256[] memory amounts,
1034         bytes memory data
1035     ) private {
1036         if (to.isContract()) {
1037             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1038                 bytes4 response
1039             ) {
1040                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1041                     revert("ERC1155: ERC1155Receiver rejected tokens");
1042                 }
1043             } catch Error(string memory reason) {
1044                 revert(reason);
1045             } catch {
1046                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1047             }
1048         }
1049     }
1050 
1051     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1052         uint256[] memory array = new uint256[](1);
1053         array[0] = element;
1054 
1055         return array;
1056     }
1057 }
1058 
1059 // File: contracts/MetaSphere.sol
1060 
1061 
1062 pragma solidity ^0.8.0;
1063 
1064 
1065 
1066 contract MetaSphere is ERC1155, Ownable {
1067     string public constant name = "Meta Sphere";
1068     string public constant symbol = "MS";
1069 
1070     uint32 public totalSupply = 0;
1071 
1072     uint32 public preSaleStart = 1643223600;
1073     uint256 public constant preSaleUnitPrice = 0.09 ether;
1074     uint32 public constant preSaleMaxSupply = 4444;
1075 
1076     uint32 public publicSaleStart = 1643310000;
1077     uint256 public constant publicSaleUnitPrice = 0.1 ether;
1078     uint32 public constant publicSaleMaxSupply = 6666;
1079 
1080     address signerAddress = 0x98EB87dDBc85B2720Fc0A89A7aAD2f42480E823D;
1081 
1082     constructor(string memory uri) ERC1155(uri) {}
1083 
1084     function setURI(string memory uri) public onlyOwner {
1085         _setURI(uri);
1086     }
1087 
1088     function setSignerAddress(address addr) external onlyOwner {
1089         signerAddress = addr;
1090     }
1091 
1092     function setPreSaleStart(uint32 timestamp) public onlyOwner {
1093         preSaleStart = timestamp;
1094     }
1095 
1096     function setPublicSaleStart(uint32 timestamp) public onlyOwner {
1097         publicSaleStart = timestamp;
1098     }
1099 
1100     function preSaleIsActive() public view returns (bool) {
1101         return
1102             preSaleStart <= block.timestamp &&
1103             publicSaleStart > block.timestamp;
1104     }
1105 
1106     function publicSaleIsActive() public view returns (bool) {
1107         return publicSaleStart <= block.timestamp;
1108     }
1109 
1110     function isValidAccessMessage(
1111         uint8 v,
1112         bytes32 r,
1113         bytes32 s
1114     ) internal view returns (bool) {
1115         bytes32 hash = keccak256(abi.encodePacked(msg.sender));
1116         return
1117             signerAddress ==
1118             ecrecover(
1119                 keccak256(
1120                     abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1121                 ),
1122                 v,
1123                 r,
1124                 s
1125             );
1126     }
1127 
1128     function mint(address to, uint32 count) internal {
1129         if (count > 1) {
1130             uint256[] memory ids = new uint256[](uint256(count));
1131             uint256[] memory amounts = new uint256[](uint256(count));
1132 
1133             for (uint32 i = 0; i < count; i++) {
1134                 ids[i] = totalSupply + i;
1135                 amounts[i] = 1;
1136             }
1137 
1138             _mintBatch(to, ids, amounts, "");
1139         } else {
1140             _mint(to, totalSupply, 1, "");
1141         }
1142 
1143         totalSupply += count;
1144     }
1145 
1146     function preSaleMint(
1147         uint8 v,
1148         bytes32 r,
1149         bytes32 s,
1150         uint32 count
1151     ) external payable {
1152         require(preSaleIsActive(), "Pre-sale is not active.");
1153         require(isValidAccessMessage(v, r, s), "Not whitelisted.");
1154         require(count > 0, "Count must be greater than 0.");
1155         require(
1156             totalSupply + count <= preSaleMaxSupply,
1157             "Count exceeds the maximum allowed supply."
1158         );
1159         require(msg.value >= preSaleUnitPrice * count, "Not enough ether.");
1160 
1161         mint(msg.sender, count);
1162     }
1163 
1164     function publicSaleMint(uint32 count) external payable {
1165         require(publicSaleIsActive(), "Public sale is not active.");
1166         require(count > 0, "Count must be greater than 0.");
1167         require(
1168             totalSupply + count <= publicSaleMaxSupply,
1169             "Count exceeds the maximum allowed supply."
1170         );
1171         require(msg.value >= publicSaleUnitPrice * count, "Not enough ether.");
1172 
1173         mint(msg.sender, count);
1174     }
1175 
1176     function batchMint(address[] memory addresses) external onlyOwner {
1177         require(
1178             totalSupply + addresses.length <= publicSaleMaxSupply,
1179             "Count exceeds the maximum allowed supply."
1180         );
1181 
1182         for (uint256 i = 0; i < addresses.length; i++) {
1183             mint(addresses[i], 1);
1184         }
1185     }
1186 
1187     function withdraw() external onlyOwner {
1188         address[4] memory addresses = [
1189             0x0e5aE2f582e8fbf3338788953577C805Dbd647B1,
1190             0x00889fc62F0b701e6393A99495F9d0b24C8858E8,
1191             0x1831bF0892b9a6978DCC742fE999B961643a9ED7,
1192             0x45394FF3c6C3442240bE68aAf5a852f07e745AfD
1193         ];
1194 
1195         uint32[4] memory shares = [
1196             uint32(8050),
1197             uint32(1250),
1198             uint32(400),
1199             uint32(300)
1200         ];
1201 
1202         uint256 balance = address(this).balance;
1203 
1204         for (uint32 i = 0; i < addresses.length; i++) {
1205             uint256 amount = i == addresses.length - 1
1206                 ? address(this).balance
1207                 : (balance * shares[i]) / 10000;
1208             payable(addresses[i]).transfer(amount);
1209         }
1210     }
1211 }