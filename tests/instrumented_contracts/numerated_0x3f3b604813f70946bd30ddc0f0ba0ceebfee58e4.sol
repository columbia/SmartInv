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
28 // File: @openzeppelin/contracts/security/Pausable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which allows children to implement an emergency stop
38  * mechanism that can be triggered by an authorized account.
39  *
40  * This module is used through inheritance. It will make available the
41  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
42  * the functions of your contract. Note that they will not be pausable by
43  * simply including this module, only once the modifiers are put in place.
44  */
45 abstract contract Pausable is Context {
46     /**
47      * @dev Emitted when the pause is triggered by `account`.
48      */
49     event Paused(address account);
50 
51     /**
52      * @dev Emitted when the pause is lifted by `account`.
53      */
54     event Unpaused(address account);
55 
56     bool private _paused;
57 
58     /**
59      * @dev Initializes the contract in unpaused state.
60      */
61     constructor() {
62         _paused = false;
63     }
64 
65     /**
66      * @dev Modifier to make a function callable only when the contract is not paused.
67      *
68      * Requirements:
69      *
70      * - The contract must not be paused.
71      */
72     modifier whenNotPaused() {
73         _requireNotPaused();
74         _;
75     }
76 
77     /**
78      * @dev Modifier to make a function callable only when the contract is paused.
79      *
80      * Requirements:
81      *
82      * - The contract must be paused.
83      */
84     modifier whenPaused() {
85         _requirePaused();
86         _;
87     }
88 
89     /**
90      * @dev Returns true if the contract is paused, and false otherwise.
91      */
92     function paused() public view virtual returns (bool) {
93         return _paused;
94     }
95 
96     /**
97      * @dev Throws if the contract is paused.
98      */
99     function _requireNotPaused() internal view virtual {
100         require(!paused(), "Pausable: paused");
101     }
102 
103     /**
104      * @dev Throws if the contract is not paused.
105      */
106     function _requirePaused() internal view virtual {
107         require(paused(), "Pausable: not paused");
108     }
109 
110     /**
111      * @dev Triggers stopped state.
112      *
113      * Requirements:
114      *
115      * - The contract must not be paused.
116      */
117     function _pause() internal virtual whenNotPaused {
118         _paused = true;
119         emit Paused(_msgSender());
120     }
121 
122     /**
123      * @dev Returns to normal state.
124      *
125      * Requirements:
126      *
127      * - The contract must be paused.
128      */
129     function _unpause() internal virtual whenPaused {
130         _paused = false;
131         emit Unpaused(_msgSender());
132     }
133 }
134 
135 // File: @openzeppelin/contracts/access/Ownable.sol
136 
137 
138 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 
143 /**
144  * @dev Contract module which provides a basic access control mechanism, where
145  * there is an account (an owner) that can be granted exclusive access to
146  * specific functions.
147  *
148  * By default, the owner account will be the one that deploys the contract. This
149  * can later be changed with {transferOwnership}.
150  *
151  * This module is used through inheritance. It will make available the modifier
152  * `onlyOwner`, which can be applied to your functions to restrict their use to
153  * the owner.
154  */
155 abstract contract Ownable is Context {
156     address private _owner;
157 
158     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159 
160     /**
161      * @dev Initializes the contract setting the deployer as the initial owner.
162      */
163     constructor() {
164         _transferOwnership(_msgSender());
165     }
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         _checkOwner();
172         _;
173     }
174 
175     /**
176      * @dev Returns the address of the current owner.
177      */
178     function owner() public view virtual returns (address) {
179         return _owner;
180     }
181 
182     /**
183      * @dev Throws if the sender is not the owner.
184      */
185     function _checkOwner() internal view virtual {
186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
187     }
188 
189     /**
190      * @dev Leaves the contract without owner. It will not be possible to call
191      * `onlyOwner` functions anymore. Can only be called by the current owner.
192      *
193      * NOTE: Renouncing ownership will leave the contract without an owner,
194      * thereby removing any functionality that is only available to the owner.
195      */
196     function renounceOwnership() public virtual onlyOwner {
197         _transferOwnership(address(0));
198     }
199 
200     /**
201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
202      * Can only be called by the current owner.
203      */
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         _transferOwnership(newOwner);
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      * Internal function without access restriction.
212      */
213     function _transferOwnership(address newOwner) internal virtual {
214         address oldOwner = _owner;
215         _owner = newOwner;
216         emit OwnershipTransferred(oldOwner, newOwner);
217     }
218 }
219 
220 // File: @openzeppelin/contracts/utils/Address.sol
221 
222 
223 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
224 
225 pragma solidity ^0.8.1;
226 
227 /**
228  * @dev Collection of functions related to the address type
229  */
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * [IMPORTANT]
235      * ====
236      * It is unsafe to assume that an address for which this function returns
237      * false is an externally-owned account (EOA) and not a contract.
238      *
239      * Among others, `isContract` will return false for the following
240      * types of addresses:
241      *
242      *  - an externally-owned account
243      *  - a contract in construction
244      *  - an address where a contract will be created
245      *  - an address where a contract lived, but was destroyed
246      * ====
247      *
248      * [IMPORTANT]
249      * ====
250      * You shouldn't rely on `isContract` to protect against flash loan attacks!
251      *
252      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
253      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
254      * constructor.
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // This method relies on extcodesize/address.code.length, which returns 0
259         // for contracts in construction, since the code is only stored at the end
260         // of the constructor execution.
261 
262         return account.code.length > 0;
263     }
264 
265     /**
266      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267      * `recipient`, forwarding all available gas and reverting on errors.
268      *
269      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270      * of certain opcodes, possibly making contracts go over the 2300 gas limit
271      * imposed by `transfer`, making them unable to receive funds via
272      * `transfer`. {sendValue} removes this limitation.
273      *
274      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275      *
276      * IMPORTANT: because control is transferred to `recipient`, care must be
277      * taken to not create reentrancy vulnerabilities. Consider using
278      * {ReentrancyGuard} or the
279      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280      */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, "Address: insufficient balance");
283 
284         (bool success, ) = recipient.call{value: amount}("");
285         require(success, "Address: unable to send value, recipient may have reverted");
286     }
287 
288     /**
289      * @dev Performs a Solidity function call using a low level `call`. A
290      * plain `call` is an unsafe replacement for a function call: use this
291      * function instead.
292      *
293      * If `target` reverts with a revert reason, it is bubbled up by this
294      * function (like regular Solidity function calls).
295      *
296      * Returns the raw returned data. To convert to the expected return value,
297      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
298      *
299      * Requirements:
300      *
301      * - `target` must be a contract.
302      * - calling `target` with `data` must not revert.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
312      * `errorMessage` as a fallback revert reason when `target` reverts.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but also transferring `value` wei to `target`.
327      *
328      * Requirements:
329      *
330      * - the calling contract must have an ETH balance of at least `value`.
331      * - the called Solidity function must be `payable`.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(
336         address target,
337         bytes memory data,
338         uint256 value
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         (bool success, bytes memory returndata) = target.staticcall(data);
382         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         (bool success, bytes memory returndata) = target.delegatecall(data);
407         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
412      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
413      *
414      * _Available since v4.8._
415      */
416     function verifyCallResultFromTarget(
417         address target,
418         bool success,
419         bytes memory returndata,
420         string memory errorMessage
421     ) internal view returns (bytes memory) {
422         if (success) {
423             if (returndata.length == 0) {
424                 // only check isContract if the call was successful and the return data is empty
425                 // otherwise we already know that it was a contract
426                 require(isContract(target), "Address: call to non-contract");
427             }
428             return returndata;
429         } else {
430             _revert(returndata, errorMessage);
431         }
432     }
433 
434     /**
435      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason or using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             _revert(returndata, errorMessage);
449         }
450     }
451 
452     function _revert(bytes memory returndata, string memory errorMessage) private pure {
453         // Look for revert reason and bubble it up if present
454         if (returndata.length > 0) {
455             // The easiest way to bubble the revert reason is using memory via assembly
456             /// @solidity memory-safe-assembly
457             assembly {
458                 let returndata_size := mload(returndata)
459                 revert(add(32, returndata), returndata_size)
460             }
461         } else {
462             revert(errorMessage);
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @dev Interface of the ERC165 standard, as defined in the
476  * https://eips.ethereum.org/EIPS/eip-165[EIP].
477  *
478  * Implementers can declare support of contract interfaces, which can then be
479  * queried by others ({ERC165Checker}).
480  *
481  * For an implementation, see {ERC165}.
482  */
483 interface IERC165 {
484     /**
485      * @dev Returns true if this contract implements the interface defined by
486      * `interfaceId`. See the corresponding
487      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
488      * to learn more about how these ids are created.
489      *
490      * This function call must use less than 30 000 gas.
491      */
492     function supportsInterface(bytes4 interfaceId) external view returns (bool);
493 }
494 
495 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @dev Implementation of the {IERC165} interface.
505  *
506  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
507  * for the additional interface id that will be supported. For example:
508  *
509  * ```solidity
510  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
511  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
512  * }
513  * ```
514  *
515  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
516  */
517 abstract contract ERC165 is IERC165 {
518     /**
519      * @dev See {IERC165-supportsInterface}.
520      */
521     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
522         return interfaceId == type(IERC165).interfaceId;
523     }
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
527 
528 
529 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev _Available since v3.1._
536  */
537 interface IERC1155Receiver is IERC165 {
538     /**
539      * @dev Handles the receipt of a single ERC1155 token type. This function is
540      * called at the end of a `safeTransferFrom` after the balance has been updated.
541      *
542      * NOTE: To accept the transfer, this must return
543      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
544      * (i.e. 0xf23a6e61, or its own function selector).
545      *
546      * @param operator The address which initiated the transfer (i.e. msg.sender)
547      * @param from The address which previously owned the token
548      * @param id The ID of the token being transferred
549      * @param value The amount of tokens being transferred
550      * @param data Additional data with no specified format
551      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
552      */
553     function onERC1155Received(
554         address operator,
555         address from,
556         uint256 id,
557         uint256 value,
558         bytes calldata data
559     ) external returns (bytes4);
560 
561     /**
562      * @dev Handles the receipt of a multiple ERC1155 token types. This function
563      * is called at the end of a `safeBatchTransferFrom` after the balances have
564      * been updated.
565      *
566      * NOTE: To accept the transfer(s), this must return
567      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
568      * (i.e. 0xbc197c81, or its own function selector).
569      *
570      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
571      * @param from The address which previously owned the token
572      * @param ids An array containing ids of each token being transferred (order and length must match values array)
573      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
574      * @param data Additional data with no specified format
575      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
576      */
577     function onERC1155BatchReceived(
578         address operator,
579         address from,
580         uint256[] calldata ids,
581         uint256[] calldata values,
582         bytes calldata data
583     ) external returns (bytes4);
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
587 
588 
589 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Required interface of an ERC1155 compliant contract, as defined in the
596  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
597  *
598  * _Available since v3.1._
599  */
600 interface IERC1155 is IERC165 {
601     /**
602      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
603      */
604     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
605 
606     /**
607      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
608      * transfers.
609      */
610     event TransferBatch(
611         address indexed operator,
612         address indexed from,
613         address indexed to,
614         uint256[] ids,
615         uint256[] values
616     );
617 
618     /**
619      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
620      * `approved`.
621      */
622     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
623 
624     /**
625      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
626      *
627      * If an {URI} event was emitted for `id`, the standard
628      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
629      * returned by {IERC1155MetadataURI-uri}.
630      */
631     event URI(string value, uint256 indexed id);
632 
633     /**
634      * @dev Returns the amount of tokens of token type `id` owned by `account`.
635      *
636      * Requirements:
637      *
638      * - `account` cannot be the zero address.
639      */
640     function balanceOf(address account, uint256 id) external view returns (uint256);
641 
642     /**
643      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
644      *
645      * Requirements:
646      *
647      * - `accounts` and `ids` must have the same length.
648      */
649     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
650         external
651         view
652         returns (uint256[] memory);
653 
654     /**
655      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
656      *
657      * Emits an {ApprovalForAll} event.
658      *
659      * Requirements:
660      *
661      * - `operator` cannot be the caller.
662      */
663     function setApprovalForAll(address operator, bool approved) external;
664 
665     /**
666      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
667      *
668      * See {setApprovalForAll}.
669      */
670     function isApprovedForAll(address account, address operator) external view returns (bool);
671 
672     /**
673      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
674      *
675      * Emits a {TransferSingle} event.
676      *
677      * Requirements:
678      *
679      * - `to` cannot be the zero address.
680      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
681      * - `from` must have a balance of tokens of type `id` of at least `amount`.
682      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
683      * acceptance magic value.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 id,
689         uint256 amount,
690         bytes calldata data
691     ) external;
692 
693     /**
694      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
695      *
696      * Emits a {TransferBatch} event.
697      *
698      * Requirements:
699      *
700      * - `ids` and `amounts` must have the same length.
701      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
702      * acceptance magic value.
703      */
704     function safeBatchTransferFrom(
705         address from,
706         address to,
707         uint256[] calldata ids,
708         uint256[] calldata amounts,
709         bytes calldata data
710     ) external;
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
723  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
724  *
725  * _Available since v3.1._
726  */
727 interface IERC1155MetadataURI is IERC1155 {
728     /**
729      * @dev Returns the URI for token type `id`.
730      *
731      * If the `\{id\}` substring is present in the URI, it must be replaced by
732      * clients with the actual token type ID.
733      */
734     function uri(uint256 id) external view returns (string memory);
735 }
736 
737 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
738 
739 
740 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 
745 
746 
747 
748 
749 
750 /**
751  * @dev Implementation of the basic standard multi-token.
752  * See https://eips.ethereum.org/EIPS/eip-1155
753  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
754  *
755  * _Available since v3.1._
756  */
757 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
758     using Address for address;
759 
760     // Mapping from token ID to account balances
761     mapping(uint256 => mapping(address => uint256)) private _balances;
762 
763     // Mapping from account to operator approvals
764     mapping(address => mapping(address => bool)) private _operatorApprovals;
765 
766     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
767     string private _uri;
768 
769     /**
770      * @dev See {_setURI}.
771      */
772     constructor(string memory uri_) {
773         _setURI(uri_);
774     }
775 
776     /**
777      * @dev See {IERC165-supportsInterface}.
778      */
779     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
780         return
781             interfaceId == type(IERC1155).interfaceId ||
782             interfaceId == type(IERC1155MetadataURI).interfaceId ||
783             super.supportsInterface(interfaceId);
784     }
785 
786     /**
787      * @dev See {IERC1155MetadataURI-uri}.
788      *
789      * This implementation returns the same URI for *all* token types. It relies
790      * on the token type ID substitution mechanism
791      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
792      *
793      * Clients calling this function must replace the `\{id\}` substring with the
794      * actual token type ID.
795      */
796     function uri(uint256) public view virtual override returns (string memory) {
797         return _uri;
798     }
799 
800     /**
801      * @dev See {IERC1155-balanceOf}.
802      *
803      * Requirements:
804      *
805      * - `account` cannot be the zero address.
806      */
807     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
808         require(account != address(0), "ERC1155: address zero is not a valid owner");
809         return _balances[id][account];
810     }
811 
812     /**
813      * @dev See {IERC1155-balanceOfBatch}.
814      *
815      * Requirements:
816      *
817      * - `accounts` and `ids` must have the same length.
818      */
819     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
820         public
821         view
822         virtual
823         override
824         returns (uint256[] memory)
825     {
826         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
827 
828         uint256[] memory batchBalances = new uint256[](accounts.length);
829 
830         for (uint256 i = 0; i < accounts.length; ++i) {
831             batchBalances[i] = balanceOf(accounts[i], ids[i]);
832         }
833 
834         return batchBalances;
835     }
836 
837     /**
838      * @dev See {IERC1155-setApprovalForAll}.
839      */
840     function setApprovalForAll(address operator, bool approved) public virtual override {
841         _setApprovalForAll(_msgSender(), operator, approved);
842     }
843 
844     /**
845      * @dev See {IERC1155-isApprovedForAll}.
846      */
847     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
848         return _operatorApprovals[account][operator];
849     }
850 
851     /**
852      * @dev See {IERC1155-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 id,
858         uint256 amount,
859         bytes memory data
860     ) public virtual override {
861         require(
862             from == _msgSender() || isApprovedForAll(from, _msgSender()),
863             "ERC1155: caller is not token owner or approved"
864         );
865         _safeTransferFrom(from, to, id, amount, data);
866     }
867 
868     /**
869      * @dev See {IERC1155-safeBatchTransferFrom}.
870      */
871     function safeBatchTransferFrom(
872         address from,
873         address to,
874         uint256[] memory ids,
875         uint256[] memory amounts,
876         bytes memory data
877     ) public virtual override {
878         require(
879             from == _msgSender() || isApprovedForAll(from, _msgSender()),
880             "ERC1155: caller is not token owner or approved"
881         );
882         _safeBatchTransferFrom(from, to, ids, amounts, data);
883     }
884 
885     /**
886      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
887      *
888      * Emits a {TransferSingle} event.
889      *
890      * Requirements:
891      *
892      * - `to` cannot be the zero address.
893      * - `from` must have a balance of tokens of type `id` of at least `amount`.
894      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
895      * acceptance magic value.
896      */
897     function _safeTransferFrom(
898         address from,
899         address to,
900         uint256 id,
901         uint256 amount,
902         bytes memory data
903     ) internal virtual {
904         require(to != address(0), "ERC1155: transfer to the zero address");
905 
906         address operator = _msgSender();
907         uint256[] memory ids = _asSingletonArray(id);
908         uint256[] memory amounts = _asSingletonArray(amount);
909 
910         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
911 
912         uint256 fromBalance = _balances[id][from];
913         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
914         unchecked {
915             _balances[id][from] = fromBalance - amount;
916         }
917         _balances[id][to] += amount;
918 
919         emit TransferSingle(operator, from, to, id, amount);
920 
921         _afterTokenTransfer(operator, from, to, ids, amounts, data);
922 
923         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
924     }
925 
926     /**
927      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
928      *
929      * Emits a {TransferBatch} event.
930      *
931      * Requirements:
932      *
933      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
934      * acceptance magic value.
935      */
936     function _safeBatchTransferFrom(
937         address from,
938         address to,
939         uint256[] memory ids,
940         uint256[] memory amounts,
941         bytes memory data
942     ) internal virtual {
943         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
944         require(to != address(0), "ERC1155: transfer to the zero address");
945 
946         address operator = _msgSender();
947 
948         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
949 
950         for (uint256 i = 0; i < ids.length; ++i) {
951             uint256 id = ids[i];
952             uint256 amount = amounts[i];
953 
954             uint256 fromBalance = _balances[id][from];
955             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
956             unchecked {
957                 _balances[id][from] = fromBalance - amount;
958             }
959             _balances[id][to] += amount;
960         }
961 
962         emit TransferBatch(operator, from, to, ids, amounts);
963 
964         _afterTokenTransfer(operator, from, to, ids, amounts, data);
965 
966         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
967     }
968 
969     /**
970      * @dev Sets a new URI for all token types, by relying on the token type ID
971      * substitution mechanism
972      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
973      *
974      * By this mechanism, any occurrence of the `\{id\}` substring in either the
975      * URI or any of the amounts in the JSON file at said URI will be replaced by
976      * clients with the token type ID.
977      *
978      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
979      * interpreted by clients as
980      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
981      * for token type ID 0x4cce0.
982      *
983      * See {uri}.
984      *
985      * Because these URIs cannot be meaningfully represented by the {URI} event,
986      * this function emits no events.
987      */
988     function _setURI(string memory newuri) internal virtual {
989         _uri = newuri;
990     }
991 
992     /**
993      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
994      *
995      * Emits a {TransferSingle} event.
996      *
997      * Requirements:
998      *
999      * - `to` cannot be the zero address.
1000      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1001      * acceptance magic value.
1002      */
1003     function _mint(
1004         address to,
1005         uint256 id,
1006         uint256 amount,
1007         bytes memory data
1008     ) internal virtual {
1009         require(to != address(0), "ERC1155: mint to the zero address");
1010 
1011         address operator = _msgSender();
1012         uint256[] memory ids = _asSingletonArray(id);
1013         uint256[] memory amounts = _asSingletonArray(amount);
1014 
1015         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1016 
1017         _balances[id][to] += amount;
1018         emit TransferSingle(operator, address(0), to, id, amount);
1019 
1020         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1021 
1022         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1023     }
1024 
1025     /**
1026      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1027      *
1028      * Emits a {TransferBatch} event.
1029      *
1030      * Requirements:
1031      *
1032      * - `ids` and `amounts` must have the same length.
1033      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1034      * acceptance magic value.
1035      */
1036     function _mintBatch(
1037         address to,
1038         uint256[] memory ids,
1039         uint256[] memory amounts,
1040         bytes memory data
1041     ) internal virtual {
1042         require(to != address(0), "ERC1155: mint to the zero address");
1043         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1044 
1045         address operator = _msgSender();
1046 
1047         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1048 
1049         for (uint256 i = 0; i < ids.length; i++) {
1050             _balances[ids[i]][to] += amounts[i];
1051         }
1052 
1053         emit TransferBatch(operator, address(0), to, ids, amounts);
1054 
1055         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1056 
1057         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1058     }
1059 
1060     /**
1061      * @dev Destroys `amount` tokens of token type `id` from `from`
1062      *
1063      * Emits a {TransferSingle} event.
1064      *
1065      * Requirements:
1066      *
1067      * - `from` cannot be the zero address.
1068      * - `from` must have at least `amount` tokens of token type `id`.
1069      */
1070     function _burn(
1071         address from,
1072         uint256 id,
1073         uint256 amount
1074     ) internal virtual {
1075         require(from != address(0), "ERC1155: burn from the zero address");
1076 
1077         address operator = _msgSender();
1078         uint256[] memory ids = _asSingletonArray(id);
1079         uint256[] memory amounts = _asSingletonArray(amount);
1080 
1081         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1082 
1083         uint256 fromBalance = _balances[id][from];
1084         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1085         unchecked {
1086             _balances[id][from] = fromBalance - amount;
1087         }
1088 
1089         emit TransferSingle(operator, from, address(0), id, amount);
1090 
1091         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1092     }
1093 
1094     /**
1095      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1096      *
1097      * Emits a {TransferBatch} event.
1098      *
1099      * Requirements:
1100      *
1101      * - `ids` and `amounts` must have the same length.
1102      */
1103     function _burnBatch(
1104         address from,
1105         uint256[] memory ids,
1106         uint256[] memory amounts
1107     ) internal virtual {
1108         require(from != address(0), "ERC1155: burn from the zero address");
1109         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1110 
1111         address operator = _msgSender();
1112 
1113         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1114 
1115         for (uint256 i = 0; i < ids.length; i++) {
1116             uint256 id = ids[i];
1117             uint256 amount = amounts[i];
1118 
1119             uint256 fromBalance = _balances[id][from];
1120             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1121             unchecked {
1122                 _balances[id][from] = fromBalance - amount;
1123             }
1124         }
1125 
1126         emit TransferBatch(operator, from, address(0), ids, amounts);
1127 
1128         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1129     }
1130 
1131     /**
1132      * @dev Approve `operator` to operate on all of `owner` tokens
1133      *
1134      * Emits an {ApprovalForAll} event.
1135      */
1136     function _setApprovalForAll(
1137         address owner,
1138         address operator,
1139         bool approved
1140     ) internal virtual {
1141         require(owner != operator, "ERC1155: setting approval status for self");
1142         _operatorApprovals[owner][operator] = approved;
1143         emit ApprovalForAll(owner, operator, approved);
1144     }
1145 
1146     /**
1147      * @dev Hook that is called before any token transfer. This includes minting
1148      * and burning, as well as batched variants.
1149      *
1150      * The same hook is called on both single and batched variants. For single
1151      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1152      *
1153      * Calling conditions (for each `id` and `amount` pair):
1154      *
1155      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1156      * of token type `id` will be  transferred to `to`.
1157      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1158      * for `to`.
1159      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1160      * will be burned.
1161      * - `from` and `to` are never both zero.
1162      * - `ids` and `amounts` have the same, non-zero length.
1163      *
1164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1165      */
1166     function _beforeTokenTransfer(
1167         address operator,
1168         address from,
1169         address to,
1170         uint256[] memory ids,
1171         uint256[] memory amounts,
1172         bytes memory data
1173     ) internal virtual {}
1174 
1175     /**
1176      * @dev Hook that is called after any token transfer. This includes minting
1177      * and burning, as well as batched variants.
1178      *
1179      * The same hook is called on both single and batched variants. For single
1180      * transfers, the length of the `id` and `amount` arrays will be 1.
1181      *
1182      * Calling conditions (for each `id` and `amount` pair):
1183      *
1184      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1185      * of token type `id` will be  transferred to `to`.
1186      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1187      * for `to`.
1188      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1189      * will be burned.
1190      * - `from` and `to` are never both zero.
1191      * - `ids` and `amounts` have the same, non-zero length.
1192      *
1193      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1194      */
1195     function _afterTokenTransfer(
1196         address operator,
1197         address from,
1198         address to,
1199         uint256[] memory ids,
1200         uint256[] memory amounts,
1201         bytes memory data
1202     ) internal virtual {}
1203 
1204     function _doSafeTransferAcceptanceCheck(
1205         address operator,
1206         address from,
1207         address to,
1208         uint256 id,
1209         uint256 amount,
1210         bytes memory data
1211     ) private {
1212         if (to.isContract()) {
1213             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1214                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1215                     revert("ERC1155: ERC1155Receiver rejected tokens");
1216                 }
1217             } catch Error(string memory reason) {
1218                 revert(reason);
1219             } catch {
1220                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1221             }
1222         }
1223     }
1224 
1225     function _doSafeBatchTransferAcceptanceCheck(
1226         address operator,
1227         address from,
1228         address to,
1229         uint256[] memory ids,
1230         uint256[] memory amounts,
1231         bytes memory data
1232     ) private {
1233         if (to.isContract()) {
1234             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1235                 bytes4 response
1236             ) {
1237                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1238                     revert("ERC1155: ERC1155Receiver rejected tokens");
1239                 }
1240             } catch Error(string memory reason) {
1241                 revert(reason);
1242             } catch {
1243                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1244             }
1245         }
1246     }
1247 
1248     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1249         uint256[] memory array = new uint256[](1);
1250         array[0] = element;
1251 
1252         return array;
1253     }
1254 }
1255 
1256 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1257 
1258 
1259 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 
1264 /**
1265  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1266  * own tokens and those that they have been approved to use.
1267  *
1268  * _Available since v3.1._
1269  */
1270 abstract contract ERC1155Burnable is ERC1155 {
1271     function burn(
1272         address account,
1273         uint256 id,
1274         uint256 value
1275     ) public virtual {
1276         require(
1277             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1278             "ERC1155: caller is not token owner or approved"
1279         );
1280 
1281         _burn(account, id, value);
1282     }
1283 
1284     function burnBatch(
1285         address account,
1286         uint256[] memory ids,
1287         uint256[] memory values
1288     ) public virtual {
1289         require(
1290             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1291             "ERC1155: caller is not token owner or approved"
1292         );
1293 
1294         _burnBatch(account, ids, values);
1295     }
1296 }
1297 
1298 // File: contracts/Aiddrop.sol
1299 
1300 
1301 pragma solidity ^0.8.4;
1302 
1303 
1304 
1305 
1306 
1307 contract AIDDROP is ERC1155, Ownable, Pausable, ERC1155Burnable {
1308     uint256[] prices = [
1309         0.05 * (10**18)
1310     ];
1311 
1312     event Attest(address indexed to, uint256 indexed tokenId);
1313     event Revoke(address indexed to, uint256 indexed tokenId);
1314 
1315     constructor() ERC1155("") {}
1316 
1317     function setURI(string memory newuri) public onlyOwner {
1318         _setURI(newuri);
1319     }
1320 
1321     function pause() public onlyOwner {
1322         _pause();
1323     }
1324 
1325     function unpause() public onlyOwner {
1326         _unpause();
1327     }
1328 
1329     function mint(
1330         address account,
1331         uint256 id,
1332         uint256 amount,
1333         bytes memory data
1334     ) public payable {
1335         require(msg.value >= prices[id % prices.length], "Insufficient funds!");
1336         _mint(account, id, amount, data);
1337     }
1338 
1339     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal pure override {
1340         require(
1341             from == address(0) || to == address(0),
1342             "Not allowed to transfer token"
1343         );
1344     }
1345 
1346     function _afterTokenTransfer(
1347         address from,
1348         address to,
1349         uint256 tokenId, uint256[] memory ids, uint256[] memory amounts, bytes memory data
1350     ) internal {
1351         if (from == address(0)) {
1352             emit Attest(to, tokenId);
1353         } else if (to == address(0)) {
1354             emit Revoke(to, tokenId);
1355         }
1356     }
1357 
1358     function mintBatch(
1359         address to,
1360         uint256[] memory ids,
1361         uint256[] memory amounts,
1362         bytes memory data
1363     ) public payable {
1364         uint256 total = 0;
1365         for (uint256 i = 0; i < ids.length; i++) {
1366             total = total + prices[ids[i]] * amounts[i];
1367         }
1368         require(msg.value >= total, "Insufficient funds!");
1369         _mintBatch(to, ids, amounts, data);
1370     }
1371 
1372     function setPrices(uint256[] memory new_prices) public onlyOwner {
1373         prices = new_prices;
1374     }
1375 
1376     function getPrices() internal view returns (uint256[] storage) {
1377         return prices;
1378     }
1379 
1380     function withdraw() public onlyOwner {
1381         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1382         require(os);
1383         // =============================================================================
1384     }
1385 }