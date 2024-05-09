1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/utils/Strings.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 }
117 
118 // File: @openzeppelin/contracts/utils/Address.sol
119 
120 
121 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
122 
123 pragma solidity ^0.8.1;
124 
125 /**
126  * @dev Collection of functions related to the address type
127  */
128 library Address {
129     /**
130      * @dev Returns true if `account` is a contract.
131      *
132      * [IMPORTANT]
133      * ====
134      * It is unsafe to assume that an address for which this function returns
135      * false is an externally-owned account (EOA) and not a contract.
136      *
137      * Among others, `isContract` will return false for the following
138      * types of addresses:
139      *
140      *  - an externally-owned account
141      *  - a contract in construction
142      *  - an address where a contract will be created
143      *  - an address where a contract lived, but was destroyed
144      * ====
145      *
146      * [IMPORTANT]
147      * ====
148      * You shouldn't rely on `isContract` to protect against flash loan attacks!
149      *
150      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
151      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
152      * constructor.
153      * ====
154      */
155     function isContract(address account) internal view returns (bool) {
156         // This method relies on extcodesize/address.code.length, which returns 0
157         // for contracts in construction, since the code is only stored at the end
158         // of the constructor execution.
159 
160         return account.code.length > 0;
161     }
162 
163     /**
164      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
165      * `recipient`, forwarding all available gas and reverting on errors.
166      *
167      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
168      * of certain opcodes, possibly making contracts go over the 2300 gas limit
169      * imposed by `transfer`, making them unable to receive funds via
170      * `transfer`. {sendValue} removes this limitation.
171      *
172      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
173      *
174      * IMPORTANT: because control is transferred to `recipient`, care must be
175      * taken to not create reentrancy vulnerabilities. Consider using
176      * {ReentrancyGuard} or the
177      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
178      */
179     function sendValue(address payable recipient, uint256 amount) internal {
180         require(address(this).balance >= amount, "Address: insufficient balance");
181 
182         (bool success, ) = recipient.call{value: amount}("");
183         require(success, "Address: unable to send value, recipient may have reverted");
184     }
185 
186     /**
187      * @dev Performs a Solidity function call using a low level `call`. A
188      * plain `call` is an unsafe replacement for a function call: use this
189      * function instead.
190      *
191      * If `target` reverts with a revert reason, it is bubbled up by this
192      * function (like regular Solidity function calls).
193      *
194      * Returns the raw returned data. To convert to the expected return value,
195      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
196      *
197      * Requirements:
198      *
199      * - `target` must be a contract.
200      * - calling `target` with `data` must not revert.
201      *
202      * _Available since v3.1._
203      */
204     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionCall(target, data, "Address: low-level call failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
210      * `errorMessage` as a fallback revert reason when `target` reverts.
211      *
212      * _Available since v3.1._
213      */
214     function functionCall(
215         address target,
216         bytes memory data,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, 0, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but also transferring `value` wei to `target`.
225      *
226      * Requirements:
227      *
228      * - the calling contract must have an ETH balance of at least `value`.
229      * - the called Solidity function must be `payable`.
230      *
231      * _Available since v3.1._
232      */
233     function functionCallWithValue(
234         address target,
235         bytes memory data,
236         uint256 value
237     ) internal returns (bytes memory) {
238         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
243      * with `errorMessage` as a fallback revert reason when `target` reverts.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         require(address(this).balance >= value, "Address: insufficient balance for call");
254         require(isContract(target), "Address: call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.call{value: value}(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but performing a static call.
263      *
264      * _Available since v3.3._
265      */
266     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
267         return functionStaticCall(target, data, "Address: low-level static call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
272      * but performing a static call.
273      *
274      * _Available since v3.3._
275      */
276     function functionStaticCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal view returns (bytes memory) {
281         require(isContract(target), "Address: static call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.staticcall(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a delegate call.
290      *
291      * _Available since v3.4._
292      */
293     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
294         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
299      * but performing a delegate call.
300      *
301      * _Available since v3.4._
302      */
303     function functionDelegateCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         require(isContract(target), "Address: delegate call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.delegatecall(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
316      * revert reason using the provided one.
317      *
318      * _Available since v4.3._
319      */
320     function verifyCallResult(
321         bool success,
322         bytes memory returndata,
323         string memory errorMessage
324     ) internal pure returns (bytes memory) {
325         if (success) {
326             return returndata;
327         } else {
328             // Look for revert reason and bubble it up if present
329             if (returndata.length > 0) {
330                 // The easiest way to bubble the revert reason is using memory via assembly
331 
332                 assembly {
333                     let returndata_size := mload(returndata)
334                     revert(add(32, returndata), returndata_size)
335                 }
336             } else {
337                 revert(errorMessage);
338             }
339         }
340     }
341 }
342 
343 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
344 
345 
346 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @title ERC721 token receiver interface
352  * @dev Interface for any contract that wants to support safeTransfers
353  * from ERC721 asset contracts.
354  */
355 interface IERC721Receiver {
356     /**
357      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
358      * by `operator` from `from`, this function is called.
359      *
360      * It must return its Solidity selector to confirm the token transfer.
361      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
362      *
363      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
364      */
365     function onERC721Received(
366         address operator,
367         address from,
368         uint256 tokenId,
369         bytes calldata data
370     ) external returns (bytes4);
371 }
372 
373 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @dev Interface of the ERC165 standard, as defined in the
382  * https://eips.ethereum.org/EIPS/eip-165[EIP].
383  *
384  * Implementers can declare support of contract interfaces, which can then be
385  * queried by others ({ERC165Checker}).
386  *
387  * For an implementation, see {ERC165}.
388  */
389 interface IERC165 {
390     /**
391      * @dev Returns true if this contract implements the interface defined by
392      * `interfaceId`. See the corresponding
393      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
394      * to learn more about how these ids are created.
395      *
396      * This function call must use less than 30 000 gas.
397      */
398     function supportsInterface(bytes4 interfaceId) external view returns (bool);
399 }
400 
401 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 
409 /**
410  * @dev Implementation of the {IERC165} interface.
411  *
412  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
413  * for the additional interface id that will be supported. For example:
414  *
415  * ```solidity
416  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
417  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
418  * }
419  * ```
420  *
421  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
422  */
423 abstract contract ERC165 is IERC165 {
424     /**
425      * @dev See {IERC165-supportsInterface}.
426      */
427     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
428         return interfaceId == type(IERC165).interfaceId;
429     }
430 }
431 
432 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 
440 /**
441  * @dev Required interface of an ERC721 compliant contract.
442  */
443 interface IERC721 is IERC165 {
444     /**
445      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
446      */
447     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
448 
449     /**
450      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
451      */
452     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
453 
454     /**
455      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
456      */
457     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
458 
459     /**
460      * @dev Returns the number of tokens in ``owner``'s account.
461      */
462     function balanceOf(address owner) external view returns (uint256 balance);
463 
464     /**
465      * @dev Returns the owner of the `tokenId` token.
466      *
467      * Requirements:
468      *
469      * - `tokenId` must exist.
470      */
471     function ownerOf(uint256 tokenId) external view returns (address owner);
472 
473     /**
474      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
475      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
476      *
477      * Requirements:
478      *
479      * - `from` cannot be the zero address.
480      * - `to` cannot be the zero address.
481      * - `tokenId` token must exist and be owned by `from`.
482      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
483      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
484      *
485      * Emits a {Transfer} event.
486      */
487     function safeTransferFrom(
488         address from,
489         address to,
490         uint256 tokenId
491     ) external;
492 
493     /**
494      * @dev Transfers `tokenId` token from `from` to `to`.
495      *
496      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
497      *
498      * Requirements:
499      *
500      * - `from` cannot be the zero address.
501      * - `to` cannot be the zero address.
502      * - `tokenId` token must be owned by `from`.
503      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
504      *
505      * Emits a {Transfer} event.
506      */
507     function transferFrom(
508         address from,
509         address to,
510         uint256 tokenId
511     ) external;
512 
513     /**
514      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
515      * The approval is cleared when the token is transferred.
516      *
517      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
518      *
519      * Requirements:
520      *
521      * - The caller must own the token or be an approved operator.
522      * - `tokenId` must exist.
523      *
524      * Emits an {Approval} event.
525      */
526     function approve(address to, uint256 tokenId) external;
527 
528     /**
529      * @dev Returns the account approved for `tokenId` token.
530      *
531      * Requirements:
532      *
533      * - `tokenId` must exist.
534      */
535     function getApproved(uint256 tokenId) external view returns (address operator);
536 
537     /**
538      * @dev Approve or remove `operator` as an operator for the caller.
539      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
540      *
541      * Requirements:
542      *
543      * - The `operator` cannot be the caller.
544      *
545      * Emits an {ApprovalForAll} event.
546      */
547     function setApprovalForAll(address operator, bool _approved) external;
548 
549     /**
550      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
551      *
552      * See {setApprovalForAll}
553      */
554     function isApprovedForAll(address owner, address operator) external view returns (bool);
555 
556     /**
557      * @dev Safely transfers `tokenId` token from `from` to `to`.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must exist and be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
566      *
567      * Emits a {Transfer} event.
568      */
569     function safeTransferFrom(
570         address from,
571         address to,
572         uint256 tokenId,
573         bytes calldata data
574     ) external;
575 }
576 
577 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
578 
579 
580 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 
585 /**
586  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
587  * @dev See https://eips.ethereum.org/EIPS/eip-721
588  */
589 interface IERC721Enumerable is IERC721 {
590     /**
591      * @dev Returns the total amount of tokens stored by the contract.
592      */
593     function totalSupply() external view returns (uint256);
594 
595     /**
596      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
597      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
598      */
599     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
600 
601     /**
602      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
603      * Use along with {totalSupply} to enumerate all tokens.
604      */
605     function tokenByIndex(uint256 index) external view returns (uint256);
606 }
607 
608 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
609 
610 
611 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 
616 /**
617  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
618  * @dev See https://eips.ethereum.org/EIPS/eip-721
619  */
620 interface IERC721Metadata is IERC721 {
621     /**
622      * @dev Returns the token collection name.
623      */
624     function name() external view returns (string memory);
625 
626     /**
627      * @dev Returns the token collection symbol.
628      */
629     function symbol() external view returns (string memory);
630 
631     /**
632      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
633      */
634     function tokenURI(uint256 tokenId) external view returns (string memory);
635 }
636 
637 // File: @openzeppelin/contracts/utils/Context.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev Provides information about the current execution context, including the
646  * sender of the transaction and its data. While these are generally available
647  * via msg.sender and msg.data, they should not be accessed in such a direct
648  * manner, since when dealing with meta-transactions the account sending and
649  * paying for execution may not be the actual sender (as far as an application
650  * is concerned).
651  *
652  * This contract is only required for intermediate, library-like contracts.
653  */
654 abstract contract Context {
655     function _msgSender() internal view virtual returns (address) {
656         return msg.sender;
657     }
658 
659     function _msgData() internal view virtual returns (bytes calldata) {
660         return msg.data;
661     }
662 }
663 
664 // File: @openzeppelin/contracts/security/Pausable.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @dev Contract module which allows children to implement an emergency stop
674  * mechanism that can be triggered by an authorized account.
675  *
676  * This module is used through inheritance. It will make available the
677  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
678  * the functions of your contract. Note that they will not be pausable by
679  * simply including this module, only once the modifiers are put in place.
680  */
681 abstract contract Pausable is Context {
682     /**
683      * @dev Emitted when the pause is triggered by `account`.
684      */
685     event Paused(address account);
686 
687     /**
688      * @dev Emitted when the pause is lifted by `account`.
689      */
690     event Unpaused(address account);
691 
692     bool private _paused;
693 
694     /**
695      * @dev Initializes the contract in unpaused state.
696      */
697     constructor() {
698         _paused = false;
699     }
700 
701     /**
702      * @dev Returns true if the contract is paused, and false otherwise.
703      */
704     function paused() public view virtual returns (bool) {
705         return _paused;
706     }
707 
708     /**
709      * @dev Modifier to make a function callable only when the contract is not paused.
710      *
711      * Requirements:
712      *
713      * - The contract must not be paused.
714      */
715     modifier whenNotPaused() {
716         require(!paused(), "Pausable: paused");
717         _;
718     }
719 
720     /**
721      * @dev Modifier to make a function callable only when the contract is paused.
722      *
723      * Requirements:
724      *
725      * - The contract must be paused.
726      */
727     modifier whenPaused() {
728         require(paused(), "Pausable: not paused");
729         _;
730     }
731 
732     /**
733      * @dev Triggers stopped state.
734      *
735      * Requirements:
736      *
737      * - The contract must not be paused.
738      */
739     function _pause() internal virtual whenNotPaused {
740         _paused = true;
741         emit Paused(_msgSender());
742     }
743 
744     /**
745      * @dev Returns to normal state.
746      *
747      * Requirements:
748      *
749      * - The contract must be paused.
750      */
751     function _unpause() internal virtual whenPaused {
752         _paused = false;
753         emit Unpaused(_msgSender());
754     }
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
758 
759 
760 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 
766 
767 
768 
769 
770 
771 /**
772  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
773  * the Metadata extension, but not including the Enumerable extension, which is available separately as
774  * {ERC721Enumerable}.
775  */
776 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
777     using Address for address;
778     using Strings for uint256;
779 
780     // Token name
781     string private _name;
782 
783     // Token symbol
784     string private _symbol;
785 
786     // Mapping from token ID to owner address
787     mapping(uint256 => address) private _owners;
788 
789     // Mapping owner address to token count
790     mapping(address => uint256) private _balances;
791 
792     // Mapping from token ID to approved address
793     mapping(uint256 => address) private _tokenApprovals;
794 
795     // Mapping from owner to operator approvals
796     mapping(address => mapping(address => bool)) private _operatorApprovals;
797 
798     /**
799      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
800      */
801     constructor(string memory name_, string memory symbol_) {
802         _name = name_;
803         _symbol = symbol_;
804     }
805 
806     /**
807      * @dev See {IERC165-supportsInterface}.
808      */
809     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
810         return
811             interfaceId == type(IERC721).interfaceId ||
812             interfaceId == type(IERC721Metadata).interfaceId ||
813             super.supportsInterface(interfaceId);
814     }
815 
816     /**
817      * @dev See {IERC721-balanceOf}.
818      */
819     function balanceOf(address owner) public view virtual override returns (uint256) {
820         require(owner != address(0), "ERC721: balance query for the zero address");
821         return _balances[owner];
822     }
823 
824     /**
825      * @dev See {IERC721-ownerOf}.
826      */
827     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
828         address owner = _owners[tokenId];
829         require(owner != address(0), "ERC721: owner query for nonexistent token");
830         return owner;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-name}.
835      */
836     function name() public view virtual override returns (string memory) {
837         return _name;
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-symbol}.
842      */
843     function symbol() public view virtual override returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-tokenURI}.
849      */
850     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
851         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
852 
853         string memory baseURI = _baseURI();
854         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
855     }
856 
857     /**
858      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
859      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
860      * by default, can be overriden in child contracts.
861      */
862     function _baseURI() internal view virtual returns (string memory) {
863         return "";
864     }
865 
866     /**
867      * @dev See {IERC721-approve}.
868      */
869     function approve(address to, uint256 tokenId) public virtual override {
870         address owner = ERC721.ownerOf(tokenId);
871         require(to != owner, "ERC721: approval to current owner");
872 
873         require(
874             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
875             "ERC721: approve caller is not owner nor approved for all"
876         );
877 
878         _approve(to, tokenId);
879     }
880 
881     /**
882      * @dev See {IERC721-getApproved}.
883      */
884     function getApproved(uint256 tokenId) public view virtual override returns (address) {
885         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
886 
887         return _tokenApprovals[tokenId];
888     }
889 
890     /**
891      * @dev See {IERC721-setApprovalForAll}.
892      */
893     function setApprovalForAll(address operator, bool approved) public virtual override {
894         _setApprovalForAll(_msgSender(), operator, approved);
895     }
896 
897     /**
898      * @dev See {IERC721-isApprovedForAll}.
899      */
900     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
901         return _operatorApprovals[owner][operator];
902     }
903 
904     /**
905      * @dev See {IERC721-transferFrom}.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public virtual override {
912         //solhint-disable-next-line max-line-length
913         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
914 
915         _transfer(from, to, tokenId);
916     }
917 
918     /**
919      * @dev See {IERC721-safeTransferFrom}.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId
925     ) public virtual override {
926         safeTransferFrom(from, to, tokenId, "");
927     }
928 
929     /**
930      * @dev See {IERC721-safeTransferFrom}.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) public virtual override {
938         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
939         _safeTransfer(from, to, tokenId, _data);
940     }
941 
942     /**
943      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
944      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
945      *
946      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
947      *
948      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
949      * implement alternative mechanisms to perform token transfer, such as signature-based.
950      *
951      * Requirements:
952      *
953      * - `from` cannot be the zero address.
954      * - `to` cannot be the zero address.
955      * - `tokenId` token must exist and be owned by `from`.
956      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _safeTransfer(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) internal virtual {
966         _transfer(from, to, tokenId);
967         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
968     }
969 
970     /**
971      * @dev Returns whether `tokenId` exists.
972      *
973      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
974      *
975      * Tokens start existing when they are minted (`_mint`),
976      * and stop existing when they are burned (`_burn`).
977      */
978     function _exists(uint256 tokenId) internal view virtual returns (bool) {
979         return _owners[tokenId] != address(0);
980     }
981 
982     /**
983      * @dev Returns whether `spender` is allowed to manage `tokenId`.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      */
989     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
990         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
991         address owner = ERC721.ownerOf(tokenId);
992         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
993     }
994 
995     /**
996      * @dev Safely mints `tokenId` and transfers it to `to`.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must not exist.
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _safeMint(address to, uint256 tokenId) internal virtual {
1006         _safeMint(to, tokenId, "");
1007     }
1008 
1009     /**
1010      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1011      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1012      */
1013     function _safeMint(
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) internal virtual {
1018         _mint(to, tokenId);
1019         require(
1020             _checkOnERC721Received(address(0), to, tokenId, _data),
1021             "ERC721: transfer to non ERC721Receiver implementer"
1022         );
1023     }
1024 
1025     /**
1026      * @dev Mints `tokenId` and transfers it to `to`.
1027      *
1028      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must not exist.
1033      * - `to` cannot be the zero address.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _mint(address to, uint256 tokenId) internal virtual {
1038         require(to != address(0), "ERC721: mint to the zero address");
1039         require(!_exists(tokenId), "ERC721: token already minted");
1040 
1041         _beforeTokenTransfer(address(0), to, tokenId);
1042 
1043         _balances[to] += 1;
1044         _owners[tokenId] = to;
1045 
1046         emit Transfer(address(0), to, tokenId);
1047 
1048         _afterTokenTransfer(address(0), to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev Destroys `tokenId`.
1053      * The approval is cleared when the token is burned.
1054      *
1055      * Requirements:
1056      *
1057      * - `tokenId` must exist.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _burn(uint256 tokenId) internal virtual {
1062         address owner = ERC721.ownerOf(tokenId);
1063 
1064         _beforeTokenTransfer(owner, address(0), tokenId);
1065 
1066         // Clear approvals
1067         _approve(address(0), tokenId);
1068 
1069         _balances[owner] -= 1;
1070         delete _owners[tokenId];
1071 
1072         emit Transfer(owner, address(0), tokenId);
1073 
1074         _afterTokenTransfer(owner, address(0), tokenId);
1075     }
1076 
1077     /**
1078      * @dev Transfers `tokenId` from `from` to `to`.
1079      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1080      *
1081      * Requirements:
1082      *
1083      * - `to` cannot be the zero address.
1084      * - `tokenId` token must be owned by `from`.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _transfer(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) internal virtual {
1093         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1094         require(to != address(0), "ERC721: transfer to the zero address");
1095 
1096         _beforeTokenTransfer(from, to, tokenId);
1097 
1098         // Clear approvals from the previous owner
1099         _approve(address(0), tokenId);
1100 
1101         _balances[from] -= 1;
1102         _balances[to] += 1;
1103         _owners[tokenId] = to;
1104 
1105         emit Transfer(from, to, tokenId);
1106 
1107         _afterTokenTransfer(from, to, tokenId);
1108     }
1109 
1110     /**
1111      * @dev Approve `to` to operate on `tokenId`
1112      *
1113      * Emits a {Approval} event.
1114      */
1115     function _approve(address to, uint256 tokenId) internal virtual {
1116         _tokenApprovals[tokenId] = to;
1117         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1118     }
1119 
1120     /**
1121      * @dev Approve `operator` to operate on all of `owner` tokens
1122      *
1123      * Emits a {ApprovalForAll} event.
1124      */
1125     function _setApprovalForAll(
1126         address owner,
1127         address operator,
1128         bool approved
1129     ) internal virtual {
1130         require(owner != operator, "ERC721: approve to caller");
1131         _operatorApprovals[owner][operator] = approved;
1132         emit ApprovalForAll(owner, operator, approved);
1133     }
1134 
1135     /**
1136      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1137      * The call is not executed if the target address is not a contract.
1138      *
1139      * @param from address representing the previous owner of the given token ID
1140      * @param to target address that will receive the tokens
1141      * @param tokenId uint256 ID of the token to be transferred
1142      * @param _data bytes optional data to send along with the call
1143      * @return bool whether the call correctly returned the expected magic value
1144      */
1145     function _checkOnERC721Received(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) private returns (bool) {
1151         if (to.isContract()) {
1152             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1153                 return retval == IERC721Receiver.onERC721Received.selector;
1154             } catch (bytes memory reason) {
1155                 if (reason.length == 0) {
1156                     revert("ERC721: transfer to non ERC721Receiver implementer");
1157                 } else {
1158                     assembly {
1159                         revert(add(32, reason), mload(reason))
1160                     }
1161                 }
1162             }
1163         } else {
1164             return true;
1165         }
1166     }
1167 
1168     /**
1169      * @dev Hook that is called before any token transfer. This includes minting
1170      * and burning.
1171      *
1172      * Calling conditions:
1173      *
1174      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1175      * transferred to `to`.
1176      * - When `from` is zero, `tokenId` will be minted for `to`.
1177      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1178      * - `from` and `to` are never both zero.
1179      *
1180      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1181      */
1182     function _beforeTokenTransfer(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) internal virtual {}
1187 
1188     /**
1189      * @dev Hook that is called after any transfer of tokens. This includes
1190      * minting and burning.
1191      *
1192      * Calling conditions:
1193      *
1194      * - when `from` and `to` are both non-zero.
1195      * - `from` and `to` are never both zero.
1196      *
1197      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1198      */
1199     function _afterTokenTransfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) internal virtual {}
1204 }
1205 
1206 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1207 
1208 
1209 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1210 
1211 pragma solidity ^0.8.0;
1212 
1213 
1214 
1215 /**
1216  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1217  * enumerability of all the token ids in the contract as well as all token ids owned by each
1218  * account.
1219  */
1220 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1221     // Mapping from owner to list of owned token IDs
1222     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1223 
1224     // Mapping from token ID to index of the owner tokens list
1225     mapping(uint256 => uint256) private _ownedTokensIndex;
1226 
1227     // Array with all token ids, used for enumeration
1228     uint256[] private _allTokens;
1229 
1230     // Mapping from token id to position in the allTokens array
1231     mapping(uint256 => uint256) private _allTokensIndex;
1232 
1233     /**
1234      * @dev See {IERC165-supportsInterface}.
1235      */
1236     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1237         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1238     }
1239 
1240     /**
1241      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1242      */
1243     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1244         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1245         return _ownedTokens[owner][index];
1246     }
1247 
1248     /**
1249      * @dev See {IERC721Enumerable-totalSupply}.
1250      */
1251     function totalSupply() public view virtual override returns (uint256) {
1252         return _allTokens.length;
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Enumerable-tokenByIndex}.
1257      */
1258     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1259         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1260         return _allTokens[index];
1261     }
1262 
1263     /**
1264      * @dev Hook that is called before any token transfer. This includes minting
1265      * and burning.
1266      *
1267      * Calling conditions:
1268      *
1269      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1270      * transferred to `to`.
1271      * - When `from` is zero, `tokenId` will be minted for `to`.
1272      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1273      * - `from` cannot be the zero address.
1274      * - `to` cannot be the zero address.
1275      *
1276      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1277      */
1278     function _beforeTokenTransfer(
1279         address from,
1280         address to,
1281         uint256 tokenId
1282     ) internal virtual override {
1283         super._beforeTokenTransfer(from, to, tokenId);
1284 
1285         if (from == address(0)) {
1286             _addTokenToAllTokensEnumeration(tokenId);
1287         } else if (from != to) {
1288             _removeTokenFromOwnerEnumeration(from, tokenId);
1289         }
1290         if (to == address(0)) {
1291             _removeTokenFromAllTokensEnumeration(tokenId);
1292         } else if (to != from) {
1293             _addTokenToOwnerEnumeration(to, tokenId);
1294         }
1295     }
1296 
1297     /**
1298      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1299      * @param to address representing the new owner of the given token ID
1300      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1301      */
1302     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1303         uint256 length = ERC721.balanceOf(to);
1304         _ownedTokens[to][length] = tokenId;
1305         _ownedTokensIndex[tokenId] = length;
1306     }
1307 
1308     /**
1309      * @dev Private function to add a token to this extension's token tracking data structures.
1310      * @param tokenId uint256 ID of the token to be added to the tokens list
1311      */
1312     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1313         _allTokensIndex[tokenId] = _allTokens.length;
1314         _allTokens.push(tokenId);
1315     }
1316 
1317     /**
1318      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1319      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1320      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1321      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1322      * @param from address representing the previous owner of the given token ID
1323      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1324      */
1325     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1326         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1327         // then delete the last slot (swap and pop).
1328 
1329         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1330         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1331 
1332         // When the token to delete is the last token, the swap operation is unnecessary
1333         if (tokenIndex != lastTokenIndex) {
1334             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1335 
1336             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1337             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1338         }
1339 
1340         // This also deletes the contents at the last position of the array
1341         delete _ownedTokensIndex[tokenId];
1342         delete _ownedTokens[from][lastTokenIndex];
1343     }
1344 
1345     /**
1346      * @dev Private function to remove a token from this extension's token tracking data structures.
1347      * This has O(1) time complexity, but alters the order of the _allTokens array.
1348      * @param tokenId uint256 ID of the token to be removed from the tokens list
1349      */
1350     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1351         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1352         // then delete the last slot (swap and pop).
1353 
1354         uint256 lastTokenIndex = _allTokens.length - 1;
1355         uint256 tokenIndex = _allTokensIndex[tokenId];
1356 
1357         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1358         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1359         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1360         uint256 lastTokenId = _allTokens[lastTokenIndex];
1361 
1362         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1363         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1364 
1365         // This also deletes the contents at the last position of the array
1366         delete _allTokensIndex[tokenId];
1367         _allTokens.pop();
1368     }
1369 }
1370 
1371 // File: @openzeppelin/contracts/access/Ownable.sol
1372 
1373 
1374 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1375 
1376 pragma solidity ^0.8.0;
1377 
1378 
1379 /**
1380  * @dev Contract module which provides a basic access control mechanism, where
1381  * there is an account (an owner) that can be granted exclusive access to
1382  * specific functions.
1383  *
1384  * By default, the owner account will be the one that deploys the contract. This
1385  * can later be changed with {transferOwnership}.
1386  *
1387  * This module is used through inheritance. It will make available the modifier
1388  * `onlyOwner`, which can be applied to your functions to restrict their use to
1389  * the owner.
1390  */
1391 abstract contract Ownable is Context {
1392     address private _owner;
1393 
1394     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1395 
1396     /**
1397      * @dev Initializes the contract setting the deployer as the initial owner.
1398      */
1399     constructor() {
1400         _transferOwnership(_msgSender());
1401     }
1402 
1403     /**
1404      * @dev Returns the address of the current owner.
1405      */
1406     function owner() public view virtual returns (address) {
1407         return _owner;
1408     }
1409 
1410     /**
1411      * @dev Throws if called by any account other than the owner.
1412      */
1413     modifier onlyOwner() {
1414         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1415         _;
1416     }
1417 
1418     /**
1419      * @dev Leaves the contract without owner. It will not be possible to call
1420      * `onlyOwner` functions anymore. Can only be called by the current owner.
1421      *
1422      * NOTE: Renouncing ownership will leave the contract without an owner,
1423      * thereby removing any functionality that is only available to the owner.
1424      */
1425     function renounceOwnership() public virtual onlyOwner {
1426         _transferOwnership(address(0));
1427     }
1428 
1429     /**
1430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1431      * Can only be called by the current owner.
1432      */
1433     function transferOwnership(address newOwner) public virtual onlyOwner {
1434         require(newOwner != address(0), "Ownable: new owner is the zero address");
1435         _transferOwnership(newOwner);
1436     }
1437 
1438     /**
1439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1440      * Internal function without access restriction.
1441      */
1442     function _transferOwnership(address newOwner) internal virtual {
1443         address oldOwner = _owner;
1444         _owner = newOwner;
1445         emit OwnershipTransferred(oldOwner, newOwner);
1446     }
1447 }
1448 
1449 // File: DGClubCard.sol
1450 
1451 
1452 pragma solidity ^0.8.0;
1453 
1454 
1455 
1456 
1457 
1458 
1459 abstract contract ENS {
1460     function resolver(bytes32 node) public view virtual returns (Resolver);
1461 }
1462 
1463 abstract contract Resolver {
1464     function addr(bytes32 node) public view virtual returns (address);
1465 }
1466 
1467 /// @title Disgusting Gentlemen Club Card
1468 /// @author Aidan Fu
1469 /// @notice Manages minting of the Disgusting Gentlemen Club Card NFT's
1470 contract DGClubCard is Ownable, ERC721, Pausable {
1471     string public baseUri;
1472     uint256 public maxMintAmt = 1000;
1473     address public ENSAddress = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
1474 
1475     using Counters for Counters.Counter;
1476     Counters.Counter private _tokenIdCounter; // token id will range from 0-999 inclusive
1477     ENS ens = ENS(ENSAddress);
1478 
1479     constructor() ERC721("DisgustingGentlemenClubCard", "DGCC") {}
1480 
1481     modifier callerIsUser() {
1482         require(tx.origin == msg.sender, "The caller is another contract");
1483         _;
1484     }
1485 
1486     modifier canMint(address minter) {
1487         require(balanceOf(minter) == 0, "Only one DG Club Card per owner!");
1488         require(
1489             _tokenIdCounter.current() < maxMintAmt,
1490             "No more mints can be made"
1491         );
1492         _;
1493     }
1494 
1495     function setENSAddress(address _ENSAddress) external onlyOwner {
1496         ENSAddress = _ENSAddress;
1497     }
1498 
1499     function setMaxMintAmt(uint256 _maxMintAmt) external onlyOwner {
1500         maxMintAmt = _maxMintAmt;
1501     }
1502 
1503     function setBaseURI(string memory _baseUri) external onlyOwner {
1504         baseUri = _baseUri;
1505     }
1506 
1507     function airDrop(address addressToAirDrop)
1508         external
1509         onlyOwner
1510         canMint(addressToAirDrop)
1511     {
1512         uint256 tokenId = _tokenIdCounter.current();
1513         _tokenIdCounter.increment();
1514         _safeMint(addressToAirDrop, tokenId);
1515     }
1516 
1517     function publicMint(bytes32 node)
1518         external
1519         callerIsUser
1520         canMint(msg.sender)
1521         whenNotPaused
1522     {
1523         require(
1524             resolve(node) == msg.sender,
1525             "You must have a valid ENS domain to mint"
1526         );
1527         uint256 tokenId = _tokenIdCounter.current();
1528         _tokenIdCounter.increment();
1529         _safeMint(msg.sender, tokenId);
1530     }
1531 
1532     function withdraw() external {
1533         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1534         require(os);
1535     }
1536 
1537     function pause() external onlyOwner {
1538         _pause();
1539     }
1540 
1541     function unpause() external onlyOwner {
1542         _unpause();
1543     }
1544 
1545     function _baseURI() internal view override returns (string memory) {
1546         return baseUri;
1547     }
1548 
1549     function resolve(bytes32 node) public view returns (address) {
1550         Resolver resolver = ens.resolver(node);
1551         return resolver.addr(node);
1552     }
1553 }