1 /**⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⠶⠛⠛⠛⠶⣤⡀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⠟⠋⢁⣠⣴⣶⣶⣶⣬⣿⣆⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⡾⠟⠉⢀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀
6 ⠀⠀⠀⠀⠀⠀⠀⢀⣠⡴⠟⠋⠁⠀⠀⠺⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀
7 ⠀⠀⠀⠀⢀⣴⠾⠛⠉⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀
8 ⠀⠀⢀⡾⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀
9 ⠀⢀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣾⠿⢿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀
10 ⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⡾⠛⢉⣠⣴⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⢿⡄⠐⢦⣤⣤⣴⣾⠿⠛⣁⣤⡾⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠻⢦⣄⣀⠉⣉⣀⣴⠾⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠉⠛⠛⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 TAKE THE GOLD PILL⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16  */
17 // SPDX-License-Identifier: MIT
18 //Developer Info:
19 
20 
21 
22 // File: @openzeppelin/contracts/utils/Strings.sol
23 
24 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev String operations.
30  */
31 library Strings {
32     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
33 
34     /**
35      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
36      */
37     function toString(uint256 value) internal pure returns (string memory) {
38         // Inspired by OraclizeAPI's implementation - MIT licence
39         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
40 
41         if (value == 0) {
42             return "0";
43         }
44         uint256 temp = value;
45         uint256 digits;
46         while (temp != 0) {
47             digits++;
48             temp /= 10;
49         }
50         bytes memory buffer = new bytes(digits);
51         while (value != 0) {
52             digits -= 1;
53             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
54             value /= 10;
55         }
56         return string(buffer);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
61      */
62     function toHexString(uint256 value) internal pure returns (string memory) {
63         if (value == 0) {
64             return "0x00";
65         }
66         uint256 temp = value;
67         uint256 length = 0;
68         while (temp != 0) {
69             length++;
70             temp >>= 8;
71         }
72         return toHexString(value, length);
73     }
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
77      */
78     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
79         bytes memory buffer = new bytes(2 * length + 2);
80         buffer[0] = "0";
81         buffer[1] = "x";
82         for (uint256 i = 2 * length + 1; i > 1; --i) {
83             buffer[i] = _HEX_SYMBOLS[value & 0xf];
84             value >>= 4;
85         }
86         require(value == 0, "Strings: hex length insufficient");
87         return string(buffer);
88     }
89 }
90 
91 // File: @openzeppelin/contracts/utils/Context.sol
92 
93 
94 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes calldata) {
114         return msg.data;
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
577 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
578 
579 
580 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 
585 /**
586  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
587  * @dev See https://eips.ethereum.org/EIPS/eip-721
588  */
589 interface IERC721Metadata is IERC721 {
590     /**
591      * @dev Returns the token collection name.
592      */
593     function name() external view returns (string memory);
594 
595     /**
596      * @dev Returns the token collection symbol.
597      */
598     function symbol() external view returns (string memory);
599 
600     /**
601      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
602      */
603     function tokenURI(uint256 tokenId) external view returns (string memory);
604 }
605 
606 // File: contracts/new.sol
607 
608 
609 
610 
611 pragma solidity ^0.8.4;
612 
613 
614 
615 
616 
617 
618 
619 
620 error ApprovalCallerNotOwnerNorApproved();
621 error ApprovalQueryForNonexistentToken();
622 error ApproveToCaller();
623 error ApprovalToCurrentOwner();
624 error BalanceQueryForZeroAddress();
625 error MintToZeroAddress();
626 error MintZeroQuantity();
627 error OwnerQueryForNonexistentToken();
628 error TransferCallerNotOwnerNorApproved();
629 error TransferFromIncorrectOwner();
630 error TransferToNonERC721ReceiverImplementer();
631 error TransferToZeroAddress();
632 error URIQueryForNonexistentToken();
633 
634 /**
635  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
636  * the Metadata extension. Built to optimize for lower gas during batch mints.
637  *
638  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
639  *
640  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
641  *
642  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
643  */
644 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
645     using Address for address;
646     using Strings for uint256;
647 
648     // Compiler will pack this into a single 256bit word.
649     struct TokenOwnership {
650         // The address of the owner.
651         address addr;
652         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
653         uint64 startTimestamp;
654         // Whether the token has been burned.
655         bool burned;
656     }
657 
658     // Compiler will pack this into a single 256bit word.
659     struct AddressData {
660         // Realistically, 2**64-1 is more than enough.
661         uint64 balance;
662         // Keeps track of mint count with minimal overhead for tokenomics.
663         uint64 numberMinted;
664         // Keeps track of burn count with minimal overhead for tokenomics.
665         uint64 numberBurned;
666         // For miscellaneous variable(s) pertaining to the address
667         // (e.g. number of whitelist mint slots used).
668         // If there are multiple variables, please pack them into a uint64.
669         uint64 aux;
670     }
671 
672     // The tokenId of the next token to be minted.
673     uint256 internal _currentIndex;
674 
675     // The number of tokens burned.
676     uint256 internal _burnCounter;
677 
678     // Token name
679     string private _name;
680 
681     // Token symbol
682     string private _symbol;
683 
684     // Mapping from token ID to ownership details
685     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
686     mapping(uint256 => TokenOwnership) internal _ownerships;
687 
688     // Mapping owner address to address data
689     mapping(address => AddressData) private _addressData;
690 
691     // Mapping from token ID to approved address
692     mapping(uint256 => address) private _tokenApprovals;
693 
694     // Mapping from owner to operator approvals
695     mapping(address => mapping(address => bool)) private _operatorApprovals;
696 
697     constructor(string memory name_, string memory symbol_) {
698         _name = name_;
699         _symbol = symbol_;
700         _currentIndex = _startTokenId();
701     }
702 
703     /**
704      * To change the starting tokenId, please override this function.
705      */
706     function _startTokenId() internal view virtual returns (uint256) {
707         return 0;
708     }
709 
710     /**
711      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
712      */
713     function totalSupply() public view returns (uint256) {
714         // Counter underflow is impossible as _burnCounter cannot be incremented
715         // more than _currentIndex - _startTokenId() times
716         unchecked {
717             return _currentIndex - _burnCounter - _startTokenId();
718         }
719     }
720 
721     /**
722      * Returns the total amount of tokens minted in the contract.
723      */
724     function _totalMinted() internal view returns (uint256) {
725         // Counter underflow is impossible as _currentIndex does not decrement,
726         // and it is initialized to _startTokenId()
727         unchecked {
728             return _currentIndex - _startTokenId();
729         }
730     }
731 
732     /**
733      * @dev See {IERC165-supportsInterface}.
734      */
735     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
736         return
737             interfaceId == type(IERC721).interfaceId ||
738             interfaceId == type(IERC721Metadata).interfaceId ||
739             super.supportsInterface(interfaceId);
740     }
741 
742     /**
743      * @dev See {IERC721-balanceOf}.
744      */
745     function balanceOf(address owner) public view override returns (uint256) {
746         if (owner == address(0)) revert BalanceQueryForZeroAddress();
747         return uint256(_addressData[owner].balance);
748     }
749 
750     /**
751      * Returns the number of tokens minted by `owner`.
752      */
753     function _numberMinted(address owner) internal view returns (uint256) {
754         return uint256(_addressData[owner].numberMinted);
755     }
756 
757     /**
758      * Returns the number of tokens burned by or on behalf of `owner`.
759      */
760     function _numberBurned(address owner) internal view returns (uint256) {
761         return uint256(_addressData[owner].numberBurned);
762     }
763 
764     /**
765      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
766      */
767     function _getAux(address owner) internal view returns (uint64) {
768         return _addressData[owner].aux;
769     }
770 
771     /**
772      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
773      * If there are multiple variables, please pack them into a uint64.
774      */
775     function _setAux(address owner, uint64 aux) internal {
776         _addressData[owner].aux = aux;
777     }
778 
779     /**
780      * Gas spent here starts off proportional to the maximum mint batch size.
781      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
782      */
783     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
784         uint256 curr = tokenId;
785 
786         unchecked {
787             if (_startTokenId() <= curr && curr < _currentIndex) {
788                 TokenOwnership memory ownership = _ownerships[curr];
789                 if (!ownership.burned) {
790                     if (ownership.addr != address(0)) {
791                         return ownership;
792                     }
793                     // Invariant:
794                     // There will always be an ownership that has an address and is not burned
795                     // before an ownership that does not have an address and is not burned.
796                     // Hence, curr will not underflow.
797                     while (true) {
798                         curr--;
799                         ownership = _ownerships[curr];
800                         if (ownership.addr != address(0)) {
801                             return ownership;
802                         }
803                     }
804                 }
805             }
806         }
807         revert OwnerQueryForNonexistentToken();
808     }
809 
810     /**
811      * @dev See {IERC721-ownerOf}.
812      */
813     function ownerOf(uint256 tokenId) public view override returns (address) {
814         return _ownershipOf(tokenId).addr;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-name}.
819      */
820     function name() public view virtual override returns (string memory) {
821         return _name;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-symbol}.
826      */
827     function symbol() public view virtual override returns (string memory) {
828         return _symbol;
829     }
830 
831     /**
832      * @dev See {IERC721Metadata-tokenURI}.
833      */
834     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
835         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
836 
837         string memory baseURI = _baseURI();
838         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
839     }
840 
841     /**
842      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
843      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
844      * by default, can be overriden in child contracts.
845      */
846     function _baseURI() internal view virtual returns (string memory) {
847         return '';
848     }
849 
850     /**
851      * @dev See {IERC721-approve}.
852      */
853     function approve(address to, uint256 tokenId) public override {
854         address owner = ERC721A.ownerOf(tokenId);
855         if (to == owner) revert ApprovalToCurrentOwner();
856 
857         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
858             revert ApprovalCallerNotOwnerNorApproved();
859         }
860 
861         _approve(to, tokenId, owner);
862     }
863 
864     /**
865      * @dev See {IERC721-getApproved}.
866      */
867     function getApproved(uint256 tokenId) public view override returns (address) {
868         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
869 
870         return _tokenApprovals[tokenId];
871     }
872 
873     /**
874      * @dev See {IERC721-setApprovalForAll}.
875      */
876     function setApprovalForAll(address operator, bool approved) public virtual override {
877         if (operator == _msgSender()) revert ApproveToCaller();
878 
879         _operatorApprovals[_msgSender()][operator] = approved;
880         emit ApprovalForAll(_msgSender(), operator, approved);
881     }
882 
883     /**
884      * @dev See {IERC721-isApprovedForAll}.
885      */
886     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
887         return _operatorApprovals[owner][operator];
888     }
889 
890     /**
891      * @dev See {IERC721-transferFrom}.
892      */
893     function transferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         _transfer(from, to, tokenId);
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         safeTransferFrom(from, to, tokenId, '');
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) public virtual override {
921         _transfer(from, to, tokenId);
922         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
923             revert TransferToNonERC721ReceiverImplementer();
924         }
925     }
926 
927     /**
928      * @dev Returns whether `tokenId` exists.
929      *
930      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
931      *
932      * Tokens start existing when they are minted (`_mint`),
933      */
934     function _exists(uint256 tokenId) internal view returns (bool) {
935         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
936             !_ownerships[tokenId].burned;
937     }
938 
939     function _safeMint(address to, uint256 quantity) internal {
940         _safeMint(to, quantity, '');
941     }
942 
943     /**
944      * @dev Safely mints `quantity` tokens and transfers them to `to`.
945      *
946      * Requirements:
947      *
948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
949      * - `quantity` must be greater than 0.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _safeMint(
954         address to,
955         uint256 quantity,
956         bytes memory _data
957     ) internal {
958         _mint(to, quantity, _data, true);
959     }
960 
961     /**
962      * @dev Mints `quantity` tokens and transfers them to `to`.
963      *
964      * Requirements:
965      *
966      * - `to` cannot be the zero address.
967      * - `quantity` must be greater than 0.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _mint(
972         address to,
973         uint256 quantity,
974         bytes memory _data,
975         bool safe
976     ) internal {
977         uint256 startTokenId = _currentIndex;
978         if (to == address(0)) revert MintToZeroAddress();
979         if (quantity == 0) revert MintZeroQuantity();
980 
981         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
982 
983         // Overflows are incredibly unrealistic.
984         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
985         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
986         unchecked {
987             _addressData[to].balance += uint64(quantity);
988             _addressData[to].numberMinted += uint64(quantity);
989 
990             _ownerships[startTokenId].addr = to;
991             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
992 
993             uint256 updatedIndex = startTokenId;
994             uint256 end = updatedIndex + quantity;
995 
996             if (safe && to.isContract()) {
997                 do {
998                     emit Transfer(address(0), to, updatedIndex);
999                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1000                         revert TransferToNonERC721ReceiverImplementer();
1001                     }
1002                 } while (updatedIndex != end);
1003                 // Reentrancy protection
1004                 if (_currentIndex != startTokenId) revert();
1005             } else {
1006                 do {
1007                     emit Transfer(address(0), to, updatedIndex++);
1008                 } while (updatedIndex != end);
1009             }
1010             _currentIndex = updatedIndex;
1011         }
1012         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1013     }
1014 
1015     /**
1016      * @dev Transfers `tokenId` from `from` to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must be owned by `from`.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _transfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) private {
1030         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1031 
1032         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1033 
1034         bool isApprovedOrOwner = (_msgSender() == from ||
1035             isApprovedForAll(from, _msgSender()) ||
1036             getApproved(tokenId) == _msgSender());
1037 
1038         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1039         if (to == address(0)) revert TransferToZeroAddress();
1040 
1041         _beforeTokenTransfers(from, to, tokenId, 1);
1042 
1043         // Clear approvals from the previous owner
1044         _approve(address(0), tokenId, from);
1045 
1046         // Underflow of the sender's balance is impossible because we check for
1047         // ownership above and the recipient's balance can't realistically overflow.
1048         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1049         unchecked {
1050             _addressData[from].balance -= 1;
1051             _addressData[to].balance += 1;
1052 
1053             TokenOwnership storage currSlot = _ownerships[tokenId];
1054             currSlot.addr = to;
1055             currSlot.startTimestamp = uint64(block.timestamp);
1056 
1057             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1058             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1059             uint256 nextTokenId = tokenId + 1;
1060             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1061             if (nextSlot.addr == address(0)) {
1062                 // This will suffice for checking _exists(nextTokenId),
1063                 // as a burned slot cannot contain the zero address.
1064                 if (nextTokenId != _currentIndex) {
1065                     nextSlot.addr = from;
1066                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1067                 }
1068             }
1069         }
1070 
1071         emit Transfer(from, to, tokenId);
1072         _afterTokenTransfers(from, to, tokenId, 1);
1073     }
1074 
1075     /**
1076      * @dev This is equivalent to _burn(tokenId, false)
1077      */
1078     function _burn(uint256 tokenId) internal virtual {
1079         _burn(tokenId, false);
1080     }
1081 
1082     /**
1083      * @dev Destroys `tokenId`.
1084      * The approval is cleared when the token is burned.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1093         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1094 
1095         address from = prevOwnership.addr;
1096 
1097         if (approvalCheck) {
1098             bool isApprovedOrOwner = (_msgSender() == from ||
1099                 isApprovedForAll(from, _msgSender()) ||
1100                 getApproved(tokenId) == _msgSender());
1101 
1102             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1103         }
1104 
1105         _beforeTokenTransfers(from, address(0), tokenId, 1);
1106 
1107         // Clear approvals from the previous owner
1108         _approve(address(0), tokenId, from);
1109 
1110         // Underflow of the sender's balance is impossible because we check for
1111         // ownership above and the recipient's balance can't realistically overflow.
1112         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1113         unchecked {
1114             AddressData storage addressData = _addressData[from];
1115             addressData.balance -= 1;
1116             addressData.numberBurned += 1;
1117 
1118             // Keep track of who burned the token, and the timestamp of burning.
1119             TokenOwnership storage currSlot = _ownerships[tokenId];
1120             currSlot.addr = from;
1121             currSlot.startTimestamp = uint64(block.timestamp);
1122             currSlot.burned = true;
1123 
1124             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1125             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1126             uint256 nextTokenId = tokenId + 1;
1127             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1128             if (nextSlot.addr == address(0)) {
1129                 // This will suffice for checking _exists(nextTokenId),
1130                 // as a burned slot cannot contain the zero address.
1131                 if (nextTokenId != _currentIndex) {
1132                     nextSlot.addr = from;
1133                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1134                 }
1135             }
1136         }
1137 
1138         emit Transfer(from, address(0), tokenId);
1139         _afterTokenTransfers(from, address(0), tokenId, 1);
1140 
1141         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1142         unchecked {
1143             _burnCounter++;
1144         }
1145     }
1146 
1147     /**
1148      * @dev Approve `to` to operate on `tokenId`
1149      *
1150      * Emits a {Approval} event.
1151      */
1152     function _approve(
1153         address to,
1154         uint256 tokenId,
1155         address owner
1156     ) private {
1157         _tokenApprovals[tokenId] = to;
1158         emit Approval(owner, to, tokenId);
1159     }
1160 
1161     /**
1162      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1163      *
1164      * @param from address representing the previous owner of the given token ID
1165      * @param to target address that will receive the tokens
1166      * @param tokenId uint256 ID of the token to be transferred
1167      * @param _data bytes optional data to send along with the call
1168      * @return bool whether the call correctly returned the expected magic value
1169      */
1170     function _checkContractOnERC721Received(
1171         address from,
1172         address to,
1173         uint256 tokenId,
1174         bytes memory _data
1175     ) private returns (bool) {
1176         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1177             return retval == IERC721Receiver(to).onERC721Received.selector;
1178         } catch (bytes memory reason) {
1179             if (reason.length == 0) {
1180                 revert TransferToNonERC721ReceiverImplementer();
1181             } else {
1182                 assembly {
1183                     revert(add(32, reason), mload(reason))
1184                 }
1185             }
1186         }
1187     }
1188 
1189     /**
1190      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1191      * And also called before burning one token.
1192      *
1193      * startTokenId - the first token id to be transferred
1194      * quantity - the amount to be transferred
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` will be minted for `to`.
1201      * - When `to` is zero, `tokenId` will be burned by `from`.
1202      * - `from` and `to` are never both zero.
1203      */
1204     function _beforeTokenTransfers(
1205         address from,
1206         address to,
1207         uint256 startTokenId,
1208         uint256 quantity
1209     ) internal virtual {}
1210 
1211     /**
1212      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1213      * minting.
1214      * And also called after one token has been burned.
1215      *
1216      * startTokenId - the first token id to be transferred
1217      * quantity - the amount to be transferred
1218      *
1219      * Calling conditions:
1220      *
1221      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1222      * transferred to `to`.
1223      * - When `from` is zero, `tokenId` has been minted for `to`.
1224      * - When `to` is zero, `tokenId` has been burned by `from`.
1225      * - `from` and `to` are never both zero.
1226      */
1227     function _afterTokenTransfers(
1228         address from,
1229         address to,
1230         uint256 startTokenId,
1231         uint256 quantity
1232     ) internal virtual {}
1233 }
1234 
1235 abstract contract Ownable is Context {
1236     address private _owner;
1237 
1238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1239 
1240     /**
1241      * @dev Initializes the contract setting the deployer as the initial owner.
1242      */
1243     constructor() {
1244         _transferOwnership(_msgSender());
1245     }
1246 
1247     /**
1248      * @dev Returns the address of the current owner.
1249      */
1250     function owner() public view virtual returns (address) {
1251         return _owner;
1252     }
1253 
1254     /**
1255      * @dev Throws if called by any account other than the owner.
1256      */
1257     modifier onlyOwner() {
1258         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1259         _;
1260     }
1261 
1262     /**
1263      * @dev Leaves the contract without owner. It will not be possible to call
1264      * `onlyOwner` functions anymore. Can only be called by the current owner.
1265      *
1266      * NOTE: Renouncing ownership will leave the contract without an owner,
1267      * thereby removing any functionality that is only available to the owner.
1268      */
1269     function renounceOwnership() public virtual onlyOwner {
1270         _transferOwnership(address(0));
1271     }
1272 
1273     /**
1274      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1275      * Can only be called by the current owner.
1276      */
1277     function transferOwnership(address newOwner) public virtual onlyOwner {
1278         require(newOwner != address(0), "Ownable: new owner is the zero address");
1279         _transferOwnership(newOwner);
1280     }
1281 
1282     /**
1283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1284      * Internal function without access restriction.
1285      */
1286     function _transferOwnership(address newOwner) internal virtual {
1287         address oldOwner = _owner;
1288         _owner = newOwner;
1289         emit OwnershipTransferred(oldOwner, newOwner);
1290     }
1291 }
1292 pragma solidity ^0.8.13;
1293 
1294 interface IOperatorFilterRegistry {
1295     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1296     function register(address registrant) external;
1297     function registerAndSubscribe(address registrant, address subscription) external;
1298     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1299     function updateOperator(address registrant, address operator, bool filtered) external;
1300     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1301     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1302     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1303     function subscribe(address registrant, address registrantToSubscribe) external;
1304     function unsubscribe(address registrant, bool copyExistingEntries) external;
1305     function subscriptionOf(address addr) external returns (address registrant);
1306     function subscribers(address registrant) external returns (address[] memory);
1307     function subscriberAt(address registrant, uint256 index) external returns (address);
1308     function copyEntriesOf(address registrant, address registrantToCopy) external;
1309     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1310     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1311     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1312     function filteredOperators(address addr) external returns (address[] memory);
1313     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1314     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1315     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1316     function isRegistered(address addr) external returns (bool);
1317     function codeHashOf(address addr) external returns (bytes32);
1318 }
1319 pragma solidity ^0.8.13;
1320 
1321 
1322 
1323 abstract contract OperatorFilterer {
1324     error OperatorNotAllowed(address operator);
1325 
1326     IOperatorFilterRegistry constant operatorFilterRegistry =
1327         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1328 
1329     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1330         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1331         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1332         // order for the modifier to filter addresses.
1333         if (address(operatorFilterRegistry).code.length > 0) {
1334             if (subscribe) {
1335                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1336             } else {
1337                 if (subscriptionOrRegistrantToCopy != address(0)) {
1338                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1339                 } else {
1340                     operatorFilterRegistry.register(address(this));
1341                 }
1342             }
1343         }
1344     }
1345 
1346     modifier onlyAllowedOperator(address from) virtual {
1347         // Check registry code length to facilitate testing in environments without a deployed registry.
1348         if (address(operatorFilterRegistry).code.length > 0) {
1349             // Allow spending tokens from addresses with balance
1350             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1351             // from an EOA.
1352             if (from == msg.sender) {
1353                 _;
1354                 return;
1355             }
1356             if (
1357                 !(
1358                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1359                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1360                 )
1361             ) {
1362                 revert OperatorNotAllowed(msg.sender);
1363             }
1364         }
1365         _;
1366     }
1367 }
1368 pragma solidity ^0.8.13;
1369 
1370 
1371 
1372 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1373     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1374 
1375     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1376 }
1377     pragma solidity ^0.8.7;
1378     
1379     contract TheGoldPillNFT is ERC721A, DefaultOperatorFilterer , Ownable {
1380     using Strings for uint256;
1381 
1382 
1383   string private uriPrefix ;
1384   string private uriSuffix = ".json";
1385   string public hiddenURL;
1386 
1387   
1388   
1389 
1390   uint256 public cost = 0.1 ether;
1391  
1392   
1393 
1394   uint16 public maxSupply = 1000;
1395   uint8 public maxMintAmountPerTx = 1;
1396     uint8 public maxFreeMintAmountPerWallet = 1;
1397                                                              
1398  
1399   bool public paused = true;
1400   bool public reveal =false;
1401 
1402    mapping (address => uint8) public NFTPerPublicAddress;
1403 
1404  
1405   
1406   
1407  
1408   
1409 
1410   constructor() ERC721A("The Gold Pill NFT", "GOLD") {
1411   }
1412 
1413 
1414   
1415  
1416   function mint(uint8 _mintAmount) external payable  {
1417      uint16 totalSupply = uint16(totalSupply());
1418      uint8 nft = NFTPerPublicAddress[msg.sender];
1419     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1420     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1421     require(msg.sender == tx.origin , "No Bots Allowed");
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