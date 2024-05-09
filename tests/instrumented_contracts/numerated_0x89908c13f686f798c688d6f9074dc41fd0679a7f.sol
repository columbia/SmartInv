1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.8.0 <0.9.0;
4 pragma abicoder v2;
5 
6 interface IAvatarsGear {
7     function applyGear(uint32 avatarId, address holder, uint32 gearID) external;
8 }
9 
10 // File: contracts/gears/IMultipassGear.sol
11 
12 interface IMultipassGear {
13     function applyGear(uint32 multipassId, address holder, uint16 gearId) external;
14     function hasApplyGear(uint32 multipassId) external view returns(bool);
15 }
16 
17 // File: @openzeppelin/contracts/utils/Context.sol
18 
19 
20 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 // File: @openzeppelin/contracts/access/Ownable.sol
45 
46 
47 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
48 
49 pragma solidity ^0.8.0;
50 
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * By default, the owner account will be the one that deploys the contract. This
58  * can later be changed with {transferOwnership}.
59  *
60  * This module is used through inheritance. It will make available the modifier
61  * `onlyOwner`, which can be applied to your functions to restrict their use to
62  * the owner.
63  */
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor() {
73         _transferOwnership(_msgSender());
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view virtual returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOwner() {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     /**
92      * @dev Leaves the contract without owner. It will not be possible to call
93      * `onlyOwner` functions anymore. Can only be called by the current owner.
94      *
95      * NOTE: Renouncing ownership will leave the contract without an owner,
96      * thereby removing any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public virtual onlyOwner {
99         _transferOwnership(address(0));
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Can only be called by the current owner.
105      */
106     function transferOwnership(address newOwner) public virtual onlyOwner {
107         require(newOwner != address(0), "Ownable: new owner is the zero address");
108         _transferOwnership(newOwner);
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Internal function without access restriction.
114      */
115     function _transferOwnership(address newOwner) internal virtual {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Address.sol
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Collection of functions related to the address type
131  */
132 library Address {
133     /**
134      * @dev Returns true if `account` is a contract.
135      *
136      * [IMPORTANT]
137      * ====
138      * It is unsafe to assume that an address for which this function returns
139      * false is an externally-owned account (EOA) and not a contract.
140      *
141      * Among others, `isContract` will return false for the following
142      * types of addresses:
143      *
144      *  - an externally-owned account
145      *  - a contract in construction
146      *  - an address where a contract will be created
147      *  - an address where a contract lived, but was destroyed
148      * ====
149      */
150     function isContract(address account) internal view returns (bool) {
151         // This method relies on extcodesize, which returns 0 for contracts in
152         // construction, since the code is only stored at the end of the
153         // constructor execution.
154 
155         uint256 size;
156         assembly {
157             size := extcodesize(account)
158         }
159         return size > 0;
160     }
161 
162     /**
163      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
164      * `recipient`, forwarding all available gas and reverting on errors.
165      *
166      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
167      * of certain opcodes, possibly making contracts go over the 2300 gas limit
168      * imposed by `transfer`, making them unable to receive funds via
169      * `transfer`. {sendValue} removes this limitation.
170      *
171      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
172      *
173      * IMPORTANT: because control is transferred to `recipient`, care must be
174      * taken to not create reentrancy vulnerabilities. Consider using
175      * {ReentrancyGuard} or the
176      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
177      */
178     function sendValue(address payable recipient, uint256 amount) internal {
179         require(address(this).balance >= amount, "Address: insufficient balance");
180 
181         (bool success, ) = recipient.call{value: amount}("");
182         require(success, "Address: unable to send value, recipient may have reverted");
183     }
184 
185     /**
186      * @dev Performs a Solidity function call using a low level `call`. A
187      * plain `call` is an unsafe replacement for a function call: use this
188      * function instead.
189      *
190      * If `target` reverts with a revert reason, it is bubbled up by this
191      * function (like regular Solidity function calls).
192      *
193      * Returns the raw returned data. To convert to the expected return value,
194      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
195      *
196      * Requirements:
197      *
198      * - `target` must be a contract.
199      * - calling `target` with `data` must not revert.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionCall(target, data, "Address: low-level call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
209      * `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, 0, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but also transferring `value` wei to `target`.
224      *
225      * Requirements:
226      *
227      * - the calling contract must have an ETH balance of at least `value`.
228      * - the called Solidity function must be `payable`.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value
236     ) internal returns (bytes memory) {
237         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
242      * with `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value,
250         string memory errorMessage
251     ) internal returns (bytes memory) {
252         require(address(this).balance >= value, "Address: insufficient balance for call");
253         require(isContract(target), "Address: call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.call{value: value}(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
266         return functionStaticCall(target, data, "Address: low-level static call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal view returns (bytes memory) {
280         require(isContract(target), "Address: static call to non-contract");
281 
282         (bool success, bytes memory returndata) = target.staticcall(data);
283         return verifyCallResult(success, returndata, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but performing a delegate call.
289      *
290      * _Available since v3.4._
291      */
292     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
298      * but performing a delegate call.
299      *
300      * _Available since v3.4._
301      */
302     function functionDelegateCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(isContract(target), "Address: delegate call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.delegatecall(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
315      * revert reason using the provided one.
316      *
317      * _Available since v4.3._
318      */
319     function verifyCallResult(
320         bool success,
321         bytes memory returndata,
322         string memory errorMessage
323     ) internal pure returns (bytes memory) {
324         if (success) {
325             return returndata;
326         } else {
327             // Look for revert reason and bubble it up if present
328             if (returndata.length > 0) {
329                 // The easiest way to bubble the revert reason is using memory via assembly
330 
331                 assembly {
332                     let returndata_size := mload(returndata)
333                     revert(add(32, returndata), returndata_size)
334                 }
335             } else {
336                 revert(errorMessage);
337             }
338         }
339     }
340 }
341 
342 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
343 
344 
345 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
346 
347 pragma solidity ^0.8.0;
348 
349 /**
350  * @dev Interface of the ERC165 standard, as defined in the
351  * https://eips.ethereum.org/EIPS/eip-165[EIP].
352  *
353  * Implementers can declare support of contract interfaces, which can then be
354  * queried by others ({ERC165Checker}).
355  *
356  * For an implementation, see {ERC165}.
357  */
358 interface IERC165 {
359     /**
360      * @dev Returns true if this contract implements the interface defined by
361      * `interfaceId`. See the corresponding
362      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
363      * to learn more about how these ids are created.
364      *
365      * This function call must use less than 30 000 gas.
366      */
367     function supportsInterface(bytes4 interfaceId) external view returns (bool);
368 }
369 
370 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
371 
372 
373 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 
378 /**
379  * @dev Implementation of the {IERC165} interface.
380  *
381  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
382  * for the additional interface id that will be supported. For example:
383  *
384  * ```solidity
385  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
386  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
387  * }
388  * ```
389  *
390  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
391  */
392 abstract contract ERC165 is IERC165 {
393     /**
394      * @dev See {IERC165-supportsInterface}.
395      */
396     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
397         return interfaceId == type(IERC165).interfaceId;
398     }
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 
409 /**
410  * @dev _Available since v3.1._
411  */
412 interface IERC1155Receiver is IERC165 {
413     /**
414         @dev Handles the receipt of a single ERC1155 token type. This function is
415         called at the end of a `safeTransferFrom` after the balance has been updated.
416         To accept the transfer, this must return
417         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
418         (i.e. 0xf23a6e61, or its own function selector).
419         @param operator The address which initiated the transfer (i.e. msg.sender)
420         @param from The address which previously owned the token
421         @param id The ID of the token being transferred
422         @param value The amount of tokens being transferred
423         @param data Additional data with no specified format
424         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
425     */
426     function onERC1155Received(
427         address operator,
428         address from,
429         uint256 id,
430         uint256 value,
431         bytes calldata data
432     ) external returns (bytes4);
433 
434     /**
435         @dev Handles the receipt of a multiple ERC1155 token types. This function
436         is called at the end of a `safeBatchTransferFrom` after the balances have
437         been updated. To accept the transfer(s), this must return
438         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
439         (i.e. 0xbc197c81, or its own function selector).
440         @param operator The address which initiated the batch transfer (i.e. msg.sender)
441         @param from The address which previously owned the token
442         @param ids An array containing ids of each token being transferred (order and length must match values array)
443         @param values An array containing amounts of each token being transferred (order and length must match ids array)
444         @param data Additional data with no specified format
445         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
446     */
447     function onERC1155BatchReceived(
448         address operator,
449         address from,
450         uint256[] calldata ids,
451         uint256[] calldata values,
452         bytes calldata data
453     ) external returns (bytes4);
454 }
455 
456 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @dev Required interface of an ERC1155 compliant contract, as defined in the
466  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
467  *
468  * _Available since v3.1._
469  */
470 interface IERC1155 is IERC165 {
471     /**
472      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
473      */
474     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
475 
476     /**
477      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
478      * transfers.
479      */
480     event TransferBatch(
481         address indexed operator,
482         address indexed from,
483         address indexed to,
484         uint256[] ids,
485         uint256[] values
486     );
487 
488     /**
489      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
490      * `approved`.
491      */
492     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
493 
494     /**
495      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
496      *
497      * If an {URI} event was emitted for `id`, the standard
498      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
499      * returned by {IERC1155MetadataURI-uri}.
500      */
501     event URI(string value, uint256 indexed id);
502 
503     /**
504      * @dev Returns the amount of tokens of token type `id` owned by `account`.
505      *
506      * Requirements:
507      *
508      * - `account` cannot be the zero address.
509      */
510     function balanceOf(address account, uint256 id) external view returns (uint256);
511 
512     /**
513      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
514      *
515      * Requirements:
516      *
517      * - `accounts` and `ids` must have the same length.
518      */
519     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
520         external
521         view
522         returns (uint256[] memory);
523 
524     /**
525      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
526      *
527      * Emits an {ApprovalForAll} event.
528      *
529      * Requirements:
530      *
531      * - `operator` cannot be the caller.
532      */
533     function setApprovalForAll(address operator, bool approved) external;
534 
535     /**
536      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
537      *
538      * See {setApprovalForAll}.
539      */
540     function isApprovedForAll(address account, address operator) external view returns (bool);
541 
542     /**
543      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
544      *
545      * Emits a {TransferSingle} event.
546      *
547      * Requirements:
548      *
549      * - `to` cannot be the zero address.
550      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
551      * - `from` must have a balance of tokens of type `id` of at least `amount`.
552      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
553      * acceptance magic value.
554      */
555     function safeTransferFrom(
556         address from,
557         address to,
558         uint256 id,
559         uint256 amount,
560         bytes calldata data
561     ) external;
562 
563     /**
564      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
565      *
566      * Emits a {TransferBatch} event.
567      *
568      * Requirements:
569      *
570      * - `ids` and `amounts` must have the same length.
571      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
572      * acceptance magic value.
573      */
574     function safeBatchTransferFrom(
575         address from,
576         address to,
577         uint256[] calldata ids,
578         uint256[] calldata amounts,
579         bytes calldata data
580     ) external;
581 }
582 
583 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
593  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
594  *
595  * _Available since v3.1._
596  */
597 interface IERC1155MetadataURI is IERC1155 {
598     /**
599      * @dev Returns the URI for token type `id`.
600      *
601      * If the `\{id\}` substring is present in the URI, it must be replaced by
602      * clients with the actual token type ID.
603      */
604     function uri(uint256 id) external view returns (string memory);
605 }
606 
607 // File: contracts/gears/ERC1155.sol
608 
609 
610 
611 pragma solidity >=0.8.0 <0.9.0;
612 
613 
614 
615 
616 
617 
618 
619 /**
620  * @dev Implementation of the basic standard multi-token.
621  * See https://eips.ethereum.org/EIPS/eip-1155
622  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
623  *
624  * _Available since v3.1._
625  */
626 /**
627  * @dev Implementation of the basic standard multi-token.
628  * See https://eips.ethereum.org/EIPS/eip-1155
629  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
630  *
631  * _Available since v3.1._
632  */
633 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
634     using Address for address;
635 
636     struct TokenInfo {
637         uint16 hasApplyingToAvatar;         // 0: no; 1:yes
638         uint16 multipassId;
639         uint32 amount;
640         uint32 mintedAtTimestamp;
641         uint32 avatarId;
642 
643         uint32 reserve1;
644         uint32 reserve2;
645         uint32 reserve3;
646         uint32 reserve4;
647     }
648 
649     // Mapping from token ID to account balances
650     mapping(uint256 => mapping(address => TokenInfo)) internal _balances;
651 
652     // Mapping from account to operator approvals
653     mapping(address => mapping(address => bool)) internal _operatorApprovals;
654 
655     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
656     string internal _uri;
657 
658     /**
659      * @dev See {_setURI}.
660      */
661     constructor(string memory uri_) {
662         _setURI(uri_);
663     }
664 
665     /**
666      * @dev See {IERC165-supportsInterface}.
667      */
668     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
669         return
670             interfaceId == type(IERC1155).interfaceId ||
671             interfaceId == type(IERC1155MetadataURI).interfaceId ||
672             super.supportsInterface(interfaceId);
673     }
674 
675     /**
676      * @dev See {IERC1155MetadataURI-uri}.
677      *
678      * This implementation returns the same URI for *all* token types. It relies
679      * on the token type ID substitution mechanism
680      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
681      *
682      * Clients calling this function must replace the `\{id\}` substring with the
683      * actual token type ID.
684      */
685     function uri(uint256) public view virtual override returns (string memory) {
686         return _uri;
687     }
688 
689     /**
690      * @dev See {IERC1155-balanceOf}.
691      *
692      * Requirements:
693      *
694      * - `account` cannot be the zero address.
695      */
696     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
697         require(account != address(0), "ERC1155: balance query for the zero address");
698         return _balances[id][account].amount;
699     }
700 
701     /**
702      * @dev See {IERC1155-balanceOfBatch}.
703      *
704      * Requirements:
705      *
706      * - `accounts` and `ids` must have the same length.
707      */
708     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
709         public
710         view
711         virtual
712         override
713         returns (uint256[] memory)
714     {
715         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
716 
717         uint256[] memory batchBalances = new uint256[](accounts.length);
718 
719         for (uint256 i = 0; i < accounts.length; ++i) {
720             batchBalances[i] = balanceOf(accounts[i], ids[i]);
721         }
722 
723         return batchBalances;
724     }
725 
726     /**
727      * @dev See {IERC1155-setApprovalForAll}.
728      */
729     function setApprovalForAll(address operator, bool approved) public virtual override {
730         require(_msgSender() != operator, "ERC1155: setting approval status for self");
731 
732         _operatorApprovals[_msgSender()][operator] = approved;
733         emit ApprovalForAll(_msgSender(), operator, approved);
734     }
735 
736     /**
737      * @dev See {IERC1155-isApprovedForAll}.
738      */
739     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
740         return _operatorApprovals[account][operator];
741     }
742 
743     /**
744      * @dev See {IERC1155-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 id,
750         uint256 amount,
751         bytes memory data
752     ) public virtual override {
753         require(
754             from == _msgSender() || isApprovedForAll(from, _msgSender()),
755             "ERC1155: caller is not owner nor approved"
756         );
757         _safeTransferFrom(from, to, id, amount, data);
758     }
759 
760     /**
761      * @dev See {IERC1155-safeBatchTransferFrom}.
762      */
763     function safeBatchTransferFrom(
764         address from,
765         address to,
766         uint256[] memory ids,
767         uint256[] memory amounts,
768         bytes memory data
769     ) public virtual override {
770         require(
771             from == _msgSender() || isApprovedForAll(from, _msgSender()),
772             "ERC1155: transfer caller is not owner nor approved"
773         );
774         _safeBatchTransferFrom(from, to, ids, amounts, data);
775     }
776 
777     /**
778      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
779      *
780      * Emits a {TransferSingle} event.
781      *
782      * Requirements:
783      *
784      * - `to` cannot be the zero address.
785      * - `from` must have a balance of tokens of type `id` of at least `amount`.
786      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
787      * acceptance magic value.
788      */
789     function _safeTransferFrom(
790         address from,
791         address to,
792         uint256 id,
793         uint256 amount,
794         bytes memory data
795     ) internal virtual {
796         require(to != address(0), "ERC1155: transfer to the zero address");
797 
798         address operator = _msgSender();
799 
800         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
801 
802         uint256 fromBalance = _balances[id][from].amount;
803         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
804         unchecked {
805             _balances[id][from].amount = uint32(fromBalance - amount);
806         }
807         _balances[id][to].amount = uint32(uint(_balances[id][to].amount) + amount);
808 
809         emit TransferSingle(operator, from, to, id, amount);
810 
811         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
812     }
813 
814     /**
815      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
816      *
817      * Emits a {TransferBatch} event.
818      *
819      * Requirements:
820      *
821      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
822      * acceptance magic value.
823      */
824     function _safeBatchTransferFrom(
825         address from,
826         address to,
827         uint256[] memory ids,
828         uint256[] memory amounts,
829         bytes memory data
830     ) internal virtual {
831         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
832         require(to != address(0), "ERC1155: transfer to the zero address");
833 
834         address operator = _msgSender();
835 
836         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
837 
838         for (uint256 i = 0; i < ids.length; ++i) {
839             uint256 id = ids[i];
840             uint256 amount = amounts[i];
841 
842             uint256 fromBalance = _balances[id][from].amount;
843             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
844             unchecked {
845                 _balances[id][from].amount = uint32(fromBalance - amount);
846             }
847             _balances[id][to].amount = uint32(uint(_balances[id][to].amount) + amount);
848         }
849 
850         emit TransferBatch(operator, from, to, ids, amounts);
851 
852         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
853     }
854 
855     /**
856      * @dev Sets a new URI for all token types, by relying on the token type ID
857      * substitution mechanism
858      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
859      *
860      * By this mechanism, any occurrence of the `\{id\}` substring in either the
861      * URI or any of the amounts in the JSON file at said URI will be replaced by
862      * clients with the token type ID.
863      *
864      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
865      * interpreted by clients as
866      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
867      * for token type ID 0x4cce0.
868      *
869      * See {uri}.
870      *
871      * Because these URIs cannot be meaningfully represented by the {URI} event,
872      * this function emits no events.
873      */
874     function _setURI(string memory newuri) internal virtual {
875         _uri = newuri;
876     }
877 
878     /**
879      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
880      *
881      * Emits a {TransferSingle} event.
882      *
883      * Requirements:
884      *
885      * - `account` cannot be the zero address.
886      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
887      * acceptance magic value.
888      */
889     function _mint(
890         address account,
891         uint256 id,
892         uint256 amount,
893         bytes memory data
894     ) internal virtual {
895         require(account != address(0), "ERC1155: mint to the zero address");
896 
897         address operator = _msgSender();
898 
899         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
900 
901         _balances[id][account].amount = uint32(uint(_balances[id][account].amount) + amount);
902         _balances[id][account].mintedAtTimestamp = uint32(block.timestamp);
903         emit TransferSingle(operator, address(0), account, id, amount);
904 
905         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
906     }
907 
908     /**
909      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
910      *
911      * Requirements:
912      *
913      * - `ids` and `amounts` must have the same length.
914      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
915      * acceptance magic value.
916      */
917     function _mintBatch(
918         address to,
919         uint256[] memory ids,
920         uint256[] memory amounts,
921         bytes memory data
922     ) internal virtual {
923         require(to != address(0), "ERC1155: mint to the zero address");
924         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
925 
926         address operator = _msgSender();
927 
928         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
929 
930         for (uint256 i = 0; i < ids.length; i++) {
931             _balances[ids[i]][to].amount = uint32(uint(_balances[ids[i]][to].amount) + amounts[i]);
932             _balances[ids[i]][to].mintedAtTimestamp = uint32(block.timestamp);
933         }
934 
935         emit TransferBatch(operator, address(0), to, ids, amounts);
936 
937         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
938     }
939 
940     /**
941      * @dev Destroys `amount` tokens of token type `id` from `account`
942      *
943      * Requirements:
944      *
945      * - `account` cannot be the zero address.
946      * - `account` must have at least `amount` tokens of token type `id`.
947      */
948     function _burn(
949         address account,
950         uint256 id,
951         uint256 amount
952     ) internal virtual {
953         require(account != address(0), "ERC1155: burn from the zero address");
954 
955         address operator = _msgSender();
956 
957         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
958 
959         uint256 accountBalance = _balances[id][account].amount;
960         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
961         unchecked {
962             _balances[id][account].amount = uint32(accountBalance - amount);
963         }
964 
965         emit TransferSingle(operator, account, address(0), id, amount);
966     }
967 
968     /**
969      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
970      *
971      * Requirements:
972      *
973      * - `ids` and `amounts` must have the same length.
974      */
975     function _burnBatch(
976         address account,
977         uint256[] memory ids,
978         uint256[] memory amounts
979     ) internal virtual {
980         require(account != address(0), "ERC1155: burn from the zero address");
981         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
982 
983         address operator = _msgSender();
984 
985         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
986 
987         for (uint256 i = 0; i < ids.length; i++) {
988             uint256 id = ids[i];
989             uint256 amount = amounts[i];
990 
991             uint256 accountBalance = _balances[id][account].amount;
992             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
993             unchecked {
994                 _balances[id][account].amount = uint32(accountBalance - amount);
995             }
996         }
997 
998         emit TransferBatch(operator, account, address(0), ids, amounts);
999     }
1000 
1001     /**
1002      * @dev Hook that is called before any token transfer. This includes minting
1003      * and burning, as well as batched variants.
1004      *
1005      * The same hook is called on both single and batched variants. For single
1006      * transfers, the length of the `id` and `amount` arrays will be 1.
1007      *
1008      * Calling conditions (for each `id` and `amount` pair):
1009      *
1010      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1011      * of token type `id` will be  transferred to `to`.
1012      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1013      * for `to`.
1014      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1015      * will be burned.
1016      * - `from` and `to` are never both zero.
1017      * - `ids` and `amounts` have the same, non-zero length.
1018      *
1019      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1020      */
1021     function _beforeTokenTransfer(
1022         address operator,
1023         address from,
1024         address to,
1025         uint256[] memory ids,
1026         uint256[] memory amounts,
1027         bytes memory data
1028     ) internal virtual {}
1029 
1030     function _doSafeTransferAcceptanceCheck(
1031         address operator,
1032         address from,
1033         address to,
1034         uint256 id,
1035         uint256 amount,
1036         bytes memory data
1037     ) private {
1038         if (to.isContract()) {
1039             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1040                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1041                     revert("ERC1155: ERC1155Receiver rejected tokens");
1042                 }
1043             } catch Error(string memory reason) {
1044                 revert(reason);
1045             } catch {
1046                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1047             }
1048         }
1049     }
1050 
1051     function _doSafeBatchTransferAcceptanceCheck(
1052         address operator,
1053         address from,
1054         address to,
1055         uint256[] memory ids,
1056         uint256[] memory amounts,
1057         bytes memory data
1058     ) private {
1059         if (to.isContract()) {
1060             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1061                 bytes4 response
1062             ) {
1063                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1064                     revert("ERC1155: ERC1155Receiver rejected tokens");
1065                 }
1066             } catch Error(string memory reason) {
1067                 revert(reason);
1068             } catch {
1069                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1070             }
1071         }
1072     }
1073 
1074     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1075         uint256[] memory array = new uint256[](1);
1076         array[0] = element;
1077 
1078         return array;
1079     }
1080 }
1081 
1082 // File: contracts/gears/Gears.sol
1083 
1084 
1085 
1086 pragma solidity >=0.8.0 < 0.9.0;
1087 pragma experimental ABIEncoderV2;
1088 
1089 
1090 
1091 
1092 
1093 struct AvatarInfo {
1094     uint8  level;
1095     uint8  reverse1;
1096     uint16 reverse2;
1097     uint32 amount;
1098     uint32 gearID;
1099     uint32 mintedAtTimestamp;
1100     uint32 cityID;
1101     uint32 personalID;
1102     uint32 randReceipt;
1103     uint32 reverse4;    
1104 }
1105 
1106 contract Gears is ERC1155, Ownable {
1107     struct NftToken {
1108       uint16 mintingStatus;     // set can be mint or not
1109       uint16 currentMinted;
1110       uint16 totalSupply;
1111       uint16 maxSupply;
1112       uint16 maxMintingPerTime;
1113       uint16 reserve1;
1114       
1115       uint32 nftCost;           // unit is finney (0.001 ETH)
1116       uint32 reserve2;
1117       uint32 reserve3;    
1118       uint64 reserve4; 
1119     }
1120 
1121     NftToken public nftToken;
1122     address public immutable multipassAddress;
1123     address public immutable avatarAddress;
1124     mapping(address => bool) private defaultApprovals;
1125 
1126     event WithdrawEth(address indexed _operator, uint256 _ethWei);
1127     event SetMaxMintingPerTime(uint maxMintingPerTime);
1128     event MintGear(uint indexed gearId, uint indexed multipassId, address holder, address operator, uint timestamp);
1129     event DefaultApproval(address indexed operator, bool hasApproval);
1130     event ApplyGear(uint indexed gearId, address holder, uint newAvatarId);
1131     
1132     constructor(address _multipass, address _avatarAddress) 
1133       ERC1155("https://cloudflare-ipfs.com/ipns/k2k4r8p3fpywxp1hjfve019hirc4s6m7qc2f3ypiecg7ekx2u8pfik97/{id}")
1134     {
1135         nftToken.maxSupply = 10000;
1136         nftToken.totalSupply = 5000;
1137         nftToken.nftCost = 0;
1138         nftToken.maxMintingPerTime = 255;
1139         nftToken.mintingStatus = 1;
1140         nftToken.currentMinted = 1;         // ID from 1
1141         multipassAddress = _multipass;
1142         avatarAddress = _avatarAddress;
1143         setDefaultApproval(_avatarAddress, true);
1144     }
1145 
1146     function name() public pure returns (string memory)
1147     {
1148         return "Awakened-Gear";
1149     }
1150 
1151     function symbol() public pure returns (string memory)
1152     {
1153         return "Gears";
1154     }
1155 
1156     function decimals() public view virtual  returns (uint256) 
1157     {  
1158         return 0;
1159     }
1160 
1161     function totalSupply() public view returns (uint)
1162     {
1163         return nftToken.currentMinted - 1;
1164     }
1165 
1166     function maxSupply() public view returns (uint)
1167     {
1168         return nftToken.maxSupply;
1169     }
1170 
1171     function nftCost() public view returns(uint)
1172     {
1173         return nftToken.nftCost;
1174     }
1175 
1176     function mintingStatus() public view returns(uint)
1177     {
1178         return nftToken.mintingStatus;
1179     }
1180 
1181     function maxMintingPerTime() public view returns(uint)
1182     {
1183         return nftToken.maxMintingPerTime;
1184     }
1185 
1186     receive() external virtual payable { } 
1187     fallback() external virtual payable { }
1188     
1189     /* withdraw eth from owner */
1190     function withdraw(uint _amount) public onlyOwner
1191     {
1192         require(_amount <= address(this).balance, "exceed withdraw balance.");
1193         if (_amount == 0)
1194         {
1195             _amount = address(this).balance;
1196         }
1197         uint _devFee = _amount * 5 / 100;
1198         payable(0x2130C75caC9E1EF6381C6F354331B3049221391C).transfer(_devFee);
1199         payable(_msgSender()).transfer(_amount - _devFee);
1200 
1201         emit WithdrawEth(_msgSender(), _amount);
1202     }
1203 
1204     modifier canMint(uint16 _number)
1205     {
1206         require(nftToken.currentMinted + _number <= nftToken.totalSupply + 1, "Exceed the max supply!");
1207         require(nftToken.mintingStatus > 0, "Minting already stop now!");
1208         require(_number <= nftToken.maxMintingPerTime, "exceed the max minting limit per time");
1209         _;
1210     }
1211 
1212     /* check token exist or not */
1213     function existsToken(address _addr, uint _id) public view returns(bool)
1214     {
1215         return _balances[_id][_addr].amount > 0;
1216     }
1217 
1218     function isApprovedForAll(address _owner, address _operator) public virtual override(ERC1155) view returns (bool) {
1219         return defaultApprovals[_operator] || super.isApprovedForAll(_owner, _operator);
1220     }
1221 
1222     function setDefaultApproval(address operator, bool hasApproval) public onlyOwner {
1223         defaultApprovals[operator] = hasApproval;
1224         emit DefaultApproval(operator, hasApproval);
1225     }
1226 
1227     /* Allow the owner set how max minting per time */
1228     function setMaxMintingPerTime(uint16 _maxMintingPerTime) public onlyOwner
1229     {
1230       nftToken.maxMintingPerTime = _maxMintingPerTime;
1231       emit SetMaxMintingPerTime(_maxMintingPerTime);
1232     }
1233 
1234     // when _howManyMEth = 1, it's 0.001 ETH
1235     function setNftCost(uint32 _howManyFinney) external onlyOwner
1236     {
1237         nftToken.nftCost = _howManyFinney;
1238     }
1239 
1240     /* set Token URI */
1241     function setTokenURI(string calldata _uri, uint256 _id) external onlyOwner {
1242         emit URI(_uri, _id);
1243     }
1244 
1245     /* set status can be mint or not */
1246     function setMintingStatus(uint16 _status) public onlyOwner
1247     {
1248         nftToken.mintingStatus = _status;
1249     }
1250 
1251     /* can set total supply, but it can't never be exceed max supply */
1252     function setTotalSupply(uint16 _supply) external onlyOwner
1253     {
1254         require(_supply <= nftToken.maxSupply, "exceed max supply");
1255         nftToken.totalSupply = _supply;
1256     }
1257 
1258     function setUri(string memory newuri) external onlyOwner
1259     {
1260         _setURI(newuri);
1261     }
1262 
1263     function mint(uint16[] memory multipassIds) external canMint(uint16(multipassIds.length))
1264     {
1265         uint number = uint16(multipassIds.length);
1266         address holder = _msgSender();
1267         
1268         uint16 _currentMintedID = nftToken.currentMinted;
1269         for (uint16 i = 0; i < number; i++)
1270         {
1271             if (!IMultipassGear(multipassAddress).hasApplyGear(multipassIds[i]))
1272             {
1273                 IMultipassGear(multipassAddress).applyGear(multipassIds[i], holder, _currentMintedID);
1274                 _balances[_currentMintedID][holder].amount += 1;
1275                 _balances[_currentMintedID][holder].multipassId = multipassIds[i];
1276                 _balances[_currentMintedID][holder].mintedAtTimestamp = uint32(block.timestamp);
1277 
1278                 emit TransferSingle(_msgSender(), address(0), holder, _currentMintedID, 1);
1279                 emit MintGear(_currentMintedID, multipassIds[i], holder, holder, block.timestamp);
1280 
1281                 _currentMintedID += 1;
1282             }
1283         }
1284         nftToken.currentMinted = _currentMintedID;
1285     }
1286 
1287     function applyingToAvatar(uint16[] memory gearIds, uint16[] memory avatarIds) external
1288     {
1289         address holder = _msgSender();
1290         require(gearIds.length == avatarIds.length, "Must the same length between avatars and gears.");
1291         for (uint i = 0; i < gearIds.length; i++)
1292         {
1293             require(existsToken(holder, gearIds[i]), "Holder:did not own this token");
1294             IAvatarsGear(avatarAddress).applyGear(avatarIds[i], holder, uint32(gearIds[i]));
1295             _balances[gearIds[i]][holder].amount = 0;
1296             emit ApplyGear(gearIds[i], holder, avatarIds[i]);
1297             emit TransferSingle(holder, holder, address(0), gearIds[i], 1);
1298         }
1299     }
1300 
1301     function mintAndApply(uint16[] memory multipassIds, uint16[] memory avatarIds) external
1302     {
1303         require(avatarIds.length == multipassIds.length, "Must the same length between multipass and avatars.");
1304         uint number = uint16(multipassIds.length);
1305         address holder = _msgSender();
1306         uint16 _currentMintedID = nftToken.currentMinted;
1307 
1308         for (uint16 i = 0; i < number; i++)
1309         {
1310             if (!IMultipassGear(multipassAddress).hasApplyGear(multipassIds[i]))
1311             {
1312                 IMultipassGear(multipassAddress).applyGear(multipassIds[i], holder, _currentMintedID);
1313                 _balances[_currentMintedID][holder].multipassId = multipassIds[i];
1314                 _balances[_currentMintedID][holder].mintedAtTimestamp = uint32(block.timestamp);
1315 
1316                 IAvatarsGear(avatarAddress).applyGear(avatarIds[i], holder, _currentMintedID);
1317 
1318                 emit ApplyGear(_currentMintedID, holder, avatarIds[i]);
1319                 emit TransferSingle(holder, holder, address(0), _currentMintedID, 1);
1320 
1321                 _currentMintedID += 1;
1322             }
1323         }
1324         nftToken.currentMinted = _currentMintedID;
1325     }
1326 
1327     function batchMint(address[] memory _addrs) external onlyOwner
1328     {        
1329         require(nftToken.currentMinted + uint16(_addrs.length) <= nftToken.totalSupply + 1, "Exceed the max supply!");
1330 
1331         uint8 number = uint8(_addrs.length);
1332         uint16 _currentMintedID = nftToken.currentMinted;
1333 
1334         for (uint8 i = 0; i < number; i++)
1335         {
1336             _balances[_currentMintedID][_addrs[i]].amount += 1;
1337             _balances[_currentMintedID][_addrs[i]].mintedAtTimestamp = uint32(block.timestamp);
1338             _balances[_currentMintedID][_addrs[i]].multipassId = 65535;
1339 
1340             emit TransferSingle(_msgSender(), address(0), _addrs[i], _currentMintedID, 1);
1341             emit MintGear(_currentMintedID, 65535, _addrs[i], _msgSender(), block.timestamp);
1342 
1343             _currentMintedID++;
1344         }
1345         nftToken.currentMinted = _currentMintedID;
1346     }
1347 }