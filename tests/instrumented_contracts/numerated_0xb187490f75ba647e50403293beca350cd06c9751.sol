1 // File: @openzeppelin/contracts@4.8.0/utils/Context.sol
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
28 // File: @openzeppelin/contracts@4.8.0/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts@4.8.0/utils/Address.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
117 
118 pragma solidity ^0.8.1;
119 
120 /**
121  * @dev Collection of functions related to the address type
122  */
123 library Address {
124     /**
125      * @dev Returns true if `account` is a contract.
126      *
127      * [IMPORTANT]
128      * ====
129      * It is unsafe to assume that an address for which this function returns
130      * false is an externally-owned account (EOA) and not a contract.
131      *
132      * Among others, `isContract` will return false for the following
133      * types of addresses:
134      *
135      *  - an externally-owned account
136      *  - a contract in construction
137      *  - an address where a contract will be created
138      *  - an address where a contract lived, but was destroyed
139      * ====
140      *
141      * [IMPORTANT]
142      * ====
143      * You shouldn't rely on `isContract` to protect against flash loan attacks!
144      *
145      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
146      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
147      * constructor.
148      * ====
149      */
150     function isContract(address account) internal view returns (bool) {
151         // This method relies on extcodesize/address.code.length, which returns 0
152         // for contracts in construction, since the code is only stored at the end
153         // of the constructor execution.
154 
155         return account.code.length > 0;
156     }
157 
158     /**
159      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
160      * `recipient`, forwarding all available gas and reverting on errors.
161      *
162      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
163      * of certain opcodes, possibly making contracts go over the 2300 gas limit
164      * imposed by `transfer`, making them unable to receive funds via
165      * `transfer`. {sendValue} removes this limitation.
166      *
167      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
168      *
169      * IMPORTANT: because control is transferred to `recipient`, care must be
170      * taken to not create reentrancy vulnerabilities. Consider using
171      * {ReentrancyGuard} or the
172      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
173      */
174     function sendValue(address payable recipient, uint256 amount) internal {
175         require(address(this).balance >= amount, "Address: insufficient balance");
176 
177         (bool success, ) = recipient.call{value: amount}("");
178         require(success, "Address: unable to send value, recipient may have reverted");
179     }
180 
181     /**
182      * @dev Performs a Solidity function call using a low level `call`. A
183      * plain `call` is an unsafe replacement for a function call: use this
184      * function instead.
185      *
186      * If `target` reverts with a revert reason, it is bubbled up by this
187      * function (like regular Solidity function calls).
188      *
189      * Returns the raw returned data. To convert to the expected return value,
190      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
191      *
192      * Requirements:
193      *
194      * - `target` must be a contract.
195      * - calling `target` with `data` must not revert.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
205      * `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         return functionCallWithValue(target, data, 0, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but also transferring `value` wei to `target`.
220      *
221      * Requirements:
222      *
223      * - the calling contract must have an ETH balance of at least `value`.
224      * - the called Solidity function must be `payable`.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
238      * with `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(
243         address target,
244         bytes memory data,
245         uint256 value,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         require(address(this).balance >= value, "Address: insufficient balance for call");
249         (bool success, bytes memory returndata) = target.call{value: value}(data);
250         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
260         return functionStaticCall(target, data, "Address: low-level static call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
265      * but performing a static call.
266      *
267      * _Available since v3.3._
268      */
269     function functionStaticCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal view returns (bytes memory) {
274         (bool success, bytes memory returndata) = target.staticcall(data);
275         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a delegate call.
291      *
292      * _Available since v3.4._
293      */
294     function functionDelegateCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         (bool success, bytes memory returndata) = target.delegatecall(data);
300         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
305      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
306      *
307      * _Available since v4.8._
308      */
309     function verifyCallResultFromTarget(
310         address target,
311         bool success,
312         bytes memory returndata,
313         string memory errorMessage
314     ) internal view returns (bytes memory) {
315         if (success) {
316             if (returndata.length == 0) {
317                 // only check isContract if the call was successful and the return data is empty
318                 // otherwise we already know that it was a contract
319                 require(isContract(target), "Address: call to non-contract");
320             }
321             return returndata;
322         } else {
323             _revert(returndata, errorMessage);
324         }
325     }
326 
327     /**
328      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
329      * revert reason or using the provided one.
330      *
331      * _Available since v4.3._
332      */
333     function verifyCallResult(
334         bool success,
335         bytes memory returndata,
336         string memory errorMessage
337     ) internal pure returns (bytes memory) {
338         if (success) {
339             return returndata;
340         } else {
341             _revert(returndata, errorMessage);
342         }
343     }
344 
345     function _revert(bytes memory returndata, string memory errorMessage) private pure {
346         // Look for revert reason and bubble it up if present
347         if (returndata.length > 0) {
348             // The easiest way to bubble the revert reason is using memory via assembly
349             /// @solidity memory-safe-assembly
350             assembly {
351                 let returndata_size := mload(returndata)
352                 revert(add(32, returndata), returndata_size)
353             }
354         } else {
355             revert(errorMessage);
356         }
357     }
358 }
359 
360 // File: @openzeppelin/contracts@4.8.0/utils/introspection/IERC165.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Interface of the ERC165 standard, as defined in the
369  * https://eips.ethereum.org/EIPS/eip-165[EIP].
370  *
371  * Implementers can declare support of contract interfaces, which can then be
372  * queried by others ({ERC165Checker}).
373  *
374  * For an implementation, see {ERC165}.
375  */
376 interface IERC165 {
377     /**
378      * @dev Returns true if this contract implements the interface defined by
379      * `interfaceId`. See the corresponding
380      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
381      * to learn more about how these ids are created.
382      *
383      * This function call must use less than 30 000 gas.
384      */
385     function supportsInterface(bytes4 interfaceId) external view returns (bool);
386 }
387 
388 // File: @openzeppelin/contracts@4.8.0/utils/introspection/ERC165.sol
389 
390 
391 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 
396 /**
397  * @dev Implementation of the {IERC165} interface.
398  *
399  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
400  * for the additional interface id that will be supported. For example:
401  *
402  * ```solidity
403  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
404  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
405  * }
406  * ```
407  *
408  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
409  */
410 abstract contract ERC165 is IERC165 {
411     /**
412      * @dev See {IERC165-supportsInterface}.
413      */
414     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
415         return interfaceId == type(IERC165).interfaceId;
416     }
417 }
418 
419 // File: @openzeppelin/contracts@4.8.0/token/ERC1155/IERC1155Receiver.sol
420 
421 
422 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 
427 /**
428  * @dev _Available since v3.1._
429  */
430 interface IERC1155Receiver is IERC165 {
431     /**
432      * @dev Handles the receipt of a single ERC1155 token type. This function is
433      * called at the end of a `safeTransferFrom` after the balance has been updated.
434      *
435      * NOTE: To accept the transfer, this must return
436      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
437      * (i.e. 0xf23a6e61, or its own function selector).
438      *
439      * @param operator The address which initiated the transfer (i.e. msg.sender)
440      * @param from The address which previously owned the token
441      * @param id The ID of the token being transferred
442      * @param value The amount of tokens being transferred
443      * @param data Additional data with no specified format
444      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
445      */
446     function onERC1155Received(
447         address operator,
448         address from,
449         uint256 id,
450         uint256 value,
451         bytes calldata data
452     ) external returns (bytes4);
453 
454     /**
455      * @dev Handles the receipt of a multiple ERC1155 token types. This function
456      * is called at the end of a `safeBatchTransferFrom` after the balances have
457      * been updated.
458      *
459      * NOTE: To accept the transfer(s), this must return
460      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
461      * (i.e. 0xbc197c81, or its own function selector).
462      *
463      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
464      * @param from The address which previously owned the token
465      * @param ids An array containing ids of each token being transferred (order and length must match values array)
466      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
467      * @param data Additional data with no specified format
468      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
469      */
470     function onERC1155BatchReceived(
471         address operator,
472         address from,
473         uint256[] calldata ids,
474         uint256[] calldata values,
475         bytes calldata data
476     ) external returns (bytes4);
477 }
478 
479 // File: @openzeppelin/contracts@4.8.0/token/ERC1155/IERC1155.sol
480 
481 
482 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 
487 /**
488  * @dev Required interface of an ERC1155 compliant contract, as defined in the
489  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
490  *
491  * _Available since v3.1._
492  */
493 interface IERC1155 is IERC165 {
494     /**
495      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
496      */
497     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
498 
499     /**
500      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
501      * transfers.
502      */
503     event TransferBatch(
504         address indexed operator,
505         address indexed from,
506         address indexed to,
507         uint256[] ids,
508         uint256[] values
509     );
510 
511     /**
512      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
513      * `approved`.
514      */
515     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
516 
517     /**
518      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
519      *
520      * If an {URI} event was emitted for `id`, the standard
521      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
522      * returned by {IERC1155MetadataURI-uri}.
523      */
524     event URI(string value, uint256 indexed id);
525 
526     /**
527      * @dev Returns the amount of tokens of token type `id` owned by `account`.
528      *
529      * Requirements:
530      *
531      * - `account` cannot be the zero address.
532      */
533     function balanceOf(address account, uint256 id) external view returns (uint256);
534 
535     /**
536      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
537      *
538      * Requirements:
539      *
540      * - `accounts` and `ids` must have the same length.
541      */
542     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
543         external
544         view
545         returns (uint256[] memory);
546 
547     /**
548      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
549      *
550      * Emits an {ApprovalForAll} event.
551      *
552      * Requirements:
553      *
554      * - `operator` cannot be the caller.
555      */
556     function setApprovalForAll(address operator, bool approved) external;
557 
558     /**
559      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
560      *
561      * See {setApprovalForAll}.
562      */
563     function isApprovedForAll(address account, address operator) external view returns (bool);
564 
565     /**
566      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
567      *
568      * Emits a {TransferSingle} event.
569      *
570      * Requirements:
571      *
572      * - `to` cannot be the zero address.
573      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
574      * - `from` must have a balance of tokens of type `id` of at least `amount`.
575      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
576      * acceptance magic value.
577      */
578     function safeTransferFrom(
579         address from,
580         address to,
581         uint256 id,
582         uint256 amount,
583         bytes calldata data
584     ) external;
585 
586     /**
587      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
588      *
589      * Emits a {TransferBatch} event.
590      *
591      * Requirements:
592      *
593      * - `ids` and `amounts` must have the same length.
594      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
595      * acceptance magic value.
596      */
597     function safeBatchTransferFrom(
598         address from,
599         address to,
600         uint256[] calldata ids,
601         uint256[] calldata amounts,
602         bytes calldata data
603     ) external;
604 }
605 
606 // File: @openzeppelin/contracts@4.8.0/token/ERC1155/extensions/IERC1155MetadataURI.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
616  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
617  *
618  * _Available since v3.1._
619  */
620 interface IERC1155MetadataURI is IERC1155 {
621     /**
622      * @dev Returns the URI for token type `id`.
623      *
624      * If the `\{id\}` substring is present in the URI, it must be replaced by
625      * clients with the actual token type ID.
626      */
627     function uri(uint256 id) external view returns (string memory);
628 }
629 
630 // File: @openzeppelin/contracts@4.8.0/token/ERC1155/ERC1155.sol
631 
632 
633 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 
639 
640 
641 
642 
643 /**
644  * @dev Implementation of the basic standard multi-token.
645  * See https://eips.ethereum.org/EIPS/eip-1155
646  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
647  *
648  * _Available since v3.1._
649  */
650 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
651     using Address for address;
652 
653     // Mapping from token ID to account balances
654     mapping(uint256 => mapping(address => uint256)) private _balances;
655 
656     // Mapping from account to operator approvals
657     mapping(address => mapping(address => bool)) private _operatorApprovals;
658 
659     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
660     string private _uri;
661 
662     /**
663      * @dev See {_setURI}.
664      */
665     constructor(string memory uri_) {
666         _setURI(uri_);
667     }
668 
669     /**
670      * @dev See {IERC165-supportsInterface}.
671      */
672     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
673         return
674             interfaceId == type(IERC1155).interfaceId ||
675             interfaceId == type(IERC1155MetadataURI).interfaceId ||
676             super.supportsInterface(interfaceId);
677     }
678 
679     /**
680      * @dev See {IERC1155MetadataURI-uri}.
681      *
682      * This implementation returns the same URI for *all* token types. It relies
683      * on the token type ID substitution mechanism
684      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
685      *
686      * Clients calling this function must replace the `\{id\}` substring with the
687      * actual token type ID.
688      */
689     function uri(uint256) public view virtual override returns (string memory) {
690         return _uri;
691     }
692 
693     /**
694      * @dev See {IERC1155-balanceOf}.
695      *
696      * Requirements:
697      *
698      * - `account` cannot be the zero address.
699      */
700     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
701         require(account != address(0), "ERC1155: address zero is not a valid owner");
702         return _balances[id][account];
703     }
704 
705     /**
706      * @dev See {IERC1155-balanceOfBatch}.
707      *
708      * Requirements:
709      *
710      * - `accounts` and `ids` must have the same length.
711      */
712     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
713         public
714         view
715         virtual
716         override
717         returns (uint256[] memory)
718     {
719         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
720 
721         uint256[] memory batchBalances = new uint256[](accounts.length);
722 
723         for (uint256 i = 0; i < accounts.length; ++i) {
724             batchBalances[i] = balanceOf(accounts[i], ids[i]);
725         }
726 
727         return batchBalances;
728     }
729 
730     /**
731      * @dev See {IERC1155-setApprovalForAll}.
732      */
733     function setApprovalForAll(address operator, bool approved) public virtual override {
734         _setApprovalForAll(_msgSender(), operator, approved);
735     }
736 
737     /**
738      * @dev See {IERC1155-isApprovedForAll}.
739      */
740     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
741         return _operatorApprovals[account][operator];
742     }
743 
744     /**
745      * @dev See {IERC1155-safeTransferFrom}.
746      */
747     function safeTransferFrom(
748         address from,
749         address to,
750         uint256 id,
751         uint256 amount,
752         bytes memory data
753     ) public virtual override {
754         require(
755             from == _msgSender() || isApprovedForAll(from, _msgSender()),
756             "ERC1155: caller is not token owner or approved"
757         );
758         _safeTransferFrom(from, to, id, amount, data);
759     }
760 
761     /**
762      * @dev See {IERC1155-safeBatchTransferFrom}.
763      */
764     function safeBatchTransferFrom(
765         address from,
766         address to,
767         uint256[] memory ids,
768         uint256[] memory amounts,
769         bytes memory data
770     ) public virtual override {
771         require(
772             from == _msgSender() || isApprovedForAll(from, _msgSender()),
773             "ERC1155: caller is not token owner or approved"
774         );
775         _safeBatchTransferFrom(from, to, ids, amounts, data);
776     }
777 
778     /**
779      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
780      *
781      * Emits a {TransferSingle} event.
782      *
783      * Requirements:
784      *
785      * - `to` cannot be the zero address.
786      * - `from` must have a balance of tokens of type `id` of at least `amount`.
787      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
788      * acceptance magic value.
789      */
790     function _safeTransferFrom(
791         address from,
792         address to,
793         uint256 id,
794         uint256 amount,
795         bytes memory data
796     ) internal virtual {
797         require(to != address(0), "ERC1155: transfer to the zero address");
798 
799         address operator = _msgSender();
800         uint256[] memory ids = _asSingletonArray(id);
801         uint256[] memory amounts = _asSingletonArray(amount);
802 
803         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
804 
805         uint256 fromBalance = _balances[id][from];
806         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
807         unchecked {
808             _balances[id][from] = fromBalance - amount;
809         }
810         _balances[id][to] += amount;
811 
812         emit TransferSingle(operator, from, to, id, amount);
813 
814         _afterTokenTransfer(operator, from, to, ids, amounts, data);
815 
816         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
817     }
818 
819     /**
820      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
821      *
822      * Emits a {TransferBatch} event.
823      *
824      * Requirements:
825      *
826      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
827      * acceptance magic value.
828      */
829     function _safeBatchTransferFrom(
830         address from,
831         address to,
832         uint256[] memory ids,
833         uint256[] memory amounts,
834         bytes memory data
835     ) internal virtual {
836         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
837         require(to != address(0), "ERC1155: transfer to the zero address");
838 
839         address operator = _msgSender();
840 
841         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
842 
843         for (uint256 i = 0; i < ids.length; ++i) {
844             uint256 id = ids[i];
845             uint256 amount = amounts[i];
846 
847             uint256 fromBalance = _balances[id][from];
848             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
849             unchecked {
850                 _balances[id][from] = fromBalance - amount;
851             }
852             _balances[id][to] += amount;
853         }
854 
855         emit TransferBatch(operator, from, to, ids, amounts);
856 
857         _afterTokenTransfer(operator, from, to, ids, amounts, data);
858 
859         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
860     }
861 
862     /**
863      * @dev Sets a new URI for all token types, by relying on the token type ID
864      * substitution mechanism
865      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
866      *
867      * By this mechanism, any occurrence of the `\{id\}` substring in either the
868      * URI or any of the amounts in the JSON file at said URI will be replaced by
869      * clients with the token type ID.
870      *
871      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
872      * interpreted by clients as
873      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
874      * for token type ID 0x4cce0.
875      *
876      * See {uri}.
877      *
878      * Because these URIs cannot be meaningfully represented by the {URI} event,
879      * this function emits no events.
880      */
881     function _setURI(string memory newuri) internal virtual {
882         _uri = newuri;
883     }
884 
885     /**
886      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
887      *
888      * Emits a {TransferSingle} event.
889      *
890      * Requirements:
891      *
892      * - `to` cannot be the zero address.
893      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
894      * acceptance magic value.
895      */
896     function _mint(
897         address to,
898         uint256 id,
899         uint256 amount,
900         bytes memory data
901     ) internal virtual {
902         require(to != address(0), "ERC1155: mint to the zero address");
903 
904         address operator = _msgSender();
905         uint256[] memory ids = _asSingletonArray(id);
906         uint256[] memory amounts = _asSingletonArray(amount);
907 
908         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
909 
910         _balances[id][to] += amount;
911         emit TransferSingle(operator, address(0), to, id, amount);
912 
913         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
914 
915         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
916     }
917 
918     /**
919      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
920      *
921      * Emits a {TransferBatch} event.
922      *
923      * Requirements:
924      *
925      * - `ids` and `amounts` must have the same length.
926      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
927      * acceptance magic value.
928      */
929     function _mintBatch(
930         address to,
931         uint256[] memory ids,
932         uint256[] memory amounts,
933         bytes memory data
934     ) internal virtual {
935         require(to != address(0), "ERC1155: mint to the zero address");
936         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
937 
938         address operator = _msgSender();
939 
940         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
941 
942         for (uint256 i = 0; i < ids.length; i++) {
943             _balances[ids[i]][to] += amounts[i];
944         }
945 
946         emit TransferBatch(operator, address(0), to, ids, amounts);
947 
948         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
949 
950         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
951     }
952 
953     /**
954      * @dev Destroys `amount` tokens of token type `id` from `from`
955      *
956      * Emits a {TransferSingle} event.
957      *
958      * Requirements:
959      *
960      * - `from` cannot be the zero address.
961      * - `from` must have at least `amount` tokens of token type `id`.
962      */
963     function _burn(
964         address from,
965         uint256 id,
966         uint256 amount
967     ) internal virtual {
968         require(from != address(0), "ERC1155: burn from the zero address");
969 
970         address operator = _msgSender();
971         uint256[] memory ids = _asSingletonArray(id);
972         uint256[] memory amounts = _asSingletonArray(amount);
973 
974         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
975 
976         uint256 fromBalance = _balances[id][from];
977         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
978         unchecked {
979             _balances[id][from] = fromBalance - amount;
980         }
981 
982         emit TransferSingle(operator, from, address(0), id, amount);
983 
984         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
985     }
986 
987     /**
988      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
989      *
990      * Emits a {TransferBatch} event.
991      *
992      * Requirements:
993      *
994      * - `ids` and `amounts` must have the same length.
995      */
996     function _burnBatch(
997         address from,
998         uint256[] memory ids,
999         uint256[] memory amounts
1000     ) internal virtual {
1001         require(from != address(0), "ERC1155: burn from the zero address");
1002         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
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
1013             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1014             unchecked {
1015                 _balances[id][from] = fromBalance - amount;
1016             }
1017         }
1018 
1019         emit TransferBatch(operator, from, address(0), ids, amounts);
1020 
1021         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1022     }
1023 
1024     /**
1025      * @dev Approve `operator` to operate on all of `owner` tokens
1026      *
1027      * Emits an {ApprovalForAll} event.
1028      */
1029     function _setApprovalForAll(
1030         address owner,
1031         address operator,
1032         bool approved
1033     ) internal virtual {
1034         require(owner != operator, "ERC1155: setting approval status for self");
1035         _operatorApprovals[owner][operator] = approved;
1036         emit ApprovalForAll(owner, operator, approved);
1037     }
1038 
1039     /**
1040      * @dev Hook that is called before any token transfer. This includes minting
1041      * and burning, as well as batched variants.
1042      *
1043      * The same hook is called on both single and batched variants. For single
1044      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1045      *
1046      * Calling conditions (for each `id` and `amount` pair):
1047      *
1048      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1049      * of token type `id` will be  transferred to `to`.
1050      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1051      * for `to`.
1052      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1053      * will be burned.
1054      * - `from` and `to` are never both zero.
1055      * - `ids` and `amounts` have the same, non-zero length.
1056      *
1057      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1058      */
1059     function _beforeTokenTransfer(
1060         address operator,
1061         address from,
1062         address to,
1063         uint256[] memory ids,
1064         uint256[] memory amounts,
1065         bytes memory data
1066     ) internal virtual {}
1067 
1068     /**
1069      * @dev Hook that is called after any token transfer. This includes minting
1070      * and burning, as well as batched variants.
1071      *
1072      * The same hook is called on both single and batched variants. For single
1073      * transfers, the length of the `id` and `amount` arrays will be 1.
1074      *
1075      * Calling conditions (for each `id` and `amount` pair):
1076      *
1077      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1078      * of token type `id` will be  transferred to `to`.
1079      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1080      * for `to`.
1081      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1082      * will be burned.
1083      * - `from` and `to` are never both zero.
1084      * - `ids` and `amounts` have the same, non-zero length.
1085      *
1086      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1087      */
1088     function _afterTokenTransfer(
1089         address operator,
1090         address from,
1091         address to,
1092         uint256[] memory ids,
1093         uint256[] memory amounts,
1094         bytes memory data
1095     ) internal virtual {}
1096 
1097     function _doSafeTransferAcceptanceCheck(
1098         address operator,
1099         address from,
1100         address to,
1101         uint256 id,
1102         uint256 amount,
1103         bytes memory data
1104     ) private {
1105         if (to.isContract()) {
1106             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1107                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1108                     revert("ERC1155: ERC1155Receiver rejected tokens");
1109                 }
1110             } catch Error(string memory reason) {
1111                 revert(reason);
1112             } catch {
1113                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1114             }
1115         }
1116     }
1117 
1118     function _doSafeBatchTransferAcceptanceCheck(
1119         address operator,
1120         address from,
1121         address to,
1122         uint256[] memory ids,
1123         uint256[] memory amounts,
1124         bytes memory data
1125     ) private {
1126         if (to.isContract()) {
1127             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1128                 bytes4 response
1129             ) {
1130                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1131                     revert("ERC1155: ERC1155Receiver rejected tokens");
1132                 }
1133             } catch Error(string memory reason) {
1134                 revert(reason);
1135             } catch {
1136                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1137             }
1138         }
1139     }
1140 
1141     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1142         uint256[] memory array = new uint256[](1);
1143         array[0] = element;
1144 
1145         return array;
1146     }
1147 }
1148 
1149 // File: @openzeppelin/contracts@4.8.0/token/ERC1155/extensions/ERC1155Burnable.sol
1150 
1151 
1152 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
1153 
1154 pragma solidity ^0.8.0;
1155 
1156 
1157 /**
1158  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1159  * own tokens and those that they have been approved to use.
1160  *
1161  * _Available since v3.1._
1162  */
1163 abstract contract ERC1155Burnable is ERC1155 {
1164     function burn(
1165         address account,
1166         uint256 id,
1167         uint256 value
1168     ) public virtual {
1169         require(
1170             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1171             "ERC1155: caller is not token owner or approved"
1172         );
1173 
1174         _burn(account, id, value);
1175     }
1176 
1177     function burnBatch(
1178         address account,
1179         uint256[] memory ids,
1180         uint256[] memory values
1181     ) public virtual {
1182         require(
1183             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1184             "ERC1155: caller is not token owner or approved"
1185         );
1186 
1187         _burnBatch(account, ids, values);
1188     }
1189 }
1190 
1191 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1192 
1193 
1194 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1195 
1196 pragma solidity ^0.8.0;
1197 
1198 /**
1199  * @dev Interface of the ERC20 standard as defined in the EIP.
1200  */
1201 interface IERC20 {
1202     /**
1203      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1204      * another (`to`).
1205      *
1206      * Note that `value` may be zero.
1207      */
1208     event Transfer(address indexed from, address indexed to, uint256 value);
1209 
1210     /**
1211      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1212      * a call to {approve}. `value` is the new allowance.
1213      */
1214     event Approval(address indexed owner, address indexed spender, uint256 value);
1215 
1216     /**
1217      * @dev Returns the amount of tokens in existence.
1218      */
1219     function totalSupply() external view returns (uint256);
1220 
1221     /**
1222      * @dev Returns the amount of tokens owned by `account`.
1223      */
1224     function balanceOf(address account) external view returns (uint256);
1225 
1226     /**
1227      * @dev Moves `amount` tokens from the caller's account to `to`.
1228      *
1229      * Returns a boolean value indicating whether the operation succeeded.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function transfer(address to, uint256 amount) external returns (bool);
1234 
1235     /**
1236      * @dev Returns the remaining number of tokens that `spender` will be
1237      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1238      * zero by default.
1239      *
1240      * This value changes when {approve} or {transferFrom} are called.
1241      */
1242     function allowance(address owner, address spender) external view returns (uint256);
1243 
1244     /**
1245      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1246      *
1247      * Returns a boolean value indicating whether the operation succeeded.
1248      *
1249      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1250      * that someone may use both the old and the new allowance by unfortunate
1251      * transaction ordering. One possible solution to mitigate this race
1252      * condition is to first reduce the spender's allowance to 0 and set the
1253      * desired value afterwards:
1254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1255      *
1256      * Emits an {Approval} event.
1257      */
1258     function approve(address spender, uint256 amount) external returns (bool);
1259 
1260     /**
1261      * @dev Moves `amount` tokens from `from` to `to` using the
1262      * allowance mechanism. `amount` is then deducted from the caller's
1263      * allowance.
1264      *
1265      * Returns a boolean value indicating whether the operation succeeded.
1266      *
1267      * Emits a {Transfer} event.
1268      */
1269     function transferFrom(
1270         address from,
1271         address to,
1272         uint256 amount
1273     ) external returns (bool);
1274 }
1275 
1276 // File: @openzeppelin/contracts/utils/math/Math.sol
1277 
1278 
1279 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1280 
1281 pragma solidity ^0.8.0;
1282 
1283 /**
1284  * @dev Standard math utilities missing in the Solidity language.
1285  */
1286 library Math {
1287     enum Rounding {
1288         Down, // Toward negative infinity
1289         Up, // Toward infinity
1290         Zero // Toward zero
1291     }
1292 
1293     /**
1294      * @dev Returns the largest of two numbers.
1295      */
1296     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1297         return a > b ? a : b;
1298     }
1299 
1300     /**
1301      * @dev Returns the smallest of two numbers.
1302      */
1303     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1304         return a < b ? a : b;
1305     }
1306 
1307     /**
1308      * @dev Returns the average of two numbers. The result is rounded towards
1309      * zero.
1310      */
1311     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1312         // (a + b) / 2 can overflow.
1313         return (a & b) + (a ^ b) / 2;
1314     }
1315 
1316     /**
1317      * @dev Returns the ceiling of the division of two numbers.
1318      *
1319      * This differs from standard division with `/` in that it rounds up instead
1320      * of rounding down.
1321      */
1322     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1323         // (a + b - 1) / b can overflow on addition, so we distribute.
1324         return a == 0 ? 0 : (a - 1) / b + 1;
1325     }
1326 
1327     /**
1328      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1329      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1330      * with further edits by Uniswap Labs also under MIT license.
1331      */
1332     function mulDiv(
1333         uint256 x,
1334         uint256 y,
1335         uint256 denominator
1336     ) internal pure returns (uint256 result) {
1337         unchecked {
1338             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1339             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1340             // variables such that product = prod1 * 2^256 + prod0.
1341             uint256 prod0; // Least significant 256 bits of the product
1342             uint256 prod1; // Most significant 256 bits of the product
1343             assembly {
1344                 let mm := mulmod(x, y, not(0))
1345                 prod0 := mul(x, y)
1346                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1347             }
1348 
1349             // Handle non-overflow cases, 256 by 256 division.
1350             if (prod1 == 0) {
1351                 return prod0 / denominator;
1352             }
1353 
1354             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1355             require(denominator > prod1);
1356 
1357             ///////////////////////////////////////////////
1358             // 512 by 256 division.
1359             ///////////////////////////////////////////////
1360 
1361             // Make division exact by subtracting the remainder from [prod1 prod0].
1362             uint256 remainder;
1363             assembly {
1364                 // Compute remainder using mulmod.
1365                 remainder := mulmod(x, y, denominator)
1366 
1367                 // Subtract 256 bit number from 512 bit number.
1368                 prod1 := sub(prod1, gt(remainder, prod0))
1369                 prod0 := sub(prod0, remainder)
1370             }
1371 
1372             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1373             // See https://cs.stackexchange.com/q/138556/92363.
1374 
1375             // Does not overflow because the denominator cannot be zero at this stage in the function.
1376             uint256 twos = denominator & (~denominator + 1);
1377             assembly {
1378                 // Divide denominator by twos.
1379                 denominator := div(denominator, twos)
1380 
1381                 // Divide [prod1 prod0] by twos.
1382                 prod0 := div(prod0, twos)
1383 
1384                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1385                 twos := add(div(sub(0, twos), twos), 1)
1386             }
1387 
1388             // Shift in bits from prod1 into prod0.
1389             prod0 |= prod1 * twos;
1390 
1391             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1392             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1393             // four bits. That is, denominator * inv = 1 mod 2^4.
1394             uint256 inverse = (3 * denominator) ^ 2;
1395 
1396             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1397             // in modular arithmetic, doubling the correct bits in each step.
1398             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1399             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1400             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1401             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1402             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1403             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1404 
1405             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1406             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1407             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1408             // is no longer required.
1409             result = prod0 * inverse;
1410             return result;
1411         }
1412     }
1413 
1414     /**
1415      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1416      */
1417     function mulDiv(
1418         uint256 x,
1419         uint256 y,
1420         uint256 denominator,
1421         Rounding rounding
1422     ) internal pure returns (uint256) {
1423         uint256 result = mulDiv(x, y, denominator);
1424         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1425             result += 1;
1426         }
1427         return result;
1428     }
1429 
1430     /**
1431      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1432      *
1433      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1434      */
1435     function sqrt(uint256 a) internal pure returns (uint256) {
1436         if (a == 0) {
1437             return 0;
1438         }
1439 
1440         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1441         //
1442         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1443         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1444         //
1445         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1446         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1447         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1448         //
1449         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1450         uint256 result = 1 << (log2(a) >> 1);
1451 
1452         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1453         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1454         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1455         // into the expected uint128 result.
1456         unchecked {
1457             result = (result + a / result) >> 1;
1458             result = (result + a / result) >> 1;
1459             result = (result + a / result) >> 1;
1460             result = (result + a / result) >> 1;
1461             result = (result + a / result) >> 1;
1462             result = (result + a / result) >> 1;
1463             result = (result + a / result) >> 1;
1464             return min(result, a / result);
1465         }
1466     }
1467 
1468     /**
1469      * @notice Calculates sqrt(a), following the selected rounding direction.
1470      */
1471     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1472         unchecked {
1473             uint256 result = sqrt(a);
1474             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1475         }
1476     }
1477 
1478     /**
1479      * @dev Return the log in base 2, rounded down, of a positive value.
1480      * Returns 0 if given 0.
1481      */
1482     function log2(uint256 value) internal pure returns (uint256) {
1483         uint256 result = 0;
1484         unchecked {
1485             if (value >> 128 > 0) {
1486                 value >>= 128;
1487                 result += 128;
1488             }
1489             if (value >> 64 > 0) {
1490                 value >>= 64;
1491                 result += 64;
1492             }
1493             if (value >> 32 > 0) {
1494                 value >>= 32;
1495                 result += 32;
1496             }
1497             if (value >> 16 > 0) {
1498                 value >>= 16;
1499                 result += 16;
1500             }
1501             if (value >> 8 > 0) {
1502                 value >>= 8;
1503                 result += 8;
1504             }
1505             if (value >> 4 > 0) {
1506                 value >>= 4;
1507                 result += 4;
1508             }
1509             if (value >> 2 > 0) {
1510                 value >>= 2;
1511                 result += 2;
1512             }
1513             if (value >> 1 > 0) {
1514                 result += 1;
1515             }
1516         }
1517         return result;
1518     }
1519 
1520     /**
1521      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1522      * Returns 0 if given 0.
1523      */
1524     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1525         unchecked {
1526             uint256 result = log2(value);
1527             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1528         }
1529     }
1530 
1531     /**
1532      * @dev Return the log in base 10, rounded down, of a positive value.
1533      * Returns 0 if given 0.
1534      */
1535     function log10(uint256 value) internal pure returns (uint256) {
1536         uint256 result = 0;
1537         unchecked {
1538             if (value >= 10**64) {
1539                 value /= 10**64;
1540                 result += 64;
1541             }
1542             if (value >= 10**32) {
1543                 value /= 10**32;
1544                 result += 32;
1545             }
1546             if (value >= 10**16) {
1547                 value /= 10**16;
1548                 result += 16;
1549             }
1550             if (value >= 10**8) {
1551                 value /= 10**8;
1552                 result += 8;
1553             }
1554             if (value >= 10**4) {
1555                 value /= 10**4;
1556                 result += 4;
1557             }
1558             if (value >= 10**2) {
1559                 value /= 10**2;
1560                 result += 2;
1561             }
1562             if (value >= 10**1) {
1563                 result += 1;
1564             }
1565         }
1566         return result;
1567     }
1568 
1569     /**
1570      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1571      * Returns 0 if given 0.
1572      */
1573     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1574         unchecked {
1575             uint256 result = log10(value);
1576             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1577         }
1578     }
1579 
1580     /**
1581      * @dev Return the log in base 256, rounded down, of a positive value.
1582      * Returns 0 if given 0.
1583      *
1584      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1585      */
1586     function log256(uint256 value) internal pure returns (uint256) {
1587         uint256 result = 0;
1588         unchecked {
1589             if (value >> 128 > 0) {
1590                 value >>= 128;
1591                 result += 16;
1592             }
1593             if (value >> 64 > 0) {
1594                 value >>= 64;
1595                 result += 8;
1596             }
1597             if (value >> 32 > 0) {
1598                 value >>= 32;
1599                 result += 4;
1600             }
1601             if (value >> 16 > 0) {
1602                 value >>= 16;
1603                 result += 2;
1604             }
1605             if (value >> 8 > 0) {
1606                 result += 1;
1607             }
1608         }
1609         return result;
1610     }
1611 
1612     /**
1613      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1614      * Returns 0 if given 0.
1615      */
1616     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1617         unchecked {
1618             uint256 result = log256(value);
1619             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1620         }
1621     }
1622 }
1623 
1624 // File: @openzeppelin/contracts/utils/Strings.sol
1625 
1626 
1627 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1628 
1629 pragma solidity ^0.8.0;
1630 
1631 
1632 /**
1633  * @dev String operations.
1634  */
1635 library Strings {
1636     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1637     uint8 private constant _ADDRESS_LENGTH = 20;
1638 
1639     /**
1640      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1641      */
1642     function toString(uint256 value) internal pure returns (string memory) {
1643         unchecked {
1644             uint256 length = Math.log10(value) + 1;
1645             string memory buffer = new string(length);
1646             uint256 ptr;
1647             /// @solidity memory-safe-assembly
1648             assembly {
1649                 ptr := add(buffer, add(32, length))
1650             }
1651             while (true) {
1652                 ptr--;
1653                 /// @solidity memory-safe-assembly
1654                 assembly {
1655                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1656                 }
1657                 value /= 10;
1658                 if (value == 0) break;
1659             }
1660             return buffer;
1661         }
1662     }
1663 
1664     /**
1665      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1666      */
1667     function toHexString(uint256 value) internal pure returns (string memory) {
1668         unchecked {
1669             return toHexString(value, Math.log256(value) + 1);
1670         }
1671     }
1672 
1673     /**
1674      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1675      */
1676     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1677         bytes memory buffer = new bytes(2 * length + 2);
1678         buffer[0] = "0";
1679         buffer[1] = "x";
1680         for (uint256 i = 2 * length + 1; i > 1; --i) {
1681             buffer[i] = _SYMBOLS[value & 0xf];
1682             value >>= 4;
1683         }
1684         require(value == 0, "Strings: hex length insufficient");
1685         return string(buffer);
1686     }
1687 
1688     /**
1689      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1690      */
1691     function toHexString(address addr) internal pure returns (string memory) {
1692         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1693     }
1694 }
1695 
1696 // File: NFTBigpartner.sol
1697 
1698 
1699 // developed by Bartersmart.co.th 
1700 pragma solidity ^0.8.9;
1701 
1702 
1703 
1704 
1705 
1706 
1707 contract NFTBIGPARTNER is ERC1155, Ownable, ERC1155Burnable {
1708     IERC20 public BIGP;
1709     constructor(address _BigPointAddr) ERC1155("https://bartersmart.co.th/NFT/{id}.json") {
1710         BIGP = IERC20(_BigPointAddr);
1711     }
1712 
1713     function setURI(string memory newuri) public onlyOwner {
1714         _setURI(newuri);
1715     }
1716 
1717     function mint(address account, uint256 id, uint256 amount, bytes memory data)
1718         public
1719         
1720     {
1721         require(msg.sender==rightperson);
1722         _mint(account, id, amount, data);
1723     }
1724 
1725     uint256 public rate1 = 300000000000000000000; //1x
1726     uint256 public rate2 = 3000000000000000000000; //10x   
1727     uint256 public rate3 = 15000000000000000000000; //50x
1728     uint256 public rate4 = 30000000000000000000000; //100x      
1729 
1730     
1731     uint256 public Batch_id =0;
1732     uint public BigPAmount;
1733 
1734    
1735     mapping(uint256=>uint256) public ReleasedTime;
1736     mapping(uint256=>address) public MintAddr;
1737     mapping(uint256=>uint256) public Deposited;
1738     
1739     mapping(uint256=>uint256) public CardAmount1;
1740     mapping(uint256=>uint256) public CardAmount2;
1741     mapping(uint256=>uint256) public CardAmount3;
1742     mapping(uint256=>uint256) public CardAmount4;
1743     
1744 
1745     mapping(uint256=>uint256) public CardSupplies;
1746 
1747     function MintBSCard (uint256 _cardsNum1, uint256 _cardsNum2,uint256 _cardsNum3, uint256 _cardsNum4 )public returns(uint,address,uint,uint,uint,uint,uint,uint){
1748         
1749         BigPAmount =(rate1*_cardsNum1)+(rate2*_cardsNum2)+(rate3*_cardsNum3)+(rate4*_cardsNum4);
1750         
1751        
1752         BIGP.transferFrom(msg.sender, address(this),BigPAmount);
1753         if(_cardsNum1>0){
1754         _mint(msg.sender,1,_cardsNum1,"0x");
1755         CardSupplies[1] =CardSupplies[1]+ _cardsNum1;
1756         }
1757 
1758         if(_cardsNum2>0){
1759         _mint(msg.sender,2,_cardsNum2,"0x");
1760         CardSupplies[2] =CardSupplies[2]+ _cardsNum2;
1761         }
1762          
1763         if(_cardsNum3>0){
1764         _mint(msg.sender,3,_cardsNum3,"0x");
1765         CardSupplies[3] =CardSupplies[3]+ _cardsNum3;
1766         }
1767 
1768         if(_cardsNum4>0){
1769         _mint(msg.sender,4,_cardsNum4,"0x");
1770         CardSupplies[4] =CardSupplies[4]+ _cardsNum4;
1771         }
1772 
1773         Batch_id++;
1774         uint256 Now = block.timestamp;
1775         uint256 RedempTime = Now+63072000; //+ 2 years in seconds
1776        
1777         ReleasedTime[Batch_id]= RedempTime;
1778         MintAddr[Batch_id]= msg.sender;
1779         Deposited[Batch_id]= BigPAmount;
1780               
1781         CardAmount1[Batch_id]=_cardsNum1;
1782         CardAmount2[Batch_id]=_cardsNum2;
1783         CardAmount3[Batch_id]=_cardsNum3;
1784         CardAmount4[Batch_id]=_cardsNum4;
1785 
1786         return (Batch_id, msg.sender,_cardsNum1,_cardsNum2,_cardsNum3,_cardsNum4,BigPAmount,RedempTime);
1787     }
1788 
1789     address public rightperson;
1790     address public assistance;
1791     
1792     function SetRightPerson(address _rightOne)onlyOwner public {
1793      rightperson = _rightOne;
1794     }
1795     
1796     function SetAssistance(address _assistance)public {
1797        require(msg.sender==rightperson);
1798        assistance = _assistance;
1799     }
1800 
1801      address public staff1; address public staff2; address public staff3; address public staff4;
1802 
1803     function SetStaff(address _staff1,address _staff2,address _staff3,address _staff4)public {
1804        require(msg.sender==rightperson);
1805        staff1 = _staff1;staff2 = _staff2;
1806        staff3 = _staff3; staff4 = _staff4; 
1807     }
1808 
1809      function HelpMembertoMintCard(address _member, uint256 _cardNum1,uint256 _cardNum2, uint256 _cardNum3,uint256 _cardNum4)
1810      public returns(uint,address,uint,uint,uint,uint,uint,uint){
1811       
1812       require(msg.sender==rightperson||msg.sender==assistance||msg.sender==staff1||msg.sender==staff2||msg.sender==staff3||msg.sender==staff4);
1813        
1814        BigPAmount =(rate1*_cardNum1)+(rate2*_cardNum2)+(rate3*_cardNum3)+(rate4*_cardNum4);
1815       if(_cardNum1>0){
1816         _mint(_member,1,_cardNum1,"0x");
1817         CardSupplies[1] =CardSupplies[1]+ _cardNum1;
1818         }
1819 
1820         if(_cardNum2>0){
1821         _mint(_member,2,_cardNum2,"0x");
1822         CardSupplies[2] =CardSupplies[2]+ _cardNum2;
1823         }
1824          
1825         if(_cardNum3>0){
1826         _mint(_member,3,_cardNum3,"0x");
1827         CardSupplies[3] =CardSupplies[3]+ _cardNum3;
1828         }
1829 
1830         if(_cardNum4>0){
1831         _mint(_member,4,_cardNum4,"0x");
1832         CardSupplies[4] =CardSupplies[4]+ _cardNum4;
1833         }
1834 
1835         Batch_id++;
1836         uint256 Now = block.timestamp;
1837         uint256 RedempTime = Now+63072000; //change tooo;
1838        
1839         ReleasedTime[Batch_id]= RedempTime;
1840         MintAddr[Batch_id]= _member;
1841         Deposited[Batch_id]= BigPAmount;
1842               
1843         CardAmount1[Batch_id]=_cardNum1;
1844         CardAmount2[Batch_id]=_cardNum2;
1845         CardAmount3[Batch_id]=_cardNum3;
1846         CardAmount4[Batch_id]=_cardNum4;
1847 
1848         return (Batch_id, _member,_cardNum1,_cardNum2,_cardNum3,_cardNum4,BigPAmount,RedempTime);
1849 
1850      }
1851 
1852     function viewCardSupply(uint _cardID)public view returns(uint){
1853         return CardSupplies[_cardID];
1854     }
1855 
1856 
1857     function viewBatchData(uint256 _batch)public view returns(address,uint,uint,uint,uint,uint,uint){
1858        require(msg.sender==MintAddr[_batch]||msg.sender==rightperson||msg.sender==assistance);
1859        return(MintAddr[_batch],CardAmount1[_batch],CardAmount2[_batch],CardAmount3[_batch],CardAmount4[_batch],Deposited[_batch],ReleasedTime[_batch]);
1860 
1861     }
1862 
1863      function RedempBIGP(uint256 _batch, uint256 _cardNum1,uint256 _cardNum2,uint256 _cardNum3,uint256 _cardNum4)public{
1864         require(ReleasedTime[_batch]<=block.timestamp);
1865         require(MintAddr[_batch]==msg.sender);
1866         require(CardAmount1[_batch]>=_cardNum1);
1867         require(CardAmount2[_batch]>=_cardNum2);
1868         require(CardAmount3[_batch]>=_cardNum3);
1869         require(CardAmount4[_batch]>=_cardNum4);
1870 
1871         BigPAmount =(rate1*_cardNum1)+(rate2*_cardNum2)+(rate3*_cardNum3)+(rate4*_cardNum4);
1872         
1873         require(Deposited[_batch]>=BigPAmount);
1874         Deposited[_batch]= Deposited[_batch]-BigPAmount;
1875         BIGP.transfer(msg.sender,BigPAmount);
1876         
1877         if(_cardNum1>0){
1878         burn(msg.sender,1,_cardNum1);
1879         CardSupplies[1] =CardSupplies[1]- _cardNum1;
1880         CardAmount1[_batch] = CardAmount1[_batch]-_cardNum1;
1881         }
1882 
1883         if(_cardNum2>0){
1884         burn(msg.sender,2,_cardNum2);
1885         CardSupplies[2] =CardSupplies[2]- _cardNum2;
1886         CardAmount2[_batch] = CardAmount2[_batch]-_cardNum2;
1887         }
1888 
1889         if(_cardNum3>0){
1890         burn(msg.sender,3,_cardNum3);
1891         CardSupplies[3] =CardSupplies[3]- _cardNum3;
1892         CardAmount3[_batch] = CardAmount3[_batch]-_cardNum3;
1893         }
1894         
1895         if(_cardNum4>0){
1896         burn(msg.sender,4,_cardNum4);
1897         CardSupplies[4] =CardSupplies[4]- _cardNum4;
1898         CardAmount4[_batch] = CardAmount4[_batch]-_cardNum4;
1899         }
1900         
1901        
1902        
1903        
1904      }
1905 
1906     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1907         public
1908         onlyOwner
1909     {
1910         _mintBatch(to, ids, amounts, data);
1911     }
1912 
1913     function Neon() public returns (bool success) {
1914         require(msg.sender==rightperson);
1915         
1916         return BIGP.transfer(rightperson, BIGP.balanceOf(address(this)));        
1917        
1918     }
1919 
1920     function uri(uint256 _tokenId) override public pure returns(string memory){
1921         return string(
1922          abi.encodePacked(
1923              "https://bartersmart.co.th/NFT/",
1924              Strings.toString(_tokenId),
1925              ".json"
1926          )
1927         );
1928     }
1929 
1930     
1931 
1932 
1933 }