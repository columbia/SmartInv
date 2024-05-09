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
111 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
112 
113 pragma solidity ^0.8.1;
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
135      *
136      * [IMPORTANT]
137      * ====
138      * You shouldn't rely on `isContract` to protect against flash loan attacks!
139      *
140      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
141      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
142      * constructor.
143      * ====
144      */
145     function isContract(address account) internal view returns (bool) {
146         // This method relies on extcodesize/address.code.length, which returns 0
147         // for contracts in construction, since the code is only stored at the end
148         // of the constructor execution.
149 
150         return account.code.length > 0;
151     }
152 
153     /**
154      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
155      * `recipient`, forwarding all available gas and reverting on errors.
156      *
157      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
158      * of certain opcodes, possibly making contracts go over the 2300 gas limit
159      * imposed by `transfer`, making them unable to receive funds via
160      * `transfer`. {sendValue} removes this limitation.
161      *
162      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
163      *
164      * IMPORTANT: because control is transferred to `recipient`, care must be
165      * taken to not create reentrancy vulnerabilities. Consider using
166      * {ReentrancyGuard} or the
167      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
168      */
169     function sendValue(address payable recipient, uint256 amount) internal {
170         require(address(this).balance >= amount, "Address: insufficient balance");
171 
172         (bool success, ) = recipient.call{value: amount}("");
173         require(success, "Address: unable to send value, recipient may have reverted");
174     }
175 
176     /**
177      * @dev Performs a Solidity function call using a low level `call`. A
178      * plain `call` is an unsafe replacement for a function call: use this
179      * function instead.
180      *
181      * If `target` reverts with a revert reason, it is bubbled up by this
182      * function (like regular Solidity function calls).
183      *
184      * Returns the raw returned data. To convert to the expected return value,
185      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
186      *
187      * Requirements:
188      *
189      * - `target` must be a contract.
190      * - calling `target` with `data` must not revert.
191      *
192      * _Available since v3.1._
193      */
194     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionCall(target, data, "Address: low-level call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
200      * `errorMessage` as a fallback revert reason when `target` reverts.
201      *
202      * _Available since v3.1._
203      */
204     function functionCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         return functionCallWithValue(target, data, 0, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but also transferring `value` wei to `target`.
215      *
216      * Requirements:
217      *
218      * - the calling contract must have an ETH balance of at least `value`.
219      * - the called Solidity function must be `payable`.
220      *
221      * _Available since v3.1._
222      */
223     function functionCallWithValue(
224         address target,
225         bytes memory data,
226         uint256 value
227     ) internal returns (bytes memory) {
228         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
233      * with `errorMessage` as a fallback revert reason when `target` reverts.
234      *
235      * _Available since v3.1._
236      */
237     function functionCallWithValue(
238         address target,
239         bytes memory data,
240         uint256 value,
241         string memory errorMessage
242     ) internal returns (bytes memory) {
243         require(address(this).balance >= value, "Address: insufficient balance for call");
244         require(isContract(target), "Address: call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.call{value: value}(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but performing a static call.
253      *
254      * _Available since v3.3._
255      */
256     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
257         return functionStaticCall(target, data, "Address: low-level static call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262      * but performing a static call.
263      *
264      * _Available since v3.3._
265      */
266     function functionStaticCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal view returns (bytes memory) {
271         require(isContract(target), "Address: static call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.staticcall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
279      * but performing a delegate call.
280      *
281      * _Available since v3.4._
282      */
283     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
289      * but performing a delegate call.
290      *
291      * _Available since v3.4._
292      */
293     function functionDelegateCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         require(isContract(target), "Address: delegate call to non-contract");
299 
300         (bool success, bytes memory returndata) = target.delegatecall(data);
301         return verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
306      * revert reason using the provided one.
307      *
308      * _Available since v4.3._
309      */
310     function verifyCallResult(
311         bool success,
312         bytes memory returndata,
313         string memory errorMessage
314     ) internal pure returns (bytes memory) {
315         if (success) {
316             return returndata;
317         } else {
318             // Look for revert reason and bubble it up if present
319             if (returndata.length > 0) {
320                 // The easiest way to bubble the revert reason is using memory via assembly
321 
322                 assembly {
323                     let returndata_size := mload(returndata)
324                     revert(add(32, returndata), returndata_size)
325                 }
326             } else {
327                 revert(errorMessage);
328             }
329         }
330     }
331 }
332 
333 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @dev Interface of the ERC165 standard, as defined in the
342  * https://eips.ethereum.org/EIPS/eip-165[EIP].
343  *
344  * Implementers can declare support of contract interfaces, which can then be
345  * queried by others ({ERC165Checker}).
346  *
347  * For an implementation, see {ERC165}.
348  */
349 interface IERC165 {
350     /**
351      * @dev Returns true if this contract implements the interface defined by
352      * `interfaceId`. See the corresponding
353      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
354      * to learn more about how these ids are created.
355      *
356      * This function call must use less than 30 000 gas.
357      */
358     function supportsInterface(bytes4 interfaceId) external view returns (bool);
359 }
360 
361 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 
369 /**
370  * @dev Implementation of the {IERC165} interface.
371  *
372  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
373  * for the additional interface id that will be supported. For example:
374  *
375  * ```solidity
376  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
378  * }
379  * ```
380  *
381  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
382  */
383 abstract contract ERC165 is IERC165 {
384     /**
385      * @dev See {IERC165-supportsInterface}.
386      */
387     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
388         return interfaceId == type(IERC165).interfaceId;
389     }
390 }
391 
392 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
393 
394 
395 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 /**
401  * @dev _Available since v3.1._
402  */
403 interface IERC1155Receiver is IERC165 {
404     /**
405      * @dev Handles the receipt of a single ERC1155 token type. This function is
406      * called at the end of a `safeTransferFrom` after the balance has been updated.
407      *
408      * NOTE: To accept the transfer, this must return
409      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
410      * (i.e. 0xf23a6e61, or its own function selector).
411      *
412      * @param operator The address which initiated the transfer (i.e. msg.sender)
413      * @param from The address which previously owned the token
414      * @param id The ID of the token being transferred
415      * @param value The amount of tokens being transferred
416      * @param data Additional data with no specified format
417      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
418      */
419     function onERC1155Received(
420         address operator,
421         address from,
422         uint256 id,
423         uint256 value,
424         bytes calldata data
425     ) external returns (bytes4);
426 
427     /**
428      * @dev Handles the receipt of a multiple ERC1155 token types. This function
429      * is called at the end of a `safeBatchTransferFrom` after the balances have
430      * been updated.
431      *
432      * NOTE: To accept the transfer(s), this must return
433      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
434      * (i.e. 0xbc197c81, or its own function selector).
435      *
436      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
437      * @param from The address which previously owned the token
438      * @param ids An array containing ids of each token being transferred (order and length must match values array)
439      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
440      * @param data Additional data with no specified format
441      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
442      */
443     function onERC1155BatchReceived(
444         address operator,
445         address from,
446         uint256[] calldata ids,
447         uint256[] calldata values,
448         bytes calldata data
449     ) external returns (bytes4);
450 }
451 
452 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 
460 /**
461  * @dev Required interface of an ERC1155 compliant contract, as defined in the
462  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
463  *
464  * _Available since v3.1._
465  */
466 interface IERC1155 is IERC165 {
467     /**
468      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
469      */
470     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
471 
472     /**
473      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
474      * transfers.
475      */
476     event TransferBatch(
477         address indexed operator,
478         address indexed from,
479         address indexed to,
480         uint256[] ids,
481         uint256[] values
482     );
483 
484     /**
485      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
486      * `approved`.
487      */
488     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
489 
490     /**
491      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
492      *
493      * If an {URI} event was emitted for `id`, the standard
494      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
495      * returned by {IERC1155MetadataURI-uri}.
496      */
497     event URI(string value, uint256 indexed id);
498 
499     /**
500      * @dev Returns the amount of tokens of token type `id` owned by `account`.
501      *
502      * Requirements:
503      *
504      * - `account` cannot be the zero address.
505      */
506     function balanceOf(address account, uint256 id) external view returns (uint256);
507 
508     /**
509      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
510      *
511      * Requirements:
512      *
513      * - `accounts` and `ids` must have the same length.
514      */
515     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
516         external
517         view
518         returns (uint256[] memory);
519 
520     /**
521      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
522      *
523      * Emits an {ApprovalForAll} event.
524      *
525      * Requirements:
526      *
527      * - `operator` cannot be the caller.
528      */
529     function setApprovalForAll(address operator, bool approved) external;
530 
531     /**
532      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
533      *
534      * See {setApprovalForAll}.
535      */
536     function isApprovedForAll(address account, address operator) external view returns (bool);
537 
538     /**
539      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
540      *
541      * Emits a {TransferSingle} event.
542      *
543      * Requirements:
544      *
545      * - `to` cannot be the zero address.
546      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
547      * - `from` must have a balance of tokens of type `id` of at least `amount`.
548      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
549      * acceptance magic value.
550      */
551     function safeTransferFrom(
552         address from,
553         address to,
554         uint256 id,
555         uint256 amount,
556         bytes calldata data
557     ) external;
558 
559     /**
560      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
561      *
562      * Emits a {TransferBatch} event.
563      *
564      * Requirements:
565      *
566      * - `ids` and `amounts` must have the same length.
567      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
568      * acceptance magic value.
569      */
570     function safeBatchTransferFrom(
571         address from,
572         address to,
573         uint256[] calldata ids,
574         uint256[] calldata amounts,
575         bytes calldata data
576     ) external;
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
580 
581 
582 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
589  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
590  *
591  * _Available since v3.1._
592  */
593 interface IERC1155MetadataURI is IERC1155 {
594     /**
595      * @dev Returns the URI for token type `id`.
596      *
597      * If the `\{id\}` substring is present in the URI, it must be replaced by
598      * clients with the actual token type ID.
599      */
600     function uri(uint256 id) external view returns (string memory);
601 }
602 
603 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
604 
605 
606 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 
611 
612 
613 
614 
615 
616 /**
617  * @dev Implementation of the basic standard multi-token.
618  * See https://eips.ethereum.org/EIPS/eip-1155
619  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
620  *
621  * _Available since v3.1._
622  */
623 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
624     using Address for address;
625 
626     // Mapping from token ID to account balances
627     mapping(uint256 => mapping(address => uint256)) private _balances;
628 
629     // Mapping from account to operator approvals
630     mapping(address => mapping(address => bool)) private _operatorApprovals;
631 
632     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
633     string private _uri;
634 
635     /**
636      * @dev See {_setURI}.
637      */
638     constructor(string memory uri_) {
639         _setURI(uri_);
640     }
641 
642     /**
643      * @dev See {IERC165-supportsInterface}.
644      */
645     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
646         return
647             interfaceId == type(IERC1155).interfaceId ||
648             interfaceId == type(IERC1155MetadataURI).interfaceId ||
649             super.supportsInterface(interfaceId);
650     }
651 
652     /**
653      * @dev See {IERC1155MetadataURI-uri}.
654      *
655      * This implementation returns the same URI for *all* token types. It relies
656      * on the token type ID substitution mechanism
657      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
658      *
659      * Clients calling this function must replace the `\{id\}` substring with the
660      * actual token type ID.
661      */
662     function uri(uint256) public view virtual override returns (string memory) {
663         return _uri;
664     }
665 
666     /**
667      * @dev See {IERC1155-balanceOf}.
668      *
669      * Requirements:
670      *
671      * - `account` cannot be the zero address.
672      */
673     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
674         require(account != address(0), "ERC1155: balance query for the zero address");
675         return _balances[id][account];
676     }
677 
678     /**
679      * @dev See {IERC1155-balanceOfBatch}.
680      *
681      * Requirements:
682      *
683      * - `accounts` and `ids` must have the same length.
684      */
685     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
686         public
687         view
688         virtual
689         override
690         returns (uint256[] memory)
691     {
692         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
693 
694         uint256[] memory batchBalances = new uint256[](accounts.length);
695 
696         for (uint256 i = 0; i < accounts.length; ++i) {
697             batchBalances[i] = balanceOf(accounts[i], ids[i]);
698         }
699 
700         return batchBalances;
701     }
702 
703     /**
704      * @dev See {IERC1155-setApprovalForAll}.
705      */
706     function setApprovalForAll(address operator, bool approved) public virtual override {
707         _setApprovalForAll(_msgSender(), operator, approved);
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
726     ) public virtual override {
727         require(
728             from == _msgSender() || isApprovedForAll(from, _msgSender()),
729             "ERC1155: caller is not owner nor approved"
730         );
731         _safeTransferFrom(from, to, id, amount, data);
732     }
733 
734     /**
735      * @dev See {IERC1155-safeBatchTransferFrom}.
736      */
737     function safeBatchTransferFrom(
738         address from,
739         address to,
740         uint256[] memory ids,
741         uint256[] memory amounts,
742         bytes memory data
743     ) public virtual override {
744         require(
745             from == _msgSender() || isApprovedForAll(from, _msgSender()),
746             "ERC1155: transfer caller is not owner nor approved"
747         );
748         _safeBatchTransferFrom(from, to, ids, amounts, data);
749     }
750 
751     /**
752      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
753      *
754      * Emits a {TransferSingle} event.
755      *
756      * Requirements:
757      *
758      * - `to` cannot be the zero address.
759      * - `from` must have a balance of tokens of type `id` of at least `amount`.
760      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
761      * acceptance magic value.
762      */
763     function _safeTransferFrom(
764         address from,
765         address to,
766         uint256 id,
767         uint256 amount,
768         bytes memory data
769     ) internal virtual {
770         require(to != address(0), "ERC1155: transfer to the zero address");
771 
772         address operator = _msgSender();
773 
774         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
775 
776         uint256 fromBalance = _balances[id][from];
777         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
778         unchecked {
779             _balances[id][from] = fromBalance - amount;
780         }
781         _balances[id][to] += amount;
782 
783         emit TransferSingle(operator, from, to, id, amount);
784 
785         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
786     }
787 
788     /**
789      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
790      *
791      * Emits a {TransferBatch} event.
792      *
793      * Requirements:
794      *
795      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
796      * acceptance magic value.
797      */
798     function _safeBatchTransferFrom(
799         address from,
800         address to,
801         uint256[] memory ids,
802         uint256[] memory amounts,
803         bytes memory data
804     ) internal virtual {
805         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
806         require(to != address(0), "ERC1155: transfer to the zero address");
807 
808         address operator = _msgSender();
809 
810         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
811 
812         for (uint256 i = 0; i < ids.length; ++i) {
813             uint256 id = ids[i];
814             uint256 amount = amounts[i];
815 
816             uint256 fromBalance = _balances[id][from];
817             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
818             unchecked {
819                 _balances[id][from] = fromBalance - amount;
820             }
821             _balances[id][to] += amount;
822         }
823 
824         emit TransferBatch(operator, from, to, ids, amounts);
825 
826         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
827     }
828 
829     /**
830      * @dev Sets a new URI for all token types, by relying on the token type ID
831      * substitution mechanism
832      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
833      *
834      * By this mechanism, any occurrence of the `\{id\}` substring in either the
835      * URI or any of the amounts in the JSON file at said URI will be replaced by
836      * clients with the token type ID.
837      *
838      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
839      * interpreted by clients as
840      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
841      * for token type ID 0x4cce0.
842      *
843      * See {uri}.
844      *
845      * Because these URIs cannot be meaningfully represented by the {URI} event,
846      * this function emits no events.
847      */
848     function _setURI(string memory newuri) internal virtual {
849         _uri = newuri;
850     }
851 
852     /**
853      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
854      *
855      * Emits a {TransferSingle} event.
856      *
857      * Requirements:
858      *
859      * - `to` cannot be the zero address.
860      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
861      * acceptance magic value.
862      */
863     function _mint(
864         address to,
865         uint256 id,
866         uint256 amount,
867         bytes memory data
868     ) internal virtual {
869         require(to != address(0), "ERC1155: mint to the zero address");
870 
871         address operator = _msgSender();
872 
873         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
874 
875         _balances[id][to] += amount;
876         emit TransferSingle(operator, address(0), to, id, amount);
877 
878         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
879     }
880 
881     /**
882      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
883      *
884      * Requirements:
885      *
886      * - `ids` and `amounts` must have the same length.
887      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
888      * acceptance magic value.
889      */
890     function _mintBatch(
891         address to,
892         uint256[] memory ids,
893         uint256[] memory amounts,
894         bytes memory data
895     ) internal virtual {
896         require(to != address(0), "ERC1155: mint to the zero address");
897         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
898 
899         address operator = _msgSender();
900 
901         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
902 
903         for (uint256 i = 0; i < ids.length; i++) {
904             _balances[ids[i]][to] += amounts[i];
905         }
906 
907         emit TransferBatch(operator, address(0), to, ids, amounts);
908 
909         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
910     }
911 
912     /**
913      * @dev Destroys `amount` tokens of token type `id` from `from`
914      *
915      * Requirements:
916      *
917      * - `from` cannot be the zero address.
918      * - `from` must have at least `amount` tokens of token type `id`.
919      */
920     function _burn(
921         address from,
922         uint256 id,
923         uint256 amount
924     ) internal virtual {
925         require(from != address(0), "ERC1155: burn from the zero address");
926 
927         address operator = _msgSender();
928 
929         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
930 
931         uint256 fromBalance = _balances[id][from];
932         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
933         unchecked {
934             _balances[id][from] = fromBalance - amount;
935         }
936 
937         emit TransferSingle(operator, from, address(0), id, amount);
938     }
939 
940     /**
941      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
942      *
943      * Requirements:
944      *
945      * - `ids` and `amounts` must have the same length.
946      */
947     function _burnBatch(
948         address from,
949         uint256[] memory ids,
950         uint256[] memory amounts
951     ) internal virtual {
952         require(from != address(0), "ERC1155: burn from the zero address");
953         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
954 
955         address operator = _msgSender();
956 
957         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
958 
959         for (uint256 i = 0; i < ids.length; i++) {
960             uint256 id = ids[i];
961             uint256 amount = amounts[i];
962 
963             uint256 fromBalance = _balances[id][from];
964             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
965             unchecked {
966                 _balances[id][from] = fromBalance - amount;
967             }
968         }
969 
970         emit TransferBatch(operator, from, address(0), ids, amounts);
971     }
972 
973     /**
974      * @dev Approve `operator` to operate on all of `owner` tokens
975      *
976      * Emits a {ApprovalForAll} event.
977      */
978     function _setApprovalForAll(
979         address owner,
980         address operator,
981         bool approved
982     ) internal virtual {
983         require(owner != operator, "ERC1155: setting approval status for self");
984         _operatorApprovals[owner][operator] = approved;
985         emit ApprovalForAll(owner, operator, approved);
986     }
987 
988     /**
989      * @dev Hook that is called before any token transfer. This includes minting
990      * and burning, as well as batched variants.
991      *
992      * The same hook is called on both single and batched variants. For single
993      * transfers, the length of the `id` and `amount` arrays will be 1.
994      *
995      * Calling conditions (for each `id` and `amount` pair):
996      *
997      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
998      * of token type `id` will be  transferred to `to`.
999      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1000      * for `to`.
1001      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1002      * will be burned.
1003      * - `from` and `to` are never both zero.
1004      * - `ids` and `amounts` have the same, non-zero length.
1005      *
1006      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1007      */
1008     function _beforeTokenTransfer(
1009         address operator,
1010         address from,
1011         address to,
1012         uint256[] memory ids,
1013         uint256[] memory amounts,
1014         bytes memory data
1015     ) internal virtual {}
1016 
1017     function _doSafeTransferAcceptanceCheck(
1018         address operator,
1019         address from,
1020         address to,
1021         uint256 id,
1022         uint256 amount,
1023         bytes memory data
1024     ) private {
1025         if (to.isContract()) {
1026             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1027                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1028                     revert("ERC1155: ERC1155Receiver rejected tokens");
1029                 }
1030             } catch Error(string memory reason) {
1031                 revert(reason);
1032             } catch {
1033                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1034             }
1035         }
1036     }
1037 
1038     function _doSafeBatchTransferAcceptanceCheck(
1039         address operator,
1040         address from,
1041         address to,
1042         uint256[] memory ids,
1043         uint256[] memory amounts,
1044         bytes memory data
1045     ) private {
1046         if (to.isContract()) {
1047             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1048                 bytes4 response
1049             ) {
1050                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1051                     revert("ERC1155: ERC1155Receiver rejected tokens");
1052                 }
1053             } catch Error(string memory reason) {
1054                 revert(reason);
1055             } catch {
1056                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1057             }
1058         }
1059     }
1060 
1061     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1062         uint256[] memory array = new uint256[](1);
1063         array[0] = element;
1064 
1065         return array;
1066     }
1067 }
1068 
1069 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1070 
1071 
1072 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1073 
1074 pragma solidity ^0.8.0;
1075 
1076 
1077 /**
1078  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1079  *
1080  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1081  * clearly identified. Note: While a totalSupply of 1 might mean the
1082  * corresponding is an NFT, there is no guarantees that no other token with the
1083  * same id are not going to be minted.
1084  */
1085 abstract contract ERC1155Supply is ERC1155 {
1086     mapping(uint256 => uint256) private _totalSupply;
1087 
1088     /**
1089      * @dev Total amount of tokens in with a given id.
1090      */
1091     function totalSupply(uint256 id) public view virtual returns (uint256) {
1092         return _totalSupply[id];
1093     }
1094 
1095     /**
1096      * @dev Indicates whether any token exist with a given id, or not.
1097      */
1098     function exists(uint256 id) public view virtual returns (bool) {
1099         return ERC1155Supply.totalSupply(id) > 0;
1100     }
1101 
1102     /**
1103      * @dev See {ERC1155-_beforeTokenTransfer}.
1104      */
1105     function _beforeTokenTransfer(
1106         address operator,
1107         address from,
1108         address to,
1109         uint256[] memory ids,
1110         uint256[] memory amounts,
1111         bytes memory data
1112     ) internal virtual override {
1113         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1114 
1115         if (from == address(0)) {
1116             for (uint256 i = 0; i < ids.length; ++i) {
1117                 _totalSupply[ids[i]] += amounts[i];
1118             }
1119         }
1120 
1121         if (to == address(0)) {
1122             for (uint256 i = 0; i < ids.length; ++i) {
1123                 _totalSupply[ids[i]] -= amounts[i];
1124             }
1125         }
1126     }
1127 }
1128 
1129 // File: @openzeppelin/contracts/utils/Strings.sol
1130 
1131 
1132 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1133 
1134 pragma solidity ^0.8.0;
1135 
1136 /**
1137  * @dev String operations.
1138  */
1139 library Strings {
1140     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1141 
1142     /**
1143      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1144      */
1145     function toString(uint256 value) internal pure returns (string memory) {
1146         // Inspired by OraclizeAPI's implementation - MIT licence
1147         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1148 
1149         if (value == 0) {
1150             return "0";
1151         }
1152         uint256 temp = value;
1153         uint256 digits;
1154         while (temp != 0) {
1155             digits++;
1156             temp /= 10;
1157         }
1158         bytes memory buffer = new bytes(digits);
1159         while (value != 0) {
1160             digits -= 1;
1161             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1162             value /= 10;
1163         }
1164         return string(buffer);
1165     }
1166 
1167     /**
1168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1169      */
1170     function toHexString(uint256 value) internal pure returns (string memory) {
1171         if (value == 0) {
1172             return "0x00";
1173         }
1174         uint256 temp = value;
1175         uint256 length = 0;
1176         while (temp != 0) {
1177             length++;
1178             temp >>= 8;
1179         }
1180         return toHexString(value, length);
1181     }
1182 
1183     /**
1184      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1185      */
1186     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1187         bytes memory buffer = new bytes(2 * length + 2);
1188         buffer[0] = "0";
1189         buffer[1] = "x";
1190         for (uint256 i = 2 * length + 1; i > 1; --i) {
1191             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1192             value >>= 4;
1193         }
1194         require(value == 0, "Strings: hex length insufficient");
1195         return string(buffer);
1196     }
1197 }
1198 
1199 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1200 
1201 
1202 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 
1207 /**
1208  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1209  *
1210  * These functions can be used to verify that a message was signed by the holder
1211  * of the private keys of a given address.
1212  */
1213 library ECDSA {
1214     enum RecoverError {
1215         NoError,
1216         InvalidSignature,
1217         InvalidSignatureLength,
1218         InvalidSignatureS,
1219         InvalidSignatureV
1220     }
1221 
1222     function _throwError(RecoverError error) private pure {
1223         if (error == RecoverError.NoError) {
1224             return; // no error: do nothing
1225         } else if (error == RecoverError.InvalidSignature) {
1226             revert("ECDSA: invalid signature");
1227         } else if (error == RecoverError.InvalidSignatureLength) {
1228             revert("ECDSA: invalid signature length");
1229         } else if (error == RecoverError.InvalidSignatureS) {
1230             revert("ECDSA: invalid signature 's' value");
1231         } else if (error == RecoverError.InvalidSignatureV) {
1232             revert("ECDSA: invalid signature 'v' value");
1233         }
1234     }
1235 
1236     /**
1237      * @dev Returns the address that signed a hashed message (`hash`) with
1238      * `signature` or error string. This address can then be used for verification purposes.
1239      *
1240      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1241      * this function rejects them by requiring the `s` value to be in the lower
1242      * half order, and the `v` value to be either 27 or 28.
1243      *
1244      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1245      * verification to be secure: it is possible to craft signatures that
1246      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1247      * this is by receiving a hash of the original message (which may otherwise
1248      * be too long), and then calling {toEthSignedMessageHash} on it.
1249      *
1250      * Documentation for signature generation:
1251      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1252      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1253      *
1254      * _Available since v4.3._
1255      */
1256     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1257         // Check the signature length
1258         // - case 65: r,s,v signature (standard)
1259         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1260         if (signature.length == 65) {
1261             bytes32 r;
1262             bytes32 s;
1263             uint8 v;
1264             // ecrecover takes the signature parameters, and the only way to get them
1265             // currently is to use assembly.
1266             assembly {
1267                 r := mload(add(signature, 0x20))
1268                 s := mload(add(signature, 0x40))
1269                 v := byte(0, mload(add(signature, 0x60)))
1270             }
1271             return tryRecover(hash, v, r, s);
1272         } else if (signature.length == 64) {
1273             bytes32 r;
1274             bytes32 vs;
1275             // ecrecover takes the signature parameters, and the only way to get them
1276             // currently is to use assembly.
1277             assembly {
1278                 r := mload(add(signature, 0x20))
1279                 vs := mload(add(signature, 0x40))
1280             }
1281             return tryRecover(hash, r, vs);
1282         } else {
1283             return (address(0), RecoverError.InvalidSignatureLength);
1284         }
1285     }
1286 
1287     /**
1288      * @dev Returns the address that signed a hashed message (`hash`) with
1289      * `signature`. This address can then be used for verification purposes.
1290      *
1291      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1292      * this function rejects them by requiring the `s` value to be in the lower
1293      * half order, and the `v` value to be either 27 or 28.
1294      *
1295      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1296      * verification to be secure: it is possible to craft signatures that
1297      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1298      * this is by receiving a hash of the original message (which may otherwise
1299      * be too long), and then calling {toEthSignedMessageHash} on it.
1300      */
1301     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1302         (address recovered, RecoverError error) = tryRecover(hash, signature);
1303         _throwError(error);
1304         return recovered;
1305     }
1306 
1307     /**
1308      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1309      *
1310      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1311      *
1312      * _Available since v4.3._
1313      */
1314     function tryRecover(
1315         bytes32 hash,
1316         bytes32 r,
1317         bytes32 vs
1318     ) internal pure returns (address, RecoverError) {
1319         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1320         uint8 v = uint8((uint256(vs) >> 255) + 27);
1321         return tryRecover(hash, v, r, s);
1322     }
1323 
1324     /**
1325      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1326      *
1327      * _Available since v4.2._
1328      */
1329     function recover(
1330         bytes32 hash,
1331         bytes32 r,
1332         bytes32 vs
1333     ) internal pure returns (address) {
1334         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1335         _throwError(error);
1336         return recovered;
1337     }
1338 
1339     /**
1340      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1341      * `r` and `s` signature fields separately.
1342      *
1343      * _Available since v4.3._
1344      */
1345     function tryRecover(
1346         bytes32 hash,
1347         uint8 v,
1348         bytes32 r,
1349         bytes32 s
1350     ) internal pure returns (address, RecoverError) {
1351         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1352         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1353         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1354         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1355         //
1356         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1357         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1358         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1359         // these malleable signatures as well.
1360         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1361             return (address(0), RecoverError.InvalidSignatureS);
1362         }
1363         if (v != 27 && v != 28) {
1364             return (address(0), RecoverError.InvalidSignatureV);
1365         }
1366 
1367         // If the signature is valid (and not malleable), return the signer address
1368         address signer = ecrecover(hash, v, r, s);
1369         if (signer == address(0)) {
1370             return (address(0), RecoverError.InvalidSignature);
1371         }
1372 
1373         return (signer, RecoverError.NoError);
1374     }
1375 
1376     /**
1377      * @dev Overload of {ECDSA-recover} that receives the `v`,
1378      * `r` and `s` signature fields separately.
1379      */
1380     function recover(
1381         bytes32 hash,
1382         uint8 v,
1383         bytes32 r,
1384         bytes32 s
1385     ) internal pure returns (address) {
1386         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1387         _throwError(error);
1388         return recovered;
1389     }
1390 
1391     /**
1392      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1393      * produces hash corresponding to the one signed with the
1394      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1395      * JSON-RPC method as part of EIP-191.
1396      *
1397      * See {recover}.
1398      */
1399     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1400         // 32 is the length in bytes of hash,
1401         // enforced by the type signature above
1402         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1403     }
1404 
1405     /**
1406      * @dev Returns an Ethereum Signed Message, created from `s`. This
1407      * produces hash corresponding to the one signed with the
1408      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1409      * JSON-RPC method as part of EIP-191.
1410      *
1411      * See {recover}.
1412      */
1413     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1414         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1415     }
1416 
1417     /**
1418      * @dev Returns an Ethereum Signed Typed Data, created from a
1419      * `domainSeparator` and a `structHash`. This produces hash corresponding
1420      * to the one signed with the
1421      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1422      * JSON-RPC method as part of EIP-712.
1423      *
1424      * See {recover}.
1425      */
1426     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1427         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1428     }
1429 }
1430 
1431 // File: contracts/bears_club_contract.sol
1432 
1433 
1434 pragma solidity ^0.8.0;
1435 
1436 
1437 
1438 
1439 
1440 contract BearsClubByKickOnFire is ERC1155, ERC1155Supply, Ownable {
1441 
1442     string public name = "Bears Club By KicksOnFire";
1443 
1444     uint256 public constant DUNK_CHAMP_BEAR = 1;
1445     uint256 public constant CHAMPIONSHIP_BEAR = 2;
1446     uint256 public constant CHOKE_BEAR = 3;
1447     uint256 public constant CELEBRATION_BEAR = 4;
1448     uint256 public constant STEP_OVER_BEAR = 5;
1449 
1450     uint256 private _price = 0.3 ether;
1451     uint256 private _max_mint_amount = 5;
1452     uint256 private INITIAL_MAX_SUPPLY = 1111;
1453 
1454     mapping(uint256 => uint256) private _maxSupply;
1455     uint256[] private _collections;
1456 
1457     address private signer;
1458 
1459     constructor() ERC1155("https://bearsclubkof.mypinata.cloud/ipfs/QmfE6NMKCBcJMrcP5zqmCx99aLDD9qcd4J3H6ctwVt99c4/{id}.json") {
1460         addToken(DUNK_CHAMP_BEAR, INITIAL_MAX_SUPPLY);
1461         addToken(CHAMPIONSHIP_BEAR, INITIAL_MAX_SUPPLY);
1462         addToken(CHOKE_BEAR, INITIAL_MAX_SUPPLY);
1463         addToken(CELEBRATION_BEAR, INITIAL_MAX_SUPPLY);
1464         addToken(STEP_OVER_BEAR, INITIAL_MAX_SUPPLY);
1465     }
1466 
1467     function mintKicksOnFireBears(uint256[] memory ids, uint256[] memory amounts) public payable {
1468         
1469         uint256 value = msg.value;
1470         uint256 totalAmount = 0;
1471 
1472         //validate the ids
1473         for (uint256 i = 0; i < ids.length; i++) {
1474            _validateToken(ids[i]);
1475         }
1476 
1477         for (uint256 i = 0; i < ids.length; ++i) {
1478             totalAmount = totalAmount + amounts[i];
1479         }
1480 
1481         require(totalAmount > 0, "You cannot mint 0 bears");
1482 
1483         uint256 totalPrice = _price * totalAmount;
1484 
1485         require(totalAmount <= _max_mint_amount,string(abi.encodePacked("You may only mint up to ", _uint2str(_max_mint_amount), " per transaction")));
1486         require(value == totalPrice, "Amount of Ether sent is not correct");
1487 
1488         for (uint256 i = 0; i < ids.length; ++i) {
1489             uint256 id = ids[i];
1490             uint256 amount = amounts[i];
1491             _mint(msg.sender, id, amount, "");
1492         }
1493     }
1494 
1495     function addToken(uint256 id, uint256 maxSupply) onlyOwner public {
1496         _collections.push(id);
1497         _setMaxSupply(id, maxSupply);
1498     }
1499 
1500     function removeToken(uint index) onlyOwner public {
1501         require(index < _collections.length);
1502         uint256 id = _collections[index];
1503         _collections[index] = _collections[_collections.length-1];
1504         _collections.pop();
1505         _removeMaxSupply(id);
1506     }
1507 
1508     function getTokens() public view returns(uint256[] memory) {
1509         return _collections;
1510     }
1511 
1512     function withdraw(address account) external onlyOwner {
1513         uint256 balance = address(this).balance;
1514         Address.sendValue(payable(account), balance);
1515     }
1516 
1517     function setURI(string memory newUri) onlyOwner public {
1518         _setURI(newUri);
1519     }
1520 
1521     function setPrice(uint256 price) onlyOwner public {
1522         _price = price;
1523     }
1524 
1525     function setMaxMintAmount(uint256 maxMintAmount) onlyOwner public {
1526         _max_mint_amount = maxMintAmount;
1527     }
1528 
1529     function getMaxSupply(uint256 id) public view returns(uint256) {
1530         return _maxSupply[id];
1531     }
1532 
1533     function burn(address account, uint256 id, uint256 amount) public {
1534         require(msg.sender == account);
1535         _burn(account, id, amount);
1536     }
1537 
1538     function _setMaxSupply(uint256 id, uint256 amount) internal {
1539         _maxSupply[id] = amount;
1540     }
1541 
1542     function _removeMaxSupply(uint256 id) internal {
1543         delete _maxSupply[id];
1544     }
1545 
1546     function _validateToken(uint256 id) internal view {
1547         bool contain = false;
1548     
1549         for (uint i=0; i < _collections.length; i++) {
1550             if (id == _collections[i]) {
1551                 contain = true;
1552             }
1553         }
1554         
1555         require(contain, "Invalid token id");
1556     }
1557 
1558     function _mint(
1559         address account,
1560         uint256 id,
1561         uint256 amount,
1562         bytes memory data
1563     ) internal virtual override {
1564         require(totalSupply(id) < _maxSupply[id], "Exceeds maximum supply");
1565         super._mint(account, id, amount, data);
1566     }
1567 
1568     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1569         internal
1570         override(ERC1155, ERC1155Supply)
1571     {
1572         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1573     }
1574 
1575     function _uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1576         if (_i == 0) {
1577             return "0";
1578         }
1579         uint j = _i;
1580         uint len;
1581         while (j != 0) {
1582             len++;
1583             j /= 10;
1584         }
1585         bytes memory bstr = new bytes(len);
1586         uint k = len;
1587         while (_i != 0) {
1588             k = k-1;
1589             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1590             bytes1 b1 = bytes1(temp);
1591             bstr[k] = b1;
1592             _i /= 10;
1593         }
1594         return string(bstr);
1595     }
1596 
1597 }