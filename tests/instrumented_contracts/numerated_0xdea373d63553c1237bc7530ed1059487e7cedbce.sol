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
113 // File: @openzeppelin/contracts/utils/Address.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
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
200         return functionCall(target, data, "Address: low-level call failed");
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
249         require(isContract(target), "Address: call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.call{value: value}(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
262         return functionStaticCall(target, data, "Address: low-level static call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a static call.
268      *
269      * _Available since v3.3._
270      */
271     function functionStaticCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal view returns (bytes memory) {
276         require(isContract(target), "Address: static call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.staticcall(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but performing a delegate call.
285      *
286      * _Available since v3.4._
287      */
288     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
289         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
294      * but performing a delegate call.
295      *
296      * _Available since v3.4._
297      */
298     function functionDelegateCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(isContract(target), "Address: delegate call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.delegatecall(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
311      * revert reason using the provided one.
312      *
313      * _Available since v4.3._
314      */
315     function verifyCallResult(
316         bool success,
317         bytes memory returndata,
318         string memory errorMessage
319     ) internal pure returns (bytes memory) {
320         if (success) {
321             return returndata;
322         } else {
323             // Look for revert reason and bubble it up if present
324             if (returndata.length > 0) {
325                 // The easiest way to bubble the revert reason is using memory via assembly
326                 /// @solidity memory-safe-assembly
327                 assembly {
328                     let returndata_size := mload(returndata)
329                     revert(add(32, returndata), returndata_size)
330                 }
331             } else {
332                 revert(errorMessage);
333             }
334         }
335     }
336 }
337 
338 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
339 
340 
341 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Interface of the ERC20 standard as defined in the EIP.
347  */
348 interface IERC20 {
349     /**
350      * @dev Emitted when `value` tokens are moved from one account (`from`) to
351      * another (`to`).
352      *
353      * Note that `value` may be zero.
354      */
355     event Transfer(address indexed from, address indexed to, uint256 value);
356 
357     /**
358      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
359      * a call to {approve}. `value` is the new allowance.
360      */
361     event Approval(address indexed owner, address indexed spender, uint256 value);
362 
363     /**
364      * @dev Returns the amount of tokens in existence.
365      */
366     function totalSupply() external view returns (uint256);
367 
368     /**
369      * @dev Returns the amount of tokens owned by `account`.
370      */
371     function balanceOf(address account) external view returns (uint256);
372 
373     /**
374      * @dev Moves `amount` tokens from the caller's account to `to`.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transfer(address to, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Returns the remaining number of tokens that `spender` will be
384      * allowed to spend on behalf of `owner` through {transferFrom}. This is
385      * zero by default.
386      *
387      * This value changes when {approve} or {transferFrom} are called.
388      */
389     function allowance(address owner, address spender) external view returns (uint256);
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * IMPORTANT: Beware that changing an allowance with this method brings the risk
397      * that someone may use both the old and the new allowance by unfortunate
398      * transaction ordering. One possible solution to mitigate this race
399      * condition is to first reduce the spender's allowance to 0 and set the
400      * desired value afterwards:
401      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
402      *
403      * Emits an {Approval} event.
404      */
405     function approve(address spender, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Moves `amount` tokens from `from` to `to` using the
409      * allowance mechanism. `amount` is then deducted from the caller's
410      * allowance.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * Emits a {Transfer} event.
415      */
416     function transferFrom(
417         address from,
418         address to,
419         uint256 amount
420     ) external returns (bool);
421 }
422 
423 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Interface of the ERC165 standard, as defined in the
432  * https://eips.ethereum.org/EIPS/eip-165[EIP].
433  *
434  * Implementers can declare support of contract interfaces, which can then be
435  * queried by others ({ERC165Checker}).
436  *
437  * For an implementation, see {ERC165}.
438  */
439 interface IERC165 {
440     /**
441      * @dev Returns true if this contract implements the interface defined by
442      * `interfaceId`. See the corresponding
443      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
444      * to learn more about how these ids are created.
445      *
446      * This function call must use less than 30 000 gas.
447      */
448     function supportsInterface(bytes4 interfaceId) external view returns (bool);
449 }
450 
451 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
452 
453 
454 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
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
545      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
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
602 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 
610 /**
611  * @dev Implementation of the {IERC165} interface.
612  *
613  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
614  * for the additional interface id that will be supported. For example:
615  *
616  * ```solidity
617  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
618  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
619  * }
620  * ```
621  *
622  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
623  */
624 abstract contract ERC165 is IERC165 {
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629         return interfaceId == type(IERC165).interfaceId;
630     }
631 }
632 
633 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
634 
635 
636 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @dev _Available since v3.1._
643  */
644 interface IERC1155Receiver is IERC165 {
645     /**
646      * @dev Handles the receipt of a single ERC1155 token type. This function is
647      * called at the end of a `safeTransferFrom` after the balance has been updated.
648      *
649      * NOTE: To accept the transfer, this must return
650      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
651      * (i.e. 0xf23a6e61, or its own function selector).
652      *
653      * @param operator The address which initiated the transfer (i.e. msg.sender)
654      * @param from The address which previously owned the token
655      * @param id The ID of the token being transferred
656      * @param value The amount of tokens being transferred
657      * @param data Additional data with no specified format
658      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
659      */
660     function onERC1155Received(
661         address operator,
662         address from,
663         uint256 id,
664         uint256 value,
665         bytes calldata data
666     ) external returns (bytes4);
667 
668     /**
669      * @dev Handles the receipt of a multiple ERC1155 token types. This function
670      * is called at the end of a `safeBatchTransferFrom` after the balances have
671      * been updated.
672      *
673      * NOTE: To accept the transfer(s), this must return
674      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
675      * (i.e. 0xbc197c81, or its own function selector).
676      *
677      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
678      * @param from The address which previously owned the token
679      * @param ids An array containing ids of each token being transferred (order and length must match values array)
680      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
681      * @param data Additional data with no specified format
682      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
683      */
684     function onERC1155BatchReceived(
685         address operator,
686         address from,
687         uint256[] calldata ids,
688         uint256[] calldata values,
689         bytes calldata data
690     ) external returns (bytes4);
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
694 
695 
696 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 
702 
703 
704 
705 
706 /**
707  * @dev Implementation of the basic standard multi-token.
708  * See https://eips.ethereum.org/EIPS/eip-1155
709  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
710  *
711  * _Available since v3.1._
712  */
713 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
714     using Address for address;
715 
716     // Mapping from token ID to account balances
717     mapping(uint256 => mapping(address => uint256)) private _balances;
718 
719     // Mapping from account to operator approvals
720     mapping(address => mapping(address => bool)) private _operatorApprovals;
721 
722     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
723     string private _uri;
724 
725     /**
726      * @dev See {_setURI}.
727      */
728     constructor(string memory uri_) {
729         _setURI(uri_);
730     }
731 
732     /**
733      * @dev See {IERC165-supportsInterface}.
734      */
735     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
736         return
737             interfaceId == type(IERC1155).interfaceId ||
738             interfaceId == type(IERC1155MetadataURI).interfaceId ||
739             super.supportsInterface(interfaceId);
740     }
741 
742     /**
743      * @dev See {IERC1155MetadataURI-uri}.
744      *
745      * This implementation returns the same URI for *all* token types. It relies
746      * on the token type ID substitution mechanism
747      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
748      *
749      * Clients calling this function must replace the `\{id\}` substring with the
750      * actual token type ID.
751      */
752     function uri(uint256) public view virtual override returns (string memory) {
753         return _uri;
754     }
755 
756     /**
757      * @dev See {IERC1155-balanceOf}.
758      *
759      * Requirements:
760      *
761      * - `account` cannot be the zero address.
762      */
763     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
764         require(account != address(0), "ERC1155: address zero is not a valid owner");
765         return _balances[id][account];
766     }
767 
768     /**
769      * @dev See {IERC1155-balanceOfBatch}.
770      *
771      * Requirements:
772      *
773      * - `accounts` and `ids` must have the same length.
774      */
775     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
776         public
777         view
778         virtual
779         override
780         returns (uint256[] memory)
781     {
782         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
783 
784         uint256[] memory batchBalances = new uint256[](accounts.length);
785 
786         for (uint256 i = 0; i < accounts.length; ++i) {
787             batchBalances[i] = balanceOf(accounts[i], ids[i]);
788         }
789 
790         return batchBalances;
791     }
792 
793     /**
794      * @dev See {IERC1155-setApprovalForAll}.
795      */
796     function setApprovalForAll(address operator, bool approved) public virtual override {
797         _setApprovalForAll(_msgSender(), operator, approved);
798     }
799 
800     /**
801      * @dev See {IERC1155-isApprovedForAll}.
802      */
803     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
804         return _operatorApprovals[account][operator];
805     }
806 
807     /**
808      * @dev See {IERC1155-safeTransferFrom}.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 id,
814         uint256 amount,
815         bytes memory data
816     ) public virtual override {
817         require(
818             from == _msgSender() || isApprovedForAll(from, _msgSender()),
819             "ERC1155: caller is not token owner nor approved"
820         );
821         _safeTransferFrom(from, to, id, amount, data);
822     }
823 
824     /**
825      * @dev See {IERC1155-safeBatchTransferFrom}.
826      */
827     function safeBatchTransferFrom(
828         address from,
829         address to,
830         uint256[] memory ids,
831         uint256[] memory amounts,
832         bytes memory data
833     ) public virtual override {
834         require(
835             from == _msgSender() || isApprovedForAll(from, _msgSender()),
836             "ERC1155: caller is not token owner nor approved"
837         );
838         _safeBatchTransferFrom(from, to, ids, amounts, data);
839     }
840 
841     /**
842      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
843      *
844      * Emits a {TransferSingle} event.
845      *
846      * Requirements:
847      *
848      * - `to` cannot be the zero address.
849      * - `from` must have a balance of tokens of type `id` of at least `amount`.
850      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
851      * acceptance magic value.
852      */
853     function _safeTransferFrom(
854         address from,
855         address to,
856         uint256 id,
857         uint256 amount,
858         bytes memory data
859     ) internal virtual {
860         require(to != address(0), "ERC1155: transfer to the zero address");
861 
862         address operator = _msgSender();
863         uint256[] memory ids = _asSingletonArray(id);
864         uint256[] memory amounts = _asSingletonArray(amount);
865 
866         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
867 
868         uint256 fromBalance = _balances[id][from];
869         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
870         unchecked {
871             _balances[id][from] = fromBalance - amount;
872         }
873         _balances[id][to] += amount;
874 
875         emit TransferSingle(operator, from, to, id, amount);
876 
877         _afterTokenTransfer(operator, from, to, ids, amounts, data);
878 
879         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
880     }
881 
882     /**
883      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
884      *
885      * Emits a {TransferBatch} event.
886      *
887      * Requirements:
888      *
889      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
890      * acceptance magic value.
891      */
892     function _safeBatchTransferFrom(
893         address from,
894         address to,
895         uint256[] memory ids,
896         uint256[] memory amounts,
897         bytes memory data
898     ) internal virtual {
899         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
900         require(to != address(0), "ERC1155: transfer to the zero address");
901 
902         address operator = _msgSender();
903 
904         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
905 
906         for (uint256 i = 0; i < ids.length; ++i) {
907             uint256 id = ids[i];
908             uint256 amount = amounts[i];
909 
910             uint256 fromBalance = _balances[id][from];
911             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
912             unchecked {
913                 _balances[id][from] = fromBalance - amount;
914             }
915             _balances[id][to] += amount;
916         }
917 
918         emit TransferBatch(operator, from, to, ids, amounts);
919 
920         _afterTokenTransfer(operator, from, to, ids, amounts, data);
921 
922         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
923     }
924 
925     /**
926      * @dev Sets a new URI for all token types, by relying on the token type ID
927      * substitution mechanism
928      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
929      *
930      * By this mechanism, any occurrence of the `\{id\}` substring in either the
931      * URI or any of the amounts in the JSON file at said URI will be replaced by
932      * clients with the token type ID.
933      *
934      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
935      * interpreted by clients as
936      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
937      * for token type ID 0x4cce0.
938      *
939      * See {uri}.
940      *
941      * Because these URIs cannot be meaningfully represented by the {URI} event,
942      * this function emits no events.
943      */
944     function _setURI(string memory newuri) internal virtual {
945         _uri = newuri;
946     }
947 
948     /**
949      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
950      *
951      * Emits a {TransferSingle} event.
952      *
953      * Requirements:
954      *
955      * - `to` cannot be the zero address.
956      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
957      * acceptance magic value.
958      */
959     function _mint(
960         address to,
961         uint256 id,
962         uint256 amount,
963         bytes memory data
964     ) internal virtual {
965         require(to != address(0), "ERC1155: mint to the zero address");
966 
967         address operator = _msgSender();
968         uint256[] memory ids = _asSingletonArray(id);
969         uint256[] memory amounts = _asSingletonArray(amount);
970 
971         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
972 
973         _balances[id][to] += amount;
974         emit TransferSingle(operator, address(0), to, id, amount);
975 
976         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
977 
978         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
979     }
980 
981     /**
982      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
983      *
984      * Emits a {TransferBatch} event.
985      *
986      * Requirements:
987      *
988      * - `ids` and `amounts` must have the same length.
989      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
990      * acceptance magic value.
991      */
992     function _mintBatch(
993         address to,
994         uint256[] memory ids,
995         uint256[] memory amounts,
996         bytes memory data
997     ) internal virtual {
998         require(to != address(0), "ERC1155: mint to the zero address");
999         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1000 
1001         address operator = _msgSender();
1002 
1003         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1004 
1005         for (uint256 i = 0; i < ids.length; i++) {
1006             _balances[ids[i]][to] += amounts[i];
1007         }
1008 
1009         emit TransferBatch(operator, address(0), to, ids, amounts);
1010 
1011         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1012 
1013         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1014     }
1015 
1016     /**
1017      * @dev Destroys `amount` tokens of token type `id` from `from`
1018      *
1019      * Emits a {TransferSingle} event.
1020      *
1021      * Requirements:
1022      *
1023      * - `from` cannot be the zero address.
1024      * - `from` must have at least `amount` tokens of token type `id`.
1025      */
1026     function _burn(
1027         address from,
1028         uint256 id,
1029         uint256 amount
1030     ) internal virtual {
1031         require(from != address(0), "ERC1155: burn from the zero address");
1032 
1033         address operator = _msgSender();
1034         uint256[] memory ids = _asSingletonArray(id);
1035         uint256[] memory amounts = _asSingletonArray(amount);
1036 
1037         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1038 
1039         uint256 fromBalance = _balances[id][from];
1040         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1041         unchecked {
1042             _balances[id][from] = fromBalance - amount;
1043         }
1044 
1045         emit TransferSingle(operator, from, address(0), id, amount);
1046 
1047         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1048     }
1049 
1050     /**
1051      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1052      *
1053      * Emits a {TransferBatch} event.
1054      *
1055      * Requirements:
1056      *
1057      * - `ids` and `amounts` must have the same length.
1058      */
1059     function _burnBatch(
1060         address from,
1061         uint256[] memory ids,
1062         uint256[] memory amounts
1063     ) internal virtual {
1064         require(from != address(0), "ERC1155: burn from the zero address");
1065         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1066 
1067         address operator = _msgSender();
1068 
1069         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1070 
1071         for (uint256 i = 0; i < ids.length; i++) {
1072             uint256 id = ids[i];
1073             uint256 amount = amounts[i];
1074 
1075             uint256 fromBalance = _balances[id][from];
1076             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1077             unchecked {
1078                 _balances[id][from] = fromBalance - amount;
1079             }
1080         }
1081 
1082         emit TransferBatch(operator, from, address(0), ids, amounts);
1083 
1084         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1085     }
1086 
1087     /**
1088      * @dev Approve `operator` to operate on all of `owner` tokens
1089      *
1090      * Emits an {ApprovalForAll} event.
1091      */
1092     function _setApprovalForAll(
1093         address owner,
1094         address operator,
1095         bool approved
1096     ) internal virtual {
1097         require(owner != operator, "ERC1155: setting approval status for self");
1098         _operatorApprovals[owner][operator] = approved;
1099         emit ApprovalForAll(owner, operator, approved);
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before any token transfer. This includes minting
1104      * and burning, as well as batched variants.
1105      *
1106      * The same hook is called on both single and batched variants. For single
1107      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1108      *
1109      * Calling conditions (for each `id` and `amount` pair):
1110      *
1111      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1112      * of token type `id` will be  transferred to `to`.
1113      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1114      * for `to`.
1115      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1116      * will be burned.
1117      * - `from` and `to` are never both zero.
1118      * - `ids` and `amounts` have the same, non-zero length.
1119      *
1120      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1121      */
1122     function _beforeTokenTransfer(
1123         address operator,
1124         address from,
1125         address to,
1126         uint256[] memory ids,
1127         uint256[] memory amounts,
1128         bytes memory data
1129     ) internal virtual {}
1130 
1131     /**
1132      * @dev Hook that is called after any token transfer. This includes minting
1133      * and burning, as well as batched variants.
1134      *
1135      * The same hook is called on both single and batched variants. For single
1136      * transfers, the length of the `id` and `amount` arrays will be 1.
1137      *
1138      * Calling conditions (for each `id` and `amount` pair):
1139      *
1140      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1141      * of token type `id` will be  transferred to `to`.
1142      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1143      * for `to`.
1144      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1145      * will be burned.
1146      * - `from` and `to` are never both zero.
1147      * - `ids` and `amounts` have the same, non-zero length.
1148      *
1149      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1150      */
1151     function _afterTokenTransfer(
1152         address operator,
1153         address from,
1154         address to,
1155         uint256[] memory ids,
1156         uint256[] memory amounts,
1157         bytes memory data
1158     ) internal virtual {}
1159 
1160     function _doSafeTransferAcceptanceCheck(
1161         address operator,
1162         address from,
1163         address to,
1164         uint256 id,
1165         uint256 amount,
1166         bytes memory data
1167     ) private {
1168         if (to.isContract()) {
1169             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1170                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1171                     revert("ERC1155: ERC1155Receiver rejected tokens");
1172                 }
1173             } catch Error(string memory reason) {
1174                 revert(reason);
1175             } catch {
1176                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1177             }
1178         }
1179     }
1180 
1181     function _doSafeBatchTransferAcceptanceCheck(
1182         address operator,
1183         address from,
1184         address to,
1185         uint256[] memory ids,
1186         uint256[] memory amounts,
1187         bytes memory data
1188     ) private {
1189         if (to.isContract()) {
1190             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1191                 bytes4 response
1192             ) {
1193                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1194                     revert("ERC1155: ERC1155Receiver rejected tokens");
1195                 }
1196             } catch Error(string memory reason) {
1197                 revert(reason);
1198             } catch {
1199                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1200             }
1201         }
1202     }
1203 
1204     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1205         uint256[] memory array = new uint256[](1);
1206         array[0] = element;
1207 
1208         return array;
1209     }
1210 }
1211 
1212 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol
1213 
1214 
1215 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)
1216 
1217 pragma solidity ^0.8.0;
1218 
1219 
1220 
1221 /**
1222  * @dev _Available since v3.1._
1223  */
1224 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
1225     /**
1226      * @dev See {IERC165-supportsInterface}.
1227      */
1228     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1229         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
1230     }
1231 }
1232 
1233 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol
1234 
1235 
1236 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/utils/ERC1155Holder.sol)
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 
1241 /**
1242  * Simple implementation of `ERC1155Receiver` that will allow a contract to hold ERC1155 tokens.
1243  *
1244  * IMPORTANT: When inheriting this contract, you must include a way to use the received tokens, otherwise they will be
1245  * stuck.
1246  *
1247  * @dev _Available since v3.1._
1248  */
1249 contract ERC1155Holder is ERC1155Receiver {
1250     function onERC1155Received(
1251         address,
1252         address,
1253         uint256,
1254         uint256,
1255         bytes memory
1256     ) public virtual override returns (bytes4) {
1257         return this.onERC1155Received.selector;
1258     }
1259 
1260     function onERC1155BatchReceived(
1261         address,
1262         address,
1263         uint256[] memory,
1264         uint256[] memory,
1265         bytes memory
1266     ) public virtual override returns (bytes4) {
1267         return this.onERC1155BatchReceived.selector;
1268     }
1269 }
1270 
1271 // File: contracts/unchartedMarketplace.sol
1272 
1273 
1274 
1275 pragma solidity 0.8.17;
1276 
1277 
1278 
1279 
1280 
1281 
1282 
1283 
1284 contract UnchartedMarketplace is ERC1155Holder, Ownable {
1285 
1286     // For airdrop
1287 
1288     IERC20 public usdcAddress;
1289 
1290 
1291 
1292     address payable public walletToSend; // The wallet where ETH from purchases should be sent
1293 
1294 
1295 
1296     IERC1155 public tokenAddress;
1297 
1298     uint256 public tokenId = 0;
1299 
1300     uint256 public tokenPrice = 19 * 1e16; // in the native currency (ETH) - wei
1301 
1302     // allowable smart contract NFT limit (for pre-sale and sale limitation)
1303 
1304     uint256 public allowableSCLimit = 0;
1305 
1306     uint256 public limitPerWallet = 0;
1307 
1308 
1309 
1310     event BuyEvent(address indexed buyer, IERC1155 indexed tokenAddress, uint256 indexed tokenId, uint256 amount);
1311 
1312     event GiveAwayEvent(IERC1155 indexed tokenAddress, address indexed recipient, uint256 indexed tokenId, uint256 amount);
1313 
1314     event PriceChangedEvent(uint256 indexed price);
1315 
1316     event UsdcAddressChangedEvent(address indexed usdcAddress);
1317 
1318     event WalletToSendAddressChangedEvent(address indexed newAddress);
1319 
1320     event AllowableSCLimitChangedEvent(uint256 indexed amount);
1321 
1322     event UnchartedTokenAddressChangedEvent(address indexed _address);
1323 
1324     event TokenIdChangedEvent(uint256 indexed _tokenId);
1325 
1326     event LimitPerWalletChangedEvent(uint256 indexed amount);
1327 
1328 
1329 
1330     constructor(
1331 
1332         address _usdcAddress,
1333 
1334         address payable _walletToSend,
1335 
1336         address _tokenAddress
1337 
1338     ) {
1339 
1340         walletToSend = _walletToSend;
1341 
1342         usdcAddress = IERC20(_usdcAddress);
1343 
1344         tokenAddress = IERC1155(_tokenAddress);
1345 
1346     }
1347 
1348 
1349 
1350     function setTokenId(uint256 _tokenId) public onlyOwner {
1351 
1352         tokenId = _tokenId;
1353 
1354 
1355 
1356         emit TokenIdChangedEvent(_tokenId);
1357 
1358     }
1359 
1360 
1361 
1362     function setTokenPrice(uint256 price) public onlyOwner {
1363 
1364         tokenPrice = price;
1365 
1366 
1367 
1368         emit PriceChangedEvent(price);
1369 
1370     }
1371 
1372 
1373 
1374     function setUnchartedTokenAddress(address _address) public onlyOwner {
1375 
1376         tokenAddress = IERC1155(_address);
1377 
1378 
1379 
1380         emit UnchartedTokenAddressChangedEvent(_address);
1381 
1382     }
1383 
1384 
1385 
1386     function setAllowableSCLimit(uint256 amount) public onlyOwner {
1387 
1388         allowableSCLimit = amount;
1389 
1390 
1391 
1392         emit AllowableSCLimitChangedEvent(amount);
1393 
1394     }
1395 
1396 
1397 
1398     function startNewSales(
1399 
1400         address _tokenAddress,
1401 
1402         uint256 _tokenId,
1403 
1404         uint256 price,
1405 
1406         uint256 _allowableSCLimit
1407 
1408     ) external onlyOwner {
1409 
1410         setUnchartedTokenAddress(_tokenAddress);
1411 
1412         setTokenId(_tokenId);
1413 
1414         setTokenPrice(price);
1415 
1416         setAllowableSCLimit(_allowableSCLimit);
1417 
1418     }
1419 
1420 
1421 
1422     function setUsdcAddress(address _usdcAddress) external onlyOwner {
1423 
1424         require(_usdcAddress != address(0x0), "Invalid address");
1425 
1426         usdcAddress = IERC20(_usdcAddress);
1427 
1428 
1429 
1430         emit UsdcAddressChangedEvent(_usdcAddress);
1431 
1432     }
1433 
1434 
1435 
1436     function setWalletToSend(address payable newAddress) external onlyOwner {
1437 
1438         require(newAddress != address(0x0), "Invalid address");
1439 
1440         walletToSend = newAddress;
1441 
1442 
1443 
1444         emit WalletToSendAddressChangedEvent(newAddress);
1445 
1446     }
1447 
1448 
1449 
1450     function setLimitPerWallet(uint256 amount) external onlyOwner {
1451 
1452         limitPerWallet = amount;
1453 
1454 
1455 
1456         emit LimitPerWalletChangedEvent(amount);
1457 
1458     }
1459 
1460 
1461 
1462     function buy(uint256 amount) external payable {
1463 
1464         require(tokenPrice > 0, "Not for sale yet");
1465 
1466         require(amount * tokenPrice == msg.value, "ETH amount mismatch");
1467 
1468         require(tokenAddress.balanceOf(address(this), tokenId) >= amount, "There is no such amount of tokens");
1469 
1470         require(
1471 
1472             tokenAddress.balanceOf(address(this), tokenId) - amount >= allowableSCLimit,
1473 
1474             string.concat("Limit reached")
1475 
1476         );
1477 
1478         if (limitPerWallet > 0) {
1479 
1480             require(
1481 
1482                 tokenAddress.balanceOf(msg.sender, tokenId) + amount <= limitPerWallet,
1483 
1484                 "Limit per wallet reached"
1485 
1486             );
1487 
1488         }
1489 
1490 
1491 
1492         walletToSend.transfer(msg.value);
1493 
1494         tokenAddress.safeTransferFrom(address(this), msg.sender, tokenId, amount, "0x0");
1495 
1496 
1497 
1498         emit BuyEvent(msg.sender, tokenAddress, tokenId, amount);
1499 
1500     }
1501 
1502 
1503 
1504     function giveAway(address recipient, uint256 amount) external onlyOwner {
1505 
1506         tokenAddress.safeTransferFrom(address(this), recipient, tokenId, amount, "GiveAway");
1507 
1508 
1509 
1510         emit GiveAwayEvent(tokenAddress, recipient, tokenId, amount);
1511 
1512     }
1513 
1514 
1515 
1516     function giveAwayBatch(address[] memory recipients, uint256[] memory amount) external onlyOwner {
1517 
1518         require(recipients.length == amount.length, "Recipient and amount arrays mismatch");
1519 
1520         uint sum = 0;
1521 
1522         for (uint i = 0; i < recipients.length; i++) {
1523 
1524             require(recipients[i] != address(0), "Recipient should not have 0x0 address");
1525 
1526             sum += amount[i];
1527 
1528         }
1529 
1530         require(tokenAddress.balanceOf(msg.sender, tokenId) >= sum, "Insufficient amount of tokens");
1531 
1532 
1533 
1534         for (uint i = 0; i < recipients.length; i++) {
1535 
1536             tokenAddress.safeTransferFrom(address(this), recipients[i], tokenId, amount[i], "GiveAway");
1537 
1538             emit GiveAwayEvent(tokenAddress, recipients[i], tokenId, amount[i]);
1539 
1540         }
1541 
1542     }
1543 
1544 
1545 
1546     function airdrop(address[] memory recipients, uint256[] memory amount) external {
1547 
1548         require(recipients.length == amount.length, "Recipient and amount arrays mismatch");
1549 
1550         uint sum = 0;
1551 
1552         for (uint i = 0; i < recipients.length; i++) {
1553 
1554             require(recipients[i] != address(0), "Recipient should not have 0x0 address");
1555 
1556             sum += amount[i];
1557 
1558         }
1559 
1560         require(usdcAddress.allowance(msg.sender, address(this)) >= sum, "Insufficient USDC allowance");
1561 
1562         require(usdcAddress.balanceOf(msg.sender) >= sum, "Insufficient USDC");
1563 
1564 
1565 
1566         for (uint i = 0; i < recipients.length; i++) {
1567 
1568             require(
1569 
1570                 usdcAddress.transferFrom(msg.sender, recipients[i], amount[i]) == true,
1571 
1572                 "Unable to transfer"
1573 
1574             );
1575 
1576         }
1577 
1578     }
1579 
1580 
1581 
1582     // If a user sends other tokens to this smart contract, the owner can transfer it to himself.
1583 
1584     function withdrawToken(address _tokenContract, address _recipient, uint256 _amount) external onlyOwner {
1585 
1586         IERC20 tokenContract = IERC20(_tokenContract);
1587 
1588 
1589 
1590         // transfer the token from address of this contract
1591 
1592         // to address of the user (executing the withdrawToken() function)
1593 
1594         tokenContract.transfer(_recipient, _amount);
1595 
1596     }
1597 
1598 }