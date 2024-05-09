1 // SPDX-License-Identifier: MIT
2 
3 // Sources flattened with hardhat v2.13.0 https://hardhat.org
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
32 
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(
96             newOwner != address(0),
97             "Ownable: new owner is the zero address"
98         );
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
113 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
114 
115 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Interface of the ERC165 standard, as defined in the
121  * https://eips.ethereum.org/EIPS/eip-165[EIP].
122  *
123  * Implementers can declare support of contract interfaces, which can then be
124  * queried by others ({ERC165Checker}).
125  *
126  * For an implementation, see {ERC165}.
127  */
128 interface IERC165 {
129     /**
130      * @dev Returns true if this contract implements the interface defined by
131      * `interfaceId`. See the corresponding
132      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
133      * to learn more about how these ids are created.
134      *
135      * This function call must use less than 30 000 gas.
136      */
137     function supportsInterface(bytes4 interfaceId) external view returns (bool);
138 }
139 
140 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.6.0
141 
142 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Required interface of an ERC1155 compliant contract, as defined in the
148  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
149  *
150  * _Available since v3.1._
151  */
152 interface IERC1155 is IERC165 {
153     /**
154      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
155      */
156     event TransferSingle(
157         address indexed operator,
158         address indexed from,
159         address indexed to,
160         uint256 id,
161         uint256 value
162     );
163 
164     /**
165      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
166      * transfers.
167      */
168     event TransferBatch(
169         address indexed operator,
170         address indexed from,
171         address indexed to,
172         uint256[] ids,
173         uint256[] values
174     );
175 
176     /**
177      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
178      * `approved`.
179      */
180     event ApprovalForAll(
181         address indexed account,
182         address indexed operator,
183         bool approved
184     );
185 
186     /**
187      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
188      *
189      * If an {URI} event was emitted for `id`, the standard
190      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
191      * returned by {IERC1155MetadataURI-uri}.
192      */
193     event URI(string value, uint256 indexed id);
194 
195     /**
196      * @dev Returns the amount of tokens of token type `id` owned by `account`.
197      *
198      * Requirements:
199      *
200      * - `account` cannot be the zero address.
201      */
202     function balanceOf(
203         address account,
204         uint256 id
205     ) external view returns (uint256);
206 
207     /**
208      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
209      *
210      * Requirements:
211      *
212      * - `accounts` and `ids` must have the same length.
213      */
214     function balanceOfBatch(
215         address[] calldata accounts,
216         uint256[] calldata ids
217     ) external view returns (uint256[] memory);
218 
219     /**
220      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
221      *
222      * Emits an {ApprovalForAll} event.
223      *
224      * Requirements:
225      *
226      * - `operator` cannot be the caller.
227      */
228     function setApprovalForAll(address operator, bool approved) external;
229 
230     /**
231      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
232      *
233      * See {setApprovalForAll}.
234      */
235     function isApprovedForAll(
236         address account,
237         address operator
238     ) external view returns (bool);
239 
240     /**
241      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
242      *
243      * Emits a {TransferSingle} event.
244      *
245      * Requirements:
246      *
247      * - `to` cannot be the zero address.
248      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
249      * - `from` must have a balance of tokens of type `id` of at least `amount`.
250      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
251      * acceptance magic value.
252      */
253     function safeTransferFrom(
254         address from,
255         address to,
256         uint256 id,
257         uint256 amount,
258         bytes calldata data
259     ) external;
260 
261     /**
262      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
263      *
264      * Emits a {TransferBatch} event.
265      *
266      * Requirements:
267      *
268      * - `ids` and `amounts` must have the same length.
269      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
270      * acceptance magic value.
271      */
272     function safeBatchTransferFrom(
273         address from,
274         address to,
275         uint256[] calldata ids,
276         uint256[] calldata amounts,
277         bytes calldata data
278     ) external;
279 }
280 
281 // File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.6.0
282 
283 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
289  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
290  *
291  * _Available since v3.1._
292  */
293 interface IERC1155MetadataURI is IERC1155 {
294     /**
295      * @dev Returns the URI for token type `id`.
296      *
297      * If the `\{id\}` substring is present in the URI, it must be replaced by
298      * clients with the actual token type ID.
299      */
300     function uri(uint256 id) external view returns (string memory);
301 }
302 
303 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.6.0
304 
305 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev _Available since v3.1._
311  */
312 interface IERC1155Receiver is IERC165 {
313     /**
314      * @dev Handles the receipt of a single ERC1155 token type. This function is
315      * called at the end of a `safeTransferFrom` after the balance has been updated.
316      *
317      * NOTE: To accept the transfer, this must return
318      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
319      * (i.e. 0xf23a6e61, or its own function selector).
320      *
321      * @param operator The address which initiated the transfer (i.e. msg.sender)
322      * @param from The address which previously owned the token
323      * @param id The ID of the token being transferred
324      * @param value The amount of tokens being transferred
325      * @param data Additional data with no specified format
326      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
327      */
328     function onERC1155Received(
329         address operator,
330         address from,
331         uint256 id,
332         uint256 value,
333         bytes calldata data
334     ) external returns (bytes4);
335 
336     /**
337      * @dev Handles the receipt of a multiple ERC1155 token types. This function
338      * is called at the end of a `safeBatchTransferFrom` after the balances have
339      * been updated.
340      *
341      * NOTE: To accept the transfer(s), this must return
342      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
343      * (i.e. 0xbc197c81, or its own function selector).
344      *
345      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
346      * @param from The address which previously owned the token
347      * @param ids An array containing ids of each token being transferred (order and length must match values array)
348      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
349      * @param data Additional data with no specified format
350      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
351      */
352     function onERC1155BatchReceived(
353         address operator,
354         address from,
355         uint256[] calldata ids,
356         uint256[] calldata values,
357         bytes calldata data
358     ) external returns (bytes4);
359 }
360 
361 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
362 
363 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
364 
365 pragma solidity ^0.8.1;
366 
367 /**
368  * @dev Collection of functions related to the address type
369  */
370 library Address {
371     /**
372      * @dev Returns true if `account` is a contract.
373      *
374      * [IMPORTANT]
375      * ====
376      * It is unsafe to assume that an address for which this function returns
377      * false is an externally-owned account (EOA) and not a contract.
378      *
379      * Among others, `isContract` will return false for the following
380      * types of addresses:
381      *
382      *  - an externally-owned account
383      *  - a contract in construction
384      *  - an address where a contract will be created
385      *  - an address where a contract lived, but was destroyed
386      * ====
387      *
388      * [IMPORTANT]
389      * ====
390      * You shouldn't rely on `isContract` to protect against flash loan attacks!
391      *
392      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
393      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
394      * constructor.
395      * ====
396      */
397     function isContract(address account) internal view returns (bool) {
398         // This method relies on extcodesize/address.code.length, which returns 0
399         // for contracts in construction, since the code is only stored at the end
400         // of the constructor execution.
401 
402         return account.code.length > 0;
403     }
404 
405     /**
406      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
407      * `recipient`, forwarding all available gas and reverting on errors.
408      *
409      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
410      * of certain opcodes, possibly making contracts go over the 2300 gas limit
411      * imposed by `transfer`, making them unable to receive funds via
412      * `transfer`. {sendValue} removes this limitation.
413      *
414      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
415      *
416      * IMPORTANT: because control is transferred to `recipient`, care must be
417      * taken to not create reentrancy vulnerabilities. Consider using
418      * {ReentrancyGuard} or the
419      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
420      */
421     function sendValue(address payable recipient, uint256 amount) internal {
422         require(
423             address(this).balance >= amount,
424             "Address: insufficient balance"
425         );
426 
427         (bool success, ) = recipient.call{value: amount}("");
428         require(
429             success,
430             "Address: unable to send value, recipient may have reverted"
431         );
432     }
433 
434     /**
435      * @dev Performs a Solidity function call using a low level `call`. A
436      * plain `call` is an unsafe replacement for a function call: use this
437      * function instead.
438      *
439      * If `target` reverts with a revert reason, it is bubbled up by this
440      * function (like regular Solidity function calls).
441      *
442      * Returns the raw returned data. To convert to the expected return value,
443      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
444      *
445      * Requirements:
446      *
447      * - `target` must be a contract.
448      * - calling `target` with `data` must not revert.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(
453         address target,
454         bytes memory data
455     ) internal returns (bytes memory) {
456         return functionCall(target, data, "Address: low-level call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
461      * `errorMessage` as a fallback revert reason when `target` reverts.
462      *
463      * _Available since v3.1._
464      */
465     function functionCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal returns (bytes memory) {
470         return functionCallWithValue(target, data, 0, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but also transferring `value` wei to `target`.
476      *
477      * Requirements:
478      *
479      * - the calling contract must have an ETH balance of at least `value`.
480      * - the called Solidity function must be `payable`.
481      *
482      * _Available since v3.1._
483      */
484     function functionCallWithValue(
485         address target,
486         bytes memory data,
487         uint256 value
488     ) internal returns (bytes memory) {
489         return
490             functionCallWithValue(
491                 target,
492                 data,
493                 value,
494                 "Address: low-level call with value failed"
495             );
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
500      * with `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         require(
511             address(this).balance >= value,
512             "Address: insufficient balance for call"
513         );
514         require(isContract(target), "Address: call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.call{value: value}(
517             data
518         );
519         return verifyCallResult(success, returndata, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but performing a static call.
525      *
526      * _Available since v3.3._
527      */
528     function functionStaticCall(
529         address target,
530         bytes memory data
531     ) internal view returns (bytes memory) {
532         return
533             functionStaticCall(
534                 target,
535                 data,
536                 "Address: low-level static call failed"
537             );
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal view returns (bytes memory) {
551         require(isContract(target), "Address: static call to non-contract");
552 
553         (bool success, bytes memory returndata) = target.staticcall(data);
554         return verifyCallResult(success, returndata, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(
564         address target,
565         bytes memory data
566     ) internal returns (bytes memory) {
567         return
568             functionDelegateCall(
569                 target,
570                 data,
571                 "Address: low-level delegate call failed"
572             );
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         require(isContract(target), "Address: delegate call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.delegatecall(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
594      * revert reason using the provided one.
595      *
596      * _Available since v4.3._
597      */
598     function verifyCallResult(
599         bool success,
600         bytes memory returndata,
601         string memory errorMessage
602     ) internal pure returns (bytes memory) {
603         if (success) {
604             return returndata;
605         } else {
606             // Look for revert reason and bubble it up if present
607             if (returndata.length > 0) {
608                 // The easiest way to bubble the revert reason is using memory via assembly
609 
610                 assembly {
611                     let returndata_size := mload(returndata)
612                     revert(add(32, returndata), returndata_size)
613                 }
614             } else {
615                 revert(errorMessage);
616             }
617         }
618     }
619 }
620 
621 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
622 
623 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev Implementation of the {IERC165} interface.
629  *
630  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
631  * for the additional interface id that will be supported. For example:
632  *
633  * ```solidity
634  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
635  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
636  * }
637  * ```
638  *
639  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
640  */
641 abstract contract ERC165 is IERC165 {
642     /**
643      * @dev See {IERC165-supportsInterface}.
644      */
645     function supportsInterface(
646         bytes4 interfaceId
647     ) public view virtual override returns (bool) {
648         return interfaceId == type(IERC165).interfaceId;
649     }
650 }
651 
652 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.6.0
653 
654 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Implementation of the basic standard multi-token.
660  * See https://eips.ethereum.org/EIPS/eip-1155
661  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
662  *
663  * _Available since v3.1._
664  */
665 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
666     using Address for address;
667 
668     // Mapping from token ID to account balances
669     mapping(uint256 => mapping(address => uint256)) private _balances;
670 
671     // Mapping from account to operator approvals
672     mapping(address => mapping(address => bool)) private _operatorApprovals;
673 
674     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
675     string private _uri;
676 
677     /**
678      * @dev See {_setURI}.
679      */
680     constructor(string memory uri_) {
681         _setURI(uri_);
682     }
683 
684     /**
685      * @dev See {IERC165-supportsInterface}.
686      */
687     function supportsInterface(
688         bytes4 interfaceId
689     ) public view virtual override(ERC165, IERC165) returns (bool) {
690         return
691             interfaceId == type(IERC1155).interfaceId ||
692             interfaceId == type(IERC1155MetadataURI).interfaceId ||
693             super.supportsInterface(interfaceId);
694     }
695 
696     /**
697      * @dev See {IERC1155MetadataURI-uri}.
698      *
699      * This implementation returns the same URI for *all* token types. It relies
700      * on the token type ID substitution mechanism
701      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
702      *
703      * Clients calling this function must replace the `\{id\}` substring with the
704      * actual token type ID.
705      */
706     function uri(uint256) public view virtual override returns (string memory) {
707         return _uri;
708     }
709 
710     /**
711      * @dev See {IERC1155-balanceOf}.
712      *
713      * Requirements:
714      *
715      * - `account` cannot be the zero address.
716      */
717     function balanceOf(
718         address account,
719         uint256 id
720     ) public view virtual override returns (uint256) {
721         require(
722             account != address(0),
723             "ERC1155: balance query for the zero address"
724         );
725         return _balances[id][account];
726     }
727 
728     /**
729      * @dev See {IERC1155-balanceOfBatch}.
730      *
731      * Requirements:
732      *
733      * - `accounts` and `ids` must have the same length.
734      */
735     function balanceOfBatch(
736         address[] memory accounts,
737         uint256[] memory ids
738     ) public view virtual override returns (uint256[] memory) {
739         require(
740             accounts.length == ids.length,
741             "ERC1155: accounts and ids length mismatch"
742         );
743 
744         uint256[] memory batchBalances = new uint256[](accounts.length);
745 
746         for (uint256 i = 0; i < accounts.length; ++i) {
747             batchBalances[i] = balanceOf(accounts[i], ids[i]);
748         }
749 
750         return batchBalances;
751     }
752 
753     /**
754      * @dev See {IERC1155-setApprovalForAll}.
755      */
756     function setApprovalForAll(
757         address operator,
758         bool approved
759     ) public virtual override {
760         _setApprovalForAll(_msgSender(), operator, approved);
761     }
762 
763     /**
764      * @dev See {IERC1155-isApprovedForAll}.
765      */
766     function isApprovedForAll(
767         address account,
768         address operator
769     ) public view virtual override returns (bool) {
770         return _operatorApprovals[account][operator];
771     }
772 
773     /**
774      * @dev See {IERC1155-safeTransferFrom}.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 id,
780         uint256 amount,
781         bytes memory data
782     ) public virtual override {
783         require(
784             from == _msgSender() || isApprovedForAll(from, _msgSender()),
785             "ERC1155: caller is not owner nor approved"
786         );
787         _safeTransferFrom(from, to, id, amount, data);
788     }
789 
790     /**
791      * @dev See {IERC1155-safeBatchTransferFrom}.
792      */
793     function safeBatchTransferFrom(
794         address from,
795         address to,
796         uint256[] memory ids,
797         uint256[] memory amounts,
798         bytes memory data
799     ) public virtual override {
800         require(
801             from == _msgSender() || isApprovedForAll(from, _msgSender()),
802             "ERC1155: transfer caller is not owner nor approved"
803         );
804         _safeBatchTransferFrom(from, to, ids, amounts, data);
805     }
806 
807     /**
808      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
809      *
810      * Emits a {TransferSingle} event.
811      *
812      * Requirements:
813      *
814      * - `to` cannot be the zero address.
815      * - `from` must have a balance of tokens of type `id` of at least `amount`.
816      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
817      * acceptance magic value.
818      */
819     function _safeTransferFrom(
820         address from,
821         address to,
822         uint256 id,
823         uint256 amount,
824         bytes memory data
825     ) internal virtual {
826         require(to != address(0), "ERC1155: transfer to the zero address");
827 
828         address operator = _msgSender();
829         uint256[] memory ids = _asSingletonArray(id);
830         uint256[] memory amounts = _asSingletonArray(amount);
831 
832         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
833 
834         uint256 fromBalance = _balances[id][from];
835         require(
836             fromBalance >= amount,
837             "ERC1155: insufficient balance for transfer"
838         );
839         unchecked {
840             _balances[id][from] = fromBalance - amount;
841         }
842         _balances[id][to] += amount;
843 
844         emit TransferSingle(operator, from, to, id, amount);
845 
846         _afterTokenTransfer(operator, from, to, ids, amounts, data);
847 
848         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
849     }
850 
851     /**
852      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
853      *
854      * Emits a {TransferBatch} event.
855      *
856      * Requirements:
857      *
858      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
859      * acceptance magic value.
860      */
861     function _safeBatchTransferFrom(
862         address from,
863         address to,
864         uint256[] memory ids,
865         uint256[] memory amounts,
866         bytes memory data
867     ) internal virtual {
868         require(
869             ids.length == amounts.length,
870             "ERC1155: ids and amounts length mismatch"
871         );
872         require(to != address(0), "ERC1155: transfer to the zero address");
873 
874         address operator = _msgSender();
875 
876         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
877 
878         for (uint256 i = 0; i < ids.length; ++i) {
879             uint256 id = ids[i];
880             uint256 amount = amounts[i];
881 
882             uint256 fromBalance = _balances[id][from];
883             require(
884                 fromBalance >= amount,
885                 "ERC1155: insufficient balance for transfer"
886             );
887             unchecked {
888                 _balances[id][from] = fromBalance - amount;
889             }
890             _balances[id][to] += amount;
891         }
892 
893         emit TransferBatch(operator, from, to, ids, amounts);
894 
895         _afterTokenTransfer(operator, from, to, ids, amounts, data);
896 
897         _doSafeBatchTransferAcceptanceCheck(
898             operator,
899             from,
900             to,
901             ids,
902             amounts,
903             data
904         );
905     }
906 
907     /**
908      * @dev Sets a new URI for all token types, by relying on the token type ID
909      * substitution mechanism
910      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
911      *
912      * By this mechanism, any occurrence of the `\{id\}` substring in either the
913      * URI or any of the amounts in the JSON file at said URI will be replaced by
914      * clients with the token type ID.
915      *
916      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
917      * interpreted by clients as
918      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
919      * for token type ID 0x4cce0.
920      *
921      * See {uri}.
922      *
923      * Because these URIs cannot be meaningfully represented by the {URI} event,
924      * this function emits no events.
925      */
926     function _setURI(string memory newuri) internal virtual {
927         _uri = newuri;
928     }
929 
930     /**
931      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
932      *
933      * Emits a {TransferSingle} event.
934      *
935      * Requirements:
936      *
937      * - `to` cannot be the zero address.
938      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
939      * acceptance magic value.
940      */
941     function _mint(
942         address to,
943         uint256 id,
944         uint256 amount,
945         bytes memory data
946     ) internal virtual {
947         require(to != address(0), "ERC1155: mint to the zero address");
948 
949         address operator = _msgSender();
950         uint256[] memory ids = _asSingletonArray(id);
951         uint256[] memory amounts = _asSingletonArray(amount);
952 
953         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
954 
955         _balances[id][to] += amount;
956         emit TransferSingle(operator, address(0), to, id, amount);
957 
958         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
959 
960         _doSafeTransferAcceptanceCheck(
961             operator,
962             address(0),
963             to,
964             id,
965             amount,
966             data
967         );
968     }
969 
970     /**
971      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
972      *
973      * Requirements:
974      *
975      * - `ids` and `amounts` must have the same length.
976      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
977      * acceptance magic value.
978      */
979     function _mintBatch(
980         address to,
981         uint256[] memory ids,
982         uint256[] memory amounts,
983         bytes memory data
984     ) internal virtual {
985         require(to != address(0), "ERC1155: mint to the zero address");
986         require(
987             ids.length == amounts.length,
988             "ERC1155: ids and amounts length mismatch"
989         );
990 
991         address operator = _msgSender();
992 
993         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
994 
995         for (uint256 i = 0; i < ids.length; i++) {
996             _balances[ids[i]][to] += amounts[i];
997         }
998 
999         emit TransferBatch(operator, address(0), to, ids, amounts);
1000 
1001         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1002 
1003         _doSafeBatchTransferAcceptanceCheck(
1004             operator,
1005             address(0),
1006             to,
1007             ids,
1008             amounts,
1009             data
1010         );
1011     }
1012 
1013     /**
1014      * @dev Destroys `amount` tokens of token type `id` from `from`
1015      *
1016      * Requirements:
1017      *
1018      * - `from` cannot be the zero address.
1019      * - `from` must have at least `amount` tokens of token type `id`.
1020      */
1021     function _burn(address from, uint256 id, uint256 amount) internal virtual {
1022         require(from != address(0), "ERC1155: burn from the zero address");
1023 
1024         address operator = _msgSender();
1025         uint256[] memory ids = _asSingletonArray(id);
1026         uint256[] memory amounts = _asSingletonArray(amount);
1027 
1028         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1029 
1030         uint256 fromBalance = _balances[id][from];
1031         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1032         unchecked {
1033             _balances[id][from] = fromBalance - amount;
1034         }
1035 
1036         emit TransferSingle(operator, from, address(0), id, amount);
1037 
1038         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1039     }
1040 
1041     /**
1042      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1043      *
1044      * Requirements:
1045      *
1046      * - `ids` and `amounts` must have the same length.
1047      */
1048     function _burnBatch(
1049         address from,
1050         uint256[] memory ids,
1051         uint256[] memory amounts
1052     ) internal virtual {
1053         require(from != address(0), "ERC1155: burn from the zero address");
1054         require(
1055             ids.length == amounts.length,
1056             "ERC1155: ids and amounts length mismatch"
1057         );
1058 
1059         address operator = _msgSender();
1060 
1061         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1062 
1063         for (uint256 i = 0; i < ids.length; i++) {
1064             uint256 id = ids[i];
1065             uint256 amount = amounts[i];
1066 
1067             uint256 fromBalance = _balances[id][from];
1068             require(
1069                 fromBalance >= amount,
1070                 "ERC1155: burn amount exceeds balance"
1071             );
1072             unchecked {
1073                 _balances[id][from] = fromBalance - amount;
1074             }
1075         }
1076 
1077         emit TransferBatch(operator, from, address(0), ids, amounts);
1078 
1079         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1080     }
1081 
1082     /**
1083      * @dev Approve `operator` to operate on all of `owner` tokens
1084      *
1085      * Emits a {ApprovalForAll} event.
1086      */
1087     function _setApprovalForAll(
1088         address owner,
1089         address operator,
1090         bool approved
1091     ) internal virtual {
1092         require(owner != operator, "ERC1155: setting approval status for self");
1093         _operatorApprovals[owner][operator] = approved;
1094         emit ApprovalForAll(owner, operator, approved);
1095     }
1096 
1097     /**
1098      * @dev Hook that is called before any token transfer. This includes minting
1099      * and burning, as well as batched variants.
1100      *
1101      * The same hook is called on both single and batched variants. For single
1102      * transfers, the length of the `id` and `amount` arrays will be 1.
1103      *
1104      * Calling conditions (for each `id` and `amount` pair):
1105      *
1106      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1107      * of token type `id` will be  transferred to `to`.
1108      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1109      * for `to`.
1110      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1111      * will be burned.
1112      * - `from` and `to` are never both zero.
1113      * - `ids` and `amounts` have the same, non-zero length.
1114      *
1115      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1116      */
1117     function _beforeTokenTransfer(
1118         address operator,
1119         address from,
1120         address to,
1121         uint256[] memory ids,
1122         uint256[] memory amounts,
1123         bytes memory data
1124     ) internal virtual {}
1125 
1126     /**
1127      * @dev Hook that is called after any token transfer. This includes minting
1128      * and burning, as well as batched variants.
1129      *
1130      * The same hook is called on both single and batched variants. For single
1131      * transfers, the length of the `id` and `amount` arrays will be 1.
1132      *
1133      * Calling conditions (for each `id` and `amount` pair):
1134      *
1135      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1136      * of token type `id` will be  transferred to `to`.
1137      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1138      * for `to`.
1139      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1140      * will be burned.
1141      * - `from` and `to` are never both zero.
1142      * - `ids` and `amounts` have the same, non-zero length.
1143      *
1144      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1145      */
1146     function _afterTokenTransfer(
1147         address operator,
1148         address from,
1149         address to,
1150         uint256[] memory ids,
1151         uint256[] memory amounts,
1152         bytes memory data
1153     ) internal virtual {}
1154 
1155     function _doSafeTransferAcceptanceCheck(
1156         address operator,
1157         address from,
1158         address to,
1159         uint256 id,
1160         uint256 amount,
1161         bytes memory data
1162     ) private {
1163         if (to.isContract()) {
1164             try
1165                 IERC1155Receiver(to).onERC1155Received(
1166                     operator,
1167                     from,
1168                     id,
1169                     amount,
1170                     data
1171                 )
1172             returns (bytes4 response) {
1173                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1174                     revert("ERC1155: ERC1155Receiver rejected tokens");
1175                 }
1176             } catch Error(string memory reason) {
1177                 revert(reason);
1178             } catch {
1179                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1180             }
1181         }
1182     }
1183 
1184     function _doSafeBatchTransferAcceptanceCheck(
1185         address operator,
1186         address from,
1187         address to,
1188         uint256[] memory ids,
1189         uint256[] memory amounts,
1190         bytes memory data
1191     ) private {
1192         if (to.isContract()) {
1193             try
1194                 IERC1155Receiver(to).onERC1155BatchReceived(
1195                     operator,
1196                     from,
1197                     ids,
1198                     amounts,
1199                     data
1200                 )
1201             returns (bytes4 response) {
1202                 if (
1203                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1204                 ) {
1205                     revert("ERC1155: ERC1155Receiver rejected tokens");
1206                 }
1207             } catch Error(string memory reason) {
1208                 revert(reason);
1209             } catch {
1210                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1211             }
1212         }
1213     }
1214 
1215     function _asSingletonArray(
1216         uint256 element
1217     ) private pure returns (uint256[] memory) {
1218         uint256[] memory array = new uint256[](1);
1219         array[0] = element;
1220 
1221         return array;
1222     }
1223 }
1224 
1225 // File @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol@v4.6.0
1226 
1227 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Burnable.sol)
1228 
1229 pragma solidity ^0.8.0;
1230 
1231 /**
1232  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1233  * own tokens and those that they have been approved to use.
1234  *
1235  * _Available since v3.1._
1236  */
1237 abstract contract ERC1155Burnable is ERC1155 {
1238     function burn(address account, uint256 id, uint256 value) public virtual {
1239         require(
1240             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1241             "ERC1155: caller is not owner nor approved"
1242         );
1243 
1244         _burn(account, id, value);
1245     }
1246 
1247     function burnBatch(
1248         address account,
1249         uint256[] memory ids,
1250         uint256[] memory values
1251     ) public virtual {
1252         require(
1253             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1254             "ERC1155: caller is not owner nor approved"
1255         );
1256 
1257         _burnBatch(account, ids, values);
1258     }
1259 }
1260 
1261 // File @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol@v4.6.0
1262 
1263 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 /**
1268  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1269  *
1270  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1271  * clearly identified. Note: While a totalSupply of 1 might mean the
1272  * corresponding is an NFT, there is no guarantees that no other token with the
1273  * same id are not going to be minted.
1274  */
1275 abstract contract ERC1155Supply is ERC1155 {
1276     mapping(uint256 => uint256) private _totalSupply;
1277 
1278     /**
1279      * @dev Total amount of tokens in with a given id.
1280      */
1281     function totalSupply(uint256 id) public view virtual returns (uint256) {
1282         return _totalSupply[id];
1283     }
1284 
1285     /**
1286      * @dev Indicates whether any token exist with a given id, or not.
1287      */
1288     function exists(uint256 id) public view virtual returns (bool) {
1289         return ERC1155Supply.totalSupply(id) > 0;
1290     }
1291 
1292     /**
1293      * @dev See {ERC1155-_beforeTokenTransfer}.
1294      */
1295     function _beforeTokenTransfer(
1296         address operator,
1297         address from,
1298         address to,
1299         uint256[] memory ids,
1300         uint256[] memory amounts,
1301         bytes memory data
1302     ) internal virtual override {
1303         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1304 
1305         if (from == address(0)) {
1306             for (uint256 i = 0; i < ids.length; ++i) {
1307                 _totalSupply[ids[i]] += amounts[i];
1308             }
1309         }
1310 
1311         if (to == address(0)) {
1312             for (uint256 i = 0; i < ids.length; ++i) {
1313                 uint256 id = ids[i];
1314                 uint256 amount = amounts[i];
1315                 uint256 supply = _totalSupply[id];
1316                 require(
1317                     supply >= amount,
1318                     "ERC1155: burn amount exceeds totalSupply"
1319                 );
1320                 unchecked {
1321                     _totalSupply[id] = supply - amount;
1322                 }
1323             }
1324         }
1325     }
1326 }
1327 
1328 // File contracts/ADWKeysNoUpgrade.sol
1329 
1330 pragma solidity ^0.8.17;
1331 
1332 // import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
1333 
1334 // import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
1335 
1336 contract ADWKeys is Ownable, ERC1155Burnable, ERC1155Supply {
1337     uint256 public constant BASIC = 0;
1338     uint256 public constant DRIPPY = 1;
1339     uint256 public constant LEGENDARY = 2;
1340     uint256 public constant MYTHIC = 3;
1341 
1342     uint256 public basicPrice;
1343     uint256 public maxBasicAmount;
1344 
1345     uint256 public totalMintedBasic;
1346 
1347     bool public saleIsActive;
1348 
1349     constructor() ERC1155("") {
1350         basicPrice = 0.03 ether;
1351         maxBasicAmount = 3333;
1352         totalMintedBasic = 0;
1353         saleIsActive = false;
1354 
1355         mint(msg.sender, LEGENDARY, 10);
1356     }
1357 
1358     function setBaseMetadataURI(
1359         string memory _newBaseMetadataURI
1360     ) public onlyOwner {
1361         _setURI(_newBaseMetadataURI);
1362     }
1363 
1364     function mintBasic(uint256 amount) external payable {
1365         require(saleIsActive, "Sale not started");
1366         require(msg.value >= basicPrice * amount, "Invalid value");
1367 
1368         _mint(msg.sender, BASIC, amount, "");
1369         require(totalMintedBasic < maxBasicAmount, "Exceeds supply");
1370         // totalSupply(BASIC) will increment back after burning
1371         totalMintedBasic += amount;
1372     }
1373 
1374     function setBasicSupply(uint256 amount) external onlyOwner {
1375         maxBasicAmount = amount;
1376     }
1377 
1378     function setBasicPrice(uint256 newPrice) external onlyOwner {
1379         basicPrice = newPrice;
1380     }
1381 
1382     function flipSaleState() external onlyOwner {
1383         saleIsActive = !saleIsActive;
1384     }
1385 
1386     function mint(
1387         address account,
1388         uint256 id,
1389         uint256 amount
1390     ) public onlyOwner {
1391         _mint(account, id, amount, "");
1392     }
1393 
1394     function mintBatch(
1395         address to,
1396         uint256[] memory ids,
1397         uint256[] memory amounts
1398     ) public onlyOwner {
1399         _mintBatch(to, ids, amounts, "");
1400     }
1401 
1402     function _beforeTokenTransfer(
1403         address operator,
1404         address from,
1405         address to,
1406         uint256[] memory ids,
1407         uint256[] memory amounts,
1408         bytes memory data
1409     ) internal override(ERC1155, ERC1155Supply) {
1410         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1411     }
1412 
1413     function calculateBurnAmount(
1414         uint256 tokenId,
1415         uint256 finalItemId,
1416         uint256 wantedAmount
1417     ) internal pure returns (uint256) {
1418         return wantedAmount * 2 ** (finalItemId - tokenId);
1419     }
1420 
1421     function forge(
1422         uint256 tokenId,
1423         uint256 finalItemId,
1424         uint256 burnAmount,
1425         uint256 wantedAmount
1426     ) public {
1427         require(tokenId < finalItemId, "Invalid");
1428         require(
1429             calculateBurnAmount(tokenId, finalItemId, wantedAmount) ==
1430                 burnAmount,
1431             "Invalid"
1432         );
1433         require(balanceOf(msg.sender, tokenId) >= burnAmount, "Invalid Keys");
1434         burn(msg.sender, tokenId, burnAmount);
1435         _mint(msg.sender, finalItemId, wantedAmount, "");
1436     }
1437 
1438     function withdrawMoney() external onlyOwner {
1439         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1440         require(success, "Failed");
1441     }
1442 }