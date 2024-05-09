1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length)
55         internal
56         pure
57         returns (string memory)
58     {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 /**
74  * @dev Provides information about the current execution context, including the
75  * sender of the transaction and its data. While these are generally available
76  * via msg.sender and msg.data, they should not be accessed in such a direct
77  * manner, since when dealing with meta-transactions the account sending and
78  * paying for execution may not be the actual sender (as far as an application
79  * is concerned).
80  *
81  * This contract is only required for intermediate, library-like contracts.
82  */
83 abstract contract Context {
84     function _msgSender() internal view virtual returns (address) {
85         return msg.sender;
86     }
87 
88     function _msgData() internal view virtual returns (bytes calldata) {
89         return msg.data;
90     }
91 }
92 
93 // File: @openzeppelin/contracts/access/Ownable.sol
94 
95 /**
96  * @dev Contract module which provides a basic access control mechanism, where
97  * there is an account (an owner) that can be granted exclusive access to
98  * specific functions.
99  *
100  * By default, the owner account will be the one that deploys the contract. This
101  * can later be changed with {transferOwnership}.
102  *
103  * This module is used through inheritance. It will make available the modifier
104  * `onlyOwner`, which can be applied to your functions to restrict their use to
105  * the owner.
106  */
107 abstract contract Ownable is Context {
108     address private _owner;
109 
110     event OwnershipTransferred(
111         address indexed previousOwner,
112         address indexed newOwner
113     );
114 
115     /**
116      * @dev Initializes the contract setting the deployer as the initial owner.
117      */
118     constructor() {
119         _setOwner(_msgSender());
120     }
121 
122     /**
123      * @dev Returns the address of the current owner.
124      */
125     function owner() public view virtual returns (address) {
126         return _owner;
127     }
128 
129     /**
130      * @dev Throws if called by any account other than the owner.
131      */
132     modifier onlyOwner() {
133         require(owner() == _msgSender(), "Ownable: caller is not the owner");
134         _;
135     }
136 
137     /**
138      * @dev Leaves the contract without owner. It will not be possible to call
139      * `onlyOwner` functions anymore. Can only be called by the current owner.
140      *
141      * NOTE: Renouncing ownership will leave the contract without an owner,
142      * thereby removing any functionality that is only available to the owner.
143      */
144     function renounceOwnership() public virtual onlyOwner {
145         _setOwner(address(0));
146     }
147 
148     /**
149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
150      * Can only be called by the current owner.
151      */
152     function transferOwnership(address newOwner) public virtual onlyOwner {
153         require(
154             newOwner != address(0),
155             "Ownable: new owner is the zero address"
156         );
157         _setOwner(newOwner);
158     }
159 
160     function _setOwner(address newOwner) private {
161         address oldOwner = _owner;
162         _owner = newOwner;
163         emit OwnershipTransferred(oldOwner, newOwner);
164     }
165 }
166 
167 // File: @openzeppelin/contracts/utils/Address.sol
168 
169 /**
170  * @dev Collection of functions related to the address type
171  */
172 library Address {
173     /**
174      * @dev Returns true if `account` is a contract.
175      *
176      * [IMPORTANT]
177      * ====
178      * It is unsafe to assume that an address for which this function returns
179      * false is an externally-owned account (EOA) and not a contract.
180      *
181      * Among others, `isContract` will return false for the following
182      * types of addresses:
183      *
184      *  - an externally-owned account
185      *  - a contract in construction
186      *  - an address where a contract will be created
187      *  - an address where a contract lived, but was destroyed
188      * ====
189      */
190     function isContract(address account) internal view returns (bool) {
191         // This method relies on extcodesize, which returns 0 for contracts in
192         // construction, since the code is only stored at the end of the
193         // constructor execution.
194 
195         uint256 size;
196         assembly {
197             size := extcodesize(account)
198         }
199         return size > 0;
200     }
201 
202     /**
203      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
204      * `recipient`, forwarding all available gas and reverting on errors.
205      *
206      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
207      * of certain opcodes, possibly making contracts go over the 2300 gas limit
208      * imposed by `transfer`, making them unable to receive funds via
209      * `transfer`. {sendValue} removes this limitation.
210      *
211      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
212      *
213      * IMPORTANT: because control is transferred to `recipient`, care must be
214      * taken to not create reentrancy vulnerabilities. Consider using
215      * {ReentrancyGuard} or the
216      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
217      */
218     function sendValue(address payable recipient, uint256 amount) internal {
219         require(
220             address(this).balance >= amount,
221             "Address: insufficient balance"
222         );
223 
224         (bool success, ) = recipient.call{value: amount}("");
225         require(
226             success,
227             "Address: unable to send value, recipient may have reverted"
228         );
229     }
230 
231     /**
232      * @dev Performs a Solidity function call using a low level `call`. A
233      * plain `call` is an unsafe replacement for a function call: use this
234      * function instead.
235      *
236      * If `target` reverts with a revert reason, it is bubbled up by this
237      * function (like regular Solidity function calls).
238      *
239      * Returns the raw returned data. To convert to the expected return value,
240      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
241      *
242      * Requirements:
243      *
244      * - `target` must be a contract.
245      * - calling `target` with `data` must not revert.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(address target, bytes memory data)
250         internal
251         returns (bytes memory)
252     {
253         return functionCall(target, data, "Address: low-level call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
258      * `errorMessage` as a fallback revert reason when `target` reverts.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         return functionCallWithValue(target, data, 0, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but also transferring `value` wei to `target`.
273      *
274      * Requirements:
275      *
276      * - the calling contract must have an ETH balance of at least `value`.
277      * - the called Solidity function must be `payable`.
278      *
279      * _Available since v3.1._
280      */
281     function functionCallWithValue(
282         address target,
283         bytes memory data,
284         uint256 value
285     ) internal returns (bytes memory) {
286         return
287             functionCallWithValue(
288                 target,
289                 data,
290                 value,
291                 "Address: low-level call with value failed"
292             );
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
307         require(
308             address(this).balance >= value,
309             "Address: insufficient balance for call"
310         );
311         require(isContract(target), "Address: call to non-contract");
312 
313         (bool success, bytes memory returndata) = target.call{value: value}(
314             data
315         );
316         return verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(address target, bytes memory data)
326         internal
327         view
328         returns (bytes memory)
329     {
330         return
331             functionStaticCall(
332                 target,
333                 data,
334                 "Address: low-level static call failed"
335             );
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.staticcall(data);
352         return verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(address target, bytes memory data)
362         internal
363         returns (bytes memory)
364     {
365         return
366             functionDelegateCall(
367                 target,
368                 data,
369                 "Address: low-level delegate call failed"
370             );
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a delegate call.
376      *
377      * _Available since v3.4._
378      */
379     function functionDelegateCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(isContract(target), "Address: delegate call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.delegatecall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
392      * revert reason using the provided one.
393      *
394      * _Available since v4.3._
395      */
396     function verifyCallResult(
397         bool success,
398         bytes memory returndata,
399         string memory errorMessage
400     ) internal pure returns (bytes memory) {
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407 
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 
419 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
420 
421 /**
422  * @dev Interface of the ERC165 standard, as defined in the
423  * https://eips.ethereum.org/EIPS/eip-165[EIP].
424  *
425  * Implementers can declare support of contract interfaces, which can then be
426  * queried by others ({ERC165Checker}).
427  *
428  * For an implementation, see {ERC165}.
429  */
430 interface IERC165 {
431     /**
432      * @dev Returns true if this contract implements the interface defined by
433      * `interfaceId`. See the corresponding
434      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
435      * to learn more about how these ids are created.
436      *
437      * This function call must use less than 30 000 gas.
438      */
439     function supportsInterface(bytes4 interfaceId) external view returns (bool);
440 }
441 
442 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
443 
444 /**
445  * @dev Implementation of the {IERC165} interface.
446  *
447  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
448  * for the additional interface id that will be supported. For example:
449  *
450  * ```solidity
451  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
452  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
453  * }
454  * ```
455  *
456  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
457  */
458 abstract contract ERC165 is IERC165 {
459     /**
460      * @dev See {IERC165-supportsInterface}.
461      */
462     function supportsInterface(bytes4 interfaceId)
463         public
464         view
465         virtual
466         override
467         returns (bool)
468     {
469         return interfaceId == type(IERC165).interfaceId;
470     }
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
474 
475 /**
476  * @dev _Available since v3.1._
477  */
478 interface IERC1155Receiver is IERC165 {
479     /**
480         @dev Handles the receipt of a single ERC1155 token type. This function is
481         called at the end of a `safeTransferFrom` after the balance has been updated.
482         To accept the transfer, this must return
483         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
484         (i.e. 0xf23a6e61, or its own function selector).
485         @param operator The address which initiated the transfer (i.e. msg.sender)
486         @param from The address which previously owned the token
487         @param id The ID of the token being transferred
488         @param value The amount of tokens being transferred
489         @param data Additional data with no specified format
490         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
491     */
492     function onERC1155Received(
493         address operator,
494         address from,
495         uint256 id,
496         uint256 value,
497         bytes calldata data
498     ) external returns (bytes4);
499 
500     /**
501         @dev Handles the receipt of a multiple ERC1155 token types. This function
502         is called at the end of a `safeBatchTransferFrom` after the balances have
503         been updated. To accept the transfer(s), this must return
504         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
505         (i.e. 0xbc197c81, or its own function selector).
506         @param operator The address which initiated the batch transfer (i.e. msg.sender)
507         @param from The address which previously owned the token
508         @param ids An array containing ids of each token being transferred (order and length must match values array)
509         @param values An array containing amounts of each token being transferred (order and length must match ids array)
510         @param data Additional data with no specified format
511         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
512     */
513     function onERC1155BatchReceived(
514         address operator,
515         address from,
516         uint256[] calldata ids,
517         uint256[] calldata values,
518         bytes calldata data
519     ) external returns (bytes4);
520 }
521 
522 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
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
534     event TransferSingle(
535         address indexed operator,
536         address indexed from,
537         address indexed to,
538         uint256 id,
539         uint256 value
540     );
541 
542     /**
543      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
544      * transfers.
545      */
546     event TransferBatch(
547         address indexed operator,
548         address indexed from,
549         address indexed to,
550         uint256[] ids,
551         uint256[] values
552     );
553 
554     /**
555      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
556      * `approved`.
557      */
558     event ApprovalForAll(
559         address indexed account,
560         address indexed operator,
561         bool approved
562     );
563 
564     /**
565      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
566      *
567      * If an {URI} event was emitted for `id`, the standard
568      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
569      * returned by {IERC1155MetadataURI-uri}.
570      */
571     event URI(string value, uint256 indexed id);
572 
573     /**
574      * @dev Returns the amount of tokens of token type `id` owned by `account`.
575      *
576      * Requirements:
577      *
578      * - `account` cannot be the zero address.
579      */
580     function balanceOf(address account, uint256 id)
581         external
582         view
583         returns (uint256);
584 
585     /**
586      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
587      *
588      * Requirements:
589      *
590      * - `accounts` and `ids` must have the same length.
591      */
592     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
593         external
594         view
595         returns (uint256[] memory);
596 
597     /**
598      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
599      *
600      * Emits an {ApprovalForAll} event.
601      *
602      * Requirements:
603      *
604      * - `operator` cannot be the caller.
605      */
606     function setApprovalForAll(address operator, bool approved) external;
607 
608     /**
609      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
610      *
611      * See {setApprovalForAll}.
612      */
613     function isApprovedForAll(address account, address operator)
614         external
615         view
616         returns (bool);
617 
618     /**
619      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
620      *
621      * Emits a {TransferSingle} event.
622      *
623      * Requirements:
624      *
625      * - `to` cannot be the zero address.
626      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
627      * - `from` must have a balance of tokens of type `id` of at least `amount`.
628      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
629      * acceptance magic value.
630      */
631     function safeTransferFrom(
632         address from,
633         address to,
634         uint256 id,
635         uint256 amount,
636         bytes calldata data
637     ) external;
638 
639     /**
640      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
641      *
642      * Emits a {TransferBatch} event.
643      *
644      * Requirements:
645      *
646      * - `ids` and `amounts` must have the same length.
647      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
648      * acceptance magic value.
649      */
650     function safeBatchTransferFrom(
651         address from,
652         address to,
653         uint256[] calldata ids,
654         uint256[] calldata amounts,
655         bytes calldata data
656     ) external;
657 }
658 
659 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
660 
661 /**
662  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
663  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
664  *
665  * _Available since v3.1._
666  */
667 interface IERC1155MetadataURI is IERC1155 {
668     /**
669      * @dev Returns the URI for token type `id`.
670      *
671      * If the `\{id\}` substring is present in the URI, it must be replaced by
672      * clients with the actual token type ID.
673      */
674     function uri(uint256 id) external view returns (string memory);
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
678 
679 /**
680  * @dev Implementation of the basic standard multi-token.
681  * See https://eips.ethereum.org/EIPS/eip-1155
682  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
683  *
684  * _Available since v3.1._
685  */
686 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
687     using Address for address;
688 
689     // Mapping from token ID to account balances
690     mapping(uint256 => mapping(address => uint256)) private _balances;
691 
692     // Mapping from account to operator approvals
693     mapping(address => mapping(address => bool)) private _operatorApprovals;
694 
695     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
696     string private _uri;
697 
698     /**
699      * @dev See {_setURI}.
700      */
701     constructor(string memory uri_) {
702         _setURI(uri_);
703     }
704 
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId)
709         public
710         view
711         virtual
712         override(ERC165, IERC165)
713         returns (bool)
714     {
715         return
716             interfaceId == type(IERC1155).interfaceId ||
717             interfaceId == type(IERC1155MetadataURI).interfaceId ||
718             super.supportsInterface(interfaceId);
719     }
720 
721     /**
722      * @dev See {IERC1155MetadataURI-uri}.
723      *
724      * This implementation returns the same URI for *all* token types. It relies
725      * on the token type ID substitution mechanism
726      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
727      *
728      * Clients calling this function must replace the `\{id\}` substring with the
729      * actual token type ID.
730      */
731     function uri(uint256) public view virtual override returns (string memory) {
732         return _uri;
733     }
734 
735     /**
736      * @dev See {IERC1155-balanceOf}.
737      *
738      * Requirements:
739      *
740      * - `account` cannot be the zero address.
741      */
742     function balanceOf(address account, uint256 id)
743         public
744         view
745         virtual
746         override
747         returns (uint256)
748     {
749         require(
750             account != address(0),
751             "ERC1155: balance query for the zero address"
752         );
753         return _balances[id][account];
754     }
755 
756     /**
757      * @dev See {IERC1155-balanceOfBatch}.
758      *
759      * Requirements:
760      *
761      * - `accounts` and `ids` must have the same length.
762      */
763     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
764         public
765         view
766         virtual
767         override
768         returns (uint256[] memory)
769     {
770         require(
771             accounts.length == ids.length,
772             "ERC1155: accounts and ids length mismatch"
773         );
774 
775         uint256[] memory batchBalances = new uint256[](accounts.length);
776 
777         for (uint256 i = 0; i < accounts.length; ++i) {
778             batchBalances[i] = balanceOf(accounts[i], ids[i]);
779         }
780 
781         return batchBalances;
782     }
783 
784     /**
785      * @dev See {IERC1155-setApprovalForAll}.
786      */
787     function setApprovalForAll(address operator, bool approved)
788         public
789         virtual
790         override
791     {
792         require(
793             _msgSender() != operator,
794             "ERC1155: setting approval status for self"
795         );
796 
797         _operatorApprovals[_msgSender()][operator] = approved;
798         emit ApprovalForAll(_msgSender(), operator, approved);
799     }
800 
801     /**
802      * @dev See {IERC1155-isApprovedForAll}.
803      */
804     function isApprovedForAll(address account, address operator)
805         public
806         view
807         virtual
808         override
809         returns (bool)
810     {
811         return _operatorApprovals[account][operator];
812     }
813 
814     /**
815      * @dev See {IERC1155-safeTransferFrom}.
816      */
817     function safeTransferFrom(
818         address from,
819         address to,
820         uint256 id,
821         uint256 amount,
822         bytes memory data
823     ) public virtual override {
824         require(
825             from == _msgSender() || isApprovedForAll(from, _msgSender()),
826             "ERC1155: caller is not owner nor approved"
827         );
828         _safeTransferFrom(from, to, id, amount, data);
829     }
830 
831     /**
832      * @dev See {IERC1155-safeBatchTransferFrom}.
833      */
834     function safeBatchTransferFrom(
835         address from,
836         address to,
837         uint256[] memory ids,
838         uint256[] memory amounts,
839         bytes memory data
840     ) public virtual override {
841         require(
842             from == _msgSender() || isApprovedForAll(from, _msgSender()),
843             "ERC1155: transfer caller is not owner nor approved"
844         );
845         _safeBatchTransferFrom(from, to, ids, amounts, data);
846     }
847 
848     /**
849      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
850      *
851      * Emits a {TransferSingle} event.
852      *
853      * Requirements:
854      *
855      * - `to` cannot be the zero address.
856      * - `from` must have a balance of tokens of type `id` of at least `amount`.
857      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
858      * acceptance magic value.
859      */
860     function _safeTransferFrom(
861         address from,
862         address to,
863         uint256 id,
864         uint256 amount,
865         bytes memory data
866     ) internal virtual {
867         require(to != address(0), "ERC1155: transfer to the zero address");
868 
869         address operator = _msgSender();
870 
871         _beforeTokenTransfer(
872             operator,
873             from,
874             to,
875             _asSingletonArray(id),
876             _asSingletonArray(amount),
877             data
878         );
879 
880         uint256 fromBalance = _balances[id][from];
881         require(
882             fromBalance >= amount,
883             "ERC1155: insufficient balance for transfer"
884         );
885         unchecked {
886             _balances[id][from] = fromBalance - amount;
887         }
888         _balances[id][to] += amount;
889 
890         emit TransferSingle(operator, from, to, id, amount);
891 
892         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
893     }
894 
895     /**
896      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
897      *
898      * Emits a {TransferBatch} event.
899      *
900      * Requirements:
901      *
902      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
903      * acceptance magic value.
904      */
905     function _safeBatchTransferFrom(
906         address from,
907         address to,
908         uint256[] memory ids,
909         uint256[] memory amounts,
910         bytes memory data
911     ) internal virtual {
912         require(
913             ids.length == amounts.length,
914             "ERC1155: ids and amounts length mismatch"
915         );
916         require(to != address(0), "ERC1155: transfer to the zero address");
917 
918         address operator = _msgSender();
919 
920         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
921 
922         for (uint256 i = 0; i < ids.length; ++i) {
923             uint256 id = ids[i];
924             uint256 amount = amounts[i];
925 
926             uint256 fromBalance = _balances[id][from];
927             require(
928                 fromBalance >= amount,
929                 "ERC1155: insufficient balance for transfer"
930             );
931             unchecked {
932                 _balances[id][from] = fromBalance - amount;
933             }
934             _balances[id][to] += amount;
935         }
936 
937         emit TransferBatch(operator, from, to, ids, amounts);
938 
939         _doSafeBatchTransferAcceptanceCheck(
940             operator,
941             from,
942             to,
943             ids,
944             amounts,
945             data
946         );
947     }
948 
949     /**
950      * @dev Sets a new URI for all token types, by relying on the token type ID
951      * substitution mechanism
952      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
953      *
954      * By this mechanism, any occurrence of the `\{id\}` substring in either the
955      * URI or any of the amounts in the JSON file at said URI will be replaced by
956      * clients with the token type ID.
957      *
958      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
959      * interpreted by clients as
960      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
961      * for token type ID 0x4cce0.
962      *
963      * See {uri}.
964      *
965      * Because these URIs cannot be meaningfully represented by the {URI} event,
966      * this function emits no events.
967      */
968     function _setURI(string memory newuri) internal virtual {
969         _uri = newuri;
970     }
971 
972     /**
973      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
974      *
975      * Emits a {TransferSingle} event.
976      *
977      * Requirements:
978      *
979      * - `account` cannot be the zero address.
980      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
981      * acceptance magic value.
982      */
983     function _mint(
984         address account,
985         uint256 id,
986         uint256 amount,
987         bytes memory data
988     ) internal virtual {
989         require(account != address(0), "ERC1155: mint to the zero address");
990 
991         address operator = _msgSender();
992 
993         _beforeTokenTransfer(
994             operator,
995             address(0),
996             account,
997             _asSingletonArray(id),
998             _asSingletonArray(amount),
999             data
1000         );
1001 
1002         _balances[id][account] += amount;
1003         emit TransferSingle(operator, address(0), account, id, amount);
1004 
1005         _doSafeTransferAcceptanceCheck(
1006             operator,
1007             address(0),
1008             account,
1009             id,
1010             amount,
1011             data
1012         );
1013     }
1014 
1015     /**
1016      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1017      *
1018      * Requirements:
1019      *
1020      * - `ids` and `amounts` must have the same length.
1021      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1022      * acceptance magic value.
1023      */
1024     function _mintBatch(
1025         address to,
1026         uint256[] memory ids,
1027         uint256[] memory amounts,
1028         bytes memory data
1029     ) internal virtual {
1030         require(to != address(0), "ERC1155: mint to the zero address");
1031         require(
1032             ids.length == amounts.length,
1033             "ERC1155: ids and amounts length mismatch"
1034         );
1035 
1036         address operator = _msgSender();
1037 
1038         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1039 
1040         for (uint256 i = 0; i < ids.length; i++) {
1041             _balances[ids[i]][to] += amounts[i];
1042         }
1043 
1044         emit TransferBatch(operator, address(0), to, ids, amounts);
1045 
1046         _doSafeBatchTransferAcceptanceCheck(
1047             operator,
1048             address(0),
1049             to,
1050             ids,
1051             amounts,
1052             data
1053         );
1054     }
1055 
1056     /**
1057      * @dev Destroys `amount` tokens of token type `id` from `account`
1058      *
1059      * Requirements:
1060      *
1061      * - `account` cannot be the zero address.
1062      * - `account` must have at least `amount` tokens of token type `id`.
1063      */
1064     function _burn(
1065         address account,
1066         uint256 id,
1067         uint256 amount
1068     ) internal virtual {
1069         require(account != address(0), "ERC1155: burn from the zero address");
1070 
1071         address operator = _msgSender();
1072 
1073         _beforeTokenTransfer(
1074             operator,
1075             account,
1076             address(0),
1077             _asSingletonArray(id),
1078             _asSingletonArray(amount),
1079             ""
1080         );
1081 
1082         uint256 accountBalance = _balances[id][account];
1083         require(
1084             accountBalance >= amount,
1085             "ERC1155: burn amount exceeds balance"
1086         );
1087         unchecked {
1088             _balances[id][account] = accountBalance - amount;
1089         }
1090 
1091         emit TransferSingle(operator, account, address(0), id, amount);
1092     }
1093 
1094     /**
1095      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1096      *
1097      * Requirements:
1098      *
1099      * - `ids` and `amounts` must have the same length.
1100      */
1101     function _burnBatch(
1102         address account,
1103         uint256[] memory ids,
1104         uint256[] memory amounts
1105     ) internal virtual {
1106         require(account != address(0), "ERC1155: burn from the zero address");
1107         require(
1108             ids.length == amounts.length,
1109             "ERC1155: ids and amounts length mismatch"
1110         );
1111 
1112         address operator = _msgSender();
1113 
1114         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1115 
1116         for (uint256 i = 0; i < ids.length; i++) {
1117             uint256 id = ids[i];
1118             uint256 amount = amounts[i];
1119 
1120             uint256 accountBalance = _balances[id][account];
1121             require(
1122                 accountBalance >= amount,
1123                 "ERC1155: burn amount exceeds balance"
1124             );
1125             unchecked {
1126                 _balances[id][account] = accountBalance - amount;
1127             }
1128         }
1129 
1130         emit TransferBatch(operator, account, address(0), ids, amounts);
1131     }
1132 
1133     /**
1134      * @dev Hook that is called before any token transfer. This includes minting
1135      * and burning, as well as batched variants.
1136      *
1137      * The same hook is called on both single and batched variants. For single
1138      * transfers, the length of the `id` and `amount` arrays will be 1.
1139      *
1140      * Calling conditions (for each `id` and `amount` pair):
1141      *
1142      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1143      * of token type `id` will be  transferred to `to`.
1144      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1145      * for `to`.
1146      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1147      * will be burned.
1148      * - `from` and `to` are never both zero.
1149      * - `ids` and `amounts` have the same, non-zero length.
1150      *
1151      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1152      */
1153     function _beforeTokenTransfer(
1154         address operator,
1155         address from,
1156         address to,
1157         uint256[] memory ids,
1158         uint256[] memory amounts,
1159         bytes memory data
1160     ) internal virtual {}
1161 
1162     function _doSafeTransferAcceptanceCheck(
1163         address operator,
1164         address from,
1165         address to,
1166         uint256 id,
1167         uint256 amount,
1168         bytes memory data
1169     ) private {
1170         if (to.isContract()) {
1171             try
1172                 IERC1155Receiver(to).onERC1155Received(
1173                     operator,
1174                     from,
1175                     id,
1176                     amount,
1177                     data
1178                 )
1179             returns (bytes4 response) {
1180                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1181                     revert("ERC1155: ERC1155Receiver rejected tokens");
1182                 }
1183             } catch Error(string memory reason) {
1184                 revert(reason);
1185             } catch {
1186                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1187             }
1188         }
1189     }
1190 
1191     function _doSafeBatchTransferAcceptanceCheck(
1192         address operator,
1193         address from,
1194         address to,
1195         uint256[] memory ids,
1196         uint256[] memory amounts,
1197         bytes memory data
1198     ) private {
1199         if (to.isContract()) {
1200             try
1201                 IERC1155Receiver(to).onERC1155BatchReceived(
1202                     operator,
1203                     from,
1204                     ids,
1205                     amounts,
1206                     data
1207                 )
1208             returns (bytes4 response) {
1209                 if (
1210                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1211                 ) {
1212                     revert("ERC1155: ERC1155Receiver rejected tokens");
1213                 }
1214             } catch Error(string memory reason) {
1215                 revert(reason);
1216             } catch {
1217                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1218             }
1219         }
1220     }
1221 
1222     function _asSingletonArray(uint256 element)
1223         private
1224         pure
1225         returns (uint256[] memory)
1226     {
1227         uint256[] memory array = new uint256[](1);
1228         array[0] = element;
1229 
1230         return array;
1231     }
1232 }
1233 
1234 /**
1235  * @dev Wrappers over Solidity's arithmetic operations.
1236  *
1237  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1238  * now has built in overflow checking.
1239  */
1240 library SafeMath {
1241     /**
1242      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1243      *
1244      * _Available since v3.4._
1245      */
1246     function tryAdd(uint256 a, uint256 b)
1247         internal
1248         pure
1249         returns (bool, uint256)
1250     {
1251         unchecked {
1252             uint256 c = a + b;
1253             if (c < a) return (false, 0);
1254             return (true, c);
1255         }
1256     }
1257 
1258     /**
1259      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1260      *
1261      * _Available since v3.4._
1262      */
1263     function trySub(uint256 a, uint256 b)
1264         internal
1265         pure
1266         returns (bool, uint256)
1267     {
1268         unchecked {
1269             if (b > a) return (false, 0);
1270             return (true, a - b);
1271         }
1272     }
1273 
1274     /**
1275      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1276      *
1277      * _Available since v3.4._
1278      */
1279     function tryMul(uint256 a, uint256 b)
1280         internal
1281         pure
1282         returns (bool, uint256)
1283     {
1284         unchecked {
1285             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1286             // benefit is lost if 'b' is also tested.
1287             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1288             if (a == 0) return (true, 0);
1289             uint256 c = a * b;
1290             if (c / a != b) return (false, 0);
1291             return (true, c);
1292         }
1293     }
1294 
1295     /**
1296      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1297      *
1298      * _Available since v3.4._
1299      */
1300     function tryDiv(uint256 a, uint256 b)
1301         internal
1302         pure
1303         returns (bool, uint256)
1304     {
1305         unchecked {
1306             if (b == 0) return (false, 0);
1307             return (true, a / b);
1308         }
1309     }
1310 
1311     /**
1312      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1313      *
1314      * _Available since v3.4._
1315      */
1316     function tryMod(uint256 a, uint256 b)
1317         internal
1318         pure
1319         returns (bool, uint256)
1320     {
1321         unchecked {
1322             if (b == 0) return (false, 0);
1323             return (true, a % b);
1324         }
1325     }
1326 
1327     /**
1328      * @dev Returns the addition of two unsigned integers, reverting on
1329      * overflow.
1330      *
1331      * Counterpart to Solidity's `+` operator.
1332      *
1333      * Requirements:
1334      *
1335      * - Addition cannot overflow.
1336      */
1337     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1338         return a + b;
1339     }
1340 
1341     /**
1342      * @dev Returns the subtraction of two unsigned integers, reverting on
1343      * overflow (when the result is negative).
1344      *
1345      * Counterpart to Solidity's `-` operator.
1346      *
1347      * Requirements:
1348      *
1349      * - Subtraction cannot overflow.
1350      */
1351     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1352         return a - b;
1353     }
1354 
1355     /**
1356      * @dev Returns the multiplication of two unsigned integers, reverting on
1357      * overflow.
1358      *
1359      * Counterpart to Solidity's `*` operator.
1360      *
1361      * Requirements:
1362      *
1363      * - Multiplication cannot overflow.
1364      */
1365     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1366         return a * b;
1367     }
1368 
1369     /**
1370      * @dev Returns the integer division of two unsigned integers, reverting on
1371      * division by zero. The result is rounded towards zero.
1372      *
1373      * Counterpart to Solidity's `/` operator.
1374      *
1375      * Requirements:
1376      *
1377      * - The divisor cannot be zero.
1378      */
1379     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1380         return a / b;
1381     }
1382 
1383     /**
1384      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1385      * reverting when dividing by zero.
1386      *
1387      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1388      * opcode (which leaves remaining gas untouched) while Solidity uses an
1389      * invalid opcode to revert (consuming all remaining gas).
1390      *
1391      * Requirements:
1392      *
1393      * - The divisor cannot be zero.
1394      */
1395     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1396         return a % b;
1397     }
1398 
1399     /**
1400      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1401      * overflow (when the result is negative).
1402      *
1403      * CAUTION: This function is deprecated because it requires allocating memory for the error
1404      * message unnecessarily. For custom revert reasons use {trySub}.
1405      *
1406      * Counterpart to Solidity's `-` operator.
1407      *
1408      * Requirements:
1409      *
1410      * - Subtraction cannot overflow.
1411      */
1412     function sub(
1413         uint256 a,
1414         uint256 b,
1415         string memory errorMessage
1416     ) internal pure returns (uint256) {
1417         unchecked {
1418             require(b <= a, errorMessage);
1419             return a - b;
1420         }
1421     }
1422 
1423     /**
1424      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1425      * division by zero. The result is rounded towards zero.
1426      *
1427      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1428      * opcode (which leaves remaining gas untouched) while Solidity uses an
1429      * invalid opcode to revert (consuming all remaining gas).
1430      *
1431      * Counterpart to Solidity's `/` operator. Note: this function uses a
1432      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1433      * uses an invalid opcode to revert (consuming all remaining gas).
1434      *
1435      * Requirements:
1436      *
1437      * - The divisor cannot be zero.
1438      */
1439     function div(
1440         uint256 a,
1441         uint256 b,
1442         string memory errorMessage
1443     ) internal pure returns (uint256) {
1444         unchecked {
1445             require(b > 0, errorMessage);
1446             return a / b;
1447         }
1448     }
1449 
1450     /**
1451      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1452      * reverting with custom message when dividing by zero.
1453      *
1454      * CAUTION: This function is deprecated because it requires allocating memory for the error
1455      * message unnecessarily. For custom revert reasons use {tryMod}.
1456      *
1457      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1458      * opcode (which leaves remaining gas untouched) while Solidity uses an
1459      * invalid opcode to revert (consuming all remaining gas).
1460      *
1461      * Requirements:
1462      *
1463      * - The divisor cannot be zero.
1464      */
1465     function mod(
1466         uint256 a,
1467         uint256 b,
1468         string memory errorMessage
1469     ) internal pure returns (uint256) {
1470         unchecked {
1471             require(b > 0, errorMessage);
1472             return a % b;
1473         }
1474     }
1475 }
1476 
1477 abstract contract ContextMixin {
1478     function msgSender() internal view returns (address payable sender) {
1479         if (msg.sender == address(this)) {
1480             bytes memory array = msg.data;
1481             uint256 index = msg.data.length;
1482             assembly {
1483                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1484                 sender := and(
1485                     mload(add(array, index)),
1486                     0xffffffffffffffffffffffffffffffffffffffff
1487                 )
1488             }
1489         } else {
1490             sender = payable(msg.sender);
1491         }
1492         return sender;
1493     }
1494 }
1495 
1496 contract Initializable {
1497     bool inited = false;
1498 
1499     modifier initializer() {
1500         require(!inited, "already inited");
1501         _;
1502         inited = true;
1503     }
1504 }
1505 
1506 contract EIP712Base is Initializable {
1507     struct EIP712Domain {
1508         string name;
1509         string version;
1510         address verifyingContract;
1511         bytes32 salt;
1512     }
1513 
1514     string public constant ERC712_VERSION = "1";
1515 
1516     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
1517         keccak256(
1518             bytes(
1519                 "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1520             )
1521         );
1522     bytes32 internal domainSeperator;
1523 
1524     // supposed to be called once while initializing.
1525     // one of the contracts that inherits this contract follows proxy pattern
1526     // so it is not possible to do this in a constructor
1527     function _initializeEIP712(string memory name) internal initializer {
1528         _setDomainSeperator(name);
1529     }
1530 
1531     function _setDomainSeperator(string memory name) internal {
1532         domainSeperator = keccak256(
1533             abi.encode(
1534                 EIP712_DOMAIN_TYPEHASH,
1535                 keccak256(bytes(name)),
1536                 keccak256(bytes(ERC712_VERSION)),
1537                 address(this),
1538                 bytes32(getChainId())
1539             )
1540         );
1541     }
1542 
1543     function getDomainSeperator() public view returns (bytes32) {
1544         return domainSeperator;
1545     }
1546 
1547     function getChainId() public view returns (uint256) {
1548         uint256 id;
1549         assembly {
1550             id := chainid()
1551         }
1552         return id;
1553     }
1554 
1555     /**
1556      * Accept message hash and returns hash message in EIP712 compatible form
1557      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1558      * https://eips.ethereum.org/EIPS/eip-712
1559      * "\\x19" makes the encoding deterministic
1560      * "\\x01" is the version byte to make it compatible to EIP-191
1561      */
1562     function toTypedMessageHash(bytes32 messageHash)
1563         internal
1564         view
1565         returns (bytes32)
1566     {
1567         return
1568             keccak256(
1569                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1570             );
1571     }
1572 }
1573 
1574 contract NativeMetaTransaction is EIP712Base {
1575     using SafeMath for uint256;
1576     bytes32 private constant META_TRANSACTION_TYPEHASH =
1577         keccak256(
1578             bytes(
1579                 "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1580             )
1581         );
1582     event MetaTransactionExecuted(
1583         address userAddress,
1584         address payable relayerAddress,
1585         bytes functionSignature
1586     );
1587     mapping(address => uint256) nonces;
1588 
1589     /*
1590      * Meta transaction structure.
1591      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1592      * He should call the desired function directly in that case.
1593      */
1594     struct MetaTransaction {
1595         uint256 nonce;
1596         address from;
1597         bytes functionSignature;
1598     }
1599 
1600     function executeMetaTransaction(
1601         address userAddress,
1602         bytes memory functionSignature,
1603         bytes32 sigR,
1604         bytes32 sigS,
1605         uint8 sigV
1606     ) public payable returns (bytes memory) {
1607         MetaTransaction memory metaTx = MetaTransaction({
1608             nonce: nonces[userAddress],
1609             from: userAddress,
1610             functionSignature: functionSignature
1611         });
1612 
1613         require(
1614             verify(userAddress, metaTx, sigR, sigS, sigV),
1615             "Signer and signature do not match"
1616         );
1617 
1618         // increase nonce for user (to avoid re-use)
1619         nonces[userAddress] = nonces[userAddress].add(1);
1620 
1621         emit MetaTransactionExecuted(
1622             userAddress,
1623             payable(msg.sender),
1624             functionSignature
1625         );
1626 
1627         // Append userAddress and relayer address at the end to extract it from calling context
1628         (bool success, bytes memory returnData) = address(this).call(
1629             abi.encodePacked(functionSignature, userAddress)
1630         );
1631         require(success, "Function call not successful");
1632 
1633         return returnData;
1634     }
1635 
1636     function hashMetaTransaction(MetaTransaction memory metaTx)
1637         internal
1638         pure
1639         returns (bytes32)
1640     {
1641         return
1642             keccak256(
1643                 abi.encode(
1644                     META_TRANSACTION_TYPEHASH,
1645                     metaTx.nonce,
1646                     metaTx.from,
1647                     keccak256(metaTx.functionSignature)
1648                 )
1649             );
1650     }
1651 
1652     function getNonce(address user) public view returns (uint256 nonce) {
1653         nonce = nonces[user];
1654     }
1655 
1656     function verify(
1657         address signer,
1658         MetaTransaction memory metaTx,
1659         bytes32 sigR,
1660         bytes32 sigS,
1661         uint8 sigV
1662     ) internal view returns (bool) {
1663         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1664         return
1665             signer ==
1666             ecrecover(
1667                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1668                 sigV,
1669                 sigR,
1670                 sigS
1671             );
1672     }
1673 }
1674 
1675 contract OwnableDelegateProxy {}
1676 
1677 contract ProxyRegistry {
1678     mapping(address => OwnableDelegateProxy) public proxies;
1679 }
1680 
1681 /**
1682  * @title ERC1155Tradable
1683  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, has create and mint functionality, and supports useful standards from OpenZeppelin, like _exists(), name(), symbol(), and totalSupply()
1684  */
1685 contract ERC1155Tradable is
1686     ContextMixin,
1687     ERC1155,
1688     NativeMetaTransaction,
1689     Ownable
1690 {
1691     using Strings for string;
1692     using SafeMath for uint256;
1693 
1694     address proxyRegistryAddress;
1695     mapping(uint256 => address) public creators;
1696     mapping(uint256 => uint256) public tokenSupply;
1697     mapping(uint256 => string) customUri;
1698     // Contract name
1699     string public name;
1700     // Contract symbol
1701     string public symbol;
1702 
1703     /**
1704      * @dev Require _msgSender() to be the creator of the token id
1705      */
1706     modifier creatorOnly(uint256 _id) {
1707         require(
1708             creators[_id] == _msgSender(),
1709             "ERC1155Tradable#creatorOnly: ONLY_CREATOR_ALLOWED"
1710         );
1711         _;
1712     }
1713 
1714     /**
1715      * @dev Require _msgSender() to own more than 0 of the token id
1716      */
1717     modifier ownersOnly(uint256 _id) {
1718         require(
1719             balanceOf(_msgSender(), _id) > 0,
1720             "ERC1155Tradable#ownersOnly: ONLY_OWNERS_ALLOWED"
1721         );
1722         _;
1723     }
1724 
1725     constructor(
1726         string memory _name,
1727         string memory _symbol,
1728         string memory _uri,
1729         address _proxyRegistryAddress
1730     ) ERC1155(_uri) {
1731         name = _name;
1732         symbol = _symbol;
1733         proxyRegistryAddress = _proxyRegistryAddress;
1734         _initializeEIP712(name);
1735     }
1736 
1737     function uri(uint256 _id) public view override returns (string memory) {
1738         require(_exists(_id), "ERC1155Tradable#uri: NONEXISTENT_TOKEN");
1739         // We have to convert string to bytes to check for existence
1740         bytes memory customUriBytes = bytes(customUri[_id]);
1741         if (customUriBytes.length > 0) {
1742             return customUri[_id];
1743         } else {
1744             return super.uri(_id);
1745         }
1746     }
1747 
1748     /**
1749      * @dev Returns the total quantity for a token ID
1750      * @param _id uint256 ID of the token to query
1751      * @return amount of token in existence
1752      */
1753     function totalSupply(uint256 _id) public view returns (uint256) {
1754         return tokenSupply[_id];
1755     }
1756 
1757     /**
1758      * @dev Sets a new URI for all token types, by relying on the token type ID
1759      * substitution mechanism
1760      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1761      * @param _newURI New URI for all tokens
1762      */
1763     function setURI(string memory _newURI) public onlyOwner {
1764         _setURI(_newURI);
1765     }
1766 
1767     /**
1768      * @dev Will update the base URI for the token
1769      * @param _tokenId The token to update. _msgSender() must be its creator.
1770      * @param _newURI New URI for the token.
1771      */
1772     function setCustomURI(uint256 _tokenId, string memory _newURI)
1773         public
1774         creatorOnly(_tokenId)
1775     {
1776         customUri[_tokenId] = _newURI;
1777         emit URI(_newURI, _tokenId);
1778     }
1779 
1780     /**
1781      * @dev Creates a new token type and assigns _initialSupply to an address
1782      * NOTE: remove onlyOwner if you want third parties to create new tokens on
1783      *       your contract (which may change your IDs)
1784      * NOTE: The token id must be passed. This allows lazy creation of tokens or
1785      *       creating NFTs by setting the id's high bits with the method
1786      *       described in ERC1155 or to use ids representing values other than
1787      *       successive small integers. If you wish to create ids as successive
1788      *       small integers you can either subclass this class to count onchain
1789      *       or maintain the offchain cache of identifiers recommended in
1790      *       ERC1155 and calculate successive ids from that.
1791      * @param _initialOwner address of the first owner of the token
1792      * @param _id The id of the token to create (must not currenty exist).
1793      * @param _initialSupply amount to supply the first owner
1794      * @param _uri Optional URI for this token type
1795      * @param _data Data to pass if receiver is contract
1796      * @return The newly created token ID
1797      */
1798     function create(
1799         address _initialOwner,
1800         uint256 _id,
1801         uint256 _initialSupply,
1802         string memory _uri,
1803         bytes memory _data
1804     ) public onlyOwner returns (uint256) {
1805         require(!_exists(_id), "token _id already exists");
1806         creators[_id] = _msgSender();
1807 
1808         if (bytes(_uri).length > 0) {
1809             customUri[_id] = _uri;
1810             emit URI(_uri, _id);
1811         }
1812 
1813         _mint(_initialOwner, _id, _initialSupply, _data);
1814 
1815         tokenSupply[_id] = _initialSupply;
1816         return _id;
1817     }
1818 
1819     /**
1820      * @dev Mints some amount of tokens to an address
1821      * @param _to          Address of the future owner of the token
1822      * @param _id          Token ID to mint
1823      * @param _quantity    Amount of tokens to mint
1824      * @param _data        Data to pass if receiver is contract
1825      */
1826     function mint(
1827         address _to,
1828         uint256 _id,
1829         uint256 _quantity,
1830         bytes memory _data
1831     ) public virtual creatorOnly(_id) {
1832         _mint(_to, _id, _quantity, _data);
1833         tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1834     }
1835 
1836     /**
1837      * @dev Mint tokens for each id in _ids
1838      * @param _to          The address to mint tokens to
1839      * @param _ids         Array of ids to mint
1840      * @param _quantities  Array of amounts of tokens to mint per id
1841      * @param _data        Data to pass if receiver is contract
1842      */
1843     function batchMint(
1844         address _to,
1845         uint256[] memory _ids,
1846         uint256[] memory _quantities,
1847         bytes memory _data
1848     ) public {
1849         for (uint256 i = 0; i < _ids.length; i++) {
1850             uint256 _id = _ids[i];
1851             require(
1852                 creators[_id] == _msgSender(),
1853                 "ERC1155Tradable#batchMint: ONLY_CREATOR_ALLOWED"
1854             );
1855             uint256 quantity = _quantities[i];
1856             tokenSupply[_id] = tokenSupply[_id].add(quantity);
1857         }
1858         _mintBatch(_to, _ids, _quantities, _data);
1859     }
1860 
1861     /**
1862      * @dev Change the creator address for given tokens
1863      * @param _to   Address of the new creator
1864      * @param _ids  Array of Token IDs to change creator
1865      */
1866     function setCreator(address _to, uint256[] memory _ids) public {
1867         require(
1868             _to != address(0),
1869             "ERC1155Tradable#setCreator: INVALID_ADDRESS."
1870         );
1871         for (uint256 i = 0; i < _ids.length; i++) {
1872             uint256 id = _ids[i];
1873             _setCreator(_to, id);
1874         }
1875     }
1876 
1877     /**
1878      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1879      */
1880     function isApprovedForAll(address _owner, address _operator)
1881         public
1882         view
1883         override
1884         returns (bool isOperator)
1885     {
1886         // Whitelist OpenSea proxy contract for easy trading.
1887         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1888         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1889             return true;
1890         }
1891 
1892         return ERC1155.isApprovedForAll(_owner, _operator);
1893     }
1894 
1895     /**
1896      * @dev Change the creator address for given token
1897      * @param _to   Address of the new creator
1898      * @param _id  Token IDs to change creator of
1899      */
1900     function _setCreator(address _to, uint256 _id) internal creatorOnly(_id) {
1901         creators[_id] = _to;
1902     }
1903 
1904     /**
1905      * @dev Returns whether the specified token exists by checking to see if it has a creator
1906      * @param _id uint256 ID of the token to query the existence of
1907      * @return bool whether the token exists
1908      */
1909     function _exists(uint256 _id) internal view returns (bool) {
1910         return creators[_id] != address(0);
1911     }
1912 
1913     function exists(uint256 _id) external view returns (bool) {
1914         return _exists(_id);
1915     }
1916 
1917     /**
1918      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1919      */
1920     function _msgSender() internal view override returns (address sender) {
1921         return ContextMixin.msgSender();
1922     }
1923 }
1924 
1925 contract TrippyLoot is ERC1155Tradable {
1926     using SafeMath for uint256;
1927 
1928     constructor()
1929         ERC1155Tradable(
1930             "Paradise Trippies Treasure Chests",
1931             "TRIPPYLOOT",
1932             "",
1933             0xa5409ec958C83C3f309868babACA7c86DCB077c1
1934         )
1935     {
1936         create(msg.sender, 1, 1, "https://paradise.mypinata.cloud/ipfs/Qmc3C75PzKuX31B9xQ2cqoFG4JcC2nUb2QtyqFK9Vh8E7d/1.json", "");
1937         create(msg.sender, 2, 1, "https://paradise.mypinata.cloud/ipfs/Qmc3C75PzKuX31B9xQ2cqoFG4JcC2nUb2QtyqFK9Vh8E7d/2.json", "");
1938         create(msg.sender, 3, 1, "https://paradise.mypinata.cloud/ipfs/Qmc3C75PzKuX31B9xQ2cqoFG4JcC2nUb2QtyqFK9Vh8E7d/3.json", "");
1939     }
1940 
1941     function airdrop(
1942         address[] memory _addrs,
1943         uint256 _quantity,
1944         uint256 _id
1945     ) public onlyOwner {
1946         for (uint256 i = 0; i < _addrs.length; i++) {
1947             _mint(_addrs[i], _id, _quantity, "");
1948             tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1949         }
1950     }
1951 }