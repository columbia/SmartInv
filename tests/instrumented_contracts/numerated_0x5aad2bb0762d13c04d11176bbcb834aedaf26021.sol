1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Address.sol
74 
75 
76 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
77 
78 pragma solidity ^0.8.1;
79 
80 /**
81  * @dev Collection of functions related to the address type
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      *
101      * [IMPORTANT]
102      * ====
103      * You shouldn't rely on `isContract` to protect against flash loan attacks!
104      *
105      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
106      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
107      * constructor.
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize/address.code.length, which returns 0
112         // for contracts in construction, since the code is only stored at the end
113         // of the constructor execution.
114 
115         return account.code.length > 0;
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         (bool success, ) = recipient.call{value: amount}("");
138         require(success, "Address: unable to send value, recipient may have reverted");
139     }
140 
141     /**
142      * @dev Performs a Solidity function call using a low level `call`. A
143      * plain `call` is an unsafe replacement for a function call: use this
144      * function instead.
145      *
146      * If `target` reverts with a revert reason, it is bubbled up by this
147      * function (like regular Solidity function calls).
148      *
149      * Returns the raw returned data. To convert to the expected return value,
150      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
151      *
152      * Requirements:
153      *
154      * - `target` must be a contract.
155      * - calling `target` with `data` must not revert.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionCall(target, data, "Address: low-level call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
165      * `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, 0, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but also transferring `value` wei to `target`.
180      *
181      * Requirements:
182      *
183      * - the calling contract must have an ETH balance of at least `value`.
184      * - the called Solidity function must be `payable`.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
198      * with `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(address(this).balance >= value, "Address: insufficient balance for call");
209         require(isContract(target), "Address: call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.call{value: value}(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217      * but performing a static call.
218      *
219      * _Available since v3.3._
220      */
221     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
222         return functionStaticCall(target, data, "Address: low-level static call failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
227      * but performing a static call.
228      *
229      * _Available since v3.3._
230      */
231     function functionStaticCall(
232         address target,
233         bytes memory data,
234         string memory errorMessage
235     ) internal view returns (bytes memory) {
236         require(isContract(target), "Address: static call to non-contract");
237 
238         (bool success, bytes memory returndata) = target.staticcall(data);
239         return verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but performing a delegate call.
245      *
246      * _Available since v3.4._
247      */
248     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
249         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
254      * but performing a delegate call.
255      *
256      * _Available since v3.4._
257      */
258     function functionDelegateCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         require(isContract(target), "Address: delegate call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.delegatecall(data);
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
271      * revert reason using the provided one.
272      *
273      * _Available since v4.3._
274      */
275     function verifyCallResult(
276         bool success,
277         bytes memory returndata,
278         string memory errorMessage
279     ) internal pure returns (bytes memory) {
280         if (success) {
281             return returndata;
282         } else {
283             // Look for revert reason and bubble it up if present
284             if (returndata.length > 0) {
285                 // The easiest way to bubble the revert reason is using memory via assembly
286 
287                 assembly {
288                     let returndata_size := mload(returndata)
289                     revert(add(32, returndata), returndata_size)
290                 }
291             } else {
292                 revert(errorMessage);
293             }
294         }
295     }
296 }
297 
298 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
299 
300 
301 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @title ERC721 token receiver interface
307  * @dev Interface for any contract that wants to support safeTransfers
308  * from ERC721 asset contracts.
309  */
310 interface IERC721Receiver {
311     /**
312      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
313      * by `operator` from `from`, this function is called.
314      *
315      * It must return its Solidity selector to confirm the token transfer.
316      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
317      *
318      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
319      */
320     function onERC721Received(
321         address operator,
322         address from,
323         uint256 tokenId,
324         bytes calldata data
325     ) external returns (bytes4);
326 }
327 
328 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev Interface of the ERC165 standard, as defined in the
337  * https://eips.ethereum.org/EIPS/eip-165[EIP].
338  *
339  * Implementers can declare support of contract interfaces, which can then be
340  * queried by others ({ERC165Checker}).
341  *
342  * For an implementation, see {ERC165}.
343  */
344 interface IERC165 {
345     /**
346      * @dev Returns true if this contract implements the interface defined by
347      * `interfaceId`. See the corresponding
348      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
349      * to learn more about how these ids are created.
350      *
351      * This function call must use less than 30 000 gas.
352      */
353     function supportsInterface(bytes4 interfaceId) external view returns (bool);
354 }
355 
356 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 /**
365  * @dev Implementation of the {IERC165} interface.
366  *
367  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
368  * for the additional interface id that will be supported. For example:
369  *
370  * ```solidity
371  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
372  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
373  * }
374  * ```
375  *
376  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
377  */
378 abstract contract ERC165 is IERC165 {
379     /**
380      * @dev See {IERC165-supportsInterface}.
381      */
382     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
383         return interfaceId == type(IERC165).interfaceId;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
388 
389 
390 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Required interface of an ERC721 compliant contract.
397  */
398 interface IERC721 is IERC165 {
399     /**
400      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
401      */
402     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
406      */
407     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
408 
409     /**
410      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
411      */
412     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
413 
414     /**
415      * @dev Returns the number of tokens in ``owner``'s account.
416      */
417     function balanceOf(address owner) external view returns (uint256 balance);
418 
419     /**
420      * @dev Returns the owner of the `tokenId` token.
421      *
422      * Requirements:
423      *
424      * - `tokenId` must exist.
425      */
426     function ownerOf(uint256 tokenId) external view returns (address owner);
427 
428     /**
429      * @dev Safely transfers `tokenId` token from `from` to `to`.
430      *
431      * Requirements:
432      *
433      * - `from` cannot be the zero address.
434      * - `to` cannot be the zero address.
435      * - `tokenId` token must exist and be owned by `from`.
436      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
438      *
439      * Emits a {Transfer} event.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId,
445         bytes calldata data
446     ) external;
447 
448     /**
449      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
450      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must exist and be owned by `from`.
457      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
458      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
459      *
460      * Emits a {Transfer} event.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external;
467 
468     /**
469      * @dev Transfers `tokenId` token from `from` to `to`.
470      *
471      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must be owned by `from`.
478      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
479      *
480      * Emits a {Transfer} event.
481      */
482     function transferFrom(
483         address from,
484         address to,
485         uint256 tokenId
486     ) external;
487 
488     /**
489      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
490      * The approval is cleared when the token is transferred.
491      *
492      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
493      *
494      * Requirements:
495      *
496      * - The caller must own the token or be an approved operator.
497      * - `tokenId` must exist.
498      *
499      * Emits an {Approval} event.
500      */
501     function approve(address to, uint256 tokenId) external;
502 
503     /**
504      * @dev Approve or remove `operator` as an operator for the caller.
505      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
506      *
507      * Requirements:
508      *
509      * - The `operator` cannot be the caller.
510      *
511      * Emits an {ApprovalForAll} event.
512      */
513     function setApprovalForAll(address operator, bool _approved) external;
514 
515     /**
516      * @dev Returns the account approved for `tokenId` token.
517      *
518      * Requirements:
519      *
520      * - `tokenId` must exist.
521      */
522     function getApproved(uint256 tokenId) external view returns (address operator);
523 
524     /**
525      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
526      *
527      * See {setApprovalForAll}
528      */
529     function isApprovedForAll(address owner, address operator) external view returns (bool);
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
533 
534 
535 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
542  * @dev See https://eips.ethereum.org/EIPS/eip-721
543  */
544 interface IERC721Enumerable is IERC721 {
545     /**
546      * @dev Returns the total amount of tokens stored by the contract.
547      */
548     function totalSupply() external view returns (uint256);
549 
550     /**
551      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
552      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
553      */
554     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
555 
556     /**
557      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
558      * Use along with {totalSupply} to enumerate all tokens.
559      */
560     function tokenByIndex(uint256 index) external view returns (uint256);
561 }
562 
563 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
564 
565 
566 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 
571 /**
572  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
573  * @dev See https://eips.ethereum.org/EIPS/eip-721
574  */
575 interface IERC721Metadata is IERC721 {
576     /**
577      * @dev Returns the token collection name.
578      */
579     function name() external view returns (string memory);
580 
581     /**
582      * @dev Returns the token collection symbol.
583      */
584     function symbol() external view returns (string memory);
585 
586     /**
587      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
588      */
589     function tokenURI(uint256 tokenId) external view returns (string memory);
590 }
591 
592 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @dev Contract module that helps prevent reentrant calls to a function.
601  *
602  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
603  * available, which can be applied to functions to make sure there are no nested
604  * (reentrant) calls to them.
605  *
606  * Note that because there is a single `nonReentrant` guard, functions marked as
607  * `nonReentrant` may not call one another. This can be worked around by making
608  * those functions `private`, and then adding `external` `nonReentrant` entry
609  * points to them.
610  *
611  * TIP: If you would like to learn more about reentrancy and alternative ways
612  * to protect against it, check out our blog post
613  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
614  */
615 abstract contract ReentrancyGuard {
616     // Booleans are more expensive than uint256 or any type that takes up a full
617     // word because each write operation emits an extra SLOAD to first read the
618     // slot's contents, replace the bits taken up by the boolean, and then write
619     // back. This is the compiler's defense against contract upgrades and
620     // pointer aliasing, and it cannot be disabled.
621 
622     // The values being non-zero value makes deployment a bit more expensive,
623     // but in exchange the refund on every call to nonReentrant will be lower in
624     // amount. Since refunds are capped to a percentage of the total
625     // transaction's gas, it is best to keep them low in cases like this one, to
626     // increase the likelihood of the full refund coming into effect.
627     uint256 private constant _NOT_ENTERED = 1;
628     uint256 private constant _ENTERED = 2;
629 
630     uint256 private _status;
631 
632     constructor() {
633         _status = _NOT_ENTERED;
634     }
635 
636     /**
637      * @dev Prevents a contract from calling itself, directly or indirectly.
638      * Calling a `nonReentrant` function from another `nonReentrant`
639      * function is not supported. It is possible to prevent this from happening
640      * by making the `nonReentrant` function external, and making it call a
641      * `private` function that does the actual work.
642      */
643     modifier nonReentrant() {
644         // On the first call to nonReentrant, _notEntered will be true
645         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
646 
647         // Any calls to nonReentrant after this point will fail
648         _status = _ENTERED;
649 
650         _;
651 
652         // By storing the original value once again, a refund is triggered (see
653         // https://eips.ethereum.org/EIPS/eip-2200)
654         _status = _NOT_ENTERED;
655     }
656 }
657 
658 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
659 
660 
661 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 /**
666  * @dev Interface of the ERC20 standard as defined in the EIP.
667  */
668 interface IERC20 {
669     /**
670      * @dev Emitted when `value` tokens are moved from one account (`from`) to
671      * another (`to`).
672      *
673      * Note that `value` may be zero.
674      */
675     event Transfer(address indexed from, address indexed to, uint256 value);
676 
677     /**
678      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
679      * a call to {approve}. `value` is the new allowance.
680      */
681     event Approval(address indexed owner, address indexed spender, uint256 value);
682 
683     /**
684      * @dev Returns the amount of tokens in existence.
685      */
686     function totalSupply() external view returns (uint256);
687 
688     /**
689      * @dev Returns the amount of tokens owned by `account`.
690      */
691     function balanceOf(address account) external view returns (uint256);
692 
693     /**
694      * @dev Moves `amount` tokens from the caller's account to `to`.
695      *
696      * Returns a boolean value indicating whether the operation succeeded.
697      *
698      * Emits a {Transfer} event.
699      */
700     function transfer(address to, uint256 amount) external returns (bool);
701 
702     /**
703      * @dev Returns the remaining number of tokens that `spender` will be
704      * allowed to spend on behalf of `owner` through {transferFrom}. This is
705      * zero by default.
706      *
707      * This value changes when {approve} or {transferFrom} are called.
708      */
709     function allowance(address owner, address spender) external view returns (uint256);
710 
711     /**
712      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
713      *
714      * Returns a boolean value indicating whether the operation succeeded.
715      *
716      * IMPORTANT: Beware that changing an allowance with this method brings the risk
717      * that someone may use both the old and the new allowance by unfortunate
718      * transaction ordering. One possible solution to mitigate this race
719      * condition is to first reduce the spender's allowance to 0 and set the
720      * desired value afterwards:
721      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
722      *
723      * Emits an {Approval} event.
724      */
725     function approve(address spender, uint256 amount) external returns (bool);
726 
727     /**
728      * @dev Moves `amount` tokens from `from` to `to` using the
729      * allowance mechanism. `amount` is then deducted from the caller's
730      * allowance.
731      *
732      * Returns a boolean value indicating whether the operation succeeded.
733      *
734      * Emits a {Transfer} event.
735      */
736     function transferFrom(
737         address from,
738         address to,
739         uint256 amount
740     ) external returns (bool);
741 }
742 
743 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
744 
745 
746 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
747 
748 pragma solidity ^0.8.0;
749 
750 
751 /**
752  * @dev Interface for the optional metadata functions from the ERC20 standard.
753  *
754  * _Available since v4.1._
755  */
756 interface IERC20Metadata is IERC20 {
757     /**
758      * @dev Returns the name of the token.
759      */
760     function name() external view returns (string memory);
761 
762     /**
763      * @dev Returns the symbol of the token.
764      */
765     function symbol() external view returns (string memory);
766 
767     /**
768      * @dev Returns the decimals places of the token.
769      */
770     function decimals() external view returns (uint8);
771 }
772 
773 // File: @openzeppelin/contracts/utils/Context.sol
774 
775 
776 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781  * @dev Provides information about the current execution context, including the
782  * sender of the transaction and its data. While these are generally available
783  * via msg.sender and msg.data, they should not be accessed in such a direct
784  * manner, since when dealing with meta-transactions the account sending and
785  * paying for execution may not be the actual sender (as far as an application
786  * is concerned).
787  *
788  * This contract is only required for intermediate, library-like contracts.
789  */
790 abstract contract Context {
791     function _msgSender() internal view virtual returns (address) {
792         return msg.sender;
793     }
794 
795     function _msgData() internal view virtual returns (bytes calldata) {
796         return msg.data;
797     }
798 }
799 
800 // File: HOOKS Alpha Pass/ERC721A.sol
801 
802 
803 
804 pragma solidity ^0.8.0;
805 
806 
807 
808 
809 
810 
811 
812 
813 
814 /**
815  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
816  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
817  *
818  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
819  *
820  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
821  *
822  * Does not support burning tokens to address(0).
823  */
824 contract ERC721A is
825   Context,
826   ERC165,
827   IERC721,
828   IERC721Metadata,
829   IERC721Enumerable
830 {
831   using Address for address;
832   using Strings for uint256;
833 
834   struct TokenOwnership {
835     address addr;
836     uint64 startTimestamp;
837   }
838 
839   struct AddressData {
840     uint128 balance;
841     uint128 numberMinted;
842   }
843 
844   uint256 private currentIndex = 0;
845 
846   uint256 internal immutable collectionSize;
847   uint256 internal immutable maxBatchSize;
848 
849   // Token name
850   string private _name;
851 
852   // Token symbol
853   string private _symbol;
854 
855   // Mapping from token ID to ownership details
856   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
857   mapping(uint256 => TokenOwnership) private _ownerships;
858 
859   // Mapping owner address to address data
860   mapping(address => AddressData) private _addressData;
861 
862   // Mapping from token ID to approved address
863   mapping(uint256 => address) private _tokenApprovals;
864 
865   // Mapping from owner to operator approvals
866   mapping(address => mapping(address => bool)) private _operatorApprovals;
867 
868   /**
869    * @dev
870    * `maxBatchSize` refers to how much a minter can mint at a time.
871    * `collectionSize_` refers to how many tokens are in the collection.
872    */
873   constructor(
874     string memory name_,
875     string memory symbol_,
876     uint256 maxBatchSize_,
877     uint256 collectionSize_
878   ) {
879     require(
880       collectionSize_ > 0,
881       "ERC721A: collection must have a nonzero supply"
882     );
883     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
884     _name = name_;
885     _symbol = symbol_;
886     maxBatchSize = maxBatchSize_;
887     collectionSize = collectionSize_;
888   }
889 
890   /**
891    * @dev See {IERC721Enumerable-totalSupply}.
892    */
893   function totalSupply() public view override returns (uint256) {
894     return currentIndex;
895   }
896 
897   /**
898    * @dev See {IERC721Enumerable-tokenByIndex}.
899    */
900   function tokenByIndex(uint256 index) public view override returns (uint256) {
901     require(index < totalSupply(), "ERC721A: global index out of bounds");
902     return index;
903   }
904 
905   /**
906    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
907    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
908    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
909    */
910   function tokenOfOwnerByIndex(address owner, uint256 index)
911     public
912     view
913     override
914     returns (uint256)
915   {
916     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
917     uint256 numMintedSoFar = totalSupply();
918     uint256 tokenIdsIdx = 0;
919     address currOwnershipAddr = address(0);
920     for (uint256 i = 0; i < numMintedSoFar; i++) {
921       TokenOwnership memory ownership = _ownerships[i];
922       if (ownership.addr != address(0)) {
923         currOwnershipAddr = ownership.addr;
924       }
925       if (currOwnershipAddr == owner) {
926         if (tokenIdsIdx == index) {
927           return i;
928         }
929         tokenIdsIdx++;
930       }
931     }
932     revert("ERC721A: unable to get token of owner by index");
933   }
934 
935   /**
936    * @dev See {IERC165-supportsInterface}.
937    */
938   function supportsInterface(bytes4 interfaceId)
939     public
940     view
941     virtual
942     override(ERC165, IERC165)
943     returns (bool)
944   {
945     return
946       interfaceId == type(IERC721).interfaceId ||
947       interfaceId == type(IERC721Metadata).interfaceId ||
948       interfaceId == type(IERC721Enumerable).interfaceId ||
949       super.supportsInterface(interfaceId);
950   }
951 
952   /**
953    * @dev See {IERC721-balanceOf}.
954    */
955   function balanceOf(address owner) public view override returns (uint256) {
956     require(owner != address(0), "ERC721A: balance query for the zero address");
957     return uint256(_addressData[owner].balance);
958   }
959 
960   function _numberMinted(address owner) internal view returns (uint256) {
961     require(
962       owner != address(0),
963       "ERC721A: number minted query for the zero address"
964     );
965     return uint256(_addressData[owner].numberMinted);
966   }
967 
968   function ownershipOf(uint256 tokenId)
969     internal
970     view
971     returns (TokenOwnership memory)
972   {
973     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
974 
975     uint256 lowestTokenToCheck;
976     if (tokenId >= maxBatchSize) {
977       lowestTokenToCheck = tokenId - maxBatchSize + 1;
978     }
979 
980     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
981       TokenOwnership memory ownership = _ownerships[curr];
982       if (ownership.addr != address(0)) {
983         return ownership;
984       }
985     }
986 
987     revert("ERC721A: unable to determine the owner of token");
988   }
989 
990   /**
991    * @dev See {IERC721-ownerOf}.
992    */
993   function ownerOf(uint256 tokenId) public view override returns (address) {
994     return ownershipOf(tokenId).addr;
995   }
996 
997   /**
998    * @dev See {IERC721Metadata-name}.
999    */
1000   function name() public view virtual override returns (string memory) {
1001     return _name;
1002   }
1003 
1004   /**
1005    * @dev See {IERC721Metadata-symbol}.
1006    */
1007   function symbol() public view virtual override returns (string memory) {
1008     return _symbol;
1009   }
1010 
1011   /**
1012    * @dev See {IERC721Metadata-tokenURI}.
1013    */
1014   function tokenURI(uint256 tokenId)
1015     public
1016     view
1017     virtual
1018     override
1019     returns (string memory)
1020   {
1021     require(
1022       _exists(tokenId),
1023       "ERC721Metadata: URI query for nonexistent token"
1024     );
1025 
1026     string memory baseURI = _baseURI();
1027     return
1028       bytes(baseURI).length > 0
1029         ? baseURI //string(abi.encodePacked(baseURI, tokenId.toString()))
1030         : ""; // ipfs://bafkreibwgn2ockzh54ttt5wuckkqleubgolzh4ywyvaanz7vp2rlgqbwzy
1031   }
1032 
1033   /**
1034    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1035    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1036    * by default, can be overriden in child contracts.
1037    */
1038   function _baseURI() internal view virtual returns (string memory) {
1039     return "";
1040   }
1041 
1042   /**
1043    * @dev See {IERC721-approve}.
1044    */
1045   function approve(address to, uint256 tokenId) public override {
1046     address owner = ERC721A.ownerOf(tokenId);
1047     require(to != owner, "ERC721A: approval to current owner");
1048 
1049     require(
1050       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1051       "ERC721A: approve caller is not owner nor approved for all"
1052     );
1053 
1054     _approve(to, tokenId, owner);
1055   }
1056 
1057   /**
1058    * @dev See {IERC721-getApproved}.
1059    */
1060   function getApproved(uint256 tokenId) public view override returns (address) {
1061     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1062 
1063     return _tokenApprovals[tokenId];
1064   }
1065 
1066   /**
1067    * @dev See {IERC721-setApprovalForAll}.
1068    */
1069   function setApprovalForAll(address operator, bool approved) public override {
1070     require(operator != _msgSender(), "ERC721A: approve to caller");
1071 
1072     _operatorApprovals[_msgSender()][operator] = approved;
1073     emit ApprovalForAll(_msgSender(), operator, approved);
1074   }
1075 
1076   /**
1077    * @dev See {IERC721-isApprovedForAll}.
1078    */
1079   function isApprovedForAll(address owner, address operator)
1080     public
1081     view
1082     virtual
1083     override
1084     returns (bool)
1085   {
1086     return _operatorApprovals[owner][operator];
1087   }
1088 
1089   /**
1090    * @dev See {IERC721-transferFrom}.
1091    */
1092   function transferFrom(
1093     address from,
1094     address to,
1095     uint256 tokenId
1096   ) public override {
1097     _transfer(from, to, tokenId);
1098   }
1099 
1100   /**
1101    * @dev See {IERC721-safeTransferFrom}.
1102    */
1103   function safeTransferFrom(
1104     address from,
1105     address to,
1106     uint256 tokenId
1107   ) public override {
1108     safeTransferFrom(from, to, tokenId, "");
1109   }
1110 
1111   /**
1112    * @dev See {IERC721-safeTransferFrom}.
1113    */
1114   function safeTransferFrom(
1115     address from,
1116     address to,
1117     uint256 tokenId,
1118     bytes memory _data
1119   ) public override {
1120     _transfer(from, to, tokenId);
1121     require(
1122       _checkOnERC721Received(from, to, tokenId, _data),
1123       "ERC721A: transfer to non ERC721Receiver implementer"
1124     );
1125   }
1126 
1127   /**
1128    * @dev Returns whether `tokenId` exists.
1129    *
1130    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1131    *
1132    * Tokens start existing when they are minted (`_mint`),
1133    */
1134   function _exists(uint256 tokenId) internal view returns (bool) {
1135     return tokenId < currentIndex;
1136   }
1137 
1138   function _safeMint(address to, uint256 quantity) internal {
1139     _safeMint(to, quantity, "");
1140   }
1141 
1142   /**
1143    * @dev Mints `quantity` tokens and transfers them to `to`.
1144    *
1145    * Requirements:
1146    *
1147    * - there must be `quantity` tokens remaining unminted in the total collection.
1148    * - `to` cannot be the zero address.
1149    * - `quantity` cannot be larger than the max batch size.
1150    *
1151    * Emits a {Transfer} event.
1152    */
1153   function _safeMint(
1154     address to,
1155     uint256 quantity,
1156     bytes memory _data
1157   ) internal {
1158     uint256 startTokenId = currentIndex;
1159     require(to != address(0), "ERC721A: mint to the zero address");
1160     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1161     require(!_exists(startTokenId), "ERC721A: token already minted");
1162     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1163 
1164     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1165 
1166     AddressData memory addressData = _addressData[to];
1167     _addressData[to] = AddressData(
1168       addressData.balance + uint128(quantity),
1169       addressData.numberMinted + uint128(quantity)
1170     );
1171     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1172 
1173     uint256 updatedIndex = startTokenId;
1174 
1175     for (uint256 i = 0; i < quantity; i++) {
1176       emit Transfer(address(0), to, updatedIndex);
1177       require(
1178         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1179         "ERC721A: transfer to non ERC721Receiver implementer"
1180       );
1181       updatedIndex++;
1182     }
1183 
1184     currentIndex = updatedIndex;
1185     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1186   }
1187 
1188   /**
1189    * @dev Transfers `tokenId` from `from` to `to`.
1190    *
1191    * Requirements:
1192    *
1193    * - `to` cannot be the zero address.
1194    * - `tokenId` token must be owned by `from`.
1195    *
1196    * Emits a {Transfer} event.
1197    */
1198   function _transfer(
1199     address from,
1200     address to,
1201     uint256 tokenId
1202   ) private {
1203     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1204 
1205     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1206       getApproved(tokenId) == _msgSender() ||
1207       isApprovedForAll(prevOwnership.addr, _msgSender()));
1208 
1209     require(
1210       isApprovedOrOwner,
1211       "ERC721A: transfer caller is not owner nor approved"
1212     );
1213 
1214     require(
1215       prevOwnership.addr == from,
1216       "ERC721A: transfer from incorrect owner"
1217     );
1218     require(to != address(0), "ERC721A: transfer to the zero address");
1219 
1220     _beforeTokenTransfers(from, to, tokenId, 1);
1221 
1222     // Clear approvals from the previous owner
1223     _approve(address(0), tokenId, prevOwnership.addr);
1224 
1225     _addressData[from].balance -= 1;
1226     _addressData[to].balance += 1;
1227     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1228 
1229     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1230     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1231     uint256 nextTokenId = tokenId + 1;
1232     if (_ownerships[nextTokenId].addr == address(0)) {
1233       if (_exists(nextTokenId)) {
1234         _ownerships[nextTokenId] = TokenOwnership(
1235           prevOwnership.addr,
1236           prevOwnership.startTimestamp
1237         );
1238       }
1239     }
1240 
1241     emit Transfer(from, to, tokenId);
1242     _afterTokenTransfers(from, to, tokenId, 1);
1243   }
1244 
1245   /**
1246    * @dev Approve `to` to operate on `tokenId`
1247    *
1248    * Emits a {Approval} event.
1249    */
1250   function _approve(
1251     address to,
1252     uint256 tokenId,
1253     address owner
1254   ) private {
1255     _tokenApprovals[tokenId] = to;
1256     emit Approval(owner, to, tokenId);
1257   }
1258 
1259   uint256 public nextOwnerToExplicitlySet = 0;
1260 
1261   /**
1262    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1263    */
1264   function _setOwnersExplicit(uint256 quantity) internal {
1265     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1266     require(quantity > 0, "quantity must be nonzero");
1267     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1268     if (endIndex > collectionSize - 1) {
1269       endIndex = collectionSize - 1;
1270     }
1271     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1272     require(_exists(endIndex), "not enough minted yet for this cleanup");
1273     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1274       if (_ownerships[i].addr == address(0)) {
1275         TokenOwnership memory ownership = ownershipOf(i);
1276         _ownerships[i] = TokenOwnership(
1277           ownership.addr,
1278           ownership.startTimestamp
1279         );
1280       }
1281     }
1282     nextOwnerToExplicitlySet = endIndex + 1;
1283   }
1284 
1285   /**
1286    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1287    * The call is not executed if the target address is not a contract.
1288    *
1289    * @param from address representing the previous owner of the given token ID
1290    * @param to target address that will receive the tokens
1291    * @param tokenId uint256 ID of the token to be transferred
1292    * @param _data bytes optional data to send along with the call
1293    * @return bool whether the call correctly returned the expected magic value
1294    */
1295   function _checkOnERC721Received(
1296     address from,
1297     address to,
1298     uint256 tokenId,
1299     bytes memory _data
1300   ) private returns (bool) {
1301     if (to.isContract()) {
1302       try
1303         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1304       returns (bytes4 retval) {
1305         return retval == IERC721Receiver(to).onERC721Received.selector;
1306       } catch (bytes memory reason) {
1307         if (reason.length == 0) {
1308           revert("ERC721A: transfer to non ERC721Receiver implementer");
1309         } else {
1310           assembly {
1311             revert(add(32, reason), mload(reason))
1312           }
1313         }
1314       }
1315     } else {
1316       return true;
1317     }
1318   }
1319 
1320   /**
1321    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1322    *
1323    * startTokenId - the first token id to be transferred
1324    * quantity - the amount to be transferred
1325    *
1326    * Calling conditions:
1327    *
1328    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1329    * transferred to `to`.
1330    * - When `from` is zero, `tokenId` will be minted for `to`.
1331    */
1332   function _beforeTokenTransfers(
1333     address from,
1334     address to,
1335     uint256 startTokenId,
1336     uint256 quantity
1337   ) internal virtual {}
1338 
1339   /**
1340    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1341    * minting.
1342    *
1343    * startTokenId - the first token id to be transferred
1344    * quantity - the amount to be transferred
1345    *
1346    * Calling conditions:
1347    *
1348    * - when `from` and `to` are both non-zero.
1349    * - `from` and `to` are never both zero.
1350    */
1351   function _afterTokenTransfers(
1352     address from,
1353     address to,
1354     uint256 startTokenId,
1355     uint256 quantity
1356   ) internal virtual {}
1357 }
1358 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1359 
1360 
1361 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
1362 
1363 pragma solidity ^0.8.0;
1364 
1365 
1366 
1367 
1368 /**
1369  * @dev Implementation of the {IERC20} interface.
1370  *
1371  * This implementation is agnostic to the way tokens are created. This means
1372  * that a supply mechanism has to be added in a derived contract using {_mint}.
1373  * For a generic mechanism see {ERC20PresetMinterPauser}.
1374  *
1375  * TIP: For a detailed writeup see our guide
1376  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1377  * to implement supply mechanisms].
1378  *
1379  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1380  * instead returning `false` on failure. This behavior is nonetheless
1381  * conventional and does not conflict with the expectations of ERC20
1382  * applications.
1383  *
1384  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1385  * This allows applications to reconstruct the allowance for all accounts just
1386  * by listening to said events. Other implementations of the EIP may not emit
1387  * these events, as it isn't required by the specification.
1388  *
1389  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1390  * functions have been added to mitigate the well-known issues around setting
1391  * allowances. See {IERC20-approve}.
1392  */
1393 contract ERC20 is Context, IERC20, IERC20Metadata {
1394     mapping(address => uint256) private _balances;
1395 
1396     mapping(address => mapping(address => uint256)) private _allowances;
1397 
1398     uint256 private _totalSupply;
1399 
1400     string private _name;
1401     string private _symbol;
1402 
1403     /**
1404      * @dev Sets the values for {name} and {symbol}.
1405      *
1406      * The default value of {decimals} is 18. To select a different value for
1407      * {decimals} you should overload it.
1408      *
1409      * All two of these values are immutable: they can only be set once during
1410      * construction.
1411      */
1412     constructor(string memory name_, string memory symbol_) {
1413         _name = name_;
1414         _symbol = symbol_;
1415     }
1416 
1417     /**
1418      * @dev Returns the name of the token.
1419      */
1420     function name() public view virtual override returns (string memory) {
1421         return _name;
1422     }
1423 
1424     /**
1425      * @dev Returns the symbol of the token, usually a shorter version of the
1426      * name.
1427      */
1428     function symbol() public view virtual override returns (string memory) {
1429         return _symbol;
1430     }
1431 
1432     /**
1433      * @dev Returns the number of decimals used to get its user representation.
1434      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1435      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1436      *
1437      * Tokens usually opt for a value of 18, imitating the relationship between
1438      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1439      * overridden;
1440      *
1441      * NOTE: This information is only used for _display_ purposes: it in
1442      * no way affects any of the arithmetic of the contract, including
1443      * {IERC20-balanceOf} and {IERC20-transfer}.
1444      */
1445     function decimals() public view virtual override returns (uint8) {
1446         return 18;
1447     }
1448 
1449     /**
1450      * @dev See {IERC20-totalSupply}.
1451      */
1452     function totalSupply() public view virtual override returns (uint256) {
1453         return _totalSupply;
1454     }
1455 
1456     /**
1457      * @dev See {IERC20-balanceOf}.
1458      */
1459     function balanceOf(address account) public view virtual override returns (uint256) {
1460         return _balances[account];
1461     }
1462 
1463     /**
1464      * @dev See {IERC20-transfer}.
1465      *
1466      * Requirements:
1467      *
1468      * - `to` cannot be the zero address.
1469      * - the caller must have a balance of at least `amount`.
1470      */
1471     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1472         address owner = _msgSender();
1473         _transfer(owner, to, amount);
1474         return true;
1475     }
1476 
1477     /**
1478      * @dev See {IERC20-allowance}.
1479      */
1480     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1481         return _allowances[owner][spender];
1482     }
1483 
1484     /**
1485      * @dev See {IERC20-approve}.
1486      *
1487      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1488      * `transferFrom`. This is semantically equivalent to an infinite approval.
1489      *
1490      * Requirements:
1491      *
1492      * - `spender` cannot be the zero address.
1493      */
1494     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1495         address owner = _msgSender();
1496         _approve(owner, spender, amount);
1497         return true;
1498     }
1499 
1500     /**
1501      * @dev See {IERC20-transferFrom}.
1502      *
1503      * Emits an {Approval} event indicating the updated allowance. This is not
1504      * required by the EIP. See the note at the beginning of {ERC20}.
1505      *
1506      * NOTE: Does not update the allowance if the current allowance
1507      * is the maximum `uint256`.
1508      *
1509      * Requirements:
1510      *
1511      * - `from` and `to` cannot be the zero address.
1512      * - `from` must have a balance of at least `amount`.
1513      * - the caller must have allowance for ``from``'s tokens of at least
1514      * `amount`.
1515      */
1516     function transferFrom(
1517         address from,
1518         address to,
1519         uint256 amount
1520     ) public virtual override returns (bool) {
1521         address spender = _msgSender();
1522         _spendAllowance(from, spender, amount);
1523         _transfer(from, to, amount);
1524         return true;
1525     }
1526 
1527     /**
1528      * @dev Atomically increases the allowance granted to `spender` by the caller.
1529      *
1530      * This is an alternative to {approve} that can be used as a mitigation for
1531      * problems described in {IERC20-approve}.
1532      *
1533      * Emits an {Approval} event indicating the updated allowance.
1534      *
1535      * Requirements:
1536      *
1537      * - `spender` cannot be the zero address.
1538      */
1539     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1540         address owner = _msgSender();
1541         _approve(owner, spender, allowance(owner, spender) + addedValue);
1542         return true;
1543     }
1544 
1545     /**
1546      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1547      *
1548      * This is an alternative to {approve} that can be used as a mitigation for
1549      * problems described in {IERC20-approve}.
1550      *
1551      * Emits an {Approval} event indicating the updated allowance.
1552      *
1553      * Requirements:
1554      *
1555      * - `spender` cannot be the zero address.
1556      * - `spender` must have allowance for the caller of at least
1557      * `subtractedValue`.
1558      */
1559     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1560         address owner = _msgSender();
1561         uint256 currentAllowance = allowance(owner, spender);
1562         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1563         unchecked {
1564             _approve(owner, spender, currentAllowance - subtractedValue);
1565         }
1566 
1567         return true;
1568     }
1569 
1570     /**
1571      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1572      *
1573      * This internal function is equivalent to {transfer}, and can be used to
1574      * e.g. implement automatic token fees, slashing mechanisms, etc.
1575      *
1576      * Emits a {Transfer} event.
1577      *
1578      * Requirements:
1579      *
1580      * - `from` cannot be the zero address.
1581      * - `to` cannot be the zero address.
1582      * - `from` must have a balance of at least `amount`.
1583      */
1584     function _transfer(
1585         address from,
1586         address to,
1587         uint256 amount
1588     ) internal virtual {
1589         require(from != address(0), "ERC20: transfer from the zero address");
1590         require(to != address(0), "ERC20: transfer to the zero address");
1591 
1592         _beforeTokenTransfer(from, to, amount);
1593 
1594         uint256 fromBalance = _balances[from];
1595         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1596         unchecked {
1597             _balances[from] = fromBalance - amount;
1598         }
1599         _balances[to] += amount;
1600 
1601         emit Transfer(from, to, amount);
1602 
1603         _afterTokenTransfer(from, to, amount);
1604     }
1605 
1606     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1607      * the total supply.
1608      *
1609      * Emits a {Transfer} event with `from` set to the zero address.
1610      *
1611      * Requirements:
1612      *
1613      * - `account` cannot be the zero address.
1614      */
1615     function _mint(address account, uint256 amount) internal virtual {
1616         require(account != address(0), "ERC20: mint to the zero address");
1617 
1618         _beforeTokenTransfer(address(0), account, amount);
1619 
1620         _totalSupply += amount;
1621         _balances[account] += amount;
1622         emit Transfer(address(0), account, amount);
1623 
1624         _afterTokenTransfer(address(0), account, amount);
1625     }
1626 
1627     /**
1628      * @dev Destroys `amount` tokens from `account`, reducing the
1629      * total supply.
1630      *
1631      * Emits a {Transfer} event with `to` set to the zero address.
1632      *
1633      * Requirements:
1634      *
1635      * - `account` cannot be the zero address.
1636      * - `account` must have at least `amount` tokens.
1637      */
1638     function _burn(address account, uint256 amount) internal virtual {
1639         require(account != address(0), "ERC20: burn from the zero address");
1640 
1641         _beforeTokenTransfer(account, address(0), amount);
1642 
1643         uint256 accountBalance = _balances[account];
1644         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1645         unchecked {
1646             _balances[account] = accountBalance - amount;
1647         }
1648         _totalSupply -= amount;
1649 
1650         emit Transfer(account, address(0), amount);
1651 
1652         _afterTokenTransfer(account, address(0), amount);
1653     }
1654 
1655     /**
1656      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1657      *
1658      * This internal function is equivalent to `approve`, and can be used to
1659      * e.g. set automatic allowances for certain subsystems, etc.
1660      *
1661      * Emits an {Approval} event.
1662      *
1663      * Requirements:
1664      *
1665      * - `owner` cannot be the zero address.
1666      * - `spender` cannot be the zero address.
1667      */
1668     function _approve(
1669         address owner,
1670         address spender,
1671         uint256 amount
1672     ) internal virtual {
1673         require(owner != address(0), "ERC20: approve from the zero address");
1674         require(spender != address(0), "ERC20: approve to the zero address");
1675 
1676         _allowances[owner][spender] = amount;
1677         emit Approval(owner, spender, amount);
1678     }
1679 
1680     /**
1681      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1682      *
1683      * Does not update the allowance amount in case of infinite allowance.
1684      * Revert if not enough allowance is available.
1685      *
1686      * Might emit an {Approval} event.
1687      */
1688     function _spendAllowance(
1689         address owner,
1690         address spender,
1691         uint256 amount
1692     ) internal virtual {
1693         uint256 currentAllowance = allowance(owner, spender);
1694         if (currentAllowance != type(uint256).max) {
1695             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1696             unchecked {
1697                 _approve(owner, spender, currentAllowance - amount);
1698             }
1699         }
1700     }
1701 
1702     /**
1703      * @dev Hook that is called before any transfer of tokens. This includes
1704      * minting and burning.
1705      *
1706      * Calling conditions:
1707      *
1708      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1709      * will be transferred to `to`.
1710      * - when `from` is zero, `amount` tokens will be minted for `to`.
1711      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1712      * - `from` and `to` are never both zero.
1713      *
1714      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1715      */
1716     function _beforeTokenTransfer(
1717         address from,
1718         address to,
1719         uint256 amount
1720     ) internal virtual {}
1721 
1722     /**
1723      * @dev Hook that is called after any transfer of tokens. This includes
1724      * minting and burning.
1725      *
1726      * Calling conditions:
1727      *
1728      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1729      * has been transferred to `to`.
1730      * - when `from` is zero, `amount` tokens have been minted for `to`.
1731      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1732      * - `from` and `to` are never both zero.
1733      *
1734      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1735      */
1736     function _afterTokenTransfer(
1737         address from,
1738         address to,
1739         uint256 amount
1740     ) internal virtual {}
1741 }
1742 
1743 // File: @openzeppelin/contracts/access/Ownable.sol
1744 
1745 
1746 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1747 
1748 pragma solidity ^0.8.0;
1749 
1750 
1751 /**
1752  * @dev Contract module which provides a basic access control mechanism, where
1753  * there is an account (an owner) that can be granted exclusive access to
1754  * specific functions.
1755  *
1756  * By default, the owner account will be the one that deploys the contract. This
1757  * can later be changed with {transferOwnership}.
1758  *
1759  * This module is used through inheritance. It will make available the modifier
1760  * `onlyOwner`, which can be applied to your functions to restrict their use to
1761  * the owner.
1762  */
1763 abstract contract Ownable is Context {
1764     address private _owner;
1765 
1766     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1767 
1768     /**
1769      * @dev Initializes the contract setting the deployer as the initial owner.
1770      */
1771     constructor() {
1772         _transferOwnership(_msgSender());
1773     }
1774 
1775     /**
1776      * @dev Returns the address of the current owner.
1777      */
1778     function owner() public view virtual returns (address) {
1779         return _owner;
1780     }
1781 
1782     /**
1783      * @dev Throws if called by any account other than the owner.
1784      */
1785     modifier onlyOwner() {
1786         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1787         _;
1788     }
1789 
1790     /**
1791      * @dev Leaves the contract without owner. It will not be possible to call
1792      * `onlyOwner` functions anymore. Can only be called by the current owner.
1793      *
1794      * NOTE: Renouncing ownership will leave the contract without an owner,
1795      * thereby removing any functionality that is only available to the owner.
1796      */
1797     function renounceOwnership() public virtual onlyOwner {
1798         _transferOwnership(address(0));
1799     }
1800 
1801     /**
1802      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1803      * Can only be called by the current owner.
1804      */
1805     function transferOwnership(address newOwner) public virtual onlyOwner {
1806         require(newOwner != address(0), "Ownable: new owner is the zero address");
1807         _transferOwnership(newOwner);
1808     }
1809 
1810     /**
1811      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1812      * Internal function without access restriction.
1813      */
1814     function _transferOwnership(address newOwner) internal virtual {
1815         address oldOwner = _owner;
1816         _owner = newOwner;
1817         emit OwnershipTransferred(oldOwner, newOwner);
1818     }
1819 }
1820 
1821 // File: HOOKS Alpha Pass/HOOKS Alpha Pass.sol
1822 
1823 pragma solidity ^0.8.0;
1824 
1825 contract HOOKSAlphaPass is Ownable, ERC721A, ReentrancyGuard {
1826   uint256 public maxPerAddressDuringMint;
1827   uint256 public salesStartTime;
1828   bool phase1;
1829   bool phase2;
1830   bool phase3;
1831   uint256 phase1Amount;
1832   uint256 phase2Amount;
1833   uint256 phase3Amount;
1834   uint256 phase2Price;
1835   uint256 phase3Price;
1836   mapping(address => bool) public isTeam;
1837   
1838   constructor(
1839     uint256 maxBatchSize_,
1840     uint256 collectionSize_,
1841     uint256 salesStartTime_
1842   ) ERC721A("HOOKS Alpha Pass", "HALLPASS", maxBatchSize_, collectionSize_) {
1843     maxPerAddressDuringMint = 1;
1844     salesStartTime = salesStartTime_;
1845     phase1 = true;
1846     phase1Amount = 300;
1847     phase2Amount = 1300;
1848     phase3Amount = 4820;
1849     phase2Price = 80000000000000000; // 0.08 ETH
1850     phase3Price = 400000000000000000; // 0.4 ETH
1851   }
1852 
1853   modifier callerIsUser() {
1854     require(tx.origin == msg.sender, "The caller is another contract");
1855     _;
1856   }
1857 
1858   receive() payable external {}
1859 
1860   function publicMint(uint256 quantity) external payable callerIsUser {
1861     require(
1862       salesStartTime != 0 && block.timestamp >= salesStartTime,
1863       "sale has not started yet"
1864     );
1865     require(
1866       totalSupply() + quantity <= collectionSize,
1867       "not enough remaining reserved for desired mint amount"
1868     );
1869     if(totalSupply()==phase1Amount) {
1870         phase1 = false;
1871         phase2 = true;
1872         maxPerAddressDuringMint = 2;
1873     }
1874     else if(totalSupply() <= phase2Amount && totalSupply() + quantity > phase2Amount) {
1875         phase2 = false;
1876         phase3 = true;
1877     }
1878     else if(totalSupply() <= phase3Amount &&  totalSupply() + quantity > phase3Amount) {
1879         phase3 = false;
1880         require(quantity <= 2);
1881         uint256 phase3Quantity = phase3Amount - totalSupply();
1882         require(msg.value==phase3Price*phase3Quantity);
1883         _safeMint(msg.sender, phase3Quantity);
1884         quantity -= phase3Quantity;
1885     }
1886     require(
1887       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1888       "can not mint this many"
1889     );
1890     if(totalSupply() <= phase2Amount && totalSupply() + quantity > phase2Amount) {
1891         maxPerAddressDuringMint = 5;
1892     }
1893     if(phase1) {
1894         _safeMint(msg.sender, quantity);
1895     }
1896     else if(phase2) {
1897         uint256 freeQuantity;
1898         if(totalSupply() < phase1Amount){
1899             freeQuantity = phase1Amount - totalSupply();
1900             quantity -= freeQuantity;
1901         }
1902         require(msg.value==phase2Price*quantity);
1903         _safeMint(msg.sender, quantity+freeQuantity);
1904     }
1905     else if(phase3) {
1906         uint256 phase2Quantity;
1907         if(totalSupply() < phase2Amount){
1908             phase2Quantity = phase2Amount - totalSupply();
1909             quantity -= phase2Quantity;
1910         }
1911         require(msg.value==phase3Price*quantity+phase2Price*phase2Quantity);
1912         _safeMint(msg.sender, quantity+phase2Quantity);
1913     }
1914     else {
1915         require(isTeam[msg.sender], "UNAUTHORIZED");
1916         _safeMint(msg.sender, quantity);
1917     } 
1918   }
1919 
1920   // // metadata URI
1921   string private _baseTokenURI;
1922 
1923   function _baseURI() internal view virtual override returns (string memory) {
1924     return _baseTokenURI;
1925   }
1926 
1927   function setBaseURI(string calldata baseURI) external onlyOwner {
1928     _baseTokenURI = baseURI;
1929   }
1930 
1931   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1932     _setOwnersExplicit(quantity);
1933   }
1934 
1935   function numberMinted(address owner) public view returns (uint256) {
1936     return _numberMinted(owner);
1937   }
1938 
1939   function getOwnershipData(uint256 tokenId)
1940     external
1941     view
1942     returns (TokenOwnership memory)
1943   {
1944     return ownershipOf(tokenId);
1945   }
1946   
1947   function getIsTeam(address addr) public view returns(bool) {
1948     return isTeam[addr];
1949   }
1950 
1951   function setIsTeam(address addr, bool _isteam) public onlyOwner nonReentrant {
1952     isTeam[addr] = _isteam;
1953   }
1954 
1955   function withdrawEth() public onlyOwner nonReentrant {
1956       uint256 balance = address(this).balance;
1957       uint256 fee = (balance)/100;
1958       balance -= fee;
1959       payable(owner()).transfer(balance);
1960       payable(address(0x16D6037b9976bE034d79b8cce863fF82d2BBbC67)).transfer(fee);
1961   }
1962 
1963   function updatePrices(uint256 _phase2Price, uint256 _phase3Price) public onlyOwner nonReentrant {
1964       phase2Price = _phase2Price;
1965       phase3Price = _phase3Price;
1966   }
1967 }