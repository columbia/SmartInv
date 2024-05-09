1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Address.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
110 
111 pragma solidity ^0.8.0;
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
133      */
134     function isContract(address account) internal view returns (bool) {
135         // This method relies on extcodesize, which returns 0 for contracts in
136         // construction, since the code is only stored at the end of the
137         // constructor execution.
138 
139         uint256 size;
140         assembly {
141             size := extcodesize(account)
142         }
143         return size > 0;
144     }
145 
146     /**
147      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
148      * `recipient`, forwarding all available gas and reverting on errors.
149      *
150      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
151      * of certain opcodes, possibly making contracts go over the 2300 gas limit
152      * imposed by `transfer`, making them unable to receive funds via
153      * `transfer`. {sendValue} removes this limitation.
154      *
155      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
156      *
157      * IMPORTANT: because control is transferred to `recipient`, care must be
158      * taken to not create reentrancy vulnerabilities. Consider using
159      * {ReentrancyGuard} or the
160      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
161      */
162     function sendValue(address payable recipient, uint256 amount) internal {
163         require(address(this).balance >= amount, "Address: insufficient balance");
164 
165         (bool success, ) = recipient.call{value: amount}("");
166         require(success, "Address: unable to send value, recipient may have reverted");
167     }
168 
169     /**
170      * @dev Performs a Solidity function call using a low level `call`. A
171      * plain `call` is an unsafe replacement for a function call: use this
172      * function instead.
173      *
174      * If `target` reverts with a revert reason, it is bubbled up by this
175      * function (like regular Solidity function calls).
176      *
177      * Returns the raw returned data. To convert to the expected return value,
178      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
179      *
180      * Requirements:
181      *
182      * - `target` must be a contract.
183      * - calling `target` with `data` must not revert.
184      *
185      * _Available since v3.1._
186      */
187     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
188         return functionCall(target, data, "Address: low-level call failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
193      * `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, 0, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but also transferring `value` wei to `target`.
208      *
209      * Requirements:
210      *
211      * - the calling contract must have an ETH balance of at least `value`.
212      * - the called Solidity function must be `payable`.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value
220     ) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
226      * with `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCallWithValue(
231         address target,
232         bytes memory data,
233         uint256 value,
234         string memory errorMessage
235     ) internal returns (bytes memory) {
236         require(address(this).balance >= value, "Address: insufficient balance for call");
237         require(isContract(target), "Address: call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.call{value: value}(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
250         return functionStaticCall(target, data, "Address: low-level static call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal view returns (bytes memory) {
264         require(isContract(target), "Address: static call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.staticcall(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but performing a delegate call.
273      *
274      * _Available since v3.4._
275      */
276     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
282      * but performing a delegate call.
283      *
284      * _Available since v3.4._
285      */
286     function functionDelegateCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         require(isContract(target), "Address: delegate call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.delegatecall(data);
294         return verifyCallResult(success, returndata, errorMessage);
295     }
296 
297     /**
298      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
299      * revert reason using the provided one.
300      *
301      * _Available since v4.3._
302      */
303     function verifyCallResult(
304         bool success,
305         bytes memory returndata,
306         string memory errorMessage
307     ) internal pure returns (bytes memory) {
308         if (success) {
309             return returndata;
310         } else {
311             // Look for revert reason and bubble it up if present
312             if (returndata.length > 0) {
313                 // The easiest way to bubble the revert reason is using memory via assembly
314 
315                 assembly {
316                     let returndata_size := mload(returndata)
317                     revert(add(32, returndata), returndata_size)
318                 }
319             } else {
320                 revert(errorMessage);
321             }
322         }
323     }
324 }
325 
326 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
386 
387 
388 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev _Available since v3.1._
395  */
396 interface IERC1155Receiver is IERC165 {
397     /**
398         @dev Handles the receipt of a single ERC1155 token type. This function is
399         called at the end of a `safeTransferFrom` after the balance has been updated.
400         To accept the transfer, this must return
401         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
402         (i.e. 0xf23a6e61, or its own function selector).
403         @param operator The address which initiated the transfer (i.e. msg.sender)
404         @param from The address which previously owned the token
405         @param id The ID of the token being transferred
406         @param value The amount of tokens being transferred
407         @param data Additional data with no specified format
408         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
409     */
410     function onERC1155Received(
411         address operator,
412         address from,
413         uint256 id,
414         uint256 value,
415         bytes calldata data
416     ) external returns (bytes4);
417 
418     /**
419         @dev Handles the receipt of a multiple ERC1155 token types. This function
420         is called at the end of a `safeBatchTransferFrom` after the balances have
421         been updated. To accept the transfer(s), this must return
422         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
423         (i.e. 0xbc197c81, or its own function selector).
424         @param operator The address which initiated the batch transfer (i.e. msg.sender)
425         @param from The address which previously owned the token
426         @param ids An array containing ids of each token being transferred (order and length must match values array)
427         @param values An array containing amounts of each token being transferred (order and length must match ids array)
428         @param data Additional data with no specified format
429         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
430     */
431     function onERC1155BatchReceived(
432         address operator,
433         address from,
434         uint256[] calldata ids,
435         uint256[] calldata values,
436         bytes calldata data
437     ) external returns (bytes4);
438 }
439 
440 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
441 
442 
443 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 
448 /**
449  * @dev Required interface of an ERC1155 compliant contract, as defined in the
450  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
451  *
452  * _Available since v3.1._
453  */
454 interface IERC1155 is IERC165 {
455     /**
456      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
457      */
458     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
459 
460     /**
461      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
462      * transfers.
463      */
464     event TransferBatch(
465         address indexed operator,
466         address indexed from,
467         address indexed to,
468         uint256[] ids,
469         uint256[] values
470     );
471 
472     /**
473      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
474      * `approved`.
475      */
476     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
477 
478     /**
479      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
480      *
481      * If an {URI} event was emitted for `id`, the standard
482      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
483      * returned by {IERC1155MetadataURI-uri}.
484      */
485     event URI(string value, uint256 indexed id);
486 
487     /**
488      * @dev Returns the amount of tokens of token type `id` owned by `account`.
489      *
490      * Requirements:
491      *
492      * - `account` cannot be the zero address.
493      */
494     function balanceOf(address account, uint256 id) external view returns (uint256);
495 
496     /**
497      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
498      *
499      * Requirements:
500      *
501      * - `accounts` and `ids` must have the same length.
502      */
503     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
504         external
505         view
506         returns (uint256[] memory);
507 
508     /**
509      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
510      *
511      * Emits an {ApprovalForAll} event.
512      *
513      * Requirements:
514      *
515      * - `operator` cannot be the caller.
516      */
517     function setApprovalForAll(address operator, bool approved) external;
518 
519     /**
520      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
521      *
522      * See {setApprovalForAll}.
523      */
524     function isApprovedForAll(address account, address operator) external view returns (bool);
525 
526     /**
527      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
528      *
529      * Emits a {TransferSingle} event.
530      *
531      * Requirements:
532      *
533      * - `to` cannot be the zero address.
534      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
535      * - `from` must have a balance of tokens of type `id` of at least `amount`.
536      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
537      * acceptance magic value.
538      */
539     function safeTransferFrom(
540         address from,
541         address to,
542         uint256 id,
543         uint256 amount,
544         bytes calldata data
545     ) external;
546 
547     /**
548      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
549      *
550      * Emits a {TransferBatch} event.
551      *
552      * Requirements:
553      *
554      * - `ids` and `amounts` must have the same length.
555      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
556      * acceptance magic value.
557      */
558     function safeBatchTransferFrom(
559         address from,
560         address to,
561         uint256[] calldata ids,
562         uint256[] calldata amounts,
563         bytes calldata data
564     ) external;
565 }
566 
567 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
568 
569 
570 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 
575 /**
576  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
577  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
578  *
579  * _Available since v3.1._
580  */
581 interface IERC1155MetadataURI is IERC1155 {
582     /**
583      * @dev Returns the URI for token type `id`.
584      *
585      * If the `\{id\}` substring is present in the URI, it must be replaced by
586      * clients with the actual token type ID.
587      */
588     function uri(uint256 id) external view returns (string memory);
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 
599 
600 
601 
602 
603 
604 /**
605  * @dev Implementation of the basic standard multi-token.
606  * See https://eips.ethereum.org/EIPS/eip-1155
607  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
608  *
609  * _Available since v3.1._
610  */
611 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
612     using Address for address;
613 
614     // Mapping from token ID to account balances
615     mapping(uint256 => mapping(address => uint256)) private _balances;
616 
617     // Mapping from account to operator approvals
618     mapping(address => mapping(address => bool)) private _operatorApprovals;
619 
620     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
621     string private _uri;
622 
623     /**
624      * @dev See {_setURI}.
625      */
626     constructor(string memory uri_) {
627         _setURI(uri_);
628     }
629 
630     /**
631      * @dev See {IERC165-supportsInterface}.
632      */
633     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
634         return
635             interfaceId == type(IERC1155).interfaceId ||
636             interfaceId == type(IERC1155MetadataURI).interfaceId ||
637             super.supportsInterface(interfaceId);
638     }
639 
640     /**
641      * @dev See {IERC1155MetadataURI-uri}.
642      *
643      * This implementation returns the same URI for *all* token types. It relies
644      * on the token type ID substitution mechanism
645      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
646      *
647      * Clients calling this function must replace the `\{id\}` substring with the
648      * actual token type ID.
649      */
650     function uri(uint256) public view virtual override returns (string memory) {
651         return _uri;
652     }
653 
654     /**
655      * @dev See {IERC1155-balanceOf}.
656      *
657      * Requirements:
658      *
659      * - `account` cannot be the zero address.
660      */
661     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
662         require(account != address(0), "ERC1155: balance query for the zero address");
663         return _balances[id][account];
664     }
665 
666     /**
667      * @dev See {IERC1155-balanceOfBatch}.
668      *
669      * Requirements:
670      *
671      * - `accounts` and `ids` must have the same length.
672      */
673     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
674         public
675         view
676         virtual
677         override
678         returns (uint256[] memory)
679     {
680         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
681 
682         uint256[] memory batchBalances = new uint256[](accounts.length);
683 
684         for (uint256 i = 0; i < accounts.length; ++i) {
685             batchBalances[i] = balanceOf(accounts[i], ids[i]);
686         }
687 
688         return batchBalances;
689     }
690 
691     /**
692      * @dev See {IERC1155-setApprovalForAll}.
693      */
694     function setApprovalForAll(address operator, bool approved) public virtual override {
695         _setApprovalForAll(_msgSender(), operator, approved);
696     }
697 
698     /**
699      * @dev See {IERC1155-isApprovedForAll}.
700      */
701     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
702         return _operatorApprovals[account][operator];
703     }
704 
705     /**
706      * @dev See {IERC1155-safeTransferFrom}.
707      */
708     function safeTransferFrom(
709         address from,
710         address to,
711         uint256 id,
712         uint256 amount,
713         bytes memory data
714     ) public virtual override {
715         require(
716             from == _msgSender() || isApprovedForAll(from, _msgSender()),
717             "ERC1155: caller is not owner nor approved"
718         );
719         _safeTransferFrom(from, to, id, amount, data);
720     }
721 
722     /**
723      * @dev See {IERC1155-safeBatchTransferFrom}.
724      */
725     function safeBatchTransferFrom(
726         address from,
727         address to,
728         uint256[] memory ids,
729         uint256[] memory amounts,
730         bytes memory data
731     ) public virtual override {
732         require(
733             from == _msgSender() || isApprovedForAll(from, _msgSender()),
734             "ERC1155: transfer caller is not owner nor approved"
735         );
736         _safeBatchTransferFrom(from, to, ids, amounts, data);
737     }
738 
739     /**
740      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
741      *
742      * Emits a {TransferSingle} event.
743      *
744      * Requirements:
745      *
746      * - `to` cannot be the zero address.
747      * - `from` must have a balance of tokens of type `id` of at least `amount`.
748      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
749      * acceptance magic value.
750      */
751     function _safeTransferFrom(
752         address from,
753         address to,
754         uint256 id,
755         uint256 amount,
756         bytes memory data
757     ) internal virtual {
758         require(to != address(0), "ERC1155: transfer to the zero address");
759 
760         address operator = _msgSender();
761 
762         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
763 
764         uint256 fromBalance = _balances[id][from];
765         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
766         unchecked {
767             _balances[id][from] = fromBalance - amount;
768         }
769         _balances[id][to] += amount;
770 
771         emit TransferSingle(operator, from, to, id, amount);
772 
773         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
774     }
775 
776     /**
777      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
778      *
779      * Emits a {TransferBatch} event.
780      *
781      * Requirements:
782      *
783      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
784      * acceptance magic value.
785      */
786     function _safeBatchTransferFrom(
787         address from,
788         address to,
789         uint256[] memory ids,
790         uint256[] memory amounts,
791         bytes memory data
792     ) internal virtual {
793         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
794         require(to != address(0), "ERC1155: transfer to the zero address");
795 
796         address operator = _msgSender();
797 
798         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
799 
800         for (uint256 i = 0; i < ids.length; ++i) {
801             uint256 id = ids[i];
802             uint256 amount = amounts[i];
803 
804             uint256 fromBalance = _balances[id][from];
805             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
806             unchecked {
807                 _balances[id][from] = fromBalance - amount;
808             }
809             _balances[id][to] += amount;
810         }
811 
812         emit TransferBatch(operator, from, to, ids, amounts);
813 
814         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
815     }
816 
817     /**
818      * @dev Sets a new URI for all token types, by relying on the token type ID
819      * substitution mechanism
820      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
821      *
822      * By this mechanism, any occurrence of the `\{id\}` substring in either the
823      * URI or any of the amounts in the JSON file at said URI will be replaced by
824      * clients with the token type ID.
825      *
826      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
827      * interpreted by clients as
828      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
829      * for token type ID 0x4cce0.
830      *
831      * See {uri}.
832      *
833      * Because these URIs cannot be meaningfully represented by the {URI} event,
834      * this function emits no events.
835      */
836     function _setURI(string memory newuri) internal virtual {
837         _uri = newuri;
838     }
839 
840     /**
841      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
842      *
843      * Emits a {TransferSingle} event.
844      *
845      * Requirements:
846      *
847      * - `to` cannot be the zero address.
848      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
849      * acceptance magic value.
850      */
851     function _mint(
852         address to,
853         uint256 id,
854         uint256 amount,
855         bytes memory data
856     ) internal virtual {
857         require(to != address(0), "ERC1155: mint to the zero address");
858 
859         address operator = _msgSender();
860 
861         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
862 
863         _balances[id][to] += amount;
864         emit TransferSingle(operator, address(0), to, id, amount);
865 
866         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
867     }
868 
869     /**
870      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
871      *
872      * Requirements:
873      *
874      * - `ids` and `amounts` must have the same length.
875      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
876      * acceptance magic value.
877      */
878     function _mintBatch(
879         address to,
880         uint256[] memory ids,
881         uint256[] memory amounts,
882         bytes memory data
883     ) internal virtual {
884         require(to != address(0), "ERC1155: mint to the zero address");
885         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
886 
887         address operator = _msgSender();
888 
889         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
890 
891         for (uint256 i = 0; i < ids.length; i++) {
892             _balances[ids[i]][to] += amounts[i];
893         }
894 
895         emit TransferBatch(operator, address(0), to, ids, amounts);
896 
897         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
898     }
899 
900     /**
901      * @dev Destroys `amount` tokens of token type `id` from `from`
902      *
903      * Requirements:
904      *
905      * - `from` cannot be the zero address.
906      * - `from` must have at least `amount` tokens of token type `id`.
907      */
908     function _burn(
909         address from,
910         uint256 id,
911         uint256 amount
912     ) internal virtual {
913         require(from != address(0), "ERC1155: burn from the zero address");
914 
915         address operator = _msgSender();
916 
917         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
918 
919         uint256 fromBalance = _balances[id][from];
920         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
921         unchecked {
922             _balances[id][from] = fromBalance - amount;
923         }
924 
925         emit TransferSingle(operator, from, address(0), id, amount);
926     }
927 
928     /**
929      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
930      *
931      * Requirements:
932      *
933      * - `ids` and `amounts` must have the same length.
934      */
935     function _burnBatch(
936         address from,
937         uint256[] memory ids,
938         uint256[] memory amounts
939     ) internal virtual {
940         require(from != address(0), "ERC1155: burn from the zero address");
941         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
942 
943         address operator = _msgSender();
944 
945         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
946 
947         for (uint256 i = 0; i < ids.length; i++) {
948             uint256 id = ids[i];
949             uint256 amount = amounts[i];
950 
951             uint256 fromBalance = _balances[id][from];
952             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
953             unchecked {
954                 _balances[id][from] = fromBalance - amount;
955             }
956         }
957 
958         emit TransferBatch(operator, from, address(0), ids, amounts);
959     }
960 
961     /**
962      * @dev Approve `operator` to operate on all of `owner` tokens
963      *
964      * Emits a {ApprovalForAll} event.
965      */
966     function _setApprovalForAll(
967         address owner,
968         address operator,
969         bool approved
970     ) internal virtual {
971         require(owner != operator, "ERC1155: setting approval status for self");
972         _operatorApprovals[owner][operator] = approved;
973         emit ApprovalForAll(owner, operator, approved);
974     }
975 
976     /**
977      * @dev Hook that is called before any token transfer. This includes minting
978      * and burning, as well as batched variants.
979      *
980      * The same hook is called on both single and batched variants. For single
981      * transfers, the length of the `id` and `amount` arrays will be 1.
982      *
983      * Calling conditions (for each `id` and `amount` pair):
984      *
985      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
986      * of token type `id` will be  transferred to `to`.
987      * - When `from` is zero, `amount` tokens of token type `id` will be minted
988      * for `to`.
989      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
990      * will be burned.
991      * - `from` and `to` are never both zero.
992      * - `ids` and `amounts` have the same, non-zero length.
993      *
994      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
995      */
996     function _beforeTokenTransfer(
997         address operator,
998         address from,
999         address to,
1000         uint256[] memory ids,
1001         uint256[] memory amounts,
1002         bytes memory data
1003     ) internal virtual {}
1004 
1005     function _doSafeTransferAcceptanceCheck(
1006         address operator,
1007         address from,
1008         address to,
1009         uint256 id,
1010         uint256 amount,
1011         bytes memory data
1012     ) private {
1013         if (to.isContract()) {
1014             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1015                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1016                     revert("ERC1155: ERC1155Receiver rejected tokens");
1017                 }
1018             } catch Error(string memory reason) {
1019                 revert(reason);
1020             } catch {
1021                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1022             }
1023         }
1024     }
1025 
1026     function _doSafeBatchTransferAcceptanceCheck(
1027         address operator,
1028         address from,
1029         address to,
1030         uint256[] memory ids,
1031         uint256[] memory amounts,
1032         bytes memory data
1033     ) private {
1034         if (to.isContract()) {
1035             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1036                 bytes4 response
1037             ) {
1038                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1039                     revert("ERC1155: ERC1155Receiver rejected tokens");
1040                 }
1041             } catch Error(string memory reason) {
1042                 revert(reason);
1043             } catch {
1044                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1045             }
1046         }
1047     }
1048 
1049     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1050         uint256[] memory array = new uint256[](1);
1051         array[0] = element;
1052 
1053         return array;
1054     }
1055 }
1056 
1057 // File: contracts/BucketsClub.sol
1058 
1059 
1060 pragma solidity ^0.8.0;
1061 
1062 
1063 
1064 contract BucketsClub is ERC1155, Ownable {
1065     string public constant name = "Buckets Club";
1066     string public constant symbol = "BUCKETS";
1067 
1068     uint32 public totalSupply = 0;
1069     uint32 public constant maxSupply = 1000;
1070     uint256 public constant unitPrice = 0.3 ether;
1071 
1072     uint32 public preSaleStart = 1639616400;
1073     uint32 public publicSaleStart = 1639702800;
1074 
1075     uint32 public constant preSaleMaxPerAddress = 1;
1076     uint32 public constant publicSaleMaxPerAddress = 5;
1077 
1078     address private signerAddress = 0xbF645f208E06053a586ee6b23F2b5c430753BACc;
1079 
1080     mapping(address => uint256) private _tokensMintedByAddress;
1081 
1082     constructor(string memory uri) ERC1155(uri) {}
1083 
1084     function setURI(string memory uri) public onlyOwner {
1085         _setURI(uri);
1086     }
1087 
1088     function setSignerAddress(address addr) external onlyOwner {
1089         signerAddress = addr;
1090     }
1091 
1092     function setPreSaleStart(uint32 timestamp) public onlyOwner {
1093         preSaleStart = timestamp;
1094     }
1095 
1096     function setPublicSaleStart(uint32 timestamp) public onlyOwner {
1097         publicSaleStart = timestamp;
1098     }
1099 
1100     function preSaleIsActive() public view returns (bool) {
1101         return
1102             preSaleStart <= block.timestamp &&
1103             publicSaleStart >= block.timestamp;
1104     }
1105 
1106     function publicSaleIsActive() public view returns (bool) {
1107         return publicSaleStart <= block.timestamp;
1108     }
1109 
1110     function isValidAccessMessage(
1111         uint8 v,
1112         bytes32 r,
1113         bytes32 s
1114     ) internal view returns (bool) {
1115         bytes32 hash = keccak256(abi.encodePacked(msg.sender));
1116         return
1117             signerAddress ==
1118             ecrecover(
1119                 keccak256(
1120                     abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1121                 ),
1122                 v,
1123                 r,
1124                 s
1125             );
1126     }
1127 
1128     function mint(address to, uint32 count) internal {
1129         if (count > 1) {
1130             uint256[] memory ids = new uint256[](uint256(count));
1131             uint256[] memory amounts = new uint256[](uint256(count));
1132 
1133             for (uint32 i = 0; i < count; i++) {
1134                 ids[i] = totalSupply + i;
1135                 amounts[i] = 1;
1136             }
1137 
1138             _mintBatch(to, ids, amounts, "");
1139         } else {
1140             _mint(to, totalSupply, 1, "");
1141         }
1142 
1143         totalSupply += count;
1144     }
1145 
1146     function preSaleMint(
1147         uint8 v,
1148         bytes32 r,
1149         bytes32 s,
1150         uint32 count
1151     ) external payable {
1152         require(preSaleIsActive(), "Pre-sale is not active.");
1153         require(isValidAccessMessage(v, r, s), "Not whitelisted.");
1154         require(count > 0, "Count must be greater than 0.");
1155         require(
1156             totalSupply + count <= maxSupply,
1157             "Count exceeds the maximum allowed supply."
1158         );
1159         require(
1160             _tokensMintedByAddress[msg.sender] + count <= preSaleMaxPerAddress,
1161             "Count exceeds the maximum allowed per address."
1162         );
1163         require(msg.value >= unitPrice * count, "Not enough ether.");
1164 
1165         mint(msg.sender, count);
1166         _tokensMintedByAddress[msg.sender] += count;
1167     }
1168 
1169     function publicSaleMint(uint32 count) external payable {
1170         require(publicSaleIsActive(), "Public sale is not active.");
1171         require(count > 0, "Count must be greater than 0.");
1172         require(
1173             totalSupply + count <= maxSupply,
1174             "Count exceeds the maximum allowed supply."
1175         );
1176         require(
1177             _tokensMintedByAddress[msg.sender] + count <=
1178                 publicSaleMaxPerAddress,
1179             "Count exceeds the maximum allowed per address."
1180         );
1181         require(msg.value >= unitPrice * count, "Not enough ether.");
1182 
1183         mint(msg.sender, count);
1184         _tokensMintedByAddress[msg.sender] += count;
1185     }
1186 
1187     function batchMint(address[] memory addresses) external onlyOwner {
1188         require(
1189             totalSupply + addresses.length <= maxSupply,
1190             "Count exceeds the maximum allowed supply."
1191         );
1192 
1193         for (uint256 i = 0; i < addresses.length; i++) {
1194             mint(addresses[i], 1);
1195         }
1196     }
1197 
1198     function withdraw() external onlyOwner {
1199         address[3] memory addresses = [
1200             0xcC090398DC4dEA02f657168914B9ef3E828Ec81a,
1201             0x930A4fDCbA0f7E2101e91CB3Bc2CA3b26e2a80a3,
1202             0xdAD1EF6384492059Db601C22502F3C1E1C04A4CF
1203         ];
1204 
1205         uint32[3] memory shares = [uint32(7500), uint32(1500), uint32(1000)];
1206 
1207         uint256 balance = address(this).balance;
1208 
1209         for (uint32 i = 0; i < addresses.length; i++) {
1210             uint256 amount = i == addresses.length - 1
1211                 ? address(this).balance
1212                 : (balance * shares[i]) / 10000;
1213             payable(addresses[i]).transfer(amount);
1214         }
1215     }
1216 }