1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
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
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 
91 pragma solidity ^0.8.0;
92 
93 
94 pragma solidity ^0.8.0;
95 
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Interface of the ERC165 standard, as defined in the
101  * https://eips.ethereum.org/EIPS/eip-165[EIP].
102  *
103  * Implementers can declare support of contract interfaces, which can then be
104  * queried by others ({ERC165Checker}).
105  *
106  * For an implementation, see {ERC165}.
107  */
108 interface IERC165 {
109     /**
110      * @dev Returns true if this contract implements the interface defined by
111      * `interfaceId`. See the corresponding
112      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
113      * to learn more about how these ids are created.
114      *
115      * This function call must use less than 30 000 gas.
116      */
117     function supportsInterface(bytes4 interfaceId) external view returns (bool);
118 }
119 
120 
121 /**
122  * @dev Required interface of an ERC1155 compliant contract, as defined in the
123  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
124  *
125  * _Available since v3.1._
126  */
127 interface IERC1155 is IERC165 {
128     /**
129      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
130      */
131     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
132 
133     /**
134      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
135      * transfers.
136      */
137     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
138 
139     /**
140      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
141      * `approved`.
142      */
143     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
144 
145     /**
146      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
147      *
148      * If an {URI} event was emitted for `id`, the standard
149      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
150      * returned by {IERC1155MetadataURI-uri}.
151      */
152     event URI(string value, uint256 indexed id);
153 
154     /**
155      * @dev Returns the amount of tokens of token type `id` owned by `account`.
156      *
157      * Requirements:
158      *
159      * - `account` cannot be the zero address.
160      */
161     function balanceOf(address account, uint256 id) external view returns (uint256);
162 
163     /**
164      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
165      *
166      * Requirements:
167      *
168      * - `accounts` and `ids` must have the same length.
169      */
170     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
171 
172     /**
173      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
174      *
175      * Emits an {ApprovalForAll} event.
176      *
177      * Requirements:
178      *
179      * - `operator` cannot be the caller.
180      */
181     function setApprovalForAll(address operator, bool approved) external;
182 
183     /**
184      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
185      *
186      * See {setApprovalForAll}.
187      */
188     function isApprovedForAll(address account, address operator) external view returns (bool);
189 
190     /**
191      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
192      *
193      * Emits a {TransferSingle} event.
194      *
195      * Requirements:
196      *
197      * - `to` cannot be the zero address.
198      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
199      * - `from` must have a balance of tokens of type `id` of at least `amount`.
200      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
201      * acceptance magic value.
202      */
203     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
204 
205     /**
206      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
207      *
208      * Emits a {TransferBatch} event.
209      *
210      * Requirements:
211      *
212      * - `ids` and `amounts` must have the same length.
213      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
214      * acceptance magic value.
215      */
216     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
217 }
218 
219 
220 pragma solidity ^0.8.0;
221 
222 
223 
224 /**
225  * @dev _Available since v3.1._
226  */
227 interface IERC1155Receiver is IERC165 {
228 
229     /**
230         @dev Handles the receipt of a single ERC1155 token type. This function is
231         called at the end of a `safeTransferFrom` after the balance has been updated.
232         To accept the transfer, this must return
233         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
234         (i.e. 0xf23a6e61, or its own function selector).
235         @param operator The address which initiated the transfer (i.e. msg.sender)
236         @param from The address which previously owned the token
237         @param id The ID of the token being transferred
238         @param value The amount of tokens being transferred
239         @param data Additional data with no specified format
240         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
241     */
242     function onERC1155Received(
243         address operator,
244         address from,
245         uint256 id,
246         uint256 value,
247         bytes calldata data
248     )
249         external
250         returns(bytes4);
251 
252     /**
253         @dev Handles the receipt of a multiple ERC1155 token types. This function
254         is called at the end of a `safeBatchTransferFrom` after the balances have
255         been updated. To accept the transfer(s), this must return
256         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
257         (i.e. 0xbc197c81, or its own function selector).
258         @param operator The address which initiated the batch transfer (i.e. msg.sender)
259         @param from The address which previously owned the token
260         @param ids An array containing ids of each token being transferred (order and length must match values array)
261         @param values An array containing amounts of each token being transferred (order and length must match ids array)
262         @param data Additional data with no specified format
263         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
264     */
265     function onERC1155BatchReceived(
266         address operator,
267         address from,
268         uint256[] calldata ids,
269         uint256[] calldata values,
270         bytes calldata data
271     )
272         external
273         returns(bytes4);
274 }
275 
276 
277 pragma solidity ^0.8.0;
278 
279 
280 
281 /**
282  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
283  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
284  *
285  * _Available since v3.1._
286  */
287 interface IERC1155MetadataURI is IERC1155 {
288     /**
289      * @dev Returns the URI for token type `id`.
290      *
291      * If the `\{id\}` substring is present in the URI, it must be replaced by
292      * clients with the actual token type ID.
293      */
294     function uri(uint256 id) external view returns (string memory);
295 }
296 
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev Collection of functions related to the address type
302  */
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      */
321     function isContract(address account) internal view returns (bool) {
322         // This method relies on extcodesize, which returns 0 for contracts in
323         // construction, since the code is only stored at the end of the
324         // constructor execution.
325 
326         uint256 size;
327         // solhint-disable-next-line no-inline-assembly
328         assembly { size := extcodesize(account) }
329         return size > 0;
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350 
351         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
352         (bool success, ) = recipient.call{ value: amount }("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain`call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375       return functionCall(target, data, "Address: low-level call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
405      * with `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
410         require(address(this).balance >= value, "Address: insufficient balance for call");
411         require(isContract(target), "Address: call to non-contract");
412 
413         // solhint-disable-next-line avoid-low-level-calls
414         (bool success, bytes memory returndata) = target.call{ value: value }(data);
415         return _verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but performing a static call.
421      *
422      * _Available since v3.3._
423      */
424     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
425         return functionStaticCall(target, data, "Address: low-level static call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430      * but performing a static call.
431      *
432      * _Available since v3.3._
433      */
434     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
435         require(isContract(target), "Address: static call to non-contract");
436 
437         // solhint-disable-next-line avoid-low-level-calls
438         (bool success, bytes memory returndata) = target.staticcall(data);
439         return _verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         // solhint-disable-next-line avoid-low-level-calls
462         (bool success, bytes memory returndata) = target.delegatecall(data);
463         return _verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
467         if (success) {
468             return returndata;
469         } else {
470             // Look for revert reason and bubble it up if present
471             if (returndata.length > 0) {
472                 // The easiest way to bubble the revert reason is using memory via assembly
473 
474                 // solhint-disable-next-line no-inline-assembly
475                 assembly {
476                     let returndata_size := mload(returndata)
477                     revert(add(32, returndata), returndata_size)
478                 }
479             } else {
480                 revert(errorMessage);
481             }
482         }
483     }
484 }
485 
486 
487 pragma solidity ^0.8.0;
488 
489 
490 
491 /**
492  * @dev Implementation of the {IERC165} interface.
493  *
494  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
495  * for the additional interface id that will be supported. For example:
496  *
497  * ```solidity
498  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
499  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
500  * }
501  * ```
502  *
503  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
504  */
505 abstract contract ERC165 is IERC165 {
506     /**
507      * @dev See {IERC165-supportsInterface}.
508      */
509     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
510         return interfaceId == type(IERC165).interfaceId;
511     }
512 }
513 
514 
515 /**
516  * @dev Implementation of the basic standard multi-token.
517  * See https://eips.ethereum.org/EIPS/eip-1155
518  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
519  *
520  * _Available since v3.1._
521  */
522 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
523     using Address for address;
524 
525     // Mapping from token ID to account balances
526     mapping (uint256 => mapping(address => uint256)) private _balances;
527 
528     // Mapping from account to operator approvals
529     mapping (address => mapping(address => bool)) private _operatorApprovals;
530 
531     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
532     string private _uri;
533 
534     /**
535      * @dev See {_setURI}.
536      */
537     constructor (string memory uri_) {
538         _setURI(uri_);
539     }
540 
541     /**
542      * @dev See {IERC165-supportsInterface}.
543      */
544     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
545         return interfaceId == type(IERC1155).interfaceId
546             || interfaceId == type(IERC1155MetadataURI).interfaceId
547             || super.supportsInterface(interfaceId);
548     }
549 
550     /**
551      * @dev See {IERC1155MetadataURI-uri}.
552      *
553      * This implementation returns the same URI for *all* token types. It relies
554      * on the token type ID substitution mechanism
555      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
556      *
557      * Clients calling this function must replace the `\{id\}` substring with the
558      * actual token type ID.
559      */
560     function uri(uint256) public view virtual override returns (string memory) {
561         return _uri;
562     }
563 
564     /**
565      * @dev See {IERC1155-balanceOf}.
566      *
567      * Requirements:
568      *
569      * - `account` cannot be the zero address.
570      */
571     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
572         require(account != address(0), "ERC1155: balance query for the zero address");
573         return _balances[id][account];
574     }
575 
576     /**
577      * @dev See {IERC1155-balanceOfBatch}.
578      *
579      * Requirements:
580      *
581      * - `accounts` and `ids` must have the same length.
582      */
583     function balanceOfBatch(
584         address[] memory accounts,
585         uint256[] memory ids
586     )
587         public
588         view
589         virtual
590         override
591         returns (uint256[] memory)
592     {
593         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
594 
595         uint256[] memory batchBalances = new uint256[](accounts.length);
596 
597         for (uint256 i = 0; i < accounts.length; ++i) {
598             batchBalances[i] = balanceOf(accounts[i], ids[i]);
599         }
600 
601         return batchBalances;
602     }
603 
604     /**
605      * @dev See {IERC1155-setApprovalForAll}.
606      */
607     function setApprovalForAll(address operator, bool approved) public virtual override {
608         require(_msgSender() != operator, "ERC1155: setting approval status for self");
609 
610         _operatorApprovals[_msgSender()][operator] = approved;
611         emit ApprovalForAll(_msgSender(), operator, approved);
612     }
613 
614     /**
615      * @dev See {IERC1155-isApprovedForAll}.
616      */
617     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
618         return _operatorApprovals[account][operator];
619     }
620 
621     /**
622      * @dev See {IERC1155-safeTransferFrom}.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 id,
628         uint256 amount,
629         bytes memory data
630     )
631         public
632         virtual
633         override
634     {
635         require(to != address(0), "ERC1155: transfer to the zero address");
636         require(
637             from == _msgSender() || isApprovedForAll(from, _msgSender()),
638             "ERC1155: caller is not owner nor approved"
639         );
640 
641         address operator = _msgSender();
642 
643         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
644 
645         uint256 fromBalance = _balances[id][from];
646         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
647         _balances[id][from] = fromBalance - amount;
648         _balances[id][to] += amount;
649 
650         emit TransferSingle(operator, from, to, id, amount);
651 
652         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
653     }
654 
655     /**
656      * @dev See {IERC1155-safeBatchTransferFrom}.
657      */
658     function safeBatchTransferFrom(
659         address from,
660         address to,
661         uint256[] memory ids,
662         uint256[] memory amounts,
663         bytes memory data
664     )
665         public
666         virtual
667         override
668     {
669         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
670         require(to != address(0), "ERC1155: transfer to the zero address");
671         require(
672             from == _msgSender() || isApprovedForAll(from, _msgSender()),
673             "ERC1155: transfer caller is not owner nor approved"
674         );
675 
676         address operator = _msgSender();
677 
678         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
679 
680         for (uint256 i = 0; i < ids.length; ++i) {
681             uint256 id = ids[i];
682             uint256 amount = amounts[i];
683 
684             uint256 fromBalance = _balances[id][from];
685             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
686             _balances[id][from] = fromBalance - amount;
687             _balances[id][to] += amount;
688         }
689 
690         emit TransferBatch(operator, from, to, ids, amounts);
691 
692         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
693     }
694 
695     /**
696      * @dev Sets a new URI for all token types, by relying on the token type ID
697      * substitution mechanism
698      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
699      *
700      * By this mechanism, any occurrence of the `\{id\}` substring in either the
701      * URI or any of the amounts in the JSON file at said URI will be replaced by
702      * clients with the token type ID.
703      *
704      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
705      * interpreted by clients as
706      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
707      * for token type ID 0x4cce0.
708      *
709      * See {uri}.
710      *
711      * Because these URIs cannot be meaningfully represented by the {URI} event,
712      * this function emits no events.
713      */
714     function _setURI(string memory newuri) internal virtual {
715         _uri = newuri;
716     }
717 
718     /**
719      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
720      *
721      * Emits a {TransferSingle} event.
722      *
723      * Requirements:
724      *
725      * - `account` cannot be the zero address.
726      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
727      * acceptance magic value.
728      */
729     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
730         require(account != address(0), "ERC1155: mint to the zero address");
731 
732         address operator = _msgSender();
733 
734         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
735 
736         _balances[id][account] += amount;
737         emit TransferSingle(operator, address(0), account, id, amount);
738 
739         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
740     }
741 
742     /**
743      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
744      *
745      * Requirements:
746      *
747      * - `ids` and `amounts` must have the same length.
748      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
749      * acceptance magic value.
750      */
751     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
752         require(to != address(0), "ERC1155: mint to the zero address");
753         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
754 
755         address operator = _msgSender();
756 
757         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
758 
759         for (uint i = 0; i < ids.length; i++) {
760             _balances[ids[i]][to] += amounts[i];
761         }
762 
763         emit TransferBatch(operator, address(0), to, ids, amounts);
764 
765         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
766     }
767 
768     /**
769      * @dev Destroys `amount` tokens of token type `id` from `account`
770      *
771      * Requirements:
772      *
773      * - `account` cannot be the zero address.
774      * - `account` must have at least `amount` tokens of token type `id`.
775      */
776     function _burn(address account, uint256 id, uint256 amount) internal virtual {
777         require(account != address(0), "ERC1155: burn from the zero address");
778 
779         address operator = _msgSender();
780 
781         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
782 
783         uint256 accountBalance = _balances[id][account];
784         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
785         _balances[id][account] = accountBalance - amount;
786 
787         emit TransferSingle(operator, account, address(0), id, amount);
788     }
789 
790     /**
791      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
792      *
793      * Requirements:
794      *
795      * - `ids` and `amounts` must have the same length.
796      */
797     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
798         require(account != address(0), "ERC1155: burn from the zero address");
799         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
800 
801         address operator = _msgSender();
802 
803         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
804 
805         for (uint i = 0; i < ids.length; i++) {
806             uint256 id = ids[i];
807             uint256 amount = amounts[i];
808 
809             uint256 accountBalance = _balances[id][account];
810             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
811             _balances[id][account] = accountBalance - amount;
812         }
813 
814         emit TransferBatch(operator, account, address(0), ids, amounts);
815     }
816 
817     /**
818      * @dev Hook that is called before any token transfer. This includes minting
819      * and burning, as well as batched variants.
820      *
821      * The same hook is called on both single and batched variants. For single
822      * transfers, the length of the `id` and `amount` arrays will be 1.
823      *
824      * Calling conditions (for each `id` and `amount` pair):
825      *
826      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
827      * of token type `id` will be  transferred to `to`.
828      * - When `from` is zero, `amount` tokens of token type `id` will be minted
829      * for `to`.
830      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
831      * will be burned.
832      * - `from` and `to` are never both zero.
833      * - `ids` and `amounts` have the same, non-zero length.
834      *
835      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
836      */
837     function _beforeTokenTransfer(
838         address operator,
839         address from,
840         address to,
841         uint256[] memory ids,
842         uint256[] memory amounts,
843         bytes memory data
844     )
845         internal
846         virtual
847     { }
848 
849     function _doSafeTransferAcceptanceCheck(
850         address operator,
851         address from,
852         address to,
853         uint256 id,
854         uint256 amount,
855         bytes memory data
856     )
857         private
858     {
859         if (to.isContract()) {
860             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
861                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
862                     revert("ERC1155: ERC1155Receiver rejected tokens");
863                 }
864             } catch Error(string memory reason) {
865                 revert(reason);
866             } catch {
867                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
868             }
869         }
870     }
871 
872     function _doSafeBatchTransferAcceptanceCheck(
873         address operator,
874         address from,
875         address to,
876         uint256[] memory ids,
877         uint256[] memory amounts,
878         bytes memory data
879     )
880         private
881     {
882         if (to.isContract()) {
883             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
884                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
885                     revert("ERC1155: ERC1155Receiver rejected tokens");
886                 }
887             } catch Error(string memory reason) {
888                 revert(reason);
889             } catch {
890                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
891             }
892         }
893     }
894 
895     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
896         uint256[] memory array = new uint256[](1);
897         array[0] = element;
898 
899         return array;
900     }
901 }
902 
903 
904 pragma solidity ^0.8.0;
905 
906 // CAUTION
907 // This version of SafeMath should only be used with Solidity 0.8 or later,
908 // because it relies on the compiler's built in overflow checks.
909 
910 /**
911  * @dev Wrappers over Solidity's arithmetic operations.
912  *
913  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
914  * now has built in overflow checking.
915  */
916 library SafeMath {
917     /**
918      * @dev Returns the addition of two unsigned integers, with an overflow flag.
919      *
920      * _Available since v3.4._
921      */
922     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
923         unchecked {
924             uint256 c = a + b;
925             if (c < a) return (false, 0);
926             return (true, c);
927         }
928     }
929 
930     /**
931      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
932      *
933      * _Available since v3.4._
934      */
935     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
936         unchecked {
937             if (b > a) return (false, 0);
938             return (true, a - b);
939         }
940     }
941 
942     /**
943      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
944      *
945      * _Available since v3.4._
946      */
947     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
948         unchecked {
949             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
950             // benefit is lost if 'b' is also tested.
951             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
952             if (a == 0) return (true, 0);
953             uint256 c = a * b;
954             if (c / a != b) return (false, 0);
955             return (true, c);
956         }
957     }
958 
959     /**
960      * @dev Returns the division of two unsigned integers, with a division by zero flag.
961      *
962      * _Available since v3.4._
963      */
964     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
965         unchecked {
966             if (b == 0) return (false, 0);
967             return (true, a / b);
968         }
969     }
970 
971     /**
972      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
973      *
974      * _Available since v3.4._
975      */
976     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
977         unchecked {
978             if (b == 0) return (false, 0);
979             return (true, a % b);
980         }
981     }
982 
983     /**
984      * @dev Returns the addition of two unsigned integers, reverting on
985      * overflow.
986      *
987      * Counterpart to Solidity's `+` operator.
988      *
989      * Requirements:
990      *
991      * - Addition cannot overflow.
992      */
993     function add(uint256 a, uint256 b) internal pure returns (uint256) {
994         return a + b;
995     }
996 
997     /**
998      * @dev Returns the subtraction of two unsigned integers, reverting on
999      * overflow (when the result is negative).
1000      *
1001      * Counterpart to Solidity's `-` operator.
1002      *
1003      * Requirements:
1004      *
1005      * - Subtraction cannot overflow.
1006      */
1007     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1008         return a - b;
1009     }
1010 
1011     /**
1012      * @dev Returns the multiplication of two unsigned integers, reverting on
1013      * overflow.
1014      *
1015      * Counterpart to Solidity's `*` operator.
1016      *
1017      * Requirements:
1018      *
1019      * - Multiplication cannot overflow.
1020      */
1021     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1022         return a * b;
1023     }
1024 
1025     /**
1026      * @dev Returns the integer division of two unsigned integers, reverting on
1027      * division by zero. The result is rounded towards zero.
1028      *
1029      * Counterpart to Solidity's `/` operator.
1030      *
1031      * Requirements:
1032      *
1033      * - The divisor cannot be zero.
1034      */
1035     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1036         return a / b;
1037     }
1038 
1039     /**
1040      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1041      * reverting when dividing by zero.
1042      *
1043      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1044      * opcode (which leaves remaining gas untouched) while Solidity uses an
1045      * invalid opcode to revert (consuming all remaining gas).
1046      *
1047      * Requirements:
1048      *
1049      * - The divisor cannot be zero.
1050      */
1051     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1052         return a % b;
1053     }
1054 
1055     /**
1056      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1057      * overflow (when the result is negative).
1058      *
1059      * CAUTION: This function is deprecated because it requires allocating memory for the error
1060      * message unnecessarily. For custom revert reasons use {trySub}.
1061      *
1062      * Counterpart to Solidity's `-` operator.
1063      *
1064      * Requirements:
1065      *
1066      * - Subtraction cannot overflow.
1067      */
1068     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1069         unchecked {
1070             require(b <= a, errorMessage);
1071             return a - b;
1072         }
1073     }
1074 
1075     /**
1076      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1077      * division by zero. The result is rounded towards zero.
1078      *
1079      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1080      * opcode (which leaves remaining gas untouched) while Solidity uses an
1081      * invalid opcode to revert (consuming all remaining gas).
1082      *
1083      * Counterpart to Solidity's `/` operator. Note: this function uses a
1084      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1085      * uses an invalid opcode to revert (consuming all remaining gas).
1086      *
1087      * Requirements:
1088      *
1089      * - The divisor cannot be zero.
1090      */
1091     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1092         unchecked {
1093             require(b > 0, errorMessage);
1094             return a / b;
1095         }
1096     }
1097 
1098     /**
1099      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1100      * reverting with custom message when dividing by zero.
1101      *
1102      * CAUTION: This function is deprecated because it requires allocating memory for the error
1103      * message unnecessarily. For custom revert reasons use {tryMod}.
1104      *
1105      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1106      * opcode (which leaves remaining gas untouched) while Solidity uses an
1107      * invalid opcode to revert (consuming all remaining gas).
1108      *
1109      * Requirements:
1110      *
1111      * - The divisor cannot be zero.
1112      */
1113     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1114         unchecked {
1115             require(b > 0, errorMessage);
1116             return a % b;
1117         }
1118     }
1119 }
1120 
1121 
1122 pragma solidity ^0.8.0;
1123 
1124 /**
1125  * @dev String operations.
1126  */
1127 library Strings {
1128     bytes16 private constant alphabet = "0123456789abcdef";
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
1179             buffer[i] = alphabet[value & 0xf];
1180             value >>= 4;
1181         }
1182         require(value == 0, "Strings: hex length insufficient");
1183         return string(buffer);
1184     }
1185 
1186 }
1187 
1188 
1189 
1190 pragma solidity ^0.8.0;
1191 
1192 abstract contract ContextMixin {
1193     function msgSender()
1194         internal
1195         view
1196         returns (address payable sender)
1197     {
1198         if (msg.sender == address(this)) {
1199             bytes memory array = msg.data;
1200             uint256 index = msg.data.length;
1201             assembly {
1202                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1203                 sender := and(
1204                     mload(add(array, index)),
1205                     0xffffffffffffffffffffffffffffffffffffffff
1206                 )
1207             }
1208         } else {
1209             sender = payable(msg.sender);
1210         }
1211         return sender;
1212     }
1213 }
1214 
1215 
1216 pragma solidity ^0.8.0;
1217 
1218 
1219 
1220 pragma solidity ^0.8.0;
1221 
1222 
1223 pragma solidity ^0.8.0;
1224 
1225 contract Initializable {
1226     bool inited = false;
1227 
1228     modifier initializer() {
1229         require(!inited, "already inited");
1230         _;
1231         inited = true;
1232     }
1233 }
1234 
1235 
1236 contract EIP712Base is Initializable {
1237     struct EIP712Domain {
1238         string name;
1239         string version;
1240         address verifyingContract;
1241         bytes32 salt;
1242     }
1243 
1244     string constant public ERC712_VERSION = "1";
1245 
1246     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
1247         bytes(
1248             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1249         )
1250     );
1251     bytes32 internal domainSeperator;
1252 
1253     // supposed to be called once while initializing.
1254     // one of the contracts that inherits this contract follows proxy pattern
1255     // so it is not possible to do this in a constructor
1256     function _initializeEIP712(
1257         string memory name
1258     )
1259         internal
1260         initializer
1261     {
1262         _setDomainSeperator(name);
1263     }
1264 
1265     function _setDomainSeperator(string memory name) internal {
1266         domainSeperator = keccak256(
1267             abi.encode(
1268                 EIP712_DOMAIN_TYPEHASH,
1269                 keccak256(bytes(name)),
1270                 keccak256(bytes(ERC712_VERSION)),
1271                 address(this),
1272                 bytes32(getChainId())
1273             )
1274         );
1275     }
1276 
1277     function getDomainSeperator() public view returns (bytes32) {
1278         return domainSeperator;
1279     }
1280 
1281     function getChainId() public view returns (uint256) {
1282         uint256 id;
1283         assembly {
1284             id := chainid()
1285         }
1286         return id;
1287     }
1288 
1289     /**
1290      * Accept message hash and returns hash message in EIP712 compatible form
1291      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1292      * https://eips.ethereum.org/EIPS/eip-712
1293      * "\\x19" makes the encoding deterministic
1294      * "\\x01" is the version byte to make it compatible to EIP-191
1295      */
1296     function toTypedMessageHash(bytes32 messageHash)
1297         internal
1298         view
1299         returns (bytes32)
1300     {
1301         return
1302             keccak256(
1303                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1304             );
1305     }
1306 }
1307 
1308 contract NativeMetaTransaction is EIP712Base {
1309     using SafeMath for uint256;
1310     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
1311         bytes(
1312             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1313         )
1314     );
1315     event MetaTransactionExecuted(
1316         address userAddress,
1317         address payable relayerAddress,
1318         bytes functionSignature
1319     );
1320     mapping(address => uint256) nonces;
1321 
1322     /*
1323      * Meta transaction structure.
1324      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1325      * He should call the desired function directly in that case.
1326      */
1327     struct MetaTransaction {
1328         uint256 nonce;
1329         address from;
1330         bytes functionSignature;
1331     }
1332 
1333     function executeMetaTransaction(
1334         address userAddress,
1335         bytes memory functionSignature,
1336         bytes32 sigR,
1337         bytes32 sigS,
1338         uint8 sigV
1339     ) public payable returns (bytes memory) {
1340         MetaTransaction memory metaTx = MetaTransaction({
1341             nonce: nonces[userAddress],
1342             from: userAddress,
1343             functionSignature: functionSignature
1344         });
1345 
1346         require(
1347             verify(userAddress, metaTx, sigR, sigS, sigV),
1348             "Signer and signature do not match"
1349         );
1350 
1351         // increase nonce for user (to avoid re-use)
1352         nonces[userAddress] = nonces[userAddress].add(1);
1353 
1354         emit MetaTransactionExecuted(
1355             userAddress,
1356             payable(msg.sender),
1357             functionSignature
1358         );
1359 
1360         // Append userAddress and relayer address at the end to extract it from calling context
1361         (bool success, bytes memory returnData) = address(this).call(
1362             abi.encodePacked(functionSignature, userAddress)
1363         );
1364         require(success, "Function call not successful");
1365 
1366         return returnData;
1367     }
1368 
1369     function hashMetaTransaction(MetaTransaction memory metaTx)
1370         internal
1371         pure
1372         returns (bytes32)
1373     {
1374         return
1375             keccak256(
1376                 abi.encode(
1377                     META_TRANSACTION_TYPEHASH,
1378                     metaTx.nonce,
1379                     metaTx.from,
1380                     keccak256(metaTx.functionSignature)
1381                 )
1382             );
1383     }
1384 
1385     function getNonce(address user) public view returns (uint256 nonce) {
1386         nonce = nonces[user];
1387     }
1388 
1389     function verify(
1390         address signer,
1391         MetaTransaction memory metaTx,
1392         bytes32 sigR,
1393         bytes32 sigS,
1394         uint8 sigV
1395     ) internal view returns (bool) {
1396         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1397         return
1398             signer ==
1399             ecrecover(
1400                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1401                 sigV,
1402                 sigR,
1403                 sigS
1404             );
1405     }
1406 }
1407 
1408 
1409 contract OwnableDelegateProxy { }
1410 
1411 contract ProxyRegistry {
1412   mapping(address => OwnableDelegateProxy) public proxies;
1413 }
1414 
1415 /**
1416  * @title ERC1155Tradable
1417  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, has create and mint functionality, and supports useful standards from OpenZeppelin,
1418   like _exists(), name(), symbol(), and totalSupply()
1419  */
1420 contract ERC1155Tradable is ContextMixin, ERC1155, NativeMetaTransaction, Ownable {
1421   using Strings for string;
1422   using SafeMath for uint256;
1423 
1424   address proxyRegistryAddress;
1425   mapping (uint256 => address) public creators;
1426   mapping (uint256 => uint256) public tokenSupply;
1427   mapping (uint256 => string) customUri;
1428   // Contract name
1429   string public name;
1430   // Contract symbol
1431   string public symbol;
1432 
1433   /**
1434    * @dev Require _msgSender() to be the creator of the token id
1435    */
1436   modifier creatorOnly(uint256 _id) {
1437     require(creators[_id] == _msgSender(), "ERC1155Tradable#creatorOnly: ONLY_CREATOR_ALLOWED");
1438     _;
1439   }
1440 
1441   /**
1442    * @dev Require _msgSender() to own more than 0 of the token id
1443    */
1444   modifier ownersOnly(uint256 _id) {
1445     require(balanceOf(_msgSender(), _id) > 0, "ERC1155Tradable#ownersOnly: ONLY_OWNERS_ALLOWED");
1446     _;
1447   }
1448 
1449   constructor(
1450     string memory _name,
1451     string memory _symbol,
1452     string memory _uri,
1453     address _proxyRegistryAddress
1454   ) ERC1155(_uri) {
1455     name = _name;
1456     symbol = _symbol;
1457     proxyRegistryAddress = _proxyRegistryAddress;
1458     _initializeEIP712(name);
1459   }
1460 
1461   function uri(
1462     uint256 _id
1463   ) override public view returns (string memory) {
1464     require(_exists(_id), "ERC1155Tradable#uri: NONEXISTENT_TOKEN");
1465     // We have to convert string to bytes to check for existence
1466     bytes memory customUriBytes = bytes(customUri[_id]);
1467     if (customUriBytes.length > 0) {
1468         return customUri[_id];
1469     } else {
1470         return super.uri(_id);
1471     }
1472   }
1473 
1474   /**
1475     * @dev Returns the total quantity for a token ID
1476     * @param _id uint256 ID of the token to query
1477     * @return amount of token in existence
1478     */
1479   function totalSupply(
1480     uint256 _id
1481   ) public view returns (uint256) {
1482     return tokenSupply[_id];
1483   }
1484 
1485   /**
1486    * @dev Sets a new URI for all token types, by relying on the token type ID
1487     * substitution mechanism
1488     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1489    * @param _newURI New URI for all tokens
1490    */
1491   function setURI(
1492     string memory _newURI
1493   ) public onlyOwner {
1494     _setURI(_newURI);
1495   }
1496 
1497   /**
1498    * @dev Will update the base URI for the token
1499    * @param _tokenId The token to update. _msgSender() must be its creator.
1500    * @param _newURI New URI for the token.
1501    */
1502   function setCustomURI(
1503     uint256 _tokenId,
1504     string memory _newURI
1505   ) public creatorOnly(_tokenId) {
1506     customUri[_tokenId] = _newURI;
1507     emit URI(_newURI, _tokenId);
1508   }
1509 
1510   /**
1511     * @dev Creates a new token type and assigns _initialSupply to an address
1512     * NOTE: remove onlyOwner if you want third parties to create new tokens on
1513     *       your contract (which may change your IDs)
1514     * NOTE: The token id must be passed. This allows lazy creation of tokens or
1515     *       creating NFTs by setting the id's high bits with the method
1516     *       described in ERC1155 or to use ids representing values other than
1517     *       successive small integers. If you wish to create ids as successive
1518     *       small integers you can either subclass this class to count onchain
1519     *       or maintain the offchain cache of identifiers recommended in
1520     *       ERC1155 and calculate successive ids from that.
1521     * @param _initialOwner address of the first owner of the token
1522     * @param _id The id of the token to create (must not currenty exist).
1523     * @param _initialSupply amount to supply the first owner
1524     * @param _uri Optional URI for this token type
1525     * @param _data Data to pass if receiver is contract
1526     * @return The newly created token ID
1527     */
1528   function create(
1529     address _initialOwner,
1530     uint256 _id,
1531     uint256 _initialSupply,
1532     string memory _uri,
1533     bytes memory _data
1534   ) public onlyOwner returns (uint256) {
1535     require(!_exists(_id), "token _id already exists");
1536     creators[_id] = _msgSender();
1537 
1538     if (bytes(_uri).length > 0) {
1539       customUri[_id] = _uri;
1540       emit URI(_uri, _id);
1541     }
1542 
1543     _mint(_initialOwner, _id, _initialSupply, _data);
1544 
1545     tokenSupply[_id] = _initialSupply;
1546     return _id;
1547   }
1548 
1549   /**
1550     * @dev Mints some amount of tokens to an address
1551     * @param _to          Address of the future owner of the token
1552     * @param _id          Token ID to mint
1553     * @param _quantity    Amount of tokens to mint
1554     * @param _data        Data to pass if receiver is contract
1555     */
1556   function mint(
1557     address _to,
1558     uint256 _id,
1559     uint256 _quantity,
1560     bytes memory _data
1561   ) virtual public creatorOnly(_id) {
1562     _mint(_to, _id, _quantity, _data);
1563     tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1564   }
1565 
1566   /**
1567     * @dev Mint tokens for each id in _ids
1568     * @param _to          The address to mint tokens to
1569     * @param _ids         Array of ids to mint
1570     * @param _quantities  Array of amounts of tokens to mint per id
1571     * @param _data        Data to pass if receiver is contract
1572     */
1573   function batchMint(
1574     address _to,
1575     uint256[] memory _ids,
1576     uint256[] memory _quantities,
1577     bytes memory _data
1578   ) public {
1579     for (uint256 i = 0; i < _ids.length; i++) {
1580       uint256 _id = _ids[i];
1581       require(creators[_id] == _msgSender(), "ERC1155Tradable#batchMint: ONLY_CREATOR_ALLOWED");
1582       uint256 quantity = _quantities[i];
1583       tokenSupply[_id] = tokenSupply[_id].add(quantity);
1584     }
1585     _mintBatch(_to, _ids, _quantities, _data);
1586   }
1587 
1588   /**
1589     * @dev Change the creator address for given tokens
1590     * @param _to   Address of the new creator
1591     * @param _ids  Array of Token IDs to change creator
1592     */
1593   function setCreator(
1594     address _to,
1595     uint256[] memory _ids
1596   ) public {
1597     require(_to != address(0), "ERC1155Tradable#setCreator: INVALID_ADDRESS.");
1598     for (uint256 i = 0; i < _ids.length; i++) {
1599       uint256 id = _ids[i];
1600       _setCreator(_to, id);
1601     }
1602   }
1603 
1604   /**
1605    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1606    */
1607   function isApprovedForAll(
1608     address _owner,
1609     address _operator
1610   ) override public view returns (bool isOperator) {
1611     // Whitelist OpenSea proxy contract for easy trading.
1612     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1613     if (address(proxyRegistry.proxies(_owner)) == _operator) {
1614       return true;
1615     }
1616 
1617     return ERC1155.isApprovedForAll(_owner, _operator);
1618   }
1619 
1620   /**
1621     * @dev Change the creator address for given token
1622     * @param _to   Address of the new creator
1623     * @param _id  Token IDs to change creator of
1624     */
1625   function _setCreator(address _to, uint256 _id) internal creatorOnly(_id)
1626   {
1627       creators[_id] = _to;
1628   }
1629 
1630   /**
1631     * @dev Returns whether the specified token exists by checking to see if it has a creator
1632     * @param _id uint256 ID of the token to query the existence of
1633     * @return bool whether the token exists
1634     */
1635   function _exists(
1636     uint256 _id
1637   ) internal view returns (bool) {
1638     return creators[_id] != address(0);
1639   }
1640 
1641   function exists(
1642     uint256 _id
1643   ) external view returns (bool) {
1644     return _exists(_id);
1645   }
1646 
1647     /**
1648      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1649      */
1650     function _msgSender()
1651         internal
1652         override
1653         view
1654         returns (address sender)
1655     {
1656         return ContextMixin.msgSender();
1657     }
1658 }