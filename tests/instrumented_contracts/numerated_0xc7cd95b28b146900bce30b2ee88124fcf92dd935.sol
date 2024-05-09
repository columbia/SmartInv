1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 // File openzeppelin-solidity/contracts/access/Ownable.sol@v4.2.0
27 
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _setOwner(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _setOwner(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _setOwner(newOwner);
89     }
90 
91     function _setOwner(address newOwner) private {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 // File contracts/AbstractTCLEntity.sol
100 
101 
102  
103 pragma solidity ^0.8.0;
104 abstract contract AbstractTCLEntity is Ownable {
105 
106     address internal _admin;
107 
108     /* modifiers */
109     modifier onlyOwnerOrAdmin {
110         if(_admin != address(0)){
111             require(_msgSender() == owner() || _msgSender() == admin(), "TCL Entity: Sender is neither owner nor admin.");
112         }
113         else {
114             require(_msgSender() == owner(),  "TCL Entity: Sender is not owner.");
115         }
116         _;
117     }
118 
119     /* getter & setter for admin address */
120     function admin() public view returns (address) {
121         return _admin;
122     }
123     function setAdmin(address newAdmin) external onlyOwnerOrAdmin {
124         require(newAdmin != address(0), "TCL Entity: Admin cannot be AddressZero");
125         require(newAdmin != owner(), "TCL Entity: Owner and admin cannot be the same address.");
126         _admin = newAdmin;
127     }
128 }
129 
130 
131 // File openzeppelin-solidity/contracts/utils/introspection/IERC165.sol@v4.2.0
132 
133 
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Interface of the ERC165 standard, as defined in the
139  * https://eips.ethereum.org/EIPS/eip-165[EIP].
140  *
141  * Implementers can declare support of contract interfaces, which can then be
142  * queried by others ({ERC165Checker}).
143  *
144  * For an implementation, see {ERC165}.
145  */
146 interface IERC165 {
147     /**
148      * @dev Returns true if this contract implements the interface defined by
149      * `interfaceId`. See the corresponding
150      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
151      * to learn more about how these ids are created.
152      *
153      * This function call must use less than 30 000 gas.
154      */
155     function supportsInterface(bytes4 interfaceId) external view returns (bool);
156 }
157 
158 
159 // File openzeppelin-solidity/contracts/token/ERC1155/IERC1155.sol@v4.2.0
160 
161 
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @dev Required interface of an ERC1155 compliant contract, as defined in the
167  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
168  *
169  * _Available since v3.1._
170  */
171 interface IERC1155 is IERC165 {
172     /**
173      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
174      */
175     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
176 
177     /**
178      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
179      * transfers.
180      */
181     event TransferBatch(
182         address indexed operator,
183         address indexed from,
184         address indexed to,
185         uint256[] ids,
186         uint256[] values
187     );
188 
189     /**
190      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
191      * `approved`.
192      */
193     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
194 
195     /**
196      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
197      *
198      * If an {URI} event was emitted for `id`, the standard
199      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
200      * returned by {IERC1155MetadataURI-uri}.
201      */
202     event URI(string value, uint256 indexed id);
203 
204     /**
205      * @dev Returns the amount of tokens of token type `id` owned by `account`.
206      *
207      * Requirements:
208      *
209      * - `account` cannot be the zero address.
210      */
211     function balanceOf(address account, uint256 id) external view returns (uint256);
212 
213     /**
214      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
215      *
216      * Requirements:
217      *
218      * - `accounts` and `ids` must have the same length.
219      */
220     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
221         external
222         view
223         returns (uint256[] memory);
224 
225     /**
226      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
227      *
228      * Emits an {ApprovalForAll} event.
229      *
230      * Requirements:
231      *
232      * - `operator` cannot be the caller.
233      */
234     function setApprovalForAll(address operator, bool approved) external;
235 
236     /**
237      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
238      *
239      * See {setApprovalForAll}.
240      */
241     function isApprovedForAll(address account, address operator) external view returns (bool);
242 
243     /**
244      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
245      *
246      * Emits a {TransferSingle} event.
247      *
248      * Requirements:
249      *
250      * - `to` cannot be the zero address.
251      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
252      * - `from` must have a balance of tokens of type `id` of at least `amount`.
253      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
254      * acceptance magic value.
255      */
256     function safeTransferFrom(
257         address from,
258         address to,
259         uint256 id,
260         uint256 amount,
261         bytes calldata data
262     ) external;
263 
264     /**
265      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
266      *
267      * Emits a {TransferBatch} event.
268      *
269      * Requirements:
270      *
271      * - `ids` and `amounts` must have the same length.
272      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
273      * acceptance magic value.
274      */
275     function safeBatchTransferFrom(
276         address from,
277         address to,
278         uint256[] calldata ids,
279         uint256[] calldata amounts,
280         bytes calldata data
281     ) external;
282 }
283 
284 
285 // File openzeppelin-solidity/contracts/token/ERC1155/IERC1155Receiver.sol@v4.2.0
286 
287 
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev _Available since v3.1._
293  */
294 interface IERC1155Receiver is IERC165 {
295     /**
296         @dev Handles the receipt of a single ERC1155 token type. This function is
297         called at the end of a `safeTransferFrom` after the balance has been updated.
298         To accept the transfer, this must return
299         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
300         (i.e. 0xf23a6e61, or its own function selector).
301         @param operator The address which initiated the transfer (i.e. msg.sender)
302         @param from The address which previously owned the token
303         @param id The ID of the token being transferred
304         @param value The amount of tokens being transferred
305         @param data Additional data with no specified format
306         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
307     */
308     function onERC1155Received(
309         address operator,
310         address from,
311         uint256 id,
312         uint256 value,
313         bytes calldata data
314     ) external returns (bytes4);
315 
316     /**
317         @dev Handles the receipt of a multiple ERC1155 token types. This function
318         is called at the end of a `safeBatchTransferFrom` after the balances have
319         been updated. To accept the transfer(s), this must return
320         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
321         (i.e. 0xbc197c81, or its own function selector).
322         @param operator The address which initiated the batch transfer (i.e. msg.sender)
323         @param from The address which previously owned the token
324         @param ids An array containing ids of each token being transferred (order and length must match values array)
325         @param values An array containing amounts of each token being transferred (order and length must match ids array)
326         @param data Additional data with no specified format
327         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
328     */
329     function onERC1155BatchReceived(
330         address operator,
331         address from,
332         uint256[] calldata ids,
333         uint256[] calldata values,
334         bytes calldata data
335     ) external returns (bytes4);
336 }
337 
338 
339 // File openzeppelin-solidity/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.2.0
340 
341 
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
347  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
348  *
349  * _Available since v3.1._
350  */
351 interface IERC1155MetadataURI is IERC1155 {
352     /**
353      * @dev Returns the URI for token type `id`.
354      *
355      * If the `\{id\}` substring is present in the URI, it must be replaced by
356      * clients with the actual token type ID.
357      */
358     function uri(uint256 id) external view returns (string memory);
359 }
360 
361 
362 // File openzeppelin-solidity/contracts/utils/Address.sol@v4.2.0
363 
364 
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev Collection of functions related to the address type
370  */
371 library Address {
372     /**
373      * @dev Returns true if `account` is a contract.
374      *
375      * [IMPORTANT]
376      * ====
377      * It is unsafe to assume that an address for which this function returns
378      * false is an externally-owned account (EOA) and not a contract.
379      *
380      * Among others, `isContract` will return false for the following
381      * types of addresses:
382      *
383      *  - an externally-owned account
384      *  - a contract in construction
385      *  - an address where a contract will be created
386      *  - an address where a contract lived, but was destroyed
387      * ====
388      */
389     function isContract(address account) internal view returns (bool) {
390         // This method relies on extcodesize, which returns 0 for contracts in
391         // construction, since the code is only stored at the end of the
392         // constructor execution.
393 
394         uint256 size;
395         assembly {
396             size := extcodesize(account)
397         }
398         return size > 0;
399     }
400 
401     /**
402      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
403      * `recipient`, forwarding all available gas and reverting on errors.
404      *
405      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
406      * of certain opcodes, possibly making contracts go over the 2300 gas limit
407      * imposed by `transfer`, making them unable to receive funds via
408      * `transfer`. {sendValue} removes this limitation.
409      *
410      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
411      *
412      * IMPORTANT: because control is transferred to `recipient`, care must be
413      * taken to not create reentrancy vulnerabilities. Consider using
414      * {ReentrancyGuard} or the
415      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
416      */
417     function sendValue(address payable recipient, uint256 amount) internal {
418         require(address(this).balance >= amount, "Address: insufficient balance");
419 
420         (bool success, ) = recipient.call{value: amount}("");
421         require(success, "Address: unable to send value, recipient may have reverted");
422     }
423 
424     /**
425      * @dev Performs a Solidity function call using a low level `call`. A
426      * plain `call` is an unsafe replacement for a function call: use this
427      * function instead.
428      *
429      * If `target` reverts with a revert reason, it is bubbled up by this
430      * function (like regular Solidity function calls).
431      *
432      * Returns the raw returned data. To convert to the expected return value,
433      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
434      *
435      * Requirements:
436      *
437      * - `target` must be a contract.
438      * - calling `target` with `data` must not revert.
439      *
440      * _Available since v3.1._
441      */
442     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
443         return functionCall(target, data, "Address: low-level call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
448      * `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         return functionCallWithValue(target, data, 0, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but also transferring `value` wei to `target`.
463      *
464      * Requirements:
465      *
466      * - the calling contract must have an ETH balance of at least `value`.
467      * - the called Solidity function must be `payable`.
468      *
469      * _Available since v3.1._
470      */
471     function functionCallWithValue(
472         address target,
473         bytes memory data,
474         uint256 value
475     ) internal returns (bytes memory) {
476         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
481      * with `errorMessage` as a fallback revert reason when `target` reverts.
482      *
483      * _Available since v3.1._
484      */
485     function functionCallWithValue(
486         address target,
487         bytes memory data,
488         uint256 value,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(address(this).balance >= value, "Address: insufficient balance for call");
492         require(isContract(target), "Address: call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.call{value: value}(data);
495         return _verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but performing a static call.
501      *
502      * _Available since v3.3._
503      */
504     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
505         return functionStaticCall(target, data, "Address: low-level static call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
510      * but performing a static call.
511      *
512      * _Available since v3.3._
513      */
514     function functionStaticCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal view returns (bytes memory) {
519         require(isContract(target), "Address: static call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.staticcall(data);
522         return _verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but performing a delegate call.
528      *
529      * _Available since v3.4._
530      */
531     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
532         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
537      * but performing a delegate call.
538      *
539      * _Available since v3.4._
540      */
541     function functionDelegateCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         require(isContract(target), "Address: delegate call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.delegatecall(data);
549         return _verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     function _verifyCallResult(
553         bool success,
554         bytes memory returndata,
555         string memory errorMessage
556     ) private pure returns (bytes memory) {
557         if (success) {
558             return returndata;
559         } else {
560             // Look for revert reason and bubble it up if present
561             if (returndata.length > 0) {
562                 // The easiest way to bubble the revert reason is using memory via assembly
563 
564                 assembly {
565                     let returndata_size := mload(returndata)
566                     revert(add(32, returndata), returndata_size)
567                 }
568             } else {
569                 revert(errorMessage);
570             }
571         }
572     }
573 }
574 
575 
576 // File openzeppelin-solidity/contracts/utils/introspection/ERC165.sol@v4.2.0
577 
578 
579 
580 pragma solidity ^0.8.0;
581 
582 /**
583  * @dev Implementation of the {IERC165} interface.
584  *
585  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
586  * for the additional interface id that will be supported. For example:
587  *
588  * ```solidity
589  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
590  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
591  * }
592  * ```
593  *
594  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
595  */
596 abstract contract ERC165 is IERC165 {
597     /**
598      * @dev See {IERC165-supportsInterface}.
599      */
600     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
601         return interfaceId == type(IERC165).interfaceId;
602     }
603 }
604 
605 
606 // File contracts/ERC1155.sol
607 
608 
609 
610 pragma solidity ^0.8.0;
611 /**
612  * @dev Implementation of the basic standard multi-token.
613  * See https://eips.ethereum.org/EIPS/eip-1155
614  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
615  *
616  * _Available since v3.1._
617  */
618 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
619     using Address for address;
620 
621     // Mapping from token ID to account balances
622     mapping (uint256 => mapping(address => uint256)) internal _balances;
623 
624     // Mapping from account to operator approvals
625     mapping (address => mapping(address => bool)) private _operatorApprovals;
626 
627     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
628     string private _uri;
629 
630     /**
631      * @dev See {_setURI}.
632      */
633     constructor (string memory uri_) {
634         _setURI(uri_);
635     }
636 
637     /**
638      * @dev See {IERC165-supportsInterface}.
639      */
640     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
641         return interfaceId == type(IERC1155).interfaceId
642             || interfaceId == type(IERC1155MetadataURI).interfaceId
643             || super.supportsInterface(interfaceId);
644     }
645 
646     /**
647      * @dev See {IERC1155MetadataURI-uri}.
648      *
649      * This implementation returns the same URI for *all* token types. It relies
650      * on the token type ID substitution mechanism
651      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
652      *
653      * Clients calling this function must replace the `\{id\}` substring with the
654      * actual token type ID.
655      */
656     function uri(uint256) public view virtual override returns (string memory) {
657         return _uri;
658     }
659 
660     /**
661      * @dev See {IERC1155-balanceOf}.
662      *
663      * Requirements:
664      *
665      * - `account` cannot be the zero address.
666      */
667     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
668         require(account != address(0), "ERC1155: balance query for the zero address");
669         return _balances[id][account];
670     }
671 
672     /**
673      * @dev See {IERC1155-balanceOfBatch}.
674      *
675      * Requirements:
676      *
677      * - `accounts` and `ids` must have the same length.
678      */
679     function balanceOfBatch(
680         address[] memory accounts,
681         uint256[] memory ids
682     )
683         public
684         view
685         virtual
686         override
687         returns (uint256[] memory)
688     {
689         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
690 
691         uint256[] memory batchBalances = new uint256[](accounts.length);
692 
693         for (uint256 i = 0; i < accounts.length; ++i) {
694             batchBalances[i] = balanceOf(accounts[i], ids[i]);
695         }
696 
697         return batchBalances;
698     }
699 
700     /**
701      * @dev See {IERC1155-setApprovalForAll}.
702      */
703     function setApprovalForAll(address operator, bool approved) public virtual override {
704         require(_msgSender() != operator, "ERC1155: setting approval status for self");
705 
706         _operatorApprovals[_msgSender()][operator] = approved;
707         emit ApprovalForAll(_msgSender(), operator, approved);
708     }
709 
710     /**
711      * @dev See {IERC1155-isApprovedForAll}.
712      */
713     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
714         return _operatorApprovals[account][operator];
715     }
716 
717     /**
718      * @dev See {IERC1155-safeTransferFrom}.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 id,
724         uint256 amount,
725         bytes memory data
726     )
727         public
728         virtual
729         override
730     {
731         require(
732             from == _msgSender() || isApprovedForAll(from, _msgSender()),
733             "ERC1155: caller is not owner nor approved"
734         );
735         _safeTransferFrom(from, to, id, amount, data);
736     }
737 
738     /**
739      * @dev See {IERC1155-safeBatchTransferFrom}.
740      */
741     function safeBatchTransferFrom(
742         address from,
743         address to,
744         uint256[] memory ids,
745         uint256[] memory amounts,
746         bytes memory data
747     )
748         public
749         virtual
750         override
751     {
752         require(
753             from == _msgSender() || isApprovedForAll(from, _msgSender()),
754             "ERC1155: transfer caller is not owner nor approved"
755         );
756         _safeBatchTransferFrom(from, to, ids, amounts, data);
757     }
758 
759     /**
760      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
761      *
762      * Emits a {TransferSingle} event.
763      *
764      * Requirements:
765      *
766      * - `to` cannot be the zero address.
767      * - `from` must have a balance of tokens of type `id` of at least `amount`.
768      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
769      * acceptance magic value.
770      */
771     function _safeTransferFrom(
772         address from,
773         address to,
774         uint256 id,
775         uint256 amount,
776         bytes memory data
777     )
778         internal
779         virtual
780     {
781         require(to != address(0), "ERC1155: transfer to the zero address");
782 
783         address operator = _msgSender();
784 
785         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
786 
787         uint256 fromBalance = _balances[id][from];
788         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
789         _balances[id][from] = fromBalance - amount;
790         _balances[id][to] += amount;
791 
792         emit TransferSingle(operator, from, to, id, amount);
793 
794         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
795     }
796 
797     /**
798      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
799      *
800      * Emits a {TransferBatch} event.
801      *
802      * Requirements:
803      *
804      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
805      * acceptance magic value.
806      */
807     function _safeBatchTransferFrom(
808         address from,
809         address to,
810         uint256[] memory ids,
811         uint256[] memory amounts,
812         bytes memory data
813     )
814         internal
815         virtual
816     {
817         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
818         require(to != address(0), "ERC1155: transfer to the zero address");
819 
820         address operator = _msgSender();
821 
822         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
823 
824         for (uint256 i = 0; i < ids.length; ++i) {
825             uint256 id = ids[i];
826             uint256 amount = amounts[i];
827 
828             uint256 fromBalance = _balances[id][from];
829             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
830             _balances[id][from] = fromBalance - amount;
831             _balances[id][to] += amount;
832         }
833 
834         emit TransferBatch(operator, from, to, ids, amounts);
835 
836         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
837     }
838 
839     /**
840      * @dev Sets a new URI for all token types, by relying on the token type ID
841      * substitution mechanism
842      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
843      *
844      * By this mechanism, any occurrence of the `\{id\}` substring in either the
845      * URI or any of the amounts in the JSON file at said URI will be replaced by
846      * clients with the token type ID.
847      *
848      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
849      * interpreted by clients as
850      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
851      * for token type ID 0x4cce0.
852      *
853      * See {uri}.
854      *
855      * Because these URIs cannot be meaningfully represented by the {URI} event,
856      * this function emits no events.
857      */
858     function _setURI(string memory newuri) internal virtual {
859         _uri = newuri;
860     }
861 
862     /**
863      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
864      *
865      * Emits a {TransferSingle} event.
866      *
867      * Requirements:
868      *
869      * - `account` cannot be the zero address.
870      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
871      * acceptance magic value.
872      */
873     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
874         require(account != address(0), "ERC1155: mint to the zero address");
875 
876         address operator = _msgSender();
877 
878         _balances[id][account] += amount;
879         emit TransferSingle(operator, address(0), account, id, amount);
880 
881         if (account != address(this)){
882             _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
883         }
884     }
885 
886     /**
887      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
888      *
889      * Requirements:
890      *
891      * - `ids` and `amounts` must have the same length.
892      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
893      * acceptance magic value.
894      */
895     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
896         require(to != address(0), "ERC1155: mint to the zero address");
897         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
898 
899         address operator = _msgSender();
900 
901         for (uint i = 0; i < ids.length; i++) {
902             _balances[ids[i]][to] += amounts[i];
903         }
904 
905         emit TransferBatch(operator, address(0), to, ids, amounts);
906 
907         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
908     }
909 
910     /**
911      * @dev Destroys `amount` tokens of token type `id` from `account`
912      *
913      * Requirements:
914      *
915      * - `account` cannot be the zero address.
916      * - `account` must have at least `amount` tokens of token type `id`.
917      */
918     function _burn(address account, uint256 id, uint256 amount) internal virtual {
919         require(account != address(0), "ERC1155: burn from the zero address");
920 
921         address operator = _msgSender();
922 
923         uint256 accountBalance = _balances[id][account];
924         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
925         _balances[id][account] = accountBalance - amount;
926 
927         emit TransferSingle(operator, account, address(0), id, amount);
928     }
929 
930     /**
931      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
932      *
933      * Requirements:
934      *
935      * - `ids` and `amounts` must have the same length.
936      */
937     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
938         require(account != address(0), "ERC1155: burn from the zero address");
939         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
940 
941         address operator = _msgSender();
942 
943         for (uint i = 0; i < ids.length; i++) {
944             uint256 id = ids[i];
945             uint256 amount = amounts[i];
946 
947             uint256 accountBalance = _balances[id][account];
948             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
949             _balances[id][account] = accountBalance - amount;
950         }
951 
952         emit TransferBatch(operator, account, address(0), ids, amounts);
953     }
954 
955     /**
956      * @dev Hook that is called before any token transfer. This does not include minting
957      * and burning.
958      *
959      * The same hook is called on both single and batched variants. For single
960      * transfers, the length of the `id` and `amount` arrays will be 1.
961      *
962      * Calling conditions (for each `id` and `amount` pair):
963      *
964      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
965      * of token type `id` will be  transferred to `to`.
966      * - When `from` is zero, `amount` tokens of token type `id` will be minted
967      * for `to`.
968      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
969      * will be burned.
970      * - `from` and `to` are never both zero.
971      * - `ids` and `amounts` have the same, non-zero length.
972      *
973      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
974      */
975     function _beforeTokenTransfer(
976         address operator,
977         address from,
978         address to,
979         uint256[] memory ids,
980         uint256[] memory amounts,
981         bytes memory data
982     )
983         internal
984         virtual
985     { }
986 
987     function _doSafeTransferAcceptanceCheck(
988         address operator,
989         address from,
990         address to,
991         uint256 id,
992         uint256 amount,
993         bytes memory data
994     )
995         private
996     {
997         if (to.isContract()) {
998             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
999                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1000                     revert("ERC1155: ERC1155Receiver rejected tokens");
1001                 }
1002             } catch Error(string memory reason) {
1003                 revert(reason);
1004             } catch {
1005                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1006             }
1007         }
1008     }
1009 
1010     function _doSafeBatchTransferAcceptanceCheck(
1011         address operator,
1012         address from,
1013         address to,
1014         uint256[] memory ids,
1015         uint256[] memory amounts,
1016         bytes memory data
1017     )
1018         private
1019     {
1020         if (to.isContract()) {
1021             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1022                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1023                     revert("ERC1155: ERC1155Receiver rejected tokens");
1024                 }
1025             } catch Error(string memory reason) {
1026                 revert(reason);
1027             } catch {
1028                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1029             }
1030         }
1031     }
1032 
1033     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1034         uint256[] memory array = new uint256[](1);
1035         array[0] = element;
1036 
1037         return array;
1038     }
1039 }
1040 
1041 
1042 // File contracts/TCLNFTToken.sol
1043 
1044 
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 contract TCLNFTToken is ERC1155, AbstractTCLEntity {
1050   // Token name
1051   string private _name;
1052 
1053   // Token symbol
1054   string private _symbol;
1055 
1056   /* the central instance of content */
1057   uint256 private _maxTierId;
1058 
1059   /****** NFT SECTION *******/
1060   /* nft data type enum */
1061   enum NftDataType {TEXT, IMAGE, AUDIO, VIDEO}
1062 
1063   /* nft content struct */
1064   struct NftContent {
1065     NftDataType dataType;
1066     uint256 timestamp;
1067     uint256 value;
1068     string ipfsAddress;
1069   }
1070 
1071   mapping(uint256 => NftContent) private _tierToNftContent;
1072   mapping(string => bool) private _ipfsAddressUsed;
1073 
1074   event NewNft(address creator, uint256 contentId, uint256 timestamp, NftDataType dataType, string ipfsAddress);
1075 
1076   modifier validTierId(uint256 tier) {
1077     require(tier != 0 && tier <= _maxTierId, "TCL : Provided tier is not available.");
1078     _;
1079   }
1080 
1081   constructor(string memory name_, string memory symbol_, address adminAddr) 
1082     ERC1155("")
1083   {
1084     _name = name_;
1085     _symbol = symbol_;
1086     _admin = adminAddr;
1087     _maxTierId = 3;
1088   }
1089 
1090   function name() public view returns (string memory) {
1091     return _name;
1092   }
1093 
1094   function symbol() public view returns (string memory) {
1095       return _symbol;
1096   }
1097 
1098   /***************************************************
1099     * NFTS (public/ external section)
1100     ***************************************************/
1101 
1102   /**
1103     * Mint new content as NFT.
1104     */
1105   function createContent(uint tier, string memory ipfsAddress, NftDataType dataType, uint amount) external onlyOwnerOrAdmin {
1106     require(!_ipfsAddressUsed[ipfsAddress], "TCL: IPFS Address has already been used by this collection.");
1107     /* mint the NFT */
1108     NftContent memory content = NftContent({
1109                                     dataType: dataType,
1110                                     timestamp: block.timestamp,
1111                                     value: 0,
1112                                     ipfsAddress: ipfsAddress
1113                                 });
1114 
1115     _mint(address(this), tier, amount, "");
1116     _tierToNftContent[tier] = content;
1117     _ipfsAddressUsed[ipfsAddress] = true;
1118 
1119     emit NewNft(address(this), tier, block.timestamp, dataType, ipfsAddress);
1120   }
1121 
1122   /* get tier ount and is just amount of content NFTs. */
1123   function tierCount() external view returns (uint256){
1124     return _maxTierId;
1125   }
1126 
1127   /* Get content data of the provided tier */
1128   function getContent(uint256 tier) external view validTierId(tier) returns (NftDataType, uint256, uint256, string memory) {
1129     NftContent memory content = _tierToNftContent[tier];
1130     return (content.dataType, content.timestamp, content.value, content.ipfsAddress);
1131   }
1132 
1133   /* claim NFT by tier */
1134   function claim(uint tier) public payable validTierId(tier) {
1135     require(balanceOf(_msgSender(), tier) < 1, "You already had claimed!");
1136     require(balanceOf(address(this), tier) > 0, "Out of NFT stock!");
1137     _safeTransferFrom(address(this), _msgSender(), tier, 1, "");
1138   }
1139 }