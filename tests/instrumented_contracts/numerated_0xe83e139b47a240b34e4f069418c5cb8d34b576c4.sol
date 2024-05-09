1 // CryptoPunks Bunnies Official Contract - https://cryptopunksbunnies.com
2 // Discord - https://discord.com/invite/xwR69ujF9E
3 // Twitter - https://twitter.com/cpbpixel
4 
5 // 4096 unique collectible characters with proof of ownership working on the Ethereum blockchain. The project that inspired the classic pixel CryptoArt movement.
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity ^0.8.0;
9 
10 library Strings {
11     bytes16 private constant alphabet = "0123456789abcdef";
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
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = alphabet[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "#43");
66         return string(buffer);
67     }
68 
69 }
70 
71 /**
72  * @dev Interface of the ERC165 standard, as defined in the
73  * https://eips.ethereum.org/EIPS/eip-165[EIP].
74  *
75  * Implementers can declare support of contract interfaces, which can then be
76  * queried by others ({ERC165Checker}).
77  *
78  * For an implementation, see {ERC165}.
79  */
80 interface IERC165 {
81     /**
82      * @dev Returns true if this contract implements the interface defined by
83      * `interfaceId`. See the corresponding
84      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
85      * to learn more about how these ids are created.
86      *
87      * This function call must use less than 30 000 gas.
88      */
89     function supportsInterface(bytes4 interfaceId) external view returns (bool);
90 }
91 
92 
93 
94 
95 /**
96  * @dev Required interface of an ERC1155 compliant contract, as defined in the
97  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
98  *
99  * _Available since v3.1._
100  */
101 interface IERC1155 is IERC165 {
102     /**
103      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
104      */
105     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
106 
107     /**
108      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
109      * transfers.
110      */
111     event TransferBatch(
112         address indexed operator,
113         address indexed from,
114         address indexed to,
115         uint256[] ids,
116         uint256[] values
117     );
118 
119     /**
120      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
121      * `approved`.
122      */
123     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
124 
125     /**
126      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
127      *
128      * If an {URI} event was emitted for `id`, the standard
129      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
130      * returned by {IERC1155MetadataURI-uri}.
131      */
132     event URI(string value, uint256 indexed id);
133 
134     /**
135      * @dev Returns the amount of tokens of token type `id` owned by `account`.
136      *
137      * Requirements:
138      *
139      * - `account` cannot be the zero address.
140      */
141     function balanceOf(address account, uint256 id) external view returns (uint256);
142 
143     /**
144      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
145      *
146      * Requirements:
147      *
148      * - `accounts` and `ids` must have the same length.
149      */
150     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
151         external
152         view
153         returns (uint256[] memory);
154 
155     /**
156      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
157      *
158      * Emits an {ApprovalForAll} event.
159      *
160      * Requirements:
161      *
162      * - `operator` cannot be the caller.
163      */
164     function setApprovalForAll(address operator, bool approved) external;
165 
166     /**
167      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
168      *
169      * See {setApprovalForAll}.
170      */
171     function isApprovedForAll(address account, address operator) external view returns (bool);
172 
173     /**
174      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
175      *
176      * Emits a {TransferSingle} event.
177      *
178      * Requirements:
179      *
180      * - `to` cannot be the zero address.
181      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
182      * - `from` must have a balance of tokens of type `id` of at least `amount`.
183      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
184      * acceptance magic value.
185      */
186     function safeTransferFrom(
187         address from,
188         address to,
189         uint256 id,
190         uint256 amount,
191         bytes calldata data
192     ) external;
193 
194     /**
195      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
196      *
197      * Emits a {TransferBatch} event.
198      *
199      * Requirements:
200      *
201      * - `ids` and `amounts` must have the same length.
202      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
203      * acceptance magic value.
204      */
205     function safeBatchTransferFrom(
206         address from,
207         address to,
208         uint256[] calldata ids,
209         uint256[] calldata amounts,
210         bytes calldata data
211     ) external;
212 }
213 
214 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
215 
216 /**
217  * @dev _Available since v3.1._
218  */
219 interface IERC1155Receiver is IERC165 {
220     /**
221      * @dev Handles the receipt of a single ERC1155 token type. This function is
222      * called at the end of a `safeTransferFrom` after the balance has been updated.
223      *
224      * NOTE: To accept the transfer, this must return
225      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
226      * (i.e. 0xf23a6e61, or its own function selector).
227      *
228      * @param operator The address which initiated the transfer (i.e. msg.sender)
229      * @param from The address which previously owned the token
230      * @param id The ID of the token being transferred
231      * @param value The amount of tokens being transferred
232      * @param data Additional data with no specified format
233      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
234      */
235     function onERC1155Received(
236         address operator,
237         address from,
238         uint256 id,
239         uint256 value,
240         bytes calldata data
241     ) external returns (bytes4);
242 
243     /**
244      * @dev Handles the receipt of a multiple ERC1155 token types. This function
245      * is called at the end of a `safeBatchTransferFrom` after the balances have
246      * been updated.
247      *
248      * NOTE: To accept the transfer(s), this must return
249      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
250      * (i.e. 0xbc197c81, or its own function selector).
251      *
252      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
253      * @param from The address which previously owned the token
254      * @param ids An array containing ids of each token being transferred (order and length must match values array)
255      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
256      * @param data Additional data with no specified format
257      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
258      */
259     function onERC1155BatchReceived(
260         address operator,
261         address from,
262         uint256[] calldata ids,
263         uint256[] calldata values,
264         bytes calldata data
265     ) external returns (bytes4);
266 }
267 
268 
269 
270 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
271 
272 /**
273  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
274  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
275  *
276  * _Available since v3.1._
277  */
278 interface IERC1155MetadataURI is IERC1155 {
279     /**
280      * @dev Returns the URI for token type `id`.
281      *
282      * If the `\{id\}` substring is present in the URI, it must be replaced by
283      * clients with the actual token type ID.
284      */
285     function uri(uint256 id) external view returns (string memory);
286 }
287 
288 
289 
290 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 /**
316  * @dev Collection of functions related to the address type
317  */
318 
319 library Address {
320     /**
321      * @dev Returns true if `account` is a contract.
322      *
323      * [IMPORTANT]
324      * ====
325      * It is unsafe to assume that an address for which this function returns
326      * false is an externally-owned account (EOA) and not a contract.
327      *
328      * Among others, `isContract` will return false for the following
329      * types of addresses:
330      *
331      *  - an externally-owned account
332      *  - a contract in construction
333      *  - an address where a contract will be created
334      *  - an address where a contract lived, but was destroyed
335      * ====
336      *
337      * [IMPORTANT]
338      * ====
339      * You shouldn't rely on `isContract` to protect against flash loan attacks!
340      *
341      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
342      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
343      * constructor.
344      * ====
345      */
346     function isContract(address account) internal view returns (bool) {
347         // This method relies on extcodesize/address.code.length, which returns 0
348         // for contracts in construction, since the code is only stored at the end
349         // of the constructor execution.
350 
351         return account.code.length > 0;
352     }
353 
354     /**
355      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
356      * `recipient`, forwarding all available gas and reverting on errors.
357      *
358      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
359      * of certain opcodes, possibly making contracts go over the 2300 gas limit
360      * imposed by `transfer`, making them unable to receive funds via
361      * `transfer`. {sendValue} removes this limitation.
362      *
363      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
364      *
365      * IMPORTANT: because control is transferred to `recipient`, care must be
366      * taken to not create reentrancy vulnerabilities. Consider using
367      * {ReentrancyGuard} or the
368      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
369      */
370     function sendValue(address payable recipient, uint256 amount) internal {
371         require(address(this).balance >= amount, "Address: insufficient balance");
372 
373         (bool success, ) = recipient.call{value: amount}("");
374         require(success, "Address: unable to send value, recipient may have reverted");
375     }
376 
377     /**
378      * @dev Performs a Solidity function call using a low level `call`. A
379      * plain `call` is an unsafe replacement for a function call: use this
380      * function instead.
381      *
382      * If `target` reverts with a revert reason, it is bubbled up by this
383      * function (like regular Solidity function calls).
384      *
385      * Returns the raw returned data. To convert to the expected return value,
386      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
387      *
388      * Requirements:
389      *
390      * - `target` must be a contract.
391      * - calling `target` with `data` must not revert.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
396         return functionCall(target, data, "Address: low-level call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
401      * `errorMessage` as a fallback revert reason when `target` reverts.
402      *
403      * _Available since v3.1._
404      */
405     function functionCall(
406         address target,
407         bytes memory data,
408         string memory errorMessage
409     ) internal returns (bytes memory) {
410         return functionCallWithValue(target, data, 0, errorMessage);
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
415      * but also transferring `value` wei to `target`.
416      *
417      * Requirements:
418      *
419      * - the calling contract must have an ETH balance of at least `value`.
420      * - the called Solidity function must be `payable`.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value
428     ) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
434      * with `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(
439         address target,
440         bytes memory data,
441         uint256 value,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(address(this).balance >= value, "Address: insufficient balance for call");
445         require(isContract(target), "Address: call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.call{value: value}(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
458         return functionStaticCall(target, data, "Address: low-level static call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(
468         address target,
469         bytes memory data,
470         string memory errorMessage
471     ) internal view returns (bytes memory) {
472         require(isContract(target), "Address: static call to non-contract");
473 
474         (bool success, bytes memory returndata) = target.staticcall(data);
475         return verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.4._
483      */
484     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
485         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
490      * but performing a delegate call.
491      *
492      * _Available since v3.4._
493      */
494     function functionDelegateCall(
495         address target,
496         bytes memory data,
497         string memory errorMessage
498     ) internal returns (bytes memory) {
499         require(isContract(target), "Address: delegate call to non-contract");
500 
501         (bool success, bytes memory returndata) = target.delegatecall(data);
502         return verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     /**
506      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
507      * revert reason using the provided one.
508      *
509      * _Available since v4.3._
510      */
511     function verifyCallResult(
512         bool success,
513         bytes memory returndata,
514         string memory errorMessage
515     ) internal pure returns (bytes memory) {
516         if (success) {
517             return returndata;
518         } else {
519             // Look for revert reason and bubble it up if present
520             if (returndata.length > 0) {
521                 // The easiest way to bubble the revert reason is using memory via assembly
522 
523                 assembly {
524                     let returndata_size := mload(returndata)
525                     revert(add(32, returndata), returndata_size)
526                 }
527             } else {
528                 revert(errorMessage);
529             }
530         }
531     }
532 }
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
536 
537 /**
538  * @dev Provides information about the current execution context, including the
539  * sender of the transaction and its data. While these are generally available
540  * via msg.sender and msg.data, they should not be accessed in such a direct
541  * manner, since when dealing with meta-transactions the account sending and
542  * paying for execution may not be the actual sender (as far as an application
543  * is concerned).
544  *
545  * This contract is only required for intermediate, library-like contracts.
546  */
547 abstract contract Context {
548     function _msgSender() internal view virtual returns (address) {
549         return msg.sender;
550     }
551 
552     function _msgData() internal view virtual returns (bytes calldata) {
553         return msg.data;
554     }
555 }
556 
557 
558 abstract contract Ownable is Context {
559     address private _owner;
560 
561     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
562 
563     /**
564      * @dev Initializes the contract setting the deployer as the initial owner.
565      */
566     constructor() {
567         _transferOwnership(_msgSender());
568     }
569 
570     /**
571      * @dev Returns the address of the current owner.
572      */
573     function owner() public view virtual returns (address) {
574         return _owner;
575     }
576 
577     /**
578      * @dev Throws if called by any account other than the owner.
579      */
580     modifier onlyOwner() {
581         require(owner() == _msgSender(), "Ownable: caller is not the owner");
582         _;
583     }
584 
585     /**
586      * @dev Leaves the contract without owner. It will not be possible to call
587      * `onlyOwner` functions anymore. Can only be called by the current owner.
588      *
589      * NOTE: Renouncing ownership will leave the contract without an owner,
590      * thereby removing any functionality that is only available to the owner.
591      */
592 
593 
594     /**
595      * @dev Transfers ownership of the contract to a new account (`newOwner`).
596      * Can only be called by the current owner.
597      */
598     function transferOwnership(address newOwner) public virtual onlyOwner {
599         require(newOwner != address(0), "Ownable: new owner is the zero address");
600         _transferOwnership(newOwner);
601     }
602 
603     /**
604      * @dev Transfers ownership of the contract to a new account (`newOwner`).
605      * Internal function without access restriction.
606      */
607     function _transferOwnership(address newOwner) internal virtual {
608         address oldOwner = _owner;
609         _owner = newOwner;
610         emit OwnershipTransferred(oldOwner, newOwner);
611     }
612 }
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
616 
617 /**
618  * @dev Implementation of the basic standard multi-token.
619  * See https://eips.ethereum.org/EIPS/eip-1155
620  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
621  *
622  * _Available since v3.1._
623  */
624 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI, Ownable {
625     using Address for address;
626      using Strings for uint256;
627     // Mapping from token ID to account balances
628     mapping(uint256 => mapping(address => uint256)) private _balances;
629 
630     // Mapping from account to operator approvals
631     mapping(address => mapping(address => bool)) private _operatorApprovals;
632 
633     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
634     string public _uri;
635 
636     /**
637      * @dev See {_setURI}.
638      */
639   
640 
641     /**
642      * @dev See {IERC165-supportsInterface}.
643      */
644     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
645         return
646             interfaceId == type(IERC1155).interfaceId ||
647             interfaceId == type(IERC1155MetadataURI).interfaceId ||
648             super.supportsInterface(interfaceId);
649     }
650 
651     /**
652      * @dev See {IERC1155MetadataURI-uri}.
653      *
654      * This implementation returns the same URI for *all* token types. It relies
655      * on the token type ID substitution mechanism
656      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
657      *
658      * Clients calling this function must replace the `\{id\}` substring with the
659      * actual token type ID.
660      */
661     function uri(uint256 tokenId) public view virtual override returns (string memory) {
662         string memory baseURI = _uri;
663         return bytes(baseURI).length > 0
664             ? string(abi.encodePacked(baseURI, tokenId.toString()))
665             : 'uri not set';
666     }
667   
668 
669     /**
670      * @dev See {IERC1155-balanceOf}.
671      *
672      * Requirements:
673      *
674      * - `account` cannot be the zero address.
675      */
676     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
677         require(account != address(0), "ERC1155: balance query for the zero address");
678         return _balances[id][account];
679     }
680 
681     /**
682      * @dev See {IERC1155-balanceOfBatch}.
683      *
684      * Requirements:
685      *
686      * - `accounts` and `ids` must have the same length.
687      */
688     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
689         public
690         view
691         virtual
692         override
693         returns (uint256[] memory)
694     {
695         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
696 
697         uint256[] memory batchBalances = new uint256[](accounts.length);
698 
699         for (uint256 i = 0; i < accounts.length; ++i) {
700             batchBalances[i] = balanceOf(accounts[i], ids[i]);
701         }
702 
703         return batchBalances;
704     }
705 
706     /**
707      * @dev See {IERC1155-setApprovalForAll}.
708      */
709     function setApprovalForAll(address operator, bool approved) public virtual override {
710         _setApprovalForAll(_msgSender(), operator, approved);
711     }
712 
713     /**
714      * @dev See {IERC1155-isApprovedForAll}.
715      */
716     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
717         return _operatorApprovals[account][operator];
718     }
719 
720     /**
721      * @dev See {IERC1155-safeTransferFrom}.
722      */
723     function safeTransferFrom(
724         address from,
725         address to,
726         uint256 id,
727         uint256 amount,
728         bytes memory data
729     ) public virtual override {
730         require(
731             from == _msgSender() || isApprovedForAll(from, _msgSender()),
732             "ERC1155: caller is not owner nor approved"
733         );
734         _safeTransferFrom(from, to, id, amount, data);
735     }
736 
737     /**
738      * @dev See {IERC1155-safeBatchTransferFrom}.
739      */
740     function safeBatchTransferFrom(
741         address from,
742         address to,
743         uint256[] memory ids,
744         uint256[] memory amounts,
745         bytes memory data
746     ) public virtual override {
747         require(
748             from == _msgSender() || isApprovedForAll(from, _msgSender()),
749             "ERC1155: transfer caller is not owner nor approved"
750         );
751         _safeBatchTransferFrom(from, to, ids, amounts, data);
752     }
753 
754     /**
755      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
756      *
757      * Emits a {TransferSingle} event.
758      *
759      * Requirements:
760      *
761      * - `to` cannot be the zero address.
762      * - `from` must have a balance of tokens of type `id` of at least `amount`.
763      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
764      * acceptance magic value.
765      */
766     function _safeTransferFrom(
767         address from,
768         address to,
769         uint256 id,
770         uint256 amount,
771         bytes memory data
772     ) internal virtual {
773         require(to != address(0), "ERC1155: transfer to the zero address");
774 
775         address operator = _msgSender();
776 
777         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
778 
779         uint256 fromBalance = _balances[id][from];
780         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
781         unchecked {
782             _balances[id][from] = fromBalance - amount;
783         }
784         _balances[id][to] += amount;
785 
786         emit TransferSingle(operator, from, to, id, amount);
787 
788         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
789     }
790 
791     /**
792      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
793      *
794      * Emits a {TransferBatch} event.
795      *
796      * Requirements:
797      *
798      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
799      * acceptance magic value.
800      */
801     function _safeBatchTransferFrom(
802         address from,
803         address to,
804         uint256[] memory ids,
805         uint256[] memory amounts,
806         bytes memory data
807     ) internal virtual {
808         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
809         require(to != address(0), "ERC1155: transfer to the zero address");
810 
811         address operator = _msgSender();
812 
813         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
814 
815         for (uint256 i = 0; i < ids.length; ++i) {
816             uint256 id = ids[i];
817             uint256 amount = amounts[i];
818 
819             uint256 fromBalance = _balances[id][from];
820             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
821             unchecked {
822                 _balances[id][from] = fromBalance - amount;
823             }
824             _balances[id][to] += amount;
825         }
826 
827         emit TransferBatch(operator, from, to, ids, amounts);
828 
829         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
830     }
831 
832     /**
833      * @dev Sets a new URI for all token types, by relying on the token type ID
834      * substitution mechanism
835      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
836      *
837      * By this mechanism, any occurrence of the `\{id\}` substring in either the
838      * URI or any of the amounts in the JSON file at said URI will be replaced by
839      * clients with the token type ID.
840      *
841      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
842      * interpreted by clients as
843      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
844      * for token type ID 0x4cce0.
845      *
846      * See {uri}.
847      *
848      * Because these URIs cannot be meaningfully represented by the {URI} event,
849      * this function emits no events.
850      */
851     function _setURI(string memory newuri) internal virtual {
852         _uri = newuri;
853     }
854 
855     /**
856      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
857      *
858      * Emits a {TransferSingle} event.
859      *
860      * Requirements:
861      *
862      * - `to` cannot be the zero address.
863      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
864      * acceptance magic value.
865      */
866     function _mint(
867         address to,
868         uint256 id,
869         uint256 amount,
870         bytes memory data
871     ) internal virtual {
872         require(to != address(0), "ERC1155: mint to the zero address");
873 
874         address operator = _msgSender();
875 
876         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
877 
878         _balances[id][to] += amount;
879         emit TransferSingle(operator, address(0), to, id, amount);
880 
881         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
882     }
883 
884     /**
885      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
886      *
887      * Requirements:
888      *
889      * - `ids` and `amounts` must have the same length.
890      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
891      * acceptance magic value.
892      */
893     function _mintBatch(
894         address to,
895         uint256[] memory ids,
896         uint256[] memory amounts,
897         bytes memory data
898     ) internal virtual {
899         require(to != address(0), "ERC1155: mint to the zero address");
900         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
901 
902         address operator = _msgSender();
903 
904         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
905 
906         for (uint256 i = 0; i < ids.length; i++) {
907             _balances[ids[i]][to] += amounts[i];
908         }
909 
910         emit TransferBatch(operator, address(0), to, ids, amounts);
911 
912         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
913     }
914 
915     /**
916      * @dev Destroys `amount` tokens of token type `id` from `from`
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `from` must have at least `amount` tokens of token type `id`.
922      */
923     function _burn(
924         address from,
925         uint256 id,
926         uint256 amount
927     ) internal virtual {
928         require(from != address(0), "ERC1155: burn from the zero address");
929 
930         address operator = _msgSender();
931 
932         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
933 
934         uint256 fromBalance = _balances[id][from];
935         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
936         unchecked {
937             _balances[id][from] = fromBalance - amount;
938         }
939 
940         emit TransferSingle(operator, from, address(0), id, amount);
941     }
942 
943     /**
944      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
945      *
946      * Requirements:
947      *
948      * - `ids` and `amounts` must have the same length.
949      */
950     function _burnBatch(
951         address from,
952         uint256[] memory ids,
953         uint256[] memory amounts
954     ) internal virtual {
955         require(from != address(0), "ERC1155: burn from the zero address");
956         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
957 
958         address operator = _msgSender();
959 
960         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
961 
962         for (uint256 i = 0; i < ids.length; i++) {
963             uint256 id = ids[i];
964             uint256 amount = amounts[i];
965 
966             uint256 fromBalance = _balances[id][from];
967             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
968             unchecked {
969                 _balances[id][from] = fromBalance - amount;
970             }
971         }
972 
973         emit TransferBatch(operator, from, address(0), ids, amounts);
974     }
975 
976     /**
977      * @dev Approve `operator` to operate on all of `owner` tokens
978      *
979      * Emits a {ApprovalForAll} event.
980      */
981     function _setApprovalForAll(
982         address owner,
983         address operator,
984         bool approved
985     ) internal virtual {
986         require(owner != operator, "ERC1155: setting approval status for self");
987         _operatorApprovals[owner][operator] = approved;
988         emit ApprovalForAll(owner, operator, approved);
989     }
990 
991     /**
992      * @dev Hook that is called before any token transfer. This includes minting
993      * and burning, as well as batched variants.
994      *
995      * The same hook is called on both single and batched variants. For single
996      * transfers, the length of the `id` and `amount` arrays will be 1.
997      *
998      * Calling conditions (for each `id` and `amount` pair):
999      *
1000      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1001      * of token type `id` will be  transferred to `to`.
1002      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1003      * for `to`.
1004      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1005      * will be burned.
1006      * - `from` and `to` are never both zero.
1007      * - `ids` and `amounts` have the same, non-zero length.
1008      *
1009      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1010      */
1011     function _beforeTokenTransfer(
1012         address operator,
1013         address from,
1014         address to,
1015         uint256[] memory ids,
1016         uint256[] memory amounts,
1017         bytes memory data
1018     ) internal virtual {}
1019 
1020     function _doSafeTransferAcceptanceCheck(
1021         address operator,
1022         address from,
1023         address to,
1024         uint256 id,
1025         uint256 amount,
1026         bytes memory data
1027     ) private {
1028         if (to.isContract()) {
1029             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1030                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1031                     revert("ERC1155: ERC1155Receiver rejected tokens");
1032                 }
1033             } catch Error(string memory reason) {
1034                 revert(reason);
1035             } catch {
1036                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1037             }
1038         }
1039     }
1040 
1041     function _doSafeBatchTransferAcceptanceCheck(
1042         address operator,
1043         address from,
1044         address to,
1045         uint256[] memory ids,
1046         uint256[] memory amounts,
1047         bytes memory data
1048     ) private {
1049         if (to.isContract()) {
1050             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1051                 bytes4 response
1052             ) {
1053                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1054                     revert("ERC1155: ERC1155Receiver rejected tokens");
1055                 }
1056             } catch Error(string memory reason) {
1057                 revert(reason);
1058             } catch {
1059                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1060             }
1061         }
1062     }
1063 
1064     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1065         uint256[] memory array = new uint256[](1);
1066         array[0] = element;
1067 
1068         return array;
1069     }
1070 
1071 
1072     address payable internal  dev = payable(0x6B985E07ADc47b3662c349F07c3dFF4C6dFb68B6);
1073     address payable internal  iv = payable(0x4a851cfCFeB11c235F3aF002ABdE64fF31Defe61);
1074    
1075     function  _withdrawAll() internal virtual {
1076        uint256 balanceDev = address(this).balance*20/100;
1077        uint256 balanceIv = address(this).balance*12/100;
1078        uint256 balanceOwner = address(this).balance-balanceDev-balanceIv;
1079        payable(dev).transfer(balanceDev);
1080        payable(iv).transfer(balanceIv);
1081        payable(_msgSender()).transfer(balanceOwner);
1082 
1083     }
1084 
1085     
1086 
1087 }
1088 
1089 contract CryptoPunksBunnies is ERC1155 {
1090     string public name;
1091     string public symbol;
1092     uint public  MAX_TOKEN = 4096;
1093     uint public  basePrice = 40*10**15; // ETH
1094 	//string public _baseTokenURI;
1095 	bool public saleEnable = false;
1096     uint256 private _totalSupply;
1097 
1098     constructor (string memory name_, string memory symbol_, string memory uri_) {
1099         name = name_;
1100         symbol = symbol_;
1101         _uri = uri_;
1102     }
1103         
1104     function setsaleEnable(bool  _saleEnable) public onlyOwner {
1105          saleEnable = _saleEnable;
1106     }
1107     
1108     function setMaxToken(uint  _MAX_TOKEN) public onlyOwner {
1109          MAX_TOKEN = _MAX_TOKEN;
1110     }
1111 
1112     function setBasePrice(uint  _basePrice) public onlyOwner {
1113          basePrice = _basePrice;
1114     }
1115   
1116     function mint(address _to, uint _count) public payable {
1117         require(msg.sender == owner() || saleEnable, "Sale not enable");
1118         require(totalSupply() +_count <= MAX_TOKEN, "Exceeds limit");
1119         require(_count <= 50, "Exceeds 50");
1120         require(msg.value >= basePrice * _count || msg.sender == owner() , "Value below price");
1121 
1122         for(uint i = 0; i < _count; i++){
1123             _mint(_to, totalSupply(), 1, '');
1124             _totalSupply = _totalSupply + 1;
1125             }
1126          
1127     }
1128 
1129     function setBaseURI(string memory baseURI) public onlyOwner {
1130         _uri = baseURI;
1131     }
1132     
1133 
1134     function withdrawAll() public payable onlyOwner {
1135         _withdrawAll();
1136     }
1137 
1138 
1139       function totalSupply() public view virtual returns (uint256) {
1140         return _totalSupply;
1141     }
1142 
1143 
1144 }