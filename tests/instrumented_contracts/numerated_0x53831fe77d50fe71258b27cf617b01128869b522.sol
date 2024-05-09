1 /*
2     AMOEA Universe Passport
3 */
4 pragma solidity 0.8.10;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 /**
29  * @dev Implementation of the {IERC165} interface.
30  *
31  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
32  * for the additional interface id that will be supported. For example:
33  *
34  * ```solidity
35  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
36  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
37  * }
38  * ```
39  *
40  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
41  */
42 abstract contract ERC165 is IERC165 {
43     /**
44      * @dev See {IERC165-supportsInterface}.
45      */
46     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
47         return interfaceId == type(IERC165).interfaceId;
48     }
49 }
50 
51 /**
52  * @dev Provides information about the current execution context, including the
53  * sender of the transaction and its data. While these are generally available
54  * via msg.sender and msg.data, they should not be accessed in such a direct
55  * manner, since when dealing with meta-transactions the account sending and
56  * paying for execution may not be the actual sender (as far as an application
57  * is concerned).
58  *
59  * This contract is only required for intermediate, library-like contracts.
60  */
61 abstract contract Context {
62     function _msgSender() internal view virtual returns (address) {
63         return msg.sender;
64     }
65 
66     function _msgData() internal view virtual returns (bytes calldata) {
67         return msg.data;
68     }
69 }
70 
71 /**
72  * @dev Contract module which provides a basic access control mechanism, where
73  * there is an account (an owner) that can be granted exclusive access to
74  * specific functions.
75  *
76  * By default, the owner account will be the one that deploys the contract. This
77  * can later be changed with {transferOwnership}.
78  *
79  * This module is used through inheritance. It will make available the modifier
80  * `onlyOwner`, which can be applied to your functions to restrict their use to
81  * the owner.
82  */
83 abstract contract Ownable is Context {
84     address private _owner;
85 
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     /**
89      * @dev Initializes the contract setting the deployer as the initial owner.
90      */
91     constructor() {
92         _setOwner(_msgSender());
93     }
94 
95     /**
96      * @dev Returns the address of the current owner.
97      */
98     function owner() public view virtual returns (address) {
99         return _owner;
100     }
101 
102     /**
103      * @dev Throws if called by any account other than the owner.
104      */
105     modifier onlyOwner() {
106         require(owner() == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110     /**
111      * @dev Leaves the contract without owner. It will not be possible to call
112      * `onlyOwner` functions anymore. Can only be called by the current owner.
113      *
114      * NOTE: Renouncing ownership will leave the contract without an owner,
115      * thereby removing any functionality that is only available to the owner.
116      */
117     function renounceOwnership() public virtual onlyOwner {
118         _setOwner(address(0));
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Can only be called by the current owner.
124      */
125     function transferOwnership(address newOwner) public virtual onlyOwner {
126         require(newOwner != address(0), "Ownable: new owner is the zero address");
127         _setOwner(newOwner);
128     }
129 
130     function _setOwner(address newOwner) private {
131         address oldOwner = _owner;
132         _owner = newOwner;
133         emit OwnershipTransferred(oldOwner, newOwner);
134     }
135 }
136 
137 /**
138  * @dev Collection of functions related to the address type
139  */
140 library Address {
141     /**
142      * @dev Returns true if `account` is a contract.
143      *
144      * [IMPORTANT]
145      * ====
146      * It is unsafe to assume that an address for which this function returns
147      * false is an externally-owned account (EOA) and not a contract.
148      *
149      * Among others, `isContract` will return false for the following
150      * types of addresses:
151      *
152      *  - an externally-owned account
153      *  - a contract in construction
154      *  - an address where a contract will be created
155      *  - an address where a contract lived, but was destroyed
156      * ====
157      */
158     function isContract(address account) internal view returns (bool) {
159         // This method relies on extcodesize, which returns 0 for contracts in
160         // construction, since the code is only stored at the end of the
161         // constructor execution.
162 
163         uint256 size;
164         assembly {
165             size := extcodesize(account)
166         }
167         return size > 0;
168     }
169 
170     /**
171      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
172      * `recipient`, forwarding all available gas and reverting on errors.
173      *
174      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
175      * of certain opcodes, possibly making contracts go over the 2300 gas limit
176      * imposed by `transfer`, making them unable to receive funds via
177      * `transfer`. {sendValue} removes this limitation.
178      *
179      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
180      *
181      * IMPORTANT: because control is transferred to `recipient`, care must be
182      * taken to not create reentrancy vulnerabilities. Consider using
183      * {ReentrancyGuard} or the
184      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
185      */
186     function sendValue(address payable recipient, uint256 amount) internal {
187         require(address(this).balance >= amount, "Address: insufficient balance");
188 
189         (bool success, ) = recipient.call{value: amount}("");
190         require(success, "Address: unable to send value, recipient may have reverted");
191     }
192 
193     /**
194      * @dev Performs a Solidity function call using a low level `call`. A
195      * plain `call` is an unsafe replacement for a function call: use this
196      * function instead.
197      *
198      * If `target` reverts with a revert reason, it is bubbled up by this
199      * function (like regular Solidity function calls).
200      *
201      * Returns the raw returned data. To convert to the expected return value,
202      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
203      *
204      * Requirements:
205      *
206      * - `target` must be a contract.
207      * - calling `target` with `data` must not revert.
208      *
209      * _Available since v3.1._
210      */
211     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
212         return functionCall(target, data, "Address: low-level call failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
217      * `errorMessage` as a fallback revert reason when `target` reverts.
218      *
219      * _Available since v3.1._
220      */
221     function functionCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, 0, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but also transferring `value` wei to `target`.
232      *
233      * Requirements:
234      *
235      * - the calling contract must have an ETH balance of at least `value`.
236      * - the called Solidity function must be `payable`.
237      *
238      * _Available since v3.1._
239      */
240     function functionCallWithValue(
241         address target,
242         bytes memory data,
243         uint256 value
244     ) internal returns (bytes memory) {
245         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
250      * with `errorMessage` as a fallback revert reason when `target` reverts.
251      *
252      * _Available since v3.1._
253      */
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(address(this).balance >= value, "Address: insufficient balance for call");
261         require(isContract(target), "Address: call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.call{value: value}(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a static call.
270      *
271      * _Available since v3.3._
272      */
273     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
274         return functionStaticCall(target, data, "Address: low-level static call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a static call.
280      *
281      * _Available since v3.3._
282      */
283     function functionStaticCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal view returns (bytes memory) {
288         require(isContract(target), "Address: static call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.staticcall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but performing a delegate call.
297      *
298      * _Available since v3.4._
299      */
300     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
301         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
306      * but performing a delegate call.
307      *
308      * _Available since v3.4._
309      */
310     function functionDelegateCall(
311         address target,
312         bytes memory data,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(isContract(target), "Address: delegate call to non-contract");
316 
317         (bool success, bytes memory returndata) = target.delegatecall(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
323      * revert reason using the provided one.
324      *
325      * _Available since v4.3._
326      */
327     function verifyCallResult(
328         bool success,
329         bytes memory returndata,
330         string memory errorMessage
331     ) internal pure returns (bytes memory) {
332         if (success) {
333             return returndata;
334         } else {
335             // Look for revert reason and bubble it up if present
336             if (returndata.length > 0) {
337                 // The easiest way to bubble the revert reason is using memory via assembly
338 
339                 assembly {
340                     let returndata_size := mload(returndata)
341                     revert(add(32, returndata), returndata_size)
342                 }
343             } else {
344                 revert(errorMessage);
345             }
346         }
347     }
348 }
349 
350 /**
351  * @dev Required interface of an ERC1155 compliant contract, as defined in the
352  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
353  *
354  * _Available since v3.1._
355  */
356 interface IERC1155 is IERC165 {
357     /**
358      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
359      */
360     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
361 
362     /**
363      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
364      * transfers.
365      */
366     event TransferBatch(
367         address indexed operator,
368         address indexed from,
369         address indexed to,
370         uint256[] ids,
371         uint256[] values
372     );
373 
374     /**
375      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
376      * `approved`.
377      */
378     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
379 
380     /**
381      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
382      *
383      * If an {URI} event was emitted for `id`, the standard
384      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
385      * returned by {IERC1155MetadataURI-uri}.
386      */
387     event URI(string value, uint256 indexed id);
388 
389     /**
390      * @dev Returns the amount of tokens of token type `id` owned by `account`.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      */
396     function balanceOf(address account, uint256 id) external view returns (uint256);
397 
398     /**
399      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
400      *
401      * Requirements:
402      *
403      * - `accounts` and `ids` must have the same length.
404      */
405     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
406         external
407         view
408         returns (uint256[] memory);
409 
410     /**
411      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
412      *
413      * Emits an {ApprovalForAll} event.
414      *
415      * Requirements:
416      *
417      * - `operator` cannot be the caller.
418      */
419     function setApprovalForAll(address operator, bool approved) external;
420 
421     /**
422      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
423      *
424      * See {setApprovalForAll}.
425      */
426     function isApprovedForAll(address account, address operator) external view returns (bool);
427 
428     /**
429      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
430      *
431      * Emits a {TransferSingle} event.
432      *
433      * Requirements:
434      *
435      * - `to` cannot be the zero address.
436      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
437      * - `from` must have a balance of tokens of type `id` of at least `amount`.
438      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
439      * acceptance magic value.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 id,
445         uint256 amount,
446         bytes calldata data
447     ) external;
448 
449     /**
450      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
451      *
452      * Emits a {TransferBatch} event.
453      *
454      * Requirements:
455      *
456      * - `ids` and `amounts` must have the same length.
457      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
458      * acceptance magic value.
459      */
460     function safeBatchTransferFrom(
461         address from,
462         address to,
463         uint256[] calldata ids,
464         uint256[] calldata amounts,
465         bytes calldata data
466     ) external;
467 }
468 
469 /**
470  * @dev _Available since v3.1._
471  */
472 interface IERC1155Receiver is IERC165 {
473     /**
474         @dev Handles the receipt of a single ERC1155 token type. This function is
475         called at the end of a `safeTransferFrom` after the balance has been updated.
476         To accept the transfer, this must return
477         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
478         (i.e. 0xf23a6e61, or its own function selector).
479         @param operator The address which initiated the transfer (i.e. msg.sender)
480         @param from The address which previously owned the token
481         @param id The ID of the token being transferred
482         @param value The amount of tokens being transferred
483         @param data Additional data with no specified format
484         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
485     */
486     function onERC1155Received(
487         address operator,
488         address from,
489         uint256 id,
490         uint256 value,
491         bytes calldata data
492     ) external returns (bytes4);
493 
494     /**
495         @dev Handles the receipt of a multiple ERC1155 token types. This function
496         is called at the end of a `safeBatchTransferFrom` after the balances have
497         been updated. To accept the transfer(s), this must return
498         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
499         (i.e. 0xbc197c81, or its own function selector).
500         @param operator The address which initiated the batch transfer (i.e. msg.sender)
501         @param from The address which previously owned the token
502         @param ids An array containing ids of each token being transferred (order and length must match values array)
503         @param values An array containing amounts of each token being transferred (order and length must match ids array)
504         @param data Additional data with no specified format
505         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
506     */
507     function onERC1155BatchReceived(
508         address operator,
509         address from,
510         uint256[] calldata ids,
511         uint256[] calldata values,
512         bytes calldata data
513     ) external returns (bytes4);
514 }
515 
516 /**
517  * @dev _Available since v3.1._
518  */
519 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
520     /**
521      * @dev See {IERC165-supportsInterface}.
522      */
523     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
524         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
525     }
526 }
527 
528 
529 /**
530  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
531  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
532  *
533  * _Available since v3.1._
534  */
535 interface IERC1155MetadataURI is IERC1155 {
536     /**
537      * @dev Returns the URI for token type `id`.
538      *
539      * If the `\{id\}` substring is present in the URI, it must be replaced by
540      * clients with the actual token type ID.
541      */
542     function uri(uint256 id) external view returns (string memory);
543 }
544 
545 /**
546  * @dev Implementation of the basic standard multi-token.
547  * See https://eips.ethereum.org/EIPS/eip-1155
548  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
549  *
550  * _Available since v3.1._
551  */
552 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
553     using Address for address;
554 
555     // Mapping from token ID to account balances
556     mapping(uint256 => mapping(address => uint256)) private _balances;
557 
558     // Mapping from account to operator approvals
559     mapping(address => mapping(address => bool)) private _operatorApprovals;
560 
561     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
562     mapping(uint256 => string) private _tokenURIs;
563 
564     /**
565      * @dev See {_setURI}.
566      */
567     constructor() {
568         
569     }
570 
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
575         return
576             interfaceId == type(IERC1155).interfaceId ||
577             interfaceId == type(IERC1155MetadataURI).interfaceId ||
578             super.supportsInterface(interfaceId);
579     }
580 
581     /**
582      * @dev See {IERC1155MetadataURI-uri}.
583      *
584      * This implementation returns the same URI for *all* token types. It relies
585      * on the token type ID substitution mechanism
586      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
587      *
588      * Clients calling this function must replace the `\{id\}` substring with the
589      * actual token type ID.
590      */
591     function uri(uint256 tokenId) public view virtual override returns (string memory) {
592         return _tokenURIs[tokenId];
593     }
594 
595     /**
596      * @dev See {IERC1155-balanceOf}.
597      *
598      * Requirements:
599      *
600      * - `account` cannot be the zero address.
601      */
602     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
603         require(account != address(0), "ERC1155: balance query for the zero address");
604         return _balances[id][account];
605     }
606 
607     /**
608      * @dev See {IERC1155-balanceOfBatch}.
609      *
610      * Requirements:
611      *
612      * - `accounts` and `ids` must have the same length.
613      */
614     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
615         public
616         view
617         virtual
618         override
619         returns (uint256[] memory)
620     {
621         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
622 
623         uint256[] memory batchBalances = new uint256[](accounts.length);
624 
625         for (uint256 i = 0; i < accounts.length; ++i) {
626             batchBalances[i] = balanceOf(accounts[i], ids[i]);
627         }
628 
629         return batchBalances;
630     }
631 
632     /**
633      * @dev See {IERC1155-setApprovalForAll}.
634      */
635     function setApprovalForAll(address operator, bool approved) public virtual override {
636         require(_msgSender() != operator, "ERC1155: setting approval status for self");
637 
638         _operatorApprovals[_msgSender()][operator] = approved;
639         emit ApprovalForAll(_msgSender(), operator, approved);
640     }
641 
642     /**
643      * @dev See {IERC1155-isApprovedForAll}.
644      */
645     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
646         return _operatorApprovals[account][operator];
647     }
648 
649     /**
650      * @dev See {IERC1155-safeTransferFrom}.
651      */
652     function safeTransferFrom(
653         address from,
654         address to,
655         uint256 id,
656         uint256 amount,
657         bytes memory data
658     ) public virtual override {
659         require(
660             from == _msgSender() || isApprovedForAll(from, _msgSender()),
661             "ERC1155: caller is not owner nor approved"
662         );
663         _safeTransferFrom(from, to, id, amount, data);
664     }
665 
666     /**
667      * @dev See {IERC1155-safeBatchTransferFrom}.
668      */
669     function safeBatchTransferFrom(
670         address from,
671         address to,
672         uint256[] memory ids,
673         uint256[] memory amounts,
674         bytes memory data
675     ) public virtual override {
676         require(
677             from == _msgSender() || isApprovedForAll(from, _msgSender()),
678             "ERC1155: transfer caller is not owner nor approved"
679         );
680         _safeBatchTransferFrom(from, to, ids, amounts, data);
681     }
682 
683     /**
684      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
685      *
686      * Emits a {TransferSingle} event.
687      *
688      * Requirements:
689      *
690      * - `to` cannot be the zero address.
691      * - `from` must have a balance of tokens of type `id` of at least `amount`.
692      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
693      * acceptance magic value.
694      */
695     function _safeTransferFrom(
696         address from,
697         address to,
698         uint256 id,
699         uint256 amount,
700         bytes memory data
701     ) internal virtual {
702         require(to != address(0), "ERC1155: transfer to the zero address");
703 
704         address operator = _msgSender();
705 
706         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
707 
708         uint256 fromBalance = _balances[id][from];
709         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
710         unchecked {
711             _balances[id][from] = fromBalance - amount;
712         }
713         _balances[id][to] += amount;
714 
715         emit TransferSingle(operator, from, to, id, amount);
716 
717         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
718     }
719 
720     /**
721      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
722      *
723      * Emits a {TransferBatch} event.
724      *
725      * Requirements:
726      *
727      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
728      * acceptance magic value.
729      */
730     function _safeBatchTransferFrom(
731         address from,
732         address to,
733         uint256[] memory ids,
734         uint256[] memory amounts,
735         bytes memory data
736     ) internal virtual {
737         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
738         require(to != address(0), "ERC1155: transfer to the zero address");
739 
740         address operator = _msgSender();
741 
742         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
743 
744         for (uint256 i = 0; i < ids.length; ++i) {
745             uint256 id = ids[i];
746             uint256 amount = amounts[i];
747 
748             uint256 fromBalance = _balances[id][from];
749             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
750             unchecked {
751                 _balances[id][from] = fromBalance - amount;
752             }
753             _balances[id][to] += amount;
754         }
755 
756         emit TransferBatch(operator, from, to, ids, amounts);
757 
758         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
759     }
760 
761     /**
762      * @dev Sets a new URI for all token types, by relying on the token type ID
763      * substitution mechanism
764      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
765      *
766      * By this mechanism, any occurrence of the `\{id\}` substring in either the
767      * URI or any of the amounts in the JSON file at said URI will be replaced by
768      * clients with the token type ID.
769      *
770      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
771      * interpreted by clients as
772      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
773      * for token type ID 0x4cce0.
774      *
775      * See {uri}.
776      *
777      * Because these URIs cannot be meaningfully represented by the {URI} event,
778      * this function emits no events.
779      */
780     function _setURI(uint256 tokenId, string memory newuri) internal virtual {
781         _tokenURIs[tokenId] = newuri;
782     }
783 
784     /**
785      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
786      *
787      * Emits a {TransferSingle} event.
788      *
789      * Requirements:
790      *
791      * - `account` cannot be the zero address.
792      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
793      * acceptance magic value.
794      */
795     function _mint(
796         address account,
797         uint256 id,
798         uint256 amount,
799         bytes memory data
800     ) internal virtual {
801         require(account != address(0), "ERC1155: mint to the zero address");
802 
803         address operator = _msgSender();
804 
805         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
806 
807         _balances[id][account] += amount;
808         emit TransferSingle(operator, address(0), account, id, amount);
809 
810         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
811     }
812 
813     /**
814      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
815      *
816      * Requirements:
817      *
818      * - `ids` and `amounts` must have the same length.
819      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
820      * acceptance magic value.
821      */
822     function _mintBatch(
823         address to,
824         uint256[] memory ids,
825         uint256[] memory amounts,
826         bytes memory data
827     ) internal virtual {
828         require(to != address(0), "ERC1155: mint to the zero address");
829         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
830 
831         address operator = _msgSender();
832 
833         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
834 
835         for (uint256 i = 0; i < ids.length; i++) {
836             _balances[ids[i]][to] += amounts[i];
837         }
838 
839         emit TransferBatch(operator, address(0), to, ids, amounts);
840 
841         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
842     }
843 
844     /**
845      * @dev Destroys `amount` tokens of token type `id` from `account`
846      *
847      * Requirements:
848      *
849      * - `account` cannot be the zero address.
850      * - `account` must have at least `amount` tokens of token type `id`.
851      */
852     function _burn(
853         address account,
854         uint256 id,
855         uint256 amount
856     ) internal virtual {
857         require(account != address(0), "ERC1155: burn from the zero address");
858 
859         address operator = _msgSender();
860 
861         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
862 
863         uint256 accountBalance = _balances[id][account];
864         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
865         unchecked {
866             _balances[id][account] = accountBalance - amount;
867         }
868 
869         emit TransferSingle(operator, account, address(0), id, amount);
870     }
871 
872     /**
873      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
874      *
875      * Requirements:
876      *
877      * - `ids` and `amounts` must have the same length.
878      */
879     function _burnBatch(
880         address account,
881         uint256[] memory ids,
882         uint256[] memory amounts
883     ) internal virtual {
884         require(account != address(0), "ERC1155: burn from the zero address");
885         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
886 
887         address operator = _msgSender();
888 
889         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
890 
891         for (uint256 i = 0; i < ids.length; i++) {
892             uint256 id = ids[i];
893             uint256 amount = amounts[i];
894 
895             uint256 accountBalance = _balances[id][account];
896             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
897             unchecked {
898                 _balances[id][account] = accountBalance - amount;
899             }
900         }
901 
902         emit TransferBatch(operator, account, address(0), ids, amounts);
903     }
904 
905     /**
906      * @dev Hook that is called before any token transfer. This includes minting
907      * and burning, as well as batched variants.
908      *
909      * The same hook is called on both single and batched variants. For single
910      * transfers, the length of the `id` and `amount` arrays will be 1.
911      *
912      * Calling conditions (for each `id` and `amount` pair):
913      *
914      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
915      * of token type `id` will be  transferred to `to`.
916      * - When `from` is zero, `amount` tokens of token type `id` will be minted
917      * for `to`.
918      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
919      * will be burned.
920      * - `from` and `to` are never both zero.
921      * - `ids` and `amounts` have the same, non-zero length.
922      *
923      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
924      */
925     function _beforeTokenTransfer(
926         address operator,
927         address from,
928         address to,
929         uint256[] memory ids,
930         uint256[] memory amounts,
931         bytes memory data
932     ) internal virtual {}
933 
934     function _doSafeTransferAcceptanceCheck(
935         address operator,
936         address from,
937         address to,
938         uint256 id,
939         uint256 amount,
940         bytes memory data
941     ) private {
942         if (to.isContract()) {
943             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
944                 if (response != IERC1155Receiver.onERC1155Received.selector) {
945                     revert("ERC1155: ERC1155Receiver rejected tokens");
946                 }
947             } catch Error(string memory reason) {
948                 revert(reason);
949             } catch {
950                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
951             }
952         }
953     }
954 
955     function _doSafeBatchTransferAcceptanceCheck(
956         address operator,
957         address from,
958         address to,
959         uint256[] memory ids,
960         uint256[] memory amounts,
961         bytes memory data
962     ) private {
963         if (to.isContract()) {
964             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
965                 bytes4 response
966             ) {
967                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
968                     revert("ERC1155: ERC1155Receiver rejected tokens");
969                 }
970             } catch Error(string memory reason) {
971                 revert(reason);
972             } catch {
973                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
974             }
975         }
976     }
977 
978     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
979         uint256[] memory array = new uint256[](1);
980         array[0] = element;
981 
982         return array;
983     }
984 }
985 
986 abstract contract ReentrancyGuard {
987     // Booleans are more expensive than uint256 or any type that takes up a full
988     // word because each write operation emits an extra SLOAD to first read the
989     // slot's contents, replace the bits taken up by the boolean, and then write
990     // back. This is the compiler's defense against contract upgrades and
991     // pointer aliasing, and it cannot be disabled.
992 
993     // The values being non-zero value makes deployment a bit more expensive,
994     // but in exchange the refund on every call to nonReentrant will be lower in
995     // amount. Since refunds are capped to a percentage of the total
996     // transaction's gas, it is best to keep them low in cases like this one, to
997     // increase the likelihood of the full refund coming into effect.
998     uint256 private constant _NOT_ENTERED = 1;
999     uint256 private constant _ENTERED = 2;
1000 
1001     uint256 private _status;
1002 
1003     constructor() {
1004         _status = _NOT_ENTERED;
1005     }
1006 
1007     /**
1008      * @dev Prevents a contract from calling itself, directly or indirectly.
1009      * Calling a `nonReentrant` function from another `nonReentrant`
1010      * function is not supported. It is possible to prevent this from happening
1011      * by making the `nonReentrant` function external, and making it call a
1012      * `private` function that does the actual work.
1013      */
1014     modifier nonReentrant() {
1015         // On the first call to nonReentrant, _notEntered will be true
1016         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1017 
1018         // Any calls to nonReentrant after this point will fail
1019         _status = _ENTERED;
1020 
1021         _;
1022 
1023         // By storing the original value once again, a refund is triggered (see
1024         // https://eips.ethereum.org/EIPS/eip-2200)
1025         _status = _NOT_ENTERED;
1026     }
1027 }
1028 
1029 contract AMOEAUniversePassport is ERC1155, Ownable, ReentrancyGuard
1030 {
1031     //Minting limit
1032     mapping(uint256 => uint256) private _mintLimit;
1033 
1034     //Minting tokenid
1035     uint16 MINTING_TOKEN_ID = 1;
1036 
1037     //Record amout of tokenid
1038     mapping(uint16 => uint16) private _tokenCount;
1039 
1040     //Record the number of address mint
1041     mapping(address => uint16) private _mintCount;
1042 
1043     //Limit the number of address mint
1044     uint16 _mintLimitForAddress = 1;
1045 
1046     event Mint(address indexed user, uint256 indexed tokenId, uint256 amount);
1047 
1048     constructor() ERC1155(){
1049        _setURI(MINTING_TOKEN_ID, "https://cdn.amoea.io/nft/amoea-universe-passport/TypeA/passport-1155.json");
1050        _mintLimit[MINTING_TOKEN_ID] = 10000;
1051     }
1052 
1053     function setNowMintTokenID(uint16 mintTokenId) public onlyOwner
1054     {
1055         MINTING_TOKEN_ID = mintTokenId;
1056     }
1057 
1058     function setNowMintTokenMintLimit(uint16 tokenId, uint16 mintLimit) public onlyOwner
1059     {
1060         _mintLimit[tokenId] = mintLimit;
1061     }
1062 
1063     function setURI(uint16 tokenId, string memory newuri) public onlyOwner
1064     {
1065         _setURI(tokenId, newuri);
1066     }
1067 
1068     function getTotalSupplyByTokenId(uint16 tokenId) public view returns (uint256)
1069     {
1070         return _tokenCount[tokenId];
1071     }
1072 
1073     function getMintLimitByTokenId(uint16 tokenId) public view returns (uint256)
1074     {
1075         return _mintLimit[tokenId];
1076     }
1077 
1078     function getMintLimitForAddress() public view returns (uint256)
1079     {
1080         return _mintLimitForAddress;
1081     }
1082 
1083     function getTotalSupplyByAddress(address addr) public view returns (uint16)
1084     {
1085         return _mintCount[addr];
1086     }
1087 
1088     function setMintLimit(uint16 mintLimit) public onlyOwner
1089     {
1090         _mintLimitForAddress = mintLimit;
1091     }
1092 
1093     function multiMint(uint16 tokenId, uint16 count) public onlyOwner
1094     {
1095         address to = _msgSender();
1096         _tokenCount[tokenId] += count;
1097         _mint(to, tokenId, count, "");
1098 
1099         emit Mint(to, tokenId, count);
1100     }
1101 
1102     function freeMint() public nonReentrant
1103     {
1104         require(_mintCount[_msgSender()] < _mintLimitForAddress, "Too many mint");
1105         require(_tokenCount[MINTING_TOKEN_ID] < _mintLimit[MINTING_TOKEN_ID], "Sold out");
1106         
1107         address to = _msgSender();
1108         _mintCount[to] += 1;
1109         _tokenCount[MINTING_TOKEN_ID] += 1;
1110         _mint(to, MINTING_TOKEN_ID, 1, "");
1111 
1112         emit Mint(to, MINTING_TOKEN_ID, 1);
1113     }
1114 }