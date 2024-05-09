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
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Address.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
117 
118 pragma solidity ^0.8.1;
119 
120 /**
121  * @dev Collection of functions related to the address type
122  */
123 library Address {
124     /**
125      * @dev Returns true if `account` is a contract.
126      *
127      * [IMPORTANT]
128      * ====
129      * It is unsafe to assume that an address for which this function returns
130      * false is an externally-owned account (EOA) and not a contract.
131      *
132      * Among others, `isContract` will return false for the following
133      * types of addresses:
134      *
135      *  - an externally-owned account
136      *  - a contract in construction
137      *  - an address where a contract will be created
138      *  - an address where a contract lived, but was destroyed
139      * ====
140      *
141      * [IMPORTANT]
142      * ====
143      * You shouldn't rely on `isContract` to protect against flash loan attacks!
144      *
145      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
146      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
147      * constructor.
148      * ====
149      */
150     function isContract(address account) internal view returns (bool) {
151         // This method relies on extcodesize/address.code.length, which returns 0
152         // for contracts in construction, since the code is only stored at the end
153         // of the constructor execution.
154 
155         return account.code.length > 0;
156     }
157 
158     /**
159      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
160      * `recipient`, forwarding all available gas and reverting on errors.
161      *
162      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
163      * of certain opcodes, possibly making contracts go over the 2300 gas limit
164      * imposed by `transfer`, making them unable to receive funds via
165      * `transfer`. {sendValue} removes this limitation.
166      *
167      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
168      *
169      * IMPORTANT: because control is transferred to `recipient`, care must be
170      * taken to not create reentrancy vulnerabilities. Consider using
171      * {ReentrancyGuard} or the
172      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
173      */
174     function sendValue(address payable recipient, uint256 amount) internal {
175         require(address(this).balance >= amount, "Address: insufficient balance");
176 
177         (bool success, ) = recipient.call{value: amount}("");
178         require(success, "Address: unable to send value, recipient may have reverted");
179     }
180 
181     /**
182      * @dev Performs a Solidity function call using a low level `call`. A
183      * plain `call` is an unsafe replacement for a function call: use this
184      * function instead.
185      *
186      * If `target` reverts with a revert reason, it is bubbled up by this
187      * function (like regular Solidity function calls).
188      *
189      * Returns the raw returned data. To convert to the expected return value,
190      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
191      *
192      * Requirements:
193      *
194      * - `target` must be a contract.
195      * - calling `target` with `data` must not revert.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
200         return functionCall(target, data, "Address: low-level call failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
205      * `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         return functionCallWithValue(target, data, 0, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but also transferring `value` wei to `target`.
220      *
221      * Requirements:
222      *
223      * - the calling contract must have an ETH balance of at least `value`.
224      * - the called Solidity function must be `payable`.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
238      * with `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(
243         address target,
244         bytes memory data,
245         uint256 value,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         require(address(this).balance >= value, "Address: insufficient balance for call");
249         require(isContract(target), "Address: call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.call{value: value}(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
262         return functionStaticCall(target, data, "Address: low-level static call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a static call.
268      *
269      * _Available since v3.3._
270      */
271     function functionStaticCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal view returns (bytes memory) {
276         require(isContract(target), "Address: static call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.staticcall(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but performing a delegate call.
285      *
286      * _Available since v3.4._
287      */
288     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
289         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
294      * but performing a delegate call.
295      *
296      * _Available since v3.4._
297      */
298     function functionDelegateCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(isContract(target), "Address: delegate call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.delegatecall(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
311      * revert reason using the provided one.
312      *
313      * _Available since v4.3._
314      */
315     function verifyCallResult(
316         bool success,
317         bytes memory returndata,
318         string memory errorMessage
319     ) internal pure returns (bytes memory) {
320         if (success) {
321             return returndata;
322         } else {
323             // Look for revert reason and bubble it up if present
324             if (returndata.length > 0) {
325                 // The easiest way to bubble the revert reason is using memory via assembly
326                 /// @solidity memory-safe-assembly
327                 assembly {
328                     let returndata_size := mload(returndata)
329                     revert(add(32, returndata), returndata_size)
330                 }
331             } else {
332                 revert(errorMessage);
333             }
334         }
335     }
336 }
337 
338 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Interface of the ERC165 standard, as defined in the
347  * https://eips.ethereum.org/EIPS/eip-165[EIP].
348  *
349  * Implementers can declare support of contract interfaces, which can then be
350  * queried by others ({ERC165Checker}).
351  *
352  * For an implementation, see {ERC165}.
353  */
354 interface IERC165 {
355     /**
356      * @dev Returns true if this contract implements the interface defined by
357      * `interfaceId`. See the corresponding
358      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
359      * to learn more about how these ids are created.
360      *
361      * This function call must use less than 30 000 gas.
362      */
363     function supportsInterface(bytes4 interfaceId) external view returns (bool);
364 }
365 
366 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 
374 /**
375  * @dev Implementation of the {IERC165} interface.
376  *
377  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
378  * for the additional interface id that will be supported. For example:
379  *
380  * ```solidity
381  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
382  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
383  * }
384  * ```
385  *
386  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
387  */
388 abstract contract ERC165 is IERC165 {
389     /**
390      * @dev See {IERC165-supportsInterface}.
391      */
392     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
393         return interfaceId == type(IERC165).interfaceId;
394     }
395 }
396 
397 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 
405 /**
406  * @dev _Available since v3.1._
407  */
408 interface IERC1155Receiver is IERC165 {
409     /**
410      * @dev Handles the receipt of a single ERC1155 token type. This function is
411      * called at the end of a `safeTransferFrom` after the balance has been updated.
412      *
413      * NOTE: To accept the transfer, this must return
414      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
415      * (i.e. 0xf23a6e61, or its own function selector).
416      *
417      * @param operator The address which initiated the transfer (i.e. msg.sender)
418      * @param from The address which previously owned the token
419      * @param id The ID of the token being transferred
420      * @param value The amount of tokens being transferred
421      * @param data Additional data with no specified format
422      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
423      */
424     function onERC1155Received(
425         address operator,
426         address from,
427         uint256 id,
428         uint256 value,
429         bytes calldata data
430     ) external returns (bytes4);
431 
432     /**
433      * @dev Handles the receipt of a multiple ERC1155 token types. This function
434      * is called at the end of a `safeBatchTransferFrom` after the balances have
435      * been updated.
436      *
437      * NOTE: To accept the transfer(s), this must return
438      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
439      * (i.e. 0xbc197c81, or its own function selector).
440      *
441      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
442      * @param from The address which previously owned the token
443      * @param ids An array containing ids of each token being transferred (order and length must match values array)
444      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
445      * @param data Additional data with no specified format
446      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
447      */
448     function onERC1155BatchReceived(
449         address operator,
450         address from,
451         uint256[] calldata ids,
452         uint256[] calldata values,
453         bytes calldata data
454     ) external returns (bytes4);
455 }
456 
457 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
458 
459 
460 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 
465 /**
466  * @dev Required interface of an ERC1155 compliant contract, as defined in the
467  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
468  *
469  * _Available since v3.1._
470  */
471 interface IERC1155 is IERC165 {
472     /**
473      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
474      */
475     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
476 
477     /**
478      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
479      * transfers.
480      */
481     event TransferBatch(
482         address indexed operator,
483         address indexed from,
484         address indexed to,
485         uint256[] ids,
486         uint256[] values
487     );
488 
489     /**
490      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
491      * `approved`.
492      */
493     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
494 
495     /**
496      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
497      *
498      * If an {URI} event was emitted for `id`, the standard
499      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
500      * returned by {IERC1155MetadataURI-uri}.
501      */
502     event URI(string value, uint256 indexed id);
503 
504     /**
505      * @dev Returns the amount of tokens of token type `id` owned by `account`.
506      *
507      * Requirements:
508      *
509      * - `account` cannot be the zero address.
510      */
511     function balanceOf(address account, uint256 id) external view returns (uint256);
512 
513     /**
514      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
515      *
516      * Requirements:
517      *
518      * - `accounts` and `ids` must have the same length.
519      */
520     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
521         external
522         view
523         returns (uint256[] memory);
524 
525     /**
526      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
527      *
528      * Emits an {ApprovalForAll} event.
529      *
530      * Requirements:
531      *
532      * - `operator` cannot be the caller.
533      */
534     function setApprovalForAll(address operator, bool approved) external;
535 
536     /**
537      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
538      *
539      * See {setApprovalForAll}.
540      */
541     function isApprovedForAll(address account, address operator) external view returns (bool);
542 
543     /**
544      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
545      *
546      * Emits a {TransferSingle} event.
547      *
548      * Requirements:
549      *
550      * - `to` cannot be the zero address.
551      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
552      * - `from` must have a balance of tokens of type `id` of at least `amount`.
553      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
554      * acceptance magic value.
555      */
556     function safeTransferFrom(
557         address from,
558         address to,
559         uint256 id,
560         uint256 amount,
561         bytes calldata data
562     ) external;
563 
564     /**
565      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
566      *
567      * Emits a {TransferBatch} event.
568      *
569      * Requirements:
570      *
571      * - `ids` and `amounts` must have the same length.
572      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
573      * acceptance magic value.
574      */
575     function safeBatchTransferFrom(
576         address from,
577         address to,
578         uint256[] calldata ids,
579         uint256[] calldata amounts,
580         bytes calldata data
581     ) external;
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
594  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
595  *
596  * _Available since v3.1._
597  */
598 interface IERC1155MetadataURI is IERC1155 {
599     /**
600      * @dev Returns the URI for token type `id`.
601      *
602      * If the `\{id\}` substring is present in the URI, it must be replaced by
603      * clients with the actual token type ID.
604      */
605     function uri(uint256 id) external view returns (string memory);
606 }
607 
608 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
609 
610 
611 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 
616 
617 
618 
619 
620 
621 /**
622  * @dev Implementation of the basic standard multi-token.
623  * See https://eips.ethereum.org/EIPS/eip-1155
624  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
625  *
626  * _Available since v3.1._
627  */
628 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
629     using Address for address;
630 
631     // Mapping from token ID to account balances
632     mapping(uint256 => mapping(address => uint256)) private _balances;
633 
634     // Mapping from account to operator approvals
635     mapping(address => mapping(address => bool)) private _operatorApprovals;
636 
637     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
638     string private _uri;
639 
640     /**
641      * @dev See {_setURI}.
642      */
643     constructor(string memory uri_) {
644         _setURI(uri_);
645     }
646 
647     /**
648      * @dev See {IERC165-supportsInterface}.
649      */
650     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
651         return
652             interfaceId == type(IERC1155).interfaceId ||
653             interfaceId == type(IERC1155MetadataURI).interfaceId ||
654             super.supportsInterface(interfaceId);
655     }
656 
657     /**
658      * @dev See {IERC1155MetadataURI-uri}.
659      *
660      * This implementation returns the same URI for *all* token types. It relies
661      * on the token type ID substitution mechanism
662      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
663      *
664      * Clients calling this function must replace the `\{id\}` substring with the
665      * actual token type ID.
666      */
667     function uri(uint256) public view virtual override returns (string memory) {
668         return _uri;
669     }
670 
671     /**
672      * @dev See {IERC1155-balanceOf}.
673      *
674      * Requirements:
675      *
676      * - `account` cannot be the zero address.
677      */
678     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
679         require(account != address(0), "ERC1155: address zero is not a valid owner");
680         return _balances[id][account];
681     }
682 
683     /**
684      * @dev See {IERC1155-balanceOfBatch}.
685      *
686      * Requirements:
687      *
688      * - `accounts` and `ids` must have the same length.
689      */
690     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
691         public
692         view
693         virtual
694         override
695         returns (uint256[] memory)
696     {
697         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
698 
699         uint256[] memory batchBalances = new uint256[](accounts.length);
700 
701         for (uint256 i = 0; i < accounts.length; ++i) {
702             batchBalances[i] = balanceOf(accounts[i], ids[i]);
703         }
704 
705         return batchBalances;
706     }
707 
708     /**
709      * @dev See {IERC1155-setApprovalForAll}.
710      */
711     function setApprovalForAll(address operator, bool approved) public virtual override {
712         _setApprovalForAll(_msgSender(), operator, approved);
713     }
714 
715     /**
716      * @dev See {IERC1155-isApprovedForAll}.
717      */
718     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[account][operator];
720     }
721 
722     /**
723      * @dev See {IERC1155-safeTransferFrom}.
724      */
725     function safeTransferFrom(
726         address from,
727         address to,
728         uint256 id,
729         uint256 amount,
730         bytes memory data
731     ) public virtual override {
732         require(
733             from == _msgSender() || isApprovedForAll(from, _msgSender()),
734             "ERC1155: caller is not token owner nor approved"
735         );
736         _safeTransferFrom(from, to, id, amount, data);
737     }
738 
739     /**
740      * @dev See {IERC1155-safeBatchTransferFrom}.
741      */
742     function safeBatchTransferFrom(
743         address from,
744         address to,
745         uint256[] memory ids,
746         uint256[] memory amounts,
747         bytes memory data
748     ) public virtual override {
749         require(
750             from == _msgSender() || isApprovedForAll(from, _msgSender()),
751             "ERC1155: caller is not token owner nor approved"
752         );
753         _safeBatchTransferFrom(from, to, ids, amounts, data);
754     }
755 
756     /**
757      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
758      *
759      * Emits a {TransferSingle} event.
760      *
761      * Requirements:
762      *
763      * - `to` cannot be the zero address.
764      * - `from` must have a balance of tokens of type `id` of at least `amount`.
765      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
766      * acceptance magic value.
767      */
768     function _safeTransferFrom(
769         address from,
770         address to,
771         uint256 id,
772         uint256 amount,
773         bytes memory data
774     ) internal virtual {
775         require(to != address(0), "ERC1155: transfer to the zero address");
776 
777         address operator = _msgSender();
778         uint256[] memory ids = _asSingletonArray(id);
779         uint256[] memory amounts = _asSingletonArray(amount);
780 
781         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
782 
783         uint256 fromBalance = _balances[id][from];
784         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
785         unchecked {
786             _balances[id][from] = fromBalance - amount;
787         }
788         _balances[id][to] += amount;
789 
790         emit TransferSingle(operator, from, to, id, amount);
791 
792         _afterTokenTransfer(operator, from, to, ids, amounts, data);
793 
794         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
795     }
796 
797     /**
798      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
799      *
800      * Emits a {TransferBatch} event.
801      *
802      * Requirements:
803      *
804      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
805      * acceptance magic value.
806      */
807     function _safeBatchTransferFrom(
808         address from,
809         address to,
810         uint256[] memory ids,
811         uint256[] memory amounts,
812         bytes memory data
813     ) internal virtual {
814         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
815         require(to != address(0), "ERC1155: transfer to the zero address");
816 
817         address operator = _msgSender();
818 
819         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
820 
821         for (uint256 i = 0; i < ids.length; ++i) {
822             uint256 id = ids[i];
823             uint256 amount = amounts[i];
824 
825             uint256 fromBalance = _balances[id][from];
826             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
827             unchecked {
828                 _balances[id][from] = fromBalance - amount;
829             }
830             _balances[id][to] += amount;
831         }
832 
833         emit TransferBatch(operator, from, to, ids, amounts);
834 
835         _afterTokenTransfer(operator, from, to, ids, amounts, data);
836 
837         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
838     }
839 
840     /**
841      * @dev Sets a new URI for all token types, by relying on the token type ID
842      * substitution mechanism
843      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
844      *
845      * By this mechanism, any occurrence of the `\{id\}` substring in either the
846      * URI or any of the amounts in the JSON file at said URI will be replaced by
847      * clients with the token type ID.
848      *
849      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
850      * interpreted by clients as
851      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
852      * for token type ID 0x4cce0.
853      *
854      * See {uri}.
855      *
856      * Because these URIs cannot be meaningfully represented by the {URI} event,
857      * this function emits no events.
858      */
859     function _setURI(string memory newuri) internal virtual {
860         _uri = newuri;
861     }
862 
863     /**
864      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
865      *
866      * Emits a {TransferSingle} event.
867      *
868      * Requirements:
869      *
870      * - `to` cannot be the zero address.
871      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
872      * acceptance magic value.
873      */
874     function _mint(
875         address to,
876         uint256 id,
877         uint256 amount,
878         bytes memory data
879     ) internal virtual {
880         require(to != address(0), "ERC1155: mint to the zero address");
881 
882         address operator = _msgSender();
883         uint256[] memory ids = _asSingletonArray(id);
884         uint256[] memory amounts = _asSingletonArray(amount);
885 
886         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
887 
888         _balances[id][to] += amount;
889         emit TransferSingle(operator, address(0), to, id, amount);
890 
891         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
892 
893         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
894     }
895 
896     /**
897      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
898      *
899      * Emits a {TransferBatch} event.
900      *
901      * Requirements:
902      *
903      * - `ids` and `amounts` must have the same length.
904      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
905      * acceptance magic value.
906      */
907     function _mintBatch(
908         address to,
909         uint256[] memory ids,
910         uint256[] memory amounts,
911         bytes memory data
912     ) internal virtual {
913         require(to != address(0), "ERC1155: mint to the zero address");
914         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
915 
916         address operator = _msgSender();
917 
918         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
919 
920         for (uint256 i = 0; i < ids.length; i++) {
921             _balances[ids[i]][to] += amounts[i];
922         }
923 
924         emit TransferBatch(operator, address(0), to, ids, amounts);
925 
926         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
927 
928         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
929     }
930 
931     /**
932      * @dev Destroys `amount` tokens of token type `id` from `from`
933      *
934      * Emits a {TransferSingle} event.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `from` must have at least `amount` tokens of token type `id`.
940      */
941     function _burn(
942         address from,
943         uint256 id,
944         uint256 amount
945     ) internal virtual {
946         require(from != address(0), "ERC1155: burn from the zero address");
947 
948         address operator = _msgSender();
949         uint256[] memory ids = _asSingletonArray(id);
950         uint256[] memory amounts = _asSingletonArray(amount);
951 
952         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
953 
954         uint256 fromBalance = _balances[id][from];
955         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
956         unchecked {
957             _balances[id][from] = fromBalance - amount;
958         }
959 
960         emit TransferSingle(operator, from, address(0), id, amount);
961 
962         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
963     }
964 
965     /**
966      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
967      *
968      * Emits a {TransferBatch} event.
969      *
970      * Requirements:
971      *
972      * - `ids` and `amounts` must have the same length.
973      */
974     function _burnBatch(
975         address from,
976         uint256[] memory ids,
977         uint256[] memory amounts
978     ) internal virtual {
979         require(from != address(0), "ERC1155: burn from the zero address");
980         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
981 
982         address operator = _msgSender();
983 
984         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
985 
986         for (uint256 i = 0; i < ids.length; i++) {
987             uint256 id = ids[i];
988             uint256 amount = amounts[i];
989 
990             uint256 fromBalance = _balances[id][from];
991             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
992             unchecked {
993                 _balances[id][from] = fromBalance - amount;
994             }
995         }
996 
997         emit TransferBatch(operator, from, address(0), ids, amounts);
998 
999         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1000     }
1001 
1002     /**
1003      * @dev Approve `operator` to operate on all of `owner` tokens
1004      *
1005      * Emits an {ApprovalForAll} event.
1006      */
1007     function _setApprovalForAll(
1008         address owner,
1009         address operator,
1010         bool approved
1011     ) internal virtual {
1012         require(owner != operator, "ERC1155: setting approval status for self");
1013         _operatorApprovals[owner][operator] = approved;
1014         emit ApprovalForAll(owner, operator, approved);
1015     }
1016 
1017     /**
1018      * @dev Hook that is called before any token transfer. This includes minting
1019      * and burning, as well as batched variants.
1020      *
1021      * The same hook is called on both single and batched variants. For single
1022      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1023      *
1024      * Calling conditions (for each `id` and `amount` pair):
1025      *
1026      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1027      * of token type `id` will be  transferred to `to`.
1028      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1029      * for `to`.
1030      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1031      * will be burned.
1032      * - `from` and `to` are never both zero.
1033      * - `ids` and `amounts` have the same, non-zero length.
1034      *
1035      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1036      */
1037     function _beforeTokenTransfer(
1038         address operator,
1039         address from,
1040         address to,
1041         uint256[] memory ids,
1042         uint256[] memory amounts,
1043         bytes memory data
1044     ) internal virtual {}
1045 
1046     /**
1047      * @dev Hook that is called after any token transfer. This includes minting
1048      * and burning, as well as batched variants.
1049      *
1050      * The same hook is called on both single and batched variants. For single
1051      * transfers, the length of the `id` and `amount` arrays will be 1.
1052      *
1053      * Calling conditions (for each `id` and `amount` pair):
1054      *
1055      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1056      * of token type `id` will be  transferred to `to`.
1057      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1058      * for `to`.
1059      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1060      * will be burned.
1061      * - `from` and `to` are never both zero.
1062      * - `ids` and `amounts` have the same, non-zero length.
1063      *
1064      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1065      */
1066     function _afterTokenTransfer(
1067         address operator,
1068         address from,
1069         address to,
1070         uint256[] memory ids,
1071         uint256[] memory amounts,
1072         bytes memory data
1073     ) internal virtual {}
1074 
1075     function _doSafeTransferAcceptanceCheck(
1076         address operator,
1077         address from,
1078         address to,
1079         uint256 id,
1080         uint256 amount,
1081         bytes memory data
1082     ) private {
1083         if (to.isContract()) {
1084             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1085                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1086                     revert("ERC1155: ERC1155Receiver rejected tokens");
1087                 }
1088             } catch Error(string memory reason) {
1089                 revert(reason);
1090             } catch {
1091                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1092             }
1093         }
1094     }
1095 
1096     function _doSafeBatchTransferAcceptanceCheck(
1097         address operator,
1098         address from,
1099         address to,
1100         uint256[] memory ids,
1101         uint256[] memory amounts,
1102         bytes memory data
1103     ) private {
1104         if (to.isContract()) {
1105             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1106                 bytes4 response
1107             ) {
1108                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1109                     revert("ERC1155: ERC1155Receiver rejected tokens");
1110                 }
1111             } catch Error(string memory reason) {
1112                 revert(reason);
1113             } catch {
1114                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1115             }
1116         }
1117     }
1118 
1119     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1120         uint256[] memory array = new uint256[](1);
1121         array[0] = element;
1122 
1123         return array;
1124     }
1125 }
1126 
1127 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1128 
1129 
1130 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 /**
1136  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1137  *
1138  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1139  * clearly identified. Note: While a totalSupply of 1 might mean the
1140  * corresponding is an NFT, there is no guarantees that no other token with the
1141  * same id are not going to be minted.
1142  */
1143 abstract contract ERC1155Supply is ERC1155 {
1144     mapping(uint256 => uint256) private _totalSupply;
1145 
1146     /**
1147      * @dev Total amount of tokens in with a given id.
1148      */
1149     function totalSupply(uint256 id) public view virtual returns (uint256) {
1150         return _totalSupply[id];
1151     }
1152 
1153     /**
1154      * @dev Indicates whether any token exist with a given id, or not.
1155      */
1156     function exists(uint256 id) public view virtual returns (bool) {
1157         return ERC1155Supply.totalSupply(id) > 0;
1158     }
1159 
1160     /**
1161      * @dev See {ERC1155-_beforeTokenTransfer}.
1162      */
1163     function _beforeTokenTransfer(
1164         address operator,
1165         address from,
1166         address to,
1167         uint256[] memory ids,
1168         uint256[] memory amounts,
1169         bytes memory data
1170     ) internal virtual override {
1171         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1172 
1173         if (from == address(0)) {
1174             for (uint256 i = 0; i < ids.length; ++i) {
1175                 _totalSupply[ids[i]] += amounts[i];
1176             }
1177         }
1178 
1179         if (to == address(0)) {
1180             for (uint256 i = 0; i < ids.length; ++i) {
1181                 uint256 id = ids[i];
1182                 uint256 amount = amounts[i];
1183                 uint256 supply = _totalSupply[id];
1184                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1185                 unchecked {
1186                     _totalSupply[id] = supply - amount;
1187                 }
1188             }
1189         }
1190     }
1191 }
1192 
1193 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1194 
1195 
1196 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 
1201 /**
1202  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1203  * own tokens and those that they have been approved to use.
1204  *
1205  * _Available since v3.1._
1206  */
1207 abstract contract ERC1155Burnable is ERC1155 {
1208     function burn(
1209         address account,
1210         uint256 id,
1211         uint256 value
1212     ) public virtual {
1213         require(
1214             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1215             "ERC1155: caller is not token owner nor approved"
1216         );
1217 
1218         _burn(account, id, value);
1219     }
1220 
1221     function burnBatch(
1222         address account,
1223         uint256[] memory ids,
1224         uint256[] memory values
1225     ) public virtual {
1226         require(
1227             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1228             "ERC1155: caller is not token owner nor approved"
1229         );
1230 
1231         _burnBatch(account, ids, values);
1232     }
1233 }
1234 
1235 // File: contract/ERC1155.sol
1236 
1237 
1238 pragma solidity ^0.8.4;
1239 
1240 
1241 
1242 
1243 
1244 contract Hitchhikerofstar is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
1245     constructor()
1246         ERC1155("https://resource.hypernft.world/properties/{id}.json")
1247     {}
1248 
1249     function setURI(string memory newuri) public onlyOwner {
1250         _setURI(newuri);
1251     }
1252 
1253     function mint(address account, uint256 id, uint256 amount, bytes memory data)
1254         public
1255         onlyOwner
1256     {
1257         _mint(account, id, amount, data);
1258     }
1259 
1260     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1261         public
1262         onlyOwner
1263     {
1264         _mintBatch(to, ids, amounts, data);
1265     }
1266 
1267     // The following functions are overrides required by Solidity.
1268 
1269     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1270         internal
1271         override(ERC1155, ERC1155Supply)
1272     {
1273         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1274     }
1275 }