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
106 // File: @openzeppelin/contracts/security/Pausable.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Contract module which allows children to implement an emergency stop
116  * mechanism that can be triggered by an authorized account.
117  *
118  * This module is used through inheritance. It will make available the
119  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
120  * the functions of your contract. Note that they will not be pausable by
121  * simply including this module, only once the modifiers are put in place.
122  */
123 abstract contract Pausable is Context {
124     /**
125      * @dev Emitted when the pause is triggered by `account`.
126      */
127     event Paused(address account);
128 
129     /**
130      * @dev Emitted when the pause is lifted by `account`.
131      */
132     event Unpaused(address account);
133 
134     bool private _paused;
135 
136     /**
137      * @dev Initializes the contract in unpaused state.
138      */
139     constructor() {
140         _paused = false;
141     }
142 
143     /**
144      * @dev Returns true if the contract is paused, and false otherwise.
145      */
146     function paused() public view virtual returns (bool) {
147         return _paused;
148     }
149 
150     /**
151      * @dev Modifier to make a function callable only when the contract is not paused.
152      *
153      * Requirements:
154      *
155      * - The contract must not be paused.
156      */
157     modifier whenNotPaused() {
158         require(!paused(), "Pausable: paused");
159         _;
160     }
161 
162     /**
163      * @dev Modifier to make a function callable only when the contract is paused.
164      *
165      * Requirements:
166      *
167      * - The contract must be paused.
168      */
169     modifier whenPaused() {
170         require(paused(), "Pausable: not paused");
171         _;
172     }
173 
174     /**
175      * @dev Triggers stopped state.
176      *
177      * Requirements:
178      *
179      * - The contract must not be paused.
180      */
181     function _pause() internal virtual whenNotPaused {
182         _paused = true;
183         emit Paused(_msgSender());
184     }
185 
186     /**
187      * @dev Returns to normal state.
188      *
189      * Requirements:
190      *
191      * - The contract must be paused.
192      */
193     function _unpause() internal virtual whenPaused {
194         _paused = false;
195         emit Unpaused(_msgSender());
196     }
197 }
198 
199 // File: @openzeppelin/contracts/access/Ownable.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 
207 /**
208  * @dev Contract module which provides a basic access control mechanism, where
209  * there is an account (an owner) that can be granted exclusive access to
210  * specific functions.
211  *
212  * By default, the owner account will be the one that deploys the contract. This
213  * can later be changed with {transferOwnership}.
214  *
215  * This module is used through inheritance. It will make available the modifier
216  * `onlyOwner`, which can be applied to your functions to restrict their use to
217  * the owner.
218  */
219 abstract contract Ownable is Context {
220     address private _owner;
221 
222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224     /**
225      * @dev Initializes the contract setting the deployer as the initial owner.
226      */
227     constructor() {
228         _transferOwnership(_msgSender());
229     }
230 
231     /**
232      * @dev Returns the address of the current owner.
233      */
234     function owner() public view virtual returns (address) {
235         return _owner;
236     }
237 
238     /**
239      * @dev Throws if called by any account other than the owner.
240      */
241     modifier onlyOwner() {
242         require(owner() == _msgSender(), "Ownable: caller is not the owner");
243         _;
244     }
245 
246     /**
247      * @dev Leaves the contract without owner. It will not be possible to call
248      * `onlyOwner` functions anymore. Can only be called by the current owner.
249      *
250      * NOTE: Renouncing ownership will leave the contract without an owner,
251      * thereby removing any functionality that is only available to the owner.
252      */
253     function renounceOwnership() public virtual onlyOwner {
254         _transferOwnership(address(0));
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      * Can only be called by the current owner.
260      */
261     function transferOwnership(address newOwner) public virtual onlyOwner {
262         require(newOwner != address(0), "Ownable: new owner is the zero address");
263         _transferOwnership(newOwner);
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Internal function without access restriction.
269      */
270     function _transferOwnership(address newOwner) internal virtual {
271         address oldOwner = _owner;
272         _owner = newOwner;
273         emit OwnershipTransferred(oldOwner, newOwner);
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/Address.sol
278 
279 
280 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
281 
282 pragma solidity ^0.8.1;
283 
284 /**
285  * @dev Collection of functions related to the address type
286  */
287 library Address {
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * [IMPORTANT]
292      * ====
293      * It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      *
296      * Among others, `isContract` will return false for the following
297      * types of addresses:
298      *
299      *  - an externally-owned account
300      *  - a contract in construction
301      *  - an address where a contract will be created
302      *  - an address where a contract lived, but was destroyed
303      * ====
304      *
305      * [IMPORTANT]
306      * ====
307      * You shouldn't rely on `isContract` to protect against flash loan attacks!
308      *
309      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
310      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
311      * constructor.
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // This method relies on extcodesize/address.code.length, which returns 0
316         // for contracts in construction, since the code is only stored at the end
317         // of the constructor execution.
318 
319         return account.code.length > 0;
320     }
321 
322     /**
323      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
324      * `recipient`, forwarding all available gas and reverting on errors.
325      *
326      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
327      * of certain opcodes, possibly making contracts go over the 2300 gas limit
328      * imposed by `transfer`, making them unable to receive funds via
329      * `transfer`. {sendValue} removes this limitation.
330      *
331      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
332      *
333      * IMPORTANT: because control is transferred to `recipient`, care must be
334      * taken to not create reentrancy vulnerabilities. Consider using
335      * {ReentrancyGuard} or the
336      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
337      */
338     function sendValue(address payable recipient, uint256 amount) internal {
339         require(address(this).balance >= amount, "Address: insufficient balance");
340 
341         (bool success, ) = recipient.call{value: amount}("");
342         require(success, "Address: unable to send value, recipient may have reverted");
343     }
344 
345     /**
346      * @dev Performs a Solidity function call using a low level `call`. A
347      * plain `call` is an unsafe replacement for a function call: use this
348      * function instead.
349      *
350      * If `target` reverts with a revert reason, it is bubbled up by this
351      * function (like regular Solidity function calls).
352      *
353      * Returns the raw returned data. To convert to the expected return value,
354      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
355      *
356      * Requirements:
357      *
358      * - `target` must be a contract.
359      * - calling `target` with `data` must not revert.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
364         return functionCall(target, data, "Address: low-level call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
369      * `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, 0, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but also transferring `value` wei to `target`.
384      *
385      * Requirements:
386      *
387      * - the calling contract must have an ETH balance of at least `value`.
388      * - the called Solidity function must be `payable`.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(
393         address target,
394         bytes memory data,
395         uint256 value
396     ) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 value,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(address(this).balance >= value, "Address: insufficient balance for call");
413         require(isContract(target), "Address: call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.call{value: value}(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but performing a static call.
422      *
423      * _Available since v3.3._
424      */
425     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
426         return functionStaticCall(target, data, "Address: low-level static call failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(
436         address target,
437         bytes memory data,
438         string memory errorMessage
439     ) internal view returns (bytes memory) {
440         require(isContract(target), "Address: static call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.staticcall(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
453         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         require(isContract(target), "Address: delegate call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.delegatecall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
475      * revert reason using the provided one.
476      *
477      * _Available since v4.3._
478      */
479     function verifyCallResult(
480         bool success,
481         bytes memory returndata,
482         string memory errorMessage
483     ) internal pure returns (bytes memory) {
484         if (success) {
485             return returndata;
486         } else {
487             // Look for revert reason and bubble it up if present
488             if (returndata.length > 0) {
489                 // The easiest way to bubble the revert reason is using memory via assembly
490 
491                 assembly {
492                     let returndata_size := mload(returndata)
493                     revert(add(32, returndata), returndata_size)
494                 }
495             } else {
496                 revert(errorMessage);
497             }
498         }
499     }
500 }
501 
502 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
503 
504 
505 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev Interface of the ERC165 standard, as defined in the
511  * https://eips.ethereum.org/EIPS/eip-165[EIP].
512  *
513  * Implementers can declare support of contract interfaces, which can then be
514  * queried by others ({ERC165Checker}).
515  *
516  * For an implementation, see {ERC165}.
517  */
518 interface IERC165 {
519     /**
520      * @dev Returns true if this contract implements the interface defined by
521      * `interfaceId`. See the corresponding
522      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
523      * to learn more about how these ids are created.
524      *
525      * This function call must use less than 30 000 gas.
526      */
527     function supportsInterface(bytes4 interfaceId) external view returns (bool);
528 }
529 
530 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @dev Implementation of the {IERC165} interface.
540  *
541  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
542  * for the additional interface id that will be supported. For example:
543  *
544  * ```solidity
545  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
547  * }
548  * ```
549  *
550  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
551  */
552 abstract contract ERC165 is IERC165 {
553     /**
554      * @dev See {IERC165-supportsInterface}.
555      */
556     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557         return interfaceId == type(IERC165).interfaceId;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
562 
563 
564 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @dev _Available since v3.1._
571  */
572 interface IERC1155Receiver is IERC165 {
573     /**
574      * @dev Handles the receipt of a single ERC1155 token type. This function is
575      * called at the end of a `safeTransferFrom` after the balance has been updated.
576      *
577      * NOTE: To accept the transfer, this must return
578      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
579      * (i.e. 0xf23a6e61, or its own function selector).
580      *
581      * @param operator The address which initiated the transfer (i.e. msg.sender)
582      * @param from The address which previously owned the token
583      * @param id The ID of the token being transferred
584      * @param value The amount of tokens being transferred
585      * @param data Additional data with no specified format
586      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
587      */
588     function onERC1155Received(
589         address operator,
590         address from,
591         uint256 id,
592         uint256 value,
593         bytes calldata data
594     ) external returns (bytes4);
595 
596     /**
597      * @dev Handles the receipt of a multiple ERC1155 token types. This function
598      * is called at the end of a `safeBatchTransferFrom` after the balances have
599      * been updated.
600      *
601      * NOTE: To accept the transfer(s), this must return
602      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
603      * (i.e. 0xbc197c81, or its own function selector).
604      *
605      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
606      * @param from The address which previously owned the token
607      * @param ids An array containing ids of each token being transferred (order and length must match values array)
608      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
609      * @param data Additional data with no specified format
610      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
611      */
612     function onERC1155BatchReceived(
613         address operator,
614         address from,
615         uint256[] calldata ids,
616         uint256[] calldata values,
617         bytes calldata data
618     ) external returns (bytes4);
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
622 
623 
624 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @dev Required interface of an ERC1155 compliant contract, as defined in the
631  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
632  *
633  * _Available since v3.1._
634  */
635 interface IERC1155 is IERC165 {
636     /**
637      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
638      */
639     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
640 
641     /**
642      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
643      * transfers.
644      */
645     event TransferBatch(
646         address indexed operator,
647         address indexed from,
648         address indexed to,
649         uint256[] ids,
650         uint256[] values
651     );
652 
653     /**
654      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
655      * `approved`.
656      */
657     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
658 
659     /**
660      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
661      *
662      * If an {URI} event was emitted for `id`, the standard
663      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
664      * returned by {IERC1155MetadataURI-uri}.
665      */
666     event URI(string value, uint256 indexed id);
667 
668     /**
669      * @dev Returns the amount of tokens of token type `id` owned by `account`.
670      *
671      * Requirements:
672      *
673      * - `account` cannot be the zero address.
674      */
675     function balanceOf(address account, uint256 id) external view returns (uint256);
676 
677     /**
678      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
679      *
680      * Requirements:
681      *
682      * - `accounts` and `ids` must have the same length.
683      */
684     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
685         external
686         view
687         returns (uint256[] memory);
688 
689     /**
690      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
691      *
692      * Emits an {ApprovalForAll} event.
693      *
694      * Requirements:
695      *
696      * - `operator` cannot be the caller.
697      */
698     function setApprovalForAll(address operator, bool approved) external;
699 
700     /**
701      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
702      *
703      * See {setApprovalForAll}.
704      */
705     function isApprovedForAll(address account, address operator) external view returns (bool);
706 
707     /**
708      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
709      *
710      * Emits a {TransferSingle} event.
711      *
712      * Requirements:
713      *
714      * - `to` cannot be the zero address.
715      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
716      * - `from` must have a balance of tokens of type `id` of at least `amount`.
717      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
718      * acceptance magic value.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 id,
724         uint256 amount,
725         bytes calldata data
726     ) external;
727 
728     /**
729      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
730      *
731      * Emits a {TransferBatch} event.
732      *
733      * Requirements:
734      *
735      * - `ids` and `amounts` must have the same length.
736      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
737      * acceptance magic value.
738      */
739     function safeBatchTransferFrom(
740         address from,
741         address to,
742         uint256[] calldata ids,
743         uint256[] calldata amounts,
744         bytes calldata data
745     ) external;
746 }
747 
748 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
749 
750 
751 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
752 
753 pragma solidity ^0.8.0;
754 
755 
756 /**
757  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
758  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
759  *
760  * _Available since v3.1._
761  */
762 interface IERC1155MetadataURI is IERC1155 {
763     /**
764      * @dev Returns the URI for token type `id`.
765      *
766      * If the `\{id\}` substring is present in the URI, it must be replaced by
767      * clients with the actual token type ID.
768      */
769     function uri(uint256 id) external view returns (string memory);
770 }
771 
772 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
773 
774 
775 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
776 
777 pragma solidity ^0.8.0;
778 
779 
780 
781 
782 
783 
784 
785 /**
786  * @dev Implementation of the basic standard multi-token.
787  * See https://eips.ethereum.org/EIPS/eip-1155
788  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
789  *
790  * _Available since v3.1._
791  */
792 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
793     using Address for address;
794 
795     // Mapping from token ID to account balances
796     mapping(uint256 => mapping(address => uint256)) private _balances;
797 
798     // Mapping from account to operator approvals
799     mapping(address => mapping(address => bool)) private _operatorApprovals;
800 
801     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
802     string private _uri;
803 
804     /**
805      * @dev See {_setURI}.
806      */
807     constructor(string memory uri_) {
808         _setURI(uri_);
809     }
810 
811     /**
812      * @dev See {IERC165-supportsInterface}.
813      */
814     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
815         return
816             interfaceId == type(IERC1155).interfaceId ||
817             interfaceId == type(IERC1155MetadataURI).interfaceId ||
818             super.supportsInterface(interfaceId);
819     }
820 
821     /**
822      * @dev See {IERC1155MetadataURI-uri}.
823      *
824      * This implementation returns the same URI for *all* token types. It relies
825      * on the token type ID substitution mechanism
826      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
827      *
828      * Clients calling this function must replace the `\{id\}` substring with the
829      * actual token type ID.
830      */
831     function uri(uint256) public view virtual override returns (string memory) {
832         return _uri;
833     }
834 
835     /**
836      * @dev See {IERC1155-balanceOf}.
837      *
838      * Requirements:
839      *
840      * - `account` cannot be the zero address.
841      */
842     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
843         require(account != address(0), "ERC1155: balance query for the zero address");
844         return _balances[id][account];
845     }
846 
847     /**
848      * @dev See {IERC1155-balanceOfBatch}.
849      *
850      * Requirements:
851      *
852      * - `accounts` and `ids` must have the same length.
853      */
854     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
855         public
856         view
857         virtual
858         override
859         returns (uint256[] memory)
860     {
861         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
862 
863         uint256[] memory batchBalances = new uint256[](accounts.length);
864 
865         for (uint256 i = 0; i < accounts.length; ++i) {
866             batchBalances[i] = balanceOf(accounts[i], ids[i]);
867         }
868 
869         return batchBalances;
870     }
871 
872     /**
873      * @dev See {IERC1155-setApprovalForAll}.
874      */
875     function setApprovalForAll(address operator, bool approved) public virtual override {
876         _setApprovalForAll(_msgSender(), operator, approved);
877     }
878 
879     /**
880      * @dev See {IERC1155-isApprovedForAll}.
881      */
882     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
883         return _operatorApprovals[account][operator];
884     }
885 
886     /**
887      * @dev See {IERC1155-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 id,
893         uint256 amount,
894         bytes memory data
895     ) public virtual override {
896         require(
897             from == _msgSender() || isApprovedForAll(from, _msgSender()),
898             "ERC1155: caller is not owner nor approved"
899         );
900         _safeTransferFrom(from, to, id, amount, data);
901     }
902 
903     /**
904      * @dev See {IERC1155-safeBatchTransferFrom}.
905      */
906     function safeBatchTransferFrom(
907         address from,
908         address to,
909         uint256[] memory ids,
910         uint256[] memory amounts,
911         bytes memory data
912     ) public virtual override {
913         require(
914             from == _msgSender() || isApprovedForAll(from, _msgSender()),
915             "ERC1155: transfer caller is not owner nor approved"
916         );
917         _safeBatchTransferFrom(from, to, ids, amounts, data);
918     }
919 
920     /**
921      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
922      *
923      * Emits a {TransferSingle} event.
924      *
925      * Requirements:
926      *
927      * - `to` cannot be the zero address.
928      * - `from` must have a balance of tokens of type `id` of at least `amount`.
929      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
930      * acceptance magic value.
931      */
932     function _safeTransferFrom(
933         address from,
934         address to,
935         uint256 id,
936         uint256 amount,
937         bytes memory data
938     ) internal virtual {
939         require(to != address(0), "ERC1155: transfer to the zero address");
940 
941         address operator = _msgSender();
942         uint256[] memory ids = _asSingletonArray(id);
943         uint256[] memory amounts = _asSingletonArray(amount);
944 
945         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
946 
947         uint256 fromBalance = _balances[id][from];
948         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
949         unchecked {
950             _balances[id][from] = fromBalance - amount;
951         }
952         _balances[id][to] += amount;
953 
954         emit TransferSingle(operator, from, to, id, amount);
955 
956         _afterTokenTransfer(operator, from, to, ids, amounts, data);
957 
958         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
959     }
960 
961     /**
962      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
963      *
964      * Emits a {TransferBatch} event.
965      *
966      * Requirements:
967      *
968      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
969      * acceptance magic value.
970      */
971     function _safeBatchTransferFrom(
972         address from,
973         address to,
974         uint256[] memory ids,
975         uint256[] memory amounts,
976         bytes memory data
977     ) internal virtual {
978         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
979         require(to != address(0), "ERC1155: transfer to the zero address");
980 
981         address operator = _msgSender();
982 
983         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
984 
985         for (uint256 i = 0; i < ids.length; ++i) {
986             uint256 id = ids[i];
987             uint256 amount = amounts[i];
988 
989             uint256 fromBalance = _balances[id][from];
990             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
991             unchecked {
992                 _balances[id][from] = fromBalance - amount;
993             }
994             _balances[id][to] += amount;
995         }
996 
997         emit TransferBatch(operator, from, to, ids, amounts);
998 
999         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1000 
1001         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1002     }
1003 
1004     /**
1005      * @dev Sets a new URI for all token types, by relying on the token type ID
1006      * substitution mechanism
1007      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1008      *
1009      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1010      * URI or any of the amounts in the JSON file at said URI will be replaced by
1011      * clients with the token type ID.
1012      *
1013      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1014      * interpreted by clients as
1015      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1016      * for token type ID 0x4cce0.
1017      *
1018      * See {uri}.
1019      *
1020      * Because these URIs cannot be meaningfully represented by the {URI} event,
1021      * this function emits no events.
1022      */
1023     function _setURI(string memory newuri) internal virtual {
1024         _uri = newuri;
1025     }
1026 
1027     /**
1028      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1029      *
1030      * Emits a {TransferSingle} event.
1031      *
1032      * Requirements:
1033      *
1034      * - `to` cannot be the zero address.
1035      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1036      * acceptance magic value.
1037      */
1038     function _mint(
1039         address to,
1040         uint256 id,
1041         uint256 amount,
1042         bytes memory data
1043     ) internal virtual {
1044         require(to != address(0), "ERC1155: mint to the zero address");
1045 
1046         address operator = _msgSender();
1047         uint256[] memory ids = _asSingletonArray(id);
1048         uint256[] memory amounts = _asSingletonArray(amount);
1049 
1050         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1051 
1052         _balances[id][to] += amount;
1053         emit TransferSingle(operator, address(0), to, id, amount);
1054 
1055         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1056 
1057         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1058     }
1059 
1060     /**
1061      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1062      *
1063      * Requirements:
1064      *
1065      * - `ids` and `amounts` must have the same length.
1066      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1067      * acceptance magic value.
1068      */
1069     function _mintBatch(
1070         address to,
1071         uint256[] memory ids,
1072         uint256[] memory amounts,
1073         bytes memory data
1074     ) internal virtual {
1075         require(to != address(0), "ERC1155: mint to the zero address");
1076         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1077 
1078         address operator = _msgSender();
1079 
1080         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1081 
1082         for (uint256 i = 0; i < ids.length; i++) {
1083             _balances[ids[i]][to] += amounts[i];
1084         }
1085 
1086         emit TransferBatch(operator, address(0), to, ids, amounts);
1087 
1088         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1089 
1090         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1091     }
1092 
1093     /**
1094      * @dev Destroys `amount` tokens of token type `id` from `from`
1095      *
1096      * Requirements:
1097      *
1098      * - `from` cannot be the zero address.
1099      * - `from` must have at least `amount` tokens of token type `id`.
1100      */
1101     function _burn(
1102         address from,
1103         uint256 id,
1104         uint256 amount
1105     ) internal virtual {
1106         require(from != address(0), "ERC1155: burn from the zero address");
1107 
1108         address operator = _msgSender();
1109         uint256[] memory ids = _asSingletonArray(id);
1110         uint256[] memory amounts = _asSingletonArray(amount);
1111 
1112         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1113 
1114         uint256 fromBalance = _balances[id][from];
1115         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1116         unchecked {
1117             _balances[id][from] = fromBalance - amount;
1118         }
1119 
1120         emit TransferSingle(operator, from, address(0), id, amount);
1121 
1122         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1123     }
1124 
1125     /**
1126      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1127      *
1128      * Requirements:
1129      *
1130      * - `ids` and `amounts` must have the same length.
1131      */
1132     function _burnBatch(
1133         address from,
1134         uint256[] memory ids,
1135         uint256[] memory amounts
1136     ) internal virtual {
1137         require(from != address(0), "ERC1155: burn from the zero address");
1138         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1139 
1140         address operator = _msgSender();
1141 
1142         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1143 
1144         for (uint256 i = 0; i < ids.length; i++) {
1145             uint256 id = ids[i];
1146             uint256 amount = amounts[i];
1147 
1148             uint256 fromBalance = _balances[id][from];
1149             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1150             unchecked {
1151                 _balances[id][from] = fromBalance - amount;
1152             }
1153         }
1154 
1155         emit TransferBatch(operator, from, address(0), ids, amounts);
1156 
1157         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1158     }
1159 
1160     /**
1161      * @dev Approve `operator` to operate on all of `owner` tokens
1162      *
1163      * Emits a {ApprovalForAll} event.
1164      */
1165     function _setApprovalForAll(
1166         address owner,
1167         address operator,
1168         bool approved
1169     ) internal virtual {
1170         require(owner != operator, "ERC1155: setting approval status for self");
1171         _operatorApprovals[owner][operator] = approved;
1172         emit ApprovalForAll(owner, operator, approved);
1173     }
1174 
1175     /**
1176      * @dev Hook that is called before any token transfer. This includes minting
1177      * and burning, as well as batched variants.
1178      *
1179      * The same hook is called on both single and batched variants. For single
1180      * transfers, the length of the `id` and `amount` arrays will be 1.
1181      *
1182      * Calling conditions (for each `id` and `amount` pair):
1183      *
1184      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1185      * of token type `id` will be  transferred to `to`.
1186      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1187      * for `to`.
1188      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1189      * will be burned.
1190      * - `from` and `to` are never both zero.
1191      * - `ids` and `amounts` have the same, non-zero length.
1192      *
1193      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1194      */
1195     function _beforeTokenTransfer(
1196         address operator,
1197         address from,
1198         address to,
1199         uint256[] memory ids,
1200         uint256[] memory amounts,
1201         bytes memory data
1202     ) internal virtual {}
1203 
1204     /**
1205      * @dev Hook that is called after any token transfer. This includes minting
1206      * and burning, as well as batched variants.
1207      *
1208      * The same hook is called on both single and batched variants. For single
1209      * transfers, the length of the `id` and `amount` arrays will be 1.
1210      *
1211      * Calling conditions (for each `id` and `amount` pair):
1212      *
1213      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1214      * of token type `id` will be  transferred to `to`.
1215      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1216      * for `to`.
1217      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1218      * will be burned.
1219      * - `from` and `to` are never both zero.
1220      * - `ids` and `amounts` have the same, non-zero length.
1221      *
1222      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1223      */
1224     function _afterTokenTransfer(
1225         address operator,
1226         address from,
1227         address to,
1228         uint256[] memory ids,
1229         uint256[] memory amounts,
1230         bytes memory data
1231     ) internal virtual {}
1232 
1233     function _doSafeTransferAcceptanceCheck(
1234         address operator,
1235         address from,
1236         address to,
1237         uint256 id,
1238         uint256 amount,
1239         bytes memory data
1240     ) private {
1241         if (to.isContract()) {
1242             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1243                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1244                     revert("ERC1155: ERC1155Receiver rejected tokens");
1245                 }
1246             } catch Error(string memory reason) {
1247                 revert(reason);
1248             } catch {
1249                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1250             }
1251         }
1252     }
1253 
1254     function _doSafeBatchTransferAcceptanceCheck(
1255         address operator,
1256         address from,
1257         address to,
1258         uint256[] memory ids,
1259         uint256[] memory amounts,
1260         bytes memory data
1261     ) private {
1262         if (to.isContract()) {
1263             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1264                 bytes4 response
1265             ) {
1266                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1267                     revert("ERC1155: ERC1155Receiver rejected tokens");
1268                 }
1269             } catch Error(string memory reason) {
1270                 revert(reason);
1271             } catch {
1272                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1273             }
1274         }
1275     }
1276 
1277     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1278         uint256[] memory array = new uint256[](1);
1279         array[0] = element;
1280 
1281         return array;
1282     }
1283 }
1284 
1285 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1286 
1287 
1288 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1289 
1290 pragma solidity ^0.8.0;
1291 
1292 
1293 /**
1294  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1295  *
1296  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1297  * clearly identified. Note: While a totalSupply of 1 might mean the
1298  * corresponding is an NFT, there is no guarantees that no other token with the
1299  * same id are not going to be minted.
1300  */
1301 abstract contract ERC1155Supply is ERC1155 {
1302     mapping(uint256 => uint256) private _totalSupply;
1303 
1304     /**
1305      * @dev Total amount of tokens in with a given id.
1306      */
1307     function totalSupply(uint256 id) public view virtual returns (uint256) {
1308         return _totalSupply[id];
1309     }
1310 
1311     /**
1312      * @dev Indicates whether any token exist with a given id, or not.
1313      */
1314     function exists(uint256 id) public view virtual returns (bool) {
1315         return ERC1155Supply.totalSupply(id) > 0;
1316     }
1317 
1318     /**
1319      * @dev See {ERC1155-_beforeTokenTransfer}.
1320      */
1321     function _beforeTokenTransfer(
1322         address operator,
1323         address from,
1324         address to,
1325         uint256[] memory ids,
1326         uint256[] memory amounts,
1327         bytes memory data
1328     ) internal virtual override {
1329         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1330 
1331         if (from == address(0)) {
1332             for (uint256 i = 0; i < ids.length; ++i) {
1333                 _totalSupply[ids[i]] += amounts[i];
1334             }
1335         }
1336 
1337         if (to == address(0)) {
1338             for (uint256 i = 0; i < ids.length; ++i) {
1339                 uint256 id = ids[i];
1340                 uint256 amount = amounts[i];
1341                 uint256 supply = _totalSupply[id];
1342                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1343                 unchecked {
1344                     _totalSupply[id] = supply - amount;
1345                 }
1346             }
1347         }
1348     }
1349 }
1350 
1351 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1352 
1353 
1354 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Burnable.sol)
1355 
1356 pragma solidity ^0.8.0;
1357 
1358 
1359 /**
1360  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1361  * own tokens and those that they have been approved to use.
1362  *
1363  * _Available since v3.1._
1364  */
1365 abstract contract ERC1155Burnable is ERC1155 {
1366     function burn(
1367         address account,
1368         uint256 id,
1369         uint256 value
1370     ) public virtual {
1371         require(
1372             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1373             "ERC1155: caller is not owner nor approved"
1374         );
1375 
1376         _burn(account, id, value);
1377     }
1378 
1379     function burnBatch(
1380         address account,
1381         uint256[] memory ids,
1382         uint256[] memory values
1383     ) public virtual {
1384         require(
1385             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1386             "ERC1155: caller is not owner nor approved"
1387         );
1388 
1389         _burnBatch(account, ids, values);
1390     }
1391 }
1392 
1393 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1394 
1395 
1396 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 /**
1401  * @dev Interface of the ERC20 standard as defined in the EIP.
1402  */
1403 interface IERC20 {
1404     /**
1405      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1406      * another (`to`).
1407      *
1408      * Note that `value` may be zero.
1409      */
1410     event Transfer(address indexed from, address indexed to, uint256 value);
1411 
1412     /**
1413      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1414      * a call to {approve}. `value` is the new allowance.
1415      */
1416     event Approval(address indexed owner, address indexed spender, uint256 value);
1417 
1418     /**
1419      * @dev Returns the amount of tokens in existence.
1420      */
1421     function totalSupply() external view returns (uint256);
1422 
1423     /**
1424      * @dev Returns the amount of tokens owned by `account`.
1425      */
1426     function balanceOf(address account) external view returns (uint256);
1427 
1428     /**
1429      * @dev Moves `amount` tokens from the caller's account to `to`.
1430      *
1431      * Returns a boolean value indicating whether the operation succeeded.
1432      *
1433      * Emits a {Transfer} event.
1434      */
1435     function transfer(address to, uint256 amount) external returns (bool);
1436 
1437     /**
1438      * @dev Returns the remaining number of tokens that `spender` will be
1439      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1440      * zero by default.
1441      *
1442      * This value changes when {approve} or {transferFrom} are called.
1443      */
1444     function allowance(address owner, address spender) external view returns (uint256);
1445 
1446     /**
1447      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1448      *
1449      * Returns a boolean value indicating whether the operation succeeded.
1450      *
1451      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1452      * that someone may use both the old and the new allowance by unfortunate
1453      * transaction ordering. One possible solution to mitigate this race
1454      * condition is to first reduce the spender's allowance to 0 and set the
1455      * desired value afterwards:
1456      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1457      *
1458      * Emits an {Approval} event.
1459      */
1460     function approve(address spender, uint256 amount) external returns (bool);
1461 
1462     /**
1463      * @dev Moves `amount` tokens from `from` to `to` using the
1464      * allowance mechanism. `amount` is then deducted from the caller's
1465      * allowance.
1466      *
1467      * Returns a boolean value indicating whether the operation succeeded.
1468      *
1469      * Emits a {Transfer} event.
1470      */
1471     function transferFrom(
1472         address from,
1473         address to,
1474         uint256 amount
1475     ) external returns (bool);
1476 }
1477 
1478 // File: contracts/BlinklessMuseum.sol
1479 
1480 
1481 pragma solidity ^0.8.4;
1482 
1483 /****************************************************************
1484 * The Blinkless Museum
1485 * code by @digitalkemical
1486 *****************************************************************/
1487 
1488 
1489 
1490 
1491 
1492 
1493 
1494 
1495 contract BlinklessMuseum is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {
1496 
1497     uint public optixMintPrice = 10000 ether; // cost to mint in optix
1498     uint public currentlyMinting = 1; // token id thats currently minting
1499     uint public pvmRewards = 1; // number of tokens minted during pvm
1500     IERC20 public optixContract; // optix contract address
1501     address public depositAddress = 0xf794E26f81831028a9b54314722224B9D7BD9Af3; // address to deposit optix
1502     bool public pvmActive = true; // switch to enable/disable pvm 
1503     string public metadataURI; // uri to metadata
1504     string public name = "The Blinkless Museum"; // name of collection
1505     string public symbol = "BLKM"; // symbol of collection
1506 
1507     constructor(address _optixContract) ERC1155("") {
1508         // set optix contract
1509         optixContract = IERC20(_optixContract);
1510     }
1511 
1512     /**
1513     * mint a token with optix
1514     */
1515     function mintWithOptix() public whenNotPaused
1516     {
1517         require(currentlyMinting > 0, "Mint not active.");
1518 
1519         // transfer optix (must have approval already!)
1520         optixContract.transferFrom(msg.sender,address(depositAddress),optixMintPrice);
1521         // mint the token
1522         _mint(msg.sender, currentlyMinting, 1, "0x00");
1523 
1524     }
1525 
1526     /**
1527     * set pvm rewards
1528     */
1529     function setPvmRewards(uint _pvmRewards) public onlyOwner {
1530         // set pvm rewards
1531         pvmRewards = _pvmRewards;
1532     }
1533 
1534     /**
1535     * set optix contract address
1536     */
1537     function setOptixContract(address _optixContract) public onlyOwner {
1538         // set optix contract
1539         optixContract = IERC20(_optixContract);
1540     }
1541 
1542      /**
1543     * set currently minting token id
1544     */
1545     function setCurrentlyMinting(uint _currentlyMinting) public onlyOwner {
1546         // set id of token to mint
1547         currentlyMinting = _currentlyMinting;
1548     }
1549 
1550     /**
1551     * toggle PVM on/off
1552     */
1553     function togglePVM() public onlyOwner {
1554         if(pvmActive == true){
1555             pvmActive = false;
1556         } else {
1557             pvmActive = true;
1558         }
1559     }
1560 
1561     /**
1562     * set new metadata uri
1563     */
1564     function setURI(string memory newuri) public onlyOwner {
1565         metadataURI = newuri;
1566     }
1567 
1568     /**
1569     * set new mint price
1570     */
1571     function setMintPrice(uint _price) public onlyOwner {
1572         optixMintPrice = _price;
1573     }
1574 
1575     /**
1576     * pause 
1577     */
1578     function pause() public onlyOwner {
1579         _pause();
1580     }
1581 
1582     /**
1583     * unpause 
1584     */
1585     function unpause() public onlyOwner {
1586         _unpause();
1587     }
1588 
1589     /**
1590     * owner mint
1591     */
1592     function mint(address account, uint256 id, uint256 amount, bytes memory data)
1593         public
1594         onlyOwner
1595     {
1596         _mint(account, id, amount, data);
1597     }
1598 
1599     /**
1600     * owner batch mint
1601     */
1602     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1603         public
1604         onlyOwner
1605     {
1606         _mintBatch(to, ids, amounts, data);
1607     }
1608 
1609     /**
1610     * transfer hook for supply
1611     */
1612     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1613         internal
1614         whenNotPaused
1615         override(ERC1155, ERC1155Supply)
1616     {
1617         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1618         
1619     }
1620 
1621     /**
1622      * @dev See {IERC1155-safeTransferFrom}.
1623      */
1624     function safeTransferFrom(
1625         address from,
1626         address to,
1627         uint256 id,
1628         uint256 amount,
1629         bytes memory data
1630     ) public virtual override {
1631         require(
1632             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1633             "ERC1155: caller is not owner nor approved"
1634         );
1635         _safeTransferFrom(from, to, id, amount, data);
1636 
1637         //pvm must be active, minting art and the recipient must have a zero optix balance
1638         if(pvmActive && currentlyMinting > 0 && optixContract.balanceOf(to) == 0 && balanceOf(to,id) == 1){
1639             // mint the token - PVM
1640             _mint(from, currentlyMinting, pvmRewards, "0x00");
1641         }
1642     }
1643 
1644 
1645     function uri(uint256 _tokenId) public view virtual override returns (string memory) {
1646          return bytes(metadataURI).length != 0 ? string(abi.encodePacked(metadataURI, Strings.toString(_tokenId),'.json')) : '';
1647     }
1648 
1649     function tokenURI(uint256 _tokenId) public view virtual  returns (string memory) {
1650          return bytes(metadataURI).length != 0 ? string(abi.encodePacked(metadataURI, Strings.toString(_tokenId),'.json')) : '';
1651     }
1652 
1653     function contractURI() public view virtual  returns (string memory) {
1654          return bytes(metadataURI).length != 0 ? string(abi.encodePacked(metadataURI, 'museum','.json')) : '';
1655     }
1656 
1657      /*
1658     * Withdraw by owner
1659     */
1660     function withdrawMoney() external onlyOwner {
1661         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1662         require(success, "Transfer failed.");
1663     }
1664 
1665 
1666     /*
1667     * These are here to receive ETH sent to the contract address
1668     */
1669     receive() external payable {}
1670 
1671     fallback() external payable {}
1672    
1673 }