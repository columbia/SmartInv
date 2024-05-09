1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Context.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Address.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
110 
111 pragma solidity ^0.8.1;
112 
113 /**
114  * @dev Collection of functions related to the address type
115  */
116 library Address {
117     /**
118      * @dev Returns true if `account` is a contract.
119      *
120      * [IMPORTANT]
121      * ====
122      * It is unsafe to assume that an address for which this function returns
123      * false is an externally-owned account (EOA) and not a contract.
124      *
125      * Among others, `isContract` will return false for the following
126      * types of addresses:
127      *
128      *  - an externally-owned account
129      *  - a contract in construction
130      *  - an address where a contract will be created
131      *  - an address where a contract lived, but was destroyed
132      * ====
133      *
134      * [IMPORTANT]
135      * ====
136      * You shouldn't rely on `isContract` to protect against flash loan attacks!
137      *
138      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
139      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
140      * constructor.
141      * ====
142      */
143     function isContract(address account) internal view returns (bool) {
144         // This method relies on extcodesize/address.code.length, which returns 0
145         // for contracts in construction, since the code is only stored at the end
146         // of the constructor execution.
147 
148         return account.code.length > 0;
149     }
150 
151     /**
152      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
153      * `recipient`, forwarding all available gas and reverting on errors.
154      *
155      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
156      * of certain opcodes, possibly making contracts go over the 2300 gas limit
157      * imposed by `transfer`, making them unable to receive funds via
158      * `transfer`. {sendValue} removes this limitation.
159      *
160      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
161      *
162      * IMPORTANT: because control is transferred to `recipient`, care must be
163      * taken to not create reentrancy vulnerabilities. Consider using
164      * {ReentrancyGuard} or the
165      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
166      */
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(address(this).balance >= amount, "Address: insufficient balance");
169 
170         (bool success, ) = recipient.call{value: amount}("");
171         require(success, "Address: unable to send value, recipient may have reverted");
172     }
173 
174     /**
175      * @dev Performs a Solidity function call using a low level `call`. A
176      * plain `call` is an unsafe replacement for a function call: use this
177      * function instead.
178      *
179      * If `target` reverts with a revert reason, it is bubbled up by this
180      * function (like regular Solidity function calls).
181      *
182      * Returns the raw returned data. To convert to the expected return value,
183      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
184      *
185      * Requirements:
186      *
187      * - `target` must be a contract.
188      * - calling `target` with `data` must not revert.
189      *
190      * _Available since v3.1._
191      */
192     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionCall(target, data, "Address: low-level call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
198      * `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, 0, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but also transferring `value` wei to `target`.
213      *
214      * Requirements:
215      *
216      * - the calling contract must have an ETH balance of at least `value`.
217      * - the called Solidity function must be `payable`.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(
222         address target,
223         bytes memory data,
224         uint256 value
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
231      * with `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(
236         address target,
237         bytes memory data,
238         uint256 value,
239         string memory errorMessage
240     ) internal returns (bytes memory) {
241         require(address(this).balance >= value, "Address: insufficient balance for call");
242         require(isContract(target), "Address: call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.call{value: value}(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a static call.
251      *
252      * _Available since v3.3._
253      */
254     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
255         return functionStaticCall(target, data, "Address: low-level static call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a static call.
261      *
262      * _Available since v3.3._
263      */
264     function functionStaticCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal view returns (bytes memory) {
269         require(isContract(target), "Address: static call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.staticcall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but performing a delegate call.
278      *
279      * _Available since v3.4._
280      */
281     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
287      * but performing a delegate call.
288      *
289      * _Available since v3.4._
290      */
291     function functionDelegateCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         require(isContract(target), "Address: delegate call to non-contract");
297 
298         (bool success, bytes memory returndata) = target.delegatecall(data);
299         return verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
304      * revert reason using the provided one.
305      *
306      * _Available since v4.3._
307      */
308     function verifyCallResult(
309         bool success,
310         bytes memory returndata,
311         string memory errorMessage
312     ) internal pure returns (bytes memory) {
313         if (success) {
314             return returndata;
315         } else {
316             // Look for revert reason and bubble it up if present
317             if (returndata.length > 0) {
318                 // The easiest way to bubble the revert reason is using memory via assembly
319                 /// @solidity memory-safe-assembly
320                 assembly {
321                     let returndata_size := mload(returndata)
322                     revert(add(32, returndata), returndata_size)
323                 }
324             } else {
325                 revert(errorMessage);
326             }
327         }
328     }
329 }
330 
331 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
332 
333 
334 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @dev Interface of the ERC165 standard, as defined in the
340  * https://eips.ethereum.org/EIPS/eip-165[EIP].
341  *
342  * Implementers can declare support of contract interfaces, which can then be
343  * queried by others ({ERC165Checker}).
344  *
345  * For an implementation, see {ERC165}.
346  */
347 interface IERC165 {
348     /**
349      * @dev Returns true if this contract implements the interface defined by
350      * `interfaceId`. See the corresponding
351      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
352      * to learn more about how these ids are created.
353      *
354      * This function call must use less than 30 000 gas.
355      */
356     function supportsInterface(bytes4 interfaceId) external view returns (bool);
357 }
358 
359 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 
367 /**
368  * @dev Implementation of the {IERC165} interface.
369  *
370  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
371  * for the additional interface id that will be supported. For example:
372  *
373  * ```solidity
374  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
375  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
376  * }
377  * ```
378  *
379  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
380  */
381 abstract contract ERC165 is IERC165 {
382     /**
383      * @dev See {IERC165-supportsInterface}.
384      */
385     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
386         return interfaceId == type(IERC165).interfaceId;
387     }
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
391 
392 
393 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 /**
399  * @dev _Available since v3.1._
400  */
401 interface IERC1155Receiver is IERC165 {
402     /**
403      * @dev Handles the receipt of a single ERC1155 token type. This function is
404      * called at the end of a `safeTransferFrom` after the balance has been updated.
405      *
406      * NOTE: To accept the transfer, this must return
407      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
408      * (i.e. 0xf23a6e61, or its own function selector).
409      *
410      * @param operator The address which initiated the transfer (i.e. msg.sender)
411      * @param from The address which previously owned the token
412      * @param id The ID of the token being transferred
413      * @param value The amount of tokens being transferred
414      * @param data Additional data with no specified format
415      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
416      */
417     function onERC1155Received(
418         address operator,
419         address from,
420         uint256 id,
421         uint256 value,
422         bytes calldata data
423     ) external returns (bytes4);
424 
425     /**
426      * @dev Handles the receipt of a multiple ERC1155 token types. This function
427      * is called at the end of a `safeBatchTransferFrom` after the balances have
428      * been updated.
429      *
430      * NOTE: To accept the transfer(s), this must return
431      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
432      * (i.e. 0xbc197c81, or its own function selector).
433      *
434      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
435      * @param from The address which previously owned the token
436      * @param ids An array containing ids of each token being transferred (order and length must match values array)
437      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
438      * @param data Additional data with no specified format
439      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
440      */
441     function onERC1155BatchReceived(
442         address operator,
443         address from,
444         uint256[] calldata ids,
445         uint256[] calldata values,
446         bytes calldata data
447     ) external returns (bytes4);
448 }
449 
450 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
451 
452 
453 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 
458 /**
459  * @dev Required interface of an ERC1155 compliant contract, as defined in the
460  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
461  *
462  * _Available since v3.1._
463  */
464 interface IERC1155 is IERC165 {
465     /**
466      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
467      */
468     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
469 
470     /**
471      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
472      * transfers.
473      */
474     event TransferBatch(
475         address indexed operator,
476         address indexed from,
477         address indexed to,
478         uint256[] ids,
479         uint256[] values
480     );
481 
482     /**
483      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
484      * `approved`.
485      */
486     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
487 
488     /**
489      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
490      *
491      * If an {URI} event was emitted for `id`, the standard
492      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
493      * returned by {IERC1155MetadataURI-uri}.
494      */
495     event URI(string value, uint256 indexed id);
496 
497     /**
498      * @dev Returns the amount of tokens of token type `id` owned by `account`.
499      *
500      * Requirements:
501      *
502      * - `account` cannot be the zero address.
503      */
504     function balanceOf(address account, uint256 id) external view returns (uint256);
505 
506     /**
507      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
508      *
509      * Requirements:
510      *
511      * - `accounts` and `ids` must have the same length.
512      */
513     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
514         external
515         view
516         returns (uint256[] memory);
517 
518     /**
519      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
520      *
521      * Emits an {ApprovalForAll} event.
522      *
523      * Requirements:
524      *
525      * - `operator` cannot be the caller.
526      */
527     function setApprovalForAll(address operator, bool approved) external;
528 
529     /**
530      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
531      *
532      * See {setApprovalForAll}.
533      */
534     function isApprovedForAll(address account, address operator) external view returns (bool);
535 
536     /**
537      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
538      *
539      * Emits a {TransferSingle} event.
540      *
541      * Requirements:
542      *
543      * - `to` cannot be the zero address.
544      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
545      * - `from` must have a balance of tokens of type `id` of at least `amount`.
546      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
547      * acceptance magic value.
548      */
549     function safeTransferFrom(
550         address from,
551         address to,
552         uint256 id,
553         uint256 amount,
554         bytes calldata data
555     ) external;
556 
557     /**
558      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
559      *
560      * Emits a {TransferBatch} event.
561      *
562      * Requirements:
563      *
564      * - `ids` and `amounts` must have the same length.
565      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
566      * acceptance magic value.
567      */
568     function safeBatchTransferFrom(
569         address from,
570         address to,
571         uint256[] calldata ids,
572         uint256[] calldata amounts,
573         bytes calldata data
574     ) external;
575 }
576 
577 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
578 
579 
580 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 
585 /**
586  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
587  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
588  *
589  * _Available since v3.1._
590  */
591 interface IERC1155MetadataURI is IERC1155 {
592     /**
593      * @dev Returns the URI for token type `id`.
594      *
595      * If the `\{id\}` substring is present in the URI, it must be replaced by
596      * clients with the actual token type ID.
597      */
598     function uri(uint256 id) external view returns (string memory);
599 }
600 
601 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
602 
603 
604 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 
609 
610 
611 
612 
613 
614 /**
615  * @dev Implementation of the basic standard multi-token.
616  * See https://eips.ethereum.org/EIPS/eip-1155
617  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
618  *
619  * _Available since v3.1._
620  */
621 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
622     using Address for address;
623 
624     // Mapping from token ID to account balances
625     mapping(uint256 => mapping(address => uint256)) private _balances;
626 
627     // Mapping from account to operator approvals
628     mapping(address => mapping(address => bool)) private _operatorApprovals;
629 
630     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
631     string private _uri;
632 
633     /**
634      * @dev See {_setURI}.
635      */
636     constructor(string memory uri_) {
637         _setURI(uri_);
638     }
639 
640     /**
641      * @dev See {IERC165-supportsInterface}.
642      */
643     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
644         return
645             interfaceId == type(IERC1155).interfaceId ||
646             interfaceId == type(IERC1155MetadataURI).interfaceId ||
647             super.supportsInterface(interfaceId);
648     }
649 
650     /**
651      * @dev See {IERC1155MetadataURI-uri}.
652      *
653      * This implementation returns the same URI for *all* token types. It relies
654      * on the token type ID substitution mechanism
655      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
656      *
657      * Clients calling this function must replace the `\{id\}` substring with the
658      * actual token type ID.
659      */
660     function uri(uint256) public view virtual override returns (string memory) {
661         return _uri;
662     }
663 
664     /**
665      * @dev See {IERC1155-balanceOf}.
666      *
667      * Requirements:
668      *
669      * - `account` cannot be the zero address.
670      */
671     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
672         require(account != address(0), "ERC1155: address zero is not a valid owner");
673         return _balances[id][account];
674     }
675 
676     /**
677      * @dev See {IERC1155-balanceOfBatch}.
678      *
679      * Requirements:
680      *
681      * - `accounts` and `ids` must have the same length.
682      */
683     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
684         public
685         view
686         virtual
687         override
688         returns (uint256[] memory)
689     {
690         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
691 
692         uint256[] memory batchBalances = new uint256[](accounts.length);
693 
694         for (uint256 i = 0; i < accounts.length; ++i) {
695             batchBalances[i] = balanceOf(accounts[i], ids[i]);
696         }
697 
698         return batchBalances;
699     }
700 
701     /**
702      * @dev See {IERC1155-setApprovalForAll}.
703      */
704     function setApprovalForAll(address operator, bool approved) public virtual override {
705         _setApprovalForAll(_msgSender(), operator, approved);
706     }
707 
708     /**
709      * @dev See {IERC1155-isApprovedForAll}.
710      */
711     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
712         return _operatorApprovals[account][operator];
713     }
714 
715     /**
716      * @dev See {IERC1155-safeTransferFrom}.
717      */
718     function safeTransferFrom(
719         address from,
720         address to,
721         uint256 id,
722         uint256 amount,
723         bytes memory data
724     ) public virtual override {
725         require(
726             from == _msgSender() || isApprovedForAll(from, _msgSender()),
727             "ERC1155: caller is not token owner nor approved"
728         );
729         _safeTransferFrom(from, to, id, amount, data);
730     }
731 
732     /**
733      * @dev See {IERC1155-safeBatchTransferFrom}.
734      */
735     function safeBatchTransferFrom(
736         address from,
737         address to,
738         uint256[] memory ids,
739         uint256[] memory amounts,
740         bytes memory data
741     ) public virtual override {
742         require(
743             from == _msgSender() || isApprovedForAll(from, _msgSender()),
744             "ERC1155: caller is not token owner nor approved"
745         );
746         _safeBatchTransferFrom(from, to, ids, amounts, data);
747     }
748 
749     /**
750      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
751      *
752      * Emits a {TransferSingle} event.
753      *
754      * Requirements:
755      *
756      * - `to` cannot be the zero address.
757      * - `from` must have a balance of tokens of type `id` of at least `amount`.
758      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
759      * acceptance magic value.
760      */
761     function _safeTransferFrom(
762         address from,
763         address to,
764         uint256 id,
765         uint256 amount,
766         bytes memory data
767     ) internal virtual {
768         require(to != address(0), "ERC1155: transfer to the zero address");
769 
770         address operator = _msgSender();
771         uint256[] memory ids = _asSingletonArray(id);
772         uint256[] memory amounts = _asSingletonArray(amount);
773 
774         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
775 
776         uint256 fromBalance = _balances[id][from];
777         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
778         unchecked {
779             _balances[id][from] = fromBalance - amount;
780         }
781         _balances[id][to] += amount;
782 
783         emit TransferSingle(operator, from, to, id, amount);
784 
785         _afterTokenTransfer(operator, from, to, ids, amounts, data);
786 
787         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
788     }
789 
790     /**
791      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
792      *
793      * Emits a {TransferBatch} event.
794      *
795      * Requirements:
796      *
797      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
798      * acceptance magic value.
799      */
800     function _safeBatchTransferFrom(
801         address from,
802         address to,
803         uint256[] memory ids,
804         uint256[] memory amounts,
805         bytes memory data
806     ) internal virtual {
807         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
808         require(to != address(0), "ERC1155: transfer to the zero address");
809 
810         address operator = _msgSender();
811 
812         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
813 
814         for (uint256 i = 0; i < ids.length; ++i) {
815             uint256 id = ids[i];
816             uint256 amount = amounts[i];
817 
818             uint256 fromBalance = _balances[id][from];
819             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
820             unchecked {
821                 _balances[id][from] = fromBalance - amount;
822             }
823             _balances[id][to] += amount;
824         }
825 
826         emit TransferBatch(operator, from, to, ids, amounts);
827 
828         _afterTokenTransfer(operator, from, to, ids, amounts, data);
829 
830         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
831     }
832 
833     /**
834      * @dev Sets a new URI for all token types, by relying on the token type ID
835      * substitution mechanism
836      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
837      *
838      * By this mechanism, any occurrence of the `\{id\}` substring in either the
839      * URI or any of the amounts in the JSON file at said URI will be replaced by
840      * clients with the token type ID.
841      *
842      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
843      * interpreted by clients as
844      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
845      * for token type ID 0x4cce0.
846      *
847      * See {uri}.
848      *
849      * Because these URIs cannot be meaningfully represented by the {URI} event,
850      * this function emits no events.
851      */
852     function _setURI(string memory newuri) internal virtual {
853         _uri = newuri;
854     }
855 
856     /**
857      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
858      *
859      * Emits a {TransferSingle} event.
860      *
861      * Requirements:
862      *
863      * - `to` cannot be the zero address.
864      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
865      * acceptance magic value.
866      */
867     function _mint(
868         address to,
869         uint256 id,
870         uint256 amount,
871         bytes memory data
872     ) internal virtual {
873         require(to != address(0), "ERC1155: mint to the zero address");
874 
875         address operator = _msgSender();
876         uint256[] memory ids = _asSingletonArray(id);
877         uint256[] memory amounts = _asSingletonArray(amount);
878 
879         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
880 
881         _balances[id][to] += amount;
882         emit TransferSingle(operator, address(0), to, id, amount);
883 
884         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
885 
886         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
887     }
888 
889     /**
890      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
891      *
892      * Emits a {TransferBatch} event.
893      *
894      * Requirements:
895      *
896      * - `ids` and `amounts` must have the same length.
897      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
898      * acceptance magic value.
899      */
900     function _mintBatch(
901         address to,
902         uint256[] memory ids,
903         uint256[] memory amounts,
904         bytes memory data
905     ) internal virtual {
906         require(to != address(0), "ERC1155: mint to the zero address");
907         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
908 
909         address operator = _msgSender();
910 
911         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
912 
913         for (uint256 i = 0; i < ids.length; i++) {
914             _balances[ids[i]][to] += amounts[i];
915         }
916 
917         emit TransferBatch(operator, address(0), to, ids, amounts);
918 
919         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
920 
921         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
922     }
923 
924     /**
925      * @dev Destroys `amount` tokens of token type `id` from `from`
926      *
927      * Emits a {TransferSingle} event.
928      *
929      * Requirements:
930      *
931      * - `from` cannot be the zero address.
932      * - `from` must have at least `amount` tokens of token type `id`.
933      */
934     function _burn(
935         address from,
936         uint256 id,
937         uint256 amount
938     ) internal virtual {
939         require(from != address(0), "ERC1155: burn from the zero address");
940 
941         address operator = _msgSender();
942         uint256[] memory ids = _asSingletonArray(id);
943         uint256[] memory amounts = _asSingletonArray(amount);
944 
945         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
946 
947         uint256 fromBalance = _balances[id][from];
948         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
949         unchecked {
950             _balances[id][from] = fromBalance - amount;
951         }
952 
953         emit TransferSingle(operator, from, address(0), id, amount);
954 
955         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
956     }
957 
958     /**
959      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
960      *
961      * Emits a {TransferBatch} event.
962      *
963      * Requirements:
964      *
965      * - `ids` and `amounts` must have the same length.
966      */
967     function _burnBatch(
968         address from,
969         uint256[] memory ids,
970         uint256[] memory amounts
971     ) internal virtual {
972         require(from != address(0), "ERC1155: burn from the zero address");
973         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
974 
975         address operator = _msgSender();
976 
977         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
978 
979         for (uint256 i = 0; i < ids.length; i++) {
980             uint256 id = ids[i];
981             uint256 amount = amounts[i];
982 
983             uint256 fromBalance = _balances[id][from];
984             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
985             unchecked {
986                 _balances[id][from] = fromBalance - amount;
987             }
988         }
989 
990         emit TransferBatch(operator, from, address(0), ids, amounts);
991 
992         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
993     }
994 
995     /**
996      * @dev Approve `operator` to operate on all of `owner` tokens
997      *
998      * Emits an {ApprovalForAll} event.
999      */
1000     function _setApprovalForAll(
1001         address owner,
1002         address operator,
1003         bool approved
1004     ) internal virtual {
1005         require(owner != operator, "ERC1155: setting approval status for self");
1006         _operatorApprovals[owner][operator] = approved;
1007         emit ApprovalForAll(owner, operator, approved);
1008     }
1009 
1010     /**
1011      * @dev Hook that is called before any token transfer. This includes minting
1012      * and burning, as well as batched variants.
1013      *
1014      * The same hook is called on both single and batched variants. For single
1015      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1016      *
1017      * Calling conditions (for each `id` and `amount` pair):
1018      *
1019      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1020      * of token type `id` will be  transferred to `to`.
1021      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1022      * for `to`.
1023      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1024      * will be burned.
1025      * - `from` and `to` are never both zero.
1026      * - `ids` and `amounts` have the same, non-zero length.
1027      *
1028      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1029      */
1030     function _beforeTokenTransfer(
1031         address operator,
1032         address from,
1033         address to,
1034         uint256[] memory ids,
1035         uint256[] memory amounts,
1036         bytes memory data
1037     ) internal virtual {}
1038 
1039     /**
1040      * @dev Hook that is called after any token transfer. This includes minting
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
1059     function _afterTokenTransfer(
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
1120 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1121 
1122 
1123 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1124 
1125 pragma solidity ^0.8.0;
1126 
1127 
1128 /**
1129  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1130  *
1131  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1132  * clearly identified. Note: While a totalSupply of 1 might mean the
1133  * corresponding is an NFT, there is no guarantees that no other token with the
1134  * same id are not going to be minted.
1135  */
1136 abstract contract ERC1155Supply is ERC1155 {
1137     mapping(uint256 => uint256) private _totalSupply;
1138 
1139     /**
1140      * @dev Total amount of tokens in with a given id.
1141      */
1142     function totalSupply(uint256 id) public view virtual returns (uint256) {
1143         return _totalSupply[id];
1144     }
1145 
1146     /**
1147      * @dev Indicates whether any token exist with a given id, or not.
1148      */
1149     function exists(uint256 id) public view virtual returns (bool) {
1150         return ERC1155Supply.totalSupply(id) > 0;
1151     }
1152 
1153     /**
1154      * @dev See {ERC1155-_beforeTokenTransfer}.
1155      */
1156     function _beforeTokenTransfer(
1157         address operator,
1158         address from,
1159         address to,
1160         uint256[] memory ids,
1161         uint256[] memory amounts,
1162         bytes memory data
1163     ) internal virtual override {
1164         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1165 
1166         if (from == address(0)) {
1167             for (uint256 i = 0; i < ids.length; ++i) {
1168                 _totalSupply[ids[i]] += amounts[i];
1169             }
1170         }
1171 
1172         if (to == address(0)) {
1173             for (uint256 i = 0; i < ids.length; ++i) {
1174                 uint256 id = ids[i];
1175                 uint256 amount = amounts[i];
1176                 uint256 supply = _totalSupply[id];
1177                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1178                 unchecked {
1179                     _totalSupply[id] = supply - amount;
1180                 }
1181             }
1182         }
1183     }
1184 }
1185 
1186 // File: contracts/Prop.sol
1187 
1188 
1189 pragma solidity ^0.8.7;
1190 
1191 
1192 
1193 contract Potion is ERC1155Supply {
1194     using Strings for uint256;
1195     
1196     address public owner;
1197     string public baseURI;
1198 
1199     constructor() ERC1155("") {
1200         owner = _msgSender();
1201     }
1202 
1203     modifier onlyOwner() {
1204         require(owner == _msgSender(), "Not Owner");
1205         _;
1206     }
1207 
1208     function mint(
1209         address account,
1210         uint256 tokenId,
1211         uint256 amount
1212     ) public onlyOwner {
1213         _mint(account, tokenId, amount, "");
1214     }
1215 
1216     function airdrop(uint256 tokenId, address[] memory accounts, uint256[] memory amounts) public onlyOwner {
1217         address account = _msgSender();
1218         for (uint256 i = 0; i < accounts.length; i++) {
1219             _mint(accounts[i], tokenId, amounts[i], "");
1220         }
1221     }
1222 
1223     function setURI(string memory newuri) public onlyOwner {
1224         baseURI = newuri;
1225     }
1226 
1227     function uri(uint256 tokenId) public view override returns (string memory) {
1228         require(exists(tokenId), "Not exist tokenId");
1229         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1230     }
1231 }