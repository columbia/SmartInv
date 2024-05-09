1 // File: @openzeppelin/contracts@4.6.0/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts@4.6.0/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _transferOwnership(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _transferOwnership(newOwner);
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Internal function without access restriction.
164      */
165     function _transferOwnership(address newOwner) internal virtual {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 // File: @openzeppelin/contracts@4.6.0/utils/Address.sol
173 
174 
175 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
176 
177 pragma solidity ^0.8.1;
178 
179 /**
180  * @dev Collection of functions related to the address type
181  */
182 library Address {
183     /**
184      * @dev Returns true if `account` is a contract.
185      *
186      * [IMPORTANT]
187      * ====
188      * It is unsafe to assume that an address for which this function returns
189      * false is an externally-owned account (EOA) and not a contract.
190      *
191      * Among others, `isContract` will return false for the following
192      * types of addresses:
193      *
194      *  - an externally-owned account
195      *  - a contract in construction
196      *  - an address where a contract will be created
197      *  - an address where a contract lived, but was destroyed
198      * ====
199      *
200      * [IMPORTANT]
201      * ====
202      * You shouldn't rely on `isContract` to protect against flash loan attacks!
203      *
204      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
205      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
206      * constructor.
207      * ====
208      */
209     function isContract(address account) internal view returns (bool) {
210         // This method relies on extcodesize/address.code.length, which returns 0
211         // for contracts in construction, since the code is only stored at the end
212         // of the constructor execution.
213 
214         return account.code.length > 0;
215     }
216 
217     /**
218      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
219      * `recipient`, forwarding all available gas and reverting on errors.
220      *
221      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
222      * of certain opcodes, possibly making contracts go over the 2300 gas limit
223      * imposed by `transfer`, making them unable to receive funds via
224      * `transfer`. {sendValue} removes this limitation.
225      *
226      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
227      *
228      * IMPORTANT: because control is transferred to `recipient`, care must be
229      * taken to not create reentrancy vulnerabilities. Consider using
230      * {ReentrancyGuard} or the
231      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
232      */
233     function sendValue(address payable recipient, uint256 amount) internal {
234         require(address(this).balance >= amount, "Address: insufficient balance");
235 
236         (bool success, ) = recipient.call{value: amount}("");
237         require(success, "Address: unable to send value, recipient may have reverted");
238     }
239 
240     /**
241      * @dev Performs a Solidity function call using a low level `call`. A
242      * plain `call` is an unsafe replacement for a function call: use this
243      * function instead.
244      *
245      * If `target` reverts with a revert reason, it is bubbled up by this
246      * function (like regular Solidity function calls).
247      *
248      * Returns the raw returned data. To convert to the expected return value,
249      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
250      *
251      * Requirements:
252      *
253      * - `target` must be a contract.
254      * - calling `target` with `data` must not revert.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionCall(target, data, "Address: low-level call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
264      * `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         return functionCallWithValue(target, data, 0, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but also transferring `value` wei to `target`.
279      *
280      * Requirements:
281      *
282      * - the calling contract must have an ETH balance of at least `value`.
283      * - the called Solidity function must be `payable`.
284      *
285      * _Available since v3.1._
286      */
287     function functionCallWithValue(
288         address target,
289         bytes memory data,
290         uint256 value
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
297      * with `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(address(this).balance >= value, "Address: insufficient balance for call");
308         require(isContract(target), "Address: call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.call{value: value}(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
321         return functionStaticCall(target, data, "Address: low-level static call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal view returns (bytes memory) {
335         require(isContract(target), "Address: static call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.staticcall(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a delegate call.
344      *
345      * _Available since v3.4._
346      */
347     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(isContract(target), "Address: delegate call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.delegatecall(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
370      * revert reason using the provided one.
371      *
372      * _Available since v4.3._
373      */
374     function verifyCallResult(
375         bool success,
376         bytes memory returndata,
377         string memory errorMessage
378     ) internal pure returns (bytes memory) {
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 // File: @openzeppelin/contracts@4.6.0/utils/introspection/IERC165.sol
398 
399 
400 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @dev Interface of the ERC165 standard, as defined in the
406  * https://eips.ethereum.org/EIPS/eip-165[EIP].
407  *
408  * Implementers can declare support of contract interfaces, which can then be
409  * queried by others ({ERC165Checker}).
410  *
411  * For an implementation, see {ERC165}.
412  */
413 interface IERC165 {
414     /**
415      * @dev Returns true if this contract implements the interface defined by
416      * `interfaceId`. See the corresponding
417      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
418      * to learn more about how these ids are created.
419      *
420      * This function call must use less than 30 000 gas.
421      */
422     function supportsInterface(bytes4 interfaceId) external view returns (bool);
423 }
424 
425 // File: @openzeppelin/contracts@4.6.0/utils/introspection/ERC165.sol
426 
427 
428 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 
433 /**
434  * @dev Implementation of the {IERC165} interface.
435  *
436  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
437  * for the additional interface id that will be supported. For example:
438  *
439  * ```solidity
440  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
441  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
442  * }
443  * ```
444  *
445  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
446  */
447 abstract contract ERC165 is IERC165 {
448     /**
449      * @dev See {IERC165-supportsInterface}.
450      */
451     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
452         return interfaceId == type(IERC165).interfaceId;
453     }
454 }
455 
456 // File: @openzeppelin/contracts@4.6.0/token/ERC1155/IERC1155Receiver.sol
457 
458 
459 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @dev _Available since v3.1._
466  */
467 interface IERC1155Receiver is IERC165 {
468     /**
469      * @dev Handles the receipt of a single ERC1155 token type. This function is
470      * called at the end of a `safeTransferFrom` after the balance has been updated.
471      *
472      * NOTE: To accept the transfer, this must return
473      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
474      * (i.e. 0xf23a6e61, or its own function selector).
475      *
476      * @param operator The address which initiated the transfer (i.e. msg.sender)
477      * @param from The address which previously owned the token
478      * @param id The ID of the token being transferred
479      * @param value The amount of tokens being transferred
480      * @param data Additional data with no specified format
481      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
482      */
483     function onERC1155Received(
484         address operator,
485         address from,
486         uint256 id,
487         uint256 value,
488         bytes calldata data
489     ) external returns (bytes4);
490 
491     /**
492      * @dev Handles the receipt of a multiple ERC1155 token types. This function
493      * is called at the end of a `safeBatchTransferFrom` after the balances have
494      * been updated.
495      *
496      * NOTE: To accept the transfer(s), this must return
497      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
498      * (i.e. 0xbc197c81, or its own function selector).
499      *
500      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
501      * @param from The address which previously owned the token
502      * @param ids An array containing ids of each token being transferred (order and length must match values array)
503      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
504      * @param data Additional data with no specified format
505      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
506      */
507     function onERC1155BatchReceived(
508         address operator,
509         address from,
510         uint256[] calldata ids,
511         uint256[] calldata values,
512         bytes calldata data
513     ) external returns (bytes4);
514 }
515 
516 // File: @openzeppelin/contracts@4.6.0/token/ERC1155/IERC1155.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @dev Required interface of an ERC1155 compliant contract, as defined in the
526  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
527  *
528  * _Available since v3.1._
529  */
530 interface IERC1155 is IERC165 {
531     /**
532      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
533      */
534     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
535 
536     /**
537      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
538      * transfers.
539      */
540     event TransferBatch(
541         address indexed operator,
542         address indexed from,
543         address indexed to,
544         uint256[] ids,
545         uint256[] values
546     );
547 
548     /**
549      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
550      * `approved`.
551      */
552     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
553 
554     /**
555      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
556      *
557      * If an {URI} event was emitted for `id`, the standard
558      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
559      * returned by {IERC1155MetadataURI-uri}.
560      */
561     event URI(string value, uint256 indexed id);
562 
563     /**
564      * @dev Returns the amount of tokens of token type `id` owned by `account`.
565      *
566      * Requirements:
567      *
568      * - `account` cannot be the zero address.
569      */
570     function balanceOf(address account, uint256 id) external view returns (uint256);
571 
572     /**
573      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
574      *
575      * Requirements:
576      *
577      * - `accounts` and `ids` must have the same length.
578      */
579     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
580         external
581         view
582         returns (uint256[] memory);
583 
584     /**
585      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
586      *
587      * Emits an {ApprovalForAll} event.
588      *
589      * Requirements:
590      *
591      * - `operator` cannot be the caller.
592      */
593     function setApprovalForAll(address operator, bool approved) external;
594 
595     /**
596      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
597      *
598      * See {setApprovalForAll}.
599      */
600     function isApprovedForAll(address account, address operator) external view returns (bool);
601 
602     /**
603      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
604      *
605      * Emits a {TransferSingle} event.
606      *
607      * Requirements:
608      *
609      * - `to` cannot be the zero address.
610      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
611      * - `from` must have a balance of tokens of type `id` of at least `amount`.
612      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
613      * acceptance magic value.
614      */
615     function safeTransferFrom(
616         address from,
617         address to,
618         uint256 id,
619         uint256 amount,
620         bytes calldata data
621     ) external;
622 
623     /**
624      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
625      *
626      * Emits a {TransferBatch} event.
627      *
628      * Requirements:
629      *
630      * - `ids` and `amounts` must have the same length.
631      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
632      * acceptance magic value.
633      */
634     function safeBatchTransferFrom(
635         address from,
636         address to,
637         uint256[] calldata ids,
638         uint256[] calldata amounts,
639         bytes calldata data
640     ) external;
641 }
642 
643 // File: @openzeppelin/contracts@4.6.0/token/ERC1155/extensions/IERC1155MetadataURI.sol
644 
645 
646 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 
651 /**
652  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
653  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
654  *
655  * _Available since v3.1._
656  */
657 interface IERC1155MetadataURI is IERC1155 {
658     /**
659      * @dev Returns the URI for token type `id`.
660      *
661      * If the `\{id\}` substring is present in the URI, it must be replaced by
662      * clients with the actual token type ID.
663      */
664     function uri(uint256 id) external view returns (string memory);
665 }
666 
667 // File: @openzeppelin/contracts@4.6.0/token/ERC1155/ERC1155.sol
668 
669 
670 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 
675 
676 
677 
678 
679 
680 /**
681  * @dev Implementation of the basic standard multi-token.
682  * See https://eips.ethereum.org/EIPS/eip-1155
683  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
684  *
685  * _Available since v3.1._
686  */
687 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
688     using Address for address;
689 
690     // Mapping from token ID to account balances
691     mapping(uint256 => mapping(address => uint256)) private _balances;
692 
693     // Mapping from account to operator approvals
694     mapping(address => mapping(address => bool)) private _operatorApprovals;
695 
696     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
697     string private _uri;
698 
699     /**
700      * @dev See {_setURI}.
701      */
702     constructor(string memory uri_) {
703         _setURI(uri_);
704     }
705 
706     /**
707      * @dev See {IERC165-supportsInterface}.
708      */
709     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
710         return
711             interfaceId == type(IERC1155).interfaceId ||
712             interfaceId == type(IERC1155MetadataURI).interfaceId ||
713             super.supportsInterface(interfaceId);
714     }
715 
716     /**
717      * @dev See {IERC1155MetadataURI-uri}.
718      *
719      * This implementation returns the same URI for *all* token types. It relies
720      * on the token type ID substitution mechanism
721      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
722      *
723      * Clients calling this function must replace the `\{id\}` substring with the
724      * actual token type ID.
725      */
726     function uri(uint256) public view virtual override returns (string memory) {
727         return _uri;
728     }
729 
730     /**
731      * @dev See {IERC1155-balanceOf}.
732      *
733      * Requirements:
734      *
735      * - `account` cannot be the zero address.
736      */
737     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
738         require(account != address(0), "ERC1155: balance query for the zero address");
739         return _balances[id][account];
740     }
741 
742     /**
743      * @dev See {IERC1155-balanceOfBatch}.
744      *
745      * Requirements:
746      *
747      * - `accounts` and `ids` must have the same length.
748      */
749     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
750         public
751         view
752         virtual
753         override
754         returns (uint256[] memory)
755     {
756         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
757 
758         uint256[] memory batchBalances = new uint256[](accounts.length);
759 
760         for (uint256 i = 0; i < accounts.length; ++i) {
761             batchBalances[i] = balanceOf(accounts[i], ids[i]);
762         }
763 
764         return batchBalances;
765     }
766 
767     /**
768      * @dev See {IERC1155-setApprovalForAll}.
769      */
770     function setApprovalForAll(address operator, bool approved) public virtual override {
771         _setApprovalForAll(_msgSender(), operator, approved);
772     }
773 
774     /**
775      * @dev See {IERC1155-isApprovedForAll}.
776      */
777     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
778         return _operatorApprovals[account][operator];
779     }
780 
781     /**
782      * @dev See {IERC1155-safeTransferFrom}.
783      */
784     function safeTransferFrom(
785         address from,
786         address to,
787         uint256 id,
788         uint256 amount,
789         bytes memory data
790     ) public virtual override {
791         require(
792             from == _msgSender() || isApprovedForAll(from, _msgSender()),
793             "ERC1155: caller is not owner nor approved"
794         );
795         _safeTransferFrom(from, to, id, amount, data);
796     }
797 
798     /**
799      * @dev See {IERC1155-safeBatchTransferFrom}.
800      */
801     function safeBatchTransferFrom(
802         address from,
803         address to,
804         uint256[] memory ids,
805         uint256[] memory amounts,
806         bytes memory data
807     ) public virtual override {
808         require(
809             from == _msgSender() || isApprovedForAll(from, _msgSender()),
810             "ERC1155: transfer caller is not owner nor approved"
811         );
812         _safeBatchTransferFrom(from, to, ids, amounts, data);
813     }
814 
815     /**
816      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
817      *
818      * Emits a {TransferSingle} event.
819      *
820      * Requirements:
821      *
822      * - `to` cannot be the zero address.
823      * - `from` must have a balance of tokens of type `id` of at least `amount`.
824      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
825      * acceptance magic value.
826      */
827     function _safeTransferFrom(
828         address from,
829         address to,
830         uint256 id,
831         uint256 amount,
832         bytes memory data
833     ) internal virtual {
834         require(to != address(0), "ERC1155: transfer to the zero address");
835 
836         address operator = _msgSender();
837         uint256[] memory ids = _asSingletonArray(id);
838         uint256[] memory amounts = _asSingletonArray(amount);
839 
840         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
841 
842         uint256 fromBalance = _balances[id][from];
843         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
844         unchecked {
845             _balances[id][from] = fromBalance - amount;
846         }
847         _balances[id][to] += amount;
848 
849         emit TransferSingle(operator, from, to, id, amount);
850 
851         _afterTokenTransfer(operator, from, to, ids, amounts, data);
852 
853         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
854     }
855 
856     /**
857      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
858      *
859      * Emits a {TransferBatch} event.
860      *
861      * Requirements:
862      *
863      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
864      * acceptance magic value.
865      */
866     function _safeBatchTransferFrom(
867         address from,
868         address to,
869         uint256[] memory ids,
870         uint256[] memory amounts,
871         bytes memory data
872     ) internal virtual {
873         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
874         require(to != address(0), "ERC1155: transfer to the zero address");
875 
876         address operator = _msgSender();
877 
878         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
879 
880         for (uint256 i = 0; i < ids.length; ++i) {
881             uint256 id = ids[i];
882             uint256 amount = amounts[i];
883 
884             uint256 fromBalance = _balances[id][from];
885             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
886             unchecked {
887                 _balances[id][from] = fromBalance - amount;
888             }
889             _balances[id][to] += amount;
890         }
891 
892         emit TransferBatch(operator, from, to, ids, amounts);
893 
894         _afterTokenTransfer(operator, from, to, ids, amounts, data);
895 
896         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
897     }
898 
899     /**
900      * @dev Sets a new URI for all token types, by relying on the token type ID
901      * substitution mechanism
902      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
903      *
904      * By this mechanism, any occurrence of the `\{id\}` substring in either the
905      * URI or any of the amounts in the JSON file at said URI will be replaced by
906      * clients with the token type ID.
907      *
908      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
909      * interpreted by clients as
910      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
911      * for token type ID 0x4cce0.
912      *
913      * See {uri}.
914      *
915      * Because these URIs cannot be meaningfully represented by the {URI} event,
916      * this function emits no events.
917      */
918     function _setURI(string memory newuri) internal virtual {
919         _uri = newuri;
920     }
921 
922     /**
923      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
924      *
925      * Emits a {TransferSingle} event.
926      *
927      * Requirements:
928      *
929      * - `to` cannot be the zero address.
930      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
931      * acceptance magic value.
932      */
933     function _mint(
934         address to,
935         uint256 id,
936         uint256 amount,
937         bytes memory data
938     ) internal virtual {
939         require(to != address(0), "ERC1155: mint to the zero address");
940 
941         address operator = _msgSender();
942         uint256[] memory ids = _asSingletonArray(id);
943         uint256[] memory amounts = _asSingletonArray(amount);
944 
945         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
946 
947         _balances[id][to] += amount;
948         emit TransferSingle(operator, address(0), to, id, amount);
949 
950         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
951 
952         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
953     }
954 
955     /**
956      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
957      *
958      * Requirements:
959      *
960      * - `ids` and `amounts` must have the same length.
961      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
962      * acceptance magic value.
963      */
964     function _mintBatch(
965         address to,
966         uint256[] memory ids,
967         uint256[] memory amounts,
968         bytes memory data
969     ) internal virtual {
970         require(to != address(0), "ERC1155: mint to the zero address");
971         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
972 
973         address operator = _msgSender();
974 
975         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
976 
977         for (uint256 i = 0; i < ids.length; i++) {
978             _balances[ids[i]][to] += amounts[i];
979         }
980 
981         emit TransferBatch(operator, address(0), to, ids, amounts);
982 
983         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
984 
985         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
986     }
987 
988     /**
989      * @dev Destroys `amount` tokens of token type `id` from `from`
990      *
991      * Requirements:
992      *
993      * - `from` cannot be the zero address.
994      * - `from` must have at least `amount` tokens of token type `id`.
995      */
996     function _burn(
997         address from,
998         uint256 id,
999         uint256 amount
1000     ) internal virtual {
1001         require(from != address(0), "ERC1155: burn from the zero address");
1002 
1003         address operator = _msgSender();
1004         uint256[] memory ids = _asSingletonArray(id);
1005         uint256[] memory amounts = _asSingletonArray(amount);
1006 
1007         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1008 
1009         uint256 fromBalance = _balances[id][from];
1010         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1011         unchecked {
1012             _balances[id][from] = fromBalance - amount;
1013         }
1014 
1015         emit TransferSingle(operator, from, address(0), id, amount);
1016 
1017         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1018     }
1019 
1020     /**
1021      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1022      *
1023      * Requirements:
1024      *
1025      * - `ids` and `amounts` must have the same length.
1026      */
1027     function _burnBatch(
1028         address from,
1029         uint256[] memory ids,
1030         uint256[] memory amounts
1031     ) internal virtual {
1032         require(from != address(0), "ERC1155: burn from the zero address");
1033         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1034 
1035         address operator = _msgSender();
1036 
1037         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1038 
1039         for (uint256 i = 0; i < ids.length; i++) {
1040             uint256 id = ids[i];
1041             uint256 amount = amounts[i];
1042 
1043             uint256 fromBalance = _balances[id][from];
1044             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1045             unchecked {
1046                 _balances[id][from] = fromBalance - amount;
1047             }
1048         }
1049 
1050         emit TransferBatch(operator, from, address(0), ids, amounts);
1051 
1052         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1053     }
1054 
1055     /**
1056      * @dev Approve `operator` to operate on all of `owner` tokens
1057      *
1058      * Emits a {ApprovalForAll} event.
1059      */
1060     function _setApprovalForAll(
1061         address owner,
1062         address operator,
1063         bool approved
1064     ) internal virtual {
1065         require(owner != operator, "ERC1155: setting approval status for self");
1066         _operatorApprovals[owner][operator] = approved;
1067         emit ApprovalForAll(owner, operator, approved);
1068     }
1069 
1070     /**
1071      * @dev Hook that is called before any token transfer. This includes minting
1072      * and burning, as well as batched variants.
1073      *
1074      * The same hook is called on both single and batched variants. For single
1075      * transfers, the length of the `id` and `amount` arrays will be 1.
1076      *
1077      * Calling conditions (for each `id` and `amount` pair):
1078      *
1079      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1080      * of token type `id` will be  transferred to `to`.
1081      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1082      * for `to`.
1083      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1084      * will be burned.
1085      * - `from` and `to` are never both zero.
1086      * - `ids` and `amounts` have the same, non-zero length.
1087      *
1088      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1089      */
1090     function _beforeTokenTransfer(
1091         address operator,
1092         address from,
1093         address to,
1094         uint256[] memory ids,
1095         uint256[] memory amounts,
1096         bytes memory data
1097     ) internal virtual {}
1098 
1099     /**
1100      * @dev Hook that is called after any token transfer. This includes minting
1101      * and burning, as well as batched variants.
1102      *
1103      * The same hook is called on both single and batched variants. For single
1104      * transfers, the length of the `id` and `amount` arrays will be 1.
1105      *
1106      * Calling conditions (for each `id` and `amount` pair):
1107      *
1108      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1109      * of token type `id` will be  transferred to `to`.
1110      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1111      * for `to`.
1112      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1113      * will be burned.
1114      * - `from` and `to` are never both zero.
1115      * - `ids` and `amounts` have the same, non-zero length.
1116      *
1117      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1118      */
1119     function _afterTokenTransfer(
1120         address operator,
1121         address from,
1122         address to,
1123         uint256[] memory ids,
1124         uint256[] memory amounts,
1125         bytes memory data
1126     ) internal virtual {}
1127 
1128     function _doSafeTransferAcceptanceCheck(
1129         address operator,
1130         address from,
1131         address to,
1132         uint256 id,
1133         uint256 amount,
1134         bytes memory data
1135     ) private {
1136         if (to.isContract()) {
1137             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1138                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1139                     revert("ERC1155: ERC1155Receiver rejected tokens");
1140                 }
1141             } catch Error(string memory reason) {
1142                 revert(reason);
1143             } catch {
1144                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1145             }
1146         }
1147     }
1148 
1149     function _doSafeBatchTransferAcceptanceCheck(
1150         address operator,
1151         address from,
1152         address to,
1153         uint256[] memory ids,
1154         uint256[] memory amounts,
1155         bytes memory data
1156     ) private {
1157         if (to.isContract()) {
1158             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1159                 bytes4 response
1160             ) {
1161                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1162                     revert("ERC1155: ERC1155Receiver rejected tokens");
1163                 }
1164             } catch Error(string memory reason) {
1165                 revert(reason);
1166             } catch {
1167                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1168             }
1169         }
1170     }
1171 
1172     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1173         uint256[] memory array = new uint256[](1);
1174         array[0] = element;
1175 
1176         return array;
1177     }
1178 }
1179 
1180 // File: Poop.sol
1181 
1182 
1183 pragma solidity ^0.8.7;
1184 
1185 
1186 
1187 
1188 contract Poop is ERC1155, Ownable, ReentrancyGuard {
1189     constructor() ERC1155("") {}
1190 
1191     uint256 public mintPrice = 0.004 ether;
1192     uint256 public freeMintSupply = 1666;
1193     uint256 public maxSupply = 6666;
1194     uint256 public maxAmountPerTx = 5;
1195 
1196     uint256 private _totalSupply = 0;
1197 
1198     bool public paused = true;
1199 
1200     function setURI(string memory newuri) external onlyOwner {
1201         _setURI(newuri);
1202     }
1203 
1204     function setPrice(uint256 _price) external onlyOwner {
1205         mintPrice = _price;
1206     }
1207 
1208     function setMaxAmountPerTx(uint256 _amount) external onlyOwner {
1209         maxAmountPerTx = _amount;
1210     }
1211 
1212     function setFreeMintSupply(uint256 _supply) external onlyOwner {
1213         freeMintSupply = _supply;
1214     }
1215 
1216     function togglePause() external onlyOwner {
1217         paused = !paused;
1218     }
1219 
1220     function mint(address account, uint256 amount)
1221         external
1222         payable
1223         nonReentrant
1224     {
1225         require( tx.origin == msg.sender, "No bots!");
1226         require( _totalSupply + amount <= maxSupply, "Exceeds max supply!" );
1227         require( amount <= maxAmountPerTx, "Exceeds max amount per tx!" );
1228         require( !paused, "Sale is not live!" );
1229         require( ( _totalSupply < freeMintSupply ) || ( msg.value >= mintPrice * amount ), "Insufficient funds!" );
1230 
1231         _mint(account, 1, amount, "0");
1232         _totalSupply += amount;
1233     }
1234 
1235     function claim(address account, uint256 amount)
1236         external
1237         onlyOwner
1238     {
1239         _mint(account, 1, amount, "0");
1240         _totalSupply += amount;
1241     }
1242 
1243     function totalSupply(uint256 id) public view virtual returns (uint256) {
1244         return _totalSupply;
1245     }
1246 
1247     function withdrawAll() external onlyOwner {
1248         require(payable(msg.sender).send(address(this).balance));
1249     }
1250 
1251 }