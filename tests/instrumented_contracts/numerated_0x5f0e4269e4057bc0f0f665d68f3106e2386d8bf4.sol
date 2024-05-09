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
604 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
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
771         uint256[] memory ids = _asSingletonArray(id);
772         uint256[] memory amounts = _asSingletonArray(amount);
773 
774         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
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
785         _afterTokenTransfer(operator, from, to, ids, amounts, data);
786 
787         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
788     }
789 
790     /**
791      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
792      *
793      * Emits a {TransferBatch} event.
794      *
795      * Requirements:
796      *
797      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
798      * acceptance magic value.
799      */
800     function _safeBatchTransferFrom(
801         address from,
802         address to,
803         uint256[] memory ids,
804         uint256[] memory amounts,
805         bytes memory data
806     ) internal virtual {
807         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
808         require(to != address(0), "ERC1155: transfer to the zero address");
809 
810         address operator = _msgSender();
811 
812         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
813 
814         for (uint256 i = 0; i < ids.length; ++i) {
815             uint256 id = ids[i];
816             uint256 amount = amounts[i];
817 
818             uint256 fromBalance = _balances[id][from];
819             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
820             unchecked {
821                 _balances[id][from] = fromBalance - amount;
822             }
823             _balances[id][to] += amount;
824         }
825 
826         emit TransferBatch(operator, from, to, ids, amounts);
827 
828         _afterTokenTransfer(operator, from, to, ids, amounts, data);
829 
830         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
831     }
832 
833     /**
834      * @dev Sets a new URI for all token types, by relying on the token type ID
835      * substitution mechanism
836      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
837      *
838      * By this mechanism, any occurrence of the `\{id\}` substring in either the
839      * URI or any of the amounts in the JSON file at said URI will be replaced by
840      * clients with the token type ID.
841      *
842      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
843      * interpreted by clients as
844      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
845      * for token type ID 0x4cce0.
846      *
847      * See {uri}.
848      *
849      * Because these URIs cannot be meaningfully represented by the {URI} event,
850      * this function emits no events.
851      */
852     function _setURI(string memory newuri) internal virtual {
853         _uri = newuri;
854     }
855 
856     /**
857      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
858      *
859      * Emits a {TransferSingle} event.
860      *
861      * Requirements:
862      *
863      * - `to` cannot be the zero address.
864      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
865      * acceptance magic value.
866      */
867     function _mint(
868         address to,
869         uint256 id,
870         uint256 amount,
871         bytes memory data
872     ) internal virtual {
873         require(to != address(0), "ERC1155: mint to the zero address");
874 
875         address operator = _msgSender();
876         uint256[] memory ids = _asSingletonArray(id);
877         uint256[] memory amounts = _asSingletonArray(amount);
878 
879         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
880 
881         _balances[id][to] += amount;
882         emit TransferSingle(operator, address(0), to, id, amount);
883 
884         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
885 
886         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
887     }
888 
889     /**
890      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
891      *
892      * Requirements:
893      *
894      * - `ids` and `amounts` must have the same length.
895      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
896      * acceptance magic value.
897      */
898     function _mintBatch(
899         address to,
900         uint256[] memory ids,
901         uint256[] memory amounts,
902         bytes memory data
903     ) internal virtual {
904         require(to != address(0), "ERC1155: mint to the zero address");
905         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
906 
907         address operator = _msgSender();
908 
909         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
910 
911         for (uint256 i = 0; i < ids.length; i++) {
912             _balances[ids[i]][to] += amounts[i];
913         }
914 
915         emit TransferBatch(operator, address(0), to, ids, amounts);
916 
917         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
918 
919         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
920     }
921 
922     /**
923      * @dev Destroys `amount` tokens of token type `id` from `from`
924      *
925      * Requirements:
926      *
927      * - `from` cannot be the zero address.
928      * - `from` must have at least `amount` tokens of token type `id`.
929      */
930     function _burn(
931         address from,
932         uint256 id,
933         uint256 amount
934     ) internal virtual {
935         require(from != address(0), "ERC1155: burn from the zero address");
936 
937         address operator = _msgSender();
938         uint256[] memory ids = _asSingletonArray(id);
939         uint256[] memory amounts = _asSingletonArray(amount);
940 
941         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
942 
943         uint256 fromBalance = _balances[id][from];
944         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
945         unchecked {
946             _balances[id][from] = fromBalance - amount;
947         }
948 
949         emit TransferSingle(operator, from, address(0), id, amount);
950 
951         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
952     }
953 
954     /**
955      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
956      *
957      * Requirements:
958      *
959      * - `ids` and `amounts` must have the same length.
960      */
961     function _burnBatch(
962         address from,
963         uint256[] memory ids,
964         uint256[] memory amounts
965     ) internal virtual {
966         require(from != address(0), "ERC1155: burn from the zero address");
967         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
968 
969         address operator = _msgSender();
970 
971         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
972 
973         for (uint256 i = 0; i < ids.length; i++) {
974             uint256 id = ids[i];
975             uint256 amount = amounts[i];
976 
977             uint256 fromBalance = _balances[id][from];
978             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
979             unchecked {
980                 _balances[id][from] = fromBalance - amount;
981             }
982         }
983 
984         emit TransferBatch(operator, from, address(0), ids, amounts);
985 
986         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
987     }
988 
989     /**
990      * @dev Approve `operator` to operate on all of `owner` tokens
991      *
992      * Emits a {ApprovalForAll} event.
993      */
994     function _setApprovalForAll(
995         address owner,
996         address operator,
997         bool approved
998     ) internal virtual {
999         require(owner != operator, "ERC1155: setting approval status for self");
1000         _operatorApprovals[owner][operator] = approved;
1001         emit ApprovalForAll(owner, operator, approved);
1002     }
1003 
1004     /**
1005      * @dev Hook that is called before any token transfer. This includes minting
1006      * and burning, as well as batched variants.
1007      *
1008      * The same hook is called on both single and batched variants. For single
1009      * transfers, the length of the `id` and `amount` arrays will be 1.
1010      *
1011      * Calling conditions (for each `id` and `amount` pair):
1012      *
1013      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1014      * of token type `id` will be  transferred to `to`.
1015      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1016      * for `to`.
1017      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1018      * will be burned.
1019      * - `from` and `to` are never both zero.
1020      * - `ids` and `amounts` have the same, non-zero length.
1021      *
1022      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1023      */
1024     function _beforeTokenTransfer(
1025         address operator,
1026         address from,
1027         address to,
1028         uint256[] memory ids,
1029         uint256[] memory amounts,
1030         bytes memory data
1031     ) internal virtual {}
1032 
1033     /**
1034      * @dev Hook that is called after any token transfer. This includes minting
1035      * and burning, as well as batched variants.
1036      *
1037      * The same hook is called on both single and batched variants. For single
1038      * transfers, the length of the `id` and `amount` arrays will be 1.
1039      *
1040      * Calling conditions (for each `id` and `amount` pair):
1041      *
1042      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1043      * of token type `id` will be  transferred to `to`.
1044      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1045      * for `to`.
1046      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1047      * will be burned.
1048      * - `from` and `to` are never both zero.
1049      * - `ids` and `amounts` have the same, non-zero length.
1050      *
1051      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1052      */
1053     function _afterTokenTransfer(
1054         address operator,
1055         address from,
1056         address to,
1057         uint256[] memory ids,
1058         uint256[] memory amounts,
1059         bytes memory data
1060     ) internal virtual {}
1061 
1062     function _doSafeTransferAcceptanceCheck(
1063         address operator,
1064         address from,
1065         address to,
1066         uint256 id,
1067         uint256 amount,
1068         bytes memory data
1069     ) private {
1070         if (to.isContract()) {
1071             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1072                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1073                     revert("ERC1155: ERC1155Receiver rejected tokens");
1074                 }
1075             } catch Error(string memory reason) {
1076                 revert(reason);
1077             } catch {
1078                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1079             }
1080         }
1081     }
1082 
1083     function _doSafeBatchTransferAcceptanceCheck(
1084         address operator,
1085         address from,
1086         address to,
1087         uint256[] memory ids,
1088         uint256[] memory amounts,
1089         bytes memory data
1090     ) private {
1091         if (to.isContract()) {
1092             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1093                 bytes4 response
1094             ) {
1095                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1096                     revert("ERC1155: ERC1155Receiver rejected tokens");
1097                 }
1098             } catch Error(string memory reason) {
1099                 revert(reason);
1100             } catch {
1101                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1102             }
1103         }
1104     }
1105 
1106     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1107         uint256[] memory array = new uint256[](1);
1108         array[0] = element;
1109 
1110         return array;
1111     }
1112 }
1113 
1114 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1115 
1116 
1117 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1118 
1119 pragma solidity ^0.8.0;
1120 
1121 
1122 /**
1123  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1124  *
1125  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1126  * clearly identified. Note: While a totalSupply of 1 might mean the
1127  * corresponding is an NFT, there is no guarantees that no other token with the
1128  * same id are not going to be minted.
1129  */
1130 abstract contract ERC1155Supply is ERC1155 {
1131     mapping(uint256 => uint256) private _totalSupply;
1132 
1133     /**
1134      * @dev Total amount of tokens in with a given id.
1135      */
1136     function totalSupply(uint256 id) public view virtual returns (uint256) {
1137         return _totalSupply[id];
1138     }
1139 
1140     /**
1141      * @dev Indicates whether any token exist with a given id, or not.
1142      */
1143     function exists(uint256 id) public view virtual returns (bool) {
1144         return ERC1155Supply.totalSupply(id) > 0;
1145     }
1146 
1147     /**
1148      * @dev See {ERC1155-_beforeTokenTransfer}.
1149      */
1150     function _beforeTokenTransfer(
1151         address operator,
1152         address from,
1153         address to,
1154         uint256[] memory ids,
1155         uint256[] memory amounts,
1156         bytes memory data
1157     ) internal virtual override {
1158         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1159 
1160         if (from == address(0)) {
1161             for (uint256 i = 0; i < ids.length; ++i) {
1162                 _totalSupply[ids[i]] += amounts[i];
1163             }
1164         }
1165 
1166         if (to == address(0)) {
1167             for (uint256 i = 0; i < ids.length; ++i) {
1168                 uint256 id = ids[i];
1169                 uint256 amount = amounts[i];
1170                 uint256 supply = _totalSupply[id];
1171                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1172                 unchecked {
1173                     _totalSupply[id] = supply - amount;
1174                 }
1175             }
1176         }
1177     }
1178 }
1179 
1180 // File: contracts/FLEX COLLAB.sol
1181 
1182 
1183 /*
1184  /$$$$$$$$ /$$       /$$$$$$$$ /$$   /$$        /$$$$$$  /$$       /$$$$$$$ 
1185 | $$_____/| $$      | $$_____/| $$  / $$       /$$__  $$| $$      | $$__  $$
1186 | $$      | $$      | $$      |  $$/ $$/      | $$  \__/| $$      | $$  \ $$
1187 | $$$$$   | $$      | $$$$$    \  $$$$/       | $$      | $$      | $$$$$$$ 
1188 | $$__/   | $$      | $$__/     >$$  $$       | $$      | $$      | $$__  $$
1189 | $$      | $$      | $$       /$$/\  $$      | $$    $$| $$      | $$  \ $$
1190 | $$      | $$$$$$$$| $$$$$$$$| $$  \ $$      |  $$$$$$/| $$$$$$$$| $$$$$$$/
1191 |__/      |________/|________/|__/  |__/       \______/ |________/|_______/ 
1192 */
1193 
1194 pragma solidity 0.8.7;
1195 
1196 
1197 
1198 contract FLEXCLB is ERC1155Supply, Ownable 
1199 {
1200     bool public saleIsActive = true;
1201     uint public activeBadgeId = 1;
1202     uint public maxPerTransaction = 999;
1203     uint public maxPerWallet = 999;
1204     uint public maxSupply = 1000;
1205     uint public constant NUMBER_RESERVED_TOKENS = 0;
1206     uint256 public constant PRICE = 200000000000000000;
1207     
1208     uint public reservedTokensMinted = 0;
1209     
1210     string public contractURIstr = "Flex x MBH";
1211 
1212     constructor() ERC1155("") {}
1213     
1214 
1215     function contractURI() public view returns (string memory) 
1216     {
1217        return contractURIstr;
1218     }
1219     
1220     function setContractURI(string memory newuri) external onlyOwner
1221     {
1222        contractURIstr = newuri;
1223     }
1224     
1225     function setURI(string memory newuri) external onlyOwner 
1226     {
1227         _setURI(newuri);
1228     }
1229     
1230     function mintToken(uint256 amount) external payable
1231     {
1232         require(msg.sender == tx.origin, "No transaction from smart contracts!");
1233         require(saleIsActive, "Sale must be active to mint");
1234         require(amount > 0 && amount <= maxPerTransaction, "Max per transaction reached, sale not allowed");
1235         require(balanceOf(msg.sender, activeBadgeId) + amount <= maxPerWallet, "Limit per wallet reached with this amount, sale not allowed");
1236         require(totalSupply(activeBadgeId) + amount <= maxSupply - (NUMBER_RESERVED_TOKENS - reservedTokensMinted), "Purchase would exceed max supply");
1237         require(msg.value >= PRICE * amount, "Not enough ETH for transaction");
1238 
1239         _mint(msg.sender, activeBadgeId, amount, "");
1240     }
1241     
1242     function mintReservedTokens(address to, uint256 amount) external onlyOwner 
1243     {
1244         require(reservedTokensMinted + amount <= NUMBER_RESERVED_TOKENS, "This amount is more than max allowed");
1245 
1246         _mint(to, activeBadgeId, amount, "");
1247         reservedTokensMinted = reservedTokensMinted + amount;
1248     }
1249     
1250     function withdraw() external 
1251     {
1252         payable(owner()).transfer(address(this).balance);
1253     }
1254     
1255     function flipSaleState() external onlyOwner 
1256     {
1257         saleIsActive = !saleIsActive;
1258     }
1259     
1260     function changeSaleDetails(uint _activeBadgeId, uint _maxPerTransaction, uint _maxPerWallet, uint _maxSupply) external onlyOwner 
1261     {
1262         activeBadgeId = _activeBadgeId;
1263         maxPerTransaction = _maxPerTransaction;
1264         maxPerWallet = _maxPerWallet;
1265         maxSupply = _maxSupply;
1266         saleIsActive = false;
1267     }
1268 }