1 // File: out/CloudedCrew_flat.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
30 
31 
32 
33 /**
34  * @dev Provides information about the current execution context, including the
35  * sender of the transaction and its data. While these are generally available
36  * via msg.sender and msg.data, they should not be accessed in such a direct
37  * manner, since when dealing with meta-transactions the account sending and
38  * paying for execution may not be the actual sender (as far as an application
39  * is concerned).
40  *
41  * This contract is only required for intermediate, library-like contracts.
42  */
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes calldata) {
49         return msg.data;
50     }
51 }
52 
53 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
54 
55 
56 
57 /**
58  * @dev String operations.
59  */
60 library Strings {
61     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
65      */
66     function toString(uint256 value) internal pure returns (string memory) {
67         // Inspired by OraclizeAPI's implementation - MIT licence
68         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
69 
70         if (value == 0) {
71             return "0";
72         }
73         uint256 temp = value;
74         uint256 digits;
75         while (temp != 0) {
76             digits++;
77             temp /= 10;
78         }
79         bytes memory buffer = new bytes(digits);
80         while (value != 0) {
81             digits -= 1;
82             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
83             value /= 10;
84         }
85         return string(buffer);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
90      */
91     function toHexString(uint256 value) internal pure returns (string memory) {
92         if (value == 0) {
93             return "0x00";
94         }
95         uint256 temp = value;
96         uint256 length = 0;
97         while (temp != 0) {
98             length++;
99             temp >>= 8;
100         }
101         return toHexString(value, length);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
106      */
107     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
108         bytes memory buffer = new bytes(2 * length + 2);
109         buffer[0] = "0";
110         buffer[1] = "x";
111         for (uint256 i = 2 * length + 1; i > 1; --i) {
112             buffer[i] = _HEX_SYMBOLS[value & 0xf];
113             value >>= 4;
114         }
115         require(value == 0, "Strings: hex length insufficient");
116         return string(buffer);
117     }
118 }
119 
120 
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
124 
125 
126 
127 
128 
129 /**
130  * @dev Contract module which provides a basic access control mechanism, where
131  * there is an account (an owner) that can be granted exclusive access to
132  * specific functions.
133  *
134  * By default, the owner account will be the one that deploys the contract. This
135  * can later be changed with {transferOwnership}.
136  *
137  * This module is used through inheritance. It will make available the modifier
138  * `onlyOwner`, which can be applied to your functions to restrict their use to
139  * the owner.
140  */
141 abstract contract Ownable is Context {
142     address private _owner;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     /**
147      * @dev Initializes the contract setting the deployer as the initial owner.
148      */
149     constructor() {
150         _transferOwnership(_msgSender());
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view virtual returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         require(owner() == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         _transferOwnership(address(0));
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Can only be called by the current owner.
182      */
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         _transferOwnership(newOwner);
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Internal function without access restriction.
191      */
192     function _transferOwnership(address newOwner) internal virtual {
193         address oldOwner = _owner;
194         _owner = newOwner;
195         emit OwnershipTransferred(oldOwner, newOwner);
196     }
197 }
198 
199 
200 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
201 
202 
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
206 
207 
208 
209 
210 
211 /**
212  * @dev Required interface of an ERC1155 compliant contract, as defined in the
213  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
214  *
215  * _Available since v3.1._
216  */
217 interface IERC1155 is IERC165 {
218     /**
219      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
220      */
221     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
222 
223     /**
224      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
225      * transfers.
226      */
227     event TransferBatch(
228         address indexed operator,
229         address indexed from,
230         address indexed to,
231         uint256[] ids,
232         uint256[] values
233     );
234 
235     /**
236      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
237      * `approved`.
238      */
239     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
240 
241     /**
242      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
243      *
244      * If an {URI} event was emitted for `id`, the standard
245      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
246      * returned by {IERC1155MetadataURI-uri}.
247      */
248     event URI(string value, uint256 indexed id);
249 
250     /**
251      * @dev Returns the amount of tokens of token type `id` owned by `account`.
252      *
253      * Requirements:
254      *
255      * - `account` cannot be the zero address.
256      */
257     function balanceOf(address account, uint256 id) external view returns (uint256);
258 
259     /**
260      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
261      *
262      * Requirements:
263      *
264      * - `accounts` and `ids` must have the same length.
265      */
266     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
267         external
268         view
269         returns (uint256[] memory);
270 
271     /**
272      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
273      *
274      * Emits an {ApprovalForAll} event.
275      *
276      * Requirements:
277      *
278      * - `operator` cannot be the caller.
279      */
280     function setApprovalForAll(address operator, bool approved) external;
281 
282     /**
283      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
284      *
285      * See {setApprovalForAll}.
286      */
287     function isApprovedForAll(address account, address operator) external view returns (bool);
288 
289     /**
290      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
291      *
292      * Emits a {TransferSingle} event.
293      *
294      * Requirements:
295      *
296      * - `to` cannot be the zero address.
297      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
298      * - `from` must have a balance of tokens of type `id` of at least `amount`.
299      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
300      * acceptance magic value.
301      */
302     function safeTransferFrom(
303         address from,
304         address to,
305         uint256 id,
306         uint256 amount,
307         bytes calldata data
308     ) external;
309 
310     /**
311      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
312      *
313      * Emits a {TransferBatch} event.
314      *
315      * Requirements:
316      *
317      * - `ids` and `amounts` must have the same length.
318      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
319      * acceptance magic value.
320      */
321     function safeBatchTransferFrom(
322         address from,
323         address to,
324         uint256[] calldata ids,
325         uint256[] calldata amounts,
326         bytes calldata data
327     ) external;
328 }
329 
330 
331 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
332 
333 
334 
335 
336 
337 /**
338  * @dev _Available since v3.1._
339  */
340 interface IERC1155Receiver is IERC165 {
341     /**
342      * @dev Handles the receipt of a single ERC1155 token type. This function is
343      * called at the end of a `safeTransferFrom` after the balance has been updated.
344      *
345      * NOTE: To accept the transfer, this must return
346      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
347      * (i.e. 0xf23a6e61, or its own function selector).
348      *
349      * @param operator The address which initiated the transfer (i.e. msg.sender)
350      * @param from The address which previously owned the token
351      * @param id The ID of the token being transferred
352      * @param value The amount of tokens being transferred
353      * @param data Additional data with no specified format
354      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
355      */
356     function onERC1155Received(
357         address operator,
358         address from,
359         uint256 id,
360         uint256 value,
361         bytes calldata data
362     ) external returns (bytes4);
363 
364     /**
365      * @dev Handles the receipt of a multiple ERC1155 token types. This function
366      * is called at the end of a `safeBatchTransferFrom` after the balances have
367      * been updated.
368      *
369      * NOTE: To accept the transfer(s), this must return
370      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
371      * (i.e. 0xbc197c81, or its own function selector).
372      *
373      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
374      * @param from The address which previously owned the token
375      * @param ids An array containing ids of each token being transferred (order and length must match values array)
376      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
377      * @param data Additional data with no specified format
378      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
379      */
380     function onERC1155BatchReceived(
381         address operator,
382         address from,
383         uint256[] calldata ids,
384         uint256[] calldata values,
385         bytes calldata data
386     ) external returns (bytes4);
387 }
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
391 
392 
393 
394 
395 
396 /**
397  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
398  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
399  *
400  * _Available since v3.1._
401  */
402 interface IERC1155MetadataURI is IERC1155 {
403     /**
404      * @dev Returns the URI for token type `id`.
405      *
406      * If the `\{id\}` substring is present in the URI, it must be replaced by
407      * clients with the actual token type ID.
408      */
409     function uri(uint256 id) external view returns (string memory);
410 }
411 
412 
413 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
414 
415 
416 
417 /**
418  * @dev Collection of functions related to the address type
419  */
420 library Address {
421     /**
422      * @dev Returns true if `account` is a contract.
423      *
424      * [IMPORTANT]
425      * ====
426      * It is unsafe to assume that an address for which this function returns
427      * false is an externally-owned account (EOA) and not a contract.
428      *
429      * Among others, `isContract` will return false for the following
430      * types of addresses:
431      *
432      *  - an externally-owned account
433      *  - a contract in construction
434      *  - an address where a contract will be created
435      *  - an address where a contract lived, but was destroyed
436      * ====
437      *
438      * [IMPORTANT]
439      * ====
440      * You shouldn't rely on `isContract` to protect against flash loan attacks!
441      *
442      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
443      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
444      * constructor.
445      * ====
446      */
447     function isContract(address account) internal view returns (bool) {
448         // This method relies on extcodesize/address.code.length, which returns 0
449         // for contracts in construction, since the code is only stored at the end
450         // of the constructor execution.
451 
452         return account.code.length > 0;
453     }
454 
455     /**
456      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
457      * `recipient`, forwarding all available gas and reverting on errors.
458      *
459      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
460      * of certain opcodes, possibly making contracts go over the 2300 gas limit
461      * imposed by `transfer`, making them unable to receive funds via
462      * `transfer`. {sendValue} removes this limitation.
463      *
464      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
465      *
466      * IMPORTANT: because control is transferred to `recipient`, care must be
467      * taken to not create reentrancy vulnerabilities. Consider using
468      * {ReentrancyGuard} or the
469      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
470      */
471     function sendValue(address payable recipient, uint256 amount) internal {
472         require(address(this).balance >= amount, "Address: insufficient balance");
473 
474         (bool success, ) = recipient.call{value: amount}("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 
478     /**
479      * @dev Performs a Solidity function call using a low level `call`. A
480      * plain `call` is an unsafe replacement for a function call: use this
481      * function instead.
482      *
483      * If `target` reverts with a revert reason, it is bubbled up by this
484      * function (like regular Solidity function calls).
485      *
486      * Returns the raw returned data. To convert to the expected return value,
487      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
488      *
489      * Requirements:
490      *
491      * - `target` must be a contract.
492      * - calling `target` with `data` must not revert.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionCall(target, data, "Address: low-level call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
502      * `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, 0, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but also transferring `value` wei to `target`.
517      *
518      * Requirements:
519      *
520      * - the calling contract must have an ETH balance of at least `value`.
521      * - the called Solidity function must be `payable`.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
535      * with `errorMessage` as a fallback revert reason when `target` reverts.
536      *
537      * _Available since v3.1._
538      */
539     function functionCallWithValue(
540         address target,
541         bytes memory data,
542         uint256 value,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         require(address(this).balance >= value, "Address: insufficient balance for call");
546         require(isContract(target), "Address: call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.call{value: value}(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
559         return functionStaticCall(target, data, "Address: low-level static call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a static call.
565      *
566      * _Available since v3.3._
567      */
568     function functionStaticCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal view returns (bytes memory) {
573         require(isContract(target), "Address: static call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.staticcall(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a delegate call.
582      *
583      * _Available since v3.4._
584      */
585     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
586         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a delegate call.
592      *
593      * _Available since v3.4._
594      */
595     function functionDelegateCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         require(isContract(target), "Address: delegate call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.delegatecall(data);
603         return verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
608      * revert reason using the provided one.
609      *
610      * _Available since v4.3._
611      */
612     function verifyCallResult(
613         bool success,
614         bytes memory returndata,
615         string memory errorMessage
616     ) internal pure returns (bytes memory) {
617         if (success) {
618             return returndata;
619         } else {
620             // Look for revert reason and bubble it up if present
621             if (returndata.length > 0) {
622                 // The easiest way to bubble the revert reason is using memory via assembly
623 
624                 assembly {
625                     let returndata_size := mload(returndata)
626                     revert(add(32, returndata), returndata_size)
627                 }
628             } else {
629                 revert(errorMessage);
630             }
631         }
632     }
633 }
634 
635 
636 
637 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
638 
639 
640 
641 
642 
643 /**
644  * @dev Implementation of the {IERC165} interface.
645  *
646  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
647  * for the additional interface id that will be supported. For example:
648  *
649  * ```solidity
650  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
651  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
652  * }
653  * ```
654  *
655  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
656  */
657 abstract contract ERC165 is IERC165 {
658     /**
659      * @dev See {IERC165-supportsInterface}.
660      */
661     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
662         return interfaceId == type(IERC165).interfaceId;
663     }
664 }
665 
666 
667 /**
668  * @dev Implementation of the basic standard multi-token.
669  * See https://eips.ethereum.org/EIPS/eip-1155
670  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
671  *
672  * _Available since v3.1._
673  */
674 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
675     using Address for address;
676 
677     // Mapping from token ID to account balances
678     mapping(uint256 => mapping(address => uint256)) private _balances;
679 
680     // Mapping from account to operator approvals
681     mapping(address => mapping(address => bool)) private _operatorApprovals;
682 
683     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
684     string private _uri;
685 
686     /**
687      * @dev See {_setURI}.
688      */
689     constructor(string memory uri_) {
690         _setURI(uri_);
691     }
692 
693     /**
694      * @dev See {IERC165-supportsInterface}.
695      */
696     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
697         return
698             interfaceId == type(IERC1155).interfaceId ||
699             interfaceId == type(IERC1155MetadataURI).interfaceId ||
700             super.supportsInterface(interfaceId);
701     }
702 
703     /**
704      * @dev See {IERC1155MetadataURI-uri}.
705      *
706      * This implementation returns the same URI for *all* token types. It relies
707      * on the token type ID substitution mechanism
708      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
709      *
710      * Clients calling this function must replace the `\{id\}` substring with the
711      * actual token type ID.
712      */
713     function uri(uint256) public view virtual override returns (string memory) {
714         return _uri;
715     }
716 
717     /**
718      * @dev See {IERC1155-balanceOf}.
719      *
720      * Requirements:
721      *
722      * - `account` cannot be the zero address.
723      */
724     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
725         require(account != address(0), "ERC1155: balance query for the zero address");
726         return _balances[id][account];
727     }
728 
729     /**
730      * @dev See {IERC1155-balanceOfBatch}.
731      *
732      * Requirements:
733      *
734      * - `accounts` and `ids` must have the same length.
735      */
736     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
737         public
738         view
739         virtual
740         override
741         returns (uint256[] memory)
742     {
743         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
744 
745         uint256[] memory batchBalances = new uint256[](accounts.length);
746 
747         for (uint256 i = 0; i < accounts.length; ++i) {
748             batchBalances[i] = balanceOf(accounts[i], ids[i]);
749         }
750 
751         return batchBalances;
752     }
753 
754     /**
755      * @dev See {IERC1155-setApprovalForAll}.
756      */
757     function setApprovalForAll(address operator, bool approved) public virtual override {
758         _setApprovalForAll(_msgSender(), operator, approved);
759     }
760 
761     /**
762      * @dev See {IERC1155-isApprovedForAll}.
763      */
764     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
765         return _operatorApprovals[account][operator];
766     }
767 
768     /**
769      * @dev See {IERC1155-safeTransferFrom}.
770      */
771     function safeTransferFrom(
772         address from,
773         address to,
774         uint256 id,
775         uint256 amount,
776         bytes memory data
777     ) public virtual override {
778         require(
779             from == _msgSender() || isApprovedForAll(from, _msgSender()),
780             "ERC1155: caller is not owner nor approved"
781         );
782         _safeTransferFrom(from, to, id, amount, data);
783     }
784 
785     /**
786      * @dev See {IERC1155-safeBatchTransferFrom}.
787      */
788     function safeBatchTransferFrom(
789         address from,
790         address to,
791         uint256[] memory ids,
792         uint256[] memory amounts,
793         bytes memory data
794     ) public virtual override {
795         require(
796             from == _msgSender() || isApprovedForAll(from, _msgSender()),
797             "ERC1155: transfer caller is not owner nor approved"
798         );
799         _safeBatchTransferFrom(from, to, ids, amounts, data);
800     }
801 
802     /**
803      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
804      *
805      * Emits a {TransferSingle} event.
806      *
807      * Requirements:
808      *
809      * - `to` cannot be the zero address.
810      * - `from` must have a balance of tokens of type `id` of at least `amount`.
811      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
812      * acceptance magic value.
813      */
814     function _safeTransferFrom(
815         address from,
816         address to,
817         uint256 id,
818         uint256 amount,
819         bytes memory data
820     ) internal virtual {
821         require(to != address(0), "ERC1155: transfer to the zero address");
822 
823         address operator = _msgSender();
824 
825         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
826 
827         uint256 fromBalance = _balances[id][from];
828         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
829         unchecked {
830             _balances[id][from] = fromBalance - amount;
831         }
832         _balances[id][to] += amount;
833 
834         emit TransferSingle(operator, from, to, id, amount);
835 
836         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
837     }
838 
839     /**
840      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
841      *
842      * Emits a {TransferBatch} event.
843      *
844      * Requirements:
845      *
846      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
847      * acceptance magic value.
848      */
849     function _safeBatchTransferFrom(
850         address from,
851         address to,
852         uint256[] memory ids,
853         uint256[] memory amounts,
854         bytes memory data
855     ) internal virtual {
856         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
857         require(to != address(0), "ERC1155: transfer to the zero address");
858 
859         address operator = _msgSender();
860 
861         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
862 
863         for (uint256 i = 0; i < ids.length; ++i) {
864             uint256 id = ids[i];
865             uint256 amount = amounts[i];
866 
867             uint256 fromBalance = _balances[id][from];
868             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
869             unchecked {
870                 _balances[id][from] = fromBalance - amount;
871             }
872             _balances[id][to] += amount;
873         }
874 
875         emit TransferBatch(operator, from, to, ids, amounts);
876 
877         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
878     }
879 
880     /**
881      * @dev Sets a new URI for all token types, by relying on the token type ID
882      * substitution mechanism
883      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
884      *
885      * By this mechanism, any occurrence of the `\{id\}` substring in either the
886      * URI or any of the amounts in the JSON file at said URI will be replaced by
887      * clients with the token type ID.
888      *
889      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
890      * interpreted by clients as
891      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
892      * for token type ID 0x4cce0.
893      *
894      * See {uri}.
895      *
896      * Because these URIs cannot be meaningfully represented by the {URI} event,
897      * this function emits no events.
898      */
899     function _setURI(string memory newuri) internal virtual {
900         _uri = newuri;
901     }
902 
903     /**
904      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
905      *
906      * Emits a {TransferSingle} event.
907      *
908      * Requirements:
909      *
910      * - `to` cannot be the zero address.
911      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
912      * acceptance magic value.
913      */
914     function _mint(
915         address to,
916         uint256 id,
917         uint256 amount,
918         bytes memory data
919     ) internal virtual {
920         require(to != address(0), "ERC1155: mint to the zero address");
921 
922         address operator = _msgSender();
923 
924         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
925 
926         _balances[id][to] += amount;
927         emit TransferSingle(operator, address(0), to, id, amount);
928 
929         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
930     }
931 
932     /**
933      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
934      *
935      * Requirements:
936      *
937      * - `ids` and `amounts` must have the same length.
938      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
939      * acceptance magic value.
940      */
941     function _mintBatch(
942         address to,
943         uint256[] memory ids,
944         uint256[] memory amounts,
945         bytes memory data
946     ) internal virtual {
947         require(to != address(0), "ERC1155: mint to the zero address");
948         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
949 
950         address operator = _msgSender();
951 
952         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
953 
954         for (uint256 i = 0; i < ids.length; i++) {
955             _balances[ids[i]][to] += amounts[i];
956         }
957 
958         emit TransferBatch(operator, address(0), to, ids, amounts);
959 
960         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
961     }
962 
963     /**
964      * @dev Destroys `amount` tokens of token type `id` from `from`
965      *
966      * Requirements:
967      *
968      * - `from` cannot be the zero address.
969      * - `from` must have at least `amount` tokens of token type `id`.
970      */
971     function _burn(
972         address from,
973         uint256 id,
974         uint256 amount
975     ) internal virtual {
976         require(from != address(0), "ERC1155: burn from the zero address");
977 
978         address operator = _msgSender();
979 
980         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
981 
982         uint256 fromBalance = _balances[id][from];
983         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
984         unchecked {
985             _balances[id][from] = fromBalance - amount;
986         }
987 
988         emit TransferSingle(operator, from, address(0), id, amount);
989     }
990 
991     /**
992      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
993      *
994      * Requirements:
995      *
996      * - `ids` and `amounts` must have the same length.
997      */
998     function _burnBatch(
999         address from,
1000         uint256[] memory ids,
1001         uint256[] memory amounts
1002     ) internal virtual {
1003         require(from != address(0), "ERC1155: burn from the zero address");
1004         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1005 
1006         address operator = _msgSender();
1007 
1008         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1009 
1010         for (uint256 i = 0; i < ids.length; i++) {
1011             uint256 id = ids[i];
1012             uint256 amount = amounts[i];
1013 
1014             uint256 fromBalance = _balances[id][from];
1015             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1016             unchecked {
1017                 _balances[id][from] = fromBalance - amount;
1018             }
1019         }
1020 
1021         emit TransferBatch(operator, from, address(0), ids, amounts);
1022     }
1023 
1024     /**
1025      * @dev Approve `operator` to operate on all of `owner` tokens
1026      *
1027      * Emits a {ApprovalForAll} event.
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
1044      * transfers, the length of the `id` and `amount` arrays will be 1.
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
1068     function _doSafeTransferAcceptanceCheck(
1069         address operator,
1070         address from,
1071         address to,
1072         uint256 id,
1073         uint256 amount,
1074         bytes memory data
1075     ) private {
1076         if (to.isContract()) {
1077             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1078                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1079                     revert("ERC1155: ERC1155Receiver rejected tokens");
1080                 }
1081             } catch Error(string memory reason) {
1082                 revert(reason);
1083             } catch {
1084                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1085             }
1086         }
1087     }
1088 
1089     function _doSafeBatchTransferAcceptanceCheck(
1090         address operator,
1091         address from,
1092         address to,
1093         uint256[] memory ids,
1094         uint256[] memory amounts,
1095         bytes memory data
1096     ) private {
1097         if (to.isContract()) {
1098             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1099                 bytes4 response
1100             ) {
1101                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1102                     revert("ERC1155: ERC1155Receiver rejected tokens");
1103                 }
1104             } catch Error(string memory reason) {
1105                 revert(reason);
1106             } catch {
1107                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1108             }
1109         }
1110     }
1111 
1112     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1113         uint256[] memory array = new uint256[](1);
1114         array[0] = element;
1115 
1116         return array;
1117     }
1118 }
1119 
1120 
1121 
1122 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1123 
1124 
1125 
1126 /**
1127  * @dev These functions deal with verification of Merkle Trees proofs.
1128  *
1129  * The proofs can be generated using the JavaScript library
1130  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1131  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1132  *
1133  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1134  */
1135 library MerkleProof {
1136     /**
1137      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1138      * defined by `root`. For this, a `proof` must be provided, containing
1139      * sibling hashes on the branch from the leaf to the root of the tree. Each
1140      * pair of leaves and each pair of pre-images are assumed to be sorted.
1141      */
1142     function verify(
1143         bytes32[] memory proof,
1144         bytes32 root,
1145         bytes32 leaf
1146     ) internal pure returns (bool) {
1147         return processProof(proof, leaf) == root;
1148     }
1149 
1150     /**
1151      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1152      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1153      * hash matches the root of the tree. When processing the proof, the pairs
1154      * of leafs & pre-images are assumed to be sorted.
1155      *
1156      * _Available since v4.4._
1157      */
1158     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1159         bytes32 computedHash = leaf;
1160         for (uint256 i = 0; i < proof.length; i++) {
1161             bytes32 proofElement = proof[i];
1162             if (computedHash <= proofElement) {
1163                 // Hash(current computed hash + current element of the proof)
1164                 computedHash = _efficientHash(computedHash, proofElement);
1165             } else {
1166                 // Hash(current element of the proof + current computed hash)
1167                 computedHash = _efficientHash(proofElement, computedHash);
1168             }
1169         }
1170         return computedHash;
1171     }
1172 
1173     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1174         assembly {
1175             mstore(0x00, a)
1176             mstore(0x20, b)
1177             value := keccak256(0x00, 0x40)
1178         }
1179     }
1180 }
1181 
1182 
1183 contract OwnableDelegateProxy {}
1184 
1185 /**
1186 Used to delegate ownership of a contract to another address, to save on unneeded transactions to approve contract use for users
1187  */
1188 contract ProxyRegistry {
1189     mapping(address => OwnableDelegateProxy) public proxies;
1190 }
1191 
1192 /////////////////////////////////
1193 /// ERRORS
1194 /////////////////////////////////
1195 
1196 error PresaleNotActive();
1197 error PresaleIsActive();
1198 error SalePaused();
1199 error InvalidPresaleAmount();
1200 error NotOnWhitelist();
1201 error InvalidQuantity();
1202 error InsufficientETH();
1203 error InvalidTokenID();
1204 error InvalidGeneralSaleQuantity();
1205 error FreeSupplyStillAvailable();
1206 
1207 /// @title CloudedCrew
1208 ///@author Karsh Sinha <karsh@hey.com>
1209 contract CloudedCrew is ERC1155, Ownable {
1210     /////////////////////////////////
1211     /// PUBLIC VARS
1212     /////////////////////////////////
1213 
1214     string public name;
1215     bool public isPresaleActive = true;
1216     bool public isSalePaused = false;
1217     mapping(address => uint256) public presaleMintCount;
1218     mapping(address => uint256) public freeSupplyMintCount;
1219     mapping(address => uint256) public generalSaleMintCount;
1220     uint256 public currentTokenID = 1;
1221     bytes32 public whitelist_merkle_tree_root;
1222     uint256 public minting_fee = 0.0333 ether;
1223 
1224     /////////////////////////////////
1225     /// CONSTANTS
1226     /////////////////////////////////
1227 
1228     string public constant METADATA_PROVENANCE_HASH =
1229         "0xf7be2e1dcabf611b83404e57c13cc31947115973d6716ba6a6f688a7209c4931";
1230     uint256 public constant MAX_NFT_SUPPLY = 3333;
1231     uint256 public constant MAX_FREE_SUPPLY = 2333;
1232     uint256 public constant MAX_PRESALE_MINT_COUNT = 3;
1233     uint256 public constant MAX_FREE_SUPPLY_MINT_COUNT = 6;
1234     uint256 public constant MAX_GENERAL_SALE_MINT_COUNT = 6;
1235 
1236     /////////////////////////////////
1237     /// PRIVATE VARS
1238     /////////////////////////////////
1239 
1240     address private _payout_wallet; //TODO: Create splits contract at 0xsplits.xyz before mainnet deployment
1241     address private immutable _PROXY_REGISTRY_ADDRESS;
1242 
1243     /////////////////////////////////
1244     /// MODIFIERS
1245     /////////////////////////////////
1246 
1247     modifier checkPresaleActive() {
1248         if (!isPresaleActive) {
1249             revert PresaleNotActive();
1250         }
1251         _;
1252     }
1253 
1254     modifier checkPresaleInactive() {
1255         if (isPresaleActive) {
1256             revert PresaleIsActive();
1257         }
1258         _;
1259     }
1260 
1261     modifier checkSaleStatus() {
1262         if (isSalePaused) {
1263             revert SalePaused();
1264         }
1265         _;
1266     }
1267 
1268     modifier checkPresaleMintCount(uint256 quantity) {
1269         if (presaleMintCount[msg.sender] + quantity > MAX_PRESALE_MINT_COUNT) {
1270             revert InvalidPresaleAmount();
1271         }
1272         _;
1273     }
1274 
1275     modifier verifyWhitelist(bytes32[] calldata proof) {
1276         if (
1277             !MerkleProof.verify(
1278                 proof,
1279                 whitelist_merkle_tree_root,
1280                 keccak256(abi.encodePacked(msg.sender))
1281             )
1282         ) {
1283             revert NotOnWhitelist();
1284         }
1285         _;
1286     }
1287 
1288     modifier checkMaxSupply(uint256 quantity) {
1289         if (currentTokenID + quantity - 1 > MAX_NFT_SUPPLY) {
1290             revert InvalidQuantity();
1291         }
1292         _;
1293     }
1294 
1295     modifier checkFreeSupply(uint256 quantity) {
1296         if (currentTokenID + quantity - 1 > MAX_FREE_SUPPLY) {
1297             revert InvalidQuantity();
1298         }
1299         _;
1300     }
1301 
1302     modifier checkFreeSupplyMintCount(uint256 quantity) {
1303         if (
1304             freeSupplyMintCount[msg.sender] + quantity >
1305             MAX_FREE_SUPPLY_MINT_COUNT
1306         ) {
1307             revert InvalidQuantity();
1308         }
1309         _;
1310     }
1311 
1312     modifier checkGeneralSaleMintCount(uint256 quantity) {
1313         if (
1314             generalSaleMintCount[msg.sender] + quantity >
1315             MAX_GENERAL_SALE_MINT_COUNT
1316         ) {
1317             revert InvalidGeneralSaleQuantity();
1318         }
1319         _;
1320     }
1321 
1322     modifier checkTokenID(uint256 tokenID) {
1323         if (tokenID > currentTokenID - 1 || tokenID <= 0) {
1324             revert InvalidTokenID();
1325         }
1326         _;
1327     }
1328 
1329     modifier checkValue(uint256 quantity) {
1330         if (msg.value < quantity * minting_fee) {
1331             revert InsufficientETH();
1332         }
1333         _;
1334     }
1335 
1336     modifier checkFreeSupplyDone() {
1337         if (currentTokenID <= MAX_FREE_SUPPLY) {
1338             revert FreeSupplyStillAvailable();
1339         }
1340         _;
1341     }
1342 
1343     /////////////////////////////////
1344     /// CONSTRUCTOR
1345     /////////////////////////////////
1346 
1347     /// @notice Setting base metadata URI to unrevealed metadata during contract deployment. Once all NFTs have been minted, contract owner will update base metadata URI to point to the actual metadata.  To ensure that metadata for each NFT was set prior to contract deployment, we have stored the provenance hash of all metadata JSON files in the contract as METADATA_PROVENANCE_HASH.  This provenance hash was computed by hashing a list of hashes of JSON metadata object for each NFT in order from 1 to MAX_NFT_SUPPLY.  This was done in Python using the web3.solidityKeccak method
1348     constructor(
1349         bytes32 _whitelist_merkle_tree_root,
1350         address payout_wallet,
1351         string memory baseMetadataURI,
1352         address proxyRegistryAddressOpensea
1353     ) ERC1155(baseMetadataURI) {
1354         name = "Clouded Crew";
1355         whitelist_merkle_tree_root = _whitelist_merkle_tree_root;
1356         _payout_wallet = payout_wallet;
1357         _PROXY_REGISTRY_ADDRESS = proxyRegistryAddressOpensea;
1358 
1359         uint256[] memory _ids = new uint256[](33);
1360         uint256[] memory _numTokens = new uint256[](33);
1361 
1362         for (uint256 i = 0; i < 33; i++) {
1363             _ids[i] = currentTokenID + i;
1364             _numTokens[i] = 1;
1365         }
1366         currentTokenID = currentTokenID + 33;
1367         _mintBatch(msg.sender, _ids, _numTokens, "");
1368     }
1369 
1370     /////////////////////////////////
1371     /// EXTERNAL METHODS
1372     /////////////////////////////////
1373 
1374     /// @dev Function to mint presale NFTs
1375     /// @param proof Merkle proof provided by the client
1376     /// @param quantity Number of NFTs to mint
1377     function mintPresale(bytes32[] calldata proof, uint256 quantity)
1378         external
1379         checkPresaleActive
1380         checkSaleStatus
1381         verifyWhitelist(proof)
1382         checkPresaleMintCount(quantity)
1383     {
1384         uint256[] memory _ids = new uint256[](quantity);
1385         uint256[] memory _numTokens = new uint256[](quantity);
1386 
1387         for (uint256 i = 0; i < quantity; i++) {
1388             _ids[i] = currentTokenID + i;
1389             _numTokens[i] = 1;
1390         }
1391         currentTokenID = currentTokenID + quantity;
1392         presaleMintCount[msg.sender] += quantity;
1393         _mintBatch(msg.sender, _ids, _numTokens, "");
1394     }
1395 
1396     /// @dev Mint _quantity number of free NFTs
1397     /// @param quantity Number of NFTs to mint
1398     function mintFree(uint256 quantity)
1399         external
1400         checkPresaleInactive
1401         checkSaleStatus
1402         checkFreeSupplyMintCount(quantity)
1403         checkFreeSupply(quantity)
1404     {
1405         uint256[] memory _ids = new uint256[](quantity);
1406         uint256[] memory _numTokens = new uint256[](quantity);
1407 
1408         for (uint256 i = 0; i < quantity; i++) {
1409             _ids[i] = currentTokenID + i;
1410             _numTokens[i] = 1;
1411         }
1412         currentTokenID = currentTokenID + quantity;
1413         freeSupplyMintCount[msg.sender] += quantity;
1414         _mintBatch(msg.sender, _ids, _numTokens, "");
1415     }
1416 
1417     /// @dev Mint _quantity number of NFTs
1418     /// @param quantity Number of NFTs to mint
1419     function mintRegular(uint256 quantity)
1420         external
1421         payable
1422         checkPresaleInactive
1423         checkSaleStatus
1424         checkFreeSupplyDone
1425         checkMaxSupply(quantity)
1426         checkGeneralSaleMintCount(quantity)
1427         checkValue(quantity)
1428     {
1429         uint256[] memory _ids = new uint256[](quantity);
1430         uint256[] memory _numTokens = new uint256[](quantity);
1431 
1432         for (uint256 i = 0; i < quantity; i++) {
1433             _ids[i] = currentTokenID + i;
1434             _numTokens[i] = 1;
1435         }
1436         currentTokenID = currentTokenID + quantity;
1437         generalSaleMintCount[msg.sender] += quantity;
1438         _mintBatch(msg.sender, _ids, _numTokens, "");
1439     }
1440 
1441     /// @dev Function to start/pause the sale
1442     /// @param status Boolean to set sale to paused or unpaused
1443     function updateSalePausedStatus(bool status) external onlyOwner {
1444         isSalePaused = status;
1445     }
1446 
1447     /// @dev Update presale status
1448     /// @param status The new status of the presale
1449     function updatePresaleStatus(bool status) external onlyOwner {
1450         isPresaleActive = status;
1451     }
1452 
1453     /// @dev Withdraw full balance the splits contract
1454     function withdraw() external onlyOwner {
1455         payable(_payout_wallet).transfer(address(this).balance);
1456     }
1457 
1458     /// @dev Will update the base metadata URI of NFTs
1459     /// @param newBaseMetadataURI New base URL
1460     function setBaseMetadataURI(string calldata newBaseMetadataURI)
1461         external
1462         onlyOwner
1463     {
1464         _setURI(newBaseMetadataURI);
1465     }
1466 
1467     /// @dev Updates the payout wallet
1468     /// @param newPayoutWallet New payout wallet address
1469     function setPayoutWallet(address newPayoutWallet) external onlyOwner {
1470         _payout_wallet = newPayoutWallet;
1471     }
1472 
1473     /// @notice Update merkle tree root
1474     /// @param newMerkleTreeRoot New merkle tree root
1475     function updateWhitelistMerkleTreeRoot(bytes32 newMerkleTreeRoot)
1476         external
1477         onlyOwner
1478     {
1479         whitelist_merkle_tree_root = newMerkleTreeRoot;
1480     }
1481 
1482     /// @notice Update minting fee
1483     /// @param newMintingFee New minting fee
1484     function updateMintingFee(uint256 newMintingFee) external onlyOwner {
1485         minting_fee = newMintingFee;
1486     }
1487 
1488     /////////////////////////////////
1489     /// PUBLIC METHODS
1490     /////////////////////////////////
1491 
1492     bytes4 private constant INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
1493     bytes4 private constant INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
1494 
1495     /// @dev See {IERC165-supportsInterface}.
1496     function supportsInterface(bytes4 interfaceId)
1497         public
1498         view
1499         virtual
1500         override
1501         returns (bool)
1502     {
1503         if (
1504             interfaceId == INTERFACE_SIGNATURE_ERC165 ||
1505             interfaceId == INTERFACE_SIGNATURE_ERC1155
1506         ) {
1507             return true;
1508         }
1509         return false;
1510     }
1511 
1512     /// @dev Generate NFT metadata URI for a given NFT token ID
1513     /// @param tokenID Token ID for the NFT
1514     function uri(uint256 tokenID)
1515         public
1516         view
1517         override
1518         checkTokenID(tokenID)
1519         returns (string memory)
1520     {
1521         return
1522             string(
1523                 abi.encodePacked(
1524                     super.uri(tokenID),
1525                     Strings.toString(tokenID),
1526                     ".json"
1527                 )
1528             );
1529     }
1530 
1531     /// @dev Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1532     function isApprovedForAll(address owner, address operator)
1533         public
1534         view
1535         override
1536         returns (bool)
1537     {
1538         // Whitelist OpenSea proxy contract for easy trading.
1539         ProxyRegistry proxyRegistry = ProxyRegistry(_PROXY_REGISTRY_ADDRESS);
1540         if (address(proxyRegistry.proxies(owner)) == operator) {
1541             return true;
1542         }
1543 
1544         return super.isApprovedForAll(owner, operator);
1545     }
1546 }