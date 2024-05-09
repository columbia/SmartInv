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
1057 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1058 
1059 
1060 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1061 
1062 pragma solidity ^0.8.0;
1063 
1064 
1065 /**
1066  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1067  *
1068  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1069  * clearly identified. Note: While a totalSupply of 1 might mean the
1070  * corresponding is an NFT, there is no guarantees that no other token with the
1071  * same id are not going to be minted.
1072  */
1073 abstract contract ERC1155Supply is ERC1155 {
1074     mapping(uint256 => uint256) private _totalSupply;
1075 
1076     /**
1077      * @dev Total amount of tokens in with a given id.
1078      */
1079     function totalSupply(uint256 id) public view virtual returns (uint256) {
1080         return _totalSupply[id];
1081     }
1082 
1083     /**
1084      * @dev Indicates whether any token exist with a given id, or not.
1085      */
1086     function exists(uint256 id) public view virtual returns (bool) {
1087         return ERC1155Supply.totalSupply(id) > 0;
1088     }
1089 
1090     /**
1091      * @dev See {ERC1155-_beforeTokenTransfer}.
1092      */
1093     function _beforeTokenTransfer(
1094         address operator,
1095         address from,
1096         address to,
1097         uint256[] memory ids,
1098         uint256[] memory amounts,
1099         bytes memory data
1100     ) internal virtual override {
1101         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1102 
1103         if (from == address(0)) {
1104             for (uint256 i = 0; i < ids.length; ++i) {
1105                 _totalSupply[ids[i]] += amounts[i];
1106             }
1107         }
1108 
1109         if (to == address(0)) {
1110             for (uint256 i = 0; i < ids.length; ++i) {
1111                 _totalSupply[ids[i]] -= amounts[i];
1112             }
1113         }
1114     }
1115 }
1116 
1117 // File: @openzeppelin/contracts/utils/Strings.sol
1118 
1119 
1120 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1121 
1122 pragma solidity ^0.8.0;
1123 
1124 /**
1125  * @dev String operations.
1126  */
1127 library Strings {
1128     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1129 
1130     /**
1131      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1132      */
1133     function toString(uint256 value) internal pure returns (string memory) {
1134         // Inspired by OraclizeAPI's implementation - MIT licence
1135         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1136 
1137         if (value == 0) {
1138             return "0";
1139         }
1140         uint256 temp = value;
1141         uint256 digits;
1142         while (temp != 0) {
1143             digits++;
1144             temp /= 10;
1145         }
1146         bytes memory buffer = new bytes(digits);
1147         while (value != 0) {
1148             digits -= 1;
1149             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1150             value /= 10;
1151         }
1152         return string(buffer);
1153     }
1154 
1155     /**
1156      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1157      */
1158     function toHexString(uint256 value) internal pure returns (string memory) {
1159         if (value == 0) {
1160             return "0x00";
1161         }
1162         uint256 temp = value;
1163         uint256 length = 0;
1164         while (temp != 0) {
1165             length++;
1166             temp >>= 8;
1167         }
1168         return toHexString(value, length);
1169     }
1170 
1171     /**
1172      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1173      */
1174     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1175         bytes memory buffer = new bytes(2 * length + 2);
1176         buffer[0] = "0";
1177         buffer[1] = "x";
1178         for (uint256 i = 2 * length + 1; i > 1; --i) {
1179             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1180             value >>= 4;
1181         }
1182         require(value == 0, "Strings: hex length insufficient");
1183         return string(buffer);
1184     }
1185 }
1186 
1187 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1188 
1189 
1190 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 
1195 /**
1196  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1197  *
1198  * These functions can be used to verify that a message was signed by the holder
1199  * of the private keys of a given address.
1200  */
1201 library ECDSA {
1202     enum RecoverError {
1203         NoError,
1204         InvalidSignature,
1205         InvalidSignatureLength,
1206         InvalidSignatureS,
1207         InvalidSignatureV
1208     }
1209 
1210     function _throwError(RecoverError error) private pure {
1211         if (error == RecoverError.NoError) {
1212             return; // no error: do nothing
1213         } else if (error == RecoverError.InvalidSignature) {
1214             revert("ECDSA: invalid signature");
1215         } else if (error == RecoverError.InvalidSignatureLength) {
1216             revert("ECDSA: invalid signature length");
1217         } else if (error == RecoverError.InvalidSignatureS) {
1218             revert("ECDSA: invalid signature 's' value");
1219         } else if (error == RecoverError.InvalidSignatureV) {
1220             revert("ECDSA: invalid signature 'v' value");
1221         }
1222     }
1223 
1224     /**
1225      * @dev Returns the address that signed a hashed message (`hash`) with
1226      * `signature` or error string. This address can then be used for verification purposes.
1227      *
1228      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1229      * this function rejects them by requiring the `s` value to be in the lower
1230      * half order, and the `v` value to be either 27 or 28.
1231      *
1232      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1233      * verification to be secure: it is possible to craft signatures that
1234      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1235      * this is by receiving a hash of the original message (which may otherwise
1236      * be too long), and then calling {toEthSignedMessageHash} on it.
1237      *
1238      * Documentation for signature generation:
1239      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1240      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1241      *
1242      * _Available since v4.3._
1243      */
1244     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1245         // Check the signature length
1246         // - case 65: r,s,v signature (standard)
1247         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1248         if (signature.length == 65) {
1249             bytes32 r;
1250             bytes32 s;
1251             uint8 v;
1252             // ecrecover takes the signature parameters, and the only way to get them
1253             // currently is to use assembly.
1254             assembly {
1255                 r := mload(add(signature, 0x20))
1256                 s := mload(add(signature, 0x40))
1257                 v := byte(0, mload(add(signature, 0x60)))
1258             }
1259             return tryRecover(hash, v, r, s);
1260         } else if (signature.length == 64) {
1261             bytes32 r;
1262             bytes32 vs;
1263             // ecrecover takes the signature parameters, and the only way to get them
1264             // currently is to use assembly.
1265             assembly {
1266                 r := mload(add(signature, 0x20))
1267                 vs := mload(add(signature, 0x40))
1268             }
1269             return tryRecover(hash, r, vs);
1270         } else {
1271             return (address(0), RecoverError.InvalidSignatureLength);
1272         }
1273     }
1274 
1275     /**
1276      * @dev Returns the address that signed a hashed message (`hash`) with
1277      * `signature`. This address can then be used for verification purposes.
1278      *
1279      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1280      * this function rejects them by requiring the `s` value to be in the lower
1281      * half order, and the `v` value to be either 27 or 28.
1282      *
1283      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1284      * verification to be secure: it is possible to craft signatures that
1285      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1286      * this is by receiving a hash of the original message (which may otherwise
1287      * be too long), and then calling {toEthSignedMessageHash} on it.
1288      */
1289     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1290         (address recovered, RecoverError error) = tryRecover(hash, signature);
1291         _throwError(error);
1292         return recovered;
1293     }
1294 
1295     /**
1296      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1297      *
1298      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1299      *
1300      * _Available since v4.3._
1301      */
1302     function tryRecover(
1303         bytes32 hash,
1304         bytes32 r,
1305         bytes32 vs
1306     ) internal pure returns (address, RecoverError) {
1307         bytes32 s;
1308         uint8 v;
1309         assembly {
1310             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1311             v := add(shr(255, vs), 27)
1312         }
1313         return tryRecover(hash, v, r, s);
1314     }
1315 
1316     /**
1317      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1318      *
1319      * _Available since v4.2._
1320      */
1321     function recover(
1322         bytes32 hash,
1323         bytes32 r,
1324         bytes32 vs
1325     ) internal pure returns (address) {
1326         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1327         _throwError(error);
1328         return recovered;
1329     }
1330 
1331     /**
1332      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1333      * `r` and `s` signature fields separately.
1334      *
1335      * _Available since v4.3._
1336      */
1337     function tryRecover(
1338         bytes32 hash,
1339         uint8 v,
1340         bytes32 r,
1341         bytes32 s
1342     ) internal pure returns (address, RecoverError) {
1343         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1344         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1345         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1346         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1347         //
1348         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1349         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1350         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1351         // these malleable signatures as well.
1352         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1353             return (address(0), RecoverError.InvalidSignatureS);
1354         }
1355         if (v != 27 && v != 28) {
1356             return (address(0), RecoverError.InvalidSignatureV);
1357         }
1358 
1359         // If the signature is valid (and not malleable), return the signer address
1360         address signer = ecrecover(hash, v, r, s);
1361         if (signer == address(0)) {
1362             return (address(0), RecoverError.InvalidSignature);
1363         }
1364 
1365         return (signer, RecoverError.NoError);
1366     }
1367 
1368     /**
1369      * @dev Overload of {ECDSA-recover} that receives the `v`,
1370      * `r` and `s` signature fields separately.
1371      */
1372     function recover(
1373         bytes32 hash,
1374         uint8 v,
1375         bytes32 r,
1376         bytes32 s
1377     ) internal pure returns (address) {
1378         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1379         _throwError(error);
1380         return recovered;
1381     }
1382 
1383     /**
1384      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1385      * produces hash corresponding to the one signed with the
1386      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1387      * JSON-RPC method as part of EIP-191.
1388      *
1389      * See {recover}.
1390      */
1391     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1392         // 32 is the length in bytes of hash,
1393         // enforced by the type signature above
1394         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1395     }
1396 
1397     /**
1398      * @dev Returns an Ethereum Signed Message, created from `s`. This
1399      * produces hash corresponding to the one signed with the
1400      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1401      * JSON-RPC method as part of EIP-191.
1402      *
1403      * See {recover}.
1404      */
1405     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1406         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1407     }
1408 
1409     /**
1410      * @dev Returns an Ethereum Signed Typed Data, created from a
1411      * `domainSeparator` and a `structHash`. This produces hash corresponding
1412      * to the one signed with the
1413      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1414      * JSON-RPC method as part of EIP-712.
1415      *
1416      * See {recover}.
1417      */
1418     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1419         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1420     }
1421 }
1422 
1423 // File: Holiday_8sian_CNY.sol
1424 
1425 
1426 /*
1427  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄ 
1428 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌      ▐░▌
1429 ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌     ▐░▌
1430 ▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌▐░▌    ▐░▌
1431 ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▐░▌   ▐░▌
1432  ▐░░░░░░░░░▌ ▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌
1433 ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌   ▐░▌ ▐░▌
1434 ▐░▌       ▐░▌          ▐░▌     ▐░▌     ▐░▌       ▐░▌▐░▌    ▐░▌▐░▌
1435 ▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄ ▐░▌       ▐░▌▐░▌     ▐░▐░▌
1436 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌      ▐░░▌
1437  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀        ▀▀ 
1438                         By zensein#5412 
1439 */
1440 
1441 pragma solidity ^0.8.0;
1442 
1443 
1444 
1445 
1446 
1447 contract Holiday_8sian_CNY is ERC1155Supply, Ownable {
1448     using Strings for uint256;
1449     using ECDSA for bytes32;
1450 
1451     uint256 public immutable MAX_TOKENS = 888;
1452     uint256 private _currentTokenID = 3;
1453     uint256 public MAX_PER_TX = 3;
1454     uint256 public PUBLIC_SALE_PRICE = 0.05 ether;
1455 
1456     string private constant SIG_WORD = "8SIAN_CNY";
1457     address private SIGNER_ADDRESS = 0x3f22e08Ca09BF365F9Fe3aD69fA4f213444E1062;
1458 
1459     mapping(uint32 => mapping(address => bool)) public buyersList;
1460     mapping(uint32 => uint256[]) public seasonTokens;
1461     mapping(uint256 => bool) private nonceList;
1462 
1463     uint32 public currentSeason = 1;
1464     bool public privateLive;
1465     bool public publicLive;
1466 
1467     constructor()
1468         ERC1155(
1469             "https://gateway.pinata.cloud/ipfs/QmSU8Q9avtMbqMQTQecV6QGoSTik53c3MX4U32ehq6RUk9/{id}.json"
1470         )
1471     {}
1472 
1473     function matchAddresSigner(bytes memory signature, uint256 _nonce)
1474         private
1475         view
1476         returns (bool)
1477     {
1478         bytes32 hash = keccak256(
1479             abi.encodePacked(
1480                 "\x19Ethereum Signed Message:\n32",
1481                 keccak256(abi.encodePacked(msg.sender, SIG_WORD, _nonce))
1482             )
1483         );
1484         return SIGNER_ADDRESS == hash.recover(signature);
1485     }
1486 
1487     function togglePrivateSaleStatus() external onlyOwner {
1488         privateLive = !privateLive;
1489     }
1490 
1491     function togglePublicSaleStatus() external onlyOwner {
1492         publicLive = !publicLive;
1493     }
1494 
1495     function setPrice(uint256 price) external onlyOwner {
1496         PUBLIC_SALE_PRICE = price;
1497     }
1498 
1499     function addSeasonTokens(uint256 amount, bool newSeason)
1500         external
1501         onlyOwner
1502     {
1503         if (newSeason) {
1504             currentSeason = currentSeason + 1;
1505             for (uint256 i = 0; i < amount; i++) {
1506                 seasonTokens[currentSeason].push(_currentTokenID + i);
1507             }
1508         }
1509         _currentTokenID = _currentTokenID + amount;
1510     }
1511 
1512     function changeSeason(uint32 season) external onlyOwner {
1513         currentSeason = season;
1514     }
1515 
1516     function privateMint(bytes memory signature, uint256 id) external {
1517         require(privateLive, "PRIVATE_SALE_IS_NOT_ACTIVE");
1518         require(id < _currentTokenID, "ID_DOES_NOT_EXIST");
1519         require(totalSupply(id) < MAX_TOKENS, "EXCEED_MAX_TOKENS");
1520         require(
1521             matchAddresSigner(signature, currentSeason),
1522             "DIRECT_MINT_DISALLOWED"
1523         );
1524         require(!buyersList[currentSeason][msg.sender], "ALREADY_MINTED");
1525 
1526         buyersList[currentSeason][msg.sender] = true;
1527         _mint(msg.sender, id, 1, "");
1528     }
1529 
1530     function publicMint(
1531         bytes memory signature,
1532         uint256[] calldata ids,
1533         uint256[] calldata amount,
1534         uint256 _nonce
1535     ) external payable {
1536         require(publicLive, "PUBLIC_SALE_IS_NOT_ACTIVE");
1537         require(amount.length == ids.length, "INCORRECT_LENGTH");
1538         require(!nonceList[_nonce], "ERROR_NONCE_USED");
1539         require(matchAddresSigner(signature, _nonce), "DIRECT_MINT_DISALLOWED");
1540 
1541         uint256 totalAmount;
1542         for (uint256 j = 0; j < amount.length; j++) {
1543             totalAmount = amount[j];
1544         }
1545         require(
1546             PUBLIC_SALE_PRICE * totalAmount <= msg.value,
1547             "INSUFFICIENT_ETH"
1548         );
1549         require(totalAmount <= MAX_PER_TX, "MAXIMUM_OF_3");
1550 
1551         for (uint256 i = 0; i < ids.length; i++) {
1552             require(ids[i] < _currentTokenID, "ID_DOES_NOT_EXIST");
1553             require(
1554                 totalSupply(ids[i]) + amount[i] <= MAX_TOKENS,
1555                 "EXCEED_MAX_TOKENS"
1556             );
1557             nonceList[_nonce] = true;
1558             _mint(msg.sender, ids[i], amount[i], "");
1559         }
1560     }
1561 
1562     function gift(address[] calldata receivers, uint256[] calldata ids)
1563         external
1564         onlyOwner
1565     {
1566         require(receivers.length == ids.length, "LENGTHS_DO_NOT_MATCH");
1567         for (uint256 i = 0; i < receivers.length; i++) {
1568             require(ids[i] < _currentTokenID, "ID_DOES_NOT_EXIST");
1569             require(totalSupply(ids[i]) < MAX_TOKENS, "EXCEED_MAX_TOKENS");
1570             // require(!buyersList[currentSeason][receivers[i]], "ADDRESS_MINTED");
1571             buyersList[currentSeason][receivers[i]] = true;
1572             _mint(receivers[i], ids[i], 1, "");
1573         }
1574     }
1575 
1576     function withdraw() external {
1577         uint256 currentBalance = address(this).balance;
1578         payable(0x45EB1D6283C98aCfaEbA07E5dEFe4612B0071d76).transfer(
1579             (currentBalance * 250) / 1000
1580         );
1581         payable(0xb53b491e917Eefe9c4d713870B9a08D630670245).transfer(
1582             (currentBalance * 150) / 1000
1583         );
1584         payable(0xe72441A43Ed985a9E3D43c11a7FcE93Dd282FF03).transfer(
1585             (currentBalance * 150) / 1000
1586         );
1587         payable(0x3329904219aF8Da1B86576C64b68eBe59D28c037).transfer(
1588             (currentBalance * 100) / 1000
1589         );
1590         payable(0x506046F99A9932540fa5938fa4aE3a6Ff20E1f65).transfer(
1591             (currentBalance * 100) / 1000
1592         );
1593         payable(0xf0d78074a1ED1c4CAEce0cECfE81DC9010A77FB9).transfer(
1594             (currentBalance * 100) / 1000
1595         );
1596         payable(0xE9D0BD5520af8c9ad20e12801315117dE9958149).transfer(
1597             (currentBalance * 50) / 1000
1598         );
1599         payable(0x9178bCf3A4C25B9A321EDFE7360fA587f7bD10fd).transfer(
1600             (currentBalance * 50) / 1000
1601         );
1602         payable(0xeD9C842645D9a2Bb66d4EAC77857768071384447).transfer(
1603             (currentBalance * 50) / 1000
1604         );
1605     }
1606 }