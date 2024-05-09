1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
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
70 // File: Context.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /*
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 // File: Ownable.sol
96 
97 
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
123         _setOwner(_msgSender());
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
149         _setOwner(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _setOwner(newOwner);
159     }
160 
161     function _setOwner(address newOwner) private {
162         address oldOwner = _owner;
163         _owner = newOwner;
164         emit OwnershipTransferred(oldOwner, newOwner);
165     }
166 }
167 // File: Address.sol
168 
169 
170 
171 pragma solidity ^0.8.0;
172 
173 /**
174  * @dev Collection of functions related to the address type
175  */
176 library Address {
177     /**
178      * @dev Returns true if `account` is a contract.
179      *
180      * [IMPORTANT]
181      * ====
182      * It is unsafe to assume that an address for which this function returns
183      * false is an externally-owned account (EOA) and not a contract.
184      *
185      * Among others, `isContract` will return false for the following
186      * types of addresses:
187      *
188      *  - an externally-owned account
189      *  - a contract in construction
190      *  - an address where a contract will be created
191      *  - an address where a contract lived, but was destroyed
192      * ====
193      */
194     function isContract(address account) internal view returns (bool) {
195         // This method relies on extcodesize, which returns 0 for contracts in
196         // construction, since the code is only stored at the end of the
197         // constructor execution.
198 
199         uint256 size;
200         assembly {
201             size := extcodesize(account)
202         }
203         return size > 0;
204     }
205 
206     /**
207      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
208      * `recipient`, forwarding all available gas and reverting on errors.
209      *
210      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
211      * of certain opcodes, possibly making contracts go over the 2300 gas limit
212      * imposed by `transfer`, making them unable to receive funds via
213      * `transfer`. {sendValue} removes this limitation.
214      *
215      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
216      *
217      * IMPORTANT: because control is transferred to `recipient`, care must be
218      * taken to not create reentrancy vulnerabilities. Consider using
219      * {ReentrancyGuard} or the
220      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
221      */
222     function sendValue(address payable recipient, uint256 amount) internal {
223         require(address(this).balance >= amount, "Address: insufficient balance");
224 
225         (bool success, ) = recipient.call{value: amount}("");
226         require(success, "Address: unable to send value, recipient may have reverted");
227     }
228 
229     /**
230      * @dev Performs a Solidity function call using a low level `call`. A
231      * plain `call` is an unsafe replacement for a function call: use this
232      * function instead.
233      *
234      * If `target` reverts with a revert reason, it is bubbled up by this
235      * function (like regular Solidity function calls).
236      *
237      * Returns the raw returned data. To convert to the expected return value,
238      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
239      *
240      * Requirements:
241      *
242      * - `target` must be a contract.
243      * - calling `target` with `data` must not revert.
244      *
245      * _Available since v3.1._
246      */
247     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionCall(target, data, "Address: low-level call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
253      * `errorMessage` as a fallback revert reason when `target` reverts.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, 0, errorMessage);
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
267      * but also transferring `value` wei to `target`.
268      *
269      * Requirements:
270      *
271      * - the calling contract must have an ETH balance of at least `value`.
272      * - the called Solidity function must be `payable`.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(
277         address target,
278         bytes memory data,
279         uint256 value
280     ) internal returns (bytes memory) {
281         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
286      * with `errorMessage` as a fallback revert reason when `target` reverts.
287      *
288      * _Available since v3.1._
289      */
290     function functionCallWithValue(
291         address target,
292         bytes memory data,
293         uint256 value,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         require(address(this).balance >= value, "Address: insufficient balance for call");
297         require(isContract(target), "Address: call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.call{value: value}(data);
300         return _verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a static call.
306      *
307      * _Available since v3.3._
308      */
309     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
310         return functionStaticCall(target, data, "Address: low-level static call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal view returns (bytes memory) {
324         require(isContract(target), "Address: static call to non-contract");
325 
326         (bool success, bytes memory returndata) = target.staticcall(data);
327         return _verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but performing a delegate call.
333      *
334      * _Available since v3.4._
335      */
336     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
337         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
342      * but performing a delegate call.
343      *
344      * _Available since v3.4._
345      */
346     function functionDelegateCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         require(isContract(target), "Address: delegate call to non-contract");
352 
353         (bool success, bytes memory returndata) = target.delegatecall(data);
354         return _verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     function _verifyCallResult(
358         bool success,
359         bytes memory returndata,
360         string memory errorMessage
361     ) private pure returns (bytes memory) {
362         if (success) {
363             return returndata;
364         } else {
365             // Look for revert reason and bubble it up if present
366             if (returndata.length > 0) {
367                 // The easiest way to bubble the revert reason is using memory via assembly
368 
369                 assembly {
370                     let returndata_size := mload(returndata)
371                     revert(add(32, returndata), returndata_size)
372                 }
373             } else {
374                 revert(errorMessage);
375             }
376         }
377     }
378 }
379 // File: IERC721Receiver.sol
380 
381 
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @title ERC721 token receiver interface
387  * @dev Interface for any contract that wants to support safeTransfers
388  * from ERC721 asset contracts.
389  */
390 interface IERC721Receiver {
391     /**
392      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
393      * by `operator` from `from`, this function is called.
394      *
395      * It must return its Solidity selector to confirm the token transfer.
396      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
397      *
398      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
399      */
400     function onERC721Received(
401         address operator,
402         address from,
403         uint256 tokenId,
404         bytes calldata data
405     ) external returns (bytes4);
406 }
407 // File: IERC165.sol
408 
409 
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @dev Interface of the ERC165 standard, as defined in the
415  * https://eips.ethereum.org/EIPS/eip-165[EIP].
416  *
417  * Implementers can declare support of contract interfaces, which can then be
418  * queried by others ({ERC165Checker}).
419  *
420  * For an implementation, see {ERC165}.
421  */
422 interface IERC165 {
423     /**
424      * @dev Returns true if this contract implements the interface defined by
425      * `interfaceId`. See the corresponding
426      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
427      * to learn more about how these ids are created.
428      *
429      * This function call must use less than 30 000 gas.
430      */
431     function supportsInterface(bytes4 interfaceId) external view returns (bool);
432 }
433 // File: IERC1155Receiver.sol
434 
435 
436 
437 pragma solidity ^0.8.0;
438 
439 
440 /**
441  * @dev _Available since v3.1._
442  */
443 interface IERC1155Receiver is IERC165 {
444     /**
445         @dev Handles the receipt of a single ERC1155 token type. This function is
446         called at the end of a `safeTransferFrom` after the balance has been updated.
447         To accept the transfer, this must return
448         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
449         (i.e. 0xf23a6e61, or its own function selector).
450         @param operator The address which initiated the transfer (i.e. msg.sender)
451         @param from The address which previously owned the token
452         @param id The ID of the token being transferred
453         @param value The amount of tokens being transferred
454         @param data Additional data with no specified format
455         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
456     */
457     function onERC1155Received(
458         address operator,
459         address from,
460         uint256 id,
461         uint256 value,
462         bytes calldata data
463     ) external returns (bytes4);
464 
465     /**
466         @dev Handles the receipt of a multiple ERC1155 token types. This function
467         is called at the end of a `safeBatchTransferFrom` after the balances have
468         been updated. To accept the transfer(s), this must return
469         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
470         (i.e. 0xbc197c81, or its own function selector).
471         @param operator The address which initiated the batch transfer (i.e. msg.sender)
472         @param from The address which previously owned the token
473         @param ids An array containing ids of each token being transferred (order and length must match values array)
474         @param values An array containing amounts of each token being transferred (order and length must match ids array)
475         @param data Additional data with no specified format
476         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
477     */
478     function onERC1155BatchReceived(
479         address operator,
480         address from,
481         uint256[] calldata ids,
482         uint256[] calldata values,
483         bytes calldata data
484     ) external returns (bytes4);
485 }
486 // File: IERC1155.sol
487 
488 
489 
490 pragma solidity ^0.8.0;
491 
492 
493 /**
494  * @dev Required interface of an ERC1155 compliant contract, as defined in the
495  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
496  *
497  * _Available since v3.1._
498  */
499 interface IERC1155 is IERC165 {
500     /**
501      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
502      */
503     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
504 
505     /**
506      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
507      * transfers.
508      */
509     event TransferBatch(
510         address indexed operator,
511         address indexed from,
512         address indexed to,
513         uint256[] ids,
514         uint256[] values
515     );
516 
517     /**
518      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
519      * `approved`.
520      */
521     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
522 
523     /**
524      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
525      *
526      * If an {URI} event was emitted for `id`, the standard
527      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
528      * returned by {IERC1155MetadataURI-uri}.
529      */
530     event URI(string value, uint256 indexed id);
531 
532     /**
533      * @dev Returns the amount of tokens of token type `id` owned by `account`.
534      *
535      * Requirements:
536      *
537      * - `account` cannot be the zero address.
538      */
539     function balanceOf(address account, uint256 id) external view returns (uint256);
540 
541     /**
542      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
543      *
544      * Requirements:
545      *
546      * - `accounts` and `ids` must have the same length.
547      */
548     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
549         external
550         view
551         returns (uint256[] memory);
552 
553     /**
554      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
555      *
556      * Emits an {ApprovalForAll} event.
557      *
558      * Requirements:
559      *
560      * - `operator` cannot be the caller.
561      */
562     function setApprovalForAll(address operator, bool approved) external;
563 
564     /**
565      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
566      *
567      * See {setApprovalForAll}.
568      */
569     function isApprovedForAll(address account, address operator) external view returns (bool);
570 
571     /**
572      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
573      *
574      * Emits a {TransferSingle} event.
575      *
576      * Requirements:
577      *
578      * - `to` cannot be the zero address.
579      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
580      * - `from` must have a balance of tokens of type `id` of at least `amount`.
581      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
582      * acceptance magic value.
583      */
584     function safeTransferFrom(
585         address from,
586         address to,
587         uint256 id,
588         uint256 amount,
589         bytes calldata data
590     ) external;
591 
592     /**
593      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
594      *
595      * Emits a {TransferBatch} event.
596      *
597      * Requirements:
598      *
599      * - `ids` and `amounts` must have the same length.
600      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
601      * acceptance magic value.
602      */
603     function safeBatchTransferFrom(
604         address from,
605         address to,
606         uint256[] calldata ids,
607         uint256[] calldata amounts,
608         bytes calldata data
609     ) external;
610 }
611 // File: IERC1155MetadataURI.sol
612 
613 
614 
615 pragma solidity ^0.8.0;
616 
617 
618 /**
619  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
620  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
621  *
622  * _Available since v3.1._
623  */
624 interface IERC1155MetadataURI is IERC1155 {
625     /**
626      * @dev Returns the URI for token type `id`.
627      *
628      * If the `\{id\}` substring is present in the URI, it must be replaced by
629      * clients with the actual token type ID.
630      */
631     function uri(uint256 id) external view returns (string memory);
632 }
633 // File: ERC165.sol
634 
635 
636 
637 pragma solidity ^0.8.0;
638 
639 
640 /**
641  * @dev Implementation of the {IERC165} interface.
642  *
643  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
644  * for the additional interface id that will be supported. For example:
645  *
646  * ```solidity
647  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
648  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
649  * }
650  * ```
651  *
652  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
653  */
654 abstract contract ERC165 is IERC165 {
655     /**
656      * @dev See {IERC165-supportsInterface}.
657      */
658     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
659         return interfaceId == type(IERC165).interfaceId;
660     }
661 }
662 // File: ERC1155.sol
663 
664 
665 
666 pragma solidity ^0.8.0;
667 
668 
669 
670 
671 
672 
673 
674 /**
675  * @dev Implementation of the basic standard multi-token.
676  * See https://eips.ethereum.org/EIPS/eip-1155
677  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
678  *
679  * _Available since v3.1._
680  */
681 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
682     using Address for address;
683 
684     // Mapping from token ID to account balances
685     mapping(uint256 => mapping(address => uint256)) private _balances;
686 
687     // Mapping from account to operator approvals
688     mapping(address => mapping(address => bool)) private _operatorApprovals;
689 
690     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
691     string private _uri;
692 
693     /**
694      * @dev See {_setURI}.
695      */
696     constructor(string memory uri_) {
697         _setURI(uri_);
698     }
699 
700     /**
701      * @dev See {IERC165-supportsInterface}.
702      */
703     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
704         return
705             interfaceId == type(IERC1155).interfaceId ||
706             interfaceId == type(IERC1155MetadataURI).interfaceId ||
707             super.supportsInterface(interfaceId);
708     }
709 
710     /**
711      * @dev See {IERC1155MetadataURI-uri}.
712      *
713      * This implementation returns the same URI for *all* token types. It relies
714      * on the token type ID substitution mechanism
715      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
716      *
717      * Clients calling this function must replace the `\{id\}` substring with the
718      * actual token type ID.
719      */
720     function uri(uint256) public view virtual override returns (string memory) {
721         return _uri;
722     }
723 
724     /**
725      * @dev See {IERC1155-balanceOf}.
726      *
727      * Requirements:
728      *
729      * - `account` cannot be the zero address.
730      */
731     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
732         require(account != address(0), "ERC1155: balance query for the zero address");
733         return _balances[id][account];
734     }
735 
736     /**
737      * @dev See {IERC1155-balanceOfBatch}.
738      *
739      * Requirements:
740      *
741      * - `accounts` and `ids` must have the same length.
742      */
743     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
744         public
745         view
746         virtual
747         override
748         returns (uint256[] memory)
749     {
750         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
751 
752         uint256[] memory batchBalances = new uint256[](accounts.length);
753 
754         for (uint256 i = 0; i < accounts.length; ++i) {
755             batchBalances[i] = balanceOf(accounts[i], ids[i]);
756         }
757 
758         return batchBalances;
759     }
760 
761     /**
762      * @dev See {IERC1155-setApprovalForAll}.
763      */
764     function setApprovalForAll(address operator, bool approved) public virtual override {
765         require(_msgSender() != operator, "ERC1155: setting approval status for self");
766 
767         _operatorApprovals[_msgSender()][operator] = approved;
768         emit ApprovalForAll(_msgSender(), operator, approved);
769     }
770 
771     /**
772      * @dev See {IERC1155-isApprovedForAll}.
773      */
774     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
775         return _operatorApprovals[account][operator];
776     }
777 
778     /**
779      * @dev See {IERC1155-safeTransferFrom}.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 id,
785         uint256 amount,
786         bytes memory data
787     ) public virtual override {
788         require(
789             from == _msgSender() || isApprovedForAll(from, _msgSender()),
790             "ERC1155: caller is not owner nor approved"
791         );
792         _safeTransferFrom(from, to, id, amount, data);
793     }
794 
795     /**
796      * @dev See {IERC1155-safeBatchTransferFrom}.
797      */
798     function safeBatchTransferFrom(
799         address from,
800         address to,
801         uint256[] memory ids,
802         uint256[] memory amounts,
803         bytes memory data
804     ) public virtual override {
805         require(
806             from == _msgSender() || isApprovedForAll(from, _msgSender()),
807             "ERC1155: transfer caller is not owner nor approved"
808         );
809         _safeBatchTransferFrom(from, to, ids, amounts, data);
810     }
811 
812     /**
813      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
814      *
815      * Emits a {TransferSingle} event.
816      *
817      * Requirements:
818      *
819      * - `to` cannot be the zero address.
820      * - `from` must have a balance of tokens of type `id` of at least `amount`.
821      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
822      * acceptance magic value.
823      */
824     function _safeTransferFrom(
825         address from,
826         address to,
827         uint256 id,
828         uint256 amount,
829         bytes memory data
830     ) internal virtual {
831         require(to != address(0), "ERC1155: transfer to the zero address");
832 
833         address operator = _msgSender();
834 
835         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
836 
837         uint256 fromBalance = _balances[id][from];
838         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
839         unchecked {
840             _balances[id][from] = fromBalance - amount;
841         }
842         _balances[id][to] += amount;
843 
844         emit TransferSingle(operator, from, to, id, amount);
845 
846         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
847     }
848 
849     /**
850      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
851      *
852      * Emits a {TransferBatch} event.
853      *
854      * Requirements:
855      *
856      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
857      * acceptance magic value.
858      */
859     function _safeBatchTransferFrom(
860         address from,
861         address to,
862         uint256[] memory ids,
863         uint256[] memory amounts,
864         bytes memory data
865     ) internal virtual {
866         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
867         require(to != address(0), "ERC1155: transfer to the zero address");
868 
869         address operator = _msgSender();
870 
871         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
872 
873         for (uint256 i = 0; i < ids.length; ++i) {
874             uint256 id = ids[i];
875             uint256 amount = amounts[i];
876 
877             uint256 fromBalance = _balances[id][from];
878             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
879             unchecked {
880                 _balances[id][from] = fromBalance - amount;
881             }
882             _balances[id][to] += amount;
883         }
884 
885         emit TransferBatch(operator, from, to, ids, amounts);
886 
887         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
888     }
889 
890     /**
891      * @dev Sets a new URI for all token types, by relying on the token type ID
892      * substitution mechanism
893      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
894      *
895      * By this mechanism, any occurrence of the `\{id\}` substring in either the
896      * URI or any of the amounts in the JSON file at said URI will be replaced by
897      * clients with the token type ID.
898      *
899      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
900      * interpreted by clients as
901      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
902      * for token type ID 0x4cce0.
903      *
904      * See {uri}.
905      *
906      * Because these URIs cannot be meaningfully represented by the {URI} event,
907      * this function emits no events.
908      */
909     function _setURI(string memory newuri) internal virtual {
910         _uri = newuri;
911     }
912 
913     /**
914      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
915      *
916      * Emits a {TransferSingle} event.
917      *
918      * Requirements:
919      *
920      * - `account` cannot be the zero address.
921      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
922      * acceptance magic value.
923      */
924     function _mint(
925         address account,
926         uint256 id,
927         uint256 amount,
928         bytes memory data
929     ) internal virtual {
930         require(account != address(0), "ERC1155: mint to the zero address");
931 
932         address operator = _msgSender();
933 
934         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
935 
936         _balances[id][account] += amount;
937         emit TransferSingle(operator, address(0), account, id, amount);
938 
939         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
940     }
941 
942     /**
943      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
944      *
945      * Requirements:
946      *
947      * - `ids` and `amounts` must have the same length.
948      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
949      * acceptance magic value.
950      */
951     function _mintBatch(
952         address to,
953         uint256[] memory ids,
954         uint256[] memory amounts,
955         bytes memory data
956     ) internal virtual {
957         require(to != address(0), "ERC1155: mint to the zero address");
958         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
959 
960         address operator = _msgSender();
961 
962         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
963 
964         for (uint256 i = 0; i < ids.length; i++) {
965             _balances[ids[i]][to] += amounts[i];
966         }
967 
968         emit TransferBatch(operator, address(0), to, ids, amounts);
969 
970         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
971     }
972 
973     /**
974      * @dev Destroys `amount` tokens of token type `id` from `account`
975      *
976      * Requirements:
977      *
978      * - `account` cannot be the zero address.
979      * - `account` must have at least `amount` tokens of token type `id`.
980      */
981     function _burn(
982         address account,
983         uint256 id,
984         uint256 amount
985     ) internal virtual {
986         require(account != address(0), "ERC1155: burn from the zero address");
987 
988         address operator = _msgSender();
989 
990         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
991 
992         uint256 accountBalance = _balances[id][account];
993         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
994         unchecked {
995             _balances[id][account] = accountBalance - amount;
996         }
997 
998         emit TransferSingle(operator, account, address(0), id, amount);
999     }
1000 
1001     /**
1002      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1003      *
1004      * Requirements:
1005      *
1006      * - `ids` and `amounts` must have the same length.
1007      */
1008     function _burnBatch(
1009         address account,
1010         uint256[] memory ids,
1011         uint256[] memory amounts
1012     ) internal virtual {
1013         require(account != address(0), "ERC1155: burn from the zero address");
1014         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1015 
1016         address operator = _msgSender();
1017 
1018         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1019 
1020         for (uint256 i = 0; i < ids.length; i++) {
1021             uint256 id = ids[i];
1022             uint256 amount = amounts[i];
1023 
1024             uint256 accountBalance = _balances[id][account];
1025             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1026             unchecked {
1027                 _balances[id][account] = accountBalance - amount;
1028             }
1029         }
1030 
1031         emit TransferBatch(operator, account, address(0), ids, amounts);
1032     }
1033 
1034     /**
1035      * @dev Hook that is called before any token transfer. This includes minting
1036      * and burning, as well as batched variants.
1037      *
1038      * The same hook is called on both single and batched variants. For single
1039      * transfers, the length of the `id` and `amount` arrays will be 1.
1040      *
1041      * Calling conditions (for each `id` and `amount` pair):
1042      *
1043      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1044      * of token type `id` will be  transferred to `to`.
1045      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1046      * for `to`.
1047      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1048      * will be burned.
1049      * - `from` and `to` are never both zero.
1050      * - `ids` and `amounts` have the same, non-zero length.
1051      *
1052      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1053      */
1054     function _beforeTokenTransfer(
1055         address operator,
1056         address from,
1057         address to,
1058         uint256[] memory ids,
1059         uint256[] memory amounts,
1060         bytes memory data
1061     ) internal virtual {}
1062 
1063     function _doSafeTransferAcceptanceCheck(
1064         address operator,
1065         address from,
1066         address to,
1067         uint256 id,
1068         uint256 amount,
1069         bytes memory data
1070     ) private {
1071         if (to.isContract()) {
1072             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1073                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1074                     revert("ERC1155: ERC1155Receiver rejected tokens");
1075                 }
1076             } catch Error(string memory reason) {
1077                 revert(reason);
1078             } catch {
1079                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1080             }
1081         }
1082     }
1083 
1084     function _doSafeBatchTransferAcceptanceCheck(
1085         address operator,
1086         address from,
1087         address to,
1088         uint256[] memory ids,
1089         uint256[] memory amounts,
1090         bytes memory data
1091     ) private {
1092         if (to.isContract()) {
1093             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1094                 bytes4 response
1095             ) {
1096                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1097                     revert("ERC1155: ERC1155Receiver rejected tokens");
1098                 }
1099             } catch Error(string memory reason) {
1100                 revert(reason);
1101             } catch {
1102                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1103             }
1104         }
1105     }
1106 
1107     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1108         uint256[] memory array = new uint256[](1);
1109         array[0] = element;
1110 
1111         return array;
1112     }
1113 }
1114 // File: IERC721.sol
1115 
1116 
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 
1121 /**
1122  * @dev Required interface of an ERC721 compliant contract.
1123  */
1124 interface IERC721 is IERC165 {
1125     /**
1126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1127      */
1128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1129 
1130     /**
1131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1132      */
1133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1134 
1135     /**
1136      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1137      */
1138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1139 
1140     /**
1141      * @dev Returns the number of tokens in ``owner``'s account.
1142      */
1143     function balanceOf(address owner) external view returns (uint256 balance);
1144 
1145     /**
1146      * @dev Returns the owner of the `tokenId` token.
1147      *
1148      * Requirements:
1149      *
1150      * - `tokenId` must exist.
1151      */
1152     function ownerOf(uint256 tokenId) external view returns (address owner);
1153 
1154     /**
1155      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1156      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1157      *
1158      * Requirements:
1159      *
1160      * - `from` cannot be the zero address.
1161      * - `to` cannot be the zero address.
1162      * - `tokenId` token must exist and be owned by `from`.
1163      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function safeTransferFrom(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) external;
1173 
1174     /**
1175      * @dev Transfers `tokenId` token from `from` to `to`.
1176      *
1177      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1178      *
1179      * Requirements:
1180      *
1181      * - `from` cannot be the zero address.
1182      * - `to` cannot be the zero address.
1183      * - `tokenId` token must be owned by `from`.
1184      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function transferFrom(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) external;
1193 
1194     /**
1195      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1196      * The approval is cleared when the token is transferred.
1197      *
1198      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1199      *
1200      * Requirements:
1201      *
1202      * - The caller must own the token or be an approved operator.
1203      * - `tokenId` must exist.
1204      *
1205      * Emits an {Approval} event.
1206      */
1207     function approve(address to, uint256 tokenId) external;
1208 
1209     /**
1210      * @dev Returns the account approved for `tokenId` token.
1211      *
1212      * Requirements:
1213      *
1214      * - `tokenId` must exist.
1215      */
1216     function getApproved(uint256 tokenId) external view returns (address operator);
1217 
1218     /**
1219      * @dev Approve or remove `operator` as an operator for the caller.
1220      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1221      *
1222      * Requirements:
1223      *
1224      * - The `operator` cannot be the caller.
1225      *
1226      * Emits an {ApprovalForAll} event.
1227      */
1228     function setApprovalForAll(address operator, bool _approved) external;
1229 
1230     /**
1231      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1232      *
1233      * See {setApprovalForAll}
1234      */
1235     function isApprovedForAll(address owner, address operator) external view returns (bool);
1236 
1237     /**
1238      * @dev Safely transfers `tokenId` token from `from` to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - `from` cannot be the zero address.
1243      * - `to` cannot be the zero address.
1244      * - `tokenId` token must exist and be owned by `from`.
1245      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1246      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function safeTransferFrom(
1251         address from,
1252         address to,
1253         uint256 tokenId,
1254         bytes calldata data
1255     ) external;
1256 }
1257 // File: IERC721Enumerable.sol
1258 
1259 
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 
1264 /**
1265  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1266  * @dev See https://eips.ethereum.org/EIPS/eip-721
1267  */
1268 interface IERC721Enumerable is IERC721 {
1269     /**
1270      * @dev Returns the total amount of tokens stored by the contract.
1271      */
1272     function totalSupply() external view returns (uint256);
1273 
1274     /**
1275      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1276      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1277      */
1278     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1279 
1280     /**
1281      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1282      * Use along with {totalSupply} to enumerate all tokens.
1283      */
1284     function tokenByIndex(uint256 index) external view returns (uint256);
1285 }
1286 // File: IERC721Metadata.sol
1287 
1288 
1289 
1290 pragma solidity ^0.8.0;
1291 
1292 
1293 /**
1294  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1295  * @dev See https://eips.ethereum.org/EIPS/eip-721
1296  */
1297 interface IERC721Metadata is IERC721 {
1298     /**
1299      * @dev Returns the token collection name.
1300      */
1301     function name() external view returns (string memory);
1302 
1303     /**
1304      * @dev Returns the token collection symbol.
1305      */
1306     function symbol() external view returns (string memory);
1307 
1308     /**
1309      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1310      */
1311     function tokenURI(uint256 tokenId) external view returns (string memory);
1312 }
1313 // File: ERC721.sol
1314 
1315 
1316 pragma solidity ^0.8.10;
1317 
1318 
1319 
1320 
1321 
1322 
1323 
1324 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1325     using Address for address;
1326     string private _name;
1327     string private _symbol;
1328     address[] internal _owners;
1329     mapping(uint256 => address) private _tokenApprovals;
1330     mapping(address => mapping(address => bool)) private _operatorApprovals;     
1331     constructor(string memory name_, string memory symbol_) {
1332         _name = name_;
1333         _symbol = symbol_;
1334     }     
1335     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1336         return
1337             interfaceId == type(IERC721).interfaceId ||
1338             interfaceId == type(IERC721Metadata).interfaceId ||
1339             super.supportsInterface(interfaceId);
1340     }
1341     function balanceOf(address owner) public view virtual override returns (uint256) {
1342         require(owner != address(0), "ERC721: balance query for the zero address");
1343         uint count = 0;
1344         uint length = _owners.length;
1345         for( uint i = 0; i < length; ++i ){
1346           if( owner == _owners[i] ){
1347             ++count;
1348           }
1349         }
1350         delete length;
1351         return count;
1352     }
1353     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1354         address owner = _owners[tokenId];
1355         require(owner != address(0), "ERC721: owner query for nonexistent token");
1356         return owner;
1357     }
1358     function name() public view virtual override returns (string memory) {
1359         return _name;
1360     }
1361     function symbol() public view virtual override returns (string memory) {
1362         return _symbol;
1363     }
1364     function approve(address to, uint256 tokenId) public virtual override {
1365         address owner = ERC721.ownerOf(tokenId);
1366         require(to != owner, "ERC721: approval to current owner");
1367 
1368         require(
1369             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1370             "ERC721: approve caller is not owner nor approved for all"
1371         );
1372 
1373         _approve(to, tokenId);
1374     }
1375     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1376         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1377 
1378         return _tokenApprovals[tokenId];
1379     }
1380     function setApprovalForAll(address operator, bool approved) public virtual override {
1381         require(operator != _msgSender(), "ERC721: approve to caller");
1382 
1383         _operatorApprovals[_msgSender()][operator] = approved;
1384         emit ApprovalForAll(_msgSender(), operator, approved);
1385     }
1386     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1387         return _operatorApprovals[owner][operator];
1388     }
1389     function transferFrom(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) public virtual override {
1394         //solhint-disable-next-line max-line-length
1395         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1396 
1397         _transfer(from, to, tokenId);
1398     }
1399     function safeTransferFrom(
1400         address from,
1401         address to,
1402         uint256 tokenId
1403     ) public virtual override {
1404         safeTransferFrom(from, to, tokenId, "");
1405     }
1406     function safeTransferFrom(
1407         address from,
1408         address to,
1409         uint256 tokenId,
1410         bytes memory _data
1411     ) public virtual override {
1412         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1413         _safeTransfer(from, to, tokenId, _data);
1414     }     
1415     function _safeTransfer(
1416         address from,
1417         address to,
1418         uint256 tokenId,
1419         bytes memory _data
1420     ) internal virtual {
1421         _transfer(from, to, tokenId);
1422         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1423     }
1424 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
1425         return tokenId < _owners.length && _owners[tokenId] != address(0);
1426     }
1427 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1428         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1429         address owner = ERC721.ownerOf(tokenId);
1430         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1431     }
1432 	function _safeMint(address to, uint256 tokenId) internal virtual {
1433         _safeMint(to, tokenId, "");
1434     }
1435 	function _safeMint(
1436         address to,
1437         uint256 tokenId,
1438         bytes memory _data
1439     ) internal virtual {
1440         _mint(to, tokenId);
1441         require(
1442             _checkOnERC721Received(address(0), to, tokenId, _data),
1443             "ERC721: transfer to non ERC721Receiver implementer"
1444         );
1445     }
1446 	function _mint(address to, uint256 tokenId) internal virtual {
1447         require(to != address(0), "ERC721: mint to the zero address");
1448         require(!_exists(tokenId), "ERC721: token already minted");
1449 
1450         _beforeTokenTransfer(address(0), to, tokenId);
1451         _owners.push(to);
1452 
1453         emit Transfer(address(0), to, tokenId);
1454     }
1455 	function _burn(uint256 tokenId) internal virtual {
1456         address owner = ERC721.ownerOf(tokenId);
1457 
1458         _beforeTokenTransfer(owner, address(0), tokenId);
1459 
1460         // Clear approvals
1461         _approve(address(0), tokenId);
1462         _owners[tokenId] = address(0);
1463 
1464         emit Transfer(owner, address(0), tokenId);
1465     }
1466 	function _transfer(
1467         address from,
1468         address to,
1469         uint256 tokenId
1470     ) internal virtual {
1471         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1472         require(to != address(0), "ERC721: transfer to the zero address");
1473 
1474         _beforeTokenTransfer(from, to, tokenId);
1475 
1476         // Clear approvals from the previous owner
1477         _approve(address(0), tokenId);
1478         _owners[tokenId] = to;
1479 
1480         emit Transfer(from, to, tokenId);
1481     }
1482 	function _approve(address to, uint256 tokenId) internal virtual {
1483         _tokenApprovals[tokenId] = to;
1484         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1485     }
1486 	function _checkOnERC721Received(
1487         address from,
1488         address to,
1489         uint256 tokenId,
1490         bytes memory _data
1491     ) private returns (bool) {
1492         if (to.isContract()) {
1493             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1494                 return retval == IERC721Receiver.onERC721Received.selector;
1495             } catch (bytes memory reason) {
1496                 if (reason.length == 0) {
1497                     revert("ERC721: transfer to non ERC721Receiver implementer");
1498                 } else {
1499                     assembly {
1500                         revert(add(32, reason), mload(reason))
1501                     }
1502                 }
1503             }
1504         } else {
1505             return true;
1506         }
1507     }
1508 	function _beforeTokenTransfer(
1509         address from,
1510         address to,
1511         uint256 tokenId
1512     ) internal virtual {}
1513 }
1514 
1515 pragma solidity ^0.8.0;
1516 
1517 abstract contract ERC1155Supply is ERC1155 {
1518     mapping(uint256 => uint256) private _totalSupply;
1519 
1520     /**
1521      * @dev Total amount of tokens in with a given id.
1522      */
1523     function totalSupply(uint256 id) public view virtual returns (uint256) {
1524         return _totalSupply[id];
1525     }
1526 
1527     /**
1528      * @dev Indicates whether any token exist with a given id, or not.
1529      */
1530     function exists(uint256 id) public view virtual returns (bool) {
1531         return ERC1155Supply.totalSupply(id) > 0;
1532     }
1533 
1534     /**
1535      * @dev See {ERC1155-_beforeTokenTransfer}.
1536      */
1537     function _beforeTokenTransfer(
1538         address operator,
1539         address from,
1540         address to,
1541         uint256[] memory ids,
1542         uint256[] memory amounts,
1543         bytes memory data
1544     ) internal virtual override {
1545         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1546 
1547         if (from == address(0)) {
1548             for (uint256 i = 0; i < ids.length; ++i) {
1549                 _totalSupply[ids[i]] += amounts[i];
1550             }
1551         }
1552 
1553         if (to == address(0)) {
1554             for (uint256 i = 0; i < ids.length; ++i) {
1555                 _totalSupply[ids[i]] -= amounts[i];
1556             }
1557         }
1558     }
1559 }
1560 
1561 // File: ERC721Enumerable.sol
1562 
1563 
1564 pragma solidity ^0.8.10;
1565 
1566 
1567 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1568     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1569         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1570     }
1571     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
1572         require(index < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
1573         uint count;
1574         for( uint i; i < _owners.length; ++i ){
1575             if( owner == _owners[i] ){
1576                 if( count == index )
1577                     return i;
1578                 else
1579                     ++count;
1580             }
1581         }
1582         require(false, "ERC721Enum: owner ioob");
1583     }
1584     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1585         require(0 < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
1586         uint256 tokenCount = balanceOf(owner);
1587         uint256[] memory tokenIds = new uint256[](tokenCount);
1588         for (uint256 i = 0; i < tokenCount; i++) {
1589             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
1590         }
1591         return tokenIds;
1592     }
1593     function totalSupply() public view virtual override returns (uint256) {
1594         return _owners.length;
1595     }
1596     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1597         require(index < ERC721Enumerable.totalSupply(), "ERC721Enum: global ioob");
1598         return index;
1599     }
1600 }
1601 
1602 pragma solidity ^0.8.9;
1603 
1604 abstract contract ILLUMINATI {
1605   function ownerOf(uint256 tokenId) public virtual view returns (address);
1606   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1607   function balanceOf(address owner) external virtual view returns (uint256 balance);
1608   function tokensOfOwner(address owner) public virtual view returns (uint256[] memory);
1609 }
1610 
1611 contract TRUTH is ERC1155, Ownable {
1612 	using Strings for string;
1613 
1614 	mapping(uint256 => bool) public claimTracker;
1615 
1616 	ILLUMINATI private illuminati;
1617 
1618 	uint256 constant nft1 = 1;
1619 	uint constant public maxSupply = 8128;
1620     uint public airdropped = 2210;
1621     uint  public claimedCount = airdropped; //start at airdropped
1622 
1623 	string public _baseURI;
1624 	string public _contractURI;
1625 
1626 	bool public claimLive = false;
1627 
1628     string name_;
1629     string symbol_;   
1630 
1631 	constructor(
1632         address illuminatiContractAddress,
1633         string memory _name,
1634         string memory _symbol
1635         ) 
1636 		ERC1155(_baseURI)  {
1637         name_ = _name;
1638         symbol_ = _symbol;
1639 		illuminati = ILLUMINATI(illuminatiContractAddress);
1640 	}
1641 
1642 	// claim function
1643     function claim(uint256[] calldata illuminatiIDs) external {		
1644 		//initial checks
1645 		require(claimLive,"Claim Window is not live");
1646 		require(illuminatiIDs.length > 0,"You must claim at least 1 token"); // you must claim
1647 	
1648 		// checks
1649 		for(uint256 x = 0; x < illuminatiIDs.length; x++) {
1650 		require(illuminati.ownerOf(illuminatiIDs[x]) == msg.sender,"You do not own these Illuminati"); //check inputted balance
1651 		require(claimTracker[illuminatiIDs[x]] == false,"An inputted token was already claimed"); //check if inputted tokens claimed
1652 		claimTracker[illuminatiIDs[x]] = true; //track claims
1653         }
1654         _mint(msg.sender, nft1, illuminatiIDs.length, ""); //mint 1 per
1655         claimedCount += illuminatiIDs.length;
1656     }
1657 
1658 	// aidrop function
1659     function aidrop(uint256[] calldata illuminatiIDs, address[] calldata addr) public onlyOwner {		
1660 		for(uint256 x = 0; x < illuminatiIDs.length; x++) {
1661         _mint(addr[x], nft1, 1, ""); //mint 1 per
1662     	claimTracker[illuminatiIDs[x]] = true; //track claims
1663         }
1664     }
1665 
1666 	// admin claim (token 0)
1667     function claimStartingToken(uint256 illuminatiID) external onlyOwner {		
1668 		require(illuminatiID == 0,"You must claimtoken 0"); // you must claim
1669          _mint(msg.sender, nft1, 1, ""); //mint 1 per
1670 		 claimTracker[illuminatiID] = true; //track claims
1671          claimedCount += 1;
1672     }
1673 
1674 	//metadata
1675 	function setBaseURI(string memory newuri) public onlyOwner {
1676 		_baseURI = newuri;
1677 	}
1678 
1679 	function setContractURI(string memory newuri) public onlyOwner {
1680 		_contractURI = newuri;
1681 	}
1682 
1683 	function uri(uint256 tokenId) public view override returns (string memory) {
1684 		return string(abi.encodePacked(_baseURI, uint2str(tokenId)));
1685 	}
1686 
1687 	function contractURI() public view returns (string memory) {
1688 		return _contractURI;
1689 	}
1690 
1691 	function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1692 		if (_i == 0) {return "0";}
1693 			uint256 j = _i;
1694 			uint256 len;
1695 		while (j != 0) {len++; j /= 10;}
1696 			bytes memory bstr = new bytes(len);
1697 			uint256 k = len;
1698 		while (_i != 0) {
1699 			k = k - 1;
1700 			uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
1701 			bytes1 b1 = bytes1(temp);
1702 			bstr[k] = b1;
1703 			_i /= 10;
1704 		}
1705 		return string(bstr);
1706 	}
1707 
1708 	// enables claim
1709 	function setClaimLive(bool _live) external onlyOwner {
1710 		claimLive = _live;
1711 	}
1712 
1713 	//check claim by token
1714 	function checkClaimed(uint256 tokenId) public view returns (bool) {
1715 		return claimTracker[tokenId];
1716 	}
1717 
1718     function totalSupply() public view returns (uint){
1719         return claimedCount;
1720     }
1721 
1722 	//check Illuminati Tokens
1723 	function checkIlluminatiTokens(address owner) public view returns (uint256[] memory){
1724 		uint256 tokenCount = illuminati.balanceOf(owner);
1725 		uint256[] memory tokenIds = new uint256[](tokenCount);
1726         for (uint256 i = 0; i < tokenCount; i++) {
1727             tokenIds[i] = illuminati.tokenOfOwnerByIndex(owner, i);
1728         }
1729 		return tokenIds;
1730 	}
1731 
1732     function name() public view returns (string memory) {
1733         return name_;
1734     }
1735 
1736     function symbol() public view returns (string memory) {
1737         return symbol_;
1738     }       
1739 
1740 	//withdraw any funds
1741 	function withdrawToOwner() external onlyOwner {
1742 		payable(msg.sender).transfer(address(this).balance);
1743 	}
1744 
1745 
1746 
1747 }