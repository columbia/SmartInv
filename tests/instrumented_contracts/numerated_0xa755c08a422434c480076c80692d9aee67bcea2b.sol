1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 // File: @openzeppelin/contracts/access/Ownable.sol
25 
26 
27 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Address.sol
103 
104 
105 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
106 
107 pragma solidity ^0.8.1;
108 
109 /**
110  * @dev Collection of functions related to the address type
111  */
112 library Address {
113     /**
114      * @dev Returns true if `account` is a contract.
115      *
116      * [IMPORTANT]
117      * ====
118      * It is unsafe to assume that an address for which this function returns
119      * false is an externally-owned account (EOA) and not a contract.
120      *
121      * Among others, `isContract` will return false for the following
122      * types of addresses:
123      *
124      *  - an externally-owned account
125      *  - a contract in construction
126      *  - an address where a contract will be created
127      *  - an address where a contract lived, but was destroyed
128      * ====
129      *
130      * [IMPORTANT]
131      * ====
132      * You shouldn't rely on `isContract` to protect against flash loan attacks!
133      *
134      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
135      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
136      * constructor.
137      * ====
138      */
139     function isContract(address account) internal view returns (bool) {
140         // This method relies on extcodesize/address.code.length, which returns 0
141         // for contracts in construction, since the code is only stored at the end
142         // of the constructor execution.
143 
144         return account.code.length > 0;
145     }
146 
147     /**
148      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
149      * `recipient`, forwarding all available gas and reverting on errors.
150      *
151      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
152      * of certain opcodes, possibly making contracts go over the 2300 gas limit
153      * imposed by `transfer`, making them unable to receive funds via
154      * `transfer`. {sendValue} removes this limitation.
155      *
156      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
157      *
158      * IMPORTANT: because control is transferred to `recipient`, care must be
159      * taken to not create reentrancy vulnerabilities. Consider using
160      * {ReentrancyGuard} or the
161      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
162      */
163     function sendValue(address payable recipient, uint256 amount) internal {
164         require(address(this).balance >= amount, "Address: insufficient balance");
165 
166         (bool success, ) = recipient.call{value: amount}("");
167         require(success, "Address: unable to send value, recipient may have reverted");
168     }
169 
170     /**
171      * @dev Performs a Solidity function call using a low level `call`. A
172      * plain `call` is an unsafe replacement for a function call: use this
173      * function instead.
174      *
175      * If `target` reverts with a revert reason, it is bubbled up by this
176      * function (like regular Solidity function calls).
177      *
178      * Returns the raw returned data. To convert to the expected return value,
179      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
180      *
181      * Requirements:
182      *
183      * - `target` must be a contract.
184      * - calling `target` with `data` must not revert.
185      *
186      * _Available since v3.1._
187      */
188     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
189         return functionCall(target, data, "Address: low-level call failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
194      * `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCall(
199         address target,
200         bytes memory data,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         return functionCallWithValue(target, data, 0, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but also transferring `value` wei to `target`.
209      *
210      * Requirements:
211      *
212      * - the calling contract must have an ETH balance of at least `value`.
213      * - the called Solidity function must be `payable`.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value
221     ) internal returns (bytes memory) {
222         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
227      * with `errorMessage` as a fallback revert reason when `target` reverts.
228      *
229      * _Available since v3.1._
230      */
231     function functionCallWithValue(
232         address target,
233         bytes memory data,
234         uint256 value,
235         string memory errorMessage
236     ) internal returns (bytes memory) {
237         require(address(this).balance >= value, "Address: insufficient balance for call");
238         require(isContract(target), "Address: call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.call{value: value}(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but performing a static call.
247      *
248      * _Available since v3.3._
249      */
250     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
251         return functionStaticCall(target, data, "Address: low-level static call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
256      * but performing a static call.
257      *
258      * _Available since v3.3._
259      */
260     function functionStaticCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal view returns (bytes memory) {
265         require(isContract(target), "Address: static call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.staticcall(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but performing a delegate call.
274      *
275      * _Available since v3.4._
276      */
277     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
278         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
283      * but performing a delegate call.
284      *
285      * _Available since v3.4._
286      */
287     function functionDelegateCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         require(isContract(target), "Address: delegate call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.delegatecall(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
300      * revert reason using the provided one.
301      *
302      * _Available since v4.3._
303      */
304     function verifyCallResult(
305         bool success,
306         bytes memory returndata,
307         string memory errorMessage
308     ) internal pure returns (bytes memory) {
309         if (success) {
310             return returndata;
311         } else {
312             // Look for revert reason and bubble it up if present
313             if (returndata.length > 0) {
314                 // The easiest way to bubble the revert reason is using memory via assembly
315 
316                 assembly {
317                     let returndata_size := mload(returndata)
318                     revert(add(32, returndata), returndata_size)
319                 }
320             } else {
321                 revert(errorMessage);
322             }
323         }
324     }
325 }
326 
327 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Interface of the ERC165 standard, as defined in the
336  * https://eips.ethereum.org/EIPS/eip-165[EIP].
337  *
338  * Implementers can declare support of contract interfaces, which can then be
339  * queried by others ({ERC165Checker}).
340  *
341  * For an implementation, see {ERC165}.
342  */
343 interface IERC165 {
344     /**
345      * @dev Returns true if this contract implements the interface defined by
346      * `interfaceId`. See the corresponding
347      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
348      * to learn more about how these ids are created.
349      *
350      * This function call must use less than 30 000 gas.
351      */
352     function supportsInterface(bytes4 interfaceId) external view returns (bool);
353 }
354 
355 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 
363 /**
364  * @dev Implementation of the {IERC165} interface.
365  *
366  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
367  * for the additional interface id that will be supported. For example:
368  *
369  * ```solidity
370  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
371  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
372  * }
373  * ```
374  *
375  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
376  */
377 abstract contract ERC165 is IERC165 {
378     /**
379      * @dev See {IERC165-supportsInterface}.
380      */
381     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
382         return interfaceId == type(IERC165).interfaceId;
383     }
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
387 
388 
389 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev _Available since v3.1._
396  */
397 interface IERC1155Receiver is IERC165 {
398     /**
399      * @dev Handles the receipt of a single ERC1155 token type. This function is
400      * called at the end of a `safeTransferFrom` after the balance has been updated.
401      *
402      * NOTE: To accept the transfer, this must return
403      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
404      * (i.e. 0xf23a6e61, or its own function selector).
405      *
406      * @param operator The address which initiated the transfer (i.e. msg.sender)
407      * @param from The address which previously owned the token
408      * @param id The ID of the token being transferred
409      * @param value The amount of tokens being transferred
410      * @param data Additional data with no specified format
411      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
412      */
413     function onERC1155Received(
414         address operator,
415         address from,
416         uint256 id,
417         uint256 value,
418         bytes calldata data
419     ) external returns (bytes4);
420 
421     /**
422      * @dev Handles the receipt of a multiple ERC1155 token types. This function
423      * is called at the end of a `safeBatchTransferFrom` after the balances have
424      * been updated.
425      *
426      * NOTE: To accept the transfer(s), this must return
427      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
428      * (i.e. 0xbc197c81, or its own function selector).
429      *
430      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
431      * @param from The address which previously owned the token
432      * @param ids An array containing ids of each token being transferred (order and length must match values array)
433      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
434      * @param data Additional data with no specified format
435      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
436      */
437     function onERC1155BatchReceived(
438         address operator,
439         address from,
440         uint256[] calldata ids,
441         uint256[] calldata values,
442         bytes calldata data
443     ) external returns (bytes4);
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev Required interface of an ERC1155 compliant contract, as defined in the
456  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
457  *
458  * _Available since v3.1._
459  */
460 interface IERC1155 is IERC165 {
461     /**
462      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
463      */
464     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
465 
466     /**
467      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
468      * transfers.
469      */
470     event TransferBatch(
471         address indexed operator,
472         address indexed from,
473         address indexed to,
474         uint256[] ids,
475         uint256[] values
476     );
477 
478     /**
479      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
480      * `approved`.
481      */
482     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
483 
484     /**
485      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
486      *
487      * If an {URI} event was emitted for `id`, the standard
488      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
489      * returned by {IERC1155MetadataURI-uri}.
490      */
491     event URI(string value, uint256 indexed id);
492 
493     /**
494      * @dev Returns the amount of tokens of token type `id` owned by `account`.
495      *
496      * Requirements:
497      *
498      * - `account` cannot be the zero address.
499      */
500     function balanceOf(address account, uint256 id) external view returns (uint256);
501 
502     /**
503      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
504      *
505      * Requirements:
506      *
507      * - `accounts` and `ids` must have the same length.
508      */
509     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
510         external
511         view
512         returns (uint256[] memory);
513 
514     /**
515      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
516      *
517      * Emits an {ApprovalForAll} event.
518      *
519      * Requirements:
520      *
521      * - `operator` cannot be the caller.
522      */
523     function setApprovalForAll(address operator, bool approved) external;
524 
525     /**
526      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
527      *
528      * See {setApprovalForAll}.
529      */
530     function isApprovedForAll(address account, address operator) external view returns (bool);
531 
532     /**
533      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
534      *
535      * Emits a {TransferSingle} event.
536      *
537      * Requirements:
538      *
539      * - `to` cannot be the zero address.
540      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
541      * - `from` must have a balance of tokens of type `id` of at least `amount`.
542      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
543      * acceptance magic value.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 id,
549         uint256 amount,
550         bytes calldata data
551     ) external;
552 
553     /**
554      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
555      *
556      * Emits a {TransferBatch} event.
557      *
558      * Requirements:
559      *
560      * - `ids` and `amounts` must have the same length.
561      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
562      * acceptance magic value.
563      */
564     function safeBatchTransferFrom(
565         address from,
566         address to,
567         uint256[] calldata ids,
568         uint256[] calldata amounts,
569         bytes calldata data
570     ) external;
571 }
572 
573 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 
581 /**
582  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
583  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
584  *
585  * _Available since v3.1._
586  */
587 interface IERC1155MetadataURI is IERC1155 {
588     /**
589      * @dev Returns the URI for token type `id`.
590      *
591      * If the `\{id\}` substring is present in the URI, it must be replaced by
592      * clients with the actual token type ID.
593      */
594     function uri(uint256 id) external view returns (string memory);
595 }
596 
597 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
598 
599 
600 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 
605 
606 
607 
608 
609 
610 /**
611  * @dev Implementation of the basic standard multi-token.
612  * See https://eips.ethereum.org/EIPS/eip-1155
613  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
614  *
615  * _Available since v3.1._
616  */
617 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
618     using Address for address;
619 
620     // Mapping from token ID to account balances
621     mapping(uint256 => mapping(address => uint256)) private _balances;
622 
623     // Mapping from account to operator approvals
624     mapping(address => mapping(address => bool)) private _operatorApprovals;
625 
626     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
627     string private _uri;
628 
629     /**
630      * @dev See {_setURI}.
631      */
632     constructor(string memory uri_) {
633         _setURI(uri_);
634     }
635 
636     /**
637      * @dev See {IERC165-supportsInterface}.
638      */
639     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
640         return
641             interfaceId == type(IERC1155).interfaceId ||
642             interfaceId == type(IERC1155MetadataURI).interfaceId ||
643             super.supportsInterface(interfaceId);
644     }
645 
646     /**
647      * @dev See {IERC1155MetadataURI-uri}.
648      *
649      * This implementation returns the same URI for *all* token types. It relies
650      * on the token type ID substitution mechanism
651      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
652      *
653      * Clients calling this function must replace the `\{id\}` substring with the
654      * actual token type ID.
655      */
656     function uri(uint256) public view virtual override returns (string memory) {
657         return _uri;
658     }
659 
660     /**
661      * @dev See {IERC1155-balanceOf}.
662      *
663      * Requirements:
664      *
665      * - `account` cannot be the zero address.
666      */
667     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
668         require(account != address(0), "ERC1155: balance query for the zero address");
669         return _balances[id][account];
670     }
671 
672     /**
673      * @dev See {IERC1155-balanceOfBatch}.
674      *
675      * Requirements:
676      *
677      * - `accounts` and `ids` must have the same length.
678      */
679     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
680         public
681         view
682         virtual
683         override
684         returns (uint256[] memory)
685     {
686         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
687 
688         uint256[] memory batchBalances = new uint256[](accounts.length);
689 
690         for (uint256 i = 0; i < accounts.length; ++i) {
691             batchBalances[i] = balanceOf(accounts[i], ids[i]);
692         }
693 
694         return batchBalances;
695     }
696 
697     /**
698      * @dev See {IERC1155-setApprovalForAll}.
699      */
700     function setApprovalForAll(address operator, bool approved) public virtual override {
701         _setApprovalForAll(_msgSender(), operator, approved);
702     }
703 
704     /**
705      * @dev See {IERC1155-isApprovedForAll}.
706      */
707     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
708         return _operatorApprovals[account][operator];
709     }
710 
711     /**
712      * @dev See {IERC1155-safeTransferFrom}.
713      */
714     function safeTransferFrom(
715         address from,
716         address to,
717         uint256 id,
718         uint256 amount,
719         bytes memory data
720     ) public virtual override {
721         require(
722             from == _msgSender() || isApprovedForAll(from, _msgSender()),
723             "ERC1155: caller is not owner nor approved"
724         );
725         _safeTransferFrom(from, to, id, amount, data);
726     }
727 
728     /**
729      * @dev See {IERC1155-safeBatchTransferFrom}.
730      */
731     function safeBatchTransferFrom(
732         address from,
733         address to,
734         uint256[] memory ids,
735         uint256[] memory amounts,
736         bytes memory data
737     ) public virtual override {
738         require(
739             from == _msgSender() || isApprovedForAll(from, _msgSender()),
740             "ERC1155: transfer caller is not owner nor approved"
741         );
742         _safeBatchTransferFrom(from, to, ids, amounts, data);
743     }
744 
745     /**
746      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
747      *
748      * Emits a {TransferSingle} event.
749      *
750      * Requirements:
751      *
752      * - `to` cannot be the zero address.
753      * - `from` must have a balance of tokens of type `id` of at least `amount`.
754      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
755      * acceptance magic value.
756      */
757     function _safeTransferFrom(
758         address from,
759         address to,
760         uint256 id,
761         uint256 amount,
762         bytes memory data
763     ) internal virtual {
764         require(to != address(0), "ERC1155: transfer to the zero address");
765 
766         address operator = _msgSender();
767         uint256[] memory ids = _asSingletonArray(id);
768         uint256[] memory amounts = _asSingletonArray(amount);
769 
770         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
771 
772         uint256 fromBalance = _balances[id][from];
773         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
774         unchecked {
775             _balances[id][from] = fromBalance - amount;
776         }
777         _balances[id][to] += amount;
778 
779         emit TransferSingle(operator, from, to, id, amount);
780 
781         _afterTokenTransfer(operator, from, to, ids, amounts, data);
782 
783         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
784     }
785 
786     /**
787      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
788      *
789      * Emits a {TransferBatch} event.
790      *
791      * Requirements:
792      *
793      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
794      * acceptance magic value.
795      */
796     function _safeBatchTransferFrom(
797         address from,
798         address to,
799         uint256[] memory ids,
800         uint256[] memory amounts,
801         bytes memory data
802     ) internal virtual {
803         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
804         require(to != address(0), "ERC1155: transfer to the zero address");
805 
806         address operator = _msgSender();
807 
808         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
809 
810         for (uint256 i = 0; i < ids.length; ++i) {
811             uint256 id = ids[i];
812             uint256 amount = amounts[i];
813 
814             uint256 fromBalance = _balances[id][from];
815             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
816             unchecked {
817                 _balances[id][from] = fromBalance - amount;
818             }
819             _balances[id][to] += amount;
820         }
821 
822         emit TransferBatch(operator, from, to, ids, amounts);
823 
824         _afterTokenTransfer(operator, from, to, ids, amounts, data);
825 
826         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
827     }
828 
829     /**
830      * @dev Sets a new URI for all token types, by relying on the token type ID
831      * substitution mechanism
832      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
833      *
834      * By this mechanism, any occurrence of the `\{id\}` substring in either the
835      * URI or any of the amounts in the JSON file at said URI will be replaced by
836      * clients with the token type ID.
837      *
838      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
839      * interpreted by clients as
840      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
841      * for token type ID 0x4cce0.
842      *
843      * See {uri}.
844      *
845      * Because these URIs cannot be meaningfully represented by the {URI} event,
846      * this function emits no events.
847      */
848     function _setURI(string memory newuri) internal virtual {
849         _uri = newuri;
850     }
851 
852     /**
853      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
854      *
855      * Emits a {TransferSingle} event.
856      *
857      * Requirements:
858      *
859      * - `to` cannot be the zero address.
860      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
861      * acceptance magic value.
862      */
863     function _mint(
864         address to,
865         uint256 id,
866         uint256 amount,
867         bytes memory data
868     ) internal virtual {
869         require(to != address(0), "ERC1155: mint to the zero address");
870 
871         address operator = _msgSender();
872         uint256[] memory ids = _asSingletonArray(id);
873         uint256[] memory amounts = _asSingletonArray(amount);
874 
875         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
876 
877         _balances[id][to] += amount;
878         emit TransferSingle(operator, address(0), to, id, amount);
879 
880         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
881 
882         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
883     }
884 
885     /**
886      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
887      *
888      * Requirements:
889      *
890      * - `ids` and `amounts` must have the same length.
891      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
892      * acceptance magic value.
893      */
894     function _mintBatch(
895         address to,
896         uint256[] memory ids,
897         uint256[] memory amounts,
898         bytes memory data
899     ) internal virtual {
900         require(to != address(0), "ERC1155: mint to the zero address");
901         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
902 
903         address operator = _msgSender();
904 
905         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
906 
907         for (uint256 i = 0; i < ids.length; i++) {
908             _balances[ids[i]][to] += amounts[i];
909         }
910 
911         emit TransferBatch(operator, address(0), to, ids, amounts);
912 
913         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
914 
915         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
916     }
917 
918     /**
919      * @dev Destroys `amount` tokens of token type `id` from `from`
920      *
921      * Requirements:
922      *
923      * - `from` cannot be the zero address.
924      * - `from` must have at least `amount` tokens of token type `id`.
925      */
926     function _burn(
927         address from,
928         uint256 id,
929         uint256 amount
930     ) internal virtual {
931         require(from != address(0), "ERC1155: burn from the zero address");
932 
933         address operator = _msgSender();
934         uint256[] memory ids = _asSingletonArray(id);
935         uint256[] memory amounts = _asSingletonArray(amount);
936 
937         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
938 
939         uint256 fromBalance = _balances[id][from];
940         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
941         unchecked {
942             _balances[id][from] = fromBalance - amount;
943         }
944 
945         emit TransferSingle(operator, from, address(0), id, amount);
946 
947         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
948     }
949 
950     /**
951      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
952      *
953      * Requirements:
954      *
955      * - `ids` and `amounts` must have the same length.
956      */
957     function _burnBatch(
958         address from,
959         uint256[] memory ids,
960         uint256[] memory amounts
961     ) internal virtual {
962         require(from != address(0), "ERC1155: burn from the zero address");
963         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
964 
965         address operator = _msgSender();
966 
967         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
968 
969         for (uint256 i = 0; i < ids.length; i++) {
970             uint256 id = ids[i];
971             uint256 amount = amounts[i];
972 
973             uint256 fromBalance = _balances[id][from];
974             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
975             unchecked {
976                 _balances[id][from] = fromBalance - amount;
977             }
978         }
979 
980         emit TransferBatch(operator, from, address(0), ids, amounts);
981 
982         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
983     }
984 
985     /**
986      * @dev Approve `operator` to operate on all of `owner` tokens
987      *
988      * Emits a {ApprovalForAll} event.
989      */
990     function _setApprovalForAll(
991         address owner,
992         address operator,
993         bool approved
994     ) internal virtual {
995         require(owner != operator, "ERC1155: setting approval status for self");
996         _operatorApprovals[owner][operator] = approved;
997         emit ApprovalForAll(owner, operator, approved);
998     }
999 
1000     /**
1001      * @dev Hook that is called before any token transfer. This includes minting
1002      * and burning, as well as batched variants.
1003      *
1004      * The same hook is called on both single and batched variants. For single
1005      * transfers, the length of the `id` and `amount` arrays will be 1.
1006      *
1007      * Calling conditions (for each `id` and `amount` pair):
1008      *
1009      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1010      * of token type `id` will be  transferred to `to`.
1011      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1012      * for `to`.
1013      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1014      * will be burned.
1015      * - `from` and `to` are never both zero.
1016      * - `ids` and `amounts` have the same, non-zero length.
1017      *
1018      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1019      */
1020     function _beforeTokenTransfer(
1021         address operator,
1022         address from,
1023         address to,
1024         uint256[] memory ids,
1025         uint256[] memory amounts,
1026         bytes memory data
1027     ) internal virtual {}
1028 
1029     /**
1030      * @dev Hook that is called after any token transfer. This includes minting
1031      * and burning, as well as batched variants.
1032      *
1033      * The same hook is called on both single and batched variants. For single
1034      * transfers, the length of the `id` and `amount` arrays will be 1.
1035      *
1036      * Calling conditions (for each `id` and `amount` pair):
1037      *
1038      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1039      * of token type `id` will be  transferred to `to`.
1040      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1041      * for `to`.
1042      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1043      * will be burned.
1044      * - `from` and `to` are never both zero.
1045      * - `ids` and `amounts` have the same, non-zero length.
1046      *
1047      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1048      */
1049     function _afterTokenTransfer(
1050         address operator,
1051         address from,
1052         address to,
1053         uint256[] memory ids,
1054         uint256[] memory amounts,
1055         bytes memory data
1056     ) internal virtual {}
1057 
1058     function _doSafeTransferAcceptanceCheck(
1059         address operator,
1060         address from,
1061         address to,
1062         uint256 id,
1063         uint256 amount,
1064         bytes memory data
1065     ) private {
1066         if (to.isContract()) {
1067             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1068                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1069                     revert("ERC1155: ERC1155Receiver rejected tokens");
1070                 }
1071             } catch Error(string memory reason) {
1072                 revert(reason);
1073             } catch {
1074                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1075             }
1076         }
1077     }
1078 
1079     function _doSafeBatchTransferAcceptanceCheck(
1080         address operator,
1081         address from,
1082         address to,
1083         uint256[] memory ids,
1084         uint256[] memory amounts,
1085         bytes memory data
1086     ) private {
1087         if (to.isContract()) {
1088             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1089                 bytes4 response
1090             ) {
1091                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1092                     revert("ERC1155: ERC1155Receiver rejected tokens");
1093                 }
1094             } catch Error(string memory reason) {
1095                 revert(reason);
1096             } catch {
1097                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1098             }
1099         }
1100     }
1101 
1102     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1103         uint256[] memory array = new uint256[](1);
1104         array[0] = element;
1105 
1106         return array;
1107     }
1108 }
1109 
1110 // File: contracts/1155.sol
1111 
1112 
1113 pragma solidity ^0.8.4;
1114 
1115 
1116 
1117 contract MysteryStorage is ERC1155, Ownable {
1118     string public name = "Mystery Storage";
1119 
1120     constructor() ERC1155("https://cdn.monstercave.wtf/meta/e38dadc68ea9e8e1d9511b12317bc5b/json/{id}.json") {}
1121 
1122     function setURI(string memory newuri) public onlyOwner {
1123         _setURI(newuri);
1124     }
1125 
1126     function mint(address account, uint256 id, uint256 amount, bytes memory data)
1127         public
1128         onlyOwner
1129     {
1130         _mint(account, id, amount, data);
1131     }
1132 
1133     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1134         public
1135         onlyOwner
1136     {
1137         _mintBatch(to, ids, amounts, data);
1138     }
1139 }