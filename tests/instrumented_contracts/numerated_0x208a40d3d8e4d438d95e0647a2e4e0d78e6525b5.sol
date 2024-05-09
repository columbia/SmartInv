1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
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
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 // File: Context.sol
67 
68 
69 
70 pragma solidity ^0.8.0;
71 
72 /*
73  * @dev Provides information about the current execution context, including the
74  * sender of the transaction and its data. While these are generally available
75  * via msg.sender and msg.data, they should not be accessed in such a direct
76  * manner, since when dealing with meta-transactions the account sending and
77  * paying for execution may not be the actual sender (as far as an application
78  * is concerned).
79  *
80  * This contract is only required for intermediate, library-like contracts.
81  */
82 abstract contract Context {
83     function _msgSender() internal view virtual returns (address) {
84         return msg.sender;
85     }
86 
87     function _msgData() internal view virtual returns (bytes calldata) {
88         return msg.data;
89     }
90 }
91 // File: Ownable.sol
92 
93 
94 
95 pragma solidity ^0.8.0;
96 
97 
98 /**
99  * @dev Contract module which provides a basic access control mechanism, where
100  * there is an account (an owner) that can be granted exclusive access to
101  * specific functions.
102  *
103  * By default, the owner account will be the one that deploys the contract. This
104  * can later be changed with {transferOwnership}.
105  *
106  * This module is used through inheritance. It will make available the modifier
107  * `onlyOwner`, which can be applied to your functions to restrict their use to
108  * the owner.
109  */
110 abstract contract Ownable is Context {
111     address private _owner;
112 
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
153         require(newOwner != address(0), "Ownable: new owner is the zero address");
154         _setOwner(newOwner);
155     }
156 
157     function _setOwner(address newOwner) private {
158         address oldOwner = _owner;
159         _owner = newOwner;
160         emit OwnershipTransferred(oldOwner, newOwner);
161     }
162 }
163 // File: Address.sol
164 
165 
166 
167 pragma solidity ^0.8.0;
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
219         require(address(this).balance >= amount, "Address: insufficient balance");
220 
221         (bool success, ) = recipient.call{value: amount}("");
222         require(success, "Address: unable to send value, recipient may have reverted");
223     }
224 
225     /**
226      * @dev Performs a Solidity function call using a low level `call`. A
227      * plain `call` is an unsafe replacement for a function call: use this
228      * function instead.
229      *
230      * If `target` reverts with a revert reason, it is bubbled up by this
231      * function (like regular Solidity function calls).
232      *
233      * Returns the raw returned data. To convert to the expected return value,
234      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
235      *
236      * Requirements:
237      *
238      * - `target` must be a contract.
239      * - calling `target` with `data` must not revert.
240      *
241      * _Available since v3.1._
242      */
243     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
244         return functionCall(target, data, "Address: low-level call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
249      * `errorMessage` as a fallback revert reason when `target` reverts.
250      *
251      * _Available since v3.1._
252      */
253     function functionCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         return functionCallWithValue(target, data, 0, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but also transferring `value` wei to `target`.
264      *
265      * Requirements:
266      *
267      * - the calling contract must have an ETH balance of at least `value`.
268      * - the called Solidity function must be `payable`.
269      *
270      * _Available since v3.1._
271      */
272     function functionCallWithValue(
273         address target,
274         bytes memory data,
275         uint256 value
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
282      * with `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(
287         address target,
288         bytes memory data,
289         uint256 value,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         require(address(this).balance >= value, "Address: insufficient balance for call");
293         require(isContract(target), "Address: call to non-contract");
294 
295         (bool success, bytes memory returndata) = target.call{value: value}(data);
296         return _verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
301      * but performing a static call.
302      *
303      * _Available since v3.3._
304      */
305     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
306         return functionStaticCall(target, data, "Address: low-level static call failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
311      * but performing a static call.
312      *
313      * _Available since v3.3._
314      */
315     function functionStaticCall(
316         address target,
317         bytes memory data,
318         string memory errorMessage
319     ) internal view returns (bytes memory) {
320         require(isContract(target), "Address: static call to non-contract");
321 
322         (bool success, bytes memory returndata) = target.staticcall(data);
323         return _verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but performing a delegate call.
329      *
330      * _Available since v3.4._
331      */
332     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
333         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
338      * but performing a delegate call.
339      *
340      * _Available since v3.4._
341      */
342     function functionDelegateCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         require(isContract(target), "Address: delegate call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.delegatecall(data);
350         return _verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     function _verifyCallResult(
354         bool success,
355         bytes memory returndata,
356         string memory errorMessage
357     ) private pure returns (bytes memory) {
358         if (success) {
359             return returndata;
360         } else {
361             // Look for revert reason and bubble it up if present
362             if (returndata.length > 0) {
363                 // The easiest way to bubble the revert reason is using memory via assembly
364 
365                 assembly {
366                     let returndata_size := mload(returndata)
367                     revert(add(32, returndata), returndata_size)
368                 }
369             } else {
370                 revert(errorMessage);
371             }
372         }
373     }
374 }
375 // File: IERC721Receiver.sol
376 
377 
378 
379 pragma solidity ^0.8.0;
380 
381 /**
382  * @title ERC721 token receiver interface
383  * @dev Interface for any contract that wants to support safeTransfers
384  * from ERC721 asset contracts.
385  */
386 interface IERC721Receiver {
387     /**
388      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
389      * by `operator` from `from`, this function is called.
390      *
391      * It must return its Solidity selector to confirm the token transfer.
392      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
393      *
394      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
395      */
396     function onERC721Received(
397         address operator,
398         address from,
399         uint256 tokenId,
400         bytes calldata data
401     ) external returns (bytes4);
402 }
403 // File: IERC165.sol
404 
405 
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Interface of the ERC165 standard, as defined in the
411  * https://eips.ethereum.org/EIPS/eip-165[EIP].
412  *
413  * Implementers can declare support of contract interfaces, which can then be
414  * queried by others ({ERC165Checker}).
415  *
416  * For an implementation, see {ERC165}.
417  */
418 interface IERC165 {
419     /**
420      * @dev Returns true if this contract implements the interface defined by
421      * `interfaceId`. See the corresponding
422      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
423      * to learn more about how these ids are created.
424      *
425      * This function call must use less than 30 000 gas.
426      */
427     function supportsInterface(bytes4 interfaceId) external view returns (bool);
428 }
429 // File: IERC1155Receiver.sol
430 
431 
432 
433 pragma solidity ^0.8.0;
434 
435 
436 /**
437  * @dev _Available since v3.1._
438  */
439 interface IERC1155Receiver is IERC165 {
440     /**
441         @dev Handles the receipt of a single ERC1155 token type. This function is
442         called at the end of a `safeTransferFrom` after the balance has been updated.
443         To accept the transfer, this must return
444         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
445         (i.e. 0xf23a6e61, or its own function selector).
446         @param operator The address which initiated the transfer (i.e. msg.sender)
447         @param from The address which previously owned the token
448         @param id The ID of the token being transferred
449         @param value The amount of tokens being transferred
450         @param data Additional data with no specified format
451         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
452     */
453     function onERC1155Received(
454         address operator,
455         address from,
456         uint256 id,
457         uint256 value,
458         bytes calldata data
459     ) external returns (bytes4);
460 
461     /**
462         @dev Handles the receipt of a multiple ERC1155 token types. This function
463         is called at the end of a `safeBatchTransferFrom` after the balances have
464         been updated. To accept the transfer(s), this must return
465         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
466         (i.e. 0xbc197c81, or its own function selector).
467         @param operator The address which initiated the batch transfer (i.e. msg.sender)
468         @param from The address which previously owned the token
469         @param ids An array containing ids of each token being transferred (order and length must match values array)
470         @param values An array containing amounts of each token being transferred (order and length must match ids array)
471         @param data Additional data with no specified format
472         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
473     */
474     function onERC1155BatchReceived(
475         address operator,
476         address from,
477         uint256[] calldata ids,
478         uint256[] calldata values,
479         bytes calldata data
480     ) external returns (bytes4);
481 }
482 // File: IERC1155.sol
483 
484 
485 
486 pragma solidity ^0.8.0;
487 
488 
489 /**
490  * @dev Required interface of an ERC1155 compliant contract, as defined in the
491  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
492  *
493  * _Available since v3.1._
494  */
495 interface IERC1155 is IERC165 {
496     /**
497      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
498      */
499     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
500 
501     /**
502      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
503      * transfers.
504      */
505     event TransferBatch(
506         address indexed operator,
507         address indexed from,
508         address indexed to,
509         uint256[] ids,
510         uint256[] values
511     );
512 
513     /**
514      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
515      * `approved`.
516      */
517     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
518 
519     /**
520      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
521      *
522      * If an {URI} event was emitted for `id`, the standard
523      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
524      * returned by {IERC1155MetadataURI-uri}.
525      */
526     event URI(string value, uint256 indexed id);
527 
528     /**
529      * @dev Returns the amount of tokens of token type `id` owned by `account`.
530      *
531      * Requirements:
532      *
533      * - `account` cannot be the zero address.
534      */
535     function balanceOf(address account, uint256 id) external view returns (uint256);
536 
537     /**
538      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
539      *
540      * Requirements:
541      *
542      * - `accounts` and `ids` must have the same length.
543      */
544     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
545         external
546         view
547         returns (uint256[] memory);
548 
549     /**
550      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
551      *
552      * Emits an {ApprovalForAll} event.
553      *
554      * Requirements:
555      *
556      * - `operator` cannot be the caller.
557      */
558     function setApprovalForAll(address operator, bool approved) external;
559 
560     /**
561      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
562      *
563      * See {setApprovalForAll}.
564      */
565     function isApprovedForAll(address account, address operator) external view returns (bool);
566 
567     /**
568      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
569      *
570      * Emits a {TransferSingle} event.
571      *
572      * Requirements:
573      *
574      * - `to` cannot be the zero address.
575      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
576      * - `from` must have a balance of tokens of type `id` of at least `amount`.
577      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
578      * acceptance magic value.
579      */
580     function safeTransferFrom(
581         address from,
582         address to,
583         uint256 id,
584         uint256 amount,
585         bytes calldata data
586     ) external;
587 
588     /**
589      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
590      *
591      * Emits a {TransferBatch} event.
592      *
593      * Requirements:
594      *
595      * - `ids` and `amounts` must have the same length.
596      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
597      * acceptance magic value.
598      */
599     function safeBatchTransferFrom(
600         address from,
601         address to,
602         uint256[] calldata ids,
603         uint256[] calldata amounts,
604         bytes calldata data
605     ) external;
606 }
607 // File: IERC1155MetadataURI.sol
608 
609 
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
629 // File: ERC165.sol
630 
631 
632 
633 pragma solidity ^0.8.0;
634 
635 
636 /**
637  * @dev Implementation of the {IERC165} interface.
638  *
639  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
640  * for the additional interface id that will be supported. For example:
641  *
642  * ```solidity
643  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
644  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
645  * }
646  * ```
647  *
648  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
649  */
650 abstract contract ERC165 is IERC165 {
651     /**
652      * @dev See {IERC165-supportsInterface}.
653      */
654     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
655         return interfaceId == type(IERC165).interfaceId;
656     }
657 }
658 // File: ERC1155.sol
659 
660 
661 
662 pragma solidity ^0.8.0;
663 
664 
665 
666 
667 
668 
669 
670 /**
671  * @dev Implementation of the basic standard multi-token.
672  * See https://eips.ethereum.org/EIPS/eip-1155
673  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
674  *
675  * _Available since v3.1._
676  */
677 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
678     using Address for address;
679 
680     // Mapping from token ID to account balances
681     mapping(uint256 => mapping(address => uint256)) private _balances;
682 
683     // Mapping from account to operator approvals
684     mapping(address => mapping(address => bool)) private _operatorApprovals;
685 
686     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
687     string private _uri;
688 
689     /**
690      * @dev See {_setURI}.
691      */
692     constructor(string memory uri_) {
693         _setURI(uri_);
694     }
695 
696     /**
697      * @dev See {IERC165-supportsInterface}.
698      */
699     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
700         return
701             interfaceId == type(IERC1155).interfaceId ||
702             interfaceId == type(IERC1155MetadataURI).interfaceId ||
703             super.supportsInterface(interfaceId);
704     }
705 
706     /**
707      * @dev See {IERC1155MetadataURI-uri}.
708      *
709      * This implementation returns the same URI for *all* token types. It relies
710      * on the token type ID substitution mechanism
711      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
712      *
713      * Clients calling this function must replace the `\{id\}` substring with the
714      * actual token type ID.
715      */
716     function uri(uint256) public view virtual override returns (string memory) {
717         return _uri;
718     }
719 
720     /**
721      * @dev See {IERC1155-balanceOf}.
722      *
723      * Requirements:
724      *
725      * - `account` cannot be the zero address.
726      */
727     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
728         require(account != address(0), "ERC1155: balance query for the zero address");
729         return _balances[id][account];
730     }
731 
732     /**
733      * @dev See {IERC1155-balanceOfBatch}.
734      *
735      * Requirements:
736      *
737      * - `accounts` and `ids` must have the same length.
738      */
739     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
740         public
741         view
742         virtual
743         override
744         returns (uint256[] memory)
745     {
746         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
747 
748         uint256[] memory batchBalances = new uint256[](accounts.length);
749 
750         for (uint256 i = 0; i < accounts.length; ++i) {
751             batchBalances[i] = balanceOf(accounts[i], ids[i]);
752         }
753 
754         return batchBalances;
755     }
756 
757     /**
758      * @dev See {IERC1155-setApprovalForAll}.
759      */
760     function setApprovalForAll(address operator, bool approved) public virtual override {
761         require(_msgSender() != operator, "ERC1155: setting approval status for self");
762 
763         _operatorApprovals[_msgSender()][operator] = approved;
764         emit ApprovalForAll(_msgSender(), operator, approved);
765     }
766 
767     /**
768      * @dev See {IERC1155-isApprovedForAll}.
769      */
770     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
771         return _operatorApprovals[account][operator];
772     }
773 
774     /**
775      * @dev See {IERC1155-safeTransferFrom}.
776      */
777     function safeTransferFrom(
778         address from,
779         address to,
780         uint256 id,
781         uint256 amount,
782         bytes memory data
783     ) public virtual override {
784         require(
785             from == _msgSender() || isApprovedForAll(from, _msgSender()),
786             "ERC1155: caller is not owner nor approved"
787         );
788         _safeTransferFrom(from, to, id, amount, data);
789     }
790 
791     /**
792      * @dev See {IERC1155-safeBatchTransferFrom}.
793      */
794     function safeBatchTransferFrom(
795         address from,
796         address to,
797         uint256[] memory ids,
798         uint256[] memory amounts,
799         bytes memory data
800     ) public virtual override {
801         require(
802             from == _msgSender() || isApprovedForAll(from, _msgSender()),
803             "ERC1155: transfer caller is not owner nor approved"
804         );
805         _safeBatchTransferFrom(from, to, ids, amounts, data);
806     }
807 
808     /**
809      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
810      *
811      * Emits a {TransferSingle} event.
812      *
813      * Requirements:
814      *
815      * - `to` cannot be the zero address.
816      * - `from` must have a balance of tokens of type `id` of at least `amount`.
817      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
818      * acceptance magic value.
819      */
820     function _safeTransferFrom(
821         address from,
822         address to,
823         uint256 id,
824         uint256 amount,
825         bytes memory data
826     ) internal virtual {
827         require(to != address(0), "ERC1155: transfer to the zero address");
828 
829         address operator = _msgSender();
830 
831         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
832 
833         uint256 fromBalance = _balances[id][from];
834         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
835         unchecked {
836             _balances[id][from] = fromBalance - amount;
837         }
838         _balances[id][to] += amount;
839 
840         emit TransferSingle(operator, from, to, id, amount);
841 
842         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
843     }
844 
845     /**
846      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
847      *
848      * Emits a {TransferBatch} event.
849      *
850      * Requirements:
851      *
852      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
853      * acceptance magic value.
854      */
855     function _safeBatchTransferFrom(
856         address from,
857         address to,
858         uint256[] memory ids,
859         uint256[] memory amounts,
860         bytes memory data
861     ) internal virtual {
862         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
863         require(to != address(0), "ERC1155: transfer to the zero address");
864 
865         address operator = _msgSender();
866 
867         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
868 
869         for (uint256 i = 0; i < ids.length; ++i) {
870             uint256 id = ids[i];
871             uint256 amount = amounts[i];
872 
873             uint256 fromBalance = _balances[id][from];
874             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
875             unchecked {
876                 _balances[id][from] = fromBalance - amount;
877             }
878             _balances[id][to] += amount;
879         }
880 
881         emit TransferBatch(operator, from, to, ids, amounts);
882 
883         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
884     }
885 
886     /**
887      * @dev Sets a new URI for all token types, by relying on the token type ID
888      * substitution mechanism
889      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
890      *
891      * By this mechanism, any occurrence of the `\{id\}` substring in either the
892      * URI or any of the amounts in the JSON file at said URI will be replaced by
893      * clients with the token type ID.
894      *
895      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
896      * interpreted by clients as
897      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
898      * for token type ID 0x4cce0.
899      *
900      * See {uri}.
901      *
902      * Because these URIs cannot be meaningfully represented by the {URI} event,
903      * this function emits no events.
904      */
905     function _setURI(string memory newuri) internal virtual {
906         _uri = newuri;
907     }
908 
909     /**
910      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
911      *
912      * Emits a {TransferSingle} event.
913      *
914      * Requirements:
915      *
916      * - `account` cannot be the zero address.
917      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
918      * acceptance magic value.
919      */
920     function _mint(
921         address account,
922         uint256 id,
923         uint256 amount,
924         bytes memory data
925     ) internal virtual {
926         require(account != address(0), "ERC1155: mint to the zero address");
927 
928         address operator = _msgSender();
929 
930         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
931 
932         _balances[id][account] += amount;
933         emit TransferSingle(operator, address(0), account, id, amount);
934 
935         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
936     }
937 
938     /**
939      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
940      *
941      * Requirements:
942      *
943      * - `ids` and `amounts` must have the same length.
944      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
945      * acceptance magic value.
946      */
947     function _mintBatch(
948         address to,
949         uint256[] memory ids,
950         uint256[] memory amounts,
951         bytes memory data
952     ) internal virtual {
953         require(to != address(0), "ERC1155: mint to the zero address");
954         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
955 
956         address operator = _msgSender();
957 
958         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
959 
960         for (uint256 i = 0; i < ids.length; i++) {
961             _balances[ids[i]][to] += amounts[i];
962         }
963 
964         emit TransferBatch(operator, address(0), to, ids, amounts);
965 
966         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
967     }
968 
969     /**
970      * @dev Destroys `amount` tokens of token type `id` from `account`
971      *
972      * Requirements:
973      *
974      * - `account` cannot be the zero address.
975      * - `account` must have at least `amount` tokens of token type `id`.
976      */
977     function _burn(
978         address account,
979         uint256 id,
980         uint256 amount
981     ) internal virtual {
982         require(account != address(0), "ERC1155: burn from the zero address");
983 
984         address operator = _msgSender();
985 
986         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
987 
988         uint256 accountBalance = _balances[id][account];
989         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
990         unchecked {
991             _balances[id][account] = accountBalance - amount;
992         }
993 
994         emit TransferSingle(operator, account, address(0), id, amount);
995     }
996 
997     /**
998      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
999      *
1000      * Requirements:
1001      *
1002      * - `ids` and `amounts` must have the same length.
1003      */
1004     function _burnBatch(
1005         address account,
1006         uint256[] memory ids,
1007         uint256[] memory amounts
1008     ) internal virtual {
1009         require(account != address(0), "ERC1155: burn from the zero address");
1010         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1011 
1012         address operator = _msgSender();
1013 
1014         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1015 
1016         for (uint256 i = 0; i < ids.length; i++) {
1017             uint256 id = ids[i];
1018             uint256 amount = amounts[i];
1019 
1020             uint256 accountBalance = _balances[id][account];
1021             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1022             unchecked {
1023                 _balances[id][account] = accountBalance - amount;
1024             }
1025         }
1026 
1027         emit TransferBatch(operator, account, address(0), ids, amounts);
1028     }
1029 
1030     /**
1031      * @dev Hook that is called before any token transfer. This includes minting
1032      * and burning, as well as batched variants.
1033      *
1034      * The same hook is called on both single and batched variants. For single
1035      * transfers, the length of the `id` and `amount` arrays will be 1.
1036      *
1037      * Calling conditions (for each `id` and `amount` pair):
1038      *
1039      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1040      * of token type `id` will be  transferred to `to`.
1041      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1042      * for `to`.
1043      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1044      * will be burned.
1045      * - `from` and `to` are never both zero.
1046      * - `ids` and `amounts` have the same, non-zero length.
1047      *
1048      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1049      */
1050     function _beforeTokenTransfer(
1051         address operator,
1052         address from,
1053         address to,
1054         uint256[] memory ids,
1055         uint256[] memory amounts,
1056         bytes memory data
1057     ) internal virtual {}
1058 
1059     function _doSafeTransferAcceptanceCheck(
1060         address operator,
1061         address from,
1062         address to,
1063         uint256 id,
1064         uint256 amount,
1065         bytes memory data
1066     ) private {
1067         if (to.isContract()) {
1068             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1069                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1070                     revert("ERC1155: ERC1155Receiver rejected tokens");
1071                 }
1072             } catch Error(string memory reason) {
1073                 revert(reason);
1074             } catch {
1075                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1076             }
1077         }
1078     }
1079 
1080     function _doSafeBatchTransferAcceptanceCheck(
1081         address operator,
1082         address from,
1083         address to,
1084         uint256[] memory ids,
1085         uint256[] memory amounts,
1086         bytes memory data
1087     ) private {
1088         if (to.isContract()) {
1089             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1090                 bytes4 response
1091             ) {
1092                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1093                     revert("ERC1155: ERC1155Receiver rejected tokens");
1094                 }
1095             } catch Error(string memory reason) {
1096                 revert(reason);
1097             } catch {
1098                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1099             }
1100         }
1101     }
1102 
1103     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1104         uint256[] memory array = new uint256[](1);
1105         array[0] = element;
1106 
1107         return array;
1108     }
1109 }
1110 // File: IERC721.sol
1111 
1112 
1113 
1114 pragma solidity ^0.8.0;
1115 
1116 
1117 /**
1118  * @dev Required interface of an ERC721 compliant contract.
1119  */
1120 interface IERC721 is IERC165 {
1121     /**
1122      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1123      */
1124     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1125 
1126     /**
1127      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1128      */
1129     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1130 
1131     /**
1132      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1133      */
1134     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1135 
1136     /**
1137      * @dev Returns the number of tokens in ``owner``'s account.
1138      */
1139     function balanceOf(address owner) external view returns (uint256 balance);
1140 
1141     /**
1142      * @dev Returns the owner of the `tokenId` token.
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must exist.
1147      */
1148     function ownerOf(uint256 tokenId) external view returns (address owner);
1149 
1150     /**
1151      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1152      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1153      *
1154      * Requirements:
1155      *
1156      * - `from` cannot be the zero address.
1157      * - `to` cannot be the zero address.
1158      * - `tokenId` token must exist and be owned by `from`.
1159      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function safeTransferFrom(
1165         address from,
1166         address to,
1167         uint256 tokenId
1168     ) external;
1169 
1170     /**
1171      * @dev Transfers `tokenId` token from `from` to `to`.
1172      *
1173      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1174      *
1175      * Requirements:
1176      *
1177      * - `from` cannot be the zero address.
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must be owned by `from`.
1180      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function transferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) external;
1189 
1190     /**
1191      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1192      * The approval is cleared when the token is transferred.
1193      *
1194      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1195      *
1196      * Requirements:
1197      *
1198      * - The caller must own the token or be an approved operator.
1199      * - `tokenId` must exist.
1200      *
1201      * Emits an {Approval} event.
1202      */
1203     function approve(address to, uint256 tokenId) external;
1204 
1205     /**
1206      * @dev Returns the account approved for `tokenId` token.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must exist.
1211      */
1212     function getApproved(uint256 tokenId) external view returns (address operator);
1213 
1214     /**
1215      * @dev Approve or remove `operator` as an operator for the caller.
1216      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1217      *
1218      * Requirements:
1219      *
1220      * - The `operator` cannot be the caller.
1221      *
1222      * Emits an {ApprovalForAll} event.
1223      */
1224     function setApprovalForAll(address operator, bool _approved) external;
1225 
1226     /**
1227      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1228      *
1229      * See {setApprovalForAll}
1230      */
1231     function isApprovedForAll(address owner, address operator) external view returns (bool);
1232 
1233     /**
1234      * @dev Safely transfers `tokenId` token from `from` to `to`.
1235      *
1236      * Requirements:
1237      *
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must exist and be owned by `from`.
1241      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1242      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function safeTransferFrom(
1247         address from,
1248         address to,
1249         uint256 tokenId,
1250         bytes calldata data
1251     ) external;
1252 }
1253 // File: IERC721Enumerable.sol
1254 
1255 
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 
1260 /**
1261  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1262  * @dev See https://eips.ethereum.org/EIPS/eip-721
1263  */
1264 interface IERC721Enumerable is IERC721 {
1265     /**
1266      * @dev Returns the total amount of tokens stored by the contract.
1267      */
1268     function totalSupply() external view returns (uint256);
1269 
1270     /**
1271      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1272      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1273      */
1274     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1275 
1276     /**
1277      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1278      * Use along with {totalSupply} to enumerate all tokens.
1279      */
1280     function tokenByIndex(uint256 index) external view returns (uint256);
1281 }
1282 // File: IERC721Metadata.sol
1283 
1284 
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 
1289 /**
1290  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1291  * @dev See https://eips.ethereum.org/EIPS/eip-721
1292  */
1293 interface IERC721Metadata is IERC721 {
1294     /**
1295      * @dev Returns the token collection name.
1296      */
1297     function name() external view returns (string memory);
1298 
1299     /**
1300      * @dev Returns the token collection symbol.
1301      */
1302     function symbol() external view returns (string memory);
1303 
1304     /**
1305      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1306      */
1307     function tokenURI(uint256 tokenId) external view returns (string memory);
1308 }
1309 // File: ERC721.sol
1310 
1311 
1312 pragma solidity ^0.8.10;
1313 
1314 
1315 
1316 
1317 
1318 
1319 
1320 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1321     using Address for address;
1322     string private _name;
1323     string private _symbol;
1324     address[] internal _owners;
1325     mapping(uint256 => address) private _tokenApprovals;
1326     mapping(address => mapping(address => bool)) private _operatorApprovals;     
1327     constructor(string memory name_, string memory symbol_) {
1328         _name = name_;
1329         _symbol = symbol_;
1330     }     
1331     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1332         return
1333             interfaceId == type(IERC721).interfaceId ||
1334             interfaceId == type(IERC721Metadata).interfaceId ||
1335             super.supportsInterface(interfaceId);
1336     }
1337     function balanceOf(address owner) public view virtual override returns (uint256) {
1338         require(owner != address(0), "ERC721: balance query for the zero address");
1339         uint count = 0;
1340         uint length = _owners.length;
1341         for( uint i = 0; i < length; ++i ){
1342           if( owner == _owners[i] ){
1343             ++count;
1344           }
1345         }
1346         delete length;
1347         return count;
1348     }
1349     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1350         address owner = _owners[tokenId];
1351         require(owner != address(0), "ERC721: owner query for nonexistent token");
1352         return owner;
1353     }
1354     function name() public view virtual override returns (string memory) {
1355         return _name;
1356     }
1357     function symbol() public view virtual override returns (string memory) {
1358         return _symbol;
1359     }
1360     function approve(address to, uint256 tokenId) public virtual override {
1361         address owner = ERC721.ownerOf(tokenId);
1362         require(to != owner, "ERC721: approval to current owner");
1363 
1364         require(
1365             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1366             "ERC721: approve caller is not owner nor approved for all"
1367         );
1368 
1369         _approve(to, tokenId);
1370     }
1371     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1372         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1373 
1374         return _tokenApprovals[tokenId];
1375     }
1376     function setApprovalForAll(address operator, bool approved) public virtual override {
1377         require(operator != _msgSender(), "ERC721: approve to caller");
1378 
1379         _operatorApprovals[_msgSender()][operator] = approved;
1380         emit ApprovalForAll(_msgSender(), operator, approved);
1381     }
1382     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1383         return _operatorApprovals[owner][operator];
1384     }
1385     function transferFrom(
1386         address from,
1387         address to,
1388         uint256 tokenId
1389     ) public virtual override {
1390         //solhint-disable-next-line max-line-length
1391         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1392 
1393         _transfer(from, to, tokenId);
1394     }
1395     function safeTransferFrom(
1396         address from,
1397         address to,
1398         uint256 tokenId
1399     ) public virtual override {
1400         safeTransferFrom(from, to, tokenId, "");
1401     }
1402     function safeTransferFrom(
1403         address from,
1404         address to,
1405         uint256 tokenId,
1406         bytes memory _data
1407     ) public virtual override {
1408         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1409         _safeTransfer(from, to, tokenId, _data);
1410     }     
1411     function _safeTransfer(
1412         address from,
1413         address to,
1414         uint256 tokenId,
1415         bytes memory _data
1416     ) internal virtual {
1417         _transfer(from, to, tokenId);
1418         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1419     }
1420 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
1421         return tokenId < _owners.length && _owners[tokenId] != address(0);
1422     }
1423 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1424         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1425         address owner = ERC721.ownerOf(tokenId);
1426         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1427     }
1428 	function _safeMint(address to, uint256 tokenId) internal virtual {
1429         _safeMint(to, tokenId, "");
1430     }
1431 	function _safeMint(
1432         address to,
1433         uint256 tokenId,
1434         bytes memory _data
1435     ) internal virtual {
1436         _mint(to, tokenId);
1437         require(
1438             _checkOnERC721Received(address(0), to, tokenId, _data),
1439             "ERC721: transfer to non ERC721Receiver implementer"
1440         );
1441     }
1442 	function _mint(address to, uint256 tokenId) internal virtual {
1443         require(to != address(0), "ERC721: mint to the zero address");
1444         require(!_exists(tokenId), "ERC721: token already minted");
1445 
1446         _beforeTokenTransfer(address(0), to, tokenId);
1447         _owners.push(to);
1448 
1449         emit Transfer(address(0), to, tokenId);
1450     }
1451 	function _burn(uint256 tokenId) internal virtual {
1452         address owner = ERC721.ownerOf(tokenId);
1453 
1454         _beforeTokenTransfer(owner, address(0), tokenId);
1455 
1456         // Clear approvals
1457         _approve(address(0), tokenId);
1458         _owners[tokenId] = address(0);
1459 
1460         emit Transfer(owner, address(0), tokenId);
1461     }
1462 	function _transfer(
1463         address from,
1464         address to,
1465         uint256 tokenId
1466     ) internal virtual {
1467         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1468         require(to != address(0), "ERC721: transfer to the zero address");
1469 
1470         _beforeTokenTransfer(from, to, tokenId);
1471 
1472         // Clear approvals from the previous owner
1473         _approve(address(0), tokenId);
1474         _owners[tokenId] = to;
1475 
1476         emit Transfer(from, to, tokenId);
1477     }
1478 	function _approve(address to, uint256 tokenId) internal virtual {
1479         _tokenApprovals[tokenId] = to;
1480         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1481     }
1482 	function _checkOnERC721Received(
1483         address from,
1484         address to,
1485         uint256 tokenId,
1486         bytes memory _data
1487     ) private returns (bool) {
1488         if (to.isContract()) {
1489             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1490                 return retval == IERC721Receiver.onERC721Received.selector;
1491             } catch (bytes memory reason) {
1492                 if (reason.length == 0) {
1493                     revert("ERC721: transfer to non ERC721Receiver implementer");
1494                 } else {
1495                     assembly {
1496                         revert(add(32, reason), mload(reason))
1497                     }
1498                 }
1499             }
1500         } else {
1501             return true;
1502         }
1503     }
1504 	function _beforeTokenTransfer(
1505         address from,
1506         address to,
1507         uint256 tokenId
1508     ) internal virtual {}
1509 }
1510 
1511 pragma solidity ^0.8.0;
1512 
1513 abstract contract ERC1155Supply is ERC1155 {
1514     mapping(uint256 => uint256) private _totalSupply;
1515 
1516     /**
1517      * @dev Total amount of tokens in with a given id.
1518      */
1519     function totalSupply(uint256 id) public view virtual returns (uint256) {
1520         return _totalSupply[id];
1521     }
1522 
1523     /**
1524      * @dev Indicates whether any token exist with a given id, or not.
1525      */
1526     function exists(uint256 id) public view virtual returns (bool) {
1527         return ERC1155Supply.totalSupply(id) > 0;
1528     }
1529 
1530     /**
1531      * @dev See {ERC1155-_beforeTokenTransfer}.
1532      */
1533     function _beforeTokenTransfer(
1534         address operator,
1535         address from,
1536         address to,
1537         uint256[] memory ids,
1538         uint256[] memory amounts,
1539         bytes memory data
1540     ) internal virtual override {
1541         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1542 
1543         if (from == address(0)) {
1544             for (uint256 i = 0; i < ids.length; ++i) {
1545                 _totalSupply[ids[i]] += amounts[i];
1546             }
1547         }
1548 
1549         if (to == address(0)) {
1550             for (uint256 i = 0; i < ids.length; ++i) {
1551                 _totalSupply[ids[i]] -= amounts[i];
1552             }
1553         }
1554     }
1555 }
1556 
1557 // File: ERC721Enumerable.sol
1558 
1559 
1560 pragma solidity ^0.8.10;
1561 
1562 
1563 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1564     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1565         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1566     }
1567     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
1568         require(index < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
1569         uint count;
1570         for( uint i; i < _owners.length; ++i ){
1571             if( owner == _owners[i] ){
1572                 if( count == index )
1573                     return i;
1574                 else
1575                     ++count;
1576             }
1577         }
1578         require(false, "ERC721Enum: owner ioob");
1579     }
1580     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1581         require(0 < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
1582         uint256 tokenCount = balanceOf(owner);
1583         uint256[] memory tokenIds = new uint256[](tokenCount);
1584         for (uint256 i = 0; i < tokenCount; i++) {
1585             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
1586         }
1587         return tokenIds;
1588     }
1589     function totalSupply() public view virtual override returns (uint256) {
1590         return _owners.length;
1591     }
1592     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1593         require(index < ERC721Enumerable.totalSupply(), "ERC721Enum: global ioob");
1594         return index;
1595     }
1596 }
1597 
1598 // File: ECDSA.sol
1599 
1600 
1601 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
1602 
1603 pragma solidity ^0.8.0;
1604 
1605 
1606 /**
1607  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1608  *
1609  * These functions can be used to verify that a message was signed by the holder
1610  * of the private keys of a given address.
1611  */
1612 library ECDSA {
1613     enum RecoverError {
1614         NoError,
1615         InvalidSignature,
1616         InvalidSignatureLength,
1617         InvalidSignatureS,
1618         InvalidSignatureV
1619     }
1620 
1621     function _throwError(RecoverError error) private pure {
1622         if (error == RecoverError.NoError) {
1623             return; // no error: do nothing
1624         } else if (error == RecoverError.InvalidSignature) {
1625             revert("ECDSA: invalid signature");
1626         } else if (error == RecoverError.InvalidSignatureLength) {
1627             revert("ECDSA: invalid signature length");
1628         } else if (error == RecoverError.InvalidSignatureS) {
1629             revert("ECDSA: invalid signature 's' value");
1630         } else if (error == RecoverError.InvalidSignatureV) {
1631             revert("ECDSA: invalid signature 'v' value");
1632         }
1633     }
1634 
1635     /**
1636      * @dev Returns the address that signed a hashed message (`hash`) with
1637      * `signature` or error string. This address can then be used for verification purposes.
1638      *
1639      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1640      * this function rejects them by requiring the `s` value to be in the lower
1641      * half order, and the `v` value to be either 27 or 28.
1642      *
1643      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1644      * verification to be secure: it is possible to craft signatures that
1645      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1646      * this is by receiving a hash of the original message (which may otherwise
1647      * be too long), and then calling {toEthSignedMessageHash} on it.
1648      *
1649      * Documentation for signature generation:
1650      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1651      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1652      *
1653      * _Available since v4.3._
1654      */
1655     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1656         // Check the signature length
1657         // - case 65: r,s,v signature (standard)
1658         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1659         if (signature.length == 65) {
1660             bytes32 r;
1661             bytes32 s;
1662             uint8 v;
1663             // ecrecover takes the signature parameters, and the only way to get them
1664             // currently is to use assembly.
1665             assembly {
1666                 r := mload(add(signature, 0x20))
1667                 s := mload(add(signature, 0x40))
1668                 v := byte(0, mload(add(signature, 0x60)))
1669             }
1670             return tryRecover(hash, v, r, s);
1671         } else if (signature.length == 64) {
1672             bytes32 r;
1673             bytes32 vs;
1674             // ecrecover takes the signature parameters, and the only way to get them
1675             // currently is to use assembly.
1676             assembly {
1677                 r := mload(add(signature, 0x20))
1678                 vs := mload(add(signature, 0x40))
1679             }
1680             return tryRecover(hash, r, vs);
1681         } else {
1682             return (address(0), RecoverError.InvalidSignatureLength);
1683         }
1684     }
1685 
1686     /**
1687      * @dev Returns the address that signed a hashed message (`hash`) with
1688      * `signature`. This address can then be used for verification purposes.
1689      *
1690      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1691      * this function rejects them by requiring the `s` value to be in the lower
1692      * half order, and the `v` value to be either 27 or 28.
1693      *
1694      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1695      * verification to be secure: it is possible to craft signatures that
1696      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1697      * this is by receiving a hash of the original message (which may otherwise
1698      * be too long), and then calling {toEthSignedMessageHash} on it.
1699      */
1700     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1701         (address recovered, RecoverError error) = tryRecover(hash, signature);
1702         _throwError(error);
1703         return recovered;
1704     }
1705 
1706     /**
1707      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1708      *
1709      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1710      *
1711      * _Available since v4.3._
1712      */
1713     function tryRecover(
1714         bytes32 hash,
1715         bytes32 r,
1716         bytes32 vs
1717     ) internal pure returns (address, RecoverError) {
1718         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1719         uint8 v = uint8((uint256(vs) >> 255) + 27);
1720         return tryRecover(hash, v, r, s);
1721     }
1722 
1723     /**
1724      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1725      *
1726      * _Available since v4.2._
1727      */
1728     function recover(
1729         bytes32 hash,
1730         bytes32 r,
1731         bytes32 vs
1732     ) internal pure returns (address) {
1733         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1734         _throwError(error);
1735         return recovered;
1736     }
1737 
1738     /**
1739      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1740      * `r` and `s` signature fields separately.
1741      *
1742      * _Available since v4.3._
1743      */
1744     function tryRecover(
1745         bytes32 hash,
1746         uint8 v,
1747         bytes32 r,
1748         bytes32 s
1749     ) internal pure returns (address, RecoverError) {
1750         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1751         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1752         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1753         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1754         //
1755         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1756         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1757         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1758         // these malleable signatures as well.
1759         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1760             return (address(0), RecoverError.InvalidSignatureS);
1761         }
1762         if (v != 27 && v != 28) {
1763             return (address(0), RecoverError.InvalidSignatureV);
1764         }
1765 
1766         // If the signature is valid (and not malleable), return the signer address
1767         address signer = ecrecover(hash, v, r, s);
1768         if (signer == address(0)) {
1769             return (address(0), RecoverError.InvalidSignature);
1770         }
1771 
1772         return (signer, RecoverError.NoError);
1773     }
1774 
1775     /**
1776      * @dev Overload of {ECDSA-recover} that receives the `v`,
1777      * `r` and `s` signature fields separately.
1778      */
1779     function recover(
1780         bytes32 hash,
1781         uint8 v,
1782         bytes32 r,
1783         bytes32 s
1784     ) internal pure returns (address) {
1785         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1786         _throwError(error);
1787         return recovered;
1788     }
1789 
1790     /**
1791      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1792      * produces hash corresponding to the one signed with the
1793      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1794      * JSON-RPC method as part of EIP-191.
1795      *
1796      * See {recover}.
1797      */
1798     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1799         // 32 is the length in bytes of hash,
1800         // enforced by the type signature above
1801         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1802     }
1803 
1804     /**
1805      * @dev Returns an Ethereum Signed Message, created from `s`. This
1806      * produces hash corresponding to the one signed with the
1807      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1808      * JSON-RPC method as part of EIP-191.
1809      *
1810      * See {recover}.
1811      */
1812     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1813         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1814     }
1815 
1816     /**
1817      * @dev Returns an Ethereum Signed Typed Data, created from a
1818      * `domainSeparator` and a `structHash`. This produces hash corresponding
1819      * to the one signed with the
1820      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1821      * JSON-RPC method as part of EIP-712.
1822      *
1823      * See {recover}.
1824      */
1825     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1826         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1827     }
1828 }
1829 
1830 pragma solidity ^0.8.9;
1831 
1832 contract AokiGTAnthem is ERC1155, Ownable {
1833 	using Strings for string;
1834 
1835 	mapping(address => bool) public hevyooBINheararreddy;
1836     mapping(bytes32 => bool) public howYOOgotinnahear;
1837 
1838     address private unkaSTEEVzbakpokket = 0x01d7cFB4bcEb9Dd6e917B59434590698c953e36C;
1839 
1840 	uint256 public BEETSONDAFLOOR = 521;
1841     uint256 public donbefukkingreedy = 1;
1842 
1843 	string public _stufwatmakesdapicherz;
1844 	bool public GOorNO = false;
1845     uint public lossastompinz;
1846 
1847     string waddawekallit_;
1848     string gimmedat_;   
1849 
1850 	constructor() ERC1155(_stufwatmakesdapicherz) { waddawekallit_ = "AokiGTAnthem"; gimmedat_ = "PISS"; }
1851 
1852     modifier iZunkaSTEEVzbakpokketn {
1853         require(msg.sender == unkaSTEEVzbakpokket);
1854      _;
1855     }
1856 
1857     function MAKEdatSWEATmoozik(address plaseweartingshappn, bytes calldata sekretwordzes) external {		
1858 	   require(GOorNO);
1859        require(lossastompinz + 1 <= BEETSONDAFLOOR);
1860        require(msg.sender == plaseweartingshappn);
1861        require(hevyooBINheararreddy[plaseweartingshappn] == false);
1862        hevyooBINheararreddy[plaseweartingshappn] = true;
1863 
1864        bytes32 makkewlfraze = keccak256(abi.encodePacked(plaseweartingshappn));
1865        require(howYOOgotinnahear[makkewlfraze] == false);
1866        require(_verifySignature(unkaSTEEVzbakpokket, makkewlfraze, sekretwordzes));
1867        howYOOgotinnahear[makkewlfraze] = true;
1868  
1869        _mint(msg.sender, 0, 1, "");
1870        lossastompinz += 1;
1871     }
1872 
1873     function POOdatSWEATmoozik(address[] calldata plaseweartingshappn) public iZunkaSTEEVzbakpokketn {	
1874 
1875         require(lossastompinz + plaseweartingshappn.length <= BEETSONDAFLOOR);	
1876 
1877 		for(uint256 x = 0; x < plaseweartingshappn.length; x++) {
1878         _mint(plaseweartingshappn[x], 0, 1, "");
1879         }
1880 
1881         lossastompinz += plaseweartingshappn.length;
1882     }
1883 
1884 	function makGOorNO(bool _doodoo) external iZunkaSTEEVzbakpokketn {
1885 		GOorNO = _doodoo;
1886 	}
1887 
1888 	function makePicherz(string memory makesdapicherz) public iZunkaSTEEVzbakpokketn {
1889 		_stufwatmakesdapicherz = makesdapicherz;
1890 	}
1891  
1892     function setSteevzPokket(address _newtroll) external iZunkaSTEEVzbakpokketn {
1893        unkaSTEEVzbakpokket = _newtroll;
1894     }   
1895 
1896 	function uri(uint256 tokenId) public view override returns (string memory) {
1897         require(tokenId == 0);
1898 		return _stufwatmakesdapicherz;
1899 	}
1900 
1901     function name() public view returns (string memory) {
1902         return waddawekallit_;
1903     }
1904 
1905     function symbol() public view returns (string memory) {
1906         return gimmedat_;
1907     }    
1908 
1909     function _verifySignature(address unkaSTEEV, bytes32 makkewlfraze, bytes memory sekretwordzes) private pure returns (bool) {
1910        return unkaSTEEV == ECDSA.recover(ECDSA.toEthSignedMessageHash(makkewlfraze), sekretwordzes);
1911     }
1912 
1913 	function withdrawToOwner() external onlyOwner {
1914 		payable(msg.sender).transfer(address(this).balance);
1915 	}
1916 
1917 }