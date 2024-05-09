1 // File: Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
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
70 
71 // File: Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
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
119     address private _owner;
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
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
176         address oldOwner = _owner;
177         _owner = newOwner;
178         emit OwnershipTransferred(oldOwner, newOwner);
179     }
180 }
181 
182 // File: Address.sol
183 
184 
185 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev Collection of functions related to the address type
191  */
192 library Address {
193     /**
194      * @dev Returns true if `account` is a contract.
195      *
196      * [IMPORTANT]
197      * ====
198      * It is unsafe to assume that an address for which this function returns
199      * false is an externally-owned account (EOA) and not a contract.
200      *
201      * Among others, `isContract` will return false for the following
202      * types of addresses:
203      *
204      *  - an externally-owned account
205      *  - a contract in construction
206      *  - an address where a contract will be created
207      *  - an address where a contract lived, but was destroyed
208      * ====
209      *
210      * [IMPORTANT]
211      * ====
212      * You shouldn't rely on `isContract` to protect against flash loan attacks!
213      *
214      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
215      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
216      * constructor.
217      * ====
218      */
219     function isContract(address account) internal view returns (bool) {
220         // This method relies on extcodesize/address.code.length, which returns 0
221         // for contracts in construction, since the code is only stored at the end
222         // of the constructor execution.
223 
224         return account.code.length > 0;
225     }
226 
227     /**
228      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
229      * `recipient`, forwarding all available gas and reverting on errors.
230      *
231      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
232      * of certain opcodes, possibly making contracts go over the 2300 gas limit
233      * imposed by `transfer`, making them unable to receive funds via
234      * `transfer`. {sendValue} removes this limitation.
235      *
236      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
237      *
238      * IMPORTANT: because control is transferred to `recipient`, care must be
239      * taken to not create reentrancy vulnerabilities. Consider using
240      * {ReentrancyGuard} or the
241      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
242      */
243     function sendValue(address payable recipient, uint256 amount) internal {
244         require(address(this).balance >= amount, "Address: insufficient balance");
245 
246         (bool success, ) = recipient.call{value: amount}("");
247         require(success, "Address: unable to send value, recipient may have reverted");
248     }
249 
250     /**
251      * @dev Performs a Solidity function call using a low level `call`. A
252      * plain `call` is an unsafe replacement for a function call: use this
253      * function instead.
254      *
255      * If `target` reverts with a revert reason, it is bubbled up by this
256      * function (like regular Solidity function calls).
257      *
258      * Returns the raw returned data. To convert to the expected return value,
259      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
260      *
261      * Requirements:
262      *
263      * - `target` must be a contract.
264      * - calling `target` with `data` must not revert.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionCall(target, data, "Address: low-level call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
274      * `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, 0, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but also transferring `value` wei to `target`.
289      *
290      * Requirements:
291      *
292      * - the calling contract must have an ETH balance of at least `value`.
293      * - the called Solidity function must be `payable`.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
307      * with `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(
312         address target,
313         bytes memory data,
314         uint256 value,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(address(this).balance >= value, "Address: insufficient balance for call");
318         require(isContract(target), "Address: call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.call{value: value}(data);
321         return verifyCallResult(success, returndata, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
331         return functionStaticCall(target, data, "Address: low-level static call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal view returns (bytes memory) {
345         require(isContract(target), "Address: static call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.staticcall(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
358         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(isContract(target), "Address: delegate call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.delegatecall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
380      * revert reason using the provided one.
381      *
382      * _Available since v4.3._
383      */
384     function verifyCallResult(
385         bool success,
386         bytes memory returndata,
387         string memory errorMessage
388     ) internal pure returns (bytes memory) {
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 // File: IERC165.sol
408 
409 
410 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415  * @dev Interface of the ERC165 standard, as defined in the
416  * https://eips.ethereum.org/EIPS/eip-165[EIP].
417  *
418  * Implementers can declare support of contract interfaces, which can then be
419  * queried by others ({ERC165Checker}).
420  *
421  * For an implementation, see {ERC165}.
422  */
423 interface IERC165 {
424     /**
425      * @dev Returns true if this contract implements the interface defined by
426      * `interfaceId`. See the corresponding
427      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
428      * to learn more about how these ids are created.
429      *
430      * This function call must use less than 30 000 gas.
431      */
432     function supportsInterface(bytes4 interfaceId) external view returns (bool);
433 }
434 
435 // File: ERC165.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 
443 /**
444  * @dev Implementation of the {IERC165} interface.
445  *
446  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
447  * for the additional interface id that will be supported. For example:
448  *
449  * ```solidity
450  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
451  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
452  * }
453  * ```
454  *
455  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
456  */
457 abstract contract ERC165 is IERC165 {
458     /**
459      * @dev See {IERC165-supportsInterface}.
460      */
461     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
462         return interfaceId == type(IERC165).interfaceId;
463     }
464 }
465 
466 // File: IERC1155Receiver.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 
474 /**
475  * @dev _Available since v3.1._
476  */
477 interface IERC1155Receiver is IERC165 {
478     /**
479      * @dev Handles the receipt of a single ERC1155 token type. This function is
480      * called at the end of a `safeTransferFrom` after the balance has been updated.
481      *
482      * NOTE: To accept the transfer, this must return
483      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
484      * (i.e. 0xf23a6e61, or its own function selector).
485      *
486      * @param operator The address which initiated the transfer (i.e. msg.sender)
487      * @param from The address which previously owned the token
488      * @param id The ID of the token being transferred
489      * @param value The amount of tokens being transferred
490      * @param data Additional data with no specified format
491      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
492      */
493     function onERC1155Received(
494         address operator,
495         address from,
496         uint256 id,
497         uint256 value,
498         bytes calldata data
499     ) external returns (bytes4);
500 
501     /**
502      * @dev Handles the receipt of a multiple ERC1155 token types. This function
503      * is called at the end of a `safeBatchTransferFrom` after the balances have
504      * been updated.
505      *
506      * NOTE: To accept the transfer(s), this must return
507      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
508      * (i.e. 0xbc197c81, or its own function selector).
509      *
510      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
511      * @param from The address which previously owned the token
512      * @param ids An array containing ids of each token being transferred (order and length must match values array)
513      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
514      * @param data Additional data with no specified format
515      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
516      */
517     function onERC1155BatchReceived(
518         address operator,
519         address from,
520         uint256[] calldata ids,
521         uint256[] calldata values,
522         bytes calldata data
523     ) external returns (bytes4);
524 }
525 
526 // File: IERC1155.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Required interface of an ERC1155 compliant contract, as defined in the
536  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
537  *
538  * _Available since v3.1._
539  */
540 interface IERC1155 is IERC165 {
541     /**
542      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
543      */
544     event TransferSingle(
545         address indexed operator,
546         address indexed from,
547         address indexed to,
548         uint256 id,
549         uint256 value
550     );
551 
552     /**
553      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
554      * transfers.
555      */
556     event TransferBatch(
557         address indexed operator,
558         address indexed from,
559         address indexed to,
560         uint256[] ids,
561         uint256[] values
562     );
563 
564     /**
565      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
566      * `approved`.
567      */
568     event ApprovalForAll(
569         address indexed account,
570         address indexed operator,
571         bool approved
572     );
573 
574     /**
575      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
576      *
577      * If an {URI} event was emitted for `id`, the standard
578      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
579      * returned by {IERC1155MetadataURI-uri}.
580      */
581     event URI(string value, uint256 indexed id);
582 
583     /**
584      * @dev Returns the amount of tokens of token type `id` owned by `account`.
585      *
586      * Requirements:
587      *
588      * - `account` cannot be the zero address.
589      */
590     function balanceOf(address account, uint256 id)
591         external
592         view
593         returns (uint256);
594 
595     /**
596      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
597      *
598      * Requirements:
599      *
600      * - `accounts` and `ids` must have the same length.
601      */
602     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
603         external
604         view
605         returns (uint256[] memory);
606 
607     /**
608      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
609      *
610      * Emits an {ApprovalForAll} event.
611      *
612      * Requirements:
613      *
614      * - `operator` cannot be the caller.
615      */
616     function setApprovalForAll(address operator, bool approved) external;
617 
618     /**
619      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
620      *
621      * See {setApprovalForAll}.
622      */
623     function isApprovedForAll(address account, address operator)
624         external
625         view
626         returns (bool);
627 
628     /**
629      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
630      *
631      * Emits a {TransferSingle} event.
632      *
633      * Requirements:
634      *
635      * - `to` cannot be the zero address.
636      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
637      * - `from` must have a balance of tokens of type `id` of at least `amount`.
638      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
639      * acceptance magic value.
640      */
641     function safeTransferFrom(
642         address from,
643         address to,
644         uint256 id,
645         uint256 amount,
646         bytes calldata data
647     ) external;
648 
649     /**
650      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
651      *
652      * Emits a {TransferBatch} event.
653      *
654      * Requirements:
655      *
656      * - `ids` and `amounts` must have the same length.
657      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
658      * acceptance magic value.
659      */
660     function safeBatchTransferFrom(
661         address from,
662         address to,
663         uint256[] calldata ids,
664         uint256[] calldata amounts,
665         bytes calldata data
666     ) external;
667 }
668 
669 // File: IERC1155MetadataURI.sol
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 
677 /**
678  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
679  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
680  *
681  * _Available since v3.1._
682  */
683 interface IERC1155MetadataURI is IERC1155 {
684     /**
685      * @dev Returns the URI for token type `id`.
686      *
687      * If the `\{id\}` substring is present in the URI, it must be replaced by
688      * clients with the actual token type ID.
689      */
690     function uri(uint256 id) external view returns (string memory);
691 }
692 
693 // File: ERC1155.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 
702 
703 
704 
705 
706 
707 /**
708  * @dev Implementation of the basic standard multi-token.
709  * See https://eips.ethereum.org/EIPS/eip-1155
710  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
711  *
712  * _Available since v3.1._
713  */
714 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
715     using Address for address;
716 
717     // Mapping from token ID to account balances
718     mapping(uint256 => mapping(address => uint256)) private _balances;
719     // Mapping from account to operator approvals
720     mapping(address => mapping(address => bool)) private _operatorApprovals;
721     mapping(uint256 => uint256) public tokenCastleLevel;
722     // ORTH NFT price, just over 1$ (ETH @ 3100$)
723     uint256 public constant REVEAL_PRICE = 0.0004 ether;
724     uint256 public constant CASTLE_BASE_PRICE = 0.008 ether;
725     uint256 public constant FLIP_REALM_PRICE = 0.001 ether;
726     address public constant W0 = 0x2830B5a3b5242BC2c64C390594ED971E7deD47D2;
727     address public constant W1 = 0x2cdE3C309EF95411f78b338A7de85c4454316208;
728 
729     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
730     string private _uri;
731 
732     /**
733      * @dev See {_setURI}.
734      */
735     constructor(string memory uri_) {
736         _setURI(uri_);
737     }
738 
739     /// @notice Public function to retrieve the contract description for OpenSea
740     function contractURI() public view returns (string memory) {
741         return string(abi.encodePacked(_uri, "contract.json"));
742     }
743 
744     /**
745      * @dev See {IERC165-supportsInterface}.
746      */
747     function supportsInterface(bytes4 interfaceId)
748         public
749         view
750         virtual
751         override(ERC165, IERC165)
752         returns (bool)
753     {
754         return
755             interfaceId == type(IERC1155).interfaceId ||
756             interfaceId == type(IERC1155MetadataURI).interfaceId ||
757             super.supportsInterface(interfaceId);
758     }
759 
760     /**
761      * @dev Create the NFT by emitting the event and setting the token ID to the
762      * sender's address.
763      */
764     function reveal() public payable {
765         require(msg.value >= REVEAL_PRICE, "Please send 0.0004 ETH");
766 
767         address tokenOwner = msg.sender;
768 
769         uint256 tokenId = uint256(uint160(tokenOwner));
770         require(_balances[tokenId][tokenOwner] == 0, "NFT already revealed");
771 
772         _balances[tokenId][tokenOwner] = 1;
773         address operator = _msgSender();
774         emit TransferSingle(operator, address(0), tokenOwner, tokenId, 1);
775     }
776 
777     /**
778      * @dev Make the gift of Orthoverse and spread the joy around you.
779      */
780     function gift(address account) public payable {
781         require(account != address(0), "ERC1155: No gift for the zero address");
782         require(msg.value >= REVEAL_PRICE, "Please send 0.0004 ETH");
783 
784         address tokenOwner = account;
785 
786         uint256 tokenId = uint256(uint160(tokenOwner));
787         require(_balances[tokenId][tokenOwner] == 0, "NFT already revealed");
788 
789         _balances[tokenId][tokenOwner] = 1;
790         address operator = _msgSender();
791         emit TransferSingle(operator, address(0), tokenOwner, tokenId, 1);
792     }
793 
794     /**
795      * @dev Returns 0 if the token has not been revealed
796      */
797     function isRevealed() public view returns (uint256) {
798         address account = msg.sender;
799         uint256 id = uint256(uint160(account));
800         return _balances[id][account];
801     }
802 
803     /**
804      * @dev See {IERC1155MetadataURI-uri}.
805      *
806      * This implementation returns the same URI for *all* token types. It relies
807      * on the token type ID substitution mechanism
808      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
809      *
810      * Clients calling this function must replace the `\{id\}` substring with the
811      * actual token type ID.
812      */
813 
814     /// @notice  Returns the metadata URI for tokenId
815     function uri(uint256 tokenId)
816         public
817         view
818         virtual
819         override
820         returns (string memory)
821     {
822         return
823             string(
824                 abi.encodePacked(
825                     _uri,
826                     Strings.toHexString(tokenId),
827                     "-",
828                     Strings.toString(tokenCastleLevel[tokenId]),
829                     ".json"
830                 )
831             );
832     }
833 
834     /**
835      * @dev See {IERC1155-balanceOf}.
836      *
837      * Requirements:
838      *
839      * - `account` cannot be the zero address.
840      */
841     function balanceOf(address account, uint256 id)
842         public
843         view
844         virtual
845         override
846         returns (uint256)
847     {
848         require(
849             account != address(0),
850             "ERC1155: balance query for the zero address"
851         );
852         if (id == uint256(uint160(account)) && (_balances[id][account] == 0)) {
853             return 1;
854         } else {
855             return _balances[id][account] % 2;
856         }
857     }
858 
859     /**
860      * @dev See {IERC1155-balanceOfBatch}.
861      *
862      * Requirements:
863      *
864      * - `accounts` and `ids` must have the same length.
865      */
866     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
867         public
868         view
869         virtual
870         override
871         returns (uint256[] memory)
872     {
873         require(
874             accounts.length == ids.length,
875             "ERC1155: accounts and ids length mismatch"
876         );
877 
878         uint256[] memory batchBalances = new uint256[](accounts.length);
879 
880         for (uint256 i = 0; i < accounts.length; ++i) {
881             batchBalances[i] = balanceOf(accounts[i], ids[i]);
882         }
883 
884         return batchBalances;
885     }
886 
887     /**
888      * @dev See {IERC1155-setApprovalForAll}.
889      */
890     function setApprovalForAll(address operator, bool approved)
891         public
892         virtual
893         override
894     {
895         _setApprovalForAll(_msgSender(), operator, approved);
896     }
897 
898     function flipRealm(uint256 tokenId_) public payable {
899         require(
900             _balances[tokenId_][msg.sender] == 1,
901             "Only owner can flip realm, token must be revealed"
902         );
903 
904         if (msg.sender != W0 || msg.sender != W1) {
905             require(msg.value >= FLIP_REALM_PRICE, "Not enough ETH");
906         }
907 
908         if (tokenCastleLevel[tokenId_] > 7) {
909             tokenCastleLevel[tokenId_] = tokenCastleLevel[tokenId_] - 8;
910         } else {
911             tokenCastleLevel[tokenId_] = tokenCastleLevel[tokenId_] + 8;
912         }
913     }
914 
915     /**
916      * @dev See {IERC1155-isApprovedForAll}.
917      */
918     function isApprovedForAll(address account, address operator)
919         public
920         view
921         virtual
922         override
923         returns (bool)
924     {
925         return _operatorApprovals[account][operator];
926     }
927 
928     /**
929      * @dev See {IERC1155-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 id,
935         uint256 amount,
936         bytes memory data
937     ) public virtual override {
938         require(
939             from == _msgSender() || isApprovedForAll(from, _msgSender()),
940             "ERC1155: caller is not owner nor approved"
941         );
942         _safeTransferFrom(from, to, id, amount, data);
943     }
944 
945     /**
946      * @dev See {IERC1155-safeBatchTransferFrom}.
947      */
948     function safeBatchTransferFrom(
949         address from,
950         address to,
951         uint256[] memory ids,
952         uint256[] memory amounts,
953         bytes memory data
954     ) public virtual override {
955         require(
956             from == _msgSender() || isApprovedForAll(from, _msgSender()),
957             "ERC1155: transfer caller is not owner nor approved"
958         );
959         _safeBatchTransferFrom(from, to, ids, amounts, data);
960     }
961 
962     /**
963      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
964      *
965      * Emits a {TransferSingle} event.
966      *
967      * Requirements:
968      *
969      * - `to` cannot be the zero address.
970      * - `from` must have a balance of tokens of type `id` of at least `amount`.
971      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
972      * acceptance magic value.
973      */
974     function _safeTransferFrom(
975         address from,
976         address to,
977         uint256 id,
978         // we just ignore amount, because it's always one
979         uint256 amount,
980         bytes memory data
981     ) internal virtual {
982         require(to != address(0), "ERC1155: transfer to the zero address");
983 
984         address operator = _msgSender();
985 
986         if (_balances[id][from] == 0) {
987             // this actually makes the NFT
988             _balances[id][from] = 1;
989             emit TransferSingle(operator, address(0), from, id, 1);
990         }
991 
992         _beforeTokenTransfer(
993             operator,
994             from,
995             to,
996             _asSingletonArray(id),
997             _asSingletonArray(amount),
998             data
999         );
1000 
1001         uint256 fromBalance = _balances[id][from];
1002 
1003         require(
1004             fromBalance % 2 == 1,
1005             "ERC1155: insufficient balance for transfer"
1006         );
1007 
1008         unchecked {
1009             _balances[id][from] += 1;
1010         }
1011 
1012         _balances[id][to] += 1;
1013 
1014         emit TransferSingle(operator, from, to, id, 1);
1015 
1016         _doSafeTransferAcceptanceCheck(operator, from, to, id, 1, data);
1017     }
1018 
1019     /**
1020      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1021      *
1022      * Emits a {TransferBatch} event.
1023      *
1024      * Requirements:
1025      *
1026      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1027      * acceptance magic value.
1028      */
1029     function _safeBatchTransferFrom(
1030         address from,
1031         address to,
1032         uint256[] memory ids,
1033         uint256[] memory amounts,
1034         bytes memory data
1035     ) internal virtual {
1036         require(
1037             ids.length == amounts.length,
1038             "ERC1155: ids and amounts length mismatch"
1039         );
1040         require(to != address(0), "ERC1155: transfer to the zero address");
1041 
1042         address operator = _msgSender();
1043 
1044         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1045 
1046         uint256 fromToken = uint256(uint160(from));
1047         if (_balances[fromToken][from] == 0) {
1048             // this actually makes the NFT
1049             _balances[fromToken][from] += 1;
1050             emit TransferSingle(operator, address(0), from, fromToken, 1);
1051         }
1052 
1053         for (uint256 i = 0; i < ids.length; ++i) {
1054             uint256 id = ids[i];
1055 
1056             uint256 fromBalance = _balances[id][from];
1057             require(
1058                 (fromBalance % 2 == 1),
1059                 "ERC1155: insufficient balance for transfer batch"
1060             );
1061 
1062             unchecked {
1063                 _balances[id][from] = fromBalance + 1;
1064             }
1065             _balances[id][to] += 1;
1066         }
1067 
1068         emit TransferBatch(operator, from, to, ids, amounts);
1069 
1070         _doSafeBatchTransferAcceptanceCheck(
1071             operator,
1072             from,
1073             to,
1074             ids,
1075             amounts,
1076             data
1077         );
1078     }
1079 
1080     /**
1081      * @dev Sets a new URI for all token types, by relying on the token type ID
1082      * substitution mechanism
1083      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1084      *
1085      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1086      * URI or any of the amounts in the JSON file at said URI will be replaced by
1087      * clients with the token type ID.
1088      *
1089      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1090      * interpreted by clients as
1091      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1092      * for token type ID 0x4cce0.
1093      *
1094      * See {uri}.
1095      *
1096      * Because these URIs cannot be meaningfully represented by the {URI} event,
1097      * this function emits no events.
1098      */
1099     function _setURI(string memory newuri) internal virtual {
1100         _uri = newuri;
1101     }
1102 
1103     /**
1104      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1105      *
1106      * Emits a {TransferSingle} event.
1107      *
1108      * Requirements:
1109      *
1110      * - `to` cannot be the zero address.
1111      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1112      * acceptance magic value.
1113      */
1114     function _mint(
1115         address to,
1116         uint256 id,
1117         uint256 amount,
1118         bytes memory data
1119     ) internal virtual {
1120         require(to != address(0), "ERC1155: mint to the zero address");
1121 
1122         address operator = _msgSender();
1123 
1124         _beforeTokenTransfer(
1125             operator,
1126             address(0),
1127             to,
1128             _asSingletonArray(id),
1129             _asSingletonArray(amount),
1130             data
1131         );
1132 
1133         _balances[id][to] += amount;
1134         emit TransferSingle(operator, address(0), to, id, amount);
1135 
1136         _doSafeTransferAcceptanceCheck(
1137             operator,
1138             address(0),
1139             to,
1140             id,
1141             amount,
1142             data
1143         );
1144     }
1145 
1146     /**
1147      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1148      *
1149      * Requirements:
1150      *
1151      * - `ids` and `amounts` must have the same length.
1152      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1153      * acceptance magic value.
1154      */
1155     function _mintBatch(
1156         address to,
1157         uint256[] memory ids,
1158         uint256[] memory amounts,
1159         bytes memory data
1160     ) internal virtual {
1161         require(to != address(0), "ERC1155: mint to the zero address");
1162         require(
1163             ids.length == amounts.length,
1164             "ERC1155: ids and amounts length mismatch"
1165         );
1166 
1167         address operator = _msgSender();
1168 
1169         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1170 
1171         for (uint256 i = 0; i < ids.length; i++) {
1172             _balances[ids[i]][to] += amounts[i];
1173         }
1174 
1175         emit TransferBatch(operator, address(0), to, ids, amounts);
1176 
1177         _doSafeBatchTransferAcceptanceCheck(
1178             operator,
1179             address(0),
1180             to,
1181             ids,
1182             amounts,
1183             data
1184         );
1185     }
1186 
1187     /**
1188      * @dev Destroys `amount` tokens of token type `id` from `from`
1189      *
1190      * Requirements:
1191      *
1192      * - `from` cannot be the zero address.
1193      * - `from` must have at least `amount` tokens of token type `id`.
1194      */
1195     function _burn(
1196         address from,
1197         uint256 id,
1198         uint256 amount
1199     ) internal virtual {
1200         require(from != address(0), "ERC1155: burn from the zero address");
1201 
1202         address operator = _msgSender();
1203 
1204         _beforeTokenTransfer(
1205             operator,
1206             from,
1207             address(0),
1208             _asSingletonArray(id),
1209             _asSingletonArray(amount),
1210             ""
1211         );
1212 
1213         uint256 fromBalance = _balances[id][from];
1214         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1215         unchecked {
1216             _balances[id][from] = fromBalance - amount;
1217         }
1218 
1219         emit TransferSingle(operator, from, address(0), id, amount);
1220     }
1221 
1222     /**
1223      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1224      *
1225      * Requirements:
1226      *
1227      * - `ids` and `amounts` must have the same length.
1228      */
1229     function _burnBatch(
1230         address from,
1231         uint256[] memory ids,
1232         uint256[] memory amounts
1233     ) internal virtual {
1234         require(from != address(0), "ERC1155: burn from the zero address");
1235         require(
1236             ids.length == amounts.length,
1237             "ERC1155: ids and amounts length mismatch"
1238         );
1239 
1240         address operator = _msgSender();
1241 
1242         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1243 
1244         for (uint256 i = 0; i < ids.length; i++) {
1245             uint256 id = ids[i];
1246             uint256 amount = amounts[i];
1247 
1248             uint256 fromBalance = _balances[id][from];
1249             require(
1250                 fromBalance >= amount,
1251                 "ERC1155: burn amount exceeds balance"
1252             );
1253             unchecked {
1254                 _balances[id][from] = fromBalance - amount;
1255             }
1256         }
1257 
1258         emit TransferBatch(operator, from, address(0), ids, amounts);
1259     }
1260 
1261     /**
1262      * @dev Approve `operator` to operate on all of `owner` tokens
1263      *
1264      * Emits a {ApprovalForAll} event.
1265      */
1266     function _setApprovalForAll(
1267         address owner,
1268         address operator,
1269         bool approved
1270     ) internal virtual {
1271         require(owner != operator, "ERC1155: setting approval status for self");
1272         _operatorApprovals[owner][operator] = approved;
1273         emit ApprovalForAll(owner, operator, approved);
1274     }
1275 
1276     /**
1277      * @dev Hook that is called before any token transfer. This includes minting
1278      * and burning, as well as batched variants.
1279      *
1280      * The same hook is called on both single and batched variants. For single
1281      * transfers, the length of the `id` and `amount` arrays will be 1.
1282      *
1283      * Calling conditions (for each `id` and `amount` pair):
1284      *
1285      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1286      * of token type `id` will be  transferred to `to`.
1287      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1288      * for `to`.
1289      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1290      * will be burned.
1291      * - `from` and `to` are never both zero.
1292      * - `ids` and `amounts` have the same, non-zero length.
1293      *
1294      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1295      */
1296     function _beforeTokenTransfer(
1297         address operator,
1298         address from,
1299         address to,
1300         uint256[] memory ids,
1301         uint256[] memory amounts,
1302         bytes memory data
1303     ) internal virtual {}
1304 
1305     function _doSafeTransferAcceptanceCheck(
1306         address operator,
1307         address from,
1308         address to,
1309         uint256 id,
1310         uint256 amount,
1311         bytes memory data
1312     ) private {
1313         if (to.isContract()) {
1314             try
1315                 IERC1155Receiver(to).onERC1155Received(
1316                     operator,
1317                     from,
1318                     id,
1319                     amount,
1320                     data
1321                 )
1322             returns (bytes4 response) {
1323                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1324                     revert("ERC1155: ERC1155Receiver rejected tokens");
1325                 }
1326             } catch Error(string memory reason) {
1327                 revert(reason);
1328             } catch {
1329                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1330             }
1331         }
1332     }
1333 
1334     function _doSafeBatchTransferAcceptanceCheck(
1335         address operator,
1336         address from,
1337         address to,
1338         uint256[] memory ids,
1339         uint256[] memory amounts,
1340         bytes memory data
1341     ) private {
1342         if (to.isContract()) {
1343             try
1344                 IERC1155Receiver(to).onERC1155BatchReceived(
1345                     operator,
1346                     from,
1347                     ids,
1348                     amounts,
1349                     data
1350                 )
1351             returns (bytes4 response) {
1352                 if (
1353                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1354                 ) {
1355                     revert("ERC1155: ERC1155Receiver rejected tokens");
1356                 }
1357             } catch Error(string memory reason) {
1358                 revert(reason);
1359             } catch {
1360                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1361             }
1362         }
1363     }
1364 
1365     function _asSingletonArray(uint256 element)
1366         private
1367         pure
1368         returns (uint256[] memory)
1369     {
1370         uint256[] memory array = new uint256[](1);
1371         array[0] = element;
1372 
1373         return array;
1374     }
1375 }
1376 
1377 // File: ERC1155Supply.sol
1378 
1379 
1380 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1381 
1382 pragma solidity ^0.8.0;
1383 
1384 
1385 /**
1386  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1387  *
1388  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1389  * clearly identified. Note: While a totalSupply of 1 might mean the
1390  * corresponding is an NFT, there is no guarantees that no other token with the
1391  * same id are not going to be minted.
1392  */
1393 abstract contract ERC1155Supply is ERC1155 {
1394     mapping(uint256 => uint256) private _totalSupply;
1395 
1396     /**
1397      * @dev Total amount of tokens in with a given id.
1398      */
1399     function totalSupply(uint256 id) public view virtual returns (uint256) {
1400         delete id;
1401         return 1;
1402     }
1403 
1404     /**
1405      * @dev In Orthoverse every token exists already, you just have to reveal it.
1406      */
1407     function exists(uint256 id) public view virtual returns (bool) {
1408         delete id;
1409         return true;
1410     }
1411 
1412     /**
1413      * @dev See {ERC1155-_beforeTokenTransfer}.
1414      */
1415     function _beforeTokenTransfer(
1416         address operator,
1417         address from,
1418         address to,
1419         uint256[] memory ids,
1420         uint256[] memory amounts,
1421         bytes memory data
1422     ) internal virtual override {
1423         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1424 
1425         if (from == address(0)) {
1426             for (uint256 i = 0; i < ids.length; ++i) {
1427                 _totalSupply[ids[i]] += amounts[i];
1428             }
1429         }
1430 
1431         if (to == address(0)) {
1432             for (uint256 i = 0; i < ids.length; ++i) {
1433                 _totalSupply[ids[i]] -= amounts[i];
1434             }
1435         }
1436     }
1437 }
1438 
1439 // File: Orthoverse.sol
1440 
1441 
1442 /*
1443  *   Orthoverse - How to mint an insane number of NFTs in one go!
1444  *
1445  *  Brought to you by:
1446  *
1447  *       Keir Finlow-Bates - https://www.linkedin.com/in/keirf/
1448  *                      &
1449  *       Richard Piacentini - https://www.linkedin.com/in/richardpiacentini/
1450  *
1451  */
1452 
1453 pragma solidity ^0.8.2;
1454 
1455 
1456 
1457 
1458 contract Orthoverse is ERC1155, Ownable, ERC1155Supply {
1459     constructor(string memory uri_) ERC1155(uri_) {}
1460 
1461     function name() public pure returns (string memory) {
1462         return "Orthoverse";
1463     }
1464 
1465     function symbol() public pure returns (string memory) {
1466         return "ORTH";
1467     }
1468 
1469     function setURI(string memory newURI_) public onlyOwner {
1470         _setURI(newURI_);
1471     }
1472 
1473     function castleLevel(uint256 tokenId_) public view returns (uint256) {
1474         return tokenCastleLevel[tokenId_];
1475     }
1476 
1477     function castlePrice(uint256 tokenId_) public view returns (uint256) {
1478         return (CASTLE_BASE_PRICE * (2**(tokenCastleLevel[tokenId_] % 8)));
1479     }
1480 
1481     function upgradeCastleLevel(address account_) public payable {
1482         require(account_ != address(0), "No castle for the zero address");
1483         uint256 tokenId = uint256(uint160(account_));
1484 
1485         require(
1486             tokenCastleLevel[tokenId] != 7 && tokenCastleLevel[tokenId] != 15,
1487             "Castle is already at max level"
1488         );
1489 
1490         if (msg.sender != W0 || msg.sender != W1) {
1491             require(msg.value >= castlePrice(tokenId), "Not enough ETH");
1492         }
1493         tokenCastleLevel[tokenId]++;
1494     }
1495 
1496     function withdraw() external {
1497         uint256 balance = address(this).balance;
1498         require(balance > 0, "No funds");
1499 
1500         uint256 half = (balance * 5) / 10;
1501         Address.sendValue(payable(W0), half);
1502         Address.sendValue(payable(W1), half);
1503     }
1504 
1505     // The following functions are overrides required by Solidity.
1506 
1507     function _beforeTokenTransfer(
1508         address operator,
1509         address from,
1510         address to,
1511         uint256[] memory ids,
1512         uint256[] memory amounts,
1513         bytes memory data
1514     ) internal override(ERC1155, ERC1155Supply) {
1515         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1516     }
1517 }