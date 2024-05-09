1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-30
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.4;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     /**
25      * @dev Initializes the contract setting the deployer as the initial owner.
26      */
27     constructor() {
28         _setOwner(_msgSender());
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(owner() == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Leaves the contract without owner. It will not be possible to call
48      * `onlyOwner` functions anymore. Can only be called by the current owner.
49      *
50      * NOTE: Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public virtual onlyOwner {
54         _setOwner(address(0));
55     }
56 
57     /**
58      * @dev Transfers ownership of the contract to a new account (`newOwner`).
59      * Can only be called by the current owner.
60      */
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         _setOwner(newOwner);
64     }
65 
66     function _setOwner(address newOwner) private {
67         address oldOwner = _owner;
68         _owner = newOwner;
69         emit OwnershipTransferred(oldOwner, newOwner);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Address.sol
74 
75 /**
76  * @dev Collection of functions related to the address type
77  */
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      */
96     function isContract(address account) internal view returns (bool) {
97         // This method relies on extcodesize, which returns 0 for contracts in
98         // construction, since the code is only stored at the end of the
99         // constructor execution.
100 
101         uint256 size;
102         assembly {
103             size := extcodesize(account)
104         }
105         return size > 0;
106     }
107 
108     /**
109      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
110      * `recipient`, forwarding all available gas and reverting on errors.
111      *
112      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
113      * of certain opcodes, possibly making contracts go over the 2300 gas limit
114      * imposed by `transfer`, making them unable to receive funds via
115      * `transfer`. {sendValue} removes this limitation.
116      *
117      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
118      *
119      * IMPORTANT: because control is transferred to `recipient`, care must be
120      * taken to not create reentrancy vulnerabilities. Consider using
121      * {ReentrancyGuard} or the
122      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
123      */
124     function sendValue(address payable recipient, uint256 amount) internal {
125         require(address(this).balance >= amount, "Address: insufficient balance");
126 
127         (bool success, ) = recipient.call{value: amount}("");
128         require(success, "Address: unable to send value, recipient may have reverted");
129     }
130 
131     /**
132      * @dev Performs a Solidity function call using a low level `call`. A
133      * plain `call` is an unsafe replacement for a function call: use this
134      * function instead.
135      *
136      * If `target` reverts with a revert reason, it is bubbled up by this
137      * function (like regular Solidity function calls).
138      *
139      * Returns the raw returned data. To convert to the expected return value,
140      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
141      *
142      * Requirements:
143      *
144      * - `target` must be a contract.
145      * - calling `target` with `data` must not revert.
146      *
147      * _Available since v3.1._
148      */
149     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
150         return functionCall(target, data, "Address: low-level call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
155      * `errorMessage` as a fallback revert reason when `target` reverts.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal returns (bytes memory) {
164         return functionCallWithValue(target, data, 0, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but also transferring `value` wei to `target`.
170      *
171      * Requirements:
172      *
173      * - the calling contract must have an ETH balance of at least `value`.
174      * - the called Solidity function must be `payable`.
175      *
176      * _Available since v3.1._
177      */
178     function functionCallWithValue(
179         address target,
180         bytes memory data,
181         uint256 value
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
188      * with `errorMessage` as a fallback revert reason when `target` reverts.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value,
196         string memory errorMessage
197     ) internal returns (bytes memory) {
198         require(address(this).balance >= value, "Address: insufficient balance for call");
199         require(isContract(target), "Address: call to non-contract");
200 
201         (bool success, bytes memory returndata) = target.call{value: value}(data);
202         return verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but performing a static call.
208      *
209      * _Available since v3.3._
210      */
211     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
212         return functionStaticCall(target, data, "Address: low-level static call failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
217      * but performing a static call.
218      *
219      * _Available since v3.3._
220      */
221     function functionStaticCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal view returns (bytes memory) {
226         require(isContract(target), "Address: static call to non-contract");
227 
228         (bool success, bytes memory returndata) = target.staticcall(data);
229         return verifyCallResult(success, returndata, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but performing a delegate call.
235      *
236      * _Available since v3.4._
237      */
238     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
244      * but performing a delegate call.
245      *
246      * _Available since v3.4._
247      */
248     function functionDelegateCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         require(isContract(target), "Address: delegate call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.delegatecall(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
261      * revert reason using the provided one.
262      *
263      * _Available since v4.3._
264      */
265     function verifyCallResult(
266         bool success,
267         bytes memory returndata,
268         string memory errorMessage
269     ) internal pure returns (bytes memory) {
270         if (success) {
271             return returndata;
272         } else {
273             // Look for revert reason and bubble it up if present
274             if (returndata.length > 0) {
275                 // The easiest way to bubble the revert reason is using memory via assembly
276 
277                 assembly {
278                     let returndata_size := mload(returndata)
279                     revert(add(32, returndata), returndata_size)
280                 }
281             } else {
282                 revert(errorMessage);
283             }
284         }
285     }
286 }
287 
288 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
289 
290 /**
291  * @dev Interface of the ERC165 standard, as defined in the
292  * https://eips.ethereum.org/EIPS/eip-165[EIP].
293  *
294  * Implementers can declare support of contract interfaces, which can then be
295  * queried by others ({ERC165Checker}).
296  *
297  * For an implementation, see {ERC165}.
298  */
299 interface IERC165 {
300     /**
301      * @dev Returns true if this contract implements the interface defined by
302      * `interfaceId`. See the corresponding
303      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
304      * to learn more about how these ids are created.
305      *
306      * This function call must use less than 30 000 gas.
307      */
308     function supportsInterface(bytes4 interfaceId) external view returns (bool);
309 }
310 
311 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
312 
313 
314 /**
315  * @dev Implementation of the {IERC165} interface.
316  *
317  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
318  * for the additional interface id that will be supported. For example:
319  *
320  * ```solidity
321  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
322  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
323  * }
324  * ```
325  *
326  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
327  */
328 abstract contract ERC165 is IERC165 {
329     /**
330      * @dev See {IERC165-supportsInterface}.
331      */
332     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
333         return interfaceId == type(IERC165).interfaceId;
334     }
335 }
336 
337 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
338 
339 /**
340  * @dev _Available since v3.1._
341  */
342 interface IERC1155Receiver is IERC165 {
343     /**
344         @dev Handles the receipt of a single ERC1155 token type. This function is
345         called at the end of a `safeTransferFrom` after the balance has been updated.
346         To accept the transfer, this must return
347         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
348         (i.e. 0xf23a6e61, or its own function selector).
349         @param operator The address which initiated the transfer (i.e. msg.sender)
350         @param from The address which previously owned the token
351         @param id The ID of the token being transferred
352         @param value The amount of tokens being transferred
353         @param data Additional data with no specified format
354         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
355     */
356     function onERC1155Received(
357         address operator,
358         address from,
359         uint256 id,
360         uint256 value,
361         bytes calldata data
362     ) external returns (bytes4);
363 
364     /**
365         @dev Handles the receipt of a multiple ERC1155 token types. This function
366         is called at the end of a `safeBatchTransferFrom` after the balances have
367         been updated. To accept the transfer(s), this must return
368         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
369         (i.e. 0xbc197c81, or its own function selector).
370         @param operator The address which initiated the batch transfer (i.e. msg.sender)
371         @param from The address which previously owned the token
372         @param ids An array containing ids of each token being transferred (order and length must match values array)
373         @param values An array containing amounts of each token being transferred (order and length must match ids array)
374         @param data Additional data with no specified format
375         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
376     */
377     function onERC1155BatchReceived(
378         address operator,
379         address from,
380         uint256[] calldata ids,
381         uint256[] calldata values,
382         bytes calldata data
383     ) external returns (bytes4);
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
387 
388 /**
389  * @dev Required interface of an ERC1155 compliant contract, as defined in the
390  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
391  *
392  * _Available since v3.1._
393  */
394 interface IERC1155 is IERC165 {
395     /**
396      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
397      */
398     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
399 
400     /**
401      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
402      * transfers.
403      */
404     event TransferBatch(
405         address indexed operator,
406         address indexed from,
407         address indexed to,
408         uint256[] ids,
409         uint256[] values
410     );
411 
412     /**
413      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
414      * `approved`.
415      */
416     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
417 
418     /**
419      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
420      *
421      * If an {URI} event was emitted for `id`, the standard
422      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
423      * returned by {IERC1155MetadataURI-uri}.
424      */
425     event URI(string value, uint256 indexed id);
426 
427     /**
428      * @dev Returns the amount of tokens of token type `id` owned by `account`.
429      *
430      * Requirements:
431      *
432      * - `account` cannot be the zero address.
433      */
434     function balanceOf(address account, uint256 id) external view returns (uint256);
435 
436     /**
437      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
438      *
439      * Requirements:
440      *
441      * - `accounts` and `ids` must have the same length.
442      */
443     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
444         external
445         view
446         returns (uint256[] memory);
447 
448     /**
449      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
450      *
451      * Emits an {ApprovalForAll} event.
452      *
453      * Requirements:
454      *
455      * - `operator` cannot be the caller.
456      */
457     function setApprovalForAll(address operator, bool approved) external;
458 
459     /**
460      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
461      *
462      * See {setApprovalForAll}.
463      */
464     function isApprovedForAll(address account, address operator) external view returns (bool);
465 
466     /**
467      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
468      *
469      * Emits a {TransferSingle} event.
470      *
471      * Requirements:
472      *
473      * - `to` cannot be the zero address.
474      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
475      * - `from` must have a balance of tokens of type `id` of at least `amount`.
476      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
477      * acceptance magic value.
478      */
479     function safeTransferFrom(
480         address from,
481         address to,
482         uint256 id,
483         uint256 amount,
484         bytes calldata data
485     ) external;
486 
487     /**
488      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
489      *
490      * Emits a {TransferBatch} event.
491      *
492      * Requirements:
493      *
494      * - `ids` and `amounts` must have the same length.
495      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
496      * acceptance magic value.
497      */
498     function safeBatchTransferFrom(
499         address from,
500         address to,
501         uint256[] calldata ids,
502         uint256[] calldata amounts,
503         bytes calldata data
504     ) external;
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
508 
509 /**
510  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
511  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
512  *
513  * _Available since v3.1._
514  */
515 interface IERC1155MetadataURI is IERC1155 {
516     /**
517      * @dev Returns the URI for token type `id`.
518      *
519      * If the `\{id\}` substring is present in the URI, it must be replaced by
520      * clients with the actual token type ID.
521      */
522     function uri(uint256 id) external view returns (string memory);
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
526 
527 /**
528  * @dev Implementation of the basic standard multi-token.
529  * See https://eips.ethereum.org/EIPS/eip-1155
530  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
531  *
532  * _Available since v3.1._
533  */
534 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
535     using Address for address;
536 
537     // Mapping from token ID to account balances
538     mapping(uint256 => mapping(address => uint256)) private _balances;
539 
540     // Mapping from account to operator approvals
541     mapping(address => mapping(address => bool)) private _operatorApprovals;
542 
543     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
544     string private _uri;
545 
546     /**
547      * @dev See {_setURI}.
548      */
549     constructor() {
550         
551     }
552 
553     /**
554      * @dev See {IERC165-supportsInterface}.
555      */
556     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
557         return
558             interfaceId == type(IERC1155).interfaceId ||
559             interfaceId == type(IERC1155MetadataURI).interfaceId ||
560             super.supportsInterface(interfaceId);
561     }
562 
563     /**
564      * @dev See {IERC1155MetadataURI-uri}.
565      *
566      * This implementation returns the same URI for *all* token types. It relies
567      * on the token type ID substitution mechanism
568      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
569      *
570      * Clients calling this function must replace the `\{id\}` substring with the
571      * actual token type ID.
572      */
573     function uri(uint256) public view virtual override returns (string memory) {
574         return _uri;
575     }
576 
577     /**
578      * @dev See {IERC1155-balanceOf}.
579      *
580      * Requirements:
581      *
582      * - `account` cannot be the zero address.
583      */
584     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
585         require(account != address(0), "ERC1155: balance query for the zero address");
586         return _balances[id][account];
587     }
588 
589     /**
590      * @dev See {IERC1155-balanceOfBatch}.
591      *
592      * Requirements:
593      *
594      * - `accounts` and `ids` must have the same length.
595      */
596     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
597         public
598         view
599         virtual
600         override
601         returns (uint256[] memory)
602     {
603         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
604 
605         uint256[] memory batchBalances = new uint256[](accounts.length);
606 
607         for (uint256 i = 0; i < accounts.length; ++i) {
608             batchBalances[i] = balanceOf(accounts[i], ids[i]);
609         }
610 
611         return batchBalances;
612     }
613 
614     /**
615      * @dev See {IERC1155-setApprovalForAll}.
616      */
617     function setApprovalForAll(address operator, bool approved) public virtual override {
618         require(_msgSender() != operator, "ERC1155: setting approval status for self");
619 
620         _operatorApprovals[_msgSender()][operator] = approved;
621         emit ApprovalForAll(_msgSender(), operator, approved);
622     }
623 
624     /**
625      * @dev See {IERC1155-isApprovedForAll}.
626      */
627     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
628         return _operatorApprovals[account][operator];
629     }
630 
631     /**
632      * @dev See {IERC1155-safeTransferFrom}.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 id,
638         uint256 amount,
639         bytes memory data
640     ) public virtual override {
641         require(
642             from == _msgSender() || isApprovedForAll(from, _msgSender()),
643             "ERC1155: caller is not owner nor approved"
644         );
645         _safeTransferFrom(from, to, id, amount, data);
646     }
647 
648     /**
649      * @dev See {IERC1155-safeBatchTransferFrom}.
650      */
651     function safeBatchTransferFrom(
652         address from,
653         address to,
654         uint256[] memory ids,
655         uint256[] memory amounts,
656         bytes memory data
657     ) public virtual override {
658         require(
659             from == _msgSender() || isApprovedForAll(from, _msgSender()),
660             "ERC1155: transfer caller is not owner nor approved"
661         );
662         _safeBatchTransferFrom(from, to, ids, amounts, data);
663     }
664 
665     /**
666      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
667      *
668      * Emits a {TransferSingle} event.
669      *
670      * Requirements:
671      *
672      * - `to` cannot be the zero address.
673      * - `from` must have a balance of tokens of type `id` of at least `amount`.
674      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
675      * acceptance magic value.
676      */
677     function _safeTransferFrom(
678         address from,
679         address to,
680         uint256 id,
681         uint256 amount,
682         bytes memory data
683     ) internal virtual {
684         require(to != address(0), "ERC1155: transfer to the zero address");
685 
686         address operator = _msgSender();
687 
688         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
689 
690         uint256 fromBalance = _balances[id][from];
691         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
692         unchecked {
693             _balances[id][from] = fromBalance - amount;
694         }
695         _balances[id][to] += amount;
696 
697         emit TransferSingle(operator, from, to, id, amount);
698 
699         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
700     }
701 
702     /**
703      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
704      *
705      * Emits a {TransferBatch} event.
706      *
707      * Requirements:
708      *
709      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
710      * acceptance magic value.
711      */
712     function _safeBatchTransferFrom(
713         address from,
714         address to,
715         uint256[] memory ids,
716         uint256[] memory amounts,
717         bytes memory data
718     ) internal virtual {
719         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
720         require(to != address(0), "ERC1155: transfer to the zero address");
721 
722         address operator = _msgSender();
723 
724         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
725 
726         for (uint256 i = 0; i < ids.length; ++i) {
727             uint256 id = ids[i];
728             uint256 amount = amounts[i];
729 
730             uint256 fromBalance = _balances[id][from];
731             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
732             unchecked {
733                 _balances[id][from] = fromBalance - amount;
734             }
735             _balances[id][to] += amount;
736         }
737 
738         emit TransferBatch(operator, from, to, ids, amounts);
739 
740         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
741     }
742 
743     /**
744      * @dev Sets a new URI for all token types, by relying on the token type ID
745      * substitution mechanism
746      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
747      *
748      * By this mechanism, any occurrence of the `\{id\}` substring in either the
749      * URI or any of the amounts in the JSON file at said URI will be replaced by
750      * clients with the token type ID.
751      *
752      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
753      * interpreted by clients as
754      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
755      * for token type ID 0x4cce0.
756      *
757      * See {uri}.
758      *
759      * Because these URIs cannot be meaningfully represented by the {URI} event,
760      * this function emits no events.
761      */
762     function _setURI(string memory newuri) internal virtual {
763         _uri = newuri;
764     }
765 
766     /**
767      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
768      *
769      * Emits a {TransferSingle} event.
770      *
771      * Requirements:
772      *
773      * - `account` cannot be the zero address.
774      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
775      * acceptance magic value.
776      */
777     function _mint(
778         address account,
779         uint256 id,
780         uint256 amount,
781         bytes memory data
782     ) internal virtual {
783         require(account != address(0), "ERC1155: mint to the zero address");
784 
785         address operator = _msgSender();
786 
787         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
788 
789         _balances[id][account] += amount;
790         emit TransferSingle(operator, address(0), account, id, amount);
791 
792         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
793     }
794 
795     /**
796      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
797      *
798      * Requirements:
799      *
800      * - `ids` and `amounts` must have the same length.
801      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
802      * acceptance magic value.
803      */
804     function _mintBatch(
805         address to,
806         uint256[] memory ids,
807         uint256[] memory amounts,
808         bytes memory data
809     ) internal virtual {
810         require(to != address(0), "ERC1155: mint to the zero address");
811         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
812 
813         address operator = _msgSender();
814 
815         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
816 
817         for (uint256 i = 0; i < ids.length; i++) {
818             _balances[ids[i]][to] += amounts[i];
819         }
820 
821         emit TransferBatch(operator, address(0), to, ids, amounts);
822 
823         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
824     }
825 
826     /**
827      * @dev Destroys `amount` tokens of token type `id` from `account`
828      *
829      * Requirements:
830      *
831      * - `account` cannot be the zero address.
832      * - `account` must have at least `amount` tokens of token type `id`.
833      */
834     function _burn(
835         address account,
836         uint256 id,
837         uint256 amount
838     ) internal virtual {
839         require(account != address(0), "ERC1155: burn from the zero address");
840 
841         address operator = _msgSender();
842 
843         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
844 
845         uint256 accountBalance = _balances[id][account];
846         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
847         unchecked {
848             _balances[id][account] = accountBalance - amount;
849         }
850 
851         emit TransferSingle(operator, account, address(0), id, amount);
852     }
853 
854     /**
855      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
856      *
857      * Requirements:
858      *
859      * - `ids` and `amounts` must have the same length.
860      */
861     function _burnBatch(
862         address account,
863         uint256[] memory ids,
864         uint256[] memory amounts
865     ) internal virtual {
866         require(account != address(0), "ERC1155: burn from the zero address");
867         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
868 
869         address operator = _msgSender();
870 
871         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
872 
873         for (uint256 i = 0; i < ids.length; i++) {
874             uint256 id = ids[i];
875             uint256 amount = amounts[i];
876 
877             uint256 accountBalance = _balances[id][account];
878             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
879             unchecked {
880                 _balances[id][account] = accountBalance - amount;
881             }
882         }
883 
884         emit TransferBatch(operator, account, address(0), ids, amounts);
885     }
886 
887     /**
888      * @dev Hook that is called before any token transfer. This includes minting
889      * and burning, as well as batched variants.
890      *
891      * The same hook is called on both single and batched variants. For single
892      * transfers, the length of the `id` and `amount` arrays will be 1.
893      *
894      * Calling conditions (for each `id` and `amount` pair):
895      *
896      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
897      * of token type `id` will be  transferred to `to`.
898      * - When `from` is zero, `amount` tokens of token type `id` will be minted
899      * for `to`.
900      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
901      * will be burned.
902      * - `from` and `to` are never both zero.
903      * - `ids` and `amounts` have the same, non-zero length.
904      *
905      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
906      */
907     function _beforeTokenTransfer(
908         address operator,
909         address from,
910         address to,
911         uint256[] memory ids,
912         uint256[] memory amounts,
913         bytes memory data
914     ) internal virtual {}
915 
916     function _doSafeTransferAcceptanceCheck(
917         address operator,
918         address from,
919         address to,
920         uint256 id,
921         uint256 amount,
922         bytes memory data
923     ) private {
924         if (to.isContract()) {
925             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
926                 if (response != IERC1155Receiver.onERC1155Received.selector) {
927                     revert("ERC1155: ERC1155Receiver rejected tokens");
928                 }
929             } catch Error(string memory reason) {
930                 revert(reason);
931             } catch {
932                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
933             }
934         }
935     }
936 
937     function _doSafeBatchTransferAcceptanceCheck(
938         address operator,
939         address from,
940         address to,
941         uint256[] memory ids,
942         uint256[] memory amounts,
943         bytes memory data
944     ) private {
945         if (to.isContract()) {
946             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
947                 bytes4 response
948             ) {
949                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
950                     revert("ERC1155: ERC1155Receiver rejected tokens");
951                 }
952             } catch Error(string memory reason) {
953                 revert(reason);
954             } catch {
955                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
956             }
957         }
958     }
959 
960     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
961         uint256[] memory array = new uint256[](1);
962         array[0] = element;
963 
964         return array;
965     }
966 }
967 
968 /**
969  * @dev Wrappers over Solidity's arithmetic operations.
970  *
971  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
972  * now has built in overflow checking.
973  */
974 library SafeMath {
975     /**
976      * @dev Returns the addition of two unsigned integers, with an overflow flag.
977      *
978      * _Available since v3.4._
979      */
980     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
981         unchecked {
982             uint256 c = a + b;
983             if (c < a) return (false, 0);
984             return (true, c);
985         }
986     }
987 
988     /**
989      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
990      *
991      * _Available since v3.4._
992      */
993     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
994         unchecked {
995             if (b > a) return (false, 0);
996             return (true, a - b);
997         }
998     }
999 
1000     /**
1001      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1002      *
1003      * _Available since v3.4._
1004      */
1005     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1006         unchecked {
1007             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1008             // benefit is lost if 'b' is also tested.
1009             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1010             if (a == 0) return (true, 0);
1011             uint256 c = a * b;
1012             if (c / a != b) return (false, 0);
1013             return (true, c);
1014         }
1015     }
1016 
1017     /**
1018      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1019      *
1020      * _Available since v3.4._
1021      */
1022     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1023         unchecked {
1024             if (b == 0) return (false, 0);
1025             return (true, a / b);
1026         }
1027     }
1028 
1029     /**
1030      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1031      *
1032      * _Available since v3.4._
1033      */
1034     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1035         unchecked {
1036             if (b == 0) return (false, 0);
1037             return (true, a % b);
1038         }
1039     }
1040 
1041     /**
1042      * @dev Returns the addition of two unsigned integers, reverting on
1043      * overflow.
1044      *
1045      * Counterpart to Solidity's `+` operator.
1046      *
1047      * Requirements:
1048      *
1049      * - Addition cannot overflow.
1050      */
1051     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1052         return a + b;
1053     }
1054 
1055     /**
1056      * @dev Returns the subtraction of two unsigned integers, reverting on
1057      * overflow (when the result is negative).
1058      *
1059      * Counterpart to Solidity's `-` operator.
1060      *
1061      * Requirements:
1062      *
1063      * - Subtraction cannot overflow.
1064      */
1065     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1066         return a - b;
1067     }
1068 
1069     /**
1070      * @dev Returns the multiplication of two unsigned integers, reverting on
1071      * overflow.
1072      *
1073      * Counterpart to Solidity's `*` operator.
1074      *
1075      * Requirements:
1076      *
1077      * - Multiplication cannot overflow.
1078      */
1079     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1080         return a * b;
1081     }
1082 
1083     /**
1084      * @dev Returns the integer division of two unsigned integers, reverting on
1085      * division by zero. The result is rounded towards zero.
1086      *
1087      * Counterpart to Solidity's `/` operator.
1088      *
1089      * Requirements:
1090      *
1091      * - The divisor cannot be zero.
1092      */
1093     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1094         return a / b;
1095     }
1096 
1097     /**
1098      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1099      * reverting when dividing by zero.
1100      *
1101      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1102      * opcode (which leaves remaining gas untouched) while Solidity uses an
1103      * invalid opcode to revert (consuming all remaining gas).
1104      *
1105      * Requirements:
1106      *
1107      * - The divisor cannot be zero.
1108      */
1109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1110         return a % b;
1111     }
1112 
1113     /**
1114      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1115      * overflow (when the result is negative).
1116      *
1117      * CAUTION: This function is deprecated because it requires allocating memory for the error
1118      * message unnecessarily. For custom revert reasons use {trySub}.
1119      *
1120      * Counterpart to Solidity's `-` operator.
1121      *
1122      * Requirements:
1123      *
1124      * - Subtraction cannot overflow.
1125      */
1126     function sub(
1127         uint256 a,
1128         uint256 b,
1129         string memory errorMessage
1130     ) internal pure returns (uint256) {
1131         unchecked {
1132             require(b <= a, errorMessage);
1133             return a - b;
1134         }
1135     }
1136 
1137     /**
1138      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1139      * division by zero. The result is rounded towards zero.
1140      *
1141      * Counterpart to Solidity's `/` operator. Note: this function uses a
1142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1143      * uses an invalid opcode to revert (consuming all remaining gas).
1144      *
1145      * Requirements:
1146      *
1147      * - The divisor cannot be zero.
1148      */
1149     function div(
1150         uint256 a,
1151         uint256 b,
1152         string memory errorMessage
1153     ) internal pure returns (uint256) {
1154         unchecked {
1155             require(b > 0, errorMessage);
1156             return a / b;
1157         }
1158     }
1159 
1160     /**
1161      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1162      * reverting with custom message when dividing by zero.
1163      *
1164      * CAUTION: This function is deprecated because it requires allocating memory for the error
1165      * message unnecessarily. For custom revert reasons use {tryMod}.
1166      *
1167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1168      * opcode (which leaves remaining gas untouched) while Solidity uses an
1169      * invalid opcode to revert (consuming all remaining gas).
1170      *
1171      * Requirements:
1172      *
1173      * - The divisor cannot be zero.
1174      */
1175     function mod(
1176         uint256 a,
1177         uint256 b,
1178         string memory errorMessage
1179     ) internal pure returns (uint256) {
1180         unchecked {
1181             require(b > 0, errorMessage);
1182             return a % b;
1183         }
1184     }
1185 }
1186 
1187 /**
1188  * @dev String operations.
1189  */
1190 library Strings {
1191     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1192 
1193     /**
1194      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1195      */
1196     function toString(uint256 value) internal pure returns (string memory) {
1197         // Inspired by OraclizeAPI's implementation - MIT licence
1198         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1199 
1200         if (value == 0) {
1201             return "0";
1202         }
1203         uint256 temp = value;
1204         uint256 digits;
1205         while (temp != 0) {
1206             digits++;
1207             temp /= 10;
1208         }
1209         bytes memory buffer = new bytes(digits);
1210         while (value != 0) {
1211             digits -= 1;
1212             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1213             value /= 10;
1214         }
1215         return string(buffer);
1216     }
1217 
1218     /**
1219      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1220      */
1221     function toHexString(uint256 value) internal pure returns (string memory) {
1222         if (value == 0) {
1223             return "0x00";
1224         }
1225         uint256 temp = value;
1226         uint256 length = 0;
1227         while (temp != 0) {
1228             length++;
1229             temp >>= 8;
1230         }
1231         return toHexString(value, length);
1232     }
1233 
1234     /**
1235      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1236      */
1237     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1238         bytes memory buffer = new bytes(2 * length + 2);
1239         buffer[0] = "0";
1240         buffer[1] = "x";
1241         for (uint256 i = 2 * length + 1; i > 1; --i) {
1242             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1243             value >>= 4;
1244         }
1245         require(value == 0, "Strings: hex length insufficient");
1246         return string(buffer);
1247     }
1248 }
1249 contract CyborgMercenariesCm is ERC1155, Ownable {
1250     string public constant name = "CyborgMercenariesCm";
1251     string public constant symbol = "CYBORG";
1252     
1253     using SafeMath for uint256;
1254     using Strings for uint256;
1255     uint256 public totalSupply = 0;
1256     string private baseURI;
1257     string private blindURI;
1258     uint256 public constant MAX_NFT_PUBLIC = 8738;
1259     uint256 private constant MAX_NFT = 8888;
1260     uint256 public constant maxGiveaway=150;
1261     uint256 public WHITELIST_MAX_MINT = 2;
1262     mapping(address => uint256) private whiteListClaimed;
1263     uint256 public NFTPrice = 100000000000000000;  // 0.10 ETH
1264     uint256 public MAX_NFT_PRICE = 150000000000000000;  // 0.15 ETH
1265     bool public reveal;
1266     bool public isActive;
1267     bool public isPresaleActive;
1268     bytes32 public root;
1269     uint256 public giveawayCount;
1270     /*
1271      * Function to reveal all NFTs
1272     */
1273     function revealNow() 
1274         external 
1275         onlyOwner 
1276     {
1277         reveal = true;
1278     }
1279     
1280     /*
1281      * Function to mint NFTs
1282     */
1283     function mint(address to, uint32 count) internal {
1284         if (count > 1) {
1285             uint256[] memory ids = new uint256[](uint256(count));
1286             uint256[] memory amounts = new uint256[](uint256(count));
1287 
1288             for (uint32 i = 0; i < count; i++) {
1289                 ids[i] = totalSupply + i;
1290                 amounts[i] = 1;
1291             }
1292 
1293             _mintBatch(to, ids, amounts, "");
1294         } else {
1295             _mint(to, totalSupply, 1, "");
1296         }
1297 
1298         totalSupply += count;
1299     }
1300     
1301     /*
1302      * Function setIsActive to activate/desactivate the smart contract
1303     */
1304     function setIsActive(
1305         bool _isActive
1306     ) 
1307         external 
1308         onlyOwner 
1309     {
1310         isActive = _isActive;
1311     }
1312     
1313 
1314     /*
1315      * Function setPrice allow the owner to set the price of an NFT
1316     */
1317     function setPriceAndMax(
1318         uint256 _price,uint256 _max
1319     ) 
1320         external 
1321         onlyOwner 
1322     {   require(_price <= MAX_NFT_PRICE, 'The price must be smaller or equal to MAX_NFT_PRICE');
1323         require(_price > 0, 'The price must be greater than 0');
1324         NFTPrice = _price;
1325         WHITELIST_MAX_MINT=_max;
1326     }
1327     
1328     
1329     /*
1330      * Function setPresaleActive to activate/desactivate the presale  
1331     */
1332     function setPresaleActive(
1333         bool _isActive
1334     ) 
1335         external 
1336         onlyOwner 
1337     {
1338        
1339         isPresaleActive = _isActive;
1340     }
1341     
1342     /*
1343      * Function to set Base and Blind URI 
1344     */
1345     function setURIs(
1346         string memory _blindURI, 
1347         string memory _URI
1348     ) 
1349         external 
1350         onlyOwner 
1351     {
1352         blindURI = _blindURI;
1353         baseURI = _URI;
1354     }
1355     
1356     /*
1357      * Function to withdraw collected amount during minting by the owner
1358     */
1359     function withdraw(
1360     ) 
1361         public 
1362         onlyOwner 
1363     {
1364         uint balance = address(this).balance;
1365         require(balance > 0, "Balance should be more then zero");
1366         payable(owner()).transfer(balance);
1367     }
1368 
1369     
1370     /*
1371      * Function to mint new NFTs during the public sale
1372      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1373     */
1374     function mintNFT(
1375         uint32 _numOfTokens
1376     ) 
1377         public 
1378         payable 
1379     {
1380     
1381         require(isActive, 'Contract is not active');
1382         require(!isPresaleActive, 'Presale still active');
1383         require(totalSupply.add(_numOfTokens).sub(giveawayCount) <= MAX_NFT_PUBLIC, "Purchase would exceed max public supply of NFTs");
1384         require( msg.value >= NFTPrice.mul(_numOfTokens), "Ether value sent is not correct");
1385         mint(msg.sender,_numOfTokens);
1386     }
1387     
1388     /*
1389      * Function to mint new NFTs during the presale
1390      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1391     */ 
1392     function mintNFTDuringPresale(
1393         uint32 _numOfTokens,
1394         bytes32[] memory _proof
1395     ) 
1396         public 
1397         payable
1398     {
1399         require(isActive, 'Contract is not active');
1400         require(isPresaleActive, 'Presale not active');
1401         require(verify(_proof, bytes32(uint256(uint160(msg.sender)))), "Not whitelisted");
1402         require(totalSupply.sub(giveawayCount) < MAX_NFT_PUBLIC, 'All public tokens have been minted');
1403         require(totalSupply.add(_numOfTokens).sub(giveawayCount) <= MAX_NFT_PUBLIC, 'Purchase would exceed max public supply of NFTs');
1404         require( msg.value >= NFTPrice.mul(_numOfTokens), "Ether value sent is not correct");
1405         require(whiteListClaimed[msg.sender].add(_numOfTokens) <= WHITELIST_MAX_MINT, "Purchase exceeds max whitelisted");
1406         mint(msg.sender,_numOfTokens);
1407         whiteListClaimed[msg.sender] += _numOfTokens;
1408            
1409     }
1410     
1411     /*
1412      * Function to mint all NFTs for giveaway and partnerships
1413     */
1414     function mintByOwner(
1415         address _to
1416     ) 
1417         public 
1418         onlyOwner
1419     {
1420         require(totalSupply.add(1) < MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
1421         mint(_to,1);
1422     }
1423     
1424     /*
1425      * Function to mint all NFTs for giveaway and partnerships
1426     */
1427     function mintMultipleByOwner(
1428         address[] memory _to
1429     ) 
1430         public 
1431         onlyOwner
1432     {
1433         require(totalSupply.add(_to.length) < MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
1434         require(giveawayCount.add(_to.length)<=maxGiveaway,"Cannot do that much giveaway");
1435         for(uint256 i = 0; i < _to.length; i++){
1436             mint(_to[i],1);
1437         }
1438         giveawayCount=giveawayCount.add(_to.length);
1439     }
1440     
1441     /*
1442      * Function to get token URI of given token ID
1443      * URI will be blank untill totalSupply reaches MAX_NFT_PUBLIC
1444     */
1445     function uri(
1446         uint256 _tokenId
1447     ) 
1448         public 
1449         view 
1450         virtual 
1451         override 
1452         returns (string memory) 
1453     {
1454         require(_tokenId<totalSupply, "ERC1155Metadata: URI query for nonexistent token");
1455         if (!reveal) {
1456             return string(abi.encodePacked(blindURI));
1457         } else {
1458             return string(abi.encodePacked(baseURI, _tokenId.toString()));
1459         }
1460     }
1461     
1462     /*
1463      * Function to set the merkle root
1464     */
1465     function setRoot(uint256 _root) onlyOwner() public {
1466         root = bytes32(_root);
1467     }
1468     
1469     /*
1470      * Function to verify the proof
1471     */
1472     function verify(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1473         bytes32 computedHash = leaf;
1474 
1475         for (uint256 i = 0; i < proof.length; i++) {
1476             bytes32 proofElement = proof[i];
1477             
1478             if (computedHash <= proofElement) {
1479                 // Hash(current computed hash + current element of the proof)
1480                 computedHash = sha256(abi.encodePacked(computedHash, proofElement));
1481             } else {
1482                 // Hash(current element of the proof + current computed hash)
1483                 computedHash = sha256(abi.encodePacked(proofElement, computedHash));
1484             }
1485         }
1486 
1487         // Check if the computed hash (root) is equal to the provided root
1488         return computedHash == root;
1489     }
1490 }