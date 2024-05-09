1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
3 
4 // File: @openzeppelin/contracts/utils/Context.sol
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _setOwner(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _setOwner(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _setOwner(newOwner);
85     }
86 
87     function _setOwner(address newOwner) private {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 // File: @openzeppelin/contracts/utils/Address.sol
95 
96 /**
97  * @dev Collection of functions related to the address type
98  */
99 library Address {
100     /**
101      * @dev Returns true if `account` is a contract.
102      *
103      * [IMPORTANT]
104      * ====
105      * It is unsafe to assume that an address for which this function returns
106      * false is an externally-owned account (EOA) and not a contract.
107      *
108      * Among others, `isContract` will return false for the following
109      * types of addresses:
110      *
111      *  - an externally-owned account
112      *  - a contract in construction
113      *  - an address where a contract will be created
114      *  - an address where a contract lived, but was destroyed
115      * ====
116      */
117     function isContract(address account) internal view returns (bool) {
118         // This method relies on extcodesize, which returns 0 for contracts in
119         // construction, since the code is only stored at the end of the
120         // constructor execution.
121 
122         uint256 size;
123         assembly {
124             size := extcodesize(account)
125         }
126         return size > 0;
127     }
128 
129     /**
130      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
131      * `recipient`, forwarding all available gas and reverting on errors.
132      *
133      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
134      * of certain opcodes, possibly making contracts go over the 2300 gas limit
135      * imposed by `transfer`, making them unable to receive funds via
136      * `transfer`. {sendValue} removes this limitation.
137      *
138      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
139      *
140      * IMPORTANT: because control is transferred to `recipient`, care must be
141      * taken to not create reentrancy vulnerabilities. Consider using
142      * {ReentrancyGuard} or the
143      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
144      */
145     function sendValue(address payable recipient, uint256 amount) internal {
146         require(address(this).balance >= amount, "Address: insufficient balance");
147 
148         (bool success, ) = recipient.call{value: amount}("");
149         require(success, "Address: unable to send value, recipient may have reverted");
150     }
151 
152     /**
153      * @dev Performs a Solidity function call using a low level `call`. A
154      * plain `call` is an unsafe replacement for a function call: use this
155      * function instead.
156      *
157      * If `target` reverts with a revert reason, it is bubbled up by this
158      * function (like regular Solidity function calls).
159      *
160      * Returns the raw returned data. To convert to the expected return value,
161      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
162      *
163      * Requirements:
164      *
165      * - `target` must be a contract.
166      * - calling `target` with `data` must not revert.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
171         return functionCall(target, data, "Address: low-level call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
176      * `errorMessage` as a fallback revert reason when `target` reverts.
177      *
178      * _Available since v3.1._
179      */
180     function functionCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, 0, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
190      * but also transferring `value` wei to `target`.
191      *
192      * Requirements:
193      *
194      * - the calling contract must have an ETH balance of at least `value`.
195      * - the called Solidity function must be `payable`.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
209      * with `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         require(address(this).balance >= value, "Address: insufficient balance for call");
220         require(isContract(target), "Address: call to non-contract");
221 
222         (bool success, bytes memory returndata) = target.call{value: value}(data);
223         return verifyCallResult(success, returndata, errorMessage);
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
228      * but performing a static call.
229      *
230      * _Available since v3.3._
231      */
232     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
233         return functionStaticCall(target, data, "Address: low-level static call failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
238      * but performing a static call.
239      *
240      * _Available since v3.3._
241      */
242     function functionStaticCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal view returns (bytes memory) {
247         require(isContract(target), "Address: static call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.staticcall(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but performing a delegate call.
256      *
257      * _Available since v3.4._
258      */
259     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
260         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
265      * but performing a delegate call.
266      *
267      * _Available since v3.4._
268      */
269     function functionDelegateCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         require(isContract(target), "Address: delegate call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.delegatecall(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
282      * revert reason using the provided one.
283      *
284      * _Available since v4.3._
285      */
286     function verifyCallResult(
287         bool success,
288         bytes memory returndata,
289         string memory errorMessage
290     ) internal pure returns (bytes memory) {
291         if (success) {
292             return returndata;
293         } else {
294             // Look for revert reason and bubble it up if present
295             if (returndata.length > 0) {
296                 // The easiest way to bubble the revert reason is using memory via assembly
297 
298                 assembly {
299                     let returndata_size := mload(returndata)
300                     revert(add(32, returndata), returndata_size)
301                 }
302             } else {
303                 revert(errorMessage);
304             }
305         }
306     }
307 }
308 
309 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
310 
311 /**
312  * @dev Interface of the ERC165 standard, as defined in the
313  * https://eips.ethereum.org/EIPS/eip-165[EIP].
314  *
315  * Implementers can declare support of contract interfaces, which can then be
316  * queried by others ({ERC165Checker}).
317  *
318  * For an implementation, see {ERC165}.
319  */
320 interface IERC165 {
321     /**
322      * @dev Returns true if this contract implements the interface defined by
323      * `interfaceId`. See the corresponding
324      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
325      * to learn more about how these ids are created.
326      *
327      * This function call must use less than 30 000 gas.
328      */
329     function supportsInterface(bytes4 interfaceId) external view returns (bool);
330 }
331 
332 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
333 
334 
335 /**
336  * @dev Implementation of the {IERC165} interface.
337  *
338  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
339  * for the additional interface id that will be supported. For example:
340  *
341  * ```solidity
342  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
343  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
344  * }
345  * ```
346  *
347  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
348  */
349 abstract contract ERC165 is IERC165 {
350     /**
351      * @dev See {IERC165-supportsInterface}.
352      */
353     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
354         return interfaceId == type(IERC165).interfaceId;
355     }
356 }
357 
358 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
359 
360 /**
361  * @dev _Available since v3.1._
362  */
363 interface IERC1155Receiver is IERC165 {
364     /**
365         @dev Handles the receipt of a single ERC1155 token type. This function is
366         called at the end of a `safeTransferFrom` after the balance has been updated.
367         To accept the transfer, this must return
368         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
369         (i.e. 0xf23a6e61, or its own function selector).
370         @param operator The address which initiated the transfer (i.e. msg.sender)
371         @param from The address which previously owned the token
372         @param id The ID of the token being transferred
373         @param value The amount of tokens being transferred
374         @param data Additional data with no specified format
375         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
376     */
377     function onERC1155Received(
378         address operator,
379         address from,
380         uint256 id,
381         uint256 value,
382         bytes calldata data
383     ) external returns (bytes4);
384 
385     /**
386         @dev Handles the receipt of a multiple ERC1155 token types. This function
387         is called at the end of a `safeBatchTransferFrom` after the balances have
388         been updated. To accept the transfer(s), this must return
389         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
390         (i.e. 0xbc197c81, or its own function selector).
391         @param operator The address which initiated the batch transfer (i.e. msg.sender)
392         @param from The address which previously owned the token
393         @param ids An array containing ids of each token being transferred (order and length must match values array)
394         @param values An array containing amounts of each token being transferred (order and length must match ids array)
395         @param data Additional data with no specified format
396         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
397     */
398     function onERC1155BatchReceived(
399         address operator,
400         address from,
401         uint256[] calldata ids,
402         uint256[] calldata values,
403         bytes calldata data
404     ) external returns (bytes4);
405 }
406 
407 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
408 
409 /**
410  * @dev Required interface of an ERC1155 compliant contract, as defined in the
411  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
412  *
413  * _Available since v3.1._
414  */
415 interface IERC1155 is IERC165 {
416     /**
417      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
418      */
419     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
420 
421     /**
422      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
423      * transfers.
424      */
425     event TransferBatch(
426         address indexed operator,
427         address indexed from,
428         address indexed to,
429         uint256[] ids,
430         uint256[] values
431     );
432 
433     /**
434      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
435      * `approved`.
436      */
437     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
438 
439     /**
440      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
441      *
442      * If an {URI} event was emitted for `id`, the standard
443      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
444      * returned by {IERC1155MetadataURI-uri}.
445      */
446     event URI(string value, uint256 indexed id);
447 
448     /**
449      * @dev Returns the amount of tokens of token type `id` owned by `account`.
450      *
451      * Requirements:
452      *
453      * - `account` cannot be the zero address.
454      */
455     function balanceOf(address account, uint256 id) external view returns (uint256);
456 
457     /**
458      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
459      *
460      * Requirements:
461      *
462      * - `accounts` and `ids` must have the same length.
463      */
464     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
465         external
466         view
467         returns (uint256[] memory);
468 
469     /**
470      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
471      *
472      * Emits an {ApprovalForAll} event.
473      *
474      * Requirements:
475      *
476      * - `operator` cannot be the caller.
477      */
478     function setApprovalForAll(address operator, bool approved) external;
479 
480     /**
481      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
482      *
483      * See {setApprovalForAll}.
484      */
485     function isApprovedForAll(address account, address operator) external view returns (bool);
486 
487     /**
488      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
489      *
490      * Emits a {TransferSingle} event.
491      *
492      * Requirements:
493      *
494      * - `to` cannot be the zero address.
495      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
496      * - `from` must have a balance of tokens of type `id` of at least `amount`.
497      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
498      * acceptance magic value.
499      */
500     function safeTransferFrom(
501         address from,
502         address to,
503         uint256 id,
504         uint256 amount,
505         bytes calldata data
506     ) external;
507 
508     /**
509      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
510      *
511      * Emits a {TransferBatch} event.
512      *
513      * Requirements:
514      *
515      * - `ids` and `amounts` must have the same length.
516      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
517      * acceptance magic value.
518      */
519     function safeBatchTransferFrom(
520         address from,
521         address to,
522         uint256[] calldata ids,
523         uint256[] calldata amounts,
524         bytes calldata data
525     ) external;
526 }
527 
528 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
529 
530 /**
531  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
532  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
533  *
534  * _Available since v3.1._
535  */
536 interface IERC1155MetadataURI is IERC1155 {
537     /**
538      * @dev Returns the URI for token type `id`.
539      *
540      * If the `\{id\}` substring is present in the URI, it must be replaced by
541      * clients with the actual token type ID.
542      */
543     function uri(uint256 id) external view returns (string memory);
544 }
545 
546 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
547 
548 /**
549  * @dev Implementation of the basic standard multi-token.
550  * See https://eips.ethereum.org/EIPS/eip-1155
551  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
552  *
553  * _Available since v3.1._
554  */
555 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
556     using Address for address;
557 
558     // Mapping from token ID to account balances
559     mapping(uint256 => mapping(address => uint256)) private _balances;
560 
561     // Mapping from account to operator approvals
562     mapping(address => mapping(address => bool)) private _operatorApprovals;
563 
564     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
565     string private _uri;
566 
567     /**
568      * @dev See {_setURI}.
569      */
570     constructor(string memory uri_) {
571         _setURI(uri_);
572     }
573 
574     /**
575      * @dev See {IERC165-supportsInterface}.
576      */
577     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
578         return
579             interfaceId == type(IERC1155).interfaceId ||
580             interfaceId == type(IERC1155MetadataURI).interfaceId ||
581             super.supportsInterface(interfaceId);
582     }
583 
584     /**
585      * @dev See {IERC1155MetadataURI-uri}.
586      *
587      * This implementation returns the same URI for *all* token types. It relies
588      * on the token type ID substitution mechanism
589      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
590      *
591      * Clients calling this function must replace the `\{id\}` substring with the
592      * actual token type ID.
593      */
594     function uri(uint256) public view virtual override returns (string memory) {
595         return _uri;
596     }
597 
598     /**
599      * @dev See {IERC1155-balanceOf}.
600      *
601      * Requirements:
602      *
603      * - `account` cannot be the zero address.
604      */
605     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
606         require(account != address(0), "ERC1155: balance query for the zero address");
607         return _balances[id][account];
608     }
609 
610     /**
611      * @dev See {IERC1155-balanceOfBatch}.
612      *
613      * Requirements:
614      *
615      * - `accounts` and `ids` must have the same length.
616      */
617     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
618         public
619         view
620         virtual
621         override
622         returns (uint256[] memory)
623     {
624         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
625 
626         uint256[] memory batchBalances = new uint256[](accounts.length);
627 
628         for (uint256 i = 0; i < accounts.length; ++i) {
629             batchBalances[i] = balanceOf(accounts[i], ids[i]);
630         }
631 
632         return batchBalances;
633     }
634 
635     /**
636      * @dev See {IERC1155-setApprovalForAll}.
637      */
638     function setApprovalForAll(address operator, bool approved) public virtual override {
639         require(_msgSender() != operator, "ERC1155: setting approval status for self");
640 
641         _operatorApprovals[_msgSender()][operator] = approved;
642         emit ApprovalForAll(_msgSender(), operator, approved);
643     }
644 
645     /**
646      * @dev See {IERC1155-isApprovedForAll}.
647      */
648     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
649         return _operatorApprovals[account][operator];
650     }
651 
652     /**
653      * @dev See {IERC1155-safeTransferFrom}.
654      */
655     function safeTransferFrom(
656         address from,
657         address to,
658         uint256 id,
659         uint256 amount,
660         bytes memory data
661     ) public virtual override {
662         require(
663             from == _msgSender() || isApprovedForAll(from, _msgSender()),
664             "ERC1155: caller is not owner nor approved"
665         );
666         _safeTransferFrom(from, to, id, amount, data);
667     }
668 
669     /**
670      * @dev See {IERC1155-safeBatchTransferFrom}.
671      */
672     function safeBatchTransferFrom(
673         address from,
674         address to,
675         uint256[] memory ids,
676         uint256[] memory amounts,
677         bytes memory data
678     ) public virtual override {
679         require(
680             from == _msgSender() || isApprovedForAll(from, _msgSender()),
681             "ERC1155: transfer caller is not owner nor approved"
682         );
683         _safeBatchTransferFrom(from, to, ids, amounts, data);
684     }
685 
686     /**
687      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
688      *
689      * Emits a {TransferSingle} event.
690      *
691      * Requirements:
692      *
693      * - `to` cannot be the zero address.
694      * - `from` must have a balance of tokens of type `id` of at least `amount`.
695      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
696      * acceptance magic value.
697      */
698     function _safeTransferFrom(
699         address from,
700         address to,
701         uint256 id,
702         uint256 amount,
703         bytes memory data
704     ) internal virtual {
705         require(to != address(0), "ERC1155: transfer to the zero address");
706 
707         address operator = _msgSender();
708 
709         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
710 
711         uint256 fromBalance = _balances[id][from];
712         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
713         unchecked {
714             _balances[id][from] = fromBalance - amount;
715         }
716         _balances[id][to] += amount;
717 
718         emit TransferSingle(operator, from, to, id, amount);
719 
720         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
721     }
722 
723     /**
724      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
725      *
726      * Emits a {TransferBatch} event.
727      *
728      * Requirements:
729      *
730      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
731      * acceptance magic value.
732      */
733     function _safeBatchTransferFrom(
734         address from,
735         address to,
736         uint256[] memory ids,
737         uint256[] memory amounts,
738         bytes memory data
739     ) internal virtual {
740         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
741         require(to != address(0), "ERC1155: transfer to the zero address");
742 
743         address operator = _msgSender();
744 
745         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
746 
747         for (uint256 i = 0; i < ids.length; ++i) {
748             uint256 id = ids[i];
749             uint256 amount = amounts[i];
750 
751             uint256 fromBalance = _balances[id][from];
752             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
753             unchecked {
754                 _balances[id][from] = fromBalance - amount;
755             }
756             _balances[id][to] += amount;
757         }
758 
759         emit TransferBatch(operator, from, to, ids, amounts);
760 
761         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
762     }
763 
764     /**
765      * @dev Sets a new URI for all token types, by relying on the token type ID
766      * substitution mechanism
767      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
768      *
769      * By this mechanism, any occurrence of the `\{id\}` substring in either the
770      * URI or any of the amounts in the JSON file at said URI will be replaced by
771      * clients with the token type ID.
772      *
773      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
774      * interpreted by clients as
775      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
776      * for token type ID 0x4cce0.
777      *
778      * See {uri}.
779      *
780      * Because these URIs cannot be meaningfully represented by the {URI} event,
781      * this function emits no events.
782      */
783     function _setURI(string memory newuri) internal virtual {
784         _uri = newuri;
785     }
786 
787     /**
788      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
789      *
790      * Emits a {TransferSingle} event.
791      *
792      * Requirements:
793      *
794      * - `account` cannot be the zero address.
795      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
796      * acceptance magic value.
797      */
798     function _mint(
799         address account,
800         uint256 id,
801         uint256 amount,
802         bytes memory data
803     ) internal virtual {
804         require(account != address(0), "ERC1155: mint to the zero address");
805 
806         address operator = _msgSender();
807 
808         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
809 
810         _balances[id][account] += amount;
811         emit TransferSingle(operator, address(0), account, id, amount);
812 
813         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
814     }
815 
816     /**
817      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
818      *
819      * Requirements:
820      *
821      * - `ids` and `amounts` must have the same length.
822      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
823      * acceptance magic value.
824      */
825     function _mintBatch(
826         address to,
827         uint256[] memory ids,
828         uint256[] memory amounts,
829         bytes memory data
830     ) internal virtual {
831         require(to != address(0), "ERC1155: mint to the zero address");
832         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
833 
834         address operator = _msgSender();
835 
836         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
837 
838         for (uint256 i = 0; i < ids.length; i++) {
839             _balances[ids[i]][to] += amounts[i];
840         }
841 
842         emit TransferBatch(operator, address(0), to, ids, amounts);
843 
844         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
845     }
846 
847     /**
848      * @dev Destroys `amount` tokens of token type `id` from `account`
849      *
850      * Requirements:
851      *
852      * - `account` cannot be the zero address.
853      * - `account` must have at least `amount` tokens of token type `id`.
854      */
855     function _burn(
856         address account,
857         uint256 id,
858         uint256 amount
859     ) internal virtual {
860         require(account != address(0), "ERC1155: burn from the zero address");
861 
862         address operator = _msgSender();
863 
864         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
865 
866         uint256 accountBalance = _balances[id][account];
867         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
868         unchecked {
869             _balances[id][account] = accountBalance - amount;
870         }
871 
872         emit TransferSingle(operator, account, address(0), id, amount);
873     }
874 
875     /**
876      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
877      *
878      * Requirements:
879      *
880      * - `ids` and `amounts` must have the same length.
881      */
882     function _burnBatch(
883         address account,
884         uint256[] memory ids,
885         uint256[] memory amounts
886     ) internal virtual {
887         require(account != address(0), "ERC1155: burn from the zero address");
888         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
889 
890         address operator = _msgSender();
891 
892         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
893 
894         for (uint256 i = 0; i < ids.length; i++) {
895             uint256 id = ids[i];
896             uint256 amount = amounts[i];
897 
898             uint256 accountBalance = _balances[id][account];
899             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
900             unchecked {
901                 _balances[id][account] = accountBalance - amount;
902             }
903         }
904 
905         emit TransferBatch(operator, account, address(0), ids, amounts);
906     }
907 
908     /**
909      * @dev Hook that is called before any token transfer. This includes minting
910      * and burning, as well as batched variants.
911      *
912      * The same hook is called on both single and batched variants. For single
913      * transfers, the length of the `id` and `amount` arrays will be 1.
914      *
915      * Calling conditions (for each `id` and `amount` pair):
916      *
917      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
918      * of token type `id` will be  transferred to `to`.
919      * - When `from` is zero, `amount` tokens of token type `id` will be minted
920      * for `to`.
921      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
922      * will be burned.
923      * - `from` and `to` are never both zero.
924      * - `ids` and `amounts` have the same, non-zero length.
925      *
926      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
927      */
928     function _beforeTokenTransfer(
929         address operator,
930         address from,
931         address to,
932         uint256[] memory ids,
933         uint256[] memory amounts,
934         bytes memory data
935     ) internal virtual {}
936 
937     function _doSafeTransferAcceptanceCheck(
938         address operator,
939         address from,
940         address to,
941         uint256 id,
942         uint256 amount,
943         bytes memory data
944     ) private {
945         if (to.isContract()) {
946             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
947                 if (response != IERC1155Receiver.onERC1155Received.selector) {
948                     revert("ERC1155: ERC1155Receiver rejected tokens");
949                 }
950             } catch Error(string memory reason) {
951                 revert(reason);
952             } catch {
953                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
954             }
955         }
956     }
957 
958     function _doSafeBatchTransferAcceptanceCheck(
959         address operator,
960         address from,
961         address to,
962         uint256[] memory ids,
963         uint256[] memory amounts,
964         bytes memory data
965     ) private {
966         if (to.isContract()) {
967             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
968                 bytes4 response
969             ) {
970                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
971                     revert("ERC1155: ERC1155Receiver rejected tokens");
972                 }
973             } catch Error(string memory reason) {
974                 revert(reason);
975             } catch {
976                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
977             }
978         }
979     }
980 
981     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
982         uint256[] memory array = new uint256[](1);
983         array[0] = element;
984 
985         return array;
986     }
987 }
988 
989 contract ExpansionPhunks is ERC1155, Ownable {
990     string public constant name = "ExpansionPhunks";
991     string public constant symbol = "PHUNX";
992 
993     uint32 public totalSupply = 0;
994     uint256 public constant phunkPrice = 0.02 ether;
995     uint256 public constant bulkPrice = 0.015 ether;
996     
997     uint32 public saleStart = 1640894400;
998     uint32 public constant startSupply = 10000;
999     uint32 public maxSupply = 10000;
1000 
1001     address private wallet1 = 0xD44F85aA20b03cc773309f10d67cC4eaB0BD26a6;
1002     address private wallet2 = 0xB9e1cc664a0140953c2512f57BCd36Bb92c2eEf6;
1003 
1004     constructor(string memory uri) ERC1155(uri) {}
1005 
1006     function setURI(string memory uri) public onlyOwner {
1007         _setURI(uri);
1008     }
1009 
1010     function setSaleStart(uint32 timestamp) public onlyOwner {
1011         saleStart = timestamp;
1012     }
1013     
1014     function saleIsActive() public view returns (bool) {
1015         return saleStart <= block.timestamp;
1016     }
1017 
1018     function setMaxSupply(uint32 _supply) public onlyOwner {
1019         maxSupply = _supply;
1020     }
1021 
1022     function mint(address to, uint32 count) internal {
1023         if (count > 1) {
1024             uint256[] memory ids = new uint256[](uint256(count));
1025             uint256[] memory amounts = new uint256[](uint256(count));
1026 
1027             for (uint32 i = 0; i < count; i++) {
1028                 ids[i] = startSupply + totalSupply + i;
1029                 amounts[i] = 1;
1030             }
1031 
1032             _mintBatch(to, ids, amounts, "");
1033         } else {
1034             _mint(to, startSupply + totalSupply, 1, "");
1035         }
1036 
1037         totalSupply += count;
1038     }
1039     
1040     function purchase(uint32 count) external payable {
1041         require(saleIsActive(), "Sale inactive");
1042         require(count > 0, "Count must be greater than 0");
1043         require(count < 51, "Count must be less than or equal to 50");
1044         require(totalSupply + count <= maxSupply, "Exceeds max supply");
1045 
1046         if (count > 9) {
1047             require(msg.value >= bulkPrice * count, "Insufficient funds");
1048         } else {
1049             require(msg.value >= phunkPrice * count, "Insufficient funds");
1050         }
1051 
1052         mint(msg.sender, count);
1053     }
1054 
1055     function teamMint(uint32 count) external onlyOwner {
1056         require(totalSupply + count <= maxSupply, "Exceeds max supply");
1057         mint(msg.sender, count);
1058     }
1059 
1060     function withdraw() external onlyOwner {
1061         uint256 balance = address(this).balance;
1062         uint256 balance1 = balance * 85 / 100;
1063         uint256 balance2 = balance * 10 / 100;
1064         uint256 balance3 = balance * 5 / 100;
1065 
1066         payable(wallet1).transfer(balance1);
1067         payable(wallet2).transfer(balance2);
1068         payable(msg.sender).transfer(balance3);
1069     }
1070 }