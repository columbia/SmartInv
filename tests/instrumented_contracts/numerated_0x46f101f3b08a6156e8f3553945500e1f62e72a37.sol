1 // Sources flattened with hardhat v2.6.5 https://hardhat.org
2 
3 // File contracts/utils/Context.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File contracts/access/Ownable.sol
32 
33 
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor () {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 
102 // File contracts/utils/introspection/IERC165.sol
103 
104 
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Interface of the ERC165 standard, as defined in the
110  * https://eips.ethereum.org/EIPS/eip-165[EIP].
111  *
112  * Implementers can declare support of contract interfaces, which can then be
113  * queried by others ({ERC165Checker}).
114  *
115  * For an implementation, see {ERC165}.
116  */
117 interface IERC165 {
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30 000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 }
128 
129 
130 // File contracts/token/ERC1155/IERC1155.sol
131 
132 
133 
134 pragma solidity ^0.8.0;
135 
136 /**
137  * @dev Required interface of an ERC1155 compliant contract, as defined in the
138  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
139  *
140  * _Available since v3.1._
141  */
142 interface IERC1155 is IERC165 {
143     /**
144      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
145      */
146     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
147 
148     /**
149      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
150      * transfers.
151      */
152     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
153 
154     /**
155      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
156      * `approved`.
157      */
158     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
159 
160     /**
161      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
162      *
163      * If an {URI} event was emitted for `id`, the standard
164      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
165      * returned by {IERC1155MetadataURI-uri}.
166      */
167     event URI(string value, uint256 indexed id);
168 
169     /**
170      * @dev Returns the amount of tokens of token type `id` owned by `account`.
171      *
172      * Requirements:
173      *
174      * - `account` cannot be the zero address.
175      */
176     function balanceOf(address account, uint256 id) external view returns (uint256);
177 
178     /**
179      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
180      *
181      * Requirements:
182      *
183      * - `accounts` and `ids` must have the same length.
184      */
185     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
186 
187     /**
188      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
189      *
190      * Emits an {ApprovalForAll} event.
191      *
192      * Requirements:
193      *
194      * - `operator` cannot be the caller.
195      */
196     function setApprovalForAll(address operator, bool approved) external;
197 
198     /**
199      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
200      *
201      * See {setApprovalForAll}.
202      */
203     function isApprovedForAll(address account, address operator) external view returns (bool);
204 
205     /**
206      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
207      *
208      * Emits a {TransferSingle} event.
209      *
210      * Requirements:
211      *
212      * - `to` cannot be the zero address.
213      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
214      * - `from` must have a balance of tokens of type `id` of at least `amount`.
215      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
216      * acceptance magic value.
217      */
218     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
219 
220     /**
221      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
222      *
223      * Emits a {TransferBatch} event.
224      *
225      * Requirements:
226      *
227      * - `ids` and `amounts` must have the same length.
228      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
229      * acceptance magic value.
230      */
231     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
232 }
233 
234 
235 // File contracts/token/ERC1155/IERC1155Receiver.sol
236 
237 
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * _Available since v3.1._
243  */
244 interface IERC1155Receiver is IERC165 {
245 
246     /**
247         @dev Handles the receipt of a single ERC1155 token type. This function is
248         called at the end of a `safeTransferFrom` after the balance has been updated.
249         To accept the transfer, this must return
250         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
251         (i.e. 0xf23a6e61, or its own function selector).
252         @param operator The address which initiated the transfer (i.e. msg.sender)
253         @param from The address which previously owned the token
254         @param id The ID of the token being transferred
255         @param value The amount of tokens being transferred
256         @param data Additional data with no specified format
257         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
258     */
259     function onERC1155Received(
260         address operator,
261         address from,
262         uint256 id,
263         uint256 value,
264         bytes calldata data
265     )
266         external
267         returns(bytes4);
268 
269     /**
270         @dev Handles the receipt of a multiple ERC1155 token types. This function
271         is called at the end of a `safeBatchTransferFrom` after the balances have
272         been updated. To accept the transfer(s), this must return
273         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
274         (i.e. 0xbc197c81, or its own function selector).
275         @param operator The address which initiated the batch transfer (i.e. msg.sender)
276         @param from The address which previously owned the token
277         @param ids An array containing ids of each token being transferred (order and length must match values array)
278         @param values An array containing amounts of each token being transferred (order and length must match ids array)
279         @param data Additional data with no specified format
280         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
281     */
282     function onERC1155BatchReceived(
283         address operator,
284         address from,
285         uint256[] calldata ids,
286         uint256[] calldata values,
287         bytes calldata data
288     )
289         external
290         returns(bytes4);
291 }
292 
293 
294 // File contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
295 
296 
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
302  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
303  *
304  * _Available since v3.1._
305  */
306 interface IERC1155MetadataURI is IERC1155 {
307     /**
308      * @dev Returns the URI for token type `id`.
309      *
310      * If the `\{id\}` substring is present in the URI, it must be replaced by
311      * clients with the actual token type ID.
312      */
313     function uri(uint256 id) external view returns (string memory);
314 }
315 
316 
317 // File contracts/utils/Address.sol
318 
319 
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Collection of functions related to the address type
325  */
326 library Address {
327     /**
328      * @dev Returns true if `account` is a contract.
329      *
330      * [IMPORTANT]
331      * ====
332      * It is unsafe to assume that an address for which this function returns
333      * false is an externally-owned account (EOA) and not a contract.
334      *
335      * Among others, `isContract` will return false for the following
336      * types of addresses:
337      *
338      *  - an externally-owned account
339      *  - a contract in construction
340      *  - an address where a contract will be created
341      *  - an address where a contract lived, but was destroyed
342      * ====
343      */
344     function isContract(address account) internal view returns (bool) {
345         // This method relies on extcodesize, which returns 0 for contracts in
346         // construction, since the code is only stored at the end of the
347         // constructor execution.
348 
349         uint256 size;
350         // solhint-disable-next-line no-inline-assembly
351         assembly { size := extcodesize(account) }
352         return size > 0;
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
375         (bool success, ) = recipient.call{ value: amount }("");
376         require(success, "Address: unable to send value, recipient may have reverted");
377     }
378 
379     /**
380      * @dev Performs a Solidity function call using a low level `call`. A
381      * plain`call` is an unsafe replacement for a function call: use this
382      * function instead.
383      *
384      * If `target` reverts with a revert reason, it is bubbled up by this
385      * function (like regular Solidity function calls).
386      *
387      * Returns the raw returned data. To convert to the expected return value,
388      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
389      *
390      * Requirements:
391      *
392      * - `target` must be a contract.
393      * - calling `target` with `data` must not revert.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
398       return functionCall(target, data, "Address: low-level call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
403      * `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but also transferring `value` wei to `target`.
414      *
415      * Requirements:
416      *
417      * - the calling contract must have an ETH balance of at least `value`.
418      * - the called Solidity function must be `payable`.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         require(isContract(target), "Address: call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.call{ value: value }(data);
438         return _verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
448         return functionStaticCall(target, data, "Address: low-level static call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         // solhint-disable-next-line avoid-low-level-calls
461         (bool success, bytes memory returndata) = target.staticcall(data);
462         return _verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a delegate call.
468      *
469      * _Available since v3.4._
470      */
471     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
472         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a delegate call.
478      *
479      * _Available since v3.4._
480      */
481     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
482         require(isContract(target), "Address: delegate call to non-contract");
483 
484         // solhint-disable-next-line avoid-low-level-calls
485         (bool success, bytes memory returndata) = target.delegatecall(data);
486         return _verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
490         if (success) {
491             return returndata;
492         } else {
493             // Look for revert reason and bubble it up if present
494             if (returndata.length > 0) {
495                 // The easiest way to bubble the revert reason is using memory via assembly
496 
497                 // solhint-disable-next-line no-inline-assembly
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 
510 // File contracts/utils/introspection/ERC165.sol
511 
512 
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Implementation of the {IERC165} interface.
518  *
519  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
520  * for the additional interface id that will be supported. For example:
521  *
522  * ```solidity
523  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
525  * }
526  * ```
527  *
528  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
529  */
530 abstract contract ERC165 is IERC165 {
531     /**
532      * @dev See {IERC165-supportsInterface}.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         return interfaceId == type(IERC165).interfaceId;
536     }
537 }
538 
539 
540 // File contracts/token/ERC1155/ERC1155.sol
541 
542 
543 
544 pragma solidity ^0.8.0;
545 
546 
547 
548 
549 
550 
551 /**
552  *
553  * @dev Implementation of the basic standard multi-token.
554  * See https://eips.ethereum.org/EIPS/eip-1155
555  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
556  *
557  * _Available since v3.1._
558  */
559 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
560     using Address for address;
561 
562     // Mapping from token ID to account balances
563     mapping (uint256 => mapping(address => uint256)) private _balances;
564 
565     // Mapping from account to operator approvals
566     mapping (address => mapping(address => bool)) private _operatorApprovals;
567 
568     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
569     string private _uri;
570 
571     /**
572      * @dev See {_setURI}.
573      */
574     constructor (string memory uri_) {
575         _setURI(uri_);
576     }
577 
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      */
581     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
582         return interfaceId == type(IERC1155).interfaceId
583             || interfaceId == type(IERC1155MetadataURI).interfaceId
584             || super.supportsInterface(interfaceId);
585     }
586 
587     /**
588      * @dev See {IERC1155MetadataURI-uri}.
589      *
590      * This implementation returns the same URI for *all* token types. It relies
591      * on the token type ID substitution mechanism
592      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
593      *
594      * Clients calling this function must replace the `\{id\}` substring with the
595      * actual token type ID.
596      */
597     function uri(uint256) public view virtual override returns (string memory) {
598         return _uri;
599     }
600 
601     /**
602      * @dev See {IERC1155-balanceOf}.
603      *
604      * Requirements:
605      *
606      * - `account` cannot be the zero address.
607      */
608     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
609         require(account != address(0), "ERC1155: balance query for the zero address");
610         return _balances[id][account];
611     }
612 
613     /**
614      * @dev See {IERC1155-balanceOfBatch}.
615      *
616      * Requirements:
617      *
618      * - `accounts` and `ids` must have the same length.
619      */
620     function balanceOfBatch(
621         address[] memory accounts,
622         uint256[] memory ids
623     )
624         public
625         view
626         virtual
627         override
628         returns (uint256[] memory)
629     {
630         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
631 
632         uint256[] memory batchBalances = new uint256[](accounts.length);
633 
634         for (uint256 i = 0; i < accounts.length; ++i) {
635             batchBalances[i] = balanceOf(accounts[i], ids[i]);
636         }
637 
638         return batchBalances;
639     }
640 
641     /**
642      * @dev See {IERC1155-setApprovalForAll}.
643      */
644     function setApprovalForAll(address operator, bool approved) public virtual override {
645         require(_msgSender() != operator, "ERC1155: setting approval status for self");
646 
647         _operatorApprovals[_msgSender()][operator] = approved;
648         emit ApprovalForAll(_msgSender(), operator, approved);
649     }
650 
651     /**
652      * @dev See {IERC1155-isApprovedForAll}.
653      */
654     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
655         return _operatorApprovals[account][operator];
656     }
657 
658     /**
659      * @dev See {IERC1155-safeTransferFrom}.
660      */
661     function safeTransferFrom(
662         address from,
663         address to,
664         uint256 id,
665         uint256 amount,
666         bytes memory data
667     )
668         public
669         virtual
670         override
671     {
672         require(to != address(0), "ERC1155: transfer to the zero address");
673         require(
674             from == _msgSender() || isApprovedForAll(from, _msgSender()),
675             "ERC1155: caller is not owner nor approved"
676         );
677 
678         address operator = _msgSender();
679 
680         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
681 
682         uint256 fromBalance = _balances[id][from];
683         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
684         _balances[id][from] = fromBalance - amount;
685         _balances[id][to] += amount;
686 
687         emit TransferSingle(operator, from, to, id, amount);
688 
689         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
690     }
691 
692     /**
693      * @dev See {IERC1155-safeBatchTransferFrom}.
694      */
695     function safeBatchTransferFrom(
696         address from,
697         address to,
698         uint256[] memory ids,
699         uint256[] memory amounts,
700         bytes memory data
701     )
702         public
703         virtual
704         override
705     {
706         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
707         require(to != address(0), "ERC1155: transfer to the zero address");
708         require(
709             from == _msgSender() || isApprovedForAll(from, _msgSender()),
710             "ERC1155: transfer caller is not owner nor approved"
711         );
712 
713         address operator = _msgSender();
714 
715         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
716 
717         for (uint256 i = 0; i < ids.length; ++i) {
718             uint256 id = ids[i];
719             uint256 amount = amounts[i];
720 
721             uint256 fromBalance = _balances[id][from];
722             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
723             _balances[id][from] = fromBalance - amount;
724             _balances[id][to] += amount;
725         }
726 
727         emit TransferBatch(operator, from, to, ids, amounts);
728 
729         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
730     }
731 
732     /**
733      * @dev Sets a new URI for all token types, by relying on the token type ID
734      * substitution mechanism
735      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
736      *
737      * By this mechanism, any occurrence of the `\{id\}` substring in either the
738      * URI or any of the amounts in the JSON file at said URI will be replaced by
739      * clients with the token type ID.
740      *
741      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
742      * interpreted by clients as
743      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
744      * for token type ID 0x4cce0.
745      *
746      * See {uri}.
747      *
748      * Because these URIs cannot be meaningfully represented by the {URI} event,
749      * this function emits no events.
750      */
751     function _setURI(string memory newuri) internal virtual {
752         _uri = newuri;
753     }
754 
755     /**
756      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
757      *
758      * Emits a {TransferSingle} event.
759      *
760      * Requirements:
761      *
762      * - `account` cannot be the zero address.
763      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
764      * acceptance magic value.
765      */
766     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
767         require(account != address(0), "ERC1155: mint to the zero address");
768 
769         address operator = _msgSender();
770 
771         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
772 
773         _balances[id][account] += amount;
774         emit TransferSingle(operator, address(0), account, id, amount);
775 
776         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
777     }
778 
779     /**
780      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
781      *
782      * Requirements:
783      *
784      * - `ids` and `amounts` must have the same length.
785      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
786      * acceptance magic value.
787      */
788     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
789         require(to != address(0), "ERC1155: mint to the zero address");
790         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
791 
792         address operator = _msgSender();
793 
794         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
795 
796         for (uint i = 0; i < ids.length; i++) {
797             _balances[ids[i]][to] += amounts[i];
798         }
799 
800         emit TransferBatch(operator, address(0), to, ids, amounts);
801 
802         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
803     }
804 
805     /**
806      * @dev Destroys `amount` tokens of token type `id` from `account`
807      *
808      * Requirements:
809      *
810      * - `account` cannot be the zero address.
811      * - `account` must have at least `amount` tokens of token type `id`.
812      */
813     function _burn(address account, uint256 id, uint256 amount) internal virtual {
814         require(account != address(0), "ERC1155: burn from the zero address");
815 
816         address operator = _msgSender();
817 
818         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
819 
820         uint256 accountBalance = _balances[id][account];
821         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
822         _balances[id][account] = accountBalance - amount;
823 
824         emit TransferSingle(operator, account, address(0), id, amount);
825     }
826 
827     /**
828      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
829      *
830      * Requirements:
831      *
832      * - `ids` and `amounts` must have the same length.
833      */
834     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
835         require(account != address(0), "ERC1155: burn from the zero address");
836         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
837 
838         address operator = _msgSender();
839 
840         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
841 
842         for (uint i = 0; i < ids.length; i++) {
843             uint256 id = ids[i];
844             uint256 amount = amounts[i];
845 
846             uint256 accountBalance = _balances[id][account];
847             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
848             _balances[id][account] = accountBalance - amount;
849         }
850 
851         emit TransferBatch(operator, account, address(0), ids, amounts);
852     }
853 
854     /**
855      * @dev Hook that is called before any token transfer. This includes minting
856      * and burning, as well as batched variants.
857      *
858      * The same hook is called on both single and batched variants. For single
859      * transfers, the length of the `id` and `amount` arrays will be 1.
860      *
861      * Calling conditions (for each `id` and `amount` pair):
862      *
863      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
864      * of token type `id` will be  transferred to `to`.
865      * - When `from` is zero, `amount` tokens of token type `id` will be minted
866      * for `to`.
867      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
868      * will be burned.
869      * - `from` and `to` are never both zero.
870      * - `ids` and `amounts` have the same, non-zero length.
871      *
872      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
873      */
874     function _beforeTokenTransfer(
875         address operator,
876         address from,
877         address to,
878         uint256[] memory ids,
879         uint256[] memory amounts,
880         bytes memory data
881     )
882         internal
883         virtual
884     { }
885 
886     function _doSafeTransferAcceptanceCheck(
887         address operator,
888         address from,
889         address to,
890         uint256 id,
891         uint256 amount,
892         bytes memory data
893     )
894         private
895     {
896         if (to.isContract()) {
897             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
898                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
899                     revert("ERC1155: ERC1155Receiver rejected tokens");
900                 }
901             } catch Error(string memory reason) {
902                 revert(reason);
903             } catch {
904                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
905             }
906         }
907     }
908 
909     function _doSafeBatchTransferAcceptanceCheck(
910         address operator,
911         address from,
912         address to,
913         uint256[] memory ids,
914         uint256[] memory amounts,
915         bytes memory data
916     )
917         private
918     {
919         if (to.isContract()) {
920             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
921                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
922                     revert("ERC1155: ERC1155Receiver rejected tokens");
923                 }
924             } catch Error(string memory reason) {
925                 revert(reason);
926             } catch {
927                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
928             }
929         }
930     }
931 
932     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
933         uint256[] memory array = new uint256[](1);
934         array[0] = element;
935 
936         return array;
937     }
938 }
939 
940 
941 // File contracts/utils/Strings.sol
942 
943 
944 
945 pragma solidity ^0.8.0;
946 
947 /**
948  * @dev String operations.
949  */
950 library Strings {
951     bytes16 private constant alphabet = "0123456789abcdef";
952 
953     /**
954      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
955      */
956     function toString(uint256 value) internal pure returns (string memory) {
957         // Inspired by OraclizeAPI's implementation - MIT licence
958         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
959 
960         if (value == 0) {
961             return "0";
962         }
963         uint256 temp = value;
964         uint256 digits;
965         while (temp != 0) {
966             digits++;
967             temp /= 10;
968         }
969         bytes memory buffer = new bytes(digits);
970         while (value != 0) {
971             digits -= 1;
972             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
973             value /= 10;
974         }
975         return string(buffer);
976     }
977 
978     /**
979      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
980      */
981     function toHexString(uint256 value) internal pure returns (string memory) {
982         if (value == 0) {
983             return "0x00";
984         }
985         uint256 temp = value;
986         uint256 length = 0;
987         while (temp != 0) {
988             length++;
989             temp >>= 8;
990         }
991         return toHexString(value, length);
992     }
993 
994     /**
995      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
996      */
997     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
998         bytes memory buffer = new bytes(2 * length + 2);
999         buffer[0] = "0";
1000         buffer[1] = "x";
1001         for (uint256 i = 2 * length + 1; i > 1; --i) {
1002             buffer[i] = alphabet[value & 0xf];
1003             value >>= 4;
1004         }
1005         require(value == 0, "Strings: hex length insufficient");
1006         return string(buffer);
1007     }
1008 
1009 }
1010 
1011 
1012 // File contracts/token/ERC1155/extensions/ERC1155MintByUser.sol
1013 
1014 
1015 
1016 
1017 
1018 pragma solidity ^0.8.0;
1019 
1020 contract ERC1155MintByUser is Ownable, ERC1155 {
1021     using Strings for uint256;
1022 
1023     mapping(uint256 => uint256) public tokenSupply;
1024     mapping(uint256 => string) public customUri;
1025 
1026     // Contract name
1027     string public name;
1028     // Contract symbol
1029     string public symbol;
1030 
1031     constructor(
1032         string memory _name,
1033         string memory _symbol,
1034         string memory _uri
1035     ) ERC1155(_uri) {
1036         name = _name;
1037         symbol = _symbol;
1038     }
1039 
1040     function uri(uint256 _id)
1041         public
1042         view
1043         virtual
1044         override
1045         returns (string memory)
1046     {
1047         bytes memory customUriBytes = bytes(customUri[_id]);
1048         if (customUriBytes.length > 0) {
1049             return customUri[_id];
1050         } else {
1051             return string(abi.encodePacked(super.uri(0), _id.toString()));
1052         }
1053     }
1054 
1055     function setURI(string memory newuri) public virtual onlyOwner {
1056         _setURI(newuri);
1057     }
1058 
1059     function setCustomURI(uint256 _tokenId, string memory _newURI)
1060         public
1061         virtual
1062         onlyOwner
1063     {
1064         customUri[_tokenId] = _newURI;
1065         emit URI(_newURI, _tokenId);
1066     }
1067 
1068     function _mintUpdateSupply(
1069         address _to,
1070         uint256 _id,
1071         uint256 _quantity,
1072         bytes memory _data
1073     ) internal virtual{
1074         _mint(_to, _id, _quantity, _data);
1075         tokenSupply[_id] += _quantity;
1076     }
1077 
1078 
1079     function burn(uint256 _id, uint256 _quantity) public virtual {
1080       _burn(_msgSender(), _id, _quantity);
1081     }
1082 
1083 }
1084 
1085 
1086 // File contracts/MICROPAYMENT/signature.sol
1087 
1088 
1089 
1090 pragma solidity ^0.8.6;
1091 
1092 contract  Signature {
1093 
1094 
1095     /// signature methods.
1096     function splitSignature(bytes memory sig)
1097         internal
1098         pure
1099         returns (uint8 v, bytes32 r, bytes32 s)
1100     {
1101         require(sig.length == 65);
1102 
1103         assembly {
1104             // first 32 bytes, after the length prefix.
1105             r := mload(add(sig, 32))
1106             // second 32 bytes.
1107             s := mload(add(sig, 64))
1108             // final byte (first byte of the next 32 bytes).
1109             v := byte(0, mload(add(sig, 96)))
1110         }
1111 
1112         return (v, r, s);
1113     }
1114 
1115     function recoverSigner(bytes32 message, bytes memory sig)
1116         internal
1117         pure
1118         returns (address)
1119     {
1120         (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
1121 
1122         return ecrecover(message, v, r, s);
1123     }
1124 
1125     /// builds a prefixed hash to mimic the behavior of eth_sign.
1126     function prefixed(bytes32 hash) internal pure returns (bytes32) {
1127         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1128     }
1129 
1130     function verifySignature(bytes32 _message , bytes memory _signature, address _signer) public pure returns (bool){
1131         return recoverSigner(_message, _signature) == _signer;
1132     }
1133 }
1134 
1135 
1136 // File contracts/security/ReentrancyGuard.sol
1137 
1138 
1139 
1140 pragma solidity ^0.8.0;
1141 
1142 /**
1143  * @dev Contract module that helps prevent reentrant calls to a function.
1144  *
1145  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1146  * available, which can be applied to functions to make sure there are no nested
1147  * (reentrant) calls to them.
1148  *
1149  * Note that because there is a single `nonReentrant` guard, functions marked as
1150  * `nonReentrant` may not call one another. This can be worked around by making
1151  * those functions `private`, and then adding `external` `nonReentrant` entry
1152  * points to them.
1153  *
1154  * TIP: If you would like to learn more about reentrancy and alternative ways
1155  * to protect against it, check out our blog post
1156  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1157  */
1158 abstract contract ReentrancyGuard {
1159     // Booleans are more expensive than uint256 or any type that takes up a full
1160     // word because each write operation emits an extra SLOAD to first read the
1161     // slot's contents, replace the bits taken up by the boolean, and then write
1162     // back. This is the compiler's defense against contract upgrades and
1163     // pointer aliasing, and it cannot be disabled.
1164 
1165     // The values being non-zero value makes deployment a bit more expensive,
1166     // but in exchange the refund on every call to nonReentrant will be lower in
1167     // amount. Since refunds are capped to a percentage of the total
1168     // transaction's gas, it is best to keep them low in cases like this one, to
1169     // increase the likelihood of the full refund coming into effect.
1170     uint256 private constant _NOT_ENTERED = 1;
1171     uint256 private constant _ENTERED = 2;
1172 
1173     uint256 private _status;
1174 
1175     constructor () {
1176         _status = _NOT_ENTERED;
1177     }
1178 
1179     /**
1180      * @dev Prevents a contract from calling itself, directly or indirectly.
1181      * Calling a `nonReentrant` function from another `nonReentrant`
1182      * function is not supported. It is possible to prevent this from happening
1183      * by making the `nonReentrant` function external, and make it call a
1184      * `private` function that does the actual work.
1185      */
1186     modifier nonReentrant() {
1187         // On the first call to nonReentrant, _notEntered will be true
1188         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1189 
1190         // Any calls to nonReentrant after this point will fail
1191         _status = _ENTERED;
1192 
1193         _;
1194 
1195         // By storing the original value once again, a refund is triggered (see
1196         // https://eips.ethereum.org/EIPS/eip-2200)
1197         _status = _NOT_ENTERED;
1198     }
1199 }
1200 
1201 
1202 // File contracts/BMWU/candy.sol
1203 
1204 
1205 
1206 pragma solidity ^0.8.6;
1207 
1208 
1209 
1210 contract BoredMummyWakingUpCandy is ERC1155MintByUser, Signature, ReentrancyGuard{
1211 
1212     event CandyUpgrade(address owner, uint256 useLv1Candy);
1213 
1214     mapping(uint256 => bool) public nonceUsed;
1215     address public bmhrr;
1216     bool public upgradeStart;
1217 
1218     constructor(
1219         string memory name_,
1220         string memory symbol_,
1221         string memory uri_
1222     ) ERC1155MintByUser(name_, symbol_, uri_) {}
1223 
1224     struct signParams {
1225         uint256 nonce;
1226         uint256 tokenId;
1227         uint256 amount;
1228         address receiver;
1229         uint256 expiration;
1230     }
1231 
1232     function setBmhrrAddress(address _bmhrr) public onlyOwner {
1233         bmhrr = _bmhrr;
1234     }
1235 
1236     function isApprovedForAll(address account, address operator) public view override returns (bool) {
1237         return super.isApprovedForAll(account, operator) || operator == bmhrr;
1238     }
1239 
1240     function mintBySignature(signParams calldata _p, bytes memory _signature) public nonReentrant{
1241         require(block.timestamp <= _p.expiration, "ticket expired");
1242         require(_msgSender() == _p.receiver, "can't claim by other");
1243         require(!nonceUsed[_p.nonce], "signature used");
1244         bytes32 message = prefixed(
1245             keccak256(abi.encodePacked(
1246                 _p.nonce,
1247                 _p.tokenId, 
1248                 _p.amount, 
1249                 _p.receiver,
1250                 _p.expiration
1251             ))
1252         );
1253         require(
1254             verifySignature(message, _signature, owner()),
1255             "verification failed"
1256         );
1257         nonceUsed[_p.nonce] = true;
1258         _mintUpdateSupply(_msgSender(), _p.tokenId, _p.amount, "");
1259     }
1260 
1261     function setUpgradeStart(bool _start) public onlyOwner{
1262         upgradeStart = _start;
1263     }
1264 
1265     function upgradeCandy(uint256 useLv1Candy) payable public nonReentrant{
1266         require(upgradeStart, "upgrade not started");
1267         require(tokenSupply[2] < 3888, "too many H2 candies");
1268         require(0 < useLv1Candy && useLv1Candy < 4, "wrong candy number");
1269         if(useLv1Candy == 1){
1270             require(msg.value == 150000000000000000, "value error");
1271             payable(owner()).transfer(msg.value);
1272         }
1273         if(useLv1Candy == 2){
1274             require(msg.value == 80000000000000000, "value error");
1275             payable(owner()).transfer(msg.value);
1276         }
1277         burn(1, useLv1Candy);
1278         _mintUpdateSupply(_msgSender(), 2, 1, "");
1279         emit CandyUpgrade(_msgSender(),useLv1Candy);
1280     }
1281 
1282 }