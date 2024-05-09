1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 
29 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         _checkOwner();
63         _;
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if the sender is not the owner.
75      */
76     function _checkOwner() internal view virtual {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         _transferOwnership(address(0));
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Internal function without access restriction.
103      */
104     function _transferOwnership(address newOwner) internal virtual {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/Address.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
115 
116 pragma solidity ^0.8.1;
117 
118 /**
119  * @dev Collection of functions related to the address type
120  */
121 library Address {
122     /**
123      * @dev Returns true if `account` is a contract.
124      *
125      * [IMPORTANT]
126      * ====
127      * It is unsafe to assume that an address for which this function returns
128      * false is an externally-owned account (EOA) and not a contract.
129      *
130      * Among others, `isContract` will return false for the following
131      * types of addresses:
132      *
133      *  - an externally-owned account
134      *  - a contract in construction
135      *  - an address where a contract will be created
136      *  - an address where a contract lived, but was destroyed
137      * ====
138      *
139      * [IMPORTANT]
140      * ====
141      * You shouldn't rely on `isContract` to protect against flash loan attacks!
142      *
143      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
144      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
145      * constructor.
146      * ====
147      */
148     function isContract(address account) internal view returns (bool) {
149         // This method relies on extcodesize/address.code.length, which returns 0
150         // for contracts in construction, since the code is only stored at the end
151         // of the constructor execution.
152 
153         return account.code.length > 0;
154     }
155 
156     /**
157      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
158      * `recipient`, forwarding all available gas and reverting on errors.
159      *
160      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
161      * of certain opcodes, possibly making contracts go over the 2300 gas limit
162      * imposed by `transfer`, making them unable to receive funds via
163      * `transfer`. {sendValue} removes this limitation.
164      *
165      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
166      *
167      * IMPORTANT: because control is transferred to `recipient`, care must be
168      * taken to not create reentrancy vulnerabilities. Consider using
169      * {ReentrancyGuard} or the
170      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
171      */
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, "Address: insufficient balance");
174 
175         (bool success, ) = recipient.call{value: amount}("");
176         require(success, "Address: unable to send value, recipient may have reverted");
177     }
178 
179     /**
180      * @dev Performs a Solidity function call using a low level `call`. A
181      * plain `call` is an unsafe replacement for a function call: use this
182      * function instead.
183      *
184      * If `target` reverts with a revert reason, it is bubbled up by this
185      * function (like regular Solidity function calls).
186      *
187      * Returns the raw returned data. To convert to the expected return value,
188      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
189      *
190      * Requirements:
191      *
192      * - `target` must be a contract.
193      * - calling `target` with `data` must not revert.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
203      * `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, 0, errorMessage);
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217      * but also transferring `value` wei to `target`.
218      *
219      * Requirements:
220      *
221      * - the calling contract must have an ETH balance of at least `value`.
222      * - the called Solidity function must be `payable`.
223      *
224      * _Available since v3.1._
225      */
226     function functionCallWithValue(
227         address target,
228         bytes memory data,
229         uint256 value
230     ) internal returns (bytes memory) {
231         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
236      * with `errorMessage` as a fallback revert reason when `target` reverts.
237      *
238      * _Available since v3.1._
239      */
240     function functionCallWithValue(
241         address target,
242         bytes memory data,
243         uint256 value,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         require(address(this).balance >= value, "Address: insufficient balance for call");
247         (bool success, bytes memory returndata) = target.call{value: value}(data);
248         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
258         return functionStaticCall(target, data, "Address: low-level static call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a static call.
264      *
265      * _Available since v3.3._
266      */
267     function functionStaticCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal view returns (bytes memory) {
272         (bool success, bytes memory returndata) = target.staticcall(data);
273         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a delegate call.
279      *
280      * _Available since v3.4._
281      */
282     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a delegate call.
289      *
290      * _Available since v3.4._
291      */
292     function functionDelegateCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         (bool success, bytes memory returndata) = target.delegatecall(data);
298         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
303      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
304      *
305      * _Available since v4.8._
306      */
307     function verifyCallResultFromTarget(
308         address target,
309         bool success,
310         bytes memory returndata,
311         string memory errorMessage
312     ) internal view returns (bytes memory) {
313         if (success) {
314             if (returndata.length == 0) {
315                 // only check isContract if the call was successful and the return data is empty
316                 // otherwise we already know that it was a contract
317                 require(isContract(target), "Address: call to non-contract");
318             }
319             return returndata;
320         } else {
321             _revert(returndata, errorMessage);
322         }
323     }
324 
325     /**
326      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
327      * revert reason or using the provided one.
328      *
329      * _Available since v4.3._
330      */
331     function verifyCallResult(
332         bool success,
333         bytes memory returndata,
334         string memory errorMessage
335     ) internal pure returns (bytes memory) {
336         if (success) {
337             return returndata;
338         } else {
339             _revert(returndata, errorMessage);
340         }
341     }
342 
343     function _revert(bytes memory returndata, string memory errorMessage) private pure {
344         // Look for revert reason and bubble it up if present
345         if (returndata.length > 0) {
346             // The easiest way to bubble the revert reason is using memory via assembly
347             /// @solidity memory-safe-assembly
348             assembly {
349                 let returndata_size := mload(returndata)
350                 revert(add(32, returndata), returndata_size)
351             }
352         } else {
353             revert(errorMessage);
354         }
355     }
356 }
357 
358 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
359 
360 
361 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
362 
363 pragma solidity ^0.8.0;
364 
365 /**
366  * @dev Interface of the ERC165 standard, as defined in the
367  * https://eips.ethereum.org/EIPS/eip-165[EIP].
368  *
369  * Implementers can declare support of contract interfaces, which can then be
370  * queried by others ({ERC165Checker}).
371  *
372  * For an implementation, see {ERC165}.
373  */
374 interface IERC165 {
375     /**
376      * @dev Returns true if this contract implements the interface defined by
377      * `interfaceId`. See the corresponding
378      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
379      * to learn more about how these ids are created.
380      *
381      * This function call must use less than 30 000 gas.
382      */
383     function supportsInterface(bytes4 interfaceId) external view returns (bool);
384 }
385 
386 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev Implementation of the {IERC165} interface.
396  *
397  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
398  * for the additional interface id that will be supported. For example:
399  *
400  * ```solidity
401  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
402  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
403  * }
404  * ```
405  *
406  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
407  */
408 abstract contract ERC165 is IERC165 {
409     /**
410      * @dev See {IERC165-supportsInterface}.
411      */
412     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
413         return interfaceId == type(IERC165).interfaceId;
414     }
415 }
416 
417 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
418 
419 
420 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 
425 /**
426  * @dev _Available since v3.1._
427  */
428 interface IERC1155Receiver is IERC165 {
429     /**
430      * @dev Handles the receipt of a single ERC1155 token type. This function is
431      * called at the end of a `safeTransferFrom` after the balance has been updated.
432      *
433      * NOTE: To accept the transfer, this must return
434      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
435      * (i.e. 0xf23a6e61, or its own function selector).
436      *
437      * @param operator The address which initiated the transfer (i.e. msg.sender)
438      * @param from The address which previously owned the token
439      * @param id The ID of the token being transferred
440      * @param value The amount of tokens being transferred
441      * @param data Additional data with no specified format
442      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
443      */
444     function onERC1155Received(
445         address operator,
446         address from,
447         uint256 id,
448         uint256 value,
449         bytes calldata data
450     ) external returns (bytes4);
451 
452     /**
453      * @dev Handles the receipt of a multiple ERC1155 token types. This function
454      * is called at the end of a `safeBatchTransferFrom` after the balances have
455      * been updated.
456      *
457      * NOTE: To accept the transfer(s), this must return
458      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
459      * (i.e. 0xbc197c81, or its own function selector).
460      *
461      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
462      * @param from The address which previously owned the token
463      * @param ids An array containing ids of each token being transferred (order and length must match values array)
464      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
465      * @param data Additional data with no specified format
466      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
467      */
468     function onERC1155BatchReceived(
469         address operator,
470         address from,
471         uint256[] calldata ids,
472         uint256[] calldata values,
473         bytes calldata data
474     ) external returns (bytes4);
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
478 
479 
480 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Required interface of an ERC1155 compliant contract, as defined in the
487  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
488  *
489  * _Available since v3.1._
490  */
491 interface IERC1155 is IERC165 {
492     /**
493      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
494      */
495     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
496 
497     /**
498      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
499      * transfers.
500      */
501     event TransferBatch(
502         address indexed operator,
503         address indexed from,
504         address indexed to,
505         uint256[] ids,
506         uint256[] values
507     );
508 
509     /**
510      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
511      * `approved`.
512      */
513     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
514 
515     /**
516      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
517      *
518      * If an {URI} event was emitted for `id`, the standard
519      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
520      * returned by {IERC1155MetadataURI-uri}.
521      */
522     event URI(string value, uint256 indexed id);
523 
524     /**
525      * @dev Returns the amount of tokens of token type `id` owned by `account`.
526      *
527      * Requirements:
528      *
529      * - `account` cannot be the zero address.
530      */
531     function balanceOf(address account, uint256 id) external view returns (uint256);
532 
533     /**
534      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
535      *
536      * Requirements:
537      *
538      * - `accounts` and `ids` must have the same length.
539      */
540     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
541         external
542         view
543         returns (uint256[] memory);
544 
545     /**
546      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
547      *
548      * Emits an {ApprovalForAll} event.
549      *
550      * Requirements:
551      *
552      * - `operator` cannot be the caller.
553      */
554     function setApprovalForAll(address operator, bool approved) external;
555 
556     /**
557      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
558      *
559      * See {setApprovalForAll}.
560      */
561     function isApprovedForAll(address account, address operator) external view returns (bool);
562 
563     /**
564      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
565      *
566      * Emits a {TransferSingle} event.
567      *
568      * Requirements:
569      *
570      * - `to` cannot be the zero address.
571      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
572      * - `from` must have a balance of tokens of type `id` of at least `amount`.
573      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
574      * acceptance magic value.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 id,
580         uint256 amount,
581         bytes calldata data
582     ) external;
583 
584     /**
585      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
586      *
587      * Emits a {TransferBatch} event.
588      *
589      * Requirements:
590      *
591      * - `ids` and `amounts` must have the same length.
592      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
593      * acceptance magic value.
594      */
595     function safeBatchTransferFrom(
596         address from,
597         address to,
598         uint256[] calldata ids,
599         uint256[] calldata amounts,
600         bytes calldata data
601     ) external;
602 }
603 
604 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 
612 /**
613  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
614  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
615  *
616  * _Available since v3.1._
617  */
618 interface IERC1155MetadataURI is IERC1155 {
619     /**
620      * @dev Returns the URI for token type `id`.
621      *
622      * If the `\{id\}` substring is present in the URI, it must be replaced by
623      * clients with the actual token type ID.
624      */
625     function uri(uint256 id) external view returns (string memory);
626 }
627 
628 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
629 
630 
631 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 
636 
637 
638 
639 
640 
641 /**
642  * @dev Implementation of the basic standard multi-token.
643  * See https://eips.ethereum.org/EIPS/eip-1155
644  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
645  *
646  * _Available since v3.1._
647  */
648 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
649     using Address for address;
650 
651     // Mapping from token ID to account balances
652     mapping(uint256 => mapping(address => uint256)) internal _balances;
653 
654     // Mapping from account to operator approvals
655     mapping(address => mapping(address => bool)) private _operatorApprovals;
656 
657     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
658     string private _uri;
659 
660     /**
661      * @dev See {_setURI}.
662      */
663     constructor(string memory uri_) {
664         _setURI(uri_);
665     }
666 
667     /**
668      * @dev See {IERC165-supportsInterface}.
669      */
670     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
671         return
672             interfaceId == type(IERC1155).interfaceId ||
673             interfaceId == type(IERC1155MetadataURI).interfaceId ||
674             super.supportsInterface(interfaceId);
675     }
676 
677     /**
678      * @dev See {IERC1155MetadataURI-uri}.
679      *
680      * This implementation returns the same URI for *all* token types. It relies
681      * on the token type ID substitution mechanism
682      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
683      *
684      * Clients calling this function must replace the `\{id\}` substring with the
685      * actual token type ID.
686      */
687     function uri(uint256) public view virtual override returns (string memory) {
688         return _uri;
689     }
690 
691     /**
692      * @dev See {IERC1155-balanceOf}.
693      *
694      * Requirements:
695      *
696      * - `account` cannot be the zero address.
697      */
698     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
699         require(account != address(0), "ERC1155: address zero is not a valid owner");
700         return _balances[id][account];
701     }
702 
703     /**
704      * @dev See {IERC1155-balanceOfBatch}.
705      *
706      * Requirements:
707      *
708      * - `accounts` and `ids` must have the same length.
709      */
710     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
711         public
712         view
713         virtual
714         override
715         returns (uint256[] memory)
716     {
717         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
718 
719         uint256[] memory batchBalances = new uint256[](accounts.length);
720 
721         for (uint256 i = 0; i < accounts.length; ++i) {
722             batchBalances[i] = balanceOf(accounts[i], ids[i]);
723         }
724 
725         return batchBalances;
726     }
727 
728     /**
729      * @dev See {IERC1155-setApprovalForAll}.
730      */
731     function setApprovalForAll(address operator, bool approved) public virtual override {
732         _setApprovalForAll(_msgSender(), operator, approved);
733     }
734 
735     /**
736      * @dev See {IERC1155-isApprovedForAll}.
737      */
738     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
739         return _operatorApprovals[account][operator];
740     }
741 
742     /**
743      * @dev See {IERC1155-safeTransferFrom}.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 id,
749         uint256 amount,
750         bytes memory data
751     ) public virtual override {
752         require(
753             from == _msgSender() || isApprovedForAll(from, _msgSender()),
754             "ERC1155: caller is not token owner or approved"
755         );
756         _safeTransferFrom(from, to, id, amount, data);
757     }
758 
759     /**
760      * @dev See {IERC1155-safeBatchTransferFrom}.
761      */
762     function safeBatchTransferFrom(
763         address from,
764         address to,
765         uint256[] memory ids,
766         uint256[] memory amounts,
767         bytes memory data
768     ) public virtual override {
769         require(
770             from == _msgSender() || isApprovedForAll(from, _msgSender()),
771             "ERC1155: caller is not token owner or approved"
772         );
773         _safeBatchTransferFrom(from, to, ids, amounts, data);
774     }
775 
776     /**
777      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
778      *
779      * Emits a {TransferSingle} event.
780      *
781      * Requirements:
782      *
783      * - `to` cannot be the zero address.
784      * - `from` must have a balance of tokens of type `id` of at least `amount`.
785      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
786      * acceptance magic value.
787      */
788     function _safeTransferFrom(
789         address from,
790         address to,
791         uint256 id,
792         uint256 amount,
793         bytes memory data
794     ) internal virtual {
795         require(to != address(0), "ERC1155: transfer to the zero address");
796 
797         address operator = _msgSender();
798         uint256[] memory ids = _asSingletonArray(id);
799         uint256[] memory amounts = _asSingletonArray(amount);
800 
801         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
802 
803         uint256 fromBalance = _balances[id][from];
804         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
805         unchecked {
806             _balances[id][from] = fromBalance - amount;
807         }
808         _balances[id][to] += amount;
809 
810         emit TransferSingle(operator, from, to, id, amount);
811 
812         _afterTokenTransfer(operator, from, to, ids, amounts, data);
813 
814         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
815     }
816 
817     /**
818      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
819      *
820      * Emits a {TransferBatch} event.
821      *
822      * Requirements:
823      *
824      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
825      * acceptance magic value.
826      */
827     function _safeBatchTransferFrom(
828         address from,
829         address to,
830         uint256[] memory ids,
831         uint256[] memory amounts,
832         bytes memory data
833     ) internal virtual {
834         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
835         require(to != address(0), "ERC1155: transfer to the zero address");
836 
837         address operator = _msgSender();
838 
839         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
840 
841         for (uint256 i = 0; i < ids.length; ++i) {
842             uint256 id = ids[i];
843             uint256 amount = amounts[i];
844 
845             uint256 fromBalance = _balances[id][from];
846             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
847             unchecked {
848                 _balances[id][from] = fromBalance - amount;
849             }
850             _balances[id][to] += amount;
851         }
852 
853         emit TransferBatch(operator, from, to, ids, amounts);
854 
855         _afterTokenTransfer(operator, from, to, ids, amounts, data);
856 
857         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
858     }
859 
860     /**
861      * @dev Sets a new URI for all token types, by relying on the token type ID
862      * substitution mechanism
863      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
864      *
865      * By this mechanism, any occurrence of the `\{id\}` substring in either the
866      * URI or any of the amounts in the JSON file at said URI will be replaced by
867      * clients with the token type ID.
868      *
869      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
870      * interpreted by clients as
871      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
872      * for token type ID 0x4cce0.
873      *
874      * See {uri}.
875      *
876      * Because these URIs cannot be meaningfully represented by the {URI} event,
877      * this function emits no events.
878      */
879     function _setURI(string memory newuri) internal virtual {
880         _uri = newuri;
881     }
882 
883     /**
884      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
885      *
886      * Emits a {TransferSingle} event.
887      *
888      * Requirements:
889      *
890      * - `to` cannot be the zero address.
891      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
892      * acceptance magic value.
893      */
894     function _mint(
895         address to,
896         uint256 id,
897         uint256 amount,
898         bytes memory data
899     ) internal virtual {
900         require(to != address(0), "ERC1155: mint to the zero address");
901 
902         address operator = _msgSender();
903         uint256[] memory ids = _asSingletonArray(id);
904         uint256[] memory amounts = _asSingletonArray(amount);
905 
906         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
907 
908         _balances[id][to] += amount;
909         emit TransferSingle(operator, address(0), to, id, amount);
910 
911         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
912 
913         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
914     }
915 
916     /**
917      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
918      *
919      * Emits a {TransferBatch} event.
920      *
921      * Requirements:
922      *
923      * - `ids` and `amounts` must have the same length.
924      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
925      * acceptance magic value.
926      */
927     function _mintBatch(
928         address to,
929         uint256[] memory ids,
930         uint256[] memory amounts,
931         bytes memory data
932     ) internal virtual {
933         require(to != address(0), "ERC1155: mint to the zero address");
934         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
935 
936         address operator = _msgSender();
937 
938         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
939 
940         for (uint256 i = 0; i < ids.length; i++) {
941             _balances[ids[i]][to] += amounts[i];
942         }
943 
944         emit TransferBatch(operator, address(0), to, ids, amounts);
945 
946         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
947 
948         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
949     }
950 
951     /**
952      * @dev Destroys `amount` tokens of token type `id` from `from`
953      *
954      * Emits a {TransferSingle} event.
955      *
956      * Requirements:
957      *
958      * - `from` cannot be the zero address.
959      * - `from` must have at least `amount` tokens of token type `id`.
960      */
961     function _burn(
962         address from,
963         uint256 id,
964         uint256 amount
965     ) internal virtual {
966         require(from != address(0), "ERC1155: burn from the zero address");
967 
968         address operator = _msgSender();
969         uint256[] memory ids = _asSingletonArray(id);
970         uint256[] memory amounts = _asSingletonArray(amount);
971 
972         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
973 
974         uint256 fromBalance = _balances[id][from];
975         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
976         unchecked {
977             _balances[id][from] = fromBalance - amount;
978         }
979 
980         emit TransferSingle(operator, from, address(0), id, amount);
981 
982         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
983     }
984 
985     /**
986      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
987      *
988      * Emits a {TransferBatch} event.
989      *
990      * Requirements:
991      *
992      * - `ids` and `amounts` must have the same length.
993      */
994     function _burnBatch(
995         address from,
996         uint256[] memory ids,
997         uint256[] memory amounts
998     ) internal virtual {
999         require(from != address(0), "ERC1155: burn from the zero address");
1000         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1001 
1002         address operator = _msgSender();
1003 
1004         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1005 
1006         for (uint256 i = 0; i < ids.length; i++) {
1007             uint256 id = ids[i];
1008             uint256 amount = amounts[i];
1009 
1010             uint256 fromBalance = _balances[id][from];
1011             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1012             unchecked {
1013                 _balances[id][from] = fromBalance - amount;
1014             }
1015         }
1016 
1017         emit TransferBatch(operator, from, address(0), ids, amounts);
1018 
1019         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1020     }
1021 
1022     /**
1023      * @dev Approve `operator` to operate on all of `owner` tokens
1024      *
1025      * Emits an {ApprovalForAll} event.
1026      */
1027     function _setApprovalForAll(
1028         address owner,
1029         address operator,
1030         bool approved
1031     ) internal virtual {
1032         require(owner != operator, "ERC1155: setting approval status for self");
1033         _operatorApprovals[owner][operator] = approved;
1034         emit ApprovalForAll(owner, operator, approved);
1035     }
1036 
1037     /**
1038      * @dev Hook that is called before any token transfer. This includes minting
1039      * and burning, as well as batched variants.
1040      *
1041      * The same hook is called on both single and batched variants. For single
1042      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1043      *
1044      * Calling conditions (for each `id` and `amount` pair):
1045      *
1046      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1047      * of token type `id` will be  transferred to `to`.
1048      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1049      * for `to`.
1050      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1051      * will be burned.
1052      * - `from` and `to` are never both zero.
1053      * - `ids` and `amounts` have the same, non-zero length.
1054      *
1055      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1056      */
1057     function _beforeTokenTransfer(
1058         address operator,
1059         address from,
1060         address to,
1061         uint256[] memory ids,
1062         uint256[] memory amounts,
1063         bytes memory data
1064     ) internal virtual {}
1065 
1066     /**
1067      * @dev Hook that is called after any token transfer. This includes minting
1068      * and burning, as well as batched variants.
1069      *
1070      * The same hook is called on both single and batched variants. For single
1071      * transfers, the length of the `id` and `amount` arrays will be 1.
1072      *
1073      * Calling conditions (for each `id` and `amount` pair):
1074      *
1075      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1076      * of token type `id` will be  transferred to `to`.
1077      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1078      * for `to`.
1079      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1080      * will be burned.
1081      * - `from` and `to` are never both zero.
1082      * - `ids` and `amounts` have the same, non-zero length.
1083      *
1084      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1085      */
1086     function _afterTokenTransfer(
1087         address operator,
1088         address from,
1089         address to,
1090         uint256[] memory ids,
1091         uint256[] memory amounts,
1092         bytes memory data
1093     ) internal virtual {}
1094 
1095     function _doSafeTransferAcceptanceCheck(
1096         address operator,
1097         address from,
1098         address to,
1099         uint256 id,
1100         uint256 amount,
1101         bytes memory data
1102     ) private {
1103         if (to.isContract()) {
1104             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1105                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1106                     revert("ERC1155: ERC1155Receiver rejected tokens");
1107                 }
1108             } catch Error(string memory reason) {
1109                 revert(reason);
1110             } catch {
1111                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1112             }
1113         }
1114     }
1115 
1116     function _doSafeBatchTransferAcceptanceCheck(
1117         address operator,
1118         address from,
1119         address to,
1120         uint256[] memory ids,
1121         uint256[] memory amounts,
1122         bytes memory data
1123     ) private {
1124         if (to.isContract()) {
1125             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1126                 bytes4 response
1127             ) {
1128                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1129                     revert("ERC1155: ERC1155Receiver rejected tokens");
1130                 }
1131             } catch Error(string memory reason) {
1132                 revert(reason);
1133             } catch {
1134                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1135             }
1136         }
1137     }
1138 
1139     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1140         uint256[] memory array = new uint256[](1);
1141         array[0] = element;
1142 
1143         return array;
1144     }
1145 }
1146 
1147 // File: @openzeppelin/contracts/utils/math/Math.sol
1148 
1149 
1150 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1151 
1152 pragma solidity ^0.8.0;
1153 
1154 /**
1155  * @dev Standard math utilities missing in the Solidity language.
1156  */
1157 library Math {
1158     enum Rounding {
1159         Down, // Toward negative infinity
1160         Up, // Toward infinity
1161         Zero // Toward zero
1162     }
1163 
1164     /**
1165      * @dev Returns the largest of two numbers.
1166      */
1167     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1168         return a > b ? a : b;
1169     }
1170 
1171     /**
1172      * @dev Returns the smallest of two numbers.
1173      */
1174     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1175         return a < b ? a : b;
1176     }
1177 
1178     /**
1179      * @dev Returns the average of two numbers. The result is rounded towards
1180      * zero.
1181      */
1182     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1183         // (a + b) / 2 can overflow.
1184         return (a & b) + (a ^ b) / 2;
1185     }
1186 
1187     /**
1188      * @dev Returns the ceiling of the division of two numbers.
1189      *
1190      * This differs from standard division with `/` in that it rounds up instead
1191      * of rounding down.
1192      */
1193     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1194         // (a + b - 1) / b can overflow on addition, so we distribute.
1195         return a == 0 ? 0 : (a - 1) / b + 1;
1196     }
1197 
1198     /**
1199      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1200      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1201      * with further edits by Uniswap Labs also under MIT license.
1202      */
1203     function mulDiv(
1204         uint256 x,
1205         uint256 y,
1206         uint256 denominator
1207     ) internal pure returns (uint256 result) {
1208         unchecked {
1209             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1210             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1211             // variables such that product = prod1 * 2^256 + prod0.
1212             uint256 prod0; // Least significant 256 bits of the product
1213             uint256 prod1; // Most significant 256 bits of the product
1214             assembly {
1215                 let mm := mulmod(x, y, not(0))
1216                 prod0 := mul(x, y)
1217                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1218             }
1219 
1220             // Handle non-overflow cases, 256 by 256 division.
1221             if (prod1 == 0) {
1222                 return prod0 / denominator;
1223             }
1224 
1225             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1226             require(denominator > prod1);
1227 
1228             ///////////////////////////////////////////////
1229             // 512 by 256 division.
1230             ///////////////////////////////////////////////
1231 
1232             // Make division exact by subtracting the remainder from [prod1 prod0].
1233             uint256 remainder;
1234             assembly {
1235                 // Compute remainder using mulmod.
1236                 remainder := mulmod(x, y, denominator)
1237 
1238                 // Subtract 256 bit number from 512 bit number.
1239                 prod1 := sub(prod1, gt(remainder, prod0))
1240                 prod0 := sub(prod0, remainder)
1241             }
1242 
1243             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1244             // See https://cs.stackexchange.com/q/138556/92363.
1245 
1246             // Does not overflow because the denominator cannot be zero at this stage in the function.
1247             uint256 twos = denominator & (~denominator + 1);
1248             assembly {
1249                 // Divide denominator by twos.
1250                 denominator := div(denominator, twos)
1251 
1252                 // Divide [prod1 prod0] by twos.
1253                 prod0 := div(prod0, twos)
1254 
1255                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1256                 twos := add(div(sub(0, twos), twos), 1)
1257             }
1258 
1259             // Shift in bits from prod1 into prod0.
1260             prod0 |= prod1 * twos;
1261 
1262             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1263             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1264             // four bits. That is, denominator * inv = 1 mod 2^4.
1265             uint256 inverse = (3 * denominator) ^ 2;
1266 
1267             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1268             // in modular arithmetic, doubling the correct bits in each step.
1269             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1270             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1271             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1272             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1273             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1274             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1275 
1276             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1277             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1278             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1279             // is no longer required.
1280             result = prod0 * inverse;
1281             return result;
1282         }
1283     }
1284 
1285     /**
1286      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1287      */
1288     function mulDiv(
1289         uint256 x,
1290         uint256 y,
1291         uint256 denominator,
1292         Rounding rounding
1293     ) internal pure returns (uint256) {
1294         uint256 result = mulDiv(x, y, denominator);
1295         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1296             result += 1;
1297         }
1298         return result;
1299     }
1300 
1301     /**
1302      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1303      *
1304      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1305      */
1306     function sqrt(uint256 a) internal pure returns (uint256) {
1307         if (a == 0) {
1308             return 0;
1309         }
1310 
1311         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1312         //
1313         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1314         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1315         //
1316         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1317         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1318         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1319         //
1320         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1321         uint256 result = 1 << (log2(a) >> 1);
1322 
1323         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1324         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1325         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1326         // into the expected uint128 result.
1327         unchecked {
1328             result = (result + a / result) >> 1;
1329             result = (result + a / result) >> 1;
1330             result = (result + a / result) >> 1;
1331             result = (result + a / result) >> 1;
1332             result = (result + a / result) >> 1;
1333             result = (result + a / result) >> 1;
1334             result = (result + a / result) >> 1;
1335             return min(result, a / result);
1336         }
1337     }
1338 
1339     /**
1340      * @notice Calculates sqrt(a), following the selected rounding direction.
1341      */
1342     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1343         unchecked {
1344             uint256 result = sqrt(a);
1345             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1346         }
1347     }
1348 
1349     /**
1350      * @dev Return the log in base 2, rounded down, of a positive value.
1351      * Returns 0 if given 0.
1352      */
1353     function log2(uint256 value) internal pure returns (uint256) {
1354         uint256 result = 0;
1355         unchecked {
1356             if (value >> 128 > 0) {
1357                 value >>= 128;
1358                 result += 128;
1359             }
1360             if (value >> 64 > 0) {
1361                 value >>= 64;
1362                 result += 64;
1363             }
1364             if (value >> 32 > 0) {
1365                 value >>= 32;
1366                 result += 32;
1367             }
1368             if (value >> 16 > 0) {
1369                 value >>= 16;
1370                 result += 16;
1371             }
1372             if (value >> 8 > 0) {
1373                 value >>= 8;
1374                 result += 8;
1375             }
1376             if (value >> 4 > 0) {
1377                 value >>= 4;
1378                 result += 4;
1379             }
1380             if (value >> 2 > 0) {
1381                 value >>= 2;
1382                 result += 2;
1383             }
1384             if (value >> 1 > 0) {
1385                 result += 1;
1386             }
1387         }
1388         return result;
1389     }
1390 
1391     /**
1392      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1393      * Returns 0 if given 0.
1394      */
1395     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1396         unchecked {
1397             uint256 result = log2(value);
1398             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1399         }
1400     }
1401 
1402     /**
1403      * @dev Return the log in base 10, rounded down, of a positive value.
1404      * Returns 0 if given 0.
1405      */
1406     function log10(uint256 value) internal pure returns (uint256) {
1407         uint256 result = 0;
1408         unchecked {
1409             if (value >= 10**64) {
1410                 value /= 10**64;
1411                 result += 64;
1412             }
1413             if (value >= 10**32) {
1414                 value /= 10**32;
1415                 result += 32;
1416             }
1417             if (value >= 10**16) {
1418                 value /= 10**16;
1419                 result += 16;
1420             }
1421             if (value >= 10**8) {
1422                 value /= 10**8;
1423                 result += 8;
1424             }
1425             if (value >= 10**4) {
1426                 value /= 10**4;
1427                 result += 4;
1428             }
1429             if (value >= 10**2) {
1430                 value /= 10**2;
1431                 result += 2;
1432             }
1433             if (value >= 10**1) {
1434                 result += 1;
1435             }
1436         }
1437         return result;
1438     }
1439 
1440     /**
1441      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1442      * Returns 0 if given 0.
1443      */
1444     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1445         unchecked {
1446             uint256 result = log10(value);
1447             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1448         }
1449     }
1450 
1451     /**
1452      * @dev Return the log in base 256, rounded down, of a positive value.
1453      * Returns 0 if given 0.
1454      *
1455      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1456      */
1457     function log256(uint256 value) internal pure returns (uint256) {
1458         uint256 result = 0;
1459         unchecked {
1460             if (value >> 128 > 0) {
1461                 value >>= 128;
1462                 result += 16;
1463             }
1464             if (value >> 64 > 0) {
1465                 value >>= 64;
1466                 result += 8;
1467             }
1468             if (value >> 32 > 0) {
1469                 value >>= 32;
1470                 result += 4;
1471             }
1472             if (value >> 16 > 0) {
1473                 value >>= 16;
1474                 result += 2;
1475             }
1476             if (value >> 8 > 0) {
1477                 result += 1;
1478             }
1479         }
1480         return result;
1481     }
1482 
1483     /**
1484      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1485      * Returns 0 if given 0.
1486      */
1487     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1488         unchecked {
1489             uint256 result = log256(value);
1490             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1491         }
1492     }
1493 }
1494 
1495 // File: @openzeppelin/contracts/utils/Strings.sol
1496 
1497 
1498 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1499 
1500 pragma solidity ^0.8.0;
1501 
1502 
1503 /**
1504  * @dev String operations.
1505  */
1506 library Strings {
1507     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1508     uint8 private constant _ADDRESS_LENGTH = 20;
1509 
1510     /**
1511      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1512      */
1513     function toString(uint256 value) internal pure returns (string memory) {
1514         unchecked {
1515             uint256 length = Math.log10(value) + 1;
1516             string memory buffer = new string(length);
1517             uint256 ptr;
1518             /// @solidity memory-safe-assembly
1519             assembly {
1520                 ptr := add(buffer, add(32, length))
1521             }
1522             while (true) {
1523                 ptr--;
1524                 /// @solidity memory-safe-assembly
1525                 assembly {
1526                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1527                 }
1528                 value /= 10;
1529                 if (value == 0) break;
1530             }
1531             return buffer;
1532         }
1533     }
1534 
1535     /**
1536      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1537      */
1538     function toHexString(uint256 value) internal pure returns (string memory) {
1539         unchecked {
1540             return toHexString(value, Math.log256(value) + 1);
1541         }
1542     }
1543 
1544     /**
1545      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1546      */
1547     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1548         bytes memory buffer = new bytes(2 * length + 2);
1549         buffer[0] = "0";
1550         buffer[1] = "x";
1551         for (uint256 i = 2 * length + 1; i > 1; --i) {
1552             buffer[i] = _SYMBOLS[value & 0xf];
1553             value >>= 4;
1554         }
1555         require(value == 0, "Strings: hex length insufficient");
1556         return string(buffer);
1557     }
1558 
1559     /**
1560      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1561      */
1562     function toHexString(address addr) internal pure returns (string memory) {
1563         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1564     }
1565 }
1566 
1567 
1568 abstract contract ERC1155Supply is ERC1155 {
1569     mapping(uint256 => uint256) private _totalSupply;
1570 
1571     /**
1572      * @dev Total amount of tokens in with a given id.
1573      */
1574     function totalSupply(uint256 id) public view virtual returns (uint256) {
1575         return _totalSupply[id];
1576     }
1577 
1578     /**
1579      * @dev Indicates whether any token exist with a given id, or not.
1580      */
1581     function exists(uint256 id) public view virtual returns (bool) {
1582         return ERC1155Supply.totalSupply(id) > 0;
1583     }
1584 
1585     /**
1586      * @dev See {ERC1155-_beforeTokenTransfer}.
1587      */
1588     function _beforeTokenTransfer(
1589         address operator,
1590         address from,
1591         address to,
1592         uint256[] memory ids,
1593         uint256[] memory amounts,
1594         bytes memory data
1595     ) internal virtual override {
1596         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1597 
1598         if (from == address(0)) {
1599             for (uint256 i = 0; i < ids.length; ++i) {
1600                 _totalSupply[ids[i]] += amounts[i];
1601             }
1602         }
1603 
1604         if (to == address(0)) {
1605             for (uint256 i = 0; i < ids.length; ++i) {
1606                 uint256 id = ids[i];
1607                 uint256 amount = amounts[i];
1608                 uint256 supply = _totalSupply[id];
1609                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1610                 unchecked {
1611                     _totalSupply[id] = supply - amount;
1612                 }
1613             }
1614         }
1615     }
1616 }
1617 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol
1618 
1619 
1620 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155URIStorage.sol)
1621 
1622 pragma solidity ^0.8.0;
1623 
1624 
1625 
1626 /**
1627  * @dev ERC1155 token with storage based token URI management.
1628  * Inspired by the ERC721URIStorage extension
1629  *
1630  * _Available since v4.6._
1631  */
1632 abstract contract ERC1155URIStorage is ERC1155Supply {
1633     using Strings for uint256;
1634 
1635     // Optional base URI
1636     string private _baseURI = "";
1637 
1638     // Optional mapping for token URIs
1639     mapping(uint256 => string) private _tokenURIs;
1640 
1641     /**
1642      * @dev See {IERC1155MetadataURI-uri}.
1643      *
1644      * This implementation returns the concatenation of the `_baseURI`
1645      * and the token-specific uri if the latter is set
1646      *
1647      * This enables the following behaviors:
1648      *
1649      * - if `_tokenURIs[tokenId]` is set, then the result is the concatenation
1650      *   of `_baseURI` and `_tokenURIs[tokenId]` (keep in mind that `_baseURI`
1651      *   is empty per default);
1652      *
1653      * - if `_tokenURIs[tokenId]` is NOT set then we fallback to `super.uri()`
1654      *   which in most cases will contain `ERC1155._uri`;
1655      *
1656      * - if `_tokenURIs[tokenId]` is NOT set, and if the parents do not have a
1657      *   uri value set, then the result is empty.
1658      */
1659     function uri(uint256 tokenId) public view virtual override returns (string memory) {
1660         string memory tokenURI = _tokenURIs[tokenId];
1661 
1662         // If token URI is set, concatenate base URI and tokenURI (via abi.encodePacked).
1663         return bytes(tokenURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenURI)) : super.uri(tokenId);
1664     }
1665 
1666     /**
1667      * @dev Sets `tokenURI` as the tokenURI of `tokenId`.
1668      */
1669     function _setURI(uint256 tokenId, string memory tokenURI) internal virtual {
1670         _tokenURIs[tokenId] = tokenURI;
1671         emit URI(uri(tokenId), tokenId);
1672     }
1673 
1674     /**
1675      * @dev Sets `baseURI` as the `_baseURI` for all tokens
1676      */
1677     function _setBaseURI(string memory baseURI) internal virtual {
1678         _baseURI = baseURI;
1679     }
1680 }
1681 
1682 // File: kizuna/kizuna.sol
1683 
1684 
1685 pragma solidity ^0.8.9;
1686 
1687 
1688 
1689 
1690 pragma solidity ^0.8.9;
1691 
1692 
1693 
1694 pragma solidity ^0.8.9;
1695 abstract contract Operable is Context {
1696     mapping(address => bool) _operators;
1697     modifier onlyOperator() {
1698         _checkOperatorRole(_msgSender());
1699         _;
1700     }
1701     function isOperator(address _operator) public view returns (bool) {
1702         return _operators[_operator];
1703     }
1704     function _grantOperatorRole(address _candidate) internal {
1705         require(
1706             !_operators[_candidate],
1707             string(
1708                 abi.encodePacked(
1709                     "account ",
1710                     Strings.toHexString(uint160(_msgSender()), 20),
1711                     " is already has an operator role"
1712                 )
1713             )
1714         );
1715         _operators[_candidate] = true;
1716     }
1717     function _revokeOperatorRole(address _candidate) internal {
1718         _checkOperatorRole(_candidate);
1719         delete _operators[_candidate];
1720     }
1721     function _checkOperatorRole(address _operator) internal view {
1722         require(
1723             _operators[_operator],
1724             string(
1725                 abi.encodePacked(
1726                     "account ",
1727                     Strings.toHexString(uint160(_msgSender()), 20),
1728                     " is not an operator"
1729                 )
1730             )
1731         );
1732     }
1733 }
1734 
1735 // File: EXO/NEW/EXO.sol
1736 
1737 pragma solidity >=0.6.0;
1738 
1739 /// @title Base64
1740 /// @author Brecht Devos - <brecht@loopring.org>
1741 /// @notice Provides functions for encoding/decoding base64
1742 library Base64 {
1743     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
1744     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
1745                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
1746                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
1747                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
1748 
1749     function encode(bytes memory data) internal pure returns (string memory) {
1750         if (data.length == 0) return '';
1751 
1752         // load the table into memory
1753         string memory table = TABLE_ENCODE;
1754 
1755         // multiply by 4/3 rounded up
1756         uint256 encodedLen = 4 * ((data.length + 2) / 3);
1757 
1758         // add some extra buffer at the end required for the writing
1759         string memory result = new string(encodedLen + 32);
1760 
1761         assembly {
1762             // set the actual output length
1763             mstore(result, encodedLen)
1764 
1765             // prepare the lookup table
1766             let tablePtr := add(table, 1)
1767 
1768             // input ptr
1769             let dataPtr := data
1770             let endPtr := add(dataPtr, mload(data))
1771 
1772             // result ptr, jump over length
1773             let resultPtr := add(result, 32)
1774 
1775             // run over the input, 3 bytes at a time
1776             for {} lt(dataPtr, endPtr) {}
1777             {
1778                 // read 3 bytes
1779                 dataPtr := add(dataPtr, 3)
1780                 let input := mload(dataPtr)
1781 
1782                 // write 4 characters
1783                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1784                 resultPtr := add(resultPtr, 1)
1785                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1786                 resultPtr := add(resultPtr, 1)
1787                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
1788                 resultPtr := add(resultPtr, 1)
1789                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
1790                 resultPtr := add(resultPtr, 1)
1791             }
1792 
1793             // padding with '='
1794             switch mod(mload(data), 3)
1795             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
1796             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
1797         }
1798 
1799         return result;
1800     }
1801 
1802     function decode(string memory _data) internal pure returns (bytes memory) {
1803         bytes memory data = bytes(_data);
1804 
1805         if (data.length == 0) return new bytes(0);
1806         require(data.length % 4 == 0, "invalid base64 decoder input");
1807 
1808         // load the table into memory
1809         bytes memory table = TABLE_DECODE;
1810 
1811         // every 4 characters represent 3 bytes
1812         uint256 decodedLen = (data.length / 4) * 3;
1813 
1814         // add some extra buffer at the end required for the writing
1815         bytes memory result = new bytes(decodedLen + 32);
1816 
1817         assembly {
1818             // padding with '='
1819             let lastBytes := mload(add(data, mload(data)))
1820             if eq(and(lastBytes, 0xFF), 0x3d) {
1821                 decodedLen := sub(decodedLen, 1)
1822                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
1823                     decodedLen := sub(decodedLen, 1)
1824                 }
1825             }
1826 
1827             // set the actual output length
1828             mstore(result, decodedLen)
1829 
1830             // prepare the lookup table
1831             let tablePtr := add(table, 1)
1832 
1833             // input ptr
1834             let dataPtr := data
1835             let endPtr := add(dataPtr, mload(data))
1836 
1837             // result ptr, jump over length
1838             let resultPtr := add(result, 32)
1839 
1840             // run over the input, 4 characters at a time
1841             for {} lt(dataPtr, endPtr) {}
1842             {
1843                // read 4 characters
1844                dataPtr := add(dataPtr, 4)
1845                let input := mload(dataPtr)
1846 
1847                // write 3 bytes
1848                let output := add(
1849                    add(
1850                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
1851                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
1852                    add(
1853                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
1854                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
1855                     )
1856                 )
1857                 mstore(resultPtr, shl(232, output))
1858                 resultPtr := add(resultPtr, 3)
1859             }
1860         }
1861 
1862         return result;
1863     }
1864 }
1865 
1866 
1867 
1868 
1869 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1870 
1871 pragma solidity ^0.8.0;
1872 
1873 /**
1874  * @dev Contract module that helps prevent reentrant calls to a function.
1875  *
1876  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1877  * available, which can be applied to functions to make sure there are no nested
1878  * (reentrant) calls to them.
1879  *
1880  * Note that because there is a single `nonReentrant` guard, functions marked as
1881  * `nonReentrant` may not call one another. This can be worked around by making
1882  * those functions `private`, and then adding `external` `nonReentrant` entry
1883  * points to them.
1884  *
1885  * TIP: If you would like to learn more about reentrancy and alternative ways
1886  * to protect against it, check out our blog post
1887  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1888  */
1889 abstract contract ReentrancyGuard {
1890     // Booleans are more expensive than uint256 or any type that takes up a full
1891     // word because each write operation emits an extra SLOAD to first read the
1892     // slot's contents, replace the bits taken up by the boolean, and then write
1893     // back. This is the compiler's defense against contract upgrades and
1894     // pointer aliasing, and it cannot be disabled.
1895 
1896     // The values being non-zero value makes deployment a bit more expensive,
1897     // but in exchange the refund on every call to nonReentrant will be lower in
1898     // amount. Since refunds are capped to a percentage of the total
1899     // transaction's gas, it is best to keep them low in cases like this one, to
1900     // increase the likelihood of the full refund coming into effect.
1901     uint256 private constant _NOT_ENTERED = 1;
1902     uint256 private constant _ENTERED = 2;
1903 
1904     uint256 private _status;
1905 
1906     constructor() {
1907         _status = _NOT_ENTERED;
1908     }
1909 
1910     /**
1911      * @dev Prevents a contract from calling itself, directly or indirectly.
1912      * Calling a `nonReentrant` function from another `nonReentrant`
1913      * function is not supported. It is possible to prevent this from happening
1914      * by making the `nonReentrant` function external, and making it call a
1915      * `private` function that does the actual work.
1916      */
1917     modifier nonReentrant() {
1918         _nonReentrantBefore();
1919         _;
1920         _nonReentrantAfter();
1921     }
1922 
1923     function _nonReentrantBefore() private {
1924         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1925         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1926 
1927         // Any calls to nonReentrant after this point will fail
1928         _status = _ENTERED;
1929     }
1930 
1931     function _nonReentrantAfter() private {
1932         // By storing the original value once again, a refund is triggered (see
1933         // https://eips.ethereum.org/EIPS/eip-2200)
1934         _status = _NOT_ENTERED;
1935     }
1936 }
1937 
1938 
1939 
1940 
1941 pragma solidity ^0.8.7;
1942 abstract contract MerkleProof {
1943     mapping(uint256 => bytes32) internal _alMerkleRoot;
1944     uint256 public phaseId;
1945 
1946     function _setAlMerkleRootWithId(uint256 _phaseId,bytes32 merkleRoot_) internal virtual {
1947         _alMerkleRoot[_phaseId] = merkleRoot_;
1948     }
1949 
1950     function _setAlMerkleRoot(bytes32 merkleRoot_) internal virtual {
1951         _alMerkleRoot[phaseId] = merkleRoot_;
1952     }
1953 
1954     function isAllowlisted(address address_,uint256 _phaseId, bytes32[] memory proof_) public view returns (bool) {
1955         bytes32 _leaf = keccak256(abi.encodePacked(address_));
1956         for (uint256 i = 0; i < proof_.length; i++) {
1957             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
1958         }
1959         return _leaf == _alMerkleRoot[_phaseId];
1960     }
1961 
1962 }
1963 
1964 
1965 
1966 pragma solidity ^0.8.13;
1967 
1968 interface IOperatorFilterRegistry {
1969     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1970     function register(address registrant) external;
1971     function registerAndSubscribe(address registrant, address subscription) external;
1972     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1973     function unregister(address addr) external;
1974     function updateOperator(address registrant, address operator, bool filtered) external;
1975     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1976     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1977     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1978     function subscribe(address registrant, address registrantToSubscribe) external;
1979     function unsubscribe(address registrant, bool copyExistingEntries) external;
1980     function subscriptionOf(address addr) external returns (address registrant);
1981     function subscribers(address registrant) external returns (address[] memory);
1982     function subscriberAt(address registrant, uint256 index) external returns (address);
1983     function copyEntriesOf(address registrant, address registrantToCopy) external;
1984     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1985     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1986     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1987     function filteredOperators(address addr) external returns (address[] memory);
1988     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1989     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1990     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1991     function isRegistered(address addr) external returns (bool);
1992     function codeHashOf(address addr) external returns (bytes32);
1993 }
1994 
1995 pragma solidity ^0.8.13;
1996 
1997 
1998 /**
1999  * @title  OperatorFilterer
2000  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2001  *         registrant's entries in the OperatorFilterRegistry.
2002  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2003  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2004  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2005  */
2006 abstract contract OperatorFilterer {
2007     error OperatorNotAllowed(address operator);
2008     bool public operatorFilteringEnabled = true;
2009 
2010     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2011         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
2012 
2013     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2014         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2015         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2016         // order for the modifier to filter addresses.
2017         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2018             if (subscribe) {
2019                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2020             } else {
2021                 if (subscriptionOrRegistrantToCopy != address(0)) {
2022                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2023                 } else {
2024                     OPERATOR_FILTER_REGISTRY.register(address(this));
2025                 }
2026             }
2027         }
2028     }
2029 
2030     modifier onlyAllowedOperator(address from) virtual {
2031         // Check registry code length to facilitate testing in environments without a deployed registry.
2032         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0 && operatorFilteringEnabled) {
2033             // Allow spending tokens from addresses with balance
2034             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2035             // from an EOA.
2036             if (from == msg.sender) {
2037                 _;
2038                 return;
2039             }
2040             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
2041                 revert OperatorNotAllowed(msg.sender);
2042             }
2043         }
2044         _;
2045     }
2046 
2047     modifier onlyAllowedOperatorApproval(address operator) virtual {
2048         // Check registry code length to facilitate testing in environments without a deployed registry.
2049         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0 && operatorFilteringEnabled) {
2050             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2051                 revert OperatorNotAllowed(operator);
2052             }
2053         }
2054         _;
2055     }
2056 }
2057 
2058 
2059 pragma solidity ^0.8.13;
2060 /**
2061  * @title  DefaultOperatorFilterer
2062  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2063  */
2064 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2065     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2066 
2067     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
2068 }
2069 
2070 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
2071 
2072 
2073 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
2074 
2075 pragma solidity ^0.8.0;
2076 
2077 
2078 /**
2079  * @dev Interface for the NFT Royalty Standard.
2080  *
2081  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2082  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2083  *
2084  * _Available since v4.5._
2085  */
2086 interface IERC2981 is IERC165 {
2087     /**
2088      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2089      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2090      */
2091     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2092         external
2093         view
2094         returns (address receiver, uint256 royaltyAmount);
2095 }
2096 
2097 // File: @openzeppelin/contracts/token/common/ERC2981.sol
2098 
2099 
2100 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
2101 
2102 pragma solidity ^0.8.0;
2103 
2104 
2105 
2106 /**
2107  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2108  *
2109  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2110  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2111  *
2112  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2113  * fee is specified in basis points by default.
2114  *
2115  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2116  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2117  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2118  *
2119  * _Available since v4.5._
2120  */
2121 abstract contract ERC2981 is IERC2981, ERC165 {
2122     struct RoyaltyInfo {
2123         address receiver;
2124         uint96 royaltyFraction;
2125     }
2126 
2127     RoyaltyInfo private _defaultRoyaltyInfo;
2128     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2129 
2130     /**
2131      * @dev See {IERC165-supportsInterface}.
2132      */
2133     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2134         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2135     }
2136 
2137     /**
2138      * @inheritdoc IERC2981
2139      */
2140     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
2141         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2142 
2143         if (royalty.receiver == address(0)) {
2144             royalty = _defaultRoyaltyInfo;
2145         }
2146 
2147         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
2148 
2149         return (royalty.receiver, royaltyAmount);
2150     }
2151 
2152     /**
2153      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2154      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2155      * override.
2156      */
2157     function _feeDenominator() internal pure virtual returns (uint96) {
2158         return 10000;
2159     }
2160 
2161     /**
2162      * @dev Sets the royalty information that all ids in this contract will default to.
2163      *
2164      * Requirements:
2165      *
2166      * - `receiver` cannot be the zero address.
2167      * - `feeNumerator` cannot be greater than the fee denominator.
2168      */
2169     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2170         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2171         require(receiver != address(0), "ERC2981: invalid receiver");
2172 
2173         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2174     }
2175 
2176     /**
2177      * @dev Removes default royalty information.
2178      */
2179     function _deleteDefaultRoyalty() internal virtual {
2180         delete _defaultRoyaltyInfo;
2181     }
2182 
2183     /**
2184      * @dev Sets the royalty information for a specific token id, overriding the global default.
2185      *
2186      * Requirements:
2187      *
2188      * - `receiver` cannot be the zero address.
2189      * - `feeNumerator` cannot be greater than the fee denominator.
2190      */
2191     function _setTokenRoyalty(
2192         uint256 tokenId,
2193         address receiver,
2194         uint96 feeNumerator
2195     ) internal virtual {
2196         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2197         require(receiver != address(0), "ERC2981: Invalid parameters");
2198 
2199         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2200     }
2201 
2202     /**
2203      * @dev Resets royalty information for the token id back to the global default.
2204      */
2205     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2206         delete _tokenRoyaltyInfo[tokenId];
2207     }
2208 }
2209 
2210 // File: @openzeppelin/contracts/utils/Context.sol
2211 
2212 
2213 
2214 contract KIZUNA is ERC1155URIStorage, Ownable, Operable,ReentrancyGuard, DefaultOperatorFilterer,ERC2981,MerkleProof {
2215     using Strings for string;
2216 
2217     string public name = 'KIZUNA by STARTJPN';
2218     string public symbol = 'KIZUNA';
2219     mapping(address => bool) bondedAddress;
2220     bool unlock = true;
2221     uint256 public nowPhaseAl;
2222     uint256 public alMintPrice = 0.0 ether;
2223     uint256 public mintable;
2224     mapping(uint256 => uint256) public maxMintsPerAL;
2225     uint256 public maxMintsPerALOT = 1;
2226     bool public isAlSaleEnabled;
2227     mapping(uint256 => mapping(address => uint256)) internal _alMinted;
2228     address public deployer;
2229 
2230     constructor(
2231     address _royaltyReceiver,
2232     uint96 _royaltyFraction
2233     ) ERC1155('') {
2234         deployer = msg.sender;
2235         _grantOperatorRole(msg.sender);
2236         _grantOperatorRole(_royaltyReceiver);
2237         _setDefaultRoyalty(_royaltyReceiver,_royaltyFraction);
2238         _setBaseURI('https://startdata.io/kizuna/');
2239         initializeSBT(0, 'index.json');
2240         maxMintsPerAL[0] = 1;
2241     }
2242 
2243 
2244   //set Default Royalty._feeNumerator 500 = 5% Royalty
2245   function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external virtual onlyOperator {
2246       _setDefaultRoyalty(_receiver, _feeNumerator);
2247   }
2248   //for ERC2981
2249   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC2981) returns (bool) {
2250     return super.supportsInterface(interfaceId);
2251   }
2252   //for ERC2981 Opensea
2253   function contractURI() external view virtual returns (string memory) {
2254         return _formatContractURI();
2255   }
2256   //make contractURI
2257   function _formatContractURI() internal view returns (string memory) {
2258     (address receiver, uint256 royaltyFraction) = royaltyInfo(0,_feeDenominator());//tokenid=0
2259     return string(
2260       abi.encodePacked(
2261         "data:application/json;base64,",
2262         Base64.encode(
2263           bytes(
2264             abi.encodePacked(
2265                 '{"seller_fee_basis_points":', Strings.toString(royaltyFraction),
2266                 ', "fee_recipient":"', Strings.toHexString(uint256(uint160(receiver)), 20), '"}'
2267             )
2268           )
2269         )
2270       )
2271     );
2272   }
2273 
2274     //OPENSEA.OPERATORFilterer.START
2275     /**
2276      * @notice Set the state of the OpenSea operator filter
2277      * @param value Flag indicating if the operator filter should be applied to transfers and approvals
2278      */
2279     function setOperatorFilteringEnabled(bool value) external onlyOperator {
2280         operatorFilteringEnabled = value;
2281     }
2282 
2283     /**
2284      * @dev See {IERC1155-setApprovalForAll}.
2285      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2286      */
2287     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2288         super.setApprovalForAll(operator, approved);
2289         _setApprovalForAll(_msgSender(), operator, approved);
2290     }
2291 
2292     /**
2293      * @dev See {IERC1155-safeTransferFrom}.
2294      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2295      */
2296     function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount, bytes memory data)
2297         public
2298         override
2299         onlyAllowedOperator(from)
2300     {
2301         super.safeTransferFrom(from, to, tokenId, amount, data);
2302     }
2303 
2304     /**
2305      * @dev See {IERC1155-safeBatchTransferFrom}.
2306      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2307      */
2308     function safeBatchTransferFrom(
2309         address from,
2310         address to,
2311         uint256[] memory ids,
2312         uint256[] memory amounts,
2313         bytes memory data
2314     ) public virtual override onlyAllowedOperator(from) {
2315         super.safeBatchTransferFrom(from, to, ids, amounts, data);
2316     }
2317 
2318 
2319     //OPENSEA.OPERATORFilterer.END
2320 
2321 
2322     function locked(address to) external view returns (bool) {
2323         return bondedAddress[to];
2324     }
2325 
2326     function bound(address to, bool flag) public onlyOperator {
2327         bondedAddress[to] = flag;
2328     }
2329 
2330     function setBaseURI(string memory uri_) external onlyOperator {
2331         _setBaseURI(uri_);
2332     }
2333 
2334     function setTokenURI(uint256 tokenId, string memory _tokenURI)
2335         external
2336         onlyOperator
2337     {
2338         _setURI(tokenId, _tokenURI);
2339     }
2340 
2341     function initializeSBT(uint256 tokenId, string memory _tokenURI)
2342         public
2343         onlyOperator
2344     {
2345         require(bytes(uri(tokenId)).length == 0, 'SBT already exists');
2346         _mint(msg.sender, tokenId, 1, '');
2347         _setURI(tokenId, _tokenURI);
2348     }
2349 
2350     //AL mint.
2351   function allowlistMint(uint256 _amount,uint256 id, bytes32[] memory proof_) external payable virtual nonReentrant {
2352     require(bytes(uri(id)).length != 0, 'Not initialized');
2353     require(isAlSaleEnabled, "allowlistMint is Paused");
2354     require(isAllowlisted(msg.sender,phaseId, proof_), "You are not whitelisted!");
2355     require(maxMintsPerALOT >= _amount, "allowlistMint: Over max mints per one time");
2356     require(maxMintsPerAL[phaseId] >= _amount, "allowlistMint: Over max mints per wallet");
2357     require(maxMintsPerAL[phaseId] >= _alMinted[nowPhaseAl][msg.sender] + _amount, "You have no whitelistMint left");
2358     require(msg.value == alMintPrice * _amount, "ETH value is not correct");
2359     require((_amount + totalSupply(id)) <= (mintable) || mintable == 0, "No more NFTs");
2360     _alMinted[nowPhaseAl][msg.sender] += _amount;
2361     _mint(msg.sender, id, _amount, '');
2362   }
2363   function setMintable(uint256 _mintable) external virtual onlyOperator {
2364     mintable = _mintable;
2365   }
2366 
2367   function alMinted(address _address) external view virtual returns (uint256){
2368     return _alMinted[nowPhaseAl][_address];
2369   }
2370   function alIdMinted(uint256 _nowPhaseAl,address _address) external view virtual returns (uint256){
2371     return _alMinted[_nowPhaseAl][_address];
2372   }
2373 
2374     // GET phaseId.
2375   function getPhaseId() external view virtual returns (uint256){
2376     return phaseId;
2377   }
2378     // SET phaseId.
2379   function setPhaseId(uint256 _phaseId) external virtual onlyOperator {
2380     phaseId = _phaseId;
2381   }
2382     // SET phaseId.
2383   function setPhaseIdWithReset(uint256 _phaseId) external virtual onlyOperator {
2384     phaseId = _phaseId;
2385     nowPhaseAl += 1;
2386   }
2387 
2388   function setNowPhaseAl(uint256 _nowPhaseAl) external virtual onlyOperator {
2389     nowPhaseAl = _nowPhaseAl;
2390   }
2391 
2392   function setMaxMintsPerALOT(uint256 _maxMintsPerALOT) external virtual onlyOperator {
2393     maxMintsPerALOT = _maxMintsPerALOT;
2394   }
2395   function setMaxMintsPerAL(uint256 _maxMintsPerAL,uint256 _id) external virtual onlyOperator {
2396     maxMintsPerAL[_id] = _maxMintsPerAL;
2397   }
2398   function setMerkleRootAlWithId(uint256 _phaseId,bytes32 merkleRoot_) external virtual onlyOperator {
2399     _setAlMerkleRootWithId(_phaseId,merkleRoot_);
2400   }
2401 
2402   //AL.SaleEnable
2403   function setAllowlistSaleEnable(bool bool_) external virtual onlyOperator {
2404     isAlSaleEnabled = bool_;
2405   }
2406   //AL.SaleEnable
2407   function setUnlock(bool bool_) external virtual onlyOperator {
2408     unlock = bool_;
2409   }
2410 
2411     function mint(
2412         address to,
2413         uint256 id,
2414         uint256 amount
2415     ) public onlyOperator {
2416         require(bytes(uri(id)).length != 0, 'Not initialized');
2417         _mint(to, id, amount, '');
2418     }
2419 
2420     function batchMintTo(
2421         address[] memory list,
2422         uint256 id,
2423         uint256[] memory amount
2424     ) public onlyOperator {
2425         for (uint256 i = 0; i < list.length; i++) {
2426             _mint(list[i], id, amount[i], '');
2427         }
2428     }
2429 
2430     function burnAdmin(
2431         address to,
2432         uint256 id,
2433         uint256 amount
2434     ) public onlyOperator {
2435         _burn(to, id, amount);
2436     }
2437 
2438     function _beforeTokenTransfer(
2439         address operator,
2440         address from,
2441         address to,
2442         uint256[] memory ids,
2443         uint256[] memory amounts,
2444         bytes memory data
2445     ) internal virtual override {
2446         require(
2447             operator == owner() || bondedAddress[operator] == true || unlock == true || from == address(0),
2448             'Send NFT not allowed'
2449         );
2450         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
2451     }
2452     /**
2453         @dev Operable.Role.ADD
2454      */
2455     function grantOperatorRole(address _candidate) external onlyOwner {
2456         _grantOperatorRole(_candidate);
2457     }
2458     /**
2459         @dev Operable.Role.REMOVE
2460      */
2461     function revokeOperatorRole(address _candidate) external onlyOwner {
2462         _revokeOperatorRole(_candidate);
2463     }
2464 }