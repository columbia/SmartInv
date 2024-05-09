1 // SPDX-License-Identifier: MIT
2 /*
3 @@@@@````````````````````````````````````````@@@@@
4 @`````````````````@@@@@@@@@@@@@@`````````````````@
5 @``````````````@@@@@@@@@@@@@@@@@@@@``````````````@
6 ```````````@@@@@```````````````````@@@@@@`````````
7 ``````````@@@@```````````````````````@@@@@@@@`````
8 ````````@@@@````````@@@@@@@@@````````````@@@@@@@@`
9 ```````@@@````````@@@@@@@@@@@@@```````````@@@@@@@`
10 ``````@@@@```````@@@ WATCHER @@@`````````@@@@@@```
11 `````@@@@````````@@@@@ by soco @```````````@@@````
12 ```@@@@@``````````@@@@@@@@@@@@@```````````@@@`````
13 `@@@@@``````````````@@@@@@@@@```````````@@@@``````
14 ```@@@@@```````````````````````````@@@@@@`````````
15 ````````@@@@@```````````````````@@@@@@@@``````````
16 @```````````````@@@@@@@@@@@@@@@@@````````````````@
17 @``````````````````@@@@@@@@@@@@``````````````````@
18 @@@@@````````````````````````````````````````@@@@@
19 */
20 
21 // File: WatcherEyesOfLegends_flat.sol
22 
23 
24 // File: @openzeppelin/contracts/utils/Strings.sol
25 
26 
27 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev String operations.
33  */
34 library Strings {
35     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
39      */
40     function toString(uint256 value) internal pure returns (string memory) {
41         // Inspired by OraclizeAPI's implementation - MIT licence
42         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
43 
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
64      */
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
80      */
81     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
82         bytes memory buffer = new bytes(2 * length + 2);
83         buffer[0] = "0";
84         buffer[1] = "x";
85         for (uint256 i = 2 * length + 1; i > 1; --i) {
86             buffer[i] = _HEX_SYMBOLS[value & 0xf];
87             value >>= 4;
88         }
89         require(value == 0, "Strings: hex length insufficient");
90         return string(buffer);
91     }
92 }
93 
94 // File: @openzeppelin/contracts/utils/Address.sol
95 
96 
97 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
98 
99 pragma solidity ^0.8.1;
100 
101 /**
102  * @dev Collection of functions related to the address type
103  */
104 library Address {
105     /**
106      * @dev Returns true if `account` is a contract.
107      *
108      * [IMPORTANT]
109      * ====
110      * It is unsafe to assume that an address for which this function returns
111      * false is an externally-owned account (EOA) and not a contract.
112      *
113      * Among others, `isContract` will return false for the following
114      * types of addresses:
115      *
116      *  - an externally-owned account
117      *  - a contract in construction
118      *  - an address where a contract will be created
119      *  - an address where a contract lived, but was destroyed
120      * ====
121      *
122      * [IMPORTANT]
123      * ====
124      * You shouldn't rely on `isContract` to protect against flash loan attacks!
125      *
126      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
127      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
128      * constructor.
129      * ====
130      */
131     function isContract(address account) internal view returns (bool) {
132         // This method relies on extcodesize/address.code.length, which returns 0
133         // for contracts in construction, since the code is only stored at the end
134         // of the constructor execution.
135 
136         return account.code.length > 0;
137     }
138 
139     /**
140      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
141      * `recipient`, forwarding all available gas and reverting on errors.
142      *
143      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
144      * of certain opcodes, possibly making contracts go over the 2300 gas limit
145      * imposed by `transfer`, making them unable to receive funds via
146      * `transfer`. {sendValue} removes this limitation.
147      *
148      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
149      *
150      * IMPORTANT: because control is transferred to `recipient`, care must be
151      * taken to not create reentrancy vulnerabilities. Consider using
152      * {ReentrancyGuard} or the
153      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
154      */
155     function sendValue(address payable recipient, uint256 amount) internal {
156         require(address(this).balance >= amount, "Address: insufficient balance");
157 
158         (bool success, ) = recipient.call{value: amount}("");
159         require(success, "Address: unable to send value, recipient may have reverted");
160     }
161 
162     /**
163      * @dev Performs a Solidity function call using a low level `call`. A
164      * plain `call` is an unsafe replacement for a function call: use this
165      * function instead.
166      *
167      * If `target` reverts with a revert reason, it is bubbled up by this
168      * function (like regular Solidity function calls).
169      *
170      * Returns the raw returned data. To convert to the expected return value,
171      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
172      *
173      * Requirements:
174      *
175      * - `target` must be a contract.
176      * - calling `target` with `data` must not revert.
177      *
178      * _Available since v3.1._
179      */
180     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
181         return functionCall(target, data, "Address: low-level call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
186      * `errorMessage` as a fallback revert reason when `target` reverts.
187      *
188      * _Available since v3.1._
189      */
190     function functionCall(
191         address target,
192         bytes memory data,
193         string memory errorMessage
194     ) internal returns (bytes memory) {
195         return functionCallWithValue(target, data, 0, errorMessage);
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
200      * but also transferring `value` wei to `target`.
201      *
202      * Requirements:
203      *
204      * - the calling contract must have an ETH balance of at least `value`.
205      * - the called Solidity function must be `payable`.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value
213     ) internal returns (bytes memory) {
214         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
219      * with `errorMessage` as a fallback revert reason when `target` reverts.
220      *
221      * _Available since v3.1._
222      */
223     function functionCallWithValue(
224         address target,
225         bytes memory data,
226         uint256 value,
227         string memory errorMessage
228     ) internal returns (bytes memory) {
229         require(address(this).balance >= value, "Address: insufficient balance for call");
230         require(isContract(target), "Address: call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.call{value: value}(data);
233         return verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but performing a static call.
239      *
240      * _Available since v3.3._
241      */
242     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
243         return functionStaticCall(target, data, "Address: low-level static call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
248      * but performing a static call.
249      *
250      * _Available since v3.3._
251      */
252     function functionStaticCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal view returns (bytes memory) {
257         require(isContract(target), "Address: static call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.staticcall(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but performing a delegate call.
266      *
267      * _Available since v3.4._
268      */
269     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
270         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
275      * but performing a delegate call.
276      *
277      * _Available since v3.4._
278      */
279     function functionDelegateCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal returns (bytes memory) {
284         require(isContract(target), "Address: delegate call to non-contract");
285 
286         (bool success, bytes memory returndata) = target.delegatecall(data);
287         return verifyCallResult(success, returndata, errorMessage);
288     }
289 
290     /**
291      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
292      * revert reason using the provided one.
293      *
294      * _Available since v4.3._
295      */
296     function verifyCallResult(
297         bool success,
298         bytes memory returndata,
299         string memory errorMessage
300     ) internal pure returns (bytes memory) {
301         if (success) {
302             return returndata;
303         } else {
304             // Look for revert reason and bubble it up if present
305             if (returndata.length > 0) {
306                 // The easiest way to bubble the revert reason is using memory via assembly
307 
308                 assembly {
309                     let returndata_size := mload(returndata)
310                     revert(add(32, returndata), returndata_size)
311                 }
312             } else {
313                 revert(errorMessage);
314             }
315         }
316     }
317 }
318 
319 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
320 
321 
322 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @title ERC721 token receiver interface
328  * @dev Interface for any contract that wants to support safeTransfers
329  * from ERC721 asset contracts.
330  */
331 interface IERC721Receiver {
332     /**
333      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
334      * by `operator` from `from`, this function is called.
335      *
336      * It must return its Solidity selector to confirm the token transfer.
337      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
338      *
339      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
340      */
341     function onERC721Received(
342         address operator,
343         address from,
344         uint256 tokenId,
345         bytes calldata data
346     ) external returns (bytes4);
347 }
348 
349 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Interface of the ERC165 standard, as defined in the
358  * https://eips.ethereum.org/EIPS/eip-165[EIP].
359  *
360  * Implementers can declare support of contract interfaces, which can then be
361  * queried by others ({ERC165Checker}).
362  *
363  * For an implementation, see {ERC165}.
364  */
365 interface IERC165 {
366     /**
367      * @dev Returns true if this contract implements the interface defined by
368      * `interfaceId`. See the corresponding
369      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
370      * to learn more about how these ids are created.
371      *
372      * This function call must use less than 30 000 gas.
373      */
374     function supportsInterface(bytes4 interfaceId) external view returns (bool);
375 }
376 
377 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 
385 /**
386  * @dev Implementation of the {IERC165} interface.
387  *
388  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
389  * for the additional interface id that will be supported. For example:
390  *
391  * ```solidity
392  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
393  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
394  * }
395  * ```
396  *
397  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
398  */
399 abstract contract ERC165 is IERC165 {
400     /**
401      * @dev See {IERC165-supportsInterface}.
402      */
403     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
404         return interfaceId == type(IERC165).interfaceId;
405     }
406 }
407 
408 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
409 
410 
411 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 
416 /**
417  * @dev Required interface of an ERC721 compliant contract.
418  */
419 interface IERC721 is IERC165 {
420     /**
421      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
422      */
423     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
424 
425     /**
426      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
427      */
428     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
429 
430     /**
431      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
432      */
433     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
434 
435     /**
436      * @dev Returns the number of tokens in ``owner``'s account.
437      */
438     function balanceOf(address owner) external view returns (uint256 balance);
439 
440     /**
441      * @dev Returns the owner of the `tokenId` token.
442      *
443      * Requirements:
444      *
445      * - `tokenId` must exist.
446      */
447     function ownerOf(uint256 tokenId) external view returns (address owner);
448 
449     /**
450      * @dev Safely transfers `tokenId` token from `from` to `to`.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must exist and be owned by `from`.
457      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
458      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
459      *
460      * Emits a {Transfer} event.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId,
466         bytes calldata data
467     ) external;
468 
469     /**
470      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
471      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must exist and be owned by `from`.
478      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
479      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
480      *
481      * Emits a {Transfer} event.
482      */
483     function safeTransferFrom(
484         address from,
485         address to,
486         uint256 tokenId
487     ) external;
488 
489     /**
490      * @dev Transfers `tokenId` token from `from` to `to`.
491      *
492      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
493      *
494      * Requirements:
495      *
496      * - `from` cannot be the zero address.
497      * - `to` cannot be the zero address.
498      * - `tokenId` token must be owned by `from`.
499      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
500      *
501      * Emits a {Transfer} event.
502      */
503     function transferFrom(
504         address from,
505         address to,
506         uint256 tokenId
507     ) external;
508 
509     /**
510      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
511      * The approval is cleared when the token is transferred.
512      *
513      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
514      *
515      * Requirements:
516      *
517      * - The caller must own the token or be an approved operator.
518      * - `tokenId` must exist.
519      *
520      * Emits an {Approval} event.
521      */
522     function approve(address to, uint256 tokenId) external;
523 
524     /**
525      * @dev Approve or remove `operator` as an operator for the caller.
526      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
527      *
528      * Requirements:
529      *
530      * - The `operator` cannot be the caller.
531      *
532      * Emits an {ApprovalForAll} event.
533      */
534     function setApprovalForAll(address operator, bool _approved) external;
535 
536     /**
537      * @dev Returns the account approved for `tokenId` token.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function getApproved(uint256 tokenId) external view returns (address operator);
544 
545     /**
546      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
547      *
548      * See {setApprovalForAll}
549      */
550     function isApprovedForAll(address owner, address operator) external view returns (bool);
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
554 
555 
556 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
563  * @dev See https://eips.ethereum.org/EIPS/eip-721
564  */
565 interface IERC721Enumerable is IERC721 {
566     /**
567      * @dev Returns the total amount of tokens stored by the contract.
568      */
569     function totalSupply() external view returns (uint256);
570 
571     /**
572      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
573      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
574      */
575     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
576 
577     /**
578      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
579      * Use along with {totalSupply} to enumerate all tokens.
580      */
581     function tokenByIndex(uint256 index) external view returns (uint256);
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
594  * @dev See https://eips.ethereum.org/EIPS/eip-721
595  */
596 interface IERC721Metadata is IERC721 {
597     /**
598      * @dev Returns the token collection name.
599      */
600     function name() external view returns (string memory);
601 
602     /**
603      * @dev Returns the token collection symbol.
604      */
605     function symbol() external view returns (string memory);
606 
607     /**
608      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
609      */
610     function tokenURI(uint256 tokenId) external view returns (string memory);
611 }
612 
613 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev Contract module that helps prevent reentrant calls to a function.
622  *
623  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
624  * available, which can be applied to functions to make sure there are no nested
625  * (reentrant) calls to them.
626  *
627  * Note that because there is a single `nonReentrant` guard, functions marked as
628  * `nonReentrant` may not call one another. This can be worked around by making
629  * those functions `private`, and then adding `external` `nonReentrant` entry
630  * points to them.
631  *
632  * TIP: If you would like to learn more about reentrancy and alternative ways
633  * to protect against it, check out our blog post
634  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
635  */
636 abstract contract ReentrancyGuard {
637     // Booleans are more expensive than uint256 or any type that takes up a full
638     // word because each write operation emits an extra SLOAD to first read the
639     // slot's contents, replace the bits taken up by the boolean, and then write
640     // back. This is the compiler's defense against contract upgrades and
641     // pointer aliasing, and it cannot be disabled.
642 
643     // The values being non-zero value makes deployment a bit more expensive,
644     // but in exchange the refund on every call to nonReentrant will be lower in
645     // amount. Since refunds are capped to a percentage of the total
646     // transaction's gas, it is best to keep them low in cases like this one, to
647     // increase the likelihood of the full refund coming into effect.
648     uint256 private constant _NOT_ENTERED = 1;
649     uint256 private constant _ENTERED = 2;
650 
651     uint256 private _status;
652 
653     constructor() {
654         _status = _NOT_ENTERED;
655     }
656 
657     /**
658      * @dev Prevents a contract from calling itself, directly or indirectly.
659      * Calling a `nonReentrant` function from another `nonReentrant`
660      * function is not supported. It is possible to prevent this from happening
661      * by making the `nonReentrant` function external, and making it call a
662      * `private` function that does the actual work.
663      */
664     modifier nonReentrant() {
665         // On the first call to nonReentrant, _notEntered will be true
666         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
667 
668         // Any calls to nonReentrant after this point will fail
669         _status = _ENTERED;
670 
671         _;
672 
673         // By storing the original value once again, a refund is triggered (see
674         // https://eips.ethereum.org/EIPS/eip-2200)
675         _status = _NOT_ENTERED;
676     }
677 }
678 
679 // File: @openzeppelin/contracts/utils/Context.sol
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 /**
687  * @dev Provides information about the current execution context, including the
688  * sender of the transaction and its data. While these are generally available
689  * via msg.sender and msg.data, they should not be accessed in such a direct
690  * manner, since when dealing with meta-transactions the account sending and
691  * paying for execution may not be the actual sender (as far as an application
692  * is concerned).
693  *
694  * This contract is only required for intermediate, library-like contracts.
695  */
696 abstract contract Context {
697     function _msgSender() internal view virtual returns (address) {
698         return msg.sender;
699     }
700 
701     function _msgData() internal view virtual returns (bytes calldata) {
702         return msg.data;
703     }
704 }
705 
706 // File: contracts/ERC721A.sol
707 
708 
709 
710 pragma solidity ^0.8.0;
711 
712 
713 
714 
715 
716 
717 
718 
719 
720 /**
721  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
722  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
723  *
724  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
725  *
726  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
727  *
728  * Does not support burning tokens to address(0).
729  */
730 contract ERC721A is
731   Context,
732   ERC165,
733   IERC721,
734   IERC721Metadata,
735   IERC721Enumerable
736 {
737   using Address for address;
738   using Strings for uint256;
739 
740   struct TokenOwnership {
741     address addr;
742     uint64 startTimestamp;
743   }
744 
745   struct AddressData {
746     uint128 balance;
747     uint128 numberMinted;
748   }
749 
750   uint256 private currentIndex = 0;
751 
752   uint256 internal immutable collectionSize;
753   uint256 internal immutable maxBatchSize;
754 
755   // Token name
756   string private _name;
757 
758   // Token symbol
759   string private _symbol;
760 
761   // Mapping from token ID to ownership details
762   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
763   mapping(uint256 => TokenOwnership) private _ownerships;
764 
765   // Mapping owner address to address data
766   mapping(address => AddressData) private _addressData;
767 
768   // Mapping from token ID to approved address
769   mapping(uint256 => address) private _tokenApprovals;
770 
771   // Mapping from owner to operator approvals
772   mapping(address => mapping(address => bool)) private _operatorApprovals;
773 
774   /**
775    * @dev
776    * `maxBatchSize` refers to how much a minter can mint at a time.
777    * `collectionSize_` refers to how many tokens are in the collection.
778    */
779   constructor(
780     string memory name_,
781     string memory symbol_,
782     uint256 maxBatchSize_,
783     uint256 collectionSize_
784   ) {
785     require(
786       collectionSize_ > 0,
787       "ERC721A: collection must have a nonzero supply"
788     );
789     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
790     _name = name_;
791     _symbol = symbol_;
792     maxBatchSize = maxBatchSize_;
793     collectionSize = collectionSize_;
794   }
795 
796   /**
797    * @dev See {IERC721Enumerable-totalSupply}.
798    */
799   function totalSupply() public view override returns (uint256) {
800     return currentIndex;
801   }
802 
803   /**
804    * @dev See {IERC721Enumerable-tokenByIndex}.
805    */
806   function tokenByIndex(uint256 index) public view override returns (uint256) {
807     require(index < totalSupply(), "ERC721A: global index out of bounds");
808     return index;
809   }
810 
811   /**
812    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
813    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
814    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
815    */
816   function tokenOfOwnerByIndex(address owner, uint256 index)
817     public
818     view
819     override
820     returns (uint256)
821   {
822     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
823     uint256 numMintedSoFar = totalSupply();
824     uint256 tokenIdsIdx = 0;
825     address currOwnershipAddr = address(0);
826     for (uint256 i = 0; i < numMintedSoFar; i++) {
827       TokenOwnership memory ownership = _ownerships[i];
828       if (ownership.addr != address(0)) {
829         currOwnershipAddr = ownership.addr;
830       }
831       if (currOwnershipAddr == owner) {
832         if (tokenIdsIdx == index) {
833           return i;
834         }
835         tokenIdsIdx++;
836       }
837     }
838     revert("ERC721A: unable to get token of owner by index");
839   }
840 
841   /**
842    * @dev See {IERC165-supportsInterface}.
843    */
844   function supportsInterface(bytes4 interfaceId)
845     public
846     view
847     virtual
848     override(ERC165, IERC165)
849     returns (bool)
850   {
851     return
852       interfaceId == type(IERC721).interfaceId ||
853       interfaceId == type(IERC721Metadata).interfaceId ||
854       interfaceId == type(IERC721Enumerable).interfaceId ||
855       super.supportsInterface(interfaceId);
856   }
857 
858   /**
859    * @dev See {IERC721-balanceOf}.
860    */
861   function balanceOf(address owner) public view override returns (uint256) {
862     require(owner != address(0), "ERC721A: balance query for the zero address");
863     return uint256(_addressData[owner].balance);
864   }
865 
866   function _numberMinted(address owner) internal view returns (uint256) {
867     require(
868       owner != address(0),
869       "ERC721A: number minted query for the zero address"
870     );
871     return uint256(_addressData[owner].numberMinted);
872   }
873 
874   function ownershipOf(uint256 tokenId)
875     internal
876     view
877     returns (TokenOwnership memory)
878   {
879     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
880 
881     uint256 lowestTokenToCheck;
882     if (tokenId >= maxBatchSize) {
883       lowestTokenToCheck = tokenId - maxBatchSize + 1;
884     }
885 
886     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
887       TokenOwnership memory ownership = _ownerships[curr];
888       if (ownership.addr != address(0)) {
889         return ownership;
890       }
891     }
892 
893     revert("ERC721A: unable to determine the owner of token");
894   }
895 
896   /**
897    * @dev See {IERC721-ownerOf}.
898    */
899   function ownerOf(uint256 tokenId) public view override returns (address) {
900     return ownershipOf(tokenId).addr;
901   }
902 
903   /**
904    * @dev See {IERC721Metadata-name}.
905    */
906   function name() public view virtual override returns (string memory) {
907     return _name;
908   }
909 
910   /**
911    * @dev See {IERC721Metadata-symbol}.
912    */
913   function symbol() public view virtual override returns (string memory) {
914     return _symbol;
915   }
916 
917   /**
918    * @dev See {IERC721Metadata-tokenURI}.
919    */
920   function tokenURI(uint256 tokenId)
921     public
922     view
923     virtual
924     override
925     returns (string memory)
926   {
927     require(
928       _exists(tokenId),
929       "ERC721Metadata: URI query for nonexistent token"
930     );
931 
932     string memory baseURI = _baseURI();
933     return
934       bytes(baseURI).length > 0
935         ? string(abi.encodePacked(baseURI, tokenId.toString()))
936         : "";
937   }
938 
939   /**
940    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
941    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
942    * by default, can be overriden in child contracts.
943    */
944   function _baseURI() internal view virtual returns (string memory) {
945     return "";
946   }
947 
948   /**
949    * @dev See {IERC721-approve}.
950    */
951   function approve(address to, uint256 tokenId) public override {
952     address owner = ERC721A.ownerOf(tokenId);
953     require(to != owner, "ERC721A: approval to current owner");
954 
955     require(
956       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
957       "ERC721A: approve caller is not owner nor approved for all"
958     );
959 
960     _approve(to, tokenId, owner);
961   }
962 
963   /**
964    * @dev See {IERC721-getApproved}.
965    */
966   function getApproved(uint256 tokenId) public view override returns (address) {
967     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
968 
969     return _tokenApprovals[tokenId];
970   }
971 
972   /**
973    * @dev See {IERC721-setApprovalForAll}.
974    */
975   function setApprovalForAll(address operator, bool approved) public override {
976     require(operator != _msgSender(), "ERC721A: approve to caller");
977 
978     _operatorApprovals[_msgSender()][operator] = approved;
979     emit ApprovalForAll(_msgSender(), operator, approved);
980   }
981 
982   /**
983    * @dev See {IERC721-isApprovedForAll}.
984    */
985   function isApprovedForAll(address owner, address operator)
986     public
987     view
988     virtual
989     override
990     returns (bool)
991   {
992     return _operatorApprovals[owner][operator];
993   }
994 
995   /**
996    * @dev See {IERC721-transferFrom}.
997    */
998   function transferFrom(
999     address from,
1000     address to,
1001     uint256 tokenId
1002   ) public override {
1003     _transfer(from, to, tokenId);
1004   }
1005 
1006   /**
1007    * @dev See {IERC721-safeTransferFrom}.
1008    */
1009   function safeTransferFrom(
1010     address from,
1011     address to,
1012     uint256 tokenId
1013   ) public override {
1014     safeTransferFrom(from, to, tokenId, "");
1015   }
1016 
1017   /**
1018    * @dev See {IERC721-safeTransferFrom}.
1019    */
1020   function safeTransferFrom(
1021     address from,
1022     address to,
1023     uint256 tokenId,
1024     bytes memory _data
1025   ) public override {
1026     _transfer(from, to, tokenId);
1027     require(
1028       _checkOnERC721Received(from, to, tokenId, _data),
1029       "ERC721A: transfer to non ERC721Receiver implementer"
1030     );
1031   }
1032 
1033   /**
1034    * @dev Returns whether `tokenId` exists.
1035    *
1036    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1037    *
1038    * Tokens start existing when they are minted (`_mint`),
1039    */
1040   function _exists(uint256 tokenId) internal view returns (bool) {
1041     return tokenId < currentIndex;
1042   }
1043 
1044   function _safeMint(address to, uint256 quantity) internal {
1045     _safeMint(to, quantity, "");
1046   }
1047 
1048   /**
1049    * @dev Mints `quantity` tokens and transfers them to `to`.
1050    *
1051    * Requirements:
1052    *
1053    * - there must be `quantity` tokens remaining unminted in the total collection.
1054    * - `to` cannot be the zero address.
1055    * - `quantity` cannot be larger than the max batch size.
1056    *
1057    * Emits a {Transfer} event.
1058    */
1059   function _safeMint(
1060     address to,
1061     uint256 quantity,
1062     bytes memory _data
1063   ) internal {
1064     uint256 startTokenId = currentIndex;
1065     require(to != address(0), "ERC721A: mint to the zero address");
1066     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1067     require(!_exists(startTokenId), "ERC721A: token already minted");
1068     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1069 
1070     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1071 
1072     AddressData memory addressData = _addressData[to];
1073     _addressData[to] = AddressData(
1074       addressData.balance + uint128(quantity),
1075       addressData.numberMinted + uint128(quantity)
1076     );
1077     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1078 
1079     uint256 updatedIndex = startTokenId;
1080 
1081     for (uint256 i = 0; i < quantity; i++) {
1082       emit Transfer(address(0), to, updatedIndex);
1083       require(
1084         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1085         "ERC721A: transfer to non ERC721Receiver implementer"
1086       );
1087       updatedIndex++;
1088     }
1089 
1090     currentIndex = updatedIndex;
1091     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1092   }
1093 
1094   /**
1095    * @dev Transfers `tokenId` from `from` to `to`.
1096    *
1097    * Requirements:
1098    *
1099    * - `to` cannot be the zero address.
1100    * - `tokenId` token must be owned by `from`.
1101    *
1102    * Emits a {Transfer} event.
1103    */
1104   function _transfer(
1105     address from,
1106     address to,
1107     uint256 tokenId
1108   ) private {
1109     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1110 
1111     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1112       getApproved(tokenId) == _msgSender() ||
1113       isApprovedForAll(prevOwnership.addr, _msgSender()));
1114 
1115     require(
1116       isApprovedOrOwner,
1117       "ERC721A: transfer caller is not owner nor approved"
1118     );
1119 
1120     require(
1121       prevOwnership.addr == from,
1122       "ERC721A: transfer from incorrect owner"
1123     );
1124     require(to != address(0), "ERC721A: transfer to the zero address");
1125 
1126     _beforeTokenTransfers(from, to, tokenId, 1);
1127 
1128     // Clear approvals from the previous owner
1129     _approve(address(0), tokenId, prevOwnership.addr);
1130 
1131     _addressData[from].balance -= 1;
1132     _addressData[to].balance += 1;
1133     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1134 
1135     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1136     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1137     uint256 nextTokenId = tokenId + 1;
1138     if (_ownerships[nextTokenId].addr == address(0)) {
1139       if (_exists(nextTokenId)) {
1140         _ownerships[nextTokenId] = TokenOwnership(
1141           prevOwnership.addr,
1142           prevOwnership.startTimestamp
1143         );
1144       }
1145     }
1146 
1147     emit Transfer(from, to, tokenId);
1148     _afterTokenTransfers(from, to, tokenId, 1);
1149   }
1150 
1151   /**
1152    * @dev Approve `to` to operate on `tokenId`
1153    *
1154    * Emits a {Approval} event.
1155    */
1156   function _approve(
1157     address to,
1158     uint256 tokenId,
1159     address owner
1160   ) private {
1161     _tokenApprovals[tokenId] = to;
1162     emit Approval(owner, to, tokenId);
1163   }
1164 
1165   uint256 public nextOwnerToExplicitlySet = 0;
1166 
1167   /**
1168    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1169    */
1170   function _setOwnersExplicit(uint256 quantity) internal {
1171     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1172     require(quantity > 0, "quantity must be nonzero");
1173     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1174     if (endIndex > collectionSize - 1) {
1175       endIndex = collectionSize - 1;
1176     }
1177     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1178     require(_exists(endIndex), "not enough minted yet for this cleanup");
1179     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1180       if (_ownerships[i].addr == address(0)) {
1181         TokenOwnership memory ownership = ownershipOf(i);
1182         _ownerships[i] = TokenOwnership(
1183           ownership.addr,
1184           ownership.startTimestamp
1185         );
1186       }
1187     }
1188     nextOwnerToExplicitlySet = endIndex + 1;
1189   }
1190 
1191   /**
1192    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1193    * The call is not executed if the target address is not a contract.
1194    *
1195    * @param from address representing the previous owner of the given token ID
1196    * @param to target address that will receive the tokens
1197    * @param tokenId uint256 ID of the token to be transferred
1198    * @param _data bytes optional data to send along with the call
1199    * @return bool whether the call correctly returned the expected magic value
1200    */
1201   function _checkOnERC721Received(
1202     address from,
1203     address to,
1204     uint256 tokenId,
1205     bytes memory _data
1206   ) private returns (bool) {
1207     if (to.isContract()) {
1208       try
1209         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1210       returns (bytes4 retval) {
1211         return retval == IERC721Receiver(to).onERC721Received.selector;
1212       } catch (bytes memory reason) {
1213         if (reason.length == 0) {
1214           revert("ERC721A: transfer to non ERC721Receiver implementer");
1215         } else {
1216           assembly {
1217             revert(add(32, reason), mload(reason))
1218           }
1219         }
1220       }
1221     } else {
1222       return true;
1223     }
1224   }
1225 
1226   /**
1227    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1228    *
1229    * startTokenId - the first token id to be transferred
1230    * quantity - the amount to be transferred
1231    *
1232    * Calling conditions:
1233    *
1234    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1235    * transferred to `to`.
1236    * - When `from` is zero, `tokenId` will be minted for `to`.
1237    */
1238   function _beforeTokenTransfers(
1239     address from,
1240     address to,
1241     uint256 startTokenId,
1242     uint256 quantity
1243   ) internal virtual {}
1244 
1245   /**
1246    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1247    * minting.
1248    *
1249    * startTokenId - the first token id to be transferred
1250    * quantity - the amount to be transferred
1251    *
1252    * Calling conditions:
1253    *
1254    * - when `from` and `to` are both non-zero.
1255    * - `from` and `to` are never both zero.
1256    */
1257   function _afterTokenTransfers(
1258     address from,
1259     address to,
1260     uint256 startTokenId,
1261     uint256 quantity
1262   ) internal virtual {}
1263 }
1264 // File: @openzeppelin/contracts/access/Ownable.sol
1265 
1266 
1267 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1268 
1269 pragma solidity ^0.8.0;
1270 
1271 
1272 /**
1273  * @dev Contract module which provides a basic access control mechanism, where
1274  * there is an account (an owner) that can be granted exclusive access to
1275  * specific functions.
1276  *
1277  * By default, the owner account will be the one that deploys the contract. This
1278  * can later be changed with {transferOwnership}.
1279  *
1280  * This module is used through inheritance. It will make available the modifier
1281  * `onlyOwner`, which can be applied to your functions to restrict their use to
1282  * the owner.
1283  */
1284 abstract contract Ownable is Context {
1285     address private _owner;
1286 
1287     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1288 
1289     /**
1290      * @dev Initializes the contract setting the deployer as the initial owner.
1291      */
1292     constructor() {
1293         _transferOwnership(_msgSender());
1294     }
1295 
1296     /**
1297      * @dev Returns the address of the current owner.
1298      */
1299     function owner() public view virtual returns (address) {
1300         return _owner;
1301     }
1302 
1303     /**
1304      * @dev Throws if called by any account other than the owner.
1305      */
1306     modifier onlyOwner() {
1307         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1308         _;
1309     }
1310 
1311     /**
1312      * @dev Leaves the contract without owner. It will not be possible to call
1313      * `onlyOwner` functions anymore. Can only be called by the current owner.
1314      *
1315      * NOTE: Renouncing ownership will leave the contract without an owner,
1316      * thereby removing any functionality that is only available to the owner.
1317      */
1318     function renounceOwnership() public virtual onlyOwner {
1319         _transferOwnership(address(0));
1320     }
1321 
1322     /**
1323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1324      * Can only be called by the current owner.
1325      */
1326     function transferOwnership(address newOwner) public virtual onlyOwner {
1327         require(newOwner != address(0), "Ownable: new owner is the zero address");
1328         _transferOwnership(newOwner);
1329     }
1330 
1331     /**
1332      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1333      * Internal function without access restriction.
1334      */
1335     function _transferOwnership(address newOwner) internal virtual {
1336         address oldOwner = _owner;
1337         _owner = newOwner;
1338         emit OwnershipTransferred(oldOwner, newOwner);
1339     }
1340 }
1341 
1342 // File: contracts/WatcherEyesOfLegends.sol
1343 
1344 
1345 
1346 pragma solidity ^0.8.0;
1347 
1348 
1349 
1350 
1351 
1352 contract WatcherEyesOfLegends is Ownable, ERC721A, ReentrancyGuard {
1353     uint256 public tokenCount;
1354     uint256 private mintPrice = 0.006 ether;
1355     uint256 private mintLimit = 100;
1356     uint256 public psMintLimit = 10;
1357     uint256 public freeMintLimit = 3;
1358     uint256 public _totalSupply = 6666;
1359     uint256 public currentSupply= 3333;
1360     bool public wlSaleStart = false;
1361     bool public saleStart = false;
1362     bool public secondWlSaleStart = false;
1363     bool public secondSaleStart = false;
1364     mapping(address => uint256) public psMinted; 
1365     mapping(address => uint256) public freeMinted; 
1366     mapping(address => uint256) public secondPsMinted; 
1367     mapping(address => uint256) public secondFreeMinted; 
1368     mapping(address => bool) public _whiteLists; 
1369 
1370   constructor(
1371   ) ERC721A("WatcherEyesOfLegends", "WEoL", mintLimit, _totalSupply) {
1372      tokenCount = 0;
1373   }
1374 
1375   modifier callerIsUser() {
1376     require(tx.origin == msg.sender, "The caller is another contract");
1377     _;
1378   }
1379   function partnerMint(uint256 quantity, address to) external onlyOwner {
1380     require(
1381         (quantity + tokenCount) <= (_totalSupply), 
1382         "too many already minted before patner mint"
1383     );
1384     require(
1385         (quantity + tokenCount) <= (currentSupply), 
1386         "too many already minted before patner mint"
1387     );
1388     _safeMint(to, quantity);
1389     tokenCount += quantity;
1390   }
1391   function psMint(uint256 quantity) public payable nonReentrant {
1392     require(psMintLimit >= quantity, "limit over");
1393     require(psMintLimit >= psMinted[msg.sender] + quantity, "You have no Mint left");
1394     require(msg.value == mintPrice * quantity, "Value sent is not correct");
1395     require((quantity + tokenCount) <= (currentSupply), "Sorry. No more NFTs");
1396     require(saleStart, "Sale Paused");
1397          
1398     psMinted[msg.sender] += quantity;
1399     _safeMint(msg.sender, quantity);
1400     tokenCount += quantity;
1401   }
1402   function socondPsMint(uint256 quantity) public payable nonReentrant {
1403     require(psMintLimit >= quantity, "limit over");
1404     require(psMintLimit >= secondPsMinted[msg.sender] + quantity, "You have no Mint left");
1405     require(msg.value == mintPrice * quantity, "Value sent is not correct");
1406     require((quantity + tokenCount) <= (currentSupply), "Sorry. No more NFTs");
1407     require(secondSaleStart, "Sale Paused");
1408          
1409     secondPsMinted[msg.sender] += quantity;
1410     _safeMint(msg.sender, quantity);
1411     tokenCount += quantity;
1412   }
1413 
1414   function freeMint(uint256 quantity) public{
1415     require(freeMintLimit >= quantity, "Free mint limit over");
1416     require(freeMintLimit >= freeMinted[msg.sender] + quantity, "You have no Mint left");
1417     require((quantity + tokenCount) <= (currentSupply), "Sorry. No more NFTs");
1418     require(wlSaleStart, "Sale Paused");
1419     require(_whiteLists[msg.sender] , "Your adress is not on the Whitelist.");
1420 
1421          
1422     freeMinted[msg.sender] += quantity;
1423     _safeMint(msg.sender, quantity);
1424     tokenCount += quantity;
1425   }
1426   function secondFreeMint(uint256 quantity) public{
1427     require(freeMintLimit >= quantity, "Free mint limit over");
1428     require(freeMintLimit >= secondFreeMinted[msg.sender] + quantity, "You have no Mint left");
1429     require((quantity + tokenCount) <= (currentSupply), "Sorry. No more NFTs");
1430     require(secondWlSaleStart, "Sale Paused");
1431     require(_whiteLists[msg.sender] , "Your adress is not on the Whitelist.");
1432 
1433     secondFreeMinted[msg.sender] += quantity;
1434     _safeMint(msg.sender, quantity);
1435     tokenCount += quantity;
1436   }
1437 
1438   function withdrawMoney() external onlyOwner nonReentrant {
1439     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1440     require(success, "Transfer failed.");
1441   }
1442 
1443   function withdrawRevenueShare() external onlyOwner {
1444     uint256 sendAmount = address(this).balance;
1445 
1446     address creator = payable(0x1C2457B8959824C6c57A8128b2f88a3C566877f9); 
1447     address engineer = payable(0x7Abb65089055fB2bf5b247c89E3C11F7dB861213); 
1448     address partner = payable(0xc0095c3b4C5021C867Cf39758bfcC803392D471d); 
1449 
1450     bool success;
1451 
1452     (success, ) = creator.call{value: (sendAmount * 300/1000)}("");
1453     require(success, "Failed to withdraw Ether");
1454 
1455     (success, ) = engineer.call{value: (sendAmount * 400/1000)}("");
1456     require(success, "Failed to withdraw Ether");
1457 
1458     (success, ) = partner.call{value: (sendAmount * 300/1000)}("");
1459     require(success, "Failed to withdraw Ether");
1460   }
1461 
1462   function walletOfOwner(address _address) public view returns (uint256[] memory) {
1463     uint256 ownerTokenCount = balanceOf(_address);
1464     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1465       for (uint256 i; i < ownerTokenCount; i++) {
1466         tokenIds[i] = tokenOfOwnerByIndex(_address, i);
1467       }
1468     return tokenIds;
1469   }
1470 
1471   // // metadata URI
1472   string private _baseTokenURI;
1473 
1474   function _baseURI() internal view virtual override returns (string memory) {
1475     return _baseTokenURI;
1476   }
1477 
1478   function setBaseURI(string calldata baseURI) external onlyOwner {
1479     _baseTokenURI = baseURI;
1480   }
1481 
1482   function pushMultiWL(address[] memory list, bool _state) public virtual onlyOwner{
1483     for (uint i = 0; i < list.length; i++) {
1484       _whiteLists[list[i]]= _state;
1485     }
1486   }
1487 
1488   function setCurrentSupply(uint256 newSupply) external onlyOwner {
1489     require(_totalSupply >= newSupply, "totalSupplyover");
1490     currentSupply = newSupply;
1491   }
1492 
1493   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1494     _setOwnersExplicit(quantity);
1495   }
1496 
1497   function switchSale(bool _state) external onlyOwner {
1498       saleStart = _state;
1499   }
1500   function switchWlSale(bool _state) external onlyOwner {
1501       wlSaleStart = _state;
1502   }
1503   function switchSecondSale(bool _state) external onlyOwner {
1504       secondSaleStart = _state;
1505   }
1506   function switchWlSecondSale(bool _state) external onlyOwner {
1507       secondWlSaleStart = _state;
1508   }
1509 
1510   function setPrice(uint256 newPrice) external onlyOwner {
1511       mintPrice = newPrice;
1512  }
1513 
1514   function numberMinted(address owner) public view returns (uint256) {
1515     return _numberMinted(owner);
1516   }
1517 
1518   function getOwnershipData(uint256 tokenId)
1519     external
1520     view
1521     returns (TokenOwnership memory)
1522   {
1523     return ownershipOf(tokenId);
1524   }
1525 }