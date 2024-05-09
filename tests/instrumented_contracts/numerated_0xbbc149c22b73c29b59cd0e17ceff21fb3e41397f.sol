1 // SPDX-License-Identifier: MIT
2 /**
3 .----------------.  .----------------.  .----------------.  .-----------------. .----------------.  .-----------------. .----------------.  .----------------.  .----------------.  .----------------.  .----------------.
4 | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
5 | |   ______     | || | _____  _____ | || |  _______     | || | ____  _____  | || |     _____    | || | ____  _____  | || |    ______    | || | ____    ____ | || |  _________   | || |  _________   | || |      __      | |
6 | |  |_   _ \    | || ||_   _||_   _|| || | |_   __ \    | || ||_   \|_   _| | || |    |_   _|   | || ||_   \|_   _| | || |  .' ___  |   | || ||_   \  /   _|| || | |_   ___  |  | || | |  _   _  |  | || |     /  \     | |
7 | |    | |_) |   | || |  | |    | |  | || |   | |__) |   | || |  |   \ | |   | || |      | |     | || |  |   \ | |   | || | / .'   \_|   | || |  |   \/   |  | || |   | |_  \_|  | || | |_/ | | \_|  | || |    / /\ \    | |
8 | |    |  __'.   | || |  | '    ' |  | || |   |  __ /    | || |  | |\ \| |   | || |      | |     | || |  | |\ \| |   | || | | |    ____  | || |  | |\  /| |  | || |   |  _|  _   | || |     | |      | || |   / ____ \   | |
9 | |   _| |__) |  | || |   \ `--' /   | || |  _| |  \ \_  | || | _| |_\   |_  | || |     _| |_    | || | _| |_\   |_  | || | \ `.___]  _| | || | _| |_\/_| |_ | || |  _| |___/ |  | || |    _| |_     | || | _/ /    \ \_ | |
10 | |  |_______/   | || |    `.__.'    | || | |____| |___| | || ||_____|\____| | || |    |_____|   | || ||_____|\____| | || |  `._____.'   | || ||_____||_____|| || | |_________|  | || |   |_____|    | || ||____|  |____|| |
11 | |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |
12 | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
13 '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'
14 */
15 
16 // File: contracts/Strings.sol
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev String operations.
21  */
22 library Strings {
23     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
24 
25     /**
26      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
27      */
28     function toString(uint256 value) internal pure returns (string memory) {
29         // Inspired by OraclizeAPI's implementation - MIT licence
30         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
31 
32         if (value == 0) {
33             return "0";
34         }
35         uint256 temp = value;
36         uint256 digits;
37         while (temp != 0) {
38             digits++;
39             temp /= 10;
40         }
41         bytes memory buffer = new bytes(digits);
42         while (value != 0) {
43             digits -= 1;
44             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
45             value /= 10;
46         }
47         return string(buffer);
48     }
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
52      */
53     function toHexString(uint256 value) internal pure returns (string memory) {
54         if (value == 0) {
55             return "0x00";
56         }
57         uint256 temp = value;
58         uint256 length = 0;
59         while (temp != 0) {
60             length++;
61             temp >>= 8;
62         }
63         return toHexString(value, length);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
68      */
69     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
70         bytes memory buffer = new bytes(2 * length + 2);
71         buffer[0] = "0";
72         buffer[1] = "x";
73         for (uint256 i = 2 * length + 1; i > 1; --i) {
74             buffer[i] = _HEX_SYMBOLS[value & 0xf];
75             value >>= 4;
76         }
77         require(value == 0, "Strings: hex length insufficient");
78         return string(buffer);
79     }
80 }
81 
82 // File: contracts/Address.sol
83 
84 
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize, which returns 0 for contracts in
111         // construction, since the code is only stored at the end of the
112         // constructor execution.
113 
114         uint256 size;
115         assembly {
116             size := extcodesize(account)
117         }
118         return size > 0;
119     }
120 
121     /**
122      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
123      * `recipient`, forwarding all available gas and reverting on errors.
124      *
125      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
126      * of certain opcodes, possibly making contracts go over the 2300 gas limit
127      * imposed by `transfer`, making them unable to receive funds via
128      * `transfer`. {sendValue} removes this limitation.
129      *
130      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
131      *
132      * IMPORTANT: because control is transferred to `recipient`, care must be
133      * taken to not create reentrancy vulnerabilities. Consider using
134      * {ReentrancyGuard} or the
135      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
136      */
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(address(this).balance >= amount, "Address: insufficient balance");
139 
140         (bool success, ) = recipient.call{value: amount}("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143 
144     /**
145      * @dev Performs a Solidity function call using a low level `call`. A
146      * plain `call` is an unsafe replacement for a function call: use this
147      * function instead.
148      *
149      * If `target` reverts with a revert reason, it is bubbled up by this
150      * function (like regular Solidity function calls).
151      *
152      * Returns the raw returned data. To convert to the expected return value,
153      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
154      *
155      * Requirements:
156      *
157      * - `target` must be a contract.
158      * - calling `target` with `data` must not revert.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163         return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
168      * `errorMessage` as a fallback revert reason when `target` reverts.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         return functionCallWithValue(target, data, 0, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but also transferring `value` wei to `target`.
183      *
184      * Requirements:
185      *
186      * - the calling contract must have an ETH balance of at least `value`.
187      * - the called Solidity function must be `payable`.
188      *
189      * _Available since v3.1._
190      */
191     function functionCallWithValue(
192         address target,
193         bytes memory data,
194         uint256 value
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
201      * with `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCallWithValue(
206         address target,
207         bytes memory data,
208         uint256 value,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         require(address(this).balance >= value, "Address: insufficient balance for call");
212         require(isContract(target), "Address: call to non-contract");
213 
214         (bool success, bytes memory returndata) = target.call{value: value}(data);
215         return _verifyCallResult(success, returndata, errorMessage);
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
225         return functionStaticCall(target, data, "Address: low-level static call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal view returns (bytes memory) {
239         require(isContract(target), "Address: static call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.staticcall(data);
242         return _verifyCallResult(success, returndata, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
252         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         require(isContract(target), "Address: delegate call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.delegatecall(data);
269         return _verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     function _verifyCallResult(
273         bool success,
274         bytes memory returndata,
275         string memory errorMessage
276     ) private pure returns (bytes memory) {
277         if (success) {
278             return returndata;
279         } else {
280             // Look for revert reason and bubble it up if present
281             if (returndata.length > 0) {
282                 // The easiest way to bubble the revert reason is using memory via assembly
283 
284                 assembly {
285                     let returndata_size := mload(returndata)
286                     revert(add(32, returndata), returndata_size)
287                 }
288             } else {
289                 revert(errorMessage);
290             }
291         }
292     }
293 }
294 
295 // File: contracts/IERC721Receiver.sol
296 
297 
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @title ERC721 token receiver interface
303  * @dev Interface for any contract that wants to support safeTransfers
304  * from ERC721 asset contracts.
305  */
306 interface IERC721Receiver {
307     /**
308      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
309      * by `operator` from `from`, this function is called.
310      *
311      * It must return its Solidity selector to confirm the token transfer.
312      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
313      *
314      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
315      */
316     function onERC721Received(
317         address operator,
318         address from,
319         uint256 tokenId,
320         bytes calldata data
321     ) external returns (bytes4);
322 }
323 
324 // File: contracts/IERC165.sol
325 
326 
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @dev Interface of the ERC165 standard, as defined in the
332  * https://eips.ethereum.org/EIPS/eip-165[EIP].
333  *
334  * Implementers can declare support of contract interfaces, which can then be
335  * queried by others ({ERC165Checker}).
336  *
337  * For an implementation, see {ERC165}.
338  */
339 interface IERC165 {
340     /**
341      * @dev Returns true if this contract implements the interface defined by
342      * `interfaceId`. See the corresponding
343      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
344      * to learn more about how these ids are created.
345      *
346      * This function call must use less than 30 000 gas.
347      */
348     function supportsInterface(bytes4 interfaceId) external view returns (bool);
349 }
350 
351 // File: contracts/ERC165.sol
352 
353 
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev Implementation of the {IERC165} interface.
360  *
361  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
362  * for the additional interface id that will be supported. For example:
363  *
364  * ```solidity
365  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
366  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
367  * }
368  * ```
369  *
370  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
371  */
372 abstract contract ERC165 is IERC165 {
373     /**
374      * @dev See {IERC165-supportsInterface}.
375      */
376     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377         return interfaceId == type(IERC165).interfaceId;
378     }
379 }
380 
381 // File: contracts/IERC721.sol
382 
383 
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Required interface of an ERC721 compliant contract.
390  */
391 interface IERC721 is IERC165 {
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 }
524 
525 // File: contracts/IERC721Enumerable.sol
526 
527 
528 
529 pragma solidity ^0.8.0;
530 
531 
532 /**
533  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
534  * @dev See https://eips.ethereum.org/EIPS/eip-721
535  */
536 interface IERC721Enumerable is IERC721 {
537     /**
538      * @dev Returns the total amount of tokens stored by the contract.
539      */
540     function totalSupply() external view returns (uint256);
541 
542     /**
543      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
544      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
545      */
546     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
547 
548     /**
549      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
550      * Use along with {totalSupply} to enumerate all tokens.
551      */
552     function tokenByIndex(uint256 index) external view returns (uint256);
553 }
554 
555 // File: contracts/IERC721Metadata.sol
556 
557 
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
564  * @dev See https://eips.ethereum.org/EIPS/eip-721
565  */
566 interface IERC721Metadata is IERC721 {
567     /**
568      * @dev Returns the token collection name.
569      */
570     function name() external view returns (string memory);
571 
572     /**
573      * @dev Returns the token collection symbol.
574      */
575     function symbol() external view returns (string memory);
576 
577     /**
578      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
579      */
580     function tokenURI(uint256 tokenId) external view returns (string memory);
581 }
582 
583 // File: contracts/ReentrancyGuard.sol
584 
585 
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @dev Contract module that helps prevent reentrant calls to a function.
591  *
592  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
593  * available, which can be applied to functions to make sure there are no nested
594  * (reentrant) calls to them.
595  *
596  * Note that because there is a single `nonReentrant` guard, functions marked as
597  * `nonReentrant` may not call one another. This can be worked around by making
598  * those functions `private`, and then adding `external` `nonReentrant` entry
599  * points to them.
600  *
601  * TIP: If you would like to learn more about reentrancy and alternative ways
602  * to protect against it, check out our blog post
603  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
604  */
605 abstract contract ReentrancyGuard {
606     // Booleans are more expensive than uint256 or any type that takes up a full
607     // word because each write operation emits an extra SLOAD to first read the
608     // slot's contents, replace the bits taken up by the boolean, and then write
609     // back. This is the compiler's defense against contract upgrades and
610     // pointer aliasing, and it cannot be disabled.
611 
612     // The values being non-zero value makes deployment a bit more expensive,
613     // but in exchange the refund on every call to nonReentrant will be lower in
614     // amount. Since refunds are capped to a percentage of the total
615     // transaction's gas, it is best to keep them low in cases like this one, to
616     // increase the likelihood of the full refund coming into effect.
617     uint256 private constant _NOT_ENTERED = 1;
618     uint256 private constant _ENTERED = 2;
619 
620     uint256 private _status;
621 
622     constructor() {
623         _status = _NOT_ENTERED;
624     }
625 
626     /**
627      * @dev Prevents a contract from calling itself, directly or indirectly.
628      * Calling a `nonReentrant` function from another `nonReentrant`
629      * function is not supported. It is possible to prevent this from happening
630      * by making the `nonReentrant` function external, and make it call a
631      * `private` function that does the actual work.
632      */
633     modifier nonReentrant() {
634         // On the first call to nonReentrant, _notEntered will be true
635         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
636 
637         // Any calls to nonReentrant after this point will fail
638         _status = _ENTERED;
639 
640         _;
641 
642         // By storing the original value once again, a refund is triggered (see
643         // https://eips.ethereum.org/EIPS/eip-2200)
644         _status = _NOT_ENTERED;
645     }
646 }
647 
648 // File: contracts/Context.sol
649 
650 
651 
652 pragma solidity ^0.8.0;
653 
654 /*
655  * @dev Provides information about the current execution context, including the
656  * sender of the transaction and its data. While these are generally available
657  * via msg.sender and msg.data, they should not be accessed in such a direct
658  * manner, since when dealing with meta-transactions the account sending and
659  * paying for execution may not be the actual sender (as far as an application
660  * is concerned).
661  *
662  * This contract is only required for intermediate, library-like contracts.
663  */
664 abstract contract Context {
665     function _msgSender() internal view virtual returns (address) {
666         return msg.sender;
667     }
668 
669     function _msgData() internal view virtual returns (bytes calldata) {
670         return msg.data;
671     }
672 }
673 
674 // File: contracts/ERC721A.sol
675 
676 
677 
678 pragma solidity ^0.8.0;
679 
680 
681 
682 
683 
684 
685 
686 
687 
688 /**
689  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
690  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
691  *
692  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
693  *
694  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
695  *
696  * Does not support burning tokens to address(0).
697  */
698 contract ERC721A is
699   Context,
700   ERC165,
701   IERC721,
702   IERC721Metadata,
703   IERC721Enumerable
704 {
705   using Address for address;
706   using Strings for uint256;
707 
708   struct TokenOwnership {
709     address addr;
710     uint64 startTimestamp;
711   }
712 
713   struct AddressData {
714     uint128 balance;
715     uint128 numberMinted;
716   }
717 
718   uint256 private currentIndex = 0;
719 
720   uint256 internal immutable collectionSize;
721   uint256 internal immutable maxBatchSize;
722 
723   // Token name
724   string private _name;
725 
726   // Token symbol
727   string private _symbol;
728 
729   // Mapping from token ID to ownership details
730   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
731   mapping(uint256 => TokenOwnership) private _ownerships;
732 
733   // Mapping owner address to address data
734   mapping(address => AddressData) private _addressData;
735 
736   // Mapping from token ID to approved address
737   mapping(uint256 => address) private _tokenApprovals;
738 
739   // Mapping from owner to operator approvals
740   mapping(address => mapping(address => bool)) private _operatorApprovals;
741 
742   /**
743    * @dev
744    * `maxBatchSize` refers to how much a minter can mint at a time.
745    * `collectionSize_` refers to how many tokens are in the collection.
746    */
747   constructor(
748     string memory name_,
749     string memory symbol_,
750     uint256 maxBatchSize_,
751     uint256 collectionSize_
752   ) {
753     require(
754       collectionSize_ > 0,
755       "ERC721A: collection must have a nonzero supply"
756     );
757     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
758     _name = name_;
759     _symbol = symbol_;
760     maxBatchSize = maxBatchSize_;
761     collectionSize = collectionSize_;
762   }
763 
764   /**
765    * @dev See {IERC721Enumerable-totalSupply}.
766    */
767   function totalSupply() public view override returns (uint256) {
768     return currentIndex;
769   }
770 
771   /**
772    * @dev See {IERC721Enumerable-tokenByIndex}.
773    */
774   function tokenByIndex(uint256 index) public view override returns (uint256) {
775     require(index < totalSupply(), "ERC721A: global index out of bounds");
776     return index;
777   }
778 
779   /**
780    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
781    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
782    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
783    */
784   function tokenOfOwnerByIndex(address owner, uint256 index)
785     public
786     view
787     override
788     returns (uint256)
789   {
790     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
791     uint256 numMintedSoFar = totalSupply();
792     uint256 tokenIdsIdx = 0;
793     address currOwnershipAddr = address(0);
794     for (uint256 i = 0; i < numMintedSoFar; i++) {
795       TokenOwnership memory ownership = _ownerships[i];
796       if (ownership.addr != address(0)) {
797         currOwnershipAddr = ownership.addr;
798       }
799       if (currOwnershipAddr == owner) {
800         if (tokenIdsIdx == index) {
801           return i;
802         }
803         tokenIdsIdx++;
804       }
805     }
806     revert("ERC721A: unable to get token of owner by index");
807   }
808 
809   /**
810    * @dev See {IERC165-supportsInterface}.
811    */
812   function supportsInterface(bytes4 interfaceId)
813     public
814     view
815     virtual
816     override(ERC165, IERC165)
817     returns (bool)
818   {
819     return
820       interfaceId == type(IERC721).interfaceId ||
821       interfaceId == type(IERC721Metadata).interfaceId ||
822       interfaceId == type(IERC721Enumerable).interfaceId ||
823       super.supportsInterface(interfaceId);
824   }
825 
826   /**
827    * @dev See {IERC721-balanceOf}.
828    */
829   function balanceOf(address owner) public view override returns (uint256) {
830     require(owner != address(0), "ERC721A: balance query for the zero address");
831     return uint256(_addressData[owner].balance);
832   }
833 
834   function _numberMinted(address owner) internal view returns (uint256) {
835     require(
836       owner != address(0),
837       "ERC721A: number minted query for the zero address"
838     );
839     return uint256(_addressData[owner].numberMinted);
840   }
841 
842   function ownershipOf(uint256 tokenId)
843     internal
844     view
845     returns (TokenOwnership memory)
846   {
847     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
848 
849     uint256 lowestTokenToCheck;
850     if (tokenId >= maxBatchSize) {
851       lowestTokenToCheck = tokenId - maxBatchSize + 1;
852     }
853 
854     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
855       TokenOwnership memory ownership = _ownerships[curr];
856       if (ownership.addr != address(0)) {
857         return ownership;
858       }
859     }
860 
861     revert("ERC721A: unable to determine the owner of token");
862   }
863 
864   /**
865    * @dev See {IERC721-ownerOf}.
866    */
867   function ownerOf(uint256 tokenId) public view override returns (address) {
868     return ownershipOf(tokenId).addr;
869   }
870 
871   /**
872    * @dev See {IERC721Metadata-name}.
873    */
874   function name() public view virtual override returns (string memory) {
875     return _name;
876   }
877 
878   /**
879    * @dev See {IERC721Metadata-symbol}.
880    */
881   function symbol() public view virtual override returns (string memory) {
882     return _symbol;
883   }
884 
885   /**
886    * @dev See {IERC721Metadata-tokenURI}.
887    */
888   function tokenURI(uint256 tokenId)
889     public
890     view
891     virtual
892     override
893     returns (string memory)
894   {
895     require(
896       _exists(tokenId),
897       "ERC721Metadata: URI query for nonexistent token"
898     );
899 
900     string memory baseURI = _baseURI();
901     return
902       bytes(baseURI).length > 0
903         ? string(abi.encodePacked(baseURI, tokenId.toString()))
904         : "";
905   }
906 
907   /**
908    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
909    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
910    * by default, can be overriden in child contracts.
911    */
912   function _baseURI() internal view virtual returns (string memory) {
913     return "";
914   }
915 
916   /**
917    * @dev See {IERC721-approve}.
918    */
919   function approve(address to, uint256 tokenId) public override {
920     address owner = ERC721A.ownerOf(tokenId);
921     require(to != owner, "ERC721A: approval to current owner");
922 
923     require(
924       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
925       "ERC721A: approve caller is not owner nor approved for all"
926     );
927 
928     _approve(to, tokenId, owner);
929   }
930 
931   /**
932    * @dev See {IERC721-getApproved}.
933    */
934   function getApproved(uint256 tokenId) public view override returns (address) {
935     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
936 
937     return _tokenApprovals[tokenId];
938   }
939 
940   /**
941    * @dev See {IERC721-setApprovalForAll}.
942    */
943   function setApprovalForAll(address operator, bool approved) public override {
944     require(operator != _msgSender(), "ERC721A: approve to caller");
945 
946     _operatorApprovals[_msgSender()][operator] = approved;
947     emit ApprovalForAll(_msgSender(), operator, approved);
948   }
949 
950   /**
951    * @dev See {IERC721-isApprovedForAll}.
952    */
953   function isApprovedForAll(address owner, address operator)
954     public
955     view
956     virtual
957     override
958     returns (bool)
959   {
960     return _operatorApprovals[owner][operator];
961   }
962 
963   /**
964    * @dev See {IERC721-transferFrom}.
965    */
966   function transferFrom(
967     address from,
968     address to,
969     uint256 tokenId
970   ) public override {
971     _transfer(from, to, tokenId);
972   }
973 
974   /**
975    * @dev See {IERC721-safeTransferFrom}.
976    */
977   function safeTransferFrom(
978     address from,
979     address to,
980     uint256 tokenId
981   ) public override {
982     safeTransferFrom(from, to, tokenId, "");
983   }
984 
985   /**
986    * @dev See {IERC721-safeTransferFrom}.
987    */
988   function safeTransferFrom(
989     address from,
990     address to,
991     uint256 tokenId,
992     bytes memory _data
993   ) public override {
994     _transfer(from, to, tokenId);
995     require(
996       _checkOnERC721Received(from, to, tokenId, _data),
997       "ERC721A: transfer to non ERC721Receiver implementer"
998     );
999   }
1000 
1001   /**
1002    * @dev Returns whether `tokenId` exists.
1003    *
1004    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1005    *
1006    * Tokens start existing when they are minted (`_mint`),
1007    */
1008   function _exists(uint256 tokenId) internal view returns (bool) {
1009     return tokenId < currentIndex;
1010   }
1011 
1012   function _safeMint(address to, uint256 quantity) internal {
1013     _safeMint(to, quantity, "");
1014   }
1015 
1016   /**
1017    * @dev Mints `quantity` tokens and transfers them to `to`.
1018    *
1019    * Requirements:
1020    *
1021    * - there must be `quantity` tokens remaining unminted in the total collection.
1022    * - `to` cannot be the zero address.
1023    * - `quantity` cannot be larger than the max batch size.
1024    *
1025    * Emits a {Transfer} event.
1026    */
1027   function _safeMint(
1028     address to,
1029     uint256 quantity,
1030     bytes memory _data
1031   ) internal {
1032     uint256 startTokenId = currentIndex;
1033     require(to != address(0), "ERC721A: mint to the zero address");
1034     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1035     require(!_exists(startTokenId), "ERC721A: token already minted");
1036     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1037 
1038     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1039 
1040     AddressData memory addressData = _addressData[to];
1041     _addressData[to] = AddressData(
1042       addressData.balance + uint128(quantity),
1043       addressData.numberMinted + uint128(quantity)
1044     );
1045     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1046 
1047     uint256 updatedIndex = startTokenId;
1048 
1049     for (uint256 i = 0; i < quantity; i++) {
1050       emit Transfer(address(0), to, updatedIndex);
1051       require(
1052         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1053         "ERC721A: transfer to non ERC721Receiver implementer"
1054       );
1055       updatedIndex++;
1056     }
1057 
1058     currentIndex = updatedIndex;
1059     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1060   }
1061 
1062   /**
1063    * @dev Transfers `tokenId` from `from` to `to`.
1064    *
1065    * Requirements:
1066    *
1067    * - `to` cannot be the zero address.
1068    * - `tokenId` token must be owned by `from`.
1069    *
1070    * Emits a {Transfer} event.
1071    */
1072   function _transfer(
1073     address from,
1074     address to,
1075     uint256 tokenId
1076   ) private {
1077     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1078 
1079     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1080       getApproved(tokenId) == _msgSender() ||
1081       isApprovedForAll(prevOwnership.addr, _msgSender()));
1082 
1083     require(
1084       isApprovedOrOwner,
1085       "ERC721A: transfer caller is not owner nor approved"
1086     );
1087 
1088     require(
1089       prevOwnership.addr == from,
1090       "ERC721A: transfer from incorrect owner"
1091     );
1092     require(to != address(0), "ERC721A: transfer to the zero address");
1093 
1094     _beforeTokenTransfers(from, to, tokenId, 1);
1095 
1096     // Clear approvals from the previous owner
1097     _approve(address(0), tokenId, prevOwnership.addr);
1098 
1099     _addressData[from].balance -= 1;
1100     _addressData[to].balance += 1;
1101     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1102 
1103     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1104     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1105     uint256 nextTokenId = tokenId + 1;
1106     if (_ownerships[nextTokenId].addr == address(0)) {
1107       if (_exists(nextTokenId)) {
1108         _ownerships[nextTokenId] = TokenOwnership(
1109           prevOwnership.addr,
1110           prevOwnership.startTimestamp
1111         );
1112       }
1113     }
1114 
1115     emit Transfer(from, to, tokenId);
1116     _afterTokenTransfers(from, to, tokenId, 1);
1117   }
1118 
1119   /**
1120    * @dev Approve `to` to operate on `tokenId`
1121    *
1122    * Emits a {Approval} event.
1123    */
1124   function _approve(
1125     address to,
1126     uint256 tokenId,
1127     address owner
1128   ) private {
1129     _tokenApprovals[tokenId] = to;
1130     emit Approval(owner, to, tokenId);
1131   }
1132 
1133   uint256 public nextOwnerToExplicitlySet = 0;
1134 
1135   /**
1136    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1137    */
1138   function _setOwnersExplicit(uint256 quantity) internal {
1139     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1140     require(quantity > 0, "quantity must be nonzero");
1141     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1142     if (endIndex > collectionSize - 1) {
1143       endIndex = collectionSize - 1;
1144     }
1145     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1146     require(_exists(endIndex), "not enough minted yet for this cleanup");
1147     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1148       if (_ownerships[i].addr == address(0)) {
1149         TokenOwnership memory ownership = ownershipOf(i);
1150         _ownerships[i] = TokenOwnership(
1151           ownership.addr,
1152           ownership.startTimestamp
1153         );
1154       }
1155     }
1156     nextOwnerToExplicitlySet = endIndex + 1;
1157   }
1158 
1159   /**
1160    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1161    * The call is not executed if the target address is not a contract.
1162    *
1163    * @param from address representing the previous owner of the given token ID
1164    * @param to target address that will receive the tokens
1165    * @param tokenId uint256 ID of the token to be transferred
1166    * @param _data bytes optional data to send along with the call
1167    * @return bool whether the call correctly returned the expected magic value
1168    */
1169   function _checkOnERC721Received(
1170     address from,
1171     address to,
1172     uint256 tokenId,
1173     bytes memory _data
1174   ) private returns (bool) {
1175     if (to.isContract()) {
1176       try
1177         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1178       returns (bytes4 retval) {
1179         return retval == IERC721Receiver(to).onERC721Received.selector;
1180       } catch (bytes memory reason) {
1181         if (reason.length == 0) {
1182           revert("ERC721A: transfer to non ERC721Receiver implementer");
1183         } else {
1184           assembly {
1185             revert(add(32, reason), mload(reason))
1186           }
1187         }
1188       }
1189     } else {
1190       return true;
1191     }
1192   }
1193 
1194   /**
1195    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1196    *
1197    * startTokenId - the first token id to be transferred
1198    * quantity - the amount to be transferred
1199    *
1200    * Calling conditions:
1201    *
1202    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1203    * transferred to `to`.
1204    * - When `from` is zero, `tokenId` will be minted for `to`.
1205    */
1206   function _beforeTokenTransfers(
1207     address from,
1208     address to,
1209     uint256 startTokenId,
1210     uint256 quantity
1211   ) internal virtual {}
1212 
1213   /**
1214    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1215    * minting.
1216    *
1217    * startTokenId - the first token id to be transferred
1218    * quantity - the amount to be transferred
1219    *
1220    * Calling conditions:
1221    *
1222    * - when `from` and `to` are both non-zero.
1223    * - `from` and `to` are never both zero.
1224    */
1225   function _afterTokenTransfers(
1226     address from,
1227     address to,
1228     uint256 startTokenId,
1229     uint256 quantity
1230   ) internal virtual {}
1231 }
1232 
1233 // File: contracts/Ownable.sol
1234 
1235 
1236 
1237 pragma solidity ^0.8.0;
1238 
1239 
1240 /**
1241  * @dev Contract module which provides a basic access control mechanism, where
1242  * there is an account (an owner) that can be granted exclusive access to
1243  * specific functions.
1244  *
1245  * By default, the owner account will be the one that deploys the contract. This
1246  * can later be changed with {transferOwnership}.
1247  *
1248  * This module is used through inheritance. It will make available the modifier
1249  * `onlyOwner`, which can be applied to your functions to restrict their use to
1250  * the owner.
1251  */
1252 abstract contract Ownable is Context {
1253     address private _owner;
1254 
1255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1256 
1257     /**
1258      * @dev Initializes the contract setting the deployer as the initial owner.
1259      */
1260     constructor() {
1261         _setOwner(_msgSender());
1262     }
1263 
1264     /**
1265      * @dev Returns the address of the current owner.
1266      */
1267     function owner() public view virtual returns (address) {
1268         return _owner;
1269     }
1270 
1271     /**
1272      * @dev Throws if called by any account other than the owner.
1273      */
1274     modifier onlyOwner() {
1275         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1276         _;
1277     }
1278 
1279     /**
1280      * @dev Leaves the contract without owner. It will not be possible to call
1281      * `onlyOwner` functions anymore. Can only be called by the current owner.
1282      *
1283      * NOTE: Renouncing ownership will leave the contract without an owner,
1284      * thereby removing any functionality that is only available to the owner.
1285      */
1286     function renounceOwnership() public virtual onlyOwner {
1287         _setOwner(address(0));
1288     }
1289 
1290     /**
1291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1292      * Can only be called by the current owner.
1293      */
1294     function transferOwnership(address newOwner) public virtual onlyOwner {
1295         require(newOwner != address(0), "Ownable: new owner is the zero address");
1296         _setOwner(newOwner);
1297     }
1298 
1299     function _setOwner(address newOwner) private {
1300         address oldOwner = _owner;
1301         _owner = newOwner;
1302         emit OwnershipTransferred(oldOwner, newOwner);
1303     }
1304 }
1305 
1306 // File: contracts/BurningMeta.sol
1307 
1308 
1309 
1310 pragma solidity ^0.8.0;
1311 
1312 
1313 
1314 
1315 
1316 contract BurningMeta is Ownable, ERC721A, ReentrancyGuard {
1317   uint256 public immutable maxPerAddressDuringMint;
1318   uint256 public immutable amountForDevs;
1319   uint256 public immutable amountForFree;
1320   uint256 public mintPrice = 0; //0.05 ETH
1321   uint256 public listPrice = 0; //0.05 ETH
1322 
1323   mapping(address => uint256) public allowlist;
1324 
1325   constructor(
1326     uint256 maxBatchSize_,
1327     uint256 collectionSize_,
1328     uint256 amountForDevs_,
1329     uint256 amountForFree_
1330   ) ERC721A("BurningMeta", "BURN", maxBatchSize_, collectionSize_) {
1331     maxPerAddressDuringMint = maxBatchSize_;
1332     amountForDevs = amountForDevs_;
1333     amountForFree = amountForFree_;
1334   }
1335 
1336   modifier callerIsUser() {
1337     require(tx.origin == msg.sender, "The caller is another contract");
1338     _;
1339   }
1340 
1341   function mint(uint256 quantity) external callerIsUser {
1342 
1343     require(totalSupply() + quantity <= amountForFree, "reached max supply");
1344     require(
1345       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1346       "can not mint this many"
1347     );
1348     _safeMint(msg.sender, quantity);
1349   }
1350 
1351   function wlMint() external payable callerIsUser {
1352     uint256 price = listPrice;
1353     require(price != 0, "allowlist sale has not begun yet");
1354     require(allowlist[msg.sender] > 0, "not eligible for allowlist mint");
1355     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1356     allowlist[msg.sender]--;
1357     _safeMint(msg.sender, 1);
1358     refundIfOver(price);
1359   }
1360 
1361   function paidMint(uint256 quantity)
1362     external
1363     payable
1364     callerIsUser
1365   {
1366     uint256 publicPrice = mintPrice;
1367 
1368     require(
1369       isPublicSaleOn(publicPrice),
1370       "public sale has not begun yet"
1371     );
1372     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1373     require(
1374       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1375       "can not mint this many"
1376     );
1377     _safeMint(msg.sender, quantity);
1378     refundIfOver(publicPrice * quantity);
1379   }
1380 
1381   function refundIfOver(uint256 price) private {
1382     require(msg.value >= price, "Need to send more ETH.");
1383     if (msg.value > price) {
1384       payable(msg.sender).transfer(msg.value - price);
1385     }
1386   }
1387 
1388   function isPublicSaleOn(
1389     uint256 publicPriceWei
1390   ) public view returns (bool) {
1391     return
1392       publicPriceWei != 0 ;
1393   }
1394 
1395 
1396   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1397     external
1398     onlyOwner
1399   {
1400     require(
1401       addresses.length == numSlots.length,
1402       "addresses does not match numSlots length"
1403     );
1404     for (uint256 i = 0; i < addresses.length; i++) {
1405       allowlist[addresses[i]] = numSlots[i];
1406     }
1407   }
1408 
1409   // For marketing etc.
1410   function devMint(uint256 quantity) external onlyOwner {
1411     require(
1412       totalSupply() + quantity <= amountForDevs,
1413       "too many already minted before dev mint"
1414     );
1415     require(
1416       quantity % maxBatchSize == 0,
1417       "can only mint a multiple of the maxBatchSize"
1418     );
1419     uint256 numChunks = quantity / maxBatchSize;
1420     for (uint256 i = 0; i < numChunks; i++) {
1421       _safeMint(msg.sender, maxBatchSize);
1422     }
1423   }
1424 
1425   // // metadata URI
1426   string private _baseTokenURI;
1427 
1428   function _baseURI() internal view virtual override returns (string memory) {
1429     return _baseTokenURI;
1430   }
1431 
1432   function setBaseURI(string calldata baseURI) external onlyOwner {
1433     _baseTokenURI = baseURI;
1434   }
1435 
1436   function withdrawMoney() external onlyOwner nonReentrant {
1437     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1438     require(success, "Transfer failed.");
1439   }
1440 
1441   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1442     _setOwnersExplicit(quantity);
1443   }
1444 
1445   function numberMinted(address owner) public view returns (uint256) {
1446     return _numberMinted(owner);
1447   }
1448 
1449   function getOwnershipData(uint256 tokenId)
1450     external
1451     view
1452     returns (TokenOwnership memory)
1453   {
1454     return ownershipOf(tokenId);
1455   }
1456 
1457   function setListPrice(uint256 newPrice) public onlyOwner {
1458       listPrice = newPrice;
1459   }
1460 
1461   function setMintPrice(uint256 newPrice) public onlyOwner {
1462       mintPrice = newPrice;
1463   }
1464 }