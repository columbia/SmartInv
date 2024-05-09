1 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
2 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
3 //@@@@@@@@@@@@@@@@@@##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 //@@@@@@@@@@@@@@  @@@@    *@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@              .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 //@@@@@@@@@@@#   @@@@@@@@@   @@ /@@@@@@@@@@@@@@        @@      @@@@@@@@@@@@ /@@@    @@@@@ @@@@@   @@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 //@@@@@@@@@@*  @@@@@@@@@@@@  @@ @@@      @@@@@  @@@@@   @@  @@   @@@@@@@    #@@@@   @@@@@@@@      @@      @@@@@@@@@@@@@@@@@/@@@@@@@@@  @@@@@@@@@@  @@@@@@
7 //@@@@@@@@@@  @@@@@@@@@@@@@         @@@    # @@@@@@@@.  @@  (@@  @@@@@  @@@@@@@   @@@@@@@@    @@@@@@@@@   @@@@@@@  @@@@@@@@   @@@@@       @@@@@@  @@@@@@@@
8 //@@@@@@@@@@   @@@@@@@@@@@@      @@@@@@@@@@   @@@@@@@@@   @/  @@  @@@/   @@@@@@@@  @@@@@@@   .@@@@@@@@@@@@   @@@@@@  (@@@@@@  @@@@  @@@  @@@@@@  @@@@@@@@@
9 //@@@@@@@@@@@            ,@@@   @@@@@@@@@@@@   @@@@@@@@@  @@  @@@  @@@  @@@@@@@@   @@@@@@@@  @@@@@@@@@@@@@   @@@@@     @@@@@  @@@@  @@@@  @@@@   @@@@@@@@@
10 //@@@@@@@@@@@@@@@@@@@@@@@@@@%  @@@@@@@@@@@@@  % @@@@@@  @@@  @@@@  @@  &@@@@@@@    @@@@@@@@    @@@@@@@@@@ @   @@@*  @   @@@@. @@@  @@@@@@   @@  @@@@@@@@@@
11 //@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@               @@  @@@@@    @@ @@@@@@@@@@@@@@@@@       @@@@@   @@@   @@  @@     @@  @@@   @@@@@@  @  @@@@@@@@@@@
12 //@@@@@@@@@@ %@@@@@@@@@@@@@@      @@@@@@@  &@@( @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           @@@@@    @@@@@@@    @@   @@@@@@@@   @@@@@@@@@@@@
13 //@@@@@@@@@@@@      .@@@@@@  @@@           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 //@@@@@@@@@@@@@@@@@         %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2022-05-27
19 */
20 
21 // SPDX-License-Identifier: MIT
22 
23 // File: @openzeppelin/contracts/utils/Strings.sol
24 
25 
26 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev String operations.
32  */
33 library Strings {
34     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
38      */
39     function toString(uint256 value) internal pure returns (string memory) {
40         // Inspired by OraclizeAPI's implementation - MIT licence
41         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
42 
43         if (value == 0) {
44             return "0";
45         }
46         uint256 temp = value;
47         uint256 digits;
48         while (temp != 0) {
49             digits++;
50             temp /= 10;
51         }
52         bytes memory buffer = new bytes(digits);
53         while (value != 0) {
54             digits -= 1;
55             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
56             value /= 10;
57         }
58         return string(buffer);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
63      */
64     function toHexString(uint256 value) internal pure returns (string memory) {
65         if (value == 0) {
66             return "0x00";
67         }
68         uint256 temp = value;
69         uint256 length = 0;
70         while (temp != 0) {
71             length++;
72             temp >>= 8;
73         }
74         return toHexString(value, length);
75     }
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
79      */
80     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 }
92 
93 // File: @openzeppelin/contracts/utils/Context.sol
94 
95 
96 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Provides information about the current execution context, including the
102  * sender of the transaction and its data. While these are generally available
103  * via msg.sender and msg.data, they should not be accessed in such a direct
104  * manner, since when dealing with meta-transactions the account sending and
105  * paying for execution may not be the actual sender (as far as an application
106  * is concerned).
107  *
108  * This contract is only required for intermediate, library-like contracts.
109  */
110 abstract contract Context {
111     function _msgSender() internal view virtual returns (address) {
112         return msg.sender;
113     }
114 
115     function _msgData() internal view virtual returns (bytes calldata) {
116         return msg.data;
117     }
118 }
119 
120 // File: @openzeppelin/contracts/utils/Address.sol
121 
122 
123 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
124 
125 pragma solidity ^0.8.1;
126 
127 /**
128  * @dev Collection of functions related to the address type
129  */
130 library Address {
131     /**
132      * @dev Returns true if `account` is a contract.
133      *
134      * [IMPORTANT]
135      * ====
136      * It is unsafe to assume that an address for which this function returns
137      * false is an externally-owned account (EOA) and not a contract.
138      *
139      * Among others, `isContract` will return false for the following
140      * types of addresses:
141      *
142      *  - an externally-owned account
143      *  - a contract in construction
144      *  - an address where a contract will be created
145      *  - an address where a contract lived, but was destroyed
146      * ====
147      *
148      * [IMPORTANT]
149      * ====
150      * You shouldn't rely on `isContract` to protect against flash loan attacks!
151      *
152      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
153      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
154      * constructor.
155      * ====
156      */
157     function isContract(address account) internal view returns (bool) {
158         // This method relies on extcodesize/address.code.length, which returns 0
159         // for contracts in construction, since the code is only stored at the end
160         // of the constructor execution.
161 
162         return account.code.length > 0;
163     }
164 
165     /**
166      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
167      * `recipient`, forwarding all available gas and reverting on errors.
168      *
169      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
170      * of certain opcodes, possibly making contracts go over the 2300 gas limit
171      * imposed by `transfer`, making them unable to receive funds via
172      * `transfer`. {sendValue} removes this limitation.
173      *
174      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
175      *
176      * IMPORTANT: because control is transferred to `recipient`, care must be
177      * taken to not create reentrancy vulnerabilities. Consider using
178      * {ReentrancyGuard} or the
179      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
180      */
181     function sendValue(address payable recipient, uint256 amount) internal {
182         require(address(this).balance >= amount, "Address: insufficient balance");
183 
184         (bool success, ) = recipient.call{value: amount}("");
185         require(success, "Address: unable to send value, recipient may have reverted");
186     }
187 
188     /**
189      * @dev Performs a Solidity function call using a low level `call`. A
190      * plain `call` is an unsafe replacement for a function call: use this
191      * function instead.
192      *
193      * If `target` reverts with a revert reason, it is bubbled up by this
194      * function (like regular Solidity function calls).
195      *
196      * Returns the raw returned data. To convert to the expected return value,
197      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
198      *
199      * Requirements:
200      *
201      * - `target` must be a contract.
202      * - calling `target` with `data` must not revert.
203      *
204      * _Available since v3.1._
205      */
206     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
207         return functionCall(target, data, "Address: low-level call failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
212      * `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCall(
217         address target,
218         bytes memory data,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, 0, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but also transferring `value` wei to `target`.
227      *
228      * Requirements:
229      *
230      * - the calling contract must have an ETH balance of at least `value`.
231      * - the called Solidity function must be `payable`.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(
236         address target,
237         bytes memory data,
238         uint256 value
239     ) internal returns (bytes memory) {
240         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
245      * with `errorMessage` as a fallback revert reason when `target` reverts.
246      *
247      * _Available since v3.1._
248      */
249     function functionCallWithValue(
250         address target,
251         bytes memory data,
252         uint256 value,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(address(this).balance >= value, "Address: insufficient balance for call");
256         require(isContract(target), "Address: call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.call{value: value}(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a static call.
265      *
266      * _Available since v3.3._
267      */
268     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
269         return functionStaticCall(target, data, "Address: low-level static call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
274      * but performing a static call.
275      *
276      * _Available since v3.3._
277      */
278     function functionStaticCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal view returns (bytes memory) {
283         require(isContract(target), "Address: static call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.staticcall(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but performing a delegate call.
292      *
293      * _Available since v3.4._
294      */
295     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
296         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
301      * but performing a delegate call.
302      *
303      * _Available since v3.4._
304      */
305     function functionDelegateCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         require(isContract(target), "Address: delegate call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.delegatecall(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
318      * revert reason using the provided one.
319      *
320      * _Available since v4.3._
321      */
322     function verifyCallResult(
323         bool success,
324         bytes memory returndata,
325         string memory errorMessage
326     ) internal pure returns (bytes memory) {
327         if (success) {
328             return returndata;
329         } else {
330             // Look for revert reason and bubble it up if present
331             if (returndata.length > 0) {
332                 // The easiest way to bubble the revert reason is using memory via assembly
333 
334                 assembly {
335                     let returndata_size := mload(returndata)
336                     revert(add(32, returndata), returndata_size)
337                 }
338             } else {
339                 revert(errorMessage);
340             }
341         }
342     }
343 }
344 
345 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
346 
347 
348 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @title ERC721 token receiver interface
354  * @dev Interface for any contract that wants to support safeTransfers
355  * from ERC721 asset contracts.
356  */
357 interface IERC721Receiver {
358     /**
359      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
360      * by `operator` from `from`, this function is called.
361      *
362      * It must return its Solidity selector to confirm the token transfer.
363      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
364      *
365      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
366      */
367     function onERC721Received(
368         address operator,
369         address from,
370         uint256 tokenId,
371         bytes calldata data
372     ) external returns (bytes4);
373 }
374 
375 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
376 
377 
378 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @dev Interface of the ERC165 standard, as defined in the
384  * https://eips.ethereum.org/EIPS/eip-165[EIP].
385  *
386  * Implementers can declare support of contract interfaces, which can then be
387  * queried by others ({ERC165Checker}).
388  *
389  * For an implementation, see {ERC165}.
390  */
391 interface IERC165 {
392     /**
393      * @dev Returns true if this contract implements the interface defined by
394      * `interfaceId`. See the corresponding
395      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
396      * to learn more about how these ids are created.
397      *
398      * This function call must use less than 30 000 gas.
399      */
400     function supportsInterface(bytes4 interfaceId) external view returns (bool);
401 }
402 
403 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
404 
405 
406 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 
411 /**
412  * @dev Implementation of the {IERC165} interface.
413  *
414  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
415  * for the additional interface id that will be supported. For example:
416  *
417  * ```solidity
418  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
419  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
420  * }
421  * ```
422  *
423  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
424  */
425 abstract contract ERC165 is IERC165 {
426     /**
427      * @dev See {IERC165-supportsInterface}.
428      */
429     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
430         return interfaceId == type(IERC165).interfaceId;
431     }
432 }
433 
434 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
435 
436 
437 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 
442 /**
443  * @dev Required interface of an ERC721 compliant contract.
444  */
445 interface IERC721 is IERC165 {
446     /**
447      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
448      */
449     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
450 
451     /**
452      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
453      */
454     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
455 
456     /**
457      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
458      */
459     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
460 
461     /**
462      * @dev Returns the number of tokens in ``owner``'s account.
463      */
464     function balanceOf(address owner) external view returns (uint256 balance);
465 
466     /**
467      * @dev Returns the owner of the `tokenId` token.
468      *
469      * Requirements:
470      *
471      * - `tokenId` must exist.
472      */
473     function ownerOf(uint256 tokenId) external view returns (address owner);
474 
475     /**
476      * @dev Safely transfers `tokenId` token from `from` to `to`.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must exist and be owned by `from`.
483      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
484      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
485      *
486      * Emits a {Transfer} event.
487      */
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId,
492         bytes calldata data
493     ) external;
494 
495     /**
496      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
497      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external;
514 
515     /**
516      * @dev Transfers `tokenId` token from `from` to `to`.
517      *
518      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must be owned by `from`.
525      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
526      *
527      * Emits a {Transfer} event.
528      */
529     function transferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
537      * The approval is cleared when the token is transferred.
538      *
539      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
540      *
541      * Requirements:
542      *
543      * - The caller must own the token or be an approved operator.
544      * - `tokenId` must exist.
545      *
546      * Emits an {Approval} event.
547      */
548     function approve(address to, uint256 tokenId) external;
549 
550     /**
551      * @dev Approve or remove `operator` as an operator for the caller.
552      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
553      *
554      * Requirements:
555      *
556      * - The `operator` cannot be the caller.
557      *
558      * Emits an {ApprovalForAll} event.
559      */
560     function setApprovalForAll(address operator, bool _approved) external;
561 
562     /**
563      * @dev Returns the account approved for `tokenId` token.
564      *
565      * Requirements:
566      *
567      * - `tokenId` must exist.
568      */
569     function getApproved(uint256 tokenId) external view returns (address operator);
570 
571     /**
572      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
573      *
574      * See {setApprovalForAll}
575      */
576     function isApprovedForAll(address owner, address operator) external view returns (bool);
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
589  * @dev See https://eips.ethereum.org/EIPS/eip-721
590  */
591 interface IERC721Enumerable is IERC721 {
592     /**
593      * @dev Returns the total amount of tokens stored by the contract.
594      */
595     function totalSupply() external view returns (uint256);
596 
597     /**
598      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
599      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
600      */
601     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
602 
603     /**
604      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
605      * Use along with {totalSupply} to enumerate all tokens.
606      */
607     function tokenByIndex(uint256 index) external view returns (uint256);
608 }
609 
610 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 
618 /**
619  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
620  * @dev See https://eips.ethereum.org/EIPS/eip-721
621  */
622 interface IERC721Metadata is IERC721 {
623     /**
624      * @dev Returns the token collection name.
625      */
626     function name() external view returns (string memory);
627 
628     /**
629      * @dev Returns the token collection symbol.
630      */
631     function symbol() external view returns (string memory);
632 
633     /**
634      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
635      */
636     function tokenURI(uint256 tokenId) external view returns (string memory);
637 }
638 
639 // File: ERC721A.sol
640 
641 
642 // Creator: Chiru Labs
643 
644 pragma solidity ^0.8.0;
645 
646 
647 
648 
649 
650 
651 
652 
653 
654 /**
655  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
656  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
657  *
658  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
659  *
660  * Does not support burning tokens to address(0).
661  *
662  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
663  */
664 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
665     using Address for address;
666     using Strings for uint256;
667 
668     struct TokenOwnership {
669         address addr;
670         uint64 startTimestamp;
671     }
672 
673     struct AddressData {
674         uint128 balance;
675         uint128 numberMinted;
676     }
677 
678     uint256 internal currentIndex;
679 
680     // Token name
681     string private _name;
682 
683     // Token symbol
684     string private _symbol;
685 
686     // Mapping from token ID to ownership details
687     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
688     mapping(uint256 => TokenOwnership) internal _ownerships;
689 
690     // Mapping owner address to address data
691     mapping(address => AddressData) private _addressData;
692 
693     // Mapping from token ID to approved address
694     mapping(uint256 => address) private _tokenApprovals;
695 
696     // Mapping from owner to operator approvals
697     mapping(address => mapping(address => bool)) private _operatorApprovals;
698 
699     constructor(string memory name_, string memory symbol_) {
700         _name = name_;
701         _symbol = symbol_;
702     }
703 
704     /**
705      * @dev See {IERC721Enumerable-totalSupply}.
706      */
707     function totalSupply() public view override returns (uint256) {
708         return currentIndex;
709     }
710 
711     /**
712      * @dev See {IERC721Enumerable-tokenByIndex}.
713      */
714     function tokenByIndex(uint256 index) public view override returns (uint256) {
715         require(index < totalSupply(), 'ERC721A: global index out of bounds');
716         return index;
717     }
718 
719     /**
720      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
721      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
722      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
723      */
724     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
725         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
726         uint256 numMintedSoFar = totalSupply();
727         uint256 tokenIdsIdx;
728         address currOwnershipAddr;
729 
730         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
731         unchecked {
732             for (uint256 i; i < numMintedSoFar; i++) {
733                 TokenOwnership memory ownership = _ownerships[i];
734                 if (ownership.addr != address(0)) {
735                     currOwnershipAddr = ownership.addr;
736                 }
737                 if (currOwnershipAddr == owner) {
738                     if (tokenIdsIdx == index) {
739                         return i;
740                     }
741                     tokenIdsIdx++;
742                 }
743             }
744         }
745 
746         revert('ERC721A: unable to get token of owner by index');
747     }
748 
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
753         return
754             interfaceId == type(IERC721).interfaceId ||
755             interfaceId == type(IERC721Metadata).interfaceId ||
756             interfaceId == type(IERC721Enumerable).interfaceId ||
757             super.supportsInterface(interfaceId);
758     }
759 
760     /**
761      * @dev See {IERC721-balanceOf}.
762      */
763     function balanceOf(address owner) public view override returns (uint256) {
764         require(owner != address(0), 'ERC721A: balance query for the zero address');
765         return uint256(_addressData[owner].balance);
766     }
767 
768     function _numberMinted(address owner) internal view returns (uint256) {
769         require(owner != address(0), 'ERC721A: number minted query for the zero address');
770         return uint256(_addressData[owner].numberMinted);
771     }
772 
773     /**
774      * Gas spent here starts off proportional to the maximum mint batch size.
775      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
776      */
777     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
778         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
779 
780         unchecked {
781             for (uint256 curr = tokenId; curr >= 0; curr--) {
782                 TokenOwnership memory ownership = _ownerships[curr];
783                 if (ownership.addr != address(0)) {
784                     return ownership;
785                 }
786             }
787         }
788 
789         revert('ERC721A: unable to determine the owner of token');
790     }
791 
792     /**
793      * @dev See {IERC721-ownerOf}.
794      */
795     function ownerOf(uint256 tokenId) public view override returns (address) {
796         return ownershipOf(tokenId).addr;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-name}.
801      */
802     function name() public view virtual override returns (string memory) {
803         return _name;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-symbol}.
808      */
809     function symbol() public view virtual override returns (string memory) {
810         return _symbol;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-tokenURI}.
815      */
816     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
817         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
818 
819         string memory baseURI = _baseURI();
820         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
821     }
822 
823     /**
824      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
825      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
826      * by default, can be overriden in child contracts.
827      */
828     function _baseURI() internal view virtual returns (string memory) {
829         return '';
830     }
831 
832     /**
833      * @dev See {IERC721-approve}.
834      */
835     function approve(address to, uint256 tokenId) public override {
836         address owner = ERC721A.ownerOf(tokenId);
837         require(to != owner, 'ERC721A: approval to current owner');
838 
839         require(
840             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
841             'ERC721A: approve caller is not owner nor approved for all'
842         );
843 
844         _approve(to, tokenId, owner);
845     }
846 
847     /**
848      * @dev See {IERC721-getApproved}.
849      */
850     function getApproved(uint256 tokenId) public view override returns (address) {
851         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
852 
853         return _tokenApprovals[tokenId];
854     }
855 
856     /**
857      * @dev See {IERC721-setApprovalForAll}.
858      */
859     function setApprovalForAll(address operator, bool approved) public override {
860         require(operator != _msgSender(), 'ERC721A: approve to caller');
861 
862         _operatorApprovals[_msgSender()][operator] = approved;
863         emit ApprovalForAll(_msgSender(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public override {
881         _transfer(from, to, tokenId);
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) public override {
892         safeTransferFrom(from, to, tokenId, '');
893     }
894 
895     /**
896      * @dev See {IERC721-safeTransferFrom}.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) public override {
904         _transfer(from, to, tokenId);
905         require(
906             _checkOnERC721Received(from, to, tokenId, _data),
907             'ERC721A: transfer to non ERC721Receiver implementer'
908         );
909     }
910 
911     /**
912      * @dev Returns whether `tokenId` exists.
913      *
914      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
915      *
916      * Tokens start existing when they are minted (`_mint`),
917      */
918     function _exists(uint256 tokenId) internal view returns (bool) {
919         return tokenId < currentIndex;
920     }
921 
922     function _safeMint(address to, uint256 quantity) internal {
923         _safeMint(to, quantity, '');
924     }
925 
926     /**
927      * @dev Safely mints `quantity` tokens and transfers them to `to`.
928      *
929      * Requirements:
930      *
931      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
932      * - `quantity` must be greater than 0.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _safeMint(
937         address to,
938         uint256 quantity,
939         bytes memory _data
940     ) internal {
941         _mint(to, quantity, _data, true);
942     }
943 
944     /**
945      * @dev Mints `quantity` tokens and transfers them to `to`.
946      *
947      * Requirements:
948      *
949      * - `to` cannot be the zero address.
950      * - `quantity` must be greater than 0.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _mint(
955         address to,
956         uint256 quantity,
957         bytes memory _data,
958         bool safe
959     ) internal {
960         uint256 startTokenId = currentIndex;
961         require(to != address(0), 'ERC721A: mint to the zero address');
962         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
963 
964         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
965 
966         // Overflows are incredibly unrealistic.
967         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
968         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
969         unchecked {
970             _addressData[to].balance += uint128(quantity);
971             _addressData[to].numberMinted += uint128(quantity);
972 
973             _ownerships[startTokenId].addr = to;
974             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
975 
976             uint256 updatedIndex = startTokenId;
977 
978             for (uint256 i; i < quantity; i++) {
979                 emit Transfer(address(0), to, updatedIndex);
980                 if (safe) {
981                     require(
982                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
983                         'ERC721A: transfer to non ERC721Receiver implementer'
984                     );
985                 }
986 
987                 updatedIndex++;
988             }
989 
990             currentIndex = updatedIndex;
991         }
992 
993         _afterTokenTransfers(address(0), to, startTokenId, quantity);
994     }
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must be owned by `from`.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _transfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) private {
1011         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1012 
1013         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1014             getApproved(tokenId) == _msgSender() ||
1015             isApprovedForAll(prevOwnership.addr, _msgSender()));
1016 
1017         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1018 
1019         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1020         require(to != address(0), 'ERC721A: transfer to the zero address');
1021 
1022         _beforeTokenTransfers(from, to, tokenId, 1);
1023 
1024         // Clear approvals from the previous owner
1025         _approve(address(0), tokenId, prevOwnership.addr);
1026 
1027         // Underflow of the sender's balance is impossible because we check for
1028         // ownership above and the recipient's balance can't realistically overflow.
1029         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1030         unchecked {
1031             _addressData[from].balance -= 1;
1032             _addressData[to].balance += 1;
1033 
1034             _ownerships[tokenId].addr = to;
1035             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1036 
1037             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1038             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1039             uint256 nextTokenId = tokenId + 1;
1040             if (_ownerships[nextTokenId].addr == address(0)) {
1041                 if (_exists(nextTokenId)) {
1042                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1043                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1044                 }
1045             }
1046         }
1047 
1048         emit Transfer(from, to, tokenId);
1049         _afterTokenTransfers(from, to, tokenId, 1);
1050     }
1051 
1052     /**
1053      * @dev Approve `to` to operate on `tokenId`
1054      *
1055      * Emits a {Approval} event.
1056      */
1057     function _approve(
1058         address to,
1059         uint256 tokenId,
1060         address owner
1061     ) private {
1062         _tokenApprovals[tokenId] = to;
1063         emit Approval(owner, to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1068      * The call is not executed if the target address is not a contract.
1069      *
1070      * @param from address representing the previous owner of the given token ID
1071      * @param to target address that will receive the tokens
1072      * @param tokenId uint256 ID of the token to be transferred
1073      * @param _data bytes optional data to send along with the call
1074      * @return bool whether the call correctly returned the expected magic value
1075      */
1076     function _checkOnERC721Received(
1077         address from,
1078         address to,
1079         uint256 tokenId,
1080         bytes memory _data
1081     ) private returns (bool) {
1082         if (to.isContract()) {
1083             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1084                 return retval == IERC721Receiver(to).onERC721Received.selector;
1085             } catch (bytes memory reason) {
1086                 if (reason.length == 0) {
1087                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1088                 } else {
1089                     assembly {
1090                         revert(add(32, reason), mload(reason))
1091                     }
1092                 }
1093             }
1094         } else {
1095             return true;
1096         }
1097     }
1098 
1099     /**
1100      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1101      *
1102      * startTokenId - the first token id to be transferred
1103      * quantity - the amount to be transferred
1104      *
1105      * Calling conditions:
1106      *
1107      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1108      * transferred to `to`.
1109      * - When `from` is zero, `tokenId` will be minted for `to`.
1110      */
1111     function _beforeTokenTransfers(
1112         address from,
1113         address to,
1114         uint256 startTokenId,
1115         uint256 quantity
1116     ) internal virtual {}
1117 
1118     /**
1119      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1120      * minting.
1121      *
1122      * startTokenId - the first token id to be transferred
1123      * quantity - the amount to be transferred
1124      *
1125      * Calling conditions:
1126      *
1127      * - when `from` and `to` are both non-zero.
1128      * - `from` and `to` are never both zero.
1129      */
1130     function _afterTokenTransfers(
1131         address from,
1132         address to,
1133         uint256 startTokenId,
1134         uint256 quantity
1135     ) internal virtual {}
1136 }
1137 // File: goontown-contract.sol
1138 
1139 
1140 
1141 pragma solidity ^0.8.0;
1142 
1143 /**
1144  * @dev Contract module which allows children to implement an emergency stop
1145  * mechanism that can be triggered by an authorized account.
1146  *
1147  * This module is used through inheritance. It will make available the
1148  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1149  * the functions of your contract. Note that they will not be pausable by
1150  * simply including this module, only once the modifiers are put in place.
1151  */
1152 abstract contract Pausable is Context {
1153     /**
1154      * @dev Emitted when the pause is triggered by `account`.
1155      */
1156     event Paused(address account);
1157 
1158     /**
1159      * @dev Emitted when the pause is lifted by `account`.
1160      */
1161     event Unpaused(address account);
1162 
1163     bool private _paused;
1164 
1165     /**
1166      * @dev Initializes the contract in unpaused state.
1167      */
1168     constructor() {
1169         _paused = false;
1170     }
1171 
1172     /**
1173      * @dev Returns true if the contract is paused, and false otherwise.
1174      */
1175     function paused() public view virtual returns (bool) {
1176         return _paused;
1177     }
1178 
1179     /**
1180      * @dev Modifier to make a function callable only when the contract is not paused.
1181      *
1182      * Requirements:
1183      *
1184      * - The contract must not be paused.
1185      */
1186     modifier whenNotPaused() {
1187         require(!paused(), "Pausable: paused");
1188         _;
1189     }
1190 
1191     /**
1192      * @dev Modifier to make a function callable only when the contract is paused.
1193      *
1194      * Requirements:
1195      *
1196      * - The contract must be paused.
1197      */
1198     modifier whenPaused() {
1199         require(paused(), "Pausable: not paused");
1200         _;
1201     }
1202 
1203     /**
1204      * @dev Triggers stopped state.
1205      *
1206      * Requirements:
1207      *
1208      * - The contract must not be paused.
1209      */
1210     function _pause() internal virtual whenNotPaused {
1211         _paused = true;
1212         emit Paused(_msgSender());
1213     }
1214 
1215     /**
1216      * @dev Returns to normal state.
1217      *
1218      * Requirements:
1219      *
1220      * - The contract must be paused.
1221      */
1222     function _unpause() internal virtual whenPaused {
1223         _paused = false;
1224         emit Unpaused(_msgSender());
1225     }
1226 }
1227 
1228 // Ownable.sol
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 /**
1233  * @dev Contract module which provides a basic access control mechanism, where
1234  * there is an account (an owner) that can be granted exclusive access to
1235  * specific functions.
1236  *
1237  * By default, the owner account will be the one that deploys the contract. This
1238  * can later be changed with {transferOwnership}.
1239  *
1240  * This module is used through inheritance. It will make available the modifier
1241  * `onlyOwner`, which can be applied to your functions to restrict their use to
1242  * the owner.
1243  */
1244 abstract contract Ownable is Context {
1245     address private _owner;
1246 
1247     event OwnershipTransferred(
1248         address indexed previousOwner,
1249         address indexed newOwner
1250     );
1251 
1252     /**
1253      * @dev Initializes the contract setting the deployer as the initial owner.
1254      */
1255     constructor() {
1256         _setOwner(_msgSender());
1257     }
1258 
1259     /**
1260      * @dev Returns the address of the current owner.
1261      */
1262     function owner() public view virtual returns (address) {
1263         return _owner;
1264     }
1265 
1266     /**
1267      * @dev Throws if called by any account other than the owner.
1268      */
1269     modifier onlyOwner() {
1270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1271         _;
1272     }
1273 
1274     /**
1275      * @dev Leaves the contract without owner. It will not be possible to call
1276      * `onlyOwner` functions anymore. Can only be called by the current owner.
1277      *
1278      * NOTE: Renouncing ownership will leave the contract without an owner,
1279      * thereby removing any functionality that is only available to the owner.
1280      */
1281     function renounceOwnership() public virtual onlyOwner {
1282         _setOwner(address(0));
1283     }
1284 
1285     /**
1286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1287      * Can only be called by the current owner.
1288      */
1289     function transferOwnership(address newOwner) public virtual onlyOwner {
1290         require(
1291             newOwner != address(0),
1292             "Ownable: new owner is the zero address"
1293         );
1294         _setOwner(newOwner);
1295     }
1296 
1297     function _setOwner(address newOwner) private {
1298         address oldOwner = _owner;
1299         _owner = newOwner;
1300         emit OwnershipTransferred(oldOwner, newOwner);
1301     }
1302 }
1303 
1304 pragma solidity ^0.8.0;
1305 
1306 /**
1307  * @dev Contract module that helps prevent reentrant calls to a function.
1308  *
1309  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1310  * available, which can be applied to functions to make sure there are no nested
1311  * (reentrant) calls to them.
1312  *
1313  * Note that because there is a single `nonReentrant` guard, functions marked as
1314  * `nonReentrant` may not call one another. This can be worked around by making
1315  * those functions `private`, and then adding `external` `nonReentrant` entry
1316  * points to them.
1317  *
1318  * TIP: If you would like to learn more about reentrancy and alternative ways
1319  * to protect against it, check out our blog post
1320  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1321  */
1322 abstract contract ReentrancyGuard {
1323     // Booleans are more expensive than uint256 or any type that takes up a full
1324     // word because each write operation emits an extra SLOAD to first read the
1325     // slot's contents, replace the bits taken up by the boolean, and then write
1326     // back. This is the compiler's defense against contract upgrades and
1327     // pointer aliasing, and it cannot be disabled.
1328 
1329     // The values being non-zero value makes deployment a bit more expensive,
1330     // but in exchange the refund on every call to nonReentrant will be lower in
1331     // amount. Since refunds are capped to a percentage of the total
1332     // transaction's gas, it is best to keep them low in cases like this one, to
1333     // increase the likelihood of the full refund coming into effect.
1334     uint256 private constant _NOT_ENTERED = 1;
1335     uint256 private constant _ENTERED = 2;
1336 
1337     uint256 private _status;
1338 
1339     constructor() {
1340         _status = _NOT_ENTERED;
1341     }
1342 
1343     /**
1344      * @dev Prevents a contract from calling itself, directly or indirectly.
1345      * Calling a `nonReentrant` function from another `nonReentrant`
1346      * function is not supported. It is possible to prevent this from happening
1347      * by making the `nonReentrant` function external, and make it call a
1348      * `private` function that does the actual work.
1349      */
1350     modifier nonReentrant() {
1351         // On the first call to nonReentrant, _notEntered will be true
1352         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1353 
1354         // Any calls to nonReentrant after this point will fail
1355         _status = _ENTERED;
1356 
1357         _;
1358 
1359         // By storing the original value once again, a refund is triggered (see
1360         // https://eips.ethereum.org/EIPS/eip-2200)
1361         _status = _NOT_ENTERED;
1362     }
1363 }
1364 
1365 pragma solidity ^0.8.0;
1366 
1367 contract goontown is ERC721A, Ownable, Pausable, ReentrancyGuard {
1368     using Strings for uint256;
1369     string public baseURI;
1370     uint256 public cost = 0.005 ether;
1371     uint256 public maxSupply = 10000;
1372     uint256 public maxFree = 3000;
1373     uint256 public maxperAddressFreeLimit = 2;
1374     uint256 public maxperTransactionPublicMint = 3;
1375     uint256 public maxperAddress = 5;
1376 
1377     mapping(address => uint256) public addressFreeMintedBalance;
1378     mapping(address => uint256) public addressPublicMintedBalance;
1379 
1380     constructor() ERC721A("goontown", "GOON") {
1381         setBaseURI("");
1382 
1383     }
1384 
1385     function _baseURI() internal view virtual override returns (string memory) {
1386         return baseURI;
1387     }
1388 
1389     function MintFree(uint256 _mintAmount) public payable nonReentrant{
1390 		uint256 s = totalSupply();
1391         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1392         uint256 addressPublicMintedCount = addressPublicMintedBalance[msg.sender];
1393 
1394         require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "Only 2 for free per wallet, don't be greedy!");
1395 		require(_mintAmount > 0, "You must mint more than 0" );
1396 		require(s + _mintAmount <= maxFree, "All free goons are gone, use mint() function now");
1397         require(addressFreeMintedCount + addressPublicMintedCount + _mintAmount <= maxperAddress, "Only a max of 5 per wallet, don't be greedy!");
1398 
1399 		for (uint256 i = 0; i < _mintAmount; ++i) {
1400             addressFreeMintedBalance[msg.sender]++;
1401 		}
1402         
1403         _safeMint(msg.sender, _mintAmount);
1404 		delete s;
1405         delete addressFreeMintedCount;
1406         delete addressPublicMintedCount;
1407 	}
1408 
1409 
1410     function mint(uint256 _mintAmount) public payable nonReentrant {
1411         uint256 s = totalSupply();
1412         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1413         uint256 addressPublicMintedCount = addressPublicMintedBalance[msg.sender];
1414 
1415         require(_mintAmount > 0, "You must mint more than 0.");
1416         require(_mintAmount <= maxperTransactionPublicMint, "You can only max mint 3 per transaction." );
1417         require(s + _mintAmount <= maxSupply, "Silly goon, you cant go over supply");
1418         require(msg.value >= cost * _mintAmount);
1419         require(addressFreeMintedCount + addressPublicMintedCount + _mintAmount <= maxperAddress, "Only a max of 5 per wallet, don't be greedy!");
1420 
1421         for (uint256 i = 0; i < _mintAmount; ++i) {
1422             addressPublicMintedBalance[msg.sender]++;
1423 		}
1424         
1425         _safeMint(msg.sender, _mintAmount);
1426         delete s;
1427         delete addressFreeMintedCount;
1428         delete addressPublicMintedCount;
1429     }
1430 
1431     function gift(uint256[] calldata quantity, address[] calldata recipient)
1432         external
1433         onlyOwner
1434     {
1435         require(
1436             quantity.length == recipient.length,
1437             "Provide quantities and recipients"
1438         );
1439         uint256 totalQuantity = 0;
1440         uint256 s = totalSupply();
1441         for (uint256 i = 0; i < quantity.length; ++i) {
1442             totalQuantity += quantity[i];
1443         }
1444         require(s + totalQuantity <= maxSupply, "Too many");
1445         delete totalQuantity;
1446         for (uint256 i = 0; i < recipient.length; ++i) {
1447             _safeMint(recipient[i], quantity[i]);
1448         }
1449         delete s;
1450     }
1451 
1452     function tokenURI(uint256 tokenId)
1453         public
1454         view
1455         virtual
1456         override
1457         returns (string memory)
1458     {
1459         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1460         string memory currentBaseURI = _baseURI();
1461         return
1462             bytes(currentBaseURI).length > 0
1463                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1464                 : "";
1465     }
1466 
1467     function setCost(uint256 _newCost) public onlyOwner {
1468         cost = _newCost;
1469     }
1470 
1471     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1472         require(_newMaxSupply <= maxSupply, "Cannot increase max supply");
1473         maxSupply = _newMaxSupply;
1474     }
1475     
1476     function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1477         maxFree = _newMaxFreeSupply;
1478     }
1479 
1480     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1481         baseURI = _newBaseURI;
1482     }
1483 
1484     function setMaxperTransactionPublicMint(uint256 _amount) public onlyOwner {
1485         maxperTransactionPublicMint = _amount;
1486     }
1487 
1488     function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1489         maxperAddressFreeLimit = _amount;
1490     }
1491     
1492     function setMaxperAddress(uint256 _amount) public onlyOwner{
1493         maxperAddress = _amount;
1494     }
1495 
1496     function withdraw() public payable onlyOwner {
1497         (bool success, ) = payable(msg.sender).call{
1498             value: address(this).balance
1499         }("");
1500         require(success);
1501     }
1502 
1503     function withdrawAny(uint256 _amount) public payable onlyOwner {
1504         (bool success, ) = payable(msg.sender).call{value: _amount}("");
1505         require(success);
1506     }
1507 }