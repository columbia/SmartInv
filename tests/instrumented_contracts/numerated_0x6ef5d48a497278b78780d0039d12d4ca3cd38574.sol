1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
5 //SPDX-License-Identifier
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
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/access/Ownable.sol
101 
102 
103 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 abstract contract Ownable is Context {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     /**
126      * @dev Initializes the contract setting the deployer as the initial owner.
127      */
128     constructor() {
129         _transferOwnership(_msgSender());
130     }
131 
132     /**
133      * @dev Throws if called by any account other than the owner.
134      */
135     modifier onlyOwner() {
136         _checkOwner();
137         _;
138     }
139 
140     /**
141      * @dev Returns the address of the current owner.
142      */
143     function owner() public view virtual returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if the sender is not the owner.
149      */
150     function _checkOwner() internal view virtual {
151         require(owner() == _msgSender(), "Ownable: caller is not the owner");
152     }
153 
154     /**
155      * @dev Leaves the contract without owner. It will not be possible to call
156      * `onlyOwner` functions anymore. Can only be called by the current owner.
157      *
158      * NOTE: Renouncing ownership will leave the contract without an owner,
159      * thereby removing any functionality that is only available to the owner.
160      */
161     function renounceOwnership() public virtual onlyOwner {
162         _transferOwnership(address(0));
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         _transferOwnership(newOwner);
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Internal function without access restriction.
177      */
178     function _transferOwnership(address newOwner) internal virtual {
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182     }
183 }
184 
185 // File: @openzeppelin/contracts/utils/Address.sol
186 
187 
188 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
189 
190 pragma solidity ^0.8.1;
191 
192 /**
193  * @dev Collection of functions related to the address type
194  */
195 library Address {
196     /**
197      * @dev Returns true if `account` is a contract.
198      *
199      * [IMPORTANT]
200      * ====
201      * It is unsafe to assume that an address for which this function returns
202      * false is an externally-owned account (EOA) and not a contract.
203      *
204      * Among others, `isContract` will return false for the following
205      * types of addresses:
206      *
207      *  - an externally-owned account
208      *  - a contract in construction
209      *  - an address where a contract will be created
210      *  - an address where a contract lived, but was destroyed
211      * ====
212      *
213      * [IMPORTANT]
214      * ====
215      * You shouldn't rely on `isContract` to protect against flash loan attacks!
216      *
217      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
218      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
219      * constructor.
220      * ====
221      */
222     function isContract(address account) internal view returns (bool) {
223         // This method relies on extcodesize/address.code.length, which returns 0
224         // for contracts in construction, since the code is only stored at the end
225         // of the constructor execution.
226 
227         return account.code.length > 0;
228     }
229 
230     /**
231      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
232      * `recipient`, forwarding all available gas and reverting on errors.
233      *
234      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
235      * of certain opcodes, possibly making contracts go over the 2300 gas limit
236      * imposed by `transfer`, making them unable to receive funds via
237      * `transfer`. {sendValue} removes this limitation.
238      *
239      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
240      *
241      * IMPORTANT: because control is transferred to `recipient`, care must be
242      * taken to not create reentrancy vulnerabilities. Consider using
243      * {ReentrancyGuard} or the
244      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
245      */
246     function sendValue(address payable recipient, uint256 amount) internal {
247         require(address(this).balance >= amount, "Address: insufficient balance");
248 
249         (bool success, ) = recipient.call{value: amount}("");
250         require(success, "Address: unable to send value, recipient may have reverted");
251     }
252 
253     /**
254      * @dev Performs a Solidity function call using a low level `call`. A
255      * plain `call` is an unsafe replacement for a function call: use this
256      * function instead.
257      *
258      * If `target` reverts with a revert reason, it is bubbled up by this
259      * function (like regular Solidity function calls).
260      *
261      * Returns the raw returned data. To convert to the expected return value,
262      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
263      *
264      * Requirements:
265      *
266      * - `target` must be a contract.
267      * - calling `target` with `data` must not revert.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
277      * `errorMessage` as a fallback revert reason when `target` reverts.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         return functionCallWithValue(target, data, 0, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but also transferring `value` wei to `target`.
292      *
293      * Requirements:
294      *
295      * - the calling contract must have an ETH balance of at least `value`.
296      * - the called Solidity function must be `payable`.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
310      * with `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(
315         address target,
316         bytes memory data,
317         uint256 value,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         require(address(this).balance >= value, "Address: insufficient balance for call");
321         (bool success, bytes memory returndata) = target.call{value: value}(data);
322         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but performing a static call.
328      *
329      * _Available since v3.3._
330      */
331     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
332         return functionStaticCall(target, data, "Address: low-level static call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal view returns (bytes memory) {
346         (bool success, bytes memory returndata) = target.staticcall(data);
347         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         (bool success, bytes memory returndata) = target.delegatecall(data);
372         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
377      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
378      *
379      * _Available since v4.8._
380      */
381     function verifyCallResultFromTarget(
382         address target,
383         bool success,
384         bytes memory returndata,
385         string memory errorMessage
386     ) internal view returns (bytes memory) {
387         if (success) {
388             if (returndata.length == 0) {
389                 // only check isContract if the call was successful and the return data is empty
390                 // otherwise we already know that it was a contract
391                 require(isContract(target), "Address: call to non-contract");
392             }
393             return returndata;
394         } else {
395             _revert(returndata, errorMessage);
396         }
397     }
398 
399     /**
400      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
401      * revert reason or using the provided one.
402      *
403      * _Available since v4.3._
404      */
405     function verifyCallResult(
406         bool success,
407         bytes memory returndata,
408         string memory errorMessage
409     ) internal pure returns (bytes memory) {
410         if (success) {
411             return returndata;
412         } else {
413             _revert(returndata, errorMessage);
414         }
415     }
416 
417     function _revert(bytes memory returndata, string memory errorMessage) private pure {
418         // Look for revert reason and bubble it up if present
419         if (returndata.length > 0) {
420             // The easiest way to bubble the revert reason is using memory via assembly
421             /// @solidity memory-safe-assembly
422             assembly {
423                 let returndata_size := mload(returndata)
424                 revert(add(32, returndata), returndata_size)
425             }
426         } else {
427             revert(errorMessage);
428         }
429     }
430 }
431 
432 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Interface of the ERC165 standard, as defined in the
441  * https://eips.ethereum.org/EIPS/eip-165[EIP].
442  *
443  * Implementers can declare support of contract interfaces, which can then be
444  * queried by others ({ERC165Checker}).
445  *
446  * For an implementation, see {ERC165}.
447  */
448 interface IERC165 {
449     /**
450      * @dev Returns true if this contract implements the interface defined by
451      * `interfaceId`. See the corresponding
452      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
453      * to learn more about how these ids are created.
454      *
455      * This function call must use less than 30 000 gas.
456      */
457     function supportsInterface(bytes4 interfaceId) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @dev Implementation of the {IERC165} interface.
470  *
471  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
472  * for the additional interface id that will be supported. For example:
473  *
474  * ```solidity
475  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
476  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
477  * }
478  * ```
479  *
480  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
481  */
482 abstract contract ERC165 is IERC165 {
483     /**
484      * @dev See {IERC165-supportsInterface}.
485      */
486     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
487         return interfaceId == type(IERC165).interfaceId;
488     }
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
492 
493 
494 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @dev _Available since v3.1._
501  */
502 interface IERC1155Receiver is IERC165 {
503     /**
504      * @dev Handles the receipt of a single ERC1155 token type. This function is
505      * called at the end of a `safeTransferFrom` after the balance has been updated.
506      *
507      * NOTE: To accept the transfer, this must return
508      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
509      * (i.e. 0xf23a6e61, or its own function selector).
510      *
511      * @param operator The address which initiated the transfer (i.e. msg.sender)
512      * @param from The address which previously owned the token
513      * @param id The ID of the token being transferred
514      * @param value The amount of tokens being transferred
515      * @param data Additional data with no specified format
516      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
517      */
518     function onERC1155Received(
519         address operator,
520         address from,
521         uint256 id,
522         uint256 value,
523         bytes calldata data
524     ) external returns (bytes4);
525 
526     /**
527      * @dev Handles the receipt of a multiple ERC1155 token types. This function
528      * is called at the end of a `safeBatchTransferFrom` after the balances have
529      * been updated.
530      *
531      * NOTE: To accept the transfer(s), this must return
532      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
533      * (i.e. 0xbc197c81, or its own function selector).
534      *
535      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
536      * @param from The address which previously owned the token
537      * @param ids An array containing ids of each token being transferred (order and length must match values array)
538      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
539      * @param data Additional data with no specified format
540      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
541      */
542     function onERC1155BatchReceived(
543         address operator,
544         address from,
545         uint256[] calldata ids,
546         uint256[] calldata values,
547         bytes calldata data
548     ) external returns (bytes4);
549 }
550 
551 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
552 
553 
554 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 /**
560  * @dev Required interface of an ERC1155 compliant contract, as defined in the
561  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
562  *
563  * _Available since v3.1._
564  */
565 interface IERC1155 is IERC165 {
566     /**
567      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
568      */
569     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
570 
571     /**
572      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
573      * transfers.
574      */
575     event TransferBatch(
576         address indexed operator,
577         address indexed from,
578         address indexed to,
579         uint256[] ids,
580         uint256[] values
581     );
582 
583     /**
584      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
585      * `approved`.
586      */
587     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
588 
589     /**
590      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
591      *
592      * If an {URI} event was emitted for `id`, the standard
593      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
594      * returned by {IERC1155MetadataURI-uri}.
595      */
596     event URI(string value, uint256 indexed id);
597 
598     /**
599      * @dev Returns the amount of tokens of token type `id` owned by `account`.
600      *
601      * Requirements:
602      *
603      * - `account` cannot be the zero address.
604      */
605     function balanceOf(address account, uint256 id) external view returns (uint256);
606 
607     /**
608      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
609      *
610      * Requirements:
611      *
612      * - `accounts` and `ids` must have the same length.
613      */
614     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
615         external
616         view
617         returns (uint256[] memory);
618 
619     /**
620      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
621      *
622      * Emits an {ApprovalForAll} event.
623      *
624      * Requirements:
625      *
626      * - `operator` cannot be the caller.
627      */
628     function setApprovalForAll(address operator, bool approved) external;
629 
630     /**
631      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
632      *
633      * See {setApprovalForAll}.
634      */
635     function isApprovedForAll(address account, address operator) external view returns (bool);
636 
637     /**
638      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
639      *
640      * Emits a {TransferSingle} event.
641      *
642      * Requirements:
643      *
644      * - `to` cannot be the zero address.
645      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
646      * - `from` must have a balance of tokens of type `id` of at least `amount`.
647      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
648      * acceptance magic value.
649      */
650     function safeTransferFrom(
651         address from,
652         address to,
653         uint256 id,
654         uint256 amount,
655         bytes calldata data
656     ) external;
657 
658     /**
659      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
660      *
661      * Emits a {TransferBatch} event.
662      *
663      * Requirements:
664      *
665      * - `ids` and `amounts` must have the same length.
666      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
667      * acceptance magic value.
668      */
669     function safeBatchTransferFrom(
670         address from,
671         address to,
672         uint256[] calldata ids,
673         uint256[] calldata amounts,
674         bytes calldata data
675     ) external;
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
679 
680 
681 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
688  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
689  *
690  * _Available since v3.1._
691  */
692 interface IERC1155MetadataURI is IERC1155 {
693     /**
694      * @dev Returns the URI for token type `id`.
695      *
696      * If the `\{id\}` substring is present in the URI, it must be replaced by
697      * clients with the actual token type ID.
698      */
699     function uri(uint256 id) external view returns (string memory);
700 }
701 
702 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
703 
704 
705 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 
711 
712 
713 
714 
715 /**
716  * @dev Implementation of the basic standard multi-token.
717  * See https://eips.ethereum.org/EIPS/eip-1155
718  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
719  *
720  * _Available since v3.1._
721  */
722 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
723     using Address for address;
724 
725     // Mapping from token ID to account balances
726     mapping(uint256 => mapping(address => uint256)) private _balances;
727 
728     // Mapping from account to operator approvals
729     mapping(address => mapping(address => bool)) private _operatorApprovals;
730 
731     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
732     string private _uri;
733 
734     /**
735      * @dev See {_setURI}.
736      */
737     constructor(string memory uri_) {
738         _setURI(uri_);
739     }
740 
741     /**
742      * @dev See {IERC165-supportsInterface}.
743      */
744     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
745         return
746             interfaceId == type(IERC1155).interfaceId ||
747             interfaceId == type(IERC1155MetadataURI).interfaceId ||
748             super.supportsInterface(interfaceId);
749     }
750 
751     /**
752      * @dev See {IERC1155MetadataURI-uri}.
753      *
754      * This implementation returns the same URI for *all* token types. It relies
755      * on the token type ID substitution mechanism
756      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
757      *
758      * Clients calling this function must replace the `\{id\}` substring with the
759      * actual token type ID.
760      */
761     function uri(uint256) public view virtual override returns (string memory) {
762         return _uri;
763     }
764 
765     /**
766      * @dev See {IERC1155-balanceOf}.
767      *
768      * Requirements:
769      *
770      * - `account` cannot be the zero address.
771      */
772     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
773         require(account != address(0), "ERC1155: address zero is not a valid owner");
774         return _balances[id][account];
775     }
776 
777     /**
778      * @dev See {IERC1155-balanceOfBatch}.
779      *
780      * Requirements:
781      *
782      * - `accounts` and `ids` must have the same length.
783      */
784     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
785         public
786         view
787         virtual
788         override
789         returns (uint256[] memory)
790     {
791         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
792 
793         uint256[] memory batchBalances = new uint256[](accounts.length);
794 
795         for (uint256 i = 0; i < accounts.length; ++i) {
796             batchBalances[i] = balanceOf(accounts[i], ids[i]);
797         }
798 
799         return batchBalances;
800     }
801 
802     /**
803      * @dev See {IERC1155-setApprovalForAll}.
804      */
805     function setApprovalForAll(address operator, bool approved) public virtual override {
806         _setApprovalForAll(_msgSender(), operator, approved);
807     }
808 
809     /**
810      * @dev See {IERC1155-isApprovedForAll}.
811      */
812     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
813         return _operatorApprovals[account][operator];
814     }
815 
816     /**
817      * @dev See {IERC1155-safeTransferFrom}.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 id,
823         uint256 amount,
824         bytes memory data
825     ) public virtual override {
826         require(
827             from == _msgSender() || isApprovedForAll(from, _msgSender()),
828             "ERC1155: caller is not token owner or approved"
829         );
830         _safeTransferFrom(from, to, id, amount, data);
831     }
832 
833     /**
834      * @dev See {IERC1155-safeBatchTransferFrom}.
835      */
836     function safeBatchTransferFrom(
837         address from,
838         address to,
839         uint256[] memory ids,
840         uint256[] memory amounts,
841         bytes memory data
842     ) public virtual override {
843         require(
844             from == _msgSender() || isApprovedForAll(from, _msgSender()),
845             "ERC1155: caller is not token owner or approved"
846         );
847         _safeBatchTransferFrom(from, to, ids, amounts, data);
848     }
849 
850     /**
851      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
852      *
853      * Emits a {TransferSingle} event.
854      *
855      * Requirements:
856      *
857      * - `to` cannot be the zero address.
858      * - `from` must have a balance of tokens of type `id` of at least `amount`.
859      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
860      * acceptance magic value.
861      */
862     function _safeTransferFrom(
863         address from,
864         address to,
865         uint256 id,
866         uint256 amount,
867         bytes memory data
868     ) internal virtual {
869         require(to != address(0), "ERC1155: transfer to the zero address");
870 
871         address operator = _msgSender();
872         uint256[] memory ids = _asSingletonArray(id);
873         uint256[] memory amounts = _asSingletonArray(amount);
874 
875         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
876 
877         uint256 fromBalance = _balances[id][from];
878         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
879         unchecked {
880             _balances[id][from] = fromBalance - amount;
881         }
882         _balances[id][to] += amount;
883 
884         emit TransferSingle(operator, from, to, id, amount);
885 
886         _afterTokenTransfer(operator, from, to, ids, amounts, data);
887 
888         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
889     }
890 
891     /**
892      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
893      *
894      * Emits a {TransferBatch} event.
895      *
896      * Requirements:
897      *
898      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
899      * acceptance magic value.
900      */
901     function _safeBatchTransferFrom(
902         address from,
903         address to,
904         uint256[] memory ids,
905         uint256[] memory amounts,
906         bytes memory data
907     ) internal virtual {
908         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
909         require(to != address(0), "ERC1155: transfer to the zero address");
910 
911         address operator = _msgSender();
912 
913         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
914 
915         for (uint256 i = 0; i < ids.length; ++i) {
916             uint256 id = ids[i];
917             uint256 amount = amounts[i];
918 
919             uint256 fromBalance = _balances[id][from];
920             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
921             unchecked {
922                 _balances[id][from] = fromBalance - amount;
923             }
924             _balances[id][to] += amount;
925         }
926 
927         emit TransferBatch(operator, from, to, ids, amounts);
928 
929         _afterTokenTransfer(operator, from, to, ids, amounts, data);
930 
931         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
932     }
933 
934     /**
935      * @dev Sets a new URI for all token types, by relying on the token type ID
936      * substitution mechanism
937      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
938      *
939      * By this mechanism, any occurrence of the `\{id\}` substring in either the
940      * URI or any of the amounts in the JSON file at said URI will be replaced by
941      * clients with the token type ID.
942      *
943      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
944      * interpreted by clients as
945      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
946      * for token type ID 0x4cce0.
947      *
948      * See {uri}.
949      *
950      * Because these URIs cannot be meaningfully represented by the {URI} event,
951      * this function emits no events.
952      */
953     function _setURI(string memory newuri) internal virtual {
954         _uri = newuri;
955     }
956 
957     /**
958      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
959      *
960      * Emits a {TransferSingle} event.
961      *
962      * Requirements:
963      *
964      * - `to` cannot be the zero address.
965      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
966      * acceptance magic value.
967      */
968     function _mint(
969         address to,
970         uint256 id,
971         uint256 amount,
972         bytes memory data
973     ) internal virtual {
974         require(to != address(0), "ERC1155: mint to the zero address");
975 
976         address operator = _msgSender();
977         uint256[] memory ids = _asSingletonArray(id);
978         uint256[] memory amounts = _asSingletonArray(amount);
979 
980         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
981 
982         _balances[id][to] += amount;
983         emit TransferSingle(operator, address(0), to, id, amount);
984 
985         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
986 
987         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
988     }
989 
990     /**
991      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
992      *
993      * Emits a {TransferBatch} event.
994      *
995      * Requirements:
996      *
997      * - `ids` and `amounts` must have the same length.
998      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
999      * acceptance magic value.
1000      */
1001     function _mintBatch(
1002         address to,
1003         uint256[] memory ids,
1004         uint256[] memory amounts,
1005         bytes memory data
1006     ) internal virtual {
1007         require(to != address(0), "ERC1155: mint to the zero address");
1008         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1009 
1010         address operator = _msgSender();
1011 
1012         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1013 
1014         for (uint256 i = 0; i < ids.length; i++) {
1015             _balances[ids[i]][to] += amounts[i];
1016         }
1017 
1018         emit TransferBatch(operator, address(0), to, ids, amounts);
1019 
1020         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1021 
1022         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1023     }
1024 
1025     /**
1026      * @dev Destroys `amount` tokens of token type `id` from `from`
1027      *
1028      * Emits a {TransferSingle} event.
1029      *
1030      * Requirements:
1031      *
1032      * - `from` cannot be the zero address.
1033      * - `from` must have at least `amount` tokens of token type `id`.
1034      */
1035     function _burn(
1036         address from,
1037         uint256 id,
1038         uint256 amount
1039     ) internal virtual {
1040         require(from != address(0), "ERC1155: burn from the zero address");
1041 
1042         address operator = _msgSender();
1043         uint256[] memory ids = _asSingletonArray(id);
1044         uint256[] memory amounts = _asSingletonArray(amount);
1045 
1046         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1047 
1048         uint256 fromBalance = _balances[id][from];
1049         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1050         unchecked {
1051             _balances[id][from] = fromBalance - amount;
1052         }
1053 
1054         emit TransferSingle(operator, from, address(0), id, amount);
1055 
1056         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1057     }
1058 
1059     /**
1060      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1061      *
1062      * Emits a {TransferBatch} event.
1063      *
1064      * Requirements:
1065      *
1066      * - `ids` and `amounts` must have the same length.
1067      */
1068     function _burnBatch(
1069         address from,
1070         uint256[] memory ids,
1071         uint256[] memory amounts
1072     ) internal virtual {
1073         require(from != address(0), "ERC1155: burn from the zero address");
1074         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1075 
1076         address operator = _msgSender();
1077 
1078         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1079 
1080         for (uint256 i = 0; i < ids.length; i++) {
1081             uint256 id = ids[i];
1082             uint256 amount = amounts[i];
1083 
1084             uint256 fromBalance = _balances[id][from];
1085             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1086             unchecked {
1087                 _balances[id][from] = fromBalance - amount;
1088             }
1089         }
1090 
1091         emit TransferBatch(operator, from, address(0), ids, amounts);
1092 
1093         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1094     }
1095 
1096     /**
1097      * @dev Approve `operator` to operate on all of `owner` tokens
1098      *
1099      * Emits an {ApprovalForAll} event.
1100      */
1101     function _setApprovalForAll(
1102         address owner,
1103         address operator,
1104         bool approved
1105     ) internal virtual {
1106         require(owner != operator, "ERC1155: setting approval status for self");
1107         _operatorApprovals[owner][operator] = approved;
1108         emit ApprovalForAll(owner, operator, approved);
1109     }
1110 
1111     /**
1112      * @dev Hook that is called before any token transfer. This includes minting
1113      * and burning, as well as batched variants.
1114      *
1115      * The same hook is called on both single and batched variants. For single
1116      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1117      *
1118      * Calling conditions (for each `id` and `amount` pair):
1119      *
1120      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1121      * of token type `id` will be  transferred to `to`.
1122      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1123      * for `to`.
1124      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1125      * will be burned.
1126      * - `from` and `to` are never both zero.
1127      * - `ids` and `amounts` have the same, non-zero length.
1128      *
1129      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1130      */
1131     function _beforeTokenTransfer(
1132         address operator,
1133         address from,
1134         address to,
1135         uint256[] memory ids,
1136         uint256[] memory amounts,
1137         bytes memory data
1138     ) internal virtual {}
1139 
1140     /**
1141      * @dev Hook that is called after any token transfer. This includes minting
1142      * and burning, as well as batched variants.
1143      *
1144      * The same hook is called on both single and batched variants. For single
1145      * transfers, the length of the `id` and `amount` arrays will be 1.
1146      *
1147      * Calling conditions (for each `id` and `amount` pair):
1148      *
1149      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1150      * of token type `id` will be  transferred to `to`.
1151      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1152      * for `to`.
1153      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1154      * will be burned.
1155      * - `from` and `to` are never both zero.
1156      * - `ids` and `amounts` have the same, non-zero length.
1157      *
1158      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1159      */
1160     function _afterTokenTransfer(
1161         address operator,
1162         address from,
1163         address to,
1164         uint256[] memory ids,
1165         uint256[] memory amounts,
1166         bytes memory data
1167     ) internal virtual {}
1168 
1169     function _doSafeTransferAcceptanceCheck(
1170         address operator,
1171         address from,
1172         address to,
1173         uint256 id,
1174         uint256 amount,
1175         bytes memory data
1176     ) private {
1177         if (to.isContract()) {
1178             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1179                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1180                     revert("ERC1155: ERC1155Receiver rejected tokens");
1181                 }
1182             } catch Error(string memory reason) {
1183                 revert(reason);
1184             } catch {
1185                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1186             }
1187         }
1188     }
1189 
1190     function _doSafeBatchTransferAcceptanceCheck(
1191         address operator,
1192         address from,
1193         address to,
1194         uint256[] memory ids,
1195         uint256[] memory amounts,
1196         bytes memory data
1197     ) private {
1198         if (to.isContract()) {
1199             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1200                 bytes4 response
1201             ) {
1202                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1203                     revert("ERC1155: ERC1155Receiver rejected tokens");
1204                 }
1205             } catch Error(string memory reason) {
1206                 revert(reason);
1207             } catch {
1208                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1209             }
1210         }
1211     }
1212 
1213     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1214         uint256[] memory array = new uint256[](1);
1215         array[0] = element;
1216 
1217         return array;
1218     }
1219 }
1220 
1221 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1222 
1223 
1224 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 
1229 /**
1230  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1231  *
1232  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1233  * clearly identified. Note: While a totalSupply of 1 might mean the
1234  * corresponding is an NFT, there is no guarantees that no other token with the
1235  * same id are not going to be minted.
1236  */
1237 abstract contract ERC1155Supply is ERC1155 {
1238     mapping(uint256 => uint256) private _totalSupply;
1239 
1240     /**
1241      * @dev Total amount of tokens in with a given id.
1242      */
1243     function totalSupply(uint256 id) public view virtual returns (uint256) {
1244         return _totalSupply[id];
1245     }
1246 
1247     /**
1248      * @dev Indicates whether any token exist with a given id, or not.
1249      */
1250     function exists(uint256 id) public view virtual returns (bool) {
1251         return ERC1155Supply.totalSupply(id) > 0;
1252     }
1253 
1254     /**
1255      * @dev See {ERC1155-_beforeTokenTransfer}.
1256      */
1257     function _beforeTokenTransfer(
1258         address operator,
1259         address from,
1260         address to,
1261         uint256[] memory ids,
1262         uint256[] memory amounts,
1263         bytes memory data
1264     ) internal virtual override {
1265         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1266 
1267         if (from == address(0)) {
1268             for (uint256 i = 0; i < ids.length; ++i) {
1269                 _totalSupply[ids[i]] += amounts[i];
1270             }
1271         }
1272 
1273         if (to == address(0)) {
1274             for (uint256 i = 0; i < ids.length; ++i) {
1275                 uint256 id = ids[i];
1276                 uint256 amount = amounts[i];
1277                 uint256 supply = _totalSupply[id];
1278                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1279                 unchecked {
1280                     _totalSupply[id] = supply - amount;
1281                 }
1282             }
1283         }
1284     }
1285 }
1286 
1287 // File: contracts/cubeXGold.sol
1288 
1289 //SPDX-License-Identifier: MIT
1290 pragma solidity ^0.8.2;
1291 
1292 
1293 
1294 
1295 
1296 
1297 
1298 
1299 /*
1300  * By @Dr.Robotnik
1301  */
1302 contract cubeXGoldCrad is ERC1155, ERC1155Supply, Ownable {
1303     constructor(string memory _uri) ERC1155(_uri) {
1304         _setURI(_uri);
1305     }
1306 
1307     function setURI(string memory newuri) public onlyOwner {
1308         _setURI(newuri);
1309     }
1310 
1311     function claim(uint256 _dropNumber, address[] calldata _list)
1312         public
1313         onlyOwner
1314         
1315     {
1316         for (uint256 i = 0; i < _list.length; i++) {
1317             _mint(_list[i], _dropNumber, 10, "");
1318         }
1319     }
1320     function airdrop5(uint256 _dropNumber, address[] calldata _list)
1321         public
1322         onlyOwner
1323     {
1324         for (uint256 i = 0; i < _list.length; i++) {
1325             _mint(_list[i], _dropNumber, 5, "");
1326         }
1327     }
1328     function airdrop3(uint256 _dropNumber, address[] calldata _list)
1329         public
1330         onlyOwner
1331     {
1332         for (uint256 i = 0; i < _list.length; i++) {
1333             _mint(_list[i], _dropNumber, 3, "");
1334         }
1335     }
1336     function airdrop2(uint256 _dropNumber, address[] calldata _list)
1337         public
1338         onlyOwner
1339     {
1340         for (uint256 i = 0; i < _list.length; i++) {
1341             _mint(_list[i], _dropNumber, 2, "");
1342         }
1343     }
1344     function airdrop25(uint256 _dropNumber, address[] calldata _list)
1345         public
1346         onlyOwner
1347     {
1348         for (uint256 i = 0; i < _list.length; i++) {
1349             _mint(_list[i], _dropNumber, 25, "");
1350         }
1351     }
1352 
1353  
1354     function batchMint(
1355         uint256 _tokenID,
1356         address _address,
1357         uint256 _quantity
1358     ) public onlyOwner {
1359         _mint(_address, _tokenID, _quantity, "");
1360     }
1361 
1362     function _beforeTokenTransfer(
1363         address operator,
1364         address from,
1365         address to,
1366         uint256[] memory ids,
1367         uint256[] memory amounts,
1368         bytes memory data
1369     ) internal override(ERC1155, ERC1155Supply) {
1370         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1371     }
1372 }