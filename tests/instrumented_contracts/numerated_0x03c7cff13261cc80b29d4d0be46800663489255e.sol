1 /*                  
2   _    _  ____  _  __     __  _____  ______ _______ _____ 
3  | |  | |/ __ \| | \ \   / / |  __ \|  ____|__   __/ ____|
4  | |__| | |  | | |  \ \_/ /  | |__) | |__     | | | (___  
5  |  __  | |  | | |   \   /   |  ___/|  __|    | |  \___ \ 
6  | |  | | |__| | |____| |    | |    | |____   | |  ____) |
7  |_|  |_|\____/|______|_|    |_|    |______|  |_| |_____/ 
8  
9     cewy@nftbrains.com     
10 */
11 
12 // File: @openzeppelin/contracts/utils/Context.sol
13 
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 // File: @openzeppelin/contracts/access/Ownable.sol
40 
41 
42 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Address.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Collection of functions related to the address type
126  */
127 library Address {
128     /**
129      * @dev Returns true if `account` is a contract.
130      *
131      * [IMPORTANT]
132      * ====
133      * It is unsafe to assume that an address for which this function returns
134      * false is an externally-owned account (EOA) and not a contract.
135      *
136      * Among others, `isContract` will return false for the following
137      * types of addresses:
138      *
139      *  - an externally-owned account
140      *  - a contract in construction
141      *  - an address where a contract will be created
142      *  - an address where a contract lived, but was destroyed
143      * ====
144      */
145     function isContract(address account) internal view returns (bool) {
146         // This method relies on extcodesize, which returns 0 for contracts in
147         // construction, since the code is only stored at the end of the
148         // constructor execution.
149 
150         uint256 size;
151         assembly {
152             size := extcodesize(account)
153         }
154         return size > 0;
155     }
156 
157     /**
158      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
159      * `recipient`, forwarding all available gas and reverting on errors.
160      *
161      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
162      * of certain opcodes, possibly making contracts go over the 2300 gas limit
163      * imposed by `transfer`, making them unable to receive funds via
164      * `transfer`. {sendValue} removes this limitation.
165      *
166      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
167      *
168      * IMPORTANT: because control is transferred to `recipient`, care must be
169      * taken to not create reentrancy vulnerabilities. Consider using
170      * {ReentrancyGuard} or the
171      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
172      */
173     function sendValue(address payable recipient, uint256 amount) internal {
174         require(address(this).balance >= amount, "Address: insufficient balance");
175 
176         (bool success, ) = recipient.call{value: amount}("");
177         require(success, "Address: unable to send value, recipient may have reverted");
178     }
179 
180     /**
181      * @dev Performs a Solidity function call using a low level `call`. A
182      * plain `call` is an unsafe replacement for a function call: use this
183      * function instead.
184      *
185      * If `target` reverts with a revert reason, it is bubbled up by this
186      * function (like regular Solidity function calls).
187      *
188      * Returns the raw returned data. To convert to the expected return value,
189      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
190      *
191      * Requirements:
192      *
193      * - `target` must be a contract.
194      * - calling `target` with `data` must not revert.
195      *
196      * _Available since v3.1._
197      */
198     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
199         return functionCall(target, data, "Address: low-level call failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
204      * `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCall(
209         address target,
210         bytes memory data,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, 0, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but also transferring `value` wei to `target`.
219      *
220      * Requirements:
221      *
222      * - the calling contract must have an ETH balance of at least `value`.
223      * - the called Solidity function must be `payable`.
224      *
225      * _Available since v3.1._
226      */
227     function functionCallWithValue(
228         address target,
229         bytes memory data,
230         uint256 value
231     ) internal returns (bytes memory) {
232         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
237      * with `errorMessage` as a fallback revert reason when `target` reverts.
238      *
239      * _Available since v3.1._
240      */
241     function functionCallWithValue(
242         address target,
243         bytes memory data,
244         uint256 value,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         require(address(this).balance >= value, "Address: insufficient balance for call");
248         require(isContract(target), "Address: call to non-contract");
249 
250         (bool success, bytes memory returndata) = target.call{value: value}(data);
251         return verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but performing a static call.
257      *
258      * _Available since v3.3._
259      */
260     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
261         return functionStaticCall(target, data, "Address: low-level static call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
266      * but performing a static call.
267      *
268      * _Available since v3.3._
269      */
270     function functionStaticCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal view returns (bytes memory) {
275         require(isContract(target), "Address: static call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.staticcall(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but performing a delegate call.
284      *
285      * _Available since v3.4._
286      */
287     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
293      * but performing a delegate call.
294      *
295      * _Available since v3.4._
296      */
297     function functionDelegateCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         require(isContract(target), "Address: delegate call to non-contract");
303 
304         (bool success, bytes memory returndata) = target.delegatecall(data);
305         return verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
310      * revert reason using the provided one.
311      *
312      * _Available since v4.3._
313      */
314     function verifyCallResult(
315         bool success,
316         bytes memory returndata,
317         string memory errorMessage
318     ) internal pure returns (bytes memory) {
319         if (success) {
320             return returndata;
321         } else {
322             // Look for revert reason and bubble it up if present
323             if (returndata.length > 0) {
324                 // The easiest way to bubble the revert reason is using memory via assembly
325 
326                 assembly {
327                     let returndata_size := mload(returndata)
328                     revert(add(32, returndata), returndata_size)
329                 }
330             } else {
331                 revert(errorMessage);
332             }
333         }
334     }
335 }
336 
337 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
338 
339 
340 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev Interface of the ERC165 standard, as defined in the
346  * https://eips.ethereum.org/EIPS/eip-165[EIP].
347  *
348  * Implementers can declare support of contract interfaces, which can then be
349  * queried by others ({ERC165Checker}).
350  *
351  * For an implementation, see {ERC165}.
352  */
353 interface IERC165 {
354     /**
355      * @dev Returns true if this contract implements the interface defined by
356      * `interfaceId`. See the corresponding
357      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
358      * to learn more about how these ids are created.
359      *
360      * This function call must use less than 30 000 gas.
361      */
362     function supportsInterface(bytes4 interfaceId) external view returns (bool);
363 }
364 
365 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 
373 /**
374  * @dev Implementation of the {IERC165} interface.
375  *
376  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
377  * for the additional interface id that will be supported. For example:
378  *
379  * ```solidity
380  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
382  * }
383  * ```
384  *
385  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
386  */
387 abstract contract ERC165 is IERC165 {
388     /**
389      * @dev See {IERC165-supportsInterface}.
390      */
391     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
392         return interfaceId == type(IERC165).interfaceId;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev _Available since v3.1._
406  */
407 interface IERC1155Receiver is IERC165 {
408     /**
409         @dev Handles the receipt of a single ERC1155 token type. This function is
410         called at the end of a `safeTransferFrom` after the balance has been updated.
411         To accept the transfer, this must return
412         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
413         (i.e. 0xf23a6e61, or its own function selector).
414         @param operator The address which initiated the transfer (i.e. msg.sender)
415         @param from The address which previously owned the token
416         @param id The ID of the token being transferred
417         @param value The amount of tokens being transferred
418         @param data Additional data with no specified format
419         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
420     */
421     function onERC1155Received(
422         address operator,
423         address from,
424         uint256 id,
425         uint256 value,
426         bytes calldata data
427     ) external returns (bytes4);
428 
429     /**
430         @dev Handles the receipt of a multiple ERC1155 token types. This function
431         is called at the end of a `safeBatchTransferFrom` after the balances have
432         been updated. To accept the transfer(s), this must return
433         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
434         (i.e. 0xbc197c81, or its own function selector).
435         @param operator The address which initiated the batch transfer (i.e. msg.sender)
436         @param from The address which previously owned the token
437         @param ids An array containing ids of each token being transferred (order and length must match values array)
438         @param values An array containing amounts of each token being transferred (order and length must match ids array)
439         @param data Additional data with no specified format
440         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
441     */
442     function onERC1155BatchReceived(
443         address operator,
444         address from,
445         uint256[] calldata ids,
446         uint256[] calldata values,
447         bytes calldata data
448     ) external returns (bytes4);
449 }
450 
451 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 
459 /**
460  * @dev Required interface of an ERC1155 compliant contract, as defined in the
461  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
462  *
463  * _Available since v3.1._
464  */
465 interface IERC1155 is IERC165 {
466     /**
467      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
468      */
469     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
470 
471     /**
472      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
473      * transfers.
474      */
475     event TransferBatch(
476         address indexed operator,
477         address indexed from,
478         address indexed to,
479         uint256[] ids,
480         uint256[] values
481     );
482 
483     /**
484      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
485      * `approved`.
486      */
487     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
488 
489     /**
490      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
491      *
492      * If an {URI} event was emitted for `id`, the standard
493      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
494      * returned by {IERC1155MetadataURI-uri}.
495      */
496     event URI(string value, uint256 indexed id);
497 
498     /**
499      * @dev Returns the amount of tokens of token type `id` owned by `account`.
500      *
501      * Requirements:
502      *
503      * - `account` cannot be the zero address.
504      */
505     function balanceOf(address account, uint256 id) external view returns (uint256);
506 
507     /**
508      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
509      *
510      * Requirements:
511      *
512      * - `accounts` and `ids` must have the same length.
513      */
514     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
515         external
516         view
517         returns (uint256[] memory);
518 
519     /**
520      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
521      *
522      * Emits an {ApprovalForAll} event.
523      *
524      * Requirements:
525      *
526      * - `operator` cannot be the caller.
527      */
528     function setApprovalForAll(address operator, bool approved) external;
529 
530     /**
531      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
532      *
533      * See {setApprovalForAll}.
534      */
535     function isApprovedForAll(address account, address operator) external view returns (bool);
536 
537     /**
538      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
539      *
540      * Emits a {TransferSingle} event.
541      *
542      * Requirements:
543      *
544      * - `to` cannot be the zero address.
545      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
546      * - `from` must have a balance of tokens of type `id` of at least `amount`.
547      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
548      * acceptance magic value.
549      */
550     function safeTransferFrom(
551         address from,
552         address to,
553         uint256 id,
554         uint256 amount,
555         bytes calldata data
556     ) external;
557 
558     /**
559      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
560      *
561      * Emits a {TransferBatch} event.
562      *
563      * Requirements:
564      *
565      * - `ids` and `amounts` must have the same length.
566      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
567      * acceptance magic value.
568      */
569     function safeBatchTransferFrom(
570         address from,
571         address to,
572         uint256[] calldata ids,
573         uint256[] calldata amounts,
574         bytes calldata data
575     ) external;
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
588  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
589  *
590  * _Available since v3.1._
591  */
592 interface IERC1155MetadataURI is IERC1155 {
593     /**
594      * @dev Returns the URI for token type `id`.
595      *
596      * If the `\{id\}` substring is present in the URI, it must be replaced by
597      * clients with the actual token type ID.
598      */
599     function uri(uint256 id) external view returns (string memory);
600 }
601 
602 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 
610 
611 
612 
613 
614 
615 /**
616  * @dev Implementation of the basic standard multi-token.
617  * See https://eips.ethereum.org/EIPS/eip-1155
618  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
619  *
620  * _Available since v3.1._
621  */
622 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
623     using Address for address;
624 
625     // Mapping from token ID to account balances
626     mapping(uint256 => mapping(address => uint256)) private _balances;
627 
628     // Mapping from account to operator approvals
629     mapping(address => mapping(address => bool)) private _operatorApprovals;
630 
631     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
632     string private _uri;
633 
634     /**
635      * @dev See {_setURI}.
636      */
637     constructor(string memory uri_) {
638         _setURI(uri_);
639     }
640 
641     /**
642      * @dev See {IERC165-supportsInterface}.
643      */
644     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
645         return
646             interfaceId == type(IERC1155).interfaceId ||
647             interfaceId == type(IERC1155MetadataURI).interfaceId ||
648             super.supportsInterface(interfaceId);
649     }
650 
651     /**
652      * @dev See {IERC1155MetadataURI-uri}.
653      *
654      * This implementation returns the same URI for *all* token types. It relies
655      * on the token type ID substitution mechanism
656      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
657      *
658      * Clients calling this function must replace the `\{id\}` substring with the
659      * actual token type ID.
660      */
661     function uri(uint256) public view virtual override returns (string memory) {
662         return _uri;
663     }
664 
665     /**
666      * @dev See {IERC1155-balanceOf}.
667      *
668      * Requirements:
669      *
670      * - `account` cannot be the zero address.
671      */
672     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
673         require(account != address(0), "ERC1155: balance query for the zero address");
674         return _balances[id][account];
675     }
676 
677     /**
678      * @dev See {IERC1155-balanceOfBatch}.
679      *
680      * Requirements:
681      *
682      * - `accounts` and `ids` must have the same length.
683      */
684     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
685         public
686         view
687         virtual
688         override
689         returns (uint256[] memory)
690     {
691         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
692 
693         uint256[] memory batchBalances = new uint256[](accounts.length);
694 
695         for (uint256 i = 0; i < accounts.length; ++i) {
696             batchBalances[i] = balanceOf(accounts[i], ids[i]);
697         }
698 
699         return batchBalances;
700     }
701 
702     /**
703      * @dev See {IERC1155-setApprovalForAll}.
704      */
705     function setApprovalForAll(address operator, bool approved) public virtual override {
706         _setApprovalForAll(_msgSender(), operator, approved);
707     }
708 
709     /**
710      * @dev See {IERC1155-isApprovedForAll}.
711      */
712     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
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
728             "ERC1155: caller is not owner nor approved"
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
745             "ERC1155: transfer caller is not owner nor approved"
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
772 
773         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
774 
775         uint256 fromBalance = _balances[id][from];
776         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
777         unchecked {
778             _balances[id][from] = fromBalance - amount;
779         }
780         _balances[id][to] += amount;
781 
782         emit TransferSingle(operator, from, to, id, amount);
783 
784         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
785     }
786 
787     /**
788      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
789      *
790      * Emits a {TransferBatch} event.
791      *
792      * Requirements:
793      *
794      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
795      * acceptance magic value.
796      */
797     function _safeBatchTransferFrom(
798         address from,
799         address to,
800         uint256[] memory ids,
801         uint256[] memory amounts,
802         bytes memory data
803     ) internal virtual {
804         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
805         require(to != address(0), "ERC1155: transfer to the zero address");
806 
807         address operator = _msgSender();
808 
809         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
810 
811         for (uint256 i = 0; i < ids.length; ++i) {
812             uint256 id = ids[i];
813             uint256 amount = amounts[i];
814 
815             uint256 fromBalance = _balances[id][from];
816             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
817             unchecked {
818                 _balances[id][from] = fromBalance - amount;
819             }
820             _balances[id][to] += amount;
821         }
822 
823         emit TransferBatch(operator, from, to, ids, amounts);
824 
825         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
826     }
827 
828     /**
829      * @dev Sets a new URI for all token types, by relying on the token type ID
830      * substitution mechanism
831      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
832      *
833      * By this mechanism, any occurrence of the `\{id\}` substring in either the
834      * URI or any of the amounts in the JSON file at said URI will be replaced by
835      * clients with the token type ID.
836      *
837      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
838      * interpreted by clients as
839      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
840      * for token type ID 0x4cce0.
841      *
842      * See {uri}.
843      *
844      * Because these URIs cannot be meaningfully represented by the {URI} event,
845      * this function emits no events.
846      */
847     function _setURI(string memory newuri) internal virtual {
848         _uri = newuri;
849     }
850 
851     /**
852      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
853      *
854      * Emits a {TransferSingle} event.
855      *
856      * Requirements:
857      *
858      * - `to` cannot be the zero address.
859      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
860      * acceptance magic value.
861      */
862     function _mint(
863         address to,
864         uint256 id,
865         uint256 amount,
866         bytes memory data
867     ) internal virtual {
868         require(to != address(0), "ERC1155: mint to the zero address");
869 
870         address operator = _msgSender();
871 
872         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
873 
874         _balances[id][to] += amount;
875         emit TransferSingle(operator, address(0), to, id, amount);
876 
877         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
878     }
879 
880     /**
881      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
882      *
883      * Requirements:
884      *
885      * - `ids` and `amounts` must have the same length.
886      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
887      * acceptance magic value.
888      */
889     function _mintBatch(
890         address to,
891         uint256[] memory ids,
892         uint256[] memory amounts,
893         bytes memory data
894     ) internal virtual {
895         require(to != address(0), "ERC1155: mint to the zero address");
896         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
897 
898         address operator = _msgSender();
899 
900         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
901 
902         for (uint256 i = 0; i < ids.length; i++) {
903             _balances[ids[i]][to] += amounts[i];
904         }
905 
906         emit TransferBatch(operator, address(0), to, ids, amounts);
907 
908         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
909     }
910 
911     /**
912      * @dev Destroys `amount` tokens of token type `id` from `from`
913      *
914      * Requirements:
915      *
916      * - `from` cannot be the zero address.
917      * - `from` must have at least `amount` tokens of token type `id`.
918      */
919     function _burn(
920         address from,
921         uint256 id,
922         uint256 amount
923     ) internal virtual {
924         require(from != address(0), "ERC1155: burn from the zero address");
925 
926         address operator = _msgSender();
927 
928         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
929 
930         uint256 fromBalance = _balances[id][from];
931         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
932         unchecked {
933             _balances[id][from] = fromBalance - amount;
934         }
935 
936         emit TransferSingle(operator, from, address(0), id, amount);
937     }
938 
939     /**
940      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
941      *
942      * Requirements:
943      *
944      * - `ids` and `amounts` must have the same length.
945      */
946     function _burnBatch(
947         address from,
948         uint256[] memory ids,
949         uint256[] memory amounts
950     ) internal virtual {
951         require(from != address(0), "ERC1155: burn from the zero address");
952         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
953 
954         address operator = _msgSender();
955 
956         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
957 
958         for (uint256 i = 0; i < ids.length; i++) {
959             uint256 id = ids[i];
960             uint256 amount = amounts[i];
961 
962             uint256 fromBalance = _balances[id][from];
963             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
964             unchecked {
965                 _balances[id][from] = fromBalance - amount;
966             }
967         }
968 
969         emit TransferBatch(operator, from, address(0), ids, amounts);
970     }
971 
972     /**
973      * @dev Approve `operator` to operate on all of `owner` tokens
974      *
975      * Emits a {ApprovalForAll} event.
976      */
977     function _setApprovalForAll(
978         address owner,
979         address operator,
980         bool approved
981     ) internal virtual {
982         require(owner != operator, "ERC1155: setting approval status for self");
983         _operatorApprovals[owner][operator] = approved;
984         emit ApprovalForAll(owner, operator, approved);
985     }
986 
987     /**
988      * @dev Hook that is called before any token transfer. This includes minting
989      * and burning, as well as batched variants.
990      *
991      * The same hook is called on both single and batched variants. For single
992      * transfers, the length of the `id` and `amount` arrays will be 1.
993      *
994      * Calling conditions (for each `id` and `amount` pair):
995      *
996      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
997      * of token type `id` will be  transferred to `to`.
998      * - When `from` is zero, `amount` tokens of token type `id` will be minted
999      * for `to`.
1000      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1001      * will be burned.
1002      * - `from` and `to` are never both zero.
1003      * - `ids` and `amounts` have the same, non-zero length.
1004      *
1005      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1006      */
1007     function _beforeTokenTransfer(
1008         address operator,
1009         address from,
1010         address to,
1011         uint256[] memory ids,
1012         uint256[] memory amounts,
1013         bytes memory data
1014     ) internal virtual {}
1015 
1016     function _doSafeTransferAcceptanceCheck(
1017         address operator,
1018         address from,
1019         address to,
1020         uint256 id,
1021         uint256 amount,
1022         bytes memory data
1023     ) private {
1024         if (to.isContract()) {
1025             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1026                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1027                     revert("ERC1155: ERC1155Receiver rejected tokens");
1028                 }
1029             } catch Error(string memory reason) {
1030                 revert(reason);
1031             } catch {
1032                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1033             }
1034         }
1035     }
1036 
1037     function _doSafeBatchTransferAcceptanceCheck(
1038         address operator,
1039         address from,
1040         address to,
1041         uint256[] memory ids,
1042         uint256[] memory amounts,
1043         bytes memory data
1044     ) private {
1045         if (to.isContract()) {
1046             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1047                 bytes4 response
1048             ) {
1049                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1050                     revert("ERC1155: ERC1155Receiver rejected tokens");
1051                 }
1052             } catch Error(string memory reason) {
1053                 revert(reason);
1054             } catch {
1055                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1056             }
1057         }
1058     }
1059 
1060     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1061         uint256[] memory array = new uint256[](1);
1062         array[0] = element;
1063 
1064         return array;
1065     }
1066 }
1067 
1068 // File: contracts/HolyPets.sol
1069 
1070 
1071 pragma solidity ^0.8.0; 
1072 
1073 contract HolyPets is ERC1155, Ownable {
1074     string public constant name = "Pets";
1075     string public constant symbol = "PETS";
1076 
1077     uint32 public constant maxSupply = 6666;
1078     uint256 public constant unitPrice = 0.0777 ether;
1079 
1080     uint32 public totalSupply = 0;
1081     uint32 public saleStart = 1646510400;
1082 
1083     constructor(string memory uri) ERC1155(uri) {}
1084 
1085     function setURI(string memory uri) external onlyOwner {
1086         _setURI(uri);
1087     }
1088 
1089     function setSaleStart(uint32 timestamp) external onlyOwner {
1090         saleStart = timestamp;
1091     }
1092 
1093     function saleIsActive() public view returns (bool) {
1094         return saleStart <= block.timestamp;
1095     }
1096 
1097     function mint(address to, uint32 count) internal {
1098         totalSupply += count;
1099 
1100         if (count > 1) {
1101             uint256[] memory ids = new uint256[](uint256(count));
1102             uint256[] memory amounts = new uint256[](uint256(count));
1103 
1104             for (uint32 i = 0; i < count; i++) {
1105                 ids[i] = totalSupply - count + i;
1106                 amounts[i] = 1;
1107             }
1108 
1109             _mintBatch(to, ids, amounts, "");
1110         } else {
1111             _mint(to, totalSupply - 1, 1, "");
1112         }
1113     }
1114 
1115     function mint(uint32 count) external payable {
1116         require(saleIsActive(), "Public sale is not active.");
1117         require(count > 0, "Count must be greater than 0.");
1118         require(
1119             totalSupply + count <= maxSupply,
1120             "Count exceeds the maximum allowed supply."
1121         );
1122         require(msg.value >= unitPrice * count, "Not enough ether.");
1123 
1124         mint(msg.sender, count);
1125     }
1126 
1127     function batchMint(address[] memory addresses) external onlyOwner {
1128         require(
1129             totalSupply + addresses.length <= maxSupply,
1130             "Count exceeds the maximum allowed supply."
1131         );
1132 
1133         for (uint256 i = 0; i < addresses.length; i++) {
1134             mint(addresses[i], 1);
1135         }
1136     }
1137 
1138     function withdraw() external onlyOwner {
1139         address[2] memory addresses = [
1140             0x2EC1e3291f0889085098555A4a3AC3A451491060,
1141             0x1F9fa3F21f92b5579c4e4d7232d9E412b0E89399
1142         ];
1143 
1144         uint32[2] memory shares = [
1145             uint32(6900),
1146             uint32(3100)
1147         ];
1148 
1149         uint256 balance = address(this).balance;
1150 
1151         for (uint32 i = 0; i < addresses.length; i++) {
1152             uint256 amount = i == addresses.length - 1
1153                 ? address(this).balance
1154                 : (balance * shares[i]) / 10000;
1155             payable(addresses[i]).transfer(amount);
1156         }
1157     }
1158 }