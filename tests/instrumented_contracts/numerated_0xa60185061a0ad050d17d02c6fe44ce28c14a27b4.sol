1 /**
2 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
3 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⣤⣴⣶⣶⣶⣶⣦⣤⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿
4 ⣿⣿⣿⣿⣿⣿⣿⣿⠋⢠⣄⠙⢿⣿⣿⣿⣿⡿⠋⣠⡄⠙⣿⣿⣿⣿⣿⣿⣿⣿
5 ⣿⣿⣿⣿⣿⣿⣿⠃⢠⣿⣿⣷⣦⣌⣉⣉⣡⣴⣾⣿⣿⡄⠘⣿⣿⣿⣿⣿⣿⣿
6 ⣿⣿⣿⣿⣿⣿⠃⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠘⣿⣿⣿⣿⣿⣿
7 ⣿⣿⣿⣿⣿⡏⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⢹⣿⣿⣿⣿⣿
8 ⣿⣿⣿⣿⡿⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⢿⣿⣿⣿⣿
9 ⣿⣿⣿⣿⡇⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⢸⣿⣿⣿⣿
10 ⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⣿⣿⣿⣿
11 ⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⣿⣿⣿⣿
12 ⣿⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⣿⣿⣿⣿
13 ⣿⣿⣿⣿⠀⠀⠀⠀⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠃⠀⠀⠀⣿⣿⣿⣿
14 ⣿⣿⣿⣿⠀⠀⠀⠀⠀⢶⣶⣶⣶⣾⣿⣿⣷⣶⣶⣶⣶⠀⠀⠀⠀⠀⣿⣿⣿⣿
15 ⣿⣿⣿⣿⣿⣶⣦⣄⣀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⢀⣠⣤⣶⣿⣿⣿⣿⣿
16 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
17  */
18 // SPDX-License-Identifier: MIT
19 //Developer Info: 
20 
21 
22 
23 // File: @openzeppelin/contracts/utils/Strings.sol
24 
25 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/Context.sol
93 
94 
95 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address) {
111         return msg.sender;
112     }
113 
114     function _msgData() internal view virtual returns (bytes calldata) {
115         return msg.data;
116     }
117 }
118 
119 // File: @openzeppelin/contracts/utils/Address.sol
120 
121 
122 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
123 
124 pragma solidity ^0.8.1;
125 
126 /**
127  * @dev Collection of functions related to the address type
128  */
129 library Address {
130     /**
131      * @dev Returns true if `account` is a contract.
132      *
133      * [IMPORTANT]
134      * ====
135      * It is unsafe to assume that an address for which this function returns
136      * false is an externally-owned account (EOA) and not a contract.
137      *
138      * Among others, `isContract` will return false for the following
139      * types of addresses:
140      *
141      *  - an externally-owned account
142      *  - a contract in construction
143      *  - an address where a contract will be created
144      *  - an address where a contract lived, but was destroyed
145      * ====
146      *
147      * [IMPORTANT]
148      * ====
149      * You shouldn't rely on `isContract` to protect against flash loan attacks!
150      *
151      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
152      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
153      * constructor.
154      * ====
155      */
156     function isContract(address account) internal view returns (bool) {
157         // This method relies on extcodesize/address.code.length, which returns 0
158         // for contracts in construction, since the code is only stored at the end
159         // of the constructor execution.
160 
161         return account.code.length > 0;
162     }
163 
164     /**
165      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
166      * `recipient`, forwarding all available gas and reverting on errors.
167      *
168      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
169      * of certain opcodes, possibly making contracts go over the 2300 gas limit
170      * imposed by `transfer`, making them unable to receive funds via
171      * `transfer`. {sendValue} removes this limitation.
172      *
173      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
174      *
175      * IMPORTANT: because control is transferred to `recipient`, care must be
176      * taken to not create reentrancy vulnerabilities. Consider using
177      * {ReentrancyGuard} or the
178      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
179      */
180     function sendValue(address payable recipient, uint256 amount) internal {
181         require(address(this).balance >= amount, "Address: insufficient balance");
182 
183         (bool success, ) = recipient.call{value: amount}("");
184         require(success, "Address: unable to send value, recipient may have reverted");
185     }
186 
187     /**
188      * @dev Performs a Solidity function call using a low level `call`. A
189      * plain `call` is an unsafe replacement for a function call: use this
190      * function instead.
191      *
192      * If `target` reverts with a revert reason, it is bubbled up by this
193      * function (like regular Solidity function calls).
194      *
195      * Returns the raw returned data. To convert to the expected return value,
196      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
197      *
198      * Requirements:
199      *
200      * - `target` must be a contract.
201      * - calling `target` with `data` must not revert.
202      *
203      * _Available since v3.1._
204      */
205     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
206         return functionCall(target, data, "Address: low-level call failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
211      * `errorMessage` as a fallback revert reason when `target` reverts.
212      *
213      * _Available since v3.1._
214      */
215     function functionCall(
216         address target,
217         bytes memory data,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         return functionCallWithValue(target, data, 0, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but also transferring `value` wei to `target`.
226      *
227      * Requirements:
228      *
229      * - the calling contract must have an ETH balance of at least `value`.
230      * - the called Solidity function must be `payable`.
231      *
232      * _Available since v3.1._
233      */
234     function functionCallWithValue(
235         address target,
236         bytes memory data,
237         uint256 value
238     ) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
244      * with `errorMessage` as a fallback revert reason when `target` reverts.
245      *
246      * _Available since v3.1._
247      */
248     function functionCallWithValue(
249         address target,
250         bytes memory data,
251         uint256 value,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         require(address(this).balance >= value, "Address: insufficient balance for call");
255         require(isContract(target), "Address: call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.call{value: value}(data);
258         return verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but performing a static call.
264      *
265      * _Available since v3.3._
266      */
267     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
268         return functionStaticCall(target, data, "Address: low-level static call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
273      * but performing a static call.
274      *
275      * _Available since v3.3._
276      */
277     function functionStaticCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal view returns (bytes memory) {
282         require(isContract(target), "Address: static call to non-contract");
283 
284         (bool success, bytes memory returndata) = target.staticcall(data);
285         return verifyCallResult(success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but performing a delegate call.
291      *
292      * _Available since v3.4._
293      */
294     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
295         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
300      * but performing a delegate call.
301      *
302      * _Available since v3.4._
303      */
304     function functionDelegateCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         require(isContract(target), "Address: delegate call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.delegatecall(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
317      * revert reason using the provided one.
318      *
319      * _Available since v4.3._
320      */
321     function verifyCallResult(
322         bool success,
323         bytes memory returndata,
324         string memory errorMessage
325     ) internal pure returns (bytes memory) {
326         if (success) {
327             return returndata;
328         } else {
329             // Look for revert reason and bubble it up if present
330             if (returndata.length > 0) {
331                 // The easiest way to bubble the revert reason is using memory via assembly
332 
333                 assembly {
334                     let returndata_size := mload(returndata)
335                     revert(add(32, returndata), returndata_size)
336                 }
337             } else {
338                 revert(errorMessage);
339             }
340         }
341     }
342 }
343 
344 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @title ERC721 token receiver interface
353  * @dev Interface for any contract that wants to support safeTransfers
354  * from ERC721 asset contracts.
355  */
356 interface IERC721Receiver {
357     /**
358      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
359      * by `operator` from `from`, this function is called.
360      *
361      * It must return its Solidity selector to confirm the token transfer.
362      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
363      *
364      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
365      */
366     function onERC721Received(
367         address operator,
368         address from,
369         uint256 tokenId,
370         bytes calldata data
371     ) external returns (bytes4);
372 }
373 
374 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
375 
376 
377 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 /**
382  * @dev Interface of the ERC165 standard, as defined in the
383  * https://eips.ethereum.org/EIPS/eip-165[EIP].
384  *
385  * Implementers can declare support of contract interfaces, which can then be
386  * queried by others ({ERC165Checker}).
387  *
388  * For an implementation, see {ERC165}.
389  */
390 interface IERC165 {
391     /**
392      * @dev Returns true if this contract implements the interface defined by
393      * `interfaceId`. See the corresponding
394      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
395      * to learn more about how these ids are created.
396      *
397      * This function call must use less than 30 000 gas.
398      */
399     function supportsInterface(bytes4 interfaceId) external view returns (bool);
400 }
401 
402 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
403 
404 
405 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 
410 /**
411  * @dev Implementation of the {IERC165} interface.
412  *
413  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
414  * for the additional interface id that will be supported. For example:
415  *
416  * ```solidity
417  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
418  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
419  * }
420  * ```
421  *
422  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
423  */
424 abstract contract ERC165 is IERC165 {
425     /**
426      * @dev See {IERC165-supportsInterface}.
427      */
428     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
429         return interfaceId == type(IERC165).interfaceId;
430     }
431 }
432 
433 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 
441 /**
442  * @dev Required interface of an ERC721 compliant contract.
443  */
444 interface IERC721 is IERC165 {
445     /**
446      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
447      */
448     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
449 
450     /**
451      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
452      */
453     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
454 
455     /**
456      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
457      */
458     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
459 
460     /**
461      * @dev Returns the number of tokens in ``owner``'s account.
462      */
463     function balanceOf(address owner) external view returns (uint256 balance);
464 
465     /**
466      * @dev Returns the owner of the `tokenId` token.
467      *
468      * Requirements:
469      *
470      * - `tokenId` must exist.
471      */
472     function ownerOf(uint256 tokenId) external view returns (address owner);
473 
474     /**
475      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
476      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must exist and be owned by `from`.
483      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
484      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
485      *
486      * Emits a {Transfer} event.
487      */
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Transfers `tokenId` token from `from` to `to`.
496      *
497      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must be owned by `from`.
504      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
505      *
506      * Emits a {Transfer} event.
507      */
508     function transferFrom(
509         address from,
510         address to,
511         uint256 tokenId
512     ) external;
513 
514     /**
515      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
516      * The approval is cleared when the token is transferred.
517      *
518      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
519      *
520      * Requirements:
521      *
522      * - The caller must own the token or be an approved operator.
523      * - `tokenId` must exist.
524      *
525      * Emits an {Approval} event.
526      */
527     function approve(address to, uint256 tokenId) external;
528 
529     /**
530      * @dev Returns the account approved for `tokenId` token.
531      *
532      * Requirements:
533      *
534      * - `tokenId` must exist.
535      */
536     function getApproved(uint256 tokenId) external view returns (address operator);
537 
538     /**
539      * @dev Approve or remove `operator` as an operator for the caller.
540      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
541      *
542      * Requirements:
543      *
544      * - The `operator` cannot be the caller.
545      *
546      * Emits an {ApprovalForAll} event.
547      */
548     function setApprovalForAll(address operator, bool _approved) external;
549 
550     /**
551      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
552      *
553      * See {setApprovalForAll}
554      */
555     function isApprovedForAll(address owner, address operator) external view returns (bool);
556 
557     /**
558      * @dev Safely transfers `tokenId` token from `from` to `to`.
559      *
560      * Requirements:
561      *
562      * - `from` cannot be the zero address.
563      * - `to` cannot be the zero address.
564      * - `tokenId` token must exist and be owned by `from`.
565      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
566      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
567      *
568      * Emits a {Transfer} event.
569      */
570     function safeTransferFrom(
571         address from,
572         address to,
573         uint256 tokenId,
574         bytes calldata data
575     ) external;
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
588  * @dev See https://eips.ethereum.org/EIPS/eip-721
589  */
590 interface IERC721Metadata is IERC721 {
591     /**
592      * @dev Returns the token collection name.
593      */
594     function name() external view returns (string memory);
595 
596     /**
597      * @dev Returns the token collection symbol.
598      */
599     function symbol() external view returns (string memory);
600 
601     /**
602      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
603      */
604     function tokenURI(uint256 tokenId) external view returns (string memory);
605 }
606 
607 // File: contracts/new.sol
608 
609 
610 
611 
612 pragma solidity ^0.8.4;
613 
614 
615 
616 
617 
618 
619 
620 
621 error ApprovalCallerNotOwnerNorApproved();
622 error ApprovalQueryForNonexistentToken();
623 error ApproveToCaller();
624 error ApprovalToCurrentOwner();
625 error BalanceQueryForZeroAddress();
626 error MintToZeroAddress();
627 error MintZeroQuantity();
628 error OwnerQueryForNonexistentToken();
629 error TransferCallerNotOwnerNorApproved();
630 error TransferFromIncorrectOwner();
631 error TransferToNonERC721ReceiverImplementer();
632 error TransferToZeroAddress();
633 error URIQueryForNonexistentToken();
634 
635 /**
636  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
637  * the Metadata extension. Built to optimize for lower gas during batch mints.
638  *
639  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
640  *
641  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
642  *
643  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
644  */
645 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
646     using Address for address;
647     using Strings for uint256;
648 
649     // Compiler will pack this into a single 256bit word.
650     struct TokenOwnership {
651         // The address of the owner.
652         address addr;
653         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
654         uint64 startTimestamp;
655         // Whether the token has been burned.
656         bool burned;
657     }
658 
659     // Compiler will pack this into a single 256bit word.
660     struct AddressData {
661         // Realistically, 2**64-1 is more than enough.
662         uint64 balance;
663         // Keeps track of mint count with minimal overhead for tokenomics.
664         uint64 numberMinted;
665         // Keeps track of burn count with minimal overhead for tokenomics.
666         uint64 numberBurned;
667         // For miscellaneous variable(s) pertaining to the address
668         // (e.g. number of whitelist mint slots used).
669         // If there are multiple variables, please pack them into a uint64.
670         uint64 aux;
671     }
672 
673     // The tokenId of the next token to be minted.
674     uint256 internal _currentIndex;
675 
676     // The number of tokens burned.
677     uint256 internal _burnCounter;
678 
679     // Token name
680     string private _name;
681 
682     // Token symbol
683     string private _symbol;
684 
685     // Mapping from token ID to ownership details
686     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
687     mapping(uint256 => TokenOwnership) internal _ownerships;
688 
689     // Mapping owner address to address data
690     mapping(address => AddressData) private _addressData;
691 
692     // Mapping from token ID to approved address
693     mapping(uint256 => address) private _tokenApprovals;
694 
695     // Mapping from owner to operator approvals
696     mapping(address => mapping(address => bool)) private _operatorApprovals;
697 
698     constructor(string memory name_, string memory symbol_) {
699         _name = name_;
700         _symbol = symbol_;
701         _currentIndex = _startTokenId();
702     }
703 
704     /**
705      * To change the starting tokenId, please override this function.
706      */
707     function _startTokenId() internal view virtual returns (uint256) {
708         return 0;
709     }
710 
711     /**
712      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
713      */
714     function totalSupply() public view returns (uint256) {
715         // Counter underflow is impossible as _burnCounter cannot be incremented
716         // more than _currentIndex - _startTokenId() times
717         unchecked {
718             return _currentIndex - _burnCounter - _startTokenId();
719         }
720     }
721 
722     /**
723      * Returns the total amount of tokens minted in the contract.
724      */
725     function _totalMinted() internal view returns (uint256) {
726         // Counter underflow is impossible as _currentIndex does not decrement,
727         // and it is initialized to _startTokenId()
728         unchecked {
729             return _currentIndex - _startTokenId();
730         }
731     }
732 
733     /**
734      * @dev See {IERC165-supportsInterface}.
735      */
736     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
737         return
738             interfaceId == type(IERC721).interfaceId ||
739             interfaceId == type(IERC721Metadata).interfaceId ||
740             super.supportsInterface(interfaceId);
741     }
742 
743     /**
744      * @dev See {IERC721-balanceOf}.
745      */
746     function balanceOf(address owner) public view override returns (uint256) {
747         if (owner == address(0)) revert BalanceQueryForZeroAddress();
748         return uint256(_addressData[owner].balance);
749     }
750 
751     /**
752      * Returns the number of tokens minted by `owner`.
753      */
754     function _numberMinted(address owner) internal view returns (uint256) {
755         return uint256(_addressData[owner].numberMinted);
756     }
757 
758     /**
759      * Returns the number of tokens burned by or on behalf of `owner`.
760      */
761     function _numberBurned(address owner) internal view returns (uint256) {
762         return uint256(_addressData[owner].numberBurned);
763     }
764 
765     /**
766      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
767      */
768     function _getAux(address owner) internal view returns (uint64) {
769         return _addressData[owner].aux;
770     }
771 
772     /**
773      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
774      * If there are multiple variables, please pack them into a uint64.
775      */
776     function _setAux(address owner, uint64 aux) internal {
777         _addressData[owner].aux = aux;
778     }
779 
780     /**
781      * Gas spent here starts off proportional to the maximum mint batch size.
782      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
783      */
784     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
785         uint256 curr = tokenId;
786 
787         unchecked {
788             if (_startTokenId() <= curr && curr < _currentIndex) {
789                 TokenOwnership memory ownership = _ownerships[curr];
790                 if (!ownership.burned) {
791                     if (ownership.addr != address(0)) {
792                         return ownership;
793                     }
794                     // Invariant:
795                     // There will always be an ownership that has an address and is not burned
796                     // before an ownership that does not have an address and is not burned.
797                     // Hence, curr will not underflow.
798                     while (true) {
799                         curr--;
800                         ownership = _ownerships[curr];
801                         if (ownership.addr != address(0)) {
802                             return ownership;
803                         }
804                     }
805                 }
806             }
807         }
808         revert OwnerQueryForNonexistentToken();
809     }
810 
811     /**
812      * @dev See {IERC721-ownerOf}.
813      */
814     function ownerOf(uint256 tokenId) public view override returns (address) {
815         return _ownershipOf(tokenId).addr;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-name}.
820      */
821     function name() public view virtual override returns (string memory) {
822         return _name;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-symbol}.
827      */
828     function symbol() public view virtual override returns (string memory) {
829         return _symbol;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-tokenURI}.
834      */
835     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
836         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
837 
838         string memory baseURI = _baseURI();
839         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
840     }
841 
842     /**
843      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
844      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
845      * by default, can be overriden in child contracts.
846      */
847     function _baseURI() internal view virtual returns (string memory) {
848         return '';
849     }
850 
851     /**
852      * @dev See {IERC721-approve}.
853      */
854     function approve(address to, uint256 tokenId) public override {
855         address owner = ERC721A.ownerOf(tokenId);
856         if (to == owner) revert ApprovalToCurrentOwner();
857 
858         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
859             revert ApprovalCallerNotOwnerNorApproved();
860         }
861 
862         _approve(to, tokenId, owner);
863     }
864 
865     /**
866      * @dev See {IERC721-getApproved}.
867      */
868     function getApproved(uint256 tokenId) public view override returns (address) {
869         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
870 
871         return _tokenApprovals[tokenId];
872     }
873 
874     /**
875      * @dev See {IERC721-setApprovalForAll}.
876      */
877     function setApprovalForAll(address operator, bool approved) public virtual override {
878         if (operator == _msgSender()) revert ApproveToCaller();
879 
880         _operatorApprovals[_msgSender()][operator] = approved;
881         emit ApprovalForAll(_msgSender(), operator, approved);
882     }
883 
884     /**
885      * @dev See {IERC721-isApprovedForAll}.
886      */
887     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
888         return _operatorApprovals[owner][operator];
889     }
890 
891     /**
892      * @dev See {IERC721-transferFrom}.
893      */
894     function transferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public virtual override {
899         _transfer(from, to, tokenId);
900     }
901 
902     /**
903      * @dev See {IERC721-safeTransferFrom}.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public virtual override {
910         safeTransferFrom(from, to, tokenId, '');
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) public virtual override {
922         _transfer(from, to, tokenId);
923         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
924             revert TransferToNonERC721ReceiverImplementer();
925         }
926     }
927 
928     /**
929      * @dev Returns whether `tokenId` exists.
930      *
931      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
932      *
933      * Tokens start existing when they are minted (`_mint`),
934      */
935     function _exists(uint256 tokenId) internal view returns (bool) {
936         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
937             !_ownerships[tokenId].burned;
938     }
939 
940     function _safeMint(address to, uint256 quantity) internal {
941         _safeMint(to, quantity, '');
942     }
943 
944     /**
945      * @dev Safely mints `quantity` tokens and transfers them to `to`.
946      *
947      * Requirements:
948      *
949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
950      * - `quantity` must be greater than 0.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _safeMint(
955         address to,
956         uint256 quantity,
957         bytes memory _data
958     ) internal {
959         _mint(to, quantity, _data, true);
960     }
961 
962     /**
963      * @dev Mints `quantity` tokens and transfers them to `to`.
964      *
965      * Requirements:
966      *
967      * - `to` cannot be the zero address.
968      * - `quantity` must be greater than 0.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _mint(
973         address to,
974         uint256 quantity,
975         bytes memory _data,
976         bool safe
977     ) internal {
978         uint256 startTokenId = _currentIndex;
979         if (to == address(0)) revert MintToZeroAddress();
980         if (quantity == 0) revert MintZeroQuantity();
981 
982         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
983 
984         // Overflows are incredibly unrealistic.
985         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
986         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
987         unchecked {
988             _addressData[to].balance += uint64(quantity);
989             _addressData[to].numberMinted += uint64(quantity);
990 
991             _ownerships[startTokenId].addr = to;
992             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
993 
994             uint256 updatedIndex = startTokenId;
995             uint256 end = updatedIndex + quantity;
996 
997             if (safe && to.isContract()) {
998                 do {
999                     emit Transfer(address(0), to, updatedIndex);
1000                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1001                         revert TransferToNonERC721ReceiverImplementer();
1002                     }
1003                 } while (updatedIndex != end);
1004                 // Reentrancy protection
1005                 if (_currentIndex != startTokenId) revert();
1006             } else {
1007                 do {
1008                     emit Transfer(address(0), to, updatedIndex++);
1009                 } while (updatedIndex != end);
1010             }
1011             _currentIndex = updatedIndex;
1012         }
1013         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1014     }
1015 
1016     /**
1017      * @dev Transfers `tokenId` from `from` to `to`.
1018      *
1019      * Requirements:
1020      *
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must be owned by `from`.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _transfer(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) private {
1031         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1032 
1033         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1034 
1035         bool isApprovedOrOwner = (_msgSender() == from ||
1036             isApprovedForAll(from, _msgSender()) ||
1037             getApproved(tokenId) == _msgSender());
1038 
1039         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1040         if (to == address(0)) revert TransferToZeroAddress();
1041 
1042         _beforeTokenTransfers(from, to, tokenId, 1);
1043 
1044         // Clear approvals from the previous owner
1045         _approve(address(0), tokenId, from);
1046 
1047         // Underflow of the sender's balance is impossible because we check for
1048         // ownership above and the recipient's balance can't realistically overflow.
1049         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1050         unchecked {
1051             _addressData[from].balance -= 1;
1052             _addressData[to].balance += 1;
1053 
1054             TokenOwnership storage currSlot = _ownerships[tokenId];
1055             currSlot.addr = to;
1056             currSlot.startTimestamp = uint64(block.timestamp);
1057 
1058             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1059             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1060             uint256 nextTokenId = tokenId + 1;
1061             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1062             if (nextSlot.addr == address(0)) {
1063                 // This will suffice for checking _exists(nextTokenId),
1064                 // as a burned slot cannot contain the zero address.
1065                 if (nextTokenId != _currentIndex) {
1066                     nextSlot.addr = from;
1067                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1068                 }
1069             }
1070         }
1071 
1072         emit Transfer(from, to, tokenId);
1073         _afterTokenTransfers(from, to, tokenId, 1);
1074     }
1075 
1076     /**
1077      * @dev This is equivalent to _burn(tokenId, false)
1078      */
1079     function _burn(uint256 tokenId) internal virtual {
1080         _burn(tokenId, false);
1081     }
1082 
1083     /**
1084      * @dev Destroys `tokenId`.
1085      * The approval is cleared when the token is burned.
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must exist.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1094         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1095 
1096         address from = prevOwnership.addr;
1097 
1098         if (approvalCheck) {
1099             bool isApprovedOrOwner = (_msgSender() == from ||
1100                 isApprovedForAll(from, _msgSender()) ||
1101                 getApproved(tokenId) == _msgSender());
1102 
1103             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1104         }
1105 
1106         _beforeTokenTransfers(from, address(0), tokenId, 1);
1107 
1108         // Clear approvals from the previous owner
1109         _approve(address(0), tokenId, from);
1110 
1111         // Underflow of the sender's balance is impossible because we check for
1112         // ownership above and the recipient's balance can't realistically overflow.
1113         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1114         unchecked {
1115             AddressData storage addressData = _addressData[from];
1116             addressData.balance -= 1;
1117             addressData.numberBurned += 1;
1118 
1119             // Keep track of who burned the token, and the timestamp of burning.
1120             TokenOwnership storage currSlot = _ownerships[tokenId];
1121             currSlot.addr = from;
1122             currSlot.startTimestamp = uint64(block.timestamp);
1123             currSlot.burned = true;
1124 
1125             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1126             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1127             uint256 nextTokenId = tokenId + 1;
1128             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1129             if (nextSlot.addr == address(0)) {
1130                 // This will suffice for checking _exists(nextTokenId),
1131                 // as a burned slot cannot contain the zero address.
1132                 if (nextTokenId != _currentIndex) {
1133                     nextSlot.addr = from;
1134                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1135                 }
1136             }
1137         }
1138 
1139         emit Transfer(from, address(0), tokenId);
1140         _afterTokenTransfers(from, address(0), tokenId, 1);
1141 
1142         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1143         unchecked {
1144             _burnCounter++;
1145         }
1146     }
1147 
1148     /**
1149      * @dev Approve `to` to operate on `tokenId`
1150      *
1151      * Emits a {Approval} event.
1152      */
1153     function _approve(
1154         address to,
1155         uint256 tokenId,
1156         address owner
1157     ) private {
1158         _tokenApprovals[tokenId] = to;
1159         emit Approval(owner, to, tokenId);
1160     }
1161 
1162     /**
1163      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1164      *
1165      * @param from address representing the previous owner of the given token ID
1166      * @param to target address that will receive the tokens
1167      * @param tokenId uint256 ID of the token to be transferred
1168      * @param _data bytes optional data to send along with the call
1169      * @return bool whether the call correctly returned the expected magic value
1170      */
1171     function _checkContractOnERC721Received(
1172         address from,
1173         address to,
1174         uint256 tokenId,
1175         bytes memory _data
1176     ) private returns (bool) {
1177         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1178             return retval == IERC721Receiver(to).onERC721Received.selector;
1179         } catch (bytes memory reason) {
1180             if (reason.length == 0) {
1181                 revert TransferToNonERC721ReceiverImplementer();
1182             } else {
1183                 assembly {
1184                     revert(add(32, reason), mload(reason))
1185                 }
1186             }
1187         }
1188     }
1189 
1190     /**
1191      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1192      * And also called before burning one token.
1193      *
1194      * startTokenId - the first token id to be transferred
1195      * quantity - the amount to be transferred
1196      *
1197      * Calling conditions:
1198      *
1199      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1200      * transferred to `to`.
1201      * - When `from` is zero, `tokenId` will be minted for `to`.
1202      * - When `to` is zero, `tokenId` will be burned by `from`.
1203      * - `from` and `to` are never both zero.
1204      */
1205     function _beforeTokenTransfers(
1206         address from,
1207         address to,
1208         uint256 startTokenId,
1209         uint256 quantity
1210     ) internal virtual {}
1211 
1212     /**
1213      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1214      * minting.
1215      * And also called after one token has been burned.
1216      *
1217      * startTokenId - the first token id to be transferred
1218      * quantity - the amount to be transferred
1219      *
1220      * Calling conditions:
1221      *
1222      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1223      * transferred to `to`.
1224      * - When `from` is zero, `tokenId` has been minted for `to`.
1225      * - When `to` is zero, `tokenId` has been burned by `from`.
1226      * - `from` and `to` are never both zero.
1227      */
1228     function _afterTokenTransfers(
1229         address from,
1230         address to,
1231         uint256 startTokenId,
1232         uint256 quantity
1233     ) internal virtual {}
1234 }
1235 
1236 abstract contract Ownable is Context {
1237     address private _owner;
1238 
1239     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1240 
1241     /**
1242      * @dev Initializes the contract setting the deployer as the initial owner.
1243      */
1244     constructor() {
1245         _transferOwnership(_msgSender());
1246     }
1247 
1248     /**
1249      * @dev Returns the address of the current owner.
1250      */
1251     function owner() public view virtual returns (address) {
1252         return _owner;
1253     }
1254 
1255     /**
1256      * @dev Throws if called by any account other than the owner.
1257      */
1258     modifier onlyOwner() {
1259         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1260         _;
1261     }
1262 
1263     /**
1264      * @dev Leaves the contract without owner. It will not be possible to call
1265      * `onlyOwner` functions anymore. Can only be called by the current owner.
1266      *
1267      * NOTE: Renouncing ownership will leave the contract without an owner,
1268      * thereby removing any functionality that is only available to the owner.
1269      */
1270     function renounceOwnership() public virtual onlyOwner {
1271         _transferOwnership(address(0));
1272     }
1273 
1274     /**
1275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1276      * Can only be called by the current owner.
1277      */
1278     function transferOwnership(address newOwner) public virtual onlyOwner {
1279         require(newOwner != address(0), "Ownable: new owner is the zero address");
1280         _transferOwnership(newOwner);
1281     }
1282 
1283     /**
1284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1285      * Internal function without access restriction.
1286      */
1287     function _transferOwnership(address newOwner) internal virtual {
1288         address oldOwner = _owner;
1289         _owner = newOwner;
1290         emit OwnershipTransferred(oldOwner, newOwner);
1291     }
1292 }
1293 pragma solidity ^0.8.13;
1294 
1295 interface IOperatorFilterRegistry {
1296     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1297     function register(address registrant) external;
1298     function registerAndSubscribe(address registrant, address subscription) external;
1299     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1300     function updateOperator(address registrant, address operator, bool filtered) external;
1301     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1302     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1303     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1304     function subscribe(address registrant, address registrantToSubscribe) external;
1305     function unsubscribe(address registrant, bool copyExistingEntries) external;
1306     function subscriptionOf(address addr) external returns (address registrant);
1307     function subscribers(address registrant) external returns (address[] memory);
1308     function subscriberAt(address registrant, uint256 index) external returns (address);
1309     function copyEntriesOf(address registrant, address registrantToCopy) external;
1310     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1311     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1312     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1313     function filteredOperators(address addr) external returns (address[] memory);
1314     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1315     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1316     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1317     function isRegistered(address addr) external returns (bool);
1318     function codeHashOf(address addr) external returns (bytes32);
1319 }
1320 pragma solidity ^0.8.13;
1321 
1322 
1323 
1324 abstract contract OperatorFilterer {
1325     error OperatorNotAllowed(address operator);
1326 
1327     IOperatorFilterRegistry constant operatorFilterRegistry =
1328         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1329 
1330     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1331         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1332         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1333         // order for the modifier to filter addresses.
1334         if (address(operatorFilterRegistry).code.length > 0) {
1335             if (subscribe) {
1336                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1337             } else {
1338                 if (subscriptionOrRegistrantToCopy != address(0)) {
1339                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1340                 } else {
1341                     operatorFilterRegistry.register(address(this));
1342                 }
1343             }
1344         }
1345     }
1346 
1347     modifier onlyAllowedOperator(address from) virtual {
1348         // Check registry code length to facilitate testing in environments without a deployed registry.
1349         if (address(operatorFilterRegistry).code.length > 0) {
1350             // Allow spending tokens from addresses with balance
1351             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1352             // from an EOA.
1353             if (from == msg.sender) {
1354                 _;
1355                 return;
1356             }
1357             if (
1358                 !(
1359                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1360                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1361                 )
1362             ) {
1363                 revert OperatorNotAllowed(msg.sender);
1364             }
1365         }
1366         _;
1367     }
1368 }
1369 pragma solidity ^0.8.13;
1370 
1371 
1372 
1373 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1374     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1375 
1376     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1377 }
1378     pragma solidity ^0.8.7;
1379     
1380     contract SNeakyFrenz is ERC721A, DefaultOperatorFilterer , Ownable {
1381     using Strings for uint256;
1382 
1383 
1384   string private uriPrefix ;
1385   string private uriSuffix = ".json";
1386   string public hiddenURL;
1387 
1388   
1389   
1390 
1391   uint256 public cost = 0.003 ether;
1392  
1393   
1394 
1395   uint16 public maxSupply = 2222;
1396   uint8 public maxMintAmountPerTx = 11;
1397     uint8 public maxFreeMintAmountPerWallet = 1;
1398                                                              
1399  
1400   bool public paused = true;
1401   bool public reveal =false;
1402 
1403    mapping (address => uint8) public NFTPerPublicAddress;
1404 
1405  
1406   
1407   
1408  
1409   
1410 
1411   constructor() ERC721A("Sneaky Frenz", "SF") {
1412   }
1413 
1414 
1415   
1416  
1417   function mint(uint8 _mintAmount) external payable  {
1418      uint16 totalSupply = uint16(totalSupply());
1419      uint8 nft = NFTPerPublicAddress[msg.sender];
1420     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1421     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1422 
1423     require(!paused, "The contract is paused!");
1424     
1425       if(nft >= maxFreeMintAmountPerWallet)
1426     {
1427     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1428     }
1429     else {
1430          uint8 costAmount = _mintAmount + nft;
1431         if(costAmount > maxFreeMintAmountPerWallet)
1432        {
1433         costAmount = costAmount - maxFreeMintAmountPerWallet;
1434         require(msg.value >= cost * costAmount, "Insufficient funds!");
1435        }
1436        
1437          
1438     }
1439     
1440 
1441 
1442     _safeMint(msg.sender , _mintAmount);
1443 
1444     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1445      
1446      delete totalSupply;
1447      delete _mintAmount;
1448   }
1449   
1450   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1451      uint16 totalSupply = uint16(totalSupply());
1452     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1453      _safeMint(_receiver , _mintAmount);
1454      delete _mintAmount;
1455      delete _receiver;
1456      delete totalSupply;
1457   }
1458 
1459   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1460      uint16 totalSupply = uint16(totalSupply());
1461      uint totalAmount =   _amountPerAddress * addresses.length;
1462     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1463      for (uint256 i = 0; i < addresses.length; i++) {
1464             _safeMint(addresses[i], _amountPerAddress);
1465         }
1466 
1467      delete _amountPerAddress;
1468      delete totalSupply;
1469   }
1470 
1471  
1472 
1473   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1474       maxSupply = _maxSupply;
1475   }
1476 
1477 
1478 
1479    
1480   function tokenURI(uint256 _tokenId)
1481     public
1482     view
1483     virtual
1484     override
1485     returns (string memory)
1486   {
1487     require(
1488       _exists(_tokenId),
1489       "ERC721Metadata: URI query for nonexistent token"
1490     );
1491     
1492   
1493 if ( reveal == false)
1494 {
1495     return hiddenURL;
1496 }
1497     
1498 
1499     string memory currentBaseURI = _baseURI();
1500     return bytes(currentBaseURI).length > 0
1501         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1502         : "";
1503   }
1504  
1505  
1506 
1507 
1508  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1509     maxFreeMintAmountPerWallet = _limit;
1510    delete _limit;
1511 
1512 }
1513 
1514     
1515   
1516 
1517   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1518     uriPrefix = _uriPrefix;
1519   }
1520    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1521     hiddenURL = _uriPrefix;
1522   }
1523 
1524 
1525   function setPaused() external onlyOwner {
1526     paused = !paused;
1527    
1528   }
1529 
1530   function setCost(uint _cost) external onlyOwner{
1531       cost = _cost;
1532 
1533   }
1534 
1535  function setRevealed() external onlyOwner{
1536      reveal = !reveal;
1537  }
1538 
1539   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1540       maxMintAmountPerTx = _maxtx;
1541 
1542   }
1543 
1544  
1545 
1546   function withdraw() external onlyOwner {
1547   uint _balance = address(this).balance;
1548      payable(msg.sender).transfer(_balance ); 
1549        
1550   }
1551 
1552 
1553   function _baseURI() internal view  override returns (string memory) {
1554     return uriPrefix;
1555   }
1556 
1557     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1558         super.transferFrom(from, to, tokenId);
1559     }
1560 
1561     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1562         super.safeTransferFrom(from, to, tokenId);
1563     }
1564 
1565     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1566         public
1567         override
1568         onlyAllowedOperator(from)
1569     {
1570         super.safeTransferFrom(from, to, tokenId, data);
1571     }
1572 }