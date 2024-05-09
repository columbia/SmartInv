1 //SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on `isContract` to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
201      * revert reason using the provided one.
202      *
203      * _Available since v4.3._
204      */
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216 
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @title ERC721 token receiver interface
237  * @dev Interface for any contract that wants to support safeTransfers
238  * from ERC721 asset contracts.
239  */
240 interface IERC721Receiver {
241     /**
242      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
243      * by `operator` from `from`, this function is called.
244      *
245      * It must return its Solidity selector to confirm the token transfer.
246      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
247      *
248      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
249      */
250     function onERC721Received(
251         address operator,
252         address from,
253         uint256 tokenId,
254         bytes calldata data
255     ) external returns (bytes4);
256 }
257 
258 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Interface of the ERC165 standard, as defined in the
267  * https://eips.ethereum.org/EIPS/eip-165[EIP].
268  *
269  * Implementers can declare support of contract interfaces, which can then be
270  * queried by others ({ERC165Checker}).
271  *
272  * For an implementation, see {ERC165}.
273  */
274 interface IERC165 {
275     /**
276      * @dev Returns true if this contract implements the interface defined by
277      * `interfaceId`. See the corresponding
278      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
279      * to learn more about how these ids are created.
280      *
281      * This function call must use less than 30 000 gas.
282      */
283     function supportsInterface(bytes4 interfaceId) external view returns (bool);
284 }
285 
286 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 
294 /**
295  * @dev Implementation of the {IERC165} interface.
296  *
297  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
298  * for the additional interface id that will be supported. For example:
299  *
300  * ```solidity
301  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
302  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
303  * }
304  * ```
305  *
306  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
307  */
308 abstract contract ERC165 is IERC165 {
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return interfaceId == type(IERC165).interfaceId;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
318 
319 
320 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 
325 /**
326  * @dev Required interface of an ERC721 compliant contract.
327  */
328 interface IERC721 is IERC165 {
329     /**
330      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
333 
334     /**
335      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
336      */
337     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
338 
339     /**
340      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
341      */
342     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
343 
344     /**
345      * @dev Returns the number of tokens in ``owner``'s account.
346      */
347     function balanceOf(address owner) external view returns (uint256 balance);
348 
349     /**
350      * @dev Returns the owner of the `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function ownerOf(uint256 tokenId) external view returns (address owner);
357 
358     /**
359      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
360      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `tokenId` token must exist and be owned by `from`.
367      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
368      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
369      *
370      * Emits a {Transfer} event.
371      */
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId
376     ) external;
377 
378     /**
379      * @dev Transfers `tokenId` token from `from` to `to`.
380      *
381      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must be owned by `from`.
388      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) external;
397 
398     /**
399      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
400      * The approval is cleared when the token is transferred.
401      *
402      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
403      *
404      * Requirements:
405      *
406      * - The caller must own the token or be an approved operator.
407      * - `tokenId` must exist.
408      *
409      * Emits an {Approval} event.
410      */
411     function approve(address to, uint256 tokenId) external;
412 
413     /**
414      * @dev Returns the account approved for `tokenId` token.
415      *
416      * Requirements:
417      *
418      * - `tokenId` must exist.
419      */
420     function getApproved(uint256 tokenId) external view returns (address operator);
421 
422     /**
423      * @dev Approve or remove `operator` as an operator for the caller.
424      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
425      *
426      * Requirements:
427      *
428      * - The `operator` cannot be the caller.
429      *
430      * Emits an {ApprovalForAll} event.
431      */
432     function setApprovalForAll(address operator, bool _approved) external;
433 
434     /**
435      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
436      *
437      * See {setApprovalForAll}
438      */
439     function isApprovedForAll(address owner, address operator) external view returns (bool);
440 
441     /**
442      * @dev Safely transfers `tokenId` token from `from` to `to`.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `tokenId` token must exist and be owned by `from`.
449      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
450      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
451      *
452      * Emits a {Transfer} event.
453      */
454     function safeTransferFrom(
455         address from,
456         address to,
457         uint256 tokenId,
458         bytes calldata data
459     ) external;
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
472  * @dev See https://eips.ethereum.org/EIPS/eip-721
473  */
474 interface IERC721Metadata is IERC721 {
475     /**
476      * @dev Returns the token collection name.
477      */
478     function name() external view returns (string memory);
479 
480     /**
481      * @dev Returns the token collection symbol.
482      */
483     function symbol() external view returns (string memory);
484 
485     /**
486      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
487      */
488     function tokenURI(uint256 tokenId) external view returns (string memory);
489 }
490 
491 // File: @openzeppelin/contracts/utils/math/Math.sol
492 
493 
494 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev Standard math utilities missing in the Solidity language.
500  */
501 library Math {
502     enum Rounding {
503         Down, // Toward negative infinity
504         Up, // Toward infinity
505         Zero // Toward zero
506     }
507 
508     /**
509      * @dev Returns the largest of two numbers.
510      */
511     function max(uint256 a, uint256 b) internal pure returns (uint256) {
512         return a >= b ? a : b;
513     }
514 
515     /**
516      * @dev Returns the smallest of two numbers.
517      */
518     function min(uint256 a, uint256 b) internal pure returns (uint256) {
519         return a < b ? a : b;
520     }
521 
522     /**
523      * @dev Returns the average of two numbers. The result is rounded towards
524      * zero.
525      */
526     function average(uint256 a, uint256 b) internal pure returns (uint256) {
527         // (a + b) / 2 can overflow.
528         return (a & b) + (a ^ b) / 2;
529     }
530 
531     /**
532      * @dev Returns the ceiling of the division of two numbers.
533      *
534      * This differs from standard division with `/` in that it rounds up instead
535      * of rounding down.
536      */
537     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
538         // (a + b - 1) / b can overflow on addition, so we distribute.
539         return a == 0 ? 0 : (a - 1) / b + 1;
540     }
541 
542     /**
543      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
544      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
545      * with further edits by Uniswap Labs also under MIT license.
546      */
547     function mulDiv(
548         uint256 x,
549         uint256 y,
550         uint256 denominator
551     ) internal pure returns (uint256 result) {
552         unchecked {
553             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
554             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
555             // variables such that product = prod1 * 2^256 + prod0.
556             uint256 prod0; // Least significant 256 bits of the product
557             uint256 prod1; // Most significant 256 bits of the product
558             assembly {
559                 let mm := mulmod(x, y, not(0))
560                 prod0 := mul(x, y)
561                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
562             }
563 
564             // Handle non-overflow cases, 256 by 256 division.
565             if (prod1 == 0) {
566                 return prod0 / denominator;
567             }
568 
569             // Make sure the result is less than 2^256. Also prevents denominator == 0.
570             require(denominator > prod1);
571 
572             ///////////////////////////////////////////////
573             // 512 by 256 division.
574             ///////////////////////////////////////////////
575 
576             // Make division exact by subtracting the remainder from [prod1 prod0].
577             uint256 remainder;
578             assembly {
579                 // Compute remainder using mulmod.
580                 remainder := mulmod(x, y, denominator)
581 
582                 // Subtract 256 bit number from 512 bit number.
583                 prod1 := sub(prod1, gt(remainder, prod0))
584                 prod0 := sub(prod0, remainder)
585             }
586 
587             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
588             // See https://cs.stackexchange.com/q/138556/92363.
589 
590             // Does not overflow because the denominator cannot be zero at this stage in the function.
591             uint256 twos = denominator & (~denominator + 1);
592             assembly {
593                 // Divide denominator by twos.
594                 denominator := div(denominator, twos)
595 
596                 // Divide [prod1 prod0] by twos.
597                 prod0 := div(prod0, twos)
598 
599                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
600                 twos := add(div(sub(0, twos), twos), 1)
601             }
602 
603             // Shift in bits from prod1 into prod0.
604             prod0 |= prod1 * twos;
605 
606             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
607             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
608             // four bits. That is, denominator * inv = 1 mod 2^4.
609             uint256 inverse = (3 * denominator) ^ 2;
610 
611             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
612             // in modular arithmetic, doubling the correct bits in each step.
613             inverse *= 2 - denominator * inverse; // inverse mod 2^8
614             inverse *= 2 - denominator * inverse; // inverse mod 2^16
615             inverse *= 2 - denominator * inverse; // inverse mod 2^32
616             inverse *= 2 - denominator * inverse; // inverse mod 2^64
617             inverse *= 2 - denominator * inverse; // inverse mod 2^128
618             inverse *= 2 - denominator * inverse; // inverse mod 2^256
619 
620             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
621             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
622             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
623             // is no longer required.
624             result = prod0 * inverse;
625             return result;
626         }
627     }
628 
629     /**
630      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
631      */
632     function mulDiv(
633         uint256 x,
634         uint256 y,
635         uint256 denominator,
636         Rounding rounding
637     ) internal pure returns (uint256) {
638         uint256 result = mulDiv(x, y, denominator);
639         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
640             result += 1;
641         }
642         return result;
643     }
644 
645     /**
646      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
647      *
648      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
649      */
650     function sqrt(uint256 a) internal pure returns (uint256) {
651         if (a == 0) {
652             return 0;
653         }
654 
655         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
656         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
657         // `msb(a) <= a < 2*msb(a)`.
658         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
659         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
660         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
661         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
662         uint256 result = 1;
663         uint256 x = a;
664         if (x >> 128 > 0) {
665             x >>= 128;
666             result <<= 64;
667         }
668         if (x >> 64 > 0) {
669             x >>= 64;
670             result <<= 32;
671         }
672         if (x >> 32 > 0) {
673             x >>= 32;
674             result <<= 16;
675         }
676         if (x >> 16 > 0) {
677             x >>= 16;
678             result <<= 8;
679         }
680         if (x >> 8 > 0) {
681             x >>= 8;
682             result <<= 4;
683         }
684         if (x >> 4 > 0) {
685             x >>= 4;
686             result <<= 2;
687         }
688         if (x >> 2 > 0) {
689             result <<= 1;
690         }
691 
692         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
693         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
694         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
695         // into the expected uint128 result.
696         unchecked {
697             result = (result + a / result) >> 1;
698             result = (result + a / result) >> 1;
699             result = (result + a / result) >> 1;
700             result = (result + a / result) >> 1;
701             result = (result + a / result) >> 1;
702             result = (result + a / result) >> 1;
703             result = (result + a / result) >> 1;
704             return min(result, a / result);
705         }
706     }
707 
708     /**
709      * @notice Calculates sqrt(a), following the selected rounding direction.
710      */
711     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
712         uint256 result = sqrt(a);
713         if (rounding == Rounding.Up && result * result < a) {
714             result += 1;
715         }
716         return result;
717     }
718 }
719 
720 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
721 
722 
723 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 /**
728  * @dev These functions deal with verification of Merkle Tree proofs.
729  *
730  * The proofs can be generated using the JavaScript library
731  * https://github.com/miguelmota/merkletreejs[merkletreejs].
732  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
733  *
734  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
735  *
736  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
737  * hashing, or use a hash function other than keccak256 for hashing leaves.
738  * This is because the concatenation of a sorted pair of internal nodes in
739  * the merkle tree could be reinterpreted as a leaf value.
740  */
741 library MerkleProof {
742     /**
743      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
744      * defined by `root`. For this, a `proof` must be provided, containing
745      * sibling hashes on the branch from the leaf to the root of the tree. Each
746      * pair of leaves and each pair of pre-images are assumed to be sorted.
747      */
748     function verify(
749         bytes32[] memory proof,
750         bytes32 root,
751         bytes32 leaf
752     ) internal pure returns (bool) {
753         return processProof(proof, leaf) == root;
754     }
755 
756     /**
757      * @dev Calldata version of {verify}
758      *
759      * _Available since v4.7._
760      */
761     function verifyCalldata(
762         bytes32[] calldata proof,
763         bytes32 root,
764         bytes32 leaf
765     ) internal pure returns (bool) {
766         return processProofCalldata(proof, leaf) == root;
767     }
768 
769     /**
770      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
771      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
772      * hash matches the root of the tree. When processing the proof, the pairs
773      * of leafs & pre-images are assumed to be sorted.
774      *
775      * _Available since v4.4._
776      */
777     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
778         bytes32 computedHash = leaf;
779         for (uint256 i = 0; i < proof.length; i++) {
780             computedHash = _hashPair(computedHash, proof[i]);
781         }
782         return computedHash;
783     }
784 
785     /**
786      * @dev Calldata version of {processProof}
787      *
788      * _Available since v4.7._
789      */
790     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
791         bytes32 computedHash = leaf;
792         for (uint256 i = 0; i < proof.length; i++) {
793             computedHash = _hashPair(computedHash, proof[i]);
794         }
795         return computedHash;
796     }
797 
798     /**
799      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
800      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
801      *
802      * _Available since v4.7._
803      */
804     function multiProofVerify(
805         bytes32[] memory proof,
806         bool[] memory proofFlags,
807         bytes32 root,
808         bytes32[] memory leaves
809     ) internal pure returns (bool) {
810         return processMultiProof(proof, proofFlags, leaves) == root;
811     }
812 
813     /**
814      * @dev Calldata version of {multiProofVerify}
815      *
816      * _Available since v4.7._
817      */
818     function multiProofVerifyCalldata(
819         bytes32[] calldata proof,
820         bool[] calldata proofFlags,
821         bytes32 root,
822         bytes32[] memory leaves
823     ) internal pure returns (bool) {
824         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
825     }
826 
827     /**
828      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
829      * consuming from one or the other at each step according to the instructions given by
830      * `proofFlags`.
831      *
832      * _Available since v4.7._
833      */
834     function processMultiProof(
835         bytes32[] memory proof,
836         bool[] memory proofFlags,
837         bytes32[] memory leaves
838     ) internal pure returns (bytes32 merkleRoot) {
839         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
840         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
841         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
842         // the merkle tree.
843         uint256 leavesLen = leaves.length;
844         uint256 totalHashes = proofFlags.length;
845 
846         // Check proof validity.
847         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
848 
849         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
850         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
851         bytes32[] memory hashes = new bytes32[](totalHashes);
852         uint256 leafPos = 0;
853         uint256 hashPos = 0;
854         uint256 proofPos = 0;
855         // At each step, we compute the next hash using two values:
856         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
857         //   get the next hash.
858         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
859         //   `proof` array.
860         for (uint256 i = 0; i < totalHashes; i++) {
861             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
862             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
863             hashes[i] = _hashPair(a, b);
864         }
865 
866         if (totalHashes > 0) {
867             return hashes[totalHashes - 1];
868         } else if (leavesLen > 0) {
869             return leaves[0];
870         } else {
871             return proof[0];
872         }
873     }
874 
875     /**
876      * @dev Calldata version of {processMultiProof}
877      *
878      * _Available since v4.7._
879      */
880     function processMultiProofCalldata(
881         bytes32[] calldata proof,
882         bool[] calldata proofFlags,
883         bytes32[] memory leaves
884     ) internal pure returns (bytes32 merkleRoot) {
885         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
886         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
887         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
888         // the merkle tree.
889         uint256 leavesLen = leaves.length;
890         uint256 totalHashes = proofFlags.length;
891 
892         // Check proof validity.
893         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
894 
895         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
896         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
897         bytes32[] memory hashes = new bytes32[](totalHashes);
898         uint256 leafPos = 0;
899         uint256 hashPos = 0;
900         uint256 proofPos = 0;
901         // At each step, we compute the next hash using two values:
902         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
903         //   get the next hash.
904         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
905         //   `proof` array.
906         for (uint256 i = 0; i < totalHashes; i++) {
907             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
908             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
909             hashes[i] = _hashPair(a, b);
910         }
911 
912         if (totalHashes > 0) {
913             return hashes[totalHashes - 1];
914         } else if (leavesLen > 0) {
915             return leaves[0];
916         } else {
917             return proof[0];
918         }
919     }
920 
921     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
922         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
923     }
924 
925     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
926         /// @solidity memory-safe-assembly
927         assembly {
928             mstore(0x00, a)
929             mstore(0x20, b)
930             value := keccak256(0x00, 0x40)
931         }
932     }
933 }
934 
935 // File: @openzeppelin/contracts/utils/Strings.sol
936 
937 
938 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 /**
943  * @dev String operations.
944  */
945 library Strings {
946     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
947 
948     /**
949      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
950      */
951     function toString(uint256 value) internal pure returns (string memory) {
952         // Inspired by OraclizeAPI's implementation - MIT licence
953         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
954 
955         if (value == 0) {
956             return "0";
957         }
958         uint256 temp = value;
959         uint256 digits;
960         while (temp != 0) {
961             digits++;
962             temp /= 10;
963         }
964         bytes memory buffer = new bytes(digits);
965         while (value != 0) {
966             digits -= 1;
967             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
968             value /= 10;
969         }
970         return string(buffer);
971     }
972 
973     /**
974      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
975      */
976     function toHexString(uint256 value) internal pure returns (string memory) {
977         if (value == 0) {
978             return "0x00";
979         }
980         uint256 temp = value;
981         uint256 length = 0;
982         while (temp != 0) {
983             length++;
984             temp >>= 8;
985         }
986         return toHexString(value, length);
987     }
988 
989     /**
990      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
991      */
992     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
993         bytes memory buffer = new bytes(2 * length + 2);
994         buffer[0] = "0";
995         buffer[1] = "x";
996         for (uint256 i = 2 * length + 1; i > 1; --i) {
997             buffer[i] = _HEX_SYMBOLS[value & 0xf];
998             value >>= 4;
999         }
1000         require(value == 0, "Strings: hex length insufficient");
1001         return string(buffer);
1002     }
1003 }
1004 
1005 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1006 
1007 
1008 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 /**
1013  * @dev Contract module that helps prevent reentrant calls to a function.
1014  *
1015  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1016  * available, which can be applied to functions to make sure there are no nested
1017  * (reentrant) calls to them.
1018  *
1019  * Note that because there is a single `nonReentrant` guard, functions marked as
1020  * `nonReentrant` may not call one another. This can be worked around by making
1021  * those functions `private`, and then adding `external` `nonReentrant` entry
1022  * points to them.
1023  *
1024  * TIP: If you would like to learn more about reentrancy and alternative ways
1025  * to protect against it, check out our blog post
1026  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1027  */
1028 abstract contract ReentrancyGuard {
1029     // Booleans are more expensive than uint256 or any type that takes up a full
1030     // word because each write operation emits an extra SLOAD to first read the
1031     // slot's contents, replace the bits taken up by the boolean, and then write
1032     // back. This is the compiler's defense against contract upgrades and
1033     // pointer aliasing, and it cannot be disabled.
1034 
1035     // The values being non-zero value makes deployment a bit more expensive,
1036     // but in exchange the refund on every call to nonReentrant will be lower in
1037     // amount. Since refunds are capped to a percentage of the total
1038     // transaction's gas, it is best to keep them low in cases like this one, to
1039     // increase the likelihood of the full refund coming into effect.
1040     uint256 private constant _NOT_ENTERED = 1;
1041     uint256 private constant _ENTERED = 2;
1042 
1043     uint256 private _status;
1044 
1045     constructor() {
1046         _status = _NOT_ENTERED;
1047     }
1048 
1049     /**
1050      * @dev Prevents a contract from calling itself, directly or indirectly.
1051      * Calling a `nonReentrant` function from another `nonReentrant`
1052      * function is not supported. It is possible to prevent this from happening
1053      * by making the `nonReentrant` function external, and making it call a
1054      * `private` function that does the actual work.
1055      */
1056     modifier nonReentrant() {
1057         // On the first call to nonReentrant, _notEntered will be true
1058         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1059 
1060         // Any calls to nonReentrant after this point will fail
1061         _status = _ENTERED;
1062 
1063         _;
1064 
1065         // By storing the original value once again, a refund is triggered (see
1066         // https://eips.ethereum.org/EIPS/eip-2200)
1067         _status = _NOT_ENTERED;
1068     }
1069 }
1070 
1071 // File: @openzeppelin/contracts/utils/Context.sol
1072 
1073 
1074 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1075 
1076 pragma solidity ^0.8.0;
1077 
1078 /**
1079  * @dev Provides information about the current execution context, including the
1080  * sender of the transaction and its data. While these are generally available
1081  * via msg.sender and msg.data, they should not be accessed in such a direct
1082  * manner, since when dealing with meta-transactions the account sending and
1083  * paying for execution may not be the actual sender (as far as an application
1084  * is concerned).
1085  *
1086  * This contract is only required for intermediate, library-like contracts.
1087  */
1088 abstract contract Context {
1089     function _msgSender() internal view virtual returns (address) {
1090         return msg.sender;
1091     }
1092 
1093     function _msgData() internal view virtual returns (bytes calldata) {
1094         return msg.data;
1095     }
1096 }
1097 
1098 // File: contracts/ERC721A.sol
1099 
1100 
1101 // Creator: Chiru Labs
1102 
1103 pragma solidity ^0.8.4;
1104 
1105 
1106 
1107 
1108 
1109 
1110 
1111 
1112 error ApprovalCallerNotOwnerNorApproved();
1113 error ApprovalQueryForNonexistentToken();
1114 error ApproveToCaller();
1115 error ApprovalToCurrentOwner();
1116 error BalanceQueryForZeroAddress();
1117 error MintToZeroAddress();
1118 error MintZeroQuantity();
1119 error OwnerQueryForNonexistentToken();
1120 error TransferCallerNotOwnerNorApproved();
1121 error TransferFromIncorrectOwner();
1122 error TransferToNonERC721ReceiverImplementer();
1123 error TransferToZeroAddress();
1124 error URIQueryForNonexistentToken();
1125 
1126 /**
1127  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1128  * the Metadata extension. Built to optimize for lower gas during batch mints.
1129  *
1130  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1131  *
1132  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1133  *
1134  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1135  */
1136 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1137     using Address for address;
1138     using Strings for uint256;
1139 
1140     // Compiler will pack this into a single 256bit word.
1141     struct TokenOwnership {
1142         // The address of the owner.
1143         address addr;
1144         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1145         uint64 startTimestamp;
1146         // Whether the token has been burned.
1147         bool burned;
1148     }
1149 
1150     // Compiler will pack this into a single 256bit word.
1151     struct AddressData {
1152         // Realistically, 2**64-1 is more than enough.
1153         uint64 balance;
1154         // Keeps track of mint count with minimal overhead for tokenomics.
1155         uint64 numberMinted;
1156         // Keeps track of burn count with minimal overhead for tokenomics.
1157         uint64 numberBurned;
1158         // For miscellaneous variable(s) pertaining to the address
1159         // (e.g. number of whitelist mint slots used).
1160         // If there are multiple variables, please pack them into a uint64.
1161         uint64 aux;
1162     }
1163 
1164     // The tokenId of the next token to be minted.
1165     uint256 internal _currentIndex;
1166 
1167     // The number of tokens burned.
1168     uint256 internal _burnCounter;
1169 
1170     // Token name
1171     string private _name;
1172 
1173     // Token symbol
1174     string private _symbol;
1175 
1176     // Mapping from token ID to ownership details
1177     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1178     mapping(uint256 => TokenOwnership) internal _ownerships;
1179 
1180     // Mapping owner address to address data
1181     mapping(address => AddressData) private _addressData;
1182 
1183     // Mapping from token ID to approved address
1184     mapping(uint256 => address) private _tokenApprovals;
1185 
1186     // Mapping from owner to operator approvals
1187     mapping(address => mapping(address => bool)) private _operatorApprovals;
1188 
1189     constructor(string memory name_, string memory symbol_) {
1190         _name = name_;
1191         _symbol = symbol_;
1192         _currentIndex = _startTokenId();
1193     }
1194 
1195     /**
1196      * To change the starting tokenId, please override this function.
1197      */
1198     function _startTokenId() internal view virtual returns (uint256) {
1199         return 0;
1200     }
1201 
1202     /**
1203      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1204      */
1205     function totalSupply() public view returns (uint256) {
1206         // Counter underflow is impossible as _burnCounter cannot be incremented
1207         // more than _currentIndex - _startTokenId() times
1208         unchecked {
1209             return _currentIndex - _burnCounter - _startTokenId();
1210         }
1211     }
1212 
1213     /**
1214      * Returns the total amount of tokens minted in the contract.
1215      */
1216     function _totalMinted() internal view returns (uint256) {
1217         // Counter underflow is impossible as _currentIndex does not decrement,
1218         // and it is initialized to _startTokenId()
1219         unchecked {
1220             return _currentIndex - _startTokenId();
1221         }
1222     }
1223 
1224     /**
1225      * @dev See {IERC165-supportsInterface}.
1226      */
1227     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1228         return
1229             interfaceId == type(IERC721).interfaceId ||
1230             interfaceId == type(IERC721Metadata).interfaceId ||
1231             super.supportsInterface(interfaceId);
1232     }
1233 
1234     /**
1235      * @dev See {IERC721-balanceOf}.
1236      */
1237     function balanceOf(address owner) public view override returns (uint256) {
1238         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1239         return uint256(_addressData[owner].balance);
1240     }
1241 
1242     /**
1243      * Returns the number of tokens minted by `owner`.
1244      */
1245     function _numberMinted(address owner) internal view returns (uint256) {
1246         return uint256(_addressData[owner].numberMinted);
1247     }
1248 
1249     /**
1250      * Returns the number of tokens burned by or on behalf of `owner`.
1251      */
1252     function _numberBurned(address owner) internal view returns (uint256) {
1253         return uint256(_addressData[owner].numberBurned);
1254     }
1255 
1256     /**
1257      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1258      */
1259     function _getAux(address owner) internal view returns (uint64) {
1260         return _addressData[owner].aux;
1261     }
1262 
1263     /**
1264      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1265      * If there are multiple variables, please pack them into a uint64.
1266      */
1267     function _setAux(address owner, uint64 aux) internal {
1268         _addressData[owner].aux = aux;
1269     }
1270 
1271     /**
1272      * Gas spent here starts off proportional to the maximum mint batch size.
1273      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1274      */
1275     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1276         uint256 curr = tokenId;
1277 
1278         unchecked {
1279             if (_startTokenId() <= curr && curr < _currentIndex) {
1280                 TokenOwnership memory ownership = _ownerships[curr];
1281                 if (!ownership.burned) {
1282                     if (ownership.addr != address(0)) {
1283                         return ownership;
1284                     }
1285                     // Invariant:
1286                     // There will always be an ownership that has an address and is not burned
1287                     // before an ownership that does not have an address and is not burned.
1288                     // Hence, curr will not underflow.
1289                     while (true) {
1290                         curr--;
1291                         ownership = _ownerships[curr];
1292                         if (ownership.addr != address(0)) {
1293                             return ownership;
1294                         }
1295                     }
1296                 }
1297             }
1298         }
1299         revert OwnerQueryForNonexistentToken();
1300     }
1301 
1302     /**
1303      * @dev See {IERC721-ownerOf}.
1304      */
1305     function ownerOf(uint256 tokenId) public view override returns (address) {
1306         return _ownershipOf(tokenId).addr;
1307     }
1308 
1309     /**
1310      * @dev See {IERC721Metadata-name}.
1311      */
1312     function name() public view virtual override returns (string memory) {
1313         return _name;
1314     }
1315 
1316     /**
1317      * @dev See {IERC721Metadata-symbol}.
1318      */
1319     function symbol() public view virtual override returns (string memory) {
1320         return _symbol;
1321     }
1322 
1323     /**
1324      * @dev See {IERC721Metadata-tokenURI}.
1325      */
1326     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1327         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1328 
1329         string memory baseURI = _baseURI();
1330         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1331     }
1332 
1333     /**
1334      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1335      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1336      * by default, can be overriden in child contracts.
1337      */
1338     function _baseURI() internal view virtual returns (string memory) {
1339         return '';
1340     }
1341 
1342     /**
1343      * @dev See {IERC721-approve}.
1344      */
1345     function approve(address to, uint256 tokenId) public override {
1346         address owner = ERC721A.ownerOf(tokenId);
1347         if (to == owner) revert ApprovalToCurrentOwner();
1348 
1349         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1350             revert ApprovalCallerNotOwnerNorApproved();
1351         }
1352 
1353         _approve(to, tokenId, owner);
1354     }
1355 
1356     /**
1357      * @dev See {IERC721-getApproved}.
1358      */
1359     function getApproved(uint256 tokenId) public view override returns (address) {
1360         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1361 
1362         return _tokenApprovals[tokenId];
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-setApprovalForAll}.
1367      */
1368     function setApprovalForAll(address operator, bool approved) public virtual override {
1369         if (operator == _msgSender()) revert ApproveToCaller();
1370 
1371         _operatorApprovals[_msgSender()][operator] = approved;
1372         emit ApprovalForAll(_msgSender(), operator, approved);
1373     }
1374 
1375     /**
1376      * @dev See {IERC721-isApprovedForAll}.
1377      */
1378     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1379         return _operatorApprovals[owner][operator];
1380     }
1381 
1382     /**
1383      * @dev See {IERC721-transferFrom}.
1384      */
1385     function transferFrom(
1386         address from,
1387         address to,
1388         uint256 tokenId
1389     ) public virtual override {
1390         _transfer(from, to, tokenId);
1391     }
1392 
1393     /**
1394      * @dev See {IERC721-safeTransferFrom}.
1395      */
1396     function safeTransferFrom(
1397         address from,
1398         address to,
1399         uint256 tokenId
1400     ) public virtual override {
1401         safeTransferFrom(from, to, tokenId, '');
1402     }
1403 
1404     /**
1405      * @dev See {IERC721-safeTransferFrom}.
1406      */
1407     function safeTransferFrom(
1408         address from,
1409         address to,
1410         uint256 tokenId,
1411         bytes memory _data
1412     ) public virtual override {
1413         _transfer(from, to, tokenId);
1414         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1415             revert TransferToNonERC721ReceiverImplementer();
1416         }
1417     }
1418 
1419     /**
1420      * @dev Returns whether `tokenId` exists.
1421      *
1422      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1423      *
1424      * Tokens start existing when they are minted (`_mint`),
1425      */
1426     function _exists(uint256 tokenId) internal view returns (bool) {
1427         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1428     }
1429 
1430     function _safeMint(address to, uint256 quantity) internal {
1431         _safeMint(to, quantity, '');
1432     }
1433 
1434     /**
1435      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1436      *
1437      * Requirements:
1438      *
1439      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1440      * - `quantity` must be greater than 0.
1441      *
1442      * Emits a {Transfer} event.
1443      */
1444     function _safeMint(
1445         address to,
1446         uint256 quantity,
1447         bytes memory _data
1448     ) internal {
1449         _mint(to, quantity, _data, true);
1450     }
1451 
1452     /**
1453      * @dev Mints `quantity` tokens and transfers them to `to`.
1454      *
1455      * Requirements:
1456      *
1457      * - `to` cannot be the zero address.
1458      * - `quantity` must be greater than 0.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function _mint(
1463         address to,
1464         uint256 quantity,
1465         bytes memory _data,
1466         bool safe
1467     ) internal {
1468         uint256 startTokenId = _currentIndex;
1469         if (to == address(0)) revert MintToZeroAddress();
1470         if (quantity == 0) revert MintZeroQuantity();
1471 
1472         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1473 
1474         // Overflows are incredibly unrealistic.
1475         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1476         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1477         unchecked {
1478             _addressData[to].balance += uint64(quantity);
1479             _addressData[to].numberMinted += uint64(quantity);
1480 
1481             _ownerships[startTokenId].addr = to;
1482             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1483 
1484             uint256 updatedIndex = startTokenId;
1485             uint256 end = updatedIndex + quantity;
1486 
1487             if (safe && to.isContract()) {
1488                 do {
1489                     emit Transfer(address(0), to, updatedIndex);
1490                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1491                         revert TransferToNonERC721ReceiverImplementer();
1492                     }
1493                 } while (updatedIndex != end);
1494                 // Reentrancy protection
1495                 if (_currentIndex != startTokenId) revert();
1496             } else {
1497                 do {
1498                     emit Transfer(address(0), to, updatedIndex++);
1499                 } while (updatedIndex != end);
1500             }
1501             _currentIndex = updatedIndex;
1502         }
1503         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1504     }
1505 
1506     /**
1507      * @dev Transfers `tokenId` from `from` to `to`.
1508      *
1509      * Requirements:
1510      *
1511      * - `to` cannot be the zero address.
1512      * - `tokenId` token must be owned by `from`.
1513      *
1514      * Emits a {Transfer} event.
1515      */
1516     function _transfer(
1517         address from,
1518         address to,
1519         uint256 tokenId
1520     ) private {
1521         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1522 
1523         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1524 
1525         bool isApprovedOrOwner = (_msgSender() == from ||
1526             isApprovedForAll(from, _msgSender()) ||
1527             getApproved(tokenId) == _msgSender());
1528 
1529         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1530         if (to == address(0)) revert TransferToZeroAddress();
1531 
1532         _beforeTokenTransfers(from, to, tokenId, 1);
1533 
1534         // Clear approvals from the previous owner
1535         _approve(address(0), tokenId, from);
1536 
1537         // Underflow of the sender's balance is impossible because we check for
1538         // ownership above and the recipient's balance can't realistically overflow.
1539         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1540         unchecked {
1541             _addressData[from].balance -= 1;
1542             _addressData[to].balance += 1;
1543 
1544             TokenOwnership storage currSlot = _ownerships[tokenId];
1545             currSlot.addr = to;
1546             currSlot.startTimestamp = uint64(block.timestamp);
1547 
1548             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1549             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1550             uint256 nextTokenId = tokenId + 1;
1551             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1552             if (nextSlot.addr == address(0)) {
1553                 // This will suffice for checking _exists(nextTokenId),
1554                 // as a burned slot cannot contain the zero address.
1555                 if (nextTokenId != _currentIndex) {
1556                     nextSlot.addr = from;
1557                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1558                 }
1559             }
1560         }
1561 
1562         emit Transfer(from, to, tokenId);
1563         _afterTokenTransfers(from, to, tokenId, 1);
1564     }
1565 
1566     /**
1567      * @dev This is equivalent to _burn(tokenId, false)
1568      */
1569     function _burn(uint256 tokenId) internal virtual {
1570         _burn(tokenId, false);
1571     }
1572 
1573     /**
1574      * @dev Destroys `tokenId`.
1575      * The approval is cleared when the token is burned.
1576      *
1577      * Requirements:
1578      *
1579      * - `tokenId` must exist.
1580      *
1581      * Emits a {Transfer} event.
1582      */
1583     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1584         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1585 
1586         address from = prevOwnership.addr;
1587 
1588         if (approvalCheck) {
1589             bool isApprovedOrOwner = (_msgSender() == from ||
1590                 isApprovedForAll(from, _msgSender()) ||
1591                 getApproved(tokenId) == _msgSender());
1592 
1593             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1594         }
1595 
1596         _beforeTokenTransfers(from, address(0), tokenId, 1);
1597 
1598         // Clear approvals from the previous owner
1599         _approve(address(0), tokenId, from);
1600 
1601         // Underflow of the sender's balance is impossible because we check for
1602         // ownership above and the recipient's balance can't realistically overflow.
1603         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1604         unchecked {
1605             AddressData storage addressData = _addressData[from];
1606             addressData.balance -= 1;
1607             addressData.numberBurned += 1;
1608 
1609             // Keep track of who burned the token, and the timestamp of burning.
1610             TokenOwnership storage currSlot = _ownerships[tokenId];
1611             currSlot.addr = from;
1612             currSlot.startTimestamp = uint64(block.timestamp);
1613             currSlot.burned = true;
1614 
1615             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1616             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1617             uint256 nextTokenId = tokenId + 1;
1618             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1619             if (nextSlot.addr == address(0)) {
1620                 // This will suffice for checking _exists(nextTokenId),
1621                 // as a burned slot cannot contain the zero address.
1622                 if (nextTokenId != _currentIndex) {
1623                     nextSlot.addr = from;
1624                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1625                 }
1626             }
1627         }
1628 
1629         emit Transfer(from, address(0), tokenId);
1630         _afterTokenTransfers(from, address(0), tokenId, 1);
1631 
1632         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1633         unchecked {
1634             _burnCounter++;
1635         }
1636     }
1637 
1638     /**
1639      * @dev Approve `to` to operate on `tokenId`
1640      *
1641      * Emits a {Approval} event.
1642      */
1643     function _approve(
1644         address to,
1645         uint256 tokenId,
1646         address owner
1647     ) private {
1648         _tokenApprovals[tokenId] = to;
1649         emit Approval(owner, to, tokenId);
1650     }
1651 
1652     /**
1653      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1654      *
1655      * @param from address representing the previous owner of the given token ID
1656      * @param to target address that will receive the tokens
1657      * @param tokenId uint256 ID of the token to be transferred
1658      * @param _data bytes optional data to send along with the call
1659      * @return bool whether the call correctly returned the expected magic value
1660      */
1661     function _checkContractOnERC721Received(
1662         address from,
1663         address to,
1664         uint256 tokenId,
1665         bytes memory _data
1666     ) private returns (bool) {
1667         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1668             return retval == IERC721Receiver(to).onERC721Received.selector;
1669         } catch (bytes memory reason) {
1670             if (reason.length == 0) {
1671                 revert TransferToNonERC721ReceiverImplementer();
1672             } else {
1673                 assembly {
1674                     revert(add(32, reason), mload(reason))
1675                 }
1676             }
1677         }
1678     }
1679 
1680     /**
1681      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1682      * And also called before burning one token.
1683      *
1684      * startTokenId - the first token id to be transferred
1685      * quantity - the amount to be transferred
1686      *
1687      * Calling conditions:
1688      *
1689      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1690      * transferred to `to`.
1691      * - When `from` is zero, `tokenId` will be minted for `to`.
1692      * - When `to` is zero, `tokenId` will be burned by `from`.
1693      * - `from` and `to` are never both zero.
1694      */
1695     function _beforeTokenTransfers(
1696         address from,
1697         address to,
1698         uint256 startTokenId,
1699         uint256 quantity
1700     ) internal virtual {}
1701 
1702     /**
1703      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1704      * minting.
1705      * And also called after one token has been burned.
1706      *
1707      * startTokenId - the first token id to be transferred
1708      * quantity - the amount to be transferred
1709      *
1710      * Calling conditions:
1711      *
1712      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1713      * transferred to `to`.
1714      * - When `from` is zero, `tokenId` has been minted for `to`.
1715      * - When `to` is zero, `tokenId` has been burned by `from`.
1716      * - `from` and `to` are never both zero.
1717      */
1718     function _afterTokenTransfers(
1719         address from,
1720         address to,
1721         uint256 startTokenId,
1722         uint256 quantity
1723     ) internal virtual {}
1724 }
1725 
1726 // File: @openzeppelin/contracts/access/Ownable.sol
1727 
1728 
1729 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1730 
1731 pragma solidity ^0.8.0;
1732 
1733 
1734 /**
1735  * @dev Contract module which provides a basic access control mechanism, where
1736  * there is an account (an owner) that can be granted exclusive access to
1737  * specific functions.
1738  *
1739  * By default, the owner account will be the one that deploys the contract. This
1740  * can later be changed with {transferOwnership}.
1741  *
1742  * This module is used through inheritance. It will make available the modifier
1743  * `onlyOwner`, which can be applied to your functions to restrict their use to
1744  * the owner.
1745  */
1746 abstract contract Ownable is Context {
1747     address private _owner;
1748 
1749     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1750 
1751     /**
1752      * @dev Initializes the contract setting the deployer as the initial owner.
1753      */
1754     constructor() {
1755         _transferOwnership(_msgSender());
1756     }
1757 
1758     /**
1759      * @dev Returns the address of the current owner.
1760      */
1761     function owner() public view virtual returns (address) {
1762         return _owner;
1763     }
1764 
1765     /**
1766      * @dev Throws if called by any account other than the owner.
1767      */
1768     modifier onlyOwner() {
1769         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1770         _;
1771     }
1772 
1773     /**
1774      * @dev Leaves the contract without owner. It will not be possible to call
1775      * `onlyOwner` functions anymore. Can only be called by the current owner.
1776      *
1777      * NOTE: Renouncing ownership will leave the contract without an owner,
1778      * thereby removing any functionality that is only available to the owner.
1779      */
1780     function renounceOwnership() public virtual onlyOwner {
1781         _transferOwnership(address(0));
1782     }
1783 
1784     /**
1785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1786      * Can only be called by the current owner.
1787      */
1788     function transferOwnership(address newOwner) public virtual onlyOwner {
1789         require(newOwner != address(0), "Ownable: new owner is the zero address");
1790         _transferOwnership(newOwner);
1791     }
1792 
1793     /**
1794      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1795      * Internal function without access restriction.
1796      */
1797     function _transferOwnership(address newOwner) internal virtual {
1798         address oldOwner = _owner;
1799         _owner = newOwner;
1800         emit OwnershipTransferred(oldOwner, newOwner);
1801     }
1802 }
1803 
1804 
1805 pragma solidity ^0.8.13;
1806 
1807 
1808 contract BearRiders is ERC721A, Ownable, ReentrancyGuard {
1809     using Strings for uint256;
1810 
1811     enum MintState {
1812 
1813         // PUBLIC: open for all, integer id: 0
1814         PUBLIC,
1815         // WHITELIST: only used for
1816         WHITELIST,
1817         // mint is closed, only admin/owner may mint
1818         CLOSED
1819     }
1820 
1821     uint256 public constant MINT_PER_ACCOUNT = 3;
1822 
1823 
1824     uint256 public immutable MAX_SUPPLY;
1825 
1826     // the state of whether minting is allowed.
1827     MintState private mintingState = MintState.CLOSED;
1828 
1829     string public readMeURI;
1830     // the base uri for the token
1831     string public baseURI;
1832 
1833     string public unrevealedURI;
1834 
1835     constructor(
1836        uint256 maxSupply,
1837        string memory name, string memory symbol
1838     ) ERC721A(name, symbol) {
1839         MAX_SUPPLY = maxSupply;
1840     }
1841 
1842     /**
1843      * To change the starting tokenId, please override this function.
1844      */
1845     function _startTokenId() internal override view virtual returns (uint256) {
1846         return 1;
1847     }
1848 
1849     function setReadMeURI(string calldata _uri) external onlyOwner {
1850         readMeURI = _uri;
1851     }
1852 
1853     function setBaseURI(string calldata _uri) external onlyOwner {
1854         baseURI = _uri;
1855     }
1856 
1857     function setUnrevealedURI(string calldata _uri) external onlyOwner {
1858         unrevealedURI = _uri;
1859     }
1860 
1861     function tokenURI(uint256 tokenId)
1862         public
1863         view
1864         override
1865         returns (string memory)
1866     {
1867         require(
1868             _exists(tokenId),
1869             "ERC721Metadata: URI query for nonexistent token"
1870         );
1871 
1872         return bytes(baseURI).length > 0
1873                         ? string(
1874                             abi.encodePacked(
1875                                 baseURI,
1876                                 tokenId.toString(),
1877                                 ".json"))
1878                         : unrevealedURI;
1879     }
1880 
1881     modifier mintOpen() {
1882         require(mintingState == MintState.PUBLIC, "minting not active.");
1883         _;
1884     }
1885 
1886     function ownerMint(uint16 amount) external onlyOwner {
1887         uint256 totalSupply = totalSupply();
1888         // ensure minting the amount entered would not mint over the max supply
1889         require(
1890             totalSupply + amount < MAX_SUPPLY,
1891             "mint amount would be out of range."
1892         );
1893 
1894           _safeMint(_msgSender(), amount);
1895     }
1896 
1897 
1898     function max(int256 a, int256 b) internal pure returns(int256) {
1899         return a > b ? a : b;
1900     }
1901 
1902     function min(int256 a, int256 b) internal pure returns(int256) {
1903         return a < b ? a : b;
1904     }
1905 
1906 
1907     function mint(uint256 amount) external nonReentrant mintOpen {
1908         require(_totalMinted() < MAX_SUPPLY, "minted out.");
1909         require(_totalMinted() + amount <= MAX_SUPPLY, "mint amount would be out of range.");
1910         require(msg.sender == tx.origin);
1911         require(amount > 0 && amount <= MINT_PER_ACCOUNT, "number too large");
1912 
1913         uint minted = _numberMinted(msg.sender);        
1914 
1915         require(minted < 3, "max amount minted");
1916 
1917         // this will determine how many free mints are left.
1918         // 1000 - 999 = 1
1919         // for example
1920         // int256 remainingFreeMints = max(int256(MAX_FREE_MINTS) - int256(totalSupply()), 0);
1921         // uint256 requiredPrice = 0;
1922 
1923 
1924         // if (remainingFreeMints > 0) {
1925         //     // we have free mint left.
1926         //     // limit the user to 1 per free mint.
1927         //     require(amount == 1, "you may only mint one free NFT at this time.");
1928         //     require(minted < 1, "account already claimed free mint");
1929 
1930 
1931         //     // mark their account as having minted during free mint
1932         //     _setAux(msg.sender, 1); 
1933         // } else {
1934         //     uint256 accountMintLimit = MINT_PER_ACCOUNT;
1935 
1936         //     if (_getAux(msg.sender) > 0) {
1937         //         // being greater than 1, means they minted during the free period. allow them to mint an extra one during paid.
1938         //         accountMintLimit += 1; 
1939         //     }
1940 
1941         //     require(minted < accountMintLimit, "mint limit reached");
1942         //     require(minted + amount <= accountMintLimit, "mint limit reached");
1943 
1944         //     requiredPrice = amount * MINT_PRICE;
1945         // }
1946 
1947         // if (requiredPrice > 0) {
1948         //     require(msg.value >= requiredPrice, "out of free mints, must pay 0.005 ether for each");
1949         // }
1950 
1951         _safeMint(msg.sender, amount);
1952 
1953         // if (msg.value > requiredPrice) {
1954         //     uint256 diff = msg.value - requiredPrice;
1955         //     (bool ok,) = payable(msg.sender).call{value: diff}("");
1956         //     require(ok, "failed to send refund.");
1957         // }
1958     }
1959 
1960 
1961 
1962     // toggles the state of mint
1963     function setMintingState(MintState state) external onlyOwner {
1964         mintingState = state;
1965     }
1966 
1967 
1968 
1969     // Issue a withdrawal to a specific address
1970     function withdraw(address sendTo) external onlyOwner {
1971         (bool ok, ) = payable(sendTo).call{value: address(this).balance}("");
1972         require(ok);
1973     }
1974 }