1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
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
79 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
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
106 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor() {
135         _transferOwnership(_msgSender());
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         _checkOwner();
143         _;
144     }
145 
146     /**
147      * @dev Returns the address of the current owner.
148      */
149     function owner() public view virtual returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if the sender is not the owner.
155      */
156     function _checkOwner() internal view virtual {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _transferOwnership(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Internal function without access restriction.
183      */
184     function _transferOwnership(address newOwner) internal virtual {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
192 
193 
194 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
195 
196 pragma solidity ^0.8.1;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * [IMPORTANT]
206      * ====
207      * It is unsafe to assume that an address for which this function returns
208      * false is an externally-owned account (EOA) and not a contract.
209      *
210      * Among others, `isContract` will return false for the following
211      * types of addresses:
212      *
213      *  - an externally-owned account
214      *  - a contract in construction
215      *  - an address where a contract will be created
216      *  - an address where a contract lived, but was destroyed
217      * ====
218      *
219      * [IMPORTANT]
220      * ====
221      * You shouldn't rely on `isContract` to protect against flash loan attacks!
222      *
223      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
224      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
225      * constructor.
226      * ====
227      */
228     function isContract(address account) internal view returns (bool) {
229         // This method relies on extcodesize/address.code.length, which returns 0
230         // for contracts in construction, since the code is only stored at the end
231         // of the constructor execution.
232 
233         return account.code.length > 0;
234     }
235 
236     /**
237      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
238      * `recipient`, forwarding all available gas and reverting on errors.
239      *
240      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
241      * of certain opcodes, possibly making contracts go over the 2300 gas limit
242      * imposed by `transfer`, making them unable to receive funds via
243      * `transfer`. {sendValue} removes this limitation.
244      *
245      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
246      *
247      * IMPORTANT: because control is transferred to `recipient`, care must be
248      * taken to not create reentrancy vulnerabilities. Consider using
249      * {ReentrancyGuard} or the
250      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
251      */
252     function sendValue(address payable recipient, uint256 amount) internal {
253         require(address(this).balance >= amount, "Address: insufficient balance");
254 
255         (bool success, ) = recipient.call{value: amount}("");
256         require(success, "Address: unable to send value, recipient may have reverted");
257     }
258 
259     /**
260      * @dev Performs a Solidity function call using a low level `call`. A
261      * plain `call` is an unsafe replacement for a function call: use this
262      * function instead.
263      *
264      * If `target` reverts with a revert reason, it is bubbled up by this
265      * function (like regular Solidity function calls).
266      *
267      * Returns the raw returned data. To convert to the expected return value,
268      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
269      *
270      * Requirements:
271      *
272      * - `target` must be a contract.
273      * - calling `target` with `data` must not revert.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
278         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
283      * `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, 0, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but also transferring `value` wei to `target`.
298      *
299      * Requirements:
300      *
301      * - the calling contract must have an ETH balance of at least `value`.
302      * - the called Solidity function must be `payable`.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
316      * with `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         (bool success, bytes memory returndata) = target.call{value: value}(data);
328         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but performing a static call.
334      *
335      * _Available since v3.3._
336      */
337     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
338         return functionStaticCall(target, data, "Address: low-level static call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
343      * but performing a static call.
344      *
345      * _Available since v3.3._
346      */
347     function functionStaticCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal view returns (bytes memory) {
352         (bool success, bytes memory returndata) = target.staticcall(data);
353         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
363         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         (bool success, bytes memory returndata) = target.delegatecall(data);
378         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
383      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
384      *
385      * _Available since v4.8._
386      */
387     function verifyCallResultFromTarget(
388         address target,
389         bool success,
390         bytes memory returndata,
391         string memory errorMessage
392     ) internal view returns (bytes memory) {
393         if (success) {
394             if (returndata.length == 0) {
395                 // only check isContract if the call was successful and the return data is empty
396                 // otherwise we already know that it was a contract
397                 require(isContract(target), "Address: call to non-contract");
398             }
399             return returndata;
400         } else {
401             _revert(returndata, errorMessage);
402         }
403     }
404 
405     /**
406      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
407      * revert reason or using the provided one.
408      *
409      * _Available since v4.3._
410      */
411     function verifyCallResult(
412         bool success,
413         bytes memory returndata,
414         string memory errorMessage
415     ) internal pure returns (bytes memory) {
416         if (success) {
417             return returndata;
418         } else {
419             _revert(returndata, errorMessage);
420         }
421     }
422 
423     function _revert(bytes memory returndata, string memory errorMessage) private pure {
424         // Look for revert reason and bubble it up if present
425         if (returndata.length > 0) {
426             // The easiest way to bubble the revert reason is using memory via assembly
427             /// @solidity memory-safe-assembly
428             assembly {
429                 let returndata_size := mload(returndata)
430                 revert(add(32, returndata), returndata_size)
431             }
432         } else {
433             revert(errorMessage);
434         }
435     }
436 }
437 
438 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @dev Interface of the ERC165 standard, as defined in the
447  * https://eips.ethereum.org/EIPS/eip-165[EIP].
448  *
449  * Implementers can declare support of contract interfaces, which can then be
450  * queried by others ({ERC165Checker}).
451  *
452  * For an implementation, see {ERC165}.
453  */
454 interface IERC165 {
455     /**
456      * @dev Returns true if this contract implements the interface defined by
457      * `interfaceId`. See the corresponding
458      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
459      * to learn more about how these ids are created.
460      *
461      * This function call must use less than 30 000 gas.
462      */
463     function supportsInterface(bytes4 interfaceId) external view returns (bool);
464 }
465 
466 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 
474 /**
475  * @dev Implementation of the {IERC165} interface.
476  *
477  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
478  * for the additional interface id that will be supported. For example:
479  *
480  * ```solidity
481  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
482  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
483  * }
484  * ```
485  *
486  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
487  */
488 abstract contract ERC165 is IERC165 {
489     /**
490      * @dev See {IERC165-supportsInterface}.
491      */
492     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
493         return interfaceId == type(IERC165).interfaceId;
494     }
495 }
496 
497 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol
498 
499 
500 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @dev _Available since v3.1._
507  */
508 interface IERC1155Receiver is IERC165 {
509     /**
510      * @dev Handles the receipt of a single ERC1155 token type. This function is
511      * called at the end of a `safeTransferFrom` after the balance has been updated.
512      *
513      * NOTE: To accept the transfer, this must return
514      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
515      * (i.e. 0xf23a6e61, or its own function selector).
516      *
517      * @param operator The address which initiated the transfer (i.e. msg.sender)
518      * @param from The address which previously owned the token
519      * @param id The ID of the token being transferred
520      * @param value The amount of tokens being transferred
521      * @param data Additional data with no specified format
522      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
523      */
524     function onERC1155Received(
525         address operator,
526         address from,
527         uint256 id,
528         uint256 value,
529         bytes calldata data
530     ) external returns (bytes4);
531 
532     /**
533      * @dev Handles the receipt of a multiple ERC1155 token types. This function
534      * is called at the end of a `safeBatchTransferFrom` after the balances have
535      * been updated.
536      *
537      * NOTE: To accept the transfer(s), this must return
538      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
539      * (i.e. 0xbc197c81, or its own function selector).
540      *
541      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
542      * @param from The address which previously owned the token
543      * @param ids An array containing ids of each token being transferred (order and length must match values array)
544      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
545      * @param data Additional data with no specified format
546      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
547      */
548     function onERC1155BatchReceived(
549         address operator,
550         address from,
551         uint256[] calldata ids,
552         uint256[] calldata values,
553         bytes calldata data
554     ) external returns (bytes4);
555 }
556 
557 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol
558 
559 
560 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @dev Required interface of an ERC1155 compliant contract, as defined in the
567  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
568  *
569  * _Available since v3.1._
570  */
571 interface IERC1155 is IERC165 {
572     /**
573      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
574      */
575     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
576 
577     /**
578      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
579      * transfers.
580      */
581     event TransferBatch(
582         address indexed operator,
583         address indexed from,
584         address indexed to,
585         uint256[] ids,
586         uint256[] values
587     );
588 
589     /**
590      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
591      * `approved`.
592      */
593     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
594 
595     /**
596      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
597      *
598      * If an {URI} event was emitted for `id`, the standard
599      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
600      * returned by {IERC1155MetadataURI-uri}.
601      */
602     event URI(string value, uint256 indexed id);
603 
604     /**
605      * @dev Returns the amount of tokens of token type `id` owned by `account`.
606      *
607      * Requirements:
608      *
609      * - `account` cannot be the zero address.
610      */
611     function balanceOf(address account, uint256 id) external view returns (uint256);
612 
613     /**
614      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
615      *
616      * Requirements:
617      *
618      * - `accounts` and `ids` must have the same length.
619      */
620     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
621         external
622         view
623         returns (uint256[] memory);
624 
625     /**
626      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
627      *
628      * Emits an {ApprovalForAll} event.
629      *
630      * Requirements:
631      *
632      * - `operator` cannot be the caller.
633      */
634     function setApprovalForAll(address operator, bool approved) external;
635 
636     /**
637      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
638      *
639      * See {setApprovalForAll}.
640      */
641     function isApprovedForAll(address account, address operator) external view returns (bool);
642 
643     /**
644      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
645      *
646      * Emits a {TransferSingle} event.
647      *
648      * Requirements:
649      *
650      * - `to` cannot be the zero address.
651      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
652      * - `from` must have a balance of tokens of type `id` of at least `amount`.
653      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
654      * acceptance magic value.
655      */
656     function safeTransferFrom(
657         address from,
658         address to,
659         uint256 id,
660         uint256 amount,
661         bytes calldata data
662     ) external;
663 
664     /**
665      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
666      *
667      * Emits a {TransferBatch} event.
668      *
669      * Requirements:
670      *
671      * - `ids` and `amounts` must have the same length.
672      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
673      * acceptance magic value.
674      */
675     function safeBatchTransferFrom(
676         address from,
677         address to,
678         uint256[] calldata ids,
679         uint256[] calldata amounts,
680         bytes calldata data
681     ) external;
682 }
683 
684 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
694  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
695  *
696  * _Available since v3.1._
697  */
698 interface IERC1155MetadataURI is IERC1155 {
699     /**
700      * @dev Returns the URI for token type `id`.
701      *
702      * If the `\{id\}` substring is present in the URI, it must be replaced by
703      * clients with the actual token type ID.
704      */
705     function uri(uint256 id) external view returns (string memory);
706 }
707 
708 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
709 
710 
711 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 
716 
717 
718 
719 
720 
721 /**
722  * @dev Implementation of the basic standard multi-token.
723  * See https://eips.ethereum.org/EIPS/eip-1155
724  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
725  *
726  * _Available since v3.1._
727  */
728 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
729     using Address for address;
730 
731     // Mapping from token ID to account balances
732     mapping(uint256 => mapping(address => uint256)) private _balances;
733 
734     // Mapping from account to operator approvals
735     mapping(address => mapping(address => bool)) private _operatorApprovals;
736 
737     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
738     string private _uri;
739 
740     /**
741      * @dev See {_setURI}.
742      */
743     constructor(string memory uri_) {
744         _setURI(uri_);
745     }
746 
747     /**
748      * @dev See {IERC165-supportsInterface}.
749      */
750     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
751         return
752             interfaceId == type(IERC1155).interfaceId ||
753             interfaceId == type(IERC1155MetadataURI).interfaceId ||
754             super.supportsInterface(interfaceId);
755     }
756 
757     /**
758      * @dev See {IERC1155MetadataURI-uri}.
759      *
760      * This implementation returns the same URI for *all* token types. It relies
761      * on the token type ID substitution mechanism
762      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
763      *
764      * Clients calling this function must replace the `\{id\}` substring with the
765      * actual token type ID.
766      */
767     function uri(uint256) public view virtual override returns (string memory) {
768         return _uri;
769     }
770 
771     /**
772      * @dev See {IERC1155-balanceOf}.
773      *
774      * Requirements:
775      *
776      * - `account` cannot be the zero address.
777      */
778     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
779         require(account != address(0), "ERC1155: address zero is not a valid owner");
780         return _balances[id][account];
781     }
782 
783     /**
784      * @dev See {IERC1155-balanceOfBatch}.
785      *
786      * Requirements:
787      *
788      * - `accounts` and `ids` must have the same length.
789      */
790     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
791         public
792         view
793         virtual
794         override
795         returns (uint256[] memory)
796     {
797         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
798 
799         uint256[] memory batchBalances = new uint256[](accounts.length);
800 
801         for (uint256 i = 0; i < accounts.length; ++i) {
802             batchBalances[i] = balanceOf(accounts[i], ids[i]);
803         }
804 
805         return batchBalances;
806     }
807 
808     /**
809      * @dev See {IERC1155-setApprovalForAll}.
810      */
811     function setApprovalForAll(address operator, bool approved) public virtual override {
812         _setApprovalForAll(_msgSender(), operator, approved);
813     }
814 
815     /**
816      * @dev See {IERC1155-isApprovedForAll}.
817      */
818     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
819         return _operatorApprovals[account][operator];
820     }
821 
822     /**
823      * @dev See {IERC1155-safeTransferFrom}.
824      */
825     function safeTransferFrom(
826         address from,
827         address to,
828         uint256 id,
829         uint256 amount,
830         bytes memory data
831     ) public virtual override {
832         require(
833             from == _msgSender() || isApprovedForAll(from, _msgSender()),
834             "ERC1155: caller is not token owner nor approved"
835         );
836         _safeTransferFrom(from, to, id, amount, data);
837     }
838 
839     /**
840      * @dev See {IERC1155-safeBatchTransferFrom}.
841      */
842     function safeBatchTransferFrom(
843         address from,
844         address to,
845         uint256[] memory ids,
846         uint256[] memory amounts,
847         bytes memory data
848     ) public virtual override {
849         require(
850             from == _msgSender() || isApprovedForAll(from, _msgSender()),
851             "ERC1155: caller is not token owner nor approved"
852         );
853         _safeBatchTransferFrom(from, to, ids, amounts, data);
854     }
855 
856     /**
857      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
858      *
859      * Emits a {TransferSingle} event.
860      *
861      * Requirements:
862      *
863      * - `to` cannot be the zero address.
864      * - `from` must have a balance of tokens of type `id` of at least `amount`.
865      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
866      * acceptance magic value.
867      */
868     function _safeTransferFrom(
869         address from,
870         address to,
871         uint256 id,
872         uint256 amount,
873         bytes memory data
874     ) internal virtual {
875         require(to != address(0), "ERC1155: transfer to the zero address");
876 
877         address operator = _msgSender();
878         uint256[] memory ids = _asSingletonArray(id);
879         uint256[] memory amounts = _asSingletonArray(amount);
880 
881         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
882 
883         uint256 fromBalance = _balances[id][from];
884         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
885         unchecked {
886             _balances[id][from] = fromBalance - amount;
887         }
888         _balances[id][to] += amount;
889 
890         emit TransferSingle(operator, from, to, id, amount);
891 
892         _afterTokenTransfer(operator, from, to, ids, amounts, data);
893 
894         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
895     }
896 
897     /**
898      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
899      *
900      * Emits a {TransferBatch} event.
901      *
902      * Requirements:
903      *
904      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
905      * acceptance magic value.
906      */
907     function _safeBatchTransferFrom(
908         address from,
909         address to,
910         uint256[] memory ids,
911         uint256[] memory amounts,
912         bytes memory data
913     ) internal virtual {
914         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
915         require(to != address(0), "ERC1155: transfer to the zero address");
916 
917         address operator = _msgSender();
918 
919         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
920 
921         for (uint256 i = 0; i < ids.length; ++i) {
922             uint256 id = ids[i];
923             uint256 amount = amounts[i];
924 
925             uint256 fromBalance = _balances[id][from];
926             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
927             unchecked {
928                 _balances[id][from] = fromBalance - amount;
929             }
930             _balances[id][to] += amount;
931         }
932 
933         emit TransferBatch(operator, from, to, ids, amounts);
934 
935         _afterTokenTransfer(operator, from, to, ids, amounts, data);
936 
937         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
938     }
939 
940     /**
941      * @dev Sets a new URI for all token types, by relying on the token type ID
942      * substitution mechanism
943      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
944      *
945      * By this mechanism, any occurrence of the `\{id\}` substring in either the
946      * URI or any of the amounts in the JSON file at said URI will be replaced by
947      * clients with the token type ID.
948      *
949      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
950      * interpreted by clients as
951      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
952      * for token type ID 0x4cce0.
953      *
954      * See {uri}.
955      *
956      * Because these URIs cannot be meaningfully represented by the {URI} event,
957      * this function emits no events.
958      */
959     function _setURI(string memory newuri) internal virtual {
960         _uri = newuri;
961     }
962 
963     /**
964      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
965      *
966      * Emits a {TransferSingle} event.
967      *
968      * Requirements:
969      *
970      * - `to` cannot be the zero address.
971      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
972      * acceptance magic value.
973      */
974     function _mint(
975         address to,
976         uint256 id,
977         uint256 amount,
978         bytes memory data
979     ) internal virtual {
980         require(to != address(0), "ERC1155: mint to the zero address");
981 
982         address operator = _msgSender();
983         uint256[] memory ids = _asSingletonArray(id);
984         uint256[] memory amounts = _asSingletonArray(amount);
985 
986         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
987 
988         _balances[id][to] += amount;
989         emit TransferSingle(operator, address(0), to, id, amount);
990 
991         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
992 
993         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
994     }
995 
996     /**
997      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
998      *
999      * Emits a {TransferBatch} event.
1000      *
1001      * Requirements:
1002      *
1003      * - `ids` and `amounts` must have the same length.
1004      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1005      * acceptance magic value.
1006      */
1007     function _mintBatch(
1008         address to,
1009         uint256[] memory ids,
1010         uint256[] memory amounts,
1011         bytes memory data
1012     ) internal virtual {
1013         require(to != address(0), "ERC1155: mint to the zero address");
1014         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1015 
1016         address operator = _msgSender();
1017 
1018         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1019 
1020         for (uint256 i = 0; i < ids.length; i++) {
1021             _balances[ids[i]][to] += amounts[i];
1022         }
1023 
1024         emit TransferBatch(operator, address(0), to, ids, amounts);
1025 
1026         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1027 
1028         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1029     }
1030 
1031     /**
1032      * @dev Destroys `amount` tokens of token type `id` from `from`
1033      *
1034      * Emits a {TransferSingle} event.
1035      *
1036      * Requirements:
1037      *
1038      * - `from` cannot be the zero address.
1039      * - `from` must have at least `amount` tokens of token type `id`.
1040      */
1041     function _burn(
1042         address from,
1043         uint256 id,
1044         uint256 amount
1045     ) internal virtual {
1046         require(from != address(0), "ERC1155: burn from the zero address");
1047 
1048         address operator = _msgSender();
1049         uint256[] memory ids = _asSingletonArray(id);
1050         uint256[] memory amounts = _asSingletonArray(amount);
1051 
1052         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1053 
1054         uint256 fromBalance = _balances[id][from];
1055         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1056         unchecked {
1057             _balances[id][from] = fromBalance - amount;
1058         }
1059 
1060         emit TransferSingle(operator, from, address(0), id, amount);
1061 
1062         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1063     }
1064 
1065     /**
1066      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1067      *
1068      * Emits a {TransferBatch} event.
1069      *
1070      * Requirements:
1071      *
1072      * - `ids` and `amounts` must have the same length.
1073      */
1074     function _burnBatch(
1075         address from,
1076         uint256[] memory ids,
1077         uint256[] memory amounts
1078     ) internal virtual {
1079         require(from != address(0), "ERC1155: burn from the zero address");
1080         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1081 
1082         address operator = _msgSender();
1083 
1084         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1085 
1086         for (uint256 i = 0; i < ids.length; i++) {
1087             uint256 id = ids[i];
1088             uint256 amount = amounts[i];
1089 
1090             uint256 fromBalance = _balances[id][from];
1091             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1092             unchecked {
1093                 _balances[id][from] = fromBalance - amount;
1094             }
1095         }
1096 
1097         emit TransferBatch(operator, from, address(0), ids, amounts);
1098 
1099         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1100     }
1101 
1102     /**
1103      * @dev Approve `operator` to operate on all of `owner` tokens
1104      *
1105      * Emits an {ApprovalForAll} event.
1106      */
1107     function _setApprovalForAll(
1108         address owner,
1109         address operator,
1110         bool approved
1111     ) internal virtual {
1112         require(owner != operator, "ERC1155: setting approval status for self");
1113         _operatorApprovals[owner][operator] = approved;
1114         emit ApprovalForAll(owner, operator, approved);
1115     }
1116 
1117     /**
1118      * @dev Hook that is called before any token transfer. This includes minting
1119      * and burning, as well as batched variants.
1120      *
1121      * The same hook is called on both single and batched variants. For single
1122      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1123      *
1124      * Calling conditions (for each `id` and `amount` pair):
1125      *
1126      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1127      * of token type `id` will be  transferred to `to`.
1128      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1129      * for `to`.
1130      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1131      * will be burned.
1132      * - `from` and `to` are never both zero.
1133      * - `ids` and `amounts` have the same, non-zero length.
1134      *
1135      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1136      */
1137     function _beforeTokenTransfer(
1138         address operator,
1139         address from,
1140         address to,
1141         uint256[] memory ids,
1142         uint256[] memory amounts,
1143         bytes memory data
1144     ) internal virtual {}
1145 
1146     /**
1147      * @dev Hook that is called after any token transfer. This includes minting
1148      * and burning, as well as batched variants.
1149      *
1150      * The same hook is called on both single and batched variants. For single
1151      * transfers, the length of the `id` and `amount` arrays will be 1.
1152      *
1153      * Calling conditions (for each `id` and `amount` pair):
1154      *
1155      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1156      * of token type `id` will be  transferred to `to`.
1157      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1158      * for `to`.
1159      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1160      * will be burned.
1161      * - `from` and `to` are never both zero.
1162      * - `ids` and `amounts` have the same, non-zero length.
1163      *
1164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1165      */
1166     function _afterTokenTransfer(
1167         address operator,
1168         address from,
1169         address to,
1170         uint256[] memory ids,
1171         uint256[] memory amounts,
1172         bytes memory data
1173     ) internal virtual {}
1174 
1175     function _doSafeTransferAcceptanceCheck(
1176         address operator,
1177         address from,
1178         address to,
1179         uint256 id,
1180         uint256 amount,
1181         bytes memory data
1182     ) private {
1183         if (to.isContract()) {
1184             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1185                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1186                     revert("ERC1155: ERC1155Receiver rejected tokens");
1187                 }
1188             } catch Error(string memory reason) {
1189                 revert(reason);
1190             } catch {
1191                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1192             }
1193         }
1194     }
1195 
1196     function _doSafeBatchTransferAcceptanceCheck(
1197         address operator,
1198         address from,
1199         address to,
1200         uint256[] memory ids,
1201         uint256[] memory amounts,
1202         bytes memory data
1203     ) private {
1204         if (to.isContract()) {
1205             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1206                 bytes4 response
1207             ) {
1208                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1209                     revert("ERC1155: ERC1155Receiver rejected tokens");
1210                 }
1211             } catch Error(string memory reason) {
1212                 revert(reason);
1213             } catch {
1214                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1215             }
1216         }
1217     }
1218 
1219     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1220         uint256[] memory array = new uint256[](1);
1221         array[0] = element;
1222 
1223         return array;
1224     }
1225 }
1226 
1227 // File: contracts/CryptoCloudPunks.sol
1228 
1229 
1230 
1231 pragma solidity ^ 0.8.7;
1232 
1233 
1234 
1235 
1236 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
1237 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#########################################################
1238 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&####################################################################
1239 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#################################################################################
1240 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&########################################################################################
1241 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#############################################################################################
1242 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&###############################################################################################
1243 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##BBBBBBB#####&&#############&&&####BBBBBBBB#####&#######BGGGGGBBBBBBBBBBBB####&&#########################
1244 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##BPY?7!~~~!7?JJJYPGGP55B###########GPY?7!~~~!7??JJYPGGP55B####G~^~~~!!7?JJYPGPPYJ??7777J5B#######################
1245 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#BB5JJJJJYY55PPGGGGGGBBGGY~P#######BG5JJJJJYY55PPGGGGGGBBGBY~G###GJ^Y5PGGGGBBBBBBBBBGGGP5Y?7~~75#####################
1246 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&GYPBBGGBBBB#BBBBBBBBBBBBG55~?55&&#GYPBBGGBBBBBBBBBBBGBGBBBG55~7P5&G5!JGPGBBBBGGGGGGGGGBBBBBBBBG5Y??G###################
1247 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&P?JPBBBBBBBGGGPPPPPPP5PPPP55!.5JP&P?JPBBBBBBBGGGPPPPPPPPPPPP557.5J5#PPJGGGGGGGGPPG5YYYY55PPPPPGGBBGGG5B##################
1248 // &&&&&&&&&&&&&&&&&&&&&&&&&&&B7~JGGB#BBGGGPPP55Y55555YYYYYJ.~PYG7~JGGBBBBGGGPP555Y55555YYYYYJ.~PJ#BBPBBGGPPPPPGGP??J?!^755555PPGBGGBY55B################
1249 // &&&&&&&&&&&&&&&&&&&&&&&&&&P:^YPGBBBGGGP5J7!?Y5GBBBGP5Y?7!~PGY:^YPGBBBGGGP5Y7!7Y5PBBBGP5Y?7!~5GG##Y5BGGGPPPPGGBGYG##B!.J5PP5PPPGPPG??YG################
1250 // &&&&&&&&&&&&&&&&&&&&&&&&&G^^YPBBBGGGP5J~:7PBG5JJ?JY5PB#BBG#P^^YPGBBGGGP5J~:?5GG5YJJJ5PPB#BGG####P!5BGGGGGGGGBPJ5GGGJ:~Y5GPPPPPGP5Y^JPG################
1251 // &&&&&&&&&&&&&&&&&&&&&&&&#?~5PGBBGGGG5J:^PB5JJY5PPGGGPG#####?~5PGBBGGGG5Y^~PB5YJY55PGGGPG######BB!!PGBBGGGGGGG5???777JPGBGGPPPPPYJ:^P5B################
1252 // &&&&&&&&&&&&&&&&&&&&&&&&G7YGGBBGGGGP5!~G#5G#&&&&&######B##G7YGGBBGGGGP57!G#PYG###B########BB##G?.?PPGGGGGGBGGGGGPPBBB##BGGGPP5J7:!PY5#################
1253 // &&&&&&&&&&&&&&&&&&&&&&&&Y!PGGBBGGGGP5~7B##############BB##5!PGGBBGGGGPP?YB##PB###PB#######BB#BP^^5PGGGGGGBBBB#B#PGBBBBGGGGPPY?775P?J##################
1254 // &&&&&&&&&&&&&&&&&&&&&&&&Y!PGGBBBBBBPP77B&#############BB##Y!PGGBBBBBBGG55BBBGBBBB5BBBB####BB#BY~JPGBBBBBGGG5YJ????JJJJYY5PGGPPGPJ?P###################
1255 // &&&&&&&&&&&&&&&&&&&&&&#&G75GGBBBBB#BGGPPGBBBBBGGGPPP5PPG##G75GGBBBBBBBBBGGGGPGPPPY5PPPGBBBBGBBYYGGBBBBBGGGJ!!~~~~~!7?J5PB#BBP5YYP#####################
1256 // &&&&&&&&&&&&&&&&&&&&#####?!PPGBBBB##BBBBPJJ?7!!~~~~!!~?G###JJGGBBBBBGGGP55YYYYYJJ7??JJY5PGGPBBPBBBBBBBBGBGYYGBBBBB######BGP5PGB#######################
1257 // &&&&&&&&&&&&&&&&&&#######P:~Y5GBBB######BBGGGGGGGGGG57YYB##GJYGGGPP5555Y????7??7777777?J5P5YBBBBBBBBBBBB#GBB#BBBBBB#B#################################
1258 // &&&&&&&&&&&&&&&&&########BP^:?5GBB###############BBBPP5JBBBBPJYYJJ?7?JJJJ?7?7777??????JJ5P5JGGBBBBBBBBB#BJG#####BB####################################
1259 // &&&&&&&&&&&&&&&&#########GGBY77YGGBBBBBB##BB##BBBB#BG#P5BBG5J7!!777!!7????777?7?????JJJYYPY?GGGBBBGGPPPGJ?B#####BB####################################
1260 // &&&&&&&&&&&&&&&###########P5B#G5GGP555555YYJJJJJJYYJPBPPBPJ!~!!!!!7!!!!7???7?JJJJ?????JY55YJGGPPPGG5YJJJJP######BB####################################
1261 // &&&&&&&&&&&&&&&############B5Y5GB#BPYJJ7!!~^~~!7?Y5GBBPPP!^^~~~~^^~!7!~!7?J??JJJJJJJYY55PP5YGPPP5PGGGGBBBB######BB####################################
1262 // &&&&&&&&&&&&&&&##############B5J??JYPPGPPPPGBB#####BBBGY~::^^^^^^^^!!~!7?JY?JJ55YYY55PPPPPP5GGP55PGGGGBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1263 // &&&&&&&&&&&&&&################&&#BP5YYYYYY5G###BBBBBBB5~:::^^^:^^^~~~!7?JJYJ5Y555JY555555555P55YYPGBBBBBBB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1264 // &&&&&&&&&&&&&####################################BBBBG7^::::^^^^~~!~!!?JJJYJY5YYY5GGGGGPP55YYJJYY5GBBBB#BG#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1265 // &&&&&&&&&&&&&####################################BBBBG?~^::^^^^^~~~~~7YYYYYYYYY?J5GGGGGGGGGP555YYPPGBBB#BP#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1266 // &&&&&&&&&&&&#####################################BBBBB5~~^^~^^:^~^~!!?55PPGGGGP5PGGGGGGBBBGGGGP5YPGBBBB#BP##BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1267 // &&&&&&&&&&&&####################################BBBBBB5~^^^~^^:^~~~~!!?YGBBBBBBBBBBBBBBBBBBGBBGPPGBBBBB#BG#B##########################################
1268 // &&&&&&&&&&&######################################BBBBBJ:::^^~7!77!~~!!7J5PGBBBBBBBBBBBBBBBGGBBBBBBBBBBB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1269 // &&&&&&&&&&&#######################################BBBBPJJ7~?YPJ5P5YY55PGGGPPGBBBBBBBBBBGP5PBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1270 // &&&&&&&&&&########################################BBBBGPGGG5JPY5GBBBBGGBBGGGGGBBBBBBBGPY5GBBBBBBBBBBB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1271 // &&&&&&&&&&########################################BBBBBBBP5PJJYYGBGGBPPGGPYGGGPPPPGGGGGGBBBBBBBBBBBGB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1272 // &&&&&&&&&######################################B####BBBBBBY7!7J?JY55GP555J5GPPGGBBBBBBBBBBBBBBBBB#BGBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1273 // &&&&&&&&#######################################BB####BBBBB57?JYJJ777JJJYJPGPGGBBBBBBBBBBBGBBBBBBB#BPBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1274 // &&&&&&&&#######################################BB######BBBGPGGPY5YY55YYPGGGGBBBBBBBBBBBBGGGBBBBBB#BPB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1275 // &&&&&&&&#######################################BB######BBBBBBBGGPGGPP55BBBBBBBBBBBBBBBBBBBGBBBBBB#B5B#BB#BBBBBBBB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1276 // &&&&&&&&&######################################BB######BB#BBBBPPBGPPY5PGGGBBBBBBBBBBBBBBBBGGGB#BB#BJB#BB#BBBBBBBB#BB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1277 // &&&&&&&&&###############################BB#####BB######BB##BBBGJ5Y5YJYP5GGGBBBBBBBBBBBBBBBGGPB#BB#B?G#BB#BBBBBBBB#GG#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1278 // &&&&&&&&&&##############################BB#####GB######BB###BBBP5YYJYYGGPBBBBBBGBBGGBBBBBGGBGBBBB#BJB#BB#BBBBB#BB#PP#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1279 // &&&&&&&&&&##############################BB#####GG######B#####BBB5YY5PPGBBBBBBBGPGGGBGBBBBBBBBBBBB#B5B#GG#BBBBBBBB#GG#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1280 // &&&&&&&&&&&#############################BB#####PPB#####BB#####BBBGBBBGGBBBBBGGPYGBBBGBBB###BGG#BBBBPB#PP#B#BGB#BB#BB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1281 // &&&&&&&&&&&#########################B###GG#####55B#####BB######B##BGGGGGGBGGPPPPBBBBGB#####BGG#BBBBGB#GG#B#BGB#BB#BB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1282 // &&&&&&&&&&&&########################G###GP#####YJB#####BB#########BBBGGGGPPGGGPPBB#BGB######PG#BBBBGB#BB#B#GPB#B##BB#BBBB#BBB#BBBBBBBBBBBBBBBBBBBBBBBB
1283 // &&&&&&&&&&&&&#######################B###P5####BJ?GBBBB#GB#BBB####BBGG5Y55Y5PGGP5BBBGPBBBBBBBJYBBBBBBB#BB###G5BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
1284 // &&&&&&&&&&&&&################BBBBBBBBBBBYJBBBGGJJGBGGPP?JYYJ???JYYYYJ?JYYYYJJ57~?Y5Y75P5YJYY~7P5PPPPGBGPPPGY7GBBBGGGGGGGGGGGBBBBBBBBBBBBBBBBBBBBBBBBBB
1285 // &&&&&&&&&&&&&&##############BBBBBBBGGGGP7!55YY?:.~~!??7^~!!77?7!::~!~^~7Y5PJ!7~:~YPY~YYJ??J7:.^^^~~~~~^!?JJ!^?JJJYYY5YPPPGGGBBBBBBBBBBBBBBBBBBBBBBBBBB
1286 // &&&&&&&&#####################BBBGGP5YJ??!!?7!77~~7!:^7J~?555YYYJJJ?JJJJJJJJJJJJJJJJ7:?JJJJJJ^~777!~!??7!~^:..^^:^~7JYJPGGBBBBBB#########BBBBBBBBBBBBBB
1287 // &&&&&&&#########BBBBBBBBGGGGPPP555YJ7!~^..^:^!7?YP5YYYJ^~7?JJJJYYY55555PPPPPPPPPPPPJ~Y55YYYJ~~J?JJJ?JJJJ??J7~JYJ?777!^~7??JYY55PPPGGGBBBBBBBBBBBBBB###
1288 // &&&&&&&&&&&&&######BBBBGGGPP555Y?!?J5PPPJ?Y5PP5??JJ??J?^7J5PGGGBBBBBBB#############GYBBBBBBGY5P55YJ????JYYY7!YYJ!~^^:.....:~!7??JY55PPGGGGBBBBBBBBB###
1289 // ###############BBBBBGGGP55YJJ7~^~7J??7?PPPGP55Y????JY5P?55GBB######################BPB#####BGGBBGGGP5YJ???J7~?5PPY!:~!??7^.~??JYY55PPPGGGGGBBBBBBBBBBB
1290 // #########BBBBBBBBBGGGGGPPP55J!:?5YJ7~:?GP55?JYJ?7!J5PPG5P5G########################BGB######BBBBBBGGP5Y?7????YY5PGGY~!!7?7^.^7?JYY55PPPGGGGGGGGGBBBBBB
1291 // &&&&&############BBBGGP55YJ?~..^7!~:. ~PGPPYJYYJJ77JY5PYP5GBBBB####################BB######BBBBBGGPP5J???JJ?!?YPGGP5PGGGBGJ:!YPPPGGGBBBBBBB###########
1292 // &&&&&&&&&&#####BBGGP5YYJ7!~^^: .!YPP5Y~7YPGBGP5YY7?JJJ?7??YPPPPGBBBBBBB#BB#######BBBGBBBBGGGP555YJJ???JJYJJJYPGPY7^^~!??7!^^!?JJYY55PPGGGGBBBBB#######
1293 // &&&&&&&######BBBBGGPPP55YJJ???7!^^7YPGJ5J7!!7J5PGJ5P55Y???JJJ?!JYYYYY5555?555555555YJYYYYJJJ??JJJJJY555PPP5Y5P5J7!!~:.:. .:^~!77?JYY55PPPGGGGBBBBBB###
1294 // &&&##########BBBBBBBBGGGP55YJ?77!!^:^^::!7JJJY5YJ~!?JY5Y55PPPY755YYYYYYYY7YYYJJYYYYYJY55Y55555PPPPPGGGGP5?!::^7??77!~!7??77!!!!!7?JY55PPGGGGGBBBBBBBBB
1295 // &###############BBBBGGGGGGPPPPPPP5555YJJYJ?7!!^:..:~~^^:!?Y5PY7PPPGGGGGPYJYYYYPGGGP5J??J??7!!?YPPPPPPPP55Y?7~. ::^^!7JJYY55PPPPPPPPPPPPGGGGGBBBBBBBBBB
1296 // &&&&&&&&&&################BBBBBGGGGGP5?7~^:^~!!!~:::~!77?JYYYJ?PPGBBBBPJ. ^~J~JGGGPY!: ::^~^..^~!7!~^:.^JYYY555YJ??JYY5PPGGGGPPGGGGGBBBBBBBBBBBBBBBB##
1297 // &&&&&&&&&&&&&&&&&############BBBGGP5YJJYY555YJJ?JJY55YYYYYJJJJJPGBBBGPY!.:!JYY~75P5Y?!^. :^~~~~^::^!77!7JYPGGBBBBBBGGPPPPPGGBBBBBBBBBGGGGBBBBBBBBBBBBB
1298 // &&&&&&&&&&&&&&&&&&&#########BBBBGGBBBBBGGPPPPGGGGPPPGGGGGGGGBBB#####BGPY?JPPPG7!5GGGPPYJ!!?JJY555J??JY5PGGGGGBBB########BBBBGGBBBB########BBBBBBBBBBBB
1299 // &&&&&&&&&&&&&&&&&&&&&&###########BBBGGGBBBB#BBBBBBBB##BB############BBGPPPGBGB5J5BBBBBBGP5555PGGBBGGPP5PGBB#######################BBBBB#############BB
1300 // &&&&&&&&&&&&&&&&&&&&&&&&&####BBBBBBB#################################BBGGBBBB#G5PB######BBGGGGBBBBBBBBBBGGGBB#########################################
1301 // &&&&&&&&&&&&&&&&&&&&&&####BBBB#######################################BBGBB####BGGB#########BBBBB##########BBBBBB######################################
1302 // &&&&&&&&&&&&&&&&&&&############&&&&&&&&&&&###########################BBBB#####BGGB############################BBBB####################################
1303 // &&&&&&&&&&&&&&&&&&&#&&&&&&&&&&&&&&&&&&&&&&&&&########################BBB######BBBB####################################################################
1304 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&################################BBB####################################################################
1305 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&###################################################################################################
1306 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&################################################################################################
1307 
1308 contract CryptoCloudPunks is ERC1155, Ownable {
1309     // editing section starts below here
1310     string public name = "Crypto Cloud Punks"; //name your NFT collection
1311     string public symbol = "CCPS"; //few letters to represent the symbol of your collection
1312     string private ipfsCID = "QmWAE7eWhf1Mq8jeRGuE7brP3186Vpv28QLTDhhrYJVgCU"; // ipfs metadata folder CID as the starting or hidden NFT
1313     uint256 public collectionTotal = 8888; // total number of NFTs to start your collection
1314     uint256 public cost = 0.01 ether;  // Phase 1 price per mint
1315     uint256 public maxMintAmount = 20; // max amount a user other than owner can mint at in one session
1316     uint256 public maxBatchMintAmount = 20;  // max batch amount a user other than owner can mint at in one session
1317     uint256 public whitelisterLimit = 88; // max amount a whitelisted user can mint during presale 
1318     // editing section end
1319 
1320     bool public paused = false;
1321     bool public revealed = false;
1322     bool public mintInOrder = true;
1323 
1324     uint256 public ogCollectionTotal; // the original collection total
1325     uint256 public tokenNextToMint; //next token index to mint
1326     mapping(uint => string) private tokenURI;
1327     mapping(uint256 => uint256) private currentSupply;
1328     mapping(uint256 => bool) private hasMaxSupply;
1329     mapping(uint256 => uint256) public maxSupply;
1330     mapping(uint256 => bool) private createdToken; // if true token has been minted at least one time or was updated into the collection total
1331 
1332     bool public onlyWhitelisted = true;
1333     address[] public whitelistedAddresses;
1334     mapping(address => uint256) public whitelisterMintedBalance;
1335 
1336     address payable public payments; //0xCc4e40f98C507501F5DF1BCc8BAE21b4637d6f7b the payout address for the withdraw function
1337     address public admin_1 = 0x522ee4130B819355e10218E40d6Ab0c495219690;
1338 
1339     constructor() ERC1155(""){
1340         ogCollectionTotal = collectionTotal;
1341         maxSupply[1] = 1;
1342         hasMaxSupply[1] = true;
1343         createdToken[1] = true;
1344         currentSupply[1] = 1; //sets current supply to the amount minted on deploy
1345         tokenNextToMint = 2; //sets the next token index to mint on deploy
1346         _mint(msg.sender, 1, 1, ""); //sends Owner, NFT id 1, amount 1
1347     }
1348 
1349     /**
1350      * @dev The contract developer's website.
1351      */
1352     function contractDev() public pure returns(string memory){
1353         string memory dev = unicode"🐸 HalfSuperShop.com 🐸";
1354         return dev;
1355     }
1356 
1357     /**
1358      * @dev Admin can set the PAUSE state.
1359      * true = closed to Admin Only
1360      * false = open for Presale or Public
1361      */
1362     function pause(bool _state) public onlyAdmins {
1363         paused = _state;
1364     }
1365 
1366     /**
1367      * @dev Allows Admins, Whitelisters, and Public to Mint NFTs in Order from 1-ogCollectionTotal.
1368      * Can only be called by the Public when onlyWhitelisted is false.
1369      */
1370     function _mintInOrder(uint _numberOfTokensToMint) public payable {
1371         require(mintInOrder, "This Can Only Be Used When mintInOrder is True");
1372         require(!paused, "Contract Paused");
1373         require(!exists(8888), "Collection Minted Out");
1374         require(_numberOfTokensToMint + tokenNextToMint <= ogCollectionTotal + 1, "Exceeds Collection Total, Please Lower Amount");
1375 
1376         if (!checkIfAdmin()) {
1377             if (onlyWhitelisted) {
1378                 require(isWhitelisted(msg.sender), "Not Whitelisted");
1379                 uint256 whitelisterMintedCount = whitelisterMintedBalance[msg.sender];
1380                 require(whitelisterMintedCount + _numberOfTokensToMint <= whitelisterLimit, "Exceeded Max Whitelist Mint Limit");
1381             }
1382             require(msg.value >= (_numberOfTokensToMint * costPhase()), "Insufficient Funds");
1383         }
1384 
1385         whitelisterMintedBalance[msg.sender] += _numberOfTokensToMint;
1386 
1387         uint256[] memory _ids = new uint256[](_numberOfTokensToMint);
1388         uint256[] memory _amounts = new uint256[](_numberOfTokensToMint);
1389         for (uint256 i = 0; i < _numberOfTokensToMint; i++) {
1390             uint256 _id = tokenNextToMint;
1391             if (!exists(_id)) {
1392                 createdToken[_id] = true;
1393                 maxSupply[_id] = 1;
1394                 hasMaxSupply[_id] = true;
1395                 currentSupply[_id] = 1;
1396             }
1397 
1398             _ids[i] = tokenNextToMint;
1399             _amounts[i] = 1;
1400             tokenNextToMint++;
1401         }
1402 
1403         _mintBatch(msg.sender, _ids, _amounts, "");
1404     }
1405 
1406     function costPhase() public view returns(uint256){
1407         if (tokenNextToMint <= 100){
1408             return 10000000000000000;
1409         }
1410         if (tokenNextToMint >= 101 && tokenNextToMint <= 300){
1411             return 30000000000000000;
1412         }
1413         if (tokenNextToMint >= 301 && tokenNextToMint <= 8888){
1414             return 60000000000000000;
1415         }
1416         return cost;
1417     }
1418 
1419     /**
1420      * @dev Allows Owner, Whitelisters, and Public to Mint a single NFT.
1421      * Can only be called by the Public when onlyWhitelisted is false.
1422      */
1423     function mint(address _to, uint _id, uint _amount) public payable {
1424         require(!mintInOrder, "Only Can Use the Mint In Order Function At This Time");
1425         require(!paused, "Contract Paused");
1426         require(canMintChecker(_id, _amount), "CANNOT MINT");
1427         if (_id <= ogCollectionTotal){
1428             require(oneOfOneOnly(_id, _amount), "Amount must be 1 for this NFT");
1429             require(!createdToken[_id], "Token Already Minted");
1430             maxSupply[_id] = 1;
1431             hasMaxSupply[_id] = true;
1432         }
1433 
1434         if (!checkIfAdmin()) {
1435             if (onlyWhitelisted == true) {
1436                 require(isWhitelisted(msg.sender), "Not Whitelisted");
1437                 uint256 whitelisterMintedCount = whitelisterMintedBalance[msg.sender];
1438                 require(whitelisterMintedCount + _amount <= whitelisterLimit, "Exceeded Max Whitelist Mint Limit");
1439             }
1440             require(msg.value >= (_amount * cost), "Insufficient Funds");
1441         }
1442 
1443         whitelisterMintedBalance[msg.sender] += _amount;
1444         currentSupply[_id] += _amount;
1445         if (!exists(_id)) {
1446             createdToken[_id] = true;            
1447         }
1448         _mint(_to, _id, _amount, "");
1449     }
1450 
1451     function canMintChecker(uint _id, uint _amount) private view returns(bool){
1452         if (hasMaxSupply[_id]) {
1453             if (_amount > 0 && _amount <= maxMintAmount && _id > 0 && _id <= collectionTotal && currentSupply[_id] + _amount <= maxSupply[_id]) {
1454                 // CAN MINT
1455             }
1456             else {
1457                 // CANNOT MINT 
1458                 return false;
1459             }
1460         }
1461         else {
1462             if (_amount > 0 && _amount <= maxMintAmount && _id > 0 && _id <= collectionTotal) {
1463                 // CAN MINT
1464             }
1465             else {
1466                 // CANNOT MINT 
1467                 return false;
1468             }
1469         }
1470 
1471         return true;
1472     }
1473 
1474     /**
1475      * @dev Allows Owner, Whitelisters, and Public to Mint multiple NFTs.
1476      * Can only be called by the Public when onlyWhitelisted is false.
1477      * Note: Only mint a max of {mintMaxAmount} or less NFT IDs with a totaling amount of {maxBatchMintAmount} at a time.
1478      * Example to Mint 3 of each Token IDs 1, 2, 3, 4:
1479      * _ids = [1,2,3,4]
1480      * _amounts = [3,3,3,3]
1481      * 4 seperate NFTs with a quantity of 3 each has a totaling amount of 12.
1482      */
1483     function mintBatch(address _to, uint[] memory _ids, uint[] memory _amounts) public payable {
1484         require(!mintInOrder, "Only Can Use the Mint In Order Function At This Time");
1485         require(!paused, "Contract Paused");
1486         require(_ids.length <= maxMintAmount, "Batch Token IDs Limit Exceeded");
1487         require(_ids.length == _amounts.length, "IDs Array Not Equal To Amounts Array");
1488         require(canMintBatchChecker(_ids, _amounts), "CANNOT MINT BATCH");
1489 
1490         uint256 _totalBatchAmount;
1491         for (uint256 i = 0; i < _amounts.length; i++) {
1492             uint256 _id = _ids[i];
1493             uint256 _amount = _amounts[i];
1494             if (_id <= ogCollectionTotal){
1495                 require(oneOfOneOnly(_id, _amount), "Amount must be 1 for this NFT");
1496                 require(!createdToken[_id], "Token Already Minted");
1497                 maxSupply[_id] = 1;
1498                 hasMaxSupply[_id] = true;
1499             }
1500             _totalBatchAmount += _amounts[i];
1501         }
1502         require(_totalBatchAmount <= maxBatchMintAmount, "Batch Amount Limit Exceeded");
1503 
1504         if (!checkIfAdmin()) {
1505             if (onlyWhitelisted) {
1506                 require(isWhitelisted(msg.sender), "Not Whitelisted");
1507                 uint256 whitelisterMintedCount = whitelisterMintedBalance[msg.sender];
1508                 require(whitelisterMintedCount + _totalBatchAmount <= whitelisterLimit, "Exceeded Max Whitelist Mint Limit");
1509             }
1510             require(msg.value >= (_totalBatchAmount * cost), "Insufficient Funds");
1511         }
1512 
1513         whitelisterMintedBalance[msg.sender] += _totalBatchAmount;
1514 
1515         for (uint256 k = 0; k < _ids.length; k++) {
1516             currentSupply[_ids[k]] += _amounts[k];
1517             uint256 _id = _ids[k];
1518             if (!exists(_id)) {
1519                 createdToken[_id] = true;
1520             }
1521         }
1522 
1523         _mintBatch(_to, _ids, _amounts, "");
1524     }
1525 
1526     function canMintBatchChecker(uint[] memory _ids, uint[] memory _amounts)private view returns(bool){
1527         for (uint256 i = 0; i < _ids.length; i++) {
1528             uint256 _id = _ids[i];
1529             uint256 _amount = _amounts[i];
1530             if (hasMaxSupply[_id]) {
1531                 if (_amount > 0 && _amount <= maxMintAmount && _id > 0 && _id <= collectionTotal && currentSupply[_id] + _amount <= maxSupply[_id]) {
1532                     // CAN MINT
1533                 }
1534                 else {
1535                     // CANNOT MINT
1536                     return false;
1537                 }
1538             }
1539             else {
1540                 if (_amount > 0 && _amount <= maxMintAmount && _id > 0 && _id <= collectionTotal) {
1541                     // CAN MINT
1542                 }
1543                 else {
1544                     // CANNOT MINT
1545                     return false;
1546                 }
1547             }
1548         }
1549 
1550         return true;
1551     }
1552 
1553     /**
1554      * @dev Allows Admin to Mint a single NEW NFT.
1555      * Can only be called by the current owner.
1556      * Note: NEW NFT means above and beyond the original collection total.
1557      */
1558     function adminMint(address _to, uint _id, uint _amount) external onlyAdmins {
1559         require(_id > ogCollectionTotal, "ID Must Not Be From Original Collection");
1560         if (!exists(_id)) {
1561             createdToken[_id] = true;
1562             collectionTotal++;
1563         }
1564         currentSupply[_id] += _amount;
1565         _mint(_to, _id, _amount, "");
1566     }
1567 
1568     /**
1569      * @dev Allows Admin to Mint multiple NEW NFTs.
1570      * Can only be called by the current owner.
1571      * Note: NEW NFT means above and beyond the original collection total.
1572      * Ideally it's best to only mint a max of 70 or less NFT IDs at a time.
1573      * Example to Mint 3 of each Token IDs 1, 2, 3, 4:
1574      * _ids = [1,2,3,4]
1575      * _amounts = [3,3,3,3]
1576      */
1577     function adminMintBatch(address _to, uint[] memory _ids, uint[] memory _amounts) external onlyAdmins {
1578         require(!checkIfOriginal(_ids), "ID Must Not Be From Original Collection");
1579         for (uint256 i = 0; i < _ids.length; ++i) {
1580             uint256 _id = _ids[i];
1581             if (!exists(_id)) {
1582                 createdToken[_id] = true;
1583                 collectionTotal++;
1584             }
1585             currentSupply[_id] += _amounts[i];
1586         }
1587         _mintBatch(_to, _ids, _amounts, "");
1588     }
1589 
1590     /**
1591     * @dev Allows User to DESTROY a single token they own.
1592     */
1593     function burn(uint _id, uint _amount) external {
1594         currentSupply[_id] -= _amount;
1595         _burn(msg.sender, _id, _amount);
1596     }
1597 
1598     /**
1599     * @dev Allows User to DESTROY multiple tokens they own.
1600     */
1601     function burnBatch(uint[] memory _ids, uint[] memory _amounts) external {
1602         for (uint256 i = 0; i < _ids.length; ++i) {
1603             uint256 _id = _ids[i];
1604             currentSupply[_id] -= _amounts[i];
1605         }
1606         _burnBatch(msg.sender, _ids, _amounts);
1607     }
1608 
1609     /**
1610     * @dev Allows Admin to REVEAL the original collection.
1611     * Can only be called by the current owner once.
1612     * WARNING: Please ensure the CID is 100% correct before execution.
1613     */
1614     function reveal(string memory _uri) external onlyAdmins {
1615         require(!revealed, "Already set to Revealed");
1616         ipfsCID = _uri;
1617         revealed = true;
1618     }
1619 
1620     /**
1621     * @dev Allows Admin to set the URI of a single token.
1622     * Note: Original Token URIs cannot be changed.
1623     *       Set _isIpfsCID to true if using only IPFS CID for the _uri.
1624     */
1625     function setURI(uint _id, string memory _uri, bool _isIpfsCID) external onlyAdmins {
1626         require(_id > ogCollectionTotal, "ID Must Not Be From Original Collection");
1627         if (_isIpfsCID) {
1628             string memory _uriIPFS = string(abi.encodePacked(
1629                 "ipfs://",
1630                 _uri,
1631                 "/",
1632                 Strings.toString(_id),
1633                 ".json"
1634             ));
1635 
1636             tokenURI[_id] = _uriIPFS;
1637             emit URI(_uriIPFS, _id);
1638         }
1639         else {
1640             tokenURI[_id] = _uri;
1641             emit URI(_uri, _id);
1642         }
1643     }
1644 
1645     /**
1646     * @dev Allows Admin to set the URI of multiple tokens.
1647     * Note: Original Token URIs cannot be changed.
1648     *       Set _isIpfsCID to true if using only IPFS CID for the _uri.
1649     */
1650     function setBatchURI(uint[] memory _ids, string memory _uri, bool _isIpfsCID) external onlyAdmins {
1651         require(_ids.length > 1, "Must have at least 2 ids");
1652         require(!checkIfOriginal(_ids), "ID Must Not Be From Original Collection");
1653 
1654         for (uint256 i = 0; i < _ids.length; ++i) {
1655             uint256 _id = _ids[i];
1656             if (_isIpfsCID) {
1657                 string memory _uriIPFS = string(abi.encodePacked(
1658                     "ipfs://",
1659                     _uri,
1660                     "/",
1661                     Strings.toString(_id),
1662                     ".json"
1663                 ));
1664 
1665                 tokenURI[_id] = _uriIPFS;
1666                 emit URI(_uriIPFS, _id);
1667             }
1668             else {
1669                 tokenURI[_id] = _uri;
1670                 emit URI(_uri, _id);
1671             }
1672         }
1673     }
1674 
1675     function uri(uint256 _id) override public view returns(string memory){
1676         if (_id > 0 && _id <= ogCollectionTotal) {
1677             if(!revealed){
1678                 return (
1679                 string(abi.encodePacked(
1680                     "ipfs://",
1681                     ipfsCID,
1682                     "/",
1683                     "hidden",
1684                     ".json"
1685                 )));
1686             }
1687             else{
1688                 return (
1689                 string(abi.encodePacked(
1690                     "ipfs://",
1691                     ipfsCID,
1692                     "/",
1693                     Strings.toString(_id),
1694                     ".json"
1695                 )));
1696             }
1697                 
1698         }
1699         else {
1700             return tokenURI[_id];
1701         }
1702     }
1703 
1704     function checkIfOriginal(uint[] memory _ids) private view returns(bool){
1705         for (uint256 i = 0; i < _ids.length; ++i) {
1706             uint256 _id = _ids[i];
1707             if (_id <= ogCollectionTotal) {
1708                 // original
1709             }
1710             else {
1711                 // new
1712                 return false;
1713             }
1714         }
1715         return true;
1716     }
1717 
1718     function oneOfOneOnly (uint _id, uint _amount) private view returns (bool){
1719         if (_id <= ogCollectionTotal && _amount == 1){
1720             return true;
1721         }
1722         else{
1723             return false;
1724         }
1725     }
1726 
1727     /**
1728     * @dev Total amount of tokens in with a given id.
1729     */
1730     function totalSupply(uint256 _id) public view returns(uint256) {
1731         return currentSupply[_id];
1732     }
1733 
1734     /**
1735      * @dev Indicates whether any token exist with a given id, or not.
1736      */
1737     function exists(uint256 _id) public view returns(bool) {
1738         return createdToken[_id];
1739     }
1740 
1741     /**
1742     * @dev Checks max supply of token with the given id.
1743     */
1744     function checkMaxSupply(uint256 _id) public view returns(uint256) {
1745         if(_id <= ogCollectionTotal){
1746             return 1;
1747         }
1748         else{
1749             return maxSupply[_id];
1750         }
1751     }
1752 
1753     /**
1754      * @dev Admin can set a supply limit.
1755      * Note: If supply amount is set to 0 that will make the supply limitless.
1756      */
1757     function setMaxSupplies(uint[] memory _ids, uint[] memory _supplies) external onlyAdmins {
1758         for (uint256 i = 0; i < _ids.length; i++) {
1759             uint256 _id = _ids[i];
1760             maxSupply[_id] += _supplies[i];
1761             if (_supplies[i] > 0) {
1762                 // has a max limit
1763                 hasMaxSupply[i] = true;
1764             }
1765             else {
1766                 // infinite supply, because you wouldn't create a token max supply with an amount of zero 
1767                 hasMaxSupply[i] = false;
1768             }
1769         }
1770     }
1771 
1772     /**
1773      * @dev Admin can update the collection total to allow minting the newly added NFTs.
1774      */
1775     function updateCollectionTotal(uint _amountToAdd) external onlyAdmins {
1776         collectionTotal += _amountToAdd;
1777     }
1778 
1779     /**
1780      * @dev Check if address is whitelisted.
1781      */
1782     function isWhitelisted(address _user) public view returns(bool) {
1783         for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
1784             if (whitelistedAddresses[i] == _user) {
1785                 return true;
1786             }
1787         }
1788         return false;
1789     }
1790 
1791     /**
1792      * @dev Admin can set the amount of NFTs a user can mint in one session.
1793      */
1794     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyAdmins {
1795         maxMintAmount = _newmaxMintAmount;
1796     }
1797 
1798     /**
1799      * @dev Admin can set the max amount of NFTs a whitelister can mint during presale.
1800      */
1801     function setNftPerWhitelisterLimit(uint256 _limit) public onlyAdmins {
1802         whitelisterLimit = _limit;
1803     }
1804 
1805     /**
1806      * @dev Admin can set the PRESALE state.
1807      * true = presale ongoing for whitelisters only
1808      * false = sale open to public
1809      */
1810     function setOnlyWhitelisted(bool _state) public onlyAdmins {
1811         onlyWhitelisted = _state;
1812     }
1813 
1814     /**
1815      * @dev Admin can set the addresses as whitelisters.
1816      * Example: ["0xADDRESS1", "0xADDRESS2", "0xADDRESS3"]
1817      */
1818     function whitelistUsers(address[] calldata _users) public onlyAdmins {
1819         delete whitelistedAddresses;
1820         whitelistedAddresses = _users;
1821     }
1822 
1823     /**
1824      * @dev Admin can set the new cost in WEI.
1825      * 1 ETH = 10^18 WEI
1826      * Use https://coinguides.org/ethereum-unit-converter-gwei-ether/ for conversions.
1827      */
1828     function setCost(uint256 _newCost) public onlyAdmins {
1829         cost = _newCost;
1830     }
1831 
1832     /**
1833      * @dev Admin can set the payout address.
1834      */
1835     function setPayoutAddress(address _address) external onlyOwner{
1836         payments = payable(_address);
1837     }
1838 
1839     /**
1840      * @dev Admin can pull funds to the payout address.
1841      */
1842     function withdraw() public payable onlyAdmins {
1843         require(payments != 0x0000000000000000000000000000000000000000, "Payout Address Must Be Set First");
1844         (bool success, ) = payable(payments).call{ value: address(this).balance } ("");
1845         require(success);
1846     }
1847 
1848     /**
1849      * @dev Auto send funds to the payout address.
1850         Triggers only if funds were sent directly to this address.
1851      */
1852     receive() payable external {
1853         require(payments != 0x0000000000000000000000000000000000000000, "Payout Address Must Be Set First");
1854         uint256 payout = msg.value;
1855         payments.transfer(payout);
1856     }
1857 
1858      /**
1859      * @dev Throws if called by any account other than the owner or admin.
1860      */
1861     modifier onlyAdmins() {
1862         _checkAdmins();
1863         _;
1864     }
1865 
1866     /**
1867      * @dev Throws if the sender is not the owner or admin.
1868      */
1869     function _checkAdmins() internal view virtual {
1870         require(msg.sender == owner() || msg.sender == admin_1, "Admin Only: caller is not an admin");
1871     }
1872 
1873     function checkIfAdmin() public view returns(bool) {
1874         if (msg.sender == owner() || msg.sender == admin_1){
1875             return true;
1876         }
1877         else{
1878             return false;
1879         }
1880     }
1881 
1882 }