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
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Address.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
110 
111 pragma solidity ^0.8.1;
112 
113 /**
114  * @dev Collection of functions related to the address type
115  */
116 library Address {
117     /**
118      * @dev Returns true if `account` is a contract.
119      *
120      * [IMPORTANT]
121      * ====
122      * It is unsafe to assume that an address for which this function returns
123      * false is an externally-owned account (EOA) and not a contract.
124      *
125      * Among others, `isContract` will return false for the following
126      * types of addresses:
127      *
128      *  - an externally-owned account
129      *  - a contract in construction
130      *  - an address where a contract will be created
131      *  - an address where a contract lived, but was destroyed
132      * ====
133      *
134      * [IMPORTANT]
135      * ====
136      * You shouldn't rely on `isContract` to protect against flash loan attacks!
137      *
138      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
139      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
140      * constructor.
141      * ====
142      */
143     function isContract(address account) internal view returns (bool) {
144         // This method relies on extcodesize/address.code.length, which returns 0
145         // for contracts in construction, since the code is only stored at the end
146         // of the constructor execution.
147 
148         return account.code.length > 0;
149     }
150 
151     /**
152      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
153      * `recipient`, forwarding all available gas and reverting on errors.
154      *
155      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
156      * of certain opcodes, possibly making contracts go over the 2300 gas limit
157      * imposed by `transfer`, making them unable to receive funds via
158      * `transfer`. {sendValue} removes this limitation.
159      *
160      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
161      *
162      * IMPORTANT: because control is transferred to `recipient`, care must be
163      * taken to not create reentrancy vulnerabilities. Consider using
164      * {ReentrancyGuard} or the
165      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
166      */
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(address(this).balance >= amount, "Address: insufficient balance");
169 
170         (bool success, ) = recipient.call{value: amount}("");
171         require(success, "Address: unable to send value, recipient may have reverted");
172     }
173 
174     /**
175      * @dev Performs a Solidity function call using a low level `call`. A
176      * plain `call` is an unsafe replacement for a function call: use this
177      * function instead.
178      *
179      * If `target` reverts with a revert reason, it is bubbled up by this
180      * function (like regular Solidity function calls).
181      *
182      * Returns the raw returned data. To convert to the expected return value,
183      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
184      *
185      * Requirements:
186      *
187      * - `target` must be a contract.
188      * - calling `target` with `data` must not revert.
189      *
190      * _Available since v3.1._
191      */
192     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionCall(target, data, "Address: low-level call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
198      * `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, 0, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but also transferring `value` wei to `target`.
213      *
214      * Requirements:
215      *
216      * - the calling contract must have an ETH balance of at least `value`.
217      * - the called Solidity function must be `payable`.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(
222         address target,
223         bytes memory data,
224         uint256 value
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
231      * with `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(
236         address target,
237         bytes memory data,
238         uint256 value,
239         string memory errorMessage
240     ) internal returns (bytes memory) {
241         require(address(this).balance >= value, "Address: insufficient balance for call");
242         require(isContract(target), "Address: call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.call{value: value}(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a static call.
251      *
252      * _Available since v3.3._
253      */
254     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
255         return functionStaticCall(target, data, "Address: low-level static call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a static call.
261      *
262      * _Available since v3.3._
263      */
264     function functionStaticCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal view returns (bytes memory) {
269         require(isContract(target), "Address: static call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.staticcall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but performing a delegate call.
278      *
279      * _Available since v3.4._
280      */
281     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
287      * but performing a delegate call.
288      *
289      * _Available since v3.4._
290      */
291     function functionDelegateCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         require(isContract(target), "Address: delegate call to non-contract");
297 
298         (bool success, bytes memory returndata) = target.delegatecall(data);
299         return verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
304      * revert reason using the provided one.
305      *
306      * _Available since v4.3._
307      */
308     function verifyCallResult(
309         bool success,
310         bytes memory returndata,
311         string memory errorMessage
312     ) internal pure returns (bytes memory) {
313         if (success) {
314             return returndata;
315         } else {
316             // Look for revert reason and bubble it up if present
317             if (returndata.length > 0) {
318                 // The easiest way to bubble the revert reason is using memory via assembly
319 
320                 assembly {
321                     let returndata_size := mload(returndata)
322                     revert(add(32, returndata), returndata_size)
323                 }
324             } else {
325                 revert(errorMessage);
326             }
327         }
328     }
329 }
330 
331 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
332 
333 
334 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @dev Interface of the ERC165 standard, as defined in the
340  * https://eips.ethereum.org/EIPS/eip-165[EIP].
341  *
342  * Implementers can declare support of contract interfaces, which can then be
343  * queried by others ({ERC165Checker}).
344  *
345  * For an implementation, see {ERC165}.
346  */
347 interface IERC165 {
348     /**
349      * @dev Returns true if this contract implements the interface defined by
350      * `interfaceId`. See the corresponding
351      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
352      * to learn more about how these ids are created.
353      *
354      * This function call must use less than 30 000 gas.
355      */
356     function supportsInterface(bytes4 interfaceId) external view returns (bool);
357 }
358 
359 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 
367 /**
368  * @dev Implementation of the {IERC165} interface.
369  *
370  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
371  * for the additional interface id that will be supported. For example:
372  *
373  * ```solidity
374  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
375  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
376  * }
377  * ```
378  *
379  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
380  */
381 abstract contract ERC165 is IERC165 {
382     /**
383      * @dev See {IERC165-supportsInterface}.
384      */
385     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
386         return interfaceId == type(IERC165).interfaceId;
387     }
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
391 
392 
393 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 /**
399  * @dev _Available since v3.1._
400  */
401 interface IERC1155Receiver is IERC165 {
402     /**
403      * @dev Handles the receipt of a single ERC1155 token type. This function is
404      * called at the end of a `safeTransferFrom` after the balance has been updated.
405      *
406      * NOTE: To accept the transfer, this must return
407      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
408      * (i.e. 0xf23a6e61, or its own function selector).
409      *
410      * @param operator The address which initiated the transfer (i.e. msg.sender)
411      * @param from The address which previously owned the token
412      * @param id The ID of the token being transferred
413      * @param value The amount of tokens being transferred
414      * @param data Additional data with no specified format
415      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
416      */
417     function onERC1155Received(
418         address operator,
419         address from,
420         uint256 id,
421         uint256 value,
422         bytes calldata data
423     ) external returns (bytes4);
424 
425     /**
426      * @dev Handles the receipt of a multiple ERC1155 token types. This function
427      * is called at the end of a `safeBatchTransferFrom` after the balances have
428      * been updated.
429      *
430      * NOTE: To accept the transfer(s), this must return
431      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
432      * (i.e. 0xbc197c81, or its own function selector).
433      *
434      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
435      * @param from The address which previously owned the token
436      * @param ids An array containing ids of each token being transferred (order and length must match values array)
437      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
438      * @param data Additional data with no specified format
439      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
440      */
441     function onERC1155BatchReceived(
442         address operator,
443         address from,
444         uint256[] calldata ids,
445         uint256[] calldata values,
446         bytes calldata data
447     ) external returns (bytes4);
448 }
449 
450 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 
458 /**
459  * @dev Required interface of an ERC1155 compliant contract, as defined in the
460  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
461  *
462  * _Available since v3.1._
463  */
464 interface IERC1155 is IERC165 {
465     /**
466      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
467      */
468     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
469 
470     /**
471      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
472      * transfers.
473      */
474     event TransferBatch(
475         address indexed operator,
476         address indexed from,
477         address indexed to,
478         uint256[] ids,
479         uint256[] values
480     );
481 
482     /**
483      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
484      * `approved`.
485      */
486     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
487 
488     /**
489      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
490      *
491      * If an {URI} event was emitted for `id`, the standard
492      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
493      * returned by {IERC1155MetadataURI-uri}.
494      */
495     event URI(string value, uint256 indexed id);
496 
497     /**
498      * @dev Returns the amount of tokens of token type `id` owned by `account`.
499      *
500      * Requirements:
501      *
502      * - `account` cannot be the zero address.
503      */
504     function balanceOf(address account, uint256 id) external view returns (uint256);
505 
506     /**
507      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
508      *
509      * Requirements:
510      *
511      * - `accounts` and `ids` must have the same length.
512      */
513     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
514         external
515         view
516         returns (uint256[] memory);
517 
518     /**
519      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
520      *
521      * Emits an {ApprovalForAll} event.
522      *
523      * Requirements:
524      *
525      * - `operator` cannot be the caller.
526      */
527     function setApprovalForAll(address operator, bool approved) external;
528 
529     /**
530      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
531      *
532      * See {setApprovalForAll}.
533      */
534     function isApprovedForAll(address account, address operator) external view returns (bool);
535 
536     /**
537      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
538      *
539      * Emits a {TransferSingle} event.
540      *
541      * Requirements:
542      *
543      * - `to` cannot be the zero address.
544      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
545      * - `from` must have a balance of tokens of type `id` of at least `amount`.
546      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
547      * acceptance magic value.
548      */
549     function safeTransferFrom(
550         address from,
551         address to,
552         uint256 id,
553         uint256 amount,
554         bytes calldata data
555     ) external;
556 
557     /**
558      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
559      *
560      * Emits a {TransferBatch} event.
561      *
562      * Requirements:
563      *
564      * - `ids` and `amounts` must have the same length.
565      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
566      * acceptance magic value.
567      */
568     function safeBatchTransferFrom(
569         address from,
570         address to,
571         uint256[] calldata ids,
572         uint256[] calldata amounts,
573         bytes calldata data
574     ) external;
575 }
576 
577 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
578 
579 
580 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 
585 /**
586  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
587  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
588  *
589  * _Available since v3.1._
590  */
591 interface IERC1155MetadataURI is IERC1155 {
592     /**
593      * @dev Returns the URI for token type `id`.
594      *
595      * If the `\{id\}` substring is present in the URI, it must be replaced by
596      * clients with the actual token type ID.
597      */
598     function uri(uint256 id) external view returns (string memory);
599 }
600 
601 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
602 
603 
604 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 
609 
610 
611 
612 
613 
614 /**
615  * @dev Implementation of the basic standard multi-token.
616  * See https://eips.ethereum.org/EIPS/eip-1155
617  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
618  *
619  * _Available since v3.1._
620  */
621 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
622     using Address for address;
623 
624     // Mapping from token ID to account balances
625     mapping(uint256 => mapping(address => uint256)) private _balances;
626 
627     // Mapping from account to operator approvals
628     mapping(address => mapping(address => bool)) private _operatorApprovals;
629 
630     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
631     string private _uri;
632 
633     /**
634      * @dev See {_setURI}.
635      */
636     constructor(string memory uri_) {
637         _setURI(uri_);
638     }
639 
640     /**
641      * @dev See {IERC165-supportsInterface}.
642      */
643     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
644         return
645             interfaceId == type(IERC1155).interfaceId ||
646             interfaceId == type(IERC1155MetadataURI).interfaceId ||
647             super.supportsInterface(interfaceId);
648     }
649 
650     /**
651      * @dev See {IERC1155MetadataURI-uri}.
652      *
653      * This implementation returns the same URI for *all* token types. It relies
654      * on the token type ID substitution mechanism
655      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
656      *
657      * Clients calling this function must replace the `\{id\}` substring with the
658      * actual token type ID.
659      */
660     function uri(uint256) public view virtual override returns (string memory) {
661         return _uri;
662     }
663 
664     /**
665      * @dev See {IERC1155-balanceOf}.
666      *
667      * Requirements:
668      *
669      * - `account` cannot be the zero address.
670      */
671     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
672         require(account != address(0), "ERC1155: balance query for the zero address");
673         return _balances[id][account];
674     }
675 
676     /**
677      * @dev See {IERC1155-balanceOfBatch}.
678      *
679      * Requirements:
680      *
681      * - `accounts` and `ids` must have the same length.
682      */
683     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
684         public
685         view
686         virtual
687         override
688         returns (uint256[] memory)
689     {
690         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
691 
692         uint256[] memory batchBalances = new uint256[](accounts.length);
693 
694         for (uint256 i = 0; i < accounts.length; ++i) {
695             batchBalances[i] = balanceOf(accounts[i], ids[i]);
696         }
697 
698         return batchBalances;
699     }
700 
701     /**
702      * @dev See {IERC1155-setApprovalForAll}.
703      */
704     function setApprovalForAll(address operator, bool approved) public virtual override {
705         _setApprovalForAll(_msgSender(), operator, approved);
706     }
707 
708     /**
709      * @dev See {IERC1155-isApprovedForAll}.
710      */
711     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
712         return _operatorApprovals[account][operator];
713     }
714 
715     /**
716      * @dev See {IERC1155-safeTransferFrom}.
717      */
718     function safeTransferFrom(
719         address from,
720         address to,
721         uint256 id,
722         uint256 amount,
723         bytes memory data
724     ) public virtual override {
725         require(
726             from == _msgSender() || isApprovedForAll(from, _msgSender()),
727             "ERC1155: caller is not owner nor approved"
728         );
729         _safeTransferFrom(from, to, id, amount, data);
730     }
731 
732     /**
733      * @dev See {IERC1155-safeBatchTransferFrom}.
734      */
735     function safeBatchTransferFrom(
736         address from,
737         address to,
738         uint256[] memory ids,
739         uint256[] memory amounts,
740         bytes memory data
741     ) public virtual override {
742         require(
743             from == _msgSender() || isApprovedForAll(from, _msgSender()),
744             "ERC1155: transfer caller is not owner nor approved"
745         );
746         _safeBatchTransferFrom(from, to, ids, amounts, data);
747     }
748 
749     /**
750      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
751      *
752      * Emits a {TransferSingle} event.
753      *
754      * Requirements:
755      *
756      * - `to` cannot be the zero address.
757      * - `from` must have a balance of tokens of type `id` of at least `amount`.
758      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
759      * acceptance magic value.
760      */
761     function _safeTransferFrom(
762         address from,
763         address to,
764         uint256 id,
765         uint256 amount,
766         bytes memory data
767     ) internal virtual {
768         require(to != address(0), "ERC1155: transfer to the zero address");
769 
770         address operator = _msgSender();
771 
772         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
773 
774         uint256 fromBalance = _balances[id][from];
775         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
776         unchecked {
777             _balances[id][from] = fromBalance - amount;
778         }
779         _balances[id][to] += amount;
780 
781         emit TransferSingle(operator, from, to, id, amount);
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
803         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
804         require(to != address(0), "ERC1155: transfer to the zero address");
805 
806         address operator = _msgSender();
807 
808         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
809 
810         for (uint256 i = 0; i < ids.length; ++i) {
811             uint256 id = ids[i];
812             uint256 amount = amounts[i];
813 
814             uint256 fromBalance = _balances[id][from];
815             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
816             unchecked {
817                 _balances[id][from] = fromBalance - amount;
818             }
819             _balances[id][to] += amount;
820         }
821 
822         emit TransferBatch(operator, from, to, ids, amounts);
823 
824         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
825     }
826 
827     /**
828      * @dev Sets a new URI for all token types, by relying on the token type ID
829      * substitution mechanism
830      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
831      *
832      * By this mechanism, any occurrence of the `\{id\}` substring in either the
833      * URI or any of the amounts in the JSON file at said URI will be replaced by
834      * clients with the token type ID.
835      *
836      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
837      * interpreted by clients as
838      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
839      * for token type ID 0x4cce0.
840      *
841      * See {uri}.
842      *
843      * Because these URIs cannot be meaningfully represented by the {URI} event,
844      * this function emits no events.
845      */
846     function _setURI(string memory newuri) internal virtual {
847         _uri = newuri;
848     }
849 
850     /**
851      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
852      *
853      * Emits a {TransferSingle} event.
854      *
855      * Requirements:
856      *
857      * - `to` cannot be the zero address.
858      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
859      * acceptance magic value.
860      */
861     function _mint(
862         address to,
863         uint256 id,
864         uint256 amount,
865         bytes memory data
866     ) internal virtual {
867         require(to != address(0), "ERC1155: mint to the zero address");
868 
869         address operator = _msgSender();
870 
871         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
872 
873         _balances[id][to] += amount;
874         emit TransferSingle(operator, address(0), to, id, amount);
875 
876         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
877     }
878 
879     /**
880      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
881      *
882      * Requirements:
883      *
884      * - `ids` and `amounts` must have the same length.
885      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
886      * acceptance magic value.
887      */
888     function _mintBatch(
889         address to,
890         uint256[] memory ids,
891         uint256[] memory amounts,
892         bytes memory data
893     ) internal virtual {
894         require(to != address(0), "ERC1155: mint to the zero address");
895         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
896 
897         address operator = _msgSender();
898 
899         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
900 
901         for (uint256 i = 0; i < ids.length; i++) {
902             _balances[ids[i]][to] += amounts[i];
903         }
904 
905         emit TransferBatch(operator, address(0), to, ids, amounts);
906 
907         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
908     }
909 
910     /**
911      * @dev Destroys `amount` tokens of token type `id` from `from`
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `from` must have at least `amount` tokens of token type `id`.
917      */
918     function _burn(
919         address from,
920         uint256 id,
921         uint256 amount
922     ) internal virtual {
923         require(from != address(0), "ERC1155: burn from the zero address");
924 
925         address operator = _msgSender();
926 
927         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
928 
929         uint256 fromBalance = _balances[id][from];
930         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
931         unchecked {
932             _balances[id][from] = fromBalance - amount;
933         }
934 
935         emit TransferSingle(operator, from, address(0), id, amount);
936     }
937 
938     /**
939      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
940      *
941      * Requirements:
942      *
943      * - `ids` and `amounts` must have the same length.
944      */
945     function _burnBatch(
946         address from,
947         uint256[] memory ids,
948         uint256[] memory amounts
949     ) internal virtual {
950         require(from != address(0), "ERC1155: burn from the zero address");
951         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
952 
953         address operator = _msgSender();
954 
955         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
956 
957         for (uint256 i = 0; i < ids.length; i++) {
958             uint256 id = ids[i];
959             uint256 amount = amounts[i];
960 
961             uint256 fromBalance = _balances[id][from];
962             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
963             unchecked {
964                 _balances[id][from] = fromBalance - amount;
965             }
966         }
967 
968         emit TransferBatch(operator, from, address(0), ids, amounts);
969     }
970 
971     /**
972      * @dev Approve `operator` to operate on all of `owner` tokens
973      *
974      * Emits a {ApprovalForAll} event.
975      */
976     function _setApprovalForAll(
977         address owner,
978         address operator,
979         bool approved
980     ) internal virtual {
981         require(owner != operator, "ERC1155: setting approval status for self");
982         _operatorApprovals[owner][operator] = approved;
983         emit ApprovalForAll(owner, operator, approved);
984     }
985 
986     /**
987      * @dev Hook that is called before any token transfer. This includes minting
988      * and burning, as well as batched variants.
989      *
990      * The same hook is called on both single and batched variants. For single
991      * transfers, the length of the `id` and `amount` arrays will be 1.
992      *
993      * Calling conditions (for each `id` and `amount` pair):
994      *
995      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
996      * of token type `id` will be  transferred to `to`.
997      * - When `from` is zero, `amount` tokens of token type `id` will be minted
998      * for `to`.
999      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1000      * will be burned.
1001      * - `from` and `to` are never both zero.
1002      * - `ids` and `amounts` have the same, non-zero length.
1003      *
1004      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1005      */
1006     function _beforeTokenTransfer(
1007         address operator,
1008         address from,
1009         address to,
1010         uint256[] memory ids,
1011         uint256[] memory amounts,
1012         bytes memory data
1013     ) internal virtual {}
1014 
1015     function _doSafeTransferAcceptanceCheck(
1016         address operator,
1017         address from,
1018         address to,
1019         uint256 id,
1020         uint256 amount,
1021         bytes memory data
1022     ) private {
1023         if (to.isContract()) {
1024             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1025                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1026                     revert("ERC1155: ERC1155Receiver rejected tokens");
1027                 }
1028             } catch Error(string memory reason) {
1029                 revert(reason);
1030             } catch {
1031                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1032             }
1033         }
1034     }
1035 
1036     function _doSafeBatchTransferAcceptanceCheck(
1037         address operator,
1038         address from,
1039         address to,
1040         uint256[] memory ids,
1041         uint256[] memory amounts,
1042         bytes memory data
1043     ) private {
1044         if (to.isContract()) {
1045             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1046                 bytes4 response
1047             ) {
1048                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1049                     revert("ERC1155: ERC1155Receiver rejected tokens");
1050                 }
1051             } catch Error(string memory reason) {
1052                 revert(reason);
1053             } catch {
1054                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1055             }
1056         }
1057     }
1058 
1059     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1060         uint256[] memory array = new uint256[](1);
1061         array[0] = element;
1062 
1063         return array;
1064     }
1065 }
1066 
1067 // File: contracts/WAGMI.sol
1068 
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 
1073 
1074 contract WAGMI is ERC1155, Ownable {
1075     string public constant name = "WAGMI";
1076     string public constant symbol = "WAGMI";
1077 
1078     uint32 public constant maxSupply = 3022;
1079     uint256 public constant unitPrice = 0.125 ether;
1080 
1081     uint32 public totalSupply = 0;
1082     uint32 public saleStart = 1648324800;
1083 
1084     constructor(string memory uri) ERC1155(uri) {}
1085 
1086     function setURI(string memory uri) external onlyOwner {
1087         _setURI(uri);
1088     }
1089 
1090     function setSaleStart(uint32 timestamp) external onlyOwner {
1091         saleStart = timestamp;
1092     }
1093 
1094     function saleIsActive() public view returns (bool) {
1095         return saleStart <= block.timestamp;
1096     }
1097 
1098     function mint(address to, uint32 count) internal {
1099         totalSupply += count;
1100 
1101         if (count > 1) {
1102             uint256[] memory ids = new uint256[](uint256(count));
1103             uint256[] memory amounts = new uint256[](uint256(count));
1104 
1105             for (uint32 i = 0; i < count; i++) {
1106                 ids[i] = totalSupply - count + i;
1107                 amounts[i] = 1;
1108             }
1109 
1110             _mintBatch(to, ids, amounts, "");
1111         } else {
1112             _mint(to, totalSupply - 1, 1, "");
1113         }
1114     }
1115 
1116     function mint(uint32 count) external payable {
1117         require(saleIsActive(), "Public sale is not active.");
1118         require(count > 0, "Count must be greater than 0.");
1119         require(
1120             totalSupply + count <= maxSupply,
1121             "Count exceeds the maximum allowed supply."
1122         );
1123         require(msg.value >= unitPrice * count, "Not enough ether.");
1124 
1125         mint(msg.sender, count);
1126     }
1127 
1128     function airdrop(address[] memory addresses) external onlyOwner {
1129         require(
1130             totalSupply + addresses.length <= maxSupply,
1131             "Count exceeds the maximum allowed supply."
1132         );
1133 
1134         for (uint256 i = 0; i < addresses.length; i++) {
1135             mint(addresses[i], 1);
1136         }
1137     }
1138 
1139     function withdraw() external onlyOwner {
1140         address[2] memory addresses = [
1141             0xb166139a65fe53162936760aB9596b71b2467E82,
1142             0x6951E3dF5AeE8b018325ce2FBC0c399858d76eE0
1143         ];
1144 
1145         uint32[2] memory shares = [uint32(9600), uint32(400)];
1146 
1147         uint256 balance = address(this).balance;
1148 
1149         for (uint32 i = 0; i < addresses.length; i++) {
1150             uint256 amount = i == addresses.length - 1
1151                 ? address(this).balance
1152                 : (balance * shares[i]) / 10000;
1153             payable(addresses[i]).transfer(amount);
1154         }
1155     }
1156 }