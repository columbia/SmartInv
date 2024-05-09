1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Initializes the contract setting the deployer as the initial owner.
22      */
23     constructor() {
24         _setOwner(_msgSender());
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Leaves the contract without owner. It will not be possible to call
44      * `onlyOwner` functions anymore. Can only be called by the current owner.
45      *
46      * NOTE: Renouncing ownership will leave the contract without an owner,
47      * thereby removing any functionality that is only available to the owner.
48      */
49     function renounceOwnership() public virtual onlyOwner {
50         _setOwner(address(0));
51     }
52 
53     /**
54      * @dev Transfers ownership of the contract to a new account (`newOwner`).
55      * Can only be called by the current owner.
56      */
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _setOwner(newOwner);
60     }
61 
62     function _setOwner(address newOwner) private {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Address.sol
70 
71 /**
72  * @dev Collection of functions related to the address type
73  */
74 library Address {
75     /**
76      * @dev Returns true if `account` is a contract.
77      *
78      * [IMPORTANT]
79      * ====
80      * It is unsafe to assume that an address for which this function returns
81      * false is an externally-owned account (EOA) and not a contract.
82      *
83      * Among others, `isContract` will return false for the following
84      * types of addresses:
85      *
86      *  - an externally-owned account
87      *  - a contract in construction
88      *  - an address where a contract will be created
89      *  - an address where a contract lived, but was destroyed
90      * ====
91      */
92     function isContract(address account) internal view returns (bool) {
93         // This method relies on extcodesize, which returns 0 for contracts in
94         // construction, since the code is only stored at the end of the
95         // constructor execution.
96 
97         uint256 size;
98         assembly {
99             size := extcodesize(account)
100         }
101         return size > 0;
102     }
103 
104     /**
105      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
106      * `recipient`, forwarding all available gas and reverting on errors.
107      *
108      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
109      * of certain opcodes, possibly making contracts go over the 2300 gas limit
110      * imposed by `transfer`, making them unable to receive funds via
111      * `transfer`. {sendValue} removes this limitation.
112      *
113      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
114      *
115      * IMPORTANT: because control is transferred to `recipient`, care must be
116      * taken to not create reentrancy vulnerabilities. Consider using
117      * {ReentrancyGuard} or the
118      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
119      */
120     function sendValue(address payable recipient, uint256 amount) internal {
121         require(address(this).balance >= amount, "Address: insufficient balance");
122 
123         (bool success, ) = recipient.call{value: amount}("");
124         require(success, "Address: unable to send value, recipient may have reverted");
125     }
126 
127     /**
128      * @dev Performs a Solidity function call using a low level `call`. A
129      * plain `call` is an unsafe replacement for a function call: use this
130      * function instead.
131      *
132      * If `target` reverts with a revert reason, it is bubbled up by this
133      * function (like regular Solidity function calls).
134      *
135      * Returns the raw returned data. To convert to the expected return value,
136      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
137      *
138      * Requirements:
139      *
140      * - `target` must be a contract.
141      * - calling `target` with `data` must not revert.
142      *
143      * _Available since v3.1._
144      */
145     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
146         return functionCall(target, data, "Address: low-level call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
151      * `errorMessage` as a fallback revert reason when `target` reverts.
152      *
153      * _Available since v3.1._
154      */
155     function functionCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal returns (bytes memory) {
160         return functionCallWithValue(target, data, 0, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
165      * but also transferring `value` wei to `target`.
166      *
167      * Requirements:
168      *
169      * - the calling contract must have an ETH balance of at least `value`.
170      * - the called Solidity function must be `payable`.
171      *
172      * _Available since v3.1._
173      */
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
184      * with `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(address(this).balance >= value, "Address: insufficient balance for call");
195         require(isContract(target), "Address: call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.call{value: value}(data);
198         return verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but performing a static call.
204      *
205      * _Available since v3.3._
206      */
207     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
208         return functionStaticCall(target, data, "Address: low-level static call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
213      * but performing a static call.
214      *
215      * _Available since v3.3._
216      */
217     function functionStaticCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal view returns (bytes memory) {
222         require(isContract(target), "Address: static call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.staticcall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but performing a delegate call.
231      *
232      * _Available since v3.4._
233      */
234     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
235         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
240      * but performing a delegate call.
241      *
242      * _Available since v3.4._
243      */
244     function functionDelegateCall(
245         address target,
246         bytes memory data,
247         string memory errorMessage
248     ) internal returns (bytes memory) {
249         require(isContract(target), "Address: delegate call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.delegatecall(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
257      * revert reason using the provided one.
258      *
259      * _Available since v4.3._
260      */
261     function verifyCallResult(
262         bool success,
263         bytes memory returndata,
264         string memory errorMessage
265     ) internal pure returns (bytes memory) {
266         if (success) {
267             return returndata;
268         } else {
269             // Look for revert reason and bubble it up if present
270             if (returndata.length > 0) {
271                 // The easiest way to bubble the revert reason is using memory via assembly
272 
273                 assembly {
274                     let returndata_size := mload(returndata)
275                     revert(add(32, returndata), returndata_size)
276                 }
277             } else {
278                 revert(errorMessage);
279             }
280         }
281     }
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
285 
286 /**
287  * @dev Interface of the ERC165 standard, as defined in the
288  * https://eips.ethereum.org/EIPS/eip-165[EIP].
289  *
290  * Implementers can declare support of contract interfaces, which can then be
291  * queried by others ({ERC165Checker}).
292  *
293  * For an implementation, see {ERC165}.
294  */
295 interface IERC165 {
296     /**
297      * @dev Returns true if this contract implements the interface defined by
298      * `interfaceId`. See the corresponding
299      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
300      * to learn more about how these ids are created.
301      *
302      * This function call must use less than 30 000 gas.
303      */
304     function supportsInterface(bytes4 interfaceId) external view returns (bool);
305 }
306 
307 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
308 
309 
310 /**
311  * @dev Implementation of the {IERC165} interface.
312  *
313  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
314  * for the additional interface id that will be supported. For example:
315  *
316  * ```solidity
317  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
318  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
319  * }
320  * ```
321  *
322  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
323  */
324 abstract contract ERC165 is IERC165 {
325     /**
326      * @dev See {IERC165-supportsInterface}.
327      */
328     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
329         return interfaceId == type(IERC165).interfaceId;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
334 
335 /**
336  * @dev _Available since v3.1._
337  */
338 interface IERC1155Receiver is IERC165 {
339     /**
340         @dev Handles the receipt of a single ERC1155 token type. This function is
341         called at the end of a `safeTransferFrom` after the balance has been updated.
342         To accept the transfer, this must return
343         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
344         (i.e. 0xf23a6e61, or its own function selector).
345         @param operator The address which initiated the transfer (i.e. msg.sender)
346         @param from The address which previously owned the token
347         @param id The ID of the token being transferred
348         @param value The amount of tokens being transferred
349         @param data Additional data with no specified format
350         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
351     */
352     function onERC1155Received(
353         address operator,
354         address from,
355         uint256 id,
356         uint256 value,
357         bytes calldata data
358     ) external returns (bytes4);
359 
360     /**
361         @dev Handles the receipt of a multiple ERC1155 token types. This function
362         is called at the end of a `safeBatchTransferFrom` after the balances have
363         been updated. To accept the transfer(s), this must return
364         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
365         (i.e. 0xbc197c81, or its own function selector).
366         @param operator The address which initiated the batch transfer (i.e. msg.sender)
367         @param from The address which previously owned the token
368         @param ids An array containing ids of each token being transferred (order and length must match values array)
369         @param values An array containing amounts of each token being transferred (order and length must match ids array)
370         @param data Additional data with no specified format
371         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
372     */
373     function onERC1155BatchReceived(
374         address operator,
375         address from,
376         uint256[] calldata ids,
377         uint256[] calldata values,
378         bytes calldata data
379     ) external returns (bytes4);
380 }
381 
382 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
383 
384 /**
385  * @dev Required interface of an ERC1155 compliant contract, as defined in the
386  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
387  *
388  * _Available since v3.1._
389  */
390 interface IERC1155 is IERC165 {
391     /**
392      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
393      */
394     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
395 
396     /**
397      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
398      * transfers.
399      */
400     event TransferBatch(
401         address indexed operator,
402         address indexed from,
403         address indexed to,
404         uint256[] ids,
405         uint256[] values
406     );
407 
408     /**
409      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
410      * `approved`.
411      */
412     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
413 
414     /**
415      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
416      *
417      * If an {URI} event was emitted for `id`, the standard
418      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
419      * returned by {IERC1155MetadataURI-uri}.
420      */
421     event URI(string value, uint256 indexed id);
422 
423     /**
424      * @dev Returns the amount of tokens of token type `id` owned by `account`.
425      *
426      * Requirements:
427      *
428      * - `account` cannot be the zero address.
429      */
430     function balanceOf(address account, uint256 id) external view returns (uint256);
431 
432     /**
433      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
434      *
435      * Requirements:
436      *
437      * - `accounts` and `ids` must have the same length.
438      */
439     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
440         external
441         view
442         returns (uint256[] memory);
443 
444     /**
445      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
446      *
447      * Emits an {ApprovalForAll} event.
448      *
449      * Requirements:
450      *
451      * - `operator` cannot be the caller.
452      */
453     function setApprovalForAll(address operator, bool approved) external;
454 
455     /**
456      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
457      *
458      * See {setApprovalForAll}.
459      */
460     function isApprovedForAll(address account, address operator) external view returns (bool);
461 
462     /**
463      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
464      *
465      * Emits a {TransferSingle} event.
466      *
467      * Requirements:
468      *
469      * - `to` cannot be the zero address.
470      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
471      * - `from` must have a balance of tokens of type `id` of at least `amount`.
472      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
473      * acceptance magic value.
474      */
475     function safeTransferFrom(
476         address from,
477         address to,
478         uint256 id,
479         uint256 amount,
480         bytes calldata data
481     ) external;
482 
483     /**
484      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
485      *
486      * Emits a {TransferBatch} event.
487      *
488      * Requirements:
489      *
490      * - `ids` and `amounts` must have the same length.
491      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
492      * acceptance magic value.
493      */
494     function safeBatchTransferFrom(
495         address from,
496         address to,
497         uint256[] calldata ids,
498         uint256[] calldata amounts,
499         bytes calldata data
500     ) external;
501 }
502 
503 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
504 
505 /**
506  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
507  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
508  *
509  * _Available since v3.1._
510  */
511 interface IERC1155MetadataURI is IERC1155 {
512     /**
513      * @dev Returns the URI for token type `id`.
514      *
515      * If the `\{id\}` substring is present in the URI, it must be replaced by
516      * clients with the actual token type ID.
517      */
518     function uri(uint256 id) external view returns (string memory);
519 }
520 
521 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
522 
523 /**
524  * @dev Implementation of the basic standard multi-token.
525  * See https://eips.ethereum.org/EIPS/eip-1155
526  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
527  *
528  * _Available since v3.1._
529  */
530 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
531     using Address for address;
532 
533     // Mapping from token ID to account balances
534     mapping(uint256 => mapping(address => uint256)) private _balances;
535 
536     // Mapping from account to operator approvals
537     mapping(address => mapping(address => bool)) private _operatorApprovals;
538 
539     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
540     string private _uri;
541 
542     /**
543      * @dev See {_setURI}.
544      */
545     constructor() {
546         
547     }
548 
549     /**
550      * @dev See {IERC165-supportsInterface}.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
553         return
554             interfaceId == type(IERC1155).interfaceId ||
555             interfaceId == type(IERC1155MetadataURI).interfaceId ||
556             super.supportsInterface(interfaceId);
557     }
558 
559     /**
560      * @dev See {IERC1155MetadataURI-uri}.
561      *
562      * This implementation returns the same URI for *all* token types. It relies
563      * on the token type ID substitution mechanism
564      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
565      *
566      * Clients calling this function must replace the `\{id\}` substring with the
567      * actual token type ID.
568      */
569     function uri(uint256) public view virtual override returns (string memory) {
570         return _uri;
571     }
572 
573     /**
574      * @dev See {IERC1155-balanceOf}.
575      *
576      * Requirements:
577      *
578      * - `account` cannot be the zero address.
579      */
580     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
581         require(account != address(0), "ERC1155: balance query for the zero address");
582         return _balances[id][account];
583     }
584 
585     /**
586      * @dev See {IERC1155-balanceOfBatch}.
587      *
588      * Requirements:
589      *
590      * - `accounts` and `ids` must have the same length.
591      */
592     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
593         public
594         view
595         virtual
596         override
597         returns (uint256[] memory)
598     {
599         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
600 
601         uint256[] memory batchBalances = new uint256[](accounts.length);
602 
603         for (uint256 i = 0; i < accounts.length; ++i) {
604             batchBalances[i] = balanceOf(accounts[i], ids[i]);
605         }
606 
607         return batchBalances;
608     }
609 
610     /**
611      * @dev See {IERC1155-setApprovalForAll}.
612      */
613     function setApprovalForAll(address operator, bool approved) public virtual override {
614         require(_msgSender() != operator, "ERC1155: setting approval status for self");
615 
616         _operatorApprovals[_msgSender()][operator] = approved;
617         emit ApprovalForAll(_msgSender(), operator, approved);
618     }
619 
620     /**
621      * @dev See {IERC1155-isApprovedForAll}.
622      */
623     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
624         return _operatorApprovals[account][operator];
625     }
626 
627     /**
628      * @dev See {IERC1155-safeTransferFrom}.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 id,
634         uint256 amount,
635         bytes memory data
636     ) public virtual override {
637         require(
638             from == _msgSender() || isApprovedForAll(from, _msgSender()),
639             "ERC1155: caller is not owner nor approved"
640         );
641         _safeTransferFrom(from, to, id, amount, data);
642     }
643 
644     /**
645      * @dev See {IERC1155-safeBatchTransferFrom}.
646      */
647     function safeBatchTransferFrom(
648         address from,
649         address to,
650         uint256[] memory ids,
651         uint256[] memory amounts,
652         bytes memory data
653     ) public virtual override {
654         require(
655             from == _msgSender() || isApprovedForAll(from, _msgSender()),
656             "ERC1155: transfer caller is not owner nor approved"
657         );
658         _safeBatchTransferFrom(from, to, ids, amounts, data);
659     }
660 
661     /**
662      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
663      *
664      * Emits a {TransferSingle} event.
665      *
666      * Requirements:
667      *
668      * - `to` cannot be the zero address.
669      * - `from` must have a balance of tokens of type `id` of at least `amount`.
670      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
671      * acceptance magic value.
672      */
673     function _safeTransferFrom(
674         address from,
675         address to,
676         uint256 id,
677         uint256 amount,
678         bytes memory data
679     ) internal virtual {
680         require(to != address(0), "ERC1155: transfer to the zero address");
681 
682         address operator = _msgSender();
683 
684         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
685 
686         uint256 fromBalance = _balances[id][from];
687         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
688         unchecked {
689             _balances[id][from] = fromBalance - amount;
690         }
691         _balances[id][to] += amount;
692 
693         emit TransferSingle(operator, from, to, id, amount);
694 
695         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
696     }
697 
698     /**
699      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
700      *
701      * Emits a {TransferBatch} event.
702      *
703      * Requirements:
704      *
705      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
706      * acceptance magic value.
707      */
708     function _safeBatchTransferFrom(
709         address from,
710         address to,
711         uint256[] memory ids,
712         uint256[] memory amounts,
713         bytes memory data
714     ) internal virtual {
715         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
716         require(to != address(0), "ERC1155: transfer to the zero address");
717 
718         address operator = _msgSender();
719 
720         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
721 
722         for (uint256 i = 0; i < ids.length; ++i) {
723             uint256 id = ids[i];
724             uint256 amount = amounts[i];
725 
726             uint256 fromBalance = _balances[id][from];
727             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
728             unchecked {
729                 _balances[id][from] = fromBalance - amount;
730             }
731             _balances[id][to] += amount;
732         }
733 
734         emit TransferBatch(operator, from, to, ids, amounts);
735 
736         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
737     }
738 
739     /**
740      * @dev Sets a new URI for all token types, by relying on the token type ID
741      * substitution mechanism
742      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
743      *
744      * By this mechanism, any occurrence of the `\{id\}` substring in either the
745      * URI or any of the amounts in the JSON file at said URI will be replaced by
746      * clients with the token type ID.
747      *
748      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
749      * interpreted by clients as
750      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
751      * for token type ID 0x4cce0.
752      *
753      * See {uri}.
754      *
755      * Because these URIs cannot be meaningfully represented by the {URI} event,
756      * this function emits no events.
757      */
758     function _setURI(string memory newuri) internal virtual {
759         _uri = newuri;
760     }
761 
762     /**
763      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
764      *
765      * Emits a {TransferSingle} event.
766      *
767      * Requirements:
768      *
769      * - `account` cannot be the zero address.
770      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
771      * acceptance magic value.
772      */
773     function _mint(
774         address account,
775         uint256 id,
776         uint256 amount,
777         bytes memory data
778     ) internal virtual {
779         require(account != address(0), "ERC1155: mint to the zero address");
780 
781         address operator = _msgSender();
782 
783         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
784 
785         _balances[id][account] += amount;
786         emit TransferSingle(operator, address(0), account, id, amount);
787 
788         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
789     }
790 
791     /**
792      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
793      *
794      * Requirements:
795      *
796      * - `ids` and `amounts` must have the same length.
797      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
798      * acceptance magic value.
799      */
800     function _mintBatch(
801         address to,
802         uint256[] memory ids,
803         uint256[] memory amounts,
804         bytes memory data
805     ) internal virtual {
806         require(to != address(0), "ERC1155: mint to the zero address");
807         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
808 
809         address operator = _msgSender();
810 
811         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
812 
813         for (uint256 i = 0; i < ids.length; i++) {
814             _balances[ids[i]][to] += amounts[i];
815         }
816 
817         emit TransferBatch(operator, address(0), to, ids, amounts);
818 
819         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
820     }
821 
822     /**
823      * @dev Destroys `amount` tokens of token type `id` from `account`
824      *
825      * Requirements:
826      *
827      * - `account` cannot be the zero address.
828      * - `account` must have at least `amount` tokens of token type `id`.
829      */
830     function _burn(
831         address account,
832         uint256 id,
833         uint256 amount
834     ) internal virtual {
835         require(account != address(0), "ERC1155: burn from the zero address");
836 
837         address operator = _msgSender();
838 
839         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
840 
841         uint256 accountBalance = _balances[id][account];
842         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
843         unchecked {
844             _balances[id][account] = accountBalance - amount;
845         }
846 
847         emit TransferSingle(operator, account, address(0), id, amount);
848     }
849 
850     /**
851      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
852      *
853      * Requirements:
854      *
855      * - `ids` and `amounts` must have the same length.
856      */
857     function _burnBatch(
858         address account,
859         uint256[] memory ids,
860         uint256[] memory amounts
861     ) internal virtual {
862         require(account != address(0), "ERC1155: burn from the zero address");
863         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
864 
865         address operator = _msgSender();
866 
867         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
868 
869         for (uint256 i = 0; i < ids.length; i++) {
870             uint256 id = ids[i];
871             uint256 amount = amounts[i];
872 
873             uint256 accountBalance = _balances[id][account];
874             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
875             unchecked {
876                 _balances[id][account] = accountBalance - amount;
877             }
878         }
879 
880         emit TransferBatch(operator, account, address(0), ids, amounts);
881     }
882 
883     /**
884      * @dev Hook that is called before any token transfer. This includes minting
885      * and burning, as well as batched variants.
886      *
887      * The same hook is called on both single and batched variants. For single
888      * transfers, the length of the `id` and `amount` arrays will be 1.
889      *
890      * Calling conditions (for each `id` and `amount` pair):
891      *
892      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
893      * of token type `id` will be  transferred to `to`.
894      * - When `from` is zero, `amount` tokens of token type `id` will be minted
895      * for `to`.
896      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
897      * will be burned.
898      * - `from` and `to` are never both zero.
899      * - `ids` and `amounts` have the same, non-zero length.
900      *
901      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
902      */
903     function _beforeTokenTransfer(
904         address operator,
905         address from,
906         address to,
907         uint256[] memory ids,
908         uint256[] memory amounts,
909         bytes memory data
910     ) internal virtual {}
911 
912     function _doSafeTransferAcceptanceCheck(
913         address operator,
914         address from,
915         address to,
916         uint256 id,
917         uint256 amount,
918         bytes memory data
919     ) private {
920         if (to.isContract()) {
921             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
922                 if (response != IERC1155Receiver.onERC1155Received.selector) {
923                     revert("ERC1155: ERC1155Receiver rejected tokens");
924                 }
925             } catch Error(string memory reason) {
926                 revert(reason);
927             } catch {
928                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
929             }
930         }
931     }
932 
933     function _doSafeBatchTransferAcceptanceCheck(
934         address operator,
935         address from,
936         address to,
937         uint256[] memory ids,
938         uint256[] memory amounts,
939         bytes memory data
940     ) private {
941         if (to.isContract()) {
942             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
943                 bytes4 response
944             ) {
945                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
946                     revert("ERC1155: ERC1155Receiver rejected tokens");
947                 }
948             } catch Error(string memory reason) {
949                 revert(reason);
950             } catch {
951                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
952             }
953         }
954     }
955 
956     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
957         uint256[] memory array = new uint256[](1);
958         array[0] = element;
959 
960         return array;
961     }
962 }
963 
964 /**
965  * @dev Wrappers over Solidity's arithmetic operations.
966  *
967  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
968  * now has built in overflow checking.
969  */
970 library SafeMath {
971     /**
972      * @dev Returns the addition of two unsigned integers, with an overflow flag.
973      *
974      * _Available since v3.4._
975      */
976     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
977         unchecked {
978             uint256 c = a + b;
979             if (c < a) return (false, 0);
980             return (true, c);
981         }
982     }
983 
984     /**
985      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
986      *
987      * _Available since v3.4._
988      */
989     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
990         unchecked {
991             if (b > a) return (false, 0);
992             return (true, a - b);
993         }
994     }
995 
996     /**
997      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
998      *
999      * _Available since v3.4._
1000      */
1001     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1002         unchecked {
1003             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1004             // benefit is lost if 'b' is also tested.
1005             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1006             if (a == 0) return (true, 0);
1007             uint256 c = a * b;
1008             if (c / a != b) return (false, 0);
1009             return (true, c);
1010         }
1011     }
1012 
1013     /**
1014      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1015      *
1016      * _Available since v3.4._
1017      */
1018     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1019         unchecked {
1020             if (b == 0) return (false, 0);
1021             return (true, a / b);
1022         }
1023     }
1024 
1025     /**
1026      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1027      *
1028      * _Available since v3.4._
1029      */
1030     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1031         unchecked {
1032             if (b == 0) return (false, 0);
1033             return (true, a % b);
1034         }
1035     }
1036 
1037     /**
1038      * @dev Returns the addition of two unsigned integers, reverting on
1039      * overflow.
1040      *
1041      * Counterpart to Solidity's `+` operator.
1042      *
1043      * Requirements:
1044      *
1045      * - Addition cannot overflow.
1046      */
1047     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1048         return a + b;
1049     }
1050 
1051     /**
1052      * @dev Returns the subtraction of two unsigned integers, reverting on
1053      * overflow (when the result is negative).
1054      *
1055      * Counterpart to Solidity's `-` operator.
1056      *
1057      * Requirements:
1058      *
1059      * - Subtraction cannot overflow.
1060      */
1061     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1062         return a - b;
1063     }
1064 
1065     /**
1066      * @dev Returns the multiplication of two unsigned integers, reverting on
1067      * overflow.
1068      *
1069      * Counterpart to Solidity's `*` operator.
1070      *
1071      * Requirements:
1072      *
1073      * - Multiplication cannot overflow.
1074      */
1075     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1076         return a * b;
1077     }
1078 
1079     /**
1080      * @dev Returns the integer division of two unsigned integers, reverting on
1081      * division by zero. The result is rounded towards zero.
1082      *
1083      * Counterpart to Solidity's `/` operator.
1084      *
1085      * Requirements:
1086      *
1087      * - The divisor cannot be zero.
1088      */
1089     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1090         return a / b;
1091     }
1092 
1093     /**
1094      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1095      * reverting when dividing by zero.
1096      *
1097      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1098      * opcode (which leaves remaining gas untouched) while Solidity uses an
1099      * invalid opcode to revert (consuming all remaining gas).
1100      *
1101      * Requirements:
1102      *
1103      * - The divisor cannot be zero.
1104      */
1105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1106         return a % b;
1107     }
1108 
1109     /**
1110      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1111      * overflow (when the result is negative).
1112      *
1113      * CAUTION: This function is deprecated because it requires allocating memory for the error
1114      * message unnecessarily. For custom revert reasons use {trySub}.
1115      *
1116      * Counterpart to Solidity's `-` operator.
1117      *
1118      * Requirements:
1119      *
1120      * - Subtraction cannot overflow.
1121      */
1122     function sub(
1123         uint256 a,
1124         uint256 b,
1125         string memory errorMessage
1126     ) internal pure returns (uint256) {
1127         unchecked {
1128             require(b <= a, errorMessage);
1129             return a - b;
1130         }
1131     }
1132 
1133     /**
1134      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1135      * division by zero. The result is rounded towards zero.
1136      *
1137      * Counterpart to Solidity's `/` operator. Note: this function uses a
1138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1139      * uses an invalid opcode to revert (consuming all remaining gas).
1140      *
1141      * Requirements:
1142      *
1143      * - The divisor cannot be zero.
1144      */
1145     function div(
1146         uint256 a,
1147         uint256 b,
1148         string memory errorMessage
1149     ) internal pure returns (uint256) {
1150         unchecked {
1151             require(b > 0, errorMessage);
1152             return a / b;
1153         }
1154     }
1155 
1156     /**
1157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1158      * reverting with custom message when dividing by zero.
1159      *
1160      * CAUTION: This function is deprecated because it requires allocating memory for the error
1161      * message unnecessarily. For custom revert reasons use {tryMod}.
1162      *
1163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1164      * opcode (which leaves remaining gas untouched) while Solidity uses an
1165      * invalid opcode to revert (consuming all remaining gas).
1166      *
1167      * Requirements:
1168      *
1169      * - The divisor cannot be zero.
1170      */
1171     function mod(
1172         uint256 a,
1173         uint256 b,
1174         string memory errorMessage
1175     ) internal pure returns (uint256) {
1176         unchecked {
1177             require(b > 0, errorMessage);
1178             return a % b;
1179         }
1180     }
1181 }
1182 
1183 /**
1184  * @dev String operations.
1185  */
1186 library Strings {
1187     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1188 
1189     /**
1190      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1191      */
1192     function toString(uint256 value) internal pure returns (string memory) {
1193         // Inspired by OraclizeAPI's implementation - MIT licence
1194         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1195 
1196         if (value == 0) {
1197             return "0";
1198         }
1199         uint256 temp = value;
1200         uint256 digits;
1201         while (temp != 0) {
1202             digits++;
1203             temp /= 10;
1204         }
1205         bytes memory buffer = new bytes(digits);
1206         while (value != 0) {
1207             digits -= 1;
1208             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1209             value /= 10;
1210         }
1211         return string(buffer);
1212     }
1213 
1214     /**
1215      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1216      */
1217     function toHexString(uint256 value) internal pure returns (string memory) {
1218         if (value == 0) {
1219             return "0x00";
1220         }
1221         uint256 temp = value;
1222         uint256 length = 0;
1223         while (temp != 0) {
1224             length++;
1225             temp >>= 8;
1226         }
1227         return toHexString(value, length);
1228     }
1229 
1230     /**
1231      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1232      */
1233     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1234         bytes memory buffer = new bytes(2 * length + 2);
1235         buffer[0] = "0";
1236         buffer[1] = "x";
1237         for (uint256 i = 2 * length + 1; i > 1; --i) {
1238             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1239             value >>= 4;
1240         }
1241         require(value == 0, "Strings: hex length insufficient");
1242         return string(buffer);
1243     }
1244 }
1245 contract BabyDoodleArt is ERC1155, Ownable {
1246     string public constant name = "Baby Doodle Art";
1247     string public constant symbol = "BDART";
1248     
1249     using SafeMath for uint256;
1250     using Strings for uint256;
1251     uint256 public totalSupply = 0;
1252     string private baseURI;
1253     string private blindURI;
1254     uint256 public constant BUY_LIMIT_PER_TX = 15;
1255     uint256 public constant MAX_NFT_PUBLIC = 8799;
1256     uint256 private constant MAX_NFT = 8999;
1257     uint256 public constant maxGiveaway=200;
1258     uint256 public NFTPrice = 80000000000000000;  // 0.08 ETH
1259     bool public reveal;
1260     bool public isActive;
1261     bool public isPresaleActive;
1262     bytes32 public root;
1263     uint256 public constant WHITELIST_MAX_MINT = 15;
1264     mapping(address => uint256) private whiteListClaimed;
1265     uint256 public giveawayCount;
1266     /*
1267      * Function to reveal all NFTs
1268     */
1269     function revealNow() 
1270         external 
1271         onlyOwner 
1272     {
1273         reveal = true;
1274     }
1275     
1276     /*
1277      * Function to mint NFTs
1278     */
1279     function mint(address to, uint32 count) internal {
1280         if (count > 1) {
1281             uint256[] memory ids = new uint256[](uint256(count));
1282             uint256[] memory amounts = new uint256[](uint256(count));
1283 
1284             for (uint32 i = 0; i < count; i++) {
1285                 ids[i] = totalSupply + i;
1286                 amounts[i] = 1;
1287             }
1288 
1289             _mintBatch(to, ids, amounts, "");
1290         } else {
1291             _mint(to, totalSupply, 1, "");
1292         }
1293 
1294         totalSupply += count;
1295     }
1296     
1297     /*
1298      * Function setIsActive to activate/desactivate the smart contract
1299     */
1300     function setIsActive(
1301         bool _isActive
1302     ) 
1303         external 
1304         onlyOwner 
1305     {
1306         isActive = _isActive;
1307     }
1308     
1309     /*
1310      * Function setPresaleActive to activate/desactivate the presale  
1311     */
1312     function setPresaleActive(
1313         bool _isActive
1314     ) 
1315         external 
1316         onlyOwner 
1317     {
1318         if(_isActive==true){
1319             NFTPrice=80000000000000000;  // 0.08 ETH
1320         }else{
1321             NFTPrice=100000000000000000;  // 0.1 ETH
1322         }
1323         isPresaleActive = _isActive;
1324     }
1325     
1326     /*
1327      * Function to set Base and Blind URI 
1328     */
1329     function setURIs(
1330         string memory _blindURI, 
1331         string memory _URI
1332     ) 
1333         external 
1334         onlyOwner 
1335     {
1336         blindURI = _blindURI;
1337         baseURI = _URI;
1338     }
1339     
1340     /*
1341      * Function to withdraw collected amount during minting by the owner
1342     */
1343     function withdraw(
1344     ) 
1345         public 
1346         onlyOwner 
1347     {
1348         address[3] memory addresses = [
1349             0xE9E7d48F3a373c00844B5412951F7fd9D9605eE6,
1350             0xfbc7A660e4820DE480Cfdf65CfEaE6dE317aD0ca,
1351             0xBF3227FdE241CF0cff652f8c4BfC99724140e7b6
1352         ];
1353 
1354         uint32[3] memory shares = [
1355             uint32(4750),
1356             uint32(4750),
1357             uint32(500)
1358         ];
1359 
1360         uint256 balance = address(this).balance;
1361 
1362         for (uint32 i = 0; i < addresses.length; i++) {
1363             uint256 amount = i == addresses.length - 1 ? address(this).balance : balance * shares[i] / 10000;
1364             payable(addresses[i]).transfer(amount);
1365         }
1366     }
1367 
1368     /*
1369      * Function to withdraw collected amount during minting by the owner
1370     */
1371     function emergencyWithdraw(
1372         address _to
1373     ) 
1374         public 
1375         onlyOwner 
1376     {
1377         uint balance = address(this).balance;
1378         require(balance > 0, "Balance should be more then zero");
1379         payable(_to).transfer(balance);
1380     }
1381     
1382     /*
1383      * Function to mint new NFTs during the public sale
1384      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1385     */
1386     function mintNFT(
1387         uint32 _numOfTokens
1388     ) 
1389         public 
1390         payable 
1391     {
1392     
1393         require(isActive, 'Contract is not active');
1394         require(!isPresaleActive, 'Presale still active');
1395         require(_numOfTokens <= BUY_LIMIT_PER_TX, "Cannot mint above limit");
1396         require(totalSupply.add(_numOfTokens).sub(giveawayCount) <= MAX_NFT_PUBLIC, "Purchase would exceed max public supply of NFTs");
1397         require( msg.value >= NFTPrice.mul(_numOfTokens), "Ether value sent is not correct");
1398         mint(msg.sender,_numOfTokens);
1399     }
1400     
1401     /*
1402      * Function to mint new NFTs during the presale
1403      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1404     */ 
1405     function mintNFTDuringPresale(
1406         uint32 _numOfTokens,
1407         bytes32[] memory _proof
1408     ) 
1409         public 
1410         payable
1411     {
1412         require(isActive, 'Contract is not active');
1413         require(isPresaleActive, 'Presale not active');
1414         require(verify(_proof, bytes32(uint256(uint160(msg.sender)))), "Not whitelisted");
1415         require(totalSupply.sub(giveawayCount) < MAX_NFT_PUBLIC, 'All public tokens have been minted');
1416         require(_numOfTokens <= WHITELIST_MAX_MINT, 'Cannot purchase this many tokens');
1417         require(totalSupply.add(_numOfTokens).sub(giveawayCount) <= MAX_NFT_PUBLIC, 'Purchase would exceed max public supply of NFTs');
1418         require(whiteListClaimed[msg.sender].add(_numOfTokens) <= WHITELIST_MAX_MINT, 'Purchase exceeds max whiteed');
1419         require( msg.value >= NFTPrice.mul(_numOfTokens), "Ether value sent is not correct");
1420         mint(msg.sender,_numOfTokens);
1421         whiteListClaimed[msg.sender] += _numOfTokens;
1422            
1423     }
1424     
1425     /*
1426      * Function to mint all NFTs for giveaway and partnerships
1427     */
1428     function mintByOwner(
1429         address _to
1430     ) 
1431         public 
1432         onlyOwner
1433     {
1434         require(giveawayCount.add(1)<=maxGiveaway,"Cannot do more giveaway");
1435         require(totalSupply.add(1) < MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
1436         mint(_to,1);
1437         giveawayCount=giveawayCount.add(1);
1438     }
1439     
1440     /*
1441      * Function to mint all NFTs for giveaway and partnerships
1442     */
1443     function mintMultipleByOwner(
1444         address[] memory _to
1445     ) 
1446         public 
1447         onlyOwner
1448     {
1449         require(totalSupply.add(_to.length) < MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
1450         require(giveawayCount.add(_to.length)<=maxGiveaway,"Cannot do that much giveaway");
1451         for(uint256 i = 0; i < _to.length; i++){
1452             mint(_to[i],1);
1453         }
1454         giveawayCount=giveawayCount.add(_to.length);
1455     }
1456     
1457     /*
1458      * Function to get token URI of given token ID
1459      * URI will be blank untill totalSupply reaches MAX_NFT_PUBLIC
1460     */
1461     function uri(
1462         uint256 _tokenId
1463     ) 
1464         public 
1465         view 
1466         virtual 
1467         override 
1468         returns (string memory) 
1469     {
1470         require(_tokenId<totalSupply, "ERC1155Metadata: URI query for nonexistent token");
1471         if (!reveal) {
1472             return string(abi.encodePacked(blindURI));
1473         } else {
1474             return string(abi.encodePacked(baseURI, _tokenId.toString()));
1475         }
1476     }
1477     
1478     /*
1479      * Function to set the merkle root
1480     */
1481     function setRoot(uint256 _root) onlyOwner() public {
1482         root = bytes32(_root);
1483     }
1484     
1485     /*
1486      * Function to verify the proof
1487     */
1488     function verify(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1489         bytes32 computedHash = leaf;
1490 
1491         for (uint256 i = 0; i < proof.length; i++) {
1492             bytes32 proofElement = proof[i];
1493             
1494             if (computedHash <= proofElement) {
1495                 // Hash(current computed hash + current element of the proof)
1496                 computedHash = sha256(abi.encodePacked(computedHash, proofElement));
1497             } else {
1498                 // Hash(current element of the proof + current computed hash)
1499                 computedHash = sha256(abi.encodePacked(proofElement, computedHash));
1500             }
1501         }
1502 
1503         // Check if the computed hash (root) is equal to the provided root
1504         return computedHash == root;
1505     }
1506 }