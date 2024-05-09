1 /**
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠤⠤⠤⠄⠀⠒⠢⣄⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⡠⠐⢈⠄⠀⠀⠀⠀⠀⠀⠀⠀⢸⠓⠄⠀⠀⠀
4 ⠀⠀⠀⠀⠐⠈⠠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⠀⠈⢂⠀⠀
5 ⠀⠀⢀⠊⠀⡐⠁⠀⠀⠀⠀⠀⠀⠀⠀⢠⢊⠔⠈⠀⠀⠀⠆⠀
6 ⠀⣠⡃⠀⢰⠀⠀⠀⠀⢀⡠⠄⠐⠒⠀⢸⢜⠄⠀⠀⠀⠀⠀⠀
7 ⡐⣁⡑⠀⠘⠀⠀⢀⠔⢁⣀⣤⣤⣤⣒⣤⠀⠈⠀⠀⠀⠀⡄⠀
8 ⢫⣿⢧⠀⢸⠀⠀⣡⣶⣯⠭⢄⣀⣼⡏⠁⢀⡤⠀⠀⠀⢐⠁⠀
9 ⢠⢿⣾⣧⠈⠀⢠⣿⣿⣗⢢⣤⣿⡿⢋⠀⡏⠀⠀⠀⠀⡌⠀⠀
10 ⠘⠳⠙⠻⠀⠀⠰⠿⠟⠛⠻⢍⠫⠒⠁⡰⠀⠀⠀⢀⠜⠀⠀⠀
11 ⠘⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⢊⠀⡇⢠⠒⠁⠀⠀⠀⠀
12 ⠀⠀⠈⢦⠂⠀⠀⠀⠀⢠⠊⠁⠀⢀⠄⠀⡇⢸⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠘⢄⡄⢤⢄⠀⠘⡄⠀⠀⡀⠄⢊⡅⡆⢆⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⢊⠀⠀⠀⠈⢁⠴⠅⣀⣀⠘⢣⠠⠈⠢⢀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠈⠢⢄⣀⡠⠊⠀⠀⠈⢣⠀⠈⠃⠡⠀⠀⠉⠐⠄
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠇⠀⠀⠐⡑⠤⢀⠀⠀
17  */
18 
19 // SPDX-License-Identifier: MIT
20 
21 // File: @openzeppelin/contracts/utils/Strings.sol
22 
23 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 }
89 
90 // File: @openzeppelin/contracts/utils/Context.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Address.sol
118 
119 
120 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
121 
122 pragma solidity ^0.8.1;
123 
124 /**
125  * @dev Collection of functions related to the address type
126  */
127 library Address {
128     /**
129      * @dev Returns true if `account` is a contract.
130      *
131      * [IMPORTANT]
132      * ====
133      * It is unsafe to assume that an address for which this function returns
134      * false is an externally-owned account (EOA) and not a contract.
135      *
136      * Among others, `isContract` will return false for the following
137      * types of addresses:
138      *
139      *  - an externally-owned account
140      *  - a contract in construction
141      *  - an address where a contract will be created
142      *  - an address where a contract lived, but was destroyed
143      * ====
144      *
145      * [IMPORTANT]
146      * ====
147      * You shouldn't rely on `isContract` to protect against flash loan attacks!
148      *
149      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
150      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
151      * constructor.
152      * ====
153      */
154     function isContract(address account) internal view returns (bool) {
155         // This method relies on extcodesize/address.code.length, which returns 0
156         // for contracts in construction, since the code is only stored at the end
157         // of the constructor execution.
158 
159         return account.code.length > 0;
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
342 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
343 
344 
345 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
346 
347 pragma solidity ^0.8.0;
348 
349 /**
350  * @title ERC721 token receiver interface
351  * @dev Interface for any contract that wants to support safeTransfers
352  * from ERC721 asset contracts.
353  */
354 interface IERC721Receiver {
355     /**
356      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
357      * by `operator` from `from`, this function is called.
358      *
359      * It must return its Solidity selector to confirm the token transfer.
360      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
361      *
362      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
363      */
364     function onERC721Received(
365         address operator,
366         address from,
367         uint256 tokenId,
368         bytes calldata data
369     ) external returns (bytes4);
370 }
371 
372 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev Interface of the ERC165 standard, as defined in the
381  * https://eips.ethereum.org/EIPS/eip-165[EIP].
382  *
383  * Implementers can declare support of contract interfaces, which can then be
384  * queried by others ({ERC165Checker}).
385  *
386  * For an implementation, see {ERC165}.
387  */
388 interface IERC165 {
389     /**
390      * @dev Returns true if this contract implements the interface defined by
391      * `interfaceId`. See the corresponding
392      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
393      * to learn more about how these ids are created.
394      *
395      * This function call must use less than 30 000 gas.
396      */
397     function supportsInterface(bytes4 interfaceId) external view returns (bool);
398 }
399 
400 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
401 
402 
403 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 
408 /**
409  * @dev Implementation of the {IERC165} interface.
410  *
411  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
412  * for the additional interface id that will be supported. For example:
413  *
414  * ```solidity
415  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
416  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
417  * }
418  * ```
419  *
420  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
421  */
422 abstract contract ERC165 is IERC165 {
423     /**
424      * @dev See {IERC165-supportsInterface}.
425      */
426     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
427         return interfaceId == type(IERC165).interfaceId;
428     }
429 }
430 
431 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 
439 /**
440  * @dev Required interface of an ERC721 compliant contract.
441  */
442 interface IERC721 is IERC165 {
443     /**
444      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
445      */
446     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
447 
448     /**
449      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
450      */
451     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
455      */
456     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
457 
458     /**
459      * @dev Returns the number of tokens in ``owner``'s account.
460      */
461     function balanceOf(address owner) external view returns (uint256 balance);
462 
463     /**
464      * @dev Returns the owner of the `tokenId` token.
465      *
466      * Requirements:
467      *
468      * - `tokenId` must exist.
469      */
470     function ownerOf(uint256 tokenId) external view returns (address owner);
471 
472     /**
473      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
474      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `tokenId` token must exist and be owned by `from`.
481      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
482      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
483      *
484      * Emits a {Transfer} event.
485      */
486     function safeTransferFrom(
487         address from,
488         address to,
489         uint256 tokenId
490     ) external;
491 
492     /**
493      * @dev Transfers `tokenId` token from `from` to `to`.
494      *
495      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `tokenId` token must be owned by `from`.
502      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
503      *
504      * Emits a {Transfer} event.
505      */
506     function transferFrom(
507         address from,
508         address to,
509         uint256 tokenId
510     ) external;
511 
512     /**
513      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
514      * The approval is cleared when the token is transferred.
515      *
516      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
517      *
518      * Requirements:
519      *
520      * - The caller must own the token or be an approved operator.
521      * - `tokenId` must exist.
522      *
523      * Emits an {Approval} event.
524      */
525     function approve(address to, uint256 tokenId) external;
526 
527     /**
528      * @dev Returns the account approved for `tokenId` token.
529      *
530      * Requirements:
531      *
532      * - `tokenId` must exist.
533      */
534     function getApproved(uint256 tokenId) external view returns (address operator);
535 
536     /**
537      * @dev Approve or remove `operator` as an operator for the caller.
538      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
539      *
540      * Requirements:
541      *
542      * - The `operator` cannot be the caller.
543      *
544      * Emits an {ApprovalForAll} event.
545      */
546     function setApprovalForAll(address operator, bool _approved) external;
547 
548     /**
549      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
550      *
551      * See {setApprovalForAll}
552      */
553     function isApprovedForAll(address owner, address operator) external view returns (bool);
554 
555     /**
556      * @dev Safely transfers `tokenId` token from `from` to `to`.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must exist and be owned by `from`.
563      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
564      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
565      *
566      * Emits a {Transfer} event.
567      */
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 tokenId,
572         bytes calldata data
573     ) external;
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
577 
578 
579 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 
584 /**
585  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
586  * @dev See https://eips.ethereum.org/EIPS/eip-721
587  */
588 interface IERC721Metadata is IERC721 {
589     /**
590      * @dev Returns the token collection name.
591      */
592     function name() external view returns (string memory);
593 
594     /**
595      * @dev Returns the token collection symbol.
596      */
597     function symbol() external view returns (string memory);
598 
599     /**
600      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
601      */
602     function tokenURI(uint256 tokenId) external view returns (string memory);
603 }
604 
605 // File: contracts/new.sol
606 
607 
608 
609 
610 pragma solidity ^0.8.4;
611 
612 
613 
614 
615 
616 
617 
618 
619 error ApprovalCallerNotOwnerNorApproved();
620 error ApprovalQueryForNonexistentToken();
621 error ApproveToCaller();
622 error ApprovalToCurrentOwner();
623 error BalanceQueryForZeroAddress();
624 error MintToZeroAddress();
625 error MintZeroQuantity();
626 error OwnerQueryForNonexistentToken();
627 error TransferCallerNotOwnerNorApproved();
628 error TransferFromIncorrectOwner();
629 error TransferToNonERC721ReceiverImplementer();
630 error TransferToZeroAddress();
631 error URIQueryForNonexistentToken();
632 
633 /**
634  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
635  * the Metadata extension. Built to optimize for lower gas during batch mints.
636  *
637  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
638  *
639  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
640  *
641  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
642  */
643 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
644     using Address for address;
645     using Strings for uint256;
646 
647     // Compiler will pack this into a single 256bit word.
648     struct TokenOwnership {
649         // The address of the owner.
650         address addr;
651         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
652         uint64 startTimestamp;
653         // Whether the token has been burned.
654         bool burned;
655     }
656 
657     // Compiler will pack this into a single 256bit word.
658     struct AddressData {
659         // Realistically, 2**64-1 is more than enough.
660         uint64 balance;
661         // Keeps track of mint count with minimal overhead for tokenomics.
662         uint64 numberMinted;
663         // Keeps track of burn count with minimal overhead for tokenomics.
664         uint64 numberBurned;
665         // For miscellaneous variable(s) pertaining to the address
666         // (e.g. number of whitelist mint slots used).
667         // If there are multiple variables, please pack them into a uint64.
668         uint64 aux;
669     }
670 
671     // The tokenId of the next token to be minted.
672     uint256 internal _currentIndex;
673 
674     // The number of tokens burned.
675     uint256 internal _burnCounter;
676 
677     // Token name
678     string private _name;
679 
680     // Token symbol
681     string private _symbol;
682 
683     // Mapping from token ID to ownership details
684     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
685     mapping(uint256 => TokenOwnership) internal _ownerships;
686 
687     // Mapping owner address to address data
688     mapping(address => AddressData) private _addressData;
689 
690     // Mapping from token ID to approved address
691     mapping(uint256 => address) private _tokenApprovals;
692 
693     // Mapping from owner to operator approvals
694     mapping(address => mapping(address => bool)) private _operatorApprovals;
695 
696     constructor(string memory name_, string memory symbol_) {
697         _name = name_;
698         _symbol = symbol_;
699         _currentIndex = _startTokenId();
700     }
701 
702     /**
703      * To change the starting tokenId, please override this function.
704      */
705     function _startTokenId() internal view virtual returns (uint256) {
706         return 0;
707     }
708 
709     /**
710      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
711      */
712     function totalSupply() public view returns (uint256) {
713         // Counter underflow is impossible as _burnCounter cannot be incremented
714         // more than _currentIndex - _startTokenId() times
715         unchecked {
716             return _currentIndex - _burnCounter - _startTokenId();
717         }
718     }
719 
720     /**
721      * Returns the total amount of tokens minted in the contract.
722      */
723     function _totalMinted() internal view returns (uint256) {
724         // Counter underflow is impossible as _currentIndex does not decrement,
725         // and it is initialized to _startTokenId()
726         unchecked {
727             return _currentIndex - _startTokenId();
728         }
729     }
730 
731     /**
732      * @dev See {IERC165-supportsInterface}.
733      */
734     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
735         return
736             interfaceId == type(IERC721).interfaceId ||
737             interfaceId == type(IERC721Metadata).interfaceId ||
738             super.supportsInterface(interfaceId);
739     }
740 
741     /**
742      * @dev See {IERC721-balanceOf}.
743      */
744     function balanceOf(address owner) public view override returns (uint256) {
745         if (owner == address(0)) revert BalanceQueryForZeroAddress();
746         return uint256(_addressData[owner].balance);
747     }
748 
749     /**
750      * Returns the number of tokens minted by `owner`.
751      */
752     function _numberMinted(address owner) internal view returns (uint256) {
753         return uint256(_addressData[owner].numberMinted);
754     }
755 
756     /**
757      * Returns the number of tokens burned by or on behalf of `owner`.
758      */
759     function _numberBurned(address owner) internal view returns (uint256) {
760         return uint256(_addressData[owner].numberBurned);
761     }
762 
763     /**
764      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
765      */
766     function _getAux(address owner) internal view returns (uint64) {
767         return _addressData[owner].aux;
768     }
769 
770     /**
771      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
772      * If there are multiple variables, please pack them into a uint64.
773      */
774     function _setAux(address owner, uint64 aux) internal {
775         _addressData[owner].aux = aux;
776     }
777 
778     /**
779      * Gas spent here starts off proportional to the maximum mint batch size.
780      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
781      */
782     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
783         uint256 curr = tokenId;
784 
785         unchecked {
786             if (_startTokenId() <= curr && curr < _currentIndex) {
787                 TokenOwnership memory ownership = _ownerships[curr];
788                 if (!ownership.burned) {
789                     if (ownership.addr != address(0)) {
790                         return ownership;
791                     }
792                     // Invariant:
793                     // There will always be an ownership that has an address and is not burned
794                     // before an ownership that does not have an address and is not burned.
795                     // Hence, curr will not underflow.
796                     while (true) {
797                         curr--;
798                         ownership = _ownerships[curr];
799                         if (ownership.addr != address(0)) {
800                             return ownership;
801                         }
802                     }
803                 }
804             }
805         }
806         revert OwnerQueryForNonexistentToken();
807     }
808 
809     /**
810      * @dev See {IERC721-ownerOf}.
811      */
812     function ownerOf(uint256 tokenId) public view override returns (address) {
813         return _ownershipOf(tokenId).addr;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-name}.
818      */
819     function name() public view virtual override returns (string memory) {
820         return _name;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-symbol}.
825      */
826     function symbol() public view virtual override returns (string memory) {
827         return _symbol;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-tokenURI}.
832      */
833     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
834         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
835 
836         string memory baseURI = _baseURI();
837         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
838     }
839 
840     /**
841      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
842      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
843      * by default, can be overriden in child contracts.
844      */
845     function _baseURI() internal view virtual returns (string memory) {
846         return '';
847     }
848 
849     /**
850      * @dev See {IERC721-approve}.
851      */
852     function approve(address to, uint256 tokenId) public override {
853         address owner = ERC721A.ownerOf(tokenId);
854         if (to == owner) revert ApprovalToCurrentOwner();
855 
856         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
857             revert ApprovalCallerNotOwnerNorApproved();
858         }
859 
860         _approve(to, tokenId, owner);
861     }
862 
863     /**
864      * @dev See {IERC721-getApproved}.
865      */
866     function getApproved(uint256 tokenId) public view override returns (address) {
867         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
868 
869         return _tokenApprovals[tokenId];
870     }
871 
872     /**
873      * @dev See {IERC721-setApprovalForAll}.
874      */
875     function setApprovalForAll(address operator, bool approved) public virtual override {
876         if (operator == _msgSender()) revert ApproveToCaller();
877 
878         _operatorApprovals[_msgSender()][operator] = approved;
879         emit ApprovalForAll(_msgSender(), operator, approved);
880     }
881 
882     /**
883      * @dev See {IERC721-isApprovedForAll}.
884      */
885     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
886         return _operatorApprovals[owner][operator];
887     }
888 
889     /**
890      * @dev See {IERC721-transferFrom}.
891      */
892     function transferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         _transfer(from, to, tokenId);
898     }
899 
900     /**
901      * @dev See {IERC721-safeTransferFrom}.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId
907     ) public virtual override {
908         safeTransferFrom(from, to, tokenId, '');
909     }
910 
911     /**
912      * @dev See {IERC721-safeTransferFrom}.
913      */
914     function safeTransferFrom(
915         address from,
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) public virtual override {
920         _transfer(from, to, tokenId);
921         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
922             revert TransferToNonERC721ReceiverImplementer();
923         }
924     }
925 
926     /**
927      * @dev Returns whether `tokenId` exists.
928      *
929      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
930      *
931      * Tokens start existing when they are minted (`_mint`),
932      */
933     function _exists(uint256 tokenId) internal view returns (bool) {
934         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
935             !_ownerships[tokenId].burned;
936     }
937 
938     function _safeMint(address to, uint256 quantity) internal {
939         _safeMint(to, quantity, '');
940     }
941 
942     /**
943      * @dev Safely mints `quantity` tokens and transfers them to `to`.
944      *
945      * Requirements:
946      *
947      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
948      * - `quantity` must be greater than 0.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _safeMint(
953         address to,
954         uint256 quantity,
955         bytes memory _data
956     ) internal {
957         _mint(to, quantity, _data, true);
958     }
959 
960     /**
961      * @dev Mints `quantity` tokens and transfers them to `to`.
962      *
963      * Requirements:
964      *
965      * - `to` cannot be the zero address.
966      * - `quantity` must be greater than 0.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _mint(
971         address to,
972         uint256 quantity,
973         bytes memory _data,
974         bool safe
975     ) internal {
976         uint256 startTokenId = _currentIndex;
977         if (to == address(0)) revert MintToZeroAddress();
978         if (quantity == 0) revert MintZeroQuantity();
979 
980         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
981 
982         // Overflows are incredibly unrealistic.
983         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
984         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
985         unchecked {
986             _addressData[to].balance += uint64(quantity);
987             _addressData[to].numberMinted += uint64(quantity);
988 
989             _ownerships[startTokenId].addr = to;
990             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
991 
992             uint256 updatedIndex = startTokenId;
993             uint256 end = updatedIndex + quantity;
994 
995             if (safe && to.isContract()) {
996                 do {
997                     emit Transfer(address(0), to, updatedIndex);
998                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
999                         revert TransferToNonERC721ReceiverImplementer();
1000                     }
1001                 } while (updatedIndex != end);
1002                 // Reentrancy protection
1003                 if (_currentIndex != startTokenId) revert();
1004             } else {
1005                 do {
1006                     emit Transfer(address(0), to, updatedIndex++);
1007                 } while (updatedIndex != end);
1008             }
1009             _currentIndex = updatedIndex;
1010         }
1011         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1012     }
1013 
1014     /**
1015      * @dev Transfers `tokenId` from `from` to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must be owned by `from`.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _transfer(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) private {
1029         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1030 
1031         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1032 
1033         bool isApprovedOrOwner = (_msgSender() == from ||
1034             isApprovedForAll(from, _msgSender()) ||
1035             getApproved(tokenId) == _msgSender());
1036 
1037         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1038         if (to == address(0)) revert TransferToZeroAddress();
1039 
1040         _beforeTokenTransfers(from, to, tokenId, 1);
1041 
1042         // Clear approvals from the previous owner
1043         _approve(address(0), tokenId, from);
1044 
1045         // Underflow of the sender's balance is impossible because we check for
1046         // ownership above and the recipient's balance can't realistically overflow.
1047         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1048         unchecked {
1049             _addressData[from].balance -= 1;
1050             _addressData[to].balance += 1;
1051 
1052             TokenOwnership storage currSlot = _ownerships[tokenId];
1053             currSlot.addr = to;
1054             currSlot.startTimestamp = uint64(block.timestamp);
1055 
1056             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1057             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1058             uint256 nextTokenId = tokenId + 1;
1059             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1060             if (nextSlot.addr == address(0)) {
1061                 // This will suffice for checking _exists(nextTokenId),
1062                 // as a burned slot cannot contain the zero address.
1063                 if (nextTokenId != _currentIndex) {
1064                     nextSlot.addr = from;
1065                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1066                 }
1067             }
1068         }
1069 
1070         emit Transfer(from, to, tokenId);
1071         _afterTokenTransfers(from, to, tokenId, 1);
1072     }
1073 
1074     /**
1075      * @dev This is equivalent to _burn(tokenId, false)
1076      */
1077     function _burn(uint256 tokenId) internal virtual {
1078         _burn(tokenId, false);
1079     }
1080 
1081     /**
1082      * @dev Destroys `tokenId`.
1083      * The approval is cleared when the token is burned.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must exist.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1092         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1093 
1094         address from = prevOwnership.addr;
1095 
1096         if (approvalCheck) {
1097             bool isApprovedOrOwner = (_msgSender() == from ||
1098                 isApprovedForAll(from, _msgSender()) ||
1099                 getApproved(tokenId) == _msgSender());
1100 
1101             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1102         }
1103 
1104         _beforeTokenTransfers(from, address(0), tokenId, 1);
1105 
1106         // Clear approvals from the previous owner
1107         _approve(address(0), tokenId, from);
1108 
1109         // Underflow of the sender's balance is impossible because we check for
1110         // ownership above and the recipient's balance can't realistically overflow.
1111         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1112         unchecked {
1113             AddressData storage addressData = _addressData[from];
1114             addressData.balance -= 1;
1115             addressData.numberBurned += 1;
1116 
1117             // Keep track of who burned the token, and the timestamp of burning.
1118             TokenOwnership storage currSlot = _ownerships[tokenId];
1119             currSlot.addr = from;
1120             currSlot.startTimestamp = uint64(block.timestamp);
1121             currSlot.burned = true;
1122 
1123             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1124             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1125             uint256 nextTokenId = tokenId + 1;
1126             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1127             if (nextSlot.addr == address(0)) {
1128                 // This will suffice for checking _exists(nextTokenId),
1129                 // as a burned slot cannot contain the zero address.
1130                 if (nextTokenId != _currentIndex) {
1131                     nextSlot.addr = from;
1132                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1133                 }
1134             }
1135         }
1136 
1137         emit Transfer(from, address(0), tokenId);
1138         _afterTokenTransfers(from, address(0), tokenId, 1);
1139 
1140         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1141         unchecked {
1142             _burnCounter++;
1143         }
1144     }
1145 
1146     /**
1147      * @dev Approve `to` to operate on `tokenId`
1148      *
1149      * Emits a {Approval} event.
1150      */
1151     function _approve(
1152         address to,
1153         uint256 tokenId,
1154         address owner
1155     ) private {
1156         _tokenApprovals[tokenId] = to;
1157         emit Approval(owner, to, tokenId);
1158     }
1159 
1160     /**
1161      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1162      *
1163      * @param from address representing the previous owner of the given token ID
1164      * @param to target address that will receive the tokens
1165      * @param tokenId uint256 ID of the token to be transferred
1166      * @param _data bytes optional data to send along with the call
1167      * @return bool whether the call correctly returned the expected magic value
1168      */
1169     function _checkContractOnERC721Received(
1170         address from,
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) private returns (bool) {
1175         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1176             return retval == IERC721Receiver(to).onERC721Received.selector;
1177         } catch (bytes memory reason) {
1178             if (reason.length == 0) {
1179                 revert TransferToNonERC721ReceiverImplementer();
1180             } else {
1181                 assembly {
1182                     revert(add(32, reason), mload(reason))
1183                 }
1184             }
1185         }
1186     }
1187 
1188     /**
1189      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1190      * And also called before burning one token.
1191      *
1192      * startTokenId - the first token id to be transferred
1193      * quantity - the amount to be transferred
1194      *
1195      * Calling conditions:
1196      *
1197      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1198      * transferred to `to`.
1199      * - When `from` is zero, `tokenId` will be minted for `to`.
1200      * - When `to` is zero, `tokenId` will be burned by `from`.
1201      * - `from` and `to` are never both zero.
1202      */
1203     function _beforeTokenTransfers(
1204         address from,
1205         address to,
1206         uint256 startTokenId,
1207         uint256 quantity
1208     ) internal virtual {}
1209 
1210     /**
1211      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1212      * minting.
1213      * And also called after one token has been burned.
1214      *
1215      * startTokenId - the first token id to be transferred
1216      * quantity - the amount to be transferred
1217      *
1218      * Calling conditions:
1219      *
1220      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1221      * transferred to `to`.
1222      * - When `from` is zero, `tokenId` has been minted for `to`.
1223      * - When `to` is zero, `tokenId` has been burned by `from`.
1224      * - `from` and `to` are never both zero.
1225      */
1226     function _afterTokenTransfers(
1227         address from,
1228         address to,
1229         uint256 startTokenId,
1230         uint256 quantity
1231     ) internal virtual {}
1232 }
1233 
1234 abstract contract Ownable is Context {
1235     address private _owner;
1236 
1237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1238 
1239     /**
1240      * @dev Initializes the contract setting the deployer as the initial owner.
1241      */
1242     constructor() {
1243         _transferOwnership(_msgSender());
1244     }
1245 
1246     /**
1247      * @dev Returns the address of the current owner.
1248      */
1249     function owner() public view virtual returns (address) {
1250         return _owner;
1251     }
1252 
1253     /**
1254      * @dev Throws if called by any account other than the owner.
1255      */
1256     modifier onlyOwner() {
1257         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1258         _;
1259     }
1260 
1261     /**
1262      * @dev Leaves the contract without owner. It will not be possible to call
1263      * `onlyOwner` functions anymore. Can only be called by the current owner.
1264      *
1265      * NOTE: Renouncing ownership will leave the contract without an owner,
1266      * thereby removing any functionality that is only available to the owner.
1267      */
1268     function renounceOwnership() public virtual onlyOwner {
1269         _transferOwnership(address(0));
1270     }
1271 
1272     /**
1273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1274      * Can only be called by the current owner.
1275      */
1276     function transferOwnership(address newOwner) public virtual onlyOwner {
1277         require(newOwner != address(0), "Ownable: new owner is the zero address");
1278         _transferOwnership(newOwner);
1279     }
1280 
1281     /**
1282      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1283      * Internal function without access restriction.
1284      */
1285     function _transferOwnership(address newOwner) internal virtual {
1286         address oldOwner = _owner;
1287         _owner = newOwner;
1288         emit OwnershipTransferred(oldOwner, newOwner);
1289     }
1290 }
1291     pragma solidity ^0.8.7;
1292     
1293     contract $8ncients is ERC721A, Ownable {
1294     using Strings for uint256;
1295 
1296 
1297   string private uriPrefix ;
1298   string private uriSuffix = ".json";
1299   string public hiddenURL;
1300 
1301   
1302   
1303 
1304   uint256 public cost = 0.003 ether;
1305   uint256 public whiteListCost = 0 ;
1306   
1307 
1308   uint16 public maxSupply = 4888;
1309   uint8 public maxMintAmountPerTx = 8;
1310     uint8 public maxFreeMintAmountPerWallet = 1;
1311                                                              
1312   bool public WLpaused = true;
1313   bool public paused = true;
1314   bool public reveal =false;
1315   mapping (address => uint8) public NFTPerWLAddress;
1316    mapping (address => uint8) public NFTPerPublicAddress;
1317   mapping (address => bool) public isWhitelisted;
1318  
1319   
1320   
1321  
1322   
1323 
1324   constructor() ERC721A("$8ncients", "8NCIENTS") {
1325   }
1326 
1327  function SACRIFICE(uint[] calldata token) external onlyOwner{
1328      for(uint i ; i <token.length ; i ++)
1329    _burn(token[i]);
1330  }
1331   
1332 
1333   
1334  
1335   function CRE8TE(uint8 _mintAmount) external payable  {
1336      uint16 totalSupply = uint16(totalSupply());
1337      uint8 nft = NFTPerPublicAddress[msg.sender];
1338     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1339     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1340 
1341     require(!paused, "The contract is paused!");
1342     
1343       if(nft >= maxFreeMintAmountPerWallet)
1344     {
1345     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1346     }
1347     else {
1348          uint8 costAmount = _mintAmount + nft;
1349         if(costAmount > maxFreeMintAmountPerWallet)
1350        {
1351         costAmount = costAmount - maxFreeMintAmountPerWallet;
1352         require(msg.value >= cost * costAmount, "Insufficient funds!");
1353        }
1354        
1355          
1356     }
1357     
1358 
1359 
1360     _safeMint(msg.sender , _mintAmount);
1361 
1362     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1363      
1364      delete totalSupply;
1365      delete _mintAmount;
1366   }
1367   
1368   function Invasion(uint16 _mintAmount, address _receiver) external onlyOwner {
1369      uint16 totalSupply = uint16(totalSupply());
1370     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1371      _safeMint(_receiver , _mintAmount);
1372      delete _mintAmount;
1373      delete _receiver;
1374      delete totalSupply;
1375   }
1376 
1377   function UFOLanding(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1378      uint16 totalSupply = uint16(totalSupply());
1379      uint totalAmount =   _amountPerAddress * addresses.length;
1380     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1381      for (uint256 i = 0; i < addresses.length; i++) {
1382             _safeMint(addresses[i], _amountPerAddress);
1383         }
1384 
1385      delete _amountPerAddress;
1386      delete totalSupply;
1387   }
1388 
1389  
1390 
1391   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1392       maxSupply = _maxSupply;
1393   }
1394 
1395 
1396 
1397    
1398   function tokenURI(uint256 _tokenId)
1399     public
1400     view
1401     virtual
1402     override
1403     returns (string memory)
1404   {
1405     require(
1406       _exists(_tokenId),
1407       "ERC721Metadata: URI query for nonexistent token"
1408     );
1409     
1410   
1411 if ( reveal == false)
1412 {
1413     return hiddenURL;
1414 }
1415     
1416 
1417     string memory currentBaseURI = _baseURI();
1418     return bytes(currentBaseURI).length > 0
1419         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1420         : "";
1421   }
1422  
1423    function setWLPaused() external onlyOwner {
1424     WLpaused = !WLpaused;
1425   }
1426   function setWLCost(uint256 _cost) external onlyOwner {
1427     whiteListCost = _cost;
1428     delete _cost;
1429   }
1430 
1431 
1432 
1433  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1434     maxFreeMintAmountPerWallet = _limit;
1435    delete _limit;
1436 
1437 }
1438 
1439     
1440   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1441         for(uint8 i = 0; i < entries.length; i++) {
1442             isWhitelisted[entries[i]] = true;
1443         }   
1444     }
1445 
1446     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1447         for(uint8 i = 0; i < entries.length; i++) {
1448              isWhitelisted[entries[i]] = false;
1449         }
1450     }
1451 
1452 function whitelistMint(uint8 _mintAmount) external payable {
1453         
1454     
1455         uint8 nft = NFTPerWLAddress[msg.sender];
1456        require(isWhitelisted[msg.sender],  "You are not whitelisted");
1457 
1458        require (nft + _mintAmount <= maxMintAmountPerTx, "Exceeds max  limit  per address");
1459       
1460 
1461 
1462     require(!WLpaused, "Whitelist minting is over!");
1463          if(nft >= maxFreeMintAmountPerWallet)
1464     {
1465     require(msg.value >= whiteListCost * _mintAmount, "Insufficient funds!");
1466     }
1467     else {
1468          uint8 costAmount = _mintAmount + nft;
1469         if(costAmount > maxFreeMintAmountPerWallet)
1470        {
1471         costAmount = costAmount - maxFreeMintAmountPerWallet;
1472         require(msg.value >= whiteListCost * costAmount, "Insufficient funds!");
1473        }
1474        
1475          
1476     }
1477     
1478     
1479 
1480      _safeMint(msg.sender , _mintAmount);
1481       NFTPerWLAddress[msg.sender] =nft + _mintAmount;
1482      
1483       delete _mintAmount;
1484        delete nft;
1485     
1486     }
1487 
1488   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1489     uriPrefix = _uriPrefix;
1490   }
1491    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1492     hiddenURL = _uriPrefix;
1493   }
1494 
1495 
1496   function setPaused() external onlyOwner {
1497     paused = !paused;
1498     WLpaused = true;
1499   }
1500 
1501   function setCost(uint _cost) external onlyOwner{
1502       cost = _cost;
1503 
1504   }
1505 
1506  function setRevealed() external onlyOwner{
1507      reveal = !reveal;
1508  }
1509 
1510   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1511       maxMintAmountPerTx = _maxtx;
1512 
1513   }
1514 
1515  
1516 
1517   function withdraw() external onlyOwner {
1518   uint _balance = address(this).balance;
1519      payable(msg.sender).transfer(_balance ); 
1520        
1521   }
1522 
1523 
1524   function _baseURI() internal view  override returns (string memory) {
1525     return uriPrefix;
1526   }
1527 }