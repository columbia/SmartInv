1 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
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
28 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
29 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 ////import "./IERC165.sol";
34 
35 /**
36  * @dev Implementation of the {IERC165} interface.
37  *
38  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
39  * for the additional interface id that will be supported. For example:
40  *
41  * ```solidity
42  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
43  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
44  * }
45  * ```
46  *
47  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
48  */
49 abstract contract ERC165 is IERC165 {
50     /**
51      * @dev See {IERC165-supportsInterface}.
52      */
53     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
54         return interfaceId == type(IERC165).interfaceId;
55     }
56 }
57 
58 
59 
60 
61             
62 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
63 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 ////import "../../utils/introspection/IERC165.sol";
68 
69 /**
70  * @dev _Available since v3.1._
71  */
72 interface IERC1155Receiver is IERC165 {
73     /**
74      * @dev Handles the receipt of a single ERC1155 token type. This function is
75      * called at the end of a `safeTransferFrom` after the balance has been updated.
76      *
77      * NOTE: To accept the transfer, this must return
78      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
79      * (i.e. 0xf23a6e61, or its own function selector).
80      *
81      * @param operator The address which initiated the transfer (i.e. msg.sender)
82      * @param from The address which previously owned the token
83      * @param id The ID of the token being transferred
84      * @param value The amount of tokens being transferred
85      * @param data Additional data with no specified format
86      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
87      */
88     function onERC1155Received(
89         address operator,
90         address from,
91         uint256 id,
92         uint256 value,
93         bytes calldata data
94     ) external returns (bytes4);
95 
96     /**
97      * @dev Handles the receipt of a multiple ERC1155 token types. This function
98      * is called at the end of a `safeBatchTransferFrom` after the balances have
99      * been updated.
100      *
101      * NOTE: To accept the transfer(s), this must return
102      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
103      * (i.e. 0xbc197c81, or its own function selector).
104      *
105      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
106      * @param from The address which previously owned the token
107      * @param ids An array containing ids of each token being transferred (order and length must match values array)
108      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
109      * @param data Additional data with no specified format
110      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
111      */
112     function onERC1155BatchReceived(
113         address operator,
114         address from,
115         uint256[] calldata ids,
116         uint256[] calldata values,
117         bytes calldata data
118     ) external returns (bytes4);
119 }
120 
121 
122 
123     
124 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
125 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 ////import "../IERC1155Receiver.sol";
130 ////import "../../../utils/introspection/ERC165.sol";
131 
132 /**
133  * @dev _Available since v3.1._
134  */
135 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
136     /**
137      * @dev See {IERC165-supportsInterface}.
138      */
139     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
140         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
141     }
142 }
143 
144 
145 
146             
147 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
148 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @title ERC721 token receiver interface
154  * @dev Interface for any contract that wants to support safeTransfers
155  * from ERC721 asset contracts.
156  */
157 interface IERC721Receiver {
158     /**
159      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
160      * by `operator` from `from`, this function is called.
161      *
162      * It must return its Solidity selector to confirm the token transfer.
163      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
164      *
165      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
166      */
167     function onERC721Received(
168         address operator,
169         address from,
170         uint256 tokenId,
171         bytes calldata data
172     ) external returns (bytes4);
173 }
174 
175 
176 
177             
178 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
179 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
180 
181 pragma solidity ^0.8.1;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [////IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      *
204      * [IMPORTANT]
205      * ====
206      * You shouldn't rely on `isContract` to protect against flash loan attacks!
207      *
208      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
209      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
210      * constructor.
211      * ====
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies on extcodesize/address.code.length, which returns 0
215         // for contracts in construction, since the code is only stored at the end
216         // of the constructor execution.
217 
218         return account.code.length > 0;
219     }
220 
221     /**
222      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
223      * `recipient`, forwarding all available gas and reverting on errors.
224      *
225      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
226      * of certain opcodes, possibly making contracts go over the 2300 gas limit
227      * imposed by `transfer`, making them unable to receive funds via
228      * `transfer`. {sendValue} removes this limitation.
229      *
230      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
231      *
232      * ////IMPORTANT: because control is transferred to `recipient`, care must be
233      * taken to not create reentrancy vulnerabilities. Consider using
234      * {ReentrancyGuard} or the
235      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
236      */
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     /**
245      * @dev Performs a Solidity function call using a low level `call`. A
246      * plain `call` is an unsafe replacement for a function call: use this
247      * function instead.
248      *
249      * If `target` reverts with a revert reason, it is bubbled up by this
250      * function (like regular Solidity function calls).
251      *
252      * Returns the raw returned data. To convert to the expected return value,
253      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
254      *
255      * Requirements:
256      *
257      * - `target` must be a contract.
258      * - calling `target` with `data` must not revert.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionCall(target, data, "Address: low-level call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
268      * `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
301      * with `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(address(this).balance >= value, "Address: insufficient balance for call");
312         require(isContract(target), "Address: call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.call{value: value}(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
325         return functionStaticCall(target, data, "Address: low-level static call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(isContract(target), "Address: delegate call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.delegatecall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
374      * revert reason using the provided one.
375      *
376      * _Available since v4.3._
377      */
378     function verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 
402 
403 
404 
405             
406 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
407 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @dev Interface of the ERC20 standard as defined in the EIP.
413  */
414 interface IERC20 {
415     /**
416      * @dev Emitted when `value` tokens are moved from one account (`from`) to
417      * another (`to`).
418      *
419      * Note that `value` may be zero.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 value);
422 
423     /**
424      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
425      * a call to {approve}. `value` is the new allowance.
426      */
427     event Approval(address indexed owner, address indexed spender, uint256 value);
428 
429     /**
430      * @dev Returns the amount of tokens in existence.
431      */
432     function totalSupply() external view returns (uint256);
433 
434     /**
435      * @dev Returns the amount of tokens owned by `account`.
436      */
437     function balanceOf(address account) external view returns (uint256);
438 
439     /**
440      * @dev Moves `amount` tokens from the caller's account to `to`.
441      *
442      * Returns a boolean value indicating whether the operation succeeded.
443      *
444      * Emits a {Transfer} event.
445      */
446     function transfer(address to, uint256 amount) external returns (bool);
447 
448     /**
449      * @dev Returns the remaining number of tokens that `spender` will be
450      * allowed to spend on behalf of `owner` through {transferFrom}. This is
451      * zero by default.
452      *
453      * This value changes when {approve} or {transferFrom} are called.
454      */
455     function allowance(address owner, address spender) external view returns (uint256);
456 
457     /**
458      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
459      *
460      * Returns a boolean value indicating whether the operation succeeded.
461      *
462      * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
463      * that someone may use both the old and the new allowance by unfortunate
464      * transaction ordering. One possible solution to mitigate this race
465      * condition is to first reduce the spender's allowance to 0 and set the
466      * desired value afterwards:
467      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
468      *
469      * Emits an {Approval} event.
470      */
471     function approve(address spender, uint256 amount) external returns (bool);
472 
473     /**
474      * @dev Moves `amount` tokens from `from` to `to` using the
475      * allowance mechanism. `amount` is then deducted from the caller's
476      * allowance.
477      *
478      * Returns a boolean value indicating whether the operation succeeded.
479      *
480      * Emits a {Transfer} event.
481      */
482     function transferFrom(
483         address from,
484         address to,
485         uint256 amount
486     ) external returns (bool);
487 }
488 
489 
490 
491 
492             
493 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
494 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev Provides information about the current execution context, including the
500  * sender of the transaction and its data. While these are generally available
501  * via msg.sender and msg.data, they should not be accessed in such a direct
502  * manner, since when dealing with meta-transactions the account sending and
503  * paying for execution may not be the actual sender (as far as an application
504  * is concerned).
505  *
506  * This contract is only required for intermediate, library-like contracts.
507  */
508 abstract contract Context {
509     function _msgSender() internal view virtual returns (address) {
510         return msg.sender;
511     }
512 
513     function _msgData() internal view virtual returns (bytes calldata) {
514         return msg.data;
515     }
516 }
517 
518 
519             
520 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
521 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/utils/ERC1155Holder.sol)
522 
523 pragma solidity ^0.8.0;
524 
525 ////import "./ERC1155Receiver.sol";
526 
527 /**
528  * Simple implementation of `ERC1155Receiver` that will allow a contract to hold ERC1155 tokens.
529  *
530  * ////IMPORTANT: When inheriting this contract, you must include a way to use the received tokens, otherwise they will be
531  * stuck.
532  *
533  * @dev _Available since v3.1._
534  */
535 contract ERC1155Holder is ERC1155Receiver {
536     function onERC1155Received(
537         address,
538         address,
539         uint256,
540         uint256,
541         bytes memory
542     ) public virtual override returns (bytes4) {
543         return this.onERC1155Received.selector;
544     }
545 
546     function onERC1155BatchReceived(
547         address,
548         address,
549         uint256[] memory,
550         uint256[] memory,
551         bytes memory
552     ) public virtual override returns (bytes4) {
553         return this.onERC1155BatchReceived.selector;
554     }
555 }
556 
557 
558 
559 
560 
561             
562 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
563 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 ////import "../IERC721Receiver.sol";
568 
569 /**
570  * @dev Implementation of the {IERC721Receiver} interface.
571  *
572  * Accepts all token transfers.
573  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
574  */
575 contract ERC721Holder is IERC721Receiver {
576     /**
577      * @dev See {IERC721Receiver-onERC721Received}.
578      *
579      * Always returns `IERC721Receiver.onERC721Received.selector`.
580      */
581     function onERC721Received(
582         address,
583         address,
584         uint256,
585         bytes memory
586     ) public virtual override returns (bytes4) {
587         return this.onERC721Received.selector;
588     }
589 }
590 
591 
592 
593 
594 
595             
596 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
597 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 ////import "../../utils/introspection/IERC165.sol";
602 
603 /**
604  * @dev Required interface of an ERC1155 compliant contract, as defined in the
605  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
606  *
607  * _Available since v3.1._
608  */
609 interface IERC1155 is IERC165 {
610     /**
611      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
612      */
613     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
614 
615     /**
616      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
617      * transfers.
618      */
619     event TransferBatch(
620         address indexed operator,
621         address indexed from,
622         address indexed to,
623         uint256[] ids,
624         uint256[] values
625     );
626 
627     /**
628      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
629      * `approved`.
630      */
631     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
632 
633     /**
634      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
635      *
636      * If an {URI} event was emitted for `id`, the standard
637      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
638      * returned by {IERC1155MetadataURI-uri}.
639      */
640     event URI(string value, uint256 indexed id);
641 
642     /**
643      * @dev Returns the amount of tokens of token type `id` owned by `account`.
644      *
645      * Requirements:
646      *
647      * - `account` cannot be the zero address.
648      */
649     function balanceOf(address account, uint256 id) external view returns (uint256);
650 
651     /**
652      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
653      *
654      * Requirements:
655      *
656      * - `accounts` and `ids` must have the same length.
657      */
658     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
659         external
660         view
661         returns (uint256[] memory);
662 
663     /**
664      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
665      *
666      * Emits an {ApprovalForAll} event.
667      *
668      * Requirements:
669      *
670      * - `operator` cannot be the caller.
671      */
672     function setApprovalForAll(address operator, bool approved) external;
673 
674     /**
675      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
676      *
677      * See {setApprovalForAll}.
678      */
679     function isApprovedForAll(address account, address operator) external view returns (bool);
680 
681     /**
682      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
683      *
684      * Emits a {TransferSingle} event.
685      *
686      * Requirements:
687      *
688      * - `to` cannot be the zero address.
689      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
690      * - `from` must have a balance of tokens of type `id` of at least `amount`.
691      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
692      * acceptance magic value.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 id,
698         uint256 amount,
699         bytes calldata data
700     ) external;
701 
702     /**
703      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
704      *
705      * Emits a {TransferBatch} event.
706      *
707      * Requirements:
708      *
709      * - `ids` and `amounts` must have the same length.
710      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
711      * acceptance magic value.
712      */
713     function safeBatchTransferFrom(
714         address from,
715         address to,
716         uint256[] calldata ids,
717         uint256[] calldata amounts,
718         bytes calldata data
719     ) external;
720 }
721 
722 
723 
724 
725             
726 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
727 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 ////import "../../utils/introspection/IERC165.sol";
732 
733 /**
734  * @dev Required interface of an ERC721 compliant contract.
735  */
736 interface IERC721 is IERC165 {
737     /**
738      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
739      */
740     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
741 
742     /**
743      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
744      */
745     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
746 
747     /**
748      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
749      */
750     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
751 
752     /**
753      * @dev Returns the number of tokens in ``owner``'s account.
754      */
755     function balanceOf(address owner) external view returns (uint256 balance);
756 
757     /**
758      * @dev Returns the owner of the `tokenId` token.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function ownerOf(uint256 tokenId) external view returns (address owner);
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes calldata data
784     ) external;
785 
786     /**
787      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
788      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must exist and be owned by `from`.
795      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external;
805 
806     /**
807      * @dev Transfers `tokenId` token from `from` to `to`.
808      *
809      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must be owned by `from`.
816      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
817      *
818      * Emits a {Transfer} event.
819      */
820     function transferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) external;
825 
826     /**
827      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
828      * The approval is cleared when the token is transferred.
829      *
830      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
831      *
832      * Requirements:
833      *
834      * - The caller must own the token or be an approved operator.
835      * - `tokenId` must exist.
836      *
837      * Emits an {Approval} event.
838      */
839     function approve(address to, uint256 tokenId) external;
840 
841     /**
842      * @dev Approve or remove `operator` as an operator for the caller.
843      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
844      *
845      * Requirements:
846      *
847      * - The `operator` cannot be the caller.
848      *
849      * Emits an {ApprovalForAll} event.
850      */
851     function setApprovalForAll(address operator, bool _approved) external;
852 
853     /**
854      * @dev Returns the account approved for `tokenId` token.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must exist.
859      */
860     function getApproved(uint256 tokenId) external view returns (address operator);
861 
862     /**
863      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
864      *
865      * See {setApprovalForAll}
866      */
867     function isApprovedForAll(address owner, address operator) external view returns (bool);
868 }
869 
870 
871 
872 
873             
874 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
875 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
876 
877 pragma solidity ^0.8.0;
878 
879 ////import "../IERC20.sol";
880 ////import "../../../utils/Address.sol";
881 
882 /**
883  * @title SafeERC20
884  * @dev Wrappers around ERC20 operations that throw on failure (when the token
885  * contract returns false). Tokens that return no value (and instead revert or
886  * throw on failure) are also supported, non-reverting calls are assumed to be
887  * successful.
888  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
889  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
890  */
891 library SafeERC20 {
892     using Address for address;
893 
894     function safeTransfer(
895         IERC20 token,
896         address to,
897         uint256 value
898     ) internal {
899         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
900     }
901 
902     function safeTransferFrom(
903         IERC20 token,
904         address from,
905         address to,
906         uint256 value
907     ) internal {
908         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
909     }
910 
911     /**
912      * @dev Deprecated. This function has issues similar to the ones found in
913      * {IERC20-approve}, and its usage is discouraged.
914      *
915      * Whenever possible, use {safeIncreaseAllowance} and
916      * {safeDecreaseAllowance} instead.
917      */
918     function safeApprove(
919         IERC20 token,
920         address spender,
921         uint256 value
922     ) internal {
923         // safeApprove should only be called when setting an initial allowance,
924         // or when resetting it to zero. To increase and decrease it, use
925         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
926         require(
927             (value == 0) || (token.allowance(address(this), spender) == 0),
928             "SafeERC20: approve from non-zero to non-zero allowance"
929         );
930         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
931     }
932 
933     function safeIncreaseAllowance(
934         IERC20 token,
935         address spender,
936         uint256 value
937     ) internal {
938         uint256 newAllowance = token.allowance(address(this), spender) + value;
939         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
940     }
941 
942     function safeDecreaseAllowance(
943         IERC20 token,
944         address spender,
945         uint256 value
946     ) internal {
947         unchecked {
948             uint256 oldAllowance = token.allowance(address(this), spender);
949             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
950             uint256 newAllowance = oldAllowance - value;
951             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
952         }
953     }
954 
955     /**
956      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
957      * on the return value: the return value is optional (but if data is returned, it must not be false).
958      * @param token The token targeted by the call.
959      * @param data The call data (encoded using abi.encode or one of its variants).
960      */
961     function _callOptionalReturn(IERC20 token, bytes memory data) private {
962         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
963         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
964         // the target address contains contract code and also asserts for success in the low-level call.
965 
966         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
967         if (returndata.length > 0) {
968             // Return data is optional
969             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
970         }
971     }
972 }
973 
974 
975 
976 
977             
978 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
979 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
980 
981 pragma solidity ^0.8.0;
982 
983 ////import "../utils/Context.sol";
984 
985 /**
986  * @dev Contract module which provides a basic access control mechanism, where
987  * there is an account (an owner) that can be granted exclusive access to
988  * specific functions.
989  *
990  * By default, the owner account will be the one that deploys the contract. This
991  * can later be changed with {transferOwnership}.
992  *
993  * This module is used through inheritance. It will make available the modifier
994  * `onlyOwner`, which can be applied to your functions to restrict their use to
995  * the owner.
996  */
997 abstract contract Ownable is Context {
998     address private _owner;
999 
1000     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1001 
1002     /**
1003      * @dev Initializes the contract setting the deployer as the initial owner.
1004      */
1005     constructor() {
1006         _transferOwnership(_msgSender());
1007     }
1008 
1009     /**
1010      * @dev Returns the address of the current owner.
1011      */
1012     function owner() public view virtual returns (address) {
1013         return _owner;
1014     }
1015 
1016     /**
1017      * @dev Throws if called by any account other than the owner.
1018      */
1019     modifier onlyOwner() {
1020         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1021         _;
1022     }
1023 
1024     /**
1025      * @dev Leaves the contract without owner. It will not be possible to call
1026      * `onlyOwner` functions anymore. Can only be called by the current owner.
1027      *
1028      * NOTE: Renouncing ownership will leave the contract without an owner,
1029      * thereby removing any functionality that is only available to the owner.
1030      */
1031     function renounceOwnership() public virtual onlyOwner {
1032         _transferOwnership(address(0));
1033     }
1034 
1035     /**
1036      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1037      * Can only be called by the current owner.
1038      */
1039     function transferOwnership(address newOwner) public virtual onlyOwner {
1040         require(newOwner != address(0), "Ownable: new owner is the zero address");
1041         _transferOwnership(newOwner);
1042     }
1043 
1044     /**
1045      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1046      * Internal function without access restriction.
1047      */
1048     function _transferOwnership(address newOwner) internal virtual {
1049         address oldOwner = _owner;
1050         _owner = newOwner;
1051         emit OwnershipTransferred(oldOwner, newOwner);
1052     }
1053 }
1054 
1055 
1056 
1057 
1058             
1059 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1060 pragma solidity ^0.8.9;
1061 
1062 interface IFractonTokenFactory {
1063   function getowner() external view returns (address);
1064 
1065   function getDAOAddress() external view returns (address);
1066 
1067   function getVaultAddress() external view returns (address);
1068 
1069   function getSwapAddress() external view returns (address);
1070 
1071   function getPoolFundingVaultAddress() external view returns (address);
1072 
1073   function updateDao(address daoAddress) external returns (bool);
1074 
1075   function updateVault(address pendingVault_) external returns (bool);
1076 
1077   function updatePFVault(address pendingPFVault_) external returns (bool);
1078 }
1079 
1080 
1081 
1082 
1083 
1084             
1085 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1086 pragma solidity ^0.8.9;
1087 
1088 interface IFractonSwap {
1089   event UpdatePoolRelation(
1090     address editor,
1091     address miniNFT,
1092     address FFT,
1093     address NFT
1094   );
1095 
1096   event PoolClaim(address owner, address miniNFTcontract, uint256 tokenID);
1097 
1098   event SwapMiniNFTtoFFT(
1099     address owner,
1100     address miniNFTcontract,
1101     uint256 tokenID,
1102     uint256 miniNFTAmount
1103   );
1104 
1105   event SwapFFTtoMiniNFT(
1106     address owner,
1107     address miniNFTcontract,
1108     uint256 miniNFTAmount
1109   );
1110 
1111   event SendChainlinkVRF(
1112     uint256 requestId,
1113     address sender,
1114     address NFTContract
1115   );
1116 
1117   event SwapMiniNFTtoNFT(address owner, address NFTContract, uint256 NFTID);
1118 
1119   event UpdateFactory(address factory);
1120 
1121   event UpdateTax(uint256 fftTax, uint256 nftTax);
1122 
1123   struct ChainLinkRequest {
1124     address sender;
1125     address nft;
1126   }
1127 
1128   function updatePoolRelation(
1129     address miniNFT,
1130     address FFT,
1131     address NFT
1132   ) external returns (bool);
1133 
1134   function poolClaim(address miniNFTcontract, uint256 tokenID)
1135     external
1136     returns (bool);
1137 
1138   function swapMiniNFTtoFFT(
1139     address miniNFTcontract,
1140     uint256 tokenID,
1141     uint256 amount
1142   ) external returns (bool);
1143 
1144   function swapFFTtoMiniNFT(address miniNFTcontract, uint256 miniNFTamount)
1145     external
1146     returns (bool);
1147 
1148   function swapMiniNFTtoNFT(address NFTContract) external returns (bool);
1149 
1150   function swapNFTtoMiniNFT(
1151     address NFTContract,
1152     address fromOwner,
1153     uint256 tokenId
1154   ) external returns (bool);
1155 
1156   function updateCallbackGasLimit(uint32 gasLimit_) external returns (bool);
1157 
1158   function updateVrfSubscriptionId(uint64 subscriptionId_)
1159     external
1160     returns (bool);
1161 
1162   function withdrawERC20(address project, uint256 amount) external returns (bool);
1163   function withdrawERC721(address airdropContract, uint256 tokenId) external returns (bool);
1164   function withdrawERC1155(
1165     address airdropContract,
1166     uint256 tokenId,
1167     uint256 amount
1168   ) external returns (bool);
1169   function updateTax(uint256 fftTax_, uint256 nftTax_) external returns (bool);
1170 }
1171 
1172 
1173 
1174 
1175             
1176 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1177 pragma solidity ^0.8.9;
1178 
1179 interface IFractonMiniNFT {
1180   event StartNewRound(uint256 blockNumber, uint256 sellingPrice);
1181 
1182   event CloseRound(uint256 blockNumber);
1183 
1184   event ClaimBlindBox(address owner, uint256 tokenID, uint256 amount);
1185 
1186   event WithdrawEther(address caller, uint256 amount);
1187 
1188   event UpdateRoundSucceed(uint256 round, uint256 blockNumber);
1189 
1190   event UpdateBlindBoxPrice(uint256 price);
1191 
1192   function startNewRound(uint256 sellingPrice) external returns (bool);
1193 
1194   function closeRound() external returns (bool);
1195 
1196   function mintBlindBox(uint256 amount) external payable returns (uint256);
1197 
1198   function claimBlindBox(uint256 tokenID) external returns (uint256);
1199 
1200   function withdrawEther() external returns (bool);
1201 
1202   function updateRoundSucceed(uint256 round) external returns (bool);
1203 
1204   function updateBlindBoxPrice(uint256 BBoxPrice) external returns (bool);
1205 
1206   function totalSupply(uint256 id) external view returns (uint256);
1207 
1208   function burn(uint256 amount) external;
1209 
1210   function swapmint(uint256 amount, address to) external returns (bool);
1211 }
1212 
1213 
1214 
1215 
1216         
1217 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1218 pragma solidity ^0.8.9;
1219 
1220 ////import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
1221 
1222 interface IFractonFFT is IERC20 {
1223   event SetPercent(uint256 vaultPercent, uint256 pfVaultPercent);
1224 
1225   function swapmint(uint256 amount, address to) external returns (bool);
1226 
1227   function transfer(address to, uint256 value) external returns (bool);
1228 
1229   function multiTransfer(address[] memory receivers, uint256[] memory amounts)
1230     external;
1231 
1232   function transferFrom(
1233     address from,
1234     address to,
1235     uint256 value
1236   ) external returns (bool);
1237 
1238   function burnFrom(address from, uint256 value) external returns (bool);
1239 
1240   function isExcludedFromFee(address account) external view returns (bool);
1241 
1242   function updateFee(uint256 vaultPercent_, uint256 pfVaultPercent_)
1243     external
1244     returns (bool);
1245 
1246   function excludeFromFee(address account) external returns (bool);
1247   function batchExcludeFromFee(address[] memory accounts) external returns (bool);
1248   function includeInFee(address account) external returns (bool);
1249 }
1250 
1251 
1252 
1253 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1254 pragma solidity ^0.8.9;
1255 
1256 ////import {IFractonFFT} from "../interface/IFractonFFT.sol";
1257 ////import {IFractonMiniNFT} from "../interface/IFractonMiniNFT.sol";
1258 ////import {IFractonSwap} from "../interface/IFractonSwap.sol";
1259 ////import {IFractonTokenFactory} from "../interface/IFractonTokenFactory.sol";
1260 ////import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
1261 ////import {IERC20, SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
1262 ////import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
1263 ////import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
1264 ////import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
1265 ////import {ERC1155Holder} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
1266 
1267 /// @title FractonDAO
1268 /// @dev It Implements fracton system onlyDAO functions
1269 contract FractonDAO is Ownable, ERC721Holder, ERC1155Holder {
1270     using SafeERC20 for IERC20;
1271 
1272     /// @notice Whitelist NFT collections and users for permissionless fraction
1273     mapping(address => mapping(address => bool)) public whiteListedUsers;
1274 
1275     /// @notice Fracton Token Factory address
1276     IFractonTokenFactory public immutable fractonTokenFactory;
1277 
1278     /// @notice FractonSwap address
1279     IFractonSwap public immutable fractonSwap;
1280 
1281     event WithdrawEtherFromMiniNFT(address miniNFT, uint256 amount, address receiver);
1282 
1283     event WithdrawERC20FromSwap(address token, uint256 amount, address receiver);
1284 
1285     event WithdrawERC721FromSwap(address token, uint256 tokenId, address receiver);
1286 
1287     event WithdrawERC1155FromSwap(address token, uint256 tokenId, uint256 amount, address receiver);
1288 
1289     event WhiteListedUserSet(address collection, address user, bool enabled);
1290 
1291     modifier onlyWhiteListed(address _user, address _collection) {
1292         require(
1293             whiteListedUsers[_collection][_user],
1294             "Fracton: user not authorized"
1295         );
1296         _;
1297     }
1298 
1299     constructor(address _fractonTokenFactory, address _fractonSwap) {
1300         require(_fractonTokenFactory != address(0), "Fracton: Invalid address");
1301         require(_fractonSwap != address(0), "Fracton: Invalid address");
1302 
1303         fractonTokenFactory = IFractonTokenFactory(_fractonTokenFactory);
1304         fractonSwap = IFractonSwap(_fractonSwap);
1305     }
1306 
1307     /// @notice Update a user whitelisted status
1308     /// @param _user the user address
1309     /// @param _enable true if whitelist the user for permissionless fraction, vice versa
1310     function updateWhitelistedUser(address _collection,address _user,  bool _enable) external onlyOwner {
1311         whiteListedUsers[_collection][_user] = _enable;
1312         emit WhiteListedUserSet(_collection, _user, _enable);
1313     }
1314 
1315     /************************************************
1316      *         Fracton FFT onlyDAO functions
1317      ************************************************/
1318     function excludeFromFee(address _account, address _fft) external onlyOwner {
1319         require(
1320             IFractonFFT(_fft).excludeFromFee(_account),
1321             "Fracton: exclude from fee failed"
1322         );
1323     }
1324 
1325     function batchExcludeFromFee(
1326         address[] memory _accounts,
1327         address _fft
1328     ) external onlyOwner {
1329         require(
1330             IFractonFFT(_fft).batchExcludeFromFee(_accounts),
1331             "Fracton: batch exclude from fee failed"
1332         );
1333     }
1334 
1335     function updateFee(
1336         uint256 _vaultPercent,
1337         uint256 _pfVaultPercent,
1338         address _fft
1339     ) external onlyOwner {
1340         require(
1341             IFractonFFT(_fft).updateFee(_vaultPercent, _pfVaultPercent),
1342             "Fracton: update fee failed"
1343         );
1344     }
1345 
1346     function includeInFee(address _account, address _fft) external onlyOwner {
1347         require(
1348             IFractonFFT(_fft).includeInFee(_account),
1349             "Fracton: include in fee failed"
1350         );
1351     }
1352 
1353     /************************************************
1354      *         Fracton miniNFT onlyDAO functions
1355      ************************************************/
1356     function startNewRound(uint256 _sellingPrice, address _miniNFT) external onlyOwner {
1357         require(
1358             IFractonMiniNFT(_miniNFT).startNewRound(_sellingPrice),
1359             "Fracton: start new round failed"
1360         );
1361     }
1362 
1363     function closeRound(address _miniNFT) external onlyOwner {
1364         require(
1365             IFractonMiniNFT(_miniNFT).closeRound(),
1366             "Fracton: close round failed"
1367         );
1368     }
1369 
1370     /// @notice Withdraw fundrasing ethers for purchasing NFT
1371     function withdrawEther(address _miniNFT, address _receiver) external onlyOwner {
1372         require(
1373             IFractonMiniNFT(_miniNFT).withdrawEther(),
1374             "Fracton: withdraw ether failed"
1375         );
1376         uint256 amount = address(this).balance;
1377         payable(_receiver).transfer(amount);
1378 
1379         emit WithdrawEtherFromMiniNFT(_miniNFT, amount, _receiver);
1380     }
1381 
1382     function updateRoundSucceed(uint256 _round, address _miniNFT) external onlyOwner {
1383         require(
1384             IFractonMiniNFT(_miniNFT).updateRoundSucceed(_round),
1385             "Fracton: update round falied"
1386         );
1387     }
1388 
1389     function updateBlindBoxPrice(uint256 _newPrice, address _miniNFT) external onlyOwner {
1390         require(
1391             IFractonMiniNFT(_miniNFT).updateBlindBoxPrice(_newPrice),
1392             "Fracton: update new price falied"
1393         );
1394     }
1395 
1396     /************************************************
1397      *         Fracton swap onlyDAO functions
1398      ************************************************/
1399     function swapNFTtoMiniNFT(
1400         address _collection,
1401         uint256 _tokenId
1402     ) external onlyWhiteListed(_msgSender(), _collection) {
1403         require(
1404             IFractonSwap(fractonSwap).swapNFTtoMiniNFT(
1405                 _collection,
1406                 _msgSender(),
1407                 _tokenId
1408             ),
1409             "Fracton: swap NFT to MiniNFT failed"
1410         );
1411     }
1412 
1413     function withdrawERC20(
1414         address _project,
1415         uint256 _amount,
1416         address _receiver
1417     ) external onlyOwner {
1418         require(
1419             IFractonSwap(fractonSwap).withdrawERC20(_project, _amount),
1420             "Fracton: withdraw ERC20 failed"
1421         );
1422         IERC20(_project).safeTransfer(
1423             _receiver,
1424             _amount
1425         );
1426 
1427         emit WithdrawERC20FromSwap(_project, _amount, _receiver);
1428     }
1429 
1430     function withdrawERC721(
1431         address _airdropContract,
1432         uint256 _tokenId,
1433         address _receiver
1434     ) external onlyOwner {
1435         require(
1436             IFractonSwap(fractonSwap).withdrawERC721(
1437                 _airdropContract,
1438                 _tokenId
1439             ),
1440             "Fracton: withdraw ERC721 failed" 
1441         );
1442         IERC721(_airdropContract).safeTransferFrom(
1443             address(this),
1444             _receiver,
1445             _tokenId
1446         );
1447 
1448         emit WithdrawERC721FromSwap(_airdropContract, _tokenId, _receiver);
1449     }
1450 
1451     function withdrawERC1155(
1452         address _airdropContract,
1453         uint256 _tokenId,
1454         uint256 _amount,
1455         address _receiver
1456     ) external onlyOwner {
1457         require(
1458             IFractonSwap(fractonSwap).withdrawERC1155(
1459                 _airdropContract,
1460                 _tokenId,
1461                 _amount
1462             ),
1463             "Fracton: withdraw ERC1155 failed"
1464         );
1465         IERC1155(_airdropContract).safeTransferFrom(
1466             address(this),
1467             _receiver,
1468             _tokenId,
1469             _amount,
1470             ""
1471         );
1472 
1473         emit WithdrawERC1155FromSwap(_airdropContract, _tokenId, _amount, _receiver);
1474     }
1475 
1476     function updateTax(uint256 _fftTax, uint256 _nftTax) external onlyOwner {
1477         require(
1478             IFractonSwap(fractonSwap).updateTax(_fftTax, _nftTax),
1479             "Fracton: update tax failed"
1480         );
1481     }
1482 
1483     function updateCallbackGasLimit(uint32 _gasLimit) external onlyOwner {
1484         require(
1485             IFractonSwap(fractonSwap).updateCallbackGasLimit(_gasLimit),
1486             "Fracton: update callback gas limit failed"
1487         );
1488     }
1489 
1490     function updateVrfSubscriptionId(uint64 _subscriptionId) external onlyOwner {
1491         require(
1492             IFractonSwap(fractonSwap).updateVrfSubscriptionId(_subscriptionId),
1493             "Fracton: update vrf subscriptionId failed"
1494         );
1495     }
1496 
1497     /************************************************
1498      *     Fracton token factory onlyDAO functions
1499      ************************************************/
1500     function updateDao(address _daoAddress) external onlyOwner {
1501         require(
1502             IFractonTokenFactory(fractonTokenFactory).updateDao(_daoAddress),
1503             "Fracton: update dao failed"
1504         );
1505     }
1506 
1507     function updateVault(address _pendingVault) external onlyOwner {
1508         require(
1509             IFractonTokenFactory(fractonTokenFactory).updateVault(_pendingVault),
1510             "Fracton: update vault failed"
1511         );
1512     }
1513 
1514     function updatePFVault(address _pendingPFVault) external onlyOwner {
1515         require(
1516             IFractonTokenFactory(fractonTokenFactory).updatePFVault(_pendingPFVault),
1517              "Fracton: update PFvault failed"
1518         );
1519     }
1520 
1521     /// @dev See {IERC721Receiver-onERC721Received}.
1522     function onERC721Received(
1523         address,
1524         address,
1525         uint256,
1526         bytes memory
1527     ) public virtual override returns (bytes4) {
1528         return this.onERC721Received.selector;
1529     }
1530 
1531     /// @dev See {IERC1155Receiver-onERC1155Received}.
1532     function onERC1155Received(
1533         address,
1534         address,
1535         uint256,
1536         uint256,
1537         bytes memory
1538     ) public virtual override returns (bytes4) {
1539         return this.onERC1155Received.selector;
1540     }
1541 
1542     receive() external payable {}
1543 }