1 /**
2 ██████████████████████████████████████████████████████████████████████████████████████████
3 ██████████████████████████████████████████████████████████████████████████████████████████
4 ██████████████████████████████████████████████████████████████████████████████████████████
5 ██████████████████████████████████████████████████████████████████████████████████████████
6 ██████████████████████████████████████████████████████████████████████████████████████████
7 ██████████████████████████████████████████████████████████████████████████████████████████
8 ██████████████████████████████████████████████████████████████████████████████████████████
9 ██████████████████████████████████████████████████████████████████████████████████████████
10 ██████████████████████████████████████████████████████████████████████████████████████████
11 ██████████████████████████████████████████████████████████████████████████████████████████
12 ██████████████████████████████████████████████████████████████████████████████████████████
13 ██████████████████████████████████████████████████████████████████████████████████████████
14 ██████████████████████████████████████████████████████████████████████████████████████████
15 ████████████████████████████▓▓███████████████████████████████▒████████████████████████████
16 ████████████████████████████░░██████████████████████████████▒░████████████████████████████
17 ████████████████████████████▒░░████████████████████████████▒░░████████████████████████████
18 ████████████████████████████▓░░░▒▓██████████████████████▓▒░░░▒████████████████████████████
19 ██████████████████████████████░▒▒░░▒▓██▓██████████▓██▓▒░░▒▓░▓█████████████████████████████
20 ████████████████████████████▓██▒███░░░▓████████████▓░░▒▓██▓▓██████████████████████████████
21 ███████████████████████████████▓▒██▓█▒░▒███▓██████▒░░█▓██▓▒███████████████████████████████
22 ███████████████████████████▓████▓▒▓████░░▒▓▓███▓▒░░▓███▓▒▓███████████████▓████████████████
23 ██████████████████████▓████████████▓▓▓▓▓▒▒▓▓███▓▒▒▓▓▓▓▓████████████▓██████████████████████
24 █████████████████████▓▓██████████████████▓██████▓██████████████████▓▓███████▓█████████████
25 ███████████████████▓▓█▓████████████████████▓██▓▓███████████████████▓█▓▓███████████████████
26 ███████████████████████▓█████████████████████▓█████████████████████▓██████████████████████
27 ███████████████████████▒██████████████████████████████████████████▒███████████████████████
28 ███████████████████████▓██████████████████████████████████████████▒███████████████████████
29 ████████████████████████▓█████████████████████████████████████████▓███████████████████████
30 ████████████████████████▓████████████████████████████████████████▓████████████████████████
31 ████████████████████████▓████████████████████████████████████████▓████████████████████████
32 █████████████████████████▓██████████████████████████████████████▒█████████████████████████
33 ██████████████████████████▓▓███████████████████████████████████▓██████████████████████████
34 ████████████████████████████▓▓██████████████████████████████▓▓████████████████████████████
35 ███████████████████████████████▓▓███▓███████▓▓███████▓███▓▓███████████████████████████████
36 ██████████████████████████████████████████▓█▒▒███▓████████████████████████████████████████
37 ██████████████████████████████████████████████████████████████████████████████████████████
38 ██████████████████████████████████████████████████████████████████████████████████████████
39 ██████████████████████████████████████████████████████████████████████████████████████████
40 ██████████████████████████████████████████████████████████████████████████████████████████
41 ██████████████████████████████████████████████████████████████████████████████████████████
42 ██████████████████████████████████████████████████████████████████████████████████████████
43 ██████████████████████████████████████████████████████████████████████████████████████████
44 ██████████████████████████████████████████████████████████████████████████████████████████
45 ██████████████████████████████████████████████████████████████████████████████████████████
46 ██████████████████████████████████████████████████████████████████████████████████████████
47 
48  */
49 
50 // SPDX-License-Identifier: MIT
51 
52 // File: @openzeppelin/contracts/utils/Strings.sol
53 
54 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev String operations.
60  */
61 library Strings {
62     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
66      */
67     function toString(uint256 value) internal pure returns (string memory) {
68         // Inspired by OraclizeAPI's implementation - MIT licence
69         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
70 
71         if (value == 0) {
72             return "0";
73         }
74         uint256 temp = value;
75         uint256 digits;
76         while (temp != 0) {
77             digits++;
78             temp /= 10;
79         }
80         bytes memory buffer = new bytes(digits);
81         while (value != 0) {
82             digits -= 1;
83             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
84             value /= 10;
85         }
86         return string(buffer);
87     }
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
91      */
92     function toHexString(uint256 value) internal pure returns (string memory) {
93         if (value == 0) {
94             return "0x00";
95         }
96         uint256 temp = value;
97         uint256 length = 0;
98         while (temp != 0) {
99             length++;
100             temp >>= 8;
101         }
102         return toHexString(value, length);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
107      */
108     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
109         bytes memory buffer = new bytes(2 * length + 2);
110         buffer[0] = "0";
111         buffer[1] = "x";
112         for (uint256 i = 2 * length + 1; i > 1; --i) {
113             buffer[i] = _HEX_SYMBOLS[value & 0xf];
114             value >>= 4;
115         }
116         require(value == 0, "Strings: hex length insufficient");
117         return string(buffer);
118     }
119 }
120 
121 // File: @openzeppelin/contracts/utils/Context.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev Provides information about the current execution context, including the
130  * sender of the transaction and its data. While these are generally available
131  * via msg.sender and msg.data, they should not be accessed in such a direct
132  * manner, since when dealing with meta-transactions the account sending and
133  * paying for execution may not be the actual sender (as far as an application
134  * is concerned).
135  *
136  * This contract is only required for intermediate, library-like contracts.
137  */
138 abstract contract Context {
139     function _msgSender() internal view virtual returns (address) {
140         return msg.sender;
141     }
142 
143     function _msgData() internal view virtual returns (bytes calldata) {
144         return msg.data;
145     }
146 }
147 
148 // File: @openzeppelin/contracts/utils/Address.sol
149 
150 
151 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
152 
153 pragma solidity ^0.8.1;
154 
155 /**
156  * @dev Collection of functions related to the address type
157  */
158 library Address {
159     /**
160      * @dev Returns true if `account` is a contract.
161      *
162      * [IMPORTANT]
163      * ====
164      * It is unsafe to assume that an address for which this function returns
165      * false is an externally-owned account (EOA) and not a contract.
166      *
167      * Among others, `isContract` will return false for the following
168      * types of addresses:
169      *
170      *  - an externally-owned account
171      *  - a contract in construction
172      *  - an address where a contract will be created
173      *  - an address where a contract lived, but was destroyed
174      * ====
175      *
176      * [IMPORTANT]
177      * ====
178      * You shouldn't rely on `isContract` to protect against flash loan attacks!
179      *
180      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
181      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
182      * constructor.
183      * ====
184      */
185     function isContract(address account) internal view returns (bool) {
186         // This method relies on extcodesize/address.code.length, which returns 0
187         // for contracts in construction, since the code is only stored at the end
188         // of the constructor execution.
189 
190         return account.code.length > 0;
191     }
192 
193     /**
194      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
195      * `recipient`, forwarding all available gas and reverting on errors.
196      *
197      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
198      * of certain opcodes, possibly making contracts go over the 2300 gas limit
199      * imposed by `transfer`, making them unable to receive funds via
200      * `transfer`. {sendValue} removes this limitation.
201      *
202      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
203      *
204      * IMPORTANT: because control is transferred to `recipient`, care must be
205      * taken to not create reentrancy vulnerabilities. Consider using
206      * {ReentrancyGuard} or the
207      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
208      */
209     function sendValue(address payable recipient, uint256 amount) internal {
210         require(address(this).balance >= amount, "Address: insufficient balance");
211 
212         (bool success, ) = recipient.call{value: amount}("");
213         require(success, "Address: unable to send value, recipient may have reverted");
214     }
215 
216     /**
217      * @dev Performs a Solidity function call using a low level `call`. A
218      * plain `call` is an unsafe replacement for a function call: use this
219      * function instead.
220      *
221      * If `target` reverts with a revert reason, it is bubbled up by this
222      * function (like regular Solidity function calls).
223      *
224      * Returns the raw returned data. To convert to the expected return value,
225      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
226      *
227      * Requirements:
228      *
229      * - `target` must be a contract.
230      * - calling `target` with `data` must not revert.
231      *
232      * _Available since v3.1._
233      */
234     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
235         return functionCall(target, data, "Address: low-level call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
240      * `errorMessage` as a fallback revert reason when `target` reverts.
241      *
242      * _Available since v3.1._
243      */
244     function functionCall(
245         address target,
246         bytes memory data,
247         string memory errorMessage
248     ) internal returns (bytes memory) {
249         return functionCallWithValue(target, data, 0, errorMessage);
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254      * but also transferring `value` wei to `target`.
255      *
256      * Requirements:
257      *
258      * - the calling contract must have an ETH balance of at least `value`.
259      * - the called Solidity function must be `payable`.
260      *
261      * _Available since v3.1._
262      */
263     function functionCallWithValue(
264         address target,
265         bytes memory data,
266         uint256 value
267     ) internal returns (bytes memory) {
268         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
273      * with `errorMessage` as a fallback revert reason when `target` reverts.
274      *
275      * _Available since v3.1._
276      */
277     function functionCallWithValue(
278         address target,
279         bytes memory data,
280         uint256 value,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         require(address(this).balance >= value, "Address: insufficient balance for call");
284         require(isContract(target), "Address: call to non-contract");
285 
286         (bool success, bytes memory returndata) = target.call{value: value}(data);
287         return verifyCallResult(success, returndata, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but performing a static call.
293      *
294      * _Available since v3.3._
295      */
296     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
297         return functionStaticCall(target, data, "Address: low-level static call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
302      * but performing a static call.
303      *
304      * _Available since v3.3._
305      */
306     function functionStaticCall(
307         address target,
308         bytes memory data,
309         string memory errorMessage
310     ) internal view returns (bytes memory) {
311         require(isContract(target), "Address: static call to non-contract");
312 
313         (bool success, bytes memory returndata) = target.staticcall(data);
314         return verifyCallResult(success, returndata, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but performing a delegate call.
320      *
321      * _Available since v3.4._
322      */
323     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
329      * but performing a delegate call.
330      *
331      * _Available since v3.4._
332      */
333     function functionDelegateCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         require(isContract(target), "Address: delegate call to non-contract");
339 
340         (bool success, bytes memory returndata) = target.delegatecall(data);
341         return verifyCallResult(success, returndata, errorMessage);
342     }
343 
344     /**
345      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
346      * revert reason using the provided one.
347      *
348      * _Available since v4.3._
349      */
350     function verifyCallResult(
351         bool success,
352         bytes memory returndata,
353         string memory errorMessage
354     ) internal pure returns (bytes memory) {
355         if (success) {
356             return returndata;
357         } else {
358             // Look for revert reason and bubble it up if present
359             if (returndata.length > 0) {
360                 // The easiest way to bubble the revert reason is using memory via assembly
361 
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @title ERC721 token receiver interface
382  * @dev Interface for any contract that wants to support safeTransfers
383  * from ERC721 asset contracts.
384  */
385 interface IERC721Receiver {
386     /**
387      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
388      * by `operator` from `from`, this function is called.
389      *
390      * It must return its Solidity selector to confirm the token transfer.
391      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
392      *
393      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
394      */
395     function onERC721Received(
396         address operator,
397         address from,
398         uint256 tokenId,
399         bytes calldata data
400     ) external returns (bytes4);
401 }
402 
403 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
404 
405 
406 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 /**
411  * @dev Interface of the ERC165 standard, as defined in the
412  * https://eips.ethereum.org/EIPS/eip-165[EIP].
413  *
414  * Implementers can declare support of contract interfaces, which can then be
415  * queried by others ({ERC165Checker}).
416  *
417  * For an implementation, see {ERC165}.
418  */
419 interface IERC165 {
420     /**
421      * @dev Returns true if this contract implements the interface defined by
422      * `interfaceId`. See the corresponding
423      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
424      * to learn more about how these ids are created.
425      *
426      * This function call must use less than 30 000 gas.
427      */
428     function supportsInterface(bytes4 interfaceId) external view returns (bool);
429 }
430 
431 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 
439 /**
440  * @dev Implementation of the {IERC165} interface.
441  *
442  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
443  * for the additional interface id that will be supported. For example:
444  *
445  * ```solidity
446  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
447  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
448  * }
449  * ```
450  *
451  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
452  */
453 abstract contract ERC165 is IERC165 {
454     /**
455      * @dev See {IERC165-supportsInterface}.
456      */
457     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
458         return interfaceId == type(IERC165).interfaceId;
459     }
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Required interface of an ERC721 compliant contract.
472  */
473 interface IERC721 is IERC165 {
474     /**
475      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
476      */
477     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
478 
479     /**
480      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
481      */
482     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
483 
484     /**
485      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
486      */
487     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
488 
489     /**
490      * @dev Returns the number of tokens in ``owner``'s account.
491      */
492     function balanceOf(address owner) external view returns (uint256 balance);
493 
494     /**
495      * @dev Returns the owner of the `tokenId` token.
496      *
497      * Requirements:
498      *
499      * - `tokenId` must exist.
500      */
501     function ownerOf(uint256 tokenId) external view returns (address owner);
502 
503     /**
504      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
505      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId
521     ) external;
522 
523     /**
524      * @dev Transfers `tokenId` token from `from` to `to`.
525      *
526      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
527      *
528      * Requirements:
529      *
530      * - `from` cannot be the zero address.
531      * - `to` cannot be the zero address.
532      * - `tokenId` token must be owned by `from`.
533      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
534      *
535      * Emits a {Transfer} event.
536      */
537     function transferFrom(
538         address from,
539         address to,
540         uint256 tokenId
541     ) external;
542 
543     /**
544      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
545      * The approval is cleared when the token is transferred.
546      *
547      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
548      *
549      * Requirements:
550      *
551      * - The caller must own the token or be an approved operator.
552      * - `tokenId` must exist.
553      *
554      * Emits an {Approval} event.
555      */
556     function approve(address to, uint256 tokenId) external;
557 
558     /**
559      * @dev Returns the account approved for `tokenId` token.
560      *
561      * Requirements:
562      *
563      * - `tokenId` must exist.
564      */
565     function getApproved(uint256 tokenId) external view returns (address operator);
566 
567     /**
568      * @dev Approve or remove `operator` as an operator for the caller.
569      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
570      *
571      * Requirements:
572      *
573      * - The `operator` cannot be the caller.
574      *
575      * Emits an {ApprovalForAll} event.
576      */
577     function setApprovalForAll(address operator, bool _approved) external;
578 
579     /**
580      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
581      *
582      * See {setApprovalForAll}
583      */
584     function isApprovedForAll(address owner, address operator) external view returns (bool);
585 
586     /**
587      * @dev Safely transfers `tokenId` token from `from` to `to`.
588      *
589      * Requirements:
590      *
591      * - `from` cannot be the zero address.
592      * - `to` cannot be the zero address.
593      * - `tokenId` token must exist and be owned by `from`.
594      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
595      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
596      *
597      * Emits a {Transfer} event.
598      */
599     function safeTransferFrom(
600         address from,
601         address to,
602         uint256 tokenId,
603         bytes calldata data
604     ) external;
605 }
606 
607 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 
615 /**
616  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
617  * @dev See https://eips.ethereum.org/EIPS/eip-721
618  */
619 interface IERC721Metadata is IERC721 {
620     /**
621      * @dev Returns the token collection name.
622      */
623     function name() external view returns (string memory);
624 
625     /**
626      * @dev Returns the token collection symbol.
627      */
628     function symbol() external view returns (string memory);
629 
630     /**
631      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
632      */
633     function tokenURI(uint256 tokenId) external view returns (string memory);
634 }
635 
636 // File: contracts/new.sol
637 
638 
639 
640 
641 pragma solidity ^0.8.4;
642 
643 
644 
645 
646 
647 
648 
649 
650 error ApprovalCallerNotOwnerNorApproved();
651 error ApprovalQueryForNonexistentToken();
652 error ApproveToCaller();
653 error ApprovalToCurrentOwner();
654 error BalanceQueryForZeroAddress();
655 error MintToZeroAddress();
656 error MintZeroQuantity();
657 error OwnerQueryForNonexistentToken();
658 error TransferCallerNotOwnerNorApproved();
659 error TransferFromIncorrectOwner();
660 error TransferToNonERC721ReceiverImplementer();
661 error TransferToZeroAddress();
662 error URIQueryForNonexistentToken();
663 
664 /**
665  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
666  * the Metadata extension. Built to optimize for lower gas during batch mints.
667  *
668  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
669  *
670  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
671  *
672  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
673  */
674 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
675     using Address for address;
676     using Strings for uint256;
677 
678     // Compiler will pack this into a single 256bit word.
679     struct TokenOwnership {
680         // The address of the owner.
681         address addr;
682         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
683         uint64 startTimestamp;
684         // Whether the token has been burned.
685         bool burned;
686     }
687 
688     // Compiler will pack this into a single 256bit word.
689     struct AddressData {
690         // Realistically, 2**64-1 is more than enough.
691         uint64 balance;
692         // Keeps track of mint count with minimal overhead for tokenomics.
693         uint64 numberMinted;
694         // Keeps track of burn count with minimal overhead for tokenomics.
695         uint64 numberBurned;
696         // For miscellaneous variable(s) pertaining to the address
697         // (e.g. number of whitelist mint slots used).
698         // If there are multiple variables, please pack them into a uint64.
699         uint64 aux;
700     }
701 
702     // The tokenId of the next token to be minted.
703     uint256 internal _currentIndex;
704 
705     // The number of tokens burned.
706     uint256 internal _burnCounter;
707 
708     // Token name
709     string private _name;
710 
711     // Token symbol
712     string private _symbol;
713 
714     // Mapping from token ID to ownership details
715     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
716     mapping(uint256 => TokenOwnership) internal _ownerships;
717 
718     // Mapping owner address to address data
719     mapping(address => AddressData) private _addressData;
720 
721     // Mapping from token ID to approved address
722     mapping(uint256 => address) private _tokenApprovals;
723 
724     // Mapping from owner to operator approvals
725     mapping(address => mapping(address => bool)) private _operatorApprovals;
726 
727     constructor(string memory name_, string memory symbol_) {
728         _name = name_;
729         _symbol = symbol_;
730         _currentIndex = _startTokenId();
731     }
732 
733     /**
734      * To change the starting tokenId, please override this function.
735      */
736     function _startTokenId() internal view virtual returns (uint256) {
737         return 0;
738     }
739 
740     /**
741      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
742      */
743     function totalSupply() public view returns (uint256) {
744         // Counter underflow is impossible as _burnCounter cannot be incremented
745         // more than _currentIndex - _startTokenId() times
746         unchecked {
747             return _currentIndex - _burnCounter - _startTokenId();
748         }
749     }
750 
751     /**
752      * Returns the total amount of tokens minted in the contract.
753      */
754     function _totalMinted() internal view returns (uint256) {
755         // Counter underflow is impossible as _currentIndex does not decrement,
756         // and it is initialized to _startTokenId()
757         unchecked {
758             return _currentIndex - _startTokenId();
759         }
760     }
761 
762     /**
763      * @dev See {IERC165-supportsInterface}.
764      */
765     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
766         return
767             interfaceId == type(IERC721).interfaceId ||
768             interfaceId == type(IERC721Metadata).interfaceId ||
769             super.supportsInterface(interfaceId);
770     }
771 
772     /**
773      * @dev See {IERC721-balanceOf}.
774      */
775     function balanceOf(address owner) public view override returns (uint256) {
776         if (owner == address(0)) revert BalanceQueryForZeroAddress();
777         return uint256(_addressData[owner].balance);
778     }
779 
780     /**
781      * Returns the number of tokens minted by `owner`.
782      */
783     function _numberMinted(address owner) internal view returns (uint256) {
784         return uint256(_addressData[owner].numberMinted);
785     }
786 
787     /**
788      * Returns the number of tokens burned by or on behalf of `owner`.
789      */
790     function _numberBurned(address owner) internal view returns (uint256) {
791         return uint256(_addressData[owner].numberBurned);
792     }
793 
794     /**
795      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
796      */
797     function _getAux(address owner) internal view returns (uint64) {
798         return _addressData[owner].aux;
799     }
800 
801     /**
802      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
803      * If there are multiple variables, please pack them into a uint64.
804      */
805     function _setAux(address owner, uint64 aux) internal {
806         _addressData[owner].aux = aux;
807     }
808 
809     /**
810      * Gas spent here starts off proportional to the maximum mint batch size.
811      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
812      */
813     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
814         uint256 curr = tokenId;
815 
816         unchecked {
817             if (_startTokenId() <= curr && curr < _currentIndex) {
818                 TokenOwnership memory ownership = _ownerships[curr];
819                 if (!ownership.burned) {
820                     if (ownership.addr != address(0)) {
821                         return ownership;
822                     }
823                     // Invariant:
824                     // There will always be an ownership that has an address and is not burned
825                     // before an ownership that does not have an address and is not burned.
826                     // Hence, curr will not underflow.
827                     while (true) {
828                         curr--;
829                         ownership = _ownerships[curr];
830                         if (ownership.addr != address(0)) {
831                             return ownership;
832                         }
833                     }
834                 }
835             }
836         }
837         revert OwnerQueryForNonexistentToken();
838     }
839 
840     /**
841      * @dev See {IERC721-ownerOf}.
842      */
843     function ownerOf(uint256 tokenId) public view override returns (address) {
844         return _ownershipOf(tokenId).addr;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-name}.
849      */
850     function name() public view virtual override returns (string memory) {
851         return _name;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-symbol}.
856      */
857     function symbol() public view virtual override returns (string memory) {
858         return _symbol;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-tokenURI}.
863      */
864     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
865         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
866 
867         string memory baseURI = _baseURI();
868         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
869     }
870 
871     /**
872      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
873      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
874      * by default, can be overriden in child contracts.
875      */
876     function _baseURI() internal view virtual returns (string memory) {
877         return '';
878     }
879 
880     /**
881      * @dev See {IERC721-approve}.
882      */
883     function approve(address to, uint256 tokenId) public override {
884         address owner = ERC721A.ownerOf(tokenId);
885         if (to == owner) revert ApprovalToCurrentOwner();
886 
887         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
888             revert ApprovalCallerNotOwnerNorApproved();
889         }
890 
891         _approve(to, tokenId, owner);
892     }
893 
894     /**
895      * @dev See {IERC721-getApproved}.
896      */
897     function getApproved(uint256 tokenId) public view override returns (address) {
898         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
899 
900         return _tokenApprovals[tokenId];
901     }
902 
903     /**
904      * @dev See {IERC721-setApprovalForAll}.
905      */
906     function setApprovalForAll(address operator, bool approved) public virtual override {
907         if (operator == _msgSender()) revert ApproveToCaller();
908 
909         _operatorApprovals[_msgSender()][operator] = approved;
910         emit ApprovalForAll(_msgSender(), operator, approved);
911     }
912 
913     /**
914      * @dev See {IERC721-isApprovedForAll}.
915      */
916     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
917         return _operatorApprovals[owner][operator];
918     }
919 
920     /**
921      * @dev See {IERC721-transferFrom}.
922      */
923     function transferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public virtual override {
928         _transfer(from, to, tokenId);
929     }
930 
931     /**
932      * @dev See {IERC721-safeTransferFrom}.
933      */
934     function safeTransferFrom(
935         address from,
936         address to,
937         uint256 tokenId
938     ) public virtual override {
939         safeTransferFrom(from, to, tokenId, '');
940     }
941 
942     /**
943      * @dev See {IERC721-safeTransferFrom}.
944      */
945     function safeTransferFrom(
946         address from,
947         address to,
948         uint256 tokenId,
949         bytes memory _data
950     ) public virtual override {
951         _transfer(from, to, tokenId);
952         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
953             revert TransferToNonERC721ReceiverImplementer();
954         }
955     }
956 
957     /**
958      * @dev Returns whether `tokenId` exists.
959      *
960      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
961      *
962      * Tokens start existing when they are minted (`_mint`),
963      */
964     function _exists(uint256 tokenId) internal view returns (bool) {
965         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
966             !_ownerships[tokenId].burned;
967     }
968 
969     function _safeMint(address to, uint256 quantity) internal {
970         _safeMint(to, quantity, '');
971     }
972 
973     /**
974      * @dev Safely mints `quantity` tokens and transfers them to `to`.
975      *
976      * Requirements:
977      *
978      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
979      * - `quantity` must be greater than 0.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _safeMint(
984         address to,
985         uint256 quantity,
986         bytes memory _data
987     ) internal {
988         _mint(to, quantity, _data, true);
989     }
990 
991     /**
992      * @dev Mints `quantity` tokens and transfers them to `to`.
993      *
994      * Requirements:
995      *
996      * - `to` cannot be the zero address.
997      * - `quantity` must be greater than 0.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _mint(
1002         address to,
1003         uint256 quantity,
1004         bytes memory _data,
1005         bool safe
1006     ) internal {
1007         uint256 startTokenId = _currentIndex;
1008         if (to == address(0)) revert MintToZeroAddress();
1009         if (quantity == 0) revert MintZeroQuantity();
1010 
1011         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1012 
1013         // Overflows are incredibly unrealistic.
1014         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1015         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1016         unchecked {
1017             _addressData[to].balance += uint64(quantity);
1018             _addressData[to].numberMinted += uint64(quantity);
1019 
1020             _ownerships[startTokenId].addr = to;
1021             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1022 
1023             uint256 updatedIndex = startTokenId;
1024             uint256 end = updatedIndex + quantity;
1025 
1026             if (safe && to.isContract()) {
1027                 do {
1028                     emit Transfer(address(0), to, updatedIndex);
1029                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1030                         revert TransferToNonERC721ReceiverImplementer();
1031                     }
1032                 } while (updatedIndex != end);
1033                 // Reentrancy protection
1034                 if (_currentIndex != startTokenId) revert();
1035             } else {
1036                 do {
1037                     emit Transfer(address(0), to, updatedIndex++);
1038                 } while (updatedIndex != end);
1039             }
1040             _currentIndex = updatedIndex;
1041         }
1042         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1043     }
1044 
1045     /**
1046      * @dev Transfers `tokenId` from `from` to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must be owned by `from`.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _transfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) private {
1060         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1061 
1062         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1063 
1064         bool isApprovedOrOwner = (_msgSender() == from ||
1065             isApprovedForAll(from, _msgSender()) ||
1066             getApproved(tokenId) == _msgSender());
1067 
1068         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1069         if (to == address(0)) revert TransferToZeroAddress();
1070 
1071         _beforeTokenTransfers(from, to, tokenId, 1);
1072 
1073         // Clear approvals from the previous owner
1074         _approve(address(0), tokenId, from);
1075 
1076         // Underflow of the sender's balance is impossible because we check for
1077         // ownership above and the recipient's balance can't realistically overflow.
1078         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1079         unchecked {
1080             _addressData[from].balance -= 1;
1081             _addressData[to].balance += 1;
1082 
1083             TokenOwnership storage currSlot = _ownerships[tokenId];
1084             currSlot.addr = to;
1085             currSlot.startTimestamp = uint64(block.timestamp);
1086 
1087             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1088             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1089             uint256 nextTokenId = tokenId + 1;
1090             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1091             if (nextSlot.addr == address(0)) {
1092                 // This will suffice for checking _exists(nextTokenId),
1093                 // as a burned slot cannot contain the zero address.
1094                 if (nextTokenId != _currentIndex) {
1095                     nextSlot.addr = from;
1096                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1097                 }
1098             }
1099         }
1100 
1101         emit Transfer(from, to, tokenId);
1102         _afterTokenTransfers(from, to, tokenId, 1);
1103     }
1104 
1105     /**
1106      * @dev This is equivalent to _burn(tokenId, false)
1107      */
1108     function _burn(uint256 tokenId) internal virtual {
1109         _burn(tokenId, false);
1110     }
1111 
1112     /**
1113      * @dev Destroys `tokenId`.
1114      * The approval is cleared when the token is burned.
1115      *
1116      * Requirements:
1117      *
1118      * - `tokenId` must exist.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1123         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1124 
1125         address from = prevOwnership.addr;
1126 
1127         if (approvalCheck) {
1128             bool isApprovedOrOwner = (_msgSender() == from ||
1129                 isApprovedForAll(from, _msgSender()) ||
1130                 getApproved(tokenId) == _msgSender());
1131 
1132             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1133         }
1134 
1135         _beforeTokenTransfers(from, address(0), tokenId, 1);
1136 
1137         // Clear approvals from the previous owner
1138         _approve(address(0), tokenId, from);
1139 
1140         // Underflow of the sender's balance is impossible because we check for
1141         // ownership above and the recipient's balance can't realistically overflow.
1142         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1143         unchecked {
1144             AddressData storage addressData = _addressData[from];
1145             addressData.balance -= 1;
1146             addressData.numberBurned += 1;
1147 
1148             // Keep track of who burned the token, and the timestamp of burning.
1149             TokenOwnership storage currSlot = _ownerships[tokenId];
1150             currSlot.addr = from;
1151             currSlot.startTimestamp = uint64(block.timestamp);
1152             currSlot.burned = true;
1153 
1154             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1155             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1156             uint256 nextTokenId = tokenId + 1;
1157             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1158             if (nextSlot.addr == address(0)) {
1159                 // This will suffice for checking _exists(nextTokenId),
1160                 // as a burned slot cannot contain the zero address.
1161                 if (nextTokenId != _currentIndex) {
1162                     nextSlot.addr = from;
1163                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1164                 }
1165             }
1166         }
1167 
1168         emit Transfer(from, address(0), tokenId);
1169         _afterTokenTransfers(from, address(0), tokenId, 1);
1170 
1171         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1172         unchecked {
1173             _burnCounter++;
1174         }
1175     }
1176 
1177     /**
1178      * @dev Approve `to` to operate on `tokenId`
1179      *
1180      * Emits a {Approval} event.
1181      */
1182     function _approve(
1183         address to,
1184         uint256 tokenId,
1185         address owner
1186     ) private {
1187         _tokenApprovals[tokenId] = to;
1188         emit Approval(owner, to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1193      *
1194      * @param from address representing the previous owner of the given token ID
1195      * @param to target address that will receive the tokens
1196      * @param tokenId uint256 ID of the token to be transferred
1197      * @param _data bytes optional data to send along with the call
1198      * @return bool whether the call correctly returned the expected magic value
1199      */
1200     function _checkContractOnERC721Received(
1201         address from,
1202         address to,
1203         uint256 tokenId,
1204         bytes memory _data
1205     ) private returns (bool) {
1206         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1207             return retval == IERC721Receiver(to).onERC721Received.selector;
1208         } catch (bytes memory reason) {
1209             if (reason.length == 0) {
1210                 revert TransferToNonERC721ReceiverImplementer();
1211             } else {
1212                 assembly {
1213                     revert(add(32, reason), mload(reason))
1214                 }
1215             }
1216         }
1217     }
1218 
1219     /**
1220      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1221      * And also called before burning one token.
1222      *
1223      * startTokenId - the first token id to be transferred
1224      * quantity - the amount to be transferred
1225      *
1226      * Calling conditions:
1227      *
1228      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1229      * transferred to `to`.
1230      * - When `from` is zero, `tokenId` will be minted for `to`.
1231      * - When `to` is zero, `tokenId` will be burned by `from`.
1232      * - `from` and `to` are never both zero.
1233      */
1234     function _beforeTokenTransfers(
1235         address from,
1236         address to,
1237         uint256 startTokenId,
1238         uint256 quantity
1239     ) internal virtual {}
1240 
1241     /**
1242      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1243      * minting.
1244      * And also called after one token has been burned.
1245      *
1246      * startTokenId - the first token id to be transferred
1247      * quantity - the amount to be transferred
1248      *
1249      * Calling conditions:
1250      *
1251      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1252      * transferred to `to`.
1253      * - When `from` is zero, `tokenId` has been minted for `to`.
1254      * - When `to` is zero, `tokenId` has been burned by `from`.
1255      * - `from` and `to` are never both zero.
1256      */
1257     function _afterTokenTransfers(
1258         address from,
1259         address to,
1260         uint256 startTokenId,
1261         uint256 quantity
1262     ) internal virtual {}
1263 }
1264 
1265 abstract contract Ownable is Context {
1266     address private _owner;
1267 
1268     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1269 
1270     /**
1271      * @dev Initializes the contract setting the deployer as the initial owner.
1272      */
1273     constructor() {
1274         _transferOwnership(_msgSender());
1275     }
1276 
1277     /**
1278      * @dev Returns the address of the current owner.
1279      */
1280     function owner() public view virtual returns (address) {
1281         return _owner;
1282     }
1283 
1284     /**
1285      * @dev Throws if called by any account other than the owner.
1286      */
1287     modifier onlyOwner() {
1288         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1289         _;
1290     }
1291 
1292     /**
1293      * @dev Leaves the contract without owner. It will not be possible to call
1294      * `onlyOwner` functions anymore. Can only be called by the current owner.
1295      *
1296      * NOTE: Renouncing ownership will leave the contract without an owner,
1297      * thereby removing any functionality that is only available to the owner.
1298      */
1299     function renounceOwnership() public virtual onlyOwner {
1300         _transferOwnership(address(0));
1301     }
1302 
1303     /**
1304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1305      * Can only be called by the current owner.
1306      */
1307     function transferOwnership(address newOwner) public virtual onlyOwner {
1308         require(newOwner != address(0), "Ownable: new owner is the zero address");
1309         _transferOwnership(newOwner);
1310     }
1311 
1312     /**
1313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1314      * Internal function without access restriction.
1315      */
1316     function _transferOwnership(address newOwner) internal virtual {
1317         address oldOwner = _owner;
1318         _owner = newOwner;
1319         emit OwnershipTransferred(oldOwner, newOwner);
1320     }
1321 }
1322 pragma solidity ^0.8.13;
1323 
1324 interface IOperatorFilterRegistry {
1325     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1326     function register(address registrant) external;
1327     function registerAndSubscribe(address registrant, address subscription) external;
1328     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1329     function updateOperator(address registrant, address operator, bool filtered) external;
1330     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1331     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1332     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1333     function subscribe(address registrant, address registrantToSubscribe) external;
1334     function unsubscribe(address registrant, bool copyExistingEntries) external;
1335     function subscriptionOf(address addr) external returns (address registrant);
1336     function subscribers(address registrant) external returns (address[] memory);
1337     function subscriberAt(address registrant, uint256 index) external returns (address);
1338     function copyEntriesOf(address registrant, address registrantToCopy) external;
1339     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1340     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1341     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1342     function filteredOperators(address addr) external returns (address[] memory);
1343     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1344     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1345     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1346     function isRegistered(address addr) external returns (bool);
1347     function codeHashOf(address addr) external returns (bytes32);
1348 }
1349 pragma solidity ^0.8.13;
1350 
1351 
1352 
1353 abstract contract OperatorFilterer {
1354     error OperatorNotAllowed(address operator);
1355 
1356     IOperatorFilterRegistry constant operatorFilterRegistry =
1357         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1358 
1359     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1360         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1361         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1362         // order for the modifier to filter addresses.
1363         if (address(operatorFilterRegistry).code.length > 0) {
1364             if (subscribe) {
1365                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1366             } else {
1367                 if (subscriptionOrRegistrantToCopy != address(0)) {
1368                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1369                 } else {
1370                     operatorFilterRegistry.register(address(this));
1371                 }
1372             }
1373         }
1374     }
1375 
1376     modifier onlyAllowedOperator(address from) virtual {
1377         // Check registry code length to facilitate testing in environments without a deployed registry.
1378         if (address(operatorFilterRegistry).code.length > 0) {
1379             // Allow spending tokens from addresses with balance
1380             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1381             // from an EOA.
1382             if (from == msg.sender) {
1383                 _;
1384                 return;
1385             }
1386             if (
1387                 !(
1388                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1389                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1390                 )
1391             ) {
1392                 revert OperatorNotAllowed(msg.sender);
1393             }
1394         }
1395         _;
1396     }
1397 }
1398 pragma solidity ^0.8.13;
1399 
1400 
1401 
1402 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1403     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1404 
1405     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1406 }
1407     pragma solidity ^0.8.7;
1408     
1409     contract BoredGrinchmasClub is ERC721A, DefaultOperatorFilterer , Ownable {
1410     using Strings for uint256;
1411 
1412 
1413   string private uriPrefix ;
1414   string private uriSuffix = ".json";
1415   string public hiddenURL;
1416 
1417   
1418   
1419 
1420   uint256 public cost = 0.004 ether;
1421  
1422   
1423 
1424   uint16 public maxSupply = 10000;
1425   uint8 public maxMintAmountPerTx = 11;
1426     uint8 public maxFreeMintAmountPerWallet = 1;
1427                                                              
1428  
1429   bool public paused = true;
1430   bool public reveal =false;
1431 
1432    mapping (address => uint8) public NFTPerPublicAddress;
1433 
1434  
1435   
1436   
1437  
1438   
1439 
1440   constructor() ERC721A("Bored Grinchmas Club", "BGMC") {
1441   }
1442 
1443 
1444   
1445  
1446   function mint(uint8 _mintAmount) external payable  {
1447      uint16 totalSupply = uint16(totalSupply());
1448      uint8 nft = NFTPerPublicAddress[msg.sender];
1449     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1450     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1451 
1452     require(!paused, "The contract is paused!");
1453     
1454       if(nft >= maxFreeMintAmountPerWallet)
1455     {
1456     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1457     }
1458     else {
1459          uint8 costAmount = _mintAmount + nft;
1460         if(costAmount > maxFreeMintAmountPerWallet)
1461        {
1462         costAmount = costAmount - maxFreeMintAmountPerWallet;
1463         require(msg.value >= cost * costAmount, "Insufficient funds!");
1464        }
1465        
1466          
1467     }
1468     
1469 
1470 
1471     _safeMint(msg.sender , _mintAmount);
1472 
1473     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1474      
1475      delete totalSupply;
1476      delete _mintAmount;
1477   }
1478   
1479   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1480      uint16 totalSupply = uint16(totalSupply());
1481     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1482      _safeMint(_receiver , _mintAmount);
1483      delete _mintAmount;
1484      delete _receiver;
1485      delete totalSupply;
1486   }
1487 
1488   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1489      uint16 totalSupply = uint16(totalSupply());
1490      uint totalAmount =   _amountPerAddress * addresses.length;
1491     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1492      for (uint256 i = 0; i < addresses.length; i++) {
1493             _safeMint(addresses[i], _amountPerAddress);
1494         }
1495 
1496      delete _amountPerAddress;
1497      delete totalSupply;
1498   }
1499 
1500  
1501 
1502   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1503       maxSupply = _maxSupply;
1504   }
1505 
1506 
1507 
1508    
1509   function tokenURI(uint256 _tokenId)
1510     public
1511     view
1512     virtual
1513     override
1514     returns (string memory)
1515   {
1516     require(
1517       _exists(_tokenId),
1518       "ERC721Metadata: URI query for nonexistent token"
1519     );
1520     
1521   
1522 if ( reveal == false)
1523 {
1524     return hiddenURL;
1525 }
1526     
1527 
1528     string memory currentBaseURI = _baseURI();
1529     return bytes(currentBaseURI).length > 0
1530         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1531         : "";
1532   }
1533  
1534  
1535 
1536 
1537  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1538     maxFreeMintAmountPerWallet = _limit;
1539    delete _limit;
1540 
1541 }
1542 
1543     
1544   
1545 
1546   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1547     uriPrefix = _uriPrefix;
1548   }
1549    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1550     hiddenURL = _uriPrefix;
1551   }
1552 
1553 
1554   function setPaused() external onlyOwner {
1555     paused = !paused;
1556    
1557   }
1558 
1559   function setCost(uint _cost) external onlyOwner{
1560       cost = _cost;
1561 
1562   }
1563 
1564  function setRevealed() external onlyOwner{
1565      reveal = !reveal;
1566  }
1567 
1568   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1569       maxMintAmountPerTx = _maxtx;
1570 
1571   }
1572 
1573  
1574 
1575   function withdraw() external onlyOwner {
1576   uint _balance = address(this).balance;
1577      payable(msg.sender).transfer(_balance ); 
1578        
1579   }
1580 
1581 
1582   function _baseURI() internal view  override returns (string memory) {
1583     return uriPrefix;
1584   }
1585 
1586     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1587         super.transferFrom(from, to, tokenId);
1588     }
1589 
1590     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1591         super.safeTransferFrom(from, to, tokenId);
1592     }
1593 
1594     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1595         public
1596         override
1597         onlyAllowedOperator(from)
1598     {
1599         super.safeTransferFrom(from, to, tokenId, data);
1600     }
1601 }